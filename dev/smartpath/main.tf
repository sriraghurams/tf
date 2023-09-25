

module "dev-smartpath-vpc" {
source = "../../modules/vpc"
#source = "git::ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/baseline"
env = "dev-smartpath-new"
environment ="dev"
region = "us-east-1"
vpc-cidr = "10.234.0.0/16"
azs = ["us-east-1a", "us-east-1b"]
public-subnets = ["10.234.10.0/24" , "10.234.20.0/24"]
private-subnets = ["10.234.1.0/24" , "10.234.2.0/24"]
dataprocessing-private-subnets = ["10.234.3.0/24" , "10.234.4.0/24"]
db-private-subnets = ["10.234.5.0/25" , "10.234.5.128/25"]
gap-vpc-cidr    = "10.235.0.0/16" # NACL rule
ev-vpc-cidr     = "10.233.0.0/16" # NACL rule
smartpath-vpc-cidr = "10.234.0.0/16" # NACL rule
chatbot-vpc-cidr = "10.230.0.0/16" # NACL rule
analytics-vpc-cidr = "10.232.0.0/16"
evintegration-vpc-cidr ="10.231.0.0/16"
}
