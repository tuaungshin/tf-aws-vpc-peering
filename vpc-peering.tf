# =========================
# VPC Peering
# =========================
resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = aws_vpc.vpc_a.id
  peer_vpc_id = aws_vpc.vpc_b.id
  auto_accept = true

  tags = {
    Name = "vpc-a-to-vpc-b"
  }
}

# =========================
# Route from VPC A -> VPC B
# =========================
resource "aws_route" "route_a_to_b" {
  route_table_id            = aws_route_table.rt_a.id
  destination_cidr_block    = aws_vpc.vpc_b.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# =========================
# Route from VPC B -> VPC A
# =========================
resource "aws_route" "route_b_to_a" {
  route_table_id            = aws_route_table.rt_b.id
  destination_cidr_block    = aws_vpc.vpc_a.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}