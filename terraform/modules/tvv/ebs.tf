
resource "aws_ebs_volume" "db" {
  availability_zone = "${aws_instance.db.availability_zone}"
  size              = "${var.db_volume_size}"
  type              = "${var.db_ebs_type}"

  tags {
    Name     = "${var.customer}-db"
    Customer = "${var.customer}"
    Type     = "db"
  }

  lifecycle {
    ignore_changes = [
      "snapshot_id",
    ]
  }
}

resource "aws_volume_attachment" "db" {
  device_name  = "/dev/xvdf"
  volume_id    = "${aws_ebs_volume.db.id}"
  instance_id  = "${aws_instance.db.id}"
  force_detach = true
}
