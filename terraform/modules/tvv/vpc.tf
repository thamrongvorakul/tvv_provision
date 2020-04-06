resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name     = "${var.customer}"
    Customer = "${var.customer}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name     = "${var.customer}"
    Customer = "${var.customer}"
  }
}

resource "aws_subnet" "a0" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, 2, 0)}"
  map_public_ip_on_launch = true
  availability_zone       = "${element(var.availability_zones, 0)}"

  tags {
    Name     = "${var.customer}"
    Customer = "${var.customer}"
  }
}

resource "aws_subnet" "b0" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, 2, 1)}"
  map_public_ip_on_launch = true
  availability_zone       = "${element(var.availability_zones, 1)}"

  tags {
    Name     = "${var.customer}"
    Customer = "${var.customer}"
  }
}

resource "aws_subnet" "c0" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, 2, 2)}"
  map_public_ip_on_launch = true
  availability_zone       = "${element(var.availability_zones, 2)}"

  tags {
    Name     = "${var.customer}"
    Customer = "${var.customer}"
  }
}

resource "aws_default_route_table" "main" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name     = "${var.customer}"
    Customer = "${var.customer}"
  }

  lifecycle {
    ignore_changes = [
      "route",
      "tags",
    ]
  }
}

resource "aws_route_table_association" "a0" {
  subnet_id      = "${aws_subnet.a0.id}"
  route_table_id = "${aws_default_route_table.main.id}"
}

resource "aws_route_table_association" "b0" {
  subnet_id      = "${aws_subnet.b0.id}"
  route_table_id = "${aws_default_route_table.main.id}"
}

resource "aws_route_table_association" "c0" {
  subnet_id      = "${aws_subnet.c0.id}"
  route_table_id = "${aws_default_route_table.main.id}"
}
