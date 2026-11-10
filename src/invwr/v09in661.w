&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V09IN661 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V09IN661 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

{cdp/cdcfgmat.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES estab-mat
&Scoped-define FIRST-EXTERNAL-TABLE estab-mat


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estab-mat.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-3 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS rs-fase-medio l-acerto-aut l-gera-act ~
l-pm-ja-ini l-fec-ja-ini rs-tipo-pr-med i-num-dec c-lb-fase c-lb-param ~
c-lb-tipo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS rs-fase-medio l-acerto-aut l-gera-act ~
l-pm-ja-ini l-fec-ja-ini rs-tipo-pr-med i-num-dec 
&Scoped-define ADM-MODIFY-FIELDS l-acerto-aut l-gera-act rs-tipo-pr-med ~
i-num-dec 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-lb-fase AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-lb-param AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-lb-tipo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE i-num-dec AS INTEGER FORMAT ">9" INITIAL 4 
     LABEL "Decimais Para C lculo" 
     VIEW-AS FILL-IN 
     SIZE 3.43 BY .88.

DEFINE VARIABLE rs-fase-medio AS INTEGER INITIAL 5 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "NÆo Calculado", 1,
"Itens Comprados", 2,
"Ord Manuten‡Æo", 3,
"Ord Invest", 4,
"Ord Produ‡Æo", 5
     SIZE 22.29 BY 4.04.

DEFINE VARIABLE rs-tipo-pr-med AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Di rio", 1,
"Mensal", 2
     SIZE 17.43 BY 1.58.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43.14 BY 4.58.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43 BY 2.21.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.57 BY 7.21.

DEFINE VARIABLE l-acerto-aut AS LOGICAL INITIAL no 
     LABEL "Gera acertos custo on-line" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83.

DEFINE VARIABLE l-fec-ja-ini AS LOGICAL INITIAL no 
     LABEL "Fechamento iniciado" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.72 BY .83.

DEFINE VARIABLE l-gera-act AS LOGICAL INITIAL no 
     LABEL "Gera acertos c lculo m‚dio" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.14 BY .83.

DEFINE VARIABLE l-pm-ja-ini AS LOGICAL INITIAL no 
     LABEL "Pre‡o m‚dio iniciado" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     rs-fase-medio AT ROW 1.67 COL 9 NO-LABEL
     l-acerto-aut AT ROW 1.75 COL 54
     l-gera-act AT ROW 3.17 COL 54
     l-pm-ja-ini AT ROW 4.54 COL 54
     l-fec-ja-ini AT ROW 5.83 COL 54
     rs-tipo-pr-med AT ROW 6.75 COL 9 NO-LABEL
     i-num-dec AT ROW 7.08 COL 73 COLON-ALIGNED HELP
          "Informe o n£mero de decimais"
     c-lb-fase AT ROW 1 COL 1.86 NO-LABEL
     c-lb-param AT ROW 1 COL 43.43 COLON-ALIGNED NO-LABEL
     c-lb-tipo AT ROW 6 COL 2 NO-LABEL
     RECT-1 AT ROW 1.33 COL 1
     RECT-3 AT ROW 1.33 COL 44.43
     RECT-2 AT ROW 6.33 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estab-mat
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 7.67
         WIDTH              = 86.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-lb-fase IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-lb-param IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-lb-tipo IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN i-num-dec IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX l-acerto-aut IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX l-fec-ja-ini IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR TOGGLE-BOX l-gera-act IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX l-pm-ja-ini IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR RADIO-SET rs-fase-medio IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR RADIO-SET rs-tipo-pr-med IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "estab-mat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estab-mat"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  &if defined(bf_mat_fech_estab) &then
     if avail estab-mat then
        assign rs-fase-medio = estab-mat.fase-medio 
               rs-tipo-pr-med = estab-mat.tipo-pr-med 
               l-acerto-aut   = estab-mat.acerto-aut
               l-gera-act     = estab-mat.gera-act
               l-pm-ja-ini    = estab-mat.pm-ja-ini
               l-fec-ja-ini   = estab-mat.fec-ja-ini
               i-num-dec      = estab-mat.num-dec.
     {utp/ut-field.i mgind estab-mat fase-medio 1}
     assign c-lb-fase = return-value.
     {utp/ut-field.i mgind estab-mat tipo-pr-med 1}
     assign c-lb-tipo = return-value.
     {utp/ut-liter.i Parƒmetros * L}
     assign c-lb-param = return-value.
  &endif

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  disp c-lb-fase 
       c-lb-tipo
       c-lb-param 
       with frame {&frame-name}.
     
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &if defined(bf_mat_fech_estab) &then
    {utp/ut-field.i mgind estab-mat acerto-aut 1}
    assign l-acerto-aut:label in frame {&FRAME-NAME} = return-value.
    {utp/ut-field.i mgind estab-mat gera-act 1}
    assign l-gera-act:label in frame {&FRAME-NAME} = return-value.
    {utp/ut-field.i mgind estab-mat pm-ja-ini 1}
    assign l-pm-ja-ini:label in frame {&FRAME-NAME} = return-value.
    {utp/ut-field.i mgind estab-mat fec-ja-ini 1}
    assign l-fec-ja-ini:label in frame {&FRAME-NAME} = return-value.
    {utp/ut-field.i mgind estab-mat num-dec 1}
    assign i-num-dec:label in frame {&FRAME-NAME} = return-value.
    
    {utp/ut-field.i mgind estab-mat fase-medio 1}
    assign c-lb-fase = return-value.
    {utp/ut-field.i mgind estab-mat tipo-pr-med 1}
    assign c-lb-tipo = return-value.
    {utp/ut-liter.i Parƒmetros * L}
    assign c-lb-param = return-value.
   
    /*{utp/ut-rdset.i rs-fase-medio mce}
 *     {utp/ut-rdset.i rs-tipo-pr-med mce}*/
    
  &endif

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "estab-mat"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
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
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


