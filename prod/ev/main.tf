module "prod" {
    source          = "../../modules/vpc"
    env             = "prod-ev"
    environment     = "prod"
    region          = "us-east-1"
    vpc-cidr        = "10.223.0.0/16"
    azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
    public-subnets  = ["10.223.10.0/24" , "10.223.20.0/24", "10.223.30.0/24"]
    private-subnets = ["10.223.1.0/24" , "10.223.2.0/24", "10.223.3.0/24"]
    dataprocessing-private-subnets = ["10.223.4.0/24" , "10.223.5.0/24", "10.223.6.0/24"]
    db-private-subnets = ["10.223.7.0/25" , "10.223.7.128/25", "10.223.8.0/25"]
    gap-vpc-cidr    = "10.225.0.0/16"
    ev-vpc-cidr     = "10.223.0.0/16"
    smartpath-vpc-cidr = "10.224.0.0/16"
    chatbot-vpc-cidr = "10.220.0.0/16"
    analytics-vpc-cidr  = "10.222.0.0/16"
    evintegration-vpc-cidr ="10.221.0.0/16"
}

