# Frontend — Interface CJD (définitive)

Application **Paheko** avec une interface **fixe** aux couleurs et à la mise en page CJD.  
Il n'y a **pas de thèmes interchangeables** : seules les fonctionnalités métier sont celles de Paheko.

## Stack

- **Vite 6** + **Tailwind CSS v4**
- Sources : `src/admin/`
- Build : `src/www/admin/static/dist/`

## Commandes

```bash
npm install
npm run build    # production
npm run dev      # watch
```

Depuis `src/` : `make frontend`

## Structure

| Dossier | Rôle |
|---------|------|
| `tokens.css` | Couleurs et typos CJD (fixes) |
| `components/shell.css` | Header + layout application |
| `components/` | UI (forms, nav, alertes…) |
| `legacy/` | CSS métier Paheko (tableaux, compta, formulaires) |
| `media/` | handheld, print |

## Personnalisation autorisée

- Logo, favicon, icône (Configuration → Personnalisation)
- Texte de la page d'accueil

**Non disponible** : couleurs, thème sombre, CSS admin sur mesure, image de fond.
