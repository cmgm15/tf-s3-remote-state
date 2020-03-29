# Terraform module for remote state
A Terraform module to create s3 bucket for remote state.

## Input Variables
| Name | Type | Default| isRequired|
|--|--|:---:|:--:|
| owner | string | - | yes | 
| application | string | - | yes |
| tags | map(string) | - | yes |
| multipart_delete | bool | true | no |
| multipart_days | number| 3 | no |
| force_destroy| bool | true | no |

## Output
| Name | Description |
|--|--|
| remote_state_bucket | Created bucket name |

## Example
Setup and create resources

main.tf
```hcl
module "s3_remote_state" {
	source = "github.com/cmgm15/tf-s3-remote-state?ref=1.0.0"
	owner = var.owner
	application = var.app
	tags = var.tags
}
```
variables.tf
```hcl
variable "owner" {}
variable "app" {}
variable "tags" {
	type = map(string)
}
```
terraform.tfvars
```hcl
app = "web-app"
owner = "cmgm15"
tags = {
	environment = "dev",
	application = "web-app",
	responsible = "cmgm15"
}
```

Using the s3 bucket created
```hcl
terraform {
	backend "s3" {
		region = "us-east-1"
		bucket = "web-app-tf-state"
		key = "dev.terraform.tfstate"
	}
}
```