resource "aws_security_group" "common" {
  name   = "${var.customer}-common"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "ICMP"
    cidr_blocks = ["${aws_vpc.main.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Customer = "${var.customer}"
  }

  lifecycle {
    ignore_changes = [
      "ingress",
      "egress",
    ]
  }
}

resource "aws_security_group" "app" {
  name   = "${var.customer}-app"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "TCP"
    security_groups = ["${aws_security_group.alb.id}"]
  }

  ingress {
    # etc
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  tags {
    Customer = "${var.customer}"
  }
}


resource "aws_security_group" "db" {
  name   = "${var.customer}-db"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    # mongodb
    from_port = 27017
    to_port   = 27017
    protocol  = "TCP"

    security_groups = [
      "${aws_security_group.app.id}"
    ]
  }
  tags {
    Customer = "${var.customer}"
  }
}


resource "aws_security_group" "alb" {
  name   = "${var.customer}-alb"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${aws_vpc.main.cidr_block}"]
  }

  tags {
    Customer = "${var.customer}"
  }
}
