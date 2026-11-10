/******************************************************************
**
** i03ad205.i Campo: bloqueio-cgc (param-global)
**
******************************************************************/
{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Distribu¡do
&glob val2 NÆo Distribu¡do
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Distribuido
&glob val2 No Distribuido
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Distributed
&glob val2 No Distributed
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

