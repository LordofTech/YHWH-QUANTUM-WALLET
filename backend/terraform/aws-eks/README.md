
# Terraform: AWS EKS (template)

```bash
cd terraform/aws-eks
terraform init
terraform apply -auto-approve
# After apply, configure kubectl using:
aws eks update-kubeconfig --name quantum-wallet-eks --region eu-west-1
```
