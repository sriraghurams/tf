
variable "vpc_id" {
    description = "VPC ID"
    type = string
}

variable "msk_sg_name" {
    description = "kafka security group name"
    type = string
}

variable "cidr" {
    description = "VPC cidr"
    type = list(string)
}


variable "loggroup_name" {
    description = "kafka log group name"
    type = string
}

variable "msk_cluster_name" {
    description = "kafka cluster name"
    type = string
}
variable "kafka_version" {
    description = "Mananged kafka version "
    type = string
}
variable "number_of_broker_nodes" {
    description = " this is for replication in lower environments this value is 2 and in prod it should be 3"
    type = number
}
variable "instance_type" {
    description = " Instance class definition with size"
    type = string
}
variable "ebs_volume_size" {
    description = "size of ebs volume"
    type = number
}

variable "private_subnets" {
    description = "Private subnets to host managed kafka"
    type = list(string)
}

variable "msk_kms_id" {
    description = "KMS cmk key arn for encryption at rest"
    type = string
}

variable "env" {
    description = "environment"
    type = string
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




variable "scaling_max_capacity" {
    description = "EBS max size for autoscale"
    type = number
}



variable "scaling_target_value" {
    description = "broker scale out max number"
    type = number
}