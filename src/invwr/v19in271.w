&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
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
{include/i-prgvrs.i V19IN271 2.00.00.030}  /*** 010030 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v19in271 MUT}
&ENDIF

/*------------------------------------------------------------------------


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
def new global shared var v-row-parent as rowid              no-undo.    
def new global shared var i-ordem LIKE ord-prod.nr-ord-produ no-undo.

def new global shared var gr-estabel  as rowid  no-undo.
def new global shared var gr-deposito as rowid  no-undo.
def new global shared var gr-ord-prod as rowid  no-undo.
def new global shared var gr-item     as rowid  no-undo.
def new global shared var h-acomp     as handle no-undo.

{cdp/cdcfgman.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var l-erro-valid          as logical                no-undo.
def var l-prim-exec           as logical init yes       no-undo.
def var c-handle              as char                   no-undo.
def var h-handle              as handle                 no-undo.
def var c-retorno             as char                   no-undo.
def var c-erro                as char                   no-undo.
def var c-texto               as char                   no-undo.
def var l-busca-saldos        as logical                no-undo.
def var i-cont                as integer                no-undo.
DEF VAR l-usa-config          AS LOGICAL                NO-UNDO.
DEFINE VARIABLE l-ini-upd     AS LOGICAL INIT YES       NO-UNDO.
def new global shared var l-pag-movtos as LOG INIT NO no-undo.

{cpp/cpapi012.i}
{cpp/cpapi012.i1}
{cdp/cd0666.i}

{cpp/cpapi022.i}

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
&Scoped-define EXTERNAL-TABLES ord-prod
&Scoped-define FIRST-EXTERNAL-TABLE ord-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ord-prod.nr-ord-produ 
&Scoped-define ENABLED-TABLES ord-prod
&Scoped-define FIRST-ENABLED-TABLE ord-prod
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 RECT-36 RECT-37 
&Scoped-Define DISPLAYED-FIELDS ord-prod.nr-ord-produ ord-prod.cod-estabel ~
ord-prod.conta-ordem ord-prod.it-codigo ord-prod.cod-refer ~
ord-prod.qt-ordem ord-prod.qt-requisita 
&Scoped-define DISPLAYED-TABLES ord-prod
&Scoped-define FIRST-DISPLAYED-TABLE ord-prod
&Scoped-Define DISPLAYED-OBJECTS rs-req-dev c-it-descricao cb-estado ~
fi-qt-requisita da-data-requis c-item-ini c-item-fin c-depos-ini ~
c-depos-fin i-oper-ini i-oper-fin fi-label-retangulo f-inicial f-final 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS rs-req-dev 
&Scoped-define ADM-ASSIGN-FIELDS rs-req-dev ord-prod.conta-ordem ~
ord-prod.it-codigo c-it-descricao ord-prod.cod-refer cb-estado ~
ord-prod.qt-ordem fi-qt-requisita da-data-requis c-item-ini c-item-fin ~
c-depos-ini c-depos-fin i-oper-ini i-oper-fin 
&Scoped-define ADM-MODIFY-FIELDS rs-req-dev fi-qt-requisita da-data-requis ~
c-item-ini c-item-fin c-depos-ini c-depos-fin i-oper-ini i-oper-fin 
&Scoped-define List-4 ord-prod.qt-requisita fi-qt-requisita da-data-requis ~
c-item-ini c-item-fin c-depos-ini c-depos-fin i-oper-ini i-oper-fin 

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
DEFINE VARIABLE cb-estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE c-depos-fin AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-depos-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-descricao AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 51.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-fin AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-requis AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE f-final AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 6 BY .75 NO-UNDO.

DEFINE VARIABLE f-inicial AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 6 BY .75 NO-UNDO.

DEFINE VARIABLE fi-label-retangulo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13 BY .67 NO-UNDO.

DEFINE VARIABLE fi-qt-requisita AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE i-oper-fin AS INTEGER FORMAT ">>>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-oper-ini AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE rs-req-dev AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Requisi‡Æo", 1,
"Devolu‡Æo", 2
     SIZE 44 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 56 BY 1.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 1.75.

DEFINE RECTANGLE RECT-36
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 12.25.

DEFINE RECTANGLE RECT-37
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.43 BY 3.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ord-prod.nr-ord-produ AT ROW 1.5 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     rs-req-dev AT ROW 3.75 COL 26 NO-LABEL
     ord-prod.cod-estabel AT ROW 5 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .88
     ord-prod.conta-ordem AT ROW 5 COL 53 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     ord-prod.it-codigo AT ROW 6 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     c-it-descricao AT ROW 6 COL 34.57 COLON-ALIGNED NO-LABEL
     ord-prod.cod-refer AT ROW 7 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .88
     cb-estado AT ROW 7 COL 53 COLON-ALIGNED
     ord-prod.qt-ordem AT ROW 8.25 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     ord-prod.qt-requisita AT ROW 8.25 COL 53 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     fi-qt-requisita AT ROW 9.25 COL 17.29 COLON-ALIGNED
     da-data-requis AT ROW 9.25 COL 53 COLON-ALIGNED
     c-item-ini AT ROW 11.5 COL 17.29 COLON-ALIGNED
     c-item-fin AT ROW 11.5 COL 53 COLON-ALIGNED NO-LABEL
     c-depos-ini AT ROW 12.5 COL 17.29 COLON-ALIGNED
     c-depos-fin AT ROW 12.5 COL 53 COLON-ALIGNED NO-LABEL
     i-oper-ini AT ROW 13.5 COL 17.29 COLON-ALIGNED
     i-oper-fin AT ROW 13.5 COL 53 COLON-ALIGNED NO-LABEL
     fi-label-retangulo AT ROW 3 COL 19 COLON-ALIGNED NO-LABEL
     f-inicial AT ROW 10.75 COL 20 COLON-ALIGNED NO-LABEL
     f-final AT ROW 10.75 COL 55 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 3.25 COL 17
     RECT-3 AT ROW 1 COL 1
     RECT-36 AT ROW 2.75 COL 1
     RECT-37 AT ROW 11 COL 2.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.ord-prod
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
         HEIGHT             = 14.04
         WIDTH              = 88.29.
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

/* SETTINGS FOR FILL-IN c-depos-fin IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR FILL-IN c-depos-ini IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR FILL-IN c-it-descricao IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN c-item-fin IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR FILL-IN c-item-ini IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR COMBO-BOX cb-estado IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ord-prod.cod-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-prod.cod-refer IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ord-prod.conta-ordem IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN da-data-requis IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR FILL-IN f-final IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-inicial IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label-retangulo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qt-requisita IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR FILL-IN i-oper-fin IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR FILL-IN i-oper-ini IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR FILL-IN ord-prod.it-codigo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ord-prod.qt-ordem IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ord-prod.qt-requisita IN FRAME f-main
   NO-ENABLE 4                                                          */
/* SETTINGS FOR RADIO-SET rs-req-dev IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
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

&Scoped-define SELF-NAME c-depos-fin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-fin V-table-Win
ON F5 OF c-depos-fin IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom = "inzoom/z01in084.w"
                     &campo     = c-depos-fin
                     &campozoom = cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-fin V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-depos-fin IN FRAME f-main
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-depos-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-ini V-table-Win
ON F5 OF c-depos-ini IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom = "inzoom/z01in084.w"
                     &campo     = c-depos-ini
                     &campozoom = cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-ini V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-depos-ini IN FRAME f-main
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-item-fin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-fin V-table-Win
ON F5 OF c-item-fin IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom = "inzoom/z02in172.w"
                     &campo     = c-item-fin
                     &campozoom = it-codigo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-fin V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-item-fin IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-item-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-ini V-table-Win
ON F5 OF c-item-ini IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom = "inzoom/z02in172.w"
                     &campo     = c-item-ini
                     &campozoom = it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-ini V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-item-ini IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-oper-fin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-oper-fin V-table-Win
ON F5 OF i-oper-fin IN FRAME f-main
DO:
  ASSIGN i-ordem = ord-prod.nr-ord-prod.
  {include/zoomvar.i &prog-zoom = "inzoom/z02in260.w"
                     &campo     = i-oper-fin
                     &campozoom = op-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-oper-fin V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-oper-fin IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-oper-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-oper-ini V-table-Win
ON F5 OF i-oper-ini IN FRAME f-main
DO:      
  ASSIGN i-ordem = ord-prod.nr-ord-prod.
  {include/zoomvar.i &prog-zoom = "inzoom/z02in260.w"
                     &campo     = i-oper-ini
                     &campozoom = op-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-oper-ini V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-oper-ini IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-req-dev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-req-dev V-table-Win
ON VALUE-CHANGED OF rs-req-dev IN FRAME f-main
DO:
  if input frame {&frame-name} rs-req-dev = 2 
  then do :
     {utp/ut-field.i mgind it-requisicao qt-a-devolver 1}
     assign fi-qt-requisita:label in frame {&frame-name} = trim (return-value).

     {utp/ut-field.i mgind requisicao dt-devol 1}
     assign da-data-requis:label in frame {&frame-name} = return-value.                      

     assign fi-qt-requisita:screen-value in frame {&frame-name} = string(ord-prod.qt-requisita).   
  end.     
  else do : 
     {utp/ut-liter.i Qtde_a_Requisitar mcp l}
     assign fi-qt-requisita:label in frame {&frame-name} = trim (return-value).                      

     {utp/ut-field.i mgind os-requis dt-requis 1}
     assign da-data-requis:label in frame {&frame-name} = return-value.     

     assign fi-qt-requisita:screen-value in frame {&frame-name} =
        if ord-prod.qt-ordem - ord-prod.qt-requisita > 0 
           then string(ord-prod.qt-ordem - ord-prod.qt-requisita)
           else string(0).
  end.     

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  {utp/ut-rtlbl.i mgind movto-estoq tipo-trans fi-label-retangulo} 

  {utp/ut-field.i mgind ord-prod qt-requisita 1}
  assign fi-qt-requisita:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind os-requis dt-requis 1}
  ASSIGN da-data-requis:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

  {utp/ut-field.i mgind item it-codigo 1}
  ASSIGN c-item-ini:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

  {utp/ut-field.i mgind deposito cod-depos 1}
  ASSIGN c-depos-ini:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

  {utp/ut-field.i mgind oper-ord op-codigo 1}
  ASSIGN i-oper-ini:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

  {utp/ut-field.i mgind ord-prod estado 1}
  ASSIGN cb-estado:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

  {utp/ut-liter.i Inicial * C}
  ASSIGN f-inicial              = RETURN-VALUE
         f-inicial:SCREEN-VALUE = RETURN-VALUE.

  {utp/ut-liter.i Final * C}
  ASSIGN f-final              = RETURN-VALUE
         f-final:SCREEN-VALUE = RETURN-VALUE.

  {utp/ut-rdset.i rs-req-dev *}       

  IF  c-item-ini:LOAD-MOUSE-POINTER("image/lupa.cur")  IN FRAME {&frame-name} THEN.
  IF  c-item-fin:LOAD-MOUSE-POINTER("image/lupa.cur")  IN FRAME {&frame-name} THEN.    
  IF  c-depos-ini:LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME {&frame-name} THEN.
  IF  c-depos-fin:LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME {&frame-name} THEN.
  IF  i-oper-ini:LOAD-MOUSE-POINTER("image/lupa.cur")  IN FRAME {&frame-name} THEN.  
  IF  i-oper-fin:LOAD-MOUSE-POINTER("image/lupa.cur")  IN FRAME {&frame-name} THEN.

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "ord-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-prod"}

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

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}

  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.  

  for each tt-requis:
      delete tt-requis.
  end.    

  for each tt-reservas:
      delete tt-reservas.
  end.

  for each tt-aloca:
      delete tt-aloca.
  end.

  run pi-recebe-tt-requis   in h-handle (input table tt-requis).  
  run pi-recebe-tt-reservas in h-handle (input table tt-reservas).
  run pi-recebe-tt-aloca    in h-handle (input table tt-aloca).

  do with frame {&frame-name}:  
     create tt-requis.
     assign tt-requis.cod-versao-integracao = 001
            tt-requis.tipo-trans       = input rs-req-dev
            tt-requis.nr-ord-prod      = ord-prod.nr-ord-prod
            tt-requis.quantidade       = input fi-qt-requisita
            tt-requis.data             = input da-data-requis
            tt-requis.item-ini         = input c-item-ini
            tt-requis.item-fim         = input c-item-fin
            tt-requis.deposito-ini     = input c-depos-ini
            tt-requis.deposito-fim     = input c-depos-fin
            tt-requis.op-codigo-ini    = input i-oper-ini
            tt-requis.op-codigo-fim    = input i-oper-fin
            tt-requis.procura-saldos   = l-busca-saldos
            tt-requis.carrega-reservas = no            
            tt-requis.prog-seg         = "cp0309"
            tt-requis.nro-docto        = string(ord-prod.nr-ord-prod)  
            tt-requis.serie-docto      = "".

  end.

  run pi-recebe-tt-requis in h-handle (input table tt-requis).

  run pi-valida-requis in h-handle (input  yes,
                                    input  ord-prod.nr-ord-prod,
                                    input  "cp",
                                    output c-erro,
                                    output c-texto).

  assign c-retorno = return-value.       

  if c-retorno = "nok" then do:
     case int (entry (1, c-erro)):

     end case.
  end.

  do i-cont = 1 to num-entries (c-erro):
     run utp/ut-msgs.p (input "show",
                        input int (entry (i-cont, c-erro)),
                        input entry (i-cont, c-texto)).
  end.

  if c-retorno = "nok" then return "adm-error".            

  for each tt-reservas:
      delete tt-reservas.
  end.

  for each tt-aloca:
      delete tt-aloca.
  end.

  run pi-recebe-tt-reservas in h-handle (input table tt-reservas).
  run pi-recebe-tt-aloca    in h-handle (input table tt-aloca).

  if not l-busca-saldos or 
     input frame {&frame-name} rs-req-dev = 2 then do:
     RUN cpp/cp0309a.w (INPUT h-handle).    
     assign c-retorno = return-value.
  end.
  else do:
       run pi-carrega-tt-reservas in h-handle.
       run utp/ut-acomp.p persistent set h-acomp.
       {utp/ut-liter.i Processando_Requisi‡äes *}
       run pi-inicializar in h-acomp ( Return-value ). 
       run pi-desabilita-cancela in h-acomp.

       &IF DEFINED(bf_man_204) &THEN
           IF l-usa-config THEN DO:
               RUN pi-ajusta-tt-reservas IN h-handle.
           END.
       &ENDIF

       run pi-processa-requis in h-handle (input table  tt-requis,
                                           input-output table tt-erro,
                                           input        yes).
       assign c-retorno = return-value.
       if valid-handle (h-acomp) then
          run pi-finalizar in h-acomp.
       find first tt-erro no-error.   
       if avail tt-erro then
          run cdp/cd0666.w (input table tt-erro).
  end.

  if c-retorno = "NOK" then
     return "ADM-ERROR".             

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.          

  /* Code placed here will execute AFTER standard behavior.    */  

  assign fi-qt-requisita = 0.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).   

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

  disable {&List-4} with frame {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/       

  /* Dispatch standard ADM method.                             */
  FIND item WHERE item.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.           
  IF AVAIL item THEN
     ASSIGN c-it-descricao = item.desc-item.    

  RUN dispatch IN THIS-PROCEDURE (input 'display-fields':U).

  IF AVAIL ord-prod THEN 
     ASSIGN cb-estado:SCREEN-VALUE in frame {&frame-name} = {ininc/i01in271.i 04 ord-prod.estado} .
  ELSE 
     ASSIGN cb-estado:SCREEN-VALUE in frame {&frame-name} = {ininc/i01in271.i 04 1}.

  ASSIGN l-ini-upd = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  def var c-handle as char no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ).

  IF l-usa-config THEN DO:
      FOR EACH tt-reserva-op-config:
          DELETE tt-reserva-op-config.
      END.
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  assign ord-prod.nr-ord-produ:sensitive in FRAME {&frame-name} = no
         da-data-requis:screen-value     in frame {&frame-name} = string(today)
         fi-qt-requisita:SCREEN-VALUE    IN FRAME {&frame-name} = 
            if input frame {&frame-name} rs-req-dev = 1 
            then
               IF ord-prod.qt-ordem - ord-prod.qt-requisita > 0 
                  THEN STRING(ord-prod.qt-ordem - ord-prod.qt-requisita)
                  ELSE STRING(0)
            else
               string(ord-prod.qt-requisita).      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*----------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  DO WITH FRAME {&frame-name}:
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cLista AS CHARACTER  NO-UNDO.
        assign cLista = {ininc/i01in271.i 03}.
            run utp/ut-lstit.p (input-output cLista).
        ASSIGN cb-estado:list-item-pairs = cLista.      
     &else
        ASSIGN cb-estado:list-items = {ininc/i01in271.i 03}. 
     &endif
  END. /* do with frame ... */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .  

  /* Code placed here will execute AFTER standard behavior.    */

  FIND FIRST param-global NO-LOCK NO-ERROR.
  FIND FIRST param-cp     NO-LOCK NO-ERROR.     
  ASSIGN ord-prod.conta-ordem:FORMAT IN FRAME {&frame-name} = param-global.formato-conta-contabil.      

  {utp/ut-liter.i Qtde_a_Requisitar mcp l}
  assign fi-qt-requisita:label in frame {&frame-name} = trim (return-value).

  ASSIGN l-usa-config = NO.

  &IF DEFINED(bf_man_204) &THEN

      FIND FIRST param-cp NO-LOCK NO-ERROR.

      &IF DEFINED(bf_man_206b) &THEN
          ASSIGN l-usa-config = param-cp.log-reserva-config.
      &ELSE
          ASSIGN l-usa-config = IF SUBSTRING(param-cp.char-2,12,1) = "2" THEN YES ELSE NO.
      &ENDIF

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

  /* Code placed here will execute AFTER standard behavior.    */  
  IF  AVAIL ord-prod THEN DO:
      ASSIGN gr-ord-prod = rowid(ord-prod). 
      FIND estabelec WHERE estabelec.cod-estabel = ord-prod.cod-estabel NO-LOCK NO-ERROR.
      IF AVAIL estabelec THEN
         ASSIGN gr-estabel = ROWID(estabelec).
      FIND item WHERE item.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.
      IF AVAIL item THEN
         ASSIGN gr-item = ROWID(item).              
  END.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parametros V-table-Win 
PROCEDURE pi-atualiza-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-busca-saldos as logical no-undo.

assign l-busca-saldos = p-busca-saldos.

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
def input parameter p-handle as handle no-undo.

assign h-handle = p-handle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-ordem V-table-Win 
PROCEDURE pi-valida-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 IF AVAIL ord-prod THEN DO:
     IF ord-prod.origem = "MV":U THEN DO:
        run utp/ut-msgs.p (input "show",
                           input 29505 ,
                           input ""    ).
        RUN Who-Is-The-Container IN adm-broker-hdl
                                   (INPUT this-procedure,
                                    OUTPUT c-handle).
        run pi-cancela in widget-handle(c-handle).
        return "adm-error":u.
     END.
  END.
run pi-valida-ordem in h-handle (input  yes,
                                 input  ord-prod.nr-ord-prod, 
                                 input  "cp",                                            
                                 output c-erro,
                                 output c-texto).           
assign c-retorno = return-value.
do i-cont = 1 to num-entries (c-erro):
   run utp/ut-msgs.p (input "show",
                      input int (entry (i-cont, c-erro)),
                      input entry (i-cont, c-texto)).
end.
return c-retorno.

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
  {src/adm/template/snd-list.i "ord-prod"}

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

  /* Include com os tratamentos necess rios … valida‡Æo antes que se 
     habilite os campos                                           */     
  {cpp/cp9100.i}

  if p-state = "update-begin":U AND l-ini-upd AND RETURN-VALUE <> 'ADM-ERROR':U THEN DO:

      ASSIGN l-ini-upd = NO.

      IF CAN-FIND(FIRST movto-mat
                  WHERE movto-mat.nr-ord-produ = ord-prod.nr-ord-produ
                    AND movto-mat.it-codigo    = ord-prod.it-codigo
                    AND movto-mat.esp-docto    = 1 /*aca*/  NO-LOCK) THEN DO:
      /*Caso a ordem possua algum movimento de acabado, pergunta se o usuario deseja visualizar os movimentos*/
         run utp/ut-msgs.p (input "show",
                            input 31680,
                            input "").
         IF RETURN-VALUE = "yes":U THEN DO:
             ASSIGN l-pag-movtos = YES.
             RUN cpp/cp0507.w.
         END.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

