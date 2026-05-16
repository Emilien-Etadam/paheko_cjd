import js from '@eslint/js';
import globals from 'globals';

const adminScripts = '../src/www/admin/static/scripts';

export default [
	{
		ignores: [
			'node_modules/**',
			`${adminScripts}/lib/**`,
			`${adminScripts}/**/*.min.js`,
		],
	},
	js.configs.recommended,
	{
		files: [`${adminScripts}/**/*.js`],
		languageOptions: {
			ecmaVersion: 2022,
			sourceType: 'script',
			globals: {
				...globals.browser,
				g: 'readonly',
				garradin: 'readonly',
				$: 'readonly',
			},
		},
		rules: {
			'no-var': 'off',
			'require-jsdoc': 'off',
			'no-unused-vars': ['warn', { argsIgnorePattern: '^_', caughtErrorsIgnorePattern: '^_' }],
		},
	},
];
