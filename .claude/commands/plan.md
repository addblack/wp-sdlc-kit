---
description: Turn a task into a short implementation plan before writing code
argument-hint: <task or issue description>
---

Task: $ARGUMENTS

Do not write code yet. Produce a plan:

1. Restate the goal and acceptance criteria in 3-5 bullets. Ask me only about things that block the plan.
2. Inspect the repo to find the files and hooks involved (use Grep/Glob, read `CLAUDE.md` and `docs/ARCHITECTURE.md`).
3. Propose the approach. If there are real alternatives, give two with a one-line trade-off each and recommend one.
4. List the steps as small, separately committable changes, each with the files touched and how it will be tested.
5. Call out risks: security, performance, data migrations, backwards compatibility, deploy order.
6. If the change is architectural, draft an ADR entry for `docs/DECISIONS.md`.

End by asking for approval. After approval, implement step by step and run `composer check` after each step.
