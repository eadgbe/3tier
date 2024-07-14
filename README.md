## Description

This reference architecture allows you to create a 3-tier web application with its DNS zones, firewall, load balancers and a database.

You may need to add other components, like route table, route table associations or any other resources that you need.

> terraform apply status: successful

## Architecture components

### Web layer

This is the user facing part, with its subnets and configuration right behind the firewall.

### Application components

This layers hosts the VMs used as the application engine.

### Database layer

This layer is dedicated to the database with replication and its own subnet.

## Requirements

| Name | Configuration |
| --- | --- |
| Terraform | all versions |
| Provider  | AWS |
| Provider version  | >= 5.33.0 |
| Access | Admin access |

## How to use the architecture

Clone the architecture and modify the following variables according to your needs:

| Variable | Description |
| --- | --- |
| cidr_block | The CIDR block of the VPC |
| az1 | The name of 1st availability zone |
| az2 | The name of 2nd availability zone |
| a_records | the IP address of the DNS zone  |
| app_asg_max | Maximum capacity of the application ASG |
| app_asg_min | Minmum capacity of the application ASG  |
| app_port | The default port of the application |
| app_subnets | The subnets of the application with their names and cidr |
| bucket_name | The name of the S3 bucket |
| db_subnets | The subnets of the database with their names and cidr  |
| dns_zone | The DNS zone associated with the application  |
| domains | The domain associated with the application |
| env | The environment of the architecture |
| hosted_zone | The DNS zone of the application |
| image_id | The AMI of the virtual machine used in the ASG |
| ipset_value | The cidr of the IPSET |
| tags | The default tags to add for all resources |
| web_asg_max | Maximum capacity of the web ASG |
| web_asg_min | Minimum capacity of the Web ASG |
| web_subnets | The subnets of the web with their names and cidr |

**N.B:** Feel free to remove the resources that are not relevant to your use-case. 

## Maintainer(s)

You can reach out to these maintainers if you need help or assistance:

- [Brainboard team](mailto:support@brainboard.co)
