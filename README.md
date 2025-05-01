
# Welcome to CICD Project for NETFLIX clone app in React

This is a CICD project for deploying a NETFLIX clone app.

</center>

![alt text](./pictures/netflix.png)

</center>

## Steps to Deploy Netflix cloned app using Terraform/AWS Fargate or AWS cluster

- This project is designed for the deployment of a Netflix clone application written in React language
- The image is built using a Dockerfile from ECR to ECS from UI and using Terraform/Jenkins for automation.
- Make sure to have your image deployed to Amazon ECR using the CI jenkins pipeline build to deploy the image. Here we used jenkinsfile for this.
- Create your ECS - Elastic container service ecs_main.tf file in our case for creating the resources (ECS) via terraform. Ensure your image ID is properly tagged in the main.tf file.
- Run through the terraform commands, fmt, init, validate, plan and apply to proovision your resources accordingly. Reference the ecs_main.tf file.

```bash
terraform fmt
terraform int
terraform validate
terraform plan
terraform apply
```

- You should be able to access the application using the public IP address of your cluster task service.

- Now we have to automate the build using Jenkins to deploy the application using terraform.
- Use the jenkinsfile in root directory to build the pipeline for automating the above process.

## Second Phase of project, Deploying the application using AWS Code Pipeline to an AWS EKS cluster

- Using AWS Code Pipeline to deploy the application to an Amazon EKS cluster
- Use the buildspec.yml file at root of the folder to configure the aws pipeline
- Spin up a cluster using below bash command

```bash
eksctl create cluster --name nameOfCluster --region ap-south-1
eksctl create cluster --name pumejcluster --region ap-south-1
```
