&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN359 2.00.00.020} /*** "010020" 24/11/2023 13:25:22  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN359 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

{cdp/cdcfgmat.i} 

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName proc-fornec
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName proc-fornec
&GLOBAL-DEFINE TableLabel proc-fornec
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin359.i RowObject}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var iNrProcessoIni as int no-undo.
def var iNrProcessoFim as int no-undo.
def var iEmitenteIni   as int no-undo.
def var iEmitenteFim   as int no-undo.

DEFINE VARIABLE h-boin358 AS HANDLE     NO-UNDO.
DEFINE VARIABLE c-cod-comprado AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-erro AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-erro-pregao AS LOGICAL INIT NO NO-UNDO.

/** * Defini‡äes Multi-Planta * **/
def var i-tipo-movto    as integer no-undo.
def var c-cod-emitente  like emitente.cod-emitente.
def var c-processo      like proc-fornec.nr-processo.
def var l-proces-pregao as logical no-undo.
def var l-usuar-pregao  as logical no-undo.

{mpp/mpapi011.i}
{cdp/cd7300.i1}
{cdp/cd0669.i}
{utp/ut-glob.i}
/*---Vari veis PTI-Status,EMS2.05---*/
&if defined (bf_mat_bloqueio_fornec) &then
    def var h-api029       as handle no-undo.
    def var i-situacao     as int    no-undo.  
    def var dt-vig-ini     as date   no-undo.  
    def var dt-vig-fim     as date   no-undo.  
    def var c-return       as char   no-undo.

    def temp-table tt-erro-cdapi029 no-undo
        field i-sequen as int             
        field cd-erro  as int
        field mensagem as char format "x(255)"
        field c-param  as char.

&endif

/** * Fim Defini‡äes Multi-Planta * **/

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
         HEIGHT             = 17.46
         WIDTH              = 48.43.
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


FIND FIRST param-global NO-LOCK NO-ERROR.
find first param-compra no-lock no-error.

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

  assign i-tipo-movto = 1. /* utilizado na procedure pi-cria-processo-mat059 para 
                              informar quando ‚ create(1), update(2). ou delete(3)*/

    run pi-cria-processo-mat059.

    return "OK":U.

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

  assign i-tipo-movto = 2. /* utilizado na procedure pi-cria-processo-mat059 para 
                              informar quando ‚ create(1), update(2). ou delete(3)*/

    run pi-cria-processo-mat059.

    return "OK":U.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  assign i-tipo-movto = 3. /* utilizado na procedure pi-cria-processo-mat059 para
                                informar quando ‚ create(1), update(2). ou delete(3)*/

  assign c-cod-emitente = RowObject.cod-emitente
         c-processo     = RowObject.nr-processo.

  run pi-cria-processo-mat059.

/*   for each RowObject                                    */
/*       where RowObject.cod-emitente = c-cod-emitente and */
/*             RowObject.nr-processo  = c-processo :       */
/*       delete RowObject.                                 */
/*   end.                                                  */

  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    DEFINE INPUT PARAMETER pnr-processo  LIKE proc-fornec.nr-processo  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE proc-fornec.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcreturn      AS   char                     NO-UNDO.

    RUN openQueryStatic (input "Main":U).

    run goToKey (input pnr-processo,
                 input pcod-emitente).

    if return-value = "OK" then assign pcreturn = "".  /* esse ‚ o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa ‚ a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.


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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "nr-processo":U THEN ASSIGN pFieldValue = RowObject.nr-processo.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice CODIGO
  Parameters:
               retorna valor dos campos do ¡ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-processo LIKE proc-fornec.nr-processo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE proc-fornec.cod-emitente NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnr-processo = RowObject.nr-processo.
    ASSIGN pcod-emitente = RowObject.cod-emitente.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
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
  Purpose:     Reposiciona registro com base no ¡ndice CODIGO
  Parameters:
               recebe valor dos campos do ¡ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-processo LIKE proc-fornec.nr-processo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE proc-fornec.cod-emitente NO-UNDO.

    FIND FIRST bfproc-fornec WHERE
        bfproc-fornec.nr-processo = pnr-processo AND
        bfproc-fornec.cod-emitente = pcod-emitente
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproc-fornec THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproc-fornec)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToNrProcesso DBOProgram 
PROCEDURE goToNrProcesso :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no n£mero do processo
  Parameters:
               recebe valor do campo nr-processo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-processo LIKE proc-fornec.nr-processo NO-UNDO.

    FIND FIRST bfproc-fornec WHERE
        bfproc-fornec.nr-processo = pnr-processo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproc-fornec THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproc-fornec)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToProcesso DBOProgram 
PROCEDURE linkToProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param h-proc as handle no-undo.
    
    RUN GetKey in h-proc (output inrprocessoini).
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ------------------------ PROXIES BO 1.1 ----------------------------- */ 

    define input parameter i-abertura as integer no-undo.
    
    case i-abertura:
        when 1 then
            RUN openQueryStatic (input "Main":U).       

        when 2 then
            RUN openQueryStatic (input "ByNrProcesso":U).
                
        when 4 then
            RUN openQueryStatic (input "ByNrProcesso":U).       

        when 5 then
            RUN openQueryStatic (input "ByCodEmitente":U).       
    end case.    
    
    RETURN "OK":U.                               


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCodEmitente DBOProgram 
PROCEDURE openQueryByCodEmitente :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela proc-fornec dentro de uma
              faixa do n£mero do processo do fornecedor e outra faixa de c¢digo 
              do emitente (fornecedor).
              Os registros sÆo ordenados pelo c¢digo do emitente (fornecedor). 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
                                     {&TableName}.nr-processo  >= iNrProcessoIni and
                                     {&TableName}.nr-processo  <= iNrprocessoFim and
                                     {&TableName}.cod-emitente >= iEmitenteIni   and
                                     {&TableName}.cod-emitente <= iEmitenteFim   NO-LOCK 
                                     by cod-emitente INDEXED-REPOSITION.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEmitente DBOProgram 
PROCEDURE openQueryByEmitente :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela proc-fornec dentro de uma
              faixa de c¢digo do emitente (fornecedor).
              Os registros sÆo ordenados pelo c¢digo do emitente (fornecedor). 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
                                     {&TableName}.cod-emitente >= iEmitenteIni   and
                                     {&TableName}.cod-emitente <= iEmitenteFim   NO-LOCK 
                                     by cod-emitente INDEXED-REPOSITION.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNrProcesso DBOProgram 
PROCEDURE openQueryByNrProcesso :
/*------------------------------------------------------------------------------
  Purpose:  Busca conjunto de registros da tabela proc-fornec dentro de uma 
            faixa do n£mero do processo do fornecedor e outra faixa de c¢digo 
            do emitente (fornecedor).
            Os registros sÆo ordenados pelo n£mero do processo.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
                                     {&TableName}.nr-processo  >= iNrProcessoIni and
                                     {&TableName}.nr-processo  <= iNrprocessoFim and
                                     {&TableName}.cod-emitente >= iEmitenteIni   and
                                     {&TableName}.cod-emitente <= iEmitenteFim   NO-LOCK 
                                     by nr-processo INDEXED-REPOSITION.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryByProcesso DBOProgram 
PROCEDURE OpenQueryByProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
                                     {&TableName}.nr-processo  = iNrProcessoIni NO-LOCK 
                                     by cod-emitente INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH proc-fornec NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNrProcesso DBOProgram 
PROCEDURE openQueryNrProcesso :
/*------------------------------------------------------------------------------
  Purpose:  Busca conjunto de registros da tabela proc-fornec dentro de uma 
            faixa do n£mero do processo do fornecedor
            Os registros sÆo ordenados pelo n£mero do processo.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
                                     {&TableName}.nr-processo  >= iNrProcessoIni and
                                     {&TableName}.nr-processo  <= iNrprocessoFim NO-LOCK 
                                     by nr-processo INDEXED-REPOSITION.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-processo-mat059 DBOProgram 
PROCEDURE pi-cria-processo-mat059 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                                
    /*********** Multi-Planta **************/ 

    assign c-transacao = "MAT059".
    if  param-global.modulo-mp then do:   
        run cdp/cdapi150.p (input "proc-fornec",
                            input rowid(proc-fornec),
                            input i-tipo-movto,
                            input c-transacao,
                            input-output table tt-erro).    
        assign c-estabel-dest = " ".                                     
    end.

    /********** Fim Multi-Planta ***********/     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFornecProcesso DBOProgram 
PROCEDURE returnFornecProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER piProcesso AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER  TABLE FOR RowObject.

    FOR EACH proc-fornec WHERE
             proc-fornec.nr-processo = piProcesso NO-LOCK:
        CREATE RowObject.
        BUFFER-COPY proc-fornec TO RowObject.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ------------------------ PROXIES BO 1.1 ----------------------------- */ 

    def input param piNrProcesso as int no-undo.

    run setConstraintNrProcesso (input piNrProcesso,
                                 input piNrProcesso,
                                 input 0,
                                 input 999999999).
    
   RETURN "OK":U.                               


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint4 DBOProgram 
PROCEDURE setConstraint4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */ 

    def input param piNrProcessoIni as int no-undo.
    def input param piNrProcessoFim as int no-undo.
    def input param piEmitenteIni   as int no-undo.
    def input param piEmitenteFim   as int no-undo.

    run setConstraintNrProcesso (piNrProcessoIni,
                                 piNrProcessoFim,
                                 piEmitenteIni,
                                 piEmitenteFim).
    
   RETURN "OK":U.      
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintbyEmitente DBOProgram 
PROCEDURE setConstraintbyEmitente :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo os c¢digos 
              inicial e final do c¢digo do emitente (fornecedor).
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piEmitenteIni   as int no-undo.
    def input param piEmitenteFim   as int no-undo.
    
    assign iEmitenteIni   = piEmitenteIni
           iEmitenteFim   = piEmitenteFim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintbyNrProcesso DBOProgram 
PROCEDURE setConstraintbyNrProcesso :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo os c¢digos 
              inicial e final do processo do fornecedor.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piNrProcessoIni as int no-undo.
    def input param piNrProcessoFim as int no-undo.
    
    assign iNrProcessoIni = piNrProcessoIni
           iNrProcessoFim = piNrProcessoFim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNrProcesso DBOProgram 
PROCEDURE setConstraintNrProcesso :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo os c¢digos 
              inicial e final do processo do fornecedor e do c¢digo do 
              emitente (fornecedor).
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piNrProcessoIni as int no-undo.
    def input param piNrProcessoFim as int no-undo.
    def input param piEmitenteIni   as int no-undo.
    def input param piEmitenteFim   as int no-undo.
    
    assign iNrProcessoIni = piNrProcessoIni
           iNrProcessoFim = piNrProcessoFim
           iEmitenteIni   = piEmitenteIni
           iEmitenteFim   = piEmitenteFim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o par³metro pType para identificar quais as valida‡„es a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o par³metro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡„es ---*/
    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        find first proc-compra no-lock
             where proc-compra.nr-processo = RowObject.nr-processo.
        if avail proc-compra then do:
            &if "{&bf_mat_versao_ems}" >= "2.07" &then
                assign l-proces-pregao = proc-compra.log-proces-pregao.
            &else
                if substring(proc-compra.char-1,4,1) = "1" then
                    assign l-proces-pregao = yes.
                else 
                    assign l-proces-pregao = no.
            &endif
        end.

        find first usuar-mater no-lock
             where usuar-mater.cod-usuario = c-seg-usuario no-error.
        if avail usuar-mater then do:
            &if "{&bf_mat_versao_ems}" >= "2.07" &then
                assign l-usuar-pregao = usuar-mater.log-usuar-pregao.
            &else
                if substring(usuar-mater.char-1,13,1) = "1" then
                    assign l-usuar-pregao = yes.
                else 
                    assign l-usuar-pregao = no.
            &endif
        end.
    &endif

    FIND FIRST rowObject NO-ERROR. 
    
    if avail rowObject then do:
        if RowObject.cod-emitente <= 0 then do:
            {method/svc/errors/inserr.i &ErrorNumber="8591"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}             
        end.
        
       /****In¡cio valida‡Æo fornecedor, PTI-Status***/
        &IF defined(bf_mat_bloqueio_fornec) &THEN
        
            if not valid-handle(h-boin358) then
                run inbo/boin358.p persistent set h-boin358.
            run findCodigo in h-boin358 (input RowObject.nr-processo,
                                         output c-erro).
            run getCharField in h-boin358 (input "cod-comprado":U, output c-cod-comprado).

            run cdp/cdapi029.p(input c-cod-comprado,
                               input 1,
                               input today,
                               input RowObject.cod-emitente,
                               output i-situacao,
                               output dt-vig-ini,
                               output dt-vig-fim,
                               output table tt-erro-cdapi029).
            assign c-return = return-value.
            
            for each tt-erro-cdapi029:
                if c-return = "NOK":U then do:
                    {method/svc/errors/inserr.i &ErrorNumber="tt-erro-cdapi029.cd-erro"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="tt-erro-cdapi029.c-param"}
                end.
                else do:
                    {method/svc/errors/inserr.i &ErrorNumber="tt-erro-cdapi029.cd-erro"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="WARNING":U
                                            &ErrorParameters="tt-erro-cdapi029.c-param"}
                end.
            end.

        &ENDIF

        if pType = "Create":U then do:
            FIND FIRST bfproc-fornec WHERE
                bfproc-fornec.nr-processo = RowObject.nr-processo AND
                bfproc-fornec.cod-emitente = RowObject.cod-emitente NO-LOCK NO-ERROR.
            if avail bfproc-fornec then do:
                {method/svc/errors/inserr.i &ErrorNumber="5664"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U}             
            end.      
            find emitente where
                 emitente.cod-emitente = RowObject.cod-emitente and
                 emitente.identific <> 1 no-lock no-error.            
            if not avail emitente then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-fornecedor AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Fornecedor" *}
                ASSIGN c-lbl-liter-fornecedor = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-lbl-liter-fornecedor"}            
            end.
            
            &if "{&bf_mat_versao_ems}" >= "2.062" &then
                if l-proces-pregao and
                    not l-usuar-pregao then do:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-pregoeiro AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "pregoeiro" *}
                        ASSIGN c-lbl-liter-pregoeiro = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-incluir-este-registro AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "incluir_este_registro" *}
                        ASSIGN c-lbl-liter-incluir-este-registro = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="33085"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="Error":U
                                                    &ErrorParameters="usuar-mater.cod-usuario + '~~~~' + c-lbl-liter-pregoeiro + '~~~~' + c-lbl-liter-incluir-este-registro"}
                    return "NOK":U.
                end.
            &endif
        end.
        
        ASSIGN l-erro-pregao = NO.
        IF pType = "Delete":U THEN DO:
            &if "{&bf_mat_versao_ems}" >= "2.062" &then
                if l-proces-pregao and
                    not l-usuar-pregao then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-pregoeiro-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "pregoeiro" *}
                    ASSIGN c-lbl-liter-pregoeiro-2 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-excluir-este-registro AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "excluir_este_registro" *}
                    ASSIGN c-lbl-liter-excluir-este-registro = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="33085"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="Error":U
                                                &ErrorParameters="usuar-mater.cod-usuario + '~~~~' + c-lbl-liter-pregoeiro-2 + '~~~~' + c-lbl-liter-excluir-este-registro"}
                end.
            &endif

            FOR EACH ordem-compra NO-LOCK
                WHERE ordem-compra.nr-processo  = RowObject.nr-processo
                  AND ordem-compra.cod-emitente = RowObject.cod-emitente
                  AND ordem-compra.situacao     = 3, 
                FIRST cotacao-item NO-LOCK
                WHERE cotacao-item.cod-emitente     = ordem-compra.cod-emitente
                  AND cotacao-item.numero-ordem     = ordem-compra.numero-ordem
                  AND cotacao-item.data-cotacao     = ordem-compra.data-cotacao
                  AND cotacao-item.ind-orig-entrada = 17:
                IF NOT l-erro-pregao THEN
                    /* Inicio -- Projeto Internacional */
                    DO:
                    DEFINE VARIABLE c-lbl-liter-fornecedor-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Fornecedor" *}
                    ASSIGN c-lbl-liter-fornecedor-2 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-ordem-de-compra AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Ordem_de_Compra" *}
                    ASSIGN c-lbl-liter-ordem-de-compra = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="5"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="c-lbl-liter-fornecedor-2 + '~~~~' + c-lbl-liter-ordem-de-compra + ' ' + string(ordem-compra.numero-ordem)"}
                    END. 
                ASSIGN l-erro-pregao = YES.                                                
            END.  
        END. 
    end.
    
    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

