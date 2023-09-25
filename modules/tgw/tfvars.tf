variable "vpc-id" {
    type = string
}

variable "private-subnets-ids" {
    type = list
}

variable "env" {
    type = string
}

variable "amazon_side_asn" {
    type = number
}

variable "default_tags" {
    description = "Default tags"
    type = map(string)
    default = {
      Terraform              = "true"
      Project                = "Core-Gap"
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

variable "gap-smartpath-nonprod-vpc-cidr" {
    type = string
}

variable "ct-smartpath-nonprod-vpc-cidr" {
    type = string
}

variable "cross-account-id" {
    type = string
}

variable "network_acl_id" {
    type = string
}



variable "vpc_main_route_table_id" {
    type = string
}

variable "private_route_table_ids" {
    type = list(string)
}