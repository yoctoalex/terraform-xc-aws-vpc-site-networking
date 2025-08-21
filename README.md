# AWS Networking module for F5 Distributed Cloud (XC) AWS VPC Site

This Terraform module provisions a VPC network in AWS that is required for XC Cloud AWS VPC Site. It creates a VPC, subnets, route tables, and security groups with whitelisted IP ranges.

## Features

- **Secure by default**: All subnets are private by default with configurable public IP assignment
- **Hardened security groups**: Default security group blocks all traffic; XC-specific security groups with controlled access
- **Flexible subnet tiers**: Support for outside, inside, local, and workload subnets
- **Route table management**: Conditional route table creation and associations
- **VS Code integration**: Pre-configured linting and validation tasks
- **CI/CD ready**: GitHub Actions workflow for automated testing

## Requirements

| Name                                                                                                             | Version  |
| ---------------------------------------------------------------------------------------------------------------- | -------- |
| <a name="requirement_terraform"></a> [terraform](https://github.com/hashicorp/terraform)                         | >= 1.3   |
| <a name="requirement_aws"></a> [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)          | >= 6.9.0 |
| <a name="requirement_random"></a> [random](https://registry.terraform.io/providers/hashicorp/random/latest/docs) | >= 3.0   |

## Usage

To use this module and create a VPC configured for XC Cloud AWS VPC Site on AWS Cloud, include the following code in your Terraform configuration:

```hcl
module "aws_vpc" {
  source  = "f5devcentral/aws-vpc-site-networking/xc"
  version = "0.0.6"

  name             = "aws-tf-demo-creds"
  environment      = "dev"
  az_names         = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_cidr         = "192.168.0.0/16"
  outside_subnets  = ["192.168.11.0/24", "192.168.12.0/24", "192.168.13.0/24"]
  inside_subnets   = ["192.168.21.0/24", "192.168.22.0/24", "192.168.23.0/24"]
  workload_subnets = ["192.168.31.0/24", "192.168.32.0/24", "192.168.33.0/24"]
  
  # Optional: Enable public IP assignment (default: false)
  map_public_ip_outside  = true
  map_public_ip_inside   = false
  map_public_ip_workload = false
  map_public_ip_local    = false
  
  # Optional: Control resource creation
  create_internet_gateway         = true
  create_outside_route_table      = true
  create_outside_security_group   = true
  create_inside_security_group    = true
  create_udp_security_group_rules = true

  tags = {
    Project = "XC-Demo"
    Owner   = "DevOps"
  }
}
```

## Security

This module implements security best practices:

- **Private by default**: All subnets disable auto-assign public IP by default
- **Locked down default SG**: Default security group has no ingress or egress rules
- **XC IP whitelisting**: Security groups use managed prefix lists with F5 XC IP ranges
- **Lifecycle protection**: Security groups use `revoke_rules_on_delete = false`

## Development

### Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.3
- [TFLint](https://github.com/terraform-linters/tflint) (for linting)
- [VS Code](https://code.visualstudio.com/) with HashiCorp Terraform extension (recommended)

### VS Code Setup

This repository includes VS Code configuration for enhanced development experience:

1. Install recommended extensions when prompted
2. Use `Ctrl+Shift+P` → "Tasks: Run Task" → "Terraform: Full Lint Check"
3. Auto-formatting and validation on save are enabled

### Linting

Run linting checks:

```bash
# Initialize TFLint
tflint --init

# Run linting
tflint --format compact

# Format code
terraform fmt -recursive

# Validate syntax
terraform validate
```

### CI/CD

The repository includes GitHub Actions workflows for:
- Terraform formatting checks
- TFLint validation
- Terraform syntax validation

## Contributing

Contributions to this module are welcome! Please see the contribution guidelines for more information.

## License

This module is licensed under the Apache 2.0 License.