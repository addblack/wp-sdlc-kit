import { defineConfig } from '@playwright/test';

// Runs against the wp-env site (npm run env:start). Change baseURL for staging.
export default defineConfig( {
	testDir: './tests/e2e',
	retries: process.env.CI ? 1 : 0,
	reporter: [ [ 'list' ], [ 'html', { open: 'never' } ] ],
	use: {
		baseURL: process.env.WP_BASE_URL || 'http://localhost:8888',
		trace: 'on-first-retry',
	},
} );
