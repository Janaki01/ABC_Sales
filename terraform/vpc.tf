resource "aws_vpc" "etl_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags       = { 
    Name = "etl-vpc" 
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.etl_vpc.id
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.etl_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.etl_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  }
# resource "aws_subnet" "private_subnet_1" {
#     vpc_id = aws_vpc.etl_vpc.id
#     cidr_block = "10.0.2.0/24"
#     availability_zone = "ap-south-1a"
# }
# resource "aws_subnet" "private_subnet_2" {
#     vpc_id = aws_vpc.etl_vpc.id
#     cidr_block = "10.0.3.0/24"
#     availability_zone = "ap-south-1b"
# }
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.etl_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}
