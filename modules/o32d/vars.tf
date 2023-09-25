#################################################
# Common
#################################################

variable "region" {
  default = "us-east-1"
}

variable "account_id" {
    type = number
}
variable "common_tags" {
  description = "Common tags between resources"
  type        = map(string)
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

variable "config_profile" {
  description = "Profile name for Spring Config server"
}

variable "env" {
  description = "dev, qa, stage, or prod"
}

variable "app_name" {
  description = "app or team name"
}

variable "vpc_id" {
  description = "The VPC id"
}

# variable "dc_vpc_id" {
#  description = "The VPC id for datacentre connectivity"
# }

#################################################
# NLB
#################################################
variable "subnet_ids" {
  type        = list(string)
  description = "The private subnets to use"
}

# variable "dc_subnet_ids" {
#  type        = list(string)
#  description = "The private subnets to use for datacentre connectivity"
# }

# #################################################
# # API Gateway
# #################################################




#################################################
# ECS Service
#################################################

variable "appd_access_key" {
  description = "AppDynamics access key"
}

variable "appd_endpoint" {
  description = "AppDynamics endpoint"
}

variable "appd_account_name" {
  description = "AppDynamics account name"
}
variable "vpc_cidr" {
  description = "CIDR block of the ECS service VPC"
}

# variable "dc_vpc_cidr" {
#   description = "CIDR block of the ECS service VPC for datacentre"
# }

variable "ecs_task_execution_role" {}

variable "ecs_task_role" {}

variable "cmpgnmgt_image" {
  description = "ECR image for cmpgnmgt"
}

variable "cmpgnmgt_desired_count" {
  default = "0"
}

variable "cmpgnmgt_min_capacity" {
  default = "0"
}

variable "cmpgnmgt_max_capacity" {
  default = "0"
}

variable "deploy_cmpgnmgt" {
  default = "1"
}

variable "refresh_cmpgnmgt" {
  default = "false"
}

variable "admnmgt_image" {
  description = "ECR image for admnmgt"
}

variable "admnmgt_desired_count" {
  default = "0"
}

variable "admnmgt_min_capacity" {
  default = "0"
}

variable "admnmgt_max_capacity" {
  default = "0"
}

variable "deploy_admnmgt" {
  default = "1"
}

variable "refresh_admnmgt" {
  default = "false"
}

variable "evtlsnr_image" {
  description = "ECR image for evtlsnr"
}

variable "evtlsnr_desired_count" {
  default = "0"
}

variable "evtlsnr_min_capacity" {
  default = "0"
}

variable "evtlsnr_max_capacity" {
  default = "0"
}

variable "deploy_evtlsnr" {
  default = "1"
}

variable "refresh_evtlsnr" {
  default = "false"
}

# variable "mktcards_image" {
#   description = "ECR image for mktcards"
# }

variable "mktcards_desired_count" {
  default = "0"
}

variable "mktcards_min_capacity" {
  default = "0"
}

variable "mktcards_max_capacity" {
  default = "0"
}

variable "deploy_mktcards" {
  default = "1"
}

variable "refresh_mktcards" {
  default = "false"
}

# variable "auditsvc_image" {
#   description = "ECR image for auditsvc"
# }

variable "auditsvc_desired_count" {
  default = "0"
}

variable "auditsvc_min_capacity" {
  default = "0"
}

variable "auditsvc_max_capacity" {
  default = "0"
}

variable "deploy_auditsvc" {
  default = "1"
}

variable "refresh_auditsvc" {
  default = "false"
}
