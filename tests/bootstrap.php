<?php
/**
 * PHPUnit bootstrap for WordPress integration tests (runs inside wp-env tests-cli).
 *
 * Set PLUGIN_MAIN_FILE if the plugin main file is not named after the folder.
 * For a theme, replace the plugin loader below with switch_theme().
 *
 * @package project
 */

$tests_dir = getenv( 'WP_TESTS_DIR' );
if ( ! $tests_dir ) {
	$tests_dir = '/wordpress-phpunit';
}

if ( ! defined( 'WP_TESTS_PHPUNIT_POLYFILLS_PATH' ) ) {
	define( 'WP_TESTS_PHPUNIT_POLYFILLS_PATH', dirname( __DIR__ ) . '/vendor/yoast/phpunit-polyfills' );
}

require_once $tests_dir . '/includes/functions.php';

tests_add_filter(
	'muplugins_loaded',
	static function () {
		$main = getenv( 'PLUGIN_MAIN_FILE' );
		if ( ! $main ) {
			$main = basename( dirname( __DIR__ ) ) . '.php';
		}
		require dirname( __DIR__ ) . '/' . $main;
	}
);

require $tests_dir . '/includes/bootstrap.php';
