/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD125 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad125 MUT}
&ENDIF

/*
**  BOAD125.P
**
**  geren-cb - Arquivo de Valores do Caixa e Bancos p/ o modulo gerencial
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY geren-cb
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME geren-cb
 
{include/boini.i}
 
{adbo/boad125.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

/* Definicao {&FC_OBJETIVO_GE} */
{gep/ge9500.i}
 
procedure setConstraint1:
 
end procedure.
 
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
    def input parameter c-cod-estabel as char no-undo.
    def input parameter da-data as date no-undo.
    def output parameter c-return as char no-undo.
 
    find geren-cb where
        geren-cb.ep-codigo = i-ep-codigo
        and geren-cb.cod-estabel = c-cod-estabel
        and geren-cb.data = da-data
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
 
    if rowObject.data = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.duplicata-ap = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.duplicata-cr = ? then do:
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
 
    if rowObject.ped-compra = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ped-fat = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.previsao-ap = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.previsao-cr = ? then do:
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
 
    if rowObject.data = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} data 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.duplicata-ap = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} duplicata-ap 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.duplicata-cr = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} duplicata-cr 1}
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
 
    if rowObject.ped-compra = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ped-compra 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ped-fat = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ped-fat 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.previsao-ap = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} previsao-ap 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.previsao-cr = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} previsao-cr 1}
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
        find geren-cb where
            geren-cb.ep-codigo = rowObject.ep-codigo
        and geren-cb.cod-estabel = rowObject.cod-estabel
        and geren-cb.data = rowObject.data
            no-lock no-error.
        if avail geren-cb then do:
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
        when "cod-estabel" then c-value = RowObject.cod-estabel.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "duplicata-ap" then c-value = RowObject.duplicata-ap.
        when "duplicata-cr" then c-value = RowObject.duplicata-cr.
        when "ped-compra" then c-value = RowObject.ped-compra.
        when "ped-fat" then c-value = RowObject.ped-fat.
        when "previsao-ap" then c-value = RowObject.previsao-ap.
        when "previsao-cr" then c-value = RowObject.previsao-cr.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        &IF "{&mguni_version}" < "2.07A" &THEN
            when "ep-codigo" then c-value = RowObject.ep-codigo.
        &ENDIF
        
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data" then c-value = RowObject.data.
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
 
PROCEDURE zeraValores:
    &IF "{&mguni_version}" >= "2.07A" &THEN
    DEF INPUT PARAM pEpCodigo     LIKE empresa.ep-codigo  NO-UNDO.    
    &ELSE
    DEF INPUT PARAM pEpCodigo     AS INT  NO-UNDO.
    &ENDIF
    DEF INPUT PARAM pMaquina      AS INT  NO-UNDO.
    DEF INPUT PARAM pDatInicialGE AS DATE NO-UNDO.
    DEF INPUT PARAM pModulo       AS CHAR NO-UNDO.

    FOR EACH {&TABLE-NAME}
        WHERE {&TABLE-NAME}.ep-codigo = pEpCodigo
        /*** TRATAMENTO 2.03 ***/
        &IF "{&FC_OBJETIVO_GE}" = "YES" &THEN 
        AND   {&TABLE-NAME}.cod-maquina-origem = pMaquina
        &ENDIF
        /***-----------------***/
        EXCLUSIVE-LOCK ON STOP UNDO, LEAVE:
        IF  {&TABLE-NAME}.data < pDatInicialGE THEN 
            DELETE {&TABLE-NAME}.
        ELSE DO:
            CASE pModulo:
                WHEN "AP":U OR WHEN "APB":U THEN 
                    ASSIGN {&TABLE-NAME}.duplicata-ap = 0.
                WHEN "CR":U OR WHEN "ACR":U THEN 
                    ASSIGN {&TABLE-NAME}.duplicata-cr = 0.
            END CASE.
        END.
    END.
END PROCEDURE.

PROCEDURE atualizaValores:
    &IF "{&mguni_version}" >= "2.07A" &THEN
    DEF INPUT PARAM pEpCodigo     LIKE empresa.ep-codigo  NO-UNDO.    
    &ELSE
    DEF INPUT PARAM pEpCodigo     AS INT  NO-UNDO.
    &ENDIF
    DEF INPUT PARAM pCodEstabel AS CHAR NO-UNDO.
    DEF INPUT PARAM pData       AS DATE NO-UNDO.
    DEF INPUT PARAM pMaquina    AS INT  NO-UNDO.
    DEF INPUT PARAM pModulo     AS CHAR NO-UNDO.
    DEF INPUT PARAM pValor      AS DEC  NO-UNDO.

    FIND {&TABLE-NAME} EXCLUSIVE-LOCK 
        WHERE {&TABLE-NAME}.ep-codigo   = pEpCodigo
        AND   {&TABLE-NAME}.cod-estabel = pCodEstabel
        AND   {&TABLE-NAME}.data        = pData
        /*** TRATAMENTO 2.03 ***/
        &IF "{&FC_OBJETIVO_GE}" = "YES" &THEN 
        and {&TABLE-NAME}.cod-maquina-origem = pMaquina              
        &ENDIF
        /***-----------------***/ NO-WAIT NO-ERROR.
        
    IF  NOT AVAIL  {&TABLE-NAME}
    AND NOT LOCKED {&TABLE-NAME} THEN DO:
        CREATE {&TABLE-NAME}.
        ASSIGN {&TABLE-NAME}.ep-codigo    = pEpCodigo
               {&TABLE-NAME}.cod-estabel  = pCodEstabel
               {&TABLE-NAME}.data         = pData
               /*** TRATAMENTO 2.03 ***/
               &IF "{&FC_OBJETIVO_GE}" = "YES" &THEN 
               {&TABLE-NAME}.cod-maquina-origem = pMaquina              
               &ENDIF
               /***-----------------***/                     
               {&TABLE-NAME}.duplicata-cr = 0
               {&TABLE-NAME}.duplicata-ap = 0
               {&TABLE-NAME}.ped-compra   = 0
               {&TABLE-NAME}.ped-fat      = 0
               {&TABLE-NAME}.previsao-cr  = 0.
    END.
    
    IF  AVAIL {&TABLE-NAME} THEN DO:
        CASE pModulo:
            WHEN "AP":U OR WHEN "APB":U THEN 
                ASSIGN {&TABLE-NAME}.duplicata-ap = {&TABLE-NAME}.duplicata-ap + pValor.
            WHEN "CR":U OR WHEN "ACR":U THEN 
                ASSIGN {&TABLE-NAME}.duplicata-cr = {&TABLE-NAME}.duplicata-cr + pValor.
        END CASE.
    END.
END PROCEDURE.
