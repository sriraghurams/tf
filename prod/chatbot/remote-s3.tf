terraform {
  required_version = "= 0.13.6"
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "prod-gap-terraform-remote-state-s3"
    dynamodb_table = "prod-gap-terraform-state-lock-dynamo"
    key            = "prod/chatbot/terraform.tfstate" 
    region         = "us-east-1"
    profile = "ctgap-prod"
    encrypt        = true
  }
}