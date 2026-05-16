<nav class="tabs">
	{if $current == 'index' && $session->canAccess($session::SECTION_USERS, $session::ACCESS_ADMIN)}
	<aside>
		{exportmenu right=true}
	</aside>
	{/if}

	<ul>
		<li{if $current == 'index'} class="current"{/if}><a href="./" {if $current == 'index'}aria-current="page"{/if}>Liste des membres</a></li>
		<li{if $current == 'search'} class="current"{/if}><a href="search.php"{if $current == 'search'} aria-current="page"{/if}>Recherche avancée</a></li>
		<li{if $current == 'saved_searches'} class="current"{/if}><a href="saved_searches.php"{if $current == 'saved_searches'} aria-current="page"{/if}>Recherches enregistrées</a></li>
		{if $session->canAccess($session::SECTION_USERS, $session::ACCESS_ADMIN)}
			<li{if $current == 'import'} class="current"{/if}><a href="import.php"{if $current == 'import'} aria-current="page"{/if}>Import</a></li>
		{/if}
	</ul>
</nav>