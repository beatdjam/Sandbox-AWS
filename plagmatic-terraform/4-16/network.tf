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
resource "aws_subnet" "public" {
  cidr_block              = "10.0.0.0/24"
  vpc_id                  = aws_vpc.example.id
  # 起動時にパブリックIPアドレスを自動で割り当てる
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
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
resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id
}

# private network
resource "aws_subnet" "private" {
  cidr_block              = "10.0.64.0/24" # publicなsubnetとは別にする
  vpc_id                  = aws_vpc.example.id
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private.id
}

# NAT
resource "aws_eip" "nat_gateway" {
  vpc        = true
  depends_on = [aws_internet_gateway.example]
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.example]
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}