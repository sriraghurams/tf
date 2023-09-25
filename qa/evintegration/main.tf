module "qa" {
source = "../../modules/vpc"
env = "qa-evintegration"
environment ="qa"
region = "us-east-1"
vpc-cidr = "10.241.0.0/16"
azs = ["us-east-1a", "us-east-1b"]
public-subnets = ["10.241.10.0/24" , "10.241.20.0/24"]
private-subnets = ["10.241.1.0/24" , "10.241.2.0/24"]
dataprocessing-private-subnets = ["10.241.3.0/24" , "10.241.4.0/24"]
db-private-subnets = ["10.241.5.0/25" , "10.241.5.128/25"]
gap-vpc-cidr    = "10.245.0.0/16" # NACL rule
ev-vpc-cidr     = "10.243.0.0/16" # NACL rule
smartpath-vpc-cidr = "10.244.0.0/16" # NACL rule
chatbot-vpc-cidr = "10.240.0.0/16" # NACL rule
analytics-vpc-cidr = "10.242.0.0/16"
evintegration-vpc-cidr ="10.241.0.0/16"
}


output "evintegration_vpc_id" {
  description = "EC2 Instance"
  value       = "${module.qa.vpc_id}"
}

output "evintegration_private_subnets" {
  description = "List of IDs of private subnets"
  value       = "${module.qa.private_subnets}"
}


output "evintegration_public_subnets" {
  description = "List of IDs of private subnets"
  value       = "${module.qa.public_subnets}"
  #value       = "${element("${module.qa-gap-vpc.public_subnets}", 1)}"
}

output "evintegration_dataprocessing_private_subnets" {
  description = "List of IDs of private subnets"
  value       = "${module.qa.dataprocessing_private_subnets}"
}


output "evintegration_db_private_subnets" {
  description = "List of IDs of private subnets"
  value       = "${module.qa.db_private_subnets}"
}

