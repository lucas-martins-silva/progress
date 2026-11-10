&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
          movmnt           PROGRESS
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
{include/i-prgvrs.i V11IN270 2.00.00.028} /*** "010028" 23/10/2024 17:34:00  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v11in270 MUT}
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
def new global shared var v-row-parent as rowid                   NO-UNDO.    
def new global shared var i-ordem      LIKE ord-manut.nr-ord-produ NO-UNDO.
def new global shared var h-acomp      as handle                  no-undo.

DEF NEW GLOBAL SHARED VAR gr-estabel   AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-deposito  AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-ord-manut AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-item      AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-ord-prod  AS rowid NO-UNDO.

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

{cdp/cdcfgmnt.i}
{cdp/cdcfgman.i}


&if defined (bf_mnt_ems203) &then
    {mip/miapi006.i}
    {mip/miapi006.i1}
&else
    {cpp/cpapi012.i}
    {cpp/cpapi012.i1}
&endif

{cdp/cd0666.i}
{cdp/cd9911.i}
{cdp/cdunif001.i} /*105 unifica‡Æo de conceitos*/
DEFINE VARIABLE dManut AS DATE      INITIAL TODAY NO-UNDO.
DEFINE VARIABLE cEstab AS CHARACTER INITIAL ""    NO-UNDO.
DEFINE VARIABLE cEmpre AS CHARACTER INITIAL ""    NO-UNDO.

DEFINE VARIABLE h-window-v11in270 AS HANDLE NO-UNDO.


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
&Scoped-define EXTERNAL-TABLES ord-manut
&Scoped-define FIRST-EXTERNAL-TABLE ord-manut


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-manut.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ord-manut.nr-ord-produ 
&Scoped-define ENABLED-TABLES ord-manut
&Scoped-define FIRST-ENABLED-TABLE ord-manut
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 RECT-36 RECT-37 
&Scoped-Define DISPLAYED-FIELDS ord-manut.nr-ord-produ ord-manut.sc-desp ~
ord-manut.ct-codigo ord-manut.sc-codigo ord-manut.cd-equipto ~
ord-manut.cd-tag ord-manut.dt-manut ord-manut.num-ord-inv 
&Scoped-define DISPLAYED-TABLES ord-manut
&Scoped-define FIRST-DISPLAYED-TABLE ord-manut
&Scoped-Define DISPLAYED-OBJECTS rs-req-dev c-cod-estabel c-desc-equipto ~
c-desc-tag da-data-requis cb-estado c-nr-docto c-sr-docto c-cod-unid-negoc ~
c-des-unid-negoc c-item-ini c-item-fin c-depos-ini c-depos-fin i-tarefa-ini ~
i-tarefa-fim fi-label-retangulo f-inicial f-final 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS rs-req-dev 
&Scoped-define ADM-ASSIGN-FIELDS rs-req-dev da-data-requis cb-estado ~
c-item-ini c-item-fin c-depos-ini c-depos-fin i-tarefa-ini i-tarefa-fim 
&Scoped-define ADM-MODIFY-FIELDS rs-req-dev da-data-requis c-item-ini ~
c-item-fin c-depos-ini c-depos-fin i-tarefa-ini i-tarefa-fim 
&Scoped-define List-4 da-data-requis c-item-ini c-item-fin c-depos-ini ~
c-depos-fin i-tarefa-ini i-tarefa-fim 

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
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-estabel LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R15 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-depos-fin AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-depos-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-unid-negoc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-equipto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tag AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-fin AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-docto AS CHARACTER FORMAT "X(16)":U 
     LABEL "N£mero do documento" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-sr-docto AS CHARACTER FORMAT "X(5)":U 
     LABEL "S‚rie do documento" 
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

DEFINE VARIABLE i-tarefa-fim AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE i-tarefa-ini AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE rs-req-dev AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Requisi‡Æo", 1,
"Devolu‡Æo", 2
     SIZE 43 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 1.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.75.

DEFINE RECTANGLE RECT-36
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 13.67.

DEFINE RECTANGLE RECT-37
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 3.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ord-manut.nr-ord-produ AT ROW 1.46 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     ord-manut.sc-desp AT ROW 1.46 COL 54.29 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     rs-req-dev AT ROW 3.75 COL 26 NO-LABEL
     c-cod-estabel AT ROW 5 COL 17 COLON-ALIGNED HELP
          ""
          LABEL "Estabelecimento":R15
     ord-manut.ct-codigo AT ROW 5 COL 45.29 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     ord-manut.sc-codigo AT ROW 5 COL 65.72 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     ord-manut.cd-equipto AT ROW 6 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     c-desc-equipto AT ROW 6 COL 34.29 COLON-ALIGNED NO-LABEL
     ord-manut.cd-tag AT ROW 7 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     c-desc-tag AT ROW 7.08 COL 34.29 COLON-ALIGNED NO-LABEL
     ord-manut.dt-manut AT ROW 8 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     da-data-requis AT ROW 8 COL 57.43 COLON-ALIGNED
     cb-estado AT ROW 9 COL 17 COLON-ALIGNED
     ord-manut.num-ord-inv AT ROW 9 COL 57.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     c-nr-docto AT ROW 10 COL 17 COLON-ALIGNED
     c-sr-docto AT ROW 10 COL 57.43 COLON-ALIGNED
     c-cod-unid-negoc AT ROW 11 COL 17 COLON-ALIGNED
     c-des-unid-negoc AT ROW 11 COL 22 COLON-ALIGNED NO-LABEL
     c-item-ini AT ROW 12.83 COL 23.43 COLON-ALIGNED
     c-item-fin AT ROW 12.83 COL 60.43 COLON-ALIGNED NO-LABEL
     c-depos-ini AT ROW 13.83 COL 23.43 COLON-ALIGNED
     c-depos-fin AT ROW 13.83 COL 60.43 COLON-ALIGNED NO-LABEL
     i-tarefa-ini AT ROW 14.83 COL 23.43 COLON-ALIGNED
     i-tarefa-fim AT ROW 14.83 COL 60.43 COLON-ALIGNED NO-LABEL
     fi-label-retangulo AT ROW 3 COL 19 COLON-ALIGNED NO-LABEL
     f-inicial AT ROW 12.04 COL 27.43 COLON-ALIGNED NO-LABEL
     f-final AT ROW 12.04 COL 64.43 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 3.25 COL 17
     RECT-3 AT ROW 1 COL 1
     RECT-36 AT ROW 2.71 COL 1
     RECT-37 AT ROW 12.33 COL 6.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ord-manut
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
         HEIGHT             = 15.38
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

/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME f-main
   NO-ENABLE LIKE = mgcad.estabelec.cod-estabel EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN c-cod-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-depos-fin IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR FILL-IN c-depos-ini IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR FILL-IN c-des-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-equipto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-tag IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-item-fin IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR FILL-IN c-item-ini IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR FILL-IN c-nr-docto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sr-docto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-estado IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ord-manut.cd-equipto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-tag IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.ct-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-data-requis IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR FILL-IN ord-manut.dt-manut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-final IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-inicial IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label-retangulo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-tarefa-fim IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR FILL-IN i-tarefa-ini IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR FILL-IN ord-manut.num-ord-inv IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET rs-req-dev IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN ord-manut.sc-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.sc-desp IN FRAME f-main
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


&Scoped-define SELF-NAME i-tarefa-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tarefa-fim V-table-Win
ON F5 OF i-tarefa-fim IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom = "inzoom/z01in273.w"
                     &campo     = i-tarefa-fim
                     &campozoom = cd-tarefa}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tarefa-fim V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-tarefa-fim IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-tarefa-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tarefa-ini V-table-Win
ON F5 OF i-tarefa-ini IN FRAME f-main
DO:      
  {include/zoomvar.i &prog-zoom = "inzoom/z01in273.w"
                     &campo     = i-tarefa-ini
                     &campozoom = cd-tarefa}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tarefa-ini V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-tarefa-ini IN FRAME f-main
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
     {utp/ut-field.i mgind requisicao dt-devol 1}
     assign da-data-requis:label in frame {&frame-name} = return-value.                      
  end.     
  else do : 
     {utp/ut-field.i mgind os-requis dt-requis 1}
     assign da-data-requis:label in frame {&frame-name} = return-value.     
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
 {utp/ut-rtlbl.i mgind movto-estoq tipo-trans fi-label-retangulo} 
  {utp/ut-rdset.i rs-req-dev *}

  find first param-mi no-lock no-error.

  do with frame {&frame-name}:
    {utp/ut-field.i mgind os-requis dt-requis 1}
    ASSIGN da-data-requis:LABEL = RETURN-VALUE.

    {utp/ut-field.i mgind estat-cc cod-estabel 1}
    assign c-cod-estabel:label = return-value.

    {utp/ut-liter.i Conta_Ordem}
    assign ord-manut.ct-codigo:label = return-value.

    {utp/ut-liter.i Centro_Custo}
    assign ord-manut.sc-desp:label = return-value.

   {utp/ut-field.i mgind item it-codigo 1}
    ASSIGN c-item-ini:LABEL = RETURN-VALUE.

    {utp/ut-field.i mgind deposito cod-depos 1}
    ASSIGN c-depos-ini:LABEL  = RETURN-VALUE.

    {utp/ut-field.i mgind ord-taref cd-tarefa 1}
    ASSIGN i-tarefa-ini:LABEL = RETURN-VALUE.

    {utp/ut-field.i mgind ord-manut estado 1}
    ASSIGN cb-estado:LABEL = RETURN-VALUE.

    IF l-usa-unid-negoc THEN DO:
        {utp/ut-liter.i "Unidade Neg¢cio" * 1}
        ASSIGN c-cod-unid-negoc:LABEL IN FRAME f-main  = TRIM(RETURN-VALUE).
    END.

    {utp/ut-liter.i Inicial * C}
    ASSIGN f-inicial              = RETURN-VALUE
           f-inicial:SCREEN-VALUE = RETURN-VALUE.

    {utp/ut-liter.i Final * C}
    ASSIGN f-final              = RETURN-VALUE
           f-final:SCREEN-VALUE = RETURN-VALUE.

    c-item-ini:LOAD-MOUSE-POINTER("image/lupa.cur").
    c-item-fin:LOAD-MOUSE-POINTER("image/lupa.cur").    
    c-depos-ini:LOAD-MOUSE-POINTER("image/lupa.cur").
    c-depos-fin:LOAD-MOUSE-POINTER("image/lupa.cur"). 
    i-tarefa-ini:LOAD-MOUSE-POINTER("image/lupa.cur").  
    i-tarefa-fim:LOAD-MOUSE-POINTER("image/lupa.cur").
  end.  



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
  {src/adm/template/row-list.i "ord-manut"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-manut"}

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
            tt-requis.nr-ord-prod      = FRAME {&frame-name} ord-manut.nr-ord-prod
            tt-requis.quantidade       = 1
            tt-requis.data             = input da-data-requis
            tt-requis.item-ini         = input c-item-ini
            tt-requis.item-fim         = input c-item-fin
            tt-requis.deposito-ini     = input c-depos-ini
            tt-requis.deposito-fim     = input c-depos-fin   
            tt-requis.op-codigo-ini    = input i-tarefa-ini
            tt-requis.op-codigo-fim    = input i-tarefa-fim         
            tt-requis.procura-saldos   = l-busca-saldos
            tt-requis.carrega-reservas = no            
            tt-requis.prog-seg         = "mi0306"
            tt-requis.nro-docto         = input c-nr-docto
            tt-requis.serie-docto         = input c-sr-docto.
  end.

  run pi-recebe-tt-requis in h-handle (input table tt-requis).


  run pi-valida-requis in h-handle (input  yes,
                                    input  INPUT FRAME {&frame-name} ord-manut.nr-ord-prod,
                                    input  "mi",
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
     ASSIGN h-window-v11in270 = ACTIVE-WINDOW
            h-window-v11in270:sensitive = no.
     RUN mip/mi0306a.w (INPUT h-handle).
     assign h-window-v11in270:sensitive = yes.
     assign c-retorno = return-value.
  end.
  else do:
       run pi-carrega-tt-reservas in h-handle.
       run utp/ut-acomp.p persistent set h-acomp.
       {utp/ut-liter.i Processando_Requisi‡äes *}
       run pi-inicializar in h-acomp ( Return-value ). 
       run pi-desabilita-cancela in h-acomp.
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

   assign c-sr-docto:sensitive in FRAME {&frame-name} = no
          c-nr-docto:sensitive in FRAME {&frame-name} = no.
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

  {cdp/cdcfgmnt.i}
  find first param-mi no-lock no-error.


  FIND equipto 
      WHERE equipto.cd-equipto = ord-manut.cd-equipto NO-LOCK NO-ERROR.           
      ASSIGN c-desc-equipto = if avail equipto then equipto.descricao else "":U.    
  FIND tag 
      WHERE tag.cd-tag = ord-manut.cd-tag NO-LOCK NO-ERROR.           
      ASSIGN c-desc-tag = if avail tag then tag.descricao else "":U.    

  RUN dispatch IN THIS-PROCEDURE (input 'display-fields':U).

  IF AVAIL ord-manut THEN 
      find ord-prod of ord-manut no-lock no-error.

  IF AVAIL ord-manut AND AVAIL ord-prod THEN 
     ASSIGN cb-estado:SCREEN-VALUE in frame {&frame-name} = {ininc/i01in271.i 04 ord-manut.estado}
            c-cod-estabel:screen-value in frame {&frame-name} = &if defined(bf_mnt_ems203) &then ord-manut.cod-estabel &else ord-prod.cod-estabel &endif.

  ELSE 
     ASSIGN cb-estado:SCREEN-VALUE in frame {&frame-name} = {ininc/i01in271.i 04 1}  
                        c-cod-estabel:screen-value in frame {&frame-name} = "".

  if avail ord-manut and ord-manut.cd-equipto <> ' ' then
     if  avail param-mi and param-mi.formato-cd-equipto <> ' ' then
        assign ord-manut.cd-equipto:format in frame {&frame-name} = param-mi.formato-cd-equipto.

  if  avail param-mi and param-mi.formato-cd-tag <> ' ' then
     assign ord-manut.cd-tag:format in frame {&frame-name} = param-mi.formato-cd-tag.

  /*if NOT ADM-NEW-RECORD and c-nr-docto:sensitive in frame {&frame-name} = yes  then
 *         assign c-nr-docto:screen-value in frame {&frame-name} = STRING(ord-manut.nr-ord-produ). 
 * */

  IF l-usa-unid-negoc THEN DO:
      &IF DEFINED(bf_mnt_ems207) &THEN
          FOR FIRST unid-negoc WHERE ord-manut.cod-unid-negoc = unid-negoc.cod-unid-negoc NO-LOCK:
          END.
              ASSIGN c-cod-unid-negoc:SCREEN-VALUE = IF AVAIL unid-negoc THEN unid-negoc.cod-unid-negoc ELSE ""
                     c-des-unid-negoc:SCREEN-VALUE = IF AVAIL unid-negoc THEN unid-negoc.des-unid-negoc ELSE "".
      &ELSEIF DEFINED(bf_mnt_ems206b) &THEN
          FOR FIRST unid-negoc WHERE SUBSTRING(ord-manut.char-1,19,3) = unid-negoc.cod-unid-negoc NO-LOCK:
          END.
          ASSIGN c-cod-unid-negoc:SCREEN-VALUE = IF AVAIL unid-negoc THEN unid-negoc.cod-unid-negoc ELSE ""
                 c-des-unid-negoc:SCREEN-VALUE = IF AVAIL unid-negoc THEN unid-negoc.des-unid-negoc ELSE "".
      &ENDIF
  END.

    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    ASSIGN dManut = INPUT FRAME {&frame-name} ord-manut.dt-manut
           cEstab = INPUT FRAME {&frame-name} c-cod-estabel.

    FOR FIRST estabelec WHERE estabelec.cod-estabel = cEstab NO-LOCK:
        ASSIGN cEmpre = estabelec.ep-codigo.     
    END.
        
    RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT cEmpre,               /* EMPRESA EMS2 */
                                                   INPUT "",                   /* PLANO CCUSTO */
                                                   INPUT dManut,               /* DATA DE TRANSACAO */
                                                   OUTPUT p_cod_format_ccusto, /* FORMATO CCUSTO */
                                                   OUTPUT TABLE tt_log_erro).  /* ERROS */
    
    
    RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT cEmpre,
                                                       INPUT "",
                                                       INPUT dManut,
                                                       OUTPUT p_cod_format_cta_ctbl,
                                                       OUTPUT TABLE tt_log_erro).
    
    assign ord-manut.sc-desp:FORMAT   IN FRAME {&frame-name} = IF ord-manut.sc-desp:SCREEN-VALUE   IN FRAME {&frame-name} <> "" THEN p_cod_format_ccusto   ELSE "X(20)"
           ord-manut.sc-codigo:FORMAT IN FRAME {&frame-name} = IF ord-manut.sc-codigo:SCREEN-VALUE IN FRAME {&frame-name} <> "" THEN p_cod_format_ccusto   ELSE "X(20)"
           ord-manut.ct-codigo:FORMAT IN FRAME {&frame-name} = IF ord-manut.ct-codigo:SCREEN-VALUE IN FRAME {&frame-name} <> "" THEN p_cod_format_cta_ctbl ELSE "X(20)".
    
    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE OBJECT h_api_ccusto.
    END.
    
    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE OBJECT h_api_cta_ctbl.
    END.




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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ).

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

 assign ord-manut.nr-ord-produ:sensitive in FRAME {&frame-name} = no
     da-data-requis:screen-value     in frame {&frame-name} = string(today).

 assign c-sr-docto:sensitive in FRAME {&frame-name} = yes
        c-nr-docto:sensitive in FRAME {&frame-name} = yes.

if NOT ADM-NEW-RECORD and c-nr-docto:sensitive in frame {&frame-name}  then
        assign c-nr-docto:screen-value in frame {&frame-name} = STRING(FRAME {&frame-name} ord-manut.nr-ord-prod). 

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
         DEFINE VARIABLE c-lista AS CHARACTER  NO-UNDO.
         ASSIGN c-lista = {ininc/i01in271.i 03}.
         run utp/ut-lstit.p (input-output c-lista).
         ASSIGN cb-estado:LIST-ITEM-PAIRS = c-lista.      
     &else
         ASSIGN cb-estado:list-items = {ininc/i01in271.i 03}. 
     &endif
  END. /* do with frame ... */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .  

  /*NÆo mostrar unidade de neg¢cio*/
  IF l-usa-unid-negoc = NO THEN DO:
      ASSIGN c-cod-unid-negoc:VISIBLE IN FRAME {&FRAME-NAME} = NO 
             c-des-unid-negoc:VISIBLE IN FRAME {&FRAME-NAME} = NO.
  END.

  /* Code placed here will execute AFTER standard behavior.    */
      
  FIND FIRST param-global NO-LOCK NO-ERROR.
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
 /* find ord-manut where ord-manut.nr-ord-produ =
 *        input frame {&frame-name} ord-manut.nr-ord-produ no-lock no-error. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  IF  AVAIL ord-manut AND AVAIL ord-prod THEN DO:
      ASSIGN gr-ord-manut = rowid(ord-manut).

      FIND estabelec WHERE estabelec.cod-estabel = &if defined(bf_mnt_ems203) &then ord-manut.cod-estabel &else ord-prod.cod-estabel &endif NO-LOCK NO-ERROR.
      IF AVAIL estabelec THEN
         ASSIGN gr-estabel = ROWID(estabelec).
      FIND item WHERE item.it-codigo = param-mi.it-codigo NO-LOCK NO-ERROR.
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

&if defined (bf_mnt_calib) &then
    FIND FIRST ord-manut
        WHERE ord-manut.nr-ord-produ = ord-prod.nr-ord-produ NO-LOCK NO-ERROR.
    IF AVAIL ord-manut  THEN DO:
        IF &IF DEFINED (bf_mnt_ems205) &THEN
            param-global.log-modul-calib 
        &else
            substr(param-global.char-2,100,1) = "2" 
        &endif
        &IF DEFINED (bf_mnt_ems208) &THEN
          AND ord-manut.tp-manut = 3
        &else
          AND ord-manut.dec-1 = 3 
        &endif
        AND ord-manut.estado = 1 THEN DO:
            {utp/ut-table.i mgind ord-prod 1}
            run utp/ut-msgs.p("show", 28075, return-value).    /* ordem de calibracao nao liberada*/
            return 'ADM-ERROR':U.
        END.
    END.
&endif

run pi-valida-ordem in h-handle (input  yes,
                                 input  INPUT FRAME {&frame-name} ord-manut.nr-ord-prod,
                                 input  "mi",
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
  {src/adm/template/snd-list.i "ord-manut"}

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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

