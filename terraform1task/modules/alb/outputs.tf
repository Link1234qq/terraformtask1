output "alb_arn" {
  value       = aws_lb.petclinic_alb.arn
  description = "The ARN of the ALB"
}

output "alb_dns_name" {
  value       = aws_lb.petclinic_alb.dns_name
  description = "The DNS name of the ALB"
}

output "target_group_arn" {
  value       = aws_lb_target_group.petclinic.arn
  description = "The ARN of ALB target group"
}