terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

resource "aws_security_group" "sg" {
  name = "securitygroup"
  description = "Allow HTTP and SSH traffic via Terraform"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



variable "keyName" {
  default = "mykey"
}

variable "github_url" {
  default = "https://github.com/docker/getting-started.git"
}

provider "aws" {
  region = "us-west-2"
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "myKey"       # Create a "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { # Create a "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./${var.keyName}.pem && chmod 400 ${var.keyName}.pem"
  }
}


resource "aws_instance" "app_server" {
  ami           = "ami-08df94af6199f15b6"
  instance_type = "t2.micro"
  key_name = aws_key_pair.kp.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = "ExapleTeraaform"
  }


  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("${var.keyName}.pem")
    host     = self.public_ip
  }


  provisioner "remote-exec" {
      inline = [
        "sudo apt update",
        "sudo apt upgrade - y",
        "sudo uwf allow 8080",
        "sudo apt install docker.io -y && sudo apt install docker-compose -y && git clone https://github.com/kartik-ramani/sample.git && cd sample && sudo docker-compose up -d "
      ]
    
  }


  depends_on = [
    aws_key_pair.kp
  ]
}



# inline = [
#         "sudo apt update",
#         "sudo apt upgrade - y",
#         "sudo uwf allow 8080",
#         "sudo apt install docker.io -y && sudo apt install docker-compose -y && git clone https://github.com/kartik-ramani/sample.git && cd sample && sudo docker-compose up -d "
#       ]

# && cd sample && sudo docker-compose up -d

// Docker run from Docker File
# inline = [
#         "sudo apt update",
#         "sudo apt upgrade - y",
#         "sudo apt install docker.io -y && sudo docker run -dp 80:80 docker/getting-started"
# ]