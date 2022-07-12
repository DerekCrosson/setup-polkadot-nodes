terraform-init:
	cd terraform && terraform init && cd ..

terraform-plan:
	cd terraform && terraform plan && cd ..

terraform-apply:
	cd terraform && terraform apply --auto-approve && cd ..

terraform-destroy:
	cd terraform && terraform destroy --auto-approve && cd ..

packer-build:
	cd packer && packer build boot_node_template.json && packer build collator_node_template.json && packer build rpc_node_template.json && cd ..

deploy-polkadot-nodes:
	make packer-build && make terraform-apply
