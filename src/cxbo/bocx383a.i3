/************************************************************************
**
** cxbo/bocx383a.i3 - Cria‡Æo das duplicatas das despesas.
**
************************************************************************/
def var l-continua         as   logical no-undo.

def var de-val-desp             like dupli-apagar-cex.vl-a-pagar no-undo.
def var de-val-desp-mo          like dupli-apagar-cex.vl-a-pagar no-undo.
DEF VAR de-desp-tot-val-desp-mo LIKE cotacao-item-cex.val-desp   NO-UNDO.
DEF VAR i-cod-emitente-desp-ii  LIKE emitente.cod-emitente       NO-UNDO.
DEF VAR c-espec-padr            AS   CHAR FORMAT "x(2)"          NO-UNDO.
def var i-cont                  as int no-undo.
DEF VAR i-mo-codigo-ant         AS INT NO-UNDO.
def var i-seq-nacionaliz        AS INT NO-UNDO.
def var i-pto-nacionaliz        as int no-undo.
def var i-num-adic              AS INT INITIAL 0 NO-UNDO.
def var i-tp-despesa            as int initial 0 no-undo.

&IF  '{&bf_mat_versao_ems}' >= '2.06' &THEN
    &GLOBAL-DEFINE vcod-espec-padr desp-imp.cod-espec-padr
&ELSE
    &GLOBAL-DEFINE vcod-espec-padr SUBSTRING(desp-imp.char-1,14,2)
&ENDIF

for each tt-dupli-apagar-cex:
    delete tt-dupli-apagar-cex.
end.

for each tt-desp-totais:
    delete tt-desp-totais.
end.

IF NOT VALID-HANDLE(h-bocx407) THEN
    RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.

RUN retorna-seq-ponto-nacionaliz IN h-bocx407 (INPUT SUBSTRING(tt-documEst-aux.char-1,1,20),
                                               INPUT tt-documEst-aux.cod-estabel ,
                                               OUTPUT i-seq-nacionaliz).
                
FOR EACH  historico-embarque NO-LOCK
    WHERE historico-embarque.cod-estabel = tt-documEst-aux.cod-estabel
    AND   historico-embarque.embarque    = SUBSTRING(tt-documEst-aux.char-1,1,20) 
    AND   historico-embarque.sequencia   <= i-seq-nacionaliz,
    EACH  desp-embarque NO-LOCK
    where desp-embarque.cod-estabel = historico-embarque.cod-estabel
    and   desp-embarque.embarque    = historico-embarque.embarque:
    
    find last tt-desp-totais
         where tt-desp-totais.cod-desp = desp-embarque.cod-desp no-lock no-error.
    if avail tt-desp-totais then
        assign i-num-adic = i-num-adic + 1.
    else 
        assign i-num-adic = 1.

    assign i-tp-despesa = 0.        

    &if '{&bf_mat_versao_ems}':U >= '2.062':U &then            
        for first desp-imp fields (tp-despesa)
            where desp-imp.cod-desp = desp-embarque.cod-desp no-lock: end.
        if  avail desp-imp
            and   desp-imp.tp-despesa > 0 then
            assign i-tp-despesa = desp-imp.tp-despesa.
        else do:
            if  not avail emitente 
            or  emitente.cod-emitente <> desp-embarque.cod-emitente-desp then
                for first emitente fields (cod-emitente tp-desp-padrao)
                    where emitente.cod-emitente = desp-embarque.cod-emitente-desp no-lock: end.

            IF  AVAIL emitente THEN
                assign i-tp-despesa = emitente.tp-desp-padrao.
        end.
    &endif

        
    if not can-find(first tt-desp-totais
                    where tt-desp-totais.cod-desp = desp-embarque.cod-desp) then do:
                    
        create tt-desp-totais.    
        assign tt-desp-totais.cod-desp          = desp-embarque.cod-desp
               tt-desp-totais.num-adic          = i-num-adic         
               tt-desp-totais.cod-emitente-desp = desp-embarque.cod-emitente-desp
               tt-desp-totais.cod-cond-pag      = desp-embarque.cod-cond-pag
               tt-desp-totais.val-desp          = desp-embarque.val-desp
               tt-desp-totais.val-desp-mo       = desp-embarque.val-desp
               tt-desp-totais.mo-codigo         = desp-embarque.mo-codigo
               tt-desp-totais.cotacao           = 0
               tt-desp-totais.cod-pto-contr     = historico-embarque.cod-pto-contr
               tt-desp-totais.tp-despesa        = i-tp-despesa.

    end.
END.

for each tt-docum-est-cex 
    where tt-docum-est-cex.serie-docto   = tt-documEst-aux.serie-docto
      and tt-docum-est-cex.nro-docto     = tt-documEst-aux.nro-docto       
      and tt-docum-est-cex.cod-emitente  = tt-documEst-aux.cod-emitente
      and tt-docum-est-cex.nat-operacao  = tt-documEst-aux.nat-operacao
      no-lock:
      
    /* Testa se despesa incide no valor da duplicata */
    find desp-imp
        where desp-imp.cod-desp = tt-docum-est-cex.cod-desp no-lock no-error.
        
    if avail desp-imp and not desp-imp.inc-val-duplic then
        next.
       
    assign l-continua = yes.
       
    find emitente
        where emitente.cod-emitente = tt-docum-est-cex.cod-emitente-desp no-lock no-error.
    
    if tt-docum-est-cex.cod-desp = i-desp-ii-i50 then do:
        
        if not can-find(first tt-desp-totais
                        where tt-desp-totais.cod-desp = tt-docum-est-cex.cod-desp) then do:

            run retorna-ponto-nacionalizacao in h-bocx407(INPUT substring(tt-documEst-aux.char-1,1,20),
                                                          INPUT tt-documEst-aux.cod-estabel,
                                                          OUTPUT i-pto-nacionaliz).
                    
            create tt-desp-totais.    
            assign tt-desp-totais.cod-desp          = tt-docum-est-cex.cod-desp
                   tt-desp-totais.num-adic          = i-num-adic + 1        
                   tt-desp-totais.cod-emitente-desp = tt-docum-est-cex.cod-emitente-desp
                   tt-desp-totais.cod-cond-pag      = tt-docum-est-cex.cod-cond-pag
                   tt-desp-totais.val-desp          = tt-docum-est-cex.val-desp
                   tt-desp-totais.val-desp-mo       = tt-docum-est-cex.val-desp
                   tt-desp-totais.mo-codigo         = tt-docum-est-cex.mo-codigo
                   tt-desp-totais.cotacao           = 0
                   tt-desp-totais.cod-pto-contr     = i-pto-nacionaliz
                   tt-desp-totais.tp-despesa        = if avail desp-imp and desp-imp.tp-despesa > 0 then desp-imp.tp-despesa else emitente.tp-desp-padrao.
        end.
    end.
    
    assign de-desp-tot-val-desp-mo = 0.
    for each tt-desp-totais
        where tt-desp-totais.cod-desp = tt-docum-est-cex.cod-desp:
        assign de-desp-tot-val-desp-mo = de-desp-tot-val-desp-mo + tt-desp-totais.val-desp-mo.
    end. 
    
    find first tt-desp-totais
        where tt-desp-totais.cod-desp = tt-docum-est-cex.cod-desp no-error.    
   
    if not avail tt-desp-totais then
        next.        

    IF  AVAIL param-imp THEN
        ASSIGN c-espec-padr = param-imp.esp-tit-rec.

    FOR FIRST desp-imp NO-LOCK
        WHERE desp-imp.cod-desp = tt-docum-est-cex.cod-desp
          AND {&vcod-espec-padr} <> "":
    
        ASSIGN c-espec-padr = {&vcod-espec-padr}.
    END.
    
    for each tt-item-doc-est-cex
       where tt-item-doc-est-cex.serie-docto       = tt-docum-est-cex.serie-docto
         and tt-item-doc-est-cex.nro-docto         = tt-docum-est-cex.nro-docto
         and tt-item-doc-est-cex.cod-emitente      = tt-docum-est-cex.cod-emitente
         and tt-item-doc-est-cex.nat-operacao      = tt-docum-est-cex.nat-operacao
         and tt-item-doc-est-cex.cod-emitente-desp = tt-docum-est-cex.cod-emitente-desp          
         and tt-item-doc-est-cex.cod-desp          = tt-docum-est-cex.cod-desp
         no-lock:
         
        find {1} 
            where {1}.serie-docto   = tt-item-doc-est-cex.serie-docto
              and {1}.nro-docto     = tt-item-doc-est-cex.nro-docto
              and {1}.cod-emitente  = tt-item-doc-est-cex.cod-emitente
              and {1}.nat-operacao  = tt-item-doc-est-cex.nat-operacao
              and {1}.sequencia     = tt-item-doc-est-cex.sequencia no-lock no-error.             
              
        assign de-val-desp    = tt-item-doc-est-cex.val-desp
               de-val-desp-mo = tt-item-doc-est-cex.val-desp.

        if tt-desp-totais.mo-codigo <> 0 then do:        
        
            for first decla-import no-lock
                where decla-import.cod-di-siscomex = tt-documEst-aux.declaracao-import : end.

            RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                    INPUT decla-import.cdd-siscomex-dts,
                                    INPUT tt-desp-totais.mo-codigo,
                                    INPUT 0,
                                    INPUT de-val-desp,
                                    INPUT decla-import.dat-di,
                                    OUTPUT de-val-desp-mo).               
                
        end.

        find ordem-compra
            where ordem-compra.numero-ordem = {1}.numero-ordem no-lock no-error.
            
        
        /* 
        ** Verifica se a despesa possui o mesmo fornecedor do material
        ** se tiver, o valor da duplicata de despesa ‚ somado ao valor da duplicata do material e
        ** o valor ‚ rateado conforme condi‡Æo de pagamento do material 
        */
        find first tt-dupli-apagar 
            where tt-dupli-apagar.serie-docto  = tt-documEst-aux.serie-docto
              and tt-dupli-apagar.nro-docto    = tt-documEst-aux.nro-docto
              and tt-dupli-apagar.cod-emitente = tt-docum-est-cex.cod-emitente-desp
              and tt-dupli-apagar.nat-operacao = tt-documEst-aux.nat-operacao
              and tt-dupli-apagar.mo-codigo    = tt-desp-totais.mo-codigo
              AND tt-dupli-apagar.cod-esp      = c-espec-padr
              &if '{&bf_mat_versao_ems}' >= '2.062' &then
                  and tt-dupli-apagar.tp-despesa = tt-desp-totais.tp-despesa
              &endif
              no-error.
              
        if avail tt-dupli-apagar then do:
           if tt-docum-est-cex.cod-desp <> i-desp-ii-i50 then do: /* Quando for Imposto Importa‡Æo duplicata ‚ gerada separadamente */
              assign de-tot-vl-docto    = de-tot-vl-docto
                                        + de-val-desp.
              assign de-vl-docto-mo     = 0
                     de-tot-vl-docto-mo = de-tot-vl-docto / tt-nota.cotacao-dia.
                   
              find historico-embarque 
                  where historico-embarque.cod-estabel   = tt-documEst-aux.cod-estabel
                    and historico-embarque.embarque      = tt-documEst-aux.embarque
                    and historico-embarque.cod-itiner    = tt-nota.cod-itiner
                    and historico-embarque.cod-pto-contr = tt-nota.cod-pto-contr-base
                    no-lock no-error.
                  
              find cond-pagto
                  where cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag no-lock no-error.
            
              if not avail cond-pagto then do:
                  find cond-especif where 
                       cond-especif.num-pedido = ordem-compra.num-pedido no-lock no-error.
                if  not avail cond-especif then next.
                else do:
                    do i-ind = 1 to 6:
                        if  cond-especif.data-pagto[i-ind] <> ? then do:                
                            find first tt-dupli-apagar 
                                where tt-dupli-apagar.serie-docto  = tt-documEst-aux.serie-docto
                                  and tt-dupli-apagar.nro-docto    = tt-documEst-aux.nro-docto
                                  and tt-dupli-apagar.cod-emitente = tt-docum-est-cex.cod-emitente-desp
                                  and tt-dupli-apagar.nat-operacao = tt-documEst-aux.nat-operacao 
                                  and tt-dupli-apagar.dt-vencim    = cond-especif.data-pagto[i-ind]
                                &if '{&bf_mat_versao_ems}' >= '2.062' &then
                                  and tt-dupli-apagar.tp-despesa = tt-desp-totais.tp-despesa
                                &endif                                  
                                no-error.
                            if avail tt-dupli-apagar then do:
                                assign tt-dupli-apagar.vl-a-pagar  = tt-dupli-apagar.vl-a-pagar +
                                                                    (de-val-desp 
                                                                     * cond-especif.perc-pagto[i-ind]
                                                                     / 100).
                                                                     
                                RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                                        INPUT decla-import.cdd-siscomex-dts,
                                                        INPUT tt-dupli-apagar.mo-codigo,
                                                        INPUT 0,
                                                        INPUT tt-dupli-apagar.vl-a-pagar,
                                                        INPUT decla-import.dat-di,
                                                        OUTPUT de-val-desp-mo).

                                assign tt-dupli-apagar.vl-a-pagar-mo = de-val-desp-mo.
                                
                            end.                                                                     
                        end.
                    end.
                end.
              end.
              else do:               
                  assign da-data    = today.               
                      
                  if not avail historico-embarque then
                      assign da-partida = tt-documEst-aux.dt-emissao.
                  else
                      assign da-partida = historico-embarque.dt-efetiva.
                      
                  {cdp/cd9020.i7 tt-documEst-aux.cod-estabel y}
                  
                  do  i-ind = 1 to cond-pagto.num-parcelas:
                      if da-data[i-ind] < today then 
                          assign da-data[i-ind] = tt-documEst-aux.dt-emissao.                
                          
                      find first tt-dupli-apagar 
                          where tt-dupli-apagar.serie-docto  = tt-documEst-aux.serie-docto
                            and tt-dupli-apagar.nro-docto    = tt-documEst-aux.nro-docto
                            and tt-dupli-apagar.cod-emitente = tt-docum-est-cex.cod-emitente-desp
                            and tt-dupli-apagar.nat-operacao = tt-documEst-aux.nat-operacao 
                            and tt-dupli-apagar.dt-vencim    = da-data[i-ind]
                          &if '{&bf_mat_versao_ems}' >= '2.062' &then
                            and tt-dupli-apagar.tp-despesa = tt-desp-totais.tp-despesa
                          &endif
                            no-error.
                      if avail tt-dupli-apagar then do:
                          assign tt-dupli-apagar.vl-a-pagar  = tt-dupli-apagar.vl-a-pagar 
                                                             + (de-val-desp
                                                             * cond-pagto.per-pg-dup[i-ind]
                                                             / 100).
                          RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                                  INPUT decla-import.cdd-siscomex-dts,
                                                  INPUT tt-dupli-apagar.mo-codigo,
                                                  INPUT 0,
                                                  INPUT tt-dupli-apagar.vl-a-pagar,
                                                  INPUT decla-import.dat-di,
                                                  OUTPUT de-val-desp-mo).

                          assign tt-dupli-apagar.vl-a-pagar-mo = de-val-desp-mo.                                                             

                      end.
                  end.
              end.            
              assign l-continua = no.            
           end.
        end.
        else do:              
            /*duplicatas do fornecedor da mercadoria porem com moedas diferentes na despesa*/
            find first tt-dupli-apagar 
                 where tt-dupli-apagar.serie-docto  = tt-documEst-aux.serie-docto
                   and tt-dupli-apagar.nro-docto    = tt-documEst-aux.nro-docto
                   and tt-dupli-apagar.cod-emitente = tt-docum-est-cex.cod-emitente-desp
                   and tt-dupli-apagar.nat-operacao = tt-documEst-aux.nat-operacao
                   AND tt-dupli-apagar.cod-esp      = c-espec-padr
                   no-error.

            if  avail tt-dupli-apagar 
            and tt-docum-est-cex.cod-desp <> i-desp-ii-i50 then do: /* Quando for Imposto Importa‡Æo duplicata ‚ gerada separadamente */

                if i-moeda-material = tt-desp-totais.mo-codigo then do:
                   assign de-tot-vl-docto    = de-tot-vl-docto
                                             + de-val-desp.
                   assign de-vl-docto-mo     = 0
                          de-tot-vl-docto-mo = de-tot-vl-docto / tt-nota.cotacao-dia.
                          
                end.
                else do:
                   assign de-tot-vl-docto-aux = de-tot-vl-docto-aux
                                              + de-val-desp
                          de-vl-docto-mo     = 0.
                          
                          if  tt-desp-totais.mo-codigo <> 0 then
                              RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                                      INPUT decla-import.cdd-siscomex-dts,
                                                      INPUT tt-desp-totais.mo-codigo,
                                                      INPUT 0,
                                                      INPUT de-tot-vl-docto-aux,
                                                      INPUT decla-import.dat-di,
                                                      OUTPUT de-tot-vl-docto-mo-aux).       
                end.
                       
                find historico-embarque 
                    where historico-embarque.cod-estabel   = tt-documEst-aux.cod-estabel
                      and historico-embarque.embarque      = tt-documEst-aux.embarque
                      and historico-embarque.cod-itiner    = tt-nota.cod-itiner
                      and historico-embarque.cod-pto-contr = tt-nota.cod-pto-contr-base no-lock no-error.              
            
                find cond-pagto where 
                     cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag no-lock no-error.
                    
                if not avail cond-pagto then do:
                    find cond-especif where 
                         cond-especif.num-pedido = ordem-compra.num-pedido no-lock no-error.
                    if  not avail cond-especif then next.
                    else do:
                        do i-ind = 1 to 6:
                            if  cond-especif.data-pagto[i-ind] <> ? then do:                
                                find  first b-tt-dupli-apagar 
                                where b-tt-dupli-apagar.serie-docto  = tt-documEst-aux.serie-docto
                                  and b-tt-dupli-apagar.nro-docto    = tt-documEst-aux.nro-docto
                                  and b-tt-dupli-apagar.cod-emitente = tt-docum-est-cex.cod-emitente-desp
                                  and b-tt-dupli-apagar.nat-operacao = tt-documEst-aux.nat-operacao 
                                  and b-tt-dupli-apagar.dt-vencim    = cond-especif.data-pagto[i-ind] no-error.
                                
                                if avail b-tt-dupli-apagar then do:
                                         
                                     assign i-cont = 0.       
                                    
                                     for each tt-dupli-apagar no-lock
                                          break by tt-dupli-apagar.parcela
                                                by tt-dupli-apagar.dt-vencim:
                                          assign i-cont = i-cont + 1.
                                     end.  

                                     assign i-parcela = i-cont + 1.
                                     create tt-dupli-apagar.
                                     assign tt-dupli-apagar.cod-emitente  = b-tt-dupli-apagar.cod-emitente
                                            tt-dupli-apagar.dt-vencim     = b-tt-dupli-apagar.dt-vencim
                                            tt-dupli-apagar.nat-operacao  = b-tt-dupli-apagar.nat-operacao
                                            tt-dupli-apagar.nro-docto     = b-tt-dupli-apagar.nro-docto
                                            tt-dupli-apagar.parcela       = string(i-parcela)
                                            tt-dupli-apagar.serie-docto   = b-tt-dupli-apagar.serie-docto
                                            tt-dupli-apagar.nr-duplic     = b-tt-dupli-apagar.nro-docto
                                            tt-dupli-apagar.tp-despesa    = &if '{&bf_mat_versao_ems}' >= '2.062' &then
                                                                            tt-desp-totais.tp-despesa                 
                                                                            &else                                     
                                                                            b-tt-dupli-apagar.tp-despesa                   
                                                                            &endif 
                                            tt-dupli-apagar.cod-esp       = b-tt-dupli-apagar.cod-esp
                                            tt-dupli-apagar.mo-codigo     = tt-desp-totais.mo-codigo.
        
                                     assign tt-dupli-apagar.vl-a-pagar  = (de-val-desp 
                                                                          * cond-especif.perc-pagto[i-ind]
                                                                          / 100).
                                                                 
                                     if  tt-desp-totais.mo-codigo <> 0 then do:
                                            for first decla-import no-lock
                                                where decla-import.cod-di-siscomex = tt-documEst-aux.declaracao-import : end.
                                
                                            RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                                                    INPUT decla-import.cdd-siscomex-dts,
                                                                    INPUT 0,
                                                                    INPUT tt-desp-totais.mo-codigo,
                                                                    INPUT tt-dupli-apagar.vl-a-pagar,
                                                                    INPUT decla-import.dat-di,
                                                                    OUTPUT de-val-desp-mo).
                                     end.
                                                  
                                     assign tt-dupli-apagar.vl-a-pagar-mo = de-val-desp-mo.

                                     release tt-dupli-apagar.
                                end.                                                                     
                            end.
                        end.
                    end.
                end.
                else do:               
                    assign da-data    = today.               
                            
                    if not avail historico-embarque then
                        assign da-partida = tt-documEst-aux.dt-emissao.
                    else
                        assign da-partida = historico-embarque.dt-efetiva.
                            
                    {cdp/cd9020.i7 tt-documEst-aux.cod-estabel w}
                       
                    do  i-ind = 1 to cond-pagto.num-parcelas:
                        if da-data[i-ind] < today then 
                            assign da-data[i-ind] = tt-documEst-aux.dt-emissao.   
                                         
                        find  first b-tt-dupli-apagar 
                              where b-tt-dupli-apagar.serie-docto  = tt-documEst-aux.serie-docto
                                and b-tt-dupli-apagar.nro-docto    = tt-documEst-aux.nro-docto
                                and b-tt-dupli-apagar.cod-emitente = tt-docum-est-cex.cod-emitente-desp
                                and b-tt-dupli-apagar.nat-operacao = tt-documEst-aux.nat-operacao 
                                and b-tt-dupli-apagar.dt-vencim    = da-data[i-ind] no-error.
                        if avail b-tt-dupli-apagar then do:
                            
                            assign i-cont = 0.

                            for each tt-dupli-apagar no-lock
                                 break by tt-dupli-apagar.parcela
                                       by tt-dupli-apagar.dt-vencim:                                   
                               assign i-cont = i-cont + 1.
                            end.                                  

                            assign i-parcela = i-cont + 1.

                            create tt-dupli-apagar.
                            assign tt-dupli-apagar.cod-emitente  = b-tt-dupli-apagar.cod-emitente
                                   tt-dupli-apagar.dt-vencim     = b-tt-dupli-apagar.dt-vencim   
                                   tt-dupli-apagar.nat-operacao  = b-tt-dupli-apagar.nat-operacao
                                   tt-dupli-apagar.nro-docto     = b-tt-dupli-apagar.nro-docto
                                   tt-dupli-apagar.parcela       = string(i-parcela)
                                   tt-dupli-apagar.serie-docto   = b-tt-dupli-apagar.serie-docto
                                   tt-dupli-apagar.nr-duplic     = b-tt-dupli-apagar.nro-docto
                                   tt-dupli-apagar.tp-despesa    = &if '{&bf_mat_versao_ems}' >= '2.062' &then
                                                                   tt-desp-totais.tp-despesa                 
                                                                   &else                                     
                                                                   b-tt-dupli-apagar.tp-despesa                   
                                                                   &endif 
                                   tt-dupli-apagar.cod-esp       = b-tt-dupli-apagar.cod-esp
                                   tt-dupli-apagar.mo-codigo     = tt-desp-totais.mo-codigo.
        
                            assign tt-dupli-apagar.vl-a-pagar  = (de-val-desp
                                                                 * cond-pagto.per-pg-dup[i-ind]
                                                                 / 100).
                                      
                            if  tt-dupli-apagar.mo-codigo <> 0 then do:
                                    for first decla-import no-lock
                                        where decla-import.cod-di-siscomex = tt-documEst-aux.declaracao-import : end.
                        
                                    RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                                            INPUT decla-import.cdd-siscomex-dts,
                                                            INPUT 0,
                                                            INPUT tt-desp-totais.mo-codigo,
                                                            INPUT tt-dupli-apagar.vl-a-pagar,
                                                            INPUT decla-import.dat-di,
                                                            OUTPUT de-val-desp-mo).                            
                            end.
                                                         
                            assign tt-dupli-apagar.vl-a-pagar-mo = de-val-desp-mo.
                            
                            release tt-dupli-apagar.
                        end.
                    end.
                end.            
                assign l-continua = no.            
            end.               
            else do: 
                find first historico-embarque 
                     where historico-embarque.cod-estabel   = tt-documEst-aux.cod-estabel
                       and historico-embarque.embarque      = tt-documEst-aux.embarque
                       and historico-embarque.cod-itiner    = tt-nota.cod-itiner
                       and historico-embarque.cod-pto-contr = tt-desp-totais.cod-pto-contr no-lock no-error.              

                find cond-pagto where 
                     cond-pagto.cod-cond-pag = tt-docum-est-cex.cod-cond-pag no-lock no-error.
                     
                if  not avail cond-pagto then do:
                    find cond-especif-cex
                      where cond-especif-cex.num-pedido        = ordem-compra.num-pedido
                        and cond-especif-cex.cod-emitente-desp = tt-docum-est-cex.cod-emitente-desp
                        and cond-especif-cex.cod-desp          = tt-docum-est-cex.cod-desp          no-lock no-error.
                    if  not avail cond-especif-cex THEN DO:
                        ASSIGN i-msg  = 1088
                               c-char = " Cadastre ou informe uma outra Condi‡Æo de Pagamento para o Emitente " + STRING(tt-docum-est-cex.cod-emitente-desp) + ".".
                        RUN pi-gera-erro.
                        NEXT.
                    END.
                    else do:

                      /* Condicao especifica de pagamento */
                      do  i-ind = 1 to 6:
                          if  cond-especif-cex.data-pagto[i-ind] <> ? then do:                    
                              create tt-dupli-apagar-cex.
                              assign tt-dupli-apagar-cex.cod-emitente      = tt-docum-est-cex.cod-emitente
                                     tt-dupli-apagar-cex.nat-operacao      = tt-documEst-aux.nat-operacao
                                     tt-dupli-apagar-cex.serie-docto       = tt-documEst-aux.serie-docto                               
                                     tt-dupli-apagar-cex.nro-docto         = tt-documEst-aux.nro-docto
                                     tt-dupli-apagar-cex.cod-emitente-desp = tt-docum-est-cex.cod-emitente-desp
                                     tt-dupli-apagar-cex.cod-desp          = tt-docum-est-cex.cod-desp                               
                                     tt-dupli-apagar-cex.mo-codigo         = tt-desp-totais.mo-codigo
                                     tt-dupli-apagar-cex.dt-vencim         = cond-especif-cex.data-pagto[i-ind]
                                     tt-dupli-apagar-cex.tp-despesa        = &if '{&bf_mat_versao_ems}' >= '2.062' &then
                                                                             tt-desp-totais.tp-despesa                 
                                                                             &else                                     
                                                                             emitente.tp-desp-padrao                   
                                                                             &endif                                    
                                     tt-dupli-apagar-cex.vl-a-pagar        = round(de-val-desp,2)
                                                                           * cond-especif-cex.perc-pagto[i-ind] / 100
                                     tt-dupli-apagar-cex.vl-a-pagar-mo     = round(de-val-desp-mo,2)
                                                                           * cond-especif-cex.perc-pagto[i-ind] / 100
                                     tt-dupli-apagar-cex.cod-esp           = c-espec-padr.
                          end.
                      end.
                    end.
                end.
                else do:
                    assign da-data    = today.
                    
                    if not avail historico-embarque then
                        assign da-partida = tt-documEst-aux.dt-emissao.
                    else
                        assign da-partida = historico-embarque.dt-efetiva.
                                            
                    /* Condi‡Æo Pagamento Antecipada */
                    if da-partida < tt-documEst-aux.dt-emissao then
                        assign da-partida = tt-documEst-aux.dt-emissao.
                    
                    {cdp/cd9020.i7 tt-documEst-aux.cod-estabel x}

                    do  i-ind = 1 to cond-pagto.num-parcelas:

                        if da-data[i-ind] < today then 
                            assign da-data[i-ind] = tt-documEst-aux.dt-emissao.
        
                        create tt-dupli-apagar-cex.
                        assign tt-dupli-apagar-cex.cod-emitente      = tt-docum-est-cex.cod-emitente
                               tt-dupli-apagar-cex.nat-operacao      = tt-documEst-aux.nat-operacao
                               tt-dupli-apagar-cex.serie-docto       = tt-documEst-aux.serie-docto                               
                               tt-dupli-apagar-cex.nro-docto         = tt-documEst-aux.nro-docto                               
                               tt-dupli-apagar-cex.cod-emitente-desp = tt-docum-est-cex.cod-emitente-desp                
                               tt-dupli-apagar-cex.cod-desp          = tt-docum-est-cex.cod-desp
                               tt-dupli-apagar-cex.mo-codigo         = tt-desp-totais.mo-codigo                       
                               tt-dupli-apagar-cex.dt-vencim         = da-data[i-ind]
                               tt-dupli-apagar-cex.tp-despesa        = &if '{&bf_mat_versao_ems}' >= '2.062' &then
                                                                       tt-desp-totais.tp-despesa                 
                                                                       &else                                     
                                                                       emitente.tp-desp-padrao                   
                                                                       &endif                                    
                               tt-dupli-apagar-cex.vl-a-pagar        = round(de-val-desp,2) 
                                                                     * cond-pagto.per-pg-dup[i-ind] / 100                                                             
                               tt-dupli-apagar-cex.vl-a-pagar-mo     = round(de-val-desp-mo,2) 
                                                                     * cond-pagto.per-pg-dup[i-ind] / 100
                               tt-dupli-apagar-cex.cod-esp           = c-espec-padr.                               
                    end.
                end.
           end.            
       end.  
    end. /*for each tt-item-doc-est-cex, qndo for >= 204*/
    

    /*
    ** Ajuste das diferen‡as do total das duplicatas de material com o valor do material
    */
    assign de-dup-tot        = 0
           de-dup-tot-mo     = 0
           de-dup-tot-aux    = 0
           de-dup-tot-mo-aux = 0.

    for each tt-dupli-apagar
      where tt-dupli-apagar.mo-codigo = i-moeda-material no-lock:
        assign de-dup-tot    = de-dup-tot 
                             + tt-dupli-apagar.vl-a-pagar
               de-dup-tot-mo = de-dup-tot-mo
                             + tt-dupli-apagar.vl-a-pagar-mo.
    end.
    
    /*duplicatas para o fornecedor da mercadoria porem moedas diferentes = despesa x mercadoria*/
    for each tt-dupli-apagar
       where tt-dupli-apagar.mo-codigo = tt-desp-totais.mo-codigo no-lock:
        assign de-dup-tot-aux    = de-dup-tot-aux
                                 + tt-dupli-apagar.vl-a-pagar
               de-dup-tot-mo-aux = de-dup-tot-mo-aux
                                 + tt-dupli-apagar.vl-a-pagar-mo.
    end.

    
    if i-moeda-material   = tt-desp-totais.mo-codigo then do:
       if de-tot-vl-docto    <> de-dup-tot then do:
           find last tt-dupli-apagar no-error.
           assign tt-dupli-apagar.vl-a-pagar = tt-dupli-apagar.vl-a-pagar
                                             + (de-tot-vl-docto - de-dup-tot).
       end.

       if de-tot-vl-docto-mo <> de-dup-tot-mo then do:
           find last tt-dupli-apagar no-error.
           assign tt-dupli-apagar.vl-a-pagar-mo = tt-dupli-apagar.vl-a-pagar-mo
                                                + (de-tot-vl-docto-mo - de-dup-tot-mo).
                                                
       end.
    end.
    else do:
         if de-tot-vl-docto-aux    <> de-dup-tot-aux then do:
            find last tt-dupli-apagar no-error.
            assign tt-dupli-apagar.vl-a-pagar = tt-dupli-apagar.vl-a-pagar
                                              + (de-tot-vl-docto-aux - de-dup-tot-aux).
         end.

         if de-tot-vl-docto-mo-aux <> de-dup-tot-mo-aux then do:
             find last tt-dupli-apagar no-error.
             assign tt-dupli-apagar.vl-a-pagar-mo = tt-dupli-apagar.vl-a-pagar-mo
                                                  + (de-tot-vl-docto-mo-aux - de-dup-tot-mo-aux).
                                                               
         end.
    end.


    /* 
    ** Ajuste das diferen‡as do total das duplicatas de despesas com o valor da despesa
    */
    assign de-dup-tot    = 0
           de-dup-tot-mo = 0.    
    for each tt-dupli-apagar-cex where
        tt-dupli-apagar-cex.serie-docto       = tt-documEst-aux.serie-docto and
        tt-dupli-apagar-cex.nro-docto         = tt-documEst-aux.nro-docto and 
        tt-dupli-apagar-cex.cod-emitente      = tt-docum-est-cex.cod-emitente and
        tt-dupli-apagar-cex.nat-operacao      = tt-documEst-aux.nat-operacao and
        tt-dupli-apagar-cex.cod-desp          = tt-docum-est-cex.cod-desp and
        tt-dupli-apagar-cex.cod-emitente-desp = tt-docum-est-cex.cod-emitente-desp no-lock:

        assign de-dup-tot    = de-dup-tot 
                             + tt-dupli-apagar-cex.vl-a-pagar 
               de-dup-tot-mo = de-dup-tot-mo 
                             + tt-dupli-apagar-cex.vl-a-pagar-mo.

    end.

    if tt-docum-est-cex.val-desp <> de-dup-tot then do:
        find last tt-dupli-apagar-cex where
            tt-dupli-apagar-cex.serie-docto       = tt-documEst-aux.serie-docto and            
            tt-dupli-apagar-cex.nro-docto         = tt-documEst-aux.nro-docto and                                
            tt-dupli-apagar-cex.cod-emitente      = tt-docum-est-cex.cod-emitente and
            tt-dupli-apagar-cex.nat-operacao      = tt-documEst-aux.nat-operacao and
            tt-dupli-apagar-cex.cod-desp          = tt-docum-est-cex.cod-desp and
            tt-dupli-apagar-cex.cod-emitente-desp = tt-docum-est-cex.cod-emitente-desp no-lock no-error.        
        if avail tt-dupli-apagar-cex then
            assign tt-dupli-apagar-cex.vl-a-pagar = tt-dupli-apagar-cex.vl-a-pagar
                                                  + ( tt-docum-est-cex.val-desp - de-dup-tot ).
    end.

    if de-desp-tot-val-desp-mo <> de-dup-tot-mo then do:
        
        find last tt-dupli-apagar-cex where
            tt-dupli-apagar-cex.serie-docto       = tt-documEst-aux.serie-docto and            
            tt-dupli-apagar-cex.nro-docto         = tt-documEst-aux.nro-docto and                                
            tt-dupli-apagar-cex.cod-emitente      = tt-docum-est-cex.cod-emitente and
            tt-dupli-apagar-cex.nat-operacao      = tt-documEst-aux.nat-operacao and
            tt-dupli-apagar-cex.cod-desp          = tt-docum-est-cex.cod-desp and
            tt-dupli-apagar-cex.cod-emitente-desp = tt-docum-est-cex.cod-emitente-desp no-lock no-error.
        if avail tt-dupli-apagar-cex then            
            assign tt-dupli-apagar-cex.vl-a-pagar-mo = tt-dupli-apagar-cex.vl-a-pagar-mo
                                                     + ( de-desp-tot-val-desp-mo - de-dup-tot-mo ).

    end.
    
end.

/* Correcao dos valores criados para a duplicata de despesas */
/* Organiza conforme fornecedor e data de vencimento */
for each tt-dupli-apagar-cex no-lock where
         tt-dupli-apagar-cex.cod-desp <> i-desp-ii-i50
    break  
    &IF '{&bf_mat_versao_ems}' < '2.062' &THEN
            by tt-dupli-apagar-cex.cod-emitente-desp
            by tt-dupli-apagar-cex.mo-codigo
            by tt-dupli-apagar-cex.dt-vencim
                by tt-dupli-apagar-cex.cod-esp
            &if '{&bf_mat_versao_ems}' >= '2.062' &then
            by tt-dupli-apagar-cex.tp-despesa
            &endif 
    &ELSE
            by tt-dupli-apagar-cex.cod-esp
            by tt-dupli-apagar-cex.cod-emitente-desp
            by tt-dupli-apagar-cex.dt-vencim
            by tt-dupli-apagar-cex.tp-despesa
            by tt-dupli-apagar-cex.mo-codigo
    &ENDIF
    :

    /* 
    ** Considera duplicatas de imposto separadamente
    */ 

    &IF '{&bf_mat_versao_ems}' < '2.062' &THEN
         if first-of(tt-dupli-apagar-cex.mo-codigo) then
             IF  FIRST-OF(tt-dupli-apagar-cex.cod-emitente-desp) then do:    
                 ASSIGN i-parcela = 0. 
                 for each tt-dupli-apagar no-lock
                 where tt-dupli-apagar.cod-emitente = tt-dupli-apagar-cex.cod-emitente-desp :
                      if INTEGER(tt-dupli-apagar.parcela) > i-parcela then
                          assign i-parcela = INTEGER(tt-dupli-apagar.parcela).
                 end.
             end.   
         
    &ELSE
         IF  i-cod-emitente-desp-ant = 0 THEN
             ASSIGN i-cod-emitente-desp-ant = tt-dupli-apagar-cex.cod-emitente-desp.

         IF  i-mo-codigo-ant = 0 THEN
             ASSIGN i-mo-codigo-ant = tt-dupli-apagar-cex.mo-codigo.

         if  tt-dupli-apagar-cex.cod-emitente-desp <> i-cod-emitente-desp-ant
         and tt-dupli-apagar-cex.mo-codigo         <> i-mo-codigo-ant then do:

              ASSIGN i-parcela = 0. 
              for each tt-dupli-apagar no-lock
              where tt-dupli-apagar.cod-emitente = tt-dupli-apagar-cex.cod-emitente-desp :
                   if INTEGER(tt-dupli-apagar.parcela) > i-parcela then
                       assign i-parcela = INTEGER(tt-dupli-apagar.parcela).
              end.      
              IF  tt-dupli-apagar-cex.cod-emitente-desp <> i-cod-emitente-desp-ant THEN
                  ASSIGN i-cod-emitente-desp-ant = tt-dupli-apagar-cex.cod-emitente-desp.
              IF  tt-dupli-apagar-cex.dt-vencim <> da-dt-vencto-ant THEN
                  ASSIGN da-dt-vencto-ant = tt-dupli-apagar-cex.dt-vencim.               
          end.   
    &ENDIF        
    
    IF 
        &IF '{&bf_mat_versao_ems}' < '2.062' &THEN
            first-of(tt-dupli-apagar-cex.mo-codigo)         or
            FIRST-OF(tt-dupli-apagar-cex.dt-vencim)         OR 
            FIRST-OF(tt-dupli-apagar-cex.cod-emitente-desp) OR 
            FIRST-OF(tt-dupli-apagar-cex.cod-esp)
        &ELSE
               first-of(tt-dupli-apagar-cex.cod-esp)
            or first-of(tt-dupli-apagar-cex.cod-emitente-desp)
            or first-of(tt-dupli-apagar-cex.dt-vencim)
            or first-of(tt-dupli-apagar-cex.tp-despesa)
            or first-of(tt-dupli-apagar-cex.mo-codigo)
        &ENDIF
        THEN
        ASSIGN de-total-dup    = 0
               de-total-dup-mo = 0
               i-parcela       = i-parcela + 1.
               
    assign de-total-dup    = de-total-dup 
                           + tt-dupli-apagar-cex.vl-a-pagar
           de-total-dup-mo = de-total-dup-mo 
                           + tt-dupli-apagar-cex.vl-a-pagar-mo. 
           
    IF  &IF '{&bf_mat_versao_ems}' < '2.062' &THEN
            last-of(tt-dupli-apagar-cex.mo-codigo) or
            LAST-OF(tt-dupli-apagar-cex.cod-esp) OR
            &if '{&bf_mat_versao_ems}' >= '2.062' &then
                last-of(tt-dupli-apagar-cex.tp-despesa) or
            &endif
            LAST-OF(tt-dupli-apagar-cex.dt-vencim) 
        &ELSE
               last-of(tt-dupli-apagar-cex.cod-esp)
            or last-of(tt-dupli-apagar-cex.cod-emitente-desp)
            or last-of(tt-dupli-apagar-cex.dt-vencim)
            or last-of(tt-dupli-apagar-cex.tp-despesa)
            or last-of(tt-dupli-apagar-cex.mo-codigo)
        &ENDIF
        THEN DO:
    

        /*--- testa erro de chave duplicada ---*/
        &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
            IF  CAN-FIND(FIRST {2} 
                         WHERE {2}.serie-docto       = tt-dupli-apagar-cex.serie-docto 
                           AND {2}.nro-docto         = tt-dupli-apagar-cex.nro-docto 
                           AND {2}.cod-emitente      = tt-dupli-apagar-cex.cod-emitente 
                           AND {2}.nat-operacao      = tt-dupli-apagar-cex.nat-operacao 
                           AND {2}.cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp 
                           AND {2}.parcela           = string(i-parcela)) THEN 
            REPEAT:
                ASSIGN i-parcela = i-parcela + 1.
                IF  NOT CAN-FIND(FIRST {2} 
                                 WHERE {2}.serie-docto       = tt-dupli-apagar-cex.serie-docto 
                                   AND {2}.nro-docto         = tt-dupli-apagar-cex.nro-docto 
                                   AND {2}.cod-emitente      = tt-dupli-apagar-cex.cod-emitente 
                                   AND {2}.nat-operacao      = tt-dupli-apagar-cex.nat-operacao 
                                   AND {2}.cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp 
                                   AND {2}.parcela           = string(i-parcela)) 
                OR  i-parcela > 9999 THEN 
                    LEAVE.
            END.
        &ENDIF  

        find {2} where 
            {2}.serie-docto       = tt-dupli-apagar-cex.serie-docto and            
            {2}.nro-docto         = tt-dupli-apagar-cex.nro-docto and                        
            {2}.cod-emitente      = tt-dupli-apagar-cex.cod-emitente and
            {2}.nat-operacao      = tt-dupli-apagar-cex.nat-operacao and
            {2}.mo-codigo         = tt-dupli-apagar-cex.mo-codigo and
            &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
            {2}.tp-despesa         = tt-dupli-apagar-cex.tp-despesa and
            {2}.cod-esp            = tt-dupli-apagar-cex.cod-esp    and
            &ENDIF
            {2}.cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp and
            {2}.parcela           = string(i-parcela)
            exclusive-lock no-error.
        

        if not avail {2} then do:

            create {2}.
            assign {2}.cod-emitente      = tt-dupli-apagar-cex.cod-emitente
                   {2}.dt-vencim         = tt-dupli-apagar-cex.dt-vencim
                   {2}.nat-operacao      = tt-dupli-apagar-cex.nat-operacao
                   {2}.nro-docto         = tt-dupli-apagar-cex.nro-docto
                   {2}.cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp                   
                   {2}.parcela           = string(i-parcela)
                   {2}.serie-docto       = tt-dupli-apagar-cex.serie-docto
                   {2}.nr-duplic         = tt-dupli-apagar-cex.nro-docto
                   {2}.tp-despesa        = tt-dupli-apagar-cex.tp-despesa
                   {2}.cod-esp           = tt-dupli-apagar-cex.cod-esp
                   {2}.mo-codigo         = tt-dupli-apagar-cex.mo-codigo
                   {2}.dt-emissao        = tt-documEst-aux.dt-emissao
                   {2}.dt-trans          = tt-documEst-aux.dt-trans.
        end.
        
        assign {2}.vl-a-pagar-mo = {2}.vl-a-pagar-mo
                                 + de-total-dup-mo
               {2}.vl-a-pagar    = {2}.vl-a-pagar
                                 + de-total-dup.
        release {2}.
    end.
end.

/* Exclusivo para duplicatas de despesa */
/* Correcao dos valores criados para a duplicata de despesas */
/* Organiza conforme fornecedor e data de vencimento */
FIND FIRST tt-dupli-apagar-cex 
     WHERE tt-dupli-apagar-cex.cod-desp = i-desp-ii-i50 NO-LOCK NO-ERROR.
IF AVAIL tt-dupli-apagar-cex THEN DO:
    
   ASSIGN i-parcela        = 0
          de-total-dup     = 0
          de-total-dup-mo  = 0.
   
   /* find last nÆo traz o valor correto porque o campo parcela ‚ char */       
   for each {2} 
      where {2}.serie-docto       = tt-dupli-apagar-cex.serie-docto 
        and {2}.nro-docto         = tt-dupli-apagar-cex.nro-docto 
        and {2}.cod-emitente      = tt-dupli-apagar-cex.cod-emitente 
        AND {2}.nat-operacao      = tt-dupli-apagar-cex.nat-operacao 
        AND {2}.cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp NO-LOCK:
      if INTEGER({2}.parcela) > i-parcela then
          ASSIGN i-parcela = INTEGER({2}.parcela).
   end.
       
   if i-parcela = 0 then do:
       
      /* find last nÆo traz o valor correto porque o campo parcela ‚ char */ 
      for each tt-dupli-apagar no-lock
          where tt-dupli-apagar.cod-emitente = tt-dupli-apagar-cex.cod-emitente-desp:
          if INTEGER(tt-dupli-apagar.parcela) > i-parcela then
              assign i-parcela = INTEGER(tt-dupli-apagar.parcela).
      end.
   end.
END.

for each tt-dupli-apagar-cex no-lock
    WHERE tt-dupli-apagar-cex.cod-desp = i-desp-ii-i50
    break by tt-dupli-apagar-cex.dt-vencim:
    
    if  first-of(tt-dupli-apagar-cex.dt-vencim) then do:
        assign de-total-dup    = 0
               de-total-dup-mo = 0
               i-parcela       = i-parcela + 1.
    end.


    assign de-total-dup    = de-total-dup 
                           + tt-dupli-apagar-cex.vl-a-pagar
           de-total-dup-mo = de-total-dup-mo 
                           + tt-dupli-apagar-cex.vl-a-pagar-mo. 
                           

    if  last-of(tt-dupli-apagar-cex.dt-vencim) then do:
    
        find {2} where 
             {2}.serie-docto       = tt-dupli-apagar-cex.serie-docto and            
             {2}.nro-docto         = tt-dupli-apagar-cex.nro-docto and                        
             {2}.cod-emitente      = tt-dupli-apagar-cex.cod-emitente and
             {2}.nat-operacao      = tt-dupli-apagar-cex.nat-operacao and
             {2}.cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp and
             {2}.mo-codigo         = tt-dupli-apagar-cex.mo-codigo and
             {2}.parcela           = string(i-parcela)
             exclusive-lock no-error.
        
        if not avail {2} then do:
            create {2}.
            assign {2}.cod-emitente      = tt-dupli-apagar-cex.cod-emitente
                   {2}.dt-vencim         = tt-dupli-apagar-cex.dt-vencim
                   {2}.nat-operacao      = tt-dupli-apagar-cex.nat-operacao
                   {2}.nro-docto         = tt-dupli-apagar-cex.nro-docto
                   {2}.cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp                   
                   {2}.parcela           = string(i-parcela)
                   {2}.serie-docto       = tt-dupli-apagar-cex.serie-docto
                   {2}.nr-duplic         = tt-dupli-apagar-cex.nro-docto
                   {2}.tp-despesa        = tt-dupli-apagar-cex.tp-despesa
                   {2}.cod-esp           = tt-dupli-apagar-cex.cod-esp
                   {2}.mo-codigo         = tt-dupli-apagar-cex.mo-codigo
                   {2}.dt-emissao        = tt-documEst-aux.dt-emissao
                   {2}.dt-trans          = tt-documEst-aux.dt-trans.
        end.
        
        assign {2}.vl-a-pagar-mo = {2}.vl-a-pagar-mo
                                 + de-total-dup-mo
               {2}.vl-a-pagar    = {2}.vl-a-pagar
                                 + de-total-dup.                                

        release {2}.                         
    end.
end.

IF VALID-HANDLE(h-bocx407) THEN DO:
    DELETE PROCEDURE h-bocx407.
    ASSIGN h-bocx407 = ?.
END.                               

/* im7777.i3 */
