&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V01IN081 2.00.00.005 } /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN081 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var i-x         as integer no-undo.
def var i-cont      as integer no-undo.
def var i-moeda     as integer no-undo.
def var de-perc     as decimal no-undo.
def var de-tot-perc as decimal no-undo.
def var c-mo        as character extent 5 no-undo.
def var i-mo-aux    as integer   extent 5 no-undo.
def var i-mo-aux2   as integer   extent 5 no-undo.
def var da-reaj-aux as date      extent 5 no-undo.
def var de-perc-aux as decimal   extent 5 no-undo.
def var da-cotacao  as date .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 rt-mold fi-dt-preco-base ~
fi-mo-codigo1 fi-data-indice1 fi-perc-reaj1 fi-mo-codigo2 fi-data-indice2 ~
fi-perc-reaj2 fi-mo-codigo3 fi-data-indice3 fi-perc-reaj3 fi-mo-codigo4 ~
fi-data-indice4 fi-perc-reaj4 fi-mo-codigo5 fi-data-indice5 fi-perc-reaj5 
&Scoped-Define DISPLAYED-OBJECTS fi-dt-preco-base fi-mo-codigo1 fi-moeda1 ~
fi-data-indice1 fi-perc-reaj1 fi-mo-codigo2 fi-moeda2 fi-data-indice2 ~
fi-perc-reaj2 fi-mo-codigo3 fi-moeda3 fi-data-indice3 fi-perc-reaj3 ~
fi-mo-codigo4 fi-moeda4 fi-data-indice4 fi-perc-reaj4 fi-mo-codigo5 ~
fi-moeda5 fi-data-indice5 fi-perc-reaj5 

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
DEFINE VARIABLE fi-data-indice1 AS DATE FORMAT "99/99/9999" 
     LABEL "1":R4 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE fi-data-indice2 AS DATE FORMAT "99/99/9999" 
     LABEL "2":R4 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE fi-data-indice3 AS DATE FORMAT "99/99/9999" 
     LABEL "3":R4 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE fi-data-indice4 AS DATE FORMAT "99/99/9999" 
     LABEL "4":R4 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE fi-data-indice5 AS DATE FORMAT "99/99/9999" 
     LABEL "5":R4 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE fi-data-reaj AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .63 NO-UNDO.

DEFINE VARIABLE fi-dt-preco-base AS DATE FORMAT "99/99/9999" 
     LABEL "Data Pre‡o Base":R18 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE fi-mo-codigo1 AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "1":R7 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88.

DEFINE VARIABLE fi-mo-codigo2 AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "2":R7 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88.

DEFINE VARIABLE fi-mo-codigo3 AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "3":R7 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88.

DEFINE VARIABLE fi-mo-codigo4 AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "4":R7 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88.

DEFINE VARIABLE fi-mo-codigo5 AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "5":R7 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88.

DEFINE VARIABLE fi-moeda AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .63 NO-UNDO.

DEFINE VARIABLE fi-moeda1 AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 21.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-moeda2 AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 21.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-moeda3 AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 21.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-moeda4 AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 21.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-moeda5 AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 21.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-perc-reaj AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .63 NO-UNDO.

DEFINE VARIABLE fi-perc-reaj1 AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "1":R4 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88.

DEFINE VARIABLE fi-perc-reaj2 AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "2":R4 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88.

DEFINE VARIABLE fi-perc-reaj3 AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "3":R4 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88.

DEFINE VARIABLE fi-perc-reaj4 AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "4":R4 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88.

DEFINE VARIABLE fi-perc-reaj5 AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "5":R4 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 6.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 23.43 BY 6.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 18.43 BY 5.83.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 78 BY 1.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-dt-preco-base AT ROW 1.38 COL 40.57 COLON-ALIGNED
     fi-mo-codigo1 AT ROW 3.92 COL 5.29 COLON-ALIGNED
     fi-moeda1 AT ROW 3.92 COL 9.57 COLON-ALIGNED NO-LABEL
     fi-data-indice1 AT ROW 3.83 COL 40.29 COLON-ALIGNED
     fi-perc-reaj1 AT ROW 4 COL 64 COLON-ALIGNED
     fi-mo-codigo2 AT ROW 4.92 COL 5.29 COLON-ALIGNED
     fi-moeda2 AT ROW 4.92 COL 9.57 COLON-ALIGNED NO-LABEL
     fi-data-indice2 AT ROW 4.83 COL 40.29 COLON-ALIGNED
     fi-perc-reaj2 AT ROW 5 COL 64 COLON-ALIGNED
     fi-mo-codigo3 AT ROW 5.92 COL 5.29 COLON-ALIGNED
     fi-moeda3 AT ROW 5.92 COL 9.57 COLON-ALIGNED NO-LABEL
     fi-data-indice3 AT ROW 5.83 COL 40.29 COLON-ALIGNED
     fi-perc-reaj3 AT ROW 6 COL 64 COLON-ALIGNED
     fi-mo-codigo4 AT ROW 6.92 COL 5.29 COLON-ALIGNED
     fi-moeda4 AT ROW 6.92 COL 9.57 COLON-ALIGNED NO-LABEL
     fi-data-indice4 AT ROW 6.83 COL 40.29 COLON-ALIGNED
     fi-perc-reaj4 AT ROW 7 COL 64 COLON-ALIGNED
     fi-mo-codigo5 AT ROW 7.92 COL 5.29 COLON-ALIGNED
     fi-moeda5 AT ROW 7.92 COL 9.57 COLON-ALIGNED NO-LABEL
     fi-data-indice5 AT ROW 7.83 COL 40.29 COLON-ALIGNED
     fi-perc-reaj5 AT ROW 8 COL 64 COLON-ALIGNED
     fi-moeda AT ROW 3 COL 10 COLON-ALIGNED NO-LABEL
     fi-data-reaj AT ROW 3 COL 40 COLON-ALIGNED NO-LABEL
     fi-perc-reaj AT ROW 3 COL 62 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 3.25 COL 1
     RECT-2 AT ROW 3.25 COL 36
     RECT-3 AT ROW 3.25 COL 61.14
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 8.25
         WIDTH              = 78.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi-data-reaj IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-moeda IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-moeda1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-moeda2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-moeda3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-moeda4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-moeda5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-perc-reaj IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR RECTANGLE RECT-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-3 IN FRAME f-main
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

&Scoped-define SELF-NAME fi-mo-codigo1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo1 V-table-Win
ON F5 OF fi-mo-codigo1 IN FRAME f-main /* 1 */
DO:
   {include/zoomvar.i &prog-zoom=adzoom/z01ad178.w
                        &campo=fi-mo-codigo1
                        &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo1 V-table-Win
ON LEAVE OF fi-mo-codigo1 IN FRAME f-main /* 1 */
DO:
    {include/leave.i &tabela=moeda
                     &atributo-ref=descricao
                     &variavel-ref=fi-moeda1
                     &where="moeda.mo-codigo = input frame {&frame-name} fi-mo-codigo1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo1 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-mo-codigo1 IN FRAME f-main /* 1 */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-mo-codigo2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo2 V-table-Win
ON F5 OF fi-mo-codigo2 IN FRAME f-main /* 2 */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad178.w
                        &campo=fi-mo-codigo2
                        &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo2 V-table-Win
ON LEAVE OF fi-mo-codigo2 IN FRAME f-main /* 2 */
DO:
    {include/leave.i &tabela=moeda
                     &atributo-ref=descricao
                     &variavel-ref=fi-moeda2
                     &where="moeda.mo-codigo = input frame {&frame-name} fi-mo-codigo2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo2 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-mo-codigo2 IN FRAME f-main /* 2 */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-mo-codigo3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo3 V-table-Win
ON F5 OF fi-mo-codigo3 IN FRAME f-main /* 3 */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad178.w
                        &campo=fi-mo-codigo3
                        &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo3 V-table-Win
ON LEAVE OF fi-mo-codigo3 IN FRAME f-main /* 3 */
DO:
    {include/leave.i &tabela=moeda
                     &atributo-ref=descricao
                     &variavel-ref=fi-moeda3
                     &where="moeda.mo-codigo = input frame {&frame-name} fi-mo-codigo3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo3 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-mo-codigo3 IN FRAME f-main /* 3 */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-mo-codigo4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo4 V-table-Win
ON F5 OF fi-mo-codigo4 IN FRAME f-main /* 4 */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad178.w
                        &campo=fi-mo-codigo4
                        &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo4 V-table-Win
ON LEAVE OF fi-mo-codigo4 IN FRAME f-main /* 4 */
DO:
    {include/leave.i &tabela=moeda
                     &atributo-ref=descricao
                     &variavel-ref=fi-moeda4
                     &where="moeda.mo-codigo = input frame {&frame-name} fi-mo-codigo4"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo4 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-mo-codigo4 IN FRAME f-main /* 4 */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-mo-codigo5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo5 V-table-Win
ON F5 OF fi-mo-codigo5 IN FRAME f-main /* 5 */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad178.w
                        &campo=fi-mo-codigo5
                        &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo5 V-table-Win
ON LEAVE OF fi-mo-codigo5 IN FRAME f-main /* 5 */
DO:
    {include/leave.i &tabela=moeda
                     &atributo-ref=descricao
                     &variavel-ref=fi-moeda5
                     &where="moeda.mo-codigo = input frame {&frame-name} fi-mo-codigo5"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo5 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-mo-codigo5 IN FRAME f-main /* 5 */
DO:
    apply "F5" to self.
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

  
  do  with frame {&frame-name}:
      if fi-mo-codigo1:load-mouse-pointer("image/lupa.cur") then .
      if fi-mo-codigo2:load-mouse-pointer("image/lupa.cur") then .
      if fi-mo-codigo3:load-mouse-pointer("image/lupa.cur") then .
      if fi-mo-codigo4:load-mouse-pointer("image/lupa.cur") then .
      if fi-mo-codigo5:load-mouse-pointer("image/lupa.cur") then .
  end.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  if adm-new-record = yes then
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
  
  {utp/ut-liter.i Moeda * C}
  assign fi-moeda = trim(return-value).
  {utp/ut-liter.i Data_Reajuste * C}
  assign fi-data-reaj = trim(return-value).
  {utp/ut-liter.i %_Reajuste * C}
  assign fi-perc-reaj = trim(return-value).
  
  disp fi-moeda
       fi-data-reaj
       fi-perc-reaj
       with frame {&frame-name}.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     define input parameter v-row-parent-externo as rowid no-undo.
     assign v-row-parent = v-row-parent-externo.
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cancela V-table-Win 
PROCEDURE pi-cancela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-conclui V-table-Win 
PROCEDURE pi-conclui :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter l-ok as logical.

assign l-ok = yes.
assign i-mo-aux[1]    = input frame {&frame-name} fi-mo-codigo1
       i-mo-aux[2]    = input frame {&frame-name} fi-mo-codigo2
       i-mo-aux[3]    = input frame {&frame-name} fi-mo-codigo3
       i-mo-aux[4]    = input frame {&frame-name} fi-mo-codigo4
       i-mo-aux[5]    = input frame {&frame-name} fi-mo-codigo5
       de-perc-aux[1] = input frame {&frame-name} fi-perc-reaj1
       de-perc-aux[2] = input frame {&frame-name} fi-perc-reaj2
       de-perc-aux[3] = input frame {&frame-name} fi-perc-reaj3
       de-perc-aux[4] = input frame {&frame-name} fi-perc-reaj4
       de-perc-aux[5] = input frame {&frame-name} fi-perc-reaj5
       da-reaj-aux[1] = input frame {&frame-name} fi-data-indice1
       da-reaj-aux[2] = input frame {&frame-name} fi-data-indice2
       da-reaj-aux[3] = input frame {&frame-name} fi-data-indice3
       da-reaj-aux[4] = input frame {&frame-name} fi-data-indice4
       da-reaj-aux[5] = input frame {&frame-name} fi-data-indice5.
        
        
assign de-tot-perc = 0.
  
do  i-x = 1 to 5:
    assign i-moeda = i-mo-aux[i-x]
           de-perc = de-perc-aux[i-x]
           de-tot-perc = de-tot-perc + de-perc.
    if  i-moeda <> 0 then do:
        find moeda where moeda.mo-codigo = i-moeda no-lock no-error.
        if  not avail moeda then do:
            {utp/ut-table.i mguni moeda 1}
            run utp/ut-msgs.p (input "show":U, input 2, input return-value).
            apply "entry" to fi-dt-preco-base in frame {&frame-name}.
            assign l-ok = no.
            return 'ADM-ERROR':U.
        end.
        if  de-perc = 0 then do:
            run utp/ut-msgs.p (input "show":U, input 1548, input "").
            apply "entry" to fi-dt-preco-base in frame {&frame-name}.
            assign l-ok = no.
            return 'ADM-ERROR':U.
        end.
    end.
    else do:
        if  de-perc <> 0 then do:
            run utp/ut-msgs.p (input "show":U, input 3617, input "").
            apply "entry" to fi-dt-preco-base in frame {&frame-name}.
            assign l-ok = no.
            return 'ADM-ERROR':U.
        end.
    end.
end.
if  de-tot-perc > 100  then do:
    run utp/ut-msgs.p (input "show":U, input 2208, input "").
    apply "entry" to fi-dt-preco-base in frame {&frame-name}.
    assign l-ok = no.
    return 'ADM-ERROR':U.
end.
if  de-tot-perc < 100  then do:
    run utp/ut-msgs.p (input "show":U, input 16928, input "").
    apply "entry" to fi-dt-preco-base in frame {&frame-name}.
    assign l-ok = no.
    return 'ADM-ERROR':U.
end.
if  cotacao-item.numero-ordem = ? then
    find cota-item-reaj 
        where cota-item-reaj.it-codigo    = cotacao-item.it-codigo
          and cota-item-reaj.numero-ordem = 0
          and cota-item-reaj.cod-emitente = cotacao-item.cod-emitente
        EXCLUSIVE-LOCK no-error.
else
    find cota-item-reaj 
            where cota-item-reaj.it-codigo    = cotacao-item.it-codigo
              and cota-item-reaj.numero-ordem = cotacao-item.numero-ordem
              and cota-item-reaj.cod-emitente = cotacao-item.cod-emitente
            EXCLUSIVE-LOCK no-error.
if  not avail cota-item-reaj then do:
    create cota-item-reaj.
    assign cota-item-reaj.it-codigo = cotacao-item.it-codigo
           cota-item-reaj.numero-ordem =
                          if cotacao-item.numero-ordem = ? then 0
                          else cotacao-item.numero-ordem
           cota-item-reaj.cod-emitente = cotacao-item.cod-emitente
           cota-item-reaj.data-cotacao = input frame {&frame-name} fi-dt-preco-base.
end.
assign i-cont    = 0
       i-mo-aux2 = 0.
assign i-cont = 0
       cota-item-reaj.mo-codigo = 0
       cota-item-reaj.data-indice = ?
       cota-item-reaj.perc-reaj = 0
       cota-item-reaj.dt-preco-base = input frame {&frame-name} fi-dt-preco-base.
do  i-x = 1 to 5:
    if  i-mo-aux[i-x] <> 0 then do:
        assign i-cont              = i-cont + 1
               cota-item-reaj.mo-codigo[i-cont] = i-mo-aux[i-x]
               cota-item-reaj.data-indice[i-cont] = da-reaj-aux[i-x]
               cota-item-reaj.perc-reaj[i-cont] = de-perc-aux[i-x].
    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campos V-table-Win 
PROCEDURE pi-inicializa-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter r-cotacao as rowid.
find cotacao-item where rowid(cotacao-item) = r-cotacao no-lock no-error.
if  avail cotacao-item then do:
        if cotacao-item.numero-ordem = ? then
        find cota-item-reaj 
            where cota-item-reaj.it-codigo    = cotacao-item.it-codigo
              and cota-item-reaj.numero-ordem = 0
              and cota-item-reaj.cod-emitente = cotacao-item.cod-emitente
            NO-LOCK no-error.
    else
        find cota-item-reaj 
            where cota-item-reaj.it-codigo    = cotacao-item.it-codigo
              and cota-item-reaj.numero-ordem = cotacao-item.numero-ordem
              and cota-item-reaj.cod-emitente = cotacao-item.cod-emitente
            NO-LOCK no-error.
    
    if  avail cota-item-reaj then do:
          assign fi-dt-preco-base = cota-item-reaj.dt-preco-base
                 fi-mo-codigo1    = cota-item-reaj.mo-codigo[1]
                 fi-mo-codigo2    = cota-item-reaj.mo-codigo[2]
                 fi-mo-codigo3    = cota-item-reaj.mo-codigo[3]
                 fi-mo-codigo4    = cota-item-reaj.mo-codigo[4]
                 fi-mo-codigo5    = cota-item-reaj.mo-codigo[5]
                 fi-data-indice1  = cota-item-reaj.data-indice[1]
                 fi-data-indice2  = cota-item-reaj.data-indice[2]
                 fi-data-indice3  = cota-item-reaj.data-indice[3]
                 fi-data-indice4  = cota-item-reaj.data-indice[4]
                 fi-data-indice5  = cota-item-reaj.data-indice[5]
                 fi-perc-reaj1    = cota-item-reaj.perc-reaj[1]
                 fi-perc-reaj2    = cota-item-reaj.perc-reaj[2]
                 fi-perc-reaj3    = cota-item-reaj.perc-reaj[3]
                 fi-perc-reaj4    = cota-item-reaj.perc-reaj[4]
                 fi-perc-reaj5    = cota-item-reaj.perc-reaj[5].
                 
          do  i-x = 1 to 5:
              if  cota-item-reaj.mo-codigo[i-x] <> 0 then do:
                  find moeda where moeda.mo-codigo = cota-item-reaj.mo-codigo[i-x]
                       no-lock no-error.
                  assign c-mo[i-x] = if avail moeda then moeda.descricao else "".
              end.
          end. 
          assign fi-moeda1 = c-mo[1]
                 fi-moeda2 = c-mo[2]
                 fi-moeda3 = c-mo[3]
                 fi-moeda4 = c-mo[4]
                 fi-moeda5 = c-mo[5].
         
         disp fi-dt-preco-base 
              fi-mo-codigo1    
              fi-mo-codigo2    
              fi-mo-codigo3    
              fi-mo-codigo4    
              fi-mo-codigo5    
              fi-moeda1
              fi-moeda2
              fi-moeda3
              fi-moeda4
              fi-moeda5
              fi-data-indice1  
              fi-data-indice2  
              fi-data-indice3  
              fi-data-indice4  
              fi-data-indice5  
              fi-perc-reaj1    
              fi-perc-reaj2    
              fi-perc-reaj3    
              fi-perc-reaj4 
              fi-perc-reaj5
              with frame {&frame-name}.
    end.
   display cotacao-item.data-cotacao @ fi-dt-preco-base with frame {&frame-name}.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
   
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
 



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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
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
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


