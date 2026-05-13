{* [CJD Section] Refonte couche 2 — 2026 — pied de page texte (pattern 5 couleurs : body::after côté web uniquement) *}
{if !isset($cjd_section_name)}{assign var=cjd_section_name value="CJD Section"}{/if}
{if !isset($cjd_section_rna)}{assign var=cjd_section_rna value=""}{/if}
{if !isset($cjd_section_president)}{assign var=cjd_section_president value=""}{/if}

— {$cjd_section_name}
{if $cjd_section_president} — Président·e : {$cjd_section_president}{/if}
{if $cjd_section_rna} — RNA {$cjd_section_rna}{/if}
— Mouvement CJD · Mettre l'économie au service de l'Homme

Vert #00D556 | Bleu #1882E3 | Cyan #00CAC8 | Orange #FF5220 | Jaune #FFC800

