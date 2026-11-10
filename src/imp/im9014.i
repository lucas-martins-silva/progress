/*********************************************************************

IM9014.I - IntegraÁ„o de importaÁ„o
           Listagem Conferància de documentos
           Definiá∆o das vari†veis e temp-tables
            
**********************************************************************/

    {utp/ut-liter.i Forn_Desp * r}
    assign c-lb-forn = trim(return-value).
    {utp/ut-liter.i Despesa * r}
    assign c-lb-despesa = trim(return-value).
    {utp/ut-liter.i Descriá∆o * l}
    assign c-lb-desc-desp = trim(return-value).
    {utp/ut-liter.i Valor_Despesa * r}
    assign c-lb-val-desp = trim(return-value).
    {utp/ut-liter.i Cond_Pgto * r}
    assign c-lb-cond-pagto = trim(return-value).
    {utp/ut-liter.i Descricao * l}
    assign c-lb-descricao = trim(return-value).

&if defined(bf-mat-comex) &then        

    {utp/ut-liter.i Nome_Abrev * r}
    assign c-lb-nome-abrev = trim(return-value).
    
    form
        c-lb-forn        at   1 format "x(9)"  
        c-lb-nome-abrev  at  11 format "x(12)" 
        c-lb-despesa     at  24 format "x(7)"  
        c-lb-desc-desp   at  32 format "x(30)" 
        c-lb-val-desp    at  68 format "x(13)" 
        c-lb-cond-pagto  at  83 format "x(9)"  
        c-lb-descricao   at  93 format "x(30)" skip
        "---------"
        "------------"
        "-------"
        "------------------------------"
        "-------------------"
        "---------"
        "------------------------------"
        with down stream-io no-labels no-box width 132 frame f-docum-est-cex2.
    
    /* DOCUM-EST-CEX */
    form docum-est-cex.cod-emitente-desp     at  1
         c-emitente like emitente.nome-abrev at 11
         docum-est-cex.cod-desp              at 25
         c-desp-imp like desp-imp.descricao  at 32
         docum-est-cex.val-desp              at 66
         docum-est-cex.cod-cond-pag          at 88
         c-cod-cond-pag                      at 93
         with stream-io no-box no-labels width 132 64 down frame f-docum-est-cex.
         
    {utp/ut-liter.i Tipo_Despesa:_ * r}
    assign c-lb-tipo-desp = trim(return-value).
    {utp/ut-liter.i Incoterm_de_Rateio:_ * r}
    assign c-lb-incoterm-rat = trim(return-value).
    
    form c-lb-tipo-desp    at 32 c-tipo-desp    format "x(21)" at 46
         c-lb-incoterm-rat at 68 c-incoterm-rat format "x(3)"  at 88
         with down width 132 no-labels no-box stream-io frame f-detalha-desp.

&else

    {utp/ut-liter.i Nome_Abreviado * r}
    assign c-lb-nome-abrev = trim(return-value).

    form
        c-lb-forn        at   1 format "x(9)"  
        c-lb-nome-abrev  at  11 format "x(14)" 
        c-lb-despesa     at  26 format "x(7)"  
        c-lb-desc-desp   at  34 format "x(30)" 
        c-lb-val-desp    at  71 format "x(13)" 
        c-lb-cond-pagto  at  85 format "x(9)"  
        c-lb-descricao   at  95 format "x(30)" skip
        "---------"
        "--------------"
        "-------"
        "------------------------------"
        "-------------------"
        "---------"
        "------------------------------"
        with down stream-io no-labels no-box width 132 frame f-docum-est-cex2.
    
    /* DOCUM-EST-CEX */
    form docum-est-cex.cod-emitente-desp     at  1
         c-emitente like emitente.nome-abrev at 11
         docum-est-cex.cod-desp              at 27
         c-desp-imp like desp-imp.descricao  at 34
         docum-est-cex.val-desp              at 68
         docum-est-cex.cod-cond-pag          at 90
         c-cod-cond-pag                      at 95
         with stream-io no-box no-labels width 132 64 down frame f-docum-est-cex.
         
    {utp/ut-liter.i Tipo_Despesa:_ * r}
    assign c-lb-tipo-desp = trim(return-value).
    {utp/ut-liter.i Incoterm_de_Rateio:_ * r}
    assign c-lb-incoterm-rat = trim(return-value).
    
    form c-lb-tipo-desp    at 34 c-tipo-desp    format "x(21)" at 48
         c-lb-incoterm-rat at 70 c-incoterm-rat format "x(3)"  at 90
         with down width 132 no-labels no-box stream-io frame f-detalha-desp.

&endif

form c-tit-doc-cex format "x(132)"
     with stream-io no-box no-label width 132 frame f-tit-doc-cex.

/* ITEM-DOC-EST-CEX */          
form item-doc-est-cex.sequencia          FORMAT ">>>>>>>>9" AT 1 LABEL "SeqÅància"
     item-doc-est-cex.cod-emitente-desp
     c-emitente2 like emitente.nome-abrev
     item-doc-est-cex.cod-desp 
     c-desp-imp2 like desp-imp.descricao
     &IF DEFINED(bf_mat_versao_ems) &THEN
         &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
             c-embrq      column-label "Embarque"
             c-seqnc      column-label "SeqÅància"
             da-data-cot  column-label "Data Cotaá∆o"
         &ENDIF
     &ENDIF
     item-doc-est-cex.val-desp
     with stream-io no-box width 132 64 down frame f-item-doc-est-cex.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-item-doc-est-cex:HANDLE).

          
form c-tit-it-doc-cex format "x(132)"
     with stream-io no-box no-label width 132 frame f-tit-it-doc-cex.
     
/* DUPLI-APAGAR-CEX */ 
form dupli-apagar-cex.cod-emitente-desp column-label "Forn Desp"
     c-emitente3                        column-label "Nome Abrev" skip(1)
     with stream-io no-box 64 down width 132 frame f-emit-dupli.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-emit-dupli:HANDLE).


form dupli-apagar-cex.parcela       column-label "Pa"
     dupli-apagar-cex.cod-esp
     dupli-apagar-cex.tp-despesa
     dupli-apagar-cex.nr-duplic
     dupli-apagar-cex.dt-emissao
     dupli-apagar-cex.dt-trans
     dupli-apagar-cex.dt-vencim
     de-valor-pagar
     dupli-apagar-cex.desconto
     dupli-apagar-cex.dt-venc-desc
     c-esp-movto  format "x(1)" column-label "D/C"
     da-data-pag
     de-valor-pag  skip(1)
     header "*------------------------------------------   Informado   --------------------------------------------*" space (1)
            "*---------Previsto---------*"  
     with stream-io no-box 64 down width 132 frame f-dupli-apagar-cex.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-dupli-apagar-cex:HANDLE).

     
form dupli-apagar-cex.cod-emitente-desp column-label "Forn Desp"
     c-emitente4 column-label "Nome Abrev" skip(1)
     with stream-io no-box 64 down width 132 frame f-emit-dupli1. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-emit-dupli1:HANDLE).
    
     
form dupli-apagar-cex.parcela       column-label "Pa"
     dupli-apagar-cex.cod-esp
     dupli-apagar-cex.tp-despesa
     dupli-apagar-cex.nr-duplic
     dupli-apagar-cex.dt-emissao
     dupli-apagar-cex.dt-trans
     dupli-apagar-cex.dt-vencim
     de-valor-pagar
     dupli-apagar-cex.desconto
     dupli-apagar-cex.dt-venc-desc
     c-esp-movto  format "x(1)" column-label "D/C"
     with stream-io no-box 64 down width 132 frame f-dupli-apagar-cex1. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-dupli-apagar-cex1:HANDLE).
    

{utp/ut-liter.i Pa * r}
assign dupli-apagar-cex.parcela:label in frame f-dupli-apagar-cex = trim(return-value).
{utp/ut-liter.i Dt_Vencto * r}
assign da-data-pag:label in frame f-dupli-apagar-cex = trim(return-value).
{utp/ut-liter.i D/C * r}
assign c-esp-movto:label in frame f-dupli-apagar-cex = trim(return-value).
{utp/ut-liter.i Vl._Duplicata * r}
assign de-valor-pag:label in frame f-dupli-apagar-cex = trim(return-value).

form c-tit-dupli-cex format "x(132)"
     with stream-io no-box no-label width 132 frame f-tit-dupli-cex.     
