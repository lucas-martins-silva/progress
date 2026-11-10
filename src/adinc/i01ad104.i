/******************************************************************
**
** i01ad104.i - campo tipo (originado do arquivo espec-ap)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&global val1 Normal
&global val2 Antecipaá∆o
&global val3 Previs∆o
&global val4 Nota de DÇbito
&global val5 Nota de CrÇdito
&global val6 Juros
&global val7 Ordem de Pagamento
&global val8 Retená∆o
&global val9 Nota Promiss¢ria
&IF DEFINED(BF_FIN_PROVISAO) &THEN
    &global val10 Provis∆o
&ELSE
    &IF DEFINED(BF_FIN_PROVISAO203) &THEN 
        if can-find(first funcao where 
                          funcao.cd-funcao = "spp-provisao" and
                          funcao.ativo     = yes) then
           &global val10 Provis∆o
    &ENDIF
&ENDIF
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&global val1 Normal
&global val2 Anticipo
&global val3 Previsi¢n
&global val4 Nota de Debito
&global val5 Nota de Credito
&global val6 Interes
&global val7 Orden de Pago
&global val8 Retenci¢n
&global val9 Pagare
&IF DEFINED(BF_FIN_PROVISAO) &THEN
    &global val10 Provisi¢n
&ELSE
    &IF DEFINED(BF_FIN_PROVISAO203) &THEN 
        if can-find(first funcao where 
                          funcao.cd-funcao = "spp-provisao" and
                          funcao.ativo     = yes) then
           &global val10 Provisi¢n
    &ENDIF
&ENDIF
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&global val1 Normal
&global val2 Advance Pymt
&global val3 Forecast
&global val4 Debit Note
&global val5 Credit Note
&global val6 Intrst
&global val7 Payment Order
&global val8 Retention
&global val9 Promissory Note
&IF DEFINED(BF_FIN_PROVISAO) &THEN
    &global val10 Provision
&ELSE
    &IF DEFINED(BF_FIN_PROVISAO203) &THEN 
        if can-find(first funcao where 
                          funcao.cd-funcao = "spp-provisao" and
                          funcao.ativo     = yes) then
           &global val10 Provision
    &ENDIF
&ENDIF
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
