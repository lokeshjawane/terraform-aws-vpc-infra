resource "aws_nat_gateway" "main_autosubnet" {
  count         = length(var.external_subnets) == 0 ? 1 : 0
  allocation_id = aws_eip.nat-ip.id
  subnet_id     = element(aws_subnet.external_autosubnet.*.id, 1)
  depends_on = [
    aws_internet_gateway.main,
    aws_subnet.external_autosubnet,
  ]

  tags = {
    Name = "${var.environment}-${var.vpc_name}-nat-gw"
  }
}

/*
create subnet with auto calculation
*/

data "aws_availability_zones" "available" {
  state = "available"
}

data "external" "subnetbit" {
  program = ["python3", "${path.module}/script/subnetbit.py", "-b ${var.subnet_count * 2}"]
}

resource "aws_subnet" "internal_autosubnet" {
  count  = length(var.internal_subnets) == 0 ? var.subnet_count : 0
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(
    var.vpc_cidr,
    data.external.subnetbit.result["subnetbits"],
    count.index,
  )
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "${var.environment}-${var.vpc_name}-private-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_subnet" "external_autosubnet" {
  count  = length(var.external_subnets) == 0 ? var.subnet_count : 0
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(
    var.vpc_cidr,
    data.external.subnetbit.result["subnetbits"],
    count.index + var.subnet_count,
  )
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "${var.environment}-${var.vpc_name}-public-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

/**
 * Route tables
 */

resource "aws_route" "internal_autosubnet" {
  count                  = length(var.external_subnets) == 0 ? 1 : 0
  route_table_id         = aws_route_table.internal.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main_autosubnet[0].id
}

/**
 * Route associations
 */

resource "aws_route_table_association" "internal_autosubnet" {
  count          = length(var.internal_subnets) == 0 ? var.subnet_count : 0
  subnet_id      = element(aws_subnet.internal_autosubnet.*.id, count.index)
  route_table_id = aws_route_table.internal.id
  depends_on     = [aws_subnet.internal_autosubnet]
}

resource "aws_route_table_association" "external_autosubnet" {
  count          = length(var.external_subnets) == 0 ? var.subnet_count : 0
  subnet_id      = element(aws_subnet.external_autosubnet.*.id, count.index)
  route_table_id = aws_route_table.external.id
  depends_on     = [aws_subnet.external_autosubnet]
}

