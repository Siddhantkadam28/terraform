To initialize the Dev environment using the Dev state file:

terraform init -backend-config="bucket=sid-bucket-terraform" -backend-config="key=dev/dev.tfstatefile" -backend-config="region=us-east-1"


Note:
If you are running the Prod environment, make sure to update the backend path to:

-backend-config="key=prod/prod.statefile"


For Terraform Plan / Apply:

Prod environment:

terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"


Dev environment:

terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
