# AWS Observability Project

## Objetive
Create an EC2 instance and installs Prometheus and Grafana using Docker.

## Stack
* **AWS**: To host the server (EC2) and configure Secrets Manager (Optional).
* **Terraform**: To create the IaC.
* **CircleCI**: To run the deployment pipeline.
* **Docker**: To run Prometheus and Grafana in containers

## Diagram

![Diagram](./docs/diagram_cicd-ec2-monitoring.png)

## Project Structure
```
├── docker
│   └── docker-compose.yml
├── infra-aws
│   └── terraform
│       ├── environments
│       │   ├── dev
│       │   │   ├── maint.tf
│       │   │   ├── outputs.tf
│       │   │   └── provider.tf
│       │   └── prod
│       │       ├── maint.tf
│       │       ├── outputs.tf
│       │       └── provider.tf
│       ├── modules
│       │   └── compute
│       │       └── network
│       ├── terraform.tfvars
│       └── variables.tf
└── scripts
    └── docker-config.sh
```



## How to run it
...WiP...

## Key decisions
...WiP...
