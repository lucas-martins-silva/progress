/*******************************************************************************
**
** IM9033.i - Aprovacao Mapa Cotacao - Alteracao Pedidos/Ordens
**
*******************************************************************************/
{cdp/cdcfgmat.i} /* Definicao de pre-processadores */

{include/boerrtab.i}
def var i-seq-erro as integer init 0 no-undo.
{cdp/cd4300.i3}
{ccp/cc9019.i50}

def var i-numero-ordem like cotacao-item-cex.numero-ordem  no-undo.
def var i-cod-emitente like cotacao-item-cex.cod-emitente  no-undo.
def var c-it-codigo    like cotacao-item-cex.it-codigo     no-undo.
def var i-seq-cotac    like cotacao-item-cex.seq-cotac     no-undo.
def var da-cotacao     like cotacao-item-cex.data-cotacao  no-undo.
def var i-mapa-cotacao like cotacao-item-cex.mapa-cotacao  no-undo.
def var c-return       as char   no-undo.
DEF VAR h-bocx085      AS HANDLE NO-UNDO.

def input parameter r-chave as rowid no-undo.
def output parameter table for tt-bo-erro.

find cotacao-item-cex 
    where rowid(cotacao-item-cex) = r-chave 
    no-lock no-error.

IF AVAIL cotacao-item-cex THEN DO:
    assign i-numero-ordem = cotacao-item-cex.numero-ordem 
           i-cod-emitente = cotacao-item-cex.cod-emitente 
           c-it-codigo    = cotacao-item-cex.it-codigo
           i-seq-cotac    = cotacao-item-cex.seq-cotac
           da-cotacao     = cotacao-item-cex.data-cotacao
           i-mapa-cotacao = cotacao-item-cex.mapa-cotacao.

    /* Verifica se a ordem de compra est  vinculada a um embarque */
    
    FIND FIRST ordens-embarque 
         WHERE ordens-embarque.numero-ordem = i-numero-ordem NO-LOCK NO-ERROR.

    IF AVAIL ordens-embarque THEN DO:
        CREATE tt-bo-erro.
        {utp/ut-liter.i Ordem_de_Compra * L}
        ASSIGN c-return = TRIM(RETURN-VALUE) + " " + STRING(cotacao-item-cex.numero-ordem). 
        {utp/ut-liter.i Ordem_de_compra_j _est _vinculada_a_um_Embarque. * L}
        ASSIGN tt-bo-erro.parametros    = c-return + "~~" + TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 26802,
                           INPUT tt-bo-erro.parametros).
        ASSIGN tt-bo-erro.i-sequen      = 1
               tt-bo-erro.cd-erro       = 26802
               tt-bo-erro.mensagem      = RETURN-VALUE.
        UNDO,RETURN "NOK":U.
    END.

END.
for each cotacao-item-cex no-lock
    where cotacao-item-cex.numero-ordem = i-numero-ordem and
          cotacao-item-cex.cod-emitente = i-cod-emitente and
          cotacao-item-cex.it-codigo    = c-it-codigo and
          cotacao-item-cex.data-cotacao = da-cotacao and
          cotacao-item-cex.seq-cotac    = i-seq-cotac and
          cotacao-item-cex.mapa-cotacao = i-mapa-cotacao:

    if cotacao-item-cex.cod-emitente-desp = 0 then do:
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */    
        {utp/ut-field.i mgcex cotacao-item-cex cod-emitente-desp 1}
        /******************************************/
        assign c-return = return-value.
        {utp/ut-liter.i zero * L}
        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        assign tt-bo-erro.parametros = c-return + "~~" + return-value. 
        run utp/ut-msgs.p (input "msg",
                           input 7972,
                           input c-return + "~~" + return-value).
        assign tt-bo-erro.i-sequen = i-seq-erro
      	        tt-bo-erro.cd-erro  = 7972
     	        tt-bo-erro.mensagem = return-value.    
        leave.
    end.

    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
    
        IF cotacao-item-cex.log-recalc-val THEN DO:
            create tt-bo-erro.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Mapa" *}
            assign tt-bo-erro.parametros = RETURN-VALUE + "~~" + STRING(cotacao-item-cex.cod-desp).
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Mapa" *}
            run utp/ut-msgs.p (input "msg",
                               input 30076,
                               input RETURN-VALUE + "~~" + STRING(cotacao-item-cex.cod-desp)).
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 30076
                   tt-bo-erro.mensagem = return-value.    

        END.
    
    &ENDIF
    
    {imp/im9053.i} /* Validacoes: - cotacao-item-cex.cod-emitente-desp = 0 
                    *             - cotacao-item-cex.cod-pto-contr = 0
                    *             - cotacao-item-cex.val-desp = 0 / cotacao-item-cex.val-desp = ? 
                    */
    
end.

if not can-find(first tt-bo-erro) then do:           
    find cotacao-item 
        where cotacao-item.it-codigo    = c-it-codigo 
          and cotacao-item.cod-emitente = i-cod-emitente 
          and cotacao-item.data-cotacao = da-cotacao 
          and cotacao-item.numero-ordem = i-numero-ordem
          &if defined(bf-mat-comex) &then
          &else
            and cotacao-item.seq-cotac  = i-seq-cotac                             
          &endif
          exclusive-lock no-error no-wait.
    if locked(cotacao-item) then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 16096,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
      	        tt-bo-erro.cd-erro  = 16096
     	        tt-bo-erro.mensagem = return-value.
    end.
end.

if avail cotacao-item then do:
    &if defined(bf-mat-comex) &then    
        assign i-mapa-cotacao-i50  = int(string(substring(cotacao-item.char-1,6,2),"99"))
               c-cod-incoterm-i50  = substring(cotacao-item.char-1,8,3)
               i-cod-pto-contr-i50 = int(string(substring(cotacao-item.char-1,11,5),"99999")).
    &else
        {cdp/cd4300.i4 "yes" cotacao-item.char-1}
        {ccp/cc9019.i51 "yes"}
    &endif
    if i-mapa-cotacao-i50 <> i-mapa-cotacao then do:
        run utp/ut-msgs.p (input "msg",
                           input 17273,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = 1
               tt-bo-erro.cd-erro  = 17273
               tt-bo-erro.mensagem = return-value.

        &if  "{&bf_mat_versao_ems}":U >= "2.062":U  &then
        
        IF  NOT VALID-HANDLE(h-bocx085) THEN
            RUN cxbo/bocx085.p PERSISTENT SET h-bocx085.

        IF  VALID-HANDLE(h-bocx085) THEN DO:
            RUN atualizaMapaDespesasPedido IN h-bocx085 (INPUT ROWID(cotacao-item),
                                                         INPUT i-mapa-cotacao,
                                                         INPUT i-mapa-cotacao-i50).
            DELETE PROCEDURE h-bocx085 NO-ERROR.
            ASSIGN h-bocx085 = ?.
        END.

        &endif
    end.
    assign i-mapa-cotacao-i50     = i-mapa-cotacao
           d-entrega-embarque-i50 = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.
    &if defined(bf-mat-comex) &then
        assign substring(cotacao-item.char-1,6,2)  = string(i-mapa-cotacao-i50,"99")
               substring(cotacao-item.char-1,8,3)  = c-cod-incoterm-i50
               substring(cotacao-item.char-1,11,5) = string(i-cod-pto-contr-i50,"99999").
    &else
        {ccp/cc9019.i51 "no"}
        {cdp/cd4300.i4 "no" cotacao-item.char-1}
    &endif
end.
else
    if not can-find(first tt-bo-erro) then do:
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-table.i mgind cotacao-item 1}
        /******************************************/
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign tt-bo-erro.i-sequen = 1
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = return-value.
    end.

/* IM9033.I */    
