/******************************************************************
**
**  adinc/i03ad298.i - codigos-retenc.gera-imposto.
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Implanta‡Æo
&glob val2 Pagamento
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Implantaci¢n
&glob val2 Pagamento
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Addition
&glob val2 Payment
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

