locals {
  cluster_name = "smartcloud-eks"
}

# IAM role assumed by the EKS control plane
resource "aws_iam_role" "eks_cluster_role" {
  name = "${local.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = ["sts:AssumeRole", "sts:TagSession"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "eks" {
  name     = local.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.public_subnet_01.id,
      aws_subnet.public_subnet_02.id,
      aws_subnet.private_subnet_01.id,
      aws_subnet.private_subnet_02.id,
    ]
    endpoint_public_access  = true
    endpoint_private_access = true
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = {
    Name = local.cluster_name
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}
