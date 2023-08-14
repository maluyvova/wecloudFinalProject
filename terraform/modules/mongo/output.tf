output "mongo_public_ip" {
  value = aws_instance.terraform-mongo-server.public_ip
}
