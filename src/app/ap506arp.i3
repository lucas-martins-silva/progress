/*****************************************************************************
***
*** app/ap506arp.i3 - pi-cancela-ir.
*** 
*****************************************************************************/

def buffer b2-tit-ap for tit-ap.

def var da-data         as date.
def var da-fluxo        as date.

def var l-elimina       as log initIal true.
def var l-cb0110        as logical.
def var de-saldo-ant    like tit-ap.valor-saldo no-undo.

form
    b-tit-ap.cod-estabel 
    b-tit-ap.cod-esp     
    b-tit-ap.serie       
    b-tit-ap.nr-docto    
    b-tit-ap.parcela     
    b-tit-ap.cod-fornec  
    b-tit-ap.vl-original 
    b-tit-ap.valor-saldo 
    with stream-io down no-box no-attr-space width 132 frame f-detalhe2.


for each b-tit-ap
   where b-tit-ap.ep-codigo   = tit-ap.ep-codigo
   and   b-tit-ap.cod-fornec  = tit-ap.cod-fornec
   and   b-tit-ap.cod-estabel = tit-ap.cod-estabel
   and   b-tit-ap.esp-ant     = tit-ap.cod-esp
   and   b-tit-ap.serie-ant   = tit-ap.serie
   and   b-tit-ap.docto-ant   = tit-ap.nr-docto
   and   b-tit-ap.parc-ant    = tit-ap.parcela
   and   b-tit-ap.tipo        = 8:
        
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
       run utp/ut-liter.p ("msg", 5893, "").
       message return-value.
       assign l-elimina = no.
   end.

    find first mov-ap use-index codigo
        where mov-ap.ep-codigo   = b-tit-ap.ep-codigo
        and   mov-ap.cod-fornec  = b-tit-ap.cod-fornec
        and   mov-ap.cod-estabel = b-tit-ap.cod-estabel
        and   mov-ap.cod-esp     = b-tit-ap.cod-esp
        and   mov-ap.serie       = b-tit-ap.serie
        and   mov-ap.nr-docto    = b-tit-ap.nr-docto
        and   mov-ap.parcela     = b-tit-ap.parcela
        and   mov-ap.transacao   = 6 no-lock no-error.
            
    if  avail mov-ap then do:
        run utp/ut-liter.p ("msg", 5894, "").
        message return-value.
        assign l-elimina = no.
    end.
                
    find first mov-ap use-index codigo
         where mov-ap.ep-codigo    = b-tit-ap.ep-codigo
         and   mov-ap.cod-fornec   = b-tit-ap.cod-fornec
         and   mov-ap.cod-estabel  = b-tit-ap.cod-estabel
         and   mov-ap.cod-esp      = b-tit-ap.cod-esp
         and   mov-ap.serie        = b-tit-ap.serie
         and   mov-ap.nr-docto     = b-tit-ap.nr-docto
         and   mov-ap.parcela      = b-tit-ap.parcela
         and   mov-ap.contabilizou = yes no-lock no-error.
         
    if  avail mov-ap then do:
        run utp/ut-liter.p ("msg", 5895, "").
        message return-value.
        assign l-elimina = no.
    end.

    if  l-elimina then do:
                    
        for each emite-ap use-index codigo
            where emite-ap.ep-codigo   = b-tit-ap.ep-codigo
            and   emite-ap.cod-fornec  = b-tit-ap.cod-fornec
            and   emite-ap.cod-estabel = b-tit-ap.cod-estabel
            and   emite-ap.cod-esp     = b-tit-ap.cod-esp
            and   emite-ap.serie       = b-tit-ap.serie
            and   emite-ap.nr-docto    = b-tit-ap.nr-docto
            and   emite-ap.parcela     = b-tit-ap.parcela exclusive-lock:
                                
            /************ MULTIPLANTA *************/ 
            run pi-cria-tt-dados-emite-ap (input 3).
            /**************************************/
                    
            delete emite-ap. 
        end.
        
        for each mov-ap use-index codigo
            where mov-ap.ep-codigo   = b-tit-ap.ep-codigo
            and   mov-ap.cod-fornec  = b-tit-ap.cod-fornec
            and   mov-ap.cod-estabel = b-tit-ap.cod-estabel
            and   mov-ap.cod-esp     = b-tit-ap.cod-esp
            and   mov-ap.serie       = b-tit-ap.serie
            and   mov-ap.nr-docto    = b-tit-ap.nr-docto
            and   mov-ap.parcela     = b-tit-ap.parcela no-lock:

            {app/ap9100.i2}
            assign tt-integ-ap.tt-row-tit-ap  = rowid(b-tit-ap)
                   tt-integ-ap.tt-row-mov-ap  = rowid(mov-ap)
                   tt-integ-ap.tt-cb0110a     = yes
                   tt-integ-ap.tt-op-cb0110a  = 22.
            raw-transfer tt-integ-ap to raw-integracao.
            run app/ap9100.p (input raw-integracao, input-output table tt-erro).
                
            if  mov-ap.transacao = 2 then do:
                {app/ap9100.i2}
                assign tt-integ-ap.tt-row-tit-ap  = rowid(b-tit-ap)
                       tt-integ-ap.tt-row-mov-ap  = rowid(mov-ap)
                       tt-integ-ap.tt-ge0102b     = yes
                       tt-integ-ap.tt-op-ge0102b  = 7. /*Elimina Baixa*/
                raw-transfer tt-integ-ap to raw-integracao.
                run app/ap9100.p (input raw-integracao, input-output table tt-erro).
            end.
                        
            find first che-emit
                where che-emit.ep-codigo   = mov-ap.ep-codigo
                and   che-emit.portador    = mov-ap.portador
                and   che-emit.nr-cheque   = mov-ap.nr-cheque
                and   che-emit.cod-fornec  = mov-ap.cod-fornec
                and   che-emit.cod-estabel = mov-ap.cod-estabel
                and   che-emit.cod-esp     = mov-ap.cod-esp
                and   che-emit.serie       = mov-ap.serie
                and   che-emit.nr-docto    = mov-ap.nr-docto
                and   che-emit.parcela     = mov-ap.parcela
                and   che-emit.dt-emissao  = mov-ap.dt-transacao no-error.
                
            if  avail che-emit then do:
                        
                assign che-emit.cancelado = yes.
                        
                /************ MULTIPLANTA *************/ 
                run pi-cria-tt-che-emit (input 2).
                /**************************************/
                            
            end.
            
            for each tit-conta-ap
                where tit-conta-ap.ep-codigo   = mov-ap.ep-codigo
                and   tit-conta-ap.cod-estabel = mov-ap.cod-estabel
                and   tit-conta-ap.cod-esp     = mov-ap.cod-esp
                and   tit-conta-ap.serie       = mov-ap.serie
                and   tit-conta-ap.nr-docto    = mov-ap.nr-docto
                and   tit-conta-ap.parcela     = mov-ap.parcela
                and   tit-conta-ap.cod-fornec  = mov-ap.cod-fornec exclusive-lock:
                        
                /************ MULTIPLANTA *************/ 
                run pi-cria-tt-dados-tit-conta-ap (input 3).
                /**************************************/
                                    
                delete tit-conta-ap.  
            end.

            find b-mov-ap where rowid(b-mov-ap) = rowid(mov-ap) exclusive-lock no-error.
            
            if  mov-ap.transacao = 2 then do:
                {app/ap9100.i2}
                assign tt-integ-ap.tt-row-tit-ap  = rowid(b-tit-ap)
                       tt-integ-ap.tt-row-mov-ap  = rowid(mov-ap)
                       tt-integ-ap.tt-ge0102b     = yes
                       tt-integ-ap.tt-ge0102g     = yes
                       tt-integ-ap.tt-op-ge0102b  = 6
                       tt-integ-ap.tt-op-ge0102g  = 6.
                raw-transfer tt-integ-ap to raw-integracao.
                run app/ap9100.p (input raw-integracao, input-output table tt-erro).
            end.
 
            if  mov-ap.transacao = 5 and mov-ap.esp-ant   <> "" then do:
                /* Procura da antecipacao que gerou o IR antecipado */
                find first b2-tit-ap
                    where b2-tit-ap.ep-codigo  = mov-ap.ep-codigo
                    and   b2-tit-ap.cod-estab  = mov-ap.cod-estab
                    and   b2-tit-ap.esp-ant    = mov-ap.esp-ant
                    and   b2-tit-ap.serie-ant  = mov-ap.serie-ant
                    and   b2-tit-ap.cod-fornec = mov-ap.fornec-ant
                    and   b2-tit-ap.docto-ant  = mov-ap.docto-ant
                    and   b2-tit-ap.parc-ant   = mov-ap.parc-ant
                    exclusive-lock no-error.
                if  avail b2-tit-ap then do:
                    assign b2-tit-ap.vl-ir-antec = b2-tit-ap.vl-ir-antec + mov-ap.vl-antecip.                                
                end.
            end.
            
            find b-mov-ap where rowid(b-mov-ap) = rowid(mov-ap) exclusive-lock.
                            
            /************ MULTIPLANTA *************/ 
            run pi-cria-tt-dados-b-mov-ap (input 3).
            /**************************************/
                                
            delete b-mov-ap.    
            
        end.

        disp b-tit-ap.cod-estabel
             b-tit-ap.cod-esp
             b-tit-ap.serie
             b-tit-ap.nr-docto
             b-tit-ap.parcela
             b-tit-ap.cod-fornec
             b-tit-ap.valor-saldo
             b-tit-ap.vl-original
             with frame f-detalhe2.
        down with frame f-detalhe2.
        
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

        find dirf-ap where dirf-ap.ep-codigo    = b-tit-ap.ep-codigo
                        and dirf-ap.cod-fornec  = b-tit-ap.cod-fornec
                        and dirf-ap.cod-estabel = b-tit-ap.cod-estabel
                        and dirf-ap.cod-esp     = b-tit-ap.cod-esp
                        and dirf-ap.serie       = b-tit-ap.serie
                        and dirf-ap.nr-docto    = b-tit-ap.nr-docto
                        and dirf-ap.parcela     = b-tit-ap.parcela
                        use-index ch-fornec exclusive-lock no-error.
                        
        if  avail dirf-ap then do:
                        
            /************ MULTIPLANTA *************/ 
            run pi-cria-tt-dados-dirf-ap (input 3).
            /**************************************/
                        
            delete dirf-ap.   
        end.    

        {app/ap9100.i2}
        assign tt-integ-ap.tt-row-tit-ap  = rowid(b-tit-ap)
               tt-integ-ap.tt-cb0110a     = yes
               tt-integ-ap.tt-op-cb0110a  = 6. /*Elimina*/
        raw-transfer tt-integ-ap to raw-integracao.
        run app/ap9100.p (input raw-integracao, input-output table tt-erro).
            
        assign de-saldo-ant = b-tit-ap.valor-saldo.
        
   /*-- atencao o valor do saldo do b-tit-ap devera ser = ao vl-original -----
    --- antes da eliminacao do registro devido a atualizacao do gerencial, ---
    --- favor nao alterar esta logica sem antes falar com o ANDERSON ------- */

        {app/ap9100.i2}
        assign b-tit-ap.valor-saldo         = b-tit-ap.vl-original
               tt-integ-ap.tt-row-tit-ap  = rowid(b-tit-ap)
               tt-integ-ap.tt-ge0102b     = yes
               tt-integ-ap.tt-op-ge0102b  = 6.  /*Elimina*/
        raw-transfer tt-integ-ap to raw-integracao.
        run app/ap9100.p (input raw-integracao, input-output table tt-erro).
        
        {app/ap9100.i2}
        assign b-tit-ap.valor-saldo         = de-saldo-ant
               tt-integ-ap.tt-row-tit-ap  = rowid(b-tit-ap)
               tt-integ-ap.tt-ge0102g     = yes
               tt-integ-ap.tt-op-ge0102g  = 6. /*Elimina*/
        raw-transfer tt-integ-ap to raw-integracao.
        run app/ap9100.p (input raw-integracao, input-output table tt-erro).
                    
        /************ MULTIPLANTA *************/ 
        run pi-cria-tt-dados-b-tit-ap (input 3).
        /**************************************/
                    
        delete b-tit-ap.
            
    end.

    disp skip with frame f-detalhe2.
        
end.

/* Fim de Include */
