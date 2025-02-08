resource "aws_lb" "app_lb" {
  name               = var.load_balancer.name
  internal           = var.load_balancer.internal
  load_balancer_type = var.load_balancer.type
  security_groups    = var.load_balancer.security_groups
  subnets            = var.load_balancer.subnets
}

resource "aws_lb_target_group" "app_tg" {
  name     = var.load_balancer.target_group_name
  port     = var.load_balancer.target_group_port
  protocol = var.load_balancer.target_group_protocol
  vpc_id   = var.load_balancer.vpc_id
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = var.load_balancer.http_listener_port
  protocol          = var.load_balancer.http_listener_protocol

  default_action {
    type             = var.load_balancer.http_listener_action
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port = var.load_balancer.https_listener_port
  protocol = var.load_balancer.https_listener_protocol
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.load_balancer.ssl_arn

  default_action {
    type = var.load_balancer.http_listener_action
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "web" {
  for_each = { for idx, id in var.load_balancer.instance_ids : idx => id }
  target_group_arn  = aws_lb_target_group.app_tg.arn
  target_id         = each.value
  port              = var.load_balancer.target_group_port
}