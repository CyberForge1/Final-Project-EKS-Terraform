# F5 NGINX Ingress Controller, exposed through an AWS Network Load Balancer
resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "oci://ghcr.io/nginx/charts"
  chart            = "nginx-ingress"
  version          = "2.7.2"
  namespace        = "nginx-ingress"
  create_namespace = true

  values = [yamlencode({
    controller = {
      replicaCount = 1

      ingressClass = {
        name                = "nginx"
        create              = true
        setAsDefaultIngress = true
      }

      # Lets cert-manager issue certificates for VirtualServer resources too
      enableCertManager = true

      service = {
        type                  = "LoadBalancer"
        externalTrafficPolicy = "Local"
        annotations = {
          "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
        }
      }
    }
  })]

  depends_on = [
    aws_eks_node_group.node_group,
    helm_release.cert_manager,
  ]
}

# AWS load balancer created for the NGINX ingress controller
data "kubernetes_service_v1" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress-controller"
    namespace = helm_release.nginx_ingress.namespace
  }
}

output "load_balancer_hostname" {
  description = "Point a CNAME record for your domain at this hostname"
  value       = data.kubernetes_service_v1.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname
}
