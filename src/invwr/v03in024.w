&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V03IN024 2.00.00.020 } /*** "010020" 19/06/2024 15:51:45 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v03in024 MUT}
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
def new global shared var v-row-parent   as rowid no-undo.                                
DEF NEW GLOBAL SHARED VAR gr-estabelec   AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-deposito    AS rowid NO-UNDO.
def new global shared var gr-cab-req-sum as rowid no-undo.
def new global shared var h-acomp as handle no-undo.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var l-ok                     as log     no-undo.
def var c-label-dep-dest         as char    no-undo.
def var c-label-localiz-dest     as char    no-undo.
def var c-label-dep-orig         as char    no-undo.
def var c-label-localiz-orig-ini as char    no-undo.
def var h-handle                 as handle  no-undo.
def var c-handle                 as char    no-undo.
def var c-erro                   as char    no-undo.
def var c-texto                  as char    no-undo.
def var c-retorno                as char    no-undo.
def var i-cont                   as integer no-undo.
def var l-informa-localizacao    as logical no-undo.
def var l-busca-saldos           as logical no-undo.
def var i-empresa-prin           LIKE empresa.ep-codigo NO-UNDO.
def var d-data                   as date    no-undo.

DEF VAR W-Win AS WIDGET-HANDLE NO-UNDO.

{cdp/cdcfgman.i}

{cpp/cpapi014.i}
{cpp/cpapi014.i1}
{cdp/cd0666.i}
{cdp/cdcfgmat.i}  /* Preprocessador bf_mat_conta_estab */

/** Unifica‡Æo de Conceito **/
{cdp/cdunif001.i}
{cdp/cdunif001.i1}

{cpp/cpapi029.i}

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/
&scoped-define TTONLY YES
{include/i-estab-security.i}
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/


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
&Scoped-define EXTERNAL-TABLES cab-req-sum
&Scoped-define FIRST-EXTERNAL-TABLE cab-req-sum


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cab-req-sum.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cab-req-sum.nr-req-sum 
&Scoped-define ENABLED-TABLES cab-req-sum
&Scoped-define FIRST-ENABLED-TABLE cab-req-sum
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 RECT-5 RECT-6 fi-ccusto 
&Scoped-Define DISPLAYED-FIELDS cab-req-sum.nr-req-sum 
&Scoped-define DISPLAYED-TABLES cab-req-sum
&Scoped-define FIRST-DISPLAYED-TABLE cab-req-sum
&Scoped-Define DISPLAYED-OBJECTS rs-transf-dev fi-cod-estabel ~
fi-conta-contabil fi-ccusto fi-dt-trans fi-perc-trans fi-cod-depos-dest ~
fi-cod-localiz-dest fi-cod-depos-orig-ini fi-cod-depos-orig-fim ~
fi-it-codigo-ini fi-it-codigo-fim fi-label-retangulo fi-label-inicial ~
fi-label-final 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cab-req-sum.nr-req-sum rs-transf-dev 
&Scoped-define ADM-ASSIGN-FIELDS cab-req-sum.nr-req-sum rs-transf-dev ~
fi-cod-estabel fi-conta-contabil fi-dt-trans fi-perc-trans ~
fi-cod-depos-dest fi-cod-depos-orig-ini fi-cod-depos-orig-fim ~
fi-it-codigo-ini fi-it-codigo-fim 
&Scoped-define ADM-MODIFY-FIELDS cab-req-sum.nr-req-sum rs-transf-dev ~
fi-cod-estabel fi-conta-contabil fi-dt-trans fi-perc-trans ~
fi-cod-depos-dest fi-cod-depos-orig-ini fi-cod-depos-orig-fim ~
fi-it-codigo-ini fi-it-codigo-fim 

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
DEFINE VARIABLE fi-ccusto AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-depos-dest AS CHARACTER FORMAT "X(03)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-depos-orig-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-depos-orig-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel LIKE estabelec.cod-estabel
     LABEL "":R7 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-localiz-dest AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE fi-conta-contabil AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-trans AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-label-final AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fi-label-inicial AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fi-label-retangulo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13 BY .67 NO-UNDO.

DEFINE VARIABLE fi-perc-trans AS DECIMAL FORMAT ">>>9.99999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE rs-transf-dev AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Transferˆncia", 1,
"Devolu‡Æo", 2
     SIZE 38 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 1.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.75.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 12.25.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 3.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cab-req-sum.nr-req-sum AT ROW 1.5 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     rs-transf-dev AT ROW 3.75 COL 25 NO-LABEL
     fi-cod-estabel AT ROW 5 COL 35 COLON-ALIGNED HELP
          ""
          LABEL "":R7
     fi-conta-contabil AT ROW 6 COL 35 COLON-ALIGNED
     fi-ccusto AT ROW 6 COL 55.29 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     fi-dt-trans AT ROW 7 COL 35 COLON-ALIGNED
     fi-perc-trans AT ROW 8 COL 35 COLON-ALIGNED
     fi-cod-depos-dest AT ROW 9 COL 35 COLON-ALIGNED
     fi-cod-localiz-dest AT ROW 10 COL 35 COLON-ALIGNED
     fi-cod-depos-orig-ini AT ROW 12.25 COL 22 COLON-ALIGNED
     fi-cod-depos-orig-fim AT ROW 12.25 COL 55 COLON-ALIGNED NO-LABEL
     fi-it-codigo-ini AT ROW 13.25 COL 22 COLON-ALIGNED
     fi-it-codigo-fim AT ROW 13.25 COL 55 COLON-ALIGNED NO-LABEL
     fi-label-retangulo AT ROW 3 COL 21 COLON-ALIGNED NO-LABEL
     fi-label-inicial AT ROW 11.25 COL 27 COLON-ALIGNED NO-LABEL
     fi-label-final AT ROW 11.25 COL 59 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 3.25 COL 21
     RECT-3 AT ROW 1 COL 1
     RECT-5 AT ROW 2.75 COL 1
     RECT-6 AT ROW 11.5 COL 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.cab-req-sum
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
         HEIGHT             = 14.04
         WIDTH              = 88.
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
   FRAME-NAME Size-to-Fit                                               */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN fi-cod-depos-dest IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-cod-depos-orig-fim IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-cod-depos-orig-ini IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME f-main
   NO-ENABLE 2 3 LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE  */
/* SETTINGS FOR FILL-IN fi-cod-localiz-dest IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-conta-contabil IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-dt-trans IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-it-codigo-fim IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-it-codigo-ini IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-label-final IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label-inicial IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label-retangulo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-perc-trans IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN cab-req-sum.nr-req-sum IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR RADIO-SET rs-transf-dev IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
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

&Scoped-define SELF-NAME fi-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto V-table-Win
ON F5 OF fi-ccusto IN FRAME f-main
DO:
    FIND FIRST param-global NO-LOCK NO-ERROR.

    assign i-empresa-prin = param-global.empresa-prin.
    &IF DEFINED (bf_mat_conta_estab) &THEN
        find first estabelec
             where estabelec.cod-estabel = input frame {&frame-name} fi-cod-estabel no-lock no-error.
        if avail estabelec then
           run cdp/cd9970.p (input rowid(estabelec),
                             output i-empresa-prin).
    &ENDIF

    ASSIGN i-ep-codigo-usuario = i-empresa-prin
           l-implanta          = yes.

    if not valid-handle(h_api_ccusto) then 
        run prgint/utb/utb742za.py persistent set h_api_ccusto.

    run pi_zoom_ccusto in h_api_ccusto (INPUT i-empresa-prin,
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    
    if v_cod_ccusto <> "" then
        ASSIGN fi-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.

    if valid-handle(h_api_ccusto) then
        delete object h_api_ccusto.
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto V-table-Win
ON LEAVE OF fi-ccusto IN FRAME f-main
DO:
   {cdp/cdunif001d.i fi-ccusto {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-ccusto IN FRAME f-main
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-depos-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-dest V-table-Win
ON F5 OF fi-cod-depos-dest IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=fi-cod-depos-dest
                     &campozoom=cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-dest V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-depos-dest IN FRAME f-main
DO:
   APPLY "F5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-depos-orig-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-orig-fim V-table-Win
ON F5 OF fi-cod-depos-orig-fim IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=fi-cod-depos-orig-fim
                     &campozoom=cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-orig-fim V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-depos-orig-fim IN FRAME f-main
DO:
   APPLY "F5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-depos-orig-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-orig-ini V-table-Win
ON F5 OF fi-cod-depos-orig-ini IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=fi-cod-depos-orig-ini
                     &campozoom=cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-orig-ini V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-depos-orig-ini IN FRAME f-main
DO:
   APPLY "F5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel V-table-Win
ON F5 OF fi-cod-estabel IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=fi-cod-estabel
                     &campozoom=cod-estabel}                 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel V-table-Win
ON LEAVE OF fi-cod-estabel IN FRAME f-main
DO:
    
    IF NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.

    assign i-empresa-prin = param-global.empresa-prin.
    &IF DEFINED (bf_mat_conta_estab) &THEN
        find first estabelec
             where estabelec.cod-estabel = input frame {&frame-name} fi-cod-estabel no-lock no-error.
        if avail estabelec then
           run cdp/cd9970.p (input rowid(estabelec),
                             output i-empresa-prin).
    &ENDIF

    EMPTY TEMP-TABLE tt_log_erro.
    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.    
        run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (INPUT i-empresa-prin,
                                                       INPUT "",
                                                       INPUT TODAY,
                                                       OUTPUT p_cod_format_cta_ctbl,
                                                       OUTPUT TABLE tt_log_erro).
                                                                                                           
        if valid-handle(h_api_cta_ctbl) then
                delete object h_api_cta_ctbl.                                                                                                              
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estabel IN FRAME f-main
DO:
  APPLY "F5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-localiz-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-localiz-dest V-table-Win
ON F5 OF fi-cod-localiz-dest IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom = "inzoom/z01in189.w"
                     &campo     = fi-cod-localiz-dest
                     &campozoom = cod-localiz}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-localiz-dest V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-localiz-dest IN FRAME f-main
DO:
  APPLY "F5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-conta-contabil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-contabil V-table-Win
ON ENTRY OF fi-conta-contabil IN FRAME f-main
DO:
  ASSIGN fi-conta-contabil:FORMAT IN FRAME {&frame-name} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-contabil V-table-Win
ON F5 OF fi-conta-contabil IN FRAME f-main
DO:
    FIND FIRST param-global NO-LOCK NO-ERROR.
        
    assign i-empresa-prin = param-global.empresa-prin.
    &IF DEFINED (bf_mat_conta_estab) &THEN
        find first estabelec
             where estabelec.cod-estabel = input frame {&frame-name} fi-cod-estabel no-lock no-error.
        if avail estabelec then
           run cdp/cd9970.p (input rowid(estabelec),
                             output i-empresa-prin).
    &ENDIF
        
    ASSIGN i-ep-codigo-usuario = i-empresa-prin
           l-implanta          = yes.
        
    if not valid-handle(h_api_cta_ctbl) then
        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
    
    assign v_cod_finalid = {adinc/i05ad049.i 4 4}.
    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT i-empresa-prin,
                                                   INPUT "CEP",
                                                   INPUT "",
                                                   INPUT v_cod_finalid,
                                                   INPUT date(fi-dt-trans:screen-value in frame {&frame-name}),
                                                   OUTPUT v_cod_cta_ctbl,
                                                   OUTPUT v_des_cta_ctbl,
                                                   OUTPUT p-finalidade,
                                                   OUTPUT TABLE tt_log_erro).
    
    {cdp/cdunif001b.i1}
        
    IF v_cod_cta_ctbl <> "" THEN
        ASSIGN fi-conta-contabil:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.

    if valid-handle(h_api_cta_ctbl) then
        delete object h_api_cta_ctbl.
        
    APPLY "LEAVE":U  TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-contabil V-table-Win
ON LEAVE OF fi-conta-contabil IN FRAME f-main
DO:
    FIND FIRST param-global NO-LOCK NO-ERROR.

    assign i-empresa-prin = param-global.empresa-prin.
    &IF DEFINED (bf_mat_conta_estab) &THEN
        find first estabelec
             where estabelec.cod-estabel = input frame {&frame-name} fi-cod-estabel no-lock no-error.
        if avail estabelec then
           run cdp/cd9970.p (input rowid(estabelec),
                             output i-empresa-prin).
    &ENDIF
    
    assign d-data = date(fi-dt-trans:screen-value in frame {&frame-name}).
    
    if avail estabelec then do:
        {cdp/cdunif001a.i fi-conta-contabil fi-ccusto {&FRAME-NAME} d-data i-empresa-prin estabelec.cod-estabel}
    end. 
    else do:
        {cdp/cdunif001a.i fi-conta-contabil fi-ccusto {&FRAME-NAME} d-data """" """"}
    end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-contabil V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-conta-contabil IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo-fim V-table-Win
ON F5 OF fi-it-codigo-fim IN FRAME f-main
DO:
  assign l-implanta = no.
  {include/zoomvar.i &prog-zoom = "inzoom/z02in172.w"
                     &campo     = fi-it-codigo-fim
                     &campozoom = it-codigo   }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo-fim V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-it-codigo-fim IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo-ini V-table-Win
ON F5 OF fi-it-codigo-ini IN FRAME f-main
DO:
  assign l-implanta = no.
  {include/zoomvar.i &prog-zoom = "inzoom/z02in172.w"
                     &campo     = fi-it-codigo-ini
                     &campozoom = it-codigo   }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo-ini V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-it-codigo-ini IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-transf-dev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-transf-dev V-table-Win
ON VALUE-CHANGED OF rs-transf-dev IN FRAME f-main
DO:
   if input frame {&frame-name} rs-transf-dev = 1 
   then   
      assign fi-cod-depos-dest:label       = c-label-dep-dest
             fi-cod-localiz-dest:label     = c-label-localiz-dest
             fi-cod-depos-orig-ini:label   = c-label-dep-orig.
   else 
      assign fi-cod-depos-dest:label       = c-label-dep-orig                      
             fi-cod-localiz-dest:label     = c-label-localiz-orig-ini           
             fi-cod-depos-orig-ini:label   = c-label-dep-dest.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.    
    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
    
    EMPTY TEMP-TABLE tt_log_erro.
    run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (INPUT "",
                                                      INPUT "",
                                                      INPUT TODAY,
                                                      OUTPUT p_cod_format_cta_ctbl,
                                                      OUTPUT TABLE tt_log_erro).
        if valid-handle(h_api_cta_ctbl) then
                delete object h_api_cta_ctbl.    
    
    {utp/ut-rtlbl.i mgind movto-estoq tipo-trans fi-label-retangulo} 
    {utp/ut-rdset.i rs-transf-dev *}
    {utp/ut-liter.i Inicial * C} 
    assign fi-label-inicial = return-value.
    {utp/ut-liter.i Final * C}
    assign fi-label-final = return-value.
    
    IF fi-cod-estabel:LOAD-MOUSE-POINTER       ("image/lupa.cur") IN FRAME {&frame-name} THEN.
    IF fi-cod-depos-dest:LOAD-MOUSE-POINTER    ("image/lupa.cur") IN FRAME {&frame-name} THEN.
    IF fi-cod-depos-orig-ini:LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME {&frame-name} THEN.
    IF fi-cod-depos-orig-fim:LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME {&frame-name} THEN.
    IF fi-cod-localiz-dest:LOAD-MOUSE-POINTER  ("image/lupa.cur") IN FRAME {&frame-name} THEN.
    IF fi-conta-contabil:LOAD-MOUSE-POINTER    ("image/lupa.cur") IN FRAME {&frame-name} THEN.  
    IF fi-ccusto        :LOAD-MOUSE-POINTER    ("image/lupa.cur") IN FRAME {&frame-name} THEN.  
    IF fi-it-codigo-ini:LOAD-MOUSE-POINTER     ("image/lupa.cur") IN FRAME {&frame-name} THEN.  
    IF fi-it-codigo-fim:LOAD-MOUSE-POINTER     ("image/lupa.cur") IN FRAME {&frame-name} THEN.  
    
    &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
    &ENDIF         
    
    /************************ INTERNAL PROCEDURES ********************/
    
    {utp/ut-liter.i Dep¢sito_Origem mcp l}
    ASSIGN fi-cod-depos-orig-ini:LABEL IN FRAME {&frame-name} = RETURN-VALUE
         c-label-dep-orig                                   = return-value.
    
    {utp/ut-liter.i Localiz_Origem mcp L}
    assign c-label-localiz-orig-ini = return-value.
    
    {utp/ut-field.i mgind req-sum dep-destino 1}
    ASSIGN fi-cod-depos-dest:LABEL IN FRAME {&frame-name} = RETURN-VALUE
         c-label-dep-dest                               = return-value.
    
    {utp/ut-field.i mgind req-sum loc-dest 1}
    ASSIGN fi-cod-localiz-dest:LABEL IN FRAME {&frame-name} = RETURN-VALUE
         c-label-localiz-dest                             = return-value.
    
    {utp/ut-liter.i Percentual_a_transferir mcp l}
    ASSIGN fi-perc-trans:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
    
    {utp/ut-field.i mgind movto-estoq dt-trans 1}
    ASSIGN fi-dt-trans:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
    
    {utp/ut-field.i mgadm conta-contab conta-contabil 1}
    ASSIGN fi-conta-contabil:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
    
    {utp/ut-field.i mgadm estabelec cod-estabel 1}
    ASSIGN fi-cod-estabel:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
    
    {utp/ut-field.i mgind item it-codigo 1}
    ASSIGN fi-it-codigo-ini:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

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
  {src/adm/template/row-list.i "cab-req-sum"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cab-req-sum"}

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
  
  /******************************************************************************************
  ** SEGURANCA ESTABELECIMENTO
  ******************************************************************************************/
  IF l-estab-security-active = YES THEN DO:
      IF NOT CAN-FIND(FIRST {&ESTAB-SEC-TT}
                      WHERE {&ESTAB-SEC-TT-FIELD} = fi-cod-estabel:screen-value in frame {&FRAME-NAME} NO-LOCK) THEN DO:
          {utp/ut-liter.i Estabelecimento *}
          RUN utp/ut-msgs.p (INPUT "show":U,
                             INPUT 2,
                             INPUT trim(return-value)).
          apply 'entry':U to fi-cod-estabel in frame {&FRAME-NAME}.
          return 'ADM-ERROR':U.
      END.
  END.
  /******************************************************************************************
  ** SEGURANCA ESTABELECIMENTO
  ******************************************************************************************/


  for each tt-transf:
      delete tt-transf.
  end.

  do with frame {&frame-name}:
     create tt-transf.
     assign tt-transf.cod-versao-integracao = 001
            tt-transf.nr-req-sum       = input cab-req-sum.nr-req-sum
            tt-transf.tipo-trans       = input rs-transf-dev
            tt-transf.cod-estabel      = input fi-cod-estabel
            tt-transf.ct-codigo        = input fi-conta-contabil
            tt-transf.sc-codigo        = INPUT fi-ccusto
            tt-transf.data             = input fi-dt-trans
            tt-transf.percentual       = input fi-perc-trans
            tt-transf.cod-depos-dest   = input fi-cod-depos-dest
            tt-transf.cod-localiz-dest = input fi-cod-localiz-dest
            tt-transf.deposito-ini     = input fi-cod-depos-orig-ini
            tt-transf.deposito-fim     = input fi-cod-depos-orig-fim
            tt-transf.item-ini         = input fi-it-codigo-ini
            tt-transf.item-fim         = input fi-it-codigo-fim
            tt-transf.carrega-req-sum  = no
            tt-transf.loc-ent-unica    = l-informa-localizacao 
            tt-transf.procura-saldos   = l-busca-saldos.
  end. 

  run pi-recebe-tt-transf in h-handle (input table tt-transf).

  run pi-valida-transf in h-handle (input  yes,
                                    input  tt-transf.nr-req-sum,
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

  for each tt-req-sum:
      delete tt-req-sum.
  end.

  for each tt-aloca:
      delete tt-aloca.
  end.

  run pi-recebe-tt-req-sum in h-handle (input table tt-req-sum).
  run pi-recebe-tt-aloca   in h-handle (input table tt-aloca).

  if not l-busca-saldos or input frame {&frame-name} rs-transf-dev = 2 then do:
     IF VALID-HANDLE(w-win) THEN ASSIGN w-win:SENSITIVE = NO.
     RUN cpp/cp0310a.w (INPUT h-handle).   
     assign c-retorno = return-value.
     IF VALID-HANDLE(w-win) THEN ASSIGN w-win:SENSITIVE = YES.
     APPLY 'ENTRY':u TO w-win.
  end.
  else do:
       run pi-carrega-tt-req-sum in h-handle.
       run utp/ut-acomp.p persistent set h-acomp.
       {utp/ut-liter.i Processando_Transferˆncias *}
       run pi-inicializar in h-acomp ( Return-value ). 
       run pi-desabilita-cancela in h-acomp.
       run pi-processa-transf in h-handle (input table  tt-transf,
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

  disable fi-cod-localiz-dest with frame {&frame-name}.
  disable fi-ccusto with frame {&frame-name}.

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
  
  if avail cab-req-sum then
     find first ord-prod where 
                ord-prod.nr-req-sum = cab-req-sum.nr-req-sum no-lock no-error.


  if avail ord-prod then DO:

      RUN pi-execute IN h-cpapi029 (INPUT 1,
                                    INPUT ord-prod.cod-estabel,
                                    INPUT ord-prod.nr-linha,
                                    output c-dep-fabrica  ,
                                    output d-var-rep      ,   
                                    output d-var-req-menor,  
                                    output d-var-requis   ,  
                                    output d-var-transf   ,
                                    output table tt-erro append).



      assign fi-cod-estabel    = ord-prod.cod-estabel 
             fi-conta-contabil = param-cp.ct-trans
             fi-ccusto         = param-cp.sc-trans
             fi-cod-depos-dest = c-dep-fabrica
             fi-dt-trans       = today
             fi-perc-trans     = 100.  
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  APPLY "LEAVE":U to fi-conta-contabil in frame {&frame-name}.

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

  ASSIGN cab-req-sum.nr-req-sum:sensitive in frame {&frame-name} = no
         fi-cod-localiz-dest:sensitive    in frame {&frame-name} = l-informa-localizacao.    

  FIND FIRST param-cp NO-LOCK NO-ERROR.
  IF  AVAIL param-cp THEN DO:
      assign fi-cod-depos-dest:sensitive in frame {&frame-name} = not(param-cp.dep-fab-unico)
             fi-cod-estabel:sensitive    in frame {&frame-name} = not(param-cp.est-unico).            
  END. /* if avail param-cp ... */    
  
  apply "LEAVE":U to fi-conta-contabil in frame {&frame-name}.
  

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
  IF NOT VALID-HANDLE(h-cpapi029) THEN
      RUN cpp/cpapi029.p PERSISTENT SET h-cpapi029.

  FIND FIRST param-cp     NO-LOCK NO-ERROR.
  FIND FIRST param-global NO-LOCK NO-ERROR.
  FIND FIRST param-estoq  NO-LOCK NO-ERROR. 

  &IF DEFINED (bf_mat_conta_estab) &THEN
      find first estab-mfg
           where estab-mfg.cod-estabel = param-cp.cod-estabel no-lock no-error.
      if avail estab-mfg and
         estab-mfg.conta-trans <> ? then
         assign fi-conta-contabil = estab-mfg.ct-trans
                fi-ccusto         = estab-mfg.sc-trans.
      else
  &ENDIF
      assign fi-conta-contabil = param-cp.ct-trans
             fi-ccusto         = param-cp.sc-trans.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


  ASSIGN w-win = {&WINDOW-NAME} NO-ERROR.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN pi-recebe-handle.

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
  if avail cab-req-sum then
     assign gr-cab-req-sum = rowid(cab-req-sum).     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-parametros V-table-Win 
PROCEDURE pi-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  run cpp/cp0310e.w (input-output l-informa-localizacao,
                     input-output l-busca-saldos). 

  if fi-dt-trans:sensitive in frame {&frame-name} then 
     assign fi-cod-localiz-dest:sensitive in frame {&frame-name} = l-informa-localizacao.

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

RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT  this-procedure,
     OUTPUT c-handle).

run get-attribute in widget-handle (c-handle) (input 'HANDLE').

assign h-handle = widget-handle (return-value).

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
  {src/adm/template/snd-list.i "cab-req-sum"}

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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT VALID-HANDLE(h-cpapi029) THEN
      DELETE PROCEDURE  h-cpapi029.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
