output "all_nodes_security_group_id" {
  value = "${aws_security_group.polkadot_all_nodes.id}"
}

output "rpc_nodes_security_group_id" {
  value = "${aws_security_group.polkadot_rpc_nodes.id}"
}

output "collator_nodes_security_group_id" {
  value = "${aws_security_group.polkadot_collator_nodes.id}"
}
