terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Default Provider (US East - N. Virginia)
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project     = "Global-Service-Mesh"
      Environment = "Production"
      ManagedBy   = "Terraform"
    }
  }
}

# Aliased Provider (Europe - London)
provider "aws" {
  alias  = "london"
  region = "eu-west-2"
  default_tags {
    tags = {
      Project     = "Global-Service-Mesh"
      Environment = "Production"
      ManagedBy   = "Terraform"
    }
  }
}

# Aliased Provider (Africa - Cape Town)
provider "aws" {
  alias  = "capetown"
  region = "af-south-1"
  default_tags {
    tags = {
      Project     = "Global-Service-Mesh"
      Environment = "Production"
      ManagedBy   = "Terraform"
    }
  }
}