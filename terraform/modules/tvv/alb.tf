resource "aws_alb" "app" {
  name         = "${var.customer}-app"
  subnets      = ["${aws_subnet.a0.id}", "${aws_subnet.b0.id}", "${aws_subnet.c0.id}"]
  idle_timeout = 1200

  security_groups = [
    "${aws_security_group.alb.id}",
  ]

  tags {
    Customer = "${var.customer}"
  }
}

resource "aws_alb_target_group" "app" {
  name                 = "${var.customer}-app"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${aws_vpc.main.id}"
  deregistration_delay = 60

  health_check {
    path                = "${var.healthcheck_path}"
    matcher             = "${var.healthcheck_status}"
    interval            = "${var.interval_time}"
    healthy_threshold   = "${var.healthy_threshold_count}"
    unhealthy_threshold = "${var.unhealthy_threshold_count}"
  }
}

resource "aws_alb_target_group" "default" {
  name                 = "${var.customer}-default"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${aws_vpc.main.id}"
  deregistration_delay = 60

  health_check {
    path                = "${var.healthcheck_path}"
    matcher             = "${var.healthcheck_status}"
    interval            = "${var.interval_time}"
    healthy_threshold   = "${var.healthy_threshold_count}"
    unhealthy_threshold = "${var.unhealthy_threshold_count}"
  }
}

resource "aws_alb_listener" "app" {
  load_balancer_arn = "${aws_alb.app.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "default_http" {
  target_group_arn = "${aws_alb_target_group.default.arn}"
  target_id        = "${aws_instance.app.id}"
  port             = 80
}

resource "aws_lb_target_group_attachment" "app_http" {
  target_group_arn = "${aws_alb_target_group.app.arn}"
  target_id        = "${aws_instance.app.id}"
  port             = 80
}
