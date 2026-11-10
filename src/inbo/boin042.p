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
{include/i-prgvrs.i BOIN042 2.00.01.021 } /*** "010121" 29/07/2024 22:11:54 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN042 MUT}
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
&GLOBAL-DEFINE KeyField1 cc-codigo /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES 

&GLOBAL-DEFINE DBOName centro-custo
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName centro-custo
&GLOBAL-DEFINE TableLabel centro-custo
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin042.i RowObject}
{inbo/boin734.i tt-ccusto-estabRow}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE TEMP-TABLE tt-ccusto-estab NO-UNDO LIKE ccusto-estab
       field r-rowid as rowid.

/* Variaveis necessarias aos setConstraint's */

   define variable c-inicial   as character no-undo.
   define variable c-final     as character no-undo.

   DEFINE TEMP-TABLE RowErrorsFrotas no-undo
       field ErrorSequence as integer
       field ErrorNumber   as integer
       field ErrorDescription as char
       field ErrorParameters as char
       field ErrorType       as char
       field Errorhelp       as char
       field Errorsubtype    as char.

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
         HEIGHT             = 11
         WIDTH              = 40.14.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    def input parameter pcc-codigo LIKE centro-custo.cc-codigo no-undo.
    def output parameter pcreturn as char no-undo.
    
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input pcc-codigo).

    if return-value = "OK" then assign pcreturn = "".  /* esse ² o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa ² a mensagem esperada nas interfaces 1.1  qdo n’o acha o registro */
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "sc-codigo[1]":U THEN ASSIGN pFieldValue = RowObject.sc-codigo[1].
        WHEN "sc-codigo[2]":U THEN ASSIGN pFieldValue = RowObject.sc-codigo[2].
        WHEN "sc-codigo[3]":U THEN ASSIGN pFieldValue = RowObject.sc-codigo[3].
        WHEN "sc-codigo[4]":U THEN ASSIGN pFieldValue = RowObject.sc-codigo[4].
        WHEN "sc-codigo[5]":U THEN ASSIGN pFieldValue = RowObject.sc-codigo[5].
        WHEN "sc-codigo[6]":U THEN ASSIGN pFieldValue = RowObject.sc-codigo[6].
        WHEN "sc-mob":U THEN ASSIGN pFieldValue = RowObject.sc-mob.
        WHEN "cc-codigo":U THEN ASSIGN pFieldValue = RowObject.cc-codigo.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "ct-codigo[1]":U THEN ASSIGN pFieldValue = RowObject.ct-codigo[1].
        WHEN "ct-codigo[2]":U THEN ASSIGN pFieldValue = RowObject.ct-codigo[2].
        WHEN "ct-codigo[3]":U THEN ASSIGN pFieldValue = RowObject.ct-codigo[3].
        WHEN "ct-codigo[4]":U THEN ASSIGN pFieldValue = RowObject.ct-codigo[4].
        WHEN "ct-codigo[5]":U THEN ASSIGN pFieldValue = RowObject.ct-codigo[5].
        WHEN "ct-codigo[6]":U THEN ASSIGN pFieldValue = RowObject.ct-codigo[6].
        WHEN "ct-mob":U THEN ASSIGN pFieldValue = RowObject.ct-mob.
        WHEN "ct-var-efic":U THEN ASSIGN pFieldValue = RowObject.ct-var-efic.
        WHEN "ct-var-taxa":U THEN ASSIGN pFieldValue = RowObject.ct-var-taxa.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "sc-var-efic":U THEN ASSIGN pFieldValue = RowObject.sc-var-efic.
        WHEN "sc-var-taxa":U THEN ASSIGN pFieldValue = RowObject.sc-var-taxa.
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
        WHEN "data-cust-pr":U THEN ASSIGN pFieldValue = RowObject.data-cust-pr.
        WHEN "data-custo-pad":U THEN ASSIGN pFieldValue = RowObject.data-custo-pad.
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
        WHEN "val-unit-up[3]":U THEN ASSIGN pFieldValue = RowObject.val-unit-up[3].
        WHEN "horas-dispon":U THEN ASSIGN pFieldValue = RowObject.horas-dispon.
        WHEN "horas-homem":U THEN ASSIGN pFieldValue = RowObject.horas-homem.
        WHEN "horas-maq":U THEN ASSIGN pFieldValue = RowObject.horas-maq.
        WHEN "horas-padrao":U THEN ASSIGN pFieldValue = RowObject.horas-padrao.
        WHEN "horas-prod":U THEN ASSIGN pFieldValue = RowObject.horas-prod.
        WHEN "horas-report":U THEN ASSIGN pFieldValue = RowObject.horas-report.
        WHEN "nr-up-report":U THEN ASSIGN pFieldValue = RowObject.nr-up-report.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "tot-hora-hom":U THEN ASSIGN pFieldValue = RowObject.tot-hora-hom.
        WHEN "tot-hora-maq":U THEN ASSIGN pFieldValue = RowObject.tot-hora-maq.
        WHEN "val-unit-up[1]":U THEN ASSIGN pFieldValue = RowObject.val-unit-up[1].
        WHEN "val-unit-up[2]":U THEN ASSIGN pFieldValue = RowObject.val-unit-up[2].
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
        WHEN "forma-abs[6]":U THEN ASSIGN pFieldValue = RowObject.forma-abs[6].
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "forma-abs[1]":U THEN ASSIGN pFieldValue = RowObject.forma-abs[1].
        WHEN "forma-abs[2]":U THEN ASSIGN pFieldValue = RowObject.forma-abs[2].
        WHEN "forma-abs[3]":U THEN ASSIGN pFieldValue = RowObject.forma-abs[3].
        WHEN "forma-abs[4]":U THEN ASSIGN pFieldValue = RowObject.forma-abs[4].
        WHEN "forma-abs[5]":U THEN ASSIGN pFieldValue = RowObject.forma-abs[5].
        WHEN "tempo-ggf":U THEN ASSIGN pFieldValue = RowObject.tempo-ggf.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice CODIGO
  Parameters:
               retorna valor dos campos do ­ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcc-codigo LIKE centro-custo.cc-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcc-codigo = RowObject.cc-codigo.

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
  Purpose:     Reposiciona registro com base no ­ndice CODIGO
  Parameters:
               recebe valor dos campos do ­ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcc-codigo LIKE centro-custo.cc-codigo NO-UNDO.

    FIND FIRST bfcentro-custo WHERE
        bfcentro-custo.cc-codigo = pcc-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcentro-custo THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcentro-custo)).
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
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    define input parameter i-abertura as integer no-undo.
       case i-abertura:
           when 1 then
              RUN openQueryStatic (input "Main":U). 
              
           when 2 then
              RUN openQueryStatic (input "ByCcCodigo":U).
           
           when 3 then
              RUN openQueryStatic (input "ByDescricao":U).

    end case.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCcCodigo DBOProgram 
PROCEDURE openQueryByCcCodigo :
/*------------------------------------------------------------------------------
  Purpose:  Busca conjunto de registros da tabela centro-custo dentro de
            uma faixa de centro de custo inicial e final. Ordena por 
            centro de custo. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&TABLENAME}.cc-codigo >= c-inicial and 
                                     {&TABLENAME}.cc-codigo <= c-final NO-LOCK
                                     BY {&TABLENAME}.cc-codigo
                                     INDEXED-REPOSITION.
                                      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDescricao DBOProgram 
PROCEDURE openQueryByDescricao :
/*------------------------------------------------------------------------------
  Purpose:  Busca conjunto de registros da tabela centro-custo, 
            dentro de uma faixa de descri‡Æo inicial e final.
            Ordena por descri‡Æo. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&TABLENAME}.descricao >= c-inicial and 
                                     {&TABLENAME}.descricao <= c-final NO-LOCK
                                     BY {&TABLENAME}.descricao
                                     INDEXED-REPOSITION.
                                                                                             
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDescricao DBOProgram 
PROCEDURE openQueryDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK BY 
                                 {&TableName}.descricao INDEXED-REPOSITION.

RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram  
PROCEDURE openQueryDefault :
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
                                      
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
    OPEN QUERY {&QueryName} FOR EACH centro-custo NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo 
              o c¢digo do centro-custo inicial e final. 
  Parameters: ipar1: p-inicial: Centro-custo Inicial
              ipar2: p-final:   Centro-custo Final 
    
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    def input parameter p-inicial     as char no-undo.
    def input parameter p-final       as char no-undo.
    
    run setConstraintFiltroCcCodigo (p-inicial,
                                     p-final).
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByCcCodigo DBOProgram 
PROCEDURE setConstraintByCcCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-codigo-ini  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-codigo-end  AS CHARACTER NO-UNDO.

ASSIGN c-inicial     = p-codigo-ini
       c-final       = p-codigo-end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDescricao DBOProgram 
PROCEDURE setConstraintByDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-desc-ini    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-desc-end    AS CHARACTER NO-UNDO.

ASSIGN c-inicial     = p-desc-ini
       c-final       = p-desc-end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroCcCodigo DBOProgram 
PROCEDURE setConstraintFiltroCcCodigo :
/*------------------------------------------------------------------------------
  Purpose:   Seta as vari veis de controle para queries contendo 
             o c¢digo do centro-custo inicial e final. 
  Parameters: ipar1: p-inicial: Centro-custo Inicial
              ipar2: p-final:   Centro-custo Final
        
------------------------------------------------------------------------------*/

    def input parameter p-inicial    as char no-undo.
    def input parameter p-final      as char no-undo.

    assign c-inicial = p-inicial
           c-final   = p-final.

                               
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

    IF CAN-FIND(FIRST ccusto-estab WHERE ccusto-estab.cc-codigo = RowObject.cc-codigo) THEN DO:
        FOR EACH ccusto-estab WHERE ccusto-estab.cc-codigo = RowObject.cc-codigo EXCLUSIVE-LOCK:
            DELETE ccusto-estab.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeleteFrotas DBOProgram 
PROCEDURE validateDeleteFrotas :
/*------------------------------------------------------------------------------
  Purpose: Valida as tabelas de Frotas    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define variable h-abapi008 as handle  no-undo.
define variable iErro      as integer no-undo.
define variable lValida    as logical no-undo.
define variable i-cont     as integer no-undo.



assign lValida = no.
do i-cont = 1 to 5:
    if i-cont <> 3
    and i-cont <> 4 then do:
        run cdp/cd9902.p (input i-cont).
        if return-value = "OK":U then do:
            assign lValida = yes.
            leave.
        end.
    end.
end.
if lValida then do:
    /** Passa o rowid para API de Frotas **/
    run abp/abapi008.p persistent set h-abapi008 (input RowObject.r-rowid).
    /** Valida‡äes de Frotas **/
    run validateCentroCusto in h-abapi008 (INPUT RowObject.cc-codigo).
    if return-value = "NOK":U then do:
        empty temp-table RowErrorsFrotas.
        /** Busca os erros ocorridos em frotas **/
        run getRowErrors in h-abapi008 (output table RowErrorsFrotas).
        assign iErro = 0.
        /** Se ocorreram erros noproduto padrÆo, busca a £ltima sequˆncia **/
        for last RowErrors no-lock:
            assign iErro = RowErrors.ErrorSequence.
        end.
        /** Percorre os erros ocorridos em frotas **/
        for each RowErrorsFrotas no-lock:
            /** Cria os erros no produto padrÆo **/
            create RowErrors.
            buffer-copy RowErrorsFrotas except ErrorSequence to RowErrors
                assign RowErrors.ErrorSequence = iErro + 1
                       iErro                   = RowErrors.ErrorSequence.
        end.
        empty temp-table RowErrorsFrotas.
    end.
    /** Elimina a API da mem¢ria **/
    if valid-handle(h-abapi008) then
        delete procedure h-abapi008.
end.

return "OK":U.
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

    def var c-centro as char no-undo.

    {utp/ut-table.i mgind centro-custo 1}
    assign c-centro = return-value.

    /*--- Utilize o par³metro pType para identificar quais as valida»„es a serem
          executadas ---*/
    /*--- Os valores poss­veis para o par³metro s’o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav²s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida»„es ---*/


    IF pType = "CREATE":U THEN DO:

       IF CAN-FIND(FIRST bf{&TableName} 
                   WHERE bf{&TableName}.cc-codigo = RowObject.cc-codigo) THEN DO:
           {utp/ut-table.i mgind centro-custo 1}
           {method/svc/errors/inserr.i &ErrorNumber="7"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="return-value"}
       END.  

       IF RowObject.cod-estabel <> "*" THEN DO :
       
          FIND FIRST gm-estab 
               WHERE gm-estab.cc-codigo = RowObject.cc-codigo AND
                     gm-estab.cod-estabel = RowObject.cod-estabel NO-LOCK NO-ERROR.
          IF AVAIL gm-estab THEN DO:
             {utp/ut-table.i mgadm estabelec 01}
             {method/svc/errors/inserr.i &ErrorNumber="26929"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="return-value"}
                                
          END.

          IF length(trim(RowObject.cod-estabel)) <= 0 THEN DO:
             {utp/ut-table.i mgadm estabelec 01}
             {method/svc/errors/inserr.i &ErrorNumber="265"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="return-value"}
          END.

          IF NOT CAN-FIND(FIRST estabelec 
                          WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
             {utp/ut-table.i mgadm estabelec 01}
             {method/svc/errors/inserr.i &ErrorNumber="56"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="return-value"}
          END.
          
       END.
       ELSE DO:

          IF CAN-FIND (FIRST gm-estab 
                       WHERE gm-estab.cc-codigo = RowObject.cc-codigo NO-LOCK) THEN DO:
             {utp/ut-table.i mgind centro-custo 01}
             {method/svc/errors/inserr.i &ErrorNumber="26929"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="return-value"}           

          END.
          
       END.
       
    END.

    IF pType = "DELETE":U THEN DO:
    
       IF CAN-FIND (FIRST gm-estab 
                    WHERE gm-estab.cc-codigo   = RowObject.cc-codigo 
                      AND gm-estab.cod-estabel = RowObject.cod-estabel NO-LOCK) THEN DO:
          {utp/ut-table.i mgadm estabelec 01}
          {method/svc/errors/inserr.i &ErrorNumber="26929"
                                      &ErrorType="EMS"
                                      &ErrorSubType="ERROR"
                                      &ErrorParameters="return-value"}           
       END.
        /*
        {inbo/boin042.i1 ccusto-estab mgind}
        */
        {inbo/boin042.i1 gm-estab mgind}
        {inbo/boin042.i1 ext-custos mgind}
        {inbo/boin042.i1 ext-per-custo movind}
        {inbo/boin042.i1 ext-per-custo-estab movind}
        {inbo/boin042.i1 movto-dir movind}
        {inbo/boin042.i1 movto-ggf movind}
        {inbo/boin042.i1 prazo-compra movind}
        {inbo/boin042.i1 mi-espec mgmnt}
        {inbo/boin042.i1 tecn-mi mgmnt}
        {inbo/boin042.i1 ord-mob movmnt}

        find first param-global no-lock no-error.
        if avail param-global and param-global.modulo-bh then do:

            FIND FIRST centro-custo
                 WHERE centro-custo.cc-codigo = RowObject.cc-codigo NO-LOCK NO-ERROR.

            run bhp/bh0453.p (buffer centro-custo).

            if  return-value <> "ok" then do:

                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-nao_foi_possivel_verificar AS CHARACTER FORMAT "X(117)" NO-UNDO.
                {utp/ut-liter.i "Bancos Hist¢ricos: Não foi possível verificar informações ou foram encontrados registros de movimentação GGF" *}
                ASSIGN c-nao_foi_possivel_verificar = TRIM(RETURN-VALUE).

                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-nao_foi_possivel_verificar"}
            end.
        end.
        
        run validateDeleteFrotas in this-procedure.
    end.

    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


define buffer b-tt-ccusto-estab for tt-ccusto-estab.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaEstab DBOProgram
PROCEDURE setaEstab :
    define input parameter c-cc-codigo as character.
    define input parameter table for tt-ccusto-estab.
    define output parameter table for RowErrors.
    
    define variable h-boin734 as handle no-undo.
    DEFINE BUFFER bccusto-estab FOR ccusto-estab.

    DEFINE VARIABLE r-rowid AS ROWID       NO-UNDO.
    run inbo/boin734.p persistent set h-boin734.
    run openQueryStatic in h-boin734 (input "Main":U).
    
    /** Apaga registros ja existentes que nao estao na TT **/
    for each bccusto-estab WHERE bccusto-estab.cc-codigo   = c-cc-codigo NO-LOCK:
        
        if not can-find(first tt-ccusto-estab
                        where tt-ccusto-estab.cc-codigo   = c-cc-codigo
                          and tt-ccusto-estab.cod-estabel = bccusto-estab.cod-estabel) then do:
            
            run goToKey in h-boin734 (input bccusto-estab.cc-codigo,
                                      INPUT bccusto-estab.cod-estabel).


            if return-value = "OK":U then do:
                run deleteRecord in h-boin734.

                if return-value = "NOK":U  then do:
                    run getRowErrors in h-boin734 (output table RowErrors).
					
					
					IF can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) THEN
						RETURN "NOK":u.
                end.
            end.
            
        end.

        
    end.

    RUN emptyRowErrors IN h-boin734.
    RUN emptyRowErrors IN THIS-PROCEDURE.
    ASSIGN r-rowid = ?.

    /** Cria novos registros **/
    for each tt-ccusto-estab no-lock:
        
        
        if can-find(first ccusto-estab
                    where ccusto-estab.cc-codigo   = tt-ccusto-estab.cc-codigo
                    and   ccusto-estab.cod-estabel = "*")
                    and tt-ccusto-estab.cod-estabel <> "*" then do:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Relacionamento de estabelecimentos individuais só podem ser efetuados para centro de custos que não utilizem *'"}
            return "NOK":u. 
        end.
                
        if not can-find (first ccusto-estab
                         where ccusto-estab.cc-codigo   = tt-ccusto-estab.cc-codigo
                           and ccusto-estab.cod-estabel = tt-ccusto-estab.cod-estabel) then do:

            empty temp-table tt-ccusto-estabRow.
            
            create tt-ccusto-estabRow.
            buffer-copy tt-ccusto-estab to tt-ccusto-estabRow.

            RUN validateCreate IN h-boin734 (INPUT TABLE tt-ccusto-estabRow,
                                             OUTPUT TABLE rowErrors,
                                             OUTPUT r-rowid).


            if return-value <> "OK" then 
                RETURN "NOK":U.
            
        end.
        
    end.

    RETURN "OK":U.
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
