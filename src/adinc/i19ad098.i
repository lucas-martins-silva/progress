/******************************************************************
**
** i19ad098.i  Campo: ind-dif-atrs-1
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 NÆo aceita
&glob val2 Ignora
&glob val3 Adiciona atraso + recente
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No Aprueba
&glob val2 Ignora
&glob val3 Adic Atraso + Reciente
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Not accept
&glob val2 Ignore
&glob val3 Add most recent delay
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

