#!/usr/bin/env bash
# Install the SDLC kit into an existing WordPress project.
#
# Usage: bin/install.sh /path/to/project [--force] [--no-claude] [--no-deploy]
#
# Existing files are never overwritten unless --force is given.
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET=""
FORCE=0
WITH_CLAUDE=1
WITH_DEPLOY=1

for arg in "$@"; do
	case "$arg" in
		--force) FORCE=1 ;;
		--no-claude) WITH_CLAUDE=0 ;;
		--no-deploy) WITH_DEPLOY=0 ;;
		-h|--help) sed -n '2,6p' "${BASH_SOURCE[0]}"; exit 0 ;;
		-*) echo "Unknown option: $arg" >&2; exit 1 ;;
		*) TARGET="$arg" ;;
	esac
done

if [ -z "$TARGET" ] || [ ! -d "$TARGET" ]; then
	echo "Usage: bin/install.sh /path/to/project [--force] [--no-claude] [--no-deploy]" >&2
	exit 1
fi
TARGET="$(cd "$TARGET" && pwd)"

if [ "$TARGET" = "$KIT_DIR" ]; then
	echo "Target is the kit itself." >&2
	exit 1
fi

ADDED=0
SKIPPED=0
SKIPPED_LIST=""

copy_file() {
	local rel="$1"
	local src="$KIT_DIR/$rel"
	local dst="$TARGET/$rel"
	[ -f "$src" ] || return 0
	if [ -e "$dst" ] && [ "$FORCE" -ne 1 ]; then
		echo "  skip   $rel (exists)"
		SKIPPED=$((SKIPPED + 1))
		SKIPPED_LIST="$SKIPPED_LIST $rel"
		return 0
	fi
	mkdir -p "$(dirname "$dst")"
	cp "$src" "$dst"
	echo "  add    $rel"
	ADDED=$((ADDED + 1))
}

copy_dir() {
	local rel="$1"
	[ -d "$KIT_DIR/$rel" ] || return 0
	while IFS= read -r f; do
		f="${f#"$KIT_DIR"/}"
		if [ "$WITH_DEPLOY" -ne 1 ] && [ "$f" = ".github/workflows/deploy.yml" ]; then
			continue
		fi
		copy_file "$f"
	done < <(find "$KIT_DIR/$rel" -type f | sort)
}

echo "Installing SDLC kit into $TARGET"

for f in composer.json package.json phpcs.xml phpstan.neon phpunit.xml.dist playwright.config.ts \
	lefthook.yml .editorconfig .gitignore .distignore .wp-env.json; do
	copy_file "$f"
done

copy_dir .github
copy_dir docs
copy_dir tests

if [ "$WITH_CLAUDE" -eq 1 ]; then
	copy_file CLAUDE.md
	copy_dir .claude
fi

echo
echo "Added $ADDED file(s), skipped $SKIPPED."

if [ "$SKIPPED" -gt 0 ]; then
	echo
	echo "Skipped files already exist. Merge by hand if needed:$SKIPPED_LIST"
	case "$SKIPPED_LIST" in
		*composer.json*) echo "  - composer.json: add the require-dev block, config.allow-plugins and scripts from the kit." ;;
	esac
	case "$SKIPPED_LIST" in
		*package.json*) echo "  - package.json: add the scripts and devDependencies from the kit." ;;
	esac
	case "$SKIPPED_LIST" in
		*.gitignore*) echo "  - .gitignore: make sure vendor/, node_modules/, dist/ are ignored." ;;
	esac
fi

cat <<'NEXT'

Next steps
  1. Edit phpcs.xml (text domain, prefix, PHP/WP versions) and fill in CLAUDE.md.
  2. composer install && npm install
  3. npx lefthook install
  4. composer check
  5. Set GitHub secrets for deploy (see docs/RUNBOOK.md), run Deploy with dry_run first.
  6. Protect main: require PR and the CI checks (see docs/SDLC.md).
NEXT
