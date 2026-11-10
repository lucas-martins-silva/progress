/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD124 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad124 MUT}
&ENDIF

/*
**  BOAD124.P
**
**  geren-ap - Arquivo de Valores do Contas a Pagar p/ o modulo Gerencial
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/

&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY geren-ap
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME geren-ap

{include/boini.i}

{adbo/boad124.i RowObject}

DEFINE QUERY  {&QUERY-NAME}   for {&TABLE-NAME} scrolling.
DEFINE BUFFER bf{&TABLE-NAME} FOR {&TABLE-NAME}.

/* Definicao {&FC_OBJETIVO_GE} */
{gep/ge9500.i}

/* Versao dos Bancos */
{include/i_dbvers.i}

/* Definicao do ttData - Periodo a ser Atualizado */ 
DEF TEMP-TABLE ttData 
    FIELD data AS DATE
    INDEX ch-data IS PRIMARY data.

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
    def input parameter i-cod-gr-forn as inte no-undo.
    def input parameter da-dt-vencto as date no-undo.
    def output parameter c-return as char no-undo.

    find geren-ap where
        geren-ap.ep-codigo = i-ep-codigo
        and geren-ap.cod-estabel = c-cod-estabel
        and geren-ap.cod-gr-forn = i-cod-gr-forn
        and geren-ap.dt-vencto = da-dt-vencto
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

    if rowObject.cod-gr-forn = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.dt-vencto = ? then do:
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

    if rowObject.vl-antecip = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.vl-baixado = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.vl-bx-antec = ? then do:
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

    if rowObject.vl-emitido = ? then do:
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

    if rowObject.vl-previsao = ? then do:
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

    if rowObject.cod-gr-forn = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-gr-forn 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.dt-vencto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} dt-vencto 1}
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

    if rowObject.vl-antecip = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} vl-antecip 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.vl-baixado = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} vl-baixado 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.vl-bx-antec = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} vl-bx-antec 1}
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

    if rowObject.vl-emitido = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} vl-emitido 1}
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

    if rowObject.vl-previsao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} vl-previsao 1}
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
        find geren-ap where
            geren-ap.ep-codigo = rowObject.ep-codigo
        and geren-ap.cod-estabel = rowObject.cod-estabel
        and geren-ap.cod-gr-forn = rowObject.cod-gr-forn
        and geren-ap.dt-vencto = rowObject.dt-vencto
            no-lock no-error.
        if avail geren-ap then do:
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
        when "vl-antecip" then c-value = RowObject.vl-antecip.
        when "vl-baixado" then c-value = RowObject.vl-baixado.
        when "vl-bx-antec" then c-value = RowObject.vl-bx-antec.
        when "vl-desconto" then c-value = RowObject.vl-desconto.
        when "vl-emitido" then c-value = RowObject.vl-emitido.
        when "vl-juros" then c-value = RowObject.vl-juros.
        when "vl-previsao" then c-value = RowObject.vl-previsao.
        otherwise return error.
    end case.
end procedure.

procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.

    case c-field:
        when "cod-gr-forn" then c-value = RowObject.cod-gr-forn.
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
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.
        when "dt-vencto" then c-value = RowObject.dt-vencto.
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
    DEF INPUT PARAM TABLE FOR ttData. 
    &IF "{&mguni_version}" >= "2.07A" &THEN
    DEF INPUT PARAM pEpCodigo     LIKE empresa.ep-codigo NO-UNDO.
    &ELSE
    DEF INPUT PARAM pEpCodigo     AS INT  NO-UNDO.
    &ENDIF
    DEF INPUT PARAM pTpGeracao    AS INT  NO-UNDO. 
    DEF INPUT PARAM iMaquina      AS INT  NO-UNDO.
    DEF INPUT PARAM pDatInicialGE AS DATE NO-UNDO.

    FOR EACH ttData,
        EACH  bf{&TABLE-NAME}
        WHERE bf{&TABLE-NAME}.ep-codigo = pEpCodigo
        AND  (bf{&TABLE-NAME}.dt-vencto = ttData.data OR pTpGeracao = 1)
        /*** TRATAMENTO 2.03 ***/
        &IF "{&FC_OBJETIVO_GE}" = "YES" &THEN     
        AND   bf{&TABLE-NAME}.cod-maquina-origem = iMaquina
        &ENDIF
        /***-----------------***/
        NO-LOCK ON STOP UNDO, LEAVE:    

        &IF  "{&mgadm_version}" >= "2.04" &THEN
             IF  bf{&TABLE-NAME}.cod-tipo-movto = "PMP" 
             OR  bf{&TABLE-NAME}.cod-tipo-movto = "AMP" THEN NEXT.
        &ELSE
             IF (bf{&TABLE-NAME}.cod-estabel = "PMP" 
             OR  bf{&TABLE-NAME}.cod-estabel = "AMP") 
             AND bf{&TABLE-NAME}.cod-gr-forn = (99 * -1) THEN NEXT.
        &ENDIF

        FIND {&TABLE-NAME} EXCLUSIVE-LOCK 
            WHERE ROWID({&TABLE-NAME}) = ROWID(bf{&TABLE-NAME}) NO-WAIT NO-ERROR.
        IF LOCKED {&TABLE-NAME} THEN NEXT.

        IF  {&TABLE-NAME}.dt-vencto < pDatInicialGE THEN 
            DELETE {&TABLE-NAME}.
        ELSE                                            
            ASSIGN {&TABLE-NAME}.vl-antecip  = 0
                   {&TABLE-NAME}.vl-baixado  = 0
                   {&TABLE-NAME}.vl-bx-antec = 0
                   {&TABLE-NAME}.vl-desconto = 0
                   {&TABLE-NAME}.vl-emitido  = 0
                   {&TABLE-NAME}.vl-juros    = 0
                   {&TABLE-NAME}.vl-previsao = 0.    
    END.
END PROCEDURE.


PROCEDURE zeraValoresCarteira:
    /**----ZERAR OS VALORES CARTEIRA-----**/
    &IF "{&mguni_version}" >= "2.07A" &THEN
    DEF INPUT PARAM pEpCodigo     LIKE empresa.ep-codigo NO-UNDO.
    &ELSE
    DEF INPUT PARAM pEpCodigo     AS INT  NO-UNDO.
    &ENDIF
    DEF INPUT PARAM pMaquina  AS INT NO-UNDO.

    FOR EACH {&TABLE-NAME}
        WHERE {&TABLE-NAME}.ep-codigo   = pEpCodigo
        AND   {&TABLE-NAME}.cod-gr-forn = 0
        AND   {&TABLE-NAME}.dt-vencto   = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF 
        /*** TRATAMENTO 2.03 ***/
        &IF "{&FC_OBJETIVO_GE}" = "YES" &THEN 
        AND   {&TABLE-NAME}.cod-maquina-origem = pMaquina
        &ENDIF
        /***-----------------***/        
        NO-LOCK ON STOP UNDO, LEAVE:

        FIND bf{&TABLE-NAME}
             WHERE ROWID(bf{&TABLE-NAME}) = rowid({&TABLE-NAME})             
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

        IF  AVAIL bf{&TABLE-NAME} THEN 
            ASSIGN bf{&TABLE-NAME}.vl-emitido  = 0              
                   bf{&TABLE-NAME}.vl-bx-antec = 0.   
    END. 
END PROCEDURE.

PROCEDURE atualizaValores:
    &IF "{&mguni_version}" >= "2.07A" &THEN
    DEF INPUT PARAM pEpCodigo     LIKE empresa.ep-codigo NO-UNDO.
    &ELSE
    DEF INPUT PARAM pEpCodigo     AS INT  NO-UNDO.
    &ENDIF
    DEF INPUT PARAM pCodEstabel  AS CHAR NO-UNDO.
    DEF INPUT PARAM pData        AS DATE NO-UNDO.
    DEF INPUT PARAM pMaquina     AS INT  NO-UNDO.
    DEF INPUT PARAM pDesValor    AS CHAR NO-UNDO.
    DEF INPUT PARAM pValor       AS DEC  NO-UNDO.

    FIND {&Table-Name} EXCLUSIVE-LOCK 
         WHERE {&Table-Name}.ep-codigo   = pEpCodigo
         AND   {&Table-Name}.cod-estabel = pCodEstabel
         AND   {&Table-Name}.cod-gr-forn = 0
         AND   {&Table-Name}.dt-vencto   = pData
         /*** TRATAMENTO 2.03 ***/
         &IF "{&FC_OBJETIVO_GE}" = "YES" &THEN 
         AND   {&Table-Name}.cod-maquina-origem = pMaquina
         &ENDIF
         /***-----------------***/ NO-WAIT NO-ERROR.

    IF  LOCKED {&Table-Name} THEN NEXT.
    IF  NOT AVAIL {&Table-Name} THEN DO:
        CREATE {&Table-Name}.
        ASSIGN {&Table-Name}.ep-codigo   = pEpCodigo
               {&Table-Name}.cod-estabel = pCodEstabel
               {&Table-Name}.cod-gr-forn = 0
               {&Table-Name}.dt-vencto   = pData
               /*** TRATAMENTO 2.03 ***/
               &IF "{&FC_OBJETIVO_GE}" = "YES" &THEN 
               {&Table-Name}.cod-maquina-origem = pMaquina
               &ENDIF
               /***-----------------***/ 
               {&Table-Name}.vl-antecip  = 0
               {&TABLE-NAME}.vl-emitido  = 0
               {&TABLE-NAME}.vl-desconto = 0
               {&TABLE-NAME}.vl-bx-antec = 0
               {&TABLE-NAME}.vl-baixado  = 0.
    END.
    CASE pDesValor:
        WHEN "PAGAMENTO":U THEN    /* Atualiza Pagamento Diario */
            ASSIGN {&TABLE-NAME}.vl-baixado  = {&TABLE-NAME}.vl-baixado  + pValor.
        WHEN "VENCIMENTO":U THEN /* Atualiza Vencimento Diario */
            ASSIGN {&Table-Name}.vl-antecip  = {&TABLE-NAME}.vl-antecip  + pValor.
        WHEN "CARTEIRA":U THEN   /* Atualiza Valores em Carteira - Data 01/01/0001 */
            ASSIGN {&TABLE-NAME}.vl-emitido  = {&TABLE-NAME}.vl-emitido  + pValor. 
        WHEN "ATRASO":U THEN       /* Atualiza Atraso > 30 dias - Data 01/01/0001 */
            ASSIGN {&TABLE-NAME}.vl-bx-antec = {&TABLE-NAME}.vl-bx-antec + pValor.
    END CASE.
END PROCEDURE.

PROCEDURE atualizaValoresAMPM:
    &IF "{&mguni_version}" >= "2.07A" &THEN
    DEF INPUT PARAM pEpCodigo     LIKE empresa.ep-codigo NO-UNDO.
    &ELSE
    DEF INPUT PARAM pEpCodigo     AS INT  NO-UNDO.
    &ENDIF
    DEF INPUT PARAM pMaquina     AS INT  NO-UNDO.
    DEF INPUT PARAM pDesValor    AS CHAR NO-UNDO.
    DEF INPUT PARAM pValor       AS DEC  NO-UNDO.

    DO TRANS:
        FIND {&TABLE-NAME} EXCLUSIVE-LOCK 
            WHERE {&TABLE-NAME}.ep-codigo    = pEpCodigo

            &IF  "{&mgadm_version}" >= "2.04" &THEN
            AND {&TABLE-NAME}.cod-tipo-movto = pDesValor
            &ELSE            
            AND {&TABLE-NAME}.cod-gr-forn    = (99 * -1)
            &ENDIF
            AND {&TABLE-NAME}.cod-estabel    = pDesValor
            AND {&TABLE-NAME}.dt-vencto      = TODAY
            /*** TRATAMENTO 2.03 ***/
            &IF "{&FC_OBJETIVO_GE}" = "YES" &THEN 
            AND {&TABLE-NAME}.cod-maquina-origem = pMaquina
            &ENDIF
            NO-WAIT NO-ERROR.

        IF NOT LOCKED {&TABLE-NAME} THEN DO:
            IF  NOT AVAIL {&TABLE-NAME} THEN DO:
                CREATE  {&TABLE-NAME}.
                ASSIGN  {&TABLE-NAME}.ep-codigo      = pEpCodigo
                        &IF  "{&mgadm_version}" >= "2.04" &THEN
                        {&TABLE-NAME}.cod-tipo-movto = pDesValor
                        &ELSE            
                        {&TABLE-NAME}.cod-gr-forn    = (99 * -1)
                        &ENDIF
                        {&TABLE-NAME}.cod-estabel    = pDesValor
                        {&TABLE-NAME}.dt-vencto   = TODAY
                        /*** TRATAMENTO 2.03 ***/
                        &IF "{&FC_OBJETIVO_GE}" = "YES" &THEN 
                        {&TABLE-NAME}.cod-maquina-origem = pMaquina              
                        &ENDIF.
            END.
            CASE pDesValor:
                WHEN "AMP" THEN    /* Atualiza Atraso Medio Pagamento */
                    ASSIGN {&TABLE-NAME}.vl-desconto = pValor.
                WHEN "PMP":U THEN  /* Atualiza Prazo Medio Pagamento */
                    ASSIGN {&TABLE-NAME}.vl-previsao = pValor.
            END CASE.
        END.
    END.
END.

