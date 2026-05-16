<header class="cjd-shell">
	<div class="cjd-shell__brand">
	{if isset($config) && ($url = $config->fileURL('logo', '150px'))}
		<a href="{$admin_uri}"><img src="{$url}" alt="{$config.org_name|escape}" /><span>{$config.org_name|escape|truncate:24:'…':true}</span></a>
	{else}
		<a href="{$admin_uri}"><span>CJD</span></a>
	{/if}
	</div>
	<button type="button" class="cjd-shell__toggle" aria-expanded="false" aria-controls="cjd-nav">Menu</button>
	<nav class="cjd-shell__nav" id="cjd-nav" aria-label="Navigation principale">
		<ul class="cjd-shell__list">
		{if $is_logged}
		<?php $current_parent = substr($current, 0, strpos($current, '/') ?: strlen($current)); ?>
			<li class="cjd-shell__item home{if $current == 'home'} is-active{elseif $current_parent == 'home'} is-parent{/if}{if !empty($plugins_menu)} has-sub{/if}">
				<a class="cjd-shell__link" href="{$admin_uri}" accesskey="H">{icon shape="home"}<span>Accueil</span></a>
				{if !empty($plugins_menu)}
				<ul class="cjd-shell__sub">
				{foreach from=$plugins_menu key="key" item="html"}
					<li{if $current == $key} class="is-active"{/if}>{$html|raw}</li>
				{/foreach}
				</ul>
				{/if}
			</li>
			{if $session->canAccess($session::SECTION_USERS, $session::ACCESS_READ)}
			<li class="cjd-shell__item has-sub{if $current == 'users'} is-active{elseif $current_parent == 'users'} is-parent{/if}">
				<a class="cjd-shell__link" href="{$admin_uri}users/" accesskey="U">{icon shape="users"}<span>Membres</span></a>
				<ul class="cjd-shell__sub">
				{if $session->canAccess($session::SECTION_USERS, $session::ACCESS_WRITE)}
					<li{if $current == 'users/new'} class="is-active"{/if}><a href="{$admin_uri}users/new.php" accesskey="A">Ajouter</a></li>
				{/if}
					<li{if $current == 'users/services'} class="is-active"{/if}><a href="{$admin_uri}services/">Activités &amp; cotisations</a></li>
				{if !DISABLE_EMAIL && $session->canAccess($session::SECTION_USERS, $session::ACCESS_WRITE)}
					<li{if $current == 'users/mailing'} class="is-active"{/if}><a href="{$admin_uri}users/mailing/">Messages collectifs</a></li>
				{/if}
				</ul>
			</li>
			{/if}
			{if $session->canAccess($session::SECTION_ACCOUNTING, $session::ACCESS_READ)}
			<li class="cjd-shell__item has-sub{if $current == 'acc'} is-active{elseif $current_parent == 'acc'} is-parent{/if}">
				<a class="cjd-shell__link" href="{$admin_uri}acc/">{icon shape="money"}<span>Comptabilité</span></a>
				<ul class="cjd-shell__sub">
				{if $session->canAccess($session::SECTION_ACCOUNTING, $session::ACCESS_WRITE)}
					<li{if $current == 'acc/new'} class="is-active"{/if}><a href="{$admin_uri}acc/transactions/new.php" accesskey="N">Saisie</a></li>
				{/if}
					<li{if $current == 'acc/accounts'} class="is-active"{/if}><a href="{$admin_uri}acc/accounts/">Comptes</a></li>
					<li{if $current == 'acc/simple'} class="is-active"{/if}><a href="{$admin_uri}acc/accounts/simple.php">Suivi des écritures</a></li>
					<li{if $current == 'acc/years'} class="is-active"{/if}><a href="{$admin_uri}acc/years/">Exercices &amp; rapports</a></li>
				</ul>
			</li>
			{/if}
			{if $session->canAccess($session::SECTION_DOCUMENTS, $session::ACCESS_READ)
				|| $session->canAccess($session::SECTION_ACCOUNTING, $session::ACCESS_READ)
				|| $session->canAccess($session::SECTION_USERS, $session::ACCESS_READ)}
			<li class="cjd-shell__item{if $current == 'docs'} is-active{elseif $current_parent == 'docs'} is-parent{/if}">
				<a class="cjd-shell__link" href="{$admin_uri}docs/" accesskey="D">{icon shape="folder"}<span>Documents</span></a>
			</li>
			{/if}
			{if $session->canAccess($session::SECTION_WEB, $session::ACCESS_READ)}
			<li class="cjd-shell__item{if $current == 'web'} is-active{elseif $current_parent == 'web'} is-parent{/if}">
				<a class="cjd-shell__link" href="{$admin_uri}web/" accesskey="W">{icon shape="globe"}<span>Site web</span></a>
			</li>
			{/if}
			{if $session->canAccess($session::SECTION_CONFIG, $session::ACCESS_ADMIN)}
			<li class="cjd-shell__item{if $current == 'config'} is-active{elseif $current_parent == 'config'} is-parent{/if}">
				<a class="cjd-shell__link" href="{$admin_uri}config/">{icon shape="settings"}<span>Configuration</span></a>
			</li>
			{/if}
			{if $logged_user && $logged_user->exists()}
			<li class="cjd-shell__item has-sub{if $current == 'me'} is-active{elseif $current_parent == 'me'} is-parent{/if}">
				<a class="cjd-shell__link" href="{$admin_uri}me/">{icon shape="user"}<span>Mon compte</span></a>
				<ul class="cjd-shell__sub">
					<li{if $current == 'me/services'} class="is-active"{/if}><a href="{$admin_uri}me/services.php">Mes activités &amp; cotisations</a></li>
				</ul>
			</li>
			{/if}
			{if !defined('Paheko\LOCAL_LOGIN') || !LOCAL_LOGIN}
			<li class="cjd-shell__item">
				<a class="cjd-shell__link" href="{$admin_uri}logout.php">{icon shape="logout"}<span>Déconnexion</span></a>
			</li>
			{/if}
			{if $help_url}
			<li class="cjd-shell__item">
				<a class="cjd-shell__link" href="{$help_url}" target="_dialog" accesskey="?">{icon shape="help"}<span>Aide</span></a>
			</li>
			{/if}
		{elseif !defined('Paheko\SKIP_STARTUP_CHECK')}
			{if $config.org_web || !$config.site_disabled}
			<li class="cjd-shell__item"><a class="cjd-shell__link" href="{$site_url}">{icon shape="left"}<span>Retour au site</span></a></li>
			{/if}
			<li class="cjd-shell__item{if $current == 'login'} is-active{/if}">
				<a class="cjd-shell__link" href="{$admin_url}">{icon shape="login"}<span>Connexion</span></a>
			</li>
		{/if}
		</ul>
	</nav>
</header>
