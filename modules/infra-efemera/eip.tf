resource "aws_eip" "sap_b1_client_eip" {
  count = var.criar_instancia_ec2 ? 1 : 0

  domain = "vpc"
  depends_on = [aws_instance.sap_b1_client]
}

resource "aws_eip_association" "sap_b1_client_eip_assoc" {
  count = var.criar_instancia_ec2 ? 1 : 0

  instance_id   = aws_instance.sap_b1_client[0].id
  allocation_id = aws_eip.sap_b1_client_eip[0].id
}