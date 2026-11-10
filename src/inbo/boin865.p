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
&GLOBAL-DEFINE DBOName BOIN865
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName fda-investig
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
      
      
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES        
      
{inbo/boin865.i RowObject}

DEF VAR h-handle-aux AS HANDLE NO-UNDO.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/*vari†vel que possui o usu†rio logado*/
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER NO-UNDO.


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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-serie":U THEN ASSIGN pFieldValue = RowObject.cod-serie.
		WHEN "dsl-parecer-investig":U THEN ASSIGN pFieldValue = RowObject.dsl-parecer-investig.
        WHEN "dsl-acao-investig":U THEN ASSIGN pFieldValue = RowObject.dsl-acao-investig.
        WHEN "dsl-motiv-investig":U THEN ASSIGN pFieldValue = RowObject.dsl-motiv-investig.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "cod-respons":U THEN ASSIGN pFieldValue = RowObject.cod-respons.
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
        WHEN "dat-fim":U THEN ASSIGN pFieldValue = RowObject.dat-fim.
        WHEN "dat-inic":U THEN ASSIGN pFieldValue = RowObject.dat-inic.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-period-final-investig":U THEN ASSIGN pFieldValue = RowObject.dat-period-final-investig.
        WHEN "dat-period-inicial-investig":U THEN ASSIGN pFieldValue = RowObject.dat-period-inicial-investig.
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
        WHEN "cdn-num-investig":U THEN ASSIGN pFieldValue = RowObject.cdn-num-investig.
        WHEN "idi-status-investig":U THEN ASSIGN pFieldValue = RowObject.idi-status-investig.
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
  Purpose:     Retorna valores dos campos do °ndice fdnvstg-id
  Parameters:  
               retorna valor do campo cdn-num-investig
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-num-investig LIKE fda-investig.cdn-num-investig NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-num-investig = RowObject.cdn-num-investig.

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
  Purpose:     Reposiciona registro com base no °ndice fdnvstg-id
  Parameters:  
               recebe valor do campo cdn-num-investig
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-num-investig LIKE fda-investig.cdn-num-investig NO-UNDO.

    FIND FIRST bffda-investig WHERE 
        bffda-investig.cdn-num-investig = pcdn-num-investig NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bffda-investig THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bffda-investig)).
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
    IF pType = "CREATE" THEN DO:	
        IF NOT CAN-FIND(FIRST responsavel NO-LOCK
                        WHERE responsavel.cod-resp = v_cod_usuar_corren) THEN DO:
            {method/svc/errors/inserr.i
               &ErrorNumber=52143
               &ErrorType="FDA"
               &ErrorSubType="ERROR"}
        END.


        IF (RowObject.cdn-num-investig = 0) OR (RowObject.cdn-num-investig = ?) THEN DO:
            FIND LAST fda-investig NO-LOCK NO-ERROR.

            IF AVAIL fda-investig THEN DO:
                ASSIGN RowObject.cdn-num-investig = (fda-investig.cdn-num-investig + 1).
            END.
            
            IF RowObject.cdn-num-investig = 0 THEN
                RowObject.cdn-num-investig = 1.

            IF RowObject.idi-status-investig = 0 THEN
                RowObject.idi-status-investig = 1.
            IF RowObject.cod-respons = "" THEN
                RowObject.cod-respons = v_cod_usuar_corren.
        END.
    END.

    IF pType = "DELETE" THEN DO:
        IF RowObject.idi-status-investig <> 1 THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber=52136
                &ErrorType="FDA"
                &ErrorSubType="ERROR"}
        END.
        
        FIND FIRST fda-lote-investig 
            WHERE fda-lote-investig.cod-status-lote <> '1' /*opcao 1 = An†lise*/
              AND fda-lote-investig.cdn-num-investig = RowObject.cdn-num-investig NO-LOCK NO-ERROR.
        IF AVAIL fda-lote-investig THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber=52136
                &ErrorType="FDA"
                &ErrorSubType="ERROR"}
        END.
        ELSE DO:
            IF CAN-FIND ( FIRST responsavel NO-LOCK
            WHERE  responsavel.cod-resp = RowObject.cod-respons 
               AND responsavel.cod-resp <> v_cod_usuar_corren 
               AND responsavel.cod-respons-2 <> v_cod_usuar_corren ) THEN
                    {method/svc/errors/inserr.i
                            &ErrorNumber=52136
                            &ErrorType="FDA"
                            &ErrorSubType="ERROR"}
        END.    
    END.

    IF pType = "UPDATE" THEN DO:
        IF CAN-FIND ( FIRST responsavel NO-LOCK
            WHERE  responsavel.cod-resp = RowObject.cod-respons 
               AND responsavel.cod-resp <> v_cod_usuar_corren 
               AND responsavel.cod-respons-2 <> v_cod_usuar_corren ) THEN DO:
            {method/svc/errors/inserr.i
                    &ErrorNumber=52136
                    &ErrorType="FDA"
                    &ErrorSubType="ERROR"}
            
        END. 
    END.
    IF (pType = "CREATE") OR (pType = "UPDATE") THEN DO:
        IF (DATE(RowObject.dat-period-inicial-investig) > DATE(RowObject.dat-period-final-investig)) THEN DO:
            {method/svc/errors/inserr.i
                    &ErrorNumber=198
                    &ErrorType="FDA"
                    &ErrorSubType="ERROR"}
        END.
    END.
    
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram
PROCEDURE openQueryDefault:
OPEN QUERY {&QueryName}
    FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord Method-Library 
PROCEDURE afterDeleteRecord:
    RUN inbo/boin866.p PERSISTENT SET h-handle-aux.
    RUN openQueryStatic IN h-handle-aux (INPUT "Default").
    FOR EACH fda-lote-investig
        WHERE fda-lote-investig.cdn-num-investig = RowObject.cdn-num-investig NO-LOCK:
        RUN gotoKey IN h-handle-aux (INPUT fda-lote-investig.cdn-num-investig, INPUT fda-lote-investig.nr-lote).
        IF RETURN-VALUE <> "NOK" THEN
            RUN deleteRecord IN h-handle-aux.
        RUN getRowErrors IN h-handle-aux (OUTPUT TABLE RowErrors APPEND).
    END.

    RETURN "OK":U.
END PROCEDURE. 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

