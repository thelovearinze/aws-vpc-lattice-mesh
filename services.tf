# ------------------------------------------------------------------------------
# 1. US EAST (Virginia) - Lattice Service
# ------------------------------------------------------------------------------
resource "aws_vpclattice_target_group" "va_tg" {
  name = "va-app-tg"
  type = "INSTANCE"
  config {
    vpc_identifier = aws_vpc.virginia.id
    port           = 80
    protocol       = "HTTP"
  }
}

resource "aws_vpclattice_target_group_attachment" "va_tg_attach" {
  target_group_identifier = aws_vpclattice_target_group.va_tg.id
  target {
    id   = aws_instance.app_va.id
    port = 80
  }
}

resource "aws_vpclattice_service" "va_svc" {
  name      = "va-app-service"
  auth_type = "NONE"
}

resource "aws_vpclattice_listener" "va_listener" {
  name               = "va-http-listener"
  protocol           = "HTTP"
  port               = 80
  service_identifier = aws_vpclattice_service.va_svc.id
  default_action {
    forward {
      target_groups {
        target_group_identifier = aws_vpclattice_target_group.va_tg.id
        weight                  = 100
      }
    }
  }
}

resource "aws_vpclattice_service_network_service_association" "va_svc_assoc" {
  service_identifier         = aws_vpclattice_service.va_svc.id
  service_network_identifier = aws_vpclattice_service_network.virginia_mesh.id
}

# ------------------------------------------------------------------------------
# 2. EUROPE (London) - Lattice Service
# ------------------------------------------------------------------------------
resource "aws_vpclattice_target_group" "ldn_tg" {
  provider = aws.london
  name     = "ldn-app-tg"
  type     = "INSTANCE"
  config {
    vpc_identifier = aws_vpc.london.id
    port           = 80
    protocol       = "HTTP"
  }
}

resource "aws_vpclattice_target_group_attachment" "ldn_tg_attach" {
  provider                = aws.london
  target_group_identifier = aws_vpclattice_target_group.ldn_tg.id
  target {
    id   = aws_instance.app_ldn.id
    port = 80
  }
}

resource "aws_vpclattice_service" "ldn_svc" {
  provider  = aws.london
  name      = "ldn-app-service"
  auth_type = "NONE"
}

resource "aws_vpclattice_listener" "ldn_listener" {
  provider           = aws.london
  name               = "ldn-http-listener"
  protocol           = "HTTP"
  port               = 80
  service_identifier = aws_vpclattice_service.ldn_svc.id
  default_action {
    forward {
      target_groups {
        target_group_identifier = aws_vpclattice_target_group.ldn_tg.id
        weight                  = 100
      }
    }
  }
}

resource "aws_vpclattice_service_network_service_association" "ldn_svc_assoc" {
  provider                   = aws.london
  service_identifier         = aws_vpclattice_service.ldn_svc.id
  service_network_identifier = aws_vpclattice_service_network.london_mesh.id
}

# ------------------------------------------------------------------------------
# 3. AFRICA (Cape Town) - Lattice Service
# ------------------------------------------------------------------------------
resource "aws_vpclattice_target_group" "ct_tg" {
  provider = aws.capetown
  name     = "ct-app-tg"
  type     = "INSTANCE"
  config {
    vpc_identifier = aws_vpc.capetown.id
    port           = 80
    protocol       = "HTTP"
  }
}

resource "aws_vpclattice_target_group_attachment" "ct_tg_attach" {
  provider                = aws.capetown
  target_group_identifier = aws_vpclattice_target_group.ct_tg.id
  target {
    id   = aws_instance.app_ct.id
    port = 80
  }
}

resource "aws_vpclattice_service" "ct_svc" {
  provider  = aws.capetown
  name      = "ct-app-service"
  auth_type = "NONE"
}

resource "aws_vpclattice_listener" "ct_listener" {
  provider           = aws.capetown
  name               = "ct-http-listener"
  protocol           = "HTTP"
  port               = 80
  service_identifier = aws_vpclattice_service.ct_svc.id
  default_action {
    forward {
      target_groups {
        target_group_identifier = aws_vpclattice_target_group.ct_tg.id
        weight                  = 100
      }
    }
  }
}

resource "aws_vpclattice_service_network_service_association" "ct_svc_assoc" {
  provider                   = aws.capetown
  service_identifier         = aws_vpclattice_service.ct_svc.id
  service_network_identifier = aws_vpclattice_service_network.capetown_mesh.id
}