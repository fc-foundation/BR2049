# CLAUDE.md

Project-level instructions for Claude Code. This file is loaded automatically on every session in this repo — put durable conventions, gotchas, and standing instructions here (not one-off task notes).

## Project
[Brief description of what BR2049 is / does.]

## Conventions
[Coding style, directory layout notes, anything a new contributor — or Claude — would otherwise have to rediscover.]

### Azure resource naming
All Azure resources are deployed via Terraform in `infrastructure/terraform/`, using Microsoft's CAF pattern: `<resource-type-abbr>-br2049-<env>-<region>-<instance>` (e.g. `rg-br2049-prod-eastus-001`). Names come from the `Azure/naming/azurerm` module (wired in `naming.tf`) via `local.names.<type>` (`locals.tf`) — never hardcode a `name = "..."` on a resource block. A CI check (`.github/workflows/terraform-naming-check.yml`) fails the PR if it finds one. Add a new `local.names` entry the first time a new resource type is introduced.

## Gotchas
[Non-obvious constraints, footguns, things that have bitten people before.]
