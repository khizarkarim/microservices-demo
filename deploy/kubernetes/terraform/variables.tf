variable "aws_amis" {
  description = "The AMI to use for setting up the instances."
  default = {
    "us-east-2" = "ami-0884d2865dbe9de4b"
  }
}

data "aws_availability_zones" "available" {}

variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-2"
}

variable "instance_user" {
  description = "The user account to use on the instances to run the scripts."
  default     = "ubuntu"
}

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
  default     = "aws-keypair"
}

variable "master_instance_type" {
  description = "The instance type to use for the Kubernetes master."
  default     = "m3.large"
}

variable "node_instance_type" {
  description = "The instance type to use for the Kubernetes nodes."
  default     = "m3.large"
}

variable "node_count" {
  description = "The number of nodes in the cluster."
  default     = "3"
}

variable "private_key_path" {
  description = "The private key for connection to the instances as the user. Corresponds to the key_name variable."
  default     = "$SSH_PRIVATE_KEY"
}
