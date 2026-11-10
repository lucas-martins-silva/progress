&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          rtb              PROGRESS
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-emitente NO-UNDO LIKE emitente.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i B22AD098 2.00.00.007}  /*** 010007 ***/
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/browserd.w
{cdp/cdcfgmat.i} /* Alfa 2.06b - Definicao de pre-processadores - Magnus ou EMS */
DEFINE VARIABLE c-lista-valor       AS CHARACTER INIT '':U NO-UNDO.

&IF "{&bf_mat_versao_ems}":U >= "2.05":U &THEN
    DEFINE VARIABLE l-fornecedor-filtro AS LOGICAL             NO-UNDO.
    DEFINE VARIABLE l-cliente-filtro    AS LOGICAL             NO-UNDO.
    DEFINE VARIABLE l-ambos-filtro      AS LOGICAL             NO-UNDO.

    DEFINE VARIABLE l-ativos-filtro                AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE l-restricao-compras-filtro     AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE l-restricao-compras-rec-filtro AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE l-inativos-filtro              AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE c-data-emit-restricao-filtro   AS CHAR     NO-UNDO.
    DEFINE VARIABLE c-situacao-emitente            AS CHAR     NO-UNDO. /* Coluna do Browser */

    DEFINE VARIABLE h-handle-pai               AS HANDLE       NO-UNDO.
    DEFINE VARIABLE l-pesquisa-emitente-filtro AS LOGICAL      NO-UNDO. /* Pesquisa de Emitente */
&ENDIF


/* Parameters Definitions ---                                           */


DEF VAR l-initialize AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-emitente

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table tt-emitente.cod-emitente tt-emitente.nome-abrev tt-emitente.nome-emit tt-emitente.cgc tt-emitente.nome-matriz tt-emitente.cod-gr-forn &IF "{&bf_mat_versao_ems}":U >= "2.05":U &THEN fn-status-emitente(tt-emitente.cod-emitente) @ c-situacao-emitente &ENDIF     
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define SELF-NAME br-table
&Scoped-define QUERY-STRING-br-table FOR EACH tt-emitente     INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-table OPEN QUERY {&SELF-NAME} FOR EACH tt-emitente     INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-table tt-emitente
&Scoped-define FIRST-TABLE-IN-QUERY-br-table tt-emitente


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-inicial c-final bt-confirma br-table ~
IMAGE-1 IMAGE-2 
&Scoped-Define DISPLAYED-OBJECTS c-inicial c-final 

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
<FOREIGN-KEYS>
cod-cond-pag||y|mgadm.emitente.cod-cond-pag
cod-gr-forn|y|y|mgadm.emitente.cod-gr-forn
cod-rep||y|mgadm.emitente.cod-rep
cod-transp||y|mgadm.emitente.cod-transp
cod-banco||y|mgadm.emitente.cod-banco
nome-abrev|y|y|mgadm.emitente.nome-abrev
cod-emitente|y|y|mgadm.emitente.cod-emitente
cod-gr-cli||y|mgadm.emitente.cod-gr-cli
cod-mensagem||y|mgadm.emitente.cod-mensagem
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "cod-gr-forn,nome-abrev,cod-emitente",
     Keys-Supplied = "cod-cond-pag,cod-gr-forn,cod-rep,cod-transp,cod-banco,nome-abrev,cod-emitente,cod-gr-cli,cod-mensagem"':U).

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
************************
* Initialize Filter Attributes */
RUN set-attribute-list IN THIS-PROCEDURE ('
  Filter-Value=':U).
/************************
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-mostra-emitente B-table-Win 
FUNCTION fn-mostra-emitente RETURNS LOGICAL
  (INPUT p-cod-emitente AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-status-emitente B-table-Win 
FUNCTION fn-status-emitente RETURNS CHARACTER
  (INPUT p-cod-emitente AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image~\im-sav":U
     LABEL "Button 1" 
     SIZE 5.14 BY 1.

DEFINE VARIABLE c-final AS INTEGER FORMAT ">>>>>9":U INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-inicial AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\ii-las":U
     SIZE 2.86 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      tt-emitente SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table B-table-Win _FREEFORM
  QUERY br-table NO-LOCK DISPLAY
      tt-emitente.cod-emitente FORMAT ">>>>>>>>9":U
      tt-emitente.nome-abrev FORMAT "X(12)":U
      tt-emitente.nome-emit FORMAT "X(40)":U
      tt-emitente.cgc FORMAT "x(19)":U
      tt-emitente.nome-matriz FORMAT "x(12)":U
      tt-emitente.cod-gr-forn FORMAT ">9":U
      &IF "{&bf_mat_versao_ems}":U >= "2.05":U &THEN
           fn-status-emitente(tt-emitente.cod-emitente) @ c-situacao-emitente COLUMN-LABEL "Situaá∆o" FORMAT "X(40)":U
      &ENDIF
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 78 BY 9.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-inicial AT ROW 1.04 COL 14.57 COLON-ALIGNED
     c-final AT ROW 1 COL 42.43 COLON-ALIGNED NO-LABEL
     bt-confirma AT ROW 1 COL 73
     br-table AT ROW 2.17 COL 1
     IMAGE-1 AT ROW 1 COL 24.72
     IMAGE-2 AT ROW 1 COL 41
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
   Temp-Tables and Buffers:
      TABLE: tt-emitente T "?" NO-UNDO mgadm emitente
   END-TABLES.
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
         HEIGHT             = 10.17
         WIDTH              = 78.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{include/c-brwzoo.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
/* BROWSE-TAB br-table bt-confirma F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-emitente
    INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _OrdList          = "mgadm.emitente.cod-emitente|yes"
     _Where[1]         = "mgadm.emitente.cod-emitente >= c-inicial
 AND mgadm.emitente.cod-emitente <= c-final
 AND emitente.identific <> 2"
     _Query            is NOT OPENED
*/  /* BROWSE br-table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br-table
&Scoped-define SELF-NAME br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br-table IN FRAME F-Main
DO:
    RUN New-State('DblClick':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-ENTRY OF br-table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
  
  run new-state('New-Line|':U + string(rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}))).
  run seta-valor.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-LEAVE OF br-table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON VALUE-CHANGED OF br-table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
  run new-state('New-Line|':U + string(rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}))).
  run new-state('Value-Changed|':U + string(this-procedure)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma B-table-Win
ON CHOOSE OF bt-confirma IN FRAME F-Main /* Button 1 */
DO:

  assign input frame {&frame-name} c-inicial c-final.
  RUN pi-OpenQuery IN THIS-PROCEDURE.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  apply 'value-changed' to {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

/* &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN           */
/* RUN dispatch IN THIS-PROCEDURE ('initialize':U). */
/* &ENDIF                                           */

{utp/ut-field.i mgadm emitente cod-emitente 1}
assign c-inicial:label in frame {&frame-name} = return-value.

&IF "{&bf_mat_versao_ems}":U >= "2.05":U &THEN
    {utp/ut-liter.i Situaá∆o}
    assign c-situacao-emitente:label in browse {&browse-name} = return-value.
&ENDIF

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
  DEF VAR key-value AS CHAR NO-UNDO.

  DEF VAR Filter-Value AS CHAR NO-UNDO.

  /* Copy 'Filter-Attributes' into local variables. */
  RUN get-attribute ('Filter-Value':U).
  Filter-Value = RETURN-VALUE.
  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'cod-gr-forn':U THEN DO:
       &Scope KEY-PHRASE emitente.cod-gr-forn eq INTEGER(key-value)
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* cod-gr-forn */
    WHEN 'nome-abrev':U THEN DO:
       &Scope KEY-PHRASE emitente.nome-abrev eq key-value
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* nome-abrev */
    WHEN 'cod-emitente':U THEN DO:
       &Scope KEY-PHRASE emitente.cod-emitente eq INTEGER(key-value)
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* cod-emitente */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/


  /* Code placed here will execute PRIOR to standard behavior. */
   /* Alfa 2.06 */
    &IF "{&bf_mat_versao_ems}":U >= "2.05":U &THEN
        DEFINE VARIABLE wh-br-table           AS WIDGET-HANDLE      NO-UNDO.
        DEFINE VARIABLE wh-column-situacao    AS WIDGET-HANDLE      NO-UNDO.

        RUN Who-Is-The-Container in adm-broker-hdl (input this-procedure,
                                                    output h-handle-pai).
        IF  VALID-HANDLE(h-handle-pai) THEN 
            RUN pi-filtro IN h-handle-pai (OUTPUT l-fornecedor-filtro,
                                           OUTPUT l-cliente-filtro,
                                           OUTPUT l-ambos-filtro,
                                           OUTPUT l-ativos-filtro,              
                                           OUTPUT l-restricao-compras-filtro,   
                                           OUTPUT l-restricao-compras-rec-filtro,
                                           OUTPUT l-inativos-filtro,            
                                           OUTPUT c-data-emit-restricao-filtro).
    &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    &IF "{&bf_mat_versao_ems}":U >= "2.05":U &THEN    
        /* Code placed here will execute AFTER standard behavior.    */
        /* Alfa 2.06 */
        FIND FIRST param-global NO-LOCK NO-ERROR.
        IF  param-global.modulo-re OR
            param-global.modulo-cc OR
            param-global.modulo-cn THEN
            ASSIGN l-pesquisa-emitente-filtro = YES.
        ELSE
            ASSIGN l-pesquisa-emitente-filtro = NO.
    
  IF l-pesquisa-emitente-filtro = NO THEN DO:
            ASSIGN wh-br-table = br-table:HANDLE IN FRAME {&FRAME-NAME}
                   wh-column-situacao = wh-br-table:GET-BROWSE-COLUMN(7)
                   wh-column-situacao:VISIBLE = FALSE.
        END.
    &ENDIF
    
  ASSIGN c-final:SCREEN-VALUE IN FRAME f-main = "999999".

  APPLY 'ENTRY' TO c-inicial IN FRAME f-main.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.*/

 IF l-initialize = YES THEN
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .
 ELSE
    ASSIGN l-initialize = YES.  

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view B-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  apply 'value-changed':U to {&browse-name} in frame {&frame-name}.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartBrowser, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-filtro B-table-Win 
PROCEDURE pi-filtro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Procedure Filtro de parametros. Release >= 2.05 */
&IF "{&bf_mat_versao_ems}":U >= "2.05":U &THEN
    define input parameter p-l-fornecedor as logical no-undo.
    define input parameter p-l-cliente    as logical no-undo.
    define input parameter p-l-ambos      as logical no-undo.

    define input parameter p-l-ativos-filtro                 as logical no-undo.
    define input parameter p-l-restricao-compras-filtro      as logical no-undo.
    define input parameter p-l-restricao-compras-rec-filtro  as logical no-undo.
    define input parameter p-l-inativos-filtro               as logical no-undo.
    define input parameter p-c-data-emit-restricao-filtro    as CHAR no-undo.


    assign l-fornecedor-filtro = p-l-fornecedor
           l-cliente-filtro    = p-l-cliente
           l-ambos-filtro      = p-l-ambos.

    
    ASSIGN l-ativos-filtro                  = p-l-ativos-filtro
           l-restricao-compras-filtro       = p-l-restricao-compras-filtro    
           l-restricao-compras-rec-filtro   = p-l-restricao-compras-rec-filtro
           l-inativos-filtro                = p-l-inativos-filtro             
           c-data-emit-restricao-filtro     = p-c-data-emit-restricao-filtro.
    RUN pi-OpenQuery.
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-OpenQuery B-table-Win 
PROCEDURE pi-OpenQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR l-criar-tt-emitente AS LOGICAL NO-UNDO.

    FOR EACH tt-emitente:
        DELETE tt-emitente.
    END.

    FOR EACH emitente 
        WHERE emitente.cod-emitente >= c-inicial AND 
              emitente.cod-emitente <= c-final AND 
              emitente.identific <> 2 NO-LOCK,
        FIRST resum-emit OF emitente NO-LOCK
              BY emitente.cod-emitente:

        /* Alfa 2.06b */
        &IF "{&bf_mat_versao_ems}":U >= "2.05":U &THEN
                IF l-pesquisa-emitente-filtro THEN 
                    ASSIGN l-criar-tt-emitente = fn-mostra-emitente(emitente.cod-emitente).
                ELSE
                    ASSIGN l-criar-tt-emitente = YES.
        &ELSE
                ASSIGN l-criar-tt-emitente = YES.
        &ENDIF
          
        IF l-criar-tt-emitente THEN DO:
            CREATE tt-emitente.
            ASSIGN tt-emitente.cod-emitente = emitente.cod-emitente
                   tt-emitente.nome-abrev   = emitente.nome-abrev
                   tt-emitente.cgc          = emitente.cgc
                   tt-emitente.nome-matriz  = emitente.nome-matriz
                   tt-emitente.cod-gr-forn  = emitente.cod-gr-forn
                   tt-emitente.nome-emit    = emitente.nome-emit.
            END.
    END.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-valor B-table-Win 
PROCEDURE pi-retorna-valor :
DEFINE INPUT PARAMETER P-CAMPO AS CHARACTER NO-UNDO.

    DEFINE VARIABLE P-VALOR AS CHAR INIT "" NO-UNDO.

    if  avail tt-emitente then do:
        case p-campo:
            when "nome-abrev" then
                assign p-valor = string(tt-emitente.nome-abrev).
        end.
    end.
    return p-valor.
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

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "cod-cond-pag" "emitente" "cod-cond-pag"}
  {src/adm/template/sndkycas.i "cod-gr-forn" "emitente" "cod-gr-forn"}
  {src/adm/template/sndkycas.i "cod-rep" "emitente" "cod-rep"}
  {src/adm/template/sndkycas.i "cod-transp" "emitente" "cod-transp"}
  {src/adm/template/sndkycas.i "cod-banco" "emitente" "cod-banco"}
  {src/adm/template/sndkycas.i "nome-abrev" "emitente" "nome-abrev"}
  {src/adm/template/sndkycas.i "cod-emitente" "emitente" "cod-emitente"}
  {src/adm/template/sndkycas.i "cod-gr-cli" "emitente" "cod-gr-cli"}
  {src/adm/template/sndkycas.i "cod-mensagem" "emitente" "cod-mensagem"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "RetornaValorCampo" B-table-Win _INLINE
/* Actions: ? ? ? ? support/brwrtval.p */
/* Procedure desativada */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-mostra-emitente B-table-Win 
FUNCTION fn-mostra-emitente RETURNS LOGICAL
  (INPUT p-cod-emitente AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
l-ativos-filtro                    
l-restricao-compras-filtro         
l-restricao-compras-rec-filtro     
l-inativos-filtro                  
c-data-emit-restricao-filtro       
    
------------------------------------------------------------------------------*/
&IF "{&bf_mat_versao_ems}":U >= "2.05":U &THEN
    IF fn-status-emitente(p-cod-emitente) <> "" THEN
        RETURN YES.
    ELSE
        RETURN NO.
&ELSE
    RETURN YES.
&ENDIF

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-status-emitente B-table-Win 
FUNCTION fn-status-emitente RETURNS CHARACTER
  (INPUT p-cod-emitente AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
l-ativos-filtro                    
l-restricao-compras-filtro         
l-restricao-compras-rec-filtro     
l-inativos-filtro                  
c-data-emit-restricao-filtro       
    
------------------------------------------------------------------------------*/
&IF "{&bf_mat_versao_ems}":U >= "2.05":U &THEN
    FIND FIRST dist-emitente 
         WHERE dist-emitente.cod-emitente = p-cod-emitente no-lock no-error.
      
    /* Se n∆o existir a tabela dist-emitente relacionada ao emitente, 
       o registro dever† ser mostrados normalmente                    */
    IF  NOT AVAIL dist-emitente THEN DO:
        RETURN "Desconhecido".
    END.
    
    /* Se o emitente estiver ativo,  */
    IF  dist-emitente.idi-sit-fornec = 1 AND l-ativos-filtro THEN DO:
        RETURN "Ativo".
    END.
    
    /* Verifica se existe alguma restricao em vigor para a data em questao*/
    IF  dist-emitente.dat-vigenc-inicial <= DATE(c-data-emit-restricao-filtro) AND
        dist-emitente.dat-vigenc-final   >= DATE(c-data-emit-restricao-filtro) THEN DO:
        IF  dist-emitente.idi-sit-fornec = 2 AND /* Restricao em Compras */
            l-restricao-compras-filtro THEN DO:
            RETURN "Restriá∆o Compras".
        END.
    
        IF  dist-emitente.idi-sit-fornec = 3 AND /* Restricao em compras e recebimento */
            l-restricao-compras-rec-filtro THEN DO:
            RETURN "Restricao Compras e Recebimento".
        END.
    
        IF  dist-emitente.idi-sit-fornec = 4 AND /* Inativos */
            l-inativos-filtro THEN DO:
            RETURN "Inativo".
        END.
    END.
    ELSE IF l-ativos-filtro THEN DO:
        RETURN "".
    END.
             

    /* se nao entrou em nenhuma situacao acima, nao mostra o emitente */
    RETURN "".
&ELSE
    RETURN "".
&ENDIF


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

