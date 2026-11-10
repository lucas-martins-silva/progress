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
{include/i-prgvrs.i BOIN791 2.00.00.005 } /*** "010005" 24/11/2023 13:25:30  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin791 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : BOIN791.P
    Purpose    : L¢gica de neg¢cio e acesso a dados para tabela mla-faixa-aprov
    Parameters : <none>
    Notes      : <none>
  ------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName boin791
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-faixa-aprov
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
{inbo/boin791.i RowObject}

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
{method/dboqry.i}

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName}    FOR {&TableName}. 


DEFINE VARIABLE c-ep-codigo    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estabel  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-lotacao  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cod-tip-doc  AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-limite-ini   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-limite-fim   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-log-reg      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-boin769      AS HANDLE      NO-UNDO. /* mla-log-reg */
DEFINE VARIABLE h-boin793      AS HANDLE      NO-UNDO. /* mla-hierarquia-aprov */

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
         HEIGHT             = 9.5
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AftercreateRecord DBOProgram 
PROCEDURE AftercreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF NOT VALID-HANDLE(h-boin769) THEN
        RUN inbo/boin769.p PERSISTENT SET h-boin769.

    RUN setLogReg IN THIS-PROCEDURE.

    RUN pi-gera-log IN h-boin769 (INPUT 3, INPUT ROWID(mla-faixa-aprov), INPUT 1, c-log-reg).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

    IF VALID-HANDLE(h-boin793) THEN DO:
        DELETE PROCEDURE h-boin793.
        ASSIGN h-boin793 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforedeleteRecord DBOProgram 
PROCEDURE BeforedeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     Cria log e elimina tabela filha 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT VALID-HANDLE(h-boin793) THEN
        RUN inbo/boin793.p PERSISTENT SET h-boin793.
    

    RUN piEliminaTodosAprovadores IN h-boin793 (INPUT mla-faixa-aprov.ep-codigo,
                                                INPUT mla-faixa-aprov.cod-estabel,
                                                INPUT mla-faixa-aprov.cod-lotacao,
                                                INPUT mla-faixa-aprov.cod-tip-doc,
                                                INPUT mla-faixa-aprov.num-faixa).

    
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN getRowErrors IN h-boin793 (OUTPUT TABLE RowErrors).
        RETURN "NOK":U.
    END.

    IF NOT VALID-HANDLE(h-boin769) THEN
        RUN inbo/boin769.p PERSISTENT SET h-boin769.

    RUN setLogReg IN THIS-PROCEDURE.

    RUN pi-gera-log IN h-boin769 (INPUT 3, INPUT ROWID(mla-faixa-aprov), INPUT 3, c-log-reg).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeupdateRecord DBOProgram 
PROCEDURE BeforeupdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-log-reg = "".

    IF RowObject.limite-ini <> mla-faixa-aprov.limite-ini THEN
        ASSIGN c-log-reg = "Limite Inicial     : ":U + STRING(mla-faixa-aprov.limite-ini)  + CHR(13) +
                           "                   : ":U + STRING(RowObject.limite-ini)        + CHR(13) + CHR(13).

    IF RowObject.limite-fim <> mla-faixa-aprov.limite-fim THEN
        ASSIGN c-log-reg = c-log-reg + "Limite Final       : ":U + STRING(mla-faixa-aprov.limite-fim) + CHR(13) +
                                       "                   : ":U + STRING(RowObject.limite-fim)       + CHR(13) + CHR(13).
    IF c-log-reg <> "" THEN DO:

         IF NOT VALID-HANDLE(h-boin769) THEN
             RUN inbo/boin769.p PERSISTENT SET h-boin769.

         RUN pi-gera-log IN h-boin769 (INPUT 3, INPUT ROWID(mla-faixa-aprov), INPUT 2, c-log-reg).
    END.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
        WHEN "des-faixa":U THEN ASSIGN pFieldValue = RowObject.des-faixa.
        &IF "{&mguni_version}" >= "2.071" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "dec-3":U THEN ASSIGN pFieldValue = RowObject.dec-3.
        WHEN "dec-4":U THEN ASSIGN pFieldValue = RowObject.dec-4.
        WHEN "dec-5":U THEN ASSIGN pFieldValue = RowObject.dec-5.
        WHEN "limite-fim":U THEN ASSIGN pFieldValue = RowObject.limite-fim.
        WHEN "limite-ini":U THEN ASSIGN pFieldValue = RowObject.limite-ini.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-tip-doc":U THEN ASSIGN pFieldValue = RowObject.cod-tip-doc.
        &IF "{&mguni_version}" < "2.071" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "int-3":U THEN ASSIGN pFieldValue = RowObject.int-3.
        WHEN "int-4":U THEN ASSIGN pFieldValue = RowObject.int-4.
        WHEN "int-5":U THEN ASSIGN pFieldValue = RowObject.int-5.
        WHEN "num-faixa":U THEN ASSIGN pFieldValue = RowObject.num-faixa.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice lotacao
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-lotacao
               retorna valor do campo cod-tip-doc
               retorna valor do campo num-faixa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE mla-faixa-aprov.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE mla-faixa-aprov.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-lotacao LIKE mla-faixa-aprov.cod-lotacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tip-doc LIKE mla-faixa-aprov.cod-tip-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-faixa LIKE mla-faixa-aprov.num-faixa NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           pcod-lotacao = RowObject.cod-lotacao
           pcod-tip-doc = RowObject.cod-tip-doc
           pnum-faixa = RowObject.num-faixa.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-3":U THEN ASSIGN pFieldValue = RowObject.log-3.
        WHEN "log-4":U THEN ASSIGN pFieldValue = RowObject.log-4.
        WHEN "log-5":U THEN ASSIGN pFieldValue = RowObject.log-5.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice lotacao
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-lotacao
               recebe valor do campo cod-tip-doc
               recebe valor do campo num-faixa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE mla-faixa-aprov.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE mla-faixa-aprov.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-lotacao LIKE mla-faixa-aprov.cod-lotacao NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-doc LIKE mla-faixa-aprov.cod-tip-doc NO-UNDO.
    DEFINE INPUT PARAMETER pnum-faixa LIKE mla-faixa-aprov.num-faixa NO-UNDO.

    FIND FIRST bfmla-faixa-aprov WHERE 
        bfmla-faixa-aprov.ep-codigo = pep-codigo AND 
        bfmla-faixa-aprov.cod-estabel = pcod-estabel AND 
        bfmla-faixa-aprov.cod-lotacao = pcod-lotacao AND 
        bfmla-faixa-aprov.cod-tip-doc = pcod-tip-doc AND 
        bfmla-faixa-aprov.num-faixa = pnum-faixa NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-faixa-aprov THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-faixa-aprov)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyValor DBOProgram 
PROCEDURE goToKeyValor :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice lotacao
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-lotacao
               recebe valor do campo cod-tip-doc
               recebe valor do campo num-faixa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE mla-faixa-aprov.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE mla-faixa-aprov.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-lotacao LIKE mla-faixa-aprov.cod-lotacao NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-doc LIKE mla-faixa-aprov.cod-tip-doc NO-UNDO.
    DEFINE INPUT PARAMETER pvalor LIKE mla-faixa-aprov.limite-ini NO-UNDO.

    FIND FIRST bfmla-faixa-aprov
         WHERE bfmla-faixa-aprov.ep-codigo   = pep-codigo
           AND bfmla-faixa-aprov.cod-estabel = pcod-estabel
           AND bfmla-faixa-aprov.cod-lotacao = pcod-lotacao
           AND bfmla-faixa-aprov.cod-tip-doc = pcod-tip-doc
           AND bfmla-faixa-aprov.limite-ini <= pvalor
           AND bfmla-faixa-aprov.limite-fim >= pvalor NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-faixa-aprov THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-faixa-aprov)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToMlaLotacao DBOProgram 
PROCEDURE linkToMlaLotacao :
/*------------------------------------------------------------------------------
  Purpose:     Pegar as informa‡äes da tabela mla-lotacao, quando utilizado via 
               programa mla0111
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER hMlaLotacao AS HANDLE NO-UNDO.

    RUN getKey IN hMlaLotacao (OUTPUT c-ep-codigo, OUTPUT c-cod-lotacao).

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

    RUN openQueryStatic (input "Main":U). 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixas DBOProgram 
PROCEDURE openQueryFaixas :
/*------------------------------------------------------------------------------
  Purpose:     Abrir a query para todas as faixas de uma empresa/estabelecimento/lotacao/documento
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME}
        FOR EACH {&TABLENAME}
           WHERE {&TABLENAME}.ep-codigo   = c-ep-codigo
             AND {&TABLENAME}.cod-estabel = c-cod-estabel
             AND {&TABLENAME}.cod-lotacao = c-cod-lotacao
             AND {&TABLENAME}.cod-tip-doc = i-cod-tip-doc
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
    open query {&QUERYNAME} 
        for each {&TABLENAME} 
                 NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixas DBOProgram 
PROCEDURE setConstraintFaixas :
/*------------------------------------------------------------------------------
  Purpose:     Restringir a query para a empresa/estabelecimento/lotacao/documento
               recebidos como parametro 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-ep-codigo   AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-lotacao AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pi-cod-tip-doc AS INTEGER    NO-UNDO.

    ASSIGN c-ep-codigo   = pc-ep-codigo  
           c-cod-estabel = pc-cod-estabel
           c-cod-lotacao = pc-cod-lotacao
           i-cod-tip-doc = pi-cod-tip-doc.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLogReg DBOProgram 
PROCEDURE setLogReg :
/*------------------------------------------------------------------------------
  Purpose:     Preenche a variavel para cria‡Æo do log de altera‡äes
  Parameters:  
  Notes:       mla-faixa-aprov precisa estar posicionada
------------------------------------------------------------------------------*/

    IF AVAIL mla-faixa-aprov THEN
        ASSIGN c-log-reg = ENTRY(3,{ininc/i03in030.i 03}) + CHR(13) + CHR(13) +
                           "Lota‡Æo            : " + STRING(mla-faixa-aprov.cod-lotacao) + CHR(13) +
                           "Documento          : " + STRING(mla-faixa-aprov.cod-tip-doc) + CHR(13) + 
                           "Faixa              : " + STRING(mla-faixa-aprov.num-faixa)   + CHR(13) +                                   
                           "Descri‡Æo          : " + STRING(mla-faixa-aprov.des-faixa)   + CHR(13) +                                   
                           "Limite Inicial     : " + STRING(mla-faixa-aprov.limite-ini)  + CHR(13) +                                   
                           "Limite Final       : " + STRING(mla-faixa-aprov.limite-fim).
    ELSE
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do include: method/svc/errors/inserr.i
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        
        IF  pType = "CREATE":U
        AND CAN-FIND(FIRST mla-faixa-aprov
                     WHERE mla-faixa-aprov.ep-codigo   = RowObject.ep-codigo
                       AND mla-faixa-aprov.cod-estabel = RowObject.cod-estabel
                       AND mla-faixa-aprov.cod-lotacao = RowObject.cod-lotacao
                       AND mla-faixa-aprov.cod-tip-doc = RowObject.cod-tip-doc
                       AND mla-faixa-aprov.num-faixa   = RowObject.num-faixa) THEN DO:
            
            {utp/ut-liter.i "faixas_da_lota‡Æo"}
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida empresa */
        IF NOT CAN-FIND(FIRST empresa
                        WHERE empresa.ep-codigo = RowObject.ep-codigo) THEN DO:
            
            {utp/ut-liter.i "empresa"}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida estabelecimento */
        IF NOT CAN-FIND(FIRST estabelec
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            
            {utp/ut-liter.i "estabelecimento"}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida Lota‡Æo */
        IF NOT CAN-FIND(FIRST mla-lotacao
                        WHERE mla-lotacao.cod-lotacao = RowObject.cod-lotacao
                          AND mla-lotacao.ep-codigo   = RowObject.ep-codigo) THEN DO:
            
            {utp/ut-liter.i "lota‡Æo"}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida Documento */
        IF NOT CAN-FIND(FIRST mla-tipo-doc-aprov
                        WHERE mla-tipo-doc-aprov.cod-tip-doc = RowObject.cod-tip-doc
                          AND mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo) THEN DO:
            
            {utp/ut-liter.i "documento"}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters=RETURN-VALUE}
        END.

        IF RowObject.limite-ini > RowObject.limite-fim THEN DO:
    
            {utp/ut-liter.i Limite_inicial * r}
            ASSIGN c-limite-ini = RETURN-VALUE.
            {utp/ut-liter.i Limite_final * r}
            ASSIGN c-limite-fim = RETURN-VALUE.
            
            {method/svc/errors/inserr.i &ErrorNumber="1207"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-limite-fim + '~~~~' + c-limite-ini"}
        END.
    
        FOR EACH bf{&TableName} FIELDS(limite-ini) NO-LOCK
           WHERE bf{&TableName}.ep-codigo   = RowObject.ep-codigo 
             AND bf{&TableName}.cod-estabel = RowObject.cod-estabel
             AND bf{&TableName}.cod-lotacao = RowObject.cod-lotacao 
             AND bf{&TableName}.cod-tip-doc = RowObject.cod-tip-doc
             AND bf{&TableName}.num-faixa   > RowObject.num-faixa:
            
            IF  bf{&TableName}.limite-ini < RowObject.limite-ini THEN DO:
                
                {utp/ut-liter.i Limite_inicial_da_faixa_seguinte * r}
                ASSIGN c-limite-ini = RETURN-VALUE.
                {utp/ut-liter.i Limite_final * r}
                ASSIGN c-limite-fim = RETURN-VALUE.
                
                {method/svc/errors/inserr.i &ErrorNumber="1207"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" 
                                            &ErrorParameters="c-limite-fim + '~~~~' + c-limite-ini"}
                LEAVE.
            END.
        END.
    END.

    IF pType = "DELETE":U THEN DO:

        IF CAN-FIND(FIRST mla-faixa-aprov 
                    WHERE mla-faixa-aprov.ep-codigo   = RowObject.ep-codigo   
                      AND mla-faixa-aprov.cod-estabel = RowObject.cod-estabel 
                      AND mla-faixa-aprov.cod-lotacao = RowObject.cod-lotacao 
                      AND mla-faixa-aprov.cod-tip-doc = RowObject.cod-tip-doc 
                      AND mla-faixa-aprov.num-faixa   > RowObject.num-faixa) THEN DO:

            /* Existem faixas abaixo desta para a mesma lotação e tipo de documento que devem ser eliminadas primeiro. */
            {method/svc/errors/inserr.i &ErrorNumber="26625"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
            RETURN "NOK":U.

        END.
    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

