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
{include/i-prgvrs.i BOCX220Q02 2.00.00.009 } /*** "010009" 27/11/2023 16:32:28  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx220q02 MUT}
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
&GLOBAL-DEFINE DBOName tt-embarque-imp
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName tt-embarque-imp
&GLOBAL-DEFINE TableLabel tt-embarque-imp
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (bocx135.p) est† com as funá‰es de inclui (createRecord), 
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

{cxbo/bocx220q02.i tt-embarque-imp}
{cxbo/bocx220q02.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
/*DEFINE BUFFER bf{&TableName} FOR tt-embarque-imp.*/

/*---------- Include de PrÇ-Processadores -------------*/
{cdp/cdcfgmat.i}

def var r-first   as ROWID no-undo.
def var r-last    as ROWID no-undo.
def var r-aux-pri as ROWID no-undo.

def var linha-aux  as int no-undo.
def var i-nrlinhas as int no-undo.

/*--Definiá∆o variaveis usadas nas procedures--*/

def var c-embarque-ini    as char no-undo.
def var c-embarque-fim    as char no-undo.
def var c-cod-estabel-ini as char no-undo.
def var c-cod-estabel-fim as char no-undo.
def var dt-nacional-ini   as date no-undo.
def var dt-nacional-fim   as date no-undo.

def var i-cod-emitente   like emitente.cod-emitente   no-undo.
def var c-nome-abrev     like emitente.nome-abrev     no-undo.
                                                               
def var c-estab-fisc     like processo-imp.estab-fisc no-undo.

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
         HEIGHT             = 22.71
         WIDTH              = 71.86.
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
        WHEN "embarque"           THEN ASSIGN pFieldValue = RowObject.embarque.          
        WHEN "cod-estabel"        THEN ASSIGN pFieldValue = RowObject.cod-estabel.       
        WHEN "cod-estab-fisc"     THEN ASSIGN pFieldValue = RowObject.cod-estab-fisc.    
        WHEN "ct-transit-import"  THEN ASSIGN pFieldValue = RowObject.ct-transit-import. 
        WHEN "nome-abrev"         THEN ASSIGN pFieldValue = RowObject.nome-abrev.        
        WHEN "sc-transit-import"  THEN ASSIGN pFieldValue = RowObject.sc-transit-import. 
        WHEN "declaracao-import"  THEN ASSIGN pFieldValue = RowObject.declaracao-import. 
        WHEN "cod-incoterm"       THEN ASSIGN pFieldValue = RowObject.cod-incoterm.      
        WHEN "char-1"             THEN ASSIGN pFieldValue = RowObject.char-1.            
        WHEN "char-2"             THEN ASSIGN pFieldValue = RowObject.char-2.            
        WHEN "check-sum"          THEN ASSIGN pFieldValue = RowObject.check-sum.         
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
ASSIGN rowObject.r-rowid = tt-embarque-imp.r-rowid.

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
  
  ASSIGN pRowid = tt-embarque-imp.r-rowid.
  
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

    /*for first tt-embarque-imp 
        fields(cod-estabel embarque) no-lock
        where tt-embarque-imp.cod-estabel = rowObject.cod-estabel 
         and tt-embarque-imp.embarque = rowObject.embarque:
       assign rowObject.r-rowid = tt-embarque-imp.r-rowid.
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

        /* carrega temptable espec°fica para zoom z10cx135 */

        /* Somente embarques nao encerrados */

    for each embarque-imp no-lock:        
        
        if embarque-imp.situacao = 2 then next. 

        FOR FIRST param-imp FIELDS(ct-transit-import sc-transit-import)
            WHERE param-imp.cod-estabel = embarque-imp.cod-estabel NO-LOCK:
        END.

        IF NOT AVAIL param-imp THEN NEXT.
        
        FOR FIRST historico-embarque FIELDS(cod-itiner)
            WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
              AND historico-embarque.embarque    = embarque-imp.embarque NO-LOCK:
        END.

        if not avail historico-embarque then next.

        FOR FIRST itinerario FIELDS(cod-itiner pto-desembarque)
            WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK:
        END.

        IF NOT AVAIL itinerario THEN NEXT.
        
        release historico-embarque.
        
        find historico-embarque where
             historico-embarque.cod-estabel   = embarque-imp.cod-estabel and
             historico-embarque.embarque      = embarque-imp.embarque    and
             historico-embarque.cod-itiner    = itinerario.cod-itiner    and
             historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar 
             use-index pto-contr no-lock no-error.
        
        if not avail historico-embarque then next.
        find first ordens-embarque where
                   ordens-embarque.cod-estabel = embarque-imp.cod-estabel and
                   ordens-embarque.embarque    = embarque-imp.embarque    no-lock no-error.

        if  avail ordens-embarque then do:
            find processo-imp where
                 processo-imp.cod-estabel = ordens-embarque.cod-estabel and
                 processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp 
                 no-lock no-error.
            if  avail processo-imp then do:
                assign c-estab-fisc   = processo-imp.estab-fisc.
                
                find first emitente where
                           emitente.cod-emitente = processo-imp.cod-exportador no-lock no-error.
                if  avail emitente then
                    assign i-cod-emitente = processo-imp.cod-exportador
                           c-nome-abrev   = emitente.nome-abrev.
            end.
        end.
        
        find first tt-embarque-imp where
                   tt-embarque-imp.cod-estabel = embarque-imp.cod-estabel and
                   tt-embarque-imp.embarque    = embarque-imp.embarque no-error.
         
        if not avail tt-embarque-imp then do:
            
            create tt-embarque-imp.
            assign tt-embarque-imp.embarque             = embarque-imp.embarque
                   tt-embarque-imp.cod-estabel          = embarque-imp.cod-estabel
                   tt-embarque-imp.cod-emitente         = i-cod-emitente
                   tt-embarque-imp.nome-abrev           = c-nome-abrev
                   tt-embarque-imp.cod-incoterm         = embarque-imp.cod-incoterm
                   tt-embarque-imp.cod-despachante      = embarque-imp.cod-despachante
                   tt-embarque-imp.cod-transportador    = embarque-imp.cod-transportador
                   tt-embarque-imp.cod-banco            = embarque-imp.cod-banco
                   tt-embarque-imp.declaracao-import    = embarque-imp.declaracao-import
                   tt-embarque-imp.data-di              = embarque-imp.data-di
                   tt-embarque-imp.dt-efetiva           = historico-embarque.dt-efetiva
                   tt-embarque-imp.ct-transit-import    = param-imp.ct-transit-import
                   tt-embarque-imp.sc-transit-import    = param-imp.sc-transit-import
                   tt-embarque-imp.cod-estab-fisc       = c-estab-fisc
                   tt-embarque-imp.cod-via-transp       = int(embarque-imp.cod-via-transp)
                   tt-embarque-imp.r-rowid              = rowid(embarque-imp)
                   i-cod-emitente = 0
                   c-nome-abrev   = ""
                   c-estab-fisc   = "".
             
        end.
    end. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTable2 DBOProgram 
PROCEDURE carregaTable2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        /* carrega temptable espec°fica para zoom z04cx220 */

        /* Somente embarques nao encerrados */
    for each embarque-imp NO-LOCK
        WHERE embarque-imp.embarque >= c-embarque-ini
          AND embarque-imp.embarque <= c-embarque-fim:
        
        if embarque-imp.situacao = 2 then next. 

        FOR FIRST param-imp FIELDS(ct-transit-import sc-transit-import)
            WHERE param-imp.cod-estabel = embarque-imp.cod-estabel NO-LOCK:
        END.

        IF NOT AVAIL param-imp THEN NEXT.
        
        find first historico-embarque where
                   historico-embarque.cod-estabel = embarque-imp.cod-estabel and
                   historico-embarque.embarque    = embarque-imp.embarque
                   no-lock no-error.

        if not avail historico-embarque then next.
        find itinerario where
             itinerario.cod-itiner = historico-embarque.cod-itiner
             no-lock no-error.

        IF NOT AVAIL itinerario THEN NEXT.
        
        release historico-embarque.
        
        find historico-embarque where
             historico-embarque.cod-estabel   = embarque-imp.cod-estabel and
             historico-embarque.embarque      = embarque-imp.embarque    and
             historico-embarque.cod-itiner    = itinerario.cod-itiner    and
             historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar
             use-index pto-contr no-lock no-error.
        
        if not avail historico-embarque then next.
        find first ordens-embarque where
                   ordens-embarque.cod-estabel = embarque-imp.cod-estabel and
                   ordens-embarque.embarque    = embarque-imp.embarque    no-lock no-error.
             
        if  avail ordens-embarque then do:
            find processo-imp where
                 processo-imp.cod-estabel = ordens-embarque.cod-estabel and
                 processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp 
                 no-lock no-error.
            if  avail processo-imp then do:
                assign c-estab-fisc   = processo-imp.estab-fisc.
                
                find first emitente where
                           emitente.cod-emitente = processo-imp.cod-exportador no-lock no-error.
                if  avail emitente then
                    assign i-cod-emitente = processo-imp.cod-exportador
                           c-nome-abrev   = emitente.nome-abrev.
            end.
        end.
        
        find first tt-embarque-imp where
                   tt-embarque-imp.cod-estabel = embarque-imp.cod-estabel and
                   tt-embarque-imp.embarque    = embarque-imp.embarque no-error.
         
        if not avail tt-embarque-imp then do:
            
            create tt-embarque-imp.
            assign tt-embarque-imp.embarque             = embarque-imp.embarque
                   tt-embarque-imp.cod-estabel          = embarque-imp.cod-estabel
                   tt-embarque-imp.cod-emitente         = i-cod-emitente
                   tt-embarque-imp.nome-abrev           = c-nome-abrev
                   tt-embarque-imp.cod-incoterm         = embarque-imp.cod-incoterm
                   tt-embarque-imp.cod-despachante      = embarque-imp.cod-despachante
                   tt-embarque-imp.cod-transportador    = embarque-imp.cod-transportador
                   tt-embarque-imp.cod-banco            = embarque-imp.cod-banco
                   tt-embarque-imp.declaracao-import    = embarque-imp.declaracao-import
                   tt-embarque-imp.data-di              = embarque-imp.data-di
                   tt-embarque-imp.dt-efetiva           = historico-embarque.dt-efetiva
                   tt-embarque-imp.ct-transit-import    = param-imp.ct-transit-import
                   tt-embarque-imp.sc-transit-import    = param-imp.sc-transit-import
                   tt-embarque-imp.cod-estab-fisc       = c-estab-fisc
                   tt-embarque-imp.cod-via-transp       = int(embarque-imp.cod-via-transp)
                   tt-embarque-imp.r-rowid              = rowid(embarque-imp)
                   i-cod-emitente = 0
                   c-nome-abrev   = ""
                   c-estab-fisc   = "".

            
             
        end.
    end. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecords DBOProgram 
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
        
        /* customizaá∆o */
        
        for first tt-embarque-imp fields(cod-estabel embarque)
             WHERE tt-embarque-imp.r-rowid = pRowid.
        end.
        if avail tt-embarque-imp then 
            ASSIGN pRowid = rowid(tt-embarque-imp).
 
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
        
        
        GET NEXT {&QueryName}.
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
        WHEN "data-di"      THEN ASSIGN pFieldValue = RowObject.data-di.
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
        WHEN "cod-emitente":U      THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-despachante":U   THEN ASSIGN pFieldValue = RowObject.cod-despachante.
        WHEN "cod-transportador":U THEN ASSIGN pFieldValue = RowObject.cod-transportador.
        WHEN "cod-banco":U         THEN ASSIGN pFieldValue = RowObject.cod-banco.
        WHEN "cod-via-transp":U    THEN ASSIGN pFieldValue = RowObject.cod-via-transp.
        WHEN "int-1":U             THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U             THEN ASSIGN pFieldValue = RowObject.int-2.
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
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE {&TABLENAME}.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pembarque LIKE {&TABLENAME}.embarque   NO-UNDO.
    
    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEmbarque DBOProgram 
PROCEDURE openQueryByEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   if c-embarque-ini = c-embarque-fim then
        open query {&QUERYNAME} for each tt-embarque-imp where 
                                         tt-embarque-imp.embarque  = c-embarque-ini and
                                         tt-embarque-imp.dt-efetiva >= dt-nacional-ini and
                                         tt-embarque-imp.dt-efetiva <= dt-nacional-fim 
                                         by tt-embarque-imp.embarque
                                         by tt-embarque-imp.cod-estabel
                                         INDEXED-REPOSITION.   
   else
        open query {&QUERYNAME} for each tt-embarque-imp where 
                                         tt-embarque-imp.embarque   >= c-embarque-ini  and
                                         tt-embarque-imp.embarque   <= c-embarque-fim  and
                                         tt-embarque-imp.dt-efetiva >= dt-nacional-ini and
                                         tt-embarque-imp.dt-efetiva <= dt-nacional-fim 
                                         by tt-embarque-imp.embarque
                                         by tt-embarque-imp.cod-estabel
                                         INDEXED-REPOSITION.

                 
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEmbarqueWeb DBOProgram 
PROCEDURE openQueryByEmbarqueWeb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   if c-embarque-ini = c-embarque-fim then
        open query {&QUERYNAME} for each tt-embarque-imp where 
                                         tt-embarque-imp.embarque  = c-embarque-ini       and
                                         tt-embarque-imp.cod-estabel >= c-cod-estabel-ini and
                                         tt-embarque-imp.cod-estabel <= c-cod-estabel-fim  and
                                         tt-embarque-imp.dt-efetiva >= dt-nacional-ini    and
                                         tt-embarque-imp.dt-efetiva <= dt-nacional-fim 
                                         by tt-embarque-imp.embarque
                                         by tt-embarque-imp.cod-estabel
                                         INDEXED-REPOSITION.   
   else
        open query {&QUERYNAME} for each tt-embarque-imp where 
                                         tt-embarque-imp.embarque    >= c-embarque-ini    and
                                         tt-embarque-imp.embarque    <= c-embarque-fim    and
                                         tt-embarque-imp.cod-estabel >= c-cod-estabel-ini and
                                         tt-embarque-imp.cod-estabel <= c-cod-estabel-fim and
                                         tt-embarque-imp.dt-efetiva  >= dt-nacional-ini   and
                                         tt-embarque-imp.dt-efetiva  <= dt-nacional-fim 
                                         by tt-embarque-imp.embarque
                                         by tt-embarque-imp.cod-estabel
                                         INDEXED-REPOSITION.

                 
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEstabel DBOProgram 
PROCEDURE openQueryByEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   if c-cod-estabel-ini = c-cod-estabel-fim then
        open query {&QUERYNAME} for each tt-embarque-imp where 
                                         tt-embarque-imp.cod-estabel  = c-cod-estabel-ini and
                                         tt-embarque-imp.dt-efetiva  >= dt-nacional-ini and
                                         tt-embarque-imp.dt-efetiva  <= dt-nacional-fim 
                                         by tt-embarque-imp.cod-estabel
                                         by tt-embarque-imp.embarque
                                         INDEXED-REPOSITION.   
   else
        open query {&QUERYNAME} for each tt-embarque-imp where 
                                         tt-embarque-imp.cod-estabel >= c-cod-estabel-ini and
                                         tt-embarque-imp.cod-estabel <= c-cod-estabel-fim and
                                         tt-embarque-imp.dt-efetiva  >= dt-nacional-ini   and
                                         tt-embarque-imp.dt-efetiva  <= dt-nacional-fim 
                                         by tt-embarque-imp.cod-estabel
                                         by tt-embarque-imp.embarque
                                         INDEXED-REPOSITION.
                  
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEstabelWeb DBOProgram 
PROCEDURE openQueryByEstabelWeb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   if c-cod-estabel-ini = c-cod-estabel-fim then
        open query {&QUERYNAME} for each tt-embarque-imp where 
                                         tt-embarque-imp.cod-estabel  = c-cod-estabel-ini and
                                         tt-embarque-imp.embarque     >= c-embarque-ini   and
                                         tt-embarque-imp.embarque     <= c-embarque-fim   and
                                         tt-embarque-imp.dt-efetiva   >= dt-nacional-ini  and
                                         tt-embarque-imp.dt-efetiva   <= dt-nacional-fim 
                                         by tt-embarque-imp.cod-estabel
                                         by tt-embarque-imp.embarque
                                         INDEXED-REPOSITION.   
   else
        open query {&QUERYNAME} for each tt-embarque-imp where 
                                         tt-embarque-imp.cod-estabel >= c-cod-estabel-ini    and
                                         tt-embarque-imp.cod-estabel <= c-cod-estabel-fim    and
                                         tt-embarque-imp.embarque    >= c-embarque-ini and
                                         tt-embarque-imp.embarque    <= c-embarque-fim and
                                         tt-embarque-imp.dt-efetiva  >= dt-nacional-ini   and
                                         tt-embarque-imp.dt-efetiva  <= dt-nacional-fim 
                                         by tt-embarque-imp.cod-estabel
                                         by tt-embarque-imp.embarque
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
        FOR EACH tt-embarque-imp NO-LOCK 
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

 def input parameter p-cod-estabel-ini as char no-undo.
 def input parameter p-cod-estabel-fim as char no-undo.
 def input parameter p-embarque-ini    as char no-undo.
 def input parameter p-embarque-fim    as char no-undo.
 def input parameter p-dt-nacional-ini as date no-undo.
 def input parameter p-dt-nacional-fim as date no-undo.

 assign c-embarque-ini    = p-embarque-ini
        c-embarque-fim    = p-embarque-fim
        c-cod-estabel-ini = p-cod-estabel-ini
        c-cod-estabel-fim = p-cod-estabel-fim
        dt-nacional-ini   = p-dt-nacional-ini
        dt-nacional-fim   = p-dt-nacional-fim.

 run carregatable.

      RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaEmbarque DBOProgram 
PROCEDURE setConstraintFaixaEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 def input parameter p-embarque-ini as char.
 def input parameter p-embarque-fim as char.
 def input parameter p-dt-nacional-ini as date.
 def input parameter p-dt-nacional-fim as date.

 assign c-embarque-ini = p-embarque-ini
        c-embarque-fim = p-embarque-fim
        dt-nacional-ini = p-dt-nacional-ini
        dt-nacional-fim = p-dt-nacional-fim.

 run carregatable2.
 
      RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaEstabel DBOProgram 
PROCEDURE setConstraintFaixaEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 def input parameter p-cod-estabel-ini as char.
 def input parameter p-cod-estabel-fim as char.
 def input parameter p-dt-nacional-ini as date.
 def input parameter p-dt-nacional-fim as date.

 assign c-cod-estabel-ini = p-cod-estabel-ini
        c-cod-estabel-fim = p-cod-estabel-fim
        dt-nacional-ini   = p-dt-nacional-ini
        dt-nacional-fim   = p-dt-nacional-fim.

 run carregatable.        

      RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

