variable "boot_image_filter_name_value" {
  default = "ami-polkadot-boot-node"
}

variable "collator_image_filter_name_value" {
  default = "ami-polkadot-collator-node"
}

variable "rpc_image_filter_name_value" {
  default = "ami-polkadot-rpc-node"
}

variable "instance_size" {
  default = "m4.large"
}

variable "availability_zone" {
  default = "eu-west-1c"
}

variable "disk_size" {
  default = 40
}

variable "disk_type" {
  default = "gp2"
}

variable "device_name" {
  default = "/dev/sdh"
}

variable "tag_name" {
  default = "polkadot"
}

variable "environment" {
  default = "production"
}

variable "subnet_id" {
  type = string
}

# variable "vpc_security_group_ids" {
#   type = list(string)
# }

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

variable "volumes" {
  type = map(object({
    size              = string
    type              = string
    availability_zone = string
    tags              = map(string)
  }))
  default = {
    "polkadot-boot-node-primary" = {
      size              = "40"
      type              = "gp2"
      availability_zone = "eu-west-1c"
      tags = {
        Name            = "primary-boot-node"
      }
    },
    "polkadot-boot-node-secondary" = {
      size              = "40"
      type              = "gp2"
      availability_zone = "eu-west-1c"
      tags = {
        Name            = "secondary-boot-node"
      }
    },
    "polkadot-collator-node" = {
      size              = "100"
      type              = "gp2"
      availability_zone = "eu-west-1c"
      tags = {
        Name        = "collator-node"
      }
    },
    "polkadot-rpc-node-1" = {
      size              = "100"
      type              = "gp2"
      availability_zone = "eu-west-1a"
      tags = {
        Name        = "rpc-node-1"
      }
    },
    "polkadot-rpc-node-2" = {
      size              = "100"
      type              = "gp2"
      availability_zone = "eu-west-1c"
      tags = {
        Name        = "rpc-node-2"
      }
    }
  }
}

variable "security_group_name" {
  default = "polkadot"
}

variable "cidr_block" {
  default = "172.26.0.0/16"
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

variable "public_key" {
  default = "put ssh key here"
}
