/******************************************************************
**
**  i11ad098.i Campo: ind-dif-atrs-1 (emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 NÆo aceita
&glob val2 Ignora
&glob val3 Adiciona no Atraso + Recenete
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No Aprueba
&glob val2 Ignora
&glob val3 Adiciona en Atraso + Reciente
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Not accept
&glob val2 Ignore
&glob val3 Adds to most Recent Delay
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

