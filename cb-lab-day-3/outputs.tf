// outputs for the user data webserver
output "Private_IP" {
  description = "This is the private IP for the SSH terminal"
  value       = aws_instance.cathay-web.private_ip
}

output "Public_IP" {
  description = "This is the public IP"
  value       = join("", ["http://", aws_instance.cathay-web.public_ip])
}

// outputs for the remote-exec webserver
#output "Remote_Private_IP" {
#  description = "This is the private IP for the SSH terminal"
#  value       = aws_instance.remote-server.private_ip
#}

#output "Remote_Public_IP" {
#  description = "This is the public IP"
#  value       = join("", ["http://", aws_instance.remote-server.public_ip])
#}