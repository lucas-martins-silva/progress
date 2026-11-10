&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/**************************************************************************
** Copyright TOTVS S.A. (2022)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa. 
***************************************************************************/
USING Progress.Lang.*.
USING rep.imp.*.

{include/i-prgvrs.i BOIN045 2.00.00.008 } /*** "010008" 18/09/2024 17:11:22 ***/
{include/i-license-manager.i boin045 MUT}

/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : Tabela com valores dos impostos por atributo de imposto
                 Cada registro é um atributo com o seu conteudo/valor
                 Vinculada ao item do conversor de NF-e (item-doc-orig-nfe)
                 Ex: nom-trib: ICMS
                     cod-campo: CST
                     cod-conteudo: 51
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN045
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-doc-imp-nfe
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin045.i RowObject}

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i}
{inbo/boin045.i tt-item-doc-imp-nfe-em-process}

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
         HEIGHT             = 2
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
DEFINE TEMP-TABLE RowErrorsAux NO-UNDO LIKE RowErrors.

DEFINE VAR c-ch-acesso-comp-nfe LIKE item-doc-imp-nfe.ch-acesso-comp-nfe NO-UNDO.
DEFINE VAR i-seq-item           LIKE item-doc-imp-nfe.seq-item           NO-UNDO.
DEFINE VAR c-nom-trib           LIKE item-doc-imp-nfe.nom-trib           NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR FORMAT "x(12)" NO-UNDO.

// Classes de validacao de imposto e atributo definidos nas classes rep.imp.Imposto e rep.imp.AtributoImposto
def var objImposto      as rep.imp.Imposto           NO-UNDO.
def var objAtribImposto as rep.imp.AtributoImposto   NO-UNDO.
objImposto = new rep.imp.Imposto().
objAtribImposto = new rep.imp.AtributoImposto().

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setChaveAcesso DBOProgram 
PROCEDURE setChaveAcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-ch-acesso-comp-nfe LIKE item-doc-imp-nfe.ch-acesso-comp-nfe NO-UNDO.
    ASSIGN c-ch-acesso-comp-nfe = p-ch-acesso-comp-nfe.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSeqItem DBOProgram 
PROCEDURE setSeqItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-seq-item LIKE item-doc-imp-nfe.seq-item NO-UNDO.
    ASSIGN i-seq-item = p-seq-item.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setNomTrib DBOProgram 
PROCEDURE setNomTrib :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  nom-trib -> Imposto. Ex: ICMS
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-nom-trib LIKE item-doc-imp-nfe.nom-trib NO-UNDO.
    ASSIGN c-nom-trib = p-nom-trib.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTempTableProcess DBOProgram 
PROCEDURE setTempTableProcess :
/*------------------------------------------------------------------------------
  Purpose:     Recebe a temp table de processo tt-item-doc-imp-nfe-em-process
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM TABLE FOR tt-item-doc-imp-nfe-em-process. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyTempTableProcess DBOProgram 
PROCEDURE emptyTempTableProcess :
/*------------------------------------------------------------------------------
  Purpose:     Limpa a temp table de processo tt-item-doc-imp-nfe-em-process
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-item-doc-imp-nfe-em-process.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRegistroOriginalTT DBOProgram 
PROCEDURE addRegistroOriginalTT :
/*------------------------------------------------------------------------------
  Purpose:     Adiciona registro original a TT de processo
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnom-trib      LIKE item-doc-imp-nfe.nom-trib           NO-UNDO.
    DEFINE INPUT PARAMETER pcod-campo     LIKE item-doc-imp-nfe.cod-campo          NO-UNDO.
    DEFINE INPUT PARAMETER pcod-conteudo  LIKE item-doc-imp-nfe.cod-conteudo       NO-UNDO.

    IF c-ch-acesso-comp-nfe = "" OR i-seq-item = 0 OR pcod-conteudo = ? THEN
        RETURN "NOK".

    RUN addRegistroTT (INPUT c-ch-acesso-comp-nfe,
                       INPUT i-seq-item,
                       INPUT "ORIG":U,
                       INPUT pnom-trib,
                       INPUT pcod-campo,
                       INPUT pcod-conteudo).

    RETURN RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRegistroTT DBOProgram 
PROCEDURE addRegistroTT:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pch-acesso-comp-nfe LIKE item-doc-imp-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pseq-item           LIKE item-doc-imp-nfe.seq-item           NO-UNDO.
    DEFINE INPUT PARAMETER ptipo-reg           LIKE item-doc-imp-nfe.tipo-reg           NO-UNDO.
    DEFINE INPUT PARAMETER pnom-trib           LIKE item-doc-imp-nfe.nom-trib           NO-UNDO.
    DEFINE INPUT PARAMETER pcod-campo          LIKE item-doc-imp-nfe.cod-campo          NO-UNDO.
    DEFINE INPUT PARAMETER pcod-conteudo       LIKE item-doc-imp-nfe.cod-conteudo       NO-UNDO.

    IF CAN-FIND (FIRST tt-item-doc-imp-nfe-em-process
                 WHERE tt-item-doc-imp-nfe-em-process.ch-acesso-comp-nfe = pch-acesso-comp-nfe
                   AND tt-item-doc-imp-nfe-em-process.seq-item           = pseq-item
                   AND tt-item-doc-imp-nfe-em-process.tipo-reg           = ptipo-reg
                   AND tt-item-doc-imp-nfe-em-process.nom-trib           = pnom-trib
                   AND tt-item-doc-imp-nfe-em-process.cod-campo          = pcod-campo) THEN DO:
        RETURN "NOK":U. //Registro ja existe na TT
    END.

    CREATE tt-item-doc-imp-nfe-em-process.
    ASSIGN tt-item-doc-imp-nfe-em-process.ch-acesso-comp-nfe = pch-acesso-comp-nfe
           tt-item-doc-imp-nfe-em-process.seq-item           = pseq-item
           tt-item-doc-imp-nfe-em-process.tipo-reg           = ptipo-reg
           tt-item-doc-imp-nfe-em-process.nom-trib           = pnom-trib
           tt-item-doc-imp-nfe-em-process.cod-campo          = pcod-campo
           tt-item-doc-imp-nfe-em-process.cod-conteudo       = pcod-conteudo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRegistroSistemaTT DBOProgram 
PROCEDURE addRegistroSistemaTT :
/*------------------------------------------------------------------------------
  Purpose:     Adiciona registro de sistema a TT de processo
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnom-trib      LIKE item-doc-imp-nfe.nom-trib           NO-UNDO.
    DEFINE INPUT PARAMETER pcod-campo     LIKE item-doc-imp-nfe.cod-campo          NO-UNDO.
    DEFINE INPUT PARAMETER pcod-conteudo  LIKE item-doc-imp-nfe.cod-conteudo       NO-UNDO.

    IF c-ch-acesso-comp-nfe = "" OR i-seq-item = 0 OR pcod-conteudo = ? THEN
        RETURN "NOK".

    RUN addRegistroTT (INPUT c-ch-acesso-comp-nfe,
                       INPUT i-seq-item,
                       INPUT "SIST":U,
                       INPUT pnom-trib,
                       INPUT pcod-campo,
                       INPUT pcod-conteudo).

    RETURN RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRegistroTraduzidoTT DBOProgram 
PROCEDURE addRegistroTraduzidoTT :
/*------------------------------------------------------------------------------
  Purpose:     Adiciona registro traduzido a TT de processo
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnom-trib      LIKE item-doc-imp-nfe.nom-trib           NO-UNDO.
    DEFINE INPUT PARAMETER pcod-campo     LIKE item-doc-imp-nfe.cod-campo          NO-UNDO.
    DEFINE INPUT PARAMETER pcod-conteudo  LIKE item-doc-imp-nfe.cod-conteudo       NO-UNDO.

    IF c-ch-acesso-comp-nfe = "" OR i-seq-item = 0 OR pcod-conteudo = ? THEN
        RETURN "NOK".

    RUN addRegistroTT (INPUT c-ch-acesso-comp-nfe,
                       INPUT i-seq-item,
                       INPUT "TRAD":U,
                       INPUT pnom-trib,
                       INPUT pcod-campo,
                       INPUT pcod-conteudo).

    RETURN RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE efetivarTTProcess DBOProgram 
PROCEDURE efetivarTTProcess :
/*------------------------------------------------------------------------------
  Purpose:     Efetiva todos os registros que foram adicionados na tt-item-doc-imp-nfe-em-process
  Parameters:  <none>
  Notes:       Buscar a RowErrros para verificar se houve erro
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE RowErrorsAux.

    persistenceTransaction:
    DO TRANSACTION:
        FOR EACH tt-item-doc-imp-nfe-em-process:
            EMPTY TEMP-TABLE RowObject.
            EMPTY TEMP-TABLE RowErrors.
            CREATE RowObject.
            BUFFER-COPY tt-item-doc-imp-nfe-em-process TO RowObject.
            RUN validateRecord (INPUT 'CREATE':U).

            IF RETURN-VALUE = "NOK":U THEN
                RUN getRowErrors(OUTPUT TABLE RowErrorsAux APPEND).
            ELSE DO:
                CREATE item-doc-imp-nfe.
                BUFFER-COPY tt-item-doc-imp-nfe-em-process TO item-doc-imp-nfe.
            END.
        END.

        IF CAN-FIND(FIRST RowErrorsAux) THEN
            UNDO, LEAVE persistenceTransaction. // desfaz a transacao caso ocorra erro na criacao de algum atributo
    END.

    EMPTY TEMP-TABLE RowErrors.
    FOR EACH RowErrorsAux:
        BUFFER-COPY RowErrorsAux TO RowErrors. // deixa os erros na RowErrors para que possam ser consultados pelo programa chamador
    END.
    EMPTY TEMP-TABLE RowErrorsAux.

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminarPorChaveAcesso DBOProgram 
PROCEDURE eliminarPorChaveAcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF c-ch-acesso-comp-nfe = "" OR c-ch-acesso-comp-nfe = ? THEN
        RETURN "NOK":U.

    FOR EACH item-doc-imp-nfe EXCLUSIVE-LOCK
       WHERE item-doc-imp-nfe.ch-acesso-comp-nfe = c-ch-acesso-comp-nfe:
        DELETE item-doc-imp-nfe.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminarDadosSistema DBOProgram 
PROCEDURE eliminarDadosSistema :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF c-ch-acesso-comp-nfe = "" OR c-ch-acesso-comp-nfe = ? OR i-seq-item = 0 THEN
        RETURN "NOK":U.

    FOR EACH item-doc-imp-nfe EXCLUSIVE-LOCK
       WHERE item-doc-imp-nfe.ch-acesso-comp-nfe = c-ch-acesso-comp-nfe
         AND item-doc-imp-nfe.seq-item           = i-seq-item:

        IF item-doc-imp-nfe.tipo-reg = "SIST":U THEN
            DELETE item-doc-imp-nfe.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminarDadosTraduzidos DBOProgram 
PROCEDURE eliminarDadosTraduzidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF c-ch-acesso-comp-nfe = "" OR c-ch-acesso-comp-nfe = ? OR i-seq-item = 0 THEN
        RETURN "NOK":U.

    FOR EACH item-doc-imp-nfe EXCLUSIVE-LOCK
       WHERE item-doc-imp-nfe.ch-acesso-comp-nfe = c-ch-acesso-comp-nfe
         AND item-doc-imp-nfe.seq-item           = i-seq-item:

        IF item-doc-imp-nfe.tipo-reg = "TRAD":U THEN
            DELETE item-doc-imp-nfe.
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
        WHEN "ch-acesso-comp-nfe":U THEN ASSIGN pFieldValue = RowObject.ch-acesso-comp-nfe.
        WHEN "tipo-reg":U THEN ASSIGN pFieldValue = RowObject.tipo-reg.
        WHEN "nom-trib":U THEN ASSIGN pFieldValue = RowObject.nom-trib.
        WHEN "cod-campo":U THEN ASSIGN pFieldValue = RowObject.cod-campo.
        WHEN "cod-conteudo":U THEN ASSIGN pFieldValue = RowObject.cod-conteudo.
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
        WHEN "seq-item":U THEN ASSIGN pFieldValue = RowObject.seq-item.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice primario
  Parameters:  
               retorna valor do campo ch-acesso-comp-nfe
               retorna valor do campo seq-item
               retorna valor do campo tipo-reg 
               retorna valor do campo nom-trib 
               retorna valor do campo cod-campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pch-acesso-comp-nfe LIKE item-doc-imp-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-item  LIKE item-doc-imp-nfe.seq-item NO-UNDO.
    DEFINE OUTPUT PARAMETER ptipo-reg  LIKE item-doc-imp-nfe.tipo-reg NO-UNDO.
    DEFINE OUTPUT PARAMETER pnom-trib  LIKE item-doc-imp-nfe.nom-trib NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-campo LIKE item-doc-imp-nfe.cod-campo NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
           pseq-item  = RowObject.seq-item
           ptipo-reg  = RowObject.tipo-reg
           pnom-trib  = RowObject.nom-trib
           pcod-campo = RowObject.cod-campo
           .

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram  
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice dcxmlcmp_id2
  Parameters:  
               recebe valor do campo ch-acesso-comp-nfe
               recebe valor do campo seq-item
               recebe valor do campo tipo-reg 
               recebe valor do campo nom-trib 
               recebe valor do campo cod-campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pch-acesso-comp-nfe LIKE item-doc-imp-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pseq-item  LIKE item-doc-imp-nfe.seq-item NO-UNDO.
    DEFINE INPUT PARAMETER ptipo-reg  LIKE item-doc-imp-nfe.tipo-reg NO-UNDO.
    DEFINE INPUT PARAMETER pnom-trib  LIKE item-doc-imp-nfe.nom-trib NO-UNDO.
    DEFINE INPUT PARAMETER pcod-campo LIKE item-doc-imp-nfe.cod-campo NO-UNDO.

    FIND FIRST bfitem-doc-imp-nfe
         WHERE bfitem-doc-imp-nfe.ch-acesso-comp-nfe = pch-acesso-comp-nfe
           AND bfitem-doc-imp-nfe.seq-item           = pseq-item 
           AND bfitem-doc-imp-nfe.tipo-reg           = ptipo-reg 
           AND bfitem-doc-imp-nfe.nom-trib           = pnom-trib 
           AND bfitem-doc-imp-nfe.cod-campo          = pcod-campo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-doc-imp-nfe THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-doc-imp-nfe)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
   OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDoctoXML DBOProgram 
PROCEDURE openQueryDoctoXML :
/*------------------------------------------------------------------------------
  Purpose:     Abre a query com todos os registros de uma nota
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
                              WHERE {&TableName}.ch-acesso-comp-nfe = c-ch-acesso-comp-nfe  INDEXED-REPOSITION.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemDoctoXML DBOProgram 
PROCEDURE openQueryItemDoctoXML :
/*------------------------------------------------------------------------------
  Purpose:     Abre a query com todos os registros de uma nota e item
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
                              WHERE {&TableName}.ch-acesso-comp-nfe = c-ch-acesso-comp-nfe
                                AND {&TableName}.seq-item           = i-seq-item  INDEXED-REPOSITION.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryImposto DBOProgram 
PROCEDURE openQueryImposto :
/*------------------------------------------------------------------------------
  Purpose:     Abre a query com todos os registros de uma nota, item e tributo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
                              WHERE {&TableName}.ch-acesso-comp-nfe = c-ch-acesso-comp-nfe
                                AND {&TableName}.seq-item           = i-seq-item
                                AND {&TableName}.nom-trib           = c-nom-trib  INDEXED-REPOSITION.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i    */
    /*:T--- Inclua aqui as valida‡äes ---*/

    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:

        IF NOT objImposto:isValid(RowObject.nom-trib) THEN DO:
            // Erro nome do tributo nao eh valido
            {utp/ut-liter.i Tributo *}
            {method/svc/errors/inserr.i &ErrorNumber="32955"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="RETURN-VALUE + ': ' + RowObject.nom-trib"}
        END.

        IF NOT objAtribImposto:isValid(RowObject.cod-campo) THEN DO:
            // Erro atributo do imposto do tributo nao eh valido
            {utp/ut-liter.i Atributo_imposto *}
            {method/svc/errors/inserr.i &ErrorNumber="32955"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="RETURN-VALUE + ': ' + RowObject.cod-campo"}
        END.

    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
