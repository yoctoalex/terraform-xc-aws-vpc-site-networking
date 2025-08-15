output "vpc_id" {
  value       = var.vpc_id
  description = "The ID of the VPC."
}

output "vpc_cidr" {
  value       = data.aws_vpc.this.cidr_block
  description = "The CIDR block of the VPC."
}

output "outside_security_group_id" {
  value       = var.create_outside_security_group ? aws_security_group.outside[0].id : null
  description = "The ID of the outside security group."
}

output "inside_security_group_id" {
  value       = var.create_inside_security_group ? aws_security_group.inside[0].id : null
  description = "The ID of the inside security group."
}

output "tcp_80_prefix_list_id" {
  value       = var.create_outside_security_group ? aws_ec2_managed_prefix_list.tcp_80[0].id : null
  description = "The ID of the managed prefix list for TCP/80 source ranges."
}

output "tcp_443_prefix_list_id" {
  value       = var.create_outside_security_group ? aws_ec2_managed_prefix_list.tcp_443[0].id : null
  description = "The ID of the managed prefix list for TCP/443 source ranges."
}

output "udp_4500_prefix_list_id" {
  value       = var.create_outside_security_group && var.create_udp_security_group_rules ? aws_ec2_managed_prefix_list.udp_4500[0].id : null
  description = "The ID of the managed prefix list for UDP/4500 source ranges (if created)."
}
