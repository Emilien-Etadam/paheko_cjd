<nav class="tabs">
	<ul>
		<li{if $current == 'me'} class="current"{/if}><a href="{$admin_url}me/" {if $current == 'me'}aria-current="page"{/if}>Mes informations personnelles</a></li>
		{if $logged_user.password}
		<li{if $current == 'security'} class="current"{/if}><a href="{$admin_url}me/security.php" {if $current == 'security'}aria-current="page"{/if}>Mot de passe et options de sécurité</a></li>
		{/if}
		<li{if $current == 'preferences'} class="current"{/if}><a href="{$admin_url}me/preferences.php" {if $current == 'preferences'}aria-current="page"{/if}>Préférences</a></li>
	</ul>
</nav>