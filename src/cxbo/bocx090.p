/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX090 2.00.00.023 } /*** "010023" 27/11/2023 16:32:27  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx090 MUT}
&ENDIF

/*
               KSV Editor
    Copyright: (C) 2000-2001 Serguey Klimoff (bulkl0DD)
     Filename: CXBO~\BOCX090.P
      Comment: <comment>
   Parameters:
         Uses:
      Used by:
      Created: 21.06.2004 15:03 LOG13165
     Modified: 21.06.2004 15:26 LOG13165 
     Modified: 
*/

&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
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
&GLOBAL-DEFINE DBOName BOCX090
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName docum-est-cex
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

{cdp/cdcfgmat.i} /* Definicao de pre-processadores */

def var l-inclusao           as log            no-undo.
def var l-despesa-isenta     as log initial no no-undo.

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx090.i RowObject}
{utp/ut-glob.i}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var i-cod-emitente      as int                           no-undo.
def var c-serie-docto       as char                          no-undo.
def var c-nro-docto         as char                          no-undo.
def var c-nat-operacao      as char                          no-undo.
DEFINE VARIABLE h-cdapi050 AS HANDLE      NO-UNDO.

{cdp/cd4300.i3} /* tratamento atributo livre */

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
         HEIGHT             = 10.63
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaItens DBOProgram 
PROCEDURE atualizaItens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*/*
 * ** Atualiza as despesas (rateio) do item-doc-est-cex, item-doc-est e docum-est
 * */
 *     def input  parameter r-row  as rowid   no-undo.
 *     def input  parameter de-val as decimal no-undo.
 *     
 *     def var h-im9028 as handle no-undo.
 *     
 *     RUN imp/im9028.p persistent set h-im9028.
 *     run pi-atualizaItens in h-im9028 (input r-row, input de-val).    
 *     delete procedure h-im9028. */   

    return "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRelacDocum-est DBOProgram 
PROCEDURE deleteRelacDocum-est :
/*------------------------------------------------------------------------------
  Purpose: Eliminar as despesas relativas ao Documento de Entrada que est† sendo eliminado    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-serie-docto  like docum-est.serie-docto   no-undo.
    def input parameter p-nro-docto    like docum-est.nro-docto    no-undo.
    def input parameter p-cod-emitente like docum-est.cod-emitente no-undo.
    def input parameter p-nat-operacao like docum-est.nat-operacao no-undo.
    
    for each bf{&TableName}
        where bf{&TableName}.serie-docto  = p-serie-docto 
          and bf{&TableName}.nro-docto    = p-nro-docto
          and bf{&TableName}.cod-emitente = p-cod-emitente
          and bf{&TableName}.nat-operacao = p-nat-operacao no-lock:
        find {&TableName} 
            where rowid({&TableName}) = rowid(bf{&TableName}) exclusive-lock no-error.
        delete {&TableName}.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executeUpdate DBOProgram 
PROCEDURE executeUpdate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* run updateRecord.*/

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

   RUN pi-save-siscosrv.

   RETURN "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   RUN pi-save-siscosrv.

   RETURN "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-cdapi050) THEN
        RUN cdp/cdapi050.p PERSISTENT SET h-cdapi050.

    FOR FIRST docum-est FIELDS(cod-estabel)
              WHERE docum-est.serie-docto  = rowObject.serie-docto 
              AND   docum-est.nro-docto    = rowObject.nro-docto   
              AND   docum-est.cod-emitente = rowObject.cod-emitente
              AND   docum-est.nat-operacao = rowObject.nat-operacao NO-LOCK:
        
        RUN pi-apaga-nota-import-sis IN h-cdapi050 (INPUT  rowObject.serie-docto,
                                                    INPUT  rowObject.nro-docto,
                                                    INPUT  rowObject.nat-operacao,
                                                    INPUT  docum-est.cod-estabel,
                                                    INPUT  STRING(rowObject.cod-emitente-desp),
                                                    INPUT  2).
    END.

    IF VALID-HANDLE(h-cdapi050) THEN DO:
        DELETE PROCEDURE h-cdapi050.
        ASSIGN h-cdapi050 = ?.
    END.
    RETURN "OK":U.
   
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
/*    /*
 *     **  Procura pelo indice, caso nao ache,
 *     **  retorna mensagem de erro padrao do EMS.
 *     */
 *     def input parameter c-serie-docto as char no-undo.
 *     def input parameter c-nro-docto as char no-undo.
 *     def input parameter i-cod-emitente as inte no-undo.
 *     def input parameter c-nat-operacao as char no-undo.
 *     def input parameter i-cod-emitente-desp as inte no-undo.
 *     def input parameter i-cod-desp as inte no-undo.
 *     def output parameter c-return as char no-undo.    
 * 
 *     run goToKey (c-serie-docto,
 *                  c-nro-docto,
 *                  i-cod-emitente,
 *                  c-nat-operacao,
 *                  i-cod-emitente-desp,
 *                  i-cod-desp ).
 *     
 *     if return-value = "NOK":U then 
 *        assign c-return = "NOK":U.
 *     else 
 *        assign c-return = "".*/
                 
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCotacao DBOProgram 
PROCEDURE findCotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*/*
 * ** Acha a cotacao da moeda para a data atual.
 * */
 *     def input  parameter da-dt-trans like docum-est.dt-trans no-undo.
 *     def input  parameter c-moeda like docum-est-cex.mo-codigo no-undo.
 *     def output parameter de-cotacao as decimal init 0.
 *     
 *     def var c-periodo like cotacao.ano-periodo no-undo.    
 *              
 *     assign c-periodo = string(year(da-dt-trans), "9999") + 
 *                        string(month(da-dt-trans), "99" ).    
 *     find cotacao
 *          where cotacao.mo-codigo = c-moeda
 *          and   cotacao.ano-periodo = c-periodo no-lock no-error.
 *     if  avail cotacao then do:
 *         assign de-cotacao = cotacao.cotacao[day(da-dt-trans)].
 *     end.
 *     else 
 *         assign de-cotacao = 1.*/

   return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDesp_Imp DBOProgram 
PROCEDURE findDesp_Imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /***  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter i-cod-desp as inte no-undo.
    def output parameter c-return as char no-undo.        
 
    find docum-est-cex where docum-est-cex.cod-desp = i-cod-desp no-lock no-error.
    if not avail {&TABLENAME} then do:
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */

        /******************************************/
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-despesas-do-documento AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Despesas_do_documento" *}
        ASSIGN c-lbl-liter-despesas-do-documento = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2" 
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters = "c-lbl-liter-despesas-do-documento" } 
        assign c-return = "NOK":U.                            
    end.
    else do:
        run _copyBuffer2TT.
    end.
 
 
    return "OK":U.
    
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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cotacao":U THEN ASSIGN pFieldValue = RowObject.cotacao.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "val-desp":U THEN ASSIGN pFieldValue = RowObject.val-desp.
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
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-desp":U THEN ASSIGN pFieldValue = RowObject.cod-desp.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-emitente-desp":U THEN ASSIGN pFieldValue = RowObject.cod-emitente-desp.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
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
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo cod-emitente-desp
               retorna valor do campo cod-desp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE docum-est-cex.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE docum-est-cex.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE docum-est-cex.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE docum-est-cex.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente-desp LIKE docum-est-cex.cod-emitente-desp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-desp LIKE docum-est-cex.cod-desp NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pcod-emitente-desp = RowObject.cod-emitente-desp
           pcod-desp = RowObject.cod-desp.

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
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo cod-emitente-desp
               recebe valor do campo cod-desp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE docum-est-cex.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE docum-est-cex.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE docum-est-cex.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE docum-est-cex.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente-desp LIKE docum-est-cex.cod-emitente-desp NO-UNDO.
    DEFINE INPUT PARAMETER pcod-desp LIKE docum-est-cex.cod-desp NO-UNDO.

    FIND FIRST bfdocum-est-cex WHERE 
        bfdocum-est-cex.serie-docto = pserie-docto AND 
        bfdocum-est-cex.nro-docto = pnro-docto AND 
        bfdocum-est-cex.cod-emitente = pcod-emitente AND 
        bfdocum-est-cex.nat-operacao = pnat-operacao AND 
        bfdocum-est-cex.cod-emitente-desp = pcod-emitente-desp AND 
        bfdocum-est-cex.cod-desp = pcod-desp NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocum-est-cex THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocum-est-cex)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linktoDocumEst DBOProgram 
PROCEDURE linktoDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter pHandle as handle no-undo.
    
    run getKey in pHandle ( output i-cod-emitente,
                            output c-serie-docto,
                            output c-nro-docto,
                            output c-nat-operacao ).
                            
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
    define input parameter i-abertura as integer no-undo.
    
    case i-abertura:
        when 1 then 
           run openQueryStatic ("Main":U).                
        when 2 then
           run openQueryStatic ("OfDocum":U). 
    end case.
    
    Return "OK":U.

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

open query {&QUERYNAME} for each {&TABLENAME} no-lock indexed-reposition.


Return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocum DBOProgram 
PROCEDURE openQueryOfDocum :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} no-lock where 
                                     {&TABLENAME}.nro-docto = c-nro-docto and                                         
                                 {&TABLENAME}.nat-operacao  = c-nat-operacao and
                                 {&TABLENAME}.serie-docto   = c-serie-docto and
                                 {&TABLENAME}.cod-emitente  = i-cod-emitente indexed-reposition. 

                                            
    Return "OK":U.                                 
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
    def input parameter r-chave as rowid no-undo.
  
 /*   find docum-est where rowid(docum-est) = r-chave no-lock no-error. */
    
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRowidDocumEst DBOProgram 
PROCEDURE setRowidDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param rwDocumEst  as rowid no-undo.

    for first docum-est
        fields ( cod-emitente    serie-docto     
                 nro-docto       nat-operacao
                 cod-estabel     usuario
                 dt-emissao      tot-valor  )
        where rowid(docum-est) = rwDocumEst no-lock:
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCodigo DBOProgram 
PROCEDURE validateCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
** Valida o formato e o tipo de valor que esta sendo preenchido.
*/
    def input-output parameter c-cod-emitente-desp as char no-undo.
    def input-output parameter c-cod-desp          as char no-undo.
    def input-output parameter c-val-desp          as char no-undo.
    def input-output parameter c-mo-codigo         as char no-undo.            
    
    def var i-teste1 as integer no-undo.
    def var i-teste2 as integer no-undo.
    def var i-teste3 as integer no-undo.
    def var i-teste4 as integer no-undo.
    
    assign i-teste1 = int(c-cod-emitente-desp) no-error.
    if  error-status:error then do:
        assign c-cod-emitente-desp = "0".
       /* Inicio -- Projeto Internacional */
       DEFINE VARIABLE c-lbl-liter-fornec-despesa AS CHARACTER NO-UNDO.
       {utp/ut-liter.i "Fornecedor_da_Despesa" *}
       ASSIGN c-lbl-liter-fornec-despesa = TRIM(RETURN-VALUE).
       {method/svc/errors/inserr.i
                             &ErrorNumber="16963" 
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters = "c-lbl-liter-fornec-despesa" }      

    end.    
    assign i-teste2 = int(c-cod-desp) no-error.
    if  error-status:error then do:
        assign c-cod-desp = "0".
      /* Inicio -- Projeto Internacional */
      DEFINE VARIABLE c-lbl-liter-codigo-despesa AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "C¢digo_Despesa" *}
      ASSIGN c-lbl-liter-codigo-despesa = TRIM(RETURN-VALUE).
      {method/svc/errors/inserr.i
                             &ErrorNumber="16963" 
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters = "c-lbl-liter-codigo-despesa" }    
    end.          
    assign i-teste3 = int(c-val-desp) no-error.
    if  error-status:error then do:
        assign c-val-desp = "0".

      /* Inicio -- Projeto Internacional */
      DEFINE VARIABLE c-lbl-liter-valor-despesa AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "Valor_Despesa" *}
      ASSIGN c-lbl-liter-valor-despesa = TRIM(RETURN-VALUE).
      {method/svc/errors/inserr.i
                             &ErrorNumber="16963" 
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters = "c-lbl-liter-valor-despesa" }    
    end.    
    assign i-teste4 = int(c-mo-codigo) no-error.
    if  error-status:error then do:
        assign c-mo-codigo = "0".

      /* Inicio -- Projeto Internacional */
      DEFINE VARIABLE c-lbl-liter-moeda AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "Moeda" *}
      ASSIGN c-lbl-liter-moeda = TRIM(RETURN-VALUE).
      {method/svc/errors/inserr.i
                             &ErrorNumber="16963" 
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters = "c-lbl-liter-moeda" }    
    end.
              
   IF CAN-FIND(FIRST RowErrors) THEN
      RETURN "NOK":U.
              
   return "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateDesp DBOProgram 
PROCEDURE validateCreateDesp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* valida apenas os valores do emitente da despesa e da despesa*/

def input parameter p-cod-emitente-desp like emitente.cod-emitente  no-undo.
def input parameter p-cod-desp          like desp-imp.cod-desp      no-undo.
def input parameter p-val-desp          like docum-est-cex.val-desp no-undo.

    if p-cod-desp = 0 then do:
       /* Inicio -- Projeto Internacional */
       DEFINE VARIABLE c-lbl-liter-codigo-despesa-2 AS CHARACTER NO-UNDO.
       {utp/ut-liter.i "C¢digo_Despesa" *}
       ASSIGN c-lbl-liter-codigo-despesa-2 = TRIM(RETURN-VALUE).
       {method/svc/errors/inserr.i
                             &ErrorNumber="265" 
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters = "c-lbl-liter-codigo-despesa-2" }                       
    end.
    else do:
       if not can-find(desp-imp where desp-imp.cod-desp = p-cod-desp) then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-codigo-despesa-3 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "C¢digo_Despesa" *}
            ASSIGN c-lbl-liter-codigo-despesa-3 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                             &ErrorNumber="2" 
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters = "c-lbl-liter-codigo-despesa-3" }  
                             
       end.           
    end. 
    
    if p-cod-emitente-desp = 0 then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-fornec-despesa-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Fornecedor_da_Despesa" *}
        ASSIGN c-lbl-liter-fornec-despesa-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                             &ErrorNumber="7965" 
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters = "c-lbl-liter-fornec-despesa-2" }  
    end.
    else do:
        for first emitente fields(identific)
            where emitente.cod-emitente = p-cod-emitente-desp no-lock:
            if emitente.identific = 1 then do:
                {method/svc/errors/inserr.i
                                 &ErrorNumber="8738" 
                                 &ErrorType="EMS"
                                 &ErrorSubType="ERROR"}  
            end.        end.
        if not avail emitente then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-fornec-despesa-3 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Fornecedor_da_Despesa" *}
            ASSIGN c-lbl-liter-fornec-despesa-3 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                             &ErrorNumber="2" 
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters = "c-lbl-liter-fornec-despesa-3" }  
                                      
        end.
    end.
   
    IF CAN-FIND(FIRST RowErrors) THEN
      RETURN "NOK":U.

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
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
          
    /*--- Inclua aqui as validaá‰es ---*/
    {rep/re1001a.i50} /* tratamento atributo livre docum-est.char-1 */
  
    if pType = "Create" then do:
    
        for first docum-est fields(cod-estabel char-1)
            where docum-est.serie-docto  = rowObject.serie-docto 
              and docum-est.nro-docto    = rowObject.nro-docto
              and docum-est.cod-emitente = rowObject.cod-emitente
              and docum-est.nat-operacao = rowObject.nat-operacao no-lock:
            {cdp/cd4300.i4 "yes" docum-est.char-1}
            {rep/re1001a.i51 "yes"}
        end.
        
        if not avail docum-est then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-documento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Documento" *}
            ASSIGN c-lbl-liter-documento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                              &ErrorNumber="2" 
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR"
                              &ErrorParameters = "c-lbl-liter-documento" }
        end.    

        for first estabelec fields(pais)
            where estabelec.cod-estabel = docum-est.cod-estabel no-lock:
        end.

        for first natur-oper fields(nota-rateio)
            where natur-oper.nat-operacao = rowObject.nat-operacao no-lock:
        end.
        
        for first emitente fields(identific natureza pais)
            where emitente.cod-emitente = rowObject.cod-emitente no-lock:
            
            if c-embarque = "" then do:
              if (emitente.natureza <> 3 and emitente.natureza <> 4) then do:
                  {method/svc/errors/inserr.i
                                   &ErrorNumber="15196" 
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"}                       
              end.

              /*
              Quando o documento for de importacao com natureza de operacao em branco
              nao deve realizar esta validacao para o pais diferente de BRASIL.
              */
              if avail natur-oper and natur-oper.nota-rateio = NO then do:
                 IF i-pais-impto-usuario <> 1 THEN
                     if avail estabelec and
                        emitente.pais = estabelec.pais then do:
                        {method/svc/errors/inserr.i
                                          &ErrorNumber="27238"
                                          &ErrorType="EMS"
                                          &ErrorSubType="ERROR"}
                     end.
              end.

            end.
        end.        

    
        run validateCreatedesp (input rowObject.cod-emitente-desp,
                                input rowObject.cod-desp,
                                input rowObject.val-desp).
    
        find bfdocum-est-cex 
                where bfdocum-est-cex.serie-docto       = rowObject.serie-docto
                  and bfdocum-est-cex.nro-docto         = rowObject.nro-docto
                  and bfdocum-est-cex.cod-emitente      = rowObject.cod-emitente
                  and bfdocum-est-cex.nat-operacao      = rowObject.nat-operacao
                  and bfdocum-est-cex.cod-emitente-desp = rowObject.cod-emitente-desp
                  and bfdocum-est-cex.cod-desp          = rowObject.cod-desp  no-lock no-error.
        if avail bfdocum-est-cex then do:
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-despesas-do-documento-2 AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "Despesas_do_Documento" *}
                 ASSIGN c-lbl-liter-despesas-do-documento-2 = TRIM(RETURN-VALUE).
                 {method/svc/errors/inserr.i
                                 &ErrorNumber="8" 
                                 &ErrorType="EMS"
                                 &ErrorSubType="ERROR"
                                 &ErrorParameters = "c-lbl-liter-despesas-do-documento-2" }  
        end.
    end.  /* PType = "Create" */ 

    if pType = "Update" then do:
        &if "{&bf_mat_versao_ems}" >= "2.04" &then
            if rowObject.val-desp < {&TABLENAME}.val-desp then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-a-despesa-esta-sendo-modificad AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "A_despesa_est†_sendo_modificada_para_um_valor_menor" *}
                ASSIGN c-lbl-liter-a-despesa-esta-sendo-modificad = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-a-despesa-esta-sendo-modificad-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "A_despesa_est†_sendo_modificada_para_um_valor_menor,_por_este_motivo,_sugere-se_a_modificaá∆o_do_status_da_despesa_no_embarque_para_n∆o_recebida" *}
                ASSIGN c-lbl-liter-a-despesa-esta-sendo-modificad-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="15825" 
                    &ErrorType="EMS"
                    &ErrorSubType="Information"
                    &ErrorDescription = c-lbl-liter-a-despesa-esta-sendo-modificad + '.'
                    &ErrorHelp = c-lbl-liter-a-despesa-esta-sendo-modificad-2 + '.'
                    &ErrorParameters = "''" }                            
            end.
    &endif

    end. /*pType = "Update"*/                       

    FIND FIRST desp-imp NO-LOCK
           WHERE desp-imp.cod-desp = rowObject.cod-desp NO-ERROR.
    IF AVAIL desp-imp THEN
        ASSIGN l-despesa-isenta = desp-imp.inc-despesa-nota.

    if rowObject.val-desp = 0 and l-despesa-isenta = no then do:
       /* Inicio -- Projeto Internacional */
       DEFINE VARIABLE c-lbl-liter-valor-despesa-2 AS CHARACTER NO-UNDO.
       {utp/ut-liter.i "Valor_Despesa" *}
       ASSIGN c-lbl-liter-valor-despesa-2 = TRIM(RETURN-VALUE).
       {method/svc/errors/inserr.i
                            &ErrorNumber="265" 
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters = "c-lbl-liter-valor-despesa-2" }                            
    end.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    Return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEmitenteDesp DBOProgram 
PROCEDURE getEmitenteDesp :

    DEF INPUT  PARAM c-serie     AS CHAR FORMAT "x(5)".
    DEF INPUT  PARAM c-nro-docto AS CHAR FORMAT "x(16)".
    DEF INPUT  PARAM i-cod-emit  AS INT  FORMAT ">>>>>>>>9".
    DEF INPUT  PARAM c-nat-oper  AS CHAR FORMAT "x(6)".
    DEF INPUT  PARAM c-cod-desp  AS CHAR FORMAT "x(12)".
    DEF OUTPUT PARAM i-emit-desp AS INT  FORMAT ">>>>>>>>9".
    
    for first docum-est-cex 
        where docum-est-cex.serie-docto      = c-serie     and
              docum-est-cex.nro-docto        = c-nro-docto and
              docum-est-cex.cod-emitente     = i-cod-emit  and
              docum-est-cex.nat-operacao     = c-nat-oper  and
              docum-est-cex.cod-desp         = INT(c-cod-desp) no-lock:
    end.
    
    IF AVAIL docum-est-cex  THEN
        ASSIGN i-emit-desp =  docum-est-cex.cod-emitente-desp.

 Return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-save-siscosrv DBOProgram 
PROCEDURE pi-save-siscosrv :

  /*** Siscoserv ***/  
  IF CAN-FIND( FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = docum-est-cex.cod-emitente-desp
                 AND   UPPER(emitente.pais) <> "BRASIL":U) THEN DO: /*forncedor ≤ extrangeiro*/ 
      
      IF NOT VALID-HANDLE(h-cdapi050) THEN
          RUN cdp/cdapi050.p PERSISTENT SET h-cdapi050.

      RUN pi-siscoserv-ativo IN h-cdapi050.
      IF RETURN-VALUE = "OK":U THEN
          FOR FIRST docum-est FIELDS(cod-estabel dt-emissao)
              WHERE docum-est.serie-docto  = rowObject.serie-docto 
              AND   docum-est.nro-docto    = rowObject.nro-docto   
              AND   docum-est.cod-emitente = rowObject.cod-emitente
              AND   docum-est.nat-operacao = rowObject.nat-operacao NO-LOCK:

              RUN pi-grava-nota-import-sis IN h-cdapi050 (INPUT  rowObject.serie-docto,
                                                          INPUT  rowObject.nro-docto,
                                                          INPUT  rowObject.nat-operacao,
                                                          INPUT  docum-est.cod-estabel,
                                                          INPUT  STRING(rowObject.cod-emitente-desp),
                                                          INPUT  rowObject.cod-desp,
                                                          INPUT  2,
                                                          INPUT  docum-est.dt-emissao,
                                                          INPUT  rowObject.cod-emitente).
          END.
  END.

  IF VALID-HANDLE(h-cdapi050) THEN DO:
      DELETE PROCEDURE h-cdapi050.
      ASSIGN h-cdapi050 = ?.
  END.
  /*** Siscoserv ***/

 RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
