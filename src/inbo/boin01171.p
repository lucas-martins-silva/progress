&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
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
{include/i-prgvrs.i BOIN01171 2.00.00.003 } /*** "010003" 19/03/2026 16:13:36 ***/
{include/i-license-manager.i boin01171 MUT}

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01171
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName cenario-regras-evento-trib
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
{inbo/boin01171.i RowObject}


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

DEF TEMP-TABLE deleteRowErrors NO-UNDO LIKE RowErrors.
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
        WHEN "cod-cclass-trib":U THEN ASSIGN pFieldValue = RowObject.cod-cclass-trib.
        WHEN "cod-class-fisc":U THEN ASSIGN pFieldValue = RowObject.cod-class-fisc.
        WHEN "cod-cred-pres":U THEN ASSIGN pFieldValue = RowObject.cod-cred-pres.
        WHEN "cod-cta-pat":U THEN ASSIGN pFieldValue = RowObject.cod-cta-pat.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-mod-dfe":U THEN ASSIGN pFieldValue = RowObject.cod-mod-dfe.
        WHEN "cod-nbs":U THEN ASSIGN pFieldValue = RowObject.cod-nbs.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
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
        WHEN "data-final":U THEN ASSIGN pFieldValue = RowObject.data-final.
        WHEN "data-inicial":U THEN ASSIGN pFieldValue = RowObject.data-inicial.
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
        WHEN "num-id-cenario":U THEN ASSIGN pFieldValue = RowObject.num-id-cenario.
        WHEN "num-id-regra":U THEN ASSIGN pFieldValue = RowObject.num-id-regra.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-fin-nfe":U THEN ASSIGN pFieldValue = RowObject.cod-fin-nfe.
        WHEN "cod-tipo-nf-cred-deb":U THEN ASSIGN pFieldValue = RowObject.cod-tipo-nf-cred-deb.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice idx-cen-regra
  Parameters:  
               retorna valor do campo num-id-cenario
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-id-cenario LIKE cenario-regras-evento-trib.num-id-cenario NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-id-cenario = RowObject.num-id-cenario.

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
        WHEN "envio-auto":U THEN ASSIGN pFieldValue = RowObject.envio-auto.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram  
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice idx-cen-regra
  Parameters:  
               recebe valor do campo num-id-cenario
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-id-cenario LIKE cenario-regras-evento-trib.num-id-cenario NO-UNDO.
    DEFINE INPUT PARAMETER pnum-id-regra   LIKE cenario-regras-evento-trib.num-id-regra   NO-UNDO.

    FIND FIRST bfcenario-regras-evento-trib WHERE 
        bfcenario-regras-evento-trib.num-id-cenario = pnum-id-cenario AND
        bfcenario-regras-evento-trib.num-id-regra   = pnum-id-regra NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcenario-regras-evento-trib THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcenario-regras-evento-trib)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRules DBOProgram 
PROCEDURE deleteRules:
/*:T------------------------------------------------------------------------------
  Purpose:     Deleta as regras que n∆o fazem parte da lista de regras salvas
  Parameters:  Recebe o identificador do cen†rio e as regras que devem ser salvas
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM dIdCenario   AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAM cRulesIdList AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.
    
    DEFINE VARIABLE cMsgErrorRecordKey AS CHARACTER NO-UNDO.
    DEFINE VARIABLE hHistoricRules     AS HANDLE    NO-UNDO.
    DEFINE VARIABLE cOldContent        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRule              AS CHARACTER NO-UNDO.
    
    IF NOT VALID-HANDLE(hHistoricRules) THEN
        RUN cdp/rules/historicoCenarioEventoTribsRules.p PERSISTENT SET hHistoricRules.

    DEFINE BUFFER bf-cenario-regras FOR cenario-regras-evento-trib.
    
    FOR EACH  bf-cenario-regras NO-LOCK
        WHERE bf-cenario-regras.num-id-cenario = dIdCenario:
        
        IF LOOKUP(STRING(bf-cenario-regras.num-id-regra), cRulesIdList) > 0 THEN NEXT.
        
        RUN goToKey IN THIS-PROCEDURE (INPUT bf-cenario-regras.num-id-cenario,
                                       INPUT bf-cenario-regras.num-id-regra).
        
        IF RETURN-VALUE = "NOK":U THEN NEXT.
        
        ASSIGN cRule = STRING(bf-cenario-regras.num-id-regra).
        
        ASSIGN cOldContent =  (IF bf-cenario-regras.num-id-cenario       <> ? THEN STRING(bf-cenario-regras.num-id-cenario)       ELSE "")  + "|" +
                              (IF bf-cenario-regras.num-id-regra         <> ? THEN STRING(bf-cenario-regras.num-id-regra)         ELSE "")  + "|" +
                              (IF bf-cenario-regras.data-inicial         <> ? THEN STRING(bf-cenario-regras.data-inicial)         ELSE "")  + "|" +
                              (IF bf-cenario-regras.data-final           <> ? THEN STRING(bf-cenario-regras.data-final)           ELSE "")  + "|" +
                              (IF bf-cenario-regras.cod-estabel          <> ? THEN bf-cenario-regras.cod-estabel                  ELSE "")  + "|" +
                              (IF bf-cenario-regras.cod-emitente         <> ? THEN STRING(bf-cenario-regras.cod-emitente)         ELSE "")  + "|" +
                              (IF bf-cenario-regras.cod-fin-nfe          <> ? THEN STRING(bf-cenario-regras.cod-fin-nfe)          ELSE "")  + "|" +
                              (IF bf-cenario-regras.cod-tipo-nf-cred-deb <> ? THEN STRING(bf-cenario-regras.cod-tipo-nf-cred-deb) ELSE "")  + "|" +
                              //(IF bf-cenario-regras.cod-mod-dfe          <> ? THEN bf-cenario-regras.cod-mod-dfe                  ELSE "")  + "|" +
                              (IF bf-cenario-regras.nat-operacao         <> ? THEN bf-cenario-regras.nat-operacao                 ELSE "")  + "|" +
                              (IF bf-cenario-regras.it-codigo            <> ? THEN bf-cenario-regras.it-codigo                    ELSE "")  + "|" +
                              (IF bf-cenario-regras.cod-cclass-trib      <> ? THEN bf-cenario-regras.cod-cclass-trib              ELSE "")  + "|" +
                              (IF bf-cenario-regras.cod-cred-pres        <> ? THEN bf-cenario-regras.cod-cred-pres                ELSE "")  + "|" +
                              (IF bf-cenario-regras.cod-class-fisc       <> ? THEN bf-cenario-regras.cod-class-fisc               ELSE "")  + "|" +
                              (IF bf-cenario-regras.cod-nbs              <> ? THEN bf-cenario-regras.cod-nbs                      ELSE "")  + "|" +
                              (IF bf-cenario-regras.cod-cta-pat          <> ? THEN bf-cenario-regras.cod-cta-pat                  ELSE "").
        
        RUN deleteRecord IN THIS-PROCEDURE.
        RUN getRowErrors IN THIS-PROCEDURE (OUTPUT TABLE deleteRowErrors).
        
        FOR EACH deleteRowErrors WHERE
            UPPER(deleteRowErrors.ErrorType) = 'INTERNAL':U:
            DELETE deleteRowErrors. 
        END.

        IF  CAN-FIND(FIRST deleteRowErrors) THEN DO:

            {utp/ut-liter.i "Regra" * r} 
            ASSIGN cMsgErrorRecordKey = cMsgErrorRecordKey + TRIM(RETURN-VALUE) + ": ":U 
                                                           + STRING(bf-cenario-regras.num-id-regra).

            FOR EACH deleteRowErrors:
                CREATE RowErrors.
                BUFFER-COPY deleteRowErrors 
                         TO RowErrors              
                     ASSIGN RowErrors.ErrorDescription = deleteRowErrors.ErrorDescription 
                                                       + " (":U + cMsgErrorRecordKey + ")":U.
            END.

            IF CAN-FIND(FIRST deleteRowErrors WHERE
                        UPPER (deleteRowErrors.ErrorSubType) = 'ERROR':U) THEN
               RETURN "NOK":U.
        END.
        ELSE DO:
        
            RUN pi-cria-hist-event-temp IN hHistoricRules (INPUT "Exclus∆o",
                                                           INPUT "",
                                                           INPUT "cenario-regras-evento-trib",
                                                           INPUT "Exclus∆o de regra",
                                                           INPUT STRING(dIdCenario),
                                                           INPUT cRule,
                                                           INPUT cOldContent,
                                                           INPUT "").
        END.
        
    END.
    
    RUN pi-cria-hist-event IN hHistoricRules.
    
    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE hHistoricRules NO-ERROR.
    END FINALLY.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

