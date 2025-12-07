# Terraform Cloud Infra Playground — Core Services & Modules

My Terraform playground: a small catalogue of core platform pieces and tiny reusable modules. The `core` stands up the shared platform (remote state storage, Key Vault, logging, DNS, networks) using HCP Terraform as the backend, so I can use this tfstate as the foundation for other projects. I can also pull modules from this repo to other projects.

## Repo Content

- A set of core services (key vault, state storage, logging, DNS, networks) supporting other projects.
- Small, focused Terraform modules that can be composed into environments.
- Act as a reference / playground for testing provisioning patterns and permissions (Key Vault RBAC vs access-policies, storage-backed state, etc.).

## Core Services

Deploys the below services:

### Azure

- Azure Storage Account and Container for Terraform remote state
- Azure Key Vault (RBAC authorization enabled) - contains: storage account access key, SSH private/public keys, Cloudflare TLS certificate
- Azure Log Analytics Workspace for central logging/monitoring
- Azure DNS zone
- Virtual networks and subnets
- Bastion (Developer or Standard SKU) for VM management
