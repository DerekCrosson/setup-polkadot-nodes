output "node_ids" {
    value = [for k, v in aws_instance.polkadot_node : aws_instance.polkadot_node[k]]
}

output "ssh_public_key" {
    value = tls_private_key.ssh_key.public_key_openssh
}
