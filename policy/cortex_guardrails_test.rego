package cortex.guardrails

test_public_object_storage_denied if {
  violations := deny with input as {
    "resource_type": "object_storage",
    "public_access": true,
    "encryption_enabled": true,
    "tags": {"cortex:environment": "dev", "cortex:owner": "platform-engineering"}
  }
  violations["Object storage buckets must not allow public access"]
}

test_database_public_access_denied if {
  violations := deny with input as {
    "resource_type": "database",
    "public_access": true,
    "encryption_enabled": true,
    "tags": {"cortex:environment": "dev", "cortex:owner": "platform-engineering"}
  }
  violations["Databases must not allow public network access"]
}

test_encryption_required if {
  violations := deny with input as {
    "resource_type": "compute",
    "public_access": false,
    "encryption_enabled": false,
    "tags": {"cortex:environment": "dev", "cortex:owner": "platform-engineering"}
  }
  violations["Encryption must be enabled for landing-zone resources"]
}
