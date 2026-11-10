/*********************************************************************************
**
** IM0080.I - Include de geraá∆o dos t°tulos em AP.
**
**********************************************************************************/
find param-imp 
    where param-imp.cod-estabel = historico-embarque.cod-estabel no-lock no-error.
    
if  not avail param-imp then do:
    assign i-msg = 17371
           c-msg = "Hist¢rico do Embarque"
           c-char= ""
           c-embarque = historico-embarque.embarque
           c-cod-estabel = historico-embarque.cod-estabel.
    run pi-gera-erro.      
    next.
end.    

find first param-estoq  no-lock no-error.   

if  not avail param-estoq then do:
    assign i-msg = 5246
           c-msg = ""
           c-char= ""
           c-embarque = historico-embarque.embarque
           c-cod-estabel = historico-embarque.cod-estabel.
    run pi-gera-erro.      
end.

assign i-empresa-prin = param-global.empresa-prin.

FIND FIRST estabelec where
                    estabelec.cod-estabel = historico-embarque.cod-estabel no-lock no-error.
        assign i-empresa-ct = estabelec.ep-codigo when avail estabelec.

assign v_cod_cta_ctbl = param-imp.ct-transit-import.
run pi_busca_dados_cta_ctbl in h_api_cta (input        i-empresa-ct,    /* EMPRESA EMS2 */
                                         input        "",            /* PLANO DE CONTAS */
                                         input-output v_cod_cta_ctbl,     /* CONTA */
                                         input        today,              /* DATA TRANSACAO */   
                                         output       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                         output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                         output       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */
                                         output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                         output table tt_log_erro).       /* ERROS */ 

if v_cod_cta_ctbl = ""  then do: 
    assign i-msg = 17366
           c-msg = param-imp.ct-transit-import
           c-char= ""
           c-embarque = historico-embarque.embarque
           c-cod-estabel = historico-embarque.cod-estabel.
    run pi-gera-erro.      
    next.
end.    

ASSIGN v_cod_ccusto = param-imp.sc-transit-import.
run pi_busca_dados_ccusto in h_api_ccust (input  i-empresa-ct,                /* EMPRESA EMS2 */
                                           input  "",         /* CODIGO DO PLANO CCUSTO */
                                           input  v_cod_ccusto,            /* CCUSTO */
                                           input  today,              /* DATA DE TRANSACAO */
                                           output v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                           output table tt_log_erro). /* ERROS */
IF RETURN-VALUE = "NOK" THEN
    ASSIGN v_cod_ccusto = "".


FOR EACH tt-ordens:
    DELETE tt-ordens.
END.

FOR EACH tt-ordens-dupli:
    DELETE tt-ordens-dupli.
END.

for each ordens-embarque
    where ordens-embarque.cod-estabel = historico-embarque.cod-estabel
      and ordens-embarque.embarque    = historico-embarque.embarque no-lock:
     
    find processo-imp 
        where processo-imp.cod-estabel = historico-embarque.cod-estabel
          and processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp NO-LOCK no-error.
       
    if  not avail processo-imp then do:
        assign i-msg = 17364
               c-msg = ordens-embarque.nr-proc-imp
               c-char= historico-embarque.cod-estabel
               c-embarque = historico-embarque.embarque
               c-cod-estabel = historico-embarque.cod-estabel.
        run pi-gera-erro.
        next.
    end.

    find emitente
        where emitente.cod-emitente = processo-imp.cod-exportador no-lock no-error.
    
    if  not avail emitente then do:
        assign i-msg = 17373
               c-msg = string(processo-imp.cod-exportador)
               c-char= ""
               c-embarque = historico-embarque.embarque
               c-cod-estabel = historico-embarque.cod-estabel.               .
        run pi-gera-erro.      
        next.
    end.

    run pi-busca-portador-modalidade (buffer emitente,
                                      output i-portador-emit,
                                      output i-modalidade-emit).

    find pedido-compr
        where pedido-compr.num-pedido = processo-imp.num-pedido no-lock no-error.    
        
    if  avail pedido-compr then 
        find cond-pagto where cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag no-lock no-error.
    else 
        find cond-pagto where cond-pagto.cod-cond-pag = emitente.cod-cond-pag no-lock no-error.

    find ordem-compra
        where ordem-compra.numero-ordem = ordens-embarque.numero-ordem no-lock no-error.
    if avail ordem-compra then do:
        assign i-tipo-despesa = ordem-compra.tp-despesa.

        /* Cotaá∆o do item */
        find cotacao-item 
            where cotacao-item.numero-ordem = ordem-compra.numero-ordem
              and cotacao-item.cod-emitente = ordem-compra.cod-emitente
              and cotacao-item.it-codigo    = ordem-compra.it-codigo
              and cotacao-item.cot-aprovada no-lock no-error.
        if not avail cotacao-item then do:
           assign i-msg = 2
                  c-msg = string(ordens-embarque.numero-ordem)
                  c-char= string(historico-embarque.dt-efetiva)
                  c-embarque = historico-embarque.embarque
                  c-cod-estabel = historico-embarque.cod-estabel.
           
           run pi-gera-erro.                      
           next.
        end.
        else do:   
            assign de-preco-unit-mo = (cotacao-item.pre-unit-for * 100)
                        / (100 + cotacao-item.aliquota-ipi)
                   de-preco-unit = (cotacao-item.pre-unit-for * 100)
                        / (100 + cotacao-item.aliquota-ipi)
                   i-mo-codigo      = ordem-compra.mo-codigo.
        END.
    
        if i-mo-codigo <> 0  then do:
        
            find first cotacao
                where cotacao.mo-codigo   = i-mo-codigo
                  and cotacao.ano-periodo = string(year (historico-embarque.dt-efetiva),'9999')
                                          +  string(month(historico-embarque.dt-efetiva),'99') no-lock no-error.                                     
            if  not avail cotacao then do:       
                assign i-msg = 1847
                       c-msg = string(i-mo-codigo)
                       c-char= string(historico-embarque.dt-efetiva)
                       c-embarque = historico-embarque.embarque
                       c-cod-estabel = historico-embarque.cod-estabel.
                run pi-gera-erro.                      
                next.
            end.        
            /* 
            ** Conversío da moeda 
            */
            else do:
                assign de-valor-conver = 0.
                run cdp/cd0812.p (input  i-mo-codigo,
                                  input  0,
                                  input  de-preco-unit-mo,
                                  input  historico-embarque.dt-efetiva,
                                  output de-preco-unit).
                if de-preco-unit = 0 or
                   de-preco-unit = ? then 
                   assign de-preco-unit = de-preco-unit-mo.
            end.
        end.
        else
            assign de-preco-unit-mo = de-preco-unit.
        
        if  ordens-embarque.quantidade <> 0 then
            assign de-vl-docto-mo = de-vl-docto-mo 
                                  + ( de-preco-unit-mo * ordens-embarque.qt-do-forn )
                   de-vl-docto    = de-vl-docto + ( de-preco-unit * ordens-embarque.qt-do-forn )
                   de-vl-docto-mo-aux = ( de-preco-unit-mo * ordens-embarque.qt-do-forn )
                   de-vl-docto-aux = ( de-preco-unit * ordens-embarque.qt-do-forn ).                   

        /* Guarda os valores por ordem de compra para depois criar a  tt-ordem-dupli */
        find first tt-ordens where 
                   tt-ordens.numero-ordem = ordens-embarque.numero-ordem
                   no-error.
        if not avail tt-ordens then do:
            create tt-ordens.
            assign tt-ordens.numero-ordem = ordens-embarque.numero-ordem
                   tt-ordens.valor = de-vl-docto-aux
                   tt-ordens.valor-mo = de-vl-docto-mo-aux
                   de-vl-docto-aux = 0
                   de-vl-docto-mo-aux = 0.
        end.
        else do:
            assign tt-ordens.valor = tt-ordens.valor + de-vl-docto-aux
                   tt-ordens.valor-mo = tt-ordens.valor-mo + de-vl-docto-mo-aux
                   de-vl-docto-aux = 0
                   de-vl-docto-mo-aux = 0.
        end.           
    end.
    else do:
        assign i-msg = 123
               c-msg = string(ordens-embarque.numero-ordem)
               c-char= " "
               c-embarque = historico-embarque.embarque
               c-cod-estabel = historico-embarque.cod-estabel.
        run pi-gera-erro.
        next.
    end.
end.

&IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
    if c-nom-prog-dpc-mg97  <> "" or
       c-nom-prog-appc-mg97 <> "" or
       c-nom-prog-upc-mg97  <> "" then do:

        for each tt-epc
            where cod-event = "atualiza-valores-titulo":
            delete tt-epc.
        end.

        {include/i-epc200.i2 &CodEvent="'atualiza-valores-titulo'"
                             &CodParameter="'cod-estabel'"
                             &ValueParameter="historico-embarque.cod-estabel"}
                             
        {include/i-epc200.i2 &CodEvent="'atualiza-valores-titulo'"
                             &CodParameter="'embarque'"
                             &ValueParameter="historico-embarque.embarque"}
        
        {include/i-epc201.i "atualiza-valores-titulo"}

        find first tt-ordens no-error.
        if avail tt-ordens then do:

            for each tt-epc
                where tt-epc.cod-event = "atualiza-valores-titulo":

                case tt-epc.cod-parameter:
                    when "de-vl-docto-mo" then
                        assign tt-ordens.valor-mo = tt-ordens.valor-mo + dec(tt-epc.val-parameter).
                    when "de-vl-docto" then
                        assign tt-ordens.valor = tt-ordens.valor + dec(tt-epc.val-parameter).
                end case.
            end.

        end.

    end.
&ENDIF

&if defined(bf_mat_unidade_negocio) &then               
    if l-unid-neg then do:
       for each tt-ordens:
           FIND FIRST unid-neg-ordem 
                WHERE unid-neg-ordem.numero-ordem = tt-ordens.numero-ordem NO-LOCK NO-ERROR.
           IF NOT AVAIL unid-neg-ordem THEN DO:

               &if "{&bf_mat_versao_ems}" >= "2.062" &then
               &else
                   assign i-msg         = 28264
                          c-msg         = ""
                          c-char        = "  " + STRING(tt-ordens.numero-ordem)
                          c-embarque    = STRING(historico-embarque.embarque)
                          c-cod-estabel = STRING(historico-embarque.cod-estabel).
                   run pi-gera-erro.
                   NEXT bloco.
               &endif
           END.
       END.
    END.
&ENDIF


if  not avail cond-pagto and avail ordem-compra then do:
    
    find cond-especif where cond-especif.num-pedido = ordem-compra.num-pedido
        no-lock no-error.
    if  not avail cond-especif then do:

        assign i-msg = 15052
               c-msg = ""
               c-char= " "
               c-embarque = historico-embarque.embarque
               c-cod-estabel = historico-embarque.cod-estabel.
        run pi-gera-erro.                      
        next.
    end.
    else do:
        do  i-ind = 1 to 6:
            if  cond-especif.data-pagto[i-ind] <> ? then do:
                create tt-dupli.
                assign tt-dupli.dt-vencim     = cond-especif.data-pagto[i-ind]
                       tt-dupli.tp-despesa    = i-tipo-despesa
                       tt-dupli.vl-apagar     = de-vl-docto
                                              * cond-especif.perc-pagto[i-ind]
                                              / 100
                       tt-dupli.vl-apagar-mo  = de-vl-docto-mo
                                              * cond-especif.perc-pagto[i-ind]
                                              / 100.

                /* criaá∆o da tt-ordens-dupli por ordem de compra e data de vencimento,
                   para posteriormente fazer o rateio por unidade de neg¢cio */
                for each tt-ordens:
                   create tt-ordens-dupli.
                   assign tt-ordens-dupli.numero-ordem = tt-ordens.numero-ordem
                          tt-ordens-dupli.dt-vencim    = tt-dupli.dt-vencim
                          tt-ordens-dupli.vl-apagar    = tt-ordens.valor 
                                                       * cond-especif.perc-pagto[i-ind] / 100
                          tt-ordens-dupli.vl-apagar-mo = tt-ordens.valor-mo
                                                       * cond-especif.perc-pagto[i-ind] / 100. 
                   
                end.
            end.
        end.
    end.
end.

else do:

    assign da-data    = today
           da-partida = historico-embarque.dt-efetiva.
           
    {cdp/cd9020.i7 historico-embarque.cod-estabel}
    do  i-ind = 1 to cond-pagto.num-parcelas:    
        create tt-dupli.
        assign tt-dupli.dt-vencim    = da-data[i-ind]
               tt-dupli.tp-despesa   = i-tipo-despesa
               tt-dupli.vl-apagar    = de-vl-docto 
                                     * cond-pagto.per-pg-dup[i-ind] / 100
               tt-dupli.vl-apagar-mo = de-vl-docto-mo 
                                     * cond-pagto.per-pg-dup[i-ind] / 100.             

        /* criaá∆o da tt-ordens-dupli por ordem de compra e data de vencimento,
           para posteriormente fazer o rateio por unidade de neg¢cio */
        for each tt-ordens:
           create tt-ordens-dupli.
           assign tt-ordens-dupli.numero-ordem = tt-ordens.numero-ordem
                  tt-ordens-dupli.dt-vencim    = tt-dupli.dt-vencim
                  tt-ordens-dupli.vl-apagar    = tt-ordens.valor 
                                               * cond-pagto.per-pg-dup[i-ind] / 100
                  tt-ordens-dupli.vl-apagar-mo = tt-ordens.valor-mo
                                               * cond-pagto.per-pg-dup[i-ind] / 100.

        end.
    end.
end.

assign i-parcela = 0.
    
for each tt-dupli break by tt-dupli.dt-vencim:
    if  first-of(tt-dupli.dt-vencim) then do:
        assign de-total-dup    = 0
               de-total-dup-mo = 0
               i-parcela       = i-parcela + 1.
    end.
    
    assign de-total-dup    = de-total-dup + tt-dupli.vl-apagar
           de-total-dup-mo = de-total-dup-mo + tt-dupli.vl-apagar-mo.   

    if  last-of(tt-dupli.dt-vencim) then do:
        run pi-monta-referencia.
        
        find first lin-i-ap
            where lin-i-ap.ep-codigo   = i-empresa-prin
              and lin-i-ap.cod-estabel = historico-embarque.cod-estabel
              and lin-i-ap.referencia  = c-ref-aux
              and lin-i-ap.sequencia   = i-cont no-lock no-error.
        
        if  avail lin-i-ap then do:
            next.                      
        end.  
        find last tt-lin-i-ap use-index codigo
            where tt-lin-i-ap.ep-codigo = i-empresa-prin
            and   tt-lin-i-ap.referencia = "" no-lock no-error.            
            
        assign i-cont = if avail tt-lin-i-ap then tt-lin-i-ap.sequencia + 10 else 10.        
        
        find first cotacao 
            where cotacao.mo-codigo = i-mo-codigo
              and cotacao.ano-periodo = string(year (historico-embarque.dt-efetiva),'9999')        
                                      +  string(month(historico-embarque.dt-efetiva),'99') no-lock no-error.                                                                          
        
        /* busca o valor do lin-i-ap da tt-ordens-dupli, pois nela foi feito o acerto do res°duo por
        ordem de compra como Ç feito no recebimento por item*/

        ASSIGN c-esp-tit-transit = param-imp.esp-tit-transit.

        {include/i-epc200.i2 &CodEvent='"AlteraEspecieTitulo"'
                             &CodParameter='"cod-estabel"'
                             &ValueParameter="historico-embarque.cod-estabel"}

        {include/i-epc200.i2 &CodEvent='"AlteraEspecieTitulo"'
                             &CodParameter='"embarque"'
                             &ValueParameter="historico-embarque.embarque"}

        {include/i-epc200.i2 &CodEvent='"AlteraEspecieTitulo"'
                             &CodParameter='"cod-fornec"'
                             &ValueParameter="string(processo-imp.cod-exportador)"}
        
            
        {include/i-epc200.i2 &CodEvent='"AlteraEspecieTitulo"'
                             &CodParameter='"esp-tit-transit"'
                             &ValueParameter="c-esp-tit-transit"}
        /*Include i-epc201.i: Chamada do programa de EPC */
        {include/i-epc201.i "AlteraEspecieTitulo"}

        if c-nom-prog-dpc-mg97  <> "" or
           c-nom-prog-appc-mg97 <> "" or 
           c-nom-prog-upc-mg97  <> "" then do:

            find first tt-epc where 
                       tt-epc.cod-event = "AlteraEspecieTitulo" and
                       tt-epc.cod-parameter = "esp-tit-transit"
                       no-error.
            if avail tt-epc then
               assign c-esp-tit-transit = tt-epc.val-parameter.
            for each tt-epc:
                delete tt-epc.
            end.
        end.                                        
        
        FOR EACH tt-ordens-dupli WHERE tt-ordens-dupli.dt-vencim = tt-dupli.dt-vencim
            BREAK BY tt-ordens-dupli.dt-vencim:
            ASSIGN de-vl-apagar-aux = de-vl-apagar-aux + tt-ordens-dupli.vl-apagar
                   de-vl-apagar-mo-aux = de-vl-apagar-mo-aux + tt-ordens-dupli.vl-apagar-mo.
            
            IF LAST-OF(tt-ordens-dupli.dt-vencim) THEN DO:
                ASSIGN de-cotacao = ROUND(de-vl-apagar-aux,2) / ROUND(de-vl-apagar-mo-aux,2).
                
                create tt-lin-i-ap.
                assign tt-lin-i-ap.cod-esp      = c-esp-tit-transit
                       tt-lin-i-ap.tp-codigo    = tt-dupli.tp-despesa
                       tt-lin-i-ap.cod-estabel  = historico-embarque.cod-estabel
                       tt-lin-i-ap.cod-fornec   = processo-imp.cod-exportador
                       tt-lin-i-ap.cod-portador = i-portador-emit
                       tt-lin-i-ap.modalidade   = i-modalidade-emit
                       /*tt-lin-i-ap.conta-debito = param-imp.ct-transit-import*/
                       tt-lin-i-ap.ct-debito    = v_cod_cta_ctbl
                       tt-lin-i-ap.sc-debito    = v_cod_ccusto
                       tt-lin-i-ap.dt-desconto  = ?
                       tt-lin-i-ap.dt-emissao   = historico-embarque.dt-efetiva
                       tt-lin-i-ap.dt-vencimen  = tt-dupli.dt-vencim
                       tt-lin-i-ap.dt-transacao = IF p-dt-desembarque-parcial = ? THEN historico-embarque.dt-efetiva ELSE p-dt-desembarque-parcial
                       tt-lin-i-ap.ep-codigo    = i-empresa-prin
                       tt-lin-i-ap.nr-docto     = historico-embarque.embarque
                       tt-lin-i-ap.origem       = 2
                       tt-lin-i-ap.parcela      = string(i-parcela,"99")
                       tt-lin-i-ap.referencia   = c-ref-aux
                       tt-lin-i-ap.sequencia    = i-cont
                       tt-lin-i-ap.serie        = " "
                       tt-lin-i-ap.perc-mult    = 0     
                       tt-lin-i-ap.cod-retencao = 0
                       tt-lin-i-ap.tp-pagto     = emitente.tp-pagto
                       tt-lin-i-ap.mo-codigo    = i-mo-codigo
                       tt-lin-i-ap.cotacao-dia  = de-cotacao
                       tt-lin-i-ap.vl-taxa      = 0 
                       tt-lin-i-ap.frete        = 0
                       tt-lin-i-ap.diversos     = 0
                       tt-lin-i-ap.vl-original  = round(de-vl-apagar-aux,2)
                       tt-lin-i-ap.vl-orig-me   = round(de-vl-apagar-mo-aux,2)
                       de-vl-apagar-aux = 0
                       de-vl-apagar-mo-aux = 0
                       de-cotacao = 0
                       c-esp-tit-transit = "".
                
             END.
        END.
               

        /*----------------------------------- Unidade de NÇg¢cio ----------------------------------------- */
        &if defined(bf_mat_unidade_negocio) &then               
           assign de-vl-unid    = 0
                  de-vl-unid-me = 0.
           
           if l-unid-neg then do:
              
              assign de-vl-tot-unid = 0
                     de-vl-tot-unid-me = 0.
              for each tt-ordens-dupli where
                        tt-ordens-dupli.dt-vencim = tt-dupli.dt-vencim
                        break by tt-ordens-dupli.numero-ordem:
                  
                  FIND FIRST unid-neg-ordem WHERE
                             unid-neg-ordem.numero-ordem = tt-ordens-dupli.numero-ordem NO-LOCK NO-ERROR.
                  IF NOT AVAIL unid-neg-ordem THEN DO:

                      &if "{&bf_mat_versao_ems}" >= "2.062" &then
                          FIND b-ordem-compra
                              WHERE b-ordem-compra.numero-ordem = tt-ordens-dupli.numero-ordem NO-LOCK NO-ERROR.
                          
                          assign l-tem-unid-neg = yes
                                 c-char-1 = string(b-ordem-compra.cod-unid-negoc) + chr(10) + string(i-tipo-despesa).

                          {rep/re9340.i4 "and tt-lin-conta-ap.char-1 = c-char-1" }   /* Cria TT-LIN-CONTA-AP */

                          assign de-vl-unid    = fn_ajust_dec(tt-ordens-dupli.vl-apagar,0)
                                 de-vl-unid-me = fn_ajust_dec(tt-ordens-dupli.vl-apagar-mo,i-mo-codigo).

                          assign tt-lin-conta-ap.vl-movto    = tt-lin-conta-ap.vl-movto    + de-vl-unid
                                 tt-lin-conta-ap.vl-movto-me = tt-lin-conta-ap.vl-movto-me + de-vl-unid-me
                                 tt-lin-conta-ap.char-1      = c-char-1
                                 de-vl-tot-unid              = de-vl-tot-unid    + de-vl-unid
                                 de-vl-tot-unid-me           = de-vl-tot-unid-me + de-vl-unid-me
                                 de-vl-unid    = 0
                                 de-vl-unid-me = 0.
                      &endif
                  END.
                  ELSE
                      for each unid-neg-ordem no-lock where
                               unid-neg-ordem.numero-ordem = tt-ordens-dupli.numero-ordem
                               break by unid-neg-ordem.cod_unid_negoc:
                          
                          assign l-tem-unid-neg = yes
                                 c-char-1       = string(unid-neg-ordem.cod_unid_negoc)
                                                + chr(10)
                                                + string(i-tipo-despesa).
                          
                          {rep/re9340.i4
                               "and tt-lin-conta-ap.char-1 = c-char-1" }   /* Cria TT-LIN-CONTA-AP */
                          
                          assign de-vl-unid    = fn_ajust_dec(trunc(tt-ordens-dupli.vl-apagar * unid-neg-ordem.perc-unid-neg / 100, 2),0)
                                 de-vl-unid-me = fn_ajust_dec(trunc(tt-ordens-dupli.vl-apagar-mo  * unid-neg-ordem.perc-unid-neg / 100, 2),i-mo-codigo).
    
                          assign tt-lin-conta-ap.vl-movto    = tt-lin-conta-ap.vl-movto    + de-vl-unid
                                 tt-lin-conta-ap.vl-movto-me = tt-lin-conta-ap.vl-movto-me + de-vl-unid-me
                                 tt-lin-conta-ap.char-1      = c-char-1
                                 de-vl-tot-unid              = de-vl-tot-unid    + de-vl-unid
                                 de-vl-tot-unid-me           = de-vl-tot-unid-me + de-vl-unid-me
                                 de-vl-unid = 0
                                 de-vl-unid-me = 0.
                      end.              
              end.

              /* Acerto de Residuos por Unid Negocio */
              
              IF l-tem-unid-neg THEN DO:
                  if de-vl-tot-unid <> tt-lin-i-ap.vl-original then
                      assign tt-lin-conta-ap.vl-movto = tt-lin-conta-ap.vl-movto
                                                      + ( tt-lin-i-ap.vl-original - de-vl-tot-unid ).
                       
                  if de-vl-tot-unid-me <> tt-lin-i-ap.vl-orig-me then
                      assign tt-lin-conta-ap.vl-movto-me = tt-lin-conta-ap.vl-movto-me
                                                     + ( tt-lin-i-ap.vl-orig-me - de-vl-tot-unid-me ).
                  
              END.
           end.
        &endif    
                                                       
       /* ------------------------------------------------------------------------------------------------ */
        
        if not l-unid-neg then do:       
            
            {rep/re9340.i4 " "} /* Cria LIN-CONTA-AP */
            assign tt-lin-conta-ap.vl-movto    = tt-lin-i-ap.vl-original
                   tt-lin-conta-ap.vl-movto-me = tt-lin-i-ap.vl-orig-me.
        end.        
        
        if  param-estoq.gera-ap = 1 then do:     
            create tt-doc-i-ap.
            assign tt-doc-i-ap.cod-esp     = tt-lin-i-ap.cod-esp
                   tt-doc-i-ap.cod-estabel = tt-lin-i-ap.cod-estabel
                   tt-doc-i-ap.data-movto  = IF p-dt-desembarque-parcial = ? THEN historico-embarque.dt-efetiva ELSE p-dt-desembarque-parcial
                   tt-doc-i-ap.ep-codigo   = i-empresa-prin
                   tt-doc-i-ap.referencia  = tt-lin-i-ap.referencia
                   tt-doc-i-ap.mo-codigo   = tt-lin-i-ap.mo-codigo
                   tt-doc-i-ap.total-movto = if  tt-lin-i-ap.mo-codigo = 0 then 
                                                 tt-lin-i-ap.vl-original 
                                             else 
                                                 tt-lin-i-ap.vl-orig-me
                   tt-doc-i-ap.cod-versao-integ = 003
                   tt-doc-i-ap.ind-elimina-lote = if  avail param-re 
                                                  and param-re.erro-dupli then 
                                                      2 /* n∆o elimina o tt-doc-i-ap em caso de erro na api*/
                                                  else 
                                                      1 /* elimina o tt-doc-i-ap em caso de erro na api*/.                                                      
                                                      
        end.
    end.
end.    



/* IM0080.I */
