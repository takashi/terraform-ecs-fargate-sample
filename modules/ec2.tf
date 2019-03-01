data "aws_ami" "amazon_linux2" {
 most_recent = true


 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}
## Bastion
resource "aws_instance" "bastion" {
  ami           = "${data.aws_ami.amazon_linux2.id}"
  instance_type = "t2.nano"
  key_name      = "${terraform.workspace}"

  vpc_security_group_ids = [
    "${aws_security_group.bastion.id}",
  ]

  subnet_id                   = "${aws_subnet.bastion.id}"
  associate_public_ip_address = true

  root_block_device = {
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags {
    Name        = "${var.name}-bastion"
    Environment = "${terraform.workspace}"
  }

  user_data = <<EOS
        #cloud-config
        hostname: "bastion"
        timezone: "Asia/Tokyo"
EOS
}
