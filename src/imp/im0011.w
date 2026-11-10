&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0011 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0011 MIM}
&ENDIF

/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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

/* Parameters Definitions ---                                           */

def input parameter p-pedido as integer no-undo.
def input parameter p-cod-emitente-desp as integer no-undo.
def input parameter p-cod-desp as integer no-undo.
def input parameter p-datapedi as date no-undo.

/* Local Variable Definitions ---                                       */

def var i-total as integer no-undo.

def var i-perc-1 as integer no-undo.
def var i-perc-2 as integer no-undo.
def var i-perc-3 as integer no-undo.
def var i-perc-4 as integer no-undo.
def var i-perc-5 as integer no-undo.
def var i-perc-6 as integer no-undo.
def var i-perc-7 as integer no-undo.
def var i-perc-8 as integer no-undo.
def var i-perc-9 as integer no-undo.
def var i-perc-10 as integer no-undo.
def var i-perc-11 as integer no-undo.
def var i-perc-12 as integer no-undo.

def var l-existe as logical initial no.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key da-data-pagto-1 i-perc-pagto-1 ~
c-comentarios-1 rt-buttom bt-ok bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS i-num-pedido i-total-percentual ~
i-cod-emitente-desp i-cod-desp da-data-pagto-1 i-perc-pagto-1 ~
c-comentarios-1 da-data-pagto-2 i-perc-pagto-2 c-comentarios-2 ~
da-data-pagto-3 i-perc-pagto-3 c-comentarios-3 da-data-pagto-4 ~
i-perc-pagto-4 c-comentarios-4 da-data-pagto-5 i-perc-pagto-5 ~
c-comentarios-5 da-data-pagto-6 i-perc-pagto-6 c-comentarios-6 ~
da-data-pagto-7 i-perc-pagto-7 c-comentarios-7 da-data-pagto-8 ~
i-perc-pagto-8 c-comentarios-8 da-data-pagto-9 i-perc-pagto-9 ~
c-comentarios-9 da-data-pagto-10 i-perc-pagto-10 c-comentarios-10 ~
da-data-pagto-11 i-perc-pagto-11 c-comentarios-11 da-data-pagto-12 ~
i-perc-pagto-12 c-comentarios-12 c-num-pedido c-total c-cod-emitente-desp ~
c-cod-desp c-data c-percentual c-comentario 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-cod-desp AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-emitente-desp AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-comentario AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .63 NO-UNDO.

DEFINE VARIABLE c-comentarios-1 AS CHARACTER FORMAT "X(76)" 
     VIEW-AS FILL-IN 
     SIZE 59.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-comentarios-10 AS CHARACTER FORMAT "X(76)" 
     VIEW-AS FILL-IN 
     SIZE 59.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-comentarios-11 AS CHARACTER FORMAT "X(76)" 
     VIEW-AS FILL-IN 
     SIZE 59.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-comentarios-12 AS CHARACTER FORMAT "X(76)" 
     VIEW-AS FILL-IN 
     SIZE 59.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-comentarios-2 AS CHARACTER FORMAT "X(76)" 
     VIEW-AS FILL-IN 
     SIZE 59.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-comentarios-3 AS CHARACTER FORMAT "X(76)" 
     VIEW-AS FILL-IN 
     SIZE 59.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-comentarios-4 AS CHARACTER FORMAT "X(76)" 
     VIEW-AS FILL-IN 
     SIZE 59.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-comentarios-5 AS CHARACTER FORMAT "X(76)" 
     VIEW-AS FILL-IN 
     SIZE 59.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-comentarios-6 AS CHARACTER FORMAT "X(76)" 
     VIEW-AS FILL-IN 
     SIZE 59.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-comentarios-7 AS CHARACTER FORMAT "X(76)" 
     VIEW-AS FILL-IN 
     SIZE 59.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-comentarios-8 AS CHARACTER FORMAT "X(76)" 
     VIEW-AS FILL-IN 
     SIZE 59.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-comentarios-9 AS CHARACTER FORMAT "X(76)" 
     VIEW-AS FILL-IN 
     SIZE 59.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-data AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9 BY .63 NO-UNDO.

DEFINE VARIABLE c-num-pedido AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-percentual AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 5 BY .63 NO-UNDO.

DEFINE VARIABLE c-total AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .63 NO-UNDO.

DEFINE VARIABLE da-data-pagto-1 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-pagto-10 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-pagto-11 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-pagto-12 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-pagto-2 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-pagto-3 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-pagto-4 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-pagto-5 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-pagto-6 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-pagto-7 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-pagto-8 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-pagto-9 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-desp AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-desp AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-pedido AS INTEGER FORMAT ">>>>>,>>9" INITIAL 0 
     LABEL "":R8 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE i-perc-pagto-1 AS INTEGER FORMAT ">>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-perc-pagto-10 AS INTEGER FORMAT ">>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-perc-pagto-11 AS INTEGER FORMAT ">>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-perc-pagto-12 AS INTEGER FORMAT ">>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-perc-pagto-2 AS INTEGER FORMAT ">>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-perc-pagto-3 AS INTEGER FORMAT ">>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-perc-pagto-4 AS INTEGER FORMAT ">>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-perc-pagto-5 AS INTEGER FORMAT ">>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-perc-pagto-6 AS INTEGER FORMAT ">>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-perc-pagto-7 AS INTEGER FORMAT ">>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-perc-pagto-8 AS INTEGER FORMAT ">>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-perc-pagto-9 AS INTEGER FORMAT ">>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-total-percentual AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 84.43 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     i-num-pedido AT ROW 1.5 COL 23 COLON-ALIGNED
     i-total-percentual AT ROW 1.5 COL 75 COLON-ALIGNED
     i-cod-emitente-desp AT ROW 2.5 COL 23 COLON-ALIGNED
     i-cod-desp AT ROW 3.5 COL 23 COLON-ALIGNED
     da-data-pagto-1 AT ROW 5.75 COL 6 HELP
          "Informe a Data de Pagamento" NO-LABEL
     i-perc-pagto-1 AT ROW 5.75 COL 18 COLON-ALIGNED HELP
          "Percentual de Pagamento" NO-LABEL
     c-comentarios-1 AT ROW 5.75 COL 26 NO-LABEL
     da-data-pagto-2 AT ROW 6.75 COL 6 HELP
          "Informe a Data de Pagamento" NO-LABEL
     i-perc-pagto-2 AT ROW 6.75 COL 18 COLON-ALIGNED HELP
          "Percentual de Pagamento" NO-LABEL
     c-comentarios-2 AT ROW 6.75 COL 26 NO-LABEL
     da-data-pagto-3 AT ROW 7.75 COL 6 HELP
          "Informe a Data de Pagamento" NO-LABEL
     i-perc-pagto-3 AT ROW 7.75 COL 18 COLON-ALIGNED HELP
          "Percentual de Pagamento" NO-LABEL
     c-comentarios-3 AT ROW 7.75 COL 26 NO-LABEL
     da-data-pagto-4 AT ROW 8.75 COL 6 HELP
          "Informe a Data de Pagamento" NO-LABEL
     i-perc-pagto-4 AT ROW 8.75 COL 18 COLON-ALIGNED HELP
          "Percentual de Pagamento" NO-LABEL
     c-comentarios-4 AT ROW 8.75 COL 26 NO-LABEL
     da-data-pagto-5 AT ROW 9.75 COL 6 HELP
          "Informe a Data de Pagamento" NO-LABEL
     i-perc-pagto-5 AT ROW 9.75 COL 18 COLON-ALIGNED HELP
          "Percentual de Pagamento" NO-LABEL
     c-comentarios-5 AT ROW 9.75 COL 26 NO-LABEL
     da-data-pagto-6 AT ROW 10.75 COL 6 HELP
          "Informe a Data de Pagamento" NO-LABEL
     i-perc-pagto-6 AT ROW 10.75 COL 18 COLON-ALIGNED HELP
          "Percentual de Pagamento" NO-LABEL
     c-comentarios-6 AT ROW 10.75 COL 26 NO-LABEL
     da-data-pagto-7 AT ROW 11.75 COL 6 HELP
          "Informe a Data de Pagamento" NO-LABEL
     i-perc-pagto-7 AT ROW 11.75 COL 18 COLON-ALIGNED HELP
          "Percentual de Pagamento" NO-LABEL
     c-comentarios-7 AT ROW 11.75 COL 26 NO-LABEL
     da-data-pagto-8 AT ROW 12.75 COL 6 HELP
          "Informe a Data de Pagamento" NO-LABEL
     i-perc-pagto-8 AT ROW 12.75 COL 18 COLON-ALIGNED HELP
          "Percentual de Pagamento" NO-LABEL
     c-comentarios-8 AT ROW 12.75 COL 26 NO-LABEL
     da-data-pagto-9 AT ROW 13.75 COL 6 HELP
          "Informe a Data de Pagamento" NO-LABEL
     i-perc-pagto-9 AT ROW 13.75 COL 18 COLON-ALIGNED HELP
          "Percentual de Pagamento" NO-LABEL
     c-comentarios-9 AT ROW 13.75 COL 26 NO-LABEL
     da-data-pagto-10 AT ROW 14.75 COL 6 HELP
          "Informe a Data de Pagamento" NO-LABEL
     i-perc-pagto-10 AT ROW 14.75 COL 18 COLON-ALIGNED HELP
          "Percentual de Pagamento" NO-LABEL
     c-comentarios-10 AT ROW 14.75 COL 26 NO-LABEL
     da-data-pagto-11 AT ROW 15.75 COL 6 HELP
          "Informe a Data de Pagamento" NO-LABEL
     i-perc-pagto-11 AT ROW 15.75 COL 18 COLON-ALIGNED HELP
          "Percentual de Pagamento" NO-LABEL
     c-comentarios-11 AT ROW 15.75 COL 26 NO-LABEL
     da-data-pagto-12 AT ROW 16.75 COL 6 HELP
          "Informe a Data de Pagamento" NO-LABEL
     i-perc-pagto-12 AT ROW 16.75 COL 18 COLON-ALIGNED HELP
          "Percentual de Pagamento" NO-LABEL
     c-comentarios-12 AT ROW 16.75 COL 26 NO-LABEL
     bt-ok AT ROW 18.08 COL 3
     bt-cancela AT ROW 18.08 COL 14
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME D-Dialog
     bt-ajuda AT ROW 18.08 COL 75.43
     c-num-pedido AT ROW 1.5 COL 23 RIGHT-ALIGNED NO-LABEL
     c-total AT ROW 1.63 COL 58 COLON-ALIGNED NO-LABEL
     c-cod-emitente-desp AT ROW 2.5 COL 23 RIGHT-ALIGNED NO-LABEL
     c-cod-desp AT ROW 3.5 COL 23 RIGHT-ALIGNED NO-LABEL
     c-data AT ROW 5 COL 8 COLON-ALIGNED NO-LABEL
     c-percentual AT ROW 5 COL 18 COLON-ALIGNED NO-LABEL
     c-comentario AT ROW 5 COL 46 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1.25 COL 2
     "01 -" VIEW-AS TEXT
          SIZE 4 BY .63 AT ROW 5.83 COL 2
     "02 -" VIEW-AS TEXT
          SIZE 4 BY .63 AT ROW 6.83 COL 2
     "03 -" VIEW-AS TEXT
          SIZE 4 BY .63 AT ROW 7.83 COL 2
     "04 -" VIEW-AS TEXT
          SIZE 4 BY .63 AT ROW 8.83 COL 2
     "05 -" VIEW-AS TEXT
          SIZE 4 BY .63 AT ROW 9.83 COL 2
     "06 -" VIEW-AS TEXT
          SIZE 4 BY .63 AT ROW 10.83 COL 2
     "07 -" VIEW-AS TEXT
          SIZE 4 BY .63 AT ROW 11.83 COL 2
     "08 -" VIEW-AS TEXT
          SIZE 4 BY .63 AT ROW 12.83 COL 2
     "09 -" VIEW-AS TEXT
          SIZE 4 BY .63 AT ROW 13.83 COL 2
     "10 -" VIEW-AS TEXT
          SIZE 4 BY .63 AT ROW 14.83 COL 2
     "11 -" VIEW-AS TEXT
          SIZE 4 BY .63 AT ROW 15.83 COL 2
     "12 -" VIEW-AS TEXT
          SIZE 4 BY .63 AT ROW 16.83 COL 2
     rt-buttom AT ROW 17.83 COL 2
     SPACE(0.70) SKIP(0.16)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "<insert SmartDialog title>"
         DEFAULT-BUTTON bt-ok.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
                                                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-desp IN FRAME D-Dialog
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN c-cod-emitente-desp IN FRAME D-Dialog
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN c-comentario IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-comentarios-1 IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-comentarios-10 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-comentarios-11 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-comentarios-12 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-comentarios-2 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-comentarios-3 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-comentarios-4 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-comentarios-5 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-comentarios-6 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-comentarios-7 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-comentarios-8 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-comentarios-9 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-data IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-num-pedido IN FRAME D-Dialog
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN c-percentual IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-total IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-data-pagto-1 IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN da-data-pagto-10 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN da-data-pagto-11 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN da-data-pagto-12 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN da-data-pagto-2 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN da-data-pagto-3 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN da-data-pagto-4 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN da-data-pagto-5 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN da-data-pagto-6 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN da-data-pagto-7 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN da-data-pagto-8 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN da-data-pagto-9 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN i-cod-desp IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-emitente-desp IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-num-pedido IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-perc-pagto-10 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-perc-pagto-11 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-perc-pagto-12 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-perc-pagto-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-perc-pagto-3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-perc-pagto-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-perc-pagto-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-perc-pagto-6 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-perc-pagto-7 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-perc-pagto-8 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-perc-pagto-9 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-total-percentual IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-dialog.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* <insert SmartDialog title> */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda D-Dialog
ON CHOOSE OF bt-ajuda IN FRAME D-Dialog /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok D-Dialog
ON CHOOSE OF bt-ok IN FRAME D-Dialog /* OK */
DO:

    if i-total < 100 then do:
             run utp/ut-msgs.p (input "show",
                                input 1688,
                                input "").
             apply "entry" to i-perc-pagto-1 in frame {&frame-name}.
             return no-apply.
    end.      

  
    if input frame {&frame-name} da-data-pagto-2 = ? then do:
    if input frame {&frame-name} da-data-pagto-2 <
       input frame {&frame-name} da-data-pagto-1 then do:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-2 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_2" *}
             ASSIGN c-lbl-liter-data-de-pagamento-2 = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-1 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_1" *}
             ASSIGN c-lbl-liter-data-de-pagamento-1 = TRIM(RETURN-VALUE).
             run utp/ut-msgs.p (input "show",
                                input 1207,
                                input c-lbl-liter-data-de-pagamento-2 + "~~" +
                                      c-lbl-liter-data-de-pagamento-1).
             apply "entry" to da-data-pagto-2 in frame {&frame-name}.
             return no-apply.
    end.
    end.
    
    if input frame {&frame-name} da-data-pagto-3 = ? then do:
    if input frame {&frame-name} da-data-pagto-3 <
       input frame {&frame-name} da-data-pagto-2 then do:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-3 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_3" *}
             ASSIGN c-lbl-liter-data-de-pagamento-3 = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-4 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_2" *}
             ASSIGN c-lbl-liter-data-de-pagamento-4 = TRIM(RETURN-VALUE).
             run utp/ut-msgs.p (input "show",
                                input 1207,
                                input c-lbl-liter-data-de-pagamento-3 + "~~" +
                                      c-lbl-liter-data-de-pagamento-4).
             apply "entry" to da-data-pagto-3 in frame {&frame-name}.
             return no-apply.
    end.
    end.    
  
    if input frame {&frame-name} da-data-pagto-4 = ? then do:  
    if input frame {&frame-name} da-data-pagto-4 <
       input frame {&frame-name} da-data-pagto-3 then do:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-5 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_4" *}
             ASSIGN c-lbl-liter-data-de-pagamento-5 = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-6 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_3" *}
             ASSIGN c-lbl-liter-data-de-pagamento-6 = TRIM(RETURN-VALUE).
             run utp/ut-msgs.p (input "show",
                                input 1207,
                                input c-lbl-liter-data-de-pagamento-5 + "~~" +
                                      c-lbl-liter-data-de-pagamento-6).
             apply "entry" to da-data-pagto-4 in frame {&frame-name}.
             return no-apply.
    end.
    end.    
  
    if input frame {&frame-name} da-data-pagto-5 = ? then do:  
    if input frame {&frame-name} da-data-pagto-5 <
       input frame {&frame-name} da-data-pagto-4 then do:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-7 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_5" *}
             ASSIGN c-lbl-liter-data-de-pagamento-7 = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-8 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_4" *}
             ASSIGN c-lbl-liter-data-de-pagamento-8 = TRIM(RETURN-VALUE).
             run utp/ut-msgs.p (input "show",
                                input 1207,
                                input c-lbl-liter-data-de-pagamento-7 + "~~" +
                                      c-lbl-liter-data-de-pagamento-8).
             apply "entry" to da-data-pagto-5 in frame {&frame-name}.
             return no-apply.
    end.
    end.    
  
    if input frame {&frame-name} da-data-pagto-6 = ? then do:  
    if input frame {&frame-name} da-data-pagto-6 <
       input frame {&frame-name} da-data-pagto-5 then do:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-9 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_6" *}
             ASSIGN c-lbl-liter-data-de-pagamento-9 = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-10 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_5" *}
             ASSIGN c-lbl-liter-data-de-pagamento-10 = TRIM(RETURN-VALUE).
             run utp/ut-msgs.p (input "show",
                                input 1207,
                                input c-lbl-liter-data-de-pagamento-9 + "~~" +
                                      c-lbl-liter-data-de-pagamento-10).
             apply "entry" to da-data-pagto-6 in frame {&frame-name}.
             return no-apply.
    end.
    end.    
  
    if input frame {&frame-name} da-data-pagto-7 = ? then do:  
    if input frame {&frame-name} da-data-pagto-7 <
       input frame {&frame-name} da-data-pagto-6 then do:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-11 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_7" *}
             ASSIGN c-lbl-liter-data-de-pagamento-11 = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-12 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_6" *}
             ASSIGN c-lbl-liter-data-de-pagamento-12 = TRIM(RETURN-VALUE).
             run utp/ut-msgs.p (input "show",
                                input 1207,
                                input c-lbl-liter-data-de-pagamento-11 + "~~" +
                                      c-lbl-liter-data-de-pagamento-12).
             apply "entry" to da-data-pagto-7 in frame {&frame-name}.
             return no-apply.
    end.
    end.    
  
    if input frame {&frame-name} da-data-pagto-8 = ? then do:  
    if input frame {&frame-name} da-data-pagto-8 <
       input frame {&frame-name} da-data-pagto-7 then do:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-13 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_8" *}
             ASSIGN c-lbl-liter-data-de-pagamento-13 = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-14 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_7" *}
             ASSIGN c-lbl-liter-data-de-pagamento-14 = TRIM(RETURN-VALUE).
             run utp/ut-msgs.p (input "show",
                                input 1207,
                                input c-lbl-liter-data-de-pagamento-13 + "~~" +
                                      c-lbl-liter-data-de-pagamento-14).
             apply "entry" to da-data-pagto-8 in frame {&frame-name}.
             return no-apply.
    end.
    end.    
  
    if input frame {&frame-name} da-data-pagto-9 = ? then do:  
    if input frame {&frame-name} da-data-pagto-9 <
       input frame {&frame-name} da-data-pagto-8 then do:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-15 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_9" *}
             ASSIGN c-lbl-liter-data-de-pagamento-15 = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-16 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_8" *}
             ASSIGN c-lbl-liter-data-de-pagamento-16 = TRIM(RETURN-VALUE).
             run utp/ut-msgs.p (input "show",
                                input 1207,
                                input c-lbl-liter-data-de-pagamento-15 + "~~" +
                                      c-lbl-liter-data-de-pagamento-16).
             apply "entry" to da-data-pagto-9 in frame {&frame-name}.
             return no-apply.
    end.
    end.    
  
    if input frame {&frame-name} da-data-pagto-10 = ? then do:  
    if input frame {&frame-name} da-data-pagto-10 <
       input frame {&frame-name} da-data-pagto-9 then do:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-17 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_10" *}
             ASSIGN c-lbl-liter-data-de-pagamento-17 = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-18 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_9" *}
             ASSIGN c-lbl-liter-data-de-pagamento-18 = TRIM(RETURN-VALUE).
             run utp/ut-msgs.p (input "show",
                                input 1207,
                                input c-lbl-liter-data-de-pagamento-17 + "~~" +
                                      c-lbl-liter-data-de-pagamento-18).
             apply "entry" to da-data-pagto-10 in frame {&frame-name}.
             return no-apply.
    end.
    end.    
  
    if input frame {&frame-name} da-data-pagto-11 = ? then do:  
    if input frame {&frame-name} da-data-pagto-11 <
       input frame {&frame-name} da-data-pagto-10 then do:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-19 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_11" *}
             ASSIGN c-lbl-liter-data-de-pagamento-19 = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-20 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_10" *}
             ASSIGN c-lbl-liter-data-de-pagamento-20 = TRIM(RETURN-VALUE).
             run utp/ut-msgs.p (input "show",
                                input 1207,
                                input c-lbl-liter-data-de-pagamento-19 + "~~" +
                                      c-lbl-liter-data-de-pagamento-20).
             apply "entry" to da-data-pagto-11 in frame {&frame-name}.
             return no-apply.
    end.
    end.    
  
    if input frame {&frame-name} da-data-pagto-12 = ? then do:  
    if input frame {&frame-name} da-data-pagto-12 <
       input frame {&frame-name} da-data-pagto-11 then do:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-21 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_12" *}
             ASSIGN c-lbl-liter-data-de-pagamento-21 = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-data-de-pagamento-22 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Data_de_Pagamento_11" *}
             ASSIGN c-lbl-liter-data-de-pagamento-22 = TRIM(RETURN-VALUE).
             run utp/ut-msgs.p (input "show",
                                input 1207,
                                input c-lbl-liter-data-de-pagamento-21 + "~~" +
                                      c-lbl-liter-data-de-pagamento-22).
             apply "entry" to da-data-pagto-12 in frame {&frame-name}.
             return no-apply.
    end.
    end.    
    
    if (input frame {&frame-name} da-data-pagto-1 <> ? and 
       input frame {&frame-name} i-perc-pagto-1 = 0) or
       (input frame {&frame-name} da-data-pagto-1 = ? and
       input frame {&frame-name} i-perc-pagto-1 <> 0) then do:
            run utp/ut-msgs.p (input "show",
                               input 1669,
                               input "").
            apply "entry" to da-data-pagto-1 in frame {&frame-name}.
            return no-apply.
    end.           

    if (input frame {&frame-name} da-data-pagto-2 <> ? and 
       input frame {&frame-name} i-perc-pagto-2 = 0) or
       (input frame {&frame-name} da-data-pagto-2 = ? and
       input frame {&frame-name} i-perc-pagto-2 <> 0) then do:
            run utp/ut-msgs.p (input "show",
                               input 1669,
                               input "").
            apply "entry" to da-data-pagto-2 in frame {&frame-name}.
            return no-apply.
    end.           

    if (input frame {&frame-name} da-data-pagto-3 <> ? and 
       input frame {&frame-name} i-perc-pagto-3 = 0) or
       (input frame {&frame-name} da-data-pagto-3 = ? and
       input frame {&frame-name} i-perc-pagto-3 <> 0) then do:
            run utp/ut-msgs.p (input "show",
                               input 1669,
                               input "").
            apply "entry" to da-data-pagto-3 in frame {&frame-name}.
            return no-apply.
    end.           

    if (input frame {&frame-name} da-data-pagto-4 <> ? and 
       input frame {&frame-name} i-perc-pagto-4 = 0) or
       (input frame {&frame-name} da-data-pagto-4 = ? and
       input frame {&frame-name} i-perc-pagto-4 <> 0) then do:
            run utp/ut-msgs.p (input "show",
                               input 1669,
                               input "").
            apply "entry" to da-data-pagto-4 in frame {&frame-name}.
            return no-apply.
    end.           

    if (input frame {&frame-name} da-data-pagto-5 <> ? and 
       input frame {&frame-name} i-perc-pagto-5 = 0) or
       (input frame {&frame-name} da-data-pagto-5 = ? and
       input frame {&frame-name} i-perc-pagto-5 <> 0) then do:
            run utp/ut-msgs.p (input "show",
                               input 1669,
                               input "").
            apply "entry" to da-data-pagto-5 in frame {&frame-name}.
            return no-apply.
    end.           

    if (input frame {&frame-name} da-data-pagto-6 <> ? and 
       input frame {&frame-name} i-perc-pagto-6 = 0) or
       (input frame {&frame-name} da-data-pagto-6 = ? and
       input frame {&frame-name} i-perc-pagto-6 <> 0) then do:
            run utp/ut-msgs.p (input "show",
                               input 1669,
                               input "").
            apply "entry" to da-data-pagto-6 in frame {&frame-name}.
            return no-apply.
    end.           

    if (input frame {&frame-name} da-data-pagto-7 <> ? and 
       input frame {&frame-name} i-perc-pagto-7 = 0) or
       (input frame {&frame-name} da-data-pagto-7 = ? and
       input frame {&frame-name} i-perc-pagto-7 <> 0) then do:
            run utp/ut-msgs.p (input "show",
                               input 1669,
                               input "").
            apply "entry" to da-data-pagto-7 in frame {&frame-name}.
            return no-apply.
    end.           

    if (input frame {&frame-name} da-data-pagto-8 <> ? and 
       input frame {&frame-name} i-perc-pagto-8 = 0) or
       (input frame {&frame-name} da-data-pagto-8 = ? and
       input frame {&frame-name} i-perc-pagto-8 <> 0) then do:
            run utp/ut-msgs.p (input "show",
                               input 1669,
                               input "").
            apply "entry" to da-data-pagto-8 in frame {&frame-name}.
            return no-apply.
    end.           

    if (input frame {&frame-name} da-data-pagto-9 <> ? and 
       input frame {&frame-name} i-perc-pagto-9 = 0) or
       (input frame {&frame-name} da-data-pagto-9 = ? and
       input frame {&frame-name} i-perc-pagto-9 <> 0) then do:
            run utp/ut-msgs.p (input "show",
                               input 1669,
                               input "").
            apply "entry" to da-data-pagto-9 in frame {&frame-name}.
            return no-apply.
    end.           

    if (input frame {&frame-name} da-data-pagto-10 <> ? and 
       input frame {&frame-name} i-perc-pagto-10 = 0) or
       (input frame {&frame-name} da-data-pagto-10 = ? and
       input frame {&frame-name} i-perc-pagto-10 <> 0) then do:
            run utp/ut-msgs.p (input "show",
                               input 1669,
                               input "").
            apply "entry" to da-data-pagto-10 in frame {&frame-name}.
            return no-apply.
    end.           

    if (input frame {&frame-name} da-data-pagto-11 <> ? and 
       input frame {&frame-name} i-perc-pagto-11 = 0) or
       (input frame {&frame-name} da-data-pagto-11 = ? and
       input frame {&frame-name} i-perc-pagto-11 <> 0) then do:
            run utp/ut-msgs.p (input "show",
                               input 1669,
                               input "").
            apply "entry" to da-data-pagto-11 in frame {&frame-name}.
            return no-apply.
    end.           

    if (input frame {&frame-name} da-data-pagto-12 <> ? and 
       input frame {&frame-name} i-perc-pagto-12 = 0) or
       (input frame {&frame-name} da-data-pagto-12 = ? and
       input frame {&frame-name} i-perc-pagto-12 <> 0) then do:
            run utp/ut-msgs.p (input "show",
                               input 1669,
                               input "").
            apply "entry" to da-data-pagto-12 in frame {&frame-name}.
            return no-apply.
    end.           


    if l-existe = no then do:
        create cond-especif-cex.
    end.
    assign cond-especif-cex.num-pedido        = p-pedido
           cond-especif-cex.cod-emitente-desp = p-cod-emitente-desp
           cond-especif-cex.cod-desp          = p-cod-desp
           cond-especif-cex.data-pagto[1] = input frame {&frame-name} da-data-pagto-1
           cond-especif-cex.perc-pagto[1] = input frame {&frame-name} i-perc-pagto-1
           cond-especif-cex.comentarios[1] = input frame {&frame-name} c-comentarios-1
           cond-especif-cex.data-pagto[2] = input frame {&frame-name} da-data-pagto-2
           cond-especif-cex.perc-pagto[2] = input frame {&frame-name} i-perc-pagto-2
           cond-especif-cex.comentarios[2] = input frame {&frame-name} c-comentarios-2
           cond-especif-cex.data-pagto[3] = input frame {&frame-name} da-data-pagto-3
           cond-especif-cex.perc-pagto[3] = input frame {&frame-name} i-perc-pagto-3
           cond-especif-cex.comentarios[3] = input frame {&frame-name} c-comentarios-3
           cond-especif-cex.data-pagto[4] = input frame {&frame-name} da-data-pagto-4
           cond-especif-cex.perc-pagto[4] = input frame {&frame-name} i-perc-pagto-4
           cond-especif-cex.comentarios[4] = input frame {&frame-name} c-comentarios-4
           cond-especif-cex.data-pagto[5] = input frame {&frame-name} da-data-pagto-5
           cond-especif-cex.perc-pagto[5] = input frame {&frame-name} i-perc-pagto-5
           cond-especif-cex.comentarios[5] = input frame {&frame-name} c-comentarios-5
           cond-especif-cex.data-pagto[6] = input frame {&frame-name} da-data-pagto-6
           cond-especif-cex.perc-pagto[6] = input frame {&frame-name} i-perc-pagto-6
           cond-especif-cex.comentarios[6] = input frame {&frame-name} c-comentarios-6
           cond-especif-cex.data-pagto[7] = input frame {&frame-name} da-data-pagto-7
           cond-especif-cex.perc-pagto[7] = input frame {&frame-name} i-perc-pagto-7
           cond-especif-cex.comentarios[7] = input frame {&frame-name} c-comentarios-7
           cond-especif-cex.data-pagto[8] = input frame {&frame-name} da-data-pagto-8
           cond-especif-cex.perc-pagto[8] = input frame {&frame-name} i-perc-pagto-8
           cond-especif-cex.comentarios[8] = input frame {&frame-name} c-comentarios-8
           cond-especif-cex.data-pagto[9] = input frame {&frame-name} da-data-pagto-9
           cond-especif-cex.perc-pagto[9] = input frame {&frame-name} i-perc-pagto-9
           cond-especif-cex.comentarios[9] = input frame {&frame-name} c-comentarios-9
           cond-especif-cex.data-pagto[10] = input frame {&frame-name} da-data-pagto-10
           cond-especif-cex.perc-pagto[10] = input frame {&frame-name} i-perc-pagto-10
           cond-especif-cex.comentarios[10] = input frame {&frame-name} c-comentarios-10
           cond-especif-cex.data-pagto[11] = input frame {&frame-name} da-data-pagto-11
           cond-especif-cex.perc-pagto[11] = input frame {&frame-name} i-perc-pagto-11
           cond-especif-cex.comentarios[11] = input frame {&frame-name} c-comentarios-11
           cond-especif-cex.data-pagto[12] = input frame {&frame-name} da-data-pagto-12
           cond-especif-cex.perc-pagto[12] = input frame {&frame-name} i-perc-pagto-12
           cond-especif-cex.comentarios[12] = input frame {&frame-name} c-comentarios-12.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-comentarios-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comentarios-1 D-Dialog
ON LEAVE OF c-comentarios-1 IN FRAME D-Dialog
DO:    
    enable da-data-pagto-2 i-perc-pagto-2 c-comentarios-2 with frame {&frame-name}.
    apply "entry" to da-data-pagto-2 in frame {&frame-name}. 
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-comentarios-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comentarios-10 D-Dialog
ON LEAVE OF c-comentarios-10 IN FRAME D-Dialog
DO:
            enable da-data-pagto-11 with frame {&frame-name}.
            enable i-perc-pagto-11 with frame {&frame-name}.
            enable c-comentarios-11 with frame {&frame-name}.
            apply "entry" to da-data-pagto-11 in frame {&frame-name}.
            return no-apply.            
            
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-comentarios-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comentarios-11 D-Dialog
ON LEAVE OF c-comentarios-11 IN FRAME D-Dialog
DO:
            enable da-data-pagto-12 with frame {&frame-name}.
            enable i-perc-pagto-12 with frame {&frame-name}.
            enable c-comentarios-12 with frame {&frame-name}.
            apply "entry" to da-data-pagto-12 in frame {&frame-name}.
            return no-apply.            
            
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-comentarios-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comentarios-2 D-Dialog
ON LEAVE OF c-comentarios-2 IN FRAME D-Dialog
DO:
            enable da-data-pagto-3 with frame {&frame-name}.
            enable i-perc-pagto-3 with frame {&frame-name}.
            enable c-comentarios-3 with frame {&frame-name}.
            apply "entry" to da-data-pagto-3 in frame {&frame-name}.
            return no-apply.            
            
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-comentarios-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comentarios-3 D-Dialog
ON LEAVE OF c-comentarios-3 IN FRAME D-Dialog
DO:
            enable da-data-pagto-4 with frame {&frame-name}.
            enable i-perc-pagto-4 with frame {&frame-name}.
            enable c-comentarios-4 with frame {&frame-name}.
            apply "entry" to da-data-pagto-4 in frame {&frame-name}.
            return no-apply.            
            
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-comentarios-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comentarios-4 D-Dialog
ON LEAVE OF c-comentarios-4 IN FRAME D-Dialog
DO:
            enable da-data-pagto-5 with frame {&frame-name}.
            enable i-perc-pagto-5 with frame {&frame-name}.
            enable c-comentarios-5 with frame {&frame-name}.
            apply "entry" to da-data-pagto-5 in frame {&frame-name}.
            return no-apply.            
            
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-comentarios-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comentarios-5 D-Dialog
ON LEAVE OF c-comentarios-5 IN FRAME D-Dialog
DO:
            enable da-data-pagto-6 with frame {&frame-name}.
            enable i-perc-pagto-6 with frame {&frame-name}.
            enable c-comentarios-6 with frame {&frame-name}.
            apply "entry" to da-data-pagto-6 in frame {&frame-name}.
            return no-apply.            
            
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-comentarios-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comentarios-6 D-Dialog
ON LEAVE OF c-comentarios-6 IN FRAME D-Dialog
DO:
            enable da-data-pagto-7 with frame {&frame-name}.
            enable i-perc-pagto-7 with frame {&frame-name}.
            enable c-comentarios-7 with frame {&frame-name}.
            apply "entry" to da-data-pagto-7 in frame {&frame-name}.
            return no-apply.            
            
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-comentarios-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comentarios-7 D-Dialog
ON LEAVE OF c-comentarios-7 IN FRAME D-Dialog
DO:
            enable da-data-pagto-8 with frame {&frame-name}.
            enable i-perc-pagto-8 with frame {&frame-name}.
            enable c-comentarios-8 with frame {&frame-name}.
            apply "entry" to da-data-pagto-8 in frame {&frame-name}.
            return no-apply.            
            
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-comentarios-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comentarios-8 D-Dialog
ON LEAVE OF c-comentarios-8 IN FRAME D-Dialog
DO:
            enable da-data-pagto-9 with frame {&frame-name}.
            enable i-perc-pagto-9 with frame {&frame-name}.
            enable c-comentarios-9 with frame {&frame-name}.
            apply "entry" to da-data-pagto-9 in frame {&frame-name}.
            return no-apply.            
            
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-comentarios-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-comentarios-9 D-Dialog
ON LEAVE OF c-comentarios-9 IN FRAME D-Dialog
DO:
            enable da-data-pagto-10 with frame {&frame-name}.
            enable i-perc-pagto-10 with frame {&frame-name}.
            enable c-comentarios-10 with frame {&frame-name}.
            apply "entry" to da-data-pagto-10 in frame {&frame-name}.
            return no-apply.            
            
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-data-pagto-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-data-pagto-1 D-Dialog
ON LEAVE OF da-data-pagto-1 IN FRAME D-Dialog
DO:
    if input frame {&frame-name} da-data-pagto-1 < p-datapedi then do:
         run utp/ut-msgs.p (input "show",
                            input 1687,
                            input "").
         apply "entry" to da-data-pagto-1 in frame {&frame-name}.
         return no-apply.
    end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-perc-pagto-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-perc-pagto-1 D-Dialog
ON LEAVE OF i-perc-pagto-1 IN FRAME D-Dialog
DO:
  
        if (( i-total - i-perc-1 ) + input frame {&frame-name} i-perc-pagto-1) > 100 then do:
            run utp/ut-msgs.p (input "show",
                               input 1684,
                               input "").
            assign i-perc-pagto-1 = i-perc-1.
            display i-perc-pagto-1 with frame {&frame-name}.
            apply "entry" to i-perc-pagto-1 in frame {&frame-name}.
            return no-apply.            
        end.
        else do:
            assign i-total = (( i-total - i-perc-1) + input frame {&frame-name} i-perc-pagto-1).
            assign i-perc-1 = input frame {&frame-name} i-perc-pagto-1.
            assign i-total-percentual = i-total.
            display i-total-percentual with frame {&frame-name}.
        end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-perc-pagto-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-perc-pagto-10 D-Dialog
ON LEAVE OF i-perc-pagto-10 IN FRAME D-Dialog
DO:
  
        if (( i-total - i-perc-10 ) + input frame {&frame-name} i-perc-pagto-10) > 100 then do:
            run utp/ut-msgs.p (input "show",
                               input 1684,
                               input "").
            assign i-perc-pagto-10 = i-perc-10.
            display i-perc-pagto-10 with frame {&frame-name}.
            apply "entry" to i-perc-pagto-10 in frame {&frame-name}.
            return no-apply.            
        end.
        else do:
            assign i-total = (( i-total - i-perc-10) + input frame {&frame-name} i-perc-pagto-10).
            assign i-perc-10 = input frame {&frame-name} i-perc-pagto-10.
            assign i-total-percentual = i-total.
            display i-total-percentual with frame {&frame-name}.
        end.

  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-perc-pagto-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-perc-pagto-11 D-Dialog
ON LEAVE OF i-perc-pagto-11 IN FRAME D-Dialog
DO:
  
        if (( i-total - i-perc-11 ) + input frame {&frame-name} i-perc-pagto-11) > 100 then do:
            run utp/ut-msgs.p (input "show",
                               input 1684,
                               input "").
            assign i-perc-pagto-11 = i-perc-11.
            display i-perc-pagto-11 with frame {&frame-name}.
            apply "entry" to i-perc-pagto-11 in frame {&frame-name}.
            return no-apply.            
        end.
        else do:
            assign i-total = (( i-total - i-perc-11) + input frame {&frame-name} i-perc-pagto-11).
            assign i-perc-11 = input frame {&frame-name} i-perc-pagto-11.
            assign i-total-percentual = i-total.
            display i-total-percentual with frame {&frame-name}.
        end.

  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-perc-pagto-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-perc-pagto-12 D-Dialog
ON LEAVE OF i-perc-pagto-12 IN FRAME D-Dialog
DO:
  
        if (( i-total - i-perc-12 ) + input frame {&frame-name} i-perc-pagto-12) > 100 then do:
            run utp/ut-msgs.p (input "show",
                               input 1684,
                               input "").
            assign i-perc-pagto-12 = i-perc-12.
            display i-perc-pagto-12 with frame {&frame-name}.
            apply "entry" to i-perc-pagto-12 in frame {&frame-name}.
            return no-apply.            
        end.
        else do:
            assign i-total = (( i-total - i-perc-12) + input frame {&frame-name} i-perc-pagto-12).
            assign i-perc-12 = input frame {&frame-name} i-perc-pagto-12.
            assign i-total-percentual = i-total.
            display i-total-percentual with frame {&frame-name}.
        end.
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-perc-pagto-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-perc-pagto-2 D-Dialog
ON LEAVE OF i-perc-pagto-2 IN FRAME D-Dialog
DO:

        if (( i-total - i-perc-2 ) + input frame {&frame-name} i-perc-pagto-2) > 100 then do:
            run utp/ut-msgs.p (input "show",
                               input 1684,
                               input "").
            assign i-perc-pagto-2 = i-perc-2.
            display i-perc-pagto-2 with frame {&frame-name}.
            apply "entry" to i-perc-pagto-2 in frame {&frame-name}.
            return no-apply.            
        end.
        else do:
            assign i-total = (( i-total - i-perc-2) + input frame {&frame-name} i-perc-pagto-2).
            assign i-perc-2 = input frame {&frame-name} i-perc-pagto-2.
            assign i-total-percentual = i-total.
            display i-total-percentual with frame {&frame-name}.
        end.


  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-perc-pagto-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-perc-pagto-3 D-Dialog
ON LEAVE OF i-perc-pagto-3 IN FRAME D-Dialog
DO:
  
        if (( i-total - i-perc-3 ) + input frame {&frame-name} i-perc-pagto-3) > 100 then do:
            run utp/ut-msgs.p (input "show",
                               input 1684,
                               input "").
            assign i-perc-pagto-3 = i-perc-3.
            display i-perc-pagto-3 with frame {&frame-name}.
            apply "entry" to i-perc-pagto-3 in frame {&frame-name}.
            return no-apply.            
        end.
        else do:
            assign i-total = (( i-total - i-perc-3) + input frame {&frame-name} i-perc-pagto-3).
            assign i-perc-3 = input frame {&frame-name} i-perc-pagto-3.
            assign i-total-percentual = i-total.
            display i-total-percentual with frame {&frame-name}.
        end.

  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-perc-pagto-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-perc-pagto-4 D-Dialog
ON LEAVE OF i-perc-pagto-4 IN FRAME D-Dialog
DO:
  
        if (( i-total - i-perc-4 ) + input frame {&frame-name} i-perc-pagto-4) > 100 then do:
            run utp/ut-msgs.p (input "show",
                               input 1684,
                               input "").
            assign i-perc-pagto-4 = i-perc-4.
            display i-perc-pagto-4 with frame {&frame-name}.
            apply "entry" to i-perc-pagto-4 in frame {&frame-name}.
            return no-apply.            
        end.
        else do:
            assign i-total = (( i-total - i-perc-4) + input frame {&frame-name} i-perc-pagto-4).
            assign i-perc-4 = input frame {&frame-name} i-perc-pagto-4.
            assign i-total-percentual = i-total.
            display i-total-percentual with frame {&frame-name}.
        end.

  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-perc-pagto-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-perc-pagto-5 D-Dialog
ON LEAVE OF i-perc-pagto-5 IN FRAME D-Dialog
DO:
  
        if (( i-total - i-perc-5 ) + input frame {&frame-name} i-perc-pagto-5) > 100 then do:
            run utp/ut-msgs.p (input "show",
                               input 1684,
                               input "").
            assign i-perc-pagto-5 = i-perc-5.
            display i-perc-pagto-5 with frame {&frame-name}.
            apply "entry" to i-perc-pagto-5 in frame {&frame-name}.
            return no-apply.            
        end.
        else do:
            assign i-total = (( i-total - i-perc-5) + input frame {&frame-name} i-perc-pagto-5).
            assign i-perc-5 = input frame {&frame-name} i-perc-pagto-5.
            assign i-total-percentual = i-total.
            display i-total-percentual with frame {&frame-name}.
        end.

  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-perc-pagto-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-perc-pagto-6 D-Dialog
ON LEAVE OF i-perc-pagto-6 IN FRAME D-Dialog
DO:
  
        if (( i-total - i-perc-6 ) + input frame {&frame-name} i-perc-pagto-6) > 100 then do:
            run utp/ut-msgs.p (input "show",
                               input 1684,
                               input "").
            assign i-perc-pagto-6 = i-perc-6.
            display i-perc-pagto-6 with frame {&frame-name}.
            apply "entry" to i-perc-pagto-6 in frame {&frame-name}.
            return no-apply.            
        end.
        else do:
            assign i-total = (( i-total - i-perc-6) + input frame {&frame-name} i-perc-pagto-6).
            assign i-perc-6 = input frame {&frame-name} i-perc-pagto-6.
            assign i-total-percentual = i-total.
            display i-total-percentual with frame {&frame-name}.
        end.

  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-perc-pagto-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-perc-pagto-7 D-Dialog
ON LEAVE OF i-perc-pagto-7 IN FRAME D-Dialog
DO:
  
        if (( i-total - i-perc-7 ) + input frame {&frame-name} i-perc-pagto-7) > 100 then do:
            run utp/ut-msgs.p (input "show",
                               input 1684,
                               input "").
            assign i-perc-pagto-7 = i-perc-7.
            display i-perc-pagto-7 with frame {&frame-name}.
            apply "entry" to i-perc-pagto-7 in frame {&frame-name}.
            return no-apply.            
        end.
        else do:
            assign i-total = (( i-total - i-perc-7) + input frame {&frame-name} i-perc-pagto-7).
            assign i-perc-7 = input frame {&frame-name} i-perc-pagto-7.
            assign i-total-percentual = i-total.
            display i-total-percentual with frame {&frame-name}.
        end.

  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-perc-pagto-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-perc-pagto-8 D-Dialog
ON LEAVE OF i-perc-pagto-8 IN FRAME D-Dialog
DO:
  
        if (( i-total - i-perc-8 ) + input frame {&frame-name} i-perc-pagto-8) > 100 then do:
            run utp/ut-msgs.p (input "show",
                               input 1684,
                               input "").
            assign i-perc-pagto-8 = i-perc-8.
            display i-perc-pagto-8 with frame {&frame-name}.
            apply "entry" to i-perc-pagto-8 in frame {&frame-name}.
            return no-apply.            
        end.
        else do:
            assign i-total = (( i-total - i-perc-8) + input frame {&frame-name} i-perc-pagto-8).
            assign i-perc-8 = input frame {&frame-name} i-perc-pagto-8.
            assign i-total-percentual = i-total.
            display i-total-percentual with frame {&frame-name}.
        end.

  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-perc-pagto-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-perc-pagto-9 D-Dialog
ON LEAVE OF i-perc-pagto-9 IN FRAME D-Dialog
DO:
  
        if (( i-total - i-perc-9 ) + input frame {&frame-name} i-perc-pagto-9) > 100 then do:
            run utp/ut-msgs.p (input "show",
                               input 1684,
                               input "").
            assign i-perc-pagto-9 = i-perc-9.
            display i-perc-pagto-9 with frame {&frame-name}.
            apply "entry" to i-perc-pagto-9 in frame {&frame-name}.
            return no-apply.            
        end.
        else do:
            assign i-total = (( i-total - i-perc-9) + input frame {&frame-name} i-perc-pagto-9).
            assign i-perc-9 = input frame {&frame-name} i-perc-pagto-9.
            assign i-total-percentual = i-total.
            display i-total-percentual with frame {&frame-name}.
        end.

  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY i-num-pedido i-total-percentual i-cod-emitente-desp i-cod-desp 
          da-data-pagto-1 i-perc-pagto-1 c-comentarios-1 da-data-pagto-2 
          i-perc-pagto-2 c-comentarios-2 da-data-pagto-3 i-perc-pagto-3 
          c-comentarios-3 da-data-pagto-4 i-perc-pagto-4 c-comentarios-4 
          da-data-pagto-5 i-perc-pagto-5 c-comentarios-5 da-data-pagto-6 
          i-perc-pagto-6 c-comentarios-6 da-data-pagto-7 i-perc-pagto-7 
          c-comentarios-7 da-data-pagto-8 i-perc-pagto-8 c-comentarios-8 
          da-data-pagto-9 i-perc-pagto-9 c-comentarios-9 da-data-pagto-10 
          i-perc-pagto-10 c-comentarios-10 da-data-pagto-11 i-perc-pagto-11 
          c-comentarios-11 da-data-pagto-12 i-perc-pagto-12 c-comentarios-12 
          c-num-pedido c-total c-cod-emitente-desp c-cod-desp c-data 
          c-percentual c-comentario 
      WITH FRAME D-Dialog.
  ENABLE rt-key da-data-pagto-1 i-perc-pagto-1 c-comentarios-1 rt-buttom bt-ok 
         bt-cancela bt-ajuda 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy D-Dialog 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
{utp/ut9000.i "IM0011" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    {utp/ut-liter.i Data * R}
    assign c-data = return-value.
    display c-data with frame {&frame-name}.

    {utp/ut-liter.i Perc. * R}
    assign c-percentual = return-value.
    display c-percentual with frame {&frame-name}.

    {utp/ut-liter.i Coment rio * R}
    assign c-comentario = return-value.
    display c-comentario with frame {&frame-name}.

    {utp/ut-liter.i Total_Percentual * R}
    assign c-total = return-value.
    display c-total with frame {&frame-name}.
    
    {utp/ut-field.i mgcex cond-especif-cex num-pedido 1}
    assign c-num-pedido = return-value.
    display c-num-pedido with frame {&frame-name}.    
    
    {utp/ut-field.i mgcex cond-especif-cex cod-emitente-desp 1}
    assign c-cod-emitente-desp = return-value.
    display c-cod-emitente-desp with frame {&frame-name}.
    
    {utp/ut-field.i mgcex cond-especif-cex cod-desp 1}
    assign c-cod-desp = return-value.
    display c-cod-desp with frame {&frame-name}.   

    display p-pedido @ i-num-pedido 
            p-cod-emitente-desp @ i-cod-emitente-desp 
            p-cod-desp @ i-cod-desp with frame {&frame-name}.

    FOR FIRST cond-especif-cex 
        where cond-especif-cex.num-pedido = p-pedido NO-LOCK:
        assign l-existe = yes.
        assign i-total = 0.
        if cond-especif-cex.data-pagto[1] <> ? then do:
            display cond-especif-cex.data-pagto[1] @ da-data-pagto-1 with frame {&frame-name}.
            display cond-especif-cex.perc-pagto[1] @ i-perc-pagto-1 with frame {&frame-name}.
            display cond-especif-cex.comentarios[1] @ c-comentarios-1 with frame {&frame-name}.
            assign i-total = i-total + cond-especif-cex.perc-pagto[1].
        end.
        if cond-especif-cex.data-pagto[2] <> ? then do:
            display cond-especif-cex.data-pagto[2] @ da-data-pagto-2 with frame {&frame-name}.
            display cond-especif-cex.perc-pagto[2] @ i-perc-pagto-2 with frame {&frame-name}.
            display cond-especif-cex.comentarios[2] @ c-comentarios-2 with frame {&frame-name}.
            assign i-total = i-total + cond-especif-cex.perc-pagto[2].
            enable da-data-pagto-2 with frame {&frame-name}.
            enable i-perc-pagto-2 with frame {&frame-name}.
            enable c-comentarios-2 with frame {&frame-name}.
        end.
        if cond-especif-cex.data-pagto[3] <> ? then do:
            display cond-especif-cex.data-pagto[3] @ da-data-pagto-3 with frame {&frame-name}.
            display cond-especif-cex.perc-pagto[3] @ i-perc-pagto-3 with frame {&frame-name}.
            display cond-especif-cex.comentarios[3] @ c-comentarios-3 with frame {&frame-name}.
            assign i-total = i-total + cond-especif-cex.perc-pagto[3].
            enable da-data-pagto-3 with frame {&frame-name}.
            enable i-perc-pagto-3 with frame {&frame-name}.
            enable c-comentarios-3 with frame {&frame-name}.
        end.
        if cond-especif-cex.data-pagto[4] <> ? then do:
            display cond-especif-cex.data-pagto[4] @ da-data-pagto-4 with frame {&frame-name}.
            display cond-especif-cex.perc-pagto[4] @ i-perc-pagto-4 with frame {&frame-name}.
            display cond-especif-cex.comentarios[4] @ c-comentarios-4 with frame {&frame-name}.
            assign i-total = i-total + cond-especif-cex.perc-pagto[4].
            enable da-data-pagto-4 with frame {&frame-name}.
            enable i-perc-pagto-4 with frame {&frame-name}.
            enable c-comentarios-4 with frame {&frame-name}.
        end.
        if cond-especif-cex.data-pagto[5] <> ? then do:
            display cond-especif-cex.data-pagto[5] @ da-data-pagto-5 with frame {&frame-name}.
            display cond-especif-cex.perc-pagto[5] @ i-perc-pagto-5 with frame {&frame-name}.
            display cond-especif-cex.comentarios[5] @ c-comentarios-5 with frame {&frame-name}.
            assign i-total = i-total + cond-especif-cex.perc-pagto[5].
            enable da-data-pagto-5 with frame {&frame-name}.
            enable i-perc-pagto-5 with frame {&frame-name}.
            enable c-comentarios-5 with frame {&frame-name}.
        end.
        if cond-especif-cex.data-pagto[6] <> ? then do:
            display cond-especif-cex.data-pagto[6] @ da-data-pagto-6 with frame {&frame-name}.
            display cond-especif-cex.perc-pagto[6] @ i-perc-pagto-6 with frame {&frame-name}.
            display cond-especif-cex.comentarios[6] @ c-comentarios-6 with frame {&frame-name}.
            assign i-total = i-total + cond-especif-cex.perc-pagto[6].
            enable da-data-pagto-6 with frame {&frame-name}.
            enable i-perc-pagto-6 with frame {&frame-name}.
            enable c-comentarios-6 with frame {&frame-name}.
        end.
        if cond-especif-cex.data-pagto[7] <> ? then do:
            display cond-especif-cex.data-pagto[7] @ da-data-pagto-7 with frame {&frame-name}.
            display cond-especif-cex.perc-pagto[7] @ i-perc-pagto-7 with frame {&frame-name}.
            display cond-especif-cex.comentarios[7] @ c-comentarios-7 with frame {&frame-name}.
            assign i-total = i-total + cond-especif-cex.perc-pagto[7].
            enable da-data-pagto-7 with frame {&frame-name}.
            enable i-perc-pagto-7 with frame {&frame-name}.
            enable c-comentarios-7 with frame {&frame-name}.
        end.
        if cond-especif-cex.data-pagto[8] <> ? then do:
            display cond-especif-cex.data-pagto[8] @ da-data-pagto-8 with frame {&frame-name}.
            display cond-especif-cex.perc-pagto[8] @ i-perc-pagto-8 with frame {&frame-name}.
            display cond-especif-cex.comentarios[8] @ c-comentarios-8 with frame {&frame-name}.
            assign i-total = i-total + cond-especif-cex.perc-pagto[8].
            enable da-data-pagto-8 with frame {&frame-name}.
            enable i-perc-pagto-8 with frame {&frame-name}.
            enable c-comentarios-8 with frame {&frame-name}.
        end.
        if cond-especif-cex.data-pagto[9] <> ? then do:
            display cond-especif-cex.data-pagto[9] @ da-data-pagto-9 with frame {&frame-name}.
            display cond-especif-cex.perc-pagto[9] @ i-perc-pagto-9 with frame {&frame-name}.
            display cond-especif-cex.comentarios[9] @ c-comentarios-9 with frame {&frame-name}.
            assign i-total = i-total + cond-especif-cex.perc-pagto[9].
            enable da-data-pagto-9 with frame {&frame-name}.
            enable i-perc-pagto-9 with frame {&frame-name}.
            enable c-comentarios-9 with frame {&frame-name}.
        end.
        if cond-especif-cex.data-pagto[10] <> ? then do:
            display cond-especif-cex.data-pagto[10] @ da-data-pagto-10 with frame {&frame-name}.
            display cond-especif-cex.perc-pagto[10] @ i-perc-pagto-10 with frame {&frame-name}.
            display cond-especif-cex.comentarios[10] @ c-comentarios-10 with frame {&frame-name}.
            assign i-total = i-total + cond-especif-cex.perc-pagto[10].
            enable da-data-pagto-10 with frame {&frame-name}.
            enable i-perc-pagto-10 with frame {&frame-name}.
            enable c-comentarios-10 with frame {&frame-name}.
        end.
        if cond-especif-cex.data-pagto[11] <> ? then do:
            display cond-especif-cex.data-pagto[11] @ da-data-pagto-11 with frame {&frame-name}.
            display cond-especif-cex.perc-pagto[11] @ i-perc-pagto-11 with frame {&frame-name}.
            display cond-especif-cex.comentarios[11] @ c-comentarios-11 with frame {&frame-name}.
            assign i-total = i-total + cond-especif-cex.perc-pagto[11].
            enable da-data-pagto-11 with frame {&frame-name}.
            enable i-perc-pagto-11 with frame {&frame-name}.
            enable c-comentarios-11 with frame {&frame-name}.
        end.
        if cond-especif-cex.data-pagto[12] <> ? then do:
            display cond-especif-cex.data-pagto[12] @ da-data-pagto-12 with frame {&frame-name}.
            display cond-especif-cex.perc-pagto[12] @ i-perc-pagto-12 with frame {&frame-name}.
            display cond-especif-cex.comentarios[12] @ c-comentarios-12 with frame {&frame-name}.
            assign i-total = i-total + cond-especif-cex.perc-pagto[12].
            enable da-data-pagto-12 with frame {&frame-name}.
            enable i-perc-pagto-12 with frame {&frame-name}.
            enable c-comentarios-12 with frame {&frame-name}.
        end.
        assign i-perc-1 = cond-especif-cex.perc-pagto[1]
               i-perc-2 = cond-especif-cex.perc-pagto[2]            
               i-perc-3 = cond-especif-cex.perc-pagto[3]            
               i-perc-4 = cond-especif-cex.perc-pagto[4]            
               i-perc-5 = cond-especif-cex.perc-pagto[5]            
               i-perc-6 = cond-especif-cex.perc-pagto[6]            
               i-perc-7 = cond-especif-cex.perc-pagto[7]            
               i-perc-8 = cond-especif-cex.perc-pagto[8]            
               i-perc-9 = cond-especif-cex.perc-pagto[9]            
               i-perc-10 = cond-especif-cex.perc-pagto[10]            
               i-perc-11 = cond-especif-cex.perc-pagto[11]            
               i-perc-12 = cond-especif-cex.perc-pagto[12].
    end.
    IF NOT AVAIL cond-especif-cex THEN
        assign l-existe = no.
    display i-total @ i-total-percentual with frame {&frame-name}.
    
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


