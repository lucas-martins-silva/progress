&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/
{include/i-prgvrs.i BOIN01038 2.00.00.007 } /*** "010007" 23/11/2023 16:19:40  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01038 MUT}
&ENDIF

/****************************  Definitions  *****************************/

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN01038
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName envio-solicit-cotac
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin01038.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{inbo/boin01038.i1} /* ttSendedQuotationProcess, ttItemSendedQuotationProcess*/

DEFINE TEMP-TABLE ttVendorSendedQuotationProcess NO-UNDO LIKE ttItemSendedQuotationProcess 
       USE-INDEX itmnvslc_ix3.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
        WHEN "cod-obs":U THEN ASSIGN pFieldValue = RowObject.cod-obs.
        WHEN "des-motiv-cancel":U THEN ASSIGN pFieldValue = RowObject.des-motiv-cancel.
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
        WHEN "dat-envio":U THEN ASSIGN pFieldValue = RowObject.dat-envio.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-livre-3":U THEN ASSIGN pFieldValue = RowObject.dat-livre-3.
        WHEN "dat-livre-4":U THEN ASSIGN pFieldValue = RowObject.dat-livre-4.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDatetimeField DBOProgram 
PROCEDURE getDatetimeField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo datetime
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATETIME NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dtm-liber":U   THEN ASSIGN pFieldValue = RowObject.dtm-liber.
        WHEN "dtm-expirac":U THEN ASSIGN pFieldValue = RowObject.dtm-expirac.
        WHEN "dtm-cancel":U  THEN ASSIGN pFieldValue = RowObject.dtm-cancel.
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
        WHEN "cdd-solicit":U THEN ASSIGN pFieldValue = RowObject.cdd-solicit.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-livre-3":U THEN ASSIGN pFieldValue = RowObject.val-livre-3.
        WHEN "val-livre-4":U THEN ASSIGN pFieldValue = RowObject.val-livre-4.
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
        WHEN "idi-situacao":U THEN ASSIGN pFieldValue = RowObject.idi-situacao.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-livre-3":U THEN ASSIGN pFieldValue = RowObject.num-livre-3.
        WHEN "num-livre-4":U THEN ASSIGN pFieldValue = RowObject.num-livre-4.
        WHEN "seq":U THEN ASSIGN pFieldValue = RowObject.seq.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice envslctc_id4
  Parameters:  
               retorna valor do campo cdd-solicit
               retorna valor do campo seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdd-solicit LIKE envio-solicit-cotac.cdd-solicit NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq LIKE envio-solicit-cotac.seq NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdd-solicit = RowObject.cdd-solicit
           pseq = RowObject.seq.

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
        WHEN "log-cancel":U THEN ASSIGN pFieldValue = RowObject.log-cancel.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-livre-3":U THEN ASSIGN pFieldValue = RowObject.log-livre-3.
        WHEN "log-livre-4":U THEN ASSIGN pFieldValue = RowObject.log-livre-4.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSendedQuotationProcessByPurchOrder DBOProgram 
PROCEDURE getSendedQuotationProcessByPurchOrder :
/*------------------------------------------------------------------------------
  Purpose: Busca informa‡äes sobre as solicita‡äes de cota‡Æo enviadas referente a ordem de compra informada
  Parameters:   p-numero-ordem (input): Nœmero da ordem de compra (integer)
                ttSendedQuotationProcess (output): Informa‡äes do envio da solicita‡Æo de cota‡Æo. (temp-table)
                ttItemSendedQuotationProcess (output): Informa‡äes do item do envio da solicita‡Æo de cota‡Æo. (temp-table)
                RowErrors (output): Informa‡äes dos erros que ocorreram durante o processamento. (temp-table)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNumeroOrdem LIKE item-solicit-cotac.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttSendedQuotationProcess.
    DEFINE OUTPUT PARAMETER TABLE FOR ttItemSendedQuotationProcess.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    EMPTY TEMP-TABLE RowErrors.

    IF NOT CAN-FIND(FIRST item-solicit-cotac WHERE item-solicit-cotac.numero-ordem = pNumeroOrdem) THEN DO:
        {utp/ut-table.i movind item-solicit-cotac 1}
        {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorParameters="RETURN-VALUE + '~~~~' + STRING(pNumeroOrdem)"}
    END.

    FOR FIRST item-solicit-cotac fields(numero-ordem cdd-solicit) NO-LOCK
        WHERE item-solicit-cotac.numero-ordem = pNumeroOrdem:

        FOR EACH envio-solicit-cotac NO-LOCK
            WHERE envio-solicit-cotac.cdd-solicit = item-solicit-cotac.cdd-solicit:

            IF CAN-FIND(FIRST item-envio-solicit-cotac NO-LOCK
                            WHERE item-envio-solicit-cotac.cdd-solicit   = item-solicit-cotac.cdd-solicit
                            AND   item-envio-solicit-cotac.numero-ordem  = item-solicit-cotac.numero-ordem
                            AND   item-envio-solicit-cotac.seq           = envio-solicit-cotac.seq) THEN DO:

                CREATE ttSendedQuotationProcess.
                BUFFER-COPY envio-solicit-cotac TO ttSendedQuotationProcess.
    
                FOR EACH item-envio-solicit-cotac NO-LOCK
                    WHERE item-envio-solicit-cotac.cdd-solicit   = item-solicit-cotac.cdd-solicit
                    AND   item-envio-solicit-cotac.numero-ordem  = item-solicit-cotac.numero-ordem
                    AND   item-envio-solicit-cotac.seq           = envio-solicit-cotac.seq :
    
                    CREATE ttItemSendedQuotationProcess.
                    BUFFER-COPY item-envio-solicit-cotac TO ttItemSendedQuotationProcess.
                    FOR FIRST emitente FIELDS(nome-abrev nome-emit cgc) NO-LOCK
                        WHERE emitente.cod-emitente = item-envio-solicit-cotac.cdn-fornec:
                        ASSIGN ttItemSendedQuotationProcess.nome-abrev  = emitente.nome-abrev
                               ttItemSendedQuotationProcess.nome-emit   = emitente.nome-emit
                               ttItemSendedQuotationProcess.cgc         = emitente.cgc.
                    END.
                END.
            END.
        END.
    END.
    
    /*:T--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSendedQuotationProcessByProcess DBOProgram 
PROCEDURE getSendedQuotationProcessByProcess :
/*------------------------------------------------------------------------------
  Purpose: Busca informa‡äes sobre as solicita‡äes de cota‡Æo enviadas para o processo de cota‡Æo
  Parameters:   pQuotationProcessNumber (input): N£mero do processo de cota‡Æo (decimal)
                ttSendedQuotationProcess (output): Informa‡äes do envio da solicita‡Æo de cota‡Æo. (temp-table)
                ttVendorSendedQuotationProcess (output): Informa‡äes do fornecedor do envio da solicita‡Æo de cota‡Æo. (temp-table)
                RowErrors (output): Informa‡äes dos erros que ocorreram durante o processamento. (temp-table)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pQuotationProcessNumber LIKE solicit-cotac.cdd-solicit NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttSendedQuotationProcess.
    DEFINE OUTPUT PARAMETER TABLE FOR ttVendorSendedQuotationProcess.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    EMPTY TEMP-TABLE RowErrors.
    EMPTY TEMP-TABLE ttSendedQuotationProcess.
    EMPTY TEMP-TABLE ttItemSendedQuotationProcess.

    IF NOT CAN-FIND(FIRST solicit-cotac WHERE solicit-cotac.cdd-solicit = pQuotationProcessNumber) THEN DO:
        {utp/ut-table.i movind solicit-cotac 1}
        {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorParameters="RETURN-VALUE + '~~~~' + STRING(pQuotationProcessNumber)"}
    END.
    ELSE DO:
        FOR EACH envio-solicit-cotac NO-LOCK
           WHERE envio-solicit-cotac.cdd-solicit = pQuotationProcessNumber:
    
            IF CAN-FIND(FIRST item-envio-solicit-cotac NO-LOCK
                        WHERE item-envio-solicit-cotac.cdd-solicit   = envio-solicit-cotac.cdd-solicit
                          AND item-envio-solicit-cotac.seq           = envio-solicit-cotac.seq) THEN DO:
    
                CREATE ttSendedQuotationProcess.
                BUFFER-COPY envio-solicit-cotac TO ttSendedQuotationProcess.
    
                FOR EACH item-envio-solicit-cotac NO-LOCK
                    WHERE item-envio-solicit-cotac.cdd-solicit   = envio-solicit-cotac.cdd-solicit
                    AND   item-envio-solicit-cotac.seq           = envio-solicit-cotac.seq 
                    BREAK BY item-envio-solicit-cotac.cdn-fornec:
    
                    IF FIRST-OF(item-envio-solicit-cotac.cdn-fornec) THEN DO:
                        CREATE ttVendorSendedQuotationProcess.
                        BUFFER-COPY item-envio-solicit-cotac TO ttVendorSendedQuotationProcess.
                        FOR FIRST emitente FIELDS(nome-abrev nome-emit cgc) NO-LOCK
                            WHERE emitente.cod-emitente = item-envio-solicit-cotac.cdn-fornec:
                            ASSIGN ttVendorSendedQuotationProcess.nome-abrev  = emitente.nome-abrev
                                   ttVendorSendedQuotationProcess.nome-emit   = emitente.nome-emit
                                   ttVendorSendedQuotationProcess.cgc         = emitente.cgc.
                        END.
                    END.
                END.
            END.
        END.
    END.
    
    /*:T--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice envslctc_id4
  Parameters:  
               recebe valor do campo cdd-solicit
               recebe valor do campo seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-solicit LIKE envio-solicit-cotac.cdd-solicit NO-UNDO.
    DEFINE INPUT PARAMETER pseq LIKE envio-solicit-cotac.seq NO-UNDO.

    FIND FIRST bfenvio-solicit-cotac WHERE 
        bfenvio-solicit-cotac.cdd-solicit = pcdd-solicit AND 
        bfenvio-solicit-cotac.seq = pseq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfenvio-solicit-cotac THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfenvio-solicit-cotac)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query com todos os registros da tabela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Removido o INDEXED-REPOSITION devido a erro em banco Oracle - Chamado aberto junto a Progress:
       https://supportlink.progress.com/partner/CDetails?id=5000c00001fkKLP */
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK.

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
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    IF pType = "Create":U THEN DO:
        IF CAN-FIND(FIRST bf{&TableName} 
                    WHERE bf{&TableName}.cdd-solicit  = RowObject.cdd-solicit
                      AND bf{&TableName}.seq          = RowObject.seq) THEN DO:
            {utp/ut-liter.i Envio_Solicita‡Æo_Cota‡Æo * }
            {method/svc/errors/inserr.i
                  &ErrorNumber="1"
                  &ErrorType=EMS
                  &ErrorSubType=ERROR
                  &ErrorParameters="return-value"}
            RETURN "NOK":U.                       
        END.
    END.

    IF pType = "Create":U OR pType = "Update":U THEN DO:
        IF NOT CAN-FIND(FIRST solicit-cotac WHERE solicit-cotac.cdd-solicit = RowObject.cdd-solicit) THEN DO:
            {utp/ut-liter.i Processo_de_Cota»’o * }
            {method/svc/errors/inserr.i 
                    &ErrorNumber="56" /* &1 inexistente. */
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
    END.

    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

