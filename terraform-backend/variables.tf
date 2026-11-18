variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "smart-task"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "ssh_allowed_ip" {
  description = "Public IP allowed to SSH into EC2"
  type        = string
}
