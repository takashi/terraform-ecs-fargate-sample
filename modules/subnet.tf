
# Public
resource "aws_subnet" "public" {
  count = "${length(split(",", lookup(var.common, "default.availability_zones", var.common["default.availability_zones"])))}"

  availability_zone       = "${element(split(",", lookup(var.common, "default.availability_zones", var.common["default.availability_zones"])), count.index)}"
  cidr_block              = "${element(split(",", lookup(var.subnets, "${terraform.env}.public", var.subnets["default.public"])), count.index)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-subnet-public-${count.index}"
    Environment = "${terraform.workspace}"
  }
}

### NAT
resource "aws_subnet" "nat" {
  count = "${length(split(",", lookup(var.common, "default.availability_zones", var.common["default.availability_zones"])))}"

  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${element(split(",", lookup(var.subnets, "${terraform.env}.nat", var.subnets["default.nat"])), count.index)}"
  availability_zone       = "${element(split(",", lookup(var.common, "default.availability_zones", var.common["default.availability_zones"])), count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.name}-subnet-nat-${count.index}"
    Environment = "${terraform.workspace}"
  }
}

### Bastion
resource "aws_subnet" "bastion" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${lookup(var.subnets, "${terraform.env}.bastion", var.subnets["default.bastion"])}"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags {
    Name        = "${var.name}-subnet-bastion"
    Environment = "${terraform.env}"
  }
}

# Private
resource "aws_subnet" "rds" {
  count = "${length(split(",", lookup(var.common, "default.availability_zones", var.common["default.availability_zones"])))}"

  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${element(split(",", lookup(var.subnets, "${terraform.env}.rds", var.subnets["default.rds"])), count.index)}"
  availability_zone       = "${element(split(",", lookup(var.common, "default.availability_zones", var.common["default.availability_zones"])), count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name        = "${var.name}-subnet-rds-${count.index}"
    Environment = "${terraform.workspace}"
  }
}
