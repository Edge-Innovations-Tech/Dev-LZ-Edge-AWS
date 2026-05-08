output "cortex_inventory" {
  description = "Aggregated Cortex inventory for the AWS development landing zone."
  value = {
    iam            = module.iam.cortex_inventory
    network        = module.network.cortex_inventory
    compute        = module.compute.cortex_inventory
    containers     = module.containers.cortex_inventory
    serverless     = module.serverless.cortex_inventory
    database       = module.database.cortex_inventory
    storage        = module.storage.cortex_inventory
    object_storage = module.object_storage.cortex_inventory
    dns            = module.dns.cortex_inventory
    monitoring     = module.monitoring.cortex_inventory
    cost           = module.cost.cortex_inventory
  }
}
