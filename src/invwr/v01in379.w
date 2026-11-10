&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V01IN379 2.00.00.041 } /*** "010041" 10/02/2026 10:28:20 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in379 MUT}
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
def new global shared var gr-rep-prod  as rowid no-undo.
def new global shared var gr-item      as rowid no-undo.
def new global shared var h-acomp      as handle no-undo.

{cdp/cd0666.i}
{cpp/cpapi009.i}
{cdp/cdcfgman.i}  /* Definiá∆o preprocessador bf_man_sfc_lc */
{cdp/cdcfgmat.i}  /* Definiá∆o preprocessador bf_mat_conta_estab */

def var c-mensagem          as char             no-undo.
def var c-erro              as char             no-undo.
def var c-texto             as char             no-undo.
def var c-retorno           as char             no-undo.
def var i-cont              as integer          no-undo.

def var i-retorno           as integer          no-undo.
def var c-handle            as char             no-undo.
def var h-handle            as handle           no-undo.
def var l-localizacao-unica as logical          no-undo.
def var l-emite-relatorio   as logical          no-undo.
def var l-data-lead-time    as logical init yes no-undo.
DEF VAR c-conta             LIKE ITEM.ct-codigo NO-UNDO.
DEF VAR c-ccusto            LIKE ITEM.sc-codigo NO-UNDO.
def var h-rfid              as handle           no-undo.
function f-gera-numero-reporte returns integer () in h-handle.    
{cdp/cd9203.i}     /* Function f-item-uni-estab        */
define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date                                      
    field hora-exec        as integer
    field item-ini         like rep-prod.it-codigo
    field item-fim         like rep-prod.it-codigo
    field data-ini         like rep-prod.data
    field data-fim         like rep-prod.data
    field rep-ini          like rep-prod.nr-reporte
    field rep-fim          like rep-prod.nr-reporte
    field situacao         as integer.

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def var c-programa-mg97       as char format "x(08)"          no-undo.
def var c-versao-mg97         as char format "x(08)"          no-undo.
def var c-estado              as char format "x(20)" extent 4 no-undo.
def var i-pedido-rpw          as integer                      no-undo.

&IF "{&mguni_version}" >= "2.071" &THEN
def var i-empresa-prin LIKE empresa.ep-codigo no-undo.
&ELSE
def var i-empresa-prin as integer no-undo.
&ENDIF


define variable fi-cod-estabel-ant as character no-undo.
define variable fi-it-codigo-ant as character no-undo.

/* Local Definitions for EAI                                   */

&IF DEFINED (bf_man_204) &THEN 
  DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO. 
&ENDIF

DEF VAR l-usa-unid-negoc    AS LOGICAL  NO-UNDO.
DEF VAR h-cdapi024          AS HANDLE   NO-UNDO.

DEF VAR hProgramZoom        AS HANDLE   NO-UNDO.

DEF VAR h-label-aux         AS HANDLE   NO-UNDO.

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
  def var l-lote-avancado     as log                     no-undo.
  def var l-sugere-lote       as log                     no-undo.
  def var l-amostra           as log                     no-undo.
  def var i-tp-amostra        as int                     no-undo.
  def var h-ceapi030          as handle                  no-undo.
  def var c-lote-amostra      like saldo-estoq.lote      no-undo.
  def var c-cod-depos-amostra like saldo-estoq.cod-depos no-undo.

  {cep/ceapi030.i}
&endif

/** Unificaá∆o de Conceito **/
{cdp/cdunif001.i}
{cdp/cdunif001.i1}
{bcp/bcapi001.i}    /* Definicao da temp-table tt-trans ---                     */
{bcp/bcapi002.i}    /*** Definicao da temp-table para a API de criacao de etiquetas tt-etiqueta ***/

DEFINE TEMP-TABLE tt-etiqueta-aux NO-UNDO
    FIELD it-codigo       LIKE ITEM.it-codigo
    FIELD cod-refer       LIKE ITEM.cod-refer
    FIELD un              LIKE ITEM.un    
    FIELD sequencia       LIKE item-doc-est.sequencia
    FIELD lote            LIKE item-doc-est.lote
    FIELD dt-val-lote     LIKE tt-etiqueta.dt-val-lote
    FIELD qtd-item        LIKE item-doc-est.quantidade
    FIELD qtd-etiq        AS INTEGER
    FIELD etiqueta        AS INTEGER
    FIELD quant-item-etiq AS DECIMAL
    FIELD r-rowid         AS ROWID.

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
&Scoped-define EXTERNAL-TABLES rep-prod
&Scoped-define FIRST-EXTERNAL-TABLE rep-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR rep-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-cc-aplic fi-ccusto RECT-1 RECT-2 RECT-3 
&Scoped-Define DISPLAYED-OBJECTS fi-estado fi-nome fi-nr-reporte fi-text-2 ~
fi-text-1 fi-it-codigo fi-descricao fi-cod-refer fi-conta-aplicacao ~
fi-cc-aplic fi-cod-estabel fi-dep-pad-sai fi-localizacao fi-data ~
fi-qt-reporte fi-qt-refugo fi-ct-refugo fi-ccusto fi-qt-apr-cond fi-un ~
fi-nro-docto fi-serie-docto fi-cod-depos fi-cod-localiz fi-lote-serie ~
fi-dt-vali-lote 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS fi-it-codigo fi-cod-refer fi-cod-estabel ~
fi-dep-pad-sai fi-data fi-qt-reporte fi-qt-refugo fi-qt-apr-cond ~
fi-nro-docto fi-serie-docto fi-cod-depos fi-cod-localiz fi-lote-serie ~
fi-dt-vali-lote 
&Scoped-define ADM-ASSIGN-FIELDS fi-it-codigo fi-cod-refer ~
fi-conta-aplicacao fi-cod-estabel fi-dep-pad-sai fi-data fi-qt-reporte ~
fi-qt-refugo fi-ct-refugo fi-qt-apr-cond fi-nro-docto fi-serie-docto ~
fi-cod-depos fi-cod-localiz fi-lote-serie fi-dt-vali-lote 
&Scoped-define ADM-MODIFY-FIELDS fi-it-codigo fi-cod-refer fi-cod-estabel ~
fi-dep-pad-sai fi-data fi-qt-reporte fi-qt-refugo fi-qt-apr-cond ~
fi-nro-docto fi-serie-docto fi-cod-depos fi-cod-localiz fi-lote-serie ~
fi-dt-vali-lote 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-adiciona-lista V-table-Win 
FUNCTION f-adiciona-lista RETURNS CHARACTER
  ( input c-lista as char, 
    input c-item as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-formato-campo V-table-Win 
FUNCTION f-formato-campo RETURNS CHARACTER
  ( input c-campo as char,
    input i-tipo  as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER FORMAT "X(03)":U 
     LABEL "Unidade de Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-unid-negoc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cc-aplic AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ccusto AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-depos AS CHARACTER FORMAT "x(3)" 
     LABEL "Dep¢sito":R10 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE fi-cod-estabel LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R7 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-localiz AS CHARACTER FORMAT "x(20)" 
     LABEL "Localizaá∆o":R14 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE fi-cod-refer AS CHARACTER FORMAT "x(8)" 
     LABEL "Referància":R12 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88.

DEFINE VARIABLE fi-conta-aplicacao AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta DÇbito Direto":R23 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-ct-refugo AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta Refugo":R20 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-data AS DATE FORMAT "99/99/9999" 
     LABEL "Data Reporte":R15 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE VARIABLE fi-dep-pad-sai AS CHARACTER FORMAT "X(3)" 
     LABEL "Dep¢sito Sa°da":R18 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(60)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88.

DEFINE VARIABLE fi-dt-vali-lote AS DATE FORMAT "99/99/9999" 
     LABEL "Validade Lote":R16 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE VARIABLE fi-estado AS CHARACTER FORMAT "X(32)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88.

DEFINE VARIABLE fi-localizacao AS CHARACTER FORMAT "x(20)" 
     LABEL "Localizaá∆o":R14 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-lote-serie AS CHARACTER FORMAT "x(10)" 
     LABEL "Lote/SÇrie":R12 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-reporte AS INTEGER FORMAT ">>>>>>>>>>>>9" INITIAL 1 
     LABEL "Reporte":R9 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88.

DEFINE VARIABLE fi-nro-docto AS CHARACTER FORMAT "x(16)" 
     LABEL "Documento":R11 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88.

DEFINE VARIABLE fi-qt-apr-cond AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Qtde Aprov Cond":R18 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-qt-refugo AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Qtde Refugo":R14 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-qt-reporte AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Qtde Reporte":R15 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-serie-docto AS CHARACTER FORMAT "x(5)" 
     LABEL "Serie Docto":R14 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .88.

DEFINE VARIABLE fi-text-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 17 BY .63.

DEFINE VARIABLE fi-text-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16.57 BY .63.

DEFINE VARIABLE fi-un AS CHARACTER FORMAT "xx" 
     LABEL "Unid Medida":R17 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 6.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.54.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 6.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-estado AT ROW 1.25 COL 68 COLON-ALIGNED
     fi-nome AT ROW 5.25 COL 35.14 COLON-ALIGNED NO-LABEL
     fi-nr-reporte AT ROW 1.25 COL 27 COLON-ALIGNED
     fi-text-2 AT ROW 7.63 COL 2.72 NO-LABEL
     fi-text-1 AT ROW 9.42 COL 2.72 NO-LABEL
     fi-it-codigo AT ROW 2.25 COL 27 COLON-ALIGNED
     fi-descricao AT ROW 2.25 COL 45 COLON-ALIGNED NO-LABEL
     fi-cod-refer AT ROW 3.25 COL 27 COLON-ALIGNED
     fi-conta-aplicacao AT ROW 4.25 COL 27 COLON-ALIGNED
     fi-cc-aplic AT ROW 4.25 COL 47.43 COLON-ALIGNED NO-LABEL
     fi-cod-estabel AT ROW 5.25 COL 27 COLON-ALIGNED HELP
          ""
          LABEL "Estabelecimento":R7
     c-cod-unid-negoc AT ROW 6.25 COL 27 COLON-ALIGNED
     c-desc-unid-negoc AT ROW 6.25 COL 35 COLON-ALIGNED NO-LABEL
     fi-dep-pad-sai AT ROW 8.17 COL 27 COLON-ALIGNED HELP
          "Dep¢sito padr∆o"
     fi-localizacao AT ROW 8.17 COL 68 COLON-ALIGNED HELP
          "Informe o c¢digo de localizaá∆o do material"
     fi-data AT ROW 10.08 COL 13.14 COLON-ALIGNED
     fi-qt-reporte AT ROW 11.08 COL 13.14 COLON-ALIGNED
     fi-qt-refugo AT ROW 12.08 COL 13.14 COLON-ALIGNED
     fi-ct-refugo AT ROW 13.08 COL 13.14 COLON-ALIGNED
     fi-ccusto AT ROW 13.08 COL 33.43 COLON-ALIGNED NO-LABEL
     fi-qt-apr-cond AT ROW 14.08 COL 13.14 COLON-ALIGNED
     fi-un AT ROW 15.08 COL 13.14 COLON-ALIGNED
     fi-nro-docto AT ROW 10.08 COL 64.14 COLON-ALIGNED
     fi-serie-docto AT ROW 11.08 COL 64.14 COLON-ALIGNED
     fi-cod-depos AT ROW 12.08 COL 64.14 COLON-ALIGNED
     fi-cod-localiz AT ROW 13.08 COL 64.14 COLON-ALIGNED
     fi-lote-serie AT ROW 14.08 COL 64.14 COLON-ALIGNED
     fi-dt-vali-lote AT ROW 15.08 COL 64.14 COLON-ALIGNED
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 7.83 COL 1
     RECT-3 AT ROW 9.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.rep-prod
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
         HEIGHT             = 15.29
         WIDTH              = 88.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{btb/btb008za.i0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-unid-negoc IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-desc-unid-negoc IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-cod-depos IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME f-main
   NO-ENABLE 1 2 3 LIKE = mgcad.estabelec.cod-estabel EXP-LABEL EXP-SIZE */
/* SETTINGS FOR FILL-IN fi-cod-localiz IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-cod-refer IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-conta-aplicacao IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-ct-refugo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-data IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-dep-pad-sai IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dt-vali-lote IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-localizacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-lote-serie IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-nome IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nr-reporte IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nro-docto IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-qt-apr-cond IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-qt-refugo IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-qt-reporte IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-serie-docto IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-text-1 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-text-2 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-un IN FRAME f-main
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

&Scoped-define SELF-NAME c-cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc V-table-Win
ON F5 OF c-cod-unid-negoc IN FRAME f-main /* Unidade de Neg¢cio */
DO:

    &IF DEFINED(bf_man_206b) &THEN

        {method/zoomfields.i &ProgramZoom="inzoom/z01in745.w"
                             &FieldZoom1=cod-unid-negoc
                             &FieldScreen1=c-cod-unid-negoc
                             &Frame1=f-main}

    &ENDIF

    APPLY "LEAVE":U TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc V-table-Win
ON LEAVE OF c-cod-unid-negoc IN FRAME f-main /* Unidade de Neg¢cio */
DO:

    &IF DEFINED(bf_man_206b) &THEN

        FIND unid-negoc WHERE unid-negoc.cod-unid-negoc = c-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
        IF AVAIL unid-negoc THEN 
            ASSIGN c-desc-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = unid-negoc.des-unid-negoc.
        ELSE
            ASSIGN c-desc-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    &ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-unid-negoc IN FRAME f-main /* Unidade de Neg¢cio */
DO:

    APPLY "F5":U TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cc-aplic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-aplic V-table-Win
ON F5 OF fi-cc-aplic IN FRAME f-main
DO:

    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
        run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    
    if v_cod_ccusto <> "" then
                ASSIGN fi-cc-aplic:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.

    if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-aplic V-table-Win
ON LEAVE OF fi-cc-aplic IN FRAME f-main
DO:
   {cdp/cdunif001d.i fi-cc-aplic {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-aplic V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cc-aplic IN FRAME f-main
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto V-table-Win
ON F5 OF fi-ccusto IN FRAME f-main
DO:

    find first param-global no-lock no-error.
    assign i-ep-codigo-usuario = param-global.empresa-prin
           l-implanta          = yes.

    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
        run pi_zoom_ccusto in h_api_ccusto (INPUT i-ep-codigo-usuario,
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


&Scoped-define SELF-NAME fi-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos V-table-Win
ON F5 OF fi-cod-depos IN FRAME f-main /* Dep¢sito */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=fi-cod-depos
                     &campozoom=cod-depos}



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos V-table-Win
ON LEAVE OF fi-cod-depos IN FRAME f-main /* Dep¢sito */
DO:
    RUN pi-verifica-unid-negoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-depos IN FRAME f-main /* Dep¢sito */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel V-table-Win
ON F5 OF fi-cod-estabel IN FRAME f-main /* Estabelecimento */
DO: 
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=fi-cod-estabel
                       &campozoom=cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel V-table-Win
ON LEAVE OF fi-cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
    IF l-estab-security-active AND
       NOT CAN-FIND(FIRST {&ESTAB-SEC-TT}
                    WHERE {&ESTAB-SEC-TT-FIELD} = input frame {&frame-name} fi-cod-estabel NO-LOCK) THEN DO:
        RETURN .
    END.
    
    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=fi-nome
                     &where="estabelec.cod-estabel= input frame {&frame-name}
                             fi-cod-estabel"}
    
    APPLY "leave":U TO fi-it-codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-localiz V-table-Win
ON F5 OF fi-cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in189.w"
                     &campo=fi-cod-localiz
                     &campozoom=cod-localiz
                     &campo2=fi-cod-depos
                     &campozoom2=cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-refer V-table-Win
ON F5 OF fi-cod-refer IN FRAME f-main /* Referància */
DO:
 {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                    &campo=fi-cod-refer
                    &campozoom = cod-refer
                    &parametros= "run pi-seta-inicial in wh-pesquisa
                    (input fi-it-codigo:screen-value)." }.                                                          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-refer IN FRAME f-main /* Referància */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-conta-aplicacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-aplicacao V-table-Win
ON ENTRY OF fi-conta-aplicacao IN FRAME f-main /* Conta DÇbito Direto */
DO:
    ASSIGN fi-conta-aplicacao:FORMAT IN FRAME {&frame-name} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-aplicacao V-table-Win
ON F5 OF fi-conta-aplicacao IN FRAME f-main /* Conta DÇbito Direto */
DO: 
  find first param-global no-lock no-error.
  assign i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = yes.

    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
    
    assign v_cod_finalid = {adinc/i05ad049.i 4 1} 
       v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 2} 
       v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 3} 
       v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 4} 
       v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 5} 
       v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 6}
       v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 7}
       v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 8}
       v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 10}.

    if v_cod_finalid = "" then do: assign v_cod_finalid = "(nenhum)". end.

        run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT i-ep-codigo-usuario,
                                                   INPUT "CEP",
                                                   INPUT "",
                                                   INPUT v_cod_finalid,
                                                   INPUT TODAY,
                                                   OUTPUT v_cod_cta_ctbl,
                                                   OUTPUT v_des_cta_ctbl,
                                                   OUTPUT p-finalidade,
                                                   OUTPUT TABLE tt_log_erro).
    {cdp/cdunif001b.i1}
        
        IF v_cod_cta_ctbl <> "" THEN
                ASSIGN fi-conta-aplicacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.

        if valid-handle(h_api_cta_ctbl) then
                delete object h_api_cta_ctbl.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-aplicacao V-table-Win
ON LEAVE OF fi-conta-aplicacao IN FRAME f-main /* Conta DÇbito Direto */
DO:
    /* Chamado TPCGHW */
    find first param-global no-lock no-error.
    assign i-empresa-prin = param-global.empresa-prin.

    find first estabelec no-lock 
         where estabelec.cod-estabel = input frame {&frame-name} fi-cod-estabel no-error.
    if avail estabelec then do:
        {cdp/cdunif001a.i fi-conta-aplicacao fi-cc-aplic {&FRAME-NAME} TODAY i-empresa-prin estabelec.cod-estabel}
    END.
    ELSE DO:
        {cdp/cdunif001a.i fi-conta-aplicacao fi-cc-aplic {&FRAME-NAME} TODAY """" """"}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-aplicacao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-conta-aplicacao IN FRAME f-main /* Conta DÇbito Direto */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ct-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-refugo V-table-Win
ON ENTRY OF fi-ct-refugo IN FRAME f-main /* Conta Refugo */
DO:
    ASSIGN fi-ct-refugo:FORMAT IN FRAME {&frame-name} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-refugo V-table-Win
ON F5 OF fi-ct-refugo IN FRAME f-main /* Conta Refugo */
DO:
  find first param-global no-lock no-error.
  assign i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = yes.

    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        if v_cod_finalid = "" then do: assign v_cod_finalid = "(nenhum)". end.
        run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT i-ep-codigo-usuario,
                                                   INPUT "CEP",
                                                   INPUT "",
                                                   INPUT v_cod_finalid,
                                                   INPUT TODAY,
                                                   OUTPUT v_cod_cta_ctbl,
                                                   OUTPUT v_des_cta_ctbl,
                                                   OUTPUT p-finalidade,
                                                   OUTPUT TABLE tt_log_erro).
    {cdp/cdunif001b.i1}
        
    IF v_cod_cta_ctbl <> "" THEN
                ASSIGN fi-ct-refugo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.

    if valid-handle(h_api_cta_ctbl) then
                delete object h_api_cta_ctbl.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-refugo V-table-Win
ON LEAVE OF fi-ct-refugo IN FRAME f-main /* Conta Refugo */
DO:
    /*Chamado TPCGHW */
    find first param-global no-lock no-error.
    assign i-empresa-prin = param-global.empresa-prin.

    find first estabelec no-lock 
         where estabelec.cod-estabel = input frame {&frame-name} fi-cod-estabel no-error.
    if avail estabelec then do:
        {cdp/cdunif001a.i fi-ct-refugo fi-ccusto {&FRAME-NAME} TODAY i-empresa-prin estabelec.cod-estabel}
    END.
    ELSE DO:
        {cdp/cdunif001a.i fi-ct-refugo fi-ccusto {&FRAME-NAME} TODAY """" """"}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-refugo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-ct-refugo IN FRAME f-main /* Conta Refugo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-data
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-data V-table-Win
ON LEAVE OF fi-data IN FRAME f-main /* Data Reporte */
DO:
  IF date(fi-data:SCREEN-VALUE IN FRAME {&FRAME-NAME}) > TODAY THEN DO:

       run utp/ut-msgs.p (input "show":U,
                          input 2794,
                          input "").

         RETURN NO-APPLY.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-dep-pad-sai
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-dep-pad-sai V-table-Win
ON F5 OF fi-dep-pad-sai IN FRAME f-main /* Dep¢sito Sa°da */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=fi-dep-pad-sai
                     &campozoom=cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-dep-pad-sai V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-dep-pad-sai IN FRAME f-main /* Dep¢sito Sa°da */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo V-table-Win
ON F5 OF fi-it-codigo IN FRAME f-main /* Item */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                     &campo=fi-it-codigo
                     &campozoom=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo V-table-Win
ON LEAVE OF fi-it-codigo IN FRAME f-main /* Item */
DO: 

 {include/leave.i &tabela=item
                  &atributo-ref=un
                  &variavel-ref=fi-un
                  &where="item.it-codigo= input frame {&frame-name}
                          fi-it-codigo"}
  
  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    if can-find(first funcao where funcao.cd-funcao = "lote-avancado":u and
                                   funcao.ativo) then
        assign l-lote-avancado = yes.
  &endif

 find item where 
      item.it-codigo = input frame {&frame-name} fi-it-codigo no-lock no-error.

 if avail item then do:    
    assign fi-descricao = item.desc-item.

   find first param-global no-lock no-error.
   find first param-cp no-lock no-error.

   IF ITEM.ct-codigo = "" THEN DO:
                &if defined (bf_man_sfc_lc) &then
                        assign c-conta = param-cp.cod-cta-unif
                                   c-ccusto = param-cp.cod-ccusto-unif.
                &else
                        ASSIGN c-conta  = ""
                                   c-ccusto = "".
                &endif
   END.
   ELSE DO:
                ASSIGN c-conta  = ITEM.ct-codigo
               c-ccusto = ITEM.sc-codigo.
   END.
   
   if fi-cod-estabel-ant <> fi-cod-estabel:screen-value in frame {&frame-name}
            OR fi-it-codigo-ant <> fi-it-codigo:screen-value in frame {&frame-name}
                OR trim(fi-cod-estabel:screen-value in frame {&frame-name}) = "" THEN DO:
                
                if item.tipo-contr <> 2 or item.it-codigo = "" THEN DO:
                        ASSIGN fi-conta-aplicacao:SENSITIVE    = YES
                                   fi-conta-aplicacao:screen-value = c-conta
                                   fi-cc-aplic:SCREEN-VALUE        = c-ccusto.
                        apply "leave":U to fi-conta-aplicacao.
                END.
                ELSE DO:
                        assign fi-conta-aplicacao:screen-value = ""
                                   fi-cc-aplic:SCREEN-VALUE        = ""
                                   fi-conta-aplicacao:SENSITIVE    = NO
                                   fi-cc-aplic:SENSITIVE           = NO.
                END.
        end.
        
    if item.tipo-con-est = 4 then do:
       enable fi-cod-refer with frame {&frame-name}.
       apply "ENTRY":U to fi-cod-refer.
    end.  
    else do:
       assign fi-cod-refer:screen-value = "" .
       disable fi-cod-refer with frame {&frame-name}.   
    end.   

    IF param-global.modulo-cq and 
       param-cq.tipo-cq       > 1 and
       STRING (f-item-uni-estab(item.it-codigo,
                                IF fi-cod-estabel:SCREEN-VAL = ''
                                THEN item.cod-estabel
                                ELSE fi-cod-estabel:SCREEN-VAL,
                                "contr-qualid":U)) = "yes":U THEN DO:
    
         &if '{&bf_lote_avancado_liberado}' = 'yes' &then
             if l-lote-avancado and
                item.tipo-con-est > 2 then do:
        
                 assign fi-cod-depos:screen-value = f-item-uni-estab(item.it-codigo,
                                                                     if fi-cod-estabel:screen-value = '' then 
                                                                         item.cod-estabel
                                                                     else fi-cod-estabel:screen-value,
                                                                     "deposito-pad":U).
        
             end.
             else
         &endif
             
       &IF DEFINED(bf_man_206b) &THEN

           IF l-usa-unid-negoc THEN DO:

               FIND unid-negoc-cq 
                   WHERE unid-negoc-cq.cod-estab      = INPUT FRAME {&FRAME-NAME} fi-cod-estabel
                   AND   unid-negoc-cq.cod-unid-negoc = INPUT FRAME {&FRAME-NAME} c-cod-unid-negoc NO-LOCK NO-ERROR.
               IF AVAIL unid-negoc-cq THEN
                   ASSIGN fi-cod-depos:SCREEN-VALUE = unid-negoc-cq.cod-depos-cq.
               ELSE DO:

                   FOR FIRST estabelec FIELDS (deposito-cq) WHERE 
                             estabelec.cod-estabel = IF fi-cod-estabel:SCREEN-VAL = ''
                                                     THEN item.cod-estabel
                                                     ELSE fi-cod-estabel:SCREEN-VAL NO-LOCK:
                       assign fi-cod-depos:screen-value = estabelec.deposito-cq.
                   END.

               END.


           END.
           ELSE DO:

               FOR FIRST estabelec FIELDS (deposito-cq) WHERE 
                         estabelec.cod-estabel = IF fi-cod-estabel:SCREEN-VAL = ''
                                                 THEN item.cod-estabel
                                                 ELSE fi-cod-estabel:SCREEN-VAL NO-LOCK:
                   assign fi-cod-depos:screen-value = estabelec.deposito-cq.
               END.

           END.

       &ELSE

           FOR FIRST estabelec FIELDS (deposito-cq) WHERE 
                     estabelec.cod-estabel = IF fi-cod-estabel:SCREEN-VAL = ''
                                             THEN item.cod-estabel
                                             ELSE fi-cod-estabel:SCREEN-VAL NO-LOCK:
               assign fi-cod-depos:screen-value = estabelec.deposito-cq.
           END.

       &ENDIF

    END.
    ELSE 
        assign fi-cod-depos:screen-value = f-item-uni-estab(item.it-codigo,
                                                    IF fi-cod-estabel:SCREEN-VAL = ''
                                                    THEN item.cod-estabel
                                                    ELSE fi-cod-estabel:SCREEN-VAL,
                                                    "deposito-pad":U).


    ASSIGN fi-cod-depos
           fi-cod-localiz:screen-value = f-item-uni-estab(item.it-codigo,
                                                          IF fi-cod-estabel:SCREEN-VAL = ''
                                                          THEN item.cod-estabel 
                                                          ELSE fi-cod-estabel:SCREEN-VAL,
                                                          "cod-localiz":U). item.cod-localiz.      
    if STRING (f-item-uni-estab(item.it-codigo,
                                fi-cod-estabel,
                                "loc-unica":U)) = "yes":U then
       disable  fi-cod-localiz with frame {&frame-name}.
    else
       enable fi-cod-localiz with frame {&frame-name}.         

    if (item.tipo-con-est > 1 ) then do:

          &if '{&bf_lote_avancado_liberado}' = 'yes' &then
            if l-lote-avancado and
               item.tipo-con-est > 2 then do:

                empty temp-table tt-dados-fda.
                empty temp-table tt-valores.
                empty temp-table tt-erro.
                     
                create tt-dados-fda.
                assign tt-dados-fda.cod-estabel     = fi-cod-estabel:screen-value
                       tt-dados-fda.it-codigo       = fi-it-codigo:screen-value
                       tt-dados-fda.cod-refer       = fi-cod-refer:screen-value
                       tt-dados-fda.cod-modul-dtsul = "MCP"
                       tt-dados-fda.cod-usuario     = c-seg-usuario
                       tt-dados-fda.cod-depos       = fi-cod-depos:screen-value
                       tt-dados-fda.cod-localiz     = fi-cod-localiz:screen-value
                       tt-dados-fda.fm-codigo       = item.fm-codigo.

                if not valid-handle(h-ceapi030) then
                    run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                                  output table tt-valores,
                                                                  output table tt-erro).
        
                run pi-executar in h-ceapi030 (input table tt-dados-fda,
                                               output table tt-valores,
                                               output table tt-erro).
        
                if return-value = "ok":u then do:
        
                    find first tt-valores no-lock no-error.
                    if avail tt-valores then do:

                        run pi-param-esp in h-ceapi030 (input fi-it-codigo:screen-value,
                                                        input "",
                                                        input fi-cod-estabel:screen-value,
                                                        output l-sugere-lote,
                                                        output l-amostra,
                                                        output i-tp-amostra).
                        if l-sugere-lote and
                           tt-valores.lote <> "" then
                            assign fi-lote-serie:screen-value = tt-valores.lote.

                        if tt-valores.dt-val <> ? then
                            assign fi-dt-vali-lote:screen-value = string(tt-valores.dt-val).

                    end.

                    apply 'leave':u to self.
                end.
                
            end.
            else
          &endif
            
      assign fi-lote-serie:screen-value 
                              = (IF INPUT fi-nr-reporte > 999999 THEN 
                                    STRING(input fi-nr-reporte,"9999999999")
                                 ELSE 
                                    string(IF fi-cod-estabel:SCREEN-VAL = ''
                                                          THEN item.cod-estabel 
                                                          ELSE fi-cod-estabel:SCREEN-VAL) + "." +
                                                               string(input fi-nr-reporte,"999999")). /*FO-983074*/
      enable fi-lote-serie
             fi-dt-vali-lote with frame {&frame-name}. 
      ASSIGN fi-lote-serie:READ-ONLY in frame {&frame-name} = NO.                        
          
   end.                             
   else do:
      assign fi-lote-serie:screen-value         = ""
             fi-dt-vali-lote:screen-value = "".
      disable fi-lote-serie
              fi-dt-vali-lote with frame {&frame-name}.  
   end.
   if  input frame {&frame-name} fi-cod-estabel = "" then 
       disp item.cod-estabel @ fi-cod-estabel 
            with frame {&frame-name}.

   ASSIGN fi-cod-depos
          fi-cod-localiz.
 end.           
 ELSE 
    assign fi-descricao = "".

 disp fi-descricao 
      fi-cod-depos with frame {&frame-name}.
          
        
        assign fi-cod-estabel-ant = fi-cod-estabel:screen-value in frame {&frame-name}
                   fi-it-codigo-ant = fi-it-codigo:screen-value in frame {&frame-name}.

 RUN pi-verifica-unid-negoc.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-it-codigo IN FRAME f-main /* Item */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-localizacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-localizacao V-table-Win
ON F5 OF fi-localizacao IN FRAME f-main /* Localizaá∆o */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in189.w"
                     &campo=fi-localizacao
                     &campozoom=cod-localiz}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-localizacao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-localizacao IN FRAME f-main /* Localizaá∆o */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-lote-serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-lote-serie V-table-Win
ON LEAVE OF fi-lote-serie IN FRAME f-main /* Lote/SÇrie */
DO:
   if item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
      find first saldo-estoq use-index lote where 
                 saldo-estoq.lote      = input frame {&frame-name} fi-lote-serie and
                 saldo-estoq.it-codigo = item.it-codigo
                 no-lock no-error.         

      if not avail(saldo-estoq) then do:
         assign fi-dt-vali-lote:sensitive = yes.      

         &if '{&bf_lote_avancado_liberado}' = 'yes' &then
            if l-lote-avancado then do:

                find first tt-valores no-lock no-error.
                if avail tt-valores and
                   tt-valores.dt-val <> ? then
                    assign fi-dt-vali-lote:screen-value = string(tt-valores.dt-val).
                
            end.
          &endif

      end.
      else 
         assign  fi-dt-vali-lote:sensitive    = no
                 fi-dt-vali-lote:screen-value = string(saldo-estoq.dt-vali-lote).
   end.   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-qt-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-qt-refugo V-table-Win
ON LEAVE OF fi-qt-refugo IN FRAME f-main /* Qtde Refugo */
DO:
  if input frame {&frame-name} fi-qt-refugo > 0 then do:
     enable fi-ct-refugo fi-ccusto with frame {&frame-name}.
     ASSIGN fi-ccusto:format in frame {&frame-name} = "x(20)":U. /*Chamado TPCGHW */
     find first param-global no-lock no-error.
     find first param-cp no-lock no-error.
     &IF DEFINED (bf_mat_conta_estab) &THEN
         find first estab-mfg
              where estab-mfg.cod-estab = input frame {&frame-name} fi-cod-estabel no-lock no-error.
         if avail estab-mfg and
            estab-mfg.ct-refugo <> ? then
                assign fi-ct-refugo:screen-value in frame {&frame-name} = estab-mfg.ct-refugo
                       fi-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME}       = estab-mfg.sc-refugo.
         else do:
            if avail param-cp then do:
               assign fi-ct-refugo:screen-value in frame {&frame-name} = param-cp.ct-refugo
                      fi-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME}       = param-cp.sc-refugo.
            end.
         end.
     &ELSE
         if avail param-cp then do:
            assign fi-ct-refugo:screen-value in frame {&frame-name} = param-cp.ct-refugo
                   fi-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME}       = param-cp.sc-refugo.
         end.
     &ENDIF
         
         apply "leave":u to fi-ct-refugo in frame {&frame-name}.
  end.
  else do:
     disable fi-ct-refugo fi-ccusto with frame {&frame-name}.
     assign fi-ct-refugo:format in frame {&frame-name} = "x(20)":U
                    fi-ccusto:format in frame {&frame-name} = "x(20)":U
                    fi-ct-refugo:screen-value in frame {&frame-name} = "":U
            fi-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U.
  end.
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
    
    ASSIGN l-usa-unid-negoc = NO.

    &IF DEFINED(bf_man_206b) &THEN

        IF CAN-FIND (FIRST funcao
                     WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO"
                     AND   funcao.ativo     = YES) THEN DO:

            ASSIGN l-usa-unid-negoc = YES.

            c-cod-unid-negoc:load-mouse-pointer ("image/lupa.cur":U).

        END.

    &ENDIF

    IF NOT l-usa-unid-negoc THEN DO:

        ASSIGN c-cod-unid-negoc:VISIBLE  = FALSE
               c-desc-unid-negoc:VISIBLE = FALSE.

        ASSIGN RECT-1:HEIGHT                         = 5.38
               fi-text-2:ROW                         = 6.54
               rect-2:ROW                            = 6.75
               fi-dep-pad-sai:ROW                    = 7.08
               h-label-aux                           = fi-dep-pad-sai:SIDE-LABEL-HANDLE
               h-label-aux:ROW                       = 7.08
               fi-localizacao:ROW                    = 7.08
               h-label-aux                           = fi-localizacao:SIDE-LABEL-HANDLE
               h-label-aux:ROW                       = 7.08
               fi-text-1:ROW                         = 8.46
               rect-3:ROW                            = 8.67
               fi-data:ROW                           = 9.00
               h-label-aux                           = fi-data:SIDE-LABEL-HANDLE
               h-label-aux:ROW                       = 9.00
               fi-nro-docto:ROW                      = 9.00
               h-label-aux                           = fi-nro-docto:SIDE-LABEL-HANDLE
               h-label-aux:ROW                       = 9.00
               fi-qt-reporte:ROW                     = 10.00
               h-label-aux                           = fi-qt-reporte:SIDE-LABEL-HANDLE
               h-label-aux:ROW                       = 10.00
               fi-serie-docto:ROW                    = 10.00
               h-label-aux                           = fi-serie-docto:SIDE-LABEL-HANDLE
               h-label-aux:ROW                       = 10.00
               fi-qt-refugo:ROW                      = 11.00
               h-label-aux                           = fi-qt-refugo:SIDE-LABEL-HANDLE
               h-label-aux:ROW                       = 11.00
               fi-cod-depos:ROW                      = 11.00
               h-label-aux                           = fi-cod-depos:SIDE-LABEL-HANDLE
               h-label-aux:ROW                       = 11.00
               fi-ct-refugo:ROW                      = 12.00
               fi-ccusto:ROW                         = 12.00
               h-label-aux                           = fi-ct-refugo:SIDE-LABEL-HANDLE
               h-label-aux:ROW                       = 12.00
               fi-cod-localiz:ROW                    = 12.00
               h-label-aux                           = fi-cod-localiz:SIDE-LABEL-HANDLE
               h-label-aux:ROW                       = 12.00
               fi-qt-apr-cond:ROW                    = 13.00
               h-label-aux                           = fi-qt-apr-cond:SIDE-LABEL-HANDLE
               h-label-aux:ROW                       = 13.00
               fi-lote-serie:ROW                     = 13.00
               h-label-aux                           = fi-lote-serie:SIDE-LABEL-HANDLE
               h-label-aux:ROW                       = 13.00
               fi-un:ROW                             = 14.00
               h-label-aux                           = fi-un:SIDE-LABEL-HANDLE
               h-label-aux:ROW                       = 14.00
               fi-dt-vali-lote:ROW                   = 14.00
               h-label-aux                           = fi-dt-vali-lote:SIDE-LABEL-HANDLE
               h-label-aux:ROW                       = 14.00
               FRAME f-main:HEIGHT                   = 14.21.

    END.


 FIND FIRST param-global NO-LOCK NO-ERROR.
 FIND FIRST param-cq NO-LOCK NO-ERROR. 
  fi-it-codigo:load-mouse-pointer       ("image/lupa.cur":U).
  fi-cod-localiz:load-mouse-pointer     ("image/lupa.cur":U).
  fi-localizacao:load-mouse-pointer     ("image/lupa.cur":U).
  fi-cod-depos:load-mouse-pointer       ("image/lupa.cur":U).
  fi-cod-estabel:load-mouse-pointer     ("image/lupa.cur":U).
  fi-cod-refer:load-mouse-pointer       ("image/lupa.cur":U).
  fi-dep-pad-sai:LOAD-MOUSE-POINTER     ("image/lupa.cur":U).
  fi-conta-aplicacao:load-mouse-pointer ("image/lupa.cur":U).
  fi-ct-refugo:load-mouse-pointer       ("image/lupa.cur":U).
  fi-ccusto:LOAD-MOUSE-POINTER          ("image/lupa.cur":U).
  fi-cc-aplic:LOAD-MOUSE-POINTER        ("image/lupa.cur":U).

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

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
  {src/adm/template/row-list.i "rep-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "rep-prod"}

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
  /*run dispatch in this-procedure (input 'display-fields':U).*/

  assign &IF DEFINED(bf_man_206b) &THEN
               fi-nr-reporte:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(NEXT-VALUE(seq-numero-reporte))
         &ELSE fi-nr-reporte:screen-value  in frame {&frame-name} = string(f-gera-numero-reporte())
         &ENDIF
         fi-estado:screen-value      in frame {&frame-name} = c-estado[4]
         fi-data:screen-value        in frame {&frame-name} = string(today)
         fi-dep-pad-sai:screen-value in frame {&frame-name} = if  avail param-cp 
                                                              then param-cp.dep-fabrica
                                                              else "".

  assign fi-nro-docto:screen-value in frame {&frame-name} = fi-nr-reporte:screen-value in frame {&frame-name}.

  for each tt-ref-ordem:  delete tt-ref-ordem. end.
  for each tt-serie:      delete tt-serie.     end.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
def var l-retorno-api   as log no-undo.

    /* Chamada EPC para a assign record */
     {include/i-epc020.i}

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .  */

  /* Code placed here will execute AFTER standard behavior.    */
  
    do  with frame {&frame-name}:
        for each tt-rep-prod:
            delete tt-rep-prod.
        end.

        /* Atualizaá‰es via Browse */

        assign i-retorno = 1. 

        find item where item.it-codigo = input fi-it-codigo no-lock no-error.

        if  avail item then do:
            &IF DEFINED(bf_man_206b) &THEN

                IF l-usa-unid-negoc THEN DO:
                    IF NOT CAN-FIND (FIRST unid-negoc
                                     WHERE unid-negoc.cod-unid-negoc = INPUT FRAME {&FRAME-NAME} c-cod-unid-negoc) THEN DO:

                        /* Inicio -- Projeto Internacional */
                        {utp/ut-liter.i "Unidade_de_Neg¢cio" *}
                        RUN utp/ut-msgs.p (INPUT "show":U,
                                           INPUT 56,
                                           INPUT RETURN-VALUE).
                        apply 'entry':U to c-cod-unid-negoc in frame {&frame-name}. 
                        RETURN "adm-error":U.
                    END.
                END.
            &ENDIF
            
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
            

            if item.compr-fabric = 1 then do:
               run utp/ut-msgs.p (input "show":U,
                                  input 561,
                                  input "").
               if return-value = "no":U then do:
                  apply 'entry':U to fi-it-codigo in frame {&frame-name}. 
                  return 'ADM-ERROR':U.
               end.
            end.

            if  input fi-qt-refugo > 0 then do:
                IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "refugo-sivef"
                                           AND funcao.ativo     = YES NO-LOCK) THEN DO:
                    if  param-global.modulo-cq  and 
                        param-cq.tipo-cq       > 1  then
                        run cpp/cp9060.w (input-output table tt-ref-ordem,
                                          input (input fi-qt-refugo),
                                          input 1,
                                          input 0,
                                          output i-retorno).
                END.
                ELSE DO:
                    if  param-global.modulo-cq and 
                        param-cq.tipo-cq       > 1 and 
                        f-item-uni-estab (input item.it-codigo,
                                          input INPUT FRAME {&FRAME-NAME} fi-cod-estabel,
                                          "contr-qualid") = "yes":U then
                        run cpp/cp9060.w (input-output table tt-ref-ordem,
                                          input (input fi-qt-refugo),
                                          input 1,
                                          input 0,
                                          output i-retorno).
                END.
            end.

            if  i-retorno = 0 then do:
                apply "ENTRY":U to fi-qt-refugo in frame {&frame-name}.
                return "ADM-ERROR":U.    
            end.

            assign i-retorno = 1. 

            if  input fi-qt-apr-cond > 0 then do:      

                if  param-global.modulo-cq  and 
                    param-cq.tipo-cq       > 1  and 
                    f-item-uni-estab (input item.it-codigo,
                                      input INPUT FRAME {&FRAME-NAME} fi-cod-estabel,
                                      "contr-qualid") = "yes":U then
                    run cpp/cp9060.w (input-output table tt-ref-ordem,
                                      input (input fi-qt-apr-cond),
                                      input 2,
                                      input 0,
                                      output i-retorno).
            end.

            if  i-retorno = 0 then do:
                apply "ENTRY":U to fi-qt-apr-cond in frame {&frame-name}.
                return "ADM-ERROR":U.    
            end.

            if  tipo-con-est = 2 then do:     
                run cpp/cp0324i.w (input-output table tt-serie,
                                   input (input fi-qt-refugo),
                                   input (input fi-qt-reporte),
                                   input (input fi-it-codigo),
                                   output i-retorno).
            end.

            if  i-retorno = 0 then do:
                apply "ENTRY":U to fi-it-codigo in frame {&frame-name}.
                return "ADM-ERROR":U.    
            end.  
        end.     

        create tt-rep-prod.
        assign tt-rep-prod.cod-versao-integracao = 001
               tt-rep-prod.nr-reporte            = input fi-nr-reporte
               tt-rep-prod.it-codigo             = input fi-it-codigo
               tt-rep-prod.cod-refer             = input fi-cod-refer
               tt-rep-prod.cod-cta-unif          = input fi-conta-aplicacao
               tt-rep-prod.cod-ccusto-unif       = input fi-cc-aplic
               tt-rep-prod.cod-estabel           = input fi-cod-estabel
               tt-rep-prod.cod-depos-sai         = input fi-dep-pad-sai
               tt-rep-prod.cod-local-sai         = input fi-localizacao
               tt-rep-prod.data                  = input fi-data
               tt-rep-prod.qt-reporte            = input fi-qt-reporte
               tt-rep-prod.qt-refugo             = input fi-qt-refugo
               tt-rep-prod.ct-refugo             = input fi-ct-refugo
               tt-rep-prod.sc-refugo             = INPUT fi-ccusto
               tt-rep-prod.qt-apr-cond           = input fi-qt-apr-cond
               tt-rep-prod.nro-docto             = input fi-nro-docto
               tt-rep-prod.serie-docto           = input fi-serie-docto
               tt-rep-prod.cod-depos             = input fi-cod-depos
               tt-rep-prod.cod-localiz           = input fi-cod-localiz
               tt-rep-prod.lote-serie            = input fi-lote-serie
               tt-rep-prod.dt-vali-lote          = input fi-dt-vali-lote
               tt-rep-prod.loc-sai-unica         = l-localizacao-unica
               tt-rep-prod.prog-seg              = "v01in379":U.

        &IF DEFINED (bf_man_trans_assinc) &THEN
        &ELSE

        for each tt-serie:
            assign tt-rep-prod.char-2 = f-adiciona-lista (tt-rep-prod.char-2,
                                                          tt-serie.nr-serie + ";" +
                                                          string (tt-serie.refugo)).
        end.

        for each tt-ref-ordem:
            assign tt-rep-prod.char-2 = f-adiciona-lista (tt-rep-prod.char-2, 
                                                          string (tt-ref-ordem.codigo-rejei) + ";" +
                                                          string (tt-ref-ordem.qt-refugo) + ";" +
                                                          tt-ref-ordem.observacao).
        end.

        &ENDIF
        
        run pi-recebe-param-dt-lead-time in h-handle (input l-data-lead-time).
        run pi-recebe-tt-rep-prod  in h-handle (input table tt-rep-prod).       
        run pi-recebe-tt-ref-ordem in h-handle (input table tt-ref-ordem).
        run pi-recebe-tt-serie     in h-handle (input table tt-serie).

        run pi-valida-rep-prod in h-handle (input yes,
                                            input yes,
                                            output c-erro,
                                            output c-texto).          
            
        if return-value = 'nok':u then
            assign l-retorno-api = no.
        else
            assign l-retorno-api = yes.
    end.

    /****** Verifica se j† existe ficha de CQ para Item/Lote *****/
    run pi-valida-ficha-cq in h-handle (input yes).

    if  tt-rep-prod.qt-reporte - tt-rep-prod.qt-refugo > 0 then do: 

        if param-cp.log-ficha-ord then do:            

            if  item.tipo-con-est = 3 
            OR  item.tipo-con-est = 4 then do:

                run pi-valida-ficha-cq in h-handle (input NO).                

                find first ficha-cq 
                     where ficha-cq.it-codigo   = tt-rep-prod.it-codigo
                       and ficha-cq.cod-estabel = tt-rep-prod.cod-estabel
                       and ficha-cq.cod-depos   = tt-rep-prod.cod-depos
                       and ficha-cq.cod-localiz = tt-rep-prod.cod-localiz
                       and ficha-cq.lote        = tt-rep-prod.lote-serie
                       and ficha-cq.situacao    < 4 
                       and ficha-cq.op-seq      = 0 NO-LOCK no-error.

                if avail ficha-cq then do: 
                    run utp/ut-msgs.p (input "show":U,
                                       input 19503,
                                       input "").

                    run pi-valida-ficha-cq in h-handle (input (RETURN-VALUE = "YES")).
                end.
                ELSE run pi-valida-ficha-cq in h-handle (input YES).
            end.
        END.
    end.  /* Quantidade de CQ > 0 */
    else
        run pi-valida-ficha-cq in h-handle (input  no).

    if not l-retorno-api then do with frame {&frame-name}:
        case int (entry (num-entries (c-erro), c-erro)):
            when 1     or 
            when 1940  or 
            when 1941  or 
            when 1942  or 
            when 1947  or 
            when 1568  or
            when 18903 then apply 'entry':U to fi-it-codigo.
            when 1490  then apply 'entry':U to fi-conta-aplicacao.
            when 13    then apply 'entry':U to fi-cod-estabel.
            when 3178  then apply 'entry':U to fi-dep-pad-sai.
            when 2388  then apply 'entry':U to fi-ct-refugo.
            when 3166  or 
            when 530   then apply 'entry':U to fi-cod-depos.
            when 956   then apply 'entry':U to fi-lote-serie.
            when 2409  or 
            when 1940  then apply 'entry':U to fi-dt-vali-lote.
            when 2372  then apply 'entry':U to fi-qt-reporte.
            when 2170  or 
            when 2741  or 
            when 4122  then apply 'entry':U to fi-qt-refugo.
            when 3175  then apply 'entry':U to fi-nro-docto.
            when 2739  or 
            when 4123  then apply 'entry':U to fi-qt-apr-cond.
            when 56 then do:
                {utp/ut-table.i mgind item 1}
                if  entry (num-entries (c-texto), c-texto) = return-value then
                    apply 'entry':U to fi-it-codigo.

                {utp/ut-liter.i Conta_DÇbito_Direto mcp c}
                if  entry (num-entries (c-texto), c-texto) = return-value then
                    apply 'entry':U to fi-conta-aplicacao.

                {utp/ut-field.i mgind rep-prod cod-depos-sai 1}
                if  entry (num-entries (c-texto), c-texto) = return-value then
                    apply 'entry':U to fi-dep-pad-sai.

                {utp/ut-liter.i Conta_Refugo mcp c} 
                if  entry (num-entries (c-texto), c-texto) = return-value then
                    apply 'entry':U to fi-ct-refugo.
            end.
        end case.

        do  i-cont = 1 to num-entries (c-erro):
            run utp/ut-msgs.p (input "show":U,
                               input int (entry (i-cont, c-erro)),
                               input entry (i-cont, c-texto)).
        end.

        if  int (entry (num-entries (c-erro), c-erro)) = 1 then
            assign fi-nro-docto:screen-value  = if  fi-nro-docto:screen-value = fi-nr-reporte:screen-value
                                                then string(f-gera-numero-reporte())
                                                else fi-nro-docto:screen-value
                   &IF DEFINED(bf_man_206b) &THEN
                       fi-nr-reporte:screen-value = string(NEXT-VALUE(seq-numero-reporte)).
                   &ELSE
                       fi-nr-reporte:screen-value = string(f-gera-numero-reporte()).
                   &ENDIF                       

        return "adm-error":U.
    end.
    else do:
        do  i-cont = 1 to num-entries (c-erro):
            run utp/ut-msgs.p (input "show":U,
                               input int (entry (i-cont, c-erro)),
                               input entry (i-cont, c-texto)).
        end.

        blk_rep_prod:
        DO transaction on error undo, LEAVE:
            /***************************************************************
            **
            ** I-EPC003.I - EPC para Evento ASSIGN de SmartViewer 
            ** 
            ***************************************************************/

            &IF DEFINED(OriginalName) <> 0 &THEN
                 ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "{&OriginalName}".
            &ELSE
                 ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:file-name.
            &ENDIF
            /* DPC */
            if  c-nom-prog-dpc-mg97 <> "" and
                c-nom-prog-dpc-mg97 <> ? then do:                  
                run value(c-nom-prog-dpc-mg97) (input "ASSIGN":U, 
                                                input "VIEWER":U,
                                                input this-procedure,
                                                input frame {&FRAME-NAME}:handle,
                                                input "{&FIRST-EXTERNAL-TABLE}",
                &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                                input ?).
                &ELSE
                                                input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
                &ENDIF                                 
                if  return-value = "NOK":U then
                    return "adm-error":U.                               
            end.
            /* APPC */
            if  c-nom-prog-appc-mg97 <> "" and
                c-nom-prog-appc-mg97 <> ? then do:                  
                run value(c-nom-prog-appc-mg97) (input "ASSIGN":U, 
                                                input "VIEWER":U,
                                                input this-procedure,
                                                input frame {&FRAME-NAME}:handle,
                                                input "{&FIRST-EXTERNAL-TABLE}",
                &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                                input ?).
                &ELSE
                                                input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
                &ENDIF                                 
                if  return-value = "NOK":U then
                    return "adm-error":U.                               
            end.
            /* UPC */
            if  c-nom-prog-upc-mg97 <> "" and
                c-nom-prog-upc-mg97 <> ? then do:                  
                run value(c-nom-prog-upc-mg97) (input "ASSIGN":U, 
                                                input "VIEWER":U,
                                                input this-procedure,
                                                input frame {&FRAME-NAME}:handle,
                                                input "{&FIRST-EXTERNAL-TABLE}",
                &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                                input ?).
                &ELSE
                                                input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
                &ENDIF                                 
                if  return-value = "NOK":U then
                    return "adm-error":U.                               
            end.                 
            /* I-EPC003.I */         
            
            run utp/ut-acomp.p persistent set h-acomp.
            {utp/ut-liter.i Processando_Reporte *}
            run pi-inicializar in h-acomp (input  Return-value ).
            run pi-desabilita-cancela in h-acomp.

            &IF DEFINED(bf_man_206b) &THEN

                IF l-usa-unid-negoc THEN DO:

                    RUN pi-seta-unid-negoc IN h-handle (INPUT INPUT FRAME {&FRAME-NAME} c-cod-unid-negoc).

                END.

            &ENDIF

            run pi-processa-reportes in h-handle (input-output table tt-rep-prod,
                                                  input        table tt-serie,
                                                  input        table tt-ref-ordem,
                                                  input-output table tt-erro, 
                                                  output       table tt-relatorio,
                                                  input yes).
                                                  
            assign c-retorno = return-value.                                      
            run pi-finalizar in h-acomp.

            find tt-erro where tt-erro.cd-erro = 17357 no-error.
            if  avail tt-erro then
                delete tt-erro no-error.

            find first tt-relatorio no-lock no-error.      
            if avail tt-relatorio and l-emite-relatorio then do:
                run cpp/cp0324h.w (input table tt-relatorio).     
            end.

            if  c-retorno = "ok":U then do:
                find first tt-rep-prod no-error.
                find rep-prod 
                    where rowid (rep-prod) = tt-rep-prod.rw-rep-prod no-lock no-error.
                assign adm-first-table = tt-rep-prod.rw-rep-prod.
            end.
            else
                undo, LEAVE blk_rep_prod.

           /* Integracao EAI - Itens */
            &IF DEFINED (bf_man_204) &THEN 
              IF v_log_eai_habilit THEN DO:
                run pi-retorna-tt-rep-prod  in h-handle (OUTPUT table tt-rep-prod).       
                IF CAN-FIND (FIRST tt-rep-prod) THEN DO:
                    RUN adapters~/xml~/ma2~/axsma006.p (INPUT "add",
                                                     INPUT "cp0234.w",
                                                     INPUT STRING(c-prg-vrs),
                                                     INPUT TABLE tt-rep-prod,
                                                     INPUT TABLE tt-serie,
                                                     INPUT TABLE tt-ref-ordem,
                                                     OUTPUT TABLE RowErrors).  
                    IF CAN-FIND (FIRST RowErrors WHERE 
                                       RowErrors.ErrorSubType = "ERROR":U) THEN DO:

                       {method/showmessage.i1}
                       {method/showmessage.i2 &Modal="YES"}

                       undo, leave blk_rep_prod.
                    END.
                END.
              END.
            &ENDIF

        end.
    end.
            
    find first tt-erro no-lock no-error.
    IF AVAILABLE tt-erro THEN DO:            
        run cdp/cd0666.w (input table tt-erro).
        if  tt-erro.cd-erro = 1 then do:
            ASSIGN fi-nro-docto:screen-value  = (if fi-nro-docto:screen-value = 
                                                    fi-nr-reporte:screen-value then
                                                    string (f-gera-numero-reporte())
                                                    else fi-nro-docto:screen-value)
                      fi-nr-reporte:screen-value = string(f-gera-numero-reporte()).
            apply 'entry':U to fi-nr-reporte.
         end. 
         
         if  c-retorno <> "ok":U THEN 
             UNDO, RETURN "adm-error":u.
    END.      
    IF NOT TRANSACTION THEN DO:

        /* EPC - End-update da Viewer */
        &IF  DEFINED(adm-viewer) <> 0 &THEN
           {include/i-epc010.i}
        &ENDIF

        /* EPC - After End-update da Viewer */
        &IF  DEFINED(adm-viewer) <> 0 &THEN
           {include/i-epc027.i}
        &ENDIF

    END.          
	
    IF CONNECTED("mgcld")THEN DO:
        
        RUN rfid/rfidapi001.p PERSISTENT SET h-rfid.        
          
        RUN pi-valida-impressao IN h-rfid(BUFFER tt-rep-prod,
                                          INPUT input frame {&frame-name} fi-it-codigo,
                                          INPUT ROWID(ord-prod),
                                          INPUT input frame {&frame-name} fi-nro-docto,
                                          INPUT input frame {&frame-name} fi-serie-docto,
                                          INPUT input frame {&frame-name} fi-lote-serie,
                                          INPUT DATE(input frame {&frame-name} fi-dt-vali-lote),
                                          INPUT c-seg-usuario).
        
        IF VALID-HANDLE(h-rfid)THEN 
            DELETE PROCEDURE h-rfid.        
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Ponha na pi-validate todas as validaá‰es */    

  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */ 

  /* Dispatch standard ADM method.                             */

  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .   */  


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

   IF VALID-HANDLE(h_api_ccusto) THEN
       DELETE PROCEDURE h_api_ccusto.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    if valid-handle(h-ceapi030) then
        delete procedure h-ceapi030.
  &endif

  &IF DEFINED(bf_man_206b) &THEN

      IF l-usa-unid-negoc THEN DO:

          IF VALID-HANDLE(h-cdapi024) THEN DO:
              DELETE PROCEDURE h-cdapi024.
              ASSIGN h-cdapi024 = ?.
          END.

      END.

  &ENDIF

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

  /* Dispatch standard ADM method.   
                            */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  disable all with frame {&frame-name}.

  enable fi-lote-serie WITH FRAME {&frame-name}.
  ASSIGN fi-lote-serie:READ-ONLY in frame {&frame-name} = YES.
  
  &IF DEFINED(bf_man_206b) &THEN

      IF l-usa-unid-negoc THEN DO:

          DISABLE c-cod-unid-negoc c-desc-unid-negoc WITH FRAME {&FRAME-NAME}.

      END.

  &ENDIF

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

  if avail rep-prod then do with frame {&frame-name}:
     /* Chamada EPC para Evento DISPLAY de SmartViewer - como o RUN dispatch est† comentado Ç necess†rio a chamada da include*/
     {include/i-epc006.i}
     find item where 
          item.it-codigo         = rep-prod.it-codigo no-lock no-error.
     assign fi-descricao:screen-value       = if avail item then item.desc-item
                                                 else "":U
            fi-un:screen-value              = if avail item then item.un
                                                 else "":U
            fi-nr-reporte:screen-value      = string (rep-prod.nr-reporte)
            fi-it-codigo:screen-value       = rep-prod.it-codigo
            fi-cod-refer:screen-value       = rep-prod.cod-refer
            fi-conta-aplicacao:screen-value = rep-prod.cod-cta-unif
            fi-cc-aplic:screen-value        = rep-prod.cod-ccusto-unif
            fi-cod-estabel:screen-value     = rep-prod.cod-estabel
            fi-dep-pad-sai:screen-value     = rep-prod.cod-depos-sai
            fi-localizacao:screen-value     = rep-prod.cod-local-sai
            fi-data:screen-value            = string (rep-prod.data)
            fi-qt-reporte:screen-value      = string (rep-prod.qt-reporte)
            fi-qt-refugo:screen-value       = string (rep-prod.qt-refugo)
            fi-ct-refugo:screen-value       = string (rep-prod.ct-refugo)
            fi-ccusto:SCREEN-VALUE          = STRING (rep-prod.sc-refugo)
            fi-qt-apr-cond:screen-value     = string (rep-prod.qt-apr-cond)
            fi-nro-docto:screen-value       = rep-prod.nro-docto
            fi-serie-docto:screen-value     = rep-prod.serie-docto
            fi-cod-depos:screen-value       = rep-prod.cod-depos
            fi-cod-localiz:screen-value     = rep-prod.cod-localiz
            fi-lote-serie:screen-value      = rep-prod.lote-serie
            fi-dt-vali-lote:screen-value    = string (rep-prod.dt-vali-lote).

     if  avail item then do:
        if  (item.tipo-con-est = 3 and rep-prod.lote-serie = "") then
            assign fi-lote-serie:screen-value 
                              = (IF INPUT fi-nr-reporte > 999999 THEN 
                                    STRING(input fi-nr-reporte,"9999999999")
                                 ELSE 
                                    string(item.cod-estabel) + "." +
                                    string(input fi-nr-reporte,"999999")). /*FO-983074*/

        /*         else                                        */
/*             assign fi-lote-serie:screen-value = "". */
    end.  

    if  rep-prod.char-1 <> "" then
        assign fi-estado:screen-value = c-estado[3].
    else if  NOT rep-prod.log-1 
         and NOT rep-prod.log-2 then
             assign fi-estado:screen-value = c-estado[1].
    else if  NOT rep-prod.log-1 
         and rep-prod.log-2  then
             assign fi-estado:screen-value = c-estado[2].
    else if  rep-prod.log-1 
         and rep-prod.log-2  then
             assign fi-estado:screen-value = c-estado[4].          
  end.

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .*/

  {utp/ut-liter.i Entrada_Acabado mcp c}

  assign fi-text-1 = return-value
         fi-text-1:screen-value in frame {&frame-name} = return-value.    

  {utp/ut-liter.i Sa°da_Materiais mcp c}

  assign fi-text-2 = return-value
         fi-text-2:screen-value in frame {&frame-name} = return-value.

  /* Code placed here will execute AFTER standard behavior.    */

  &IF DEFINED(bf_man_206b) &THEN

      IF l-usa-unid-negoc THEN DO:

          IF VALID-HANDLE(h-cdapi024) THEN DO:

              FIND ITEM WHERE ITEM.it-codigo = INPUT FRAME {&frame-name} fi-it-codigo NO-LOCK NO-ERROR.
              IF AVAIL ITEM THEN DO:

                  IF ITEM.tipo-contr <> 1 AND
                     ITEM.tipo-contr <> 4 THEN DO:

                      RUN RetornaUnidadeNegocio IN h-cdapi024 (INPUT INPUT FRAME {&FRAME-NAME} fi-cod-estabel,
                                                               INPUT INPUT FRAME {&FRAME-NAME} fi-it-codigo,
                                                               INPUT INPUT FRAME {&FRAME-NAME} fi-cod-depos,
                                                               OUTPUT c-cod-unid-negoc).

                      DISP c-cod-unid-negoc WITH FRAME {&FRAME-NAME}.

                      APPLY "LEAVE":U TO c-cod-unid-negoc IN FRAME {&FRAME-NAME}.

                  END.

              END.

          END.

      END.

  &ENDIF

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
  run get-attribute ('adm-new-record':U).
  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  assign fi-localizacao:sensitive in frame {&frame-name} = l-localizacao-unica.

  &IF DEFINED(bf_man_206b) &THEN
      IF l-usa-unid-negoc THEN 
          ENABLE c-cod-unid-negoc WITH FRAME {&FRAME-NAME}.
  &ENDIF

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

  find first param-global no-lock no-error.
  if param-global.modulo-ce then do:
     find first param-cq    no-lock no-error.     
  end.

  {utp/ut-field.i mgind ord-prod estado 1}
  assign fi-estado:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Atualizado     mcp l}  assign c-estado[1] = trim (return-value).
  {utp/ut-liter.i Reqs_Pendentes mcp l}  assign c-estado[2] = trim (return-value).
  {utp/ut-liter.i Com_Erro       mcp l}  assign c-estado[3] = trim (return-value).
  {utp/ut-liter.i Pendente       mcp l}  assign c-estado[4] = trim (return-value).

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    if can-find(first funcao where funcao.cd-funcao = "lote-avancado":u and
                                   funcao.ativo) then
        assign l-lote-avancado = yes.
  &endif

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  find first param-global no-lock no-error.
  find first param-cp no-lock no-error.

  do with frame {&frame-name}:
     run pi-inicializa-campo (fi-nr-reporte:handle,      "nr-reporte":U). 
     run pi-inicializa-campo (fi-it-codigo:handle,       "it-codigo":U).
     run pi-inicializa-campo (fi-cod-refer:handle,       "cod-refer":U).
     /*run pi-inicializa-campo (fi-conta-aplicacao:handle, "ct-codigo":U).*/
     /*RUN pi-inicializa-campo (fi-cc-aplic:HANDLE,        "sc-codigo").   */
     run pi-inicializa-campo (fi-cod-estabel:handle,     "cod-estabel":U).
     run pi-inicializa-campo (fi-dep-pad-sai:handle,     "cod-depos-sai":U).
     run pi-inicializa-campo (fi-localizacao:handle,     "cod-localiz":U).
     run pi-inicializa-campo (fi-data:handle,            "data":U).
     run pi-inicializa-campo (fi-qt-reporte:handle,      "qt-reporte":U).
     run pi-inicializa-campo (fi-qt-refugo:handle,       "qt-refugo":U).
     /*run pi-inicializa-campo (fi-ct-refugo:handle,    "ct-refugo":U).*/
     /*RUN pi-inicializa-campo (fi-ccusto:HANDLE ,         "sc-refugo":U).*/
     run pi-inicializa-campo (fi-qt-apr-cond:handle,     "qt-apr-cond":U).
     run pi-inicializa-campo (fi-nro-docto:handle,       "nro-docto":U).
     run pi-inicializa-campo (fi-serie-docto:handle,     "serie-docto":U).
     run pi-inicializa-campo (fi-cod-depos:handle,       "cod-depos":U).
     run pi-inicializa-campo (fi-cod-localiz:handle,     "cod-localiz":U).
     run pi-inicializa-campo (fi-lote-serie:handle,      "lote-serie":U).
     run pi-inicializa-campo (fi-dt-vali-lote:handle,    "dt-vali-lote":U).

     {utp/ut-field.i mgind item un 1}
     assign fi-un:label = return-value.

     {utp/ut-liter.i Entrada_Acabado mcp c}

     assign fi-text-1 = return-value
            fi-text-1:screen-value = return-value.    

     {utp/ut-liter.i Sa°da_Materiais mcp c}

     assign fi-text-2 = return-value
            fi-text-2:screen-value = return-value.

     find first param-global no-lock no-error.
  end.

  /*Chamado TPCGHW */
  ASSIGN fi-cc-aplic:SENSITIVE        = NO
         fi-ccusto:SENSITIVE          = NO.

  &IF DEFINED(bf_man_206b) &THEN

      IF l-usa-unid-negoc THEN DO:

          RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.

      END.

  &ENDIF

  if NOT fi-lote-serie:sensitive in frame {&frame-name} THEN DO:
          enable fi-lote-serie WITH FRAME {&frame-name}.
          ASSIGN fi-lote-serie:READ-ONLY in frame {&frame-name} = YES.
  END.
  
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

  if avail rep-prod then
     assign gr-rep-prod = rowid(rep-prod).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campo V-table-Win 
PROCEDURE pi-inicializa-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter wh-handle as handle no-undo.
    def input parameter c-campo as char no-undo.

    run utp/ut-field.p (input "mgind":U, 
                        input "rep-prod":U, 
                        input c-campo, 
                        input "1"). /* Label */
    assign wh-handle:label = return-value.

    run utp/ut-field.p (input "mgind":U, 
                        input "rep-prod":U, 
                        input c-campo, 
                        input "4"). /* Formato */
    assign wh-handle:format = return-value.

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

    run cpp/cp0324k.w (input-output l-localizacao-unica,
                       input-output l-emite-relatorio,
                       input-output l-data-lead-time).

    if  fi-it-codigo:sensitive in frame {&frame-name} then
        assign fi-localizacao:sensitive in frame {&frame-name} = l-localizacao-unica.

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

    run get-attribute in widget-handle (c-handle) (input 'HANDLE':U).

    assign h-handle = widget-handle (return-value).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-unid-negoc V-table-Win 
PROCEDURE pi-verifica-unid-negoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF DEFINED(bf_man_206b) &THEN

        IF l-usa-unid-negoc THEN DO:

            FIND ITEM WHERE ITEM.it-codigo = INPUT FRAME {&frame-name} fi-it-codigo NO-LOCK NO-ERROR.
            IF AVAIL ITEM THEN DO:

                IF ITEM.tipo-contr = 1 OR
                   ITEM.tipo-contr = 4 THEN DO:

                    ASSIGN c-cod-unid-negoc:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = ""
                           c-cod-unid-negoc:SENSITIVE     IN FRAME {&FRAME-NAME} = TRUE.

                END.

                IF ITEM.tipo-contr <> 1 AND   
                   ITEM.tipo-contr <> 4 THEN DO:  

                    RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT INPUT FRAME {&FRAME-NAME} fi-cod-estabel,
                                                             INPUT INPUT FRAME {&FRAME-NAME} fi-it-codigo,
                                                             INPUT INPUT FRAME {&FRAME-NAME} fi-cod-depos,
                                                             OUTPUT c-cod-unid-negoc).

                    ASSIGN c-cod-unid-negoc:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = c-cod-unid-negoc
                           c-cod-unid-negoc:SENSITIVE     IN FRAME {&FRAME-NAME} = FALSE.

                END.

                APPLY "LEAVE":U TO c-cod-unid-negoc IN FRAME {&FRAME-NAME}.

            END.

        END.

    &ENDIF

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
  {src/adm/template/snd-list.i "rep-prod"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-set-fields V-table-Win 
PROCEDURE pi-set-fields :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE INPUT PARAM c-it-codigo AS CHAR NO-UNDO.
    DEFINE INPUT PARAM c-cod-refer AS CHAR NO-UNDO.
    DEFINE INPUT PARAM c-cod-estabel AS CHAR NO-UNDO.

    ASSIGN fi-it-codigo:SCREEN-VALUE IN FRAME f-main = c-it-codigo
           fi-cod-refer:SCREEN-VALUE IN FRAME f-main = c-cod-refer 
           fi-cod-estabel:SCREEN-VALUE IN FRAME f-main = c-cod-estabel. 
           
   APPLY "LEAVE":U TO fi-it-codigo IN FRAME f-main.
   APPLY "LEAVE":U TO fi-cod-refer IN FRAME f-main.
   APPLY "LEAVE":U TO fi-cod-estabel IN FRAME f-main.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-adiciona-lista V-table-Win 
FUNCTION f-adiciona-lista RETURNS CHARACTER
  ( input c-lista as char, 
    input c-item as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

return c-lista + (if num-entries (c-lista, ";") > 0 then ";" else "") + 
       c-item.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-formato-campo V-table-Win 
FUNCTION f-formato-campo RETURNS CHARACTER
  ( input c-campo as char,
    input i-tipo  as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  run utp/ut-field.p (input "mgind", 
                      input "ord-prod", 
                      input c-campo, 
                      input string (i-tipo)).

  RETURN return-value.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
