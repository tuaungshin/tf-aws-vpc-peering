
##################
#EC2 A Security Group
##################

resource "aws_security_group" "ec2_a_sg" {
  name   = "ec2-a-sg"
  vpc_id = aws_vpc.vpc_a.id
  description = "EC2 A Security Group"

  # Ping from VPC B
  ingress {
    description = "ICMP from peer VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.1.0.0/16"]
  }

  # HTTP outbound to VPCE
  egress {
    description = "HTTPS outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # All outbound internal
  egress {
    description = "All outbound internal"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  }

  #########################
#EC2 B Security Group
##################

resource "aws_security_group" "ec2_b_sg" {
  name   = "ec2-b-sg"
  vpc_id = aws_vpc.vpc_b.id
  description = "EC2 B Security Group"

  # Ping from VPC A
  ingress {
    description = "ICMP from peer VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # HTTP outbound to VPCE
  egress {
    description = "HTTPS outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # All outbound internal
  egress {
    description = "All outbound internal"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  }

  ##################
  # VPCE SG for VPC A
  ##################

resource "aws_security_group" "vpce_sg_a" {
  name   = "vpce-sg-a"
  vpc_id = aws_vpc.vpc_a.id


## Allow inbound HTTPS traffic 
## from EC2 instances to the VPC Endpoint
  ingress {
    description = "Allow HTTPS from EC2 instances to VPC Endpoint"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # better: restrict to VPC CIDR
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

##################
#VPCE SG for VPC B
##################
resource "aws_security_group" "vpce_sg_b" {
  name   = "vpce-sg-b"
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