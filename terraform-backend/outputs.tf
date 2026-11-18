output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.backend.id
}

output "ec2_instance_arn" {
  description = "EC2 Instance ARN"
  value       = aws_instance.backend.arn
}

output "ec2_public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.backend.public_ip
}

output "ec2_public_dns" {
  description = "EC2 Public DNS"
  value       = aws_instance.backend.public_dns
}

output "security_group_id" {
  description = "Backend Security Group ID"
  value       = aws_security_group.backend_sg.id
}
