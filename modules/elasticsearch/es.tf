
resource "aws_security_group" "es" {
  name        = "${var.env}-elasticsearch-${var.domain}-sg"
  description = "Managed by Terraform"
  vpc_id      = var.vpc_id

  ingress {
      from_port = 0
      to_port = 0
      protocol = -1
      self      = true
  } 
}

resource "aws_iam_service_linked_role" "es" {
  count            = "${var.enabled == "true" && var.create_iam_service_linked_role == "true" ? 1 : 0}"
  aws_service_name = "es.amazonaws.com"
}
resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.domain
  elasticsearch_version = "7.10"
 

  cluster_config {
    instance_type = var.instance_type
    instance_count = var.instance_count
    zone_awareness_enabled  = true
  }
  snapshot_options {
    automated_snapshot_start_hour = 23
  }
  vpc_options {
    # subnet_ids = ["${var.subnet_ids[0]}", "${var.subnet_ids[1]}" ]
    subnet_ids = "${ var.env != "prod" ? ["${var.subnet_ids[0]}", "${var.subnet_ids[1]}" ]  : ["${var.subnet_ids[0]}", "${var.subnet_ids[1]}", "${var.subnet_ids[2]}" ] }"
    security_group_ids = [aws_security_group.es.id]
  }
  ebs_options {
    ebs_enabled = var.ebs_volume_size > 0 ? true : false
    volume_size = var.ebs_volume_size
    volume_type = var.volume_type
  }
  encrypt_at_rest {
    enabled    = true
    kms_key_id = var.es_kms_key_id
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.es.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }
  node_to_node_encryption {
     enabled = true
  }
  depends_on = [aws_iam_service_linked_role.es]
  tags = merge(
    var.default_tags,
    {
      Name = var.domain
      Domain = var.domain
    },
  )

}


resource "aws_elasticsearch_domain_policy" "main" {
  domain_name = aws_elasticsearch_domain.es.domain_name
  access_policies = <<POLICIES
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "${aws_elasticsearch_domain.es.arn}/*"
        }
    ]
}
POLICIES
}

resource "aws_cloudwatch_log_group" "es" {
  name = "${var.env}-elasticsearch-${var.domain}-loggroup"
}

resource "aws_cloudwatch_log_resource_policy" "es" {
  policy_name = "${var.env}-elasticsearch-${var.domain}-policy"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}