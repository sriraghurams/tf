module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~> 2.0"

  name        = "${var.env}-gap-tgw"
  description = "My TGW shared with several other AWS accounts"

  enable_auto_accept_shared_attachments = true

  vpc_attachments = {
    vpc = {
      vpc_id       = var.vpc-id
      subnet_ids   = var.private-subnets-ids
      dns_support  = true
      ipv6_support = false

      tgw_routes = [
        {
          destination_cidr_block = "${var.gap-smartpath-nonprod-vpc-cidr}"
        }
      ]
    }
  }
  amazon_side_asn               = var.amazon_side_asn
  ram_allow_external_principals = true
  ram_principals = ["${var.cross-account-id}"]

  tags = merge(
    var.default_tags,
    {
      Name = "${var.env}--gap-tgw"
      Env = var.env
    },
  )
}

# Update NACL

resource "aws_network_acl_rule" "private_nacl_ingress" {
  network_acl_id = var.network_acl_id
  rule_number    = 500
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "${var.ct-smartpath-nonprod-vpc-cidr}"
}

resource "aws_network_acl_rule" "private_nacl_egress" {
  network_acl_id = var.network_acl_id
  rule_number    = 500
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "${var.ct-smartpath-nonprod-vpc-cidr}"
}

#Update Private subnet route tables

resource "aws_route" "private_route_tables" {
  count                          = length(var.private_route_table_ids)
  route_table_id            = "${element("${var.private_route_table_ids}", count.index)}"
  destination_cidr_block    = var.ct-smartpath-nonprod-vpc-cidr
  transit_gateway_id        = module.tgw.ec2_transit_gateway_id
}


resource "aws_route" "vpc_main_route_table" {
  route_table_id            = var.vpc_main_route_table_id
  destination_cidr_block    = var.ct-smartpath-nonprod-vpc-cidr
  transit_gateway_id        = module.tgw.ec2_transit_gateway_id
}