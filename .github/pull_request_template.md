## What and why

<!-- One or two sentences. Link the issue: Closes #123 -->

## How to test

<!-- Steps a reviewer can follow. -->

## Checklist

- [ ] `composer check` passes locally
- [ ] Tests added or updated (or explained why not)
- [ ] Input sanitized, output escaped, nonces and capabilities checked where relevant
- [ ] No new queries in loops, no unbounded `WP_Query`
- [ ] Strings are translatable (text domain)
- [ ] Docs / `docs/DECISIONS.md` updated if behavior or architecture changed
- [ ] Commits follow Conventional Commits
