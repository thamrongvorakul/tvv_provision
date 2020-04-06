output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "vpc_cidr" {
  value = "${aws_vpc.main.cidr_block}"
}

output "region" {
  value = "${var.region}"
}

output "customer" {
  value = "${var.customer}"
}

output "s3_secret_bucket_name" {
  value = "${var.s3_secret_bucket_name}"
}

output "db_data_device" {
  value = "${var.db_data_device}"
}

output "db_hostname" {
  value = "${var.customer}-db"
}

output "db_private_ip" {
  value = "${coalesce(join("", aws_instance.db.*.private_ip), join("", aws_instance.db.*.private_ip))}"
}
