# =========================
# VPC A
# =========================
resource "aws_vpc" "vpc_a" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-a"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.vpc_a.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "subnet-a"
  }
}

resource "aws_route_table" "rt_a" {
  vpc_id = aws_vpc.vpc_a.id

  tags = {
    Name = "rt-a"
  }
}

resource "aws_route_table_association" "rta_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.rt_a.id
}

# =========================
# VPC B
# =========================
resource "aws_vpc" "vpc_b" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "vpc-b"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.vpc_b.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "subnet-b"
  }
}

resource "aws_route_table" "rt_b" {
  vpc_id = aws_vpc.vpc_b.id

  tags = {
    Name = "rt-b"
  }
}

resource "aws_route_table_association" "rta_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.rt_b.id
}

