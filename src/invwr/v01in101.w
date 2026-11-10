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
{include/i-prgvrs.i V01IN101 2.00.00.014}  /*** "010014" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in101 MUT}
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

{include/i-vrtab.i familia}
/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var i-mes-aux      as integer   format   99  extent  12.
def var i-ano-aux      as integer   format 9999  extent   4.
def var i-mo           as integer   format   "9" initial "1".
def var i-moeda        as integer   format   "9".


def var de-total-ent   as decimal   format "->>>>,>>>,>>9.99" extent 4.
def var de-ent-qt      as decimal   format "->>>>,>>>,>>9.99" extent 4.
def var de-total-saida as decimal   format "->>>>,>>>,>>9.99" extent 4.
def var de-saida-qt    as decimal   format "->>>>,>>>,>>9.99" extent 4.
def var de-est-med     as decimal   format "->>>>,>>>,>>9.99" extent 4.
def var de-est-exc     as decimal   format "->>>>,>>>,>>9.99" extent 4.
def var de-est-seg     as decimal   format "->>>>,>>>,>>9.99" extent 4.
def var de-est-ini     as decimal   format "->>>>,>>>,>>9.99" extent 4.
def var de-est-fim     as decimal   format "->>>>,>>>,>>9.99" extent 4.
def var de-est-med-qt  as decimal   format "->>>>,>>>,>>9.99" extent 4.
def var de-giro        as decimal   format "->>>>>9.99"       extent 4.
def var i-mes-fec      as integer   format 99.
def var i-ano-fec      as integer   format 9999    initial 0.
def var i-ano-medio    as integer   format 9999.
def var i-ano          as integer   format 9999    extent 12.
def var i-mes          as integer   format   99    extent  4.
def var c-ext          as character format "x(9)"  extent 12.
def var c-barra        as character format "x(1)"  extent  4 initial "/".
def var tabela         as character extent 12      initial ["  Janeiro","Fevereiro","    Mar‡o","    Abril",
                                                            "     Maio","    Junho","    Julho","   Agosto",
                                                            " Setembro","  Outubro"," Novembro"," Dezembro"].
                                                   
def var i-cont         as integer   format 99      initial 0.
def var c-per-ini      as character format 9999/99.
def var c-per-fin      as character format 9999/99.
def var i-tipo-custo   as integer   format   "9" initial "1".

{cdp/cdcfgmat.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES familia
&Scoped-define FIRST-EXTERNAL-TABLE familia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR familia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS familia.fm-codigo familia.descricao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}fm-codigo ~{&FP2}fm-codigo ~{&FP3}~
 ~{&FP1}descricao ~{&FP2}descricao ~{&FP3}
&Scoped-define ENABLED-TABLES familia
&Scoped-define FIRST-ENABLED-TABLE familia
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS familia.fm-codigo familia.descricao 
&Scoped-Define DISPLAYED-OBJECTS c-moeda c-periodo-1 c-periodo-2 ~
c-periodo-3 c-periodo-4 de-total-ent-1 de-total-ent-2 de-total-ent-3 ~
de-total-ent-4 de-ent-qt-1 de-ent-qt-2 de-ent-qt-3 de-ent-qt-4 ~
de-total-saida-1 de-total-saida-2 de-total-saida-3 de-total-saida-4 ~
de-saida-qt-1 de-saida-qt-2 de-saida-qt-3 de-saida-qt-4 de-est-ini-1 ~
de-est-ini-2 de-est-ini-3 de-est-ini-4 de-est-med-1 de-est-med-2 ~
de-est-med-3 de-est-med-4 de-est-seg-1 de-est-seg-2 de-est-seg-3 ~
de-est-seg-4 de-est-exc-1 de-est-exc-2 de-est-exc-3 de-est-exc-4 ~
de-est-fim-1 de-est-fim-2 de-est-fim-3 de-est-fim-4 de-giro-1 de-giro-2 ~
de-giro-3 de-giro-4 c-periodos c-entradas c-qtde-1 c-saidas c-qtde-2 ~
c-inicial c-medio c-segur c-exceden c-final c-giro 

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
DEFINE VARIABLE c-entradas AS CHARACTER FORMAT "X(12)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-exceden AS CHARACTER FORMAT "X(12)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-final AS CHARACTER FORMAT "X(12)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-giro AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-inicial AS CHARACTER FORMAT "X(12)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-medio AS CHARACTER FORMAT "X(12)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(10)":U 
     LABEL "Moeda" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-periodo-1 AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-periodo-2 AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-periodo-3 AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-periodo-4 AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-periodos AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-qtde-1 AS CHARACTER FORMAT "X(12)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-qtde-2 AS CHARACTER FORMAT "X(12)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-saidas AS CHARACTER FORMAT "X(12)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-segur AS CHARACTER FORMAT "X(12)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE de-ent-qt-1 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-ent-qt-2 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-ent-qt-3 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-ent-qt-4 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-exc-1 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-exc-2 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-exc-3 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-exc-4 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-fim-1 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-fim-2 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-fim-3 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-fim-4 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-ini-1 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-ini-2 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-ini-3 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-ini-4 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-med-1 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-med-2 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-med-3 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-med-4 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-seg-1 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-seg-2 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-seg-3 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-seg-4 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-giro-1 AS DECIMAL FORMAT "ZZZZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-giro-2 AS DECIMAL FORMAT "ZZZZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-giro-3 AS DECIMAL FORMAT "ZZZZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-giro-4 AS DECIMAL FORMAT "ZZZZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-saida-qt-1 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-saida-qt-2 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-saida-qt-3 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-saida-qt-4 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-total-ent-1 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-total-ent-2 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-total-ent-3 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-total-ent-4 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-total-saida-1 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-total-saida-2 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-total-saida-3 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-total-saida-4 AS DECIMAL FORMAT "Z,ZZZ,ZZZ,ZZ9.99-":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 13.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     familia.fm-codigo AT ROW 1.17 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     familia.descricao AT ROW 1.17 COL 26 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     c-moeda AT ROW 1.17 COL 70 COLON-ALIGNED
     c-periodo-1 AT ROW 2.83 COL 14.72 COLON-ALIGNED NO-LABEL
     c-periodo-2 AT ROW 2.83 COL 34.14 COLON-ALIGNED NO-LABEL
     c-periodo-3 AT ROW 2.83 COL 52.72 COLON-ALIGNED NO-LABEL
     c-periodo-4 AT ROW 2.83 COL 71.57 COLON-ALIGNED NO-LABEL
     de-total-ent-1 AT ROW 4.5 COL 10.72 COLON-ALIGNED NO-LABEL
     de-total-ent-2 AT ROW 4.5 COL 29.86 COLON-ALIGNED NO-LABEL
     de-total-ent-3 AT ROW 4.5 COL 49 COLON-ALIGNED NO-LABEL
     de-total-ent-4 AT ROW 4.5 COL 68.14 COLON-ALIGNED NO-LABEL
     de-ent-qt-1 AT ROW 5.5 COL 10.72 COLON-ALIGNED NO-LABEL
     de-ent-qt-2 AT ROW 5.5 COL 29.86 COLON-ALIGNED NO-LABEL
     de-ent-qt-3 AT ROW 5.5 COL 49 COLON-ALIGNED NO-LABEL
     de-ent-qt-4 AT ROW 5.5 COL 68.14 COLON-ALIGNED NO-LABEL
     de-total-saida-1 AT ROW 6.5 COL 10.72 COLON-ALIGNED NO-LABEL
     de-total-saida-2 AT ROW 6.5 COL 29.86 COLON-ALIGNED NO-LABEL
     de-total-saida-3 AT ROW 6.5 COL 49 COLON-ALIGNED NO-LABEL
     de-total-saida-4 AT ROW 6.5 COL 68.14 COLON-ALIGNED NO-LABEL
     de-saida-qt-1 AT ROW 7.5 COL 10.72 COLON-ALIGNED NO-LABEL
     de-saida-qt-2 AT ROW 7.5 COL 29.86 COLON-ALIGNED NO-LABEL
     de-saida-qt-3 AT ROW 7.5 COL 49 COLON-ALIGNED NO-LABEL
     de-saida-qt-4 AT ROW 7.5 COL 68.14 COLON-ALIGNED NO-LABEL
     de-est-ini-1 AT ROW 8.5 COL 10.72 COLON-ALIGNED NO-LABEL
     de-est-ini-2 AT ROW 8.5 COL 29.86 COLON-ALIGNED NO-LABEL
     de-est-ini-3 AT ROW 8.5 COL 49 COLON-ALIGNED NO-LABEL
     de-est-ini-4 AT ROW 8.5 COL 68.14 COLON-ALIGNED NO-LABEL
     de-est-med-1 AT ROW 9.5 COL 10.72 COLON-ALIGNED NO-LABEL
     de-est-med-2 AT ROW 9.5 COL 29.86 COLON-ALIGNED NO-LABEL
     de-est-med-3 AT ROW 9.5 COL 49 COLON-ALIGNED NO-LABEL
     de-est-med-4 AT ROW 9.5 COL 68.14 COLON-ALIGNED NO-LABEL
     de-est-seg-1 AT ROW 10.5 COL 10.72 COLON-ALIGNED NO-LABEL
     de-est-seg-2 AT ROW 10.5 COL 29.86 COLON-ALIGNED NO-LABEL
     de-est-seg-3 AT ROW 10.5 COL 49 COLON-ALIGNED NO-LABEL
     de-est-seg-4 AT ROW 10.5 COL 68.14 COLON-ALIGNED NO-LABEL
     de-est-exc-1 AT ROW 11.5 COL 10.72 COLON-ALIGNED NO-LABEL
     de-est-exc-2 AT ROW 11.5 COL 29.86 COLON-ALIGNED NO-LABEL
     de-est-exc-3 AT ROW 11.5 COL 49 COLON-ALIGNED NO-LABEL
     de-est-exc-4 AT ROW 11.5 COL 68.14 COLON-ALIGNED NO-LABEL
     de-est-fim-1 AT ROW 12.5 COL 10.72 COLON-ALIGNED NO-LABEL
     de-est-fim-2 AT ROW 12.5 COL 29.86 COLON-ALIGNED NO-LABEL
     de-est-fim-3 AT ROW 12.5 COL 49 COLON-ALIGNED NO-LABEL
     de-est-fim-4 AT ROW 12.5 COL 68.14 COLON-ALIGNED NO-LABEL
     de-giro-1 AT ROW 14.5 COL 16.57 COLON-ALIGNED NO-LABEL
     de-giro-2 AT ROW 14.5 COL 35.86 COLON-ALIGNED NO-LABEL
     de-giro-3 AT ROW 14.5 COL 55 COLON-ALIGNED NO-LABEL
     de-giro-4 AT ROW 14.5 COL 74 COLON-ALIGNED NO-LABEL
     c-periodos AT ROW 2.75 COL 1.57 NO-LABEL
     c-entradas AT ROW 4.5 COL 1.57 NO-LABEL
     c-qtde-1 AT ROW 5.5 COL 1.57 NO-LABEL
     c-saidas AT ROW 6.5 COL 1.57 NO-LABEL
     c-qtde-2 AT ROW 7.5 COL 1.57 NO-LABEL
     c-inicial AT ROW 8.5 COL 1.57 NO-LABEL
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     c-medio AT ROW 9.5 COL 1.57 NO-LABEL
     c-segur AT ROW 10.5 COL 1.57 NO-LABEL
     c-exceden AT ROW 11.5 COL 1.57 NO-LABEL
     c-final AT ROW 12.5 COL 1.57 NO-LABEL
     c-giro AT ROW 14.5 COL 1.72 NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.familia
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
         HEIGHT             = 14.88
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

/* SETTINGS FOR FILL-IN c-entradas IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-exceden IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-final IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-giro IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-inicial IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-medio IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-periodo-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-periodo-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-periodo-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-periodo-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-periodos IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-qtde-1 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-qtde-2 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-saidas IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-segur IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN de-ent-qt-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-ent-qt-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-ent-qt-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-ent-qt-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-exc-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-exc-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-exc-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-exc-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-fim-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-fim-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-fim-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-fim-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-ini-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-ini-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-ini-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-ini-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-med-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-med-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-med-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-med-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-seg-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-seg-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-seg-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-seg-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-giro-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-giro-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-giro-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-giro-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-saida-qt-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-saida-qt-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-saida-qt-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-saida-qt-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-total-ent-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-total-ent-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-total-ent-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-total-ent-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-total-saida-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-total-saida-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-total-saida-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-total-saida-4 IN FRAME f-main
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

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
  {src/adm/template/row-list.i "familia"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "familia"}

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
  
  assign de-total-ent   = 0
         de-ent-qt      = 0
         de-total-saida = 0
         de-saida-qt    = 0
         de-est-med     = 0
         de-est-exc     = 0
         de-est-seg     = 0
         de-est-ini     = 0
         de-est-fim     = 0
         de-giro        = 0.
      
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  assign i-moeda = (i-mo - 1).

  
  find moeda where
       moeda.mo-codigo = i-moeda no-lock no-error.
  if avail moeda then do:
      assign c-moeda:screen-value in frame {&frame-name} = moeda.descricao.
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

  {utp/ut-liter.i Moeda}
  assign c-moeda:label in frame {&FRAME-NAME} = trim(return-value).

  
  {utp/ut-liter.i Per¡odos * C}
  assign c-periodos = return-value.
  {utp/ut-liter.i Entradas * C}
  assign c-entradas = return-value.
  {utp/ut-liter.i Quantidade * C}
  assign c-qtde-1 = return-value.
  {utp/ut-liter.i Sa¡das * C}
  assign c-saidas = return-value.
  {utp/ut-liter.i Quantidade * C}
  assign c-qtde-2 = return-value.
  {utp/ut-liter.i Inicial * C}
  assign c-inicial = return-value.
  {utp/ut-liter.i M‚dio * C}
  assign c-medio = return-value.
  {utp/ut-liter.i Seguran‡a * C}
  assign c-segur = return-value.
  {utp/ut-liter.i Excedente * C}
  assign c-exceden = return-value.
  {utp/ut-liter.i Final * C}
  assign c-final = return-value.
  {utp/ut-liter.i Giro * C}
  assign c-giro = return-value.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  find first param-estoq  no-lock no-error.
  
  &if defined(bf_mat_fech_estab) &then
   if param-estoq.tp-fech = 2 then
      assign c-per-fin = string(year(today),"9999") + string(month(today),"99").
   else
      assign c-per-fin = param-estoq.ult-per-fech.
  &else
    assign c-per-fin = param-estoq.ult-per-fech.
  &endif

  assign c-per-ini = string(i-ano-aux[4],"9999") + string(i-mes-aux[4],"99").
         
  /* Code placed here will execute AFTER standard behavior.    */

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
   
  if available familia then
    assign gr-familia = rowid(familia).
    
    assign c-periodo-1      = ""
         c-periodo-2      = ""
         c-periodo-3      = ""
         c-periodo-4      = ""
         de-total-ent-1   = 0
         de-total-ent-2   = 0
         de-total-ent-3   = 0
         de-total-ent-4   = 0
         de-ent-qt-1      = 0
         de-ent-qt-2      = 0
         de-ent-qt-3      = 0
         de-ent-qt-4      = 0
         de-total-saida-1 = 0
         de-total-saida-2 = 0
         de-total-saida-3 = 0
         de-total-saida-4 = 0
         de-saida-qt-1    = 0
         de-saida-qt-2    = 0
         de-saida-qt-3    = 0
         de-saida-qt-4    = 0
         de-est-ini-1     = 0
         de-est-ini-2     = 0
         de-est-ini-3     = 0
         de-est-ini-4     = 0
         de-est-med-1     = 0
         de-est-med-2     = 0
         de-est-med-3     = 0
         de-est-med-4     = 0
         de-est-seg-1     = 0
         de-est-seg-2     = 0
         de-est-seg-3     = 0
         de-est-seg-4     = 0
         de-est-exc-1     = 0
         de-est-exc-2     = 0
         de-est-exc-3     = 0
         de-est-exc-4     = 0
         de-est-fim-1     = 0
         de-est-fim-2     = 0
         de-est-fim-3     = 0
         de-est-fim-4     = 0
         de-giro-1        = 0
         de-giro-2        = 0
         de-giro-3        = 0
         de-giro-4        = 0.
         
        DO i-cont = 1 TO 4:
             assign de-total-ent[i-cont]   = 0
                    de-ent-qt[i-cont]      = 0
                    de-total-saida[i-cont] = 0
                    de-saida-qt[i-cont]    = 0
                    de-est-ini[i-cont]     = 0
                    de-est-med[i-cont]     = 0
                    de-est-seg[i-cont]     = 0
                    de-est-exc[i-cont]     = 0
                    de-est-fim[i-cont]     = 0
                    de-giro[i-cont]        = 0
                    de-est-med-qt[i-cont]  = 0.
        END.
         
        display c-periodo-1
                c-periodo-2
                c-periodo-3
                c-periodo-4
                de-total-ent-1 
                de-total-ent-2 
                de-total-ent-3 
                de-total-ent-4
                de-ent-qt-1 
                de-ent-qt-2 
                de-ent-qt-3 
                de-ent-qt-4
                de-total-saida-1 
                de-total-saida-2 
                de-total-saida-3 
                de-total-saida-4
                de-saida-qt-1 
                de-saida-qt-2 
                de-saida-qt-3 
                de-saida-qt-4
                de-est-ini-1 
                de-est-ini-2 
                de-est-ini-3 
                de-est-ini-4
                de-est-med-1 
                de-est-med-2 
                de-est-med-3 
                de-est-med-4
                de-est-seg-1 
                de-est-seg-2 
                de-est-seg-3 
                de-est-seg-4
                de-est-exc-1 
                de-est-exc-2 
                de-est-exc-3 
                de-est-exc-4
                de-est-fim-1 
                de-est-fim-2 
                de-est-fim-3 
                de-est-fim-4
                de-giro-1 
                de-giro-2 
                de-giro-3 
                de-giro-4 with frame {&frame-name}.

         run pi-calcula-periodo.
    
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-periodo V-table-Win 
PROCEDURE pi-calcula-periodo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    i-cont = 1.
    assign i-moeda = (i-mo - 1).
    
    find moeda where
        moeda.mo-codigo = i-moeda 
        no-lock no-error.
    if avail moeda then do:
        assign c-moeda:screen-value in frame {&frame-name} = moeda.descricao.
    end.

    for each estat-estab no-lock
       where estat-estab.fm-codigo = familia.fm-codigo 
       and   c-per-ini <= estat-estab.periodo 
       and   c-per-fin >= estat-estab.periodo 
        break by estat-estab.periodo descending:
                
        if i-cont = 5 then leave.

        assign i-ano[i-cont] = integer(substring(estat-estab.periodo,1,4))
               i-mes[i-cont] = integer(substring(estat-estab.periodo,5,2)).
           
        if i-mes[i-cont] > 12 then
            assign i-mes[i-cont] = i-mes[i-cont] - 12
                   i-ano[i-cont] = i-ano-medio .
               
        if i-tipo-custo = 1 then do:
            {cep/ce0824.i -m}
        end.
        if i-tipo-custo = 2 then do:
            {cep/ce0824.i -o}
        end.
        if i-tipo-custo = 3 then do:
            {cep/ce0824.i -p}
        end.  
    
        if last-of(estat-estab.periodo) then do:
            
            if de-est-med-qt[i-cont] <> 0 then
                assign de-giro[i-cont] = (de-saida-qt[i-cont] / de-est-med-qt[i-cont]) * 100. 

            if i-cont = 1 then do:
                assign c-periodo-1      = c-ext[1] + c-barra[1] + string(i-ano[1])
                       de-total-ent-1   = de-total-ent[i-cont]
                       de-ent-qt-1      = de-ent-qt[i-cont]
                       de-total-saida-1 = de-total-saida[i-cont]
                       de-saida-qt-1    = de-saida-qt[i-cont]
                       de-est-ini-1     = de-est-ini[i-cont]
                       de-est-med-1     = de-est-med[i-cont]
                       de-est-seg-1     = de-est-seg[i-cont]
                       de-est-exc-1     = de-est-exc[i-cont]
                       de-est-fim-1     = de-est-fim[i-cont]
                       de-giro-1        = de-giro[i-cont].
            end.
            if i-cont = 2 then do:
                assign c-periodo-2      = c-ext[2] + c-barra[2] + string(i-ano[2])
                       de-total-ent-2   = de-total-ent[i-cont]
                       de-ent-qt-2      = de-ent-qt[i-cont]
                       de-total-saida-2 = de-total-saida[i-cont]
                       de-saida-qt-2    = de-saida-qt[i-cont]
                       de-est-ini-2     = de-est-ini[i-cont]
                       de-est-med-2     = de-est-med[i-cont]
                       de-est-seg-2     = de-est-seg[i-cont]
                       de-est-exc-2     = de-est-exc[i-cont]
                       de-est-fim-2     = de-est-fim[i-cont]
                       de-giro-2        = de-giro[i-cont].
            end.
            if i-cont = 3 then do:
                assign c-periodo-3      = c-ext[3] + c-barra[3] + string(i-ano[3])
                       de-total-ent-3   = de-total-ent[i-cont]
                       de-ent-qt-3      = de-ent-qt[i-cont]
                       de-total-saida-3 = de-total-saida[i-cont]
                       de-saida-qt-3    = de-saida-qt[i-cont]
                       de-est-ini-3     = de-est-ini[i-cont]
                       de-est-med-3     = de-est-med[i-cont]
                       de-est-seg-3     = de-est-seg[i-cont]
                       de-est-exc-3     = de-est-exc[i-cont]
                       de-est-fim-3     = de-est-fim[i-cont]
                       de-giro-3        = de-giro[i-cont].
            end.
            if i-cont = 4 then do:
                assign c-periodo-4      = c-ext[4] + c-barra[4] + string(i-ano[4])
                       de-total-ent-4   = de-total-ent[i-cont]
                       de-ent-qt-4      = de-ent-qt[i-cont]
                       de-total-saida-4 = de-total-saida[i-cont]
                       de-saida-qt-4    = de-saida-qt[i-cont]
                       de-est-ini-4     = de-est-ini[i-cont]
                       de-est-med-4     = de-est-med[i-cont]
                       de-est-seg-4     = de-est-seg[i-cont]
                       de-est-exc-4     = de-est-exc[i-cont]
                       de-est-fim-4     = de-est-fim[i-cont]
                       de-giro-4        = de-giro[i-cont].
            end.
        
            display c-periodo-1
                    c-periodo-2
                    c-periodo-3
                    c-periodo-4
                    de-total-ent-1 
                    de-total-ent-2 
                    de-total-ent-3 
                    de-total-ent-4
                    de-ent-qt-1 
                    de-ent-qt-2 
                    de-ent-qt-3 
                    de-ent-qt-4
                    de-total-saida-1 
                    de-total-saida-2 
                    de-total-saida-3 
                    de-total-saida-4
                    de-saida-qt-1 
                    de-saida-qt-2 
                    de-saida-qt-3 
                    de-saida-qt-4
                    de-est-ini-1 
                    de-est-ini-2 
                    de-est-ini-3 
                    de-est-ini-4
                    de-est-med-1 
                    de-est-med-2 
                    de-est-med-3 
                    de-est-med-4
                    de-est-seg-1 
                    de-est-seg-2 
                    de-est-seg-3 
                    de-est-seg-4
                    de-est-exc-1 
                    de-est-exc-2 
                    de-est-exc-3 
                    de-est-exc-4
                    de-est-fim-1 
                    de-est-fim-2 
                    de-est-fim-3 
                    de-est-fim-4
                    de-giro-1 
                    de-giro-2 
                    de-giro-3 
                    de-giro-4 with frame {&frame-name}.
                                     
            i-cont = i-cont + 1.
            
        end.
        
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-param V-table-Win 
PROCEDURE pi-seta-param :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define input parameter p-mo as integer.
define input parameter p-per-ini as character.
define input parameter p-per-fin as character.
define input parameter p-tipo-custo as integer.

assign i-mo         = p-mo
       c-per-ini    = p-per-ini
       c-per-fin    = p-per-fin
       i-tipo-custo = p-tipo-custo.

RUN dispatch IN THIS-PROCEDURE ('row-available':U).

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "familia"}

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


