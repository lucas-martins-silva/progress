/******************************************************************
**
** i21ad098.i  Campo: ind-div-atraso
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 NÆo aceita
&glob val2 Ignora
&glob val3 Assume situa‡Æo inferior
&glob val4 Assume quantidade inferior
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No Aprueba
&glob val2 Ignora
&glob val3 Asume situaci¢n inferior
&glob val4 Asume cantidad inferior
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Not accept
&glob val2 Ignore
&glob val3 Assume lower status
&glob val4 Assume lower quantity
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

