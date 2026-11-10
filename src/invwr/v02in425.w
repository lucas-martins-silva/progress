&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V02IN425 2.00.00.030 } /*** 010030 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN425 MUT}
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

{cdp/cdcfgmat.i}

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.          
def new global shared var gr-tb-pr-cc  as rowid no-undo.

/* Parameters Definitions ---                                           */
def buffer buffer-tabela for tb-pr-cc.

/* Local Variable Definitions ---                                       */
def var da-proxima as date no-undo.
def var hl-handle as handle no-undo.
def var c-nome-abrev as character no-undo.
def var r-emitente as rowid no-undo.
def var c-texto as CHAR NO-UNDO.
DEF VAR da-data-inic LIKE tb-pr-cc.dt-inicio NO-UNDO.
DEF VAR da-data-fim  LIKE tb-pr-cc.dt-termino NO-UNDO.
def var l-sobrepoe as logical no-undo.

DEFINE BUFFER bf-tb-pr-cc FOR tb-pr-cc.
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
&Scoped-define EXTERNAL-TABLES tb-pr-cc
&Scoped-define FIRST-EXTERNAL-TABLE tb-pr-cc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR tb-pr-cc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tb-pr-cc.descricao 
&Scoped-define ENABLED-TABLES tb-pr-cc
&Scoped-define FIRST-ENABLED-TABLE tb-pr-cc
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS tb-pr-cc.cod-emitente tb-pr-cc.nome-abrev ~
tb-pr-cc.nr-tab tb-pr-cc.cod-cond-pag tb-pr-cc.descricao ~
tb-pr-cc.cod-estabel tb-pr-cc.mo-codigo 
&Scoped-define DISPLAYED-TABLES tb-pr-cc
&Scoped-define FIRST-DISPLAYED-TABLE tb-pr-cc
&Scoped-Define DISPLAYED-OBJECTS c-cond-pagto c-nome-estabelec c-desc-moeda 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS tb-pr-cc.cod-emitente tb-pr-cc.nome-abrev ~
tb-pr-cc.nr-tab tb-pr-cc.cod-cond-pag tb-pr-cc.cod-estabel ~
tb-pr-cc.mo-codigo 
&Scoped-define ADM-ASSIGN-FIELDS tb-pr-cc.cod-emitente 

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
DEFINE VARIABLE c-cond-pagto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-estabelec AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 41.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 5.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tb-pr-cc.cod-emitente AT ROW 1.17 COL 22.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tb-pr-cc.nome-abrev AT ROW 1.17 COL 36.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 18.86 BY .88
     tb-pr-cc.nr-tab AT ROW 1.17 COL 69.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     tb-pr-cc.cod-cond-pag AT ROW 2.17 COL 22.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     c-cond-pagto AT ROW 2.17 COL 28.14 COLON-ALIGNED NO-LABEL
     tb-pr-cc.descricao AT ROW 3.17 COL 22.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 47.43 BY .88
     tb-pr-cc.cod-estabel AT ROW 4.17 COL 22.43 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .88
     c-nome-estabelec AT ROW 4.17 COL 28.14 COLON-ALIGNED HELP
          "Nome Estabelecimento" NO-LABEL WIDGET-ID 14
     tb-pr-cc.mo-codigo AT ROW 5.13 COL 22.43 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-moeda AT ROW 5.13 COL 27.29 COLON-ALIGNED HELP
          "Descri‡Æo da moeda" NO-LABEL WIDGET-ID 16
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.tb-pr-cc
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
         HEIGHT             = 5.29
         WIDTH              = 88.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cond-pagto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-estabelec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tb-pr-cc.cod-cond-pag IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN tb-pr-cc.cod-emitente IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN tb-pr-cc.cod-estabel IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN tb-pr-cc.mo-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN tb-pr-cc.nome-abrev IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN tb-pr-cc.nr-tab IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME c-cond-pagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cond-pagto V-table-Win
ON F5 OF c-cond-pagto IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad039.w
                     &campo=tb-pr-cc.cod-cond-pag
                     &campozoom=cod-cond-pag}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cond-pagto V-table-Win
ON LEAVE OF c-cond-pagto IN FRAME f-main
DO:
  {include/leave.i &tabela=cond-pagto
                   &atributo-ref=descricao
                   &variavel-ref=c-cond-pagto
                   &where="cond-pagto.cod-cond-pag = input frame {&frame-name}
                     tb-pr-cc.cod-cond-pag"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cond-pagto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cond-pagto IN FRAME f-main
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-pr-cc.cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.cod-cond-pag V-table-Win
ON F5 OF tb-pr-cc.cod-cond-pag IN FRAME f-main /* Condi‡Æo Pagamento */
DO:
   assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=adzoom/z01ad039.w
                     &campo=tb-pr-cc.cod-cond-pag
                     &campozoom=cod-cond-pag}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.cod-cond-pag V-table-Win
ON LEAVE OF tb-pr-cc.cod-cond-pag IN FRAME f-main /* Condi‡Æo Pagamento */
DO:
  {include/leave.i &tabela=cond-pagto
                   &atributo-ref=descricao
                   &variavel-ref=c-cond-pagto
                   &where="cond-pagto.cod-cond-pag = input frame {&frame-name}
                    tb-pr-cc.cod-cond-pag"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.cod-cond-pag V-table-Win
ON MOUSE-SELECT-DBLCLICK OF tb-pr-cc.cod-cond-pag IN FRAME f-main /* Condi‡Æo Pagamento */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-pr-cc.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.cod-emitente V-table-Win
ON F5 OF tb-pr-cc.cod-emitente IN FRAME f-main /* Fornecedor */
DO:

  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=adzoom/z03ad098.w
                     &campo=tb-pr-cc.cod-emitente
                     &campozoom=cod-emitente
                     &campo2=tb-pr-cc.nome-abrev
                     &campozoom2=nome-abrev}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.cod-emitente V-table-Win
ON LEAVE OF tb-pr-cc.cod-emitente IN FRAME f-main /* Fornecedor */
DO:
find emitente where emitente.cod-emitente = input frame {&frame-name} tb-pr-cc.cod-emitente
    no-lock no-error.

if  avail emitente then do:

    assign tb-pr-cc.nome-abrev:screen-value in frame {&frame-name} = emitente.nome-abrev.

    /***Moeda PadrÆo do Fornecedor - 2.04A***/

    &IF DEFINED(bf_mat_custeio_item) &THEN
    
        find first dist-emitente where
                   dist-emitente.cod-emitente = emitente.cod-emitente no-lock no-error.
        if  avail dist-emitente then
            assign tb-pr-cc.mo-codigo:screen-value in frame {&frame-name} = string(dist-emitente.mo-fatur).
        else    
            assign tb-pr-cc.mo-codigo:screen-value in frame {&frame-name} = string(0).
        
        apply "leave" to tb-pr-cc.mo-codigo in frame {&frame-name}.
    
    &ENDIF



end.
else
    assign tb-pr-cc.nome-abrev:screen-value in frame {&frame-name} = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.cod-emitente V-table-Win
ON MOUSE-SELECT-DBLCLICK OF tb-pr-cc.cod-emitente IN FRAME f-main /* Fornecedor */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-pr-cc.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.cod-estabel V-table-Win
ON F5 OF tb-pr-cc.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/Z01ad107.w
                       &campo=tb-pr-cc.cod-estabel
                       &campozoom=cod-estabel
                       &campo2=c-nome-estabelec
                       &campozoom2=nome}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.cod-estabel V-table-Win
ON LEAVE OF tb-pr-cc.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
find FIRST estabelec where estabelec.cod-estabel = input frame {&frame-name} tb-pr-cc.cod-estabel
    no-lock no-error.

if  avail estabelec then do:

    assign c-nome-estabelec:screen-value in frame {&frame-name} = estabelec.nome.

end.
else
    assign c-nome-estabelec:screen-value in frame {&frame-name} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF tb-pr-cc.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-pr-cc.descricao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.descricao V-table-Win
ON LEAVE OF tb-pr-cc.descricao IN FRAME f-main /* Descri‡Æo */
DO:
  if tb-pr-cc.nome-abrev:sensitive in frame {&frame-name} then do:
     find last buffer-tabela where
        buffer-tabela.nome-abrev = input frame {&frame-name} tb-pr-cc.nome-abrev and
        buffer-tabela.cod-cond-pag = input frame {&frame-name} tb-pr-cc.cod-cond-pag and
        buffer-tabela.nr-tab <> input frame {&frame-name} tb-pr-cc.nr-tab AND
        buffer-tabela.cod-estabel = input frame {&frame-name} tb-pr-cc.cod-estabel AND
        buffer-tabela.mo-codigo   = input frame {&frame-name} tb-pr-cc.mo-codigo no-lock no-error. /*juliano*/

     if available buffer-tabela then do:
        if buffer-tabela.dt-termino < 12/31/9999 then 
           assign da-proxima = buffer-tabela.dt-termino + 1.
        else 
           assign da-proxima = buffer-tabela.dt-termino.
     end.   
     else 
        assign da-proxima = today.

     run pi-seta-data in hl-handle (input da-proxima).
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-pr-cc.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.mo-codigo V-table-Win
ON F5 OF tb-pr-cc.mo-codigo IN FRAME f-main /* Moeda */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=unzoom/z01un005.w
                     &campo=tb-pr-cc.mo-codigo
                     &campozoom=mo-codigo
                     &campo2=tb-pr-cc.descricao
                     &campozoom2=c-desc-moeda}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.mo-codigo V-table-Win
ON LEAVE OF tb-pr-cc.mo-codigo IN FRAME f-main /* Moeda */
DO:
find first moeda where moeda.mo-codigo = input frame {&frame-name} tb-pr-cc.mo-codigo
    no-lock no-error.

if  avail moeda then do:

    assign c-desc-moeda:screen-value in frame {&frame-name} = moeda.descricao.

end.
else
    assign c-desc-moeda:screen-value in frame {&frame-name} = "".

APPLY "LEAVE":U TO tb-pr-cc.descricao IN FRAME f-main.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.mo-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF tb-pr-cc.mo-codigo IN FRAME f-main /* Moeda */
DO:
   apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-pr-cc.nome-abrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.nome-abrev V-table-Win
ON F5 OF tb-pr-cc.nome-abrev IN FRAME f-main /* Nome Abrev */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=adzoom/z03ad098.w
                     &campo=tb-pr-cc.nome-abrev
                     &campozoom=nome-abrev
                     &campo2=tb-pr-cc.cod-emitente
                     &campozoom2=cod-emitente }.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.nome-abrev V-table-Win
ON LEAVE OF tb-pr-cc.nome-abrev IN FRAME f-main /* Nome Abrev */
DO:

find emitente where emitente.nome-abrev = input frame {&frame-name} tb-pr-cc.nome-abrev
    no-lock no-error.
if  avail emitente then
    assign tb-pr-cc.cod-emitente:screen-value in frame {&frame-name} = string(emitente.cod-emitente).
else
    assign tb-pr-cc.cod-emitente:screen-value in frame {&frame-name} = "0".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.nome-abrev V-table-Win
ON MOUSE-SELECT-DBLCLICK OF tb-pr-cc.nome-abrev IN FRAME f-main /* Nome Abrev */
DO:
    apply "F5" to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-pr-cc.nr-tab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.nr-tab V-table-Win
ON F5 OF tb-pr-cc.nr-tab IN FRAME f-main /* Tabela */
DO:
  assign c-nome-abrev  = input frame {&frame-name} tb-pr-cc.nome-abrev.
  find FIRST emitente where emitente.nome-abrev = c-nome-abrev no-lock no-error. /*juliano*/
  if avail emitente then do:
     assign r-emitente = rowid(emitente).       
     {include/zoomvar.i &prog-zoom = "inzoom/z02in425.w"
                        &campo = tb-pr-cc.nr-tab
                        &campo2 = tb-pr-cc.cod-cond-pag
                        &campo3 = tb-pr-cc.cod-estabel
                        &campo4 = tb-pr-cc.mo-codigo
                        &campo5 = tb-pr-cc.descricao                     
                        &campozoom = nr-tab
                        &campozoom2 = cod-cond-pag
                        &campozoom3 = cod-estabel
                        &campozoom4 = mo-codigo
                        &campozoom5 = descricao
                        &parametros="run pi-seta-inicial in wh-pesquisa (input r-emitente)."} 
  end.
  else do:
     {include/zoom.i &prog-zoom="inzoom/z01in425.w"
                     &tabela=tb-pr-cc
                     &atributo=nr-tab
                     &atributo2=nome-abrev
                     &atributo3=cod-cond-pag
                     &atributo4=cod-estabel
                     &atributo5=mo-codigo}  

/*     run utp/ut-msgs.p (input "show",
 *                         input 1,
 *                         input return-value).
 *      apply "entry" to tb-pr-cc.nome-abrev in frame {&frame-name}.
 *      return error.*/
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-pr-cc.nr-tab V-table-Win
ON MOUSE-SELECT-DBLCLICK OF tb-pr-cc.nr-tab IN FRAME f-main /* Tabela */
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

  if tb-pr-cc.cod-emitente:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.
  if tb-pr-cc.nr-tab:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.
  if tb-pr-cc.cod-cond-pag:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.
  if tb-pr-cc.nome-abrev:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.
  if tb-pr-cc.cod-estabel:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.

  /************************ INTERNAL PROCEDURES ********************/

{utp/ut-liter.i Fornecedor}
assign tb-pr-cc.cod-emitente:label in frame {&frame-name} = trim(return-value).

if tb-pr-cc.mo-codigo:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "tb-pr-cc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "tb-pr-cc"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
/* Validar o campo nr-tab caso tenha combinação com os campos : Fornecedor, Condição de Pagamento, Estabelecimento e Moeda*/
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  

  if tb-pr-cc.nome-abrev:sensitive in frame {&frame-name} = yes then do:
      IF CAN-FIND(FIRST tb-pr-cc 
                  WHERE tb-pr-cc.cod-emitente = input frame {&frame-name} tb-pr-cc.cod-emitente AND
                        tb-pr-cc.cod-cond-pag = input frame {&frame-name} tb-pr-cc.cod-cond-pag AND
                        tb-pr-cc.mo-codigo    = input frame {&frame-name} tb-pr-cc.mo-codigo    AND
                        tb-pr-cc.cod-estabel  = input frame {&frame-name} tb-pr-cc.cod-estabel  AND
                        tb-pr-cc.nr-tab       = input frame {&frame-name} tb-pr-cc.nr-tab NO-LOCK) THEN DO:
                   
           {utp/ut-liter.i Tabela_de_Pre‡o * R}
            run utp/ut-msgs.p (input "show",
                               input 54007, 
                               input return-value).
           apply 'entry' to tb-pr-cc.nr-tab in frame {&frame-name}.
           return error.                        
      END.
  END.

  if valid-handle (hl-handle) then do:
      run pi-retorna-data in hl-handle (output da-data-inic, output da-data-fim).
  end.                                                                           
  
  /*---- Sobreposi‡Æo com datas de validade de outra tabela de pre‡os -----*/
  assign l-sobrepoe = no.
  FOR EACH bf-tb-pr-cc
       where bf-tb-pr-cc.cod-emitente  = input frame {&frame-name} tb-pr-cc.cod-emitente
         and bf-tb-pr-cc.cod-cond-pag  = input frame {&frame-name} tb-pr-cc.cod-cond-pag
         and bf-tb-pr-cc.nr-tab       <> input frame {&frame-name} tb-pr-cc.nr-tab
         AND bf-tb-pr-cc.cod-estabel   = input frame {&frame-name} tb-pr-cc.cod-estabel
         AND bf-tb-pr-cc.mo-codigo     = input frame {&frame-name} tb-pr-cc.mo-codigo
         and bf-tb-pr-cc.situacao      = 1 NO-LOCK:
      
      if  da-data-inic <= bf-tb-pr-cc.dt-termino and
          da-data-fim  >= bf-tb-pr-cc.dt-inicio then do:
          assign l-sobrepoe = yes.
      end.
  END.
  
  if  l-sobrepoe = yes then do:
      run utp/ut-msgs.p (input "show",
                         input 1276,
                         input "").
      return error.
  end.

/* Verifica estabelecimento */
  IF INPUT FRAME {&FRAME-NAME} tb-pr-cc.cod-estabel <> "" THEN
    IF NOT CAN-FIND (FIRST estabelec WHERE estabelec.cod-estabel = INPUT FRAME {&FRAME-NAME} tb-pr-cc.cod-estabel) THEN DO:
       {utp/ut-liter.i Estabelecimento * R}
        run utp/ut-msgs.p (input "show",
                           input 2, 
                           input return-value).
        apply 'entry' to tb-pr-cc.cod-estabel in frame {&frame-name}.
        return error.
    END.

/* Verifica Moeda */
    IF NOT CAN-FIND (FIRST moeda WHERE moeda.mo-codigo = INPUT FRAME {&FRAME-NAME} tb-pr-cc.mo-codigo) THEN DO:
       {utp/ut-liter.i Moeda * R}
        run utp/ut-msgs.p (input "show",
                           input 2, 
                           input return-value).
        apply 'entry' to tb-pr-cc.mo-codigo in frame {&frame-name}.
        return error.
    END.

/* Verifica fornecedor */
   if input frame {&frame-name} tb-pr-cc.nome-abrev = "" then do:
      {utp/ut-field.i mgind tb-pr-cc nome-abrev 1}
      assign c-texto = return-value.
      {utp/ut-table.i mgind tb-pr-cc 1}
      run utp/ut-msgs.p (input "show",
                         input 6216,
                         input c-texto + "~~" + return-value).
      apply 'entry' to tb-pr-cc.nome-abrev in frame {&frame-name}.
      return error.
   end. 

   if input frame {&frame-name} tb-pr-cc.nome-abrev = ? then do:
      {utp/ut-liter.i Nome_Abreviado * R}   
      run utp/ut-msgs.p (input "show",
                         input 158,
                         input return-value).
      apply "entry" to tb-pr-cc.nome-abrev in frame {&frame-name}.
      return error.
   end.
   else do:
      find emitente where 
         emitente.cod-emitente = input frame {&frame-name} tb-pr-cc.cod-emitente and
         emitente.identific <> 1 exclusive-lock no-error. /*juliano*/
      if not available emitente then do:
         {utp/ut-liter.i Emitente * R} 
         run utp/ut-msgs.p (input "show",
                            input 558,
                            input return-value).
         apply "entry" to tb-pr-cc.nome-abrev in frame {&frame-name}.
         return error.
      end.
   end.

/* Verifica tabela */
   if input frame {&frame-name} tb-pr-cc.nr-tab = "" then do:
      {utp/ut-field.i mgind tb-pr-cc nr-tab 1}
      assign c-texto = return-value.
      {utp/ut-table.i mgind tb-pr-cc 1}
      run utp/ut-msgs.p (input "show",
                         input 6216,
                         input c-texto + "~~" + return-value).
      apply 'entry' to tb-pr-cc.nr-tab in frame {&frame-name}.
      return error.
   end.

   if input frame {&frame-name} tb-pr-cc.nr-tab = ? then do:
      {utp/ut-liter.i N£mero_da_Tabela * R}
      run utp/ut-msgs.p (input "show",
                         input 158,
                         input return-value).
      apply "entry" to tb-pr-cc.nr-tab in frame {&frame-name}.
      return error.
   end.

/* Verifica condi‡Æo de pagto */
   if input frame {&frame-name} tb-pr-cc.cod-cond-pag = "" then do:
      {utp/ut-field.i mgind tb-pr-cc cod-cond-pag 1}
      assign c-texto = return-value.
      {utp/ut-table.i mgind tb-pr-cc 1}
      run utp/ut-msgs.p (input "show",
                         input 6216,
                         input c-texto + "~~" + return-value).
      apply 'entry' to tb-pr-cc.cod-cond-pag in frame {&frame-name}.
      return error.
   end.                       

   if input frame {&frame-name} tb-pr-cc.cod-cond-pag = ? then do:
      {utp/ut-liter.i Condi‡Æo_de_Pagamento * R}
      run utp/ut-msgs.p (input "show",
                         input 158,
                         input return-value).
      apply "entry" to tb-pr-cc.cod-cond-pag in frame {&frame-name}.
      return error.
   end.
   else do:
      find cond-pagto where cond-pagto.cod-cond-pag = input frame {&frame-name} tb-pr-cc.cod-cond-pag no-lock no-error. /*juliano*/
      if not available cond-pagto then do:
         {utp/ut-liter.i Condi‡Æo_de_Pagamento * R}
         run utp/ut-msgs.p (input "show",
                            input 47,
                            input return-value).
         apply "entry" to tb-pr-cc.cod-cond-pag in frame {&frame-name}.
         return error.
      end.
   end.

/* Verifica descri‡Æo da tabela */
   if input frame {&frame-name} tb-pr-cc.descricao = ? then do:
      {utp/ut-liter.i Descri‡Æo * R}
      run utp/ut-msgs.p (input "show",
                         input 158,
                         input return-value).
      apply "entry" to tb-pr-cc.descricao in frame {&frame-name}.
      return error.
   end.

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

  find emitente where emitente.cod-emitente = tb-pr-cc.cod-emitente no-lock no-error.
  assign tb-pr-cc.nome-abrev = emitente.nome-abrev.

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

  &if defined(bf_mat_contratos) &then
  if  avail tb-pr-cc then
      assign tb-pr-cc.cod-emitente = input frame {&frame-name} tb-pr-cc.cod-emitente.
  &endif
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

  if avail tb-pr-cc then do:
   find cond-pagto where cond-pagto.cod-cond-pag = tb-pr-cc.cod-cond-pag no-lock no-error.
    assign c-cond-pagto = if avail cond-pagto then cond-pagto.descricao else "":U.
  end.  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    if avail tb-pr-cc then do:
        find moeda where moeda.mo-codigo = tb-pr-cc.mo-codigo no-lock no-error.
        assign c-desc-moeda = if avail moeda then moeda.descricao else "":U.
        display c-desc-moeda with frame {&frame-name}. 
    end.

    if avail tb-pr-cc then do:
        find estabelec where estabelec.cod-estabel = tb-pr-cc.cod-estabel no-lock no-error.
        assign c-nome-estabelec = if avail estabelec then estabelec.nome else "":U.
        display c-nome-estabelec with frame {&frame-name}. 
    end.  

    if valid-handle (hl-handle) then
        run pi-retorna-data in hl-handle (output da-data-inic, output da-data-fim).
  
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
  &ENDIF
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

  if avail tb-pr-cc then 
   assign gr-tb-pr-cc = rowid(tb-pr-cc).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-rowid V-table-Win 
PROCEDURE pi-retorna-rowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter r-x as rowid.

find first tb-pr-cc where 
             tb-pr-cc.cod-emitente = input frame {&frame-name} tb-pr-cc.cod-emitente and   
             tb-pr-cc.nr-tab       = input frame {&frame-name} tb-pr-cc.nr-tab       and   
             tb-pr-cc.cod-cond-pag = input frame {&frame-name} tb-pr-cc.cod-cond-pag and
             tb-pr-cc.cod-estabel  = input frame {&frame-name} tb-pr-cc.cod-estabel  and
             tb-pr-cc.mo-codigo    = input frame {&frame-name} tb-pr-cc.mo-codigo
             no-lock no-error.

if avail tb-pr-cc then do:
    assign r-x = rowid(tb-pr-cc).
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-valores V-table-Win 
PROCEDURE pi-retorna-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter p-nome-abrev   like tb-pr-cc.nome-abrev.
def output parameter p-cod-cond-pag like tb-pr-cc.cod-cond-pag.
def output parameter p-nr-tab       like tb-pr-cc.nr-tab.
def output parameter p-cod-estabel  LIKE tb-pr-cc.cod-estabel.
def output parameter p-mo-codigo    LIKE tb-pr-cc.mo-codigo.

assign p-cod-cond-pag = input frame {&frame-name} tb-pr-cc.cod-cond-pag
       p-nome-abrev   = input frame {&frame-name} tb-pr-cc.nome-abrev
       p-nr-tab       = input frame {&frame-name} tb-pr-cc.nr-tab
       p-cod-estabel  = input frame {&frame-name} tb-pr-cc.cod-estabel
       p-mo-codigo    = input frame {&frame-name} tb-pr-cc.mo-codigo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-handle V-table-Win 
PROCEDURE pi-seta-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-handle as handle.
    assign hl-handle = p-handle.

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
  {src/adm/template/snd-list.i "tb-pr-cc"}

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

