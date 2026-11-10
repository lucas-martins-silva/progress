/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD00548 2.00.00.025} /*** "010025" 05/02/2025 11:02:10 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BOAD00548 MUT}
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
&GLOBAL-DEFINE DBOName BOAD00548
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName reinf-log-envio
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
{adbo/boad00548.i RowObject}
{adbo/boad00548.i tt-reinf-log-envio-aux}
{adbo/boad00549.i tt-reinf-log-envio-xml-aux}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf-reinf-log-envio     FOR reinf-log-envio.
DEFINE BUFFER bf-reinf-log-envio-xml FOR reinf-log-envio-xml.

DEFINE VARIABLE i-idi-tip-ambiente          AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-cod-empresa               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estab-ini             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estab-fim             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-layout-ini            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-layout-fim            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-cnpj-clien-fornec-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-cnpj-clien-fornec-fim AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-num-period-ini            AS integer     NO-UNDO.
DEFINE VARIABLE i-num-period-fim            AS integer     NO-UNDO.
DEFINE VARIABLE dt-n-period-ini             AS date        NO-UNDO.
DEFINE VARIABLE dt-n-period-fim             AS date        NO-UNDO.
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
DEFINE VARIABLE h-lfapi0400 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-lfapi0401 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-acomp     AS HANDLE NO-UNDO.

RUN piInicializaHandles.
/* FIM - Inicializaá∆o dos HANDLES utilizados pela BO */


{lfp/lf0400.i1} /* Definicao tt-params-generic / tt-error */
{lfp/lfapi0401.i} /* Definiá∆o tt-log-envio-xml */


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
        WHEN "cod-cnpj-clien-fornec":U THEN ASSIGN pFieldValue = RowObject.cod-cnpj-clien-fornec.
        WHEN "cod-empresa":U THEN ASSIGN pFieldValue = RowObject.cod-empresa.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-layout":U THEN ASSIGN pFieldValue = RowObject.cod-layout.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
        WHEN "cod-livre-5":U THEN ASSIGN pFieldValue = RowObject.cod-livre-5.
        WHEN "cod-livre-6":U THEN ASSIGN pFieldValue = RowObject.cod-livre-6.
        WHEN "cod-ult-recibo":U THEN ASSIGN pFieldValue = RowObject.cod-ult-recibo.
        WHEN "hra-ult-gerac":U THEN ASSIGN pFieldValue = RowObject.hra-ult-gerac.
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
        WHEN "dat-livre-3":U THEN ASSIGN pFieldValue = RowObject.dat-livre-3.
        WHEN "dat-livre-4":U THEN ASSIGN pFieldValue = RowObject.dat-livre-4.
        WHEN "dat-livre-5":U THEN ASSIGN pFieldValue = RowObject.dat-livre-5.
        WHEN "dat-livre-6":U THEN ASSIGN pFieldValue = RowObject.dat-livre-6.
        WHEN "dat-ult-gerac":U THEN ASSIGN pFieldValue = RowObject.dat-ult-gerac.
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
        WHEN "val-livre-5":U THEN ASSIGN pFieldValue = RowObject.val-livre-5.
        WHEN "val-livre-6":U THEN ASSIGN pFieldValue = RowObject.val-livre-6.
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
        WHEN "idi-ult-status-gerac":U THEN ASSIGN pFieldValue = RowObject.idi-ult-status-gerac.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-livre-3":U THEN ASSIGN pFieldValue = RowObject.num-livre-3.
        WHEN "num-livre-4":U THEN ASSIGN pFieldValue = RowObject.num-livre-4.
        WHEN "num-livre-5":U THEN ASSIGN pFieldValue = RowObject.num-livre-5.
        WHEN "num-livre-6":U THEN ASSIGN pFieldValue = RowObject.num-livre-6.
        WHEN "num-period":U THEN ASSIGN pFieldValue = RowObject.num-period.
        WHEN "idi-tip-ambiente":U THEN ASSIGN pFieldValue = RowObject.idi-tip-ambiente.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice rnflgnv_id2
  Parameters:  
               retorna valor do campo cod-empresa
               retorna valor do campo cod-estab
               retorna valor do campo cod-layout
               retorna valor do campo cod-cnpj-clien-fornec
               retorna valor do campo num-period
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pidi-tip-ambiente      LIKE reinf-log-envio.idi-tip-ambiente      NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-empresa           LIKE reinf-log-envio.cod-empresa           NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estab             LIKE reinf-log-envio.cod-estab             NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-layout            LIKE reinf-log-envio.cod-layout            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-cnpj-clien-fornec LIKE reinf-log-envio.cod-cnpj-clien-fornec NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-period            LIKE reinf-log-envio.num-period            NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pidi-tip-ambiente      = RowObject.idi-tip-ambiente
           pcod-empresa           = RowObject.cod-empresa
           pcod-estab             = RowObject.cod-estab
           pcod-layout            = RowObject.cod-layout
           pcod-cnpj-clien-fornec = RowObject.cod-cnpj-clien-fornec
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
        WHEN "log-livre-3":U THEN ASSIGN pFieldValue = RowObject.log-livre-3.
        WHEN "log-livre-4":U THEN ASSIGN pFieldValue = RowObject.log-livre-4.
        WHEN "log-livre-5":U THEN ASSIGN pFieldValue = RowObject.log-livre-5.
        WHEN "log-livre-6":U THEN ASSIGN pFieldValue = RowObject.log-livre-6.
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
  Purpose:     Reposiciona registro com base no °ndice rnflgnv_id2
  Parameters:  
               recebe valor do campo cod-empresa
               recebe valor do campo cod-estab
               recebe valor do campo cod-layout
               recebe valor do campo cod-cnpj-clien-fornec
               recebe valor do campo num-period
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pidi-tip-ambiente      LIKE reinf-log-envio.idi-tip-ambiente      NO-UNDO.
    DEFINE INPUT PARAMETER pcod-empresa           LIKE reinf-log-envio.cod-empresa           NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estab             LIKE reinf-log-envio.cod-estab             NO-UNDO.
    DEFINE INPUT PARAMETER pcod-layout            LIKE reinf-log-envio.cod-layout            NO-UNDO.
    DEFINE INPUT PARAMETER pcod-cnpj-clien-fornec LIKE reinf-log-envio.cod-cnpj-clien-fornec NO-UNDO.
    DEFINE INPUT PARAMETER pnum-period            LIKE reinf-log-envio.num-period            NO-UNDO.

    FIND FIRST bf-reinf-log-envio WHERE 
               bf-reinf-log-envio.idi-tip-ambiente      = pidi-tip-ambiente      AND
               bf-reinf-log-envio.cod-empresa           = pcod-empresa           AND
               bf-reinf-log-envio.cod-estab             = pcod-estab             AND 
               bf-reinf-log-envio.cod-layout            = pcod-layout            AND
               bf-reinf-log-envio.cod-cnpj-clien-fornec = pcod-cnpj-clien-fornec AND 
               bf-reinf-log-envio.num-period            = pnum-period            NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bf-reinf-log-envio THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf-reinf-log-envio)).
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

    IF  NOT VALID-HANDLE(h-lfapi0400) THEN
        RUN lfp/lfapi0400.p PERSISTENT SET h-lfapi0400.

    IF  NOT VALID-HANDLE(h-lfapi0401) THEN
        RUN lfp/lfapi0401.p PERSISTENT SET h-lfapi0401.

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

    IF  VALID-HANDLE(h-lfapi0400) THEN DO:
        DELETE PROCEDURE h-lfapi0400.
        ASSIGN h-lfapi0400 = ?.
    END.
    IF  VALID-HANDLE(h-lfapi0401) THEN DO:
        DELETE PROCEDURE h-lfapi0401.
        ASSIGN h-lfapi0401 = ?.
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
    DEFINE INPUT PARAMETER p-c-cod-empresa               AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER p-c-cod-estab-ini             AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER p-c-cod-estab-fim             AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER p-c-cod-layout-ini            AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER p-c-cod-layout-fim            AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER p-c-cod-cnpj-clien-fornec-ini AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER p-c-cod-cnpj-clien-fornec-fim AS CHARACTER   NO-UNDO.
    define input parameter p-i-num-period-ini            AS integer     NO-UNDO.
    define input parameter p-i-num-period-fim            AS integer     NO-UNDO.
    define input parameter p-dt-n-period-ini             AS date        NO-UNDO.
    define input parameter p-dt-n-period-fim             AS date        NO-UNDO.
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
           c-cod-empresa               = p-c-cod-empresa
           c-cod-estab-ini             = p-c-cod-estab-ini            
           c-cod-estab-fim             = p-c-cod-estab-fim            
           c-cod-layout-ini            = p-c-cod-layout-ini           
           c-cod-layout-fim            = p-c-cod-layout-fim           
           c-cod-cnpj-clien-fornec-ini = p-c-cod-cnpj-clien-fornec-ini
           c-cod-cnpj-clien-fornec-fim = p-c-cod-cnpj-clien-fornec-fim
           i-num-period-ini            = p-i-num-period-ini
           i-num-period-fim            = p-i-num-period-fim
           dt-n-period-ini             = p-dt-n-period-ini
           dt-n-period-fim             = p-dt-n-period-fim
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
                                 AND  {&TableName}.cod-empresa              = c-cod-empresa
                                 AND  {&TableName}.cod-estab               >= c-cod-estab-ini            
                                 AND  {&TableName}.cod-estab               <= c-cod-estab-fim            
                                 AND  {&TableName}.cod-layout              >= c-cod-layout-ini           
                                 AND  {&TableName}.cod-layout              <= c-cod-layout-fim           
                                 AND (({&TableName}.cod-cnpj-clien-fornec  >= c-cod-cnpj-clien-fornec-ini
                                 AND   {&TableName}.cod-cnpj-clien-fornec  <= c-cod-cnpj-clien-fornec-fim)
                                 OR   {&TableName}.cod-cnpj-clien-fornec    = "":U)
                                 AND (({&TableName}.cod-layout             <> "R-3010" and  {&TableName}.num-period >= i-num-period-ini 
                                                                                       AND  {&TableName}.num-period <= i-num-period-fim) 
                                  or  ({&TableName}.cod-layout              = "R-3010" and  {&TableName}.num-period >= INT(string(year(dt-n-period-ini),"9999")  +
                                                                                                                           string(month(dt-n-period-ini),"99") +
                                                                                                                           string(month(dt-n-period-ini),"99"))
                                                                                       AND  {&TableName}.num-period <= INT(string(year(dt-n-period-fim),"9999")  +
                                                                                                                           string(month(dt-n-period-fim),"99") +
                                                                                                                           string(month(dt-n-period-fim),"99"))))
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
    DEFINE OUTPUT PARAMETER c-cod-estab-ini             AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cod-estab-fim             AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cod-layout-ini            AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cod-layout-fim            AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cod-cnpj-clien-fornec-ini AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cod-cnpj-clien-fornec-fim AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER i-num-period-ini            AS integer     NO-UNDO.
    DEFINE OUTPUT PARAMETER i-num-period-fim            AS integer     NO-UNDO.
    DEFINE OUTPUT PARAMETER dt-n-period-ini             AS date        NO-UNDO.
    DEFINE OUTPUT PARAMETER dt-n-period-fim             AS date        NO-UNDO.
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
           c-cod-estab-ini             = "":U
           c-cod-estab-fim             = "ZZZZZZZZZZZZZZ":U
           c-cod-layout-ini            = "":U
           c-cod-layout-fim            = "ZZZZZZZZ":U
           c-cod-cnpj-clien-fornec-ini = "":U
           c-cod-cnpj-clien-fornec-fim = "ZZZZZZZZZZZZZZZZZZZZZZZZZ":U
           i-num-period-ini            = int(string(year(today - day(today)),"9999") + string(month(today - day(today)),"99"))
           i-num-period-fim            = int(string(year(today),"9999")              + string(month(today),"99"))
           dt-n-period-ini             = date(month(today - day(today)),01,year(today - day(today)))
           dt-n-period-fim             = today
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
        WHERE param-gener.cod-chave-1 = "param-monitor-reinf" 
          AND param-gener.cod-chave-2 = TRIM(c-cod-usuario):

        /* ParÉmetros do Filtro */
        ASSIGN c-cod-estab-ini             = TRIM(SUBSTRING(param-gener.cod-livre-1,   1,  20))
               c-cod-estab-fim             = TRIM(SUBSTRING(param-gener.cod-livre-1,  21,  20))
               c-cod-layout-ini            = TRIM(SUBSTRING(param-gener.cod-livre-1,  41,  10))
               c-cod-layout-fim            = TRIM(SUBSTRING(param-gener.cod-livre-1,  51,  10))
               c-cod-cnpj-clien-fornec-ini = TRIM(SUBSTRING(param-gener.cod-livre-1,  61,  30))
               c-cod-cnpj-clien-fornec-fim = TRIM(SUBSTRING(param-gener.cod-livre-1,  91,  30))
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

        if param-gener.dat-livre-3 <> ? and 
           param-gener.dat-livre-4 <> ? then
           assign dt-n-period-ini  = param-gener.dat-livre-3
                  dt-n-period-fim  = param-gener.dat-livre-4 no-error.

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
    DEFINE INPUT PARAMETER c-cod-estab-ini             AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-estab-fim             AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-layout-ini            AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-layout-fim            AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-cnpj-clien-fornec-ini AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-cnpj-clien-fornec-fim AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER i-num-period-ini            AS integer     NO-UNDO.
    DEFINE INPUT PARAMETER i-num-period-fim            AS integer     NO-UNDO.
    DEFINE INPUT PARAMETER dt-n-period-ini             AS date        NO-UNDO.
    DEFINE INPUT PARAMETER dt-n-period-fim             AS date        NO-UNDO.
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
        WHERE param-gener.cod-chave-1 = "param-monitor-reinf" 
          AND param-gener.cod-chave-2 = TRIM(c-cod-usuario):
    END.
    IF  NOT AVAIL param-gener THEN DO:
        CREATE param-gener.
        ASSIGN param-gener.cod-chave-1 = "param-monitor-reinf" 
               param-gener.cod-chave-2 = TRIM(c-cod-usuario).
    END.

    /* ParÉmetros do Filtro */
    ASSIGN OVERLAY(param-gener.cod-livre-1,   1,  20) = c-cod-estab-ini            
           OVERLAY(param-gener.cod-livre-1,  21,  20) = c-cod-estab-fim            
           OVERLAY(param-gener.cod-livre-1,  41,  10) = c-cod-layout-ini           
           OVERLAY(param-gener.cod-livre-1,  51,  10) = c-cod-layout-fim           
           OVERLAY(param-gener.cod-livre-1,  61,  30) = c-cod-cnpj-clien-fornec-ini
           OVERLAY(param-gener.cod-livre-1,  91,  30) = c-cod-cnpj-clien-fornec-fim
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
           OVERLAY(param-gener.cod-livre-1, 159,  10) = string(i-num-period-fim)
           param-gener.dat-livre-3                    = dt-n-period-ini
           param-gener.dat-livre-4                    = dt-n-period-fim.

    /* ParÉmetros da Regeraá∆o */
    ASSIGN OVERLAY(param-gener.cod-livre-2,   1,   1) = IF l-log-integr-tss         THEN "S":U ELSE "N":U   
           OVERLAY(param-gener.cod-livre-2,   2,   1) = IF l-log-exporta-xml        THEN "S":U ELSE "N":U
           OVERLAY(param-gener.cod-livre-2,   3, 300) = c-cod-dir-export-xml
           OVERLAY(param-gener.cod-livre-2, 303,   1) = IF l-log-gera-even-com-erro THEN "S":U ELSE "N":U.
              
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE limpaTTReinfLogEnvioAux DBOProgram 
PROCEDURE limpaTTReinfLogEnvioAux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-reinf-log-envio-aux     NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE integraEventosREINF DBOProgram 
PROCEDURE integraEventosREINF :
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
    DEFINE INPUT PARAMETER TABLE FOR tt-reinf-log-envio-aux.

    DISABLE TRIGGERS FOR LOAD OF reinf-log-envio.
    DISABLE TRIGGERS FOR LOAD OF reinf-log-envio-xml.
    
    IF  NOT VALID-HANDLE(h-lfapi0401) THEN
        RUN lfp/lfapi0401.p PERSISTENT SET h-lfapi0401.
    
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
        /* Exclus∆o R9000 */
        WHEN 2 THEN DO: 
        
            ASSIGN cListaSitLogEnv = "4". /* 4-Autorizado */

            FOR EACH tt-reinf-log-envio-aux NO-LOCK
               WHERE ((LOOKUP(STRING(tt-reinf-log-envio-aux.idi-ult-status-gerac), cListaSitLogEnv, ",") > 0)
                      OR tt-reinf-log-envio-aux.cod-cnpj-clien-fornec = "RemoverContribuinte"):
    
                RUN piExcluiEventoTSS.
    
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

            FOR EACH tt-reinf-log-envio-aux NO-LOCK
               WHERE LOOKUP(STRING(tt-reinf-log-envio-aux.idi-ult-status-gerac), cListaSitLogEnv, ",") > 0:
    
               if tt-reinf-log-envio-aux.cod-layout = "R-2098" or
                  tt-reinf-log-envio-aux.cod-layout = "R-2099" then
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

    FOR EACH tt-reinf-log-envio-aux NO-LOCK
        WHERE LOOKUP(STRING(tt-reinf-log-envio-aux.idi-ult-status-gerac), cListaSitLogEnv, ",") > 0,

         each bf-reinf-log-envio-xml NO-LOCK
        WHERE bf-reinf-log-envio-xml.idi-tip-ambiente      = tt-reinf-log-envio-aux.idi-tip-ambiente
          AND bf-reinf-log-envio-xml.cod-empresa           = tt-reinf-log-envio-aux.cod-empresa
          AND bf-reinf-log-envio-xml.cod-estab             = tt-reinf-log-envio-aux.cod-estab
          AND bf-reinf-log-envio-xml.cod-layout            = tt-reinf-log-envio-aux.cod-layout
          AND bf-reinf-log-envio-xml.cod-cnpj-clien-fornec = tt-reinf-log-envio-aux.cod-cnpj-clien-fornec
          AND bf-reinf-log-envio-xml.num-period            = tt-reinf-log-envio-aux.num-period
           BY bf-reinf-log-envio-xml.dat-envio-xml desc
           BY bf-reinf-log-envio-xml.hra-envio-xml desc:

        CREATE tt-log-envio-xml.
        ASSIGN tt-log-envio-xml.idi-tip-ambiente = bf-reinf-log-envio-xml.idi-tip-ambiente
               tt-log-envio-xml.cod-empresa      = bf-reinf-log-envio-xml.cod-empresa
               tt-log-envio-xml.cod-estab-param  = if tt-reinf-log-envio-aux.cod-livre-1 <> "" then tt-reinf-log-envio-aux.cod-livre-1 else bf-reinf-log-envio-xml.cod-estab
               tt-log-envio-xml.cod-layout       = bf-reinf-log-envio-xml.cod-layout
               tt-log-envio-xml.cod-estab-cno    = bf-reinf-log-envio-xml.cod-estab
               tt-log-envio-xml.cod-cnpj-cli-for = bf-reinf-log-envio-xml.cod-cnpj-clien-fornec
               tt-log-envio-xml.num-periodo      = bf-reinf-log-envio-xml.num-period
               tt-log-envio-xml.cod-id-evento    = bf-reinf-log-envio-xml.cod-id-evento.

        COPY-LOB FROM bf-reinf-log-envio-xml.blb-arq-xml TO lch-arq-xml.
        COPY-LOB FROM lch-arq-xml                        TO tt-log-envio-xml.arq-xml.

        IF  VALID-HANDLE(h-acomp) THEN 
			RUN pi-acompanhar IN h-acomp (INPUT "Envio Eventos: " + bf-reinf-log-envio-xml.cod-estab + " / " + bf-reinf-log-envio-xml.cod-layout + " / " + bf-reinf-log-envio-xml.cod-id-evento).

        leave.
                                          
    END.

    IF  NOT CAN-FIND (FIRST tt-log-envio-xml) THEN
        RETURN "OK":U.

    RUN pi-executa-reeenvio IN h-lfapi0401 (INPUT-OUTPUT TABLE tt-log-envio-xml, /* Informacoes do Evento + XML */
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
   def var c-estab-cno    as char no-undo.
   def var c-cnpj-cli-for as char no-undo.
   def var c-num-period   as char no-undo.
   def var dt-nao-period  as date no-undo.

   if valid-handle(h-acomp) then
      run pi-acompanhar in h-acomp (input "Regeraá∆o do Evento: " + tt-reinf-log-envio-aux.cod-estab + " / " + tt-reinf-log-envio-aux.cod-layout).

   empty temp-table tt-params-generic.
   empty temp-table tt-log-envio-xml.
   empty temp-table tt-error.

   /* Alimenta os ParÉmetros conforme as Regras dos Layouts */
   assign c-estab-param = if tt-reinf-log-envio-aux.cod-livre-1 <> "" then tt-reinf-log-envio-aux.cod-livre-1 else tt-reinf-log-envio-aux.cod-estab.

   if c-estab-param = tt-reinf-log-envio-aux.cod-estab then 
      assign c-estab-ini = tt-reinf-log-envio-aux.cod-estab
             c-estab-fim = tt-reinf-log-envio-aux.cod-estab
             c-estab-cno = "".
   else /* Eh uma CNO */
      assign c-estab-ini = ""
             c-estab-fim = "ZZZZZ"
             c-estab-cno = tt-reinf-log-envio-aux.cod-estab.

   assign c-cnpj-cli-for = tt-reinf-log-envio-aux.cod-cnpj-clien-fornec
          c-num-period   = string(tt-reinf-log-envio-aux.num-period).

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
   setParamsGeneric("tt-param-tela", "estab-cno",           c-estab-cno).
   setParamsGeneric("tt-param-tela", "cnpj-cli-for",        c-cnpj-cli-for).

   run pi-executa-geracao-envio in h-lfapi0401 (input  tt-reinf-log-envio-aux.cod-layout,
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
                                  &ErrorParameters="'Erro na Regeraá∆o do Evento !'  + '~~~~' + 
                                                    'Origem: ' + tt-error.orig-error + '. '   +
                                                    'Detalhes do Erro: ' + tt-error.desc-error"}
   end.

   if not can-find(first tt-log-envio-xml) then do:

      if tt-reinf-log-envio-aux.idi-ult-status-gerac = 4 /* Autorizado */ then do:
         {method/svc/errors/inserr.i &ErrorNumber="15825"
                                     &ErrorType="EMS"
                                     &ErrorSubType="Information"
                                     &ErrorParameters="'N∆o foram econtrados Dados para Regeraá∆o do Evento !'   + '~~~~' + 
                                                       'Evento: ' + tt-reinf-log-envio-aux.cod-estab             + ' / '  + 
                                                                    tt-reinf-log-envio-aux.cod-layout            + ' / '  +
                                                                    tt-reinf-log-envio-aux.cod-cnpj-clien-fornec + '. '   +
                                                       'IMPORTANTE: O Evento encontra-se Autorizado sob recibo ' + tt-reinf-log-envio-aux.cod-ult-recibo + '. ' +
                                                       'Certifique-se de que realmente n∆o h† informaá‰es a apresentar e solicite a Exclus∆o do Evento !'"}
      end.
      else do:
         {method/svc/errors/inserr.i &ErrorNumber="15825"
                                     &ErrorType="EMS"
                                     &ErrorSubType="Information"
                                     &ErrorParameters="'N∆o foram econtrados Dados para Regeraá∆o do Evento !'   + '~~~~' + 
                                                       'Evento: ' + tt-reinf-log-envio-aux.cod-estab             + ' / '  + 
                                                                    tt-reinf-log-envio-aux.cod-layout            + ' / '  +
                                                                    tt-reinf-log-envio-aux.cod-cnpj-clien-fornec + '. '"}
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
                                           &ErrorParameters="'Erro na Regeraá∆o do Evento !'             + '~~~~' +
                                                             'Evento: ' + tt-log-envio-xml.cod-id-evento + '. '   +
                                                             'Detalhes do Erro (Schema): ' + tt-log-envio-xml.des-vld-schema"}
            end.
            else do:
               /* Envio NOK/OK */
               if tt-log-envio-xml.log-tss-ok = no THEN DO:
                  {method/svc/errors/inserr.i &ErrorNumber="17006"
                                              &ErrorType="EMS"
                                              &ErrorSubType="ERROR"
                                              &ErrorParameters="'Erro na Regeraá∆o do Evento !'             + '~~~~' + 
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
                                                       'Evento: ' + tt-reinf-log-envio-aux.cod-estab             + ' / '  + 
                                                                    tt-reinf-log-envio-aux.cod-layout            + ' / '  +
                                                                    tt-reinf-log-envio-aux.cod-cnpj-clien-fornec + '. '   +
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
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-cod-layout-geracao as char no-undo.
    def var c-liter              as char no-undo.

    if tt-reinf-log-envio-aux.cod-layout = "R-1000" or
       tt-reinf-log-envio-aux.cod-layout = "R-1070" then
       assign c-cod-layout-geracao = tt-reinf-log-envio-aux.cod-layout.
    else
       assign c-cod-layout-geracao = "R-9000".

    assign c-liter = "Evento".
    IF  tt-reinf-log-envio-aux.cod-cnpj-clien-fornec = "RemoverContribuinte" THEN
        ASSIGN c-liter = "Contribuinte".

    IF  VALID-HANDLE(h-acomp) THEN 
        RUN pi-acompanhar IN h-acomp (INPUT "Exclus∆o " + c-liter + " (" + c-cod-layout-geracao + "): " + tt-reinf-log-envio-aux.cod-estab + " / " + tt-reinf-log-envio-aux.cod-layout).

    EMPTY TEMP-TABLE tt-params-generic.
    EMPTY TEMP-TABLE tt-log-envio-xml.
    EMPTY TEMP-TABLE tt-error.

    /*Cria tabela generica conforme os campos da tt-reinf-log-envio-aux*/
    initParamsGeneric("tt-param-exclusao"). /* Limpa a tt-generic-param */

    setParamsGeneric("tt-param-exclusao", "log-exclusao"         , "yes"                                       ). /* Indicaá∆o de Exclus∆o para utilizar nos Layouts de Cadastro                  */
    setParamsGeneric("tt-param-exclusao", "cod-estab-cno"        , tt-reinf-log-envio-aux.cod-estab            ). /* c¢digo do estabelecimento                                                    */
    setParamsGeneric("tt-param-exclusao", "cod-estab-param"      , (IF tt-reinf-log-envio-aux.cod-livre-1 <> "":U 
                                                                    THEN tt-reinf-log-envio-aux.cod-livre-1 
                                                                    ELSE tt-reinf-log-envio-aux.cod-estab)     ). /* c¢digo do estabelecimento                                                    */
    setParamsGeneric("tt-param-exclusao", "cod-layout-exclusao"  , tt-reinf-log-envio-aux.cod-layout           ). /* c¢digo do evento que vai ser exclu°do. Ex: R-2010                            */
    setParamsGeneric("tt-param-exclusao", "cod-cnpj-clien-fornec", tt-reinf-log-envio-aux.cod-cnpj-clien-fornec). /* c¢digo do CNPJ do cliente ou fornecedor (CNPJ 2 do evento que ser† exclu°do  */
    setParamsGeneric("tt-param-exclusao", "cod-recibo-exclusao"  , tt-reinf-log-envio-aux.cod-ult-recibo       ). /* n£mero do recibo do evento que vai ser exclu°do                              */
    setParamsGeneric("tt-param-exclusao", "cod-periodo-apur"     , STRING(tt-reinf-log-envio-aux.num-period)   ). /* per°odo de apuraá∆o do evento que vai ser exclu°do */

    RUN pi-executa-geracao-envio IN h-lfapi0401 (INPUT  c-cod-layout-geracao,
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
    
                IF  tt-reinf-log-envio-aux.cod-cnpj-clien-fornec <> "RemoverContribuinte" THEN DO:
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

    FOR EACH tt-reinf-log-envio-aux NO-LOCK
       WHERE LOOKUP(STRING(tt-reinf-log-envio-aux.idi-ult-status-gerac), cListaSitLogEnv, ",") > 0:

        FOR each bf-reinf-log-envio-xml NO-LOCK
           WHERE bf-reinf-log-envio-xml.idi-tip-ambiente      = tt-reinf-log-envio-aux.idi-tip-ambiente
             AND bf-reinf-log-envio-xml.cod-empresa           = tt-reinf-log-envio-aux.cod-empresa
             AND bf-reinf-log-envio-xml.cod-estab             = tt-reinf-log-envio-aux.cod-estab
             AND bf-reinf-log-envio-xml.cod-layout            = tt-reinf-log-envio-aux.cod-layout
             AND bf-reinf-log-envio-xml.cod-cnpj-clien-fornec = tt-reinf-log-envio-aux.cod-cnpj-clien-fornec
             AND bf-reinf-log-envio-xml.num-period            = tt-reinf-log-envio-aux.num-period
              BY bf-reinf-log-envio-xml.dat-envio-xml desc
              BY bf-reinf-log-envio-xml.hra-envio-xml desc:

            CREATE tt-log-envio-xml.
            ASSIGN tt-log-envio-xml.idi-tip-ambiente = bf-reinf-log-envio-xml.idi-tip-ambiente
                   tt-log-envio-xml.cod-empresa      = bf-reinf-log-envio-xml.cod-empresa
                   tt-log-envio-xml.cod-estab-param  = (IF tt-reinf-log-envio-aux.cod-livre-1 <> "":U 
                                                        THEN tt-reinf-log-envio-aux.cod-livre-1 
                                                        ELSE bf-reinf-log-envio-xml.cod-estab)
                   tt-log-envio-xml.cod-layout       = bf-reinf-log-envio-xml.cod-layout
                   tt-log-envio-xml.cod-estab-cno    = bf-reinf-log-envio-xml.cod-estab
                   tt-log-envio-xml.cod-cnpj-cli-for = bf-reinf-log-envio-xml.cod-cnpj-clien-fornec
                   tt-log-envio-xml.num-periodo      = bf-reinf-log-envio-xml.num-period
                   tt-log-envio-xml.cod-id-evento    = bf-reinf-log-envio-xml.cod-id-evento.
    
            IF  VALID-HANDLE(h-acomp) THEN 
    			RUN pi-acompanhar IN h-acomp (INPUT "Consulta Eventos: " + bf-reinf-log-envio-xml.cod-estab + " / " + bf-reinf-log-envio-xml.cod-layout + " / " + bf-reinf-log-envio-xml.cod-id-evento).
    
            leave.
        END.
       
    END.

    IF  NOT CAN-FIND (FIRST tt-log-envio-xml) THEN
        RETURN "OK":U.

    IF  NOT VALID-HANDLE(h-lfapi0400) THEN
        RUN lfp/lfapi0400.p PERSISTENT SET h-lfapi0400.

    IF  VALID-HANDLE(h-acomp) THEN 
		RUN pi-acompanhar IN h-acomp (INPUT "Integraá∆o com TSS - EFD-REINF...").

    RUN TSSWSREINF_CONSULTAREVENTOS IN h-lfapi0400 (INPUT-OUTPUT TABLE tt-log-envio-xml). /* Informacoes do Evento */

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

        /* Atualiza reinf-log-envio */
        FOR FIRST bf-reinf-log-envio EXCLUSIVE-LOCK
            WHERE bf-reinf-log-envio.idi-tip-ambiente      = tt-log-envio-xml.idi-tip-ambiente
              AND bf-reinf-log-envio.cod-empresa           = tt-log-envio-xml.cod-empresa
              AND bf-reinf-log-envio.cod-estab             = tt-log-envio-xml.cod-estab-cno
              AND bf-reinf-log-envio.cod-layout            = tt-log-envio-xml.cod-layout
              AND bf-reinf-log-envio.cod-cnpj-clien-fornec = tt-log-envio-xml.cod-cnpj-cli-for
              AND bf-reinf-log-envio.num-period            = tt-log-envio-xml.num-periodo:

            /* Status atual: Em Exclus∆o */
            IF  bf-reinf-log-envio.idi-ult-status-gerac = 6 /*Em Exclus∆o*/ THEN
                ASSIGN bf-reinf-log-envio.idi-ult-status-gerac = (IF   tt-log-envio-xml.num-status-tss = 6 /*6 - Evento Autorizado*/
                                                                  THEN 7 /*Exclu°do*/
                                                                  ELSE IF   tt-log-envio-xml.num-status-tss = 5 /*5 - Evento Rejeitado*/
                                                                       AND  bf-reinf-log-envio.cod-cnpj-clien-fornec = "RemoverContribuinte"
                                                                       THEN 5 /*Rejeitado*/
                                                                       ELSE IF (tt-log-envio-xml.num-status-tss = 5  /*5 - Evento Rejeitado*/
                                                                            OR  tt-log-envio-xml.num-status-tss = 3) /*3 - XML Inv†lido (Parser/Schema/Vlds)*/
                                                                            THEN 4 /*Autorizado*/  /* Exclus∆o n∆o foi autorizada, volta para status anterior "Autorizado" */
                                                                            ELSE bf-reinf-log-envio.idi-ult-status-gerac).
            /* Demais Status */
            ELSE
                ASSIGN bf-reinf-log-envio.idi-ult-status-gerac = (IF   tt-log-envio-xml.num-status-tss = 6 /*6 - Evento Autorizado*/
                                                                  THEN 4 /*Autorizado*/
                                                                  ELSE IF (tt-log-envio-xml.num-status-tss = 5  /*5 - Evento Rejeitado*/
                                                                       OR  tt-log-envio-xml.num-status-tss = 3) /*3 - XML Inv†lido (Parser/Schema/Vlds)*/
                                                                       THEN 5   /*Rejeitado*/
                                                                       ELSE 3). /*Em Processamento*/

            ASSIGN bf-reinf-log-envio.cod-ult-recibo       = (IF   tt-log-envio-xml.cod-recibo <> "":U
                                                              THEN tt-log-envio-xml.cod-recibo
                                                              ELSE bf-reinf-log-envio.cod-ult-recibo).
        END.

        /* Atualiza reinf-log-envio-xml */
        FOR FIRST bf-reinf-log-envio-xml EXCLUSIVE-LOCK
            WHERE bf-reinf-log-envio-xml.idi-tip-ambiente      = tt-log-envio-xml.idi-tip-ambiente
              AND bf-reinf-log-envio-xml.cod-empresa           = tt-log-envio-xml.cod-empresa     
              AND bf-reinf-log-envio-xml.cod-estab             = tt-log-envio-xml.cod-estab-cno       
              AND bf-reinf-log-envio-xml.cod-layout            = tt-log-envio-xml.cod-layout      
              AND bf-reinf-log-envio-xml.cod-cnpj-clien-fornec = tt-log-envio-xml.cod-cnpj-cli-for
              AND bf-reinf-log-envio-xml.num-period            = tt-log-envio-xml.num-periodo     
              AND bf-reinf-log-envio-xml.cod-id-evento         = tt-log-envio-xml.cod-id-evento:

            ASSIGN bf-reinf-log-envio-xml.idi-status-envio-xml = (IF   tt-log-envio-xml.num-status-tss = 6 /*6 - Evento Autorizado*/
                                                                  THEN 4 /*Autorizado*/
                                                                  ELSE IF (tt-log-envio-xml.num-status-tss = 5  /*5 - Evento Rejeitado*/
                                                                       OR  tt-log-envio-xml.num-status-tss = 3) /*3 - XML Inv†lido (Parser/Schema/Vlds)*/
                                                                       THEN 5  /*Rejeitado*/
                                                                       ELSE 3) /*Em Processamento*/
                   bf-reinf-log-envio-xml.cod-recibo           = tt-log-envio-xml.cod-recibo
                   bf-reinf-log-envio-xml.cod-protocolo        = tt-log-envio-xml.cod-protoc
                   bf-reinf-log-envio-xml.cod-mensagem         = tt-log-envio-xml.des-vld-tss.

            /* ++++++++++++ N«O ATUALIZAR PARA N«O SOBREPOR AO GERADO NO ENVIO ++++++++++++ */
            /* XML Envio */
            /* COPY-LOB FROM tt-log-envio-xml.arq-xml     TO lcEventoXML.                        */ 
            /* COPY-LOB FROM lcEventoXML                  TO bf-reinf-log-envio-xml.blb-arq-xml. */

            /* XML Retorno */
            COPY-LOB FROM tt-log-envio-xml.arq-xml-ret TO lcEventoXMLRet.
            if trim(lcEventoXMLRet) = "" then
               assign lcEventoXMLRet = trim(trim(tt-log-envio-xml.des-vld-schema) + " " + trim(tt-log-envio-xml.des-vld-tss)).
            COPY-LOB FROM lcEventoXMLRet               TO bf-reinf-log-envio-xml.blb-arq-xml-ret.

        END.
    END.

    RELEASE reinf-log-envio.
    RELEASE reinf-log-envio-xml.
    RELEASE bf-reinf-log-envio.
    RELEASE bf-reinf-log-envio-xml.

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
