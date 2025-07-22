resource "aws_instance" "sap_b1_server" {
  count = var.criar_instancia_ec2 ? 1 : 0

  # Configurações básicas da instância
  ami                  = data.aws_ami.windows_2019_base.id
  instance_type        = "t3.large"
  key_name             = aws_key_pair.sap_key.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = base64encode(file("${path.module}/scripts/ec2/startup.ps1"))

  # Configuração de rede
  subnet_id                   = data.aws_subnet.selected_public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sap_b1_server_sg.id]

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 60
    delete_on_termination = true
  }

  # Metadados da instância
  tags = merge(
    { Name = "${var.project_name}-${var.environment}-server" },
    { (var.instance_tag_key) = var.instance_tag_value }
  )
}

resource "aws_instance" "sap_b1_client" {
  count = var.criar_instancia_ec2 ? 1 : 0

  ami                         = data.aws_ami.windows_2019_base.id
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.sap_key.key_name
  subnet_id                   = data.aws_subnet.selected_public.id
  associate_public_ip_address = false

  vpc_security_group_ids = [aws_security_group.sap_b1_server_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name

  root_block_device {
    volume_size           = 50
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = merge(
    { Name = "${var.project_name}-${var.environment}-client" },
    { (var.instance_tag_key) = var.instance_tag_value }
  )
}

resource "aws_instance" "sql_server_express" {
  count = var.criar_instancia_ec2 ? 1 : 0

  ami                         = data.aws_ami.windows_2022_base.id
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.sap_key.key_name
  subnet_id                   = data.aws_subnet.selected_public.id
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.sql_express_sg.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  root_block_device {
    volume_size           = 50
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = merge(
    { Name = "${var.project_name}-${var.environment}-sql" },
    { (var.instance_tag_key) = var.instance_tag_value }
  )
}

resource "null_resource" "debug_boot_logs" {
  count = var.criar_instancia_ec2 ? 1 : 0

  provisioner "local-exec" {
    command = <<EOT
      aws ec2 get-console-output \
        --instance-id ${aws_instance.sap_b1_server[0].id} \
        --output text \
    EOT
  }

  triggers = {
    instance_id = aws_instance.sap_b1_server[0].id
  }
}