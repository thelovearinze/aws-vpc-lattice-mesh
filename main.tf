# ------------------------------------------------------------------------------
# 1. US EAST (Virginia) - Primary Hub
# ------------------------------------------------------------------------------
resource "aws_vpc" "virginia" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "lattice-mesh-us-east" }
}

resource "aws_subnet" "virginia_sub1" {
  vpc_id            = aws_vpc.virginia.id
  cidr_block        = "172.16.1.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "lattice-sub-us-east-1a" }
}

resource "aws_subnet" "virginia_sub2" {
  vpc_id            = aws_vpc.virginia.id
  cidr_block        = "172.16.2.0/24"
  availability_zone = "us-east-1b"
  tags = { Name = "lattice-sub-us-east-1b" }
}

# ------------------------------------------------------------------------------
# 2. EUROPE (London) - Failover Hub
# ------------------------------------------------------------------------------
resource "aws_vpc" "london" {
  provider             = aws.london
  cidr_block           = "172.17.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "lattice-mesh-eu-west" }
}

resource "aws_subnet" "london_sub1" {
  provider          = aws.london
  vpc_id            = aws_vpc.london.id
  cidr_block        = "172.17.1.0/24"
  availability_zone = "eu-west-2a"
  tags = { Name = "lattice-sub-eu-west-2a" }
}

resource "aws_subnet" "london_sub2" {
  provider          = aws.london
  vpc_id            = aws_vpc.london.id
  cidr_block        = "172.17.2.0/24"
  availability_zone = "eu-west-2b"
  tags = { Name = "lattice-sub-eu-west-2b" }
}

# ------------------------------------------------------------------------------
# 3. AFRICA (Cape Town) - Edge Region
# ------------------------------------------------------------------------------
resource "aws_vpc" "capetown" {
  provider             = aws.capetown
  cidr_block           = "172.18.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "lattice-mesh-af-south" }
}

resource "aws_subnet" "capetown_sub1" {
  provider          = aws.capetown
  vpc_id            = aws_vpc.capetown.id
  cidr_block        = "172.18.1.0/24"
  availability_zone = "af-south-1a"
  tags = { Name = "lattice-sub-af-south-1a" }
}

resource "aws_subnet" "capetown_sub2" {
  provider          = aws.capetown
  vpc_id            = aws_vpc.capetown.id
  cidr_block        = "172.18.2.0/24"
  availability_zone = "af-south-1b"
  tags = { Name = "lattice-sub-af-south-1b" }
}