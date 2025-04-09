# 🚀 Generic AWS Lambda Terraform Module

This module deploys a generic AWS Lambda function with:

- ✅ IAM execution role and basic policy
- ✅ ZIP-based deployment via S3 (with optional local ZIP upload)
- ✅ Optional VPC configuration (subnets + security groups)
- ✅ Optional Function URL for public access
- ✅ Configurable runtime, handler, timeout, memory, architecture
- ✅ Layer support
- ✅ Environment variables

---

## 📦 Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `function_name` | Name of the Lambda function | `string` | — | ✅ |
| `runtime` | Lambda runtime (e.g. `provided.al2023`, `nodejs20.x`) | `string` | `"provided.al2023"` | ❌ |
| `handler` | Lambda handler (e.g. `index.handler` or `bootstrap`) | `string` | `"bootstrap"` | ❌ |
| `memory_size` | Function memory in MB | `number` | `1024` | ❌ |
| `timeout` | Timeout in seconds | `number` | `30` | ❌ |
| `architectures` | Instruction set architecture | `list(string)` | `["arm64"]` | ❌ |
| `s3_bucket` | S3 bucket name where the Lambda ZIP is stored | `string` | — | ✅ |
| `s3_key` | S3 object key (e.g. `lambda/my-code.zip`) | `string` | — | ✅ |
| `source_code_hash` | Base64-encoded SHA256 of the ZIP file for updates | `string` | — | ✅ |
| `layer_arns` | List of Lambda layer ARNs to attach | `list(string)` | `[]` | ❌ |
| `environment_variables` | Map of environment variables | `map(string)` | `{}` | ❌ |
| `enable_function_url` | Whether to enable a public function URL | `bool` | `false` | ❌ |
| `vpc_config` | Optional VPC config: subnet IDs and security group IDs | `object({ subnet_ids = list(string), security_group_ids = list(string) })` | `null` | ❌ |
| `local_zip_path` | Optional local path to Lambda zip file. If set, it will be uploaded to S3. | `string` | `""` | ❌ |

---

## 📤 Outputs

| Name | Description |
|------|-------------|
| `lambda_function_name` | The name of the deployed Lambda |
| `lambda_function_arn` | ARN of the deployed Lambda |
| `function_url` | Function URL (if enabled), else `null` |

---

## 💡 Example Usage

```hcl
module "my_lambda" {
  source            = "./generic-lambda-module"

  function_name     = "hello-world"
  runtime           = "provided.al2023"
  handler           = "bootstrap"
  memory_size       = 512
  timeout           = 15
  architectures     = ["arm64"]

  local_zip_path    = "dist/lambda.zip"  # Local path to ZIP file

  s3_bucket         = "my-lambda-artifacts"
  s3_key            = "hello-world/lambda.zip"
  source_code_hash  = filebase64sha256("dist/lambda.zip")

  environment_variables = {
    STAGE = "prod"
  }

  layer_arns = [
    "arn:aws:lambda:us-east-1:123456789012:layer:my-shared-lib:1"
  ]

  enable_function_url = true

  vpc_config = {
    subnet_ids         = ["subnet-abc123"]
    security_group_ids = ["sg-abc123"]
  }
}
```

---

## 📎 Notes

- If `local_zip_path` is provided, the module will automatically upload the ZIP to S3.
- Make sure the S3 bucket exists before applying the module.
- You can generate `source_code_hash` using:

```bash
openssl dgst -sha256 -binary dist/lambda.zip | openssl base64
```

Or use Terraform's built-in:

```hcl
source_code_hash = filebase64sha256("dist/lambda.zip")
```

---

## 🛡 License

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

