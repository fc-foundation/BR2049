# Spec: Project Resource Group

## Overview

The project currently has no dedicated resource group (formerly referred to as "container") for the cloud
resources it will provision. Before any other infrastructure can be built, the project needs a single place
where all of its resources live, are managed, and can be reasoned about as one unit — for cost tracking,
access control, and cleanup. This feature establishes that resource group so every resource created
afterward has a home from day one, instead of resources accumulating ad hoc with no shared boundary.

## Clarifications

### Session 2026-09-04

- Q: How should the requirement that deletion be "deliberate and explicit" (FR-6) be enforced? → A: Terraform `lifecycle { prevent_destroy = true }` on the resource group — deletion requires deliberately removing that block first.
- Q: What specific tag keys must the resource group carry to satisfy the cost/access reporting requirement (FR-4)? → A: `project` and `environment` only.
- Q: Should the spec's generic term "container" be replaced with the concrete term "resource group" throughout? → A: Yes — replaced everywhere in this spec.

## User Stories

- **P1 — Project maintainer provisions the resource group.** [JIRA: DEV-5] As a project maintainer, I need one
  resource group that will hold every resource this project creates, so that the project's footprint is
  visible and manageable as a single unit. Testable independently by confirming the resource group exists
  and is empty (no other resources depend on it yet).
- **P2 — Contributor deploys a new resource into the project.** [JIRA: DEV-6] As a contributor adding a new piece of
  infrastructure, I need a predictable, already-existing place to deploy it into, so that I don't have to
  decide where it belongs or create ad hoc resource groups. Testable independently by deploying a placeholder
  resource into the group and confirming it's grouped with the rest of the project's resources.
- **P3 — Anyone auditing cost or access reviews the project as a whole.** [JIRA: DEV-7] As someone reviewing spend or
  permissions, I need to see all of the project's resources grouped together, so that cost and access
  reviews don't require hunting across unrelated resources. Testable independently by pulling a cost or
  access report scoped to the group and confirming it reflects only this project's resources.

## Functional Requirements

- **FR-1**: The project MUST have exactly one resource group that all of its cloud resources are
  created within.
- **FR-2**: The resource group MUST be identifiable as belonging to this project by name, without needing to
  inspect its contents.
- **FR-3**: The resource group MUST record which environment it supports (e.g., a proof-of-concept/dev
  environment today, with room for additional environments later).
- **FR-4**: The resource group MUST carry metadata (tags) sufficient to identify project ownership for cost
  and access reporting: a `project` tag and an `environment` tag, at minimum.
- **FR-5**: The resource group MUST exist before any other project resource is created, since all other
  resources depend on it.
- **FR-6**: Removing the resource group MUST be a deliberate, explicit action — it MUST NOT be deleted as a
  side effect of removing any single resource within it. This is enforced at the infrastructure-as-code
  level via a deletion-protection setting (e.g., Terraform `lifecycle { prevent_destroy = true }`), so
  deletion requires deliberately removing that safeguard first.

## Success Criteria

- **SC-1**: A person unfamiliar with the project can identify which cloud resources belong to it by
  looking at a single resource group, with no ambiguity.
- **SC-2**: 100% of resources created for this project after this feature ships are located inside the
  resource group — zero resources exist outside it.
- **SC-3**: A cost or access report scoped to the resource group returns only this project's resources, with
  no manual filtering required.

## Out of Scope

- Creating any resource other than the resource group itself (compute, storage, networking, etc.).
- Defining fine-grained role assignments or custom access-control policies within the resource group.
- Provisioning resource groups for additional environments beyond the first one.
- Cross-project or shared/multi-tenant resource groups.

## Assumptions

- Only one environment (a proof-of-concept/dev environment) is needed right now; additional environments
  each get their own resource group later, following the same pattern.
- A default region is acceptable for now and does not need to be decided as part of this feature.
- Standard project-identifying tags (project name, environment) are sufficient metadata; no additional
  compliance or cost-center tagging is required at this stage.
- Access to the resource group follows existing subscription-level permissions; no new access-control scheme
  is being introduced by this feature.
