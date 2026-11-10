/******************************************************************
**
** i01ad170.i  Campo: mo-vl-titulo (lin-i-ap)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Padr∆o
&glob val2 Outra Moeda
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Estandar
&glob val2 Otra Moneda
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Standard
&glob val2 Another Cu
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

