resource "aws_instance" "monitoring" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet
  vpc_security_group_ids      = [var.security_group_id]
  user_data                   = file("../../modules/compute/scripts/userdata.sh")
  key_name                    = var.key_pair_name
  associate_public_ip_address = true

  tags = {
    Name = "${var.env_01}-monitoring-server"
  }
}