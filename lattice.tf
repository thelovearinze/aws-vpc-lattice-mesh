# ------------------------------------------------------------------------------
# 1. US EAST (Virginia) - Lattice Network
# ------------------------------------------------------------------------------
resource "aws_vpclattice_service_network" "virginia_mesh" {
  name      = "global-mesh-us-east"
  auth_type = "NONE" 
}

resource "aws_vpclattice_service_network_vpc_association" "virginia_assoc" {
  vpc_identifier             = aws_vpc.virginia.id
  service_network_identifier = aws_vpclattice_service_network.virginia_mesh.id
}

# ------------------------------------------------------------------------------
# 2. EUROPE (London) - Lattice Network
# ------------------------------------------------------------------------------
resource "aws_vpclattice_service_network" "london_mesh" {
  provider  = aws.london
  name      = "global-mesh-eu-west"
  auth_type = "NONE"
}

resource "aws_vpclattice_service_network_vpc_association" "london_assoc" {
  provider                   = aws.london
  vpc_identifier             = aws_vpc.london.id
  service_network_identifier = aws_vpclattice_service_network.london_mesh.id
}

# ------------------------------------------------------------------------------
# 3. AFRICA (Cape Town) - Lattice Network
# ------------------------------------------------------------------------------
resource "aws_vpclattice_service_network" "capetown_mesh" {
  provider  = aws.capetown
  name      = "global-mesh-af-south"
  auth_type = "NONE"
}

resource "aws_vpclattice_service_network_vpc_association" "capetown_assoc" {
  provider                   = aws.capetown
  vpc_identifier             = aws_vpc.capetown.id
  service_network_identifier = aws_vpclattice_service_network.capetown_mesh.id
}