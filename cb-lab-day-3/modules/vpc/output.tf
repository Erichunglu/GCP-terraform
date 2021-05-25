output "vpc-id" {
  value = aws_vpc.cbl-vpc.id
}

output "subnet-id" {
  value = aws_subnet.cbl-subnet.id
}