---
description: Turn a feature spec into an implementation plan (the HOW).
argument-hint: [feature dir — optional, defaults to the newest specs/*/spec.md]
---

## Input

$ARGUMENTS

## Do this

1. Resolve the feature directory: use the argument if given, otherwise the most recently modified `specs/*/spec.md`'s directory. Read `spec.md`.
2. If `.claude/memory/constitution.md` exists, read it. Its rules are non-negotiable constraints on everything below — not suggestions.
3. Write `plan.md` in the same directory:
   - **Tech Stack** — languages, frameworks, storage, key libraries, one line of rationale each.
   - **Architecture** — how the pieces fit together, at a level a teammate could review in two minutes.
   - **Data Model** — entities, fields, relationships. Inline if short; split into a sibling `data-model.md` and link to it if it's getting long.
   - **Interfaces / Contracts** — API endpoints, CLI commands, or function signatures this feature exposes to callers. Skip this section entirely if the feature is purely internal.
   - **Open Risks** — anything uncertain enough that it could blow up the task list later.
4. Check the plan against every constitution rule. Where it conflicts, either change the plan to comply, or add a one-line **Deviation** note in `plan.md` explaining why not — never silently ignore a MUST.
5. Trace every functional requirement in `spec.md` to something concrete in the plan. If one doesn't map to anything, that's a gap — fix the plan, don't leave it implicit.
6. Keep `plan.md` readable in one sitting. Long code samples, migrations, or exhaustive algorithms belong in a separate file, referenced by a link — not pasted inline.

## Done when

- `plan.md` exists and every spec requirement maps to something in it
- any constitution conflicts are resolved or explicitly justified as a Deviation
