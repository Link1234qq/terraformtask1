output "autoscaling_group_name" {
  value       = aws_autoscaling_group.this.name
  description = "Name of the Auto Scaling Group"
}

output "launch_template_id" {
  value       = aws_launch_template.this.id
  description = "ID of the launch template used by the ASG"
}

output "iam_role_arn" {
  value       = aws_iam_role.asg.arn
  description = "ARN of the IAM role attached to ASG instances"
}
