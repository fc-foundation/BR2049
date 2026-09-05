---
description: Create or update a feature spec (the WHAT/WHY) from a short description.
argument-hint: [feature description]
---

## Input

$ARGUMENTS

## Do this

1. If no description was given, ask for one and stop.
2. Pick a short kebab-case slug (2-4 words) that captures the feature.
3. List `specs/` to find the next feature number (`NNN`, zero-padded, starting at `001`). Create `specs/NNN-slug/spec.md`.
4. Write the spec with these sections, in this order:
   - **Overview** — one paragraph: what this is and why it matters. No tech.
   - **User Stories** — each tagged with a priority (P1, P2, P3...) and a one-line note on how it'd be tested independently of the others.
   - **Functional Requirements** — numbered (FR-1, FR-2, ...), each one testable on its own, no implementation detail.
   - **Success Criteria** — measurable and technology-agnostic (e.g. "95% of imports finish in under 10s," not "API responds in 200ms").
   - **Out of Scope** — explicit exclusions, so nobody assumes silence means "sure, include it."
   - **Assumptions** — defaults you picked instead of asking about them.
5. Where a decision meaningfully changes scope, security, or user experience and has no reasonable default, mark it `[NEEDS CLARIFICATION: specific question]` — **cap: 3**, ranked scope > security/privacy > UX > technical detail. For everything else, make the reasonable call yourself and note it under Assumptions instead of asking.
6. If any `[NEEDS CLARIFICATION]` markers remain, ask the user about all of them in one message, each with your recommended answer, then fold their answers into the doc and delete the markers. Don't proceed to reporting completion with open markers.
7. Keep tech stack, frameworks, APIs, and file structure out of this document entirely — that's what `/speckit-plan` is for. If you catch yourself naming a library, delete it and rephrase as a user-facing need.

## Done when

- `spec.md` exists with zero `[NEEDS CLARIFICATION]` markers left in it
- every requirement is independently testable
- nothing in it depends on knowing the tech stack
