terraform {
  backend "s3" {
    bucket = "tvv-terraform-state-an"
    region = "ap-southeast-1"
    key    = "tvv-prod-state.tfstate"
  }
}

provider "aws" {
  region = "${var.region}"
}

provider "aws" {
  region = "ap-southeast-1"
  alias  = "ap-southeast-1"
}

module "tvv" {
  source                    = "../modules/tvv"
  customer                  = "${local.customer}"
  region                    = "${var.region}"
  availability_zones        = "${var.availability_zones}"
  vpc_cidr                  = "${var.vpc_cidr}"
  key_name                  = "${var.key_name}"
  app_instance_type         = "${var.app_instance_type}"
  db_instance_type          = "${var.db_instance_type}"
  db_data_device            = "${var.db_data_device}"
  base_ami                  = "${var.base_ami}"
  s3_secret_bucket_name     = "tvv-env-bucket-an"
  db_ebs_type               = "${var.db_ebs_type}"
  db_volume_size            = "${var.db_volume_size}"
  healthcheck_path          = "${var.healthcheck_path}"
  healthcheck_status        = "${var.healthcheck_status}"
  interval_time             = "${var.interval_time}"
  healthy_threshold_count   = "${var.healthy_threshold_count}"
  unhealthy_threshold_count = "${var.unhealthy_threshold_count}"

  providers {
    aws.ap-southeast-1 = "aws.ap-southeast-1"
  }
}

output "customer" {
  value = "${module.tvv.customer}"
}

output "region" {
  value = "${module.tvv.region}"
}

output "vpc_cidr" {
  value = "${module.tvv.vpc_cidr}"
}

output "db_data_device" {
  value = "${module.tvv.db_data_device}"
}

output "db_hostname" {
  value = "${module.tvv.db_hostname}"
}

output "db_private_ip" {
  value = "${module.tvv.db_private_ip}"
}
