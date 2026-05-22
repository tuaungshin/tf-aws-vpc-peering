

####################
## VPC endoint for VPC A
####################


##1-SSM Endpoint

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.vpc_a.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.subnet_a.id]
  security_group_ids = [aws_security_group.ssm_endpoint_sg.id]

  private_dns_enabled = true
}

###2-EC2 Messages Endpoint

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.vpc_a.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.subnet_a.id]
  security_group_ids = [aws_security_group.ssm_endpoint_sg.id]

  private_dns_enabled = true
}

###3-SSM Messages Endpoint

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.vpc_a.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.subnet_a.id]
  security_group_ids = [aws_security_group.ssm_endpoint_sg.id]

  private_dns_enabled = true
}



###Security group SSM
resource "aws_security_group" "ssm_endpoint_sg" {
  name   = "ssm-endpoint-sg"
  vpc_id = aws_vpc.vpc_a.id


## Allow inbound HTTPS traffic to the VPC Endpoint
  ingress {
    description = "Allow HTTPS from EC2 instances to VPC Endpoint"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # better: restrict to VPC CIDR
  }

# Allow outbound traffic from the VPC Endpoint
# to anywhere on any port and protocol
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




####################
## VPC endoint for VPC B
####################

##1-SSM Endpoint

resource "aws_vpc_endpoint" "ssm_b" {
  vpc_id            = aws_vpc.vpc_b.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.subnet_b.id]
  security_group_ids = [aws_security_group.ssm_endpoint_sg_b.id]

  private_dns_enabled = true
}

###2-EC2 Messages Endpoint

resource "aws_vpc_endpoint" "ec2messages_b" {
  vpc_id            = aws_vpc.vpc_b.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.subnet_b.id]
  security_group_ids = [aws_security_group.ssm_endpoint_sg_b.id]

  private_dns_enabled = true
}

###3-SSM Messages Endpoint

resource "aws_vpc_endpoint" "ssmmessages_b" {
  vpc_id            = aws_vpc.vpc_b.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.subnet_b.id]
  security_group_ids = [aws_security_group.ssm_endpoint_sg_b.id]

  private_dns_enabled = true
}


###########################
###Security group vpc endpoint
############################
resource "aws_security_group" "vpc_endpoint_sg_b" {
  name   = "vpc-endpoint-sg-b"
  vpc_id = aws_vpc.vpc_b.id


## Allow inbound HTTPS traffic 
## from EC2 instances to the VPC Endpoint
  ingress {
    description = "Allow HTTPS from EC2 instances to VPC Endpoint"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"] # better: restrict to VPC CIDR
  }


# Allow outbound traffic from the VPC Endpoint
# to AWS services
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#################################
###Security group - EC2 instance
#####################################

resource "aws_security_group" "ec2_sg_b" {
  name            = "ec2-sg-b"
  vpc_id          = aws_vpc.vpc_b.id
  description     = "Allow outbound traffic from EC2 instances"

  # Allow outbound HTTPS traffic
  # from EC2 instances to SSM VPC Endpoints
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################
# IAM Role for SSM
# #################
resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
###################
## iam role attachment
###################
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
#################
## profile
#################
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-ssm-profile3"
  role = aws_iam_role.ec2_ssm_role.name
}
