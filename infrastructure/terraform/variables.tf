variable "workload" {
  description = "Short workload/app token used in all resource names"
  type        = string
  default     = "br2049"
}

variable "environment" {
  description = "Deployment environment: dev, test, stg, prod"
  type        = string
}

variable "location" {
  description = "Azure region, CAF short form (e.g. eastus)"
  type        = string
  default     = "eastus"
}

variable "instance" {
  description = "Instance/sequence suffix for disambiguating duplicate resources"
  type        = string
  default     = "001"
}
