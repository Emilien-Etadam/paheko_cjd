{include file="_head.tpl" title="%s — Modifier le tarif"|args:$fee.label current="users/services"}

<nav class="breadcrumbs">
	<ul>
		<li><a href="{$admin_uri}services/">Activités et cotisations</a></li>
		<li><a href="{$admin_uri}services/fees/?id={$service.id}">{$service.label|escape}</a></li>
		<li>{$fee.label|escape}</li>
	</ul>
</nav>

{include file="services/_nav.tpl" current="index" current_service=$service service_page="index"}

<div class="cjd-card cjd-services">

{include file="services/fees/_fee_form.tpl" legend="Modifier un tarif" submit_label="Enregistrer"}

</div>

{include file="_foot.tpl"}