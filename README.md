Bastion servers on AWS using Terraform
=============

## Requirements

* Terraform >= v0.5.1

## Installation

* install [Terraform](https://www.terraform.io/) and add it to your PATH.
* clone this repo.
* `terraform get`

## Configuration

Create a configuration file such as `~/.aws/default.tfvars` which can include mandatory and optional variables such as:

NOTE: this is currently not complete
```
aws_access_key="<your aws access key>"
aws_secret_key="<your aws access secret>"
key_name="<your private key name>"
key_name="<key name>"

stream_tag="<used for aws resource groups>"

aws_region="ap-southeast-2"
aws_bastion_amis.ap-southeast-2="ami-7ff38945"

# internal hosted zone
hosted_zone_name="<some.internal>"
```

You can also modify the `variables.tf` file, replacing correct values for `aws_amis` for your region:

```
variable "aws_bastion_amis" {
  default = {
		ap-southeast-2 = "ami-xxxxxxx"
  }
}
```

These variables can also be overriden when running terraform like so:

```
terraform (plan|apply|destroy) -var 'aws_bastion_amis.ap-southeast-2=foozie'
```

The variables.tf terraform file can be further modified, for example it defaults to `ap-southeast-2` for the AWS region.

## Using Terraform

Execute the plan to see if everything works as expected.

```
terraform plan -var-file ~/.aws/default.tfvars -state='environment/development.tfstate'
```

If all looks good, lets build our infrastructure!

```
terraform apply -var-file ~/.aws/default.tfvars -state='environment/development.tfstate'
```

## TODO

* Finish This README
* Move subnet provisioning into bastion module
