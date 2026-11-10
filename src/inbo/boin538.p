/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN538 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN538 MUT}
&ENDIF

/*
**  BOIN538.P
**
**  rep-refugo-oper - Reporte Refugo Opera‡Æo
**
**  Ultima altera‡Æo : 28/07/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY rep-refugo-oper
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME rep-refugo-oper
 
 
 
{include/boini.i}
 
{inbo/boin538.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
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
 
procedure findId:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter i-nr-ord-produ as inte no-undo.
    def input parameter i-num-seq-rep as inte no-undo.
    def input parameter c-cod-motiv-refugo as char no-undo.
    def output parameter c-return as char no-undo.
 
    find rep-refugo-oper where
        rep-refugo-oper.nr-ord-produ = i-nr-ord-produ
        and rep-refugo-oper.num-seq-rep = i-num-seq-rep
        and rep-refugo-oper.cod-motiv-refugo = c-cod-motiv-refugo
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i movind {&TABLE-NAME} 1}
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
 
procedure validateFields:
    /*
    **  Valida Fields
    */
    find first rowObject
        no-lock no-error.
 
    run startMethod ("validateFields").
    if rowObject.cod-motiv-refugo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-motiv-refugo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-usuar-reporte = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-usuar-reporte 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dat-reporte = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} dat-reporte 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.hra-reporte = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} hra-reporte 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-ord-produ = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} nr-ord-produ 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.num-seq-rep = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} num-seq-rep 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-operac-refgda = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-operac-refgda 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-operac-retrab = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-operac-retrab 1}
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
        find rep-refugo-oper where
            rep-refugo-oper.nr-ord-produ = rowObject.nr-ord-produ
        and rep-refugo-oper.num-seq-rep = rowObject.num-seq-rep
        and rep-refugo-oper.cod-motiv-refugo = rowObject.cod-motiv-refugo
            no-lock no-error.
        if avail rep-refugo-oper then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i movind {&TABLE-NAME} 1}
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
        when "cod-motiv-refugo" then c-value = RowObject.cod-motiv-refugo.
        when "cod-usuar-reporte" then c-value = RowObject.cod-usuar-reporte.
        when "des-anot-tab" then c-value = RowObject.des-anot-tab.
        when "hra-reporte" then c-value = RowObject.hra-reporte.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "qtd-operac-refgda" then c-value = RowObject.qtd-operac-refgda.
        when "qtd-operac-retrab" then c-value = RowObject.qtd-operac-retrab.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "nr-ord-produ" then c-value = RowObject.nr-ord-produ.
        when "num-seq-rep" then c-value = RowObject.num-seq-rep.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "dat-reporte" then c-value = RowObject.dat-reporte.
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
 
