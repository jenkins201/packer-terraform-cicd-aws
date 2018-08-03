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

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.dmz.id}"
}

resource "aws_subnet" "dmz1" {
  vpc_id            = "${aws_vpc.dmz.id}"
  availability_zone = "${var.aws_az}"
  cidr_block        = "${var.dmz_subnet_cidr}"
}

resource "aws_route_table" "dmz" {
  vpc_id = "${aws_vpc.dmz.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
}

resource "aws_route_table_association" "dmz1" {
  subnet_id      = "${aws_subnet.dmz1.id}"
  route_table_id = "${aws_route_table.dmz.id}"
}

resource "aws_security_group" "dmz" {
  name = "dmz"

  vpc_id = "${aws_vpc.dmz.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # default, allow everything out
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
