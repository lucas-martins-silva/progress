/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX235 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX235 MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX235.P
**
**  cond-especif-cex - Condicao Especifica Comercio Exterior
**
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY cond-especif-cex
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME cond-especif-cex

{include/boini.i}
{cxbo/bocx235.i RowObject}

{cdp/cdcfgmat.i} /* defini‡Æo pr‚-processador Magnus */

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

procedure setConstraint1:
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

procedure findPedido:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter p-num-pedido as integer no-undo.
    def input parameter p-cod-emitente-desp as integer no-undo.
    def input parameter p-cod-desp as integer no-undo.
    def output parameter c-return as char no-undo.
    
    run startMethod("find":U). 
    find cond-especif-cex where
        cond-especif-cex.num-pedido        = p-num-pedido and
        cond-especif-cex.cod-emitente-desp = p-cod-emitente-desp and
        cond-especif-cex.cod-desp          = p-cod-desp         
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
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

procedure findEmitente-desp:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter p-cod-emitente-desp as integer no-undo.
    def input parameter p-cod-desp as integer no-undo.
    def output parameter c-return as char no-undo.
    
    run startMethod("find":U). 
    find first cond-especif-cex where
        cond-especif-cex.cod-emitente-desp = p-cod-emitente-desp and
        cond-especif-cex.cod-desp          = p-cod-desp         
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
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

procedure findContrato:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter p-nr-contrato as char no-undo.
    def input parameter p-cod-emitente-desp as integer no-undo.
    def input parameter p-cod-desp as integer no-undo.
    def output parameter c-return as char no-undo.
    
    run startMethod("find":U). 
    find first cond-especif-cex where
        cond-especif-cex.nr-contrato       = p-nr-contrato and
        cond-especif-cex.cod-emitente-desp = p-cod-emitente-desp and
        cond-especif-cex.cod-desp          = p-cod-desp         
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
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

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
     
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.

procedure executeUpdate:
    /*
    **  Executa Update
    */
      
    buffer-copy RowObject except num-pedido cod-emitente-desp cod-desp r-rowid to {&TABLE-NAME}.

end procedure.
 
procedure validateFields:
/*
** Validacoes Campos
*/
    def var i-cont as integer init 1 no-undo.
    def var da-data-pagto as date no-undo.
    def var de-perc-pagto as decimal no-undo.
    
    find first rowObject no-lock no-error. 
    run startMethod ("validateFields").
    do while i-cont <= 12:  
        assign da-data-pagto = rowObject.data-pagto[i-cont]
               de-perc-pagto = rowObject.perc-pagto[i-cont].
        if da-data-pagto <> ? then
        if de-perc-pagto = 0 then do:
              assign i-seq-erro = i-seq-erro + 1.
              {utp/ut-field.i mgcex {&TABLE-NAME} perc-pagto 1}
              run utp/ut-msgs.p (input "msg",
                                 input 265,
                                 input return-value).
              create tt-bo-erro.
              assign tt-bo-erro.i-sequen     = i-seq-erro
                     tt-bo-erro.cd-erro      = 265
                     tt-bo-erro.mensagem     = return-value.  
        end.
        assign i-cont = i-cont + 1.
    end.    
    run endMethod ("validateFields"). 
end procedure.

procedure validateCreate:
/*
**  Valida cria‡Æo da tabela/duplicidade de registro.
*/
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
    
    def var i-auto-num as integer no-undo.
    
    run startMethod("validateCreate").
 
    run initializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    find first rowObject no-error.            
        
    if rowObject.num-pedido = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} num-pedido 1}
        run utp/ut-msgs.p (input "msg",
                           input 7965,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 7965
               tt-bo-erro.mensagem     = return-value.
    end.      
    else 
        if not can-find(pedido-compr where pedido-compr.num-pedido = rowObject.num-pedido) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i movind pedido-compr 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
        end.
    
    if rowObject.cod-emitente-desp = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-emitente-desp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else do:
        find emitente where emitente.cod-emitente = rowObject.cod-emitente-desp no-lock no-error.
        if not avail emitente then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgadm emitente 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
        end.         
        else do:
            {cdp/cd2502.i}
        end.
    end.       

    if rowObject.cod-desp = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-desp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else 
        if not can-find(desp-imp where desp-imp.cod-desp = rowObject.cod-desp ) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex desp-imp 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
        end.
         
    run validateFields.             
    
    if can-find(first {&TABLE-NAME} where
                      {&TABLE-NAME}.num-pedido         = rowObject.num-pedido and
                      {&TABLE-NAME}.cod-emitente-desp  = rowObject.cod-emitente-desp and
                      {&TABLE-NAME}.cod-desp           = rowObject.cod-desp) then do:
       assign i-seq-erro = i-seq-erro + 1.
       {utp/ut-table.i mgcex cond-especif-cex 1}
       run utp/ut-msgs.p (input "msg",
                          input 8,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 8
              tt-bo-erro.mensagem     = return-value.
    end.            
    find first tt-bo-erro
        no-lock no-error.
    if not avail tt-bo-erro then do:
         run executeCreate.
         assign r-chave = to-rowid(return-value).
    end.  
    run endMethod("validateCreate").
end procedure.

procedure getCharField:
    define input parameter c-field as char.
    define output parameter c-value as char.
	
    case c-field:
        when "nr-contrato" then c-value = RowObject.nr-contrato.
        when "comentarios[1]" then c-value = RowObject.comentarios[1].
        when "comentarios[2]" then c-value = RowObject.comentarios[2].
        when "comentarios[3]" then c-value = RowObject.comentarios[3].
        when "comentarios[4]" then c-value = RowObject.comentarios[4].
        when "comentarios[5]" then c-value = RowObject.comentarios[5].
        when "comentarios[6]" then c-value = RowObject.comentarios[6].
        when "comentarios[7]" then c-value = RowObject.comentarios[7].
        when "comentarios[8]" then c-value = RowObject.comentarios[8].
        when "comentarios[9]" then c-value = RowObject.comentarios[9].
        when "comentarios[10]" then c-value = RowObject.comentarios[10].
        when "comentarios[11]" then c-value = RowObject.comentarios[11].
        when "comentarios[12]" then c-value = RowObject.comentarios[12].                
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
        when "num-pedido" then c-value = RowObject.num-pedido.
        when "cod-emitente-desp" then c-value = RowObject.cod-emitente-desp.
        when "cod-desp" then c-value = RowObject.cod-desp.
        when "perc-pagto[1]" then c-value = RowObject.perc-pagto[1].
        when "perc-pagto[2]" then c-value = RowObject.perc-pagto[2].
        when "perc-pagto[3]" then c-value = RowObject.perc-pagto[3].
        when "perc-pagto[4]" then c-value = RowObject.perc-pagto[4].
        when "perc-pagto[5]" then c-value = RowObject.perc-pagto[5].
        when "perc-pagto[6]" then c-value = RowObject.perc-pagto[6].
        when "perc-pagto[7]" then c-value = RowObject.perc-pagto[7].
        when "perc-pagto[8]" then c-value = RowObject.perc-pagto[8].
        when "perc-pagto[9]" then c-value = RowObject.perc-pagto[9].
        when "perc-pagto[10]" then c-value = RowObject.perc-pagto[10].
        when "perc-pagto[11]" then c-value = RowObject.perc-pagto[11].
        when "perc-pagto[12]" then c-value = RowObject.perc-pagto[12].        
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.        
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-pagto[1]" then c-value = RowObject.data-pagto[1].
        when "data-pagto[2]" then c-value = RowObject.data-pagto[2].
        when "data-pagto[3]" then c-value = RowObject.data-pagto[3].
        when "data-pagto[4]" then c-value = RowObject.data-pagto[4].
        when "data-pagto[5]" then c-value = RowObject.data-pagto[5].
        when "data-pagto[6]" then c-value = RowObject.data-pagto[6].
        when "data-pagto[7]" then c-value = RowObject.data-pagto[7].
        when "data-pagto[8]" then c-value = RowObject.data-pagto[8].
        when "data-pagto[9]" then c-value = RowObject.data-pagto[9].
        when "data-pagto[10]" then c-value = RowObject.data-pagto[10].
        when "data-pagto[11]" then c-value = RowObject.data-pagto[11].
        when "data-pagto[12]" then c-value = RowObject.data-pagto[12].        
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
