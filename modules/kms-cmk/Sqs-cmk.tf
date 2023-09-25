resource "aws_kms_alias" "corect-cmk" {
  name          = "alias/${var.corect-kms-name}"
  target_key_id = aws_kms_key.corect-cmk.key_id
}
resource "aws_kms_key" "corect-cmk" {
  description             = "customer managed key"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Id": "key-consolepolicy-3",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.aws-account}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow access for Key Administrators",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.aws-account}:role/app-admin-role"
            },
            "Action": [
                "kms:Create*",
                "kms:Describe*",
                "kms:Enable*",
                "kms:List*",
                "kms:Put*",
                "kms:Update*",
                "kms:Revoke*",
                "kms:Disable*",
                "kms:Get*",
                "kms:Delete*",
                "kms:TagResource",
                "kms:UntagResource",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
        },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
}
POLICY



  tags = {
    Terraform              = "true"
    Project                = "Core-Gap"
    Env                    = "${var.env}"
    Name                   = "${var.corect-kms-name}"
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

# #Outputs
# output "$${var.corect-kms-name}-key-id" {
#   description = "SQS cmk queue key id"
#   value = aws_kms_key.${var.corect-kms-name}.key_id
# }
