/******************************************************************
**
**  i02ad264.i Campo: enviado (titulo)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Enviado a Banco
&glob val2 Auto-Emiss∆o
&glob val3 Nao Enviado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Enviado a Banco
&glob val2 Autoemisi¢n
&glob val3 No Enviado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Sent to Bank
&glob val2 Auto-Printing
&glob val3 Not Sent
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

