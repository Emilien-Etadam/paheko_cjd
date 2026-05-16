import { defineConfig } from 'vite';
import tailwindcss from '@tailwindcss/vite';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const staticDir = path.resolve(__dirname, '../src/www/admin/static');

export default defineConfig({
	plugins: [tailwindcss()],
	root: __dirname,
	base: './',
	build: {
		outDir: path.join(staticDir, 'dist'),
		emptyOutDir: true,
		manifest: false,
		cssMinify: true,
		rollupOptions: {
			input: path.resolve(__dirname, 'src/admin/admin.css'),
			output: {
				assetFileNames: '[name][extname]',
				entryFileNames: '[name].js',
			},
		},
	},
	server: {
		port: 5173,
		strictPort: true,
		watch: {
			ignored: ['**/node_modules/**', '**/dist/**'],
		},
	},
});
