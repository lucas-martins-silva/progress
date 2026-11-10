/******************************************************************
**
** i01ad189.i - campo tipo (originado do arquivo movto-ext-aplic)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  Aplica‡Æo
&glob val2  Resgate
&glob val3  Corre‡Æo
&glob val4  Empr‚stimo
&glob val5  Pagto
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  Aplicaci¢n
&glob val2  Rescate
&glob val3  Correcci¢n
&glob val4  Pr‚stamo
&glob val5  Pago
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Application
&glob val2  Withdraw
&glob val3  Correction
&glob val4  Loan
&glob val5  Pymt
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

