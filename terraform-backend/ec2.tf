# Find the latest Ubuntu 24.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Register SSH public key in AWS
resource "aws_key_pair" "backend_key" {
  key_name   = "${var.project_name}-backend-key"
  public_key = file("${path.module}/smart-task-backend.pub")
}

# Create EC2 instance
resource "aws_instance" "backend" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  key_name = aws_key_pair.backend_key.key_name

  # Root storage
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  # Install Docker automatically during EC2 startup
  user_data = <<-EOF
    #!/bin/bash
    set -eux

    # Update Ubuntu packages
    apt-get update -y

    # Install required packages
    apt-get install -y ca-certificates curl

    # Create Docker keyring directory
    install -m 0755 -d /etc/apt/keyrings

    # Download Docker GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
      -o /etc/apt/keyrings/docker.asc

    chmod a+r /etc/apt/keyrings/docker.asc

    # Configure Docker repository
    . /etc/os-release

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $${UBUNTU_CODENAME:-$VERSION_CODENAME} stable" \
      > /etc/apt/sources.list.d/docker.list

    # Update package list
    apt-get update -y

    # Install Docker Engine and Compose
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Enable and start Docker
    systemctl enable docker
    systemctl start docker

    # Allow Ubuntu user to access Docker
    usermod -aG docker ubuntu

  EOF

  tags = {
    Name    = "${var.project_name}-backend-server"
    Project = var.project_name
  }
}
