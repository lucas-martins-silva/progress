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
{include/i-prgvrs.i BOCX407 2.00.00.033 } /*** "010033" 02/12/2025 11:29:10 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX407
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName decla-import-embarq
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
{cxbo/bocx407.i RowObject}
{cxbo/bocx220.i tt-embarque-imp}
{cxbo/bocx230.i tt-historico-embarque-first}
{cxbo/bocx230.i tt-historico-embarque}
{cxbo/bocx384.i tt-decla-histor-di}
{cxbo/bocx384.i tt-decla-histor-di-aux}
{cxbo/bocx403.i tt-decla-imp-adic}
{cxbo/bocx403.i tt-decla-imp-adic-aux}
{cxbo/bocx404.i tt-decla-import-ord}
{cxbo/bocx404.i tt-decla-import-ord-aux}
{cxbo/bocx406.i tt-despes-decla-import}
{cxbo/bocx406.i tt-despes-decla-import-aux}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{include/boerrtab.i}            /* Temp-table tt-bo-erro */


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF VAR i-num-di-ems LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEFINE VARIABLE h-bocx220na AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx220   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx115   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx230   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx384   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx403   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx404   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx406   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx383a  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-cdapi050  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00446 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00507 AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-return          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cod-itiner      LIKE historico-embarque.cod-itiner NO-UNDO.
DEFINE VARIABLE i-sequencia       LIKE historico-embarque.sequencia  NO-UNDO.
DEFINE VARIABLE i-seq-first       LIKE historico-embarque.sequencia  NO-UNDO.
DEFINE VARIABLE i-seq             LIKE historico-embarque.sequencia  NO-UNDO.
DEFINE VARIABLE i-pto-desembarque LIKE itinerario.pto-desembarque    NO-UNDO.
DEFINE VARIABLE c-sequencias-first AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-sequencias       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-reg-retornados   AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-retorno          AS LOGICAL INITIAL NO             NO-UNDO.
DEFINE VARIABLE i-via-transp       AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-primeiro         AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-permite-via-dif  AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-ord-compra       AS LOGICAL INITIAL NO             NO-UNDO.
DEFINE VARIABLE l-desp-import      AS LOGICAL INITIAL NO             NO-UNDO.
DEFINE VARIABLE log-eliminina-despesas AS LOG  NO-UNDO.
DEFINE VARIABLE c-orig-prog            AS CHAR NO-UNDO.
DEFINE VARIABLE de-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.
DEFINE VARIABLE l-nt2024002        AS LOGICAL                            NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002":U AND funcao.ativo).

{cdp/cd4300.i3}             /* variaveis para desmembrar variaveis livres   */
{ccp/cc9019.i50}            /* desmembrar atributos livres cotacao-item     */

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
         HEIGHT             = 22.38
         WIDTH              = 39.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-atualiza-dados-di.
    RUN pi-atualiza-log-pend-rat.
    RUN pi-save-siscoserv.
    RUN pi-atualiza-adiant (INPUT 1).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT CAN-FIND(FIRST bf{&TABLENAME}
                WHERE bf{&TABLENAME}.num-di-ems = RowObject.num-di-ems
                  AND bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:
    RUN pi-elimina-historico-di.
    IF c-orig-prog = "im0420" THEN DO:
        IF log-eliminina-despesas THEN DO:
            RUN pi-elimina-despesas-di.
        END.
    END.
    ELSE DO:
        RUN pi-elimina-despesas-di.
    END.
END.
    
RUN pi-zera-valores(INPUT RowObject.num-di-ems,
                    INPUT RowObject.cdd-siscomex-dts). /* zera os valores quando o embarque Ç desvinculado da DI */
RUN pi-atualiza-log-pend-rat.
RUN pi-atualiza-adiant (INPUT 2).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-atualiza-dados-di.
    RUN pi-atualiza-log-pend-rat.
    RUN pi-save-siscoserv.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:          h-cdapi050
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-cdapi050) THEN
        RUN cdp/cdapi050.p PERSISTENT SET h-cdapi050.

    RUN pi-siscoserv-ativo IN h-cdapi050.
    IF RETURN-VALUE = "OK":U THEN
        RUN pi-apaga-decla-import-sis IN h-cdapi050 (INPUT rowObject.cod-estab,
                                                     INPUT rowObject.cod-embarq,
                                                     INPUT rowObject.num-di-ems,
                                                     INPUT RowObject.cdd-siscomex-dts).
    IF VALID-HANDLE(h-cdapi050) THEN DO:
        DELETE PROCEDURE h-cdapi050.
        ASSIGN h-cdapi050 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaEmbRelac DBOProgram 
PROCEDURE buscaEmbRelac :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcod-embarque LIKE {&TableName}.cod-embarq NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-estab    LIKE {&TableName}.cod-estab  NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-habilita   AS   LOGICAL                 NO-UNDO.

    IF  CAN-FIND(FIRST {&TableName} 
                 WHERE {&TableName}.cod-embarq = pcod-embarque
                 AND   {&TableName}.cod-estab  = pcod-estab) THEN 
        
        ASSIGN pl-habilita = NO.
    ELSE 
        ASSIGN pl-habilita = YES.

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
        WHEN "cod-embarq":U THEN ASSIGN pFieldValue = RowObject.cod-embarq.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
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
        WHEN "cdd-siscomex-dts":U THEN ASSIGN pFieldValue = RowObject.cdd-siscomex-dts.
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
        WHEN "num-di-ems":U THEN ASSIGN pFieldValue = RowObject.num-di-ems.
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
  Purpose:     Retorna valores dos campos do °ndice dclmprtm-id
  Parameters:  
               retorna valor do campo num-di-ems
               retorna valor do campo cod-embarq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-di-ems LIKE decla-import-embarq.num-di-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-embarq LIKE decla-import-embarq.cod-embarq NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdd-siscomex-dts LIKE decla-import-embarq.cdd-siscomex-dts NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-di-ems = RowObject.num-di-ems
           pcod-embarq = RowObject.cod-embarq
           pcdd-siscomex-dts = RowObject.cdd-siscomex-dts.

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
  Purpose:     Reposiciona registro com base no °ndice dclmprtm-id
  Parameters:  
               recebe valor do campo num-di-ems
               recebe valor do campo cod-embarq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems LIKE decla-import-embarq.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER pcod-embarq LIKE decla-import-embarq.cod-embarq NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-siscomex-dts LIKE decla-import-embarq.cdd-siscomex-dts NO-UNDO.

    FIND FIRST bfdecla-import-embarq WHERE 
        bfdecla-import-embarq.num-di-ems = pnum-di-ems AND 
        bfdecla-import-embarq.cod-embarq = pcod-embarq AND 
        bfdecla-import-embarq.cdd-siscomex-dts = pcdd-siscomex-dts NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdecla-import-embarq THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdecla-import-embarq)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToFirstEmbarque DBOProgram 
PROCEDURE goToFirstEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro no primeiro embarque da DI.
  Parameters:  
               recebe valor do campo num-di-ems
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems LIKE decla-import-embarq.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-siscomex-dts LIKE decla-import-embarq.cdd-siscomex-dts NO-UNDO.

    FIND FIRST bfdecla-import-embarq WHERE 
        bfdecla-import-embarq.num-di-ems = pnum-di-ems AND
        bfdecla-import-embarq.cdd-siscomex-dts = pcdd-siscomex-dts NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdecla-import-embarq THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdecla-import-embarq)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDI DBOProgram 
PROCEDURE openQueryByDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME} 
                            WHERE {&TABLENAME}.num-di-ems = i-num-di-ems 
                              AND {&TABLENAME}.cdd-siscomex-dts = de-cdd-siscomex-dts NO-LOCK INDEXED-REPOSITION.

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
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-nat-DI DBOProgram 
PROCEDURE pi-altera-nat-DI :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pnum-di-ems   LIKE decla-import.num-di-ems NO-UNDO.
    DEF INPUT PARAM pnat-operacao LIKE natur-oper.nat-operacao NO-UNDO.
    DEF INPUT PARAM pcdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

    FOR FIRST decla-import EXCLUSIVE-LOCK
        WHERE decla-import.num-di-ems = pnum-di-ems
          AND decla-import.cdd-siscomex-dts = pcdd-siscomex-dts:

        ASSIGN decla-import.cod-natur-operac = pnat-operacao.
    END. /* FOR FIRST decla-import */
    
    RELEASE decla-import.


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-nat-ordens DBOProgram 
PROCEDURE pi-altera-nat-ordens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-num-di-ems LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT PARAM p-cod-estab  LIKE {&TABLENAME}.cod-estab  NO-UNDO.
DEF INPUT PARAM p-cod-embarq LIKE {&TABLENAME}.cod-embarq NO-UNDO.
DEF INPUT PARAM p-nat-oper   LIKE natur-oper.nat-operacao NO-UNDO.
DEF INPUT PARAM pcdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

IF NOT CAN-FIND(FIRST natur-oper
                WHERE natur-oper.nat-operacao = p-nat-oper) THEN DO:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-natureza-de-operacao AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Natureza_de_Operaá∆o" *}
    ASSIGN c-lbl-liter-natureza-de-operacao = TRIM(RETURN-VALUE).
    {method/svc/errors/inserr.i
          &ErrorNumber="2"
          &ErrorType="EMS"
          &ErrorParameters="c-lbl-liter-natureza-de-operacao"}      
    RETURN "NOK":U.
END.
    

FOR EACH decla-import-ord EXCLUSIVE-LOCK
    WHERE decla-import-ord.num-di-ems = p-num-di-ems  
    AND   decla-import-ord.cod-estab  = p-cod-estab  
    AND   decla-import-ord.cod-embarq = p-cod-embarq
    AND   decla-import-ord.cdd-siscomex-dts = pcdd-siscomex-dts,
    FIRST decla-import
    WHERE decla-import.num-di-ems = decla-import-ord.num-di-ems
    AND   decla-import.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts
    AND   decla-import.log-ativo:
	
	FOR FIRST natur-oper FIELD(perc-red-icm)
						 WHERE natur-oper.nat-operacao = p-nat-oper
                         NO-LOCK:
	END.
    
	ASSIGN decla-import-ord.cod-natur-operac    = p-nat-oper
		   decla-import-ord.val-perc-reduc-icms = natur-oper.perc-red-icm.
           
    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
        ASSIGN decla-import.log-pend-impto = NO.
    &ELSE
        ASSIGN decla-import.log-livre-2 = NO.
    &ENDIF

END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-adiant DBOProgram 
PROCEDURE pi-atualiza-adiant :
/*------------------------------------------------------------------------------
  Purpose: Atualiza adiantamento das despesas    
  Parameters:  Recebe o valor inteiro 1 = Inclus∆o
                                      2 = Eliminaá∆o
  Notes:       
------------------------------------------------------------------------------*/
 DEF INPUT PARAM p-tipo AS INTEGER NO-UNDO.  
 DEF VAR num-di-ems LIKE adiant-despes-embarq.num-di-ems  NO-UNDO.

 IF CAN-FIND(adiant-despes-embarq WHERE
             adiant-despes-embarq.cod-estabel = RowObject.cod-estab   AND
             adiant-despes-embarq.cod-embarq  = RowObject.cod-embarq) THEN DO:
    IF p-tipo = 1 THEN 
       ASSIGN num-di-ems = RowObject.num-di-ems.
    ELSE 
       ASSIGN num-di-ems = 0.

    RUN cxbo/bocx00446.p PERSISTENT SET h-bocx00446.    
    RUN pi-atualiza-DI-Adiant IN h-bocx00446 (INPUT  RowObject.cod-estab, 
                                              INPUT  RowObject.cod-embarq, 
                                              INPUT  num-di-ems).
    IF VALID-HANDLE(h-bocx00446) THEN DO:
        DELETE PROCEDURE h-bocx00446.
        ASSIGN h-bocx00446 = ?.
    END.
 END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-dados-di DBOProgram 
PROCEDURE pi-atualiza-dados-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR FIRST decla-import EXCLUSIVE-LOCK
    WHERE decla-import.num-di-ems = RowObject.num-di-ems
      AND decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
END.

FOR FIRST embarque-imp EXCLUSIVE-LOCK
    WHERE embarque-imp.embarque    = RowObject.cod-embarq
    AND   embarque-imp.cod-estabel = RowObject.cod-estab:

    IF decla-import.cdn-urf-entr = 0 THEN DO:
        ASSIGN i-pto-desembarque = 0.
        RUN retorna-ponto-nacionalizacao (INPUT RowObject.cod-embarq,
                                          INPUT decla-import.cod-estab,
                                          OUTPUT i-pto-desembarque).
        FOR FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = i-pto-desembarque:
            ASSIGN decla-import.cdn-urf-entr = pto-contr.unid-referencial.
        END.

    END.

    IF decla-import.cdn-urf-despch = 0 THEN DO:
        ASSIGN i-pto-desembarque = 0.
        RUN retorna-ponto-despacho (INPUT RowObject.cod-embarq,
                                    INPUT decla-import.cod-estab,
                                    OUTPUT i-pto-desembarque).
        FOR FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = i-pto-desembarque:
            ASSIGN decla-import.cdn-urf-despch = pto-contr.unid-referencial.
        END.

    END.

    IF decla-import.cod-conhecto-master = "" THEN
        ASSIGN decla-import.cod-conhecto-master = embarque-imp.cod-conhecto-master.
    ELSE
        IF embarque-imp.cod-conhecto-master = "" OR 
            embarque-imp.cod-conhecto-master <> decla-import.cod-conhecto-master THEN
            ASSIGN embarque-imp.cod-conhecto-master = decla-import.cod-conhecto-master.

    IF decla-import.cod-conhecto-house = "" THEN
        ASSIGN decla-import.cod-conhecto-house = embarque-imp.cod-conhecto-house.
    ELSE
        IF embarque-imp.cod-conhecto-house = "" OR 
            embarque-imp.cod-conhecto-house <> decla-import.cod-conhecto-house THEN
            ASSIGN embarque-imp.cod-conhecto-house = decla-import.cod-conhecto-house.

    IF decla-import.cdn-transpdor = 0 THEN
        ASSIGN decla-import.cdn-transpdor = embarque-imp.cod-transportador.
    ELSE
        IF embarque-imp.cod-transportador = 0 OR 
            embarque-imp.cod-transportador <> decla-import.cdn-transpdor THEN
            ASSIGN embarque-imp.cod-transportador = decla-import.cdn-transpdor.

    IF decla-import.idi-via-transp-di = 1 
        AND decla-import.idi-via-transp-di <> embarque-imp.cod-via-transp THEN
        ASSIGN decla-import.idi-via-transp-di = embarque-imp.cod-via-transp.
    ELSE
        IF embarque-imp.cod-via-transp = 1 OR
            embarque-imp.cod-via-transp <> decla-import.idi-via-transp-di THEN
            ASSIGN embarque-imp.cod-via-transp = decla-import.idi-via-transp-di.
    
    IF l-primeiro THEN DO:
        ASSIGN decla-import.idi-via-transp-di = i-via-transp.

        CASE i-via-transp:

            WHEN 1 THEN
                ASSIGN decla-import.cdn-via-transp-di = 7
                       decla-import.log-multimod      = NO.

            WHEN 2 THEN
                ASSIGN decla-import.cdn-via-transp-di = 4
                       decla-import.log-multimod      = YES.

            WHEN 3 THEN
                ASSIGN decla-import.cdn-via-transp-di = 1
                       decla-import.log-multimod      = NO.

            WHEN 4 THEN
                ASSIGN decla-import.cdn-via-transp-di = 6
                       decla-import.log-multimod      = NO.

            WHEN 5 THEN
                ASSIGN decla-import.cdn-via-transp-di = 6
                       decla-import.log-multimod      = YES.

            WHEN 6 THEN
                ASSIGN decla-import.cdn-via-transp-di = 2
                       decla-import.log-multimod      = YES.

            WHEN 7 THEN
                ASSIGN decla-import.cdn-via-transp-di = 7
                       decla-import.log-multimod      = YES.

            WHEN 8 THEN
                ASSIGN decla-import.cdn-via-transp-di = 11
                       decla-import.log-multimod      = NO.

        END CASE.

    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-log-pend-rat DBOProgram 
PROCEDURE pi-atualiza-log-pend-rat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR LAST decla-import EXCLUSIVE-LOCK
    WHERE decla-import.num-di-ems = RowObject.num-di-ems
      AND decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
END.

IF AVAIL decla-import THEN DO:
    ASSIGN decla-import.log-pend-rat = NO.
    &if "{&bf_mat_versao_ems}" < "2.09" &then
        ASSIGN OVERLAY(decla-import.cod-livre-1,1,1) = "N"
               decla-import.log-livre-2              = NO.
    &ELSE
        ASSIGN decla-import.log-pend-despes-compltar = NO
               decla-import.log-pend-impto           = NO.
    &ENDIF
END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-cotacoes-despesas DBOProgram 
PROCEDURE pi-busca-cotacoes-despesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pNumDiEms  LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT  PARAM pCodEmbarq LIKE {&TABLENAME}.cod-embarq NO-UNDO.
DEF INPUT  PARAM pCodEstab  LIKE {&TABLENAME}.cod-estab  NO-UNDO.
DEF INPUT  PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
DEF INPUT  PARAM pAtualizaDesp AS LOGICAL                NO-UNDO.
DEF INPUT  PARAM pEliminaDesp  AS LOGICAL                NO-UNDO.
DEF OUTPUT PARAM pRetorno   AS LOGICAL                   NO-UNDO.

DEFINE VARIABLE i-cod-emitente AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-boin274      AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-return-ordem-compr AS CHARACTER   NO-UNDO.
DEF VAR de-conv-val-cex  LIKE cotacao-item-cex.val-desp no-undo.
DEF VAR de-quant-parcela LIKE ordens-embarque.quantidade no-undo.
DEF BUFFER bf-ordens-embarque FOR ordens-embarque.

IF NOT VALID-HANDLE(h-boin274) THEN
    RUN inbo/boin274.p PERSISTENT SET h-boin274.


FOR FIRST decla-import NO-LOCK
    WHERE decla-import.num-di-ems = pNumDiEms
      AND decla-import.cdd-siscomex-dts = pCddSiscomexDts:
END.


IF AVAIL decla-import THEN DO:
    /*Verifica se foi rateado pelo menos uma vez, se n∆o retorna yes pois n∆o precisa atualizar os valores*/
    IF SUBSTRING(decla-import.cod-livre-1,2,1) = 'N' OR 
       SUBSTRING(decla-import.cod-livre-1,2,1) = '' THEN               
        ASSIGN pRetorno = YES.
    ELSE DO:
        /*Se j† foi rateado deve buscar para ver se tem cotaá∆o das despesas do embarque*/
        ASSIGN pRetorno = YES.

        FOR FIRST embarque-imp NO-LOCK
            WHERE embarque-imp.cod-estabel = pCodEstab 
            AND   embarque-imp.embarque    = pCodEmbarq,
            EACH ordens-embarque NO-LOCK
            WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
            AND   ordens-embarque.embarque    = embarque-imp.embarque,
            FIRST ordem-compra OF ordens-embarque:

            FOR FIRST processo-imp NO-LOCK
                WHERE processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp : END.

            RUN findOrdem IN h-boin274 (INPUT ordens-embarque.numero-ordem,
                                        OUTPUT c-return-ordem-compr).
            IF c-return-ordem-compr = "" THEN
                RUN getintfield IN h-boin274 ("cod-emitente":U, OUTPUT i-cod-emitente).
            
            ASSIGN de-quant-parcela = 0.

            FOR EACH bf-ordens-embarque FIELDS(quantidade)  
                WHERE bf-ordens-embarque.numero-ordem = ordens-embarque.numero-ordem 
                AND   bf-ordens-embarque.parcela      = ordens-embarque.parcela NO-LOCK:
                ASSIGN de-quant-parcela = de-quant-parcela + bf-ordens-embarque.quantidade.
            END.
            
            FOR FIRST cotacao-item fields(cotacao-item.cot-aprovada 
                                      cotacao-item.data-cotacao 
                                      &if defined(bf-mat-comex) &then
                                      &else                                         
                                      cotacao-item.seq-cotac
                                      &endif
                                      cotacao-item.char-1)
                WHERE cotacao-item.numero-ordem = ordens-embarque.numero-ordem
                AND  cotacao-item.cod-emitente = i-cod-emitente
                AND  cotacao-item.it-codigo    = ordem-compra.it-codigo
                AND  cotacao-item.cot-aprovada NO-LOCK:

                {ccp/cc9019.i50}
                &IF DEFINED(bf-mat-comex) &then
                    ASSIGN i-mapa-cotacao-i50  = int(substring(cotacao-item.char-1,6,2))
                           c-cod-incoterm-i50  = substring(cotacao-item.char-1,8,3)
                           i-cod-pto-contr-i50 = int(substring(cotacao-item.char-1,11,5)).
                &ELSE
                    {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                    {ccp/cc9019.i51 "yes"}
                &ENDIF
                
                FOR EACH desp-embarque EXCLUSIVE-LOCK
                    WHERE desp-embarque.cod-estabel = ordens-embarque.cod-estabel
                    AND   desp-embarque.embarque    = ordens-embarque.embarque :

                    IF NOT CAN-FIND(FIRST cotacao-item-cex
                                    WHERE cotacao-item-cex.numero-ordem      = cotacao-item.numero-ordem
                                    AND   cotacao-item-cex.cod-emitente      = cotacao-item.cod-emitente
                                    AND   cotacao-item-cex.it-codigo         = cotacao-item.it-codigo
                                    AND   cotacao-item-cex.seq-cotac         = cotacao-item.seq-cotac
                                    AND   cotacao-item-cex.data-cotacao      = cotacao-item.data-cotacao
                                    AND   cotacao-item-cex.mapa-cotacao      = INTEGER(SUBSTRING(cotacao-item.char-1,1,20))
                                    AND   cotacao-item-cex.cod-incoterm      = SUBSTRING(cotacao-item.char-1,21,20)
                                    AND   cotacao-item-cex.cod-itiner        = processo-imp.cod-itiner
                                    AND   cotacao-item-cex.cod-emitente-desp = desp-embarque.cod-emitente-desp
                                    AND   cotacao-item-cex.cod-desp          = desp-embarque.cod-desp ) THEN DO:
                        IF pEliminaDesp AND pAtualizaDesp THEN DO:
                            DELETE desp-embarque.
                        END.
                        ELSE
                            ASSIGN pRetorno = NO.
                    END.
                    ELSE DO:
                        ASSIGN desp-embarque.val-desp = 0.
                        IF pAtualizaDesp THEN DO:
                            FOR FIRST cotacao-item-cex NO-LOCK
                                WHERE cotacao-item-cex.numero-ordem      = cotacao-item.numero-ordem
                                AND   cotacao-item-cex.cod-emitente      = cotacao-item.cod-emitente
                                AND   cotacao-item-cex.it-codigo         = cotacao-item.it-codigo
                                AND   cotacao-item-cex.seq-cotac         = cotacao-item.seq-cotac
                                AND   cotacao-item-cex.data-cotacao      = cotacao-item.data-cotacao
                                AND   cotacao-item-cex.mapa-cotacao      = INTEGER(SUBSTRING(cotacao-item.char-1,1,20))
                                AND   cotacao-item-cex.cod-incoterm      = SUBSTRING(cotacao-item.char-1,21,20)
                                AND   cotacao-item-cex.cod-itiner        = processo-imp.cod-itiner
                                AND   cotacao-item-cex.cod-emitente-desp = desp-embarque.cod-emitente-desp
                                AND   cotacao-item-cex.cod-desp          = desp-embarque.cod-desp :

                                assign de-conv-val-cex = cotacao-item-cex.val-desp.

                                if  cotacao-item-cex.mo-codigo <> desp-embarque.mo-codigo then do:
                                    run cdp/cd0812.p (input  cotacao-item-cex.mo-codigo,
                                                      input  desp-embarque.mo-codigo,
                                                      input  cotacao-item-cex.val-desp,
                                                      input  today,
                                                      output de-conv-val-cex).
                                    if de-conv-val-cex = 0 or
                                       de-conv-val-cex = ? then 
                                        assign de-conv-val-cex = cotacao-item-cex.val-desp.
                                end.

                                FOR FIRST desp-imp NO-LOCK
                                    WHERE desp-imp.cod-desp = desp-embarque.cod-desp : END.

                                if desp-imp.tipo = 1 then /* valor fixo */
                                    assign desp-embarque.val-desp = de-conv-val-cex.
                                else
                                    assign desp-embarque.val-desp = desp-embarque.val-desp + 
                                                                   (de-conv-val-cex * de-quant-parcela).
                            END.
                        END.
                    END.
                END.
            END.
        END.
        IF VALID-HANDLE(h-boin274) THEN DO:
            DELETE PROCEDURE h-boin274.
            ASSIGN h-boin274 = ?.
        END.
    END.
END.

RELEASE desp-embarque.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-despesas-di DBOProgram 
PROCEDURE pi-elimina-despesas-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT VALID-HANDLE(h-bocx406) THEN
    RUN cxbo/bocx406.p PERSISTENT SET h-bocx406.

RUN setConstraintByDeclaImport IN h-bocx406 (INPUT RowObject.num-di-ems, INPUT RowObject.cdd-siscomex-dts).
RUN openQueryStatic            IN h-bocx406 (INPUT "ByDeclaImport":U).
RUN getBatchRecords            IN h-bocx406 (INPUT  ?,
                                             INPUT  ?,
                                             INPUT  99999,
                                             OUTPUT i-reg-retornados,
                                             OUTPUT TABLE tt-despes-decla-import).
IF CAN-FIND(FIRST tt-despes-decla-import) THEN
    FOR EACH tt-despes-decla-import:
        EMPTY TEMP-TABLE tt-despes-decla-import-aux.
        CREATE tt-despes-decla-import-aux.
        BUFFER-COPY tt-despes-decla-import TO tt-despes-decla-import-aux.

        RUN openQueryMain  IN h-bocx406.
        RUN emptyRowErrors IN h-bocx406.
        RUN emptyRowObject IN h-bocx406.
        RUN goToKey        IN h-bocx406 (INPUT tt-despes-decla-import-aux.num-di-ems,
                                         INPUT tt-despes-decla-import-aux.cdn-pto-control,
                                         INPUT tt-despes-decla-import-aux.cdn-despes,
                                         INPUT tt-despes-decla-import-aux.cdn-emit-despes,
                                         INPUT tt-despes-decla-import-aux.cdd-siscomex-dts).
        IF RETURN-VALUE = "OK" THEN DO:
            RUN deleteRecord IN h-bocx406.
            IF RETURN-VALUE = "NOK" THEN DO:
                IF VALID-HANDLE(h-bocx406) THEN DO:
                    DELETE PROCEDURE h-bocx406.
                    ASSIGN h-bocx406 = ?.
                END.
                RETURN "NOK":U.
            END.
        END.
        ELSE DO:
            IF VALID-HANDLE(h-bocx406) THEN DO:
                DELETE PROCEDURE h-bocx406.
                ASSIGN h-bocx406 = ?.
            END.
            RETURN "NOK":U.
        END.            


    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-historico-di DBOProgram 
PROCEDURE pi-elimina-historico-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT VALID-HANDLE(h-bocx384) THEN
    RUN cxbo/bocx384.p PERSISTENT SET h-bocx384.

RUN setConstraintByDeclaImport IN h-bocx384 (INPUT RowObject.num-di-ems, INPUT RowObject.cdd-siscomex-dts).
RUN openQueryStatic            IN h-bocx384 (INPUT "ByDeclaImport":U).
RUN getBatchRecords            IN h-bocx384 (INPUT  ?,
                                             INPUT  ?,
                                             INPUT  99999,
                                             OUTPUT i-reg-retornados,
                                             OUTPUT TABLE tt-decla-histor-di).
IF CAN-FIND(FIRST tt-decla-histor-di) THEN
    FOR EACH tt-decla-histor-di:
        EMPTY TEMP-TABLE tt-decla-histor-di-aux.
        CREATE tt-decla-histor-di-aux.
        BUFFER-COPY tt-decla-histor-di TO tt-decla-histor-di-aux.

        RUN openQueryMain  IN h-bocx384.
        RUN emptyRowErrors IN h-bocx384.
        RUN emptyRowObject IN h-bocx384.
        RUN goToKey        IN h-bocx384 (INPUT tt-decla-histor-di-aux.num-di-ems,
                                         INPUT tt-decla-histor-di-aux.num-seq,
                                         INPUT tt-decla-histor-di-aux.cdd-siscomex-dts).
        IF RETURN-VALUE = "OK" THEN DO:
            RUN deleteRecord IN h-bocx384.
            IF RETURN-VALUE = "NOK" THEN DO:
                IF VALID-HANDLE(h-bocx384) THEN DO:
                    DELETE PROCEDURE h-bocx384.
                    ASSIGN h-bocx384 = ?.                    
                END.
                RETURN "NOK":U.
            END.
                
        END.
        ELSE DO:
            IF VALID-HANDLE(h-bocx384) THEN DO:
                DELETE PROCEDURE h-bocx384.
                ASSIGN h-bocx384 = ?.
            END.
            RETURN "NOK":U.
        END.            
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-despesas DBOProgram 
PROCEDURE pi-gera-despesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pCodEmbarq LIKE historico-embarque.embarque    NO-UNDO.
DEF INPUT PARAM pCodEstab  LIKE historico-embarque.cod-estabel NO-UNDO.
DEF INPUT PARAM pNumDiEms  LIKE {&TABLENAME}.num-di-ems        NO-UNDO.
DEF INPUT PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

IF NOT VALID-HANDLE(h-bocx406) THEN
    RUN cxbo/bocx406.p PERSISTENT SET h-bocx406.
IF NOT VALID-HANDLE(h-bocx383a) THEN
    RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.

DEFINE VARIABLE i-cdn-pto-nacionaliz-histor AS INTEGER                        NO-UNDO.
DEFINE VARIABLE i-seq-nacionaliz            AS INTEGER                        NO-UNDO.
DEFINE VARIABLE i-seq-embarque              AS INTEGER                        NO-UNDO.
DEFINE VARIABLE de-valor-despesa            LIKE despes-decla-import.val-desp NO-UNDO.

RUN retorna-seq-ponto-nacionaliz (INPUT pCodEmbarq,
                                  INPUT pCodEstab   ,
                                  OUTPUT i-seq-nacionaliz).

RUN retorna-seq-ponto-embarque (INPUT pCodEmbarq,
                                INPUT pCodEstab,
                                OUTPUT i-seq-embarque).

RUN retorna-ponto-nacionalizacao (INPUT pCodEmbarq,
                                  INPUT pCodEstab,
                                  OUTPUT i-cdn-pto-nacionaliz-histor).

EMPTY TEMP-TABLE tt-despes-decla-import.

FOR EACH historico-embarque NO-LOCK
    WHERE historico-embarque.embarque    = pCodEmbarq 
    AND   historico-embarque.cod-estabel = pCodEstab,
    EACH desp-embarque NO-LOCK
    WHERE desp-embarque.cod-estabel   = historico-embarque.cod-estabel
    AND   desp-embarque.embarque      = historico-embarque.embarque
    AND   desp-embarque.cod-itiner    = historico-embarque.cod-itiner
    AND   desp-embarque.cod-pto-contr = historico-embarque.cod-pto-contr:

    IF NOT CAN-FIND(FIRST despes-decla-import
                    WHERE despes-decla-import.num-di-ems      = pNumDiEms
                    AND   despes-decla-import.cdn-despes      = desp-embarque.cod-desp
                    AND   despes-decla-import.cdd-siscomex-dts = pCddSiscomexDts) THEN DO: 

        IF NOT CAN-FIND(FIRST tt-despes-decla-import
                        WHERE tt-despes-decla-import.num-di-ems      = pNumDiEms
                        AND   tt-despes-decla-import.cdn-despes      = desp-embarque.cod-desp
                        AND   tt-despes-decla-import.cdd-siscomex-dts = pCddSiscomexDts)THEN DO:

            CREATE tt-despes-decla-import.
            ASSIGN tt-despes-decla-import.num-di-ems                = pNumDiEms
                   tt-despes-decla-import.cdn-pto-control           = i-cdn-pto-nacionaliz-histor /*nacionalizaá∆o*/
                   tt-despes-decla-import.cdd-siscomex-dts          = pCddSiscomexDts
                   tt-despes-decla-import.cdn-cond-pagto            = desp-embarque.cod-cond-pag
                   tt-despes-decla-import.cdn-despes                = desp-embarque.cod-desp
                   tt-despes-decla-import.cdn-emit-despes           = desp-embarque.cod-emitente-desp
                   tt-despes-decla-import.cdn-itiner                = desp-embarque.cod-itiner
                   tt-despes-decla-import.cdn-moeda                 = desp-embarque.mo-codigo
                   tt-despes-decla-import.cod-incoterm-rat          = desp-embarque.cod-incoterm-rat
                   tt-despes-decla-import.log-forma-preco-compra    = desp-embarque.log-forma-preco-compra
                   tt-despes-decla-import.val-cotac-despes-compltar = 0
                   tt-despes-decla-import.val-despes                = desp-embarque.val-desp.
    
            /* Para que despesas que fazem parte de Incoterm, o LOG-FORMA-PRECO-COMPRA deve estar marcado */
            FOR FIRST embarque-imp NO-LOCK
                WHERE embarque-imp.cod-estabel = desp-embarque.cod-estabel
                AND   embarque-imp.embarque    = desp-embarque.embarque,
                FIRST inco-cx NO-LOCK
                WHERE inco-cx.cod-incoterm = embarque-imp.cod-incoterm :
                
                IF  CAN-FIND(FIRST desp-incoterm
                             WHERE desp-incoterm.cod-incoterm = inco-cx.cod-incoterm
                             AND   desp-incoterm.cod-desp     = desp-embarque.cod-desp) 
                THEN ASSIGN tt-despes-decla-import.log-forma-preco-compra = YES. 

            END. /* FOR FIRST embarque-imp NO-LOCK */
            
            IF  historico-embarque.sequencia <= i-seq-nacionaliz 
            THEN ASSIGN tt-despes-decla-import.idi-tip-incid-nf = 1.
            ELSE ASSIGN tt-despes-decla-import.idi-tip-incid-nf = 2.
            
            IF  historico-embarque.sequencia <= i-seq-embarque 
            THEN ASSIGN tt-despes-decla-import.log-incid-vmle = YES.
            ELSE ASSIGN tt-despes-decla-import.log-incid-vmle = NO.
        END. /* somar despesa da DI + despesa do embarque */
        ELSE DO:
            FOR FIRST tt-despes-decla-import
                WHERE tt-despes-decla-import.num-di-ems       = pNumDiEms
                AND   tt-despes-decla-import.cdn-despes       = desp-embarque.cod-desp
                AND   tt-despes-decla-import.cdd-siscomex-dts = pCddSiscomexDts:

                ASSIGN de-valor-despesa = desp-embarque.val-desp.
                IF desp-embarque.mo-codigo <> tt-despes-decla-import.cdn-moeda THEN DO:
                    FOR FIRST decla-import NO-LOCK
                        WHERE decla-import.num-di-ems = pNumDiEms
                          AND decla-import.cdd-siscomex-dts = pCddSiscomexDts:
                    END.
                    
                    IF AVAIL decla-import THEN DO:
                        
                        /*Convertendo a moeda da despesa do embarque para a mesma moeda da despesa da DI */
                        RUN converteValorMoeda IN h-bocx383a (INPUT pNumDiEms,
                                                              INPUT pCddSiscomexDts,
                                                              INPUT desp-embarque.mo-codigo,            /* moeda origem */
                                                              INPUT tt-despes-decla-import.cdn-moeda, /* moeda destino */
                                                              INPUT desp-embarque.val-desp,          /* valor que sera convertido */
                                                              INPUT decla-import.dat-di,              /* data da di para buscar a cotacao */
                                                              OUTPUT de-valor-despesa).               /* valor convertido */
                    END.
                END.
                ASSIGN tt-despes-decla-import.val-despes = tt-despes-decla-import.val-despes + de-valor-despesa.
            END.
        END.
    END. /* somar despesa da DI + despesa do embarque */
    ELSE DO:
        FOR FIRST despes-decla-import EXCLUSIVE-LOCK
            WHERE despes-decla-import.num-di-ems       = pNumDiEms
            AND   despes-decla-import.cdn-despes       = desp-embarque.cod-desp
            AND   despes-decla-import.cdd-siscomex-dts = pCddSiscomexDts:

            ASSIGN de-valor-despesa = desp-embarque.val-desp.
            IF desp-embarque.mo-codigo <> despes-decla-import.cdn-moeda THEN DO:
                FOR FIRST decla-import NO-LOCK
                        WHERE decla-import.num-di-ems = pNumDiEms
                          AND decla-import.cdd-siscomex-dts = pCddSiscomexDts:
                END.
                
                IF AVAIL decla-import THEN DO:
                    /*Convertendo a moeda da despesa do embarque para a mesma moeda da despesa da DI */
                    RUN converteValorMoeda IN h-bocx383a (INPUT pNumDiEms,
                                                          INPUT pCddSiscomexDts,
                                                          INPUT desp-embarque.mo-codigo,         /* moeda origem */
                                                          INPUT despes-decla-import.cdn-moeda, /* moeda destino */
                                                          INPUT desp-embarque.val-desp,          /* valor que sera convertido */
                                                          INPUT decla-import.dat-di,           /* data da di para buscar a cotacao */
                                                          OUTPUT de-valor-despesa).            /* valor convertido */
                END.
            END.
            
            ASSIGN despes-decla-import.val-despes = despes-decla-import.val-despes + de-valor-despesa.
        END.
    END.
END.

IF CAN-FIND(FIRST tt-despes-decla-import) THEN DO:
    FOR EACH tt-despes-decla-import:
        EMPTY TEMP-TABLE tt-despes-decla-import-aux.
        CREATE tt-despes-decla-import-aux.
        BUFFER-COPY tt-despes-decla-import TO tt-despes-decla-import-aux.

        RUN emptyRowObject  IN h-bocx406.
        RUN openQueryStatic IN h-bocx406 (INPUT "Main":U).
        RUN emptyRowErrors  IN h-bocx406.
        RUN salvaPontoControle IN h-bocx406 (INPUT tt-despes-decla-import-aux.idi-tip-incid-nf,
                                             INPUT tt-despes-decla-import-aux.num-di-ems,
                                             INPUT tt-despes-decla-import-aux.cdd-siscomex-dts,
                                             OUTPUT tt-despes-decla-import-aux.cdn-pto-control).
        RUN goToKey         IN h-bocx406 (INPUT tt-despes-decla-import-aux.num-di-ems,
                                          INPUT tt-despes-decla-import.cdn-pto-control,
                                          INPUT tt-despes-decla-import-aux.cdn-despes,
                                          INPUT tt-despes-decla-import.cdn-emit-despes,
                                          INPUT tt-despes-decla-import.cdd-siscomex-dts).
        IF RETURN-VALUE = "NOK" THEN DO:
            RUN setRecord       IN h-bocx406 (INPUT TABLE tt-despes-decla-import-aux).
            RUN setaTipoGeracao IN h-bocx406 (INPUT YES).
            RUN createRecord    IN h-bocx406.
            RUN getRowErrors    IN h-bocx406 (OUTPUT TABLE RowErrors APPEND).
        END.
    END.
END.

IF VALID-HANDLE(h-bocx383a) THEN DO:
    DELETE PROCEDURE h-bocx383a.
    ASSIGN h-bocx383a = ?.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-pontos-controle DBOProgram 
PROCEDURE pi-gera-pontos-controle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pCodEmbarq LIKE historico-embarque.embarque    NO-UNDO.
DEF INPUT PARAM pCodEstab  LIKE historico-embarque.cod-estabel NO-UNDO.
DEF INPUT PARAM pNumDiEms  LIKE {&TABLENAME}.num-di-ems        NO-UNDO.
DEF INPUT PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cdn-pto-nacionaliz-histor AS INTEGER     NO-UNDO.

IF NOT VALID-HANDLE(h-bocx384) THEN
    RUN cxbo/bocx384.p PERSISTENT SET h-bocx384.

ASSIGN i-seq = 0
       i-cdn-pto-nacionaliz-histor = 0.

RUN retorna-seq-ponto-nacionaliz (INPUT pCodEmbarq,
                                  INPUT pCodEstab   ,
                                  OUTPUT i-seq).

RUN retorna-ponto-nacionalizacao (INPUT pCodEmbarq,
                                  INPUT pCodEstab,
                                  OUTPUT i-cdn-pto-nacionaliz-histor).

EMPTY TEMP-TABLE tt-decla-histor-di.

RUN setAddAll IN h-bocx384 (INPUT YES).

FOR EACH historico-embarque
    WHERE historico-embarque.embarque    = pCodEmbarq 
    AND   historico-embarque.cod-estabel = pCodEstab    
    AND historico-embarque.sequencia    >= i-seq NO-LOCK:

    IF NOT CAN-FIND(FIRST histor-decla-import
                    WHERE histor-decla-import.num-di-ems      = pNumDiEms
                    AND   histor-decla-import.cdn-pto-control = historico-embarque.cod-pto-contr
                    AND   histor-decla-import.cdd-siscomex-dts = pCddSiscomexDts) THEN DO:

        FIND LAST histor-decla-import
            WHERE histor-decla-import.num-di-ems = pNumDiEms 
              AND histor-decla-import.cdd-siscomex-dts = pCddSiscomexDts NO-LOCK NO-ERROR.
        IF AVAIL histor-decla-import THEN
            ASSIGN i-seq = histor-decla-import.num-seq + 10.
        ELSE
            ASSIGN i-seq = 10.

        IF CAN-FIND(FIRST tt-decla-histor-di
                    WHERE tt-decla-histor-di.num-di-ems = pNumDiEms
                      AND tt-decla-histor-di.cdd-siscomex-dts = pCddSiscomexDts) THEN DO:

            FIND LAST tt-decla-histor-di
                WHERE tt-decla-histor-di.num-di-ems = pNumDiEms 
                AND tt-decla-histor-di.cdd-siscomex-dts = pCddSiscomexDts NO-LOCK NO-ERROR.
            IF AVAIL tt-decla-histor-di THEN
                ASSIGN i-seq = tt-decla-histor-di.num-seq + 10.
            ELSE DO:
                ASSIGN i-seq = i-seq + 10.
            END.
        END.

        IF NOT CAN-FIND(FIRST tt-decla-histor-di
                        WHERE tt-decla-histor-di.num-di-ems = pNumDiEms
                        AND   tt-decla-histor-di.num-seq    = i-seq
                        AND   tt-decla-histor-di.cdd-siscomex-dts = pCddSiscomexDts) THEN DO:
            CREATE tt-decla-histor-di.
            ASSIGN tt-decla-histor-di.num-di-ems          = pNumDiEms
                   tt-decla-histor-di.num-seq             = i-seq
                   tt-decla-histor-di.cdn-pto-control     = historico-embarque.cod-pto-contr
                   tt-decla-histor-di.cdn-pto-nacionaliz  = i-cdn-pto-nacionaliz-histor                 
                   tt-decla-histor-di.cdd-siscomex-dts    = pCddSiscomexDts
                   tt-decla-histor-di.cod-meio-transp     = historico-embarque.id-meio-transp
                   tt-decla-histor-di.dat-efetiva         = ?
                   tt-decla-histor-di.dat-prev-origin     = historico-embarque.dt-previsao
                   tt-decla-histor-di.dsl-obs             = historico-embarque.observacao.

        END.
    END.
END.

IF CAN-FIND(FIRST tt-decla-histor-di) THEN DO:

    FOR EACH tt-decla-histor-di:
        EMPTY TEMP-TABLE tt-decla-histor-di-aux.
        CREATE tt-decla-histor-di-aux.
        BUFFER-COPY tt-decla-histor-di TO tt-decla-histor-di-aux.

        RUN emptyRowObject  IN h-bocx384.
        RUN openQueryStatic IN h-bocx384 (INPUT "Main":U).
        RUN emptyRowErrors  IN h-bocx384.
        RUN setRecord       IN h-bocx384 (INPUT TABLE tt-decla-histor-di-aux).
        RUN createRecord    IN h-bocx384.
        IF RETURN-VALUE = "NOK" THEN DO:
            RUN getRowErrors  IN h-bocx384 (OUTPUT TABLE RowErrors APPEND).
            RETURN "NOK":U.
        END.       
    END.
END. 

RUN setAddAll IN h-bocx384 (INPUT NO).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-remove-relacionamentos-embarq DBOProgram 
PROCEDURE pi-remove-relacionamentos-embarq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pCodEmbarq LIKE {&TABLENAME}.cod-embarq NO-UNDO.
DEF INPUT  PARAM pCodEstab  LIKE {&TABLENAME}.cod-estab  NO-UNDO.
DEF INPUT  PARAM pNumDiEms  LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT  PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

IF NOT VALID-HANDLE(h-bocx403) THEN DO:
    RUN cxbo/bocx403.p  PERSISTENT SET h-bocx403.
    RUN openQueryStatic IN h-bocx403 (INPUT 'Main':U).
END.

IF NOT VALID-HANDLE(h-bocx404) THEN DO:
    RUN cxbo/bocx404.p  PERSISTENT SET h-bocx404.
    RUN openQueryStatic IN h-bocx404 (INPUT 'Main':U).
END.

EMPTY TEMP-TABLE tt-decla-imp-adic.
EMPTY TEMP-TABLE tt-decla-import-ord.
EMPTY TEMP-TABLE RowErrors.

/*ELIMINANDO ADIÄÂES*/
RUN retorna-adicoes-embarq IN h-bocx403(INPUT pCodEmbarq, 
                                        INPUT pCodEstab , 
                                        INPUT pNumDiEms ,
                                        INPUT pCddSiscomexDts,
                                        OUTPUT TABLE tt-decla-imp-adic).
FOR EACH tt-decla-imp-adic:
    EMPTY TEMP-TABLE tt-decla-imp-adic-aux.
    CREATE tt-decla-imp-adic-aux.
    BUFFER-COPY tt-decla-imp-adic TO tt-decla-imp-adic-aux.
    RUN openQueryStatic IN h-bocx403(INPUT 'Main':U).
    RUN emptyRowErrors  IN h-bocx403.
    RUN emptyRowObject  IN h-bocx403.    
    RUN goToKey         IN h-bocx403 (INPUT tt-decla-imp-adic-aux.num-di-ems,
                                      INPUT tt-decla-imp-adic-aux.num-adic,
                                      INPUT tt-decla-imp-adic-aux.cdd-siscomex-dts).
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN deleteRecord    IN h-bocx403.
        RUN getRowErrors    IN h-bocx403(OUTPUT TABLE RowErrors APPEND).
    END.
END.

IF VALID-HANDLE(h-bocx403) THEN DO:
    DELETE PROCEDURE h-bocx403.
    ASSIGN h-bocx403 = ?.
END.
/*FIM ELIMINANDO ADIÄÂES*/

/*ELIMINANDO ORDENS*/
RUN retorna-ordens-embarq IN h-bocx404(INPUT pCodEmbarq, 
                                       INPUT pCodEstab , 
                                       INPUT pNumDiEms ,
                                       INPUT pCddSiscomexDts,
                                       OUTPUT TABLE tt-decla-import-ord).
FOR EACH tt-decla-import-ord:
    EMPTY TEMP-TABLE tt-decla-import-ord-aux.
    CREATE tt-decla-import-ord-aux.
    BUFFER-COPY tt-decla-import-ord TO tt-decla-import-ord-aux.
    RUN openQueryStatic IN h-bocx404(INPUT 'Main':U).
    RUN emptyRowErrors  IN h-bocx404.
    RUN emptyRowObject  IN h-bocx404.
    RUN goToKey         IN h-bocx404 (INPUT tt-decla-import-ord-aux.num-di-ems,
                                      INPUT tt-decla-import-ord-aux.num-ordem,
                                      INPUT tt-decla-import-ord-aux.num-parcela,
                                      INPUT tt-decla-import-ord-aux.cdd-siscomex-dts).
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN deleteRecord    IN h-bocx404.
        RUN getRowErrors    IN h-bocx404(OUTPUT TABLE RowErrors APPEND).    
    END.


    IF l-nt2024002 THEN DO:
        IF NOT VALID-HANDLE(h-bocx00507) THEN
            RUN cxbo/bocx00507.p PERSISTENT SET h-bocx00507.
            
        RUN piDeleteRegistro IN h-bocx00507 (INPUT tt-decla-import-ord-aux.num-di-ems,
                                             INPUT tt-decla-import-ord-aux.num-ordem,
                                             INPUT tt-decla-import-ord-aux.num-parcela,
                                             INPUT tt-decla-import-ord-aux.cdd-siscomex-dts). 
                                             
        IF VALID-HANDLE(h-bocx00507) THEN DO:
            DELETE PROCEDURE h-bocx00507.
            ASSIGN h-bocx00507 = ?.
        END.
    END.
    
END.

IF VALID-HANDLE(h-bocx404) THEN DO:
    DELETE PROCEDURE h-bocx404.
    ASSIGN h-bocx404 = ?.
END.
/*FIM ELIMINANDO ORDENS*/ 

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-save-siscoserv DBOProgram 
PROCEDURE pi-save-siscoserv :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para salvar os dados na tabela decla-import-siscoserv
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT VALID-HANDLE(h-cdapi050) THEN
        RUN cdp/cdapi050.p PERSISTENT SET h-cdapi050.

    RUN pi-siscoserv-ativo IN h-cdapi050.
    IF RETURN-VALUE = "OK":U THEN DO:
        /*Busca a data da DI pelo n£mero da DI no EMS*/
        FOR LAST decla-import FIELDS(dat-di)
            WHERE decla-import.num-di-ems   = rowObject.num-di-ems 
              AND decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts NO-LOCK:


            ASSIGN l-ord-compra  = FALSE
                   l-desp-import = FALSE.

            FOR EACH ordens-embarque FIELDS(numero-ordem) NO-LOCK
                WHERE ordens-embarque.embarque    = rowObject.cod-embarq
                AND   ordens-embarque.cod-estabel = rowObject.cod-estab:

                IF NOT l-ord-compra THEN DO:                
                    FIND FIRST ord-compra-siscoserv
                        WHERE ord-compra-siscoserv.numero-ordem = ordens-embarque.numero-ordem
                        AND   ord-compra-siscoserv.cod-estabel  = rowObject.cod-estab NO-LOCK NO-ERROR.
                    IF AVAIL ord-compra-siscoserv THEN DO:
                        ASSIGN l-ord-compra  = TRUE.
                        RUN pi-grava-decla-import-sis IN h-cdapi050 (INPUT rowObject.cod-estab,
                                                                     INPUT rowObject.cod-embarq,
                                                                     INPUT rowObject.num-di-ems,
                                                                     INPUT decla-import.dat-di,
                                                                     INPUT decla-import.cdd-siscomex-dts).
                    END. /*AVAIL ord-compra-siscoserv*/
                END. /*l-ord-compra*/

                IF NOT l-desp-import THEN DO:
                    FIND FIRST despes-import-siscoserv
                        WHERE despes-import-siscoserv.cod-estabel = rowObject.cod-estab
                        AND   despes-import-siscoserv.embarque    = rowObject.cod-embarq NO-LOCK NO-ERROR.
                    IF AVAIL despes-import-siscoserv THEN DO:
                        ASSIGN l-desp-import  = TRUE.
                        RUN pi-grava-decla-import-sis IN h-cdapi050 (INPUT rowObject.cod-estab,
                                                                     INPUT rowObject.cod-embarq,
                                                                     INPUT rowObject.num-di-ems,
                                                                     INPUT decla-import.dat-di,
                                                                     INPUT decla-import.cdd-siscomex-dts).
                    END. /*AVAIL despes-import-siscoserv*/
                END. /*l-desp-import*/
                IF l-desp-import AND l-ord-compra THEN /*Se encontrou um registro de cada (ordem e despesa) n∆o precisa mais incluir na decla-import-siscoserv*/
                    LEAVE.
            END. /*FOR EACH ordens-compra*/
        END. /*FOR LAST decla-import*/
    END. /*RETURN OK*/
        
    IF VALID-HANDLE(h-cdapi050) THEN DO:
        DELETE PROCEDURE h-cdapi050.
        ASSIGN h-cdapi050 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-embarques-di DBOProgram 
PROCEDURE pi-valida-embarques-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pNumDiEms LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT  PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
DEF OUTPUT PARAM pRetorno  AS LOGICAL                   NO-UNDO.

IF CAN-FIND(FIRST {&TABLENAME}
            WHERE {&TABLENAME}.num-di-ems = pNumDiEms
              AND {&TABLENAME}.cdd-siscomex-dts = pCddSiscomexDts) THEN
    ASSIGN pRetorno = YES.
ELSE 
    ASSIGN pRetorno = NO.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-inclusao-despesa-integr-di DBOProgram 
PROCEDURE pi-valida-inclusao-despesa-integr-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pEmbarque   LIKE embarque-imp.embarque            NO-UNDO.
    DEF INPUT  PARAM pEstab      LIKE embarque-imp.cod-estabel         NO-UNDO.
    DEF INPUT  PARAM pPtoControl LIKE historico-embarque.cod-pto-contr NO-UNDO.
    DEF OUTPUT PARAM pIntegra    AS   LOGICAL                          NO-UNDO.

    DEFINE VARIABLE i-seq-nacionaliz AS INTEGER NO-UNDO.

    ASSIGN pIntegra = NO.

    RUN retorna-seq-ponto-nacionaliz (INPUT pEmbarque,
                                      INPUT pEstab,
                                      OUTPUT i-seq-nacionaliz).

    FOR FIRST historico-embarque NO-LOCK
        WHERE historico-embarque.cod-estabel   = pEstab
        AND   historico-embarque.embarque      = pEmbarque
        AND   historico-embarque.cod-pto-contr = pPtoControl:
        
        IF historico-embarque.sequencia <= i-seq-nacionaliz THEN DO:
            IF CAN-FIND(FIRST decla-import-embarq
                        WHERE decla-import-embarq.cod-embarq = pEmbarque
                        AND   decla-import-embarq.cod-estab  = pEstab) THEN
                ASSIGN pIntegra = YES.
            ELSE 
                ASSIGN pIntegra = NO.
        END.            
        ELSE
            ASSIGN pIntegra = NO.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-integracao-di DBOProgram 
PROCEDURE pi-valida-integracao-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pEmbarque LIKE decla-import-embarq.cod-embarq NO-UNDO.
DEF INPUT  PARAM pEstab    LIKE decla-import-embarq.cod-estab  NO-UNDO.
DEF OUTPUT PARAM pRetorno  AS LOGICAL                          NO-UNDO.

IF NOT CAN-FIND(FIRST decla-import-embarq
                WHERE decla-import-embarq.cod-estab  = pEstab
                AND   decla-import-embarq.cod-embarq = pEmbarque) THEN
    ASSIGN pRetorno = NO.        
ELSE DO:
    ASSIGN pRetorno = YES.
END.    

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-all-desp-histor-di DBOProgram 
PROCEDURE pi-verifica-all-desp-histor-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pNumDiEms LIKE RowObject.num-di-ems NO-UNDO.
DEF INPUT  PARAM pEmbarque LIKE embarque-imp.embarque    NO-UNDO.
DEF INPUT  PARAM pEstab    LIKE embarque-imp.cod-estabel NO-UNDO.
DEF INPUT  PARAM pCddSiscomexDts LIKE RowObject.cdd-siscomex-dts NO-UNDO.
DEF OUTPUT PARAM pRetorno  AS LOGICAL                NO-UNDO.

RUN pi-verifica-pontos-controle-di (INPUT pNumDiEms ,
                                    INPUT pEmbarque ,
                                    INPUT pEstab    ,
                                    INPUT pCddSiscomexDts,
                                    OUTPUT pRetorno).

IF pRetorno THEN
    RUN pi-verifica-despesas-di (INPUT pNumDiEms ,
                                 INPUT pEmbarque ,
                                 INPUT pEstab    ,
                                 INPUT pCddSiscomexDts,
                                 OUTPUT pRetorno).



RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-despesas-di DBOProgram 
PROCEDURE pi-verifica-despesas-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pNumDiEms LIKE RowObject.num-di-ems     NO-UNDO.
DEF INPUT  PARAM pEmbarque LIKE embarque-imp.embarque    NO-UNDO.
DEF INPUT  PARAM pEstab    LIKE embarque-imp.cod-estabel NO-UNDO.
DEF INPUT  PARAM pCddSiscomexDts LIKE RowObject.cdd-siscomex-dts NO-UNDO.
DEF OUTPUT PARAM pRetorno  AS LOGICAL                    NO-UNDO.
    
ASSIGN pRetorno = YES.
IF CAN-FIND(FIRST bf{&TABLENAME}
            WHERE bf{&TABLENAME}.num-di-ems = pNumDiEms
            AND bf{&TABLENAME}.cdd-siscomex-dts = pCddSiscomexDts ) THEN 
    FOR EACH historico-embarque NO-LOCK
        WHERE historico-embarque.embarque    = pEmbarque 
        AND   historico-embarque.cod-estabel = pEstab,
        EACH desp-embarque NO-LOCK
        WHERE desp-embarque.cod-estabel   = historico-embarque.cod-estabel
        AND   desp-embarque.embarque      = historico-embarque.embarque
        AND   desp-embarque.cod-itiner    = historico-embarque.cod-itiner
        AND   desp-embarque.cod-pto-contr = historico-embarque.cod-pto-contr:

        IF NOT CAN-FIND(FIRST despes-decla-import
                        WHERE despes-decla-import.num-di-ems = pNumDiEms
                        AND   despes-decla-import.cdn-despes = desp-embarque.cod-desp
                        AND   despes-decla-import.cdd-siscomex-dts = pCddSiscomexDts) THEN
            ASSIGN pRetorno = NO.

    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-pontos-controle-di DBOProgram 
PROCEDURE pi-verifica-pontos-controle-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pNumDiEms LIKE RowObject.num-di-ems NO-UNDO.
DEF INPUT  PARAM pEmbarque LIKE embarque-imp.embarque    NO-UNDO.
DEF INPUT  PARAM pEstab    LIKE embarque-imp.cod-estabel NO-UNDO.
DEF INPUT  PARAM pCddSiscomexDts LIKE RowObject.cdd-siscomex-dts NO-UNDO.
DEF OUTPUT PARAM pRetorno  AS LOGICAL                NO-UNDO.

DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.

ASSIGN i-seq = 0.

RUN retorna-seq-ponto-nacionaliz(INPUT pEmbarque,
                                 INPUT pEstab   ,
                                 OUTPUT i-seq).

ASSIGN pRetorno = YES.

IF NOT CAN-FIND(FIRST histor-decla-import
                WHERE histor-decla-import.num-di-ems      = pNumDiEms
                  AND histor-decla-import.cdd-siscomex-dts = pCddSiscomexDts) THEN
    ASSIGN pRetorno = YES.
ELSE DO:
    FOR EACH historico-embarque
        WHERE historico-embarque.embarque    = pEmbarque 
        AND   historico-embarque.cod-estabel = pEstab    NO-LOCK:
        IF historico-embarque.sequencia <= i-seq THEN
            NEXT.
            
        IF NOT CAN-FIND(FIRST histor-decla-import
                        WHERE histor-decla-import.num-di-ems      = pNumDiEms
                        AND   histor-decla-import.cdn-pto-control = historico-embarque.cod-pto-contr
                        AND   histor-decla-import.cdd-siscomex-dts = pCddSiscomexDts) THEN
            ASSIGN pRetorno = NO.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-pontos-de-controle DBOProgram 
PROCEDURE pi-verifica-pontos-de-controle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pNumDiEms LIKE RowObject.num-di-ems NO-UNDO.
DEF INPUT  PARAM pEmbarque LIKE embarque-imp.embarque    NO-UNDO.
DEF INPUT  PARAM pEstab    LIKE embarque-imp.cod-estabel NO-UNDO.
DEF INPUT  PARAM pCddSiscomexDts LIKE RowObject.cdd-siscomex-dts NO-UNDO.
DEF OUTPUT PARAM pRetorno  AS LOGICAL                NO-UNDO.

IF NOT CAN-FIND(FIRST histor-decla-import
                WHERE histor-decla-import.num-di-ems = pNumDiEms
                  AND histor-decla-import.cdd-siscomex-dts = pCddSiscomexDts) THEN DO:

    ASSIGN pRetorno = YES.
    RETURN "OK":U.

END.
    
IF CAN-FIND (FIRST decla-import-embarq
             WHERE decla-import-embarq.num-di-ems = pNumDiEms
               AND decla-import-embarq.cdd-siscomex-dts = pCddSiscomexDts) THEN DO:

    FOR FIRST bf{&TABLENAME} NO-LOCK
        WHERE bf{&TABLENAME}.num-di-ems = pNumDiEms
          AND bf{&TABLENAME}.cdd-siscomex-dts = pCddSiscomexDts:

        EMPTY TEMP-TABLE tt-embarque-imp.

        IF NOT VALID-HANDLE(h-bocx220na) THEN
            RUN cxbo/bocx220na.p PERSISTENT SET h-bocx220na.

        RUN openQueryStatic IN h-bocx220na (INPUT "Main":U).
        RUN goToKey         IN h-bocx220na (INPUT bf{&TABLENAME}.cod-estab ,
                                            INPUT bf{&TABLENAME}.cod-embarq). 

        IF RETURN-VALUE = "OK":U THEN
            RUN getRecord IN h-bocx220na (OUTPUT TABLE tt-embarque-imp).
            
    END.
    
    IF NOT VALID-HANDLE(h-bocx220) THEN
        RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.

    FOR 
        FIRST tt-embarque-imp: 

        RUN validaPontosControle (INPUT tt-embarque-imp.embarque,
                                  INPUT tt-embarque-imp.cod-estabel,
                                  INPUT pEmbarque,    
                                  INPUT pEstab,
                                  OUTPUT pRetorno).
    END.

END.
ELSE
    ASSIGN pRetorno = YES.

IF VALID-HANDLE(h-bocx220na) THEN 
    DELETE PROCEDURE h-bocx220na.
ASSIGN h-bocx220na = ?.
IF VALID-HANDLE(h-bocx220) THEN 
        DELETE PROCEDURE h-bocx220.
    ASSIGN h-bocx220 = ?.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-relacionamentos DBOProgram 
PROCEDURE pi-verifica-relacionamentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pNumDiEms  LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT  PARAM pCodEmbarq LIKE {&TABLENAME}.cod-embarq NO-UNDO.
DEF INPUT  PARAM pCodEstab  LIKE {&TABLENAME}.cod-estab  NO-UNDO.
DEF INPUT  PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
DEF OUTPUT PARAM pRetorno   AS LOGICAL                   NO-UNDO.

ASSIGN pRetorno = NO.

IF CAN-FIND(FIRST decla-import-adic-itens
            WHERE decla-import-adic-itens.num-di-ems = pNumDiEms  
            AND   decla-import-adic-itens.cod-embarq = pCodEmbarq 
            AND   decla-import-adic-itens.cod-estab  = pCodEstab  
            AND   decla-import-adic-itens.cdd-siscomex-dts = pCddSiscomexDts) THEN
    ASSIGN pRetorno = YES.

IF CAN-FIND(FIRST decla-import-ord
            WHERE decla-import-ord.num-di-ems = pNumDiEms   
            AND   decla-import-ord.cod-embarq = pCodEmbarq  
            AND   decla-import-ord.cod-estab  = pCodEstab  
            AND   decla-import-ord.cdd-siscomex-dts = pCddSiscomexDts) THEN
    ASSIGN pRetorno = YES.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zera-valores DBOProgram 
PROCEDURE pi-zera-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pnum-di-ems LIKE decla-import.num-di-ems NO-UNDO.
    DEF INPUT PARAM pcdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.
    
    
    
    /*--[ decla-import ]----------------------------------*/
    
    FOR EACH decla-import EXCLUSIVE-LOCK
        WHERE decla-import.num-di-ems = pnum-di-ems
          AND decla-import.cdd-siscomex-dts = pcdd-siscomex-dts:

        ASSIGN decla-import.val-acresc-me[1]        = 0
               decla-import.val-acresc-me[2]        = 0
               decla-import.val-acresc              = 0
               decla-import.val-frete               = 0
               decla-import.val-frete-me[1]         = 0
               decla-import.val-frete-me[2]         = 0
               decla-import.val-seguro              = 0
               decla-import.val-seguro-me[1]        = 0
               decla-import.val-seguro-me[2]        = 0
               decla-import.val-vmcv                = 0
               decla-import.val-vmcv-me[1]          = 0
               decla-import.val-vmcv-me[2]          = 0
               decla-import.val-vmld                = 0
               decla-import.val-vmld-me[1]          = 0
               decla-import.val-vmld-me[2]          = 0
               decla-import.val-vmle                = 0
               decla-import.val-vmle-me[1]          = 0
               decla-import.val-vmle-me[2]          = 0
               decla-import.val-base-cofins         = 0
               decla-import.val-base-icms           = 0
               decla-import.val-base-ii             = 0
               decla-import.val-base-ipi            = 0
               decla-import.val-base-pis            = 0
               decla-import.val-cofins-db-cr        = 0
               decla-import.val-cofins-nao-tributad = 0
               decla-import.val-cofins-outras       = 0
               decla-import.val-icms-db-cr          = 0
               decla-import.val-icms-nao-tributad   = 0
               decla-import.val-icms-outras         = 0
               decla-import.val-ii-db-cr            = 0
               decla-import.val-ii-nao-tribut       = 0
               decla-import.val-ii-outras           = 0
               decla-import.val-ipi-db-cr           = 0
               decla-import.val-ipi-nao-tributad    = 0
               decla-import.val-ipi-outras          = 0
               decla-import.val-pis-db-cr           = 0
               decla-import.val-pis-nao-tributad    = 0
               decla-import.val-pis-outras          = 0.

        /*--[ decla-import-adic ]----------------------------------*/
        IF CAN-FIND(FIRST decla-import-adic
                        WHERE decla-import-adic.num-di-ems = pnum-di-ems
                          AND decla-import-adic.cdd-siscomex-dts = pcdd-siscomex-dts) THEN DO:

            FOR EACH decla-import-adic EXCLUSIVE-LOCK
                WHERE decla-import-adic.num-di-ems = pnum-di-ems
                  AND decla-import-adic.cdd-siscomex-dts = pcdd-siscomex-dts:
    
                ASSIGN  decla-import-adic.val-acresc              = 0
                        decla-import-adic.val-acresc-me[1]        = 0
                        decla-import-adic.val-acresc-me[2]        = 0
                        decla-import-adic.val-base-cofins         = 0
                        decla-import-adic.val-base-icms           = 0
                        decla-import-adic.val-base-ii             = 0
                        decla-import-adic.val-base-ipi            = 0
                        decla-import-adic.val-base-pis            = 0
                        decla-import-adic.val-cofins-db-cr        = 0
                        decla-import-adic.val-cofins-nao-tributad = 0
                        decla-import-adic.val-cofins-outras       = 0
                        decla-import-adic.val-frete               = 0
                        decla-import-adic.val-frete-me[1]         = 0
                        decla-import-adic.val-frete-me[2]         = 0
                        decla-import-adic.val-icms-db-cr          = 0
                        decla-import-adic.val-icms-nao-tributad   = 0
                        decla-import-adic.val-icms-outras         = 0
                        decla-import-adic.val-ii-db-cr            = 0
                        decla-import-adic.val-ii-nao-tribut       = 0
                        decla-import-adic.val-ii-outras           = 0
                        decla-import-adic.val-ipi-db-cr           = 0
                        decla-import-adic.val-ipi-outras          = 0
                        decla-import-adic.val-ipi-nao-tributad    = 0
                        decla-import-adic.val-seguro              = 0
                        decla-import-adic.val-seguro-me[1]        = 0
                        decla-import-adic.val-seguro-me[2]        = 0
                        decla-import-adic.val-pis-outras          = 0
                        decla-import-adic.val-pis-nao-tributad    = 0
                        decla-import-adic.val-pis-db-cr           = 0
                        decla-import-adic.val-vmcv                = 0
                        decla-import-adic.val-vmcv-me[1]          = 0
                        decla-import-adic.val-vmcv-me[2]          = 0
                        decla-import-adic.val-vmld                = 0
                        decla-import-adic.val-vmld-me[1]          = 0
                        decla-import-adic.val-vmld-me[2]          = 0
                        decla-import-adic.val-vmle                = 0
                        decla-import-adic.val-vmle-me[1]          = 0
                        decla-import-adic.val-vmle-me[2]          = 0.
        
        
                /*--[ decla-import-adic-itens ]----------------------------------*/
                IF CAN-FIND(FIRST decla-import-adic-itens
                                WHERE decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
                                AND   decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
                                AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts) THEN DO:

                    FOR EACH decla-import-adic-itens EXCLUSIVE-LOCK
                        WHERE decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems
                        AND   decla-import-adic-itens.num-adic   = decla-import-adic.num-adic
                        AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:
        
                        ASSIGN decla-import-adic-itens.val-acresc              = 0
                               decla-import-adic-itens.val-acresc-me[1]        = 0
                               decla-import-adic-itens.val-acresc-me[2]        = 0
                               decla-import-adic-itens.val-base-icms           = 0
                               decla-import-adic-itens.val-base-cofins         = 0
                               decla-import-adic-itens.val-base-ii             = 0
                               decla-import-adic-itens.val-base-ipi            = 0
                               decla-import-adic-itens.val-base-pis            = 0
                               decla-import-adic-itens.val-cofins-db-cr        = 0
                               decla-import-adic-itens.val-cofins-nao-tributad = 0 
                               decla-import-adic-itens.val-cofins-outras       = 0
                               decla-import-adic-itens.val-frete               = 0
                               decla-import-adic-itens.val-frete-me[1]         = 0
                               decla-import-adic-itens.val-frete-me[2]         = 0
                               decla-import-adic-itens.val-icms-db-cr          = 0
                               decla-import-adic-itens.val-icms-nao-tributad   = 0
                               decla-import-adic-itens.val-icms-outras         = 0
                               decla-import-adic-itens.val-ii-db-cr            = 0
                               decla-import-adic-itens.val-ii-nao-tribut       = 0
                               decla-import-adic-itens.val-ii-outras           = 0
                               decla-import-adic-itens.val-ipi-db-cr           = 0
                               decla-import-adic-itens.val-ipi-nao-tributad    = 0
                               decla-import-adic-itens.val-ipi-outras          = 0
                               decla-import-adic-itens.val-pis-db-cr           = 0
                               decla-import-adic-itens.val-pis-nao-tributad    = 0
                               decla-import-adic-itens.val-pis-outras          = 0
                               decla-import-adic-itens.val-seguro              = 0
                               decla-import-adic-itens.val-seguro-me[1]        = 0
                               decla-import-adic-itens.val-seguro-me[2]        = 0
                               decla-import-adic-itens.val-vmcv                = 0
                               decla-import-adic-itens.val-vmcv-me[1]          = 0
                               decla-import-adic-itens.val-vmcv-me[2]          = 0
                               decla-import-adic-itens.val-vmld                = 0
                               decla-import-adic-itens.val-vmld-me[1]          = 0
                               decla-import-adic-itens.val-vmld-me[2]          = 0
                               decla-import-adic-itens.val-vmle-me[1]          = 0
                               decla-import-adic-itens.val-vmle-me[2]          = 0
                               decla-import-adic-itens.val-vmle                = 0
                               decla-import-adic-itens.val-vucv                = 0
                               decla-import-adic-itens.val-vucv-me[1]          = 0
                               decla-import-adic-itens.val-vucv-me[2]          = 0.
                    END.
                    /*--[ decla-import-adic-itens ]----------------------------------*/
                END. /*if can-find(decla-import-adic-itens) */
            END.
            /*--[ decla-import-adic ]----------------------------------*/          
        END. /*if can-find(decla-import-adic( */
        IF l-nt2024002 THEN DO:
        
            FOR EACH decla-import-trib 
               WHERE decla-import-trib.num-di-ems       = decla-import.num-di-ems
                 AND decla-import-trib.cdd-siscomex-dts = decla-import.cdd-siscomex-dts EXCLUSIVE-LOCK:
                 
                IF decla-import-trib.cod-campo = "BASE":U
                OR decla-import-trib.cod-campo = "OUTROS":U 
                OR decla-import-trib.cod-campo = "VALOR":U 
                OR decla-import-trib.cod-campo = "VALOR-REG":U 
                OR decla-import-trib.cod-campo = "SUSPENSO":U THEN
                    ASSIGN decla-import-trib.cod-conteudo = "":U.
            END.
        END.
    END.
    /*--[ decla-import ]----------------------------------*/
    

    
    RELEASE decla-import.
    RELEASE decla-import-trib.
    RELEASE decla-import-adic.
    RELEASE decla-import-adic-trib.
    RELEASE decla-import-adic-itens.
    RELEASE decla-imp-adic-it-trib.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-campos-char-nacionalizacao DBOProgram 
PROCEDURE retorna-campos-char-nacionalizacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pEmbarque  LIKE embarque-imp.embarque        NO-UNDO.
    DEF INPUT  PARAM pEstab     LIKE embarque-imp.cod-estabel     NO-UNDO.
    DEF INPUT  PARAM pNomeCampo AS CHARACTER                      NO-UNDO.
    DEF OUTPUT PARAM pChar      AS CHARACTER                      NO-UNDO.
    
    IF NOT VALID-HANDLE(h-bocx230) THEN
       RUN cxbo/bocx230.p PERSISTENT SET h-bocx230.

    ASSIGN i-cod-itiner = 0
           c-return     = "".
    RUN findFirstEmbarque IN h-bocx230 (INPUT pEstab,
                                        INPUT pEmbarque,
                                        OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-bocx230 (INPUT 'cod-itiner',
                                      OUTPUT i-cod-itiner).
    ELSE
        ASSIGN i-cod-itiner = 0.

    RUN retorna-ponto-nacionalizacao (INPUT pEstab,   
                                      INPUT pEmbarque,
                                      OUTPUT i-pto-desembarque).

    ASSIGN c-return     = "".
    RUN findCh-itiner IN h-bocx230 (INPUT pEstab,
                                    INPUT pEmbarque,
                                    INPUT i-cod-itiner,
                                    INPUT i-pto-desembarque, /*ponto nacionalizaá∆o*/
                                    OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-bocx230 (INPUT pNomeCampo,
                                      OUTPUT pChar).
    ELSE
        ASSIGN pChar = "".

    DELETE PROCEDURE h-bocx230.
    ASSIGN h-bocx230 = ?.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-campos-date-nacionalizacao DBOProgram 
PROCEDURE retorna-campos-date-nacionalizacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pEmbarque  LIKE embarque-imp.embarque        NO-UNDO.
    DEF INPUT  PARAM pEstab     LIKE embarque-imp.cod-estabel     NO-UNDO.
    DEF INPUT  PARAM pNomeCampo AS CHARACTER                      NO-UNDO.
    DEF OUTPUT PARAM pDate      AS DATE                           NO-UNDO.
    
    IF NOT VALID-HANDLE(h-bocx230) THEN
       RUN cxbo/bocx230.p PERSISTENT SET h-bocx230.

    ASSIGN i-cod-itiner = 0
           c-return     = "".
    RUN findFirstEmbarque IN h-bocx230 (INPUT pEstab,
                                        INPUT pEmbarque,
                                        OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-bocx230 (INPUT 'cod-itiner',
                                      OUTPUT i-cod-itiner).
    ELSE
        ASSIGN i-cod-itiner = 0.

    RUN retorna-ponto-nacionalizacao (INPUT pEstab,   
                                      INPUT pEmbarque,
                                      OUTPUT i-pto-desembarque).

    ASSIGN c-return     = "".
    RUN findCh-itiner IN h-bocx230 (INPUT pEstab,
                                    INPUT pEmbarque,
                                    INPUT i-cod-itiner,
                                    INPUT i-pto-desembarque, /*ponto nacionalizaá∆o*/
                                    OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-bocx230 (INPUT pNomeCampo,
                                      OUTPUT pDate).
    ELSE
        ASSIGN pDate = ?.

    DELETE PROCEDURE h-bocx230.
    ASSIGN h-bocx230 = ?.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-campos-int-nacionalizacao DBOProgram 
PROCEDURE retorna-campos-int-nacionalizacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pEmbarque  LIKE embarque-imp.embarque        NO-UNDO.
    DEF INPUT  PARAM pEstab     LIKE embarque-imp.cod-estabel     NO-UNDO.
    DEF INPUT  PARAM pNomeCampo AS CHARACTER                      NO-UNDO.
    DEF OUTPUT PARAM pSeq       AS INTEGER                        NO-UNDO.
    
    IF NOT VALID-HANDLE(h-bocx230) THEN
       RUN cxbo/bocx230.p PERSISTENT SET h-bocx230.

    ASSIGN i-cod-itiner = 0
           c-return     = "".
    RUN findFirstEmbarque IN h-bocx230 (INPUT pEstab,
                                        INPUT pEmbarque,
                                        OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-bocx230 (INPUT 'cod-itiner',
                                      OUTPUT i-cod-itiner).
    ELSE
        ASSIGN i-cod-itiner = 0.

    RUN retorna-ponto-nacionalizacao (INPUT pEstab,   
                                      INPUT pEmbarque,
                                      OUTPUT i-pto-desembarque).
    ASSIGN c-return     = "".
    RUN findCh-itiner IN h-bocx230 (INPUT pEstab,
                                    INPUT pEmbarque,
                                    INPUT i-cod-itiner,
                                    INPUT i-pto-desembarque, /*ponto nacionalizaá∆o*/
                                    OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-bocx230 (INPUT pNomeCampo,
                                      OUTPUT pSeq).
    ELSE
        ASSIGN pSeq = 0.

    DELETE PROCEDURE h-bocx230.
    ASSIGN h-bocx230 = ?.
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-ponto-chegada DBOProgram 
PROCEDURE retorna-ponto-chegada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pEmbarque  LIKE embarque-imp.embarque            NO-UNDO.
    DEF INPUT  PARAM pEstab     LIKE embarque-imp.cod-estabel         NO-UNDO.
    DEF OUTPUT PARAM pPtoCheg   LIKE historico-embarque.cod-pto-contr NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx220) THEN
        RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.
    
    RUN findPk_codigo IN h-bocx220(INPUT pEstab,
                                   INPUT pEmbarque,
                                   OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-bocx220(INPUT "cdn-pto-chegad":U, 
                                     OUTPUT pPtoCheg).
    ELSE
        ASSIGN pPtoCheg = 0.
    
    DELETE PROCEDURE h-bocx220.
    ASSIGN h-bocx220 = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-ponto-despacho DBOProgram 
PROCEDURE retorna-ponto-despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pEmbarque LIKE embarque-imp.embarque            NO-UNDO.
    DEF INPUT  PARAM pEstab    LIKE embarque-imp.cod-estabel         NO-UNDO.
    DEF OUTPUT PARAM pPtoDes   LIKE historico-embarque.cod-pto-contr NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx220) THEN
        RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.
    
    RUN findPk_codigo IN h-bocx220(INPUT pEstab,
                                   INPUT pEmbarque,
                                   OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-bocx220(INPUT "cdn-pto-despch":U, 
                                     OUTPUT pPtoDes).
    ELSE
        ASSIGN pPtoDes = 0.
    
    DELETE PROCEDURE h-bocx220.
    ASSIGN h-bocx220 = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-ponto-nacionalizacao DBOProgram 
PROCEDURE retorna-ponto-nacionalizacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pEmbarque LIKE embarque-imp.embarque            NO-UNDO.
    DEF INPUT  PARAM pEstab    LIKE embarque-imp.cod-estabel         NO-UNDO.
    DEF OUTPUT PARAM pPtoNac   LIKE historico-embarque.cod-pto-contr NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx220) THEN
        RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.
    
    RUN findPk_codigo IN h-bocx220(INPUT pEstab,
                                   INPUT pEmbarque,
                                   OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-bocx220(INPUT "cdn-pto-desembar":U, 
                                     OUTPUT pPtoNac).
    ELSE
        ASSIGN pPtoNac = 0.
    
    DELETE PROCEDURE h-bocx220.
    ASSIGN h-bocx220 = ?.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-seq-ponto-embarque DBOProgram 
PROCEDURE retorna-seq-ponto-embarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pEmbarque LIKE embarque-imp.embarque        NO-UNDO.
    DEF INPUT  PARAM pEstab    LIKE embarque-imp.cod-estabel     NO-UNDO.
    DEF OUTPUT PARAM pSeq      LIKE historico-embarque.sequencia NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx115) THEN
        RUN cxbo/bocx115.p PERSISTENT SET h-bocx115.
    
    IF NOT VALID-HANDLE(h-bocx230) THEN
       RUN cxbo/bocx230.p PERSISTENT SET h-bocx230.

    IF NOT VALID-HANDLE(h-bocx220) THEN
        RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.

    ASSIGN i-cod-itiner = 0
           c-return     = "".
    RUN findFirstEmbarque IN h-bocx230 (INPUT pEstab,
                                        INPUT pEmbarque,
                                        OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-bocx230 (INPUT 'cod-itiner',
                                      OUTPUT i-cod-itiner).
    ELSE
        ASSIGN i-cod-itiner = 0.

    ASSIGN i-pto-desembarque = 0
           c-return          = "".

    RUN findPk_codigo IN h-bocx220(INPUT pEstab,
                                   INPUT pEmbarque,
                                   OUTPUT c-return).
    IF c-return = "":U THEN
        RUN getIntField IN h-bocx220(INPUT "cdn-pto-desembar":U, 
                                     OUTPUT i-pto-desembarque).

    ASSIGN c-return     = "".
    RUN findCh-itiner IN h-bocx230 (INPUT pEstab,
                                    INPUT pEmbarque,
                                    INPUT i-cod-itiner,
                                    INPUT i-pto-desembarque, /*ponto nacionalizaá∆o*/
                                    OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-bocx230 (INPUT 'sequencia',
                                      OUTPUT pSeq).
    ELSE
        ASSIGN pSeq = 0.

    DELETE PROCEDURE h-bocx115.
    DELETE PROCEDURE h-bocx230.
    DELETE PROCEDURE h-bocx220.
    ASSIGN h-bocx115 = ?
           h-bocx230 = ?
           h-bocx220 = ?.
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-seq-ponto-nacionaliz DBOProgram 
PROCEDURE retorna-seq-ponto-nacionaliz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pEmbarque LIKE embarque-imp.embarque        NO-UNDO.
    DEF INPUT  PARAM pEstab    LIKE embarque-imp.cod-estabel     NO-UNDO.
    DEF OUTPUT PARAM pSeq      LIKE historico-embarque.sequencia NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx115) THEN
        RUN cxbo/bocx115.p PERSISTENT SET h-bocx115.
    
    IF NOT VALID-HANDLE(h-bocx230) THEN
       RUN cxbo/bocx230.p PERSISTENT SET h-bocx230.

    IF NOT VALID-HANDLE(h-bocx220) THEN
        RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.

    ASSIGN i-cod-itiner = 0
           c-return     = "".
    RUN findFirstEmbarque IN h-bocx230 (INPUT pEstab,
                                        INPUT pEmbarque,
                                        OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-bocx230 (INPUT 'cod-itiner',
                                      OUTPUT i-cod-itiner).
    ELSE
        ASSIGN i-cod-itiner = 0.

    RUN findPk_codigo IN h-bocx220(INPUT pEstab,
                                   INPUT pEmbarque,
                                   OUTPUT c-return).
    IF c-return = "":U THEN
        RUN getIntField IN h-bocx220(INPUT "cdn-pto-desembar":U, 
                                     OUTPUT i-pto-desembarque).

    ASSIGN c-return     = "".
    RUN findCh-itiner IN h-bocx230 (INPUT pEstab,
                                    INPUT pEmbarque,
                                    INPUT i-cod-itiner,
                                    INPUT i-pto-desembarque, /*ponto nacionalizaá∆o*/
                                    OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-bocx230 (INPUT 'sequencia',
                                      OUTPUT pSeq).
    ELSE
        ASSIGN pSeq = 0.

    DELETE PROCEDURE h-bocx115.
    DELETE PROCEDURE h-bocx230.
    DELETE PROCEDURE h-bocx220.
    ASSIGN h-bocx115 = ?
           h-bocx230 = ?
           h-bocx220 = ?.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaHistoricoEmbarque DBOProgram 
PROCEDURE retornaHistoricoEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM pcod-estabel LIKE historico-embarque.cod-estabel NO-UNDO.
    DEF INPUT  PARAM pembarque    LIKE historico-embarque.embarque    NO-UNDO.
    DEF INPUT  PARAM pcod-itiner  LIKE historico-embarque.cod-itiner  NO-UNDO.
    DEF INPUT  PARAM psequencia   LIKE historico-embarque.sequencia   NO-UNDO.
    DEF OUTPUT PARAM prow-table   AS ROWID NO-UNDO.

    FOR FIRST historico-embarque NO-LOCK
        WHERE historico-embarque.cod-estabel = pcod-estabel 
        AND   historico-embarque.embarque    = pembarque    
        AND   historico-embarque.cod-itiner  = pcod-itiner  
        AND   historico-embarque.sequencia   = psequencia:
        ASSIGN prow-table = ROWID(historico-embarque).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaNatOperacaoEmbarque DBOProgram 
PROCEDURE retornaNatOperacaoEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM p-num-di-ems   LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT  PARAM p-cod-estab    LIKE {&TABLENAME}.cod-estab  NO-UNDO.
DEF INPUT  PARAM p-cod-embarq   LIKE {&TABLENAME}.cod-embarq NO-UNDO.
DEF INPUT  PARAM p-cdd-siscomex-dts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
DEF OUTPUT PARAM p-nat-operacao LIKE natur-oper.nat-operacao NO-UNDO.

IF NOT CAN-FIND(FIRST decla-import-ord
                WHERE decla-import-ord.num-di-ems = p-num-di-ems   
                AND   decla-import-ord.cod-estab  = p-cod-estab   
                AND   decla-import-ord.cod-embarq = p-cod-embarq
                AND   decla-import-ord.cdd-siscomex-dts = p-cdd-siscomex-dts) THEN
    RETURN "NOK":U.

FOR FIRST decla-import-ord NO-LOCK
    WHERE decla-import-ord.num-di-ems  = p-num-di-ems
    AND   decla-import-ord.cod-estab  = p-cod-estab   
    AND   decla-import-ord.cod-embarq = p-cod-embarq  
    AND   decla-import-ord.cdd-siscomex-dts = p-cdd-siscomex-dts:
    ASSIGN p-nat-operacao = decla-import-ord.cod-natur-operac. 
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDI DBOProgram 
PROCEDURE setConstraintByDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNumDiEms LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

ASSIGN i-num-di-ems = pNumDiEms
       de-cdd-siscomex-dts = pCddSiscomexDts.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-efetivacao-nacionaliz DBOProgram 
PROCEDURE valida-efetivacao-nacionaliz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pNumDiEms LIKE decla-import.num-di-ems          NO-UNDO.
    DEF INPUT  PARAM pEmbarque LIKE embarque-imp.embarque            NO-UNDO.
    DEF INPUT  PARAM pEstab    LIKE embarque-imp.cod-estabel         NO-UNDO.
    DEF INPUT  PARAM pCddSiscomexDts LIKE decla-import.cdd-siscomex-dts NO-UNDO.
    DEF OUTPUT PARAM pEfetNac  LIKE historico-embarque.dt-efetiva    NO-UNDO.

    DEF VAR d-data-aux LIKE historico-embarque.dt-efetiva NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx220) THEN
        RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.
    
    IF NOT VALID-HANDLE(h-bocx230) THEN
       RUN cxbo/bocx230.p PERSISTENT SET h-bocx230.

    ASSIGN i-cod-itiner = 0
           i-pto-desembarque = 0
           c-return     = "".

    RUN findCh_embarque IN h-bocx220 (INPUT pEstab,     
                                      INPUT pEmbarque,  
                                      OUTPUT c-return). 
    if c-return = "" then 
        RUN getIntField in h-bocx220 (input "cdn-pto-desembar", output i-pto-desembarque).
    ELSE
        ASSIGN i-pto-desembarque = 0.

    ASSIGN c-return = "".
    RUN findFirstEmbarque IN h-bocx230 (INPUT pEstab,
                                        INPUT pEmbarque,
                                        OUTPUT c-return).
    IF c-return = "" THEN 
        RUN getIntField IN h-bocx230 (INPUT 'cod-itiner', OUTPUT i-cod-itiner).
    ELSE
        ASSIGN i-cod-itiner = 0.

    ASSIGN c-return = "".
    RUN findCh-itiner IN h-bocx230 (INPUT pEstab,
                                    INPUT pEmbarque,
                                    INPUT i-cod-itiner,
                                    INPUT i-pto-desembarque, /*ponto nacionalizaá∆o*/
                                    OUTPUT c-return).
    IF c-return = "" THEN
        RUN getDateField IN h-bocx230 (INPUT 'dt-efetiva',
                                       OUTPUT pEfetNac).
    ELSE
        ASSIGN pEfetNac = ?.

    FOR FIRST decla-import NO-LOCK
         WHERE decla-import.num-di-ems = pNumDiEms
           AND decla-import.cdd-siscomex-dts = pCddSiscomexDts:
    END.
    
    /*ASSIGN d-data-aux = ?.*/

    FOR FIRST histor-decla-import NO-LOCK
        WHERE histor-decla-import.num-di-ems = pNumDiEms
          AND histor-decla-import.cdn-pto-control = i-pto-desembarque
          AND histor-decla-import.cdd-siscomex-dts = pCddSiscomexDts:

       IF histor-decla-import.dat-efetiva <> ? THEN
           ASSIGN d-data-aux = histor-decla-import.dat-efetiva. /* data da nacionalizacao */
    END.

    /*---[ atualiza data nacionalizaá∆o embarque ]--------------------------------------------------------*/
    RUN pi-retora-tt-historico-embarque IN h-bocx230 (INPUT pEstab,
                                                     INPUT pEmbarque,
                                                     INPUT i-cod-itiner,
                                                     INPUT i-pto-desembarque,
                                                     OUTPUT TABLE tt-historico-embarque).

    FOR FIRST tt-historico-embarque:
        ASSIGN tt-historico-embarque.dt-efetiva = d-data-aux.
    END.

    IF CAN-FIND(FIRST historico-embarque NO-LOCK
                WHERE historico-embarque.cod-estabel   = pEstab 
                  AND historico-embarque.embarque      = pEmbarque) THEN DO:
    
        IF NOT CAN-FIND(FIRST tt-historico-embarque) THEN DO:

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-1-27100 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vinculaá∆o_do_embarque" *}
            ASSIGN c-lbl-liter-1-27100 = TRIM(RETURN-VALUE).

            DEFINE VARIABLE c-lbl-liter-2-27100 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "n∆o_permitida!" *}
            ASSIGN c-lbl-liter-2-27100 = TRIM(RETURN-VALUE).

            DEFINE VARIABLE c-lbl-liter-3-27100 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Hist¢rio_que_est†_no_embarque_difere_do_cadastro._Favor_verificar_o_cadastro_no_CD2567" *}
            ASSIGN c-lbl-liter-3-27100 = TRIM(RETURN-VALUE).

            {method/svc/errors/inserr.i
                   &ErrorNumber="27100"
                   &ErrorType="EMS"
                   &ErrorParameters="c-lbl-liter-1-27100 + string(pEmbarque) + ' ' + c-lbl-liter-2-27100 + '~~~~' + 
                                     c-lbl-liter-3-27100"}
            RETURN "NOK":U.
        END.
        ELSE DO:
            RUN validateUpdate IN h-bocx230(INPUT  TABLE tt-historico-embarque,
                                            INPUT  tt-historico-embarque.r-rowid,
                                            OUTPUT TABLE tt-bo-erro).
        END.
    END.

    IF CAN-FIND(tt-bo-erro) THEN DO:
         FOR EACH tt-bo-erro:
             CREATE RowErrors.
             ASSIGN RowErrors.ErrorSequence    = tt-bo-erro.i-sequen     
                    RowErrors.ErrorNumber      = tt-bo-erro.cd-erro      
                    RowErrors.ErrorDescription = tt-bo-erro.mensagem     
                    RowErrors.ErrorParameters  = tt-bo-erro.parametros   
                    RowErrors.ErrorType        = tt-bo-erro.errortype    
                    RowErrors.ErrorHelp        = tt-bo-erro.errorhelp    
                    RowErrors.ErrorSubType     = tt-bo-erro.errorsubtype.
         END.
    
         RETURN "NOK":U.
    END.

    /*---[ fim - atualiza data nacionalizaá∆o embarque ]--------------------------------------------------*/ 
   
    DELETE PROCEDURE h-bocx220.
    DELETE PROCEDURE h-bocx230.
    ASSIGN h-bocx220 = ?
           h-bocx230 = ?.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaPontosControle DBOProgram 
PROCEDURE validaPontosControle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pFirstEmbarque LIKE embarque-imp.embarque    NO-UNDO.
    DEF INPUT  PARAM pFirstEstab    LIKE embarque-imp.cod-estabel NO-UNDO.
    DEF INPUT  PARAM pEmbarque      LIKE embarque-imp.embarque    NO-UNDO.
    DEF INPUT  PARAM pEstab         LIKE embarque-imp.cod-estabel NO-UNDO.
    DEF OUTPUT PARAM pRetorno       AS LOGICAL                    NO-UNDO.
    
    DEFINE VARIABLE i-cdn-pto-nacionaliz-histor     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cdn-pto-chegada-histor        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cdn-pto-nacionaliz-emb-vincul AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cdn-pto-chegada-emb-vincul    AS INTEGER     NO-UNDO.

    RUN retorna-ponto-nacionalizacao(INPUT pFirstEmbarque,
                                     INPUT pFirstEstab,
                                     OUTPUT i-cdn-pto-nacionaliz-histor).

    RUN retorna-ponto-chegada       (INPUT pFirstEmbarque,
                                     INPUT pFirstEstab,
                                     OUTPUT i-cdn-pto-chegada-histor).

    RUN retorna-ponto-nacionalizacao(INPUT pEmbarque,
                                     INPUT pEstab,
                                     OUTPUT i-cdn-pto-nacionaliz-emb-vincul).

    RUN retorna-ponto-chegada       (INPUT pEmbarque,
                                     INPUT pEstab,
                                     OUTPUT i-cdn-pto-chegada-emb-vincul).

    IF i-cdn-pto-nacionaliz-histor = i-cdn-pto-nacionaliz-emb-vincul
        AND i-cdn-pto-chegada-histor = i-cdn-pto-chegada-emb-vincul THEN
        ASSIGN pRetorno = YES. /*PONTO DE NACIONALIZAÄ«O E PONTO DE EMBARQUE S«O IGUAIS*/
    ELSE
        ASSIGN pRetorno = NO. /*PONTO DE NACIONALIZAÄ«O E PONTO DE EMBARQUE N«O S«O IGUAIS*/

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaPontosControle DBOProgram 
PROCEDURE validaViaTransporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pEmbarque   LIKE embarque-imp.embarque          NO-UNDO.
    DEF INPUT  PARAM pEstab      LIKE embarque-imp.cod-estabel       NO-UNDO.
    DEF INPUT  PARAM pnum-di-ems LIKE decla-import-embarq.num-di-ems NO-UNDO.
    DEF INPUT  PARAM pCddSiscomexDts LIKE decla-import-embarq.cdd-siscomex-dts NO-UNDO.
    DEF OUTPUT PARAM pViaTransp  AS LOGICAL                          NO-UNDO.
    DEF OUTPUT PARAM pPrimerEmb  AS LOGICAL                          NO-UNDO.

    IF NOT CAN-FIND (FIRST decla-import-embarq
             WHERE decla-import-embarq.num-di-ems = pnum-di-ems
               AND decla-import-embarq.cdd-siscomex-dts = pCddSiscomexDts) THEN 
       ASSIGN pPrimerEmb = YES
              l-primeiro = YES.
    ELSE 
       ASSIGN pPrimerEmb = NO
              l-primeiro = NO.

    FOR FIRST embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel = pEstab 
        AND   embarque-imp.embarque    = pEmbarque:
        ASSIGN i-via-transp = embarque-imp.cod-via-transp.
    END.

    FOR FIRST decla-import NO-LOCK
        WHERE decla-import.num-di-ems = pnum-di-ems
          AND decla-import.cdd-siscomex-dts = pCddSiscomexDts:
    END.
    IF AVAIL decla-import THEN DO:
        IF i-via-transp <> decla-import.idi-via-transp-di THEN 
           ASSIGN pViaTransp = YES. /*VIA DE TRANSPORTE N«O S«O IGUAIS*/
        ELSE
            ASSIGN pViaTransp = NO. /*VIA DE TRANSPORTE S«O IGUAIS*/
    END.

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
    
    DEF VAR de-valor        LIKE cotacao-item.preco-unit        NO-UNDO.
    DEF VAR i-moeda         LIKE moeda.mo-codigo                NO-UNDO.
    DEF VAR de-valor-aux    LIKE cotacao-item.preco-unit        NO-UNDO.
    DEF VAR i-moeda-aux     LIKE moeda.mo-codigo                NO-UNDO.
    DEF VAR l-retorno1      AS LOGICAL INITIAL NO               NO-UNDO.
    DEF VAR l-retorno2      AS LOGICAL INITIAL NO               NO-UNDO.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF pType = "CREATE" 
        OR pType = "COPY" THEN DO:
        IF CAN-FIND (FIRST decla-import-embarq
                     WHERE decla-import-embarq.num-di-ems = RowObject.num-di-ems
                     AND   decla-import-embarq.cod-embarq = RowObject.cod-embarq
                     AND   decla-import-embarq.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-embarque-declaracao-importacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Embarque_Declaraá∆o_Importaá∆o" *}
            ASSIGN c-lbl-liter-embarque-declaracao-importacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                  &ErrorNumber="1"
                  &ErrorType="EMS"
                  &ErrorParameters="c-lbl-liter-embarque-declaracao-importacao"}
        END.
    END.

    IF pType = "CREATE" THEN DO:
        
        ASSIGN l-retorno1 = YES.
        RUN pi-verifica-pontos-de-controle (INPUT RowObject.num-di-ems,
                                            INPUT RowObject.cod-embarq,
                                            INPUT RowObject.cod-estab,
                                            INPUT RowObject.cdd-siscomex-dts,
                                            OUTPUT l-retorno1).


        IF NOT l-retorno1 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-ponto-de-nacionalizacao-eou-po AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ponto_de_Nacionalizaá∆o_e/ou_Ponto_de_Chegada_difere_da_Declaraá∆o_de_Importaá∆o" *}
            ASSIGN c-lbl-liter-ponto-de-nacionalizacao-eou-po = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                  &ErrorNumber="17006"
                  &ErrorType="EMS"
                  &ErrorParameters="c-lbl-liter-ponto-de-nacionalizacao-eou-po + '!' + '~~~~' + c-lbl-liter-ponto-de-nacionalizacao-eou-po + '!'"}                
        END. 

        ASSIGN l-retorno2 = YES.
        RUN pi-verifica-pontos-controle-di (INPUT RowObject.num-di-ems ,
                                            INPUT RowObject.cod-embarq ,
                                            INPUT RowObject.cod-estab    ,
                                            INPUT RowObject.cdd-siscomex-dts,
                                            OUTPUT l-retorno2).

        IF NOT l-retorno2 THEN 
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-existem-pontos-de-controle-no AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Existem_pontos_de_controle_no_embarque_que_n∆o_se_encontram_na_Declaraá∆o_de_Importaá∆o" *}
            ASSIGN c-lbl-liter-existem-pontos-de-controle-no = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-existem-pontos-de-controle-no-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Existem_pontos_de_controle_no_embarque_que_n∆o_se_encontram_na_Declaraá∆o_de_Importaá∆o!_Estes_n∆o_ser∆o_integrados_de_forma_autom†tica" *}
            ASSIGN c-lbl-liter-existem-pontos-de-controle-no-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                  &ErrorNumber="15825"
                  &ErrorType="EMS"
                  &ErrorParameters="c-lbl-liter-existem-pontos-de-controle-no + '!' + '~~~~' + c-lbl-liter-existem-pontos-de-controle-no-2 + '!'"}
        END. 

        IF CAN-FIND (FIRST decla-import-embarq
                     WHERE decla-import-embarq.num-di-ems = RowObject.num-di-ems
                       AND decla-import-embarq.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:
        
            FOR FIRST bf{&TABLENAME} NO-LOCK
                WHERE bf{&TABLENAME}.num-di-ems = RowObject.num-di-ems
                  AND bf{&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:

                EMPTY TEMP-TABLE tt-embarque-imp.

                FOR FIRST embarque-imp NO-LOCK
                    WHERE embarque-imp.cod-estabel = bf{&TABLENAME}.cod-estab 
                    AND   embarque-imp.embarque    = bf{&TABLENAME}.cod-embarq:
                    CREATE tt-embarque-imp.
                    BUFFER-COPY embarque-imp TO tt-embarque-imp.
                END.
            END.
            
            IF NOT VALID-HANDLE(h-bocx220) THEN
                RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.

            FOR FIRST embarque-imp NO-LOCK
                WHERE embarque-imp.cod-estabel = RowObject.cod-estab 
                AND   embarque-imp.embarque    = RowObject.cod-embarq:

                FOR FIRST tt-embarque-imp: END.

                /*INCOTERM*/
                IF embarque-imp.cod-incoterm <> tt-embarque-imp.cod-incoterm THEN
                    /* Inicio -- Projeto Internacional */
                    DO:
                    DEFINE VARIABLE c-lbl-liter-incoterm-difere-dos-embarques AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Incoterm_difere_dos_embarques_j†_vinculados" *}
                    ASSIGN c-lbl-liter-incoterm-difere-dos-embarques = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                          &ErrorNumber="52164"
                          &ErrorType="EMS"
                          &ErrorParameters="c-lbl-liter-incoterm-difere-dos-embarques + '.' + '~~~~' + STRING(tt-embarque-imp.embarque) + '~~~~' + STRING(RowObject.num-di-ems)"}
                    END. 
                /*FIM INCOTERM*/

                /*MOEDA*/
                ASSIGN de-valor     = 0
                       i-moeda      = 0
                       de-valor-aux = 0
                       i-moeda-aux  = 0.

                RUN RetornaMoedaValor IN h-bocx220(INPUT embarque-imp.embarque,
                                                   INPUT embarque-imp.cod-estabel,
                                                   OUTPUT de-valor, 
                                                   OUTPUT i-moeda).

                RUN RetornaMoedaValor IN h-bocx220(INPUT tt-embarque-imp.embarque,
                                                   INPUT tt-embarque-imp.cod-estabel,
                                                   OUTPUT de-valor-aux,
                                                   OUTPUT i-moeda-aux).

                IF i-moeda <> i-moeda-aux THEN
                    /* Inicio -- Projeto Internacional */
                    DO:
                    DEFINE VARIABLE c-lbl-liter-moeda-difere-dos-embarques-ja AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Moeda_difere_dos_embarques_j†_vinculados" *}
                    ASSIGN c-lbl-liter-moeda-difere-dos-embarques-ja = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                          &ErrorNumber="52164"
                          &ErrorType="EMS"
                          &ErrorParameters="c-lbl-liter-moeda-difere-dos-embarques-ja + '.' + '~~~~' + STRING(tt-embarque-imp.embarque) + '~~~~' + STRING(RowObject.num-di-ems)"}
                    END. 
                /*FIM MOEDA*/
                
                RUN retorna-spp-via-transp-dif. 
                IF NOT l-permite-via-dif THEN
                    /*VIA DE TRANSPORTE*/
                    IF tt-embarque-imp.cod-via-transp <> embarque-imp.cod-via-transp THEN DO:
                        DEFINE VARIABLE c-trad-via-trans AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Via de transporte difere dos embarques j† vinculados." *}
                        ASSIGN c-trad-via-trans = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i
                              &ErrorNumber="52164"
                              &ErrorType="EMS"
                              &ErrorParameters="c-trad-via-trans + '~~~~' + STRING(tt-embarque-imp.embarque) + '~~~~' + STRING(RowObject.num-di-ems)"}               
                    END.
                
            END.
        END.

    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-log-elimina-despesas DBOProgram 
PROCEDURE pi-log-elimina-despesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-origem-prog      AS CHAR NO-UNDO.
    DEF INPUT PARAM p-elimina-despesas AS LOG  NO-UNDO.

    ASSIGN log-eliminina-despesas = p-elimina-despesas
           c-orig-prog            = p-origem-prog.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-spp-via-transp-dif DBOPro

PROCEDURE retorna-spp-via-transp-dif :
/*------------------------------------------------------------------------------
  Purpose: Quando esta funá∆o estiver ativada o programa n∆o ir† validar a via de transporte.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF CAN-FIND (funcao 
            WHERE cd-funcao = 'spp-via-transp-dif'
            AND   ativo     = YES) THEN
    ASSIGN l-permite-via-dif = TRUE.
ELSE
    ASSIGN l-permite-via-dif = FALSE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

