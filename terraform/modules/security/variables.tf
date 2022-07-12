variable "boot_nodes" {
  type = map(object({
  availability_zone = string
  tags = map(string)
  }))
  default = {
    "polkadot-boot-node-primary" = {
      availability_zone = "eu-west-1c",
      tags = {
        Name        = "primary-boot-node"
      }
    },
    "polkadot-boot-node-secondary" = {
      availability_zone = "eu-west-1c",
      tags = {
        Name        = "secondary-boot-node"
      }
    }
  }
}

variable "collator_nodes" {
  type = map(object({
  availability_zone = string
  tags = map(string)
  }))
  default = {
    "polkadot-collator-node" = {
      availability_zone = "eu-west-1c",
      tags = {
        Name        = "collator-node"
      }
    }
  }
}

variable "rpc_nodes" {
  type = map(object({
  availability_zone = string
  tags = map(string)
  }))
  default = {
    "polkadot-rpc-node-1" = {
      availability_zone = "eu-west-1a",
      tags = {
        Name        = "rpc-node-1"
      }
    },
    "polkadot-rpc-node-2" = {
      availability_zone = "eu-west-1c",
      tags = {
        Name        = "rpc-node-2"
      }
    }
  }
}

variable "all_node_ports" {
  default = ["30333", "30334"]
}

variable "collator_node_ports" {
  default = ["9933", "9944"]
}

variable "rpc_node_ports" {
  default = ["80", "443"]
}

variable "cidr_block" {
  default = "172.26.0.0/16"
}
