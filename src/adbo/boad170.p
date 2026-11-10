/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD170 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad170 MUT}
&ENDIF

/*
**  BOAD170.P
**
**  lin-i-ap - Implantacoes do Contas a Pagar
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY lin-i-ap
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME lin-i-ap
 
{include/boini.i}
 
 
{adbo/boad170.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
procedure setConstraint1:
 
end procedure.
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
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
 
procedure findCodigo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input parameter i-ep-codigo LIKE empresa.ep-codigo no-undo.
&ELSE
    def input parameter i-ep-codigo as inte no-undo.
&ENDIF
    def input parameter c-referencia as char no-undo.
    def input parameter i-sequencia as inte no-undo.
    def input parameter i-seq-import as inte no-undo.
    def output parameter c-return as char no-undo.
 
    find lin-i-ap where
        lin-i-ap.ep-codigo = i-ep-codigo
        and lin-i-ap.referencia = c-referencia
        and lin-i-ap.sequencia = i-sequencia
        and lin-i-ap.seq-import = i-seq-import
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgadm {&TABLE-NAME} 1}
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
 
procedure findDocumento:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input parameter i-ep-codigo LIKE empresa.ep-codigo no-undo.
&ELSE
    def input parameter i-ep-codigo as inte no-undo.
&ENDIF
    def input parameter c-cod-estabel as char no-undo.
    def input parameter c-cod-esp as char no-undo.
    def input parameter c-serie as char no-undo.
    def input parameter c-nr-docto as char no-undo.
    def input parameter c-parcela as char no-undo.
    def input parameter i-cod-fornec as inte no-undo.
    def output parameter c-return as char no-undo.
 
    find lin-i-ap where
        lin-i-ap.ep-codigo = i-ep-codigo
        and lin-i-ap.cod-estabel = c-cod-estabel
        and lin-i-ap.cod-esp = c-cod-esp
        and lin-i-ap.serie = c-serie
        and lin-i-ap.nr-docto = c-nr-docto
        and lin-i-ap.parcela = c-parcela
        and lin-i-ap.cod-fornec = i-cod-fornec
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgadm {&TABLE-NAME} 1}
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
    if rowObject.cod-esp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-estabel = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-fornec = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-portador = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ct-debito = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dias-atraso = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dt-emissao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dt-vencimen = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ep-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.estado = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.historico = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-docto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.observacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.origem = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.parcela = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.perc-juros = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.perc-mora = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.referencia = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.sc-debito = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.seq-import = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.sequencia = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.serie = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tp-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor-ir = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-desconto = ? then do:
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
 
    if rowObject.vl-juros = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-original = ? then do:
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
    if rowObject.cod-esp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-esp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-estabel = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-estabel 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-fornec = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-fornec 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-portador = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-portador 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ct-debito = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ct-debito 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dias-atraso = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} dias-atraso 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dt-emissao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} dt-emissao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dt-vencimen = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} dt-vencimen 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ep-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ep-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.estado = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} estado 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.historico = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} historico 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-docto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} nr-docto 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.observacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} observacao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.origem = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} origem 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.parcela = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} parcela 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.perc-juros = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} perc-juros 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.perc-mora = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} perc-mora 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.referencia = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} referencia 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.sc-debito = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} sc-debito 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.seq-import = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} seq-import 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.sequencia = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} sequencia 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.serie = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} serie 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tp-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} tp-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor-ir = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} valor-ir 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-desconto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} vl-desconto 1}
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
        {utp/ut-field.i mgadm {&TABLE-NAME} vl-imposto 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-juros = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} vl-juros 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-original = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} vl-original 1}
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
        find lin-i-ap where
            lin-i-ap.ep-codigo = rowObject.ep-codigo
        and lin-i-ap.referencia = rowObject.referencia
        and lin-i-ap.sequencia = rowObject.sequencia
        and lin-i-ap.seq-import = rowObject.seq-import
            no-lock no-error.
        if avail lin-i-ap then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgadm {&TABLE-NAME} 1}
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
        &IF "{&mguni_version}" >= "2.07A" &THEN
            when "ep-codigo" then c-value = RowObject.ep-codigo.
        &ENDIF
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        when "cod-barras" then c-value = RowObject.cod-barras.
        when "cod-controle" then c-value = RowObject.cod-controle.
        when "cod-esp" then c-value = RowObject.cod-esp.
        when "cod-estabel" then c-value = RowObject.cod-estabel.
        when "conta-debito" then c-value = RowObject.conta-debito.
        when "ct-debito" then c-value = RowObject.ct-debito.
        when "esp-vinc" then c-value = RowObject.esp-vinc.
        when "historico" then c-value = RowObject.historico.
        when "nat-operac" then c-value = RowObject.nat-operac.
        when "nr-docto" then c-value = RowObject.nr-docto.
        when "nr-docto-vinc" then c-value = RowObject.nr-docto-vinc.
        when "observacao" then c-value = RowObject.observacao.
        when "parcela" then c-value = RowObject.parcela.
        when "parcela-vinc" then c-value = RowObject.parcela-vinc.
        when "pedido" then c-value = RowObject.pedido.
        when "referencia" then c-value = RowObject.referencia.
        when "sc-debito" then c-value = RowObject.sc-debito.
        when "serie" then c-value = RowObject.serie.
        when "serie-vinc" then c-value = RowObject.serie-vinc.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "cotacao-dia" then c-value = RowObject.cotacao-dia.
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "diversos" then c-value = RowObject.diversos.
        when "diversos-me" then c-value = RowObject.diversos-me.
        when "frete" then c-value = RowObject.frete.
        when "frete-me" then c-value = RowObject.frete-me.
        when "perc-juros" then c-value = RowObject.perc-juros.
        when "perc-mora" then c-value = RowObject.perc-mora.
        when "perc-multa" then c-value = RowObject.perc-multa.
        when "saldo-isr" then c-value = RowObject.saldo-isr.
        when "valor-cmi" then c-value = RowObject.valor-cmi.
        when "valor-fasb" then c-value = RowObject.valor-fasb.
        when "valor-ir" then c-value = RowObject.valor-ir.
        when "valor-ir-me" then c-value = RowObject.valor-ir-me.
        when "valor-pres" then c-value = RowObject.valor-pres.
        when "vl-desconto" then c-value = RowObject.vl-desconto.
        when "vl-desconto-me" then c-value = RowObject.vl-desconto-me.
        when "vl-imposto" then c-value = RowObject.vl-imposto.
        when "vl-imposto-me" then c-value = RowObject.vl-imposto-me.
        when "vl-ir-antec" then c-value = RowObject.vl-ir-antec.
        when "vl-isr" then c-value = RowObject.vl-isr.
        when "vl-juros" then c-value = RowObject.vl-juros.
        when "vl-juros-me" then c-value = RowObject.vl-juros-me.
        when "vl-liquido" then c-value = RowObject.vl-liquido.
        when "vl-liquido-me" then c-value = RowObject.vl-liquido-me.
        when "vl-orig-me" then c-value = RowObject.vl-orig-me.
        when "vl-original" then c-value = RowObject.vl-original.
        when "vl-taxa" then c-value = RowObject.vl-taxa.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "cod-cond-pag" then c-value = RowObject.cod-cond-pag.
        when "cod-fornec" then c-value = RowObject.cod-fornec.
        when "cod-portador" then c-value = RowObject.cod-portador.
        when "cod-retencao" then c-value = RowObject.cod-retencao.
        when "cod-tax" then c-value = RowObject.cod-tax.
        when "dias-atraso" then c-value = RowObject.dias-atraso.
        when "docum-est" then c-value = RowObject.docum-est.
        &IF "{&mguni_version}" < "2.07A" &THEN
            when "ep-codigo" then c-value = RowObject.ep-codigo.
        &ENDIF
        when "estado" then c-value = RowObject.estado.
        when "fornec-vinc" then c-value = RowObject.fornec-vinc.
        when "hp-codigo" then c-value = RowObject.hp-codigo.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "mo-codigo" then c-value = RowObject.mo-codigo.
        when "mo-vl-titulo" then c-value = RowObject.mo-vl-titulo.
        when "nr-invoice" then c-value = RowObject.nr-invoice.
        when "num-ord-inv" then c-value = RowObject.num-ord-inv.
        when "origem" then c-value = RowObject.origem.
        when "seq-import" then c-value = RowObject.seq-import.
        when "sequencia" then c-value = RowObject.sequencia.
        when "sit-receb" then c-value = RowObject.sit-receb.
        when "tipo-mercad" then c-value = RowObject.tipo-mercad.
        when "tp-codigo" then c-value = RowObject.tp-codigo.
        when "tp-pagto" then c-value = RowObject.tp-pagto.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.
        when "dt-desconto" then c-value = RowObject.dt-desconto.
        when "dt-emissao" then c-value = RowObject.dt-emissao.
        when "dt-prev-pag" then c-value = RowObject.dt-prev-pag.
        when "dt-transacao" then c-value = RowObject.dt-transacao.
        when "dt-vencimen" then c-value = RowObject.dt-vencimen.
        when "u-data-1" then c-value = RowObject.u-data-1.
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        when "tem-credito" then c-value = RowObject.tem-credito.
        when "tem-hist" then c-value = RowObject.tem-hist.
        otherwise return error.
    end case.
end procedure.
 
