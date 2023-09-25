module "scchargestart-sns" {
    source   = "../../modules/sns"

    sns-topic-name             = "ev-prod-use-schedulecharge-start-sns"
    env                        = "prod"
}