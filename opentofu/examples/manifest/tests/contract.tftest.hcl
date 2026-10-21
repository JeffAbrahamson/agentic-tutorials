run "handover_contract" {
  command = plan
  assert {
    condition     = output.handover.schema_version == 1
    error_message = "Consumers require handover schema version 1."
  }
  assert {
    condition     = output.handover.hosts["status_a"].address == "192.0.2.10"
    error_message = "The fixture must preserve status_a's address."
  }
}

run "reject_wrong_role" {
  command = plan
  variables {
    hosts = {
      db = { address = "192.0.2.20", role = "database" }
    }
  }
  expect_failures = [var.hosts]
}
