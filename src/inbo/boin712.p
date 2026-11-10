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
{include/i-prgvrs.i BOIN712 2.00.00.005} /*** "010005" 29/11/2023 09:07:15  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN712 MUT}
&ENDIF

/*--------------------------------------------------------------------------
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

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN712
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rma-ocorrencia
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin712.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var c-cod-ocorrencia-ini as char no-undo.
def var c-cod-ocorrencia-fim as char no-undo.
def var c-des-ocorrencia-ini as char no-undo.
def var c-des-ocorrencia-fim as char no-undo.
def var i-tipo-ocorrencia    as int  no-undo.
def var c-erro               as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-ocorrencia":U THEN ASSIGN pFieldValue = RowObject.cod-ocorrencia.
        WHEN "des-ocorrencia":U THEN ASSIGN pFieldValue = RowObject.des-ocorrencia.
        WHEN "ds1-narrativa":U THEN ASSIGN pFieldValue = RowObject.ds1-narrativa.
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
        WHEN "cdn-tp-ocorrencia":U THEN ASSIGN pFieldValue = RowObject.cdn-tp-ocorrencia.
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
  Purpose:     Retorna valores dos campos do °ndice ocorrencia
  Parameters:  
               retorna valor do campo cod-ocorrencia
               retorna valor do campo cdn-tp-ocorrencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-ocorrencia LIKE rma-ocorrencia.cod-ocorrencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-tp-ocorrencia LIKE rma-ocorrencia.cdn-tp-ocorrencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-ocorrencia = RowObject.cod-ocorrencia
           pcdn-tp-ocorrencia = RowObject.cdn-tp-ocorrencia.

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
  Purpose:     Reposiciona registro com base no °ndice ocorrencia
  Parameters:  
               recebe valor do campo cod-ocorrencia
               recebe valor do campo cdn-tp-ocorrencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-ocorrencia LIKE rma-ocorrencia.cod-ocorrencia NO-UNDO.
  
    FIND FIRST bfrma-ocorrencia WHERE 
        bfrma-ocorrencia.cod-ocorrencia = pcod-ocorrencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrma-ocorrencia THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrma-ocorrencia)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryCodigo DBOProgram 
PROCEDURE OpenQueryCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if i-tipo-ocorrencia = 4 then 
    OPEN QUERY {&QueryName} FOR EACH rma-ocorrencia where
                                     rma-ocorrencia.cod-ocorrencia   >= c-cod-ocorrencia-ini and 
                                     rma-ocorrencia.cod-ocorrencia   <= c-cod-ocorrencia-fim NO-LOCK INDEXED-REPOSITION.
 else
    OPEN QUERY {&QueryName} FOR EACH rma-ocorrencia where
                                     rma-ocorrencia.cdn-tp-ocorrencia = i-tipo-ocorrencia    and
                                     rma-ocorrencia.cod-ocorrencia   >= c-cod-ocorrencia-ini and 
                                     rma-ocorrencia.cod-ocorrencia   <= c-cod-ocorrencia-fim NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryDescricao DBOProgram 
PROCEDURE OpenQueryDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if i-tipo-ocorrencia = 4 then 
    OPEN QUERY {&QueryName} FOR EACH rma-ocorrencia where
                                     rma-ocorrencia.des-ocorrencia   >= c-des-ocorrencia-ini and 
                                     rma-ocorrencia.des-ocorrencia   <= c-des-ocorrencia-fim NO-LOCK INDEXED-REPOSITION.
 else
    OPEN QUERY {&QueryName} FOR EACH rma-ocorrencia where
                                     rma-ocorrencia.cdn-tp-ocorrencia = i-tipo-ocorrencia    and
                                     rma-ocorrencia.des-ocorrencia   >= c-des-ocorrencia-ini and 
                                     rma-ocorrencia.des-ocorrencia   <= c-des-ocorrencia-fim NO-LOCK INDEXED-REPOSITION.


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
   
    OPEN QUERY {&QueryName} FOR EACH rma-ocorrencia NO-LOCK 
                               by rma-ocorrencia.cod-ocorrencia INDEXED-REPOSITION. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnTipoOcorrencia DBOProgram 
PROCEDURE returnTipoOcorrencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input  param p-c-cod-ocorrencia  like rma-ocorrencia.cod-ocorrencia    no-undo.
def input  param p-cdn-tp-ocorrencia like rma-ocorrencia.cdn-tp-ocorrencia no-undo.
def output param p-c-tipo            as   char                             no-undo.

find first rma-ocorrencia where
           rma-ocorrencia.cod-ocorrencia    = p-c-cod-ocorrencia and
           rma-ocorrencia.cdn-tp-ocorrencia = p-cdn-tp-ocorrencia no-lock no-error.

if avail rma-ocorrencia then
   assign p-c-tipo = {ininc/i01in712.i 04 rma-ocorrencia.cdn-tp-ocorrencia}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodigo DBOProgram 
PROCEDURE setConstraintCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input  param p-c-cod-ocorrencia-ini as char    no-undo.
def input  param p-c-cod-ocorrencia-fim as char    no-undo.
def input  param p-i-tipo-ocorrencia    as integer no-undo.


assign c-cod-ocorrencia-ini = p-c-cod-ocorrencia-ini
       c-cod-ocorrencia-fim = p-c-cod-ocorrencia-fim
       i-tipo-ocorrencia    = p-i-tipo-ocorrencia.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDescricao DBOProgram 
PROCEDURE setConstraintDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input  param p-c-des-ocorrencia-ini as char    no-undo.
def input  param p-c-des-ocorrencia-fim as char    no-undo.
def input  param p-i-tipo-ocorrencia    as integer no-undo.


assign c-des-ocorrencia-ini = p-c-des-ocorrencia-ini
       c-des-ocorrencia-fim = p-c-des-ocorrencia-fim
       i-tipo-ocorrencia    = p-i-tipo-ocorrencia.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    assign c-erro = "".
    
    IF pType = "Create":U then do:
       if RowObject.cod-ocorrencia = "" then
          /* Inicio -- Projeto Internacional */
          DO:
          DEFINE VARIABLE c-lbl-liter-ocorrencia AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Ocorrància" *}
          ASSIGN c-lbl-liter-ocorrencia = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i &ErrorNumber="6216"
                                      &ErrorType="EMS"
                                      &ErrorSubType="ERROR"
                                      &ErrorParameters="c-lbl-liter-ocorrencia"}
          END. 
       else do:
           find first bf{&TableName} where
                      bf{&TableName}.cod-ocorrencia = RowObject.cod-ocorrencia no-lock no-error.
           if avail bf{&TableName} then
             /* Inicio -- Projeto Internacional */
             DO:
             DEFINE VARIABLE c-lbl-liter-ocorrencia-2 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Ocorrància" *}
             ASSIGN c-lbl-liter-ocorrencia-2 = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i &ErrorNumber="8"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="c-lbl-liter-ocorrencia-2"}
             END. .           
       end.
       if RowObject.des-ocorrencia = "" then
          /* Inicio -- Projeto Internacional */
          DO:
          DEFINE VARIABLE c-lbl-liter-descricao-ocorrencia AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Descriá∆o_Ocorrància" *}
          ASSIGN c-lbl-liter-descricao-ocorrencia = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i &ErrorNumber="6216"
                                      &ErrorType="EMS"
                                      &ErrorSubType="ERROR"
                                      &ErrorParameters="c-lbl-liter-descricao-ocorrencia"}
          END. 

    END.
    
    IF pType = "Create":U or pType = "Update":U then do:
       
       /*********** Valida Narrativa *************/

       if Rowobject.ds1-narrativa = "" then
          /* Inicio -- Projeto Internacional */
          DO:
          DEFINE VARIABLE c-lbl-liter-narrativa AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Narrativa" *}
          ASSIGN c-lbl-liter-narrativa = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i &ErrorNumber="25938"
                                      &ErrorType="EMS"
                                      &ErrorSubType="ERROR"
                                      &ErrorParameters="c-lbl-liter-narrativa"}
          END. .                   
    END.
    
    IF pType = "Delete":U then do:       
       if rma-ocorrencia.cdn-tp-ocorrencia = 1 then do:
          find first rma-item where 
                     rma-item.cod-avaliacao = rma-ocorrencia.cod-ocorrencia no-lock no-error.
          if avail rma-item then
             assign c-erro = "RMA".
       end.
       else do:
          if rma-ocorrencia.cdn-tp-ocorrencia = 2 then do:
             find first item-doc-est where 
                        item-doc-est.cod-disposicao = rma-ocorrencia.cod-ocorrencia
                  use-index disposicao no-lock no-error.
             if avail item-doc-est then
                assign c-erro = "RGA".                
             find first rma-item where 
                        rma-item.cod-disposicao = rma-ocorrencia.cod-ocorrencia no-lock no-error.
             if avail rma-item then
                assign c-erro = c-erro + ", RMA".
          end.
          else do:
             find first item-doc-est where 
                        item-doc-est.cod-motivo = rma-ocorrencia.cod-ocorrencia
                  use-index motivo no-lock no-error.
             if avail item-doc-est then
                assign c-erro = "RGA".
             find first rma-item where 
                        rma-item.cod-motivo = rma-ocorrencia.cod-ocorrencia no-lock no-error.
             if avail rma-item then
                assign c-erro = c-erro + ", RMA".
          end.
       end.   
       
       if c-erro <> "" then
          /* Inicio -- Projeto Internacional */
          DO:
          DEFINE VARIABLE c-lbl-liter-ocorrencia-3 AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Ocorrància" *}
          ASSIGN c-lbl-liter-ocorrencia-3 = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i &ErrorNumber="27030"
                                      &ErrorType="EMS"
                                      &ErrorSubType="ERROR"
                                      &ErrorParameters="c-lbl-liter-ocorrencia-3 + '~~~~' + c-erro"}
          END. .

    END.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



