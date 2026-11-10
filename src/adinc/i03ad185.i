/******************************************************************
**
** i03ad185.i - campo movimento.tp-contab (Tipo de Contabiliza‡Æo)              
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&global val1 Resumido por Dia
&global val2 Resumido por Per¡odo
&global val3 Aberto
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&global val1 Sintetizado por D¡a
&global val2 Sintetizado por Per¡odo
&global val3 Abierto
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&global val1 Summarized by Day
&global val2 Summarized by Period
&global val3 Open
&ENDIF

{include/ind01-10.i {1} {2}}

/* Fim */
