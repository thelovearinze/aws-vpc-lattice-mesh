# Fetch current AWS Account ID dynamically
data "aws_caller_identity" "current" {}

# ------------------------------------------------------------------------------
# 1. TGW Peering: Virginia (Hub) -> London (Spoke)
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_peering_attachment" "peer_va_ldn" {
  transit_gateway_id      = aws_ec2_transit_gateway.tgw_va.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.tgw_ldn.id
  peer_region             = "eu-west-2"
  peer_account_id         = data.aws_caller_identity.current.account_id
  tags = { Name = "tgw-peer-va-to-ldn" }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "accept_ldn" {
  provider                      = aws.london
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.peer_va_ldn.id
  tags = { Name = "tgw-peer-ldn-to-va" }
}

# ------------------------------------------------------------------------------
# 2. TGW Peering: Virginia (Hub) -> Cape Town (Spoke)
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_peering_attachment" "peer_va_ct" {
  transit_gateway_id      = aws_ec2_transit_gateway.tgw_va.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.tgw_ct.id
  peer_region             = "af-south-1"
  peer_account_id         = data.aws_caller_identity.current.account_id
  tags = { Name = "tgw-peer-va-to-ct" }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "accept_ct" {
  provider                      = aws.capetown
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.peer_va_ct.id
  tags = { Name = "tgw-peer-ct-to-va" }
}