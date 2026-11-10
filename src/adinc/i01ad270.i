/******************************************************************
**
** i01ad270.i  Campo: estado (ano-fiscal)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 NÆo Dispon¡vel
&glob val2 Aberto
&glob val3 Congelado
&glob val4 Fechado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No Disponible
&glob val2 Abierto
&glob val3 Congelado
&glob val4 Cerrado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Not Available
&glob val2 Open
&glob val3 Frozen
&glob val4 Closed
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

