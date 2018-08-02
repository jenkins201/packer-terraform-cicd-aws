provider "aws" {}

variable "vpc_main_cidr" {
  type = "string"
}

variable "vpc_dmz_cidr" {
  type = "string"
}

variable "app_ec2_instance_type" {
  type = "string"
}

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_main_cidr}"
}

output "main_vpc_id" {
  value = "${aws_vpc.main.id}"
}

resource "aws_vpc" "dmz" {
  cidr_block = "${var.vpc_dmz_cidr}"
}

output "dmz_vpc_id" {
  value = "${aws_vpc.dmz.id}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.app_ec2_instance_type}"

  tags {
    Name = "HelloWorld"
  }
}
