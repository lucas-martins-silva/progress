/******************************************************************
**
** i02ad025.i Campo: estado (bord-rec)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Prepara‡Æo
&glob val2 Confirmado
&glob val3 Impresso
&glob val4 Reemitido
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Preparaci¢n
&glob val2 Confirmado
&glob val3 Impreso
&glob val4 Reemitido
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Preparation
&glob val2 Confirmed
&glob val3 Printed
&glob val4 Reprint
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

