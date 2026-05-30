# Coworking Space Analytics API

## Overview
A Flask-based REST API that provides analytics on user activity within a coworking space, deployed as a microservice on AWS EKS with a fully automated CI/CD pipeline.

## Architecture
The application runs as a containerized workload on **AWS EKS** (Elastic Kubernetes Service), connecting to a **PostgreSQL** database deployed via Helm within the same cluster. Docker images are stored in **AWS ECR** (Elastic Container Registry) and built automatically through **AWS CodeBuild**, which is triggered by GitHub webhooks on every push to the `main` branch.

## Technologies & Tools
- **AWS EKS** — Managed Kubernetes cluster orchestrating containerized services across EC2 worker nodes.
- **AWS ECR** — Private container registry hosting versioned Docker images for the analytics API.
- **AWS CodeBuild** — CI service that reads `buildspec.yml` to build, tag, and push Docker images to ECR automatically.
- **AWS CloudWatch** — Centralized logging and monitoring for both the EKS cluster and CodeBuild pipelines.
- **Helm** — Package manager used to deploy and manage the Bitnami PostgreSQL chart in the Kubernetes cluster.
- **kubectl** — CLI tool for applying Kubernetes manifests (Deployments, Services, ConfigMaps, Secrets) and managing cluster resources.

## Configuration Management
Plaintext environment variables (DB_HOST, DB_PORT, DB_NAME, DB_USERNAME) are stored in a **ConfigMap**, while sensitive credentials (DB_PASSWORD) are stored in a **Kubernetes Secret** with base64 encoding, following the principle of least privilege.

## Releasing New Builds
To deploy changes, update the application code and increment the image tag in both `buildspec.yml` and `deployments/coworking.yaml` using semantic versioning (e.g., `1.0.2` → `1.0.3`). Push the changes to the `main` branch, and CodeBuild will automatically build and push the new image to ECR. Then run `kubectl apply -f deployments/coworking.yaml` to roll out the updated deployment, which Kubernetes handles as a rolling update with zero downtime.

## AWS Instance Recommendation
A **t3.medium** instance (2 vCPU, 4 GB RAM) is recommended for EKS worker nodes, as it provides sufficient compute for lightweight Flask APIs and PostgreSQL while remaining cost-effective under the AWS Free Tier for the first 12 months.

## Cost Optimization
- Leverage **EC2 Spot Instances** for non-critical worker nodes to reduce compute costs by up to 90% compared to on-demand pricing.
- Implement the **Kubernetes Cluster Autoscaler** to dynamically scale node groups based on workload demand, scaling down during off-peak hours.
- Right-size **resource requests and limits** in Kubernetes manifests to prevent over-provisioning and ensure efficient bin-packing of pods across nodes.
