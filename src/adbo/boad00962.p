/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD00962 1.00.00.003} /* 01/10/2026 16:59:15 */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BOAD00962 MUT}
&ENDIF


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
&GLOBAL-DEFINE DBOName BOAD00962
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName dere-log-envio
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
{adbo/boad00962.i RowObject}
{adbo/boad00962.i tt-dere-log-envio-aux}
{adbo/boad00963.i tt-dere-log-envio-xml-aux}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf-dere-log-envio     FOR dere-log-envio.
DEFINE BUFFER bf-dere-log-envio-xml FOR dere-log-envio-xml.

DEFINE VARIABLE i-idi-tip-ambiente          AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-ep-codigo                 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-layout-ini            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-layout-fim            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-identif-event-ini     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-identif-event-fim     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-num-period-ini            AS integer     NO-UNDO.
DEFINE VARIABLE i-num-period-fim            AS integer     NO-UNDO.
DEFINE VARIABLE dt-dat-ult-gerac-ini        AS DATE        NO-UNDO.
DEFINE VARIABLE dt-dat-ult-gerac-fim        AS DATE        NO-UNDO.
DEFINE VARIABLE c-hra-ult-gerac-ini         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-hra-ult-gerac-fim         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-log-gerado-com-erro       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-log-enviado               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-log-em-processamento      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-log-autorizado            AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-log-rejeitado             AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-log-em-exclusao           AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-log-excluido              AS LOGICAL     NO-UNDO.
DEFINE VARIABLE iTransacao                  AS INTEGER     NO-UNDO.
DEFINE VARIABLE cListaSitLogEnv             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lch-arq-xml                 AS LONGCHAR    NO-UNDO.

/* Inicializaá∆o dos HANDLES utilizados pela BO */
DEFINE VARIABLE h-lfapi0600 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-lfapi0601 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-acomp     AS HANDLE NO-UNDO.

RUN piInicializaHandles.
/* FIM - Inicializaá∆o dos HANDLES utilizados pela BO */


{lfp/lf0600.i1} /* Definicao tt-params-generic / tt-error */
{lfp/lfapi0601.i} /* Definiá∆o tt-log-envio-xml */


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
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-layout":U THEN ASSIGN pFieldValue = RowObject.cod-layout.
        WHEN "cod-identif-event":U THEN ASSIGN pFieldValue = RowObject.cod-identif-event.
        WHEN "cod-ult-recibo":U THEN ASSIGN pFieldValue = RowObject.cod-ult-recibo.
        WHEN "hra-ult-gerac":U THEN ASSIGN pFieldValue = RowObject.hra-ult-gerac.
        WHEN "hra-ult-atualiz":U THEN ASSIGN pFieldValue = RowObject.hra-ult-atualiz.
        WHEN "cod-usuar-ult-atualiz":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-ult-atualiz.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
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
        WHEN "dat-ult-gerac":U THEN ASSIGN pFieldValue = RowObject.dat-ult-gerac.
        WHEN "dat-ult-atualiz":U THEN ASSIGN pFieldValue = RowObject.dat-ult-atualiz.
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
        WHEN "idi-tip-ambiente":U THEN ASSIGN pFieldValue = RowObject.idi-tip-ambiente.
        WHEN "num-period":U THEN ASSIGN pFieldValue = RowObject.num-period.
        WHEN "idi-ult-status-gerac":U THEN ASSIGN pFieldValue = RowObject.idi-ult-status-gerac.
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
  Purpose:     Retorna valores dos campos do °ndice drlgnv_id1
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-layout
               retorna valor do campo cod-identif-event
               retorna valor do campo num-period
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pidi-tip-ambiente      LIKE dere-log-envio.idi-tip-ambiente      NO-UNDO.
    DEFINE OUTPUT PARAMETER pep-codigo             LIKE dere-log-envio.ep-codigo             NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel           LIKE dere-log-envio.cod-estabel           NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-layout            LIKE dere-log-envio.cod-layout            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-identif-event     LIKE dere-log-envio.cod-identif-event     NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-period            LIKE dere-log-envio.num-period            NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pidi-tip-ambiente      = RowObject.idi-tip-ambiente
           pep-codigo             = RowObject.ep-codigo
           pcod-estabel           = RowObject.cod-estabel
           pcod-layout            = RowObject.cod-layout
           pcod-identif-event     = RowObject.cod-identif-event
           pnum-period            = RowObject.num-period.

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
  Purpose:     Reposiciona registro com base no °ndice drlgnv_id1
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-layout
               recebe valor do campo cod-identif-event
               recebe valor do campo num-period
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pidi-tip-ambiente      LIKE dere-log-envio.idi-tip-ambiente      NO-UNDO.
    DEFINE INPUT PARAMETER pep-codigo             LIKE dere-log-envio.ep-codigo             NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel           LIKE dere-log-envio.cod-estabel           NO-UNDO.
    DEFINE INPUT PARAMETER pcod-layout            LIKE dere-log-envio.cod-layout            NO-UNDO.
    DEFINE INPUT PARAMETER pcod-identif-event     LIKE dere-log-envio.cod-identif-event     NO-UNDO.
    DEFINE INPUT PARAMETER pnum-period            LIKE dere-log-envio.num-period            NO-UNDO.

    FIND FIRST bf-dere-log-envio WHERE 
               bf-dere-log-envio.idi-tip-ambiente      = pidi-tip-ambiente      AND
               bf-dere-log-envio.ep-codigo             = pep-codigo             AND
               bf-dere-log-envio.cod-estabel           = pcod-estabel           AND 
               bf-dere-log-envio.cod-layout            = pcod-layout            AND
               bf-dere-log-envio.cod-identif-event     = pcod-identif-event     AND 
               bf-dere-log-envio.num-period            = pnum-period            NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bf-dere-log-envio THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf-dere-log-envio)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicializaHandles DBOProgram 
PROCEDURE piInicializaHandles :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  NOT VALID-HANDLE(h-lfapi0600) THEN
        RUN lfp/lfapi0600.p PERSISTENT SET h-lfapi0600.

    IF  NOT VALID-HANDLE(h-lfapi0601) THEN
        RUN lfp/lfapi0601.p PERSISTENT SET h-lfapi0601.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroy DBOProgram 
PROCEDURE afterDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  VALID-HANDLE(h-lfapi0600) THEN DO:
        DELETE PROCEDURE h-lfapi0600.
        ASSIGN h-lfapi0600 = ?.
    END.
    IF  VALID-HANDLE(h-lfapi0601) THEN DO:
        DELETE PROCEDURE h-lfapi0601.
        ASSIGN h-lfapi0601 = ?.
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEventosMonitor DBOProgram 
PROCEDURE setConstraintEventosMonitor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-idi-tip-ambiente            AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER p-c-ep-codigo                 AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER p-c-cod-estabel-ini           AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER p-c-cod-estabel-fim           AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER p-c-cod-layout-ini            AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER p-c-cod-layout-fim            AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER p-c-cod-identif-event-ini     AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER p-c-cod-identif-event-fim     AS CHARACTER   NO-UNDO.
    define input parameter p-i-num-period-ini            AS integer     NO-UNDO.
    define input parameter p-i-num-period-fim            AS integer     NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-dat-ult-gerac-ini        AS DATE        NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-dat-ult-gerac-fim        AS DATE        NO-UNDO.
    DEFINE INPUT PARAMETER p-c-hra-ult-gerac-ini         AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER p-c-hra-ult-gerac-fim         AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER p-l-log-gerado-com-erro       AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER p-l-log-enviado               AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER p-l-log-em-processamento      AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER p-l-log-autorizado            AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER p-l-log-rejeitado             AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER p-l-log-em-exclusao           AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER p-l-log-excluido              AS LOGICAL     NO-UNDO.

    ASSIGN i-idi-tip-ambiente          = p-idi-tip-ambiente
           c-ep-codigo                 = p-c-ep-codigo
           c-cod-estabel-ini           = p-c-cod-estabel-ini            
           c-cod-estabel-fim           = p-c-cod-estabel-fim            
           c-cod-layout-ini            = p-c-cod-layout-ini           
           c-cod-layout-fim            = p-c-cod-layout-fim           
           c-cod-identif-event-ini     = p-c-cod-identif-event-ini
           c-cod-identif-event-fim     = p-c-cod-identif-event-fim
           i-num-period-ini            = p-i-num-period-ini
           i-num-period-fim            = p-i-num-period-fim
           dt-dat-ult-gerac-ini        = p-dt-dat-ult-gerac-ini       
           dt-dat-ult-gerac-fim        = p-dt-dat-ult-gerac-fim       
           c-hra-ult-gerac-ini         = p-c-hra-ult-gerac-ini        
           c-hra-ult-gerac-fim         = p-c-hra-ult-gerac-fim        
           l-log-gerado-com-erro       = p-l-log-gerado-com-erro              
           l-log-enviado               = p-l-log-enviado              
           l-log-em-processamento      = p-l-log-em-processamento     
           l-log-autorizado            = p-l-log-autorizado             
           l-log-rejeitado             = p-l-log-rejeitado            
           l-log-em-exclusao           = p-l-log-em-exclusao          
           l-log-excluido              = p-l-log-excluido.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEventosMonitor DBOProgram 
PROCEDURE openQueryEventosMonitor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE c-lista-idi-ult-status-gerac AS CHARACTER NO-UNDO.
    
    ASSIGN c-lista-idi-ult-status-gerac = "0".

    IF  l-log-gerado-com-erro  THEN  ASSIGN c-lista-idi-ult-status-gerac = c-lista-idi-ult-status-gerac + ",1".
    IF  l-log-enviado          THEN  ASSIGN c-lista-idi-ult-status-gerac = c-lista-idi-ult-status-gerac + ",2".
    IF  l-log-em-processamento THEN  ASSIGN c-lista-idi-ult-status-gerac = c-lista-idi-ult-status-gerac + ",3".
    IF  l-log-autorizado       THEN  ASSIGN c-lista-idi-ult-status-gerac = c-lista-idi-ult-status-gerac + ",4".
    IF  l-log-rejeitado        THEN  ASSIGN c-lista-idi-ult-status-gerac = c-lista-idi-ult-status-gerac + ",5".
    IF  l-log-em-exclusao      THEN  ASSIGN c-lista-idi-ult-status-gerac = c-lista-idi-ult-status-gerac + ",6".
    IF  l-log-excluido         THEN  ASSIGN c-lista-idi-ult-status-gerac = c-lista-idi-ult-status-gerac + ",7".

    assign c-hra-ult-gerac-ini = replace(c-hra-ult-gerac-ini,":","")
           c-hra-ult-gerac-fim = replace(c-hra-ult-gerac-fim,":","").

    OPEN QUERY {&QueryName} FOR EACH  {&TableName} NO-LOCK
                               WHERE  {&TableName}.idi-tip-ambiente         = i-idi-tip-ambiente
                                 AND  {&TableName}.ep-codigo                = c-ep-codigo
                                 AND  {&TableName}.cod-estabel             >= c-cod-estabel-ini            
                                 AND  {&TableName}.cod-estabel             <= c-cod-estabel-fim            
                                 AND  {&TableName}.cod-layout              >= c-cod-layout-ini           
                                 AND  {&TableName}.cod-layout              <= c-cod-layout-fim           
                                 AND (({&TableName}.cod-identif-event      >= c-cod-identif-event-ini
                                 AND   {&TableName}.cod-identif-event      <= c-cod-identif-event-fim)
                                 OR   {&TableName}.cod-identif-event        = "":U)
                                 AND  {&TableName}.num-period              >= i-num-period-ini 
                                 AND  {&TableName}.num-period              <= i-num-period-fim
                                 AND  {&TableName}.dat-ult-gerac           >= dt-dat-ult-gerac-ini       
                                 AND  {&TableName}.dat-ult-gerac           <= dt-dat-ult-gerac-fim       
                                 AND  {&TableName}.hra-ult-gerac           >= c-hra-ult-gerac-ini        
                                 AND  {&TableName}.hra-ult-gerac           <= c-hra-ult-gerac-fim        
                                 AND LOOKUP(STRING({&TableName}.idi-ult-status-gerac), c-lista-idi-ult-status-gerac, ",") > 0.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaTabelaParametros DBOProgram 
PROCEDURE buscaTabelaParametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER c-cod-usuario               AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER i-idi-tip-ambiente          AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cod-estabel-ini           AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cod-estabel-fim           AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cod-layout-ini            AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cod-layout-fim            AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cod-identif-event-ini     AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cod-identif-event-fim     AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER i-num-period-ini            AS integer     NO-UNDO.
    DEFINE OUTPUT PARAMETER i-num-period-fim            AS integer     NO-UNDO.
    DEFINE OUTPUT PARAMETER dt-dat-ult-gerac-ini        AS DATE        NO-UNDO.
    DEFINE OUTPUT PARAMETER dt-dat-ult-gerac-fim        AS DATE        NO-UNDO.
    DEFINE OUTPUT PARAMETER c-hra-ult-gerac-ini         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-hra-ult-gerac-fim         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER l-log-gerado-com-erro       AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER l-log-enviado               AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER l-log-em-processamento      AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER l-log-autorizado            AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER l-log-rejeitado             AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER l-log-em-exclusao           AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER l-log-excluido              AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER l-log-integr-tss            AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER l-log-gera-even-com-erro    AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER l-log-exporta-xml           AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cod-dir-export-xml        AS CHARACTER   NO-UNDO.

    /* ParÉmetros do Filtro */
    ASSIGN i-idi-tip-ambiente          = 2 /* PrÇ-Produá∆o */
           c-cod-estabel-ini           = "":U
           c-cod-estabel-fim           = "ZZZZZZZZZZZZZZ":U
           c-cod-layout-ini            = "":U
           c-cod-layout-fim            = "ZZZZZZZZ":U
           c-cod-identif-event-ini     = "":U
           c-cod-identif-event-fim     = "ZZZZZZZZZZZZZZZZZZZZZZZZZ":U
           i-num-period-ini            = int(string(year(today - day(today)),"9999") + string(month(today - day(today)),"99"))
           i-num-period-fim            = int(string(year(today),"9999")              + string(month(today),"99"))
           dt-dat-ult-gerac-ini        = (TODAY - 1)
           dt-dat-ult-gerac-fim        = TODAY
           c-hra-ult-gerac-ini         = "000000":U
           c-hra-ult-gerac-fim         = "999999":U
           l-log-gerado-com-erro       = YES
           l-log-enviado               = YES
           l-log-em-processamento      = YES
           l-log-autorizado            = YES
           l-log-rejeitado             = YES
           l-log-em-exclusao           = YES
           l-log-excluido              = YES.

    /* ParÉmetros da Regeraá∆o */
    ASSIGN l-log-integr-tss         = YES
           l-log-gera-even-com-erro = YES
           l-log-exporta-xml        = NO
           c-cod-dir-export-xml     = "":U.
    
    FOR FIRST param-gener NO-LOCK
        WHERE param-gener.cod-chave-1 = "param-monitor-dere" 
          AND param-gener.cod-chave-2 = TRIM(c-cod-usuario):

        /* ParÉmetros do Filtro */
        ASSIGN c-cod-estabel-ini           = TRIM(SUBSTRING(param-gener.cod-livre-1,   1,  20))
               c-cod-estabel-fim           = TRIM(SUBSTRING(param-gener.cod-livre-1,  21,  20))
               c-cod-layout-ini            = TRIM(SUBSTRING(param-gener.cod-livre-1,  41,  10))
               c-cod-layout-fim            = TRIM(SUBSTRING(param-gener.cod-livre-1,  51,  10))
               c-cod-identif-event-ini     = TRIM(SUBSTRING(param-gener.cod-livre-1,  61,  30))
               c-cod-identif-event-fim     = TRIM(SUBSTRING(param-gener.cod-livre-1,  91,  30))
               dt-dat-ult-gerac-ini        = param-gener.dat-livre-1
               dt-dat-ult-gerac-fim        = param-gener.dat-livre-2
               c-hra-ult-gerac-ini         = TRIM(SUBSTRING(param-gener.cod-livre-1, 121,  10))
               c-hra-ult-gerac-fim         = TRIM(SUBSTRING(param-gener.cod-livre-1, 131,  10))
               l-log-gerado-com-erro       = TRIM(SUBSTRING(param-gener.cod-livre-1, 141,   1)) = "S"
               l-log-enviado               = TRIM(SUBSTRING(param-gener.cod-livre-1, 142,   1)) = "S"
               l-log-em-processamento      = TRIM(SUBSTRING(param-gener.cod-livre-1, 143,   1)) = "S"
               l-log-autorizado            = TRIM(SUBSTRING(param-gener.cod-livre-1, 144,   1)) = "S"
               l-log-rejeitado             = TRIM(SUBSTRING(param-gener.cod-livre-1, 145,   1)) = "S"
               l-log-em-exclusao           = TRIM(SUBSTRING(param-gener.cod-livre-1, 146,   1)) = "S"
               l-log-excluido              = TRIM(SUBSTRING(param-gener.cod-livre-1, 147,   1)) = "S".
        ASSIGN i-idi-tip-ambiente          =  INT(SUBSTRING(param-gener.cod-livre-1, 148,   1)) NO-ERROR.

        if TRIM(SUBSTRING(param-gener.cod-livre-1, 149,  10)) <> "" and 
           TRIM(SUBSTRING(param-gener.cod-livre-1, 159,  10)) <> "" then
           assign i-num-period-ini = INT(TRIM(SUBSTRING(param-gener.cod-livre-1, 149,  10)))
                  i-num-period-fim = INT(TRIM(SUBSTRING(param-gener.cod-livre-1, 159,  10))) no-error.

        /* ParÉmetros da Regeraá∆o */
        ASSIGN l-log-integr-tss            = TRIM(SUBSTRING(param-gener.cod-livre-2,   1,   1)) = "S"
               l-log-exporta-xml           = TRIM(SUBSTRING(param-gener.cod-livre-2,   2,   1)) = "S"
               c-cod-dir-export-xml        = TRIM(SUBSTRING(param-gener.cod-livre-2,   3, 300))
               l-log-gera-even-com-erro    = TRIM(SUBSTRING(param-gener.cod-livre-2, 303,   1)) = "S".
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gravaTabelaParametros DBOProgram 
PROCEDURE gravaTabelaParametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER c-cod-usuario               AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER i-idi-tip-ambiente          AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-estabel-ini           AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-estabel-fim           AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-layout-ini            AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-layout-fim            AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-identif-event-ini     AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-identif-event-fim     AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER i-num-period-ini            AS integer     NO-UNDO.
    DEFINE INPUT PARAMETER i-num-period-fim            AS integer     NO-UNDO.
    DEFINE INPUT PARAMETER dt-dat-ult-gerac-ini        AS DATE        NO-UNDO.
    DEFINE INPUT PARAMETER dt-dat-ult-gerac-fim        AS DATE        NO-UNDO.
    DEFINE INPUT PARAMETER c-hra-ult-gerac-ini         AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER c-hra-ult-gerac-fim         AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER l-log-gerado-com-erro       AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER l-log-enviado               AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER l-log-em-processamento      AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER l-log-autorizado            AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER l-log-rejeitado             AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER l-log-em-exclusao           AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER l-log-excluido              AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER l-log-integr-tss            AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER l-log-gera-even-com-erro    AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER l-log-exporta-xml           AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-dir-export-xml        AS CHARACTER   NO-UNDO.

    FOR FIRST param-gener EXCLUSIVE-LOCK
        WHERE param-gener.cod-chave-1 = "param-monitor-dere" 
          AND param-gener.cod-chave-2 = TRIM(c-cod-usuario):
    END.
    IF  NOT AVAIL param-gener THEN DO:
        CREATE param-gener.
        ASSIGN param-gener.cod-chave-1 = "param-monitor-dere" 
               param-gener.cod-chave-2 = TRIM(c-cod-usuario).
    END.

    /* ParÉmetros do Filtro */
    ASSIGN OVERLAY(param-gener.cod-livre-1,   1,  20) = c-cod-estabel-ini            
           OVERLAY(param-gener.cod-livre-1,  21,  20) = c-cod-estabel-fim            
           OVERLAY(param-gener.cod-livre-1,  41,  10) = c-cod-layout-ini           
           OVERLAY(param-gener.cod-livre-1,  51,  10) = c-cod-layout-fim           
           OVERLAY(param-gener.cod-livre-1,  61,  30) = c-cod-identif-event-ini
           OVERLAY(param-gener.cod-livre-1,  91,  30) = c-cod-identif-event-fim
           param-gener.dat-livre-1                    = dt-dat-ult-gerac-ini       
           param-gener.dat-livre-2                    = dt-dat-ult-gerac-fim       
           OVERLAY(param-gener.cod-livre-1, 121,  10) = c-hra-ult-gerac-ini        
           OVERLAY(param-gener.cod-livre-1, 131,  10) = c-hra-ult-gerac-fim        
           OVERLAY(param-gener.cod-livre-1, 141,   1) = IF l-log-gerado-com-erro  THEN "S":U ELSE "N":U    
           OVERLAY(param-gener.cod-livre-1, 142,   1) = IF l-log-enviado          THEN "S":U ELSE "N":U    
           OVERLAY(param-gener.cod-livre-1, 143,   1) = IF l-log-em-processamento THEN "S":U ELSE "N":U    
           OVERLAY(param-gener.cod-livre-1, 144,   1) = IF l-log-autorizado       THEN "S":U ELSE "N":U    
           OVERLAY(param-gener.cod-livre-1, 145,   1) = IF l-log-rejeitado        THEN "S":U ELSE "N":U    
           OVERLAY(param-gener.cod-livre-1, 146,   1) = IF l-log-em-exclusao      THEN "S":U ELSE "N":U   
           OVERLAY(param-gener.cod-livre-1, 147,   1) = IF l-log-excluido         THEN "S":U ELSE "N":U
           OVERLAY(param-gener.cod-livre-1, 148,   1) = STRING(i-idi-tip-ambiente)
           OVERLAY(param-gener.cod-livre-1, 149,  10) = string(i-num-period-ini)
           OVERLAY(param-gener.cod-livre-1, 159,  10) = string(i-num-period-fim).

    /* ParÉmetros da Regeraá∆o */
    ASSIGN OVERLAY(param-gener.cod-livre-2,   1,   1) = IF l-log-integr-tss         THEN "S":U ELSE "N":U   
           OVERLAY(param-gener.cod-livre-2,   2,   1) = IF l-log-exporta-xml        THEN "S":U ELSE "N":U
           OVERLAY(param-gener.cod-livre-2,   3, 300) = c-cod-dir-export-xml
           OVERLAY(param-gener.cod-livre-2, 303,   1) = IF l-log-gera-even-com-erro THEN "S":U ELSE "N":U.
              
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE limpaTTDereLogEnvioAux DBOProgram 
PROCEDURE limpaTTDereLogEnvioAux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-dere-log-envio-aux     NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE integraEventosDERE DBOProgram 
PROCEDURE integraEventosDeRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: idi-ult-status-gerac: 1 Gerado com Erro     idi-status-envio-xml: 1 Gerado com Erro
                               2 Enviado                                   2 Enviado         
                               3 Em Processamento                          3 Em Processamento
                               4 Autorizado                                4 Autorizado
                               5 Rejeitado                                 5 Rejeitado       
                               6 Em Exclus∆o     
                               7 Exclu°do        
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pTransacao               AS INTEGER   NO-UNDO. /* 1 - Reenvio, 2 - Exclus∆o Evento, 3 - Consulta, 4 - Regeraá∆o Evento */
    DEFINE INPUT PARAMETER p-log-integr-tss         AS LOGICAL   NO-UNDO. /* Integra com TSS */
    DEFINE INPUT PARAMETER p-log-gera-even-com-erro AS LOGICAL   NO-UNDO. /* Gera Log-Envio mesmo com Erro */
    DEFINE INPUT PARAMETER p-log-exporta-xml        AS LOGICAL   NO-UNDO. /* Exporta XML */
    DEFINE INPUT PARAMETER p-cod-dir-export-xml     AS CHARACTER NO-UNDO. /* Dir Exportaá∆o XML */
    DEFINE INPUT PARAMETER TABLE FOR tt-dere-log-envio-aux.
    DEFINE INPUT PARAMETER p-cod-motivo-exclusao     AS CHARACTER NO-UNDO. /* Motivo Exclus∆o Evento */

    DISABLE TRIGGERS FOR LOAD OF dere-log-envio.
    DISABLE TRIGGERS FOR LOAD OF dere-log-envio-xml.
    
    IF  NOT VALID-HANDLE(h-lfapi0601) THEN
        RUN lfp/lfapi0601.p PERSISTENT SET h-lfapi0601.
    
    ASSIGN iTransacao      = pTransacao
           cListaSitLogEnv = "":U.

    EMPTY TEMP-TABLE tt-params-generic.
    EMPTY TEMP-TABLE tt-log-envio-xml.
    EMPTY TEMP-TABLE tt-error.

    CASE iTransacao:
        /* Reenvio */
        WHEN 1 THEN DO: 
        
            ASSIGN cListaSitLogEnv = "5". /* 5-Rejeitado */

            RUN piReenviaEventoTSS.
    
        END.
        /* Exclus∆o */
        WHEN 2 THEN DO: 
        
            ASSIGN cListaSitLogEnv = "4". /* 4-Autorizado */

            FOR EACH tt-dere-log-envio-aux NO-LOCK
               WHERE ((LOOKUP(STRING(tt-dere-log-envio-aux.idi-ult-status-gerac), cListaSitLogEnv, ",") > 0)
                      OR tt-dere-log-envio-aux.cod-identif-event = "RemoverContribuinte"):
    
                RUN piExcluiEventoTSS(input p-cod-motivo-exclusao).
    
            END.

        END.
        /* Consulta */
        WHEN 3 THEN DO: 
        
            ASSIGN cListaSitLogEnv = "2,3,6". /* 2-Enviado, 3-Em Processamento, 6-Em Exclus∆o */

            RUN piConsultaEventoTSS.

        END.
        /* Regeraá∆o */
        WHEN 4 THEN DO: 

            ASSIGN cListaSitLogEnv = "1,4,5". /* 1-Gerado com Erro, 4-Autorizado, 5-Rejeitado */

            FOR EACH tt-dere-log-envio-aux NO-LOCK
               WHERE LOOKUP(STRING(tt-dere-log-envio-aux.idi-ult-status-gerac), cListaSitLogEnv, ",") > 0:
    
               if tt-dere-log-envio-aux.cod-layout = "D-1199" then
                  next.

               RUN piRegeraEventoTSS (input p-log-integr-tss,
                                      input p-log-gera-even-com-erro,
                                      input p-log-exporta-xml,
                                      input p-cod-dir-export-xml).

            END.

        END.

        OTHERWISE RETURN "OK":U.

    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piReenviaEventoTSS DBOProgram 
PROCEDURE piReenviaEventoTSS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt-dere-log-envio-aux NO-LOCK
        WHERE LOOKUP(STRING(tt-dere-log-envio-aux.idi-ult-status-gerac), cListaSitLogEnv, ",") > 0,

         each bf-dere-log-envio-xml NO-LOCK
        WHERE bf-dere-log-envio-xml.idi-tip-ambiente      = tt-dere-log-envio-aux.idi-tip-ambiente
          AND bf-dere-log-envio-xml.ep-codigo             = tt-dere-log-envio-aux.ep-codigo
          AND bf-dere-log-envio-xml.cod-estabel           = tt-dere-log-envio-aux.cod-estabel
          AND bf-dere-log-envio-xml.cod-layout            = tt-dere-log-envio-aux.cod-layout
          AND bf-dere-log-envio-xml.cod-identif-event     = tt-dere-log-envio-aux.cod-identif-event
          AND bf-dere-log-envio-xml.num-period            = tt-dere-log-envio-aux.num-period
           BY bf-dere-log-envio-xml.dat-envio-xml desc
           BY bf-dere-log-envio-xml.hra-envio-xml desc:

        CREATE tt-log-envio-xml.
        ASSIGN tt-log-envio-xml.idi-tip-ambiente  = bf-dere-log-envio-xml.idi-tip-ambiente
               tt-log-envio-xml.ep-codigo         = bf-dere-log-envio-xml.ep-codigo
               tt-log-envio-xml.cod-estab-param   = if tt-dere-log-envio-aux.cod-livre-1 <> "" then tt-dere-log-envio-aux.cod-livre-1 else bf-dere-log-envio-xml.cod-estabel
               tt-log-envio-xml.cod-layout        = bf-dere-log-envio-xml.cod-layout
               tt-log-envio-xml.cod-estabel       = bf-dere-log-envio-xml.cod-estabel
               tt-log-envio-xml.cod-identif-event = bf-dere-log-envio-xml.cod-identif-event
               tt-log-envio-xml.num-periodo       = bf-dere-log-envio-xml.num-period
               tt-log-envio-xml.cod-id-evento     = bf-dere-log-envio-xml.cod-id-evento.

        COPY-LOB FROM bf-dere-log-envio-xml.blb-arq-xml TO lch-arq-xml.
        COPY-LOB FROM lch-arq-xml                        TO tt-log-envio-xml.arq-xml.

        IF  VALID-HANDLE(h-acomp) THEN 
			RUN pi-acompanhar IN h-acomp (INPUT "Envio Eventos: " + bf-dere-log-envio-xml.cod-estabel + " / " + bf-dere-log-envio-xml.cod-layout + " / " + bf-dere-log-envio-xml.cod-id-evento).

        leave.
                                          
    END.

    IF  NOT CAN-FIND (FIRST tt-log-envio-xml) THEN
        RETURN "OK":U.

    RUN pi-executa-reeenvio IN h-lfapi0601 (INPUT-OUTPUT TABLE tt-log-envio-xml, /* Informacoes do Evento + XML */
                                            OUTPUT       TABLE tt-error).        /* Erros retornados */
    
    FOR EACH tt-error NO-LOCK:

        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="'Erro ao Reenviar o Evento !' + '~~~~' + 
                                                      'Origem: ' + tt-error.orig-error   + 
                                                      '. Detalhes do Erro: ' + tt-error.desc-error"}

    END.
    
    FOR EACH tt-log-envio-xml NO-LOCK:

        /* Envio NOK/OK */
        IF  tt-log-envio-xml.log-tss-ok = no THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=" 'Erro ao Reenviar o Evento !' + '~~~~' + 
                                                           'Evento: ' + tt-log-envio-xml.cod-id-evento + '. ' + 
                                                           '. Detalhes do Erro: ' + tt-log-envio-xml.des-vld-tss "}
        END.
        ELSE DO:
        
            {method/svc/errors/inserr.i &ErrorNumber="15825"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Information"
                                        &ErrorParameters=" 'Reenvio do Evento realizado com Sucesso !' + '~~~~' + 
                                                           'Evento: ' + tt-log-envio-xml.cod-id-evento + '. ' "}
        END.
        
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piReenviaEventoTSS DBOProgram 
PROCEDURE piRegeraEventoTSS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param p-log-integr-tss         as log  no-undo. /* Integra com TSS */
   def input param p-log-gera-even-com-erro as log  no-undo. /* Gera Log-Envio mesmo com Erro */
   def input param p-log-exporta-xml        as log  no-undo. /* Exporta XML */
   def input param p-cod-dir-export-xml     as char no-undo. /* Dir Exportaá∆o XML */

   def var c-estab-param  as char no-undo.
   def var c-estab-ini    as char no-undo.
   def var c-estab-fim    as char no-undo.
   def var c-estabel    as char no-undo.
   def var c-cod-identif-event as char no-undo.
   def var c-num-period   as char no-undo.
   def var dt-nao-period  as date no-undo.

   if valid-handle(h-acomp) then
      run pi-acompanhar in h-acomp (input "Regeraá∆o do Evento: " + tt-dere-log-envio-aux.cod-estabel + " / " + tt-dere-log-envio-aux.cod-layout).

   empty temp-table tt-params-generic.
   empty temp-table tt-log-envio-xml.
   empty temp-table tt-error.

   /* Alimenta os ParÉmetros conforme as Regras dos Layouts */
   assign c-estab-param = if tt-dere-log-envio-aux.cod-livre-1 <> "" then tt-dere-log-envio-aux.cod-livre-1 else tt-dere-log-envio-aux.cod-estabel.

   if c-estab-param = tt-dere-log-envio-aux.cod-estabel then 
      assign c-estab-ini = tt-dere-log-envio-aux.cod-estabel
             c-estab-fim = tt-dere-log-envio-aux.cod-estabel
             c-estabel = "".
   else /* Eh uma CNO */
      assign c-estab-ini = ""
             c-estab-fim = "ZZZZZ"
             c-estabel = tt-dere-log-envio-aux.cod-estabel.

   assign c-cod-identif-event = tt-dere-log-envio-aux.cod-identif-event
          c-num-period        = string(tt-dere-log-envio-aux.num-period).

   if length(c-num-period) >= 8 then
      assign dt-nao-period = date(int(substring(c-num-period, 5, 2)), int(substring(c-num-period, 7, 2)), int(substring(c-num-period, 1, 4))).
   else
      assign dt-nao-period = date(int(substring(c-num-period, 5, 2)), 1, int(substring(c-num-period, 1, 4))).

   /* Cria tabela genÇrica para regeraá∆o */
   initParamsGeneric("tt-param-tela"). /* Limpa a tt-generic-param */
      
   setParamsGeneric("tt-param-tela", "regeracao",           "yes").
   setParamsGeneric("tt-param-tela", "estab-ini",           c-estab-ini).
   setParamsGeneric("tt-param-tela", "estab-fim",           c-estab-fim).
   setParamsGeneric("tt-param-tela", "num-periodo",         c-num-period).
   setParamsGeneric("tt-param-tela", "data-ini-nao-period", string(dt-nao-period)).
   setParamsGeneric("tt-param-tela", "data-fim-nao-period", string(dt-nao-period)).
   setParamsGeneric("tt-param-tela", "estabel",             c-estabel).
   setParamsGeneric("tt-param-tela", "cod-identif-event",   c-cod-identif-event).

   run pi-executa-geracao-envio in h-lfapi0601 (input  tt-dere-log-envio-aux.cod-layout,
                                                input  p-log-integr-tss,         /* Integra com o TSS ? */
                                                input  p-log-integr-tss,         /* Valida Schema ? */
                                                input  p-log-integr-tss,         /* Gera Log-Envio mesmo com Erro ? */  
                                                input  p-log-exporta-xml,        /* Exporta XML para aquivo ? */
                                                input  p-cod-dir-export-xml,     /* Diret¢rio de Exportaá∆o do XML */
                                                input  table tt-params-generic,  /* Informaá‰es de ParÉmetros */
                                                output table tt-log-envio-xml,   /* Informaá‰es do Evento Gerado + XML */
                                                output table tt-error).          /* Erros retornados */

   for each tt-error no-lock:
      {method/svc/errors/inserr.i &ErrorNumber="17006"
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR"
                                  &ErrorParameters="'Erro na Regeracao do Evento !'  + '~~~~' + 
                                                    'Origem: ' + tt-error.orig-error + '. '   +
                                                    'Detalhes do Erro: ' + tt-error.desc-error"}
   end.

   if not can-find(first tt-log-envio-xml) then do:

      if tt-dere-log-envio-aux.idi-ult-status-gerac = 4 /* Autorizado */ then do:
         {method/svc/errors/inserr.i &ErrorNumber="15825"
                                     &ErrorType="EMS"
                                     &ErrorSubType="Information"
                                     &ErrorParameters="'Nao foram encontrados Dados para Regeracao do Evento !'   + '~~~~' + 
                                                       'Evento: ' + tt-dere-log-envio-aux.cod-estabel           + ' / '  + 
                                                                    tt-dere-log-envio-aux.cod-layout            + ' / '  +
                                                                    tt-dere-log-envio-aux.cod-identif-event + '. '   +
                                                       'IMPORTANTE: O Evento encontra-se Autorizado sob recibo ' + tt-dere-log-envio-aux.cod-ult-recibo + '. ' +
                                                       'Certifique-se de que realmente n∆o h† informaá‰es a apresentar e solicite a Exclus∆o do Evento !'"}
      end.
      else do:
         {method/svc/errors/inserr.i &ErrorNumber="15825"
                                     &ErrorType="EMS"
                                     &ErrorSubType="Information"
                                     &ErrorParameters="'Nao foram encontrados Dados para Regeracao do Evento !'   + '~~~~' + 
                                                       'Evento: ' + tt-dere-log-envio-aux.cod-estabel           + ' / '  + 
                                                                    tt-dere-log-envio-aux.cod-layout            + ' / '  +
                                                                    tt-dere-log-envio-aux.cod-identif-event + '. '"}
      end.
   end.
   else do:
      if p-log-integr-tss = yes then do:
   
         for each tt-log-envio-xml no-lock:
            /* Schema NOK */
            if tt-log-envio-xml.log-schema-ok = no then do:
               {method/svc/errors/inserr.i &ErrorNumber="17006"
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR"
                                           &ErrorParameters="'Erro na Regeracao do Evento !'             + '~~~~' +
                                                             'Evento: ' + tt-log-envio-xml.cod-id-evento + '. '   +
                                                             'Detalhes do Erro (Schema): ' + tt-log-envio-xml.des-vld-schema"}
            end.
            else do:
               /* Envio NOK/OK */
               if tt-log-envio-xml.log-tss-ok = no THEN DO:
                  {method/svc/errors/inserr.i &ErrorNumber="17006"
                                              &ErrorType="EMS"
                                              &ErrorSubType="ERROR"
                                              &ErrorParameters="'Erro na Regeracao do Evento !'             + '~~~~' + 
                                                                'Evento: ' + tt-log-envio-xml.cod-id-evento + '. '   +
                                                                'Detalhes do Erro: ' + tt-log-envio-xml.des-vld-tss"}
               end.
               else do:
                  {method/svc/errors/inserr.i &ErrorNumber="15825"
                                              &ErrorType="EMS"
                                              &ErrorSubType="Information"
                                              &ErrorParameters="'Regeraá∆o do Evento realizada com Sucesso !' + '~~~~' + 
                                                                'Evento: ' + tt-log-envio-xml.cod-id-evento   + '. '"}
               end.
            end.
         end.
      end.
      else do:
         {method/svc/errors/inserr.i &ErrorNumber="15825"
                                     &ErrorType="EMS"
                                     &ErrorSubType="Information"
                                     &ErrorParameters="'Regeraá∆o do XML do Evento realizada com Sucesso !'      + '~~~~' + 
                                                       'Evento: ' + tt-dere-log-envio-aux.cod-estabel           + ' / '  + 
                                                                    tt-dere-log-envio-aux.cod-layout            + ' / '  +
                                                                    tt-dere-log-envio-aux.cod-identif-event + '. '   +
                                                       'IMPORTANTE: A regraá∆o foi realizada apenas para conferància, '   +
                                                       'Para Integraá∆o com o TSS, o evento ter† que ser regerado !'"}
      end.
   end.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExcluiEventoTSS DBOProgram 
PROCEDURE piExcluiEventoTSS :
    DEFINE INPUT PARAMETER p-cod-motivo-exclusao     AS CHARACTER NO-UNDO. /* Motivo Exclus∆o Evento */
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var c-cod-layout-geracao as char no-undo.
    def var c-liter              as char no-undo.

    assign c-cod-layout-geracao = tt-dere-log-envio-aux.cod-layout.

    assign c-liter = "Evento".
    IF  tt-dere-log-envio-aux.cod-identif-event = "RemoverContribuinte" THEN
        ASSIGN c-liter = "Contribuinte".

    IF  VALID-HANDLE(h-acomp) THEN 
        RUN pi-acompanhar IN h-acomp (INPUT "Exclus∆o " + c-liter + " (" + c-cod-layout-geracao + "): " + tt-dere-log-envio-aux.cod-estabel + " / " + tt-dere-log-envio-aux.cod-layout).

    EMPTY TEMP-TABLE tt-params-generic.
    EMPTY TEMP-TABLE tt-log-envio-xml.
    EMPTY TEMP-TABLE tt-error.

    /*Cria tabela generica conforme os campos da tt-dere-log-envio-aux*/
    initParamsGeneric("tt-param-exclusao"). /* Limpa a tt-generic-param */

    setParamsGeneric("tt-param-exclusao", "log-exclusao"         , "yes"                                       ). /* Indicaá∆o de Exclus∆o para utilizar nos Layouts de Cadastro                  */
    setParamsGeneric("tt-param-exclusao", "cod-estabel"          , tt-dere-log-envio-aux.cod-estabel            ). /* c¢digo do estabelecimento                                                    */
    setParamsGeneric("tt-param-exclusao", "cod-estab-param"      , (IF tt-dere-log-envio-aux.cod-livre-1 <> "":U 
                                                                    THEN tt-dere-log-envio-aux.cod-livre-1 
                                                                    ELSE tt-dere-log-envio-aux.cod-estabel)   ). /* c¢digo do estabelecimento                                                    */
    setParamsGeneric("tt-param-exclusao", "cod-layout-exclusao"  , tt-dere-log-envio-aux.cod-layout           ). /* c¢digo do evento que vai ser exclu°do. Ex: R-2010                            */
    setParamsGeneric("tt-param-exclusao", "cod-identif-event", tt-dere-log-envio-aux.cod-identif-event). /* c¢digo do CNPJ do cliente ou fornecedor (CNPJ 2 do evento que ser† exclu°do  */
    setParamsGeneric("tt-param-exclusao", "cod-recibo-exclusao"  , tt-dere-log-envio-aux.cod-ult-recibo       ). /* n£mero do recibo do evento que vai ser exclu°do                              */
    setParamsGeneric("tt-param-exclusao", "cod-periodo-apur"     , STRING(tt-dere-log-envio-aux.num-period)   ). /* per°odo de apuraá∆o do evento que vai ser exclu°do */
    setParamsGeneric("tt-param-exclusao", "cod-motivo-exclusao"     , p-cod-motivo-exclusao   ). /* Motivo Exclus∆o do Evento */

    RUN pi-executa-geracao-envio IN h-lfapi0601 (INPUT  c-cod-layout-geracao,
                                                 INPUT  YES,                     /* Integra com o TSS ? */
                                                 INPUT  YES,                     /* Valida Schema ? */
                                                 INPUT  YES,                     /* Gera Log-Envio mesmo com Erro ? */
                                                 INPUT  NO,                      /* Exporta XML para aquivo ? */
                                                 INPUT  "",                      /* Diret¢rio de Exportaá∆o do XML */
                                                 INPUT  TABLE tt-params-generic, /* Informaá‰es de ParÉmetros */
                                                 OUTPUT TABLE tt-log-envio-xml,  /* Informaá‰es do Evento Gerado + XML */
                                                 OUTPUT TABLE tt-error).         /* Erros retornados */

    FOR EACH tt-error NO-LOCK:

        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="'Erro na Exclus∆o do ' + c-liter + ' !' + '~~~~' + 
                                                      'Origem: ' + tt-error.orig-error   + 
                                                      '. Detalhes do Erro: ' + tt-error.desc-error"}

    END.
    
    FOR EACH tt-log-envio-xml NO-LOCK:

        /* Schema NOK */
        IF  tt-log-envio-xml.log-schema-ok = no THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=" 'Erro na Exclus∆o do ' + c-liter + ' !' + '~~~~' + 
                                                           'Evento: ' + tt-log-envio-xml.cod-id-evento + '. ' + 
                                                           '. Detalhes do Erro (Schema): ' + tt-log-envio-xml.des-vld-schema "}
        END.
        ELSE DO:
        
            /* Envio NOK/OK */
            IF  tt-log-envio-xml.log-tss-ok = no THEN DO:
    
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters=" 'Erro na Exclus∆o do ' + c-liter + ' !' + '~~~~' + 
                                                               'Evento: ' + tt-log-envio-xml.cod-id-evento + '. ' + 
                                                               '. Detalhes do Erro: ' + tt-log-envio-xml.des-vld-tss "}
            END.
            ELSE DO:
    
                IF  tt-dere-log-envio-aux.cod-identif-event <> "RemoverContribuinte" THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="15825"
                                                &ErrorType="EMS"
                                                &ErrorSubType="Information"
                                                &ErrorParameters=" 'Solicitaá∆o de Exclus∆o do Evento enviado com Sucesso !' + '~~~~' + 
                                                                   'Evento: ' + tt-log-envio-xml.cod-id-evento + '. ' "}
                END.
                ELSE DO:
                    {method/svc/errors/inserr.i &ErrorNumber="56000"
                                                &ErrorType="EMS"
                                                &ErrorSubType="Information"}
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piConsultaEventoTSS DBOProgram 
PROCEDURE piConsultaEventoTSS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lcEventoXML    AS LONGCHAR   NO-UNDO.
    DEFINE VARIABLE lcEventoXMLRet AS LONGCHAR   NO-UNDO.

    FOR EACH tt-dere-log-envio-aux NO-LOCK
       WHERE LOOKUP(STRING(tt-dere-log-envio-aux.idi-ult-status-gerac), cListaSitLogEnv, ",") > 0:

        FOR each bf-dere-log-envio-xml NO-LOCK
           WHERE bf-dere-log-envio-xml.idi-tip-ambiente      = tt-dere-log-envio-aux.idi-tip-ambiente
             AND bf-dere-log-envio-xml.ep-codigo             = tt-dere-log-envio-aux.ep-codigo
             AND bf-dere-log-envio-xml.cod-estabel           = tt-dere-log-envio-aux.cod-estabel
             AND bf-dere-log-envio-xml.cod-layout            = tt-dere-log-envio-aux.cod-layout
             AND bf-dere-log-envio-xml.cod-identif-event     = tt-dere-log-envio-aux.cod-identif-event
             AND bf-dere-log-envio-xml.num-period            = tt-dere-log-envio-aux.num-period
              BY bf-dere-log-envio-xml.dat-envio-xml desc
              BY bf-dere-log-envio-xml.hra-envio-xml desc:

            CREATE tt-log-envio-xml.
            ASSIGN tt-log-envio-xml.idi-tip-ambiente = bf-dere-log-envio-xml.idi-tip-ambiente
                   tt-log-envio-xml.ep-codigo        = bf-dere-log-envio-xml.ep-codigo
                   tt-log-envio-xml.cod-estab-param  = (IF tt-dere-log-envio-aux.cod-livre-1 <> "":U 
                                                        THEN tt-dere-log-envio-aux.cod-livre-1 
                                                        ELSE bf-dere-log-envio-xml.cod-estabel)
                   tt-log-envio-xml.cod-layout        = bf-dere-log-envio-xml.cod-layout
                   tt-log-envio-xml.cod-estabel       = bf-dere-log-envio-xml.cod-estabel
                   tt-log-envio-xml.cod-identif-event = bf-dere-log-envio-xml.cod-identif-event
                   tt-log-envio-xml.num-periodo       = bf-dere-log-envio-xml.num-period
                   tt-log-envio-xml.cod-id-evento     = bf-dere-log-envio-xml.cod-id-evento.
    
            IF  VALID-HANDLE(h-acomp) THEN 
    			RUN pi-acompanhar IN h-acomp (INPUT "Consulta Eventos: " + bf-dere-log-envio-xml.cod-estabel + " / " + bf-dere-log-envio-xml.cod-layout + " / " + bf-dere-log-envio-xml.cod-id-evento).
    
            leave.
        END.
       
    END.

    IF  NOT CAN-FIND (FIRST tt-log-envio-xml) THEN
        RETURN "OK":U.

    IF  NOT VALID-HANDLE(h-lfapi0600) THEN
        RUN lfp/lfapi0600.p PERSISTENT SET h-lfapi0600.

    IF  VALID-HANDLE(h-acomp) THEN 
		RUN pi-acompanhar IN h-acomp (INPUT "Integraá∆o com TSS - DeRE...").

    RUN TSSWSDERE_CONSULTAREVENTOSDERE IN h-lfapi0600 (INPUT-OUTPUT TABLE tt-log-envio-xml). /* Informacoes do Evento */

    IF  RETURN-VALUE <> "OK":U THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters=" 'Erro na Consulta do Evento !' + '~~~~' + 
                                                       '. Detalhes do Erro [TSS]: ' + return-value "}
        RETURN "NOK":U.
    END.

    /* Atualiza tabelas de log conforme retorno do TSS */
    
    FOR EACH tt-log-envio-xml
       WHERE tt-log-envio-xml.log-tss-ok NO-LOCK:

        /* Atualiza dere-log-envio */
        FOR FIRST bf-dere-log-envio EXCLUSIVE-LOCK
            WHERE bf-dere-log-envio.idi-tip-ambiente      = tt-log-envio-xml.idi-tip-ambiente
              AND bf-dere-log-envio.ep-codigo             = tt-log-envio-xml.ep-codigo
              AND bf-dere-log-envio.cod-estabel           = tt-log-envio-xml.cod-estabel
              AND bf-dere-log-envio.cod-layout            = tt-log-envio-xml.cod-layout
              AND bf-dere-log-envio.cod-identif-event     = tt-log-envio-xml.cod-identif-event
              AND bf-dere-log-envio.num-period            = tt-log-envio-xml.num-periodo:

            /* Status atual: Em Exclus∆o */
            IF  bf-dere-log-envio.idi-ult-status-gerac = 6 /*Em Exclus∆o*/ THEN
                ASSIGN bf-dere-log-envio.idi-ult-status-gerac = (IF   tt-log-envio-xml.num-status-tss = 6 /*6 - Evento Autorizado*/
                                                                  THEN 7 /*Exclu°do*/
                                                                  ELSE IF   tt-log-envio-xml.num-status-tss = 5 /*5 - Evento Rejeitado*/
                                                                       AND  bf-dere-log-envio.cod-identif-event = "RemoverContribuinte"
                                                                       THEN 5 /*Rejeitado*/
                                                                       ELSE IF (tt-log-envio-xml.num-status-tss = 5  /*5 - Evento Rejeitado*/
                                                                            OR  tt-log-envio-xml.num-status-tss = 3) /*3 - XML Inv†lido (Parser/Schema/Vlds)*/
                                                                            THEN 4 /*Autorizado*/  /* Exclus∆o n∆o foi autorizada, volta para status anterior "Autorizado" */
                                                                            ELSE bf-dere-log-envio.idi-ult-status-gerac).
            /* Demais Status */
            ELSE
                ASSIGN bf-dere-log-envio.idi-ult-status-gerac = (IF   tt-log-envio-xml.num-status-tss = 6 /*6 - Evento Autorizado*/
                                                                  THEN 4 /*Autorizado*/
                                                                  ELSE IF (tt-log-envio-xml.num-status-tss = 5  /*5 - Evento Rejeitado*/
                                                                       OR  tt-log-envio-xml.num-status-tss = 3) /*3 - XML Inv†lido (Parser/Schema/Vlds)*/
                                                                       THEN 5   /*Rejeitado*/
                                                                       ELSE 3). /*Em Processamento*/

            ASSIGN bf-dere-log-envio.cod-ult-recibo       = (IF   tt-log-envio-xml.cod-recibo <> "":U
                                                              THEN tt-log-envio-xml.cod-recibo
                                                              ELSE bf-dere-log-envio.cod-ult-recibo).
        END.

        /* Atualiza dere-log-envio-xml */
        FOR FIRST bf-dere-log-envio-xml EXCLUSIVE-LOCK
            WHERE bf-dere-log-envio-xml.idi-tip-ambiente      = tt-log-envio-xml.idi-tip-ambiente
              AND bf-dere-log-envio-xml.ep-codigo             = tt-log-envio-xml.ep-codigo
              AND bf-dere-log-envio-xml.cod-estabel           = tt-log-envio-xml.cod-estabel
              AND bf-dere-log-envio-xml.cod-layout            = tt-log-envio-xml.cod-layout
              AND bf-dere-log-envio-xml.cod-identif-event     = tt-log-envio-xml.cod-identif-event
              AND bf-dere-log-envio-xml.num-period            = tt-log-envio-xml.num-periodo
              AND bf-dere-log-envio-xml.cod-id-evento         = tt-log-envio-xml.cod-id-evento:

            ASSIGN bf-dere-log-envio-xml.idi-status-envio-xml = (IF   tt-log-envio-xml.num-status-tss = 6 /*6 - Evento Autorizado*/
                                                                  THEN 4 /*Autorizado*/
                                                                  ELSE IF (tt-log-envio-xml.num-status-tss = 5  /*5 - Evento Rejeitado*/
                                                                       OR  tt-log-envio-xml.num-status-tss = 3) /*3 - XML Inv†lido (Parser/Schema/Vlds)*/
                                                                       THEN 5  /*Rejeitado*/
                                                                       ELSE 3) /*Em Processamento*/
                   bf-dere-log-envio-xml.cod-recibo           = tt-log-envio-xml.cod-recibo
                   bf-dere-log-envio-xml.cod-protocolo        = tt-log-envio-xml.cod-protoc
                   bf-dere-log-envio-xml.cod-mensagem         = tt-log-envio-xml.des-vld-tss.

            /* ++++++++++++ N«O ATUALIZAR PARA N«O SOBREPOR AO GERADO NO ENVIO ++++++++++++ */
            /* XML Envio */
            /* COPY-LOB FROM tt-log-envio-xml.arq-xml     TO lcEventoXML.                        */ 
            /* COPY-LOB FROM lcEventoXML                  TO bf-dere-log-envio-xml.blb-arq-xml. */

            /* XML Retorno */
            COPY-LOB FROM tt-log-envio-xml.arq-xml-ret TO lcEventoXMLRet.
            if trim(lcEventoXMLRet) = "" then
               assign lcEventoXMLRet = trim(trim(tt-log-envio-xml.des-vld-schema) + " " + trim(tt-log-envio-xml.des-vld-tss)).
            COPY-LOB FROM lcEventoXMLRet               TO bf-dere-log-envio-xml.blb-arq-xml-ret.

        END.
    END.

    RELEASE dere-log-envio.
    RELEASE dere-log-envio-xml.
    RELEASE bf-dere-log-envio.
    RELEASE bf-dere-log-envio-xml.

    RETURN "OK":U.
END PROCEDURE.    

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRecebeHandleUtAcomp DBOProgram 
PROCEDURE piRecebeHandleUtAcomp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-h-acomp AS HANDLE NO-UNDO.
	
	ASSIGN h-acomp = p-h-acomp.

    RETURN "OK":U.
END PROCEDURE.    

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
