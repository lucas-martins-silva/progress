/******************************************************************
**
** i04ad397.i  Campo:param-inadimp.idi-tip-juros
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Simples
&glob val2 Composto
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Simple
&glob val2 Compuesto
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Simple
&glob val2 Composed
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */


