&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V03IN218 2.00.00.025} /*** "010025" 09/01/2026 14:41:40  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i V03IN218 MUT}
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

def new global shared var c-estab       like saldo-estoq.cod-estabel no-undo.
def new global shared var c-it-codigo   like item.it-codigo no-undo. 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var l-deleta-erros as logical no-undo.
def var h-janela1      as handle  no-undo.
def var da-inspecao    as date    no-undo.
def var c-op-des1      as char    no-undo.
def var r-rej1         as rowid   no-undo.

DEF VAR l-leitura-item-fornec-estab AS LOGICAL NO-UNDO.
DEF VAR severa-normal-lote        AS INT NO-UNDO.
DEF VAR severa-normal-rejeitado   AS INT NO-UNDO.
DEF VAR normal-severa-lote        AS INT NO-UNDO.
DEF VAR normal-severa-rejeitado   AS INT NO-UNDO.
DEF VAR normal-atenuada-lote      AS INT NO-UNDO.
DEF VAR normal-atenuada-rejeitado AS INT NO-UNDO.
DEF VAR atenuada-normal-lote      AS INT NO-UNDO.
DEF VAR atenuada-normal-rejeitado AS INT NO-UNDO.

def buffer b-saldo     for saldo-estoq.

{cep/ceapi001.i}
{cdp/cd0666.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES movto-estoq item saldo-estoq
&Scoped-define FIRST-EXTERNAL-TABLE movto-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-estoq, item, saldo-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-estoq.un movto-estoq.quantidade 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}un ~{&FP2}un ~{&FP3}~
 ~{&FP1}quantidade ~{&FP2}quantidade ~{&FP3}
&Scoped-define ENABLED-TABLES movto-estoq
&Scoped-define FIRST-ENABLED-TABLE movto-estoq
&Scoped-Define ENABLED-OBJECTS RECT-2 rt-mold RECT-13 RECT-14 c-cod-depos ~
dt-vali 
&Scoped-Define DISPLAYED-FIELDS movto-estoq.dt-trans ~
movto-estoq.serie-docto movto-estoq.nro-docto movto-estoq.it-codigo ~
item.desc-item item.cod-localiz movto-estoq.un movto-estoq.quantidade ~
movto-estoq.cod-estabel movto-estoq.cod-depos movto-estoq.cod-localiz ~
movto-estoq.lote saldo-estoq.dt-vali-lote movto-estoq.cod-refer 
&Scoped-Define DISPLAYED-OBJECTS c-conta c-cod-estabel c-cod-depos ~
c-cod-localiz c-lote dt-vali c-cod-refer c-saida 

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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-c-cod-depos 
       MENU-ITEM mZoomDep       LABEL "Zoom de Dep¢sito"
       MENU-ITEM mZoomSalDep    LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-c-cod-localiz 
       MENU-ITEM mZoomLoc       LABEL "Zoom de Localizaá∆o"
       MENU-ITEM mZoomSaldLoc   LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-c-cod-refer 
       MENU-ITEM mZoomRefer     LABEL "Zoom de Referància"
       MENU-ITEM mZoomSalRef    LABEL "Zoom de Saldos".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cod-depos AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-localiz AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-refer AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-conta AS CHARACTER FORMAT "x(17)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 23.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-entrada AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .67 NO-UNDO.

DEFINE VARIABLE c-lote AS CHARACTER FORMAT "X(10)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-saida AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9.72 BY .67 NO-UNDO.

DEFINE VARIABLE dt-vali AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37 BY 6.5.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38.29 BY 6.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 76 BY 4.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 76 BY 3.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     movto-estoq.dt-trans AT ROW 1.17 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     movto-estoq.serie-docto AT ROW 2.17 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     movto-estoq.nro-docto AT ROW 3.17 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-conta AT ROW 4.17 COL 30 COLON-ALIGNED
     movto-estoq.it-codigo AT ROW 5.67 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     item.desc-item AT ROW 5.67 COL 33.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40.72 BY .88
     item.cod-localiz AT ROW 6.67 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     movto-estoq.un AT ROW 6.67 COL 57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     movto-estoq.quantidade AT ROW 7.67 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     movto-estoq.cod-estabel AT ROW 9.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-cod-estabel AT ROW 9.5 COL 59 COLON-ALIGNED
     movto-estoq.cod-depos AT ROW 10.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-cod-depos AT ROW 10.5 COL 59 COLON-ALIGNED
     movto-estoq.cod-localiz AT ROW 11.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     c-cod-localiz AT ROW 11.5 COL 59 COLON-ALIGNED
     movto-estoq.lote AT ROW 12.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     c-lote AT ROW 12.5 COL 59 COLON-ALIGNED
     saldo-estoq.dt-vali-lote AT ROW 13.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     dt-vali AT ROW 13.5 COL 59 COLON-ALIGNED
     movto-estoq.cod-refer AT ROW 14.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-cod-refer AT ROW 14.5 COL 59 COLON-ALIGNED
     c-saida AT ROW 8.83 COL 3.29 NO-LABEL
     c-entrada AT ROW 8.83 COL 39 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 1 COL 1
     rt-mold AT ROW 5.5 COL 1
     RECT-13 AT ROW 9.17 COL 1
     RECT-14 AT ROW 9.17 COL 38.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.movto-estoq,mgind.item,movind.saldo-estoq
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
         HEIGHT             = 14.67
         WIDTH              = 76.
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

ASSIGN 
       c-cod-depos:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-c-cod-depos:HANDLE.

/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-localiz:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-c-cod-localiz:HANDLE.

/* SETTINGS FOR FILL-IN c-cod-refer IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-refer:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-c-cod-refer:HANDLE.

/* SETTINGS FOR FILL-IN c-conta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-entrada IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-saida IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN movto-estoq.cod-depos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.cod-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.cod-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.dt-trans IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN saldo-estoq.dt-vali-lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.nro-docto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.serie-docto IN FRAME f-main
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




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos V-table-Win
ON F5 OF c-cod-depos IN FRAME f-main
DO:
    assign
        l-implanta = yes
        c-estab     = input frame {&FRAME-NAME} c-cod-estabel
        c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.

    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = c-cod-depos
        &campo2     = c-cod-localiz
        &campo3     = c-lote
        &campo4     = c-cod-refer
        &campozoom  = cod-depos
        &campozoom2 = cod-localiz
        &campozoom3 = lote
        &campozoom4 = cod-refer}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-depos IN FRAME f-main
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON F5 OF c-cod-estabel IN FRAME f-main
DO:
    {include/zoomvar.i &prog-zoom = adzoom/z01ad107.w
                       &campo     = c-cod-estabel
                       &campozoom = cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME f-main
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-localiz V-table-Win
ON F5 OF c-cod-localiz IN FRAME f-main
DO:
    &SCOPED-DEFINE deposito input frame {&FRAME-NAME} c-cod-depos

    assign
        l-implanta = yes
        c-estab     = input frame {&FRAME-NAME} c-cod-estabel
        c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.

    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = c-cod-localiz
        &campozoom  = cod-localiz
        &campo2     = c-cod-depos
        &campozoom2 = cod-depos
        &campo3     = c-lote
        &campozoom3 = lote
        &campo4     = c-cod-refer
        &campozoom4 = cod-refer
        &parametros = "run pi-inicializa-paginas in wh-pesquisa.
                       run pi-set-faixa-dep in wh-pesquisa
                                        ({&deposito}, {&deposito})."}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-localiz IN FRAME f-main
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-refer V-table-Win
ON F5 OF c-cod-refer IN FRAME f-main
DO:
  &SCOPED-DEFINE deposito input frame {&FRAME-NAME} c-cod-depos

    assign
        l-implanta = yes
        c-estab     = input frame {&FRAME-NAME} c-cod-estabel
        c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.

    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = c-cod-localiz
        &campozoom  = cod-localiz
        &campo2     = c-cod-depos
        &campozoom2 = cod-depos
        &campo3     = c-lote
        &campozoom3 = lote
        &campo4     = c-cod-refer
        &campozoom4 = cod-refer
        &parametros = "run pi-inicializa-paginas in wh-pesquisa.
                       run pi-set-faixa-dep in wh-pesquisa
                                        ({&deposito}, {&deposito})."}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-refer IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-lote V-table-Win
ON LEAVE OF c-lote IN FRAME f-main
DO:
    if  item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
        find first b-saldo
            where  b-saldo.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
            and    b-saldo.cod-estabel = input frame {&frame-name} c-cod-estabel
            and    b-saldo.cod-depos   = input frame {&frame-name} c-cod-depos
            and    b-saldo.cod-localiz = input frame {&frame-name} c-cod-localiz
            and    b-saldo.lote        = input frame {&frame-name} c-lote 
            no-lock no-error.

            if  avail b-saldo then do:
                disable dt-vali with frame {&frame-name}.
                disp saldo-estoq.dt-vali-lote @ dt-vali
                     with frame {&frame-name}.
            end.         
            else do:
                enable dt-vali with frame {&frame-name}. 
                if  item.tipo-con-est = 4 then
                    enable c-cod-refer with frame {&frame-name}.
                apply 'entry' to dt-vali in frame {&frame-name}.                
                return no-apply.                                  
            end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomDep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomDep V-table-Win
ON CHOOSE OF MENU-ITEM mZoomDep /* Zoom de Dep¢sito */
DO:
   {include/zoomvar.i &prog-zoom = inzoom/z01in084.w
                       &campo     = c-cod-depos
                       &campozoom = cod-depos} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomLoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomLoc V-table-Win
ON CHOOSE OF MENU-ITEM mZoomLoc /* Zoom de Localizaá∆o */
DO:
    &SCOPED-DEFINE estab    input frame {&FRAME-NAME} c-cod-estabel
    &SCOPED-DEFINE deposito input frame {&FRAME-NAME} c-cod-depos

    {include/zoom.i
        &prog-zoom   = "inzoom/z02in189.w"
        &tabela      = movto-estoq
        &atributo    = cod-localiz
        &parametros  = "run pi-faixa in wh-pesquisa
                            ({&estab}, {&deposito}, {&deposito})."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomRefer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomRefer V-table-Win
ON CHOOSE OF MENU-ITEM mZoomRefer /* Zoom de Referància */
DO:
  {include/zoomvar.i &prog-zoom = inzoom/z01in377.w
                     &campo     = c-cod-refer
                     &campozoom = cod-refer}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalDep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalDep V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalDep /* Zoom de Saldos */
DO:
  apply "F5" to c-cod-depos in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSaldLoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSaldLoc V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSaldLoc /* Zoom de Saldos */
DO:
  apply "F5" to c-cod-localiz in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalRef V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalRef /* Zoom de Saldos */
DO:
  apply "F5" to c-cod-refer in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.un V-table-Win
ON F5 OF movto-estoq.un IN FRAME f-main /* Unid Medid */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in417.w"
                  &tabela=movto-estoq
                  &atributo=un}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.un V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.un IN FRAME f-main /* Unid Medid */
DO:
  apply 'F5' to self.
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

  {utp/ut-liter.i Conta_Cont†bil * L}
  assign c-conta:label in frame {&frame-name} = trim(return-value).

  {utp/ut-field.i mgind movto-estoq cod-estabel 1}
  assign c-cod-estabel:label in frame {&frame-name} = trim(return-value).

  {utp/ut-field.i mgind movto-estoq cod-depos 1}
  assign c-cod-depos:label in frame {&frame-name} = trim(return-value).

  {utp/ut-field.i mgind movto-estoq cod-localiz 1}
  assign c-cod-localiz:label in frame {&frame-name} = trim(return-value).

  {utp/ut-field.i mgind movto-estoq lote 1}
  assign c-lote:label in frame {&frame-name} = trim(return-value).

  {utp/ut-field.i mgind saldo-estoq dt-vali-lote 1}
  assign dt-vali:label in frame {&frame-name} = trim(return-value).

  {utp/ut-field.i mgind movto-estoq cod-refer 1}
  assign c-cod-refer:label in frame {&frame-name} = trim(return-value).

  if  c-cod-estabel :load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if  c-cod-depos   :load-mouse-pointer ("image~\rbm.cur" ) in frame {&frame-name} then.
  if  c-cod-refer   :load-mouse-pointer ("image~\rbm.cur" ) in frame {&frame-name} then.
  if  c-cod-localiz :load-mouse-pointer ("image~\rbm.cur" ) in frame {&frame-name} then
  if  movto-estoq.un:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "movto-estoq"}
  {src/adm/template/row-list.i "item"}
  {src/adm/template/row-list.i "saldo-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-estoq"}
  {src/adm/template/row-find.i "item"}
  {src/adm/template/row-find.i "saldo-estoq"}

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a validaá∆o de chave duplicada */

  /* Ponha aqui as demais validaá‰es */

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

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

  find first param-cq     no-lock no-error.
  find first param-estoq  no-lock no-error.
  find item where item.it-codigo = ficha-cq.it-codigo no-lock no-error.

  assign c-conta = param-estoq.ct-tr-transf + param-estoq.sc-tr-transf.

  disp ficha-cq.serie-docto     @ movto-estoq.serie-docto
       ficha-cq.nro-docto       @ movto-estoq.nro-docto
       da-inspecao              @ movto-estoq.dt-trans
       c-conta
       ficha-cq.it-codigo       @ movto-estoq.it-codigo
       item.desc-item
       ficha-cq.cod-estabel     @ movto-estoq.cod-estabel
       ficha-cq.cod-depos       @ movto-estoq.cod-depos
       item.cod-localiz
       ficha-cq.cod-localiz     @ movto-estoq.cod-localiz
       ficha-cq.lote            @ movto-estoq.lote
       with frame {&frame-name}.

  if  c-op-des1 = "2" then do:
      find rej-ficha where rowid(rej-ficha) = r-rej1 no-lock no-error.
      disp rej-ficha.qt-apr-cond @ movto-estoq.quantidade with frame {&frame-name}.
      disable movto-estoq.quantidade with frame {&frame-name}.
  end.

  if  c-op-des1 = "3" then do:
      find rej-ficha where rowid(rej-ficha) = r-rej1 no-lock no-error.
      disp rej-ficha.qt-rejeitada @ movto-estoq.quantidade with frame {&frame-name}.
      disable movto-estoq.quantidade with frame {&frame-name}.
  end.

  disable dt-vali with frame {&frame-name}.  
  run pi-atualiza.

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

  {utp/ut-liter.i Sa°da MCQ C}
  assign c-saida:screen-value in frame {&frame-name} = return-value.

  {utp/ut-liter.i Entrada MCQ C}
  assign c-entrada:screen-value in frame {&frame-name} = return-value.  

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza V-table-Win 
PROCEDURE pi-atualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* BUSCA SALDO DE ESTOQUE REFERENTE A FICHA CQ */
    find first saldo-estoq
        where  saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
        and    saldo-estoq.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel
        and    saldo-estoq.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos
        and    saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz
        and    saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote 
        no-lock no-error.

    if  item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
        if  avail saldo-estoq then
            disp saldo-estoq.dt-vali-lote
                 saldo-estoq.cod-refer    @ movto-estoq.cod-refer
                 saldo-estoq.dt-vali-lote @ dt-vali
                 saldo-estoq.cod-refer    @ c-cod-refer
                 with frame {&frame-name}.
        else do:
            enable dt-vali with frame {&frame-name}.
            if  item.tipo-con-est = 4 then
                enable c-cod-refer with frame {&frame-name}.
        end.
    end.

    if  param-estoq.estab-uni = no and item.tipo-contr <> 2 then
        enable c-cod-estabel with frame {&frame-name}.
    if  item.tipo-con-est <> 1 then
        enable c-lote with frame {&frame-name}.
    if  item.loc-unica = no then
        enable c-cod-localiz with frame {&frame-name}.

    find estabelec
        where estabelec.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel
        no-lock no-error.
    if  avail estabelec then do:
        if  item.tipo-con-est <> 2 and c-op-des1 <> "2"
        and (c-op-des1 <> "3" or estabelec.dep-rej-cq = "") then
            enable movto-estoq.quantidade with frame {&frame-name}.
    end.

    disp input frame {&frame-name} movto-estoq.cod-estabel @ c-cod-estabel with frame {&frame-name}.
    disp input frame {&frame-name} movto-estoq.cod-localiz @ c-cod-localiz with frame {&frame-name}.
    if  avail saldo-estoq then
        disp input frame {&frame-name} saldo-estoq.dt-vali-lote @ dt-vali
             with frame {&frame-name}.
    disp input frame {&frame-name} movto-estoq.cod-refer @ c-cod-refer
         with frame {&frame-name}.

    if  ficha-cq.nr-ordem <> 0 then
        find ordem-compra
            where ordem-compra.numero-ordem = ficha-cq.nr-ordem no-lock no-error.
    if  avail ordem-compra and ordem-compra.dep-almoxar <> ""
        then disp ordem-compra.dep-almoxar @ c-cod-depos with frame {&frame-name}.
        else disp item.deposito-pad        @ c-cod-depos with frame {&frame-name}.

    if  avail estabelec then do:
        if  c-op-des1 = "3" and estabelec.dep-rej-cq <> "" then
            disp estabelec.dep-rej-cq @ c-cod-depos with frame {&frame-name}.
    end.
    disp input frame {&frame-name} movto-estoq.lote @ c-lote
         with frame {&frame-name}.
    if  avail saldo-estoq then
        disp input frame {&frame-name} saldo-estoq.dt-vali-lote @ dt-vali
             with frame {&frame-name}.
    disp input frame {&frame-name} movto-estoq.cod-refer @ c-cod-refer
         with frame {&frame-name}.

    if  item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
        find first saldo-estoq use-index lote
            where  saldo-estoq.lote = input frame {&frame-name} c-lote
            and    saldo-estoq.it-codigo = item.it-codigo 
            no-lock no-error.
        if  avail saldo-estoq then
            disp saldo-estoq.dt-vali-lote @ dt-vali
                 saldo-estoq.cod-refer    @ c-cod-refer with frame {&frame-name}.
        else
            disp today @ dt-vali with frame {&frame-name}.
    end.
    apply 'entry' to c-cod-estabel in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorno V-table-Win 
PROCEDURE pi-retorno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter r-ficha-cq  as rowid  no-undo.
    def input parameter de-inspecao as date   no-undo.
    def input parameter c-op-des    as char   no-undo.
    def input parameter h-janela    as handle no-undo.
    def input parameter r-rej       as rowid  no-undo.

    assign da-inspecao = de-inspecao
           c-op-des1   = c-op-des
           h-janela1   = h-janela
           r-rej1      = r-rej.
    find ficha-cq where rowid(ficha-cq) = r-ficha-cq no-lock no-error.
    if  avail ficha-cq then run local-enable-fields.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valor V-table-Win 
PROCEDURE pi-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output parameter c-dep-rej1 as char no-undo.

    assign c-dep-rej1 = input frame {&frame-name} c-cod-depos.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica V-table-Win 
PROCEDURE pi-verifica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  parameter r-ficha-cq as rowid   no-undo.
    def output parameter l-erro     as logical no-undo.

    def var i-insp        as integer no-undo.
    def var i-var-aux     as integer no-undo.
    def var i-var-aux-tot as integer no-undo.



    find first param-estoq no-lock no-error.

    for each tt-movto:
        delete tt-movto.
    end.

    /* BUSCA SALDO DE ESTOQUE REFERENTE A FICHA CQ */
    find first saldo-estoq
        where  saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
        and    saldo-estoq.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel
        and    saldo-estoq.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos
        and    saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz
        and    saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote 
        no-lock no-error.

    find ficha-cq where rowid(ficha-cq) = r-ficha-cq no-lock no-error.

    /* Validaá∆o Imposta */
    if  avail saldo-estoq then do:
        if  item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
            if  input frame {&frame-name} saldo-estoq.dt-vali-lote <
                input frame {&frame-name} movto-estoq.dt-trans then do:

                run utp/ut-msgs.p (input "show", input 1268, input "").
                if  return-value = 'yes' then do:
                    enable saldo-estoq.dt-vali-lote with frame {&frame-name}.
                    apply 'entry' to saldo-estoq.dt-vali-lote in frame {&frame-name}.
                    return error.
                end.
            end.
        end.
    end.

    find estabelec
        where estabelec.cod-estabel = input frame {&frame-name} c-cod-estabel no-lock no-error.
    if  not avail estabelec then do:
        {utp/ut-field.i mgind estabelec cod-estabel 1}
        run utp/ut-msgs.p (input "show", input 558, input return-value).
        apply 'entry' to c-cod-estabel in frame {&frame-name}.
        return error.
    end.

    find deposito
        where deposito.cod-depos = input frame {&frame-name} c-cod-depos no-lock no-error.
    if  not avail deposito then do:
        {utp/ut-field.i mgind deposito cod-depos 1}
        run utp/ut-msgs.p (input "show", input 558, input return-value).
        apply 'entry' to c-cod-depos in frame {&frame-name}.
        return error.
    end.

    if input frame {&frame-name} movto-estoq.quantidade <= 0 then do:
       run utp/ut-msgs.p (input "show",input 1368,input "").
       apply 'entry' to movto-estoq.quantidade in frame {&frame-name}. 
       return error.
    end.

    if  c-op-des1 <> "3" then do:
        if  deposito.ind-dep-cq = yes then do:
            run utp/ut-msgs.p (input "show", input 1297, input "").
            return error.
        end.
        if  deposito.ind-dep-rej = yes then do:
            run utp/ut-msgs.p (input "show", input 1298, input "").
            return error.
        end.
    end.
    else do:
        if  deposito.ind-dep-rej = no then do:
            run utp/ut-msgs.p (input "show", input 1299, input "").
            return error.
        end.
    end.

    if  item.tipo-con-est = 4 then do:
        find referencia
            where referencia.cod-refer = input frame {&frame-name} c-cod-refer no-lock no-error.
        if  not avail referencia then do:
            {utp/ut-field.i mgind referencia cod-refer 1}
            run utp/ut-msgs.p (input "show", input 558, input return-value).
            apply 'entry' to movto-estoq.quantidade in frame {&frame-name}.
            return error.
        end.
    end.

    find item
        where item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo no-lock no-error.
    if  not(item.fraciona) and input frame {&frame-name} movto-estoq.quantidade <> 
        int(input frame {&frame-name} movto-estoq.quantidade) then do:

        run utp/ut-msgs.p (input "show", input 1304, input "").
        apply 'entry' to movto-estoq.quantidade in frame {&frame-name}.
        return error.
    end.

    /* Validaá∆o Imposta */
    if  avail saldo-estoq then do:
        if  saldo-estoq.qtidade-atu < input frame {&frame-name} movto-estoq.quantidade
        or  ficha-cq.qt-original - ficha-cq.qt-consumida
          - ficha-cq.qt-aprovada - ficha-cq.qt-rejeitada
          - ficha-cq.qt-apr-cond < input frame {&frame-name} movto-estoq.quantidade then do:

            run utp/ut-msgs.p (input "show", input 1303, input "").
            apply 'entry' to movto-estoq.quantidade in frame {&frame-name}.
            return error.
        end.
    end.
    if  input frame {&frame-name} movto-estoq.un <> item.un then do:
        run utp/ut-msgs.p (input "show", input 1302, input "").
        apply 'entry' to movto-estoq.un in frame {&frame-name}.
        return error.
    end.
    if  item.tipo-con-est <> 1 then do:
        if  input frame {&frame-name} c-lote = "" then do:
            run utp/ut-msgs.p (input "show", input 2158, INPUT "" ).
            apply 'entry' to c-lote in frame {&frame-name}.
            return error.
        end.
    end.

    /* VERIFICA SE LOCALIZAÄ«O ORIGEM ê IGUAL A DESTINO */
    if  input frame {&frame-name} movto-estoq.cod-estabel = input frame {&frame-name} c-cod-estabel
    and input frame {&frame-name} movto-estoq.cod-depos   = input frame {&frame-name} c-cod-depos
    and input frame {&frame-name} movto-estoq.cod-localiz = input frame {&frame-name} c-cod-localiz
    and input frame {&frame-name} movto-estoq.lote        = input frame {&frame-name} c-lote then do:
        run utp/ut-msgs.p (input "show", input 1305, input "").
        return error.
    end.

    if  c-op-des1 = "3"
    and input frame {&frame-name} movto-estoq.cod-depos =
        input frame {&frame-name} c-cod-depos then do:
        run utp/ut-msgs.p (input "show", input 1306, input "").
        return error.
    end.


    /* ATUALIZA MOVIMENTAÄ«O DO ESTOQUE - SA÷DA DO CQ - ORIGEM */
    create tt-movto.
    assign tt-movto.cod-versao-integracao = 1
           tt-movto.ct-codigo      = param-estoq.ct-tr-transf
           tt-movto.sc-codigo      = param-estoq.sc-tr-transf
           tt-movto.conta-contabil   = param-estoq.conta-transf 
           tt-movto.dt-trans       = input frame {&frame-name} movto-estoq.dt-trans
           tt-movto.nro-docto      = input frame {&frame-name} movto-estoq.nro-docto
           tt-movto.serie-docto    = input frame {&frame-name} movto-estoq.serie-docto
           tt-movto.cod-depos      = input frame {&frame-name} movto-estoq.cod-depos
           tt-movto.cod-estabel    = input frame {&frame-name} movto-estoq.cod-estabel
           tt-movto.it-codigo      = input frame {&frame-name} movto-estoq.it-codigo
           tt-movto.cod-localiz    = input frame {&frame-name} movto-estoq.cod-localiz
           tt-movto.lote           = input frame {&frame-name} movto-estoq.lote
           tt-movto.dt-vali-lote   = input frame {&frame-name} saldo-estoq.dt-vali-lote
           tt-movto.cod-refer      = input frame {&frame-name} movto-estoq.cod-refer
           tt-movto.quantidade     = input frame {&frame-name} movto-estoq.quantidade
           tt-movto.un             = input frame {&frame-name} movto-estoq.un
           tt-movto.esp-docto      = 33
           tt-movto.tipo-trans     = 2
           tt-movto.descricao-db   = ficha-cq.narrativa
           tt-movto.cod-prog-orig  = "v03in218"
           tt-movto.cod-emitente   = ficha-cq.cod-emitente
           tt-movto.usuario        = c-seg-usuario.

    /* ATUALIZA MOVIMENTAÄ«O DE ESTOQUE - DESTINO */
    create tt-movto.
    assign tt-movto.cod-versao-integracao = 1
           tt-movto.ct-codigo     = param-estoq.ct-tr-transf
           tt-movto.sc-codigo     = param-estoq.sc-tr-transf
           tt-movto.conta-contabil  = param-estoq.conta-transf 
           tt-movto.dt-trans      = input frame {&frame-name} movto-estoq.dt-trans
           tt-movto.nro-docto     = input frame {&frame-name} movto-estoq.nro-docto
           tt-movto.serie-docto   = input frame {&frame-name} movto-estoq.serie-docto
           tt-movto.cod-depos     = input frame {&frame-name} c-cod-depos
           tt-movto.cod-estabel   = input frame {&frame-name} c-cod-estabel
           tt-movto.it-codigo     = input frame {&frame-name} movto-estoq.it-codigo
           tt-movto.cod-localiz   = input frame {&frame-name} c-cod-localiz
           tt-movto.lote          = input frame {&frame-name} c-lote
           tt-movto.dt-vali-lote  = input frame {&frame-name} dt-vali
           tt-movto.cod-refer     = input frame {&frame-name} c-cod-refer
           tt-movto.quantidade    = input frame {&frame-name} movto-estoq.quantidade
           tt-movto.un            = input frame {&frame-name} movto-estoq.un
           tt-movto.esp-docto     = 33
           tt-movto.tipo-trans    = 1
           tt-movto.descricao-db  = ficha-cq.narrativa
           tt-movto.cod-prog-orig = "v03in218"
           tt-movto.usuario       = c-seg-usuario
           tt-movto.cod-emitente  = ficha-cq.cod-emitente
           l-deleta-erros         = yes.


    run cep/ceapi001.p (input-output table tt-movto,
                        input-output table tt-erro, 
                        input        l-deleta-erros).

    /* CHAMADA DO BROWSE QUE MOSTRA AS INCONSIST“NCIAS DE CRIAÄ«O DO MOVTO-ESTOQ */
    find first tt-erro no-error.
    if  avail tt-erro then do:
        if  c-op-des1 = "2" or c-op-des1 = "3" then do:
            find rej-ficha where rowid(rej-ficha) = r-rej1 exclusive-lock no-error.
            if avail rej-ficha then 
               delete rej-ficha.
        end.
        run cdp/cd0666.w (input table tt-erro).
        l-erro = yes.        
        return 'ADM-ERROR':U.
    end.


    /* ATUALIZA DADOS DA FICHA */
    if  c-op-des1 = "1" then
        assign ficha-cq.qt-aprovada = ficha-cq.qt-aprovada
                                    + input frame {&frame-name} movto-estoq.quantidade.
    else
    if  c-op-des1 = "2" then
        assign ficha-cq.qt-apr-cond = ficha-cq.qt-apr-cond
                                    + input frame {&frame-name} movto-estoq.quantidade.
    else 
        assign ficha-cq.qt-rejeitada = ficha-cq.qt-rejeitada
                                     + input frame {&frame-name} movto-estoq.quantidade
               ficha-cq.qt-a-liberar = ficha-cq.qt-a-liberar
                                     + input frame {&frame-name} movto-estoq.quantidade.



    if  ficha-cq.qt-original  - ficha-cq.qt-aprovada
      - ficha-cq.qt-consumida - ficha-cq.qt-rejeitada
      - ficha-cq.qt-apr-cond <= 0 then
        assign ficha-cq.inspecionado = yes
               ficha-cq.situacao     = 4.
    if  ficha-cq.qt-a-liberar = 0 and ficha-cq.inspecionado then
        assign ficha-cq.liberada = yes.
    if  input frame {&frame-name} movto-estoq.dt-trans > ficha-cq.dt-inspecao
    or  ficha-cq.dt-inspecao = ? then
        assign ficha-cq.dt-inspecao = input frame {&frame-name} movto-estoq.dt-trans.

    /* ATUALIZAÄ«O DA INSPEÄ«O DO FORNECEDOR */
    {cdp/cd9320.i}

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
  {src/adm/template/snd-list.i "movto-estoq"}
  {src/adm/template/snd-list.i "item"}
  {src/adm/template/snd-list.i "saldo-estoq"}

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


