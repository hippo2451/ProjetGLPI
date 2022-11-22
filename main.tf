provider "aws" {
  region     = "us-east-1"
  access_key = "{{access_key}}"
  secret_key = "{{secret_key}}"
 
}

terraform {
  backend "s3" {
    bucket = "backend-terraform-moffo"
    key    = "hippo.tfstate"
    region = "us-east-1"
    access_key = "{{access_key}}"
    secret_key = "{{secret_key}}"
 
  }
}
data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


resource "aws_security_group" "allow_ssh_http_https" {
  name        = "hippo_sg"
  description = "Allow http, https inbound traffic"

  ingress {
    description = "http from vpc"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https from vpc"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "myec2" {
  ami             = data.aws_ami.app_ami.id
  instance_type   = var.instancetype
  key_name        = "devops"
  tags            = var.aws_common_tag
  security_groups = ["${aws_security_group.allow_ssh_http_https.name}"]
  provisioner "local-exec" {
    command = "echo PUBLIC IP: ${aws_instance.myec2.public_ip} ; ID :${aws_instance.myec2.id} ; AZ: ${aws_instance.myec2.availability_zone} >> infos.ec2.txt"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1.12",
      "sudo systemctl start nginx",
    ]
    connection {
        type     = "ssh"
        user     = "ec2-user"
        private_key = file("./devops.pem")
        host     = self.public_ip
      }

  }

}


resource "aws_eip" "lb" {
  instance = aws_instance.myec2.id
  vpc      = true
}
