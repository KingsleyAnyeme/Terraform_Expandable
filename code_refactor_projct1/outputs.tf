output "aws_security_group" {
  value = aws_security_group.my_sg.id
}

output "aws_instance_public_ip" {
  value = aws_instance.my-ec2.public_ip
}

output "aws_instance_private_ip" {
  value = aws_instance.my-ec2.private_ip
}