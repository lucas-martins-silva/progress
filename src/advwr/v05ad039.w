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
{include/i-prgvrs.i V05AD039 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V05AD039 MUT}
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
def var i-prazos         like cond-pagto.prazos no-undo.
def var i-valor               as integer no-undo.
def var de-per-pg             as decimal no-undo.
def var c-variavel            as char    no-undo format "x(25)".
def var i-resto               as decimal no-undo.
def var i-soma                as decimal no-undo.
def var i-nr-par              as integer no-undo.
def var h_cd0404              as handle  no-undo.
DEF VAR h_v02ad039            AS HANDLE  NO-UNDO.
def var c-cod-venc-par-1-temp as char    no-undo.
def var c-cod-venc-par-2-temp as char    no-undo.
def var c-cod-venc-par-3-temp as char    no-undo.

def var i-cod-vencto          as integer extent 12 no-undo.
def var i-qtd-dias            as decimal no-undo.

DEF VAR l-atualiza            AS LOGICAL NO-UNDO.

DEFINE VARIABLE l-data-fixa   AS LOGICAL NO-UNDO.
DEFINE VARIABLE dt-data-1     AS DATE    NO-UNDO.

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/

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
&Scoped-define EXTERNAL-TABLES cond-pagto
&Scoped-define FIRST-EXTERNAL-TABLE cond-pagto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cond-pagto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cond-pagto.num-parcelas ~
cond-pagto.per-pg-dup[1] 
&Scoped-define ENABLED-TABLES cond-pagto
&Scoped-define FIRST-ENABLED-TABLE cond-pagto
&Scoped-Define ENABLED-OBJECTS bt-rateio RECT-1 RECT-10 RECT-11 RECT-12 ~
RECT-13 RECT-2 RECT-3 RECT-5 RECT-6 RECT-7 RECT-8 RECT-9 
&Scoped-Define DISPLAYED-FIELDS cond-pagto.num-parcelas ~
cond-pagto.per-pg-dup[1] cond-pagto.per-pg-dup[2] cond-pagto.per-pg-dup[3] ~
cond-pagto.per-pg-dup[4] cond-pagto.per-pg-dup[5] cond-pagto.per-pg-dup[6] ~
cond-pagto.per-pg-dup[7] cond-pagto.per-pg-dup[8] cond-pagto.per-pg-dup[9] ~
cond-pagto.per-pg-dup[10] cond-pagto.per-pg-dup[11] ~
cond-pagto.per-pg-dup[12] 
&Scoped-define DISPLAYED-TABLES cond-pagto
&Scoped-define FIRST-DISPLAYED-TABLE cond-pagto
&Scoped-Define DISPLAYED-OBJECTS fi-dia-semana-1 fi-prazos-1 fi-prazos-2 ~
fi-prazos-3 fi-prazos-4 fi-prazos-5 fi-prazos-6 fi-prazos-7 fi-prazos-8 ~
fi-prazos-9 fi-prazos-10 fi-prazos-11 fi-prazos-12 fi-dia-semana-2 ~
fi-dia-semana-3 fi-dia-semana-4 fi-dia-semana-5 fi-dia-semana-6 ~
fi-dia-semana-7 fi-dia-semana-8 fi-dia-semana-9 fi-dia-semana-10 ~
fi-dia-semana-11 fi-dia-semana-12 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS fi-prazos-1 cond-pagto.per-pg-dup[1] ~
fi-prazos-2 cond-pagto.per-pg-dup[2] fi-prazos-3 cond-pagto.per-pg-dup[3] ~
fi-prazos-4 cond-pagto.per-pg-dup[4] fi-prazos-5 cond-pagto.per-pg-dup[5] ~
fi-prazos-6 cond-pagto.per-pg-dup[6] fi-prazos-7 cond-pagto.per-pg-dup[7] ~
fi-prazos-8 cond-pagto.per-pg-dup[8] fi-prazos-9 cond-pagto.per-pg-dup[9] ~
fi-prazos-10 cond-pagto.per-pg-dup[10] fi-prazos-11 ~
cond-pagto.per-pg-dup[11] fi-prazos-12 cond-pagto.per-pg-dup[12] 
&Scoped-define List-4 fi-prazos-1 cond-pagto.per-pg-dup[1] fi-prazos-2 ~
cond-pagto.per-pg-dup[2] fi-prazos-3 cond-pagto.per-pg-dup[3] fi-prazos-4 ~
cond-pagto.per-pg-dup[4] fi-prazos-5 cond-pagto.per-pg-dup[5] fi-prazos-6 ~
cond-pagto.per-pg-dup[6] fi-prazos-7 cond-pagto.per-pg-dup[7] fi-prazos-8 ~
cond-pagto.per-pg-dup[8] fi-prazos-9 cond-pagto.per-pg-dup[9] fi-prazos-10 ~
cond-pagto.per-pg-dup[10] fi-prazos-11 cond-pagto.per-pg-dup[11] ~
fi-prazos-12 cond-pagto.per-pg-dup[12] 

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
DEFINE BUTTON bt-rateio 
     LABEL "" 
     SIZE 8.43 BY 1.13.

DEFINE VARIABLE fi-01 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13 BY .71 NO-UNDO.

DEFINE VARIABLE fi-04 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10.29 BY .71 NO-UNDO.

DEFINE VARIABLE fi-05 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13 BY .71 NO-UNDO.

DEFINE VARIABLE fi-08 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10.29 BY .71 NO-UNDO.

DEFINE VARIABLE fi-dia-semana-1 AS CHARACTER FORMAT "X(7)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dia-semana-10 AS CHARACTER FORMAT "X(7)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dia-semana-11 AS CHARACTER FORMAT "X(7)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dia-semana-12 AS CHARACTER FORMAT "X(7)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dia-semana-2 AS CHARACTER FORMAT "X(7)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dia-semana-3 AS CHARACTER FORMAT "X(7)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dia-semana-4 AS CHARACTER FORMAT "X(7)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dia-semana-5 AS CHARACTER FORMAT "X(7)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dia-semana-6 AS CHARACTER FORMAT "X(7)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dia-semana-7 AS CHARACTER FORMAT "X(7)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dia-semana-8 AS CHARACTER FORMAT "X(7)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dia-semana-9 AS CHARACTER FORMAT "X(7)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-prazos-1 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-prazos-10 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-prazos-11 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-prazos-12 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-prazos-2 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-prazos-3 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-prazos-4 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-prazos-5 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-prazos-6 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-prazos-7 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-prazos-8 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-prazos-9 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 4 BY .79.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 4 BY .79.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 4 BY .79.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 4 BY .79.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.29 BY 10.83.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 4 BY .79.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 4 BY .79.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 4 BY .79.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 4 BY .79.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 4 BY .79.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 4 BY .79.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 4 BY .79.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 4 BY .79.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-dia-semana-1 AT ROW 4 COL 20.43 COLON-ALIGNED NO-LABEL
     cond-pagto.num-parcelas AT ROW 1.25 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     bt-rateio AT ROW 1.17 COL 54
     fi-prazos-1 AT ROW 4 COL 10 COLON-ALIGNED NO-LABEL
     fi-01 AT ROW 3.25 COL 10 COLON-ALIGNED NO-LABEL
     fi-05 AT ROW 3.25 COL 51 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[1] AT ROW 4 COL 28.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     fi-prazos-2 AT ROW 5 COL 10 COLON-ALIGNED NO-LABEL
     fi-04 AT ROW 3.25 COL 28.86 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[2] AT ROW 5 COL 28.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     fi-prazos-3 AT ROW 6 COL 10 COLON-ALIGNED NO-LABEL
     fi-08 AT ROW 3.25 COL 69.86 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[3] AT ROW 6 COL 28.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     fi-prazos-4 AT ROW 7 COL 10 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[4] AT ROW 7 COL 28.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     fi-prazos-5 AT ROW 8 COL 10 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[5] AT ROW 8 COL 28.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     fi-prazos-6 AT ROW 9 COL 10 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[6] AT ROW 9 COL 28.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     fi-prazos-7 AT ROW 4 COL 51 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[7] AT ROW 4 COL 69.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     fi-prazos-8 AT ROW 5 COL 51 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[8] AT ROW 5 COL 69.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     fi-prazos-9 AT ROW 6 COL 51 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[9] AT ROW 6 COL 69.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     fi-prazos-10 AT ROW 7 COL 51 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[10] AT ROW 7 COL 69.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     fi-prazos-11 AT ROW 8 COL 51 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[11] AT ROW 8 COL 69.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     fi-prazos-12 AT ROW 9 COL 51 COLON-ALIGNED NO-LABEL
     cond-pagto.per-pg-dup[12] AT ROW 9 COL 69.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     fi-dia-semana-2 AT ROW 5 COL 20.43 COLON-ALIGNED NO-LABEL
     fi-dia-semana-3 AT ROW 6 COL 20.43 COLON-ALIGNED NO-LABEL
     fi-dia-semana-4 AT ROW 7 COL 20.43 COLON-ALIGNED NO-LABEL
     fi-dia-semana-5 AT ROW 8 COL 20.43 COLON-ALIGNED NO-LABEL
     fi-dia-semana-6 AT ROW 9 COL 20.43 COLON-ALIGNED NO-LABEL
     fi-dia-semana-7 AT ROW 4 COL 61.43 COLON-ALIGNED NO-LABEL
     fi-dia-semana-8 AT ROW 5 COL 61.43 COLON-ALIGNED NO-LABEL
     fi-dia-semana-9 AT ROW 6 COL 61.43 COLON-ALIGNED NO-LABEL
     fi-dia-semana-10 AT ROW 7 COL 61.43 COLON-ALIGNED NO-LABEL
     fi-dia-semana-11 AT ROW 8 COL 61.43 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     fi-dia-semana-12 AT ROW 9 COL 61.43 COLON-ALIGNED NO-LABEL
     "1" VIEW-AS TEXT
          SIZE 1.29 BY .63 AT ROW 4.13 COL 9
     "11" VIEW-AS TEXT
          SIZE 2.29 BY .5 AT ROW 8.13 COL 49.57
     "6" VIEW-AS TEXT
          SIZE 1.29 BY .58 AT ROW 9.13 COL 9
     "12" VIEW-AS TEXT
          SIZE 2.29 BY .58 AT ROW 9.13 COL 49.57
     "7" VIEW-AS TEXT
          SIZE 1.29 BY .38 AT ROW 4.25 COL 49.57
     "2" VIEW-AS TEXT
          SIZE 1.29 BY .58 AT ROW 5.13 COL 9
     "8" VIEW-AS TEXT
          SIZE 1.43 BY .42 AT ROW 5.21 COL 49.57
     "3" VIEW-AS TEXT
          SIZE 1.86 BY .5 AT ROW 6.13 COL 9
     "9" VIEW-AS TEXT
          SIZE 1.43 BY .46 AT ROW 6.17 COL 49.57
     "4" VIEW-AS TEXT
          SIZE 1.86 BY .58 AT ROW 7.13 COL 9
     "10" VIEW-AS TEXT
          SIZE 2.29 BY .42 AT ROW 7.13 COL 49.57
     "5" VIEW-AS TEXT
          SIZE 1.29 BY .5 AT ROW 8.13 COL 9
     RECT-4 AT ROW 7 COL 8
     RECT-1 AT ROW 4.04 COL 8
     RECT-10 AT ROW 7 COL 49
     RECT-11 AT ROW 8 COL 49
     RECT-12 AT ROW 9 COL 49
     RECT-13 AT ROW 1 COL 1
     RECT-2 AT ROW 5 COL 8
     RECT-3 AT ROW 6 COL 8
     RECT-5 AT ROW 8 COL 8
     RECT-6 AT ROW 9 COL 8
     RECT-7 AT ROW 4 COL 49
     RECT-8 AT ROW 5 COL 49
     RECT-9 AT ROW 6 COL 49
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
         WIDTH              = 85.29.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi-01 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-04 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-05 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-08 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-dia-semana-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dia-semana-10 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dia-semana-11 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dia-semana-12 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dia-semana-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dia-semana-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dia-semana-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dia-semana-5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dia-semana-6 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dia-semana-7 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dia-semana-8 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dia-semana-9 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-prazos-1 IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN fi-prazos-10 IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN fi-prazos-11 IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN fi-prazos-12 IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN fi-prazos-2 IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN fi-prazos-3 IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN fi-prazos-4 IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN fi-prazos-5 IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN fi-prazos-6 IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN fi-prazos-7 IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN fi-prazos-8 IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN fi-prazos-9 IN FRAME f-main
   NO-ENABLE 2 4                                                        */
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

&Scoped-define SELF-NAME bt-rateio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-rateio V-table-Win
ON CHOOSE OF bt-rateio IN FRAME f-main
DO:
    ASSIGN i-cont = INT(INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas:SCREEN-VALUE) + 1.

    DO WHILE i-cont <= 12:
        IF i-cont = 1 THEN
            ASSIGN fi-prazos-1 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
        IF i-cont = 2 THEN
            ASSIGN fi-prazos-2 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
        IF i-cont = 3 THEN
            ASSIGN fi-prazos-3 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
        IF i-cont = 4 THEN
            ASSIGN fi-prazos-4 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
        IF i-cont = 5 THEN
            ASSIGN fi-prazos-5 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
        IF i-cont = 6 THEN
            ASSIGN fi-prazos-6 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
        IF i-cont = 7 THEN
            ASSIGN fi-prazos-7 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
        IF i-cont = 8 THEN
            ASSIGN fi-prazos-8 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
        IF i-cont = 9 THEN
            ASSIGN fi-prazos-9 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
        IF i-cont = 10 THEN
            ASSIGN fi-prazos-10:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
        IF i-cont = 11 THEN
            ASSIGN fi-prazos-11:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
        IF i-cont = 12 THEN
            ASSIGN fi-prazos-12:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
        i-cont = i-cont + 1.
    END.

    ASSIGN cond-pagto.per-pg-dup[1] :SCREEN-VALUE IN FRAME {&frame-name} = " "
           cond-pagto.per-pg-dup[2] :SCREEN-VALUE IN FRAME {&frame-name} = " "
           cond-pagto.per-pg-dup[3] :SCREEN-VALUE IN FRAME {&frame-name} = " "
           cond-pagto.per-pg-dup[4] :SCREEN-VALUE IN FRAME {&frame-name} = " "
           cond-pagto.per-pg-dup[5] :SCREEN-VALUE IN FRAME {&frame-name} = " "
           cond-pagto.per-pg-dup[6] :SCREEN-VALUE IN FRAME {&frame-name} = " "
           cond-pagto.per-pg-dup[7] :SCREEN-VALUE IN FRAME {&frame-name} = " "
           cond-pagto.per-pg-dup[8] :SCREEN-VALUE IN FRAME {&frame-name} = " "
           cond-pagto.per-pg-dup[9] :SCREEN-VALUE IN FRAME {&frame-name} = " "
           cond-pagto.per-pg-dup[10]:SCREEN-VALUE IN FRAME {&frame-name} = " "
           cond-pagto.per-pg-dup[11]:SCREEN-VALUE IN FRAME {&frame-name} = " "
           cond-pagto.per-pg-dup[12]:SCREEN-VALUE IN FRAME {&frame-name} = " ".

    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                  INPUT "cb-cod-vencto").

    ASSIGN i-valor = LOOKUP(RETURN-VALUE,{diinc\i02di165.i 03}).

    IF i-valor <> 2 AND
       i-valor <> 3 AND
       i-valor <> 4 THEN DO:

        ASSIGN de-perc-equiv = TRUNC(100 / INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas,2)
               i-resto       = 0
               i-soma        = de-perc-equiv * (INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas).
               i-resto       = 100 - i-soma.

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas >= 1 THEN  
            ASSIGN cond-pagto.per-pg-dup[1]:SCREEN-VALUE = STRING(de-perc-equiv).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas >= 2 THEN
            ASSIGN cond-pagto.per-pg-dup[2]:SCREEN-VALUE = STRING(de-perc-equiv).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas >= 3 THEN 
            ASSIGN cond-pagto.per-pg-dup[3]:SCREEN-VALUE = STRING(de-perc-equiv).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas >= 4 THEN
            ASSIGN cond-pagto.per-pg-dup[4]:SCREEN-VALUE = STRING(de-perc-equiv).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas >= 5 THEN
            ASSIGN cond-pagto.per-pg-dup[5]:SCREEN-VALUE = STRING(de-perc-equiv).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas >= 6 THEN
            ASSIGN cond-pagto.per-pg-dup[6]:SCREEN-VALUE = STRING(de-perc-equiv).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas >= 7 THEN
            ASSIGN cond-pagto.per-pg-dup[7]:SCREEN-VALUE = STRING(de-perc-equiv).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas >= 8 THEN
            ASSIGN cond-pagto.per-pg-dup[8]:SCREEN-VALUE = STRING(de-perc-equiv).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas >= 9 THEN
            ASSIGN cond-pagto.per-pg-dup[9]:SCREEN-VALUE = STRING(de-perc-equiv).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas >= 10 THEN
            ASSIGN cond-pagto.per-pg-dup[10]:SCREEN-VALUE = STRING(de-perc-equiv).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas >= 11 THEN
            ASSIGN cond-pagto.per-pg-dup[11]:SCREEN-VALUE = STRING(de-perc-equiv).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas >= 12 THEN
            ASSIGN cond-pagto.per-pg-dup[12]:SCREEN-VALUE = STRING(de-perc-equiv).

        /* Acrescenta o resto a ultima parcela */
        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas = 3 THEN
            ASSIGN cond-pagto.per-pg-dup[3]:SCREEN-VALUE = STRING(de-perc-equiv + i-resto).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas = 4 THEN
            ASSIGN cond-pagto.per-pg-dup[4]:SCREEN-VALUE = STRING(de-perc-equiv + i-resto).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas = 6 THEN
            ASSIGN cond-pagto.per-pg-dup[6]:SCREEN-VALUE = STRING(de-perc-equiv + i-resto).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas = 7 THEN
            ASSIGN cond-pagto.per-pg-dup[7]:SCREEN-VALUE = STRING(de-perc-equiv + i-resto).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas = 8 THEN
            ASSIGN cond-pagto.per-pg-dup[8]:SCREEN-VALUE = STRING(de-perc-equiv + i-resto).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas = 9 THEN
            ASSIGN cond-pagto.per-pg-dup[9]:SCREEN-VALUE = STRING(de-perc-equiv + i-resto).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas = 11 THEN
            ASSIGN cond-pagto.per-pg-dup[11]:SCREEN-VALUE = STRING(de-perc-equiv + i-resto).

        IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas = 12 THEN
            ASSIGN cond-pagto.per-pg-dup[12]:SCREEN-VALUE = STRING(de-perc-equiv + i-resto).
    END.

    IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas = 1         OR
       cond-pagto.num-parcelas:SENSITIVE IN FRAME {&FRAME-NAME} = NO THEN
        DISABLE bt-rateio WITH FRAME {&FRAME-NAME}.
    ELSE
        ENABLE bt-rateio WITH FRAME {&FRAME-NAME}.

    APPLY 'LEAVE' TO fi-prazos-1  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-2  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-3  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-4  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-5  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-6  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-7  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-8  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-9  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-10 IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-11 IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-12 IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-prazos-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-prazos-1 V-table-Win
ON LEAVE OF fi-prazos-1 IN FRAME f-main
DO:
    ASSIGN fi-prazos-1.
    RUN pi-dia-semana IN THIS-PROCEDURE (INPUT 1,
                                         INPUT fi-prazos-1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-prazos-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-prazos-10 V-table-Win
ON LEAVE OF fi-prazos-10 IN FRAME f-main
DO:
    ASSIGN fi-prazos-10.
    RUN pi-dia-semana IN THIS-PROCEDURE (INPUT 10,
                                         INPUT fi-prazos-10).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-prazos-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-prazos-11 V-table-Win
ON LEAVE OF fi-prazos-11 IN FRAME f-main
DO:
    ASSIGN fi-prazos-11.
    RUN pi-dia-semana IN THIS-PROCEDURE (INPUT 11,
                                         INPUT fi-prazos-11).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-prazos-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-prazos-12 V-table-Win
ON LEAVE OF fi-prazos-12 IN FRAME f-main
DO:
    ASSIGN fi-prazos-12.
    RUN pi-dia-semana IN THIS-PROCEDURE (INPUT 12,
                                         INPUT fi-prazos-12).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-prazos-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-prazos-2 V-table-Win
ON LEAVE OF fi-prazos-2 IN FRAME f-main
DO:
    ASSIGN fi-prazos-2.
    RUN pi-dia-semana IN THIS-PROCEDURE (INPUT 2,
                                         INPUT fi-prazos-2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-prazos-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-prazos-3 V-table-Win
ON LEAVE OF fi-prazos-3 IN FRAME f-main
DO:
    ASSIGN fi-prazos-3.
    RUN pi-dia-semana IN THIS-PROCEDURE (INPUT 3,
                                         INPUT fi-prazos-3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-prazos-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-prazos-4 V-table-Win
ON LEAVE OF fi-prazos-4 IN FRAME f-main
DO:
    ASSIGN fi-prazos-4.
    RUN pi-dia-semana IN THIS-PROCEDURE (INPUT 4,
                                         INPUT fi-prazos-4).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-prazos-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-prazos-5 V-table-Win
ON LEAVE OF fi-prazos-5 IN FRAME f-main
DO:
    ASSIGN fi-prazos-5.
    RUN pi-dia-semana IN THIS-PROCEDURE (INPUT 5,
                                         INPUT fi-prazos-5).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-prazos-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-prazos-6 V-table-Win
ON LEAVE OF fi-prazos-6 IN FRAME f-main
DO:
    ASSIGN fi-prazos-6.
    RUN pi-dia-semana IN THIS-PROCEDURE (INPUT 6,
                                         INPUT fi-prazos-6).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-prazos-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-prazos-7 V-table-Win
ON LEAVE OF fi-prazos-7 IN FRAME f-main
DO:
    ASSIGN fi-prazos-7.
    RUN pi-dia-semana IN THIS-PROCEDURE (INPUT 7,
                                         INPUT fi-prazos-7).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-prazos-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-prazos-8 V-table-Win
ON LEAVE OF fi-prazos-8 IN FRAME f-main
DO:
    ASSIGN fi-prazos-8.
    RUN pi-dia-semana IN THIS-PROCEDURE (INPUT 8,
                                         INPUT fi-prazos-8).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-prazos-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-prazos-9 V-table-Win
ON LEAVE OF fi-prazos-9 IN FRAME f-main
DO:
    ASSIGN fi-prazos-9.
    RUN pi-dia-semana IN THIS-PROCEDURE (INPUT 9,
                                         INPUT fi-prazos-9).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.num-parcelas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.num-parcelas V-table-Win
ON LEAVE OF cond-pagto.num-parcelas IN FRAME f-main /* Num Parcelas */
DO:
    /* habilita campos */
    ASSIGN i-cont = 1.

    DO WHILE i-cont <= 12:
        CASE i-cont:
            WHEN 1 THEN
                ENABLE fi-prazos-1 WITH FRAME {&FRAME-NAME}.
            WHEN 2 THEN
                ENABLE fi-prazos-2 WITH FRAME {&FRAME-NAME}.
            WHEN 3 THEN
                ENABLE fi-prazos-3 WITH FRAME {&FRAME-NAME}.
            WHEN 4 THEN
                ENABLE fi-prazos-4 WITH FRAME {&FRAME-NAME}.
            WHEN 5 THEN
                ENABLE fi-prazos-5 WITH FRAME {&FRAME-NAME}.
            WHEN 6 THEN
                ENABLE fi-prazos-6 WITH FRAME {&FRAME-NAME}.
            WHEN 7 THEN
                ENABLE fi-prazos-7 WITH FRAME {&FRAME-NAME}.
            WHEN 8 THEN
                ENABLE fi-prazos-8 WITH FRAME {&FRAME-NAME}.
            WHEN 9 THEN
                ENABLE fi-prazos-9 WITH FRAME {&FRAME-NAME}.
            WHEN 10 THEN
                ENABLE fi-prazos-10 WITH FRAME {&FRAME-NAME}.
            WHEN 11 THEN
                ENABLE fi-prazos-11 WITH FRAME {&FRAME-NAME}.
            WHEN 12 THEN
                ENABLE fi-prazos-12 WITH FRAME {&FRAME-NAME}.
        END CASE.

        ENABLE  cond-pagto.per-pg-dup[i-cont]  WITH FRAME {&FRAME-NAME}.
        ASSIGN i-cont = i-cont + 1.
    END.

    /* Desabilita campos conforme numero parcelas */
    RUN pi-desabilitaCampos.

    APPLY 'CHOOSE' TO bt-rateio   IN FRAME {&FRAME-NAME}.   
    APPLY 'ENTRY'  TO fi-prazos-1 IN FRAME {&FRAME-NAME}.

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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */


  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF       

/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/


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

    ASSIGN cond-pagto.per-pg-dup[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "100". 

    IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas = 1         OR
       cond-pagto.num-parcelas:SENSITIVE IN FRAME {&FRAME-NAME} = NO THEN
        DISABLE bt-rateio WITH FRAME {&FRAME-NAME}.
    ELSE
        ENABLE bt-rateio WITH FRAME {&FRAME-NAME}.

    APPLY 'LEAVE' TO cond-pagto.num-parcelas IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

RUN pi-get-screen-value IN h_v02ad039 (OUTPUT l-data-fixa).

IF l-data-fixa THEN DO:

    ASSIGN i-prazos[1]   = 0
           i-prazos[2]   = IF fi-prazos-2  <> ? THEN fi-prazos-2  - fi-prazos-1
                                    ELSE 0
           i-prazos[3]   = IF fi-prazos-3  <> ? THEN fi-prazos-3  - fi-prazos-1
                                    ELSE 0
           i-prazos[4]   = IF fi-prazos-4  <> ? THEN fi-prazos-4  - fi-prazos-1
                                    ELSE 0
           i-prazos[5]   = IF fi-prazos-5  <> ? THEN fi-prazos-5  - fi-prazos-1
                                    ELSE 0
           i-prazos[6]   = IF fi-prazos-6  <> ? THEN fi-prazos-6  - fi-prazos-1
                                    ELSE 0
           i-prazos[7]   = IF fi-prazos-7  <> ? THEN fi-prazos-7  - fi-prazos-1
                                    ELSE 0
           i-prazos[8]   = IF fi-prazos-8  <> ? THEN fi-prazos-8  - fi-prazos-1
                                    ELSE 0
           i-prazos[9]   = IF fi-prazos-9  <> ? THEN fi-prazos-9  - fi-prazos-1
                                    ELSE 0
           i-prazos[10]  = IF fi-prazos-10 <> ? THEN fi-prazos-10 - fi-prazos-1
                                    ELSE 0
           i-prazos[11]  = IF fi-prazos-11 <> ? THEN fi-prazos-11 - fi-prazos-1
                                    ELSE 0
           i-prazos[12]  = IF fi-prazos-12 <> ? THEN fi-prazos-12 - fi-prazos-1
                                    ELSE 0
           dt-data-1      = fi-prazos-1.

/*     &IF DEFINED (bf_dis_gradiente) &THEN                                                   */
/*         IF NOT adm-new-record                                                         AND  */
/*            INPUT FRAME {&FRAME-NAME} i-qtd-dias-prazo-medio <> i-qtd-dias-prazo-medio THEN */
/*             ASSIGN l-atualiza = YES.                                                       */
/*         ELSE                                                                               */
/*             ASSIGN l-atualiza = NO.                                                        */
/*     &ENDIF                                                                                 */

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).

    ASSIGN cond-pagto.cod-ven-par = 1 /*Dias da Data*/
           cond-pagto.prazos[1]      = i-prazos[1] 
           cond-pagto.prazos[2]      = i-prazos[2] 
           cond-pagto.prazos[3]      = i-prazos[3] 
           cond-pagto.prazos[4]      = i-prazos[4] 
           cond-pagto.prazos[5]      = i-prazos[5] 
           cond-pagto.prazos[6]      = i-prazos[6] 
           cond-pagto.prazos[7]      = i-prazos[7] 
           cond-pagto.prazos[8]      = i-prazos[8] 
           cond-pagto.prazos[9]      = i-prazos[9] 
           cond-pagto.prazos[10]     = i-prazos[10]
           cond-pagto.prazos[11]     = i-prazos[11]
           cond-pagto.prazos[12]     = i-prazos[12]
           &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
           cond-pagto.dat-vencto-fix = dt-data-1.
           &ELSE
           cond-pagto.data-1         = dt-data-1.
           &ENDIF
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ).

    /* Tratamentos p/ modificacao */
    DISABLE {&List-4} WITH FRAME {&frame-name}.

    DO i-cont = 1 TO INPUT FRAME {&FRAME-NAME} mgadm.cond-pagto.num-parcelas:

        ENABLE cond-pagto.per-pg-dup[i-cont] WITH FRAME {&FRAME-NAME}.

        CASE i-cont:
            WHEN 1 THEN
                ENABLE fi-prazos-1 WITH FRAME {&FRAME-NAME}.
            WHEN 2 THEN
                ENABLE fi-prazos-2 WITH FRAME {&FRAME-NAME}.
            WHEN 3 THEN
                ENABLE fi-prazos-3 WITH FRAME {&FRAME-NAME}.
            WHEN 4 THEN
                ENABLE fi-prazos-4 WITH FRAME {&FRAME-NAME}.
            WHEN 5 THEN
                ENABLE fi-prazos-5 WITH FRAME {&FRAME-NAME}.
            WHEN 6 THEN
                ENABLE fi-prazos-6 WITH FRAME {&FRAME-NAME}.
            WHEN 7 THEN
                ENABLE fi-prazos-7 WITH FRAME {&FRAME-NAME}.
            WHEN 8 THEN
                ENABLE fi-prazos-8 WITH FRAME {&FRAME-NAME}.
            WHEN 9 THEN
                ENABLE fi-prazos-9 WITH FRAME {&FRAME-NAME}.
            WHEN 10 THEN
                ENABLE fi-prazos-10 WITH FRAME {&FRAME-NAME}.
            WHEN 11 THEN
                ENABLE fi-prazos-11 WITH FRAME {&FRAME-NAME}.
            WHEN 12 THEN
                ENABLE fi-prazos-12 WITH FRAME {&FRAME-NAME}.
        END CASE.
    END.

    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                  INPUT "cb-cod-vencto").
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
    DISABLE {&List-4} WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    {utp/ut-liter.i Data_Pagto * r}
    ASSIGN fi-01:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RETURN-VALUE.
    {utp/ut-liter.i Data_Pagto * r}
    ASSIGN fi-05:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RETURN-VALUE.
    {utp/ut-field.i mgadm cond-pagto per-pg-dup 1}
    ASSIGN fi-04:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RETURN-VALUE.
    {utp/ut-field.i mgadm cond-pagto per-pg-dup 1}
    ASSIGN fi-08:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RETURN-VALUE.

    {utp/ut-liter.i Ratear * c}
    ASSIGN bt-rateio:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

    IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas = 1         OR
       cond-pagto.num-parcelas:SENSITIVE IN FRAME {&FRAME-NAME} = NO THEN
        DISABLE bt-rateio WITH FRAME {&FRAME-NAME}.
    ELSE
        ENABLE bt-rateio WITH FRAME {&FRAME-NAME}.

    &IF "{&bf_dis_versao_ems}" >= "2.06":U &THEN
        ASSIGN fi-prazos-1 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(cond-pagto.dat-vencto-fix)
               fi-prazos-2 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[2]  > 0 THEN STRING(cond-pagto.dat-vencto-fix + cond-pagto.prazos[2])
                                                                  ELSE " "
               fi-prazos-3 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[3]  > 0 THEN STRING(cond-pagto.dat-vencto-fix + cond-pagto.prazos[3])
                                                                  ELSE " "
               fi-prazos-4 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[4]  > 0 THEN STRING(cond-pagto.dat-vencto-fix + cond-pagto.prazos[4])
                                                                  ELSE " "
               fi-prazos-5 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[5]  > 0 THEN STRING(cond-pagto.dat-vencto-fix + cond-pagto.prazos[5])
                                                                  ELSE " "
               fi-prazos-6 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[6]  > 0 THEN STRING(cond-pagto.dat-vencto-fix + cond-pagto.prazos[6])
                                                                  ELSE " "
               fi-prazos-7 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[7]  > 0 THEN STRING(cond-pagto.dat-vencto-fix + cond-pagto.prazos[7])
                                                                  ELSE " "
               fi-prazos-8 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[8]  > 0 THEN STRING(cond-pagto.dat-vencto-fix + cond-pagto.prazos[8])
                                                                  ELSE " "
               fi-prazos-9 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[9]  > 0 THEN STRING(cond-pagto.dat-vencto-fix + cond-pagto.prazos[9])
                                                                  ELSE " "
               fi-prazos-10:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[10] > 0 THEN STRING(cond-pagto.dat-vencto-fix + cond-pagto.prazos[10])
                                                                  ELSE " "
               fi-prazos-11:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[11] > 0 THEN STRING(cond-pagto.dat-vencto-fix + cond-pagto.prazos[11])
                                                                  ELSE " "
               fi-prazos-12:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[12] > 0 THEN STRING(cond-pagto.dat-vencto-fix + cond-pagto.prazos[12])
                                                                  ELSE " ".
    &ELSE
        ASSIGN fi-prazos-1 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(cond-pagto.data-1)
               fi-prazos-2 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[2]  > 0 THEN STRING(cond-pagto.data-1 + cond-pagto.prazos[2])
                                                                  ELSE " "
               fi-prazos-3 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[3]  > 0 THEN STRING(cond-pagto.data-1 + cond-pagto.prazos[3])
                                                                  ELSE " "
               fi-prazos-4 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[4]  > 0 THEN STRING(cond-pagto.data-1 + cond-pagto.prazos[4])
                                                                  ELSE " "
               fi-prazos-5 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[5]  > 0 THEN STRING(cond-pagto.data-1 + cond-pagto.prazos[5])
                                                                  ELSE " "
               fi-prazos-6 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[6]  > 0 THEN STRING(cond-pagto.data-1 + cond-pagto.prazos[6])
                                                                  ELSE " "
               fi-prazos-7 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[7]  > 0 THEN STRING(cond-pagto.data-1 + cond-pagto.prazos[7])
                                                                  ELSE " "
               fi-prazos-8 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[8]  > 0 THEN STRING(cond-pagto.data-1 + cond-pagto.prazos[8])
                                                                  ELSE " "
               fi-prazos-9 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[9]  > 0 THEN STRING(cond-pagto.data-1 + cond-pagto.prazos[9])
                                                                  ELSE " "
               fi-prazos-10:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[10] > 0 THEN STRING(cond-pagto.data-1 + cond-pagto.prazos[10])
                                                                  ELSE " "
               fi-prazos-11:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[11] > 0 THEN STRING(cond-pagto.data-1 + cond-pagto.prazos[11])
                                                                  ELSE " "
               fi-prazos-12:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF cond-pagto.prazos[12] > 0 THEN STRING(cond-pagto.data-1 + cond-pagto.prazos[12])
                                                                  ELSE " ".
    &ENDIF

    APPLY 'LEAVE' TO fi-prazos-1  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-2  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-3  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-4  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-5  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-6  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-7  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-8  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-9  IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-10 IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-11 IN FRAME {&FRAME-NAME}.
    APPLY 'LEAVE' TO fi-prazos-12 IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    RUN GET-ATTRIBUTE ('adm-new-record').

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    &IF DEFINED(ADM-MODIFY-FIELDS) &THEN
        ENABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&FRAME-NAME}.
    &ENDIF

    IF INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas        = 1  OR
       cond-pagto.num-parcelas:SENSITIVE IN FRAME {&FRAME-NAME} = NO THEN
        DISABLE bt-rateio WITH FRAME {&FRAME-NAME}.
    ELSE
        ENABLE bt-rateio WITH FRAME {&FRAME-NAME}.

    APPLY 'LEAVE' TO cond-pagto.num-parcelas IN FRAME {&FRAME-NAME}.

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
    &IF DEFINED (bf_dis_gradiente) &THEN
        IF l-atualiza         AND
           NOT adm-new-record THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 959,
                               INPUT "").

            IF RETURN-VALUE = "yes" THEN
                RUN cdp/cd0404b.p (INPUT cond-pagto.cod-cond-pag).
        END.
    &ENDIF

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE (INPUT 'end-update':U).

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

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ).

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

    APPLY 'entry' TO cond-pagto.num-parcelas IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilitaCampos V-table-Win 
PROCEDURE pi-desabilitaCampos :
/*------------------------------------------------------------------------------
  Purpose: Desabilita campos conforme numero parcelas
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN i-cont = INT(cond-pagto.num-parcelas:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + 1. 

    DO WHILE i-cont <= 12:
        CASE i-cont:
            WHEN 1 THEN
                DISABLE fi-prazos-1 WITH FRAME {&FRAME-NAME}.
            WHEN 2 THEN
                DISABLE fi-prazos-2 WITH FRAME {&FRAME-NAME}.
            WHEN 3 THEN
                DISABLE fi-prazos-3 WITH FRAME {&FRAME-NAME}.
            WHEN 4 THEN
                DISABLE fi-prazos-4 WITH FRAME {&FRAME-NAME}.
            WHEN 5 THEN
                DISABLE fi-prazos-5 WITH FRAME {&FRAME-NAME}.
            WHEN 6 THEN
                DISABLE fi-prazos-6 WITH FRAME {&FRAME-NAME}.
            WHEN 7 THEN
                DISABLE fi-prazos-7 WITH FRAME {&FRAME-NAME}.
            WHEN 8 THEN
                DISABLE fi-prazos-8 WITH FRAME {&FRAME-NAME}.
            WHEN 9 THEN
                DISABLE fi-prazos-9 WITH FRAME {&FRAME-NAME}.
            WHEN 10 THEN
                DISABLE fi-prazos-10 WITH FRAME {&FRAME-NAME}.
            WHEN 11 THEN
                DISABLE fi-prazos-11 WITH FRAME {&FRAME-NAME}.
            WHEN 12 THEN
                DISABLE fi-prazos-12 WITH FRAME {&FRAME-NAME}.
        END CASE.

        DISABLE cond-pagto.per-pg-dup[i-cont]  WITH FRAME {&FRAME-NAME}.

        ASSIGN i-cont = i-cont + 1.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dia-semana V-table-Win 
PROCEDURE pi-dia-semana :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-nr-parcela AS INTEGER    NO-UNDO.
DEFINE INPUT  PARAMETER p-dt-parcela AS DATE       NO-UNDO.

DEFINE VARIABLE c-nome-dia  AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-lista-dia AS CHARACTER FORMAT "x(9)"
    INITIAL "Domingo,Segunda,Ter‡a,Quarta,Quinta,Sexta,S bado" NO-UNDO.

    ASSIGN c-nome-dia = IF WEEKDAY(p-dt-parcela) <> ? THEN ENTRY(WEEKDAY(p-dt-parcela),c-lista-dia)
                        ELSE "".

    CASE p-nr-parcela:
        WHEN 1 THEN
            ASSIGN fi-dia-semana-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-nome-dia.
        WHEN 2 THEN
            ASSIGN fi-dia-semana-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-nome-dia.
        WHEN 3 THEN
            ASSIGN fi-dia-semana-3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-nome-dia.
        WHEN 4 THEN
            ASSIGN fi-dia-semana-4:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-nome-dia.
        WHEN 5 THEN
            ASSIGN fi-dia-semana-5:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-nome-dia.
        WHEN 6 THEN
            ASSIGN fi-dia-semana-6:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-nome-dia.
        WHEN 7 THEN
            ASSIGN fi-dia-semana-7:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-nome-dia.
        WHEN 8 THEN
            ASSIGN fi-dia-semana-8:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-nome-dia.
        WHEN 9 THEN
            ASSIGN fi-dia-semana-9:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-nome-dia.
        WHEN 10 THEN
            ASSIGN fi-dia-semana-10:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-nome-dia.
        WHEN 11 THEN
            ASSIGN fi-dia-semana-11:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-nome-dia.
        WHEN 12 THEN
            ASSIGN fi-dia-semana-12:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-nome-dia.
    END CASE.

    RETURN "OK":U.
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
    ASSIGN fi-prazos-1 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           fi-prazos-2 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           fi-prazos-3 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           fi-prazos-4 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           fi-prazos-5 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           fi-prazos-6 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           fi-prazos-7 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           fi-prazos-8 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           fi-prazos-9 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           fi-prazos-10:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           fi-prazos-11:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           fi-prazos-12:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "

           cond-pagto.per-pg-dup[1] :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           cond-pagto.per-pg-dup[2] :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           cond-pagto.per-pg-dup[3] :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           cond-pagto.per-pg-dup[4] :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           cond-pagto.per-pg-dup[5] :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           cond-pagto.per-pg-dup[6] :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           cond-pagto.per-pg-dup[7] :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           cond-pagto.per-pg-dup[8] :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           cond-pagto.per-pg-dup[9] :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           cond-pagto.per-pg-dup[10]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           cond-pagto.per-pg-dup[11]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
           cond-pagto.per-pg-dup[12]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".           

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
DEF INPUT PARAMETER p-v02ad039 AS HANDLE NO-UNDO.
DEF INPUT PARAMETER p-cd0404   AS HANDLE NO-UNDO.

    ASSIGN h_v02ad039 = p-v02ad039
           h_cd0404   = p-cd0404.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
RUN pi-get-screen-value IN h_v02ad039 (OUTPUT l-data-fixa).

IF l-data-fixa THEN DO:    
    {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */

    ASSIGN de-per-pg = 0.

    DO i-cont = 1 TO 12.
        ASSIGN de-per-pg = de-per-pg + INPUT FRAME {&FRAME-NAME} cond-pagto.per-pg-dup[i-cont].
    END.

    /* Teste para numero de parcelas igual a campos habilitados */
    ASSIGN i-nr-par = 0.

    IF fi-prazos-1 :SENSITIVE = YES THEN i-nr-par = 1.
    IF fi-prazos-2 :SENSITIVE = YES THEN i-nr-par = i-nr-par + 1.
    IF fi-prazos-3 :SENSITIVE = YES THEN i-nr-par = i-nr-par + 1.
    IF fi-prazos-4 :SENSITIVE = YES THEN i-nr-par = i-nr-par + 1.
    IF fi-prazos-5 :SENSITIVE = YES THEN i-nr-par = i-nr-par + 1.
    IF fi-prazos-6 :SENSITIVE = YES THEN i-nr-par = i-nr-par + 1.
    IF fi-prazos-7 :SENSITIVE = YES THEN i-nr-par = i-nr-par + 1.
    IF fi-prazos-8 :SENSITIVE = YES THEN i-nr-par = i-nr-par + 1.
    IF fi-prazos-9 :SENSITIVE = YES THEN i-nr-par = i-nr-par + 1.
    IF fi-prazos-10:SENSITIVE = YES THEN i-nr-par = i-nr-par + 1.
    IF fi-prazos-11:SENSITIVE = YES THEN i-nr-par = i-nr-par + 1.
    IF fi-prazos-12:SENSITIVE = YES THEN i-nr-par = i-nr-par + 1.

    IF i-nr-par <> 0                                                 AND
       i-nr-par <> INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas THEN DO:
        RUN pi-muda-pagina IN h_cd0404.
        {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
         RUN utp/ut-msgs.p (INPUT "show":U,
                            INPUT 6095,
                            INPUT " ").
        RETURN 'ADM-ERROR':U.     
    END.

    /* Teste de percentual igual a 100 % */
    IF de-per-pg <> 100 THEN DO:
        {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 4068,
                           INPUT " ").
        APPLY 'entry' TO cond-pagto.per-pg-dup[1] IN FRAME {&FRAME-NAME}.
        RETURN 'ADM-ERROR':U.
    END.

    DO i-cont = 1 TO (INPUT FRAME {&FRAME-NAME} cond-pagto.num-parcelas).

        /* Teste p/ prazo menor que anterior */
        CASE i-cont:
            WHEN 2 THEN DO:
                IF INPUT FRAME {&FRAME-NAME} fi-prazos-2 = ?                                     OR
                   INPUT FRAME {&FRAME-NAME} fi-prazos-2 < INPUT FRAME {&FRAME-NAME} fi-prazos-1 THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-data-invalida AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Data_Inv lida" *}
                    ASSIGN c-lbl-liter-data-invalida = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-a-data-da-segunda AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "A_data_da_segunda_parcela_deve_ser_maior_que_a_data_primeira_parcela" *}
                    ASSIGN c-lbl-liter-a-data-da-segunda = TRIM(RETURN-VALUE).
                    RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                      INPUT 17006,
                                      INPUT c-lbl-liter-data-invalida + "." + "~~" +
                                            c-lbl-liter-a-data-da-segunda + ".").
                    RETURN 'ADM-ERROR':U.
                END.
            END.
            WHEN 3 THEN DO:
                IF INPUT FRAME {&FRAME-NAME} fi-prazos-3 = ?                                     OR
                   INPUT FRAME {&FRAME-NAME} fi-prazos-3 < INPUT FRAME {&FRAME-NAME} fi-prazos-2 THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-data-invalida-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Data_Inv lida" *}
                    ASSIGN c-lbl-liter-data-invalida-2 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-a-data-da-terceira AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "A_data_da_terceira_parcela_deve_ser_maior_que_a_data_segunda_parcela" *}
                    ASSIGN c-lbl-liter-a-data-da-terceira = TRIM(RETURN-VALUE).
                    RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                      INPUT 17006,
                                      INPUT c-lbl-liter-data-invalida-2 + "." + "~~" +
                                            c-lbl-liter-a-data-da-terceira + ".").
                    RETURN 'ADM-ERROR':U.
                END.
            END.
            WHEN 4 THEN DO:
                IF INPUT FRAME {&FRAME-NAME} fi-prazos-4 = ?                                     OR
                   INPUT FRAME {&FRAME-NAME} fi-prazos-4 < INPUT FRAME {&FRAME-NAME} fi-prazos-3 THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-data-invalida-3 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Data_Inv lida" *}
                    ASSIGN c-lbl-liter-data-invalida-3 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-a-data-da-quarta-p AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "A_data_da_quarta_parcela_deve_ser_maior_que_a_data_terceira_parcela" *}
                    ASSIGN c-lbl-liter-a-data-da-quarta-p = TRIM(RETURN-VALUE).
                    RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                      INPUT 17006,
                                      INPUT c-lbl-liter-data-invalida-3 + "." + "~~" +
                                            c-lbl-liter-a-data-da-quarta-p + ".").
                    RETURN 'ADM-ERROR':U.
                END.
            END.
            WHEN 5 THEN DO:
                IF INPUT FRAME {&FRAME-NAME} fi-prazos-5 = ?                                     OR
                   INPUT FRAME {&FRAME-NAME} fi-prazos-5 < INPUT FRAME {&FRAME-NAME} fi-prazos-4 THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-data-invalida-4 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Data_Inv lida" *}
                    ASSIGN c-lbl-liter-data-invalida-4 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-a-data-da-quinta-p AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "A_data_da_quinta_parcela_deve_ser_maior_que_a_data_quarta_parcela" *}
                    ASSIGN c-lbl-liter-a-data-da-quinta-p = TRIM(RETURN-VALUE).
                    RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                      INPUT 17006,
                                      INPUT c-lbl-liter-data-invalida-4 + "." + "~~" +
                                            c-lbl-liter-a-data-da-quinta-p + ".").
                    RETURN 'ADM-ERROR':U.
                END.
            END.
            WHEN 6 THEN DO:
                IF INPUT FRAME {&FRAME-NAME} fi-prazos-6 = ?                                     OR
                   INPUT FRAME {&FRAME-NAME} fi-prazos-6 < INPUT FRAME {&FRAME-NAME} fi-prazos-5 THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-data-invalida-5 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Data_Inv lida" *}
                    ASSIGN c-lbl-liter-data-invalida-5 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-a-data-da-sexta-pa AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "A_data_da_sexta_parcela_deve_ser_maior_que_a_data_quinta_parcela" *}
                    ASSIGN c-lbl-liter-a-data-da-sexta-pa = TRIM(RETURN-VALUE).
                    RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                      INPUT 17006,
                                      INPUT c-lbl-liter-data-invalida-5 + "." + "~~" +
                                            c-lbl-liter-a-data-da-sexta-pa + ".").
                    RETURN 'ADM-ERROR':U.
                END.
            END.
            WHEN 7 THEN DO:
                IF INPUT FRAME {&FRAME-NAME} fi-prazos-7 = ?                                     OR
                   INPUT FRAME {&FRAME-NAME} fi-prazos-7 < INPUT FRAME {&FRAME-NAME} fi-prazos-6 THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-data-invalida-6 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Data_Inv lida" *}
                    ASSIGN c-lbl-liter-data-invalida-6 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-a-data-da-setima-p AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "A_data_da_s‚tima_parcela_deve_ser_maior_que_a_data_sexta_parcela" *}
                    ASSIGN c-lbl-liter-a-data-da-setima-p = TRIM(RETURN-VALUE).
                    RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                      INPUT 17006,
                                      INPUT c-lbl-liter-data-invalida-6 + "." + "~~" +
                                            c-lbl-liter-a-data-da-setima-p + ".").
                    RETURN 'ADM-ERROR':U.
                END.
            END.
            WHEN 8 THEN DO:
                IF INPUT FRAME {&FRAME-NAME} fi-prazos-8 = ?                                     OR
                   INPUT FRAME {&FRAME-NAME} fi-prazos-8 < INPUT FRAME {&FRAME-NAME} fi-prazos-7 THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-data-invalida-7 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Data_Inv lida" *}
                    ASSIGN c-lbl-liter-data-invalida-7 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-a-data-da-oitava-p AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "A_data_da_oitava_parcela_deve_ser_maior_que_a_data_s‚tima_parcela" *}
                    ASSIGN c-lbl-liter-a-data-da-oitava-p = TRIM(RETURN-VALUE).
                    RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                      INPUT 17006,
                                      INPUT c-lbl-liter-data-invalida-7 + "." + "~~" +
                                            c-lbl-liter-a-data-da-oitava-p + ".").
                    RETURN 'ADM-ERROR':U.
                END.
            END.
            WHEN 9 THEN DO:
                IF INPUT FRAME {&FRAME-NAME} fi-prazos-9 = ?                                     OR
                   INPUT FRAME {&FRAME-NAME} fi-prazos-9 < INPUT FRAME {&FRAME-NAME} fi-prazos-8 THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-data-invalida-8 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Data_Inv lida" *}
                    ASSIGN c-lbl-liter-data-invalida-8 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-a-data-da-nona-par AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "A_data_da_nona_parcela_deve_ser_maior_que_a_data_oitava_parcela" *}
                    ASSIGN c-lbl-liter-a-data-da-nona-par = TRIM(RETURN-VALUE).
                    RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                      INPUT 17006,
                                      INPUT c-lbl-liter-data-invalida-8 + "." + "~~" +
                                            c-lbl-liter-a-data-da-nona-par + ".").
                    RETURN 'ADM-ERROR':U.
                END.
            END.
            WHEN 10 THEN DO:
                IF INPUT FRAME {&FRAME-NAME} fi-prazos-10 = ?                                     OR
                   INPUT FRAME {&FRAME-NAME} fi-prazos-10 < INPUT FRAME {&FRAME-NAME} fi-prazos-9 THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-data-invalida-9 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Data_Inv lida" *}
                    ASSIGN c-lbl-liter-data-invalida-9 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-a-data-da-decima-p AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "A_data_da_d‚cima_parcela_deve_ser_maior_que_a_data_nona_parcela" *}
                    ASSIGN c-lbl-liter-a-data-da-decima-p = TRIM(RETURN-VALUE).
                    RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                      INPUT 17006,
                                      INPUT c-lbl-liter-data-invalida-9 + "." + "~~" +
                                            c-lbl-liter-a-data-da-decima-p + ".").
                    RETURN 'ADM-ERROR':U.
                END.
            END.
            WHEN 11 THEN DO:
                IF INPUT FRAME {&FRAME-NAME} fi-prazos-11 = ?                                      OR
                   INPUT FRAME {&FRAME-NAME} fi-prazos-11 < INPUT FRAME {&FRAME-NAME} fi-prazos-10 THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-data-invalida-10 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Data_Inv lida" *}
                    ASSIGN c-lbl-liter-data-invalida-10 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-a-data-da-decima-p-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "A_data_da_d‚cima_primeira_parcela_deve_ser_maior_que_a_data_d‚cima_parcela" *}
                    ASSIGN c-lbl-liter-a-data-da-decima-p-2 = TRIM(RETURN-VALUE).
                    RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                      INPUT 17006,
                                      INPUT c-lbl-liter-data-invalida-10 + "." + "~~" +
                                            c-lbl-liter-a-data-da-decima-p-2 + ".").
                    RETURN 'ADM-ERROR':U.
                END.
            END.
            WHEN 12 THEN DO:
                IF INPUT FRAME {&FRAME-NAME} fi-prazos-12 = ?                                      OR
                   INPUT FRAME {&FRAME-NAME} fi-prazos-12 < INPUT FRAME {&FRAME-NAME} fi-prazos-11 THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-data-invalida-11 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Data_Inv lida" *}
                    ASSIGN c-lbl-liter-data-invalida-11 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-a-data-da-decima-s AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "A_data_da_d‚cima_segunda_parcela_deve_ser_maior_que_a_data_d‚cima_primeira_parcela" *}
                    ASSIGN c-lbl-liter-a-data-da-decima-s = TRIM(RETURN-VALUE).
                    RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                      INPUT 17006,
                                      INPUT c-lbl-liter-data-invalida-11 + "." + "~~" +
                                            c-lbl-liter-a-data-da-decima-s + ".").
                    RETURN 'ADM-ERROR':U.
                END.
            END.
        END CASE.
    END.

    /**************valida‡Æo do campo num-parcela*********************************/

    RUN pi-desabilitaCampos.

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

    RUN pi-trata-state (p-issuer-hdl, p-state).

    /* Tratamentos p/ copia */
    IF p-state = "update-begin" THEN DO:
        DISABLE {&List-4} WITH FRAME {&FRAME-NAME}.

        DO i-cont = 1 TO INPUT FRAME {&FRAME-NAME} mgadm.cond-pagto.num-parcelas:

            ENABLE cond-pagto.per-pg-dup[i-cont] WITH FRAME {&FRAME-NAME} .

            CASE i-cont:
                WHEN 1 THEN
                    ENABLE fi-prazos-1 WITH FRAME {&FRAME-NAME}.
                WHEN 2 THEN
                    ENABLE fi-prazos-2 WITH FRAME {&FRAME-NAME}.
                WHEN 3 THEN
                    ENABLE fi-prazos-3 WITH FRAME {&FRAME-NAME}.
                WHEN 4 THEN
                    ENABLE fi-prazos-4 WITH FRAME {&FRAME-NAME}.
                WHEN 5 THEN
                    ENABLE fi-prazos-5 WITH FRAME {&FRAME-NAME}.
                WHEN 6 THEN
                    ENABLE fi-prazos-6 WITH FRAME {&FRAME-NAME}.
                WHEN 7 THEN
                    ENABLE fi-prazos-7 WITH FRAME {&FRAME-NAME}.
                WHEN 8 THEN
                    ENABLE fi-prazos-8 WITH FRAME {&FRAME-NAME}.
                WHEN 9 THEN
                    ENABLE fi-prazos-9 WITH FRAME {&FRAME-NAME}.
                WHEN 10 THEN
                    ENABLE fi-prazos-10 WITH FRAME {&FRAME-NAME}.
                WHEN 11 THEN
                    ENABLE fi-prazos-11 WITH FRAME {&FRAME-NAME}.
                WHEN 12 THEN
                    ENABLE fi-prazos-12 WITH FRAME {&FRAME-NAME}.
            END CASE.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

