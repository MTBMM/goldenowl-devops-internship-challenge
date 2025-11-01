# Golden Owl DevOps Internship - Technical Test
At Golden Owl, we believe in treating infrastructure as code and automating resource provisioning to the fullest extent possible. 

In this technical test, we challenge you to create a robust CI build pipeline using GitHub Actions. You have the freedom to complete this test in your local environment.

## Your Mission 🌟
Your mission, should you choose to accept it, is to craft a CI job that:
1. Forks this repository to your personal GitHub account.
2. Dockerizes a Node.js application.
3. Establishes an automated CI/CD build process using GitHub Actions workflow and a container registry service such as DockerHub or Amazon Elastic Container Registry (ECR) or similar services.
4. Initiates CI tests automatically when changes are pushed to the feature branch on GitHub.
5. Utilizes GitHub Actions for Continuous Deployment (CD) to deploy the application to major cloud providers like AWS EC2, AWS ECS or Google Cloud (please submit the deployment link).
## Nice to have 🎨
We would be genuinely delighted if you could complement your submission with a `visual flow diagram`, illustrating the sequence of tasks you performed, including the implementation of a `load balancer` and `auto scaling` for the deployed application. This additional touch would greatly enhance our understanding and appreciation of your work.

🏗️ Infrastructure as Code with Terraform (AWS)
📘 Overview

This project automates the deployment of a highly available web application infrastructure on AWS using Terraform.
The architecture is designed for scalability, security, and fault tolerance across multiple Availability Zones.

🧩 Architecture Components

    The Terraform code provisions the following resources:

    VPC (Virtual Private Cloud) – Isolated network environment for all resources

    Subnets

    Public Subnets for ALB (Application Load Balancer) and NAT Gateways

    Private Subnets for EC2 instances running the application

    Internet Gateway (IGW) – Enables internet access for resources in public subnets

    NAT Gateway – Allows private subnet instances to access the internet securely

    Route Tables – Configured for public/private routing

    Application Load Balancer (ALB) – Distributes incoming traffic across multiple EC2 instances

    Auto Scaling Group (ASG) – Automatically scales the number of EC2 instances based on load

    Launch Template – Defines the AMI, instance type, and bootstrap configuration for EC2

    Security Groups – Control inbound and outbound traffic rules

    IAM Roles & Policies – Grant EC2 instances necessary permissions (e.g., CloudWatch, S3 access)

⚙️ Deployment Steps

1️⃣ Prerequisites

    AWS account

    AWS CLI configured (aws configure)

    Terraform installed (>= v1.3)

    SSH key pair (for EC2 access)

2️⃣ Initialize Terraform
    terraform init

3️⃣ Validate configuration
    terraform validate

4️⃣ Plan deployment
    terraform plan -out=tfplan

5️⃣ Apply changes
    terraform apply tfplan

6️⃣ Get the ALB endpoint
    terraform output alb_dns_name


Access your web application via:

http://<alb_dns_name>
Reference tools for creating visual flow diagrams:
- https://www.drawio.com/
- https://excalidraw.com/
- https://www.eraser.io/
  
Including a visual representation of your workflow will provide valuable insights into your approach and make your submission stand out. Thank you for considering this enhancement! 
## The Bigger Picture 🌏
This test is designed to evaluate your ability to implement modern automated infrastructure practices while demonstrating a basic understanding of Docker containers. In your solution, we encourage you to prioritize readability, maintainability, and the principles of DevOps.

 ## Submission Guidelines 📬
Your solution should be showcased in a public GitHub repository. We encourage you to commit early and often. We prefer to see a history of iterative progress rather than a single massive push. When you've completed the assignment, kindly share the URL of your repository with us.

 ## Running the Node.js Application Locally  🏃‍♂️
 This is a Node.js application, and running it locally is straightforward:
- Navigate to the `src` directory by executing `cd src`.
- Install the project's dependencies listed in the package.json file by running `npm i`.
- Execute `npm test` to run the application's tests.
- Start the HTTP server with `npm start`.

You can test it using the following command:
  
```shell
curl localhost:3000
```
You should receive the following response:
```json
{"message":"Welcome warriors to Golden Owl!"}
```

Are you ready to embark on this DevOps journey with us? 🚀 Best of luck with your assignment! 🌟