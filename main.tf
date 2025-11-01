# Create VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpcCIDRblock
  instance_tenancy = "default"

  tags = {
    Name = var.vpcname
  }
}

# Create Public Subnet
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.publicSubnetCIDRblock
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-pub"
  }
}

# Create Private Subnet
resource "aws_subnet" "subnet_22" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.privateSubnetCIDRblock

  tags = {
    Name = "subnet-piv"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "gatewaySid" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "sid-gateway"
  }
}

# Create Public Route Table (for Internet access)
resource "aws_route_table" "pub_table" {
  vpc_id = aws_vpc.main.id

  # ✅ Correct route: send all outbound traffic (0.0.0.0/0) to the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gatewaySid.id
  }

  tags = {
    Name = "sid_public_route"
  }
}

# Create Private Route Table (for internal routing or future NAT)
resource "aws_route_table" "pri_table" {
  vpc_id = aws_vpc.main.id

  # ✅ Usually private routes don’t go directly to Internet Gateway.
  # If you have a NAT Gateway later, replace `nat_gateway_id` below.
  # For now, leave this empty or comment it out.
  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.nat.id
  # }

  tags = {
    Name = "sid_private_route"
  }
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.subnet_22.id
  route_table_id = aws_route_table.pri_table.id
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.pub_table.id
}
