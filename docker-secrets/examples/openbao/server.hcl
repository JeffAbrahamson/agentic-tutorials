# Audit devices are declared in server configuration: since OpenBao 2.3.2
# they cannot be created through the API unless explicitly allowed.
audit "file" "file" {
  options {
    file_path = "/tmp/audit.log"
  }
}
