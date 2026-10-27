<?php
/**
 * Sample test. Replace with real tests.
 *
 * @package project
 */

class SampleTest extends WP_UnitTestCase {

	public function test_wordpress_is_loaded() {
		$this->assertTrue( function_exists( 'add_action' ) );
	}
}
