module "s3-smartpath-cosmos-data-s3" {
    source   = "../../modules/s3"

    bucket-version = false
    env            = "qa"
    corect-bucket-name = "ctgap-qa-smartpath-cosmos-data"
    policy-file    = "ctgap-smartpath-cosmos-data-qa-policy"

}