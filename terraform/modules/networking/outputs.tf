output "vpc_id" {
  value = "${ aws_vpc.polkadot.id }"
}

output "subnet_id" {
  value = "${ aws_subnet.polkadot.id }"
}
