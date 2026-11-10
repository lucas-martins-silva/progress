/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX145 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX145 MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX145.P
**
**  ordens-processo - Ordens Compra Processo 
**
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY ordens-processo
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME ordens-processo

{cdp/cdcfgmat.i} /* Defini‡Æo pr‚-processadores */

{include/boini.i}
{cxbo/bocx145.i RowObject}
{inbo/boin274.i tt-ordem-compra}
{inbo/boin295.i tt-pedido-compr}

define temp-table tt-rowid-processo NO-UNDO
    field r-rowid   as rowid.
    
define temp-table tt-rowid-pedido NO-UNDO
    field r-rowid   as rowid.

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

def var c-nr-proc-imp  as char    no-undo. 
def var i-numero-ordem as integer no-undo. 

procedure setConstraint1:
end procedure. 

procedure setConstraint2:
    def input parameter p-cod as char no-undo.

    assign i-numero-ordem = int(p-cod).
end procedure.

procedure setConstraint3:
    def input parameter r-rowid as rowid no-undo.

    assign rowObject.r-rowid  = r-rowid.
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.    
    end case.
    assign l-query    = true
           i-bo-query = i-abertura.
end procedure.
 
{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
{include/bonav.i}
{include/bofind.i}
{include/bosetcur.i}
{include/bogetcur.i}
{include/bosersen.i}
{include/boprebro.i}
{include/boexecre.i}
/* {include/boexeupt.i} */
{include/boexedel.i}
{include/bovalupt.i}
{include/bovaldel.i}

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
     
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.


procedure findCodigo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter i-numero-ordem as integer no-undo.
    def input parameter c-nr-proc-imp  as char    no-undo.
    def output parameter c-return as char no-undo.

    run startMethod("find":U).
 
    find ordens-processo where
         ordens-processo.numero-ordem = i-numero-ordem and
         ordens-processo.nr-proc-imp  = c-nr-proc-imp
         no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgcex ordens-processo 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.                           
    end.
    else do:
       run setCurrent.
    end.
    run endMethod("find":U).    
end procedure.

procedure findOrdemCompra:
/*
**  Procura pela condicao, caso nao ache,
**  retorna mensagem de erro padrao do EMS.
*/
    def input parameter i-cod-exp as integer no-undo.
    def output parameter table for tt-ordem-compra.
    
    for each  ordem-compra 
        where ordem-compra.cod-emitente = i-cod-exp and
        &if defined(bf-mat-comex) &then
            ordem-compra.situacao      = "C"  
        &else
            int(ordem-compra.situacao) = 2 
        &endif no-lock:
        find ordens-processo where ordens-processo.numero-ordem = ordem-compra.numero-ordem no-lock no-error.  
        if   not avail ordens-processo then do:    
             create tt-ordem-compra.
             buffer-copy ordem-compra to tt-ordem-compra.
             assign tt-ordem-compra.r-rowid = rowid(ordem-compra).
        end.
    end.  
end procedure.

procedure findProcesso:
    def input  parameter c-nr-proc-imp like processo-imp.nr-proc-imp no-undo.
    def output parameter c-return      as char                       no-undo.

    find first ordens-processo
        where ordens-processo.nr-proc-imp  = c-nr-proc-imp
          no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgcex ordens-processo 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else do:
       run setCurrent.
    end.
end procedure.

procedure findOrdemPedido:
/*
**  Procura pela condicao, caso nao ache,
**  retorna mensagem de erro padrao do EMS.
*/
    def input parameter i-cod-exp1 as integer no-undo.
    def output parameter table for tt-pedido-compr.
    
    &if defined(bf_mat_contratos) &then
        for each pedido-compr where pedido-compr.cod-emitente = i-cod-exp1 
            and  pedido-compr.nr-contrato = 0 no-lock:        
    &else
        for each pedido-compr where pedido-compr.cod-emitente = i-cod-exp1 
            and  pedido-compr.nr-contrato = "" no-lock:    
    &endif
            find first ordem-compra where 
                       ordem-compra.num-pedido = pedido-compr.num-pedido and
                       &if defined(bf-mat-comex) &then
                           ordem-compra.situacao <> "C"
                       &else
                           int(ordem-compra.situacao) <> 2  
                       &endif no-lock no-error.
                       
            if not avail ordem-compra then do:
               find ordens-processo where ordens-processo.numero-ordem = ordem-compra.numero-ordem no-lock no-error.
               if  not avail ordens-processo then do:
                   create tt-pedido-compr.       
                   buffer-copy pedido-compr to tt-pedido-compr.
                   assign tt-pedido-compr.r-rowid = rowid(pedido-compr).     
               end.    
           end.
        end.
end procedure.

procedure executeUpdate:
    /*
    **  Executa Update
    */
    buffer-copy RowObject except r-rowid numero-ordem nr-proc-imp to {&TABLE-NAME}.

end procedure.

procedure createOrdensProcesso1:
    def input parameter r-chave as rowid.
    def input parameter table for tt-rowid-processo.
    
    find first processo-imp where rowid(processo-imp) = r-chave no-lock no-error.
    if avail processo-imp then do:
       for each tt-rowid-processo no-lock:
           find ordem-compra where rowid(ordem-compra) = tt-rowid-processo.r-rowid  
                no-lock no-error.
           if avail ordem-compra then do:
              create ordens-processo.
              assign ordens-processo.nr-proc-imp = processo-imp.nr-proc-imp
                     ordens-processo.numero-ordem = ordem-compra.numero-ordem.
          end.         
       end.
    end.
end procedure.

procedure createOrdensProcesso2:
    def input parameter r-chave as rowid.
    def input parameter table for tt-rowid-pedido.
    
    find first processo-imp where rowid(processo-imp) = r-chave no-lock no-error.
    if avail processo-imp then do:
        for each tt-rowid-pedido no-lock:
            find pedido-compr where rowid(pedido-compr) = tt-rowid-pedido.r-rowid 
                no-lock no-error.
            if avail pedido-compr then do:
                for each ordem-compra where ordem-compra.num-pedido = pedido-compr.num-pedido no-lock:
                    create ordens-processo.
                    assign ordens-processo.nr-proc-imp = processo-imp.nr-proc-imp
                           ordens-processo.numero-ordem = ordem-compra.numero-ordem.
                end.           
            end.         
        end.
    end.  
end procedure.

procedure validateFields:
/*
** Valida campos
*/
    run startMethod("validateFields":U).
    
    find first rowObject no-error.
    run endMethod("validateFields":U).
end procedure.

procedure validateCreate:
    /*
    **  Valida cria‡Æo da tabela/duplicidade de registro.
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
    
    run startMethod("validateCreate":U).    
 
    run initializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    find first rowObject no-error.
    
    if rowObject.nr-proc-imp = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} nr-proc-imp 1}
        run utp/ut-msgs.p (input "msg",
                           input 7965,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 7965
               tt-bo-erro.mensagem     = return-value.
    end.
    else
        if not can-find(processo-imp where processo-imp.nr-proc-imp = rowObject.nr-proc-imp) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex processo-imp 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
        end.           
    
    if rowObject.numero-ordem = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex ordens-processo numero-ordem 1}
        run utp/ut-msgs.p (input "msg",
                           input 7965,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 7965
               tt-bo-erro.mensagem     = return-value.
    end.
    else
        if not can-find(ordem-compra where ordem-compra.numero-ordem = rowObject.numero-ordem) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex ordens-processo numero-ordem 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
        end.           
    
    run validateFields.
    
    find first tt-bo-erro no-lock no-error.
    if not available tt-bo-erro then do:
        find ordens-processo where ordens-processo.nr-proc-imp = rowObject.nr-proc-imp
            no-lock no-error.
        if avail ordens-processo then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex {&TABLE-NAME} 1}
            run utp/ut-msgs.p (input "msg",
                               input 8,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = return-value.
        end.
    end.
    
    find first tt-bo-erro no-lock no-error. 
    if not avail tt-bo-erro then do:
       run executeCreate.
       assign r-chave = to-rowid(return-value).
    end.
    run endMethod("validateCreate":U). 
end procedure.

procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "cod-estabel" then c-value = RowObject.cod-estabel.
        when "nr-proc-imp" then c-value = RowObject.nr-proc-imp.
        when "identific-container" then c-value = RowObject.identific-container.
        when "caracter-container" then c-value = RowObject.caracter-container.
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
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.        
        otherwise return error.
    end case.
end procedure.
