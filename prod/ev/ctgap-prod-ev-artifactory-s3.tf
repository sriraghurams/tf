module "s3-ev-artifactory" {
    source   = "../../modules/s3"

    bucket-version = false
    env            = "prod"
    corect-bucket-name = "ctgap-prod-ev-artifactory"
    policy-file    = "ev-artifactory-bucket-prod-policy"

}