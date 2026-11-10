&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
{include/i-prgvrs.i BOIN00961Q01 2.00.00.005 } /*** "010005" 13/11/2023 11:45:43 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin00961Q01 MAQ}
&ENDIF


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
&GLOBAL-DEFINE DBOName BOIN00961Q01
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName carg-rural
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/****************************************
** TECNICA SEGURANCA ESTABELECIMENTO
****************************************/
{cdp/cd0031.i}
/****************************************
** TECNICA SEGURANCA ESTABELECIMENTO
****************************************/

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


&GLOBAL-DEFINE XMLReceiver YES  
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

{inbo/boin00961.i RowObject}
{inbo/boin00961.i tt-carg-rural-zoom}

DEFINE VARIABLE i-num-carg-ini   AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-num-carg-fim   AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-carga-ini      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-carga-fim      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-placa-ini      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-placa-fim      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-estab-ini      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-estab-fim      AS CHARACTER NO-UNDO.
DEFINE VARIABLE d-dat-trans-ini  AS DATE      NO-UNDO.
DEFINE VARIABLE d-dat-trans-fim  AS DATE      NO-UNDO.
DEFINE VARIABLE d-dat-entr-ini   AS DATE      NO-UNDO.
DEFINE VARIABLE d-dat-entr-fim   AS DATE      NO-UNDO.
DEFINE VARIABLE c-cod-rota-ini   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-rota-fim   AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-cod-transp-ini AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-cod-transp-fim AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-situacao       AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-origem-query   AS INTEGER   NO-UNDO.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}      FOR {&TableName}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-enable-cd-freq DBOProgram 
FUNCTION fn-situacao RETURNS CHARACTER
  ( i-sit AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
        WHEN "cod-carga":U THEN ASSIGN pFieldValue = RowObject.cod-carga.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-inter-veic":U THEN ASSIGN pFieldValue = RowObject.cod-inter-veic.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-placa":U THEN ASSIGN pFieldValue = RowObject.cod-placa.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-rota":U THEN ASSIGN pFieldValue = RowObject.cod-rota.
        WHEN "cod-uf":U THEN ASSIGN pFieldValue = RowObject.cod-uf.
        WHEN "hra-entr":U THEN ASSIGN pFieldValue = RowObject.hra-entr.
        WHEN "hra-trans":U THEN ASSIGN pFieldValue = RowObject.hra-trans.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nom-motorista":U THEN ASSIGN pFieldValue = RowObject.nom-motorista.
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
        WHEN "dat-entr":U THEN ASSIGN pFieldValue = RowObject.dat-entr.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-trans":U THEN ASSIGN pFieldValue = RowObject.dat-trans.
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
        WHEN "qtd-aferid":U THEN ASSIGN pFieldValue = RowObject.qtd-aferid.
        WHEN "qtd-peso-brut":U THEN ASSIGN pFieldValue = RowObject.qtd-peso-brut.
        WHEN "qtd-peso-liq":U THEN ASSIGN pFieldValue = RowObject.qtd-peso-liq.
        WHEN "qtd-peso-tara":U THEN ASSIGN pFieldValue = RowObject.qtd-peso-tara.
        WHEN "val-densidade":U THEN ASSIGN pFieldValue = RowObject.val-densidade.
        WHEN "val-hodom-final":U THEN ASSIGN pFieldValue = RowObject.val-hodom-final.
        WHEN "val-hodom-inicial":U THEN ASSIGN pFieldValue = RowObject.val-hodom-inicial.
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
        WHEN "cdn-sit":U THEN ASSIGN pFieldValue = RowObject.cdn-sit.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "num-carg":U THEN ASSIGN pFieldValue = RowObject.num-carg.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "qti-comptmento":U THEN ASSIGN pFieldValue = RowObject.qti-comptmento.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice num-carg
  Parameters:  
               retorna valor do campo num-carg
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-carg LIKE carg-rural.num-carg NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-carg = RowObject.num-carg.

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
  Purpose:     Reposiciona registro com base no °ndice num-carg
  Parameters:  
               recebe valor do campo num-carg
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-carg LIKE carg-rural.num-carg NO-UNDO.

    FIND FIRST bfcarg-rural WHERE 
        bfcarg-rural.num-carg = pnum-carg NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcarg-rural THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcarg-rural)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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

    OPEN QUERY qr{&tableName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom DBOProgram 
PROCEDURE openQueryZoom :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-qry         AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-qry         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-by          AS CHARACTER   NO-UNDO.    
    DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO. 
    
    DEFINE OUTPUT PARAMETER TABLE FOR tt-carg-rural-zoom.
    
    
    CASE i-origem-query:
        WHEN 1 THEN 
            ASSIGN c-qry = c-qry +   "carg-rural.cod-estabel  >= '"    + c-estab-ini             + "' "  +
                                 "AND carg-rural.cod-estabel  <= '"    + c-estab-fim             + "' "  +
                                 "AND carg-rural.dat-trans >= DATE('"  + STRING(d-dat-trans-ini) + "') " +
                                 "AND carg-rural.dat-trans <= DATE('" + STRING(d-dat-trans-fim)  + "') " +
                                 "AND carg-rural.dat-entr  >= DATE('" + STRING(d-dat-entr-ini)   + "') " +
                                 "AND carg-rural.dat-entr  <= DATE('" + STRING(d-dat-entr-fim)   + "') " 
                   c-by  = " BY carg-rural.cod-estabel BY carg-rural.dat-trans BY carg-rural.dat-entr".    
        WHEN 2 THEN 
            ASSIGN c-qry = c-qry +   "carg-rural.num-carg  >= " + STRING(i-num-carg-ini) + "  " +
                                 "AND carg-rural.num-carg  <= " + STRING(i-num-carg-fim) + "  " + 
                                 "AND carg-rural.cod-carga >= '"  + c-carga-ini          + "' " +
                                 "AND carg-rural.cod-carga <= '"  + c-carga-fim          + "' " +
                                 "AND carg-rural.cod-placa >= '" + c-placa-ini           + "' " +  
                                 "AND carg-rural.cod-placa <= '" + c-placa-fim           + "' "
                    c-by = " BY carg-rural.num-carg BY carg-rural.cod-carga BY carg-rural.cod-placa".
        WHEN 3 THEN 
            ASSIGN c-qry = c-qry +   "carg-rural.cod-rota    >= '"  + c-cod-rota-ini           + "' " + 
                                 "AND carg-rural.cod-rota    <= '"  + c-cod-rota-fim           + "' " + 
                                 "AND carg-rural.cod-transp  >= "   + STRING(i-cod-transp-ini) + " "  +
                                 "AND carg-rural.cod-transp  <= "   + STRING(i-cod-transp-fim) + " "
                   c-by  = " BY carg-rural.cod-rota BY carg-rural.cod-transp".
        OTHERWISE
            ASSIGN c-qry = "FALSE":U.        
    END CASE.

    ASSIGN c-qry =  "FOR EACH carg-rural NO-LOCK WHERE ":U + c-qry + fn-situacao(i-situacao) + c-by.    
    
    h-qry = QUERY {&QueryName}:HANDLE.     
    h-qry:SET-BUFFERS(BUFFER {&TableName}:HANDLE) NO-ERROR.  
    h-qry:QUERY-PREPARE(c-qry).
    h-qry:QUERY-OPEN().
    
    EMPTY TEMP-TABLE tt-carg-rural-zoom NO-ERROR.
    REPEAT:
        h-qry:GET-NEXT().
        IF h-qry:QUERY-OFF-END THEN LEAVE.        
        
        
        ASSIGN c-cod-estabel = BUFFER {&TableName}:HANDLE:BUFFER-FIELD("cod-estabel"):BUFFER-VALUE .
        
        {cdp/cd0031a.i  c-cod-estabel }
        
        CREATE tt-carg-rural-zoom.
        ASSIGN tt-carg-rural-zoom.cod-estabel    = c-cod-estabel 
               tt-carg-rural-zoom.dat-trans      = BUFFER {&TableName}:HANDLE:BUFFER-FIELD("dat-trans"):BUFFER-VALUE 
               tt-carg-rural-zoom.dat-entr       = BUFFER {&TableName}:HANDLE:BUFFER-FIELD("dat-entr"):BUFFER-VALUE 
               tt-carg-rural-zoom.cod-carga      = BUFFER {&TableName}:HANDLE:BUFFER-FIELD("cod-carga"):BUFFER-VALUE 
               tt-carg-rural-zoom.num-carg       = BUFFER {&TableName}:HANDLE:BUFFER-FIELD("num-carg"):BUFFER-VALUE 
               tt-carg-rural-zoom.it-codigo      = BUFFER {&TableName}:HANDLE:BUFFER-FIELD("it-codigo"):BUFFER-VALUE 
               tt-carg-rural-zoom.qti-comptmento = BUFFER {&TableName}:HANDLE:BUFFER-FIELD("qti-comptmento"):BUFFER-VALUE 
               tt-carg-rural-zoom.cod-placa      = BUFFER {&TableName}:HANDLE:BUFFER-FIELD("cod-placa"):BUFFER-VALUE 
               tt-carg-rural-zoom.cod-transp     = BUFFER {&TableName}:HANDLE:BUFFER-FIELD("cod-transp"):BUFFER-VALUE 
               tt-carg-rural-zoom.cod-rota       = BUFFER {&TableName}:HANDLE:BUFFER-FIELD("cod-rota"):BUFFER-VALUE 
               tt-carg-rural-zoom.cdn-sit        = BUFFER {&TableName}:HANDLE:BUFFER-FIELD("cdn-sit"):BUFFER-VALUE
               tt-carg-rural-zoom.r-rowid        = BUFFER {&TableName}:HANDLE:ROWID.
    END.    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCargaPlaca DBOProgram 
PROCEDURE setConstraintCargaPlaca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-carg-ini  AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-num-carg-fim  AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-carga-ini     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-carga-fim     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-placa-ini     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-placa-fim     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-situacao      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-origem-query  AS INTEGER   NO-UNDO.
    
    ASSIGN i-num-carg-ini = p-num-carg-ini
           i-num-carg-fim = p-num-carg-fim
           c-carga-ini    = p-carga-ini
           c-carga-fim    = p-carga-fim
           c-placa-ini    = p-placa-ini
           c-placa-fim    = p-placa-fim
           i-situacao     = p-situacao
           i-origem-query = p-origem-query.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEstabData DBOProgram 
PROCEDURE setConstraintEstabData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-estab-ini      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-estab-fim      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-dat-trans-ini  AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER p-dat-trans-fim  AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER p-dat-entr-ini   AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER p-dat-entr-fim   AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER p-situacao       AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-origem-query   AS INTEGER   NO-UNDO.

    ASSIGN  c-estab-ini     = p-estab-ini
            c-estab-fim     = p-estab-fim
            d-dat-trans-ini = p-dat-trans-ini
            d-dat-trans-fim = p-dat-trans-fim
            d-dat-entr-ini  = p-dat-entr-ini 
            d-dat-entr-fim  = p-dat-entr-fim
            i-situacao      = p-situacao
            i-origem-query  = p-origem-query.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintTranspRota DBOProgram 
PROCEDURE setConstraintTranspRota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-rota-ini   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-rota-fim   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-transp-ini AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-transp-fim AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-situacao       AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-origem-query   AS INTEGER   NO-UNDO.

   ASSIGN  c-cod-rota-ini   = p-cod-rota-ini  
           c-cod-rota-fim   = p-cod-rota-fim  
           i-cod-transp-ini = p-cod-transp-ini
           i-cod-transp-fim = p-cod-transp-fim
           i-situacao       = p-situacao
           i-origem-query   = p-origem-query.
          
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-situacao DBOProgram 
FUNCTION fn-situacao RETURNS CHARACTER
  ( i-sit AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/    
    DEFINE VARIABLE c-return AS CHARACTER NO-UNDO.   
    
    CASE i-sit:
        WHEN 1 THEN /* PENDENTES */
            ASSIGN c-return = " AND carg-rural.cdn-sit <> 5 ":U.
        
        WHEN 2 THEN /* ENCERRADA */
            ASSIGN c-return = " AND carg-rural.cdn-sit = 5 ":U.        
        OTHERWISE
             ASSIGN c-return = " ":U.    
    END CASE.

    RETURN c-return.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

