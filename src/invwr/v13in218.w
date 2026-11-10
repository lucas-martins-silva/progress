&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
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
{include/i-prgvrs.i V13IN218 2.00.00.070 } /*** "010070" ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v13in218 MUT}
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

/* Defini‡Æo de vari veis - Verifica‡Æo Casas Decimais Chile ---        */ 
{cep/ce1234.i}  

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.
def new global shared var c-estab      like movto-estoq.cod-estabel no-undo.
def new global shared var c-it-codigo  like movto-estoq.it-codigo no-undo.

/* Parameters Definitions ---                                           */
def var c-arq-layout as char no-undo.

/* Local Variable Definitions ---                                       */
def var i-mo-origem       like cotacao.mo-codigo no-undo.
def var i-mo-destino      like cotacao.mo-codigo no-undo.
def var de-aux-1          as decimal decimals 2 no-undo.
def var de-vl-convertido  as decimal no-undo.
def var de-vl-origem      as decimal no-undo.
def var i-custo           as integer init 1.
def var da-dt-cotacao     as date    no-undo.
def var c-periodo         as char    no-undo.
def var c-key-value       as char    no-undo.
DEF VAR c-retceapi001k    AS CHAR    NO-UNDO.

def var i-empresa like param-global.empresa-prin no-undo.
{cdp/cdcfgdis.i}
{cdp/cdcfgman.i}
{cdp/cdcfgmat.i}

{cdp/cd0666.i}

/* {cep/ceapi001.i} */
{cep/ceapi001k.i}
DEF VAR h-ceapi001k AS HANDLE NO-UNDO.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia".

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.
def var c-formato-conta      as char no-undo.
def var c-formato-ccusto     as char no-undo. 

/* Vari veis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Vari veis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo. 
def var v_log_utz_ccusto     as log    no-undo.

&IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
    DEFINE VARIABLE pcod-deposito-pad     LIKE ITEM.deposito-pad       NO-UNDO.
    DEFINE VARIABLE pcod-localiz          LIKE ITEM.cod-localiz        NO-UNDO.
    DEFINE VARIABLE ploc-unica            LIKE ITEM.loc-unica          NO-UNDO.
    DEFINE VARIABLE c-it-codigo-ant       LIKE movto-estoq.it-codigo   NO-UNDO.
    DEFINE VARIABLE c-cod-estabel-ant     LIKE movto-estoq.cod-estabel NO-UNDO.
    DEFINE VARIABLE l-executou-zoom-item  AS LOGICAL  INITIAL NO       NO-UNDO.
    DEFINE VARIABLE l-executou-zoom-estab AS LOGICAL  INITIAL NO       NO-UNDO.
&ENDIF

find first param-global no-lock no-error.
find first param-estoq  no-lock no-error.

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
&Scoped-define EXTERNAL-TABLES movto-estoq
&Scoped-define FIRST-EXTERNAL-TABLE movto-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-estoq.it-codigo movto-estoq.cod-estabel ~
movto-estoq.un movto-estoq.dt-trans movto-estoq.cod-depos ~
movto-estoq.ct-codigo movto-estoq.sc-codigo 
&Scoped-define ENABLED-TABLES movto-estoq
&Scoped-define FIRST-ENABLED-TABLE movto-estoq
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-6 rt-key 
&Scoped-Define DISPLAYED-FIELDS movto-estoq.it-codigo ~
movto-estoq.cod-estabel movto-estoq.un movto-estoq.dt-trans ~
movto-estoq.cod-refer movto-estoq.cod-depos movto-estoq.cod-localiz ~
movto-estoq.lote movto-estoq.ct-codigo movto-estoq.sc-codigo ~
movto-estoq.quantidade 
&Scoped-define DISPLAYED-TABLES movto-estoq
&Scoped-define FIRST-DISPLAYED-TABLE movto-estoq
&Scoped-Define DISPLAYED-OBJECTS c-descricao c-desc-estab c-desc-unid ~
c-desc-ref c-desc-depos c-desc-local dt-vali-lote de-per-ppm c-desc-conta ~
c-desc-ccusto de-valor-mat-1 de-valor-mob-1 de-valor-ggf-1 de-valor-mat-2 ~
de-valor-mob-2 de-valor-ggf-2 de-valor-mat-3 de-valor-mob-3 de-valor-ggf-3 ~
fi-Mat fi-mob fi-ggf fi-moeda-1 fi-moeda-2 fi-moeda-3 

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
DEFINE MENU POPUP-MENU-cod-depos 
       MENU-ITEM mZoomDepos     LABEL "Zoom de Dep¢sitos"
       MENU-ITEM mZoomSalDep    LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-cod-localiz 
       MENU-ITEM mZoomLocal     LABEL "Zoom de Localiza‡äes"
       MENU-ITEM mZoomSalLoc    LABEL "Zoom de Saldos".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-desc-ccusto AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-conta AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-depos AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-local AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ref AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-unid AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(36)":U 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .88 NO-UNDO.

DEFINE VARIABLE de-per-ppm AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "Concentra‡Æo/Ppm" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-ggf-1 AS DECIMAL FORMAT ">,>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .88.

DEFINE VARIABLE de-valor-ggf-2 AS DECIMAL FORMAT ">,>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .88.

DEFINE VARIABLE de-valor-ggf-3 AS DECIMAL FORMAT ">,>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .88.

DEFINE VARIABLE de-valor-mat-1 AS DECIMAL FORMAT ">,>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88.

DEFINE VARIABLE de-valor-mat-2 AS DECIMAL FORMAT ">,>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88.

DEFINE VARIABLE de-valor-mat-3 AS DECIMAL FORMAT ">,>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88.

DEFINE VARIABLE de-valor-mob-1 AS DECIMAL FORMAT ">,>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88.

DEFINE VARIABLE de-valor-mob-2 AS DECIMAL FORMAT ">,>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88.

DEFINE VARIABLE de-valor-mob-3 AS DECIMAL FORMAT ">,>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88.

DEFINE VARIABLE dt-vali-lote AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ggf AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-Mat AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-mob AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-moeda-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE fi-moeda-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE fi-moeda-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.14 BY 4.25.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 13.83.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 2.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     movto-estoq.it-codigo AT ROW 1.17 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao AT ROW 1.17 COL 36.14 COLON-ALIGNED NO-LABEL
     movto-estoq.cod-estabel AT ROW 2.17 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-desc-estab AT ROW 2.17 COL 26.43 COLON-ALIGNED NO-LABEL
     movto-estoq.un AT ROW 3.5 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     c-desc-unid AT ROW 3.5 COL 24.43 COLON-ALIGNED HELP
          "Descricao da Referencia" NO-LABEL
     movto-estoq.dt-trans AT ROW 3.5 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     movto-estoq.cod-refer AT ROW 4.5 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-desc-ref AT ROW 4.5 COL 31.43 COLON-ALIGNED HELP
          "Descricao da Referencia" NO-LABEL
     movto-estoq.cod-depos AT ROW 5.5 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-desc-depos AT ROW 5.5 COL 26.43 COLON-ALIGNED HELP
          "Descri‡Æo do Dep¢sito" NO-LABEL
     movto-estoq.cod-localiz AT ROW 6.5 COL 18.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25.43 BY .88
     c-desc-local AT ROW 6.5 COL 44.43 COLON-ALIGNED NO-LABEL
     movto-estoq.lote AT ROW 7.5 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25.43 BY .88
     dt-vali-lote AT ROW 7.5 COL 44.43 COLON-ALIGNED NO-LABEL
     de-per-ppm AT ROW 8.5 COL 18.43 COLON-ALIGNED
     movto-estoq.ct-codigo AT ROW 9.5 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     c-desc-conta AT ROW 9.5 COL 38.29 COLON-ALIGNED NO-LABEL
     movto-estoq.sc-codigo AT ROW 10.5 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     c-desc-ccusto AT ROW 10.5 COL 38.29 COLON-ALIGNED NO-LABEL
     movto-estoq.quantidade AT ROW 11.5 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     de-valor-mat-1 AT ROW 13.96 COL 15.86 COLON-ALIGNED NO-LABEL
     de-valor-mob-1 AT ROW 13.96 COL 38.72 COLON-ALIGNED NO-LABEL
     de-valor-ggf-1 AT ROW 13.96 COL 61 COLON-ALIGNED NO-LABEL
     de-valor-mat-2 AT ROW 14.96 COL 15.86 COLON-ALIGNED NO-LABEL
     de-valor-mob-2 AT ROW 14.96 COL 38.72 COLON-ALIGNED NO-LABEL
     de-valor-ggf-2 AT ROW 14.96 COL 61 COLON-ALIGNED NO-LABEL
     de-valor-mat-3 AT ROW 15.96 COL 15.86 COLON-ALIGNED NO-LABEL
     de-valor-mob-3 AT ROW 15.96 COL 38.72 COLON-ALIGNED NO-LABEL
     de-valor-ggf-3 AT ROW 15.96 COL 61 COLON-ALIGNED NO-LABEL
     fi-Mat AT ROW 13.04 COL 16.43 COLON-ALIGNED NO-LABEL
     fi-mob AT ROW 13.04 COL 38.72 COLON-ALIGNED NO-LABEL
     fi-ggf AT ROW 13.04 COL 61.29 COLON-ALIGNED NO-LABEL
     fi-moeda-1 AT ROW 14.04 COL 7 NO-LABEL
     fi-moeda-2 AT ROW 15.04 COL 7 NO-LABEL
     fi-moeda-3 AT ROW 16.13 COL 7 NO-LABEL
     RECT-1 AT ROW 12.75 COL 4.14
     RECT-6 AT ROW 3.25 COL 1
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.movto-estoq
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
         HEIGHT             = 16.75
         WIDTH              = 89.
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
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-ccusto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-conta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-depos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-local IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ref IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-unid IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       movto-estoq.cod-depos:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-cod-depos:HANDLE.

/* SETTINGS FOR FILL-IN movto-estoq.cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       movto-estoq.cod-localiz:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-cod-localiz:HANDLE.

/* SETTINGS FOR FILL-IN movto-estoq.cod-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-per-ppm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-ggf-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-ggf-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-ggf-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-mat-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-mat-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-mat-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-mob-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-mob-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-mob-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dt-vali-lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-ggf IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-Mat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-mob IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-moeda-1 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-moeda-2 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-moeda-3 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN movto-estoq.lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.quantidade IN FRAME f-main
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

&Scoped-define SELF-NAME movto-estoq.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-depos V-table-Win
ON F5 OF movto-estoq.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
    {include/zoomvar.i &prog-zoom = "inzoom/z01in084.w"
                       &campo     = movto-estoq.cod-depos
                       &campozoom = cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-depos V-table-Win
ON LEAVE OF movto-estoq.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
   {include/leave.i &tabela=deposito
                    &atributo-ref=nome
                    &variavel-ref=c-desc-depos
                    &where="deposito.cod-depos = input frame {&frame-name} movto-estoq.cod-depos"}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-estabel V-table-Win
ON ENTRY OF movto-estoq.cod-estabel IN FRAME f-main /* Estabel */
DO:
    &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
        IF NOT l-executou-zoom-estab THEN
            ASSIGN c-cod-estabel-ant = movto-estoq.cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        ASSIGN l-executou-zoom-estab = NO.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-estabel V-table-Win
ON F5 OF movto-estoq.cod-estabel IN FRAME f-main /* Estabel */
DO:
    assign l-implanta = yes.
    {include/zoom.i &prog-zoom="adzoom/z01ad107.w"
                    &tabela=movto-estoq
                    &atributo=cod-estabel}
    &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN                    
        ASSIGN l-executou-zoom-estab = YES.                   
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-estabel V-table-Win
ON LEAVE OF movto-estoq.cod-estabel IN FRAME f-main /* Estabel */
DO:
   {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-desc-estab
                   &where="estabelec.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel"}.
                   
    &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
        IF (movto-estoq.cod-depos:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = "" OR 
            c-cod-estabel-ant <> INPUT FRAME {&FRAME-NAME} movto-estoq.cod-estabel) THEN
            RUN pi-trata-dep-localiz IN THIS-PROCEDURE.
    &ENDIF
    

    find estabelec where
         estabelec.cod-estabel = SELF:SCREEN-VALUE no-lock no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec.    

    IF AVAIL estabelec THEN DO:
        /* Retorna formato da conta contabil */
        run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,            /* EMPRESA EMS2 */
                                                           input  "",                   /* PLANO CONTAS */
                                                           input  input movto-estoq.dt-trans, /* DATA DE TRANSACAO */
                                                           output c-formato-conta,      /* FORMATO CONTA */
                                                           output table tt_log_erro).   /* ERROS */
        /* Retorna formato do centro de custo */
        run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,            /* EMPRESA EMS2 */
                                                       input  "",                   /* PLANO CCUSTO */
                                                       input  input movto-estoq.dt-trans, /* DATA DE TRANSACAO */
                                                       output c-formato-ccusto,     /* FORMATO CCUSTO */
                                                       output table tt_log_erro).   /* ERROS */ 
        
        IF c-formato-conta <> "" THEN
          ASSIGN movto-estoq.ct-codigo:FORMAT IN FRAME {&FRAME-NAME} = c-formato-conta.
        IF c-formato-ccusto <> "" THEN
          ASSIGN movto-estoq.sc-codigo:FORMAT IN FRAME {&FRAME-NAME} = c-formato-ccusto.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-estabel IN FRAME f-main /* Estabel */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-localiz V-table-Win
ON F5 OF movto-estoq.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:

    &SCOPED-DEFINE estab    input frame {&FRAME-NAME} movto-estoq.cod-estabel
    &SCOPED-DEFINE deposito input frame {&FRAME-NAME} movto-estoq.cod-depos

    {include/zoom.i
        &prog-zoom   = "inzoom/z02in189.w"
        &tabela      = movto-estoq
        &atributo    = cod-localiz
        &parametros  = "run pi-faixa in wh-pesquisa
                            ({&estab}, {&deposito}, {&deposito})."}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-localiz V-table-Win
ON LEAVE OF movto-estoq.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
    {include/leave.i &tabela=localizacao
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-local
                   &where="localizacao.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz and
                           localizacao.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel and
                           localizacao.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-refer V-table-Win
ON F5 OF movto-estoq.cod-refer IN FRAME f-main /* Referˆncia */
DO:
   assign l-implanta = yes. 
   {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                      &campo=movto-estoq.cod-refer
                      &campozoom=cod-refer
                      &parametros="run pi-seta-inicial in wh-pesquisa
                      (input movto-estoq.it-codigo:screen-value in frame {&frame-name})."}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-refer V-table-Win
ON LEAVE OF movto-estoq.cod-refer IN FRAME f-main /* Referˆncia */
DO:
   {include/leave.i &tabela=referencia
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-ref
                   &where="referencia.cod-refer = input frame {&frame-name} movto-estoq.cod-refer"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-refer IN FRAME f-main /* Referˆncia */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.ct-codigo V-table-Win
ON ENTRY OF movto-estoq.ct-codigo IN FRAME f-main /* Conta */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
  ENABLE movto-estoq.sc-codigo WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.ct-codigo V-table-Win
ON F5 OF movto-estoq.ct-codigo IN FRAME f-main /* Conta */
DO:

   def var v_cod_finalid as char no-undo.                                               
  /* assign v_cod_finalid = {adinc/i05ad049.i 4 9}. */ /* 9 - Saldo por grupo de estoque */
   assign v_cod_finalid = "(nenhum)".

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* M–DULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  v_cod_finalid,      /* FINALIDADES */
                                                  input  INPUT movto-estoq.dt-trans, /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 

   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN movto-estoq.ct-codigo:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-desc-conta:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.ct-codigo V-table-Win
ON LEAVE OF movto-estoq.ct-codigo IN FRAME f-main /* Conta */
DO:
    def var dt-transacao as date no-undo.
    
    &SCOPED-DEFINE conta     movto-estoq.ct-codigo
    &SCOPED-DEFINE descricao c-desc-conta

    assign c-estab = input frame {&FRAME-NAME} movto-estoq.cod-estabel.
    assign dt-transacao = input frame {&FRAME-NAME} movto-estoq.dt-trans.
    
    find estabelec where
         estabelec.cod-estabel = c-estab no-lock no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec.

    do with frame {&FRAME-NAME}:

        /*** Busca dados da conta contÿbil *****************/
        ASSIGN SELF:FORMAT = "x(20)".
        ASSIGN v_cod_cta_ctbl = replace(input movto-estoq.ct-codigo,".", "").
        
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,           /* EMPRESA EMS2 */
                                                       input        "",                  /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,      /* CONTA */
                                                       input        dt-transacao,        /* DATA TRANSACAO */   
                                                       output       v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl,  /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl,  /* SITUA°€O DA CONTA */
                                                       output       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).        /* ERROS */

        IF RETURN-VALUE = "OK" THEN DO:
            ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
            ASSIGN SELF:FORMAT = c-formato-conta.
    
            /* Verifica se a conta utiliza centro de custo */
            run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,            /* EMPRESA EMS 2 */
                                                               input  c-estab,              /* ESTABELECIMENTO EMS2 */
                                                               input  "",                   /* PLANO CONTAS */
                                                               input  v_cod_cta_ctbl,       /* CONTA */
                                                               input  dt-transacao,         /* DT TRANSACAO */
                                                               output v_log_utz_ccusto,     /* UTILIZA CCUSTO ? */
                                                               output table tt_log_erro).   /* ERROS */
            IF v_log_utz_ccusto THEN DO:
                ENABLE movto-estoq.sc-codigo WITH FRAME {&FRAME-NAME}.
            END.
            ELSE DO:
                ASSIGN movto-estoq.sc-codigo:SCREEN-VALUE = "".
                ASSIGN c-desc-ccusto:SCREEN-VALUE = "".
                DISABLE movto-estoq.sc-codigo WITH FRAME {&FRAME-NAME}.
            END.
            /************************************************/
        END.

        assign c-desc-conta:SCREEN-VALUE = v_titulo_cta_ctbl.

    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.ct-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.ct-codigo IN FRAME f-main /* Conta */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-valor-ggf-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor-ggf-1 V-table-Win
ON LEAVE OF de-valor-ggf-1 IN FRAME f-main
DO:
    run pi-processa-valor(de-valor-ggf-1:handle in frame {&FRAME-NAME},
                          de-valor-ggf-2:handle in frame {&FRAME-NAME},
                          de-valor-ggf-3:handle in frame {&FRAME-NAME}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-valor-mat-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor-mat-1 V-table-Win
ON LEAVE OF de-valor-mat-1 IN FRAME f-main
DO:
    run pi-processa-valor(de-valor-mat-1:handle in frame {&FRAME-NAME},
                          de-valor-mat-2:handle in frame {&FRAME-NAME},
                          de-valor-mat-3:handle in frame {&FRAME-NAME}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-valor-mob-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor-mob-1 V-table-Win
ON LEAVE OF de-valor-mob-1 IN FRAME f-main
DO:
    run pi-processa-valor(de-valor-mob-1:handle in frame {&FRAME-NAME},
                          de-valor-mob-2:handle in frame {&FRAME-NAME},
                          de-valor-mob-3:handle in frame {&FRAME-NAME}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.it-codigo V-table-Win
ON ENTRY OF movto-estoq.it-codigo IN FRAME f-main /* Item */
DO:
    &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
        IF NOT l-executou-zoom-item THEN
            ASSIGN c-it-codigo-ant = movto-estoq.it-codigo:SCREEN-VALUE IN FRAME {&frame-name}.
        ASSIGN l-executou-zoom-item = NO.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.it-codigo V-table-Win
ON F5 OF movto-estoq.it-codigo IN FRAME f-main /* Item */
DO:
   assign l-implanta = yes. 
   {include/zoom.i &prog-zoom="inzoom/z02in172.w"
                   &tabela=movto-estoq
                   &atributo=it-codigo} 
   &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN                   
   ASSIGN l-executou-zoom-item = YES.        
   &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.it-codigo V-table-Win
ON LEAVE OF movto-estoq.it-codigo IN FRAME f-main /* Item */
DO:
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=c-descricao
                     &where="item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo"}.

    find item
        where item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo
        no-lock no-error.
    if  avail item then do:

        if  item.tipo-contr = 4 then do:
            /* Item de d‚bito direto nao aceita implantacao de saldo */
            run utp/ut-msgs.p (input "show", input 3318, input "").
            return no-apply.
        end.
        else
            if item.tipo-contr = 1 then do:
                assign de-valor-mat-1:screen-value in frame {&frame-name} = "0"
                       de-valor-mat-2:screen-value in frame {&frame-name} = "0"
                       de-valor-mat-3:screen-value in frame {&frame-name} = "0"
                       de-valor-mob-1:screen-value in frame {&frame-name} = "0"
                       de-valor-mob-2:screen-value in frame {&frame-name} = "0"
                       de-valor-mob-3:screen-value in frame {&frame-name} = "0"
                       de-valor-ggf-1:screen-value in frame {&frame-name} = "0"
                       de-valor-ggf-2:screen-value in frame {&frame-name} = "0"
                       de-valor-ggf-3:screen-value in frame {&frame-name} = "0".
                disable de-valor-mat-1 
                        de-valor-mob-1
                        de-valor-ggf-1
                        with frame {&frame-name}. 
            end.
            else
                enable de-valor-mat-1 
                       de-valor-mob-1
                       de-valor-ggf-1
                       with frame {&frame-name}. 

        &IF '{&bf_mat_versao_ems}' < '2.04' &THEN
            disp item.cod-localiz @ movto-estoq.cod-localiz
                 with frame {&frame-name}.
        &ENDIF

        IF ITEM.tipo-con-est <= 2 THEN 
            ASSIGN movto-estoq.lote:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   dt-vali-lote:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ?
            &IF '{&bf_mat_versao_ems}' < '2.04' &THEN
                   c-desc-local:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
            &ENDIF.

        if  item.tipo-con-est = 4 then 
            enable  movto-estoq.cod-refer with frame {&frame-name}.
        else DO:
            disable movto-estoq.cod-refer with frame {&frame-name}.
            ASSIGN movto-estoq.cod-refer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   c-desc-ref:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = "".
        END.


        if  item.tipo-con-est <> 1 then 
            enable  movto-estoq.lote with frame {&frame-name}.
        else DO:
            disable movto-estoq.lote with frame {&frame-name}.
            ASSIGN movto-estoq.lote:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
        END.

        if  item.tipo-con-est > 2 then 
            enable  dt-vali-lote with frame {&frame-name}.
        else 
            disable dt-vali-lote with frame {&frame-name}.

        &IF '{&bf_mat_versao_ems}' < '2.04' &THEN
            if  not item.loc-unica then 
                enable  movto-estoq.cod-localiz with frame {&frame-name}.
            else 
                disable movto-estoq.cod-localiz with frame {&frame-name}.
        &ENDIF

        if  item.tipo-con-est = 2
            then disp 1 @ movto-estoq.quantidade with frame  {&frame-name}.

        if  item.tipo-con-est <> 2
            then enable  movto-estoq.quantidade with frame {&frame-name}.
            else disable movto-estoq.quantidade with frame {&frame-name}.
    end.

    &IF DEFINED(bf_man_per_ppm) &THEN
        IF  AVAIL item THEN DO:
            DISABLE de-per-ppm WITH FRAME {&FRAME-NAME}.
            ASSIGN de-per-ppm:LABEL IN FRAME {&FRAME-NAME} = "":U.

            IF  item.tipo-formula = 1 THEN DO:
                {utp/ut-liter.i NÆo_Utiliza *}
                ASSIGN de-per-ppm:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
            END.
                
            IF  item.tipo-formula = 2 AND
                item.tipo-con-est = 3 THEN DO: /* controlado por lote */
                ASSIGN de-per-ppm:FORMAT IN FRAME {&FRAME-NAME} = ">>9.9999".
                {utp/ut-liter.i Concentra‡Æo(%) *}
                ASSIGN de-per-ppm:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
                ENABLE de-per-ppm WITH FRAME {&FRAME-NAME}.
            END.

            IF  item.tipo-formula = 3 AND
                item.tipo-con-est = 3 THEN DO: /* controlado por lote */
                {utp/ut-liter.i PPM *}
                ASSIGN de-per-ppm:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
                ENABLE de-per-ppm WITH FRAME {&FRAME-NAME}.
            END.

            IF  item.tipo-formula = 4 THEN DO:
                {utp/ut-liter.i Ve¡culo *}
                ASSIGN de-per-ppm:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
            END.
        END.
    &ENDIF

    &if defined(bf_dis_default_UN) &then

        find first param-mat no-lock no-error.
          if avail param-mat
               and param-mat.ind-sit-un = 2 then do:

            {include/leave.i &tabela=item
                   &atributo-ref=un
                   &variavel-ref=movto-estoq.un
                   &where="item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo"}
        end.

    &endif
    &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
        IF (movto-estoq.cod-depos:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = "" OR 
            c-it-codigo-ant <> INPUT FRAME {&frame-name} movto-estoq.it-codigo) THEN
            RUN pi-trata-dep-localiz IN THIS-PROCEDURE.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.it-codigo IN FRAME f-main /* Item */
DO:
     apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.lote V-table-Win
ON LEAVE OF movto-estoq.lote IN FRAME f-main /* Lote/S‚rie */
DO:

 find first saldo-estoq where 
            saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo   and
            saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote
            no-lock no-error.

 &if defined (bf_man_per_ppm) &then
    if item.tipo-con-est = 3 AND (ITEM.tipo-formula = 2 OR ITEM.tipo-formula = 3) then do: /* lote */
       enable de-per-ppm with frame {&frame-name}.
       if avail saldo-estoq then do:
          ASSIGN de-per-ppm = saldo-estoq.per-ppm.      
          disp saldo-estoq.per-ppm @ de-per-ppm with frame {&frame-name}.
          disable de-per-ppm with frame {&frame-name}.
       end.         
       IF NOT AVAIL SALDO-ESTOQ THEN do:
           ASSIGN de-per-ppm = ITEM.per-ppm.
           DISP ITEM.per-ppm @ de-per-ppm WITH FRAME {&frame-name}.
           enable de-per-ppm with frame {&frame-name}.
       end.
    end.
    ELSE DO:
       disable de-per-ppm with frame {&frame-name}.
    END.
 &endif

 if not avail saldo-estoq then do:
    IF ITEM.tipo-con-est > 2 THEN DO:
        assign dt-vali-lote:screen-value in frame {&frame-name} = ?
               dt-vali-lote:sensitive    in frame {&frame-name} = yes.
        apply "entry" to dt-vali-lote in frame {&frame-name}.
        return no-apply.             
    END.
    ELSE
        DISABLE dt-vali-lote WITH FRAME {&FRAME-NAME}.
 end.
 else
    assign dt-vali-lote:screen-value in frame {&frame-name} = string(saldo-estoq.dt-vali-lote)
           dt-vali-lote:sensitive    in frame {&frame-name} = no. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomDepos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomDepos V-table-Win
ON CHOOSE OF MENU-ITEM mZoomDepos /* Zoom de Dep¢sitos */
DO:
    Apply "F5" to movto-estoq.cod-depos in frame {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomLocal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomLocal V-table-Win
ON CHOOSE OF MENU-ITEM mZoomLocal /* Zoom de Localiza‡äes */
DO:
    apply "F5" to movto-estoq.cod-localiz in frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalDep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalDep V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalDep /* Zoom de Saldos */
DO:
    assign
        l-implanta = yes
        c-estab     = input frame {&FRAME-NAME} movto-estoq.cod-estabel
        c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.

    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = movto-estoq.cod-depos
        &campo2     = movto-estoq.cod-localiz
        &campo3     = movto-estoq.lote
        &campo4     = movto-estoq.cod-refer
        &campozoom  = cod-depos
        &campozoom2 = cod-localiz
        &campozoom3 = lote
        &campozoom4 = referencia}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalLoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalLoc V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalLoc /* Zoom de Saldos */
DO:
    assign
        l-implanta = yes
        c-estab     = input frame {&FRAME-NAME} movto-estoq.cod-estabel
        c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.

    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = movto-estoq.cod-localiz
        &campozoom  = cod-localiz
        &campo2     = movto-estoq.cod-depos
        &campozoom2 = cod-depos
        &campo3     = movto-estoq.lote
        &campozoom3 = lote
        &campo4     = movto-estoq.cod-refer
        &campozoom4 = referencia
        &parametros = "run pi-inicializa-paginas in wh-pesquisa.
                       run pi-set-faixa-dep in wh-pesquisa
                            (movto-estoq.cod-depos:screen-value in frame {&FRAME-NAME},
                             movto-estoq.cod-depos:screen-value in frame {&FRAME-NAME})."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.sc-codigo V-table-Win
ON F5 OF movto-estoq.sc-codigo IN FRAME f-main /* Sub-Conta */
DO:
   def var dt-transacao as date no-undo. 
   assign dt-transacao = input frame {&FRAME-NAME} movto-estoq.dt-trans.
    
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,            /* EMPRESA EMS2 */
                                       input "",                   /* CODIGO DO PLANO CCUSTO */
                                       input "",                   /* UNIDADE DE NEGOCIO */
                                       input  dt-transacao,        /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,        /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,     /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).  /* ERROS */ 

   IF v_titulo_ccusto <> "" THEN DO:
       ASSIGN movto-estoq.sc-codigo:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-desc-ccusto:SCREEN-VALUE = v_titulo_ccusto.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.sc-codigo V-table-Win
ON LEAVE OF movto-estoq.sc-codigo IN FRAME f-main /* Sub-Conta */
DO:
    def var dt-transacao as date no-undo. 
    assign dt-transacao = input frame {&FRAME-NAME} movto-estoq.dt-trans.    
    
    {cdp/cd9998.i}
    ASSIGN v_cod_ccusto = replace(INPUT movto-estoq.sc-codigo, ".", "").
    
    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,           /* EMPRESA EMS2 */
                                               input  "",                  /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,        /* CCUSTO */
                                               input  dt-transacao,        /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,     /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro).  /* ERROS */
    if v_titulo_ccusto <> "" then do:                                           
        ASSIGN movto-estoq.sc-codigo:SCREEN-VALUE = v_cod_ccusto.
        ASSIGN c-desc-ccusto:SCREEN-VALUE = v_titulo_ccusto.                                            
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.sc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.sc-codigo IN FRAME f-main /* Sub-Conta */
DO:
  apply 'F5' to self.
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
ON LEAVE OF movto-estoq.un IN FRAME f-main /* Unid Medid */
DO:
   {include/leave.i &tabela=tab-unidade
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-unid
                   &where="tab-unidade.un = input frame {&frame-name} movto-estoq.un"}.
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

    find first param-estoq  no-lock no-error.

    find first param-global no-lock no-error.

    if not avail param-estoq then do:
       run utp/ut-msgs.p (input "show", input 1059, input "").
       RUN dispatch IN THIS-PROCEDURE ('adm-exit':U).
    end.

    &IF  DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
        RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
    &ENDIF         


    do with frame {&FRAME-NAME}:
        if movto-estoq.it-codigo:load-mouse-pointer      ("image/lupa.cur") then.
        if movto-estoq.cod-estabel:load-mouse-pointer    ("image/lupa.cur") then.
        if movto-estoq.cod-depos:load-mouse-pointer      ("image/lupa.cur") then.
        if movto-estoq.cod-localiz:load-mouse-pointer    ("image/lupa.cur") then.
        if movto-estoq.cod-refer:load-mouse-pointer      ("image/lupa.cur") then.
        if movto-estoq.un:load-mouse-pointer             ("image/lupa.cur") then.
        if movto-estoq.ct-codigo:load-mouse-pointer      ("image/lupa.cur") then. 
        if movto-estoq.sc-codigo:load-mouse-pointer      ("image/lupa.cur") then.

        {utp/ut-field.i movind movto-estoq ct-codigo 3}
        movto-estoq.ct-codigo:help = return-value.

        {utp/ut-field.i movind movto-estoq sc-codigo 3}
        movto-estoq.sc-codigo:help = return-value.
    end.

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
  {src/adm/template/row-list.i "movto-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-estoq"}

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
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  assign movto-estoq.dt-trans:screen-value in frame {&frame-name} = string(today).

  display fi-moeda-1 fi-moeda-2 fi-moeda-3
          fi-mat     fi-mob     fi-ggf with frame {&frame-name}.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  if  session:set-wait-state ("GENERAL":U) then .

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */

  find first saldo-estoq no-lock no-error.

  if avail saldo-estoq and 
     input frame {&frame-name} dt-vali-lote < today then do:
     /* Data de validade do lote deve ser maior ou igual a atual */
     run utp/ut-msgs.p (input "show", input 8015, input "").
     return 'ADM-ERROR':U.
  end.

  if input frame {&frame-name} movto-estoq.un <> item.un then do:
        run utp/ut-msgs.p (input "show", input 1225, input "").
        return 'ADM-ERROR':U.
  end.

  find localizacao where
       localizacao.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz and
       localizacao.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos and
       localizacao.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel no-lock no-error.

  if not avail localizacao then do:
        run utp/ut-msgs.p (input "show", input 6662, input "").
        return 'ADM-ERROR':U.
  end.

  if item.tipo-con-est > 2 then do:
     if input frame {&frame-name} dt-vali-lote = ? then do:
        /* Data de validade do lote deve possuir valor */
        run utp/ut-msgs.p (input "show", input 3356, input "").
        return 'ADM-ERROR':U.
     end.
  end.

  if item.tipo-con-est = 3 then do:
     if input frame {&frame-name} movto-estoq.lote = "" then do:
        /* Item controlado por lote. Lote deve ser informado */
        run utp/ut-msgs.p (input "show", input 3319, input "").
        return 'ADM-ERROR':U.
     end.
  end.

  /* valida fator de concentra‡Æo / ppm */
  &if defined (bf_man_per_ppm) &then 
      if item.tipo-con-est = 3 AND (ITEM.tipo-formula = 2 OR ITEM.tipo-formula = 3) then do:
         /* valida fator concentra‡Æo / ppm obrigatoriedade > 0 */
         if  input frame {&frame-name} DE-PER-PPM = 0 then do:
             /* Inicio -- Projeto Internacional */
             {utp/ut-liter.i "fator_de_concentra‡Æo_ppm_deve_ser_maior_que_0" *}
             run utp/ut-msgs.p (input "show", input 17006, input RETURN-VALUE + ".").
             return 'ADM-ERROR':U.
         end.
      end.         
  &endif

  if item.tipo-con-est = 4 then do:
     if input frame {&frame-name} movto-estoq.lote = "" then do:
        /* Item controlado por lote. Lote deve ser informado */
        run utp/ut-msgs.p (input "show", input 3319, input "").
        return 'ADM-ERROR':U.
     end.
  end.

  if item.tipo-con-est = 2 then do:
     if input frame {&frame-name} movto-estoq.lote = "" then do:
        /* Item controlado por N£mero de S‚rie. A S‚rie deve ser informada */
        run utp/ut-msgs.p (input "show", input 8829, input "").
        return 'ADM-ERROR':U.
     end.
  end.

  IF AVAIL ITEM THEN DO:
      &IF '{&bf_mat_versao_ems}':U >= '2.08':U &THEN
          IF  ITEM.log-orig-ext = YES AND 
              deposito.ind-dep-cq = NO THEN DO:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-item-nao-pode-ter-saldo-implantado AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Item_nÆo_pode_ter_saldo_implantado" *}
              ASSIGN c-lbl-liter-item-nao-pode-ter-saldo-implantado = TRIM(RETURN-VALUE).
              DEFINE VARIABLE c-lbl-liter-item-nao-pode-ter-saldo-implantado-2 AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Item_nÆo_pode_ter_saldo_implantado,_pois_foi_criado_pelo_Sistema_Hospitalar" *}
              ASSIGN c-lbl-liter-item-nao-pode-ter-saldo-implantado-2 = TRIM(RETURN-VALUE).
              RUN utp/ut-msgs.p(INPUT 'show':U,
                                INPUT 17006,
                                INPUT c-lbl-liter-item-nao-pode-ter-saldo-implantado + '~~':U +
                                      c-lbl-liter-item-nao-pode-ter-saldo-implantado-2 + '.').
              RETURN 'adm-error':U.
          END.
      &ELSE
          &IF '{&bf_mat_versao_ems}':U >= '2.062':U &THEN
              IF TRIM(SUBSTRING(ITEM.char-1,267,1)) = 'S':U AND 
                 deposito.ind-dep-cq = NO THEN DO:
                  /* Inicio -- Projeto Internacional */
                  DEFINE VARIABLE c-lbl-liter-item-nao-pode-ter-saldo-implantado-3 AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "Item_nÆo_pode_ter_saldo_implantado" *}
                  ASSIGN c-lbl-liter-item-nao-pode-ter-saldo-implantado-3 = TRIM(RETURN-VALUE).
                  DEFINE VARIABLE c-lbl-liter-item-nao-pode-ter-saldo-implantado-4 AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "Item_nÆo_pode_ter_saldo_implantado,_pois_foi_criado_pelo_Sistema_Hospitalar" *}
                  ASSIGN c-lbl-liter-item-nao-pode-ter-saldo-implantado-4 = TRIM(RETURN-VALUE).
                  RUN utp/ut-msgs.p(INPUT 'show':U,
                                    INPUT 17006,
                                    INPUT c-lbl-liter-item-nao-pode-ter-saldo-implantado-3 + '~~':U +
                                          c-lbl-liter-item-nao-pode-ter-saldo-implantado-4 + '.').
                  RETURN 'adm-error':U.
              END.
          &ENDIF
      &ENDIF
  END.
 
  find deposito
      where deposito.cod-depos = input frame {&frame-name} movto-estoq.cod-depos
      no-lock no-error.
  if  avail deposito then do:
      if  deposito.ind-dep-cq then do:
          /* Implanta‡Æo nÆo permitida p/ Dep¢sito de CQ */
          run utp/ut-msgs.p (input "show":u, input 8832, input "").
          return 'ADM-ERROR':U.
      end.
      if  deposito.ind-dep-rej then do:
          /* Implanta‡Æo nÆo permitida p/ Dep¢sito de Rejei‡Æo */
          run utp/ut-msgs.p (input "show":u, input 8833, input "").
          return 'ADM-ERROR':U.
      end.
  end.

  if  item.tipo-con-est = 4 then do:
      find referencia
          where referencia.cod-refer = input frame {&frame-name} movto-estoq.cod-refer
          no-lock no-error.
      if  not avail referencia then do:
         /* Referˆncia nÆo Cadastrada */
          run utp/ut-msgs.p (input "show":u, input 4539, input "").
          return 'ADM-ERROR':U.
      end.
  end.
  else do:
      if  input frame {&frame-name} movto-estoq.cod-refer <> " "
      and input frame {&frame-name} movto-estoq.cod-refer <> ? then do:
          /* Item nÆo controlado por referˆncia, nÆo pode ser alterado. */
          run utp/ut-msgs.p (input "show":u, input 4158, input return-value).
          return 'ADM-ERROR':U.
      end.
  end.

  find first saldo-estoq
     where saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
     and   saldo-estoq.cod-refer   = input frame {&frame-name} movto-estoq.cod-refer
     and   saldo-estoq.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel
     and   saldo-estoq.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos
     and   saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz
     and   saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote
     no-lock no-error.
  if avail saldo-estoq then do:
     /* Item ja possui saldo em estoque */
     run utp/ut-msgs.p (input "show", input 3320, input "").
     return 'adm-error'.
  end.

  assign i-empresa = i-ep-codigo-usuario.
  find estabelec where
       estabelec.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel no-lock no-error.
  assign i-empresa = estabelec.ep-codigo when avail estabelec. 
  
  assign c-estab = input frame {&frame-name} movto-estoq.cod-estabel. 

  /*** Busca dados da conta contÿbil *****************/
  DEF VAR dt-transacao AS DATE NO-UNDO.
  ASSIGN dt-transacao = input frame {&frame-name} movto-estoq.dt-trans.

  assign movto-estoq.ct-codigo:format in frame {&FRAME-NAME} = "x(20)".
  ASSIGN v_cod_cta_ctbl = input frame {&frame-name} movto-estoq.ct-codigo.
  assign movto-estoq.ct-codigo:format in frame {&FRAME-NAME} = c-formato-conta.
  run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                 input        "",                 /* PLANO DE CONTAS */
                                                 input-output v_cod_cta_ctbl,     /* CONTA */
                                                 input        dt-transacao,       /* DATA TRANSACAO */   
                                                 output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                 output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                 output       v_num_sit_cta_ctbl, /* SITUA°€O DA CONTA */
                                                 output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                 output table tt_log_erro).       /* ERROS */
  /* Erros Conta Contÿbil */
  FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
  IF AVAIL tt_log_erro THEN DO:
     run utp/ut-msgs.p (input "show", input 1781, STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
     return 'adm-error'.
  END.

  if v_num_sit_cta_ctbl <> 3 then do:
     /* Conta nao e de Sistema */
     run utp/ut-msgs.p (input "show", input 443, input "").
     return 'adm-error'.
  end.

  /*if conta -contab.estoque = 0 then do:*/
  if lookup("(nenhum)", v_ind_finalid_cta) <> 0 OR v_ind_finalid_cta = "" then do:
     /* Conta nao permite lancamento de estoque */
     run utp/ut-msgs.p (input "show", input 445, input "").
     return 'adm-error'.
  end.

  if v_num_tip_cta_ctbl = 6 then do:
     /* Conta nao pode ser de Titulo */
     run utp/ut-msgs.p (input "show", input 286, input "").
     return 'adm-error'.
  end.
    
  /* Verifica se a conta utiliza centro de custo */
  run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                     input  c-estab,            /* ESTABELECIMENTO EMS2 */
                                                     input  "",                 /* PLANO CONTAS */
                                                     input  v_cod_cta_ctbl,     /* CONTA */
                                                     input  dt-transacao,       /* DT TRANSACAO */
                                                     output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                     output table tt_log_erro). /* ERROS */

  /* Utiliza centro de custo? */
  IF v_log_utz_ccusto THEN DO:
      /* Busca dados do centro de custo */
      assign movto-estoq.sc-codigo:format in frame {&FRAME-NAME} = "x(20)".
      ASSIGN v_cod_ccusto = input frame {&frame-name} movto-estoq.sc-codigo.
      assign movto-estoq.sc-codigo:format in frame {&FRAME-NAME} = c-formato-ccusto.
    
      run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                 input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                 input  v_cod_ccusto,       /* CCUSTO */
                                                 input  dt-transacao,       /* DATA DE TRANSACAO */
                                                 output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */
      /* Erros Centro Custo */
      FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
      IF AVAIL tt_log_erro THEN DO:
        run utp/ut-msgs.p (input "show":U,
                           input 17006,
                           STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
        return 'adm-error'.
      END.
  END.
  ELSE DO:
      ASSIGN v_cod_ccusto = "".
      assign movto-estoq.sc-codigo:SCREEN-VALUE in frame {&FRAME-NAME} = "".
  END.

  if  input frame {&frame-name} movto-estoq.dt-trans >= today
  and input frame {&frame-name} movto-estoq.dt-trans < estabelec.medio-ate then do:
      /* Data invalida para lancamento */
      run utp/ut-msgs.p (input "show", input 3324, input "").
      return 'adm-error'.
  end.

  assign c-periodo = string(year(input  frame {&frame-name} movto-estoq.dt-trans),"9999")
                   + string(month(input frame {&frame-name} movto-estoq.dt-trans),"99").
  if  param-estoq.tem-moeda1
  and not can-find(cotacao
              where cotacao.mo-codigo   = param-estoq.moeda1
              and   cotacao.ano-periodo = c-periodo) then do:
      /* Nao existe cotacao para moeda 1 nesta data */
      run utp/ut-msgs.p (input "show", input 3326, input "").
      return 'adm-error'.
  end.

  if  param-estoq.tem-moeda2
  and not can-find(cotacao
              where cotacao.mo-codigo   = param-estoq.moeda2
              and   cotacao.ano-periodo = c-periodo) then do:
      /* Nao existe cotacao para moeda 2 nesta data */
      run utp/ut-msgs.p (input "show", input 3327, input "").
      return 'adm-error'.
  end.

  if item.tipo-con-est <> 2 then do:
     if input frame {&frame-name} movto-estoq.quantidade <= 0 then do:
        /* Quantidade nao pode ser zero */
        run utp/ut-msgs.p (input "show", input 1368, input "").
        return 'adm-error'.
     end.
     if  not(item.fraciona)
     and input frame {&frame-name} movto-estoq.quantidade
      <> integer(input frame {&frame-name} movto-estoq.quantidade) then do:
         /* Quantidade deve ser um valor inteiro */
         run utp/ut-msgs.p (input "show", input 1222, input "").
         return 'adm-error'.
     end.
  end.
  assign da-dt-cotacao = input frame {&frame-name} movto-estoq.dt-trans.

  if input frame {&frame-name} de-valor-mat-1 <= 0 and item.tipo-contr <> 1 then do:
     /* Valor do material deve ser maior que zero */
     run utp/ut-msgs.p (input "show", input 3328, input "").
     return 'adm-error'.
  end.

  if  param-estoq.tem-moeda1 = yes
     and input frame {&frame-name} de-valor-mat-2 <= 0 and item.tipo-contr <> 1 then do:
      /* Valor do material deve ser maior que zero */
      run utp/ut-msgs.p (input "show", input 3328, input "").
      return 'adm-error'.
  end.

  if  param-estoq.tem-moeda2 = yes
  and input frame {&frame-name} de-valor-mat-3 <= 0 and item.tipo-contr <> 1 then do:
      /* Valor do material deve ser maior que zero */
      run utp/ut-msgs.p (input "show", input 3328, input "").
      return 'adm-error'.
  end.                           

  for each tt-movto:
      delete tt-movto.
  end.
  assign l-rejeita-dec = no.
  create tt-movto.
  assign tt-movto.it-codigo      = input frame {&frame-name} movto-estoq.it-codigo
         tt-movto.cod-refer      = input frame {&frame-name} movto-estoq.cod-refer
         tt-movto.cod-estabel    = input frame {&frame-name} movto-estoq.cod-estabel
         tt-movto.cod-depos      = input frame {&frame-name} movto-estoq.cod-depos
         tt-movto.lote           = input frame {&frame-name} movto-estoq.lote
         tt-movto.cod-localiz    = input frame {&frame-name} movto-estoq.cod-localiz
         tt-movto.dt-trans       = input frame {&frame-name} movto-estoq.dt-trans
         tt-movto.un             = item.un
         tt-movto.quantidade     = input frame {&frame-name} movto-estoq.quantidade
         tt-movto.dt-vali-lote = input frame {&frame-name} dt-vali-lote
         tt-movto.ct-codigo    = v_cod_cta_ctbl
         tt-movto.sc-codigo    = v_cod_ccusto
         tt-movto.tipo-trans   = 1
         tt-movto.esp-docto    = 16
         tt-movto.cod-versao-integracao = 1
         tt-movto.usuario      = c-seg-usuario.
  assign tt-movto.valor-mat-m[1] = fn_vld_ajust_dec(input frame {&frame-name} de-valor-mat-1,0).
  assign tt-movto.valor-mat-m[2] = fn_vld_ajust_dec(input frame {&frame-name} de-valor-mat-2,param-estoq.moeda1).
  assign tt-movto.valor-mat-m[3] = fn_vld_ajust_dec(input frame {&frame-name} de-valor-mat-3,param-estoq.moeda2).
  assign tt-movto.valor-mob-m[1] = fn_vld_ajust_dec(input frame {&frame-name} de-valor-mob-1,0).
  assign tt-movto.valor-mob-m[2] = fn_vld_ajust_dec(input frame {&frame-name} de-valor-mob-2,param-estoq.moeda1).
  assign tt-movto.valor-mob-m[3] = fn_vld_ajust_dec(input frame {&frame-name} de-valor-mob-3,param-estoq.moeda2).
  assign tt-movto.valor-ggf-m[1] = fn_vld_ajust_dec(input frame {&frame-name} de-valor-ggf-1,0).
  assign tt-movto.valor-ggf-m[2] = fn_vld_ajust_dec(input frame {&frame-name} de-valor-ggf-2,param-estoq.moeda1).
  assign tt-movto.valor-ggf-m[3] = fn_vld_ajust_dec(input frame {&frame-name} de-valor-ggf-3,param-estoq.moeda2).      

  &if defined (bf_man_per_ppm) &then    
     ASSIGN tt-movto.per-ppm   = input frame {&frame-name} de-per-ppm.
  &endif
  
  disp tt-movto.valor-mat-m[1] @ de-valor-mat-1 
       tt-movto.valor-mat-m[2] @ de-valor-mat-2 
       tt-movto.valor-mat-m[3] @ de-valor-mat-3
       tt-movto.valor-mob-m[1] @ de-valor-mob-1
       tt-movto.valor-mob-m[2] @ de-valor-mob-2 
       tt-movto.valor-mob-m[3] @ de-valor-mob-3
       tt-movto.valor-ggf-m[1] @ de-valor-ggf-1 
       tt-movto.valor-ggf-m[2] @ de-valor-ggf-2 
       tt-movto.valor-ggf-m[3] @ de-valor-ggf-3 with frame {&frame-name}.

  if l-rejeita-dec then do:
     run utp/ut-msgs.p (input "show",
                        input 18100,
                        input "").
     apply 'entry' to de-valor-mat-1 in frame {&frame-name}.                   
     return 'adm-error'.
  end. 

  if item.tipo-con-est = 2 then
     find first saldo-estoq
        where saldo-estoq.lote      = input frame {&frame-name} movto-estoq.lote
        and   saldo-estoq.it-codigo = input frame {&frame-name} movto-estoq.it-codigo
        no-lock no-error.
  else
     find first saldo-estoq
        where saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
        and   saldo-estoq.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel
        and   saldo-estoq.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos
        and   saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote
        and   saldo-estoq.cod-refer   = input frame {&frame-name} movto-estoq.cod-refer
        and   saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz
        no-lock no-error.
  if avail saldo-estoq then do:
     /* Item ja possui saldo */
     run utp/ut-msgs.p (input "show", input 3320, input "").
     return 'adm-error'.
  end.
  
  find first movto-estoq no-lock no-error.

  find first saldo-estoq 
       where saldo-estoq.it-codigo    =  input frame {&frame-name} movto-estoq.it-codigo
       and   saldo-estoq.dt-vali-lote <> input frame {&frame-name} dt-vali-lote no-lock no-error.
  if avail saldo-estoq 
      and  saldo-estoq.lote = input frame {&frame-name} movto-estoq.lote then do:
        /* Data de validade do lote deve ... */
        run utp/ut-msgs.p (input "show", input 26672, input "").
        return 'ADM-ERROR':U.
  end.

/*  run cep/ceapi001.p (input-output table tt-movto,
                      input-output table tt-erro,input yes). */

  ASSIGN c-retceapi001k = "".

  RUN cep/ceapi001k.p persistent set h-ceapi001k.

  run pi-execute IN h-ceapi001k (input-output table tt-movto,
                                 input-output table tt-erro,
                                 input yes).

  if  valid-handle (h-ceapi001k) then do: 
      delete procedure h-ceapi001k.
      assign h-ceapi001k = ?.
  end.

  ASSIGN c-retceapi001k = RETURN-VALUE.

  if  session:set-wait-state ("":U) then .
  find first tt-erro no-lock no-error.
  if avail tt-erro then do:
     run cdp/cd0666.w (input table tt-erro).
     apply "entry" to movto-estoq.it-codigo in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.

  IF c-retceapi001k = "Nok" THEN
      return 'ADM-ERROR':U.


  /* NÆo gravar nada no registro antes do dispatch do assign-record e nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) . */
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  disable all with frame {&frame-name}.

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  delete object h_api_cta_ctbl.
  delete object h_api_ccusto.

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

  /* Handle da API Conta Contÿbil */
  run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
  /* Handle da API Centro Custo */
  run prgint\utb\utb742za.py persistent set h_api_ccusto.

  if avail movto-estoq then do:
     find item where item.it-codigo = movto-estoq.it-codigo no-lock no-error.
     if avail item
        then assign c-descricao = item.desc-item.
        else assign c-descricao = "":U.

     find estabelec
          where estabelec.cod-estabel = movto-estoq.cod-estabel no-lock no-error.
     if avail estabelec then do:    
        assign c-desc-estab = estabelec.nome
               i-custo      = estabelec.custo-contab. 
        case i-custo:
           when 1 then do: 
              assign de-valor-mat-1 = movto-estoq.valor-mat-m[1]
                     de-valor-mob-1 = movto-estoq.valor-mob-m[1]
                     de-valor-ggf-1 = movto-estoq.valor-ggf-m[1].
              if param-estoq.tem-moeda1 then
                 assign de-valor-mat-2 = movto-estoq.valor-mat-m[2]
                        de-valor-mob-2 = movto-estoq.valor-mob-m[2]
                        de-valor-ggf-2 = movto-estoq.valor-ggf-m[2].
              if param-estoq.tem-moeda2 then
                 assign de-valor-mat-3 = movto-estoq.valor-mat-m[3]
                        de-valor-mob-3 = movto-estoq.valor-mob-m[3]
                        de-valor-ggf-3 = movto-estoq.valor-ggf-m[3].
           end.   
           when 2 then do:
              assign de-valor-mat-1 = movto-estoq.valor-mat-o[1]
                     de-valor-mob-1 = movto-estoq.valor-mob-o[1]
                     de-valor-ggf-1 = movto-estoq.valor-ggf-o[1].
              if param-estoq.tem-moeda1 then
                 assign de-valor-mat-2 = movto-estoq.valor-mat-o[2]
                        de-valor-mob-2 = movto-estoq.valor-mob-o[2]
                        de-valor-ggf-2 = movto-estoq.valor-ggf-o[2].
              if param-estoq.tem-moeda2 then
                 assign de-valor-mat-3 = movto-estoq.valor-mat-o[3]
                        de-valor-mob-3 = movto-estoq.valor-mob-o[3]
                        de-valor-ggf-3 = movto-estoq.valor-ggf-o[3].
           end.
           when 3 then do:
              assign de-valor-mat-1 = movto-estoq.valor-mat-p[1]
                     de-valor-mob-1 = movto-estoq.valor-mob-p[1]
                     de-valor-ggf-1 = movto-estoq.valor-ggf-p[1].
              if param-estoq.tem-moeda1 then
                 assign de-valor-mat-2 = movto-estoq.valor-mat-p[2]
                        de-valor-mob-2 = movto-estoq.valor-mob-p[2]
                        de-valor-ggf-2 = movto-estoq.valor-ggf-p[2].
              if param-estoq.tem-moeda2 then
                 assign de-valor-mat-3 = movto-estoq.valor-mat-p[3]
                        de-valor-mob-3 = movto-estoq.valor-mob-p[3]
                        de-valor-ggf-3 = movto-estoq.valor-ggf-p[3].
           end.
        end case.   
     end.
     else
        assign c-desc-estab = "":U.

     find localizacao
        where localizacao.cod-localiz = movto-estoq.cod-localiz no-lock no-error.
     if avail localizacao
        then assign c-desc-local = localizacao.descricao.   
        else assign c-desc-local = "":U.

     find referencia
        where referencia.cod-refer = movto-estoq.cod-refer no-lock no-error.
     if avail referencia
        then assign c-desc-ref = referencia.descricao.
        else assign c-desc-ref = "":U.

     find deposito
        where deposito.cod-depos = movto-estoq.cod-depos no-lock no-error.
     if avail deposito
        then assign c-desc-depos = deposito.nome.
        else assign c-desc-depos = "":U.

    
    find estabelec where
         estabelec.cod-estabel = movto-estoq.cod-estabel no-lock no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec.    

    /* Retorna formato da conta contabil */
    run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,            /* EMPRESA EMS2 */
                                                       input  "",                   /* PLANO CONTAS */
                                                       input  movto-estoq.dt-trans, /* DATA DE TRANSACAO */
                                                       output c-formato-conta,      /* FORMATO CONTA */
                                                       output table tt_log_erro).   /* ERROS */
    /* Retorna formato do centro de custo */
    run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,            /* EMPRESA EMS2 */
                                                   input  "",                   /* PLANO CCUSTO */
                                                   input  movto-estoq.dt-trans, /* DATA DE TRANSACAO */
                                                   output c-formato-ccusto,     /* FORMATO CCUSTO */
                                                   output table tt_log_erro).   /* ERROS */ 
    
    IF c-formato-conta <> "" THEN
      ASSIGN movto-estoq.ct-codigo:FORMAT IN FRAME {&FRAME-NAME} = c-formato-conta.
    IF c-formato-ccusto <> "" THEN
      ASSIGN movto-estoq.sc-codigo:FORMAT IN FRAME {&FRAME-NAME} = c-formato-ccusto.

    /*** Busca dados da conta contÿbil *****************/
    ASSIGN v_cod_cta_ctbl = movto-estoq.ct-codigo.
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,            /* EMPRESA EMS2 */
                                                   input        "",                   /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,       /* CONTA */
                                                   input        movto-estoq.dt-trans, /* DATA DE TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,    /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl,   /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl,   /* SITUA°€O DA CONTA */
                                                   output       v_ind_finalid_cta,    /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).         /* ERROS */

    ASSIGN c-desc-conta = v_titulo_cta_ctbl.

    /* Busca dados do centro de custo */
    ASSIGN v_cod_ccusto = movto-estoq.sc-codigo.
    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,            /* EMPRESA EMS2 */
                                               input  "",                   /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,         /* CCUSTO */
                                               input  movto-estoq.dt-trans, /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,      /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro).   /* ERROS */

    assign c-desc-ccusto = v_titulo_ccusto.

  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &if defined (bf_man_per_ppm) &then    
  &else
     ASSIGN de-per-ppm:HIDDEN IN FRAME f-main = YES.
  &endif


  find first param-global no-lock no-error.
  find first empresa where 
             empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
  find first param-estoq  no-lock no-error.  
  run pi-set-labels.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-processa-valor V-table-Win 
PROCEDURE pi-processa-valor :
/*------------------------------------------------------------------------------
  Purpose: Faz o processamento necess rio para o campo de valor (mat, mob e ggf)
  Parameters:  <none>
  Notes: h-padrao -> Handle do campo em moeda PadrÆo
         h-alter1 -> Handle do Campo em moeda Alternativa 1
         h-alter2 -> Handle do campo em moeda Alternativa 2
------------------------------------------------------------------------------*/
    define input param h-padrao       as handle no-undo.
    define input param h-alter1       as handle no-undo.
    define input param h-alter2       as handle no-undo.

    define variable de-padrao         as decimal no-undo.
    define variable de-convertido     as decimal no-undo.

    assign
        de-padrao = decimal(h-padrao:screen-value).

    /* Se o valor da moeda padrÆo for zero, limpa o valor das alternativas e 
       desabilita-------------------------------------------------------------*/
    if de-padrao = 0 then do:
        assign
            h-alter1:screen-value = ""
            h-alter2:screen-value = ""
            h-alter1:sensitive    = no
            h-alter2:sensitive    = no.
        return.
    end.

    /* Converte o campo da moeda alternativa (1) -----------------------------*/
    if param-estoq.tem-moeda1 then do:
        run cdp/cd0813.p(0, 1, 
                         de-padrao, input frame {&frame-name} movto-estoq.dt-trans,
                         output de-convertido).
        assign
            h-alter1:screen-value = string(de-convertido, h-alter1:format)
            h-alter1:sensitive    = yes.
    end.

    /* Converte o campo da moeda alternativa (1) -----------------------------*/
    if param-estoq.tem-moeda2 then do:
        run cdp/cd0813.p(0, 2, 
                         de-padrao, input frame {&frame-name} movto-estoq.dt-trans,
                         output de-convertido).
        assign
            h-alter2:screen-value = string(de-convertido, h-alter2:format)
            h-alter2:sensitive    = yes.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-set-labels V-table-Win 
PROCEDURE pi-set-labels :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    do with frame {&FRAME-NAME}:
        find moeda
            where moeda.mo-codigo = 0
            no-lock no-error.

        if avail moeda then do:
            fi-moeda-1 = moeda.descricao.
        end.

        if param-estoq.tem-moeda1 then do:
            find moeda
                where moeda.mo-codigo = param-estoq.moeda1
                no-lock no-error.

            if avail moeda then
                assign fi-moeda-2 = moeda.descricao.

        end.
        else
            assign 
                de-valor-mat-2:visible in frame {&frame-name} = no
                de-valor-mob-2:visible in frame {&frame-name} = no
                de-valor-ggf-2:visible in frame {&frame-name} = no.

        if param-estoq.tem-moeda2 then do:
            find moeda
                where moeda.mo-codigo = param-estoq.moeda2
                no-lock no-error.

            if avail moeda then
                assign fi-moeda-3 = moeda.descricao.     
        end.
        else
            assign
                de-valor-mat-3:visible in frame {&frame-name} = no
                de-valor-mob-3:visible in frame {&frame-name} = no
                de-valor-ggf-3:visible in frame {&frame-name} = no.

        {utp/ut-liter.i Material * C}
        assign fi-mat = return-value.

        {utp/ut-liter.i MÆo-de-Obra * C}
        assign fi-mob = return-value.

        {utp/ut-liter.i GGF * C}
        assign fi-ggf = return-value.

        {utp/ut-liter.i Conta * L}
        assign movto-estoq.ct-codigo:label = return-value.
        
        {utp/ut-liter.i Centro_Custo * L}
        assign movto-estoq.sc-codigo:label = return-value.        

        display fi-mat
                fi-mob
                fi-ggf
                fi-moeda-1
                fi-moeda-2
                fi-moeda-3.

    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-dep-localiz V-table-Win 
PROCEDURE pi-trata-dep-localiz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
        RUN cep/ceapi014.p( input input frame {&frame-name} movto-estoq.it-codigo,
                            INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-estabel,
                            OUTPUT pcod-deposito-pad, 
                            OUTPUT pcod-localiz,      
                            OUTPUT ploc-unica).
        IF pcod-deposito-pad <> "" THEN DO:
            ASSIGN movto-estoq.cod-depos:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = pcod-deposito-pad.
            APPLY "leave" TO movto-estoq.cod-depos.
        END.

        ASSIGN movto-estoq.cod-localiz:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pcod-localiz.
        APPLY "leave" TO movto-estoq.cod-localiz.

        IF ploc-unica THEN
            DISABLE movto-estoq.cod-localiz WITH FRAME {&FRAME-NAME}.
        ELSE 
            ENABLE movto-estoq.cod-localiz WITH FRAME {&FRAME-NAME}.
    &ENDIF
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
 *    run utp/ut-msgs.p (input "show":u, input 7, input return-value).
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
  {src/adm/template/snd-list.i "movto-estoq"}

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

