output "node_ids" {
    value = [for k, v in aws_instance.polkadot_node : aws_instance.polkadot_node[k]]
}
