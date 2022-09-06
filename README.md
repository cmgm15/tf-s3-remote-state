# Terraform module for remote state
A Terraform module to create s3 bucket for remote state.

## Example
#### Setup and create resources

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

#### Using the s3 bucket created
```hcl
terraform {
	backend "s3" {
		region = "us-east-1"
		bucket = "web-app-tf-state"
		key = "dev.terraform.tfstate"
	}
}
```

<!-- BEGIN_TF_DOCS -->
# README.md

A Terraform module to create s3 bucket for remote state.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_user.owner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_user) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | The application name to identify the remote state bucket | `string` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | n/a | `bool` | `true` | no |
| <a name="input_multipart_days"></a> [multipart\_days](#input\_multipart\_days) | n/a | `number` | `3` | no |
| <a name="input_multipart_delete"></a> [multipart\_delete](#input\_multipart\_delete) | n/a | `string` | `"Enabled"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | The owner username of the remote state bucket | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_remote_state_bucket"></a> [remote\_state\_bucket](#output\_remote\_state\_bucket) | n/a |
<!-- END_TF_DOCS -->