# ------------------------------------------------------------------------------
# 1. VIRGINIA Routing (Hub)
# ------------------------------------------------------------------------------
# Route to London
resource "aws_ec2_transit_gateway_route" "va_to_ldn" {
  destination_cidr_block         = aws_vpc.london.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.peer_va_ldn.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw_va.association_default_route_table_id
}

# Route to Cape Town
resource "aws_ec2_transit_gateway_route" "va_to_ct" {
  destination_cidr_block         = aws_vpc.capetown.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.peer_va_ct.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw_va.association_default_route_table_id
}

# ------------------------------------------------------------------------------
# 2. LONDON Routing (Spoke)
# ------------------------------------------------------------------------------
# Route back to Virginia
resource "aws_ec2_transit_gateway_route" "ldn_to_va" {
  provider                       = aws.london
  destination_cidr_block         = aws_vpc.virginia.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.peer_va_ldn.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw_ldn.association_default_route_table_id
}

# ------------------------------------------------------------------------------
# 3. CAPE TOWN Routing (Spoke)
# ------------------------------------------------------------------------------
# Route back to Virginia
resource "aws_ec2_transit_gateway_route" "ct_to_va" {
  provider                       = aws.capetown
  destination_cidr_block         = aws_vpc.virginia.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.peer_va_ct.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw_ct.association_default_route_table_id
}