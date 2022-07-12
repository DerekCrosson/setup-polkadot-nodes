locals {
  common_tags = {
    Name        = "${ var.tag_name }"
    Environment = "${ var.environment }"
  }
}

data "aws_ami" "polkadot_boot_node_image" {
  most_recent = true
  owners      = ["self"]
  filter {
    name      = "name"
    values    = ["${ var.boot_image_filter_name_value }"]
  }
}

data "aws_ami" "polkadot_collator_node_image" {
  most_recent = true
  owners      = ["self"]
  filter {
    name      = "name"
    values    = ["${ var.collator_image_filter_name_value }"]
  }
}

data "aws_ami" "polkadot_rpc_node_image" {
  most_recent = true
  owners      = ["self"]
  filter {
    name      = "name"
    values    = ["${ var.rpc_image_filter_name_value }"]
  }
}

resource "aws_instance" "polkadot_node" {
  for_each = {for k, v in merge(var.boot_nodes, var.collator_nodes, var.rpc_nodes) : k => v}
    ami                         = contains([
                                    "polkadot-boot-node-primary",
                                    "polkadot-boot-node-secondary"
                                  ], each.key) ? "${ data.aws_ami.polkadot_boot_node_image.id }": (
                                    contains([
                                      "polkadot-collator-node"
                                    ], each.key) ? "${ data.aws_ami.polkadot_collator_node_image.id }" : "${ data.aws_ami.polkadot_rpc_node_image.id }")
    instance_type               = "${ var.instance_size }"
    availability_zone           = each.value.availability_zone
    associate_public_ip_address = true
    tags                        = each.value.tags
}

resource "aws_key_pair" "polkadot_node_key_pair" {
  key_name   = "polkadot-public-key"
  public_key = var.public_key
}

resource "aws_network_interface_sg_attachment" "all_nodes_security_group_attachment" {
  for_each = {for k, v in merge(var.boot_nodes, var.collator_nodes, var.rpc_nodes) : k => v}
    security_group_id    = var.security_groups[0]
    network_interface_id = aws_instance.polkadot_node[each.key].primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "collator_nodes_security_group_attachment" {
  for_each = var.collator_nodes
    security_group_id    = var.collator_nodes_security_group_id
    network_interface_id = aws_instance.polkadot_node[each.key].primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "rpc_nodes_security_group_attachment" {
  for_each = var.rpc_nodes
    security_group_id    = var.security_groups[1]
    network_interface_id = aws_instance.polkadot_node[each.key].primary_network_interface_id
}
resource "aws_ebs_volume" "data_disk" {
  for_each            = var.volumes
    availability_zone = each.value.availability_zone
    size              = each.value.size
    type              = each.value.type
  
    tags = each.value.tags
}

# resource "aws_acm_certificate" "ssl" {
#   domain_name       = "polkadot.derekcrosson.co.za"
#   validation_method = "DNS"

#   tags = {
#     Environment = "${ var.environment }"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_volume_attachment" "volume_attachment" {
  for_each    = aws_ebs_volume.data_disk
    device_name     = "${ var.device_name }"
    volume_id       = each.value.id
    instance_id     = aws_instance.polkadot_node[each.key].id
}

resource "aws_elb" "load_balancer" {
  name               = "polkadot-rpc-nodes-load-balancer"
  availability_zones = ["eu-west-1a", "eu-west-1c"]
  #security_groups = ["${split(";", var.security_groups_as_string)}"]
  #security_groups = [aws_security_group.polkadot_all_nodes.id, aws_security_group.polkadot_rpc_nodes.id]

  # access_logs {
  #   bucket        = "logs"
  #   bucket_prefix = "polkadot-rpc-nodes-load-balancer"
  #   interval      = 60
  # }

  listener {
    instance_port     = 9056
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  # listener {
  #   instance_port      = 30333
  #   instance_protocol  = "http"
  #   lb_port            = 443
  #   lb_protocol        = "https"
  #   ssl_certificate_id = "arn:aws:acm:eu-west-1:902573523767:certificate/8ebe84e8-8331-49b3-bd31-4e49d5bd4e35" # aws_acm_certificate.ssl.id
  # }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:9056"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "polkadot-rpc-nodes-load-balancer"
  }
}
resource "aws_elb_attachment" "load_balancer_attachment" {
  for_each = var.rpc_nodes
      elb      = aws_elb.load_balancer.id
      instance = aws_instance.polkadot_node[each.key].id
}

resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory/hosts.ini"
  for_each = {for k, v in merge(var.boot_nodes, var.collator_nodes, var.rpc_nodes) : k => v}
    content = <<EOF
    [webserver]
    ${aws_instance.polkadot_node[each.key].id}
    EOF
}
