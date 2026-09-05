---
description: Create or update the project's non-negotiable rules.
argument-hint: [principle or change, in plain language]
---

## Input

$ARGUMENTS

## Do this

1. Read `.claude/memory/constitution.md` if it exists.
2. This command touches only that one file. If the input also asks for a feature, a refactor, or any code change, make the constitution edit, then tell the user to run `/speckit-specify` for the rest — don't do both in the same turn, and don't let a feature request sneak into this file as a "principle."
3. Keep it short: a handful of rules a reviewer would actually enforce on every PR, not an essay. Good candidates — required test coverage for a category of code, forbidden dependencies or patterns, a required review/deploy process, a non-negotiable architecture decision ("all state changes go through the event log"). Bad candidates — anything that's really just today's feature request, or advice nobody would block a merge over.
4. Every rule is one sentence, phrased as MUST or MUST NOT, with a short clause of rationale if it isn't obvious. No numbered "Articles," no semantic versioning, no ratification dates, no amendment-process bureaucracy — this is a living file a human reads in thirty seconds, not a charter.
5. Update the one-line comment at the top of the file: `<!-- last updated: <date> — <what changed and why, one clause> -->`.

## Done when

- `.claude/memory/constitution.md` exists
- `/speckit-plan` and `/speckit-implement` in this repo will actually read and honor it
