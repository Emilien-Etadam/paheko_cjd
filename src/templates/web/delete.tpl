{include file="_head.tpl" title=$title current="web"}


<div class="cjd-web">
{include file="common/delete_form.tpl"
	legend=$title
	warning="Êtes-vous sûr de vouloir supprimer « %s » ?"|args:$page.title
	alert=$alert
}

</div>

{include file="_foot.tpl"}