/******************************************************************
**
** i20ad098.i  Campo: ind-dif-atrs-2
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 NÆo aceita
&glob val2 Ignora
&glob val3 Subtrai atraso + antigo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No Aprueba
&glob val2 Ignora
&glob val3 Substr Atraso + Antiguo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Not accept
&glob val2 Ignore
&glob val3 Subtract oldest delay
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

