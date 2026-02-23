# Global Zero-Trust Service Mesh: AWS VPC Lattice & Transit Gateway

## Architecture Overview
This repository contains infrastructure-as-code (Terraform) to provision a globally distributed, zero-trust application mesh. The architecture spans three continents (`us-east-1`, `eu-west-2`, `af-south-1`) and bridges modern Layer 7 service discovery (AWS VPC Lattice) with a robust Layer 3 routing backbone (AWS Transit Gateway).

The design intentionally omits NAT Gateways and Internet Gateways to enforce a strict private network perimeter, relying on EC2 Instance Connect Endpoints (EICE) for secure administrative access.

## Core Infrastructure Components
* **Compute Layer:** Amazon Linux 2023 EC2 instances deployed exclusively in private subnets across Virginia, London, and Cape Town.
* **Access Layer:** Zero-trust administrative access via EC2 Instance Connect Endpoints (EICE) with `preserve_client_ip` disabled to comply with strict VPC-bound security group rules.
* **Application Mesh Layer:** VPC Lattice Service Networks establish a logical application boundary in each region, handling service directory and Layer 7 proxying.
* **Global Backbone Layer:** Inter-region Transit Gateway peering connections link the isolated VPCs. Explicit static routes direct cross-continental traffic, while security groups enforce least-privilege ingress across the mesh.

## Prerequisites
* Terraform v1.0+
* AWS CLI configured with appropriate credentials
* An IAM Principal with permissions to deploy VPCs, EC2, Transit Gateways, VPC Lattice, and `iam:CreateServiceLinkedRole` (required for EICE provisioning).

## Deployment Instructions

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd <repository-directory>

2. **Initialize Terraform:**
   ```bash
   terraform init

3. **Deploy the infrastructure:**
   ```bash
   terraform apply -auto-approve

   Note: Transit Gateway peering and EC2 Instance Connect Endpoints require approximately 5-7 minutes to fully provision.

Validation and Testing (Bypassing NAT Limitations)
Because the EC2 instances reside in strictly private subnets without outbound internet access, traditional package managers (like yum) cannot reach external repositories. To validate the cross-region mesh without deploying costly NAT Gateways, this deployment utilizes the pre-installed Python 3 module to serve HTTP traffic.

1. Start the local web service (Virginia Primary Hub):
  ```bash
   mkdir -p my-website
cd my-website
echo "<h1>Hello from Primary Hub - us-east-1</h1>" > index.html
sudo python3 -m http.server 80 &

2. Execute cross-continent Layer 3 routing test (London Spoke):
Connect to the eu-west-2 instance via EICE and curl the private IP address of the Virginia server (e.g., 172.16.1.x):
    ```bash
  curl http://<virginia-private-ip>

 Expected Output:
 <h1>Hello from Primary Hub - us-east-1</h1>

 A successful response confirms the packet traversed the London Security Group, routed through the London Transit Gateway, crossed the transatlantic peering connection, routed through the Virginia Transit Gateway, passed the Virginia Security Group ingress rules, and hit the private Python web service.

 **Known Terraform Provider Behaviors**
During teardown (terraform destroy), the AWS provider may occasionally time out when deregistering EC2 instances from VPC Lattice Target Groups, throwing a TargetGroupNotInUse error. If the state becomes stuck on UNUSED, you can manually drop the attachments from the local state file and resume destruction:
 ```bash
  terraform state rm aws_vpclattice_target_group_attachment.<name>
terraform destroy -auto-approve



