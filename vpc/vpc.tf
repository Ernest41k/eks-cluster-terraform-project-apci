resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block

    tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-main-vpc"
  })
}

# CREATING INTERNET GATEWAY--------------------------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-igw"
  })
}

# CREATING FRONTEND SUBNETS------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "frontend_subnet1" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.subnet_cidr_block[0]
  availability_zone = var.availability_zone[0]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["kubernetes.io/role/elb"]}-${var.tags["kubernetes.io/cluster/my-eks-cluster"]}-${var.tags["application"]}-${var.tags["environment"]}-frontend-subnet1"
  })
}

resource "aws_subnet" "frontend_subnet2" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.subnet_cidr_block[1]
  availability_zone = var.availability_zone[1]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["kubernetes.io/role/elb"]}-${var.tags["kubernetes.io/cluster/my-eks-cluster"]}-${var.tags["application"]}-${var.tags["environment"]}-frontend-subnet2"
  })
}

# CREATING PUBLIC ROUTE TABLE-------------------------------------------------------------------------------------------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-rt"
  })
}


# CREATING PUBLIC ROUTE TABLE ASSOCIATION FOR FRONTEND SUBNETS-----------------------------------------------------------------------------------------------------------------
resource "aws_route_table_association" "frontend_subnet_az_1a" {
  subnet_id      = aws_subnet.frontend_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "frontend_subnet2" {
  subnet_id      = aws_subnet.frontend_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

#######################################################################################################################################
# CREATING BACKEND SUBNETS-------------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "backend_subnet1" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.subnet_cidr_block[2]
  availability_zone = var.availability_zone[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-backend-subnet1"
  })
}

resource "aws_subnet" "backend_subnet2" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.subnet_cidr_block[3]
  availability_zone = var.availability_zone[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-backend-subnet2"
  })
}

# CREATING AN ELASTIC IP FOR NAT GATEWAY IN AZ-1A--------------------------------------------------------------------------------------------------------------------------
resource "aws_eip" "eip_nat_az1a" {
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-eip-nat-az1a"
  })
}

# CREATING A NAT GATEWAY---------------------------------------------------------------------------------------------------------------------------
resource "aws_nat_gateway" "nat_gw_az1a" {
  allocation_id = aws_eip.eip_nat_az1a.id
  subnet_id     = aws_subnet.frontend_subnet1.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw-azla"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.eip_nat_az1a, aws_subnet.frontend_subnet1]
}

# CREATING AN ELASTIC IP FOR NAT GATEWAY IN AZ-1B--------------------------------------------------------------------------------------------------------------------------
resource "aws_eip" "eip_nat_az1b" {
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-eip-nat-az1b"
  })
}

# CREATING A NAT GATEWAY---------------------------------------------------------------------------------------------------------------------------
resource "aws_nat_gateway" "nat_gw_az1b" {
  allocation_id = aws_eip.eip_nat_az1b.id
  subnet_id     = aws_subnet.frontend_subnet2.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw-azlb"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.eip_nat_az1b, aws_subnet.frontend_subnet2]
}

# CREATING A PRIVATE ROUTE TABLE FOR AVAILABILITY ZONE 1A-----------------------------------------------------------------------------------------------------------------------
resource "aws_route_table" "private_rt_az1a" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_az1a.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt-az1a"
  })
}

# CREATING ROUTE TABLE ASSOCIATION FOR BACKEND SUBNETS IN AZ-1A---------------------------------------------------------------------------------------------------------------
resource "aws_route_table_association" "backend_subnet1_association" {
  subnet_id      = aws_subnet.backend_subnet1.id
  route_table_id = aws_route_table.private_rt_az1a.id
}

# CREATING A PRIVATE ROUTE TABLE FOR AVAILABILITY ZONE 1B-----------------------------------------------------------------------------------------------------------------------
resource "aws_route_table" "private_rt_az1b" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_az1b.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt-az1b"
  })
}

# CREATING ROUTE TABLE ASSOCIATION FOR BACKEND SUBNETS IN AZ-1B---------------------------------------------------------------------------------------------------------------
resource "aws_route_table_association" "backend_subnet2_association" {
  subnet_id      = aws_subnet.backend_subnet2.id
  route_table_id = aws_route_table.private_rt_az1a.id
}
