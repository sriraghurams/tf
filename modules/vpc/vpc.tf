resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_subnet" "private-subnets" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.azs)
  availability_zone = "${lookup(var.zones, format("zone%d", count.index))}"
  cidr_block = element(var.private-subnets , count.index)

  tags = {
    Name = "${var.env}-private-subnet-${count.index+1}"
  }
}

resource "aws_subnet" "db-private-subnets" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.azs)
  availability_zone = "${lookup(var.zones, format("zone%d", count.index))}"
  cidr_block = element(var.db-private-subnets , count.index)

  tags = {
    Name = "${var.env}-db-private-subnet-${count.index+1}"
  }
}

resource "aws_subnet" "dataprocessing-private-subnets" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.azs)
  availability_zone = "${lookup(var.zones, format("zone%d", count.index))}"
  cidr_block = element(var.dataprocessing-private-subnets , count.index)

  tags = {
    Name = "${var.env}-dataprocessing-private-subnet-${count.index+1}"
  }
}

resource "aws_subnet" "public-subnets" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.azs)
  availability_zone = "${lookup(var.zones, format("zone%d", count.index))}"
  cidr_block = element(var.public-subnets , count.index)

  tags = {
    Name = "${var.env}-public-subnet-${count.index+1}"
  }
}

#IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-igw"
  }
}

#route table for public subnet
resource "aws_route_table" "public-rtable" {
  vpc_id = aws_vpc.vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public-rtable"
  }

  depends_on = [aws_internet_gateway.igw]
}



#route table association public subnets
resource "aws_route_table_association" "public-subnet-association" {
  count          = length(var.public-subnets)
  subnet_id      = element(aws_subnet.public-subnets.*.id , count.index)
  route_table_id = aws_route_table.public-rtable.id
}



# Elastic IP for NAT Gateway
resource "aws_eip" "nat-eip" {
  vpc      = true
  count = length(var.azs)
  
  tags = {
    Name = "${var.env}-eip-nat-${count.index+1}"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = element(aws_eip.nat-eip.*.id, count.index)
  subnet_id = element(aws_subnet.public-subnets.*.id, count.index)
  count = length(var.azs)

  tags = {
    Name = "${var.env}-nat-gateway-${count.index+1}"
  }
}


#route table for private subnet
resource "aws_route_table" "private-rtable" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.azs)

  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = element(aws_nat_gateway.nat-gateway.*.id, count.index)
  }

  tags = {
    Name = "${var.env}-private-rtable-${count.index+1}"
  }

  depends_on = [aws_nat_gateway.nat-gateway]
}


#route table association private subnets
resource "aws_route_table_association" "private-subnet-association" {
  count          = length(var.private-subnets)
  subnet_id      = element(aws_subnet.private-subnets.*.id , count.index)
  route_table_id = element(aws_route_table.private-rtable.*.id, count.index)
}

resource "aws_route_table_association" "dataprocessing-private-subnet-association" {
  count          = length(var.dataprocessing-private-subnets)
  subnet_id      = element(aws_subnet.dataprocessing-private-subnets.*.id , count.index)
  route_table_id = element(aws_route_table.private-rtable.*.id, count.index)
}

resource "aws_route_table_association" "db-private-subnet-association" {
  count          = length(var.db-private-subnets)
  subnet_id      = element(aws_subnet.db-private-subnets.*.id , count.index)
  route_table_id = element(aws_route_table.private-rtable.*.id, count.index)
}
# VPC flow logs

resource "aws_flow_log" "vpc-flow-logs" {
  iam_role_arn    = aws_iam_role.vpc-flow-logs-role.arn
  log_destination = aws_cloudwatch_log_group.vpc-flow-log-group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id
}

resource "aws_cloudwatch_log_group" "vpc-flow-log-group" {
  name = "${var.env}-vpc-flow-logs"
}

resource "aws_iam_role" "vpc-flow-logs-role" {
  name = "${var.env}-vpc-flow-logs"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc-flow-logs" {
  name = "example"
  role = aws_iam_role.vpc-flow-logs-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Create NACL

resource "aws_network_acl" "nacl" {
  vpc_id = aws_vpc.vpc.id
  subnet_ids = [for s in concat(aws_subnet.public-subnets, aws_subnet.private-subnets, aws_subnet.dataprocessing-private-subnets, aws_subnet.db-private-subnets): s.id]
  depends_on = [aws_subnet.public-subnets, aws_subnet.private-subnets]

 #Allow ingress all traffic
 
ingress {
    protocol   = -1
    rule_no    = 1
    action     = "allow"
    cidr_block = "${var.gap-vpc-cidr}"
    from_port  = 0
    to_port    = 0
  }

ingress {
    protocol   = -1
    rule_no    = 2
    action     = "allow"
    cidr_block = "${var.ev-vpc-cidr}"
    from_port  = 0
    to_port    = 0
  }

ingress {
    protocol   = -1
    rule_no    = 3
    action     = "allow"
    cidr_block = "${var.smartpath-vpc-cidr}"
    from_port  = 0
    to_port    = 0
  }

ingress {
    protocol   = -1
    rule_no    = 4
    action     = "allow"
    cidr_block = "${var.chatbot-vpc-cidr}"
    from_port  = 0
    to_port    = 0
  }

ingress {
    protocol   = -1
    rule_no    = 5
    action     = "allow"
    cidr_block = "${var.analytics-vpc-cidr}"
    from_port  = 0
    to_port    = 0
  }

ingress {
    protocol   = -1
    rule_no    = 6
    action     = "allow"
    cidr_block = "${var.evintegration-vpc-cidr}"
    from_port  = 0
    to_port    = 0
  }



ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  
  # allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0" 
    from_port  = 80
    to_port    = 80
  }
  
  # allow ingress port 443 
  ingress {
    protocol   = "tcp"
    rule_no    = 201
    action     = "allow"
    cidr_block = "0.0.0.0/0" 
    from_port  = 443
    to_port    = 443
  }
  
  # allow ingress ephemeral ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "udp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  
  
  # allow egress all traffic
 
  egress {
    protocol   = -1
    rule_no    = 1
    action     = "allow"
    cidr_block = "${var.gap-vpc-cidr}"
    from_port  = 0
    to_port    = 0
  }
  
  egress {
    protocol   = -1
    rule_no    = 2
    action     = "allow"
    cidr_block = "${var.ev-vpc-cidr}"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 3
    action     = "allow"
    cidr_block = "${var.smartpath-vpc-cidr}"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 4
    action     = "allow"
    cidr_block = "${var.chatbot-vpc-cidr}"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 5
    action     = "allow"
    cidr_block = "${var.analytics-vpc-cidr}"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 6
    action     = "allow"
    cidr_block = "${var.evintegration-vpc-cidr}"
    from_port  = 0
    to_port    = 0
  }
  # allow egress port 22 
  egress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22 
    to_port    = 22
  }
  
  # allow egress port 80 
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80  
    to_port    = 80 
  }
  
   # allow egress port 443 
  egress {
    protocol   = "tcp"
    rule_no    = 201
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443  
    to_port    = 443 
  }
 
  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = "udp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  tags = {
    Name = "${var.env}-nacl"
  }
}


# VPC endpoint for S3

resource "aws_vpc_endpoint" "s3-endpoint" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
  route_table_ids = ["${aws_route_table.public-rtable.id}", "${aws_route_table.private-rtable[0].id}" , "${aws_route_table.private-rtable[1].id}" ]
  #route_table_ids = ["${aws_route_table.public-rtable.id}", "${aws_route_table.private-rtable.id}"]
  #route_table_ids = ["aws_route_table.public-rtable.id", "aws_route_table.private-rtable.id"]
  #route_table_ids = element(concat(aws_route_table.private-rtable.*.id, [""]), 0)
  depends_on = [aws_route_table.public-rtable, aws_route_table.private-rtable]
  policy = <<POLICY
{
    "Statement": [
        {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*"
        }
    ]
}
POLICY

  tags = {
    Name = "${var.env}-s3-vpc-endpoint",
    Environment = "${var.environment}"
  }
}

# VPC endpoint for Dynamo db


resource "aws_vpc_endpoint" "dynamodb-endpoint" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.dynamodb"
  route_table_ids = ["${aws_route_table.public-rtable.id}", "${aws_route_table.private-rtable[0].id}" , "${aws_route_table.private-rtable[1].id}" ]
  depends_on = [aws_route_table.public-rtable, aws_route_table.private-rtable]
  policy = <<POLICY
{
    "Statement": [
        {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*"
        }
    ]
}
POLICY

  tags = {
    Name = "${var.env}-dynamodb-vpc-endpoint",
    Environment = "${var.environment}"
  }
}
