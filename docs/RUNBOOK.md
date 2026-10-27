# Runbook

## Deploy

- Automatic: push or merge to `main` runs `.github/workflows/deploy.yml`.
- Manual dry run: Actions -> Deploy -> Run workflow -> `dry_run` on. Read the `rsync` change list. Lines with `*deleting` are files that will be removed on the server.
- Required secrets: `SSH_HOST`, `SSH_USER`, `SSH_PRIVATE_KEY`, `DEPLOY_PATH` (and `SSH_PORT` if not 22). Optional variables: `DEPLOY_DIRS`, `POST_DEPLOY_CMD`.
- Use a dedicated deploy user and a dedicated SSH key. Never deploy as root (files become root-owned and WordPress cannot update them).
- Files listed in `.distignore` are not uploaded. Add anything that exists only on production (uploads, cache, custom config).

## Verify after deploy

1. Open the site and the admin. Check the asset `?ver=` or the plugin/theme version in the admin.
2. Check `wp-content/debug.log` for new errors.
3. Run through the critical flow (login, checkout, form, whatever matters for this project).

## Roll back

1. Fast: restore the last backup on the server. Backups are in `~/deploy-backups/` (last 5 are kept):
   `cd <DEPLOY_PATH> && tar xzf ~/deploy-backups/deploy-YYYYMMDD-HHMMSS.tgz`
2. Clean: revert the bad commit on `main` (`git revert <sha>`), push, let the deploy run.
3. If a migration ran, follow the rollback note from that PR. Restore the DB backup only as a last resort.

## Incident checklist

1. Confirm the impact and note the time. Tell stakeholders early.
2. Take a database backup before touching anything: `wp db export`.
3. White screen or fatal error: read `debug.log`; if a plugin is the cause, `wp plugin deactivate <slug>`.
4. Suspected compromise: change all passwords and salts, check `wp core verify-checksums` and `wp plugin verify-checksums --all`, review users and recent file changes.
5. After recovery: write 5 lines (what happened, cause, fix, how to prevent) in `docs/DECISIONS.md` or an incident note, and add a test or check that would have caught it.

## Routine

- Weekly: review Dependabot PRs, WordPress and plugin updates (on staging or via CI first).
- Monthly: restore a backup into a test environment to prove backups work.
