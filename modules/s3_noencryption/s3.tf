resource "aws_s3_bucket_public_access_block" "corect-bucket" {
  bucket = aws_s3_bucket.corect-bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "corect-bucket" {
  bucket = "${var.corect-bucket-name}"
  acl    = "private"
  policy = file("../../files/${var.env}/${var.policy-file}.json")
  versioning {
    enabled = "${var.bucket-version}"
  }

  
  tags = {
    Terraform              = "true"
    Project                = "Core-Gap"
    Env                    = "${var.env}"
    Name                   = "${var.corect-bucket-name}"
    ApplicationId          = "APM0004691"
    ApplicationName        = "CT-Gap"
    TerraformScriptVersion = "0.13.6"
    CoreID                 = "5510120030"
    DeptID                 = "957200"
    ProjectID              = "OCT-0100-09-01-01-0008"
    CreatedBy              = "Core-gap team member"
    BU                     = "CT"
    Project                = "CoreGAP"
  } 
}
