/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX00458Q01 2.00.00.005} /*** "010005" 11/12/2023 10:13:20 ***/
/* ***************************  Definitions  ***************************** */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx00458q01 MEX}
&ENDIF

/*
**  BOCX00458q01.P
**
**  DUE-SISCOMEX    -  Declaraá∆o Unica de Exportaá∆o
**
********************************************************************************/

&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ≤ um programa PROGRESS 
                 que cont≤m a lΩgica de negΩcio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */
/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00458Q01
&GLOBAL-DEFINE DBOVersion 20000000 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName tt-due-siscomex
&GLOBAL-DEFINE TableLabel tt-due-siscomex
&GLOBAL-DEFINE QueryName qr{&TableName} 

{utp/ut-glob.i} /*Definiá∆o de vari†veis globais do sistema*/

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

&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0
&GLOBAL-DEFINE EXCLUDE-getBatchRecords 0

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx00458q01.i RowObject}
{cxbo/bocx00458q01.i tt-due-siscomex}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
/* DEFINE BUFFER bf{&TableName} FOR {&TableName}. */

DEFINE VARIABLE c-cod-estabel-ini       LIKE due-siscomex.cod-estab        NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim       LIKE due-siscomex.cod-estab        NO-UNDO.
DEFINE VARIABLE c-cod-proces-export-ini LIKE due-item.cod-proces-export    NO-UNDO. 
DEFINE VARIABLE c-cod-proces-export-fim LIKE due-item.cod-proces-export    NO-UNDO. 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN rowObject.r-rowid = tt-due-siscomex.r-rowid.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetRowid DBOProgram 
PROCEDURE afterGetRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input-output PARAMETER pRowid  AS ROWID NO-UNDO.
    
    ASSIGN pRowid = tt-due-siscomex.r-rowid.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforerepositionrecord DBOProgram 
PROCEDURE beforerepositionrecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid  AS ROWID NO-UNDO.
    
    find {&TableName} where {&TableName}.r-rowid = pRowid no-lock no-error.

    if avail {&TableName} then 
       assign pRowid = rowid({&TableName}).

    /*--- Reposiciona query ---*/
    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        /*--- Erro 11: N“o foi poss–vel reposicionar a query ---*/
        {method/svc/errors/inserr.i &ErrorNumber="11"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}

        RETURN "NOK":U.
    END.
    
    /*--- ‚ necessŸrio para o correto funcionamento do reposicionamento ---*/
    GET NEXT {&QueryName} NO-LOCK.

    /*--- Seta flag indicando que o registro atual foi reposicionado ---*/
    &IF "{&DBType}" = "ORACLE":U &THEN
        ASSIGN lRepositioned = YES.
    &ENDIF
    
    /*--- Atualiza temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.
    
    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecords DBOProgram 
PROCEDURE getBatchRecords :
/*------------------------------------------------------------------------------
  Purpose:     Retorna faixa de registros da query atravÏs da 
               temptable RowObjectAux 
  Parameters:  recebe rowid inicial
               recebe flag indicando a execuÓ“o de novo GET NEXT
               recebe n·mero de linhas a serem retornadas
               retorna n·mero de linhas retornadas
               retorna temptable RowObjectAux
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pRowid        AS ROWID   NO-UNDO.
    DEFINE INPUT  PARAMETER pNext         AS LOGICAL NO-UNDO.
    DEFINE INPUT  PARAMETER pRowsToReturn AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pRowsReturned AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectAux.
    
    &IF "{&ROW-NUM-DEFINED}" = "YES" &THEN
        DEFINE VARIABLE iNextSeq AS INTEGER NO-UNDO INIT 0.
    &ENDIF
    
    /*--- Verifica permiss“o de execuÓ“o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
   
    /*--- Limpa temptable RowObjectAux ---*/
    RUN emptyRowObjectAux IN THIS-PROCEDURE.

    IF pRowid <> ? THEN DO:
        /* customizaØ o */
        
        for first tt-due-siscomex fields(cdd-due-ems num-versao-due)
             WHERE tt-due-siscomex.r-rowid = pRowid.
        end.
        if avail tt-due-siscomex then 
            ASSIGN pRowid = rowid(tt-due-siscomex).

        REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            &IF "{&NewRecordOffQuery}" = "YES" &THEN
                GET FIRST {&QueryName} NO-LOCK.
                ASSIGN pRowid = rowid({&TableName}).
                REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
                IF ERROR-STATUS:ERROR THEN do:
                    RETURN "NOK":U.
                end.
            &ELSE
                RETURN "NOK":U.
            &ENDIF
        END.
        
        GET NEXT {&QueryName} NO-LOCK.
        
        /*--- Este teste torna-se necessŸrio devido ao fato de realizar-se um 
              reposicionamento de um registro recÏm eliminado. Neste caso n“o Ï 
              retornado erro no comando REPOSITION, pois o reposicionamento da
              QUERY Ï processado com base no RESULT-LIST ---*/
        IF NOT AVAILABLE {&TableName} THEN
            RETURN "NOK":U.
    END.
    
    IF pNext THEN DO:
        GET NEXT {&QueryName} NO-LOCK.
    END.
    
    /*--- Grava temptable RowObjectAux ---*/
    DO WHILE AVAILABLE({&TableName}):
        IF pRowsToReturn <> 0 AND pRowsReturned >= pRowsToReturn THEN
            LEAVE.

        /*--- Atualiza temptable RowObject ---*/
        RUN _copyBuffer2TT IN THIS-PROCEDURE.

        &IF "{&ROW-NUM-DEFINED}" = "YES" &THEN
            ASSIGN iNextSeq = iNextSeq + 1
                   RowObject.RowNum = iNextSeq.
        &ENDIF
        
        /*--- Executa mÏtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="before"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        IF NOT CAN-FIND(FIRST RowObjectAux
                            WHERE RowObjectAux.cdd-due-ems    = RowObject.cdd-due-ems   
                            AND   RowObjectAux.num-versao-due = RowObject.num-versao-due) THEN DO:
            CREATE RowObjectAux.
            BUFFER-COPY RowObject TO RowObjectAux.
            ASSIGN pRowsReturned = pRowsReturned + 1.
        END.
        
        /*--- Executa mÏtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="after"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.        
        GET NEXT {&QueryName}.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecordsCustom DBOProgram
PROCEDURE getBatchRecordsCustom:
/*------------------------------------------------------------------------------
 Purpose:
 Notes: Utilizado no z01cx00458 (ex7000)
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pRowid        AS ROWID   NO-UNDO.
    DEFINE INPUT  PARAMETER pNext         AS LOGICAL NO-UNDO.
    DEFINE INPUT  PARAMETER pRowsToReturn AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pRowsReturned AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectAux.

    EMPTY TEMP-TABLE RowObjectAux NO-ERROR.    
    FOR EACH tt-due-siscomex NO-LOCK:
        CREATE RowObjectAux.
        BUFFER-COPY tt-due-siscomex TO RowObjectAux. 
    END.       
    
    RETURN "OK":U.

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
        WHEN "cod-chave-aces-due":U THEN ASSIGN pFieldValue = RowObject.cod-chave-aces-due.
        WHEN "cod-cnpj-cpf":U THEN ASSIGN pFieldValue = RowObject.cod-cnpj-cpf.
        WHEN "cod-cnpj-respons":U THEN ASSIGN pFieldValue = RowObject.cod-cnpj-respons.
        WHEN "cod-due-siscomex":U THEN ASSIGN pFieldValue = RowObject.cod-due-siscomex.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-incoterm":U THEN ASSIGN pFieldValue = RowObject.cod-incoterm.
        WHEN "cod-latitude-despch":U THEN ASSIGN pFieldValue = RowObject.cod-latitude-despch.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-longitude-despch":U THEN ASSIGN pFieldValue = RowObject.cod-longitude-despch.
        WHEN "cod-moed":U THEN ASSIGN pFieldValue = RowObject.cod-moed.
        WHEN "cod-pais-dest-final":U THEN ASSIGN pFieldValue = RowObject.cod-pais-dest-final.
        WHEN "cod-ruc":U THEN ASSIGN pFieldValue = RowObject.cod-ruc.
        WHEN "cod-telef":U THEN ASSIGN pFieldValue = RowObject.cod-telef.
        WHEN "cod-usuar-criac":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-criac.
        WHEN "des-email":U THEN ASSIGN pFieldValue = RowObject.des-email.
        WHEN "des-ender-despch":U THEN ASSIGN pFieldValue = RowObject.des-ender-despch.
        WHEN "des-ender-embarq":U THEN ASSIGN pFieldValue = RowObject.des-ender-embarq.
        WHEN "des-inform-compl":U THEN ASSIGN pFieldValue = RowObject.des-inform-compl.
        WHEN "hra-criac":U THEN ASSIGN pFieldValue = RowObject.hra-criac.
        WHEN "nom-contato":U THEN ASSIGN pFieldValue = RowObject.nom-contato.
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
        WHEN "dat-criac":U THEN ASSIGN pFieldValue = RowObject.dat-criac.
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
        WHEN "cdd-due-ems":U THEN ASSIGN pFieldValue = RowObject.cdd-due-ems.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-perc-comis-agent":U THEN ASSIGN pFieldValue = RowObject.val-perc-comis-agent.
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
        WHEN "cdn-aduana-despch":U THEN ASSIGN pFieldValue = RowObject.cdn-aduana-despch.
        WHEN "cdn-aduana-embarq":U THEN ASSIGN pFieldValue = RowObject.cdn-aduana-embarq.
        WHEN "cdn-moed-siscomex":U THEN ASSIGN pFieldValue = RowObject.cdn-moed-siscomex.
        WHEN "cdn-recinto-aduana-despch":U THEN ASSIGN pFieldValue = RowObject.cdn-recinto-aduana-despch.
        WHEN "cdn-recinto-aduana-embarq":U THEN ASSIGN pFieldValue = RowObject.cdn-recinto-aduana-embarq.
        WHEN "cdn-urf-despch":U THEN ASSIGN pFieldValue = RowObject.cdn-urf-despch.
        WHEN "cdn-urf-embarq":U THEN ASSIGN pFieldValue = RowObject.cdn-urf-embarq.
        WHEN "cod-enquad-1":U THEN ASSIGN pFieldValue = RowObject.cod-enquad-1.
        WHEN "cod-enquad-2":U THEN ASSIGN pFieldValue = RowObject.cod-enquad-2.
        WHEN "cod-enquad-3":U THEN ASSIGN pFieldValue = RowObject.cod-enquad-3.
        WHEN "cod-enquad-4":U THEN ASSIGN pFieldValue = RowObject.cod-enquad-4.
        WHEN "idi-caract-operac":U THEN ASSIGN pFieldValue = RowObject.idi-caract-operac.
        WHEN "idi-sit-especial":U THEN ASSIGN pFieldValue = RowObject.idi-sit-especial.
        WHEN "idi-sit-siscomex":U THEN ASSIGN pFieldValue = RowObject.idi-sit-siscomex.
        WHEN "idi-tratam-priorit":U THEN ASSIGN pFieldValue = RowObject.idi-tratam-priorit.
        WHEN "idi-via-transp":U THEN ASSIGN pFieldValue = RowObject.idi-via-transp.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-versao-due":U THEN ASSIGN pFieldValue = RowObject.num-versao-due.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dclncxpr_id2
  Parameters:  
               retorna valor do campo cdd-due-ems
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdd-due-ems LIKE due-siscomex.cdd-due-ems NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdd-due-ems = RowObject.cdd-due-ems.

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
        WHEN "log-ativa":U   THEN ASSIGN pFieldValue = RowObject.log-ativa.
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
  Purpose:     Reposiciona registro com base no °ndice dclncxpr_id2
  Parameters:  
               recebe valor do campo cdd-due-ems
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-due-ems    LIKE due-siscomex.cdd-due-ems NO-UNDO.
    DEFINE INPUT PARAMETER pnum-versao-due LIKE due-siscomex.num-versao-due NO-UNDO.

/*     FIND FIRST bfdue-siscomex WHERE                                                              */
/*         bfdue-siscomex.cdd-due-ems = pcdd-due-ems NO-LOCK NO-ERROR.                              */
/*                                                                                                  */
/*     /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/ */
/*     IF NOT AVAILABLE bfdue-siscomex THEN                                                         */
/*         RETURN "NOK":U.                                                                          */
/*                                                                                                  */
/*     /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso              */
/*           existam erros ser† retornada flag "NOK":U ---*/                                        */
/*     RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdue-siscomex)).                        */
/*     IF RETURN-VALUE = "NOK":U THEN                                                               */
/*         RETURN "NOK":U.                                                                          */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryData DBOProgram 
PROCEDURE openQueryProcesso :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query a partir do campo "Estabelecimento" e 
               "Processo de Exportaá∆o"
               Filtrados pelo programa de pesquisa z01cx00458
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName}
        FOR EACH tt-due-siscomex NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} 
        FOR EACH tt-due-siscomex NO-LOCK 
        INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tt DBOProgram 
PROCEDURE pi-carrega-tt :
/*------------------------------------------------------------------------------
  Purpose: Gera temp-table da due-siscomex filtrada por estabelecimento e n£mero
  do processo de exportaá∆o.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-due-siscomex.
    FOR EACH due-nf NO-LOCK 
       WHERE due-nf.cod-estab-proces-export >= c-cod-estabel-ini
         AND due-nf.cod-estab-proces-export <= c-cod-estabel-fim     
         AND due-nf.cod-proces-export       >= c-cod-proces-export-ini 
         AND due-nf.cod-proces-export       <= c-cod-proces-export-fim:
        
       IF due-nf.cod-estab-proces-export = "" OR due-nf.cod-proces-export = "" THEN NEXT.
        IF NOT CAN-FIND(FIRST tt-due-siscomex NO-LOCK
                        WHERE tt-due-siscomex.cdd-due-ems             = due-nf.cdd-due-ems
                        AND   tt-due-siscomex.cod-estab-proces-export = due-nf.cod-estab-proces-export
                        AND   tt-due-siscomex.cod-proces-export       = due-nf.cod-proces-export) THEN DO:  
           FIND FIRST due-siscomex 
                WHERE  due-siscomex.cdd-due-ems = due-nf.cdd-due-ems NO-LOCK NO-ERROR.
           IF AVAIL due-siscomex THEN DO:
              CREATE tt-due-siscomex.
              BUFFER-COPY due-siscomex TO tt-due-siscomex.
              ASSIGN tt-due-siscomex.cod-estab-proces-export = due-nf.cod-estab-proces-export
                     tt-due-siscomex.cod-proces-export       = due-nf.cod-proces-export      
                     tt-due-siscomex.r-rowid = ROWID(due-siscomex).
           END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintProcesso DBOProgram 
PROCEDURE setConstraintProcesso :
/*------------------------------------------------------------------------------
  Purpose:     Recebe os parÉmetros para abertura da query "Processo"
  Parameters:  Entrada: pc-cod-estabel-ini (character): C¢digo inicial do Estabelecimento
               Entrada: pc-cod-estabel-fim (character): C¢digo final do Estabelecimento
               Entrada: pc-cod-proces-export-ini (character): C¢digo inicial do Processo de Exportaá∆o
               Entrada: pc-cod-proces-export-fim (character): C¢digo final do Processo de Exportaá∆o
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel-ini         LIKE due-siscomex.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel-fim         LIKE due-siscomex.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-proces-export-ini   LIKE due-item.cod-proces-export NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-proces-export-fim   LIKE due-item.cod-proces-export NO-UNDO.
    
    ASSIGN c-cod-estabel-ini        = pc-cod-estabel-ini
           c-cod-estabel-fim        = pc-cod-estabel-fim
           c-cod-proces-export-ini  = pc-cod-proces-export-ini 
           c-cod-proces-export-fim  = pc-cod-proces-export-fim. 

    RUN pi-carrega-tt IN THIS-PROCEDURE.
    
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
    
    /*:T--- Utilize o par≥metro pType para identificar quais as validaªÑes a serem
          executadas ---*/
    /*:T--- Os valores poss≠veis para o par≥metro sío: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav≤s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaªÑes ---*/
    
    /*:T--- Verifica ocorrºncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

