---
description: Review the current branch with the code and security reviewers
argument-hint: [base branch, default main]
---

Review the current branch against `${ARGUMENTS:-main}`.

1. Run `composer check` and report the result.
2. Use the `code-reviewer` agent on the branch diff.
3. If the diff touches input handling, REST/AJAX, file or option handling, SQL or remote requests, also use the `security-reviewer` agent.
4. Merge the findings into one list ordered Blocker, Should fix, Nit. Remove duplicates.
5. Finish with a clear verdict. Do not change any files.
