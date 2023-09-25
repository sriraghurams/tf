 module "econnect-adapter-payloads-sns" {
    source   = "../../modules/sns"

    sns-topic-name             = "ev-prod-use-econnect-adapter-payloads-sns"
    env                        = "prod"
}