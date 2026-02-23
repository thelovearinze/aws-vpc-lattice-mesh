# ------------------------------------------------------------------------------
# 1. US EAST (Virginia) - Compute
# ------------------------------------------------------------------------------
data "aws_ami" "amazon_linux_va" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_security_group" "app_sg_va" {
  name        = "lattice-app-sg-va-v4"
  description = "Allow HTTP from Global Mesh and SSH from VPC"
  vpc_id      = aws_vpc.virginia.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/16", "172.17.0.0/16", "172.18.0.0/16"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.virginia.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "app_va" {
  ami                    = data.aws_ami.amazon_linux_va.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.virginia_sub1.id
  vpc_security_group_ids = [aws_security_group.app_sg_va.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Primary Hub - us-east-1</h1>" > /var/www/html/index.html
              EOF

  tags = { Name = "lattice-app-us-east" }
}

# ------------------------------------------------------------------------------
# 2. EUROPE (London) - Compute
# ------------------------------------------------------------------------------
data "aws_ami" "amazon_linux_ldn" {
  provider    = aws.london
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_security_group" "app_sg_ldn" {
  provider    = aws.london
  name        = "lattice-app-sg-ldn-v4"
  description = "Allow HTTP from Global Mesh and SSH from VPC"
  vpc_id      = aws_vpc.london.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/16", "172.17.0.0/16", "172.18.0.0/16"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.london.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "app_ldn" {
  provider               = aws.london
  ami                    = data.aws_ami.amazon_linux_ldn.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.london_sub1.id
  vpc_security_group_ids = [aws_security_group.app_sg_ldn.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Failover Hub - eu-west-2</h1>" > /var/www/html/index.html
              EOF

  tags = { Name = "lattice-app-eu-west" }
}

# ------------------------------------------------------------------------------
# 3. AFRICA (Cape Town) - Compute
# ------------------------------------------------------------------------------
data "aws_ami" "amazon_linux_ct" {
  provider    = aws.capetown
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_security_group" "app_sg_ct" {
  provider    = aws.capetown
  name        = "lattice-app-sg-ct-v4"
  description = "Allow HTTP from Global Mesh and SSH from VPC"
  vpc_id      = aws_vpc.capetown.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/16", "172.17.0.0/16", "172.18.0.0/16"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.capetown.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "app_ct" {
  provider               = aws.capetown
  ami                    = data.aws_ami.amazon_linux_ct.id
  instance_type          = "t3.micro" 
  subnet_id              = aws_subnet.capetown_sub1.id
  vpc_security_group_ids = [aws_security_group.app_sg_ct.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Edge Region - af-south-1</h1>" > /var/www/html/index.html
              EOF

  tags = { Name = "lattice-app-af-south" }
}