/*****************************************************************************
***
*** app/apapi018.i3 - pi-cancela-ir.
*** 
*****************************************************************************/

for each b-tit-ap exclusive-lock
   where b-tit-ap.ep-codigo   = tit-ap.ep-codigo
   and   b-tit-ap.cod-fornec  = tit-ap.cod-fornec
   and   b-tit-ap.cod-estabel = tit-ap.cod-estabel
   and   b-tit-ap.esp-ant     = tit-ap.cod-esp
   and   b-tit-ap.serie-ant   = tit-ap.serie
   and   b-tit-ap.docto-ant   = tit-ap.nr-docto
   and   b-tit-ap.parc-ant    = tit-ap.parcela
   and  (b-tit-ap.tipo        = 8
   or    b-tit-ap.tipo        = 1):

   if  b-tit-ap.tipo <> 8
   and b-tit-ap.tipo <> 1 then
       next.     
                        
   /*--- Tabela Progressiva ---*/
   {app/apapi018.i6 b-tit-ap}
        
   assign da-data  = (if  b-tit-ap.dt-prev-pag <> ? 
                      then b-tit-ap.dt-prev-pag
                      else b-tit-ap.dt-vencimen)
          da-fluxo = b-tit-ap.dt-fluxo.

   for each emite-ap use-index codigo
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
           and   che-emit.dt-emissao  = mov-ap.dt-transacao exclusive-lock no-error.
       if  avail che-emit then do:
           assign che-emit.cancelado = yes.
       end.

       for each tit-conta-ap
           where tit-conta-ap.ep-codigo   = mov-ap.ep-codigo
           and   tit-conta-ap.cod-estabel = mov-ap.cod-estabel
           and   tit-conta-ap.cod-esp     = mov-ap.cod-esp
           and   tit-conta-ap.serie       = mov-ap.serie
           and   tit-conta-ap.nr-docto    = mov-ap.nr-docto
           and   tit-conta-ap.parcela     = mov-ap.parcela
           and   tit-conta-ap.cod-fornec  = mov-ap.cod-fornec exclusive-lock:
           delete tit-conta-ap.  
       end.

       find b-mov-ap where rowid(b-mov-ap) = rowid(mov-ap) exclusive-lock no-error.

       if  mov-ap.transacao = 2 then do:
           {app/ap9100.i2}
           assign tt-integ-ap.tt-row-tit-ap  = rowid(b-tit-ap)
                  tt-integ-ap.tt-row-mov-ap  = rowid(mov-ap)
                  tt-integ-ap.tt-ge0102b     = yes
                  tt-integ-ap.tt-ge0102g     = yes
                  tt-integ-ap.tt-cb0201a     = yes
                  tt-integ-ap.tt-op-ge0102b  = 6
                  tt-integ-ap.tt-op-ge0102g  = 6
                  tt-integ-ap.tt-op-cb0201a  = 6.
           raw-transfer tt-integ-ap to raw-integracao.
           run app/ap9100.p (input raw-integracao, input-output table tt-erro).
       end.

       if  mov-ap.transacao = 5 and mov-ap.esp-ant <> "" then do:
           case b-tit-ap.tipo:
               when 8 then do:
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
               when 1 then do:
                   find first b1-tit-ap
                        where b1-tit-ap.ep-codigo  = mov-ap.ep-codigo
                        and   b1-tit-ap.cod-estab  = mov-ap.cod-estab
                        and   b1-tit-ap.cod-esp    = mov-ap.esp-ant
                        and   b1-tit-ap.serie      = mov-ap.serie-ant
                        and   b1-tit-ap.cod-fornec = mov-ap.fornec-ant
                        and   b1-tit-ap.nr-docto   = mov-ap.docto-ant
                        and   b1-tit-ap.parcela    = mov-ap.parc-ant
                        exclusive-lock no-error.
                   if avail b1-tit-ap then do:
                       assign b1-tit-ap.vl-ir-antec = b1-tit-ap.vl-ir-antec + mov-ap.vl-antecip.
                   end.
               end.        
           end case.
       end.

       find b-mov-ap where rowid(b-mov-ap) = rowid(mov-ap) exclusive-lock no-error.

       delete b-mov-ap.    

   end.

   create tt-tit-ap.
   assign tt-tit-ap.ep-codigo   = b-tit-ap.ep-codigo
          tt-tit-ap.cod-estabel = b-tit-ap.cod-estabel
          tt-tit-ap.cod-esp     = b-tit-ap.cod-esp
          tt-tit-ap.serie       = b-tit-ap.serie
          tt-tit-ap.nr-docto    = b-tit-ap.nr-docto
          tt-tit-ap.parcela     = b-tit-ap.parcela
          tt-tit-ap.cod-fornec  = b-tit-ap.cod-fornec
          tt-tit-ap.valor-saldo = b-tit-ap.valor-saldo
          tt-tit-ap.vl-original = b-tit-ap.vl-original.

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
        where dirf-ap.ep-codigo    = b-tit-ap.ep-codigo
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

   /*---- Elimina Impostos do T¡tulo ----*/
   for each impto-tit-ap exclusive-lock
       where impto-tit-ap.ep-codigo   = tit-ap.ep-codigo
       and   impto-tit-ap.cod-estabel = tit-ap.cod-estabel
       and   impto-tit-ap.cod-fornec  = tit-ap.cod-fornec
       and   impto-tit-ap.serie       = tit-ap.serie
       and   impto-tit-ap.cod-esp     = tit-ap.cod-esp
       and   impto-tit-ap.nr-docto    = tit-ap.nr-docto
       and   impto-tit-ap.parcela     = tit-ap.parcela:
       delete impto-tit-ap validate (true,"").
   end.

   /*---- Elimina Autoriza‡äes Pagamento ---*/
   for each usuar-autoriza-tit use-index codigo
       where usuar-autoriza-tit.ep-codigo    = tit-ap.ep-codigo
       and   usuar-autoriza-tit.nr-bordero   = 0
       and   usuar-autoriza-tit.cod-portador = 0
       and   usuar-autoriza-tit.cod-estabel  = tit-ap.cod-estabel
       and   usuar-autoriza-tit.cod-fornec   = tit-ap.cod-fornec
       and   usuar-autoriza-tit.cod-esp      = tit-ap.cod-esp
       and   usuar-autoriza-tit.serie        = tit-ap.serie
       and   usuar-autoriza-tit.nr-docto     = tit-ap.nr-docto
       and   usuar-autoriza-tit.parcela      = tit-ap.parcela exclusive-lock:
       delete usuar-autoriza-tit validate (true,"").
   end.                   
   
   delete b-tit-ap.            
   
end.

/* Fim de Include */
