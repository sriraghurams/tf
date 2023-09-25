variable "domain" {
    type = string
}
variable "instance_type" {
    type = string
}
variable "volume_type" {
    type = string
}
variable "ebs_volume_size" {}

variable "subnet_ids" {
    type = list(string)
}

variable "default_tags" {
    description = "Default tags"
    type = map(string)
    default = {
      Terraform              = "true"
      Project                = "Evintegration"
      ApplicationId          = "APM0004691"
      ApplicationName        = "032D"
      TerraformScriptVersion = "0.13.6"
      CoreID                 = "5510120030"
      DeptID                 = "957200"
      ProjectID              = "OCT-0100-09-01-01-0008"
      CreatedBy              = "Core-gap team member"
      BU                     = "CT"
      Project                = "CoreGAP"
  } 
  
}

variable "env" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable  "instance_count" {
    type = number
}

variable "es_kms_key_id" {
    type = string
}

variable "create_iam_service_linked_role" {
  type        = "string"
  default     = "true"
  description = "Whether to create `AWSServiceRoleForAmazonElasticsearchService` service-linked role. Set it to `false` if you already have an ElasticSearch cluster created in the AWS account and AWSServiceRoleForAmazonElasticsearchService already exists. See https://github.com/terraform-providers/terraform-provider-aws/issues/5218 for more info"
}
variable "enabled" {
    type = string
    default = "true"
}