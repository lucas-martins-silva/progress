&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V04AD039 2.00.00.024 } /*** "010024" 03/02/2025 15:58:35  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V04AD039 MUT}
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

def new global shared var v-row-parent as rowid no-undo.                                

def var l-perc-equiv as logical.
def var i-cont       as integer.

def var de-perc-equiv         as decimal no-undo.
def var i-cod-ven-par         like cond-pagto.cod-ven-par no-undo.
def var i-valor               as integer no-undo.
def var de-per-pg             as decimal no-undo.
def var c-variavel            as char    no-undo format "x(25)".
def var i-resto               as decimal no-undo.
def var i-soma                as decimal no-undo.
def var i-nr-par              as integer no-undo.
def var h-handle-atual        as handle  no-undo.
def var c-cod-venc-par-1-temp as char    no-undo.
def var c-cod-venc-par-2-temp as char    no-undo.
def var c-cod-venc-par-3-temp as char    no-undo.
def var cLista                as char    no-undo.
def var i-cod-vencto          as integer extent 12 no-undo.
def var i-qtd-dias            as decimal no-undo.

DEF VAR cCodVencto            AS CHAR    NO-UNDO.

DEF VAR l-atualiza            AS LOGICAL NO-UNDO.
DEF VAR c-meio-pagto          AS CHAR    NO-UNDO.

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/

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
&Scoped-define EXTERNAL-TABLES cond-pagto
&Scoped-define FIRST-EXTERNAL-TABLE cond-pagto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cond-pagto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cond-pagto.num-parcelas cond-pagto.prazos[1] ~
cond-pagto.per-pg-dup[1] 
&Scoped-define ENABLED-TABLES cond-pagto
&Scoped-define FIRST-ENABLED-TABLE cond-pagto
&Scoped-Define ENABLED-OBJECTS bt-calculo bt-rateio ~
RECT-1 RECT-10 RECT-11 ~
RECT-12 RECT-2 RECT-3 RECT-5 RECT-6 RECT-7 RECT-8 RECT-9 
&Scoped-Define DISPLAYED-FIELDS cond-pagto.num-parcelas ~
cond-pagto.prazos[1] cond-pagto.per-pg-dup[1] cond-pagto.prazos[2] ~
cond-pagto.per-pg-dup[2] cond-pagto.prazos[3] cond-pagto.per-pg-dup[3] ~
cond-pagto.prazos[4] cond-pagto.per-pg-dup[4] cond-pagto.prazos[5] ~
cond-pagto.per-pg-dup[5] cond-pagto.prazos[6] cond-pagto.per-pg-dup[6] ~
cond-pagto.prazos[7] cond-pagto.per-pg-dup[7] cond-pagto.prazos[8] ~
cond-pagto.per-pg-dup[8] cond-pagto.prazos[9] cond-pagto.per-pg-dup[9] ~
cond-pagto.prazos[10] cond-pagto.per-pg-dup[10] cond-pagto.prazos[11] ~
cond-pagto.per-pg-dup[11] cond-pagto.prazos[12] cond-pagto.per-pg-dup[12] 
&Scoped-define DISPLAYED-TABLES cond-pagto
&Scoped-define FIRST-DISPLAYED-TABLE cond-pagto
&Scoped-Define DISPLAYED-OBJECTS i-qtd-dias-prazo-medio cb-cod-ven-par-1 ~
cb-meio-pagto-01 cb-cod-ven-par-2 cb-meio-pagto-02 cb-cod-ven-par-3 ~
cb-meio-pagto-03 cb-cod-ven-par-4 cb-meio-pagto-04 cb-cod-ven-par-5 ~
cb-meio-pagto-05 cb-cod-ven-par-6 cb-meio-pagto-06 cb-cod-ven-par-7 ~
cb-meio-pagto-07 cb-cod-ven-par-8 cb-meio-pagto-08 cb-cod-ven-par-9 ~
cb-meio-pagto-09 cb-cod-ven-par-10 cb-meio-pagto-10 cb-cod-ven-par-11 ~
cb-meio-pagto-11 cb-cod-ven-par-12 cb-meio-pagto-12 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS cond-pagto.prazos[1] cb-cod-ven-par-1 ~
cond-pagto.per-pg-dup[1] cond-pagto.prazos[2] cb-cod-ven-par-2 ~
cond-pagto.per-pg-dup[2] cond-pagto.prazos[3] cb-cod-ven-par-3 ~
cond-pagto.per-pg-dup[3] cond-pagto.prazos[4] cb-cod-ven-par-4 ~
cond-pagto.per-pg-dup[4] cond-pagto.prazos[5] cb-cod-ven-par-5 ~
cond-pagto.per-pg-dup[5] cond-pagto.prazos[6] cb-cod-ven-par-6 ~
cond-pagto.per-pg-dup[6] cond-pagto.prazos[7] cb-cod-ven-par-7 ~
cond-pagto.per-pg-dup[7] cond-pagto.prazos[8] cb-cod-ven-par-8 ~
cond-pagto.per-pg-dup[8] cond-pagto.prazos[9] cb-cod-ven-par-9 ~
cond-pagto.per-pg-dup[9] cond-pagto.prazos[10] cb-cod-ven-par-10 ~
cond-pagto.per-pg-dup[10] cond-pagto.prazos[11] cb-cod-ven-par-11 ~
cond-pagto.per-pg-dup[11] cond-pagto.prazos[12] cb-cod-ven-par-12 ~
cond-pagto.per-pg-dup[12] ~
cb-meio-pagto-01 cb-meio-pagto-02 cb-meio-pagto-03 cb-meio-pagto-04 cb-meio-pagto-05 ~
cb-meio-pagto-06 cb-meio-pagto-07 cb-meio-pagto-08 cb-meio-pagto-09 ~
cb-meio-pagto-10 cb-meio-pagto-11 cb-meio-pagto-12
&Scoped-define ADM-MODIFY-FIELDS i-qtd-dias-prazo-medio cb-cod-ven-par-1 ~
cb-cod-ven-par-2 cb-cod-ven-par-3 cb-cod-ven-par-4 cb-cod-ven-par-5 ~
cb-cod-ven-par-6 cb-cod-ven-par-7 cb-cod-ven-par-8 cb-cod-ven-par-9 ~
cb-cod-ven-par-10 cb-cod-ven-par-11 cb-cod-ven-par-12 ~
cb-meio-pagto-01 cb-meio-pagto-02 cb-meio-pagto-03 cb-meio-pagto-04 cb-meio-pagto-05 ~
cb-meio-pagto-06 cb-meio-pagto-07 cb-meio-pagto-08 cb-meio-pagto-09 ~
cb-meio-pagto-10 cb-meio-pagto-11 cb-meio-pagto-12
&Scoped-define List-4 cond-pagto.prazos[1] cb-cod-ven-par-1 ~
cond-pagto.per-pg-dup[1] cond-pagto.prazos[2] cb-cod-ven-par-2 ~
cond-pagto.per-pg-dup[2] cond-pagto.prazos[3] cb-cod-ven-par-3 ~
cond-pagto.per-pg-dup[3] cond-pagto.prazos[4] cb-cod-ven-par-4 ~
cond-pagto.per-pg-dup[4] cond-pagto.prazos[5] cb-cod-ven-par-5 ~
cond-pagto.per-pg-dup[5] cond-pagto.prazos[6] cb-cod-ven-par-6 ~
cond-pagto.per-pg-dup[6] cond-pagto.prazos[7] cb-cod-ven-par-7 ~
cond-pagto.per-pg-dup[7] cond-pagto.prazos[8] cb-cod-ven-par-8 ~
cond-pagto.per-pg-dup[8] cond-pagto.prazos[9] cb-cod-ven-par-9 ~
cond-pagto.per-pg-dup[9] cond-pagto.prazos[10] cb-cod-ven-par-10 ~
cond-pagto.per-pg-dup[10] cond-pagto.prazos[11] cb-cod-ven-par-11 ~
cond-pagto.per-pg-dup[11] cond-pagto.prazos[12] cb-cod-ven-par-12 ~
cond-pagto.per-pg-dup[12] ~
cb-meio-pagto-01 cb-meio-pagto-02 cb-meio-pagto-03 cb-meio-pagto-04 cb-meio-pagto-05 ~
cb-meio-pagto-06 cb-meio-pagto-07 cb-meio-pagto-08 cb-meio-pagto-09 ~
cb-meio-pagto-10 cb-meio-pagto-11 cb-meio-pagto-12


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
DEFINE BUTTON bt-calculo 
     IMAGE-UP FILE "image\im-cq":U
     IMAGE-INSENSITIVE FILE "image\ii-cq":U
     LABEL "" 
     SIZE 3.72 BY 1.17.

DEFINE BUTTON bt-rateio 
     LABEL "" 
     SIZE 8.43 BY 1.13.

DEFINE VARIABLE cb-cod-ven-par-1 AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     VIEW-AS COMBO-BOX INNER-LINES 9
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cod-ven-par-10 AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     VIEW-AS COMBO-BOX INNER-LINES 9
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cod-ven-par-11 AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     VIEW-AS COMBO-BOX INNER-LINES 9
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cod-ven-par-12 AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     VIEW-AS COMBO-BOX INNER-LINES 9
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cod-ven-par-2 AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     VIEW-AS COMBO-BOX INNER-LINES 9
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cod-ven-par-3 AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     VIEW-AS COMBO-BOX INNER-LINES 9
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cod-ven-par-4 AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     VIEW-AS COMBO-BOX INNER-LINES 9
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cod-ven-par-5 AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     VIEW-AS COMBO-BOX INNER-LINES 9
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cod-ven-par-6 AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     VIEW-AS COMBO-BOX INNER-LINES 9
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cod-ven-par-7 AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     VIEW-AS COMBO-BOX INNER-LINES 9
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cod-ven-par-8 AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     VIEW-AS COMBO-BOX INNER-LINES 9
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cod-ven-par-9 AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     VIEW-AS COMBO-BOX INNER-LINES 9
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-meio-pagto-01 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE cb-meio-pagto-02 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE cb-meio-pagto-03 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE cb-meio-pagto-04 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE cb-meio-pagto-05 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE cb-meio-pagto-06 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE cb-meio-pagto-07 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE cb-meio-pagto-08 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE cb-meio-pagto-09 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE cb-meio-pagto-10 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE cb-meio-pagto-11 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE cb-meio-pagto-12 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE fi-01 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 6 BY .63 NO-UNDO.

DEFINE VARIABLE fi-02 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 6 BY .63 NO-UNDO.

DEFINE VARIABLE fi-03 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 20.57 BY .63 NO-UNDO.

DEFINE VARIABLE fi-04 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10.29 BY .63 NO-UNDO.

DEFINE VARIABLE fi-05 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 6 BY .63 NO-UNDO.

DEFINE VARIABLE fi-06 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 6 BY .63 NO-UNDO.

DEFINE VARIABLE fi-07 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 20.57 BY .63 NO-UNDO.

DEFINE VARIABLE fi-08 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9.14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-09 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 2 BY .63 NO-UNDO.

DEFINE VARIABLE fi-10 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 2 BY .63 NO-UNDO.

DEFINE VARIABLE i-qtd-dias-prazo-medio AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 3 BY .88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     bt-calculo AT ROW 10.63 COL 77.57
     i-qtd-dias-prazo-medio AT ROW 10.75 COL 69.43 COLON-ALIGNED
     cond-pagto.num-parcelas AT ROW 1.25 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     bt-rateio AT ROW 1.17 COL 54

     fi-01 AT ROW 3    COL 2.5   COLON-ALIGNED NO-LABEL
     fi-02 AT ROW 3.54 COL 2.5   COLON-ALIGNED NO-LABEL
     fi-03 AT ROW 3.54 COL 7.6   COLON-ALIGNED NO-LABEL
     fi-04 AT ROW 3.54 COL 29    COLON-ALIGNED NO-LABEL
     fi-09 AT ROW 3.54 COL 38.9  COLON-ALIGNED NO-LABEL

     fi-05 AT ROW 3    COL 46.7  COLON-ALIGNED NO-LABEL
     fi-06 AT ROW 3.54 COL 46.7  COLON-ALIGNED NO-LABEL
     fi-07 AT ROW 3.54 COL 51.6  COLON-ALIGNED NO-LABEL
     fi-08 AT ROW 3.54 COL 73    COLON-ALIGNED NO-LABEL
     fi-10 AT ROW 3.54 COL 82.7  COLON-ALIGNED NO-LABEL

     cond-pagto.prazos[1] AT ROW 4.5 COL 2.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cb-cod-ven-par-1 AT ROW 4.50 COL 7.29 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[1] AT ROW 4.5 COL 29.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     
     cb-meio-pagto-01 AT ROW 4.5 COL 38.14 COLON-ALIGNED NO-LABEL HELP "Meio Pagamento"
     cond-pagto.prazos[2] AT ROW 5.5 COL 2.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cb-cod-ven-par-2 AT ROW 5.50 COL 7.29 COLON-ALIGNED NO-LABEL
     
     cond-pagto.per-pg-dup[2] AT ROW 5.5 COL 29.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     cb-meio-pagto-02 AT ROW 5.5 COL 38.14 COLON-ALIGNED NO-LABEL HELP "Meio Pagamento"
     
     cond-pagto.prazos[3] AT ROW 6.5 COL 2.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cb-cod-ven-par-3 AT ROW 6.50 COL 7.29 COLON-ALIGNED NO-LABEL
     
     cond-pagto.per-pg-dup[3] AT ROW 6.5 COL 29.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     cb-meio-pagto-03 AT ROW 6.5 COL 38.14 COLON-ALIGNED NO-LABEL HELP "Meio Pagamento"
     cond-pagto.prazos[4] AT ROW 7.5 COL 2.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cb-cod-ven-par-4 AT ROW 7.50 COL 7.29 COLON-ALIGNED NO-LABEL
     
     cond-pagto.per-pg-dup[4] AT ROW 7.5 COL 29.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     cb-meio-pagto-04 AT ROW 7.5 COL 38.14 COLON-ALIGNED NO-LABEL HELP "Meio Pagamento"
     cond-pagto.prazos[5] AT ROW 8.5 COL 2.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cb-cod-ven-par-5 AT ROW 8.50 COL 7.29 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[5] AT ROW 8.5 COL 29.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     cb-meio-pagto-05 AT ROW 8.5 COL 38.14 COLON-ALIGNED NO-LABEL HELP "Meio Pagamento"
     cond-pagto.prazos[6] AT ROW 9.5 COL 2.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cb-cod-ven-par-6 AT ROW 9.50 COL 7.29 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[6] AT ROW 9.5 COL 29.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     cb-meio-pagto-06 AT ROW 9.5 COL 38.14 COLON-ALIGNED NO-LABEL HELP "Meio Pagamento"
     cond-pagto.prazos[7] AT ROW 4.5 COL 46.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cb-cod-ven-par-7 AT ROW 4.50 COL 51.29 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     cond-pagto.per-pg-dup[7] AT ROW 4.5 COL 73.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     cb-meio-pagto-07 AT ROW 4.5 COL 82.14 COLON-ALIGNED NO-LABEL HELP "Meio Pagamento"
     cond-pagto.prazos[8] AT ROW 5.5 COL 46.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cb-cod-ven-par-8 AT ROW 5.50 COL 51.29 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[8] AT ROW 5.5 COL 73.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     cb-meio-pagto-08 AT ROW 5.5 COL 82.14 COLON-ALIGNED NO-LABEL HELP "Meio Pagamento"
     cond-pagto.prazos[9] AT ROW 6.5 COL 46.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cb-cod-ven-par-9 AT ROW 6.50 COL 51.29 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[9] AT ROW 6.5 COL 73.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     cb-meio-pagto-09 AT ROW 6.5 COL 82.14 COLON-ALIGNED NO-LABEL HELP "Meio Pagamento"
     cond-pagto.prazos[10] AT ROW 7.5 COL 46.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cb-cod-ven-par-10 AT ROW 7.50 COL 51.29 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[10] AT ROW 7.5 COL 73.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     cb-meio-pagto-10 AT ROW 7.5 COL 82.14 COLON-ALIGNED NO-LABEL HELP "Meio Pagamento"
     cond-pagto.prazos[11] AT ROW 8.5 COL 46.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cb-cod-ven-par-11 AT ROW 8.50 COL 51.29 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[11] AT ROW 8.5 COL 73.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     cb-meio-pagto-11 AT ROW 8.5 COL 82.14 COLON-ALIGNED NO-LABEL HELP "Meio Pagamento"
     cond-pagto.prazos[12] AT ROW 9.5 COL 46.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cb-cod-ven-par-12 AT ROW 9.50 COL 51.29 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[12] AT ROW 9.5 COL 73.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     cb-meio-pagto-12 AT ROW 9.5 COL 82.14 COLON-ALIGNED NO-LABEL HELP "Meio Pagamento"
     "1" VIEW-AS  TEXT SIZE 1.29 BY .63 AT ROW 4.63 COL 2
     "2" VIEW-AS  TEXT SIZE 1.29 BY .63 AT ROW 5.63 COL 2
     "3" VIEW-AS  TEXT SIZE 1.29 BY .63 AT ROW 6.63 COL 1.86
     "4" VIEW-AS  TEXT SIZE 1.29 BY .63 AT ROW 7.63 COL 1.86
     "5" VIEW-AS  TEXT SIZE 1.29 BY .63 AT ROW 8.63 COL 1.86
     "6" VIEW-AS  TEXT SIZE 1.29 BY .63 AT ROW 9.63 COL 1.86

     "7" VIEW-AS  TEXT SIZE 1.29 BY .63 AT ROW 4.63 COL 45.9
     "8" VIEW-AS  TEXT SIZE 1.29 BY .63 AT ROW 5.63 COL 45.9
     "9" VIEW-AS  TEXT SIZE 1.29 BY .63 AT ROW 6.63 COL 45.9
     "10" VIEW-AS TEXT SIZE 2.29 BY .63 AT ROW 7.63 COL 45.6
     "11" VIEW-AS TEXT SIZE 2.29 BY .63 AT ROW 8.63 COL 45.6
     "12" VIEW-AS TEXT SIZE 2.29 BY .63 AT ROW 9.63 COL 45.6
     
     
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     RECT-1  AT ROW 4.5  COL 1
     RECT-2  AT ROW 5.5  COL 1
     RECT-3  AT ROW 6.5  COL 1
     RECT-4  AT ROW 7.5  COL 1
     RECT-5  AT ROW 8.5  COL 1
     RECT-6  AT ROW 9.5  COL 1
     
     RECT-7  AT ROW 4.5  COL 45
     RECT-8  AT ROW 5.5  COL 45
     RECT-9  AT ROW 6.5  COL 45
     RECT-10 AT ROW 7.5  COL 45
     RECT-11 AT ROW 8.5  COL 45
     RECT-12 AT ROW 9.5  COL 45
     
     
     
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.cond-pagto
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
         HEIGHT             = 10.83
         WIDTH              = 86.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_fnctrad.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 10.83
       FRAME f-main:WIDTH            = 86.43.

/* SETTINGS FOR COMBO-BOX cb-cod-ven-par-1 IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR COMBO-BOX cb-cod-ven-par-10 IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR COMBO-BOX cb-cod-ven-par-11 IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR COMBO-BOX cb-cod-ven-par-12 IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR COMBO-BOX cb-cod-ven-par-2 IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR COMBO-BOX cb-cod-ven-par-3 IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR COMBO-BOX cb-cod-ven-par-4 IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR COMBO-BOX cb-cod-ven-par-5 IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR COMBO-BOX cb-cod-ven-par-6 IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR COMBO-BOX cb-cod-ven-par-7 IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR COMBO-BOX cb-cod-ven-par-8 IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR COMBO-BOX cb-cod-ven-par-9 IN FRAME f-main
   NO-ENABLE 2 3 4                                                      */
/* SETTINGS FOR FILL-IN fi-01 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-02 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-03 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-04 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-05 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-06 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-07 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-08 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN i-qtd-dias-prazo-medio IN FRAME f-main
   NO-ENABLE 3                                                          */
ASSIGN 
       i-qtd-dias-prazo-medio:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN cond-pagto.per-pg-dup[10] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.per-pg-dup[11] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.per-pg-dup[12] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.per-pg-dup[1] IN FRAME f-main
   2 4                                                                  */
/* SETTINGS FOR FILL-IN cond-pagto.per-pg-dup[2] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.per-pg-dup[3] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.per-pg-dup[4] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.per-pg-dup[5] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.per-pg-dup[6] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.per-pg-dup[7] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.per-pg-dup[8] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.per-pg-dup[9] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.prazos[10] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.prazos[11] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.prazos[12] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.prazos[1] IN FRAME f-main
   2 4                                                                  */
/* SETTINGS FOR FILL-IN cond-pagto.prazos[2] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.prazos[3] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.prazos[4] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.prazos[5] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.prazos[6] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.prazos[7] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.prazos[8] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN cond-pagto.prazos[9] IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR RECTANGLE RECT-4 IN FRAME f-main
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

&Scoped-define SELF-NAME bt-calculo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-calculo V-table-Win
ON CHOOSE OF bt-calculo IN FRAME f-main
DO:
  assign i-cod-vencto[1]  = {diinc/i02di165.i 06 cb-cod-ven-par-1 :screen-value in frame {&frame-name}}.
  assign i-cod-vencto[2]  = {diinc/i02di165.i 06 cb-cod-ven-par-2 :screen-value in frame {&frame-name}}.
  assign i-cod-vencto[3]  = {diinc/i02di165.i 06 cb-cod-ven-par-3 :screen-value in frame {&frame-name}}.
  assign i-cod-vencto[4]  = {diinc/i02di165.i 06 cb-cod-ven-par-4 :screen-value in frame {&frame-name}}.
  assign i-cod-vencto[5]  = {diinc/i02di165.i 06 cb-cod-ven-par-5 :screen-value in frame {&frame-name}}.
  assign i-cod-vencto[6]  = {diinc/i02di165.i 06 cb-cod-ven-par-6 :screen-value in frame {&frame-name}}.
  assign i-cod-vencto[7]  = {diinc/i02di165.i 06 cb-cod-ven-par-7 :screen-value in frame {&frame-name}}.
  assign i-cod-vencto[8]  = {diinc/i02di165.i 06 cb-cod-ven-par-8 :screen-value in frame {&frame-name}}.
  assign i-cod-vencto[9]  = {diinc/i02di165.i 06 cb-cod-ven-par-9 :screen-value in frame {&frame-name}}.
  assign i-cod-vencto[10] = {diinc/i02di165.i 06 cb-cod-ven-par-10:screen-value in frame {&frame-name}}.
  assign i-cod-vencto[11] = {diinc/i02di165.i 06 cb-cod-ven-par-11:screen-value in frame {&frame-name}}.
  assign i-cod-vencto[12] = {diinc/i02di165.i 06 cb-cod-ven-par-12:screen-value in frame {&frame-name}}.

  assign i-cont = 1.
  do while i-cont <= input frame {&frame-name} cond-pagto.num-parcelas:
     if i-cod-vencto[i-cont] = 1 then 
        assign i-qtd-dias = i-qtd-dias + (input frame {&frame-name} cond-pagto.prazos[i-cont] *
                                          input frame {&frame-name} cond-pagto.per-pg-dup[i-cont]) / 100.

     if i-cod-vencto[i-cont] = 2 then 
        assign i-qtd-dias = i-qtd-dias + (0 * input frame {&frame-name} cond-pagto.per-pg-dup[i-cont]) / 100.

     if i-cod-vencto[i-cont] = 3 then 
        assign i-qtd-dias = i-qtd-dias + (0 * input frame {&frame-name} cond-pagto.per-pg-dup[i-cont]) / 100.

     if i-cod-vencto[i-cont] = 4 then 
        assign i-qtd-dias = i-qtd-dias + (0 * input frame {&frame-name} cond-pagto.per-pg-dup[i-cont]) / 100.

     if i-cod-vencto[i-cont] = 5 then 
        assign i-qtd-dias = i-qtd-dias + ((5 + input frame {&frame-name} cond-pagto.prazos[i-cont]) * 
                                           input frame {&frame-name} cond-pagto.per-pg-dup[i-cont]) / 100.

     if i-cod-vencto[i-cont] = 6 then 
        assign i-qtd-dias = i-qtd-dias + ((8 + input frame {&frame-name} cond-pagto.prazos[i-cont]) * 
                                           input frame {&frame-name} cond-pagto.per-pg-dup[i-cont]) / 100.

     if i-cod-vencto[i-cont] = 7 then 
        assign i-qtd-dias = i-qtd-dias + ((15 + input frame {&frame-name} cond-pagto.prazos[i-cont]) * 
                                           input frame {&frame-name} cond-pagto.per-pg-dup[i-cont]) / 100.

     if i-cod-vencto[i-cont] = 8 then 
        assign i-qtd-dias = i-qtd-dias + ((4 + input frame {&frame-name} cond-pagto.prazos[i-cont]) * 
                                           input frame {&frame-name} cond-pagto.per-pg-dup[i-cont]) / 100.

     if i-cod-vencto[i-cont] = 9 then 
        assign i-qtd-dias = i-qtd-dias + (0 * input frame {&frame-name} cond-pagto.per-pg-dup[i-cont]) / 100.

     i-cont = i-cont + 1.
  end.

  assign i-qtd-dias-prazo-medio:screen-value in frame {&frame-name} = string(trunc(i-qtd-dias, 2)).

  assign i-qtd-dias = 0.

  if cond-pagto.num-parcelas:sensitive in frame {&frame-name} = no  then
       disable bt-calculo with frame {&frame-name}.
  else enable bt-calculo with frame {&frame-name}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-rateio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-rateio V-table-Win
ON CHOOSE OF bt-rateio IN FRAME f-main
DO:
  assign i-cont = int(input frame {&frame-name} cond-pagto.num-parcelas:screen-value) + 1. 
   do while i-cont <= 12:
      if i-cont = 1 then
         assign cond-pagto.prazos[1]:screen-value in frame {&frame-name} = "0".      
      if i-cont = 2 then
         assign cond-pagto.prazos[2]:screen-value in frame {&frame-name} = "0".
      if i-cont = 3 then
         assign cond-pagto.prazos[3]:screen-value in frame {&frame-name} = "0".
      if i-cont = 4 then      
         assign cond-pagto.prazos[4]:screen-value in frame {&frame-name} = "0".
      if i-cont = 5 then
         assign cond-pagto.prazos[5]:screen-value in frame {&frame-name} = "0".      
      if i-cont = 6 then
         assign cond-pagto.prazos[6]:screen-value in frame {&frame-name} = "0".      
      if i-cont = 7 then
         assign cond-pagto.prazos[7]:screen-value in frame {&frame-name} = "0".      
      if i-cont = 8 then
         assign cond-pagto.prazos[8]:screen-value in frame {&frame-name} = "0".      
      if i-cont = 9 then
         assign cond-pagto.prazos[9]:screen-value in frame {&frame-name} = "0".      
      if i-cont = 10 then
         assign cond-pagto.prazos[10]:screen-value in frame {&frame-name} = "0".      
      if i-cont = 11 then                                       
         assign cond-pagto.prazos[11]:screen-value in frame {&frame-name} = "0".
      if i-cont = 12 then
         assign cond-pagto.prazos[12]:screen-value in frame {&frame-name} = "0".
     i-cont = i-cont + 1.
   end.

    assign cond-pagto.per-pg-dup[1]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[2]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[3]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[4]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[5]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[6]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[7]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[8]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[9]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[10]:screen-value in frame {&frame-name} = " "
           cond-pagto.per-pg-dup[11]:screen-value in frame {&frame-name} = " "
           cond-pagto.per-pg-dup[12]:screen-value in frame {&frame-name} = " ".

    RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).

     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif                                  

   if  i-valor <> 2  and i-valor <> 3 and i-valor <> 4 then do:
           de-perc-equiv = trunc(100 / input frame {&frame-name} cond-pagto.num-parcelas,2).
           assign i-resto = 0
                  i-soma = de-perc-equiv * (input frame {&frame-name} cond-pagto.num-parcelas).
                  i-resto = 100 - i-soma.
           if input frame {&frame-name} cond-pagto.num-parcelas >= 1 then  
              assign cond-pagto.per-pg-dup[1]:screen-value = string(de-perc-equiv)
/*                     cb-cod-ven-par-1:screen-value in frame {&frame-name} = cb-cod-ven-par-1:entry(i-valor)*/.
           if input frame {&frame-name} cond-pagto.num-parcelas >= 2 then 
              assign cond-pagto.per-pg-dup[2]:screen-value = string(de-perc-equiv)
/*                     cb-cod-ven-par-2:screen-value in frame {&frame-name} = cb-cod-ven-par-2:entry(i-valor)*/.
           if input frame {&frame-name} cond-pagto.num-parcelas  >= 3 then 
              assign cond-pagto.per-pg-dup[3]:screen-value = string(de-perc-equiv)             
/*                     cb-cod-ven-par-3:screen-value in frame {&frame-name} = cb-cod-ven-par-3:entry(i-valor)*/.
           if input frame {&frame-name} cond-pagto.num-parcelas  >= 4 then
              assign cond-pagto.per-pg-dup[4]:screen-value = string(de-perc-equiv)
/*                     cb-cod-ven-par-4:screen-value in frame {&frame-name} = cb-cod-ven-par-4:entry(i-valor)*/.
           if input frame {&frame-name} cond-pagto.num-parcelas  >= 5 then
              assign cond-pagto.per-pg-dup[5]:screen-value = string(de-perc-equiv)
/*                     cb-cod-ven-par-5:screen-value in frame {&frame-name} = cb-cod-ven-par-5:entry(i-valor)*/.
           if input frame {&frame-name} cond-pagto.num-parcelas  >= 6 then
              assign cond-pagto.per-pg-dup[6]:screen-value = string(de-perc-equiv)
/*                     cb-cod-ven-par-6:screen-value in frame {&frame-name} = cb-cod-ven-par-6:entry(i-valor)*/.
           if input frame {&frame-name} cond-pagto.num-parcelas  >= 7 then
              assign cond-pagto.per-pg-dup[7]:screen-value = string(de-perc-equiv)                                       
/*                     cb-cod-ven-par-7:screen-value in frame {&frame-name} = cb-cod-ven-par-7:entry(i-valor)*/.
           if input frame {&frame-name} cond-pagto.num-parcelas  >= 8 then
              assign cond-pagto.per-pg-dup[8]:screen-value = string(de-perc-equiv)
/*                     cb-cod-ven-par-8:screen-value in frame {&frame-name} = cb-cod-ven-par-8:entry(i-valor)*/.
           if input frame {&frame-name} cond-pagto.num-parcelas  >= 9 then
              assign cond-pagto.per-pg-dup[9]:screen-value = string(de-perc-equiv)             
/*                     cb-cod-ven-par-9:screen-value in frame {&frame-name} = cb-cod-ven-par-9:entry(i-valor)*/.
           if input frame {&frame-name} cond-pagto.num-parcelas  >= 10 then
              assign cond-pagto.per-pg-dup[10]:screen-value = string(de-perc-equiv)
/*                     cb-cod-ven-par-10:screen-value in frame {&frame-name} = cb-cod-ven-par-10:entry(i-valor)*/.
           if input frame {&frame-name} cond-pagto.num-parcelas  >= 11 then
              assign cond-pagto.per-pg-dup[11]:screen-value = string(de-perc-equiv)             
/*                     cb-cod-ven-par-11:screen-value in frame {&frame-name} = cb-cod-ven-par-11:entry(i-valor)*/.
           if input frame {&frame-name} cond-pagto.num-parcelas  >= 12 then
              assign cond-pagto.per-pg-dup[12]:screen-value = string(de-perc-equiv)
/*                     cb-cod-ven-par-12:screen-value in frame {&frame-name} = cb-cod-ven-par-12:entry(i-valor)*/.

           /* Acrescenta o resto a ultima parcela */

           if input frame {&frame-name} cond-pagto.num-parcelas  = 3 then           
              assign cond-pagto.per-pg-dup[3]:screen-value = string(de-perc-equiv + i-resto). 
           if input frame {&frame-name} cond-pagto.num-parcelas  = 4 then           
              assign cond-pagto.per-pg-dup[4]:screen-value = string(de-perc-equiv + i-resto). 
           if input frame {&frame-name} cond-pagto.num-parcelas  = 6 then           
              assign cond-pagto.per-pg-dup[6]:screen-value = string(de-perc-equiv + i-resto). 
           if input frame {&frame-name} cond-pagto.num-parcelas  = 7 then           
              assign cond-pagto.per-pg-dup[7]:screen-value = string(de-perc-equiv + i-resto).            
           if input frame {&frame-name} cond-pagto.num-parcelas  = 8 then           
              assign cond-pagto.per-pg-dup[8]:screen-value = string(de-perc-equiv + i-resto). 
           if input frame {&frame-name} cond-pagto.num-parcelas  = 9 then           
              assign cond-pagto.per-pg-dup[9]:screen-value = string(de-perc-equiv + i-resto). 
           if input frame {&frame-name} cond-pagto.num-parcelas  = 11 then           
              assign cond-pagto.per-pg-dup[11]:screen-value = string(de-perc-equiv + i-resto). 
           if input frame {&frame-name} cond-pagto.num-parcelas  = 12 then           
              assign cond-pagto.per-pg-dup[12]:screen-value = string(de-perc-equiv + i-resto).     
   end.


 if input frame {&frame-name} cond-pagto.num-parcelas = 1 or
     cond-pagto.num-parcelas:sensitive in frame {&frame-name} = no  then
       disable bt-rateio with frame {&frame-name}.
  else enable bt-rateio with frame {&frame-name}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-meio-pagto-01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-01 V-table-Win
ON F5 OF cb-meio-pagto-01 IN FRAME f-main
DO:
    
    ASSIGN c-meio-pagto = "":U
           c-meio-pagto = (IF AVAIL cond-pagto
                           THEN TRIM(SUBSTRING(cond-pagto.char-1,46,2))
                           ELSE "":U).

    RUN pi-Formas-Pagto-NFe (INPUT-OUTPUT c-meio-pagto).

    ASSIGN cb-meio-pagto-01:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(c-meio-pagto).
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-01 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-meio-pagto-01 IN FRAME f-main
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME cb-meio-pagto-02
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-02 V-table-Win
ON F5 OF cb-meio-pagto-02 IN FRAME f-main
DO:
    
    ASSIGN c-meio-pagto = "":U
           c-meio-pagto = (IF AVAIL cond-pagto
                           THEN TRIM(SUBSTRING(cond-pagto.char-1,48,2))
                           ELSE "":U).

    RUN pi-Formas-Pagto-NFe (INPUT-OUTPUT c-meio-pagto).

    ASSIGN cb-meio-pagto-02:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(c-meio-pagto).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-meio-pagto-02
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-02 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-meio-pagto-02 IN FRAME f-main
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME cb-meio-pagto-03
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-03 V-table-Win
ON F5 OF cb-meio-pagto-03 IN FRAME f-main
DO:
    
    ASSIGN c-meio-pagto = "":U
           c-meio-pagto = (IF AVAIL cond-pagto
                           THEN TRIM(SUBSTRING(cond-pagto.char-1,50,2))
                           ELSE "":U).

    RUN pi-Formas-Pagto-NFe (INPUT-OUTPUT c-meio-pagto).

    ASSIGN cb-meio-pagto-03:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(c-meio-pagto).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-meio-pagto-03
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-03 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-meio-pagto-03 IN FRAME f-main
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME cb-meio-pagto-04
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-04 V-table-Win
ON F5 OF cb-meio-pagto-04 IN FRAME f-main
DO:
    
    ASSIGN c-meio-pagto = "":U
           c-meio-pagto = (IF AVAIL cond-pagto
                           THEN TRIM(SUBSTRING(cond-pagto.char-1,52,2))
                           ELSE "":U).

    RUN pi-Formas-Pagto-NFe (INPUT-OUTPUT c-meio-pagto).

    ASSIGN cb-meio-pagto-04:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(c-meio-pagto).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-meio-pagto-04
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-04 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-meio-pagto-04 IN FRAME f-main
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME cb-meio-pagto-05
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-05 V-table-Win
ON F5 OF cb-meio-pagto-05 IN FRAME f-main
DO:
    
    ASSIGN c-meio-pagto = "":U
           c-meio-pagto = (IF AVAIL cond-pagto
                           THEN TRIM(SUBSTRING(cond-pagto.char-1,54,2))
                           ELSE "":U).

    RUN pi-Formas-Pagto-NFe (INPUT-OUTPUT c-meio-pagto).

    ASSIGN cb-meio-pagto-05:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(c-meio-pagto).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-meio-pagto-05
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-05 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-meio-pagto-05 IN FRAME f-main
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME cb-meio-pagto-06
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-06 V-table-Win
ON F5 OF cb-meio-pagto-06 IN FRAME f-main
DO:
    
    ASSIGN c-meio-pagto = "":U
           c-meio-pagto = (IF AVAIL cond-pagto
                           THEN TRIM(SUBSTRING(cond-pagto.char-1,56,2))
                           ELSE "":U).

    RUN pi-Formas-Pagto-NFe (INPUT-OUTPUT c-meio-pagto).

    ASSIGN cb-meio-pagto-06:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(c-meio-pagto).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-meio-pagto-06
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-06 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-meio-pagto-06 IN FRAME f-main
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME cb-meio-pagto-07
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-07 V-table-Win
ON F5 OF cb-meio-pagto-07 IN FRAME f-main
DO:
    
    ASSIGN c-meio-pagto = "":U
           c-meio-pagto = (IF AVAIL cond-pagto
                           THEN TRIM(SUBSTRING(cond-pagto.char-1,58,2))
                           ELSE "":U).

    RUN pi-Formas-Pagto-NFe (INPUT-OUTPUT c-meio-pagto).

    ASSIGN cb-meio-pagto-07:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(c-meio-pagto).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME cb-meio-pagto-07
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-07 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-meio-pagto-07 IN FRAME f-main
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME cb-meio-pagto-08
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-08 V-table-Win
ON F5 OF cb-meio-pagto-08 IN FRAME f-main
DO:
    
    ASSIGN c-meio-pagto = "":U
           c-meio-pagto = (IF AVAIL cond-pagto
                           THEN TRIM(SUBSTRING(cond-pagto.char-1,60,2))
                           ELSE "":U).

    RUN pi-Formas-Pagto-NFe (INPUT-OUTPUT c-meio-pagto).

    ASSIGN cb-meio-pagto-08:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(c-meio-pagto).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME cb-meio-pagto-08
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-08 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-meio-pagto-08 IN FRAME f-main
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME cb-meio-pagto-09
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-09 V-table-Win
ON F5 OF cb-meio-pagto-09 IN FRAME f-main
DO:
    
    ASSIGN c-meio-pagto = "":U
           c-meio-pagto = (IF AVAIL cond-pagto
                           THEN TRIM(SUBSTRING(cond-pagto.char-1,62,2))
                           ELSE "":U).

    RUN pi-Formas-Pagto-NFe (INPUT-OUTPUT c-meio-pagto).

    ASSIGN cb-meio-pagto-09:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(c-meio-pagto).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-meio-pagto-09
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-09 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-meio-pagto-09 IN FRAME f-main
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-meio-pagto-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-10 V-table-Win
ON F5 OF cb-meio-pagto-10 IN FRAME f-main
DO:
    
    ASSIGN c-meio-pagto = "":U
           c-meio-pagto = (IF AVAIL cond-pagto
                           THEN TRIM(SUBSTRING(cond-pagto.char-1,64,2))
                           ELSE "":U).

    RUN pi-Formas-Pagto-NFe (INPUT-OUTPUT c-meio-pagto).

    ASSIGN cb-meio-pagto-10:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(c-meio-pagto).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-meio-pagto-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-10 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-meio-pagto-10 IN FRAME f-main
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME cb-meio-pagto-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-11 V-table-Win
ON F5 OF cb-meio-pagto-11 IN FRAME f-main
DO:
    
    ASSIGN c-meio-pagto = "":U
           c-meio-pagto = (IF AVAIL cond-pagto
                           THEN TRIM(SUBSTRING(cond-pagto.char-1,66,2))
                           ELSE "":U).

    RUN pi-Formas-Pagto-NFe (INPUT-OUTPUT c-meio-pagto).

    ASSIGN cb-meio-pagto-11:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(c-meio-pagto).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-meio-pagto-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-11 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-meio-pagto-11 IN FRAME f-main
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME cb-meio-pagto-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-12 V-table-Win
ON F5 OF cb-meio-pagto-12 IN FRAME f-main
DO:
    
    ASSIGN c-meio-pagto = "":U
           c-meio-pagto = (IF AVAIL cond-pagto
                           THEN TRIM(SUBSTRING(cond-pagto.char-1,68,2))
                           ELSE "":U).

    RUN pi-Formas-Pagto-NFe (INPUT-OUTPUT c-meio-pagto).

    ASSIGN cb-meio-pagto-12:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(c-meio-pagto).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-meio-pagto-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-meio-pagto-12 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-meio-pagto-12 IN FRAME f-main
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.num-parcelas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.num-parcelas V-table-Win
ON LEAVE OF cond-pagto.num-parcelas IN FRAME f-main /* Num Parcelas */
DO:

  /* habilita campos */

   assign i-cont = 1.
   do while i-cont <= 12:
      enable  cond-pagto.prazos[i-cont] with frame {&frame-name}.
      enable  cond-pagto.per-pg-dup[i-cont]  with frame {&frame-name}.
      i-cont = i-cont + 1.
   end.
   enable  cb-cod-ven-par-1  
           cb-cod-ven-par-2  
           cb-cod-ven-par-3  
           cb-cod-ven-par-4  
           cb-cod-ven-par-5  
           cb-cod-ven-par-6  
           cb-cod-ven-par-7  
           cb-cod-ven-par-8  
           cb-cod-ven-par-9  
           cb-cod-ven-par-10 
           cb-cod-ven-par-11 
           cb-cod-ven-par-12 with frame {&frame-name}.

   IF  i-pais-impto-usuario = 1 THEN
       enable  cb-meio-pagto-01 
               cb-meio-pagto-02 
               cb-meio-pagto-03 
               cb-meio-pagto-04 
               cb-meio-pagto-05 
               cb-meio-pagto-06 
               cb-meio-pagto-07 
               cb-meio-pagto-08 
               cb-meio-pagto-09 
               cb-meio-pagto-10
               cb-meio-pagto-11
               cb-meio-pagto-12 with frame {&frame-name}.

  /* Desabilita campos conforme numero parcelas */
  RUN PI-DesabilitaCampos.

  apply 'choose' to bt-rateio in frame {&frame-name}.   

  apply 'entry' to cond-pagto.prazos[1] in frame {&frame-name}.
/*return no-apply.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.per-pg-dup[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.per-pg-dup[1] V-table-Win
ON LEAVE OF cond-pagto.per-pg-dup[1] IN FRAME f-main /* % Pg Dup[1] */
DO:
/*  run pi-calcula-percentual (input cond-pagto.per-pg-dup[1]).*/
    /*{cdp/cd0404.i  &campo = cond-pagto.per-pg-dup[1]}.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.prazos[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.prazos[10] V-table-Win
ON ENTRY OF cond-pagto.prazos[10] IN FRAME f-main /* Prazo Pgto[10] */
DO:
   RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).
     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif                                  

   if  i-valor = 4 then do:
       apply 'leave' to self.
       return no-apply.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.prazos[11]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.prazos[11] V-table-Win
ON ENTRY OF cond-pagto.prazos[11] IN FRAME f-main /* Prazo Pgto[11] */
DO:
   RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).
     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif                                  

   if  i-valor = 4 then do:
       apply 'leave' to self.
       return no-apply.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.prazos[12]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.prazos[12] V-table-Win
ON ENTRY OF cond-pagto.prazos[12] IN FRAME f-main /* Prazo Pgto[12] */
DO:
   RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).
     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif                                                    

   if  i-valor = 4 then do:
       apply 'leave' to self.
       return no-apply.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.prazos[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.prazos[1] V-table-Win
ON ENTRY OF cond-pagto.prazos[1] IN FRAME f-main /* Prazo Pgto[1] */
DO:
   RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).
     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif    

   if  i-valor = 4 then do:
       apply 'leave' to self.
       return no-apply.
   end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.prazos[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.prazos[2] V-table-Win
ON ENTRY OF cond-pagto.prazos[2] IN FRAME f-main /* Prazo Pgto[2] */
DO:
   RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).
     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif                                  

   if  i-valor = 4 then do:
       apply 'leave' to self.
       return no-apply.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.prazos[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.prazos[3] V-table-Win
ON ENTRY OF cond-pagto.prazos[3] IN FRAME f-main /* Prazo Pgto[3] */
DO:
   RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).
     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif                                  

   if  i-valor = 4 then do:
       apply 'leave' to self.
       return no-apply.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.prazos[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.prazos[4] V-table-Win
ON ENTRY OF cond-pagto.prazos[4] IN FRAME f-main /* Prazo Pgto[4] */
DO:
   RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).
     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif                                  

   if  i-valor = 4 then do:
       apply 'leave' to self.
       return no-apply.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.prazos[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.prazos[5] V-table-Win
ON ENTRY OF cond-pagto.prazos[5] IN FRAME f-main /* Prazo Pgto[5] */
DO:
   RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).
     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif                                  

   if  i-valor = 4 then do:
       apply 'leave' to self.
       return no-apply.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.prazos[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.prazos[6] V-table-Win
ON ENTRY OF cond-pagto.prazos[6] IN FRAME f-main /* Prazo Pgto[6] */
DO:
   RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).
     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif                                  

  if  i-valor = 4 then do:
       apply 'leave' to self.
       return no-apply.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.prazos[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.prazos[7] V-table-Win
ON ENTRY OF cond-pagto.prazos[7] IN FRAME f-main /* Prazo Pgto[7] */
DO:
   RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).
     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif                                  

   if  i-valor = 4 then do:
       apply 'leave' to self.
       return no-apply.
   end.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.prazos[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.prazos[8] V-table-Win
ON ENTRY OF cond-pagto.prazos[8] IN FRAME f-main /* Prazo Pgto[8] */
DO:
   RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).
     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif                                  

   if  i-valor = 4 then do:
       apply 'leave' to self.
       return no-apply.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.prazos[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.prazos[9] V-table-Win
ON ENTRY OF cond-pagto.prazos[9] IN FRAME f-main /* Prazo Pgto[9] */
DO:
   RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).
     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif                                  

   if  i-valor = 4 then do:
       apply 'leave' to self.
       return no-apply.
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

/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/

    &if defined (bf_dis_desc_bonif) &then
        {utp/ut-liter.i Dias_Prazo_M‚dio * R}
        assign i-qtd-dias-prazo-medio:label in frame {&frame-name} = return-value.
    &endif


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
  {src/adm/template/row-list.i "cond-pagto"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cond-pagto"}

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  {utp/ut-liter.i Prazo * r}
  assign fi-01:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Pagto * r}
  assign fi-02:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Prazo * r}
  assign fi-05:screen-value in frame {&frame-name} = return-value.    
  {utp/ut-liter.i Pagto * r}
  assign fi-06:screen-value in frame {&frame-name} = return-value.  
  {utp/ut-field.i mgadm cond-pagto cod-ven-par 2}
  assign fi-03:screen-value in frame {&frame-name} = return-value.
  {utp/ut-field.i mgadm cond-pagto cod-ven-par 2}
  assign fi-07:screen-value in frame {&frame-name} = return-value.  
  {utp/ut-field.i mgadm cond-pagto per-pg-dup 1}
  assign fi-04:screen-value in frame {&frame-name} = return-value.  
  {utp/ut-field.i mgadm cond-pagto per-pg-dup 1}
  assign fi-08:screen-value in frame {&frame-name} = return-value.  
  {utp/ut-liter.i MP * r}
  assign fi-09:screen-value in frame {&frame-name} = return-value.  
  {utp/ut-liter.i MP * r}
  assign fi-10:screen-value in frame {&frame-name} = return-value.  

  /* Tratamentos p/ inclusÆo */
  RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT this-procedure,
       INPUT "cb-cod-vencto").

  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).

     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif                                  

  if  i-valor = 2 then do:
      run PI-TRATA-A-VISTA.
  end.

  disable cb-cod-ven-par-2
          cb-cod-ven-par-3
          cb-cod-ven-par-4
          cb-cod-ven-par-5
          cb-cod-ven-par-6
          cb-cod-ven-par-7
          cb-cod-ven-par-8
          cb-cod-ven-par-9
          cb-cod-ven-par-10
          cb-cod-ven-par-11
          cb-cod-ven-par-12
          with frame {&frame-name}.

  IF  i-pais-impto-usuario = 1 THEN
      disable cb-meio-pagto-01
              cb-meio-pagto-02
              cb-meio-pagto-03
              cb-meio-pagto-04 
              cb-meio-pagto-05
              cb-meio-pagto-06
              cb-meio-pagto-07 
              cb-meio-pagto-08
              cb-meio-pagto-09
              cb-meio-pagto-10
              cb-meio-pagto-11
              cb-meio-pagto-12
              with frame {&frame-name}.

  assign cb-cod-ven-par-1 :screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
         cb-cod-ven-par-2 :screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 1} 
         cb-cod-ven-par-3 :screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
         cb-cod-ven-par-4 :screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
         cb-cod-ven-par-5 :screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
         cb-cod-ven-par-6 :screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
         cb-cod-ven-par-7 :screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
         cb-cod-ven-par-8 :screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
         cb-cod-ven-par-9 :screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
         cb-cod-ven-par-10:screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
         cb-cod-ven-par-11:screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
         cb-cod-ven-par-12:screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 1}.

  IF  i-pais-impto-usuario = 1 THEN
      ASSIGN cb-meio-pagto-01 :screen-value in frame {&frame-name} = "":U
             cb-meio-pagto-02 :screen-value in frame {&frame-name} = "":U
             cb-meio-pagto-03 :screen-value in frame {&frame-name} = "":U
             cb-meio-pagto-04 :screen-value in frame {&frame-name} = "":U
             cb-meio-pagto-05 :screen-value in frame {&frame-name} = "":U
             cb-meio-pagto-06 :screen-value in frame {&frame-name} = "":U
             cb-meio-pagto-07 :screen-value in frame {&frame-name} = "":U
             cb-meio-pagto-08 :screen-value in frame {&frame-name} = "":U
             cb-meio-pagto-09 :screen-value in frame {&frame-name} = "":U
             cb-meio-pagto-10 :screen-value in frame {&frame-name} = "":U
             cb-meio-pagto-11 :screen-value in frame {&frame-name} = "":U
             cb-meio-pagto-12 :screen-value in frame {&frame-name} = "":U.

 assign cond-pagto.per-pg-dup[1]:screen-value in frame {&frame-name} = "100". 

  if input frame {&frame-name} cond-pagto.num-parcelas = 1 or
     cond-pagto.num-parcelas:sensitive in frame {&frame-name} = no  then
       disable bt-rateio with frame {&frame-name}.
  else enable bt-rateio with frame {&frame-name}.

  /************************************************************ 
  *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
  ************************************************************/

  &if defined (bf_dis_desc_bonif) &then
      if cond-pagto.num-parcelas:sensitive in frame {&frame-name} = no  then
         disable bt-calculo with frame {&frame-name}.
      else enable bt-calculo with frame {&frame-name}.
  &endif

/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/

 &if defined (bf_dis_desc_bonif) &then
      assign i-qtd-dias-prazo-medio:hidden in frame {&frame-name}    = no
             bt-calculo:hidden in frame {&frame-name} = no
             i-qtd-dias-prazo-medio:screen-value in frame {&frame-name} = ""
             i-qtd-dias-prazo-medio:format in frame {&frame-name} = ">>9".
 &else
      assign i-qtd-dias-prazo-medio:hidden in frame {&frame-name}    = yes
             bt-calculo:hidden in frame {&frame-name} = yes.
 &endif


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  
  &if defined (bf_dis_gradiente) &then
    IF NOT adm-new-record  and
       input frame {&frame-name} i-qtd-dias-prazo-medio <> i-qtd-dias-prazo-medio THEN
        ASSIGN l-atualiza = YES.
    ELSE
        ASSIGN l-atualiza = NO.
  &ENDIF

  /*{include/i-valid.i}*/
  assign input frame {&frame-name} cb-cod-ven-par-1
         input frame {&frame-name} cb-cod-ven-par-2
         input frame {&frame-name} cb-cod-ven-par-3
         input frame {&frame-name} cb-cod-ven-par-4
         input frame {&frame-name} cb-cod-ven-par-5
         input frame {&frame-name} cb-cod-ven-par-6
         input frame {&frame-name} cb-cod-ven-par-7
         input frame {&frame-name} cb-cod-ven-par-8
         input frame {&frame-name} cb-cod-ven-par-9
         input frame {&frame-name} cb-cod-ven-par-10
         input frame {&frame-name} cb-cod-ven-par-11
         input frame {&frame-name} cb-cod-ven-par-12.

  assign i-cod-ven-par[1]  = {diinc/i02di165.i 06 cb-cod-ven-par-1}
         i-cod-ven-par[2]  = {diinc/i02di165.i 06 cb-cod-ven-par-2}
         i-cod-ven-par[3]  = {diinc/i02di165.i 06 cb-cod-ven-par-3}
         i-cod-ven-par[4]  = {diinc/i02di165.i 06 cb-cod-ven-par-4}
         i-cod-ven-par[5]  = {diinc/i02di165.i 06 cb-cod-ven-par-5}
         i-cod-ven-par[6]  = {diinc/i02di165.i 06 cb-cod-ven-par-6}
         i-cod-ven-par[7]  = {diinc/i02di165.i 06 cb-cod-ven-par-7}
         i-cod-ven-par[8]  = {diinc/i02di165.i 06 cb-cod-ven-par-8}
         i-cod-ven-par[9]  = {diinc/i02di165.i 06 cb-cod-ven-par-9}
         i-cod-ven-par[10] = {diinc/i02di165.i 06 cb-cod-ven-par-10}
         i-cod-ven-par[11] = {diinc/i02di165.i 06 cb-cod-ven-par-11}
         i-cod-ven-par[12] = {diinc/i02di165.i 06 cb-cod-ven-par-12}.

  IF  i-pais-impto-usuario = 1 THEN
      ASSIGN input frame {&frame-name} cb-meio-pagto-01 
             input frame {&frame-name} cb-meio-pagto-02 
             input frame {&frame-name} cb-meio-pagto-03 
             input frame {&frame-name} cb-meio-pagto-04 
             input frame {&frame-name} cb-meio-pagto-05 
             input frame {&frame-name} cb-meio-pagto-06 
             input frame {&frame-name} cb-meio-pagto-07 
             input frame {&frame-name} cb-meio-pagto-08 
             input frame {&frame-name} cb-meio-pagto-09 
             input frame {&frame-name} cb-meio-pagto-10 
             input frame {&frame-name} cb-meio-pagto-11 
             input frame {&frame-name} cb-meio-pagto-12. 

  /************************************************************ 
  *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
  ************************************************************/

  &if defined (bf_dis_desc_bonif) &then
   assign input frame {&frame-name} i-qtd-dias-prazo-medio.
  &endif

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).

  assign cond-pagto.cod-ven-par[1]  = i-cod-ven-par[1]
         cond-pagto.cod-ven-par[2]  = i-cod-ven-par[2]
         cond-pagto.cod-ven-par[3]  = i-cod-ven-par[3]
         cond-pagto.cod-ven-par[4]  = i-cod-ven-par[4]
         cond-pagto.cod-ven-par[5]  = i-cod-ven-par[5]
         cond-pagto.cod-ven-par[6]  = i-cod-ven-par[6]
         cond-pagto.cod-ven-par[7]  = i-cod-ven-par[7]
         cond-pagto.cod-ven-par[8]  = i-cod-ven-par[8]
         cond-pagto.cod-ven-par[9]  = i-cod-ven-par[9]
         cond-pagto.cod-ven-par[10] = i-cod-ven-par[10]
         cond-pagto.cod-ven-par[11] = i-cod-ven-par[11]
         cond-pagto.cod-ven-par[12] = i-cod-ven-par[12].

  IF  i-pais-impto-usuario = 1 THEN
      ASSIGN OVERLAY(cond-pagto.char-1,46,2) = cb-meio-pagto-01 
             OVERLAY(cond-pagto.char-1,48,2) = cb-meio-pagto-02 
             OVERLAY(cond-pagto.char-1,50,2) = cb-meio-pagto-03 
             OVERLAY(cond-pagto.char-1,52,2) = cb-meio-pagto-04 
             OVERLAY(cond-pagto.char-1,54,2) = cb-meio-pagto-05 
             OVERLAY(cond-pagto.char-1,56,2) = cb-meio-pagto-06 
             OVERLAY(cond-pagto.char-1,58,2) = cb-meio-pagto-07 
             OVERLAY(cond-pagto.char-1,60,2) = cb-meio-pagto-08 
             OVERLAY(cond-pagto.char-1,62,2) = cb-meio-pagto-09 
             OVERLAY(cond-pagto.char-1,64,2) = cb-meio-pagto-10 
             OVERLAY(cond-pagto.char-1,66,2) = cb-meio-pagto-11 
             OVERLAY(cond-pagto.char-1,68,2) = cb-meio-pagto-12. 

  
 /************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/

   &if defined (bf_dis_desc_bonif) &then
    assign cond-pagto.qtd-dias-prazo-medio   = i-qtd-dias-prazo-medio.
   &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .
  /* Tratamentos p/ modificacao */

      disable {&List-4} with frame {&frame-name}.    
      do i-cont  = 1 TO INPUT FRAME {&FRAME-NAME} mgadm.cond-pagto.num-parcelas :
          ENABLE cond-pagto.per-pg-dup[i-cont] 
                 cond-pagto.prazos[i-cont] WITH FRAME {&FRAME-NAME} .
          if i-cont = 1 then 
             enable cb-cod-ven-par-1  with frame {&frame-name}.      
          if i-cont = 2 then
             enable cb-cod-ven-par-2  with frame {&frame-name}.
          if i-cont = 3 then 
             enable cb-cod-ven-par-3  with frame {&frame-name}.
          if i-cont = 4 then      
             enable cb-cod-ven-par-4  with frame {&frame-name}.
          if i-cont = 5 then
             enable cb-cod-ven-par-5  with frame {&frame-name}.      
          if i-cont = 6 then
             enable cb-cod-ven-par-6  with frame {&frame-name}.      
          if i-cont = 7 then
             enable cb-cod-ven-par-7  with frame {&frame-name}.      
          if i-cont = 8 then
             enable cb-cod-ven-par-8  with frame {&frame-name}.      
          if i-cont = 9 then
             enable cb-cod-ven-par-9  with frame {&frame-name}.      
          if i-cont = 10 then
             enable cb-cod-ven-par-10 with frame {&frame-name}.      
          if i-cont = 11 then                      
             enable cb-cod-ven-par-11 with frame {&frame-name}.
          if i-cont = 12 then
             enable cb-cod-ven-par-12 with frame {&frame-name}.

          IF  i-pais-impto-usuario = 1 THEN DO:
          
              if i-cont = 1 then 
                 enable cb-meio-pagto-01 with frame {&frame-name}.      
              if i-cont = 2 then
                 enable cb-meio-pagto-02 with frame {&frame-name}.
              if i-cont = 3 then 
                 enable cb-meio-pagto-03 with frame {&frame-name}.
              if i-cont = 4 then      
                 enable cb-meio-pagto-04 with frame {&frame-name}.
              if i-cont = 5 then
                 enable cb-meio-pagto-05 with frame {&frame-name}.      
              if i-cont = 6 then
                 enable cb-meio-pagto-06 with frame {&frame-name}.      
              if i-cont = 7 then
                 enable cb-meio-pagto-07 with frame {&frame-name}.      
              if i-cont = 8 then
                 enable cb-meio-pagto-08 with frame {&frame-name}.      
              if i-cont = 9 then
                 enable cb-meio-pagto-09 with frame {&frame-name}.      
              if i-cont = 10 then
                 enable cb-meio-pagto-10 with frame {&frame-name}.      
              if i-cont = 11 then                                       
                 enable cb-meio-pagto-11 with frame {&frame-name}.
              if i-cont = 12 then
                 enable cb-meio-pagto-12 with frame {&frame-name}.
          END.

     END. 

   RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).
     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif                                  

   if  i-valor = 2 then do:
       run PI-TRATA-A-VISTA.
   end.

   /************************************************************ 
   *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
   ************************************************************/

   &if defined (bf_dis_desc_bonif) &then
       assign i-qtd-dias-prazo-medio:hidden in frame {&frame-name}    = no
              bt-calculo:hidden in frame {&frame-name} = no.
   &else
       assign i-qtd-dias-prazo-medio:hidden in frame {&frame-name}    = yes
              bt-calculo:hidden in frame {&frame-name} = yes.
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
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
  disable {&List-4} with frame {&frame-name}.

  /************************************************************ 
  *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
  ************************************************************/

   &if defined (bf_dis_desc_bonif) &then
       assign i-qtd-dias-prazo-medio:sensitive in frame {&frame-name} = no.
   &endif
  
   IF  i-pais-impto-usuario <> 1 THEN
       ASSIGN cb-meio-pagto-01:HIDDEN in frame {&frame-name} = yes
              cb-meio-pagto-02:HIDDEN in frame {&frame-name} = yes
              cb-meio-pagto-03:HIDDEN in frame {&frame-name} = yes
              cb-meio-pagto-04:HIDDEN in frame {&frame-name} = yes
              cb-meio-pagto-05:HIDDEN in frame {&frame-name} = yes
              cb-meio-pagto-06:HIDDEN in frame {&frame-name} = yes
              cb-meio-pagto-07:HIDDEN in frame {&frame-name} = yes
              cb-meio-pagto-08:HIDDEN in frame {&frame-name} = yes
              cb-meio-pagto-09:HIDDEN in frame {&frame-name} = yes
              cb-meio-pagto-10:HIDDEN in frame {&frame-name} = yes
              cb-meio-pagto-11:HIDDEN in frame {&frame-name} = yes
              cb-meio-pagto-12:HIDDEN in frame {&frame-name} = yes
              fi-09           :HIDDEN in frame {&frame-name} = yes 
              fi-10           :HIDDEN in frame {&frame-name} = yes .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  IF  i-pais-impto-usuario = 1 THEN DO:
  
      ASSIGN cb-meio-pagto-01 = "":U
             cb-meio-pagto-02 = "":U
             cb-meio-pagto-03 = "":U
             cb-meio-pagto-04 = "":U
             cb-meio-pagto-05 = "":U
             cb-meio-pagto-06 = "":U
             cb-meio-pagto-07 = "":U
             cb-meio-pagto-08 = "":U
             cb-meio-pagto-09 = "":U
             cb-meio-pagto-10 = "":U
             cb-meio-pagto-11 = "":U
             cb-meio-pagto-12 = "":U.
    
      IF  AVAIL cond-pagto THEN
          ASSIGN cb-meio-pagto-01 = TRIM(SUBSTRING(cond-pagto.char-1,46,2))
                 cb-meio-pagto-02 = TRIM(SUBSTRING(cond-pagto.char-1,48,2))
                 cb-meio-pagto-03 = TRIM(SUBSTRING(cond-pagto.char-1,50,2))
                 cb-meio-pagto-04 = TRIM(SUBSTRING(cond-pagto.char-1,52,2))
                 cb-meio-pagto-05 = TRIM(SUBSTRING(cond-pagto.char-1,54,2))
                 cb-meio-pagto-06 = TRIM(SUBSTRING(cond-pagto.char-1,56,2))
                 cb-meio-pagto-07 = TRIM(SUBSTRING(cond-pagto.char-1,58,2))
                 cb-meio-pagto-08 = TRIM(SUBSTRING(cond-pagto.char-1,60,2))
                 cb-meio-pagto-09 = TRIM(SUBSTRING(cond-pagto.char-1,62,2))
                 cb-meio-pagto-10 = TRIM(SUBSTRING(cond-pagto.char-1,64,2))
                 cb-meio-pagto-11 = TRIM(SUBSTRING(cond-pagto.char-1,66,2))
                 cb-meio-pagto-12 = TRIM(SUBSTRING(cond-pagto.char-1,68,2)).
  END.
  

  if  avail cond-pagto then do:
      if  cond-pagto.dia-sem-base <> 0 then do:
          assign cb-cod-ven-par-1 = {diinc/i02di165.i 04 cond-pagto.cod-ven-par[1]}
                 cb-cod-ven-par-2 = {diinc/i02di165.i 04 cond-pagto.cod-ven-par[2]}               
                 cb-cod-ven-par-3 = {diinc/i02di165.i 04 cond-pagto.cod-ven-par[3]}               
                 cb-cod-ven-par-4 = {diinc/i02di165.i 04 cond-pagto.cod-ven-par[4]}               
                 cb-cod-ven-par-5 = {diinc/i02di165.i 04 cond-pagto.cod-ven-par[5]}                                             
                 cb-cod-ven-par-6 = {diinc/i02di165.i 04 cond-pagto.cod-ven-par[6]}               
                 cb-cod-ven-par-7 = {diinc/i02di165.i 04 cond-pagto.cod-ven-par[7]}               
                 cb-cod-ven-par-8 = {diinc/i02di165.i 04 cond-pagto.cod-ven-par[8]}               
                 cb-cod-ven-par-9 = {diinc/i02di165.i 04 cond-pagto.cod-ven-par[9]}               
                 cb-cod-ven-par-10 = {diinc/i02di165.i 04 cond-pagto.cod-ven-par[10]}               
                 cb-cod-ven-par-11 = {diinc/i02di165.i 04 cond-pagto.cod-ven-par[11]}               
                 cb-cod-ven-par-12 = {diinc/i02di165.i 04 cond-pagto.cod-ven-par[12]}.               

      end. 
      else do:
          assign cb-cod-ven-par-1 = {diinc/i02di165.i 04 1}
                 cb-cod-ven-par-2 = {diinc/i02di165.i 04 1} 
                 cb-cod-ven-par-3 = {diinc/i02di165.i 04 1}
                 cb-cod-ven-par-4 = {diinc/i02di165.i 04 1}
                 cb-cod-ven-par-5 = {diinc/i02di165.i 04 1}
                 cb-cod-ven-par-6 = {diinc/i02di165.i 04 1}
                 cb-cod-ven-par-7 = {diinc/i02di165.i 04 1}
                 cb-cod-ven-par-8 = {diinc/i02di165.i 04 1}
                 cb-cod-ven-par-9 = {diinc/i02di165.i 04 1}
                 cb-cod-ven-par-10 = {diinc/i02di165.i 04 1}
                 cb-cod-ven-par-11 = {diinc/i02di165.i 04 1}
                 cb-cod-ven-par-12 = {diinc/i02di165.i 04 1}.
      end.
  end.
  
 /************************************************************ 
 *  Pr‚-Processador para o m½dulo de Descontos e Bonifica»’o
 ************************************************************/

  &if  defined (bf_dis_desc_bonif) <> 0 &then
       if  avail cond-pagto 
       and not adm-new-record then
           assign i-qtd-dias-prazo-medio = cond-pagto.qtd-dias-prazo-medio.
  &endif

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  {utp/ut-liter.i Prazo * r}
  assign fi-01:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Pagto * r}
  assign fi-02:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Prazo * r}
  assign fi-05:screen-value in frame {&frame-name} = return-value.    
  {utp/ut-liter.i Pagto * r}
  assign fi-06:screen-value in frame {&frame-name} = return-value.  
  {utp/ut-field.i mgadm cond-pagto cod-ven-par 2}
  assign fi-03:screen-value in frame {&frame-name} = return-value.
  {utp/ut-field.i mgadm cond-pagto cod-ven-par 2}
  assign fi-07:screen-value in frame {&frame-name} = return-value.  
  {utp/ut-field.i mgadm cond-pagto per-pg-dup 1}
  assign fi-04:screen-value in frame {&frame-name} = return-value.  
  {utp/ut-field.i mgadm cond-pagto per-pg-dup 1}
  assign fi-08:screen-value in frame {&frame-name} = return-value.  
  {utp/ut-liter.i MP * r}
  assign fi-09:screen-value in frame {&frame-name} = return-value.  
  {utp/ut-liter.i MP * r}
  assign fi-10:screen-value in frame {&frame-name} = return-value.  

  {utp/ut-liter.i Ratear * c}
  assign bt-rateio:label in frame {&frame-name} = return-value.

  if input frame {&frame-name} cond-pagto.num-parcelas = 1 or
     cond-pagto.num-parcelas:sensitive in frame {&frame-name} = no  then
       disable bt-rateio with frame {&frame-name}.
  else enable bt-rateio with frame {&frame-name}.

  /************************************************************ 
  *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
  ************************************************************/

  &if defined (bf_dis_desc_bonif) &then
      if cond-pagto.num-parcelas:sensitive in frame {&frame-name} = no  then
         disable bt-calculo with frame {&frame-name}.
      else enable bt-calculo with frame {&frame-name}.
  &endif
  
  
 /************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/

   &if defined (bf_dis_desc_bonif) &then
       assign i-qtd-dias-prazo-medio:format in frame {&frame-name} = ">>9".
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
  
  run get-attribute ('adm-new-record').

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  /************************************************************ 
  *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
  ************************************************************/

  &if defined (bf_dis_desc_bonif) &then
      if cond-pagto.num-parcelas:sensitive in frame {&frame-name} = no  then
         disable bt-calculo with frame {&frame-name}.
      else enable bt-calculo with frame {&frame-name}.
  &endif


  /************************************************************ 
  *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
  ************************************************************/

   &if defined (bf_dis_desc_bonif) &then
       assign i-qtd-dias-prazo-medio:sensitive in frame {&frame-name} = yes.
  &endif


  if input frame {&frame-name} cond-pagto.num-parcelas = 1 or
     cond-pagto.num-parcelas:sensitive in frame {&frame-name} = no  then
       disable bt-rateio with frame {&frame-name}.
  else enable bt-rateio with frame {&frame-name}.

  IF  i-pais-impto-usuario <> 1 THEN
      ASSIGN cb-meio-pagto-01:HIDDEN in frame {&frame-name} = yes
             cb-meio-pagto-02:HIDDEN in frame {&frame-name} = yes
             cb-meio-pagto-03:HIDDEN in frame {&frame-name} = yes
             cb-meio-pagto-04:HIDDEN in frame {&frame-name} = yes
             cb-meio-pagto-05:HIDDEN in frame {&frame-name} = yes
             cb-meio-pagto-06:HIDDEN in frame {&frame-name} = yes
             cb-meio-pagto-07:HIDDEN in frame {&frame-name} = yes
             cb-meio-pagto-08:HIDDEN in frame {&frame-name} = yes
             cb-meio-pagto-09:HIDDEN in frame {&frame-name} = yes
             cb-meio-pagto-10:HIDDEN in frame {&frame-name} = yes
             cb-meio-pagto-11:HIDDEN in frame {&frame-name} = yes
             cb-meio-pagto-12:HIDDEN in frame {&frame-name} = yes
             fi-09           :HIDDEN in frame {&frame-name} = yes 
             fi-10           :HIDDEN in frame {&frame-name} = yes .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  &if defined (bf_dis_gradiente) &then
    IF  l-atualiza AND
        NOT adm-new-record THEN DO:
        run utp/ut-msgs.p (input "show",
                           input 959,
                           input "").

        if  return-value = "yes" THEN
            run cdp/cd0404b.p (INPUT cond-pagto.cod-cond-pag).
    END.
  &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  IF  i-pais-impto-usuario = 1 THEN DO:
      if cb-meio-pagto-01:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
      if cb-meio-pagto-02:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
      if cb-meio-pagto-03:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
      if cb-meio-pagto-04:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
      if cb-meio-pagto-05:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
      if cb-meio-pagto-06:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
      if cb-meio-pagto-07:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
      if cb-meio-pagto-08:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
      if cb-meio-pagto-09:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
      if cb-meio-pagto-10:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
      if cb-meio-pagto-11:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
      if cb-meio-pagto-12:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  END.

  /************************************************************ 
  *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
  ************************************************************/

  &if defined (bf_dis_desc_bonif) &then
      assign i-qtd-dias-prazo-medio:hidden in frame {&frame-name}    = no
             bt-calculo:hidden in frame {&frame-name} = no.
  &else
      assign i-qtd-dias-prazo-medio:hidden in frame {&frame-name}    = yes
             bt-calculo:hidden in frame {&frame-name} = yes.  
  &endif
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  do  with frame {&frame-name}:
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          assign cLista = {diinc/i02di165.i 03}.
          run utp/ut-lstit.p (input-output cLista).
          assign cb-cod-ven-par-1:list-item-pairs  = cLista
                 cb-cod-ven-par-2:list-item-pairs  = cLista
                 cb-cod-ven-par-3:list-item-pairs  = cLista
                 cb-cod-ven-par-4:list-item-pairs  = cLista
                 cb-cod-ven-par-5:list-item-pairs  = cLista
                 cb-cod-ven-par-6:list-item-pairs  = cLista
                 cb-cod-ven-par-7:list-item-pairs  = cLista
                 cb-cod-ven-par-8:list-item-pairs  = cLista
                 cb-cod-ven-par-9:list-item-pairs  = cLista
                 cb-cod-ven-par-10:list-item-pairs = cLista
                 cb-cod-ven-par-11:list-item-pairs = cLista
                 cb-cod-ven-par-12:list-item-pairs = cLista.
      &else
          assign cb-cod-ven-par-1:list-items  = {diinc/i02di165.i 03}
                 cb-cod-ven-par-2:list-items  = {diinc/i02di165.i 03}
                 cb-cod-ven-par-3:list-items  = {diinc/i02di165.i 03}
                 cb-cod-ven-par-4:list-items  = {diinc/i02di165.i 03}
                 cb-cod-ven-par-5:list-items  = {diinc/i02di165.i 03}
                 cb-cod-ven-par-6:list-items  = {diinc/i02di165.i 03}
                 cb-cod-ven-par-7:list-items  = {diinc/i02di165.i 03}
                 cb-cod-ven-par-8:list-items  = {diinc/i02di165.i 03}
                 cb-cod-ven-par-9:list-items  = {diinc/i02di165.i 03}
                 cb-cod-ven-par-10:list-items = {diinc/i02di165.i 03}
                 cb-cod-ven-par-11:list-items = {diinc/i02di165.i 03}
                 cb-cod-ven-par-12:list-items = {diinc/i02di165.i 03}.
      &endif                                  
  end.

  if  avail cond-pagto then do:
    if  cond-pagto.dia-sem-base <> 0 then do:
        assign cb-cod-ven-par-1:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 cond-pagto.cod-ven-par[1]}
               cb-cod-ven-par-2:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 cond-pagto.cod-ven-par[2]}               
               cb-cod-ven-par-3:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 cond-pagto.cod-ven-par[3]}               
               cb-cod-ven-par-4:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 cond-pagto.cod-ven-par[4]}               
               cb-cod-ven-par-5:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 cond-pagto.cod-ven-par[5]}                                             
               cb-cod-ven-par-6:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 cond-pagto.cod-ven-par[6]}               
               cb-cod-ven-par-7:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 cond-pagto.cod-ven-par[7]}               
               cb-cod-ven-par-8:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 cond-pagto.cod-ven-par[8]}               
               cb-cod-ven-par-9:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 cond-pagto.cod-ven-par[9]}               
               cb-cod-ven-par-10:screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 cond-pagto.cod-ven-par[10]}               
               cb-cod-ven-par-11:screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 cond-pagto.cod-ven-par[11]}               
               cb-cod-ven-par-12:screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 cond-pagto.cod-ven-par[12]}.               
    end. 
    else do:
        assign cb-cod-ven-par-1:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
               cb-cod-ven-par-2:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 1} 
               cb-cod-ven-par-3:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
               cb-cod-ven-par-4:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
               cb-cod-ven-par-5:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
               cb-cod-ven-par-6:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
               cb-cod-ven-par-7:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
               cb-cod-ven-par-8:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
               cb-cod-ven-par-9:screen-value  in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
               cb-cod-ven-par-10:screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
               cb-cod-ven-par-11:screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 1}
               cb-cod-ven-par-12:screen-value in frame {&frame-name} = {DIINC/I02DI165.I 04 1}.
    end.

    ASSIGN cb-meio-pagto-01:screen-value in frame {&frame-name} = ""
           cb-meio-pagto-02:screen-value in frame {&frame-name} = ""
           cb-meio-pagto-03:screen-value in frame {&frame-name} = ""
           cb-meio-pagto-04:screen-value in frame {&frame-name} = ""
           cb-meio-pagto-05:screen-value in frame {&frame-name} = ""
           cb-meio-pagto-06:screen-value in frame {&frame-name} = ""
           cb-meio-pagto-07:screen-value in frame {&frame-name} = ""
           cb-meio-pagto-08:screen-value in frame {&frame-name} = ""
           cb-meio-pagto-09:screen-value in frame {&frame-name} = ""
           cb-meio-pagto-10:screen-value in frame {&frame-name} = ""
           cb-meio-pagto-11:screen-value in frame {&frame-name} = ""
           cb-meio-pagto-12:screen-value in frame {&frame-name} = "".

    IF  i-pais-impto-usuario <> 1 THEN
        ASSIGN cb-meio-pagto-01:HIDDEN in frame {&frame-name} = yes
               cb-meio-pagto-02:HIDDEN in frame {&frame-name} = yes
               cb-meio-pagto-03:HIDDEN in frame {&frame-name} = yes
               cb-meio-pagto-04:HIDDEN in frame {&frame-name} = yes
               cb-meio-pagto-05:HIDDEN in frame {&frame-name} = yes
               cb-meio-pagto-06:HIDDEN in frame {&frame-name} = yes
               cb-meio-pagto-07:HIDDEN in frame {&frame-name} = yes
               cb-meio-pagto-08:HIDDEN in frame {&frame-name} = yes
               cb-meio-pagto-09:HIDDEN in frame {&frame-name} = yes
               cb-meio-pagto-10:HIDDEN in frame {&frame-name} = yes
               cb-meio-pagto-11:HIDDEN in frame {&frame-name} = yes
               cb-meio-pagto-12:HIDDEN in frame {&frame-name} = yes
               fi-09           :HIDDEN in frame {&frame-name} = yes 
               fi-10           :HIDDEN in frame {&frame-name} = yes .

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-apply-campo-parcela V-table-Win 
PROCEDURE pi-apply-campo-parcela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).
     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif         

   if  i-valor <> 2  then 
       apply 'entry' to cond-pagto.num-parcelas in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-apply-campo-parcela-2 V-table-Win 
PROCEDURE pi-apply-campo-parcela-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Quando o Codigo de Vencimento for alterado de "a vista" para outro valor, 
   ‚ chamada essa procedure */
   RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
       DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
       ASSIGN cAuxTraducao002 = {diinc/i02di165.i 03}
              cCodVencto = RETURN-VALUE.
       RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao002).
       run utp/ut-lstit.p (input-output cCodVencto).
       If  lookup(cCodVencto,cAuxTraducao002) mod 2 <> 0 Then
           ASSIGN i-valor = (lookup(cCodVencto,cAuxTraducao002) + 1) / 2.
       else 
           ASSIGN i-valor = lookup(cCodVencto,cAuxTraducao002) / 2.
   &else
       ASSIGN i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif

   if  i-valor <> 2  then do:
       enable cond-pagto.num-parcelas 
              cond-pagto.prazos[1]
              cb-cod-ven-par-1   
              cond-pagto.per-pg-dup[1] with frame {&frame-name}.


     assign cb-cod-ven-par-1:screen-value in frame {&frame-name} = cb-cod-ven-par-1:entry(i-valor).       
     apply 'entry' to cond-pagto.num-parcelas in frame {&frame-name}.
   end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-DesabilitaCampos V-table-Win 
PROCEDURE pi-DesabilitaCampos :
/*------------------------------------------------------------------------------
  Purpose: Desabilita campos conforme numero parcelas
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

assign i-cont = int(cond-pagto.num-parcelas:SCREEN-VALUE IN frame {&frame-name}) + 1. 
do while i-cont <= 12:
  disable  cond-pagto.prazos[i-cont]      with frame {&frame-name}.
  disable  cond-pagto.per-pg-dup[i-cont]  with frame {&frame-name}.
  if i-cont = 1 then
     disable cb-cod-ven-par-1  cb-meio-pagto-01 with frame {&frame-name}.      
  if i-cont = 2 then
     disable cb-cod-ven-par-2  cb-meio-pagto-02 with frame {&frame-name}.
  if i-cont = 3 then
     disable cb-cod-ven-par-3  cb-meio-pagto-03 with frame {&frame-name}.
  if i-cont = 4 then      
     disable cb-cod-ven-par-4  cb-meio-pagto-04 with frame {&frame-name}.
  if i-cont = 5 then
     disable cb-cod-ven-par-5  cb-meio-pagto-05 with frame {&frame-name}.      
  if i-cont = 6 then
     disable cb-cod-ven-par-6  cb-meio-pagto-06 with frame {&frame-name}.      
  if i-cont = 7 then
     disable cb-cod-ven-par-7  cb-meio-pagto-07 with frame {&frame-name}.      
  if i-cont = 8 then
     disable cb-cod-ven-par-8  cb-meio-pagto-08 with frame {&frame-name}.      
  if i-cont = 9 then
     disable cb-cod-ven-par-9  cb-meio-pagto-09 with frame {&frame-name}.      
  if i-cont = 10 then
     disable cb-cod-ven-par-10 cb-meio-pagto-10 with frame {&frame-name}.      
  if i-cont = 11 then                                       
     disable cb-cod-ven-par-11 cb-meio-pagto-11 with frame {&frame-name}.
  if i-cont = 12 then
     disable cb-cod-ven-par-12 cb-meio-pagto-12 with frame {&frame-name}.

 i-cont = i-cont + 1.

 IF  i-pais-impto-usuario <> 1 THEN
     ASSIGN cb-meio-pagto-01:HIDDEN in frame {&frame-name} = yes
            cb-meio-pagto-02:HIDDEN in frame {&frame-name} = yes
            cb-meio-pagto-03:HIDDEN in frame {&frame-name} = yes
            cb-meio-pagto-04:HIDDEN in frame {&frame-name} = yes
            cb-meio-pagto-05:HIDDEN in frame {&frame-name} = yes
            cb-meio-pagto-06:HIDDEN in frame {&frame-name} = yes
            cb-meio-pagto-07:HIDDEN in frame {&frame-name} = yes
            cb-meio-pagto-08:HIDDEN in frame {&frame-name} = yes
            cb-meio-pagto-09:HIDDEN in frame {&frame-name} = yes
            cb-meio-pagto-10:HIDDEN in frame {&frame-name} = yes
            cb-meio-pagto-11:HIDDEN in frame {&frame-name} = yes
            cb-meio-pagto-12:HIDDEN in frame {&frame-name} = yes
            fi-09           :HIDDEN in frame {&frame-name} = yes 
            fi-10           :HIDDEN in frame {&frame-name} = yes .

end.                

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-esconde-campo-tela V-table-Win 
PROCEDURE pi-esconde-campo-tela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Esta procedure somente ‚ executada por um pr‚-processador "desc_bonif".
         NÆo eliminar esta procedure.      
------------------------------------------------------------------------------*/

 assign i-qtd-dias-prazo-medio:hidden in frame {&frame-name}    = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Formas-Pagto-NFe V-table-Win 
PROCEDURE pi-Formas-Pagto-NFe :
/*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT-OUTPUT PARAMETER pc-meio-pagto-NF-e AS CHARACTER   NO-UNDO.

    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 80 BY 1.42
         BGCOLOR 7.

    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    DEFINE VARIABLE cb-meio-pagto-NF-e AS CHAR FORMAT "x(77)":U LABEL "Meio Pagamento" VIEW-AS COMBO-BOX INNER-LINES 999 DROP-DOWN-LIST NO-UNDO.
    DEFINE VARIABLE c-meio-pagto-NF-e  AS CHARACTER   NO-UNDO.

    DEFINE FRAME fMeioPagto
        cb-meio-pagto-NF-e   AT ROW 1.42 COL 2.45 HELP "Meio Pagamento"
        btGoToOK             AT ROW 3.03 COL 2.14
        btGoToCancel         AT ROW 3.03 COL 13
        rtGoToButton         AT ROW 2.78 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Meio de Pagamento" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    DEFINE VARIABLE cLista AS CHARACTER   NO-UNDO.
    ASSIGN cLista = "":U
           cLista = "    ," + {adinc/i03ad039.i 03}.

    &if "{&FNC_MULTI_IDIOMA}" = "Yes":U &then
        RUN utp/ut-lstit.p (input-output cLista).
        ASSIGN cb-meio-pagto-NF-e:LIST-ITEM-PAIRS = cLista.
    &else
        ASSIGN cb-meio-pagto-NF-e:LIST-ITEMS      = cLista.
    &endif
    
    REPEAT i-cont = 1 TO NUM-ENTRIES(cLista):
        if  ENTRY(1,ENTRY(i-cont, cLista)," - ") = TRIM(pc-meio-pagto-NF-e) then do:
            assign cb-meio-pagto-NF-e:SCREEN-VALUE IN FRAME fMeioPagto = ENTRY(i-cont, cLista) NO-ERROR.
            leave.
        end.
        else
            assign cb-meio-pagto-NF-e:SCREEN-VALUE IN FRAME fMeioPagto = "" NO-ERROR.
    END.
    
    ASSIGN cb-meio-pagto-NF-e:SENSITIVE IN FRAME fMeioPagto = YES.

    ON  "CHOOSE":U OF btGoToOK IN FRAME fMeioPagto DO:

        ASSIGN INPUT FRAME fMeioPagto cb-meio-pagto-NF-e.

        ASSIGN pc-meio-pagto-NF-e = ENTRY(1,cb-meio-pagto-NF-e," - ")
               pc-meio-pagto-NF-e = (IF TRIM(pc-meio-pagto-NF-e) = "0":U
                                     THEN "":U
                                     ELSE TRIM(pc-meio-pagto-NF-e)) NO-ERROR.

        APPLY "GO":U TO FRAME fMeioPagto.
    END.

    ENABLE btGoToOK btGoToCancel
           WITH FRAME fMeioPagto. 

    WAIT-FOR "GO":U OF FRAME fMeioPagto.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicio-parcela V-table-Win 
PROCEDURE pi-inicio-parcela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cb-cod-vencto").

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).
     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif                                  


   if  i-valor = 2  or i-valor = 3 or i-valor = 4 then do:
       assign cond-pagto.num-parcelas:screen-value in frame {&frame-name}   = "1"
              cb-cod-ven-par-1:screen-value in frame {&frame-name} = cb-cod-ven-par-1:entry(i-valor)
              cond-pagto.per-pg-dup[1]:screen-value in frame {&frame-name}  = "100"
              cond-pagto.prazos[1]:screen-value in frame {&frame-name}      = "0".
   end.

   RUN PI-DesabilitaCampos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-campos V-table-Win 
PROCEDURE pi-limpa-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  assign   cb-cod-ven-par-1:screen-value in frame {&frame-name}  = cb-cod-ven-par-1:entry(1)
           cb-cod-ven-par-2:screen-value in frame {&frame-name}  = cb-cod-ven-par-2:entry(1)
           cb-cod-ven-par-3:screen-value in frame {&frame-name}  = cb-cod-ven-par-3:entry(1)
           cb-cod-ven-par-4:screen-value in frame {&frame-name}  = cb-cod-ven-par-4:entry(1)
           cb-cod-ven-par-5:screen-value in frame {&frame-name}  = cb-cod-ven-par-5:entry(1)
           cb-cod-ven-par-6:screen-value in frame {&frame-name}  = cb-cod-ven-par-6:entry(1)
           cb-cod-ven-par-7:screen-value in frame {&frame-name}  = cb-cod-ven-par-7:entry(1)
           cb-cod-ven-par-8:screen-value in frame {&frame-name}  = cb-cod-ven-par-8:entry(1)
           cb-cod-ven-par-9:screen-value in frame {&frame-name}  = cb-cod-ven-par-9:entry(1)
           cb-cod-ven-par-10:screen-value in frame {&frame-name} = cb-cod-ven-par-10:entry(1)
           cb-cod-ven-par-11:screen-value in frame {&frame-name} = cb-cod-ven-par-11:entry(1)
           cb-cod-ven-par-12:screen-value in frame {&frame-name} = cb-cod-ven-par-12:entry(1)

           cond-pagto.prazos[1]:screen-value in frame {&frame-name}  = " "
           cond-pagto.prazos[2]:screen-value in frame {&frame-name}  = " "
           cond-pagto.prazos[3]:screen-value in frame {&frame-name}  = " "
           cond-pagto.prazos[4]:screen-value in frame {&frame-name}  = " "
           cond-pagto.prazos[5]:screen-value in frame {&frame-name}  = " "
           cond-pagto.prazos[6]:screen-value in frame {&frame-name}  = " "
           cond-pagto.prazos[7]:screen-value in frame {&frame-name}  = " "
           cond-pagto.prazos[8]:screen-value in frame {&frame-name}  = " "
           cond-pagto.prazos[9]:screen-value in frame {&frame-name}  = " "
           cond-pagto.prazos[10]:screen-value in frame {&frame-name} = " "
           cond-pagto.prazos[11]:screen-value in frame {&frame-name} = " "
           cond-pagto.prazos[12]:screen-value in frame {&frame-name} = " "

           cond-pagto.per-pg-dup[1]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[2]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[3]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[4]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[5]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[6]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[7]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[8]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[9]:screen-value in frame {&frame-name}  = " "
           cond-pagto.per-pg-dup[10]:screen-value in frame {&frame-name} = " "
           cond-pagto.per-pg-dup[11]:screen-value in frame {&frame-name} = " "
           cond-pagto.per-pg-dup[12]:screen-value in frame {&frame-name} = " ".
      
           IF  i-pais-impto-usuario = 1 THEN
               ASSIGN cb-meio-pagto-01:screen-value in frame {&frame-name} = "":U
                      cb-meio-pagto-02:screen-value in frame {&frame-name} = "":U
                      cb-meio-pagto-03:screen-value in frame {&frame-name} = "":U
                      cb-meio-pagto-04:screen-value in frame {&frame-name} = "":U
                      cb-meio-pagto-05:screen-value in frame {&frame-name} = "":U
                      cb-meio-pagto-06:screen-value in frame {&frame-name} = "":U
                      cb-meio-pagto-07:screen-value in frame {&frame-name} = "":U
                      cb-meio-pagto-08:screen-value in frame {&frame-name} = "":U
                      cb-meio-pagto-09:screen-value in frame {&frame-name} = "":U
                      cb-meio-pagto-10:screen-value in frame {&frame-name} = "":U
                      cb-meio-pagto-11:screen-value in frame {&frame-name} = "":U
                      cb-meio-pagto-12:screen-value in frame {&frame-name} = "":U.

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
  def input parameter h-handle as handle no-undo.
  assign h-handle-atual = h-handle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-a-vista V-table-Win 
PROCEDURE pi-trata-a-vista :
/*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
------------------------------------------------------------------------------*/

    disable cond-pagto.num-parcelas 
            cond-pagto.prazos[1]
            cb-cod-ven-par-1   
            cond-pagto.per-pg-dup[1] 
            with frame {&frame-name}.

    /************************************************************ 
    *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
    ************************************************************/

    &if defined (bf_dis_desc_bonif) &then
        disable bt-calculo i-qtd-dias-prazo-medio
           with frame {&frame-name}.
    &endif

    run pi-limpa-campos.
    run pi-inicio-parcela.       

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
  define variable cb-cod-ven-par-array as integer extent 12 no-undo.
  define variable c-traduz             as character         no-undo.

  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
  assign de-per-pg = 0.
  do i-cont = 1 to 12.
     assign de-per-pg = de-per-pg + input frame {&frame-name} cond-pagto.per-pg-dup[i-cont].
  end. 

/* Teste para numero de parcelas igual a campos habilitados */
  assign i-nr-par = 0.
  if cond-pagto.prazos[1]:sensitive = yes then i-nr-par = 1.
  if cond-pagto.prazos[2]:sensitive = yes then i-nr-par = i-nr-par + 1.
  if cond-pagto.prazos[3]:sensitive = yes then i-nr-par = i-nr-par + 1.
  if cond-pagto.prazos[4]:sensitive = yes then i-nr-par = i-nr-par + 1.
  if cond-pagto.prazos[5]:sensitive = yes then i-nr-par = i-nr-par + 1.
  if cond-pagto.prazos[6]:sensitive = yes then i-nr-par = i-nr-par + 1.
  if cond-pagto.prazos[7]:sensitive = yes then i-nr-par = i-nr-par + 1.
  if cond-pagto.prazos[8]:sensitive = yes then i-nr-par = i-nr-par + 1.
  if cond-pagto.prazos[9]:sensitive = yes then i-nr-par = i-nr-par + 1.
  if cond-pagto.prazos[10]:sensitive = yes then i-nr-par = i-nr-par + 1.
  if cond-pagto.prazos[11]:sensitive = yes then i-nr-par = i-nr-par + 1.
  if cond-pagto.prazos[12]:sensitive = yes then i-nr-par = i-nr-par + 1.

  if i-nr-par <> 0 and
     i-nr-par <>   input frame {&frame-name} cond-pagto.num-parcelas then do:
      run pi-muda-pagina in h-handle-atual.      
      {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
      run utp/ut-msgs.p (input "show":U, input 6095, input " ").
      return 'ADM-ERROR':U.     
  end.

 /* Teste de percentual igual a 100 % */
  if  de-per-pg <> 100 then do:
      {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
      run utp/ut-msgs.p (input "show":U, input 4068, input " ").
      apply 'entry' to  cond-pagto.per-pg-dup[1] in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.

  do i-cont = 1 to (input frame {&frame-name} cond-pagto.num-parcelas).

 /* Teste p/ prazo menor que anterior */    
     if i-cont > 1 and
        cb-cod-ven-par-1:screen-value  <> cb-cod-ven-par-1:entry(7) then do:
        if (i-cont > 1) and
           (input frame {&frame-name} cond-pagto.prazos[i-cont] < input frame {&frame-name} cond-pagto.prazos[(i-cont) - (1)]) then do:
            {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
            run utp/ut-msgs.p (input "show":U, input 3937, input " ").
            apply 'entry' to  cond-pagto.prazos[1] in frame {&frame-name}.
            return 'ADM-ERROR':U.    
        end.
     end. 
  end.

  /*Mais Neg¢cios*/
  run Get-Field-Screen-Value in adm-broker-hdl (input this-procedure,
                                                input "log-cond-pagto-mais-negoc").

  if return-value = "Sim" then do:
      assign cb-cod-ven-par-array[1] = {diinc/i02di165.i 06 cb-cod-ven-par-1:screen-value}
             cb-cod-ven-par-array[2] = {diinc/i02di165.i 06 cb-cod-ven-par-2:screen-value}
             cb-cod-ven-par-array[3] = {diinc/i02di165.i 06 cb-cod-ven-par-3:screen-value}
             cb-cod-ven-par-array[4] = {diinc/i02di165.i 06 cb-cod-ven-par-4:screen-value}
             cb-cod-ven-par-array[5] = {diinc/i02di165.i 06 cb-cod-ven-par-5:screen-value}
             cb-cod-ven-par-array[6] = {diinc/i02di165.i 06 cb-cod-ven-par-6:screen-value}
             cb-cod-ven-par-array[7] = {diinc/i02di165.i 06 cb-cod-ven-par-7:screen-value}
             cb-cod-ven-par-array[8] = {diinc/i02di165.i 06 cb-cod-ven-par-8:screen-value}
             cb-cod-ven-par-array[9] = {diinc/i02di165.i 06 cb-cod-ven-par-9:screen-value}
             cb-cod-ven-par-array[10] = {diinc/i02di165.i 06 cb-cod-ven-par-10:screen-value}
             cb-cod-ven-par-array[11] = {diinc/i02di165.i 06 cb-cod-ven-par-11:screen-value}
             cb-cod-ven-par-array[12] = {diinc/i02di165.i 06 cb-cod-ven-par-12:screen-value}.

      do i-cont = 1 to (input frame {&frame-name} cond-pagto.num-parcelas).
          
          if cb-cod-ven-par-array[i-cont] = 3
          or cb-cod-ven-par-array[i-cont] = 4 then do:
              {utp/ut-liter.i Antecipado_e_Contra_Entrega * R}
              ASSIGN c-traduz = RETURN-VALUE.
              {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
              run utp/ut-msgs.p (input "show":U, input 57274, input c-traduz).
              return 'ADM-ERROR':U.
          end.
      end.
  end.
  /*Mais Neg¢cios*/

   /**************valida‡Æo do campo num-parcela*********************************/

   /*run pi-limpa-campos.*/

  run pi-inicio-parcela.  

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
  {src/adm/template/snd-list.i "cond-pagto"}

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

  /* Tratamentos p/ copia */
  IF p-state = "update-begin" THEN do:
      disable {&List-4} with frame {&frame-name}.    
      do i-cont  = 1 TO INPUT FRAME {&FRAME-NAME} mgadm.cond-pagto.num-parcelas :

          ENABLE cond-pagto.per-pg-dup[i-cont] 
                 cond-pagto.prazos[i-cont] WITH FRAME {&FRAME-NAME} .

          if i-cont = 1 then 
             enable cb-cod-ven-par-1  cb-meio-pagto-01 with frame {&frame-name}.      
          if i-cont = 2 then
             enable cb-cod-ven-par-2  cb-meio-pagto-02 with frame {&frame-name}.
          if i-cont = 3 then 
             enable cb-cod-ven-par-3  cb-meio-pagto-03 with frame {&frame-name}.
          if i-cont = 4 then      
             enable cb-cod-ven-par-4  cb-meio-pagto-04 with frame {&frame-name}.
          if i-cont = 5 then
             enable cb-cod-ven-par-5  cb-meio-pagto-05 with frame {&frame-name}.      
          if i-cont = 6 then
             enable cb-cod-ven-par-6  cb-meio-pagto-06 with frame {&frame-name}.      
          if i-cont = 7 then
             enable cb-cod-ven-par-7  cb-meio-pagto-07 with frame {&frame-name}.      
          if i-cont = 8 then
             enable cb-cod-ven-par-8  cb-meio-pagto-08 with frame {&frame-name}.      
          if i-cont = 9 then
             enable cb-cod-ven-par-9  cb-meio-pagto-09 with frame {&frame-name}.      
          if i-cont = 10 then
             enable cb-cod-ven-par-10 cb-meio-pagto-10 with frame {&frame-name}.      
          if i-cont = 11 then                                       
             enable cb-cod-ven-par-11 cb-meio-pagto-11 with frame {&frame-name}.
          if i-cont = 12 then
             enable cb-cod-ven-par-12 cb-meio-pagto-12 with frame {&frame-name}.
    end.

    RUN Get-Field-Screen-Value IN adm-broker-hdl
         (INPUT this-procedure,
          INPUT "cb-cod-vencto").

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista = {diinc/i02di165.i 03}
            cCodVencto = RETURN-VALUE.  
     run utp/ut-lstit.p (input-output cLista).
     run utp/ut-lstit.p (input-output cCodVencto).
     If  lookup(cCodVencto,cLista) mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(cCodVencto,cLista) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(cCodVencto,cLista) / 2.
   &else
     assign i-valor = lookup(return-value,{diinc/i02di165.i 03}).
   &endif                                  


     if  i-valor = 2 then do:
         run PI-TRATA-A-VISTA.
     end.

  END.

/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/

&if defined (bf_dis_desc_bonif) &then

&else 
  if p-state = "update-begin" then 
     run pi-esconde-campo-tela.
&endif


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



