resource "aws_instance" "pipePracMac" {
  ami                    = var.amiID
  instance_type          = var.instanceType
  region                 = var.region
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.pipePracSG.id]
  tags = {
    name        = "PipelinePracMac"
    description = "Creating this machine to practice pipeline"
  }
}