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
{include/i-prgvrs.i BOIN042O 2.00.00.008 } /*** "010008" 27/10/2023 17:03:41  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN042O MUT}
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
&GLOBAL-DEFINE DBOName BOIN042
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName centro-custo
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin042o.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 13.17
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
        WHEN "cc-codigo":U THEN ASSIGN pFieldValue = RowObject.cc-codigo.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "conta-contabil[1]":U THEN ASSIGN pFieldValue = RowObject.conta-contabil[1].
        WHEN "conta-contabil[2]":U THEN ASSIGN pFieldValue = RowObject.conta-contabil[2].
        WHEN "conta-contabil[3]":U THEN ASSIGN pFieldValue = RowObject.conta-contabil[3].
        WHEN "conta-contabil[4]":U THEN ASSIGN pFieldValue = RowObject.conta-contabil[4].
        WHEN "conta-contabil[5]":U THEN ASSIGN pFieldValue = RowObject.conta-contabil[5].
        WHEN "conta-contabil[6]":U THEN ASSIGN pFieldValue = RowObject.conta-contabil[6].
        WHEN "conta-mob":U THEN ASSIGN pFieldValue = RowObject.conta-mob.
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
        WHEN "sc-codigo[1]":U THEN ASSIGN pFieldValue = RowObject.sc-codigo[1].
        WHEN "sc-codigo[2]":U THEN ASSIGN pFieldValue = RowObject.sc-codigo[2].
        WHEN "sc-codigo[3]":U THEN ASSIGN pFieldValue = RowObject.sc-codigo[3].
        WHEN "sc-codigo[4]":U THEN ASSIGN pFieldValue = RowObject.sc-codigo[4].
        WHEN "sc-codigo[5]":U THEN ASSIGN pFieldValue = RowObject.sc-codigo[5].
        WHEN "sc-codigo[6]":U THEN ASSIGN pFieldValue = RowObject.sc-codigo[6].
        WHEN "sc-mob":U THEN ASSIGN pFieldValue = RowObject.sc-mob.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "horas-dispon":U THEN ASSIGN pFieldValue = RowObject.horas-dispon.
        WHEN "horas-homem":U THEN ASSIGN pFieldValue = RowObject.horas-homem.
        WHEN "horas-maq":U THEN ASSIGN pFieldValue = RowObject.horas-maq.
        WHEN "horas-padrao":U THEN ASSIGN pFieldValue = RowObject.horas-padrao.
        WHEN "horas-prod":U THEN ASSIGN pFieldValue = RowObject.horas-prod.
        WHEN "horas-report":U THEN ASSIGN pFieldValue = RowObject.horas-report.
        WHEN "nr-up-report":U THEN ASSIGN pFieldValue = RowObject.nr-up-report.
        WHEN "tot-hora-hom":U THEN ASSIGN pFieldValue = RowObject.tot-hora-hom.
        WHEN "tot-hora-maq":U THEN ASSIGN pFieldValue = RowObject.tot-hora-maq.
        WHEN "val-unit-up[1]":U THEN ASSIGN pFieldValue = RowObject.val-unit-up[1].
        WHEN "val-unit-up[2]":U THEN ASSIGN pFieldValue = RowObject.val-unit-up[2].
        WHEN "val-unit-up[3]":U THEN ASSIGN pFieldValue = RowObject.val-unit-up[3].
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
        WHEN "forma-abs[1]":U THEN ASSIGN pFieldValue = RowObject.forma-abs[1].
        WHEN "forma-abs[2]":U THEN ASSIGN pFieldValue = RowObject.forma-abs[2].
        WHEN "forma-abs[3]":U THEN ASSIGN pFieldValue = RowObject.forma-abs[3].
        WHEN "forma-abs[4]":U THEN ASSIGN pFieldValue = RowObject.forma-abs[4].
        WHEN "forma-abs[5]":U THEN ASSIGN pFieldValue = RowObject.forma-abs[5].
        WHEN "forma-abs[6]":U THEN ASSIGN pFieldValue = RowObject.forma-abs[6].
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
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
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo cc-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcc-codigo LIKE centro-custo.cc-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo cc-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcc-codigo LIKE centro-custo.cc-codigo NO-UNDO.

    FIND FIRST bfcentro-custo WHERE 
        bfcentro-custo.cc-codigo = pcc-codigo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcentro-custo THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcentro-custo)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
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
    /** Validaá‰es de Frotas **/
    run validateCentroCusto in h-abapi008 (INPUT RowObject.cc-codigo).
    if return-value = "NOK":U then do:
        empty temp-table RowErrorsFrotas.
        /** Busca os erros ocorridos em frotas **/
        run getRowErrors in h-abapi008 (output table RowErrorsFrotas).
        assign iErro = 0.
        /** Se ocorreram erros noproduto padr∆o, busca a £ltima sequància **/
        for last RowErrors no-lock:
            assign iErro = RowErrors.ErrorSequence.
        end.
        /** Percorre os erros ocorridos em frotas **/
        for each RowErrorsFrotas no-lock:
            /** Cria os erros no produto padr∆o **/
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
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    def var c-centro as char no-undo.

    {utp/ut-table.i mgind centro-custo 1}
    assign c-centro = return-value.

    /*--- Utilize o par≥metro pType para identificar quais as validaªÑes a serem
          executadas ---*/
    /*--- Os valores poss≠veis para o par≥metro sío: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav≤s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaªÑes ---*/


    if pType = "CREATE":U then do:
        if can-find(centro-custo where centro-custo.cc-codigo = RowObject.cc-codigo) then do:
            {utp/ut-table.i mgind centro-custo 1}
            {method/svc/errors/inserr.i &ErrorNumber="7"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        end.
    end.


    if pType = "DELETE":U then do:
        run validateDeleteFrotas in this-procedure.
    end.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

