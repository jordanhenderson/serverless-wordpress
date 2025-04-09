variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime (e.g., provided.al2023)"
  type        = string
  default     = "provided.al2023"
}

variable "handler" {
  description = "Lambda handler"
  type        = string
  default     = "bootstrap"
}

variable "memory_size" {
  description = "Amount of memory in MB"
  type        = number
  default     = 1024
}

variable "timeout" {
  description = "Function timeout in seconds"
  type        = number
  default     = 30
}

variable "architectures" {
  description = "Instruction set architecture (e.g., x86_64, arm64)"
  type        = list(string)
  default     = ["arm64"]
}

variable "s3_bucket" {
  description = "S3 bucket for Lambda deployment package"
  type        = string
}

variable "s3_key" {
  description = "S3 key for the Lambda ZIP file"
  type        = string
}

variable "source_code_hash" {
  description = "Base64-encoded SHA256 hash of the deployment ZIP file"
  type        = string
}

variable "layer_arns" {
  description = "List of Lambda layer ARNs"
  type        = list(string)
  default     = []
}

variable "environment_variables" {
  description = "Map of environment variables for the function"
  type        = map(string)
  default     = {}
}

variable "enable_function_url" {
  description = "Whether to enable a function URL"
  type        = bool
  default     = false
}

variable "vpc_config" {
  description = "Optional VPC configuration"
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable "local_zip_path" {
  description = "Optional local ZIP file to upload to S3"
  type        = string
  default     = ""
}
