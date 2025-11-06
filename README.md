
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

## Second Phase of project, Deploying the application using AWS Code Build / Pipeline to an AWS EKS cluster

- Spin up a cluster using below bash command

```bash
eksctl create cluster --name nameOfCluster --region ap-south-1
eksctl create cluster --name pumejcluster --region ap-south-1
```

- Using AWS Code Pipeline to deploy the application to an Amazon EKS cluster, use below steps to create the pipeline.
- Create the codebuildkubectlRole using the script file codebuildrolescript.sh
- Go back and update the Codebuild role created on your AWS CODE BUILD instead of the earlier created service and uncheck allow AWS to modify check box
CODEBUILDKUBECTLROLE
- Use the buildspec.yml file at root of the folder to configure the aws pipeline

- Update the aws-auth config for the cluster using below command / You can also add this to script file.

```bash
eksctl create iamidentitymapping --cluster nameofcluster --region=region --arn rolearncreated --group system:masters --username CodeBuildKubectlRole
```

- After deployment on the k8s cluster you can access the application using the external ip address assigned.

- Make sure to also create your secret for pulling the image from ECR. Use below command

```bash
kubectl create secret docker-registry ecr-secrets \
--docker-server=598189530267.dkr.ecr.ap-south-1.amazonaws.com \
--docker-username=AWS \
--docker-password=$(aws ecr get-login-password --region ap-south-1) \
--docker-email=pumej@yahoo.com -n default
```

```bash
kubectl get secret ecr-secrets -n default -o yaml > ecr-secret.yaml         | Would export it to a file called ecr-secret.yaml
```

```bash
kubectl get svc netflix-service -n default
```

NAME     TYPE           CLUSTER-IP     EXTERNAL-IP       PORT(S)
my-app   LoadBalancer   10.0.1.234     a1b2c3d4.elb.amazonaws.com   80:31234/TCP
