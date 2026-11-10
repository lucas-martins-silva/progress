/******************************************************************
**
** i01ad047.i campo natureza (conta) - Devedora/Credora
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Devedora
&glob val2 Credora
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Deudora
&glob val2 Acreedora
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Debit
&glob val2 Credit
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

