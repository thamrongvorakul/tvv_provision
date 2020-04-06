locals {
  customer = "${terraform.workspace}"
}

variable "vpc_cidr" {}

variable "region" {
  default = "ap-southeast-1"
}

variable "availability_zones" {
  default = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "key_name" {
  default = "prod_sg"
}

variable "base_ami" {
  default = "ami-09a4a9ce71ff3f20b"
}

variable "app_instance_type" {
  default = "t3.micro"
}

variable "db_instance_type" {
  default = "t3.micro"
}

variable "db_data_device" {
  default = "/dev/nvme1n1" # override this to /dev/xvdf if use t2/c4 instances
}

variable "db_volume_size" {}


variable "healthcheck_path" {
  default = "/"
}

variable "healthcheck_status" {
  default = "200-399"
}

variable "db_ebs_type" {
  default = "gp2"
}

variable "interval_time" {
  default = 15
}

variable "healthy_threshold_count" {
  default = 2
}

variable "unhealthy_threshold_count" {
  default = 4
}
