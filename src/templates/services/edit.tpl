{include file="_head.tpl" title="Modifier une activité" current="users/services"}

<nav class="breadcrumbs">
	<ul>
		<li><a href="{$admin_uri}services/">Activités et cotisations</a></li>
		<li><a href="{$admin_uri}services/fees/?id={$service.id}">{$service.label|escape}</a></li>
		<li>Modifier l'activité</li>
	</ul>
</nav>

{include file="services/_nav.tpl" current="index"}

<div class="cjd-card cjd-services">

{include file="services/_service_form.tpl" legend="Modifier une activité"}

</div>

{include file="_foot.tpl"}