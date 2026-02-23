# ------------------------------------------------------------------------------
# EC2 Instance Connect Endpoints (Zero-Trust Access)
# ------------------------------------------------------------------------------
resource "aws_ec2_instance_connect_endpoint" "va_eice" {
  subnet_id          = aws_subnet.virginia_sub1.id
  preserve_client_ip = false
  tags = { Name = "lattice-eice-va" }
}

resource "aws_ec2_instance_connect_endpoint" "ldn_eice" {
  provider           = aws.london
  subnet_id          = aws_subnet.london_sub1.id
  preserve_client_ip = false
  tags = { Name = "lattice-eice-ldn" }
}

resource "aws_ec2_instance_connect_endpoint" "ct_eice" {
  provider           = aws.capetown
  subnet_id          = aws_subnet.capetown_sub1.id
  preserve_client_ip = false
  tags = { Name = "lattice-eice-ct" }
}