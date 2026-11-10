/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD035 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad035 MUT}
&ENDIF

/*
**  BOAD035.P
**
**  che-emit - Cheques Emitidos no Período (Contas a Pagar)
**
**  Ultima altera‡Æo : 31/03/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY che-emit
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME che-emit
 
{include/boini.i}
 
 
{adbo/boad035.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
DEFINE VAR nr-cheque-ini  AS DECIMAL NO-UNDO.
DEFINE VAR nr-cheque-fim  AS DECIMAL NO-UNDO.
DEFINE VAR dt-emissao-ini AS DATE NO-UNDO.
DEFINE VAR dt-emissao-fim AS DATE NO-UNDO.
DEFINE VAR l-emitiu       AS LOGICAL NO-UNDO.
DEFINE VAR l-cancelado    AS LOGICAL NO-UNDO. 
&IF "{&mguni_version}" >= "2.07A" &THEN
DEFINE VAR ep-codigo-port LIKE empresa.ep-codigo NO-UNDO.
&ELSE
DEFINE VAR ep-codigo-port AS INTEGER NO-UNDO.
&ENDIF
DEFINE VAR cod-port       AS INTEGER NO-UNDO.
 
procedure setConstraint1:
 
end procedure.
procedure setConstraint2:
def input parameter p-chave as rowid no-undo.
def input parameter p-nr-ch-ini as decimal no-undo.
def input parameter p-nr-ch-fim as decimal no-undo.
def input parameter p-dt-emissao-ini as date no-undo.
def input parameter p-dt-emissao-fim as date no-undo.
def input parameter p-l-emitiu as logical no-undo.
def input parameter p-l-cancelado as logical no-undo.

    assign nr-cheque-ini = p-nr-ch-ini
           nr-cheque-fim = p-nr-ch-fim
           dt-emissao-ini = p-dt-emissao-ini
           dt-emissao-fim = p-dt-emissao-fim
           l-emitiu = p-l-emitiu
           l-cancelado = p-l-cancelado.
    find portador where rowid(portador) = p-chave no-lock no-error.
    if avail portador then do:
        assign ep-codigo-port = portador.ep-codigo
               cod-port = portador.cod-portador.
           
    end.

end.
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
        when 2 then
            if nr-cheque-ini = nr-cheque-fim then do:
                open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                            WHERE che-emit.ep-codigo   = ep-codigo-port
                                              AND che-emit.portador    = cod-port
                                              AND che-emit.nr-cheque   = nr-cheque-ini
                                              AND che-emit.dt-emissao >= dt-emissao-ini
                                              AND che-emit.dt-emissao <= dt-emissao-fim
                                              AND che-emit.emitiu      = l-emitiu
                                              AND che-emit.cancelado   = l-cancelado INDEXED-REPOSITION.
            end.
            else do:
                open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                            WHERE che-emit.ep-codigo   = ep-codigo-port
                                              AND che-emit.portador    = cod-port
                                              AND che-emit.nr-cheque  >= nr-cheque-ini
                                              AND che-emit.nr-cheque  <= nr-cheque-fim
                                              AND che-emit.dt-emissao >= dt-emissao-ini
                                              AND che-emit.dt-emissao <= dt-emissao-fim
                                              AND che-emit.emitiu      = l-emitiu
                                              AND che-emit.cancelado   = l-cancelado INDEXED-REPOSITION.
            end.

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
 
procedure findNum_id:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter i-num-id-che-emit as inte no-undo.
    def output parameter c-return as char no-undo.
 
    find che-emit where
        che-emit.num-id-che-emit = i-num-id-che-emit
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i movadm {&TABLE-NAME} 1}
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
    if rowObject.cancelado = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
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
 
    if rowObject.ct-conta = ? then do:
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
 
    if rowObject.mo-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nominal = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-cheque = ? then do:
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
 
    if rowObject.num-id-che-emit = ? then do:
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
 
    if rowObject.portador = ? then do:
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
 
    if rowObject.sc-conta = ? then do:
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
 
    if rowObject.transacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor-docto = ? then do:
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
    if rowObject.cancelado = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} cancelado 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-esp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} cod-esp 1}
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
        {utp/ut-field.i movadm {&TABLE-NAME} cod-estabel 1}
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
        {utp/ut-field.i movadm {&TABLE-NAME} cod-fornec 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ct-conta = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} ct-conta 1}
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
        {utp/ut-field.i movadm {&TABLE-NAME} ep-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.mo-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} mo-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nominal = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} nominal 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-cheque = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} nr-cheque 1}
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
        {utp/ut-field.i movadm {&TABLE-NAME} nr-docto 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.num-id-che-emit = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} num-id-che-emit 1}
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
        {utp/ut-field.i movadm {&TABLE-NAME} parcela 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.portador = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} portador 1}
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
        {utp/ut-field.i movadm {&TABLE-NAME} referencia 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.sc-conta = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} sc-conta 1}
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
        {utp/ut-field.i movadm {&TABLE-NAME} serie 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.transacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} transacao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor-docto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movadm {&TABLE-NAME} valor-docto 1}
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
        find che-emit where
            che-emit.num-id-che-emit = rowObject.num-id-che-emit
            no-lock no-error.
        if avail che-emit then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i movadm {&TABLE-NAME} 1}
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
        when "cod-esp" then c-value = RowObject.cod-esp.
        when "cod-estabel" then c-value = RowObject.cod-estabel.
        when "conta-debito" then c-value = RowObject.conta-debito.
        when "ct-conta" then c-value = RowObject.ct-conta.
        when "historico" then c-value = RowObject.historico.
        when "literal" then c-value = RowObject.literal.
        when "nr-docto" then c-value = RowObject.nr-docto.
        when "nr-talonario" then c-value = RowObject.nr-talonario.
        when "parcela" then c-value = RowObject.parcela.
        when "referencia" then c-value = RowObject.referencia.
        when "sc-conta" then c-value = RowObject.sc-conta.
        when "serie" then c-value = RowObject.serie.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "nr-cheque" then c-value = RowObject.nr-cheque.
        when "valor-docto" then c-value = RowObject.valor-docto.
        when "valor-docto-me" then c-value = RowObject.valor-docto-me.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "cod-fornec" then c-value = RowObject.cod-fornec.
        when "destino" then c-value = RowObject.destino.
        &IF "{&mguni_version}" < "2.07A" &THEN
            when "ep-codigo" then c-value = RowObject.ep-codigo.
        &ENDIF
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "mo-codigo" then c-value = RowObject.mo-codigo.
        when "nominal" then c-value = RowObject.nominal.
        when "num-id-che-emit" then c-value = RowObject.num-id-che-emit.
        when "portador" then c-value = RowObject.portador.
        when "sequencia" then c-value = RowObject.sequencia.
        when "transacao" then c-value = RowObject.transacao.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.
        when "dt-cancela" then c-value = RowObject.dt-cancela.
        when "dt-compensacao" then c-value = RowObject.dt-compensacao.
        when "dt-emissao" then c-value = RowObject.dt-emissao.
        when "dt-entr" then c-value = RowObject.dt-entr.
        when "dt-vencto" then c-value = RowObject.dt-vencto.
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "automatico" then c-value = RowObject.automatico.
        when "cancelado" then c-value = RowObject.cancelado.
        when "emitiu" then c-value = RowObject.emitiu.
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        otherwise return error.
    end case.
end procedure.

procedure verificachequeemitido:
   /* Verfica se existe algum cheque emitido 
    * Parâmetros:
    * ipar1 : p-ep-codigo-usuario : código da empresa
    * ipar2 : p-portador          : código do portador
    * ipar3 : p-nr-cheque         : nro do cheque
    * opar1 : l-cheque-emitido    : 
    */

&IF "{&mguni_version}" >= "2.07A" &THEN
    def input parameter  p-ep-codigo-usuario LIKE empresa.ep-codigo            no-undo.
&ELSE
    def input parameter  p-ep-codigo-usuario as integer            no-undo.
&ENDIF
    def input parameter  p-portador          like mov-ap.portador  no-undo.
    def input parameter  p-nr-cheque         like mov-ap.nr-cheque no-undo. 
    def output parameter l-cheque-emitido    as logical            no-undo.  

    find first che-emit where che-emit.ep-codigo = p-ep-codigo-usuario
                        and   che-emit.portador  = p-portador
                        and   che-emit.nr-cheque = p-nr-cheque no-lock no-error.
    if  avail che-emit then
        assign l-cheque-emitido = che-emit.emitiu.
    else     
        assign l-cheque-emitido = yes.
end.

procedure pi-verifica-cheque:
    def input  param p-ep-codigo  like che-emit.ep-codigo.
    def input  param p-portador   like che-emit.portador.
    def input  param p-nr-cheque  like che-emit.nr-cheque.
    def output param p-dt-emissao like che-emit.dt-emissao.
    def output param p-emitiu     like che-emit.emitiu.
    def output param p-cancelado  like che-emit.cancelado.

    find first che-emit 
         where che-emit.ep-codigo = p-ep-codigo
         and   che-emit.portador  = p-portador
         and   che-emit.nr-cheque = p-nr-cheque no-lock no-error.
    if avail che-emit then do:
        assign p-dt-emissao = che-emit.dt-emissao
               p-emitiu     = che-emit.emitiu
               p-cancelado  = che-emit.cancelado.
        RETURN "OK":U.
    end.
    else
        RETURN "NOK":U.
end procedure.



