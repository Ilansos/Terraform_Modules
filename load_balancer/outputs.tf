output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.app_lb.dns_name
}

