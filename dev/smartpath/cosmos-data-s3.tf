module "s3-smartpath-cosmos-data-s3" {
    source   = "../../modules/s3"

    bucket-version = false
    env            = "dev"
    corect-bucket-name = "ctgap-dev-smartpath-cosmos-data"
    policy-file    = "ctgap-smartpath-cosmos-data-dev-policy"

}