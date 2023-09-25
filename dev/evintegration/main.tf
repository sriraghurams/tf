module "development" {
source = "../../modules/vpc"
env = "development-evintegration"
environment ="development"
region = "us-east-1"
vpc-cidr = "10.231.0.0/16"
azs = ["us-east-1a", "us-east-1b"]
public-subnets = ["10.231.10.0/24" , "10.231.20.0/24"]
private-subnets = ["10.231.1.0/24" , "10.231.2.0/24"]
dataprocessing-private-subnets = ["10.231.3.0/24" , "10.231.4.0/24"]
db-private-subnets = ["10.231.5.0/25" , "10.231.5.128/25"]
gap-vpc-cidr    = "10.235.0.0/16" # NACL rule
ev-vpc-cidr     = "10.233.0.0/16" # NACL rule
smartpath-vpc-cidr = "10.234.0.0/16" # NACL rule
chatbot-vpc-cidr = "10.230.0.0/16" # NACL rule
analytics-vpc-cidr = "10.232.0.0/16"
evintegration-vpc-cidr ="10.231.0.0/16"
}


output "evintegration_vpc_id" {
  description = "EC2 Instance"
  value       = "${module.development.vpc_id}"
}

output "evintegration_private_subnets" {
  description = "List of IDs of private subnets"
  value       = "${module.development.private_subnets}"
}


output "evintegration_public_subnets" {
  description = "List of IDs of private subnets"
  value       = "${module.development.public_subnets}"
  #value       = "${element("${module.development-gap-vpc.public_subnets}", 1)}"
}

output "evintegration_dataprocessing_private_subnets" {
  description = "List of IDs of private subnets"
  value       = "${module.development.dataprocessing_private_subnets}"
}


output "evintegration_db_private_subnets" {
  description = "List of IDs of private subnets"
  value       = "${module.development.db_private_subnets}"
}

