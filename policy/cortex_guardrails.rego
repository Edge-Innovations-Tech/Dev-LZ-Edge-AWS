package cortex.guardrails

deny contains msg if {
  input.resource_type == "object_storage"
  input.public_access == true
  msg := "Object storage buckets must not allow public access"
}

deny contains msg if {
  input.resource_type == "database"
  input.public_access == true
  msg := "Databases must not allow public network access"
}

deny contains msg if {
  input.encryption_enabled == false
  msg := "Encryption must be enabled for landing-zone resources"
}

deny contains msg if {
  not input.tags["cortex:environment"]
  msg := "Required tag cortex:environment is missing"
}

deny contains msg if {
  not input.tags["cortex:owner"]
  msg := "Required tag cortex:owner is missing"
}
