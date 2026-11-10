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
{include/i-prgvrs.i V01IN013 2.00.00.008}  /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN013 MUT}
&ENDIF

/*----------------------------------------------------------------------

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
def new global shared var gr-rec-prod  as rowid no-undo.

def var rw-parent as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-lista-classe as char    no-undo.
def var i-classe       as integer no-undo.

def buffer b-alt-recp for alt-recp.
def buffer b-tp-recur for tp-recur.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES alt-recp
&Scoped-define FIRST-EXTERNAL-TABLE alt-recp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR alt-recp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS alt-recp.qt-produto alt-recp.dias-utiliz ~
alt-recp.qt-utilizada alt-recp.defasagem alt-recp.observacao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}qt-produto ~{&FP2}qt-produto ~{&FP3}~
 ~{&FP1}dias-utiliz ~{&FP2}dias-utiliz ~{&FP3}~
 ~{&FP1}qt-utilizada ~{&FP2}qt-utilizada ~{&FP3}~
 ~{&FP1}defasagem ~{&FP2}defasagem ~{&FP3}~
 ~{&FP1}observacao ~{&FP2}observacao ~{&FP3}
&Scoped-define ENABLED-TABLES alt-recp
&Scoped-define FIRST-ENABLED-TABLE alt-recp
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold rt-mold-2 
&Scoped-Define DISPLAYED-FIELDS produto.cd-produto produto.descricao ~
rec-prod.sequencia rec-prod.tp-recurso rec-prod.cd-recurso alt-recp.ordem ~
alt-recp.tp-rec-altern alt-recp.cd-rec-altern alt-recp.qt-produto ~
alt-recp.dias-utiliz alt-recp.qt-utilizada alt-recp.defasagem ~
alt-recp.observacao 
&Scoped-Define DISPLAYED-OBJECTS c-tp-recur-descricao-pai c-un-rec-pai ~
c-tp-recur-classe-pai c-tp-recur-descricao c-tp-recur-classe c-descricao ~
c-un-prod c-tp-recur-un 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS alt-recp.ordem alt-recp.tp-rec-altern ~
alt-recp.cd-rec-altern 

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
DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(35)" 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-recur-classe AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-recur-classe-pai AS CHARACTER FORMAT "X(30)":U 
     LABEL "Classe" 
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

DEFINE VARIABLE c-un-prod AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88.

DEFINE VARIABLE c-un-rec-pai AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

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
     produto.cd-produto AT ROW 1.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     produto.descricao AT ROW 1.17 COL 44.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 38 BY .88
     rec-prod.sequencia AT ROW 2.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     rec-prod.tp-recurso AT ROW 3.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     c-tp-recur-descricao-pai AT ROW 3.17 COL 36.57 COLON-ALIGNED NO-LABEL
     rec-prod.cd-recurso AT ROW 4.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-un-rec-pai AT ROW 4.17 COL 44.43 COLON-ALIGNED NO-LABEL
     c-tp-recur-classe-pai AT ROW 5.17 COL 27 COLON-ALIGNED
     alt-recp.ordem AT ROW 6.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     alt-recp.tp-rec-altern AT ROW 7.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     c-tp-recur-descricao AT ROW 7.17 COL 37 COLON-ALIGNED NO-LABEL
     c-tp-recur-classe AT ROW 8.17 COL 27 COLON-ALIGNED
     alt-recp.cd-rec-altern AT ROW 9.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     c-descricao AT ROW 9.17 COL 44.57 COLON-ALIGNED NO-LABEL
     alt-recp.qt-produto AT ROW 10.67 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-un-prod AT ROW 10.67 COL 35.57 COLON-ALIGNED NO-LABEL
     alt-recp.dias-utiliz AT ROW 10.67 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     alt-recp.qt-utilizada AT ROW 11.67 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     c-tp-recur-un AT ROW 11.67 COL 42.72 COLON-ALIGNED NO-LABEL
     alt-recp.defasagem AT ROW 11.67 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     alt-recp.observacao AT ROW 13.17 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40.29 BY .88
     rt-key AT ROW 1 COL 1.14
     rt-mold AT ROW 10.5 COL 1
     rt-mold-2 AT ROW 13 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.alt-recp
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
         HEIGHT             = 13.25
         WIDTH              = 88.72.
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
/* SETTINGS FOR FILL-IN c-un-prod IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-rec-pai IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN produto.cd-produto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN alt-recp.cd-rec-altern IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN rec-prod.cd-recurso IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN produto.descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN alt-recp.ordem IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN rec-prod.sequencia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN alt-recp.tp-rec-altern IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN rec-prod.tp-recurso IN FRAME f-main
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

&Scoped-define SELF-NAME alt-recp.cd-rec-altern
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alt-recp.cd-rec-altern V-table-Win
ON F5 OF alt-recp.cd-rec-altern IN FRAME f-main /* Recurso Alternativo */
DO:
  {utp/ut-field.i mgind tp-recur tp-recurso 1}
  find tp-recur where tp-recur.tp-recurso = 
       input frame {&frame-name} alt-recp.tp-rec-altern no-lock no-error.
  if avail tp-recur then do:
     assign l-implanta = yes.
     {include/zoomvar.i &prog-zoom=inzoom/z01in373.w
                        &campo=alt-recp.cd-rec-altern
                        &campozoom=cd-recurso
                        &parametros="run pi-seta-inicial in wh-pesquisa (input alt-recp.tp-rec-altern:screen-value)."}
  end.
  else run utp/ut-msgs.p (input "show",
                      input 47,
                      input return-value).
                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alt-recp.cd-rec-altern V-table-Win
ON LEAVE OF alt-recp.cd-rec-altern IN FRAME f-main /* Recurso Alternativo */
DO:
  if {ininc/i01in439.i 06 c-tp-recur-classe:screen-value in frame {&frame-name}} = 1 then do:
     find first mgind.recurso
          WHERE mgind.recurso.tp-recurso = input frame {&frame-name} alt-recp.tp-rec-altern 
          and   mgind.recurso.cd-recurso = input frame {&frame-name} alt-recp.cd-rec-altern no-lock no-error.
     find grup-maquina where grup-maquina.gm-codigo = recurso.gm-codigo no-lock no-error.
     assign c-descricao:screen-value in frame {&frame-name} = if avail grup-maquina then grup-maquina.descricao else "":U.
  end.
  else 
  if {ininc/i01in439.i 06 c-tp-recur-classe:screen-value in frame {&frame-name}} = 2 then do:
     find first mgind.recurso
          WHERE mgind.recurso.tp-recurso = input frame {&frame-name} alt-recp.tp-rec-altern
          and   mgind.recurso.cd-recurso = input frame {&frame-name} alt-recp.cd-rec-altern no-lock no-error.
     find item  where item.it-codigo = recurso.it-codigo no-lock no-error.
     assign c-descricao:screen-value in frame {&frame-name} = if avail item then item.desc-item else "":U.
  end.
  else 
  if {ininc/i01in439.i 06 c-tp-recur-classe:screen-value in frame {&frame-name}} = 3 then do:
     find first mgind.recurso
          WHERE mgind.recurso.tp-recurso = input frame {&frame-name} alt-recp.tp-rec-altern
          and   mgind.recurso.cd-recurso = input frame {&frame-name} alt-recp.cd-rec-altern no-lock no-error.
     find equipto where equipto.cd-equipto = recurso.cod-altern no-lock no-error.
     assign c-descricao:screen-value in frame {&frame-name} = if avail equipto then equipto.descricao else "":U.
  end. 
  else assign c-descricao:screen-value in frame {&frame-name} = "":U.
                      

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alt-recp.cd-rec-altern V-table-Win
ON MOUSE-SELECT-DBLCLICK OF alt-recp.cd-rec-altern IN FRAME f-main /* Recurso Alternativo */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME alt-recp.tp-rec-altern
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alt-recp.tp-rec-altern V-table-Win
ON F5 OF alt-recp.tp-rec-altern IN FRAME f-main /* Tp Rec Alternativo */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in439.w
                     &campo=alt-recp.tp-rec-altern
                     &campozoom=tp-recurso
                     &campo2=c-tp-recur-descricao
                     &campozoom2=descricao
                     &campo3=c-tp-recur-un
                     &campozoom3=cod-unid-capac}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alt-recp.tp-rec-altern V-table-Win
ON LEAVE OF alt-recp.tp-rec-altern IN FRAME f-main /* Tp Rec Alternativo */
DO:
   {include/leave.i &tabela=tp-recur
                   &atributo-ref=descricao
                   &variavel-ref=c-tp-recur-descricao
                   &atributo-ref2=cod-unid-capac
                   &variavel-ref2=c-tp-recur-un
                   &where="tp-recur.tp-recurso = input frame {&frame-name} alt-recp.tp-rec-altern"}
  assign c-tp-recur-classe:screen-value in frame {&frame-name} = 
  if avail tp-recur then entry(tp-recur.cl-recurso,c-lista-classe) else "":U.
  
/********************************************
  if avail tp-recur then do:
     if tp-recur.cl-recurso <> i-classe or tp-recur.cod-unid-capac <> c-un-rec-pai then do:
        assign c-tp-recur-descricao:screen-value = "":U
               c-tp-recur-classe:screen-value    = "":U.
        {utp/ut-table.i mgind alt-recp 1}
        run utp/ut-msgs.p (input 'show', 
                           input 6197,
                           input return-value).
        apply "entry" to alt-recp.tp-rec-altern in frame {&frame-name}.
        return no-apply.
     end.
  end.   
***********************************************/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL alt-recp.tp-rec-altern V-table-Win
ON MOUSE-SELECT-DBLCLICK OF alt-recp.tp-rec-altern IN FRAME f-main /* Tp Rec Alternativo */
DO:
  apply 'f5' to self.
  
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
  
  if alt-recp.tp-rec-altern:load-mouse-pointer('image/lupa.cur') in frame {&frame-name} then.
  if alt-recp.cd-rec-altern:load-mouse-pointer('image/lupa.cur') in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "alt-recp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "alt-recp"}

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
  find rec-prod where rowid(rec-prod) = v-row-parent no-lock.
  find last b-alt-recp 
       where b-alt-recp.cd-produto  = rec-prod.cd-produto 
       and   b-alt-recp.sequencia   = rec-prod.sequencia
       and   b-alt-recp.tp-recurso  = rec-prod.tp-recurso
       and   b-alt-recp.cd-recurso  = rec-prod.cd-recurso
       no-lock no-error.
  if avail b-alt-recp then
     display (b-alt-recp.ordem + param-pm.num-var-recurso) @ alt-recp.ordem with frame {&frame-name}.
  else 
     display param-pm.num-var-recurso @ alt-recp.ordem with frame {&frame-name}.
  assign alt-recp.qt-produto:screen-value in frame {&frame-name}   = string(rec-prod.qt-produto)
         alt-recp.qt-utilizada:screen-value in frame {&frame-name} = string(rec-prod.qt-utilizada)
         alt-recp.dias-utiliz:screen-value in frame {&frame-name}  = string(rec-prod.dias-utiliz)
         alt-recp.defasagem:screen-value in frame {&frame-name}    = string(rec-prod.defasagem).
         
 display c-un-prod 
         c-tp-recur-descricao-pai 
         c-un-rec-pai 
         c-tp-recur-classe-pai with frame {&frame-name}.   
  
 
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
      
  find rec-prod where rowid(rec-prod) = v-row-parent no-lock.

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
  
  if avail rec-prod then
     assign alt-recp.cd-produto  = rec-prod.cd-produto
            alt-recp.sequencia   = rec-prod.sequencia
            alt-recp.tp-recurso  = rec-prod.tp-recurso
            alt-recp.cd-recurso  = rec-prod.cd-recurso.

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
  if avail alt-recp then do:
     find tp-recur where tp-recur.tp-recurso = alt-recp.tp-rec-altern no-lock no-error.
     find produto where produto.cd-produto = alt-recp.cd-produto no-lock no-error.
     assign c-tp-recur-descricao = if avail tp-recur then tp-recur.descricao else "":U
            c-tp-recur-classe    = if avail tp-recur then 
                                   entry(tp-recur.cl-recurso,c-lista-classe) else "":U
            c-tp-recur-un        = if avail tp-recur then tp-recur.cod-unid-capac else "":U
            c-un-prod            = if avail produto then produto.un else "":U.
  end.
  
       
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  find recurso 
       where recurso.tp-recurso = alt-recp.tp-rec-altern 
       and   recurso.cd-recurso = alt-recp.cd-rec-altern no-lock no-error.
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
  
  find rec-prod where rowid(rec-prod)     = v-row-parent        no-lock.
  find produto  where produto.cd-produto  = rec-prod.cd-produto no-lock no-error.
  find tp-recur where tp-recur.tp-recurso = rec-prod.tp-recurso no-lock no-error.
  
  assign rw-parent = v-row-parent.
  
  assign c-lista-classe = {ininc/i01in439.i 03}.
  
  assign i-classe                 = tp-recur.cl-recurso
         c-un-rec-pai             = tp-recur.cod-unid-capac
         c-un-prod                = produto.un
         c-tp-recur-classe-pai    = entry(tp-recur.cl-recurso,c-lista-classe)
         c-tp-recur-descricao-pai = tp-recur.descricao.
  
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

  /*** Verifica se o recurso informado Ç v†lido ***/
  find recurso 
       where recurso.tp-recurso = input frame {&frame-name} alt-recp.tp-rec-altern
       and   recurso.cd-recurso = input frame {&frame-name} alt-recp.cd-rec-altern
       no-lock no-error.
  if not avail recurso then do:
     {utp/ut-table.i mgind recurso 1}
     run utp/ut-msgs.p (input 'show', 
                        input 56,
                        input return-value).
     apply 'entry' to alt-recp.cd-rec-altern in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.   
  
  /*** Verifica se o n£mero de dias de utilizaá∆o do recurso alternativo Ç valido ***/
  if alt-recp.dias-utiliz:sensitive             = yes and
     integer(alt-recp.dias-utiliz:screen-value) = 0 then do: 
     run utp/ut-msgs.p (input 'show',
                        input 6576,
                        input return-value).
     apply 'entry' to alt-recp.dias-utiliz in frame {&frame-name}.
     return 'adm-error':U.
  end.

  /*** Se for uma inclus∆o ***/
  if alt-recp.ordem:sensitive in frame {&frame-name} = yes then do:
  
     /*** Verifica se tipo-recurso-alternativo/recurso-alternativo Ç igual ***/
     /*** ao tipo-recurso/recurso.                                         ***/
     if  rec-prod.tp-recurso = input frame {&frame-name} alt-recp.tp-rec-altern
     and rec-prod.cd-recurso = input frame {&frame-name} alt-recp.cd-rec-altern then do:
        {utp/ut-field.i mgind rec-prod cd-recurso 1}
        assign c-label-aux = trim(return-value).
        {utp/ut-table.i mgind alt-recp 1}
        run utp/ut-msgs.p (input 'show',
                           input 1737,
                           input trim(alt-recp.cd-rec-altern:label) + '~~' +
                                 c-label-aux + '~~' +
                                 trim(return-value)).
        apply 'entry' to alt-recp.tp-rec-altern in frame {&frame-name}.
        return 'ADM-ERROR':U.
     end.  
     
     /*** Verifica se a classe to tipo de recurso alternativo Ç a mesma classe ***/
     /*** do tipo de recurso original.                                         ***/
     find tp-recur where tp-recur.tp-recurso = rec-prod.tp-recurso no-lock.
     find b-tp-recur where b-tp-recur.tp-recurso = input frame {&frame-name} alt-recp.tp-rec-altern no-lock.
     if tp-recur.ind-modo-calculo <> b-tp-recur.ind-modo-calculo or 
        (tp-recur.cl-recurso <> b-tp-recur.cl-recurso and
         tp-recur.cl-recurso <> 5 and
         b-tp-recur.cl-recurso <> 5) then do:
         run utp/ut-msgs.p (input 'show', 
                           input 7497,
                           input return-value).
        apply 'entry' to alt-recp.tp-rec-altern in frame {&frame-name}.
        return 'ADM-ERROR':U.
     end.
  
     /*** Validaá∆o Chave Duplicada ***/
     find first b-alt-recp
          where b-alt-recp.tp-rec-altern = input frame {&frame-name} alt-recp.tp-rec-altern 
          and   b-alt-recp.cd-rec-altern = input frame {&frame-name} alt-recp.cd-rec-altern 
          and   b-alt-recp.cd-produto    = rec-prod.cd-produto 
          and   b-alt-recp.tp-recurso    = rec-prod.tp-recurso
          and   b-alt-recp.cd-recurso    = rec-prod.cd-recurso 
          and   b-alt-recp.sequencia     = rec-prod.sequencia no-lock no-error.
     if avail b-alt-recp then do: 
        {utp/ut-table.i mgind alt-recp 1}
         run utp/ut-msgs.p (input 'show',
                            input 1,
                            input return-value).
        apply 'entry' to alt-recp.tp-rec-altern in frame {&frame-name}.
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
  {src/adm/template/snd-list.i "alt-recp"}

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


