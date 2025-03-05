terraform {
  backend "s3" {
    bucket = "my-s3-backend-kkarim"
    key    = "mybackend.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "${var.aws_region}"
  # shared_credentials_files = ["/Users/kkarim/.aws/credentials"]
  # profile = "440309162884_AWSAdministratorAccess"
}

# Change the following to pull from S3 instead later
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
      content     = filebase64("../manifests/00-sock-shop-ns.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/01-carts-dep.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/02-carts-svc.yml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/03-carts-db-dep.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/04-carts-db-svc.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/05-catalogue-dep.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/06-catalogue-svc.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/07-catalogue-db-dep.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/08-catalogue-db-svc.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/09-front-end-dep.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/10-front-end-svc.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/11-orders-dep.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/12-orders-svc.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/13-orders-db-dep.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/14-orders-db-svc.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/15-payment-dep.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/16-payment-svc.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/17-queue-master-dep.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/18-queue-master-svc.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/19-rabbitmq-dep.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/20-rabbitmq-svc.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/21-session-db-dep.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/22-session-db-svc.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/23-shipping-dep.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/24-shipping-svc.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/25-user-dep.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/26-user-svc.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/27-user-db-dep.yaml")
    },
    {
      path        = "/tmp/"
      permissions = "0755"
      owner       = "ubuntu:ubuntu"
      encoding    = "b64"
      content     = filebase64("../manifests/28-user-db-svc.yaml")
    }
  ]
})}
  END
}

resource "aws_security_group" "k8s-security-group" {
  name        = "md-k8s-security-group"
  description = "allow all internal traffic, ssh, http from anywhere"
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = "true"
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
  tags = {
    git_commit           = "5b8329293bc707cb0f04417557907818492fa303"
    git_file             = "deploy/kubernetes/terraform/main.tf"
    git_last_modified_at = "2016-12-08 00:39:51"
    git_last_modified_by = "vishal.lal@container-solutions.com"
    git_modifiers        = "vishal/vishal.lal"
    git_org              = "khizarkarim"
    git_repo             = "microservices-demo"
    yor_name             = "k8s-security-group"
    yor_trace            = "98d629c2-6e52-4a7e-9eba-e6b7a6ae5cfc"
  }
}

resource "aws_instance" "ci-sockshop-k8s-master" {
  instance_type   = "${var.master_instance_type}"
  ami             = "${lookup(var.aws_amis, var.aws_region)}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.k8s-security-group.name}"]
  tags = {
    Name                 = "ci-sockshop-k8s-master"
    git_commit           = "87c4648c7288b72536cef504fc23045fbc0cbb2c"
    git_file             = "deploy/kubernetes/terraform/main.tf"
    git_last_modified_at = "2025-03-04 03:14:52"
    git_last_modified_by = "kkarim@paloaltonetworks.com"
    git_modifiers        = "alex.giurgiu/kkarim/vishal/vlal"
    git_org              = "khizarkarim"
    git_repo             = "microservices-demo"
    yor_name             = "ci-sockshop-k8s-master"
    yor_trace            = "15b41310-7a45-4121-9560-b0d870e188da"
  }

  # connection {
  #   user = "ubuntu"
  #   host = self.public_ip
  #   private_key = "${var.private_key_path}"
  # }
  user_data = data.cloudinit_config.mycloudconfig.rendered
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
    Name                 = "ci-sockshop-k8s-node"
    git_commit           = "58c0eab046b0f2d55310d38a798f807483ec3640"
    git_file             = "deploy/kubernetes/terraform/main.tf"
    git_last_modified_at = "2025-03-04 01:10:14"
    git_last_modified_by = "kkarim@paloaltonetworks.com"
    git_modifiers        = "alex.giurgiu/kkarim/vishal"
    git_org              = "khizarkarim"
    git_repo             = "microservices-demo"
    yor_name             = "ci-sockshop-k8s-node"
    yor_trace            = "7099576b-a36d-43c4-bff3-535f905e3610"
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
  depends_on         = ["aws_instance.ci-sockshop-k8s-node"]
  name               = "ci-sockshop-k8s-elb"
  instances          = "${aws_instance.ci-sockshop-k8s-node.*.id}"
  availability_zones = "${data.aws_availability_zones.available.names}"
  security_groups    = ["${aws_security_group.k8s-security-group.id}"]
  listener {
    lb_port           = 80
    instance_port     = 30001
    lb_protocol       = "http"
    instance_protocol = "http"
  }

  listener {
    lb_port           = 9411
    instance_port     = 30002
    lb_protocol       = "http"
    instance_protocol = "http"
  }

  tags = {
    git_commit           = "a67d2940ed148f2b5e31fb05f973ab318b616623"
    git_file             = "deploy/kubernetes/terraform/main.tf"
    git_last_modified_at = "2025-03-03 21:55:23"
    git_last_modified_by = "kkarim@paloaltonetworks.com"
    git_modifiers        = "alex.giurgiu/kkarim/vishal.lal"
    git_org              = "khizarkarim"
    git_repo             = "microservices-demo"
    yor_name             = "ci-sockshop-k8s-elb"
    yor_trace            = "5fb613e3-1b75-4fff-a175-4f2011b28e0b"
  }
}

data "cloudinit_config" "mycloudconfig" {
  base64_encode = false
  gzip          = false
  # part {
  #   content_type = "text/cloud-config"
  #   filename     = "cloud-config.yaml"
  #   content      = local.cloud_config_config
  # }
  part {
    content_type = "text/x-shellscript"
    content      = file("k8s-master.tpl")
    filename     = "k8s-master.bash"
  }
}