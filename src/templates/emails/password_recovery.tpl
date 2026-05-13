{assign var="subject" value="Mot de passe perdu ?"}
{* [CJD Section] Refonte couche 2 — 2026 *}
{include file="emails/_cjd_header.tpl"}

Vous avez oublié votre mot de passe ? Pas de panique !

Il vous suffit de cliquer sur le lien ci-dessous pour modifier votre mot de passe :

{$recovery_url}

Si vous n'avez pas demandé à recevoir ce message, ignorez-le, votre mot de passe restera inchangé.

{include file="emails/_cjd_footer.tpl"}
