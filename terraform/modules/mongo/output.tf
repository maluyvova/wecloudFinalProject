output "mongo_public_ip" {
  value = aws_instance.terraform-mongo-server.public_ip
}


output "region_output" {
  value = "output this here look"
}
