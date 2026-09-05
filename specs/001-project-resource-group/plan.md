# Implementation Plan: Project Resource Group

**Branch**: `users/rush/Init` | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `specs/001-project-resource-group/spec.md`

> Note: this repo does not have the `.specify/` scaffold (no `setup-plan.sh`, no plan template) installed —
> only `specs/001-project-resource-group/spec.md` exists. This plan was produced by reading the spec, the
> constitution at `.claude/memory/constitution.md`, and the existing Terraform under
> `infrastructure/terraform/` directly, following the same plan structure the scaffold would generate.

## Summary

Add a single Azure Resource Group that becomes the one container every other project resource is created
inside of. The resource group itself already exists as a bare declaration in
`infrastructure/terraform/main.tf`; this plan covers the two gaps the spec's clarification session
identified: tags for cost/access reporting (FR-4) and deletion protection (FR-6).

## Technical Context

- **Language/Version**: HCL, Terraform `>= 1.9.0` (`versions.tf`)
- **Primary Dependencies**: `hashicorp/azurerm ~> 3.0`; `Azure/naming/azurerm ~> 0.4` (CAF naming, wired in `naming.tf`)
- **Storage**: N/A — no application data, no Terraform backend configured (local state)
- **Testing**: `terraform fmt -check -recursive`, `terraform validate`, CI naming guard (`.github/workflows/terraform-naming-check.yml`)
- **Target Platform**: Azure, single subscription, single region (`var.location`, default `eastus`)
- **Project Type**: Infrastructure-as-code — single Terraform root module (`infrastructure/terraform/`)
- **Performance Goals**: N/A (no runtime workload)
- **Constraints**: CAF naming via `local.names.*` only (constitution, CI-enforced); no destructive replacement of resources that already exist; no secrets in `.tf`/`.tfvars`
- **Scale/Scope**: One resource group, one environment (`dev`/PoC) for now (per spec Assumptions)

No `NEEDS CLARIFICATION` markers remain — the three material ambiguities (deletion-protection mechanism,
tag keys, "container" vs. "resource group" terminology) were resolved in the `/speckit-clarify` session
recorded in spec.md's Clarifications section (2026-09-04).

## Constitution Check

Against `.claude/memory/constitution.md`:

| Rule | Status | Notes |
|---|---|---|
| Infra: name every resource via `local.names.<type>` | PASS | `main.tf` already uses `local.names.resource_group` |
| Infra: add `local.names` entry before first use | PASS | Already present in `locals.tf` |
| Infra: don't force replace existing resources | PASS | Net-new resource group; nothing to migrate from |
| Infra: no secrets in `.tf`/`.tfvars` | PASS | No secrets involved |
| Web application / API sections | N/A | No application or API code in this feature |
| Telemetry | N/A | No runtime workload to instrument |
| Unit tests: new non-trivial logic ships with tests | N/A | Declarative resource + tags + lifecycle guard, no procedural logic to unit test; `terraform validate`/`plan` is the equivalent verification gate (see quickstart.md) |

No violations. No complexity deviations to track.

## Project Structure

```
infrastructure/terraform/
├── versions.tf      # provider requirements (existing)
├── variables.tf     # workload, environment, location, instance (existing)
├── naming.tf         # Azure/naming/azurerm module (existing)
├── locals.tf         # local.names + local.tags (tags map is new, see data-model.md)
└── main.tf           # azurerm_resource_group.this — add tags + lifecycle block (see data-model.md)
```

No new files are needed — this feature only extends `locals.tf` and `main.tf`.

## Phase 0: Outline & Research

See [research.md](./research.md). Both open technical questions (how to source tag values, how to
implement the deletion guard) are resolved there; no external research agents were needed since the answers
follow directly from the clarified spec and the existing repo conventions.

## Phase 1: Design & Contracts

See [data-model.md](./data-model.md) for the resource group's fields, tag/lifecycle attributes, and its
relationship to future project resources.

**Contracts**: skipped. This feature provisions internal cloud infrastructure and exposes no API, CLI,
schema, or UI surface to users or other systems — there is no interface to contract.

See [quickstart.md](./quickstart.md) for the runnable validation steps that prove FR-1 through FR-6 and
SC-1 through SC-3.

## Post-Design Constitution Check

Re-evaluated after Phase 1: the design (a `tags` block sourced from existing variables, and a `lifecycle`
block on the same resource) introduces no new resource types, no new secrets, and no naming bypass — all
constitution gates above still PASS unchanged.
