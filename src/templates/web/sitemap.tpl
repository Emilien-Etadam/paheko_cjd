{include file="_head.tpl" title="Plan du site" current="web"}


<div class="cjd-web">
<nav class="tabs">
	{linkbutton shape="left" href="./" label="Retour à la gestion du site"}
</nav>

<div class="web-sitemap">
	{$list|display_sitemap|raw}
</div>

{include file="_foot.tpl"}