# ------------------------------------------------------------------------------
# 1. US EAST (Virginia) - Transit Gateway Backbone
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway" "tgw_va" {
  description                     = "Global Backbone - US East"
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  tags = { Name = "lattice-tgw-us-east" }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach_va" {
  subnet_ids         = [aws_subnet.virginia_sub1.id, aws_subnet.virginia_sub2.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_va.id
  vpc_id             = aws_vpc.virginia.id
  tags = { Name = "lattice-tgw-attach-us-east" }
}

# ------------------------------------------------------------------------------
# 2. EUROPE (London) - Transit Gateway Backbone
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway" "tgw_ldn" {
  provider                        = aws.london
  description                     = "Global Backbone - EU West"
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  tags = { Name = "lattice-tgw-eu-west" }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach_ldn" {
  provider           = aws.london
  subnet_ids         = [aws_subnet.london_sub1.id, aws_subnet.london_sub2.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_ldn.id
  vpc_id             = aws_vpc.london.id
  tags = { Name = "lattice-tgw-attach-eu-west" }
}

# ------------------------------------------------------------------------------
# 3. AFRICA (Cape Town) - Transit Gateway Backbone
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway" "tgw_ct" {
  provider                        = aws.capetown
  description                     = "Global Backbone - AF South"
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  tags = { Name = "lattice-tgw-af-south" }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach_ct" {
  provider           = aws.capetown
  subnet_ids         = [aws_subnet.capetown_sub1.id, aws_subnet.capetown_sub2.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_ct.id
  vpc_id             = aws_vpc.capetown.id
  tags = { Name = "lattice-tgw-attach-af-south" }
}