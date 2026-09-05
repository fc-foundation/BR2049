---
description: Execute tasks.md phase by phase, marking progress as you go.
argument-hint: [feature dir — optional, defaults to the newest specs/*/tasks.md]
---

## Input

$ARGUMENTS

## Do this

1. Resolve the feature directory (argument, or most recently modified `specs/*/tasks.md`). Read `spec.md`, `plan.md`, `tasks.md`, and `.claude/memory/constitution.md` if it exists.
2. **Sanity pass first — don't skip this, it's cheap and catches expensive mistakes:**
   - any task referencing a file or entity not defined in `spec.md` or `plan.md`?
   - any functional requirement in `spec.md` with zero matching tasks?
   - any direct contradiction between the three files (conflicting tech choices, conflicting scope)?
   - anything that violates a MUST/MUST NOT in the constitution?
   If you find something, stop and report it before writing any code. (This is the same check spec-kit calls `/analyze` — here it just runs inline instead of needing its own command and its own invocation.) You can also delegate this step to the `spec-reviewer` subagent if you want it done in an isolated, read-only context.
3. Work through `tasks.md` phase by phase, in order. Within a phase, tasks marked `[P]` can run concurrently — dispatch one `task-runner` subagent per `[P]` task when there's more than one. Run everything else sequentially, in listed order.
4. The moment a task finishes, flip its `- [ ]` to `- [x]` in `tasks.md`. Don't batch this to the end — if something fails halfway through, the file should still reflect real progress.
5. If a task fails, stop. Report exactly what failed and why. Don't start later tasks until the user says how to proceed — a failed foundational task usually invalidates everything downstream of it.
6. When every task is checked off, verify: every requirement in `spec.md` is actually met, any tests that exist pass, and the feature runs end to end — not just "the files exist."

## Done when

- every box in `tasks.md` is checked
- the feature works end to end against `spec.md`, not just against `tasks.md`
