import { test, expect } from '@playwright/test';

test( 'front page loads without PHP errors', async ( { page } ) => {
	const response = await page.goto( '/' );
	expect( response?.status() ).toBeLessThan( 400 );

	const body = await page.content();
	expect( body ).not.toMatch( /Fatal error|Parse error|Warning:|Notice:/ );
} );
