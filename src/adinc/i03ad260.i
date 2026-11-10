/******************************************************************
**
**  i03ad260.i Campo: tipo-mercad (tit-ap)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Capital
&glob val2 NÆo Capital
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Capital
&glob val2 No Capital
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Capital
&glob val2 Not Capital
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

