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
{include/i-prgvrs.i V01IN012 2.00.00.010}  /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN012 MUT}
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
def var rw-parent as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-lista-classe as char no-undo.
def buffer b-alt-reci for alt-reci.
def buffer b-tp-recur for tp-recur.

def var i-classe as int  no-undo.
def var c-un     as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES alt-reci
&Scoped-define FIRST-EXTERNAL-TABLE alt-reci


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR alt-reci.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS alt-reci.qt-item alt-reci.dias-utiliz ~
alt-reci.qt-utilizada alt-reci.defasagem alt-reci.observacao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}qt-item ~{&FP2}qt-item ~{&FP3}~
 ~{&FP1}dias-utiliz ~{&FP2}dias-utiliz ~{&FP3}~
 ~{&FP1}qt-utilizada ~{&FP2}qt-utilizada ~{&FP3}~
 ~{&FP1}defasagem ~{&FP2}defasagem ~{&FP3}~
 ~{&FP1}observacao ~{&FP2}observacao ~{&FP3}
&Scoped-define ENABLED-TABLES alt-reci
&Scoped-define FIRST-ENABLED-TABLE alt-reci
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold rt-mold-2 
&Scoped-Define DISPLAYED-FIELDS rec-item.it-codigo rec-item.sequencia ~
rec-item.tp-recurso rec-item.cd-recurso alt-reci.ordem ~
alt-reci.tp-rec-altern alt-reci.cd-rec-altern alt-reci.qt-item ~
alt-reci.dias-utiliz alt-reci.qt-utilizada alt-reci.defasagem ~
alt-reci.observacao 
&Scoped-Define DISPLAYED-OBJECTS c-desc-item-pai c-tp-recur-descricao-pai ~
c-tp-recur-classe-pai c-cod-un-pai c-tp-recur-descricao c-tp-recur-classe ~
c-descricao c-un-item c-tp-recur-un 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS alt-reci.ordem alt-reci.tp-rec-altern ~
alt-reci.cd-rec-altern 

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
DEFINE VARIABLE c-cod-un-pai AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 14.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item-pai AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 38.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(35)" 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-recur-classe AS CHARACTER FORMAT "X(30)":U 
     LABEL "classe" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-recur-classe-pai AS CHARACTER FORMAT "X(30)":U 
     LABEL "classe" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-recur-descricao AS CHARACTER FORMAT "x(35)" 
     VIEW-AS FILL-IN 
     SIZE 36.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-recur-descricao-pai AS CHARACTER FORMAT "x(35)" 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-recur-un AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-item AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 9.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.25.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     rec-item.it-codigo AT ROW 1.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item-pai AT ROW 1.17 COL 44.72 COLON-ALIGNED NO-LABEL
     rec-item.sequencia AT ROW 2.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     rec-item.tp-recurso AT ROW 3.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     c-tp-recur-descricao-pai AT ROW 3.17 COL 36.72 COLON-ALIGNED NO-LABEL
     c-tp-recur-classe-pai AT ROW 4.17 COL 27 COLON-ALIGNED
     rec-item.cd-recurso AT ROW 5.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-cod-un-pai AT ROW 5.17 COL 44.72 COLON-ALIGNED NO-LABEL
     alt-reci.ordem AT ROW 6.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     alt-reci.tp-rec-altern AT ROW 7.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     c-tp-recur-descricao AT ROW 7.17 COL 36.72 COLON-ALIGNED NO-LABEL
     c-tp-recur-classe AT ROW 8.17 COL 27 COLON-ALIGNED
     alt-reci.cd-rec-altern AT ROW 9.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-descricao AT ROW 9.17 COL 44.72 COLON-ALIGNED NO-LABEL
     alt-reci.qt-item AT ROW 10.63 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-un-item AT ROW 10.63 COL 35.57 COLON-ALIGNED NO-LABEL
     alt-reci.dias-utiliz AT ROW 10.63 COL 74.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     alt-reci.qt-utilizada AT ROW 11.63 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.86 BY .88
     c-tp-recur-un AT ROW 11.63 COL 42.29 COLON-ALIGNED NO-LABEL
     alt-reci.defasagem AT ROW 11.63 COL 74.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     alt-reci.observacao AT ROW 13.13 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 10.46 COL 1
     rt-mold-2 AT ROW 12.96 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.alt-reci
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 13.21
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-cod-un-pai IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item-pai IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tp-recur-classe IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tp-recur-classe-pai IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tp-recur-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tp-recur-descricao-pai IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tp-recur-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN alt-reci.cd-rec-altern IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN rec-item.cd-recurso IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rec-item.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN alt-reci.ordem IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN rec-item.sequencia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN alt-reci.tp-rec-altern IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN rec-item.tp-recurso IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME alt-reci.cd-rec-altern
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alt-reci.cd-rec-altern V-table-Win
ON F5 OF alt-reci.cd-rec-altern IN FRAME f-main /* Recurso Alternativo */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in373.w
                     &campo=alt-reci.cd-rec-altern
                     &campozoom=cd-recurso
                     &parametros="run pi-seta-inicial in wh-pesquisa (input alt-reci.tp-rec-altern:screen-value)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alt-reci.cd-rec-altern V-table-Win
ON LEAVE OF alt-reci.cd-rec-altern IN FRAME f-main /* Recurso Alternativo */
DO:
  if {ininc/i01in439.i 06 c-tp-recur-classe:screen-value in frame {&frame-name}} = 1 then do:
     find first mgind.recurso
          WHERE mgind.recurso.tp-recurso = input frame {&frame-name} alt-reci.tp-rec-altern 
          and   mgind.recurso.cd-recurso = input frame {&frame-name} alt-reci.cd-rec-altern no-lock no-error.
     find grup-maquina where grup-maquina.gm-codigo = recurso.gm-codigo no-lock no-error.
     assign c-descricao:screen-value in frame {&frame-name} = if avail grup-maquina then grup-maquina.descricao else "":U.
  end.
  else 
  if {ininc/i01in439.i 06 c-tp-recur-classe:screen-value in frame {&frame-name}} = 2 then do:
     find first mgind.recurso
          WHERE mgind.recurso.tp-recurso = input frame {&frame-name} alt-reci.tp-rec-altern
          and   mgind.recurso.cd-recurso = input frame {&frame-name} alt-reci.cd-rec-altern no-lock no-error.
     find item  where item.it-codigo = recurso.it-codigo no-lock no-error.
     assign c-descricao:screen-value in frame {&frame-name} = if avail item then item.desc-item else "":U.
  end.
  else 
  if {ininc/i01in439.i 06 c-tp-recur-classe:screen-value in frame {&frame-name}} = 3 then do:
     find first mgind.recurso
          WHERE mgind.recurso.tp-recurso = input frame {&frame-name} alt-reci.tp-rec-altern
          and   mgind.recurso.cd-recurso = input frame {&frame-name} alt-reci.cd-rec-altern no-lock no-error.
     find equipto where equipto.cd-equipto = recurso.cod-altern no-lock no-error.
     assign c-descricao:screen-value in frame {&frame-name} = if avail equipto then equipto.descricao else "":U.
  end. 
  else assign c-descricao:screen-value in frame {&frame-name} = "":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alt-reci.cd-rec-altern V-table-Win
ON MOUSE-SELECT-DBLCLICK OF alt-reci.cd-rec-altern IN FRAME f-main /* Recurso Alternativo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME alt-reci.tp-rec-altern
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alt-reci.tp-rec-altern V-table-Win
ON F5 OF alt-reci.tp-rec-altern IN FRAME f-main /* Tp Rec Alternativo */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in439.w
                     &campo=alt-reci.tp-rec-altern
                     &campozoom=tp-recurso
                     &campo2=c-tp-recur-descricao
                     &campozoom2=descricao
                     &campo3=c-tp-recur-un
                     &campozoom3=cod-unid-capac}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alt-reci.tp-rec-altern V-table-Win
ON LEAVE OF alt-reci.tp-rec-altern IN FRAME f-main /* Tp Rec Alternativo */
DO:
  {include/leave.i &tabela=tp-recur
                   &atributo-ref=descricao
                   &variavel-ref=c-tp-recur-descricao
                   &atributo-ref2=cod-unid-capac
                   &variavel-ref2=c-tp-recur-un
                   &where="tp-recur.tp-recurso = input frame {&frame-name} alt-reci.tp-rec-altern"}
  assign c-tp-recur-classe:screen-value in frame {&frame-name} = 
  if avail tp-recur then entry(tp-recur.cl-recurso,c-lista-classe) else "":U.
  
  assign c-un-item:screen-value in frame {&frame-name} = if avail item then item.un else "":U.

/*******************  
  if avail tp-recur then do:
     if tp-recur.cl-recurso <> i-classe or tp-recur.cod-unid-capac <> c-un then do:
        assign c-tp-recur-descricao:screen-value = "":U
               c-tp-recur-classe:screen-value    = "":U.
        {utp/ut-table.i mgind alt-reci 1}
        run utp/ut-msgs.p (input 'show', 
                           input 6197,
                           input return-value).
        apply "entry" to alt-reci.tp-rec-altern in frame {&frame-name}.
        return no-apply.
     end.
  end.   
********************/
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alt-reci.tp-rec-altern V-table-Win
ON MOUSE-SELECT-DBLCLICK OF alt-reci.tp-rec-altern IN FRAME f-main /* Tp Rec Alternativo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  {utp/ut-field.i mgind tp-recur cl-recurso 1}
  assign c-tp-recur-classe:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind tp-recur cl-recurso 1}
  assign c-tp-recur-classe-pai:label in frame {&frame-name} = return-value.
  
  if alt-reci.tp-rec-altern:load-mouse-pointer('image/lupa.cur') in frame {&frame-name} then.
  if alt-reci.cd-rec-altern:load-mouse-pointer('image/lupa.cur') in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "alt-reci"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "alt-reci"}

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
  find last param-pm no-lock no-error.
  find rec-item where rowid(rec-item) = v-row-parent no-lock.
  find last b-alt-reci 
       where b-alt-reci.it-codigo  = rec-item.it-codigo 
       and   b-alt-reci.sequencia  = rec-item.sequencia
       and   b-alt-reci.tp-recurso = rec-item.tp-recurso
       and   b-alt-reci.cd-recurso = rec-item.cd-recurso
       no-lock no-error.
       
  if avail b-alt-reci then
     display (b-alt-reci.ordem + param-pm.num-var-recurso) @ alt-reci.ordem with frame {&frame-name}.
  else 
     display param-pm.num-var-recurso @ alt-reci.ordem with frame {&frame-name}.
     
  assign alt-reci.qt-item:screen-value in frame {&frame-name}      = string(rec-item.qt-item)
         alt-reci.qt-utilizada:screen-value in frame {&frame-name} = string(rec-item.qt-utilizada)
         alt-reci.dias-utiliz:screen-value in frame {&frame-name}  = string(rec-item.dias-utiliz)
         alt-reci.defasagem:screen-value in frame {&frame-name}    = string(rec-item.defasagem).
         
  display c-un-item 
          c-desc-item-pai
          c-tp-recur-descricao-pai
          c-tp-recur-classe-pai
          c-cod-un-pai with frame {&frame-name}.      

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
      
  find rec-item where rowid(rec-item) = rw-parent no-lock.

  run pi-validate.
  if return-value = "ADM-ERROR" then 
     return 'ADM-ERROR':U.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if avail rec-item then
     assign alt-reci.it-codigo  = rec-item.it-codigo
            alt-reci.sequencia  = rec-item.sequencia
            alt-reci.tp-recurso = rec-item.tp-recurso
            alt-reci.cd-recurso = rec-item.cd-recurso.

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
  if avail alt-reci then do:
     find tp-recur where tp-recur.tp-recurso = alt-reci.tp-rec-altern no-lock no-error.
     find item where item.it-codigo =  alt-reci.it-codigo no-lock no-error.
     assign c-tp-recur-descricao    = if avail tp-recur then tp-recur.descricao else "":U
            c-tp-recur-classe       = if avail tp-recur then 
                                         entry(tp-recur.cl-recurso,c-lista-classe) else "":U
            c-tp-recur-un           = if avail tp-recur then tp-recur.cod-unid-capac else "":U
            c-un-item               = if avail item then item.un else "":U.
  end.
  
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  find recurso 
       where recurso.tp-recurso = alt-reci.tp-rec-altern 
       and   recurso.cd-recurso = alt-reci.cd-rec-altern no-lock no-error.
  if avail recurso then do:
     if tp-recur.cl-recurso = 1 then do:
        find grup-maquina where grup-maquina.gm-codigo = recurso.gm-codigo no-lock.
        assign c-descricao:screen-value in frame {&frame-name} = grup-maquina.descricao.
     end.
     else if tp-recur.cl-recurso = 2 then do:
        find item where item.it-codigo = recurso.it-codigo no-lock no-error.
        assign c-descricao:screen-value in frame {&frame-name} = item.desc-item.
     end.
     else if tp-recur.cl-recurso = 3 then do:
        find equipto where equipto.cd-equipto = recurso.cod-alternat no-lock no-error.
        assign c-descricao:screen-value in frame {&frame-name} = equipto.descricao.
     end.
     else assign c-descricao:screen-value in frame {&frame-name} = "". 
  end. 
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
  
  find rec-item where rowid(rec-item) = v-row-parent no-lock.
  assign rw-parent = v-row-parent.
  
  find item where item.it-codigo = rec-item.it-codigo no-lock.
  find tp-recur where tp-recur.tp-recurso = rec-item.tp-recurso no-lock.
     
  assign i-classe                 = tp-recur.cl-recurso
         c-un                     = tp-recur.cod-unid-capac 
         c-un-item                = item.un
         c-desc-item-pai          = item.desc-item
         c-tp-recur-descricao-pai = tp-recur.descricao 
         c-lista-classe           = {ininc/i01in439.i 03}
         c-tp-recur-classe-pai    = entry(tp-recur.cl-recurso,c-lista-classe)         
         c-cod-un-pai             = tp-recur.cod-unid-capac.  
           
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  def var c-label-aux as char no-undo.
  def var c-tp-rec-altern as char no-undo. 
  def var c-tp-recurso as char no-undo.


  /*** Validaá∆o c¢digo do recurso ***/
  find recurso 
       where recurso.tp-recurso = input frame {&frame-name} alt-reci.tp-rec-altern
       and   recurso.cd-recurso = input frame {&frame-name} alt-reci.cd-rec-altern
       no-lock no-error.
  if not avail recurso then do:
     {utp/ut-table.i mgind recurso 1}
     run utp/ut-msgs.p (input 'show', 
                        input 56,
                        input return-value).
     apply 'entry' to alt-reci.cd-rec-altern in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.       

  /*** verifica se o n£mero de dias de utilizaá∆o do recurso Ç igual a zero. ***/  
  if alt-reci.dias-utiliz:sensitive = yes and
     integer(alt-reci.dias-utiliz:screen-value) = 0 then do: 
     run utp/ut-msgs.p (input 'show',
                        input 6576,
                        input return-value).
      apply 'entry' to alt-reci.dias-utiliz in frame {&frame-name}.
      return 'adm-error':U.
  end.

  /*** se for uma inclus∆o ***/ 
  if alt-reci.ordem:sensitive in frame {&frame-name} = yes then do:
  
     /*** Verifica se tipo recurso/recurso alternativo s∆o iguais tipo recurso/recurso. ***/
     if  rec-item.tp-recurso = input frame {&frame-name} alt-reci.tp-rec-altern
     and rec-item.cd-recurso = input frame {&frame-name} alt-reci.cd-rec-altern then do:
        {utp/ut-field.i mgind rec-item tp-recurso 1}
        assign c-label-aux = trim(return-value).
        {utp/ut-field.i mgind rec-item cd-recurso 1}
        assign c-label-aux = c-label-aux + '/' + trim(return-value).
        {utp/ut-table.i mgind alt-reci 1}
        run utp/ut-msgs.p (input 'show',
                           input 1737,
                           input alt-reci.tp-rec-altern:label + '/' + alt-reci.cd-rec-altern:label + '~~' +
                                 c-label-aux + '~~' +
                                 return-value).
        apply 'entry' to alt-reci.tp-rec-altern in frame {&frame-name}.
        return 'ADM-ERROR':U.
     end.  
  
     /*** Verifica se a classe to tipo de recurso alternativo Ç a mesma classe ***/
     /*** do tipo de recurso original ou do tipo "outro" com o mesmo modo de c†lculo.                                         ***/
     find tp-recur where tp-recur.tp-recurso   = rec-item.tp-recurso no-lock.
     find b-tp-recur where b-tp-recur.tp-recurso = input frame {&frame-name} alt-reci.tp-rec-altern no-lock.
     if tp-recur.ind-modo-calculo <> b-tp-recur.ind-modo-calculo or 
        (tp-recur.cl-recurso <> b-tp-recur.cl-recurso and
         tp-recur.cl-recurso <> 5 and
         b-tp-recur.cl-recurso <> 5) then do:
        run utp/ut-msgs.p (input 'show', 
                           input 7497,
                           input '').
        apply 'entry' to alt-reci.tp-rec-altern in frame {&frame-name}.
        return 'ADM-ERROR':U.
     end.
   
     /*** Validaá∆o Chave Duplicada ***/
     if can-find(b-alt-reci
                 where b-alt-reci.it-codigo     = rec-item.it-codigo
                 and   b-alt-reci.sequencia     = rec-item.sequencia
                 and   b-alt-reci.tp-recurso    = rec-item.tp-recurso
                 and   b-alt-reci.cd-recurso    = rec-item.cd-recurso
                 and   b-alt-reci.tp-rec-altern = input frame {&frame-name} alt-reci.tp-rec-altern
                 and   b-alt-reci.cd-rec-altern = input frame {&frame-name} alt-reci.cd-rec-altern) then do:
        {utp/ut-table.i mgind alt-reci 1}
        run utp/ut-msgs.p (input 'show',
                           input 1,
                           input return-value).
        apply 'entry' to alt-reci.tp-rec-altern in frame {&frame-name}.
        return  'ADM-ERROR':U.
     end.
  end.
  
  return ''.   
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
  {src/adm/template/snd-list.i "alt-reci"}

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


