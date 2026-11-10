/******************************************************************
**
** i03ad411.i  Campo:renegoc-inadimp.idi-tip-avdeb
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 AD énica
&glob val2 AD Por Parcela
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 AD énica
&glob val2 AD Por Cuota
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Single AD
&glob val2 AD By Installment
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */

