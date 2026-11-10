&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
{include/i-prgvrs.i V02IN569 2.00.00.012 } /*** "010012" 27/08/2024 08:50:28 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN569 MUT}
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
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var de-tempo as decimal decimals 3 no-undo.

def new global shared var gr-ord-prod as rowid no-undo.

def buffer b-movto-ggf for movto-ggf.
def var de-horas like movto-ggf.horas-report no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES movto-ggf
&Scoped-define FIRST-EXTERNAL-TABLE movto-ggf


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-ggf.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-dt-trans rt-mold 
&Scoped-Define DISPLAYED-OBJECTS fi-dt-trans cb-relogio i-hr-ini i-min-ini ~
i-cent-ini i-cent-fim i-hr-fim i-min-fim fi-horas-report i-hr i-min ~
fi-cd-turno c-desc-turno fi-matr-func fi-referencia 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS fi-dt-trans cb-relogio i-hr i-min ~
fi-matr-func fi-referencia 
&Scoped-define ADM-ASSIGN-FIELDS fi-dt-trans cb-relogio fi-horas-report ~
i-hr i-min fi-cd-turno fi-matr-func fi-referencia 
&Scoped-define ADM-MODIFY-FIELDS fi-horas-report 

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
DEFINE VARIABLE cb-relogio AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-turno AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .86 NO-UNDO.

DEFINE VARIABLE fi-cd-turno AS CHARACTER FORMAT "x(10)" 
     LABEL "":R7 
     VIEW-AS FILL-IN 
     SIZE 14.2 BY .86.

DEFINE VARIABLE fi-dt-trans AS DATE FORMAT "99/99/9999" 
     LABEL "":R17 
     VIEW-AS FILL-IN 
     SIZE 12.6 BY .86.

DEFINE VARIABLE fi-horas-report AS DECIMAL FORMAT ">>>9.9999" INITIAL 0 
     LABEL "":R14 
     VIEW-AS FILL-IN 
     SIZE 11 BY .86.

DEFINE VARIABLE fi-matr-func AS INTEGER FORMAT "99999999" INITIAL 0 
     LABEL "":R29 
     VIEW-AS FILL-IN 
     SIZE 13 BY .86 NO-UNDO.

DEFINE VARIABLE fi-referencia AS CHARACTER FORMAT "x(10)" 
     LABEL "":R12 
     VIEW-AS FILL-IN 
     SIZE 17 BY .86 NO-UNDO.

DEFINE VARIABLE i-cent-fim AS DECIMAL FORMAT ">>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .86 NO-UNDO.

DEFINE VARIABLE i-cent-ini AS DECIMAL FORMAT ">>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .86 NO-UNDO.

DEFINE VARIABLE i-hr AS INTEGER FORMAT "zzz9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .86 NO-UNDO.

DEFINE VARIABLE i-hr-fim AS INTEGER FORMAT "z9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .86 NO-UNDO.

DEFINE VARIABLE i-hr-ini AS INTEGER FORMAT "z9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .86 NO-UNDO.

DEFINE VARIABLE i-min AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .86 NO-UNDO.

DEFINE VARIABLE i-min-fim AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .86 NO-UNDO.

DEFINE VARIABLE i-min-ini AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4.6 BY .86 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 7.91.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-dt-trans AT ROW 1.52 COL 23 COLON-ALIGNED
     cb-relogio AT ROW 1.52 COL 58 COLON-ALIGNED
     i-hr-ini AT ROW 2.52 COL 23 COLON-ALIGNED
     i-min-ini AT ROW 2.52 COL 30 COLON-ALIGNED
     i-cent-ini AT ROW 2.52 COL 58.8
     i-cent-fim AT ROW 3.48 COL 58.2 COLON-ALIGNED
     i-hr-fim AT ROW 3.52 COL 23 COLON-ALIGNED
     i-min-fim AT ROW 3.52 COL 30 COLON-ALIGNED
     fi-horas-report AT ROW 4.38 COL 58 COLON-ALIGNED
     i-hr AT ROW 4.52 COL 23 COLON-ALIGNED
     i-min AT ROW 4.52 COL 30 COLON-ALIGNED
     fi-cd-turno AT ROW 5.52 COL 23 COLON-ALIGNED
     c-desc-turno AT ROW 5.52 COL 39.2 COLON-ALIGNED NO-LABEL
     fi-matr-func AT ROW 6.52 COL 23 COLON-ALIGNED
     fi-referencia AT ROW 7.52 COL 23 COLON-ALIGNED
     rt-mold AT ROW 1 COL 1.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.movto-ggf
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 8.19
         WIDTH              = 83.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-turno IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-relogio IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-cd-turno IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-dt-trans IN FRAME f-main
   1 2                                                                  */
/* SETTINGS FOR FILL-IN fi-horas-report IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-matr-func IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-referencia IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN i-cent-fim IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cent-ini IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN i-hr IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN i-hr-fim IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-hr-ini IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-min IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN i-min-fim IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-min-ini IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cb-relogio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-relogio V-table-Win
ON VALUE-CHANGED OF cb-relogio IN FRAME f-main
DO:
    assign input frame {&frame-name} cb-relogio.
    case cb-relogio:
        when {ininc/i01in289.i 04 1} then do:
            enable i-hr
                   i-min
                   with frame {&frame-name}.
            disable i-hr-ini
                    i-min-ini
                    i-hr-fim
                    i-min-fim
                    i-cent-ini
                    i-cent-fim
                    fi-horas-report
                    with frame {&frame-name}.
            assign i-hr-ini:screen-value in frame {&frame-name} = ""
                   i-hr-fim:screen-value in frame {&frame-name} = ""
                   i-min-ini:screen-value in frame {&frame-name} = ""
                   i-min-fim:screen-value in frame {&frame-name} = ""
                   i-cent-ini:screen-value in frame {&frame-name} = ""
                   i-cent-fim:screen-value in frame {&frame-name} = ""
                   fi-horas-report:screen-value in frame {&frame-name} = "".
        end.
        when {ininc/i01in289.i 04 2} then do:
            enable i-hr-ini
                   i-min-ini
                   i-hr-fim
                   i-min-fim
                   with frame {&frame-name}.
            disable i-hr
                    i-min
                    i-cent-ini
                    i-cent-fim
                    fi-horas-report
                    with frame {&frame-name}.
            assign i-hr:screen-value in frame {&frame-name} = ""
                   i-min:screen-value in frame {&frame-name} = ""
                   i-cent-ini:screen-value in frame {&frame-name} = ""
                   i-cent-fim:screen-value in frame {&frame-name} = ""
                   fi-horas-report:screen-value in frame {&frame-name} = "".
        end.
        when {ininc/i01in289.i 04 3} then do:
            enable fi-horas-report
                   with frame {&frame-name}.
            disable i-hr-ini
                    i-min-ini
                    i-hr-fim
                    i-min-fim
                    i-hr
                    i-min
                    i-cent-ini
                    i-cent-fim
                    with frame {&frame-name}.
            assign i-hr-ini:screen-value in frame {&frame-name} = ""
                   i-hr-fim:screen-value in frame {&frame-name} = ""
                   i-min-ini:screen-value in frame {&frame-name} = ""
                   i-min-fim:screen-value in frame {&frame-name} = ""
                   i-hr:screen-value in frame {&frame-name} = ""
                   i-min:screen-value in frame {&frame-name} = ""
                   i-cent-ini:screen-value in frame {&frame-name} = ""
                   i-cent-fim:screen-value in frame {&frame-name} = "".
        end.
        when {ininc/i01in289.i 04 4} then do:
            enable i-cent-ini
                   i-cent-fim
                   with frame {&frame-name}.
            disable i-hr-ini
                    i-min-ini
                    i-hr-fim
                    i-min-fim
                    i-hr
                    i-min
                    fi-horas-report
                    with frame {&frame-name}.
            assign i-hr-ini:screen-value in frame {&frame-name} = ""
                   i-hr-fim:screen-value in frame {&frame-name} = ""
                   i-min-ini:screen-value in frame {&frame-name} = ""
                   i-min-fim:screen-value in frame {&frame-name} = ""
                   i-hr:screen-value in frame {&frame-name} = ""
                   i-min:screen-value in frame {&frame-name} = ""
                   fi-horas-report:screen-value in frame {&frame-name} = "".
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-turno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-turno V-table-Win
ON F5 OF fi-cd-turno IN FRAME f-main
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in440.w"
                       &campo=fi-cd-turno
                       &campo2=c-desc-turno
                       &campozoom=cd-turno
                       &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-turno V-table-Win
ON LEAVE OF fi-cd-turno IN FRAME f-main
DO:
    {include/leave.i &tabela=turno
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-turno
                     &where="turno.cd-turno = input frame {&frame-name} fi-cd-turno"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-turno V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cd-turno IN FRAME f-main
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cent-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cent-fim V-table-Win
ON LEAVE OF i-cent-fim IN FRAME f-main
DO:
  assign i-cent-ini
         i-cent-fim.
  if i-cent-fim - i-cent-ini > 0 then
     assign fi-horas-report = i-cent-fim - i-cent-ini.
  disp fi-horas-report with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cent-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cent-ini V-table-Win
ON LEAVE OF i-cent-ini IN FRAME f-main
DO:
  assign i-cent-ini
         i-cent-fim.
  if i-cent-fim - i-cent-ini > 0 then
     assign fi-horas-report = i-cent-fim - i-cent-ini.
  disp fi-horas-report with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-hr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-hr V-table-Win
ON LEAVE OF i-hr IN FRAME f-main
DO:
  assign i-hr
         i-min.
  assign fi-horas-report = i-hr + i-min / 60.
  disp fi-horas-report with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-hr-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-hr-fim V-table-Win
ON LEAVE OF i-hr-fim IN FRAME f-main
DO:
  assign i-hr-fim
         i-min-fim
         i-hr-ini
         i-min-ini.
   if (i-hr-fim + i-min-fim / 60) - (i-hr-ini + i-min-ini / 60) > 0 then do:
      assign fi-horas-report = (i-hr-fim + i-min-fim / 60) - (i-hr-ini + i-min-ini / 60).
      disp fi-horas-report with frame {&frame-name}.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-hr-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-hr-ini V-table-Win
ON LEAVE OF i-hr-ini IN FRAME f-main
DO:
   assign i-hr-fim
          i-min-fim
          i-hr-ini
          i-min-ini.
   if (i-hr-fim + i-min-fim / 60) - (i-hr-ini + i-min-ini / 60) > 0 then do:
      assign fi-horas-report = (i-hr-fim + i-min-fim / 60) - (i-hr-ini + i-min-ini / 60).
      disp fi-horas-report with frame {&frame-name}.
   end.              
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-min
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-min V-table-Win
ON LEAVE OF i-min IN FRAME f-main
DO:
  assign i-hr
         i-min.
  assign fi-horas-report = i-hr + i-min / 60.
  disp fi-horas-report with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-min-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-min-fim V-table-Win
ON LEAVE OF i-min-fim IN FRAME f-main
DO:
  assign i-hr-fim
          i-min-fim
          i-hr-ini
          i-min-ini.
   if (i-hr-fim + i-min-fim / 60) - (i-hr-ini + i-min-ini / 60) > 0 then do:
      assign fi-horas-report = (i-hr-fim + i-min-fim / 60) - (i-hr-ini + i-min-ini / 60).
      disp fi-horas-report with frame {&frame-name}.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-min-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-min-ini V-table-Win
ON LEAVE OF i-min-ini IN FRAME f-main
DO:
  assign i-hr-fim
         i-min-fim
         i-hr-ini
         i-min-ini.
   if (i-hr-fim + i-min-fim / 60) - (i-hr-ini + i-min-ini / 60) > 0 then do:
      assign fi-horas-report = (i-hr-fim + i-min-fim / 60) - (i-hr-ini + i-min-ini / 60).
      disp fi-horas-report with frame {&frame-name}.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

  if fi-cd-turno:load-mouse-pointer ("Image\lupa.cur") in frame {&frame-name} then.

  {utp/ut-liter.i Hora_Inicial * r}
  assign i-hr-ini:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Hora_Final * r}
  assign i-hr-fim:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Inicial * r}
  assign i-cent-ini:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Final * r}
  assign i-cent-fim:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Hora * r}
  assign i-hr:label in frame {&frame-name} = trim(return-value).

  {utp/ut-field.i mgind movto-ggf dt-trans 1}
  assign fi-dt-trans:label in frame {&frame-name} = trim (return-value).

  {utp/ut-field.i mgind movto-ggf cd-turno 1}
  assign fi-cd-turno:label in frame {&frame-name} = trim (return-value).

  {utp/ut-field.i mgind movto-ggf horas-report 1}
  assign fi-horas-report:label in frame {&frame-name} = trim (return-value).

  {utp/ut-field.i mgind item cod-refer 1}
  assign fi-referencia:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind movto-ggf matr-func 1}
  assign fi-matr-func:label in frame {&frame-name} = return-value.

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "movto-ggf"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-ggf"}

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

  find ord-prod where rowid (ord-prod) = gr-ord-prod no-lock no-error.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  run get-attribute in this-procedure ('adm-new-record').
  if return-value = 'yes' then do:
     find first param-cp no-lock no-error.
     find first param-cs no-lock no-error.
     if  param-cp.usa-turno = yes then
         enable fi-cd-turno with frame {&frame-name}.
     enable {&ADM-CREATE-FIELDS} with frame {&frame-name}.
     assign cb-relogio:screen-value in frame {&frame-name} = 
            {ininc/i01in289.i 04 param-cs.tp-relogio}
            i-hr-ini:screen-value in frame {&frame-name} = "0"
            i-hr-fim:screen-value in frame {&frame-name} = "0"
            i-hr:screen-value     in frame {&frame-name} = "0"
            i-min-ini:screen-value in frame {&frame-name} = "0"
            i-min-fim:screen-value in frame {&frame-name} = "0"
            i-min:screen-value     in frame {&frame-name} = "0"
            i-cent-ini:screen-value in frame {&frame-name} = "0"
            i-cent-fim:screen-value in frame {&frame-name} = "0".
     apply "value-changed" to cb-relogio in frame {&frame-name}. 
  end.
  else do:
       assign cb-relogio:screen-value in frame {&frame-name} = {ininc/i01in289.i 04 3}.
       enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  end.

  assign fi-dt-trans:screen-value in frame {&frame-name} = string (today).

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

  {utp/ut-field.i mgind param-cs tp-relogio 1}
  assign cb-relogio:label                in frame {&frame-name} = trim(return-value)
         cb-relogio:list-items           in frame {&frame-name} = {ininc/i01in289.i 03}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

  find ord-prod where rowid (ord-prod) = gr-ord-prod no-lock no-error.

  if avail ord-prod then do:         
     if avail movto-ggf then do:
        assign fi-horas-report = movto-ggf.horas-report
               fi-cd-turno     = movto-ggf.cd-turno
               fi-matr-func    = movto-ggf.matr-func
               fi-referencia   = movto-ggf.referencia.               

        find turno where turno.cd-turno = movto-ggf.cd-turno no-lock no-error.
        if avail turno then 
           assign c-desc-turno = turno.descricao.
        else
            assign c-desc-turno = "".                                     
     end.
  end.

  run dispatch in this-procedure ('display-fields').

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-update-record V-table-Win 
PROCEDURE pi-update-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{include/i-vldfrm.i}
 do with frame {&frame-name}:
    assign input frame {&frame-name} cb-relogio.
    case cb-relogio:
        when {ininc/i01in289.i 04 1} then do:
            if  input i-min > 59 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 3073,
                                   input "").
                apply "entry" to i-min.
                return "ADM-ERROR":U.
            end.
            if  input i-hr + input i-min = 0 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 4511,
                                   input "").
                apply "entry" to i-hr.
                return "ADM-ERROR":U.
            end.
            if  (input i-hr * 60 + input i-min) / 60 <= 0 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 4511,
                                   input "").
                apply "entry" to i-hr.
                return "ADM-ERROR":U.
            end.
        end.
        when {ininc/i01in289.i 04 2} then do:
            if  input i-min-ini > 59 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 3073,
                                   input "").
                apply "entry" to i-min-ini.
                return "ADM-ERROR":U.
            end.
            if  input i-min-fim > 59 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 3073,
                                   input "").
                apply "entry" to i-min-fim.
                return "ADM-ERROR":U.
            end.

            if  input i-hr-ini > 23 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 55855,
                                   input "").
                apply "entry" to i-min-ini.
                return "ADM-ERROR":U.
            end.
            if  input i-hr-fim > 23 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 55855,
                                   input "").
                apply "entry" to i-min-fim.
                return "ADM-ERROR":U.
            end.

            if  ((input i-hr-fim * 60 + input i-min-fim) -
                 (input i-hr-ini * 60 + input i-min-ini)) / 60 <= 0 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 27653,
                                   input "").
                apply "entry" to i-hr-ini.
                return "ADM-ERROR":U.
            end.
        end.
        when {ininc/i01in289.i 04 3} then do:
            if  input fi-horas-report <= 0 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 4511,
                                   input "").
                apply "entry" to fi-horas-report.
                return "ADM-ERROR":U.
            end.
        end.
        when {ininc/i01in289.i 04 4} then do:
            if  input i-cent-fim - input i-cent-ini <= 0 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 27653,
                                   input "").
                apply "entry" to i-cent-ini.
                return "ADM-ERROR":U.
            end.
        end.
    end.

    run get-attribute in this-procedure ('adm-new-record').
    if return-value = "no" then do:
       if date(fi-dt-trans:screen-value in frame {&FRAME-NAME})  < movto-ggf.dt-trans then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show",
                             input 27328,
                             input "").
          apply "entry" to fi-dt-trans.
          return "ADM-ERROR":U.
       end.

       assign de-horas = 0.
       for each b-movto-ggf
           where b-movto-ggf.nr-ord-produ = movto-ggf.nr-ord-produ 
           and   b-movto-ggf.op-codigo    = movto-ggf.op-codigo
           and   b-movto-ggf.cod-roteiro  = movto-ggf.cod-roteiro
           and   b-movto-ggf.cd-tecnico   = movto-ggf.cd-tecnico
           and   b-movto-ggf.cd-tarefa    = movto-ggf.cd-tarefa
           and   b-movto-ggf.gm-codigo    = movto-ggf.gm-codigo
           and   b-movto-ggf.cc-codigo    = movto-ggf.cc-codigo no-lock:
           if b-movto-ggf.tipo-trans = 1 then
              assign de-horas = de-horas + b-movto-ggf.horas-report.
           else
              assign de-horas = de-horas - b-movto-ggf.horas-report.
       end.

       if input fi-horas-report > de-horas then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show",
                             input 4631,
                             input "").
          apply "entry" to i-cent-ini.
          return "ADM-ERROR":U.
       end.

    end.   
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "movto-ggf"}

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

