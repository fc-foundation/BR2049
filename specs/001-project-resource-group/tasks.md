# Tasks: Project Resource Group

**Input**: [plan.md](./plan.md), [spec.md](./spec.md), [data-model.md](./data-model.md), [research.md](./research.md), [quickstart.md](./quickstart.md)
**Tests**: Not requested in the spec — this feature has no test tasks; each story phase ends with a
`terraform plan`/`validate` check instead (see quickstart.md).

> Note: no `.specify/` scaffold exists in this repo (no `setup-tasks.sh`, no tasks template) — this file was
> written directly from the plan/spec/data-model/research docs above, following the same phase/task format
> the scaffold would generate.

## Phase 1: Setup

- [X] T001 Create `infrastructure/terraform/.terraformignore` (patterns: `.terraform/`, `*.tfstate*`, `*.tfvars`, `.terraform.lock.hcl`) and append the same Terraform patterns to the root `.gitignore` — neither currently exists, and `*.tfstate*` can contain sensitive values that must never be committed

## Phase 2: Foundational

No foundational tasks — the shared prerequisites (provider config in `versions.tf`, `var.workload`/`var.environment`/`var.location` in `variables.tf`, CAF naming in `naming.tf`/`locals.tf`, and the base `azurerm_resource_group.this` declaration in `main.tf`) already exist in the repo.

## Phase 3: User Story 1 - Project maintainer provisions the resource group (Priority: P1) 🎯 MVP

**Goal**: The resource group exists, is identifiable, and cannot be deleted except by a deliberate, explicit action (FR-1, FR-2, FR-3, FR-5, FR-6).

**Independent Test**: Per spec.md — confirm the resource group exists and is empty (no other resources depend on it yet); confirm `terraform destroy` is rejected while the lifecycle guard is in place.

- [X] T002 [US1] Add `lifecycle { prevent_destroy = true }` to `azurerm_resource_group.this` in `infrastructure/terraform/main.tf`
- [X] T003 [US1] Run `terraform validate` in `infrastructure/terraform/` and confirm it exits 0
- [X] T004 [US1] Run `terraform plan -var="environment=dev"` in `infrastructure/terraform/` and confirm exactly one resource (`azurerm_resource_group.this`) is planned, per quickstart.md's "Plan review" section

**Checkpoint**: A maintainer can run `terraform apply` to provision the resource group, and `terraform destroy` fails until the lifecycle block is deliberately removed — US1 is independently complete and testable.

## Phase 4: User Story 2 - Contributor deploys a new resource into the project (Priority: P2)

**Goal**: The resource group is a predictable, already-existing attachment point for future resources (FR-1, FR-5).

**Independent Test**: Per spec.md — deploy a placeholder resource into the group and confirm it's grouped with the rest of the project's resources.

- [X] T005 [US2] Run `terraform plan -var="environment=dev"` in `infrastructure/terraform/` and confirm `azurerm_resource_group.this.name` and `.id` resolve to stable values a future resource's `resource_group_name` argument could reference (no code change — this validates T002-T004 already satisfy US2's dependency, per quickstart.md)

**Checkpoint**: A contributor has a fixed, predictable `resource_group_name` to point new resources at — US2 is independently testable on top of US1, with no additional code.

## Phase 5: User Story 3 - Anyone auditing cost or access reviews the project as a whole (Priority: P3)

**Goal**: The resource group carries `project` and `environment` tags sufficient for cost/access reporting (FR-4).

**Independent Test**: Per spec.md — pull a cost or access report scoped to the group and confirm it reflects only this project's resources.

- [X] T006 [US3] Add `local.tags = { project = var.workload, environment = var.environment }` to `infrastructure/terraform/locals.tf`
- [X] T007 [US3] Add `tags = local.tags` to `azurerm_resource_group.this` in `infrastructure/terraform/main.tf`
- [X] T008 [US3] Run `terraform plan -var="environment=dev"` in `infrastructure/terraform/` and confirm the planned resource group's tags include `project = "br2049"` and `environment = "dev"`, per quickstart.md's "Plan review" section

**Checkpoint**: A cost/access report scoped by the `project`/`environment` tags returns only this project's resources — US3 is independently testable.

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T009 [P] Run `terraform fmt -check -recursive` in `infrastructure/terraform/` and fix any formatting drift from T002-T007
- [X] T010 [P] Walk through quickstart.md's full "Static validation" + "Plan review" sequence end-to-end and confirm every expected outcome holds

## Dependencies

- Setup (T001) has no dependencies and can run anytime before or alongside the story phases.
- **US1 (T002-T004) before US2 (T005)**: US2's validation depends on the resource group (with its lifecycle guard already in place) existing.
- **US1 (T002-T004) before US3 (T006-T008)**: T002 and T007 both edit `infrastructure/terraform/main.tf`, so US3's edits must land after US1's to avoid clobbering the same file concurrently.
- Polish (T009-T010) runs after all story phases complete.
- Within each story phase, tasks are sequential (each edits or depends on the file the previous task touched) — no `[P]` tasks exist inside US1/US2/US3 for that reason.

## Parallel Example

Only the Polish phase has parallelizable tasks, and only because they touch different concerns (formatting vs. end-to-end walkthrough) after all code changes are done:

```text
T009 [P] terraform fmt -check -recursive
T010 [P] Walk through quickstart.md validation sequence
```

## Implementation Strategy

**MVP = User Story 1 (T001-T004)**: provisions the resource group with its deletion guard. This alone
satisfies the spec's core problem statement (project has no dedicated container) and is independently
verifiable via `terraform plan`.

**Incremental delivery**: US2 (T005) adds no code — it's free once US1 lands, so implement it immediately
after for a quick second checkpoint. US3 (T006-T008) is the only phase with further code changes (tags) and
can be delivered last without touching anything US1/US2 already validated, other than the shared `main.tf`
sequencing noted above.
