terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "pdw-terraform-live-state"
    dynamodb_table = "pdw-terraform-live-locks"
    key            = "dev/terraform.tfstate" 
    region         = "us-east-1"
    encrypt        = true
  }
}