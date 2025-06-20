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
    cidr_blocks = [var.allowed_ip_cidr]
  }

  # SAP B1 Server Manager (40000-40010)
  ingress {
    description = "SAP B1 Server Manager"
    from_port   = 40000
    to_port     = 40010
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip_cidr]
  }

  # SAP B1 Core Services (ex: License Manager, DI API)
  ingress {
    description = "SAP B1 Core Services"
    from_port   = 30000
    to_port     = 30015
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip_cidr]
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

resource "aws_security_group" "sap_b1_rds_sg" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Permitir acesso da EC2 ao RDS SQL Server"
  vpc_id      = data.aws_vpc.default.id

  # SG EC2 Sap Server
  ingress {
    description = "Allow EC2 access on SQL Server port"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    security_groups = [aws_security_group.sap_b1_sg.id]
  }

  ingress {
    description = "Allow developer IP on SQL Server port"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  }
}