/******************************************************************
**
**      i02ad171.i  - define o indicador origem
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Manual
&glob val2 Estoque
&glob val3 Multi-planta
&glob val4 Outros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Manual
&glob val2 Invent
&glob val3 Multiplanta
&glob val4 Otros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Manual
&glob val2 Inventory
&glob val3 Multi-Plant
&glob val4 Others
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

