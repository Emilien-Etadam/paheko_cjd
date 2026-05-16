{include file="_head.tpl" title="Supprimer un compte" current="acc/years"}


<div class="cjd-card">
{include file="common/delete_form.tpl"
	legend="Supprimer ce plan comptable ?"
	warning="Êtes-vous sûr de vouloir supprimer le compte « %s — %s » ?"|args:$account.code,$account.label
}

</div>

{include file="_foot.tpl"}