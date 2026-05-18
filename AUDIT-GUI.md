# Audit faisabilité refonte GUI — Paheko

**Périmètre dépôt :** `/workspace` (miroir GitHub ; développement principal sur Fossil, cf. `README.md:11`).  
**Version applicative lue :** `src/VERSION` → `1.3.20`.  
**Méthode :** lecture statique uniquement ; aucun fichier applicatif modifié ; métriques obtenues par `find` / `wc` sur l’arbre au moment de l’audit.

---

## 1. Cartographie de la stack frontend

### Moteur(s) de templates et versions

| Couche | Technologie | Fichier / preuve | Version dans ce dépôt |
|--------|----------------|------------------|------------------------|
| Admin (fichiers `.tpl`) | **Smartyer** (API type Smarty, non Twig) | `Paheko\Template` étend `\KD2\Smartyer` : `src/include/lib/Paheko/Template.php:18` | **Non présent dans le dépôt** : classe attendue listée dans `src/include/lib/dependencies.list:41` (`KD2/Smartyer.php`). Numéro de version du framework KD2 : **non lisible ici** ; empreinte de référence amont : `build/kd2fw.version` (hash seul, pas un numéro semver). |
| Modules / squelettes utilisateur | **Brindille** via `Paheko\UserTemplate\UserTemplate` | `src/include/lib/Paheko/UserTemplate/UserTemplate.php:43` (`extends \KD2\Brindille`, `dependencies.list:6`) | Idem : sources KD2 hors arbre. |
| Site web / rendu contenu | Markdown, Skriv, extensions HTML | `src/include/lib/Paheko/Web/Render/` | Hors périmètre admin strict, mais impacte `content.css` chargé sur certaines pages admin. |

**Constante `ROOT` :** `dirname(__DIR__)` depuis `src/include/init.php` → racine code = `src/` : `src/include/init.php:89-91`.

### Emplacement des templates `.tpl`

- **Répertoire unique Smartyer admin :** `src/templates/` (configuré dans `Paheko\Template::init()` : `src/include/lib/Paheko/Template.php:121` : `setTemplatesDir(ROOT . '/templates')` → `src/templates`).
- **Sous-dossiers contenant des `.tpl` :**  
  `src/templates/` (racine), `acc/`, `acc/accounts/`, `acc/charts/`, `acc/charts/accounts/`, `acc/projects/`, `acc/reports/`, `acc/transactions/`, `acc/years/`, `common/`, `common/files/`, `common/search/`, `config/`, `config/advanced/`, `config/backup/`, `config/categories/`, `config/ext/`, `config/fields/`, `config/server/`, `config/users/`, `docs/`, `emails/`, `me/`, `services/`, `services/fees/`, `services/reminders/`, `services/user/`, `users/`, `users/mailing/`, `users/mailing/status/`, `web/`  
  (liste obtenue par `find … -name '*.tpl' -printf '%h\n' | sort -u`).

**Modules Brindille :** le code prévoit `UserTemplate::DIST_ROOT = ROOT . '/modules/'` (`src/include/lib/Paheko/UserTemplate/UserTemplate.php:48`) ; le répertoire `modules/` **n’est pas présent** dans ce clone (données / paquets séparés — **à vérifier** sur une installation complète).

### Assets statiques (CSS, JS, images, polices)

| Type | Emplacement principal |
|------|------------------------|
| CSS admin agrégé | `src/www/admin/static/admin.css` (imports `@import` des feuilles `styles/*.css`) : `src/www/admin/static/admin.css:1-9` |
| Feuilles modulaires admin | `src/www/admin/static/styles/*.css` (00-reset … 10-accounting, etc.) |
| CSS complémentaires | `src/www/admin/static/handheld.css`, `print.css`, `scripts/web_editor.css`, `scripts/code_editor.css`, `scripts/lib/prism/prism_editor.css`, `scripts/lib/webdav.css`, `font/paheko.css` |
| JS | `src/www/admin/static/scripts/` (33 fichiers `.js`, dont `global.js`, éditeurs, datepicker, webdav, compta, etc.) |
| Icônes / images | `src/www/admin/static/pics/` (PNG alignement texte, etc.) ; fond par défaut référencé côté config : `src/include/init.php:217` (`ADMIN_BACKGROUND_IMAGE` → `WWW_URL . 'admin/static/bg.png'`) |
| Police / pictos | `src/www/admin/static/font/` (`paheko.css` + fichiers de glyphes associés selon convention `@font-face` dans cette feuille) |
| Doc hors admin | `doc/index.css` |

**Fichier `content.css` :** généré / servi depuis l’espace données site (`BASE_URL . 'content.css'`), assigné par exemple sur l’accueil admin : `src/www/admin/index.php:37` — **contenu non versionné dans ce dépôt** (comportement **à vérifier** sur instance).

### Build (webpack, vite, npm, etc.)

- **Aucun** `package.json` ni `composer.json` à la racine du dépôt : build front **inexistant** ; CSS/JS **servis tels quels** avec paramètre de cache `version_hash` dans les URLs (`src/templates/_head.tpl:13-14`, `assign` dans `src/include/lib/Paheko/Template.php:125`).

### Frameworks CSS / JS embarqués

- **Pas de Bootstrap / jQuery / React / Vue** identifiés comme dépendances npm ; `global.js` définit un alias minimaliste `window.$` (sélecteur maison) : `src/www/admin/static/scripts/global.js:13-29`.
- **Commentaire historique** « twitter bootstrap » dans `src/www/admin/static/font/paheko.css:40` — pas de bundle Bootstrap dans l’arbre.
- **Librairies locales minifiées / tierces embarquées :** ex. `datepicker2.min.js`, `gibberish-aes.min.js`, `unzipit.min.js`, `prism_editor.js`, `webdav.js`, etc. sous `src/www/admin/static/scripts/lib/`.

### Quantification `.tpl` et `.css`

| Métrique | Valeur | Commande / méthode |
|----------|--------|---------------------|
| Fichiers `.tpl` | **262** | `find /workspace -name '*.tpl' \| wc -l` |
| Lignes `.tpl` (total) | **14 385** | `find … '*.tpl' -print0 \| xargs -0 wc -l` |
| Fichiers `.css` (tout le dépôt) | **22** | `find /workspace -name '*.css' \| wc -l` |
| Lignes `.css` (tout le dépôt) | **7 241** | idem `wc -l` |
| Fichiers `.css` sous `src/www/admin/static/` | **21** | `find …/admin/static -name '*.css' \| wc -l` |
| Lignes `.css` sous `src/www/admin/static/` | **7 015** | `wc -l` sur ce sous-arbre |
| Fichiers `.js` sous `src/www/admin/static/scripts/` | **33** | `find … \| wc -l` |
| Lignes `.js` (dudit répertoire) | **7 497** | `wc -l` |

---

## 2. Séparation logique / présentation

### MVC et scripts PHP admin

- Chaque écran admin est typiquement un script PHP sous `src/www/admin/**/*.php` qui instancie `Form`, assigne des variables au singleton `Template::getInstance()` puis appelle `$tpl->display('…tpl')` (pattern visible dès `src/www/admin/_inc.php:25-28` + usages massifs listés en section 7).
- La logique métier lourde est en principe **hors** des `.tpl` ; les templates consomment des objets / tableaux déjà préparés (`foreach` sur `$list->iterate()`, etc.).

### Logique « Smarty » dans les templates

- Les `.tpl` contiennent des `{if}`, `{foreach}`, modificateurs (`|truncate`, `|args`, etc.) et des blocs PHP courts pour variables globales (`_head.tpl` mélange Smartyer et balises PHP : `src/templates/_head.tpl:1-4`, `15-19`, `49-50`, `54-60`, `65`).
- **Risque de complexité** : pages documents, compta, recherche avancée (nombreux `foreach` imbriqués, listes dynamiques). Exemples de boucles : `src/templates/docs/index.tpl` (cf. grep `foreach` sur `docs/index.tpl` dans l’arbre), `src/templates/acc/transactions/new.tpl` (fichier long — **à vérifier** ligne par ligne lors d’une refonte).
- **Aucune requête SQL brute** repérée dans un échantillon grep `{if.*sql|SELECT` sur `src/templates` ; la logique SQL reste côté PHP / `UserTemplate` modules (hors `.tpl` admin).

### HTML généré côté PHP (hors templates)

**Fort couplage présentation / PHP** (impact direct sur refonte CSS ou changement de classes) :

| Zone | Rôle | Fichier (extrait) |
|------|------|-------------------|
| Formulaires, champs, listes | Génération HTML des `{input …}` et structures `<dl><dt><dd>` | `src/include/lib/Paheko/UserTemplate/CommonFunctions.php` (nombreux `sprintf` HTML : ex. `…:334`, `…:485`, `…:519`) |
| Messages d’erreur formulaire | Bloc `<div class="block error">…` | `src/include/lib/Paheko/Template.php:305` (`formErrors` / erreurs) |
| Couleurs / CSS variables inline | `<style> :root { --gMainColor … }` + lien `admin_css` | `src/include/lib/Paheko/Template.php:325-336` (`customColors`) |
| Bouton copier, quotas, permissions | HTML inline | `src/include/lib/Paheko/Template.php:384-387`, `…:350-381` |
| Rendu site / galerie | Wrapping `<div class="web-content">` etc. | `src/include/lib/Paheko/Web/Render/AbstractRender.php:216` ; `Extensions.php` (`…:119-305`, figures, vidéos) |
| Export CSV HTML | Lecture de feuilles CSS statiques | `src/include/lib/Paheko/CSV.php:163-164` |

Conséquence : une refonte « uniquement templates » **ne suffit pas** à maîtriser tout le markup : une partie des classes (`dd`, `help`, `input-list`, `block`, `error`, etc.) est **imposée par le PHP**.

---

## 3. Points d’extension officiels (personnalisation visuelle)

### Thème clair / sombre (utilisateur)

- Préférence `dark_theme` sur l’entité utilisateur : `src/include/lib/Paheko/Entities/Users/User.php:63`.
- Application : classe `dark` sur `<html>` si activé : `src/templates/_head.tpl:7`.
- UI de réglage : `src/www/admin/me/preferences.php:35-38`, template `src/templates/me/preferences.tpl:16` (select « Thème »).

### Couleurs, fond, page d’accueil admin, CSS personnalisé (association)

- Écran **Configuration → Personnalisation** : `src/templates/config/custom.tpl:72-98` (couleurs `color1`/`color2`, image de fond, lien vers édition `admin_css`).
- Fichier config stocké : clé `admin_css` pointant vers fichier en contexte config : `src/include/lib/Paheko/Config.php:18-39` (`'admin_css' => File::CONTEXT_CONFIG . '/admin.css'`).
- Injection dans le layout : fonction Smarty `{custom_colors}` → `Template::customColors()` ajoute variables CSS **et** `<link rel="stylesheet"…>` si fichier présent : `src/include/lib/Paheko/Template.php:325-336` ; appel dans `src/templates/_head.tpl:48-50`.

### CSS additionnel instance (`config.local.php`)

- Constante `ADMIN_CUSTOM_CSS` (défaut `null`) : `src/include/init.php:218` ; lien conditionnel dans `src/templates/_head.tpl:49-51`.  
- **Non documentée** dans `src/config.dist.php` au moment de l’audit (**à vérifier** dans la doc Fossil / wiki pour sémantique exacte et chemins autorisés).

### Feuilles par page (`custom_css` / `custom_js`)

- Boucles dans `src/templates/_head.tpl:15-25` sur `$custom_js` / `$custom_css` avec filtre `local_url` pour chemins relatifs `static/`.
- Exemples d’assignation PHP : `src/www/admin/index.php:37`, `src/www/admin/config/_inc.php` (**à lire** : `config/_inc.php` assigne `config.css`), `src/www/admin/web/edit.php:97-103`, etc.

### Plugins : CSS / JS

- `_head.tpl` prévoit `$plugin_css` / `$plugin_js` : `src/templates/_head.tpl:27-35`.
- **Aucune assignation** de ces variables trouvée dans `src/include/lib/Paheko` via recherche `plugin_css|plugin_js` (hors template). Mécanisme **prêt côté layout** ; utilisation réelle par plugins tiers **à vérifier** sur plugin exemple ou doc Plugin.

### Documentation interne

- Modules / Brindille : `doc/admin/modules.md`, `doc/admin/brindille*.md` (personnalisation logique / squelettes, pas CSS admin cœur).
- Snippets d’injection de HTML dans l’UI : `doc/admin/modules.md:73-80` (`snippets/user_details.html`, etc.).

---

## 4. Couplage HTML / logique — risques de casse

### IDs et classes critiques (JS + layout)

| Sélecteur / ID | Usage | Fichier |
|----------------|--------|---------|
| `#dialog` | Création modale, `showModal`, redimensionnement, iframe | `src/www/admin/static/scripts/global.js:150-176`, `329-341` |
| `#menu`, `#content`, `#skip` | Navigation, lien « Aller au contenu », layout principal | `src/templates/_head.tpl:68-71` (`#skip`), `73` (`#menu`), `170` (`<main id="content">`) |
| `html.nojs` / classe `js` | Basculer JS activé | `src/templates/_head.tpl:7`, `src/www/admin/static/scripts/global.js:10-11` |
| `.hidden` | `g.toggle` masque/affiche | `src/www/admin/static/scripts/global.js:52-78` |
| `.quick-search`, `tbody tr.focused` | Navigation clavier listes | `src/www/admin/static/scripts/selector.js:99-106` |
| `[data-required]`, `[data-enhanced]` | Formulaires / fichiers | `src/www/admin/static/scripts/global.js:80-81` ; `src/www/admin/static/scripts/inputs/file.js:194-214` |
| `#f_content`, `#f_format`, `#f_maxsize` | Édition web / chiffrement | `src/www/admin/static/scripts/web_encryption.js:127-160` ; `web_editor.js:13` |
| `#f_pays`, `#f_code_postal`, `#f_ville` | Datalist adresse | `src/www/admin/static/scripts/inputs/datalist.js:229-310` |
| `input[list], textarea[list]` | Initialisation datalist | `src/www/admin/static/scripts/inputs/datalist.js:334` |

**Règle `$` maison :** sélecteurs complexes passent par `querySelectorAll` ; classes/ids simples par `getElementsByClassName` / `getElementById` : `src/www/admin/static/scripts/global.js:13-29`.

### Composants tiers / markup contraint

- **DatePicker** (`<dialog class="datepicker">`, table calendrier, `td.focus`) : généré en JS : `src/www/admin/static/scripts/lib/datepicker2.min.js` (constructeur `DatePicker`, `class:"datepicker"`).
- **Éditeur WYSIWYG / code** : `web_editor.js`, `code_editor.js`, Prism — **structure DOM dédiée** (iframe, toolbar) : risque élevé si refonte CSS modifie `z-index`, `dialog`, `overflow`.
- **WebDAV / éditeur** : CSS et JS couplés sous `scripts/lib/`.

### Formulaires

- Markup des champs **imposé** par `CommonFunctions.php` (voir section 2) : renommer classes ou inverser `dt`/`dd` sans adapter le PHP **casse** thème et probablement JS (aide, `label for`, `MAX_FILE_SIZE` hidden `src/include/lib/Paheko/UserTemplate/CommonFunctions.php:472`).

---

## 5. Stratégie de fork — trois scénarios

| Scénario | Description | Faisabilité | Effort | Maintenabilité amont | Régression fonctionnelle |
|----------|-------------|-------------|--------|----------------------|---------------------------|
| **A — Surcharge CSS uniquement** | S’appuyer sur CSS d’association (`admin_css` / `Template::customColors`), éventuellement `ADMIN_CUSTOM_CSS`, variables `:root` déjà injectées (`--gMainColor`, `--gSecondColor`, `--gBgImage`) : `src/include/lib/Paheko/Template.php:325-332` + surcharge sélecteurs existants dans `src/www/admin/static/styles/*.css` **sans** toucher aux `.tpl`. | **FAISABLE** pour thème, contrastes, typo, espacements limités, mode sombre **déjà partiellement** via préférence utilisateur + classe `.dark`. | **Faible** à **moyen** selon ambition (spécificité CSS élevée pour surcharger 7k+ lignes). | **Excellente** : zéro conflit sur `.tpl` / PHP ; conflits possibles uniquement si amont renomme classes (suivre changelog). | **Faible** si pas de `display:none` sur éléments requis par JS. |
| **B — Modifier templates + CSS lourd** | Conserver la hiérarchie générale (`_head.tpl` / menu / `dialog`) mais ajuster markup dans `src/templates/**/*.tpl`, réécrire surtout `static/styles/*.css` et/ou découper nouvelles feuilles via `custom_css` par section. | **FAISABLE** ; **recommandé** pour refonte visuelle complète **sans** réécrire les générateurs PHP de champs. | **Moyen** à **élevé** (262 `.tpl`, tests manuels étendus). | **Moyenne** : conflits de fusion sur `.tpl` et CSS à chaque release ; limiter aux fichiers nécessaires. | **Moyenne** : risque si IDs/classes couplés au JS (section 4) ou si formulaires déplacés. |
| **C — Réécriture complète des templates + framework utility-first (Tailwind, etc.)** | Remplacer classes sémantiques existantes par utilitaires ; restructurer HTML de chaque écran. | **À ÉVITER** comme stratégie **globale** : coût prohibitif, duplication avec HTML généré en PHP (`CommonFunctions.php`), incompatibilité probable avec plugins / snippets / exports. | **Élevé** | **Très mauvaise** face à l’amont (churn maximal). | **Élevée** (JS, PDF/export table, modales). |

**Verdict global :** combiner **A** (couche surcharge / variables / `admin_css`) + **B** ciblé (templates de layout `_head.tpl` / `_foot.tpl`, navigation, grilles principales) pour le design moderne et responsive ; **éviter C** en tant que stratégie par défaut.

---

## 6. Plan d’action (scénario recommandé : A + B ciblé)

### Fichiers à créer / modifier (ordre suggéré)

1. **`src/www/admin/static/styles/`** — nouvelle feuille dédiée fork (ex. `99-custom-fork.css`) importée depuis `admin.css` **ou** chargée uniquement via mécanisme d’instance (éviter edit direct si objectif = merge facile) : point d’entrée actuel `src/www/admin/static/admin.css:1-9`.
2. **Fichier CSS association** (données, hors git) via UI `config/custom.tpl:86-91` — pour surcharges déployables sans rebuild.
3. **`src/templates/_head.tpl` / `src/templates/_foot.tpl`** — structure meta, liens CSS, landmarks (`#menu`, `#content`) : **haute vigilance** (`src/templates/_head.tpl:7-73`).
4. **Feuilles thématiques** — `src/www/admin/static/styles/01-layout.css`, `05-navigation.css`, `03-forms.css`, `07-tables.css` : impact visuel maximal.
5. **`src/www/admin/static/handheld.css`** — responsive existant : `src/templates/_head.tpl:38-41`.
6. **JS** — éviter ; si nécessaire, encapsuler nouveaux hooks sans modifier sélecteurs critiques listés section 4.

### Vigilance par fichier

| Fichier | Vigilance |
|---------|-----------|
| `_head.tpl` | Ordre chargement CSS ; `plugin_*` ; `custom_colors` ; classes `nojs`/`dark`/`dialog`. |
| `Template.php` (`customColors`, `formErrors`) | Toute modification touche **toutes** les pages ; préférer extension CSS. |
| `CommonFunctions.php` | Changement de markup = impact **tous** formulaires + JS `file.js` / `datalist.js`. |
| `global.js` | Modale `#dialog`, iframes : régressions transverses. |

### Tests de non-régression (proposés)

- **Matrice navigateurs :** Firefox + Chromium ; tester **thème sombre** (`me/preferences.tpl` / classe `dark` sur `html`).
- **Parcours critiques :** login (`login.tpl`), accueil (`index.tpl`), liste membres + fiche (`users/index.tpl`, `users/details.tpl`), saisie écriture (`acc/transactions/new.tpl`), pièces jointes / upload (`common/files/upload.tpl`), dialogue configuration (`config/*.tpl` avec `target="_dialog"`), éditeur mailing (`users/mailing/write.tpl`).
- **Exports :** `_export` / PDF via `Template::display` : `src/include/lib/Paheko/Template.php:34-59` (vérifier rendu table).
- **Accessibilité :** conserver `#skip` → `#content` : `src/templates/_head.tpl:68-71`.

### Stratégie Git (merges amont)

- Branche longue `custom-ui` rebasée régulièrement sur `master` / miroir amont.
- Commits **atomiques** par couche : (1) CSS layout, (2) CSS composants, (3) patch `_head.tpl`, (4) sous-ensemble métier (ex. `users/` seulement).
- **Ne pas** committer le fichier CSS d’association (stockage données) : le documenter dans README fork privé (**hors** ce dépôt si politique équipe).

---

## 7. Inventaire des écrans admin (exhaustif au sens « tout script `src/www/admin/**/*.php` hors statique »)

**Légende complexité refonte (indicatif) :** **L** faible (formulaire simple / liste), **M** moyen (tables + actions), **H** haute (éditeurs, graphes, multétapes, reconciliation).

Les templates listés sont ceux appelés par `$tpl->display(...)` dans le code parcouru ; les scripts sans `display` (téléchargement brut, image SVG, redirection) sont notés **N/A**.

### Authentification / installation / légal

| Écran | Script | Template(s) | Complexité |
|-------|--------|-------------|--------------|
| Connexion | `src/www/admin/login.php:115` | `login.tpl` | M |
| OTP | `src/www/admin/login_otp.php:51` | `login_otp.tpl` | L |
| App mobile | `src/www/admin/login_app.php:57` | `login_app.tpl` | L |
| Installation | `src/www/admin/install.php:52` | `install.tpl` | M |
| Création BD | `src/www/admin/create_db.php:36` | `create_db.tpl` | M |
| Ouvrir BD | `src/www/admin/open_db.php:70` | `open_db.tpl` | M |
| Mot de passe oublié / changement | `src/www/admin/password.php:31,59` | `password_change.tpl`, `password.tpl` | L |
| Légal | `src/www/admin/legal.php:15` | `legal.tpl` | L |
| Préférences e-mail (token) | `src/www/admin/email_preferences.php:63` | `email_preferences.tpl` | L |
| Partage fichier | `src/www/admin/share.php`, `share_legacy.php` | `share_password.tpl`, `share.tpl` | L |

### Accueil & recherche transversale

| Écran | Script | Template(s) | Complexité |
|-------|--------|-------------|--------------|
| Tableau de bord | `src/www/admin/index.php:39` | `index.tpl` | M (plugins, contenu dynamique) |
| Recherche comptable | `src/www/admin/acc/search.php` → `common/search.php:86` | `acc/search.tpl` | H |
| Recherche membres | `src/www/admin/users/search.php:8` (`require …/common/search.php`) | `users/search.tpl` | H |
| Recherches enregistrées compta | `src/www/admin/acc/saved_searches.php` → `common/saved_searches.php:83` | `common/search/saved_searches.tpl` | M |
| Recherches enregistrées membres | `src/www/admin/users/saved_searches.php` (**même** `common/saved_searches.php`) | idem | M |

### Membres (`users/`)

| Écran | Script | Template | Complexité |
|-------|--------|----------|------------|
| Liste / recherche | `users/index.php:66` | `users/index.tpl` | M |
| Nouveau | `users/new.php:68` | `users/new.tpl` | M |
| Détail | `users/details.php:88` | `users/details.tpl` | M |
| Édition | `users/edit.php:63` | `users/edit.tpl` | M |
| Sécurité | `users/edit_security.php:54` | `users/edit_security.tpl` | M |
| Import | `users/import.php:81` | `users/import.tpl` | H |
| Suppression | `users/delete.php:34` | `users/delete.tpl` | L |
| Journal | `users/log.php:34` | `users/log.tpl` | M |
| Action groupée | `users/action.php:67` | `users/action.tpl` | M |
| Message | `users/message.php:51` | `users/message.tpl` | L |
| Sélecteur | `users/selector.php:20` | `users/selector.tpl` | M |

### Mailing / messages collectifs (`users/mailing/`)

| Écran | Script | Template | Complexité |
|-------|--------|----------|------------|
| Liste | `users/mailing/index.php:16` | `users/mailing/index.tpl` | M |
| Nouveau / rédaction | `users/mailing/new.php:48`, `write.php:47` | `…/new.tpl`, `…/write.tpl` | **H** (éditeur) |
| Détail / preview / envoi / destinataires | `details.php:21`, `preview.php:23,36`, `send.php:34`, `recipients.php:28`, `recipient_data.php:23`, `delete.php:22` | templates homonymes `.tpl` | H |
| Statut mailing | `status/index.php:42`, `address.php:21`, `preferences.php:23`, `verify.php:29` | sous-dossier `status/*.tpl` | M |

### Activités & cotisations (`services/`)

| Écran | Script | Template | Complexité |
|-------|--------|----------|------------|
| Liste / détail / édition / import / suppression | `services/index.php:32`, `details.php:37`, `edit.php:35`, `import.php:48`, `delete.php:37` | `services/*.tpl` | M |
| Frais | `services/fees/*.php` | `services/fees/*.tpl` | M |
| Rappels | `services/reminders/*.php` | `services/reminders/*.tpl` | M |
| Inscription membre | `services/user/*.php` (add, edit, index, delete, payment, link, subscribe) | `services/user/*.tpl` | M à H (`subscribe.php:112`) |

### Comptabilité (`acc/`)

| Écran | Script | Template | Complexité |
|-------|--------|----------|------------|
| Sommaire compta | `acc/index.php:25` | `acc/index.tpl` | L |
| Comptes (liste, journal, import, rapprochement, etc.) | `acc/accounts/*.php` | `acc/accounts/*.tpl` (dont `deposit_form.tpl`, `deposit.tpl`) | H pour `reconcile.php:150` |
| Exercices & bilan | `acc/years/*.php` | `acc/years/*.tpl` (nombreux écrans : `first_setup.php:111`, `balance.php:153`, etc.) | H |
| Écritures | `acc/transactions/*.php` | `acc/transactions/*.tpl` (`new.php:158`) | **H** |
| Plans comptables / schémas | `acc/charts/*.php`, `acc/charts/accounts/*.php` | templates miroirs | H |
| Projets analytiques | `acc/projects/*.php` | `acc/projects/*.tpl` | M |
| Rapports (hors graph SVG) | `acc/reports/journal|statement|balance_sheet|ledger|graphs|trial_balance.php` | `.tpl` correspondants | H |
| Graphiques SVG | `acc/reports/graph_plot.php` | **N/A** (image SVG) | — |
| Recherche / sauvegardes | voir section recherche | `acc/search.tpl`, `common/search/saved_searches.tpl` | H |

### Documents (`docs/`)

| Écran | Script | Template | Complexité |
|-------|--------|----------|------------|
| Explorateur | `docs/index.php:152` | `docs/index.tpl` | **H** |
| Recherche / partage / nouveau / déplacement | `search.php:19`, `shares.php:38`, `new_*.php`, `_move.php:78` | `docs/*.tpl` | M à H |
| Actions (delete, zip, lien écriture) | `docs/action.php:53,74,109` | `docs/action_*.tpl` | M |
| Corbeille | `docs/trash.php:90,101` | `docs/trash_delete.tpl`, `docs/trash.tpl` | M |

### Site web (`web/`)

| Écran | Script | Template | Complexité |
|-------|--------|----------|------------|
| Liste / galerie / édition / recherche / pièces jointes / sitemap | fichiers `web/*.php` cités section 1 grep | `web/*.tpl` | H (`edit.php`, `_attach.php`) |

### Configuration (`config/`)

| Écran | Script | Template | Complexité |
|-------|--------|----------|------------|
| Accueil config | `config/index.php:53` | `config/index.tpl` | L |
| Personnalisation visuelle | `config/custom.php:34` | `config/custom.tpl` | M |
| Champs membres | `config/fields/*.php` | `config/fields/*.tpl` | M |
| Utilisateurs techniques | `config/users/*.php` | `config/users/*.tpl` | M |
| Serveur | `config/server/index.php:36` | `config/server/index.tpl` | M |
| Mise à jour | `config/upgrade.php:64` | `config/upgrade.tpl` | M |
| Import données | `config/donnees/import.php:6` | `config/donnees/import.tpl` | M |
| Extensions | `config/ext/*.php` | `config/ext/*.tpl` + `config/ext/_nav.tpl`, `_details.tpl` | H |
| Catégories / sauvegardes / disque / bureau | `config/categories/*.php`, `backup/*.php`, `disk_usage.php`, `desktop.php` | templates homonymes | M |
| Avancé (SQL, API, audit, erreurs, reset, debug) | `config/advanced/*.php` | `config/advanced/*.tpl` | H |
| Édition fichiers config (image, code, web) | `config/edit_file.php:46,53` | `config/edit_image.tpl`, `common/files/edit_web.tpl`, `edit_code.tpl` | M |

### Fichiers communs (`common/files/`)

| Écran | Script | Template | Complexité |
|-------|--------|----------|------------|
| Upload, rename, share, delete, preview, historique | fichiers `common/files/*.php` | `common/files/*.tpl` | M à H (`_preview.php:47`) |

### Espace perso (`me/`)

| Écran | Script | Template | Complexité |
|-------|--------|----------|------------|
| Infos, édition, services, sécurité (mot de passe, OTP, PGP), préférences, export OTP | fichiers `me/*.php` (grep section audit) | `me/*.tpl` | M (`security*.tpl`) |

### Conversion / upgrade / partage legacy

| Écran | Script | Template | Notes |
|-------|--------|----------|-------|
| Conversion média (cache) | `src/www/admin/convert.php:9` (`Conversion::serveFromCache`) | **N/A** (pas de Smartyer) | |
| Mise à jour BD (`upgrade.php` racine admin) | `src/www/admin/upgrade.php:17-22` (`Install::showProgressSpinner`) | **N/A** (sortie générée par `Install`, hors `.tpl` listés ici) | |
| Export données perso | `src/www/admin/me/export.php:9` (`downloadExport()`) | **N/A** | |

### E-mails transactionnels (hors UI admin mais `.tpl`)

- Répertoire `src/templates/emails/` (`verify_email.tpl`, `password_recovery.tpl`, etc.) — refonte branding courriels **séparée** de l’admin ; même moteur Smartyer.

### Écrans métier non dédiés « AG » / « Dons »

- **Assemblée générale / dons** : pas de module UI dédié nommé dans les chemins parcourus ; la doc utilisateur peut passer par **activités / cotisations**, **compta**, **mailing** (convocations évoquées dans `email_preferences.tpl:59`). Modules métier **Brindille** éventuels dans `modules/` — **absents de ce dépôt** (`UserTemplate::DIST_ROOT`, `doc/admin/modules.md:63`).

---

**Synthèse décisionnelle (< 10 min) :** la stack admin est **Smartyer + CSS/JS vanilla** sans pipeline de build ; la personnalisation **CSS d’association et couleurs** est un point d’extension **déjà prévu** (`Template::customColors`, `config/custom.tpl`). Le markup des formulaires est **majoritairement généré en PHP**, ce qui **interdit** une stratégie « Tailwind partout en ne touchant qu’aux `.tpl` » sans douleur. La voie **réaliste** est **surcharge CSS large (A)** complétée par **modifications ciblées des templates et feuilles `static/styles` (B)**, en préservant **IDs et structures attendus par `global.js`**. La réécriture totale type **(C)** est **à éviter** pour la compatibilité avec les mises à jour amont.
