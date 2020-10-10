output "private_subnet_ids" {
  value = local.private_subnet_ids
}

output "public_subnet_ids" {
  value = local.public_subnet_ids
}

output "security_group" {
  value = {
    "backend"   = aws_security_group.backend.id
    "bastion"   = aws_security_group.bastion.id
    "egress"    = aws_security_group.egress.id,
    "frontend"  = aws_security_group.frontend.id
    "instance"  = aws_security_group.instance.id
  }
}

output "vpc_id" {
  value = aws_vpc.this.id
}
