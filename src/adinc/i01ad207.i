/******************************************************************
**
** i01ad066.i - campo situacao(originado do arquivo parc-operacao)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Cota‡Æo
&glob val2 Fechamento
&glob val3 Quitado
&glob val4 Inadimplente
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Cotizac
&glob val2 Cierre
&glob val3 Pagado
&glob val4 Deudor
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Quotation
&glob val2 Closing
&glob val3 Paid
&glob val4 Delinquent
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

