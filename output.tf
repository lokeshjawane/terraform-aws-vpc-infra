// The VPC ID
output "id" {
  value = aws_vpc.main.id
}

// The VPC CIDR
output "cidr_block" {
  value = aws_vpc.main.cidr_block
}

// A comma-separated list of subnet IDs.
output "external_subnets" {
  value = aws_subnet.external.*.id
}

output "external_autosubnets" {
  value = aws_subnet.external_autosubnet.*.id
}

output "internal_subnets" {
  value = aws_subnet.internal.*.id
}

output "internal_autosubnets" {
  value = aws_subnet.internal_autosubnet.*.id
}

