

####################
## VPC endoint for VPC A
####################


##1-SSM Endpoint

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.vpc_a.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.subnet_a.id]
  security_group_ids = [aws_security_group.vpce_sg_a.id]

  private_dns_enabled = true
}

###2-EC2 Messages Endpoint

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.vpc_a.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.subnet_a.id]
  security_group_ids = [aws_security_group.vpce_sg_a.id]

  private_dns_enabled = true
}

###3-SSM Messages Endpoint

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.vpc_a.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.subnet_a.id]
  security_group_ids = [aws_security_group.vpce_sg_a.id]

  private_dns_enabled = true
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
  security_group_ids = [aws_security_group.vpce_sg_b.id]

  private_dns_enabled = true
}

###2-EC2 Messages Endpoint

resource "aws_vpc_endpoint" "ec2messages_b" {
  vpc_id            = aws_vpc.vpc_b.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.subnet_b.id]
  security_group_ids = [aws_security_group.vpce_sg_b.id]

  private_dns_enabled = true
}

###3-SSM Messages Endpoint

resource "aws_vpc_endpoint" "ssmmessages_b" {
  vpc_id            = aws_vpc.vpc_b.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = [aws_subnet.subnet_b.id]
  security_group_ids = [aws_security_group.vpce_sg_b.id]

  private_dns_enabled = true
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
  name = "my-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name
}
