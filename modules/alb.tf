resource "aws_alb" "alb" {
  name            = "${var.name}-${terraform.workspace}-alb"
  security_groups = ["${aws_security_group.alb.id}"]

  subnets = [
    "${aws_subnet.public.*.id}"
  ]

  internal                   = false
  enable_deletion_protection = false
}

resource "aws_alb_target_group" "alb" {
  name        = "${var.name}-${terraform.workspace}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.vpc.id}"
  target_type = "ip"

  health_check {
    interval = 60
    path     = "/health_check"

    //port                = 80  // NOTE: defaultはtraffic-port
    protocol            = "HTTP"
    timeout             = 20
    unhealthy_threshold = 4
    matcher             = 200
  }
}

resource "aws_alb_listener" "alb_443" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.alb_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "alb" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb.arn}"
    type             = "forward"
  }
}
