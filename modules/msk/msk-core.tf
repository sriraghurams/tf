resource "aws_security_group" "sg" {
  vpc_id = var.vpc_id
  name        = var.msk_sg_name
  description = "msk sg"
  

  ingress {
      from_port = 0
      to_port = 0
      protocol = -1
      self = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(
    var.default_tags,
    {
      Name = var.msk_sg_name
      Env = var.env
    },
  )
  
}

resource "aws_cloudwatch_log_group" "msk-loggroup" {
  name = var.loggroup_name
  tags = merge(
    var.default_tags,
    {
      Name = var.loggroup_name
      Env = var.env
    },
  )
}

resource "aws_msk_cluster" "msk" {
  cluster_name           = var.msk_cluster_name
  kafka_version          = var.kafka_version 
  number_of_broker_nodes = var.number_of_broker_nodes
  enhanced_monitoring = "PER_BROKER"
  

  broker_node_group_info {
    instance_type   = var.instance_type
    ebs_volume_size = var.ebs_volume_size
    client_subnets = var.private_subnets
    security_groups = [aws_security_group.sg.id]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = var.msk_kms_id
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.msk-loggroup.name
      }
 
    #   firehose {
    #     enabled         = true
    #     delivery_stream = aws_kinesis_firehose_delivery_stream.test_stream.name
    #   }
    #   s3 {
    #     enabled = true
    #     bucket  = aws_s3_bucket.bucket.id
    #     prefix  = "logs/msk-"
    #   }
    }
  }

  tags = merge(
    var.default_tags,
    {
      Env = var.env
    },
  )
}


resource "aws_appautoscaling_target" "kafka_storage" {
  max_capacity       = var.scaling_max_capacity
  min_capacity       = 1
  resource_id        = aws_msk_cluster.msk.arn
  scalable_dimension = "kafka:broker-storage:VolumeSize"
  service_namespace  = "kafka"
}

resource "aws_appautoscaling_policy" "kafka_broker_scaling_policy" {
  name               = "${var.msk_cluster_name}-broker-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_msk_cluster.msk.arn
  scalable_dimension = aws_appautoscaling_target.kafka_storage.scalable_dimension
  service_namespace  = aws_appautoscaling_target.kafka_storage.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "KafkaBrokerStorageUtilization"
    }

    target_value = var.scaling_target_value
  }
}

