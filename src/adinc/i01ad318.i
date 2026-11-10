/******************************************************************
**
** i01ad318.i  Campo: Situa‡Æo Movimento Recibo.
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Sim
&glob val2 NÆo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 S¡
&glob val2 No
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Yes
&glob val2 No 
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

