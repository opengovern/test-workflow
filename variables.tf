# variables.tf

variable "linode_api_token" {
  description = "Linode API token with permissions to create LKE clusters"
  type        = string
  sensitive   = true
}
