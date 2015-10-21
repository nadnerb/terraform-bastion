provider "aws" {
  region = "${var.aws_region}"
}

##############################################################################
# Bastion Server
##############################################################################
resource "aws_route53_record" "bastion" {
   zone_id = "${var.public_hosted_zone_id}"
   name = "${var.public_hosted_zone_name}"
   type = "A"
   ttl = "300"
   records = ["${ module.bastion_servers_a.public-ips}","${ module.bastion_servers_b.public-ips}"]
}

resource "aws_security_group" "bastion" {
  name = "bastion"
  description = "Allow access from allowed_network via SSH"
  vpc_id = "${var.vpc_id}"

  # SSH
  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${split(",", var.allowed_cidr_blocks)}"]
    self = false
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${split(",", var.internal_cidr_blocks)}"]
  }

  tags = {
    Name = "bastion"
    stream = "${var.stream_tag}"
  }
}

resource "aws_route_table" "bastion" {
  vpc_id = "${var.vpc_id}"

  # peered connections?

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.internet_gateway_id}"
  }

  tags {
    Name = "bastion route table"
    stream = "${var.stream_tag}"
  }
}

resource "aws_subnet" "bastion_a" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${concat(var.aws_region, "a")}"
  cidr_block = "${var.bastion_subnet_cidr_a}"

  tags {
    Name = "bastion subnet a"
    stream = "${var.stream_tag}"
  }
}

resource "aws_subnet" "bastion_b" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${concat(var.aws_region, "b")}"
  cidr_block = "${var.bastion_subnet_cidr_b}"

  tags {
    Name = "bastion subnet b"
    stream = "${var.stream_tag}"
  }
}

resource "aws_route_table_association" "bastion_a" {
  subnet_id = "${aws_subnet.bastion_a.id}"
  route_table_id = "${aws_route_table.bastion.id}"
}

resource "aws_route_table_association" "bastion_b" {
  subnet_id = "${aws_subnet.bastion_b.id}"
  route_table_id = "${aws_route_table.bastion.id}"
}

module "bastion_servers_a" {
  source = "./bastion"

  name = "bastion_server_a"
  stream = "${var.stream_tag}"
  key_path = "${var.key_path}"
  ami = "${lookup(var.amazon_bastion_amis, var.aws_region)}"
  key_name = "${var.key_name}"
  security_groups = "${aws_security_group.bastion.id}"
  subnet_id = "${aws_subnet.bastion_a.id}"
  instance_type = "${var.instance_type}"
}

module "bastion_servers_b" {
  source = "./bastion"

  name = "bastion_server_b"
  stream = "${var.stream_tag}"
  key_path = "${var.key_path}"
  ami = "${lookup(var.amazon_bastion_amis, var.aws_region)}"
  key_name = "${var.key_name}"
  security_groups = "${aws_security_group.bastion.id}"
  subnet_id = "${aws_subnet.bastion_b.id}"
  instance_type = "${var.instance_type}"
}
