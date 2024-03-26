resource "aws_vpc" "main_vpc" {
  cidr_block           = local.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

# resource "aws_subnet" "private_subnet" {
#   vpc_id     = aws_vpc.main_vpc.id
#   cidr_block = local.private_subnet.cidr
#   tags = {
#     Name = "${terraform.workspace}-${local.private_subnet.subnet_name}"
#   }
# }

# resource "aws_route_table" "rt_private_subnet" {
#   vpc_id = aws_vpc.main_vpc.id

#   tags = {
#     Name = "${terraform.workspace}-rt"
#   }

# }
# resource "aws_route_table_association" "rta_private_subnet" {
#   subnet_id      = aws_subnet.private_subnet.id
#   route_table_id = aws_route_table.rt_private_subnet.id
# }


resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = local.public_subnet.cidr
  tags = {
    Name = "${terraform.workspace}-${local.public_subnet.subnet_name}"
  }
}

resource "aws_internet_gateway" "ig_public_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${terraform.workspace}-ig_public_subnet"
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_public_subnet.id
  }

  tags = {
    Name = "${terraform.workspace}-rt_public"
  }

}

resource "aws_route_table_association" "rta_public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt_public.id
}
