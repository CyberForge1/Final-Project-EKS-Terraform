# cert-manager: issues and renews TLS certificates (e.g. from Let's Encrypt)
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.21.2"
  namespace        = "cert-manager"
  create_namespace = true

  values = [yamlencode({
    crds = {
      enabled = true
    }
  })]

  depends_on = [aws_eks_node_group.node_group]
}
