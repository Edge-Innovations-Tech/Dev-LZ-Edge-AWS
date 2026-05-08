run "valid_object_storage_inventory" {
  command = apply

  assert {
    condition     = output.cortex_inventory.capability == "object-storage"
    error_message = "Expected Cortex inventory capability to be object-storage."
  }

  assert {
    condition     = contains(output.cortex_inventory.zero_trust_controls, "least-privilege-iam")
    error_message = "Zero Trust controls must include least-privilege IAM."
  }
}
