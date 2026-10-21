terraform {
  required_version = "= 1.13.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "= 2.5.3"
    }
  }
}

variable "hosts" {
  type = map(object({
    address = string
    role    = string
  }))
  default = {
    status_a = { address = "192.0.2.10", role = "status" }
    status_b = { address = "192.0.2.11", role = "status" }
  }
  validation {
    condition = alltrue([
      for host in values(var.hosts) : host.role == "status"
    ])
    error_message = "This fixture accepts only the status role."
  }
}

locals {
  handover = {
    schema_version = 1
    hosts          = var.hosts
  }
}

resource "local_file" "handover" {
  filename             = "${path.module}/generated/handover.json"
  content              = jsonencode(local.handover)
  file_permission      = "0600"
  directory_permission = "0700"
}

output "handover" {
  value = local.handover
}
