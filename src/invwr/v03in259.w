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
{include/i-prgvrs.i V03IN259 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN259 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE BUFFER b-oper-exam FOR oper-exam.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold c-item-origem c-roteiro-origem ~
i-operacao-origem i-exame-inicial i-exame-final c-item-destino ~
c-roteiro-destino i-operacao-destino 
&Scoped-Define DISPLAYED-OBJECTS c-item-origem c-des-item-orig ~
c-roteiro-origem c-des-roteiro-orig i-operacao-origem c-des-operacao-orig ~
i-exame-inicial c-des-exame-inicial c-des-exame-final i-exame-final ~
c-item-destino c-des-item-dest c-roteiro-destino c-des-roteiro-dest ~
i-operacao-destino c-des-operacao-dest 

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
DEFINE VARIABLE c-des-exame-final AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-exame-inicial AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 29.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-item-dest AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-item-orig AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-operacao-dest AS CHARACTER FORMAT "X(34)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-operacao-orig AS CHARACTER FORMAT "X(34)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-roteiro-dest AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-roteiro-orig AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-destino AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-origem AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-roteiro-destino AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-roteiro-origem AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE i-exame-final AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-exame-inicial AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-operacao-destino AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-operacao-origem AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 9.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-item-origem AT ROW 1.25 COL 22 COLON-ALIGNED
     c-des-item-orig AT ROW 1.25 COL 39 COLON-ALIGNED NO-LABEL
     c-roteiro-origem AT ROW 2.25 COL 22 COLON-ALIGNED
     c-des-roteiro-orig AT ROW 2.25 COL 39 COLON-ALIGNED NO-LABEL
     i-operacao-origem AT ROW 3.25 COL 22 COLON-ALIGNED
     c-des-operacao-orig AT ROW 3.25 COL 29 COLON-ALIGNED NO-LABEL
     i-exame-inicial AT ROW 4.75 COL 22 COLON-ALIGNED
     c-des-exame-inicial AT ROW 4.75 COL 30.43 COLON-ALIGNED NO-LABEL
     c-des-exame-final AT ROW 5.71 COL 30.43 COLON-ALIGNED NO-LABEL
     i-exame-final AT ROW 5.75 COL 22 COLON-ALIGNED
     c-item-destino AT ROW 7.25 COL 22 COLON-ALIGNED
     c-des-item-dest AT ROW 7.25 COL 39 COLON-ALIGNED NO-LABEL
     c-roteiro-destino AT ROW 8.25 COL 22 COLON-ALIGNED
     c-des-roteiro-dest AT ROW 8.25 COL 39 COLON-ALIGNED NO-LABEL
     i-operacao-destino AT ROW 9.25 COL 22 COLON-ALIGNED
     c-des-operacao-dest AT ROW 9.25 COL 29 COLON-ALIGNED NO-LABEL
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
         HEIGHT             = 9.46
         WIDTH              = 88.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-des-exame-final IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-exame-inicial IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-item-dest IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-item-orig IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-operacao-dest IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-operacao-orig IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-roteiro-dest IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-roteiro-orig IN FRAME f-main
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

&Scoped-define SELF-NAME c-item-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-destino V-table-Win
ON F5 OF c-item-destino IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom\z02in172.w
                     &campo=c-item-destino
                     &campozoom=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-destino V-table-Win
ON LEAVE OF c-item-destino IN FRAME f-main
DO:
   find item no-lock
      where item.it-codigo = input frame {&FRAME-NAME} c-item-destino no-error.
   if avail item then do:
      assign c-des-item-dest:screen-value in frame {&FRAME-NAME} = item.desc-item.
   end.
   else do:
      assign c-des-item-dest:screen-value in frame {&FRAME-NAME} = "".
   end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-destino V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-item-destino IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-item-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-origem V-table-Win
ON F5 OF c-item-origem IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom\z03in259.w
                     &campo=c-item-origem
                     &campozoom=it-codigo
                     &campo2=c-roteiro-origem
                     &campozoom2=cod-roteiro
                     &campo3=i-operacao-origem
                     &campozoom3=op-codigo
                     &campo4=i-exame-inicial
                     &campozoom4=cod-exame}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-origem V-table-Win
ON LEAVE OF c-item-origem IN FRAME f-main
DO:
   find item no-lock
      where item.it-codigo = input frame {&FRAME-NAME} c-item-origem no-error.
   if avail item then do:
      assign c-des-item-orig:screen-value in frame {&FRAME-NAME} = item.desc-item.
   end.
   else do:
      assign c-des-item-orig:screen-value in frame {&FRAME-NAME} = "".
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-origem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-item-origem IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-roteiro-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-roteiro-destino V-table-Win
ON F5 OF c-roteiro-destino IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in400.w
                     &campo=c-roteiro-destino
                     &campozoom=cod-roteiro
                     &parametros="run pi-seta-inicial in wh-pesquisa (input c-item-destino:screen-value in frame {&frame-name})."}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-roteiro-destino V-table-Win
ON LEAVE OF c-roteiro-destino IN FRAME f-main
DO:
  {include/leave.i &tabela=rot-fabric
                   &atributo-ref=descricao
                   &variavel-ref=c-des-roteiro-dest
                   &where="rot-fabric.cod-roteiro = input frame {&FRAME-NAME} c-roteiro-destino"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-roteiro-destino V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-roteiro-destino IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-roteiro-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-roteiro-origem V-table-Win
ON F5 OF c-roteiro-origem IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in400.w
                     &campo=c-roteiro-origem
                     &campozoom=cod-roteiro
                     &parametros="run pi-seta-inicial in wh-pesquisa (input c-item-origem:screen-value in frame {&FRAME-NAME})."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-roteiro-origem V-table-Win
ON LEAVE OF c-roteiro-origem IN FRAME f-main
DO:
  {include/leave.i &tabela=rot-fabric
                   &atributo-ref=descricao
                   &variavel-ref=c-des-roteiro-orig
                   &where="rot-fabric.cod-roteiro = input frame {&FRAME-NAME} c-roteiro-origem"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-roteiro-origem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-roteiro-origem IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-exame-final
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-exame-final V-table-Win
ON F5 OF i-exame-final IN FRAME f-main
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom="inzoom/z01in259.w"
                      &campo=i-exame-final
                      &campozoom=cod-exame
                      &parametros="run pi-seta-inicial in wh-pesquisa (input c-item-origem:screen-value, input c-roteiro-origem:screen-value, input int(i-operacao-origem:screen-value))."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-exame-final V-table-Win
ON LEAVE OF i-exame-final IN FRAME f-main
DO:
  {include/leave.i &tabela=exame
                   &atributo-ref=descricao
                   &variavel-ref=c-des-exame-final
                   &where="exame.cod-exame = input frame {&FRAME-NAME} i-exame-final and exame.cdn-sit-vers = 2"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-exame-final V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-exame-final IN FRAME f-main
DO:
  apply 'F5' to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-exame-inicial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-exame-inicial V-table-Win
ON F5 OF i-exame-inicial IN FRAME f-main
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom="inzoom/z01in259.w"
                      &campo=i-exame-inicial
                      &campozoom=cod-exame
                      &parametros="run pi-seta-inicial in wh-pesquisa (input c-item-origem:screen-value, input c-roteiro-origem:screen-value, input int(i-operacao-origem:screen-value))."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-exame-inicial V-table-Win
ON LEAVE OF i-exame-inicial IN FRAME f-main
DO:
  {include/leave.i &tabela=exame
                   &atributo-ref=descricao
                   &variavel-ref=c-des-exame-inicial
                   &where="exame.cod-exame = input frame {&FRAME-NAME} i-exame-inicial and exame.cdn-sit-vers = 2"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-exame-inicial V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-exame-inicial IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-operacao-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-operacao-destino V-table-Win
ON F5 OF i-operacao-destino IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in263.w
                     &campo=i-operacao-destino
                     &campozoom=op-codigo}
                     /*&parametros="run pi-seta-inicial in wh-pesquisa (input c-roteiro-destino:screen-value in frame {&FRAME-NAME})."}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-operacao-destino V-table-Win
ON LEAVE OF i-operacao-destino IN FRAME f-main
DO:
   find first operacao no-lock
      where operacao.it-codigo   = input frame {&FRAME-NAME} c-item-destino
      and   operacao.cod-roteiro = input frame {&FRAME-NAME} c-roteiro-destino
      and   operacao.op-codigo   = input frame {&FRAME-NAME} i-operacao-destino no-error.
   if avail operacao then do:
      assign c-des-operacao-dest:screen-value in frame {&FRAME-NAME} = operacao.descricao.
   end.
   else do:
      assign c-des-operacao-dest:screen-value in frame {&FRAME-NAME} = "".
   end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-operacao-destino V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-operacao-destino IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-operacao-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-operacao-origem V-table-Win
ON F5 OF i-operacao-origem IN FRAME f-main
DO:
  assign l-implanta = yes.
  /*if c-roteiro-origem:screen-value in frame {&FRAME-NAME} <> "" then do:*/
     {include/zoomvar.i &prog-zoom=inzoom/z01in263.w
                        &campo=i-operacao-origem
                        &campozoom=op-codigo}
                        /*&parametros="run pi-seta-inicial in wh-pesquisa (input c-roteiro-origem:screen-value in frame {&FRAME-NAME})."}*/
/*  end.
 *   else do:
 *      {include/zoomvar.i &prog-zoom=inzoom/z03in263.w
 *                         &campo=i-operacao-origem
 *                         &campozoom=op-codigo
 *                         &parametros="run pi-seta-inicial in wh-pesquisa (input c-item-origem:screen-value in frame {&FRAME-NAME})."
 *                         &excludevar=yes}
 *   end.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-operacao-origem V-table-Win
ON LEAVE OF i-operacao-origem IN FRAME f-main
DO:
   find first operacao no-lock
      where operacao.it-codigo   = input frame {&FRAME-NAME} c-item-origem 
      and   operacao.cod-roteiro = input frame {&FRAME-NAME} c-roteiro-origem 
      and   operacao.op-codigo   = input frame {&FRAME-NAME} i-operacao-origem no-error.
   if avail operacao then do:
      assign c-des-operacao-orig:screen-value in frame {&FRAME-NAME} = operacao.descricao.
   end.
   else do:
      assign c-des-operacao-orig:screen-value in frame {&FRAME-NAME} = "".
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-operacao-origem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-operacao-origem IN FRAME f-main
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
  
  if c-item-origem:load-mouse-pointer      ("image\lupa.cur") in frame {&FRAME-NAME} then.
  if c-roteiro-origem:load-mouse-pointer   ("image\lupa.cur") in frame {&FRAME-NAME} then.
  if i-operacao-origem:load-mouse-pointer  ("image\lupa.cur") in frame {&FRAME-NAME} then.
  if i-exame-inicial:load-mouse-pointer    ("image\lupa.cur") in frame {&FRAME-NAME} then.
  if i-exame-final:load-mouse-pointer      ("image\lupa.cur") in frame {&FRAME-NAME} then.
  if c-item-destino:load-mouse-pointer     ("image\lupa.cur") in frame {&FRAME-NAME} then.
  if c-roteiro-destino:load-mouse-pointer  ("image\lupa.cur") in frame {&FRAME-NAME} then.
  if i-operacao-destino:load-mouse-pointer ("image\lupa.cur") in frame {&FRAME-NAME} then.
      
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-liter.i Item_Origem * L}
  assign c-item-origem:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-liter.i Roteiro_Origem * L}
  assign c-roteiro-origem:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-liter.i Operaá∆o_Origem * L}
  assign i-operacao-origem:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-liter.i Exame_Inicial * L}
  assign i-exame-inicial:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-liter.i Exame_Final * L}
  assign i-exame-final:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-liter.i Item_Destino * L}
  assign c-item-destino:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-liter.i Roteiro_Destino * L}
  assign c-roteiro-destino:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-liter.i Operaá∆o_Destino * L}
  assign i-operacao-destino:label in frame {&FRAME-NAME} = return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-copia V-table-Win 
PROCEDURE pi-copia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
for each b-oper-exam no-lock
   where b-oper-exam.it-codigo   =  input frame {&FRAME-NAME} c-item-origem
   and   b-oper-exam.cod-roteiro =  input frame {&FRAME-NAME} c-roteiro-origem
   and   b-oper-exam.op-codigo   =  input frame {&FRAME-NAME} i-operacao-origem
   and   b-oper-exam.cod-exame   >= input frame {&FRAME-NAME} i-exame-inicial
   and   b-oper-exam.cod-exame   <= input frame {&FRAME-NAME} i-exame-final:

   FOR FIRST exame NO-LOCK 
       WHERE exame.cod-exame = b-oper-exam.cod-exame 
         AND exame.cdn-sit-vers = 2: /* Liberada */

       find first oper-exam no-lock
          where oper-exam.it-codigo   =  input frame {&FRAME-NAME} c-item-destino
          and   oper-exam.cod-roteiro =  input frame {&FRAME-NAME} c-roteiro-destino
          and   oper-exam.op-codigo   =  input frame {&FRAME-NAME} i-operacao-destino
          and   oper-exam.cod-exame   =  b-oper-exam.cod-exame no-error.
       if not avail oper-exam then do:
          create oper-exam.
          assign oper-exam.it-codigo   = input frame {&FRAME-NAME} c-item-destino
                 oper-exam.cod-roteiro = input frame {&FRAME-NAME} c-roteiro-destino
                 oper-exam.op-codigo   = input frame {&FRAME-NAME} i-operacao-destino
                 oper-exam.cod-exame   = b-oper-exam.cod-exame             
                 oper-exam.frequencia  = b-oper-exam.frequencia
                 oper-exam.perc-nqa    = b-oper-exam.perc-nqa
                 oper-exam.nivel       = b-oper-exam.nivel
                 oper-exam.situacao    = b-oper-exam.situacao
                 oper-exam.dt-inclusao = today
                 oper-exam.responsavel = b-oper-exam.responsavel.
       end. 

   END.
end.
run utp/ut-msgs.p (input "show",
                   input 694,
                   input i-operacao-origem:screen-value  in frame {&FRAME-NAME} + "~~" +
                         i-operacao-destino:screen-value in frame {&FRAME-NAME}).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida V-table-Win 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a validaá∆o de chave duplicada */
  
  /* Ponha aqui as demais validaá‰es */
  /* valida item origem */
  find item no-lock
     where item.it-codigo = c-item-origem:screen-value in frame {&FRAME-NAME} no-error.
  if not avail item then do:
     run utp/ut-msgs.p (input "show",
                        input 2,
                        input c-item-origem:screen-value in frame {&FRAME-NAME}).
     apply 'entry' to c-item-origem.
     return 'adm-error':U.
  end.
  
  find first rot-item 
     where rot-item.it-codigo =  c-item-origem:screen-value in frame {&FRAME-NAME} no-lock no-error. 
  
  /* valida roteiro origem */
  if avail rot-item then do:
     find rot-item no-lock
        where rot-item.it-codigo   = c-item-origem:screen-value    in frame {&FRAME-NAME} 
        and   rot-item.cod-roteiro = c-roteiro-origem:screen-value in frame {&FRAME-NAME} no-error.
     if not avail rot-item then do:
        run utp/ut-msgs.p (input "show",
                           input 2,
                           input c-roteiro-origem:screen-value in frame {&FRAME-NAME}).
        apply 'entry' to c-roteiro-origem.
        return 'adm-error':U.
     end.
  end. 
  /* verifica relaá∆o roteiro-operaá∆o e item-operaá∆o origem */
  if c-roteiro-origem:screen-value in frame {&FRAME-NAME} = "" then do:
     find first operacao no-lock
        where operacao.it-codigo = c-item-origem:screen-value             in frame {&FRAME-NAME}
        and   operacao.op-codigo = integer(i-operacao-origem:screen-value in frame {&FRAME-NAME}) no-error.
     if not avail operacao then do:
        run utp/ut-msgs.p (input "show",
                           input 1025,
                           input i-operacao-origem:screen-value in frame {&FRAME-NAME} + "~~" +
                                 c-item-origem:screen-value     in frame {&FRAME-NAME}).
        apply 'entry' to i-operacao-origem.
        return 'adm-error':U.
     end.
  end.
  else do:
     find first operacao no-lock
        where operacao.cod-roteiro = c-roteiro-origem:screen-value          in frame {&FRAME-NAME}
        and   operacao.op-codigo   = integer(i-operacao-origem:screen-value in frame {&FRAME-NAME}) no-error.
     if not avail operacao then do:
        run utp/ut-msgs.p (input "show",
                           input 1026,
                           input i-operacao-origem:screen-value in frame {&FRAME-NAME} + "~~" +
                                 c-roteiro-origem:screen-value  in frame {&FRAME-NAME}).
        apply 'entry' to i-operacao-origem.
        return 'adm-error':U.
     end.  
  end.
    
  /* valida o exame inicial */
  find first b-oper-exam no-lock
     where b-oper-exam.it-codigo   = c-item-origem:screen-value             in frame {&FRAME-NAME}
     and   b-oper-exam.cod-roteiro = c-roteiro-origem:screen-value          in frame {&FRAME-NAME}
     and   b-oper-exam.op-codigo   = integer(i-operacao-origem:screen-value in frame {&FRAME-NAME})
     and   b-oper-exam.cod-exame   = integer(i-exame-inicial:screen-value   in frame {&FRAME-NAME}) no-error.
  if not avail b-oper-exam then do:
        run utp/ut-msgs.p (input "show",
                           input 1030,
                           input i-exame-inicial:screen-value   in frame {&FRAME-NAME} + "~~" +
                                 i-operacao-origem:screen-value in frame {&FRAME-NAME}).
        apply 'entry' to i-exame-inicial.
        return 'adm-error':U.
  end.
    
  /* valida o exame final */
  find first b-oper-exam no-lock
     where b-oper-exam.it-codigo   = c-item-origem:screen-value             in frame {&FRAME-NAME}
     and   b-oper-exam.cod-roteiro = c-roteiro-origem:screen-value          in frame {&FRAME-NAME}
     and   b-oper-exam.op-codigo   = integer(i-operacao-origem:screen-value in frame {&FRAME-NAME})
     and   b-oper-exam.cod-exame   = integer(i-exame-final:screen-value     in frame {&FRAME-NAME}) no-error.
  if not avail b-oper-exam then do:
        run utp/ut-msgs.p (input "show",
                           input 1030,
                           input i-exame-final:screen-value     in frame {&FRAME-NAME} + "~~" +
                                 i-operacao-origem:screen-value in frame {&FRAME-NAME}).
        apply 'entry' to i-exame-final.
        return 'adm-error':U.
  end.

  /* valida item destino */
  find item no-lock
     where item.it-codigo = c-item-destino:screen-value in frame {&FRAME-NAME} no-error.
  if not avail item then do:
     run utp/ut-msgs.p (input "show",
                        input 2,
                        input c-item-destino:screen-value in frame {&FRAME-NAME}).
     apply 'entry' to c-item-destino.
     return 'adm-error':U.
  end.
  find first rot-item 
     where rot-item.it-codigo =  c-item-destino:screen-value in frame {&FRAME-NAME} no-lock no-error. 

  /* valida roteiro destino */
  if avail rot-item then do:
     find rot-item 
        where rot-item.it-codigo   = c-item-destino:screen-value    in frame {&FRAME-NAME}
        and   rot-item.cod-roteiro = c-roteiro-destino:screen-value in frame {&FRAME-NAME} no-lock no-error.
     if not avail rot-item then do:
        run utp/ut-msgs.p (input "show",
                           input 2,
                           input c-roteiro-destino:screen-value in frame {&FRAME-NAME}).
        apply 'entry' to c-roteiro-destino.
        return 'adm-error':U.
     end.
  end.
  /* verifica relaá∆o roteiro-operaá∆o e item-operaá∆o destino*/
  if c-roteiro-destino:screen-value in frame {&FRAME-NAME} = "" then do:
     find first operacao no-lock
        where operacao.it-codigo = c-item-destino:screen-value             in frame {&FRAME-NAME}
        and   operacao.op-codigo = integer(i-operacao-destino:screen-value in frame {&FRAME-NAME}) no-error.
     if not avail operacao then do:
        run utp/ut-msgs.p (input "show",
                           input 1025,
                           input i-operacao-destino:screen-value in frame {&FRAME-NAME} + "~~" +
                                 c-item-destino:screen-value in frame {&FRAME-NAME}).
        apply 'entry' to i-operacao-destino.
        return 'adm-error':U.
     end.
  end.
  else do:
     find first operacao no-lock
        where operacao.cod-roteiro = c-roteiro-destino:screen-value          in frame {&FRAME-NAME}
        and   operacao.op-codigo   = integer(i-operacao-destino:screen-value in frame {&FRAME-NAME}) no-error.
     if not avail operacao then do:
        run utp/ut-msgs.p (input "show",
                           input 1026,
                           input i-operacao-destino:screen-value in frame {&FRAME-NAME} + "~~" +
                                 c-roteiro-destino:screen-value in frame {&FRAME-NAME}).
        apply 'entry' to i-operacao-destino.
        return 'adm-error':U.
     end.  
  end.

  /* verifica se as operaá‰es s∆o iguais */
  if c-item-origem:screen-value     in frame {&FRAME-NAME} = c-item-destino:screen-value     in frame {&FRAME-NAME} and
     c-roteiro-origem:screen-value  in frame {&FRAME-NAME} = c-roteiro-destino:screen-value  in frame {&FRAME-NAME} and
     i-operacao-origem:screen-value in frame {&FRAME-NAME} = i-operacao-destino:screen-value in frame {&FRAME-NAME} then do:
        run utp/ut-msgs.p (input "show",
                           input 1033,
                           input i-operacao-destino:screen-value in frame {&FRAME-NAME} + "~~" +
                                 i-operacao-destino:screen-value in frame {&FRAME-NAME}).
        apply 'entry' to c-item-origem.
        return 'adm-error':U.
  end.
  

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

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


