run "valid_storage_inventory" {
  command = apply

  assert {
    condition     = output.cortex_inventory.capability == "storage"
    error_message = "Expected Cortex inventory capability to be storage."
  }

  assert {
    condition     = contains(output.cortex_inventory.zero_trust_controls, "least-privilege-iam")
    error_message = "Zero Trust controls must include least-privilege IAM."
  }
}
