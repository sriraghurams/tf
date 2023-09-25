module "msk" {
    source     = "../../modules/msk"

    vpc_id                    = "${module.development.vpc_id}"
    msk_sg_name               = "o32D-sg-development"
    cidr                      = ["10.211.0.0/16"]
    loggroup_name             = "o32D-loggroup-development"
    msk_cluster_name          = "o32D-cluster-development"
    kafka_version             = "2.6.2"
    number_of_broker_nodes    = 2
    instance_type             =  "kafka.m5.large"
    ebs_volume_size           = 200
    private_subnets           = "${module.development.private_subnets}"
    msk_kms_id                = "${module.msk-kms.key_id}"
    env                       = "development"
    scaling_max_capacity      = 1024
    scaling_target_value      = 80

}