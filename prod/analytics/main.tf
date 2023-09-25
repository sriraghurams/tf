module "prod" {
    source          = "../../modules/vpc"
    env             = "prod-analytics"
    environment     = "prod"
    region          = "us-east-1"
    vpc-cidr        = "10.222.0.0/16"
    azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
    public-subnets  = ["10.222.10.0/24" , "10.222.20.0/24", "10.222.30.0/24"]
    private-subnets = ["10.222.1.0/24" , "10.222.2.0/24", "10.222.3.0/24"]
    dataprocessing-private-subnets = ["10.222.4.0/24" , "10.222.5.0/24", "10.222.6.0/24"]
    db-private-subnets = ["10.222.7.0/25" , "10.222.7.128/25", "10.222.8.0/25"]
    gap-vpc-cidr    = "10.225.0.0/16"
    ev-vpc-cidr     = "10.223.0.0/16"
    smartpath-vpc-cidr = "10.224.0.0/16"
    chatbot-vpc-cidr = "10.220.0.0/16"
    analytics-vpc-cidr  = "10.222.0.0/16"
    evintegration-vpc-cidr ="10.221.0.0/16"
}