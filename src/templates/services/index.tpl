{include file="_head.tpl" title="Activités et cotisations" current="users/services"}

{include file="services/_nav.tpl" current="index" service=null fee=null}

<div class="cjd-card cjd-services">

{if isset($_GET['CREATE'])}
	<p class="block error">Vous devez déjà créer une activité pour pouvoir utiliser cette fonction.</p>
{/if}

{if $list->count()}
	{include file="common/dynamic_list_head.tpl"}
			{foreach from=$list->iterate() item="row"}
				<tr>
					<th scope="row"><a href="fees/?id={$row.id}">{$row.label}</a></th>
					<td>{$row.date}</td>
					<td class="num"><a href="details.php?id={$row.id}&amp;type=active">{$row.nb_users_ok}</a></td>
					<td class="num"><a href="details.php?id={$row.id}&amp;type=expired">{$row.nb_users_expired}</a></td>
					<td class="num"><a href="details.php?id={$row.id}&amp;type=unpaid">{$row.nb_users_unpaid}</a></td>
					<td class="actions">
						{linkbutton shape="menu" label="Tarifs" href="!services/fees/?id=%d"|args:$row.id}
						{linkbutton shape="users" label="Liste des inscrits" href="!services/details.php?id=%d"|args:$row.id}
						{if $session->canAccess($session::SECTION_USERS, $session::ACCESS_ADMIN)}
							{linkbutton shape="edit" label="Modifier" href="!services/edit.php?id=%d"|args:$row.id}
							{linkbutton shape="delete" label="Supprimer" href="!services/delete.php?id=%d"|args:$row.id}
						{/if}
					</td>
				</tr>
			{/foreach}
		</tbody>
	</table>

	{$list->getHTMLPagination()|raw}
{else}
	<div class="empty-state" data-icon="𝍢">
		<strong>Aucune activité</strong>
		<p>Commencez par ajouter votre première activité ou cotisation.</p>
		{if $session->canAccess($session::SECTION_USERS, $session::ACCESS_ADMIN)}
			{linkbutton href="#add-activity" label="Ajouter une activité" shape="plus" class="main"}
		{/if}
	</div>
{/if}

{if empty($show_archived_services) && $session->canAccess($session::SECTION_USERS, $session::ACCESS_ADMIN)}
	<div id="add-activity">
		{include file="services/_service_form.tpl" legend="Ajouter une activité" service=null period=0}
	</div>
{/if}

</div>

{include file="_foot.tpl"}