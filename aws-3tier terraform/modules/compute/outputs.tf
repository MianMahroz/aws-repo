output "presentation_alb_dns" {
  description = "DNS Name of Presentation ALB"
  value       = aws_lb.presentation.dns_name
}

output "application_alb_dns" {
  description = "DNS Name of Application ALB"
  value       = aws_lb.application.dns_name
}

output "app_security_group_id" {
  description = "App Tier Security Group ID"
  value       = aws_security_group.app.id
}