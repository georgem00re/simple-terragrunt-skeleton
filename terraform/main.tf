
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

locals {
  vpc_name = "${var.environment}-vpc"
}

resource "aws_vpc" "this" {
  cidr_block = "192.0.0.0/16"

  tags = {
    Name = local.vpc_name
  }
}
