data "aws_availability_zones" "available" {}

# ディレクトリを分割して管理する場合は下記のようにファイルを分ける
# data "terraform_remote_state" "network" {
#   backend = "s3"

#   config {
#     bucket = "doujou-terraform"
#     key    = "network/terraform.tfstate"
#     region = "ap-northeast-1"
#   }
# }

#----------------------
# Main vpc
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${aws_vpc.doujou.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.doujou_dhcp.id}"

  depends_on = [
    "aws_route53_zone.private",
  ]
}

resource "aws_vpc_dhcp_options" "doujou_dhcp" {
  domain_name         = "${aws_route53_zone.private.name}"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags {
    Name = "${var.PROJECT_NAME} DHCP"
  }
}

resource "aws_vpc" "doujou" {
  cidr_block = "${var.VPC_CIDR_BLOCK}"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.PROJECT_NAME}-vpc"
  }
}

#----------------------
# public subnet
# multi-AZ archtechture
resource "aws_subnet" "public_0" {
  # vpc_id = "${data.terraform_remote_state.network.doujou_vpc_id}"
  vpc_id                  = "${aws_vpc.doujou.id}"
  cidr_block              = "${var.VPC_PUBLIC_SUBNET1_CIDR_BLOCK}"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.PROJECT_NAME}-vpc-public-subnet-0"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = "${aws_vpc.doujou.id}"
  cidr_block              = "${var.VPC_PUBLIC_SUBNET2_CIDR_BLOCK}"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.PROJECT_NAME}-vpc-public-subnet-1"
  }
}

#----------------------
# internet gateway
# connection between vpc and innternet, because vpc is isolated virtual network
resource "aws_internet_gateway" "doujou" {
  vpc_id = "${aws_vpc.doujou.id}"

  tags = {
    Name = "${var.PROJECT_NAME}-vpc-internet-gateway"
  }
}

#----------------------
# route table
resource "aws_route_table" "doujou_public" {
  vpc_id = "${aws_vpc.doujou.id}"

  tags = {
    Name = "${var.PROJECT_NAME}-route-table-public"
  }
}

#----------------------
# route definition
resource "aws_route" "public" {
  route_table_id = "${aws_route_table.doujou_public.id}"
  gateway_id     = "${aws_internet_gateway.doujou.id}"

  # dafault route for connect internet via internet gateway
  destination_cidr_block = "0.0.0.0/0"
}

#----------------------
# associate public subnet with route table
resource "aws_route_table_association" "public_0" {
  subnet_id = "${aws_subnet.public_0.id}"

  # caution! not aws_route! aws_route_table! route is not object
  route_table_id = "${aws_route_table.doujou_public.id}"
}

resource "aws_route_table_association" "public_1" {
  subnet_id = "${aws_subnet.public_1.id}"

  # caution! not aws_route! aws_route_table! route is not object
  route_table_id = "${aws_route_table.doujou_public.id}"
}

#----------------------
# private subnet 1
resource "aws_subnet" "private_0" {
  vpc_id            = "${aws_vpc.doujou.id}"
  cidr_block        = "${var.VPC_PRIVATE_SUBNET1_CIDR_BLOCK}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "${var.PROJECT_NAME}-vpc-private-subnet-0"
  }
}

# private subnet 2
resource "aws_subnet" "private_1" {
  vpc_id            = "${aws_vpc.doujou.id}"
  cidr_block        = "${var.VPC_PRIVATE_SUBNET2_CIDR_BLOCK}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "${var.PROJECT_NAME}-vpc-private-subnet-1"
  }
}

#----------------------
# private network route table
# multi-AZ

resource "aws_route_table" "doujou_private_0" {
  vpc_id = "${aws_vpc.doujou.id}"

  tags = {
    Name = "${var.PROJECT_NAME}-route-table-private-0"
  }
}

resource "aws_route_table" "doujou_private_1" {
  vpc_id = "${aws_vpc.doujou.id}"

  tags = {
    Name = "${var.PROJECT_NAME}-route-table-private-1"
  }
}

#----------------------
# private route definition
# multi-AZ

resource "aws_route" "doujou_private_0" {
  route_table_id = "${aws_route_table.doujou_private_0.id}"
  nat_gateway_id = "${aws_nat_gateway.nat_gateway_0.id}"

  # default route go towards nat gateway
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "doujou_private_1" {
  route_table_id = "${aws_route_table.doujou_private_1.id}"
  nat_gateway_id = "${aws_nat_gateway.nat_gateway_1.id}"

  # default route go towards nat gateway
  destination_cidr_block = "0.0.0.0/0"
}

#----------------------
# assosiate route table with subnet
# multi-AZ
resource "aws_route_table_association" "private_0" {
  subnet_id      = "${aws_subnet.private_0.id}"
  route_table_id = "${aws_route_table.doujou_private_0.id}"
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = "${aws_subnet.private_1.id}"
  route_table_id = "${aws_route_table.doujou_private_1.id}"
}

#----------------------
# nat(natwork address translation) gateway
# EIP is static public ip address
# multi-AZ

resource "aws_eip" "nat_gateway_0" {
  vpc = true

  # create eip after internet gateway
  depends_on = ["aws_internet_gateway.doujou"]

  tags = {
    Name = "eip-0"
  }
}

resource "aws_eip" "nat_gateway_1" {
  vpc = true

  # create eip after internet gateway
  depends_on = ["aws_internet_gateway.doujou"]

  tags = {
    Name = "eip-1"
  }
}

resource "aws_nat_gateway" "nat_gateway_0" {
  allocation_id = "${aws_eip.nat_gateway_0.id}"

  # nat gateway allocate in public subnet
  subnet_id  = "${aws_subnet.public_0.id}"
  depends_on = ["aws_internet_gateway.doujou"]

  tags = {
    Name = "nat-gateway-0"
  }
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = "${aws_eip.nat_gateway_1.id}"

  # nat gateway allocate in public subnet
  subnet_id  = "${aws_subnet.public_1.id}"
  depends_on = ["aws_internet_gateway.doujou"]

  tags = {
    Name = "nat-gateway-1"
  }
}
