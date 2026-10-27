# Decision log (ADR)

One entry per significant decision. Newest at the top. Never rewrite history: supersede an old decision with a new entry.

## Template

```
## ADR-NNNN: Short title

- Date: YYYY-MM-DD
- Status: Proposed | Accepted | Superseded by ADR-NNNN

### Context
What problem, what constraints.

### Decision
What we chose, in one or two sentences.

### Alternatives considered
- Option A - why not
- Option B - why not

### Consequences
What gets easier, what gets harder, what to revisit and when.
```

## ADR-0001: Use the WordPress SDLC kit

- Date: TODO
- Status: Accepted

### Context
We want the same quality gates, release flow and deploy process on every WordPress project.

### Decision
Adopt the kit: WPCS + PHPStan + PHPUnit + Playwright in CI, trunk-based flow with Conventional Commits, SemVer tags for releases, rsync-over-SSH deploy from `main`.

### Alternatives considered
- Ad-hoc setup per project - inconsistent, easy to skip checks.

### Consequences
Every project carries the same config files; updates to the kit are copied in with `bin/install.sh --force`.
