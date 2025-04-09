#!/bin/bash

# Build first using ./build.sh, then run the below.

cd deploy/aws
terraform init # first time only, or if modules change.
terraform workspace select -or-create=true main
terraform apply -var-file=main.tfvars