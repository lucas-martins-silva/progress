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
{include/i-prgvrs.i BOIN425 2.00.00.014 } /*** "010014" 24/11/2023 13:25:23  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN425 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ² um programa PROGRESS
                 que cont²m a l½gica de neg½cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini»’o ---*/
&GLOBAL-DEFINE DBOName tb-pr-cc
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName tb-pr-cc
&GLOBAL-DEFINE TableLabel tb-pr-cc
&GLOBAL-DEFINE QueryName qr{&TableName}

/*Pre-processadores para acelerador de implanta‡Æo*/
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin425.i RowObject}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Defini‡Æo das vari veis necess rias a setConstraintNomeAbrev */
DEFINE VARIABLE i-cod-emit    AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-cod-emit-ini    AS INTEGER   NO-UNDO INITIAL 0.
DEFINE VARIABLE i-cod-emit-fim    AS INTEGER   NO-UNDO INITIAL 999999999.
DEFINE VARIABLE c-nome-abrev-ini  AS CHARACTER NO-UNDO INITIAL "".
DEFINE VARIABLE c-nome-abrev-fim  AS CHARACTER NO-UNDO INITIAL "ZZZZZZZZZZZZ".

/* Defini‡Æo das vari veis necess rias a setConstraintNrTab */
DEFINE VARIABLE c-tab-ini         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-tab-fim         AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-sobrepoe        AS LOGICAL   NO-UNDO.

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
         HEIGHT             = 2.42
         WIDTH              = 25.57.
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findChCodigo DBOProgram 
PROCEDURE findChCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ----------------------------- PROXIES BO 1.1 ----------------------------- */

    DEFINE INPUT  PARAMETER pcnome-abrev   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER picod-cond-pag AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcnr-tab       AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-estabel   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pmo-codigo     AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcreturn       AS CHARACTER NO-UNDO.

    RUN goToKey (input pcnome-abrev,
                 input picod-cond-pag,
                 input pcnr-tab,
                 INPUT pcod-estabel,
                 INPUT pmo-codigo).

    IF return-value = "OK" THEN ASSIGN pcreturn = "". 
    IF return-value = "NOK" THEN do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        RUN utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        ASSIGN pcreturn =  return-value.  
    END.

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

/* ----------------------------- PROXIES BO 1.1 ----------------------------- */
 
    DEFINE INPUT  PARAMETER pcod-emitente AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER pnome-abrev   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-cond-pag AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER pnr-tab       AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-estabel  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pmo-codigo    AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcreturn      AS CHARACTER NO-UNDO.

    run openQueryStatic (input "Main").

    RUN goToKeyCodEmitente (input pcod-emitente,
                            input pnome-abrev,
                            input pcod-cond-pag,
                            input pnr-tab,
                            INPUT pcod-estabel,
                            INPUT pmo-codigo).

    IF return-value = "OK" THEN ASSIGN pcreturn = "". 
    IF return-value = "NOK" THEN do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        RUN utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        ASSIGN pcreturn =  return-value.  
    END.

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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "nr-tab":U THEN ASSIGN pFieldValue = RowObject.nr-tab.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-inicio":U THEN ASSIGN pFieldValue = RowObject.dt-inicio.
        WHEN "dt-termino":U THEN ASSIGN pFieldValue = RowObject.dt-termino.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "perc-descto":U THEN ASSIGN pFieldValue = RowObject.perc-descto.
        WHEN "tx-fin-dia":U THEN ASSIGN pFieldValue = RowObject.tx-fin-dia.
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "valor-taxa":U THEN ASSIGN pFieldValue = RowObject.valor-taxa.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "nr-dia-preco":U THEN ASSIGN pFieldValue = RowObject.nr-dia-preco.
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice CH-CODIGO
  Parameters:
               retorna valor dos campos do ­ndice CH-CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnome-abrev LIKE tb-pr-cc.nome-abrev NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-cond-pag LIKE tb-pr-cc.cod-cond-pag NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-tab LIKE tb-pr-cc.nr-tab NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE tb-pr-cc.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pmo-codigo LIKE tb-pr-cc.mo-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnome-abrev = RowObject.nome-abrev.
    ASSIGN pcod-cond-pag = RowObject.cod-cond-pag.
    ASSIGN pnr-tab = RowObject.nr-tab.
    ASSIGN pcod-estabel = RowObject.cod-estabel.
    ASSIGN pmo-codigo = RowObject.mo-codigo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l½gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "codigo-ipi":U THEN ASSIGN pFieldValue = RowObject.codigo-ipi.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
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
  Purpose:     Reposiciona registro com base no ­ndice CH-CODIGO
  Parameters:
               recebe valor dos campos do ­ndice CH-CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnome-abrev LIKE tb-pr-cc.nome-abrev NO-UNDO.
    DEFINE INPUT PARAMETER pcod-cond-pag LIKE tb-pr-cc.cod-cond-pag NO-UNDO.
    DEFINE INPUT PARAMETER pnr-tab LIKE tb-pr-cc.nr-tab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE tb-pr-cc.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pmo-codigo LIKE tb-pr-cc.mo-codigo NO-UNDO.

    FIND FIRST bftb-pr-cc WHERE
               bftb-pr-cc.nome-abrev = pnome-abrev AND
               bftb-pr-cc.cod-cond-pag = pcod-cond-pag AND
               bftb-pr-cc.nr-tab = pnr-tab AND
               bftb-pr-cc.cod-estabel = pcod-estabel AND
               bftb-pr-cc.mo-codigo = pmo-codigo NO-LOCK NO-ERROR.
     
    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    
    IF NOT AVAILABLE bftb-pr-cc THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftb-pr-cc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyCodEmitente DBOProgram 
PROCEDURE goToKeyCodEmitente :
/*------------------------------------------------------------------------------
  Purpose:     Procura pelo indice, caso nao ache, retorna mensagem de erro 
               padrao do EMS.
               !! Este m‚todo foi implementado por causa do EMS 2.02 !!
  Parameters:  
               recebe valor dos campos do ¡ndice 
               retorna status do processo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-emitente LIKE tb-pr-cc.cod-emitente NO-UNDO.    
    DEFINE INPUT PARAMETER pnome-abrev   LIKE tb-pr-cc.nome-abrev   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-cond-pag LIKE tb-pr-cc.cod-cond-pag NO-UNDO.
    DEFINE INPUT PARAMETER pnr-tab       LIKE tb-pr-cc.nr-tab       NO-UNDO.
    DEFINE INPUT PARAMETER pmo-codigo    LIKE tb-pr-cc.mo-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel  LIKE tb-pr-cc.cod-estabel  NO-UNDO.

    if  pcod-emitente = 0 
    and pnome-abrev <> "" then do:
        for first emitente fields(cod-emitente) 
            where emitente.nome-abrev = pnome-abrev no-lock: end.
        if avail emitente then
           assign pcod-emitente = emitente.cod-emitente.
    end.

    find first bftb-pr-cc 
         where bftb-pr-cc.cod-emitente = pcod-emitente 
           and bftb-pr-cc.nr-tab       = pnr-tab       
           and bftb-pr-cc.cod-cond-pag = pcod-cond-pag
           AND bftb-pr-cc.mo-codigo    = pmo-codigo
           AND bftb-pr-cc.cod-estabel  = pcod-estabel no-lock no-error.
            
    IF NOT AVAILABLE bftb-pr-cc THEN 
        RETURN "NOK":U. 

    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftb-pr-cc)).
    IF RETURN-VALUE = "NOK":U THEN 
        RETURN "NOK":U. 

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

/* ----------------------------- PROXIES BO 1.1 ----------------------------- */
    define input parameter piabertura as integer no-undo.
    case piabertura:
        when 1 then
            run openQueryStatic ("Main").
        when 3 then
            run openQueryStatic ("ByNomeAbrev").
    end case.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNomeAbrev DBOProgram 
PROCEDURE openQueryByNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    IF (c-nome-abrev-ini = c-nome-abrev-fim) AND (i-cod-emit-ini = i-cod-emit-fim) THEN DO:
        OPEN QUERY {&Queryname} FOR EACH {&TABLENAME} WHERE
                                         {&TABLENAME}.cod-emitente = i-cod-emit-ini NO-LOCK INDEXED-REPOSITION.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH {&TABLENAME} WHERE 
                                         {&TABLENAME}.nome-abrev   >= c-nome-abrev-ini AND
                                         {&TABLENAME}.nome-abrev   <= c-nome-abrev-fim AND
                                         {&TABLENAME}.cod-emitente >= i-cod-emit-ini   AND
                                         {&TABLENAME}.cod-emitente <= i-cod-emit-fim   NO-LOCK
                                         BY {&TABLENAME}.nome-abrev 
                                          BY {&TABLENAME}.nr-tab 
                                            BY {&TABLENAME}.cod-cond-pag INDEXED-REPOSITION.
    END.                                            
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNrTab DBOProgram 
PROCEDURE openQueryByNrTab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TABLENAME} WHERE 
                                     {&TABLENAME}.cod-emitente >= i-cod-emit-ini AND
                                     {&TABLENAME}.cod-emitente <= i-cod-emit-fim AND
                                     {&TABLENAME}.nr-tab >= c-tab-ini            AND
                                     {&TABLENAME}.nr-tab <= c-tab-fim            NO-LOCK
                                     BY {&TABLENAME}.nr-tab INDEXED-REPOSITION.
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
    OPEN QUERY {&QueryName} FOR EACH tb-pr-cc NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraint3 DBOProgram 
PROCEDURE setconstraint3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ----------------------------- PROXIES BO 1.1 ----------------------------- */
    def input param p-cod-usuario as char no-undo.

    run setConstraintByNomeAbrev (input "",
                                  input "",
                                  input int(p-cod-usuario),
                                  input int(p-cod-usuario)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNomeAbrev DBOProgram 
PROCEDURE setConstraintByNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose:     SetConstraint referente ordena‡Æo do nome abreviado do fornecedor
  Parameters:  
               recebe c¢digo inicial do emitente
               recebe c¢digo final do emitente
               recebe nome abreviado inicial do fornecedor
               recebe nome abreviado final do fornecedor               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnome-abrev-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pnome-abrev-fim AS CHARACTER NO-UNDO.    
    DEFINE INPUT PARAMETER pcod-emit-ini   AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emit-fim   AS INTEGER   NO-UNDO.  
    ASSIGN c-nome-abrev-ini = pnome-abrev-ini
           c-nome-abrev-fim = pnome-abrev-fim
           i-cod-emit-ini   = pcod-emit-ini
           i-cod-emit-fim   = pcod-emit-fim.
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNrTab DBOProgram 
PROCEDURE setConstraintByNrTab :
/*------------------------------------------------------------------------------
  Purpose:     SetConstraint referente ordena‡Æo do c¢digo da tabela de pre‡os
  Parameters:  
               recebe c¢digo inicial da tabela de pre‡os 
               recebe c¢digo final da tabela de pre‡os
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-emit-ini   AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emit-fim   AS INTEGER   NO-UNDO.    
    DEFINE INPUT PARAMETER ptab-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER ptab-fim AS CHARACTER NO-UNDO.
    ASSIGN i-cod-emit-ini   = pcod-emit-ini
           i-cod-emit-fim   = pcod-emit-fim
           c-tab-ini = ptab-ini
           c-tab-fim = ptab-fim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida»’o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o par³metro pType para identificar quais as valida»„es a serem
          executadas ---*/
    /*--- Os valores poss­veis para o par³metro s’o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav²s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida»„es ---*/
    
    FIND FIRST rowObject NO-ERROR. 
    
    if avail rowObject then do:
        IF pType = "Create":U OR pType = "Update":U THEN DO:
        
             find first emitente 
                  where emitente.cod-emitente = rowObject.cod-emitente no-lock no-error.
            /* Verifica se fornecedor existe */
            if  not avail emitente then do:
                 {utp/ut-liter.i "Fornecedor" *}
                 {method/svc/errors/inserr.i &ErrorNumber="558"
                                             &ErrorType="EMS":U
                                             &ErrorSubType="ERROR":U
                                             &ErrorParameters=TRIM(RETURN-VALUE)}
            end.
            
            /* Verifica se condicao de pagamento existe */
            if not can-find(first cond-pagto where 
                                 cond-pagto.cod-cond-pag = rowObject.cod-cond-pag) then do:
                {utp/ut-liter.i "Condi‡Æo_de_Pagamento" *}
                {method/svc/errors/inserr.i &ErrorNumber="47"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters=TRIM(RETURN-VALUE)}
            end.
        
            /* Verifica se foi informado codigo da tabela de preco */
            if  rowObject.nr-tab = "" or rowObject.nr-tab = ? then do:
                {utp/ut-liter.i "'c¢digo_da_tabela'" *}
                {method/svc/errors/inserr.i &ErrorNumber="6216"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters=TRIM(RETURN-VALUE)}
            end.
            
            /* Verifica descri‡Æo da tabela */
            if rowObject.descricao = "" then do:
               {utp/ut-liter.i Descri‡Æo * R}
               {method/svc/errors/inserr.i &ErrorNumber="158"
                                           &ErrorType="EMS":U
                                           &ErrorSubType="ERROR":U
                                           &ErrorParameters=TRIM(RETURN-VALUE)}
            end.
        
            /* Verifica datas de validade da tabela */
            if  rowObject.dt-inicio > rowObject.dt-termino then do:
                {method/svc/errors/inserr.i &ErrorNumber="137"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U}
            end.
            
            /*---- Sobreposi‡Æo com datas de validade de outra tabela de pre‡os -----*/
            assign l-sobrepoe = no.
            FOR EACH bftb-pr-cc
               where bftb-pr-cc.cod-emitente  = rowObject.cod-emitente 
                 and bftb-pr-cc.cod-cond-pag  = rowObject.cod-emitente 
                 and bftb-pr-cc.nr-tab       <> rowObject.nr-tab
                 AND bftb-pr-cc.cod-estabel   = rowObject.cod-estabel
                 AND bftb-pr-cc.mo-codigo     = rowObject.mo-codigo
                 and bftb-pr-cc.situacao      = 1 NO-LOCK:
                
                if  rowObject.dt-inicio <= bftb-pr-cc.dt-termino and
                    rowObject.dt-termino  >= bftb-pr-cc.dt-inicio then do:
                    assign l-sobrepoe = yes.
                end.
            END.
               
            if  l-sobrepoe = yes then do:
                {method/svc/errors/inserr.i &ErrorNumber="1276"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U}
            end.
        
            /* Verifica se moeda existe */
            if not can-find(first moeda where moeda.mo-codigo = rowObject.mo-codigo) then do:
                {utp/ut-liter.i "Moeda" *}
                {method/svc/errors/inserr.i &ErrorNumber="47"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters=TRIM(RETURN-VALUE)}
            end.
            
            /* Verifica se foi informado codigo do estabelecimento, se sim verifica se o mesmo existe */
            IF  rowObject.cod-estabel <> "":U AND rowObject.cod-estabel <> ? THEN DO:
                
                if not can-find(FIRST estabelec 
                                WHERE estabelec.cod-estabel = rowObject.cod-estabel) then do:
                    {utp/ut-liter.i "Estabelecimento" *}
                    {method/svc/errors/inserr.i &ErrorNumber="47"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters=TRIM(RETURN-VALUE)}
                END.
            END.
            
            /* verifica se situacao ‚ 1 ou 2 */
            if  rowObject.situacao <> 1 and rowObject.situacao <> 2 then do:
                {method/svc/errors/inserr.i &ErrorNumber="56084"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters=TRIM(RETURN-VALUE)}
            end.
        END.
        
        IF pType = "Create":U THEN DO:
            /* Verifica se a tabela importada ja existe */
            if can-find(first bftb-pr-cc
                        where bftb-pr-cc.cod-emitente = rowObject.cod-emitente
                          and bftb-pr-cc.nr-tab       = rowObject.nr-tab      
                          and bftb-pr-cc.cod-cond-pag = rowObject.cod-cond-pag
                          and bftb-pr-cc.cod-estabel  = rowObject.cod-estabel 
                          and bftb-pr-cc.mo-codigo    = rowObject.mo-codigo) then do:
                          
                  {utp/ut-liter.i "Tabela_de_pre‡o" *}
                  {method/svc/errors/inserr.i &ErrorNumber="4242"
                                              &ErrorType="EMS":U
                                              &ErrorSubType="ERROR":U
                                              &ErrorParameters=TRIM(RETURN-VALUE)}       
            end.
        END.
        
        IF pType = "Update":U
        OR pType = "Delete":U THEN DO:
           if not can-find(first bftb-pr-cc
                           where bftb-pr-cc.cod-emitente = rowObject.cod-emitente
                             and bftb-pr-cc.nr-tab       = rowObject.nr-tab      
                             and bftb-pr-cc.cod-cond-pag = rowObject.cod-cond-pag
                             and bftb-pr-cc.cod-estabel  = rowObject.cod-estabel 
                             and bftb-pr-cc.mo-codigo    = rowObject.mo-codigo) then do:
                {utp/ut-liter.i "Tabela_De_Pre‡o_NÆo_Encontrada!" *}
                {method/svc/errors/inserr.i &ErrorNumber="47"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters=TRIM(RETURN-VALUE)}
           end.
        end.
        
        IF pType = "Delete":U THEN DO:
           if can-find(first item-tab
                       where item-tab.cod-emitente = rowObject.cod-emitente
                         and item-tab.nr-tab       = rowObject.nr-tab      
                         and item-tab.cod-cond-pag = rowObject.cod-cond-pag
                         and item-tab.cod-estabel  = rowObject.cod-estabel) then do:
                {method/svc/errors/inserr.i &ErrorNumber="6786"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U}
           end.
        end.
    END.
    
    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

