variable "aws_access_key" {
  description = "Access key for terraform"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "Secret key for terraform"
  type        = string
  sensitive   = true
}


variable "vpc_cidr_block" {}
variable "private_subnet_cidr_blocks" {}
variable "public_subnet_cidr_blocks" {}


variable "cidr_blocks" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {}
variable "image_name" {}

variable "public_key" {}


