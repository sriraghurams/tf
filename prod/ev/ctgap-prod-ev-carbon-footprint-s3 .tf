module "s3-ev-carbon-footprint" {
    source   = "../../modules/s3"

    bucket-version = false
    env            = "prod"
    corect-bucket-name = "ctgap-prod-ev-carbon-footprint"
    policy-file    = "ctgap-prod-ev-carbon-footprint-policy"

}