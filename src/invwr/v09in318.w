&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V09IN318 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V09IN318 MUT}
&ENDIF


/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def new global shared var gr-item       as rowid no-undo.
def new global shared var gr-pl-prod    as rowid no-undo.
def new global shared var gr-pl-it-prod as rowid no-undo.
def new global shared var gr-periodo    as rowid no-undo.

{cdp/cdcfgman.i} /*Miniflexibiliza‡Æo. Utilizado no EMS 2.03 - NÇO ELIMINAR
                 * Vari vel preprocessador bf_man_203 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS pl-it-prod.cd-plano item.it-codigo 
&Scoped-define ENABLED-TABLES pl-it-prod item
&Scoped-define FIRST-ENABLED-TABLE pl-it-prod
&Scoped-define SECOND-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS RECT-2 
&Scoped-Define DISPLAYED-FIELDS pl-it-prod.cd-plano pl-prod.descricao ~
item.it-codigo 
&Scoped-define DISPLAYED-TABLES pl-it-prod pl-prod item
&Scoped-define FIRST-DISPLAYED-TABLE pl-it-prod
&Scoped-define SECOND-DISPLAYED-TABLE pl-prod
&Scoped-define THIRD-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel c-desc c-dt-per da-dt-inicio ~
da-dt-termino 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

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
DEFINE VARIABLE c-cod-estabel LIKE estabelec.cod-estabel
     LABEL "":R7 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .88 NO-UNDO.

DEFINE VARIABLE c-dt-per AS CHARACTER FORMAT "999/9999":U 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-inicio AS DATE FORMAT "99/99/9999" 
     LABEL "Data In¡cio":R14 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE da-dt-termino AS DATE FORMAT "99/99/9999" 
     LABEL "Data T‚rmino":R15 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     pl-it-prod.cd-plano AT ROW 1.25 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     pl-prod.descricao AT ROW 1.25 COL 14.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     c-cod-estabel AT ROW 1.25 COL 50.86 COLON-ALIGNED
          LABEL "":R7
     item.it-codigo AT ROW 2.25 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-desc AT ROW 2.25 COL 27 COLON-ALIGNED NO-LABEL
     c-dt-per AT ROW 3.25 COL 9 COLON-ALIGNED
     da-dt-inicio AT ROW 3.25 COL 33 COLON-ALIGNED
     da-dt-termino AT ROW 3.25 COL 62 COLON-ALIGNED
     RECT-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 3.67
         WIDTH              = 89.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{utp/ut-glob.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME F-Main
   NO-ENABLE LIKE = mgcad.estabelec.cod-estabel EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN c-desc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-dt-per IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-dt-inicio IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-dt-termino IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN pl-prod.descricao IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


{utp/ut-liter.i Per¡odo * R}
assign c-dt-per:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Data_In¡cio * R}
assign da-dt-inicio:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Data_T‚rmino * R}
assign da-dt-termino:label in frame {&frame-name} = trim(return-value).

&IF DEFINED (bf_man_203) &THEN
  {utp/ut-liter.i Est * L}
  assign c-cod-estabel:label in frame {&frame-name} = return-value.
  assign c-cod-estabel:hidden  in frame {&frame-name} = no.
&ELSE
  assign c-cod-estabel:hidden  in frame {&frame-name} = yes.
&ENDIF

/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  
  if available item then do:
     assign c-desc = item.desc-item.
  end.    

   if avail pl-it-prod then do:
     assign c-dt-per = string(pl-it-prod.periodo,"999") + 
                       string(pl-it-prod.ano,"9999").
     find first periodo
        where periodo.cd-tipo = pl-prod.cd-tipo
          and periodo.nr-per  = pl-it-prod.periodo
          and periodo.ano     = pl-it-prod.ano
        no-lock no-error.
        
     assign da-dt-inicio  = periodo.dt-inicio
            da-dt-termino = periodo.dt-termino.

       &IF DEFINED (bf_man_203) &THEN
           assign c-cod-estabel = pl-it-prod.cod-estabel.
       &ENDIF
  end.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
   if avail item then
      assign gr-item = rowid(item).

   if avail pl-prod then
      assign gr-pl-prod = rowid(pl-prod).   

   if avail pl-it-prod then do:
      assign gr-pl-it-prod = rowid(pl-it-prod).
      find first periodo
         where periodo.cd-tipo = pl-prod.cd-tipo
           and periodo.nr-per  = pl-it-prod.periodo
           and periodo.ano     = pl-it-prod.ano
         no-lock no-error.
         
      if avail periodo then do:
         assign gr-periodo = rowid(periodo).
      end.

   end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this Window, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

