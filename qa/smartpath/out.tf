 output "smartpath_vpc_id" {
  description = "EC2 Instance"
  value       = "${module.qa-smartpath-vpc.vpc_id}"
}

output "smartpath_private_subnets" {
  description = "List of IDs of private subnets"
  value       = "${module.qa-smartpath-vpc.private_subnets}"
}


output "smartpath_public_subnets" {
  description = "List of IDs of private subnets"
  value       = "${module.qa-smartpath-vpc.private_subnets}"
}

output "smartpath_dataprocessing_private_subnets" {
  description = "List of IDs of private subnets"
  value       = "${module.qa-smartpath-vpc.dataprocessing_private_subnets}"
}


output "smartpath_db_private_subnets" {
  description = "List of IDs of private subnets"
  value       = "${module.qa-smartpath-vpc.db_private_subnets}"
}

output  "smartpath_private_nacl_id"  {
  description = "Id of default nacl"
  value       = "${module.qa-smartpath-vpc.private_nacl_id}"
}

output "smartpath_private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = "${module.qa-smartpath-vpc.private_route_table_ids}"
}



output "smartpath_vpc_main_route_table_id" {
  description = "List of IDs of private route tables"
  value       = "${module.qa-smartpath-vpc.vpc_main_route_table_id}"
}
