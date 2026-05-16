{include file="_head.tpl" title="Modifier une inscription" current="users/services"}

<nav class="breadcrumbs">
	<ul>
		<li><a href="{$admin_uri}users/">Membres</a></li>
		{foreach from=$users key="id" item="name"}
		<li><a href="{$admin_uri}users/details.php?id={$id}">{$name|escape}</a></li>
		{/foreach}
		<li><a href="{$admin_uri}services/user/?id={$service_user.id_user}">Inscriptions aux activités</a></li>
		<li>Modifier une inscription</li>
	</ul>
</nav>

<div class="cjd-card cjd-services">
{form_errors}

{include file="services/user/_service_user_form.tpl" create=false}

</div>

{include file="_foot.tpl"}