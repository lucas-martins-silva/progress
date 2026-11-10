/******************************************************************
**
** i01ad329.i Campo: tp-lancamento (tipo_docto_banco)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 D‚bito
&glob val2 Cr‚dito
&glob val3 Ambos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 D‚bito
&glob val2 Cr‚dito
&glob val3 Ambos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Debit
&glob val2 Credit
&glob val3 Both
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
