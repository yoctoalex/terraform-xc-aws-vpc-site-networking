# AWS VPC for F5 XC Cloud Ingress/Egress GW AWS VPC Site

This example demonstrates how to create an AWS VPC optimized for F5 XC Cloud Ingress/Egress Gateway deployment. It provisions a secure, multi-AZ VPC with proper subnet segmentation and hardened security groups.

## Features

- **Multi-AZ deployment**: 3 availability zones for high availability
- **Subnet segmentation**: Outside, inside, and workload subnets per AZ
- **Security hardened**: Private subnets by default with controlled public IP assignment
- **XC-optimized**: Pre-configured security groups with F5 XC IP ranges
- **Production ready**: Environment tagging and proper resource naming

## Architecture

```
VPC (192.168.0.0/16)
├── AZ-A (us-west-2a)
│   ├── Outside Subnet:  192.168.11.0/24
│   ├── Inside Subnet:   192.168.21.0/24
│   └── Workload Subnet: 192.168.31.0/24
├── AZ-B (us-west-2b)
│   ├── Outside Subnet:  192.168.12.0/24
│   ├── Inside Subnet:   192.168.22.0/24
│   └── Workload Subnet: 192.168.32.0/24
└── AZ-C (us-west-2c)
    ├── Outside Subnet:  192.168.13.0/24
    ├── Inside Subnet:   192.168.23.0/24
    └── Workload Subnet: 192.168.33.0/24
```

## Usage

```hcl
module "aws_vpc" {
  source = "../.."

  # Basic configuration
  name        = "xc-ingress-egress-vpc"
  environment = "prod"
  vpc_cidr    = "192.168.0.0/16"
  
  # Multi-AZ setup
  az_names = ["us-west-2a", "us-west-2b", "us-west-2c"]
  
  # Subnet configuration
  outside_subnets  = ["192.168.11.0/24", "192.168.12.0/24", "192.168.13.0/24"]
  inside_subnets   = ["192.168.21.0/24", "192.168.22.0/24", "192.168.23.0/24"]
  workload_subnets = ["192.168.31.0/24", "192.168.32.0/24", "192.168.33.0/24"]
  
  # Security configuration (secure by default)
  map_public_ip_outside  = true   # Enable for XC gateway access
  map_public_ip_inside   = false  # Keep private
  map_public_ip_workload = false  # Keep private
  
  # Infrastructure components
  create_internet_gateway         = true
  create_outside_route_table      = true
  create_outside_security_group   = true
  create_inside_security_group    = true
  create_udp_security_group_rules = true
  
  # Tagging
  tags = {
    Project     = "XC-Gateway"
    Environment = "Production"
    Owner       = "Platform-Team"
    Purpose     = "Ingress-Egress-Gateway"
  }
}
```

## Deployment

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Review the plan**:
   ```bash
   terraform plan
   ```

3. **Apply the configuration**:
   ```bash
   terraform apply
   ```

## Outputs

The module provides these outputs for integration with XC site configuration:

- `vpc_id` - VPC identifier
- `outside_subnet_ids` - Outside subnet IDs for XC gateway placement
- `inside_subnet_ids` - Inside subnet IDs for internal traffic
- `workload_subnet_ids` - Workload subnet IDs for application deployment
- `outside_security_group_id` - Security group for XC gateway
- `inside_security_group_id` - Security group for internal resources

## Security Considerations

- **Outside subnets**: Have public IP assignment enabled for XC gateway connectivity
- **Inside/Workload subnets**: Private by default for security
- **Security groups**: Pre-configured with F5 XC IP ranges
- **Default SG**: Locked down with no ingress/egress rules
- **Environment tagging**: Enables proper resource tracking and compliance

## Next Steps

After VPC creation, use the outputs to configure your F5 XC Cloud AWS VPC Site:

1. Reference `vpc_id` and subnet IDs in your XC site configuration
2. Use security group IDs for your application deployments
3. Configure additional networking as needed for your workloads