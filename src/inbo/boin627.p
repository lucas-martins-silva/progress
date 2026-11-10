/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN627 2.00.01.002}  /*** 010102 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN627 MUT}
&ENDIF

/*
**  BOIN627.P
**
**  usuar-mater - Tabela de usu†rios do sistema de materiais
**
**  Ultima alteraá∆o : 02/04/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY usuar-mater
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME usuar-mater
 
{include/boini.i}
{inbo/boin627.i RowObject}
{cdp/cdcfgmat.i}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
def var c-cd-usuario as char.
 
/* Vari†veis necess†rias ao setConstraint4 */ 
def var c-comprado-ini        as char no-undo.
def var c-comprado-fim        as char no-undo.
DEF VAR c-nome-ini            AS CHAR NO-UNDO.
DEF VAR c-nome-fim            AS CHAR NO-UNDO.
DEF VAR l-valida-usuar-pregao AS LOG NO-UNDO.
 
procedure setConstraint1:

end procedure.

procedure setConstraint3:
    def input parameter p-cod-usuario as char.
    assign c-cd-usuario = p-cod-usuario.

end procedure.

procedure setConstraint4:
    def input parameter p-comprado-ini as char.
    def input parameter p-comprado-fim as char no-undo.
    
    assign c-comprado-ini = p-comprado-ini
           c-comprado-fim = p-comprado-fim .
           
end procedure.

PROCEDURE setconstraint5:
    DEFINE INPUT  PARAMETER p-nome-ini AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER p-nome-fim AS CHARACTER  NO-UNDO.

    ASSIGN
        c-nome-ini = p-nome-ini
        c-nome-fim = p-nome-fim.

    RETURN "OK":U.
END.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                       {&TABLE-NAME}.usuar-comprador = yes no-lock INDEXED-REPOSITION.
        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                       {&TABLE-NAME}.usuar-comprador = yes and
                       {&TABLE-NAME}.cod-usuario >= c-cd-usuario no-lock INDEXED-REPOSITION.
        when 4 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                       {&TABLE-NAME}.cod-usuario     >= c-comprado-ini and
                       {&TABLE-NAME}.cod-usuario     <= c-comprado-fim and
                       {&TABLE-NAME}.usuar-comprador  = yes no-lock INDEXED-REPOSITION.
        when 5 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                       {&TABLE-NAME}.nome-usuar >= c-nome-ini and
                       {&TABLE-NAME}.nome-usuar <= c-nome-fim and
                       {&TABLE-NAME}.usuar-comprador  = yes no-lock INDEXED-REPOSITION.
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
 
procedure findUsuar_mater:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-cod-usuario as char no-undo.
    def output parameter c-return as char no-undo.
 
    find usuar-mater where
        usuar-mater.cod-usuario = c-cod-usuario
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

procedure findUsuar_mater_Comprador:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-cod-usuario as char no-undo.
    def output parameter c-return as char no-undo.
 
    find usuar-mater where
        usuar-mater.cod-usuario     = c-cod-usuario and
	 usuar-mater.usuar-comprador = yes 
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
 
procedure validateFields:
    /*
    **  Valida Fields
    */
    find first rowObject
        no-lock no-error.
 
    run startMethod ("validateFields").
    if rowObject.lim-requis = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nome-usuar = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tp-preco = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.usuar-aprovador = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.usuar-comprador = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.usuar-requis = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.usuar-requis-manut = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.usuar-solic = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.

    /*** Validaá∆o Usu†rio Preg∆o***/
    ASSIGN l-valida-usuar-pregao = NO.
    FIND FIRST param-compra NO-LOCK NO-ERROR.
    IF AVAIL param-compra THEN DO:
        &IF "{&bf_mat_versao_ems}" >= "2.07" &then   
            IF param-compra.log-param-pregao-eletron AND
               RowObject.log-usuar-pregao = ? THEN 
                ASSIGN l-valida-usuar-pregao = YES.

        &ELSEIF "{&bf_mat_versao_ems}" >= "2.062" &then
            IF substring(param-compra.char-2,22,1) = "1" AND 
               SUBSTRING(RowObject.char-1,13,1)    = ? THEN        
                ASSIGN l-valida-usuar-pregao = YES.
        &ENDIF
    END.
    if l-valida-usuar-pregao then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Usu†rio_Preg∆o *}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input RETURN-VALUE).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    /******/
 
    run endMethod ("validateFields").
 
end procedure.
 
procedure validateCreate:
    /*
    **  Valida criaá∆o da tabela/duplicidade de registro.
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
    if rowObject.lim-requis = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} lim-requis 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nome-usuar = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} nome-usuar 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tp-preco = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} tp-preco 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.usuar-aprovador = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} usuar-aprovador 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.usuar-comprador = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} usuar-comprador 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.usuar-requis = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} usuar-requis 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.usuar-requis-manut = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} usuar-requis-manut 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.usuar-solic = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} usuar-solic 1}
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
        find usuar-mater where
            usuar-mater.cod-usuario = rowObject.cod-usuario
            no-lock no-error.
        if avail usuar-mater then do:
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
        when "cod-grp-compra" then c-value = RowObject.cod-grp-compra.
        when "cod-usuario" then c-value = RowObject.cod-usuario.
        when "ct-codigo" then c-value = RowObject.ct-codigo.
        when "e-mail" then c-value = RowObject.e-mail.
        when "home-page" then c-value = RowObject.home-page.
        when "nome-usuar" then c-value = RowObject.nome-usuar.
        when "ramal[1]" then c-value = RowObject.ramal[1].
        when "ramal[2]" then c-value = RowObject.ramal[2].
        when "ramal-fax" then c-value = RowObject.ramal-fax.
        when "ramal-modem" then c-value = RowObject.ramal-modem.
        when "sc-codigo" then c-value = RowObject.sc-codigo.
        when "telef-modem" then c-value = RowObject.telef-modem.
        when "telefax" then c-value = RowObject.telefax.
        when "telefone[1]" then c-value = RowObject.telefone[1].
        when "telefone[2]" then c-value = RowObject.telefone[2].
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "lim-requis" then c-value = RowObject.lim-requis.
        when "lim-requis-manut" then c-value = RowObject.lim-requis-manut.
        when "lim-solic" then c-value = RowObject.lim-solic.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "mo-codigo" then c-value = RowObject.mo-codigo.
        when "tp-preco" then c-value = RowObject.tp-preco.
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
        when "classif-solic" then c-value = RowObject.classif-solic.
        when "corporativo" then c-value = RowObject.corporativo.
        when "envia-e-mail" then c-value = RowObject.envia-e-mail.
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        when "recebe-e-mail" then c-value = RowObject.recebe-e-mail.
        when "usuar-aprovador" then c-value = RowObject.usuar-aprovador.
        when "usuar-comprador" then c-value = RowObject.usuar-comprador.
        when "usuar-pedido" then c-value = RowObject.usuar-pedido.
        when "usuar-requis" then c-value = RowObject.usuar-requis.
        when "usuar-requis-manut" then c-value = RowObject.usuar-requis-manut.
        when "usuar-solic" then c-value = RowObject.usuar-solic.
        WHEN "log-usuar-pregao" THEN c-value = &IF "{&bf_mat_versao_ems}" < "2.07" &THEN
                                                IF INT(SUBSTRING(rowObject.char-1,13,1)) = 1 THEN YES
                                                                                             ELSE NO.
                                               &ELSE
                                                rowObject.log-usuar-pregao.
                                               &ENDIF
        otherwise return error.
    end case.
end procedure.
 
procedure findKeyRowid:
    /*
    **  Localiza registro pela chave e retorna o rowid.
    */
    def input  parameter p-cod-usuario like usuar-mater.cod-usuario.
    def output parameter p-rowid as rowid no-undo.

    find {&TABLE-NAME} where
        {&TABLE-NAME}.cod-usuario = p-cod-usuario
        no-lock no-error.
    if available {&TABLE-NAME} then
        assign p-rowid = rowid({&TABLE-NAME}).
        assign p-rowid = rowid({&TABLE-NAME}).
end procedure.
