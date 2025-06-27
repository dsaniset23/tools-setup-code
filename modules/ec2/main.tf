terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

resource "aws_security_group" "sg" {
  name        = "${var.tool_name}-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"

  ingress {
    from_port        = var.app_port
    to_port          = var.app_port
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "${var.tool_name}-sg"
  }
}


data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "RHEL-9-DevOps-Practice"
  owners           = ["973714476881"]
}


resource "aws_instance" "instance" {
  ami = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name= var.tool_name
  }

  root_block_device {
    volume_size = var.volume_size
  }

  instance_market_options {
    market_type = "spot"
    spot_options {
      spot_instance_type = "persistent"
      instance_interruption_behavior = "stop"
    }
  }
  iam_instance_profile = ""
}

resource "aws_route53_record" "internal_record" {
  zone_id = var.zone_id
  name    = "${var.tool_name}-internal.${var.domain_name}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance.private_ip]
}

resource "aws_route53_record" "record" {
  zone_id = var.zone_id
  name    = "${var.tool_name}.${var.domain_name}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance.public_ip]
}
