

module "qa-smartpath-vpc" {
source = "../../modules/vpc"
#source = "git::ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/baseline"
env = "qa-smartpath"
environment ="qa"
region = "us-east-1"
vpc-cidr = "10.244.0.0/16"
azs = ["us-east-1a", "us-east-1b"]
public-subnets = ["10.244.10.0/24" , "10.244.20.0/24"]
private-subnets = ["10.244.1.0/24" , "10.244.2.0/24"]
dataprocessing-private-subnets = ["10.244.3.0/24" , "10.244.4.0/24"]
db-private-subnets = ["10.244.5.0/25" , "10.244.5.128/25"]
gap-vpc-cidr    = "10.245.0.0/16" # NACL rule
ev-vpc-cidr     = "10.243.0.0/16" # NACL rule
smartpath-vpc-cidr = "10.244.0.0/16" # NACL rule
chatbot-vpc-cidr = "10.240.0.0/16" # NACL rule
analytics-vpc-cidr = "10.242.0.0/16"
evintegration-vpc-cidr ="10.241.0.0/16"
}
