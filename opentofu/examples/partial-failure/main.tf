terraform {
  required_version = "= 1.13.0"
}

variable "allow_second" {
  type    = bool
  default = false
}

resource "terraform_data" "first" {
  input = "ready"
}

resource "terraform_data" "second" {
  input = terraform_data.first.output
  lifecycle {
    precondition {
      condition = terraform_data.first.output == (
        var.allow_second ? "ready" : "blocked"
      )
      error_message = "Deliberate failure: allow_second is false."
    }
  }
}
