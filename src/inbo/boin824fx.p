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
&GLOBAL-DEFINE DBOName BOIN824fx
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName fda-lote-param-espcif
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
{inbo/boin824fx.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

{fch/fchmat/fchmatspecificparameterslot.i ttSpecificParametersLotVO} 
{fch/fchmat/fchmatgeneralparameters.i ttGeneralParametersVO} 
{fch/fchmat/fchmatspecificparameters.i ttSpecificParametersVO} 
{fch/fchmat/fchmatstatelot.i ttStateLotVO} 
{fch/fchmat/fchmatspecie.i ttSpecieVO} 

DEFINE VARIABLE cType AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cInitialItemCode   AS CHARACTER FORMAT "X(16)" NO-UNDO.
DEFINE VARIABLE cFinalItemCode     AS CHARACTER FORMAT "X(16)" NO-UNDO.
DEFINE VARIABLE cInitialFamilyCode AS CHARACTER FORMAT "X(8)"  NO-UNDO.
DEFINE VARIABLE cFinalFamilyCode   AS CHARACTER FORMAT "X(8)"  NO-UNDO.
DEFINE VARIABLE cInitialSiteCode   AS CHARACTER FORMAT "X(5)"  NO-UNDO.
DEFINE VARIABLE cFinalSiteCode     AS CHARACTER FORMAT "X(5)"  NO-UNDO.
DEFINE VARIABLE lConstraint        AS LOGICAL   INITIAL YES    NO-UNDO.
DEFINE VARIABLE cTypeConstraint    AS CHARACTER FORMAT "X(16)" NO-UNDO.


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
        WHEN "cdn-empresa":U THEN ASSIGN pFieldValue = RowObject.cdn-empresa.
        WHEN "cod-aprov":U THEN ASSIGN pFieldValue = RowObject.cod-aprov-lote.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-inspecao":U THEN ASSIGN pFieldValue = RowObject.cod-inspec-lote.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-rejeicao":U THEN ASSIGN pFieldValue = RowObject.cod-rej-lote.
        WHEN "cod-status":U THEN ASSIGN pFieldValue = RowObject.cod-status.
        WHEN "cod-tip-operac":U THEN ASSIGN pFieldValue = RowObject.cod-tip-operac.
        WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
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
        WHEN "num-amostra":U THEN ASSIGN pFieldValue = RowObject.num-amostra.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ltprmspc-id
  Parameters:  
               retorna valor do campo it-codigo
               retorna valor do campo fm-codigo
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE fda-lote-param-espcif.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pfm-codigo LIKE fda-lote-param-espcif.fm-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE fda-lote-param-espcif.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pfm-codigo = RowObject.fm-codigo
           pcod-estabel = RowObject.cod-estabel.

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
        WHEN "log-amostra":U THEN ASSIGN pFieldValue = RowObject.log-amostra.
        WHEN "log-avaliac":U THEN ASSIGN pFieldValue = RowObject.log-avaliac-lote.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-lote":U THEN ASSIGN pFieldValue = RowObject.log-lote.
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
  Purpose:     Reposiciona registro com base no °ndice ltprmspc-id
  Parameters:  
               recebe valor do campo it-codigo
               recebe valor do campo fm-codigo
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE fda-lote-param-espcif.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pfm-codigo LIKE fda-lote-param-espcif.fm-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE fda-lote-param-espcif.cod-estabel NO-UNDO.

    FIND FIRST bffda-lote-param-espcif WHERE 
        bffda-lote-param-espcif.it-codigo = pit-codigo AND 
        bffda-lote-param-espcif.fm-codigo = pfm-codigo AND 
        bffda-lote-param-espcif.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bffda-lote-param-espcif THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bffda-lote-param-espcif)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSpecificParameters DBOProgram 
PROCEDURE setConstraintSpecificParameters:
    DEFINE INPUT PARAMETER pInitialItemCode   AS CHARACTER FORMAT "X(16)" NO-UNDO.
    DEFINE INPUT PARAMETER pFinalItemCode     AS CHARACTER FORMAT "X(16)" NO-UNDO.
    DEFINE INPUT PARAMETER pInitialFamilyCode AS CHARACTER FORMAT "X(8)"  NO-UNDO.
    DEFINE INPUT PARAMETER pFinalFamilyCode   AS CHARACTER FORMAT "X(8)"  NO-UNDO.
    DEFINE INPUT PARAMETER pInitialSiteCode   AS CHARACTER FORMAT "X(5)"  NO-UNDO.
    DEFINE INPUT PARAMETER pFinalSiteCode     AS CHARACTER FORMAT "X(5)"  NO-UNDO.
    
    ASSIGN cInitialItemCode   = pInitialItemCode
           cFinalItemCode     = pFinalItemCode
           cInitialFamilyCode = pInitialFamilyCode
           cFinalFamilyCode   = pFinalFamilyCode
           cInitialSiteCode   = pInitialSiteCode
           cFinalSiteCode     = pFinalSiteCode
           lConstraint        = NO.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintType DBOProgram 
PROCEDURE setConstraintType:
    DEFINE INPUT PARAMETER pTypeConstraint   AS CHARACTER FORMAT "X(16)" NO-UNDO.
  
    ASSIGN cTypeConstraint = pTypeConstraint.         

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSpecificParameters DBOProgram 
PROCEDURE getSpecificParameters:
    DEF OUTPUT PARAM TABLE FOR ttSpecificParametersVO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.
	
	  EMPTY TEMP-TABLE ttSpecificParametersVO NO-ERROR.
    
    FOR EACH fda-lote-param-espcif NO-LOCK 
       WHERE lConstraint 
          OR (fda-lote-param-espcif.it-codigo  >= cInitialItemCode    AND 
              fda-lote-param-espcif.it-codigo   <= cFinalItemCode     AND 
              fda-lote-param-espcif.fm-codigo   >= cInitialFamilyCode AND 
              fda-lote-param-espcif.fm-codigo   <= cFinalFamilyCode   AND 
              fda-lote-param-espcif.cod-estabel >= cInitialSiteCode   AND 
              fda-lote-param-espcif.cod-estabel <= cFinalSiteCode):
    
        CREATE ttSpecificParametersVO.
        ASSIGN ttSpecificParametersVO.initialState        = fda-lote-param-espcif.cod-status
               ttSpecificParametersVO.inspectionState     = fda-lote-param-espcif.cod-inspec-lote
               ttSpecificParametersVO.aprovedState        = fda-lote-param-espcif.cod-aprov-lote
               ttSpecificParametersVO.reprovedState       = fda-lote-param-espcif.cod-rej-lote
               ttSpecificParametersVO.isAllowReanalysis   = fda-lote-param-espcif.log-avaliac-lote
               ttSpecificParametersVO.isSuggestDirectCode = fda-lote-param-espcif.log-lote
               ttSpecificParametersVO.companyCodeRules    = fda-lote-param-espcif.cdn-empresa
               ttSpecificParametersVO.siteCodeRules       = fda-lote-param-espcif.cod-estab-operac
               ttSpecificParametersVO.operationType       = fda-lote-param-espcif.cod-tip-operac
               ttSpecificParametersVO.itemCode            = fda-lote-param-espcif.it-codigo
               ttSpecificParametersVO.familyCode          = fda-lote-param-espcif.fm-codigo
               ttSpecificParametersVO.siteCode            = fda-lote-param-espcif.cod-estabel
               ttSpecificParametersVO.hasSampleType       = fda-lote-param-espcif.log-amostra
               ttSpecificParametersVO.sampleType          = fda-lote-param-espcif.num-amostra.

        FOR FIRST estabelec FIELDS(nome)
             WHERE estabelec.cod-estabel = fda-lote-param-espcif.cod-estab-operac NO-LOCK:
            ASSIGN ttSpecificParametersVO.siteCodeRulesDescription = estabelec.nome.
        END.

        FOR FIRST empresa FIELDS (nome)
            WHERE empresa.ep-codigo = fda-lote-param-espcif.cdn-empresa NO-LOCK:
            ASSIGN ttSpecificParametersVO.companyCodeRulesDescription = empresa.nome.
        END.

        FOR FIRST  config-tip-operac FIELDS(des-tip-operac)
             WHERE config-tip-operac.cod-tip-operac = fda-lote-param-espcif.cod-tip-operac NO-LOCK:
            ASSIGN ttSpecificParametersVO.operationTypeDescription =  config-tip-operac.des-tip-operac.
        END.

    END.
	
	  ASSIGN lConstraint = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSpecificParameters DBOProgram 
PROCEDURE setSpecificParameters:
    DEF INPUT PARAM TABLE FOR ttSpecificParametersVO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.
    
   for each ttSpecificParametersVO:
       ASSIGN ttSpecificParametersVO.itemCode  = IF ttSpecificParametersVO.itemCode = ? THEN "" ELSE ttSpecificParametersVO.itemCode 
              ttSpecificParametersVO.familyCode = IF ttSpecificParametersVO.familyCode = ? THEN "" ELSE ttSpecificParametersVO.familyCode
              ttSpecificParametersVO.siteCode = IF ttSpecificParametersVO.siteCode = ? THEN "" ELSE ttSpecificParametersVO.siteCode.
       FIND FIRST fda-lote-param-espcif 
            WHERE fda-lote-param-espcif.cod-estabel  = ttSpecificParametersVO.siteCode 
              AND fda-lote-param-espcif.fm-codigo = ttSpecificParametersVO.familyCode
              AND fda-lote-param-espcif.it-codigo = ttSpecificParametersVO.itemCode EXCLUSIVE-LOCK NO-ERROR.
              
       IF cTypeConstraint = "" THEN DO:              
           IF NOT AVAIL fda-lote-param-espcif THEN
              ASSIGN cType = "Create":U.
           ELSE
               ASSIGN cType = "Update":U.
       END.
       ELSE DO:
           ASSIGN cType           = cTypeConstraint
                  cTypeConstraint = "".
       END.
       RUN validateFields (INPUT 2).
       IF RETURN-VALUE = "OK":U THEN DO:
           IF cType = "Create":U THEN
               create fda-lote-param-espcif.

           ASSIGN fda-lote-param-espcif.cod-status        =  ttSpecificParametersVO.initialState         
                  fda-lote-param-espcif.cod-inspec-lote   =  ttSpecificParametersVO.inspectionState      
                  fda-lote-param-espcif.cod-aprov-lote    =  ttSpecificParametersVO.aprovedState      
                  fda-lote-param-espcif.cod-rej-lote      =  ttSpecificParametersVO.reprovedState      
                  fda-lote-param-espcif.log-avaliac-lote       =  ttSpecificParametersVO.isAllowReanalysis     
                  fda-lote-param-espcif.log-lote          =  ttSpecificParametersVO.isSuggestDirectCode
                  fda-lote-param-espcif.cdn-empresa       =  ttSpecificParametersVO.companyCodeRules     
                  fda-lote-param-espcif.cod-estab-operac  =  ttSpecificParametersVO.siteCodeRules      
                  fda-lote-param-espcif.cod-tip-operac    =  ttSpecificParametersVO.operationType     
                  fda-lote-param-espcif.it-codigo         =  ttSpecificParametersVO.itemCode         
                  fda-lote-param-espcif.fm-codigo         =  ttSpecificParametersVO.familyCode  
                  fda-lote-param-espcif.cod-estabel       =  ttSpecificParametersVO.siteCode      
                  fda-lote-param-espcif.log-amostra       =  ttSpecificParametersVO.hasSampleType      
                  fda-lote-param-espcif.num-amostra       =  ttSpecificParametersVO.sampleType.         
       END.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFields DBOProgram 
PROCEDURE validateFields:
    DEF INPUT PARAM i-tipo AS INTEGER NO-UNDO. /*1 = Geral, 2 = Espec°fico*/
    
    DEFINE VARIABLE lb-config-operac AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lb-estabel       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lb-familia       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lb-item          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lb-tipo-lote     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lb-tipo-refer    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lb-msg           AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lb-help          AS CHARACTER   NO-UNDO.
    define variable lb-estado        as character   no-undo.
    define variable lb-nome-estado   as character   no-undo.
    
    EMPTY TEMP-TABLE RowErrors NO-ERROR.
    
    {utp/ut-table.i mgind config-operac 1}
     ASSIGN lb-config-operac = RETURN-VALUE.

    IF i-tipo = 1 THEN DO:
        IF NOT CAN-FIND (FIRST config-operac 
             WHERE config-operac.cod-tip-operac = ttGeneralParametersVO.operationType
               AND config-operac.cdn-empresa = ttGeneralParametersVO.companyCodeRules
               AND config-operac.cod-estab = ttGeneralParametersVO.siteCodeRules) THEN DO:
            
             {method/svc/errors/inserr.i &ErrorNumber="2"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="lb-config-operac"}
             return "NOK":U.
        END.

        if cType = "Create":u or
           cType = "Update":u then do:

            find first fda-lote-estado where 
                       fda-lote-estado.cod-status = ttGeneralParametersVO.inspectionState no-lock no-error.
            if avail fda-lote-estado and
               fda-lote-estado.idi-tip-estado <> 3 then do:     
    
                {utp/ut-liter.i Estado_Inspeá∆o}
                assign lb-estado      = return-value
                       lb-nome-estado = {ininc/i01in820.i 4 3}.
    
                {method/svc/errors/inserr.i &ErrorNumber="18440"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="lb-estado + '~~~~' + lb-nome-estado"}
    
            end.
    
            find first fda-lote-estado where 
                       fda-lote-estado.cod-status = ttGeneralParametersVO.aprovedState no-lock no-error.
            if avail fda-lote-estado and
               fda-lote-estado.idi-tip-estado <> 1 then do:
    
                {utp/ut-liter.i Estado_Aprovado}
                assign lb-estado      = return-value
                       lb-nome-estado = {ininc/i01in820.i 4 1}.
    
                {method/svc/errors/inserr.i &ErrorNumber="18440"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="lb-estado + '~~~~' + lb-nome-estado"}
    
            end.

            find first fda-lote-estado where 
                       fda-lote-estado.cod-status = ttGeneralParametersVO.reprovedState no-lock no-error.
            if avail fda-lote-estado and
               fda-lote-estado.idi-tip-estado <> 2 then do:
    
                {utp/ut-liter.i Estado_Reprovado}
                assign lb-estado      = return-value
                       lb-nome-estado = {ininc/i01in820.i 4 2}.
    
                {method/svc/errors/inserr.i &ErrorNumber="18440"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="lb-estado + '~~~~' + lb-nome-estado"}
    
            end.
        end.
    END.
    ELSE DO:
        IF cType = "Create":U THEN DO:
            IF ttSpecificParametersVO.siteCode = "" AND
               ttSpecificParametersVO.familyCode = "" AND
               ttSpecificParametersVO.itemCode = "" THEN DO:
                {utp/ut-liter.i "Valores em branco n∆o permitidos."}
                ASSIGN lb-msg = RETURN-VALUE.
                {utp/ut-liter.i "ê necess†rio que ao menos um dos campos possua valor."}
                ASSIGN lb-help = RETURN-VALUE.

                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                 &ErrorType="EMS"
                                                 &ErrorSubType="ERROR"
                                                 &ErrorParameters="lb-msg + '~~~~' + lb-help"}
                return "NOK":U.
            END.
           
            IF ttSpecificParametersVO.siteCode   <> "" AND
               ttSpecificParametersVO.familyCode <> "" AND
               ttSpecificParametersVO.itemCode   <> "" THEN DO:
                {utp/ut-liter.i "Configuraá∆o de ParÉmetro Espec°fico Lote Avanáado n∆o permitida."}
                ASSIGN lb-msg = RETURN-VALUE.
                {utp/ut-liter.i "O ParÉmetro deve obedecer a seguinte regra: item, item\estabelecimento, fam°lia ou fam°lia\estabelecimento. N∆o Ç permitido incluir os tràs valores no mesmo registro."}
                ASSIGN lb-help = RETURN-VALUE.

                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                 &ErrorType="EMS"
                                                 &ErrorSubType="ERROR"
                                                 &ErrorParameters="lb-msg + '~~~~' + lb-help"}
                return "NOK":U.
            END.
            IF ttSpecificParametersVO.siteCode <> "" AND
               NOT CAN-FIND (FIRST estabelec 
                             WHERE estabelec.cod-estabel = ttSpecificParametersVO.siteCode) THEN DO:
                {utp/ut-table.i mgadm estabelec 1}
                ASSIGN lb-estabel = RETURN-VALUE.
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                                 &ErrorType="EMS"
                                                 &ErrorSubType="ERROR"
                                                 &ErrorParameters="lb-estabel"}
                return "NOK":U.
            END.
            IF ttSpecificParametersVO.familyCode <> "" AND
                NOT CAN-FIND (FIRST familia 
                              WHERE familia.fm-codigo = ttSpecificParametersVO.familyCode) THEN DO:
                {utp/ut-table.i mgind familia 1}
                ASSIGN lb-familia = RETURN-VALUE.
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                                 &ErrorType="EMS"
                                                 &ErrorSubType="ERROR"
                                                 &ErrorParameters="lb-familia"}
                 return "NOK":U.
            END.
            IF ttSpecificParametersVO.itemCode <> "" THEN DO:
                {utp/ut-table.i mgind ITEM 1}
                ASSIGN lb-item = RETURN-VALUE.
                FIND FIRST ITEM 
                     WHERE ITEM.it-codigo = ttSpecificParametersVO.itemCode NO-LOCK NO-ERROR.
                IF NOT AVAIL ITEM THEN DO:

                    {method/svc/errors/inserr.i &ErrorNumber="2"
                                                 &ErrorType="EMS"
                                                 &ErrorSubType="ERROR"
                                                 &ErrorParameters="lb-item"}
                    return "NOK":U.
                END.
                ELSE
                    IF ITEM.tipo-con-est <= 2 THEN DO:
                        {utp/ut-liter.i Por_lote}
                        ASSIGN lb-tipo-lote = TRIM(RETURN-VALUE).
                        {utp/ut-liter.i Referància}
                        ASSIGN lb-tipo-refer = TRIM(RETURN-VALUE).
                        
                        {method/svc/errors/inserr.i &ErrorNumber="2732"
                                                 &ErrorType="EMS"
                                                 &ErrorSubType="ERROR"
                                                 &ErrorParameters="'' + '~~~~' + lb-tipo-lote + '~~~~' + lb-tipo-refer"}
                        return "NOK":U.
                    END.
            END.
            
            IF CAN-FIND(FIRST fda-lote-param-espcif
                        WHERE fda-lote-param-espcif.fm-codigo = ttSpecificParametersVO.familyCode
                          AND fda-lote-param-espcif.it-codigo = ttSpecificParametersVO.itemCode
                          AND fda-lote-param-espcif.cod-estabel   = ttSpecificParametersVO.siteCode) THEN DO:
                  {utp/ut-liter.i "ParÉmetro Espec°fico Lote Avanáado"}
                  ASSIGN lb-msg = RETURN-VALUE.
                 {method/svc/errors/inserr.i &ErrorNumber="1"
                                             &ErrorType="EMS"
                                             &ErrorSubType="ERROR"
                                             &ErrorParameters="lb-msg"}
                 return "NOK":U.                          
            END.
        END.

        if cType = "Create":u or
           cType = "Update":u then do:
		   
            IF NOT CAN-FIND (FIRST config-operac 
                             WHERE config-operac.cod-tip-operac = ttSpecificParametersVO.operationType
                               AND config-operac.cdn-empresa    = ttSpecificParametersVO.companyCodeRules
                               AND config-operac.cod-estab      = ttSpecificParametersVO.siteCodeRules) THEN DO:
        
                 {method/svc/errors/inserr.i &ErrorNumber="2"
                                             &ErrorType="EMS"
                                             &ErrorSubType="ERROR"
                                             &ErrorParameters="lb-config-operac"}
                 return "NOK":U.
            END.

            find first fda-lote-estado where 
                       fda-lote-estado.cod-status = ttSpecificParametersVO.inspectionState no-lock no-error.
            if avail fda-lote-estado and
               fda-lote-estado.idi-tip-estado <> 3 then do:     

                {utp/ut-liter.i Estado_Inspeá∆o}
                assign lb-estado      = return-value
                       lb-nome-estado = {ininc/i01in820.i 4 3}.

                {method/svc/errors/inserr.i &ErrorNumber="29928"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="lb-estado + '~~~~' + lb-nome-estado"}

            end.

            find first fda-lote-estado where 
                       fda-lote-estado.cod-status = ttSpecificParametersVO.aprovedState no-lock no-error.
            if avail fda-lote-estado and
               fda-lote-estado.idi-tip-estado <> 1 then do:

                {utp/ut-liter.i Estado_Aprovado}
                assign lb-estado      = return-value
                       lb-nome-estado = {ininc/i01in820.i 4 1}.

                {method/svc/errors/inserr.i &ErrorNumber="29928"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="lb-estado + '~~~~' + lb-nome-estado"}

            end.

            find first fda-lote-estado where 
                       fda-lote-estado.cod-status = ttSpecificParametersVO.reprovedState no-lock no-error.
            if avail fda-lote-estado and
               fda-lote-estado.idi-tip-estado <> 2 then do:

                {utp/ut-liter.i Estado_Reprovado}
                assign lb-estado      = return-value
                       lb-nome-estado = {ininc/i01in820.i 4 2}.

                {method/svc/errors/inserr.i &ErrorNumber="18440"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="lb-estado + '~~~~' + lb-nome-estado"}

            end.
        end.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getGeneralParameters DBOProgram 
PROCEDURE getGeneralParameters:
    DEF OUTPUT PARAM TABLE FOR ttGeneralParametersVO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.
    
    for each fda-lote-param no-lock:
        create ttGeneralParametersVO.
        ASSIGN ttGeneralParametersVO.initialState          = fda-lote-param.cod-status
               ttGeneralParametersVO.inspectionState      = fda-lote-param.cod-inspec-lote
               ttGeneralParametersVO.aprovedState          = fda-lote-param.cod-aprov-lote
               ttGeneralParametersVO.reprovedState          = fda-lote-param.cod-rej-lote
               ttGeneralParametersVO.isAllowReanalysis      = fda-lote-param.log-avaliac-lote
               ttGeneralParametersVO.isSuggestDirectCode  = fda-lote-param.log-lote
               ttGeneralParametersVO.companyCodeRules      = fda-lote-param.cdn-empresa
               ttGeneralParametersVO.siteCodeRules        = fda-lote-param.cod-estab-operac   
               ttGeneralParametersVO.operationType        = fda-lote-param.cod-tip-operac    
               ttGeneralParametersVO.hasSampleType          = fda-lote-param.log-amostra
               ttGeneralParametersVO.sampleType              = fda-lote-param.num-amostra.
        FOR FIRST estabelec FIELDS(nome)
             WHERE estabelec.cod-estabel = fda-lote-param.cod-estab-operac NO-LOCK:
            ASSIGN ttGeneralParametersVO.siteCodeRulesDescription = estabelec.nome.
        END.

        FOR FIRST empresa FIELDS (nome)
            WHERE empresa.ep-codigo = fda-lote-param.cdn-empresa NO-LOCK:
            ASSIGN ttGeneralParametersVO.companyCodeRulesDescription = empresa.nome.
        END.

        FOR FIRST  config-tip-operac FIELDS(des-tip-operac)
             WHERE config-tip-operac.cod-tip-operac = fda-lote-param.cod-tip-operac NO-LOCK:
            ASSIGN ttGeneralParametersVO.operationTypeDescription =  config-tip-operac.des-tip-operac.
        END.
    end.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setGeneralParameters DBOProgram 
PROCEDURE setGeneralParameters:
    DEF INPUT PARAM TABLE FOR ttGeneralParametersVO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.
    
    FOR FIRST  ttGeneralParametersVO:
        FIND FIRST fda-lote-param EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL fda-lote-param THEN
            ASSIGN cType = "Create":U.
        ELSE
            ASSIGN cType = "Update":U.

        RUN validateFields (INPUT 1).
        IF RETURN-VALUE = "OK":U THEN DO:
            IF cType = "Create":U THEN
                CREATE fda-lote-param.
            ASSIGN fda-lote-param.cod-status        = ttGeneralParametersVO.initialState       
                   fda-lote-param.cod-inspec-lote   = ttGeneralParametersVO.inspectionState    
                   fda-lote-param.cod-aprov-lote    = ttGeneralParametersVO.aprovedState       
                   fda-lote-param.cod-rej-lote      = ttGeneralParametersVO.reprovedState      
                   fda-lote-param.log-avaliac-lote  = ttGeneralParametersVO.isAllowReanalysis  
                   fda-lote-param.log-lote          = ttGeneralParametersVO.isSuggestDirectCode
                   fda-lote-param.cdn-empresa       = ttGeneralParametersVO.companyCodeRules   
                   fda-lote-param.cod-estab-operac  = ttGeneralParametersVO.siteCodeRules
                   fda-lote-param.cod-tip-operac    = ttGeneralParametersVO.operationType
                   fda-lote-param.log-amostra       = ttGeneralParametersVO.hasSampleType      
                   fda-lote-param.num-amostra       = ttGeneralParametersVO.sampleType.
        END.
    end.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getStateLot DBOProgram 
PROCEDURE getStateLot:
    DEF OUTPUT PARAM TABLE FOR ttStateLotVO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.
       
    for each fda-lote-estado no-lock:
        create ttStateLotVO.
        ASSIGN ttStateLotVO.codeState        = fda-lote-estado.cod-status 
               ttStateLotVO.descriptionState = fda-lote-estado.des-estado-lote.                
    end.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSpecie DBOProgram 
PROCEDURE getSpecie:
    DEF OUTPUT PARAM TABLE FOR ttSpecieVO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-lista AS CHARACTER   NO-UNDO.
       
    ASSIGN c-lista = {ininc/i03in218.i 03}.
    DO  i-cont = 1 to num-entries(c-lista):
        CREATE ttSpecieVO.
        ASSIGN ttSpecieVO.codeSpecie = i-cont
               ttSpecieVO.descriptionSpecie = entry(i-cont,c-lista).
    end.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSpecificParametersLot DBOProgram 
PROCEDURE getSpecificParametersLot:
    DEF INPUT PARAM itemCode AS character.
    DEF INPUT PARAM familyCode AS character.
    DEF INPUT PARAM siteCode AS character.
    DEF OUTPUT PARAM TABLE FOR ttSpecificParametersLotVO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE c-lista AS CHARACTER   NO-UNDO.
       
    ASSIGN c-lista = {ininc/i03in218.i 03}.
    FOR EACH fda-lote-vencid 
        WHERE fda-lote-vencid.it-codigo    = itemCode
          AND fda-lote-vencid.cod-estabel  = siteCode
          AND fda-lote-vencid.fm-codigo    = familyCode NO-LOCK:
        CREATE ttSpecificParametersLotVO.
        ASSIGN ttSpecificParametersLotVO.itemCode   = fda-lote-vencid.it-codigo
               ttSpecificParametersLotVO.siteCode   = fda-lote-vencid.cod-estabel
               ttSpecificParametersLotVO.familyCode = fda-lote-vencid.fm-codigo
               ttSpecificParametersLotVO.codeSpecie = fda-lote-vencid.esp-docto
               ttSpecificParametersLotVO.descriptionSpecie = ENTRY(fda-lote-vencid.esp-docto,c-lista). 
    END.
       

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSpecificParametersLot DBOProgram 
PROCEDURE setSpecificParametersLot:
    DEF INPUT PARAM TABLE FOR ttSpecificParametersLotVO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

/*     FIND FIRST ttSpecificParametersLotVO.                                           */
/*     IF AVAIL ttSpecificParametersLotVO THEN DO:                                     */
/*         CREATE fda-lote-vencid.                                                     */
/*         ASSIGN fda-lote-vencid.it-codigo    = ttSpecificParametersLotVO.itemCode    */
/*                fda-lote-vencid.cod-estabel  = ttSpecificParametersLotVO.siteCode    */
/*                fda-lote-vencid.fm-codigo    = ttSpecificParametersLotVO.familyCode  */
/*                fda-lote-vencid.esp-docto    = ttSpecificParametersLotVO.codeSpecie. */
/*     END.                                                                            */
    
    FOR EACH fda-lote-vencid EXCLUSIVE-LOCK:
        IF NOT CAN-FIND(FIRST ttSpecificParametersLotVO 
                        WHERE ttSpecificParametersLotVO.itemCode   = fda-lote-vencid.it-codigo
                          AND ttSpecificParametersLotVO.siteCode   = fda-lote-vencid.cod-estabel
                          AND ttSpecificParametersLotVO.familyCode = fda-lote-vencid.fm-codigo
                          AND ttSpecificParametersLotVO.codeSpecie = fda-lote-vencid.esp-docto) THEN
            DELETE fda-lote-vencid.
    END.
    FOR EACH ttSpecificParametersLotVO:
        IF NOT CAN-FIND(FIRST fda-lote-vencid 
                        WHERE fda-lote-vencid.it-codigo  = ttSpecificParametersLotVO.itemCode          
                          AND fda-lote-vencid.cod-estabel= ttSpecificParametersLotVO.siteCode          
                          AND fda-lote-vencid.fm-codigo  = ttSpecificParametersLotVO.familyCode        
                          AND fda-lote-vencid.esp-docto  = ttSpecificParametersLotVO.codeSpecie ) THEN DO:
            CREATE fda-lote-vencid.
            ASSIGN fda-lote-vencid.it-codigo    = ttSpecificParametersLotVO.itemCode          
                   fda-lote-vencid.cod-estabel  = ttSpecificParametersLotVO.siteCode          
                   fda-lote-vencid.fm-codigo    = ttSpecificParametersLotVO.familyCode        
                   fda-lote-vencid.esp-docto    = ttSpecificParametersLotVO.codeSpecie.
        END.
    END.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeSpecificParametersLot DBOProgram 
PROCEDURE removeSpecificParametersLot:
    DEF INPUT PARAM especieCode AS character.
    DEF INPUT PARAM itemCode AS character.
    DEF INPUT PARAM familyCode AS character.
    DEF INPUT PARAM siteCode AS character.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

    FIND FIRST fda-lote-vencid
         WHERE fda-lote-vencid.it-codigo   = itemCode
           AND fda-lote-vencid.cod-estabel = siteCode
           AND fda-lote-vencid.fm-codigo   = familyCode
           AND fda-lote-vencid.esp-docto   = int(especieCode)
        EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL fda-lote-vencid THEN
        DELETE fda-lote-vencid.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeSpecificParameters DBOProgram 
PROCEDURE removeSpecificParameters:
    DEF INPUT PARAM itemCode AS character.
    DEF INPUT PARAM familyCode AS character.
    DEF INPUT PARAM siteCode AS character.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE c-lb-lote-avancad  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lb-param-especif AS CHARACTER   NO-UNDO.
	
	
    
    IF CAN-FIND (FIRST fda-lote-avancad 
                 WHERE fda-lote-avancad.cod-estabel = siteCode
                   AND fda-lote-avancad.fm-codigo   = familyCode
                   AND fda-lote-avancad.it-codigo   = itemCode) THEN DO:
        {utp/ut-table.i mgind fda-lote-avancad 1}
        ASSIGN c-lb-lote-avancad = RETURN-VALUE.
        {utp/ut-table.i mgind fda-lote-param-espcif 1}
        ASSIGN c-lb-param-especif = RETURN-VALUE.

        {method/svc/errors/inserr.i &ErrorNumber="47218"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lb-param-especif + '~~~~' + c-lb-lote-avancad"}
             return "NOK":U.
    END.
    FIND FIRST fda-lote-param-espcif
         WHERE fda-lote-param-espcif.it-codigo  = itemCode
           AND fda-lote-param-espcif.fm-codigo  = familyCode
           AND fda-lote-param-espcif.cod-estabel = siteCode EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL fda-lote-param-espcif THEN
        DELETE fda-lote-param-espcif.

    FOR EACH fda-lote-vencid
       WHERE fda-lote-vencid.it-codigo   = itemCode
         AND fda-lote-vencid.cod-estabel = siteCode
         AND fda-lote-vencid.fm-codigo   = familyCode EXCLUSIVE-LOCK:
        DELETE fda-lote-vencid.
    END.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


