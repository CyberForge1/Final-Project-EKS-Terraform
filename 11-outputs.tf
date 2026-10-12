# Private key saved locally so you can SSH into the instance
resource "local_sensitive_file" "ec2_private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/my-ec2-key.pem"
  file_permission = "0600"
}

# ---- EKS outputs ----
output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_version" {
  value = aws_eks_cluster.eks.version
}

output "eks_node_group_name" {
  value = aws_eks_node_group.node_group.node_group_name
}

output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --region us-west-1 --name ${aws_eks_cluster.eks.name}"
}

# ---- EC2 outputs ----
# Commented out: aws_instance.ec2_vm and random_password.grafana are not defined
# in this folder, so these outputs would fail. Uncomment if you add them back.
#
# output "ec2_public_ip" {
#   value = aws_instance.ec2_vm.public_ip
# }
#
# output "ssh_command" {
#   value = "ssh -i my-ec2-key.pem ubuntu@${aws_instance.ec2_vm.public_ip}"
# }
#
# output "api_url" {
#   value = "http://${aws_instance.ec2_vm.public_ip}/health"
# }
#
# output "grafana_url" {
#   value = "http://${aws_instance.ec2_vm.public_ip}:3000"
# }
#
# output "grafana_user" {
#   value = "admin"
# }
#
# output "grafana_password" {
#   value     = random_password.grafana.result
#   sensitive = true
# }
