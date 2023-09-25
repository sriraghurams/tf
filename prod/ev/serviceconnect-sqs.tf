
module "scchargestart-sqs" {
    source   = "../../modules/sqs"

    terraform-queue-deadletter = "ctgap-scchargestart-sqs-dlq-prod"
    terraform-queue            = "ctgap-scchargestart-sqs-prod"
    policy-file                = "gap-sqs-scchargestart-prod-policy"
    env                        = "prod"
}