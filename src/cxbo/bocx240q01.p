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

{include/i-prgvrs.i BOCX240Q01 2.00.00.008 } /*** "010008" 11/12/2023 10:13:23 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx240q01 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
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
&GLOBAL-DEFINE DBOName tt-item-embal
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName tt-item-embal
&GLOBAL-DEFINE TableLabel tt-item-embal
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (bocx220.p) est† com as funá‰es de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque S‡ nela foram implementadas as triggers do dicion†rio.
**  Para desabilitar as procedures foram usados os prÇ-processadores abaixo.
**  A procedure validateRecord dessa DBO n∆o deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0
&GLOBAL-DEFINE EXCLUDE-getBatchRecords 0
/*&GLOBAL-DEFINE EXCLUDE-getRowid*/

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/

{dibo/bodi096.i tt-item-embal}
{dibo/bodi096.i tt-item-embal-aux}
{dibo/bodi096.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */

/*---------- Include de PrÇ-Processadores -------------*/
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

def var r-first   as ROWID no-undo.
def var r-last    as ROWID no-undo.
def var r-aux-pri as ROWID no-undo.

def var linha-aux  as int no-undo.
def var i-nrlinhas as int no-undo.

/*--Definiá∆o variaveis usadas nas procedures--*/

def var c-cod-estabel   LIKE estabelec.cod-estabel    no-undo.
def var c-nr-proc-exp   LIKE processo-exp.nr-proc-exp no-undo.
DEF VAR c-it-codigo-ini LIKE item.it-codigo           NO-UNDO.
DEF VAR c-it-codigo-fim LIKE ITEM.it-codigo           NO-UNDO.
DEF VAR c-nr-nota-fis-ini LIKE proc-nota-fiscal.nr-nota-fis NO-UNDO.
DEF VAR c-nr-nota-fis-fim LIKE proc-nota-fiscal.nr-nota-fis NO-UNDO.

def var l-query1 as log no-undo initial no.
def var l-query2 as log no-undo initial no.
def var i-cont as int no-undo.

def var c-rowid as char format "x(10)" no-undo.

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
         HEIGHT             = 2.88
         WIDTH              = 32.14.
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


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField:
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
        WHEN "cod-estabel"   THEN ASSIGN pFieldValue = RowObject.cod-estabel.        
        WHEN "serie"         THEN ASSIGN pFieldValue = RowObject.serie.
        &if defined(bf-dis-comex) &then
        &else
            WHEN "nr-nota-fis"   THEN ASSIGN pFieldValue = RowObject.nr-nota-fis.
        &endif
        WHEN "it-codigo"     THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "sigla-emb"     THEN ASSIGN pFieldValue = RowObject.sigla-emb.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN rowObject.r-rowid = tt-item-embal.r-rowid.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetRowid DBOProgram 
PROCEDURE afterGetRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE input-output PARAMETER pRowid  AS ROWID NO-UNDO.
  
  ASSIGN pRowid = tt-item-embal.r-rowid.
  
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforegetBatchRecords DBOProgram 
PROCEDURE beforegetBatchRecords :
/*------------------------------------------------------------------------------
  Purpose:     Customizada para carregar o rowid da tabela na temptable para 
               poder ser feita a navegaá∆o no browse corretamente. 
  Parameters:  
  Notes: 
------------------------------------------------------------------------------*/

    /*for first tt-item-embal 
        fields(cod-estabel embarque) no-lock
        where tt-item-embal.cod-estabel = rowObject.cod-estabel 
         and tt-item-embal.embarque = rowObject.embarque:
       assign rowObject.r-rowid = tt-item-embal.r-rowid.
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
    end. */
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforerepositionrecord DBOProgram 
PROCEDURE beforerepositionrecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid  AS ROWID NO-UNDO.

    find {&TableName} where {&TableName}.r-rowid = pRowid no-lock no-error.
    if avail {&TableName} then 
       assign pRowid = rowid({&TableName}).

    /*--- Reposiciona query ---*/
    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        /*--- Erro 11: Nío foi poss≠vel reposicionar a query ---*/
        {method/svc/errors/inserr.i &ErrorNumber="11"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}

        RETURN "NOK":U.
    END.
    
    /*--- » necessˇrio para o correto funcionamento do reposicionamento ---*/
    GET NEXT {&QueryName} NO-LOCK.

    /*--- Seta flag indicando que o registro atual foi reposicionado ---*/
    &IF "{&DBType}" = "ORACLE":U &THEN
        ASSIGN lRepositioned = YES.
    &ENDIF
    
    /*--- Atualiza temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.
    
    RETURN "NOK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTable DBOProgram 
PROCEDURE carregaTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-return as char initial "OK" no-undo.

    for each tt-item-embal:
       delete tt-item-embal.
    end.

    FOR EACH proc-nota-fiscal NO-LOCK USE-INDEX ch-proc-exp
        WHERE proc-nota-fiscal.nr-proc-exp = c-nr-proc-exp
          AND proc-nota-fiscal.cod-estabel = c-cod-estabel:

        IF proc-nota-fiscal.nr-nota-fis < c-nr-nota-fis-ini OR
           proc-nota-fiscal.nr-nota-fis > c-nr-nota-fis-fim THEN
           NEXT.

        FOR EACH item-embal NO-LOCK USE-INDEX ch-it-embal
           WHERE item-embal.cod-estabel = proc-nota-fiscal.cod-estab-faturam
            AND  item-embal.serie       = proc-nota-fiscal.serie
            &if defined(bf-dis-comex) &then
                AND string(item-embal.nr-nota-fis) = proc-nota-fiscal.nr-nota-fis:
            &else
                AND item-embal.nr-nota-fis = proc-nota-fiscal.nr-nota-fis:
            &endif
            IF item-embal.it-codigo < c-it-codigo-ini OR
               item-embal.it-codigo > c-it-codigo-fim THEN
                NEXT.
            CREATE tt-item-embal.
            BUFFER-COPY item-embal TO tt-item-embal.
            ASSIGN tt-item-embal.r-rowid = ROWID(item-embal).
        END.
    END.
    
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
        &if defined(bf-dis-comex) &then
        &else
           WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
           WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        &endif
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
        &if defined(bf-dis-comex) &then
            WHEN "nr-nota-fis"   THEN ASSIGN pFieldValue = RowObject.nr-nota-fis.
        &else
        &endif
        WHEN "nr-seq-fat":U    THEN ASSIGN pFieldValue = RowObject.nr-seq-fat.
        WHEN "int-1":U         THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U         THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice COMPRADOR
  Parameters:
               retorna valor dos campos do °ndice COMPRADOR
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
/*    DEFINE OUTPUT PARAMETER pcod-estabel LIKE {&TABLENAME}.cod-estabel   NO-UNDO.
    DEFINE OUTPUT PARAMETER pembarque LIKE {&TABLENAME}.embarque NO-UNDO.
    
    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-estabel  = RowObject.cod-estabel.
    ASSIGN pembarque = RowObject.embarque.*/

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByVencto DBOProgram 
PROCEDURE openQueryByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
    open query {&QUERYNAME} for each tt-item-embal 
                            BY tt-item-embal.it-codigo INDEXED-REPOSITION.        
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByVencto DBOProgram 
PROCEDURE openQueryByNotaFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
    open query {&QUERYNAME} for each tt-item-embal 
                            BY tt-item-embal.nr-nota-fis INDEXED-REPOSITION.        
   
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

    OPEN QUERY {&QueryName} 
        FOR EACH tt-item-embal NO-LOCK 
        INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixa DBOProgram 
PROCEDURE setConstraintFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-cod-estabel   LIKE estabelec.cod-estabel no-undo.
    def input parameter p-nr-proc-exp   LIKE processo-exp.nr-proc-exp no-undo.
    def input parameter p-it-codigo-ini LIKE item.it-codigo no-undo.
    def input parameter p-it-codigo-fim LIKE item.it-codigo no-undo.
    DEF INPUT PARAMETER p-nr-nota-fis-ini LIKE proc-nota-fiscal.nr-nota-fis NO-UNDO.
    DEF INPUT PARAMETER p-nr-nota-fis-fim LIKE proc-nota-fiscal.nr-nota-fis NO-UNDO.
    
    assign c-cod-estabel   = p-cod-estabel
           c-nr-proc-exp   = p-nr-proc-exp
           c-it-codigo-ini = p-it-codigo-ini 
           c-it-codigo-fim = p-it-codigo-fim
           c-nr-nota-fis-ini = p-nr-nota-fis-ini
           c-nr-nota-fis-fim = p-nr-nota-fis-fim.

    run carregatable.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintquery DBOProgram 
PROCEDURE setConstraintquery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Quando o zoom Ç executado o browse abre sem registros, esta setconstraint
         atualiza as vari†veis l-query1 e l-query2 que servir∆o de paramentro para
         abertura das querys.      
------------------------------------------------------------------------------*/

 def input parameter p-query1 as log.
 def input parameter p-query2 as log.

 assign l-query1  = p-query1
        l-query2  = p-query2.
 
      RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecords Method-Library 
PROCEDURE getBatchRecords :
/*------------------------------------------------------------------------------
  Purpose:     Retorna faixa de registros da query atrav≤s da 
               temptable RowObjectAux 
  Parameters:  recebe rowid inicial
               recebe flag indicando a execuªío de novo GET NEXT
               recebe número de linhas a serem retornadas
               retorna número de linhas retornadas
               retorna temptable RowObjectAux
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pRowid        AS ROWID   NO-UNDO.
    DEFINE INPUT  PARAMETER pNext         AS LOGICAL NO-UNDO.
    DEFINE INPUT  PARAMETER pRowsToReturn AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pRowsReturned AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectAux.
    
&IF "{&ROW-NUM-DEFINED}" = "YES" &THEN
    DEFINE VARIABLE iNextSeq AS INTEGER NO-UNDO INIT 0.
&ENDIF
    
    /*--- Verifica permissío de execuªío ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    
    /*--- Limpa temptable RowObjectAux ---*/
    RUN emptyRowObjectAux IN THIS-PROCEDURE.
    
    IF pRowid <> ? THEN DO:
/*        /*--- Reposiciona a query pelo rowid (repositionRecord) ---*/
 *         RUN repositionRecord IN THIS-PROCEDURE (INPUT pRowid).
 *         IF RETURN-VALUE = "NOK":U THEN
 *             RETURN "NOK":U.*/
        
        /* customizaá∆o */
        
        for first tt-item-embal fields(cod-estabel embarque)
             WHERE tt-item-embal.r-rowid = pRowid.
        end.
        if avail tt-item-embal then 
            ASSIGN pRowid = rowid(tt-item-embal).
 
/*         for first tt-item-embal fields(cod-estabel embarque)
             WHERE tt-item-embal.r-rowid = pRowid.
               ASSIGN pRowid = tt-item-embal.r-rowid.
        end.*/
        
        REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            &IF "{&NewRecordOffQuery}" = "YES" &THEN
                GET FIRST {&QueryName} NO-LOCK.
                ASSIGN pRowid = rowid({&TableName}).
                REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
                IF ERROR-STATUS:ERROR THEN do:
                    RETURN "NOK":U.
                end.
            &ELSE
                RETURN "NOK":U.
            &ENDIF
        END.
        
        GET NEXT {&QueryName} NO-LOCK.
        
        /*--- Este teste torna-se necessˇrio devido ao fato de realizar-se um 
              reposicionamento de um registro rec≤m eliminado. Neste caso nío ≤ 
              retornado erro no comando REPOSITION, pois o reposicionamento da
              QUERY ≤ processado com base no RESULT-LIST ---*/
        IF NOT AVAILABLE {&TableName} THEN
            RETURN "NOK":U.
    END.
    
    IF pNext THEN DO:
/*        /*--- Posicina no prΩximo registro, conforme flag de par≥metro (getNext) ---*/
 *         RUN getNext IN THIS-PROCEDURE.
 *         IF RETURN-VALUE = "NOK":U THEN
 *             RETURN "NOK":U.*/
        
        GET NEXT {&QueryName} NO-LOCK.
    END.
    
    /*--- Grava temptable RowObjectAux ---*/
    DO WHILE AVAILABLE({&TableName}):
        IF pRowsToReturn <> 0 AND pRowsReturned >= pRowsToReturn THEN
            LEAVE.
        
        /*--- Atualiza temptable RowObject ---*/
        RUN _copyBuffer2TT IN THIS-PROCEDURE.
    &IF "{&ROW-NUM-DEFINED}" = "YES" &THEN
        ASSIGN iNextSeq = iNextSeq + 1
               RowObject.RowNum = iNextSeq.
    &ENDIF
        
        /*--- Executa m≤todos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="before"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /*--- Copia o registro da temptable RowObject para a temptable RowObjectAux ---*/
        CREATE RowObjectAux.
        BUFFER-COPY RowObject TO RowObjectAux.
        
        ASSIGN pRowsReturned = pRowsReturned + 1.
        
        /*--- Executa m≤todos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="after"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
/*        /*--- Posicina no prΩximo registro (getNext) ---*/
 *         RUN getNext IN THIS-PROCEDURE.
 *         IF RETURN-VALUE = "NOK":U AND
 *            NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorNumber = 10) THEN
 *             RETURN "NOK":U.*/
        
        GET NEXT {&QueryName}.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
