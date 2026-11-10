/******************************************************************
**
** i24ad098.i  Campo: ind-abrange-aval
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Cliente
&glob val2 Matriz
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Cliente
&glob val2 Matriz
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Customer
&glob val2 Holding
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

