resource "aws_sqs_queue" "terraform_queue_deadletter" {
  name = "${var.terraform-queue-deadletter}"
  delay_seconds = 90
  max_message_size = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  kms_master_key_id                 = "alias/corect-sqs-cmk"
  kms_data_key_reuse_period_seconds = 300
}

resource "aws_sqs_queue" "terraform_queue" {
  name                      = "${var.terraform-queue}"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
    maxReceiveCount     = 10
  })
  
  kms_master_key_id                 = "alias/corect-sqs-cmk"
  kms_data_key_reuse_period_seconds = 300
  policy = file("../../files/${var.env}/${var.policy-file}.json")
#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Id": "${var.terraform-queue}-policy",
#   "Statement": [
#     {
#       "Sid": "AllowReadDelete_machine_479bba97-90d5-4056-b2fd-0ee755c56dd3",
#       "Effect": "Allow",
#       "Principal": {
#          "AWS": [
#             "964097472649",
#             "875228066049",
#             "389004169067",
#             "168207703603"
#          ]
#       },
#       "Action": [
#         "sqs:ReceiveMessage",
#         "sqs:SendMessage"
#       ],
#       "Resource": "arn:aws:sqs:us-east-1:889283944499:ctgap-serviceconnect-sqs-nonprod"
#     }
#   ]
# }
# POLICY

}

