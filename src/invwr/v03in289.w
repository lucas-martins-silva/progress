&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V03IN289 2.00.00.014}  /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v03in289 MUT}
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
&Scoped-define EXTERNAL-TABLES param-mi
&Scoped-define FIRST-EXTERNAL-TABLE param-mi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-mi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-mi.ct-prev param-mi.sc-prev ~
param-mi.ct-corretiva param-mi.sc-corretiva param-mi.ct-serv-ger ~
param-mi.sc-serv-ger param-mi.cd-equipto param-mi.perm-equip ~
param-mi.forma-aloc-esp param-mi.it-codigo param-mi.ordem-unica ~
param-mi.aloca-estoq param-mi.tp-relogio 
&Scoped-define ENABLED-TABLES param-mi
&Scoped-define FIRST-ENABLED-TABLE param-mi
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-3 RECT-30 RECT-1 
&Scoped-Define DISPLAYED-FIELDS param-mi.ct-prev param-mi.sc-prev ~
param-mi.ct-corretiva param-mi.sc-corretiva param-mi.ct-serv-ger ~
param-mi.sc-serv-ger param-mi.cd-equipto param-mi.perm-equip ~
param-mi.forma-aloc-esp param-mi.it-codigo param-mi.ordem-unica ~
param-mi.aloca-estoq param-mi.tp-relogio 
&Scoped-define DISPLAYED-TABLES param-mi
&Scoped-define FIRST-DISPLAYED-TABLE param-mi
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-2 c-forma-aloc-esp FILL-IN-1 

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
DEFINE VARIABLE c-forma-aloc-esp AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15.86 BY .67 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11.72 BY .67 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 27 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73.86 BY 1.33.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39 BY 1.29.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 33.14 BY 1.29.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 76 BY 10.17.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-mi.ct-prev AT ROW 1.17 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     param-mi.sc-prev AT ROW 1.17 COL 47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     param-mi.ct-corretiva AT ROW 2.17 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     param-mi.sc-corretiva AT ROW 2.17 COL 47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     param-mi.ct-serv-ger AT ROW 3.17 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     param-mi.sc-serv-ger AT ROW 3.17 COL 47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     param-mi.cd-equipto AT ROW 4.17 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     param-mi.perm-equip AT ROW 6.29 COL 2.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sim", 1,
"Sim com confirmaá∆o", 2,
"N∆o", 3
          SIZE 37.43 BY .67
     param-mi.forma-aloc-esp AT ROW 6.29 COL 46 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Backward", 1,
"Forward", 2
          SIZE 28.14 BY .67
     param-mi.it-codigo AT ROW 7.5 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     param-mi.ordem-unica AT ROW 8.5 COL 5.86
          VIEW-AS TOGGLE-BOX
          SIZE 32.29 BY .75
     param-mi.aloca-estoq AT ROW 8.5 COL 44
          VIEW-AS TOGGLE-BOX
          SIZE 30.43 BY .75
     param-mi.tp-relogio AT ROW 9.83 COL 16.43 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Hor†rio", 1,
"Dif Hor†ria", 2,
"Centesimal", 3,
"Dif Centesimal", 4
          SIZE 58.29 BY .79
     FILL-IN-2 AT ROW 5.5 COL 2 COLON-ALIGNED NO-LABEL
     c-forma-aloc-esp AT ROW 5.5 COL 41.43 COLON-ALIGNED NO-LABEL
     FILL-IN-1 AT ROW 9.33 COL 3.14 NO-LABEL
     rt-mold AT ROW 1 COL 1
     RECT-3 AT ROW 5.88 COL 2.14
     RECT-30 AT ROW 5.88 COL 42.43
     RECT-1 AT ROW 9.54 COL 1.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-mi
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
         HEIGHT             = 10.25
         WIDTH              = 76.29.
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

/* SETTINGS FOR FILL-IN c-forma-aloc-esp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME f-main
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

&Scoped-define SELF-NAME param-mi.cd-equipto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.cd-equipto V-table-Win
ON F5 OF param-mi.cd-equipto IN FRAME f-main /* Equipamento */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in095.w"
                &tabela=param-mi
                &atributo=cd-equipto}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.cd-equipto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-mi.cd-equipto IN FRAME f-main /* Equipamento */
DO:
  apply 'F5' to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-mi.ct-corretiva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.ct-corretiva V-table-Win
ON F5 OF param-mi.ct-corretiva IN FRAME f-main /* Conta Padr∆o Manut Corretiva */
DO:
  find first param-global no-lock no-error.
  assign i-ep-codigo-usuario = param-global.empresa-prin.

  assign l-implanta = yes.
  {include/zoomvar.i  &prog-zoom="adzoom/z01ad049.w"
                        &campo=param-mi.ct-corretiva
                        &campozoom=ct-codigo
                        &campo2=param-mi.sc-corretiva
                        &campozoom2=sc-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.ct-corretiva V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-mi.ct-corretiva IN FRAME f-main /* Conta Padr∆o Manut Corretiva */
DO:
  apply 'F5' to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-mi.ct-prev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.ct-prev V-table-Win
ON F5 OF param-mi.ct-prev IN FRAME f-main /* Conta Padr∆o Manut Preventiva */
DO:
  find first param-global no-lock no-error.
  assign i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = yes.

  {include/zoomvar.i  &prog-zoom="adzoom/z01ad049.w"
                        &campo=param-mi.ct-prev
                        &campozoom=ct-codigo
                        &campo2=param-mi.sc-prev
                        &campozoom2=sc-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.ct-prev V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-mi.ct-prev IN FRAME f-main /* Conta Padr∆o Manut Preventiva */
DO:
  apply 'F5' to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-mi.ct-serv-ger
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.ct-serv-ger V-table-Win
ON F5 OF param-mi.ct-serv-ger IN FRAME f-main /* Conta Padr∆o Serviáos Gerais */
DO:
  find first param-global no-lock no-error.
  assign i-ep-codigo-usuario = param-global.empresa-prin.

  assign l-implanta = yes.
  {include/zoomvar.i  &prog-zoom="adzoom/z01ad049.w"
                        &campo=param-mi.ct-serv-ger
                        &campozoom=ct-codigo
                        &campo2=param-mi.sc-serv-ger
                        &campozoom2=sc-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.ct-serv-ger V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-mi.ct-serv-ger IN FRAME f-main /* Conta Padr∆o Serviáos Gerais */
DO:
  apply 'F5' to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-mi.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.it-codigo V-table-Win
ON F5 OF param-mi.it-codigo IN FRAME f-main /* Item */
DO:
  {include/zoom.i &prog-zoom="inzoom/z02in172.w"
                &tabela=param-mi
                &atributo=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-mi.it-codigo IN FRAME f-main /* Item */
DO:
  apply 'F5' to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-mi.sc-corretiva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.sc-corretiva V-table-Win
ON F5 OF param-mi.sc-corretiva IN FRAME f-main /* SC Corret */
DO:
  find first param-global no-lock no-error.
  assign i-ep-codigo-usuario = param-global.empresa-prin.

  assign l-implanta = yes.
  {include/zoomvar.i  &prog-zoom="adzoom/z01ad049.w"
                        &campo=param-mi.ct-corretiva
                        &campozoom=ct-codigo
                        &campo2=param-mi.sc-corretiva
                        &campozoom2=sc-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.sc-corretiva V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-mi.sc-corretiva IN FRAME f-main /* SC Corret */
DO:
  apply 'F5' to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-mi.sc-prev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.sc-prev V-table-Win
ON F5 OF param-mi.sc-prev IN FRAME f-main /* SC Prev */
DO:
  find first param-global no-lock no-error.
  assign i-ep-codigo-usuario = param-global.empresa-prin.

  assign l-implanta = yes.
  {include/zoomvar.i  &prog-zoom="adzoom/z01ad049.w"
                        &campo=param-mi.ct-prev
                        &campozoom=ct-codigo
                        &campo2=param-mi.sc-prev
                        &campozoom2=sc-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.sc-prev V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-mi.sc-prev IN FRAME f-main /* SC Prev */
DO:
  apply 'F5' to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-mi.sc-serv-ger
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.sc-serv-ger V-table-Win
ON F5 OF param-mi.sc-serv-ger IN FRAME f-main /* SC Serv Geral */
DO:
  find first param-global no-lock no-error.
  assign i-ep-codigo-usuario = param-global.empresa-prin.

  assign l-implanta = yes.
  {include/zoomvar.i  &prog-zoom="adzoom/z01ad049.w"
                        &campo=param-mi.ct-serv-ger
                        &campozoom=ct-codigo
                        &campo2=param-mi.sc-serv-ger
                        &campozoom2=sc-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.sc-serv-ger V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-mi.sc-serv-ger IN FRAME f-main /* SC Serv Geral */
DO:
  apply 'F5' to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  if param-mi.ct-prev:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if param-mi.sc-prev:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if param-mi.ct-corretiva:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if param-mi.sc-corretiva:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if param-mi.ct-serv-ger:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if param-mi.sc-serv-ger:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if param-mi.cd-equipto:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if param-mi.it-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  {utp/ut-rtlbl.i mgind param-mi tp-relogio     fill-in-1}
  {utp/ut-rtlbl.i mgind param-mi forma-aloc-esp c-forma-aloc-esp}


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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "param-mi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-mi"}

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

  {utp/ut-rtlbl.i mgind param-mi tp-relogio     fill-in-1}

  {utp/ut-rtlbl.i mgind param-mi forma-aloc-esp c-forma-aloc-esp}


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
  {include/i-valid.i}
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  {utp/ut-rtlbl.i mgind param-mi tp-relogio fill-in-1}
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-rtlbl.i mgind param-mi tp-relogio     fill-in-1}

  {utp/ut-rtlbl.i mgind param-mi forma-aloc-esp c-forma-aloc-esp}


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

  {utp/ut-rtlbl.i mgind param-mi tp-relogio     fill-in-1}

  {utp/ut-rtlbl.i mgind param-mi forma-aloc-esp c-forma-aloc-esp}



   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ).
   /* Code placed here will execute AFTER standard behavior.    */

   FIND FIRST param-global NO-LOCK NO-ERROR.
   IF  NOT AVAILABLE param-global THEN DO:
       RUN utp/ut-msgs.p (input "show",
                          input 16,
                          input "").
       RETURN 'adm-error'.
       RETURN.
   END.

   param-mi.tp-relogio:disable(entry (3, param-mi.tp-relogio:radio-buttons
            in frame {&frame-name})) in frame {&frame-name}.
   param-mi.tp-relogio:disable(entry (7, param-mi.tp-relogio:radio-buttons
            in frame {&frame-name})) in frame {&frame-name}.

  {utp/ut-liter.i Permite_Equipamento_Diferente_Ativo *}
  ASSIGN fill-in-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} =  RETURN-VALUE.

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
  {include/i-vldfrm.i} 

  /* Ponha aqui as demais validaá‰es   CONTA PADRAO MANUT PREV */

   find item where item.it-codigo = input frame {&frame-name} param-mi.it-codigo no-lock no-error.
   if not avail item then do:
       run utp/ut-msgs.p (input "show",
                          input 563,
                          input ""). 
       return 'ADM-ERROR'.

    end.
    if item.cod-obsoleto <> 1 then do:
       run utp/ut-msgs.p (input "show",
                          input 7936,
                          input "").
       return 'ADM-ERROR'. 
    end.   
    if item.tipo-contr <> 4 then do:
       run utp/ut-msgs.p (input "show",
                          input 851,
                          input "").
       return 'ADM-ERROR'.
    end. 

   find conta-contab
        where conta-contab.ep-codigo = i-ep-codigo-usuario
        and   conta-contab.ct-codigo = input frame {&frame-name} param-mi.ct-prev
        and   conta-contab.sc-codigo = input frame {&frame-name} param-mi.sc-prev
        no-lock no-error.
    if  not available conta-contab then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 1060,
                          input "" ).
        apply 'entry' to param-mi.ct-prev in frame {&frame-name}. 
        return 'ADM-ERROR':U .          
    end.
    else if  conta-contab.estado <> 3 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 912,
                          input "" ).
        apply 'entry' to param-mi.ct-prev in frame {&frame-name}.
        return 'ADM-ERROR':U .           
    end.
    else if  conta-contab.tipo <> 5 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                           input 617,
                           input "" ).
        apply 'entry' to param-mi.ct-prev in frame {&frame-name}.
        return 'ADM-ERROR':U .
    end.
    else if  conta-contab.estoque <> 3 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 620,
                          input "" ).
        apply 'entry' to param-mi.ct-prev in frame {&frame-name}.
        return 'ADM-ERROR':U .
    end.
    /* Ponha aqui as demais validaá‰es   CONTA PADRAO MANUT CORRET */
    find conta-contab
        where conta-contab.ep-codigo = i-ep-codigo-usuario
        and   conta-contab.ct-codigo = input frame {&frame-name} param-mi.ct-corretiva
        and   conta-contab.sc-codigo = input frame {&frame-name} param-mi.sc-corretiva
        no-lock no-error.
    if  not available conta-contab then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 1060,
                          input "" ).
        apply 'entry' to param-mi.ct-corretiva in frame {&frame-name}. 
        return 'ADM-ERROR':U .          
    end.
    else if  conta-contab.estado <> 3 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 912,
                          input "" ).
        apply 'entry' to param-mi.ct-corretiva in frame {&frame-name}.
        return 'ADM-ERROR':U .           
    end.
    else if  conta-contab.tipo <> 5 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 617,
                          input "" ).
        apply 'entry' to param-mi.ct-corretiva in frame {&frame-name}.
        return 'ADM-ERROR':U .
    end.
    else if  conta-contab.estoque <> 3 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 620,
                          input "" ).
        apply 'entry' to param-mi.ct-corretiva in frame {&frame-name}.
        return 'ADM-ERROR':U .
    end.
    /* Ponha aqui as demais validaá‰es   CONTA PADRAO SERV GER */
    find conta-contab
        where conta-contab.ep-codigo = i-ep-codigo-usuario
        and   conta-contab.ct-codigo = input frame {&frame-name} param-mi.ct-serv-ger
        and   conta-contab.sc-codigo = input frame {&frame-name} param-mi.sc-serv-ger
        no-lock no-error.
    if  not available conta-contab then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 1060,
                          input "" ).
        apply 'entry' to param-mi.ct-serv-ger in frame {&frame-name}. 
        return 'ADM-ERROR':U .          
    end.
    else if  conta-contab.estado <> 3 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 912,
                          input "" ).
        apply 'entry' to param-mi.ct-serv-ger in frame {&frame-name}.
        return 'ADM-ERROR':U .           
    end.
    else if  conta-contab.tipo <> 5 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 617,
                          input "" ).
        apply 'entry' to param-mi.ct-serv-ger in frame {&frame-name}.
        return 'ADM-ERROR':U .
    end.
    else if  conta-contab.estoque <> 3 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 620,
                          input "" ).
        apply 'entry' to param-mi.ct-serv-ger in frame {&frame-name}.
        return 'ADM-ERROR':U .
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "param-mi"}

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

