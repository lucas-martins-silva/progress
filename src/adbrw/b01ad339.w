&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i B01AD339 2.00.00.001}  /*** 010001 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i b01ad339 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */
&SCOPED-DEFINE adm-attribute-dlg support/browserd.w

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-descricao-moeda AS CHARACTER NO-UNDO FORMAT "x(12)":U.
DEFINE VARIABLE h-ge0101a         AS HANDLE    NO-UNDO.
&IF "{&mguni_version}" >= "2.07A" &THEN
DEFINE VARIABLE i-empresa         LIKE empresa.ep-codigo   NO-UNDO.
&ELSE
DEFINE VARIABLE i-empresa         AS INTEGER   NO-UNDO.
&ENDIF
DEFINE VARIABLE l-buttons-state   AS LOGICAL   NO-UNDO INITIAL NO.
DEFINE VARIABLE r-param-ge        AS ROWID     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-cot-infl-ge

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cot-infl-ge

/* Definitions for BROWSE br-cot-infl-ge                                */
&Scoped-define FIELDS-IN-QUERY-br-cot-infl-ge cot-infl-ge.mo-codigo ~
fn-descricao-moeda(mo-codigo) @ c-descricao-moeda cot-infl-ge.cotacao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-cot-infl-ge 
&Scoped-define QUERY-STRING-br-cot-infl-ge FOR EACH cot-infl-ge ~
      WHERE cot-infl-ge.ep-codigo = i-empresa NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-cot-infl-ge OPEN QUERY br-cot-infl-ge FOR EACH cot-infl-ge ~
      WHERE cot-infl-ge.ep-codigo = i-empresa NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-cot-infl-ge cot-infl-ge
&Scoped-define FIRST-TABLE-IN-QUERY-br-cot-infl-ge cot-infl-ge


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br-cot-infl-ge}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-cot-infl-ge 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS>
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE>
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-descricao-moeda B-table-Win 
FUNCTION fn-descricao-moeda RETURNS CHARACTER
    (INPUT p-moeda AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-eliminar 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-incluir 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-modificar 
     LABEL "&Modificar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-cot-infl-ge FOR 
      cot-infl-ge SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-cot-infl-ge
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-cot-infl-ge B-table-Win _STRUCTURED
  QUERY br-cot-infl-ge NO-LOCK DISPLAY
      cot-infl-ge.mo-codigo FORMAT ">>9":U
      fn-descricao-moeda(mo-codigo) @ c-descricao-moeda
      cot-infl-ge.cotacao FORMAT ">>>,>>>,>>9.999999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 66 BY 6.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br-cot-infl-ge AT ROW 1 COL 1
     bt-incluir AT ROW 7.75 COL 1
     bt-modificar AT ROW 7.75 COL 11
     bt-eliminar AT ROW 7.75 COL 21
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 7.75
         WIDTH              = 66.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{include/c-browse.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br-cot-infl-ge 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON bt-eliminar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-incluir IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-modificar IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-cot-infl-ge
/* Query rebuild information for BROWSE br-cot-infl-ge
     _TblList          = "mgadm.cot-infl-ge"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "cot-infl-ge.ep-codigo = i-empresa"
     _FldNameList[1]   = mgadm.cot-infl-ge.mo-codigo
     _FldNameList[2]   > "_<CALC>"
"fn-descricao-moeda(mo-codigo) @ c-descricao-moeda" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   = mgadm.cot-infl-ge.cotacao
     _Query            is OPENED
*/  /* BROWSE br-cot-infl-ge */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME bt-eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar B-table-Win
ON CHOOSE OF bt-eliminar IN FRAME F-Main /* Eliminar */
DO:
    DO TRANSACTION:
        GET CURRENT {&BROWSE-NAME} EXCLUSIVE-LOCK.
        IF NOT AVAILABLE cot-infl-ge THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 15217, INPUT "":U).
            
            RUN dispatch IN THIS-PROCEDURE ("open-query":U).
            
            RETURN "ADM-ERROR":U.
        END.
        
        {include/confdel.i}
        IF NOT l-resposta THEN DO:
            GET CURRENT {&BROWSE-NAME} NO-LOCK.
            
            RETURN "":U.
        END.
        
        DELETE cot-infl-ge NO-ERROR.
        IF ERROR-STATUS:ERROR 
            THEN UNDO, RETURN "ADM-ERROR":U.
        
        BROWSE {&BROWSE-NAME}:DELETE-CURRENT-ROW().
        
        IF AVAILABLE cot-infl-ge
            THEN RUN new-state (INPUT "record-available, SELF":U).
            ELSE RUN new-state (INPUT "no-record-available, SELF":U).
        
        RETURN "":U.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir B-table-Win
ON CHOOSE OF bt-incluir IN FRAME F-Main /* Incluir */
DO:
    DEFINE VARIABLE r-cot-infl-ge AS ROWID NO-UNDO.
    DEFINE VARIABLE r-empresa     AS ROWID NO-UNDO.
    
    FIND empresa WHERE empresa.ep-codigo = i-empresa NO-LOCK NO-ERROR.
    IF AVAILABLE empresa THEN
        ASSIGN r-empresa = ROWID(empresa).
    ELSE
        ASSIGN r-empresa = ?.
    
    RUN gep/ge0101a.w PERSISTENT SET h-ge0101a (INPUT-OUTPUT r-cot-infl-ge,
                                                INPUT        r-param-ge,
                                                INPUT        THIS-PROCEDURE,
                                                INPUT        "incluir":U).
    
    IF VALID-HANDLE(h-ge0101a) THEN DO:
        RUN dispatch IN h-ge0101a ("initialize":U).
        
        IF VALID-HANDLE(h-ge0101a) THEN DO:
            RUN pi-recebe-empresa IN h-ge0101a (INPUT r-empresa).
            
            RUN notify IN h-ge0101a ("add-record":U).
            
            RUN pi-entry IN h-ge0101a.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-modificar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modificar B-table-Win
ON CHOOSE OF bt-modificar IN FRAME F-Main /* Modificar */
DO:
    DEFINE VARIABLE r-cot-infl-ge AS ROWID NO-UNDO.
    DEFINE VARIABLE r-empresa     AS ROWID NO-UNDO.
    
    FIND empresa WHERE empresa.ep-codigo = i-empresa NO-LOCK NO-ERROR.
    IF AVAILABLE empresa THEN
        ASSIGN r-empresa = ROWID(empresa).
    ELSE
        ASSIGN r-empresa = ?.
    
    GET CURRENT {&BROWSE-NAME}.
    
    IF NOT AVAILABLE cot-infl-ge THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 15217, INPUT "":U).
        
        RUN dispatch IN THIS-PROCEDURE ("open-query":U).
        
        RETURN "ADM-ERROR":U.
    END.
    ELSE IF CURRENT-CHANGED cot-infl-ge THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 15216, INPUT "":U).
            
            BROWSE {&BROWSE-NAME}:REFRESH().
            
            RETURN "ADM-ERROR":U.
    END.
    
    ASSIGN r-cot-infl-ge = ROWID(cot-infl-ge).
    
    RUN gep/ge0101a.w PERSISTENT SET h-ge0101a (INPUT-OUTPUT r-cot-infl-ge,
                                                INPUT        r-param-ge,
                                                INPUT        THIS-PROCEDURE,
                                                INPUT        "incluir":U).
    
    IF VALID-HANDLE(h-ge0101a) THEN DO:
        RUN dispatch IN h-ge0101a ("initialize":U).
        
        IF VALID-HANDLE(h-ge0101a) THEN DO:
            RUN pi-recebe-empresa IN h-ge0101a (INPUT r-empresa).
            
            RUN pi-reposiciona IN h-ge0101a.
            
            RUN new-state IN h-ge0101a ("update-begin":U).
            
            RUN pi-entry IN h-ge0101a.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-cot-infl-ge
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

{utp/ut-liter.i Descri‡Æo}
ASSIGN c-descricao-moeda:LABEL IN BROWSE {&BROWSE-NAME} = TRIM(RETURN-VALUE).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-change B-table-Win 
PROCEDURE pi-change :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-buttons-state AS LOGICAL NO-UNDO.
    
    ASSIGN l-buttons-state = p-buttons-state
           bt-incluir:SENSITIVE IN FRAME {&FRAME-NAME}   = l-buttons-state
           bt-modificar:SENSITIVE IN FRAME {&FRAME-NAME} = (l-buttons-state and AVAILABLE cot-infl-ge)
           bt-eliminar:SENSITIVE IN FRAME {&FRAME-NAME}  = (l-buttons-state and AVAILABLE cot-infl-ge).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-empresa B-table-Win 
PROCEDURE pi-recebe-empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    DEFINE INPUT PARAMETER p-empresa LIKE empresa.ep-codigo NO-UNDO.
&ELSE
    DEFINE INPUT PARAMETER p-empresa AS INTEGER NO-UNDO.
&ENDIF
    
    ASSIGN i-empresa = p-empresa.
    
    RUN dispatch IN THIS-PROCEDURE ("open-query":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-param-ge B-table-Win 
PROCEDURE pi-recebe-param-ge :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-param-ge AS ROWID NO-UNDO.
    
    ASSIGN r-param-ge = p-param-ge.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cot-infl-ge"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/*------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
    DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.
    
    CASE p-state:
        WHEN "record-available":U THEN
            IF l-buttons-state THEN
                ASSIGN bt-incluir:SENSITIVE IN FRAME {&FRAME-NAME}   = YES
                       bt-modificar:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                       bt-eliminar:SENSITIVE IN FRAME {&FRAME-NAME}  = YES.
        
        WHEN "no-record-available":U THEN
            IF l-buttons-state THEN
                ASSIGN bt-incluir:SENSITIVE IN FRAME {&FRAME-NAME}   = YES
                       bt-modificar:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                       bt-eliminar:SENSITIVE IN FRAME {&FRAME-NAME}  = NO.
    END CASE.
    
    CASE p-state:
        /* Object instance CASEs can go here to replace standard behavior
           or add new cases. */
        {src/adm/template/bstates.i}
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-descricao-moeda B-table-Win 
FUNCTION fn-descricao-moeda RETURNS CHARACTER
    (INPUT p-moeda AS INTEGER):
    FIND moeda WHERE moeda.mo-codigo = p-moeda NO-LOCK NO-ERROR.
    
    IF AVAILABLE moeda THEN
        RETURN moeda.descricao.
    ELSE
        RETURN "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

