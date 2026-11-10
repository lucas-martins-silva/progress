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

{include/i-prgvrs.i BOIN01030 2.00.00.016 } /*** "010016" 17/06/2025 16:40:42 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01030 MUT}
&ENDIF
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01030
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName fornec-solicit-cotac
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
&GLOBAL-DEFINE KeyField1 cdd-solicit /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField2 cdn-fornec /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
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
{inbo/boin01030.i RowObject}
{ccp/ccapi362.i1} /*Temp-tables para as informaá‰es de fornecedor*/
{fch/fchmat/fchmatpurchaserequisition.i1 ttPurchaseOrderlinesList}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-lb-vendedor      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-boin00885        AS HANDLE      NO-UNDO.

{utp/ut-liter.i "Vendedor"}
ASSIGN c-lb-vendedor = RETURN-VALUE.

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
        WHEN "assunto-email":U THEN ASSIGN pFieldValue = RowObject.assunto-email.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
        WHEN "des-e-mail":U THEN ASSIGN pFieldValue = RowObject.des-e-mail.
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
        WHEN "cdn-fornec":U THEN ASSIGN pFieldValue = RowObject.cdn-fornec.
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
  Purpose:     Retorna valores dos campos do °ndice frncslct_id2
  Parameters:  
               retorna valor do campo cdd-solicit
               retorna valor do campo cdn-fornec
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdd-solicit LIKE fornec-solicit-cotac.cdd-solicit NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-fornec LIKE fornec-solicit-cotac.cdn-fornec NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdd-solicit = RowObject.cdd-solicit
           pcdn-fornec = RowObject.cdn-fornec.

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
        WHEN "log-confir-entreg":U THEN ASSIGN pFieldValue = RowObject.log-confir-entreg.
        WHEN "log-confir-recebto":U THEN ASSIGN pFieldValue = RowObject.log-confir-recebto.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-livre-3":U THEN ASSIGN pFieldValue = RowObject.log-livre-3.
        WHEN "log-livre-4":U THEN ASSIGN pFieldValue = RowObject.log-livre-4.
        WHEN "log-planilha-envda":U THEN ASSIGN pFieldValue = RowObject.log-planilha-envda.
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
  Purpose:     Reposiciona registro com base no °ndice frncslct_id2
  Parameters:  
               recebe valor do campo cdd-solicit
               recebe valor do campo cdn-fornec
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-solicit LIKE fornec-solicit-cotac.cdd-solicit NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-fornec LIKE fornec-solicit-cotac.cdn-fornec NO-UNDO.

    FIND FIRST bffornec-solicit-cotac WHERE 
        bffornec-solicit-cotac.cdd-solicit = pcdd-solicit AND 
        bffornec-solicit-cotac.cdn-fornec = pcdn-fornec NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bffornec-solicit-cotac THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bffornec-solicit-cotac)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findByKey DBOProgram  
PROCEDURE findByKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice frncslct_id2,
               caso n∆o exista grava erro na RowErrors
  Parameters:  
               recebe valor do campo cdd-solicit
               recebe valor do campo cdn-fornec
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-solicit LIKE fornec-solicit-cotac.cdd-solicit NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-fornec  LIKE fornec-solicit-cotac.cdn-fornec  NO-UNDO.

    FIND FIRST bffornec-solicit-cotac WHERE 
        bffornec-solicit-cotac.cdd-solicit = pcdd-solicit AND 
        bffornec-solicit-cotac.cdn-fornec = pcdn-fornec NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bffornec-solicit-cotac THEN DO:
        {utp/ut-liter.i "Fornecedor_do_Processo_de_Cotaá∆o"}
        {method/svc/errors/inserr.i
                &ErrorNumber="2"
                &ErrorType="EMS"
                &ErrorParameters="RETURN-VALUE"}
        RETURN "NOK":U.
    END.
        

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bffornec-solicit-cotac)).
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
    
    DEFINE VARIABLE c-contact-email   AS CHARACTER      NO-UNDO.
    DEFINE VARIABLE cLbVendor         AS CHARACTER      NO-UNDO.
    DEFINE VARIABLE i-index-separador AS INTEGER        NO-UNDO.
    DEFINE VARIABLE i-inicio          AS INTEGER INIT 1 NO-UNDO.
    DEFINE VARIABLE l-email-valido    AS LOGICAL        NO-UNDO.
    DEFINE VARIABLE l-finaliza-verif  AS LOGICAL        NO-UNDO.
    DEFINE VARIABLE lAnswered         AS LOGICAL        NO-UNDO.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    IF pType = "Create":U OR pType = "Update":U THEN DO:
        IF NOT CAN-FIND(FIRST solicit-cotac WHERE solicit-cotac.cdd-solicit = RowObject.cdd-solicit) THEN DO:
            {utp/ut-liter.i Solicitaá∆o_Cotaá∆o * }
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

        IF RowObject.des-e-mail <> "":U AND RowObject.des-e-mail <> ? THEN DO:
            REPEAT:
                ASSIGN i-index-separador = INDEX(RowObject.des-e-mail, ";", i-inicio).
            
                IF i-index-separador = 0 THEN DO:
                    ASSIGN c-contact-email = SUBSTRING(RowObject.des-e-mail, i-inicio, LENGTH(RowObject.des-e-mail) - 1).
                    RUN pi-valida-email IN THIS-PROCEDURE (INPUT c-contact-email,
                                                           OUTPUT l-email-valido).
                    ASSIGN l-finaliza-verif = YES.
                END.
                ELSE DO:
                    ASSIGN c-contact-email = SUBSTRING(RowObject.des-e-mail, i-inicio, LENGTH(SUBSTRING(RowObject.des-e-mail, i-inicio, i-index-separador - i-inicio)))
                           i-inicio = i-index-separador + 1. 
                    RUN pi-valida-email IN THIS-PROCEDURE (INPUT c-contact-email,
                                                           OUTPUT l-email-valido).
                END.
    
                IF NOT l-email-valido THEN DO:
                    {method/svc/errors/inserr.i 
                            &ErrorNumber="55139" /* Endereáo E-mail &1 inv†lido */
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="c-contact-email"}
                END.
                            
                IF l-finaliza-verif THEN
                    LEAVE.
            END.
        END.
    END.
	IF pType = "Delete":U THEN DO:

        {utp/ut-liter.i "Fornecedor_do_processo_de_cotaá∆o" * }
        ASSIGN cLbVendor = RETURN-VALUE.

        /*Verifica se existe envios para o fornecedor*/
        IF CAN-FIND( FIRST item-envio-solicit-cotac 
                     WHERE item-envio-solicit-cotac.cdd-solicit = RowObject.cdd-solicit
                       AND item-envio-solicit-cotac.cdn-fornec  = RowObject.cdn-fornec) THEN DO:
            /*&1 n∆o pode ser eliminado(a) ! &1 possui relacionamentos &2.*/
            {utp/ut-liter.i "com_envio_do_processo_de_cotaá∆o" * }
            {method/svc/errors/inserr.i 
                    &ErrorNumber="5906" 
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="cLbVendor + '~~~~' + RETURN-VALUE"}
        END.

        /*Verifica se existem respostas para as ordens desse processo para o fornecedor*/
        FOR EACH item-solicit-cotac NO-LOCK
           WHERE item-solicit-cotac.cdd-solicit = RowObject.cdd-solicit:
            IF CAN-FIND (FIRST cotacao-item 
                         WHERE cotacao-item.numero-ordem = item-solicit-cotac.numero-ordem
                           AND cotacao-item.cod-emitente = RowObject.cdn-fornec
                           AND cotacao-item.data-cotacao <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF) THEN DO:
                ASSIGN lAnswered = YES.
                LEAVE.
            END.
        END.
        IF lAnswered THEN DO:
            /*&1 n∆o pode ser eliminado(a) ! &1 possui relacionamentos &2.*/
            {utp/ut-liter.i "com_Cotaá‰es_do_Item" * }
            {method/svc/errors/inserr.i 
                    &ErrorNumber="5906" 
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="cLbVendor + '~~~~' + RETURN-VALUE"}
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSuggestedVendors DBOProgram 
PROCEDURE getSuggestedVendors :
/*------------------------------------------------------------------------------
  Purpose: Retornar os fornecedores sugeridos com base nas ordens de compra    
  Parameters: ttPurchaseOrderlinesList (input): lista com n£meros das ordens - temp-table
              ttVendorList (output): lista com os fornecedores - temp-table
              ttContact (output): lista com os contatos dos fornecedores - temp-table
              RowErrors (output): lista com os erros - temp-table
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttPurchaseOrderlinesList.
    DEFINE OUTPUT PARAMETER TABLE FOR ttVendorList.
    DEFINE OUTPUT PARAMETER TABLE FOR ttContact.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-boin00885) THEN
        RUN inbo/boin00885.p PERSISTENT SET h-boin00885.

    EMPTY TEMP-TABLE ttVendorListAux.
    FOR EACH ttPurchaseOrderlinesList NO-LOCK:
        RUN getVendorByRequisition (INPUT ttPurchaseOrderlinesList.numero-ordem,
                                    INPUT-OUTPUT TABLE ttVendorListAux).
    END.

    /*Ordenar os fornecedores*/
    FOR EACH ttVendorListAux NO-LOCK
          BY ttVendorListAux.l-fornec-clic 
          BY ttVendorListAux.cod-emitente
          BY ttVendorListAux.cgc:

        /*Busca os contatos do fornecedor*/
        RUN getVendorContact (INPUT ttVendorListAux.cod-emitente,
                              OUTPUT TABLE ttContactAux).
        FOR EACH ttContactAux NO-LOCK:
            IF NOT CAN-FIND(FIRST ttContact
                            WHERE ttContact.cod-emitente = ttContactAux.cod-emitente
                              AND ttContact.e-mail = ttContactAux.e-mail) THEN DO:
                CREATE ttContact.
                BUFFER-COPY ttContactAux TO ttContact NO-ERROR.
            END.
        END.

        CREATE ttVendorList.
        BUFFER-COPY ttVendorListAux TO ttVendorList NO-ERROR.
    END.

    IF VALID-HANDLE(h-boin00885) THEN DO:
       DELETE PROCEDURE h-boin00885.
       ASSIGN h-boin00885 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQuotationProcessVendors DBOProgram 
PROCEDURE getQuotationProcessVendors :
/*------------------------------------------------------------------------------
  Purpose: Retornar os fornecedores do processo de cotaá∆o   
  Parameters: pCddSolicit: C¢digo do processo de cotaá∆o - decimal
              ttVendorList: lista com os fornecedores - temp-table
              ttContact: Lista com os contatos doe fornecedores - temp-table
              RowErrors: lista com os erros - temp-table
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAM pCddSolicit LIKE item-solicit-cotac.cdd-solicit NO-UNDO.
   DEFINE OUTPUT PARAMETER TABLE FOR ttVendorList.
   DEFINE OUTPUT PARAMETER TABLE FOR ttContact.
   DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

   DEFINE VARIABLE c-email-para AS CHARACTER   NO-UNDO.

   EMPTY TEMP-TABLE ttVendorListAux.
   FOR EACH fornec-solicit-cotac FIELDS(cdn-fornec des-e-mail) NO-LOCK
      WHERE fornec-solicit-cotac.cdd-solicit = pCddSolicit:
       {cdp/findemitente.i fornec-solicit-cotac.cdn-fornec}

       CREATE ttVendorListAux.
       ASSIGN ttVendorListAux.cod-emitente = emitente.cod-emitente
              ttVendorListAux.nome-abrev   = emitente.nome-abrev
              ttVendorListAux.nome-emit    = emitente.nome-emit
              ttVendorListAux.e-mail       = fornec-solicit-cotac.des-e-mail
              ttVendorListAux.cgc          = emitente.cgc.
   END.

   /* REMOVIDO DA PRIMEIRA VERS«O A SER DISPONIBILIZADA*/
   /* Busca fornecedores do clicbusiness */
   /*EMPTY TEMP-TABLE tt-cod-itens.
   FOR EACH item-solicit-cotac FIELDS(numero-ordem)
      WHERE item-solicit-cotac.cdd-solicit = pCddSolicit NO-LOCK:
      FOR FIRST ordem-compra FIELDS(it-codigo)
          WHERE ordem-compra.numero-ordem = item-solicit-cotac.numero-ordem NO-LOCK:
           IF NOT CAN-FIND(FIRST tt-cod-itens
                           WHERE tt-cod-itens.it-codigo = ordem-compra.it-codigo) THEN DO:
               CREATE tt-cod-itens.
               ASSIGN tt-cod-itens.it-codigo = ordem-compra.it-codigo.
           END.
      END.
   END.

   IF NOT VALID-HANDLE(h-boin00885) THEN
       RUN inbo/boin00885.p PERSISTENT SET h-boin00885.

   RUN piGetClicbusinessVendor (INPUT TABLE tt-cod-itens).

   IF VALID-HANDLE(h-boin00885) THEN DO:
      DELETE PROCEDURE h-boin00885.
      ASSIGN h-boin00885 = ?.
   END.*/

   /*Ordenar os fornecedores*/
   FOR EACH ttVendorListAux NO-LOCK
         BY ttVendorListAux.l-fornec-clic 
         BY ttVendorListAux.cod-emitente
         BY ttVendorListAux.cgc:

       CREATE ttVendorList.
       BUFFER-COPY ttVendorListAux TO ttVendorList NO-ERROR.
   END.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getVendorByRequisition DBOProgram 
PROCEDURE getVendorByRequisition :
/*------------------------------------------------------------------------------
  Purpose: Retornar os fornecedores do item da ordem de compra     
  Parameters: piPurchaseRequisitionNumber (input): N£mero da ordem de compra - inteiro
              ttVendorListAux (input-output): temp-table com os fornecedores - temp-table
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piPurchaseRequisitionNumber LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttVendorListAux.
 
    DEFINE VARIABLE l-ativo AS LOGICAL NO-UNDO.

	blockGetVendorByRequisition:
    DO TRANSACTION
       ON ERROR UNDO, LEAVE blockGetVendorByRequisition 
       ON STOP  UNDO, LEAVE blockGetVendorByRequisition
       ON QUIT  UNDO, LEAVE blockGetVendorByRequisition:
	
        {cdp/findordemcompra.i piPurchaseRequisitionNumber}
        IF NOT AVAIL ordem-compra THEN RETURN.

        EMPTY TEMP-TABLE tt-cod-itens.

		{cdp/findparamcompra.i}

		IF  param-compra.perm-cot-for = YES THEN
			ASSIGN l-ativo = ?.
		else
			ASSIGN l-ativo = NO.

        FOR FIRST ITEM FIELDS(fm-codigo) NO-LOCK
            WHERE ITEM.it-codigo = ordem-compra.it-codigo:
            FOR FIRST familia FIELDS(descricao) NO-LOCK
                WHERE familia.fm-codigo = ITEM.fm-codigo: END.
        END.

		IF param-compra.cria-cot-pen 
		AND CAN-FIND (FIRST cotacao-item 
						WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
						  AND cotacao-item.data-cotacao  = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF)
		THEN DO:
			FOR EACH cotacao-item fields(cod-emitente) NO-LOCK
				WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
				  AND cotacao-item.data-cotacao = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF:

				{cdp/findemitente.i cotacao-item.cod-emitente}
                IF NOT CAN-FIND(FIRST ttVendorListAux
                                WHERE ttVendorListAux.cod-emitente = cotacao-item.cod-emitente) THEN DO:
    				CREATE ttVendorListAux.
    				ASSIGN ttVendorListAux.numero-ordem = ordem-compra.numero-ordem
    					   ttVendorListAux.cod-emitente = cotacao-item.cod-emitente
    					   ttVendorListAux.it-codigo    = ordem-compra.it-codigo
    					   ttVendorListAux.nome-abrev   = emitente.nome-abrev
    					   ttVendorListAux.nome-emit    = emitente.nome-emit
                           ttVendorListAux.e-mail       = emitente.e-mail
                           ttVendorListAux.cgc          = emitente.cgc
                           ttVendorListAux.fm-codigo    = item.fm-codigo WHEN AVAIL ITEM
                           ttVendorListAux.desc-familia = familia.descricao WHEN AVAIL familia.
                END.
			END.
        END.
		ELSE DO:  
		    IF CAN-FIND (FIRST item-fornec 
                         WHERE item-fornec.it-codigo = ordem-compra.it-codigo 
                           AND item-fornec.ativo <> l-ativo) THEN DO:
		 
                FOR EACH item-fornec FIELDS(cod-emitente it-codigo) 
                   WHERE item-fornec.it-codigo = ordem-compra.it-codigo 
                     AND item-fornec.ativo <> l-ativo NO-LOCK:
            
                    {cdp/findemitente.i item-fornec.cod-emitente}
    
                    IF NOT CAN-FIND(FIRST ttVendorListAux
                                    WHERE ttVendorListAux.cod-emitente = item-fornec.cod-emitente) THEN DO:
                        CREATE ttVendorListAux.
                        ASSIGN ttVendorListAux.numero-ordem = ordem-compra.numero-ordem
                               ttVendorListAux.cod-emitente = item-fornec.cod-emitente
                               ttVendorListAux.it-codigo    = item-fornec.it-codigo
                               ttVendorListAux.nome-abrev   = emitente.nome-abrev
                               ttVendorListAux.nome-emit    = emitente.nome-emit
                               ttVendorListAux.e-mail       = emitente.e-mail
                               ttVendorListAux.cgc          = emitente.cgc
                               ttVendorListAux.fm-codigo    = item.fm-codigo WHEN AVAIL ITEM
                               ttVendorListAux.desc-familia = familia.descricao WHEN AVAIL familia.
                    END.
                END.
            END.
		END.
        /*Se ordem j† possuir cotaá∆o respondida o forncedor deve ser adicionado*/
        IF CAN-FIND(FIRST cotacao-item NO-LOCK
				    WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
				      AND cotacao-item.data-cotacao <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF) THEN DO:
            FOR EACH cotacao-item FIELDS(cod-emitente) NO-LOCK
				WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
				  AND cotacao-item.data-cotacao <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF:

				{cdp/findemitente.i cotacao-item.cod-emitente}
		        
                IF NOT CAN-FIND(FIRST ttVendorListAux
                                WHERE ttVendorListAux.cod-emitente = cotacao-item.cod-emitente) THEN DO:
    				CREATE ttVendorListAux.
    				ASSIGN ttVendorListAux.numero-ordem = ordem-compra.numero-ordem
    					   ttVendorListAux.cod-emitente = cotacao-item.cod-emitente
    					   ttVendorListAux.it-codigo    = ordem-compra.it-codigo
    					   ttVendorListAux.nome-abrev   = emitente.nome-abrev
    					   ttVendorListAux.nome-emit    = emitente.nome-emit
                           ttVendorListAux.e-mail       = emitente.e-mail
                           ttVendorListAux.cgc          = emitente.cgc
                           ttVendorListAux.fm-codigo    = item.fm-codigo WHEN AVAIL ITEM
                           ttVendorListAux.desc-familia = familia.descricao WHEN AVAIL familia.
                END.
			END.
        END.
        /* buscar fornecedores do clicbusiness */
        /* REMOVIDO DA PRIMEIRA VERS«O A SER DISPONIBILIZADA*/
        /*CREATE tt-cod-itens.
        ASSIGN tt-cod-itens.it-codigo = ordem-compra.it-codigo.
        RUN piGetClicbusinessVendor (INPUT TABLE tt-cod-itens).*/
        
    END.
    RETURN "OK".
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGetClicbusinessVendor DBOProgram 
PROCEDURE piGetClicbusinessVendor :
/*------------------------------------------------------------------------------
  Purpose: Retornar as informaá‰es dos fornecedores do Clicbusiness    
  Parameters: tt-cod-itens (input) - Lista de itens - temp-table
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-cod-itens.

    IF NOT AVAIL param-compra THEN
        FIND FIRST param-compra NO-LOCK NO-ERROR.
    IF AVAIL param-compra THEN DO: 
        /*Verifica se a integraá∆o com o clicbusiness est† ativa*/
        IF SUBSTRING(param-compra.char-2,104,1) <> "N":U THEN DO:
            
            EMPTY TEMP-TABLE tt-fornec-clicbusiness.
            RUN pi-retorna-fornecedores-item IN h-boin00885 (INPUT TABLE tt-cod-itens,
                                                             OUTPUT TABLE tt-fornec-clicbusiness).

            FOR EACH tt-fornec-clicbusiness:
                IF NOT CAN-FIND(FIRST ttVendorListAux
                                WHERE ttVendorListAux.cgc = tt-fornec-clicbusiness.cod-cgc) THEN DO:
                    
                    FIND FIRST familia NO-LOCK
                            WHERE familia.fm-codigo = tt-fornec-clicbusiness.cod-familia NO-ERROR.
    
                    
                    CREATE ttVendorListAux.
                    ASSIGN ttVendorListAux.numero-ordem = ordem-compra.numero-ordem WHEN AVAIL ordem-compra
                           ttVendorListAux.cod-emitente = 0
                           ttVendorListAux.it-codigo    = ordem-compra.it-codigo WHEN AVAIL ordem-compra
                           ttVendorListAux.nome-abrev   = tt-fornec-clicbusiness.nom-razao-social
                           ttVendorListAux.nome-emit    = tt-fornec-clicbusiness.nom-razao-social
                           ttVendorListAux.e-mail       = tt-fornec-clicbusiness.des-e-mail
                           ttVendorListAux.cgc          = tt-fornec-clicbusiness.cod-cgc
                           ttVendorListAux.l-fornec-clic = YES
                           ttVendorListAux.fm-codigo    = tt-fornec-clicbusiness.cod-familia
                           ttVendorListAux.desc-familia = familia.descricao WHEN AVAIL familia
                           ttVendorListAux.reputacao    = tt-fornec-clicbusiness.cdd-reputacao.
                END.
                ELSE DO:
                    /* editar fornecedor ems */
                    FOR FIRST ttVendorListAux EXCLUSIVE-LOCK
                        WHERE ttVendorListAux.cgc = tt-fornec-clicbusiness.cod-cgc:
                        ASSIGN ttVendorListAux.reputacao = tt-fornec-clicbusiness.cdd-reputacao.
                    END.
                END.
            END.
        END. /* verifica integraá∆o com clicbusiness */
    END.
    RETURN "OK".
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-email DBOProgram 
PROCEDURE pi-valida-email :
/*------------------------------------------------------------------------------
  Purpose: Verifica se o e-mail informado Ç v†lido   
  Parameters: pc-email (input) - E-mail a ser validado
              pl-valido (output) - Indica se o e-mail Ç v†lido
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-email AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-valido AS LOGICAL NO-UNDO.

    DEFINE VARIABLE i-index-email AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-index-dot   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-after-dot   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-email2      AS CHARACTER   NO-UNDO.

    ASSIGN i-index-email = INDEX(pc-email, "@":U).
    
    IF i-index-email = 0 OR pc-email = "" OR pc-email = ? THEN
        ASSIGN pl-valido = NO.
    ELSE DO:
        ASSIGN c-email2 = SUBSTRING(pc-email, i-index-email + 1, (LENGTH(pc-email) - i-index-email))
               i-index-dot = INDEX(c-email2, ".":U).
    
        IF i-index-dot = 0 THEN
            ASSIGN pl-valido = NO.
        ELSE DO:
            ASSIGN c-after-dot =  SUBSTRING(c-email2, i-index-dot + 1, (LENGTH(c-email2) - i-index-dot)).
            IF c-after-dot = "":U THEN
                ASSIGN pl-valido = NO.
            ELSE 
                ASSIGN pl-valido = YES.
        END.
    END.  
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getVendorContact DBOProgram 
PROCEDURE getVendorContact :
/*------------------------------------------------------------------------------
  Purpose: Buscar os contatos dos fornecedores    
  Parameters: piCodEmitente (input) - C¢digo do fornecedor - inteiro
              ttContactAux (output) - Contatos do fornecedor - temp-table
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piCodEmitente LIKE emitente.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttContactAux.  

    EMPTY TEMP-TABLE ttContactAux NO-ERROR.
    /*Clicbusiness e fornecedor 0 ser∆o desconsiderados*/
    IF piCodEmitente <> 0 THEN DO:
        /*Busca fornecedores com cargo de vendedor*/
        IF CAN-FIND(FIRST cont-emit 
                    WHERE cont-emit.cod-emitente = piCodEmitente
                      AND cont-emit.cargo = c-lb-vendedor) THEN DO:
            FOR EACH cont-emit NO-LOCK 
                WHERE cont-emit.cod-emitente = piCodEmitente
                  AND cont-emit.cargo = c-lb-vendedor:
                CREATE ttContactAux.
                BUFFER-COPY cont-emit TO ttContactAux NO-ERROR.
            END.
        END.
        /*Se n∆o existir, busca e-mail do fornecedor*/
        ELSE DO:
            FOR FIRST emitente FIELDS(e-mail)
                WHERE emitente.cod-emitente = piCodEmitente:
                IF emitente.e-mail <> "" THEN DO:
                    CREATE ttContactAux.
                    ASSIGN ttContactAux.cod-emitente = piCodEmitente
                           ttContactAux.e-mail = emitente.e-mail.
                END.
            END.
        END.
    END.
    RETURN "OK".
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
