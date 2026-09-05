# .claude/ layout

- `agents/*.md` — subagent definitions (Agent tool, subagent_type). Frontmatter: `name`, `description`, `tools`, `model`.
- `skills/<skill-name>/SKILL.md` — skills invoked via the Skill tool or `/<skill-name>`. One folder per skill; put any supporting files (scripts, references) alongside the SKILL.md in that same folder. Currently empty in this project — add a skill folder here when one is needed.
- `commands/*.md` — custom slash commands. Filename (minus `.md`) is the command name, e.g. `commands/deploy.md` → `/deploy`. Frontmatter: `description`; body is the prompt template (supports `$ARGUMENTS`).
- `memory/constitution.md` — this project's non-negotiable rules (MUST/MUST NOT), read by the spec-driven commands below. Edit by hand or via `/speckit-constitution`.
- `settings.json` / `settings.local.json` — permissions, hooks, env vars for this project (`settings.local.json` is untracked/personal).

Project-wide instructions ("CLAUDE.md" memory) live at the **repo root** (`../CLAUDE.md`), not in this folder — Claude Code walks up from the cwd looking for it there. Nested `CLAUDE.md` files in subdirectories are also picked up automatically when you're working in that subtree.

## Spec-driven workflow (spec-lite)

`commands/speckit-*.md` and `agents/{spec-reviewer,task-runner}.md` are a minimal spec-driven-development workflow, adapted from [spec-lite](https://github.com) (a stripped-down take on GitHub's spec-kit). These are **project-local commands**, distinct from the global `speckit-*` *skills* this account also has installed (the full spec-kit) — same names, but the project-local command in this repo takes precedence, so `/speckit-specify` etc. run the lite version here.

```
/speckit-constitution   (once, optional)   → .claude/memory/constitution.md
/speckit-specify <description>             → specs/NNN-slug/spec.md
/speckit-plan                              → specs/NNN-slug/plan.md
/speckit-tasks                             → specs/NNN-slug/tasks.md
/speckit-implement                         → the code, tasks.md checked off as it goes
```

Each command reads what the previous one wrote, plus `memory/constitution.md` if it exists. `/speckit-implement` dispatches `task-runner` subagents for `[P]`-marked parallel tasks and runs a read-only consistency check (or delegate it directly: `@spec-reviewer check specs/003-chat-system`) before touching code. `specs/` is created automatically the first time `/speckit-specify` runs.
