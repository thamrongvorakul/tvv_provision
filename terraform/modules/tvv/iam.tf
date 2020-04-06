data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "app" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_secret_bucket_name}/${var.customer}/*",
    ]
  }

   statement {
    actions = [
      "s3:HeadObject",
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_secret_bucket_name}/google/EkoApp-Google.json",
    ]
  }
  

  statement {
    actions = [
      "ec2:DescribeTags",
      "sns:ListPlatformApplications",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ec2:CreateTags",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/Customer"
      values   = ["${var.customer}"]
    }
  }
}

resource "aws_iam_policy" "app" {
  name_prefix = "${var.customer}-app"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.app.json}"
  description = "Managed by Terraform"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "app" {
  name               = "${var.customer}-app"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.instance_assume_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "app_ecr_readonly" {
  role       = "${aws_iam_role.app.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "app" {
  role       = "${aws_iam_role.app.name}"
  policy_arn = "${aws_iam_policy.app.arn}"
}

resource "aws_iam_role" "ecr" {
  name               = "${var.customer}-ecr"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.instance_assume_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = "${aws_iam_role.ecr.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
