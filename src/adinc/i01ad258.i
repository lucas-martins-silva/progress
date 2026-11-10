/******************************************************************
**
** i01ad258.i Campo: transacao (tipo-modalidade)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Aplica‡Æo
&glob val2 Empr‚stimo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Aplicaci¢n
&glob val2 Pr‚stamo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Application
&glob val2 Loan
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

