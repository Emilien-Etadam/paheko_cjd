{assign var="subject" value="Votre identifiant de connexion a été modifié"}
{* [CJD Section] Refonte couche 2 — 2026 *}
{include file="emails/_cjd_header.tpl"}

Vos informations de connexion ont été modifiées.

Votre nouvel identifiant de connexion est le suivant :

{$new_login}

Vous pouvez utiliser cet identifiant pour vous connecter
à votre association à l'adresse suivante :

{$admin_url}

Ce message est envoyé automatiquement lorsque votre identifiant est modifié.

{include file="emails/_cjd_footer.tpl"}