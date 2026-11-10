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
{include/i-prgvrs.i BOIN358 2.00.00.029 } /*** "010029" 24/11/2023 13:25:22  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin358 MUT}
&ENDIF


/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName proc-compra
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName proc-compra
&GLOBAL-DEFINE TableLabel proc-compra
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE KeyField1 nr-processo /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES 

{cdp/cdcfgren.i} /* pre-processor indices grendene - nao remover */
{cdp/cdcfgmat.i} 

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin358.i RowObject}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var inr-proc-ini   as int  no-undo.
def var inr-proc-fim   as int  no-undo initial "999,999".
def var cdesc-proc-ini as char no-undo.
def var cdesc-proc-fim as char no-undo initial "ZZZZZZZZZZZZZZZZZZZZZZZZ".
def var ccod-comprado-ini as char no-undo.
def var ccod-comprado-fim as char no-undo initial "ZZZZZZZZZZZZ".
def var ccomp-ini as char no-undo.
def var ccomp-fim as char no-undo initial "ZZZZZZZZZZZZ".
DEF VAR i-edital  AS INT NO-UNDO.
DEF VAR c-cod-edital AS CHAR NO-UNDO.
DEF VAR i-cdn-format-edital AS INT NO-UNDO.
DEF VAR l-proces-pregao AS LOG NO-UNDO.
DEF VAR l-usuar-pregao AS LOG NO-UNDO.
DEF VAR c-cod-edital-aux AS CHAR NO-UNDO.
DEF VAR i-cdn-format-edital-aux AS INT NO-UNDO.
DEF VAR l-proces-pregao-aux AS LOG NO-UNDO.
DEF VAR l-erro-pregao AS LOG NO-UNDO.

/** * Defini‡äes Multi-Planta * **/
def var i-tipo-movto as integer no-undo.

{mpp/mpapi011.i}
{cdp/cd7300.i1}
{cdp/cd0669.i}
{utp/ut-glob.i}

/** * Fim Defini‡äes Multi-Planta * **/

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 18.88
         WIDTH              = 27.72.
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


FIND FIRST param-global NO-LOCK NO-ERROR.

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

    assign i-tipo-movto = 1. /* utilizado na procedure pi-cria-processo-mat059 para 
                                    informar quando ‚ create(1), update(2). ou delete(3)*/

    run pi-cria-processo-mat059.

    return "OK":U.

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

    assign i-tipo-movto = 2. /* utilizado na procedure pi-cria-processo-mat059 para 
                                    informar quando ‚ create(1), update(2). ou delete(3)*/

    run pi-cria-processo-mat059.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h1 AS INTEGER NO-UNDO.
    DEFINE VARIABLE l-avail AS LOGICAL INIT NO   NO-UNDO.
    
    &IF ("{&mgind_dbtype}" <> "PROGRESS") &THEN
        RUN STORED-PROCEDURE mgind.send-sql-statement h1 = PROC-HANDLE
            ("SELECT proc_compra.nr_processo FROM proc_compra WHERE proc_compra.nr_processo = " + STRING(rowObject.nr-processo)).
        FOR EACH mgind.proc-text-buffer WHERE PROC-HANDLE = h1:
            l-avail = YES.
        END.
        IF l-avail THEN DO:
            rowObject.nr-processo = rowObject.nr-processo + 1.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-processo-compra AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Processo_Compra" *}
            ASSIGN c-lbl-liter-processo-compra = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="1"
                       &ErrorType="EMS":U
                       &ErrorSubType="ERROR":U
                       &ErrorParameters="c-lbl-liter-processo-compra"}
        END.
        CLOSE STORED-PROCEDURE mgind.send-sql-statement WHERE PROC-HANDLE = h1.
      
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.
    &ENDIF
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  assign i-tipo-movto = 3. /* utilizado na procedure pi-cria-processo-mat059 para 
                                informar quando ‚ create(1), update(2). ou delete(3)*/

  run pi-cria-processo-mat059.

  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-processo LIKE proc-compra.nr-processo NO-UNDO.
    def output parameter pcreturn       as char no-undo.
    RUN openQueryStatic (input "main":U).
    run goToKey (input pnr-processo).

    if return-value = "OK" then assign pcreturn = "".
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value. 
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findComprador DBOProgram 
PROCEDURE findComprador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pnr-processo LIKE proc-compra.nr-processo NO-UNDO.
DEFINE INPUT PARAMETER pcod-comprado LIKE proc-compra.cod-comprado NO-UNDO.
DEFINE OUTPUT PARAMETER pcreturn as char no-undo.
    RUN openQueryStatic (input "main":U).
    run goToKeyComprador (input pnr-processo,
                                pcod-comprado).

    if return-value = "OK" then assign pcreturn = "".  
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value. 
    end.
    
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "cod-edital":U THEN ASSIGN pFieldValue = &IF "{&bf_mat_versao_ems}" < "2.07" &THEN
                                                        SUBSTRING(rowObject.char-2,1,100).
                                                      &ELSE
                                                        rowObject.cod-edital.
                                                      &ENDIF
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-inicio":U THEN ASSIGN pFieldValue = RowObject.dt-inicio.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "nr-processo":U THEN ASSIGN pFieldValue = RowObject.nr-processo.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "cdn-format-edital":U THEN ASSIGN pFieldValue = &IF "{&bf_mat_versao_ems}" < "2.07" &THEN
                                                                INT(SUBSTRING(rowObject.char-1,5,5)).
                                                             &ELSE
                                                                rowObject.cdn-format-edital.
                                                             &ENDIF
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice CODIGO
  Parameters:
               retorna valor dos campos do ¡ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-processo LIKE proc-compra.nr-processo NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnr-processo = RowObject.nr-processo.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-proces-pregao":U THEN ASSIGN pFieldValue = &IF "{&bf_mat_versao_ems}" < "2.07" &THEN
                                                                IF INT(SUBSTRING(rowObject.char-1,4,1)) = 1 THEN YES
                                                                                                            ELSE NO.
                                                             &ELSE
                                                                rowObject.log-proces-pregao.
                                                             &ENDIF
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
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
  Purpose:     Reposiciona registro com base no ¡ndice CODIGO
  Parameters:
               recebe valor dos campos do ¡ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-processo LIKE proc-compra.nr-processo NO-UNDO.

    FIND FIRST bfproc-compra WHERE
        bfproc-compra.nr-processo = pnr-processo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproc-compra THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproc-compra)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyComprador DBOProgram 
PROCEDURE goToKeyComprador :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no Öndice COMPRADOR
  Parameters:
               recebe valor dos campos do Öndice COMPRADOR
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pnr-processo LIKE proc-compra.nr-processo NO-UNDO.
DEFINE INPUT PARAMETER pcod-comprado LIKE proc-compra.cod-comprado NO-UNDO.

    FIND FIRST bfproc-compra WHERE
        bfproc-compra.nr-processo = pnr-processo AND
        bfproc-compra.cod-comprado = pcod-comprado
        NO-LOCK NO-ERROR.

    /*--- Verifica se o registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproc-compra THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproc-compra)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then do:
           run openQueryStatic (input "main":U).
        end.   
        when 2 then do:
           run openQueryStatic (input "byNrProcesso":U).
        end.
        when 3 then do:
           run openQueryStatic (input "byDescricao":U).
        end.
        when 4 then do:
           run openQueryStatic (input "byCodComprado":U).
        end.
        when 5 then do:
           run openQueryStatic (input "byNrProcesso":U).
        end.
    end. /*end case*/
   RETURN "OK":U.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybyCodComprado DBOProgram 
PROCEDURE openQuerybyCodComprado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        if ccod-comprado-ini <> ccod-comprado-fim then do:
            open query {&QueryName} for each {&TableName} no-lock where
                                              {&TableName}.cod-comprado    >= ccod-comprado-ini and
                                              {&TableName}.cod-comprado    <= ccod-comprado-fim 
                                              by  {&TableName}.cod-comprado INDEXED-REPOSITION.
        end.
        else do:                                   
            open query {&QueryName} for each {&TableName} no-lock where
                                              {&TableName}.cod-comprado    = ccod-comprado-ini 
                                              by  {&TableName}.cod-comprado INDEXED-REPOSITION.
        end.                                              

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybyDescricao DBOProgram 
PROCEDURE openQuerybyDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        if cdesc-proc-ini <> cdesc-proc-fim then do:
            open query {&QueryName} for each {&TableName} no-lock where
                                              {&TableName}.descricao    >= cdesc-proc-ini and
                                              {&TableName}.descricao    <= cdesc-proc-fim 
                                              by  {&TableName}.descricao INDEXED-REPOSITION.
        end.
        else do:                                   
            open query {&QueryName} for each {&TableName} no-lock where
                                              {&TableName}.descricao    = cdesc-proc-ini 
                                              by  {&TableName}.descricao INDEXED-REPOSITION.
        end.                                              

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybyNrProcesso DBOProgram 
PROCEDURE openQuerybyNrProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


   IF inr-proc-ini = inr-proc-fim THEN DO:
            open query {&QueryName} for each {&TableName} no-lock where
                                              {&TableName}.nr-processo  = inr-proc-ini 
                                              by  {&TableName}.nr-processo INDEXED-REPOSITION.

   END.
   ELSE DO:
        IF ccod-comprado-ini = ccod-comprado-fim THEN DO:
                 open query {&QueryName} for each {&TableName} no-lock where
                                                   {&TableName}.cod-comprado  = ccod-comprado-ini 
                                                   by  {&TableName}.nr-processo INDEXED-REPOSITION.
     
        END.
        ELSE DO:                                   
                 open query {&QueryName} for each {&TableName} no-lock where
                                                   {&TableName}.nr-processo  >= inr-proc-ini   and
                                                   {&TableName}.nr-processo  <= inr-proc-fim   and
                                                   {&TableName}.cod-comprado >= ccod-comprado-ini and
                                                   {&TableName}.cod-comprado <= ccod-comprado-fim
                                                   by  {&TableName}.nr-processo INDEXED-REPOSITION.
        END. 
   END.                   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryComprador DBOProgram 
PROCEDURE openQueryComprador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
         open query {&QueryName} for each {&TableName} no-lock where
                                           {&TableName}.cod-comprado >= ccod-comprado-ini and
                                           {&TableName}.cod-comprado <= ccod-comprado-fim and
                                           {&TableName}.nr-processo  >= inr-proc-ini   and
                                           {&TableName}.nr-processo  <= inr-proc-fim   and
                                           {&TableName}.descricao    >= cdesc-proc-ini and
                                           {&TableName}.descricao    <= cdesc-proc-fim 
                                           by  {&TableName}.cod-comprado INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDescricao DBOProgram 
PROCEDURE openQueryDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
         open query {&QueryName} for each {&TableName} no-lock where
                                           {&TableName}.descricao    >= cdesc-proc-ini and
                                           {&TableName}.descricao    <= cdesc-proc-fim and
                                           {&TableName}.cod-comprado >= ccod-comprado-ini and
                                           {&TableName}.cod-comprado <= ccod-comprado-fim and
                                           {&TableName}.nr-processo  >= inr-proc-ini   and
                                           {&TableName}.nr-processo  <= inr-proc-fim 
                                       &IF DEFINED(CUSTOM_GRENDENE) &THEN
                                           use-index desc-proc
                                       &ELSE
                                           by  {&TableName}.descricao 
                                       &ENDIF
                                       INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH proc-compra NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNrProcesso DBOProgram 
PROCEDURE openQueryNrProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
         open query {&QueryName} for each {&TableName} no-lock where
                                           {&TableName}.nr-processo  >= inr-proc-ini   and
                                           {&TableName}.nr-processo  <= inr-proc-fim   and
                                           {&TableName}.cod-comprado >= ccod-comprado-ini and
                                           {&TableName}.cod-comprado <= ccod-comprado-fim and
                                           {&TableName}.descricao    >= cdesc-proc-ini and
                                           {&TableName}.descricao    <= cdesc-proc-fim 
                                           by  {&TableName}.nr-processo INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-processo-mat059 DBOProgram 
PROCEDURE pi-cria-processo-mat059 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /*********** Multi-Planta **************/

       assign c-transacao = "MAT059".
       if  param-global.modulo-mp then do:   
           run cdp/cdapi150.p (input "proc-compra",
                               input rowid(proc-compra),
                               input i-tipo-movto,
                               input c-transacao,
                               input-output table tt-erro).    
           assign c-estabel-dest = " ".                                     
       end.

    /********** Fim Multi-Planta ***********/                                   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recebeCompradorInicialFinal DBOProgram 
PROCEDURE recebeCompradorInicialFinal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*recebe como parƒmetros o comprador inicial e final que fazem parte de uma faixa e serÆo utilizados na
 validateRecord, pois s¢ poderÆo ser cadastrados processos que fazem parte da faixa selecionada pelo usu rio.      
      Parƒmetros:
         ipar1 : pcomprador-ini : c¢digo do comprador inicial escolhido na tela de parƒmetros 
         ipar2 : pcomprador-fim : c¢digo do comprador final   escolhido na tela de parƒmetros*/
      
    def input param pcomprador-ini as char no-undo.
    def input param pcomprador-fim as char no-undo.
    
    assign ccomp-ini = pcomprador-ini
           ccomp-fim = pcomprador-fim.
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pnum-proc-ini as char no-undo.
    def input param pnum-proc-fim as char no-undo.
    def input param pdesc-ini as char no-undo.
    def input param pdesc-fim as char no-undo.
    def input param pcomprador-ini as char no-undo.
    def input param pcomprador-fim as char no-undo.
     
    run setconstraintbyNrProcesso (input string(pnum-proc-ini),
                                         string(pnum-proc-fim)).
    run setconstraintbyDescricao (input pdesc-ini,
                                        pdesc-fim).
    run setconstraintbyCodComprado (input pcomprador-ini, 
                                          pcomprador-fim).
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcomprador-ini as char no-undo.
    def input param pcomprador-fim as char no-undo.
     
    run setconstraintbyCodComprado (input pcomprador-ini, 
                                          pcomprador-fim).
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintbyCodComprado DBOProgram 
PROCEDURE setConstraintbyCodComprado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcod-comprado-ini as char no-undo.
    def input param pcod-comprado-fim as char no-undo.
     
    assign ccod-comprado-ini = pcod-comprado-ini
           ccod-comprado-fim = pcod-comprado-fim.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintbyDescricao DBOProgram 
PROCEDURE setConstraintbyDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pdesc-proc-ini as char no-undo.
    def input param pdesc-proc-fim as char no-undo.
     
    assign cdesc-proc-ini = pdesc-proc-ini
           cdesc-proc-fim = pdesc-proc-fim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintbyNrProcesso DBOProgram 
PROCEDURE setConstraintbyNrProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pnr-proc-ini   as int no-undo.
    def input param pnr-proc-fim   as int no-undo.
     
    assign inr-proc-ini   = pnr-proc-ini
           inr-proc-fim   = pnr-proc-fim.
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaults DBOProgram 
PROCEDURE setDefaults :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Seta automaticamente o proximo numero do processo 
       na inclusao de um processo.
       Parametros:
       ipar1 : pnumero-proc : proximo numero do processo.
    */   

    def output parameter pnumero-proc like proc-compra.nr-processo.
      
    find first param-compra no-lock no-error.
    find last proc-compra no-lock no-error.
    if  avail proc-compra then do:
       assign pnumero-proc = proc-compra.nr-processo + 1.
       repeat: /* para execucao em multi-usuario. */
            find bfproc-compra where bfproc-compra.nr-processo = pnumero-proc
                no-lock no-error.
            if avail bfproc-compra then do:
                assign pnumero-proc = pnumero-proc + 1.
            end.
            else leave.
       end.
    end.
    /*Quando nÆo existir processo de compra seta o numero do processo para 1*/
    IF pnumero-proc = 0 THEN
        ASSIGN pnumero-proc = 1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaOrdemCompra DBOProgram 
PROCEDURE ValidaOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  i-nr-processo - Numero do processo
               l-ordem-compra - Parametro de retorno logico, caso exista alguma ordem com nr-processa j  enviada ao poral
  Notes: Retorna yes se encontrar alguma ordem com processo que esteja enviado ao portal Paradigma
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM i-nr-processo AS INT NO-UNDO.
    DEF OUTPUT PARAM l-ordem-compra AS LOG NO-UNDO.

    ASSIGN l-ordem-compra = NO.

    FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.nr-processo = i-nr-processo
           AND 
           
           &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
               substring(ordem-compra.char-1,193,1) = "S":U
           &ELSE
               ordem-compra.log-envdo-integr 
           &ENDIF
           
           NO-ERROR.
    IF AVAIL ordem-compra THEN
        ASSIGN l-ordem-compra = YES.
    ELSE
        ASSIGN l-ordem-compra = NO.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaPregaoEletronico DBOProgram 
PROCEDURE ValidaPregaoEletronico :
/*------------------------------------------------------------------------------
  Purpose: Procedure criada para implementar a valida‡Æo de Pregao Eletronico
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN 

        DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
        &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
            ASSIGN l-proces-pregao     = RowObject.log-proces-pregao
                   i-cdn-format-edital = RowObject.cdn-format-edital
                   c-cod-edital        = RowObject.cod-edital.
        &ELSE
            IF SUBSTRING(RowObject.char-1,4,1) = "1" THEN
                ASSIGN l-proces-pregao = YES.
            ELSE 
                ASSIGN l-proces-pregao = NO.
            
            ASSIGN i-cdn-format-edital = int(SUBSTRING(RowObject.char-1,5,5))
                   c-cod-edital        = RowObject.char-2.
        &ENDIF
        
        IF l-proces-pregao THEN DO:
            /** Testa formato 9999/9999-XXXXXXXXXX **/        
            IF i-cdn-format-edital = 1 THEN DO:
                /** Testa 9999 **/
                ASSIGN i-edital = INT(SUBSTRING(c-cod-edital,1,4)) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-edital AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Edital" *}
                    ASSIGN c-lbl-liter-edital = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-pela-bbm AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "pela_BBM" *}
                    ASSIGN c-lbl-liter-pela-bbm = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-pela-bbm-posicao-1-a-4-deve AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "pela_BBM_-_posi‡Æo_1_a_4_deve_ser_inteiro" *}
                    ASSIGN c-lbl-liter-pela-bbm-posicao-1-a-4-deve = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="32702"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="Information":U
                                                &ErrorParameters="c-lbl-liter-edital + '~~~~' + c-lbl-liter-pela-bbm + '~~~~' + c-lbl-liter-pela-bbm-posicao-1-a-4-deve"}
                END.
                ELSE DO:
                    /** Testa / **/
                    IF SUBSTRING(c-cod-edital,5,1) <> "/" THEN DO:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-edital-2 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Edital" *}
                        ASSIGN c-lbl-liter-edital-2 = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-pela-bbm-2 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "pela_BBM" *}
                        ASSIGN c-lbl-liter-pela-bbm-2 = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-pela-bbm-posicao-5-deve-ser AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "pela_BBM_-_posi‡Æo_5_deve_ser_/" *}
                        ASSIGN c-lbl-liter-pela-bbm-posicao-5-deve-ser = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="32702"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="Information":U
                                                    &ErrorParameters="c-lbl-liter-edital-2 + '~~~~' + c-lbl-liter-pela-bbm-2 + '~~~~' + c-lbl-liter-pela-bbm-posicao-5-deve-ser"}
                    END.
                    ELSE DO:
                        /** Testa 9999 **/
                        ASSIGN i-edital = INT(SUBSTRING(c-cod-edital,6,4)) NO-ERROR.
                        IF ERROR-STATUS:ERROR THEN DO:
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-edital-3 AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Edital" *}
                            ASSIGN c-lbl-liter-edital-3 = TRIM(RETURN-VALUE).
                            DEFINE VARIABLE c-lbl-liter-pela-bbm-3 AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "pela_BBM" *}
                            ASSIGN c-lbl-liter-pela-bbm-3 = TRIM(RETURN-VALUE).
                            DEFINE VARIABLE c-lbl-liter-pela-bbm-posicao-6-a-9-deve AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "pela_BBM_-_posi‡Æo_6_a_9_deve_ser_inteiro" *}
                            ASSIGN c-lbl-liter-pela-bbm-posicao-6-a-9-deve = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i &ErrorNumber="32702"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="Information":U
                                                        &ErrorParameters="c-lbl-liter-edital-3 + '~~~~' + c-lbl-liter-pela-bbm-3 + '~~~~' + c-lbl-liter-pela-bbm-posicao-6-a-9-deve"}
                        END.
                        ELSE DO:
                            /** Testa - **/
                            IF SUBSTRING(c-cod-edital,10,1) <> "-" THEN DO:
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-edital-4 AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Edital" *}
                                ASSIGN c-lbl-liter-edital-4 = TRIM(RETURN-VALUE).
                                DEFINE VARIABLE c-lbl-liter-pela-bbm-4 AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "pela_BBM" *}
                                ASSIGN c-lbl-liter-pela-bbm-4 = TRIM(RETURN-VALUE).
                                DEFINE VARIABLE c-lbl-liter-pela-bbm-posicao-10-deve-ser AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "pela_BBM_-_posi‡Æo_10_deve_ser" *}
                                ASSIGN c-lbl-liter-pela-bbm-posicao-10-deve-ser = TRIM(RETURN-VALUE).
                                {method/svc/errors/inserr.i &ErrorNumber="32702"
                                                            &ErrorType="EMS":U
                                                            &ErrorSubType="Information":U
                                                            &ErrorParameters="c-lbl-liter-edital-4 + '~~~~' + c-lbl-liter-pela-bbm-4 + '~~~~' + c-lbl-liter-pela-bbm-posicao-10-deve-ser + ' -'"}
                            END.
                            ELSE DO:
                                /** Testa XXXXXXXXXX **/
                                IF LENGTH(c-cod-edital) > 20 THEN DO:
                                    /* Inicio -- Projeto Internacional */
                                    DEFINE VARIABLE c-lbl-liter-edital-5 AS CHARACTER NO-UNDO.
                                    {utp/ut-liter.i "Edital" *}
                                    ASSIGN c-lbl-liter-edital-5 = TRIM(RETURN-VALUE).
                                    DEFINE VARIABLE c-lbl-liter-pela-bbm-5 AS CHARACTER NO-UNDO.
                                    {utp/ut-liter.i "pela_BBM" *}
                                    ASSIGN c-lbl-liter-pela-bbm-5 = TRIM(RETURN-VALUE).
                                    DEFINE VARIABLE c-lbl-liter-pela-bbm-maximo-20-caractere AS CHARACTER NO-UNDO.
                                    {utp/ut-liter.i "pela_BBM_-_m ximo_20_caracteres" *}
                                    ASSIGN c-lbl-liter-pela-bbm-maximo-20-caractere = TRIM(RETURN-VALUE).
                                    {method/svc/errors/inserr.i &ErrorNumber="32702"
                                                                &ErrorType="EMS":U
                                                                &ErrorSubType="Information":U
                                                                &ErrorParameters="c-lbl-liter-edital-5 + '~~~~' + c-lbl-liter-pela-bbm-5 + '~~~~' + c-lbl-liter-pela-bbm-maximo-20-caractere"}
                                END.
                            END.
                        END.
                    END.
                END.
    
                IF NOT CAN-FIND(FIRST RowErrors WHERE
                                RowErrors.ErrorNumber = 32702) THEN DO:
                    IF INT(SUBSTRING(c-cod-edital,6,4)) <> YEAR(TODAY) THEN DO:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-edital-6 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Edital" *}
                        ASSIGN c-lbl-liter-edital-6 = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-bbm AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "BBM" *}
                        ASSIGN c-lbl-liter-bbm = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-pela-bbm-segundo-grupo-9999 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "pela_BBM_-_segundo_grupo_9999_dever_ser_o_ano_corrente" *}
                        ASSIGN c-lbl-liter-pela-bbm-segundo-grupo-9999 = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="32702"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="Information":U
                                                    &ErrorParameters="c-lbl-liter-edital-6 + '~~~~' + c-lbl-liter-bbm + '~~~~' + c-lbl-liter-pela-bbm-segundo-grupo-9999"}
                    END.
                END.
            END.
            /****/

            if pType = "Create" or 
               pType = "Update" then do:

                FIND FIRST usuar-mater NO-LOCK
                     WHERE usuar-mater.cod-usuario = rowObject.cod-comprado NO-ERROR.
                IF AVAIL usuar-mater THEN DO:
                    &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
                        ASSIGN l-usuar-pregao = usuar-mater.log-usuar-pregao.
                    &ELSEIF "{&bf_mat_versao_ems}" >= "2.062" &then 
                        IF SUBSTRING(usuar-mater.char-1,13,1) = "1" THEN
                            ASSIGN l-usuar-pregao = YES.
                        ELSE 
                            ASSIGN l-usuar-pregao = NO.
                    &ENDIF
    
                    IF NOT l-usuar-pregao THEN DO:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-pregoeiro AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "pregoeiro" *}
                        ASSIGN c-lbl-liter-pregoeiro = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-incluirmodificar-este-registro AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "incluir/modificar_este_registro" *}
                        ASSIGN c-lbl-liter-incluirmodificar-este-registro = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="33085"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="Error":U
                                                    &ErrorParameters="usuar-mater.cod-usuario + '~~~~' + c-lbl-liter-pregoeiro + '~~~~' + c-lbl-liter-incluirmodificar-este-registro"}
                        RETURN "NOK":U.
                    END.
                END.
    
                FIND FIRST usuar-mater NO-LOCK
                     WHERE usuar-mater.cod-usuario = c-seg-usuario NO-ERROR.
                IF AVAIL usuar-mater THEN DO:
                    &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
                        ASSIGN l-usuar-pregao = usuar-mater.log-usuar-pregao.
                    &ELSEIF "{&bf_mat_versao_ems}" >= "2.062" &then 
                        IF SUBSTRING(usuar-mater.char-1,13,1) = "1" THEN
                            ASSIGN l-usuar-pregao = YES.
                        ELSE 
                            ASSIGN l-usuar-pregao = NO.
                    &ENDIF
    
                    IF NOT l-usuar-pregao THEN DO:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-pregoeiro-2 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "pregoeiro" *}
                        ASSIGN c-lbl-liter-pregoeiro-2 = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-incluirmodificar-este-registro-2 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "incluir/modificar_este_registro" *}
                        ASSIGN c-lbl-liter-incluirmodificar-este-registro-2 = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="33085"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="Error":U
                                                    &ErrorParameters="usuar-mater.cod-usuario + '~~~~' + c-lbl-liter-pregoeiro-2 + '~~~~' + c-lbl-liter-incluirmodificar-este-registro-2"}
                        RETURN "NOK":U.
                    END.
                END.

                IF l-proces-pregao AND i-cdn-format-edital = 1 AND RowObject.narrativa = "" THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-narrativa AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Narrativa" *}
                    ASSIGN c-lbl-liter-narrativa = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="265"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="Error":U
                                                &ErrorParameters="c-lbl-liter-narrativa"}
                    RETURN "NOK":U.
                END.

                IF l-proces-pregao THEN DO:
                    FIND FIRST bfproc-compra
                        &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
                            WHERE bfproc-compra.cod-edital  = c-cod-edital
                        &ELSE
                            WHERE bfproc-compra.char-2      = c-cod-edital
                        &ENDIF
                           AND bfproc-compra.nr-processo <> rowObject.nr-processo NO-LOCK NO-ERROR.
                    IF AVAIL bfproc-compra THEN DO:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-codigo-do-edital-ja-informado AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "C¢digo_do_Edital_j _informado_para_outro_processo_de_compras" *}
                        ASSIGN c-lbl-liter-codigo-do-edital-ja-informado = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="Error":U
                                                    &ErrorParameters="c-lbl-liter-codigo-do-edital-ja-informado + '.'"}
                        RETURN "NOK":U.
                    END.
                END.
            end.
        END.
    
        IF pType = "Update" THEN DO:
            ASSIGN l-erro-pregao = NO.
    
            FIND FIRST bfproc-compra WHERE bfproc-compra.nr-processo = RowObject.nr-processo NO-LOCK NO-ERROR.
            IF AVAIL bfproc-compra THEN DO:
                &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
                    ASSIGN l-proces-pregao-aux     = bfproc-compra.log-proces-pregao
                           i-cdn-format-edital-aux = bfproc-compra.cdn-format-edital
                           c-cod-edital-aux        = bfproc-compra.cod-edital.
                &ELSEIF "{&bf_mat_versao_ems}" >= "2.062" &then 
                    IF SUBSTRING(bfproc-compra.char-1,4,1) = "1" THEN
                        ASSIGN l-proces-pregao-aux = YES.
                    ELSE 
                        ASSIGN l-proces-pregao-aux = NO.
                    
                    ASSIGN i-cdn-format-edital-aux = int(SUBSTRING(bfproc-compra.char-1,5,5))
                           c-cod-edital-aux        = SUBSTRING(bfproc-compra.char-2,1,100).
                &ENDIF
                
                IF (l-proces-pregao <> l-proces-pregao-aux OR
                   i-cdn-format-edital <> i-cdn-format-edital-aux OR 
                   c-cod-edital <> c-cod-edital-aux) AND
                   NOT l-erro-pregao THEN DO:
                    FOR EACH ordem-compra NO-LOCK
                        WHERE ordem-compra.nr-processo = RowObject.nr-processo,
                        FIRST cotacao-item NO-LOCK
                        WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                          AND cotacao-item.data-cotacao = ordem-compra.data-cotacao
                          AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                          AND cotacao-item.ind-via-envio = 17:
                        ASSIGN l-erro-pregao = YES.
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-alteracao AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Altera‡Æo" *}
                        ASSIGN c-lbl-liter-alteracao = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-processo AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Processo" *}
                        ASSIGN c-lbl-liter-processo = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-a-uma-ordem-ja-enviada-para-o AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "a_uma_ordem_j _enviada_para_o_EAI/PregÆo_Eletr“nico" *}
                        ASSIGN c-lbl-liter-a-uma-ordem-ja-enviada-para-o = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="27414"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="Error":U
                                                    &ErrorParameters="c-lbl-liter-alteracao + '~~~~' + c-lbl-liter-processo + '~~~~' + c-lbl-liter-a-uma-ordem-ja-enviada-para-o + '.'"}
                        RETURN "NOK":U.
    
                    END.
                END.
            END.
    
        END.
    &ENDIF    
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    find first rowObject no-lock no-error.


    /*--- Utilize o par³metro pType para identificar quais as valida‡„es a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o par³metro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡„es ---*/

    /*--- Verifica ocorrˆncia de erros ---*/
    
    IF pType = "create" THEN DO:
        FIND proc-compra WHERE
             proc-compra.nr-processo = rowObject.nr-processo NO-LOCK NO-ERROR.
        IF AVAIL proc-compra THEN DO:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-processo-cadastrado AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Processo_Cadastrado" *}
             ASSIGN c-lbl-liter-processo-cadastrado = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i &ErrorNumber="15560"
                        &ErrorType="EMS":U
                        &ErrorSubType="ERROR":U
                        &ErrorParameters="c-lbl-liter-processo-cadastrado"}
             return "NOK":U.
        END.
    END.
    
    IF pType = "create" or pType = "update" then do:
    
                def var c-msg  as char no-undo.
                def var c-msg2 as char no-undo.
                
                find comprador where 
                     comprador.cod-comprado = rowObject.cod-comprado
                     no-lock no-error.
                        
                if avail comprador and rowObject.cod-comprado <> "" then do:
                    if (rowObject.cod-comprado < ccomp-ini) or
                       (rowObject.cod-comprado > ccomp-fim) then do:
                    
                        {utp/ut-field.i mgind proc-compra cod-comprado 1}
                        assign c-msg = return-value.
                
                        {utp/ut-liter.i cadastrado,_pois_nÆo_pertence_…_faixa_selecionada.} 
                        assign c-msg2 = trim(return-value).
                        
                        {method/svc/errors/inserr.i &ErrorNumber="7972"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters="c-msg + '~~~~' + c-msg2"}
                        return "NOK":U.
                        
                    end.  
                end.  
                
                if rowObject.cod-comprado = "" then do:
                    
                    /*{utp/ut-field.i mgind {&TABLE-NAME} cod-comprado 1}*/
                    /* comprador inv lido */
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-comprador AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Comprador" *}
                    ASSIGN c-lbl-liter-comprador = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="47"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters="c-lbl-liter-comprador"}
                     return "NOK":U. 
                end.
                    
                if rowObject.cod-comprado <> "" then do:
                    find comprador where 
                         comprador.cod-comprado = rowObject.cod-comprado
                         no-lock no-error.
                    if not avail comprador then do:
                        
                        /*{utp/ut-field.i mgind {&TABLE-NAME} cod-comprado 1}*/
                        /* comprador inv lido */
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-comprador-2 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Comprador" *}
                        ASSIGN c-lbl-liter-comprador-2 = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="47"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters="c-lbl-liter-comprador-2"}
                         return "NOK":U.      
                    end.
                end.
                if rowObject.nr-processo = 0 then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-processo-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Processo" *}
                    ASSIGN c-lbl-liter-processo-2 = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="26246"
                            &ErrorType="EMS":U
                            &ErrorSubType="ERROR":U
                            &ErrorParameters="c-lbl-liter-processo-2"}     
                end.
    
    END.

    IF pType = "delete" then do:
       run verificaRelacoesProcCompra.
    END.
    
    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN 
        IF pType = "create" or pType = "update" then do:
            RUN validaPregaoEletronico (INPUT pType).
        END.
    &ENDIF

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VerificaRelacoesProcCompra DBOProgram 
PROCEDURE VerificaRelacoesProcCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 /*
 Procedure criada para implementar a valida‡Æo: na elimina‡Æo da tabela proc-compra, verificar se 
 esta possui relacionamento com a tabela proc-fornec .
 */

 def var c-msg   as char no-undo. 
 def var c-msg2  as char no-undo. 
 
 find first proc-fornec
      where proc-fornec.nr-processo = proc-compra.nr-processo no-lock no-error.
 if  avail proc-fornec then do:
     {method/svc/errors/inserr.i &ErrorNumber="8029"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters="'{&TableLabel}'"}
 end.
 
 if  can-find(first ordem-compra where ordem-compra.nr-processo = proc-compra.nr-processo) then do:
     assign c-msg = "Processo de Compra".
     assign c-msg2 = "eliminado com ordem(s) vinculada(s)".
    {method/svc/errors/inserr.i &ErrorNumber="7972"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters="c-msg + '~~~~' + c-msg2"}
 end.   

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram  
PROCEDURE openQueryDefault :
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
                                      
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
