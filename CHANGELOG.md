## [2.0.1] - 2025-02-02

- Switch base docker image from `edge` to `current` for better stability

## [2.0.0] - 2025-02-02

- Update configuration pipeline to use dynamic environment parameter
- Update terraform.lock OS in terraform Prod environment
- Cleanup workflow filters in config.yml

## [1.1.2] - 2025-02-02

Refine README content and structure

## [1.1.1] - 2025-02-02

Update README for clarity and technical details

## [1.1.0] - 2025-02-01

Improved CI/CD pipeline with TFLint integration, branch filters to restrict execution to main branch only, Terraform latest image, upgraded AWS provider to 6.30.0, added versions.tf files to modules and environments, removed unnecessary region variables, optimized CircleCI workflows, and fixed Terraform provider lock compatibility issues.

## [1.0.0] - 2025-01-29

Initial AWS monitoring infrastructure deployment with Terraform IaC modular architecture, VPC with public subnets, EC2 instance (t3.micro), Docker containerization for Prometheus, Grafana, and Node Exporter, CircleCI CI/CD pipeline with automated deployment, AWS Secrets Manager integration for credentials, and manual approval workflow for infrastructure destruction.