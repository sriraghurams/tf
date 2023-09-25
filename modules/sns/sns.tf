module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 3.0"

  name  = "${var.sns-topic-name}"
  display_name = "${var.sns-topic-name}"
  kms_master_key_id = "alias/corect-sns-cmk"

  tags = {
    Terraform              = "true"
    Project                = "Core-Gap"
    Env                    = "${var.env}"
    Name                   = "${var.sns-topic-name}"
    ApplicationId          = "APM0004691"
    ApplicationName        = "CT-Gap"
    TerraformScriptVersion = "NA"
    CoreID                 = "5510120030"
    DeptID                 = "957200"
    ProjectID              = "OCT-0100-09-01-01-0008"
    CreatedBy              = "Core-gap team member"
    BU                     = "CT"
    }
}
  