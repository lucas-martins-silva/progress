/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN649A 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN649A MUT}
&ENDIF

/*
**  BOIN649.P
**
**  it-pedido-imp - 
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY it-pedido-imp
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME it-pedido-imp
 
 
 define temp-table tt-imposto-pedido no-undo
    field cod-imposto   like it-pedido-imp.cod-taxa
    field descricao     like tipo-tax.descricao
    field aliquota      like it-pedido-imp.aliquota
    field valor-imposto like it-pedido-imp.vl-imposto
    field r-rowid       as rowid.
{include/boini.i}
 
 
{inbo/boin649a.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
procedure setConstraint1:
 def input parameter r-chave as rowid.
	find ped-venda no-lock where rowid(ped-venda) = r-chave no-error.

end procedure.

procedure carregaTempTable:


for each tt-imposto-pedido:
    delete tt-imposto-pedido.
end.

for each it-pedido-imp of ped-venda
    break by it-pedido-imp.cod-taxa:
    
    find first tt-imposto-pedido where 
               tt-imposto-pedido.cod-imposto = it-pedido-imp.cod-taxa no-error.
    if not avail tt-imposto-pedido then do:
    
        find tipo-tax where
             tipo-tax.cod-tax = it-pedido-imp.cod-taxa no-lock no-error.
        
        create tt-imposto-pedido.
        assign tt-imposto-pedido.cod-imposto   = it-pedido-imp.cod-taxa
               tt-imposto-pedido.descricao     = tipo-tax.descricao
               tt-imposto-pedido.aliquota      = it-pedido-imp.aliquota
               tt-imposto-pedido.valor-imposto = it-pedido-imp.vl-imposto
               tt-imposto-pedido.r-rowid       = rowid(it-pedido-imp).
    end.
    else
        assign tt-imposto-pedido.valor-imposto = tt-imposto-pedido.valor-imposto + it-pedido-imp.vl-imposto.
end.


END PROCEDURE.



 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
    end case.
    assign l-query = true
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
 
procedure findCh_imposto:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-nome-abrev as char no-undo.
    def input parameter c-nr-pedcli as char no-undo.
    def input parameter i-nr-sequencia as inte no-undo.
    def input parameter c-it-codigo as char no-undo.
    def input parameter c-cod-refer as char no-undo.
    def input parameter i-nr-seq-imp as inte no-undo.
    def output parameter c-return as char no-undo.
 
    find it-pedido-imp where
        it-pedido-imp.nome-abrev = c-nome-abrev
        and it-pedido-imp.nr-pedcli = c-nr-pedcli
        and it-pedido-imp.nr-sequencia = i-nr-sequencia
        and it-pedido-imp.it-codigo = c-it-codigo
        and it-pedido-imp.cod-refer = c-cod-refer
        and it-pedido-imp.nr-seq-imp = i-nr-seq-imp
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
 
/*procedure validateFields:
    /*
    **  Valida Fields
    */
    find first rowObject
        no-lock no-error.
 
    run startMethod ("validateFields").
    if rowObject.cod-refer = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.it-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nome-abrev = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-pedcli = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-seq-imp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-sequencia = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-imposto = ? then do:
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
    if rowObject.cod-refer = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} cod-refer 1}
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
 
    if rowObject.nome-abrev = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} nome-abrev 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-pedcli = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} nr-pedcli 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-seq-imp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} nr-seq-imp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-sequencia = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} nr-sequencia 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-imposto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} vl-imposto 1}
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
        find it-pedido-imp where
            it-pedido-imp.nome-abrev = rowObject.nome-abrev
        and it-pedido-imp.nr-pedcli = rowObject.nr-pedcli
        and it-pedido-imp.nr-sequencia = rowObject.nr-sequencia
        and it-pedido-imp.it-codigo = rowObject.it-codigo
        and it-pedido-imp.cod-refer = rowObject.cod-refer
        and it-pedido-imp.nr-seq-imp = rowObject.nr-seq-imp
            no-lock no-error.
        if avail it-pedido-imp then do:
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
    end.
 
    run validateFields.
    find first tt-bo-erro
        no-lock no-error.
 
    if not avail tt-bo-erro then do:
       run executeCreate.
       assign r-chave = to-rowid(return-value).
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
        when "cod-refer" then c-value = RowObject.cod-refer.
        when "conta-percepcao" then c-value = RowObject.conta-percepcao.
        when "conta-retencao" then c-value = RowObject.conta-retencao.
        when "conta-tax" then c-value = RowObject.conta-tax.
        when "it-codigo" then c-value = RowObject.it-codigo.
        when "nome-abrev" then c-value = RowObject.nome-abrev.
        when "nr-pedcli" then c-value = RowObject.nr-pedcli.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "aliquota" then c-value = RowObject.aliquota.
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "perc-percepcao" then c-value = RowObject.perc-percepcao.
        when "perc-redimp" then c-value = RowObject.perc-redimp.
        when "perc-retencao" then c-value = RowObject.perc-retencao.
        when "vl-base-imp" then c-value = RowObject.vl-base-imp.
        when "vl-base-me" then c-value = RowObject.vl-base-me.
        when "vl-imposto" then c-value = RowObject.vl-imposto.
        when "vl-imposto-me" then c-value = RowObject.vl-imposto-me.
        when "vl-percepcao" then c-value = RowObject.vl-percepcao.
        when "vl-percepcao-me" then c-value = RowObject.vl-percepcao-me.
        when "vl-retencao" then c-value = RowObject.vl-retencao.
        when "vl-retencao-me" then c-value = RowObject.vl-retencao-me.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "cod-taxa" then c-value = RowObject.cod-taxa.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "nr-seq-imp" then c-value = RowObject.nr-seq-imp.
        when "nr-sequencia" then c-value = RowObject.nr-sequencia.
        when "tipo-tax" then c-value = RowObject.tipo-tax.
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
 
*/
