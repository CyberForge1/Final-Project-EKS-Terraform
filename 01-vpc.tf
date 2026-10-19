resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  # Needed for EFS: pods mount it by its DNS name (fs-xxxx.efs.<region>.amazonaws.com)
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}
