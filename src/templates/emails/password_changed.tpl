{assign var="subject" value="Mot de passe modifié"}
{* [CJD Section] Refonte couche 2 — 2026 *}
{include file="emails/_cjd_header.tpl"}

Le mot de passe de votre compte a bien été modifié, conformément à votre demande.

La demande émanait de l'adresse IP :
{$ip}

Si vous n'avez pas demandé à changer votre mot de passe, merci de nous le signaler.

Pour rappel, votre identifiant de connexion est :
{$login}

Pour vous reconnecter, utilisez cette adresse :
{$admin_url}

Ce message est envoyé automatiquement lorsque votre mot de passe est modifié.

{include file="emails/_cjd_footer.tpl"}