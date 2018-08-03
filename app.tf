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

resource "aws_eip" "app" {
  instance   = "${aws_instance.app.id}"
  vpc        = true
  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_instance" "app" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.app_ec2_instance_type}"
  subnet_id                   = "${aws_subnet.dmz1.id}"
  associate_public_ip_address = "true"
  vpc_security_group_ids      = ["${aws_security_group.dmz.id}"]
  key_name                    = "simonm"
}

resource "aws_route53_record" "app" {
  zone_id = "${var.dns_zone_id}"
  name    = "app.${var.dns_domain}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.app.public_ip}"]
}

output "app_public_ip" {
  value = "${aws_instance.app.public_ip}"
}

output "app_eip_public_ip" {
  value = "${aws_eip.app.public_ip}"
}
