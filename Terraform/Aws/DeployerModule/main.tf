
// Security Group

resource "aws_security_group" "sg" {
  name        = var.securityGroup
  description = "Allow HTTP and SSH traffic via Terraform"

  ingress {
    from_port   = var.port
    to_port     = var.port
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


// KEY PAIR GENRATES PEM FILE

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = var.keyName
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { # Create a "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./${var.keyName}.pem && chmod 400 ${var.keyName}.pem"
  }
}



// EC2 SetUp

resource "aws_instance" "app_server" {
  ami                    = var.ami
  instance_type          = var.instanceType
  key_name               = aws_key_pair.kp.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = "Terraform "
  }


  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${var.keyName}.pem")
    host        = self.public_ip
  }




  provisioner "remote-exec" {
    inline =  var.executionType == 1 ? [
      "sudo apt update",
      "sudo apt upgrade - y",
     "sudo uwf allow ${var.port}",
      "sudo apt install docker.io -y && sudo docker run -dp ${var.port}:80 ${var.dockerImage}"
    ] :  [
        "sudo apt update",
        "sudo apt upgrade - y",
        "sudo uwf allow ${var.port}",
        "sudo apt install docker.io -y && sudo apt install docker-compose -y && git clone ${var.gitUrl} && cd ${var.folderName} && sudo docker-compose up -d "
    ]
  }


  depends_on = [
    aws_key_pair.kp
  ]
}


