&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/***************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
****************************************************************************/
{include/i-prgvrs.i V31IN176 2.00.00.031 } /*** "010031" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v31in176 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

{cdp/cdcfgmat.i}

/* global variable definitions */

/* Parameters Definitions ---                                           */
def temp-table tt-rat-ordem like rat-ordem
     index codigo   
           int-1.

/* Local Variable Definitions ---                                       */
    def var l-pede-qtd          as logical  no-undo.
    def var l-pede-peso         as logical  no-undo.
    def var l-pede-valor        as logical  no-undo.

/*&Scop adm-attribute-dlg support/viewerd.w*/

    def var c-serie-comp        as char     no-undo.
    def var v-row-parent        as rowid    no-undo.
    def var c-nat-operacao      as char     no-undo.
    def var i-seq-comp         as integer no-undo.
    def var l-pede-compra       as logical  no-undo.
    def var l-consiste-item     as logical  no-undo.
    def var l-pede-ord-prod     as logical  no-undo.
    def var l-pede-conta        as logical  no-undo.
    def var l-pede-pedordem     as logical  no-undo.
    def var l-pede-baixa-ce     as logical  no-undo.
    def var l-pede-reserva      as logical  no-undo.
    def var de-desconto         as decimal  no-undo.
    def var i-sequencia         as integer  no-undo.
    def var de-indice           as decimal  no-undo.
    def var c-it-codigo         as char     no-undo.
    def var c-item-do-forn      as char     no-undo.
    def var c-cod-refer         as char     no-undo.  
    def var l-evento            as logical  no-undo.
    def var l-erro-co           as logical  no-undo.
    def var de-val-aux          as decimal  no-undo.
    def var l-contrato          as logical  no-undo.
    def var i-num-ord-inv       as integer  no-undo.
    def var h_v15in176          as handle   no-undo.
    def var h_v17in176          as handle   no-undo.  /* No Internacional -> equivale a V22IN176 */
    def var h_v20in176          as handle   no-undo.  /* No Internacional -> equivale a V22IN176 */
    def var h_b06in368          as handle   no-undo.
    def var h_b03in367          as handle   no-undo.
    def var h_b07in368          as handle   no-undo.
    def var h_v21in176          as handle   no-undo.
    def var l-novo-reg          as logical  no-undo.
    def var l-rateio            as logical  no-undo.
    def var de-quantidade       as decimal  no-undo.
    def var de-qtd-forn         as decimal  no-undo.
    def var l-habilita-fifo     as logical  no-undo.
    def var l-conta-matriz      as logical  no-undo.
    def var l-zoom              as logical  no-undo.
    def var c-item              like item-doc-est.it-codigo no-undo.
    def var i-numero-ordem     as integer no-undo.
    def var c-nat-comp         as char    no-undo.
    def var c-un               as char    no-undo.
    def var de-preco-unit      as decimal no-undo.
    def var de-val-contrato    as decimal no-undo.
    def var de-val-formula     as decimal no-undo.
    def var de-vl-merc-liq     as decimal no-undo.
    def var de-vl-preuni       as decimal no-undo.
    def var i-round            as integer no-undo.
    def var de-preco-total     as decimal no-undo.
    def var de-vl-merc-liq-aux as decimal no-undo.
    def var de-var-min         as decimal no-undo.
    def var de-var-max         as decimal no-undo.
    def var de-despesa         as decimal no-undo.    
    def var de-frete           as decimal no-undo.
    def var c-un-aux           as char    no-undo.
    def var de-qt-aux          like  item-doc-est.quantidade no-undo.
    def var l-erro-qtd         as logical no-undo.
    def var de-taxa            as decimal no-undo.
    def var de-vl-aux          as decimal no-undo.
    def var i-parcela          as integer no-undo.
    def var de-qtd-aux         as decimal no-undo.
    def var i-moeda            like docum-est.mo-codigo no-undo.
    def var l-inclui           as logical no-undo init no.    
    DEFINE VARIABLE l-erro AS LOGICAL    NO-UNDO.


    def new global shared var gr-docum-est    as rowid no-undo.
    def new global shared var gr-pedido-compr as rowid no-undo.
    def new global shared var gr-ordem-compra as rowid no-undo.

    def new global shared var i-programa-re as integer no-undo.
    def new global shared var l-material-agregado as logical no-undo.

    /**
    ***  Recebimento   1 - Normal
    ***                2 - F°sico
    ***                3 - Internacional
    **/

    def buffer b-item-doc-est for item-doc-est.

   /* Def variaveis da variacao por familia ou item-uni estab */
    {rep/re1001.i09} 

    {cdp/cd0666.i}
    {bcp/bcapi011.i} /* temp-table tt-etq-item */
    {rep/re1001.i07}
    {cdp/cd4300.i3} 
    {cdp/cd0101.i50}
    {cep/ce1234.i}   /* Validaá∆o Decimais */

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
&Scoped-define EXTERNAL-TABLES item-doc-est
&Scoped-define FIRST-EXTERNAL-TABLE item-doc-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-doc-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-doc-est.num-pedido ~
item-doc-est.numero-ordem item-doc-est.parcela item-doc-est.serie-comp ~
item-doc-est.nro-comp item-doc-est.qt-do-forn item-doc-est.quantidade ~
item-doc-est.un item-doc-est.preco-unit-me item-doc-est.preco-total-me ~
item-doc-est.desconto-me 
&Scoped-define ENABLED-TABLES item-doc-est
&Scoped-define FIRST-ENABLED-TABLE item-doc-est
&Scoped-Define ENABLED-OBJECTS fi-remito RECT-1 RECT-2 rt-mold 
&Scoped-Define DISPLAYED-FIELDS item-doc-est.num-pedido ~
item-doc-est.numero-ordem item-doc-est.parcela item-doc-est.serie-comp ~
item-doc-est.nro-comp item-doc-est.nat-comp item-doc-est.seq-comp ~
item-doc-est.qt-do-forn item-doc-est.quantidade item-doc-est.un ~
item-doc-est.preco-unit-me item-doc-est.preco-total-me ~
item-doc-est.desconto-me 
&Scoped-define DISPLAYED-TABLES item-doc-est
&Scoped-define FIRST-DISPLAYED-TABLE item-doc-est
&Scoped-Define DISPLAYED-OBJECTS de-cotacao c-nossa-unid fi-remito 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS de-cotacao 
&Scoped-define ADM-ASSIGN-FIELDS de-cotacao 
&Scoped-define ADM-MODIFY-FIELDS de-cotacao 

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
DEFINE MENU POPUP-MENU-num-pedido 
       MENU-ITEM m_F5           LABEL "F5 - Zoom"     
       MENU-ITEM m_F7           LABEL "F7 - Consulta" .

DEFINE MENU POPUP-MENU-numero-ordem 
       MENU-ITEM m_F5_O         LABEL "F5 - Zoom"     
       MENU-ITEM m_F7_O         LABEL "F7 - Consulta" .


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-nossa-unid AS CHARACTER FORMAT "X(3)":U 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88 NO-UNDO.

DEFINE VARIABLE de-cotacao AS DECIMAL FORMAT ">>>,>9.99999999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-remito AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38.14 BY 4.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45.14 BY 8.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38.14 BY 3.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-doc-est.num-pedido AT ROW 1.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     item-doc-est.numero-ordem AT ROW 2.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     item-doc-est.parcela AT ROW 3.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     item-doc-est.serie-comp AT ROW 5.33 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     item-doc-est.nro-comp AT ROW 6.33 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     item-doc-est.nat-comp AT ROW 7.33 COL 19 COLON-ALIGNED
          LABEL "":R25
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     item-doc-est.seq-comp AT ROW 8.33 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     de-cotacao AT ROW 1.25 COL 54.72 COLON-ALIGNED
     item-doc-est.qt-do-forn AT ROW 2.25 COL 54.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     item-doc-est.quantidade AT ROW 3.25 COL 54.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     item-doc-est.un AT ROW 2.25 COL 76.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     c-nossa-unid AT ROW 3.25 COL 76.14 COLON-ALIGNED NO-LABEL
     item-doc-est.preco-unit-me AT ROW 5.71 COL 54.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .88
     item-doc-est.preco-total-me AT ROW 6.71 COL 54.57 COLON-ALIGNED FORMAT ">>>>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 21.72 BY .88
     item-doc-est.desconto-me AT ROW 7.71 COL 54.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-remito AT ROW 4.5 COL 13 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 4.75 COL 1
     RECT-2 AT ROW 1 COL 39.29
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.item-doc-est
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 8.5
         WIDTH              = 83.43.
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
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-nossa-unid IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-cotacao IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN item-doc-est.nat-comp IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       item-doc-est.num-pedido:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-num-pedido:HANDLE.

ASSIGN 
       item-doc-est.numero-ordem:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-numero-ordem:HANDLE.

/* SETTINGS FOR FILL-IN item-doc-est.preco-total-me IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN item-doc-est.seq-comp IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       item-doc-est.serie-comp:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME item-doc-est.desconto-me
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.desconto-me V-table-Win
ON LEAVE OF item-doc-est.desconto-me IN FRAME f-main /* Desconto ME */
DO:

  run pi-apos-preco.
  run pi-atualiza-imposto in h_v21in176.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_F5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_F5 V-table-Win
ON CHOOSE OF MENU-ITEM m_F5 /* F5 - Zoom */
DO:

    apply "F5" to item-doc-est.num-pedido in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_F5_O
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_F5_O V-table-Win
ON CHOOSE OF MENU-ITEM m_F5_O /* F5 - Zoom */
DO:

    apply "F5" to item-doc-est.numero-ordem in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_F7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_F7 V-table-Win
ON CHOOSE OF MENU-ITEM m_F7 /* F7 - Consulta */
DO:

    apply "F7" to item-doc-est.num-pedido in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_F7_O
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_F7_O V-table-Win
ON CHOOSE OF MENU-ITEM m_F7_O /* F7 - Consulta */
DO:

    apply "F7" to item-doc-est.numero-ordem in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.nat-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.nat-comp V-table-Win
ON LEAVE OF item-doc-est.nat-comp IN FRAME f-main
DO:
  {cdp/cd9998.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.num-pedido V-table-Win
ON ENTRY OF item-doc-est.num-pedido IN FRAME f-main /* Pedido */
DO:
    if  not l-zoom then 
        assign item-doc-est.num-pedido:modified in frame {&FRAME-NAME} = no.

    assign l-zoom = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.num-pedido V-table-Win
ON F5 OF item-doc-est.num-pedido IN FRAME f-main /* Pedido */
DO:
    run pi-recebe-handle in h_v15in176 (output c-item).

    {include/zoomvar.i &prog-zoom=inzoom/z13in274.w
                       &campo=item-doc-est.numero-ordem                      
                       &campo2=item-doc-est.num-pedido    
                       &campozoom=numero-ordem
                       &campozoom2=num-pedido
                       &parametros="run pi-recebe-parametros in wh-pesquisa 
                                        (input docum-est.cod-emitente, 
                                         input 1,
                                         input c-item)."}

    assign l-zoom = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.num-pedido V-table-Win
ON F7 OF item-doc-est.num-pedido IN FRAME f-main /* Pedido */
DO:

    find pedido-compr where 
        pedido-compr.num-pedido = input frame {&frame-name} item-doc-est.num-pedido 
        no-lock no-error.
    assign gr-pedido-compr = if avail pedido-compr then 
        rowid(pedido-compr) 
        else ?.
    run ccp/cc0509.w.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.num-pedido V-table-Win
ON LEAVE OF item-doc-est.num-pedido IN FRAME f-main /* Pedido */
DO:
  if  input frame {&frame-name} item-doc-est.num-pedido = 0 
  or  item-doc-est.num-pedido:modified in frame {&FRAME-NAME} then 
      assign item-doc-est.numero-ordem:screen-value in frame {&frame-name} = string( 0 )
             item-doc-est.parcela:screen-value in frame {&frame-name} = string( 0 ).

  if  item-doc-est.num-pedido:modified in frame {&FRAME-NAME}
  or  input frame {&frame-name} item-doc-est.num-pedido = 0  then 
      run pi-pedido-ordem.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.num-pedido V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-doc-est.num-pedido IN FRAME f-main /* Pedido */
DO:
            apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.numero-ordem V-table-Win
ON ENTRY OF item-doc-est.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:
    if  not l-zoom then   
        assign item-doc-est.numero-ordem:modified in frame {&FRAME-NAME} = no.

    assign l-zoom = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.numero-ordem V-table-Win
ON F5 OF item-doc-est.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:
    run pi-recebe-handle in h_v15in176 (output c-item).

    {include/zoomvar.i &prog-zoom=inzoom/z13in274.w
                       &campo=item-doc-est.numero-ordem
                       &campozoom=numero-ordem
                       &parametros="run pi-recebe-parametros in wh-pesquisa
                                        (input docum-est.cod-emitente,
                                         input 1,
                                         input c-item)."}

    assign l-zoom = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.numero-ordem V-table-Win
ON F7 OF item-doc-est.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:

    find ordem-compra where 
        ordem-compra.numero-ordem = input frame {&frame-name} item-doc-est.numero-ordem 
        no-lock no-error.
    assign gr-ordem-compra = if avail ordem-compra then 
        rowid(ordem-compra) 
        else ?.
    run ccp/cc0505.w.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.numero-ordem V-table-Win
ON LEAVE OF item-doc-est.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:
    if  item-doc-est.numero-ordem:modified in frame {&FRAME-NAME}
    or  input frame {&frame-name} item-doc-est.numero-ordem = 0  then 
        run pi-pedido-ordem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.numero-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-doc-est.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:
            apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.parcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.parcela V-table-Win
ON ENTRY OF item-doc-est.parcela IN FRAME f-main /* Parcela */
DO:

  assign  item-doc-est.parcela:modified in frame {&FRAME-NAME} = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.parcela V-table-Win
ON F5 OF item-doc-est.parcela IN FRAME f-main /* Parcela */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z01in356.w
                       &campo=item-doc-est.parcela
                       &campozoom=parcela
                       &parametros="run pi-seta-inicial in wh-pesquisa 
                                        (input rowid(ordem-compra))."}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.parcela V-table-Win
ON LEAVE OF item-doc-est.parcela IN FRAME f-main /* Parcela */
DO:
    find prazo-compra
        where prazo-compra.numero-ordem = input frame {&frame-name} item-doc-est.numero-ordem
          and prazo-compra.parcela      = input frame {&frame-name} item-doc-est.parcela
        no-lock no-error.

    if  not avail prazo-compra then do:
        /* mensagem: Parcela n∆o cadastrada */
        {utp/ut-table.i mgind prazo-compra 01}
        run utp/ut-msgs.p (input "show",input 47,input return-value).
        apply 'entry' to item-doc-est.parcela in frame {&frame-name}.
        return no-apply.
    end.

    find ordem-compra
        where ordem-compra.numero-ordem = prazo-compra.numero-ordem no-lock no-error.
/*    if  param-global.modulo-cn and ordem-compra.nr-contrato <> " " then do:
        run cnp/cn9074.p (input frame {&frame-name} item-doc-est.numero-ordem,
                          1,
                          input frame {&frame-name} item-doc-est.int-1,
                          0,
                          docum-est.dt-emissao,
                          output de-val-aux,
                          output l-erro-co,
                          output l-contrato,
                          input-output table tt-erro).
    end.                          
*/
    if  adm-new-record 
    and item-doc-est.parcela:modified in frame {&FRAME-NAME} then do:
        run pi-pedido-ordem.
    end.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.parcela V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-doc-est.parcela IN FRAME f-main /* Parcela */
DO:
            apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.preco-total-me
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.preco-total-me V-table-Win
ON LEAVE OF item-doc-est.preco-total-me IN FRAME f-main /* Preáo Total ME */
DO:

    if  input frame {&frame-name} item-doc-est.qt-do-forn = 0 then
        assign item-doc-est.preco-unit-me:screen-value in frame {&frame-name} =
            string(input frame {&frame-name} item-doc-est.preco-total-me).
    else
        assign item-doc-est.preco-unit-me:screen-value in frame {&frame-name} =
            string(input frame {&frame-name} item-doc-est.preco-total-me /
                   input frame {&frame-name} item-doc-est.qt-do-forn).


    if adm-new-record then do:
        if param-re.rateia-desc and
            available docum-est then do:
            run rep/re1001r.p (rowid(docum-est),
                               input frame {&frame-name} item-doc-est.preco-total-me,
                               1,
                               output de-desconto).
            if  de-desconto <> 0 then do:                               
                assign item-doc-est.desconto-me:screen-value in frame {&frame-name} =
                       string(de-desconto).
            end.                       
        end.                
    end.            

    run pi-apos-preco.            
    run pi-atualiza-imposto in h_v21in176.        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.preco-unit-me
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.preco-unit-me V-table-Win
ON LEAVE OF item-doc-est.preco-unit-me IN FRAME f-main /* Preáo Unit ME */
DO:

    assign item-doc-est.preco-total-me:screen-value in frame {&frame-name} =
        string(input frame {&frame-name} item-doc-est.preco-unit-me *
                     (input frame {&frame-name} item-doc-est.qt-do-forn +
                     int(input frame {&frame-name} item-doc-est.qt-do-forn = 0))).
    run pi-atualiza-imposto in h_v21in176.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.qt-do-forn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.qt-do-forn V-table-Win
ON LEAVE OF item-doc-est.qt-do-forn IN FRAME f-main /* Qtde Emitente */
DO:
    if adm-new-record then do:
        assign item-doc-est.quantidade:screen-value in frame {&frame-name} =
            string((input frame {&frame-name} item-doc-est.qt-do-forn / de-indice)).
        if item.fraciona = no then
            assign item-doc-est.quantidade:screen-value in frame {&frame-name} = 
                string(truncate(input frame {&frame-name} item-doc-est.quantidade,0)).
    end.                            

   assign item-doc-est.preco-total-me:screen-value in frame {&frame-name} =
        string(input frame {&frame-name} item-doc-est.preco-unit-me *
                     (input frame {&frame-name} item-doc-est.qt-do-forn +
                     int(input frame {&frame-name} item-doc-est.qt-do-forn = 0))).
   run pi-atualiza-imposto in h_v21in176.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.quantidade V-table-Win
ON LEAVE OF item-doc-est.quantidade IN FRAME f-main /* Nossa Qtde */
DO:

   if param-re.pede-quant then
      assign item-doc-est.qt-do-forn:screen-value in frame {&frame-name} =
                                 string(input frame {&frame-name} item-doc-est.quantidade * de-indice).
    /** Passa nova quantidade para o browse de estoque.  */
  if valid-handle(h_b03in367) then
      run pi-dados-complement in h_b03in367 (input frame {&frame-name} item-doc-est.quantidade).

  assign item-doc-est.preco-total-me:screen-value in frame {&frame-name} =
        string(input frame {&frame-name} item-doc-est.preco-unit-me *
                     (input frame {&frame-name} item-doc-est.qt-do-forn +
                     int(input frame {&frame-name} item-doc-est.qt-do-forn = 0))).
  run pi-atualiza-imposto in h_v21in176.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.un V-table-Win
ON LEAVE OF item-doc-est.un IN FRAME f-main /* Un */
DO:
      assign c-nossa-unid:screen-value in frame {&frame-name} = input frame {&frame-name} item-doc-est.un.
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
  if item-doc-est.num-pedido:load-mouse-pointer("image/rbm.cur")
     in frame {&frame-name} then .
  if item-doc-est.numero-ordem:load-mouse-pointer("image/rbm.cur")
     in frame {&frame-name} then .

  {utp/ut-liter.i Remito * C}
  assign fi-remito:screen-value in frame {&frame-name} = return-value.  

  do with frame {&frame-name}:
     {utp/ut-field.i mgind docum-est cotacao-dia 1}
     assign de-cotacao:label in frame {&frame-name} = return-value.
     {utp/ut-liter.i Numero * L}
     assign item-doc-est.nro-comp:label = return-value.  
     {utp/ut-liter.i Natureza * L}
     assign item-doc-est.nat-comp:label = return-value.  
     {utp/ut-liter.i Sequencia * L}
     assign item-doc-est.seq-comp:label = return-value.  

  end.

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
  {src/adm/template/row-list.i "item-doc-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-doc-est"}

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

  /* Code placed here will execute AFTER standard behavior.    */
  assign i-num-ord-inv = 0
         l-inclui      = yes.

  assign de-cotacao:screen-value in frame {&frame-name} = 
         if avail docum-est then string(docum-est.cotacao-dia)
         else " ".

  if avail estabelec then
     assign item-doc-est.serie-comp:screen-value in frame {&frame-name} = estabelec.serie-manual.

  IF NOT l-ut-ser
      AND i-pais-impto-usuario <> 1 /*Brasil*/ THEN DO:

      IF NOT AVAIL param-estoq THEN
          FOR FIRST param-estoq NO-LOCK: END.

      ASSIGN item-doc-est.serie-comp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(param-estoq.char-2,69,5).

  END.                                                                                                       
  {utp/ut-liter.i Remito * C}
  assign fi-remito:screen-value in frame {&frame-name} = return-value.  

  for each tt-erro:
      delete tt-erro.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  def var de-desconto    as decimal no-undo.
  def var de-valor       as decimal no-undo.
  def var de-desconto-me as decimal no-undo.
  def var de-valor-me    as decimal no-undo.

  assign input frame {&frame-name} de-cotacao.

  if  adm-new-record = no and avail item-doc-est then do:
      assign de-qt-aux      = item-doc-est.quantidade
             de-desconto    = item-doc-est.desconto[1]
             de-valor       = item-doc-est.preco-total[1]
             de-desconto-me = item-doc-est.desconto-me
             de-valor-me    = item-doc-est.preco-total-me.
  end.
  else
      assign de-desconto    = 0
             de-valor       = 0
             de-desconto-me = 0
             de-valor-me    = 0.

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}

    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
    assign item-doc-est.num-ord-inv = i-num-ord-inv.

    if avail item-doc-est and item-doc-est.num-pedido <> 0 then do:
        find ordem-compra where 
            ordem-compra.numero-ordem = item-doc-est.numero-ordem
            no-lock no-error.
        assign item-doc-est.num-ord-inv = ordem-compra.num-ord-inv.
    end.        

    assign l-novo-reg = no.

  if avail item-doc-est then do:
     assign item-doc-est.cod-emitente = docum-est.cod-emitente
            item-doc-est.nro-docto    = docum-est.nro-docto
            item-doc-est.serie-docto  = docum-est.serie-docto
            item-doc-est.nat-operacao = docum-est.nat-operacao 
            item-doc-est.qt-saldo     = 0
            l-novo-reg                = no
            item-doc-est.sit-item     = if docum-est.nff or
                                          (not docum-est.nff and avail natur-oper and
                                           not natur-oper.emite-duplic) then 1 else 2.
  end.

  find docum-est where rowid(docum-est) = gr-docum-est EXCLUSIVE-LOCK no-error.

  assign item-doc-est.preco-unit[1]  = item-doc-est.preco-unit-me * docum-est.cotacao-dia.
  assign item-doc-est.preco-total[1] = fn_ajust_dec((item-doc-est.preco-unit-me * item-doc-est.qt-do-forn * docum-est.cotacao-dia), 0).
  assign item-doc-est.desconto[1]    = fn_ajust_dec((item-doc-est.desconto-me * docum-est.cotacao-dia), 0).

  assign docum-est.tot-desconto    = docum-est.tot-desconto 
                                   + item-doc-est.desconto[1] - de-desconto
         docum-est.tot-valor       = docum-est.tot-valor
                                   + item-doc-est.preco-total[1] - de-valor      
         docum-est.tot-desconto-me = docum-est.tot-desconto-me
                                   + item-doc-est.desconto-me - de-desconto-me 
         docum-est.tot-valor-me    = docum-est.tot-valor-me
                                   + item-doc-est.preco-total-me - de-valor-me
         docum-est.valor-mercad    = docum-est.tot-valor
         docum-est.valor-mercad-me = docum-est.tot-valor-me.

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

  /* Code placed here will execute AFTER standard behavior.    */
    for each tt-erro:
        delete tt-erro.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute AFTER standard behavior.    */

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    assign l-novo-reg = no.

    for each tt-erro:
        delete tt-erro.
    end.

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
  {utp/ut-liter.i Remito * C}
   assign fi-remito:screen-value in frame {&frame-name} = return-value.  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  if available item-doc-est then 
     assign i-num-ord-inv = item-doc-est.num-ord-inv.

/* Mostrar Nossa Unidade de Medida */
find docum-est 
      where rowid(docum-est) = gr-docum-est no-lock no-error.

find item where item.it-codigo = item-doc-est.it-codigo no-lock no-error.
find item-fornec 
     where item-fornec.cod-emitente = docum-est.cod-emitente 
     and item-fornec.it-codigo    = item-doc-est.it-codigo  no-lock no-error.

if  not adm-new-record then do:
    if avail item                
    and item.tipo-contr = 4      
    and not avail item-fornec 
    then assign c-nossa-unid:screen-value in frame {&frame-name} = item-doc-est.un.
    else assign c-nossa-unid:screen-value in frame {&frame-name} = if  avail item 
                                                                   then item.un
                                                                   else " ".
end.                          
/* Mostrar Nossa Unidade de Medida */


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

    {utp/ut-liter.i Remito * C}
    assign fi-remito:screen-value in frame {&frame-name} = return-value.  

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    /* Code placed here will execute AFTER standard behavior.    */

    disable all with frame {&frame-name}.

    assign l-novo-reg = yes.

    if adm-new-record = yes then do:
       enable all except item-doc-est.serie-comp 
                         item-doc-est.nat-comp
                         item-doc-est.seq-comp 
                         c-nossa-unid with frame {&frame-name}.    
    end.
    else do:
        enable item-doc-est.qt-do-forn     
               item-doc-est.quantidade     
               item-doc-est.un             
               item-doc-est.preco-unit-me
               item-doc-est.preco-total-me 
               item-doc-est.desconto-me    with frame {&FRAME-NAME}.
    end.

    if item-doc-est.serie-comp:hidden in frame {&frame-name} = no and
       adm-new-record = yes then
       enable item-doc-est.serie-comp with frame {&frame-name}.

    find docum-est 
        where rowid(docum-est) = gr-docum-est no-lock no-error.

    assign l-pede-compra = param-global.modulo-cc.

    if  i-programa-re = 1 then
        run pi-recebimento.
    else
    if  i-programa-re = 2 then
        run pi-fisico.
    else
        run pi-internacional.

    if  l-novo-reg 
    and param-re.log-1 = yes 
    and input frame {&frame-name} item-doc-est.numero-ordem = 0 
    and l-pede-compra then do:
        if  not adm-new-record and avail item-doc-est then do:
            find first rat-ordem {cdp/cd8900.i rat-ordem docum-est}
                   and rat-ordem.sequencia = item-doc-est.sequencia no-lock no-error.
            if  avail rat-ordem then 
                disable item-doc-est.num-pedido
                        item-doc-est.numero-ordem
                        item-doc-est.parcela with frame {&frame-name}.
        end.                   
    end.            

    assign l-novo-reg = yes.


    run pi-internacional.

    if  l-pede-qtd then 
        enable item-doc-est.quantidade  item-doc-est.qt-do-forn with frame {&frame-name}.


    if  param-re.preco-unit then
        enable item-doc-est.preco-unit-me  with frame {&frame-name}.

    enable item-doc-est.preco-total-me with frame {&frame-name}.

    if param-re.pede-desc-it then
        enable item-doc-est.desconto-me    with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if  l-erro-qtd then do:
      /* {include/i-vldprg.i} */
       run utp/ut-msgs.p (input "show",input 15455,input " ").
       apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
  end.      

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
     {utp/ut-liter.i Remito * C}
     assign fi-remito:screen-value in frame {&frame-name} = return-value.  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

    find docum-est where
        rowid(docum-est) = gr-docum-est 
        no-lock no-error.

    if avail docum-est then do:
        find emitente where
            emitente.cod-emitente = docum-est.cod-emitente
            no-lock no-error.
        assign i-moeda = docum-est.mo-codigo.
        find estabelec where
             estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
    end.
    find param-re where
        param-re.usuario = c-seg-usuario
        no-lock no-error.        
    find first param-global
        no-lock no-error.
    find first param-compra
        no-lock no-error.     
    find first param-estoq
        no-lock no-error.   

    /*Quando tem valor na param-estoq deve ser considerado o que est† nesse campo e n∆o na param-global*/
    IF SUBSTRING(param-estoq.char-2,68,1) <> "":U THEN
        ASSIGN l-ut-ser = (SUBSTRING(param-estoq.char-2,68,1) = "S":U).
    ELSE DO:
        {cdp/cd4300.i4  "yes" param-global.char-2}             
        {cdp/cd0101.i51 "yes"}
    END.

    if l-ut-ser = yes then
       assign item-doc-est.serie-comp:hidden in frame {&frame-name} = no.
    else assign item-doc-est.serie-comp:hidden in frame {&frame-name} = yes.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-apos-preco V-table-Win 
PROCEDURE pi-apos-preco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*  Ordem de Compra de Serviáo */
    if  available ordem-compra 
    and ordem-compra.natureza = 2 
    and input frame {&frame-name} item-doc-est.qt-do-forn = 0    
    and input frame {&frame-name} item-doc-est.quantidade = 0 then do:

        assign item-doc-est.qt-do-forn:screen-value in frame {&frame-name} =
                            string( (input frame {&frame-name} item-doc-est.preco-total-me -
                                     input frame {&frame-name} item-doc-est.desconto-me) /
                                     de-vl-preuni)
               item-doc-est.quantidade:screen-value in frame {&frame-name} = 
                            string(input frame {&frame-name} item-doc-est.qt-do-forn / de-indice)
               item-doc-est.preco-unit-me:screen-value in frame {&frame-name} = 
                            string( input frame {&frame-name} item-doc-est.preco-total-me /
                                  ( input frame {&frame-name} item-doc-est.qt-do-forn +
                                    int( input frame {&frame-name} item-doc-est.qt-do-forn = 0))).
    end.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-ordem-cc V-table-Win 
PROCEDURE pi-atualiza-ordem-cc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param i-ordem-cc   like item-doc-est.numero-ordem no-undo.
    def input param i-parcela-cc like item-doc-est.parcela      no-undo.

    def var de-preco-cc          as decimal no-undo.
    def var de-desconto-cc       as decimal no-undo.
    def var de-qtd-aux           as decimal no-undo.

    assign i-numero-ordem = i-ordem-cc
           i-parcela      = i-parcela-cc.

    find ordem-compra 
        where ordem-compra.numero-ordem = i-ordem-cc no-lock.

    if  avail ordem-compra then do:
        /*  C†lculo Preáo Unit†rio */
        run pi-verifica-cotacao.
        run rep/re1908.p (rowid(ordem-compra),
                          docum-est.dt-emissao,
                          output de-preco-cc,  
                          output de-desconto-cc,
                          output de-taxa).
        find item 
            where item.it-codigo = ordem-compra.it-codigo no-lock no-error.

        find prazo-compra 
            where prazo-compra.numero-ordem = ordem-compra.numero-ordem
              and prazo-compra.parcela      = i-parcela-cc no-lock no-error.

        if  avail prazo-compra then do: 
            assign de-qtd-aux = prazo-compra.quant-saldo - prazo-compra.dec-1
                   item-doc-est.qt-do-forn:screen-value in frame {&frame-name} =
                                       string( de-qtd-aux * de-indice )

                   de-qtd-aux = if  item.fraciona then de-qtd-aux
                                else truncate( de-qtd-aux, 0 )

                   item-doc-est.quantidade:screen-value in frame {&frame-name} =
                                        string( de-qtd-aux ).
        end.

        assign de-qtd-aux =(input frame {&frame-name} item-doc-est.qt-do-forn +
                            int(input frame {&frame-name} item-doc-est.qt-do-forn = 0)).


        assign item-doc-est.preco-unit-me:screen-value in frame {&frame-name} = string(de-preco-cc)
               item-doc-est.desconto-me:screen-value in frame {&frame-name} = 
                                       string(de-desconto-cc * de-qtd-aux)
               item-doc-est.preco-total-me:screen-value in frame {&frame-name} = 
                                       string(de-preco-cc * de-qtd-aux )
               de-vl-merc-liq = de-preco-cc - de-desconto-cc.                                       

    end.

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
    define input parameter v-row-parent-externo as rowid no-undo.

    assign v-row-parent = v-row-parent-externo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-preco V-table-Win 
PROCEDURE pi-atualiza-preco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter table for tt-rat-ordem.

    def var de-preco-cc          as decimal no-undo.
    def var de-desconto-cc       as decimal no-undo.
    def var de-qtd-aux           as decimal no-undo.
    def var de-preco-cc-acum     as decimal no-undo.
    def var de-desconto-cc-acum  as decimal no-undo.

    for each tt-rat-ordem where tt-rat-ordem.log-1 no-lock:

        find ordem-compra 
             where ordem-compra.numero-ordem = tt-rat-ordem.numero-ordem no-lock.

        if  avail ordem-compra then do:
            /*  C†lculo Preáo Unit†rio */
            run pi-verifica-cotacao.
            run rep/re1908.p (rowid(ordem-compra),
                              docum-est.dt-emissao,
                              output de-preco-cc,  
                              output de-desconto-cc,
                              output de-taxa).
            assign de-preco-cc-acum = de-preco-cc-acum + de-preco-cc
                   de-desconto-cc-acum = de-desconto-cc-acum + de-desconto-cc.

            find item 
                where item.it-codigo = ordem-compra.it-codigo no-lock no-error.

            find prazo-compra 
                where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                  and prazo-compra.parcela      = tt-rat-ordem.parcela no-lock no-error.

            if  avail prazo-compra then
                assign de-qtd-aux = de-qtd-aux + tt-rat-ordem.quantidade
                       de-qtd-aux = (if  item.fraciona then de-qtd-aux
                                     else truncate( de-qtd-aux, 0 )).

            assign de-qtd-aux = ((de-qtd-aux) + int((de-qtd-aux * de-indice) = 0)).

        end.
    end.
    assign item-doc-est.qt-do-forn:screen-value in frame {&frame-name} =
                                   string(de-qtd-aux * de-indice)
           item-doc-est.quantidade:screen-value in frame {&frame-name} =
                                   string(de-qtd-aux)
           item-doc-est.preco-unit-me:screen-value in frame {&frame-name} = string(de-preco-cc-acum)
           item-doc-est.desconto-me:screen-value in frame {&frame-name} = 
                                    string(de-desconto-cc-acum * de-qtd-aux)
           item-doc-est.preco-total-me:screen-value in frame {&frame-name} =
                                       string(round(input frame {&frame-name} item-doc-est.preco-unit-me *
                                              input frame {&frame-name} item-doc-est.qt-do-forn, 2)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-un V-table-Win 
PROCEDURE pi-atualiza-un :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find item-fornec
        where item-fornec.cod-emitente = docum-est.cod-emitente 
          and item-fornec.it-codigo    = item.it-codigo no-lock no-error.


    assign c-un = if  available item-fornec then
                      item-fornec.unid-med-for
                  else
                      item.un.

    if  adm-new-record then do:
        assign item-doc-est.un:screen-value in frame {&frame-name} = c-un.    

        if   avail item            
        and  item.tipo-contr = 4   
        and  not avail item-fornec 
        then assign c-nossa-unid:screen-value in frame {&frame-name} = c-un.
        else assign c-nossa-unid:screen-value in frame {&frame-name} = if avail item 
                                                                      then item.un 
                                                                      else "".
    end.                                                                      

    assign c-un-aux = input frame {&frame-name} item-doc-est.un.
    {cdp/cd9950.i item.un 
                  c-un-aux
                  docum-est.cod-emitente}

    if  de-indice = 0 or de-indice = ? then 
        assign de-indice = 1.                  

 assign item-doc-est.un:sensitive in frame {&frame-name} = (avail item and
                                                            item.tipo-contr = 4 and
                                                            not avail item-fornec).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-continua-validate V-table-Win 
PROCEDURE pi-continua-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /* Continuaá∆o do Pi-validate. */

    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

    find item where item.it-codigo = c-it-codigo no-lock no-error.

    /* Buca a variacao por familia ou item-uni estab de acordo com ver EMS.*/
    {rep/re1001.i10 docum-est.cod-estabel}

    if  l-pede-qtd then do:   
        if  item.fraciona = no 
        and integer( input frame {&frame-name} item-doc-est.quantidade) <>
                     input frame {&frame-name} item-doc-est.quantidade then do:
            /* mensagem: Quantidade n∆o pode ser fracionada */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 1892,input " ").
            apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if  input frame {&frame-name} item-doc-est.quantidade = 0 then do:
            /* mensagem: Quantidade deve ser diferente de zero */
            {include/i-vldprg.i}
            {utp/ut-liter.i Quantidade * L}
            run utp/ut-msgs.p (input "show",input 1491,input return-value).
            apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
            return 'adm-error':U.
        end.

    end.

    if  input frame {&frame-name} item-doc-est.un <> c-un 
    and (available item-fornec or item.tipo-contr <> 4) then do:            
        /* mensagem: Unidade de medida n∆o confere */
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",input 7346,input " ").
        apply 'entry' to item-doc-est.un in frame {&frame-name}.
        return 'adm-error':U.
    end.

    if  input frame {&frame-name} item-doc-est.preco-total-me = 0 
    and input frame {&frame-name} item-doc-est.quantidade <> 0 then do:
        /* mensagem: Preco total deve ser diferente de zero */
        {include/i-vldprg.i}
        {utp/ut-liter.i Preco_Total * L}
        run utp/ut-msgs.p (input "show",input 1491,input return-value).
        apply 'entry' to item-doc-est.preco-total-me in frame {&frame-name}.
        return 'adm-error':U.
    end.
    if  input frame {&frame-name} item-doc-est.qt-do-forn <> 0 then do:
        assign de-val-aux = round(input frame {&frame-name} item-doc-est.preco-unit-me *
                                  input frame {&frame-name} item-doc-est.qt-do-for,2).

        if  de-val-aux <> input frame {&frame-name} item-doc-est.preco-total-me 
        and param-re.preco-unit then do:
            /* mensagem: Preco total n∆o confere com calculado. Confirma? */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15193,input " ").
            if  return-value <> "yes" then do:                                   
                apply 'entry' to item-doc-est.un in frame {&frame-name}.
                return 'adm-error':U.
            end.
            assign item-doc-est.preco-unit-me:screen-value in frame {&frame-name} =
                        string(input frame {&frame-name} item-doc-est.preco-total-me /
                               input frame {&frame-name} item-doc-est.qt-do-forn ).
        end.
    end.                


    if  i-numero-ordem <> 0 then do:
        assign de-vl-merc-liq-aux = input frame {&frame-name} item-doc-est.preco-total-me 
                                  - input frame {&frame-name} item-doc-est.desconto-me.
        if  not l-contrato then do:
            assign de-vl-aux = de-vl-merc-liq * ( input frame {&frame-name} item-doc-est.qt-do-forn
                                           + int( input frame {&frame-name} item-doc-est.qt-do-forn = 0 )).

            run pi-variacao-valor ( input de-vl-aux,
                                    &IF defined(bf_mat_uni_estab) &THEN
                                        output de-var-max-perc,
                                        OUTPUT de-var-max-lim,
                                    &ELSE
                                        OUTPUT de-var-max
                                    &ENDIF
                                    output de-var-min).

            &IF defined(bf_mat_uni_estab) &THEN
                ASSIGN l-erro = NO.
                IF  de-var-val-re-maior = 0
                AND de-lim-var-valor    = 0  THEN DO:
                    IF  de-vl-merc-liq-aux > de-var-max-perc
                    OR  de-vl-merc-liq-aux > de-var-max-lim THEN
                        ASSIGN l-erro = YES.
                END.
                ELSE DO:
                    IF  de-vl-merc-liq-aux <= de-var-max-perc
                    OR  de-var-val-re-maior = 0 THEN
                        IF  de-vl-merc-liq-aux > de-var-max-lim
                        AND de-lim-var-valor > 0 THEN
                            ASSIGN l-erro = YES.
                        ELSE
                            ASSIGN l-erro = NO.
                    ELSE
                        ASSIGN l-erro = YES.
                END.
            &ENDIF
        end.                                   


        if  &IF defined(bf_mat_uni_estab) &THEN
                l-erro 
            &ELSE
                de-vl-merc-liq-aux > de-var-max            
            &ENDIF
        then do:
            if  param-re.aceita-var = no then do:                               
                /* mensagem: Valor l°quido fora da variacao permitida */
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",input 15195,input " ").
                apply 'entry' to item-doc-est.preco-unit-me in frame {&frame-name}.
                return 'adm-error':U.
            end.
            /* mensagem: Valor l°quido fora da variacao permitida. Confirma? */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15196,input " ").
            if return-value <> "yes" then do:                                
                apply 'entry' to item-doc-est.preco-unit-me in frame {&frame-name}.
                return 'adm-error':U.
            end.
        end.

       &IF defined(bf_mat_uni_estab) &THEN
           run rep/re9995.p (rowid(docum-est),
                             IF de-qtd-max-perc < de-qtd-max-lim THEN
                                de-qtd-max-perc
                             ELSE
                                de-var-max-lim,
                            de-vl-merc-liq-aux,
                            15196,
                            NOT l-erro,
                            i-sequencia,
                            1).


/*                ( not ((de-vl-merc-liq > de-qtd-max-lim  or de-vl-merc-liq < de-var-min) OR             */
/*                                    (de-vl-merc-liq > de-qtd-max-perc or de-vl-merc-liq < de-var-min))) */



      &ELSE
          run rep/re9995.p ( rowid(docum-est),
                             de-qtd-aux,
                             de-vl-merc-liq-aux,
                             15196,
                            ( not (de-vl-merc-liq > de-var-max or de-vl-merc-liq < de-var-min)),
                              i-sequencia,
                              1).

      &ENDIF



    end.                                            
    if  l-pede-qtd then do:
        if  i-numero-ordem <> 0 then do:
            if not l-erro-co then do:
                if not l-contrato then                    
                    run pi-variacao-quant ( input prazo-compra.quant-saldo -
                                                  prazo-compra.dec-1,
                                            &IF defined(bf_mat_uni_estab) &THEN
                                                OUTPUT de-qtd-max-perc,
                                                OUTPUT de-qtd-max-lim
                                            &ELSE
                                                output de-qtd-max
                                            &ENDIF ).

                   &IF defined(bf_mat_uni_estab) &THEN
                        ASSIGN l-erro = NO.
                        IF  de-var-qtd-re  = 0
                        AND de-lim-var-qtd = 0  THEN DO:
                            IF  input frame {&frame-name} item-doc-est.quantidade > de-qtd-max-perc
                            OR  input frame {&frame-name} item-doc-est.quantidade > de-qtd-max-lim THEN
                                ASSIGN l-erro = YES.
                        END.
                        ELSE DO:
                            IF  input frame {&frame-name} item-doc-est.quantidade <= de-qtd-max-perc
                            OR  de-var-qtd-re = 0 THEN
                                IF  input frame {&frame-name} item-doc-est.quantidade > de-qtd-max-lim
                                AND de-lim-var-qtd > 0 THEN
                                    ASSIGN l-erro = YES.
                                ELSE
                                    ASSIGN l-erro = NO.
                            ELSE
                                ASSIGN l-erro = YES.
                        END.
                    &ENDIF 
                    if  &IF defined(bf_mat_uni_estab) &THEN
                           l-erro
                        &ELSE
                           input frame {&frame-name} item-doc-est.quantidade > de-qtd-max
                       &ENDIF
                       then do:

                            if  param-re.aceita-var = no then do:                               
                                /* mensagem: Quantidade fora da variacao permitida */
                                {include/i-vldprg.i}
                                run utp/ut-msgs.p (input "show",input 5928,input " ").
                                apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
                                return 'adm-error':U.
                            end.
                            /* mensagem: Quantidade fora da variacao permitida. Confirma? */
                            {include/i-vldprg.i}
                            run utp/ut-msgs.p (input "show",input 5698,input " ").
                            if return-value <> "yes" then do:                                
                                apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
                                return 'adm-error':U.
                            end.
                     end.
            end.


            &IF defined(bf_mat_uni_estab) &THEN
                run rep/re9995.p (rowid(docum-est),
                                  IF de-qtd-max-perc < de-qtd-max-lim THEN
                                     de-qtd-max-perc
                                  ELSE
                                      de-var-max-lim,
                                  input frame {&frame-name} item-doc-est.quantidade,
                                  5698,
                                  NOT l-erro,
                                  i-sequencia,
                                  1).

/*                                not ((input frame {&frame-name} item-doc-est.quantidade > de-qtd-max-perc)       */
/*                                        OR (input frame {&frame-name} item-doc-est.quantidade > de-qtd-max-lim)) */


            &ELSE
                run rep/re9995.p (rowid(docum-est),
                                  de-qtd-max,
                                  input frame {&frame-name} item-doc-est.quantidade,
                                  5698,
                                  not (input frame {&frame-name} item-doc-est.quantidade > de-qtd-max),
                                  i-sequencia,
                                  1).
            &ENDIF  
        end.
    end.

    find first tt-erro 
        no-lock no-error.
    if available tt-erro then do:
        /* mensagem: Erro da tt-erro */
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",input tt-erro.cd-erro,input " ").
        for each tt-erro:
            delete tt-erro.
        end.
        apply 'entry' to item-doc-est.qt-do-forn in frame {&frame-name}.
        return 'adm-error':U.
    end.     
    if  not adm-new-record 
    and i-numero-ordem = 0 
    and avail item-doc-est 
    and docum-est.cod-observa <> 3 then do:
        assign de-qtd-aux = 0.
        for each rat-ordem {cdp/cd8900.i rat-ordem item-doc-est} 
             and rat-ordem.sequencia = item-doc-est.sequencia no-lock:
            assign de-qtd-aux = de-qtd-aux + rat-ordem.quantidade.
        end.
        if  de-qtd-aux > input frame {&frame-name} item-doc-est.quantidade then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15455,input " ").
            apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
            return 'adm-error':U.
        end.             
    end.       


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-fifo V-table-Win 
PROCEDURE pi-fifo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def output parameter p-habilita-fifo as logical no-undo.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-internacional V-table-Win 
PROCEDURE pi-internacional :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign l-consiste-item = yes
           l-pede-pedordem = (l-pede-compra ).


  assign l-pede-qtd   = yes
         l-pede-peso  = yes
         l-pede-valor = param-re.pd-despesa.                                

/* Consistàncias Internacional */
  assign de-cotacao:screen-value in frame {&frame-name} = string(docum-est.cotacao-dia)
         de-cotacao:sensitive    in frame {&frame-name} = no. /*a l¢gica de habilitaá∆o deste campo 
                                                                est† na procedure pi-verifica-cotacao*/
  if  adm-new-record then do:
      if  available ordem-compra and 
          ordem-compra.mo-codigo <> 0 and not docum-est.nff and 
          ordem-compra.mo-codigo = docum-est.mo-codigo then do:
          find first moeda where moeda.mo-codigo = ordem-compra.mo-codigo
               no-lock no-error.
          find cotacao where
               cotacao.mo-codigo = ordem-compra.mo-codigo and
               cotacao.ano-periodo = (string(year(today),'9999') +
                                      string(month(today),'99')) no-error.
          if not available cotacao or 
            (avail cotacao and docum-est.cotacao-dia = 0) then 
              enable de-cotacao with frame {&frame-name}.
          else 
              disable de-cotacao with frame {&frame-name}.
      end.
      else 
         disp docum-est.cotacao-dia @ de-cotacao with frame {&frame-name}.
  end.
  else
      disp docum-est.cotacao-dia @ de-cotacao with frame {&frame-name}. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-handle-1 as handle no-undo.
    def input parameter p-handle-2 as handle no-undo.
    def input parameter p-handle-3 as handle no-undo.

    assign h_v15in176 = p-handle-1
           h_v20in176 = p-handle-2
           h_v21in176 = p-handle-3.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-item V-table-Win 
PROCEDURE pi-passa-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-sequencia     like item-doc-est.sequencia no-undo.
    def input parameter p-it-codigo     like item.it-codigo         no-undo.

    assign c-it-codigo = p-it-codigo.

    find item where item.it-codigo = c-it-codigo no-lock no-error.

    /**** consistencia do coleta de dados ****/
    create tt-etq-item.
    assign tt-etq-item.it-codigo = c-it-codigo
           tt-etq-item.cod-versao-integracao = 1. 

    if  avail param-global
    and param-global.modulo-cl
    then do:
        run bcp/bcapi011.p (input-output table tt-etq-item).
    end.
    find first tt-etq-item no-error. 

    if  avail tt-etq-item then delete tt-etq-item.

    /*****************************************/                                 

    assign i-sequencia = p-sequencia.

    run pi-atualiza-un.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-quantidade V-table-Win 
PROCEDURE pi-passa-quantidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter de-quant as decimal no-undo.
    assign item-doc-est.quantidade:screen-value in frame {&frame-name} =
        string(de-quant).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-rateio V-table-Win 
PROCEDURE pi-passa-rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-quantidade as decimal no-undo.
    def input parameter p-qt-do-forn as decimal no-undo.

    assign item-doc-est.quantidade:screen-value in frame {&frame-name} =
        string(p-quantidade).
    assign item-doc-est.qt-do-forn:screen-value in frame {&frame-name} = 
        string(p-qt-do-forn).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pedido-ordem V-table-Win 
PROCEDURE pi-pedido-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  input frame {&frame-name} item-doc-est.num-pedido <> 0 
    and input frame {&frame-name} item-doc-est.numero-ordem = 0 then do:
        find first ordem-compra 
             where ordem-compra.num-pedido = input frame {&frame-name} item-doc-est.num-pedido 
               and ordem-compra.it-codigo  = c-it-codigo
               and ordem-compra.situacao   = 2 no-lock no-error.
        if  not avail ordem-compra and c-it-codigo = " " then                
            find first ordem-compra 
                 where ordem-compra.num-pedido = input frame {&frame-name} item-doc-est.num-pedido 
                   and ordem-compra.situacao   = 2 no-lock no-error.

        if  available ordem-compra then
            assign item-doc-est.numero-ordem:screen-value in frame {&frame-name} = string(ordem-compra.numero-ordem).
    end.                                                       
    if  input frame {&frame-name} item-doc-est.num-pedido = 0 
    and input frame {&frame-name} item-doc-est.numero-ordem <> 0 then do:
        find ordem-compra 
            where ordem-compra.numero-ordem = input frame {&frame-name} item-doc-est.numero-ordem
            no-lock no-error.
        if  available ordem-compra 
        and ordem-compra.num-pedido <> 0 then
            assign item-doc-est.num-pedido:screen-value in frame {&frame-name} = string(ordem-compra.num-pedido).
    end. 

    find ordem-compra 
        where ordem-compra.numero-ordem = input frame {&frame-name} item-doc-est.numero-ordem
        no-lock no-error.

    if  available ordem-compra then do:

        if  input frame {&frame-name} item-doc-est.parcela = 0 
        or item-doc-est.numero-ordem:modified in frame {&FRAME-NAME} then do:
            find first prazo-compra 
                 where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
                   and prazo-compra.situacao     = 2 
                   and ( prazo-compra.quant-saldo - prazo-compra.dec-1 ) > 0 no-lock no-error.
            if  not avail prazo-compra then 
                find first prazo-compra 
                     where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
                       and prazo-compra.situacao     = 2 no-lock no-error.

            if  available prazo-compra then
                assign item-doc-est.parcela:screen-value in frame {&frame-name} = string(prazo-compra.parcela).
        end.

        enable item-doc-est.parcela with frame {&frame-name}.

        assign l-evento = no.
        &if defined(bf_mat_contratos) &then
        if  ordem-compra.nr-contrato <> 0 and param-global.modulo-cn then do:
        &else
        if  ordem-compra.nr-contrato <> " " and param-global.modulo-cn then do:
        &endif
            run cnp/cn9071.p (input frame {&frame-name} item-doc-est.numero-ordem,
                              input frame {&frame-name} item-doc-est.num-pedido,
                              2,
                              output l-evento,
                              output l-erro-co,
                              input-output table tt-erro).
        end.

        if  adm-new-record and avail ordem-compra then do:

            run pi-item-cc in h_v15in176 ( ordem-compra.it-codigo ).

            /* Atualiza Preáo da Ordem de Compra */
            run pi-atualiza-ordem-cc  ( input frame {&frame-name} item-doc-est.numero-ordem,
                                        input frame {&frame-name} item-doc-est.parcela ).

            run pi-atualiza-ordem-cc in h_v20in176 ( input frame {&frame-name} item-doc-est.numero-ordem ).
        end.
    end.         
    else 
        disable item-doc-est.parcela with frame {&frame-name}.

    if  param-re.log-1 = yes 
    and input frame {&frame-name} item-doc-est.numero-ordem = 0 
    and input frame {&frame-name} item-doc-est.num-pedido = 0 then do:
        if  not adm-new-record and avail item-doc-est then 
            find first rat-ordem {cdp/cd8900.i rat-ordem item-doc-est}
                   and rat-ordem.sequencia = item-doc-est.sequencia no-lock no-error.
    end.                    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-quant-maxima V-table-Win 
PROCEDURE pi-quant-maxima :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find prazo-compra
        where prazo-compra.numero-ordem = i-numero-ordem
          and prazo-compra.parcela      = i-parcela
        exclusive-lock no-error.

    find ordem-compra
        where ordem-compra.numero-ordem = i-numero-ordem no-lock no-error.

    if not l-contrato then
        run pi-variacao-quant ( input prazo-compra.quant-saldo -
                                      prazo-compra.dec-1,
                                &IF defined(bf_mat_uni_estab) &THEN
                                    OUTPUT de-qtd-max-perc,
                                    OUTPUT de-qtd-max-lim
                                &ELSE
                                    output de-qtd-max
                                &ENDIF ). 

    &IF defined(bf_mat_uni_estab) &THEN
        run rep/re9995.p (rowid(docum-est),
                          IF de-qtd-max-perc < de-qtd-max-lim THEN
                             de-qtd-max-perc
                          ELSE
                              de-var-max-lim,
                          input frame {&frame-name} item-doc-est.quantidade,
                          19,
                          NOT l-erro,
                          i-sequencia,
                          2).

/*                           not ((input frame {&frame-name} item-doc-est.quantidade > de-qtd-max-perc)     */
/*                                OR (input frame {&frame-name} item-doc-est.quantidade > de-qtd-max-lim)), */


    &ELSE
        run rep/re9995.p (rowid(docum-est),
                          de-qtd-max,
                          input frame {&frame-name} item-doc-est.quantidade,
                          19,
                          not (input frame {&frame-name} item-doc-est.quantidade > de-qtd-max),
                          i-sequencia,
                          2).
    &ENDIF  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebimento V-table-Win 
PROCEDURE pi-recebimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign l-consiste-item = yes
           l-pede-pedordem = (l-pede-compra). 

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

    assign item-doc-est.preco-total-me:screen-value in frame {&frame-name} = 
                        string(fn_vld_ajust_dec(input frame {&frame-name} item-doc-est.preco-total-me, i-moeda)).
    assign item-doc-est.desconto-me:screen-value in frame {&frame-name} = 
                        string(fn_vld_ajust_dec(input frame {&frame-name} item-doc-est.desconto-me, i-moeda)).


    find item where item.it-codigo = c-it-codigo no-lock no-error.


    /* logica para obtencao de valor maximo */
    {rep/re1001.i10 docum-est.cod-estabel}


    if  input frame {&frame-name} item-doc-est.num-pedido <> 0 
    or  input frame {&frame-name} item-doc-est.numero-ordem <> 0 then do:
        find ordem-compra 
            where ordem-compra.numero-ordem = input frame {&frame-name} item-doc-est.numero-ordem
            no-lock no-error.
        if  not available ordem-compra then do:
            /* mensagem: Ordem de compra n∆o cadastrada */
            {include/i-vldprg.i}
            {utp/ut-table.i mgind ordem-compra 01}
            run utp/ut-msgs.p (input "show",input 47,input return-value).
            apply 'entry' to item-doc-est.numero-ordem in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if  ordem-compra.num-pedido = 0 then do:
            /* mensagem: Ordem de compra n∆o possui pedido */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15185,input " ").
            apply 'entry' to item-doc-est.numero-ordem in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if  i-programa-re = 3 then do:
            if ordem-compra.mo-codigo <> docum-est.mo-codigo and
               docum-est.nff then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 15474,
                                   input string(ordem-compra.mo-codigo) + "~~" +
                                         string(docum-est.mo-codigo)).
                apply 'entry' to item-doc-est.numero-ordem in frame {&frame-name}.
                return 'adm-error':U.
            end.

            if  ordem-compra.mo-codigo <> docum-est.mo-codigo and 
                not docum-est.nff and avail item-doc-est then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 15475,
                                   input string(ordem-compra.mo-codigo) + "~~" +
                                         string(docum-est.mo-codigo)).
                apply 'entry' to item-doc-est.numero-ordem in frame {&frame-name}.
                return 'adm-error':U.
            end.
        end.                

        find pedido-compr 
            where pedido-compr.num-pedido = input frame {&frame-name} item-doc-est.num-pedido
            no-lock no-error.
        if  not available pedido-compr then do:
            /* mensagem: Pedido de compra n∆o cadastrado */
            {include/i-vldprg.i}
            {utp/ut-table.i mgind pedido-compr 01}
            run utp/ut-msgs.p (input "show",input 47,input return-value).
            apply 'entry' to item-doc-est.num-pedido in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if  pedido-compr.situacao = 3 then do:
            /* mensagem: Pedido de compra eliminado */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 7169,input " ").
            apply 'entry' to item-doc-est.num-pedido in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if adm-new-record and pedido-compr.end-entrega <> docum-est.cod-estabel then do:
            /* mensagem: Estabelecimento de entrega do pedido Ç diferente do estabelecimento do documento. Confirma? */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 6814,input " ").
            if return-value <> "yes" then do:                               
                apply 'entry' to item-doc-est.num-pedido in frame {&frame-name}.
                return 'adm-error':U.
            end.
        end.                
        if adm-new-record and pedido-compr.cod-emitente <> docum-est.cod-emitente then do:
            /* mensagem: Pedido de compra n∆o pertence ao fornecedor do documento. Confirma? */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15186,input " ").
            if return-value <> "yes" then do:                               
                apply 'entry' to item-doc-est.num-pedido in frame {&frame-name}.
                return 'adm-error':U.
            end.
        end.

        if input frame {&frame-name} item-doc-est.num-pedido <> ordem-compra.num-pedido then do:
            /* mensagem: Ordem de compra n∆o pertence ao pedido */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 7342,input " ").
            apply 'entry' to item-doc-est.numero-ordem in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if  c-it-codigo <> ordem-compra.it-codigo then do:
            /* mensagem: Item da ordem n∆o confere com item da nota fiscal */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15187,input " ").
            apply 'entry' to item-doc-est.numero-ordem in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if adm-new-record and ordem-compra.situacao <> 2 then do:
            /* mensagem: Situaá∆o da ordem n∆o permite movimentaá∆o */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15188,input " ").
            apply 'entry' to item-doc-est.numero-ordem in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if  ordem-compra.situacao = 2 
        and param-compra.pend-aprov = 2 and
            ordem-compra.pend-aprov = 2 then do:
            /* mensagem: Ordem de compra pendente de aprovaá∆o. N∆o pode ser recebida */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 8813,input " ").
            apply 'entry' to item-doc-est.numero-ordem in frame {&frame-name}.
            return 'adm-error':U.
        end.

        find prazo-compra 
            where prazo-compra.numero-ordem = input frame {&frame-name} item-doc-est.numero-ordem 
              and prazo-compra.parcela      = input frame {&frame-name} item-doc-est.parcela
            no-lock no-error.
        if  not available prazo-compra then do:
            /* mensagem: Parcela n∆o cadastrada */
            {include/i-vldprg.i}
            {utp/ut-table.i mgind prazo-compra 01}
            run utp/ut-msgs.p (input "show",input 47,input return-value).
            apply 'entry' to item-doc-est.parcela in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if adm-new-record and prazo-compra.situacao <> 2 then do:
            /* mensagem: Situaá∆o da parcela n∆o permite movimentá∆o */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 6897,input " ").
            apply 'entry' to item-doc-est.parcela in frame {&frame-name}.
            return 'adm-error':U.
        end.
        &if defined(bf_mat_contratos) &then
        if  avail ordem-compra and ordem-compra.nr-contrato <> 0
        &else
        if  avail ordem-compra and ordem-compra.nr-contrato <> " " 
        &endif
        and param-global.modulo-cn then do:
            if  not l-contrato then do:
                if  prazo-compra.data-entrega > docum-est.dt-emissao + param-re.variacao 
                or  prazo-compra.data-entrega < docum-est.dt-emissao - param-re.variacao then do:
                    /* mensagem: Data de entrega da parcela esta fora da variaá∆o. Confirma? */
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show",input 7179,input " ").
                    if return-value <> "yes" then do:                               
                        apply 'entry' to item-doc-est.parcela in frame {&frame-name}.
                        return 'adm-error':U.
                    end.
                end.
            end.
        end.
    end.                   

    if adm-new-record then do:    
        find serie where serie.serie = input frame {&frame-name} item-doc-est.serie-comp 
             no-lock no-error.
        if  not avail serie then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 5580,
                               input "").
            apply 'entry' to item-doc-est.serie-comp in frame {&frame-name}.
            return 'adm-error':U.
        end.

        find first natur-oper where 
             natur-oper.nat-operacao = input frame {&frame-name} item-doc-est.nat-comp no-lock no-error.
        if not avail natur-oper and
           input frame {&frame-name} item-doc-est.nat-comp <> "" and     
           input frame {&frame-name} item-doc-est.nat-comp <> "000" then do:
           {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 4254,
                               input "").
            apply 'entry' to item-doc-est.nat-comp in frame {&frame-name}.
            return 'adm-error':U.
        end.   

        find first b-item-doc-est where
             b-item-doc-est.cod-emitente = docum-est.cod-emitente and
             b-item-doc-est.serie-docto  = input frame {&frame-name} item-doc-est.serie-comp and
             b-item-doc-est.nro-docto    = input frame {&frame-name} item-doc-est.nro-comp and
             b-item-doc-est.nat-operacao = input frame {&frame-name} item-doc-est.nat-comp and
             b-item-doc-est.sequencia    = input frame {&frame-name} item-doc-est.seq-comp no-lock no-error.
        if avail b-item-doc-est then do:
           {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 7,
                               input fi-remito:screen-value).
            apply 'entry' to item-doc-est.nro-comp in frame {&frame-name}.
            return 'adm-error':U.       
        end.     
    end.

    &if defined(bf_mat_contratos) &then
    if  avail ordem-compra and ordem-compra.nr-contrato <> 0
    &else
    if  avail ordem-compra and ordem-compra.nr-contrato <> " " 
    &endif
    and param-global.modulo-cn then do:
        run cnp/cn9072.p (input input frame {&frame-name} item-doc-est.numero-ordem,
                          input rowid(docum-est),
                          input 12,                        /* Conta-Atual   */
                          output l-conta-matriz,
                          input-output table tt-erro ).
    end.

    if  avail ordem-compra 
    and ordem-compra.mo-codigo <> i-moeda 
    and docum-est.nff then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",
                           input 15474,
                           input string(ordem-compra.mo-codigo) + "~~" +
                                 string(docum-est.mo-codigo)).
        apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
        return 'adm-error':U.
    end.

    if  avail ordem-compra 
    and ordem-compra.mo-codigo <> i-moeda 
    and not docum-est.nff then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",
                           input 15475,
                           input string(ordem-compra.mo-codigo) + "~~" +
                                 string(docum-est.mo-codigo)).
        apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
        return 'adm-error':U.
    end.
    if de-cotacao:sensitive in frame {&FRAME-NAME} 
       and (not avail cotacao 
            or docum-est.mo-codigo <> 0 and
               input frame {&frame-name} de-cotacao = 0) then do:
        find moeda where moeda.mo-codigo   = i-moeda no-lock no-error.
        {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show":U, input 316, input moeda.descricao + "~~" + string(docum-est.dt-emissao)).
        apply "entry" to de-cotacao in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.





    find first tt-erro 
        no-lock no-error.
    if  available tt-erro  then do:

        /* mensagem: Erro da tt-erro */
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",input tt-erro.cd-erro,input " ").

        if  tt-erro.cd-erro <> 15221 then do:
            apply 'entry' to item-doc-est.num-pedido in frame {&frame-name}.
            for each tt-erro:
                delete tt-erro.
            end.
            return 'adm-error':U. 
        end.
        else do:        
            for each tt-erro:
                delete tt-erro.
            end.
        end.
    end.     

/*****/
    run pi-continua-validate.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-variacao-valor V-table-Win 
PROCEDURE pi-variacao-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input  param de-valor-orig   like it-doc-fisico.preco-total[1].
&IF defined(bf_mat_uni_estab) &THEN
    def output param de-var-max-perc like it-doc-fisico.preco-total[1].
    DEF OUTPUT PARAM de-var-max-lim  LIKE it-doc-fisico.preco-total[1].
&ELSE
    DEF OUTPUT PARAM de-var-max  LIKE it-doc-fisico.preco-total[1].
&ENDIF
def output param de-valor-min    like it-doc-fisico.preco-total[1].

if param-re.aceita-var then DO:

    &IF defined(bf_mat_uni_estab) &THEN
        ASSIGN de-var-max-perc = round(de-valor-orig +
                                      (de-valor-orig * de-var-val-re-maior / 100), 2)
               de-valor-min    = round(de-valor-orig -
                                      (de-valor-orig * de-var-val-re-maior / 100), 2).

        ASSIGN de-var-max-lim = de-valor-orig + de-lim-var-valor.

    &ELSE
        ASSIGN de-var-max   = round(de-valor-orig +
                                   (de-valor-orig * de-var-val-re-maior / 100), 2)
               de-valor-min = round(de-valor-orig -
                                   (de-valor-orig * de-var-val-re-maior / 100), 2).

    &ENDIF

END.
else
    assign &IF defined(bf_mat_uni_estab) &THEN
               de-var-max-perc = de-valor-orig
               de-var-max-lim  = de-valor-orig
           &ELSE
               de-var-max = de-valor-orig
           &ENDIF
           de-var-min      = de-valor-orig.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-cotacao V-table-Win 
PROCEDURE pi-verifica-cotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Atualiza a MOEDA no DOCUM-EST para a primeira entrada de item */
    find first b-item-doc-est {cdp/cd8900.i b-item-doc-est docum-est} no-lock no-error.
    if not available b-item-doc-est 
    and docum-est.mo-codigo = 0 
    and docum-est.nff = no then do:
        assign i-moeda = if available ordem-compra 
                                   then ordem-compra.mo-codigo
                                   else 0.
        if  available ordem-compra then do with frame {&FRAME-NAME}:

            if  ordem-compra.mo-codigo <> 0 and not docum-est.nff and 
                ordem-compra.mo-codigo = i-moeda then do:
                find first cotacao 
                     where cotacao.mo-codigo = i-moeda
                     and   cotacao.ano-periodo = string(year (docum-est.dt-emissao),'9999')
                                              +  string(month(docum-est.dt-emissao),'99') no-lock no-error.
                assign de-cotacao:screen-value = if available cotacao then
                                                 string(cotacao.cotacao[day(docum-est.dt-emissao)])
                                                        else "0"
                       de-cotacao:sensitive    = yes.
            end.
        end.
    end.        

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
  {src/adm/template/snd-list.i "item-doc-est"}

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

