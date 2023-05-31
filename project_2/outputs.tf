output "aws_security_group" {
  value = aws_security_group.web_sg.id
}

output "aws_instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "aws_instance_private_ip" {
  value = aws_instance.web.private_ip
}