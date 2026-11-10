/******************************************************************
**
** adinc/i01ad092.i  Campo: doc-b-cr.ind-sit-lote-liquidacao-cr.
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Normal
&glob val2 Recibo
&IF DEFINED(BF_FIN_ENCCONTAS) &THEN
    &glob val3 Encontro de Contas
&ENDIF
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Normal
&glob val2 Recibo
&IF DEFINED(BF_FIN_ENCCONTAS) &THEN
    &glob val3 Encuentro de Cuentas
&ENDIF
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Normal
&glob val2 Rcpt
&IF DEFINED(BF_FIN_ENCCONTAS) &THEN
    &glob val3 Account Meeting
&ENDIF
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

