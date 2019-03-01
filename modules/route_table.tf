## Route Table NAT
resource "aws_route_table" "nat" {
  count = "${length(split(",", lookup(var.common, "default.availability_zones", var.common["default.availability_zones"])))}"

  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  }

  tags {
    Name        = "${var.name}-${terraform.workspace}-rtb-nat"
    Environment = "${terraform.workspace}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

## Route Table IGW
resource "aws_route_table" "igw" {
  count = "${length(split(",", lookup(var.common, "default.availability_zones", var.common["default.availability_zones"])))}"

  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name        = "${var.name}-${terraform.workspace}-rtb-igw"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(split(",", lookup(var.common, "default.availability_zones", var.common["default.availability_zones"])))}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.igw.*.id, count.index)}"
}

## NAT Route Table と RDS Subnetの関連付け
resource "aws_route_table_association" "rds" {
  count = "${length(split(",", lookup(var.common, "default.availability_zones", var.common["default.availability_zones"])))}"

  subnet_id      = "${element(aws_subnet.rds.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.nat.*.id, count.index)}"
}

## IGW Route Table と NAT Gatewayの関連付け
resource "aws_route_table_association" "nat" {
  count = "${length(split(",", lookup(var.common, "default.availability_zones", var.common["default.availability_zones"])))}"

  subnet_id      = "${element(aws_subnet.nat.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.igw.*.id, count.index)}"
}

resource "aws_route_table_association" "bastion" {
  subnet_id      = "${aws_subnet.bastion.id}"
  route_table_id = "${element(aws_route_table.igw.*.id, count.index)}"
}
