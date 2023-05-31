# Single-Tier Application with VPC and EC2 Web Instance
This repository contains the code and configuration files for deploying a single-tier application on AWS. The infrastructure is set up using Terraform and includes a Virtual Private Cloud (VPC) with two public subnets and two private subnets. Additionally, a single EC2 web instance is launched in one of the public subnets to host the web application.

## Prerequisites
Before deploying the application, make sure you have the following prerequisites:

AWS CLI installed and configured with appropriate access credentials.
Terraform installed on your local machine.

## Deployment Steps
Follow these steps to deploy the application:

1. Clone the repository to your local machine:
bash
```
Copy code

git clone https://github.com/your-username/single-tier-app.git
```
2. Change into the cloned directory:
bash
```
Copy code
cd single-tier-app
```

3. Initialize the Terraform workspace:
csharp
```
Copy code
terraform init
```

4. Review and modify the variables.tf file to customize the deployment parameters such as VPC CIDR blocks, subnet configurations, and instance type.

5. Run a Terraform plan to review the changes that will be applied:

Copy code
```
terraform plan 
```

6. If the plan looks good, apply the changes:
Copy code
```
terraform apply
```
7. Confirm the deployment by typing yes when prompted.

8. Wait for the Terraform deployment to complete. It will create the VPC, subnets, security groups, and launch the EC2 instance.

9. Once the deployment is finished, you can obtain the public IP address of the EC2 instance from the Terraform output or the AWS Management Console.

## Accessing the Web Application
To access the web application hosted on the EC2 instance:

1. Open a web browser.

2. Enter the public IP address of the EC2 instance.

3. You should now see the web application running.

## Cleaning Up
To clean up and remove all the resources created by the deployment:

1. Run the following command to destroy the infrastructure:
Copy code
```
terraform destroy
```

2. Confirm the destruction by typing yes when prompted.

## License
This project is licensed under the MIT License.

Feel free to customize and extend this project to meet your specific requirements. If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request.

Happy deploying!





