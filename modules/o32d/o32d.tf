#Demo comment
#################################################
# Local Variable Declaration
#################################################

locals {

  full_app_name = "${var.app_name}-${var.env}-${var.region}"

  # springcloudconfig_uri = "http://${data.aws_ssm_parameter.utils_nlb_dns.value}:8888/"
  springcloudconfig_uri = ""

  # alb_header_env = var.env == "prod" ? "" : ".${var.env}"

  # config_server_user = var.env == "prod" ? data.aws_ssm_parameter.config_server_user[0].value : ""
  config_server_user = ""

  # config_server_password = var.env == "prod" ? data.aws_ssm_parameter.config_server_password[0].value : ""
  config_server_password = ""

  tags = merge(
    {
      "Env"       = var.env
      "Workspace" = upper(join("-", ["${var.app_name}-${var.env}", regexall("[a-z]+", var.region)[1]]))
    },
  var.common_tags)
}

#################################################
# Shared Modules
#################################################

module "cloudwatch_log_group" {
  source = "git::https://gitlab.com/ctp1/tf.git//modules/cloudwatch_log_group?ref=origin/Dev"
  name   = local.full_app_name
  tags   = local.tags
}

module "ecs_cluster" {
  source = "git::https://gitlab.com/ctp1/tf.git//modules/ecs_cluster?ref=origin/Dev"
  name   = local.full_app_name
  tags   = local.tags
}

module "nlb" {
  source    = "git::https://gitlab.com/ctp1/tf.git//modules/nlb?ref=origin/Dev"
  name      = substr(local.full_app_name, 5, 32)
  subnet_id = var.subnet_ids
  tags      = local.tags
}

module "vpc_link" {
  source      = "git::https://gitlab.com/ctp1/tf.git//modules/apigw_vpc_link?ref=origin/Dev"
  name        = local.full_app_name
  description = "API Gateway VPC Link for ${local.full_app_name}"
  target_arns = [module.nlb.arn]
  tags        = local.tags
}

module "service_discovery_namespace" {
  source = "git::https://gitlab.com/ctp1/tf.git//modules/service_discovery_namespace?ref=origin/Dev"
  name   = local.full_app_name
  vpc_id = var.vpc_id
}

# ################################################
# # SSM Parameter Store
# #################################################

resource "aws_ssm_parameter" "nlb_dns_name" {
  name        = "/config/application/nlb/${var.app_name}/${var.env}/${replace(var.region, "-", "")}"
  description = "DNS name for the ${var.app_name}-${var.env}-${var.region} NLB"
  type        = "SecureString"
  overwrite   = true
  value       = module.nlb.dns_name
}

resource "aws_ssm_parameter" "vpc_link_id" {
  name        = "/apigw/vpc_link_id/${var.app_name}/${var.env}/${replace(var.region, "-", "")}"
  description = "VPC Link ID for ${var.app_name}-${var.env}-${var.region}"
  type        = "SecureString"
  overwrite   = true
  value       = module.vpc_link.id
}

# #################################################
# # Services
# #################################################

module "svc1" {
  source                      = "git::https://gitlab.com/ctp1/tf.git//modules/ecs_service?ref=origin/Dev"
  ecs_desired_task_count      = var.cmpgnmgt_desired_count
  ecs_min_capacity            = var.cmpgnmgt_min_capacity
  ecs_max_capacity            = var.cmpgnmgt_max_capacity
  deploy                      = var.deploy_cmpgnmgt
  refresh_task_def            = var.refresh_cmpgnmgt
  env                         = var.env
  config_profile              = var.config_profile
  vpc_id                      = var.vpc_id
  namespace_id                = module.service_discovery_namespace.namespace_id
  namespace_name              = module.service_discovery_namespace.namespace_name
  service_name                = "svc1"
  team_name                   = var.app_name
  tags                        = local.tags
  aws_region                  = var.region
  traffic_port                = 7100
  nlb_arn                     = module.nlb.arn
  nlb_port                    = 7100
  springcloudconfig_uri       = local.springcloudconfig_uri
  springcloudconfig_username  = local.config_server_user
  springcloudconfig_password  = local.config_server_password
  log_group_name              = module.cloudwatch_log_group.name
  image                       = var.cmpgnmgt_image
  appd_accesskey              = var.appd_access_key
  appd_endpoint               = var.appd_endpoint
  appd_account_name           = var.appd_account_name
  traffic_protocol            = "tcp"
  management_port             = 7101
  management_protocol         = "tcp"
  cpu                         = 1024
  memory                      = 2048
  ecs_task_execution_role_arn = "arn:aws:iam::${var.account_id}:role/${var.ecs_task_execution_role}"
  ecs_task_role_arn           = "arn:aws:iam::${var.account_id}:role/${var.ecs_task_role}"
  vpc_cidr                    = var.vpc_cidr
  ecs_cluster                 = module.ecs_cluster.id
  ecs_cluster_name            = module.ecs_cluster.name
  ecs_subnets_ids             = var.subnet_ids
  healthcheck_alarm           = "0"
# sns_topic_arn               = data.aws_ssm_parameter.healthcheck_sns_arn.value
  sns_topic_arn               = ""
  lb_arn_suffix               = module.nlb.arn_suffix
  partition_key_name          = "targetgroupname"
# dynamodb_table_name         = "ctpa-utils-${var.env}-healthcheck-dynamodb"
  dynamodb_table_name         = ""
  lb_type                     = "NLB"

}

module "svc2" {
  source                      = "git::https://gitlab.com/ctp1/tf.git//modules/ecs_service?ref=origin/Dev"
  ecs_desired_task_count      = var.admnmgt_desired_count
  ecs_min_capacity            = var.admnmgt_min_capacity
  ecs_max_capacity            = var.admnmgt_max_capacity
  deploy                      = var.deploy_admnmgt
  refresh_task_def            = var.refresh_admnmgt
  env                         = var.env
  config_profile              = var.config_profile
  vpc_id                      = var.vpc_id
  namespace_id                = module.service_discovery_namespace.namespace_id
  namespace_name              = module.service_discovery_namespace.namespace_name
  service_name                = "svc2"
  team_name                   = var.app_name
  tags                        = local.tags
  aws_region                  = var.region
  traffic_port                = 7102
  nlb_arn                     = module.nlb.arn
  nlb_port                    = 7102
  springcloudconfig_uri       = local.springcloudconfig_uri
  springcloudconfig_username  = local.config_server_user
  springcloudconfig_password  = local.config_server_password
  log_group_name              = module.cloudwatch_log_group.name
  image                       = var.admnmgt_image
  appd_accesskey              = var.appd_access_key
  appd_endpoint               = var.appd_endpoint
  appd_account_name           = var.appd_account_name
  traffic_protocol            = "tcp"
  management_port             = 7103
  management_protocol         = "tcp"
  cpu                         = 1024
  memory                      = 2048
  ecs_task_execution_role_arn = "arn:aws:iam::${var.account_id}:role/${var.ecs_task_execution_role}"
  ecs_task_role_arn           = "arn:aws:iam::${var.account_id}:role/${var.ecs_task_role}"
  vpc_cidr                    = var.vpc_cidr
  ecs_cluster                 = module.ecs_cluster.id
  ecs_cluster_name            = module.ecs_cluster.name
  ecs_subnets_ids             = var.subnet_ids
  healthcheck_alarm           = "0"
#  sns_topic_arn               = data.aws_ssm_parameter.healthcheck_sns_arn.value
  sns_topic_arn               = ""
  lb_arn_suffix               = module.nlb.arn_suffix
  partition_key_name          = "targetgroupname"
#  dynamodb_table_name         = "ctpa-utils-${var.env}-healthcheck-dynamodb"
  dynamodb_table_name         = ""
  lb_type                     = "NLB"
}

module "svc3" {
  source                      = "git::https://gitlab.com/ctp1/tf.git//modules/ecs_service?ref=origin/Dev"
  ecs_desired_task_count      = var.evtlsnr_desired_count
  ecs_min_capacity            = var.evtlsnr_min_capacity
  ecs_max_capacity            = var.evtlsnr_max_capacity
  deploy                      = var.deploy_evtlsnr
  refresh_task_def            = var.refresh_evtlsnr
  env                         = var.env
  config_profile              = var.config_profile
  vpc_id                      = var.vpc_id
  namespace_id                = module.service_discovery_namespace.namespace_id
  namespace_name              = module.service_discovery_namespace.namespace_name
  service_name                = "svc3"
  team_name                   = var.app_name
  tags                        = local.tags
  aws_region                  = var.region
  traffic_port                = 7104
  nlb_arn                     = module.nlb.arn
  nlb_port                    = 7104
  springcloudconfig_uri       = local.springcloudconfig_uri
  springcloudconfig_username  = local.config_server_user
  springcloudconfig_password  = local.config_server_password
  log_group_name              = module.cloudwatch_log_group.name
  image                       = var.evtlsnr_image
  appd_accesskey              = var.appd_access_key
  appd_endpoint               = var.appd_endpoint
  appd_account_name           = var.appd_account_name
  traffic_protocol            = "tcp"
  management_port             = 7105
  management_protocol         = "tcp"
  cpu                         = 1024
  memory                      = 2048
  ecs_task_execution_role_arn = "arn:aws:iam::${var.account_id}:role/${var.ecs_task_execution_role}"
  ecs_task_role_arn           = "arn:aws:iam::${var.account_id}:role/${var.ecs_task_role}"
  vpc_cidr                    = var.vpc_cidr
  ecs_cluster                 = module.ecs_cluster.id
  ecs_cluster_name            = module.ecs_cluster.name
  ecs_subnets_ids             = var.subnet_ids
  healthcheck_alarm           = "0"
#  sns_topic_arn               = data.aws_ssm_parameter.healthcheck_sns_arn.value
  sns_topic_arn               = ""
  lb_arn_suffix               = module.nlb.arn_suffix
  partition_key_name          = "targetgroupname"
#  dynamodb_table_name         = "ctpa-utils-${var.env}-healthcheck-dynamodb"
  dynamodb_table_name         = ""
  lb_type                     = "NLB"
}

# module "mktcards" {
#   source                      = "../modules/ecs_service"
#   ecs_desired_task_count      = var.mktcards_desired_count
#   ecs_min_capacity            = var.mktcards_min_capacity
#   ecs_max_capacity            = var.mktcards_max_capacity
#   deploy                      = var.deploy_mktcards
#   refresh_task_def            = var.refresh_mktcards
#   env                         = var.env
#   config_profile              = var.config_profile
#   vpc_id                      = var.vpc_id
#   namespace_id                = module.service_discovery_namespace.namespace_id
#   namespace_name              = module.service_discovery_namespace.namespace_name
#   service_name                = "mktcards"
#   team_name                   = var.app_name
#   tags                        = local.tags
#   aws_region                  = var.region
#   traffic_port                = 7106
#   nlb_arn                     = module.nlb.arn
#   nlb_port                    = 7106
#   springcloudconfig_uri       = local.springcloudconfig_uri
#   springcloudconfig_username  = local.config_server_user
#   springcloudconfig_password  = local.config_server_password
#   log_group_name              = module.cloudwatch_log_group.name
#   image                       = var.mktcards_image
#   appd_accesskey              = var.appd_access_key
#   appd_endpoint               = var.appd_endpoint
#   appd_account_name           = var.appd_account_name
#   traffic_protocol            = "tcp"
#   management_port             = 7107
#   management_protocol         = "tcp"
#   cpu                         = 1024
#   memory                      = 2048
#   ecs_task_execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.ecs_task_execution_role}"
#   ecs_task_role_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.ecs_task_role}"
#   vpc_cidr                    = var.vpc_cidr
#   ecs_cluster                 = module.ecs_cluster.id
#   ecs_cluster_name            = module.ecs_cluster.name
#   ecs_subnets_ids             = var.subnet_ids
#   healthcheck_alarm           = "0"
# #  sns_topic_arn               = data.aws_ssm_parameter.healthcheck_sns_arn.value
#   sns_topic_arn               = ""
#   lb_arn_suffix               = module.nlb.arn_suffix
#   partition_key_name          = "targetgroupname"
# #  dynamodb_table_name         = "ctpa-utils-${var.env}-healthcheck-dynamodb"
#   dynamodb_table_name         = ""
#   lb_type                     = "NLB"
# }

# module "auditsvc" {
#   source                      = "../modules/ecs_service"
#   ecs_desired_task_count      = var.auditsvc_desired_count
#   ecs_min_capacity            = var.auditsvc_min_capacity
#   ecs_max_capacity            = var.auditsvc_max_capacity
#   deploy                      = var.deploy_auditsvc
#   refresh_task_def            = var.refresh_auditsvc
#   env                         = var.env
#   config_profile              = var.config_profile
#   vpc_id                      = var.vpc_id
#   namespace_id                = module.service_discovery_namespace.namespace_id
#   namespace_name              = module.service_discovery_namespace.namespace_name
#   service_name                = "auditsvc"
#   team_name                   = var.app_name
#   tags                        = local.tags
#   aws_region                  = var.region
#   traffic_port                = 7108
#   nlb_arn                     = module.nlb.arn
#   nlb_port                    = 7108
#   springcloudconfig_uri       = local.springcloudconfig_uri
#   springcloudconfig_username  = local.config_server_user
#   springcloudconfig_password  = local.config_server_password
#   log_group_name              = module.cloudwatch_log_group.name
#   image                       = var.auditsvc_image
#   appd_accesskey              = var.appd_access_key
#   appd_endpoint               = var.appd_endpoint
#   appd_account_name           = var.appd_account_name
#   traffic_protocol            = "tcp"
#   management_port             = 7109
#   management_protocol         = "tcp"
#   cpu                         = 1024
#   memory                      = 2048
#   ecs_task_execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.ecs_task_execution_role}"
#   ecs_task_role_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.ecs_task_role}"
#   vpc_cidr                    = var.vpc_cidr
#   ecs_cluster                 = module.ecs_cluster.id
#   ecs_cluster_name            = module.ecs_cluster.name
#   ecs_subnets_ids             = var.subnet_ids
#   healthcheck_alarm           = "0"
# #  sns_topic_arn               = data.aws_ssm_parameter.healthcheck_sns_arn.value
#   sns_topic_arn               = ""
#   lb_arn_suffix               = module.nlb.arn_suffix
#   partition_key_name          = "targetgroupname"
# #  dynamodb_table_name         = "ctpa-utils-${var.env}-healthcheck-dynamodb"
#   dynamodb_table_name         = ""
#   lb_type                     = "NLB"
# }



# apigw

#################################################
# Local Variable Declaration
#################################################
locals {
  mktpl_body = templatefile("${path.module}/base_swagger.template", {
    title = local.mktpl_gw_name
  })
  mktpl_gw_name = "o23d-${var.region}.${var.env}.com"
}

#################################################
# API Gateway Resources
#################################################

module "o32d_mktpl_cloudwatch_log_group" {
  source = "git::https://gitlab.com/ctp1/tf.git//modules/cloudwatch_log_group?ref=origin/Dev"
  name   = "${local.mktpl_gw_name}"
  tags   = local.tags
}

module "o32d_mktpl_apigw" {
  source               = "git::https://gitlab.com/ctp1/tf.git//modules/apigw?ref=origin/Dev"
  apigw_name           = local.mktpl_gw_name
  api_stage            = var.api_stage #should be defined in TFE workspaces
  api_body             = local.mktpl_body
  api_type             = var.api_type #should be defined in TFE workspaces
  cloudwatch_log_group = module.o32d_mktpl_cloudwatch_log_group.arn
  apigw_domain         = var.mktpl_domain_name #should be defined as the SAME in east and west TFE workspaces
  acm_cert             = var.acm_cert
}

module "o32d_mktpl_usage_plan" {
  source        = "git::https://gitlab.com/ctp1/tf.git//modules/apigw_usageplan?ref=origin/Dev"
  apigw_name    = local.mktpl_gw_name
  quota_limit   = var.mktpl_quota_limit
  quota_period  = var.mktpl_quota_period
  burst_limit   = var.mktpl_burst_limit
  rate_limit    = var.mktpl_rate_limit
  apigw_id      = module.o32d_mktpl_apigw.api_id
  stage_name    = module.o32d_mktpl_apigw.stage_name
#  api_key_value = var.mktpl_api_key_value
}

# ACM CERT ARNS - Need to define in TFE workspaces
# *.dev.telematicsct.com -- arn:aws:acm:us-west-2:837432931185:certificate/3d8c66fb-6608-4287-9fed-a63bbc3248d7
# *.qa.telematicsct.com -- arn:aws:acm:us-west-2:837432931185:certificate/886eadbe-6e6c-431c-82dc-3ad700fc104b
# *.stg.telematicsct.com -- arn:aws:acm:us-west-2:837432931185:certificate/796cf2a5-3db9-4a0f-9d84-46f236b50b66

# module "ctpa_oneapi_r53_record" {
#   source         = "../modules/route53"
#   name           = module.ctpa_oneapi_apigw.domain_name
#   hosted_zone_id = "ZL5N5I19BYYOG"
#   domain_name    = module.ctpa_oneapi_apigw.regional_domain_name
#   zone_id        = module.ctpa_oneapi_apigw.regional_zone_id
# }

