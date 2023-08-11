### Terraform to Azure auth

1. ```az role definition create --role-definition Azure/roles/terraform-cloud-dev.json```
2. ```az ad sp create-for-rbac --name "CSD-TerraformCloud" --role "CSD-TerraformCloudRole" --scope "/subscriptions/099ddccf-1097-4ff8-a993-eae393c7bb34/resourceGroups/safe-deploy-rg-dev"```