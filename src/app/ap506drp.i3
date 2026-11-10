/*****************************************************************************
***
*** app/ap506drp.i3 - Cancela impostos vinculados a baixa por cheque
*** 
*****************************************************************************/

/* --- Buffers --- */
def buffer b1-tit-ap    for tit-ap.
def buffer b-tit-ap     for tit-ap.
def buffer b-mov-ap-imp for mov-ap.

/* --- Vari veis --- */
def var da-data         as date.
def var da-fluxo        as date.
def var l-elimina       as log initIal true.
def var l-cb0110        as logical.
def var de-saldo-ant    like tit-ap.valor-saldo no-undo.


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

        def buffer b-mov-ap-aux for mov-ap.

        for each b-mov-ap-aux of b-tit-ap no-lock:                
        
            if  b-mov-ap-aux.transacao <> 1 
            and b-mov-ap-aux.transacao <> 6
            and b-mov-ap-aux.origem    <> 5 then do:
        
                find first tipo-tax where
                           tipo-tax.cod-tax = tit-ap.cod-impto-ret no-lock no-error.
                     IF  AVAIL tipo-tax AND tipo-tax.tipo <> 1 THEN DO:
        
                         run utp/ut-msgs.p ("msg",
                                            18172, 
                                            string(b-mov-ap-aux.cod-estabel) + "~~" +
                                            string(b-mov-ap-aux.cod-fornec)  + "~~" +
                                            string(b-mov-ap-aux.cod-esp)     + "~~" +
                                            string(b-mov-ap-aux.serie)       + "~~" +
                                            string(b-mov-ap-aux.nr-docto)    + "~~" +
                                            string(b-mov-ap-aux.parcela)     + "~~" +
                                            string(b-mov-ap-aux.nr-cheque)   + "~~" +
                                            string(b-mov-ap-aux.referencia)).
        
                         assign l-elimina = no.                             
                     end.
            end.        
        
            if   b-mov-ap-aux.transacao = 5 and b-mov-ap-aux.tipo = 10 and b-mov-ap-aux.docto-ant <> " " then do:
                run utp/ut-msgs.p ("msg",
                                   19447, 
                                   string(b-mov-ap-aux.cod-estabel) + "~~" +
                                   string(b-mov-ap-aux.fornec-ant)  + "~~" +
                                   string(b-mov-ap-aux.esp-ant)     + "~~" +
                                   string(b-mov-ap-aux.serie-ant)   + "~~" +
                                   string(b-mov-ap-aux.docto-ant)   + "~~" +
                                   string(b-mov-ap-aux.parc-ant)).
        
                assign l-elimina = no.                             
            end.
        
        
            find first che-emit no-lock
                 where che-emit.ep-codigo   = b-mov-ap-aux.ep-codigo
                 and   che-emit.portador    = b-mov-ap-aux.portador
                 and   che-emit.nr-cheque   = b-mov-ap-aux.nr-cheque
                 and   che-emit.cod-fornec  = b-mov-ap-aux.cod-fornec
                 and   che-emit.cod-estabel = b-mov-ap-aux.cod-estabel
                 and   che-emit.cod-esp     = b-mov-ap-aux.cod-esp
                 and   che-emit.serie       = b-mov-ap-aux.serie
                 and   che-emit.nr-docto    = b-mov-ap-aux.nr-docto
                 and   che-emit.parcela     = b-mov-ap-aux.parcela
                 and   che-emit.dt-emissao  = b-mov-ap-aux.dt-transacao 
                 and   che-emit.emitiu      = yes no-error.
        
            if  avail che-emit then do:
                run utp/ut-msgs.p ("msg",
                                   16907, 
                                  string(che-emit.cod-estabel) + "~~" +
                                  string(che-emit.cod-fornec)  + "~~" +
                                  string(che-emit.cod-esp)     + "~~" +
                                  string(che-emit.serie)       + "~~" +
                                  string(che-emit.nr-docto)    + "~~" +
                                  string(che-emit.parcela)     + "~~" +
                                  string(che-emit.nr-cheque)   + "~~" +
                                  string(che-emit.referencia)).
        
                assign l-elimina = no.                             
            end.
        end.
        
        if not l-elimina then
            return "NOK".
        
        assign da-data  = (if  b-tit-ap.dt-prev-pag <> ? 
                           then b-tit-ap.dt-prev-pag
                           else b-tit-ap.dt-vencimen)
               da-fluxo = b-tit-ap.dt-fluxo.
        
        find first lin-b-ap
             where lin-b-ap.ep-codigo   = b-tit-ap.ep-codigo
             and   lin-b-ap.cod-estabel = b-tit-ap.cod-estabel
             and   lin-b-ap.cod-esp     = b-tit-ap.cod-esp
             and   lin-b-ap.nr-docto    = b-tit-ap.nr-docto
             and   lin-b-ap.parcela     = b-tit-ap.parcela
             and   lin-b-ap.serie       = b-tit-ap.serie
             and   lin-b-ap.cod-fornec  = b-tit-ap.cod-fornec no-lock no-error.
        
        if  avail lin-b-ap then do:
            run utp/ut-msgs.p (input "msg", 
                               input 30327,
                               input "").
            next.
        end.
        
        find first b-mov-ap-imp use-index codigo
             where b-mov-ap-imp.ep-codigo   = b-tit-ap.ep-codigo
             and   b-mov-ap-imp.cod-fornec  = b-tit-ap.cod-fornec
             and   b-mov-ap-imp.cod-estabel = b-tit-ap.cod-estabel
             and   b-mov-ap-imp.cod-esp     = b-tit-ap.cod-esp
             and   b-mov-ap-imp.serie       = b-tit-ap.serie
             and   b-mov-ap-imp.nr-docto    = b-tit-ap.nr-docto
             and   b-mov-ap-imp.parcela     = b-tit-ap.parcela
             and   b-mov-ap-imp.transacao   = 6 no-lock no-error.
        
        if  avail b-mov-ap-imp then do:
            run utp/ut-msgs.p (input "msg", 
                               input 30328,
                               input "").
            next.
        end.
        
        find first b-mov-ap-imp use-index codigo
             where b-mov-ap-imp.ep-codigo    = b-tit-ap.ep-codigo
             and   b-mov-ap-imp.cod-fornec   = b-tit-ap.cod-fornec
             and   b-mov-ap-imp.cod-estabel  = b-tit-ap.cod-estabel
             and   b-mov-ap-imp.cod-esp      = b-tit-ap.cod-esp
             and   b-mov-ap-imp.serie        = b-tit-ap.serie
             and   b-mov-ap-imp.nr-docto     = b-tit-ap.nr-docto
             and   b-mov-ap-imp.parcela      = b-tit-ap.parcela
             and   b-mov-ap-imp.contabilizou = yes no-lock no-error.
        
        if  avail b-mov-ap-imp then do:
        
            run utp/ut-msgs.p (input "msg", 
                               input 30329,
                               input "").
            next.
        end.
        
        if  l-elimina then do:
        
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
        
            delete b-tit-ap.            
        end.
end.

/* Fim de Include */
