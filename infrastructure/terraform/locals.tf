# Add one line per resource type the first time it's introduced.
locals {
  names = {
    resource_group  = module.naming.resource_group.name
    storage_account = module.naming.storage_account.name
    key_vault       = module.naming.key_vault.name
  }

  tags = {
    project     = var.workload
    environment = var.environment
  }
}
