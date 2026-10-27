---
description: Prepare a release - checks, version bump, changelog, tag
argument-hint: <patch|minor|major>
---

Prepare a `$ARGUMENTS` release.

1. Make sure the working tree is clean and we are on an up-to-date `main`. Stop and tell me if not.
2. Run `composer check` and the test suites. Stop on any failure.
3. Find the current version (plugin header `Version:`, theme `style.css`, `readme.txt` Stable tag, any `VERSION` constant). List every place.
4. Read commits since the last tag (`git log $(git describe --tags --abbrev=0)..HEAD --oneline`). Confirm the bump matches the commits: breaking change -> major, `feat` -> minor, otherwise patch. Tell me if it does not.
5. Update the version in all places and add a changelog entry grouped by Added / Changed / Fixed.
6. Commit as `chore(release): vX.Y.Z` and create the annotated tag `vX.Y.Z`.
7. Do NOT push. Show me the exact commands (`git push origin main` and `git push origin vX.Y.Z`) and explain that the tag push triggers the release workflow.
