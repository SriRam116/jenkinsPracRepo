output "myip" {
  value = local.myip
}

output "awsPubIP" {
  value = aws_instance.pipePracMac.public_ip
}

output "awsPrivIP" {
  value = aws_instance.pipePracMac.private_ip
}