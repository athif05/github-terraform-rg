variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-github-pipeline-testing-cicd"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Central India"
}