terraform {
  required_version = "= 1.13.0"
}

variable "hosts" {
  type = map(object({
    role     = string
    revision = number
  }))
  default = {
    status_a = { role = "status", revision = 1 }
    status_b = { role = "status", revision = 1 }
  }
}

resource "terraform_data" "host" {
  for_each         = var.hosts
  input            = each.value.role
  triggers_replace = each.value.revision
}

output "ids" {
  value = { for key, host in terraform_data.host : key => host.id }
}
