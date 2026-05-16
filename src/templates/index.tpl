{include file="_head.tpl" title="Bonjour %s !"|args:$logged_user->name() current="home"}

{$banner|raw}

{if !$has_extensions && $session->canAccess($session::SECTION_CONFIG, $session::ACCESS_ADMIN)}
	<div class="block help">
		<h2>Besoin d'autres fonctionnalités&nbsp;?</h2>
		<p>Paheko dispose d'autres fonctionnalités sous forme d'extensions optionnelles : caisse, carte de membre, reçus fiscaux, notes de frais, réservations, etc.</p>
		<p>{linkbutton href="!config/ext/?install=1" label="Activer des extensions" shape="check"}</p>
	</div>
{/if}

<nav class="tabs">
	<aside>
		{if $session->canAccess($session::SECTION_CONFIG, $session::ACCESS_ADMIN)}
			{linkbutton shape="edit" label="Modifier le texte de l'accueil" href="!config/edit_file.php?k=admin_homepage" target="_dialog"}
		{/if}
		{button id="homescreen-btn" label="Installer comme application web" class="hidden" shape="plus"}
	</aside>
	{if $logged_user && $logged_user->exists()}
		<ul>
			<li><a href="{$admin_url}me/">Mes informations personnelles</a></li>
			<li><a href="{$admin_url}me/services.php">Suivi de mes activités et cotisations</a></li>
		</ul>
	{else}
		<div style="clear: both"></div>
	{/if}
</nav>

{if $is_logged && $session->canAccess($session::SECTION_USERS, $session::ACCESS_READ)}
{* Démo : retirer les assign ci-dessous quand le PHP passera users_count, services_ok_count, services_late_count *}
{if !isset($users_count)}{assign var='users_count' value=128}{/if}
{if !isset($services_ok_count)}{assign var='services_ok_count' value=95}{/if}
{if !isset($services_late_count)}{assign var='services_late_count' value=12}{/if}
<div class="cjd-kpis">
	{if isset($users_count)}
	<div class="cjd-kpi">
		<strong>{$users_count}</strong>
		<span>Membres</span>
	</div>
	{/if}
	{if isset($services_ok_count)}
	<div class="cjd-kpi cjd-kpi--ok">
		<strong>{$services_ok_count}</strong>
		<span>Cotisations à jour</span>
	</div>
	{/if}
	{if isset($services_late_count) && $services_late_count > 0}
	<div class="cjd-kpi cjd-kpi--warn">
		<strong>{$services_late_count}</strong>
		<span>En retard</span>
	</div>
	{/if}
</div>
{/if}

<div class="cjd-dashboard">
	<aside class="cjd-dashboard__org describe">
		<h3>{$config.org_name}</h3>
		{if !empty($config.org_address)}
		<p>{$config.org_address|escape|nl2br}</p>
		{/if}
		{if !empty($config.org_phone)}
		<p>Tél. : <a href="tel:{$config.org_phone}">{$config.org_phone}</a></p>
		{/if}
		{if !empty($config.org_email)}
		<p>E-Mail : <a href="mailto:{$config.org_email}">{$config.org_email}</a></p>
		{/if}
		{if $site_url}
		<p>Web : <a href="{$site_url}" target="_blank">{$site_url}</a></p>
		{/if}
	</aside>

	{if !empty($buttons)}
		<nav class="home cjd-dashboard__actions">
			<ul>
			{foreach from=$buttons item="button"}
				<li>{$button|raw}</li>
			{/foreach}
			</ul>
		</nav>
	{/if}

	{if $homepage}
		<article class="web-content home-text cjd-dashboard__content">
			{$homepage|raw}
		</article>
	{/if}
</div>

<script type="text/javascript" src="{$admin_url}static/scripts/homescreen.js" defer="defer"></script>

{include file="_foot.tpl"}
