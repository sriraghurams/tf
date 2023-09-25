module "dev" {
#source = "git::https://git-codecommit.us-east-1.amazonaws.com/v1/repos/baseline.git"
source = "git::ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/baseline"
env = "dev"
region = "us-east-1"
vpc-cidr = "30.0.0.0/16"
azs = ["us-east-1a", "us-east-1b"]
public-subnets = ["30.0.10.0/24" , "30.0.20.0/24"]
private-subnets = ["30.0.1.0/24" , "30.0.2.0/24"]

#Data bricks variables
spark-version = "7.4.x-scala2.12"
instance-profile-arn = "arn:aws:iam::833714968256:instance-profile/dev-databricks-cluster-instance-profile-role"
s3-destination = "s3://dev-databricks-account-aws-storage/cluster-logs"
node-class-type = "m4.large"
cluster-name = "dev-gap"
databricks-host = "https://dbc-c5177952-bfb7.cloud.databricks.com/"
databricks-token = "dapia80d509dad99a9be17648ba595bd499f"
}
