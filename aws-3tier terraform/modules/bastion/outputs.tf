output "bastion_security_group_id" {
  description = "Bastion Security Group ID"
  value       = aws_security_group.bastion.id
}

output "bastion_public_ip" {
  description = "Public IP of Bastion Host"
  value       = aws_eip.bastion.public_ip
}