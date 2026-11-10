/******************************************************************
**
** i01ad226.i  Campo: selecao (rel-proc)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Total
&glob val2 Parcial
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Total
&glob val2 Parcial
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Total
&glob val2 Partial
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

