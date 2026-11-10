/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD039 2.00.00.014} /*** "010014" 10/06/2025 09:30:37  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOAD039 MUT}
&ENDIF


/*
**  BOAD039.P
**
**  cond-pagto - Condição de Pagamento
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY cond-pagto
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME cond-pagto
 
{include/boini.i}
{include/i_dbtype.i}
 
{cdp/cdcfgdis.i} /* Include uso de pre-processadores para modulo BN*/

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se nÆo, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */ 

{adbo/boad039.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 def var i-cond  as integer no-undo.
 def var i-condi as integer no-undo.
 def var i-condf as integer no-undo.
 DEF VAR c-desc  AS CHAR    NO-UNDO.

procedure setConstraint1:
 def input param p-cod-inicial as char no-undo.
 MESSAGE "teste 2,5 ==" VIEW-AS ALERT-BOX.
 assign i-cond = integer(p-cod-inicial).
end procedure.
 
procedure setConstraint2:
 def input param p-cod-inicial as char no-undo.
 def input param p-cod-final as char no-undo.

 assign i-condi = integer(p-cod-inicial)
        i-condf = integer(p-cod-final).
end procedure.

PROCEDURE setConstraint3:
 DEF INPUT PARAM p-cod-desc AS CHAR NO-UNDO.
 ASSIGN c-desc = p-cod-desc.
END PROCEDURE.



procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.cod-cond-pag >= i-cond no-lock INDEXED-REPOSITION.
        when 2 then do:
            if i-condi = i-condf then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.cod-cond-pag  = i-condi no-lock by {&TABLE-NAME}.cod-cond-pag INDEXED-REPOSITION.
            else
                open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.cod-cond-pag >= i-condi and~
                                                                      {&TABLE-NAME}.cod-cond-pag <= i-condf no-lock by {&TABLE-NAME}.cod-cond-pag INDEXED-REPOSITION.
        end.                                                                         
        WHEN 3 THEN
            OPEN QUERY {&query-name} FOR EACH {&table-name} WHERE {&table-name}.descricao >= c-desc NO-LOCK BY {&table-name}.descricao &if "{&dbtype}" = "progress" &THEN 
                                                                                        ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ INDEXED-REPOSITION 
                                                                                        ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ &ENDIF.

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
/*{include/bovaldel.i}*/
 
procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.
 
{adbo/boad039.i1} /* procedure findCodigo - utilizado pelo Magnus e pelo EMS */

procedure validateFields:
    /*
    **  Valida Fields
    */
    find first rowObject
        no-lock no-error.
 
    run startMethod ("validateFields").
    if rowObject.cod-cond-pag = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[03] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[04] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[05] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[06] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[07] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[08] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[09] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[10] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[11] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[12] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-vencto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.descricao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dia-mes-base = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dia-mes-venc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dia-sem-base = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dia-sem-venc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.num-parcelas = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[03] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[04] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[05] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[06] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[07] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[08] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[09] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[10] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[11] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[12] = ? then do:
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
    if rowObject.cod-cond-pag = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-cond-pag 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-ven-par 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-ven-par 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[03] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-ven-par 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[04] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-ven-par 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[05] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-ven-par 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[06] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-ven-par 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[07] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-ven-par 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[08] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-ven-par 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[09] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-ven-par 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[10] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-ven-par 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[11] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-ven-par 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ven-par[12] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-ven-par 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-vencto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-vencto 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.descricao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} descricao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dia-mes-base = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} dia-mes-base 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dia-mes-venc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} dia-mes-venc 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dia-sem-base = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} dia-sem-base 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dia-sem-venc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} dia-sem-venc 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.num-parcelas = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} num-parcelas 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} prazos 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} prazos 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[03] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} prazos 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[04] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} prazos 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[05] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} prazos 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[06] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} prazos 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[07] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} prazos 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[08] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} prazos 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[09] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} prazos 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[10] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} prazos 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[11] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} prazos 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prazos[12] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} prazos 1}
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
        find cond-pagto where
            cond-pagto.cod-cond-pag = rowObject.cod-cond-pag
            no-lock no-error.
        if avail cond-pagto then do:
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
 
procedure validateDelete:
    /*
    **  Valida Delete
    */
    def input-output parameter r-chave as rowid.
    def output parameter table for tt-bo-erro.
 
    run InitializeValidate.
     
    find first rowObject no-lock no-error.   
    
    find {&TABLE-NAME} where
        rowid({&TABLE-NAME}) = r-chave
        exclusive-lock no-error.
    if avail {&TABLE-NAME} then do:

       /***** ATENCAO - Uso de Pre-processador *******/
       &if defined (bf_dis_desc_bonif) &then  /* pre-processador */   
           run verificarRelacoesEliminarCondPagto.
       &endif /* preprocessador */
       /***** fim - Uso de Pre-processador *******/
   
       find first tt-bo-erro no-lock no-error.
       if not avail tt-bo-erro then
          run executeDelete.
    end.
 
    if l-query then
        get next {&QUERY-NAME}
            no-lock no-wait.
    else
        find next {&TABLE-NAME}
            no-lock no-error.

    if not avail {&TABLE-NAME} then do:
       if l-query then
           get prev {&QUERY-NAME}
               no-lock no-wait.
       else
           find prev {&TABLE-NAME}
               no-lock no-error.
    end.
    assign r-chave = rowid({&TABLE-NAME}).
    return "".
end procedure.  
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    if not avail rowobject then
       return "nok".      
    case c-field:
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.        
        when "descricao" then c-value = RowObject.descricao.
        &if defined(bf-mat-comex) &then      
            when "u-char-1" then c-value = RowObject.u-char-1.
            when "u-char-2" then c-value = RowObject.u-char-2.               
        &else
            when "check-sum" then c-value = RowObject.check-sum.        
        &endif        
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    if not avail rowobject then
       return "nok".
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "per-des-pgan" then c-value = RowObject.per-des-pgan.
        when "per-pg-dup[1]" then c-value = RowObject.per-pg-dup[1].
        when "per-pg-dup[2]" then c-value = RowObject.per-pg-dup[2].
        when "per-pg-dup[3]" then c-value = RowObject.per-pg-dup[3].
        when "per-pg-dup[4]" then c-value = RowObject.per-pg-dup[4].
        when "per-pg-dup[5]" then c-value = RowObject.per-pg-dup[5].
        when "per-pg-dup[6]" then c-value = RowObject.per-pg-dup[6].
        when "per-pg-dup[7]" then c-value = RowObject.per-pg-dup[7].
        when "per-pg-dup[8]" then c-value = RowObject.per-pg-dup[8].
        when "per-pg-dup[9]" then c-value = RowObject.per-pg-dup[9].
        when "per-pg-dup[10]" then c-value = RowObject.per-pg-dup[10].
        when "per-pg-dup[11]" then c-value = RowObject.per-pg-dup[11].
        when "per-pg-dup[12]" then c-value = RowObject.per-pg-dup[12].
        &if defined(bf-mat-comex) &then                      
            when "u-dec-1" then c-value = RowObject.u-dec-1.
            when "u-dec-2" then c-value = RowObject.u-dec-2.         
        &else
        &endif
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    if not avail rowobject then
       return "nok".
    case c-field:
        when "cod-cond-pag" then c-value = RowObject.cod-cond-pag.
        when "cod-ven-par[1]" then c-value = RowObject.cod-ven-par[1].
        when "cod-ven-par[2]" then c-value = RowObject.cod-ven-par[2].
        when "cod-ven-par[3]" then c-value = RowObject.cod-ven-par[3].
        when "cod-ven-par[4]" then c-value = RowObject.cod-ven-par[4].
        when "cod-ven-par[5]" then c-value = RowObject.cod-ven-par[5].
        when "cod-ven-par[6]" then c-value = RowObject.cod-ven-par[6].
        when "cod-ven-par[7]" then c-value = RowObject.cod-ven-par[7].
        when "cod-ven-par[8]" then c-value = RowObject.cod-ven-par[8].
        when "cod-ven-par[9]" then c-value = RowObject.cod-ven-par[9].
        when "cod-ven-par[10]" then c-value = RowObject.cod-ven-par[10].
        when "cod-ven-par[11]" then c-value = RowObject.cod-ven-par[11].
        when "cod-ven-par[12]" then c-value = RowObject.cod-ven-par[12].
        when "cod-vencto" then c-value = RowObject.cod-vencto.
        when "dia-mes-base" then c-value = RowObject.dia-mes-base.
        when "dia-mes-venc" then c-value = RowObject.dia-mes-venc.
        when "dia-sem-base" then c-value = RowObject.dia-sem-base.
        when "dia-sem-venc" then c-value = RowObject.dia-sem-venc.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "nr-dias-ante" then c-value = RowObject.nr-dias-ante.
        when "nr-dupdes" then c-value = RowObject.nr-dupdes.
        when "nr-ind-finan" then c-value = RowObject.nr-ind-finan.
        when "nr-tab-finan" then c-value = RowObject.nr-tab-finan.
        when "num-parcelas" then c-value = RowObject.num-parcelas.
        when "prazos[1]" then c-value = RowObject.prazos[1].
        when "prazos[2]" then c-value = RowObject.prazos[2].
        when "prazos[3]" then c-value = RowObject.prazos[3].
        when "prazos[4]" then c-value = RowObject.prazos[4].
        when "prazos[5]" then c-value = RowObject.prazos[5].
        when "prazos[6]" then c-value = RowObject.prazos[6].
        when "prazos[7]" then c-value = RowObject.prazos[7].
        when "prazos[8]" then c-value = RowObject.prazos[8].
        when "prazos[9]" then c-value = RowObject.prazos[9].
        when "prazos[10]" then c-value = RowObject.prazos[10].
        when "prazos[11]" then c-value = RowObject.prazos[11].
        when "prazos[12]" then c-value = RowObject.prazos[12].
        &if defined(bf-mat-comex) &then          
            when "u-int-1" then c-value = RowObject.u-int-1.
            when "u-int-2" then c-value = RowObject.u-int-2.           
        &else
            when "ano-base" then c-value = RowObject.ano-base.        
            when "mes-base" then c-value = RowObject.mes-base.            
        &endif        
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    if not avail rowobject then
       return "nok".
    case c-field:
        &if defined(bf-mat-comex) &then           
        &else
            when "data-1" then c-value = RowObject.data-1.
            when "data-2" then c-value = RowObject.data-2.        
        &endif        
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    if not avail rowobject then
       return "nok".
    case c-field:
        when "log-1" then c-value = RowObject.log-1.
        &if defined(bf-mat-comex) &then           
        &else        
            when "log-2" then c-value = RowObject.log-2.
        &endif
        otherwise return error.
    end case.
end procedure.


/***** ATENCAO - Uso de Pre-processador *******/
&if defined (bf_dis_desc_bonif) &then  /* pre-processador */   

    procedure verificarRelacoesEliminarCondPagto:
    /*
    M‚todo implementado para realizar a valida‡Æo na  elimina‡Æo da tabela Cond Pagto e verificar se 
    o Cond Pagto est  sendo usado nas tabelas desconto e canal-cliente. 
    */
        def var c-texto       as char extent 2 no-undo.

    
        find first param-global
            no-lock no-error.
    
        if param-global.modulo-09 then do: /* modulo BN */ 
            if can-find (first desconto where 
                               desconto.cod-cond-pag = cond-pagto.cod-cond-pag) then do:         
               assign i-seq-erro = i-seq-erro + 1.
               {utp/ut-table.i mgadm {&TABLE-NAME} 1}
               assign c-texto[1] = return-value.
               {utp/ut-table.i mgdis desconto 1}
               assign c-texto[2] = return-value.     
               run utp/ut-msgs.p (input "msg",
                                  input 5,          /* Cond Pagto possui relacionamentos ativos com Desconto.*/
                                  input c-texto[1] + "~~" + c-texto[2]).
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 5
                      tt-bo-erro.mensagem     = return-value.  
               assign tt-bo-erro.parametros    = c-texto[1] + "~~" + c-texto[2].
            end.    
    
            if can-find (first canal-cliente where 
                               canal-cliente.cod-cond-pag = cond-pagto.cod-cond-pag) then do:         
               assign i-seq-erro = i-seq-erro + 1.
               {utp/ut-table.i mgadm {&TABLE-NAME} 1}
               assign c-texto[1] = return-value.
               {utp/ut-table.i mgdis canal-cliente 1}
               assign c-texto[2] = return-value.     
               run utp/ut-msgs.p (input "msg",
                                  input 5,        /* cond Pagto possui relacionamentos ativos com Canal Cliente. */
                                  input c-texto[1] + "~~" + c-texto[2]).
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 5
                      tt-bo-erro.mensagem     = return-value.          
               assign tt-bo-erro.parametros    = c-texto[1] + "~~" + c-texto[2].
                      
            end.

        end. /* param-global */    
    end procedure.
    
&endif /* preprocessador */
/***** fim - Uso de Pre-processador *******/ 
