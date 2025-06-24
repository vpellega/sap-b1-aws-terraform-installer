resource "aws_key_pair" "sap_key" {
  key_name   = "sap-key-develop"
  public_key = file("${path.module}/keys/sap-key-develop.pub")
}