variable "aws_region" {
  type    = "string"
  default = "us-east-1"
}

variable "aws_az" {
  type    = "string"
  default = "us-east-1e"
}

variable "vpc_dmz_cidr" {
  type = "string"
}

variable "dmz_subnet_cidr" {
  type = "string"
}

variable "vpc_main_cidr" {
  type = "string"
}

variable "main_subnet_cidr" {
  type = "string"
}

variable "app_ec2_instance_type" {
  type = "string"
}

variable "dns_domain" {
  type = "string"
}

variable "dns_zone_id" {
  type = "string"
}
