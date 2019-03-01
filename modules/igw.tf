## Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.name}-${terraform.workspace}-igw"
    Environment = "${terraform.workspace}"
  }
}
