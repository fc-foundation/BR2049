# Quickstart: Project Resource Group

Validates FR-1 through FR-6 and SC-1 through SC-3 from [spec.md](./spec.md) against the Terraform in
`infrastructure/terraform/`. No Azure credentials are required for steps 1-4; steps 5-6 provision a real
resource group and do require them.

## Prerequisites

- Terraform `>= 1.9.0` on PATH
- (Steps 5-6 only) Azure credentials the `azurerm` provider can use (e.g. `az login`), and an Azure
  subscription to provision into

## Static validation (no credentials needed)

```sh
cd infrastructure/terraform
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

Expected: all three commands exit 0.

## Plan review

```sh
terraform plan -var="environment=dev"
```

Expected in the plan output:
- Exactly one resource to add: `azurerm_resource_group.this` (FR-1, FR-5)
- Its `name` matches the CAF pattern from `local.names.resource_group`, containing `br2049` and `dev` (FR-2, FR-3)
- Its `tags` include `project = "br2049"` and `environment = "dev"` (FR-4)
- No other resources appear in the plan (spec Out of Scope)

## Apply and verify deletion protection (requires Azure credentials)

```sh
terraform apply -var="environment=dev"
terraform destroy -var="environment=dev"
```

Expected:
- `apply` succeeds and creates exactly one resource group (SC-2: zero project resources exist outside it,
  trivially true since it's the only resource).
- `destroy` **fails** with a `prevent_destroy` error and makes no changes — this proves FR-6: removal
  requires deliberately deleting the `lifecycle` block from `main.tf` first, then re-running `destroy`.

## Cost/access reporting check (SC-1, SC-3)

In the Azure Portal or CLI (`az group show --name <resource_group_name>`), confirm:
- The resource group is identifiable by name alone, with no need to inspect its contents (SC-1).
- Its tags (`project`, `environment`) are present, matching what an unrelated cost or access report would
  filter on to return only this project's resources with no manual filtering (SC-3).

## Cleanup

After verifying deletion protection, remove the `lifecycle` block locally (do not commit the removal
unless intentionally decommissioning the environment) and run `terraform destroy` again to tear down the
test resource group.
