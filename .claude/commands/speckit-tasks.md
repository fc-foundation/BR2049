---
description: Break a plan into a dependency-ordered, checkbox task list.
argument-hint: [feature dir — optional, defaults to the newest specs/*/plan.md]
---

## Input

$ARGUMENTS

## Do this

1. Resolve the feature directory (argument, or most recently modified `specs/*/plan.md`). Read `spec.md` and `plan.md` (and `data-model.md` / contracts if they exist).
2. Write `tasks.md`, grouped into phases in this order:
   - **Setup** — project/dependency init, no story label
   - **Foundational** — shared work that blocks every user story, no story label
   - **One phase per user story**, in priority order (P1 first) — each phase must be independently shippable and testable on its own. This is the whole point of grouping by story instead of by layer (all models, then all services, then all UI): you should be able to stop after any story's phase and have something that works.
   - **Polish** — cross-cutting cleanup, no story label
3. Every task line follows this exact format: `- [ ] T### [P?] [US#?] Description — exact/file/path`
   - `T###` — sequential ID
   - `[P]` — only if this task touches different files than every other *unstarted* task and doesn't depend on them; omit otherwise
   - `[US#]` — only on user-story-phase tasks (maps to the story's priority number); Setup/Foundational/Polish tasks carry no story label
   - the description must end with the concrete file path being created or changed
4. Only add test-writing tasks if the spec explicitly asked for tests or the user requests a TDD approach — don't assume it.
5. Confirm every functional requirement in `spec.md` is covered by at least one task before finishing. Anything uncovered is a bug in the task list, not an acceptable gap.
6. Finish with a one-line note: `MVP = Phase 3 (US1) only` (adjust the phase number) if the stories are independent enough to ship one at a time.

## Done when

- every requirement in `spec.md` has at least one task
- the list reads clearly to someone with no other context than the three files it came from
