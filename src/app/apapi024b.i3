/*****************************************************************************
***
*** app/apapi024b.i3 - pi-cancela-impostos.
*** 
*****************************************************************************/

for each tt-epc where tt-epc.cod-event = "elimina-retencao".
    delete tt-epc.
end.

/* --- Elimina Impostos PIS/COFINS/CSLL --- */
for each  b-tit-ap exclusive-lock
    where b-tit-ap.ep-codigo   = mov-ap.ep-codigo
    and   b-tit-ap.cod-fornec  = mov-ap.cod-fornec
    and   b-tit-ap.cod-estabel = mov-ap.cod-estabel
    and   b-tit-ap.esp-ant     = mov-ap.cod-esp
    and   b-tit-ap.serie-ant   = mov-ap.serie
    and   b-tit-ap.docto-ant   = mov-ap.nr-docto
    and   b-tit-ap.parc-ant    = mov-ap.parcela
    and   b-tit-ap.referencia  = mov-ap.referencia
    and   b-tit-ap.tipo        = 1:               

    find first tipo-tax 
         where tipo-tax.cod-tax = b-tit-ap.cod-impto-ret no-lock no-error.
    if not avail tipo-tax
    or (avail tipo-tax and
        &if '{&mgadm_version}' >= '2.06' &then
            not tipo-tax.retenc-pis-cofins 
        &else
            not tipo-tax.log-1
        &endif
        )
    then
        next. 

    if not can-find(first imposto-pagto no-lock
        where imposto-pagto.ep-codigo   = mov-ap.ep-codigo  
          and imposto-pagto.cod-fornec  = mov-ap.cod-fornec 
          and imposto-pagto.cod-estabel = mov-ap.cod-estabel
          and imposto-pagto.cod-esp     = mov-ap.cod-esp    
          and imposto-pagto.serie       = mov-ap.serie      
          and imposto-pagto.nr-docto    = mov-ap.nr-docto   
          and imposto-pagto.parcela     = mov-ap.parcela    
          and imposto-pagto.cod-imposto = tipo-tax.cod-tax) 
    then
        next.
    if i-pais-impto-usuario = 1 then do:
        /* --- Atualiza tabela de Acumulado e Relacionamento --- */
        for each  imposto-pagto exclusive-lock
            where imposto-pagto.ep-codigo   = mov-ap.ep-codigo   
              and imposto-pagto.cod-fornec  = mov-ap.cod-fornec 
              and imposto-pagto.cod-estabel = mov-ap.cod-estabel
              and imposto-pagto.cod-esp     = mov-ap.cod-esp    
              and imposto-pagto.serie       = mov-ap.serie      
              and imposto-pagto.nr-docto    = mov-ap.nr-docto 
              and imposto-pagto.parcela     = mov-ap.parcela
              and imposto-pagto.cod-imposto = tipo-tax.cod-tax:
              
                  find first tt-transacao-ava exclusive-lock
                       where tt-transacao-ava.ep-codigo   = imposto-pagto.ep-codigo  
                         and tt-transacao-ava.cod-fornec  = imposto-pagto.cod-fornec 
                         and tt-transacao-ava.cod-estabel = imposto-pagto.cod-estabel
                         and tt-transacao-ava.cod-esp     = imposto-pagto.cod-esp    
                         and tt-transacao-ava.serie       = imposto-pagto.serie      
                         and tt-transacao-ava.nr-docto    = imposto-pagto.nr-docto   
                         and tt-transacao-ava.parcela     = imposto-pagto.parcela    
                         and tt-transacao-ava.valor-mov   = b-tit-ap.vl-original no-error.
                             
                  if not avail tt-transacao-ava then do:
                      create tt-transacao-ava.
                      assign tt-transacao-ava.ep-codigo   = imposto-pagto.ep-codigo  
                             tt-transacao-ava.cod-fornec  = imposto-pagto.cod-fornec 
                             tt-transacao-ava.cod-estabel = imposto-pagto.cod-estabel
                             tt-transacao-ava.cod-esp     = imposto-pagto.cod-esp    
                             tt-transacao-ava.serie       = imposto-pagto.serie      
                             tt-transacao-ava.nr-docto    = imposto-pagto.nr-docto   
                             tt-transacao-ava.parcela     = imposto-pagto.parcela     
                             tt-transacao-ava.valor-mov   = b-tit-ap.vl-original.
                  end.
            
            if  l-func-matriz-impto then
                find first acum-imposto-pagto 
                     where acum-imposto-pagto.ep-codigo   = imposto-pagto.ep-codigo
                     and   acum-imposto-pagto.cod-estabel = ""
                     and   acum-imposto-pagto.cod-fornec  = &if "{&mgadm_version}" >= "2.07" &then
                                                                imposto-pagto.cdn-fornec-matriz 
                                                            &else                                 
                                                                imposto-pagto.num-livre-1       
                                                            &endif
                     and   acum-imposto-pagto.dat-refer   = date(month(mov-ap.dt-transacao),01,year(mov-ap.dt-transacao))
                     and   acum-imposto-pagto.cod-imposto = imposto-pagto.cod-imposto exclusive-lock no-error.
            else 
                find first acum-imposto-pagto 
                     where acum-imposto-pagto.ep-codigo   = imposto-pagto.ep-codigo
                     and   acum-imposto-pagto.cod-estabel = ""
                     and   acum-imposto-pagto.cod-fornec  = imposto-pagto.cod-fornec
                     and   acum-imposto-pagto.dat-refer   = date(month(mov-ap.dt-transacao),01,year(mov-ap.dt-transacao))
                     and   acum-imposto-pagto.cod-imposto = imposto-pagto.cod-imposto exclusive-lock no-error.
            if  avail  acum-imposto-pagto then do:
                assign acum-imposto-pagto.val-rendto-tribut           = acum-imposto-pagto.val-rendto-tribut           - imposto-pagto.vl-base
                       acum-imposto-pagto.val-acum-impto-retid-period = acum-imposto-pagto.val-acum-impto-retid-period - imposto-pagto.vl-imposto.
                if  acum-imposto-pagto.val-rendto-tribut           = 0
                and acum-imposto-pagto.val-acum-impto-retid-period = 0 then
                    delete acum-imposto-pagto.
            end.
            delete imposto-pagto.
        end.
    end.

    assign da-data  = (if  b-tit-ap.dt-prev-pag <> ? 
                       then b-tit-ap.dt-prev-pag
                       else b-tit-ap.dt-vencimen)
           da-fluxo = b-tit-ap.dt-fluxo.

    for each  emite-ap use-index codigo
        where emite-ap.ep-codigo   = b-tit-ap.ep-codigo
        and   emite-ap.cod-fornec  = b-tit-ap.cod-fornec
        and   emite-ap.cod-estabel = b-tit-ap.cod-estabel
        and   emite-ap.cod-esp     = b-tit-ap.cod-esp
        and   emite-ap.serie       = b-tit-ap.serie
        and   emite-ap.nr-docto    = b-tit-ap.nr-docto
        and   emite-ap.parcela     = b-tit-ap.parcela exclusive-lock:
        delete emite-ap. 
    end.

    {app/ap9100.i2}
    assign tt-integ-ap.tt-row-tit-ap  = rowid(b-tit-ap)
           tt-integ-ap.tt-cb0110a     = yes
           tt-integ-ap.tt-op-cb0110a  = 6. /*Elimina*/
    raw-transfer tt-integ-ap to raw-integracao.
    run app/ap9100.p (input raw-integracao, input-output table tt-erro).

    for each  b-mov-ap-imp use-index codigo
        where b-mov-ap-imp.ep-codigo   = b-tit-ap.ep-codigo
        and   b-mov-ap-imp.cod-fornec  = b-tit-ap.cod-fornec
        and   b-mov-ap-imp.cod-estabel = b-tit-ap.cod-estabel
        and   b-mov-ap-imp.cod-esp     = b-tit-ap.cod-esp
        and   b-mov-ap-imp.serie       = b-tit-ap.serie
        and   b-mov-ap-imp.nr-docto    = b-tit-ap.nr-docto
        and   b-mov-ap-imp.parcela     = b-tit-ap.parcela no-lock:

        {app/ap9100.i2}
        assign tt-integ-ap.tt-row-tit-ap  = rowid(b-tit-ap)
               tt-integ-ap.tt-row-mov-ap  = rowid(b-mov-ap-imp)
               tt-integ-ap.tt-cb0110a     = yes
               tt-integ-ap.tt-op-cb0110a  = 22.
        raw-transfer tt-integ-ap to raw-integracao.
        run app/ap9100.p (input raw-integracao, input-output table tt-erro).

        if  mov-ap.transacao = 2 then do:
            {app/ap9100.i2}
            assign tt-integ-ap.tt-row-tit-ap  = rowid(b-tit-ap)
                   tt-integ-ap.tt-row-mov-ap  = rowid(b-mov-ap-imp)
                   tt-integ-ap.tt-ge0102b     = yes
                   tt-integ-ap.tt-op-ge0102b  = 7. /*Elimina Baixa*/
            raw-transfer tt-integ-ap to raw-integracao.
            run app/ap9100.p (input raw-integracao, input-output table tt-erro).
        end.

        find first che-emit
             where che-emit.ep-codigo   = b-mov-ap-imp.ep-codigo
             and   che-emit.portador    = b-mov-ap-imp.portador
             and   che-emit.nr-cheque   = b-mov-ap-imp.nr-cheque
             and   che-emit.cod-fornec  = b-mov-ap-imp.cod-fornec
             and   che-emit.cod-estabel = b-mov-ap-imp.cod-estabel
             and   che-emit.cod-esp     = b-mov-ap-imp.cod-esp
             and   che-emit.serie       = b-mov-ap-imp.serie
             and   che-emit.nr-docto    = b-mov-ap-imp.nr-docto
             and   che-emit.parcela     = b-mov-ap-imp.parcela
             and   che-emit.dt-emissao  = b-mov-ap-imp.dt-transacao exclusive-lock no-error.
        if  avail che-emit then do:
            assign che-emit.cancelado = yes.
        end.

        for each  tit-conta-ap
            where tit-conta-ap.ep-codigo   = b-mov-ap-imp.ep-codigo
            and   tit-conta-ap.cod-estabel = b-mov-ap-imp.cod-estabel
            and   tit-conta-ap.cod-esp     = b-mov-ap-imp.cod-esp
            and   tit-conta-ap.serie       = b-mov-ap-imp.serie
            and   tit-conta-ap.nr-docto    = b-mov-ap-imp.nr-docto
            and   tit-conta-ap.parcela     = b-mov-ap-imp.parcela
            and   tit-conta-ap.cod-fornec  = b-mov-ap-imp.cod-fornec exclusive-lock:
            delete tit-conta-ap.  
        end.

        find b-mov-ap where rowid(b-mov-ap) = rowid(b-mov-ap-imp) exclusive-lock no-error.

        if  b-mov-ap-imp.transacao = 2 then do:
            {app/ap9100.i2}
            assign tt-integ-ap.tt-row-tit-ap  = rowid(b-tit-ap)
                   tt-integ-ap.tt-row-mov-ap  = rowid(b-mov-ap-imp)
                   tt-integ-ap.tt-ge0102b     = yes
                   tt-integ-ap.tt-ge0102g     = yes
                   tt-integ-ap.tt-cb0201a     = yes
                   tt-integ-ap.tt-op-ge0102b  = 6
                   tt-integ-ap.tt-op-ge0102g  = 6
                   tt-integ-ap.tt-op-cb0201a  = 6.
            raw-transfer tt-integ-ap to raw-integracao.
            run app/ap9100.p (input raw-integracao, input-output table tt-erro).
        end.

        if b-mov-ap-imp.transacao = 5 and b-mov-ap-imp.esp-ant <> "" then do:
            find first b1-tit-ap
                 where b1-tit-ap.ep-codigo  = b-mov-ap-imp.ep-codigo
                 and   b1-tit-ap.cod-estab  = b-mov-ap-imp.cod-estab
                 and   b1-tit-ap.cod-esp    = b-mov-ap-imp.esp-ant
                 and   b1-tit-ap.serie      = b-mov-ap-imp.serie-ant
                 and   b1-tit-ap.cod-fornec = b-mov-ap-imp.fornec-ant
                 and   b1-tit-ap.nr-docto   = b-mov-ap-imp.docto-ant
                 and   b1-tit-ap.parcela    = b-mov-ap-imp.parc-ant
                 exclusive-lock no-error.
            if avail b1-tit-ap then
                assign b1-tit-ap.vl-ir-antec = b1-tit-ap.vl-ir-antec + b-mov-ap-imp.vl-antecip.
        end.

        delete b-mov-ap-imp.    

    end.

    find first emitente
         where emitente.cod-emitente = b-tit-ap.cod-fornec
         and   emitente.identific   <> 1 no-lock no-error.

    if available emitente then do:
    find emit-estat use-index grupo
        where emit-estat.cod-gr-emit   = emitente.cod-gr-forn
        and   emit-estat.cod-emitente  = b-tit-ap.cod-fornec
        and   emit-estat.data          = date (month(b-tit-ap.dt-transacao), 1, year(b-tit-ap.dt-transacao)) exclusive-lock no-error.

    if  avail emit-estat then
        assign emit-estat.vl-compras = emit-estat.vl-compras - b-tit-ap.vl-original.
    end.

    find first dirf-ap 
         where dirf-ap.ep-codigo   = b-tit-ap.ep-codigo
         and   dirf-ap.cod-fornec  = b-tit-ap.cod-fornec
         and   dirf-ap.cod-estabel = b-tit-ap.cod-estabel
         and   dirf-ap.cod-esp     = b-tit-ap.cod-esp
         and   dirf-ap.serie       = b-tit-ap.serie
         and   dirf-ap.nr-docto    = b-tit-ap.nr-docto
         and   dirf-ap.parcela     = b-tit-ap.parcela
         use-index ch-fornec exclusive-lock no-error.

    if  avail dirf-ap then do:
        delete dirf-ap.   
    end.    

    assign de-saldo-ant = b-tit-ap.valor-saldo.

    /*-- atencao o valor do saldo do b-tit-ap devera ser = ao vl-original -----
     --- antes da eliminacao do registro devido a atualizacao do gerencial, ---
     --- favor nao alterar esta logica sem antes falar com o ANDERSON ------- */

    {app/ap9100.i2}
    assign b-tit-ap.valor-saldo       = b-tit-ap.vl-original
           tt-integ-ap.tt-row-tit-ap  = rowid(b-tit-ap)
           tt-integ-ap.tt-ge0102b     = yes
           tt-integ-ap.tt-op-ge0102b  = 6.  /*Elimina*/
    raw-transfer tt-integ-ap to raw-integracao.
    run app/ap9100.p (input raw-integracao, input-output table tt-erro).

    {app/ap9100.i2}
    assign b-tit-ap.valor-saldo       = de-saldo-ant
           tt-integ-ap.tt-row-tit-ap  = rowid(b-tit-ap)
           tt-integ-ap.tt-ge0102g     = yes
           tt-integ-ap.tt-op-ge0102g  = 6. /*Elimina*/
    raw-transfer tt-integ-ap to raw-integracao.
    run app/ap9100.p (input raw-integracao, input-output table tt-erro).

    /*---- Elimina Impostos do T¡tulo ----*/
    for each  impto-tit-ap exclusive-lock
        where impto-tit-ap.ep-codigo   = mov-ap.ep-codigo
        and   impto-tit-ap.cod-estabel = mov-ap.cod-estabel
        and   impto-tit-ap.cod-fornec  = mov-ap.cod-fornec
        and   impto-tit-ap.serie       = mov-ap.serie
        and   impto-tit-ap.cod-esp     = mov-ap.cod-esp
        and   impto-tit-ap.nr-docto    = mov-ap.nr-docto
        and   impto-tit-ap.parcela     = mov-ap.parcela:
        delete impto-tit-ap validate (true,"").
    end.

    /*---- Elimina Autoriza‡äes Pagamento ---*/
    for each  usuar-autoriza-tit use-index codigo
        where usuar-autoriza-tit.ep-codigo    = mov-ap.ep-codigo
        and   usuar-autoriza-tit.nr-bordero   = 0
        and   usuar-autoriza-tit.cod-portador = 0
        and   usuar-autoriza-tit.cod-estabel  = mov-ap.cod-estabel
        and   usuar-autoriza-tit.cod-fornec   = mov-ap.cod-fornec
        and   usuar-autoriza-tit.cod-esp      = mov-ap.cod-esp
        and   usuar-autoriza-tit.serie        = mov-ap.serie
        and   usuar-autoriza-tit.nr-docto     = mov-ap.nr-docto
        and   usuar-autoriza-tit.parcela      = mov-ap.parcela exclusive-lock:
        delete usuar-autoriza-tit validate (true,"").
    end.                   

    IF  c-nom-prog-upc-mg97  <> "" OR
        c-nom-prog-dpc-mg97  <> "" OR
        c-nom-prog-appc-mg97 <> "" THEN DO:
        
        {include/i-epc102.i tit-ap}

        {include/i-epc200.i2 &CodEvent='"elimina-retencao"'
                             &CodParameter='"rowid retencao"'
                             &ValueParameter="string(rowid(b-tit-ap))"}

        {include/i-epc201.i "elimina-retencao"}

        if  return-value = "NOK" then    
            return "nok".                    
    end.

    delete b-tit-ap.            
    
end.

/* Fim de Include */


