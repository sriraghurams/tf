terraform {
  required_version = "= 0.13.6"
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "stage-gap-terraform-remote-state-s3"
    dynamodb_table = "stage-gap-terraform-state-lock-dynamo"
    key            = "qa/evintegration/terraform.tfstate" 
    region         = "us-east-1"
    profile = "ctgap-stage"
    encrypt        = true
  }
}