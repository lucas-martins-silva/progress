/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN480 2.00.00.024 } /*** "010024" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin480 MUT}
&ENDIF

/*
**  BOIN480.P
** 
**  lista-compon-item - 
**
**  Ultima altera‡Æo : 24/06/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY lista-compon-item
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME lista-compon-item
 
{cdp/cdcfgman.i} 
 
{method/dbotterr.i}
{include/boini.i}
 
{inbo/boin111.i tt-estrutura}
{inbo/boin480.i RowObject}

/*Temp table tt-epc*/
{include/i-epc200.i BOIN480}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
define variable h-boin111 AS HANDLE NO-UNDO.


procedure setConstraint1:
 
end procedure.
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
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
{include/boexeupt.i}
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
 
procedure findLista:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-cod-lista-compon as char no-undo.
    def input parameter c-it-codigo as char no-undo.
    def output parameter c-return as char no-undo.
 
    find lista-compon-item where
        lista-compon-item.cod-lista-compon = c-cod-lista-compon
        and lista-compon-item.it-codigo = c-it-codigo
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgind {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else do:
       run setCurrent.
    end.
    run endMethod ("find").
end procedure.

procedure findFirstLista:

    run startMethod ("find").
    
    def input parameter c-it-codigo as char no-undo.
    def output parameter c-return as char no-undo.
 
    find first lista-compon-item use-index lista where
               lista-compon-item.it-codigo = c-it-codigo   no-lock no-error.
    if not avail lista-compon-item then 
        assign c-return = "NOK":U.
    else do:
       assign c-return = "OK":U.
       run setCurrent.
    end.
    run endMethod ("find").
end procedure.

 
procedure validateFields:
    /*
    **  Valida Fields
    */
    find first rowObject
        no-lock no-error.
 
    run startMethod ("validateFields").
    if rowObject.cod-lista-compon = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} cod-lista-compon 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.data-inicio = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} data-inicio 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.data-termino = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} data-termino 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.it-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} it-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
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
 
    run initializeValidate.
    run startMethod ("validateCreate").
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    run validateFields.
 
    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find lista-compon-item where
            lista-compon-item.cod-lista-compon = rowObject.cod-lista-compon
        and lista-compon-item.it-codigo = rowObject.it-codigo
            no-lock no-error.
        if avail lista-compon-item then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgind {&TABLE-NAME} 1}
            run utp/ut-msgs.p (input "msg",
                               input 8,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = return-value.
        end.
        else do:
             run executeCreate.
             assign r-chave = to-rowid(return-value).
        end.
    end.
 
    run endMethod ("validateCreate").
    
end procedure.
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        when "cod-lista-compon" then c-value = RowObject.cod-lista-compon.
        when "cod-roteiro" then c-value = RowObject.cod-roteiro.
        when "it-codigo" then c-value = RowObject.it-codigo.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "proporcao" then c-value = RowObject.proporcao.
        when "qtd-item" then c-value = RowObject.qtd-item.
        when "qtd-lista" then c-value = RowObject.qtd-lista.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "op-codigo" then c-value = RowObject.op-codigo.
        when "sequencia" then c-value = RowObject.sequencia.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.
        when "data-inicio" then c-value = RowObject.data-inicio.
        when "data-termino" then c-value = RowObject.data-termino.
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


{inbo/boin480.i1}
