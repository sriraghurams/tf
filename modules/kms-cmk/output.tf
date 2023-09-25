output "key_id" {
    value   = aws_kms_key.corect-cmk.arn
    description = "ARN of KMS key"
}