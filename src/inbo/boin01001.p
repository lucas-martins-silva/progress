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

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01001
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-docto-pend-fluig
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
{inbo/boin01001.i RowObject}
{inbo/boin01001.i2} /*Definiá∆o da temp-table ttParamCreateIntegrationError*/

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i}

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
        WHEN "cod-chave-docto":U THEN ASSIGN pFieldValue = RowObject.cod-chave-docto.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
        WHEN "cod-usuar":U THEN ASSIGN pFieldValue = RowObject.cod-usuar.
        WHEN "cod-usuar-reproces":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-reproces.
        WHEN "des-mensagem":U THEN ASSIGN pFieldValue = RowObject.des-mensagem.
        WHEN "cod-usuar-orig":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-orig.
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
        WHEN "dat-cancel":U THEN ASSIGN pFieldValue = RowObject.dat-cancel.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-livre-3":U THEN ASSIGN pFieldValue = RowObject.dat-livre-3.
        WHEN "dat-livre-4":U THEN ASSIGN pFieldValue = RowObject.dat-livre-4.
        WHEN "dat-rej":U THEN ASSIGN pFieldValue = RowObject.dat-rej.
        WHEN "dt-aprov":U THEN ASSIGN pFieldValue = RowObject.dt-aprov.
        WHEN "dt-geracao":U THEN ASSIGN pFieldValue = RowObject.dt-geracao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram  
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dtm-reproces":U THEN ASSIGN pFieldValue = RowObject.dtm-reproces.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdn-mensagem":U THEN ASSIGN pFieldValue = RowObject.cdn-mensagem.
        WHEN "cdn-seq":U THEN ASSIGN pFieldValue = RowObject.cdn-seq.
        WHEN "cdn-sit":U THEN ASSIGN pFieldValue = RowObject.cdn-sit.
        WHEN "cdn-tip-docto":U THEN ASSIGN pFieldValue = RowObject.cdn-tip-docto.
        WHEN "cdn-tip-erro":U THEN ASSIGN pFieldValue = RowObject.cdn-tip-erro.
        WHEN "cdn-workflow-fluig":U THEN ASSIGN pFieldValue = RowObject.cdn-workflow-fluig.
        WHEN "nr-trans":U THEN ASSIGN pFieldValue = RowObject.nr-trans.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-livre-3":U THEN ASSIGN pFieldValue = RowObject.num-livre-3.
        WHEN "num-livre-4":U THEN ASSIGN pFieldValue = RowObject.num-livre-4.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice mldctpnb_id2
  Parameters:  
               retorna valor do campo cdn-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-seq LIKE mla-docto-pend-fluig.cdn-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-seq = RowObject.cdn-seq.

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
  Purpose:     Reposiciona registro com base no °ndice mldctpnb_id2
  Parameters:  
               recebe valor do campo cdn-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-seq LIKE mla-docto-pend-fluig.cdn-seq NO-UNDO.

    FIND FIRST bfmla-docto-pend-fluig WHERE 
        bfmla-docto-pend-fluig.cdn-seq = pcdn-seq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-docto-pend-fluig THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-docto-pend-fluig)).
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
    
	FOR EACH rowErrors WHERE rowErrors.errorType = "INTERNAL":U
                         AND (   rowErrors.errorNumber = 8
                              OR rowErrors.errorNumber = 11):
        DELETE rowErrors.
    END.
	
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-erro-processamento DBOProgram 
PROCEDURE pi-cria-erro-processamento :
/*:T------------------------------------------------------------------------------
  Purpose:     Cria/atualiza erro de integraá∆o com o Fluig
  Parameters:  ttParamCreateIntegrationError (input) - Temp-table com os parÉmetros 
               da criaá∆o do erro.
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER TABLE FOR ttParamCreateIntegrationError.
   
    DEFINE VARIABLE i-cdn-seq AS INTEGER     NO-UNDO.
    DEFINE BUFFER bf-mla-docto-pend-fluig FOR mla-docto-pend-fluig.

    FIND FIRST ttParamCreateIntegrationError NO-LOCK NO-ERROR.
    IF NOT AVAIL ttParamCreateIntegrationError THEN
        RETURN "NOK":U.

    IF CAN-FIND (FIRST mla-docto-pend-fluig 
                 WHERE mla-docto-pend-fluig.nr-trans = ttParamCreateIntegrationError.nr-trans
                   AND mla-docto-pend-fluig.cdn-tip-erro = ttParamCreateIntegrationError.cdn-tip-erro) THEN DO:
        FIND FIRST mla-docto-pend-fluig EXCLUSIVE-LOCK
                 WHERE mla-docto-pend-fluig.nr-trans = ttParamCreateIntegrationError.nr-trans
                   AND mla-docto-pend-fluig.cdn-tip-erro = ttParamCreateIntegrationError.cdn-tip-erro NO-ERROR.
        IF AVAIL mla-docto-pend-fluig THEN
            IF mla-docto-pend-fluig.cdn-tip-erro = 6 THEN /*Troca de Aprovador*/
                ASSIGN mla-docto-pend-fluig.cod-usuar = ttParamCreateIntegrationError.cod-usuar.
    END.
    ELSE DO:
        /* A consulta abaixo na tabela mla-docto-pend-fluig com EXCLUSIVE-LOCK se faz necess†ria
          devido a criaá∆o dos registros dentro de uma mesma transaá∆o, buscando o valor do buffer e 
          evitando o erro de duplicidade na chave. N«O DEVERµ SER ALTERADA.*/
        FOR LAST bf-mla-docto-pend-fluig FIELDS(cdn-seq) EXCLUSIVE-LOCK: END.
        IF AVAIL bf-mla-docto-pend-fluig THEN DO:
            ASSIGN i-cdn-seq = bf-mla-docto-pend-fluig.cdn-seq + 1.
            REPEAT:
                IF CAN-FIND(FIRST mla-docto-pend-fluig WHERE mla-docto-pend-fluig.cdn-seq = i-cdn-seq) THEN
                     ASSIGN i-cdn-seq = i-cdn-seq + 1.
                ELSE LEAVE.
            END.
        END.
        ELSE
            ASSIGN i-cdn-seq = 1.

        FOR FIRST mla-doc-pend-aprov FIELDS(nr-trans chave-doc cdn-workflow-fluig 
                                             dt-geracao cod-usuar cod-tip-doc dt-aprova dt-rejeita)
             WHERE mla-doc-pend-aprov.nr-trans = ttParamCreateIntegrationError.nr-trans NO-LOCK:
            
            CREATE mla-docto-pend-fluig.
            ASSIGN mla-docto-pend-fluig.cdn-seq            = i-cdn-seq
                   mla-docto-pend-fluig.nr-trans           = mla-doc-pend-aprov.nr-trans
                   mla-docto-pend-fluig.cod-chave-docto    = mla-doc-pend-aprov.chave-doc
                   mla-docto-pend-fluig.cdn-workflow-fluig = mla-doc-pend-aprov.cdn-workflow-fluig
                   mla-docto-pend-fluig.dt-geracao         = mla-doc-pend-aprov.dt-geracao
                   mla-docto-pend-fluig.cod-usuar          = mla-doc-pend-aprov.cod-usuar
                   mla-docto-pend-fluig.cdn-tip-docto      = mla-doc-pend-aprov.cod-tip-doc
                   mla-docto-pend-fluig.cdn-tip-erro       = ttParamCreateIntegrationError.cdn-tip-erro.
                
            CASE ttParamCreateIntegrationError.cdn-tip-erro:
                WHEN 2 THEN DO: /*Aprovaá∆o*/
                    ASSIGN mla-docto-pend-fluig.dt-aprov = mla-doc-pend-aprov.dt-aprova.
                END.
                WHEN 3 THEN DO: /*Reprovaá∆o*/
                    ASSIGN mla-docto-pend-fluig.dat-rej  = mla-doc-pend-aprov.dt-rejeita.
                END.
                WHEN 4 THEN DO: /*Cancelamento por Alteraá∆o*/
                    ASSIGN mla-docto-pend-fluig.dat-cancel = TODAY.
                END.
                WHEN 5 THEN DO: /*Cancelamento por Eliminaá∆o*/
                    ASSIGN mla-docto-pend-fluig.dat-cancel = TODAY.
                END.
            END CASE.
        END.
    END.

    IF AVAIL mla-docto-pend-fluig THEN DO:
        
        ASSIGN mla-docto-pend-fluig.cdn-mensagem                = ttParamCreateIntegrationError.cdn-msg
               mla-docto-pend-fluig.des-mensagem                = ""
               OVERLAY(mla-docto-pend-fluig.des-mensagem,1,500) = ttParamCreateIntegrationError.des-msg
               OVERLAY(mla-docto-pend-fluig.des-mensagem,501)   = ttParamCreateIntegrationError.help-msg
               mla-docto-pend-fluig.cod-usuar-orig              = ttParamCreateIntegrationError.cod-usuar-orig.

        IF ttParamCreateIntegrationError.reproces THEN
            ASSIGN mla-docto-pend-fluig.cod-usuar-reproces = c-seg-usuario
                   mla-docto-pend-fluig.dtm-reproces = NOW.
        
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
