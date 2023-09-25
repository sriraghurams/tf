
module "elastic-search" {
    source     = "../../modules/elasticsearch"

    domain              = "qa-testing" 
    instance_type       = "r4.large.elasticsearch"
    volume_type         = "gp2"
    ebs_volume_size     = 100
    subnet_ids          = "${module.qa.private_subnets}"
    vpc_id              = "${module.qa.vpc_id}"
    env                 = "qa"
    instance_count      = 2
    es_kms_key_id       = "${module.es-kms.key_id}"
    create_iam_service_linked_role = "false"
}