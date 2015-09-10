### MANDATORY ###
variable "public_hosted_zone_id" {}
variable "public_hosted_zone_name" {}

# group our resources
variable "stream_tag" {
  default = "default"
}

###################################################################
# AWS configuration below
###################################################################
variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
  default = "elastic"
}

### MANDATORY ###
variable "key_path" {
  description = "Path to the private portion of the SSH key specified."
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default = "ap-southeast-2"
}

variable "aws_security_group" {
  description = "Name of security group to use in AWS."
  default = "bastion"
}

variable "amazon_bastion_amis" {
  default = {
    eu-central-1 = "ami-46073a5b"
    ap-southeast-1 = "ami-b49dace6"
    ap-southeast-2 = "ami-e7ee9edd"
    us-west-1 = "ami-7da94839"
  }
}

###################################################################
# Vpc configuration below
###################################################################

### MANDATORY ###
variable "vpc_id" {
  description = "VPC id"
}

###################################################################
# Bastion configuration below
###################################################################
variable "instance_type" {
  default = "t2.micro"
}
