# public network
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  # AWSのDNSサーバーによる名前解決を有効にする
  enable_dns_support   = true
  # ホスト名を自動で割り当てる
  enable_dns_hostnames = true
  tags                 = {
    Name = "example"
  }
}

# subnet
resource "aws_subnet" "public_0" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.example.id
  # 起動時にパブリックIPアドレスを自動で割り当てる
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
}

resource "aws_subnet" "public_1" {
  cidr_block              = "10.0.2.0/24"
  vpc_id                  = aws_vpc.example.id
  # 起動時にパブリックIPアドレスを自動で割り当てる
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1c"
}


# gateway
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

# route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
}

# route
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0" # デフォルトルート
}

# route table association
resource "aws_route_table_association" "public_0" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_0.id
}
resource "aws_route_table_association" "public_1" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_1.id
}

# private network
resource "aws_subnet" "private_0" {
  cidr_block              = "10.0.65.0/24" # publicなsubnetとは別にする
  vpc_id                  = aws_vpc.example.id
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private_1" {
  cidr_block              = "10.0.66.0/24" # publicなsubnetとは別にする
  vpc_id                  = aws_vpc.example.id
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
}

resource "aws_route_table" "private_0" {
  vpc_id = aws_vpc.example.id
}
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table_association" "private_0" {
  route_table_id = aws_route_table.private_0.id
  subnet_id      = aws_subnet.private_0.id
}
resource "aws_route_table_association" "private_1" {
  route_table_id = aws_route_table.private_1.id
  subnet_id      = aws_subnet.private_1.id
}

# NAT
resource "aws_eip" "nat_gateway_0" {
  vpc        = true
  depends_on = [aws_internet_gateway.example]
}
resource "aws_eip" "nat_gateway_1" {
  vpc        = true
  depends_on = [aws_internet_gateway.example]
}

resource "aws_nat_gateway" "nat_gateway_0" {
  allocation_id = aws_eip.nat_gateway_0.id
  subnet_id     = aws_subnet.public_0.id
  depends_on    = [aws_internet_gateway.example]
}
resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id     = aws_subnet.public_1.id
  depends_on    = [aws_internet_gateway.example]
}

resource "aws_route" "private_0" {
  route_table_id         = aws_route_table.private_0.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_0.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_1" {
  route_table_id         = aws_route_table.private_1.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1.id
  destination_cidr_block = "0.0.0.0/0"
}