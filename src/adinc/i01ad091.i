/******************************************************************
**
** adinc/i01ad091.i  Campo: doc-b-ap.ind-sit-lote-liquidacao-ap
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Baixa Normal
&glob val2 Baixa Cheque Outros
&glob val3 Pagto Extra Fornecedor
&glob val4 Substitui‡Æo
&glob val5 Faturas
&glob val6 Nota Promiss¢ria
&IF DEFINED(BF_FIN_ENCCONTAS) &THEN
    &glob val7 Encontro de Contas
&ENDIF
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Baja Normal 
&glob val2 Baja Cheque Otros 
&glob val3 Pagamento Extra Proveedor 
&glob val4 Substituci¢n
&glob val5 Facturas
&glob val6 Pagar‚
&IF DEFINED(BF_FIN_ENCCONTAS) &THEN
    &glob val7 Encuentro de Cuentas
&ENDIF
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Normal Retirement
&glob val2 Other Check Payment 
&glob val3 Vendor Extra Payment
&glob val4 Replacement
&glob val5 Invoices
&glob val6 Promissory Note
&IF DEFINED(BF_FIN_ENCCONTAS) &THEN
    &glob val7 Account Meeting
&ENDIF
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

