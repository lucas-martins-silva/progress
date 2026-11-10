/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0660RP 2.00.00.017}  /*** 010017 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0660rp MIM}
&ENDIF

/*****************************************************************************
**
**     PROGRAMA: IM0660RP.P
**
**     OBJETIVO: Emissao Pedido Fechamento de C³mbio
**
*****************************************************************************/
    {cdp/cdcfgmat.i}    /* Pre-processador Materiais */
    {cdp/cdcfgdis.i}    /* Pre-processaror Distribuicao */
    {imp/imapi009.i}    /* temp-tables */
    {imp/imapi009.i1}   /* temp-tables */
    {imp/im0660.i}      /* tt-param */
    {imp/im0660.i1}     /* forms - variaveis */ 
    {include/tt-edit.i} /* para impressÆo da mensagem de erro */
    {include/pi-edit.i} /* para impressÆo da mensagem de erro */

    {include/i-rpvar.i}
    
    {utp/ut-liter.i Pedido_de_Fechamento_de_Cƒmbio * r}
    assign c-titulo-relat = trim(return-value).
    {utp/ut-liter.i Importa‡Æo * r}
    assign c-sistema = trim(return-value).
    
    
    define input parameter raw-param as raw.
    define input parameter table for tt-raw-digita.
    

    create tt-param.
    raw-transfer raw-param to tt-param.
    
    if  tt-param.destino = 1 then do:
    
        {utp/ut-liter.i Impressora * r}
        assign c-destino = trim(return-value).
    end.
    else 
        if  tt-param.destino = 2 then do:
    
            {utp/ut-liter.i Arquivo * r}
             assign c-destino = trim(return-value). 
         end.
         else do:
    
             {utp/ut-liter.i Terminal * r}
             assign c-destino = trim(return-value). 
         end.
       
    find first param-global no-lock no-error.
    
    assign c-empresa  = (if avail param-global then param-global.grupo else "")
           c-programa = "IM/0660"
           c-versao   = "1.00"
           c-revisao  = "001".

    {include/i-rpcab.i}
    {include/i-rpout.i} 

    view frame f-cabec.
    view frame f-rodape.
    
    if  not valid-handle (h-imapi009) then
        run imp/imapi009.p persistent set h-imapi009.

    for each  embarque-imp no-lock 
        where embarque-imp.cod-estabel         >= tt-param.cod-est-ini 
        and   embarque-imp.cod-estabel         <= tt-param.cod-est-fim 
        and   embarque-imp.embarque            >= tt-param.c-emb-ini   
        and   embarque-imp.embarque            <= tt-param.c-emb-fim 
        and   embarque-imp.cod-conhecto-master >= tt-param.c-master-ini   
        and   embarque-imp.cod-conhecto-master <= tt-param.c-master-fim   
        and   embarque-imp.cod-conhecto-house  >= tt-param.c-house-ini   
        and   embarque-imp.cod-conhecto-house  <= tt-param.c-house-fim   
        break by embarque-imp.embarque:
        
        /* Limpa as tabelas temporarias */
        run emptyTempTables in h-imapi009.
    
        run setConstraintEmbarqueImp in h-imapi009 (input rowid(embarque-imp)).
    
        /* Passa o valor do parametro traducao*/
        run setTraducao in h-imapi009 (input tt-param.i-traducao).

        /* Devolve temp-table com informacoes sobre o exportador */
        run getExportador in h-imapi009 (output table tt-emitente).
        if  return-value = "NOK":U then do:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Exportador" *}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input RETURN-VALUE).
    
            create tt-erro.
            assign tt-erro.cod-estabel = embarque-imp.cod-estabel 
                   tt-erro.nome-abrev  = ""
                   tt-erro.embarque    = embarque-imp.embarque 
                   tt-erro.nr-invoice  = ""
                   tt-erro.parcela     = ""
                   tt-erro.cd-erro     = 2
                   tt-erro.mensagem    = return-value.
            next.
        end.

        find first tt-emitente no-error.
    
        /* Devolve temp-table contendo o embarque */
        run getEmbarqueImportacao in h-imapi009 (output table tt-embarque).
        for each tt-embarque:
            assign tt-embarque.desc-via-transp = {adinc/i01ad268.i 04 tt-embarque.cod-via-transp}
                   tt-embarque.desc-situacao   = {cxinc/i01cx220.i 04 tt-embarque.situacao}.
    
            if  tt-param.i-traducao <> 1 then do:
                {imp/im9998.i "tt-embarque.desc-via-transp" "tt-embarque.desc-via-transp" "tt-emitente"}            
                {imp/im9998.i "tt-embarque.desc-situacao" "tt-embarque.desc-situacao" "tt-emitente"}
            end.
        end.
        if  return-value = "NOK":U then do:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Embarque_Importa‡Æo" *}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input RETURN-VALUE).
    
            create tt-erro.
            assign tt-erro.cod-estabel = embarque-imp.cod-estabel 
                   tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador */
                   tt-erro.embarque    = embarque-imp.embarque 
                   tt-erro.nr-invoice  = ""
                   tt-erro.parcela     = ""
                   tt-erro.cd-erro     = 2
                   tt-erro.mensagem    = return-value.
            next.
        end.
    
        /* Devolve temp-table dos proc importacao do embarque */
        run getProcessoImportacao in h-imapi009 (output table tt-processo).
        for each tt-processo:
            assign tt-processo.desc-via-transp = {adinc/i01ad268.i 04 tt-processo.via-transp}
                   tt-processo.desc-situacao   = {cxinc/i01cx140.i 04 tt-processo.situacao}.
            
            if  tt-param.i-traducao <> 1 then do:
                {imp/im9998.i "tt-processo.desc-via-transp" "tt-processo.desc-via-transp" "tt-processo"}            
                {imp/im9998.i "tt-processo.desc-situacao" "tt-processo.desc-situacao" "tt-processo"}
            end.
        end.
        if  return-value = "NOK":U then do:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Processo_Importa‡Æo" *}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input RETURN-VALUE).
    
            create tt-erro.
            assign tt-erro.cod-estabel = embarque-imp.cod-estabel 
                   tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador */
                   tt-erro.embarque    = embarque-imp.embarque 
                   tt-erro.nr-invoice  = ""
                   tt-erro.parcela     = ""
                   tt-erro.cd-erro     = 2
                   tt-erro.mensagem    = return-value.
            next.
        end.
        
        /* Devolve temp-table dos pedidos de compras do embarque */
        run getPedidoCompra in h-imapi009 (output table tt-pedido).
        for each tt-pedido:
            
            assign tt-pedido.desc-situacao   = {ininc/i02in295.i 04 tt-pedido.situacao}.
    
            if  tt-param.i-traducao <> 1 then do:
                {imp/im9998.i "tt-pedido.desc-situacao" "tt-pedido.desc-situacao" "tt-processo"}
            end.

        end.
        if  return-value = "NOK":U then do:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Pedido_de_Compra" *}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input RETURN-VALUE).
    
            create tt-erro.
            assign tt-erro.cod-estabel = embarque-imp.cod-estabel 
                   tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador */
                   tt-erro.embarque    = embarque-imp.embarque 
                   tt-erro.nr-invoice  = ""
                   tt-erro.parcela     = ""
                   tt-erro.cd-erro     = 2
                   tt-erro.mensagem    = return-value.
            next.
        end.
        
        /* Devolve temp-table da condicao de pagamento do pedido */
        run getCondicaoPagamento in h-imapi009 (output table tt-cond-pagto).
        if  return-value = "NOK":U then do:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Condi‡Æo_de_Pagamento_do_Pedido" *}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input RETURN-VALUE).
    
            create tt-erro.
            assign tt-erro.cod-estabel = embarque-imp.cod-estabel 
                   tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador */
                   tt-erro.embarque    = embarque-imp.embarque 
                   tt-erro.nr-invoice  = ""
                   tt-erro.parcela     = ""
                   tt-erro.cd-erro     = 2
                   tt-erro.mensagem    = return-value.
            next.
        end.
        
        /* Devolve temp-table com informacoes sobre o banco */
        run getBanco in h-imapi009 (output table tt-banco).
        if  return-value = "NOK":U then do:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Banco" *}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input RETURN-VALUE).
            create tt-erro.
            assign tt-erro.cod-estabel = embarque-imp.cod-estabel 
                   tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador */
                   tt-erro.embarque    = embarque-imp.embarque 
                   tt-erro.nr-invoice  = ""
                   tt-erro.parcela     = ""
                   tt-erro.cd-erro     = 2
                   tt-erro.mensagem    = return-value.
            next.
        end.
        
        /* Devolve temp-table com informacoes sobre o importador */
        run getImportador in h-imapi009 (output table tt-estabelec).
        if  return-value = "NOK":U then do:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Estabelecimento_Importador" *}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input RETURN-VALUE).
    
            create tt-erro.
            assign tt-erro.cod-estabel = embarque-imp.cod-estabel 
                   tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador */
                   tt-erro.embarque    = embarque-imp.embarque 
                   tt-erro.nr-invoice  = ""
                   tt-erro.parcela     = ""
                   tt-erro.cd-erro     = 2
                   tt-erro.mensagem    = return-value.
            next.
        end.

        /* Devolve temp-table com informacoes sobre o corretor */
        run getCorretorCambio in h-imapi009 (output table tt-corretor).
        if  return-value = "NOK":U then do:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Corretor_Cƒmbio" *}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input RETURN-VALUE).
    
            create tt-erro.
            assign tt-erro.cod-estabel = embarque-imp.cod-estabel 
                   tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador */
                   tt-erro.embarque    = embarque-imp.embarque 
                   tt-erro.nr-invoice  = ""
                   tt-erro.parcela     = ""
                   tt-erro.cd-erro     = 2
                   tt-erro.mensagem    = return-value.
            next.
        end.
    
        /* Devolve temp-table com informacoes sobre o banco do exportador */
        run getBancoExportador in h-imapi009 (output table tt-bco-exp).
        if  return-value = "NOK":U then do:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Banco_do_Exportador" *}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input RETURN-VALUE).
    
            create tt-erro.
            assign tt-erro.cod-estabel = embarque-imp.cod-estabel 
                   tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador */
                   tt-erro.embarque    = embarque-imp.embarque 
                   tt-erro.nr-invoice  = ""
                   tt-erro.parcela     = ""
                   tt-erro.cd-erro     = 2
                   tt-erro.mensagem    = return-value.
            next.
        end.
    
        /* Devolve temp-table com informacoes sobre a agencia bancaria do exportador*/
        run getAgenciaExportador in h-imapi009 (output table tt-agencia).
        if  return-value = "NOK":U then do:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Agˆncia_do_Exportador" *}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input RETURN-VALUE).
    
            create tt-erro.
            assign tt-erro.cod-estabel = embarque-imp.cod-estabel 
                   tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador */
                   tt-erro.embarque    = embarque-imp.embarque 
                   tt-erro.nr-invoice  = ""
                   tt-erro.parcela     = ""
                   tt-erro.cd-erro     = 2
                   tt-erro.mensagem    = return-value.
            next.
        end.
    
        /* Devolve temp-table com informacoes sobre o comprador do pedido de compra */
        run getComprador in h-imapi009 (output table tt-comprador).
        if  return-value = "NOK":U then do:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Comprador_Pedido_Compra" *}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input RETURN-VALUE).
    
            create tt-erro.
            assign tt-erro.cod-estabel = embarque-imp.cod-estabel 
                   tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador */
                   tt-erro.embarque    = embarque-imp.embarque 
                   tt-erro.nr-invoice  = ""
                   tt-erro.parcela     = ""
                   tt-erro.cd-erro     = 2
                   tt-erro.mensagem    = return-value.
            next.
        end.
    
        /* Devolve temp-table contendo as invoices do embarque e dados complementares
           do pedido de fechamento de cambio                                          */
        run getPedFechaCambio in h-imapi009 (input  tt-param.nr-inv-ini,
                                             input  tt-param.nr-inv-fim,
                                             input  tt-param.dt-vencim-ini, 
                                             input  tt-param.dt-vencim-fim, 
                                             output table tt-invoice,
                                             output table tt-pd-fecha-camb).
        if  return-value = "NOK":U then do:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Invoices_e/ou_Dados_Complementares_do_Ped_Fech_Cƒmbio" *}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input RETURN-VALUE).
    
            create tt-erro.
            assign tt-erro.cod-estabel = embarque-imp.cod-estabel 
                   tt-erro.nome-abrev  = tt-emitente.nome-abrev  /*exportador */
                   tt-erro.embarque    = embarque-imp.embarque 
                   tt-erro.nr-invoice  = ""
                   tt-erro.parcela     = ""
                   tt-erro.cd-erro     = 2
                   tt-erro.mensagem    = return-value.
            next.
        end.
        
        if  can-find (first tt-invoice) then do:
            run imp/im0660a.p (input  table tt-embarque,
                               input  table tt-processo,
                               input  table tt-pedido,
                               input  table tt-banco,
                               input  table tt-estabelec,
                               input  table tt-emitente,
                               input  table tt-corretor,
                               input  table tt-bco-exp,
                               input  table tt-agencia,
                               input  table tt-comprador,
                               input  table tt-invoice,
                               input  table tt-pd-fecha-camb,
                               input  table tt-cond-pagto,
                               input  table tt-param,
                               output c-arquivo-final,
                               output table tt-erro-geracao).
            find first tt-emitente no-error.

            if  not can-find (first tt-erro-geracao)
            and c-arquivo-final <> "" then do:
                
                if  tt-param.i-agrupar = 1 then do: /* Agrupar por Invoice */
    
                    if  l-imprime-doc then do:
                        view frame f-titulo-documentos.
                        assign l-imprime-doc = no.
                    end.
        
                    assign i-cont = 0.
    
                    for each tt-invoice:
                        assign i-cont = i-cont + 1.
                        disp embarque-imp.cod-estabel
                             tt-emitente.nome-abrev when avail tt-emitente
                             embarque-imp.embarque    
                             tt-invoice.nr-invoice when avail tt-invoice
                             entry(i-cont,c-arquivo-final) @ c-arquivo-final-aux
                             with frame f-documentos-impressos-inv.
                        down with frame f-documentos-impressos-inv.
                    end.
                end.
                else do:
                    find first tt-invoice no-error.
    
                    if  l-imprime-doc then do:
                        view frame f-titulo-documentos.
                        assign l-imprime-doc = no.
                    end.
        
                    disp embarque-imp.cod-estabel
                         tt-emitente.nome-abrev when avail tt-emitente
                         embarque-imp.embarque    
                         c-arquivo-final @ c-arquivo-final-aux
                         with frame f-documentos-impressos-emb.
                    down with frame f-documentos-impressos-emb.
                end.
            end.
            ELSE DO:
                FOR EACH tt-erro-geracao:
                    CREATE tt-erro.
                    BUFFER-COPY tt-erro-geracao TO tt-erro.
                END.
                EMPTY TEMP-TABLE tt-erro-geracao.
            END.
        end.    
    end.
    if  can-find (first tt-erro) then do:
        view frame f-titulo-erros.
        for each tt-erro:
            IF tt-erro.mensagem <> '' THEN
                RUN pi-imprime-narrativa-erro (INPUT 1).
            ELSE
                ASSIGN c-erro = ''.
            if  tt-param.i-agrupar = 1 then do:
                disp tt-erro.cod-estabel
                     tt-erro.nome-abrev 
                     tt-erro.embarque   
                     tt-erro.nr-invoice 
                     tt-erro.cd-erro
                     c-erro
                     with frame f-erros-inv.
                down with frame f-erros-inv.
            end.
            else do:
                disp tt-erro.cod-estabel
                     tt-erro.nome-abrev 
                     tt-erro.embarque   
                     tt-erro.cd-erro
                     c-erro
                     with frame f-erros-emb.
                down with frame f-erros-emb.
            end.
            RUN pi-imprime-narrativa-erro (INPUT 2).
        end.
    end.
    
    if  tt-param.l-impre then do:

        if  tt-param.i-agrupar = 1 then 
            assign c-agrupar = "Por Fatura".
        else
            assign c-agrupar = "Por Embarque".

        if  tt-param.i-orientacao = 0 then
            assign c-orientacao = "Retrato".
        else
            assign c-orientacao = "Paisagem".

        case tt-param.i-traducao:
            when 1 then
                assign c-traducao = "NÆo Traduz".
            when 2 then
                assign c-traducao = "Idioma Corret Camb".
            when 3 then
                assign c-traducao = "Idioma Corret Camb".
            when 4 then
                assign c-traducao = "Idioma Exportador".
        end case.

        page.
        disp c-sel
             tt-param.cod-est-ini                
             tt-param.cod-est-fim
             tt-param.c-emb-ini            
             tt-param.c-emb-fim   
             tt-param.nr-inv-ini 
             tt-param.nr-inv-fim  
             tt-param.dt-vencim-ini
             tt-param.dt-vencim-fim
             tt-param.c-master-ini
             tt-param.c-master-fim
             tt-param.c-house-ini
             tt-param.c-house-fim
             c-par
             tt-param.l-envia-docto-exportador
             tt-param.l-envia-docto-corretor  
             tt-param.c-arquivo-copia         
             tt-param.l-layout-pad-fornec     
             tt-param.c-layout-pad-fornec   
             tt-param.l-sobrepor              
             tt-param.c-dir-destino           
             c-agrupar               
             c-orientacao            
             c-traducao              
             c-imp
             c-destino             
             tt-param.usuario
             with frame f-param.
    end.         

if  valid-handle (h-imapi009) then do:
    delete procedure h-imapi009.
    h-imapi009 = ?.
end.

{include/i-rpclo.i}

return 'OK'.

PROCEDURE pi-imprime-narrativa-erro:
DEFINE INPUT PARAMETER pLinha AS INTEGER NO-UNDO.
    RUN pi-print-editor (tt-erro.mensagem, 70).
    FOR EACH tt-editor:
        IF pLinha = 1 THEN DO:
            ASSIGN c-erro = tt-editor.conteudo.
            LEAVE.
        END.
        ELSE 
            IF pLinha > 2  THEN
                PUT tt-editor.conteudo  AT 54  FORMAT "x(70)":U .
        ASSIGN pLinha = pLinha + 1.                              
    END.
END.

