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
&GLOBAL-DEFINE DBOName BOCX00430A
&GLOBAL-DEFINE DBOVersion 2.0
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName usuar-export
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
{cxbo/bocx430a.i RowObject}


/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
      
DEFINE QUERY {&QueryName} FOR {&TableName}, usuar_mestre SCROLLING.        

DEFINE VARIABLE c-cod-usuar-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-usuar-fim AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-ini      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-fim      AS CHARACTER   NO-UNDO.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 14.96
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
  Parameters:  recebe rowid inicial
               recebe flag indicando a execuá∆o de novo GET NEXT
               recebe n£mero de linhas a serem retornadas
               retorna n£mero de linhas retornadas
               retorna temptable RowObjectAux
  Notes: 
------------------------------------------------------------------------------*/
    define input  parameter pCodUsuar     as character format "x(12)":U no-undo.
    define input  parameter pNext         as logical                   no-undo.
    define input  parameter pRowsToReturn as integer                   no-undo.
    define output parameter pRowsReturned as integer                   no-undo.
    define output parameter table for RowObjectAux.
    
    define buffer bfRowObjectAux for RowObjectAux.
    
    define var pRowid    as rowid no-undo.

    if  pCodUsuar = ? then do:
        get first {&QueryName} no-lock.
        assign pRowid = rowid({&TableName}).
    end.
    else do:
       find FIRST usuar-export
            where usuar-export.cod-usuar = pCodUsuar no-lock no-error.
       if  avail  usuar-export then
           assign pRowid = rowid(usuar-export).
    end.
    
    &IF "{&ROW-NUM-DEFINED}" = "YES" &THEN
    define variable iNextSeq as integer no-undo init 0.
    &ENDIF
       
    /*--- Verifica permiss∆o de execuá∆o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    
    /*--- Limpa temptable RowObjectAux ---*/
    run emptyRowObjectAux in this-procedure.
    
    if  pRowid <> ? then do:
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
        hQuery:reposition-to-rowid(pRowid) no-error.
        &ELSE
        reposition {&QueryName} to rowid pRowid no-error.
        &ENDIF
        /* DBO-XML-END */
    
        if  error-status:error then do:
            &IF "{&NewRecordOffQuery}" = "YES" &THEN
            /* DBO-XML-BEGIN */
            /* Se a Query Dinamica estiver habilitada, usa o handle dela */
                &IF {&DYNAMIC-QUERY-ENABLED} &THEN
                hQuery:get-first(no-lock).
                assign pRowid = rowid({&TableName}).
                hQuery:reposition-to-rowid(pRowid) no-error.
                &ELSE
                get first {&QueryName} no-lock.
                assign pRowid = rowid({&TableName}).
                reposition {&QueryName} to rowid pRowid no-error.
                &ENDIF
            &ELSE
                return "NOK":U.
            &ENDIF
            
            if  error-status:error then
                return "NOK":U.
        end.
        
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
        hQuery:get-next(no-lock).
        &ELSE
        get next {&QueryName} no-lock.
        &ENDIF
        /* DBO-XML-END */
        
        /*--- Este teste torna-se necess†rio devido ao fato de realizar-se um 
              reposicionamento de um registro recÇm eliminado. Neste caso n∆o Ç 
              retornado erro no comando REPOSITION, pois o reposicionamento da
              QUERY Ç processado com base no RESULT-LIST ---*/
        if  not available {&TableName} then
            return "NOK":U.
    end.
    
    if  pNext then do:
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
        hQuery:get-next(no-lock).
        &ELSE
        get next {&QueryName} no-lock.
        &ENDIF
        /* DBO-XML-END */
    END.
    
    /*--- Grava temptable RowObjectAux ---*/
    do  while available({&TableName}):
        if  pRowsToReturn <> 0
        and pRowsReturned >= pRowsToReturn then
            leave.
        
        /*--- Atualiza temptable RowObject ---*/
        run _copyBuffer2TT in this-procedure.

        &IF "{&ROW-NUM-DEFINED}" = "YES" &THEN
        assign iNextSeq         = iNextSeq + 1
               RowObject.RowNum = iNextSeq.
        &ENDIF
           
        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="before"
                                        &Procedure="getBatchRecords"}
        if  lOverrideExecuted and return-value = "NOK":U then
            return "NOK":U.
        
        /*--- Copia o registro da temptable RowObject para a temptable RowObjectAux ---*/
        create RowObjectAux.
        assign RowObjectAux.cod-usuar   = RowObject.cod-usuar
               RowObjectAux.nome        = usuar_mestre.nom_usuario
               RowObjectAux.r-rowid     = rowid(usuar-export). 
        
        assign pRowsReturned = pRowsReturned + 1.
        
        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="after"
                                        &Procedure="getBatchRecords"}
        if  lOverrideExecuted and return-value = "NOK":U then
            return "NOK":U.
        
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
        hQuery:get-next(no-lock).
        &ELSE
        get next {&QueryName} no-lock.
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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-usuar":U THEN ASSIGN pFieldValue = RowObject.cod-usuar.
        WHEN "des-layout-origin-gerc":U THEN ASSIGN pFieldValue = RowObject.des-layout-origin-gerc.
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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice usrxprt_id
  Parameters:  
               retorna valor do campo cod-usuar
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-usuar LIKE usuar-export.cod-usuar NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-usuar = RowObject.cod-usuar.

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
  Purpose:     Reposiciona registro com base no °ndice usrxprt_id
  Parameters:  
               recebe valor do campo cod-usuar
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-usuar LIKE usuar-export.cod-usuar NO-UNDO.

    FIND FIRST bfusuar-export WHERE 
        bfusuar-export.cod-usuar = pcod-usuar NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfusuar-export THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfusuar-export)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNome DBOProgram 
PROCEDURE openQueryByNome :
/*------------------------------------------------------------------------------
  Purpose:     Query que retorna os usu†rios com filtro pelo nome
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK,
        FIRST usuar_mestre NO-LOCK
        WHERE usuar_mestre.cod_usuario = {&TableName}.cod-usuar
        AND   usuar_mestre.nom_usuario >= c-nome-ini
        AND   usuar_mestre.nom_usuario <= c-nome-fim
        BY    usuar_mestre.nom_usuario
        BY    {&TableName}.cod-usuar.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByUsuario DBOProgram 
PROCEDURE openQueryByUsuario :
/*------------------------------------------------------------------------------
  Purpose:     Query que retorna os usu†rios com filtro pelo c¢digo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
              WHERE {&TableName}.cod-usuar >= c-cod-usuar-ini
              AND   {&TableName}.cod-usuar <= c-cod-usuar-fim,
              FIRST usuar_mestre NO-LOCK
              WHERE usuar_mestre.cod_usuario  = {&TableName}.cod-usuar
                 BY {&TableName}.cod-usuar
                 BY usuar_mestre.nom_usuario.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNome DBOProgram 
PROCEDURE setConstraintByNome :
/*------------------------------------------------------------------------------
  Purpose:     Informa o nome do usu†rio (inicio e fim) para filtro da query
  Parameters:  p-nome-ini = C¢digo inicial do usu†rio
               p-nome-fim = C¢digo final do usu†rio
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-nome-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-nome-fim AS CHARACTER NO-UNDO.

    ASSIGN c-nome-ini = p-nome-ini
           c-nome-fim = p-nome-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByUsuario DBOProgram 
PROCEDURE setConstraintByUsuario :
/*------------------------------------------------------------------------------
  Purpose:     Informa o c¢digo do usu†rio (inicio e fim) para filtro da query
  Parameters:  p-cod-usuar-ini = C¢digo inicial do usu†rio
               p-cod-usuar-fim = C¢digo final do usu†rio
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-usuar-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-usuar-fim AS CHARACTER NO-UNDO.

    ASSIGN c-cod-usuar-ini = p-cod-usuar-ini
           c-cod-usuar-fim = p-cod-usuar-fim.

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
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

