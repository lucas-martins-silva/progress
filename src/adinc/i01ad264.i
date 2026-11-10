/******************************************************************
**
**      i01ad264.i  - define o indicador origem
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Manual
&glob val2 Faturamento
&glob val3 Multi-planta
&glob val4 Outros
&glob val5 Devolu‡Æo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Manual
&glob val2 Invent
&glob val3 Multiplanta
&glob val4 Otros
&glob val5 Devoluci¢n
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Manual
&glob val2 Inventory
&glob val3 Multi-Plant
&glob val4 Others
&glob val5 Return
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

