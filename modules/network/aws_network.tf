# Real AWS network when service_config.enable=true; otherwise inventory-only stub.
locals {
  net_cfg = try(jsondecode(var.service_config), var.service_config, {})

  net_enable        = try(tobool(local.net_cfg.enable), false)
  net_vpc_cidr      = try(local.net_cfg.vpc_cidr, "10.20.0.0/16")
  net_subnet_cidr   = try(local.net_cfg.subnet_cidr, "10.20.1.0/24")
  net_create_igw    = try(tobool(local.net_cfg.create_internet_gateway), true)
  net_map_public_ip = try(tobool(local.net_cfg.map_public_ip_on_launch), false)
}

resource "aws_vpc" "this" {
  count = local.net_enable ? 1 : 0

  cidr_block           = local.net_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.cortex_tags, {
    Name = "${var.name_prefix}-vpc"
  })
}

resource "aws_internet_gateway" "this" {
  count = local.net_enable && local.net_create_igw ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(local.cortex_tags, {
    Name = "${var.name_prefix}-igw"
  })
}

resource "aws_subnet" "this" {
  count = local.net_enable ? 1 : 0

  vpc_id                  = aws_vpc.this[0].id
  cidr_block              = local.net_subnet_cidr
  map_public_ip_on_launch = local.net_map_public_ip

  tags = merge(local.cortex_tags, {
    Name = "${var.name_prefix}-subnet"
  })
}

resource "aws_route_table" "public" {
  count = local.net_enable && local.net_create_igw ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(local.cortex_tags, {
    Name = "${var.name_prefix}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  count = local.net_enable && local.net_create_igw ? 1 : 0

  subnet_id      = aws_subnet.this[0].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_security_group" "this" {
  count = local.net_enable ? 1 : 0

  name        = "${var.name_prefix}-sg"
  description = "Cortex ${var.name_prefix} landing-zone security group"
  vpc_id      = aws_vpc.this[0].id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [try(local.net_cfg.ssh_source_cidr, "0.0.0.0/0")]
  }

  tags = merge(local.cortex_tags, {
    Name = "${var.name_prefix}-sg"
  })
}
