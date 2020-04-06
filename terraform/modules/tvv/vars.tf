# public
variable "customer" {}

variable "vpc_cidr" {}
variable "key_name" {}

variable "region" {
  default = "ap-southeast-1"
}

variable "availability_zones" {
  default = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
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

variable "db_volume_size" {
  default = 20
}

variable "s3_secret_bucket_name" {
  default = "tv-env-bucket-an"
}

variable "force_destroy_s3" {
  default     = false
  description = "Delete all objects before destroying bucket. Enable on dev env only"
}


variable "base_ami" {
  default = "ami-09a4a9ce71ff3f20b"
}


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
