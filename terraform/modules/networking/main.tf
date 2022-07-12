resource "aws_vpc" "polkadot" {
  cidr_block              = "${ var.cidr_block }"
  enable_dns_hostnames    = true

  tags = {
    Name                  = "${var.vpc_name_tag}"
  }
}

resource "aws_subnet" "polkadot" {
  cidr_block = "${cidrsubnet(aws_vpc.polkadot.cidr_block, 3, 1)}"
  vpc_id                  = "${ aws_vpc.polkadot.id }"
  availability_zone       = var.availability_zone
  
  map_public_ip_on_launch = true
}
