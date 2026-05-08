run "valid_compute_inventory" {
  command = apply

  assert {
    condition     = output.cortex_inventory.capability == "compute"
    error_message = "Expected Cortex inventory capability to be compute."
  }

  assert {
    condition     = contains(output.cortex_inventory.zero_trust_controls, "least-privilege-iam")
    error_message = "Zero Trust controls must include least-privilege IAM."
  }
}
