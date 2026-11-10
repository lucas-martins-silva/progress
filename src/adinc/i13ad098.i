/******************************************************************
**
**  i13ad098.i Campo: ind-div-atraso (emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 NÆo Aceita
&glob val2 Ignora
&glob val3 Assume sit inf
&glob val4 Assume qtde inf
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No Acepta
&glob val2 Ignora
&glob val3 Asume sit inf
&glob val4 Asume ctd inf
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Not Accept
&glob val2 Ignore
&glob val3 Assume lower status
&glob val4 Assume lower qty
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

