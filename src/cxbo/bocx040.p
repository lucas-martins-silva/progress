/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX040 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX040 MUT}
&ENDIF

/*
**  BOCX040.P
**
**  mod-transac - Cadastro de Modalidades de Transa‡Æo
**
**  Ultima altera‡Æo : 05/05/99 - GeraBO - Brv9587
*/
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY mod-transac
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME mod-transac
 
 
 
{include/boini.i}
 
{cxbo/bocx040.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

def var i-transac as integer no-undo.
def var i-transac-ini as integer no-undo.
def var i-transac-fin as integer no-undo.

procedure setConstraint1:
 
 
end procedure.

procedure setConstraint2:
 def input parameter p-chave as char no-undo.
 
 assign i-transac = integer(p-chave).
end procedure. 
 
procedure setConstraint3:
 def input parameter p-chave-ini as char no-undo.
 def input parameter p-chave-fin as char no-undo.
 
 assign i-transac-ini = integer(p-chave-ini)
        i-transac-fin = integer(p-chave-fin).
end procedure. 
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock. 
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.cod-transac >= i-transac no-lock by mod-transac.cod-transac.
        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.cod-transac >= i-transac-ini and ~
                                                                  {&TABLE-NAME}.cod-transac <= i-transac-fin no-lock by mod-transac.cod-transac.            

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
/*{include/boexeupt.i}*/
{include/boexedel.i}
{include/bovalupt.i}
{include/bovaldel.i}

procedure executeUpdate:
    /*
    **  Executa Update
    */
    buffer-copy RowObject except cod-transac r-rowid to {&TABLE-NAME}.
end procedure.

 
procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.
 
procedure findPk_cod_transac:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter i-cod-transac as inte no-undo.
    def output parameter c-return as char no-undo.
 
    find mod-transac where
        mod-transac.cod-transac = i-cod-transac
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
    run endMethod ("find").
end procedure.
 
procedure validateFields:
    /*
    **  Valida Fields
    */
    find first rowObject
        no-lock no-error.
 
    run startMethod ("validateFields").
    if rowObject.cod-transac = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.descricao = ? or rowObject.descricao = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
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
 
    find first rowObject
        no-lock no-error.
    if rowObject.cod-transac = ? or
       rowObject.cod-transac = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-transac 1}
        create tt-bo-erro.
        ASSIGN tt-bo-erro.parametros = RETURN-VALUE.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.descricao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} descricao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find mod-transac where
            mod-transac.cod-transac = rowObject.cod-transac
            no-lock no-error.
        if avail mod-transac then do:
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
 
    run validateFields.
    
     /** Verifica duplicidade dos registros **/
    if can-find(first mod-transac where
                      mod-transac.cod-transac = rowObject.cod-transac) then do:
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

    find first tt-bo-erro
        no-lock no-error.
 
    if not avail tt-bo-erro then do:
       run executeCreate.
       assign r-chave = to-rowid(return-value).
    end.
 
    run endMethod ("validateCreate").
end procedure.

procedure validateCodigo:
    def input-output parameter c-cod-transac as char no-undo.
    def output parameter table for tt-bo-erro.
    def var i as integer no-undo.
    
    run startMethod ("validateCodigo").
    assign i = int(c-cod-transac) no-error.
    if  error-status:error then do:       
       assign i-seq-erro = i-seq-erro + 1
              c-cod-transac = "0".
       {utp/ut-field.i mgcex mod-transac cod-transac 1}
       run utp/ut-msgs.p (input "msg",
                          input 16963,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 16963
              tt-bo-erro.mensagem     = return-value.
    end.           
    run endMethod ("validateCodigo").          
end procedure.
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        when "descricao" then c-value = RowObject.descricao.
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
        when "cod-transac" then c-value = RowObject.cod-transac.
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
 
