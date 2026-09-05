<!-- last updated: 2026-08-30 — added Telemetry section, consolidated from duplicate web/API rules -->

# Project Constitution

## Infrastructure

- MUST: name every Azure resource via `local.names.<type>` from the `Azure/naming/azurerm` module (wired in `naming.tf`) — never hardcode `name = "..."`. CI (`terraform-naming-check.yml`) already blocks on this; the constitution just makes it explicit.
- MUST: add a `local.names` entry the first time a new Azure resource type is introduced, before the resource block that uses it.
- MUST: ensure that resources defined for Azure that already exist, do not have change made to the that would force the Azure resource to be dropped and then re-created.
- MUST NOT: commit secrets, connection strings, or keys into `.tf` or `.tfvars` files — use Key Vault references or variables marked `sensitive = true`.

## Web application

- MUST: validate and sanitize all external input (form fields, query params, headers) at the boundary, before it reaches business logic.
- MUST NOT: render user-supplied content without escaping it — assume every field is attacker-controlled until proven otherwise.
- MUST: keep secrets and internal config out of anything shipped to the browser — client bundles are public by default.

## API

- MUST: every endpoint that creates, updates, or deletes state checks authentication and authorization — no anonymous writes.
- MUST NOT: return raw internal error messages or stack traces to callers — return a generic error and log the detail server-side.
- MUST: a breaking change to an existing endpoint's request or response shape ships as a new version — never silently change a contract callers depend on.

## Telemetry

- MUST: initialize a telemetry/logging tool at application startup and make it available via dependency injection — no ad-hoc console/print logging scattered through the codebase.
- MUST: log unhandled exceptions and failed operations with enough context (operation, input summary, correlation/request id) to diagnose without reproducing.
- MUST NOT: log secrets, credentials, tokens, or PII in plaintext.

## Unit tests

- MUST: any new function or module with non-trivial logic ships with unit tests in the same PR — no "tests later" follow-up.
- MUST: a bug fix includes a regression test that fails before the fix and passes after.
- MUST NOT: merge a PR with failing or skipped tests without an explicit rationale in the PR description.
