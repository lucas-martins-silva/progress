/******************************************************************
**
** i01ad346.i  Campo: tp-contrato-exp (contrato-exp)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Pronto
&glob val2 Antecipa‡Æo
&glob val3 Empr‚stimo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Pronto
&glob val2 Anticipo
&glob val3 Pr‚stamo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Ready
&glob val2 Adv Payment
&glob val3 Loan
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
