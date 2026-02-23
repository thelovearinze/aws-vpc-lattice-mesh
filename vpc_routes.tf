# ------------------------------------------------------------------------------
# 1. VIRGINIA VPC Routes
# ------------------------------------------------------------------------------
resource "aws_route" "va_to_ldn_vpc" {
  route_table_id         = aws_vpc.virginia.main_route_table_id
  destination_cidr_block = aws_vpc.london.cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_va.id
}

resource "aws_route" "va_to_ct_vpc" {
  route_table_id         = aws_vpc.virginia.main_route_table_id
  destination_cidr_block = aws_vpc.capetown.cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_va.id
}

# ------------------------------------------------------------------------------
# 2. LONDON VPC Routes
# ------------------------------------------------------------------------------
resource "aws_route" "ldn_to_va_vpc" {
  provider               = aws.london
  route_table_id         = aws_vpc.london.main_route_table_id
  destination_cidr_block = aws_vpc.virginia.cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_ldn.id
}

# ------------------------------------------------------------------------------
# 3. CAPE TOWN VPC Routes
# ------------------------------------------------------------------------------
resource "aws_route" "ct_to_va_vpc" {
  provider               = aws.capetown
  route_table_id         = aws_vpc.capetown.main_route_table_id
  destination_cidr_block = aws_vpc.virginia.cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_ct.id
}