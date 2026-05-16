# Frontend Paheko

Stack de build pour l’interface d’administration : **Vite 6** + **Tailwind CSS v4**.

## Prérequis

- Node.js ≥ 20
- npm ≥ 10

## Commandes

```bash
cd frontend
npm install
npm run dev      # rebuild en continu
npm run build    # production (minifié)
```

Sortie : `src/www/admin/static/dist/`

| Fichier | Usage |
|---------|--------|
| `admin.css` | Bundle principal (admin) |
| `handheld.css` | Media queries mobile |
| `print.css` | Impression |
| `tables-export.css` | Exports CSV/HTML |

## Architecture

```
frontend/src/admin/
├── admin.css           # Point d’entrée principal
├── tokens.css          # Design tokens + variables --g* (legacy)
├── base/
│   └── fonts.css       # Police d’icônes Paheko
├── legacy/             # Styles métier historiques (à migrer)
│   ├── _index.css
│   └── 01-layout.css … 10-accounting.css
├── theme/
│   └── dark.css        # Thème sombre (variables, pas de filter:invert)
├── media/
│   ├── handheld.css
│   └── print.css
├── export/
│   └── tables.css      # Bundle exports tableaux
└── components/         # Nouveaux composants (charte CJD, etc.)
```

### Règles

1. **Ne plus ajouter** de CSS dans `src/www/admin/static/styles/` sauf pages chargées à la demande (`config.css`, `mailing.css`, `web.css`).
2. **Nouveau code** → `components/` avec classes sémantiques ou utilitaires Tailwind.
3. **Migration** : déplacer fichier par fichier de `legacy/` vers `components/`, puis retirer l’import dans `legacy/_index.css`.
4. Les couleurs d’instance restent injectées par PHP (`{custom_colors}` → `--gMainColor`, etc.).

## Intégration PHP

- `_head.tpl` → `static/dist/admin.css`, `handheld.css`, `print.css`
- `Paheko\CSV::exportHTML` → `static/dist/tables-export.css`
- CSS par page (config, mailing, web) : toujours `static/styles/*.css` via `$custom_css`

## Release

```bash
cd src && make frontend   # ou make minify (inclut frontend)
```

Le répertoire `dist/` doit être présent dans l’archive (build commité ou exécuté avant release).
