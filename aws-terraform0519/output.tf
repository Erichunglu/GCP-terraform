output "Private_IP"{
    description = "This is the private IP for the SSH terminal"
    value = aws_instance.cathay-web.private_ip
}
