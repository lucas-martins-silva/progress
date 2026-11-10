&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-cot-ordem NO-UNDO LIKE cot-ordem
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-desp-cot-ordem NO-UNDO LIKE desp-cot-ordem
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0015BD 2.00.00.014}  /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0015BD MIM}
&ENDIF

/*------------------------------------------------------------------------

  File: 

  Description: 

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
def input param pcAcao     as char                    no-undo.
def input param piMapa     like cot-ordem.mapa-ordem  no-undo.
def input param pcAgrup    like cot-ordem.cod-agrup   no-undo.
def input param piemitente like emitente.cod-emitente no-undo.
def input param pcnr-tab   like tb-pr-cex.nr-tab      no-undo.
def input param picod-desp like desp-imp.cod-desp     no-undo.
def input param pimo-codigo like moeda.mo-codigo      no-undo.
def input param prDesp     as rowid                   no-undo.

/* Local Variable Definitions ---                                       */
def var h-bocx305 as handle no-undo.
DEFINE TEMP-TABLE RowErrors no-undo
       field i-sequen as int
       field cd-erro  as int
       field mensagem as char format "x(255)"
       field parametros as char format "x(255)" init ""
       field errortype as char format "x(20)"
       field errorhelp as char format "x(20)"       
       field errorsubtype as character.
       
def var c-acao          as char   no-undo.
def var c-return        as char   no-undo.              
def var hShowMsg        as handle no-undo.
def var hProgramZoom    as handle no-undo.
def var wh-pesquisa     as handle no-undo.

def var d-valor-despesa like desp-cot-ordem.val-desp no-undo.
def new global shared var adm-broker-hdl as handle no-undo.

{include/boerrtab.i}
{utp/ut-glob.i}

{cdp/cdcfgmat.i}

&if "{&bf_mat_versao_ems}" >= "2.05" &then
    def var i-tp-despesa as integer no-undo.
    def var h-boad259   as handle no-undo. /* BO tipo-rec-desp, para obter a descricao do tipo de despesa */
    def var h-boad098   as handle no-undo. /* BO emitente, para obter o tipo de despesa padrÆo */
    def var h-bocx095   as handle no-undo. /* BO desp-imp, para obter o tipo de despesa */
&endif

DEFINE VARIABLE l-habilita-incoterm-rat AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-desp-imposto          AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fPage0

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-desp-cot-ordem

/* Definitions for FRAME fPage0                                         */
&Scoped-define FIELDS-IN-QUERY-fPage0 tt-desp-cot-ordem.cod-cond-pag ~
tt-desp-cot-ordem.taxa-financ tt-desp-cot-ordem.cod-pto-contr ~
tt-desp-cot-ordem.perc-taxa tt-desp-cot-ordem.nr-dias-taxa ~
tt-desp-cot-ordem.contato tt-desp-cot-ordem.cod-comprado ~
tt-desp-cot-ordem.perc-descto tt-desp-cot-ordem.val-desp ~
tt-desp-cot-ordem.data-cotacao-desp tt-desp-cot-ordem.data-atualiz ~
tt-desp-cot-ordem.hora-atualiz tt-desp-cot-ordem.dias-validade 
&Scoped-define ENABLED-FIELDS-IN-QUERY-fPage0 ~
tt-desp-cot-ordem.cod-cond-pag tt-desp-cot-ordem.taxa-financ ~
tt-desp-cot-ordem.cod-pto-contr tt-desp-cot-ordem.perc-taxa ~
tt-desp-cot-ordem.nr-dias-taxa tt-desp-cot-ordem.contato ~
tt-desp-cot-ordem.cod-comprado tt-desp-cot-ordem.perc-descto ~
tt-desp-cot-ordem.val-desp tt-desp-cot-ordem.data-cotacao-desp ~
tt-desp-cot-ordem.dias-validade 
&Scoped-define ENABLED-TABLES-IN-QUERY-fPage0 tt-desp-cot-ordem
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-fPage0 tt-desp-cot-ordem
&Scoped-define QUERY-STRING-fPage0 FOR EACH tt-desp-cot-ordem SHARE-LOCK
&Scoped-define OPEN-QUERY-fPage0 OPEN QUERY fPage0 FOR EACH tt-desp-cot-ordem SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-fPage0 tt-desp-cot-ordem
&Scoped-define FIRST-TABLE-IN-QUERY-fPage0 tt-desp-cot-ordem


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-desp-cot-ordem.cod-cond-pag ~
tt-desp-cot-ordem.taxa-financ tt-desp-cot-ordem.cod-pto-contr ~
tt-desp-cot-ordem.perc-taxa tt-desp-cot-ordem.nr-dias-taxa ~
tt-desp-cot-ordem.contato tt-desp-cot-ordem.cod-comprado ~
tt-desp-cot-ordem.perc-descto tt-desp-cot-ordem.val-desp ~
tt-desp-cot-ordem.data-cotacao-desp tt-desp-cot-ordem.dias-validade 
&Scoped-define ENABLED-TABLES tt-desp-cot-ordem
&Scoped-define FIRST-ENABLED-TABLE tt-desp-cot-ordem
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar c-cod-incoterm-rat ~
i-ctp-despesa c-desc-tipo-despesa log-recalc-val btOK btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-desp-cot-ordem.cod-cond-pag ~
tt-desp-cot-ordem.taxa-financ tt-desp-cot-ordem.cod-pto-contr ~
tt-desp-cot-ordem.perc-taxa tt-desp-cot-ordem.nr-dias-taxa ~
tt-desp-cot-ordem.contato tt-desp-cot-ordem.cod-comprado ~
tt-desp-cot-ordem.perc-descto tt-desp-cot-ordem.val-desp ~
tt-desp-cot-ordem.data-cotacao-desp tt-desp-cot-ordem.data-atualiz ~
tt-desp-cot-ordem.hora-atualiz tt-desp-cot-ordem.dias-validade 
&Scoped-define DISPLAYED-TABLES tt-desp-cot-ordem
&Scoped-define FIRST-DISPLAYED-TABLE tt-desp-cot-ordem
&Scoped-Define DISPLAYED-OBJECTS c-cod-incoterm-rat i-ctp-despesa ~
c-desc-tipo-despesa log-recalc-val 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-incoterm-rat AS CHARACTER FORMAT "X(3)":U 
     LABEL "Incoterm de Rateio" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tipo-despesa LIKE tipo-rec-desp.descricao
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE i-ctp-despesa AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Tipo Despesa" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 9.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE log-recalc-val AS LOGICAL INITIAL no 
     LABEL "Recalcula Valor" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.14 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY fPage0 FOR 
      tt-desp-cot-ordem SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     tt-desp-cot-ordem.cod-cond-pag AT ROW 1.17 COL 27.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-desp-cot-ordem.taxa-financ AT ROW 2.17 COL 29.72
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .88
     tt-desp-cot-ordem.cod-pto-contr AT ROW 2.17 COL 60.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .88
     tt-desp-cot-ordem.perc-taxa AT ROW 3.17 COL 27.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-desp-cot-ordem.nr-dias-taxa AT ROW 3.17 COL 60.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-desp-cot-ordem.contato AT ROW 4.17 COL 27.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     tt-desp-cot-ordem.cod-comprado AT ROW 4.17 COL 60.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     tt-desp-cot-ordem.perc-descto AT ROW 5.17 COL 27.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-desp-cot-ordem.val-desp AT ROW 5.17 COL 60.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     tt-desp-cot-ordem.data-cotacao-desp AT ROW 6.17 COL 27.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-desp-cot-ordem.data-atualiz AT ROW 6.17 COL 60.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-desp-cot-ordem.hora-atualiz AT ROW 7.17 COL 27.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.72 BY .88
     tt-desp-cot-ordem.dias-validade AT ROW 7.17 COL 60.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-cod-incoterm-rat AT ROW 8.17 COL 27.86 COLON-ALIGNED
     i-ctp-despesa AT ROW 8.17 COL 60.86 COLON-ALIGNED HELP
          "Indicar que tipo de despesa para o Fluxo de Caixa"
     c-desc-tipo-despesa AT ROW 8.17 COL 66 COLON-ALIGNED HELP
          "" NO-LABEL
     log-recalc-val AT ROW 9.29 COL 29.86
     btOK AT ROW 11.04 COL 2
     btCancel AT ROW 11.04 COL 13
     btHelp AT ROW 11.04 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 10.83 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 11.46
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Temp-Tables and Buffers:
      TABLE: tt-cot-ordem T "?" NO-UNDO mgcex cot-ordem
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-desp-cot-ordem T "?" NO-UNDO mgcex desp-cot-ordem
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "IM0015BD"
         HEIGHT             = 11.46
         WIDTH              = 90.14
         MAX-HEIGHT         = 22.13
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.13
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 1
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fPage0
                                                                        */
/* SETTINGS FOR FILL-IN c-desc-tipo-despesa IN FRAME fPage0
   LIKE = mgadm.tipo-rec-desp.descricao EXP-SIZE                        */
/* SETTINGS FOR FILL-IN tt-desp-cot-ordem.data-atualiz IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-desp-cot-ordem.hora-atualiz IN FRAME fPage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _TblList          = "Temp-Tables.tt-desp-cot-ordem"
     _Query            is OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* IM0015BD */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* IM0015BD */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel C-Win
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp C-Win
ON CHOOSE OF btHelp IN FRAME fPage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME fPage0 /* OK */
DO:
    ASSIGN FRAME fPage0 
           tt-desp-cot-ordem.taxa-financ
           tt-desp-cot-ordem.perc-taxa
           tt-desp-cot-ordem.contato
           tt-desp-cot-ordem.perc-descto
           tt-desp-cot-ordem.data-cotacao-desp
           tt-desp-cot-ordem.hora-atualiz
           tt-desp-cot-ordem.cod-cond-pag
           tt-desp-cot-ordem.cod-pto-contr
           tt-desp-cot-ordem.nr-dias-taxa
           tt-desp-cot-ordem.cod-comprado
           tt-desp-cot-ordem.val-desp
           tt-desp-cot-ordem.data-atualiz
           tt-desp-cot-ordem.dias-validade.
           
    assign tt-desp-cot-ordem.cod-emitente-desp = piEmitente
           tt-desp-cot-ordem.nr-tab            = pcnr-tab
           tt-desp-cot-ordem.mo-codigo         = pimo-codigo
           INPUT FRAME fPage0 c-cod-incoterm-rat.

    IF  c-cod-incoterm-rat = ? THEN
        ASSIGN c-cod-incoterm-rat = "?".

    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
          ASSIGN tt-desp-cot-ordem.cod-incoterm-rat = c-cod-incoterm-rat.
    &else
          ASSIGN OVERLAY(tt-desp-cot-ordem.char-1,1,3) = c-cod-incoterm-rat.
    &endif

    &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
       assign tt-desp-cot-ordem.tp-despesa = int(i-ctp-despesa:screen-value in frame fPage0).
    &ENDIF
    
    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
    
       IF log-recalc-val:SENSITIVE IN FRAME fPage0 = YES THEN
          ASSIGN tt-desp-cot-ordem.log-recalc-val = INPUT FRAME fPage0 log-recalc-val.

    &ENDIF
    
    if pcAcao = "UPDATE":U then do:        
        RUN validateUpdate in h-bocx305 (input table tt-desp-cot-ordem,
                                         input prDesp,
                                         output table RowErrors).
    end.
    else do:
        RUN validateCreate in h-bocx305 (input table tt-desp-cot-ordem, 
                                         output table RowErrors, 
                                         output tt-desp-cot-ordem.r-rowid).
    end.
    
    IF CAN-FIND(FIRST RowErrors) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            RUN utp/showmessage.w PERSISTENT SET hShowMsg.

        RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).        
        LEAVE.
    END.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-incoterm-rat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-incoterm-rat C-Win
ON F5 OF c-cod-incoterm-rat IN FRAME fPage0 /* Incoterm de Rateio */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/Z10CX025.w"
                         &FieldZoom1="cod-incoterm"
                         &FieldScreen1="c-cod-incoterm-rat"
                         &Frame1="fPage0"
                         &EnableImplant="YES"}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-incoterm-rat C-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-incoterm-rat IN FRAME fPage0 /* Incoterm de Rateio */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-desp-cot-ordem.cod-comprado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.cod-comprado C-Win
ON F5 OF tt-desp-cot-ordem.cod-comprado IN FRAME fPage0 /* Comprador */
DO:
    {include/zoomvar.i 
     &prog-zoom="inzoom/z01in055.w"
     &campo="tt-desp-cot-ordem.cod-comprado"
     &campozoom="cod-comprado"
     &frame="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.cod-comprado C-Win
ON MOUSE-SELECT-DBLCLICK OF tt-desp-cot-ordem.cod-comprado IN FRAME fPage0 /* Comprador */
DO:
    apply "F5":U to self in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-desp-cot-ordem.cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.cod-cond-pag C-Win
ON F5 OF tt-desp-cot-ordem.cod-cond-pag IN FRAME fPage0 /* Condi‡Æo Pagamento */
DO:
    {include/zoomvar.i 
     &prog-zoom="adzoom/z01ad039.w"
     &campo="tt-desp-cot-ordem.cod-cond-pag"
     &campozoom="cod-cond-pag"
     &frame="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.cod-cond-pag C-Win
ON MOUSE-SELECT-DBLCLICK OF tt-desp-cot-ordem.cod-cond-pag IN FRAME fPage0 /* Condi‡Æo Pagamento */
DO:
    apply "F5":U to self in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-desp-cot-ordem.cod-pto-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.cod-pto-contr C-Win
ON F5 OF tt-desp-cot-ordem.cod-pto-contr IN FRAME fPage0 /* Ponto Controle */
DO:
    {include/zoomvar.i 
     &prog-zoom="cxzoom/z01cx120.w"
     &campo="tt-desp-cot-ordem.cod-pto-contr"
     &campozoom="cod-pto-contr"
     &frame="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.cod-pto-contr C-Win
ON MOUSE-SELECT-DBLCLICK OF tt-desp-cot-ordem.cod-pto-contr IN FRAME fPage0 /* Ponto Controle */
DO:
    apply "F5":U to self in frame fpage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-ctp-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ctp-despesa C-Win
ON F5 OF i-ctp-despesa IN FRAME fPage0 /* Tipo Despesa */
DO:
      {include/zoomvar.i &prog-zoom=adzoom/z01ad259.w
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ &campo="i-ctp-despesa"
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ &campozoom="tp-codigo" 
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ &FRAME="fPage0"
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ &campo2="c-desc-tipo-despesa"
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ &campozoom2="descricao"
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ctp-despesa C-Win
ON LEAVE OF i-ctp-despesa IN FRAME fPage0 /* Tipo Despesa */
DO:
  &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
      if not valid-handle(h-boad259) then
         run adbo/boad259.p persistent set h-boad259.

      /*Busca descri‡Æo do tipo da Despesa */
      {method/referencefields.i 
        &HandleDBOLeave="h-boad259"
        &FindMethod="findCodigo"
        &KeyValue1="i-ctp-despesa:screen-value in frame fPage0"
        &FieldName1="descricao"
        &FieldScreen1="c-desc-tipo-despesa"
        &Frame1="fPage0"}
   
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ctp-despesa C-Win
ON MOUSE-SELECT-DBLCLICK OF i-ctp-despesa IN FRAME fPage0 /* Tipo Despesa */
DO:
    apply "F5":U to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.
       
tt-desp-cot-ordem.cod-cond-pag:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
IN FRAME fPage0.
tt-desp-cot-ordem.contato:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
IN FRAME fPage0.
tt-desp-cot-ordem.cod-comprado:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
IN FRAME fPage0.
tt-desp-cot-ordem.cod-pto-contr:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
IN FRAME fPage0.    
i-ctp-despesa:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
IN FRAME fPage0.     

c-cod-incoterm-rat:LOAD-MOUSE-POINTER("IMAGE/lupa.cur")  IN FRAME fPage0.

IF NOT VALID-HANDLE(h-bocx305) THEN
    RUN cxbo/bocx305.p persistent set h-bocx305.

def var c-nom-prog-upc-mg97 as char no-undo.
def var c-nom-prog-appc-mg97 as char no-undo.
def var c-nom-prog-dpc-mg97 as char no-undo.

{utp/ut9000.i "IM0015BD" "2.00.00.014"}


RUN enableIncotermRat IN h-bocx305 (INPUT  piMapa,
                                    INPUT  pcAgrup,
                                    INPUT  picod-desp,
                                    OUTPUT l-habilita-incoterm-rat).

if pcAcao = "UPDATE":U then do: 
    run findDespesa in h-bocx305(input pcAgrup,
                                 input piMapa,
                                 input piemitente,
                                 input picod-desp,
                                 output c-return).
    if c-return = "" then do:          
        run getCurrent in h-bocx305(output table tt-desp-cot-ordem).
        find first tt-desp-cot-ordem no-error.
        if avail tt-desp-cot-ordem then do:                 
            if tt-desp-cot-ordem.cod-emitente-desp = 0 then do:            
               assign tt-desp-cot-ordem.cod-emitente-desp = piemitente
                      tt-desp-cot-ordem.nr-tab            = pcnr-tab
                      tt-desp-cot-ordem.mo-codigo         = pimo-codigo.
                run geraValorformula in h-bocx305 (input-output table tt-desp-cot-ordem,
                                                   output table tt-bo-erro).
                find first tt-desp-cot-ordem no-error.                                                   
                                                   
                assign tt-desp-cot-ordem.val-desp = tt-desp-cot-ordem.val-desp.
                find tt-bo-erro no-error.
                if avail tt-bo-erro then do:
                    run utp/ut-msgs.p (input "show":U,
                                       input tt-bo-erro.cd-erro,
                                       input tt-bo-erro.parametros).
                end.
            end.
            disp tt-desp-cot-ordem.taxa-financ
                 tt-desp-cot-ordem.perc-taxa
                 tt-desp-cot-ordem.contato
                 tt-desp-cot-ordem.perc-descto
                 tt-desp-cot-ordem.data-cotacao-desp
                 tt-desp-cot-ordem.hora-atualiz
                 tt-desp-cot-ordem.cod-cond-pag
                 tt-desp-cot-ordem.cod-pto-contr
                 tt-desp-cot-ordem.nr-dias-taxa
                 tt-desp-cot-ordem.cod-comprado
                 tt-desp-cot-ordem.val-desp
                 tt-desp-cot-ordem.data-atualiz
                 tt-desp-cot-ordem.dias-validade
                 with frame fPage0.

             &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
                   assign i-ctp-despesa = tt-desp-cot-ordem.tp-despesa.
                   disp i-ctp-despesa with frame fPage0.
                   apply 'leave':U to i-ctp-despesa in frame fPage0.
             &ENDIF
             
             &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
                ASSIGN log-recalc-val = tt-desp-cot-ordem.log-recalc-val.
                DISP  log-recalc-val WITH FRAME fPage0.
             &ENDIF
             
            &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
                  ASSIGN c-cod-incoterm-rat = tt-desp-cot-ordem.cod-incoterm-rat.
            &else
                  ASSIGN c-cod-incoterm-rat = SUBSTRING(tt-desp-cot-ordem.char-1,1,3).
            &endif
            
            DISP c-cod-incoterm-rat WITH FRAME fPage0.

        end.
    end.                                 
end.
else do:
    create tt-desp-cot-ordem.
    assign tt-desp-cot-ordem.cod-agrup         = pcAgrup
           tt-desp-cot-ordem.mapa-ordem        = piMapa
           tt-desp-cot-ordem.cod-emitente-desp = piemitente
           tt-desp-cot-ordem.nr-tab            = pcnr-tab
           tt-desp-cot-ordem.cod-desp          = picod-desp
           tt-desp-cot-ordem.mo-codigo         = pimo-codigo.
    
    find first emitente where emitente.cod-emitente = piemitente no-lock no-error.
    if avail emitente then
       assign tt-desp-cot-ordem.cod-cond-pag = emitente.cod-cond-pag.    

    run geraValorformula in h-bocx305 (input-output table tt-desp-cot-ordem, 
                                       output table tt-bo-erro).


    find first tt-desp-cot-ordem no-error.                                       
                                       
    find first tt-bo-erro no-error.
    if avail tt-bo-erro then do:
        run utp/ut-msgs.p (input "show":U,
                           input tt-bo-erro.cd-erro,
                           input tt-bo-erro.parametros).                           
    end.
    else
        assign tt-desp-cot-ordem.val-desp = tt-desp-cot-ordem.val-desp.
        
    /* Tipo de despesa */
    &if "{&bf_mat_versao_ems}" >= "2.05" &then
        if not valid-handle(h-bocx095) then
            run cxbo/bocx095.p persistent set h-bocx095.
        if not valid-handle(h-boad098) then
            run adbo/boad098.p persistent set h-boad098.
        if not valid-handle(h-boad259) then
            run adbo/boad259.p persistent set h-boad259.

        if valid-handle(h-bocx095) then do:

            run findCodigo in h-bocx095(input picod-desp, output c-return).
            if c-return = "" then do:
                run getIntField in h-bocx095(input "tp-despesa", output i-tp-despesa).
                if i-tp-despesa <> 0 then
                    assign i-ctp-despesa = i-tp-despesa.
                else
                    if piemitente <> 0 then
                        if valid-handle(h-boad098) then do:
                            run findCodigo in h-boad098(input piemitente, output c-return).
                            if c-return = "" then do:
                                run getIntField in h-boad098(input "tp-desp-padrao", output i-tp-despesa).
                                assign i-ctp-despesa = i-tp-despesa.
                            end.
                        end.
                disp i-ctp-despesa with frame fPage0.
            end. /* if c-return = "" */
        end. /* if valid-handle(h-bocx095) */
     &endif
    /* Fim do tipo de despesa */

    disp tt-desp-cot-ordem.cod-cond-pag 
         tt-desp-cot-ordem.taxa-financ
         tt-desp-cot-ordem.cod-pto-contr 
         tt-desp-cot-ordem.perc-taxa
         tt-desp-cot-ordem.nr-dias-taxa 
         tt-desp-cot-ordem.contato
         tt-desp-cot-ordem.cod-comprado 
         tt-desp-cot-ordem.perc-descto
         tt-desp-cot-ordem.val-desp 
         tt-desp-cot-ordem.data-cotacao-desp
         tt-desp-cot-ordem.dias-validade        
         tt-desp-cot-ordem.hora-atualiz
         tt-desp-cot-ordem.data-atualiz
         with frame fPage0.                 

    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
          ASSIGN c-cod-incoterm-rat = tt-desp-cot-ordem.cod-incoterm-rat.
    &else
          ASSIGN c-cod-incoterm-rat = SUBSTRING(tt-desp-cot-ordem.char-1,1,3).
    &endif
    
    DISP c-cod-incoterm-rat WITH FRAME fPage0.

        
end.               



/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
    RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.

    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
       IF pcAcao = "UPDATE":U THEN
          ASSIGN log-recalc-val:SENSITIVE IN FRAME fPage0 = YES.
       ELSE
          ASSIGN log-recalc-val:SENSITIVE IN FRAME fPage0 = NO.
    &ELSE
      ASSIGN log-recalc-val:VISIBLE IN FRAME fPage0 = NO.
    &ENDIF
    
    ASSIGN c-cod-incoterm-rat:SENSITIVE IN FRAME fPage0 = l-habilita-incoterm-rat.

    disable c-desc-tipo-despesa with frame fPage0.
    apply 'leave':U to i-ctp-despesa in frame fPage0.
    &IF "{&bf_mat_versao_ems}" < "2.05" &THEN
       assign i-ctp-despesa:hidden = true
              c-desc-tipo-despesa:hidden = true.
    &ENDIF
    
    ASSIGN l-desp-imposto = NO.

    RUN despesaImposto IN h-bocx305 (INPUT picod-desp,
                                     INPUT pcAgrup,
                                     INPUT piMapa,
                                     OUTPUT l-desp-imposto).

    IF l-desp-imposto THEN DO:
        ASSIGN tt-desp-cot-ordem.val-desp:SENSITIVE    IN FRAME fPage0 = NO.
        RUN utp/ut-msgs.p (INPUT "Show":U, INPUT 32051,"").
    END.
    ELSE
        ASSIGN tt-desp-cot-ordem.val-desp:SENSITIVE IN FRAME fPage0 = YES.

    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyinterface C-Win 
PROCEDURE afterDestroyinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if valid-handle(h-bocx305) then
        DELETE PROCEDURE h-bocx305.
    assign h-bocx305 = ?.

    if valid-handle(hShowMsg) then
        delete procedure hShowMsg.
    assign hShowMsg = ?.

    &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
        if valid-handle(h-bocx095) then
            DELETE PROCEDURE h-bocx095.
        assign h-bocx095 = ?.

        if valid-handle(h-boad259) then
            DELETE PROCEDURE h-boad259.
        assign h-boad259 = ?.

        if valid-handle(h-boad098) then
            DELETE PROCEDURE h-boad098.
        assign h-boad098 = ?.
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields C-Win 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-fPage0}
  GET FIRST fPage0.
  DISPLAY c-cod-incoterm-rat i-ctp-despesa c-desc-tipo-despesa log-recalc-val 
      WITH FRAME fPage0 IN WINDOW C-Win.
  IF AVAILABLE tt-desp-cot-ordem THEN 
    DISPLAY tt-desp-cot-ordem.cod-cond-pag tt-desp-cot-ordem.taxa-financ 
          tt-desp-cot-ordem.cod-pto-contr tt-desp-cot-ordem.perc-taxa 
          tt-desp-cot-ordem.nr-dias-taxa tt-desp-cot-ordem.contato 
          tt-desp-cot-ordem.cod-comprado tt-desp-cot-ordem.perc-descto 
          tt-desp-cot-ordem.val-desp tt-desp-cot-ordem.data-cotacao-desp 
          tt-desp-cot-ordem.data-atualiz tt-desp-cot-ordem.hora-atualiz 
          tt-desp-cot-ordem.dias-validade 
      WITH FRAME fPage0 IN WINDOW C-Win.
  ENABLE rtKeys rtToolBar tt-desp-cot-ordem.cod-cond-pag 
         tt-desp-cot-ordem.taxa-financ tt-desp-cot-ordem.cod-pto-contr 
         tt-desp-cot-ordem.perc-taxa tt-desp-cot-ordem.nr-dias-taxa 
         tt-desp-cot-ordem.contato tt-desp-cot-ordem.cod-comprado 
         tt-desp-cot-ordem.perc-descto tt-desp-cot-ordem.val-desp 
         tt-desp-cot-ordem.data-cotacao-desp tt-desp-cot-ordem.dias-validade 
         c-cod-incoterm-rat i-ctp-despesa c-desc-tipo-despesa log-recalc-val 
         btOK btCancel btHelp 
      WITH FRAME fPage0 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

