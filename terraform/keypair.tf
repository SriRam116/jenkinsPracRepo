resource "aws_key_pair" "pipePracKP" {
  key_name   = var.key_name
  public_key = var.public_key
  depends_on = [aws_security_group.pipePracSG]
}