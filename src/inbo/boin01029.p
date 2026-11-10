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
{include/i-prgvrs.i BOIN01029 2.00.00.014 } /*** "010014" 23/11/2023 16:19:40  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01029 MUT}
&ENDIF
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01029
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-solicit-cotac
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
&GLOBAL-DEFINE KeyField1 cdd-solicit /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField2 numero-ordem /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES
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
{inbo/boin01029.i RowObject}
{ccp/ccapi362.i} 

DEFINE VARIABLE c-lb-ordem-compra           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cStatusQuotationProcessItem AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-status-msg             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-process-msg            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-quotation-process-msg  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-error                     AS LOGICAL NO-UNDO.

{utp/ut-liter.i "Sem envio"}
ASSIGN cStatusQuotationProcessItem = RETURN-VALUE.
{utp/ut-liter.i "Com envio"}
ASSIGN cStatusQuotationProcessItem = cStatusQuotationProcessItem + "," + RETURN-VALUE.
{utp/ut-liter.i "Respondida parcial"}
ASSIGN cStatusQuotationProcessItem = cStatusQuotationProcessItem + "," + RETURN-VALUE.
{utp/ut-liter.i "Respondida total"}
ASSIGN cStatusQuotationProcessItem = cStatusQuotationProcessItem + "," + RETURN-VALUE.
{utp/ut-liter.i "Finalizada"}
ASSIGN cStatusQuotationProcessItem = cStatusQuotationProcessItem + "," + RETURN-VALUE.
{utp/ut-liter.i "Ordem de compra"}
ASSIGN c-lb-ordem-compra = RETURN-VALUE.
{utp/ut-liter.i "Situaá∆o da ordem de compra Ç diferente de 'N∆o Confirmada' e 'Em Cotaá∆o'"}
ASSIGN c-lb-status-msg = RETURN-VALUE.
{utp/ut-liter.i "Ordem de compra relacionada a um Processo de Compras"}
ASSIGN c-lb-process-msg = RETURN-VALUE.
{utp/ut-liter.i "Ordem de compra j† relacionada a um Processo de Solicitaá∆o de Cotaá∆o"}
ASSIGN c-lb-quotation-process-msg = RETURN-VALUE.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bf-item-solicit-cotac FOR item-solicit-cotac.
/* ************************  Function Prototypes ********************** */
FUNCTION fnGetDescription RETURNS CHARACTER
  (input pFieldName as char)  FORWARD.


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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "idi-situacao":U THEN ASSIGN pFieldValue = RowObject.idi-situacao.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-livre-3":U THEN ASSIGN pFieldValue = RowObject.num-livre-3.
        WHEN "num-livre-4":U THEN ASSIGN pFieldValue = RowObject.num-livre-4.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice itmslctc_id2
  Parameters:  
               retorna valor do campo cdd-solicit
               retorna valor do campo numero-ordem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdd-solicit LIKE item-solicit-cotac.cdd-solicit NO-UNDO.
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE item-solicit-cotac.numero-ordem NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdd-solicit = RowObject.cdd-solicit
           pnumero-ordem = RowObject.numero-ordem.

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
  Purpose:     Reposiciona registro com base no °ndice itmslctc_id2
  Parameters:  
               recebe valor do campo cdd-solicit
               recebe valor do campo numero-ordem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-solicit LIKE item-solicit-cotac.cdd-solicit NO-UNDO.
    DEFINE INPUT PARAMETER pnumero-ordem LIKE item-solicit-cotac.numero-ordem NO-UNDO.

    FIND FIRST bfitem-solicit-cotac WHERE 
        bfitem-solicit-cotac.cdd-solicit = pcdd-solicit AND 
        bfitem-solicit-cotac.numero-ordem = pnumero-ordem NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-solicit-cotac THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-solicit-cotac)).
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
    
    DEFINE VARIABLE cLbLinkOrderLine AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lHasQuotation    AS LOGICAL   NO-UNDO.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    IF pType = "Create":U THEN DO:
        
        IF NOT CAN-FIND(FIRST solicit-cotac 
                        WHERE solicit-cotac.cdd-solicit = RowObject.cdd-solicit) THEN DO:
             {utp/ut-liter.i "Processo_de_Cotaá∆o"}
             {method/svc/errors/inserr.i
                          &ErrorNumber="2"
                          &ErrorType="EMS"
                          &ErrorParameters=RETURN-VALUE}
        END.

        /*Validaá‰es da ordem de compra*/
        RUN validatePurchaseOrderline(INPUT RowObject.numero-ordem,
                                      INPUT pType).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeleteQuotationProcessItem DBOProgram 
PROCEDURE validateDeleteQuotationProcessItem :
/*:T------------------------------------------------------------------------------
  Purpose:     Verifica se pode ser eliminado
  Parameters:  plQuotationProcessSent(output): Indica se a ordem j† foi 
               enviada para cotaá∆o de fornecedores (logical)
  Notes:       Caso exista envio para essa ordem ser† apresentada uma mensagem no HTML 
               informando isso e questionando se deseja prosseguir com a eliminaá∆o.
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER plQuotationProcessSent AS LOGICAL NO-UNDO.
        
    RUN validateRecord IN THIS-PROCEDURE (INPUT "Delete":U).
    IF RETURN-VALUE = "OK":U THEN DO:

        /*Verifica se existe envio para a ordem do processo de cotaá∆o*/
        IF CAN-FIND(FIRST item-envio-solicit-cotac
                    WHERE item-envio-solicit-cotac.cdd-solicit  = RowObject.cdd-solicit
                      AND item-envio-solicit-cotac.numero-ordem = RowObject.numero-ordem) THEN DO:
            ASSIGN plQuotationProcessSent = YES.
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatePurchaseOrderline DBOProgram 
PROCEDURE validatePurchaseOrderline :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es da ordem de compra
  Parameters:  piOrderlineNumber: N£mero da ordem de compra  - inteiro
               pType: recebe o tipo de validaá∆o (Create, Delete, Update) - character
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER piOrderlineNumber LIKE item-solicit-cotac.numero-ordem NO-UNDO.
    DEFINE INPUT  PARAMETER pType             AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    FIND FIRST ordem-compra 
         WHERE ordem-compra.numero-ordem = piOrderlineNumber NO-LOCK NO-ERROR.
    IF NOT AVAIL ordem-compra THEN DO:
        {method/svc/errors/inserr.i
                          &ErrorNumber="2"
                          &ErrorType="EMS"
                          &ErrorParameters=c-lb-ordem-compra}
    END.
    ELSE DO:
        IF pType = "Create":U THEN DO:
            /*Valida se o tipo da ordem Ç "n∆o confirmada" ou "em cotaá∆o"*/
            IF ordem-compra.situacao <> 1 AND ordem-compra.situacao <> 5 THEN DO:
                {method/svc/errors/inserr.i
                          &ErrorNumber="55290"
                          &ErrorType="EMS"
                          &ErrorParameters="string(piOrderlineNumber) + '~~~~' + c-lb-status-msg"}
            END.
            /*Valida se a ordem est† vinculada a um processo de compras*/
            ELSE IF ordem-compra.nr-processo <> 0 THEN DO:
                {method/svc/errors/inserr.i
                          &ErrorNumber="55290"
                          &ErrorType="EMS"
                          &ErrorParameters="string(piOrderlineNumber) + '~~~~' + c-lb-process-msg"}
            END.
            /*Valida se a ordem j† est† vinculada a uma solicitaá∆o de cotaá∆o*/
            ELSE IF CAN-FIND(FIRST bf-item-solicit-cotac 
                             WHERE bf-item-solicit-cotac.numero-ordem = ordem-compra.numero-ordem) THEN DO:
                {method/svc/errors/inserr.i
                          &ErrorNumber="55290"
                          &ErrorType="EMS"
                          &ErrorParameters="string(piOrderlineNumber) + '~~~~' + c-lb-quotation-process-msg"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPurchReqAutoLinkedInfo DBOProgram 
PROCEDURE getPurchReqAutoLinkedInfo :
/*:T------------------------------------------------------------------------------
  Purpose:     Busca informaá‰es das ordens vinculadas automaticamente na 
               criaá∆o da solicitaá∆o de cotaá∆o
  Parameters:  ttPurchaseOrderlinesList: Lista de ordens para a busca das informaá‰es - temp-table
               ttPurchRequisitionInfo: Retorno das informaá‰es das ordens - temp-table
               RowErrors: Lista de erros - temp-table
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttPurchaseOrderlinesList.
    DEFINE OUTPUT PARAMETER TABLE FOR ttPurchRequisitionInfo.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE BUFFER bf-row-errors FOR RowErrors.

    EMPTY TEMP-TABLE RowErrors.
    FOR EACH ttPurchaseOrderlinesList NO-LOCK:
        RUN getPurchaseRequisitionInfo(INPUT ttPurchaseOrderlinesList.numero-ordem).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQuotationProcessItems DBOProgram 
PROCEDURE getQuotationProcessItems :
/*:T------------------------------------------------------------------------------
  Purpose:     Busca informaá‰es das ordens vinculadas ao processo de cotaá∆o
  Parameters:  pCddSolicit: C¢digo do processo de cotaá∆o - decimal
               ttPurchRequisitionInfo: Retorno das informaá‰es das ordens - temp-table
               RowErrors: Lista de erros - temp-table
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pCddSolicit LIKE item-solicit-cotac.cdd-solicit NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttPurchRequisitionInfo.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FOR EACH item-solicit-cotac FIELDS(numero-ordem)
       WHERE item-solicit-cotac.cdd-solicit = pCddSolicit NO-LOCK:
        RUN getPurchaseRequisitionInfo(INPUT item-solicit-cotac.numero-ordem).
    END.

    RETURN "OK":U.
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPurchaseRequisitionInfo DBOProgram 
PROCEDURE getPurchaseRequisitionInfo :
/*:T------------------------------------------------------------------------------
  Purpose:     Busca informaá‰es da ordem de compra com o registro dispon°vel
  Parameters:  piPurchaseRequisitionNumber: N£mero da ordem de compra
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM piPurchaseRequisitionNumber LIKE item-solicit-cotac.numero-ordem NO-UNDO.

    DEFINE VARIABLE iStatus AS INTEGER  NO-UNDO.
    DEFINE BUFFER bf-prazo-compra FOR prazo-compra.

    FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = piPurchaseRequisitionNumber NO-ERROR.
    IF AVAIL ordem-compra THEN DO:

        RUN getStatusQuotationProcessItem IN THIS-PROCEDURE(INPUT ordem-compra.numero-ordem,
                                                            OUTPUT iStatus,
                                                            OUTPUT TABLE RowErrors).
    
        CREATE ttPurchRequisitionInfo.
        BUFFER-COPY ordem-compra TO ttPurchRequisitionInfo NO-ERROR.
        assign ttPurchRequisitionInfo.it-codigo-desc = fnGetDescription (input "it-codigo")
               ttPurchRequisitionInfo.situacao-desc  = fnGetDescription (input "situacao-ordem")
               ttPurchRequisitionInfo.situacao-solic = iStatus
               ttPurchRequisitionInfo.situacao-solic-desc = ENTRY(iStatus, cStatusQuotationProcessItem).
    
        find first prazo-compra
            where prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock no-error.
        if  avail prazo-compra THEN DO:
            assign ttPurchRequisitionInfo.un = prazo-compra.un
                   ttPurchRequisitionInfo.data-entrega = prazo-compra.data-entrega.

            IF CAN-FIND(FIRST bf-prazo-compra 
                        WHERE bf-prazo-compra.numero-ordem = prazo-compra.numero-ordem
                          AND bf-prazo-compra.parcela <> prazo-compra.parcela) THEN DO:
                {utp/ut-liter.i Parcelada}
                ASSIGN ttPurchRequisitionInfo.data-entrega-desc = RETURN-VALUE.
            END.
            ELSE DO:
                ASSIGN ttPurchRequisitionInfo.data-entrega-desc = STRING(ttPurchRequisitionInfo.data-entrega,"99/99/9999").
            END.
        END.
    END.
 
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getStatusQuotationProcessItem DBOProgram 
PROCEDURE getStatusQuotationProcessItem :
/*:T------------------------------------------------------------------------------
  Purpose: Retorna a situaá∆o do item do processo de cotaá∆o.     
  Parameters:  pNrOrdem (input) - N£mero da ordem de compra     
               piStatus (output) - Situaá∆o do processo de cotaá∆o 
                                    1 - Sem solicitaá∆o
                                    2 - Com solicitaá∆o
                                    3 - Respondida Parcial
                                    4 - Respondida Total
                                    5 - Finalizada
              RowErrors (output) - temp-table de erros - (temp-table)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pNrOrdem    LIKE item-solicit-cotac.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAM piStatus    AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE lAnswered     AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lNotAnswered  AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lSend         AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lApproved     AS LOGICAL NO-UNDO.

    IF NOT CAN-FIND(FIRST ordem-compra 
         WHERE ordem-compra.numero-ordem = pNrOrdem) THEN DO:
        {method/svc/errors/inserr.i
                          &ErrorNumber="2"
                          &ErrorType="EMS"
                          &ErrorParameters=c-lb-ordem-compra}
    END.
    ELSE DO:
        /*Sem solicitaá∆o*/
        ASSIGN piStatus = 1.

        /*Verifica se a ordem est† cotada*/ 
        IF CAN-FIND (FIRST ordem-compra 
                     WHERE ordem-compra.numero-ordem = pNrOrdem
                       AND (ordem-compra.situacao = 3 /*Cotada*/
                         OR ordem-compra.situacao = 2 /*Confirmada*/
                         OR ordem-compra.situacao = 4 /*Eliminada*/
                         OR ordem-compra.situacao = 6 /*Recebida*/)) THEN
            ASSIGN lApproved = YES.
        ELSE DO:
            /*Se possuir vinculo com um processo de cotaá∆o*/
            IF CAN-FIND(FIRST bf-item-solicit-cotac
                        WHERE bf-item-solicit-cotac.numero-ordem = pNrOrdem) THEN DO:
                /*Verifica se h† ordens enviadas e n∆o enviadas*/
                FOR FIRST bf-item-solicit-cotac FIELDS(cdd-solicit numero-ordem)
                    WHERE bf-item-solicit-cotac.numero-ordem = pNrOrdem NO-LOCK:
                    
                    /*Verifica se h† cotaá∆o para a ordem*/
                    IF CAN-FIND(FIRST cotacao-item 
                                WHERE cotacao-item.numero-ordem = bf-item-solicit-cotac.numero-ordem
                                  AND cotacao-item.preco-fornec > 0) THEN
                        ASSIGN lAnswered = YES.
                    ELSE 
                        ASSIGN lNotAnswered = YES.

                    /*Se existir envio*/
                    IF CAN-FIND (FIRST item-envio-solicit-cotac
                                 WHERE item-envio-solicit-cotac.cdd-solicit  = bf-item-solicit-cotac.cdd-solicit
                                   AND item-envio-solicit-cotac.numero-ordem = bf-item-solicit-cotac.numero-ordem)THEN DO:
                        FOR EACH item-envio-solicit-cotac FIELDS(cdn-fornec)
                           WHERE item-envio-solicit-cotac.cdd-solicit  = bf-item-solicit-cotac.cdd-solicit
                             AND item-envio-solicit-cotac.numero-ordem = bf-item-solicit-cotac.numero-ordem NO-LOCK:
                            ASSIGN lSend = YES.
                            IF NOT CAN-FIND(FIRST cotacao-item 
                                        WHERE cotacao-item.numero-ordem = pNrOrdem
                                          AND cotacao-item.cod-emitente = item-envio-solicit-cotac.cdn-fornec
                                          AND cotacao-item.preco-fornec > 0) THEN
                                ASSIGN lNotAnswered = YES.
    
                        END.
                    END.
                END.
            END.
            /*Se n∆o tiver sido vinculada ainda*/
            ELSE DO: 
                /*Verifica se a ordem possui cotaá∆o respondidas e n∆o respondidas*/
                IF CAN-FIND(FIRST cotacao-item 
                            WHERE cotacao-item.numero-ordem = pNrOrdem
                              AND cotacao-item.preco-fornec > 0) THEN
                    ASSIGN lAnswered = YES.
                ELSE
                    ASSIGN lNotAnswered = YES.
            END.
        END.

        /*Se ordem estiver cotada*/
        IF lApproved THEN 
            ASSIGN piStatus = 5. /*Finalizado*/
        /*Se existir itens respondidos e n∆o exisitir itens n∆o respondidos*/
        ELSE IF lAnswered AND NOT lNotAnswered THEN
            ASSIGN piStatus = 4. /*Respondido Total*/
        /*Se existir itens respondidos e tambÇm exisitir itens n∆o respondidos*/
        ELSE IF lAnswered AND lNotAnswered THEN
            ASSIGN piStatus = 3. /*Respondido Parcial*/
        /*Se existir itens enviados*/
        ELSE IF lSend THEN
            ASSIGN piStatus = 2. /*Com solicitaá∆o*/
        /*Se n∆o se enquadrar nas opá‰es acima*/
        ELSE 
            ASSIGN piStatus = 1. /*Sem solicitaá∆o*/
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findByKey DBOProgram  
PROCEDURE findByKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice itmslctc_id2, 
               caso n∆o exista grava erro na RowErrors
  Parameters:  
               recebe valor do campo cdd-solicit
               recebe valor do campo numero-ordem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-solicit LIKE item-solicit-cotac.cdd-solicit NO-UNDO.
    DEFINE INPUT PARAMETER pnumero-ordem LIKE item-solicit-cotac.numero-ordem NO-UNDO.

    FIND FIRST bfitem-solicit-cotac 
         WHERE bfitem-solicit-cotac.cdd-solicit = pcdd-solicit 
           AND bfitem-solicit-cotac.numero-ordem = pnumero-ordem NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-solicit-cotac THEN DO:
        {utp/ut-liter.i "Item_do_Processo_de_Cotaá∆o"}
        {method/svc/errors/inserr.i
                &ErrorNumber="2"
                &ErrorType="EMS"
                &ErrorParameters="RETURN-VALUE"}
                          
        RETURN "NOK":U.
    END.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-solicit-cotac)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

FUNCTION fnGetDescription RETURNS CHARACTER
  (input pFieldName as char) :
/*------------------------------------------------------------------------------
  Purpose: Retornar a descriá∆o de campos    
  Parameters:  pFieldName    = Campo chave para  buscar a descriá∆o.
               c-Description = Descriá∆o para o pFieldName.         
  Notes:       
------------------------------------------------------------------------------*/
    def var c-Description    as char     no-undo.

    blockDescription:
    do  on error undo blockDescription, leave blockDescription 
        on stop  undo blockDescription, leave blockDescription
        on quit  undo blockDescription, leave blockDescription:

        case pFieldName:
            when "it-codigo" then do:
                {cdp/finditem.i ordem-compra.it-codigo}
                if  avail item then
                    assign c-Description = item.desc-item.
            end.
            when "situacao-ordem" then do:
                assign c-Description = {ininc/i02in274.i 4 ordem-compra.situacao}.
            end.
        end case.
    
        return c-Description.
    end.

END FUNCTION.
