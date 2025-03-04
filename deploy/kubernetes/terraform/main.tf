terraform {
  backend "s3" {
    bucket = "my-s3-backend-kkarim"
    key = "mybackend.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "${var.aws_region}"
  # shared_credentials_files = ["/Users/kkarim/.aws/credentials"]
  # profile = "440309162884_AWSAdministratorAccess"
}

locals {
  cloud_config_config = <<-END
    #cloud-config
    ${jsonencode({
      write_files = [
        {
          path        = "/tmp/"
          permissions = "0755"
          owner       = "ubuntu:ubuntu"
          encoding    = "b64"
          content     = filebase64("../manifests/*")
        },
      ]
    })}
  END
}

resource "aws_security_group" "k8s-security-group" {
  name        = "md-k8s-security-group"
  description = "allow all internal traffic, ssh, http from anywhere"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = "true"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9411
    to_port     = 9411
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 30001
    to_port     = 30001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 30002
    to_port     = 30002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
   from_port   = 31601
   to_port     = 31601
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ci-sockshop-k8s-master" {
  instance_type   = "${var.master_instance_type}"
  ami             = "${lookup(var.aws_amis, var.aws_region)}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.k8s-security-group.name}"]
  tags = {
    Name = "ci-sockshop-k8s-master"
  }

  # connection {
  #   user = "ubuntu"
  #   host = self.public_ip
  #   private_key = "${var.private_key_path}"
  # }
  # user_data = file("k8s-master.tpl")
  # provisioner "file" {
  #   source = "../manifests"
  #   destination = "/tmp/"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
  #     "sudo echo \"deb http://apt.kubernetes.io/ kubernetes-jammy main\" | sudo tee --append /etc/apt/sources.list.d/kubernetes.list",
  #     "sudo apt-get update",
  #     "sudo apt-get install -y docker.io",
  #     "sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni"
  #   ]
  # }
}

resource "aws_instance" "ci-sockshop-k8s-node" {
  instance_type   = "${var.node_instance_type}"
  count           = "${var.node_count}"
  ami             = "${lookup(var.aws_amis, var.aws_region)}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.k8s-security-group.name}"]
  tags = {
    Name = "ci-sockshop-k8s-node"
  }
  user_data = file("k8s-node.tpl")

  # connection {
  #   user = "ubuntu"
  #   host = self.public_ip
  #   private_key = "${var.private_key_path}"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
  #     "sudo echo \"deb http://apt.kubernetes.io/ kubernetes-jammy main\" | sudo tee --append /etc/apt/sources.list.d/kubernetes.list",
  #     "sudo apt-get update",
  #     "sudo apt-get install -y docker.io",
  #     "sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni",
  #     "sudo sysctl -w vm.max_map_count=262144"
  #   ]
  # }
}

resource "aws_elb" "ci-sockshop-k8s-elb" {
  depends_on = [ "aws_instance.ci-sockshop-k8s-node" ]
  name = "ci-sockshop-k8s-elb"
  instances = "${aws_instance.ci-sockshop-k8s-node.*.id}"
  availability_zones = "${data.aws_availability_zones.available.names}"
  security_groups = ["${aws_security_group.k8s-security-group.id}"] 
  listener {
    lb_port = 80
    instance_port = 30001
    lb_protocol = "http"
    instance_protocol = "http"
  }

  listener {
    lb_port = 9411
    instance_port = 30002
    lb_protocol = "http"
    instance_protocol = "http"
  }

}

data "cloudinit_config" "mycloudconfig" {
  base64_encode = false
  gzip = false
  part {
    content_type = "text/cloud-config"
    filename     = "cloud-config.yaml"
    content      = local.cloud_config_config
  }
  part {
    content_type = "text/x-shellscript"
    content = file("k8s-master.tpl")
    filename = "k8s-master.bash"
  }
}