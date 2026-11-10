/******************************************************************
**
** i01ad198.i - campo codigo-cgc (param-ap)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  C¢digo
&glob val2  CGC
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  C¢digo
&glob val2  NrCt
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Code
&glob val2  TxID
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

