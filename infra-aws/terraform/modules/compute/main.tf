resource "aws_instance" "monitoring" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet
  vpc_security_group_ids      = [var.security_group_id]
  user_data                   = file("../../modules/compute/scripts/userdata.sh")
  key_name                    = var.key_pair_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "${var.env_01}-monitoring-server"
  }
}

resource "aws_iam_role" "ec2_secrets" {
  name = "${var.env_01}-ec2-secrets-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_policy" {
  role       = aws_iam_role.ec2_secrets.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.env_01}-ec2-profile"
  role = aws_iam_role.ec2_secrets.name
}