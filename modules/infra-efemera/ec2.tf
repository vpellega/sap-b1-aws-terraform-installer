resource "aws_instance" "sap_b1_server" {
  count = var.criar_instancia_ec2 ? 1 : 0 # Cria a instância apenas se habilitado

  # Configurações básicas da instância
  ami                  = data.aws_ami.windows_2019_base.id # Windows_Server-2019-English-Full-Base-2024.12.13
  instance_type        = "t3.large"                        # Tipo de instância para servidor SAP B1
  key_name             = aws_key_pair.sap_key.key_name      
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = base64encode(file("${path.module}/scripts/ec2/startup.ps1"))

  # Configuração de rede
  subnet_id                   = data.aws_subnet.selected_public.id
  associate_public_ip_address = true                        # Atribui IP público à instância
  vpc_security_group_ids      = [aws_security_group.sap_b1_sg.id]

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 60                              # Suficiente pra Windows + SAP
    delete_on_termination = true

    tags = {
      Name    = "${var.project_name}-${var.environment}-root-volume"
      Purpose = "Disco do SO + SAP"
    }
  }

  # Metadados da instância
  tags = merge(
    { Name = "${var.project_name}-${var.environment}-server" },
    { (var.instance_tag_key) = var.instance_tag_value }
  )
}

resource "null_resource" "debug_boot_logs" {
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