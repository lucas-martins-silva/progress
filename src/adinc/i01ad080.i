/******************************************************************
**
** i01ad080.i campo impressao (originado no arquivo det-dem-vid)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Conta
&glob val2 T¡tulo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Cuenta
&glob val2 T¡tulo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Account
&glob val2 Heading
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

