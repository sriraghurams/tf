resource "aws_iam_role_policy_attachment" "gap-developer-policy-attach" {
  role     = "ctgap-dev-role"
  policy_arn = aws_iam_policy.gap-developer-policy.arn
}

resource "aws_iam_policy" "gap-developer-policy" {
  name        = "${var.gap-iam-policy}"
  path        = "/"
  description = "CT GAP developer policy Created by Teraform"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "NotAction": [
                "iam:*",
                "organizations:*",
                "account:*",
                "ec2:CreateVpc*",
                "ec2:DeleteVpc*",
                "ec2:ModifyVpc*",
                "ec2:Create*",
                "ec2:Modify*",
                "eks:Delete*",
                "kafka-cluster:Delete*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:GenerateCredentialReport",
                "iam:GenerateServiceLastAccessedDetails",
                "iam:PassRole",
                "iam:Get*",
                "iam:List*",
                "iam:SimulateCustomPolicy",
                "iam:SimulatePrincipalPolicy",
                "iam:CreateServiceLinkedRole",
                "iam:DeleteServiceLinkedRole",
                "iam:ListRoles",
                "organizations:DescribeOrganization",
                "account:ListRegions",
                "ec2:CreateInstance*",
                "ec2:Create*Template*",
                "ec2:CreateKeyPair",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:CreateSnapshot*",
                "ec2:CreateImage",
                "ec2:CreateFleet",
                "ec2:CreateVolume",
                "ec2:ModifyVolume",
                "ec2:ModifyFleet",
                "ec2:Modify*Template*",
                "ec2:ModifySecurityGroup*",
                "ec2:ModifyImage*",
                "ec2:ModifyInstance*",
                "eks:*",
                "kafka-cluster:*",
                "ec2:Describe*",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeCarrierGateways",
                "ec2:DescribeClassicLinkInstances",
                "ec2:DescribeCustomerGateways",
                "ec2:DescribeDhcpOptions",
                "ec2:DescribeEgressOnlyInternetGateways",
                "ec2:DescribeFlowLogs",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeLocalGatewayRouteTables",
                "ec2:DescribeLocalGatewayRouteTableVpcAssociations",
                "ec2:DescribeMovingAddresses",
                "ec2:DescribeNatGateways",
                "ec2:DescribeNetworkAcls",
                "ec2:DescribeNetworkInterfaceAttribute",
                "ec2:DescribeNetworkInterfacePermissions",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribePrefixLists",
                "ec2:DescribeRouteTables",
                "ec2:DescribeSecurityGroupReferences",
                "ec2:DescribeSecurityGroupRules",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeStaleSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeVpcClassicLink",
                "ec2:DescribeVpcClassicLinkDnsSupport",
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeVpcEndpointConnectionNotifications",
                "ec2:DescribeVpcEndpointConnections",
                "ec2:DescribeVpcEndpointServiceConfigurations",
                "ec2:DescribeVpcEndpointServicePermissions",
                "ec2:DescribeVpcEndpointServices",
                "ec2:DescribeVpcPeeringConnections",
                "ec2:DescribeVpcs",
                "ec2:DescribeVpnConnections",
                "ec2:DescribeVpnGateways",
                "ec2:DescribeSubnet*",
                "ec2:ModifyHosts"
            ],
            "Resource": "*"
        }
    ]
})

 tags = {
    Terraform              = "true"
    Project                = "Core-Gap"
    Env                    = "${var.env}"
    Name                   = "${var.gap-iam-policy}"
    ApplicationId          = "APM0004691"
    ApplicationName        = "CT-Gap"
    TerraformScriptVersion = "0.13.6"
    CoreID                 = "5510120030"
    DeptID                 = "957200"
    ProjectID              = "OCT-0100-09-01-01-0008"
    CreatedBy              = "Core-gap team member"
    BU                     = "CT"
    Project                = "CoreGAP"
  } 
}
