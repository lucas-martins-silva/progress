/******************************************************************
**
** i02ad011.i Campo: car-obr-opc(apl-empr-banco)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Obrigat¢ria
&glob val2 NÆo Obrigat¢ria
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Obligatoria
&glob val2 No Obligatoria
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Mandatory
&glob val2 Not Mandatory
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

