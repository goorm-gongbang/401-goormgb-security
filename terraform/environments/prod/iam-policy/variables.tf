variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "Project Name (e.g., TicketPlatform, Pyogo, etc.)"
  type        = string
}

variable "environment" {
  description = "Environment (dev / staging / prod)"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment variable must be one of 'dev', 'staging', or 'prod'."
  }
}
