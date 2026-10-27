<?php
/**
 * Sample test. Replace with real tests.
 *
 * @package project
 */

/**
 * Sample test case.
 */
class SampleTest extends WP_UnitTestCase {

	/**
	 * WordPress should be loaded by the test bootstrap.
	 */
	public function test_wordpress_is_loaded() {
		$this->assertTrue( function_exists( 'add_action' ) );
	}
}
