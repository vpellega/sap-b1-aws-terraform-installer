data "aws_ami" "windows_2019_base" {
  most_recent = true
  owners      = ["801119661308"] # Owner ID da Microsoft para AMIs públicas do Windows

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# VPC padrão
data "aws_vpc" "default" {
  default = true
}

# Encontra uma subnet pública na VPC padrão
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

# Busca informações detalhadas da primeira subnet pública
data "aws_subnet" "selected_public" {
  id = data.aws_subnets.public.ids[0]
}
