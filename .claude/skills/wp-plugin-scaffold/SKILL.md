---
name: wp-plugin-scaffold
description: Create a new WordPress plugin with a clean structure, PSR-4 autoloading, activation/uninstall handling, i18n and test setup. Use when asked to start a new plugin or add the base structure to an existing one.
---

# WordPress plugin scaffold

Ask for: plugin name, slug, text domain, global prefix, minimum WP and PHP versions, namespace. Use the values from `CLAUDE.md` and `phpcs.xml` if already set.

## Structure

```
my-plugin/
├── my-plugin.php        # header, constants, bootstrap only
├── uninstall.php        # remove options/tables created by the plugin
├── composer.json        # psr-4 autoload for src/
├── src/
│   ├── Plugin.php       # wires hooks, single entry point
│   ├── Admin/
│   ├── Rest/
│   └── Support/
├── languages/
├── assets/              # source; built output goes to build/
└── tests/php/
```

## Rules

- Main file: plugin header (including `Requires at least`, `Requires PHP`, `Text Domain`), `defined( 'ABSPATH' ) || exit;`, constants for version/path/url, require `vendor/autoload.php`, call `Plugin::boot()` on `plugins_loaded`.
- No logic in the main file. Hooks are registered in `Plugin` and delegated to small classes.
- Activation: `register_activation_hook` only for things that must exist before first request (rewrite flush, default options, tables via `dbDelta`). Store `{prefix}_db_version`. Never output anything.
- `uninstall.php`: check `WP_UNINSTALL_PLUGIN`, delete options, transients, custom tables and cron events created by the plugin.
- Prefix every option, transient, hook, cron event and global. Load the text domain on `init`.
- Add one real test per class from the start (see `tests/php/SampleTest.php`) and set `PLUGIN_MAIN_FILE` in `tests/bootstrap.php` if the main file name differs from the folder.
- Finish by running `composer install`, `composer check` and `npm run test:php`, and report the output.
