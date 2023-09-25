module "msk-kms" {
    source   = "../../modules/kms-cmk"

    aws-account = "889283944499"
    corect-kms-name = "msk-cmk-qa"
    env             = "qa"

}