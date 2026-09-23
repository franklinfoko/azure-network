variable "tags" {
  type        = map(string)
  description = "Tags applied to every resource that supports them."
}

variable "subscription_id" {
  type = string
}

variable "resource_group_name" {
  type        = string
  description = <<-DESC
    Name of the resource group that holds the network. Changing this destroys
    and recreates every resource in the configuration.
  DESC
}

variable "admin_password" {
  type = string
}
