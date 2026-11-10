/******************************************************************
**
** i01ad321.i  Campos: integr-ncr-app / integr-ncr-crp(Estabelec)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Credita/Antecipa
&glob val2 Credita
&glob val3 Antecipa
&glob val4 Cancela
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Credita/Anticipa
&glob val2 Credita
&glob val3 Anticipa
&glob val4 Cancela
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Credit/Advance
&glob val2 Credit
&glob val3 Advance
&glob val4 Cancel
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

