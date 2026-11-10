/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0305RP 2.00.00.038 } /*** "010038" 28/09/2026 16:34:52  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0305rp MIM}
&ENDIF



    {imp/im0305.i}      /* tt-param */
    {imp/im0305.i1}     /* tt-pedido-compr, tt-pedido-compr-aux,tt-ordem-compra, tt-prazo-compra, tt-despesa e tt-texto-follow-up */
    {cdp/cd4300.i3}     /* definicoes busca valores cotacao-item.char-1 */
    {ccp/cc9019.i50}    /* definicoes busca valores cotacao-item.char-1 */
    {imp/imapi009.i}    /* temp-tables utilizadas nos retornos da api */
    {imp/imapi009.i2}   /* temp-tables utilizadas nos retornos da api */
    {method/dbotterr.i} /* temp-table RowErrors */
    {include/tt-edit.i}
    {include/i-rpvar.i}

    define temp-table tt-raw-digita
        field raw-digita as raw.

    DEFINE TEMP-TABLE tt_log_erro NO-UNDO
        FIELD ttv_num_cod_erro  AS INTEGER   INITIAL ?
        FIELD ttv_des_msg_ajuda AS CHARACTER INITIAL ?
        FIELD ttv_des_msg_erro  AS CHARACTER INITIAL ?.

    /* Parametros do relatorio */
    define input param raw-param as raw no-undo.
    define input param table for tt-raw-digita.

    define variable h-acomp                         as handle                      no-undo.
    define variable c-acompanha                     as character format "x(15)":U  no-undo.
    define variable i-cont                          as integer                     no-undo.
    define variable c-texto-follow                  as character format "x(120)":U no-undo.
    define variable c-texto                         as character format "x(120)":U no-undo.
    define variable c-texto-aux                     as character format "x(120)":U no-undo.
    define variable h-imapi009                      as handle                      no-undo.
    define variable l-pendente                      as logical                     no-undo.
    define variable de-valor-descto-conv            like ordem-compra.valor-descto no-undo.
    define variable de-val-desp-conv                like cotacao-item-cex.val-desp no-undo.
    define variable de-preco-fornec-liq-conv        like cotacao-item.preco-fornec no-undo.
    define variable de-preco-interno-liq-conv       like cotacao-item.preco-fornec no-undo.
    define variable de-preco-fornec-bru-conv        like cotacao-item.preco-fornec no-undo.
    define variable de-preco-interno-bru-conv       like cotacao-item.preco-fornec no-undo.
    define variable de-preco-fornec-liq-total-conv  like cotacao-item.preco-fornec no-undo.
    define variable de-preco-interno-liq-total-conv like cotacao-item.preco-fornec no-undo.
    define variable de-preco-fornec-bru-total-conv  like cotacao-item.preco-fornec no-undo.
    define variable de-preco-interno-bru-total-conv like cotacao-item.preco-fornec no-undo.
    define variable de-tot-desp-ped                 like desp-imp.val-desp         no-undo.
    define variable l-primeira                      as logical                     no-undo.
    define variable c-erro-eai                      as character                   no-undo.
    define new global shared variable v_log_eai_habilit as logical                 no-undo.

    create tt-param.
    raw-transfer raw-param to tt-param.

    FIND FIRST tt-param.

    /************************* Definiá∆o de Frames ******************************/
&IF "{&mguni_version}" >= "2.071" &THEN
    DO:
    FORM tt-documentos-impressos.cod-estabel   format "x(05)"     COLUMN-LABEL "Est"
&ELSE
    FORM tt-documentos-impressos.cod-estabel   FORMAT "x(03)"     COLUMN-LABEL "Est"
&ENDIF
         tt-documentos-impressos.nome-emit-exp FORMAT "x(12)"     COLUMN-LABEL "Exportador"
         tt-documentos-impressos.nr-proc-imp   FORMAT "x(12)"     COLUMN-LABEL "Proc Import"
         tt-documentos-impressos.num-pedido    FORMAT ">>>>>,>>9" COLUMN-LABEL "Pedido"         
         tt-documentos-impressos.destino       FORMAT "x(92)"     COLUMN-LABEL "Destino"
    WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-doc-impressos.

    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME f-doc-impressos:HANDLE).
    
    END. 

&IF "{&mguni_version}" >= "2.071" &THEN
    DO:
    FORM tt-documentos-erros.cod-estabel   format "x(05)"     COLUMN-LABEL "Est"
&ELSE
    FORM tt-documentos-erros.cod-estabel   FORMAT "x(03)"     COLUMN-LABEL "Est"
&ENDIF
         tt-documentos-erros.nome-emit-exp FORMAT "x(12)"     COLUMN-LABEL "Exportador"
         tt-documentos-erros.nr-proc-imp   FORMAT "x(12)"     COLUMN-LABEL "Proc Import"
         tt-documentos-erros.num-pedido    FORMAT ">>>>>,>>9" COLUMN-LABEL "Pedido"
         tt-documentos-erros.cod-erro      FORMAT "99,999"    COLUMN-LABEL "Nr Mensag"
         tt-documentos-erros.mensagem      FORMAT "x(82)"     COLUMN-LABEL "Mensagem"
    WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-doc-erros. 
    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME f-doc-erros:HANDLE).
    
    END.    

    /* Include com a definiá∆o da frame de cabeáalho e rodapÇ */
    {include/i-rpcab.i}

    /* Include padr∆o para output de relat¢rios */
    {include/i-rpout.i}


    find first param-compra no-lock no-error.

    if  not valid-handle (h-imapi009) then
        run imp/imapi009.p persistent set h-imapi009.

    {utp/ut-liter.i Purchase_Order * r}.
    assign c-acompanha = return-value.

    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar in h-acomp(input c-acompanha).

    {utp/ut-liter.i Num._Pedido:_ * r}.
    assign c-acompanha = return-value.

    {utp/ut-liter.i Erros_ocorridos_durante_o_envio_ao_EAI * r}
    assign c-erro-eai = return-value.

    FOR FIRST param-global NO-LOCK:
        ASSIGN c-empresa = (IF AVAIL param-global THEN param-global.grupo ELSE "").
    END.

    {utp/ut-liter.i Purchase_Order * r}
    
    ASSIGN c-titulo-relat = trim(return-value)
           c-programa     = "IM0305".
    
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    run piPrincipal.

    /* Procedure interna utilizada para emitir os documentos criados ou erros enontrados */
    RUN piImprimirDoctosGerados IN THIS-PROCEDURE.

    if v_log_eai_habilit then do:    
        page.
        run pi-imprime-erros-eai.
    end.

    /* Imprimir p†gina de parÉmetros */
    PAGE.
    RUN piImprimirParametros IN THIS-PROCEDURE.

    if  valid-handle (h-imapi009) then
        DELETE PROCEDURE h-imapi009.

    /* Fechamento do output do relat¢rio */
    {include/i-rpclo.i}
    RUN pi-finalizar IN h-acomp.
    RETURN "OK":U.

/************************************ PROCEDURES INTERNAS ***************************************/

/* PROCEDURES GERACAO PEDIDO-COMPR */
procedure getAgenciaBanco:

    run getAgenciaBanco in h-imapi009 (output table tt-agencia).

    find first tt-agencia no-error.
    if  avail  tt-agencia then
        assign tt-pedido-compr-aux.desc-agencia	= tt-agencia.nome.

end procedure.

procedure getAgenteCargas:

    /* Busca informacoes do Agente de Cargas do Processo de Importacao */
    run getAgenteCargas in h-imapi009 (output table tt-emitente).

    find first tt-emitente no-error.
    if  avail  tt-emitente then
        assign tt-pedido-compr-aux.nome-agente          = tt-emitente.nome-emit    
               tt-pedido-compr-aux.endereco-agente      = tt-emitente.endereco     
               tt-pedido-compr-aux.bairro-agente        = tt-emitente.bairro       
               tt-pedido-compr-aux.cidade-agente        = tt-emitente.cidade       
               tt-pedido-compr-aux.pais-agente          = tt-emitente.pais         
               tt-pedido-compr-aux.cep-agente           = tt-emitente.cep          
               tt-pedido-compr-aux.cgc-agente           = tt-emitente.cgc          
               tt-pedido-compr-aux.estado-agente        = tt-emitente.estado       
               tt-pedido-compr-aux.ins-estadual-agente  = tt-emitente.ins-estadual 
               tt-pedido-compr-aux.ins-municipal-agente = tt-emitente.ins-municipal
               tt-pedido-compr-aux.caixa-postal-agente  = tt-emitente.caixa-postal 
               tt-pedido-compr-aux.e-mail-agente        = tt-emitente.e-mail       
               tt-pedido-compr-aux.cod-aba-agente       = tt-emitente.cod-aba      
               tt-pedido-compr-aux.telefone1-agente     = tt-emitente.telefone[1]
               tt-pedido-compr-aux.telefone2-agente     = tt-emitente.telefone[2]  
               tt-pedido-compr-aux.ramal1-agente        = tt-emitente.ramal[1]     
               tt-pedido-compr-aux.ramal2-agente        = tt-emitente.ramal[2]     
               tt-pedido-compr-aux.home-page-agente     = tt-emitente.home-page    
               tt-pedido-compr-aux.telefax-agente       = tt-emitente.telefax      
               tt-pedido-compr-aux.ramal-fax-agente     = tt-emitente.ramal-fax    
               tt-pedido-compr-aux.telef-fac-agente     = tt-emitente.telef-fac    
               tt-pedido-compr-aux.ramal-fac-agente     = tt-emitente.ramal-fac    
               tt-pedido-compr-aux.telef-modem-agente   = tt-emitente.telef-modem  
               tt-pedido-compr-aux.ramal-modem-agente   = tt-emitente.ramal-modem.  

end procedure.

procedure getAssinaturas:

    run getAssinaturas in h-imapi009 (output table tt-assinaturas).

    find first tt-assinaturas no-error.
    if  avail  tt-assinaturas then
        assign tt-pedido-compr-aux.nome-assinat1  = tt-assinaturas.nome-ass1  
               tt-pedido-compr-aux.nome-assinat2  = tt-assinaturas.nome-ass2  
               tt-pedido-compr-aux.nome-assinat3  = tt-assinaturas.nome-ass3  
               tt-pedido-compr-aux.cargo-assinat1 = tt-assinaturas.cargo-ass1 
               tt-pedido-compr-aux.cargo-assinat2 = tt-assinaturas.cargo-ass2 
               tt-pedido-compr-aux.cargo-assinat3 = tt-assinaturas.cargo-ass3.

end procedure.

procedure getBanco:

    run getBanco in h-imapi009 (output table tt-banco).
    
    find first tt-banco no-error.
    if  avail  tt-banco then
        assign tt-pedido-compr-aux.desc-banco = tt-banco.nome-banco
               tt-pedido-compr-aux.ag-banco   = tt-banco.ag-padrao. 

end procedure.

procedure getCondicaoPagamento:
            
    /* Busca informacoes das Condicoes de Pagamento do Pedido */
    run getCondicaoPagamento in h-imapi009 (output table tt-cond-pagto).

    find first tt-cond-pagto no-error.
    if  avail  tt-cond-pagto then 
        assign tt-pedido-compr-aux2.desc-cond-pagto      = tt-cond-pagto.descricao
               tt-pedido-compr-aux2.narrativa-cond-pagto = tt-cond-pagto.narrativa.

end procedure.

procedure getConsignatario:

    run getConsignatario in h-imapi009 (output table tt-emitente).

    find first tt-emitente no-error.
    if  avail  tt-emitente then
        assign tt-pedido-compr-aux.nome-consig          = tt-emitente.nome-emit    
               tt-pedido-compr-aux.endereco-consig      = tt-emitente.endereco   
               tt-pedido-compr-aux.bairro-consig        = tt-emitente.bairro       
               tt-pedido-compr-aux.cidade-consig        = tt-emitente.cidade       
               tt-pedido-compr-aux.pais-consig          = tt-emitente.pais         
               tt-pedido-compr-aux.cep-consig           = tt-emitente.cep          
               tt-pedido-compr-aux.cgc-consig           = tt-emitente.cgc          
               tt-pedido-compr-aux.estado-consig        = tt-emitente.estado       
               tt-pedido-compr-aux.Ins-estadual-consig  = tt-emitente.ins-estadual 
               tt-pedido-compr-aux.Ins-municipal-consig = tt-emitente.ins-municipal
               tt-pedido-compr-aux.caixa-postal-consig  = tt-emitente.caixa-postal 
               tt-pedido-compr-aux.e-mail-consig        = tt-emitente.e-mail       
               tt-pedido-compr-aux.cod-aba-consig       = tt-emitente.cod-aba      
               tt-pedido-compr-aux.telefone1-consig     = tt-emitente.telefone[1]
               tt-pedido-compr-aux.telefone2-consig     = tt-emitente.telefone[2]  
               tt-pedido-compr-aux.ramal1-consig        = tt-emitente.ramal[1]     
               tt-pedido-compr-aux.ramal2-consig        = tt-emitente.ramal[2]     
               tt-pedido-compr-aux.home-page-consig     = tt-emitente.home-page    
               tt-pedido-compr-aux.telefax-consig       = tt-emitente.telefax      
               tt-pedido-compr-aux.ramal-fax-consig     = tt-emitente.ramal-fax    
               tt-pedido-compr-aux.telef-fac-consig     = tt-emitente.telef-fac    
               tt-pedido-compr-aux.ramal-fac-consig     = tt-emitente.ramal-fac    
               tt-pedido-compr-aux.telef-modem-consig   = tt-emitente.telef-modem  
               tt-pedido-compr-aux.ramal-modem-consig   = tt-emitente.ramal-modem.

end procedure.

procedure getCorretorCambio:

    run getCorretorCambio in h-imapi009 (output table tt-emitente).

    find first tt-emitente no-error.
    if  avail  tt-emitente  then
        assign tt-pedido-compr-aux.nome-corretor-cam          = tt-emitente.nome-emit    
               tt-pedido-compr-aux.endereco-corretor-cam      = tt-emitente.endereco     
               tt-pedido-compr-aux.bairro-corretor-cam        = tt-emitente.bairro       
               tt-pedido-compr-aux.cidade-corretor-cam        = tt-emitente.cidade       
               tt-pedido-compr-aux.pais-corretor-cam          = tt-emitente.pais         
               tt-pedido-compr-aux.cep-corretor-cam           = tt-emitente.cep          
               tt-pedido-compr-aux.cgc-corretor-cam           = tt-emitente.cgc          
               tt-pedido-compr-aux.estado-corretor-cam        = tt-emitente.estado       
               tt-pedido-compr-aux.ins-estadual-corretor-cam  = tt-emitente.ins-estadual 
               tt-pedido-compr-aux.ins-municipal-corretor-cam = tt-emitente.ins-municipal
               tt-pedido-compr-aux.caixa-postal-corretor-cam  = tt-emitente.caixa-postal 
               tt-pedido-compr-aux.e-mail-corretor-cam        = tt-emitente.e-mail       
               tt-pedido-compr-aux.cod-aba-corretor-cam       = tt-emitente.cod-aba      
               tt-pedido-compr-aux.telefone1-corretor-cam     = tt-emitente.telefone[1]
               tt-pedido-compr-aux.telefone2-corretor-cam     = tt-emitente.telefone[2]  
               tt-pedido-compr-aux.ramal1-corretor-cam        = tt-emitente.ramal[1]     
               tt-pedido-compr-aux.ramal2-corretor-cam        = tt-emitente.ramal[2]     
               tt-pedido-compr-aux.home-page-corretor-cam     = tt-emitente.home-page    
               tt-pedido-compr-aux.telefax-corretor-cam       = tt-emitente.telefax      
               tt-pedido-compr-aux.ramal-fax-corretor-cam     = tt-emitente.ramal-fax    
               tt-pedido-compr-aux.telef-fac-corretor-cam     = tt-emitente.telef-fac    
               tt-pedido-compr-aux.ramal-fac-corretor-cam     = tt-emitente.ramal-fac    
               tt-pedido-compr-aux.telef-modem-corretor-cam   = tt-emitente.telef-modem  
               tt-pedido-compr-aux.ramal-modem-corretor-cam   = tt-emitente.ramal-modem.  

end procedure.

procedure getCorretorImport:

    run getCorretorImport in h-imapi009 (output table tt-emitente).

    find first tt-emitente no-error.
    if  avail  tt-emitente then
        assign tt-pedido-compr-aux.nome-corretor-imp          = tt-emitente.nome-emit    
               tt-pedido-compr-aux.endereco-corretor-imp      = tt-emitente.endereco     
               tt-pedido-compr-aux.bairro-corretor-imp        = tt-emitente.bairro       
               tt-pedido-compr-aux.cidade-corretor-imp        = tt-emitente.cidade       
               tt-pedido-compr-aux.pais-corretor-imp          = tt-emitente.pais         
               tt-pedido-compr-aux.cep-corretor-imp           = tt-emitente.cep          
               tt-pedido-compr-aux.cgc-corretor-imp           = tt-emitente.cgc          
               tt-pedido-compr-aux.estado-corretor-imp        = tt-emitente.estado       
               tt-pedido-compr-aux.ins-estadual-corretor-imp  = tt-emitente.ins-estadual 
               tt-pedido-compr-aux.ins-municipal-corretor-imp = tt-emitente.ins-municipal
               tt-pedido-compr-aux.caixa-postal-corretor-imp  = tt-emitente.caixa-postal 
               tt-pedido-compr-aux.e-mail-corretor-imp        = tt-emitente.e-mail       
               tt-pedido-compr-aux.cod-aba-corretor-imp       = tt-emitente.cod-aba      
               tt-pedido-compr-aux.telefone1-corretor-imp     = tt-emitente.telefone[1]  
               tt-pedido-compr-aux.telefone2-corretor-imp     = tt-emitente.telefone[2]  
               tt-pedido-compr-aux.ramal1-corretor-imp        = tt-emitente.ramal[1]     
               tt-pedido-compr-aux.ramal2-corretor-imp        = tt-emitente.ramal[2]     
               tt-pedido-compr-aux.home-page-corretor-imp     = tt-emitente.home-page    
               tt-pedido-compr-aux.telefax-corretor-imp       = tt-emitente.telefax      
               tt-pedido-compr-aux.ramal-fax-corretor-imp     = tt-emitente.ramal-fax    
               tt-pedido-compr-aux.telef-fac-corretor-imp     = tt-emitente.telef-fac    
               tt-pedido-compr-aux.ramal-fac-corretor-imp     = tt-emitente.ramal-fac    
               tt-pedido-compr-aux.telef-modem-corretor-imp   = tt-emitente.telef-modem  
               tt-pedido-compr-aux.ramal-modem-corretor-imp   = tt-emitente.ramal-modem.  

end procedure.

procedure getDespachante:

    /* Busca informacoes do Despachante do Processo de Importacao */
    run getDespachante in h-imapi009 (output table tt-emitente).

    find first tt-emitente no-error.
    if  avail  tt-emitente then
        assign tt-pedido-compr-aux.nome-emit-despach          = tt-emitente.nome-emit    
               tt-pedido-compr-aux.endereco-emit-despach      = tt-emitente.endereco     
               tt-pedido-compr-aux.bairro-emit-despach        = tt-emitente.bairro       
               tt-pedido-compr-aux.cidade-emit-despach        = tt-emitente.cidade       
               tt-pedido-compr-aux.pais-emit-despach          = tt-emitente.pais         
               tt-pedido-compr-aux.cep-emit-despach           = tt-emitente.cep          
               tt-pedido-compr-aux.cgc-emit-despach           = tt-emitente.cgc          
               tt-pedido-compr-aux.estado-emit-despach        = tt-emitente.estado       
               tt-pedido-compr-aux.Ins-estadual-emit-despach  = tt-emitente.ins-estadual 
               tt-pedido-compr-aux.Ins-municipal-emit-despach = tt-emitente.ins-municipal
               tt-pedido-compr-aux.caixa-postal-emit-despach  = tt-emitente.caixa-postal  
               tt-pedido-compr-aux.e-mail-emit-despach        = tt-emitente.e-mail       
               tt-pedido-compr-aux.cod-aba-emit-despach       = tt-emitente.cod-aba      
               tt-pedido-compr-aux.telefone1-emit-despach     = tt-emitente.telefone[1]
               tt-pedido-compr-aux.telefone2-emit-despach     = tt-emitente.telefone[2]  
               tt-pedido-compr-aux.ramal1-emit-despach        = tt-emitente.ramal[1]     
               tt-pedido-compr-aux.ramal2-emit-despach        = tt-emitente.ramal[2]     
               tt-pedido-compr-aux.home-page-emit-despach     = tt-emitente.home-page    
               tt-pedido-compr-aux.telefax-emit-despach       = tt-emitente.telefax      
               tt-pedido-compr-aux.ramal-fax-emit-despach     = tt-emitente.ramal-fax    
               tt-pedido-compr-aux.telef-fac-emit-despach     = tt-emitente.telef-fac    
               tt-pedido-compr-aux.ramal-fac-emit-despach     = tt-emitente.ramal-fac    
               tt-pedido-compr-aux.telef-modem-emit-despach   = tt-emitente.telef-modem  
               tt-pedido-compr-aux.ramal-modem-emit-despach   = tt-emitente.ramal-modem.  

end procedure.

procedure getDespachExterno:

    run getDespachExterno in h-imapi009 (output table tt-emitente).

    find first tt-emitente no-error.
    if  avail  tt-emitente then
        assign tt-pedido-compr-aux.nome-despach-ext          = tt-emitente.nome-emit    
               tt-pedido-compr-aux.endereco-despach-ext      = tt-emitente.endereco     
               tt-pedido-compr-aux.bairro-despach-ext        = tt-emitente.bairro       
               tt-pedido-compr-aux.cidade-despach-ext        = tt-emitente.cidade       
               tt-pedido-compr-aux.pais-despach-ext          = tt-emitente.pais         
               tt-pedido-compr-aux.cep-despach-ext           = tt-emitente.cep          
               tt-pedido-compr-aux.cgc-despach-ext           = tt-emitente.cgc          
               tt-pedido-compr-aux.estado-despach-ext        = tt-emitente.estado       
               tt-pedido-compr-aux.ins-estadual-despach-ext  = tt-emitente.ins-estadual 
               tt-pedido-compr-aux.ins-municipal-despach-ext = tt-emitente.ins-municipal
               tt-pedido-compr-aux.caixa-postal-despach-ext  = tt-emitente.caixa-postal 
               tt-pedido-compr-aux.e-mail-despach-ext        = tt-emitente.e-mail       
               tt-pedido-compr-aux.cod-aba-despach-ext       = tt-emitente.cod-aba      
               tt-pedido-compr-aux.telefone1-despach-ext     = tt-emitente.telefone[1]
               tt-pedido-compr-aux.telefone2-despach-ext     = tt-emitente.telefone[2]  
               tt-pedido-compr-aux.ramal1-despach-ext        = tt-emitente.ramal[1]     
               tt-pedido-compr-aux.ramal2-despach-ext        = tt-emitente.ramal[2]     
               tt-pedido-compr-aux.home-page-despach-ext     = tt-emitente.home-page    
               tt-pedido-compr-aux.telefax-despach-ext       = tt-emitente.telefax      
               tt-pedido-compr-aux.ramal-fax-despach-ext     = tt-emitente.ramal-fax    
               tt-pedido-compr-aux.telef-fac-despach-ext     = tt-emitente.telef-fac    
               tt-pedido-compr-aux.ramal-fac-despach-ext     = tt-emitente.ramal-fac    
               tt-pedido-compr-aux.telef-modem-despach-ext   = tt-emitente.telef-modem  
               tt-pedido-compr-aux.ramal-modem-despach-ext   = tt-emitente.ramal-modem.  

end procedure.

procedure getEmitenteEntrega:

    /* Busca informacoes do Emitente de Entrega do Pedido */
    run getEmitenteEntrega in h-imapi009 (output table tt-emitente).

    find first tt-emitente no-error.
    if  avail  tt-emitente then
        assign tt-pedido-compr.nome-emit-entr          = tt-emitente.nome-emit
               tt-pedido-compr.endereco-emit-entr      = tt-emitente.endereco
               tt-pedido-compr.bairro-emit-entr        = tt-emitente.bairro
               tt-pedido-compr.cidade-emit-entr        = tt-emitente.cidade
               tt-pedido-compr.pais-emit-entr          = tt-emitente.pais
               tt-pedido-compr.cep-emit-entr           = tt-emitente.cep
               tt-pedido-compr.cgc-emit-entr           = tt-emitente.cgc
               tt-pedido-compr.estado-emit-entr        = tt-emitente.estado
               tt-pedido-compr.ins-estadual-emit-entr  = tt-emitente.ins-estadual
               tt-pedido-compr.ins-municipal-emit-entr = tt-emitente.ins-municipal
               tt-pedido-compr.caixa-postal-emit-entr  = tt-emitente.caixa-postal
               tt-pedido-compr.e-mail-emit-entr        = tt-emitente.e-mail
               tt-pedido-compr.cod-aba-emit-entr       = tt-emitente.cod-aba
               tt-pedido-compr.telefone1-emit-entr     = tt-emitente.telefone[1]
               tt-pedido-compr.telefone2-emit-entr     = tt-emitente.telefone[2]
               tt-pedido-compr.ramal1-emit-entr        = tt-emitente.ramal[1]
               tt-pedido-compr.ramal2-emit-entr        = tt-emitente.ramal[2]
               tt-pedido-compr.home-page-emit-entr     = tt-emitente.home-page
               tt-pedido-compr.telefax-emit-entr       = tt-emitente.telefax
               tt-pedido-compr.ramal-fax-emit-entr     = tt-emitente.ramal-fax
               tt-pedido-compr.telef-fac-emit-entr     = tt-emitente.telef-fac
               tt-pedido-compr.ramal-fac-emit-entr     = tt-emitente.ramal-fac
               tt-pedido-compr.telef-modem-emit-entr   = tt-emitente.telef-modem
               tt-pedido-compr.ramal-modem-emit-entr   = tt-emitente.ramal-modem.

end procedure.

procedure getEmitenteEstabCobr:

    /* Busca informacoes do Emitente do Estabelecimento de Cobranca do Pedido */
    run getEmitenteEstabCobr in h-imapi009 (output table tt-emitente).

    find first tt-emitente no-error.
    if  avail  tt-emitente then
        assign tt-pedido-compr.nome-emit-estab-cobr          = tt-emitente.nome-emit
               tt-pedido-compr.endereco-emit-estab-cobr      = tt-emitente.endereco
               tt-pedido-compr.bairro-emit-estab-cobr        = tt-emitente.bairro
               tt-pedido-compr.cidade-emit-estab-cobr        = tt-emitente.cidade
               tt-pedido-compr.pais-emit-estab-cobr          = tt-emitente.pais
               tt-pedido-compr.cep-emit-estab-cobr           = tt-emitente.cep
               tt-pedido-compr.cgc-emit-estab-cobr           = tt-emitente.cgc
               tt-pedido-compr.estado-emit-estab-cobr        = tt-emitente.estado
               tt-pedido-compr.ins-estadual-emit-estab-cobr  = tt-emitente.ins-estadual
               tt-pedido-compr.ins-municipal-emit-estab-cobr = tt-emitente.ins-municipal
               tt-pedido-compr.caixa-postal-emit-estab-cobr  = tt-emitente.caixa-postal
               tt-pedido-compr.e-mail-emit-estab-cobr        = tt-emitente.e-mail
               tt-pedido-compr.cod-aba-emit-estab-cobr       = tt-emitente.cod-aba
               tt-pedido-compr.telefone1-emit-estab-cobr     = tt-emitente.telefone[1]
               tt-pedido-compr.telefone2-emit-estab-cobr     = tt-emitente.telefone[2]
               tt-pedido-compr.ramal1-emit-estab-cobr        = tt-emitente.ramal[1]
               tt-pedido-compr.ramal2-emit-estab-cobr        = tt-emitente.ramal[2]
               tt-pedido-compr.home-page-emit-estab-cobr     = tt-emitente.home-page
               tt-pedido-compr.telefax-emit-estab-cobr       = tt-emitente.telefax
               tt-pedido-compr.ramal-fax-emit-estab-cobr     = tt-emitente.ramal-fax
               tt-pedido-compr.telef-fac-emit-estab-cobr     = tt-emitente.telef-fac
               tt-pedido-compr.ramal-fac-emit-estab-cobr     = tt-emitente.ramal-fac
               tt-pedido-compr.telef-modem-emit-estab-cobr   = tt-emitente.telef-modem
               tt-pedido-compr.ramal-modem-emit-estab-cobr   = tt-emitente.ramal-modem.

end procedure.

procedure getEmitenteEstabEntrega:

    /* Busca informacoes do Emitente do Estabelecimento de Entrega do Pedido */
    run getEmitenteEstabEntrega in h-imapi009 (output table tt-emitente).

    find first tt-emitente no-error.
    if  avail  tt-emitente then
        assign tt-pedido-compr.nome-emit-estab-entr          = tt-emitente.nome-emit
               tt-pedido-compr.endereco-emit-estab-entr      = tt-emitente.endereco
               tt-pedido-compr.bairro-emit-estab-entr        = tt-emitente.bairro
               tt-pedido-compr.cidade-emit-estab-entr        = tt-emitente.cidade
               tt-pedido-compr.pais-emit-estab-entr          = tt-emitente.pais
               tt-pedido-compr.cep-emit-estab-entr           = tt-emitente.cep
               tt-pedido-compr.cgc-emit-estab-entr           = tt-emitente.cgc
               tt-pedido-compr.estado-emit-estab-entr        = tt-emitente.estado
               tt-pedido-compr.ins-estadual-emit-estab-entr  = tt-emitente.ins-estadual
               tt-pedido-compr.ins-municipal-emit-estab-entr = tt-emitente.ins-municipal
               tt-pedido-compr.caixa-postal-emit-estab-entr  = tt-emitente.caixa-postal
               tt-pedido-compr.e-mail-emit-estab-entr        = tt-emitente.e-mail
               tt-pedido-compr.cod-aba-emit-estab-entr       = tt-emitente.cod-aba
               tt-pedido-compr.telefone1-emit-estab-entr     = tt-emitente.telefone[1]
               tt-pedido-compr.telefone2-emit-estab-entr     = tt-emitente.telefone[2]
               tt-pedido-compr.ramal1-emit-estab-entr        = tt-emitente.ramal[1]
               tt-pedido-compr.ramal2-emit-estab-entr        = tt-emitente.ramal[2]
               tt-pedido-compr.home-page-emit-estab-entr     = tt-emitente.home-page
               tt-pedido-compr.telefax-emit-estab-entr       = tt-emitente.telefax
               tt-pedido-compr.ramal-fax-emit-estab-entr     = tt-emitente.ramal-fax
               tt-pedido-compr.telef-fac-emit-estab-entr     = tt-emitente.telef-fac
               tt-pedido-compr.ramal-fac-emit-estab-entr     = tt-emitente.ramal-fac
               tt-pedido-compr.telef-modem-emit-estab-entr   = tt-emitente.telef-modem
               tt-pedido-compr.ramal-modem-emit-estab-entr   = tt-emitente.ramal-modem.

end procedure.

procedure getEmitenteEstabFis:

    run getEmitenteEstabFis in h-imapi009 (output table tt-emitente).

    find first tt-emitente no-error.
    if  avail  tt-emitente then
        assign tt-pedido-compr-aux.nome-emit-estab-fis          = tt-emitente.nome-emit    
               tt-pedido-compr-aux.endereco-emit-estab-fis      = tt-emitente.endereco     
               tt-pedido-compr-aux.bairro-emit-estab-fis        = tt-emitente.bairro       
               tt-pedido-compr-aux.cidade-emit-estab-fis        = tt-emitente.cidade       
               tt-pedido-compr-aux.pais-emit-estab-fis          = tt-emitente.pais         
               tt-pedido-compr-aux.cep-emit-estab-fis           = tt-emitente.cep          
               tt-pedido-compr-aux.cgc-emit-estab-fis           = tt-emitente.cgc          
               tt-pedido-compr-aux.estado-emit-estab-fis        = tt-emitente.estado       
               tt-pedido-compr-aux.Ins-estadual-emit-estab-fis  = tt-emitente.ins-estadual 
               tt-pedido-compr-aux.Ins-municipal-emit-estab-fis = tt-emitente.ins-municipal
               tt-pedido-compr-aux.caixa-postal-emit-estab-fis  = tt-emitente.caixa-postal 
               tt-pedido-compr-aux.e-mail-emit-estab-fis        = tt-emitente.e-mail       
               tt-pedido-compr-aux.cod-aba-emit-estab-fis       = tt-emitente.cod-aba      
               tt-pedido-compr-aux.telefone1-emit-estab-fis     = tt-emitente.telefone[1]  
               tt-pedido-compr-aux.telefone2-emit-estab-fis     = tt-emitente.telefone[2]  
               tt-pedido-compr-aux.ramal1-emit-estab-fis        = tt-emitente.ramal[1]     
               tt-pedido-compr-aux.ramal2-emit-estab-fis        = tt-emitente.ramal[2]     
               tt-pedido-compr-aux.home-page-emit-estab-fis     = tt-emitente.home-page    
               tt-pedido-compr-aux.telefax-emit-estab-fis       = tt-emitente.telefax      
               tt-pedido-compr-aux.ramal-fax-emit-estab-fis     = tt-emitente.ramal-fax    
               tt-pedido-compr-aux.telef-fac-emit-estab-fis     = tt-emitente.telef-fac    
               tt-pedido-compr-aux.ramal-fac-emit-estab-fis     = tt-emitente.ramal-fac    
               tt-pedido-compr-aux.telef-modem-emit-estab-fis   = tt-emitente.telef-modem  
               tt-pedido-compr-aux.ramal-modem-emit-estab-fis   = tt-emitente.ramal-modem.  

end procedure.

procedure getEmitenteEstabGest:

    /* Busca informacoes do Emitente do Estabelecimento Gestor do Pedido */
    run getEmitenteEstabGest in h-imapi009 (output table tt-emitente).

    find first tt-emitente no-error.
    if  avail  tt-emitente then
        assign tt-pedido-compr.nome-emit-estab-gest          = tt-emitente.nome-emit
               tt-pedido-compr.endereco-emit-estab-gest      = tt-emitente.endereco
               tt-pedido-compr.bairro-emit-estab-gest        = tt-emitente.bairro
               tt-pedido-compr.cidade-emit-estab-gest        = tt-emitente.cidade
               tt-pedido-compr.pais-emit-estab-gest          = tt-emitente.pais
               tt-pedido-compr.cep-emit-estab-gest           = tt-emitente.cep
               tt-pedido-compr.cgc-emit-estab-gest           = tt-emitente.cgc
               tt-pedido-compr.estado-emit-estab-gest        = tt-emitente.estado
               tt-pedido-compr.ins-estadual-emit-estab-gest  = tt-emitente.ins-estadual
               tt-pedido-compr.ins-municipal-emit-estab-gest = tt-emitente.ins-municipal
               tt-pedido-compr.caixa-postal-emit-estab-gest  = tt-emitente.caixa-postal
               tt-pedido-compr.e-mail-emit-estab-gest        = tt-emitente.e-mail
               tt-pedido-compr.cod-aba-emit-estab-gest       = tt-emitente.cod-aba
               tt-pedido-compr.telefone1-emit-estab-gest     = tt-emitente.telefone[1]
               tt-pedido-compr.telefone2-emit-estab-gest     = tt-emitente.telefone[2]
               tt-pedido-compr.ramal1-emit-estab-gest        = tt-emitente.ramal[1]
               tt-pedido-compr.ramal2-emit-estab-gest        = tt-emitente.ramal[2]
               tt-pedido-compr.home-page-emit-estab-gest     = tt-emitente.home-page
               tt-pedido-compr.telefax-emit-estab-gest       = tt-emitente.telefax
               tt-pedido-compr.ramal-fax-emit-estab-gest     = tt-emitente.ramal-fax
               tt-pedido-compr.telef-fac-emit-estab-gest     = tt-emitente.telef-fac
               tt-pedido-compr.ramal-fac-emit-estab-gest     = tt-emitente.ramal-fac
               tt-pedido-compr.telef-modem-emit-estab-gest   = tt-emitente.telef-modem
               tt-pedido-compr.ramal-modem-emit-estab-gest   = tt-emitente.ramal-modem.
    
end procedure.

procedure getEmitenteImportador:

    /* Busca informacoes do Emitente do Estabelecimento Importador */
    run getEmitenteImportador in h-imapi009 (output table tt-emitente).

    find first tt-emitente no-error.
    if  avail tt-emitente then
        assign tt-pedido-compr.nome-emit-import          = tt-emitente.nome-emit    
               tt-pedido-compr.endereco-emit-import      = tt-emitente.endereco     
               tt-pedido-compr.bairro-emit-import        = tt-emitente.bairro       
               tt-pedido-compr.cidade-emit-import        = tt-emitente.cidade       
               tt-pedido-compr.pais-emit-import          = tt-emitente.pais         
               tt-pedido-compr.cep-emit-import           = tt-emitente.cep          
               tt-pedido-compr.cgc-emit-import           = tt-emitente.cgc          
               tt-pedido-compr.estado-emit-import        = tt-emitente.estado       
               tt-pedido-compr.ins-estadual-emit-import  = tt-emitente.ins-estadual 
               tt-pedido-compr.ins-municipal-emit-import = tt-emitente.ins-municipal
               tt-pedido-compr.caixa-postal-emit-import  = tt-emitente.caixa-postal 
               tt-pedido-compr.e-mail-emit-import        = tt-emitente.e-mail       
               tt-pedido-compr.cod-aba-emit-import       = tt-emitente.cod-aba      
               tt-pedido-compr.telefone1-emit-import     = tt-emitente.telefone[1]  
               tt-pedido-compr.telefone2-emit-import     = tt-emitente.telefone[2]  
               tt-pedido-compr.ramal1-emit-import        = tt-emitente.ramal[1]     
               tt-pedido-compr.ramal2-emit-import        = tt-emitente.ramal[2]     
               tt-pedido-compr.home-page-emit-import     = tt-emitente.home-page    
               tt-pedido-compr.telefax-emit-import       = tt-emitente.telefax      
               tt-pedido-compr.ramal-fax-emit-import     = tt-emitente.ramal-fax    
               tt-pedido-compr.telef-fac-emit-import     = tt-emitente.telef-fac    
               tt-pedido-compr.ramal-fac-emit-import     = tt-emitente.ramal-fac    
               tt-pedido-compr.telef-modem-emit-import   = tt-emitente.telef-modem  
               tt-pedido-compr.ramal-modem-emit-import   = tt-emitente.ramal-modem.  

end procedure.

procedure getEstabelecimentoCobranca:

    /* Busca informacoes do Estabelecimento de Cobranca do Pedido */
    run getEstabelecimentoCobranca in h-imapi009 (output table tt-estabelec).

    find first tt-estabelec no-error.
    if  avail  tt-estabelec then
        assign tt-pedido-compr.nome-estab-cobr          = tt-estabelec.nome
               tt-pedido-compr.endereco-estab-cobr      = tt-estabelec.endereco
               tt-pedido-compr.bairro-estab-cobr        = tt-estabelec.bairro
               tt-pedido-compr.cidade-estab-cobr        = tt-estabelec.cidade
               tt-pedido-compr.pais-estab-cobr          = tt-estabelec.pais
               tt-pedido-compr.cep-estab-cobr           = tt-estabelec.cep
               tt-pedido-compr.cgc-estab-cobr           = tt-estabelec.cgc
               tt-pedido-compr.estado-estab-cobr        = tt-estabelec.estado
               tt-pedido-compr.ins-estadual-estab-cobr  = tt-estabelec.ins-estadual
               tt-pedido-compr.ins-municipal-estab-cobr = tt-estabelec.ins-municipal
               tt-pedido-compr.cod-suframa-estab-cobr   = tt-estabelec.cod-suframa.

end procedure.

procedure getEstabelecimentoEntrega:

    /* Busca informacoes do Estabelecimento de Entrega do Pedido */
    run getEstabelecimentoEntrega in h-imapi009 (output table tt-estabelec).

    find first tt-estabelec no-error.
    if  avail  tt-estabelec then
        assign tt-pedido-compr.nome-estab-entr          = tt-estabelec.nome
               tt-pedido-compr.endereco-estab-entr      = tt-estabelec.endereco
               tt-pedido-compr.bairro-estab-entr        = tt-estabelec.bairro
               tt-pedido-compr.cidade-estab-entr        = tt-estabelec.cidade
               tt-pedido-compr.pais-estab-entr          = tt-estabelec.pais
               tt-pedido-compr.cep-estab-entr           = tt-estabelec.cep
               tt-pedido-compr.cgc-estab-entr           = tt-estabelec.cgc
               tt-pedido-compr.estado-estab-entr        = tt-estabelec.estado
               tt-pedido-compr.ins-estadual-estab-entr  = tt-estabelec.ins-estadual
               tt-pedido-compr.ins-municipal-estab-entr = tt-estabelec.ins-municipal
               tt-pedido-compr.cod-suframa-estab-entr   = tt-estabelec.cod-suframa
               tt-pedido-compr.cod-emit-estab-entr      = tt-estabelec.cod-emitente.

end procedure.

procedure getEstabelecimentoFiscal:

    /* Busca informacoes do Estab Fiscal do Processo de Importacao */
    run getEstabelecimentoFiscal in h-imapi009 (output table tt-estabelec).

    find first tt-estabelec no-error.
    if  avail  tt-estabelec then
        assign tt-pedido-compr-aux.nome-estab-fis          = tt-estabelec.nome         
               tt-pedido-compr-aux.endereco-estab-fis      = tt-estabelec.endereco     
               tt-pedido-compr-aux.bairro-estab-fis        = tt-estabelec.bairro       
               tt-pedido-compr-aux.cidade-estab-fis        = tt-estabelec.cidade       
               tt-pedido-compr-aux.pais-estab-fis          = tt-estabelec.pais         
               tt-pedido-compr-aux.cep-estab-fis           = tt-estabelec.cep          
               tt-pedido-compr-aux.cgc-estab-fis           = tt-estabelec.cgc          
               tt-pedido-compr-aux.estado-estab-fis        = tt-estabelec.estado       
               tt-pedido-compr-aux.ins-estadual-estab-fis  = tt-estabelec.ins-estadual 
               tt-pedido-compr-aux.ins-municipal-estab-fis = tt-estabelec.ins-municipal
               tt-pedido-compr-aux.cod-suframa-estab-fis   = tt-estabelec.cod-suframa  
               tt-pedido-compr-aux.cod-emit-estab-fis      = tt-estabelec.cod-emitente. 

end procedure.

procedure getEstabelecimentoGestor:

    /* Busca informacoes do Estabelecimento Gestor do Pedido */
    run getEstabelecimentoGestor in h-imapi009 (output table tt-estabelec).

    find first tt-estabelec no-error.
    if  avail  tt-estabelec then
        assign tt-pedido-compr.nome-estab-gest          = tt-estabelec.nome
               tt-pedido-compr.endereco-estab-gest      = tt-estabelec.endereco
               tt-pedido-compr.bairro-estab-gest        = tt-estabelec.bairro
               tt-pedido-compr.cidade-estab-gest        = tt-estabelec.cidade
               tt-pedido-compr.pais-estab-gest          = tt-estabelec.pais
               tt-pedido-compr.cep-estab-gest           = tt-estabelec.cep
               tt-pedido-compr.cgc-estab-gest           = tt-estabelec.cgc
               tt-pedido-compr.estado-estab-gest        = tt-estabelec.estado
               tt-pedido-compr.ins-estadual-estab-gest  = tt-estabelec.ins-estadual
               tt-pedido-compr.ins-municipal-estab-gest = tt-estabelec.ins-municipal
               tt-pedido-compr.cod-suframa-estab-gest   = tt-estabelec.cod-suframa.

end procedure.

procedure getExportador:

    /* Busca informacoes do Exportador (fornecedor) */
    run getExportador in h-imapi009 (output table tt-emitente).

    find first tt-emitente no-error.
    if  avail  tt-emitente then
        assign tt-pedido-compr.nome-emit-export          = tt-emitente.nome-emit    
               tt-pedido-compr.endereco-emit-export      = tt-emitente.endereco     
               tt-pedido-compr.bairro-emit-export        = tt-emitente.bairro       
               tt-pedido-compr.cidade-emit-export        = tt-emitente.cidade       
               tt-pedido-compr.pais-emit-export          = tt-emitente.pais         
               tt-pedido-compr.cep-emit-export           = tt-emitente.cep          
               tt-pedido-compr.cgc-emit-export           = tt-emitente.cgc          
               tt-pedido-compr.estado-emit-export        = tt-emitente.estado       
               tt-pedido-compr.ins-estadual-emit-export  = tt-emitente.ins-estadual 
               tt-pedido-compr.ins-municipal-emit-export = tt-emitente.ins-municipal
               tt-pedido-compr.caixa-postal-emit-export  = tt-emitente.caixa-postal 
               tt-pedido-compr.e-mail-emit-export        = tt-emitente.e-mail       
               tt-pedido-compr.cod-aba-emit-export       = tt-emitente.cod-aba      
               tt-pedido-compr.telefone1-emit-export     = tt-emitente.telefone[1]
               tt-pedido-compr.telefone2-emit-export     = tt-emitente.telefone[2]  
               tt-pedido-compr.ramal1-emit-export        = tt-emitente.ramal[1]     
               tt-pedido-compr.ramal2-emit-export        = tt-emitente.ramal[2]     
               tt-pedido-compr.home-page-emit-export     = tt-emitente.home-page    
               tt-pedido-compr.telefax-emit-export       = tt-emitente.telefax      
               tt-pedido-compr.ramal-fax-emit-export     = tt-emitente.ramal-fax    
               tt-pedido-compr.telef-fac-emit-export     = tt-emitente.telef-fac    
               tt-pedido-compr.ramal-fac-emit-export     = tt-emitente.ramal-fac    
               tt-pedido-compr.telef-modem-emit-export   = tt-emitente.telef-modem  
               tt-pedido-compr.ramal-modem-emit-export   = tt-emitente.ramal-modem.  
                               
end procedure.

procedure getImportador:

    /* Busca informacoes do Importador (estabelecimento) */
    run getImportador in h-imapi009 (output table tt-estabelec).

    find first tt-estabelec no-error.
    if  avail tt-estabelec then
        assign  tt-pedido-compr.nome-import          = tt-estabelec.nome                
                tt-pedido-compr.endereco-import      = tt-estabelec.endereco            
                tt-pedido-compr.bairro-import        = tt-estabelec.bairro              
                tt-pedido-compr.cidade-import        = tt-estabelec.cidade              
                tt-pedido-compr.pais-import          = tt-estabelec.pais                
                tt-pedido-compr.cep-import           = tt-estabelec.cep                 
                tt-pedido-compr.cgc-import           = tt-estabelec.cgc                 
                tt-pedido-compr.estado-import        = tt-estabelec.estado              
                tt-pedido-compr.ins-estadual-import  = tt-estabelec.ins-estadual        
                tt-pedido-compr.ins-municipal-import = tt-estabelec.ins-municipal       
                tt-pedido-compr.cod-suframa-import   = tt-estabelec.cod-suframa
                tt-pedido-compr.cod-emit-import      = tt-estabelec.cod-emitente.

end procedure.

procedure getIncoterm:

    run getIncoterm in h-imapi009 (output table tt-inco-cx).

    find first tt-inco-cx no-error.
    if  avail  tt-inco-cx then
        assign tt-pedido-compr.desc-incoterm = tt-inco-cx.descricao    
               tt-pedido-compr.cod-incoterm  = tt-inco-cx.cod-incoterm. 

end procedure.

procedure getItinerario:

    run getItinerario in h-imapi009 (output table tt-itinerario).

    find first tt-itinerario no-error.
    if  avail  tt-itinerario then
        assign tt-pedido-compr.desc-itiner = tt-itinerario.descricao
               tt-pedido-compr.distancia   = tt-itinerario.distancia
               tt-pedido-compr.nr-dias     = tt-itinerario.nr-dias.  

end procedure.

procedure getMensagem:

    /* Busca informacoes da Mensagem do Pedido de Compra */
    run getMensagem in h-imapi009 (output table tt-mensagens).

    find first tt-mensagens no-error.
    if  avail  tt-mensagens then
        assign tt-pedido-compr.desc-mensagem-ped = tt-mensagens.descricao   
               tt-pedido-compr.texto-mensag-ped  = tt-mensagens.texto-mensag.

end procedure.

procedure getMensagemProc:

    /* Busca informacoes da Mensagem do Pedido de Compra */
    run getMensagem in h-imapi009 (output table tt-mensagens).

    find first tt-mensagens no-error.
    if  avail  tt-mensagens then
        assign tt-pedido-compr.desc-mensagem-proc = tt-mensagens.descricao   
               tt-pedido-compr.texto-mensag-proc  = tt-mensagens.texto-mensag.

end procedure.

procedure getPedidoCompra:

    /* Busca informacoes do Pedido de Compra */
    run getPedidoCompra in h-imapi009 (output table tt-pedido).

    find first tt-pedido no-error.
    if  avail  tt-pedido then do:
        assign tt-pedido-compr.num-ped-benef      = tt-pedido.num-ped-benef   
               tt-pedido-compr.data-pedido        = tt-pedido.data-pedido        
               tt-pedido-compr.cod-emitente       = tt-pedido.cod-emitente       
               tt-pedido-compr.end-entrega        = tt-pedido.end-entrega        
               tt-pedido-compr.end-cobranca       = tt-pedido.end-cobranca       
               tt-pedido-compr.cod-cond-pag       = tt-pedido.cod-cond-pag       
               tt-pedido-compr.cod-mens-ped       = tt-pedido.cod-mensagem       
               tt-pedido-compr.cod-estabel-gestor = tt-pedido.cod-estab-gestor 
               tt-pedido-compr.cod-emit-terc      = tt-pedido.cod-emit-terc      
               tt-pedido-compr.responsavel        = tt-pedido.responsavel
               tt-pedido-compr.cod-estabel        = tt-pedido.cod-estabel
               tt-pedido-compr.desc-situacao      = {ininc/i02in295.i 04 tt-pedido.situacao}
               tt-pedido-compr.desc-natureza      = {ininc/i01in295.i 04 tt-pedido.natureza}
               tt-pedido-compr.desc-frete         = {ininc/i03in295.i 04 tt-pedido.frete}.
        /* Traducao pelo idioma da sessao (dominios fixos) - Projeto Internacional */
        case trim(tt-pedido-compr.desc-natureza):
            when "Compra"         then do: {utp/ut-liter.i "Compra" * r}          assign tt-pedido-compr.desc-natureza = trim(return-value). end.
            when "Serviáo"        then do: {utp/ut-liter.i "Serviáo" * r}         assign tt-pedido-compr.desc-natureza = trim(return-value). end.
            when "Beneficiamento" then do: {utp/ut-liter.i "Beneficiamento" * r}  assign tt-pedido-compr.desc-natureza = trim(return-value). end.
        end case.

        case trim(tt-pedido-compr.desc-frete):
            when "Pago"    then do: {utp/ut-liter.i "Pago" * r}     assign tt-pedido-compr.desc-frete = trim(return-value). end.
            when "A Pagar" then do: {utp/ut-liter.i "A Pagar" * r}  assign tt-pedido-compr.desc-frete = trim(return-value). end.
        end case.

        case trim(tt-pedido-compr.desc-situacao):
            when "Impresso"     then do: {utp/ut-liter.i "Impresso" * r}      assign tt-pedido-compr.desc-situacao = trim(return-value). end.
            when "N∆o Impresso" then do: {utp/ut-liter.i "N∆o Impresso" * r}  assign tt-pedido-compr.desc-situacao = trim(return-value). end.
            when "Eliminado"    then do: {utp/ut-liter.i "Eliminado" * r}     assign tt-pedido-compr.desc-situacao = trim(return-value). end.
        end case.

        if  tt-param.l-traducao then do:
            /* traducoes gerais */
            {imp/im9998.i "tt-pedido-compr.desc-situacao" "tt-pedido-compr.desc-situacao" "processo-imp"}
            {imp/im9998.i "tt-pedido-compr.desc-natureza" "tt-pedido-compr.desc-natureza" "processo-imp"}
            {imp/im9998.i "tt-pedido-compr.desc-frete"    "tt-pedido-compr.desc-frete"    "processo-imp"}
        end.
    end.

end procedure.

procedure getPontosControleProcesso:

    run getPontosControleProcesso in h-imapi009 (output table tt-pontos-controle-pedido).

    find first tt-pontos-controle-pedido no-error.
    if  avail tt-pontos-controle-pedido then
        assign tt-pedido-compr-aux.pto-embarque         = tt-pontos-controle-pedido.pto-embarque        
               tt-pedido-compr-aux.desc-pto-embarque    = tt-pontos-controle-pedido.desc-pto-embarque   
               tt-pedido-compr-aux.pto-desembarque      = tt-pontos-controle-pedido.pto-desembarque     
               tt-pedido-compr-aux.desc-pto-desembarque = tt-pontos-controle-pedido.desc-pto-desembarque
               tt-pedido-compr-aux.data-prev-embarque   = tt-pontos-controle-pedido.data-prev-embarque.

end procedure.
              
procedure getProcessoImportacao:

    /* Busca informacoes do Processo de Importacao*/
    run getProcessoImportacao in h-imapi009 (output table tt-processo).

    find first tt-processo no-error.
    if  avail  tt-processo then do:
        assign tt-pedido-compr.nr-proc-imp                = tt-processo.nr-proc-imp                                   
               tt-pedido-compr.cod-itiner                 = tt-processo.cod-itiner                                    
               tt-pedido-compr.dt-emissao                 = tt-processo.dt-emissao                                    
               tt-pedido-compr.dt-implantacao             = tt-processo.dt-implantacao                                
               tt-pedido-compr.dt-autorizacao             = tt-processo.dt-autorizacao                                
               tt-pedido-compr.cod-despachante            = tt-processo.cod-despachante                               
               tt-pedido-compr.cod-exportador             = tt-processo.cod-exportador                                
               tt-pedido-compr.cod-consignatario          = tt-processo.cod-consignatario                             
               tt-pedido-compr.cod-transportador          = tt-processo.cod-transportador                             
               tt-pedido-compr.cod-estabel                = tt-processo.cod-estabel                                   
               tt-pedido-compr.carta-credito              = tt-processo.carta-credito                                 
               tt-pedido-compr.narrativa                  = tt-processo.narrativa 
               tt-pedido-compr.cod-banco                  = tt-processo.cod-banco                                     
               tt-pedido-compr.nr-rof                     = tt-processo.nr-rof                                        
               tt-pedido-compr.estab-fisc                 = tt-processo.estab-fisc     
               tt-pedido-compr.contrato-cambio            = tt-processo.contrato-cambio
               tt-pedido-compr.cod-idioma                 = tt-processo.cod-idioma     
               tt-pedido-compr.cod-agente                 = tt-processo.cod-agente                 
               tt-pedido-compr.cod-mens-proc-imp          = tt-processo.cod-mensagem               
               tt-pedido-compr.texto-mens-proc-imp        = tt-processo.texto-mensag               
               tt-pedido-compr.destino-documentacao       = substr(tt-processo.char-1,1,40)
               tt-pedido-compr.cdn-corretor-cambio-import = tt-processo.cdn-corretor-cambio-import 
               tt-pedido-compr.cdn-despa-exter-import     = tt-processo.cdn-despa-exter-import     
               tt-pedido-compr.cdn-segurad-import         = tt-processo.cdn-segurad-import         
               tt-pedido-compr.cdn-corretor-import        = tt-processo.cdn-corretor-import
               tt-pedido-compr.desc-via-transp            = {adinc/i01ad268.i 04 tt-processo.via-transp}
               tt-pedido-compr.situacao-proc-imp          = {cxinc/i01cx140.i 04 tt-processo.situacao}.
        /* Traducao pelo idioma da sessao (dominios fixos) - Projeto Internacional */
        case trim(tt-pedido-compr.desc-via-transp):
            when "Rodovi†rio"      then do: {utp/ut-liter.i "Rodovi†rio" * r}       assign tt-pedido-compr.desc-via-transp = trim(return-value). end.
            when "Aerovi†rio"      then do: {utp/ut-liter.i "Aerovi†rio" * r}       assign tt-pedido-compr.desc-via-transp = trim(return-value). end.
            when "Mar°timo"        then do: {utp/ut-liter.i "Mar°timo" * r}         assign tt-pedido-compr.desc-via-transp = trim(return-value). end.
            when "Ferrovi†rio"     then do: {utp/ut-liter.i "Ferrovi†rio" * r}      assign tt-pedido-compr.desc-via-transp = trim(return-value). end.
            when "Rodoferrovi†rio" then do: {utp/ut-liter.i "Rodoferrovi†rio" * r}  assign tt-pedido-compr.desc-via-transp = trim(return-value). end.
            when "Rodofluvial"     then do: {utp/ut-liter.i "Rodofluvial" * r}      assign tt-pedido-compr.desc-via-transp = trim(return-value). end.
            when "Rodoaerovi†rio"  then do: {utp/ut-liter.i "Rodoaerovi†rio" * r}   assign tt-pedido-compr.desc-via-transp = trim(return-value). end.
            when "Outros"          then do: {utp/ut-liter.i "Outros" * r}           assign tt-pedido-compr.desc-via-transp = trim(return-value). end.
        end case.

        case trim(tt-pedido-compr.situacao-proc-imp):
            when "N∆o Embarcado"     then do: {utp/ut-liter.i "N∆o Embarcado" * r}     assign tt-pedido-compr.situacao-proc-imp = trim(return-value). end.
            when "Embarcado Parcial" then do: {utp/ut-liter.i "Embarcado Parcial" * r} assign tt-pedido-compr.situacao-proc-imp = trim(return-value). end.
            when "Embarcado Total"   then do: {utp/ut-liter.i "Embarcado Total" * r}   assign tt-pedido-compr.situacao-proc-imp = trim(return-value). end.
            when "Encerrado"         then do: {utp/ut-liter.i "Encerrado" * r}         assign tt-pedido-compr.situacao-proc-imp = trim(return-value). end.
        end case.

        if  tt-param.l-traducao then do:
            {imp/im9998.i "tt-pedido-compr.situacao-proc-imp" "tt-pedido-compr.situacao-proc-imp" "tt-processo"}

            find trad-via-transp
                where trad-via-transp.cod-via-transp = processo-imp.via-transp
                and   trad-via-transp.cod-idioma     = processo-imp.cod-idioma no-lock no-error.
            if  avail trad-via-trans then 
                assign tt-pedido-compr.desc-via-transp = trad-via-transp.tr-desc-via-transp.
        end.
    end.
               
end procedure.

procedure getSeguradora:

    run getSeguradora in h-imapi009 (output table tt-emitente).

    find first tt-emitente no-error.
    if  avail  tt-emitente then
        assign tt-pedido-compr-aux.nome-segurad          = tt-emitente.nome-emit    
               tt-pedido-compr-aux.endereco-segurad      = tt-emitente.endereco     
               tt-pedido-compr-aux.bairro-segurad        = tt-emitente.bairro       
               tt-pedido-compr-aux.cidade-segurad        = tt-emitente.cidade       
               tt-pedido-compr-aux.pais-segurad          = tt-emitente.pais         
               tt-pedido-compr-aux.cep-segurad           = tt-emitente.cep          
               tt-pedido-compr-aux.cgc-segurad           = tt-emitente.cgc          
               tt-pedido-compr-aux.estado-segurad        = tt-emitente.estado       
               tt-pedido-compr-aux.ins-estadual-segurad  = tt-emitente.ins-estadual 
               tt-pedido-compr-aux.ins-municipal-segurad = tt-emitente.ins-municipal
               tt-pedido-compr-aux.caixa-postal-segurad  = tt-emitente.caixa-postal 
               tt-pedido-compr-aux.e-mail-segurad        = tt-emitente.e-mail       
               tt-pedido-compr-aux.cod-aba-segurad       = tt-emitente.cod-aba      
               tt-pedido-compr-aux.telefone1-segurad     = tt-emitente.telefone[1]
               tt-pedido-compr-aux.telefone2-segurad     = tt-emitente.telefone[2]  
               tt-pedido-compr-aux.ramal1-segurad        = tt-emitente.ramal[1]     
               tt-pedido-compr-aux.ramal2-segurad        = tt-emitente.ramal[2]     
               tt-pedido-compr-aux.home-page-segurad     = tt-emitente.home-page    
               tt-pedido-compr-aux.telefax-segurad       = tt-emitente.telefax      
               tt-pedido-compr-aux.ramal-fax-segurad     = tt-emitente.ramal-fax    
               tt-pedido-compr-aux.telef-fac-segurad     = tt-emitente.telef-fac    
               tt-pedido-compr-aux.ramal-fac-segurad     = tt-emitente.ramal-fac    
               tt-pedido-compr-aux.telef-modem-segurad   = tt-emitente.telef-modem  
               tt-pedido-compr-aux.ramal-modem-segurad   = tt-emitente.ramal-modem.  

end procedure.                                        
                                                      
procedure getTransportador:                           

    /* Busca informacoes do Transportador do Processo de Importacao */
    run getTransportador in h-imapi009 (output table tt-transporte).

    find first tt-transporte no-error.
    if  avail  tt-transporte then do:

        assign tt-pedido-compr-aux.nome-transp          = tt-transporte.nome         
               tt-pedido-compr-aux.nome-abrev-transp    = tt-transporte.nome-abrev   
               tt-pedido-compr-aux.endereco-transp      = tt-transporte.endereco     
               tt-pedido-compr-aux.bairro-transp        = tt-transporte.bairro       
               tt-pedido-compr-aux.cidade-transp        = tt-transporte.cidade       
               tt-pedido-compr-aux.pais-transp          = tt-transporte.pais         
               tt-pedido-compr-aux.cep-transp           = tt-transporte.cep          
               tt-pedido-compr-aux.cgc-transp           = tt-transporte.cgc          
               tt-pedido-compr-aux.estado-transp        = tt-transporte.estado       
               tt-pedido-compr-aux.ins-estadual-transp  = tt-transporte.ins-estadual 
               tt-pedido-compr-aux.caixa-postal-transp  = tt-transporte.cx-postal    
               tt-pedido-compr-aux.contato-transp       = tt-transporte.contato      
               tt-pedido-compr-aux.telefone-transp      = tt-transporte.telefone     
               tt-pedido-compr-aux.ramal-transp         = tt-transporte.ramal        
               tt-pedido-compr-aux.telefax-transp       = tt-transporte.telefax      
               tt-pedido-compr-aux.telex-transp         = tt-transporte.telex        
               tt-pedido-compr-aux.ins-municipal-transp = tt-transporte.ins-municipal
               tt-pedido-compr-aux.zip-code-transp      = tt-transporte.zip-code     
               tt-pedido-compr-aux.e-mail-transp        = tt-transporte.e-mail       
               tt-pedido-compr-aux.telef-modem-transp   = tt-transporte.telef-modem  
               tt-pedido-compr-aux.home-page-transp     = tt-transporte.home-page    
               tt-pedido-compr-aux.ramal-modem-transp   = tt-transporte.ramal-modem  
               tt-pedido-compr-aux.ramal-fax-transp     = tt-transporte.ramal-fax.    
           
        if  tt-transporte.cod-transp = 0 then
            assign tt-pedido-compr-aux.pais-transp = "".
    end.
                               
end procedure.

procedure piGeraPedidoCompra:

    if  not can-find (first tt-pedido-compr
                      where tt-pedido-compr.num-pedido = pedido-compr.num-pedido) then do:

        create tt-pedido-compr.
        assign tt-pedido-compr.num-pedido = pedido-compr.num-pedido.

        create tt-pedido-compr-aux.
        assign tt-pedido-compr-aux.num-pedido = pedido-compr.num-pedido
               tt-pedido-compr-aux.cod-idioma = processo-imp.cod-idioma.

        create tt-pedido-compr-aux2.
        assign tt-pedido-compr-aux2.num-pedido = pedido-compr.num-pedido.

        run setConstraintPedidoCompr in h-imapi009 (input rowid(pedido-compr)).

        /* Busca informacoes do Pedido de Compra */
        run getPedidoCompra.

        /* Busca informacoes do Emitente de Entrega do Pedido */
        run getEmitenteEntrega.
    
        /* Busca informacoes do Estabelecimento de Entrega do Pedido */
        run getEstabelecimentoEntrega.
    
        /* Busca informacoes do Emitente do Estabelecimento de Entrega do Pedido */
        run getEmitenteEstabEntrega.

        /* Busca informacoes do Estabelecimento de Cobranca do Pedido */
        run getEstabelecimentoCobranca.

        /* Busca informacoes do Emitente do Estabelecimento de Cobranca do Pedido */
        run getEmitenteEstabCobr.

        /* Busca informacoes do Estabelecimento Gestor do Pedido */
        run getEstabelecimentoGestor.

        /* Busca informacoes do Emitente do Estabelecimento Gestor do Pedido */
        run getEmitenteEstabGest.

        /* Busca informacoes das Condicoes de Pagamento do Pedido */
        run getCondicaoPagamento.
    
        /* Busca informacoes da Mensagem do Pedido de Compra */
        run getMensagem.
    
        run setConstraintProcessoImp in h-imapi009 (input rowid(processo-imp)).
    
        /* Busca informacoes do Processo de Importacao*/
        run getProcessoImportacao.
    
        /* Busca informacoes do Importador (estabelecimento) */
        run getImportador.
    
        /* Busca informacoes do Emitente do Estabelecimento Importador */
        run getEmitenteImportador.
    
        /* Busca informacoes do Exportador (fornecedor) */
        run getExportador.
    
        run getIncoterm.
        
        run getItinerario.

        /* Busca informacoes da Mensagem do Processo de Importacao */
        run getMensagemProc.
    
        /* Busca informacoes do Transportador do Processo de Importacao */
        run getTransportador.
    
        /* Busca informacoes do Despachante do Processo de Importacao */
        run getDespachante.
    
        /* Busca informacoes do Agente de Cargas do Processo de Importacao */
        run getAgenteCargas.
    
        run getCorretorCambio.
    
        run getDespachExterno.
    
        run getSeguradora.
    
        run getCorretorImport.
    
        /* Busca informacoes do Banco do Processo de Importacao */
        run getBanco.
    
        run getAgenciaBanco.
    
        run getConsignatario.

        /* Busca informacoes do Estab Fiscal do Processo de Importacao */
        run getEstabelecimentoFiscal.
    
        run getEmitenteEstabFis.
    
        run getAssinaturas.
        
        run getPontosControleProcesso.
        
    end.
end.
/* FIM - GERACAO PEDIDO-COMPR */
/* PROCEDURE GERACAO ORDEM-COMPRA */
procedure getCalculosOrdemCompra:

    run getCalculosOrdemCompra in h-imapi009 (output table tt-calculos-ordem).

    find first tt-calculos-ordem no-error.
    if  avail tt-calculos-ordem then 
        assign tt-ordem-compra.peso-liquido-total      = tt-calculos-ordem.peso-liquido-total         
               tt-ordem-compra.peso-bruto-total        = tt-calculos-ordem.peso-bruto-total           
               tt-ordem-compra.preco-fornec-liq        = tt-calculos-ordem.preco-fornec-liq           
               tt-ordem-compra.preco-interno-liq       = tt-calculos-ordem.preco-interno-liq          
               tt-ordem-compra.preco-fornec-bru        = tt-calculos-ordem.preco-fornec-bru           
               tt-ordem-compra.preco-interno-bru       = tt-calculos-ordem.preco-interno-bru          
               tt-ordem-compra.preco-fornec-liq-total  = tt-calculos-ordem.preco-fornec-liq-total    
               tt-ordem-compra.preco-interno-liq-total = tt-calculos-ordem.preco-interno-liq-total   
               tt-ordem-compra.preco-fornec-bru-total  = tt-calculos-ordem.preco-fornec-bru-total    
               tt-ordem-compra.preco-interno-bru-total = tt-calculos-ordem.preco-interno-bru-total   
               tt-ordem-compra.ocupacao-total          = tt-calculos-ordem.ocupacao-total.

    /* Converte valor do descto para a moeda informada na tela */
    run cdp/cd0812.p (input cotacao-item.mo-codigo,
                      input tt-param.i-moeda,
                      input tt-ordem-compra.valor-descto,
                      input today,
                      output de-valor-descto-conv).

    if  de-valor-descto-conv = 0 
    or  de-valor-descto-conv = ? then
        assign de-valor-descto-conv = tt-ordem-compra.valor-descto.

    /* Converte para a moeda informada na tela */
    run cdp/cd0812.p (input cotacao-item.mo-codigo,
                      input tt-param.i-moeda,
                      input tt-ordem-compra.preco-fornec-liq,
                      input today,
                      output de-preco-fornec-liq-conv).

    if  de-preco-fornec-liq-conv = 0
    or  de-preco-fornec-liq-conv = ? then
        assign de-preco-fornec-liq-conv = tt-ordem-compra.preco-fornec-liq.

    /* Converte para a moeda informada na tela */
    run cdp/cd0812.p (input cotacao-item.mo-codigo,
                      input tt-param.i-moeda,
                      input tt-ordem-compra.preco-interno-liq,
                      input today,
                      output de-preco-interno-liq-conv).

    if  de-preco-interno-liq-conv = 0
    or  de-preco-interno-liq-conv = ? then
        assign de-preco-interno-liq-conv = tt-ordem-compra.preco-interno-liq.

    /* Converte para a moeda informada na tela */
    run cdp/cd0812.p (input cotacao-item.mo-codigo,
                      input tt-param.i-moeda,
                      input tt-ordem-compra.preco-fornec-bru,
                      input today,
                      output de-preco-fornec-bru-conv).

    if  de-preco-fornec-bru-conv = 0
    or  de-preco-fornec-bru-conv = ? then
        assign de-preco-fornec-bru-conv = tt-ordem-compra.preco-fornec-bru.

    /* Converte para a moeda informada na tela */
    run cdp/cd0812.p (input cotacao-item.mo-codigo,
                      input tt-param.i-moeda,
                      input tt-ordem-compra.preco-interno-bru,
                      input today,
                      output de-preco-interno-bru-conv).

    if  de-preco-interno-bru-conv = 0
    or  de-preco-interno-bru-conv = ? then
        assign de-preco-interno-bru-conv = tt-ordem-compra.preco-interno-bru.

    /* Converte para a moeda informada na tela */
    run cdp/cd0812.p (input cotacao-item.mo-codigo,
                      input tt-param.i-moeda,
                      input tt-ordem-compra.preco-fornec-liq-total,
                      input today,
                      output de-preco-fornec-liq-total-conv).

    if  de-preco-fornec-liq-total-conv = 0
    or  de-preco-fornec-liq-total-conv = ? then
        assign de-preco-fornec-liq-total-conv = tt-ordem-compra.preco-fornec-liq-total.

    /* Converte para a moeda informada na tela */
    run cdp/cd0812.p (input cotacao-item.mo-codigo,
                      input tt-param.i-moeda,
                      input tt-ordem-compra.preco-interno-liq-total,
                      input today,
                      output de-preco-interno-liq-total-conv).

    if  de-preco-interno-liq-total-conv = 0
    or  de-preco-interno-liq-total-conv = ? then
        assign de-preco-interno-liq-total-conv = tt-ordem-compra.preco-interno-liq-total.

    /* Converte para a moeda informada na tela */
    run cdp/cd0812.p (input cotacao-item.mo-codigo,
                      input tt-param.i-moeda,
                      input tt-ordem-compra.preco-fornec-bru-total,
                      input today,
                      output de-preco-fornec-bru-total-conv).

    if  de-preco-fornec-bru-total-conv = 0
    or  de-preco-fornec-bru-total-conv = ? then
        assign de-preco-fornec-bru-total-conv = tt-ordem-compra.preco-fornec-bru-total.

    /* Converte para a moeda informada na tela */
    run cdp/cd0812.p (input cotacao-item.mo-codigo,
                      input tt-param.i-moeda,
                      input tt-ordem-compra.preco-interno-bru-total,
                      input today,
                      output de-preco-interno-bru-total-conv).

    if  de-preco-interno-bru-total-conv = 0
    or  de-preco-interno-bru-total-conv = ? then
        assign de-preco-interno-bru-total-conv = tt-ordem-compra.preco-interno-bru-total.

    assign tt-ordem-compra.valor-descto-mo-inf            = de-valor-descto-conv
           tt-ordem-compra.preco-fornec-liq-mo-inf        = de-preco-fornec-liq-conv
           tt-ordem-compra.preco-interno-liq-mo-inf       = de-preco-interno-liq-conv
           tt-ordem-compra.preco-fornec-bru-mo-inf        = de-preco-fornec-bru-conv
           tt-ordem-compra.preco-interno-bru-mo-inf       = de-preco-interno-bru-conv
           tt-ordem-compra.preco-fornec-liq-total-mo-inf  = de-preco-fornec-liq-total-conv
           tt-ordem-compra.preco-interno-liq-total-mo-inf = de-preco-interno-liq-total-conv
           tt-ordem-compra.preco-fornec-bru-total-mo-inf  = de-preco-fornec-bru-total-conv
           tt-ordem-compra.preco-interno-bru-total-mo-inf = de-preco-interno-bru-total-conv.

end procedure.

procedure getCotacaoItem:

    run getCotacaoItem in h-imapi009 (output table tt-cotacao-item).

    find first tt-cotacao-item no-error.
    if  avail  tt-cotacao-item then
        assign tt-ordem-compra.cod-pto-contr-base = int(substr(tt-cotacao-item.char-1,41,20))
               tt-ordem-compra.aliquota-ii        = dec(substr(tt-cotacao-item.char-1,61,20))
               tt-ordem-compra.regime-import      = int(substr(tt-cotacao-item.char-2,61,20)) 
               tt-ordem-compra.Un-fornec          = tt-cotacao-item.un           
               tt-ordem-compra.cdn-pais-orig      = tt-cotacao-item.cdn-pais-orig
               tt-ordem-compra.cod-fabricante     = int(substr(tt-cotacao-item.char-2,41,20))
               tt-ordem-compra.class-fiscal       = string(SUBSTRING(tt-cotacao-item.char-1,81,20),"9999.99.99"). 
   

end procedure.

procedure getEmbalag:

    run getEmbalag in h-imapi009 (output table tt-embalag).

    find first tt-embalag no-error.
    if  avail tt-embalag then
        assign tt-ordem-compra.sigla-embalag = tt-embalag.sigla-emb 
               tt-ordem-compra.desc-embalag  = tt-embalag.descricao 
               tt-ordem-compra.peso-embalag  = tt-embalag.peso-embal.

end procedure.

procedure getFabricante:

    run getFabricante in h-imapi009 (output table tt-emitente).

    find first tt-emitente no-error.
    if  avail  tt-emitente then
        assign tt-ordem-compra.nome-fabric          = tt-emitente.nome-emit    
               tt-ordem-compra.endereco-fabric      = tt-emitente.endereco     
               tt-ordem-compra.bairro-fabric        = tt-emitente.bairro       
               tt-ordem-compra.cidade-fabric        = tt-emitente.cidade       
               tt-ordem-compra.pais-fabric          = tt-emitente.pais         
               tt-ordem-compra.cep-fabric           = tt-emitente.cep          
               tt-ordem-compra.cgc-fabric           = tt-emitente.cgc          
               tt-ordem-compra.estado-fabric        = tt-emitente.estado       
               tt-ordem-compra.Ins-estadual-fabric  = tt-emitente.ins-estadual 
               tt-ordem-compra.Ins-municipal-fabric = tt-emitente.ins-municipal
               tt-ordem-compra.caixa-postal-fabric  = tt-emitente.caixa-postal 
               tt-ordem-compra.e-mail-fabric        = tt-emitente.e-mail       
               tt-ordem-compra.cod-aba-fabric       = tt-emitente.cod-aba      
               tt-ordem-compra.telefone1-fabric     = tt-emitente.telefone[1]  
               tt-ordem-compra.telefone2-fabric     = tt-emitente.telefone[2]  
               tt-ordem-compra.ramal1-fabric        = tt-emitente.ramal[1]     
               tt-ordem-compra.ramal2-fabric        = tt-emitente.ramal[2]     
               tt-ordem-compra.home-page-fabric     = tt-emitente.home-page    
               tt-ordem-compra.telefax-fabric       = tt-emitente.telefax      
               tt-ordem-compra.ramal-fax-fabric     = tt-emitente.ramal-fax    
               tt-ordem-compra.telef-fac-fabric     = tt-emitente.telef-fac    
               tt-ordem-compra.ramal-fac-fabric     = tt-emitente.ramal-fac    
               tt-ordem-compra.telef-modem-fabric   = tt-emitente.telef-modem  
               tt-ordem-compra.ramal-modem-fabric   = tt-emitente.ramal-modem.  

end procedure.

procedure getFamComerc:

    run getFamComerc in h-imapi009 (output table tt-fam-comerc).

    find first tt-fam-comerc no-error.
    if  avail  tt-fam-comerc then
        assign tt-ordem-compra.desc-fam-comerc = tt-fam-comerc.descricao.

end procedure.

procedure getFamilia:

    run getFamilia in h-imapi009 (output table tt-familia).

    find first tt-familia no-error.
    if  avail  tt-familia then
        assign tt-ordem-compra.desc-familia = tt-familia.descricao.

end procedure.

procedure getGrupoEstoque:

    run getGrupoEstoque in h-imapi009 (output table tt-grup-estoq).

    find first tt-grup-estoq no-error.
    if  avail  tt-grup-estoq then
        assign tt-ordem-compra.desc-grup-estoq = tt-grup-estoq.descricao.

end procedure.


procedure getItem:

    run getItem in h-imapi009 (output table tt-item).

    find first tt-item no-error.
    if  avail tt-item then
        assign tt-ordem-compra.desc-item     = tt-item.desc-item    
               tt-ordem-compra.peso-liquido  = tt-item.peso-liquido 
               tt-ordem-compra.peso-bruto    = tt-item.peso-bruto   
               tt-ordem-compra.altura        = tt-item.altura       
               tt-ordem-compra.comprim       = tt-item.comprim      
               tt-ordem-compra.largura       = tt-item.largura      
               tt-ordem-compra.Ge-codigo     = tt-item.ge-codigo    
               tt-ordem-compra.Fm-codigo     = tt-item.fm-codigo    
               tt-ordem-compra.Fm-cod-com    = tt-item.fm-cod-com   
               tt-ordem-compra.Un            = tt-item.un.

end procedure.

procedure getItemFornec:
    define variable cItemDoForn like item-fornec.item-do-forn no-undo.

    run getItemFornec in h-imapi009 (output table tt-item-fornec).

    find first tt-item-fornec no-error.
    if  avail  tt-item-fornec then do:
        assign tt-ordem-compra.item-fornec         = tt-item-fornec.item-do-forn
               tt-ordem-compra.cod-embal           = tt-item-fornec.cod-embal   
               tt-ordem-compra.fator-conver        = tt-item-fornec.fator-conver
               tt-ordem-compra.num-casa-dec        = tt-item-fornec.num-casa-dec 
               tt-ordem-compra.narrat-item-fornec  = tt-item-fornec.narrativa.    

        for first item-fornec fields (item-do-forn)
            where item-fornec.it-codigo    = ordem-compra.it-codigo
            and   item-fornec.cod-emitente = ordem-compra.cod-emitente no-lock: end.
        if  avail item-fornec then do:

            assign cItemDoForn = item-fornec.item-do-forn.

            if  cItemDoForn <> "" then do:
            
                for first item fields (desc-item) 
                    where item.it-codigo = item-fornec.item-do-forn no-lock: end.
                if  avail item THEN 
                    assign tt-ordem-compra.desc-item-fornec = item.desc-item .
                else do:
        
                    for first item fields (desc-item)
                        where item.it-codigo = ordem-compra.it-codigo no-lock: end.
                    if  avail item then
                        assign tt-ordem-compra.desc-item-fornec = item.desc-item.
                end.
            end.
            else
                assign tt-ordem-compra.desc-item-fornec = "".
        end.

        if  tt-param.l-traducao then do:

            if  cItemDoForn <> "" then do:

                find traduc-item
                    where traduc-item.it-codigo    = cItemDoForn
                    and   traduc-item.cod-idioma   = processo-imp.cod-idioma
                    and   traduc-item.cod-emitente = tt-ordem-compra.cod-fabricante no-lock no-error.
                if  avail traduc-item then
                    assign tt-ordem-compra.item-fornec      = traduc-item.tr-it-codigo
                           tt-ordem-compra.desc-item-fornec = traduc-item.tr-desc-item.
    
                else do:
                    find traduc-item
                        where traduc-item.it-codigo    = cItemDoForn
                        and   traduc-item.cod-idioma   = processo-imp.cod-idioma
                        and   traduc-item.cod-emitente = pedido-compr.cod-emitente no-lock no-error.
                    if  avail traduc-item then
                        assign tt-ordem-compra.item-fornec      = traduc-item.tr-it-codigo
                               tt-ordem-compra.desc-item-fornec = traduc-item.tr-desc-item.
    
                    else do:
                        find traduc-item
                            where traduc-item.it-codigo    = cItemDoForn
                            and   traduc-item.cod-idioma   = processo-imp.cod-idioma
                            and   traduc-item.cod-emitente = 0 no-lock no-error.
                        if  avail traduc-item then
                            assign tt-ordem-compra.item-fornec      = traduc-item.tr-it-codigo
                                   tt-ordem-compra.desc-item-fornec = traduc-item.tr-desc-item.
    
                        else do:
                            find traduc-item
                                where traduc-item.it-codigo    = ordem-compra.it-codigo
                                and   traduc-item.cod-idioma   = processo-imp.cod-idioma
                                and   traduc-item.cod-emitente = tt-ordem-compra.cod-fabricante no-lock no-error.
                            if  avail traduc-item then
                                assign tt-ordem-compra.item-fornec      = traduc-item.tr-it-codigo
                                       tt-ordem-compra.desc-item-fornec = traduc-item.tr-desc-item.
                
                            else do:
                                find traduc-item
                                    where traduc-item.it-codigo    = ordem-compra.it-codigo
                                    and   traduc-item.cod-idioma   = processo-imp.cod-idioma
                                    and   traduc-item.cod-emitente = pedido-compr.cod-emitente no-lock no-error.
                                if  avail traduc-item then
                                    assign tt-ordem-compra.item-fornec      = traduc-item.tr-it-codigo
                                           tt-ordem-compra.desc-item-fornec = traduc-item.tr-desc-item.
                
                                else do:
                                    find traduc-item
                                        where traduc-item.it-codigo    = ordem-compra.it-codigo
                                        and   traduc-item.cod-idioma   = processo-imp.cod-idioma
                                        and   traduc-item.cod-emitente = 0 no-lock no-error.
                                    if  avail traduc-item then
                                        assign tt-ordem-compra.item-fornec      = traduc-item.tr-it-codigo
                                               tt-ordem-compra.desc-item-fornec = traduc-item.tr-desc-item.
                                end.
                            end.
                        end.
                    end.
                end.
            end.
            else
                assign tt-ordem-compra.desc-item-fornec = "".
        end.
    end.

end procedure.

procedure getMoeda:

    run getMoeda in h-imapi009 (output table tt-moeda).

    find first tt-moeda no-error.
    if  avail  tt-moeda then
        assign tt-ordem-compra.desc-moeda  = tt-moeda.descricao
               tt-ordem-compra.sigla-moeda = tt-moeda.sigla.

end procedure.

procedure getNarrativa:

    run getNarrativa in h-imapi009 (output table tt-narrativa).

    find first tt-narrativa no-error.
    if  avail  tt-narrativa then
        assign tt-ordem-compra.narrativa = tt-narrativa.descricao.

end procedure.

procedure getOrdensCompra:

    run getOrdensCompra in h-imapi009 (output table tt-ordens).

    find first tt-ordens no-error.
    if  avail  tt-ordens then
        assign tt-ordem-compra.It-codigo          = tt-ordens.it-codigo      
               tt-ordem-compra.data-emissao       = tt-ordens.data-emissao   
               tt-ordem-compra.narrat-ordem       = tt-ordens.narrativa      
               tt-ordem-compra.data-cotacao       = tt-ordens.data-cotacao   
               tt-ordem-compra.Mo-codigo          = tt-ordens.mo-codigo      
               tt-ordem-compra.aliquota-ipi-ordem = tt-ordens.aliquota-ipi   
               tt-ordem-compra.taxa-financ        = tt-ordens.taxa-financ    
               tt-ordem-compra.valor-taxa         = tt-ordens.valor-taxa     
               tt-ordem-compra.perc-descto        = tt-ordens.perc-descto    
               tt-ordem-compra.prazo-entreg       = tt-ordens.prazo-entreg   
               tt-ordem-compra.contato            = tt-ordens.contato        
               tt-ordem-compra.data-atualiz       = tt-ordens.data-atualiz   
               tt-ordem-compra.hora-atualiz       = tt-ordens.hora-atualiz   
               tt-ordem-compra.cod-refer          = tt-ordens.cod-refer      
               tt-ordem-compra.valor-descto       = tt-ordens.valor-descto   
               tt-ordem-compra.nr-dias-taxa       = tt-ordens.nr-dias-taxa   
               tt-ordem-compra.licenca-import     = tt-ordens.licenca-import 
               tt-ordem-compra.Loc-entrega        = tt-ordens.loc-entrega.    

end procedure.

procedure getPais:

    run getPais in h-imapi009 (output table tt-pais).

    find first tt-pais no-error.
    if  avail  tt-pais then
        assign tt-ordem-compra.nome-pais-orig = tt-pais.nome-pais.

end procedure.

procedure getPtoControle:
    
    run getPtoControle in h-imapi009 (output table tt-pto-contr).

    find first tt-pto-contr no-error.
    if  avail  tt-pto-contr then
        assign tt-ordem-compra.desc-pto-contr-base = tt-pto-contr.descricao.

end procedure.

procedure getUn:

    run getUn in h-imapi009 (output table tt-un).

    find first tt-un no-error.
    if  avail  tt-un then
        assign tt-ordem-compra.desc-un-interno = tt-un.desc-un-interno
               tt-ordem-compra.desc-un-fornec  = tt-un.desc-un-fornec. 

end procedure.

procedure piGeraOrdemCompra:

    if  not can-find (first tt-ordem-compra
                      where tt-ordem-compra.numero-ordem = ordem-compra.numero-ordem) then do:

        create tt-ordem-compra.
        assign tt-ordem-compra.numero-ordem = ordem-compra.numero-ordem
               tt-ordem-compra.num-pedido   = pedido-compr.num-pedido.

        run setConstraintOrdensCompra in h-imapi009 (input rowid(ordem-compra)).
    
        run getOrdensCompra.
    
        run getCotacaoItem.
    
        run getPtoControle.
    
        run getFabricante.
    
        run getPais.
    
        run getMoeda.
    
        run getItem.
    
        run getNarrativa.
    
        run getGrupoEstoque.
    
        run getFamilia.
    
        run getFamComerc.
    
        run getItemFornec.
    
        run getUn.
    
        run getEmbalag.
                
        run getCalculosOrdemCompra.

    end.

end procedure.
/* FIM - PROCEDURE GERACAO ORDEM-COMPRA */

/* PROCEDURE GERACAO PRAZO-COMPRA */
procedure getCalculosPrazoCompra:

    run getCalculosPrazoCompra in h-imapi009 (output table tt-calculos-parcela).

    find first tt-calculos-parcela no-error.
    if  avail tt-calculos-parcela then
        assign tt-prazo-compra.peso-liquido-total      = tt-calculos-parcela.peso-liquido-total         
               tt-prazo-compra.peso-bruto-total        = tt-calculos-parcela.peso-bruto-total           
               tt-prazo-compra.preco-fornec-liq-total  = tt-calculos-parcela.preco-fornec-liq-total    
               tt-prazo-compra.preco-interno-liq-total = tt-calculos-parcela.preco-interno-liq-total   
               tt-prazo-compra.preco-fornec-bru-total  = tt-calculos-parcela.preco-fornec-bru-total    
               tt-prazo-compra.preco-interno-bru-total = tt-calculos-parcela.preco-interno-bru-total   
               tt-prazo-compra.ocupacao-total          = tt-calculos-parcela.ocupacao-total.

    assign tt-prazo-compra.valor-descto-mo-inf            = tt-ordem-compra.valor-descto-mo-inf       
           tt-prazo-compra.preco-fornec-liq               = tt-ordem-compra.preco-fornec-liq      
           tt-prazo-compra.preco-interno-liq              = tt-ordem-compra.preco-interno-liq     
           tt-prazo-compra.preco-fornec-bru               = tt-ordem-compra.preco-fornec-bru      
           tt-prazo-compra.preco-interno-bru              = tt-ordem-compra.preco-interno-bru     
           tt-prazo-compra.preco-fornec-liq-mo-inf        = tt-ordem-compra.preco-fornec-liq-mo-inf       
           tt-prazo-compra.preco-interno-liq-mo-inf       = tt-ordem-compra.preco-interno-liq-mo-inf      
           tt-prazo-compra.preco-fornec-bru-mo-inf        = tt-ordem-compra.preco-fornec-bru-mo-inf       
           tt-prazo-compra.preco-interno-bru-mo-inf       = tt-ordem-compra.preco-interno-bru-mo-inf.     

end procedure.

procedure getPrazoCompra:

    run getPrazoCompra in h-imapi009 (output table tt-parcelas).

    find first tt-parcelas no-error.
    if  avail  tt-parcelas then
        assign tt-prazo-compra.numero-ordem   = tt-parcelas.numero-ordem  
               tt-prazo-compra.parcela        = tt-parcelas.parcela       
               tt-prazo-compra.it-codigo      = tt-parcelas.it-codigo     
               tt-prazo-compra.Un             = tt-parcelas.un            
               tt-prazo-compra.quantid-orig   = tt-parcelas.quantid-orig  
               tt-prazo-compra.quantidade     = tt-parcelas.quantidade    
               tt-prazo-compra.quant-saldo    = tt-parcelas.quant-saldo   
               tt-prazo-compra.quant-rejeit   = tt-parcelas.quant-rejeit  
               tt-prazo-compra.quant-receb    = tt-parcelas.quant-receb   
               tt-prazo-compra.qtd-do-forn    = tt-parcelas.qtd-do-forn   
               tt-prazo-compra.qtd-sal-forn   = tt-parcelas.qtd-sal-forn  
               tt-prazo-compra.qtd-rej-forn   = tt-parcelas.qtd-rej-forn  
               tt-prazo-compra.qtd-rec-forn   = tt-parcelas.qtd-rec-forn  
               tt-prazo-compra.data-orig      = tt-parcelas.data-orig     
               tt-prazo-compra.data-entrega   = tt-parcelas.data-entrega  
               tt-prazo-compra.data-alter     = tt-parcelas.data-alter    
               tt-prazo-compra.quant-a-ped    = tt-parcelas.quant-a-ped   
               tt-prazo-compra.qtd-a-ped-forn = tt-parcelas.qtd-a-ped-forn
               tt-prazo-compra.cc-codigo      = tt-parcelas.cc-codigo     
               tt-prazo-compra.item-cotacao   = tt-parcelas.item-cotacao  
               tt-prazo-compra.qtd-aloc-forn  = tt-parcelas.qtd-aloc-forn 
               tt-prazo-compra.quant-alocada  = tt-parcelas.quant-alocada
               tt-prazo-compra.cod-refer      = tt-parcelas.cod-refer. 

end procedure.

procedure piGeraPrazoCompra:

    if  not can-find (first tt-prazo-compra
                      where tt-prazo-compra.numero-ordem = prazo-compra.numero-ordem
                      and   tt-prazo-compra.parcela      = prazo-compra.parcela) then do:

        create tt-prazo-compra.
        assign tt-prazo-compra.numero-ordem = prazo-compra.numero-ordem
               tt-prazo-compra.parcela      = prazo-compra.parcela.

        run setConstraintPrazoCompra in h-imapi009 (input rowid(prazo-compra)).

        run getPrazoCompra.

        assign tt-prazo-compra.it-codigo           = tt-ordem-compra.It-codigo                 
               tt-prazo-compra.data-emissao        = tt-ordem-compra.data-emissao              
               tt-prazo-compra.narrat-ordem        = tt-ordem-compra.narrat-ordem              
               tt-prazo-compra.data-cotacao        = tt-ordem-compra.data-cotacao              
               tt-prazo-compra.Mo-codigo           = tt-ordem-compra.Mo-codigo                 
               tt-prazo-compra.aliquota-ipi-ordem  = tt-ordem-compra.aliquota-ipi-ordem        
               tt-prazo-compra.taxa-financ         = tt-ordem-compra.taxa-financ               
               tt-prazo-compra.valor-taxa          = tt-ordem-compra.valor-taxa                
               tt-prazo-compra.perc-descto         = tt-ordem-compra.perc-descto               
               tt-prazo-compra.prazo-entreg        = tt-ordem-compra.prazo-entreg              
               tt-prazo-compra.contato             = tt-ordem-compra.contato                   
               tt-prazo-compra.data-atualiz        = tt-ordem-compra.data-atualiz              
               tt-prazo-compra.hora-atualiz        = tt-ordem-compra.hora-atualiz              
               tt-prazo-compra.cod-refer           = IF tt-ordem-compra.cod-refer <> "" THEN tt-ordem-compra.cod-refer ELSE tt-prazo-compra.cod-refer
               tt-prazo-compra.valor-descto        = tt-ordem-compra.valor-descto              
               tt-prazo-compra.nr-dias-taxa        = tt-ordem-compra.nr-dias-taxa         
               tt-prazo-compra.licenca-import      = tt-ordem-compra.licenca-import       
               tt-prazo-compra.loc-entrega         = tt-ordem-compra.Loc-entrega          
               tt-prazo-compra.cod-pto-contr-base  = tt-ordem-compra.cod-pto-contr-base
               tt-prazo-compra.aliquota-ii         = tt-ordem-compra.aliquota-ii              
               tt-prazo-compra.regime-import       = tt-ordem-compra.regime-import            
               tt-prazo-compra.un-fornec           = tt-ordem-compra.Un-fornec                
               tt-prazo-compra.cdn-pais-orig       = tt-ordem-compra.cdn-pais-orig            
               tt-prazo-compra.desc-pto-contr-base = tt-ordem-compra.desc-pto-contr-base       
               tt-prazo-compra.nome-pais-orig      = tt-ordem-compra.nome-pais-orig       
               tt-prazo-compra.desc-moeda          = tt-ordem-compra.desc-moeda        
               tt-prazo-compra.sigla-moeda         = tt-ordem-compra.sigla-moeda       
               tt-prazo-compra.desc-item           = tt-ordem-compra.desc-item          
               tt-prazo-compra.peso-liquido        = tt-ordem-compra.peso-liquido       
               tt-prazo-compra.peso-bruto          = tt-ordem-compra.peso-bruto         
               tt-prazo-compra.altura              = tt-ordem-compra.altura             
               tt-prazo-compra.comprim             = tt-ordem-compra.comprim            
               tt-prazo-compra.largura             = tt-ordem-compra.largura            
               tt-prazo-compra.ge-codigo           = tt-ordem-compra.Ge-codigo          
               tt-prazo-compra.fm-codigo           = tt-ordem-compra.Fm-codigo          
               tt-prazo-compra.fm-cod-com          = tt-ordem-compra.Fm-cod-com         
               tt-prazo-compra.un                  = tt-ordem-compra.Un                 
               tt-prazo-compra.narrativa           = tt-ordem-compra.narrativa       
               tt-prazo-compra.desc-grup-estoq     = tt-ordem-compra.desc-grup-estoq       
               tt-prazo-compra.desc-familia        = tt-ordem-compra.desc-familia       
               tt-prazo-compra.desc-fam-comerc     = tt-ordem-compra.desc-fam-comerc       
               tt-prazo-compra.item-fornec         = tt-ordem-compra.item-fornec 
               tt-prazo-compra.desc-item-fornec    = tt-ordem-compra.desc-item-fornec
               tt-prazo-compra.cod-embal           = tt-ordem-compra.cod-embal                
               tt-prazo-compra.fator-conver        = tt-ordem-compra.fator-conver             
               tt-prazo-compra.num-casa-dec        = tt-ordem-compra.num-casa-dec             
               tt-prazo-compra.narrat-item-fornec  = tt-ordem-compra.narrat-item-fornec       
               tt-prazo-compra.desc-un-interno     = tt-ordem-compra.desc-un-interno       
               tt-prazo-compra.desc-un-fornec      = tt-ordem-compra.desc-un-fornec        
               tt-prazo-compra.sigla-embalag       = tt-ordem-compra.sigla-embalag       
               tt-prazo-compra.desc-embalag        = tt-ordem-compra.desc-embalag        
               tt-prazo-compra.peso-embalag        = tt-ordem-compra.peso-embalag
               tt-prazo-compra.class-fiscal        = tt-ordem-compra.class-fiscal.

        run getCalculosPrazoCompra.
    end.

end procedure.
/* FIM - PROCEDURE GERACAO PRAZO-COMPRA */

/* PROCEDURE GERACAO DESPESAS */
procedure getCondicaoPagamentoDesp:
    
    run getCondicaoPagamento in h-imapi009 (output table tt-cond-pagto).

    find first tt-cond-pagto no-error.
    if  avail  tt-cond-pagto then
        assign tt-despesa.desc-cond-pagto = tt-cond-pagto.descricao.

end procedure.

procedure getDespImp:

    run getDespImp in h-imapi009 (output table tt-desp).

    find first tt-desp no-error.
    if  avail tt-desp then
        assign tt-despesa.desc-despesa = tt-desp.descricao.

end procedure.

procedure getEmitenteDesp:

    run getEmitenteDesp in h-imapi009 (output table tt-emitente).

    find first tt-emitente no-error.
    if  avail tt-emitente then
        assign tt-despesa.nome-emit-desp          = tt-emitente.nome-emit    
               tt-despesa.endereco-emit-desp      = tt-emitente.endereco     
               tt-despesa.bairro-emit-desp        = tt-emitente.bairro       
               tt-despesa.cidade-emit-desp        = tt-emitente.cidade       
               tt-despesa.pais-emit-desp          = tt-emitente.pais         
               tt-despesa.cep-emit-desp           = tt-emitente.cep          
               tt-despesa.cgc-emit-desp           = tt-emitente.cgc          
               tt-despesa.estado-emit-desp        = tt-emitente.estado       
               tt-despesa.ins-estadual-emit-desp  = tt-emitente.ins-estadual 
               tt-despesa.ins-municipal-emit-desp = tt-emitente.ins-municipal
               tt-despesa.caixa-postal-emit-desp  = tt-emitente.caixa-postal 
               tt-despesa.e-mail-emit-desp        = tt-emitente.e-mail       
               tt-despesa.cod-aba-emit-desp       = tt-emitente.cod-aba      
               tt-despesa.telefone1-emit-desp     = tt-emitente.telefone[1]  
               tt-despesa.telefone2-emit-desp     = tt-emitente.telefone[2]  
               tt-despesa.ramal1-emit-desp        = tt-emitente.ramal[1]     
               tt-despesa.ramal2-emit-desp        = tt-emitente.ramal[2]     
               tt-despesa.home-page-emit-desp     = tt-emitente.home-page    
               tt-despesa.telefax-emit-desp       = tt-emitente.telefax      
               tt-despesa.ramal-fax-emit-desp     = tt-emitente.ramal-fax    
               tt-despesa.telef-fac-emit-desp     = tt-emitente.telef-fac    
               tt-despesa.ramal-fac-emit-desp     = tt-emitente.ramal-fac    
               tt-despesa.telef-modem-emit-desp   = tt-emitente.telef-modem  
               tt-despesa.ramal-modem-emit-desp   = tt-emitente.ramal-modem.  

end procedure.

procedure getMoedaDesp:

    run getMoeda in h-imapi009 (output table tt-moeda).

    find first tt-moeda no-error.
    if  avail tt-moeda then
        assign tt-despesa.desc-moeda  = tt-moeda.descricao
               tt-despesa.sigla-moeda = tt-moeda.sigla.

end procedure.

procedure getPtoControleDesp:
    
    run getPtoControle in h-imapi009 (output table tt-pto-contr).

    find first tt-pto-contr no-error.
    if  avail  tt-pto-contr then
        assign tt-despesa.desc-pto-contr-base = tt-pto-contr.descricao.

end procedure.

procedure piGeraDespesas:

    {cdp/cd4300.i4 "yes" cotacao-item.char-1}
    {ccp/cc9019.i51 "yes"}
    
    find emitente-cex
        where emitente-cex.cod-emitente = cotacao-item.cod-emitente no-lock no-error.
    if  not avail emitente-cex
    or  (    avail emitente-cex
         and not emitente-cex.log-1) then
    
        for each desp-incoterm no-lock
            where desp-incoterm.cod-incoterm = c-cod-incoterm-i50
            break by desp-incoterm.cod-incoterm:
    
            find desp-imp
                where desp-imp.cod-desp = desp-incoterm.cod-desp no-lock no-error.
            if  avail desp-imp then do:

                if  not desp-imp.inc-val-seguro      
                and not desp-imp.inc-val-frete       
                and not desp-imp.inc-val-embal       
                and not desp-imp.inc-val-outras-desp then
                    next.
    
                find cotacao-item-cex 
                    where cotacao-item-cex.numero-ordem      = cotacao-item.numero-ordem 
                    and   cotacao-item-cex.cod-emitente      = cotacao-item.cod-emitente 
                    and   cotacao-item-cex.it-codigo         = cotacao-item.it-codigo    
                    and   cotacao-item-cex.seq-cotac         = cotacao-item.seq-cotac    
                    and   cotacao-item-cex.data-cotacao      = cotacao-item.data-cotacao 
                    and   cotacao-item-cex.mapa-cotacao      = i-mapa-cotacao-i50        
                    and   cotacao-item-cex.cod-incoterm      = desp-incoterm.cod-incoterm
                    and   cotacao-item-cex.cod-emitente-desp = cotacao-item.cod-emitente
                    and   cotacao-item-cex.cod-desp          = desp-incoterm.cod-desp no-lock no-error.
                if  avail cotacao-item-cex then do:
    
                    run setConstraintCotacaoItemCex in h-imapi009 (input rowid(cotacao-item-cex)).

                    run getCotacaoItemCex in h-imapi009 (output table tt-cotacao-item-cex).

                    find first tt-cotacao-item-cex no-error.

                    for first tt-despesa 
                        where tt-despesa.mo-codigo     = tt-cotacao-item-cex.mo-codigo
                        and   tt-despesa.cod-cond-pag  = tt-cotacao-item-cex.cod-cond-pag
                        and   tt-despesa.cod-pto-contr = tt-cotacao-item-cex.cod-pto-contr
                        and   tt-despesa.cod-desp      = tt-cotacao-item-cex.cod-desp no-lock: end.
                    if  not avail tt-despesa then do:

                        create tt-despesa.
                        assign tt-despesa.numero-ordem      = cotacao-item-cex.numero-ordem     
                               tt-despesa.cod-emitente      = cotacao-item-cex.cod-emitente     
                               tt-despesa.it-codigo         = cotacao-item-cex.it-codigo        
                               tt-despesa.seq-cotac         = cotacao-item-cex.seq-cotac        
                               tt-despesa.data-cotacao      = cotacao-item-cex.data-cotacao     
                               tt-despesa.mapa-cotacao      = cotacao-item-cex.mapa-cotacao     
                               tt-despesa.cod-incoterm      = cotacao-item-cex.cod-incoterm     
                               tt-despesa.cod-itiner        = cotacao-item-cex.cod-itiner       
                               tt-despesa.sequencia         = cotacao-item-cex.sequencia        
                               tt-despesa.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp
                               tt-despesa.cod-desp          = cotacao-item-cex.cod-desp
                               tt-despesa.num-pedido        = pedido-compr.num-pedido
                               tt-despesa.cod-cond-pag      = tt-cotacao-item-cex.cod-cond-pag     
                               tt-despesa.data-cotacao-desp = tt-cotacao-item-cex.data-cotacao-desp
                               tt-despesa.mo-codigo         = tt-cotacao-item-cex.mo-codigo        
                               tt-despesa.cod-pto-contr     = tt-cotacao-item-cex.cod-pto-contr.    

                        run getEmitenteDesp.

                        run getDespImp.

                        run getPtoControleDesp.

                        run getCondicaoPagamentoDesp.

                        run getMoedaDesp.
                    end.

                    assign tt-despesa.val-desp = tt-despesa.val-desp 
                                               + (tt-cotacao-item-cex.val-desp * tt-ordem-compra.quantidade).

                    /* Converte valor da despesa para a moeda informada na tela */
                    run cdp/cd0812.p (input cotacao-item-cex.mo-codigo,
                                      input tt-param.i-moeda,
                                      input (tt-cotacao-item-cex.val-desp * tt-ordem-compra.quantidade),
                                      input today,
                                      output de-val-desp-conv).

                    if  de-val-desp-conv = 0 
                    or  de-val-desp-conv = ? then
                        assign de-val-desp-conv = (tt-cotacao-item-cex.val-desp * tt-ordem-compra.quantidade).

                    assign tt-despesa.val-desp-mo-inf = tt-despesa.val-desp-mo-inf 
                                                      + de-val-desp-conv
                           de-tot-desp-ped            = de-tot-desp-ped 
                                                      + de-val-desp-conv.
                end.
            end.
        end.

end procedure.
/* FIM - PROCEDURE GERACAO DESPESAS */

procedure piPrincipal:

    if  tt-param.l-traducao then
        run setTraducao in h-imapi009 (input 4).
    
    for each  processo-imp no-lock 
        where processo-imp.num-pedido >= tt-param.i-pedi-i 
        and   processo-imp.num-pedido <= tt-param.i-pedi-f 
        break by processo-imp.cod-exportador
              by processo-imp.num-pedido:

        IF tt-param.l-traducao THEN
            {imp/im9998.i c-titulo-relat c-titulo-relat processo-imp}

        find pedido-compr
            where pedido-compr.num-pedido = processo-imp.num-pedido no-lock no-error.    
        if  not avail pedido-compr 
        or  not pedido-compr.impr-pedido then 
            next.

        /* Aprovacao Eletronica */
        assign l-pendente = no.
        if  param-compra.log-1 then do:

            for each  ordem-compra
                where ordem-compra.num-pedido = pedido-compr.num-pedido no-lock:
                if  pedido-compr.emergencial then
                    run cdp/cdapi172.p (6, rowid(ordem-compra), output l-pendente).            
                ELSE
                    run cdp/cdapi172.p(4, rowid(ordem-compra), output l-pendente).

                if  l-pendente then
                    leave.
            end.
        end.        
        if  l-pendente then
            next.

        if  not can-find (first  ordem-compra
                           where ordem-compra.num-pedido = pedido-compr.num-pedido
                           and   ordem-compra.situacao  <> 4
                           and   ordem-compra.situacao  <> 6) then
            next.

        /* Limpa as tabelas temporarias */
        run emptyTempTables in h-imapi009.

        /* Criacao temp-table tt-pedido-compr e tt-pedido-compr-aux */
        assign de-tot-desp-ped = 0.

        run piGeraPedidoCompra.

        for first moeda fields (descricao sigla mo-codigo)
            where moeda.mo-codigo = tt-param.i-moeda no-lock: end.
        if  avail moeda then
            assign tt-pedido-compr-aux.desc-moeda-inf  = moeda.descricao
                   tt-pedido-compr-aux.sigla-moeda-inf = moeda.sigla
                   tt-pedido-compr-aux.mo-codigo-inf   = moeda.mo-codigo.
                       
        for each  ordem-compra
            where ordem-compra.num-pedido = pedido-compr.num-pedido
            and   ordem-compra.situacao  <> 4
            and   ordem-compra.situacao  <> 6 no-lock:

            find first cotacao-item 
                where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                and   cotacao-item.cod-emitente = ordem-compra.cod-emitente
                and   cotacao-item.cot-aprovada no-lock no-error.
            if  not avail cotacao-item then
                next.

            /* Criacao temp-table tt-ordem-compra */
            run piGeraOrdemCompra.
        
            for each prazo-compra
                where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
                and   prazo-compra.situacao    <> 4
                and   prazo-compra.situacao    <> 6 no-lock:
    
                run piGeraPrazoCompra.

                assign tt-ordem-compra.quantidade  = tt-ordem-compra.quantidade 
                                                   + tt-prazo-compra.quantidade
                       tt-ordem-compra.qtd-do-forn = tt-ordem-compra.qtd-do-forn
                                                   + tt-prazo-compra.qtd-do-forn.
            end.
    
            run piGeraDespesas.

            assign tt-pedido-compr.peso-liquido-total-ped         = tt-pedido-compr.peso-liquido-total-ped     
                                                                  + tt-ordem-compra.peso-liquido-total
                   tt-pedido-compr.peso-bruto-total-ped           = tt-pedido-compr.peso-bruto-total-ped       
                                                                  + tt-ordem-compra.peso-bruto-total
                   tt-pedido-compr.preco-fornec-liq-total-ped     = tt-pedido-compr.preco-fornec-liq-total-ped       
                                                                  + tt-ordem-compra.preco-fornec-liq-total-mo-inf
                   tt-pedido-compr.preco-interno-liq-total-ped    = tt-pedido-compr.preco-interno-liq-total-ped
                                                                  + tt-ordem-compra.preco-interno-liq-total-mo-inf
                   tt-pedido-compr.preco-fornec-bru-total-ped     = tt-pedido-compr.preco-fornec-bru-total-ped 
                                                                  + tt-ordem-compra.preco-fornec-bru-total-mo-inf
                   tt-pedido-compr.preco-interno-bru-total-ped    = tt-pedido-compr.preco-interno-bru-total-ped
                                                                  + tt-ordem-compra.preco-interno-bru-total-mo-inf
                   tt-pedido-compr.ocupacao-total-ped             = tt-pedido-compr.ocupacao-total-ped         
                                                                  + tt-ordem-compra.ocupacao-total.            
        end. /* for each ordem-compra */
    
        assign tt-pedido-compr.tot-desp-ped                   = de-tot-desp-ped
               tt-pedido-compr.tot-desp-fornec-liq-total-ped  = tt-pedido-compr.preco-fornec-liq-total-ped
                                                              + de-tot-desp-ped
               tt-pedido-compr.tot-desp-interno-liq-total-ped = tt-pedido-compr.preco-interno-liq-total-ped
                                                              + de-tot-desp-ped
               tt-pedido-compr.tot-desp-fornec-bru-total-ped  = tt-pedido-compr.preco-fornec-bru-total-ped
                                                              + de-tot-desp-ped
               tt-pedido-compr.tot-desp-interno-bru-total-ped = tt-pedido-compr.preco-interno-bru-total-ped
                                                              + de-tot-desp-ped.

        for each texto-follow-up 
            where texto-follow-up.num-pedido = pedido-compr.num-pedido no-lock:

            if  not can-find (first tt-texto-follow-up
                              where tt-texto-follow-up.nr-trans = texto-follow-up.nr-trans) then do:
                
                create tt-texto-follow-up.
                buffer-copy texto-follow-up to tt-texto-follow-up.

                if  tt-param.l-traducao then do:
                    assign c-texto        = ""
                           c-texto-aux    = "" 
                           c-texto-follow = "".
                    do  i-cont = 1 to length(texto-follow-up.des-narrativa):
            
                        if  substring(texto-follow-up.des-narrativa,i-cont,1) <> "" 
                        and lookup(substring(texto-follow-up.des-narrativa,i-cont,1),"0,1,2,3,4,5,6,7,8,9,.,-,/,~\,:,;,,," + chr(10)) = 0 then do:
                            assign c-texto = c-texto + substring(texto-follow-up.des-narrativa,i-cont,1).

                            if  i-cont = length(texto-follow-up.des-narrativa) then do:
                                if  c-texto <> "" then do:
                                    {imp/im9998.i c-texto c-texto-aux processo-imp}
                                    assign c-texto-follow = c-texto-follow + c-texto-aux.
                                end.
                            end.
                        end.
                        else do: 

                             if  c-texto <> "" then do:

                                 {imp/im9998.i c-texto c-texto-aux processo-imp}
                                 assign c-texto-follow = c-texto-follow + c-texto-aux + substring(texto-follow-up.des-narrativa,i-cont,1).
                                 assign c-texto = "".                                
                             end.
                             else
                                 assign c-texto-follow = c-texto-follow + substring(texto-follow-up.des-narrativa,i-cont,1).
                        end.
                    end.

                    assign c-texto-follow                   = replace(c-texto-follow, chr(10), " ")
                           tt-texto-follow-up.des-narrativa = c-texto-follow.
                end.
            end.
        end.
    end.

    run imp/im0305a.p (input  table tt-param,
                       input  table tt-pedido-compr,
                       input  table tt-pedido-compr-aux,
                       input  table tt-pedido-compr-aux2,
                       input  table tt-ordem-compra,
                       input  table tt-prazo-compra,
                       input  table tt-despesa,
                       input  table tt-texto-follow-up,
                       input  h-acomp,
                       output table tt-documentos-impressos,
                       output table tt-documentos-erros,
                       output table tt_log_erro).   

end procedure.  

PROCEDURE piImprimirDoctosGerados:

    IF CAN-FIND(FIRST tt-documentos-erros) THEN DO:
       {utp/ut-liter.i ERROS * L}
       PUT RETURN-VALUE FORMAT "x(10)".
       PUT UNFORMATTED SKIP(1).
    END.

    FOR EACH tt-documentos-erros
          BY tt-documentos-erros.cod-estabel
          by tt-documentos-erros.nr-proc-imp:

        DISP tt-documentos-erros.cod-estabel   
             tt-documentos-erros.nome-emit-exp
             tt-documentos-erros.nr-proc-imp
             tt-documentos-erros.num-pedido
             tt-documentos-erros.cod-erro
             tt-documentos-erros.mensagem
             WITH FRAME f-doc-erros.
        DOWN WITH FRAME f-doc-erros.
    END.
                       
    IF CAN-FIND(FIRST tt-documentos-impressos) THEN DO:
       IF CAN-FIND(FIRST tt-documentos-erros) THEN
          PUT UNFORMATTED SKIP(1).

        {utp/ut-liter.i DOCUMENTOS_IMPRESSOS * L}
        PUT RETURN-VALUE FORMAT "x(30)".
        PUT UNFORMATTED SKIP(1).

    END.

    FOR EACH tt-documentos-impressos
          BY tt-documentos-impressos.cod-estabel:

        DISP tt-documentos-impressos.cod-estabel
             tt-documentos-impressos.nome-emit-exp FORMAT "x(12)"
             tt-documentos-impressos.nr-proc-imp
             tt-documentos-impressos.num-pedido
             tt-documentos-impressos.destino
             WITH FRAME f-doc-impressos.
        DOWN WITH FRAME f-doc-impressos.
    END.

END PROCEDURE.

PROCEDURE piImprimirParametros:

    DEFINE VARIABLE c-traduz AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cValor   AS CHARACTER  NO-UNDO.

    /*** FOLDER SELEÄ«O ***/
    {utp/ut-liter.i "SELEÄ«O" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz AT 056 SKIP(1).

    /* Faixa Estabel */
    {utp/ut-liter.i "Pedido:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz                  AT 038 FORMAT "x(7)"
        tt-param.i-pedi-i         AT 046 FORMAT ">>>>>,>>9":U
        "|<   >|"                 AT 056
        tt-param.i-pedi-f         AT 064 FORMAT ">>>>>,>>9":U.
    PUT UNFORMATTED skip(2).

    /*** FOLDER PAR∂METROS ***/
    {utp/ut-liter.i "PAR∂METROS" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz AT 055 FORMAT "x(15)" SKIP(1).
   
    {utp/ut-liter.i "Envia_docto_para_fornecedor:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    {utp/ut-liter.i "Sim/N∆o" * r}.
    PUT c-traduz                          AT 032 FORMAT "x(28)"
        tt-param.l-envia-docto-fornec     AT 061 FORMAT RETURN-VALUE.
    PUT UNFORMATTED SKIP.

    {utp/ut-liter.i "Envia_C¢pia_para:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz                 AT 043 FORMAT "x(17)"
        tt-param.c-arquivo-copia AT 061 FORMAT "x(50)".
       PUT UNFORMATTED SKIP.

    {utp/ut-liter.i "Utiliza_Layout_Padr∆o_do_Fornecedor:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    {utp/ut-liter.i "Sim/N∆o" * r}.
    PUT c-traduz                          AT 024 FORMAT "x(36)"
        tt-param.l-layout-pad-fornec      AT 061 FORMAT RETURN-VALUE.
    PUT UNFORMATTED SKIP.
   
    IF NOT tt-param.l-layout-pad-fornec THEN DO:
       {utp/ut-liter.i "Layout_Padr∆o:" * r}.
       ASSIGN c-traduz = RETURN-VALUE.
       PUT c-traduz                     AT 046 FORMAT "x(15)"
           tt-param.c-layout-pad-fornec AT 061 FORMAT "x(50)".
       PUT UNFORMATTED SKIP.
    END.
    {utp/ut-liter.i Sobrepor_arquivos_j†_existentes?: *}.
    ASSIGN c-traduz = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "Sim/N∆o" * r}.
    PUT c-traduz                AT 027 FORMAT "x(33)"
        tt-param.l-sobrepor     AT 061 FORMAT RETURN-VALUE.
    PUT UNFORMATTED SKIP.
    
    {utp/ut-liter.i "Diret¢rio:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz                AT 050 FORMAT "x(10)"
        tt-param.c-dir-destino  AT 061 FORMAT "x(50)".    
    
    IF tt-param.i-orientacao = 0 THEN DO:
       {utp/ut-liter.i "Retrato" * r}.
       ASSIGN cValor = RETURN-VALUE.
    END.
    ELSE DO:
       {utp/ut-liter.i "Paisagem" * r}.
       ASSIGN cValor = RETURN-VALUE.
    END.

    {utp/ut-liter.i "Orientaá∆o:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz       AT 049 FORMAT "x(11)"
        cValor         AT 061.
    PUT UNFORMATTED SKIP.   

    IF tt-param.i-formato-data = 1 THEN
       ASSIGN cValor = "DD/MM/AAAA".
    ELSE
       ASSIGN cValor = "MM/DD/AAAA".
   
    {utp/ut-liter.i "Formato_Data:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz                    AT 047 FORMAT "x(13)"
        cValor                      AT 061 FORMAT "x(10)".
    PUT UNFORMATTED SKIP.   

    {utp/ut-liter.i "Traduzir:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    {utp/ut-liter.i "Sim/N∆o" * r}.
    PUT c-traduz                    AT 051 FORMAT "x(09)"
        tt-param.l-traducao         AT 061 FORMAT RETURN-VALUE.
    PUT UNFORMATTED SKIP.

    {utp/ut-liter.i "Imprime_minuta_docto:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    {utp/ut-liter.i "Sim/N∆o" * r}.
    PUT c-traduz                    AT 039 FORMAT "x(22)"
        tt-param.l-minuta           AT 061 FORMAT RETURN-VALUE.
    PUT UNFORMATTED SKIP.

    {utp/ut-liter.i "Decimais:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz                    AT 051 FORMAT "x(9)"
        tt-param.decimais           AT 061 FORMAT "9".
    PUT UNFORMATTED SKIP.

    {utp/ut-liter.i "Moeda:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz                    AT 054 FORMAT "x(6)"
        tt-param.i-moeda            AT 061 FORMAT "99".
    PUT UNFORMATTED SKIP(2).
       
    /*** FOLDER IMPRESS«O ***/
    {utp/ut-liter.i "IMPRESS«O" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz AT 055 FORMAT "x(15)" SKIP(1).
   
    {utp/ut-liter.i "Usu†rio:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
   
    PUT c-traduz         AT 052 FORMAT "x(08)"
        tt-param.usuario AT 061 FORMAT "x(20)".
   
    {utp/ut-liter.i "Destino:" * r}
    ASSIGN c-traduz = RETURN-VALUE.
   
    PUT c-traduz         AT 052 FORMAT "x(08)"
        tt-param.arquivo AT 061 FORMAT "x(40)".
   
END PROCEDURE.

PROCEDURE pi-imprime-erros-eai:

    IF CAN-FIND (FIRST tt_log_erro) THEN DO:    
        PUT c-erro-eai FORMAT "x(40)".
        PUT SKIP.
        PUT "-----------------------------------------------------------------".
    END.

    FOR EACH tt_log_erro NO-LOCK:
        IF tt_log_erro.ttv_des_msg_erro <> "" AND tt_log_erro.ttv_des_msg_erro <> ? THEN DO:
                                       
            RUN pi-print-editor (INPUT tt_log_erro.ttv_des_msg_erro, INPUT 60).
    
            ASSIGN l-primeira = YES.
            FOR EACH tt-editor NO-LOCK:
                IF l-primeira THEN 
                    /* Inicio -- Projeto Internacional */
                    DO:
                    DEFINE VARIABLE c-lbl-liter-erro AS CHARACTER FORMAT "X(8)" NO-UNDO.
                    {utp/ut-liter.i "Erro" *}
                    ASSIGN c-lbl-liter-erro = TRIM(RETURN-VALUE).
                    PUT c-lbl-liter-erro + ": " + STRING(tt_log_erro.ttv_num_cod_erro) + " - "  + tt-editor.conteudo AT 1 FORMAT "x(60)".
                    END. 
                ELSE 
                    PUT tt-editor.conteudo AT 8 FORMAT "x(60)".
    
                ASSIGN l-primeira = NO.
                IF LINE-COUNTER > (PAGE-SIZE - 4) THEN PAGE.
            END.                       
        END.
        
        IF tt_log_erro.ttv_des_msg_ajuda <> "" AND tt_log_erro.ttv_des_msg_ajuda <> ? THEN DO:
                                          
            RUN pi-print-editor (INPUT tt_log_erro.ttv_des_msg_ajuda, INPUT 60).
    
            ASSIGN l-primeira = YES.
            FOR EACH tt-editor NO-LOCK:
                IF l-primeira THEN 
                    /* Inicio -- Projeto Internacional */
                    DO:
                    DEFINE VARIABLE c-lbl-liter-ajuda AS CHARACTER FORMAT "X(9)" NO-UNDO.
                    {utp/ut-liter.i "Ajuda" *}
                    ASSIGN c-lbl-liter-ajuda = TRIM(RETURN-VALUE).
                    PUT c-lbl-liter-ajuda + ": " + tt-editor.conteudo AT 1 FORMAT "x(60)".
                    END. 
                ELSE 
                    PUT tt-editor.conteudo AT 8 FORMAT "x(60)".
    
                ASSIGN l-primeira = NO.
                IF LINE-COUNTER > (PAGE-SIZE - 4) THEN PAGE.
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-print-editor:
    DEF INPUT  PARAM c-editor      AS CHAR    NO-UNDO.
    DEF INPUT  PARAM i-len         AS INTEGER NO-UNDO.

    DEF VAR i-linha  AS INTEGER NO-UNDO.
    DEF VAR i-aux    AS INTEGER NO-UNDO.
    def VAR c-aux    AS CHAR    NO-UNDO.
    DEF VAR c-ret    AS CHAR    NO-UNDO.

    FOR EACH tt-editor:
        DELETE tt-editor.
    END.

    ASSIGN c-ret = CHR(255) + CHR(255).

    DO  WHILE c-editor <> "":
        IF  c-editor <> "" THEN DO:
            ASSIGN i-aux = index(c-editor, chr(10)).
            /*Alteraªío 03/08/2007 - tech14187 - FO1562655 - Alteraªío para considerar o CHR(13) como quebra de linha tamb≤m. */
            IF i-aux = 0 THEN DO:
                ASSIGN i-aux = INDEX(c-editor, chr(13)).
            END.
            IF  i-aux > i-len OR (i-aux = 0 AND LENGTH(c-editor) > i-len) then
                ASSIGN i-aux = R-INDEX(c-editor, " ", i-len + 1).
            IF  i-aux = 0 THEN
                ASSIGN c-aux = SUBSTR(c-editor, 1, i-len)
                       c-editor = SUBSTR(c-editor, i-len + 1).
            ELSE
                ASSIGN c-aux = SUBSTR(c-editor, 1, i-aux - 1)
                       c-editor = SUBSTR(c-editor, i-aux + 1).
            IF  i-len = 0 THEN
                ASSIGN ENTRY(1, c-ret, CHR(255)) = c-aux.
            ELSE DO:
                ASSIGN i-linha = i-linha + 1.
                CREATE tt-editor.
                ASSIGN tt-editor.linha    = i-linha
                       tt-editor.conteudo = c-aux.
            END.
        END.
        IF  i-len = 0 THEN
            RETURN c-ret.
    END.
    RETURN c-ret.
END PROCEDURE.

