USING Progress.Lang.*.
USING com.totvs.datasul.eai.*.
USING com.totvs.datasul.universal.*.
USING com.totvs.datasul.manufacture.*.
USING com.totvs.datasul.eai2.messages.Item_3_001.*.

&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 

{include/i-prgvrs.i BOIN00951 2.00.00.011 } /*** "010011" 27/10/2023 17:03:40  ***/

{include/i-epc200.i BOIN00951}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin00951 MUT}
&ENDIF
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

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN00951
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName pendcia-integr-mes
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
{inbo/boin00951.i RowObject}
{inbo/boin00951.i RowObject2}
{inbo/boin00952.i tt-pendcia-integr-mes-contdo}
{inbo/boin00952.i tt-pendcia-integr-mes-contdo-aux}
DEFINE VARIABLE cXML AS LONGCHAR NO-UNDO.
/* Filtro */
DEFINE VARIABLE dt-dat-envio-ini AS DATE      NO-UNDO.
DEFINE VARIABLE dt-dat-envio-fim AS DATE      NO-UNDO.
DEFINE VARIABLE c-cod-trans-ini  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-trans-fim  AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-idi-tip-status AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-usuario-ini    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-usuario-fim    AS CHARACTER NO-UNDO.

         
/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bfpendcia-integr-mes-contdo FOR pendcia-integr-mes-contdo.




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


DEFINE TEMP-TABLE rowErrorsAux NO-UNDO LIKE rowErrors.

/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram
PROCEDURE afterCreateRecord:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE BUFFER bfpendcia-integr-mes-contdo FOR pendcia-integr-mes-contdo.
    
    DEFINE VARIABLE cXMLaux     AS LONGCHAR      NO-UNDO.  
    DEFINE VARIABLE h-boin00952 AS HANDLE        NO-UNDO.
    DEFINE VARIABLE i-cdn-segment-msg AS INTEGER NO-UNDO.
 
 
    /* Apos criar o registro de pendencia, cria a tabela com o conteudo do xml */
    DO WHILE(TRUE): 
                
        ASSIGN i-cdn-segment-msg = i-cdn-segment-msg + 1.        
               
        FIND LAST bfpendcia-integr-mes-contdo NO-LOCK NO-ERROR.
        CREATE pendcia-integr-mes-contdo.
        ASSIGN pendcia-integr-mes-contdo.num-id-pendcia-integr-mes = rowObject.num-id-pendcia-integr-mes
               pendcia-integr-mes-contdo.cdn-segment-msg           = i-cdn-segment-msg
               pendcia-integr-mes-contdo.num-id-pendcia-contdo     = IF AVAIL bfpendcia-integr-mes-contdo THEN
                                                                         bfpendcia-integr-mes-contdo.num-id-pendcia-contdo + 1
                                                                     ELSE 1.                                                         
        
        /* Se o xml conter mais de 9990 caracteres, quebra a variavel */                                                             
        IF LENGTH(cXML) > 9990 THEN DO:
            ASSIGN cXMLaux  = SUBSTR(cXML, 1, 9990)
                   pendcia-integr-mes-contdo.dsl-segment-msg = cXMLaux.
                   
            SUBSTR(cXML,1, 9990) = "":U.
        
        END.
        ELSE DO: /* se tiver menos que 9990 caracteres, salva o conteudo e sai do while */       
            ASSIGN pendcia-integr-mes-contdo.dsl-segment-msg = cxml.
            LEAVE.        
        END.
		
		VALIDATE pendcia-integr-mes-contdo.
    END.   
    
    RETURN "OK":U.
       
END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram
PROCEDURE beforeCreateRecord:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
 /* Verifica se existe pendencia criada para o codigo de identificacao enviado.
    Se existir, apaga a tabela por somente pdoe exitir uma pendencia para cada
    codigo de identificacao */	
    RUN deleteRecordByIdentif(INPUT rowObject.cod-chave-ident ).

    FIND LAST bfpendcia-integr-mes  NO-LOCK NO-ERROR.  
    
    IF AVAIL bfpendcia-integr-mes THEN
        ASSIGN rowObject.num-id-pendcia-integr-mes = bfpendcia-integr-mes.num-id-pendcia-integr-mes + 1.      
    ELSE 
        ASSIGN rowObject.num-id-pendcia-integr-mes = 1. 

END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecordByIdentif DBOProgram
PROCEDURE deleteRecordByIdentif:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-chave-ident LIKE pendcia-integr-mes.cod-chave-ident NO-UNDO.  
    
    RUN validateRecord(INPUT "Delete":U).
    
    IF RETURN-VALUE = "OK":U THEN DO:        
        FOR EACH bfpendcia-integr-mes
           WHERE bfpendcia-integr-mes.cod-chave-ident = pcod-chave-ident EXCLUSIVE-LOCK:
		   
            FOR EACH bfpendcia-integr-mes-contdo OF bfpendcia-integr-mes: 			
                DELETE bfpendcia-integr-mes-contdo.
                RELEASE bfpendcia-integr-mes-contdo.                
            END.
            
            DELETE bfpendcia-integr-mes.
            RELEASE bfpendcia-integr-mes.
        END.        
    END.  
    
    RETURN RETURN-VALUE.

END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecordByPendcia DBOProgram
PROCEDURE deleteRecordByPendcia:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-id-pendcia-integr-mes LIKE pendcia-integr-mes.num-id-pendcia-integr-mes NO-UNDO.  
    
    RUN validateRecord(INPUT "Delete":U).
    IF RETURN-VALUE = "OK":U THEN DO:
        FOR EACH bfpendcia-integr-mes
           WHERE bfpendcia-integr-mes.num-id-pendcia-integr-mes = pnum-id-pendcia-integr-mes EXCLUSIVE-LOCK:
               
            FOR EACH bfpendcia-integr-mes-contdo OF bfpendcia-integr-mes EXCLUSIVE-LOCK:
                DELETE bfpendcia-integr-mes-contdo.
                RELEASE bfpendcia-integr-mes-contdo.
            END.
            
            DELETE bfpendcia-integr-mes.
            RELEASE bfpendcia-integr-mes.
        END.        
    END.  
    
    RETURN RETURN-VALUE.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-chave-ident":U THEN ASSIGN pFieldValue = RowObject.cod-chave-ident.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
        WHEN "cod-trans":U THEN ASSIGN pFieldValue = RowObject.cod-trans.
        WHEN "cod-usuar":U THEN ASSIGN pFieldValue = RowObject.cod-usuar.
        WHEN "des-msg-ret":U THEN ASSIGN pFieldValue = RowObject.des-msg-ret.
        WHEN "hra-envio":U THEN ASSIGN pFieldValue = RowObject.hra-envio.
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
        WHEN "idi-tip-status":U THEN ASSIGN pFieldValue = RowObject.idi-tip-status.
        WHEN "num-id-pendcia-integr-mes":U THEN ASSIGN pFieldValue = RowObject.num-id-pendcia-integr-mes.
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
  Purpose:     Retorna valores dos campos do ¡ndice pndcntgr-id2
  Parameters:  
               retorna valor do campo num-id-pendcia-integr-mes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-id-pendcia-integr-mes LIKE pendcia-integr-mes.num-id-pendcia-integr-mes NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-id-pendcia-integr-mes = RowObject.num-id-pendcia-integr-mes.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNumId DBOProgram
PROCEDURE getNumId:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM pi-num-id LIKE {&TableName}.num-id-pendcia-integr-mes NO-UNDO.
    
    FIND LAST {&TableName} NO-LOCK NO-ERROR.
            
    ASSIGN pi-num-id = IF AVAIL {&TableName} THEN {&TableName}.num-id-pendcia-integr-mes
                       ELSE 1.
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
  Purpose:     Reposiciona registro com base no ¡ndice pndcntgr-id2
  Parameters:  
               recebe valor do campo num-id-pendcia-integr-mes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-id-pendcia-integr-mes LIKE pendcia-integr-mes.num-id-pendcia-integr-mes NO-UNDO.

    FIND FIRST bfpendcia-integr-mes WHERE 
        bfpendcia-integr-mes.num-id-pendcia-integr-mes = pnum-id-pendcia-integr-mes NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpendcia-integr-mes THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpendcia-integr-mes)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltro DBOProgram
PROCEDURE openQueryFiltro:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    IF i-idi-tip-status = 0 THEN /* TODOS */    
        OPEN QUERY {&QueryName} 
          FOR EACH {&TableName} NO-LOCK
             WHERE {&TableName}.dat-envio     >= date(dt-dat-envio-ini)
               AND {&TableName}.dat-envio     <= date(dt-dat-envio-fim)
               AND {&TableName}.cod-trans     >= c-cod-trans-ini
               AND {&TableName}.cod-trans     <= c-cod-trans-fim
               AND {&TableName}.cod-usuar     >= c-usuario-ini
               AND {&TableName}.cod-usuar     <= c-usuario-fim
                BY {&TableName}.dat-envio DESC 
                BY {&TableName}.hra-envio DESC. 
    ELSE 
        OPEN QUERY {&QueryName} 
          FOR EACH {&TableName} NO-LOCK
             WHERE {&TableName}.dat-envio     >= date(dt-dat-envio-ini)
               AND {&TableName}.dat-envio     <= date(dt-dat-envio-fim)
               AND {&TableName}.cod-trans     >= c-cod-trans-ini
               AND {&TableName}.cod-trans     <= c-cod-trans-fim
               AND {&TableName}.cod-usuar     >= c-usuario-ini
               AND {&TableName}.cod-usuar     <= c-usuario-fim   
               AND {&TableName}.idi-tip-status = i-idi-tip-status
                BY {&TableName}.dat-envio DESC  
                BY {&TableName}.hra-envio DESC.     

           
    RETURN "OK":U.

END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram
PROCEDURE openQueryMain:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U. 

END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME






&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-xml DBOProgram
PROCEDURE pi-retorna-xml:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM rRowid AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAM plcXML AS LONGCHAR NO-UNDO.

    DEFINE VARIABLE i-cont        AS INTEGER  NO-UNDO.
    DEFINE VARIABLE lc-aux-xml    AS LONGCHAR NO-UNDO.
    DEFINE VARIABLE lc-new-xml    AS LONGCHAR NO-UNDO.
    
    FIND FIRST pendcia-integr-mes 
         WHERE ROWID(pendcia-integr-mes) = rRowid NO-LOCK NO-ERROR.
   
    IF AVAIL pendcia-integr-mes THEN DO:
        FOR EACH pendcia-integr-mes-contdo OF pendcia-integr-mes NO-LOCK
            BREAK BY cdn-segment-msg:                
          ASSIGN plcXML = plcXML + pendcia-integr-mes-contdo.dsl-segment-msg.
        END.  
    END.

    /*** Ponto Upc - NGK - #1219766 ***/
	/**********************************/
    IF c-nom-prog-upc-mg97 <> "" THEN DO:
        FOR EACH tt-epc
            WHERE tt-epc.cod-event = "after-retorna-xml": 
            DELETE tt-epc.
        END.
        
        ASSIGN lc-aux-xml = plcXML
               i-cont = 0.
        
        blk-upc:
        DO WHILE(TRUE):
            ASSIGN i-cont = i-cont + 1.
            
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "after-retorna-xml"
                   tt-epc.cod-parameter = "xml" + STRING(i-cont, "9999").

            IF LENGTH(lc-aux-xml) > 9990 THEN DO:
                ASSIGN tt-epc.val-parameter = SUBSTR(lc-aux-xml, 1, 9990)
                       SUBSTR(lc-aux-xml,1, 9990) = "":U.
            END.
            ELSE DO:
                ASSIGN tt-epc.val-parameter = lc-aux-xml. 
                LEAVE blk-upc.
            END.
        END. /*end do while*/
        
        {include/i-epc201.i "after-retorna-xml"}

        FOR EACH tt-epc
            WHERE tt-epc.cod-event     = "after-retorna-xml" 
            AND   tt-epc.cod-parameter BEGINS "new-xml" NO-LOCK BY tt-epc.cod-parameter:
            ASSIGN lc-new-xml = lc-new-xml + tt-epc.val-parameter.
        END.

        IF lc-new-xml <> "" THEN
            ASSIGN plcXML = lc-new-xml.
    END.
    /**** FIM PONTO UPC NGK - 1219766 */
	/**********************************/
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recebeMensagem DBOProgram
PROCEDURE recebeMensagem:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pc-xml AS LONGCHAR NO-UNDO.
    
    ASSIGN cXML = pc-xml.
    
    RETURN "OK":U.

END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltro DBOProgram
PROCEDURE setConstraintFiltro:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdt-dat-envio-ini AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER pdt-dat-envio-fim AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-trans-ini  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-trans-fim  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pidi-tip-status   AS INTEGER   NO-UNDO.  
    DEFINE INPUT PARAMETER pc-usuario-ini    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-usuario-fim    AS CHARACTER NO-UNDO.	
      
    ASSIGN dt-dat-envio-ini  = pdt-dat-envio-ini
           dt-dat-envio-fim  = pdt-dat-envio-fim
           c-cod-trans-ini   = pc-cod-trans-ini 
           c-cod-trans-fim   = pc-cod-trans-fim 
           i-idi-tip-status  = pidi-tip-status
		   c-usuario-ini     = pc-usuario-ini
		   c-usuario-fim     = pc-usuario-fim.
          
    RETURN "OK":U.
    
END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram
PROCEDURE setConstraintMain:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

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
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    
    IF pType = "Create" THEN DO:
        IF LENGTH(cXML) <= 0 THEN DO:            
            {utp/ut-liter.i "Ocorreu_um_erro_ao_criar_pendencia" * }
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorParameters="return-value"}
        END.        
        
    END.    
    
    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

