import { defineConfig } from 'vite';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const outDir = path.resolve(__dirname, '../build/cjd-web');

export default defineConfig({
	root: __dirname,
	base: './',
	build: {
		outDir,
		emptyOutDir: false,
		manifest: false,
		cssMinify: true,
		rollupOptions: {
			input: {
				default: path.resolve(__dirname, 'src/brindille/default.css'),
				content: path.resolve(__dirname, 'src/brindille/content.css'),
			},
			output: {
				assetFileNames: '[name][extname]',
				entryFileNames: '[name].js',
			},
		},
	},
});
