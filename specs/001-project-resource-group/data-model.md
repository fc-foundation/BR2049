# Data Model: Project Resource Group

## Entity: Resource Group

The single Azure Resource Group that contains every resource this project provisions. Declared as
`azurerm_resource_group.this` in `infrastructure/terraform/main.tf`.

| Field | Source | Notes |
|---|---|---|
| `name` | `local.names.resource_group` (CAF naming module, `naming.tf`) | Composed from `var.workload`, `var.environment`, `var.location`, `var.instance` — satisfies FR-2 (identifiable by name alone) |
| `location` | `var.location` (default `eastus`) | Satisfies FR-3's environment-locality; region choice is out of scope per spec Assumptions |
| `tags.project` | `var.workload` | Satisfies FR-4, clarified 2026-09-04 |
| `tags.environment` | `var.environment` | Satisfies FR-4, clarified 2026-09-04 |
| deletion guard | `lifecycle { prevent_destroy = true }` | Not an Azure API field — a Terraform-level constraint. Satisfies FR-6, clarified 2026-09-04 |

## Relationships

- **Resource Group → project resources (1-to-many)**: every other resource this project creates is
  declared with this resource group as its parent (`resource_group_name = azurerm_resource_group.this.name`).
  No child resources are created by this feature (Out of Scope) — the relationship exists so later features
  have a fixed attachment point (FR-1, FR-5).

## Lifecycle / State Transitions

1. **Absent** → `terraform apply` → **Created** (name, location, tags set; `prevent_destroy` active).
2. **Created** → `terraform apply` with changed `tags` or unrelated attributes → **Updated in place** (name
   and location are immutable in practice, since changing the naming inputs changes the CAF-generated name
   and would force replacement — no requirement in this feature to support renaming).
3. **Created** → `terraform destroy` (or removal from config) while `prevent_destroy = true` → **Rejected**
   by Terraform (error, no state change) — this is the FR-6 guarantee.
4. **Created** → block removed → `terraform destroy` → **Deleted** — the only path to removal, and it is
   deliberate by construction (FR-6).

## Validation Rules

- Exactly one `azurerm_resource_group` resource must exist in the root module (FR-1).
- `tags` must include non-empty `project` and `environment` keys (FR-4).
- The resource block must include `lifecycle { prevent_destroy = true }` (FR-6).
- `name` must come from `local.names.resource_group`, never a literal string (constitution; CI-enforced by
  `.github/workflows/terraform-naming-check.yml`).
