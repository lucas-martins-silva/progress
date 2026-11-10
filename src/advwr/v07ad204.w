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
{include/i-prgvrs.i V07AD204 2.00.01.000}  /*** 010100 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v07ad204 MUT}
&ENDIF

{include/i_fnctrad.i}
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

def var c-dias-selecionados     as char     no-undo.
def var i-frequencia            as inte     no-undo.
def var i-tp-grafico            as inte     no-undo.
def var c-mes                   as char     no-undo. 
def var c-dia                   as char     no-undo.
def var c-ano                   as char     no-undo.
def var c-no-dia                as char     no-undo.
def var i-fator-div             as int      no-undo.
def var h_v14ad204              as handle   no-undo.

assign c-dia    = {adinc/i03ad204.i 04 1}
       c-mes    = {adinc/i03ad204.i 04 2}
       c-ano    = {adinc/i03ad204.i 04 3}
       c-no-dia = {adinc/i03ad204.i 04 4}.

{gep/ge-grpar.i}

{gep/ge9500.i}

{include/i_dbtype.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cb-grafico cb-estilo-grafico dt-periodo-ini ~
dt-periodo-fim cb-frequencia tg-frequencia tg-acumula bt-grafico IMAGE-29 ~
IMAGE-30 RECT-63 rt-mold 
&Scoped-Define DISPLAYED-OBJECTS cb-grafico cb-estilo-grafico ~
dt-periodo-ini dt-periodo-fim cb-frequencia tg-frequencia tg-acumula 

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
DEFINE BUTTON bt-grafico 
     LABEL "Gr†fico" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-salva 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "Salva ParÉmetros?" 
     SIZE 4 BY 1.13.

DEFINE VARIABLE cb-estilo-grafico AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estilo Grafico" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE cb-frequencia AS CHARACTER FORMAT "X(256)":U 
     LABEL "FreqÅància" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE cb-grafico AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo de Gr†fico" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 63 BY 1 NO-UNDO.

DEFINE VARIABLE dt-periodo-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE dt-periodo-ini AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF
     LABEL "Per°odo Inicial" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-29
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-63
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 52 BY 7.75.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 9.5.

DEFINE VARIABLE tg-acumula AS LOGICAL INITIAL no 
     LABEL "Acumula Per°odos?" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .75 NO-UNDO.

DEFINE VARIABLE tg-frequencia AS LOGICAL INITIAL no 
     LABEL "Informa FreqÅància Per°odos?" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .75 NO-UNDO.

DEFINE BUTTON bt-a-1 
     LABEL "1" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-10 
     LABEL "10" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-11 
     LABEL "11" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-12 
     LABEL "12" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-13 
     LABEL "13" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-14 
     LABEL "14" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-15 
     LABEL "15" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-16 
     LABEL "16" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-17 
     LABEL "17" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-18 
     LABEL "18" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-19 
     LABEL "19" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-2 
     LABEL "2" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-20 
     LABEL "20" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-3 
     LABEL "3" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-4 
     LABEL "4" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-5 
     LABEL "5" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-6 
     LABEL "6" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-7 
     LABEL "7" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-8 
     LABEL "8" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-9 
     LABEL "9" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-a-desmarca 
     LABEL "Desmarca" 
     SIZE 28.72 BY 1.

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28.72 BY 5.5.

DEFINE BUTTON bt-1 
     LABEL "1" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-10 
     LABEL "10" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-11 
     LABEL "11" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-12 
     LABEL "12" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-13 
     LABEL "13" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-14 
     LABEL "14" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-15 
     LABEL "15" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-16 
     LABEL "16" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-17 
     LABEL "17" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-18 
     LABEL "18" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-19 
     LABEL "19" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-2 
     LABEL "2" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-20 
     LABEL "20" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-21 
     LABEL "21" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-22 
     LABEL "22" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-23 
     LABEL "23" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-24 
     LABEL "24" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-25 
     LABEL "25" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-26 
     LABEL "26" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-27 
     LABEL "27" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-28 
     LABEL "28" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-29 
     LABEL "29" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-3 
     LABEL "3" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-30 
     LABEL "30" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-31 
     LABEL "31" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-4 
     LABEL "4" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-5 
     LABEL "5" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-6 
     LABEL "6" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-7 
     LABEL "7" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-8 
     LABEL "8" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-9 
     LABEL "9" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-desmarca 
     LABEL "Desmarca" 
     SIZE 28.72 BY 1.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28.72 BY 5.5.

DEFINE BUTTON bt-m-1 
     LABEL "1" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-m-10 
     LABEL "10" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-m-11 
     LABEL "11" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-m-12 
     LABEL "12" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-m-2 
     LABEL "2" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-m-3 
     LABEL "3" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-m-4 
     LABEL "4" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-m-5 
     LABEL "5" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-m-6 
     LABEL "6" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-m-7 
     LABEL "7" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-m-8 
     LABEL "8" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-m-9 
     LABEL "9" 
     SIZE 2.57 BY 1.

DEFINE BUTTON bt-m-desmarca 
     LABEL "Desmarca" 
     SIZE 28.72 BY 1.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28.72 BY 5.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-grafico AT ROW 1.25 COL 5.86
     cb-estilo-grafico AT ROW 2.75 COL 19 COLON-ALIGNED
     dt-periodo-ini AT ROW 4 COL 19 COLON-ALIGNED
     dt-periodo-fim AT ROW 4 COL 38 COLON-ALIGNED NO-LABEL
     cb-frequencia AT ROW 5 COL 19 COLON-ALIGNED
     tg-frequencia AT ROW 6.25 COL 21
     tg-acumula AT ROW 7 COL 21
     bt-salva AT ROW 8.25 COL 49
     bt-grafico AT ROW 9 COL 3
     IMAGE-29 AT ROW 4 COL 34
     IMAGE-30 AT ROW 4 COL 37
     RECT-63 AT ROW 2.5 COL 2
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

DEFINE FRAME F-ZMESES
     bt-m-1 AT ROW 1.75 COL 9
     bt-m-2 AT ROW 1.75 COL 13
     bt-m-3 AT ROW 1.75 COL 17
     bt-m-4 AT ROW 1.75 COL 21
     bt-m-5 AT ROW 3.25 COL 9
     bt-m-6 AT ROW 3.25 COL 13
     bt-m-7 AT ROW 3.25 COL 17
     bt-m-8 AT ROW 3.25 COL 21
     bt-m-9 AT ROW 4.75 COL 9
     bt-m-10 AT ROW 4.75 COL 13
     bt-m-11 AT ROW 4.75 COL 17
     bt-m-12 AT ROW 4.75 COL 21
     bt-m-desmarca AT ROW 6.75 COL 1
     RECT-62 AT ROW 1 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 55 ROW 2.5
         SIZE 29 BY 7.75
         TITLE "EM MESES".

DEFINE FRAME F-ZANOS
     bt-a-1 AT ROW 1.5 COL 6
     bt-a-2 AT ROW 1.5 COL 10
     bt-a-3 AT ROW 1.5 COL 14
     bt-a-4 AT ROW 1.5 COL 18
     bt-a-5 AT ROW 1.5 COL 22
     bt-a-6 AT ROW 2.75 COL 6
     bt-a-7 AT ROW 2.75 COL 10
     bt-a-8 AT ROW 2.75 COL 14
     bt-a-9 AT ROW 2.75 COL 18
     bt-a-10 AT ROW 2.75 COL 22
     bt-a-11 AT ROW 4 COL 6
     bt-a-12 AT ROW 4 COL 10
     bt-a-13 AT ROW 4 COL 14
     bt-a-14 AT ROW 4 COL 18
     bt-a-15 AT ROW 4 COL 22
     bt-a-16 AT ROW 5.25 COL 6
     bt-a-17 AT ROW 5.25 COL 10
     bt-a-18 AT ROW 5.25 COL 14
     bt-a-19 AT ROW 5.25 COL 18
     bt-a-20 AT ROW 5.25 COL 22
     bt-a-desmarca AT ROW 6.75 COL 1
     RECT-64 AT ROW 1 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 55 ROW 2.5
         SIZE 29 BY 7.75
         TITLE "EM ANOS".

DEFINE FRAME F-ZDIAS
     bt-1 AT ROW 1.5 COL 4
     bt-2 AT ROW 1.5 COL 7
     bt-3 AT ROW 1.5 COL 10
     bt-4 AT ROW 1.5 COL 13
     bt-5 AT ROW 1.5 COL 16
     bt-6 AT ROW 1.5 COL 19
     bt-7 AT ROW 1.5 COL 22
     bt-8 AT ROW 1.5 COL 25
     bt-9 AT ROW 2.75 COL 4
     bt-10 AT ROW 2.75 COL 7
     bt-11 AT ROW 2.75 COL 10
     bt-12 AT ROW 2.75 COL 13
     bt-13 AT ROW 2.75 COL 16
     bt-14 AT ROW 2.75 COL 19
     bt-15 AT ROW 2.75 COL 22
     bt-16 AT ROW 2.75 COL 25
     bt-17 AT ROW 4 COL 4
     bt-18 AT ROW 4 COL 7
     bt-19 AT ROW 4 COL 10
     bt-20 AT ROW 4 COL 13
     bt-21 AT ROW 4 COL 16
     bt-22 AT ROW 4 COL 19
     bt-23 AT ROW 4 COL 22
     bt-24 AT ROW 4 COL 25
     bt-25 AT ROW 5.25 COL 4
     bt-26 AT ROW 5.25 COL 7
     bt-27 AT ROW 5.25 COL 10
     bt-28 AT ROW 5.25 COL 13
     bt-29 AT ROW 5.25 COL 16
     bt-30 AT ROW 5.25 COL 19
     bt-31 AT ROW 5.25 COL 22
     bt-desmarca AT ROW 6.75 COL 1
     RECT-61 AT ROW 1 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 55 ROW 2.5
         SIZE 29 BY 7.75
         TITLE "EM DIAS".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SViewer
   Allow: Basic,DB-Fields
   Add Fields to: External-Tables
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
         HEIGHT             = 9.5
         WIDTH              = 84.
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
/* REPARENT FRAME */
ASSIGN FRAME F-ZANOS:FRAME = FRAME f-main:HANDLE
       FRAME F-ZDIAS:FRAME = FRAME f-main:HANDLE
       FRAME F-ZMESES:FRAME = FRAME f-main:HANDLE.

/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON bt-salva IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       bt-salva:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-grafico IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME F-ZANOS
                                                                        */
/* SETTINGS FOR FRAME F-ZDIAS
                                                                        */
/* SETTINGS FOR FRAME F-ZMESES
                                                                        */
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

&Scoped-define FRAME-NAME F-ZDIAS
&Scoped-define SELF-NAME bt-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-1 V-table-Win
ON CHOOSE OF bt-1 IN FRAME F-ZDIAS /* 1 */
DO:
    {gep/ge0201.i bt-1 F-ZDIAS 1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-10 V-table-Win
ON CHOOSE OF bt-10 IN FRAME F-ZDIAS /* 10 */
DO:
    {gep/ge0201.i bt-10 F-ZDIAS 10}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-11 V-table-Win
ON CHOOSE OF bt-11 IN FRAME F-ZDIAS /* 11 */
DO:
    {gep/ge0201.i bt-11 F-ZDIAS 11}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-12 V-table-Win
ON CHOOSE OF bt-12 IN FRAME F-ZDIAS /* 12 */
DO:
    {gep/ge0201.i bt-12 F-ZDIAS 12}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-13 V-table-Win
ON CHOOSE OF bt-13 IN FRAME F-ZDIAS /* 13 */
DO:
    {gep/ge0201.i bt-13 F-ZDIAS 13}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-14 V-table-Win
ON CHOOSE OF bt-14 IN FRAME F-ZDIAS /* 14 */
DO:
    {gep/ge0201.i bt-14 F-ZDIAS 14}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-15 V-table-Win
ON CHOOSE OF bt-15 IN FRAME F-ZDIAS /* 15 */
DO:
    {gep/ge0201.i bt-15 F-ZDIAS 15}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-16 V-table-Win
ON CHOOSE OF bt-16 IN FRAME F-ZDIAS /* 16 */
DO:
    {gep/ge0201.i bt-16 F-ZDIAS 16}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-17
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-17 V-table-Win
ON CHOOSE OF bt-17 IN FRAME F-ZDIAS /* 17 */
DO:
    {gep/ge0201.i bt-17 F-ZDIAS 17}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-18
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-18 V-table-Win
ON CHOOSE OF bt-18 IN FRAME F-ZDIAS /* 18 */
DO:
    {gep/ge0201.i bt-18 F-ZDIAS 18}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-19
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-19 V-table-Win
ON CHOOSE OF bt-19 IN FRAME F-ZDIAS /* 19 */
DO:
    {gep/ge0201.i bt-19 F-ZDIAS 19}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-2 V-table-Win
ON CHOOSE OF bt-2 IN FRAME F-ZDIAS /* 2 */
DO:
    {gep/ge0201.i bt-2 F-ZDIAS 2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-20 V-table-Win
ON CHOOSE OF bt-20 IN FRAME F-ZDIAS /* 20 */
DO:
    {gep/ge0201.i bt-20 F-ZDIAS 20}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-21
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-21 V-table-Win
ON CHOOSE OF bt-21 IN FRAME F-ZDIAS /* 21 */
DO:
    {gep/ge0201.i bt-21 F-ZDIAS 21}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-22
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-22 V-table-Win
ON CHOOSE OF bt-22 IN FRAME F-ZDIAS /* 22 */
DO:
    {gep/ge0201.i bt-22 F-ZDIAS 22}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-23
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-23 V-table-Win
ON CHOOSE OF bt-23 IN FRAME F-ZDIAS /* 23 */
DO:
    {gep/ge0201.i bt-23 F-ZDIAS 23}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-24
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-24 V-table-Win
ON CHOOSE OF bt-24 IN FRAME F-ZDIAS /* 24 */
DO:
    {gep/ge0201.i bt-24 F-ZDIAS 24}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-25
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-25 V-table-Win
ON CHOOSE OF bt-25 IN FRAME F-ZDIAS /* 25 */
DO:
    {gep/ge0201.i bt-25 F-ZDIAS 25}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-26
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-26 V-table-Win
ON CHOOSE OF bt-26 IN FRAME F-ZDIAS /* 26 */
DO:
    {gep/ge0201.i bt-26 F-ZDIAS 26}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-27
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-27 V-table-Win
ON CHOOSE OF bt-27 IN FRAME F-ZDIAS /* 27 */
DO:
    {gep/ge0201.i bt-27 F-ZDIAS 27}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-28
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-28 V-table-Win
ON CHOOSE OF bt-28 IN FRAME F-ZDIAS /* 28 */
DO:
    {gep/ge0201.i bt-28 F-ZDIAS 28}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-29
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-29 V-table-Win
ON CHOOSE OF bt-29 IN FRAME F-ZDIAS /* 29 */
DO:
    {gep/ge0201.i bt-29 F-ZDIAS 29}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-3 V-table-Win
ON CHOOSE OF bt-3 IN FRAME F-ZDIAS /* 3 */
DO:
    {gep/ge0201.i bt-3 F-ZDIAS 3}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-30
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-30 V-table-Win
ON CHOOSE OF bt-30 IN FRAME F-ZDIAS /* 30 */
DO:
    {gep/ge0201.i bt-30 F-ZDIAS 30}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-31
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-31 V-table-Win
ON CHOOSE OF bt-31 IN FRAME F-ZDIAS /* 31 */
DO:
    {gep/ge0201.i bt-31 F-ZDIAS 31}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-4 V-table-Win
ON CHOOSE OF bt-4 IN FRAME F-ZDIAS /* 4 */
DO:
    {gep/ge0201.i bt-4 F-ZDIAS 4}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-5 V-table-Win
ON CHOOSE OF bt-5 IN FRAME F-ZDIAS /* 5 */
DO:
    {gep/ge0201.i bt-5 F-ZDIAS 5}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-6 V-table-Win
ON CHOOSE OF bt-6 IN FRAME F-ZDIAS /* 6 */
DO:
    {gep/ge0201.i bt-6 F-ZDIAS 6}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-7 V-table-Win
ON CHOOSE OF bt-7 IN FRAME F-ZDIAS /* 7 */
DO:
    {gep/ge0201.i bt-7 F-ZDIAS 7}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-8 V-table-Win
ON CHOOSE OF bt-8 IN FRAME F-ZDIAS /* 8 */
DO:
    {gep/ge0201.i bt-8 F-ZDIAS 8}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-9 V-table-Win
ON CHOOSE OF bt-9 IN FRAME F-ZDIAS /* 9 */
DO:
    {gep/ge0201.i bt-9 F-ZDIAS 9}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ZANOS
&Scoped-define SELF-NAME bt-a-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-1 V-table-Win
ON CHOOSE OF bt-a-1 IN FRAME F-ZANOS /* 1 */
DO:
    {gep/ge0201.i bt-a-1 F-ZANOS 1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-10 V-table-Win
ON CHOOSE OF bt-a-10 IN FRAME F-ZANOS /* 10 */
DO:
    {gep/ge0201.i bt-a-10 F-ZANOS 10}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-11 V-table-Win
ON CHOOSE OF bt-a-11 IN FRAME F-ZANOS /* 11 */
DO:
    {gep/ge0201.i bt-a-11 F-ZANOS 11}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-12 V-table-Win
ON CHOOSE OF bt-a-12 IN FRAME F-ZANOS /* 12 */
DO:
    {gep/ge0201.i bt-a-12 F-ZANOS 12}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-13 V-table-Win
ON CHOOSE OF bt-a-13 IN FRAME F-ZANOS /* 13 */
DO:
    {gep/ge0201.i bt-a-13 F-ZANOS 13}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-14 V-table-Win
ON CHOOSE OF bt-a-14 IN FRAME F-ZANOS /* 14 */
DO:
    {gep/ge0201.i bt-a-14 F-ZANOS 14}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-15 V-table-Win
ON CHOOSE OF bt-a-15 IN FRAME F-ZANOS /* 15 */
DO:
    {gep/ge0201.i bt-a-15 F-ZANOS 15}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-16 V-table-Win
ON CHOOSE OF bt-a-16 IN FRAME F-ZANOS /* 16 */
DO:
    {gep/ge0201.i bt-a-16 F-ZANOS 16}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-17
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-17 V-table-Win
ON CHOOSE OF bt-a-17 IN FRAME F-ZANOS /* 17 */
DO:
    {gep/ge0201.i bt-a-17 F-ZANOS 17}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-18
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-18 V-table-Win
ON CHOOSE OF bt-a-18 IN FRAME F-ZANOS /* 18 */
DO:
    {gep/ge0201.i bt-a-18 F-ZANOS 18}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-19
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-19 V-table-Win
ON CHOOSE OF bt-a-19 IN FRAME F-ZANOS /* 19 */
DO:
    {gep/ge0201.i bt-a-19 F-ZANOS 19}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-2 V-table-Win
ON CHOOSE OF bt-a-2 IN FRAME F-ZANOS /* 2 */
DO:
    {gep/ge0201.i bt-a-2 F-ZANOS 2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-20 V-table-Win
ON CHOOSE OF bt-a-20 IN FRAME F-ZANOS /* 20 */
DO:
    {gep/ge0201.i bt-a-20 F-ZANOS 20}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-3 V-table-Win
ON CHOOSE OF bt-a-3 IN FRAME F-ZANOS /* 3 */
DO:
    {gep/ge0201.i bt-a-3 F-ZANOS 3}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-4 V-table-Win
ON CHOOSE OF bt-a-4 IN FRAME F-ZANOS /* 4 */
DO:
    {gep/ge0201.i bt-a-4 F-ZANOS 4}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-5 V-table-Win
ON CHOOSE OF bt-a-5 IN FRAME F-ZANOS /* 5 */
DO:
    {gep/ge0201.i bt-a-5 F-ZANOS 5}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-6 V-table-Win
ON CHOOSE OF bt-a-6 IN FRAME F-ZANOS /* 6 */
DO:
    {gep/ge0201.i bt-a-6 F-ZANOS 6}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-7 V-table-Win
ON CHOOSE OF bt-a-7 IN FRAME F-ZANOS /* 7 */
DO:
    {gep/ge0201.i bt-a-7 F-ZANOS 7}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-8 V-table-Win
ON CHOOSE OF bt-a-8 IN FRAME F-ZANOS /* 8 */
DO:
    {gep/ge0201.i bt-a-8 F-ZANOS 8}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-9 V-table-Win
ON CHOOSE OF bt-a-9 IN FRAME F-ZANOS /* 9 */
DO:
    {gep/ge0201.i bt-a-9 F-ZANOS 9}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-a-desmarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-a-desmarca V-table-Win
ON CHOOSE OF bt-a-desmarca IN FRAME F-ZANOS /* Desmarca */
DO:
    run pi-habilita-bt (input yes).
    assign  c-dias-selecionados = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ZDIAS
&Scoped-define SELF-NAME bt-desmarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarca V-table-Win
ON CHOOSE OF bt-desmarca IN FRAME F-ZDIAS /* Desmarca */
DO:
    run pi-habilita-bt (input yes).
    assign  c-dias-selecionados = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-main
&Scoped-define SELF-NAME bt-grafico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-grafico V-table-Win
ON CHOOSE OF bt-grafico IN FRAME f-main /* Gr†fico */
DO:
    assign  i-frequencia        = cb-frequencia:lookup(cb-frequencia:screen-value).

    if  tg-frequencia:checked
    and c-dias-selecionados = ""
    then do:
        run utp/ut-msgs.p ( input "SHOW",
                            input 18874,
                            input "").
        apply "entry" to cb-frequencia.
        return no-apply.
    end.

    for each ttParamGrafico:
        delete ttParamGrafico.
    end.
    Create  ttParamGrafico.
    Assign  ttParamGrafico.DatPeriodoIni        = date( dt-periodo-ini  :screen-value)
            ttParamGrafico.DatPeriodoFim        = date( dt-periodo-fim  :screen-value)
            ttParamGrafico.LogAcumulativo       = tg-frequencia         :checked
            ttParamGrafico.LogAcumulativoTotal  = tg-acumula            :checked
            ttParamGrafico.PeriodosAcumulados   = substring(c-dias-selecionados,1,length(c-dias-selecionados) - 1)
            ttParamGrafico.DesTipoGrafico       = trim(cb-estilo-grafico:screen-value)
            ttParamGrafico.IndTipoPeriodo       = ( if  i-frequencia = 1    /* N∆o Traduzir as palavras abaixo */
                                                    then "Em Dias"
                                                    else    if  i-frequencia = 2
                                                            then "Em Meses"
                                                            else    if  i-frequencia = 3
                                                                    then "Em Anos"
                                                                    else "Sempre no(s) Dia(s)").

    &IF "{&fc_objetivo_ge}":U = "yes":U &THEN
        Run get-field-screen-value In adm-broker-hdl (Input This-Procedure,
                                                      Input "fi-cod-cenario":U).

        Assign ttParamGrafico.NumCenario = Integer(Return-Value).
    &ENDIF

    if valid-handle(h_v14ad204) then do:
        run pi-retorna-param-ge in h_v14ad204 (output i-fator-div).
        assign ttParamGrafico.ValFator = i-fator-div.
    end.

    run pi-executar.

    &IF "{&fc_objetivo_ge}":U = "yes":U &THEN
        If cb-grafico:Lookup(cb-grafico:Screen-Value) >= 20 And
           Return-Value = "NOK":U Then
            Run utp/ut-msgs.p (Input "SHOW":U, Input 25041, Input "":U).
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-ZMESES
&Scoped-define SELF-NAME bt-m-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-m-1 V-table-Win
ON CHOOSE OF bt-m-1 IN FRAME F-ZMESES /* 1 */
DO:
    {gep/ge0201.i bt-m-1 F-ZMESES 1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-m-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-m-10 V-table-Win
ON CHOOSE OF bt-m-10 IN FRAME F-ZMESES /* 10 */
DO:
    {gep/ge0201.i bt-m-10 F-ZMESES 10}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-m-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-m-11 V-table-Win
ON CHOOSE OF bt-m-11 IN FRAME F-ZMESES /* 11 */
DO:
    {gep/ge0201.i bt-m-11 F-ZMESES 11}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-m-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-m-12 V-table-Win
ON CHOOSE OF bt-m-12 IN FRAME F-ZMESES /* 12 */
DO:
    {gep/ge0201.i bt-m-12 F-ZMESES 12}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-m-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-m-2 V-table-Win
ON CHOOSE OF bt-m-2 IN FRAME F-ZMESES /* 2 */
DO:
    {gep/ge0201.i bt-m-2 F-ZMESES 2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-m-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-m-3 V-table-Win
ON CHOOSE OF bt-m-3 IN FRAME F-ZMESES /* 3 */
DO:
    {gep/ge0201.i bt-m-3 F-ZMESES 3}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-m-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-m-4 V-table-Win
ON CHOOSE OF bt-m-4 IN FRAME F-ZMESES /* 4 */
DO:
    {gep/ge0201.i bt-m-4 F-ZMESES 4}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-m-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-m-5 V-table-Win
ON CHOOSE OF bt-m-5 IN FRAME F-ZMESES /* 5 */
DO:
    {gep/ge0201.i bt-m-5 F-ZMESES 5}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-m-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-m-6 V-table-Win
ON CHOOSE OF bt-m-6 IN FRAME F-ZMESES /* 6 */
DO:
    {gep/ge0201.i bt-m-6 F-ZMESES 6}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-m-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-m-7 V-table-Win
ON CHOOSE OF bt-m-7 IN FRAME F-ZMESES /* 7 */
DO:
    {gep/ge0201.i bt-m-7 F-ZMESES 7}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-m-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-m-8 V-table-Win
ON CHOOSE OF bt-m-8 IN FRAME F-ZMESES /* 8 */
DO:
    {gep/ge0201.i bt-m-8 F-ZMESES 8}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-m-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-m-9 V-table-Win
ON CHOOSE OF bt-m-9 IN FRAME F-ZMESES /* 9 */
DO:
    {gep/ge0201.i bt-m-9 F-ZMESES 9}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-m-desmarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-m-desmarca V-table-Win
ON CHOOSE OF bt-m-desmarca IN FRAME F-ZMESES /* Desmarca */
DO:
    run pi-habilita-bt (input yes).
    assign  c-dias-selecionados = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-main
&Scoped-define SELF-NAME bt-salva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salva V-table-Win
ON CHOOSE OF bt-salva IN FRAME f-main /* Salva ParÉmetros? */
DO:
    &IF "{&fc_objetivo_ge}":U = "yes":U &THEN

         &IF "{&mguni_version}" >= "2.071" &THEN
             DEFINE VARIABLE i-ep-codigo  LIKE empresa.ep-codigo NO-UNDO.
         &ELSE
             DEFINE VARIABLE i-ep-codigo  AS INTEGER NO-UNDO.
         &ENDIF


        DEFINE VARIABLE raw-auxiliar AS RAW     NO-UNDO.

        DO TRANSACTION:
            FOR EACH ttParamGrafico:
                DELETE ttParamGrafico.
            END.

            CREATE ttParamGrafico.
            ASSIGN ttParamGrafico.DatPeriodoIni       = DATE(dt-periodo-ini:SCREEN-VALUE)
                   ttParamGrafico.DatPeriodoFim       = DATE(dt-periodo-fim:SCREEN-VALUE)
                   ttParamGrafico.LogAcumulativo      = tg-frequencia:CHECKED
                   ttParamGrafico.LogAcumulativoTotal = tg-acumula:CHECKED
                   ttParamGrafico.PeriodosAcumulados  = SUBSTRING(c-dias-selecionados, 1, LENGTH(c-dias-selecionados) - 1)
                   ttParamGrafico.DesTipoGrafico      = TRIM(cb-estilo-grafico:SCREEN-VALUE)
                   ttParamGrafico.IndTipoPeriodo      = IF i-frequencia = 1 /* N∆o Traduzir as palavras abaixo */
                                                           THEN "Em Dias"
                                                           ELSE IF i-frequencia = 2
                                                                   THEN "Em Meses"
                                                                   ELSE IF i-frequencia = 3
                                                                           THEN "Em Anos"
                                                                           ELSE "Sempre no(s) Dia(s)".

            RUN get-field-screen-value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                          INPUT "ep-codigo":U).

            &IF "{&mguni_version}" >= "2.071" &THEN
                ASSIGN i-ep-codigo = STRING(RETURN-VALUE) NO-ERROR.
            &ELSE
            
                ASSIGN i-ep-codigo = INTEGER(RETURN-VALUE) NO-ERROR. /*FO: 1907.517*/
            &ENDIF
            

            FIND FIRST param-graf-ge 
                WHERE param-graf-ge.ep-codigo         = i-ep-codigo AND
                      param-graf-ge.usuar-par-grafico = c-seg-usuario AND

                      /* Est† sendo utilizado o campo seq-grafico no lugar do tp-grafico, 
                         devido ao fato do primary index conter este campo */
                      param-graf-ge.seq-grafico       = cb-grafico:LOOKUP(cb-grafico:SCREEN-VALUE)
                EXCLUSIVE-LOCK NO-ERROR.

            IF NOT AVAILABLE param-graf-ge THEN DO:
                CREATE param-graf-ge.

                ASSIGN param-graf-ge.ep-codigo         = i-ep-codigo
                       param-graf-ge.usuar-par-grafico = c-seg-usuario
                       param-graf-ge.seq-grafico       = cb-grafico:LOOKUP(cb-grafico:SCREEN-VALUE)
                       param-graf-ge.seq-par-grafico   = 1
                       param-graf-ge.tp-grafico        = cb-grafico:LOOKUP(cb-grafico:SCREEN-VALUE).
            END.

            RAW-TRANSFER ttParamGrafico TO raw-auxiliar.

            &IF "{&mgadm_dbtype}":U = "PROGRESS":U &THEN
                ASSIGN param-graf-ge.par-grafico = raw-auxiliar.
            &ELSE
                ASSIGN param-graf-ge.par-grafico = STRING(raw-auxiliar).
            &ENDIF

        END.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-frequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-frequencia V-table-Win
ON VALUE-CHANGED OF cb-frequencia IN FRAME f-main /* FreqÅància */
DO:
    assign  i-frequencia        = cb-frequencia:lookup(cb-frequencia:screen-value)
            c-dias-selecionados = "".

    if  i-frequencia = 1    /*  Em Dias */
    and tg-frequencia
    then do:
        hide frame f-zanos.
        hide frame f-zmeses.
        view frame f-zdias.
        run pi-habilita-bt (input yes).
    end.
    else do:
        if  i-frequencia = 2    /*  Em Meses    */
        and tg-frequencia
        then do:
            hide frame f-zdias.
            hide frame f-zanos.
            view frame f-zmeses.
            run pi-habilita-bt (input yes).
        end.
        else do:
            if  i-frequencia = 3    /*  Em Anos */
            and tg-frequencia
            then do:
                hide frame f-zdias.
                hide frame f-zmeses.
                view frame f-zanos.
                run pi-habilita-bt (input yes).
            end.
            else do:
                if  i-frequencia = 4    /*  Sempre Nos Dias */
                then do:
                    hide frame f-zmeses.
                    hide frame f-zanos.
                    view frame f-zdias.
                    run pi-habilita-bt (input yes).
                    assign  tg-frequencia:checked = yes.
                end.
                else do:
                    hide frame f-zmeses.
                    hide frame f-zanos.
                    hide frame f-zdias.
                    assign  tg-frequencia:checked = no.
                end.
                apply "value-changed" to tg-frequencia.
            end.
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-grafico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-grafico V-table-Win
ON VALUE-CHANGED OF cb-grafico IN FRAME f-main /* Tipo de Gr†fico */
DO:
    ASSIGN  i-tp-grafico = cb-grafico:LOOKUP(cb-grafico:SCREEN-VALUE).

    RUN pi-ini-widgets IN THIS-PROCEDURE.

/*    FOR EACH ttParamGrafico:
 *         DELETE ttParamGrafico.
 *     END.
 *     
 *     CREATE ttParamGrafico.
 *     
 *     RUN pi-executar IN THIS-PROCEDURE.
 *     
 *     FIND FIRST ttParamGrafico NO-LOCK NO-ERROR.
 *     
 *     ASSIGN c-dias-selecionados = "":U
 *            i-frequencia        = 1
 *            
 *            cb-estilo-grafico:LIST-ITEMS   = ttParamGrafico.IndTipoGrafico
 *            cb-estilo-grafico:SCREEN-VALUE = ENTRY(1, ttParamGrafico.IndTipoGrafico).*/

    IF i-tp-grafico >= 15 AND i-tp-grafico <= 19 THEN
        ASSIGN cb-frequencia:SENSITIVE    = NO
               cb-frequencia:SCREEN-VALUE = &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then ENTRY(2, cb-frequencia:List-item-pairs) &else ENTRY(1, cb-frequencia:LIST-ITEMS) &endif
               tg-frequencia:SENSITIVE    = NO
               tg-frequencia:CHECKED      = NO.
    ELSE
        ASSIGN cb-frequencia:SENSITIVE = YES
               tg-frequencia:SENSITIVE = YES.

    &IF "{&fc_objetivo_ge}":U = "yes":U &THEN
        
        &IF "{&mguni_version}" >= "2.071" &THEN
             DEFINE VARIABLE i-ep-codigo  LIKE empresa.ep-codigo NO-UNDO.
         &ELSE
             DEFINE VARIABLE i-ep-codigo  AS INTEGER NO-UNDO.
         &ENDIF
    
        DEFINE VARIABLE i-selecionados AS INTEGER NO-UNDO.
        DEFINE VARIABLE raw-auxiliar   AS RAW     NO-UNDO.

        RUN get-field-screen-value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                      INPUT "ep-codigo":U).

        &IF "{&mguni_version}" >= "2.071" &THEN
            ASSIGN i-ep-codigo = STRING(RETURN-VALUE) NO-ERROR.
        &ELSE
            ASSIGN i-ep-codigo = INTEGER(RETURN-VALUE) NO-ERROR.
        &ENDIF

        FIND FIRST param-graf-ge 
            WHERE param-graf-ge.ep-codigo         = i-ep-codigo AND
                  param-graf-ge.usuar-par-grafico = c-seg-usuario AND

                  /* Est† sendo utilizado o campo seq-grafico no lugar do tp-grafico, 
                     devido ao fato do primary index conter este campo */
                  param-graf-ge.seq-grafico       = cb-grafico:LOOKUP(cb-grafico:SCREEN-VALUE)
            NO-LOCK NO-ERROR.

        IF AVAILABLE param-graf-ge THEN DO:
            FOR EACH ttParamGrafico:
                DELETE ttParamGrafico.
            END.

            &IF "{&mgadm_dbtype}":U = "PROGRESS":U &THEN
                ASSIGN raw-auxiliar = param-graf-ge.par-grafico.
            &ELSE
                RUN btb/btb928za.p ( INPUT param-graf-ge.par-grafico,
                                    OUTPUT raw-auxiliar) NO-ERROR.

                IF ERROR-STATUS:ERROR THEN RETURN.
            &ENDIF

            CREATE ttParamGrafico.
            RAW-TRANSFER raw-auxiliar TO ttParamGrafico.

            ASSIGN c-dias-selecionados = ttParamGrafico.PeriodosAcumulados

                   dt-periodo-ini:SCREEN-VALUE    = STRING(ttParamGrafico.DatPeriodoIni)
                   dt-periodo-fim:SCREEN-VALUE    = STRING(ttParamGrafico.DatPeriodoFim)
                   tg-frequencia:CHECKED          = ttParamGrafico.LogAcumulativo
                   tg-acumula:CHECKED             = ttParamGrafico.LogAcumulativoTotal
                   cb-estilo-grafico:SCREEN-VALUE = ttParamGrafico.DesTipoGrafico
                   cb-frequencia:SCREEN-VALUE     = IF ttParamGrafico.IndTipoPeriodo = c-dia 
                                                       THEN &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then ENTRY(2, cb-frequencia:List-item-pairs) &else ENTRY(1, cb-frequencia:LIST-ITEMS) &endif
                                                       ELSE IF ttParamGrafico.IndTipoPeriodo = c-mes
                                                               THEN &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then ENTRY(4, cb-frequencia:List-item-pairs) &else ENTRY(2, cb-frequencia:LIST-ITEMS) &endif
                                                               ELSE IF ttParamGrafico.IndTipoPeriodo = c-ano
                                                                       THEN &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then ENTRY(6, cb-frequencia:List-item-pairs) &else ENTRY(3, cb-frequencia:LIST-ITEMS) &endif
                                                                       ELSE &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then ENTRY(8, cb-frequencia:List-item-pairs) &else ENTRY(4, cb-frequencia:LIST-ITEMS) &endif.

            APPLY "VALUE-CHANGED":U TO tg-frequencia.

            ASSIGN tg-acumula:CHECKED = ttParamGrafico.LogAcumulativoTotal.

            DO i-selecionados = 1 TO NUM-ENTRIES(ttParamGrafico.PeriodosAcumulados):
                CASE ttParamGrafico.IndTipoPeriodo:
                    WHEN c-dia THEN DO:
                        CASE INTEGER(ENTRY(i-selecionados, ttParamGrafico.PeriodosAcumulados)):
                            WHEN  1 THEN ASSIGN bt-1 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN  2 THEN ASSIGN bt-2 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN  3 THEN ASSIGN bt-3 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN  4 THEN ASSIGN bt-4 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN  5 THEN ASSIGN bt-5 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN  6 THEN ASSIGN bt-6 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN  7 THEN ASSIGN bt-7 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN  8 THEN ASSIGN bt-8 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN  9 THEN ASSIGN bt-9 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 10 THEN ASSIGN bt-10:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 11 THEN ASSIGN bt-11:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 12 THEN ASSIGN bt-12:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 13 THEN ASSIGN bt-13:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 14 THEN ASSIGN bt-14:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 15 THEN ASSIGN bt-15:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 16 THEN ASSIGN bt-16:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 17 THEN ASSIGN bt-17:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 18 THEN ASSIGN bt-18:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 19 THEN ASSIGN bt-19:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 20 THEN ASSIGN bt-20:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 21 THEN ASSIGN bt-21:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 22 THEN ASSIGN bt-22:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 23 THEN ASSIGN bt-23:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 24 THEN ASSIGN bt-24:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 25 THEN ASSIGN bt-25:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 26 THEN ASSIGN bt-26:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 27 THEN ASSIGN bt-27:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 28 THEN ASSIGN bt-28:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 29 THEN ASSIGN bt-29:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 30 THEN ASSIGN bt-30:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 31 THEN ASSIGN bt-31:SENSITIVE IN FRAME f-zdias = NO.
                        END CASE.
                    END.

                    WHEN c-mes THEN DO:
                        CASE INTEGER(ENTRY(i-selecionados, ttParamGrafico.PeriodosAcumulados)):
                            WHEN  1 THEN ASSIGN bt-m-1 :SENSITIVE IN FRAME f-zmeses = NO.
                            WHEN  2 THEN ASSIGN bt-m-2 :SENSITIVE IN FRAME f-zmeses = NO.
                            WHEN  3 THEN ASSIGN bt-m-3 :SENSITIVE IN FRAME f-zmeses = NO.
                            WHEN  4 THEN ASSIGN bt-m-4 :SENSITIVE IN FRAME f-zmeses = NO.
                            WHEN  5 THEN ASSIGN bt-m-5 :SENSITIVE IN FRAME f-zmeses = NO.
                            WHEN  6 THEN ASSIGN bt-m-6 :SENSITIVE IN FRAME f-zmeses = NO.
                            WHEN  7 THEN ASSIGN bt-m-7 :SENSITIVE IN FRAME f-zmeses = NO.
                            WHEN  8 THEN ASSIGN bt-m-8 :SENSITIVE IN FRAME f-zmeses = NO.
                            WHEN  9 THEN ASSIGN bt-m-9 :SENSITIVE IN FRAME f-zmeses = NO.
                            WHEN 10 THEN ASSIGN bt-m-10:SENSITIVE IN FRAME f-zmeses = NO.
                            WHEN 11 THEN ASSIGN bt-m-11:SENSITIVE IN FRAME f-zmeses = NO.
                            WHEN 12 THEN ASSIGN bt-m-12:SENSITIVE IN FRAME f-zmeses = NO.
                        END CASE.
                    END.

                    WHEN c-ano THEN DO:
                        CASE INTEGER(ENTRY(i-selecionados, ttParamGrafico.PeriodosAcumulados)):
                            WHEN  1 THEN ASSIGN bt-a-1 :SENSITIVE IN FRAME f-zanos = NO.
                            WHEN  2 THEN ASSIGN bt-a-2 :SENSITIVE IN FRAME f-zanos = NO.
                            WHEN  3 THEN ASSIGN bt-a-3 :SENSITIVE IN FRAME f-zanos = NO.
                            WHEN  4 THEN ASSIGN bt-a-4 :SENSITIVE IN FRAME f-zanos = NO.
                            WHEN  5 THEN ASSIGN bt-a-5 :SENSITIVE IN FRAME f-zanos = NO.
                            WHEN  6 THEN ASSIGN bt-a-6 :SENSITIVE IN FRAME f-zanos = NO.
                            WHEN  7 THEN ASSIGN bt-a-7 :SENSITIVE IN FRAME f-zanos = NO.
                            WHEN  8 THEN ASSIGN bt-a-8 :SENSITIVE IN FRAME f-zanos = NO.
                            WHEN  9 THEN ASSIGN bt-a-9 :SENSITIVE IN FRAME f-zanos = NO.
                            WHEN 10 THEN ASSIGN bt-a-10:SENSITIVE IN FRAME f-zanos = NO.
                            WHEN 11 THEN ASSIGN bt-a-11:SENSITIVE IN FRAME f-zanos = NO.
                            WHEN 12 THEN ASSIGN bt-a-12:SENSITIVE IN FRAME f-zanos = NO.
                            WHEN 13 THEN ASSIGN bt-a-13:SENSITIVE IN FRAME f-zanos = NO.
                            WHEN 14 THEN ASSIGN bt-a-14:SENSITIVE IN FRAME f-zanos = NO.
                            WHEN 15 THEN ASSIGN bt-a-15:SENSITIVE IN FRAME f-zanos = NO.
                            WHEN 16 THEN ASSIGN bt-a-16:SENSITIVE IN FRAME f-zanos = NO.
                            WHEN 17 THEN ASSIGN bt-a-17:SENSITIVE IN FRAME f-zanos = NO.
                            WHEN 18 THEN ASSIGN bt-a-18:SENSITIVE IN FRAME f-zanos = NO.
                            WHEN 19 THEN ASSIGN bt-a-19:SENSITIVE IN FRAME f-zanos = NO.
                            WHEN 20 THEN ASSIGN bt-a-20:SENSITIVE IN FRAME f-zanos = NO.
                        END CASE.
                    END.

                    OTHERWISE DO:
                        CASE INTEGER(ENTRY(i-selecionados, ttParamGrafico.PeriodosAcumulados)):
                            WHEN  1 THEN ASSIGN bt-1 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN  2 THEN ASSIGN bt-2 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN  3 THEN ASSIGN bt-3 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN  4 THEN ASSIGN bt-4 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN  5 THEN ASSIGN bt-5 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN  6 THEN ASSIGN bt-6 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN  7 THEN ASSIGN bt-7 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN  8 THEN ASSIGN bt-8 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN  9 THEN ASSIGN bt-9 :SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 10 THEN ASSIGN bt-10:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 11 THEN ASSIGN bt-11:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 12 THEN ASSIGN bt-12:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 13 THEN ASSIGN bt-13:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 14 THEN ASSIGN bt-14:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 15 THEN ASSIGN bt-15:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 16 THEN ASSIGN bt-16:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 17 THEN ASSIGN bt-17:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 18 THEN ASSIGN bt-18:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 19 THEN ASSIGN bt-19:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 20 THEN ASSIGN bt-20:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 21 THEN ASSIGN bt-21:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 22 THEN ASSIGN bt-22:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 23 THEN ASSIGN bt-23:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 24 THEN ASSIGN bt-24:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 25 THEN ASSIGN bt-25:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 26 THEN ASSIGN bt-26:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 27 THEN ASSIGN bt-27:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 28 THEN ASSIGN bt-28:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 29 THEN ASSIGN bt-29:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 30 THEN ASSIGN bt-30:SENSITIVE IN FRAME f-zdias = NO.
                            WHEN 31 THEN ASSIGN bt-31:SENSITIVE IN FRAME f-zdias = NO.
                        END CASE.
                    END.
                END CASE.
            END.
        END.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-frequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-frequencia V-table-Win
ON VALUE-CHANGED OF tg-frequencia IN FRAME f-main /* Informa FreqÅància Per°odos? */
DO:
    assign  tg-acumula      :sensitive  = tg-frequencia:checked
            tg-acumula      :checked    = no.

    if  tg-frequencia:checked
    then do:
        if  i-frequencia = 2    /*  Em Meses    */
        then do:
            hide frame f-zdias.
            hide frame f-zanos.
            view frame f-zmeses.
            run pi-habilita-bt (input yes).
        end.
        else do:
            if  i-frequencia = 3    /*  Em Anos */
            then do:
                hide frame f-zdias.
                hide frame f-zmeses.
                view frame f-zanos.
                run pi-habilita-bt (input yes).
            end.
            else do:
                hide frame f-zmeses.
                hide frame f-zanos.
                view frame f-zdias.
                run pi-habilita-bt (input yes).
            end.
        end.
    end.
    else do:
        if  i-frequencia <> 4
        then do:
            hide frame f-zdias.
            hide frame f-zmeses.
            hide frame f-zanos.
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

&IF "{&fc_objetivo_ge}":U = "yes":U &THEN
    ASSIGN
        bt-salva:HIDDEN IN FRAME {&FRAME-NAME}    = NO
        bt-salva:SENSITIVE IN FRAME {&FRAME-NAME} = YES

        rt-mold:HEIGHT IN FRAME {&FRAME-NAME} = 9.0
        rect-63:HEIGHT IN FRAME {&FRAME-NAME} = 7.25
        bt-grafico:ROW IN FRAME {&FRAME-NAME} = 8.25

        bt-1:ROW IN FRAME f-zdias        = 1.25
        bt-2:ROW IN FRAME f-zdias        = 1.25
        bt-3:ROW IN FRAME f-zdias        = 1.25
        bt-4:ROW IN FRAME f-zdias        = 1.25
        bt-5:ROW IN FRAME f-zdias        = 1.25
        bt-6:ROW IN FRAME f-zdias        = 1.25
        bt-7:ROW IN FRAME f-zdias        = 1.25
        bt-8:ROW IN FRAME f-zdias        = 1.25
        bt-9:ROW IN FRAME f-zdias        = 2.50
        bt-10:ROW IN FRAME f-zdias       = 2.50
        bt-11:ROW IN FRAME f-zdias       = 2.50
        bt-12:ROW IN FRAME f-zdias       = 2.50
        bt-13:ROW IN FRAME f-zdias       = 2.50
        bt-14:ROW IN FRAME f-zdias       = 2.50
        bt-15:ROW IN FRAME f-zdias       = 2.50
        bt-16:ROW IN FRAME f-zdias       = 2.50
        bt-17:ROW IN FRAME f-zdias       = 3.75
        bt-18:ROW IN FRAME f-zdias       = 3.75
        bt-19:ROW IN FRAME f-zdias       = 3.75
        bt-20:ROW IN FRAME f-zdias       = 3.75
        bt-21:ROW IN FRAME f-zdias       = 3.75
        bt-22:ROW IN FRAME f-zdias       = 3.75
        bt-23:ROW IN FRAME f-zdias       = 3.75
        bt-24:ROW IN FRAME f-zdias       = 3.75
        bt-25:ROW IN FRAME f-zdias       = 5.00
        bt-26:ROW IN FRAME f-zdias       = 5.00
        bt-27:ROW IN FRAME f-zdias       = 5.00
        bt-28:ROW IN FRAME f-zdias       = 5.00
        bt-29:ROW IN FRAME f-zdias       = 5.00
        bt-30:ROW IN FRAME f-zdias       = 5.00
        bt-31:ROW IN FRAME f-zdias       = 5.00
        bt-desmarca:ROW IN FRAME f-zdias = 6.25
        rect-61:HEIGHT IN FRAME f-zdias  = 5.25

        bt-m-1:ROW IN FRAME f-zmeses        = 1.50
        bt-m-2:ROW IN FRAME f-zmeses        = 1.50
        bt-m-3:ROW IN FRAME f-zmeses        = 1.50
        bt-m-4:ROW IN FRAME f-zmeses        = 1.50
        bt-m-5:ROW IN FRAME f-zmeses        = 3.00
        bt-m-6:ROW IN FRAME f-zmeses        = 3.00
        bt-m-7:ROW IN FRAME f-zmeses        = 3.00
        bt-m-8:ROW IN FRAME f-zmeses        = 3.00
        bt-m-9:ROW IN FRAME f-zmeses        = 4.50
        bt-m-10:ROW IN FRAME f-zmeses       = 4.50
        bt-m-11:ROW IN FRAME f-zmeses       = 4.50
        bt-m-12:ROW IN FRAME f-zmeses       = 4.50
        bt-m-desmarca:ROW IN FRAME f-zmeses = 6.25
        rect-62:HEIGHT IN FRAME f-zmeses    = 5.25

        bt-a-1:ROW IN FRAME f-zanos        = 1.25
        bt-a-2:ROW IN FRAME f-zanos        = 1.25
        bt-a-3:ROW IN FRAME f-zanos        = 1.25
        bt-a-4:ROW IN FRAME f-zanos        = 1.25
        bt-a-5:ROW IN FRAME f-zanos        = 1.25
        bt-a-6:ROW IN FRAME f-zanos        = 2.50
        bt-a-7:ROW IN FRAME f-zanos        = 2.50
        bt-a-8:ROW IN FRAME f-zanos        = 2.50
        bt-a-9:ROW IN FRAME f-zanos        = 2.50
        bt-a-10:ROW IN FRAME f-zanos       = 2.50
        bt-a-11:ROW IN FRAME f-zanos       = 3.75
        bt-a-12:ROW IN FRAME f-zanos       = 3.75
        bt-a-13:ROW IN FRAME f-zanos       = 3.75
        bt-a-14:ROW IN FRAME f-zanos       = 3.75
        bt-a-15:ROW IN FRAME f-zanos       = 3.75
        bt-a-16:ROW IN FRAME f-zanos       = 5.00
        bt-a-17:ROW IN FRAME f-zanos       = 5.00
        bt-a-18:ROW IN FRAME f-zanos       = 5.00
        bt-a-19:ROW IN FRAME f-zanos       = 5.00
        bt-a-20:ROW IN FRAME f-zanos       = 5.00
        bt-a-desmarca:ROW IN FRAME f-zanos = 6.25
        rect-64:HEIGHT IN FRAME f-zanos    = 5.25

        FRAME f-zdias:HEIGHT  = 7.35
        FRAME f-zmeses:HEIGHT = 7.35
        FRAME f-zanos:HEIGHT  = 7.35

        FRAME f-zdias:SCROLLABLE  = NO
        FRAME f-zmeses:SCROLLABLE = NO
        FRAME f-zanos:SCROLLABLE  = NO

        FRAME {&FRAME-NAME}:HEIGHT = 9.01.

        {utp/ut-liter.i Salva_ParÉmetros}
        ASSIGN bt-salva:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

        {utp/ut-liter.i Salva_parametrizaá∆o_efetuada_para_este_gr†fico}
        ASSIGN bt-salva:HELP IN FRAME {&FRAME-NAME}    = TRIM(RETURN-VALUE)
               bt-salva:TOOLTIP IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
&ENDIF

{utp/ut-liter.i Desmarca * 1}
ASSIGN bt-desmarca:LABEL IN FRAME F-ZDIAS    = TRIM(RETURN-VALUE)
       bt-m-desmarca:LABEL IN FRAME F-ZMESES = TRIM(RETURN-VALUE)
       bt-a-desmarca:LABEL IN FRAME F-ZANOS  = TRIM(RETURN-VALUE).

{utp/ut-liter.i Gr†fico * 1}
ASSIGN bt-grafico:LABEL  IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i FreqÅància * 1}
ASSIGN cb-frequencia:LABEL  IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Tipo de Gr†fico" * 1}
ASSIGN cb-grafico:LABEL  IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Per°odo Inicial" * 1}
ASSIGN dt-periodo-ini:LABEL  IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Acumula Per°odos?" * 1}
ASSIGN tg-acumula:LABEL  IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Informa FreqÅància Per°odos?" * 1}
ASSIGN tg-frequencia:LABEL  IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i EM_DIAS *}
Assign Frame F-ZDIAS:title = Return-value.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

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
  HIDE FRAME F-ZANOS.
  HIDE FRAME F-ZDIAS.
  HIDE FRAME F-ZMESES.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
def var i-tp-gr as int.
def var c-tipo-grafico as char.

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */


    /* Code placed here will execute AFTER standard behavior.    */

    assign c-tipo-grafico = {adinc/i02ad204.i 03} &IF "{&fc_objetivo_ge}":U = "yes":U &THEN + ",":U + {adinc/i05ad204.i 03} &ENDIF.

    do  i-tp-gr = 1 to num-entries(c-tipo-grafico):

        assign  entry(i-tp-gr,c-tipo-grafico,",") = string(i-tp-gr,"99") + "-" +  entry(i-tp-gr,c-tipo-grafico,",").

    end.

    ASSIGN cb-frequencia:LIST-ITEMS IN FRAME {&frame-name}   = {adinc/i03ad204.i 03} 

           cb-grafico:LIST-ITEMS IN FRAME {&FRAME-NAME}      = c-tipo-grafico    
           .

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    Assign cb-frequencia:SCREEN-VALUE IN FRAME {&frame-name} = {adinc/i03ad204.i 04 1}
           cb-grafico:SCREEN-VALUE IN FRAME {&FRAME-NAME}    = entry(1,c-tipo-grafico,",").

    RUN pi-ini-widgets IN THIS-PROCEDURE.

/*    ENABLE ALL WITH FRAME f-zdias.
 *     ENABLE ALL WITH FRAME f-zmeses.
 *     ENABLE ALL WITH FRAME f-zanos.
 *     
 *     ASSIGN tg-acumula:SENSITIVE IN FRAME {&FRAME-NAME}        = NO
 *            dt-periodo-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "01/01/":U + STRING(YEAR(TODAY), "9999":U)
 *            dt-periodo-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY).
 *     
 *     IF tg-frequencia:CHECKED IN FRAME {&FRAME-NAME} THEN
 *         VIEW FRAME f-zdias.
 *     ELSE DO:
 *         HIDE FRAME f-zdias.
 *         HIDE FRAME f-zmeses.
 *         HIDE FRAME f-zanos.
 *     END.
 *     
 *     FOR EACH ttParamGrafico:
 *         DELETE ttParamGrafico.
 *     END.
 *     
 *     CREATE ttParamGrafico.
 *     
 *     RUN pi-executar IN THIS-PROCEDURE.
 *     
 *     FIND FIRST ttParamGrafico NO-LOCK NO-ERROR.
 *     
 *     ASSIGN cb-estilo-grafico:LIST-ITEMS IN FRAME {&frame-name}   = ttParamGrafico.IndTipoGrafico
 *            cb-estilo-grafico:SCREEN-VALUE IN FRAME {&frame-name} = ENTRY(1, ttParamGrafico.IndTipoGrafico).*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view V-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    APPLY "VALUE-CHANGED":U TO cb-grafico IN FRAME {&FRAME-NAME}.

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
    DEFINE INPUT PARAMETER v-row-parent-externo AS ROWID NO-UNDO.

    ASSIGN v-row-parent = v-row-parent-externo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar V-table-Win 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    CASE i-tp-grafico:
        WHEN  1 THEN RUN gep/ge020101.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN  2 THEN RUN gep/ge020102.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN  3 THEN RUN gep/ge020103.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN  4 THEN RUN gep/ge020104.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN  5 THEN RUN gep/ge020105.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN  6 THEN RUN gep/ge020106.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN  7 THEN RUN gep/ge020107.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN  8 THEN RUN gep/ge020108.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN  9 THEN RUN gep/ge020109.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 10 THEN RUN gep/ge020110.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 11 THEN RUN gep/ge020111.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 12 THEN RUN gep/ge020112.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 13 THEN RUN gep/ge020113.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 14 THEN RUN gep/ge020114.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 15 THEN RUN gep/ge020115.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 16 THEN RUN gep/ge020116.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 17 THEN RUN gep/ge020117.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 18 THEN RUN gep/ge020118.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 19 THEN RUN gep/ge020119.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 20 THEN RUN gep/ge020120.p (INPUT-OUTPUT TABLE ttParamGrafico).

    &IF "{&fc_objetivo_ge}":U = "yes":U &THEN
        WHEN 21 THEN RUN gep/ge020121.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 22 THEN RUN gep/ge020122.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 23 THEN RUN gep/ge020123.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 24 THEN RUN gep/ge020124.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 25 THEN RUN gep/ge020125.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 26 THEN RUN gep/ge020126.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 27 THEN RUN gep/ge020127.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 28 THEN RUN gep/ge020128.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 29 THEN RUN gep/ge020129.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 30 THEN RUN gep/ge020130.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 31 THEN RUN gep/ge020131.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 32 THEN RUN gep/ge020132.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 33 THEN RUN gep/ge020133.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 34 THEN RUN gep/ge020134.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 35 THEN RUN gep/ge020135.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 36 THEN RUN gep/ge020136.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 37 THEN RUN gep/ge020137.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 38 THEN RUN gep/ge020138.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 39 THEN RUN gep/ge020139.p (INPUT-OUTPUT TABLE ttParamGrafico).
        WHEN 40 THEN RUN gep/ge020140.p (INPUT-OUTPUT TABLE ttParamGrafico).
    &ENDIF

    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-bt V-table-Win 
PROCEDURE pi-habilita-bt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER ip-situacao AS LOGICAL NO-UNDO.

    ASSIGN c-dias-selecionados = "":U.

    IF i-frequencia = 2 /* Em Meses */ THEN
        ASSIGN bt-m-1 :SENSITIVE IN FRAME f-zmeses = ip-situacao
               bt-m-2 :SENSITIVE IN FRAME f-zmeses = ip-situacao
               bt-m-3 :SENSITIVE IN FRAME f-zmeses = ip-situacao
               bt-m-4 :SENSITIVE IN FRAME f-zmeses = ip-situacao
               bt-m-5 :SENSITIVE IN FRAME f-zmeses = ip-situacao
               bt-m-6 :SENSITIVE IN FRAME f-zmeses = ip-situacao
               bt-m-7 :SENSITIVE IN FRAME f-zmeses = ip-situacao
               bt-m-8 :SENSITIVE IN FRAME f-zmeses = ip-situacao
               bt-m-9 :SENSITIVE IN FRAME f-zmeses = ip-situacao
               bt-m-10:SENSITIVE IN FRAME f-zmeses = ip-situacao
               bt-m-11:SENSITIVE IN FRAME f-zmeses = ip-situacao
               bt-m-12:SENSITIVE IN FRAME f-zmeses = ip-situacao.
    ELSE IF i-frequencia = 3 /* Em Anos */ THEN
        ASSIGN bt-a-1 :SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-2 :SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-3 :SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-4 :SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-5 :SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-6 :SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-7 :SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-8 :SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-9 :SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-10:SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-11:SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-12:SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-13:SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-14:SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-15:SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-16:SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-17:SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-18:SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-19:SENSITIVE IN FRAME f-zanos = ip-situacao
               bt-a-20:SENSITIVE IN FRAME f-zanos = ip-situacao.
    ELSE
        ASSIGN bt-1 :SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-2 :SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-3 :SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-4 :SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-5 :SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-6 :SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-7 :SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-8 :SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-9 :SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-10:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-11:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-12:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-13:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-14:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-15:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-16:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-17:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-18:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-19:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-20:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-21:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-22:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-23:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-24:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-25:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-26:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-27:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-28:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-29:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-30:SENSITIVE IN FRAME f-zdias = ip-situacao
               bt-31:SENSITIVE IN FRAME f-zdias = ip-situacao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ini-widgets V-table-Win 
PROCEDURE pi-ini-widgets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
         Def Var c-lista As Char No-undo.
    &endif

    ENABLE ALL WITH FRAME f-zdias.
    ENABLE ALL WITH FRAME f-zmeses.
    ENABLE ALL WITH FRAME f-zanos.

    ASSIGN cb-frequencia:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then ENTRY(2, cb-frequencia:List-item-pairs IN FRAME {&FRAME-NAME}) &else ENTRY(1, cb-frequencia:LIST-ITEMS IN FRAME {&FRAME-NAME}) &endif
           dt-periodo-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "01/01/":U + STRING(YEAR(TODAY), "9999":U)
           dt-periodo-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY)
           tg-acumula:SENSITIVE IN FRAME {&FRAME-NAME}        = NO
           tg-acumula:CHECKED IN FRAME {&FRAME-NAME}          = NO
           tg-frequencia:CHECKED IN FRAME {&FRAME-NAME}       = NO.

    IF tg-frequencia:CHECKED IN FRAME {&FRAME-NAME} THEN
        VIEW FRAME f-zdias.
    ELSE DO:
        HIDE FRAME f-zdias.
        HIDE FRAME f-zmeses.
        HIDE FRAME f-zanos.
    END.

    FOR EACH ttParamGrafico:
        DELETE ttParamGrafico.
    END.

    CREATE ttParamGrafico.

    RUN pi-executar IN THIS-PROCEDURE.

    FIND FIRST ttParamGrafico NO-LOCK NO-ERROR.

    ASSIGN c-dias-selecionados = "":U
           i-frequencia        = 1.
    &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
         Assign c-lista = ttParamGrafico.IndTipoGrafico.
         Run utp/ut-lstit.p (input-output c-lista).
         If c-lista <> "" Then
            Assign cb-estilo-grafico:List-item-pairs IN FRAME {&FRAME-NAME}   = c-lista.
    &else
         Assign cb-estilo-grafico:LIST-ITEMS IN FRAME {&frame-name}   = ttParamGrafico.IndTipoGrafico.
    &ENDIF

     Assign cb-estilo-grafico:SCREEN-VALUE IN FRAME {&frame-name} = ENTRY(1, ttParamGrafico.IndTipoGrafico).

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

def input param h-v14ad204 as handle no-undo.

assign h_v14ad204 = h-v14ad204.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

/*/*    Segue um exemplo de validaá∆o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-value-changed V-table-Win 
PROCEDURE pi-value-changed :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    APPLY "VALUE-CHANGED":U TO cb-grafico IN FRAME {&FRAME-NAME}.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SViewer, and there are no
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

    RUN pi-trata-state IN THIS-PROCEDURE (INPUT p-issuer-hdl, INPUT p-state).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

