&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
{include/i-prgvrs.i BOIN00944 2.00.00.004 } /*** "010004" 13/02/2026 18:41:44 ***/
{include/i-license-manager.i boin00944 MUT}

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
&GLOBAL-DEFINE DBOName BOIN00944
&GLOBAL-DEFINE DBOVersion 2.00.00.001
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName event-nfe-cte
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
{inbo/boin00944.i RowObject}

DEFINE TEMP-TABLE tt-event-nfe-cte-aux NO-UNDO LIKE event-nfe-cte
    FIELD sit-documento LIKE doc-orig-nfe.idi-situacao
    FIELD r-rowid       AS ROWID.


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* setConstraintMonitorCancel */                                        
DEFINE VARIABLE l-tg-pendente          AS LOGICAL INITIAL YES             NO-UNDO.
DEFINE VARIABLE l-tg-processado        AS LOGICAL INITIAL NO              NO-UNDO.
DEFINE VARIABLE l-tg-nao-permitido     AS LOGICAL INITIAL NO              NO-UNDO.
DEFINE VARIABLE l-tg-nfe               AS LOGICAL INITIAL YES             NO-UNDO.
DEFINE VARIABLE l-tg-cte               AS LOGICAL INITIAL YES             NO-UNDO.
DEFINE VARIABLE c-cod-emitente-ini   LIKE event-nfe-cte.cod-emitente      NO-UNDO.
DEFINE VARIABLE c-cod-emitente-fim   LIKE event-nfe-cte.cod-emitente      NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini    LIKE event-nfe-cte.cod-estabel       NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim    LIKE event-nfe-cte.cod-estabel       NO-UNDO.
DEFINE VARIABLE c-serie-ini          LIKE event-nfe-cte.serie-docto       NO-UNDO.
DEFINE VARIABLE c-serie-fim          LIKE event-nfe-cte.serie-docto       NO-UNDO.
DEFINE VARIABLE c-nro-docto-ini      LIKE event-nfe-cte.nro-docto         NO-UNDO.
DEFINE VARIABLE c-nro-docto-fim      LIKE event-nfe-cte.nro-docto         NO-UNDO.
DEFINE VARIABLE dt-emis-event-ini    LIKE event-nfe-cte.dat-emis-event    NO-UNDO.
DEFINE VARIABLE dt-emis-event-fim    LIKE event-nfe-cte.dat-emis-event    NO-UNDO.
DEFINE VARIABLE dt-recebto-event-ini LIKE event-nfe-cte.dat-recebto-event NO-UNDO.
DEFINE VARIABLE dt-recebto-event-fim LIKE event-nfe-cte.dat-recebto-event NO-UNDO.


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
         HEIGHT             = 12.88
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
        WHEN "ch-acesso-comp-nfe":U THEN ASSIGN pFieldValue = RowObject.ch-acesso-comp-nfe.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
        WHEN "cod-protoc-cancel":U THEN ASSIGN pFieldValue = RowObject.cod-protoc-cancel.
        WHEN "cod-usuar-desativ":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-desativ.
        WHEN "des-justif":U THEN ASSIGN pFieldValue = RowObject.des-justif.
        WHEN "des-justif-desativ":U THEN ASSIGN pFieldValue = RowObject.des-justif-desativ.
        WHEN "hra-emis-event":U THEN ASSIGN pFieldValue = RowObject.hra-emis-event.
        WHEN "hra-recebto-event":U THEN ASSIGN pFieldValue = RowObject.hra-recebto-event.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
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
        WHEN "dat-desativ":U THEN ASSIGN pFieldValue = RowObject.dat-desativ.
        WHEN "dat-emis-event":U THEN ASSIGN pFieldValue = RowObject.dat-emis-event.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-livre-3":U THEN ASSIGN pFieldValue = RowObject.dat-livre-3.
        WHEN "dat-livre-4":U THEN ASSIGN pFieldValue = RowObject.dat-livre-4.
        WHEN "dat-recebto-event":U THEN ASSIGN pFieldValue = RowObject.dat-recebto-event.
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
        WHEN "idi-sit-event":U THEN ASSIGN pFieldValue = RowObject.idi-sit-event.
        WHEN "idi-tip-docto":U THEN ASSIGN pFieldValue = RowObject.idi-tip-docto.
        WHEN "idi-tip-event":U THEN ASSIGN pFieldValue = RowObject.idi-tip-event.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-livre-3":U THEN ASSIGN pFieldValue = RowObject.num-livre-3.
        WHEN "num-livre-4":U THEN ASSIGN pFieldValue = RowObject.num-livre-4.
        WHEN "num-seq":U THEN ASSIGN pFieldValue = RowObject.num-seq.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice evntnfct_id
  Parameters:  
               retorna valor do campo ch-acesso-comp-nfe
               retorna valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pch-acesso-comp-nfe LIKE event-nfe-cte.ch-acesso-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE event-nfe-cte.num-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
           pnum-seq = RowObject.num-seq.

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
        WHEN "log-livre-3":U THEN ASSIGN pFieldValue = RowObject.log-livre-3.
        WHEN "log-livre-4":U THEN ASSIGN pFieldValue = RowObject.log-livre-4.
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
  Purpose:     Reposiciona registro com base no °ndice evntnfct_id
  Parameters:  
               recebe valor do campo ch-acesso-comp-nfe
               recebe valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pch-acesso-comp-nfe LIKE event-nfe-cte.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq LIKE event-nfe-cte.num-seq NO-UNDO.

    FIND FIRST bfevent-nfe-cte WHERE 
        bfevent-nfe-cte.ch-acesso-comp-nfe = pch-acesso-comp-nfe AND 
        bfevent-nfe-cte.num-seq = pnum-seq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfevent-nfe-cte THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfevent-nfe-cte)).
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
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMonitorCancel DBOProgram 
PROCEDURE openQueryMonitorCancel :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM TABLE FOR tt-event-nfe-cte-aux.
    EMPTY TEMP-TABLE tt-event-nfe-cte-aux.
    
    FOR EACH {&TableName} NO-LOCK 
       WHERE {&TableName}.cod-emitente      >= c-cod-emitente-ini
         AND {&TableName}.cod-emitente      <= c-cod-emitente-fim
         AND {&TableName}.cod-estabel       >= c-cod-estabel-ini 
         AND {&TableName}.cod-estabel       <= c-cod-estabel-fim 
         AND {&TableName}.serie-docto       >= c-serie-ini       
         AND {&TableName}.serie-docto       <= c-serie-fim       
         AND {&TableName}.nro-docto         >= c-nro-docto-ini   
         AND {&TableName}.nro-docto         <= c-nro-docto-fim   
         AND {&TableName}.dat-emis-event    >= dt-emis-event-ini    
         AND {&TableName}.dat-emis-event    <= dt-emis-event-fim  
         AND {&TableName}.dat-recebto-event >= dt-recebto-event-ini    
         AND {&TableName}.dat-recebto-event <= dt-recebto-event-fim                   
         AND  ( ({&TableName}.idi-sit-event = 1 AND l-tg-pendente)
             OR ({&TableName}.idi-sit-event = 2 AND l-tg-processado)
             OR ({&TableName}.idi-sit-event = 3 AND l-tg-nao-permitido))
         AND (  ({&TableName}.idi-tip-docto = 1 AND l-tg-nfe)
             OR ({&TableName}.idi-tip-docto = 2 AND l-tg-cte)):

        CREATE tt-event-nfe-cte-aux.
        BUFFER-COPY {&TableName} TO tt-event-nfe-cte-aux.  
        ASSIGN tt-event-nfe-cte-aux.r-rowid = ROWID({&TableName}).   

        /* Busca a situaá∆o do documento origem */
        IF {&TableName}.idi-tip-docto = 1 THEN DO:  /* nfe */
            FOR FIRST doc-orig-nfe FIELDS(idi-situacao)
                WHERE doc-orig-nfe.idi-orig-trad = 2 
                  AND doc-orig-nfe.ch-acesso-comp-nfe = {&TableName}.ch-acesso-comp-nfe NO-LOCK:
                ASSIGN tt-event-nfe-cte-aux.sit-documento = doc-orig-nfe.idi-situacao.
            END.
        END.
        ELSE IF {&TableName}.idi-tip-docto = 2  THEN DO: /* cte */
            FOR FIRST docto-orig-cte FIELDS(idi-situacao)
                WHERE docto-orig-cte.idi-orig-trad = 2 
                  AND docto-orig-cte.cod-aces-comp-nfe = {&TableName}.ch-acesso-comp-nfe NO-LOCK:
                ASSIGN tt-event-nfe-cte-aux.sit-documento = docto-orig-cte.idi-situacao.
            END.
        END.
    END.              
    
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMonitorCancel DBOProgram 
PROCEDURE setConstraintMonitorCancel :
/*------------------------------------------------------------------------------
  Purpose: Setar variˇveis utilizadas na abertura da query utilizada pelo monitor   
  Parameters: p-tg-pendente          : mostra os cancelamentos com situacao pendente
              p-tg-processado        : mostra os cancelamentos com situacao processado
              p-tg-nao-permitido     : mostra os cancelamentos com situacao nao permitido
              p-tg-nfe               : mostra os cancelamentos de documentos do tipo nfe
              p-tg-cte               : mostra os cancelamentos de documentos do tipo cte  
              p-cod-emitente-ini     : recebe o valor inicial da faixa para emitente
              p-cod-emitente-fim     : recebe o valor final da faixa para emitente
              p-cod-estabel-ini      : recebe o valor inicial da faixa para estabelecimento
              p-cod-estabel-fim      : recebe o valor final da faixa para estabelecimento
              p-serie-ini            : recebe o valor inicial da faixa para serie
              p-serie-fim            : recebe o valor final da faixa para serie
              p-nro-docto-ini        : recebe o valor inicial da faixa para documento
              p-nro-docto-fim        : recebe o valor final da faixa para documento
              p-dt-emis-event-ini    : recebe o valor inicial da faixa para data emiss„o do evento
              p-dt-emis-event-fim    : recebe o valor final da faixa para data emiss„o do evento
              p-dt-recebto-event-ini : recebe o valor inicial da faixa para data recebimento evento
              p-dt-recebto-event-fim : recebe o valor final da faixa para data recebimento evento   
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-tg-pendente            AS LOGICAL                         NO-UNDO.
    DEFINE INPUT PARAM p-tg-processado          AS LOGICAL                         NO-UNDO.
    DEFINE INPUT PARAM p-tg-nao-permitido       AS LOGICAL                         NO-UNDO.
    DEFINE INPUT PARAM p-tg-nfe                 AS LOGICAL                         NO-UNDO.
    DEFINE INPUT PARAM p-tg-cte                 AS LOGICAL                         NO-UNDO.
    DEFINE INPUT PARAM p-cod-emitente-ini     LIKE event-nfe-cte.cod-emitente      NO-UNDO.  
    DEFINE INPUT PARAM p-cod-emitente-fim     LIKE event-nfe-cte.cod-emitente      NO-UNDO.  
    DEFINE INPUT PARAM p-cod-estabel-ini      LIKE event-nfe-cte.cod-estabel       NO-UNDO.  
    DEFINE INPUT PARAM p-cod-estabel-fim      LIKE event-nfe-cte.cod-estabel       NO-UNDO.  
    DEFINE INPUT PARAM p-serie-ini            LIKE event-nfe-cte.serie-docto       NO-UNDO.  
    DEFINE INPUT PARAM p-serie-fim            LIKE event-nfe-cte.serie-docto       NO-UNDO.  
    DEFINE INPUT PARAM p-nro-docto-ini        LIKE event-nfe-cte.nro-docto         NO-UNDO.  
    DEFINE INPUT PARAM p-nro-docto-fim        LIKE event-nfe-cte.nro-docto         NO-UNDO.  
    DEFINE INPUT PARAM p-dt-emis-event-ini    LIKE event-nfe-cte.dat-emis-event    NO-UNDO.  
    DEFINE INPUT PARAM p-dt-emis-event-fim    LIKE event-nfe-cte.dat-emis-event    NO-UNDO.  
    DEFINE INPUT PARAM p-dt-recebto-event-ini LIKE event-nfe-cte.dat-recebto-event NO-UNDO.  
    DEFINE INPUT PARAM p-dt-recebto-event-fim LIKE event-nfe-cte.dat-recebto-event NO-UNDO. 
    

    ASSIGN l-tg-pendente        = p-tg-pendente     
           l-tg-processado      = p-tg-processado   
           l-tg-nao-permitido   = p-tg-nao-permitido
           l-tg-nfe             = p-tg-nfe          
           l-tg-cte             = p-tg-cte
           c-cod-emitente-ini   = p-cod-emitente-ini    
           c-cod-emitente-fim   = p-cod-emitente-fim    
           c-cod-estabel-ini    = p-cod-estabel-ini     
           c-cod-estabel-fim    = p-cod-estabel-fim     
           c-serie-ini          = p-serie-ini           
           c-serie-fim          = p-serie-fim           
           c-nro-docto-ini      = p-nro-docto-ini       
           c-nro-docto-fim      = p-nro-docto-fim       
           dt-emis-event-ini    = p-dt-emis-event-ini   
           dt-emis-event-fim    = p-dt-emis-event-fim   
           dt-recebto-event-ini = p-dt-recebto-event-ini
           dt-recebto-event-fim = p-dt-recebto-event-fim.         
    
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

    /****** Validaá‰es comuns para todos os tipos de evento tratados por essa BO ******/
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        IF pType = "CREATE":U THEN DO:
            /*:T--- Verifica se o registro j† existe, caso exista, retorna erro ---*/
            IF can-find(first bf{&TableName}
                        where bf{&TableName}.ch-acesso-comp-nfe  = RowObject.ch-acesso-comp-nfe
                          and bf{&TableName}.num-seq             = RowObject.num-seq) then do:
                {utp/ut-liter.i "Evento" * }
                {method/svc/errors/inserr.i &ErrorNumber=7
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE"}
            end.
        END.

        IF RowObject.ch-acesso-comp-nfe = "" OR
           RowObject.ch-acesso-comp-nfe = ? THEN DO:
            {utp/ut-liter.i Chave_acesso * }
            {method/svc/errors/inserr.i &ErrorNumber="56274"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="RETURN-VALUE"}
        END.

        IF NOT CAN-FIND(FIRST estabelec WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {utp/ut-liter.i Estabelecimento *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="RETURN-VALUE + ' ' + RowObject.cod-estabel"}
        END.
    END.

    IF pType = "DELETE":U THEN DO:
        /*:T--- Validaá‰es para exclus∆o de registro ---*/
    END.

    //Valicaá‰es espec°ficas para cada tipo de evento
    CASE RowObject.idi-tip-event:
    	WHEN 1 THEN DO: /*Evento cancelamento*/
    		/*:T--- Validaá‰es para evento de cancelamento ---*/
    	END.
    	WHEN 2 THEN DO: /*Evento de desacordo CT-e */
    		/*:T--- Validaá‰es para evento de desacordo CT-e ---*/
            RUN validateRecordDesacordoCTe (INPUT pType).
    	END.
    END.    

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecordDesacordoCTe DBOProgram 
PROCEDURE validateRecordDesacordoCTe :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/ 
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        IF pType = "CREATE":U THEN DO:
            //Bloquear a criaá∆o de eventos para a mesma chave de acesso! S¢ ser† poss°vel se n∆o tiver 
            //nenhum cadastrado na base ou tiver outros cadastrados na base porÇm na situaá∆o de Autorizado ou Cancelado.
            for each bf{&TableName} no-lock
               where bf{&TableName}.ch-acesso-comp-nfe  = RowObject.ch-acesso-comp-nfe
                 and bf{&TableName}.idi-tip-event       = 2: //Desacordo
                
                //Pendente, Em processamento, Rejeitado, Em cancelamento
                IF CAN-DO("1,4,5,6":U, STRING(bf{&TableName}.idi-sit-event)) THEN DO:
                    {utp/ut-liter.i "de_desacordo" * }
                    //J† existe evento n∆o autorizado relacionado a chave acesso
                    {method/svc/errors/inserr.i &ErrorNumber="58114"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="RowObject.ch-acesso-comp-nfe + '~~~~' + RETURN-VALUE"}
                    LEAVE.
                end.
            end.

            if length(RowObject.des-justif) < 15 then do:
                {utp/ut-liter.i " 15 caracteres para a justificativa do desacordo" *}
                {method/svc/errors/inserr.i &ErrorNumber="31777"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE"}
            end.

            IF LENGTH(RowObject.ch-acesso-comp-nfe) <> 44 THEN DO:
                {utp/ut-liter.i Chave_de_acesso * }
                {method/svc/errors/inserr.i &ErrorNumber="54898"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE + '~~~~44'"}
            END.
            IF NOT CAN-DO("57,67", SUBSTRING(RowObject.ch-acesso-comp-nfe,21,2)) THEN DO:
                {utp/ut-liter.i Posiá∆o_21_da_chave_de_acesso * }
                {method/svc/errors/inserr.i &ErrorNumber="29928"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE + '~~~~57 ou 67'"}
            END.

        END.
    END.

    IF pType = "DELETE":U THEN DO:
        /*:T--- Validaá‰es para exclus∆o de registro ---*/
        IF CAN-DO("2,3,4,6,7":U, STRING(RowObject.idi-sit-event)) THEN DO:
            DEF VAR oSituacaoEventoList  AS rep.list.SituacaoEventoList  NO-UNDO.
            DEF VAR c-literal-aux AS CHAR NO-UNDO.
            oSituacaoEventoList = new rep.list.SituacaoEventoList().

            {utp/ut-liter.i evento * }
            ASSIGN c-literal-aux = RETURN-VALUE + " (" + oSituacaoEventoList:getDescricao(RowObject.idi-sit-event) + ") ".
            {utp/ut-liter.i exclus∆o * }
            {method/svc/errors/inserr.i &ErrorNumber="19194"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-literal-aux + '~~~~' + RETURN-VALUE"}
            DELETE OBJECT oSituacaoEventoList NO-ERROR.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaChave DBOProgram 
PROCEDURE validaChave :
/*:T------------------------------------------------------------------------------
   2 digitos  ñ cUF    ñ CÛdigo da UF do emitente do Documento Fiscal
   4 digitos  ñ AAMM   ñ Ano e MÍs de emiss„o do CT-e
   14 digitos ñ CNPJ   ñ CNPJ do emitente
   2 digitos  ñ mod    ñ Modelo do Documento Fiscal
   3 digitos  ñ serie  ñ SÈrie do Documento Fiscal
   9 digitos  ñ nCT    ñ N˙mero do Documento Fiscal
   1 digito   ñ tpEmis ñ Forma de emiss„o do CT-e
   8 digitos  ñ cCT    ñ CÛdigo NumÈrico que compıe a Chave de Acesso (AleatÛrio)
   1 digito   ñ cDV    ñ DÌgito Verificador da Chave de Acesso
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pChave  LIKE {&TableName}.ch-acesso-comp-nfe NO-UNDO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLastNumSeq DBOProgram 
PROCEDURE getLastNumSeq :
/*:T------------------------------------------------------------------------------
Retorna num-seq a ser utilizada para a chave na criacao do registro
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER pChave  LIKE {&TableName}.ch-acesso-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAMETER pNumSeq LIKE {&TableName}.num-seq            NO-UNDO.

    pNumSeq = 1.
    FOR LAST {&TableName} NO-LOCK
        WHERE {&TableName}.ch-acesso-comp-nfe = pChave
        BY {&TableName}.num-seq:
        pNumSeq = pNumSeq + {&TableName}.num-seq.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*:T------------------------------------------------------------------------------
------------------------------------------------------------------------------*/
    
    define variable iNumSeq like {&TableName}.num-seq no-undo.

    if RowObject.num-seq = 0 then do: /*registro novo*/
        run getLastNumSeq (input RowObject.ch-acesso-comp-nfe,
                           output iNumSeq).
        RowObject.num-seq = iNumSeq.
    end.

    if RowObject.idi-sit-event = 0 then do: /*registro novo*/
        RowObject.idi-sit-event = 1. /*pendente*/
    end.

    if can-do("57,67",substring(RowObject.ch-acesso-comp-nfe,21,2)) then do:
        RowObject.idi-tip-docto = 2. /*CTe*/
    end.

    if RowObject.nro-docto = "" then do:
        RowObject.nro-docto = substring(RowObject.ch-acesso-comp-nfe,26,9).
    end.

    if RowObject.serie-docto = "" then do:
        RowObject.serie-docto = substring(RowObject.ch-acesso-comp-nfe,23,3).
    end.

    if RowObject.cod-emitente = 0 then do:
        for first emitente no-lock
            where emitente.cgc = substring(RowObject.ch-acesso-comp-nfe,7,14):
            RowObject.cod-emitente = emitente.cod-emitente.
        end.
    end.

    if RowObject.dat-emis-event = ? then do:
        assign RowObject.dat-emis-event = today
               RowObject.hra-emis-event = string(time, "hh:mm:ss").
    end.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNumSeq DBOProgram 
PROCEDURE getNumSeq :
/*:T------------------------------------------------------------------------------
Retorna num-seq a ser utilizada para a chave na criacao do registro
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER pChave  LIKE {&TableName}.ch-acesso-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAMETER pNumSeq LIKE {&TableName}.num-seq            NO-UNDO.

    FOR LAST {&TableName} NO-LOCK
       WHERE {&TableName}.ch-acesso-comp-nfe = pChave
          BY {&TableName}.num-seq:
        pNumSeq = {&TableName}.num-seq.
    END.

    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaStatus DBOProgram 
PROCEDURE atualizaStatus :
/*:T------------------------------------------------------------------------------
  Atualiza a situaá∆o do evento conforme o pStatus informado
  Parameters: pChave  : Chave de acesso do evento
              pNumSeq : N£mero sequencial do evento
              pStatus : Situaá∆o do evento (1-pendente 2-Processado 3-N∆o permitido 4-Em processamento 5-Rejeitado)
  Notes:
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pChave  LIKE {&TableName}.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pNumSeq LIKE {&TableName}.num-seq            NO-UNDO.
    DEFINE INPUT PARAMETER pStatus LIKE {&TableName}.idi-sit-event      NO-UNDO.

    FOR FIRST {&TableName} EXCLUSIVE-LOCK
        WHERE {&TableName}.ch-acesso-comp-nfe = pChave
          AND {&TableName}.num-seq            = pNumSeq:
        {&TableName}.idi-sit-event = pStatus. /* 1-pendente 2-Processado 3-N„o permitido 4-Em processamento 5-Rejeitado */
    END.
    RELEASE {&TableName}.

    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaStatusProcessado DBOProgram 
PROCEDURE atualizaStatusProcessado :
/*:T------------------------------------------------------------------------------
 Atualiza para processado a situaá∆o do evento
 Parameters: pChave  : Chave de acesso do evento
             pNumSeq : N£mero sequencial do evento
             pProtoc : C¢digo do protocolo de autorizaá∆o
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pChave  LIKE {&TableName}.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pNumSeq LIKE {&TableName}.num-seq            NO-UNDO.
    DEFINE INPUT PARAMETER pProtoc LIKE {&TableName}.cod-protoc         NO-UNDO.

    FOR FIRST {&TableName} EXCLUSIVE-LOCK
        WHERE {&TableName}.ch-acesso-comp-nfe = pChave
          AND {&TableName}.num-seq            = pNumSeq:
        {&TableName}.idi-sit-event = 2. /* 1-pendente 2-Processado 3-N∆o permitido 4-Em processamento 5-Rejeitado 6-Em cancelamento 7-Cancelado */
        {&TableName}.cod-protoc    = pProtoc.
    END.
    RELEASE {&TableName}.

    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaStatusCancelado DBOProgram 
PROCEDURE atualizaStatusCancelado :
/*:T------------------------------------------------------------------------------
 Atualiza para cancelado a situaá∆o do evento
 Parameters: pChave  : Chave de acesso do evento
             pNumSeq : N£mero sequencial do evento
             pProtoc : C¢digo do protocolo de autorizaá∆o do cancelamento
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pChave        LIKE {&TableName}.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pNumSeq       LIKE {&TableName}.num-seq            NO-UNDO.
    DEFINE INPUT PARAMETER pProtocCancel LIKE {&TableName}.cod-protoc-cancel  NO-UNDO.

    FOR FIRST {&TableName} EXCLUSIVE-LOCK
        WHERE {&TableName}.ch-acesso-comp-nfe = pChave
          AND {&TableName}.num-seq            = pNumSeq:
        {&TableName}.idi-sit-event     = 7. /* 1-pendente 2-Processado 3-N∆o permitido 4-Em processamento 5-Rejeitado 6-Em cancelamento 7-Cancelado */
        {&TableName}.cod-protoc-cancel = pProtocCancel.
    END.
    RELEASE {&TableName}.

    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord:

    IF RowObject.idi-tip-event = 2 THEN //Desacordo CT-e
        RUN deleteMessagesDesacordo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteMessagesDesacordo DBOProgram 
PROCEDURE deleteMessagesDesacordo:

    FOR EACH msg-ret-nfe EXCLUSIVE-LOCK
       WHERE msg-ret-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
         AND msg-ret-nfe.idi-orig-trad      = 3
         AND msg-ret-nfe.int-1              = RowObject.num-seq:
        DELETE msg-ret-nfe.
    END.
    RELEASE msg-ret-nfe.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
