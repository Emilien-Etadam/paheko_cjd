<?php
$layout ??= '';
$title ??= '';
$current ??= '';
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr" class="nojs{if $dialog} dialog{/if}" data-version="{$version_hash}" data-url="{$admin_url}"{if !empty($prefer_landscape)} data-prefer-landscape="1"{/if}>
<head>
	<meta charset="utf-8" />
	<meta name="v" content="{$version_hash}" />
	<title>{$title}</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="preconnect" href="https://fonts.googleapis.com" />
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
	<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,400;0,600;0,700;1,400&amp;family=Saira+Condensed:wght@600;700&amp;display=swap" />
	<link rel="stylesheet" type="text/css" href="{$admin_uri}static/dist/admin.css?{$version_hash}" media="all" />
	<script type="text/javascript" src="{$admin_uri}static/scripts/global.js?{$version_hash}"></script>
	<script type="text/javascript" src="{$admin_uri}static/scripts/cjd-nav.js?{$version_hash}" defer="defer"></script>
	{if isset($custom_js)}
		<?php $custom_js = (array)$custom_js; ?>
		{foreach from=$custom_js item="js_url"}
			<script type="text/javascript" src="{$js_url|local_url:"!static/scripts/"}?{$version_hash}"></script>
		{/foreach}
	{/if}
	{if isset($custom_css)}
		<?php $custom_css = (array)$custom_css; ?>
		{foreach from=$custom_css item="css_url"}
			<link rel="stylesheet" type="text/css" href="{$css_url|local_url:"!static/styles/"}?{$version_hash}" media="all" />
		{/foreach}
	{/if}
	{if isset($plugin_css)}
		{foreach from=$plugin_css item="css"}
			<link rel="stylesheet" type="text/css" href="{plugin_url file=$css}?{$version_hash}" />
		{/foreach}
	{/if}
	{if isset($plugin_js)}
		{foreach from=$plugin_js item="js"}
			<script type="text/javascript" src="{plugin_url file=$js}?{$version_hash}"></script>
		{/foreach}
	{/if}
	<link rel="stylesheet" type="text/css" href="{$admin_uri}static/dist/print.css?{$version_hash}" media="print" />
	{if isset($logged_user) && $logged_user.preferences.force_handheld}
		<link rel="stylesheet" type="text/css" href="{$admin_uri}static/dist/handheld.css?{$version_hash}" media="handheld,screen" />
	{else}
		<link rel="stylesheet" type="text/css" href="{$admin_uri}static/dist/handheld.css?{$version_hash}" media="handheld,screen and (max-width:981px)" />
	{/if}
	<link rel="manifest" href="{$admin_uri}manifest.php" />
	{if isset($config)}
		<link rel="icon" type="image/png" href="{$config->fileURL('favicon')}" />
		<link rel="apple-touch-icon" href="{$config->fileURL('icon')}" />
	{/if}
	{if ADMIN_CUSTOM_CSS}
	<link rel="stylesheet" type="text/css" href="<?=ADMIN_CUSTOM_CSS?>" media="handheld,screen" />
	{/if}
</head>

<?php
$class = $layout;

if (ALERT_MESSAGE && !$dialog) {
	$class .= ' sticky';
}
?>

<body{if !empty($class)} class="{$class}"{/if}{if !empty($upload_here)}{enable_upload_here path=$upload_here}{elseif !empty($upload_here_url)}{enable_upload_here url=$upload_here_url}{/if}>

{if ALERT_MESSAGE && !$dialog}
	<div id="sticky-alert"><?=ALERT_MESSAGE?></div>
{/if}

{if !array_key_exists('_dialog', $_GET) && $layout !== 'public' && $layout !== 'raw'}
<nav id="skip">
	<a href="#content">Aller au contenu</a>
</nav>

{include file="_shell.tpl"}

{elseif $layout === 'public'}
<header class="public">
	<h1><a href="{$site_url}">{if $config.files.logo}<img src="{$config->fileURL('logo', '150px')}" alt="{$config.org_name}" />{else}{$config.org_name}{/if}</a></h1>
</header>
{/if}

<main id="content">
	{if empty($hide_title) && !$dialog}
	<h1 class="main">{$title}</h1>
	{/if}
