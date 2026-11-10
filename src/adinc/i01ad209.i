/******************************************************************
**
**      i01ad209.i  - define o indicador emissao da ocorrencia
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Carta
&glob val2 Modem
&glob val3 Telex
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Carta
&glob val2 Modem
&glob val3 Telex
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Letter
&glob val2 Modem
&glob val3 Telex
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

