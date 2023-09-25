module "prod" {
    source          = "../../modules/vpc"
    env             = "prod-chatbot"
    environment     = "prod"
    region          = "us-east-1"
    vpc-cidr        = "10.220.0.0/16"
    azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
    public-subnets  = ["10.220.10.0/24" , "10.220.20.0/24", "10.220.30.0/24"]
    private-subnets = ["10.220.1.0/24" , "10.220.2.0/24", "10.220.3.0/24"]
    dataprocessing-private-subnets = ["10.220.4.0/24" , "10.220.5.0/24", "10.220.6.0/24"]
    db-private-subnets = ["10.220.7.0/25" , "10.220.7.128/25", "10.220.8.0/25"]
    gap-vpc-cidr    = "10.225.0.0/16"
    ev-vpc-cidr     = "10.223.0.0/16"
    smartpath-vpc-cidr = "10.224.0.0/16"
    chatbot-vpc-cidr = "10.220.0.0/16"
    analytics-vpc-cidr  = "10.222.0.0/16"
    evintegration-vpc-cidr ="10.221.0.0/16"
}

