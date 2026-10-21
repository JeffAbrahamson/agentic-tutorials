# OpenBao Agent: log in with AppRole, keep the token alive, and render
# short-lived database credentials into a file the application reads.
vault {
  address = "http://bao:8200"
}

auto_auth {
  method "approle" {
    config = {
      role_id_file_path                   = "/etc/agent/approle/role_id"
      secret_id_file_path                 = "/etc/agent/approle/secret_id"
      remove_secret_id_file_after_reading = false
    }
  }
}

template {
  destination = "/run/app/db.env"
  perms       = "0400"
  contents    = <<-EOT
    {{ with secret "database/creds/app" }}PGUSER={{ .Data.username }}
    PGPASSWORD={{ .Data.password }}
    {{ end }}
  EOT
}
