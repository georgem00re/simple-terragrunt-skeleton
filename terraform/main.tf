
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

resource "aws_vpc" "example" {
  cidr_block = "192.0.0.0/16"
}
