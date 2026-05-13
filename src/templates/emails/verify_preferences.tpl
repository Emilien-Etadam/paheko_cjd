{assign var="subject" value="Confirmez vos préférences d'envoi"}
{* [CJD Section] Refonte couche 2 — 2026 *}
{include file="emails/_cjd_header.tpl"}

Vous avez demandé à vous réabonner aux envois suivants :
{if $preferences.accepts_messages}
- messages personnels{/if}{if $preferences.accepts_reminders}
- rappels de cotisation et d'activité{/if}{if $preferences.accepts_mailings}
- messages collectifs et lettres d'information{/if}

Pour confirmer que vous souhaitez recevoir ces messages,
merci de bien vouloir cliquer sur le lien ci-dessous :

{$verify_url}

{include file="emails/_cjd_footer.tpl"}
