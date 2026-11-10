&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN748 2.00.00.006 } /*** "010006" 01/12/2023 10:51:03  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin748 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN748
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName unid-negoc-depos
&GLOBAL-DEFINE TableLabel Unidade Negocio Deposito
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
{inbo/boin748.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


DEFINE VARIABLE c-item-ini  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-item-fim  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-estab-ini AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-estab-fim AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-depos-ini AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-depos-fim AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-unid-ini  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-unid-fim  AS CHARACTER  NO-UNDO.

DEFINE VARIABLE h-boin745   AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-cdapi024  AS HANDLE     NO-UNDO.

DEF TEMP-TABLE tt-erro-aux NO-UNDO
    FIELD i-sequenc AS INT
    FIELD cd-erro   AS INT
    FIELD mensagem  AS CHAR FORMAT "x(255)".

{inbo/boin745.i1} /*** tt-item-un-negoc ***/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 10.04
         WIDTH              = 43.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN atualizarUnidNegoc IN THIS-PROCEDURE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN atualizarUnidNegoc IN THIS-PROCEDURE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN atualizarUnidNegoc IN THIS-PROCEDURE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizarUnidNegoc DBOProgram 
PROCEDURE atualizarUnidNegoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-item-un-negoc.

    CREATE tt-item-un-negoc.
    ASSIGN tt-item-un-negoc.it-codigo   = rowObject.it-codigo
           tt-item-un-negoc.cod-estabel = rowObject.cod-estab
           tt-item-un-negoc.cod-depos   = rowObject.cod-depos.

    IF  NOT VALID-HANDLE(h-boin745) THEN
        RUN inbo/boin745.p PERSISTENT SET h-boin745.

    RUN acertaUnidNegoc IN h-boin745 (INPUT TABLE tt-item-un-negoc).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroy DBOProgram 
PROCEDURE beforeDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  VALID-HANDLE(h-boin745) THEN
        RUN destroy IN h-boin745.

    ASSIGN h-boin745 = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice undngcdp-id
  Parameters:  
               retorna valor do campo it-codigo
               retorna valor do campo cod-estab
               retorna valor do campo cod-depos
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE unid-negoc-depos.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estab LIKE unid-negoc-depos.cod-estab NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-depos LIKE unid-negoc-depos.cod-depos NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pcod-estab = RowObject.cod-estab
           pcod-depos = RowObject.cod-depos.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice undngcdp-id
  Parameters:  
               recebe valor do campo it-codigo
               recebe valor do campo cod-estab
               recebe valor do campo cod-depos
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE unid-negoc-depos.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estab LIKE unid-negoc-depos.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-depos LIKE unid-negoc-depos.cod-depos NO-UNDO.

    FIND FIRST bfunid-negoc-depos WHERE 
        bfunid-negoc-depos.it-codigo = pit-codigo AND 
        bfunid-negoc-depos.cod-estab = pcod-estab AND 
        bfunid-negoc-depos.cod-depos = pcod-depos NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfunid-negoc-depos THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfunid-negoc-depos)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaDepos DBOProgram 
PROCEDURE openQueryFaixaDepos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&queryname} FOR EACH {&tablename} USE-INDEX undngcdp-id NO-LOCK 
        WHERE {&tablename}.it-codigo      >= c-item-ini
          AND {&tablename}.it-codigo      <= c-item-fim
          AND {&tablename}.cod-estab      >= c-estab-ini
          AND {&tablename}.cod-estab      <= c-estab-fim
          AND {&tablename}.cod-depos      >= c-depos-ini
          AND {&tablename}.cod-depos      <= c-depos-fim
          AND {&tablename}.cod-unid-negoc >= c-unid-ini
          AND {&tablename}.cod-unid-negoc <= c-unid-fim
        BY {&tablename}.cod-depos INDEXED-REPOSITION.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaEstab DBOProgram 
PROCEDURE openQueryFaixaEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&queryname} FOR EACH {&tablename} USE-INDEX undngcdp-id NO-LOCK 
        WHERE {&tablename}.it-codigo      >= c-item-ini
          AND {&tablename}.it-codigo      <= c-item-fim
          AND {&tablename}.cod-estab      >= c-estab-ini
          AND {&tablename}.cod-estab      <= c-estab-fim
          AND {&tablename}.cod-depos      >= c-depos-ini
          AND {&tablename}.cod-depos      <= c-depos-fim
          AND {&tablename}.cod-unid-negoc >= c-unid-ini
          AND {&tablename}.cod-unid-negoc <= c-unid-fim
        BY {&tablename}.cod-estab INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaItem DBOProgram 
PROCEDURE openQueryFaixaItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&queryname} FOR EACH {&tablename} USE-INDEX undngcdp-id NO-LOCK 
        WHERE {&tablename}.it-codigo      >= c-item-ini
          AND {&tablename}.it-codigo      <= c-item-fim
          AND {&tablename}.cod-estab      >= c-estab-ini
          AND {&tablename}.cod-estab      <= c-estab-fim
          AND {&tablename}.cod-depos      >= c-depos-ini
          AND {&tablename}.cod-depos      <= c-depos-fim
          AND {&tablename}.cod-unid-negoc >= c-unid-ini
          AND {&tablename}.cod-unid-negoc <= c-unid-fim
        BY {&tablename}.it-codigo INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaUnidadeNegocio DBOProgram 
PROCEDURE openQueryFaixaUnidadeNegocio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&queryname} FOR EACH {&tablename} USE-INDEX undngcdp-id NO-LOCK 
        WHERE {&tablename}.it-codigo      >= c-item-ini
          AND {&tablename}.it-codigo      <= c-item-fim
          AND {&tablename}.cod-estab      >= c-estab-ini
          AND {&tablename}.cod-estab      <= c-estab-fim
          AND {&tablename}.cod-depos      >= c-depos-ini
          AND {&tablename}.cod-depos      <= c-depos-fim
          AND {&tablename}.cod-unid-negoc >= c-unid-ini
          AND {&tablename}.cod-unid-negoc <= c-unid-fim
        BY {&tablename}.cod-unid-negoc INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixa DBOProgram 
PROCEDURE setConstraintFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-item-ini  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-item-fim  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-estab-ini AS CHAR NO-UNDO.
    DEF INPUT PARAM p-estab-fim AS CHAR NO-UNDO.
    DEF INPUT PARAM p-depos-ini AS CHAR NO-UNDO.
    DEF INPUT PARAM p-depos-fim AS CHAR NO-UNDO.
    DEF INPUT PARAM p-unid-ini  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-unid-fim  AS CHAR NO-UNDO.

    ASSIGN c-item-ini  = p-item-ini 
           c-item-fim  = p-item-fim 
           c-estab-ini = p-estab-ini
           c-estab-fim = p-estab-fim
           c-depos-ini = p-depos-ini
           c-depos-fim = p-depos-fim
           c-unid-ini  = p-unid-ini 
           c-unid-fim  = p-unid-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    IF  pType = 'CREATE' THEN DO:
        IF  CAN-FIND (FIRST unid-negoc-depos
                      WHERE unid-negoc-depos.it-codigo = rowObject.it-codigo 
                        AND unid-negoc-depos.cod-estab = rowObject.cod-estab
                        AND unid-negoc-depos.cod-depos = rowObject.cod-depos) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind unid-negoc-depos 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="7"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
    END.
    IF  pType = "create" OR pType = "update" THEN DO:
        IF  NOT CAN-FIND(FIRST ITEM WHERE ITEM.it-codigo = rowObject.it-codigo) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind item 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.

        IF  NOT CAN-FIND(FIRST estabelec WHERE estabelec.cod-estabel = rowObject.cod-estab) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgadm estabelec 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.

        IF  NOT CAN-FIND(FIRST item-uni-estab
                         WHERE item-uni-estab.it-codigo   = rowObject.it-codigo
                           AND item-uni-estab.cod-estabel = rowObject.cod-estab) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item-por-estabelecimento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_por_Estabelecimento" *}
            ASSIGN c-lbl-liter-item-por-estabelecimento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters= "c-lbl-liter-item-por-estabelecimento"}
        END.

        IF  NOT CAN-FIND(FIRST deposito WHERE deposito.cod-depos = rowObject.cod-depos) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind deposito 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.

        IF  NOT CAN-FIND(FIRST unid-negoc WHERE unid-negoc.cod-unid-negoc = rowObject.cod-unid-negoc) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind unid-negoc 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
        ELSE DO:
            IF  NOT VALID-HANDLE(h-cdapi024) THEN
                RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.
            
            IF  VALID-HANDLE(h-cdapi024) THEN DO:
                EMPTY TEMP-TABLE tt-erro-aux.
                
                /* UN x Estabel */
                RUN ValidaUnidadeNegocioEstabel IN h-cdapi024 (INPUT RowObject.cod-estab,
                                                               INPUT TODAY,
                                                               INPUT RowObject.cod-unid-negoc,
                                                               OUTPUT TABLE tt-erro-aux).
                IF  CAN-FIND(FIRST tt-erro-aux) THEN DO:
                    FOR EACH tt-erro-aux:
                                CREATE RowErrors.
                                ASSIGN RowErrors.ErrorNumber      = tt-erro-aux.cd-erro
                                       RowErrors.ErrorType        = "EMS":U
                                       RowErrors.ErrorSubType     = "ERROR":U
                                       RowErrors.ErrorDescription = tt-erro-aux.mensagem
                                       RowErrors.ErrorHelp        = tt-erro-aux.mensagem.
                            END.
                END.
                
                RUN pi-finalizar IN h-cdapi024.
                ASSIGN h-cdapi024 = ?.
            END.
        END.
    END.


    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
