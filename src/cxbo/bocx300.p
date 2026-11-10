/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX300 2.00.00.032 } /*** 010032 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx300 MUT}
&ENDIF


/*******************************************************************************
**
**  BOCX300.P
**
**  cot-ordem - Cota‡äes por Grupo Ordem
**
*******************************************************************************/
{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */



&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY cot-ordem
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME cot-ordem

{include/boini.i}
{cxbo/bocx300.i RowObject}
{cxbo/bocx305.i tt-desp-cot-ordem}
{cxbo/bocx305.i tt-desp-cot-ordem-aux}
{cxbo/bocx085.i tt-cotacao-item-cex}
{cxbo/bocx085.i tt-cotacao-item-cex-aux}
{cdp/cd4300.i3}  /* include atributo livre */
{ccp/cc9019.i50} /* include atributo livre cotacao-item.char-1 */
{imp/imapi001.i}
{imp/im0091.i} /* include definicao tt-desp-rateio */

{include/i-epc200.i bocx300}
def temp-table tt-bo-erro-aux NO-UNDO like tt-bo-erro.

DEFINE QUERY {&QUERY-NAME} for cot-ordem scrolling.

def var c-cod-agrup1  like cot-ordem.cod-agrup  no-undo.
def var i-mapa-ordem1 like cot-ordem.mapa-ordem no-undo.
def var l-elimina-pai as logical                no-undo.

def var c-action as char no-undo.
def var rRowidCopiado as rowid no-undo.

procedure setConstraint1:
end procedure.

procedure setConstraint2:
    def input parameter p-cod-agrup  like cot-ordem.cod-agrup no-undo.
    def input parameter p-mapa-ordem like cot-ordem.mapa-ordem no-undo.

    assign c-cod-agrup1  = p-cod-agrup 
           i-mapa-ordem1 = p-mapa-ordem. 
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each cot-ordem no-lock.
        when 2 then
            open query {&QUERY-NAME} for each cot-ordem no-lock 
                where cot-ordem.cod-agrup  = c-cod-agrup1 and
                      cot-ordem.mapa-ordem = i-mapa-ordem1.
    end case.
    assign l-query    = true
           i-bo-query = i-abertura.
end procedure.

{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
/* {include/bonav.i} */ 
{include/bofind.i}
{include/bosetcur.i}
{include/bogetcur.i}
{include/bosersen.i}
{include/boprebro.i}
{include/boexecre.i}
/* {include/boexeupt.i} */
{include/boexedel.i}
{include/bovalupt.i}
/* {include/bovaldel.i} */

procedure findFirst:
    if l-query then
        get first {&QUERY-NAME}
            no-lock no-wait.
    else
        find first cot-ordem
            no-lock no-error.
    run setCurrent.
end procedure.

procedure findPrev:
    def output parameter c-return as char.
    def var c-cod-agrup like cot-ordem.cod-agrup no-undo.
    def var i-mapa-ordem like cot-ordem.mapa-ordem no-undo.

    if avail cot-ordem then do:
        assign c-cod-agrup = cot-ordem.cod-agrup
               i-mapa-ordem = cot-ordem.mapa-ordem.
    end.           

    find last cot-ordem where cot-ordem.cod-agrup = c-cod-agrup and
                                  cot-ordem.mapa-ordem < i-mapa-ordem no-lock no-error.
    if not avail cot-ordem then
        find last cot-ordem where cot-ordem.cod-agrup < c-cod-agrup no-lock no-error.

    if not avail cot-ordem then do:
        run utp/ut-msgs.p (input "msg",
                           input 7998,
                           input "").
        assign c-return = return-value.
    end.
    else run setCurrent.
end procedure.

procedure findNext:
    def output parameter c-return as char.
    def var c-cod-agrup like cot-ordem.cod-agrup no-undo.
    def var i-mapa-ordem like cot-ordem.mapa-ordem no-undo.    

    if avail cot-ordem then do:
        assign c-cod-agrup = cot-ordem.cod-agrup
               i-mapa-ordem = cot-ordem.mapa-ordem.
    end.        

    find first cot-ordem where cot-ordem.cod-agrup = c-cod-agrup and
                                  cot-ordem.mapa-ordem > i-mapa-ordem no-lock no-error.
    if not avail cot-ordem then
        find first cot-ordem where cot-ordem.cod-agrup > c-cod-agrup no-lock no-error.

    if not avail cot-ordem then do:
        run utp/ut-msgs.p (input "msg",
                           input 7999,
                           input "").
        assign c-return = return-value.
    end.
    else run setCurrent.
end procedure.

procedure findLast:
    if l-query then
        get last {&QUERY-NAME}
            no-lock no-wait.
    else
        find last cot-ordem
            no-lock no-error.
    run setCurrent.
end procedure.

procedure getRowid:
    def output parameter r-chave as rowid no-undo.
    if avail cot-ordem then do:
        assign r-chave = rowid(cot-ordem).
    end.
    else do:
       assign r-chave = ?.
    end.
end procedure.

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */

    run startMethod ("initializeValidade").
    run endMethod   ("initializeValidade").
end procedure.

procedure findCodigo:
    def input parameter c-cod-agrup        as char    no-undo.
    def input parameter i-numero-ordem     as integer no-undo.
    def input parameter i-cod-emitente     as integer no-undo.
    &if defined(bf-mat-comex) &then
        def input parameter d-data-cotacao as date    no-undo.
    &else
        def input parameter i-seq-cotac    as integer no-undo.
    &endif        
    def input parameter i-mapa-ordem       as integer no-undo.
    def output parameter c-return          as char    no-undo.

    &if defined(bf-mat-comex) &then
        find cot-ordem 
            where cot-ordem.cod-agrup    = c-cod-agrup and        
                  cot-ordem.numero-ordem = i-numero-ordem and
                  cot-ordem.cod-emitente = i-cod-emitente and
                  cot-ordem.data-1       = d-data-cotacao and
                  cot-ordem.mapa-ordem   = i-mapa-ordem 
                  no-lock no-error.    
    &else
        find cot-ordem 
            where cot-ordem.cod-agrup    = c-cod-agrup and        
                  cot-ordem.numero-ordem = i-numero-ordem and
                  cot-ordem.cod-emitente = i-cod-emitente and
                  cot-ordem.seq-cotac    = i-seq-cotac and
                  cot-ordem.mapa-ordem   = i-mapa-ordem 
                  no-lock no-error.
    &endif              
    if not avail cot-ordem then do:
        {utp/ut-table.i mgcex cot-ordem 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.                           
    end.
    else do:
       run setCurrent.
    end.

end procedure.

procedure findVapara:
    def input parameter c-cod-agrup like cot-ordem.cod-agrup no-undo.
    def input parameter i-mapa-ordem like cot-ordem.mapa-ordem no-undo.
    def input parameter c-cod-incoterm like cot-ordem.cod-incoterm no-undo.
    def input parameter i-cod-itiner like cot-ordem.cod-itiner no-undo.    
    def output parameter c-return as char no-undo.    

    find first cot-ordem 
        where cot-ordem.cod-agrup    = c-cod-agrup and        
              cot-ordem.mapa-ordem   = i-mapa-ordem and
              cot-ordem.cod-incoterm = c-cod-incoterm and
              cot-ordem.cod-itiner   = i-cod-itiner 
              no-lock no-error.
    if not avail cot-ordem then do:
        {utp/ut-table.i mgcex cot-ordem 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.                           
    end.
    else do:
       run setCurrent.
    end.

end procedure.

procedure findCotacao:
    def input parameter i-numero-ordem as integer no-undo.
    def input parameter i-cod-emitente as integer no-undo.
    def input parameter d-data-cotacao as date no-undo.    
    &if defined(bf-mat-comex) &then 
    &else
        def input parameter i-seq-cotac as integer no-undo.    
    &endif    
    def output parameter c-return as char no-undo.    

    find cot-ordem 
        where cot-ordem.numero-ordem = i-numero-ordem 
          and cot-ordem.cod-emitente = i-cod-emitente 
          and cot-ordem.data-1       = d-data-cotacao 
          &if defined(bf-mat-comex) &then 
          &else
              and cot-ordem.seq-cotac = i-seq-cotac 
          &endif          
          no-lock no-error.

    if not avail cot-ordem then do:
        {utp/ut-table.i mgcex cot-ordem 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.                           
    end.
    else do:
       run setCurrent.
    end.

end procedure.

procedure findOrdemqt:
    def input parameter i-numero-ordem as integer no-undo.
    def output parameter d-quantidade like cotacao-item.preco-unit no-undo.
    def output parameter c-return as char no-undo.

    find ordem-compra where ordem-compra.numero-ordem = i-numero-ordem no-lock no-error.
    if avail ordem-compra then do:
        for each prazo-compra 
            where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
            no-lock:
            assign d-quantidade = d-quantidade + prazo-compra.quantidade.                
        end.
    end.        
    else do:        
        {utp/ut-liter.i Ordem_de_compra mim L}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.                           
    end.
end procedure.

procedure findOrdemQtFornec:
    def input parameter i-numero-ordem as integer no-undo.
    def output parameter d-quantidade like cotacao-item.preco-unit no-undo.
    def output parameter c-return as char no-undo.

    find ordem-compra where ordem-compra.numero-ordem = i-numero-ordem no-lock no-error.
    if avail ordem-compra then do:
        for each prazo-compra 
            where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
            no-lock:
            assign d-quantidade = d-quantidade + prazo-compra.qtd-do-forn.                
        end.
    end.        
    else do:        
        {utp/ut-liter.i Ordem_de_compra mim L}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.                           
    end.
end procedure.

procedure findCotacao2:
    def input parameter i-numero-ordem  like cotacao-item.numero-ordem no-undo.
    def input parameter i-cod-emitente  like cotacao-item.cod-emitente no-undo.
    def input parameter da-cotacao      like cotacao-item.data-cotacao no-undo.    
    &if defined(bf-mat-comex) &then
    &else
        def input parameter i-seq-cotac like cotacao-item.seq-cotac    no-undo.    
    &endif
    def output parameter i-mo-codigo    like cotacao-item.mo-codigo    no-undo.
    def output parameter d-preco-unit   like cotacao-item.preco-unit   no-undo.
    def output parameter c-return       as char no-undo.


    find ordem-compra where ordem-compra.numero-ordem = i-numero-ordem no-lock no-error.
    if avail ordem-compra then do:
        find cotacao-item 
            where cotacao-item.numero-ordem  = i-numero-ordem 
              and cotacao-item.cod-emitente  = i-cod-emitente 
              and cotacao-item.it-codigo     = ordem-compra.it-codigo
              and cotacao-item.data-cotacao  = da-cotacao
              &if defined(bf-mat-comex) &then                                                                
              &else
                  and cotacao-item.seq-cotac = i-seq-cotac
              &endif
              no-lock no-error.
        if avail cotacao-item then 
            assign i-mo-codigo  = cotacao-item.mo-codigo
                   d-preco-unit = (cotacao-item.preco-unit * 100) / (100 + cotacao-item.aliquota-ipi). /** preco sem ipi **/
        else do:            
            {utp/ut-liter.i Cota‡Æo_item mim L}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign c-return = return-value.                           
        end.            
    end.    
    if not avail ordem-compra then do:
        {utp/ut-liter.i Ordem_de_compra mim L}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.                           
    end.

end procedure.

procedure findCotacao3: /** preco unitario do fornecedor **/
    def input parameter i-numero-ordem       like cotacao-item.numero-ordem no-undo.
    def input parameter i-cod-emitente       like cotacao-item.cod-emitente no-undo.
    def input parameter da-cotacao           like cotacao-item.data-cotacao no-undo.    
    &if defined(bf-mat-comex) &then
    &else
        def input parameter i-seq-cotac      like cotacao-item.seq-cotac    no-undo.    
    &endif
    def output parameter i-mo-codigo         like cotacao-item.mo-codigo    no-undo.
    def output parameter d-preco-unit-fornec like cotacao-item.preco-unit   no-undo.
    def output parameter c-return            as char no-undo.


    find ordem-compra where ordem-compra.numero-ordem = i-numero-ordem no-lock no-error.
    if avail ordem-compra then do:
        find cotacao-item 
            where cotacao-item.numero-ordem  = i-numero-ordem 
              and cotacao-item.cod-emitente  = i-cod-emitente 
              and cotacao-item.it-codigo     = ordem-compra.it-codigo
              and cotacao-item.data-cotacao  = da-cotacao
              &if defined(bf-mat-comex) &then                                                                
              &else
                  and cotacao-item.seq-cotac = i-seq-cotac
              &endif
              no-lock no-error.
        if avail cotacao-item then
            assign i-mo-codigo         = cotacao-item.mo-codigo
                   d-preco-unit-fornec = (cotacao-item.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi). /** preco sem ipi **/
                   
        else do:            
            {utp/ut-liter.i Cota‡Æo_item mim L}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign c-return = return-value.                           
        end.            
    end.    
    if not avail ordem-compra then do:
        {utp/ut-liter.i Ordem_de_compra mim L}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.                           
    end.

end procedure.

procedure executeUpdate:
    /*
    **  Executa Update
    */

    buffer-copy RowObject except r-rowid
        cod-agrup numero-ordem cod-emitente seq-cotac cod-incoterm mapa-ordem to cot-ordem.
end procedure.

procedure verificaDeletepai:
    def input parameter p-elimina-pai as logical no-undo.

    assign l-elimina-pai = p-elimina-pai.
end.

procedure validateDelete:
    /*
    **  Valida Delete
    */
    def input-output parameter r-chave as rowid.
    def output parameter table for tt-bo-erro.

    def var c-cod-agrup like cot-ordem.cod-agrup no-undo.
    def var i-mapa-ordem like cot-ordem.mapa-ordem no-undo.

    def buffer b-desp-cot-ordem for desp-cot-ordem.

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.    

    if l-elimina-pai then do:
        run validateDeletepai(input-output r-chave,
                              output table tt-bo-erro).
        leave.
    end.

    run InitializeValidate.

    find cot-ordem
        where rowid(cot-ordem) = r-chave
        exclusive-lock no-error.
    if avail cot-ordem then do:
        assign c-cod-agrup  = cot-ordem.cod-agrup
               i-mapa-ordem = cot-ordem.mapa-ordem.
        run executeDelete.
        find first cot-ordem
            where cot-ordem.cod-agrup  = c-cod-agrup
              and cot-ordem.mapa-ordem = i-mapa-ordem
              no-lock no-error.
        if not avail cot-ordem then do:
            for each desp-cot-ordem
                where desp-cot-ordem.cod-agrup  = c-cod-agrup
                  and desp-cot-ordem.mapa-ordem = i-mapa-ordem
                  no-lock:
                find b-desp-cot-ordem 
                    where rowid(b-desp-cot-ordem) = rowid(desp-cot-ordem)
                    exclusive-lock no-error.
                if avail b-desp-cot-ordem then
                    delete b-desp-cot-ordem.
            end.
        end.
    end.

    if not avail cot-ordem then
        find prev cot-ordem
            no-lock no-error.
    if not avail cot-ordem then
        find next cot-ordem
            no-lock no-error.

    assign r-chave = rowid(cot-ordem).
    return "".
end procedure.

procedure validateDeletepai:
    /*
    **  Valida Deletepai
    */
    def input-output parameter r-chave as rowid.
    def output parameter table for tt-bo-erro.

    def var c-cod-agrup like cot-ordem.cod-agrup no-undo.
    def var i-mapa-ordem like cot-ordem.mapa-ordem no-undo.

    run InitializeValidate.

    find cot-ordem where rowid(cot-ordem) = r-chave
        no-lock no-error.
    if avail cot-ordem then do:
        if cot-ordem.mapa-aprovado then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-liter.i Mapa_aprovado * L}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.        
            run utp/ut-msgs.p (input "msg",
                               input 16668,
                               input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 16668
                   tt-bo-erro.mensagem     = return-value.                        
        end.
        else do:
            assign c-cod-agrup = cot-ordem.cod-agrup 
                   i-mapa-ordem = cot-ordem.mapa-ordem.
            for each desp-cot-ordem where desp-cot-ordem.cod-agrup  = c-cod-agrup and
                                          desp-cot-ordem.mapa-ordem = i-mapa-ordem exclusive-lock:
                delete desp-cot-ordem.                                        
            end.         
        end.            
    end.

    find first tt-bo-erro no-error.
    if not avail tt-bo-erro then   
        for each cot-ordem where cot-ordem.cod-agrup = c-cod-agrup and
                                     cot-ordem.mapa-ordem = i-mapa-ordem exclusive-lock:
            delete cot-ordem.                                     
        end.

    if not avail cot-ordem then do:
        find next cot-ordem
            where cot-ordem.cod-agrup  = c-cod-agrup
              and cot-ordem.mapa-ordem > i-mapa-ordem
              no-lock no-error.
        if not avail cot-ordem then
            find next cot-ordem
                where cot-ordem.cod-agrup > c-cod-agrup
                  no-lock no-error.
        if not avail cot-ordem then
            find prev cot-ordem
                where cot-ordem.cod-agrup  = c-cod-agrup
                  and cot-ordem.mapa-ordem < i-mapa-ordem
                  no-lock no-error.                                  
        if not avail cot-ordem then
            find prev cot-ordem
                where cot-ordem.cod-agrup < c-cod-agrup
                  no-lock no-error.
        if not avail cot-ordem then                  
            find first cot-ordem no-lock no-error.                  
    end.

    if avail cot-ordem then
        assign r-chave = rowid(cot-ordem).
    else 
        assign r-chave = ?.
    return "".
end procedure.

procedure validateFields:
    find first rowObject no-lock no-error.    

    if rowObject.cod-itiner = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex cot-ordem cod-itiner 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.            
    end.
    else
        if not can-find(itinerario where itinerario.cod-itiner = rowObject.cod-itiner) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex cot-ordem cod-itiner 1}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
        end.
end procedure.

procedure PassaRowidRegistroCopiado:
/* 
**  Recebe o Rowid do registro que foi copiado, para  
**  copiar tamb‚m as despesas, somente quando for copia.
**/

    def input parameter pRowidCopiado as rowid no-undo. /**/

    assign rRowidCopiado = pRowidCopiado.

end procedure.


procedure SetaAcaoPrograma:

    /*
    **  Verifica se ‚ Copy ou Add.
    */

    def input  parameter paction as char no-undo.

    assign c-action = paction.

end procedure.

procedure validateCreate:

    /*
    **  Valida cria‡Æo da tabela/duplicidade de registro.
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid no-undo.

    def var i-mo-codigo as integer no-undo.
    def var c-return as char no-undo.
    def var c-erros as char no-undo.

    run startMethod("validateCreate":U).

    run initializeValidate.

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    
    FOR EACH tt-desp-cot-ordem:
        DELETE tt-desp-cot-ordem.
    END.

    find first rowObject no-error.        

    if rowObject.cod-agrup = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex cot-ordem cod-agrup 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.    
    end.

    if rowObject.numero-ordem = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex cot-ordem numero-ordem 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.    
    end.

    if rowObject.cod-emitente = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex cot-ordem cod-emitente 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.    
    end.
    else do:
        find emitente where emitente.cod-emitente = rowObject.cod-emitente no-lock no-error.
        if not avail emitente then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex cot-ordem cod-emitente 1}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.        
        end.
        else do:
             {cdp/cd2500.i} /* Se ‚ estrangeiro ou trading */
             {cdp/cd2502.i} /* Se ‚ fornecedor ou ambos */        
        end.
    end.

    if rowObject.data-1 = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Data_da_cota‡Æo L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.        
    end.    

    &if defined(bf-mat-comex) &then        
    &else    
       &IF DEFINED(BF_DIS_VERSAO_EMS) &THEN
           &IF {&BF_DIS_VERSAO_EMS} < 2.04 &THEN
              if rowObject.seq-cotac = 0 then do:
                  assign i-seq-erro = i-seq-erro + 1.
                  {utp/ut-field.i mgcex cot-ordem seq-cotac 1}
                  create tt-bo-erro.
                  assign tt-bo-erro.parametros = return-value.        
                  run utp/ut-msgs.p (input "msg",
                                     input 265,
                                     input return-value).
                  assign tt-bo-erro.i-sequen     = i-seq-erro
                         tt-bo-erro.cd-erro      = 265
                         tt-bo-erro.mensagem     = return-value.        
              end.
           &endif
       &endif
    &endif

    if rowObject.mapa-ordem = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex cot-ordem mapa-ordem 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.        
    end.    
    
    run validateFields.
    

    if not can-find(first tt-bo-erro) then do:
        find ordem-compra where 
             ordem-compra.numero-ordem = rowObject.numero-ordem no-lock no-error.
        if avail ordem-compra then do:
            find cotacao-item 
                where cotacao-item.numero-ordem     = rowObject.numero-ordem 
                  and cotacao-item.cod-emitente     = rowObject.cod-emitente 
                  and cotacao-item.it-codigo        = ordem-compra.it-codigo 
                  and cotacao-item.data-cotacao     = rowObject.data-1
                  &if defined(bf-mat-comex) &then                           
                  &else
                      and cotacao-item.seq-cotac    = rowObject.seq-cotac  
                  &endif
                  no-lock no-error.
            if avail cotacao-item then do:
                assign i-mo-codigo = cotacao-item.mo-codigo.
                &if defined(bf-mat-comex) &then
                    assign i-mapa-cotacao-i50  = int(substring(cotacao-item.char-1,6,2))
                           c-cod-incoterm-i50  = trim(substring(cotacao-item.char-1,8,3))
                           i-cod-pto-contr-i50 = int(substring(cotacao-item.char-1,11,5)).
                &else
                    {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                    {ccp/cc9019.i51 "yes"}
                &endif

                find first rowObject no-error.
                assign rowObject.cod-incoterm = trim(c-cod-incoterm-i50).
                if cotacao-item.preco-unit = 0 then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    {utp/ut-liter.i Cota‡Æo_do_item * L}
                    assign c-return = return-value + " " + string(rowObject.numero-ordem).                    
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = c-return.
                    run utp/ut-msgs.p (input "msg",
                                       input 36,
                                       input c-return).
                    assign tt-bo-erro.i-sequen = i-seq-erro + 1
                           tt-bo-erro.cd-erro  = 36
                           tt-bo-erro.mensagem = return-value.                 
                end.                                

                find first cot-ordem 
                    where cot-ordem.cod-agrup    = rowObject.cod-agrup and
                          cot-ordem.mapa-ordem   = rowObject.mapa-ordem and
                          cot-ordem.cod-emitente = rowObject.cod-emitente no-lock no-error.
                if avail cot-ordem then do:
                    /*frank - 09/05/05*/
                    &if defined(bf-mat-comex) &then
                        find ordem-compra 
                            where ordem-compra.numero-ordem = cot-ordem.numero-ordem no-lock no-error.                        
                        if avail ordem-compra then
                            find cotacao-item 
                                where cotacao-item.numero-ordem  = cot-ordem.numero-ordem 
                                  and cotacao-item.cod-emitente  = cot-ordem.cod-emitente 
                                  and cotacao-item.it-codigo     = ordem-compra.it-codigo 
                                  and cotacao-item.data-cotacao  = cot-ordem.data-1
                                  &if defined(bf-mat-comex) &then                                   
                                  &else
                                      and cotacao-item.seq-cotac = cot-ordem.seq-cotac 
                                  &endif
                                  no-lock no-error.                                  
                        if avail cotacao-item then
                            if cotacao-item.mo-codigo <> i-mo-codigo then do:
                                assign i-seq-erro = i-seq-erro + 1.
                                create tt-bo-erro.
                                assign tt-bo-erro.parametros = string(i-mo-codigo) + "~~" + 
                                                               string(cotacao-item.mo-codigo) + "~~" +
                                                               string(rowObject.cod-emitente).
                                run utp/ut-msgs.p (input "msg",
                                                   input 18848,
                                                   input string(i-mo-codigo) + "~~" + 
                                                         string(cotacao-item.mo-codigo) + "~~" + 
                                                         string(rowObject.cod-emitente) ).
                                assign tt-bo-erro.i-sequen     = i-seq-erro
                                       tt-bo-erro.cd-erro      = 18848
                                       tt-bo-erro.mensagem     = return-value.                        
                            end.
                    &else
                        &if '{&bf_dis_versao_ems}' < '2.04' &then
                            /* Valida se o fornecedor possui outra despesa com moeda diferente*/
                            find ordem-compra 
                                where ordem-compra.numero-ordem = cot-ordem.numero-ordem no-lock no-error.                        
                            if avail ordem-compra then
                                find cotacao-item 
                                    where cotacao-item.numero-ordem  = cot-ordem.numero-ordem 
                                      and cotacao-item.cod-emitente  = cot-ordem.cod-emitente 
                                      and cotacao-item.it-codigo     = ordem-compra.it-codigo 
                                      and cotacao-item.data-cotacao  = cot-ordem.data-1
                                      &if defined(bf-mat-comex) &then                                   
                                      &else
                                          and cotacao-item.seq-cotac = cot-ordem.seq-cotac 
                                      &endif
                                      no-lock no-error.                                  
                            if avail cotacao-item then
                                if cotacao-item.mo-codigo <> i-mo-codigo then do:
                                    assign i-seq-erro = i-seq-erro + 1.
                                    create tt-bo-erro.
                                    assign tt-bo-erro.parametros = string(i-mo-codigo) + "~~" + 
                                                                   string(cotacao-item.mo-codigo) + "~~" +
                                                                   string(rowObject.cod-emitente).
                                    run utp/ut-msgs.p (input "msg",
                                                       input 18848,
                                                       input string(i-mo-codigo) + "~~" + 
                                                             string(cotacao-item.mo-codigo) + "~~" + 
                                                             string(rowObject.cod-emitente) ).
                                    assign tt-bo-erro.i-sequen     = i-seq-erro
                                           tt-bo-erro.cd-erro      = 18848
                                           tt-bo-erro.mensagem     = return-value.                        
                                end.
                        &endif
                    &endif
                    /*fim frank - 09/05/05*/
                end.
                else 
                    find first cot-ordem 
                        where cot-ordem.cod-agrup    = rowObject.cod-agrup and
                              cot-ordem.mapa-ordem   = rowObject.mapa-ordem no-lock no-error.                                              
                if avail cot-ordem then do:
                    if c-cod-incoterm-i50 <> cot-ordem.cod-incoterm then do:
                        assign i-seq-erro = i-seq-erro + 1.
                        run utp/ut-msgs.p (input "msg",
                                           input 17478,
                                           input "").
                        create tt-bo-erro.
                        assign tt-bo-erro.i-sequen = i-seq-erro
                               tt-bo-erro.cd-erro  = 17478
                               tt-bo-erro.mensagem = return-value.                                                               
                    end.
                    if rowObject.cod-itiner <> cot-ordem.cod-itiner then do:
                        assign i-seq-erro = i-seq-erro + 1.
                        {utp/ut-field.i mgcex cot-ordem cod-itiner 1}
                        create tt-bo-erro.
                        assign tt-bo-erro.parametros = return-value.
                        run utp/ut-msgs.p (input "msg",
                                           input 2,
                                           input return-value).
                        assign tt-bo-erro.i-sequen = i-seq-erro
                               tt-bo-erro.cd-erro  = 2
                               tt-bo-erro.mensagem = return-value.                    
                    end.
                end.                
            end.        
            else do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-liter.i Cota‡Æo_do_item mim L}
                create tt-bo-erro.
                assign tt-bo-erro.parametros = return-value.
                run utp/ut-msgs.p (input "msg",
                                   input 2,
                                   input return-value).
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 2
                       tt-bo-erro.mensagem = return-value.                                           
            end.
        end.                               
        else do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 6349,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 6349
                   tt-bo-erro.mensagem = return-value.
        end.
    end.        

    find first tt-bo-erro no-error.
    if not avail tt-bo-erro then do:   
        find cot-ordem 
            where cot-ordem.numero-ordem = rowObject.numero-ordem 
              and cot-ordem.cod-emitente = rowObject.cod-emitente 
              and cot-ordem.data-1       = rowObject.data-1 
              &if defined(bf-mat-comex) &then              
              &else
                  and cot-ordem.seq-cotac    = rowObject.seq-cotac
              &endif              
              no-lock no-error.
        if avail cot-ordem then do:                              
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex cot-ordem 1}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value + " " + string(rowObject.numero-ordem) + "~~" + cot-ordem.cod-agrup.
            run utp/ut-msgs.p (input "msg",
                               input 428,
                               input return-value + " " + string(rowObject.numero-ordem)  + "~~" + cot-ordem.cod-agrup).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 428
                   tt-bo-erro.mensagem     = return-value.
        end.
    end.

    for each tt-bo-erro:
        assign c-erros = c-erros + string(tt-bo-erro.cd-erro) + " ".        
    end.    

    find first tt-bo-erro no-error. 
    if not avail tt-bo-erro then do:

        if c-action = "Copy" then
           assign rowObject.mapa-aprovado = no.

        run executeCreate.
        assign r-chave = to-rowid(return-value).
        
        run createDespauto(input r-chave).
        
        for each tt-bo-erro:
            delete tt-bo-erro.
        end.       
    end.
    else do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Cota‡Æo_item mim L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value + " " + string(rowObject.numero-ordem) + "~~" + c-erros.
        run utp/ut-msgs.p (input "msg",
                           input 18880,
                           input return-value + " " + string(rowObject.numero-ordem)  + "~~" + c-erros).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 18880
               tt-bo-erro.mensagem     = return-value.       
    end.
    run endMethod("validateCreate").    
end procedure.

procedure desaprovaGrupo:
    /*
    ** Desaprova cotacoes das ordens aprovadas
    */
    def input parameter  p-chave as rowid no-undo.
    def output parameter table for tt-bo-erro.

    def var c-cod-agrup  like cot-ordem.cod-agrup  no-undo.
    def var i-mapa-ordem like cot-ordem.mapa-ordem no-undo.
    def var h-bocx085    as handle                 no-undo.
    def var l-ok         as logical initial no     no-undo.

    def buffer b-cotacao-item-cex for cotacao-item-cex.
    def buffer b-cot-ordem        for cot-ordem.

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    find cot-ordem where rowid(cot-ordem) = p-chave no-lock no-error.
    if avail cot-ordem then do:
        assign c-cod-agrup  = cot-ordem.cod-agrup
               i-mapa-ordem = cot-ordem.mapa-ordem.
    end.

    run valDesaprovargrupo(input c-cod-agrup,
                           input i-mapa-ordem,
                           output table tt-bo-erro).

    find first tt-bo-erro no-error.
    if avail tt-bo-erro then
        leave.
    else do:    
        for each cot-ordem 
            where cot-ordem.cod-agrup  = c-cod-agrup 
              and cot-ordem.mapa-ordem = i-mapa-ordem 
              no-lock:
            assign l-ok = yes.              
            find ordem-compra 
                where ordem-compra.numero-ordem = cot-ordem.numero-ordem
                no-lock no-error.
            if avail ordem-compra then do:            
                find cotacao-item 
                    where cotacao-item.it-codigo    = ordem-compra.it-codigo 
                      and cotacao-item.cod-emitente = cot-ordem.cod-emitente 
                      and cotacao-item.data-cotacao = cot-ordem.data-1 
                      and cotacao-item.numero-ordem = cot-ordem.numero-ordem
                      &if defined(bf-mat-comex) &then 
                      &else
                          and cotacao-item.seq-cotac    = cot-ordem.seq-cotac
                      &endif
                      exclusive-lock no-error.
                if avail cotacao-item then do:                                    
                    &if defined(bf-mat-comex) &then
                        assign substring(cotacao-item.char-1,6,2) = string(0,"99").
                    &else
                        {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                        {ccp/cc9019.i51 "yes"}
                        assign i-mapa-cotacao-i50     = 0
                               d-entrega-embarque-i50 = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.
                        {ccp/cc9019.i51 "no"}
                        {cdp/cd4300.i4 "no" cotacao-item.char-1}
                    &endif
                end.
                for each cotacao-item-cex
                    where cotacao-item-cex.numero-ordem = cot-ordem.numero-ordem
                      and cotacao-item-cex.cod-emitente = cot-ordem.cod-emitente
                      and cotacao-item-cex.it-codigo    = ordem-compra.it-codigo
                      and cotacao-item-cex.seq-cotac    = cot-ordem.seq-cotac
                      and cotacao-item-cex.data-cotacao = cot-ordem.data-1
                      and cotacao-item-cex.mapa-cotacao = cot-ordem.mapa-ordem
                      no-lock:
                    find b-cotacao-item-cex 
                        where rowid(b-cotacao-item-cex) = rowid(cotacao-item-cex)
                        exclusive-lock no-error no-wait.
                    if locked(b-cotacao-item-cex) then
                        undo, leave.
                    else delete b-cotacao-item-cex.
                end.                        
            end.
            find b-cot-ordem 
                where rowid(b-cot-ordem) = rowid(cot-ordem) 
                exclusive-lock no-error no-wait.
            if locked(b-cot-ordem) then
                undo, leave.
            if avail b-cot-ordem then
                assign b-cot-ordem.mapa-aprovado = no.
        end.
    end.

    if not l-ok then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Processo_de_desaprova‡Æo mim L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 15933,
                           input c-return).
        assign tt-bo-erro.i-sequen = i-seq-erro + 1
               tt-bo-erro.cd-erro  = 15933
               tt-bo-erro.mensagem = return-value.
    end.
end procedure.

procedure aprovaGrupo:
    /*
    ** Aprova grupo de ordens (cria mapa de despesas adicionais(cotacao-item-cex) por ordem).
    ** Rateia o valor das despesas entre as ordens informadas no grupo baseado no valor individual da ordem.
    */
    def input  parameter p-chave as rowid no-undo.
    def output parameter table for tt-bo-erro.

    def var c-cod-agrup   like cot-ordem.cod-agrup       no-undo.
    def var i-mapa-ordem  like cot-ordem.mapa-ordem      no-undo.    
    def var c-cod-estabel like estabelec.cod-estabel     no-undo.
    def var h-im0091      as handle                      no-undo.
    def var de-val-desp   like cotacao-item-cex.val-desp no-undo.    

    for each tt-cotacao-item-cex:
        delete tt-cotacao-item-cex.                
    end.

    find cot-ordem where rowid(cot-ordem) = p-chave no-lock no-error.
    if avail cot-ordem then do:
        assign c-cod-agrup  = cot-ordem.cod-agrup
               i-mapa-ordem = cot-ordem.mapa-ordem.
        find ordem-compra
            where ordem-compra.numero-ordem = cot-ordem.numero-ordem no-lock no-error.
        assign c-cod-estabel = ordem-compra.cod-estabel.            
    end.
    /*-----------------------------------------------------------------*/
    /* Include i-epc200.i2: Criacao de registro para temp-table tt-epc */
    for each tt-epc where tt-epc.cod-event = "BeforeAprovaGrupo":
        delete tt-epc.
    end.
    {include/i-epc200.i2 &CodEvent='"BeforeAprovaGrupo"'
                       &CodParameter='"r-rowid"'
                       &ValueParameter="STRING(rowid(cot-ordem))"}
    /* Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i "BeforeAprovaGrupo"}
    /*-----------------------------------------------------------------*/

    /* Valida Aprova‡Æo do Grupo */
    run valAprovargrupo(input c-cod-agrup,
                        input i-mapa-ordem,
                        output table tt-bo-erro).

    find first tt-bo-erro
        no-error.
    if avail tt-bo-erro then
        leave.

    /* Cria tt-cotacao-item-cex para cria‡Æo das despesas */

    run imp/im0091.p persistent set h-im0091.
    run setaValorinicial in h-im0091 (input today,
                                      input c-cod-estabel).

    run rateioGrupoordens in h-im0091 (input c-cod-agrup,
                                       input i-mapa-ordem,
                                       &if '{&bf_mat_versao_ems}':U >= '2.062':U &then
                                       input 0,
                                       &endif
                                       output table tt-desp-rateio).

    run getTTbo-erro in h-im0091 (output table tt-bo-erro).
    delete procedure h-im0091.

    find first tt-bo-erro
        no-error.
    if avail tt-bo-erro then
        leave.    

    for each cot-ordem 
        where cot-ordem.cod-agrup  = c-cod-agrup 
          and cot-ordem.mapa-ordem = i-mapa-ordem no-lock: 

        for each desp-cot-ordem
            where desp-cot-ordem.cod-agrup  = cot-ordem.cod-agrup
              and desp-cot-ordem.mapa-ordem = cot-ordem.mapa-ordem no-lock:
         
            find first tt-desp-rateio
                where tt-desp-rateio.numero-ordem = cot-ordem.numero-ordem 
                  and tt-desp-rateio.cod-desp     = desp-cot-ordem.cod-desp no-error.                  

            if not avail tt-desp-rateio then next.

            if tt-desp-rateio.val-desp-unit = 0 then next.
            
            assign de-val-desp = tt-desp-rateio.val-desp-unit.
            if desp-cot-ordem.mo-codigo <> 0 then 
                run cdp/cd0812.p (input 0,
                                  input desp-cot-ordem.mo-codigo,
                                  input tt-desp-rateio.val-desp-unit,
                                  input today,
                                  output de-val-desp).

            /* Cria temp-table para as cotacoes de despesas adicionais do item */     
            create tt-cotacao-item-cex.
            assign tt-cotacao-item-cex.numero-ordem      = cot-ordem.numero-ordem
                   tt-cotacao-item-cex.cod-emitente      = cot-ordem.cod-emitente
                   tt-cotacao-item-cex.it-codigo         = tt-desp-rateio.it-codigo
                   tt-cotacao-item-cex.seq-cotac         = cot-ordem.seq-cotac
                   tt-cotacao-item-cex.data-cotacao      = cot-ordem.data-1
                   tt-cotacao-item-cex.mapa-cotacao      = cot-ordem.mapa-ordem
                   tt-cotacao-item-cex.cod-incoterm      = cot-ordem.cod-incoterm
                   tt-cotacao-item-cex.cod-itiner        = cot-ordem.cod-itiner
                   tt-cotacao-item-cex.sequencia         = desp-cot-ordem.sequencia
                   tt-cotacao-item-cex.cod-emitente-desp = desp-cot-ordem.cod-emitente-desp
                   tt-cotacao-item-cex.cod-desp          = desp-cot-ordem.cod-desp
                   tt-cotacao-item-cex.val-desp          = de-val-desp
                   tt-cotacao-item-cex.nr-tab            = desp-cot-ordem.nr-tab
                   tt-cotacao-item-cex.cod-pto-contr     = desp-cot-ordem.cod-pto-contr
                   tt-cotacao-item-cex.cod-cond-pag      = desp-cot-ordem.cod-cond-pag
                   tt-cotacao-item-cex.data-cotacao-desp = desp-cot-ordem.data-cotacao-desp
                   tt-cotacao-item-cex.mo-codigo         = desp-cot-ordem.mo-codigo
                   tt-cotacao-item-cex.taxa-financ       = desp-cot-ordem.taxa-financ
                   tt-cotacao-item-cex.perc-taxa         = desp-cot-ordem.perc-taxa
                   tt-cotacao-item-cex.perc-descto       = desp-cot-ordem.perc-descto
                   tt-cotacao-item-cex.contato           = desp-cot-ordem.contato
                   tt-cotacao-item-cex.cod-comprado      = desp-cot-ordem.cod-comprado
                   tt-cotacao-item-cex.aprovador         = desp-cot-ordem.aprovador
                   tt-cotacao-item-cex.usuario           = desp-cot-ordem.usuario
                   tt-cotacao-item-cex.data-atualiz      = desp-cot-ordem.data-atualiz
                   tt-cotacao-item-cex.hora-atualiz      = desp-cot-ordem.hora-atualiz
                   tt-cotacao-item-cex.motivo-apr        = desp-cot-ordem.motivo-apr
                   tt-cotacao-item-cex.dias-validade     = desp-cot-ordem.dias-validade
                   tt-cotacao-item-cex.nr-dias-taxa      = desp-cot-ordem.nr-dias-taxa
                   &if "{&bf_mat_versao_ems}" >= "2.05" &then
                   tt-cotacao-item-cex.tp-despesa        = desp-cot-ordem.tp-despesa
                   &endif
                   &if '{&bf_mat_versao_ems}':U >= '2.062':U &then
                   tt-cotacao-item-cex.log-gerac-autom   = desp-cot-ordem.log-gerac-autom  
                   &endif
                   .
        end.               
        /*-----------------------------------------------------------------*/
        /* Include i-epc200.i2: Criacao de registro para temp-table tt-epc */
        for each tt-epc where tt-epc.cod-event = "AfterAprovaGrupo":
            delete tt-epc.
        end.
        {include/i-epc200.i2 &CodEvent='"AfterAprovaGrupo"'
                           &CodParameter='"r-rowid"'
                           &ValueParameter="STRING(rowid(cot-ordem))"}
        /* Include i-epc201.i: Chamada do programa de EPC */
        {include/i-epc201.i "AfterAprovaGrupo"}
        /*-----------------------------------------------------------------*/
    end.       

    run criarDespesas(input c-cod-agrup, input i-mapa-ordem). 


end procedure.

procedure criarDespesas:
/* 
** Cria cotacao despesas adicionais 
*/
def input parameter c-cod-agrup  like cot-ordem.cod-agrup  no-undo.
def input parameter i-mapa-ordem like cot-ordem.mapa-ordem no-undo.

def var h-bocx085   as handle  no-undo.
def var l-ok        as logical no-undo.
def var r-chave-cot as rowid   no-undo.
def var c-return    as char    no-undo.

def buffer b-cot-ordem for cot-ordem.

    find first tt-cotacao-item-cex no-error.
    if avail tt-cotacao-item-cex then
        assign l-ok = yes.               

    run cxbo/bocx085.p persistent set h-bocx085.
    for each tt-cotacao-item-cex:   

        for each tt-cotacao-item-cex-aux:
            delete tt-cotacao-item-cex-aux.
        end.
        create tt-cotacao-item-cex-aux.                        
        buffer-copy tt-cotacao-item-cex to tt-cotacao-item-cex-aux.
        /* Cria registro cotacao-item-cex - rateia valor das despesas */
        run validateCreate in h-bocx085(input  table tt-cotacao-item-cex-aux,
                                        output table tt-bo-erro,
                                        output r-chave-cot).
        
        find first tt-bo-erro no-error.
        if avail tt-bo-erro then do:
            assign l-ok = no.
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-liter.i Processo_de_aprova‡Æo_da_ordem mim L}
            assign c-return = return-value + " " + string(tt-cotacao-item-cex.numero-ordem).
            create tt-bo-erro.
            assign tt-bo-erro.parametros = c-return.
            run utp/ut-msgs.p (input "msg",
                               input 15933,
                               input c-return).
            assign tt-bo-erro.i-sequen = i-seq-erro + 1
                   tt-bo-erro.cd-erro  = 15933
                   tt-bo-erro.mensagem = return-value.                               
            leave.
        end.                
        run aprovaMapa in h-bocx085(input r-chave-cot,
                                    output table tt-bo-erro).
        for each tt-bo-erro:
            delete tt-bo-erro.
        end.
    end.

    if l-ok then
        for each cot-ordem 
            where cot-ordem.cod-agrup  = c-cod-agrup 
              and cot-ordem.mapa-ordem = i-mapa-ordem 
              no-lock:
            find b-cot-ordem where
                rowid(b-cot-ordem) = rowid(cot-ordem) exclusive-lock no-error no-wait.
            if locked(b-cot-ordem) then
                undo, leave.
            else
                assign b-cot-ordem.mapa-aprovado = yes.
        end.

    if not l-ok then do:
        for each tt-cotacao-item-cex:
            find first cotacao-item-cex 
                where cotacao-item-cex.numero-ordem = tt-cotacao-item-cex.numero-ordem
                  and cotacao-item-cex.cod-emitente = tt-cotacao-item-cex.cod-emitente
                  and cotacao-item-cex.it-codigo    = tt-cotacao-item-cex.it-codigo
                  &if defined(bf-mat-comex) &then
                      and cotacao-item-cex.data-cotacao = tt-cotacao-item-cex.data-cotacao
                  &else
                      and cotacao-item-cex.seq-cotac    = tt-cotacao-item-cex.seq-cotac
                  &endif
                  and cotacao-item-cex.mapa-cotacao = tt-cotacao-item-cex.mapa-cotacao
                  no-lock no-error.
            if avail cotacao-item-cex then do:
                assign r-chave-cot = rowid(cotacao-item-cex).
                run validateDeletepai in h-bocx085(input-output r-chave-cot,
                                                   output table tt-bo-erro-aux).
            end.                         
        end.            
    end.

    delete procedure h-bocx085.
end procedure.

procedure valDesaprovargrupo:
    /*
    ** Verifica situcao das cotacoes da ordem para a desaprovacao.
    */
    def input parameter c-cod-agrup like cot-ordem.cod-agrup no-undo.
    def input parameter i-mapa-ordem like cot-ordem.mapa-ordem no-undo.
    def output parameter table for tt-bo-erro.

    def var c-return as char no-undo.

    for each cot-ordem 
        where cot-ordem.cod-agrup  = c-cod-agrup 
          and cot-ordem.mapa-ordem = i-mapa-ordem 
          no-lock:
        find ordem-compra 
            where ordem-compra.numero-ordem = cot-ordem.numero-ordem 
            no-lock no-error.
        if avail ordem-compra then do:            
            find cotacao-item 
                where cotacao-item.it-codigo    = ordem-compra.it-codigo 
                  and cotacao-item.cod-emitente = cot-ordem.cod-emitente 
                  and cotacao-item.data-cotacao = cot-ordem.data-1 
                  and cotacao-item.numero-ordem = cot-ordem.numero-ordem
                  &if defined(bf-mat-comex) &then 
                  &else
                      and cotacao-item.seq-cotac    = cot-ordem.seq-cotac
                  &endif
                  no-lock no-error.            
            if avail cotacao-item then do:
                if cotacao-item.cot-aprovada then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    {utp/ut-liter.i Cota‡Æo_da_ordem * L}
                    assign c-return = return-value + " " + string(cot-ordem.numero-ordem).
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = c-return.
                    run utp/ut-msgs.p (input "msg",
                                       input 19495,
                                       input c-return).
                    assign tt-bo-erro.i-sequen = i-seq-erro + 1
                           tt-bo-erro.cd-erro  = 19495
                           tt-bo-erro.mensagem = return-value.
                end.
            end.
        end.
    end.
end procedure.

procedure valAprovargrupo:
    /*
    ** Verifica situacao das cotacoes da ordem para a aprovacao
    ** Cotacao nao pode estar aprovada, incoterm nao pode estar diferente, cotacao nao pode estar eliminada
    */
    def input parameter c-cod-agrup  like cot-ordem.cod-agrup  no-undo.
    def input parameter i-mapa-ordem like cot-ordem.mapa-ordem no-undo.
    def output parameter table for tt-bo-erro.

    def var c-return as char no-undo.

    DEFINE VARIABLE l-erro     AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE i-cod-desp AS INTEGER    NO-UNDO.

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    for each cot-ordem 
        where cot-ordem.cod-agrup  = c-cod-agrup 
          and cot-ordem.mapa-ordem = i-mapa-ordem 
          no-lock:
        find ordem-compra 
            where ordem-compra.numero-ordem = cot-ordem.numero-ordem 
            no-lock no-error.
        if avail ordem-compra then do:
            /* Ordem precisa estar em cota‡Æo */
            &if defined(bf-mat-comex) &then 
                if ordem-compra.situacao <> "M":U then do:
            &else
                if ordem-compra.situacao <> 5 then do:
            &endif
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-liter.i aprova‡Æo_da_ordem * L}
                assign c-return = return-value + " " + string(cot-ordem.numero-ordem) + ".(Verificar situa‡Æo ordem)".
                create tt-bo-erro.
                assign tt-bo-erro.parametros = c-return.
                run utp/ut-msgs.p (input "msg",
                                   input 17148,
                                   input c-return).
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 17148
                       tt-bo-erro.mensagem = return-value.
                leave.                                       
            end.        
            find cotacao-item 
                where cotacao-item.it-codigo    = ordem-compra.it-codigo 
                  and cotacao-item.cod-emitente = cot-ordem.cod-emitente 
                  and cotacao-item.data-cotacao = cot-ordem.data-1 
                  and cotacao-item.numero-ordem = cot-ordem.numero-ordem
                  &if defined(bf-mat-comex) &then 
                  &else
                      and cotacao-item.seq-cotac    = cot-ordem.seq-cotac
                  &endif
                  no-lock no-error.
            if avail cotacao-item then do:
                if cotacao-item.cot-aprovada then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    {utp/ut-liter.i Cota‡Æo_da_ordem * L}
                    assign c-return = return-value + " " + string(cot-ordem.numero-ordem).                    
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = c-return.
                    run utp/ut-msgs.p (input "msg",
                                       input 19495,
                                       input c-return).
                    assign tt-bo-erro.i-sequen = i-seq-erro
                           tt-bo-erro.cd-erro  = 19495
                           tt-bo-erro.mensagem = return-value.                    
                end.
                &if defined(bf-mat-comex) &then
                    assign i-mapa-cotacao-i50  = int(substring(cotacao-item.char-1,6,2))
                           c-cod-incoterm-i50  = substring(cotacao-item.char-1,8,3)
                           i-cod-pto-contr-i50 = int(substring(cotacao-item.char-1,11,5)).
                &else
                    {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                    {ccp/cc9019.i51 "yes"}
                &endif
                if c-cod-incoterm-i50 <> cot-ordem.cod-incoterm then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    {utp/ut-liter.i cota‡Æo_da_ordem * L}
                    assign c-return = return-value + " " + string(cot-ordem.numero-ordem).                    
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = c-return.
                    run utp/ut-msgs.p (input "msg",
                                       input 17499,
                                       input c-return).
                    assign tt-bo-erro.i-sequen = i-seq-erro
                           tt-bo-erro.cd-erro  = 17499
                           tt-bo-erro.mensagem = return-value.
                end.
                if cotacao-item.preco-unit = 0 then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    {utp/ut-liter.i Cota‡Æo_da_ordem * L}
                    assign c-return = return-value + " " + string(cot-ordem.numero-ordem).                    
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = c-return.
                    run utp/ut-msgs.p (input "msg",
                                       input 36,
                                       input c-return).
                    assign tt-bo-erro.i-sequen = i-seq-erro
                           tt-bo-erro.cd-erro  = 36
                           tt-bo-erro.mensagem = return-value.                 
                end.                
            end.
            else do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-liter.i Cota‡Æo_da_ordem * L}
                assign c-return = return-value + " " + string(cot-ordem.numero-ordem).                    
                create tt-bo-erro.
                assign tt-bo-erro.parametros = c-return.
                run utp/ut-msgs.p (input "msg",
                                   input 18371,
                                   input c-return).
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 18371
                       tt-bo-erro.mensagem = return-value.                        
            end.
        end.
        else do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-liter.i Ordem * L}
            assign c-return = return-value + " " + string(cot-ordem.numero-ordem).                    
            create tt-bo-erro.
            assign tt-bo-erro.parametros = c-return.
            run utp/ut-msgs.p (input "msg",
                               input 18371,
                               input c-return).
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 18371
                   tt-bo-erro.mensagem = return-value.
        end.                                 
    end.    

    find first desp-cot-ordem 
        where desp-cot-ordem.cod-agrup  = c-cod-agrup 
          and desp-cot-ordem.mapa-ordem = i-mapa-ordem
          no-lock no-error.
    if not avail desp-cot-ordem then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Despesas_do_grupo * L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 265
               tt-bo-erro.mensagem = return-value.    
    end.          
    ELSE DO:
        &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
        
            blk_cot_ordem:
            FOR EACH desp-cot-ordem NO-LOCK
               where desp-cot-ordem.cod-agrup  = c-cod-agrup 
               and   desp-cot-ordem.mapa-ordem = i-mapa-ordem:

               IF desp-cot-ordem.log-recalc-val THEN DO:

                  ASSIGN l-erro     = YES
                         i-cod-desp = desp-cot-ordem.cod-desp.

                  LEAVE blk_cot_ordem.
               END.       
            END.

            IF l-erro THEN DO:
                create tt-bo-erro.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Grupo" *}
                assign tt-bo-erro.parametros = RETURN-VALUE + "~~" + STRING(i-cod-desp).
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Grupo" *}
                run utp/ut-msgs.p (input "msg",
                                   input 30076,
                                   input RETURN-VALUE + "~~" + STRING(i-cod-desp)).
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 30076
                       tt-bo-erro.mensagem = return-value.    
            END.
        
        &ENDIF
    END.

end procedure.

procedure createDespauto:
/*
** cria despesas automaticamente conforme itinerario, emitente, item e incoterm
*/
def input parameter p-rowid as rowid no-undo.

def var i-seq-desp as integer no-undo.
def var h-bocx305  as handle  no-undo.
def var r-chave    as rowid   no-undo.

if c-action = "Copy" then do:
    /*Para copiar as despesas do pai copiado*/
    find cot-ordem where
         rowid(cot-ordem) = rRowidCopiado no-lock no-error.

    find ordem-compra where
         ordem-compra.numero-ordem = cot-ordem.numero-ordem no-lock no-error.

    for each desp-cot-ordem where
             desp-cot-ordem.cod-agrup  = cot-ordem.cod-agrup and
             desp-cot-ordem.mapa-ordem = cot-ordem.mapa-ordem no-lock:

             create tt-despesas-im001.
             assign tt-despesas-im001.seq      = i-seq-desp
                    tt-despesas-im001.cod-desp = desp-cot-ordem.cod-desp
                    tt-despesas-im001.cod-pto-contr = desp-cot-ordem.cod-pto-contr
                    i-seq-desp = i-seq-desp + 1.

    end.
    release cot-ordem.

    assign i-seq-desp = 0.

end.
else do:
    find cot-ordem
        where rowid(cot-ordem) = p-rowid NO-LOCK NO-ERROR.

    find ordem-compra
        where ordem-compra.numero-ordem = cot-ordem.numero-ordem
        no-lock no-error.

    for each tt-cotacao-im001:
        delete tt-cotacao-im001.
    end.    

    create tt-cotacao-im001.
    assign tt-cotacao-im001.cod-versao-integracao = 2
           tt-cotacao-im001.it-codigo    = ordem-compra.it-codigo
           tt-cotacao-im001.cod-itiner   = cot-ordem.cod-itiner
           tt-cotacao-im001.cod-incoterm = cot-ordem.cod-incoterm
           tt-cotacao-im001.cod-emitente = cot-ordem.cod-emitente
           &if '{&bf_mat_versao_ems}':U >= '2.062':U &then
           tt-cotacao-im001.numero-ordem = cot-ordem.numero-ordem
           &endif
           .

    run imp/imapi001.p (input table tt-cotacao-im001,
                        output table tt-despesas-im001,
                        output table tt-erro-im001).    /* Despesas Pre-Cadastradas (Itiner, Item) */

    FIND FIRST tt-despesas-im001 NO-ERROR.
end.

find first tt-erro-im001 no-error.
if avail tt-erro-im001 then do:
    assign i-seq-erro = i-seq-erro + 1.
    create tt-bo-erro.
    assign tt-bo-erro.i-sequen   = i-seq-erro
           tt-bo-erro.cd-erro    = tt-erro-im001.cd-erro
           tt-bo-erro.mensagem   = tt-erro-im001.mensagem
           tt-bo-erro.parametros = tt-erro-im001.parametros.
end.
else do:
    assign i-seq-desp = 0.
    if c-action = "Copy" then do:
        find cot-ordem
            where rowid(cot-ordem) = p-rowid NO-LOCK NO-ERROR.

        find ordem-compra
            where ordem-compra.numero-ordem = cot-ordem.numero-ordem
            no-lock no-error.
    end. 

    find cotacao-item
        where cotacao-item.it-codigo    = ordem-compra.it-codigo
          and cotacao-item.cod-emitente = cot-ordem.cod-emitente
          and cotacao-item.data-cotacao = cot-ordem.data-1
          and cotacao-item.numero-ordem = cot-ordem.numero-ordem
        &if defined(bf-mat-comex) &then
        &else
          and cotacao-item.seq-cotac    = cot-ordem.seq-cotac
        &endif
          NO-LOCK NO-ERROR.
    for each tt-despesas-im001
        BY tt-despesas-im001.seq:

        create tt-desp-cot-ordem.
        assign tt-desp-cot-ordem.cod-agrup     = cot-ordem.cod-agrup
               tt-desp-cot-ordem.mapa-ordem    = cot-ordem.mapa-ordem
               tt-desp-cot-ordem.cod-desp      = tt-despesas-im001.cod-desp
               tt-desp-cot-ordem.cod-pto-contr = tt-despesas-im001.cod-pto-contr
               tt-desp-cot-ordem.taxa-financ   = yes
               tt-desp-cot-ordem.contato       = cotacao-item.contato
               tt-desp-cot-ordem.cod-comprado  = cotacao-item.cod-comprado
               tt-desp-cot-ordem.sequencia     = tt-despesas-im001.seq.
                     
             /* Grava‡Æo do tipo de despesa */
             &IF "{&BF_MAT_VERSAO_EMS}" >= "2.05" &THEN
                 for first desp-imp fields(cod-desp tp-despesa) 
                     where desp-imp.cod-desp = tt-desp-cot-ordem.cod-desp no-lock:
                 end.
                 if desp-imp.tp-despesa <> 0 then
                    assign tt-desp-cot-ordem.tp-despesa = desp-imp.tp-despesa.
                 else do:
                    for first emitente fields(tp-desp-padrao) no-lock
                              where emitente.cod-emitente = RowObject.cod-emitente:
                    end.
                    if avail emitente then
                        assign tt-desp-cot-ordem.tp-despesa = emitente.tp-desp-padrao.
                 end.
             &ENDIF
             /* Fim da grama‡Æo por tipo de despesa */

    end.

    run cxbo/bocx305.p persistent set h-bocx305.
    run setValidate in h-bocx305 (input yes).

    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
        RUN setDespesas IN h-bocx305(INPUT TABLE tt-despesas-im001).
    &endif.
    
    for each tt-desp-cot-ordem
        BY tt-desp-cot-ordem.sequencia:
        
        create tt-desp-cot-ordem-aux.
        buffer-copy tt-desp-cot-ordem to tt-desp-cot-ordem-aux.
        
        run validateCreate in h-bocx305(input table tt-desp-cot-ordem-aux,
                                        output table tt-bo-erro,
                                        output tt-desp-cot-ordem-aux.r-rowid).
        
        delete tt-desp-cot-ordem-aux.
    end.

    delete procedure h-bocx305.
    
    for each tt-despesas-im001:
        delete tt-despesas-im001.
    end.
end.

end procedure.

procedure getCharField:
    define input parameter c-field as char.
    define output parameter c-value as char.

    case c-field:
        when "cod-agrup" then c-value = RowObject.cod-agrup.
        when "cod-incoterm" then c-value = RowObject.cod-incoterm.
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        otherwise return error.
    end case.
end procedure.

procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.

    case c-field:        
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        otherwise return error.
    end case.
end procedure.

procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.

    case c-field:
        when "numero-ordem" then c-value = RowObject.numero-ordem.
        when "cod-emitente" then c-value = RowObject.cod-emitente.
        when "seq-cotac" then c-value = RowObject.seq-cotac.
        when "cod-itiner" then c-value = RowObject.cod-itiner.
        when "mapa-ordem" then c-value = RowObject.mapa-ordem.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        otherwise return error.
    end case.
end procedure.

procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.

    case c-field:
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.        
        otherwise return error.
    end case.
end procedure.

procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.

    case c-field:
        when "mapa-aprovado" then c-value = RowObject.mapa-aprovado.
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.        
        otherwise return error.
    end case.
end procedure.

