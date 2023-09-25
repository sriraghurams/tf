output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private-subnets.*.id
}


output "public_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.public-subnets.*.id
}

output "dataprocessing_private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.dataprocessing-private-subnets.*.id
}


output "db_private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.db-private-subnets.*.id
}



output "private_nacl_id" {
  description = "List of IDs of private subnets"
  value       = concat(aws_network_acl.nacl.*.id, [""])[0]
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = aws_route_table.private-rtable.*.id
}


output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = concat(aws_vpc.vpc.*.main_route_table_id, [""])[0]
}