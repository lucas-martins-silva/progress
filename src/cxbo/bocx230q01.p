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
{include/i-prgvrs.i BOCX230Q01 2.00.00.001} /*** "010001" 11/12/2023 10:13:23 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX230Q01 MUT}
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

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName tt-historico-embarque
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName tt-historico-embarque
&GLOBAL-DEFINE TableLabel tt-historico-embarque
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (bocx230a.p) est  com as fun‡äes de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque Sà nela foram implementadas as triggers do dicion rio.
**  Para desabilitar as procedures foram usados os pr‚-processadores abaixo.
**  A procedure validateRecord dessa DBO nÆo deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0
&GLOBAL-DEFINE EXCLUDE-getBatchRecords 0
/*&GLOBAL-DEFINE EXCLUDE-getRowid*/

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/

{cxbo/bocx230.i tt-historico-embarque}
{cxbo/bocx230.i tt-historico-embarque-aux}
{cxbo/bocx230.i RowObject}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */

/*---------- Include de Pr‚-Processadores -------------*/
{cdp/cdcfgmat.i}


def var r-first   as ROWID no-undo.
def var r-last    as ROWID no-undo.
def var r-aux-pri as ROWID no-undo.

def var linha-aux  as int no-undo.
def var i-nrlinhas as int no-undo.

/*--Defini‡Æo variaveis usadas nas procedures--*/

def var c-est-ini as char  no-undo.
def var c-est-fim  as char no-undo.
def var c-emb-ini  as char no-undo.
def var c-emb-fim  as char no-undo.
def var i-iti-ini as int no-undo.
def var i-iti-fim as int no-undo.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-estabel"   THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "embarque"      THEN ASSIGN pFieldValue = RowObject.embarque.
        WHEN "char-2"        THEN ASSIGN pFieldValue = RowObject.char-2.
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
ASSIGN rowObject.r-rowid = tt-historico-embarque.r-rowid.

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
  
  ASSIGN pRowid = tt-historico-embarque.r-rowid.
  
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforegetBatchRecords DBOProgram 
PROCEDURE beforegetBatchRecords :
/*------------------------------------------------------------------------------
  Purpose:     Customizada para carregar o rowid da tabela na temptable para 
               poder ser feita a navega‡Æo no browse corretamente. 
  Parameters:  
  Notes: 
------------------------------------------------------------------------------*/

    /*for first tt-historico-embarque 
        fields(cod-estabel embarque) no-lock
        where tt-historico-embarque.cod-estabel = rowObject.cod-estabel 
         and tt-historico-embarque.embarque = rowObject.embarque:
       assign rowObject.r-rowid = tt-historico-embarque.r-rowid.
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
        /*--- Erro 11: N’o foi poss­vel reposicionar a query ---*/
        {method/svc/errors/inserr.i &ErrorNumber="11"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}

        RETURN "NOK":U.
    END.
    
    /*--- È necessÿrio para o correto funcionamento do reposicionamento ---*/
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

    for each tt-historico-embarque:
       delete tt-historico-embarque.
    end.    

/* carrega temptable espec¡fica para zoom z10cx230 */
     for each estabelec 
        where estabelec.cod-estabel >= c-est-ini and
              estabelec.cod-estabel <= c-est-fim 
              no-lock:
        for each historico-embarque
           where historico-embarque.cod-estabel = estabelec.cod-estabel and
                 historico-embarque.embarque >= c-emb-ini   and
                 historico-embarque.embarque <= c-emb-fim   and
                 historico-embarque.cod-itiner >= i-iti-ini and
                 historico-embarque.cod-itiner <= i-iti-fim
                 no-lock:
             find first tt-historico-embarque 
                  where tt-historico-embarque.cod-estabel = historico-embarque.cod-estabel and
                        tt-historico-embarque.embarque    = historico-embarque.embarque    and
                        tt-historico-embarque.cod-itiner  = historico-embarque.cod-itiner
                        no-error.
             if not avail tt-historico-embarque then do:
                  create tt-historico-embarque.
                  buffer-copy historico-embarque to tt-historico-embarque.
                  assign tt-historico-embarque.r-rowid = rowid(historico-embarque).
             end.
        end.
     end.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dt-efetiva":U THEN ASSIGN pFieldValue = RowObject.dt-efetiva.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-1":U         THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U         THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "cod-itiner":U    THEN ASSIGN pFieldValue = RowObject.cod-itiner.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice COMPRADOR
  Parameters:
               retorna valor dos campos do ¡ndice COMPRADOR
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE {&TABLENAME}.cod-estabel   NO-UNDO.
    DEFINE OUTPUT PARAMETER pembarque LIKE {&TABLENAME}.embarque NO-UNDO.
    
    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-estabel  = RowObject.cod-estabel.
    ASSIGN pembarque = RowObject.embarque.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEfetiva DBOProgram 
PROCEDURE openQueryEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
            open query {&QUERYNAME} for each tt-historico-embarque 
                                    use-index codigo
                                    INDEXED-REPOSITION.
    
                  
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
        FOR EACH tt-historico-embarque NO-LOCK 
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

 def input parameter p-est-ini  as char.
 def input parameter p-est-fim  as char.
 def input parameter p-emb-ini  as char.
 def input parameter p-emb-fim  as char.
 def input parameter p-iti-ini  as int.
 def input parameter p-iti-fim  as int.
 
 assign c-est-ini  = p-est-ini
        c-est-fim  = p-est-fim
        c-emb-ini  = p-emb-ini
        c-emb-fim  = p-emb-fim
        i-iti-ini  = p-iti-ini
        i-iti-fim  = p-iti-fim.

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
  Notes: Quando o zoom ‚ executado o browse abre sem registros, esta setconstraint
         atualiza as vari veis l-query1 e l-query2 que servirÆo de paramentro para
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
  Purpose:     Retorna faixa de registros da query atrav²s da 
               temptable RowObjectAux 
  Parameters:  recebe rowid inicial
               recebe flag indicando a execu»’o de novo GET NEXT
               recebe nœmero de linhas a serem retornadas
               retorna nœmero de linhas retornadas
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
    
    /*--- Verifica permiss’o de execu»’o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    
    /*--- Limpa temptable RowObjectAux ---*/
    RUN emptyRowObjectAux IN THIS-PROCEDURE.
    
    IF pRowid <> ? THEN DO:
/*        /*--- Reposiciona a query pelo rowid (repositionRecord) ---*/
 *         RUN repositionRecord IN THIS-PROCEDURE (INPUT pRowid).
 *         IF RETURN-VALUE = "NOK":U THEN
 *             RETURN "NOK":U.*/
        
        /* customiza‡Æo */
        
        for first tt-historico-embarque fields(cod-estabel embarque)
             WHERE tt-historico-embarque.r-rowid = pRowid.
        end.
        if avail tt-historico-embarque then 
            ASSIGN pRowid = rowid(tt-historico-embarque).
 
/*         for first tt-historico-embarque fields(cod-estabel embarque)
             WHERE tt-historico-embarque.r-rowid = pRowid.
               ASSIGN pRowid = tt-historico-embarque.r-rowid.
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
        
        /*--- Este teste torna-se necessÿrio devido ao fato de realizar-se um 
              reposicionamento de um registro rec²m eliminado. Neste caso n’o ² 
              retornado erro no comando REPOSITION, pois o reposicionamento da
              QUERY ² processado com base no RESULT-LIST ---*/
        IF NOT AVAILABLE {&TableName} THEN
            RETURN "NOK":U.
    END.
    
    IF pNext THEN DO:
/*        /*--- Posicina no pr½ximo registro, conforme flag de par³metro (getNext) ---*/
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
        
        /*--- Executa m²todos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="before"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /*--- Copia o registro da temptable RowObject para a temptable RowObjectAux ---*/
        CREATE RowObjectAux.
        BUFFER-COPY RowObject TO RowObjectAux.
        
        ASSIGN pRowsReturned = pRowsReturned + 1.
        
        /*--- Executa m²todos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="after"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
/*        /*--- Posicina no pr½ximo registro (getNext) ---*/
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
