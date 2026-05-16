{include file="_head.tpl" title="Modification d'une écriture" current="acc/simple"}

<nav class="breadcrumbs">
	<ul>
		<li><a href="{$admin_uri}acc/">Comptabilité</a></li>
		<li><a href="{$admin_uri}acc/transactions/details.php?id={$transaction.id}">Écriture n°{$transaction.id}</a></li>
		<li>Modifier</li>
	</ul>
</nav>

<div class="cjd-card cjd-acc-journal">
{include file="./_form.tpl"}
</div>


{include file="_foot.tpl"}