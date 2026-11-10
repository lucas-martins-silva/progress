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
{include/i-prgvrs.i BOIN783 2.00.00.006 } /*** "010006" 24/11/2023 13:25:29  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin783 MUT}
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
&GLOBAL-DEFINE DBOName boin783
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-tipo-aprov-ref
&GLOBAL-DEFINE TableLabel 
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
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin783.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
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
         HEIGHT             = 2.42
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
        WHEN "codigo":U THEN ASSIGN pFieldValue = RowObject.codigo.
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
        WHEN "cod-tip-aprov":U THEN ASSIGN pFieldValue = RowObject.cod-tip-aprov.
        WHEN "cod-tip-doc":U THEN ASSIGN pFieldValue = RowObject.cod-tip-doc.
        &IF "{&mguni_version}" < "2.071" &THEN
             WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "int-3":U THEN ASSIGN pFieldValue = RowObject.int-3.
        WHEN "int-4":U THEN ASSIGN pFieldValue = RowObject.int-4.
        WHEN "int-5":U THEN ASSIGN pFieldValue = RowObject.int-5.
        WHEN "nr-min-aprov":U THEN ASSIGN pFieldValue = RowObject.nr-min-aprov.
        WHEN "prioridade-aprov":U THEN ASSIGN pFieldValue = RowObject.prioridade-aprov.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice referencia
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-tip-doc
               retorna valor do campo codigo
               retorna valor do campo cod-tip-aprov
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE mla-tipo-aprov-ref.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tip-doc LIKE mla-tipo-aprov-ref.cod-tip-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER pcodigo LIKE mla-tipo-aprov-ref.codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tip-aprov LIKE mla-tipo-aprov-ref.cod-tip-aprov NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-tip-doc = RowObject.cod-tip-doc
           pcodigo = RowObject.codigo
           pcod-tip-aprov = RowObject.cod-tip-aprov.

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
        WHEN "log-limite":U THEN ASSIGN pFieldValue = RowObject.log-limite.
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
  Purpose:     Reposiciona registro com base no °ndice referencia
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-tip-doc
               recebe valor do campo codigo
               recebe valor do campo cod-tip-aprov
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE mla-tipo-aprov-ref.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-doc LIKE mla-tipo-aprov-ref.cod-tip-doc NO-UNDO.
    DEFINE INPUT PARAMETER pcodigo LIKE mla-tipo-aprov-ref.codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-aprov LIKE mla-tipo-aprov-ref.cod-tip-aprov NO-UNDO.

    FIND FIRST bfmla-tipo-aprov-ref WHERE 
        bfmla-tipo-aprov-ref.ep-codigo = pep-codigo AND 
        bfmla-tipo-aprov-ref.cod-tip-doc = pcod-tip-doc AND 
        bfmla-tipo-aprov-ref.codigo = pcodigo AND 
        bfmla-tipo-aprov-ref.cod-tip-aprov = pcod-tip-aprov NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-tipo-aprov-ref THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-tipo-aprov-ref)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyPrioridade DBOProgram 
PROCEDURE goToKeyPrioridade :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice referencia
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-tip-doc
               recebe valor do campo codigo
               recebe valor do campo cod-tip-aprov
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE mla-tipo-aprov-ref.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-doc LIKE mla-tipo-aprov-ref.cod-tip-doc NO-UNDO.
    DEFINE INPUT PARAMETER pcodigo LIKE mla-tipo-aprov-ref.codigo NO-UNDO.
    DEFINE INPUT PARAMETER pprioridade LIKE mla-tipo-aprov-ref.prioridade-aprov NO-UNDO.

    FIND FIRST bfmla-tipo-aprov-ref WHERE 
        bfmla-tipo-aprov-ref.ep-codigo = pep-codigo AND 
        bfmla-tipo-aprov-ref.cod-tip-doc = pcod-tip-doc AND 
        bfmla-tipo-aprov-ref.codigo = pcodigo AND 
        bfmla-tipo-aprov-ref.prioridade-aprov = pprioridade NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-tipo-aprov-ref THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-tipo-aprov-ref)).
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

    RUN openQueryStatic (input "Main":U). 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        IF pType = "CREATE":U
        AND CAN-FIND(FIRST mla-tipo-aprov-ref
                     WHERE mla-tipo-aprov-ref.ep-codigo = RowObject.ep-codigo
                       AND mla-tipo-aprov-ref.cod-tip-doc = RowObject.cod-tip-doc
                       AND mla-tipo-aprov-ref.codigo = RowObject.codigo
                       AND mla-tipo-aprov-ref.cod-tip-aprov = RowObject.cod-tip-aprov) THEN DO:
            {utp/ut-liter.i "tipos_de_aprovaá∆o_da_referància"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="1"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Existància da empresa */
        IF NOT CAN-FIND (FIRST empresa
                         WHERE empresa.ep-codigo = RowObject.ep-codigo) THEN DO:
            {utp/ut-liter.i "empresa"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Existància do documento */
        IF NOT CAN-FIND (FIRST mla-tipo-doc-aprov
                         WHERE mla-tipo-doc-aprov.cod-tip-doc = RowObject.cod-tip-doc
                           AND mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo) THEN DO:
            {utp/ut-liter.i "documento"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Existància da referància */
        IF NOT CAN-FIND (FIRST mla-referencia
                         WHERE mla-referencia.codigo = RowObject.codigo
                           AND mla-referencia.ep-codigo = RowObject.ep-codigo
                           AND mla-referencia.cod-tip-doc = RowObject.cod-tip-doc) THEN DO:
            {utp/ut-liter.i "referància"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Existància do tipo de aprovaá∆o */
        IF NOT CAN-FIND (FIRST mla-tipo-aprov 
                         WHERE mla-tipo-aprov.cod-tip-aprov = RowObject.cod-tip-aprov) THEN DO:
            {utp/ut-liter.i "c¢digo_da_aprovaá∆o"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.
           
        /* Se o tipo da aprovaá∆o n∆o for do tipo lista -> */
        FOR FIRST mla-tipo-aprov FIELDS(ind-tip-aprov) NO-LOCK
            WHERE mla-tipo-aprov.cod-tip-aprov = RowObject.cod-tip-aprov:
            IF mla-tipo-aprov.ind-tip-aprov <> 2 THEN DO:
                {method/svc/errors/inserr.i
                        &ErrorNumber="30338"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"}
    
            END.
        END.

        /* Verifica m°nimo de aprovaá∆o para listas */
        FOR FIRST mla-tipo-aprov FIELDS(ind-tip-aprov) NO-LOCK
            WHERE mla-tipo-aprov.cod-tip-aprov = RowObject.cod-tip-aprov:
            IF mla-tipo-aprov.ind-tip-aprov <> 2 AND RowObject.nr-min-aprov <> 0 THEN DO:
                {utp/ut-liter.i "m°nimo_de_aprovaá‰es"}
                {method/svc/errors/inserr.i
                        &ErrorNumber="52530"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=RETURN-VALUE}
            END.
        END.
    END.
    ELSE DO:
        FOR EACH mla-tipo-doc-aprov FIELDS(cod-tip-doc)
           WHERE mla-tipo-doc-aprov.prioridade-aprov = 3 
             AND mla-tipo-doc-aprov.ep-codigo = RowObject.ep-codigo
             AND mla-tipo-doc-aprov.cod-tip-doc = RowObject.cod-tip-doc NO-LOCK:
            IF CAN-FIND (FIRST mla-doc-pend-aprov 
                         WHERE mla-doc-pend-aprov.ep-codigo = RowObject.ep-codigo
                           AND mla-doc-pend-aprov.cod-tip-aprov = RowObject.cod-tip-aprov
                           AND mla-doc-pend-aprov.cod-tip-doc = mla-tipo-doc-aprov.cod-tip-doc 
                           AND mla-doc-pend-aprov.ind-situacao = 1) THEN DO:
                {method/svc/errors/inserr.i
                        &ErrorNumber="54445"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=RowObject.cod-tip-aprov}
                LEAVE.
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

