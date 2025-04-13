output "backend_subnet1" {
 value = aws_subnet.backend_subnet1.id
}

output "backend_subnet2" {
  value = aws_subnet.backend_subnet2.id
}

output "frontend_subnet1" {
  value = aws_subnet.frontend_subnet1.id
}

output "frontend_subnet2" {
  value = aws_subnet.frontend_subnet2.id
}

output "main_vpc" {
 value = aws_vpc.main_vpc.id
}
