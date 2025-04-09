# 🐘 Serverless WordPress

This repository allows you to deploy a fully functional, lightweight WordPress instance on AWS Lambda using a custom runtime—no Docker, no EFS.

---

## 🚀 Getting Started

### 1. Build the Lambda Package

First, build your deployment package:

```bash
./build.sh
```

This will produce `dist/lambda.zip` with WordPress core, `vendor/`, and `composer.*` files flattened into the root of the zip.

---

### 2. Deploy with Terraform

```bash
cd deploy/aws
terraform workspace select -or-create=true main
terraform apply -var-file=main.tfvars
```

Terraform will:
- Upload the built ZIP to S3 (if using `local_zip_path`)
- Create an IAM role
- Deploy a Lambda function using `provided.al2023`
- (Optionally) configure a Function URL and VPC networking

---

## ⚙️ Requirements
- AWS CLI configured
- Terraform >= 1.3
- Composer installed (for managing PHP dependencies)
- S3 bucket created and accessible
- PHP binary compatible with AWS Lambda runtime (preferably static)

---

## 📁 Directory Structure

```
serverless-wordpress/
├── build.sh                  # Bundles your WordPress files
├── dist/lambda.zip          # Output of build script
├── wordpress/               # Your WP install (core only)
├── vendor/                  # Composer dependencies
├── composer.json
├── composer.lock
└── deploy/aws/              # Terraform module + config
```

---

## 📄 License

Licensed under the Apache License, Version 2.0. See [LICENSE](./LICENSE).

---

PRs welcome. Serverless WordPress is community-powered ⚡