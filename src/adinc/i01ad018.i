/******************************************************************
**
** i01ad018.i  Campo: emis-extrato (banco) 
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Ficha Dep¢sito
&glob val2 Cheque
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Ficha Dep¢sito
&glob val2 Cheque
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Deposit Slip
&glob val2 Check
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
