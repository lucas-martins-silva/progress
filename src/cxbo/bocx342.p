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
&GLOBAL-DEFINE DBOName BOCX342
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName docto-import
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*Pre-processadores para acelerador de implantaá∆o*/
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

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
{cxbo/bocx342.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE VARIABLE cCodIni AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCodFim AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDesIni AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDesFim AS CHARACTER  NO-UNDO.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 14.08
         WIDTH              = 42.14.
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
        WHEN "cod-docto":U THEN ASSIGN pFieldValue = RowObject.cod-docto.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "des-docto":U THEN ASSIGN pFieldValue = RowObject.des-docto.
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
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "qti-docto-cop-bco":U THEN ASSIGN pFieldValue = RowObject.qti-docto-cop-bco.
        WHEN "qti-docto-cop-imptdor":U THEN ASSIGN pFieldValue = RowObject.qti-docto-cop-imptdor.
        WHEN "qti-docto-origin":U THEN ASSIGN pFieldValue = RowObject.qti-docto-origin.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dctmprt-id
  Parameters:  
               retorna valor do campo cod-docto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-docto LIKE docto-import.cod-docto NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-docto = RowObject.cod-docto.

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
  Purpose:     Reposiciona registro com base no °ndice dctmprt-id
  Parameters:  
               recebe valor do campo cod-docto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-docto LIKE docto-import.cod-docto NO-UNDO.

    FIND FIRST bfdocto-import WHERE 
        bfdocto-import.cod-docto = pcod-docto NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocto-import THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocto-import)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodigo DBOProgram 
PROCEDURE openQueryCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK 
                            WHERE {&tableName}.cod-docto >= cCodIni
                            AND   {&tableName}.cod-docto <= cCodFim
                            BY    {&tableName}.cod-docto  INDEXED-REPOSITION.
    RETURN "ok":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDescricao DBOProgram 
PROCEDURE openQueryDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK 
                            WHERE {&tableName}.des-docto >= cDesIni
                            AND   {&tableName}.des-docto <= cDesFim
                            BY    {&tableName}.des-docto  INDEXED-REPOSITION.
    RETURN "ok":U.
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
OPEN QUERY {&queryName}
    FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.
        RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodigo DBOProgram 
PROCEDURE setConstraintCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pCodIni AS CHAR NO-UNDO.
DEF INPUT PARAM pCodFim AS CHAR NO-UNDO.

ASSIGN cCodIni = pCodIni
       cCodFim = pCodFim.
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDescricao DBOProgram 
PROCEDURE setConstraintDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pDesIni AS CHAR NO-UNDO.
DEF INPUT PARAM pDesFim AS CHAR NO-UNDO.

ASSIGN cDesIni = pDesIni
       cDesFim = pDesFim.
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

    IF  pType = "Create":U THEN DO:
        /*Duplicidade de Registro*/
        IF CAN-FIND(FIRST docto-import NO-LOCK
                         WHERE docto-import.cod-docto = rowObject.cod-docto) THEN DO:

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-documento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Documento" *}
            ASSIGN c-lbl-liter-documento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="1"
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-lbl-liter-documento"}
        END.
        /*Documento n∆o pode ser branco*/
        IF RowObject.cod-docto = "" THEN
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-documento-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Documento" *}
                ASSIGN c-lbl-liter-documento-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                &ErrorNumber="265"
                &ErrorType="EMS":U
                &ErrorSubType="Error":U
                &ErrorParameters="c-lbl-liter-documento-2"}
                END. 

        /*Documento n∆o pode ser desconhecido */
        ELSE IF RowObject.cod-docto = ? THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-documento-nao-pode-ser AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Documento_nao_pode_ser" *}
            ASSIGN c-lbl-liter-documento-nao-pode-ser = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="4240"
                &ErrorType="EMS":U
                &ErrorSubType="Error":U
                &ErrorParameters="c-lbl-liter-documento-nao-pode-ser"}
             RETURN "NOK":U.
        END.
    END.

    IF  pType = "Create":U OR 
        pType = "Update":U THEN DO:

        /*Descriá∆o n∆o pode ser branco*/
        IF RowObject.des-docto = "" THEN

            {method/svc/errors/inserr.i
                    &ErrorNumber="190"
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR"}
                    
        /*Descriá∆o n∆o pode ser desconhecido*/
       ELSE IF RowObject.des-docto = ? THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-descricao-nao-pode-ser AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Descricao_nao_pode_ser" *}
            ASSIGN c-lbl-liter-descricao-nao-pode-ser = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="4240"
                    &ErrorType="EMS":U
                    &ErrorSubType="Error":U
                    &ErrorParameters="c-lbl-liter-descricao-nao-pode-ser"}
            RETURN "NOK":U.
        END.
        
        /*Quantidade de Originais n∆o pode ser zero*/
        IF RowObject.qti-docto-origin = 0 THEN
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-quantidade-de-originais AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Quantidade_de_Originais" *}
                ASSIGN c-lbl-liter-quantidade-de-originais = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                &ErrorNumber="265"                 
                &ErrorType="EMS":U
                &ErrorSubType="Error":U
                &ErrorParameters="c-lbl-liter-quantidade-de-originais"}
                END. 
            
        /*Quantidade de c¢pias no banco n∆o pode ser zero
       IF RowObject.qti-docto-cop-bco = 0 THEN
                
                DO:
                DEFINE VARIABLE c-lbl-liter-quantidade-de-copias-banco AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Quantidade_de_C¢pias_Banco" *}
                ASSIGN c-lbl-liter-quantidade-de-copias-banco = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                &ErrorNumber="265"                 
                &ErrorType="EMS":U
                &ErrorSubType="Error":U
                &ErrorParameters="c-lbl-liter-quantidade-de-copias-banco"}
                END. */
           
        /*Quantidade de c¢pias importador n∆o pode ser zero*/
       IF RowObject.qti-docto-cop-imptdor = 0 THEN
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-quantidade-de-copias-importado AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Quantidade_de_C¢pias_Importador" *}
                ASSIGN c-lbl-liter-quantidade-de-copias-importado = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                &ErrorNumber="265"                 
                &ErrorType="EMS":U
                &ErrorSubType="Error":U
                &ErrorParameters="c-lbl-liter-quantidade-de-copias-importado"}
                END. 
       
    END.

    IF pType = "Delete":U THEN DO:

        IF CAN-FIND(FIRST item-docto-import WHERE
                        item-docto-import.cod-docto = RowObject.cod-docto) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-documento-importacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Documento_Importaá∆o" *}
            ASSIGN c-lbl-liter-documento-importacao = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-item-x-documento-importacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_X_Documento_Importaá∆o" *}
            ASSIGN c-lbl-liter-item-x-documento-importacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="5"                 
                &ErrorType="EMS":U
                &ErrorSubType="Error":U
                &ErrorParameters="c-lbl-liter-documento-importacao + '~~~~' + c-lbl-liter-item-x-documento-importacao"}
        END.

        IF CAN-FIND(FIRST trad-docto-import WHERE
                        trad-docto-import.cod-docto = RowObject.cod-docto) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-documento-importacao-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Documento_Importaá∆o" *}
            ASSIGN c-lbl-liter-documento-importacao-2 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-traducao-documento-importacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Traduá∆o_Documento_Importaá∆o" *}
            ASSIGN c-lbl-liter-traducao-documento-importacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="5"                 
                &ErrorType="EMS":U
                &ErrorSubType="Error":U
                &ErrorParameters="c-lbl-liter-documento-importacao-2 + '~~~~' + c-lbl-liter-traducao-documento-importacao"}
        END.
    END.


     IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
 
     RETURN "OK":U.  

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

