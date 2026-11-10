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
{include/i-prgvrs.i BOCX00442A 2.00.00.003 } /*** "010003" 07/10/2024 16:59:53 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00442A
&GLOBAL-DEFINE DBOVersion 2.0
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName adiant-despes
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
{cxbo/bocx00442.i RowObject}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/

DEFINE QUERY {&QueryName} FOR {&TableName}, emitente SCROLLING. 

DEF VAR c-cod-estab-ini    LIKE adiant-despes.cod-estab    NO-UNDO.
DEF VAR c-cod-estab-fim    LIKE adiant-despes.cod-estab    NO-UNDO.     
DEF VAR d-cdd-adiant-ini   LIKE adiant-despes.cdd-adiant   NO-UNDO.     
DEF VAR d-cdd-adiant-fim   LIKE adiant-despes.cdd-adiant   NO-UNDO.     
DEF VAR c-nome-abrev-ini   LIKE emitente.nome-abrev        NO-UNDO. 
DEF VAR c-nome-abrev-fim   LIKE emitente.nome-abrev        NO-UNDO.  
DEF VAR d-dat-impl-ini     LIKE adiant-despes.dat-impl     NO-UNDO.     
DEF VAR d-dat-impl-fim     LIKE adiant-despes.dat-impl     NO-UNDO. 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetBatchRecordsCustom DBOProgram 
PROCEDURE GetBatchRecordsCustom :
/*------------------------------------------------------------------------------
  Purpose:     Retorna faixa de registros da query atravÇs da 
               temptable RowObjectAux 
  Parameters:  recebe codigo do estabelecimento
               recebe c¢digo do adiantamento
               recebe flag indicando a execuá∆o de novo GET NEXT
               recebe n£mero de linhas a serem retornadas
               retorna n£mero de linhas retornadas
               retorna temptable RowObjectAux
  Notes: 
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pCodEstab     LIKE adiant-despes.cod-estabel NO-UNDO.  
DEFINE INPUT  PARAMETER pCddAdiant    LIKE adiant-despes.cdd-adiant NO-UNDO.    
DEFINE INPUT  PARAMETER pNext         AS LOGICAL NO-UNDO.
DEFINE INPUT  PARAMETER pRowsToReturn AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pRowsReturned AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR RowObjectAux.

DEFINE BUFFER bfRowObjectAux FOR RowObjectAux.
DEFINE VAR pRowid        AS ROWID   NO-UNDO.

    IF pCodEstab = ? OR pCddAdiant = ? THEN DO:
       GET FIRST {&QueryName} NO-LOCK.
       ASSIGN pRowid = ROWID({&TableName}).
    END.
    ELSE DO:
       FIND adiant-despes
          WHERE adiant-despes.cod-estabel =  pCodEstab  
          AND   adiant-despes.cdd-adiant  =  pCddAdiant  
          NO-LOCK NO-ERROR.
       IF AVAIL adiant-despes THEN
          ASSIGN pRowid = ROWID(adiant-despes).
    END.

&IF "{&ROW-NUM-DEFINED}" = "YES" &THEN
  DEFINE VARIABLE iNextSeq AS INTEGER NO-UNDO INIT 0.
&ENDIF
    
    /*--- Verifica permiss∆o de execuá∆o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    
    /*--- Limpa temptable RowObjectAux ---*/
    RUN emptyRowObjectAux IN THIS-PROCEDURE.
    
    IF pRowid <> ? THEN DO:
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:REPOSITION-TO-ROWID(pRowid) NO-ERROR.
        &ELSE
            REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
        &ENDIF
        /* DBO-XML-END */

	    IF ERROR-STATUS:ERROR THEN DO:
            &IF "{&NewRecordOffQuery}" = "YES" &THEN
                /* DBO-XML-BEGIN */
                /* Se a Query Dinamica estiver habilitada, usa o handle dela */
                &IF {&DYNAMIC-QUERY-ENABLED} &THEN
          	         hQuery:GET-FIRST(NO-LOCK).
            	  ASSIGN pRowid = rowid({&TableName}).
          	         hQuery:REPOSITION-TO-ROWID(pRowid) NO-ERROR.
                &ELSE
                    GET FIRST {&QueryName} NO-LOCK.
                    ASSIGN pRowid = rowid({&TableName}).
                    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
                &ENDIF
            &ELSE
                RETURN "NOK":U.
            &ENDIF
            IF ERROR-STATUS:ERROR THEN do:
                RETURN "NOK":U.
            end.
        END.
        
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-NEXT(NO-LOCK).
        &ELSE
            GET NEXT {&QueryName} NO-LOCK.
        &ENDIF
        /* DBO-XML-END */
        
        /*--- Este teste torna-se necess†rio devido ao fato de realizar-se um 
              reposicionamento de um registro recÇm eliminado. Neste caso n∆o Ç 
              retornado erro no comando REPOSITION, pois o reposicionamento da
              QUERY Ç processado com base no RESULT-LIST ---*/
        IF NOT AVAILABLE {&TableName} THEN
            RETURN "NOK":U.
    END.
    
    IF pNext THEN DO:
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-NEXT(NO-LOCK).
        &ELSE
            GET NEXT {&QueryName} NO-LOCK.
        &ENDIF
        /* DBO-XML-END */
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
        
        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="before"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /*--- Copia o registro da temptable RowObject para a temptable RowObjectAux ---*/
        CREATE RowObjectAux.
        ASSIGN RowObjectAux.cod-estabel  = RowObject.cod-estabel 
               RowObjectAux.cdd-adiant   = RowObject.cdd-adiant  
               RowObjectAux.cdn-emitente = RowObject.cdn-emitente
               RowObjectAux.dat-implant  = RowObject.dat-implant 
               RowObjectAux.r-rowid      = ROWID(adiant-despes).
     
        ASSIGN pRowsReturned = pRowsReturned + 1.
        
        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="after"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-NEXT(NO-LOCK).
        &ELSE
            GET NEXT {&QueryName} NO-LOCK.
        &ENDIF
        /* DBO-XML-END */
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
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
        WHEN "dat-implant":U THEN ASSIGN pFieldValue = RowObject.dat-implant.
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
        WHEN "cdd-adiant":U THEN ASSIGN pFieldValue = RowObject.cdd-adiant.
        WHEN "val-adiant":U THEN ASSIGN pFieldValue = RowObject.val-adiant.
        WHEN "val-adiant-moed":U THEN ASSIGN pFieldValue = RowObject.val-adiant-moed.
        WHEN "val-adiant-orig":U THEN ASSIGN pFieldValue = RowObject.val-adiant-orig.
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
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "cdn-moeda":U THEN ASSIGN pFieldValue = RowObject.cdn-moeda.
        WHEN "idi-modul":U THEN ASSIGN pFieldValue = RowObject.idi-modul.
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
  Purpose:     Retorna valores dos campos do °ndice adntdsps_id3
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo cdd-adiant
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE adiant-despes.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdd-adiant LIKE adiant-despes.cdd-adiant NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcdd-adiant = RowObject.cdd-adiant.

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
  Purpose:     Reposiciona registro com base no °ndice adntdsps_id3
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cdd-adiant
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE adiant-despes.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-adiant LIKE adiant-despes.cdd-adiant NO-UNDO.

    FIND FIRST bfadiant-despes WHERE 
        bfadiant-despes.cod-estabel = pcod-estabel AND 
        bfadiant-despes.cdd-adiant = pcdd-adiant NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfadiant-despes THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfadiant-despes)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNomeAbrev DBOProgram 
PROCEDURE openQueryByNomeAbrev:
/*------------------------------------------------------------------------------
  Purpose: Busca os registros de acordo com a seleá∆o considerando o nome 
           abreviado do emitente.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME} NO-LOCK
                            WHERE {&TABLENAME}.cod-estabel  >= c-cod-estab-ini       
                            AND   {&TABLENAME}.cod-estabel  <= c-cod-estab-fim 
                            AND   {&TABLENAME}.cdd-adiant   >= d-cdd-adiant-ini      
                            AND   {&TABLENAME}.cdd-adiant   <= d-cdd-adiant-fim
                            AND   {&TABLENAME}.dat-implant  >= d-dat-impl-ini          
                            AND   {&TABLENAME}.dat-implant  <= d-dat-impl-fim,
                            FIRST emitente NO-LOCK
                                  WHERE emitente.cod-emitente = {&TABLENAME}.cdn-emitente
                                  AND emitente.nome-abrev >= c-nome-abrev-ini
                                  AND   emitente.nome-abrev <= c-nome-abrev-fim
                                  BY {&TABLENAME}.cdn-emitente.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNomeAbrev DBOProgram 
PROCEDURE setConstraintByNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose: Informa chave (inicio e fim) para filtro da query     
  Parameters: p-cod-estab-ini    = C¢digo inicial do estabelecimento
              p-cod-estab-fim    = C¢digo final do estabelecimento
              p-cdd-adiant-ini   = C¢digo inicial do adiantamento
              p-cdd-adiant-fim   = C¢digo final do adiantamento
              p-nome-abrev-ini   = C¢digo inicial do emitente
              p-nome-abrev-fim   = C¢digo final do emitente
              p-dat-impl-ini     = C¢digo inicial da data de implantaá∆o 
              p-dat-impl-fim     = C¢digo final da data de implantaá∆o
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-cod-estab-ini    LIKE adiant-despes.cod-estab    NO-UNDO.
DEF INPUT PARAM p-cod-estab-fim    LIKE adiant-despes.cod-estab    NO-UNDO.
DEF INPUT PARAM p-cdd-adiant-ini   LIKE adiant-despes.cdd-adiant   NO-UNDO.
DEF INPUT PARAM p-cdd-adiant-fim   LIKE adiant-despes.cdd-adiant   NO-UNDO.
DEF INPUT PARAM p-nome-abrev-ini   LIKE emitente.nome-abrev        NO-UNDO.
DEF INPUT PARAM p-nome-abrev-fim   LIKE emitente.nome-abrev        NO-UNDO.
DEF INPUT PARAM p-dat-impl-ini     LIKE adiant-despes.dat-impl     NO-UNDO.  
DEF INPUT PARAM p-dat-impl-fim     LIKE adiant-despes.dat-impl     NO-UNDO.  

    ASSIGN c-cod-estab-ini     = p-cod-estab-ini    
           c-cod-estab-fim     = p-cod-estab-fim    
           d-cdd-adiant-ini    = p-cdd-adiant-ini   
           d-cdd-adiant-fim    = p-cdd-adiant-fim   
           c-nome-abrev-ini    = p-nome-abrev-ini
           c-nome-abrev-fim    = p-nome-abrev-fim
           d-dat-impl-ini      = p-dat-impl-ini     
           d-dat-impl-fim      = p-dat-impl-fim.   
    
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
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

