provider "aws" {
    region = var.region
    
}

# Custom VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_hostnames = true

    tags = {
      Name = "App_VPC"
    }
}

resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.main.id
    availability_zone = var.az
    map_public_ip_on_launch = true
    cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "route"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route.id
}

resource "aws_security_group" "firewall" {
    vpc_id = aws_vpc.main.id
    description = "App security group"
    name = "App_SG"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port = 7070
        to_port = 7070
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port = 8085
        to_port = 8085
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    } 
}

data "aws_ami" "ubuntu" {
    most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"] # Canonical  
}

resource "aws_instance" "instance" {
    ami                         = data.aws_ami.ubuntu.id
    vpc_security_group_ids      = [aws_security_group.firewall.id]
    instance_type               = var.instance_type
    subnet_id                   = aws_subnet.subnet.id
    key_name                    = var.kp
    user_data                   = file("docker.sh") 

    tags = {
      Name = "App_Instance"
    }
}

# Print Jenkins Server URL
output "App_server_url" {
  value       = aws_instance.instance.public_ip
  description = "App server"
}

