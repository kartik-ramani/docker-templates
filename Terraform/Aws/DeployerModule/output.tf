output "ip" {
  value = aws_instance.app_server.public_ip
}

output "privateip" {
  value = aws_instance.app_server.private_ip
}

output "state" {
  value = aws_instance.app_server.instance_state
}

output "ami" {
  value = aws_instance.app_server.ami
}

output "arn" {
  value = aws_instance.app_server.arn
}

output "keypair" {
  value = aws_key_pair.kp
}

output "securitygroup" {
  value = aws_security_group.sg
}
