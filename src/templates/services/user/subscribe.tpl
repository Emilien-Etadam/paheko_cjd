{include file="_head.tpl" title="Inscrire à une activité" current="users/services"}

{if !$dialog}
{include file="services/_nav.tpl" current="save" fee=null service=null}

<div class="cjd-card cjd-services">
{/if}

{form_errors}

{include file="services/user/_service_user_form.tpl" create=true}

</div>

{include file="_foot.tpl"}