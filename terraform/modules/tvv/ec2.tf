data "template_file" "user_data_app" {
  template = "${file("${path.module}/templates/user_data_app.yml")}"

  vars {
    customer    = "${var.customer}"
  }
}

data "template_file" "user_data_db" {
  template = "${file("${path.module}/templates/user_data_db.yml")}"

  vars {
    customer    = "${var.customer}"
  }
}

resource "aws_instance" "app" {
  ami                     = "${var.base_ami}"
  instance_type           = "${var.app_instance_type}"
  subnet_id               = "${aws_subnet.a0.id}"
  key_name                = "${var.key_name}"
  user_data               = "${data.template_file.user_data_app.rendered}"
  iam_instance_profile    = "${aws_iam_instance_profile.app.id}"
  disable_api_termination = true

  root_block_device {
    volume_size = 40
    volume_type = "gp2"
  }
  vpc_security_group_ids = [
    "${aws_security_group.common.id}",
    "${aws_security_group.app.id}",
  ]
  tags {
    Name       = "${var.customer}-app"
    Components = "app"
  }
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      "ami",
      "ebs_optimized",
      "root_block_device",
      "tags",
    ]
  }
}

resource "aws_instance" "db" {
  ami                     = "${var.base_ami}"
  instance_type           = "${var.db_instance_type}"
  subnet_id               = "${aws_subnet.a0.id}"
  key_name                = "${var.key_name}"
  user_data               = "${data.template_file.user_data_db.rendered}"
  iam_instance_profile    = "${aws_iam_instance_profile.ecr.id}"
  disable_api_termination = true

  # credit_specification {
  #   cpu_credits = "standard"
  # }

  root_block_device {
    volume_size = 40
    volume_type = "gp2"
  }
  ephemeral_block_device {
    device_name = "/dev/xvdf"
    no_device   = true
  }
  vpc_security_group_ids = [
    "${aws_security_group.common.id}",
    "${aws_security_group.db.id}",
  ]
  tags {
    Name       = "${var.customer}-db"
    Components = "mongodb"
  }
  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      "ami",
      "ebs_optimized",
      "user_data",
      "root_block_device",
      "ephemeral_block_device",
      "tags",
    ]
  }
}


resource "aws_iam_instance_profile" "app" {
  name = "${var.customer}-app"
  role = "${aws_iam_role.app.name}"
}

resource "aws_iam_instance_profile" "ecr" {
  name = "${var.customer}-ecr"
  role = "${aws_iam_role.ecr.name}"
}
