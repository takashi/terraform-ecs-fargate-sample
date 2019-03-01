## NAT
resource "aws_eip" "nat" {
  count = "${length(split(",", lookup(var.common, "default.availability_zones", var.common["default.availability_zones"])))}"

  vpc = true

  lifecycle {
    create_before_destroy = true
  }
}

## NAT Gateway
resource "aws_nat_gateway" "nat" {
  count = "${length(split(",", lookup(var.common, "default.availability_zones", var.common["default.availability_zones"])))}"

  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.nat.*.id, count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}
