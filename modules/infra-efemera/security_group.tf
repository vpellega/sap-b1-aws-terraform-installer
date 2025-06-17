resource "aws_security_group" "sap_b1_sg" {
  name_prefix = "${var.project_name}-${var.environment}-"
  description = "Security Group para SAP Business One"
  vpc_id      = data.aws_vpc.default.id

  # RDP (Remote Desktop Protocol)
  ingress {
    description = "RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SAP B1 Server Manager (40000-40010)
  ingress {
    description = "SAP B1 Server Manager"
    from_port   = 40000
    to_port     = 40010
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Saída irrestrita
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name        = "${var.project_name}-${var.environment}-sg"
  }
}