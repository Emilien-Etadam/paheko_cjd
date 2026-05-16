# Frontend Paheko

Stack de build pour l’interface d’administration : **Vite** + **Tailwind CSS v4**.

## Prérequis

- Node.js ≥ 20
- npm ≥ 10

## Commandes

```bash
cd frontend
npm install
npm run dev      # build en mode watch (développement)
npm run build    # build de production (minifié)
```

Les fichiers générés sont écrits dans `src/www/admin/static/dist/` (`admin.css` + manifest).

## Architecture

| Fichier | Rôle |
|---------|------|
| `src/admin/main.css` | Point d’entrée : Tailwind + imports legacy |
| `src/admin/tokens.css` | Design tokens (`@theme`) pour la charte graphique |
| `vite.config.js` | Build vers `../src/www/admin/static/dist` |

Les feuilles historiques restent dans `src/www/admin/static/styles/` le temps de la migration. Les CSS par page (`config.css`, `mailing.css`, etc.) et les media (`handheld.css`, `print.css`) ne sont pas encore dans le bundle.

## Développement

1. Lancer `npm run dev` dans `frontend/` (recompile à chaque modification).
2. Recharger l’admin Paheko dans le navigateur.

## Release

Depuis `src/` :

```bash
make frontend    # npm ci && npm run build
make minify      # copie dist/admin.css vers mini.css pour l’archive
```

## Prochaines étapes (hors stack)

- Migrer progressivement les fichiers `styles/*.css` vers composants / utilitaires Tailwind.
- Intégrer `handheld.css` et `print.css` au bundle ou les découper en `@media`.
- Bundler le JS admin (`global.js`, etc.) via un second point d’entrée si besoin.
