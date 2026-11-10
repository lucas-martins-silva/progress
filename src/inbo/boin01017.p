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

{include/i-prgvrs.i BOIN01017 2.00.00.006 } /*** "010006" 13/11/2023 11:45:46 ***/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01017
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ext-item-doc-est
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
{inbo/boin01017.i RowObject}


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
         HEIGHT             = 8.38
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

DEFINE VARIABLE c-serie-docto  LIKE {&TableName}.serie-docto  NO-UNDO.
DEFINE VARIABLE c-nro-docto    LIKE {&TableName}.nro-docto    NO-UNDO.
DEFINE VARIABLE c-nat-operacao LIKE {&TableName}.nat-operacao NO-UNDO.
DEFINE VARIABLE i-cod-emitente LIKE {&TableName}.cod-emitente NO-UNDO.
DEFINE VARIABLE i-sequencia    LIKE {&TableName}.sequencia    NO-UNDO.
DEFINE VARIABLE c-cod-param    LIKE {&TableName}.cod-param    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAliquotaFCP DBOProgram 
PROCEDURE getAliquotaFCP :
define output parameter p-de-it-aliq-fcp      AS DEC INIT ? NO-UNDO.

    RUN goToKeyItemDoctoParam ("fcp":U).

    IF RETURN-VALUE = "OK":U THEN DO:
        ASSIGN p-de-it-aliq-fcp     = {&TableName}.val-livre-2.
        RETURN "OK":U.
    END.
    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAliquotaFCPST DBOProgram 
PROCEDURE getAliquotaFCPST :
define output parameter p-de-it-aliq-fcp-st   AS DEC INIT ? NO-UNDO.

    RUN goToKeyItemDoctoParam ("fcp":U).

    IF RETURN-VALUE = "OK":U THEN DO:
        ASSIGN p-de-it-aliq-fcp-st  = {&TableName}.val-livre-5.
        RETURN "OK":U.
    END.
    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAliquotaFCPSTA DBOProgram 
PROCEDURE getAliquotaFCPSTA :
define output parameter p-de-it-aliq-fcp-sta  AS DEC INIT ? NO-UNDO.

    RUN goToKeyItemDoctoParam ("fcp":U).

    IF RETURN-VALUE = "OK":U THEN DO:
        ASSIGN p-de-it-aliq-fcp-sta = {&TableName}.val-livre-5.
        RETURN "OK":U.
    END.
    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAliquotaSTA DBOProgram 
PROCEDURE getAliquotaSTA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pd-aliq-sta  LIKE {&TableName}.val-livre-1 INIT 0  NO-UNDO.
    
    RUN goToKeyItemDoctoParam ("icms-sta":U).

    IF RETURN-VALUE = "OK":U THEN DO:
        ASSIGN pd-aliq-sta = {&TableName}.val-livre-1.
        RETURN "OK":U.
    END.

    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBaseFCP DBOProgram 
PROCEDURE getBaseFCP :
define output parameter p-de-it-base-fcp      AS DEC INIT ? NO-UNDO.

    RUN goToKeyItemDoctoParam ("fcp":U).

    IF RETURN-VALUE = "OK":U THEN DO:
        ASSIGN p-de-it-base-fcp     = {&TableName}.val-livre-1.
        RETURN "OK":U.
    END.
    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBaseFCPST DBOProgram 
PROCEDURE getBaseFCPST :
define output parameter p-de-it-base-fcp-st   AS DEC INIT ? NO-UNDO.

    RUN goToKeyItemDoctoParam ("fcp":U).

    IF RETURN-VALUE = "OK":U THEN DO:
        ASSIGN p-de-it-base-fcp-st  = {&TableName}.val-livre-4.
        RETURN "OK":U.
    END.
    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBaseFCPSTA DBOProgram 
PROCEDURE getBaseFCPSTA :
define output parameter p-de-it-base-fcp-sta  AS DEC INIT ? NO-UNDO.

    RUN goToKeyItemDoctoParam ("fcp":U).

    IF RETURN-VALUE = "OK":U THEN DO:
        ASSIGN p-de-it-base-fcp-sta = {&TableName}.val-livre-4.
        RETURN "OK":U.
    END.
    RETURN "NOK":U.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-livre-1":U  THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U  THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U  THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U  THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
        WHEN "cod-livre-5":U  THEN ASSIGN pFieldValue = RowObject.cod-livre-5.
        WHEN "cod-livre-6":U  THEN ASSIGN pFieldValue = RowObject.cod-livre-6.
        WHEN "cod-param":U    THEN ASSIGN pFieldValue = RowObject.cod-param.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U    THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U  THEN ASSIGN pFieldValue = RowObject.serie-docto.
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
        WHEN "dat-livre-5":U THEN ASSIGN pFieldValue = RowObject.dat-livre-5.
        WHEN "dat-livre-6":U THEN ASSIGN pFieldValue = RowObject.dat-livre-6.
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
        WHEN "val-livre-5":U THEN ASSIGN pFieldValue = RowObject.val-livre-5.
        WHEN "val-livre-6":U THEN ASSIGN pFieldValue = RowObject.val-livre-6.
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
        WHEN "num-livre-1":U  THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U  THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-livre-3":U  THEN ASSIGN pFieldValue = RowObject.num-livre-3.
        WHEN "num-livre-4":U  THEN ASSIGN pFieldValue = RowObject.num-livre-4.
        WHEN "num-livre-5":U  THEN ASSIGN pFieldValue = RowObject.num-livre-5.
        WHEN "num-livre-6":U  THEN ASSIGN pFieldValue = RowObject.num-livre-6.
        WHEN "sequencia":U    THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ext_item_documento
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo sequencia
               retorna valor do campo cod-param
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto  LIKE ext-item-doc-est.serie-docto  NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto    LIKE ext-item-doc-est.nro-docto    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE ext-item-doc-est.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE ext-item-doc-est.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia    LIKE ext-item-doc-est.sequencia    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-param    LIKE ext-item-doc-est.cod-param    NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto  = RowObject.serie-docto
           pnro-docto    = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           psequencia    = RowObject.sequencia
           pcod-param    = RowObject.cod-param.

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
        WHEN "log-livre-1":U  THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-10":U THEN ASSIGN pFieldValue = RowObject.log-livre-10.
        WHEN "log-livre-2":U  THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-livre-3":U  THEN ASSIGN pFieldValue = RowObject.log-livre-3.
        WHEN "log-livre-4":U  THEN ASSIGN pFieldValue = RowObject.log-livre-4.
        WHEN "log-livre-5":U  THEN ASSIGN pFieldValue = RowObject.log-livre-5.
        WHEN "log-livre-6":U  THEN ASSIGN pFieldValue = RowObject.log-livre-6.
        WHEN "log-livre-7":U  THEN ASSIGN pFieldValue = RowObject.log-livre-7.
        WHEN "log-livre-8":U  THEN ASSIGN pFieldValue = RowObject.log-livre-8.
        WHEN "log-livre-9":U  THEN ASSIGN pFieldValue = RowObject.log-livre-9.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValorFCP DBOProgram 
PROCEDURE getValorFCP :
define output parameter p-de-it-vl-fcp        AS DEC INIT ? NO-UNDO.

    RUN goToKeyItemDoctoParam ("fcp":U).

    IF RETURN-VALUE = "OK":U THEN DO:
        ASSIGN p-de-it-vl-fcp       = {&TableName}.val-livre-3.
        RETURN "OK":U.
    END.
    RETURN "NOK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValorFCPST DBOProgram 
PROCEDURE getValorFCPST :
define output parameter p-de-it-vl-fcp-st     AS DEC INIT ? NO-UNDO.

    RUN goToKeyItemDoctoParam ("fcp":U).

    IF RETURN-VALUE = "OK":U THEN DO:
        ASSIGN p-de-it-vl-fcp-st    = {&TableName}.val-livre-6.
        RETURN "OK":U.
    END.
    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValorFCPSTA DBOProgram 
PROCEDURE getValorFCPSTA :
define output parameter p-de-it-vl-fcp-sta    AS DEC INIT ? NO-UNDO.

    RUN goToKeyItemDoctoParam ("fcp":U).

    IF RETURN-VALUE = "OK":U THEN DO:
        ASSIGN p-de-it-vl-fcp-sta   = {&TableName}.val-livre-6.
        RETURN "OK":U.
    END.
    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValorICMSProp DBOProgram 
PROCEDURE getValorICMSProp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pd-val-icm-prop  LIKE {&TableName}.val-livre-2 INIT 0  NO-UNDO.
    
    RUN goToKeyItemDoctoParam ("icms-sta":U).

    IF RETURN-VALUE = "OK":U THEN DO:
        ASSIGN pd-val-icm-prop = {&TableName}.val-livre-2.
        RETURN "OK":U.
    END.

    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice ext_item_documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo sequencia
               recebe valor do campo cod-param
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto  LIKE ext-item-doc-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto    LIKE ext-item-doc-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE ext-item-doc-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE ext-item-doc-est.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER psequencia    LIKE ext-item-doc-est.sequencia    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-param    LIKE ext-item-doc-est.cod-param    NO-UNDO.

    FIND FIRST bfext-item-doc-est NO-LOCK 
         WHERE bfext-item-doc-est.serie-docto  = pserie-docto
           AND bfext-item-doc-est.nro-docto    = pnro-docto
           AND bfext-item-doc-est.cod-emitente = pcod-emitente
           AND bfext-item-doc-est.nat-operacao = pnat-operacao
           AND bfext-item-doc-est.sequencia    = psequencia
           AND bfext-item-doc-est.cod-param    = pcod-param NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfext-item-doc-est THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfext-item-doc-est)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyItemDoctoParam DBOProgram 
PROCEDURE goToKeyItemDoctoParam :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no item do documento
  Parameters:  recebe valor do campo cod-param
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-param    LIKE ext-item-doc-est.cod-param    NO-UNDO.

    IF AVAILABLE RowObject THEN 
        IF   RowObject.serie-docto  = c-serie-docto
         AND RowObject.nro-docto    = c-nro-docto
         AND RowObject.nat-operacao = c-nat-operacao
         AND RowObject.cod-emitente = i-cod-emitente
         AND RowObject.sequencia    = i-sequencia
         AND RowObject.cod-param    = pc-cod-param THEN
            RETURN "OK":U. /* Nao precisa consultar novamente se eh a mesma chave */

    RUN goToKey (c-serie-docto,
                 c-nro-docto,
                 i-cod-emitente,
                 c-nat-operacao,
                 i-sequencia,
                 pc-cod-param).

    RETURN RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemDocto DBOProgram 
PROCEDURE openQueryItemDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  OPEN QUERY qr{&tableName} 
    FOR EACH {&tableName} NO-LOCK
       WHERE {&TableName}.serie-docto  = c-serie-docto
         AND {&TableName}.nro-docto    = c-nro-docto
         AND {&TableName}.nat-operacao = c-nat-operacao
         AND {&TableName}.cod-emitente = i-cod-emitente
         AND {&TableName}.sequencia    = i-sequencia
      INDEXED-REPOSITION.

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

  OPEN QUERY qr{&tableName} FOR EACH {&tableName} NO-LOCK 
      INDEXED-REPOSITION.
       
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryParam DBOProgram 
PROCEDURE openQueryParam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} 
         FOR EACH  {&TableName} NO-LOCK 
             WHERE {&TableName}.cod-param = c-cod-param INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItemDocto DBOProgram 
PROCEDURE setConstraintItemDocto :
/*:T------------------------------------------------------------------------------
  Purpose:     Seta chave do item do documento
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pc-serie-docto  LIKE {&TableName}.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pc-nro-docto    LIKE {&TableName}.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pc-nat-operacao LIKE {&TableName}.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pi-cod-emitente LIKE {&TableName}.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pi-sequencia    LIKE {&TableName}.sequencia    NO-UNDO.

    ASSIGN c-serie-docto  = pc-serie-docto
           c-nro-docto    = pc-nro-docto
           c-nat-operacao = pc-nat-operacao
           i-cod-emitente = pi-cod-emitente
           i-sequencia    = pi-sequencia.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintParam DBOProgram 
PROCEDURE setConstraintParam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-c-cod-param AS CHAR NO-UNDO.

    ASSIGN c-cod-param = p-c-cod-param.

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

