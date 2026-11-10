/******************************************************************
**
**  i01ad061.i Campo: tipo-movto (dem-i-lin)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Aplic/Empr
&glob val2 Resg/Pagtos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Aplic/Empl
&glob val2 Resg/Pagos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Appl/Loan
&glob val2 W/draw/Pymt
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

