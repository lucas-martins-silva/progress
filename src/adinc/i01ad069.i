/******************************************************************
**
** i01ad069.i  Campo: tp-linha (demon-lin)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 T¡tulo
&glob val2 Branca
&glob val3 Valor
&glob val4 Total
&glob val5 Digitada
&glob val6 Salto P gina
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 T¡tulo
&glob val2 Blanca
&glob val3 Valor
&glob val4 Total
&glob val5 Digitada
&glob val6 Salto P gina
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Document
&glob val2 White
&glob val3 Value
&glob val4 Total
&glob val5 Keyed
&glob val6 Page Break
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

