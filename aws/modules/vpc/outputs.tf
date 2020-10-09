output "private_subnet_ids" {
  value = local.private_subnet_ids
}

output "subnet_ids" {
  value = local.subnet_ids
}

output "vpc_id" {
  value = aws_vpc.this.id
}
