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
{include/i-prgvrs.i IM0994-V01 2.00.00.016 } /*** "010016" 21/03/2025 09:24:36  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0994-v01 MIM}
&ENDIF



{cdp/cdcfgman.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
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

/*
{include/i-vrtab.i docum-est}
{include/i-vrtab.i emitente}
{include/i-vrtab.i natur-oper}
*/

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

DEF TEMP-TABLE tt-docum-est-cex1 NO-UNDO
    FIELD mark AS CHAR FORMAT "X(1)"
    FIELD nro-docto LIKE docum-est-cex.nro-docto
    FIELD cod-desp  LIKE docum-est-cex.cod-desp
    FIELD desc-desp LIKE desp-imp.descricao
    FIELD val-desp  LIKE docum-est-cex.val-desp
    FIELD r-rowid   AS ROWID.

DEF TEMP-TABLE tt-docum-est-cex2 NO-UNDO LIKE tt-docum-est-cex1
    FIELD r-docto   AS ROWID.

DEF TEMP-TABLE tt-item-doc-est-cex1 NO-UNDO
    FIELD nro-docto LIKE docum-est-cex.nro-docto
    FIELD cod-desp  LIKE docum-est-cex.cod-desp
    FIELD sequencia LIKE item-doc-est.sequencia
    FIELD desc-desp LIKE desp-imp.descricao
    FIELD val-desp  LIKE docum-est-cex.val-desp
    FIELD r-rowid     AS ROWID
    FIELD r-docto-cex AS ROWID
    FIELD r-item-doc  AS ROWID.

DEFINE VARIABLE cItemDespesa AS CHARACTER   NO-UNDO.

DEFINE VARIABLE r-rw         AS ROWID NO-UNDO.
DEFINE VARIABLE l-iterar        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-nro-docto-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro-docto-fim AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dt-emiss-ini    AS DATE        NO-UNDO.
DEFINE VARIABLE dt-emiss-fim    AS DATE        NO-UNDO.
DEFINE VARIABLE i-cod-desp-ini  AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-desp-fim  AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-ok            AS LOGICAL     NO-UNDO.

DEFINE VARIABLE i-inc-seq       AS INTEGER     NO-UNDO.

DEFINE VARIABLE h-bocx090 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx100 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin176 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin292 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boec022 AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-erro    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-seq-aux AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
{cxbo/bocx090.i tt-docum-est-cex}
{cxbo/bocx100.i tt-item-doc-est-cex}
{inbo/boin176.i tt-item-doc-est}
{cdp/cd1234.i}
{method/dbotterr.i}  /* RowErrors */

{cdp/cd0666.i}


/*Vai pra BO*/
{cdp/cd4300.i3}  /*Vari†veis para o cd4300.i4 */
{rep/re1001b.i50} /*Vari†veis para o re1001b.i51*/

DEFINE VARIABLE de-sum-1 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-sum-2 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-sum-3 AS DECIMAL     NO-UNDO.

DEFINE VARIABLE de-valor LIKE item-doc-est-cex.val-desp NO-UNDO.
DEFINE VARIABLE c-lbl-docto-desp AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-process        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-docto          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desp           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rateio         AS CHARACTER   NO-UNDO.

DEF BUFFER bf-item-doc-est-cex FOR item-doc-est-cex.
DEF BUFFER bf-docum-est-cex FOR docum-est-cex.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main
&Scoped-define BROWSE-NAME brDespesa1

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES docum-est
&Scoped-define FIRST-EXTERNAL-TABLE docum-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR docum-est.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-docum-est-cex1 tt-docum-est-cex2 ~
tt-item-doc-est-cex1

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE brDespesa1                                    */
&Scoped-define FIELDS-IN-QUERY-brDespesa1 tt-docum-est-cex1.nro-docto tt-docum-est-cex1.cod-desp tt-docum-est-cex1.desc-desp tt-docum-est-cex1.val-desp   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDespesa1   
&Scoped-define SELF-NAME brDespesa1
&Scoped-define QUERY-STRING-brDespesa1 FOR EACH tt-docum-est-cex1  NO-LOCK
&Scoped-define OPEN-QUERY-brDespesa1 OPEN QUERY {&SELF-NAME} FOR EACH tt-docum-est-cex1  NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brDespesa1 tt-docum-est-cex1
&Scoped-define FIRST-TABLE-IN-QUERY-brDespesa1 tt-docum-est-cex1


/* Definitions for BROWSE brDespesa2                                    */
&Scoped-define FIELDS-IN-QUERY-brDespesa2 tt-docum-est-cex2.nro-docto tt-docum-est-cex2.cod-desp tt-docum-est-cex2.desc-desp tt-docum-est-cex2.val-desp   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDespesa2   
&Scoped-define SELF-NAME brDespesa2
&Scoped-define QUERY-STRING-brDespesa2 FOR EACH tt-docum-est-cex2  NO-LOCK
&Scoped-define OPEN-QUERY-brDespesa2 OPEN QUERY {&SELF-NAME} FOR EACH tt-docum-est-cex2  NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brDespesa2 tt-docum-est-cex2
&Scoped-define FIRST-TABLE-IN-QUERY-brDespesa2 tt-docum-est-cex2


/* Definitions for BROWSE brItem1                                       */
&Scoped-define FIELDS-IN-QUERY-brItem1 tt-item-doc-est-cex1.nro-docto tt-item-doc-est-cex1.sequencia tt-item-doc-est-cex1.cod-desp tt-item-doc-est-cex1.desc-desp tt-item-doc-est-cex1.val-desp   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brItem1   
&Scoped-define SELF-NAME brItem1
&Scoped-define QUERY-STRING-brItem1 FOR EACH tt-item-doc-est-cex1  NO-LOCK       BY tt-item-doc-est-cex1.nro-docto       BY tt-item-doc-est-cex1.sequencia       BY tt-item-doc-est-cex1.cod-desp
&Scoped-define OPEN-QUERY-brItem1 OPEN QUERY {&SELF-NAME} FOR EACH tt-item-doc-est-cex1  NO-LOCK       BY tt-item-doc-est-cex1.nro-docto       BY tt-item-doc-est-cex1.sequencia       BY tt-item-doc-est-cex1.cod-desp.
&Scoped-define TABLES-IN-QUERY-brItem1 tt-item-doc-est-cex1
&Scoped-define FIRST-TABLE-IN-QUERY-brItem1 tt-item-doc-est-cex1


/* Definitions for FRAME f-main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS docum-est.nro-docto docum-est.mo-codigo 
&Scoped-define ENABLED-TABLES docum-est
&Scoped-define FIRST-ENABLED-TABLE docum-est
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 brDespesa1 bt-Marca ~
bt-todos bt-selecao btConciliacao btDesfaz brItem1 brDespesa2 bt-modificar ~
bt-impostos rd-item-despesa fi-despesas fi-fatura fi-visualiza 
&Scoped-Define DISPLAYED-FIELDS docum-est.cod-emitente docum-est.nro-docto ~
docum-est.mo-codigo 
&Scoped-define DISPLAYED-TABLES docum-est
&Scoped-define FIRST-DISPLAYED-TABLE docum-est
&Scoped-Define DISPLAYED-OBJECTS fi-emitente fi-moeda de-tot-1 de-tot-2 ~
rd-item-despesa fi-despesas fi-fatura fi-visualiza 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS docum-est.cod-emitente 

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
DEFINE BUTTON bt-impostos 
     LABEL "Impostos" 
     SIZE 10 BY .88.

DEFINE BUTTON bt-Marca 
     LABEL "Marca" 
     SIZE 10 BY .88.

DEFINE BUTTON bt-modificar 
     LABEL "&Modificar" 
     SIZE 10 BY .88.

DEFINE BUTTON bt-selecao 
     LABEL "Seleá∆o" 
     SIZE 10 BY .88.

DEFINE BUTTON bt-todos 
     LABEL "Todos" 
     SIZE 10 BY .88.

DEFINE BUTTON btConciliacao 
     IMAGE-UP FILE "image\im-down2":U
     LABEL "Button 1" 
     SIZE 10 BY .88.

DEFINE BUTTON btDesfaz 
     IMAGE-UP FILE "image\im-up2":U
     LABEL "Button 2" 
     SIZE 10 BY .88.

DEFINE VARIABLE de-tot-1 AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 16.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-tot-2 AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 16.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-despesas AS CHARACTER FORMAT "X(256)":U INITIAL "Despesas" 
      VIEW-AS TEXT 
     SIZE 15 BY .63 NO-UNDO.

DEFINE VARIABLE fi-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fatura AS CHARACTER FORMAT "X(256)":U INITIAL "Faturas" 
      VIEW-AS TEXT 
     SIZE 15 BY .5 NO-UNDO.

DEFINE VARIABLE fi-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-visualiza AS CHARACTER FORMAT "x(12)":U 
      VIEW-AS TEXT 
     SIZE 7.14 BY .67 NO-UNDO.

DEFINE VARIABLE rd-item-despesa AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Despesas", 1,
"Itens", 2
     SIZE 23 BY .75
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.72 BY 1.38.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.29 BY 5.17.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.29 BY 5.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDespesa1 FOR 
      tt-docum-est-cex1 SCROLLING.

DEFINE QUERY brDespesa2 FOR 
      tt-docum-est-cex2 SCROLLING.

DEFINE QUERY brItem1 FOR 
      tt-item-doc-est-cex1 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDespesa1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDespesa1 V-table-Win _FREEFORM
  QUERY brDespesa1 NO-LOCK DISPLAY
      tt-docum-est-cex1.nro-docto
      tt-docum-est-cex1.cod-desp
      tt-docum-est-cex1.desc-desp
      tt-docum-est-cex1.val-desp
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 87 BY 4.54 ROW-HEIGHT-CHARS .6.

DEFINE BROWSE brDespesa2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDespesa2 V-table-Win _FREEFORM
  QUERY brDespesa2 NO-LOCK DISPLAY
      tt-docum-est-cex2.nro-docto
      tt-docum-est-cex2.cod-desp
      tt-docum-est-cex2.desc-desp
      tt-docum-est-cex2.val-desp
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 87 BY 4.54 ROW-HEIGHT-CHARS .6.

DEFINE BROWSE brItem1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brItem1 V-table-Win _FREEFORM
  QUERY brItem1 NO-LOCK DISPLAY
      tt-item-doc-est-cex1.nro-docto
      tt-item-doc-est-cex1.sequencia     
      tt-item-doc-est-cex1.cod-desp
      tt-item-doc-est-cex1.desc-desp
      tt-item-doc-est-cex1.val-desp
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 87 BY 4.54 ROW-HEIGHT-CHARS .6.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     docum-est.cod-emitente AT ROW 1.21 COL 10.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     fi-emitente AT ROW 1.21 COL 19.57 COLON-ALIGNED NO-LABEL
     docum-est.nro-docto AT ROW 1.21 COL 52.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.72 BY .88
     docum-est.mo-codigo AT ROW 1.21 COL 74.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     fi-moeda AT ROW 1.21 COL 78.43 COLON-ALIGNED NO-LABEL
     brDespesa1 AT ROW 3.08 COL 1.57
     bt-Marca AT ROW 8.08 COL 1 HELP
          "Marca os itens"
     bt-todos AT ROW 8.08 COL 11 HELP
          "Marca todos os itens"
     bt-selecao AT ROW 8.08 COL 21 HELP
          "Gera/Seleciona os itens"
     btConciliacao AT ROW 8.08 COL 37 HELP
          "Seleciona os itens do remito"
     btDesfaz AT ROW 8.08 COL 46.86 HELP
          "Exclui item da fatura"
     de-tot-1 AT ROW 8.08 COL 70.43 COLON-ALIGNED
     brItem1 AT ROW 10 COL 1.72
     brDespesa2 AT ROW 10 COL 1.72
     de-tot-2 AT ROW 14.92 COL 70.43 COLON-ALIGNED
     bt-modificar AT ROW 14.96 COL 1 HELP
          "Modifica item selecionado"
     bt-impostos AT ROW 14.96 COL 11 HELP
          "Impostos"
     rd-item-despesa AT ROW 15.04 COL 38 NO-LABEL
     fi-despesas AT ROW 2.42 COL 3.29 COLON-ALIGNED NO-LABEL
     fi-fatura AT ROW 9.29 COL 3.29 COLON-ALIGNED NO-LABEL
     fi-visualiza AT ROW 15.04 COL 27.43 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 2.75 COL 1
     RECT-3 AT ROW 9.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.docum-est
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
         HEIGHT             = 15.21
         WIDTH              = 88.86.
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
/* BROWSE-TAB brDespesa1 fi-moeda f-main */
/* BROWSE-TAB brItem1 de-tot-1 f-main */
/* BROWSE-TAB brDespesa2 brItem1 f-main */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN docum-est.cod-emitente IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN de-tot-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-tot-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDespesa1
/* Query rebuild information for BROWSE brDespesa1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-docum-est-cex1  NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Query            is NOT OPENED
*/  /* BROWSE brDespesa1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDespesa2
/* Query rebuild information for BROWSE brDespesa2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-docum-est-cex2  NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Query            is NOT OPENED
*/  /* BROWSE brDespesa2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brItem1
/* Query rebuild information for BROWSE brItem1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-item-doc-est-cex1  NO-LOCK
      BY tt-item-doc-est-cex1.nro-docto
      BY tt-item-doc-est-cex1.sequencia
      BY tt-item-doc-est-cex1.cod-desp.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Query            is NOT OPENED
*/  /* BROWSE brItem1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME brDespesa1
&Scoped-define SELF-NAME brDespesa1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDespesa1 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF brDespesa1 IN FRAME f-main
DO:
    RUN piSelecionaLinha (INPUT 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDespesa1 V-table-Win
ON ROW-DISPLAY OF brDespesa1 IN FRAME f-main
DO:
  IF tt-docum-est-cex1.mark = "*":U THEN DO:
     ASSIGN tt-docum-est-cex1.nro-docto:FONT IN BROWSE brDespesa1 = 0
            tt-docum-est-cex1.cod-desp :FONT = 0
            tt-docum-est-cex1.desc-desp:FONT = 0
            tt-docum-est-cex1.val-desp :FONT = 0.
  END.
  ELSE DO:
     ASSIGN tt-docum-est-cex1.nro-docto:FONT IN BROWSE brDespesa1 = ?
            tt-docum-est-cex1.cod-desp :FONT = ?
            tt-docum-est-cex1.desc-desp:FONT = ?
            tt-docum-est-cex1.val-desp :FONT = ?.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDespesa1 V-table-Win
ON VALUE-CHANGED OF brDespesa1 IN FRAME f-main
DO:
   RUN piMudaLabel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDespesa2
&Scoped-define SELF-NAME brDespesa2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDespesa2 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF brDespesa2 IN FRAME f-main
DO:
  RUN piSelecionaLinha (INPUT 2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDespesa2 V-table-Win
ON ROW-DISPLAY OF brDespesa2 IN FRAME f-main
DO:
    IF tt-docum-est-cex2.mark = "*":U THEN DO:
       ASSIGN tt-docum-est-cex2.nro-docto:FONT IN BROWSE brDespesa2 = 0
              tt-docum-est-cex2.cod-desp :FONT = 0
              tt-docum-est-cex2.desc-desp:FONT = 0
              tt-docum-est-cex2.val-desp :FONT = 0.
    END.
    ELSE DO:
       ASSIGN tt-docum-est-cex2.nro-docto:FONT IN BROWSE brDespesa2 = ?
              tt-docum-est-cex2.cod-desp :FONT = ?
              tt-docum-est-cex2.desc-desp:FONT = ?
              tt-docum-est-cex2.val-desp :FONT = ?.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-impostos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-impostos V-table-Win
ON CHOOSE OF bt-impostos IN FRAME f-main /* Impostos */
DO:
  IF INPUT FRAME {&frame-name} rd-item-despesa = 1 THEN DO:
      IF AVAIL tt-docum-est-cex2 THEN DO:
          {&WINDOW-NAME}:SENSITIVE = NO.
          RUN imp/im0994c.w (INPUT tt-docum-est-cex2.r-docto,
                             OUTPUT l-ok).
          {&WINDOW-NAME}:SENSITIVE = YES.
      END.
  END.
  ELSE DO:
      IF AVAIL tt-item-doc-est-cex1 THEN DO:
          FIND FIRST tt-docum-est-cex2
               WHERE tt-docum-est-cex2.r-rowid = tt-item-doc-est-cex1.r-docto-cex NO-ERROR.
          IF AVAIL tt-docum-est-cex2 THEN DO:
             {&WINDOW-NAME}:SENSITIVE = NO.
             RUN imp/im0994c.w (INPUT tt-docum-est-cex2.r-docto,
                                OUTPUT l-ok).
             {&WINDOW-NAME}:SENSITIVE = YES.
          END.
      END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-Marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-Marca V-table-Win
ON CHOOSE OF bt-Marca IN FRAME f-main /* Marca */
DO:
    RUN piSelecionaLinha (INPUT 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-modificar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modificar V-table-Win
ON CHOOSE OF bt-modificar IN FRAME f-main /* Modificar */
DO:
  IF AVAIL tt-docum-est-cex2 THEN DO:
      {&WINDOW-NAME}:SENSITIVE = NO.
      RUN imp/im0994n.w (INPUT tt-docum-est-cex2.r-rowid,
                         INPUT rowid(docum-est),
                         OUTPUT de-valor,
                         OUTPUT l-ok).
      {&WINDOW-NAME}:SENSITIVE = YES.
      IF l-ok THEN DO:
         RUN piRateioValor (INPUT tt-docum-est-cex2.r-rowid,
                            INPUT de-valor).
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-selecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-selecao V-table-Win
ON CHOOSE OF bt-selecao IN FRAME f-main /* Seleá∆o */
DO:

    RUN imp/im0994b.w (INPUT-OUTPUT c-nro-docto-ini,
                       INPUT-OUTPUT c-nro-docto-fim,
                       INPUT-OUTPUT dt-emiss-ini,
                       INPUT-OUTPUT dt-emiss-fim,
                       INPUT-OUTPUT i-cod-desp-ini, 
                       INPUT-OUTPUT i-cod-desp-fim, 
                       INPUT (trim(substring(docum-est.char-2,235,1)) = "1":U), /* mostra despesa ou n∆o */
                       OUTPUT l-ok).
    IF  l-ok THEN DO:
        IF  trim(substring(docum-est.char-2,235,1)) = "1":U THEN
            RUN piCarregaDespesaAduana.
        ELSE
            RUN piCarregaDespesa1.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todos V-table-Win
ON CHOOSE OF bt-todos IN FRAME f-main /* Todos */
DO:
    if available tt-docum-est-cex1 then do:
        assign r-rw     = rowid(tt-docum-est-cex1)
               de-sum-1 = 0.
        {utp/ut-liter.i Todos * r}
        if bt-todos:label in frame {&frame-name} = return-value then do:
            for each tt-docum-est-cex1:
                ASSIGN tt-docum-est-cex1.mark = "*":U.

                    ASSIGN de-sum-1 = de-sum-1 + tt-docum-est-cex1.val-desp.

                {utp/ut-liter.i Desmarca * r}
                assign bt-marca:label in frame {&frame-name} = return-value.
                {utp/ut-liter.i Nenhum * r}
                assign bt-todos:label in frame {&frame-name} = return-value.
            end.
        end.
        else do:
            for each tt-docum-est-cex1:
                assign tt-docum-est-cex1.mark = "".
                {utp/ut-liter.i Marca * r}
                assign bt-marca:label in frame {&frame-name} = return-value.
                {utp/ut-liter.i Todos * r}
                assign bt-todos:label in frame {&frame-name} = return-value.
            end.
        end.        
        DISP de-sum-1 @ de-tot-1 WITH FRAME {&FRAME-NAME}.
        {&OPEN-QUERY-brDespesa1}
        reposition brDespesa1 to rowid r-rw.
    end.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConciliacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConciliacao V-table-Win
ON CHOOSE OF btConciliacao IN FRAME f-main /* Button 1 */
DO:
    IF trim(substring(docum-est.char-2,235,1)) = "1":U THEN
        RUN piConciliacaoAduana.
    ELSE
    DO:
      ASSIGN l-erro    = NO
             i-seq-aux = 1.
    
      DO TRANSACTION ON ERROR UNDO, LEAVE
                     ON STOP  UNDO, LEAVE:
    
          RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
          {utp/ut-liter.i Processando *}
          RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).
          RUN pi-desabilita-cancela IN h-acomp.
    
          RUN cxbo/bocx090.p PERSISTENT SET h-bocx090.
          RUN cxbo/bocx100.p PERSISTENT SET h-bocx100.
          RUN inbo/boin176.p PERSISTENT SET h-boin176.
          
          RUN inbo/boin292.p PERSISTENT SET h-boin292.
          RUN openQueryStatic IN h-boin292 (INPUT "Main":U).
          RUN goToKey         IN h-boin292  (INPUT c-seg-usuario).
          RUN getIntField     IN h-boin292  (INPUT "inc-seq":U, OUTPUT i-inc-seq).
          DELETE PROCEDURE h-boin292.
        
          EMPTY TEMP-TABLE tt-erro.
    
          blk-for:
          FOR EACH tt-docum-est-cex1
             WHERE tt-docum-est-cex1.mark = "*":U:
    
              RUN pi-acompanhar IN h-acomp (INPUT c-lbl-docto-desp + ": ":U + tt-docum-est-cex1.nro-docto + "/":U + STRING(tt-docum-est-cex1.cod-desp)).
    
              FIND FIRST docum-est-cex 
                   WHERE ROWID(docum-est-cex) = tt-docum-est-cex1.r-rowid 
                   NO-LOCK NO-ERROR. 
              IF AVAIL docum-est-cex THEN DO:
    
                  /*Validacao para nao deixar cadastrar mais de um documento (docum-est-cex) para o mesmo "docum-est"*/
                  FOR EACH item-doc-est-cex NO-LOCK OF docum-est-cex:
                      IF CAN-FIND(FIRST item-doc-est NO-LOCK 
                                  WHERE item-doc-est.serie-docto   = docum-est.serie-docto 
                                    AND item-doc-est.nro-docto     = docum-est.nro-docto   
                                    AND item-doc-est.cod-emitente  = docum-est.cod-emitente
                                    AND item-doc-est.nat-operacao  = docum-est.nat-operacao
                                    AND item-doc-est.sequencia     = item-doc-est-cex.sequencia
                                    AND (item-doc-est.serie-comp  <> docum-est-cex.serie-docto OR 
                                         item-doc-est.nro-comp    <> docum-est-cex.nro-docto   OR 
                                         item-doc-est.fornec-comp <> docum-est-cex.cod-emitente) ) THEN DO:
                          FIND FIRST item-doc-est NO-LOCK 
                               WHERE item-doc-est.serie-docto   = docum-est.serie-docto 
                                 AND item-doc-est.nro-docto     = docum-est.nro-docto   
                                 AND item-doc-est.cod-emitente  = docum-est.cod-emitente
                                 AND item-doc-est.nat-operacao  = docum-est.nat-operacao
                                 AND item-doc-est.sequencia     = item-doc-est-cex.sequencia
                                 AND (item-doc-est.serie-comp  <> docum-est-cex.serie-docto OR 
                                      item-doc-est.nro-comp    <> docum-est-cex.nro-docto   OR 
                                      item-doc-est.fornec-comp <> docum-est-cex.cod-emitente) NO-ERROR.
                          RUN piCriaErro2 (INPUT 34489,
                                           INPUT STRING(item-doc-est-cex.cod-desp) + "~~":U + item-doc-est.nro-docto,
                                           INPUT "":U).
                          NEXT blk-for.
                      END.
                  END.
                  
                  
                  
                  /*Cria o documento*/
                  EMPTY TEMP-TABLE rowErrors.
                  EMPTY TEMP-TABLE tt-docum-est-cex.
                  
                  CREATE tt-docum-est-cex.
                  BUFFER-COPY docum-est-cex EXCEPT serie-docto 
                                                   nro-docto 
                                                   cod-emitente 
                                                   nat-operacao 
                                                   TO tt-docum-est-cex.
                  ASSIGN tt-docum-est-cex.serie-docto  = docum-est.serie-docto 
                         tt-docum-est-cex.nro-docto    = docum-est.nro-docto   
                         tt-docum-est-cex.cod-emitente = docum-est.cod-emitente
                         tt-docum-est-cex.nat-operacao = docum-est.nat-operacao
                         tt-docum-est-cex.int-1        = 2 /* N∆o Conciliado */
                         tt-docum-est-cex.r-rowid      = ROWID(docum-est-cex).
    
                  RUN openQueryStatic in h-bocx090 (input "Main":U).
                  RUN setRecord IN h-bocx090 (INPUT TABLE tt-docum-est-cex).
                  RUN emptyRowErrors IN h-bocx090.
                  RUN CreateRecord IN h-bocx090.
                  IF RETURN-VALUE = "NOK":U THEN DO:
                     RUN getRowErrors IN h-bocx090 (OUTPUT TABLE RowErrors).
                     RUN piCriaErro (INPUT TABLE RowErrors, INPUT "bocx090":U).
                     NEXT blk-for.
                  END.
                  /*Cria o documento*/
    
    
                  FOR EACH item-doc-est-cex
                     WHERE item-doc-est-cex.serie-docto        = docum-est-cex.serie-docto       
                       AND item-doc-est-cex.nro-docto    = docum-est-cex.nro-docto   
                       AND item-doc-est-cex.cod-emitente = docum-est-cex.cod-emitente
                       AND item-doc-est-cex.nat-operacao = docum-est-cex.nat-operacao 
                       AND item-doc-est-cex.cod-desp     = docum-est-cex.cod-desp NO-LOCK:
                       /*Cria os itens do documento*/
                       EMPTY TEMP-TABLE rowErrors.
                       EMPTY TEMP-TABLE tt-item-doc-est-cex.
                       
                       CREATE tt-item-doc-est-cex.
                       BUFFER-COPY item-doc-est-cex EXCEPT serie-docto 
                                                           nro-docto 
                                                           cod-emitente 
                                                           nat-operacao 
                                                           TO tt-item-doc-est-cex.
                       ASSIGN tt-item-doc-est-cex.serie-docto  = docum-est.serie-docto 
                              tt-item-doc-est-cex.nro-docto    = docum-est.nro-docto   
                              tt-item-doc-est-cex.cod-emitente = docum-est.cod-emitente
                              tt-item-doc-est-cex.nat-operacao = docum-est.nat-operacao
                              tt-item-doc-est-cex.int-1        = 2 /* N∆o Conciliado */
                              tt-item-doc-est-cex.r-rowid = ROWID(item-doc-est-cex).
    
                       RUN openQueryStatic in h-bocx100 (input "Main":U).
                       RUN setRecord IN h-bocx100 (INPUT TABLE tt-item-doc-est-cex).
                       RUN emptyRowErrors IN h-bocx100.
                       RUN CreateRecord IN h-bocx100.
                       IF RETURN-VALUE = "NOK":U THEN DO:
                          RUN getRowErrors IN h-bocx100 (OUTPUT TABLE RowErrors).
                          RUN piCriaErro (INPUT TABLE RowErrors, INPUT "bocx100":U).
                          NEXT blk-for.
                       END.
                       /*Cria os itens do documento*/
    
    
                       FIND FIRST item-doc-est
                            WHERE item-doc-est.serie-docto  = item-doc-est-cex.serie-docto       
                              AND item-doc-est.nro-docto    = item-doc-est-cex.nro-docto   
                              AND item-doc-est.cod-emitente = item-doc-est-cex.cod-emitente
                              AND item-doc-est.nat-operacao = item-doc-est-cex.nat-operacao 
                              AND item-doc-est.sequencia    = item-doc-est-cex.sequencia NO-LOCK NO-ERROR.
                       IF AVAIL item-doc-est THEN DO:
                          /*Cria os itens do documento origem*/
                          EMPTY TEMP-TABLE rowErrors.
                          EMPTY TEMP-TABLE tt-item-doc-est.
                          
                          CREATE tt-item-doc-est.
                          BUFFER-COPY item-doc-est EXCEPT serie-docto 
                                                          nro-docto 
                                                          cod-emitente 
                                                          nat-operacao 
                                                          sequencia
                                                          TO tt-item-doc-est.
    
                          ASSIGN tt-item-doc-est.sequencia    = 0 
                                 tt-item-doc-est.cod-despesa  = ""
                                 tt-item-doc-est.serie-docto  = docum-est.serie-docto 
                                 tt-item-doc-est.nro-docto    = docum-est.nro-docto   
                                 tt-item-doc-est.cod-emitente = docum-est.cod-emitente
                                 tt-item-doc-est.nat-operacao = docum-est.nat-operacao
                                 /*Documento de Origem*/
                                 tt-item-doc-est.fornec-comp  = item-doc-est-cex.cod-emitente
                                 tt-item-doc-est.serie-comp   = item-doc-est-cex.serie-docto
                                 tt-item-doc-est.nro-comp     = item-doc-est-cex.nro-docto
                                 tt-item-doc-est.nat-comp     = item-doc-est-cex.nat-operacao
                                 tt-item-doc-est.seq-comp     = item-doc-est-cex.sequencia
                                 /*Documento de Origem*/
                                 tt-item-doc-est.quantidade   = 0
                                 tt-item-doc-est.qt-do-forn   = 0
                                 tt-item-doc-est.r-rowid      = ROWID(item-doc-est)
                                 tt-item-doc-est.char-2       = item-doc-est.char-2
                                 tt-item-doc-est.preco-total-me = item-doc-est-cex.val-desp
                                 tt-item-doc-est.preco-unit-me  = tt-item-doc-est.preco-total-me.
                          
                          ASSIGN tt-item-doc-est.preco-total-me = fn_ajust_dec(tt-item-doc-est.preco-total-me, docum-est.mo-codigo)
                                 tt-item-doc-est.preco-total[1] = fn_ajust_dec(tt-item-doc-est.preco-total-me * docum-est.cotacao-dia,0)
                                 tt-item-doc-est.preco-unit[1]  = tt-item-doc-est.preco-total[1].
    
                          RUN piCriaItemDocEst (INPUT TABLE tt-item-doc-est).
                          IF RETURN-VALUE = "NOK":U THEN
                             NEXT blk-for.
                          /*Cria os itens do documento origem*/
    
                       END.
                  END.
    
              END.    
        
          END.
    
          IF CAN-FIND(FIRST tt-erro) THEN
             UNDO, LEAVE.
        
      END.
      
      RUN pi-finalizar IN h-acomp.
    
      IF VALID-HANDLE(h-bocx090) THEN DELETE PROCEDURE h-bocx090.
      IF VALID-HANDLE(h-bocx100) THEN DELETE PROCEDURE h-bocx100.
      IF VALID-HANDLE(h-boin176) THEN DELETE PROCEDURE h-boin176.
    
      IF CAN-FIND(FIRST tt-erro) THEN DO:
         RUN cdp/cd0666.w (INPUT TABLE tt-erro).
      END.
      ELSE DO:
          RUN piCarregaDespesa1.
          RUN piCarregaDespesa2.
      END.
      
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDesfaz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesfaz V-table-Win
ON CHOOSE OF btDesfaz IN FRAME f-main /* Button 2 */
DO:
    ASSIGN l-erro    = NO
           i-seq-aux = 1.

    DO TRANSACTION ON ERROR UNDO, LEAVE
                   ON STOP  UNDO, LEAVE:

        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        {utp/ut-liter.i Desfazendo *}
        RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).
        RUN pi-desabilita-cancela IN h-acomp.


        RUN cxbo/bocx090.p PERSISTENT SET h-bocx090.
        RUN cxbo/bocx100.p PERSISTENT SET h-bocx100.
        RUN inbo/boin176.p PERSISTENT SET h-boin176.


        EMPTY TEMP-TABLE tt-erro.

        blk-for:
        FOR EACH tt-docum-est-cex2
           WHERE tt-docum-est-cex2.mark = "*":U:

            RUN pi-acompanhar IN h-acomp (INPUT c-lbl-docto-desp + ": ":U + tt-docum-est-cex2.nro-docto + "/":U + STRING(tt-docum-est-cex2.cod-desp)).

            FIND FIRST docum-est-cex 
                 WHERE ROWID(docum-est-cex) = tt-docum-est-cex2.r-rowid 
                 NO-LOCK NO-ERROR. 
            IF AVAIL docum-est-cex THEN DO:

                /*Elimina os itens do documento origem*/
                EMPTY TEMP-TABLE rowErrors.
                EMPTY TEMP-TABLE tt-item-doc-est.
                /*Elimina os itens do documento origem*/

                FOR EACH item-doc-est-cex
                   WHERE item-doc-est-cex.serie-docto        = docum-est-cex.serie-docto       
                     AND item-doc-est-cex.nro-docto    = docum-est-cex.nro-docto   
                     AND item-doc-est-cex.cod-emitente = docum-est-cex.cod-emitente
                     AND item-doc-est-cex.nat-operacao = docum-est-cex.nat-operacao 
                     AND item-doc-est-cex.cod-desp     = docum-est-cex.cod-desp NO-LOCK:
                     
                     FIND FIRST item-doc-est
                          WHERE item-doc-est.serie-docto  = item-doc-est-cex.serie-docto       
                            AND item-doc-est.nro-docto    = item-doc-est-cex.nro-docto   
                            AND item-doc-est.cod-emitente = item-doc-est-cex.cod-emitente
                            AND item-doc-est.nat-operacao = item-doc-est-cex.nat-operacao 
                            AND item-doc-est.sequencia    = item-doc-est-cex.sequencia NO-LOCK NO-ERROR.
                     IF AVAIL item-doc-est THEN DO:
                        CREATE tt-item-doc-est.
                        BUFFER-COPY item-doc-est TO tt-item-doc-est.
                        ASSIGN tt-item-doc-est.r-rowid      = ROWID(item-doc-est).
                     END.

                     /*Elimina os itens do documento*/
                     EMPTY TEMP-TABLE rowErrors.
                     RUN openQueryStatic  IN h-bocx100 (INPUT "Main":U).
                     RUN repositionRecord IN h-bocx100 (INPUT ROWID(item-doc-est-cex)).
                     RUN emptyRowErrors   IN h-bocx100.
                     RUN DeleteRecord     IN h-bocx100.
                     IF RETURN-VALUE = "NOK":U THEN DO:
                        RUN getRowErrors IN h-bocx100 (OUTPUT TABLE RowErrors).
                        RUN piCriaErro (INPUT TABLE RowErrors, INPUT "bocx100":U).
                        NEXT blk-for.
                     END.
                     /*Elimina os itens do documento*/
                     
                END.

                /*Elimina os itens do documento origem*/
                RUN piEliminaItemDocEst (INPUT TABLE tt-item-doc-est).
                IF RETURN-VALUE = "NOK":U THEN
                   NEXT blk-for.
                /*Elimina os itens do documento origem*/

                /*Elimina o documento*/
                EMPTY TEMP-TABLE rowErrors.
                RUN openQueryStatic  IN h-bocx090 (INPUT "Main":U).
                RUN repositionRecord IN h-bocx090 (INPUT ROWID(docum-est-cex)).
                RUN emptyRowErrors   IN h-bocx090.
                RUN DeleteRecord     IN h-bocx090.
                IF RETURN-VALUE = "NOK":U THEN DO:
                   RUN getRowErrors IN h-bocx090 (OUTPUT TABLE RowErrors).
                   RUN piCriaErro (INPUT TABLE RowErrors, INPUT "bocx090":U).
                   NEXT blk-for.
                END.
                /*Elimina o documento*/
            END.    

        END.

        IF CAN-FIND(FIRST tt-erro) THEN
           UNDO, LEAVE.

    END.

    RUN pi-finalizar IN h-acomp.

    IF VALID-HANDLE(h-bocx090) THEN DELETE PROCEDURE h-bocx090.
    IF VALID-HANDLE(h-bocx100) THEN DELETE PROCEDURE h-bocx100.
    IF VALID-HANDLE(h-boin176) THEN DELETE PROCEDURE h-boin176.

    IF CAN-FIND(FIRST tt-erro) THEN DO:
       RUN cdp/cd0666.w (INPUT TABLE tt-erro).
    END.
    ELSE DO:

        IF trim(substring(docum-est.char-2,235,1)) = "1":U THEN
            RUN piCarregaDespesaAduana.
        ELSE
            RUN piCarregaDespesa1.

        RUN piCarregaDespesa2.
    END.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rd-item-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rd-item-despesa V-table-Win
ON VALUE-CHANGED OF rd-item-despesa IN FRAME f-main
DO:
    IF SELF:INPUT-VALUE = 1 THEN DO:
       ASSIGN BROWSE brDespesa2:HIDDEN    = NO
              BROWSE brItem1   :HIDDEN    = YES
              bt-modificar     :SENSITIVE = YES
              btDesfaz         :SENSITIVE = YES.
       DISP de-sum-2 @ de-tot-2 WITH FRAM {&FRAME-NAME}.
    END.                      
    ELSE DO:
       ASSIGN BROWSE brDespesa2:HIDDEN    = YES
              BROWSE brItem1   :HIDDEN    = NO
              bt-modificar     :SENSITIVE = NO
              btDesfaz         :SENSITIVE = NO.
       DISP de-sum-3 @ de-tot-2 WITH FRAM {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDespesa1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/
  find param-re where param-re.usuario = c-seg-usuario no-lock no-error.

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
  {src/adm/template/row-list.i "docum-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "docum-est"}

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
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  IF CAN-FIND(FIRST item-doc-est NO-LOCK OF docum-est) THEN DO:
      {utp/ut-liter.i Documento *}
      RUN utp/ut-msgs.p (INPUT "show":U,
                         INPUT 3,
                         INPUT RETURN-VALUE).
      RETURN "adm-error":U.
  END.             
  

  FOR EACH docto-estoq-internac EXCLUSIVE-LOCK
     WHERE docto-estoq-internac.serie-docto  = docum-est.serie-docto
       AND docto-estoq-internac.nro-docto    = docum-est.nro-docto   
       AND docto-estoq-internac.cod-emitente = docum-est.cod-emitente
       AND docto-estoq-internac.nat-operacao = docum-est.nat-operacao:
      DELETE docto-estoq-internac.
  END.

  /*Quando Pa°s Equador deve eliminar os registros referentes a Extens∆o da docum-est */
  IF i-pais-impto-usuario = 21 THEN DO:
      IF NOT VALID-HANDLE(h-boec022) THEN
          RUN local/ecu/ec2bo/boec022.p PERSISTENT SET h-boec022.

      RUN pi-elimina-relacionamentos IN h-boec022 (INPUT docum-est.cod-emitente,
                                                   INPUT docum-est.nat-operacao,
                                                   INPUT docum-est.nro-docto,
                                                   INPUT docum-est.serie-docto).            
                           
      IF VALID-HANDLE(h-boec022) THEN DO:
          RUN destroy IN h-boec022.
          ASSIGN h-boec022 = ?.
      END.
  END.


  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  
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
  IF  AVAIL docum-est THEN DO:
      FIND emitente 
           WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
      ASSIGN fi-emitente = emitente.nome-emit.

      FIND moeda NO-LOCK
           WHERE moeda.mo-codigo = docum-est.mo-codigo NO-ERROR.
      ASSIGN fi-moeda = IF AVAIL moeda THEN moeda.sigla ELSE "":U.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN c-nro-docto-ini = "":U
         c-nro-docto-fim = "ZZZZZZZZZZZZZZZZ":U
         dt-emiss-ini    = TODAY - 30
         dt-emiss-fim    = TODAY
         i-cod-desp-ini  = 0
         i-cod-desp-fim  = 99999.

  
  RUN piCarregaDespesa2.

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
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-liter.i Documento *}
  ASSIGN c-lbl-docto-desp = RETURN-VALUE
         c-docto          = RETURN-VALUE.
  
  {utp/ut-liter.i Despesa *}
  ASSIGN c-lbl-docto-desp = c-lbl-docto-desp + "/":U + RETURN-VALUE
         c-desp           = RETURN-VALUE.

  {utp/ut-liter.i Processo *}
  ASSIGN c-process = RETURN-VALUE.

  {utp/ut-liter.i Rateio *}
  ASSIGN c-rateio = RETURN-VALUE.
  
  {utp/ut-liter.i Fornecedor *}
  ASSIGN docum-est.cod-emitente:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

  {utp/ut-liter.i Marcar *}
  ASSIGN bt-Marca:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

  {utp/ut-liter.i Todos *}
  ASSIGN bt-Todos:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

  {utp/ut-liter.i Seleá∆o *}
  ASSIGN bt-selecao:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

  {utp/ut-liter.i Modificar *}
  ASSIGN bt-modificar:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

  {utp/ut-liter.i Impostos *}
  ASSIGN bt-impostos:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

  {utp/ut-liter.i Visualiza *}
  ASSIGN fi-visualiza = RETURN-VALUE + ":":U.

  {utp/ut-liter.i Despesas *}
  ASSIGN cItemDespesa = RETURN-VALUE + ",1,":U
         fi-despesas  = RETURN-VALUE + ":":U.
  {utp/ut-liter.i Itens *}
  ASSIGN cItemDespesa = cItemDespesa + RETURN-VALUE + ",2":U.

  {utp/ut-liter.i Faturas *}
  ASSIGN fi-fatura = RETURN-VALUE + ":":U.
  
  ASSIGN rd-item-despesa:RADIO-BUTTONS IN FRAME {&FRAME-NAME} = cItemDespesa.

  {utp/ut-liter.i Total *}
  ASSIGN de-tot-1:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE
         de-tot-2:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

  APPLY "value-changed":U TO rd-item-despesa.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .
  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaDocumEst V-table-Win 
PROCEDURE piAtualizaDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF BUFFER b-docum-est FOR docum-est.

FIND FIRST b-docum-est EXCLUSIVE-LOCK
     WHERE b-docum-est.serie-docto  = docum-est.serie-docto
       AND b-docum-est.nro-docto    = docum-est.nro-docto   
       AND b-docum-est.cod-emitente = docum-est.cod-emitente
       AND b-docum-est.nat-operacao = docum-est.nat-operacao NO-ERROR.

IF AVAIL b-docum-est THEN DO:
ASSIGN b-docum-est.tot-desconto    = 0
       b-docum-est.tot-valor       = 0
       b-docum-est.tot-desconto-me = 0
       b-docum-est.tot-valor-me    = 0
       b-docum-est.valor-mercad    = 0
       b-docum-est.valor-mercad-me = 0.

FOR EACH item-doc-est NO-LOCK
   WHERE item-doc-est.serie-docto  = docum-est.serie-docto
     AND item-doc-est.nro-docto    = docum-est.nro-docto   
     AND item-doc-est.cod-emitente = docum-est.cod-emitente
     AND item-doc-est.nat-operacao = docum-est.nat-operacao:

    ASSIGN b-docum-est.tot-desconto    = b-docum-est.tot-desconto    + item-doc-est.desconto[1]
           b-docum-est.tot-valor       = b-docum-est.tot-valor       + item-doc-est.preco-total[1]
           b-docum-est.tot-desconto-me = b-docum-est.tot-desconto-me + item-doc-est.desconto-me
           b-docum-est.tot-valor-me    = b-docum-est.tot-valor-me    + item-doc-est.preco-total-me
           b-docum-est.valor-mercad    = b-docum-est.tot-valor
           b-docum-est.valor-mercad-me = b-docum-est.tot-valor-me.
    END.
    RELEASE b-docum-est NO-ERROR.

END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaSeqEmbarque V-table-Win 
PROCEDURE piBuscaSeqEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
 DEF BUFFER bl-item-doc-est-cex FOR item-doc-est-cex.
   
 FIND FIRST bf-item-doc-est-cex WHERE bf-item-doc-est-cex.serie-docto        =    tt-item-doc-est-cex.serie-docto         AND
                                      bf-item-doc-est-cex.nro-docto          =    tt-item-doc-est-cex.nro-docto           AND
                                      bf-item-doc-est-cex.cod-emitente       =    tt-item-doc-est-cex.cod-emitente        AND
                                      bf-item-doc-est-cex.nat-operacao       =    tt-item-doc-est-cex.nat-operacao        AND
                                      bf-item-doc-est-cex.num-seq-orig       =    item-doc-est-cex.sequencia              AND
                                      bf-item-doc-est-cex.embarque           =    item-doc-est-cex.embarque               EXCLUSIVE-LOCK NO-ERROR.

 IF AVAIL bf-item-doc-est-cex THEN
 DO:
     
     IF NOT l-iterar THEN
     DO:
         
         ASSIGN  tt-item-doc-est-cex.sequencia = bf-item-doc-est-cex.sequencia  /*--esta es la primera seq del embarque--*/
                 l-iterar = YES.
     END. /*not l-iterar*/
     
     ELSE
     DO:
        /*--------------------buscamos la ultima seq del embarque -----------------------------------------------------*/
        FIND LAST bl-item-doc-est-cex WHERE bl-item-doc-est-cex.serie-docto        =    tt-item-doc-est-cex.serie-docto         AND
                                            bl-item-doc-est-cex.nro-docto          =    tt-item-doc-est-cex.nro-docto           AND
                                            bl-item-doc-est-cex.cod-emitente       =    tt-item-doc-est-cex.cod-emitente        AND
                                            bl-item-doc-est-cex.nat-operacao       =    tt-item-doc-est-cex.nat-operacao        AND
                                            bl-item-doc-est-cex.cod-desp           =    tt-item-doc-est-cex.cod-desp            and
                                            bl-item-doc-est-cex.embarque           =    item-doc-est-cex.embarque   NO-LOCK NO-ERROR.
        IF AVAIL bl-item-doc-est-cex THEN
        DO: 
             ASSIGN tt-item-doc-est-cex.sequencia = bl-item-doc-est-cex.sequencia + /*10*/ i-inc-seq.
        END. /*avail bl-item-doc-est-cex*/
           

     END. /*else l-iterar*/

 END. /*avail bf-item-doc-est-cex*/
 ELSE
 DO:
     
           FIND param-re WHERE param-re.usuario = c-seg-usuario NO-LOCK NO-ERROR.

           /*-------------------es el primer gasto de este embarque buscamos la ultima seq de toda la tabla----------------------------*/
           FIND LAST bl-item-doc-est-cex WHERE bl-item-doc-est-cex.serie-docto        =    tt-item-doc-est-cex.serie-docto         AND
                                               bl-item-doc-est-cex.nro-docto          =    tt-item-doc-est-cex.nro-docto           AND
                                               bl-item-doc-est-cex.cod-emitente       =    tt-item-doc-est-cex.cod-emitente        AND
                                               bl-item-doc-est-cex.nat-operacao       =    tt-item-doc-est-cex.nat-operacao        NO-LOCK NO-ERROR.
            IF AVAIL bl-item-doc-est-cex THEN
            DO: 
               ASSIGN tt-item-doc-est-cex.sequencia = bl-item-doc-est-cex.sequencia + /*10*/ i-inc-seq.
                                                      
            END. /*avail bl-item-doc-est-cex */
            ELSE
                ASSIGN tt-item-doc-est-cex.sequencia = IF param-re.seq-item-um > 0 THEN param-re.seq-item-um ELSE 10.
      
 END. /* not avail bf-item-doc-est-cex*/
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaDespesa1 V-table-Win 
PROCEDURE piCarregaDespesa1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF BUFFER b-docum-est     FOR docum-est.
DEF BUFFER b-docum-est-cex FOR docum-est-cex.

EMPTY TEMP-TABLE tt-docum-est-cex1.

DEF BUFFER b-item-doc-est     FOR item-doc-est.
DEF BUFFER b-item-doc-est-cex FOR item-doc-est-cex.

blk-despesas:
FOR EACH docum-est-cex NO-LOCK
   WHERE docum-est-cex.nro-docto  >= c-nro-docto-ini
     AND docum-est-cex.nro-docto  <= c-nro-docto-fim
     AND docum-est-cex.cod-emitente-desp = docum-est.cod-emitente:
    
    IF docum-est-cex.mo-codigo <> docum-est.mo-codigo THEN NEXT.

    IF &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
        docum-est-cex.idi-sit-despes    <> 1
       &ELSE
        docum-est-cex.int-1             <> 1
     &ENDIF
     THEN NEXT.

    IF docum-est-cex.log-2  THEN NEXT.

     
    FOR FIRST b-docum-est NO-LOCK
        WHERE b-docum-est.serie-docto   = docum-est-cex.serie-docto       
          AND b-docum-est.nro-docto     = docum-est-cex.nro-docto   
          AND b-docum-est.cod-emitente  = docum-est-cex.cod-emitente
          AND b-docum-est.nat-operacao  = docum-est-cex.nat-operacao:
    END.
    IF NOT AVAIL b-docum-est THEN NEXT.
    
    IF b-docum-est.dt-emissao   < dt-emiss-ini
    OR b-docum-est.dt-emissao   > dt-emiss-fim THEN NEXT.

    IF NOT b-docum-est.ce-atual THEN NEXT.

    IF b-docum-est.nff          THEN NEXT.

    IF b-docum-est.embarque <> "" THEN NEXT. 


    RELEASE b-docum-est NO-ERROR.
    FOR FIRST desp-imp FIELDS(descricao inc-val-duplic) 
        WHERE desp-imp.cod-desp       = docum-est-cex.cod-desp NO-LOCK:
    END.
    IF NOT desp-imp.inc-val-duplic THEN NEXT.

    FOR FIRST natur-oper FIELDS(emite-duplic)
        WHERE natur-oper.nat-operacao = docum-est-cex.nat-operacao NO-LOCK:
    END.
    IF  NOT natur-oper.emite-duplic THEN
        NEXT.

    /*Para o mesmo documento*/
    FOR EACH item-doc-est-cex NO-LOCK 
       WHERE item-doc-est-cex.serie-docto       = docum-est-cex.serie-docto         
         AND item-doc-est-cex.nro-docto         = docum-est-cex.nro-docto           
         AND item-doc-est-cex.cod-emitente      = docum-est-cex.cod-emitente        
         AND item-doc-est-cex.nat-operacao      = docum-est-cex.nat-operacao        
         AND item-doc-est-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp 
         AND item-doc-est-cex.cod-desp          = docum-est-cex.cod-desp
        USE-INDEX desp-imp:
        
        /*Documento de origem*/
        FOR EACH b-item-doc-est 
           WHERE b-item-doc-est.serie-comp   = item-doc-est-cex.serie-docto
             AND b-item-doc-est.nro-comp     = item-doc-est-cex.nro-docto
             AND b-item-doc-est.fornec-comp  = item-doc-est-cex.cod-emitente  
             AND b-item-doc-est.nat-comp     = item-doc-est-cex.nat-operacao
             AND b-item-doc-est.seq-comp     = item-doc-est-cex.sequencia NO-LOCK:
        
            IF CAN-FIND(FIRST b-item-doc-est-cex 
                        WHERE b-item-doc-est-cex.serie-docto       = b-item-doc-est.serie-docto 
                          AND b-item-doc-est-cex.nro-docto         = b-item-doc-est.nro-docto   
                          AND b-item-doc-est-cex.cod-emitente      = b-item-doc-est.cod-emitente
                          AND b-item-doc-est-cex.nat-operacao      = b-item-doc-est.nat-operacao
                          AND b-item-doc-est-cex.sequencia         = b-item-doc-est.sequencia   
                          AND b-item-doc-est-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
                          AND b-item-doc-est-cex.cod-desp          = docum-est-cex.cod-desp) THEN
               NEXT blk-despesas.

        END.
    END.

    CREATE tt-docum-est-cex1.
    ASSIGN tt-docum-est-cex1.mark      = "":U
           tt-docum-est-cex1.nro-docto = docum-est-cex.nro-docto
           tt-docum-est-cex1.cod-desp  = docum-est-cex.cod-desp
           tt-docum-est-cex1.desc-desp = desp-imp.descricao
           tt-docum-est-cex1.r-rowid   = ROWID(docum-est-cex)
           tt-docum-est-cex1.val-desp  = docum-est-cex.val-desp.

END.

{&OPEN-QUERY-brDespesa1}

DISP 0 @ de-tot-1 WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaDespesa2 V-table-Win 
PROCEDURE piCarregaDespesa2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt-docum-est-cex2.
EMPTY TEMP-TABLE tt-item-doc-est-cex1.

ASSIGN de-sum-2 = 0
       de-sum-3 = 0.

FOR EACH docum-est-cex NO-LOCK
   WHERE docum-est-cex.serie-docto  = docum-est.serie-docto 
     AND docum-est-cex.nro-docto    = docum-est.nro-docto 
     AND docum-est-cex.cod-emitente = docum-est.cod-emitente
     AND docum-est-cex.nat-operacao = docum-est.nat-operacao,
   FIRST desp-imp FIELDS(descricao) NO-LOCK
   WHERE desp-imp.cod-desp       = docum-est-cex.cod-desp:

    CREATE tt-docum-est-cex2.
    ASSIGN tt-docum-est-cex2.mark      = "":U
           tt-docum-est-cex2.nro-docto = docum-est-cex.nro-docto
           tt-docum-est-cex2.cod-desp  = docum-est-cex.cod-desp
           tt-docum-est-cex2.desc-desp = desp-imp.descricao
           tt-docum-est-cex2.r-rowid   = ROWID(docum-est-cex)
           tt-docum-est-cex2.r-docto   = ROWID(docum-est).


        ASSIGN tt-docum-est-cex2.val-desp  = docum-est-cex.val-desp
               de-sum-2                    = de-sum-2 + docum-est-cex.val-desp.

     
    FOR EACH item-doc-est-cex USE-INDEX desp-imp NO-LOCK
       WHERE item-doc-est-cex.serie-docto       = docum-est-cex.serie-docto 
         AND item-doc-est-cex.nro-docto         = docum-est-cex.nro-docto 
         AND item-doc-est-cex.cod-emitente      = docum-est-cex.cod-emitente
         AND item-doc-est-cex.nat-operacao      = docum-est-cex.nat-operacao
         AND item-doc-est-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
         AND item-doc-est-cex.cod-desp          = docum-est-cex.cod-desp:

         FIND FIRST item-doc-est NO-LOCK 
              WHERE item-doc-est.serie-docto  = item-doc-est-cex.serie-docto 
                AND item-doc-est.nro-docto    = item-doc-est-cex.nro-docto 
                AND item-doc-est.cod-emitente = item-doc-est-cex.cod-emitente
                AND item-doc-est.nat-operacao = item-doc-est-cex.nat-operacao
                AND item-doc-est.sequencia    = item-doc-est-cex.sequencia NO-ERROR.

        CREATE tt-item-doc-est-cex1.
        ASSIGN tt-item-doc-est-cex1.nro-docto   = item-doc-est-cex.nro-docto   
               tt-item-doc-est-cex1.cod-desp    = item-doc-est-cex.cod-desp    
               tt-item-doc-est-cex1.sequencia   = item-doc-est-cex.sequencia
               tt-item-doc-est-cex1.desc-desp   = desp-imp.descricao        
               tt-item-doc-est-cex1.r-rowid     = ROWID(item-doc-est-cex)
               tt-item-doc-est-cex1.r-docto-cex = ROWID(docum-est-cex)
               tt-item-doc-est-cex1.r-item-doc  = ROWID(item-doc-est).

            ASSIGN tt-item-doc-est-cex1.val-desp    = item-doc-est-cex.val-desp
                   de-sum-3                         = de-sum-3 + item-doc-est-cex.val-desp.
                   

    END.
END.

IF rd-item-despesa:INPUT-VALUE IN FRAME {&FRAME-NAME} = 1 THEN
   DISP de-sum-2 @ de-tot-2 WITH FRAM {&FRAME-NAME}.
ELSE
   DISP de-sum-3 @ de-tot-2 WITH FRAM {&FRAME-NAME}.


{&OPEN-QUERY-brDespesa2} 
{&OPEN-QUERY-brItem1}    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaDespesaAduana V-table-Win 
PROCEDURE piCarregaDespesaAduana :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    
DEF BUFFER b-docum-est     FOR docum-est.
DEF BUFFER b-docum-est-cex FOR docum-est-cex.

EMPTY TEMP-TABLE tt-docum-est-cex1.

DEF BUFFER b-item-doc-est     FOR item-doc-est.
DEF BUFFER b-item-doc-est-cex FOR item-doc-est-cex.
DEF BUFFER bfer-item-doc-est-cex FOR item-doc-est-cex.


    
blk-despesas:
FOR EACH docum-est-cex NO-LOCK
   WHERE docum-est-cex.nro-docto  >= c-nro-docto-ini
     AND docum-est-cex.nro-docto  <= c-nro-docto-fim
     AND docum-est-cex.cod-desp   >= i-cod-desp-ini
     AND docum-est-cex.cod-desp   <= i-cod-desp-fim
     &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
     AND docum-est-cex.idi-sit-despes   = 1
     &ELSE
     AND docum-est-cex.int-1            = 1
     &ENDIF
     ,
    FIRST b-docum-est FIELDS(ce-atual) NO-LOCK
    WHERE b-docum-est.serie-docto   = docum-est-cex.serie-docto       
      AND b-docum-est.nro-docto     = docum-est-cex.nro-docto   
      AND b-docum-est.cod-emitente  = docum-est-cex.cod-emitente
      AND b-docum-est.nat-operacao  = docum-est-cex.nat-operacao
      AND b-docum-est.dt-emissao   >= dt-emiss-ini
      AND b-docum-est.dt-emissao   <= dt-emiss-fim
      AND b-docum-est.ce-atual      = YES 
      AND b-docum-est.nff           = NO
      AND b-docum-est.embarque      = "",
    FIRST desp-imp FIELDS(descricao) NO-LOCK
    WHERE desp-imp.cod-desp       = docum-est-cex.cod-desp
      AND desp-imp.inc-val-duplic = YES:

    
    
     FIND FIRST bfer-item-doc-est-cex OF docum-est-cex NO-LOCK NO-ERROR.
   
    IF NOT docum-est-cex.log-2 THEN DO:

        CREATE tt-docum-est-cex1.
        ASSIGN tt-docum-est-cex1.mark      = "":U
           tt-docum-est-cex1.nro-docto = docum-est-cex.nro-docto
           tt-docum-est-cex1.cod-desp  = docum-est-cex.cod-desp
           tt-docum-est-cex1.desc-desp = desp-imp.descricao
           tt-docum-est-cex1.val-desp  = docum-est-cex.val-desp / (IF docum-est.cotacao-dia = 0 THEN 1 ELSE docum-est.cotacao-dia )   /* las despesas son en pesos */
           tt-docum-est-cex1.r-rowid   = ROWID(docum-est-cex).
           
    END.  
    ELSE DO:
      
            NEXT blk-despesas. 
    END.

END.

{&OPEN-QUERY-brDespesa1}

DISP 0 @ de-tot-1 WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piConciliacaoAduana V-table-Win 
PROCEDURE piConciliacaoAduana :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF BUFFER bf-item-doc-ext-cex-dec FOR  item-doc-est-cex.

DEF BUFFER bf-docum-est-desp-0     FOR  docum-est.
DEF BUFFER bf-item-doc-est-desp-0 FOR  item-doc-est.


  ASSIGN l-erro    = NO
         i-seq-aux = 1.

  DO TRANSACTION ON ERROR UNDO, LEAVE
                 ON STOP  UNDO, LEAVE:

      RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
      {utp/ut-liter.i Processando *}
      RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).
      RUN pi-desabilita-cancela IN h-acomp.

      RUN cxbo/bocx090.p PERSISTENT SET h-bocx090.
      RUN cxbo/bocx100.p PERSISTENT SET h-bocx100.
      RUN inbo/boin176.p PERSISTENT SET h-boin176.
      
      RUN inbo/boin292.p PERSISTENT SET h-boin292.
      RUN openQueryStatic IN h-boin292 (INPUT "Main":U).
      RUN goToKey      IN h-boin292  (INPUT c-seg-usuario).
      RUN getIntField  IN h-boin292  (INPUT "inc-seq":U, OUTPUT i-inc-seq).
      DELETE PROCEDURE h-boin292.
    
      EMPTY TEMP-TABLE tt-erro.

      
      blk-for:
      FOR EACH tt-docum-est-cex1
         WHERE tt-docum-est-cex1.mark = "*":U:

          RUN pi-acompanhar IN h-acomp (INPUT c-lbl-docto-desp + ": ":U + tt-docum-est-cex1.nro-docto + "/":U + STRING(tt-docum-est-cex1.cod-desp)).

          FIND FIRST docum-est-cex 
               WHERE ROWID(docum-est-cex) = tt-docum-est-cex1.r-rowid 
               EXCLUSIVE-LOCK NO-ERROR. 
          IF AVAIL docum-est-cex THEN DO:

              /*--------------------------para que permita conciliar gastos con valor cero---------------------*/
              IF docum-est-cex.val-desp = 0.0 OR docum-est-cex.val-desp = 1  THEN
              DO:
                  ASSIGN docum-est-cex.val-desp = 1.     /* asigno 1 para luego prorratear en los item*/
                      
                  FOR EACH bf-item-doc-ext-cex-dec OF docum-est-cex EXCLUSIVE-LOCK:


                      /* Busco el Docum est para determinar el prorrateo a cada item */     

                      FIND FIRST bf-docum-est-desp-0 
                          WHERE bf-docum-est-desp-0.cod-estabel  = bf-item-doc-ext-cex-dec.cod-estabel 
                          AND bf-docum-est-desp-0.embarque     = bf-item-doc-ext-cex-dec.embarque    
                          AND bf-docum-est-desp-0.nat-operacao <> ""  
                          NO-LOCK NO-ERROR. 


                      IF AVAIL bf-docum-est-desp-0 THEN

                          FOR EACH bf-item-doc-est-desp-0 OF bf-docum-est-desp-0 NO-LOCK:

                              IF bf-item-doc-ext-cex-dec.sequencia = bf-item-doc-est-desp-0.sequencia THEN

                                  ASSIGN bf-item-doc-ext-cex-dec.val-desp = (1 * (bf-item-doc-est-desp-0.preco-total[1] / bf-docum-est-desp-0.valor-mercad)).
                                     
                          END.
                         

                  END.
              END.
                 
              /*Cria o documento*/
              EMPTY TEMP-TABLE rowErrors.
              EMPTY TEMP-TABLE tt-docum-est-cex.
              
              CREATE tt-docum-est-cex.
              BUFFER-COPY docum-est-cex EXCEPT serie-docto 
                                               nro-docto 
                                               cod-emitente 
                                               nat-operacao 
                                               TO tt-docum-est-cex.
              ASSIGN tt-docum-est-cex.serie-docto  = docum-est.serie-docto 
                     tt-docum-est-cex.nro-docto    = docum-est.nro-docto   
                     tt-docum-est-cex.cod-emitente = docum-est.cod-emitente
                     tt-docum-est-cex.nat-operacao = docum-est.nat-operacao
                     tt-docum-est-cex.int-1        = 2 /* N∆o Conciliado */
                     tt-docum-est-cex.r-rowid      = ROWID(docum-est-cex)
                     tt-docum-est-cex.val-desp     = docum-est-cex.val-desp / docum-est.cotacao-dia 
                     tt-docum-est-cex.mo-codigo    = docum-est.mo-codigo
                     tt-docum-est-cex.cotacao      = docum-est.cotacao-dia.

              /*--------------------para acumular los gastos de diferentes embarques o documentos---------------*/

              FIND FIRST bf-docum-est-cex 
                  WHERE bf-docum-est-cex.serie-docto        =    tt-docum-est-cex.serie-docto         
                  AND bf-docum-est-cex.nro-docto          =    tt-docum-est-cex.nro-docto           
                  AND bf-docum-est-cex.cod-emitente       =    tt-docum-est-cex.cod-emitente        
                  AND bf-docum-est-cex.nat-operacao       =    tt-docum-est-cex.nat-operacao        
                  AND bf-docum-est-cex.cod-emitente-desp  =    tt-docum-est-cex.cod-emitente-desp   
                  AND bf-docum-est-cex.cod-desp           =    tt-docum-est-cex.cod-desp            
                  EXCLUSIVE-LOCK NO-ERROR.

               IF NOT AVAIL bf-docum-est-cex THEN
               DO:  
                    RUN openQueryStatic in h-bocx090 (input "Main":U).
                    RUN setRecord IN h-bocx090 (INPUT TABLE tt-docum-est-cex).
                    RUN emptyRowErrors IN h-bocx090.
                    RUN CreateRecord IN h-bocx090.
                    IF RETURN-VALUE = "NOK":U THEN DO:
                       RUN getRowErrors IN h-bocx090 (OUTPUT TABLE RowErrors).
                       RUN piCriaErro (INPUT TABLE RowErrors, INPUT "bocx090":U).
                       NEXT blk-for.
                    END.
                   /*Cria o documento*/

               END.
               ELSE
               DO:
                   ASSIGN  bf-docum-est-cex.val-desp = bf-docum-est-cex.val-desp + tt-docum-est-cex.val-desp.
                   /*acumula documento*/
               END. /*else avail not bf-item-doc-est-cex */

               ASSIGN l-iterar = NO.


              FOR EACH item-doc-est-cex
                 WHERE item-doc-est-cex.serie-docto        = docum-est-cex.serie-docto       
                   AND item-doc-est-cex.nro-docto    = docum-est-cex.nro-docto   
                   AND item-doc-est-cex.cod-emitente = docum-est-cex.cod-emitente
                   AND item-doc-est-cex.nat-operacao = docum-est-cex.nat-operacao 
                   AND item-doc-est-cex.cod-desp     = docum-est-cex.cod-desp NO-LOCK:
                   
                   /*Cria os itens do documento*/
                   EMPTY TEMP-TABLE rowErrors.
                   EMPTY TEMP-TABLE tt-item-doc-est-cex.
                   
                   CREATE tt-item-doc-est-cex.
                   BUFFER-COPY item-doc-est-cex EXCEPT serie-docto 
                                                       nro-docto 
                                                       cod-emitente 
                                                       nat-operacao
                                                       TO tt-item-doc-est-cex.


                   ASSIGN tt-item-doc-est-cex.serie-docto  = docum-est.serie-docto 
                          tt-item-doc-est-cex.nro-docto    = docum-est.nro-docto   
                          tt-item-doc-est-cex.cod-emitente = docum-est.cod-emitente
                          tt-item-doc-est-cex.nat-operacao = docum-est.nat-operacao
                          tt-item-doc-est-cex.int-1        = 2 /* N∆o Conciliado */
                          tt-item-doc-est-cex.r-rowid = ROWID(item-doc-est-cex)
                          tt-item-doc-est-cex.val-desp     = item-doc-est-cex.val-desp / docum-est.cotacao-dia
                          tt-item-doc-est-cex.mo-codigo    = docum-est.mo-codigo
                          tt-item-doc-est-cex.cotacao      = docum-est.cotacao-dia.

       
                      /*-----nuevo gasto, buscamos si ya existe gasto para este embarque y tomar la seq---------*/
                      RUN piBuscaSeqEmbarque.   
                   
                      RUN openQueryStatic in h-bocx100 (input "Main":U).
                      RUN setRecord IN h-bocx100 (INPUT TABLE tt-item-doc-est-cex).
                      RUN emptyRowErrors IN h-bocx100.
                      RUN CreateRecord IN h-bocx100.
                      IF RETURN-VALUE = "NOK":U THEN DO:
                         RUN getRowErrors IN h-bocx100 (OUTPUT TABLE RowErrors).
                         RUN piCriaErro (INPUT TABLE RowErrors, INPUT "bocx100":U).
                         NEXT blk-for.
                      END.
                      /*Cria os itens do documento*/


                   FIND FIRST item-doc-est
                        WHERE item-doc-est.serie-docto  = item-doc-est-cex.serie-docto       
                          AND item-doc-est.nro-docto    = item-doc-est-cex.nro-docto   
                          AND item-doc-est.cod-emitente = item-doc-est-cex.cod-emitente
                          AND item-doc-est.nat-operacao = item-doc-est-cex.nat-operacao 
                          AND item-doc-est.sequencia    = item-doc-est-cex.sequencia NO-LOCK NO-ERROR.

                   IF AVAIL item-doc-est THEN DO:
                      /*Cria os itens do documento origem*/
                      EMPTY TEMP-TABLE rowErrors.
                      EMPTY TEMP-TABLE tt-item-doc-est.
                      
                      CREATE tt-item-doc-est.
                      BUFFER-COPY item-doc-est EXCEPT serie-docto 
                                                      nro-docto 
                                                      cod-emitente 
                                                      nat-operacao 
                                                      sequencia
                                                      TO tt-item-doc-est.

                      ASSIGN tt-item-doc-est.sequencia    = 0 
                             tt-item-doc-est.cod-despesa  = ""
                             tt-item-doc-est.serie-docto  = docum-est.serie-docto 
                             tt-item-doc-est.nro-docto    = docum-est.nro-docto   
                             tt-item-doc-est.cod-emitente = docum-est.cod-emitente
                             tt-item-doc-est.nat-operacao = docum-est.nat-operacao
                             /*Documento de Origem*/
                             tt-item-doc-est.fornec-comp  = item-doc-est-cex.cod-emitente
                             tt-item-doc-est.serie-comp   = item-doc-est-cex.serie-docto
                             tt-item-doc-est.nro-comp     = item-doc-est-cex.nro-docto
                             tt-item-doc-est.nat-comp     = item-doc-est-cex.nat-operacao
                             tt-item-doc-est.seq-comp     = item-doc-est-cex.sequencia
                             /*Documento de Origem*/
                             tt-item-doc-est.quantidade   = 0
                             tt-item-doc-est.qt-do-forn   = 0
                             tt-item-doc-est.r-rowid      = ROWID(item-doc-est).
                      
                      ASSIGN tt-item-doc-est.preco-total-me = item-doc-est-cex.val-desp  / docum-est.cotacao-dia
                             tt-item-doc-est.preco-unit-me  = tt-item-doc-est.preco-total-me.
                      
                      ASSIGN tt-item-doc-est.preco-total-me = fn_ajust_dec(tt-item-doc-est.preco-total-me, docum-est.mo-codigo)
                             tt-item-doc-est.preco-total[1] = fn_ajust_dec(tt-item-doc-est.preco-total-me * docum-est.cotacao-dia,0)
                             tt-item-doc-est.preco-unit[1]  = tt-item-doc-est.preco-total[1].

                      RUN piCriaItemDocEst (INPUT TABLE tt-item-doc-est).
                      IF RETURN-VALUE = "NOK":U THEN
                         NEXT blk-for.
                      /*Cria os itens do documento origem*/

                   END.
              END.

          END.    
    
      END.

      IF CAN-FIND(FIRST tt-erro) THEN
         UNDO, LEAVE.
    
  END.
  
  RUN pi-finalizar IN h-acomp.

  IF VALID-HANDLE(h-bocx090) THEN DELETE PROCEDURE h-bocx090.
  IF VALID-HANDLE(h-bocx100) THEN DELETE PROCEDURE h-bocx100.
  IF VALID-HANDLE(h-boin176) THEN DELETE PROCEDURE h-boin176.

  IF CAN-FIND(FIRST tt-erro) THEN DO:
     RUN cdp/cd0666.w (INPUT TABLE tt-erro).
  END.
  ELSE DO:
     RUN piCarregaDespesaAduana.
     RUN piCarregaDespesa2.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaErro V-table-Win 
PROCEDURE piCriaErro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF INPUT PARAMETER TABLE FOR RowErrors.
   DEF INPUT PARAMETER p-process AS CHAR NO-UNDO.

   ASSIGN l-erro = YES.

   FOR EACH RowErrors
      WHERE RowErrors.ErrorSubType = "ERROR":U
        AND RowErrors.ErrorType   <> "INTERNAL":U:
       ASSIGN i-seq-aux = i-seq-aux + 1.
       CREATE tt-erro.
       ASSIGN tt-erro.i-sequen = i-seq-aux
              tt-erro.cd-erro  = RowErrors.ErrorNumber
              tt-erro.mensagem = RowErrors.ErrorDescription + CHR(10) + CHR(10) +
                                 c-docto   + ": ":U + tt-docum-est-cex1.nro-docto        + CHR(10) + 
                                 c-desp    + ": ":U + STRING(tt-docum-est-cex1.cod-desp) + CHR(10) + 
                                 c-process + ": ":U + p-process.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaErro2 V-table-Win 
PROCEDURE piCriaErro2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pMsg   as int  no-undo.
def input param pParam as char no-undo.
def input param pTexto as char no-undo.

IF pTexto = "" OR 
   pTexto = ?  THEN DO:
   RUN utp/ut-msgs.p (input "msg":u,
                      input pMsg,
                      input pParam).
   ASSIGN pTexto = return-value.
END.

ASSIGN i-seq-aux = i-seq-aux + 1.
CREATE tt-erro.
ASSIGN tt-erro.i-sequen = i-seq-aux
       tt-erro.cd-erro  = pMsg
       tt-erro.mensagem = pTexto.
 
IF AVAIL tt-docum-est-cex1 THEN
   ASSIGN tt-erro.mensagem = pTexto + CHR(10) + CHR(10) +
                             c-docto   + ": ":U + tt-docum-est-cex1.nro-docto        + CHR(10) + 
                             c-desp    + ": ":U + STRING(tt-docum-est-cex1.cod-desp) + CHR(10).

ASSIGN l-erro = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaItemDocEst V-table-Win 
PROCEDURE piCriaItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER TABLE FOR tt-item-doc-est.

DEF BUFFER b-item-doc-est FOR item-doc-est.
DEF BUFFER b-docum-est    FOR docum-est.
              
FIND FIRST tt-item-doc-est NO-ERROR.
IF AVAIL tt-item-doc-est THEN DO:

    FIND FIRST b-item-doc-est 
         WHERE b-item-doc-est.serie-docto  = tt-item-doc-est.serie-docto
           AND b-item-doc-est.nro-docto    = tt-item-doc-est.nro-docto
           AND b-item-doc-est.cod-emitente = tt-item-doc-est.cod-emitente 
           AND b-item-doc-est.nat-operacao = tt-item-doc-est.nat-operacao
           AND b-item-doc-est.serie-comp   = tt-item-doc-est.serie-comp  
           AND b-item-doc-est.nro-comp     = tt-item-doc-est.nro-comp   
           AND b-item-doc-est.fornec-comp  = tt-item-doc-est.fornec-comp  
           AND b-item-doc-est.nat-comp     = tt-item-doc-est.nat-comp   
           AND b-item-doc-est.seq-comp     = tt-item-doc-est.seq-comp   
            EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAIL b-item-doc-est THEN DO:
        RUN piNextSequence (OUTPUT tt-item-doc-est.sequencia). 
        CREATE b-item-doc-est.
        BUFFER-COPY tt-item-doc-est TO b-item-doc-est.
    END.
    ELSE DO:
        ASSIGN b-item-doc-est.preco-total-me = b-item-doc-est.preco-total-me + tt-item-doc-est.preco-total-me
               b-item-doc-est.preco-unit-me  = b-item-doc-est.preco-total-me.
                      
        ASSIGN b-item-doc-est.preco-total-me = fn_ajust_dec(b-item-doc-est.preco-total-me, docum-est.mo-codigo)
               b-item-doc-est.preco-total[1] = fn_ajust_dec(b-item-doc-est.preco-total-me * docum-est.cotacao-dia,0)
               b-item-doc-est.preco-unit[1]  = b-item-doc-est.preco-total[1].
    END.

    {rep/re1001b.i51 "no"}
    {cdp/cd4300.i4  "no" b-item-doc-est.char-1}

END.

RUN piAtualizaDocumEst.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminaItemDocEst V-table-Win 
PROCEDURE piEliminaItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER TABLE FOR tt-item-doc-est.

DEF BUFFER b-item-doc-est     FOR item-doc-est.
DEF BUFFER b-item-doc-est-cex FOR item-doc-est-cex.
              
FOR EACH tt-item-doc-est:

    IF NOT CAN-FIND(FIRST b-item-doc-est-cex
                    WHERE b-item-doc-est-cex.serie-docto        = tt-item-doc-est.serie-docto
                      AND b-item-doc-est-cex.nro-docto    = tt-item-doc-est.nro-docto   
                      AND b-item-doc-est-cex.cod-emitente = tt-item-doc-est.cod-emitente
                      AND b-item-doc-est-cex.nat-operacao = tt-item-doc-est.nat-operacao 
                      AND b-item-doc-est-cex.sequencia    = tt-item-doc-est.sequencia) THEN DO:
        FIND FIRST b-item-doc-est 
             WHERE ROWID(b-item-doc-est) = tt-item-doc-est.r-rowid EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL b-item-doc-est THEN DO:
           FOR EACH impto-item-docto EXCLUSIVE-LOCK
              WHERE impto-item-docto.serie-docto  = b-item-doc-est.serie-docto
                AND impto-item-docto.nro-docto    = b-item-doc-est.nro-docto
                AND impto-item-docto.cod-emitente = b-item-doc-est.cod-emitente
                AND impto-item-docto.nat-operacao = b-item-doc-est.nat-operacao 
                AND impto-item-docto.num-seq      = b-item-doc-est.sequencia:
                DELETE impto-item-docto.
           END.
           DELETE b-item-doc-est.
        END.
    END.
    ELSE DO:
        FIND FIRST b-item-doc-est 
             WHERE ROWID(b-item-doc-est) = tt-item-doc-est.r-rowid EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL b-item-doc-est THEN DO:
            ASSIGN b-item-doc-est.preco-total-me = b-item-doc-est.preco-total-me - tt-item-doc-est.preco-total-me
                   b-item-doc-est.preco-unit-me  = b-item-doc-est.preco-total-me.
                      
            ASSIGN b-item-doc-est.preco-total-me = fn_ajust_dec(b-item-doc-est.preco-total-me, docum-est.mo-codigo)
                   b-item-doc-est.preco-total[1] = fn_ajust_dec(b-item-doc-est.preco-total-me * docum-est.cotacao-dia,0)
                   b-item-doc-est.preco-unit[1]  = b-item-doc-est.preco-total[1].
        END.
    END.
END.    

RUN piAtualizaDocumEst.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMudaLabel V-table-Win 
PROCEDURE piMudaLabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  NOT AVAIL tt-docum-est-cex1 THEN
        RETURN "NOK":U.
    if  tt-docum-est-cex1.mark = "" then do:
        {utp/ut-liter.i Marca * r}
        assign bt-marca:label in frame {&frame-name} = return-value.
        {utp/ut-liter.i Todos * r}
        assign bt-todos:label in frame {&frame-name} = return-value.
    end.
    else do:
        {utp/ut-liter.i Desmarca * r}
        assign bt-marca:label in frame {&frame-name} = return-value.
        {utp/ut-liter.i Nenhum * r}
        assign bt-todos:label in frame {&frame-name} = return-value.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piNextSequence V-table-Win 
PROCEDURE piNextSequence :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER i-sequencia LIKE item-doc-est.sequencia.

DEF BUFFER b-it-docest FOR item-doc-est.

FIND param-re 
     WHERE param-re.usuario = c-seg-usuario NO-LOCK NO-ERROR.        
FIND LAST b-it-docest 
     WHERE b-it-docest.cod-emitente = docum-est.cod-emitente
       AND b-it-docest.nat-operacao = docum-est.nat-operacao
       AND b-it-docest.serie-docto  = docum-est.serie-docto
       AND b-it-docest.nro-docto    = docum-est.nro-docto 
        NO-LOCK NO-ERROR.
ASSIGN i-sequencia = IF AVAIL b-it-docest THEN b-it-docest.sequencia + i-inc-seq 
                     ELSE IF param-re.seq-item-um > 0 THEN param-re.seq-item-um 
                     ELSE 10.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRateioValor V-table-Win 
PROCEDURE piRateioValor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER rw-docum-est-cex AS ROWID                    NO-UNDO.
DEF INPUT PARAMETER p-novo-valor     LIKE docum-est-cex.val-desp NO-UNDO.

DEF BUFFER b-item-doc-est FOR item-doc-est.

DEFINE VARIABLE de-perc-dif          AS DECIMAL DECIMALS 5       NO-UNDO.
DEFINE VARIABLE de-soma              AS DECIMAL DECIMALS 5       NO-UNDO.
DEFINE VARIABLE de-dif               AS DECIMAL     NO-UNDO.

  ASSIGN l-erro    = NO
         i-seq-aux = 1.

  DO TRANSACTION ON ERROR UNDO, LEAVE
                 ON STOP  UNDO, LEAVE:

      RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
      {utp/ut-liter.i Processando *}
      RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).
      RUN pi-desabilita-cancela IN h-acomp.
      
      RUN cxbo/bocx090.p PERSISTENT SET h-bocx090.
      RUN cxbo/bocx100.p PERSISTENT SET h-bocx100.
      RUN inbo/boin176.p PERSISTENT SET h-boin176.

      EMPTY TEMP-TABLE tt-erro.

      FIND FIRST tt-docum-est-cex2
           WHERE tt-docum-est-cex2.r-rowid = rw-docum-est-cex NO-ERROR.

      IF AVAIL tt-docum-est-cex2 THEN DO:
          
          RUN pi-acompanhar IN h-acomp (INPUT c-rateio + ": ":U + tt-docum-est-cex2.nro-docto + "/":U + STRING(tt-docum-est-cex2.cod-desp)).
          
          FIND FIRST docum-est-cex NO-LOCK
               WHERE ROWID(docum-est-cex) = tt-docum-est-cex2.r-rowid NO-ERROR.

          ASSIGN de-perc-dif = (p-novo-valor * 100) / tt-docum-est-cex2.val-desp.

          /*Atualiza o documento*/  
          EMPTY TEMP-TABLE rowErrors.
          EMPTY TEMP-TABLE tt-docum-est-cex.
          RUN openQueryStatic  IN h-bocx090 (INPUT "Main":U).
          RUN repositionRecord IN h-bocx090 (INPUT tt-docum-est-cex2.r-rowid).
          RUN getRecord        IN h-bocx090 (OUTPUT TABLE tt-docum-est-cex).


          FIND FIRST tt-docum-est-cex NO-ERROR.
          IF AVAIL tt-docum-est-cex THEN
             ASSIGN tt-docum-est-cex.val-desp = p-novo-valor.
          RUN setRecord      IN h-bocx090 (INPUT TABLE tt-docum-est-cex).
          RUN emptyRowErrors IN h-bocx090.
          RUN UpdateRecord   IN h-bocx090.
          IF RETURN-VALUE = "NOK":U THEN DO:
             RUN getRowErrors IN h-bocx090 (OUTPUT TABLE RowErrors).
             RUN piCriaErro (INPUT TABLE RowErrors, INPUT "bocx090":U).
             LEAVE.
          END.
          /*Atualiza o documento*/

          /*Atualiza os itens do documento*/
          ASSIGN de-soma = 0.
          RUN openQueryStatic in h-bocx100 (input "Main":U).
          FOR EACH tt-item-doc-est-cex1 NO-LOCK
             WHERE tt-item-doc-est-cex1.r-docto-cex = tt-docum-est-cex.r-rowid:        
               
               EMPTY TEMP-TABLE rowErrors.
               EMPTY TEMP-TABLE tt-docum-est-cex.
               RUN repositionRecord IN h-bocx100 (INPUT tt-item-doc-est-cex1.r-rowid).
               RUN getRecord        IN h-bocx100 (OUTPUT TABLE tt-item-doc-est-cex).
               FIND FIRST tt-item-doc-est-cex NO-ERROR.
               IF AVAIL tt-item-doc-est-cex THEN
                  ASSIGN de-dif                       = ROUND(((tt-item-doc-est-cex.val-desp * de-perc-dif) / 100) - tt-item-doc-est-cex.val-desp,5)
                         tt-item-doc-est-cex.val-desp = (tt-item-doc-est-cex.val-desp * de-perc-dif) / 100.

               ASSIGN de-soma = de-soma + tt-item-doc-est-cex.val-desp.

               RUN setRecord        IN h-bocx100 (INPUT TABLE tt-item-doc-est-cex).
               RUN emptyRowErrors   IN h-bocx100.
               RUN UpdateRecord     IN h-bocx100.
               IF RETURN-VALUE = "NOK":U THEN DO:
                  RUN getRowErrors IN h-bocx100 (OUTPUT TABLE RowErrors).
                  RUN piCriaErro (INPUT TABLE RowErrors, INPUT "bocx100":U).
                  NEXT.
               END.

               FIND FIRST b-item-doc-est
                    WHERE b-item-doc-est.serie-docto  = tt-item-doc-est-cex.serie-docto       
                      AND b-item-doc-est.nro-docto    = tt-item-doc-est-cex.nro-docto   
                      AND b-item-doc-est.cod-emitente = tt-item-doc-est-cex.cod-emitente
                      AND b-item-doc-est.nat-operacao = tt-item-doc-est-cex.nat-operacao 
                      AND b-item-doc-est.sequencia    = tt-item-doc-est-cex.sequencia EXCLUSIVE-LOCK NO-ERROR.
               IF AVAIL b-item-doc-est THEN DO:

                   ASSIGN b-item-doc-est.preco-total-me = b-item-doc-est.preco-total-me + de-dif
                          b-item-doc-est.preco-unit-me  = b-item-doc-est.preco-total-me.
                      
                   ASSIGN b-item-doc-est.preco-total-me = fn_ajust_dec(b-item-doc-est.preco-total-me, docum-est.mo-codigo)
                          b-item-doc-est.preco-total[1] = fn_ajust_dec(b-item-doc-est.preco-total-me * docum-est.cotacao-dia,0)
                          b-item-doc-est.preco-unit[1]  = b-item-doc-est.preco-total[1].
               END.

          END.
          /*Atualiza os itens do documento*/

          /*Atualiza a diferenca do rateio*/
          IF de-soma <> p-novo-valor THEN DO:
             FOR FIRST tt-item-doc-est-cex1 NO-LOCK
                 WHERE tt-item-doc-est-cex1.r-docto-cex = tt-docum-est-cex.r-rowid:      

                 EMPTY TEMP-TABLE rowErrors.
                 EMPTY TEMP-TABLE tt-docum-est-cex.
                 RUN repositionRecord IN h-bocx100 (INPUT tt-item-doc-est-cex1.r-rowid).
                 RUN getRecord        IN h-bocx100 (OUTPUT TABLE tt-item-doc-est-cex).
                 FIND FIRST tt-item-doc-est-cex NO-ERROR.
                 IF AVAIL tt-item-doc-est-cex THEN
                    ASSIGN tt-item-doc-est-cex.val-desp = tt-item-doc-est-cex.val-desp + (de-soma - p-novo-valor).
                 RUN setRecord        IN h-bocx100 (INPUT TABLE tt-item-doc-est-cex).
                 RUN emptyRowErrors   IN h-bocx100.
                 RUN UpdateRecord     IN h-bocx100.
                 IF RETURN-VALUE = "NOK":U THEN DO:
                    RUN getRowErrors IN h-bocx100 (OUTPUT TABLE RowErrors).
                    RUN piCriaErro (INPUT TABLE RowErrors, INPUT "bocx100":U).
                    NEXT.
                 END.
             END.
          END.
          RUN piAtualizaDocumEst.
          /*Atualiza a diferenca do rateio*/

      END.

      IF CAN-FIND(FIRST tt-erro) THEN
         UNDO, LEAVE.

      RUN pi-finalizar IN h-acomp.

      IF VALID-HANDLE(h-bocx090) THEN DELETE PROCEDURE h-bocx090.
      IF VALID-HANDLE(h-bocx100) THEN DELETE PROCEDURE h-bocx100.
      IF VALID-HANDLE(h-boin176) THEN DELETE PROCEDURE h-boin176.
    
      IF CAN-FIND(FIRST tt-erro) THEN DO:
         RUN cdp/cd0666.w (INPUT TABLE tt-erro).
      END.
      ELSE DO:
         RUN piCarregaDespesa2.
      END.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelecionaLinha V-table-Win 
PROCEDURE piSelecionaLinha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER p-browse AS INTEGER NO-UNDO.

IF p-browse = 1 THEN DO:
    
    if available tt-docum-est-cex1 then do:
        assign r-rw = rowid(tt-docum-est-cex1).
        if tt-docum-est-cex1.mark = "" then do:
            assign tt-docum-est-cex1.mark = "*":U.
        end.
        else do:
            assign tt-docum-est-cex1.mark = "".
        end.
        RUN piMudaLabel.
        {&OPEN-QUERY-brDespesa1}
        reposition brDespesa1 to rowid r-rw no-error.
    end.
    
    ASSIGN de-sum-1 = 0.
    FOR EACH  tt-docum-est-cex1
        WHERE tt-docum-est-cex1.mark = "*":U:
        ASSIGN de-sum-1 = de-sum-1 + tt-docum-est-cex1.val-desp.
    END.
    DISP de-sum-1 @ de-tot-1 WITH FRAME {&FRAME-NAME}.
END.
IF p-browse = 2 THEN DO:
    if available tt-docum-est-cex2 then do:
        assign r-rw = rowid(tt-docum-est-cex2).
        if tt-docum-est-cex2.mark = "" then do:
            assign tt-docum-est-cex2.mark = "*":U.
        end.
        else do:
            assign tt-docum-est-cex2.mark = "".
        end.
        {&OPEN-QUERY-brDespesa2}
        reposition brDespesa2 to rowid r-rw no-error.
    end.   
END.    

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
  {src/adm/template/snd-list.i "docum-est"}
  {src/adm/template/snd-list.i "tt-item-doc-est-cex1"}
  {src/adm/template/snd-list.i "tt-docum-est-cex2"}
  {src/adm/template/snd-list.i "tt-docum-est-cex1"}

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

