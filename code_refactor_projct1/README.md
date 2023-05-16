# CODE_REFACTORING project_1
   It is best practice to splid your code into mutiple files in a root_folder that defines your infrastructure. Terraform recommends that in our root_folder, we should breakdown our code in the files:
   - main.tf
   - variable.tf
   - outputs.tf
   - terraform.tfvars
   - providers.tf
   - local.tf

## Purpose of the code
This code is aimed at provisioning a single tier application by using terraform version 4s. This single tier infrastructure resides in a custom network (vpc)