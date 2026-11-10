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
{include/i-prgvrs.i V02AD270 2.00.00.034} /*** "010034" 25/06/2025 16:21:13  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02ad270 MUT}
&ENDIF

/* y2kready */

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
def new global shared var gr-ano-fiscal as rowid.
def var i-cont      as integer no-undo.
def var i-ind       as integer no-undo.
def var i-aux       as integer no-undo.
def var l-confirma  as logical format "Sim/N∆o" no-undo.
def var l-estoque   as logical format "Sim/N∆o" no-undo.
def var da-anterior as date no-undo.
def var da-work     as date no-undo.
def var c-aux       as char no-undo.
def var i-ano       as integer no-undo.
def var l-aux       as logical no-undo.
def var l-achou     as logical init no no-undo.
def var i-ini-per   like ano-fiscal.ini-periodo no-undo.
def var i-fim-per   like ano-fiscal.fim-periodo no-undo.
def var i-est-per   as integer no-undo.
def var l-alterou   as logical init no no-undo.
def var c-datas_ini  as char no-undo extent 13.
def var c-datas_fim  as char no-undo extent 13.
def var d-conteudo   as date. 

def var b-alterou-data as logical.
def var c-data-ant as date.

def var rw-ano-fiscal  as rowid no-undo.
def var rw-ano-fiscal2 as rowid no-undo.

def var c-opcao as char no-undo.

def var b-status as logical init false.
def var c-conteudo2 as char.
def var c_ano_informado as char.
def var d-data-retorno as date.
def var i-ano-ant as integer.
def var l-permite as logical.
def var i-ano-anterior AS INTEGER NO-UNDO.

def buffer b-ano-fiscal     for ano-fiscal.
def buffer b-ano-fiscal-aux for ano-fiscal.
def buffer b-ano            for ano-fiscal.

{utp/ut-glob.i}

/* Validaá∆o Ano Fiscal X Fechamento Estoque */
{cep/ceapi013.i}

/*************Multiplanta********************/
def var i-tipo-movto as integer no-undo.
{cdp/cd7300.i1}

{mcinc/mcapi276.i}
def temp-table tt-dados-env-SMC     like tt-dados-env.
def temp-table tt-replica-msg-SMC   like tt-replica-msg.
def temp-table tt-control-env-SMC   like tt-control-env.
def temp-table tt-integracao-SMC    like tt-integracao.

/************Fim*****************************/

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
&Scoped-define EXTERNAL-TABLES ano-fiscal
&Scoped-define FIRST-EXTERNAL-TABLE ano-fiscal


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ano-fiscal.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ano-fiscal.num-periodos ~
ano-fiscal.ini-periodo[1] ano-fiscal.fim-periodo[1] ~
ano-fiscal.fim-periodo[2] ano-fiscal.fim-periodo[3] ~
ano-fiscal.fim-periodo[4] ano-fiscal.fim-periodo[5] ~
ano-fiscal.fim-periodo[6] ano-fiscal.fim-periodo[7] ~
ano-fiscal.fim-periodo[8] ano-fiscal.fim-periodo[9] ~
ano-fiscal.fim-periodo[10] ano-fiscal.fim-periodo[11] ~
ano-fiscal.fim-periodo[12] ano-fiscal.fim-periodo[13] 
&Scoped-define ENABLED-TABLES ano-fiscal
&Scoped-define FIRST-ENABLED-TABLE ano-fiscal
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS ano-fiscal.ano-fiscal ~
ano-fiscal.num-periodos ano-fiscal.ini-periodo[1] ano-fiscal.fim-periodo[1] ~
ano-fiscal.ini-periodo[2] ano-fiscal.fim-periodo[2] ~
ano-fiscal.ini-periodo[3] ano-fiscal.fim-periodo[3] ~
ano-fiscal.ini-periodo[4] ano-fiscal.fim-periodo[4] ~
ano-fiscal.ini-periodo[5] ano-fiscal.fim-periodo[5] ~
ano-fiscal.ini-periodo[6] ano-fiscal.fim-periodo[6] ~
ano-fiscal.ini-periodo[7] ano-fiscal.fim-periodo[7] ~
ano-fiscal.ini-periodo[8] ano-fiscal.fim-periodo[8] ~
ano-fiscal.ini-periodo[9] ano-fiscal.fim-periodo[9] ~
ano-fiscal.ini-periodo[10] ano-fiscal.fim-periodo[10] ~
ano-fiscal.ini-periodo[11] ano-fiscal.fim-periodo[11] ~
ano-fiscal.ini-periodo[12] ano-fiscal.fim-periodo[12] ~
ano-fiscal.ini-periodo[13] ano-fiscal.fim-periodo[13] 
&Scoped-define DISPLAYED-TABLES ano-fiscal
&Scoped-define FIRST-DISPLAYED-TABLE ano-fiscal
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 COMBO-BOX-1 FILL-IN-2 FILL-IN-3 ~
COMBO-BOX-2 COMBO-BOX-3 COMBO-BOX-4 COMBO-BOX-5 COMBO-BOX-6 COMBO-BOX-7 ~
COMBO-BOX-8 COMBO-BOX-9 COMBO-BOX-10 COMBO-BOX-11 COMBO-BOX-12 COMBO-BOX-13 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS ano-fiscal.ano-fiscal ~
ano-fiscal.ini-periodo[1] ano-fiscal.fim-periodo[1] COMBO-BOX-1 COMBO-BOX-2 ~
COMBO-BOX-3 COMBO-BOX-4 COMBO-BOX-5 COMBO-BOX-6 COMBO-BOX-7 COMBO-BOX-8 ~
COMBO-BOX-9 COMBO-BOX-10 COMBO-BOX-11 COMBO-BOX-12 COMBO-BOX-13 
&Scoped-define ADM-ASSIGN-FIELDS ano-fiscal.ano-fiscal ~
ano-fiscal.ini-periodo[1] ano-fiscal.fim-periodo[1] COMBO-BOX-1 ~
ano-fiscal.ini-periodo[2] COMBO-BOX-2 ano-fiscal.ini-periodo[3] COMBO-BOX-3 ~
ano-fiscal.ini-periodo[4] COMBO-BOX-4 ano-fiscal.ini-periodo[5] COMBO-BOX-5 ~
ano-fiscal.ini-periodo[6] COMBO-BOX-6 ano-fiscal.ini-periodo[7] COMBO-BOX-7 ~
ano-fiscal.ini-periodo[8] COMBO-BOX-8 ano-fiscal.ini-periodo[9] COMBO-BOX-9 ~
ano-fiscal.ini-periodo[10] COMBO-BOX-10 ano-fiscal.ini-periodo[11] ~
COMBO-BOX-11 ano-fiscal.ini-periodo[12] COMBO-BOX-12 ~
ano-fiscal.ini-periodo[13] COMBO-BOX-13 
&Scoped-define ADM-MODIFY-FIELDS ano-fiscal.fim-periodo[1] COMBO-BOX-1 ~
COMBO-BOX-2 ano-fiscal.fim-periodo[3] COMBO-BOX-3 ano-fiscal.fim-periodo[4] ~
COMBO-BOX-4 ano-fiscal.fim-periodo[5] COMBO-BOX-5 ano-fiscal.fim-periodo[6] ~
COMBO-BOX-6 ano-fiscal.fim-periodo[7] COMBO-BOX-7 ano-fiscal.fim-periodo[8] ~
COMBO-BOX-8 ano-fiscal.fim-periodo[9] COMBO-BOX-9 ~
ano-fiscal.fim-periodo[10] COMBO-BOX-10 ano-fiscal.fim-periodo[11] ~
COMBO-BOX-11 ano-fiscal.fim-periodo[12] COMBO-BOX-12 ~
ano-fiscal.fim-periodo[13] COMBO-BOX-13 

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
DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24.57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-10 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24.57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-11 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24.57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-12 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24.57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-13 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24.57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24.57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24.57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24.57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24.57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-6 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24.57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-7 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24.57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-8 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24.57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-9 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24.57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15.43 BY .63 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15.43 BY .63 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 25.72 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 20.29 BY 13.79.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 20.29 BY 13.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28.57 BY 13.71.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.21.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.43 BY 14.21.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ano-fiscal.ano-fiscal AT ROW 1.17 COL 26.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     ano-fiscal.num-periodos AT ROW 1.17 COL 64.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     ano-fiscal.ini-periodo[1] AT ROW 3.17 COL 4.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ano-fiscal.fim-periodo[1] AT ROW 3.17 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     FILL-IN-1 AT ROW 2.54 COL 1.86 COLON-ALIGNED NO-LABEL
     COMBO-BOX-1 AT ROW 3.17 COL 55.29 NO-LABEL
     ano-fiscal.ini-periodo[2] AT ROW 4.17 COL 4.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     FILL-IN-2 AT ROW 2.54 COL 24.14 COLON-ALIGNED NO-LABEL
     ano-fiscal.fim-periodo[2] AT ROW 4.17 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     FILL-IN-3 AT ROW 2.54 COL 53.29 COLON-ALIGNED NO-LABEL
     COMBO-BOX-2 AT ROW 4.17 COL 53.29 COLON-ALIGNED NO-LABEL
     ano-fiscal.ini-periodo[3] AT ROW 5.17 COL 4.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ano-fiscal.fim-periodo[3] AT ROW 5.17 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     COMBO-BOX-3 AT ROW 5.17 COL 53.29 COLON-ALIGNED NO-LABEL
     ano-fiscal.ini-periodo[4] AT ROW 6.17 COL 4.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ano-fiscal.fim-periodo[4] AT ROW 6.17 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     COMBO-BOX-4 AT ROW 6.17 COL 53.29 COLON-ALIGNED NO-LABEL
     ano-fiscal.ini-periodo[5] AT ROW 7.17 COL 4.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ano-fiscal.fim-periodo[5] AT ROW 7.17 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     COMBO-BOX-5 AT ROW 7.17 COL 53.29 COLON-ALIGNED NO-LABEL
     ano-fiscal.ini-periodo[6] AT ROW 8.17 COL 4.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ano-fiscal.fim-periodo[6] AT ROW 8.17 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     COMBO-BOX-6 AT ROW 8.17 COL 53.29 COLON-ALIGNED NO-LABEL
     ano-fiscal.ini-periodo[7] AT ROW 9.17 COL 4.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ano-fiscal.fim-periodo[7] AT ROW 9.17 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     COMBO-BOX-7 AT ROW 9.17 COL 53.29 COLON-ALIGNED NO-LABEL
     ano-fiscal.ini-periodo[8] AT ROW 10.17 COL 4.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ano-fiscal.fim-periodo[8] AT ROW 10.17 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     COMBO-BOX-8 AT ROW 10.17 COL 53.29 COLON-ALIGNED NO-LABEL
     ano-fiscal.ini-periodo[9] AT ROW 11.17 COL 4.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ano-fiscal.fim-periodo[9] AT ROW 11.17 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     COMBO-BOX-9 AT ROW 11.17 COL 53.29 COLON-ALIGNED NO-LABEL
     ano-fiscal.ini-periodo[10] AT ROW 12.17 COL 4.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ano-fiscal.fim-periodo[10] AT ROW 12.17 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     COMBO-BOX-10 AT ROW 12.17 COL 53.29 COLON-ALIGNED NO-LABEL
     ano-fiscal.ini-periodo[11] AT ROW 13.17 COL 4.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ano-fiscal.fim-periodo[11] AT ROW 13.17 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     COMBO-BOX-11 AT ROW 13.17 COL 53.29 COLON-ALIGNED NO-LABEL
     ano-fiscal.ini-periodo[12] AT ROW 14.17 COL 4.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ano-fiscal.fim-periodo[12] AT ROW 14.17 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     COMBO-BOX-12 AT ROW 14.17 COL 53.29 COLON-ALIGNED NO-LABEL
     ano-fiscal.ini-periodo[13] AT ROW 15.17 COL 4.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY 1
     ano-fiscal.fim-periodo[13] AT ROW 15.17 COL 27.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.86 BY 1
     COMBO-BOX-13 AT ROW 15.17 COL 53.29 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 2.71 COL 2.72
     RECT-2 AT ROW 2.71 COL 25.57
     RECT-3 AT ROW 2.71 COL 53.57
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.33 COL 1.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.ano-fiscal
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
         HEIGHT             = 15.83
         WIDTH              = 89.29.
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
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 15.83
       FRAME f-main:WIDTH            = 89.29.

/* SETTINGS FOR FILL-IN ano-fiscal.ano-fiscal IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-1 IN FRAME f-main
   NO-ENABLE ALIGN-L 1 2 3                                              */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-10 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-11 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-12 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-13 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-2 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-3 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-4 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-5 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-6 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-7 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-8 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-9 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ano-fiscal.fim-periodo[10] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN ano-fiscal.fim-periodo[11] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN ano-fiscal.fim-periodo[12] IN FRAME f-main
   3 EXP-LABEL                                                          */
/* SETTINGS FOR FILL-IN ano-fiscal.fim-periodo[13] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN ano-fiscal.fim-periodo[1] IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN ano-fiscal.fim-periodo[3] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN ano-fiscal.fim-periodo[4] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN ano-fiscal.fim-periodo[5] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN ano-fiscal.fim-periodo[6] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN ano-fiscal.fim-periodo[7] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN ano-fiscal.fim-periodo[8] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN ano-fiscal.fim-periodo[9] IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN ano-fiscal.ini-periodo[10] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ano-fiscal.ini-periodo[11] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ano-fiscal.ini-periodo[12] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ano-fiscal.ini-periodo[13] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ano-fiscal.ini-periodo[1] IN FRAME f-main
   1 2                                                                  */
/* SETTINGS FOR FILL-IN ano-fiscal.ini-periodo[2] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ano-fiscal.ini-periodo[3] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ano-fiscal.ini-periodo[4] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ano-fiscal.ini-periodo[5] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ano-fiscal.ini-periodo[6] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ano-fiscal.ini-periodo[7] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ano-fiscal.ini-periodo[8] IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ano-fiscal.ini-periodo[9] IN FRAME f-main
   NO-ENABLE 2                                                          */
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

&Scoped-define SELF-NAME ano-fiscal.ano-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.ano-fiscal V-table-Win
ON ENTRY OF ano-fiscal.ano-fiscal IN FRAME f-main /* Ano Fiscal */
DO:
  assign c_ano_informado = ano-fiscal.ano-fiscal:screen-value.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.ano-fiscal V-table-Win
ON LEAVE OF ano-fiscal.ano-fiscal IN FRAME f-main /* Ano Fiscal */
DO:
  assign rw-ano-fiscal = rowid(ano-fiscal).

  find first b-ano-fiscal-aux no-lock no-error.

  if (year(date(ano-fiscal.ini-periodo[1]:screen-value)) <> integer(ano-fiscal.ano-fiscal:screen-value) - 1 
  or (year(date(mgadm.ano-fiscal.ini-periodo[1]:screen-value))  = year(c-data-ant) - 1
  and day(date(mgadm.ano-fiscal.ini-periodo[1]:screen-value))   = 01
  and month(date(mgadm.ano-fiscal.ini-periodo[1]:screen-value)) = 01))
  or not avail  b-ano-fiscal-aux then do:
    if ano-fiscal.ano-fiscal:screen-value <> c_ano_informado then assign b-alterou-data = true.
    assign ano-fiscal.ini-periodo[1]:screen-value = string(date(
                                                    integer( substr( ano-fiscal.ini-periodo[1]:screen-value, 04, 02 ) ) , 
                                                    integer( substr( ano-fiscal.ini-periodo[1]:screen-value, 01, 02 ) ) ,
                                                    input ano-fiscal.ano-fiscal)) no-error.
  end.    
  apply "leave" to ano-fiscal.num-periodos in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-10 V-table-Win
ON ENTRY OF COMBO-BOX-10 IN FRAME f-main
DO:
    apply 'entry' to ano-fiscal.fim-periodo[10].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-11 V-table-Win
ON ENTRY OF COMBO-BOX-11 IN FRAME f-main
DO:
    apply 'entry' to ano-fiscal.fim-periodo[11].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-12 V-table-Win
ON ENTRY OF COMBO-BOX-12 IN FRAME f-main
DO:
    apply 'entry' to ano-fiscal.fim-periodo[12].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-2 V-table-Win
ON ENTRY OF COMBO-BOX-2 IN FRAME f-main
DO:
    apply 'entry' to ano-fiscal.fim-periodo[2].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-3 V-table-Win
ON ENTRY OF COMBO-BOX-3 IN FRAME f-main
DO:
    apply 'entry' to ano-fiscal.fim-periodo[3].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-4 V-table-Win
ON ENTRY OF COMBO-BOX-4 IN FRAME f-main
DO:
    apply 'entry' to ano-fiscal.fim-periodo[4].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-5 V-table-Win
ON ENTRY OF COMBO-BOX-5 IN FRAME f-main
DO:
    apply 'entry' to ano-fiscal.fim-periodo[5].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-6 V-table-Win
ON ENTRY OF COMBO-BOX-6 IN FRAME f-main
DO:
    apply 'entry' to ano-fiscal.fim-periodo[6].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-7 V-table-Win
ON ENTRY OF COMBO-BOX-7 IN FRAME f-main
DO:
    apply 'entry' to ano-fiscal.fim-periodo[7].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-8 V-table-Win
ON ENTRY OF COMBO-BOX-8 IN FRAME f-main
DO:
    apply 'entry' to ano-fiscal.fim-periodo[8].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-9 V-table-Win
ON ENTRY OF COMBO-BOX-9 IN FRAME f-main
DO:
    apply 'entry' to ano-fiscal.fim-periodo[9].
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ano-fiscal.fim-periodo[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[10] V-table-Win
ON ENTRY OF ano-fiscal.fim-periodo[10] IN FRAME f-main /* Fim Per°odo[10] */
DO:
  if not b-status then do:
     assign c-conteudo2 = mgadm.ano-fiscal.fim-periodo[10]:screen-value.
  end.

 if input ano-fiscal.num-periodos <= 9 then
  do:
    assign c-aux = string(input ano-fiscal.num-periodos).
    run utp/ut-msgs.p (input "show", input 165 , input c-aux). 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[10] V-table-Win
ON LEAVE OF ano-fiscal.fim-periodo[10] IN FRAME f-main /* Fim Per°odo[10] */
DO:
    assign d-conteudo = input frame {&FRAME-NAME} mgadm.ano-fiscal.fim-periodo[10] no-error.
    if  error-status:get-number(1) <> 0 then do:
        run utp/ut-msgs.p (input "show", 
                           input 173, /*Data Invalida.*/
                           mgadm.ano-fiscal.fim-periodo[10]:screen-value ).
        assign mgadm.ano-fiscal.fim-periodo[10]:screen-value = c-conteudo2.
        b-status = true.
        apply "entry" to mgadm.ano-fiscal.fim-periodo[10].
        return no-apply.
    end.
    else do:
        b-status = false.
        if mgadm.ano-fiscal.fim-periodo[10]:screen-value <> "" then do:
           IF LENGTH(mgadm.ano-fiscal.fim-periodo[10]:screen-value, "CHARACTER") <= 6 then
               assign mgadm.ano-fiscal.fim-periodo[10]:screen-value = mgadm.ano-fiscal.fim-periodo[10]:screen-value + 
                           mgadm.ano-fiscal.ano-fiscal:screen-value.
             if not input frame {&FRAME-NAME} ano-fiscal.num-periodos <= 10  then do:
                assign ano-fiscal.ini-periodo[11]:screen-value = 
                       string(input frame {&FRAME-NAME} ano-fiscal.fim-periodo[10] + 1, "99/99/9999").
             end.  
           If date( mgadm.ano-fiscal.fim-periodo[10]:screen-value ) >= 
              date( mgadm.ano-fiscal.fim-periodo[11]:screen-value ) or l-permite then do:
              d-data-retorno = date( mgadm.ano-fiscal.ini-periodo[11]:screen-value ).
              run pi-altera-data.
              assign mgadm.ano-fiscal.fim-periodo[11]:screen-value = string( d-data-retorno).
              apply "leave" to mgadm.ano-fiscal.fim-periodo[11].
           end.

          end.
    end.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ano-fiscal.fim-periodo[11]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[11] V-table-Win
ON ENTRY OF ano-fiscal.fim-periodo[11] IN FRAME f-main /* Fim Per°odo[11] */
DO:
  if not b-status then do:
     assign c-conteudo2 = mgadm.ano-fiscal.fim-periodo[11]:screen-value.
  end.


   if input ano-fiscal.num-periodos <= 10 then
  do:
    assign c-aux = string(input ano-fiscal.num-periodos).
    run utp/ut-msgs.p (input "show", input 165 , input c-aux). 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[11] V-table-Win
ON LEAVE OF ano-fiscal.fim-periodo[11] IN FRAME f-main /* Fim Per°odo[11] */
DO:
    assign d-conteudo = input frame {&FRAME-NAME} mgadm.ano-fiscal.fim-periodo[11] no-error.
    if  error-status:get-number(1) <> 0 then do:
        run utp/ut-msgs.p (input "show", 
                           input 173, /*Data Invalida.*/
                           mgadm.ano-fiscal.fim-periodo[11]:screen-value ).
        assign mgadm.ano-fiscal.fim-periodo[11]:screen-value = c-conteudo2.
        b-status = true.
        apply "entry" to mgadm.ano-fiscal.fim-periodo[11].
        return no-apply.
    end.
    else do:
        b-status = false.
        if mgadm.ano-fiscal.fim-periodo[11]:screen-value <> "" then do:
         IF LENGTH(mgadm.ano-fiscal.fim-periodo[11]:screen-value, "CHARACTER") <= 6 then
             assign mgadm.ano-fiscal.fim-periodo[11]:screen-value = mgadm.ano-fiscal.fim-periodo[11]:screen-value + 
                         mgadm.ano-fiscal.ano-fiscal:screen-value.
           if not input frame {&FRAME-NAME} ano-fiscal.num-periodos <= 11  then do:
              assign ano-fiscal.ini-periodo[12]:screen-value = 
                     string(input frame {&FRAME-NAME} ano-fiscal.fim-periodo[11] + 1, "99/99/9999").
           end.  
           If date( mgadm.ano-fiscal.fim-periodo[11]:screen-value ) >= 
              date( mgadm.ano-fiscal.fim-periodo[12]:screen-value ) or l-permite then do:
              d-data-retorno = date( mgadm.ano-fiscal.ini-periodo[12]:screen-value ).
              run pi-altera-data.
              assign mgadm.ano-fiscal.fim-periodo[12]:screen-value = string( d-data-retorno).
              apply "leave" to mgadm.ano-fiscal.fim-periodo[12].
           end.

        end.
     end.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ano-fiscal.fim-periodo[12]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[12] V-table-Win
ON ENTRY OF ano-fiscal.fim-periodo[12] IN FRAME f-main /* Fim Per°odo[12] */
DO:
  if not b-status then do:
     assign c-conteudo2 = mgadm.ano-fiscal.fim-periodo[12]:screen-value.
  end.

 enable ano-fiscal.fim-periodo[13] with frame {&frame-name}.
   If trim( mgadm.ano-fiscal.fim-periodo[13]:screen-value) = "/  /" or 
      mgadm.ano-fiscal.fim-periodo[13]:screen-value = "" then do:
      assign mgadm.ano-fiscal.fim-periodo[13]:screen-value = "".
      mgadm.ano-fiscal.fim-periodo[13]:bgcolor = 8.
   End.
   if input ano-fiscal.num-periodos <= 11 then
   do:
    assign c-aux = string(input ano-fiscal.num-periodos).
    run utp/ut-msgs.p (input "show", input 165 , input c-aux). 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[12] V-table-Win
ON LEAVE OF ano-fiscal.fim-periodo[12] IN FRAME f-main /* Fim Per°odo[12] */
DO:
    assign d-conteudo = input frame {&FRAME-NAME} mgadm.ano-fiscal.fim-periodo[12] no-error.
    if  error-status:get-number(1) <> 0 then do:
        run utp/ut-msgs.p (input "show", 
                           input 173, /*Data Invalida.*/
                           mgadm.ano-fiscal.fim-periodo[12]:screen-value ).
        assign mgadm.ano-fiscal.fim-periodo[12]:screen-value = c-conteudo2.
        b-status = true.
        apply "entry" to mgadm.ano-fiscal.fim-periodo[12].
        return no-apply.
    end.
    else do:
        b-status = false.
        if mgadm.ano-fiscal.fim-periodo[12]:screen-value <> "" then do:
           IF LENGTH(mgadm.ano-fiscal.fim-periodo[12]:screen-value, "CHARACTER") <= 6 then
              assign mgadm.ano-fiscal.fim-periodo[12]:screen-value = mgadm.ano-fiscal.fim-periodo[12]:screen-value + 
                         mgadm.ano-fiscal.ano-fiscal:screen-value.

           if not input frame {&FRAME-NAME} ano-fiscal.num-periodos <= 12  then do:
             if substr( ano-fiscal.fim-periodo[12]:screen-value, 01, 05 ) <> '31/12' then do:
                assign ano-fiscal.ini-periodo[13]:screen-value = 
                       string(input frame {&FRAME-NAME} ano-fiscal.fim-periodo[12] + 1, "99/99/9999").
                assign ano-fiscal.fim-periodo[13]:screen-value = '31/12/' + 
                          mgadm.ano-fiscal.ano-fiscal:screen-value.
                run pi_posiciona.
                mgadm.ano-fiscal.fim-periodo[13]:bgcolor = 15.
             end.
             Else do:
                disable ano-fiscal.fim-periodo[13] with frame {&frame-name}.
                ano-fiscal.ini-periodo[13]:screen-value = "".
                ano-fiscal.fim-periodo[13]:screen-value = "".
                mgadm.ano-fiscal.fim-periodo[13]:bgcolor = 8.
             end.
           end.
           Else do:
              disable ano-fiscal.fim-periodo[13] with frame {&frame-name}.
              ano-fiscal.ini-periodo[13]:screen-value = "".
              ano-fiscal.fim-periodo[13]:screen-value = "".
              mgadm.ano-fiscal.fim-periodo[13]:bgcolor = 8.
           end.
           If date( mgadm.ano-fiscal.fim-periodo[12]:screen-value ) >= 
              date( mgadm.ano-fiscal.fim-periodo[13]:screen-value ) or l-permite then do:
              d-data-retorno = date( mgadm.ano-fiscal.ini-periodo[13]:screen-value ).
              if d-data-retorno <> ? then 
                  run pi-altera-data.
              assign mgadm.ano-fiscal.fim-periodo[13]:screen-value = string( d-data-retorno).
           end.
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ano-fiscal.fim-periodo[13]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[13] V-table-Win
ON ENTRY OF ano-fiscal.fim-periodo[13] IN FRAME f-main /* Fim Per°odo[13] */
DO:
  if not b-status then do:
     assign c-conteudo2 = mgadm.ano-fiscal.fim-periodo[13]:screen-value.
  end.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[13] V-table-Win
ON LEAVE OF ano-fiscal.fim-periodo[13] IN FRAME f-main /* Fim Per°odo[13] */
DO:
    assign d-conteudo = input frame {&FRAME-NAME} mgadm.ano-fiscal.fim-periodo[13] no-error.
    if  error-status:get-number(1) <> 0 then do:
        run utp/ut-msgs.p (input "show", 
                           input 173, /*Data Invalida.*/
                           mgadm.ano-fiscal.fim-periodo[13]:screen-value ).
        assign mgadm.ano-fiscal.fim-periodo[13]:screen-value = c-conteudo2.
        b-status = true.
        apply "entry" to mgadm.ano-fiscal.fim-periodo[13].
        return no-apply.
    end.
    else do:
        b-status = false.
        if mgadm.ano-fiscal.fim-periodo[13]:screen-value <> "" then do:
         IF LENGTH(mgadm.ano-fiscal.fim-periodo[13]:screen-value, "CHARACTER") = 6 then
            assign mgadm.ano-fiscal.fim-periodo[13]:screen-value = mgadm.ano-fiscal.fim-periodo[13]:screen-value + 
                       mgadm.ano-fiscal.ano-fiscal:screen-value.
        End.
    end.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ano-fiscal.fim-periodo[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[1] V-table-Win
ON ENTRY OF ano-fiscal.fim-periodo[1] IN FRAME f-main /* Fim Per°odo[1] */
DO:
  if not b-status then do:
     assign c-conteudo2 = mgadm.ano-fiscal.fim-periodo[1]:screen-value.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[1] V-table-Win
ON LEAVE OF ano-fiscal.fim-periodo[1] IN FRAME f-main /* Fim Per°odo[1] */
DO:
    assign d-conteudo = input frame {&FRAME-NAME} mgadm.ano-fiscal.fim-periodo[1] no-error.
    if  error-status:get-number(1) <> 0 then do:
        run utp/ut-msgs.p (input "show", 
                           input 173, /*Data Invalida.*/
                           mgadm.ano-fiscal.fim-periodo[1]:screen-value ).
        assign mgadm.ano-fiscal.fim-periodo[1]:screen-value = c-conteudo2.
        b-status = true.
        apply "entry" to mgadm.ano-fiscal.fim-periodo[1].
        return no-apply.
    end.
    else do:
      b-status = false.
      if mgadm.ano-fiscal.fim-periodo[1]:screen-value <> "" then do:
          if LENGTH(mgadm.ano-fiscal.fim-periodo[1]:screen-value, "CHARACTER") <= 6 then
              assign mgadm.ano-fiscal.fim-periodo[1]:screen-value = mgadm.ano-fiscal.fim-periodo[1]:screen-value + 
                          mgadm.ano-fiscal.ano-fiscal:screen-value.
          if not input frame {&FRAME-NAME} ano-fiscal.num-periodos = 1  then do:
               assign ano-fiscal.ini-periodo[2]:screen-value = 
                      string(input frame {&FRAME-NAME} ano-fiscal.fim-periodo[1] + 1, "99/99/9999").
          end.
          If date( mgadm.ano-fiscal.fim-periodo[1]:screen-value ) >= 
             date( mgadm.ano-fiscal.fim-periodo[2]:screen-value ) or l-permite then do:
             d-data-retorno = date( mgadm.ano-fiscal.ini-periodo[2]:screen-value ).
             run pi-altera-data.
             assign mgadm.ano-fiscal.fim-periodo[2]:screen-value = string( d-data-retorno).
             apply "leave" to mgadm.ano-fiscal.fim-periodo[2].
          end.
      end.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ano-fiscal.fim-periodo[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[2] V-table-Win
ON ENTRY OF ano-fiscal.fim-periodo[2] IN FRAME f-main /* Fim Per°odo[2] */
DO:
  if not b-status then do:
     assign c-conteudo2 = mgadm.ano-fiscal.fim-periodo[2]:screen-value.
  end.
  if input ano-fiscal.num-periodos = 1 then
  do:
    assign c-aux = string(input ano-fiscal.num-periodos).
    run utp/ut-msgs.p (input "show", input 165 , input c-aux). 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[2] V-table-Win
ON LEAVE OF ano-fiscal.fim-periodo[2] IN FRAME f-main /* Fim Per°odo[2] */
DO:
    assign d-conteudo = input frame {&FRAME-NAME} mgadm.ano-fiscal.fim-periodo[2] no-error.
    if  error-status:get-number(1) <> 0 then do:
        run utp/ut-msgs.p (input "show", 
                           input 173, /*Data Invalida.*/
                           mgadm.ano-fiscal.fim-periodo[2]:screen-value ).
        assign mgadm.ano-fiscal.fim-periodo[2]:screen-value = c-conteudo2.
        b-status = true.
        apply "entry" to mgadm.ano-fiscal.fim-periodo[2].
        return no-apply.
    end.
    else do:
        b-status = false.
        if mgadm.ano-fiscal.fim-periodo[2]:screen-value <> "" then do:
           IF LENGTH(mgadm.ano-fiscal.fim-periodo[2]:screen-value, "CHARACTER") <= 6 then
              assign mgadm.ano-fiscal.fim-periodo[2]:screen-value = mgadm.ano-fiscal.fim-periodo[2]:screen-value + 
                         mgadm.ano-fiscal.ano-fiscal:screen-value.

           if not input frame {&FRAME-NAME} ano-fiscal.num-periodos <= 2  then do:
              assign mgadm.ano-fiscal.ini-periodo[3]:screen-value = 
                     string(input frame {&FRAME-NAME} ano-fiscal.fim-periodo[2] + 1, "99/99/9999").
           end.  
           If date( mgadm.ano-fiscal.fim-periodo[2]:screen-value ) >= 
              date( mgadm.ano-fiscal.fim-periodo[3]:screen-value ) or l-permite then do:
              d-data-retorno = date( mgadm.ano-fiscal.ini-periodo[3]:screen-value ).
              run pi-altera-data.
              assign mgadm.ano-fiscal.fim-periodo[3]:screen-value = string( d-data-retorno).
              apply "leave" to mgadm.ano-fiscal.fim-periodo[3].
           end.
        end.
    End.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ano-fiscal.fim-periodo[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[3] V-table-Win
ON ENTRY OF ano-fiscal.fim-periodo[3] IN FRAME f-main /* Fim Per°odo[3] */
DO:
  if not b-status then do:
     assign c-conteudo2 = mgadm.ano-fiscal.fim-periodo[3]:screen-value.
  end.
  if input ano-fiscal.num-periodos <= 2 then
  do:
    assign c-aux = string(input ano-fiscal.num-periodos).
    run utp/ut-msgs.p (input "show", input 165 , input c-aux). 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[3] V-table-Win
ON LEAVE OF ano-fiscal.fim-periodo[3] IN FRAME f-main /* Fim Per°odo[3] */
DO:
    assign d-conteudo = input frame {&FRAME-NAME} mgadm.ano-fiscal.fim-periodo[3] no-error.
    if  error-status:get-number(1) <> 0 then do:
        run utp/ut-msgs.p (input "show", 
                           input 173, /*Data Invalida.*/
                           mgadm.ano-fiscal.fim-periodo[3]:screen-value ).
        assign mgadm.ano-fiscal.fim-periodo[3]:screen-value = c-conteudo2.
        b-status = true.
        apply "entry" to mgadm.ano-fiscal.fim-periodo[3].
        return no-apply.
    end.
    else do:
        b-status = false.
        if mgadm.ano-fiscal.fim-periodo[3]:screen-value <> "" then do:
         IF LENGTH(mgadm.ano-fiscal.fim-periodo[3]:screen-value, "CHARACTER") <= 6 then
             assign mgadm.ano-fiscal.fim-periodo[3]:screen-value = mgadm.ano-fiscal.fim-periodo[3]:screen-value + 
                         mgadm.ano-fiscal.ano-fiscal:screen-value.
           if not input frame {&FRAME-NAME} ano-fiscal.num-periodos <= 3  then do:
              assign ano-fiscal.ini-periodo[4]:screen-value = 
                     string(input frame {&FRAME-NAME} ano-fiscal.fim-periodo[3] + 1, "99/99/9999").
           end.  
           If date( mgadm.ano-fiscal.fim-periodo[3]:screen-value ) >= 
              date( mgadm.ano-fiscal.fim-periodo[4]:screen-value ) or l-permite then do:
              d-data-retorno = date( mgadm.ano-fiscal.ini-periodo[4]:screen-value ).
              run pi-altera-data.
              assign mgadm.ano-fiscal.fim-periodo[4]:screen-value = string( d-data-retorno).
              apply "leave" to mgadm.ano-fiscal.fim-periodo[4].

           end.
        end.
    End.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ano-fiscal.fim-periodo[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[4] V-table-Win
ON ENTRY OF ano-fiscal.fim-periodo[4] IN FRAME f-main /* Fim Per°odo[4] */
DO:
  if not b-status then do:
     assign c-conteudo2 = mgadm.ano-fiscal.fim-periodo[4]:screen-value.
  end.


   if input ano-fiscal.num-periodos <= 3 then
  do:
    assign c-aux = string(input ano-fiscal.num-periodos).
    run utp/ut-msgs.p (input "show", input 165 , input c-aux). 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[4] V-table-Win
ON LEAVE OF ano-fiscal.fim-periodo[4] IN FRAME f-main /* Fim Per°odo[4] */
DO:
    assign d-conteudo = input frame {&FRAME-NAME} mgadm.ano-fiscal.fim-periodo[4] no-error.
    if  error-status:get-number(1) <> 0 then do:
        run utp/ut-msgs.p (input "show", 
                           input 173, /*Data Invalida.*/
                           mgadm.ano-fiscal.fim-periodo[4]:screen-value ).
        assign mgadm.ano-fiscal.fim-periodo[4]:screen-value = c-conteudo2.
        b-status = true.
        apply "entry" to mgadm.ano-fiscal.fim-periodo[4].
        return no-apply.
    end.
    else do:
        b-status = false.
        if mgadm.ano-fiscal.fim-periodo[4]:screen-value <> "" then do:
           IF LENGTH(mgadm.ano-fiscal.fim-periodo[4]:screen-value, "CHARACTER") <= 6 then
               assign mgadm.ano-fiscal.fim-periodo[4]:screen-value = mgadm.ano-fiscal.fim-periodo[4]:screen-value + 
                           mgadm.ano-fiscal.ano-fiscal:screen-value.
             if not input frame {&FRAME-NAME} ano-fiscal.num-periodos <= 4  then do:
                assign ano-fiscal.ini-periodo[5]:screen-value = 
                       string(input frame {&FRAME-NAME} ano-fiscal.fim-periodo[4] + 1, "99/99/9999").
             end.  
           If date( mgadm.ano-fiscal.fim-periodo[4]:screen-value ) >= 
              date( mgadm.ano-fiscal.fim-periodo[5]:screen-value ) or l-permite then do:
              d-data-retorno = date( mgadm.ano-fiscal.ini-periodo[5]:screen-value ).
              run pi-altera-data.
              assign mgadm.ano-fiscal.fim-periodo[5]:screen-value = string( d-data-retorno).
              apply "leave" to mgadm.ano-fiscal.fim-periodo[5].
           end.
        end.
    End.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ano-fiscal.fim-periodo[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[5] V-table-Win
ON ENTRY OF ano-fiscal.fim-periodo[5] IN FRAME f-main /* Fim Per°odo[5] */
DO:
  if not b-status then do:
     assign c-conteudo2 = mgadm.ano-fiscal.fim-periodo[5]:screen-value.
  end.


   if input ano-fiscal.num-periodos <= 4 then
  do:
    assign c-aux = string(input ano-fiscal.num-periodos).
    run utp/ut-msgs.p (input "show", input 165 , input c-aux). 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[5] V-table-Win
ON LEAVE OF ano-fiscal.fim-periodo[5] IN FRAME f-main /* Fim Per°odo[5] */
DO:
    assign d-conteudo = input frame {&FRAME-NAME} mgadm.ano-fiscal.fim-periodo[5] no-error.
    if  error-status:get-number(1) <> 0 then do:
        run utp/ut-msgs.p (input "show", 
                           input 173, /*Data Invalida.*/
                           mgadm.ano-fiscal.fim-periodo[5]:screen-value ).
        assign mgadm.ano-fiscal.fim-periodo[5]:screen-value = c-conteudo2.
        b-status = true.
        apply "entry" to mgadm.ano-fiscal.fim-periodo[5].
        return no-apply.
    end.
    else do:
        b-status = false.
        if mgadm.ano-fiscal.fim-periodo[5]:screen-value <> "" then do:
         IF LENGTH(mgadm.ano-fiscal.fim-periodo[5]:screen-value, "CHARACTER") <= 6 then
             assign mgadm.ano-fiscal.fim-periodo[5]:screen-value = mgadm.ano-fiscal.fim-periodo[5]:screen-value + 
                         mgadm.ano-fiscal.ano-fiscal:screen-value.
           if not input frame {&FRAME-NAME} ano-fiscal.num-periodos <= 5  then do:
              assign ano-fiscal.ini-periodo[6]:screen-value = 
                     string(input frame {&FRAME-NAME} ano-fiscal.fim-periodo[5] + 1, "99/99/9999").
           end.  
           If date( mgadm.ano-fiscal.fim-periodo[5]:screen-value ) >= 
              date( mgadm.ano-fiscal.fim-periodo[6]:screen-value ) or l-permite then do:
              d-data-retorno = date( mgadm.ano-fiscal.ini-periodo[6]:screen-value ).
              run pi-altera-data.
              assign mgadm.ano-fiscal.fim-periodo[6]:screen-value = string( d-data-retorno).
              apply "leave" to mgadm.ano-fiscal.fim-periodo[6].
           end.

        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ano-fiscal.fim-periodo[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[6] V-table-Win
ON ENTRY OF ano-fiscal.fim-periodo[6] IN FRAME f-main /* Fim Per°odo[6] */
DO:
  if not b-status then do:
     assign c-conteudo2 = mgadm.ano-fiscal.fim-periodo[6]:screen-value.
  end.


   if input ano-fiscal.num-periodos <= 5 then
  do:
    assign c-aux = string(input ano-fiscal.num-periodos).
    run utp/ut-msgs.p (input "show", input 165 , input c-aux). 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[6] V-table-Win
ON LEAVE OF ano-fiscal.fim-periodo[6] IN FRAME f-main /* Fim Per°odo[6] */
DO:
    assign d-conteudo = input frame {&FRAME-NAME} mgadm.ano-fiscal.fim-periodo[6] no-error.
    if  error-status:get-number(1) <> 0 then do:
        run utp/ut-msgs.p (input "show", 
                           input 173, /*Data Invalida.*/
                           mgadm.ano-fiscal.fim-periodo[6]:screen-value ).
        assign mgadm.ano-fiscal.fim-periodo[6]:screen-value = c-conteudo2.
        b-status = true.
        apply "entry" to mgadm.ano-fiscal.fim-periodo[6].
        return no-apply.
    end.
    else do:
        b-status = false.
        if mgadm.ano-fiscal.fim-periodo[6]:screen-value <> "" then do:
           IF LENGTH(mgadm.ano-fiscal.fim-periodo[6]:screen-value, "CHARACTER") <= 6 then
               assign mgadm.ano-fiscal.fim-periodo[6]:screen-value = mgadm.ano-fiscal.fim-periodo[6]:screen-value + 
                           mgadm.ano-fiscal.ano-fiscal:screen-value.
             if not input frame {&FRAME-NAME} ano-fiscal.num-periodos <= 6  then do:
                assign ano-fiscal.ini-periodo[7]:screen-value = 
                       string(input frame {&FRAME-NAME} ano-fiscal.fim-periodo[6] + 1, "99/99/9999").
             end.  
           If date( mgadm.ano-fiscal.fim-periodo[6]:screen-value ) >= 
              date( mgadm.ano-fiscal.fim-periodo[7]:screen-value ) or l-permite then do:
              d-data-retorno = date( mgadm.ano-fiscal.ini-periodo[7]:screen-value ).
              run pi-altera-data.
              assign mgadm.ano-fiscal.fim-periodo[7]:screen-value = string( d-data-retorno).
              apply "leave" to mgadm.ano-fiscal.fim-periodo[7].
           end.
          end.
    end.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ano-fiscal.fim-periodo[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[7] V-table-Win
ON ENTRY OF ano-fiscal.fim-periodo[7] IN FRAME f-main /* Fim Per°odo[7] */
DO:
  if not b-status then do:
     assign c-conteudo2 = mgadm.ano-fiscal.fim-periodo[7]:screen-value.
  end.

   if input ano-fiscal.num-periodos <= 6 then
  do:
    assign c-aux = string(input ano-fiscal.num-periodos).
    run utp/ut-msgs.p (input "show", input 165 , input c-aux). 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[7] V-table-Win
ON LEAVE OF ano-fiscal.fim-periodo[7] IN FRAME f-main /* Fim Per°odo[7] */
DO:
    assign d-conteudo = input frame {&FRAME-NAME} mgadm.ano-fiscal.fim-periodo[7] no-error.
    if  error-status:get-number(1) <> 0 then do:
        run utp/ut-msgs.p (input "show", 
                           input 173, /*Data Invalida.*/
                           mgadm.ano-fiscal.fim-periodo[7]:screen-value ).
        assign mgadm.ano-fiscal.fim-periodo[7]:screen-value = c-conteudo2.
        b-status = true.
        apply "entry" to mgadm.ano-fiscal.fim-periodo[7].
        return no-apply.
    end.
    else do:
        b-status = false.
        if mgadm.ano-fiscal.fim-periodo[7]:screen-value <> "" then do:
         IF LENGTH(mgadm.ano-fiscal.fim-periodo[7]:screen-value, "CHARACTER") <= 6 then
             assign mgadm.ano-fiscal.fim-periodo[7]:screen-value = mgadm.ano-fiscal.fim-periodo[7]:screen-value + 
                         mgadm.ano-fiscal.ano-fiscal:screen-value.
           if not input frame {&FRAME-NAME} ano-fiscal.num-periodos <= 7  then do:
              assign ano-fiscal.ini-periodo[8]:screen-value = 
                     string(input frame {&FRAME-NAME} ano-fiscal.fim-periodo[7] + 1, "99/99/9999").
           end.  
           If date( mgadm.ano-fiscal.fim-periodo[7]:screen-value ) >= 
              date( mgadm.ano-fiscal.fim-periodo[8]:screen-value ) or l-permite then do:
              d-data-retorno = date( mgadm.ano-fiscal.ini-periodo[8]:screen-value ).
              run pi-altera-data.
              assign mgadm.ano-fiscal.fim-periodo[8]:screen-value = string( d-data-retorno).
              apply "leave" to mgadm.ano-fiscal.fim-periodo[8].
           end.

        end.
    end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ano-fiscal.fim-periodo[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[8] V-table-Win
ON ENTRY OF ano-fiscal.fim-periodo[8] IN FRAME f-main /* Fim Per°odo[8] */
DO:
  if not b-status then do:
     assign c-conteudo2 = mgadm.ano-fiscal.fim-periodo[8]:screen-value.
  end.


   if input ano-fiscal.num-periodos <= 7 then
  do:
    assign c-aux = string(input ano-fiscal.num-periodos).
    run utp/ut-msgs.p (input "show", input 165 , input c-aux). 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[8] V-table-Win
ON LEAVE OF ano-fiscal.fim-periodo[8] IN FRAME f-main /* Fim Per°odo[8] */
DO:
    assign d-conteudo = input frame {&FRAME-NAME} mgadm.ano-fiscal.fim-periodo[8] no-error.
    if  error-status:get-number(1) <> 0 then do:
        run utp/ut-msgs.p (input "show", 
                           input 173, /*Data Invalida.*/
                           mgadm.ano-fiscal.fim-periodo[8]:screen-value ).
        assign mgadm.ano-fiscal.fim-periodo[8]:screen-value = c-conteudo2.
        b-status = true.
        apply "entry" to mgadm.ano-fiscal.fim-periodo[8].
        return no-apply.
    end.
    else do:
        b-status = false.
        if mgadm.ano-fiscal.fim-periodo[8]:screen-value <> "" then do:
         IF LENGTH(mgadm.ano-fiscal.fim-periodo[8]:screen-value, "CHARACTER") <= 6 then
             assign mgadm.ano-fiscal.fim-periodo[8]:screen-value = mgadm.ano-fiscal.fim-periodo[8]:screen-value + 
                         mgadm.ano-fiscal.ano-fiscal:screen-value.
           if not input frame {&FRAME-NAME} ano-fiscal.num-periodos <= 8  then do:
              assign ano-fiscal.ini-periodo[9]:screen-value = 
                     string(input frame {&FRAME-NAME} ano-fiscal.fim-periodo[8] + 1, "99/99/9999").
           end.  
           If date( mgadm.ano-fiscal.fim-periodo[8]:screen-value ) >= 
              date( mgadm.ano-fiscal.fim-periodo[9]:screen-value ) or l-permite then do:
              d-data-retorno = date( mgadm.ano-fiscal.ini-periodo[9]:screen-value ).
              run pi-altera-data.
              assign mgadm.ano-fiscal.fim-periodo[9]:screen-value = string( d-data-retorno).
              apply "leave" to mgadm.ano-fiscal.fim-periodo[9].
           end.

        end.
    end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ano-fiscal.fim-periodo[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[9] V-table-Win
ON ENTRY OF ano-fiscal.fim-periodo[9] IN FRAME f-main /* Fim Per°odo[9] */
DO:
  if not b-status then do:
     assign c-conteudo2 = mgadm.ano-fiscal.fim-periodo[9]:screen-value.
  end.

   if input ano-fiscal.num-periodos <= 8 then
  do:
    assign c-aux = string(input ano-fiscal.num-periodos).
    run utp/ut-msgs.p (input "show", input 165 , input c-aux). 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.fim-periodo[9] V-table-Win
ON LEAVE OF ano-fiscal.fim-periodo[9] IN FRAME f-main /* Fim Per°odo[9] */
DO:
    assign d-conteudo = input frame {&FRAME-NAME} mgadm.ano-fiscal.fim-periodo[9] no-error.
    if  error-status:get-number(1) <> 0 then do:
        run utp/ut-msgs.p (input "show", 
                           input 173, /*Data Invalida.*/
                           mgadm.ano-fiscal.fim-periodo[9]:screen-value ).
        assign mgadm.ano-fiscal.fim-periodo[9]:screen-value = c-conteudo2.
        b-status = true.
        apply "entry" to mgadm.ano-fiscal.fim-periodo[9].
        return no-apply.
    end.
    else do:
        b-status = false.
        if mgadm.ano-fiscal.fim-periodo[9]:screen-value <> "" then do:
         IF LENGTH(mgadm.ano-fiscal.fim-periodo[9]:screen-value, "CHARACTER") <= 6 then
             assign mgadm.ano-fiscal.fim-periodo[9]:screen-value = mgadm.ano-fiscal.fim-periodo[9]:screen-value + 
                         mgadm.ano-fiscal.ano-fiscal:screen-value.
           if not input frame {&FRAME-NAME} ano-fiscal.num-periodos <= 9  then do:
              assign ano-fiscal.ini-periodo[10]:screen-value = 
                     string(input frame {&FRAME-NAME} ano-fiscal.fim-periodo[9] + 1, "99/99/9999").
           end.  
           If date( mgadm.ano-fiscal.fim-periodo[9]:screen-value ) >= 
              date( mgadm.ano-fiscal.fim-periodo[10]:screen-value ) or l-permite then do:
              d-data-retorno = date( mgadm.ano-fiscal.ini-periodo[10]:screen-value ).
              run pi-altera-data.
              assign mgadm.ano-fiscal.fim-periodo[10]:screen-value = string( d-data-retorno).
              apply "leave" to mgadm.ano-fiscal.fim-periodo[10].
           end.

        end.
     end.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ano-fiscal.ini-periodo[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.ini-periodo[1] V-table-Win
ON ENTRY OF ano-fiscal.ini-periodo[1] IN FRAME f-main /* In°cio[1] */
DO:
  if not b-status then do:
     assign c-conteudo2 = mgadm.ano-fiscal.ini-periodo[1]:screen-value.
  end.
  assign b-alterou-data = false.
  assign c-data-ant = date( mgadm.ano-fiscal.ini-periodo[1]:screen-value ).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.ini-periodo[1] V-table-Win
ON LEAVE OF ano-fiscal.ini-periodo[1] IN FRAME f-main /* In°cio[1] */
DO:

  assign l-alterou = YES
         l-permite = no.
    assign d-conteudo = input frame {&frame-name} mgadm.ano-fiscal.ini-periodo[1] no-error.
    if  error-status:get-number(1) <> 0 then do:
        run utp/ut-msgs.p (input "show", 
                           input 173, /*Data Invalida.*/
                           mgadm.ano-fiscal.ini-periodo[1]:screen-value ).
        assign mgadm.ano-fiscal.ini-periodo[1]:screen-value = c-conteudo2.
        b-status = true.
        apply "entry" to mgadm.ano-fiscal.ini-periodo[1].
        return no-apply.
    end.
    else do:

        b-status = false.
        IF LENGTH(mgadm.ano-fiscal.ini-periodo[1]:screen-value, "CHARACTER") <= 6 then
          assign mgadm.ano-fiscal.ini-periodo[1]:screen-value = mgadm.ano-fiscal.ini-periodo[1]:screen-value + 
               mgadm.ano-fiscal.ano-fiscal:screen-value.

        if c-data-ant <> date(mgadm.ano-fiscal.ini-periodo[1]:screen-value) then do:
            if year(date(ano-fiscal.ini-periodo[1]:screen-value)) <> integer(ano-fiscal.ano-fiscal:screen-value) - 1 
            or (year(date(mgadm.ano-fiscal.ini-periodo[1]:screen-value))  = year(c-data-ant) - 1
            and day(date(mgadm.ano-fiscal.ini-periodo[1]:screen-value))   = 01
            and month(date(mgadm.ano-fiscal.ini-periodo[1]:screen-value)) = 01) then do:
                assign b-alterou-data = true.
                apply "leave" to ano-fiscal.num-periodos in frame {&frame-name}.
            end.    
            else
                assign l-permite = yes.
        end.

        If date( mgadm.ano-fiscal.ini-periodo[1]:screen-value ) >= 
           date( mgadm.ano-fiscal.fim-periodo[1]:screen-value ) or l-permite then do:
           d-data-retorno = date( mgadm.ano-fiscal.ini-periodo[1]:screen-value ).
           run pi-altera-data.
           assign mgadm.ano-fiscal.fim-periodo[1]:screen-value = string( d-data-retorno).
           apply "leave" to mgadm.ano-fiscal.fim-periodo[1].
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ano-fiscal.num-periodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ano-fiscal.num-periodos V-table-Win
ON LEAVE OF ano-fiscal.num-periodos IN FRAME f-main /* Num Per°odos */
DO:
/*    if ( input frame {&FRAME-NAME}  ano-fiscal.num-periodos = 13 and i-pais-impto-usuario = 4  /*MÇxico */) then do:
            run utp/ut-msgs.p (input "show", 
                               input 19078,
                               input string(input ano-fiscal.num-periodos)).

            assign ano-fiscal.num-periodos:screen-value = "12".

            apply "entry" to ano-fiscal.num-periodos.                    
            return no-apply.
    end. (Atividade 128.681) */

/*     run get-attribute ('adm-new-record').
     if  return-value = 'yes' Then do:*/

            IF INPUT ano-fiscal.ano-fiscal = 0000 THEN DO:

                find last b-ano where b-ano.ep-codigo = i-ep-codigo-usuario no-lock no-error.
                if  avail b-ano then 
                     assign ano-fiscal.ano-fiscal:screen-value in frame {&frame-name} = string(b-ano.ano-fiscal + 1, "9999") 
                            ano-fiscal.ano-fiscal:sensitive = YES.
            END.

            assign da-work = date( 01,01,input ano-fiscal.ano-fiscal). 
            If ano-fiscal.ini-periodo[1]:screen-value <> ' ' then
               assign da-work = date( integer( substr( ano-fiscal.ini-periodo[1]:screen-value, 04,02 ) ), 
                                      integer( substr( ano-fiscal.ini-periodo[1]:screen-value, 01,02 ) ),
                                      input ano-fiscal.ano-fiscal).

            run pi_calcula_datas.
            assign ano-fiscal.ini-periodo[1]:screen-value = String(i-ini-per[1])
                   ano-fiscal.ini-periodo[2]:screen-value = String(i-ini-per[2])
                   ano-fiscal.ini-periodo[3]:screen-value = String(i-ini-per[3])
                   ano-fiscal.ini-periodo[4]:screen-value = String(i-ini-per[4])
                   ano-fiscal.ini-periodo[5]:screen-value = String(i-ini-per[5])
                   ano-fiscal.ini-periodo[6]:screen-value = String(i-ini-per[6])
                   ano-fiscal.ini-periodo[7]:screen-value = String(i-ini-per[7])
                   ano-fiscal.ini-periodo[8]:screen-value = String(i-ini-per[8])
                   ano-fiscal.ini-periodo[9]:screen-value = String(i-ini-per[9])
                   ano-fiscal.ini-periodo[10]:screen-value = String(i-ini-per[10])
                   ano-fiscal.ini-periodo[11]:screen-value = String(i-ini-per[11])
                   ano-fiscal.ini-periodo[12]:screen-value = String(i-ini-per[12]).

           if input ano-fiscal.num-periodos < 13 then do:
              ano-fiscal.ini-periodo[13]:screen-value = "".
              ano-fiscal.fim-periodo[13]:screen-value = "".
           end.

            assign ano-fiscal.fim-periodo[1]:screen-value = String(i-fim-per[1])
                   ano-fiscal.fim-periodo[2]:screen-value = String(i-fim-per[2])
                   ano-fiscal.fim-periodo[3]:screen-value = String(i-fim-per[3])
                   ano-fiscal.fim-periodo[4]:screen-value = String(i-fim-per[4])
                   ano-fiscal.fim-periodo[5]:screen-value = String(i-fim-per[5])
                   ano-fiscal.fim-periodo[6]:screen-value = String(i-fim-per[6])
                   ano-fiscal.fim-periodo[7]:screen-value = String(i-fim-per[7])
                   ano-fiscal.fim-periodo[8]:screen-value = String(i-fim-per[8])
                   ano-fiscal.fim-periodo[9]:screen-value = String(i-fim-per[9])
                   ano-fiscal.fim-periodo[10]:screen-value = String(i-fim-per[10])
                   ano-fiscal.fim-periodo[11]:screen-value = String(i-fim-per[11])
                   ano-fiscal.fim-periodo[12]:screen-value = String(i-fim-per[12]).
     /*end.*/
     enable ano-fiscal.fim-periodo[1] with frame {&frame-name}.
     enable ano-fiscal.fim-periodo[2] with frame {&frame-name}.
     enable ano-fiscal.fim-periodo[3] with frame {&frame-name}.
     enable ano-fiscal.fim-periodo[4] with frame {&frame-name}.
     enable ano-fiscal.fim-periodo[5] with frame {&frame-name}.
     enable ano-fiscal.fim-periodo[6] with frame {&frame-name}.
     enable ano-fiscal.fim-periodo[7] with frame {&frame-name}.
     enable ano-fiscal.fim-periodo[8] with frame {&frame-name}.
     enable ano-fiscal.fim-periodo[9] with frame {&frame-name}.
     enable ano-fiscal.fim-periodo[10] with frame {&frame-name}.
     enable ano-fiscal.fim-periodo[11] with frame {&frame-name}.
     enable ano-fiscal.fim-periodo[12] with frame {&frame-name}.
     disable ano-fiscal.fim-periodo[13] with frame {&frame-name}.

    if  input frame {&FRAME-NAME} ano-fiscal.num-periodos < 13 then do:
        assign ano-fiscal.ini-periodo[13]:screen-value = ""
               ano-fiscal.fim-periodo[13]:screen-value = "".
        disable ano-fiscal.fim-periodo[13] with frame {&frame-name}.
    end.
    if  input frame {&FRAME-NAME} ano-fiscal.num-periodos < 12 then do:
        assign ano-fiscal.ini-periodo[12]:screen-value = ""
               ano-fiscal.fim-periodo[12]:screen-value = "".
        disable ano-fiscal.fim-periodo[12] with frame {&frame-name}.
    end.
    if  input frame {&FRAME-NAME} ano-fiscal.num-periodos < 11 then  do:
        assign ano-fiscal.ini-periodo[11]:screen-value = ""
               ano-fiscal.fim-periodo[11]:screen-value = "".
        disable ano-fiscal.fim-periodo[11] with frame {&frame-name}.
    end.
    if  input frame {&FRAME-NAME} ano-fiscal.num-periodos < 10 then  do:
        assign ano-fiscal.ini-periodo[10]:screen-value = ""
               ano-fiscal.fim-periodo[10]:screen-value = "".
        disable ano-fiscal.fim-periodo[10] with frame {&frame-name}.
    end.
    if  input frame {&FRAME-NAME} ano-fiscal.num-periodos < 9 then  do:
        assign ano-fiscal.ini-periodo[9]:screen-value = ""
               ano-fiscal.fim-periodo[9]:screen-value = "".
        disable ano-fiscal.fim-periodo[9] with frame {&frame-name}.
    end.
    if  input frame {&FRAME-NAME} ano-fiscal.num-periodos < 8 then  do:
        assign ano-fiscal.ini-periodo[8]:screen-value = ""
               ano-fiscal.fim-periodo[8]:screen-value = "".
        disable ano-fiscal.fim-periodo[8] with frame {&frame-name}.
    end.
    if  input frame {&FRAME-NAME} ano-fiscal.num-periodos < 7 then  do:
        assign ano-fiscal.ini-periodo[7]:screen-value = ""
               ano-fiscal.fim-periodo[7]:screen-value = "".
        disable ano-fiscal.fim-periodo[7] with frame {&frame-name}.
    end.
    if  input frame {&FRAME-NAME} ano-fiscal.num-periodos < 6 then  do:
        assign ano-fiscal.ini-periodo[6]:screen-value = ""
               ano-fiscal.fim-periodo[6]:screen-value = "".
        disable ano-fiscal.fim-periodo[6] with frame {&frame-name}.
    end.
    if  input frame {&FRAME-NAME} ano-fiscal.num-periodos < 5 then  do:
        assign ano-fiscal.ini-periodo[5]:screen-value = ""
               ano-fiscal.fim-periodo[5]:screen-value = "".
        disable ano-fiscal.fim-periodo[5] with frame {&frame-name}.
    end.
    if  input frame {&FRAME-NAME} ano-fiscal.num-periodos < 4 then  do:
        assign ano-fiscal.ini-periodo[4]:screen-value = ""
               ano-fiscal.fim-periodo[4]:screen-value = "".
        disable ano-fiscal.fim-periodo[4] with frame {&frame-name}.
    end.
    if  input frame {&FRAME-NAME} ano-fiscal.num-periodos < 3 then  do:
        assign ano-fiscal.ini-periodo[3]:screen-value = ""
               ano-fiscal.fim-periodo[3]:screen-value = "".
        disable ano-fiscal.fim-periodo[3] with frame {&frame-name}.
    end.
    if  input frame {&FRAME-NAME} ano-fiscal.num-periodos < 2 then do:
        assign ano-fiscal.ini-periodo[2]:screen-value = ""
               ano-fiscal.fim-periodo[2]:screen-value = "".
        disable ano-fiscal.fim-periodo[2] with frame {&frame-name}.
    end.

    apply "leave" to mgadm.ano-fiscal.fim-periodo[1].
    apply "leave" to mgadm.ano-fiscal.fim-periodo[2].
    apply "leave" to mgadm.ano-fiscal.fim-periodo[3].
    apply "leave" to mgadm.ano-fiscal.fim-periodo[4].
    apply "leave" to mgadm.ano-fiscal.fim-periodo[5].
    apply "leave" to mgadm.ano-fiscal.fim-periodo[6].
    apply "leave" to mgadm.ano-fiscal.fim-periodo[7].
    apply "leave" to mgadm.ano-fiscal.fim-periodo[8].
    apply "leave" to mgadm.ano-fiscal.fim-periodo[9].
    apply "leave" to mgadm.ano-fiscal.fim-periodo[10].
    apply "leave" to mgadm.ano-fiscal.fim-periodo[11].
    apply "leave" to mgadm.ano-fiscal.fim-periodo[12].

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

  {utp/ut-rtlbl.i mgadm ano-fiscal ini-periodo fill-in-1}
  {utp/ut-rtlbl.i mgadm ano-fiscal fim-periodo fill-in-2}
  {utp/ut-rtlbl.i mgadm ano-fiscal estado-per  fill-in-3}

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
  {src/adm/template/row-list.i "ano-fiscal"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ano-fiscal"}

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
    assign c-opcao = "incluir".

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

    do  with frame {&frame-name}:
        assign combo-box-1:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-2:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-3:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-4:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-5:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-6:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-7:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-8:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-9:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-10:screen-value = {adinc/i01ad270.i 04 1}.
        assign combo-box-11:screen-value = {adinc/i01ad270.i 04 1}.
        assign combo-box-12:screen-value = {adinc/i01ad270.i 04 1}.
        assign combo-box-13:screen-value = {adinc/i01ad270.i 04 1}.
        assign ano-fiscal.ini-periodo[1]:screen-value = "".
        assign ano-fiscal.ini-periodo[2]:screen-value = "".
        assign ano-fiscal.ini-periodo[3]:screen-value = "".
        assign ano-fiscal.ini-periodo[4]:screen-value = "".
        assign ano-fiscal.ini-periodo[5]:screen-value = "".
        assign ano-fiscal.ini-periodo[6]:screen-value = "".
        assign ano-fiscal.ini-periodo[7]:screen-value = "".
        assign ano-fiscal.ini-periodo[8]:screen-value = "".
        assign ano-fiscal.ini-periodo[9]:screen-value = "".
        assign ano-fiscal.ini-periodo[10]:screen-value = "".
        assign ano-fiscal.ini-periodo[11]:screen-value = "".
        assign ano-fiscal.ini-periodo[12]:screen-value = "".
        assign ano-fiscal.ini-periodo[13]:screen-value = "".
        assign ano-fiscal.fim-periodo[1]:screen-value = "".
        assign ano-fiscal.fim-periodo[2]:screen-value = "".
        assign ano-fiscal.fim-periodo[3]:screen-value = "".
        assign ano-fiscal.fim-periodo[4]:screen-value = "".
        assign ano-fiscal.fim-periodo[5]:screen-value = "".
        assign ano-fiscal.fim-periodo[6]:screen-value = "".
        assign ano-fiscal.fim-periodo[7]:screen-value = "".
        assign ano-fiscal.fim-periodo[8]:screen-value = "".
        assign ano-fiscal.fim-periodo[9]:screen-value = "".
        assign ano-fiscal.fim-periodo[10]:screen-value = "".
        assign ano-fiscal.fim-periodo[11]:screen-value = "".
        assign ano-fiscal.fim-periodo[12]:screen-value = "".
        assign ano-fiscal.fim-periodo[13]:screen-value = "".
    end.    

    {utp/ut-rtlbl.i mgadm ano-fiscal ini-periodo fill-in-1}
    {utp/ut-rtlbl.i mgadm ano-fiscal fim-periodo fill-in-2}
    {utp/ut-rtlbl.i mgadm ano-fiscal estado-per  fill-in-3}

    assign rw-ano-fiscal = rowid(ano-fiscal).

    find first param-global no-lock no-error.
    if  not avail param-global then do:
        run utp/ut-msgs.p(input "show", input 16, input "").
        return 'adm-error'.
    end.
    else do:
        if  param-global.modulo-ct = yes then do:
            do with frame {&frame-name}:
               assign combo-box-1:sensitive = no.
               assign combo-box-2:sensitive = no.
               assign combo-box-3:sensitive = no.
               assign combo-box-4:sensitive = no.
               assign combo-box-5:sensitive = no.
               assign combo-box-6:sensitive = no.
               assign combo-box-7:sensitive = no.
               assign combo-box-8:sensitive = no.
               assign combo-box-9:sensitive = no.
               assign combo-box-10:sensitive = no.
               assign combo-box-11:sensitive = no.
               assign combo-box-12:sensitive = no.
               assign combo-box-13:sensitive = no.
            end.   
        end.
    end.

    find last b-ano where b-ano.ep-codigo = i-ep-codigo-usuario no-lock no-error.
    if  avail b-ano then 
        assign ano-fiscal.ano-fiscal:screen-value in frame {&frame-name} = string(b-ano.ano-fiscal + 1, "9999")
               ano-fiscal.ano-fiscal:sensitive = yes
               ano-fiscal.ini-periodo[1]:screen-value = string(b-ano.fim-periodo[b-ano.num-periodos] + 1, "99/99/9999").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/

    /*Cadastramento dos anos deve ser sequencial, se ocorrer de cadastrar um ano que n∆o seja sequencial
      n∆o deve permitir. */

    find first b-ano-fiscal-aux 
         where b-ano-fiscal-aux.ep-codigo  = i-ep-codigo-usuario 
         and   b-ano-fiscal-aux.ano-fiscal > input frame {&frame-name} ano-fiscal.ano-fiscal no-lock no-error.
    if avail b-ano-fiscal-aux then do:
       /*Testa quando Ç cadastrado um ano inferior a todos existente. */
       if input frame {&frame-name} ano-fiscal.ano-fiscal + 1 < b-ano-fiscal-aux.ano-fiscal then do:
           run utp/ut-msgs.p(input "show", 
                             input 19407, 
                             input "").
           return error.
       end.
       if input frame {&frame-name} ano-fiscal.fim-periodo[input frame {&frame-name} ano-fiscal.num-periodos] + 1 
            <> b-ano-fiscal-aux.ini-periodo[1] then do:
            run utp/ut-msgs.p(input "show",
                              input 19409,
                              input "").
            return error.
        end.
    end.
    else do:
        find last b-ano-fiscal-aux 
        where b-ano-fiscal-aux.ep-codigo  = i-ep-codigo-usuario 
        and   b-ano-fiscal-aux.ano-fiscal < input frame {&frame-name} ano-fiscal.ano-fiscal no-lock no-error.
        if avail b-ano-fiscal-aux then do:
            /*Testa quando Ç cadastrado um ano superior a todos existente. */
            if input frame {&frame-name} ano-fiscal.ano-fiscal - 1 > b-ano-fiscal-aux.ano-fiscal then do:
                run utp/ut-msgs.p(input "show", 
                              input 19407, 
                              input "").
                return error.
            end.
            if input frame {&frame-name} ano-fiscal.ini-periodo[1] - 1 <> b-ano-fiscal-aux.fim-periodo[b-ano-fiscal-aux.num-periodos] then do:
                run utp/ut-msgs.p(input "show",
                              input 19408,
                              input "").
                return error.
            end.
        end.
    end.

    /*Teste para verificar se o ano j† existe cadastrado*/
    {utp/ut-field.i mgadm ano-fiscal ano-fiscal 1}
    FIND FIRST b-ano-fiscal-aux NO-LOCK
         WHERE b-ano-fiscal-aux.ep-codigo  = i-ep-codigo-usuario
         AND   b-ano-fiscal-aux.ano-fiscal = input frame {&frame-name} ano-fiscal.ano-fiscal NO-ERROR.
    IF ano-fiscal.ano-fiscal:SENSITIVE IN FRAME  {&frame-name} = YES THEN DO: /*Inclus∆o*/
       IF AVAIL b-ano-fiscal-aux THEN DO:
          run utp/ut-msgs.p (input "show", input 1, input return-value).
          return 'adm-error'.
       END.                                                                     
    END.

    assign c-opcao = " ".
    FIND FIRST ano-fiscal where rowid(ano-fiscal) = rw-ano-fiscal NO-LOCK no-error.
    repeat i-ind = 1 to input frame {&FRAME-NAME} mgadm.ano-fiscal.num-periodos with frame {&frame-name}:
        if  input ano-fiscal.fim-periodo[i-ind] <
            input ano-fiscal.ini-periodo[i-ind] then do:
            run utp/ut-msgs.p(input "show", 
                              input 184, /* Data de Inicio  maior que Data Fim .*/
                              input string(input ano-fiscal.ini-periodo[i-ind], "99/99/9999") + "~~" +
                                    string(input ano-fiscal.fim-periodo[i-ind], "99/99/9999")).
            return 'adm-error'.
        end.
    end.

    ASSIGN i-ano-ant = input ano-fiscal.ano-fiscal - 1.
    find LAST  b-ano-fiscal 
         where b-ano-fiscal.ep-codigo  = i-ep-codigo-usuario 
         and   b-ano-fiscal.ano-fiscal = i-ano-ant NO-LOCK no-error.
    if avail b-ano-fiscal then do:
        if b-ano-fiscal.num-periodos > 0 then do:
            If (b-ano-fiscal.fim-periodo[b-ano-fiscal.num-periodos] + 1) <> input ano-fiscal.ini-periodo[1] then do:
                run utp/ut-msgs.p(input "show", 
                              input 19086, 
                              string( b-ano-fiscal.fim-periodo[b-ano-fiscal.num-periodos] + 1, '99/99/9999') ).
                return 'adm-error'.
            end.
        end.
    end.
    else do:
        /* ap¢s procurar o ano anterior verifica se a tabela n∆o esta vazia.
            Pode ser implantaá∆o de sistema e a tabela esta vazia. */

        find last b-ano-fiscal where b-ano-fiscal.ep-codigo = i-ep-codigo-usuario NO-LOCK no-error.
        if not avail b-ano-fiscal then do:
            find first b-ano-fiscal where b-ano-fiscal.ep-codigo = i-ep-codigo-usuario no-lock no-error.
            if avail ano-fiscal then do:
                run utp/ut-msgs.p(input "show", 
                          input 669, 
                          string( i-ano-ant ) ).
                return 'adm-error'.
            end.
        end.    
    end.

    if i-pais-impto-usuario <> 3 then do:
        assign da-work = input ano-fiscal.fim-periodo[input ano-fiscal.num-periodos] + 1.
        if  month(da-work) <> month(input ano-fiscal.ini-periodo[1])
        or  day(da-work) <> day(input ano-fiscal.ini-periodo[1]) then do:
            run utp/ut-msgs.p (input "show", 
                               input 185, /*Data fim do £ltimo per°odo  n∆o completa 1 ano.*/
                               input string(input ano-fiscal.fim-periodo[input ano-fiscal.num-periodos], "99/99/9999")).
            return 'adm-error'.
        end.   
    end.    

    find empresa where empresa.ep-codigo = i-ep-codigo-usuario EXCLUSIVE-LOCK no-error.
    if  empresa.ano-corrente = 0 then
        assign empresa.ano-corrente = input ano-fiscal.ano-fiscal.

    /* Validaá∆o Ano Fiscal X Fechamento Estoque */
    if  not adm-new-record
    and avail param-global
    and param-global.modulo-ce
    and param-global.empresa-prin = i-ep-codigo-usuario then do:
        run pi-valida-periodos.
        if  return-value = "adm-error" then
            return "adm-error".
    end.
    /*********************************************/

    run get-attribute ('adm-new-record').

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    assign ano-fiscal.estado-per[1]  = {adinc/i01ad270.i 06 combo-box-1}.
    assign ano-fiscal.estado-per[2]  = {adinc/i01ad270.i 06 combo-box-2}.
    assign ano-fiscal.estado-per[3]  = {adinc/i01ad270.i 06 combo-box-3}.
    assign ano-fiscal.estado-per[4]  = {adinc/i01ad270.i 06 combo-box-4}.
    assign ano-fiscal.estado-per[5]  = {adinc/i01ad270.i 06 combo-box-5}.
    assign ano-fiscal.estado-per[6]  = {adinc/i01ad270.i 06 combo-box-6}.
    assign ano-fiscal.estado-per[7]  = {adinc/i01ad270.i 06 combo-box-7}.
    assign ano-fiscal.estado-per[8]  = {adinc/i01ad270.i 06 combo-box-8}.
    assign ano-fiscal.estado-per[9]  = {adinc/i01ad270.i 06 combo-box-9}.
    assign ano-fiscal.estado-per[10] = {adinc/i01ad270.i 06 combo-box-10}.
    assign ano-fiscal.estado-per[11] = {adinc/i01ad270.i 06 combo-box-11}.
    assign ano-fiscal.estado-per[12] = {adinc/i01ad270.i 06 combo-box-12}.
    assign ano-fiscal.estado-per[13] = {adinc/i01ad270.i 06 combo-box-13}.
    assign ano-fiscal.ep-codigo      = i-ep-codigo-usuario.

    /*****[ Geraá∆o de Transaá∆o Multiplanta Especifica do SMC ]******/
        for each tt-smc-ano-fiscal:
            delete tt-smc-ano-fiscal.
        end.
        assign  c-transacao = "SMC001".
        {cdp/cd7300.i5 "001" c-transacao "-SMC"}
        assign  i-tipo-movto = if adm-new-record then 1 else 2.
        run pi-cria-tt-dados-smc (i-tipo-movto).
        {cdp/cd7300.i6 "001" c-transacao "-SMC"}
    /***[Fim da Geraá∆o de Transaá∆o Multiplanta Especifica do SMC]***/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/
    assign c-opcao = " ".
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
   /*Cadastramento dos anos deve ser sequencial, se ocorrer de cadastrar um ano que n∆o seja sequencial
    n∆o deve permitir deletar. */

    find first b-ano-fiscal-aux
         where b-ano-fiscal-aux.ep-codigo  = i-ep-codigo-usuario 
         and   b-ano-fiscal-aux.ano-fiscal > input frame {&frame-name} ano-fiscal.ano-fiscal no-lock no-error.

    if avail b-ano-fiscal-aux then do:
        /*Testa quando tenta deletar um ano e existe um ano superior e inferior a ele. */
        find first b-ano-fiscal-aux 
        where b-ano-fiscal-aux.ep-codigo  = i-ep-codigo-usuario 
        and   b-ano-fiscal-aux.ano-fiscal < input frame {&frame-name} ano-fiscal.ano-fiscal no-lock no-error.
        if avail b-ano-fiscal-aux then do:
            /*N∆o pode deixar deletar porque existem anos antes de depois do ano referido */
            run utp/ut-msgs.p(input "show", 
                              input 19412, 
                              input "").
            return error.
        end.    
    end.
 RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  ASSIGN mgadm.ano-fiscal.fim-periodo[13]:bgcolor = 8.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/

    assign rw-ano-fiscal = rowid(ano-fiscal).
    assign rw-ano-fiscal2 = rowid(ano-fiscal).

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    if  avail ano-fiscal then do with frame {&frame-name}:
        assign combo-box-1:screen-value  = {adinc/i01ad270.i 04 ano-fiscal.estado-per[1]}.
        assign combo-box-2:screen-value  = {adinc/i01ad270.i 04 ano-fiscal.estado-per[2]}.
        assign combo-box-3:screen-value  = {adinc/i01ad270.i 04 ano-fiscal.estado-per[3]}.
        assign combo-box-4:screen-value  = {adinc/i01ad270.i 04 ano-fiscal.estado-per[4]}.
        assign combo-box-5:screen-value  = {adinc/i01ad270.i 04 ano-fiscal.estado-per[5]}.
        assign combo-box-6:screen-value  = {adinc/i01ad270.i 04 ano-fiscal.estado-per[6]}.
        assign combo-box-7:screen-value  = {adinc/i01ad270.i 04 ano-fiscal.estado-per[7]}.
        assign combo-box-8:screen-value  = {adinc/i01ad270.i 04 ano-fiscal.estado-per[8]}.
        assign combo-box-9:screen-value  = {adinc/i01ad270.i 04 ano-fiscal.estado-per[9]}.
        assign combo-box-10:screen-value = {adinc/i01ad270.i 04 ano-fiscal.estado-per[10]}.
        assign combo-box-11:screen-value = {adinc/i01ad270.i 04 ano-fiscal.estado-per[11]}.
        assign combo-box-12:screen-value = {adinc/i01ad270.i 04 ano-fiscal.estado-per[12]}. 
        assign combo-box-13:screen-value = {adinc/i01ad270.i 04 ano-fiscal.estado-per[13]}.
    end.
    else do with frame {&frame-name}:
        assign combo-box-1:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-2:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-3:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-4:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-5:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-6:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-7:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-8:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-9:screen-value  = {adinc/i01ad270.i 04 1}.
        assign combo-box-10:screen-value = {adinc/i01ad270.i 04 1}.
        assign combo-box-11:screen-value = {adinc/i01ad270.i 04 1}.
        assign combo-box-12:screen-value = {adinc/i01ad270.i 04 1}.
        assign combo-box-13:screen-value = {adinc/i01ad270.i 04 1}.
   end.    

   /* Validaá∆o Ano Fiscal X Fechamento Estoque */
   for each tt-ano-fiscal-antigo:
       delete tt-ano-fiscal-antigo.
   end.
               
   if  avail ano-fiscal then do:
       create tt-ano-fiscal-antigo.
       buffer-copy ano-fiscal to tt-ano-fiscal-antigo.
   end.
   /*********************************************/
                             
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    &if defined(ADM-MODIFY-FIELDS) &then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    {utp/ut-rtlbl.i mgadm ano-fiscal ini-periodo fill-in-1}
    {utp/ut-rtlbl.i mgadm ano-fiscal fim-periodo fill-in-2}
    {utp/ut-rtlbl.i mgadm ano-fiscal estado-per  fill-in-3}

    assign rw-ano-fiscal = rowid(ano-fiscal).

    if avail ano-fiscal then
        apply "leave" to ano-fiscal.num-periodos in frame {&frame-name}.

    find first param-global no-lock no-error.
    if  not avail param-global then do:
        run utp/ut-msgs.p (input "show", 
                           input 16, /*ParÉmetros Globais n∆o cadastrados*/
                           input "").
        return 'adm-error'.
    end.
    else 
        if  param-global.modulo-ct = yes then 
            do with frame {&frame-name}:
               assign combo-box-1:sensitive = no.
               assign combo-box-2:sensitive = no.
               assign combo-box-3:sensitive = no.
               assign combo-box-4:sensitive = no.
               assign combo-box-5:sensitive = no.
               assign combo-box-6:sensitive = no.
               assign combo-box-7:sensitive = no.
               assign combo-box-8:sensitive = no.
               assign combo-box-9:sensitive = no.
               assign combo-box-10:sensitive = no.
               assign combo-box-11:sensitive = no.
               assign combo-box-12:sensitive = no.
               assign combo-box-13:sensitive = no.
            end.   


    run get-attribute ('adm-new-record').
    if  return-value = "no" then do:
/*        find empresa where empresa.ep-codigo = ano-fiscal.ep-codigo no-error.
 *         find first movimento where movimento.ep-codigo = ano-fiscal.ep-codigo no-lock no-error.
 *         if  not avail movimento and empresa.ano-corrente <> ano-fiscal.ano-fiscal then do:
 *               run utp/ut-msgs.p (input "show",
 *                                  input 186, /*Ano Fiscal corrente da Empresa ?*/
 *                                  input ano-fiscal.ep-codigo).
 *               if  return-value = "yes":U then
 *                   assign empresa.ano-corrente = ano-fiscal.ano-fiscal.
 *         end.*/

        if  not param-global.modulo-ct then do:
            find FIRST empresa where empresa.ep-codigo = i-ep-codigo-usuario EXCLUSIVE-LOCK no-error.
            IF AVAIL empresa THEN DO:
                if  ano-fiscal.estado-per[ano-fiscal.num-periodos] = 3 then do:
                   run utp/ut-msgs.p (input "show", 
                                      input 187, /*Ano Fiscal Encerrado. Confirma?*/
                                      input "").
                    if  return-value = "no":U then                   
                        undo, retry.

                    ASSIGN i-ano-anterior = int(ano-fiscal.ano-fiscal).
                    find next ano-fiscal where ano-fiscal.ep-codigo = empresa.ep-codigo no-lock no-error.
                    if  not avail ano-fiscal then
                        run utp/ut-msgs.p (input "show",
                                           input 188,/*N∆o existe Ano Fiscal posterior a ano*/
                                           input string(i-ano-anterior)).
                 else
                    assign empresa.ano-corrente = ano-fiscal.ano-fiscal.
            end.

                assign empresa.data-inicio = ?
                       empresa.data-fim    = ?.

                {cdp/cd0120.i} /* define data-inicio e data-fim */
                /*Posiciona novamente no ano-fiscal */
                find first ano-fiscal where rowid(ano-fiscal) = rw-ano-fiscal NO-LOCK no-error.
            END.
        end.
    end.         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

    {cdp/cd0120.i} /* define data-inicio e data-fim */
    {cdp/cd0120.i1 "i-ep-codigo-usuario"} /* define ano-corrente */

    find first ano-fiscal where rowid(ano-fiscal) = rw-ano-fiscal NO-LOCK no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/
    do  with frame {&frame-name}:
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {adinc/i01ad270.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
            ASSIGN  combo-box-1:LIST-ITEM-PAIRS  = cAuxTraducao001.
        &else
            ASSIGN combo-box-1:list-items  = {adinc/i01ad270.i 03}.
        &endif
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao002 = {adinc/i01ad270.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao002).
            ASSIGN  combo-box-2:LIST-ITEM-PAIRS  = cAuxTraducao002.
        &else
            ASSIGN combo-box-2:list-items  = {adinc/i01ad270.i 03}.
        &endif
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao003 = {adinc/i01ad270.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao003).
            ASSIGN  combo-box-3:LIST-ITEM-PAIRS  = cAuxTraducao003.
        &else
            ASSIGN combo-box-3:list-items  = {adinc/i01ad270.i 03}.
        &endif
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao004 = {adinc/i01ad270.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao004).
            ASSIGN  combo-box-4:LIST-ITEM-PAIRS  = cAuxTraducao004.
        &else
            ASSIGN combo-box-4:list-items  = {adinc/i01ad270.i 03}.
        &endif
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao005 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao005 = {adinc/i01ad270.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao005).
            ASSIGN  combo-box-5:LIST-ITEM-PAIRS  = cAuxTraducao005.
        &else
            ASSIGN combo-box-5:list-items  = {adinc/i01ad270.i 03}.
        &endif
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao006 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao006 = {adinc/i01ad270.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao006).
            ASSIGN  combo-box-6:LIST-ITEM-PAIRS  = cAuxTraducao006.
        &else
            ASSIGN combo-box-6:list-items  = {adinc/i01ad270.i 03}.
        &endif
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao007 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao007 = {adinc/i01ad270.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao007).
            ASSIGN  combo-box-7:LIST-ITEM-PAIRS  = cAuxTraducao007.
        &else
            ASSIGN combo-box-7:list-items  = {adinc/i01ad270.i 03}.
        &endif
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao008 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao008 = {adinc/i01ad270.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao008).
            ASSIGN  combo-box-8:LIST-ITEM-PAIRS  = cAuxTraducao008.
        &else
            ASSIGN combo-box-8:list-items  = {adinc/i01ad270.i 03}.
        &endif
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao009 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao009 = {adinc/i01ad270.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao009).
            ASSIGN  combo-box-9:LIST-ITEM-PAIRS  = cAuxTraducao009.
        &else
            ASSIGN combo-box-9:list-items  = {adinc/i01ad270.i 03}.
        &endif
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao010 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao010 = {adinc/i01ad270.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao010).
            ASSIGN  combo-box-10:LIST-ITEM-PAIRS = cAuxTraducao010.
        &else
            ASSIGN combo-box-10:list-items = {adinc/i01ad270.i 03}.
        &endif
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao011 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao011 = {adinc/i01ad270.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao011).
            ASSIGN  combo-box-11:LIST-ITEM-PAIRS = cAuxTraducao011.
        &else
            ASSIGN combo-box-11:list-items = {adinc/i01ad270.i 03}.
        &endif
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao012 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao012 = {adinc/i01ad270.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao012).
            ASSIGN  combo-box-12:LIST-ITEM-PAIRS = cAuxTraducao012.
        &else
            ASSIGN combo-box-12:list-items = {adinc/i01ad270.i 03}.
        &endif
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao013 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao013 = {adinc/i01ad270.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao013).
            ASSIGN  combo-box-13:LIST-ITEM-PAIRS = cAuxTraducao013.
        &else
            ASSIGN combo-box-13:list-items = {adinc/i01ad270.i 03}.
        &endif
    end.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    {utp/ut-rtlbl.i mgadm ano-fiscal ini-periodo fill-in-1}
    {utp/ut-rtlbl.i mgadm ano-fiscal fim-periodo fill-in-2}
    {utp/ut-rtlbl.i mgadm ano-fiscal estado-per  fill-in-3}

    run new-state ('desabilita-copia':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-reset-record V-table-Win 
PROCEDURE local-reset-record :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/
    def var rw-temp-ano-fiscal as rowid no-undo. 
    assign rw-ano-fiscal = rw-ano-fiscal2.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'reset-record':U ) .

    if  c-opcao = "incluir" then
        RUN dispatch IN THIS-PROCEDURE ('add-record':U).

    if  c-opcao = " " then do:
        RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
        apply "leave" to ano-fiscal.num-periodos in frame {&frame-name}. 
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  if  avail ano-fiscal then do:
      assign gr-ano-fiscal = rowid(ano-fiscal).

      find first param-global no-lock no-error.
      if  not avail param-global then do:
          run utp/ut-msgs.p (input "show", 
                             input 16, /*ParÉmetros Globais n∆o cadastrados*/
                             input "").
          return 'adm-error'.
      end.
      else do:
          run new-state ('habilita-modifica':U).
          run new-state ('habilita-elimina':U).

          find first movimento
               where movimento.ep-codigo = ano-fiscal.ep-codigo
               and   movimento.data     >= ano-fiscal.ini-periodo[1]
               and   movimento.data     <= ano-fiscal.fim-periodo[ano-fiscal.num-periodos]
               no-lock no-error.

          if  avail movimento then do:
              run new-state ('desabilita-modifica':U).
              run new-state ('desabilita-elimina':U).
          end.

          /**** Solicitado para retirar validaá∆o em 27/09/1999 *****/
         /*if  ano-fiscal.ep-codigo = param-global.empresa-pri then do:
 *               find first movto-estoq
 *                    where movto-estoq.dt-trans >= ano-fiscal.ini-periodo[1]
 *                    and   movto-estoq.dt-trans <= ano-fiscal.fim-periodo[ano-fiscal.num-periodos]
 *                    no-lock no-error.
 *                 
 *               if  avail movto-estoq then do:
 *                   run new-state ('desabilita-modifica':U).
 *                   run new-state ('desabilita-elimina':U).
 *               end.
 *           end.*/
      end.
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-data V-table-Win 
PROCEDURE pi-altera-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign da-anterior = d-data-retorno.
do  while month(d-data-retorno) = month(da-anterior):
    assign da-anterior = d-data-retorno.
    assign d-data-retorno = d-data-retorno + 1.
end.
assign d-data-retorno = da-anterior.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados-smc V-table-Win 
PROCEDURE pi-cria-tt-dados-smc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter i-tipo-movto as integer.

    if  param-global.modulo-mp
    and tt-replica-msg-SMC.log-replica-msg  = yes
    then do:
        create  tt-smc-ano-fiscal.
        buffer-copy ano-fiscal to tt-smc-ano-fiscal.
        create  tt-dados-env-SMC.
        assign  tt-dados-env-SMC.num-sequencia  = i-seq
                tt-dados-env-SMC.cod-tipo-reg   = 276
                tt-dados-env-SMC.ind-tipo-movto = i-tipo-movto
                tt-dados-env-SMC.identif-msg    = string(ano-fiscal.ano-fiscal).
        raw-transfer tt-smc-ano-fiscal to tt-dados-env-SMC.conteudo-msg.
        assign i-seq = i-seq + 1.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-periodos V-table-Win 
PROCEDURE pi-valida-periodos :
/*------------------------------------------------------------------------------
  Purpose:     Validaá∆o Ano Fiscal X Fechamento Estoque
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var i-periodo as int no-undo.   
       
    for each tt-ano-fiscal-novo:
        delete tt-ano-fiscal-novo.
    end.
       
    create tt-ano-fiscal-novo.
    assign tt-ano-fiscal-novo.num-periodos = input frame {&frame-name} ano-fiscal.num-periodos.
    do i-periodo = 1 to input frame {&frame-name} ano-fiscal.num-periodos:
        assign tt-ano-fiscal-novo.ini-periodo[i-periodo] = input frame {&frame-name} ano-fiscal.ini-periodo[i-periodo]
               tt-ano-fiscal-novo.fim-periodo[i-periodo] = input frame {&frame-name} ano-fiscal.fim-periodo[i-periodo].
    end.

    run cep/ceapi013.p (input  table tt-ano-fiscal-antigo,
                        input  table tt-ano-fiscal-novo,
                        output table tt-erro).

    find first tt-erro no-error.
    if  avail tt-erro then do:
        run utp/ut-msgs.p(input "show", 
                          input tt-erro.cd-erro, 
                          input "").
        return "adm-error".
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_calcula_datas V-table-Win 
PROCEDURE pi_calcula_datas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

assign c-datas_ini[1]  = ano-fiscal.ini-periodo[1]:screen-value  in frame {&frame-name}.
assign c-datas_ini[2]  = ano-fiscal.ini-periodo[2]:screen-value  in frame {&frame-name}.
assign c-datas_ini[3]  = ano-fiscal.ini-periodo[3]:screen-value  in frame {&frame-name}.
assign c-datas_ini[4]  = ano-fiscal.ini-periodo[4]:screen-value  in frame {&frame-name}.
assign c-datas_ini[5]  = ano-fiscal.ini-periodo[5]:screen-value  in frame {&frame-name}.
assign c-datas_ini[6]  = ano-fiscal.ini-periodo[6]:screen-value  in frame {&frame-name}.
assign c-datas_ini[7]  = ano-fiscal.ini-periodo[7]:screen-value  in frame {&frame-name}.
assign c-datas_ini[8]  = ano-fiscal.ini-periodo[8]:screen-value  in frame {&frame-name}.
assign c-datas_ini[9]  = ano-fiscal.ini-periodo[9]:screen-value  in frame {&frame-name}.
assign c-datas_ini[10] = ano-fiscal.ini-periodo[10]:screen-value in frame {&frame-name}.
assign c-datas_ini[11] = ano-fiscal.ini-periodo[11]:screen-value in frame {&frame-name}.
assign c-datas_ini[12] = ano-fiscal.ini-periodo[12]:screen-value in frame {&frame-name}.
assign c-datas_fim[1]  = ano-fiscal.fim-periodo[1]:screen-value  in frame {&frame-name}.
assign c-datas_fim[2]  = ano-fiscal.fim-periodo[2]:screen-value  in frame {&frame-name}.
assign c-datas_fim[3]  = ano-fiscal.fim-periodo[3]:screen-value  in frame {&frame-name}.
assign c-datas_fim[4]  = ano-fiscal.fim-periodo[4]:screen-value  in frame {&frame-name}.
assign c-datas_fim[5]  = ano-fiscal.fim-periodo[5]:screen-value  in frame {&frame-name}.
assign c-datas_fim[6]  = ano-fiscal.fim-periodo[6]:screen-value  in frame {&frame-name}.
assign c-datas_fim[7]  = ano-fiscal.fim-periodo[7]:screen-value  in frame {&frame-name}.
assign c-datas_fim[8]  = ano-fiscal.fim-periodo[8]:screen-value  in frame {&frame-name}.
assign c-datas_fim[9]  = ano-fiscal.fim-periodo[9]:screen-value  in frame {&frame-name}.
assign c-datas_fim[10] = ano-fiscal.fim-periodo[10]:screen-value in frame {&frame-name}.
assign c-datas_fim[11] = ano-fiscal.fim-periodo[11]:screen-value in frame {&frame-name}.
assign c-datas_fim[12] = ano-fiscal.fim-periodo[12]:screen-value in frame {&frame-name}.
assign c-datas_fim[13] = ano-fiscal.fim-periodo[13]:screen-value in frame {&frame-name}.

    do  i-ind = 1 to 13 with frame {&FRAME-NAME}:
        If c-datas_ini[i-ind] <> ' ' and not b-alterou-data then do:
            IF  MONTH(DATE((c-datas_ini[i-ind]))) = 02  and DAY(DATE((c-datas_ini[i-ind]))) = 29 then do:
                if (integer(YEAR(DATE((c-datas_ini[i-ind])))) modulo 4) > 0 then DO:
                   if session:date-format = "mdy" then
                      assign c-datas_ini[i-ind] = '02/28/' + substring(c-datas_ini[i-ind], 07, 04).
                   ELSE
                      assign c-datas_ini[i-ind] = '28/02/' + substring(c-datas_ini[i-ind], 07, 04).
                END.

              /*If (integer( mgadm.ano-fiscal.ano-fiscal:screen-value) modulo 4) > 0 then do:
 *                  assign c-datas_ini[i-ind] = '28/02/' + mgadm.ano-fiscal.ano-fiscal:screen-value.
 *               End.*/  
           end.
/*         assign i-ini-per[i-ind] = date( integer( substr( c-datas_ini[i-ind], 04, 02 )) , integer(substr( c-datas_ini[i-ind], 01, 02 )) , integer( mgadm.ano-fiscal.ano-fiscal:screen-value) ).*/
           assign i-ini-per[i-ind] = date( integer( substr( c-datas_ini[i-ind], 04, 02 )) , integer(substr( c-datas_ini[i-ind], 01, 02 )) , integer(substr(c-datas_ini[i-ind], 07, 04))).
           assign da-work = i-ini-per[i-ind].

           If c-datas_fim[i-ind] <> ' ' and not b-alterou-data then do:
                IF  MONTH(DATE((c-datas_fim[i-ind]))) = 02  and DAY(DATE((c-datas_fim[i-ind]))) = 29 then do:
                    if (integer(YEAR(DATE((c-datas_fim[i-ind])))) modulo 4) > 0 then DO:
                       if session:date-format = "mdy" then
                          assign c-datas_ini[i-ind] = '02/28/' + substring(c-datas_fim[i-ind], 07, 04).
                       ELSE
                          assign c-datas_ini[i-ind] = '28/02/' + substring(c-datas_fim[i-ind], 07, 04).
                    END.
                   /*If (integer( mgadm.ano-fiscal.ano-fiscal:screen-value) modulo 4) > 0 then do:
 *                       assign c-datas_fim[i-ind] = '28/02/' + mgadm.ano-fiscal.ano-fiscal:screen-value.
 *                    End.*/
                end.
           /*fo1285309-
                assign i-fim-per[i-ind] = date( integer( substr( c-datas_fim[i-ind], 04, 02 )) , integer( substr( c-datas_fim[i-ind], 01, 02 )), integer( substr(c-datas_fim[i-ind], 07, 04))).
           */     
                assign i-fim-per[i-ind] = date(MONTH(DATE((c-datas_fim[i-ind]))),DAY(DATE((c-datas_fim[i-ind]))),YEAR(DATE((c-datas_fim[i-ind])))).
                assign da-work = i-fim-per[i-ind] + 1.
/*                do while da-work) = month(i-fim-per[i-ind]):
                   assign da-anterior = da-work.
                   assign da-work     = da-work + 1.
                end.*/
           end.
           Else do:
                do while month(da-work) = month(i-ini-per[i-ind]):
                   assign da-anterior = da-work.
                   assign da-work     = da-work + 1.
                end.
                assign i-fim-per[i-ind] = da-anterior.
           End.
        End.
        Else do:
            assign i-ini-per[i-ind] = da-work.
            do  while month(da-work) = month(i-ini-per[i-ind]):
                assign da-anterior = da-work.
                assign da-work     = da-work + 1.
            end.
            assign i-fim-per[i-ind] = da-anterior.
        End.
    end.
    assign b-alterou-data = false.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_posiciona V-table-Win 
PROCEDURE pi_posiciona :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    enable ano-fiscal.fim-periodo[13] with frame {&frame-name}.
    apply "entry" to ano-fiscal.fim-periodo[13] in frame {&frame-name}. 

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
  {src/adm/template/snd-list.i "ano-fiscal"}

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

