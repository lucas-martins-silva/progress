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
{include/i-prgvrs.i V02IN101 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN101 MUT}
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

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                

def new shared var l-resposta as logical format "Sim/Nao" no-undo.
def new shared var l-entrou as logical init yes no-undo.
def new shared var l-var as logical init no no-undo.

/*
def new shared var de-total-ent as decimal format "->>>>,>>>,>>>,>>9.99" extent 4 no-undo init 0.
def new shared var de-ent-qt like de-total-ent.
def new shared var de-total-saida like de-total-ent.
def new shared var de-saida-qt like de-total-ent.
def new shared var de-est-med like de-total-ent.
def new shared var de-est-exc like de-total-ent.
def new shared var de-est-seg like de-total-ent.
def new shared var de-est-ini like de-total-ent.
def new shared var de-est-fim like de-total-ent.
def new shared var de-giro as decimal format "->>>>>9.99" extent 4 init 0.
def new shared var de-var-ent as decimal format "->>>,>>9.99" extent 2 init 0.
def new shared var de-var-ent-qt like de-var-ent.
def new shared var de-var-sd like de-var-ent.
def new shared var de-var-sd-qt like de-var-ent.
def new shared var de-var-med like de-var-ent.
def new shared var de-var-exc like de-var-ent.
def new shared var de-var-seg like de-var-ent.
def new shared var de-var-ini like de-var-ent.
def new shared var de-var-fim like de-var-ent.
def new shared var de-var-gr like de-var-ent.
*/

def var c-fam-aux like estat-ce.fm-codigo no-undo.
def var i-dia         as integer format "99" no-undo.
def var i-mo          as integer format "9" init "1" no-undo.
def var i-moeda       as integer format "9" init "0" no-undo.
def var i-mes-aux     as integer format "99" extent 12 no-undo.
def var i-ano-aux     as integer format 9999 extent 4 no-undo.
def var i-mes         as integer format 99 extent 4 no-undo.
def var i-ano         as integer format 9999 extent 12 no-undo.
def var i-dia-aux     as integer format 99 no-undo.
def var i-cont        as integer format 99 init 0 no-undo.
def var i-mes-fec     as integer format 99 no-undo.
def var i-ano-fec     as integer format 9999 init 0 no-undo.
def var i-var         as integer format 99 init 4 no-undo.
def var i-mes-per     as integer format 99 init 1 no-undo.
def var c-per-ini     as character format "9999/99" no-undo.
def var c-per-fim     like c-per-ini.
def var c-ext         as character format "x(9)" extent 12 no-undo.
def var i-mes-2       as integer no-undo.
def var i-ano-2       as integer no-undo.
def var c-moedas      as character extent 3 no-undo format "x(10)".
def var c-per-fin-aux like c-per-fim.
def var c-per-ini-aux like c-per-ini.
def var i-mo-aux like i-mo.

def var de-total-ent3 as de format "->>>>,>>>,>>>,>>9.99".
def var de-total-saida3 as de format "->>>>,>>>,>>>,>>9.99".
def var de-est-ini3 as de format "->>>>,>>>,>>>,>>9.99".
def var de-est-med3 as de format "->>>>,>>>,>>>,>>9.99".
def var de-est-seg3 as de format "->>>>,>>>,>>>,>>9.99".
def var de-est-exc3 as de format "->>>>,>>>,>>>,>>9.99".
def var de-est-fim3 as de format "->>>>,>>>,>>>,>>9.99".

def var de-total-ent4 as de format "->>>>,>>>,>>>,>>9.99".
def var de-total-saida4 as de format "->>>>,>>>,>>>,>>9.99".
def var de-est-ini4 as de format "->>>>,>>>,>>>,>>9.99".
def var de-est-med4 as de format "->>>>,>>>,>>>,>>9.99".
def var de-est-seg4 as de format "->>>>,>>>,>>>,>>9.99".
def var de-est-exc4 as de format "->>>>,>>>,>>>,>>9.99".
def var de-est-fim4 as de format "->>>>,>>>,>>>,>>9.99".

def var de-var-ent3 as decimal format "->>>,>>9.99" init 0.
def var de-var-ent-qt3 like de-var-ent3.
def var de-var-sd3 like de-var-ent3.
def var de-var-sd-qt3 like de-var-ent3.
def var de-var-med3 like de-var-ent3.
def var de-var-exc3 like de-var-ent3.
def var de-var-seg3 like de-var-ent3.
def var de-var-ini3 like de-var-ent3.
def var de-var-fim3 like de-var-ent3.
def var de-var-gr3  like de-var-ent3.
def var de-giro3 as decimal format "->>>>>9.99" init 0.
def var de-giro4 as decimal format "->>>>>9.99" init 0.

{cdp/cdcfgmat.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var tabela as char format "x(4)" extent 12.
{utp/ut-liter.i Jan * R}
assign tabela[1] = return-value.
{utp/ut-liter.i Fev * R}
assign tabela[2] = return-value.
{utp/ut-liter.i Mar * R}
assign tabela[3] = return-value.
{utp/ut-liter.i Abr * R}
assign tabela[4] = return-value.
{utp/ut-liter.i Mai * R}
assign tabela[5] = return-value.
{utp/ut-liter.i Jun * R}
assign tabela[6] = return-value.
{utp/ut-liter.i Jul * R}
assign tabela[7] = return-value.
{utp/ut-liter.i Ago * R}
assign tabela[8] = return-value.
{utp/ut-liter.i Set * R}
assign tabela[9] = return-value.
{utp/ut-liter.i Out * R}
assign tabela[10] = return-value.
{utp/ut-liter.i Nov * R}
assign tabela[11] = return-value.
{utp/ut-liter.i Dez * R}
assign tabela[12] = return-value.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-1 FILL-IN-5 
&Scoped-Define DISPLAYED-OBJECTS de-total-ent1 de-total-ent2 de-var-ent1 ~
de-total-saida1 de-total-saida2 de-var-sd1 de-est-ini1 de-est-ini2 ~
de-var-ini1 de-est-med1 de-est-med2 de-var-med1 de-est-seg1 de-est-seg2 ~
de-var-seg1 de-est-exc1 de-est-exc2 de-var-exc1 de-est-fim1 de-est-fim2 ~
de-var-fim1 de-giro1 de-giro2 de-var-gr1 c-lb-emp c-fm-codigo1 FILL-IN-5 ~
c-desc-fam c-moeda c-per-ini1 c-per-fim1 c-lb-variacao c-lb-ent c-lb-sai ~
c-lb-ini c-lb-med c-lb-seg c-lb-exc c-lb-fin c-lb-giro 

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
DEFINE VARIABLE c-desc-fam AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 28.14 BY .67 NO-UNDO.

DEFINE VARIABLE c-fm-codigo1 AS CHARACTER FORMAT "X(8)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-lb-emp AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 17.14 BY .67 NO-UNDO.

DEFINE VARIABLE c-lb-ent AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-lb-exc AS CHARACTER FORMAT "X(11)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-lb-fin AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-lb-giro AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-lb-ini AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-lb-med AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-lb-sai AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-lb-seg AS CHARACTER FORMAT "X(11)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-lb-variacao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13.14 BY .67 NO-UNDO.

DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(12)":U 
     LABEL "" 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-per-fim1 AS CHARACTER FORMAT "9999/99":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-per-ini1 AS CHARACTER FORMAT "9999/99":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE de-est-exc1 AS DECIMAL FORMAT "->>>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-exc2 AS DECIMAL FORMAT "->>>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-fim1 AS DECIMAL FORMAT "->>>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-fim2 AS DECIMAL FORMAT "->>>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-ini1 AS DECIMAL FORMAT "->>>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-ini2 AS DECIMAL FORMAT "->>>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-med1 AS DECIMAL FORMAT "->>>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-med2 AS DECIMAL FORMAT "->>>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-seg1 AS DECIMAL FORMAT "->>>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-est-seg2 AS DECIMAL FORMAT "->>>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-giro1 AS DECIMAL FORMAT "->>>>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-giro2 AS DECIMAL FORMAT "->>>>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-total-ent1 AS DECIMAL FORMAT "->>>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-total-ent2 AS DECIMAL FORMAT "->>>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-total-saida1 AS DECIMAL FORMAT "->>>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-total-saida2 AS DECIMAL FORMAT "->>>>,>>>,>>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-var-ent1 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-var-exc1 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-var-fim1 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-var-gr1 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-var-ini1 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-var-med1 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-var-sd1 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-var-seg1 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(1)":U INITIAL "-" 
      VIEW-AS TEXT 
     SIZE 1 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.43 BY 1.79.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.75.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 9.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-total-ent1 AT ROW 5.17 COL 23 COLON-ALIGNED NO-LABEL
     de-total-ent2 AT ROW 5.17 COL 49 NO-LABEL
     de-var-ent1 AT ROW 5.17 COL 70.72 COLON-ALIGNED NO-LABEL
     de-total-saida1 AT ROW 6.17 COL 23 COLON-ALIGNED NO-LABEL
     de-total-saida2 AT ROW 6.17 COL 49 NO-LABEL
     de-var-sd1 AT ROW 6.17 COL 70.72 COLON-ALIGNED NO-LABEL
     de-est-ini1 AT ROW 7.17 COL 23 COLON-ALIGNED NO-LABEL
     de-est-ini2 AT ROW 7.17 COL 47 COLON-ALIGNED NO-LABEL
     de-var-ini1 AT ROW 7.17 COL 70.72 COLON-ALIGNED NO-LABEL
     de-est-med1 AT ROW 8.17 COL 23 COLON-ALIGNED NO-LABEL
     de-est-med2 AT ROW 8.17 COL 47 COLON-ALIGNED NO-LABEL
     de-var-med1 AT ROW 8.17 COL 70.72 COLON-ALIGNED NO-LABEL
     de-est-seg1 AT ROW 9.17 COL 23 COLON-ALIGNED NO-LABEL
     de-est-seg2 AT ROW 9.17 COL 47 COLON-ALIGNED NO-LABEL
     de-var-seg1 AT ROW 9.17 COL 70.72 COLON-ALIGNED NO-LABEL
     de-est-exc1 AT ROW 10.17 COL 23 COLON-ALIGNED NO-LABEL
     de-est-exc2 AT ROW 10.17 COL 47 COLON-ALIGNED NO-LABEL
     de-var-exc1 AT ROW 10.17 COL 70.72 COLON-ALIGNED NO-LABEL
     de-est-fim1 AT ROW 11.17 COL 23 COLON-ALIGNED NO-LABEL
     de-est-fim2 AT ROW 11.17 COL 47 COLON-ALIGNED NO-LABEL
     de-var-fim1 AT ROW 11.17 COL 70.72 COLON-ALIGNED NO-LABEL
     de-giro1 AT ROW 13.42 COL 23.29 COLON-ALIGNED NO-LABEL
     de-giro2 AT ROW 13.42 COL 47 COLON-ALIGNED NO-LABEL
     de-var-gr1 AT ROW 13.42 COL 70.72 COLON-ALIGNED NO-LABEL
     c-lb-emp AT ROW 1.5 COL 2 NO-LABEL
     c-fm-codigo1 AT ROW 1.5 COL 19.43 COLON-ALIGNED NO-LABEL
     FILL-IN-5 AT ROW 1.5 COL 33.57 COLON-ALIGNED NO-LABEL
     c-desc-fam AT ROW 1.5 COL 35.14 COLON-ALIGNED NO-LABEL
     c-moeda AT ROW 1.5 COL 72.72 COLON-ALIGNED
     c-per-ini1 AT ROW 3.58 COL 26.14 COLON-ALIGNED NO-LABEL
     c-per-fim1 AT ROW 3.67 COL 50.14 COLON-ALIGNED NO-LABEL
     c-lb-variacao AT ROW 3.67 COL 71.43 COLON-ALIGNED NO-LABEL
     c-lb-ent AT ROW 5.33 COL 9.57 NO-LABEL
     c-lb-sai AT ROW 6.33 COL 9.57 NO-LABEL
     c-lb-ini AT ROW 7.33 COL 9.57 NO-LABEL
     c-lb-med AT ROW 8.33 COL 9.57 NO-LABEL
     c-lb-seg AT ROW 9.33 COL 9.57 NO-LABEL
     c-lb-exc AT ROW 10.33 COL 9.57 NO-LABEL
     c-lb-fin AT ROW 11.33 COL 9.57 NO-LABEL
     c-lb-giro AT ROW 13.42 COL 9.86 NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.92 COL 1
     RECT-1 AT ROW 12.96 COL 1.14
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
         HEIGHT             = 13.88
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

/* SETTINGS FOR FILL-IN c-desc-fam IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-fm-codigo1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-lb-emp IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-lb-ent IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-lb-exc IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-lb-fin IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-lb-giro IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-lb-ini IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-lb-med IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-lb-sai IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-lb-seg IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-lb-variacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-per-fim1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-per-ini1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-exc1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-exc2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-fim1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-fim2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-ini1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-ini2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-med1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-med2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-seg1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est-seg2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-giro1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-giro2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-total-ent1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-total-ent2 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN de-total-saida1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-total-saida2 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN de-var-ent1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-var-exc1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-var-fim1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-var-gr1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-var-ini1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-var-med1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-var-sd1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-var-seg1 IN FRAME f-main
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
  
  {utp/ut-liter.i Total_da_Empresa * R}
  assign c-lb-emp:screen-value in frame {&frame-name} = return-value.
  {utp/ut-field.i mguni moeda mo-codigo 1}
  assign c-moeda:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Entradas * R}
  assign c-lb-ent:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Sa¡das * R}
  assign c-lb-sai:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Inicial * R}
  assign c-lb-ini:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i M‚dio * R}
  assign c-lb-med:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Seguran‡a * R}
  assign c-lb-seg:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Excedente * R}
  assign c-lb-exc:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Final * R}
  assign c-lb-fin:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Giro * R}
  assign c-lb-giro:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Varia‡Æo_% * R}
  assign c-lb-variacao:screen-value in frame {&frame-name} = return-value.
  
  find first param-estoq  no-lock no-error.
  find first param-global no-lock no-error.
  assign i-ano-fec = integer(substring(param-estoq.ult-per-fech,1,4))
         i-mes-fec = integer(substring(param-estoq.ult-per-fech,5,2)).
  do i-cont = 1 to 2:
      assign i-ano-aux[i-cont] = i-ano-fec
             i-mes-aux[i-cont] = i-mes-fec
             i-mes-fec = i-mes-fec - 1.
      if i-mes-fec < 1 then
          assign i-mes-fec = 12
                 i-ano-fec = i-ano-fec - 1.
  end.
  assign c-per-fim = param-estoq.ult-per-fech
         c-per-ini = string(i-ano-aux[2],"9999") + string(i-mes-aux[2],"99").
    
  
  
  /* Code placed here will execute AFTER standard behavior.    */

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

    define input parameter c-per-ini as character format "9999/99".
    define input parameter c-per-fim as character format "9999/99".
    define input parameter i-moeda   as integer.
    define input parameter i-custo   as integer.


    {utp/ut-liter.i Total_da_Empresa * R}
    assign c-lb-emp:screen-value in frame {&frame-name} = return-value.

    find first moeda where moeda.mo-codigo = i-moeda no-lock no-error.
    if  avail moeda then do:
        if  i-moeda = 0 then do:
            {utp/ut-liter.i Corrente * L}
            assign c-moeda = return-value.
        end.
        else assign c-moeda = moeda.descricao.
    end.

    assign de-var-ent3 = 0
           de-total-ent3 = 0
           de-total-ent4 = 0
           de-var-sd3 = 0
           de-total-saida3 = 0
           de-total-saida4 = 0
           de-var-med3 = 0
           de-est-med3 = 0
           de-est-med4 = 0
           de-var-exc3 = 0
           de-est-exc3 = 0
           de-est-exc4 = 0
           de-var-seg3 = 0
           de-est-seg3 = 0
           de-est-seg4 = 0
           de-var-ini3 = 0
           de-est-ini3 = 0
           de-est-ini4 = 0
           de-var-fim3 = 0
           de-est-fim3 = 0
           de-est-fim4 = 0
           de-var-gr3 = 0
           de-giro3 = 0
           de-giro4 = 0.       
           
         if i-moeda = 0 then assign i-mo = 1.
    else if i-moeda = 1 then assign i-mo = 2.
    else if i-moeda = 2 then assign i-mo = 3.
    
         if i-custo = 0 then
            assign i-custo = 1.


    &if defined (bf_mat_consumo_estab) &then
    
        for each estat-estab
           where estat-estab.periodo = c-per-ini or estat-estab.periodo = c-per-fim no-lock:
            if  estat-estab.periodo = c-per-ini then do:
                if  i-custo = 1 then
                    assign de-total-ent3   = de-total-ent3   + estat-estab.val-tot-entr-m[i-mo]
                           de-total-saida3 = de-total-saida3 + estat-estab.val-tot-sai-m[i-mo]
                           de-est-ini3     = de-est-ini3     + estat-estab.val-est-ini-m[i-mo]
                           de-est-med3     = de-est-med3     + estat-estab.val-est-med-m[i-mo]
                           de-est-seg3     = de-est-seg3     + estat-estab.val-est-seg-m[i-mo]
                           de-est-exc3     = de-est-exc3     + estat-estab.val-est-exced-m[i-mo]
                           de-est-fim3     = de-est-fim3     + estat-estab.val-est-fim-m[i-mo].
                if  i-custo = 2 then
                    assign de-total-ent3   = de-total-ent3   + estat-estab.val-tot-entr-o[i-mo]
                           de-total-saida3 = de-total-saida3 + estat-estab.val-tot-sai-o[i-mo]
                           de-est-ini3     = de-est-ini3     + estat-estab.val-est-ini-o[i-mo]
                           de-est-med3     = de-est-med3     + estat-estab.val-est-med-o[i-mo]
                           de-est-seg3     = de-est-seg3     + estat-estab.val-est-seg-o[i-mo]
                           de-est-exc3     = de-est-exc3     + estat-estab.val-est-exced-o[i-mo]
                           de-est-fim3     = de-est-fim3     + estat-estab.val-est-fim-o[i-mo].
                if  i-custo = 3 then
                    assign de-total-ent3   = de-total-ent3   + estat-estab.val-tot-entr-p[i-mo]
                           de-total-saida3 = de-total-saida3 + estat-estab.val-tot-sai-p[i-mo]
                           de-est-ini3     = de-est-ini3     + estat-estab.val-est-ini-p[i-mo]
                           de-est-med3     = de-est-med3     + estat-estab.val-est-med-p[i-mo]
                           de-est-seg3     = de-est-seg3     + estat-estab.val-est-seg-p[i-mo]
                           de-est-exc3     = de-est-exc3     + estat-estab.val-est-exced-p[i-mo]
                           de-est-fim3     = de-est-fim3     + estat-estab.val-est-fim-p[i-mo].
            end.
            else do:
                if  i-custo = 1 then
                    assign de-total-ent4   = de-total-ent4   + estat-estab.val-tot-entr-m[i-mo]
                           de-total-saida4 = de-total-saida4 + estat-estab.val-tot-sai-m[i-mo]
                           de-est-ini4     = de-est-ini4     + estat-estab.val-est-ini-m[i-mo]
                           de-est-med4     = de-est-med4     + estat-estab.val-est-med-m[i-mo]
                           de-est-seg4     = de-est-seg4     + estat-estab.val-est-seg-m[i-mo]
                           de-est-exc4     = de-est-exc4     + estat-estab.val-est-exced-m[i-mo]
                           de-est-fim4     = de-est-fim4     + estat-estab.val-est-fim-m[i-mo].
                if  i-custo = 2 then
                    assign de-total-ent4   = de-total-ent4   + estat-estab.val-tot-entr-o[i-mo]
                           de-total-saida4 = de-total-saida4 + estat-estab.val-tot-sai-o[i-mo]
                           de-est-ini4     = de-est-ini4     + estat-estab.val-est-ini-o[i-mo]
                           de-est-med4     = de-est-med4     + estat-estab.val-est-med-o[i-mo]
                           de-est-seg4     = de-est-seg4     + estat-estab.val-est-seg-o[i-mo]
                           de-est-exc4     = de-est-exc4     + estat-estab.val-est-exced-o[i-mo]
                           de-est-fim4     = de-est-fim4     + estat-estab.val-est-fim-o[i-mo].
                if  i-custo = 3 then
                    assign de-total-ent4   = de-total-ent4   + estat-estab.val-tot-entr-p[i-mo]
                           de-total-saida4 = de-total-saida4 + estat-estab.val-tot-sai-p[i-mo]
                           de-est-ini4     = de-est-ini4     + estat-estab.val-est-ini-p[i-mo]
                           de-est-med4     = de-est-med4     + estat-estab.val-est-med-p[i-mo]
                           de-est-seg4     = de-est-seg4     + estat-estab.val-est-seg-p[i-mo]
                           de-est-exc4     = de-est-exc4     + estat-estab.val-est-exced-p[i-mo]
                           de-est-fim4     = de-est-fim4     + estat-estab.val-est-fim-p[i-mo].
            end.
        end.


    &else

        for each estat-ce no-lock
            where estat-ce.periodo = c-per-ini or estat-ce.periodo = c-per-fim:
            if  estat-ce.periodo = c-per-ini then do:
                if  i-custo = 1 then
                    assign de-total-ent3   = de-total-ent3   + estat-ce.val-tot-entr-m[i-mo]
                           de-total-saida3 = de-total-saida3 + estat-ce.val-tot-sai-m[i-mo]
                           de-est-ini3     = de-est-ini3     + estat-ce.val-est-ini-m[i-mo]
                           de-est-med3     = de-est-med3     + estat-ce.val-est-med-m[i-mo]
                           de-est-seg3     = de-est-seg3     + estat-ce.val-est-seg-m[i-mo]
                           de-est-exc3     = de-est-exc3     + estat-ce.val-est-exced-m[i-mo]
                           de-est-fim3     = de-est-fim3     + estat-ce.val-est-fim-m[i-mo].
                if  i-custo = 2 then
                    assign de-total-ent3   = de-total-ent3   + estat-ce.val-tot-entr-o[i-mo]
                           de-total-saida3 = de-total-saida3 + estat-ce.val-tot-sai-o[i-mo]
                           de-est-ini3     = de-est-ini3     + estat-ce.val-est-ini-o[i-mo]
                           de-est-med3     = de-est-med3     + estat-ce.val-est-med-o[i-mo]
                           de-est-seg3     = de-est-seg3     + estat-ce.val-est-seg-o[i-mo]
                           de-est-exc3     = de-est-exc3     + estat-ce.val-est-exced-o[i-mo]
                           de-est-fim3     = de-est-fim3     + estat-ce.val-est-fim-o[i-mo].
                if  i-custo = 3 then
                    assign de-total-ent3   = de-total-ent3   + estat-ce.val-tot-entr-p[i-mo]
                           de-total-saida3 = de-total-saida3 + estat-ce.val-tot-sai-p[i-mo]
                           de-est-ini3     = de-est-ini3     + estat-ce.val-est-ini-p[i-mo]
                           de-est-med3     = de-est-med3     + estat-ce.val-est-med-p[i-mo]
                           de-est-seg3     = de-est-seg3     + estat-ce.val-est-seg-p[i-mo]
                           de-est-exc3     = de-est-exc3     + estat-ce.val-est-exced-p[i-mo]
                           de-est-fim3     = de-est-fim3     + estat-ce.val-est-fim-p[i-mo].
            end.
            else do:
                if  i-custo = 1 then
                    assign de-total-ent4   = de-total-ent4   + estat-ce.val-tot-entr-m[i-mo]
                           de-total-saida4 = de-total-saida4 + estat-ce.val-tot-sai-m[i-mo]
                           de-est-ini4     = de-est-ini4     + estat-ce.val-est-ini-m[i-mo]
                           de-est-med4     = de-est-med4     + estat-ce.val-est-med-m[i-mo]
                           de-est-seg4     = de-est-seg4     + estat-ce.val-est-seg-m[i-mo]
                           de-est-exc4     = de-est-exc4     + estat-ce.val-est-exced-m[i-mo]
                           de-est-fim4     = de-est-fim4     + estat-ce.val-est-fim-m[i-mo].
                if  i-custo = 2 then
                    assign de-total-ent4   = de-total-ent4   + estat-ce.val-tot-entr-o[i-mo]
                           de-total-saida4 = de-total-saida4 + estat-ce.val-tot-sai-o[i-mo]
                           de-est-ini4     = de-est-ini4     + estat-ce.val-est-ini-o[i-mo]
                           de-est-med4     = de-est-med4     + estat-ce.val-est-med-o[i-mo]
                           de-est-seg4     = de-est-seg4     + estat-ce.val-est-seg-o[i-mo]
                           de-est-exc4     = de-est-exc4     + estat-ce.val-est-exced-o[i-mo]
                           de-est-fim4     = de-est-fim4     + estat-ce.val-est-fim-o[i-mo].
                if  i-custo = 3 then
                    assign de-total-ent4   = de-total-ent4   + estat-ce.val-tot-entr-p[i-mo]
                           de-total-saida4 = de-total-saida4 + estat-ce.val-tot-sai-p[i-mo]
                           de-est-ini4     = de-est-ini4     + estat-ce.val-est-ini-p[i-mo]
                           de-est-med4     = de-est-med4     + estat-ce.val-est-med-p[i-mo]
                           de-est-seg4     = de-est-seg4     + estat-ce.val-est-seg-p[i-mo]
                           de-est-exc4     = de-est-exc4     + estat-ce.val-est-exced-p[i-mo]
                           de-est-fim4     = de-est-fim4     + estat-ce.val-est-fim-p[i-mo].
            end.
        end.
    
    &endif
    
    assign de-giro3 = de-total-saida3 / de-est-med3 * 100.
    if  de-giro3 = ? then
        assign de-giro3 = 0.
    assign de-giro4 = de-total-saida4 / de-est-med4 * 100.
    if  de-giro4 = ? then
        assign de-giro4 = 0.
     
    assign de-var-ent3 = (de-total-ent4 / de-total-ent3) * 100 - 100.

    if (de-total-ent3 = 0) and (de-total-ent4 > 0) then 
        assign de-var-ent3 = 100.     
    if de-total-ent3 = 0 and de-total-ent4 = 0 then
        assign de-var-ent3 = 0.
    if  de-var-ent3 = ? then
        assign de-var-ent3 = 0.
        
    assign de-var-sd3 = (de-total-saida4 / de-total-saida3) * 100 - 100.
    if (de-total-saida3 = 0) and (de-total-saida4 > 0) then 
        assign de-var-sd3 = 100.          
    if  de-var-sd3 = ? then
        assign de-var-sd3 = 0.
        
    assign de-var-med3 = (de-est-med4 / de-est-med3) * 100 - 100.
    if (de-est-med3 = 0) and (de-est-med4 > 0) then 
        assign de-var-med3 = 100.         
    if  de-var-med3 = ? then
        assign de-var-med3 = 0.
        
    assign de-var-exc3 = (de-est-exc4 / de-est-exc3) * 100 - 100.
    if (de-est-exc3 = 0) and (de-est-exc4 > 0) then 
        assign de-var-exc3 = 100.         
    if  de-var-exc3 = ? then
        assign de-var-exc3 = 0.
        
    assign de-var-seg3 = (de-est-seg4 / de-est-seg3) * 100 - 100.
    if (de-est-seg3 = 0) and (de-est-seg4 > 0) then 
        assign de-var-seg3 = 100.         
    if  de-var-seg3 = ? then
        assign de-var-seg3 = 0.
        
    assign de-var-ini3 = (de-est-ini4 / de-est-ini3) * 100 - 100.
    if (de-est-ini3 = 0) and (de-est-ini4 > 0) then 
        assign de-var-ini3 = 100.         
    if  de-var-ini3 = ? then
        assign de-var-ini3 = 0.
        
    assign de-var-fim3 = (de-est-fim4 / de-est-fim3) * 100 - 100.
    if (de-est-fim3 = 0) and (de-est-fim4 > 0) then 
        assign de-var-fim3 = 100.         
    if  de-var-fim3 = ? then
        assign de-var-fim3 = 0.
        
    assign de-var-gr3 = (de-giro4 / de-giro3) * 100 - 100.
    if (de-giro3 = 0) and (de-giro4 > 0) then 
        assign de-var-gr3 = 100.         
    if  de-var-gr3 = ? then
        assign de-var-gr3 = 0.


    assign i-mes-aux[1] = integer(substring(c-per-ini,5,2))
           i-mes-aux[2] = integer(substring(c-per-fim,5,2))
           c-ext[1]     = tabela[i-mes-aux[1]]
           c-ext[2]     = tabela[i-mes-aux[2]]
           i-ano[1]     = integer(substring(c-per-ini,1,4))
           i-ano[2]     = integer(substring(c-per-fim,1,4)).

    assign c-per-ini = string(i-ano[1]) + string(i-mes-aux[1],"99")
           c-per-fim = string(i-ano[2]) + string(i-mes-aux[2],"99").
    assign c-per-ini1:screen-value in frame {&frame-name} = c-per-ini
           c-per-fim1:screen-value in frame {&frame-name} = c-per-fim.
    assign c-per-ini1 = c-per-ini
           c-per-fim1 = c-per-fim.

    assign de-total-ent1:screen-value   in frame {&frame-name} = string(de-total-ent3)
           de-total-ent2:screen-value   in frame {&frame-name} = string(de-total-ent4)
           
           de-total-saida1:screen-value in frame {&frame-name} = string(de-total-saida3)
           de-total-saida2:screen-value in frame {&frame-name} = string(de-total-saida4)
           
           de-est-med1:screen-value     in frame {&frame-name} = string(de-est-med3)
           de-est-med2:screen-value     in frame {&frame-name} = string(de-est-med4)
           
           de-est-exc1:screen-value     in frame {&frame-name} = string(de-est-exc3)
           de-est-exc2:screen-value     in frame {&frame-name} = string(de-est-exc4)

           de-est-seg1:screen-value     in frame {&frame-name} = string(de-est-seg3)
           de-est-seg2:screen-value     in frame {&frame-name} = string(de-est-seg4)

           de-est-ini1:screen-value     in frame {&frame-name} = string(de-est-ini3)          
           de-est-ini2:screen-value     in frame {&frame-name} = string(de-est-ini4)

           de-est-fim1:screen-value     in frame {&frame-name} = string(de-est-fim3)
           de-est-fim2:screen-value     in frame {&frame-name} = string(de-est-fim4)
           
           de-giro1:screen-value        in frame {&frame-name} = string(de-giro3)
           de-giro2:screen-value        in frame {&frame-name} = string(de-giro4)

           de-var-ent1:screen-value     in frame {&frame-name} = string(de-var-ent3)
           de-var-sd1:screen-value      in frame {&frame-name} = string(de-var-sd3)
           de-var-ini1:screen-value     in frame {&frame-name} = string(de-var-ini3)
           de-var-med1:screen-value     in frame {&frame-name} = string(de-var-med3)
           de-var-seg1:screen-value     in frame {&frame-name} = string(de-var-seg3)
           de-var-exc1:screen-value     in frame {&frame-name} = string(de-var-exc3)
           de-var-fim1:screen-value     in frame {&frame-name} = string(de-var-fim3) 
           de-var-gr1:screen-value      in frame {&frame-name} = string(de-var-gr3) .


           

disp c-per-ini1
     c-per-fim1
     c-moeda
     with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-param1 V-table-Win 
PROCEDURE pi-seta-param1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define input parameter c-per-ini    as character format "9999/99".
    define input parameter c-per-fim    as character format "9999/99".
    define input parameter c-fm-codigo  like item.fm-codigo.
    define input parameter i-moeda      as integer.
    define input parameter i-custo      as integer.


    {utp/ut-field.i mgind item fm-codigo 1}
    assign c-lb-emp:screen-value in frame {&frame-name} = return-value.

    find first familia
        where familia.fm-codigo = c-fm-codigo no-lock no-error.
    if  avail familia then
        assign c-fm-codigo1:screen-value in frame {&frame-name} = c-fm-codigo
               c-desc-fam:screen-value   in frame {&frame-name} = familia.descricao.

    find first moeda where moeda.mo-codigo = i-moeda no-lock no-error.
    if  avail moeda then do:
        if  i-moeda = 0 then do:
            {utp/ut-liter.i Corrente * L}
            assign c-moeda = return-value.
        end.
        else assign c-moeda = moeda.descricao.
    end.

    assign de-var-ent3 = 0
           de-total-ent3 = 0
           de-total-ent4 = 0
           de-var-sd3 = 0
           de-total-saida3 = 0
           de-total-saida4 = 0
           de-var-med3 = 0
           de-est-med3 = 0
           de-est-med4 = 0
           de-var-exc3 = 0
           de-est-exc3 = 0
           de-est-exc4 = 0
           de-var-seg3 = 0
           de-est-seg3 = 0
           de-est-seg4 = 0
           de-var-ini3 = 0
           de-est-ini3 = 0
           de-est-ini4 = 0
           de-var-fim3 = 0
           de-est-fim3 = 0
           de-est-fim4 = 0
           de-var-gr3 = 0
           de-giro3 = 0
           de-giro4 = 0.       

         if i-moeda = 0 then assign i-mo = 1.
    else if i-moeda = 1 then assign i-mo = 2.
    else if i-moeda = 2 then assign i-mo = 3.

         if i-custo = 0 then
            assign i-custo = 1. 

    &if defined (bf_mat_consumo_estab) &then
    
        for each estat-estab
           where estat-estab.fm-codigo = c-fm-codigo
             AND (estat-estab.periodo = c-per-ini or estat-estab.periodo = c-per-fim) no-lock:
            if  estat-estab.periodo = c-per-ini then do:
                assign de-total-ent3 = de-total-ent3 + estat-estab.entradas-tot[i-mo].
                if  i-custo = 1 then
                    assign de-total-ent3   = de-total-ent3   + estat-estab.val-tot-entr-m[i-mo]
                           de-total-saida3 = de-total-saida3 + estat-estab.val-tot-sai-m[i-mo]
                           de-est-ini3 = de-est-ini3 + estat-estab.val-est-ini-m[i-mo]
                           de-est-med3 = de-est-med3 + estat-estab.val-est-med-m[i-mo]
                           de-est-seg3 = de-est-seg3 + estat-estab.val-est-seg-m[i-mo]
                           de-est-exc3 = de-est-exc3 + estat-estab.val-est-exced-m[i-mo]
                           de-est-fim3 = de-est-fim3 + estat-estab.val-est-fim-m[i-mo].
                if  i-custo = 2 then
                    assign de-total-ent3   = de-total-ent3   + estat-estab.val-tot-entr-o[i-mo]
                           de-total-saida3 = de-total-saida3 + estat-estab.val-tot-sai-o[i-mo]
                           de-est-ini3 = de-est-ini3 + estat-estab.val-est-ini-o[i-mo]
                           de-est-med3 = de-est-med3 + estat-estab.val-est-med-o[i-mo]
                           de-est-seg3 = de-est-seg3 + estat-estab.val-est-seg-o[i-mo]
                           de-est-exc3 = de-est-exc3 + estat-estab.val-est-exced-o[i-mo]
                           de-est-fim3 = de-est-fim3 + estat-estab.val-est-fim-o[i-mo].
                if  i-custo = 3 then
                    assign de-total-ent3   = de-total-ent3   + estat-estab.val-tot-entr-p[i-mo]
                           de-total-saida3 = de-total-saida3 + estat-estab.val-tot-sai-p[i-mo]
                           de-est-ini3 = de-est-ini3 + estat-estab.val-est-ini-p[i-mo]
                           de-est-med3 = de-est-med3 + estat-estab.val-est-med-p[i-mo]
                           de-est-seg3 = de-est-seg3 + estat-estab.val-est-seg-p[i-mo]
                           de-est-exc3 = de-est-exc3 + estat-estab.val-est-exced-p[i-mo]
                           de-est-fim3 = de-est-fim3 + estat-estab.val-est-fim-p[i-mo].
            end.
            else do:
                assign de-total-ent4 = de-total-ent4 + estat-estab.entradas-tot[i-mo].
                if  i-custo = 1 then
                    assign de-total-ent4   = de-total-ent4   + estat-estab.val-tot-entr-m[i-mo]
                           de-total-saida4 = de-total-saida4 + estat-estab.val-tot-sai-m[i-mo]
                           de-est-ini4 = de-est-ini4 + estat-estab.val-est-ini-m[i-mo]
                           de-est-med4 = de-est-med4 + estat-estab.val-est-med-m[i-mo]
                           de-est-seg4 = de-est-seg4 + estat-estab.val-est-seg-m[i-mo]
                           de-est-exc4 = de-est-exc4 + estat-estab.val-est-exced-m[i-mo]
                           de-est-fim4 = de-est-fim4 + estat-estab.val-est-fim-m[i-mo].
                if  i-custo = 2 then
                    assign de-total-ent4   = de-total-ent4   + estat-estab.val-tot-entr-o[i-mo]
                           de-total-saida4 = de-total-saida4 + estat-estab.val-tot-sai-o[i-mo]
                           de-est-ini4 = de-est-ini4 + estat-estab.val-est-ini-o[i-mo]
                           de-est-med4 = de-est-med4 + estat-estab.val-est-med-o[i-mo]
                           de-est-seg4 = de-est-seg4 + estat-estab.val-est-seg-o[i-mo]
                           de-est-exc4 = de-est-exc4 + estat-estab.val-est-exced-o[i-mo]
                           de-est-fim4 = de-est-fim4 + estat-estab.val-est-fim-o[i-mo].
                if  i-custo = 3 then
                    assign de-total-ent4   = de-total-ent4   + estat-estab.val-tot-entr-p[i-mo]
                           de-total-saida4 = de-total-saida4 + estat-estab.val-tot-sai-p[i-mo]
                           de-est-ini4 = de-est-ini4 + estat-estab.val-est-ini-p[i-mo]
                           de-est-med4 = de-est-med4 + estat-estab.val-est-med-p[i-mo]
                           de-est-seg4 = de-est-seg4 + estat-estab.val-est-seg-p[i-mo]
                           de-est-exc4 = de-est-exc4 + estat-estab.val-est-exced-p[i-mo]
                           de-est-fim4 = de-est-fim4 + estat-estab.val-est-fim-p[i-mo].
            end.
        end.


    &else

        for each estat-ce
            WHERE estat-ce.fm-codigo = c-fm-codigo 
             AND (estat-ce.periodo = c-per-ini or estat-ce.periodo = c-per-fim) no-lock:
            if  estat-ce.periodo = c-per-ini then do:
                assign de-total-ent3 = de-total-ent3 + estat-ce.entradas-tot[i-mo].
                if  i-custo = 1 then
                    assign de-total-ent3   = de-total-ent3   + estat-ce.val-tot-entr-m[i-mo]
                           de-total-saida3 = de-total-saida3 + estat-ce.val-tot-sai-m[i-mo]
                           de-est-ini3 = de-est-ini3 + estat-ce.val-est-ini-m[i-mo]
                           de-est-med3 = de-est-med3 + estat-ce.val-est-med-m[i-mo]
                           de-est-seg3 = de-est-seg3 + estat-ce.val-est-seg-m[i-mo]
                           de-est-exc3 = de-est-exc3 + estat-ce.val-est-exced-m[i-mo]
                           de-est-fim3 = de-est-fim3 + estat-ce.val-est-fim-m[i-mo].
                if  i-custo = 2 then
                    assign de-total-ent3   = de-total-ent3   + estat-ce.val-tot-entr-o[i-mo]
                           de-total-saida3 = de-total-saida3 + estat-ce.val-tot-sai-o[i-mo]
                           de-est-ini3 = de-est-ini3 + estat-ce.val-est-ini-o[i-mo]
                           de-est-med3 = de-est-med3 + estat-ce.val-est-med-o[i-mo]
                           de-est-seg3 = de-est-seg3 + estat-ce.val-est-seg-o[i-mo]
                           de-est-exc3 = de-est-exc3 + estat-ce.val-est-exced-o[i-mo]
                           de-est-fim3 = de-est-fim3 + estat-ce.val-est-fim-o[i-mo].
                if  i-custo = 3 then
                    assign de-total-ent3   = de-total-ent3   + estat-ce.val-tot-entr-p[i-mo]
                           de-total-saida3 = de-total-saida3 + estat-ce.val-tot-sai-p[i-mo]
                           de-est-ini3 = de-est-ini3 + estat-ce.val-est-ini-p[i-mo]
                           de-est-med3 = de-est-med3 + estat-ce.val-est-med-p[i-mo]
                           de-est-seg3 = de-est-seg3 + estat-ce.val-est-seg-p[i-mo]
                           de-est-exc3 = de-est-exc3 + estat-ce.val-est-exced-p[i-mo]
                           de-est-fim3 = de-est-fim3 + estat-ce.val-est-fim-p[i-mo].
            end.
            else do:
                assign de-total-ent4 = de-total-ent4 + estat-ce.entradas-tot[i-mo].
                if  i-custo = 1 then
                    assign de-total-ent4   = de-total-ent4   + estat-ce.val-tot-entr-m[i-mo]
                           de-total-saida4 = de-total-saida4 + estat-ce.val-tot-sai-m[i-mo]
                           de-est-ini4 = de-est-ini4 + estat-ce.val-est-ini-m[i-mo]
                           de-est-med4 = de-est-med4 + estat-ce.val-est-med-m[i-mo]
                           de-est-seg4 = de-est-seg4 + estat-ce.val-est-seg-m[i-mo]
                           de-est-exc4 = de-est-exc4 + estat-ce.val-est-exced-m[i-mo]
                           de-est-fim4 = de-est-fim4 + estat-ce.val-est-fim-m[i-mo].
                if  i-custo = 2 then
                    assign de-total-ent4   = de-total-ent4   + estat-ce.val-tot-entr-o[i-mo]
                           de-total-saida4 = de-total-saida4 + estat-ce.val-tot-sai-o[i-mo]
                           de-est-ini4 = de-est-ini4 + estat-ce.val-est-ini-o[i-mo]
                           de-est-med4 = de-est-med4 + estat-ce.val-est-med-o[i-mo]
                           de-est-seg4 = de-est-seg4 + estat-ce.val-est-seg-o[i-mo]
                           de-est-exc4 = de-est-exc4 + estat-ce.val-est-exced-o[i-mo]
                           de-est-fim4 = de-est-fim4 + estat-ce.val-est-fim-o[i-mo].
                if  i-custo = 3 then
                    assign de-total-ent4   = de-total-ent4   + estat-ce.val-tot-entr-p[i-mo]
                           de-total-saida4 = de-total-saida4 + estat-ce.val-tot-sai-p[i-mo]
                           de-est-ini4 = de-est-ini4 + estat-ce.val-est-ini-p[i-mo]
                           de-est-med4 = de-est-med4 + estat-ce.val-est-med-p[i-mo]
                           de-est-seg4 = de-est-seg4 + estat-ce.val-est-seg-p[i-mo]
                           de-est-exc4 = de-est-exc4 + estat-ce.val-est-exced-p[i-mo]
                           de-est-fim4 = de-est-fim4 + estat-ce.val-est-fim-p[i-mo].
            end.
        end.
    
    &endif
    
    assign de-giro3 = de-total-saida3 / de-est-med3 * 100.
    if  de-giro3 = ? then
        assign de-giro3 = 0.
    assign de-giro4 = de-total-saida4 / de-est-med4 * 100.
    if  de-giro4 = ? then
        assign de-giro4 = 0.
    assign de-var-ent3 = (de-total-ent4 / de-total-ent3) * 100 - 100.
    if  de-var-ent3 = ? then
        assign de-var-ent3 = 0.
    assign de-var-sd3 = (de-total-saida4 / de-total-saida3) * 100 - 100.
    if  de-var-sd3 = ? then
        assign de-var-sd3 = 0.
    assign de-var-med1 = (de-est-med4 / de-est-med3) * 100 - 100.
    if  de-var-med3 = ? then
        assign de-var-med3 = 0.
    assign de-var-exc3 = (de-est-exc4 / de-est-exc3) * 100 - 100.
    if  de-var-exc3 = ? then
        assign de-var-exc3 = 0.
    assign de-var-seg3 = (de-est-seg4 / de-est-seg3) * 100 - 100.
    if  de-var-seg3 = ? then
        assign de-var-seg3 = 0.
    assign de-var-ini3 = (de-est-ini4 / de-est-ini3) * 100 - 100.
    if  de-var-ini3 = ? then
        assign de-var-ini3 = 0.
    assign de-var-fim1 = (de-est-fim4 / de-est-fim3) * 100 - 100.
    if  de-var-fim3 = ? then
        assign de-var-fim3 = 0.
    assign de-var-gr3 = (de-giro4 / de-giro3) * 100 - 100.
    if  de-var-gr3 = ? then
        assign de-var-gr3 = 0.

    assign i-mes-aux[1] = integer(substring(c-per-ini,5,2))
           i-mes-aux[2] = integer(substring(c-per-fim,5,2))
           c-ext[1] = tabela[i-mes-aux[1]]
           c-ext[2] = tabela[i-mes-aux[2]]
           i-ano[1] = integer(substring(c-per-ini,1,4))
           i-ano[2] = integer(substring(c-per-fim,1,4)).

/*
    assign c-per-ini = string(i-ano[1]) + "/" + string(i-mes-aux[1])
           c-per-fim = string(i-ano[2]) + "/" + string(i-mes-aux[2]).
    assign c-per-ini1:screen-value in frame {&frame-name} = c-per-ini
           c-per-fim1:screen-value in frame {&frame-name} = c-per-fim.
    assign c-per-ini1 = c-per-ini
           c-per-fim1 = c-per-fim.
*/

    assign c-per-ini = string(i-ano[1]) +  string(i-mes-aux[1],"99")
           c-per-fim = string(i-ano[2]) +  string(i-mes-aux[2],"99").
    assign c-per-ini1:screen-value in frame {&frame-name} = c-per-ini
           c-per-fim1:screen-value in frame {&frame-name} = c-per-fim.
    assign c-per-ini1 = c-per-ini
           c-per-fim1 = c-per-fim.

    assign de-var-ent1:screen-value      in frame {&frame-name} = string(de-var-ent3)
            de-total-ent1:screen-value   in frame {&frame-name} = string(de-total-ent3)
            de-total-ent2:screen-value   in frame {&frame-name} = string(de-total-ent4)
            de-var-sd1:screen-value      in frame {&frame-name} = string(de-var-sd3)
            de-total-saida1:screen-value in frame {&frame-name} = string(de-total-saida3)
            de-total-saida2:screen-value in frame {&frame-name} = string(de-total-saida4)
            de-var-med1:screen-value     in frame {&frame-name} = string(de-var-med3)
            de-est-med1:screen-value     in frame {&frame-name} = string(de-est-med3)
            de-est-med2:screen-value     in frame {&frame-name} = string(de-est-med4)
            de-var-exc1:screen-value     in frame {&frame-name} = string(de-var-exc3)
            de-est-exc1:screen-value     in frame {&frame-name} = string(de-est-exc3)
            de-est-exc2:screen-value     in frame {&frame-name} = string(de-est-exc4)
            de-var-seg1:screen-value     in frame {&frame-name} = string(de-var-seg3)
            de-est-seg1:screen-value     in frame {&frame-name} = string(de-est-seg3)
            de-est-seg2:screen-value     in frame {&frame-name} = string(de-est-seg4)
            de-var-ini1:screen-value     in frame {&frame-name} = string(de-var-ini3)
            de-est-ini1:screen-value     in frame {&frame-name} = string(de-est-ini3)
            de-est-ini2:screen-value     in frame {&frame-name} = string(de-est-ini4)
            de-var-fim1:screen-value     in frame {&frame-name} = string(de-var-fim3)
            de-est-fim1:screen-value     in frame {&frame-name} = string(de-est-fim3)
            de-est-fim2:screen-value     in frame {&frame-name} = string(de-est-fim4)
            de-var-gr1:screen-value      in frame {&frame-name} = string(de-var-gr3)
            de-giro1:screen-value        in frame {&frame-name} = string(de-giro3)
            de-giro2:screen-value        in frame {&frame-name} = string(de-giro4).

disp /*
     c-ext[1]
     i-ano[1]
     c-ext[2]
     i-ano[2]
     */
     c-per-ini1
     c-per-fim1
     c-moeda
     with frame {&frame-name} .

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


