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
&GLOBAL-DEFINE DBOName BOIN01089
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName natur-rendto
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
{inbo/boin01089.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-cod-natur-rendto-ini LIKE natur-rendto.cod-natur-rendto NO-UNDO. 
DEFINE VARIABLE i-cod-natur-rendto-fim LIKE natur-rendto.cod-natur-rendto NO-UNDO. 
DEFINE VARIABLE l-inativo              AS   LOGICAL                       NO-UNDO.

DEFINE TEMP-TABLE tt-natur-rendto-aux NO-UNDO LIKE natur-rendto 
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt_natur_rendto NO-UNDO
    FIELD tta_cod_natur_rendto  AS CHAR FORMAT "x(9)"
    FIELD ttv_des_natur_rendto  AS CHAR FORMAT "x(70)"
    FIELD ttv_log_pessoa_jurid  AS LOGICAL
    FIELD ttv_log_pessoa_fisic  AS LOGICAL
        .

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
         HEIGHT             = 16.1
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
        WHEN "cod-natur-rendto":U THEN ASSIGN pFieldValue = RowObject.cod-natur-rendto.
        WHEN "des-natur-rendto":U THEN ASSIGN pFieldValue = RowObject.des-natur-rendto.
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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ntrrndt_ix2
  Parameters:  
               retorna valor do campo cod-natur-rendto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-natur-rendto LIKE natur-rendto.cod-natur-rendto NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-natur-rendto = RowObject.cod-natur-rendto.

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
        WHEN "log-cofins":U THEN ASSIGN pFieldValue = RowObject.log-cofins.
        WHEN "log-csll":U THEN ASSIGN pFieldValue = RowObject.log-csll.
        WHEN "log-inativ":U THEN ASSIGN pFieldValue = RowObject.log-inativ.
        WHEN "log-ir":U THEN ASSIGN pFieldValue = RowObject.log-ir.
        WHEN "log-pfis-bra":U THEN ASSIGN pFieldValue = RowObject.log-pfis-bra.
        WHEN "log-pfis-exter":U THEN ASSIGN pFieldValue = RowObject.log-pfis-exter.
        WHEN "log-pis-pasep":U THEN ASSIGN pFieldValue = RowObject.log-pis-pasep.
        WHEN "log-pj-bra":U THEN ASSIGN pFieldValue = RowObject.log-pj-bra.
        WHEN "log-pj-exter":U THEN ASSIGN pFieldValue = RowObject.log-pj-exter.
		WHEN "log-agreg":U THEN ASSIGN pFieldValue = RowObject.log-agreg.
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
  Purpose:     Reposiciona registro com base no °ndice ntrrndt_ix2
  Parameters:  
               recebe valor do campo cod-natur-rendto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-natur-rendto LIKE natur-rendto.cod-natur-rendto NO-UNDO.

    FIND FIRST bfnatur-rendto WHERE 
        bfnatur-rendto.cod-natur-rendto = pcod-natur-rendto NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfnatur-rendto THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfnatur-rendto)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltro DBOProgram 
PROCEDURE openQueryFiltro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM TABLE FOR tt-natur-rendto-aux.

    DEFINE VARIABLE cQuery AS CHARACTER INITIAL "FOR EACH natur-rendto NO-LOCK" NO-UNDO.
    DEFINE VARIABLE cWhere         AS CHARACTER INITIAL "" NO-UNDO.
    
    EMPTY TEMP-TABLE tt-natur-rendto-aux.

    
    IF  i-cod-natur-rendto-ini = i-cod-natur-rendto-fim  THEN
        ASSIGN cWhere = cWhere + " where natur-rendto.cod-natur-rendto = " + "'" + string(i-cod-natur-rendto-ini) + "'".
    ELSE
        ASSIGN cWhere = cWhere + " where natur-rendto.cod-natur-rendto  >= " + "'" + string(i-cod-natur-rendto-ini) + "'" 
                               +  " AND natur-rendto.cod-natur-rendto  <= " + "'" + string(i-cod-natur-rendto-fim) + "'" .
    
    
    /*Estes parametros sempre estar∆o na cl†usula where, pois pertence ao filtro de tela do Zoom*/
    assign cWhere = cWhere + " AND natur-rendto.log-inativ     = " + string(l-inativo).


    
    RUN queryDinamica (INPUT cQuery +  cWhere).
   
   
                                        
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
    OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryDinamica DBOProgram 
PROCEDURE queryDinamica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER cQuery AS CHAR NO-UNDO.
    DEFINE VARIABLE qh     AS HANDLE    NO-UNDO.
    
    CREATE QUERY qh.
    qh:SET-BUFFERS(BUFFER natur-rendto:HANDLE).
    qh:QUERY-PREPARE(cQuery).
    qh:FORWARD-ONLY.  
    qh:QUERY-OPEN().

    REPEAT:
        qh:GET-NEXT().
        IF qh:QUERY-OFF-END THEN LEAVE.

        CREATE tt-natur-rendto-aux.
        BUFFER-COPY natur-rendto TO tt-natur-rendto-aux.
        ASSIGN tt-natur-rendto-aux.r-rowid = ROWID(natur-rendto).
    END.

    qh:QUERY-CLOSE().
    DELETE OBJECT qh.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDadosNaturRendto DBOProgram 
PROCEDURE retornaDadosNaturRendto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt_natur_rendto.

    FOR EACH tt_natur_rendto:
        DELETE tt_natur_rendto.
    END.

    FOR EACH bf{&TableName} FIELD(cod-natur-rendto des-natur-rendto log-pfis-bra log-pj-bra) NO-LOCK:
        CREATE tt_natur_rendto.
        ASSIGN tt_natur_rendto.tta_cod_natur_rendto = bf{&TableName}.cod-natur-rendto
               tt_natur_rendto.ttv_des_natur_rendto = bf{&TableName}.des-natur-rendto
               tt_natur_rendto.ttv_log_pessoa_fisic = bf{&TableName}.log-pfis-bra
               tt_natur_rendto.ttv_log_pessoa_jurid = bf{&TableName}.log-pj-bra.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltro DBOProgram 
PROCEDURE setConstraintFiltro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-natur-rendto-ini LIKE natur-rendto.cod-natur-rendto NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-natur-rendto-fim LIKE natur-rendto.cod-natur-rendto NO-UNDO.
    DEFINE INPUT PARAMETER p-inativo              LIKE natur-rendto.log-inativ       NO-UNDO.
    
    ASSIGN i-cod-natur-rendto-ini = p-cod-natur-rendto-ini
           i-cod-natur-rendto-fim = p-cod-natur-rendto-fim
           l-inativo              = p-inativo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaRegistroTabNaturRendto DBOProgram 
PROCEDURE validaRegistroTabNaturRendto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodNaturRendto AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER pLogExiste AS LOGICAL NO-UNDO.

    assign pLogExiste = no.
    
    find first bf{&TableName} no-lock
        where substr(bf{&TableName}.cod-natur-rendto,1,9) = pCodNaturRendto no-error.
    if avail bf{&TableName} then do:
        assign pLogExiste = yes.
    end.
    
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
    IF pType = 'CREATE':U THEN DO:
       IF CAN-FIND(FIRST  bf{&TableName}
                   WHERE  bf{&TableName}.cod-natur-rendto = RowObject.cod-natur-rendto) THEN DO:
          {utp/ut-liter.i "Natureza_de_rendimento" *}
          {method/svc/errors/inserr.i
           &ErrorNumber="7" 
           &ErrorType="EMS"
           &ErrorSubType="ERROR"
           &ErrorParameters= RETURN-VALUE}
       END.

    END.
    IF pType = "Create":U 
    OR pType = "Update":U THEN DO: /*para criaªío e alteraªío*/
         IF RowObject.des-natur-rendto = "" THEN DO: /* Descriá∆o deve ser diferente de branco */        
            {method/svc/errors/inserr.i
                      &ErrorNumber="190"
                      &ErrorType="EMS"
                      &ErrorParameters=" "}  
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

