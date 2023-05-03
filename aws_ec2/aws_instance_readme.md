Readme.md for launching a linux 2 EC2 instance on AWS cloud in a default vpc using terraform. 
This mini project makes up part of a the main project. 
To reuse this code,
- make sure to have your AWS Config file properly configured.
- make sure to give a ".tf" extention to your code, e.g: "main.tf"
- make ssure to cd into the location of your main.tf file.
- Do a "terraform init" to initialise the folder or file
- Next, do a "terraform validate" to cross check the code for syntax or invalid characters errors.
- Do a "terraform plan" to very the state of your code against your environment on AWS.
- Do a "terraform apply" to provision your infrstructure through your code
- Finaly, do a "terraform destroy" to clean up.