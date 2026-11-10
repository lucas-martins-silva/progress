&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            MSS
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
{include/i-prgvrs.i V03IN203 2.00.00.013 } /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN203 MUT}
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
DEF VAR l-criticid AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR l-consid-crit LIKE man-fam.log-consid-criticid.

def var h_v01in203 as handle no-undo.

def var r_manut2   as rowid  no-undo.


DEF VAR v-crit-x AS LOGICAL NO-UNDO.
DEF VAR v-crit-y AS LOGICAL NO-UNDO.
DEF VAR v-crit-z AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES man-fam
&Scoped-define FIRST-EXTERNAL-TABLE man-fam


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR man-fam.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS man-fam.log-consid-criticid man-fam.dt-inicio ~
man-fam.dt-termino man-fam.parada man-fam.gera-parada man-fam.cd-parada ~
man-fam.flexib-antec man-fam.flexib-prorr man-fam.dur-man man-fam.gera-pred ~
man-fam.cons-dur-man 
&Scoped-define ENABLED-TABLES man-fam
&Scoped-define FIRST-ENABLED-TABLE man-fam
&Scoped-Define ENABLED-OBJECTS RECT-27 RECT-28 RECT-29 rt-mold 
&Scoped-Define DISPLAYED-FIELDS man-fam.log-consid-criticid ~
man-fam.log-criticid-x man-fam.log-criticid-y man-fam.log-criticid-z ~
man-fam.dt-inicio man-fam.dt-termino man-fam.parada man-fam.gera-parada ~
man-fam.cd-parada man-fam.flexib-antec man-fam.flexib-prorr man-fam.dur-man ~
man-fam.gera-pred man-fam.cons-dur-man 
&Scoped-define DISPLAYED-TABLES man-fam
&Scoped-define FIRST-DISPLAYED-TABLE man-fam
&Scoped-Define DISPLAYED-OBJECTS c-gera-parada c-desc-parada 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

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
DEFINE VARIABLE c-desc-parada AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 44.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-gera-parada AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 24 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 1.88.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 3.75.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 1.54.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 10.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     man-fam.log-consid-criticid AT ROW 8.71 COL 36.72 WIDGET-ID 2
          LABEL "Considera Criticidade por TAG"
          VIEW-AS TOGGLE-BOX
          SIZE 26.29 BY .83
     man-fam.log-criticid-x AT ROW 9.79 COL 36.72 WIDGET-ID 4
          LABEL "Criticidade X"
          VIEW-AS TOGGLE-BOX
          SIZE 24.57 BY .83
     man-fam.log-criticid-y AT ROW 8.71 COL 64.72 WIDGET-ID 6
          LABEL "Criticidade Y"
          VIEW-AS TOGGLE-BOX
          SIZE 14.29 BY .83
     man-fam.log-criticid-z AT ROW 9.79 COL 64.72 WIDGET-ID 8
          LABEL "Criticidade Z"
          VIEW-AS TOGGLE-BOX
          SIZE 14.29 BY .83
     man-fam.dt-inicio AT ROW 1.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     man-fam.dt-termino AT ROW 1.17 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     man-fam.parada AT ROW 3.96 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 22 BY .75
     c-gera-parada AT ROW 3.17 COL 30 COLON-ALIGNED NO-LABEL
     man-fam.gera-parada AT ROW 3.96 COL 32 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Antecipada", 1,
"Prorrogada", 2,
"Parada + Pr¢xima", 3
          SIZE 49 BY .75
     man-fam.cd-parada AT ROW 5.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-desc-parada AT ROW 5.5 COL 33 COLON-ALIGNED NO-LABEL
     man-fam.flexib-antec AT ROW 7.46 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     man-fam.flexib-prorr AT ROW 7.33 COL 41.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     man-fam.dur-man AT ROW 7.33 COL 73.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     man-fam.gera-pred AT ROW 8.75 COL 3.29
          VIEW-AS TOGGLE-BOX
          SIZE 21.72 BY .75
     man-fam.cons-dur-man AT ROW 9.79 COL 3.29
          VIEW-AS TOGGLE-BOX
          SIZE 30.72 BY .83
     RECT-27 AT ROW 3.42 COL 31
     RECT-28 AT ROW 2.88 COL 3
     RECT-29 AT ROW 7 COL 3.14
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.man-fam
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 10
         WIDTH              = 85.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-parada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-gera-parada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX man-fam.log-consid-criticid IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX man-fam.log-criticid-x IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX man-fam.log-criticid-y IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX man-fam.log-criticid-z IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
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

&Scoped-define SELF-NAME man-fam.cd-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-fam.cd-parada V-table-Win
ON F5 OF man-fam.cd-parada IN FRAME f-main /* Parada */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in211.w"
                    &campo=man-fam.cd-parada
                    &campozoom=cd-parada
                    &campo2=c-desc-parada
                    &campozoom2=descricao }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-fam.cd-parada V-table-Win
ON LEAVE OF man-fam.cd-parada IN FRAME f-main /* Parada */
DO:
   {include/leave.i &tabela=mi-parada
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-parada
                    &where="mi-parada.cd-parada = input frame {&frame-name} 
                                                  man-fam.cd-parada"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-fam.cd-parada V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-fam.cd-parada IN FRAME f-main /* Parada */
DO:
    APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-fam.log-consid-criticid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-fam.log-consid-criticid V-table-Win
ON VALUE-CHANGED OF man-fam.log-consid-criticid IN FRAME f-main /* Considera Criticidade TAG */
DO:                                                      
   ASSIGN l-criticid = logical(man-fam.log-consid-criticid:CHECKED IN FRAME f-main).

   ASSIGN man-fam.log-criticid-x:CHECKED IN FRAME f-main = TRUE
          man-fam.log-criticid-y:CHECKED IN FRAME f-main = TRUE
          man-fam.log-criticid-z:CHECKED IN FRAME f-main = TRUE.

   ASSIGN man-fam.log-criticid-x:SENSITIVE IN FRAME f-main = l-criticid
          man-fam.log-criticid-y:SENSITIVE IN FRAME f-main = l-criticid
          man-fam.log-criticid-z:SENSITIVE IN FRAME f-main = l-criticid.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-fam.parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-fam.parada V-table-Win
ON VALUE-CHANGED OF man-fam.parada IN FRAME f-main /* Manuten‡Æo Parada */
DO:
   if  input frame {&frame-name} man-fam.parada = no  then do:
       assign  man-fam.cd-parada:screen-value   in frame {&frame-name} = ""
               c-desc-parada:screen-value       in frame {&frame-name} = ""
               man-fam.gera-parada:screen-value in frame {&frame-name} = "1".
       disable man-fam.cd-parada   with frame {&frame-name}.
       disable man-fam.gera-parada with frame {&frame-name}.   
   end.
   else do: 
       enable  man-fam.cd-parada   with frame {&frame-name}.
       enable  man-fam.gera-parada with frame {&frame-name}.
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

  if  man-fam.cd-parada:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.
  { utp/ut-rtlbl.i mgind man-fam gera-parada c-gera-parada }

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
  {src/adm/template/row-list.i "man-fam"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "man-fam"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
  
  /* Code placed here will execute AFTER standard behavior.    */
     { utp/ut-rtlbl.i mgind man-fam gera-parada c-gera-parada }
     
   if  input frame {&frame-name} man-fam.parada = no  then do:
       assign  man-fam.cd-parada:screen-value   in frame {&frame-name} = ""
               c-desc-parada:screen-value       in frame {&frame-name} = ""
               man-fam.gera-parada:screen-value in frame {&frame-name} = "1".
       disable man-fam.cd-parada 
               man-fam.gera-parada       with frame {&frame-name}.   
   end.
   else do: 
       enable  man-fam.cd-parada    
               man-fam.gera-parada       with frame {&frame-name}.
   end. 
  
  /* Data de Corte INICIAL */
     display  today  @  man-fam.dt-inicio  with frame {&frame-name}.


   ASSIGN man-fam.log-consid-criticid:CHECKED IN FRAME f-main = NO
          man-fam.log-criticid-x:CHECKED IN FRAME f-main = TRUE
          man-fam.log-criticid-y:CHECKED IN FRAME f-main = TRUE
          man-fam.log-criticid-z:CHECKED IN FRAME f-main = TRUE.

   ASSIGN man-fam.log-criticid-x:SENSITIVE IN FRAME f-main = NO
          man-fam.log-criticid-y:SENSITIVE IN FRAME f-main = NO
          man-fam.log-criticid-z:SENSITIVE IN FRAME f-main = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  
  /* Ponha aqui a valida‡Æo de chave duplicada */

  ASSIGN v-crit-x = man-fam.log-criticid-x:CHECKED IN FRAME f-main
         v-crit-y = man-fam.log-criticid-y:CHECKED IN FRAME f-main
         v-crit-z = man-fam.log-criticid-z:CHECKED IN FRAME f-main.

  
  /* Ponha aqui as demais valida‡äes */
   
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Parametros Plano Familia X Criticidade do TAG                            */


  ASSIGN man-fam.log-criticid-x = v-crit-x
         man-fam.log-criticid-y = v-crit-y
         man-fam.log-criticid-z = v-crit-z.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  ASSIGN man-fam.log-criticid-x:SENSITIVE IN FRAME f-main = NO
         man-fam.log-criticid-y:SENSITIVE IN FRAME f-main = NO
         man-fam.log-criticid-z:SENSITIVE IN FRAME f-main = NO.

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
  if  available man-fam then do:
      find mi-parada where mi-parada.cd-parada = man-fam.cd-parada no-lock no-error.
      assign c-desc-parada = if avail mi-parada then mi-parada.descricao else "":U.
      displ  c-desc-parada with frame {&frame-name}. 
  end.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .


  /* Code placed here will execute AFTER standard behavior.    */
  { utp/ut-rtlbl.i mgind man-fam gera-parada c-gera-parada }


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
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
   if  input frame {&frame-name} man-fam.parada = no  then do:
       assign  man-fam.cd-parada:screen-value   in frame {&frame-name} = ""
               c-desc-parada:screen-value       in frame {&frame-name} = ""
               man-fam.gera-parada:screen-value in frame {&frame-name} = "1".
       disable man-fam.cd-parada 
               man-fam.gera-parada       with frame {&frame-name}.   
   end.
   else do: 
       enable  man-fam.cd-parada    
               man-fam.gera-parada       with frame {&frame-name}.
   end. 

   ASSIGN l-consid-crit = man-fam.log-consid-criticid:CHECKED IN FRAME f-main.
   IF l-consid-crit = YES THEN DO:
       ASSIGN man-fam.log-criticid-x:SENSITIVE IN FRAME f-main = YES
              man-fam.log-criticid-y:SENSITIVE IN FRAME f-main = YES
              man-fam.log-criticid-z:SENSITIVE IN FRAME f-main = YES.
   END.

   ELSE DO: 
       ASSIGN man-fam.log-criticid-x:SENSITIVE IN FRAME f-main = NO
              man-fam.log-criticid-y:SENSITIVE IN FRAME f-main = NO
              man-fam.log-criticid-z:SENSITIVE IN FRAME f-main = NO.
   END.

  run pi-passa-manut in h_v01in203 (output r_manut2) no-error.
  find first manut where rowid(manut) = r_manut2 no-lock no-error.
  
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
  { utp/ut-rtlbl.i mgind man-fam gera-parada c-gera-parada }
  
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dado-inicial V-table-Win 
PROCEDURE pi-dado-inicial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  define input parameter r-manut as rowid.  
  find manut where rowid (manut) = r-manut no-lock no-error.
  if avail manut then
    assign  man-fam.dt-inicio:screen-value    in frame {&frame-name} =  string(manut.dt-inicio)
            man-fam.dt-termino:screen-value   in frame {&frame-name} =  string(manut.dt-termino)
            man-fam.parada:checked            in frame {&frame-name} =  manut.parada
            man-fam.gera-parada:screen-value  in frame {&frame-name} =  string(manut.gera-parada)
            man-fam.cd-parada:screen-value    in frame {&frame-name} =  string(manut.cd-parada)
            man-fam.flexib-antec:screen-value in frame {&frame-name} =  string(manut.flexib-antec)          
            man-fam.flexib-prorr:screen-value in frame {&frame-name} =  string(manut.flexib-prorr)
            man-fam.dur-man:screen-value      in frame {&frame-name} =  string(manut.dur-man)  
            man-fam.cons-dur-man:checked      in frame {&frame-name} =  manut.cons-dur-man .

  {include/leave.i &tabela=mi-parada
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-parada
                   &where="mi-parada.cd-parada = input frame {&frame-name} 
                                                 man-fam.cd-parada"}

   if  input frame {&frame-name} man-fam.parada = no  then do:
       assign  man-fam.cd-parada:screen-value   in frame {&frame-name} = ""
               c-desc-parada:screen-value       in frame {&frame-name} = ""
               man-fam.gera-parada:screen-value in frame {&frame-name} = "1".
       disable man-fam.cd-parada   
               man-fam.gera-parada with frame {&frame-name}.   
   end.
   else do: 
       enable  man-fam.cd-parada   
               man-fam.gera-parada with frame {&frame-name}.
   end.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-get-consid V-table-Win 
PROCEDURE pi-get-consid :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER v-consid-criticid AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER v-criticid-x AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER v-criticid-y AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER v-criticid-z AS LOGICAL NO-UNDO.


    ASSIGN v-consid-criticid = input frame {&frame-name} man-fam.log-consid-criticid
           v-criticid-x = input frame {&frame-name} man-fam.log-criticid-x
           v-criticid-y = input frame {&frame-name} man-fam.log-criticid-y
           v-criticid-z = input frame {&frame-name} man-fam.log-criticid-z.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param h_viewer as handle no-undo.

assign h_v01in203 = h_viewer.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
  if  man-fam.cd-parada:sensitive in frame {&frame-name} = yes 
      and (input frame {&frame-name} man-fam.cd-parada = "" 
      or not can-find (mi-parada where mi-parada.cd-parada = input frame {&frame-name} 
                                                             man-fam.cd-parada))
  then do: 
      {utp/ut-table.i mgind mi-parada 1}
      {include/i-vldprg.i}  /* posiciona pagina */
      run utp/ut-msgs.p(input "show",
                        input 2,
                        input return-value).
      apply 'entry' to man-fam.cd-parada.
      return 'ADM-ERROR'.
  end.  
  
   
   if input frame {&FRAME-NAME} man-fam.dt-inicio > input frame {&FRAME-NAME} man-fam.dt-termino then do:
      {include/i-vldprg.i}  /* posiciona pagina */
      run utp/ut-msgs.p (input "show",
                         input 508,
                         input trim(man-fam.dt-inicio:label in frame {&FRAME-NAME}) + "~~" + 
                               trim(man-fam.dt-termino:label in frame {&FRAME-NAME})). 
      apply 'entry' to man-fam.dt-inicio in frame {&frame-name}.
      return 'ADM-ERROR'.
   end. 
  
     
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
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
  {src/adm/template/snd-list.i "man-fam"}

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

