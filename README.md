# TERRAFORM AWS NETWORK CONFIG

This is a module which defines the configurations required to create an AWS network infrastructure.

The main.tf file includes the main configuration for the TERRAFORM AWS NETWORK CONFIG module, which calls a child module (./modules/network/), to provide the necessary configurations to create the network infrastructure.

## Network module structure

The network module is responsible for creating a VPC in a specified AWS Region. It also creates an Internet Gateway to enable the public subnets to communicate with the internet, and a NAT Gateway to enable access to the private subnets. Finally, it configures an Elastic IP which is used by the NAT Gateway.
In the network module, we also specify the config required to create public & private subnets within the created VPC, given a list of specified availability zones. We also define the route tables and route table associations for each subnet.

A .yml file also specifies the variables required to run the root module and call the network module from within the root module. The variable values can be modified within this file.

## Note

- Input and output variables are defined in separate files to reduce coupling among the configuration files and enable reusability and flexibility in deploying the network.
- A .gitignore file has been added to enable us hide sensitive information and configurations that could be contained in our root directory.
- To pass the variables specified in the yaml file into the root module, run the following;

``` yml

terraform apply -var-file=terraform-vars.yml
```

## Module components

``` terraform
terraform-aws-network-config
├─ .git
├─ .gitignore
├─ .terraform
│  ├─ modules
│  │  └─ modules.json
│  └─ providers
│     └─ registry.terraform.io
│        └─ hashicorp
│           └─ aws
│              └─ 4.4.0
│                 └─ windows_amd64
│                    └─ terraform-provider-aws_v4.4.0_x5.exe
├─ .terraform.lock.hcl
├─ main.tf
├─ modules
│  └─ network
│     ├─ main.tf
│     ├─ outputs.tf
│     └─ variables.tf
├─ outputs.tf
├─ README.md
├─ terraform-vars.yml
├─ terraform.tf
├─ terraform.tfstate
├─ terraform.tfstate.backup
└─ variables.tf

```
