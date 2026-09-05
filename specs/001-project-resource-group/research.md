# Research: Project Resource Group

## Decision: Tag values sourced from existing input variables

**Decision**: Add a `local.tags` map in `locals.tf` — `{ project = var.workload, environment = var.environment }`
— and apply it via `tags = local.tags` on `azurerm_resource_group.this` in `main.tf`.

**Rationale**: FR-4 (clarified) requires exactly a `project` tag and an `environment` tag. Both values
already exist as input variables (`var.workload`, `var.environment` in `variables.tf`) used by the naming
module — reusing them keeps the tag values and the resource name derived from the same source of truth,
so they can't drift independently. Centralizing the map in `locals.tf` mirrors the existing `local.names`
pattern (one shared derived-values file), so a future resource that needs the same tags does not repeat
the literal keys.

**Alternatives considered**:
- Inline literal tags directly on the resource (`tags = { project = "br2049", environment = "dev" }`) —
  rejected: hardcodes values that already exist as variables, and duplicates them per-resource once a
  second resource needs tagging.
- Deriving tags from the naming module's output — rejected: `Azure/naming/azurerm` only generates names,
  not tags; there is no tagging output to consume.

## Decision: Deletion protection via Terraform `lifecycle` block

**Decision**: Add `lifecycle { prevent_destroy = true }` to `azurerm_resource_group.this`.

**Rationale**: This is exactly the mechanism chosen in the spec's clarification session for FR-6 — it's a
native Terraform guard requiring no additional Azure resource, and it makes "deliberate, explicit" removal
literal: deleting the resource group requires first deliberately deleting this block, then re-running
`terraform apply`/`destroy`.

**Alternatives considered**:
- `azurerm_management_lock` (Azure Resource Lock) — rejected: it is itself a new Azure resource, and the
  spec's Out of Scope section excludes "creating any resource other than the container itself."
- IAM-only restriction (rely on subscription permissions to prevent deletion) — rejected in the
  clarification session: not enforced in code, so it silently stops protecting the resource group if
  permissions are ever loosened.

## Outstanding NEEDS CLARIFICATION

None. All ambiguities the spec previously marked as open were resolved in the `/speckit-clarify` session
(2026-09-04) and are recorded in spec.md's Clarifications section; the two decisions above are direct,
low-risk implementations of those answers using patterns and variables the repo already has.
