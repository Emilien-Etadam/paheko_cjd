{include file="_head.tpl" title="Supprimer %d fichiers"|args:$count current="docs"}


<div class="cjd-card cjd-docs">
{include file="common/delete_form.tpl"
	legend="Supprimer ces fichiers ?"
	warning="Êtes-vous sûr de vouloir mettre %d fichiers à la corbeille ?"|args:$count
	csrf_key=$csrf_key
	extra=$extra
}

</div>

{include file="_foot.tpl"}