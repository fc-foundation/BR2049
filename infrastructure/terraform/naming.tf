# Generates CAF-compliant, resource-type-correct names from shared tokens.
# Every resource's `name` argument must come from local.names.<type> (see locals.tf) —
# never a hardcoded string. CI enforces this in .github/workflows/terraform-naming-check.yml.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.4"

  suffix = [var.workload, var.environment, var.location, var.instance]
}
