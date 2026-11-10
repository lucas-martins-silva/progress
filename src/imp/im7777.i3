/************************************************************************
**
** imp/im7777.i3 - Cria‡Æo das duplicatas das despesas.
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


&GLOBAL-DEFINE vcod-espec-padr desp-imp.cod-espec-padr

for each tt-dupli-apagar-cex:
    delete tt-dupli-apagar-cex.
end.

for each docum-est-cex 
    where docum-est-cex.serie-docto   = tt-docum-est.serie-docto
      and docum-est-cex.nro-docto     = tt-docum-est.nro-docto       
      and docum-est-cex.cod-emitente  = tt-docum-est.cod-emitente
      and docum-est-cex.nat-operacao  = tt-docum-est.nat-operacao
       no-lock:
       
    /* Testa se despesa incide no valor da duplicata */
    find desp-imp
        where desp-imp.cod-desp = docum-est-cex.cod-desp no-lock no-error.
    if avail desp-imp and not desp-imp.inc-val-duplic then
        next.
       
    assign l-continua = yes.
       
    find emitente
        where emitente.cod-emitente = docum-est-cex.cod-emitente-desp no-lock no-error.
    
    assign de-desp-tot-val-desp-mo = 0.
    for each tt-desp-totais
        where tt-desp-totais.cod-desp = docum-est-cex.cod-desp:
        assign de-desp-tot-val-desp-mo = de-desp-tot-val-desp-mo + tt-desp-totais.val-desp-mo.
    end.
    
    find first tt-desp-totais
        where tt-desp-totais.cod-desp = docum-est-cex.cod-desp no-error.
        
    if not avail tt-desp-totais then
        next.        

    IF  AVAIL param-imp THEN
        ASSIGN c-espec-padr = param-imp.esp-tit-rec.

    FOR FIRST desp-imp NO-LOCK
        WHERE desp-imp.cod-desp = docum-est-cex.cod-desp
          AND {&vcod-espec-padr} <> "":
    
        ASSIGN c-espec-padr = {&vcod-espec-padr}.
    END.
    
    for each item-doc-est-cex
       where item-doc-est-cex.serie-docto       = docum-est-cex.serie-docto
         and item-doc-est-cex.nro-docto         = docum-est-cex.nro-docto
         and item-doc-est-cex.cod-emitente      = docum-est-cex.cod-emitente
         and item-doc-est-cex.nat-operacao      = docum-est-cex.nat-operacao
         and item-doc-est-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp          
         and item-doc-est-cex.cod-desp          = docum-est-cex.cod-desp
         no-lock:

        find {1} 
            where {1}.serie-docto   = item-doc-est-cex.serie-docto
              and {1}.nro-docto     = item-doc-est-cex.nro-docto
              and {1}.cod-emitente  = item-doc-est-cex.cod-emitente
              and {1}.nat-operacao  = item-doc-est-cex.nat-operacao
              and {1}.sequencia     = item-doc-est-cex.sequencia no-lock no-error.             
              
        assign de-val-desp    = item-doc-est-cex.val-desp
               de-val-desp-mo = item-doc-est-cex.val-desp.
        
        if tt-desp-totais.mo-codigo <> 0 then do:
            if tt-nota.d-cotacao = 0 then
                run cdp/cd0812.p (input 0,
                                  input tt-desp-totais.mo-codigo,
                                  input de-val-desp,
                                  input tt-nota.da-cotacao,
                                  output de-val-desp-mo).
            else
                run cdp/cd0812a.p (input 0,
                                   input tt-desp-totais.mo-codigo,
                                   input de-val-desp,
                                   input tt-nota.d-cotacao,
                                   output de-val-desp-mo).
        end.
    
        find ordem-compra
            where ordem-compra.numero-ordem = {1}.numero-ordem no-lock no-error.
        
        /* 
        ** Verifica se a despesa possui o mesmo fornecedor do material
        ** se tiver, o valor da duplicata de despesa ‚ somado ao valor da duplicata do material e
        ** o valor ‚ rateado conforme condi‡Æo de pagamento do material 
        */
        find first tt-dupli-apagar 
            where tt-dupli-apagar.serie-docto  = tt-docum-est.serie-docto
              and tt-dupli-apagar.nro-docto    = tt-docum-est.nro-docto
              and tt-dupli-apagar.cod-emitente = docum-est-cex.cod-emitente-desp
              and tt-dupli-apagar.nat-operacao = tt-docum-est.nat-operacao
              and tt-dupli-apagar.mo-codigo    = tt-desp-totais.mo-codigo
              and tt-dupli-apagar.cod-esp      = c-espec-padr
              and tt-dupli-apagar.tp-despesa = tt-desp-totais.tp-despesa
              no-error.
              
        if avail tt-dupli-apagar then do:
           if docum-est-cex.cod-desp <> i-desp-ii-i50 then do: /* Quando for Imposto Importa‡Æo duplicata ‚ gerada separadamente */
              assign de-vl-docto-mo     = 0.
              if i-moeda-material = tt-desp-totais.mo-codigo then
                 assign de-tot-vl-docto    = de-tot-vl-docto + de-val-desp 
                        de-tot-vl-docto-mo = de-tot-vl-docto-mo + de-val-desp-mo.                                   
                   
              find historico-embarque 
                  where historico-embarque.cod-estabel   = tt-docum-est.cod-estabel
                    and historico-embarque.embarque      = tt-docum-est.embarque
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
                                where tt-dupli-apagar.serie-docto  = tt-docum-est.serie-docto
                                  and tt-dupli-apagar.nro-docto    = tt-docum-est.nro-docto
                                  and tt-dupli-apagar.cod-emitente = docum-est-cex.cod-emitente-desp
                                  and tt-dupli-apagar.nat-operacao = tt-docum-est.nat-operacao 
                                  and tt-dupli-apagar.mo-codigo    = tt-desp-totais.mo-codigo
                                  and tt-dupli-apagar.dt-vencim    = cond-especif.data-pagto[i-ind]
                                  and tt-dupli-apagar.tp-despesa   = tt-desp-totais.tp-despesa                                                                  
                                no-error.
                            if avail tt-dupli-apagar then do:
                                assign tt-dupli-apagar.vl-a-pagar  = tt-dupli-apagar.vl-a-pagar +
                                                                    (de-val-desp 
                                                                     * cond-especif.perc-pagto[i-ind]
                                                                     / 100).
                                                             
                                if i-moeda-material = tt-desp-totais.mo-codigo then do: 
                                   assign de-val-desp-mo = tt-dupli-apagar.vl-a-pagar / tt-nota.cotacao-dia.
                                   assign tt-dupli-apagar.vl-a-pagar-mo = de-val-desp-mo.
                                end.
                                else do:                                                                                                                                      
                                   find first tt-tot-desp-mo
                                        where tt-tot-desp-mo.mo-codigo = tt-desp-totais.mo-codigo no-error.
                                   if avail tt-tot-desp-mo then do:   
                        
                                      assign tt-tot-desp-mo.tot-vl-a-pagar    = tt-tot-desp-mo.tot-vl-a-pagar + de-val-desp.
                                      assign tt-dupli-apagar.vl-a-pagar       = tt-tot-desp-mo.tot-vl-a-pagar.
                        
                                      if  tt-desp-totais.mo-codigo <> 0 then do:
                                          if tt-nota.d-cotacao = 0 then
                                              run cdp/cd0812.p (input 0,
                                                                input tt-desp-totais.mo-codigo,
                                                                input tt-tot-desp-mo.tot-vl-a-pagar,
                                                                input tt-nota.da-cotacao,
                                                                output de-tot-vl-docto-mo-aux). 
                                          else
                                              run cdp/cd0812a.p (input 0,
                                                                 input tt-desp-totais.mo-codigo,
                                                                 input tt-tot-desp-mo.tot-vl-a-pagar,
                                                                 input tt-nota.d-cotacao,
                                                                 output de-tot-vl-docto-mo-aux).
                                          assign tt-tot-desp-mo.tot-vl-a-pagar-mo = de-tot-vl-docto-mo-aux.
                                      end.
                                      else 
                                          assign tt-tot-desp-mo.tot-vl-a-pagar-mo = tt-tot-desp-mo.tot-vl-a-pagar.  
                                   end.
                                   else do:
                                      create tt-tot-desp-mo.
                                      assign tt-tot-desp-mo.mo-codigo   = tt-desp-totais.mo-codigo
                                             tt-tot-desp-mo.tot-vl-a-pagar  =  de-val-desp.
                                      if  tt-desp-totais.mo-codigo <> 0 then do: 
                                          if tt-nota.d-cotacao = 0 then
                                              run cdp/cd0812.p (input 0,                                       
                                                                input tt-desp-totais.mo-codigo,                
                                                                input de-val-desp,                     
                                                                input tt-nota.da-cotacao,                      
                                                                output de-tot-vl-docto-mo-aux).  
                                          else
                                              run cdp/cd0812a.p (input 0,                                       
                                                                 input tt-desp-totais.mo-codigo,                
                                                                 input de-val-desp,                     
                                                                 input tt-nota.d-cotacao,                      
                                                                 output de-tot-vl-docto-mo-aux).    
                                            
                                          assign tt-tot-desp-mo.tot-vl-a-pagar-mo = de-tot-vl-docto-mo-aux.    
                                      end.                                                                 
                                      else                                                                 
                                          assign tt-tot-desp-mo.tot-vl-a-pagar-mo = de-val-desp. 
                                      assign de-tot-vl-docto-mo-aux = de-tot-vl-docto-aux.                    
                                   end. 
                                   assign tt-dupli-apagar.vl-a-pagar-mo = tt-tot-desp-mo.tot-vl-a-pagar-mo.                                                     
                                end.  
                            end.                                                                     
                        end.
                    end.
                 end.
              end.
              else do:               
                        
                  assign da-data    = today.               
                      
                  if not avail historico-embarque then
                      assign da-partida = tt-docum-est.dt-emissao.
                  else
                      assign da-partida = historico-embarque.dt-efetiva.
                      
                  {cdp/cd9020.i7 tt-docum-est.cod-estabel y}
                  
                  do  i-ind = 1 to cond-pagto.num-parcelas:
                  
                      if da-data[i-ind] < today then 
                          assign da-data[i-ind] = tt-docum-est.dt-emissao.                
                          
                      find first tt-dupli-apagar 
                          where tt-dupli-apagar.serie-docto  = tt-docum-est.serie-docto
                            and tt-dupli-apagar.nro-docto    = tt-docum-est.nro-docto
                            and tt-dupli-apagar.cod-emitente = docum-est-cex.cod-emitente-desp
                            and tt-dupli-apagar.nat-operacao = tt-docum-est.nat-operacao 
                            and tt-dupli-apagar.mo-codigo    = tt-desp-totais.mo-codigo
                            and tt-dupli-apagar.dt-vencim    = da-data[i-ind]                          
                            and tt-dupli-apagar.tp-despesa = tt-desp-totais.tp-despesa
                            no-error.
                      if avail tt-dupli-apagar then do:
                                                     
                         assign tt-dupli-apagar.vl-a-pagar  = tt-dupli-apagar.vl-a-pagar              
                                                            + (de-val-desp                            
                                                            * cond-pagto.per-pg-dup[i-ind]            
                                                            / 100).  
                                                               
                         if i-moeda-material = tt-desp-totais.mo-codigo then do:                                                                       
                            assign de-val-desp-mo = tt-dupli-apagar.vl-a-pagar / tt-nota.cotacao-dia.    
                            assign tt-dupli-apagar.vl-a-pagar-mo = de-val-desp-mo.                       
                         end.                      
                         else do:                                                                                                                                      
                            find first tt-tot-desp-mo
                                 where tt-tot-desp-mo.mo-codigo = tt-desp-totais.mo-codigo no-error.
                            if avail tt-tot-desp-mo then do:   
                
                               assign tt-tot-desp-mo.tot-vl-a-pagar    = tt-tot-desp-mo.tot-vl-a-pagar + de-val-desp.
                               assign tt-dupli-apagar.vl-a-pagar       = tt-tot-desp-mo.tot-vl-a-pagar.
                
                               if  tt-desp-totais.mo-codigo <> 0 then do:
                                   if tt-nota.d-cotacao = 0 then
                                       run cdp/cd0812.p (input 0,
                                                         input tt-desp-totais.mo-codigo,
                                                         input tt-tot-desp-mo.tot-vl-a-pagar,
                                                         input tt-nota.da-cotacao,
                                                         output de-tot-vl-docto-mo-aux).            
                                   else
                                       run cdp/cd0812a.p (input 0,
                                                          input tt-desp-totais.mo-codigo,
                                                          input tt-tot-desp-mo.tot-vl-a-pagar,
                                                          input tt-nota.d-cotacao,
                                                          output de-tot-vl-docto-mo-aux).                      

                                   assign tt-tot-desp-mo.tot-vl-a-pagar-mo = de-tot-vl-docto-mo-aux.
                               end.
                               else 
                                   assign tt-tot-desp-mo.tot-vl-a-pagar-mo = tt-tot-desp-mo.tot-vl-a-pagar.  
                            end.
                            else do:
                               create tt-tot-desp-mo.
                               assign tt-tot-desp-mo.mo-codigo   = tt-desp-totais.mo-codigo
                                      tt-tot-desp-mo.tot-vl-a-pagar  =  de-val-desp.
                               if  tt-desp-totais.mo-codigo <> 0 then do:
                                   if tt-nota.d-cotacao = 0 then
                                       run cdp/cd0812.p (input 0,                                       
                                                         input tt-desp-totais.mo-codigo,                
                                                         input de-val-desp,                     
                                                         input tt-nota.da-cotacao,                      
                                                         output de-tot-vl-docto-mo-aux).
                                   else
                                       run cdp/cd0812a.p (input 0,                                       
                                                          input tt-desp-totais.mo-codigo,                
                                                          input de-val-desp,                     
                                                          input tt-nota.d-cotacao,                      
                                                          output de-tot-vl-docto-mo-aux).
                                                          
                                   assign tt-tot-desp-mo.tot-vl-a-pagar-mo = de-tot-vl-docto-mo-aux.                    
                               end.                                                                 
                               else                                                                 
                                   assign tt-tot-desp-mo.tot-vl-a-pagar-mo = de-val-desp. 
                               assign de-tot-vl-docto-mo-aux = de-tot-vl-docto-aux.                    
                            end. 
                            assign tt-dupli-apagar.vl-a-pagar-mo = tt-tot-desp-mo.tot-vl-a-pagar-mo.                                                     
                         end. 
                      end.
                  end.
              end.            
              assign l-continua = no.            
           end.
        end.
        else do:      
            /*duplicatas do fornecedor da mercadoria porem com moedas diferentes na despesa*/
            find first tt-dupli-apagar 
                 where tt-dupli-apagar.serie-docto  = tt-docum-est.serie-docto
                   and tt-dupli-apagar.nro-docto    = tt-docum-est.nro-docto
                   and tt-dupli-apagar.cod-emitente = docum-est-cex.cod-emitente-desp
                   and tt-dupli-apagar.nat-operacao = tt-docum-est.nat-operacao
                   AND tt-dupli-apagar.cod-esp      = c-espec-padr
                   no-error.
                   
            if  avail tt-dupli-apagar 
            and docum-est-cex.cod-desp <> i-desp-ii-i50 then do: /* Quando for Imposto Importa‡Æo duplicata ‚ gerada separadamente */
                if i-moeda-material = tt-desp-totais.mo-codigo then do:
                   assign de-vl-docto-mo     = 0
                          de-tot-vl-docto    = de-tot-vl-docto + de-val-desp 
                          de-tot-vl-docto-mo = de-tot-vl-docto-mo + de-val-desp-mo.                  
                end.
                else do:        
                                          
                   find first tt-tot-desp-mo
                        where tt-tot-desp-mo.mo-codigo = tt-desp-totais.mo-codigo no-error.
                   if avail tt-tot-desp-mo then do:   

                      assign tt-tot-desp-mo.tot-vl-a-pagar    = tt-tot-desp-mo.tot-vl-a-pagar + de-val-desp.   

                      if  tt-desp-totais.mo-codigo <> 0 then do:
                          if tt-nota.d-cotacao = 0 then
                              run cdp/cd0812.p (input 0,
                                                input tt-desp-totais.mo-codigo,
                                                input tt-tot-desp-mo.tot-vl-a-pagar,
                                                input tt-nota.da-cotacao,
                                                output de-tot-vl-docto-mo-aux). 
                          else
                              run cdp/cd0812a.p (input 0,
                                                 input tt-desp-totais.mo-codigo,
                                                 input tt-tot-desp-mo.tot-vl-a-pagar,
                                                 input tt-nota.d-cotacao,
                                                 output de-tot-vl-docto-mo-aux).                      
                          
                          assign tt-tot-desp-mo.tot-vl-a-pagar-mo = de-tot-vl-docto-mo-aux.
                      end.
                      else 
                          assign tt-tot-desp-mo.tot-vl-a-pagar-mo = tt-tot-desp-mo.tot-vl-a-pagar.  
                   end.
                   else do:
                      create tt-tot-desp-mo.
                      assign tt-tot-desp-mo.mo-codigo   = tt-desp-totais.mo-codigo
                             tt-tot-desp-mo.tot-vl-a-pagar  =  de-val-desp.
                      if  tt-desp-totais.mo-codigo <> 0 then do:  
                          if tt-nota.d-cotacao = 0 then
                              run cdp/cd0812.p (input 0,                                       
                                                input tt-desp-totais.mo-codigo,                
                                                input de-val-desp,                     
                                                input tt-nota.da-cotacao,                      
                                                output de-tot-vl-docto-mo-aux).    
                          else
                              run cdp/cd0812a.p (input 0,                                       
                                                 input tt-desp-totais.mo-codigo,                
                                                 input de-val-desp,                     
                                                 input tt-nota.d-cotacao,                      
                                                 output de-tot-vl-docto-mo-aux).    
                          
                          assign tt-tot-desp-mo.tot-vl-a-pagar-mo = de-tot-vl-docto-mo-aux.                    
                      end.                                                                 
                      else                                                                 
                          assign tt-tot-desp-mo.tot-vl-a-pagar-mo = de-val-desp. 
                      assign de-tot-vl-docto-mo-aux = de-tot-vl-docto-aux.    

                   end.                                                       
                end.
                       
                find historico-embarque 
                    where historico-embarque.cod-estabel   = tt-docum-est.cod-estabel
                      and historico-embarque.embarque      = tt-docum-est.embarque
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
                                where b-tt-dupli-apagar.serie-docto  = tt-docum-est.serie-docto
                                  and b-tt-dupli-apagar.nro-docto    = tt-docum-est.nro-docto
                                  and b-tt-dupli-apagar.cod-emitente = docum-est-cex.cod-emitente-desp
                                  and b-tt-dupli-apagar.nat-operacao = tt-docum-est.nat-operacao 
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
                                            tt-dupli-apagar.parcela       = string(int(i-parcela),"99")
                                            tt-dupli-apagar.serie-docto   = b-tt-dupli-apagar.serie-docto
                                            tt-dupli-apagar.nr-duplic     = b-tt-dupli-apagar.nro-docto
                                            tt-dupli-apagar.tp-despesa    = tt-desp-totais.tp-despesa                                                                                              
                                            tt-dupli-apagar.cod-esp       = b-tt-dupli-apagar.cod-esp
                                            tt-dupli-apagar.mo-codigo     = tt-desp-totais.mo-codigo.
        
                                     assign tt-dupli-apagar.vl-a-pagar  = (de-val-desp 
                                                                          * cond-especif.perc-pagto[i-ind]
                                                                          / 100).
                                                                          
                                     if  tt-desp-totais.mo-codigo <> 0 then
                                         if tt-nota.d-cotacao = 0 then
                                             run cdp/cd0812.p (input 0,
                                                               input tt-desp-totais.mo-codigo,
                                                               input tt-dupli-apagar.vl-a-pagar,
                                                               input tt-nota.da-cotacao,
                                                               output de-val-desp-mo).
                                         else
                                             run cdp/cd0812a.p (input 0,
                                                                input tt-desp-totais.mo-codigo,
                                                                input tt-dupli-apagar.vl-a-pagar,
                                                                input tt-nota.d-cotacao,
                                                                output de-val-desp-mo).
                                         
                                     else                       
                                        assign de-val-desp-mo = tt-dupli-apagar.vl-a-pagar. 
                                                 
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
                        assign da-partida = tt-docum-est.dt-emissao.
                    else
                        assign da-partida = historico-embarque.dt-efetiva.
                            
                    {cdp/cd9020.i7 tt-docum-est.cod-estabel w}
                       
                    do  i-ind = 1 to cond-pagto.num-parcelas:
                        if da-data[i-ind] < today then 
                            assign da-data[i-ind] = tt-docum-est.dt-emissao.   
                                         
                        find  first b-tt-dupli-apagar 
                              where b-tt-dupli-apagar.serie-docto  = tt-docum-est.serie-docto
                                and b-tt-dupli-apagar.nro-docto    = tt-docum-est.nro-docto
                                and b-tt-dupli-apagar.cod-emitente = docum-est-cex.cod-emitente-desp
                                and b-tt-dupli-apagar.nat-operacao = tt-docum-est.nat-operacao 
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
                                   tt-dupli-apagar.parcela       = string(int(i-parcela),"99")
                                   tt-dupli-apagar.serie-docto   = b-tt-dupli-apagar.serie-docto
                                   tt-dupli-apagar.nr-duplic     = b-tt-dupli-apagar.nro-docto
                                   tt-dupli-apagar.tp-despesa    = tt-desp-totais.tp-despesa                 
                                   tt-dupli-apagar.cod-esp       = b-tt-dupli-apagar.cod-esp
                                   tt-dupli-apagar.mo-codigo     = tt-desp-totais.mo-codigo.
        
                            assign tt-dupli-apagar.vl-a-pagar  = (de-val-desp
                                                                 * cond-pagto.per-pg-dup[i-ind]
                                                                 / 100).
                                      
                            if  tt-desp-totais.mo-codigo <> 0 then
                                if tt-nota.d-cotacao = 0 then
                                    run cdp/cd0812.p (input 0,
                                                      input tt-desp-totais.mo-codigo,
                                                      input tt-dupli-apagar.vl-a-pagar,
                                                      input tt-nota.da-cotacao,
                                                      output de-val-desp-mo).
                                else                      
                                    run cdp/cd0812a.p (input 0,
                                                       input tt-desp-totais.mo-codigo,
                                                       input tt-dupli-apagar.vl-a-pagar,
                                                       input tt-nota.d-cotacao,
                                                       output de-val-desp-mo).
                                    
                            else 
                                assign de-val-desp-mo = tt-dupli-apagar.vl-a-pagar.                             
                                
                            assign tt-dupli-apagar.vl-a-pagar-mo = de-val-desp-mo.
                            
                            release tt-dupli-apagar.
                        end.
                    end.
                end.            
                assign l-continua = no.            
            end.               
            else do: 
                find first historico-embarque 
                     where historico-embarque.cod-estabel   = tt-docum-est.cod-estabel
                       and historico-embarque.embarque      = tt-docum-est.embarque
                       and historico-embarque.cod-itiner    = tt-nota.cod-itiner
                       and historico-embarque.cod-pto-contr = tt-desp-totais.cod-pto-contr no-lock no-error.              

                find cond-pagto where 
                     cond-pagto.cod-cond-pag = docum-est-cex.cod-cond-pag no-lock no-error.
                         
                if  not avail cond-pagto then do:
                    find cond-especif-cex
                      where cond-especif-cex.num-pedido        = ordem-compra.num-pedido
                        and cond-especif-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
                        and cond-especif-cex.cod-desp          = docum-est-cex.cod-desp          no-lock no-error.
                    if  not avail cond-especif-cex then 
                        next.
                    else do:
                      /* Condicao especifica de pagamento */
                      do  i-ind = 1 to 6:
                          if  cond-especif-cex.data-pagto[i-ind] <> ? then do:                    
                              create tt-dupli-apagar-cex.
                              assign tt-dupli-apagar-cex.cod-emitente      = docum-est-cex.cod-emitente
                                     tt-dupli-apagar-cex.nat-operacao      = tt-docum-est.nat-operacao
                                     tt-dupli-apagar-cex.serie-docto       = tt-docum-est.serie-docto                               
                                     tt-dupli-apagar-cex.nro-docto         = tt-docum-est.nro-docto
                                     tt-dupli-apagar-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
                                     tt-dupli-apagar-cex.cod-desp          = docum-est-cex.cod-desp                               
                                     tt-dupli-apagar-cex.mo-codigo         = tt-desp-totais.mo-codigo
                                     tt-dupli-apagar-cex.dt-vencim         = cond-especif-cex.data-pagto[i-ind]
                                     tt-dupli-apagar-cex.tp-despesa        = tt-desp-totais.tp-despesa                                                                                                                                  
                                     tt-dupli-apagar-cex.vl-a-pagar        = de-val-desp
                                                                           * cond-especif-cex.perc-pagto[i-ind] / 100
                                     tt-dupli-apagar-cex.vl-a-pagar-mo     = de-val-desp-mo
                                                                           * cond-especif-cex.perc-pagto[i-ind] / 100
                                     tt-dupli-apagar-cex.cod-esp           = c-espec-padr.
                          end.
                      end.
                    end.
                end.
                else do:            
            
                    assign da-data    = today.
                    
                    if not avail historico-embarque then
                        assign da-partida = tt-docum-est.dt-emissao.
                    else
                        assign da-partida = historico-embarque.dt-efetiva.
                                            
                    /* Condi‡Æo Pagamento Antecipada */
                    if da-partida < tt-docum-est.dt-emissao then
                        assign da-partida = tt-docum-est.dt-emissao.
                    
                    {cdp/cd9020.i7 tt-docum-est.cod-estabel x}
                                            
                    do  i-ind = 1 to cond-pagto.num-parcelas:
                    
                        if da-data[i-ind] < today then 
                            assign da-data[i-ind] = tt-docum-est.dt-emissao.
        
                        create tt-dupli-apagar-cex.
                        assign tt-dupli-apagar-cex.cod-emitente      = docum-est-cex.cod-emitente
                               tt-dupli-apagar-cex.nat-operacao      = tt-docum-est.nat-operacao
                               tt-dupli-apagar-cex.serie-docto       = tt-docum-est.serie-docto                               
                               tt-dupli-apagar-cex.nro-docto         = tt-docum-est.nro-docto                               
                               tt-dupli-apagar-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp                
                               tt-dupli-apagar-cex.cod-desp          = docum-est-cex.cod-desp
                               tt-dupli-apagar-cex.mo-codigo         = tt-desp-totais.mo-codigo                       
                               tt-dupli-apagar-cex.dt-vencim         = da-data[i-ind]
                               tt-dupli-apagar-cex.tp-despesa        = tt-desp-totais.tp-despesa                                                                                                                            
                               tt-dupli-apagar-cex.vl-a-pagar        = de-val-desp 
                                                                     * cond-pagto.per-pg-dup[i-ind] / 100                                                             
                               tt-dupli-apagar-cex.vl-a-pagar-mo     = de-val-desp-mo 
                                                                     * cond-pagto.per-pg-dup[i-ind] / 100
                               tt-dupli-apagar-cex.cod-esp           = c-espec-padr.
        
                    end.
                end.
            end.             
        end.  
    end. /*for each item-doc-est-cex, qndo for >= 204*/
    
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
           find last tt-dupli-apagar.
           assign tt-dupli-apagar.vl-a-pagar = tt-dupli-apagar.vl-a-pagar
                                             + (de-tot-vl-docto - de-dup-tot).
       end.

       if de-tot-vl-docto-mo <> de-dup-tot-mo then do:
           find last tt-dupli-apagar.
           assign tt-dupli-apagar.vl-a-pagar-mo = tt-dupli-apagar.vl-a-pagar-mo
                                                + (de-tot-vl-docto-mo - de-dup-tot-mo).
       end.
    end.
    else do:
         find first tt-tot-desp-mo
              where tt-tot-desp-mo.mo-codigo = tt-desp-totais.mo-codigo no-error.
         if avail tt-tot-desp-mo then 
            assign de-tot-vl-docto-aux    = tt-tot-desp-mo.tot-vl-a-pagar
                   de-tot-vl-docto-mo-aux = tt-tot-desp-mo.tot-vl-a-pagar-mo.    

         if de-tot-vl-docto-aux    <> de-dup-tot-aux then do:
            find last tt-dupli-apagar.
            assign tt-dupli-apagar.vl-a-pagar = tt-dupli-apagar.vl-a-pagar
                                              + (de-tot-vl-docto-aux - de-dup-tot-aux).
         end.

         if de-tot-vl-docto-mo-aux <> de-dup-tot-mo-aux then do:
             find last tt-dupli-apagar.
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
        tt-dupli-apagar-cex.serie-docto       = tt-docum-est.serie-docto and
        tt-dupli-apagar-cex.nro-docto         = tt-docum-est.nro-docto and 
        tt-dupli-apagar-cex.cod-emitente      = docum-est-cex.cod-emitente and
        tt-dupli-apagar-cex.nat-operacao      = tt-docum-est.nat-operacao and
        tt-dupli-apagar-cex.cod-desp          = docum-est-cex.cod-desp and
        tt-dupli-apagar-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp no-lock:

        assign de-dup-tot    = de-dup-tot 
                             + tt-dupli-apagar-cex.vl-a-pagar 
               de-dup-tot-mo = de-dup-tot-mo 
                             + tt-dupli-apagar-cex.vl-a-pagar-mo.
    end.

    if docum-est-cex.val-desp <> de-dup-tot then do:
        find last tt-dupli-apagar-cex where
            tt-dupli-apagar-cex.serie-docto       = tt-docum-est.serie-docto and            
            tt-dupli-apagar-cex.nro-docto         = tt-docum-est.nro-docto and                                
            tt-dupli-apagar-cex.cod-emitente      = docum-est-cex.cod-emitente and
            tt-dupli-apagar-cex.nat-operacao      = tt-docum-est.nat-operacao and
            tt-dupli-apagar-cex.cod-desp          = docum-est-cex.cod-desp and
            tt-dupli-apagar-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp no-lock no-error.        
        if avail tt-dupli-apagar-cex then
            assign tt-dupli-apagar-cex.vl-a-pagar = tt-dupli-apagar-cex.vl-a-pagar
                                                  + ( docum-est-cex.val-desp - de-dup-tot ).
    end.

    if de-desp-tot-val-desp-mo <> de-dup-tot-mo then do:
        
        find last tt-dupli-apagar-cex where
            tt-dupli-apagar-cex.serie-docto       = tt-docum-est.serie-docto and            
            tt-dupli-apagar-cex.nro-docto         = tt-docum-est.nro-docto and                                
            tt-dupli-apagar-cex.cod-emitente      = docum-est-cex.cod-emitente and
            tt-dupli-apagar-cex.nat-operacao      = tt-docum-est.nat-operacao and
            tt-dupli-apagar-cex.cod-desp          = docum-est-cex.cod-desp and
            tt-dupli-apagar-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp no-lock no-error.
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
            by tt-dupli-apagar-cex.cod-esp
            by tt-dupli-apagar-cex.cod-emitente-desp
            by tt-dupli-apagar-cex.dt-vencim
            by tt-dupli-apagar-cex.tp-despesa
            by tt-dupli-apagar-cex.mo-codigo:

    /* 
    ** Considera duplicatas de imposto separadamente
    */ 

    
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
    
    
    IF first-of(tt-dupli-apagar-cex.cod-esp)
        or first-of(tt-dupli-apagar-cex.cod-emitente-desp)
        or first-of(tt-dupli-apagar-cex.dt-vencim)
        or first-of(tt-dupli-apagar-cex.tp-despesa)
        or first-of(tt-dupli-apagar-cex.mo-codigo) THEN DO:
        
        if  (tt-nota.l-nf-simples-remessa and tt-nota.idi-nf-simples-remes = 2)
        or (not tt-nota.l-nf-simples-remessa and tt-nota.idi-nf-simples-remes = 1 and tt-nota.l-nf-ajuste) then do:
            for each embarq-import-docto 
               WHERE embarq-import-docto.cod-embarq = tt-docum-est.embarque
                 and embarq-import-docto.cod-estab  = tt-docum-est.cod-estabel no-lock:
                for each dupli-apagar fields(parcela) no-lock
                    where dupli-apagar.nro-docto    = embarq-import-docto.cod-docto 
                      and dupli-apagar.serie-docto  = embarq-import-docto.cod-ser-docto
                      and dupli-apagar.cod-emitente = embarq-import-docto.cdn-emitente 
                      and dupli-apagar.nat-operacao = embarq-import-docto.cod-natur-operac:              
                     if int(dupli-apagar.parcela) > i-parcela then
                         assign i-parcela = int(dupli-apagar.parcela).
                end. 
            
                for each dupli-apagar-cex fields(parcela) no-lock
                    where dupli-apagar-cex.nro-docto    = embarq-import-docto.cod-docto 
                      and dupli-apagar-cex.serie-docto  = embarq-import-docto.cod-ser-docto
                      and dupli-apagar-cex.cod-emitente = embarq-import-docto.cdn-emitente 
                      and dupli-apagar-cex.nat-operacao = embarq-import-docto.cod-natur-operac:             
                     if int(dupli-apagar-cex.parcela) > i-parcela then
                        assign i-parcela = int(dupli-apagar-cex.parcela).
                end.   
                /*Verifica nota complementar*/
                for each rat-docum fields(serie-docto nro-docto cod-emitente nat-operacao)
                    where rat-docum.nf-serie    = embarq-import-docto.cod-ser-docto
                      and rat-docum.nf-nro      = embarq-import-docto.cod-docto
                      and rat-docum.nf-emitente = embarq-import-docto.cdn-emitente
                      and rat-docum.nf-nat-oper = embarq-import-docto.cod-natur-operac no-lock use-index nf-docto:
                    for each dupli-apagar fields(parcela) no-lock
                        where dupli-apagar.nro-docto    = rat-docum.nro-docto 
                          and dupli-apagar.serie-docto  = rat-docum.serie-docto
                          and dupli-apagar.cod-emitente = rat-docum.cod-emitente 
                          and dupli-apagar.nat-operacao = rat-docum.nat-operacao:              
                         if int(dupli-apagar.parcela) > i-parcela then
                            assign i-parcela = int(dupli-apagar.parcela).
                    end.      
                
                    for each dupli-apagar-cex  fields(parcela) no-lock
                        where dupli-apagar-cex.nro-docto    = rat-docum.nro-docto 
                          and dupli-apagar-cex.serie-docto  = rat-docum.serie-docto
                          and dupli-apagar-cex.cod-emitente = rat-docum.cod-emitente 
                          and dupli-apagar-cex.nat-operacao = rat-docum.nat-operacao :
                         if int(dupli-apagar-cex.parcela) > i-parcela then
                            assign i-parcela = int(dupli-apagar-cex.parcela).         
                    end.    
                end.
            end.
        end.
        
        ASSIGN de-total-dup    = 0
               de-total-dup-mo = 0
               i-parcela       = i-parcela + 1.
        
    END.    

    assign de-total-dup    = de-total-dup 
                           + tt-dupli-apagar-cex.vl-a-pagar
           de-total-dup-mo = de-total-dup-mo 
                           + tt-dupli-apagar-cex.vl-a-pagar-mo. 
           
    IF  last-of(tt-dupli-apagar-cex.cod-esp)
        or last-of(tt-dupli-apagar-cex.cod-emitente-desp)
        or last-of(tt-dupli-apagar-cex.dt-vencim)
        or last-of(tt-dupli-apagar-cex.tp-despesa)
        or last-of(tt-dupli-apagar-cex.mo-codigo) THEN DO:
    

        /*--- testa erro de chave duplicada ---*/
        
        IF  CAN-FIND(FIRST {2} 
                     WHERE {2}.serie-docto       = tt-dupli-apagar-cex.serie-docto 
                       AND {2}.nro-docto         = tt-dupli-apagar-cex.nro-docto 
                       AND {2}.cod-emitente      = tt-dupli-apagar-cex.cod-emitente 
                       AND {2}.nat-operacao      = tt-dupli-apagar-cex.nat-operacao 
                       AND {2}.cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp 
                       AND {2}.parcela           = string(int(i-parcela),"99")) THEN 
        REPEAT:
            ASSIGN i-parcela = i-parcela + 1.
            IF  NOT CAN-FIND(FIRST {2} 
                             WHERE {2}.serie-docto       = tt-dupli-apagar-cex.serie-docto 
                               AND {2}.nro-docto         = tt-dupli-apagar-cex.nro-docto 
                               AND {2}.cod-emitente      = tt-dupli-apagar-cex.cod-emitente 
                               AND {2}.nat-operacao      = tt-dupli-apagar-cex.nat-operacao 
                               AND {2}.cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp 
                               AND {2}.parcela           = string(int(i-parcela),"99")) 
            OR  i-parcela > 9999 THEN 
                LEAVE.
        END.
          

        find {2} where 
            {2}.serie-docto       = tt-dupli-apagar-cex.serie-docto and            
            {2}.nro-docto         = tt-dupli-apagar-cex.nro-docto and                        
            {2}.cod-emitente      = tt-dupli-apagar-cex.cod-emitente and
            {2}.nat-operacao      = tt-dupli-apagar-cex.nat-operacao and
            {2}.mo-codigo         = tt-dupli-apagar-cex.mo-codigo and
            {2}.tp-despesa         = tt-dupli-apagar-cex.tp-despesa and
            {2}.cod-esp            = tt-dupli-apagar-cex.cod-esp    and
            {2}.cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp and
            {2}.parcela           = string(int(i-parcela),"99")
            exclusive-lock no-error.
        

        if not avail {2} then do:

            create {2}.
            assign {2}.cod-emitente      = tt-dupli-apagar-cex.cod-emitente
                   {2}.dt-vencim         = tt-dupli-apagar-cex.dt-vencim
                   {2}.nat-operacao      = tt-dupli-apagar-cex.nat-operacao
                   {2}.nro-docto         = tt-dupli-apagar-cex.nro-docto
                   {2}.cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp                   
                   {2}.parcela           = string(int(i-parcela),"99")
                   {2}.serie-docto       = tt-dupli-apagar-cex.serie-docto
                   {2}.nr-duplic         = tt-dupli-apagar-cex.nro-docto
                   {2}.tp-despesa        = tt-dupli-apagar-cex.tp-despesa
                   {2}.cod-esp           = tt-dupli-apagar-cex.cod-esp
                   {2}.mo-codigo         = tt-dupli-apagar-cex.mo-codigo
                   {2}.dt-emissao        = tt-docum-est.dt-emissao
                   {2}.dt-trans          = tt-docum-est.dt-trans.
        end.
        
        assign {2}.vl-a-pagar-mo = {2}.vl-a-pagar-mo
                                 + de-total-dup-mo
               {2}.vl-a-pagar    = {2}.vl-a-pagar
                                 + de-total-dup.

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
        AND {2}.nat-operacao      = tt-dupli-apagar-cex.nat-operacao NO-LOCK:
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
             {2}.parcela           = string(int(i-parcela),"99")
             exclusive-lock no-error.
        
        if not avail {2} then do:
            create {2}.
            assign {2}.cod-emitente      = tt-dupli-apagar-cex.cod-emitente
                   {2}.dt-vencim         = tt-dupli-apagar-cex.dt-vencim
                   {2}.nat-operacao      = tt-dupli-apagar-cex.nat-operacao
                   {2}.nro-docto         = tt-dupli-apagar-cex.nro-docto
                   {2}.cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp                   
                   {2}.parcela           = string(int(i-parcela),"99")
                   {2}.serie-docto       = tt-dupli-apagar-cex.serie-docto
                   {2}.nr-duplic         = tt-dupli-apagar-cex.nro-docto
                   {2}.tp-despesa        = tt-dupli-apagar-cex.tp-despesa
                   {2}.cod-esp           = tt-dupli-apagar-cex.cod-esp
                   {2}.mo-codigo         = tt-dupli-apagar-cex.mo-codigo
                   {2}.dt-emissao        = tt-docum-est.dt-emissao
                   {2}.dt-trans          = tt-docum-est.dt-trans.
        end.
        
        assign {2}.vl-a-pagar-mo = {2}.vl-a-pagar-mo
                                 + de-total-dup-mo
               {2}.vl-a-pagar    = {2}.vl-a-pagar
                                 + de-total-dup.
                                 
    end.
end.


/* im7777.i3 */
