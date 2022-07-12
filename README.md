# Polkadot node provisioning

This repository is an example of how you can provision a production grade Polkadot node on Amazon Web Services.

In this repo three tools are used:

1. Terraform - for creating infrastructure (i.e. networks, servers, access control, etc)
2. Ansible - for configuration (i.e. installing packages and system updates, etc) of machine images that are created by Packer
3. Packer - for creating artifacts (i.e. backing machine images) to be used by Terraform

### What you need to begin (and the CLI to be configured on your machine)
An AWS user named `terraform`

The Terraform script will create a user group and attach the necessary permissions. If your user has a different name, update the `username` variable in the `iam` Terraform module so that the user data source can be found.

### Run with single command
```
make deploy-polkadot-nodes
```

### Bake Amazon Machine Image
```
make packer-build
```

Edit the template files and add your AWS access key and secret. This will be updated in a future version.

### Generate infrastructure plan
```
make terraform-plan
```

### Provision infrastructure
```
make terraform-apply
```

## Destroy infrastructure (cannot be undone)
```
make terraform-destroy
```

### Things I still need to get to:
- Finish up networking and security Terraform modules
- Testing code
- Creating a pipeline to automate infrastructure management using continuous integration
- Possibly switch Packer template from JSON to HCL
