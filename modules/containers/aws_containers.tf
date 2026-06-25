# Real AWS EKS when service_config.enable=true; otherwise inventory-only stub.
locals {
  eks_cfg = try(jsondecode(var.service_config), var.service_config, {})

  eks_enable        = try(tobool(local.eks_cfg.enable), false)
  eks_vpc_id        = try(local.eks_cfg.vpc_id, "")
  eks_subnet_ids    = try(local.eks_cfg.subnet_ids, [])
  eks_k8s_version   = try(local.eks_cfg.kubernetes_version, "1.29")
  eks_node_count    = try(tonumber(local.eks_cfg.node_count), 1)
  eks_instance_type = try(local.eks_cfg.instance_type, "t3.medium")
}

resource "aws_iam_role" "cluster" {
  count = local.eks_enable ? 1 : 0

  name = "${var.name_prefix}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = local.cortex_tags
}

resource "aws_iam_role_policy_attachment" "cluster" {
  count = local.eks_enable ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster[0].name
}

resource "aws_eks_cluster" "this" {
  count = local.eks_enable ? 1 : 0

  name     = "${var.name_prefix}-eks"
  role_arn = aws_iam_role.cluster[0].arn
  version  = local.eks_k8s_version

  vpc_config {
    subnet_ids              = local.eks_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = try(tobool(local.eks_cfg.public_endpoint), false)
  }

  tags = local.cortex_tags

  depends_on = [aws_iam_role_policy_attachment.cluster]

  lifecycle {
    precondition {
      condition     = !local.eks_enable || local.eks_vpc_id != ""
      error_message = "service_config.vpc_id is required when service_config.enable=true"
    }
    precondition {
      condition     = !local.eks_enable || length(local.eks_subnet_ids) > 0
      error_message = "service_config.subnet_ids is required when service_config.enable=true"
    }
  }
}

resource "aws_iam_role" "node" {
  count = local.eks_enable ? 1 : 0

  name = "${var.name_prefix}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = local.cortex_tags
}

resource "aws_iam_role_policy_attachment" "node_worker" {
  count = local.eks_enable ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node[0].name
}

resource "aws_iam_role_policy_attachment" "node_cni" {
  count = local.eks_enable ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node[0].name
}

resource "aws_iam_role_policy_attachment" "node_registry" {
  count = local.eks_enable ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node[0].name
}

resource "aws_eks_node_group" "this" {
  count = local.eks_enable ? 1 : 0

  cluster_name    = aws_eks_cluster.this[0].name
  node_group_name = "${var.name_prefix}-ng"
  node_role_arn   = aws_iam_role.node[0].arn
  subnet_ids      = local.eks_subnet_ids

  scaling_config {
    desired_size = local.eks_node_count
    max_size     = local.eks_node_count + 1
    min_size     = 1
  }

  instance_types = [local.eks_instance_type]

  depends_on = [
    aws_iam_role_policy_attachment.node_worker,
    aws_iam_role_policy_attachment.node_cni,
    aws_iam_role_policy_attachment.node_registry,
  ]

  tags = local.cortex_tags
}
