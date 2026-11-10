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
{include/i-prgvrs.i BOIN793 2.00.00.015 } /*** "010015" 04/09/2026 21:53:21 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin793 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : BOIN793.P
    Purpose    : L¢gica de neg¢cio e acesso a dados para tabela mla-hierarquia-faixa
    Parameters :
    Notes      :
  ------------------------------------------------------------------------*/


/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName boin793
&GLOBAL-DEFINE DBOVersion
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName mla-hierarquia-faixa
&GLOBAL-DEFINE TableLabel
&GLOBAL-DEFINE QueryName qr{&TableName}


/*:T--- Include com definiá∆o da temptable RowObject ---*/
{inbo/boin793.i RowObject}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
{method/dboqry.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{inbo/boin793.i1} /* Temp-tables utilizadas pelas piSubstituiAprovador */

/*--- Local Variables                                            ---*/
DEFINE VARIABLE c-ep-codigo   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-estabel AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-lotacao AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-log-reg     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE h-boin769     AS HANDLE     NO-UNDO.
DEFINE VARIABLE i-cod-tip-doc AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-num-faixa   AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-seq-aprov   AS INTEGER    NO-UNDO.

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
         HEIGHT             = 1.92
         WIDTH              = 40.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterdestroy DBOProgram
PROCEDURE afterdestroy :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-boin769) THEN DO:
        DELETE PROCEDURE h-boin769.
        ASSIGN h-boin769 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforedeleteRecord DBOProgram
PROCEDURE BeforedeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-boin769) THEN
        RUN inbo/boin769.p PERSISTENT SET h-boin769.

    ASSIGN c-log-reg = ENTRY(5,{ininc/i03in030.i 03}) + CHR(13) + CHR(13) +
                       "Lotaá∆o            : " + STRING(mla-hierarquia-faixa.cod-lotacao) + CHR(13) +
                       "Documento          : " + STRING(mla-hierarquia-faixa.cod-tip-doc) + CHR(13) +
                       "Sequància          : " + STRING(mla-hierarquia-faixa.seq-aprov)   + CHR(13) +
                       "Usu†rio            : " + STRING(mla-hierarquia-faixa.cod-usuar)   + CHR(13) +
                       "Dependància        : " + STRING(mla-hierarquia-faixa.log-depend).

    RUN pi-gera-log IN h-boin769 (INPUT 5, INPUT ROWID(mla-hierarquia-faixa), INPUT 3, c-log-reg).


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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "char-3":U THEN ASSIGN pFieldValue = RowObject.char-3.
        WHEN "char-4":U THEN ASSIGN pFieldValue = RowObject.char-4.
        WHEN "char-5":U THEN ASSIGN pFieldValue = RowObject.char-5.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-lotacao":U THEN ASSIGN pFieldValue = RowObject.cod-lotacao.
        WHEN "cod-usuar":U THEN ASSIGN pFieldValue = RowObject.cod-usuar.
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-3":U THEN ASSIGN pFieldValue = RowObject.data-3.
        WHEN "data-4":U THEN ASSIGN pFieldValue = RowObject.data-4.
        WHEN "data-5":U THEN ASSIGN pFieldValue = RowObject.data-5.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "dec-3":U THEN ASSIGN pFieldValue = RowObject.dec-3.
        WHEN "dec-4":U THEN ASSIGN pFieldValue = RowObject.dec-4.
        WHEN "dec-5":U THEN ASSIGN pFieldValue = RowObject.dec-5.
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
        WHEN "cod-tip-doc":U THEN ASSIGN pFieldValue = RowObject.cod-tip-doc.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "int-3":U THEN ASSIGN pFieldValue = RowObject.int-3.
        WHEN "int-4":U THEN ASSIGN pFieldValue = RowObject.int-4.
        WHEN "int-5":U THEN ASSIGN pFieldValue = RowObject.int-5.
        WHEN "num-faixa":U THEN ASSIGN pFieldValue = RowObject.num-faixa.
        WHEN "seq-aprov":U THEN ASSIGN pFieldValue = RowObject.seq-aprov.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice faixa
  Parameters:
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-lotacao
               retorna valor do campo cod-tip-doc
               retorna valor do campo num-faixa
               retorna valor do campo seq-aprov
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE mla-hierarquia-faixa.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE mla-hierarquia-faixa.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-lotacao LIKE mla-hierarquia-faixa.cod-lotacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tip-doc LIKE mla-hierarquia-faixa.cod-tip-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-faixa LIKE mla-hierarquia-faixa.num-faixa NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-aprov LIKE mla-hierarquia-faixa.seq-aprov NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           pcod-lotacao = RowObject.cod-lotacao
           pcod-tip-doc = RowObject.cod-tip-doc
           pnum-faixa = RowObject.num-faixa
           pseq-aprov = RowObject.seq-aprov.

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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-3":U THEN ASSIGN pFieldValue = RowObject.log-3.
        WHEN "log-4":U THEN ASSIGN pFieldValue = RowObject.log-4.
        WHEN "log-5":U THEN ASSIGN pFieldValue = RowObject.log-5.
        WHEN "log-depend":U THEN ASSIGN pFieldValue = RowObject.log-depend.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidField DBOProgram
PROCEDURE getRowidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:
               recebe nome do campo
               retorna valor do campo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER prowid AS ROWID NO-UNDO.

    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    ASSIGN prowid = ROWID(RowObject).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice faixa
  Parameters:
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-lotacao
               recebe valor do campo cod-tip-doc
               recebe valor do campo num-faixa
               recebe valor do campo seq-aprov
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo   LIKE mla-hierarquia-faixa.ep-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE mla-hierarquia-faixa.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-lotacao LIKE mla-hierarquia-faixa.cod-lotacao NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-doc LIKE mla-hierarquia-faixa.cod-tip-doc NO-UNDO.
    DEFINE INPUT PARAMETER pnum-faixa   LIKE mla-hierarquia-faixa.num-faixa   NO-UNDO.
    DEFINE INPUT PARAMETER pseq-aprov   LIKE mla-hierarquia-faixa.seq-aprov   NO-UNDO.

    FIND FIRST bfmla-hierarquia-faixa
         WHERE bfmla-hierarquia-faixa.ep-codigo   = pep-codigo
           AND bfmla-hierarquia-faixa.cod-estabel = pcod-estabel
           AND bfmla-hierarquia-faixa.cod-lotacao = pcod-lotacao
           AND bfmla-hierarquia-faixa.cod-tip-doc = pcod-tip-doc
           AND bfmla-hierarquia-faixa.num-faixa   = pnum-faixa
           AND bfmla-hierarquia-faixa.seq-aprov   = pseq-aprov NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-hierarquia-faixa THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-hierarquia-faixa)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyRowid DBOProgram
PROCEDURE goToKeyRowid :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice faixa
  Parameters:  recebe rowid
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prowid AS ROWID NO-UNDO.

    FIND FIRST bfmla-hierarquia-faixa WHERE
        ROWID(bfmla-hierarquia-faixa) = prowid NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-hierarquia-faixa THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-hierarquia-faixa)).
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
    DEF INPUT PARAMETER p-ordem AS CHAR NO-UNDO.

    RUN openQueryStatic (INPUT "Main":U).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryApprovers DBOProgram
PROCEDURE openQueryApprovers :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME}
        FOR EACH {&TABLENAME}
           WHERE {&TABLENAME}.ep-codigo   = c-ep-codigo
             AND {&TABLENAME}.cod-estabel = c-cod-estabel
             AND {&TABLENAME}.cod-lotacao = c-cod-lotacao
             AND {&TABLENAME}.cod-tip-doc = i-cod-tip-doc
             AND {&TABLENAME}.num-faixa   = i-num-faixa
                 NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryKey DBOProgram
PROCEDURE openQueryKey :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME}
        FOR EACH {&TABLENAME}
           WHERE {&TABLENAME}.ep-codigo   = c-ep-codigo
             AND {&TABLENAME}.cod-estabel = c-cod-estabel
             AND {&TABLENAME}.cod-lotacao = c-cod-lotacao
             AND {&TABLENAME}.cod-tip-doc = i-cod-tip-doc
             AND {&TABLENAME}.num-faixa   = i-num-faixa
             AND {&TABLENAME}.seq-aprov   = i-seq-aprov
                 NO-LOCK INDEXED-REPOSITION.

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

    OPEN QUERY {&QUERYNAME}
        FOR EACH {&TABLENAME}
                 NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminaAprovador DBOProgram
PROCEDURE piEliminaAprovador :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-ep-codigo   AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-lotacao AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pi-cod-tip-doc AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER pi-num-faixa   AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER pi-seq-aprov   AS INTEGER    NO-UNDO.

    IF lQueryOpened AND cQueryUseded = "Approvers":U THEN.
    ELSE DO:

        RUN setConstraintKey IN THIS-PROCEDURE (INPUT pc-ep-codigo,   INPUT pc-cod-estabel,
                                                INPUT pc-cod-lotacao, INPUT pi-cod-tip-doc,
                                                INPUT pi-num-faixa,   INPUT pi-seq-aprov).

        RUN openQueryStatic  IN THIS-PROCEDURE (INPUT "Key":U).

        IF RETURN-VALUE = "NOK":U THEN
            RETURN.
    END.

    RUN goToKey IN THIS-PROCEDURE(INPUT pc-ep-codigo,   INPUT pc-cod-estabel,
                                  INPUT pc-cod-lotacao, INPUT pi-cod-tip-doc,
                                  INPUT pi-num-faixa,   INPUT pi-seq-aprov).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN.

    RUN deleteRecord IN THIS-PROCEDURE.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U AND RowErrors.ErrorType <> "INTERNAL":U) THEN
        RETURN "NOK":U.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminaTodosAprovadores DBOProgram
PROCEDURE piEliminaTodosAprovadores :
/*------------------------------------------------------------------------------
  Purpose:     Elimina todos os aprovadores da faixa (empresa/estab/lotacao/documento)
  Parameters:
  Notes:       RowObject precisa estar posicionada
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-ep-codigo   AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-lotacao AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pi-cod-tip-doc AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER pi-num-faixa   AS INTEGER    NO-UNDO.

    RUN setConstraintApprovers IN THIS-PROCEDURE (INPUT pc-ep-codigo,
                                                  INPUT pc-cod-estabel,
                                                  INPUT pc-cod-lotacao,
                                                  INPUT pi-cod-tip-doc,
                                                  INPUT pi-num-faixa).

    RUN openQueryStatic        IN THIS-PROCEDURE (INPUT "Approvers":U).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN.

    FOR EACH mla-hierarquia-faixa
       WHERE mla-hierarquia-faixa.ep-codigo   = pc-ep-codigo
         AND mla-hierarquia-faixa.cod-estabel = pc-cod-estabel
         AND mla-hierarquia-faixa.cod-lotacao = pc-cod-lotacao
         AND mla-hierarquia-faixa.cod-tip-doc = pi-cod-tip-doc
         AND mla-hierarquia-faixa.num-faixa   = pi-num-faixa   NO-LOCK
        BY seq-aprov DESCENDING:

        RUN piEliminaAprovador IN THIS-PROCEDURE (INPUT mla-hierarquia-faixa.ep-codigo,
                                                  INPUT mla-hierarquia-faixa.cod-estabel,
                                                  INPUT mla-hierarquia-faixa.cod-lotacao,
                                                  INPUT mla-hierarquia-faixa.cod-tip-doc,
                                                  INPUT mla-hierarquia-faixa.num-faixa,
                                                  INPUT mla-hierarquia-faixa.seq-aprov).

        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSubstituiAprovador DBOProgram
PROCEDURE piSubstituiAprovador :
/*------------------------------------------------------------------------------
  Purpose:  Substituir os aprovadores das faixas.
  Parameters:  /* Input */
               pcEmpresaIni      : Empresa inicial
               pcEmpresaFim      : Empresa final
               pcEstabIni        : Estabelecimento inicial
               pcEstabFim        : Estabelecimento final
               pcDestino         : Usu†rio origem
               pcOrigem          : Usu†rio destino
               plSimulaAlteracao : Indica se Ç apenas um simulaá∆o(cria as temp-tables porÇm n∆o efetiva as alteraá‰es na base).
               /* Output */
               tt-mla-hierarquia-faixa-origem  : ContÇm os dados dos registros(aprovadores da faixa) do usu†rio origem
               tt-mla-hierarquia-faixa-destino : ContÇm os dados dos registros(aprovadores da faixa) do usu†rio destino
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcEmpresaIni   LIKE empresa.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM pcEmpresaFim   LIKE empresa.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM pcEstabIni     LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE INPUT PARAM pcEstabFim     LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE INPUT PARAM pcDestino      LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM pcOrigem       LIKE mla-usuar-aprov.cod-usuar NO-UNDO.
    DEFINE INPUT PARAM plSimulaAlteracao AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-hierarquia-faixa-origem.
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-hierarquia-faixa-destino.

    EMPTY TEMP-TABLE tt-mla-hierarquia-faixa-origem.
    EMPTY TEMP-TABLE tt-mla-hierarquia-faixa-destino.

    /* Label's */
    DEFINE VARIABLE c-lbl-usuar      AS CHARACTER   NO-UNDO.
    define variable c-substituido    as character   no-undo.
    define variable c-mantido        as character   no-undo.
    define variable c-origem         as character   no-undo.

    DEFINE BUFFER bf-mla-hierarquia-faixa FOR mla-hierarquia-faixa.

    {utp/ut-liter.i "Usu†rio" * R}
    ASSIGN c-lbl-usuar = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Mantido" * R}
    assign c-mantido = trim(return-value).

    {utp/ut-liter.i "Substitu°do" * R}
    assign c-substituido = trim(return-value).

    {utp/ut-liter.i "Origem" * R}
    assign c-origem = trim(return-value).

    RUN inbo/boin769.p PERSISTENT SET h-boin769.
    RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).

    FOR EACH bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.ep-codigo   >= pcEmpresaIni
         AND bf{&TableName}.ep-codigo   <= pcEmpresaFim
         AND bf{&TableName}.cod-estabel >= pcEstabIni
         AND bf{&TableName}.cod-estabel <= pcEstabFim
         AND bf{&TableName}.cod-usuar    = pcOrigem
    BREAK BY bf{&TableName}.ep-codigo
          BY bf{&TableName}.cod-estabel
          BY bf{&TableName}.cod-lotacao
          BY bf{&TableName}.cod-tip-doc
          BY bf{&TableName}.num-faixa:

        IF FIRST-OF(bf{&TableName}.num-faixa) then do:
            if CAN-FIND(mla-faixa-aprov
                WHERE mla-faixa-aprov.ep-codigo   = bf{&TableName}.ep-codigo
                  AND mla-faixa-aprov.cod-estabel = bf{&TableName}.cod-estabel
                  AND mla-faixa-aprov.cod-tip-doc = bf{&TableName}.cod-tip-doc
                  AND mla-faixa-aprov.cod-lotacao = bf{&TableName}.cod-lotacao
                  AND mla-faixa-aprov.num-faixa   = bf{&TableName}.num-faixa) THEN do:

                FOR EACH mla-hierarquia-faixa NO-LOCK
                    WHERE mla-hierarquia-faixa.ep-codigo    = bf{&TableName}.ep-codigo   AND
                            mla-hierarquia-faixa.cod-estabel  = bf{&TableName}.cod-estabel AND
                            mla-hierarquia-faixa.cod-lotacao  = bf{&TableName}.cod-lotacao AND
                            mla-hierarquia-faixa.cod-tip-doc  = bf{&TableName}.cod-tip-doc AND
                            mla-hierarquia-faixa.num-faixa    = bf{&TableName}.num-faixa:

                    CREATE tt-mla-hierarquia-faixa-origem.
                    BUFFER-COPY mla-hierarquia-faixa TO tt-mla-hierarquia-faixa-origem.
                    ASSIGN tt-mla-hierarquia-faixa-origem.situacao = c-origem
                        tt-mla-hierarquia-faixa-origem.id-sit   = 5
                        tt-mla-hierarquia-faixa-origem.r-rowid  = ROWID(mla-hierarquia-faixa).

                    CREATE tt-mla-hierarquia-faixa-destino.
                    BUFFER-COPY mla-hierarquia-faixa TO tt-mla-hierarquia-faixa-destino.
                    ASSIGN tt-mla-hierarquia-faixa-destino.situacao  = IF mla-hierarquia-faixa.cod-usuar = pcOrigem THEN c-substituido ELSE c-mantido
                        tt-mla-hierarquia-faixa-destino.id-sit    = 3
                        tt-mla-hierarquia-faixa-destino.r-rowid   = ROWID(mla-hierarquia-faixa)
                        tt-mla-hierarquia-faixa-destino.cod-usuar = IF mla-hierarquia-faixa.cod-usuar = pcOrigem THEN pcDestino ELSE mla-hierarquia-faixa.cod-usuar.

                    IF NOT plSimulaAlteracao AND mla-hierarquia-faixa.cod-usuar = pcOrigem THEN DO:
                        do transaction:
                            find first bf-mla-hierarquia-faixa exclusive-lock where
                                rowid(bf-mla-hierarquia-faixa) = tt-mla-hierarquia-faixa-origem.r-rowid no-error.
                            if not avail (bf-mla-hierarquia-faixa) then next.
                            RUN pi-gera-log IN h-boin769(INPUT 5,
                                                        INPUT rowid(bf-mla-hierarquia-faixa),
                                                        INPUT 2,
                                                        INPUT ENTRY(5,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                                            c-lbl-usuar + ": " + pcOrigem   + chr(13) +
                                                            "              " + pcDestino).
                            ASSIGN bf-mla-hierarquia-faixa.cod-usuar = pcDestino.
                            release bf-mla-hierarquia-faixa.
                        end.
                    END.
                END.
            END.
        END.
    END.

    IF VALID-HANDLE(h-boin769) THEN DO:
        DELETE PROCEDURE h-boin769.
        ASSIGN h-boin769 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintApprovers DBOProgram
PROCEDURE setConstraintApprovers :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-ep-codigo   AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-lotacao AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pi-cod-tip-doc AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER pi-num-faixa   AS INTEGER    NO-UNDO.

    ASSIGN c-ep-codigo   = pc-ep-codigo
           c-cod-estabel = pc-cod-estabel
           c-cod-lotacao = pc-cod-lotacao
           i-cod-tip-doc = pi-cod-tip-doc
           i-num-faixa   = pi-num-faixa.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintKey DBOProgram
PROCEDURE setConstraintKey :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-ep-codigo   AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-lotacao AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pi-cod-tip-doc AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER pi-num-faixa   AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER pi-seq-aprov   AS INTEGER    NO-UNDO.

    ASSIGN c-ep-codigo   = pc-ep-codigo
           c-cod-estabel = pc-cod-estabel
           c-cod-lotacao = pc-cod-lotacao
           i-cod-tip-doc = pi-cod-tip-doc
           i-num-faixa   = pi-num-faixa
           i-seq-aprov   = pi-seq-aprov.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do include: method/svc/errors/inserr.i
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        IF pType = "CREATE":U
        AND CAN-FIND(FIRST mla-hierarquia-faixa
                     WHERE mla-hierarquia-faixa.ep-codigo = RowObject.ep-codigo
                       AND mla-hierarquia-faixa.cod-estabel = RowObject.cod-estabel
                       AND mla-hierarquia-faixa.cod-lotacao = RowObject.cod-lotacao
                       AND mla-hierarquia-faixa.cod-tip-doc = RowObject.cod-tip-doc
                       AND mla-hierarquia-faixa.num-faixa = RowObject.num-faixa
                       AND mla-hierarquia-faixa.seq-aprov = RowObject.seq-aprov) THEN DO:
            {utp/ut-liter.i "hierarquia_de_aprovadores_da_faixa"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="1"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida empresa */
        IF NOT CAN-FIND(FIRST empresa
                        WHERE empresa.ep-codigo = RowObject.ep-codigo) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "empresa"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida estabelecimento */
        IF NOT CAN-FIND(FIRST estabelec
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "estabelecimento"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida Lotaá∆o */
        IF NOT CAN-FIND(FIRST mla-lotacao
                        WHERE mla-lotacao.cod-lotacao = RowObject.cod-lotacao
                          AND mla-lotacao.ep-codigo   = RowObject.ep-codigo) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "lotaá∆o"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida Documento */
        IF NOT CAN-FIND(FIRST mla-tipo-doc-aprov
                        WHERE mla-tipo-doc-aprov.cod-tip-doc = RowObject.cod-tip-doc
                          AND mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "documento"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida Usu†rio */
        IF NOT CAN-FIND(FIRST mla-usuar-aprov
                        WHERE mla-usuar-aprov.cod-usuar = RowObject.cod-usuar) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "aprovador"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida Faixa */
        IF NOT CAN-FIND(FIRST mla-faixa-aprov
                        WHERE mla-faixa-aprov.ep-codigo = RowObject.ep-codigo
                          AND mla-faixa-aprov.num-faixa = RowObject.num-faixa
                          AND mla-faixa-aprov.cod-estabel = RowObject.cod-estabel
                          AND mla-faixa-aprov.cod-lotacao = RowObject.cod-lotacao
                          AND mla-faixa-aprov.cod-tip-doc = RowObject.cod-tip-doc) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "faixa"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=RETURN-VALUE}
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

