{if !$dialog}
<nav class="tabs">
	<ul>
		<li><a href="{$admin_url}acc/years/">Exercices</a></li>
		<li class="current"><a href="{$admin_url}acc/projects/" aria-current="page">Projets <em>(compta analytique)</em></a></li>
		<li><a href="{$admin_url}acc/charts/">Plans comptables</a></li>
	</ul>

	<aside>
	{if $current == 'index'}
		{exportmenu class="menu-btn-right" suffix="_export="}
	{/if}
	{if $session->canAccess($session::SECTION_ACCOUNTING, $session::ACCESS_ADMIN)}
		{linkbutton label="Créer un nouveau projet" href="edit.php" shape="plus" target="_dialog"}
	{/if}
	</aside>

	{if $session->canAccess($session::SECTION_ACCOUNTING, $session::ACCESS_ADMIN)}
	<ul class="sub">
		<li{if $current != 'config'} class="current"{/if}>{if $current != 'config'}{link href="!acc/projects/" label="Liste des projets" aria-current="page"}{else}{link href="!acc/projects/" label="Liste des projets"}{/if}</li>
		<li{if $current == 'config'} class="current"{/if}>{if $current == 'config'}{link href="!acc/projects/config.php" label="Configuration" aria-current="page"}{else}{link href="!acc/projects/config.php" label="Configuration"}{/if}</li>
	</ul>
	{/if}
</nav>
{/if}
