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
{include/i-prgvrs.i BOIN01039 2.00.00.005 } /*** "010005" 23/11/2023 16:19:40  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01039 MUT}
&ENDIF

/****************************  Definitions  *****************************/

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN01039
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-envio-solicit-cotac
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
{inbo/boin01039.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


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
        WHEN "assunto-email":U THEN ASSIGN pFieldValue = RowObject.assunto-email.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
        WHEN "cod-obs":U THEN ASSIGN pFieldValue = RowObject.cod-obs.
        WHEN "des-e-mail":U THEN ASSIGN pFieldValue = RowObject.des-e-mail.
        WHEN "des-link-cotac":U THEN ASSIGN pFieldValue = RowObject.des-link-cotac.
        WHEN "des-motiv-cancel":U THEN ASSIGN pFieldValue = RowObject.des-motiv-cancel.
        WHEN "des-motiv-rej":U THEN ASSIGN pFieldValue = RowObject.des-motiv-rej.
        WHEN "dsl-texto":U THEN ASSIGN pFieldValue = RowObject.dsl-texto.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATETIME  NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dtm-rej":U    THEN ASSIGN pFieldValue = RowObject.dtm-rej.
        WHEN "dtm-cancel":U THEN ASSIGN pFieldValue = RowObject.dtm-cancel.
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
        WHEN "cdn-fornec":U THEN ASSIGN pFieldValue = RowObject.cdn-fornec.
        WHEN "idi-situacao":U THEN ASSIGN pFieldValue = RowObject.idi-situacao.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-livre-3":U THEN ASSIGN pFieldValue = RowObject.num-livre-3.
        WHEN "num-livre-4":U THEN ASSIGN pFieldValue = RowObject.num-livre-4.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
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
  Purpose:     Retorna valores dos campos do ¡ndice itmnvslc_id2
  Parameters:  
               retorna valor do campo cdd-solicit
               retorna valor do campo numero-ordem
               retorna valor do campo cdn-fornec
               retorna valor do campo seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdd-solicit LIKE item-envio-solicit-cotac.cdd-solicit NO-UNDO.
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE item-envio-solicit-cotac.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-fornec LIKE item-envio-solicit-cotac.cdn-fornec NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq LIKE item-envio-solicit-cotac.seq NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdd-solicit = RowObject.cdd-solicit
           pnumero-ordem = RowObject.numero-ordem
           pcdn-fornec = RowObject.cdn-fornec
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
        WHEN "log-confir-entreg":U THEN ASSIGN pFieldValue = RowObject.log-confir-entreg.
        WHEN "log-confir-recebto":U THEN ASSIGN pFieldValue = RowObject.log-confir-recebto.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-livre-3":U THEN ASSIGN pFieldValue = RowObject.log-livre-3.
        WHEN "log-livre-4":U THEN ASSIGN pFieldValue = RowObject.log-livre-4.
        WHEN "log-planilha-envda":U THEN ASSIGN pFieldValue = RowObject.log-planilha-envda.
        WHEN "log-rej-reg-fornec":U THEN ASSIGN pFieldValue = RowObject.log-rej-reg-fornec.
        WHEN "log-rejtdo":U THEN ASSIGN pFieldValue = RowObject.log-rejtdo.
        WHEN "log-responde-via-web":U THEN ASSIGN pFieldValue = RowObject.log-responde-via-web.
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
  Purpose:     Reposiciona registro com base no ¡ndice itmnvslc_id2
  Parameters:  
               recebe valor do campo cdd-solicit
               recebe valor do campo numero-ordem
               recebe valor do campo cdn-fornec
               recebe valor do campo seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-solicit LIKE item-envio-solicit-cotac.cdd-solicit NO-UNDO.
    DEFINE INPUT PARAMETER pnumero-ordem LIKE item-envio-solicit-cotac.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-fornec LIKE item-envio-solicit-cotac.cdn-fornec NO-UNDO.
    DEFINE INPUT PARAMETER pseq LIKE item-envio-solicit-cotac.seq NO-UNDO.

    FIND FIRST bfitem-envio-solicit-cotac WHERE 
        bfitem-envio-solicit-cotac.cdd-solicit = pcdd-solicit AND 
        bfitem-envio-solicit-cotac.numero-ordem = pnumero-ordem AND 
        bfitem-envio-solicit-cotac.cdn-fornec = pcdn-fornec AND 
        bfitem-envio-solicit-cotac.seq = pseq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-envio-solicit-cotac THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-envio-solicit-cotac)).
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
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

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
                      AND bf{&TableName}.numero-ordem = RowObject.numero-ordem
                      AND bf{&TableName}.cdn-fornec   = RowObject.cdn-fornec
                      AND bf{&TableName}.seq          = RowObject.seq) THEN DO:
            {utp/ut-liter.i Item_Envio_Solicita‡Æo_Cota‡Æo * }
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

        IF NOT CAN-FIND(FIRST emitente WHERE emitente.cod-emitente = RowObject.cdn-fornec) THEN DO:
            {utp/ut-liter.i Fornecedor * }
            {method/svc/errors/inserr.i 
                    &ErrorNumber="56" /* &1 inexistente. */
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.

        IF NOT CAN-FIND(FIRST ordem-compra WHERE ordem-compra.numero-ordem = RowObject.numero-ordem) THEN DO:
            {utp/ut-liter.i Ordem_Compra * }
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

