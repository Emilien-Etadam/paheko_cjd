# MERGE-NOTES — refonte présentation CJD (couche 2)

## 1. Fichiers upstream modifiés (suivi conflits futurs)

- `src/templates/_head.tpl`
- `src/templates/_foot.tpl`
- `src/templates/login.tpl`
- `src/templates/index.tpl`
- `src/templates/emails/password_recovery.tpl`
- `src/templates/emails/verify_email.tpl`
- `src/templates/emails/login_changed.tpl`
- `src/templates/emails/password_changed.tpl`
- `src/templates/emails/verify_preferences.tpl`
- `src/www/admin/static/admin.css` (commentaire + import `99-cjd-theme.css`)

## 2. Fichiers / assets créés (zéro conflit upstream)

- `src/www/admin/static/styles/99-cjd-theme.css`
- `src/www/admin/static/logos/cjd-logo.svg`
- `src/www/admin/static/logos/cjd-logo-white.svg`
- `src/www/admin/static/pics/cjd/picto-reflechir.svg`
- `src/www/admin/static/pics/cjd/picto-former.svg`
- `src/www/admin/static/pics/cjd/picto-experimenter.svg`
- `src/www/admin/static/pics/cjd/picto-engager.svg`
- `src/www/admin/static/pics/cjd/picto-developper.svg`
- `src/templates/emails/_cjd_header.tpl`
- `src/templates/emails/_cjd_footer.tpl`

## 3. Variables Smartyer introduites

Définies par défaut en tête de `_head.tpl` (assign si absent) :

- `$cjd_section_name`
- `$cjd_section_rna`
- `$cjd_section_president`
- `$cjd_section_logo_url`
- `$cjd_pillar_active`

Attribut HTML : `data-cjd-section` sur `<html>` (valeur = nom de section).

**Couche 3** : assigner ces variables côté PHP (plugin de configuration section) pour personnaliser RNA, président·e, logo régional.

## 4. Comportements modifiés

- **Variables CSS `--g*`** : remappées dans `99-cjd-theme.css` avec des triplets **R, G, B** pour celles utilisées via `rgb(var(--g…))` / `rgba(var(--g…), α)` (contrairement à une notation hex seule, incompatible avec le code existant).
- **Mode sombre** : suppression de l’inversion globale `filter` sur `html.dark` ; palette sombre redéfinie manuellement (fond #0A0A0A, menu noir, liens verts, en-têtes de tableaux verts sur noir, etc.).
- **Bandeau pattern** : barre fixe 4px en bas de viewport via `body::after` dans `99-cjd-theme.css` (toutes les pages utilisant `admin.css`).
- **Footer admin** : bloc `footer.cjd-admin-footer` inséré dans `_foot.tpl` lorsque `$layout !== 'public'` (le footer public existant est inchangé).
- **Menu** : bloc complémentaire `.cjd-branding` avec logo national SVG ou `$cjd_section_logo_url` si renseigné ; le logo configuré Paheko dans `figure.logo` est conservé.
- **Page de connexion** : `hide_title=true` sur l’include `_head.tpl` pour éviter le doublon avec l’accroche CJD ; wrapper `.cjd-login-wrapper` + hero (logo blanc + tagline).
- **Tableau de bord** : section `.cjd-dashboard-stats` avec compteurs placeholder (`—`) et commentaires `{* TODO couche 3 : … *}` — **aucune donnée** assignée dans `src/www/admin/index.php` à ce stade.

## 5. E-mails système (lecture `Paheko\Email\Templates` + `Emails::queue`)

Les e-mails en `CONTEXT_SYSTEM` sont mis en file avec un corps **texte** ; la partie HTML est générée par `htmlspecialchars` + `nl2br` sur ce texte (`Emails::queue`, branche `!$template`). **Les gabarits ne doivent donc pas contenir de HTML brut** : les partiels `_cjd_header.tpl` / `_cjd_footer.tpl` sont en **texte** (séparateurs, mentions section, rappel des codes couleur en libellé).

Pour un **HTML riche** (tables Outlook, images distantes), il faudra une évolution **côté PHP** (corps HTML dédié non échappé ou multipart explicite).

## 6. Tests visuels recommandés après déploiement

- `/login` : refonte, soumission, captcha éventuel, OIDC, liens aide.
- `/` : dashboard + bandeau + stats placeholder.
- `/users/` : liste, `.quick-search`, formulaires.
- `/users/new` : formulaire `dl` / `.block` / `.help`.
- `/users/details.php?id=X` : fiche membre.
- `/acc/` et `/acc/transactions/new` : formulaires complexes (JS inchangé).
- `/docs/` : datepicker, modales.
- `/config/custom.tpl` ou équivalent personnalisation : vérifier que le CSS instance chargé après `admin.css` reste prioritaire sur `99-cjd-theme.css`.
- `/me/preferences` : bascule thème sombre (palette CJD dark, sans inversion brute).

## 7. Note technique cascade CSS

Ordre de chargement inchangé côté `_head.tpl` : `admin.css` (inclut `00-reset` … `10-accounting` puis `99-cjd-theme`) puis éventuels `custom_css`, plugins, puis `ADMIN_CUSTOM_CSS` — la personnalisation instance reste en tête de cascade pour surcharger le thème CJD.
