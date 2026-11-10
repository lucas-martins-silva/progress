&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V15IN112 2.00.00.062 } /*** "010062" 22/08/2025 10:45:01  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v15in112 MUT}
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
{cdp/cd9731.i1}      /* l-integra-cn-in-medicao                */
{cdp/cd9731.i2}      /* l-matriz-medicao - parametros contrato */
{inp/inapi402.i}     /* tt-mat-rat-med-inv                     */
{method/dbotterr.i}  /* rowerrors                              */
{cdp/cd0666.i}       /* Definiá∆o da tt-erro                   */

/* Multiplanta */
def var l-erro as logical no-undo.
def var i-tipo-movto as integer no-undo.
def var c-msg as char no-undo.
/* ----------- */

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var l-contrato         as logical                     no-undo.
def var h_v16in112         as handle                      no-undo.
def var h_v17in112         as handle                      no-undo.

def var de-total-qtd     as dec format "->>>>,>>>,>>9.9999" NO-UNDO.
def var de-fi-qtd-prevista as dec format "->>>>>,>>>,>>9.9999" NO-UNDO.
def var de-qtd-ordem     like de-total-qtd NO-UNDO.
def var de-total-val     like evento-ped.val-previsto NO-UNDO.
def var de-val-ordem     like de-total-val NO-UNDO.
def var i-seq-evento     as int                           no-undo.
def var i-ordem          like ordem-compra.numero-ordem   no-undo.
def var i-ord-ant        like ordem-compra.numero-ordem   init ? no-undo.
DEF VAR l-eliminado      AS LOGICAL                       NO-UNDO.

DEF BUFFER b-evento-ped  FOR evento-ped.
DEF BUFFER b1-evento-ped FOR evento-ped.

def new global shared var gr-evento-ped as rowid no-undo.
def new global shared var g-nr-contrato like evento-ped.nr-contrato no-undo.
def new global shared var gr-it-codigo  like item.it-codigo no-undo.
def new global shared var c-nr-contrato like item-contrat.nr-contrato no-undo.

def var l-apply-tab as logical init no no-undo.

def var l-erro-co  as logical init NO NO-UNDO.
def var l-msg-tela as logical         NO-UNDO. 

def new shared var c-cod-estabel like estabelec.cod-estabel.

/**  Caraiba
**/
def var l-permissao   as logical no-undo.
def var c-permissao-1 as char    no-undo.
def var c-permissao-2 as char    no-undo.
def buffer b-usuar-mater for usuar-mater.
def var l-erro-prov as logical no-undo.
/*****/

/* Vari†veis para PTI-Status*/
&if defined (bf_mat_bloqueio_fornec) &then
    def var h-api029       as handle no-undo.
    def var i-situacao     as int    no-undo.  
    def var dt-vig-ini     as date   no-undo.  
    def var dt-vig-fim     as date   no-undo.  
    def var i-emitente     as int    no-undo.
    def var c-return       as char   no-undo.

    def temp-table tt-erro-2 no-undo
        field i-sequen as int             
        field cd-erro  as int
        field mensagem as char format "x(255)"
        field c-param  as char.

&endif


define  temp-table tt-erro-aed no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)"
    field c-param  as char.


/* Integracao Contratos - declaracao temp-tables */
{cnp/cnapi020.i3}

DEF VAR i-ord-manut AS INTEGER NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES evento-ped
&Scoped-define FIRST-EXTERNAL-TABLE evento-ped


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR evento-ped.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS evento-ped.log-1 
&Scoped-define ENABLED-TABLES evento-ped
&Scoped-define FIRST-ENABLED-TABLE evento-ped
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS evento-ped.numero-ordem ~
evento-ped.seq-evento evento-ped.cod-estabel evento-ped.num-seq-item ~
evento-ped.log-1 
&Scoped-define DISPLAYED-TABLES evento-ped
&Scoped-define FIRST-DISPLAYED-TABLE evento-ped
&Scoped-Define DISPLAYED-OBJECTS i-contrato c-des-contrato c-estabelec ~
c-it-codigo c-item c-des-event c-label-item 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS evento-ped.numero-ordem i-contrato ~
c-des-event 
&Scoped-define ADM-ASSIGN-FIELDS evento-ped.numero-ordem ~
evento-ped.seq-evento i-contrato evento-ped.cod-estabel ~
evento-ped.num-seq-item c-it-codigo c-des-event 
&Scoped-define ADM-MODIFY-FIELDS c-des-event 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
numero-ordem|||movind.evento-ped.numero-ordem
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-numero-ordem 
       MENU-ITEM m_Ordem_de_Compra LABEL "Zoom Ordem de Compra - F5"
       MENU-ITEM m_Zoom_Ordem_com_Contrato_-_F LABEL "Zoom Ordem com Contrato - F7".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-des-contrato AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-event AS CHARACTER FORMAT "x(76)" 
     LABEL "Descriá∆o_":R11 
     VIEW-AS FILL-IN 
     SIZE 66.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-estabelec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "x(16)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-item AS CHARACTER FORMAT "x(6)" 
      VIEW-AS TEXT 
     SIZE 3.72 BY .67 NO-UNDO.

DEFINE VARIABLE i-contrato AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 5.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     evento-ped.numero-ordem AT ROW 1.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     evento-ped.seq-evento AT ROW 1.17 COL 82.43 COLON-ALIGNED
          LABEL "Sequància do Evento":R4
          VIEW-AS FILL-IN 
          SIZE 4.43 BY .88
     i-contrato AT ROW 2.17 COL 19 COLON-ALIGNED
     c-des-contrato AT ROW 2.17 COL 28.72 COLON-ALIGNED NO-LABEL
     evento-ped.cod-estabel AT ROW 3.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-estabelec AT ROW 3.17 COL 26.57 COLON-ALIGNED NO-LABEL
     evento-ped.num-seq-item AT ROW 4.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-it-codigo AT ROW 4.17 COL 27.43 COLON-ALIGNED HELP
          "C¢digo do Item" NO-LABEL
     c-item AT ROW 4.17 COL 41.72 COLON-ALIGNED NO-LABEL
     c-des-event AT ROW 5.17 COL 8.86
     evento-ped.log-1 AT ROW 5.5 COL 1.43
          VIEW-AS TOGGLE-BOX
          SIZE 2.29 BY .67
     c-label-item AT ROW 4.29 COL 19.72 RIGHT-ALIGNED HELP
          "C¢digo do Item" NO-LABEL
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.evento-ped
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
         HEIGHT             = 5.38
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-des-contrato IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-event IN FRAME f-main
   NO-ENABLE ALIGN-L 1 2 3                                              */
/* SETTINGS FOR FILL-IN c-estabelec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN c-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-item IN FRAME f-main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN evento-ped.cod-estabel IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN i-contrato IN FRAME f-main
   NO-ENABLE 1 2                                                        */
ASSIGN 
       evento-ped.log-1:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN evento-ped.num-seq-item IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN evento-ped.numero-ordem IN FRAME f-main
   NO-ENABLE 1 2                                                        */
ASSIGN 
       evento-ped.numero-ordem:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-numero-ordem:HANDLE.

/* SETTINGS FOR FILL-IN evento-ped.seq-evento IN FRAME f-main
   NO-ENABLE 2 EXP-LABEL                                                */
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

&Scoped-define SELF-NAME c-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo V-table-Win
ON F5 OF c-it-codigo IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z02in172.w
                     &campo=c-it-codigo
                     &campozoom=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo V-table-Win
ON LEAVE OF c-it-codigo IN FRAME f-main
DO:
  FIND ITEM WHERE ITEM.it-codigo = INPUT FRAME {&frame-name} c-it-codigo NO-LOCK NO-ERROR.
  IF  AVAIL ITEM THEN
      ASSIGN c-item = ITEM.desc-item.
  ELSE
      ASSIGN c-item = "".
  DISP c-item WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-it-codigo IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME evento-ped.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.cod-estabel V-table-Win
ON F5 OF evento-ped.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:

  assign l-implanta = yes 
         &if defined(bf_mat_contratos) &then
         c-nr-contrato = input frame {&frame-name} i-contrato.
         &else
         c-nr-contrato = string(input frame {&frame-name} i-contrato).
         &endif
  {include/zoomvar.i &prog-zoom=adzoom/z03ad107.w
                     &campo=evento-ped.cod-estabel
                     &campozoom=cod-estabel}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.cod-estabel V-table-Win
ON LEAVE OF evento-ped.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
{include/leave.i &tabela=estabelec
                 &atributo-ref=nome
                 &variavel-ref=c-estabelec
                 &where="estabelec.cod-estabel =
                         input frame {&frame-name} evento-ped.cod-estabel"}

if not avail estabelec then do:
    {utp/ut-table.i mgadm estabelec 1}
    run utp/ut-msgs.p ("msg",47,trim(return-value)).
    disp trim(return-value) @ c-estabelec with frame {&frame-name}.
end.

&if defined(bf_mat_contratos) &then
run pi-atualiza-dados in h_v17in112 (input frame {&frame-name} i-contrato).
run pi-atualiza-dados in h_v16in112 (input frame {&frame-name} i-contrato,
                                     input frame {&frame-name} evento-ped.cod-estabel,
                                     input frame {&frame-name} evento-ped.numero-ordem). 
run pi-passa-item in h_v16in112 (input input frame {&frame-name} evento-ped.num-seq-item).
&else
run pi-atualiza-dados in h_v17in112 (string(input frame {&frame-name} i-contrato)).
run pi-atualiza-dados in h_v16in112 (string(input frame {&frame-name} i-contrato),
                                     input frame {&frame-name} evento-ped.cod-estabel,
                                     input frame {&frame-name} evento-ped.numero-ordem). 
run pi-passa-item in h_v16in112 (input input frame {&frame-name} evento-ped.num-seq-item).
&endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF evento-ped.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-contrato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-contrato V-table-Win
ON F5 OF i-contrato IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in065.w
                     &campo=i-contrato
                     &campozoom=nr-contrato}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-contrato V-table-Win
ON LEAVE OF i-contrato IN FRAME f-main
DO:

&if defined(bf_mat_contratos) &then
{include/leave.i &tabela=contrato-for
                  &atributo-ref=des-contrat
                  &variavel-ref=c-des-contrato
                  &where="contrato-for.nr-contrato =
                          input frame {&frame-name} i-contrato"}
&else
{include/leave.i &tabela=contrato-for
                  &atributo-ref=des-contrat
                  &variavel-ref=c-des-contrato
                  &where="contrato-for.nr-contrato =
                          string(input frame {&frame-name} i-contrato)"}
&endif

&if defined(bf_mat_contratos) &then
if input frame {&frame-name} i-contrato <> 0 and
&else
if input frame {&frame-name} i-contrato <> "" and
&endif
   input frame {&frame-name} i-contrato <> ?  and 
   not avail contrato-for  then do:
    {utp/ut-liter.i Contrato * c} 
    run utp/ut-msgs.p("msg",47,trim(return-value)).
    disp trim(return-value) @ c-des-contrato with frame {&frame-name}.
end.

run pi-ordem.
IF  adm-new-record then
    run pi-numera-evento.

/* run notify ('pi-recebe-item, group-assign-target'). */

do with frame {&frame-name}:    
    &if defined(bf_mat_contratos) &then
    assign l-contrato = can-find (contrato-for where contrato-for.nr-contrato = input i-contrato) 
    &else
    assign l-contrato = can-find (contrato-for where contrato-for.nr-contrato = string(input i-contrato)) 
    &endif
           input i-contrato
           evento-ped.cod-estabel:sensitive  = l-contrato 
           evento-ped.num-seq-item:sensitive = l-contrato .

    run pi-troca-campos.

    &if defined(bf_mat_contratos) &then
    run pi-atualiza-dados in h_v17in112 (i-contrato).
    run pi-atualiza-dados in h_v16in112 (i-contrato,
                                         input input evento-ped.cod-estabel,
                                         input input evento-ped.numero-ordem). 
    run pi-passa-item in h_v16in112 (input input frame {&frame-name} evento-ped.num-seq-item).
    &else
    run pi-atualiza-dados in h_v17in112 (string(i-contrato)).
    run pi-atualiza-dados in h_v16in112 (string(i-contrato),
                                         input input evento-ped.cod-estabel,
                                         input input evento-ped.numero-ordem).     
    run pi-passa-item in h_v16in112 (input input frame {&frame-name} evento-ped.num-seq-item).
    &endif

    if l-apply-tab = yes then do:
        if l-contrato 
        then apply "entry" to evento-ped.cod-estabel.
        else apply "entry" to c-it-codigo.
        return no-apply.
    end.
end.

l-apply-tab = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-contrato V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-contrato IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-contrato V-table-Win
ON TAB OF i-contrato IN FRAME f-main
DO:
  l-apply-tab = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Ordem_de_Compra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Ordem_de_Compra V-table-Win
ON CHOOSE OF MENU-ITEM m_Ordem_de_Compra /* Zoom Ordem de Compra - F5 */
DO:
    run pi-zoom-ordem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Zoom_Ordem_com_Contrato_-_F
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Zoom_Ordem_com_Contrato_-_F V-table-Win
ON CHOOSE OF MENU-ITEM m_Zoom_Ordem_com_Contrato_-_F /* Zoom Ordem com Contrato - F7 */
DO:
  run pi-zoom-ordem-contrato.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME evento-ped.num-seq-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.num-seq-item V-table-Win
ON F5 OF evento-ped.num-seq-item IN FRAME f-main /* SeqÅància Item */
DO:
  assign l-implanta = yes.
  &if defined(bf_mat_contratos) &then
  assign g-nr-contrato = input frame {&frame-name} i-contrato.
  &else
  assign g-nr-contrato = string(input frame {&frame-name} i-contrato).
  &endif
  {include/zoomvar.i &prog-zoom=inzoom/z02in582.w
                     &campo=evento-ped.num-seq-item
                     &campozoom=num-seq-item}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.num-seq-item V-table-Win
ON LEAVE OF evento-ped.num-seq-item IN FRAME f-main /* SeqÅància Item */
DO:
&if defined(bf_mat_contratos) &then
{include/leave.i &tabela=item-contrat
                 &atributo-ref=num-seq-item
                 &variavel-ref=c-item
                 &where="item-contrat.num-seq-item = input frame {&frame-name} evento-ped.num-seq-item 
                         and item-contrat.nr-contrato = i-contrato"}
&else
{include/leave.i &tabela=item-contrat
                 &atributo-ref=num-seq-item
                 &variavel-ref=c-item
                 &where="item-contrat.num-seq-item = input frame {&frame-name} evento-ped.num-seq-item 
                         and item-contrat.nr-contrato = string(i-contrato)"}
&endif

if avail item-contrat then do with frame {&frame-name}:
    find item where item.it-codigo = item-contrat.it-codigo 
        no-lock no-error.
    assign gr-it-codigo = item-contrat.it-codigo.

    if  available item then 
        display item.desc-item @ c-item
                item.it-codigo @ c-it-codigo.
    else do:
        {utp/ut-table.i mgind item 1}
        run utp/ut-msgs.p ("msg",47,trim(return-value)).
        disp trim(return-value) @ c-item
             item-contrat.it-codigo @ c-it-codigo.
    end.
end.
else do with frame {&frame-name}:
    {utp/ut-field.i mgind item-contrat num-seq-item 1}
    run utp/ut-msgs.p ("msg",47,trim(return-value)).
    assign c-it-codigo:screen-value = ""
           c-item:screen-value = trim(return-value).
end.

run pi-atualiza-dados in h_v17in112 (input string(INPUT FRAME {&FRAME-NAME} i-contrato)).
run pi-passa-item in h_v16in112 (input input frame {&frame-name} evento-ped.num-seq-item).
run pi-ordem.

IF  adm-new-record then
    run pi-numera-evento.
                                                                                         
IF  AVAIL ordem-compra THEN DO:
    DISP ordem-compra.it-codigo @ c-it-codigo WITH FRAME {&frame-name}.
    APPLY "leave":U TO c-it-codigo IN FRAME {&FRAME-NAME}.
END.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.num-seq-item V-table-Win
ON MOUSE-SELECT-DBLCLICK OF evento-ped.num-seq-item IN FRAME f-main /* SeqÅància Item */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME evento-ped.numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.numero-ordem V-table-Win
ON F5 OF evento-ped.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:
  run pi-zoom-ordem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.numero-ordem V-table-Win
ON F7 OF evento-ped.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:
  run pi-zoom-ordem-contrato.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.numero-ordem V-table-Win
ON LEAVE OF evento-ped.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:

do with frame {&frame-name}:
    if  evento-ped.numero-ordem:modified then do:
        find ordem-compra 
            where ordem-compra.numero-ordem = input evento-ped.numero-ordem
            no-lock no-error.

        if  avail ordem-compra then do:    
            assign evento-ped.cod-estabel:screen-value = string(ordem-compra.cod-estabel)
                   i-contrato:screen-value = string(ordem-compra.nr-contrato)
                   evento-ped.num-seq-item:screen-value = string(ordem-compra.num-seq-item)
                   c-it-codigo:screen-value = string(ordem-compra.it-codigo).

            apply 'leave' to i-contrato.

            &if defined(bf_mat_contratos) &then
            if  ordem-compra.nr-contrato <> 0 then
            &else
            if  ordem-compra.nr-contrato <> "" then 
            &endif
                apply 'leave' to evento-ped.num-seq-item.
            else do:
                find item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
                if avail item then
                    disp item.desc-item     @ c-item.
                else do: 
                    {utp/ut-table.i mgind item 1}
                    run utp/ut-msgs.p ("msg",47,trim(return-value)).
                    disp trim(return-value) @ c-item.
                end.
            end.
            &if defined(bf_mat_contratos) &then
            assign i-contrato:sensitive = ordem-compra.nr-contrato <> 0.
            &else
            assign i-contrato:sensitive = ordem-compra.nr-contrato <> "".
            &endif
        end.
    end.
    else do:
        find ordem-compra 
            where ordem-compra.numero-ordem = input evento-ped.numero-ordem
            no-lock no-error.
        if avail ordem-compra then do:

            IF  adm-new-record then
                run pi-numera-evento.

            &if defined(bf_mat_contratos) &then
            run pi-atualiza-dados in h_v17in112 (input i-contrato).
            run pi-atualiza-dados in h_v16in112 (input i-contrato,
                                                 input input evento-ped.cod-estabel,
                                                 input input evento-ped.numero-ordem). 
            run pi-passa-item in h_v16in112 (input input frame {&frame-name} evento-ped.num-seq-item).
            &else
            run pi-atualiza-dados in h_v17in112 (string(input i-contrato)).
            run pi-atualiza-dados in h_v16in112 (string(input i-contrato),
                                                 input input evento-ped.cod-estabel,
                                                 input input evento-ped.numero-ordem). 
            run pi-passa-item in h_v16in112 (input input frame {&frame-name} evento-ped.num-seq-item).
            &endif
        end.
    end.

    assign evento-ped.numero-ordem:modified = no.

    IF  AVAIL ordem-compra THEN DO:
        DISP ordem-compra.it-codigo @ c-it-codigo WITH FRAME {&frame-name}.
        APPLY "leave":U TO c-it-codigo IN FRAME {&FRAME-NAME}.
    END.

end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.numero-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF evento-ped.numero-ordem IN FRAME f-main /* Ordem Compra */
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

if i-contrato:load-mouse-pointer ("Image~/lupa.cur") in frame {&frame-name} then.
if evento-ped.numero-ordem:load-mouse-pointer ("Image~/rbm.cur") in frame {&frame-name} then.
if evento-ped.cod-estabel:load-mouse-pointer ("Image~/lupa.cur") in frame {&frame-name} then.
if evento-ped.num-seq-item:load-mouse-pointer ("Image~/lupa.cur") in frame {&frame-name} then.
if c-it-codigo:load-mouse-pointer ("Image~/lupa.cur") in frame {&frame-name} then.

{utp~/ut-field.i mgind evento-ped nr-contrato 1}
assign i-contrato:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Item: * r}
assign c-label-item = trim(return-value).

{utp~/ut-liter.i Descriá∆o}
assign c-des-event:label in frame {&frame-name} = trim(return-value).

{utp~/ut-liter.i Sequància_do_evento}
assign evento-ped.seq-evento:label in frame {&frame-name} = trim(return-value).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "evento-ped"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "evento-ped"}

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

  assign l-contrato = no.
  run pi-troca-campos.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

if  not avail param-global then
    find first param-global no-lock no-error.

    /* Code placed here will execute PRIOR to standard behavior. */

    /**  Caraiba
    **/
    run cdp/cdapi181.p ( input  c-seg-usuario,
                         input  4,
                         input  (if adm-new-record then 1 else 2),
                         output l-permissao).
    if not l-permissao then do:
        if adm-new-record then do:
            {utp/ut-liter.i Cadastrar * r}
            assign c-permissao-1 = trim(return-value).
        end.
        else do:
            {utp/ut-liter.i Modificar * r}
            assign c-permissao-1 = trim(return-value).
        end.
        {utp/ut-liter.i Eventos * r}
        assign c-permissao-2 = trim(return-value).
        run utp/ut-msgs.p (input "show"      ,
                           input 18728       ,
                           input c-permissao-1 + "~~" + c-permissao-2).
        return "adm-error".    
    end.

    find contrato-for where
        string(contrato-for.nr-contrato) = string(input frame {&frame-name} i-contrato)
        no-lock no-error.
    find usuar-mater where
        usuar-mater.cod-usuar = c-seg-usuario
        no-lock no-error.
    find b-usuar-mater where
        b-usuar-mater.cod-usuar = contrato-for.gestor-tecnico
        no-lock no-error.           

    if usuar-mater.cont-acesso-cc and
       AVAIL b-usuar-mater AND
        usuar-mater.sc-codigo <> b-usuar-mater.sc-codigo then do:
        if adm-new-record then do:
            {utp/ut-liter.i Incluir_Eventos * r}
            assign c-permissao-1 = trim(return-value).
        end.
        else do:
            {utp/ut-liter.i Modificar_Eventos * r}
            assign c-permissao-1 = trim(return-value).
        end.                
        {utp/ut-liter.i de_outro_Centro_de_Custo * r}
        assign c-permissao-2 = trim(return-value).
        run utp/ut-msgs.p (input "show"      ,
                           input 18728       ,
                           input c-permissao-1 + "~~" + c-permissao-2).
        return "adm-error".    
    end.

    if avail b-usuar-mater and usuar-mater.perm-alt-cont = no and
        usuar-mater.cod-usuario <> b-usuar-mater.cod-usuario then do:
        if adm-new-record then do:
            {utp/ut-liter.i Incluir_Eventos * r}
            assign c-permissao-1 = trim(return-value).
        end.
        else do:
            {utp/ut-liter.i Modificar_Eventos * r}
            assign c-permissao-1 = trim(return-value).
        end.                
        {utp/ut-liter.i de_outro_Usu†rio * r}
        assign c-permissao-2 = trim(return-value).
        run utp/ut-msgs.p (input "show"      ,
                           input 18728       ,
                           input c-permissao-1 + "~~" + c-permissao-2).
        return "adm-error".    
    end.
    /*****/

    {include/i-valid.i}

    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    &if defined(bf_mat_contratos) &then
    if  avail evento-ped and 
        not adm-new-record then do:
        find ordem-compra where 
             ordem-compra.numero-ordem = input frame {&frame-name} evento-ped.numero-ordem no-lock no-error.
        if  avail ordem-compra then do:
            run ccp/ccapi199.p (input "ordem-compra", input rowid(ordem-compra),
                                output l-erro).
            if  l-erro then do:
                /*Evento so pode ser alterado no estabelecimento executor.*/
                {utp/ut-liter.i Evento}
                assign c-msg = trim(return-value).
                {utp/ut-liter.i Executor}
                run utp/ut-msgs.p("show",18200,c-msg + "~~" + trim(return-value)).            
                return "adm-error".
            end.
        end.
    end.
    &endif

    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
    IF adm-new-record = YES THEN DO:
       FIND FIRST b-evento-ped 
            WHERE b-evento-ped.numero-ordem = INPUT FRAME {&FRAME-NAME} evento-ped.numero-ordem 
              AND b-evento-ped.seq-evento   = INPUT FRAME {&FRAME-NAME} evento-ped.seq-evento NO-LOCK NO-ERROR.
       IF AVAIL b-evento-ped THEN DO:
          {utp/ut-liter.i Evento_(Ordem_Compra,_Seq._Item) * R}
          run utp/ut-msgs.p("show",1,trim(return-value)).
          apply 'entry' to evento-ped.numero-ordem IN FRAME {&FRAME-NAME}.
          return "adm-error".  
       END.
    END.
    &ENDIF

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

    if avail evento-ped then do:
        find ordem-compra where ordem-compra.numero-ordem = evento-ped.numero-ordem
            no-lock no-error.
        assign evento-ped.des-event = input frame {&frame-name} c-des-event
               evento-ped.it-codigo = if avail ordem-compra then ordem-compra.it-codigo else ""
               evento-ped.ind-sit-event = if evento-ped.ind-sit-event = 0 then 1 
                                          else evento-ped.ind-sit-event.
    end.


    if  param-global.modulo-in and
        avail ordem-compra and ordem-compra.num-ord-inv <> 0 then
        run inp/in2105.p(input rowid(evento-ped), input (if  adm-new-record then "inclui" else "modifica")).

    &if defined(bf_mat_contratos) &then
    if  avail evento-ped and
        param-global.modulo-mp then do:
        assign i-tipo-movto = if adm-new-record then 1 else 2.
        run ccp/ccapi200.p (input "evento-ped":u, input rowid(evento-ped),
                            input i-tipo-movto, input-output table tt-erro).
    end.
    &endif

/**  Caraiba    **/

/*&if '{&mguni_version}' < "2.03" &then
  *    if can-find(funcao no-lock where funcao.cd-funcao = "implementacao_caraiba") then do:*/

    find first param-contrat
        no-lock no-error.
/*    if substring(param-contrat.char-2,1,1) = "1" then do:      
 *         if  avail evento-ped then
 *             if not adm-new-record then
 *                 run cnp/cn0080.p (input rowid(evento-ped),
 *                                   input "Alt Prev Ev",
 *                                   input-output table tt-bo-erro).
 *             else
 *                 run cnp/cn0080.p (input rowid(evento-ped),
 *                                   input "Prev Ev",
 *                                   input-output table tt-bo-erro).
 *     end.                           */

/*   end. 
&endif*/

/****************/        

    /**  Caraiba
    **/
    /*find first param-aprov
        no-lock no-error.
    if param-aprov.aprova-event then do:
        run cdp/cdapi171.p (11, 2, rowid(evento-ped)).
    end.*/
    /*****/

    /**  AED **/
    
    if can-find(funcao where
                funcao.cd-funcao = "Integra_AED_EMS" and
                funcao.ativo     = yes) then do:
       
        FIND FIRST contrato-for WHERE 
            contrato-for.nr-contrato = evento-ped.nr-contrato NO-LOCK NO-ERROR.        
       
        if  avail contrato-for then do:
            run aedp/aedapi173.p (input 11,
                                  input input frame {&frame-name} c-it-codigo,
                                  input contrato-for.gestor-tecnico,
                                  input contrato-for.cod-emitente,
                                  input contrato-for.cod-emitente,
                                  input "",
                                  input evento-ped.val-previsto,
                                  input evento-ped.val-previsto,
                                  input contrato-for.cod-estabel, 
                                  output table tt-erro-aed).

            if return-value = "nok":U then do:
                find first tt-erro-aed no-error.
                if avail tt-erro-aed then do:
                    run cdp/cd0669.w (input table tt-erro-aed).
                    undo, return "adm-error":U.
                end.
            end.
        end.
    end.    
    /**  MLA **/
    
    RUN lap/mlaapi099.p (INPUT 0).

    if can-find(funcao where
                funcao.cd-funcao = "Integra_MLA_EMS" and
                funcao.ativo     = yes) AND RETURN-VALUE <> "NOK":U then do:
       
        FIND FIRST contrato-for WHERE 
            contrato-for.nr-contrato = evento-ped.nr-contrato NO-LOCK NO-ERROR.        
       
        if  avail contrato-for then do:
            run lap/mlaapi173.p (input 11,
                                  input input frame {&frame-name} c-it-codigo,
                                  input contrato-for.gestor-tecnico,
                                  input contrato-for.cod-emitente,
                                  input contrato-for.cod-emitente,
                                  input "",
                                  input evento-ped.val-previsto,
                                  input evento-ped.val-previsto,
                                  input contrato-for.cod-estabel, 
                                  output table tt-erro-aed).

            if return-value = "nok":U then do:
                find first tt-erro-aed no-error.
                if avail tt-erro-aed then do:
                    run cdp/cd0669.w (input table tt-erro-aed).
                    undo, return "adm-error":U.
                end.
            end.
        end.
        &if defined(bf_mat_aprova_eletronica) &then
            find first param-aprov
                no-lock no-error.
            if substring(param-aprov.char-1,2,1) = "Y" then do:
                run cdp/cdapi171.p (11, 2, rowid(evento-ped)).
            end.
        &endif
    end.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  &if defined(bf_mat_contratos) &then
  assign evento-ped.nr-contrato = input frame {&frame-name} i-contrato
  &else
  assign evento-ped.nr-contrato = string(input frame {&frame-name} i-contrato)
  &endif
         evento-ped.dt-evento   = today.

  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
    ASSIGN evento-ped.seq-evento   = input frame {&frame-name} evento-ped.seq-evento
           evento-ped.numero-ordem = ordem-compra.numero-ordem
           evento-ped.num-seq-item = IF AVAIL item-contrat THEN item-contrat.num-seq-item ELSE 0.

    RUN pi-busca-om IN h_v17in112 (OUTPUT i-ord-manut).
    &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
        ASSIGN evento-ped.nr-ord-produ = i-ord-manut.
    &ELSE
        ASSIGN evento-ped.int-1        = i-ord-manut.
    &ENDIF
  &ENDIF
  
  IF AVAIL contrato-for AND 
        &IF '{&bf_mat_versao_ems}' >= '2.07' &THEN
            (contrato-for.num-ord-inv <> 0) 
        &ELSE
            (SUBSTRING(contrato-for.char-1,1,9) <> "" OR SUBSTRING(contrato-for.char-1,1,9) <> "0") 
        &ENDIF
     THEN DO:  
        &IF '{&bf_mat_versao_ems}' >= '2.07' &THEN
            ASSIGN evento-ped.num-ord-inv = contrato-for.num-ord-inv.
        &ELSE
            ASSIGN OVERLAY(evento-ped.char-1,1,9) = SUBSTRING(contrato-for.char-1,1,9).
        &ENDIF
  END.
  ELSE DO:
      IF AVAIL item-contrat AND
            &IF '{&bf_mat_versao_ems}' >= '2.07' &THEN
                (item-contrat.num-ord-inv <> 0) 
            &ELSE
                (SUBSTRING(item-contrat.char-1,1,9) <> "" OR SUBSTRING(item-contrat.char-1,1,9) <> "0") 
            &ENDIF
         THEN DO: 
            &IF '{&bf_mat_versao_ems}' >= '2.07' &THEN
                ASSIGN evento-ped.num-ord-inv = item-contrat.num-ord-inv.
            &ELSE
                ASSIGN OVERLAY(evento-ped.char-1,1,9) = SUBSTRING(item-contrat.char-1,1,9).
            &ENDIF
         END.
  END.

  /* Matriz de rateio Eventos */
  IF  (l-rat-med OR l-rat-ord) THEN DO:
    IF  AVAIL item-contrat THEN DO:
      {cnp~/cnapi015.i}
      IF  l-chamada = YES THEN DO:
          RUN cnp/cnapi015.p (input item-contrat.nr-contrato,
                              INPUT item-contrat.num-seq-item,
                              INPUT ordem-compra.numero-ordem,
                              INPUT input frame {&frame-name} evento-ped.seq-evento,
                              OUTPUT TABLE rowErrors).
          IF  CAN-FIND(FIRST RowErrors) THEN
              UNDO, RETURN "ADM-ERROR".
      END.
    END.  
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
find first param-global no-lock no-error.

DEF VAR l-eliminado AS LOGICAL NO-UNDO.

/******
if  avail evento-ped and
    evento-ped.nr-contrato <> "" then do:

    find first medicao-contrat where 
         medicao-contrat.numero-ordem = evento-ped.numero-ordem and
         medicao-contrat.num-seq-event = evento-ped.seq-evento and
         medicao-contrat.log-rec-medicao = yes
         no-lock no-error.

    if avail medicao-contrat then do:
       /*Evento possui Recebimentos efetuados*/
       run utp/ut-msgs.p (input "show",
                          input 26046, 
                          input "").
       return "adm-error".
    end.
    if  evento-ped.ind-sit-event = 2 then do:
        if evento-ped.ind-dest-event = 2 then do:
           /*Evento ja antecipado nao pode ser eliminado*/
           run utp/ut-msgs.p (input "show",
                              input 26045, 
                              input "").
           return "adm-error".
        end.
        else do:
             /*Evento ja realizado! Confirma eliminacao?*/
             run utp/ut-msgs.p (input "show",
                                input 26044, 
                                input "").
             if return-value = "no" then 
                undo,retry.
        end.
    end.
    else do:
        /*Confirma eliminaá∆o do evento?*/ 
        {utp/ut-liter.i eliminaá∆o_do_Evento * r}        
        run utp/ut-msgs.p (input "show",
                           input 701, 
                           input return-value).
    end.
    if  return-value = "no" then
        return "adm-error".
end.
******/

/**  Caraiba
**/
run cdp/cdapi181.p ( input  c-seg-usuario,
                     input  4,
                     input  3,
                     output l-permissao).
if not l-permissao then do:
    {utp/ut-liter.i Eliminar * r}
    assign c-permissao-1 = trim(return-value).
    {utp/ut-liter.i Eventos * r}
    assign c-permissao-2 = trim(return-value).
    run utp/ut-msgs.p (input "show"      ,
                       input 18728       ,
                       input c-permissao-1 + "~~" + c-permissao-2).
    return "adm-error".    
end.

find contrato-for where
    string(contrato-for.nr-contrato) = string(input frame {&frame-name} i-contrato)
    no-lock no-error.
find usuar-mater where
    usuar-mater.cod-usuar = c-seg-usuario
    no-lock no-error.
find b-usuar-mater where
    b-usuar-mater.cod-usuar = contrato-for.gestor-tecnico
    no-lock no-error.           
if avail b-usuar-mater and usuar-mater.cont-acesso-cc and
    usuar-mater.sc-codigo <> b-usuar-mater.sc-codigo then do:
    {utp/ut-liter.i Eliminar_Eventos * r}
    assign c-permissao-1 = trim(return-value).
    {utp/ut-liter.i de_outro_Centro_de_Custo * r}
    assign c-permissao-2 = trim(return-value).
    run utp/ut-msgs.p (input "show"      ,
                       input 18728       ,
                       input c-permissao-1 + "~~" + c-permissao-2).
    return "adm-error".    
end.

if avail b-usuar-mater and usuar-mater.perm-alt-cont = no and
    usuar-mater.cod-usuario <> b-usuar-mater.cod-usuario then do:
    {utp/ut-liter.i Eliminar_Eventos * r}
    assign c-permissao-1 = trim(return-value).
    {utp/ut-liter.i de_outro_Usu†rio * r}
    assign c-permissao-2 = trim(return-value).
    run utp/ut-msgs.p (input "show"      ,
                       input 18728       ,
                       input c-permissao-1 + "~~" + c-permissao-2).
    return "adm-error".    
end.
/*****/

IF CAN-FIND( FIRST medicao-contrat 
             WHERE medicao-contrat.nr-contrato   = evento-ped.nr-contrato 
               AND medicao-contrat.num-seq-item  = evento-ped.num-seq-item 
               AND medicao-contrat.numero-ordem  = evento-ped.numero-ordem 
               AND medicao-contrat.num-seq-event = evento-ped.seq-evento 
               AND medicao-contrat.sld-rec-medicao > 0 ) THEN DO:

   run utp/ut-msgs.p (input "show" ,
                       input 26046 ,
                       input "" ).

   return "adm-error".    
END.


for each tt-erro:
    delete tt-erro.
end.

if  not avail item-contrat and
    avail evento-ped then
    find item-contrat where item-contrat.nr-contrato = evento-ped.nr-contrato and
         item-contrat.num-seq-item = evento-ped.num-seq-item no-lock no-error.


if  avail evento-ped and
    avail item-contrat and
    evento-ped.ind-sit-event <> 3 and /* 3-cancelado */
    &if defined(bf_mat_contratos) &then
    evento-ped.nr-contrato <> 0 then do:
    &else
    evento-ped.nr-contrato <> "" then do:
    &endif
    assign c-cod-estabel = evento-ped.cod-estabel.
    run cnp/cnapi003.p (input rowid(item-contrat),
                        input (evento-ped.qtd-realizada * (-1) *
                           integer(item-contrat.ind-tipo-control <> 2)),
                        input (evento-ped.val-realizado * (-1) *
                           integer(item-contrat.ind-tipo-control <> 2)),
                        input 0, /* Atualiza liberado pelas medicoes */
                        input 0, /* Atualiza liberado pelas medicoes */
                        input 0,
                        input 0,
                        input c-cod-estabel,
                        output l-msg-tela,
                        output l-erro-co,
                        input-output table tt-erro).                 
    find first tt-erro no-lock no-error. 
       if avail tt-erro then 
       run cdp/cd0666.w (input table tt-erro).                  
    if  l-erro-co then 
        undo,return "adm-error".
end.

/**  Caraiba
**/
/*find first param-aprov
    no-lock no-error.
if param-aprov.aprova-medic then do:
    run cdp/cdapi171.p (11, 2, rowid(evento-ped)).
end.*/
/*****/

if  avail evento-ped and
    param-global.modulo-in then do:

    find ordem-compra where ordem-compra.numero-ordem = evento-ped.numero-ordem
        no-lock no-error.
    if avail ordem-compra and ordem-compra.num-ord-inv <> 0 then
       run inp/in2105.p(input rowid(evento-ped), input "elimina").
end.

FOR EACH  medicao-contrat 
   WHERE medicao-contrat.nr-contrato   = evento-ped.nr-contrato 
     AND medicao-contrat.num-seq-item  = evento-ped.num-seq-item 
     AND medicao-contrat.numero-ordem  = evento-ped.numero-ordem 
     AND medicao-contrat.num-seq-event = evento-ped.seq-evento EXCLUSIVE-LOCK:

    if  evento-ped.ind-sit-event <> 3 and /* 3-cancelado */
        medicao-contrat.ind-sit-medicao = 2 then do:
            run cnp/cnapi003.p (input rowid(item-contrat),
                                input (medicao-contrat.qtd-prevista *
                                      integer(not available evento-ped) * (-1)),
                                input (medicao-contrat.val-medicao *
                                      integer(not available evento-ped) * (-1)),
                                input (medicao-contrat.qtd-prevista * (-1)),
                                input (medicao-contrat.val-medicao  * (-1)),
                                input 0,
                                input 0,
                                input c-cod-estabel,
                                output l-msg-tela,
                                output l-erro-co,
                                input-output table tt-erro).
            find first tt-erro no-lock no-error. 
            if  avail tt-erro then 
                run cdp/cd0666.w (input table tt-erro).                                         
    end.
    if  l-erro-co then 
        undo,return "adm-error".

    IF  (l-rat-med OR l-rat-ord) THEN DO:
        /* Elimina matriz de mediá∆o */
        FOR EACH matriz-rat-med EXCLUSIVE-LOCK
           WHERE matriz-rat-med.nr-contrato     = medicao-contrat.nr-contrato
             AND matriz-rat-med.num-seq-item    = medicao-contrat.num-seq-item
             AND matriz-rat-med.numero-ordem    = medicao-contrat.numero-ordem
             AND matriz-rat-med.num-seq-event   = medicao-contrat.num-seq-event
             AND matriz-rat-med.num-seq-medicao = medicao-contrat.num-seq-medicao:

            /**** MULTIPLANTA-ELIMINA ****/
            IF  NOT l-eliminado                     AND
                param-global.modulo-mp              AND
                contrato-for.cod-estab-gestor <> "" THEN DO:

                ASSIGN l-eliminado = YES.

                RUN ccp/ccapi200.p (input "matriz-rat-med":u,
                                    INPUT ROWID(matriz-rat-med),
                                    INPUT 3,
                                    INPUT-OUTPUT TABLE tt-erro).
            END.
            /*****************************/

            DELETE matriz-rat-med.
        END.
        ASSIGN l-eliminado = NO.
    END.

    IF l-integra-cn-in-medicao THEN DO:
        IF AVAIL medicao-contrat THEN DO:
                                
            &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
                IF medicao-contrat.num-ord-inv > 0 THEN DO:         
                    SESSION:SET-WAIT-STATE("GENERAL":U).
                    RUN inp/inapi403.p (INPUT 2, /*Eliminar*/
                                        INPUT ROWID(medicao-contrat),
                                        INPUT-OUTPUT TABLE RowErrors).
                    SESSION:SET-WAIT-STATE ("":U).
                END.
            &ELSE
                SESSION:SET-WAIT-STATE("GENERAL":U).
                RUN inp/inapi402.p (INPUT rowid(medicao-contrat),
                                    INPUT-OUTPUT TABLE tt-mat-rat-med-inv,
                                    INPUT-OUTPUT TABLE rowErrors,
                                    INPUT 2,    /*elimina*/
                                    INPUT YES). /*pi-acompanhar*/
                SESSION:SET-WAIT-STATE ("":U).
            &ENDIF
          
            IF CAN-FIND(FIRST RowErrors) THEN DO:
               UNDO, RETURN "ADM-ERROR".
            END.
        END.
    END.

    /* Integracao Contratos - limpa registros temp-table integraá∆o */
    {cnp/cnapi020.i4}

    /* Integracao Contratos - criar registro para eliminacao */
    {cnp/cnapi020.i1 2 3 CD0115 " " medicao-contrat medicao-contrat}

    /* Integracao Contratos - executa API integraá∆o e valida erros */  
    {cnp/cnapi020.i2 ADM-ERROR yes}

    DELETE medicao-contrat.

END.

IF  (l-rat-med OR l-rat-ord) THEN DO:
    FOR EACH  matriz-rat-med EXCLUSIVE-LOCK
        WHERE matriz-rat-med.nr-contrato     = evento-ped.nr-contrato
          AND matriz-rat-med.num-seq-item    = evento-ped.num-seq-item
          AND matriz-rat-med.numero-ordem    = evento-ped.numero-ordem
          AND matriz-rat-med.num-seq-event   = evento-ped.seq-evento
          AND matriz-rat-med.num-seq-medicao = 0:

        /**** MULTIPLANTA-ELIMINA ****/
        IF  NOT l-eliminado                     AND
            param-global.modulo-mp              AND
            contrato-for.cod-estab-gestor <> "" THEN DO:

            ASSIGN l-eliminado = YES.

            RUN ccp/ccapi200.p (input "matriz-rat-med":u,
                                INPUT ROWID(matriz-rat-med),
                                INPUT 3,
                                INPUT-OUTPUT TABLE tt-erro).
        END.
        /*****************************/

        DELETE matriz-rat-med.
    END.
    ASSIGN l-eliminado = NO.
END.

IF  param-global.modulo-mp              AND
    contrato-for.cod-estab-gestor <> "" THEN DO:
    RUN ccp/ccapi200.p (input "evento-ped":u,
                        INPUT ROWID(evento-ped),
                        INPUT 3,
                        INPUT-OUTPUT TABLE tt-erro).
END.

    /**  AED    **/
    if can-find(funcao where
                funcao.cd-funcao = "Integra_AED_EMS" and
                funcao.ativo     = yes) then do:
        FIND FIRST contrato-for WHERE 
            contrato-for.nr-contrato = evento-ped.nr-contrato NO-LOCK NO-ERROR.        
        IF  AVAIL contrato-for THEN DO:
            RUN aedp/aedapi173.p (INPUT 11,
                                  INPUT "",
                                  INPUT contrato-for.gestor-tecnico,
                                  INPUT contrato-for.cod-emitente,
                                  INPUT contrato-for.cod-emitente,
                                  INPUT "",
                                  INPUT evento-ped.val-previsto,
                                  INPUT evento-ped.val-previsto,
                                  INPUT contrato-for.cod-estabel, 
                                  output table tt-erro-aed).

            if return-value = "nok":U then do:
                find first tt-erro-aed no-error.
                if avail tt-erro-aed then do:
                    run cdp/cd0669.w (input table tt-erro-aed).
                    return "adm-error":U.
                end.
            end.
        END.
        &if defined(bf_mat_aprova_eletronica) &then
            find first param-aprov
                no-lock no-error.
            if substring(param-aprov.char-1,3,1) = "Y" then do:
                run cdp/cdapi171.p (11, 2, rowid(evento-ped)).
            end.
        &endif
    end.    
    /**  MLA    **/
    RUN lap/mlaapi099.p (INPUT 0).

    if can-find(funcao where
                funcao.cd-funcao = "Integra_MLA_EMS" and
                funcao.ativo     = yes) AND RETURN-VALUE <> "NOK":U then do:
        FIND FIRST contrato-for WHERE 
            contrato-for.nr-contrato = evento-ped.nr-contrato NO-LOCK NO-ERROR.        
        IF  AVAIL contrato-for THEN DO:
            RUN lap/mlaapi173.p (INPUT 11,
                                  INPUT "",
                                  INPUT contrato-for.gestor-tecnico,
                                  INPUT contrato-for.cod-emitente,
                                  INPUT contrato-for.cod-emitente,
                                  INPUT "",
                                  INPUT evento-ped.val-previsto,
                                  INPUT evento-ped.val-previsto,
                                  INPUT contrato-for.cod-estabel, 
                                  output table tt-erro-aed).

            if return-value = "nok":U then do:
                find first tt-erro-aed no-error.
                if avail tt-erro-aed then do:
                    run cdp/cd0669.w (input table tt-erro-aed).
                    return "adm-error":U.
                end.
            end.
        END.
        &if defined(bf_mat_aprova_eletronica) &then
            find first param-aprov
                no-lock no-error.
            if substring(param-aprov.char-1,3,1) = "Y" then do:
                run cdp/cdapi171.p (16, 3, rowid(evento-ped)).
            end.
        &endif
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

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    do with frame {&frame-name}:
        disable evento-ped.cod-estabel 
                evento-ped.num-seq-item
                c-it-codigo.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

if available evento-ped and adm-new-record = no then do:
    assign i-contrato  = int(evento-ped.nr-contrato)
           c-des-event = evento-ped.des-event.
    disp i-contrato 
         c-des-event with frame {&frame-name}.
    &if defined(bf_mat_contratos) &then
    assign l-contrato = evento-ped.nr-contrato <> 0.
    &else
    assign l-contrato = evento-ped.nr-contrato <> "".
    &endif
    run pi-troca-campos.
end.

if available evento-ped then do:
    assign i-ordem = evento-ped.numero-ordem.
    &if defined(bf_mat_contratos) &then
    find contrato-for where contrato-for.nr-contrato = input frame {&frame-name} i-contrato
    &else
    find contrato-for where contrato-for.nr-contrato = string(input frame {&frame-name} i-contrato)
    &endif
        no-lock no-error.
    if available contrato-for then do:
        assign c-des-contrato      = contrato-for.des-contrat.
        display c-des-contrato with frame {&frame-name}.
    end.

    find first ordem-compra
        where ordem-compra.numero-ordem = input frame {&frame-name} evento-ped.numero-ordem no-lock no-error.
    if  avail ordem-compra then do:

        /* Ordem de Compra com Contrato */
        if  ordem-compra.nr-contrato   <> 0 THEN DO:
            
            find first item-contrat
                 where item-contrat.num-seq-item = evento-ped.num-seq-item
                 and   item-contrat.nr-contrato  = evento-ped.nr-contrato no-lock no-error.

            if avail item-contrat then do:

                find item 
                    where item.it-codigo = item-contrat.it-codigo no-lock no-error.

                if  avail item then
                    disp item.it-codigo @ c-it-codigo 
                         item.desc-item @ c-item with frame {&frame-name}.
                
            end.
        END.
        else do: /* Ordem de Compra sem Contrato */

            find first item
                where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
            if  avail item then
                disp item.it-codigo @ c-it-codigo 
                     item.desc-item @ c-item
                     with frame {&frame-name}.
        end.

        if  not avail item then do:
            {utp/ut-table.i mgind item 1}
            run utp/ut-msgs.p (input "msg",
                               input 47,
                               input trim(return-value)).
            disp trim(return-value) @ c-item with frame {&frame-name}.

        end.
    end.
    
    
    find estabelec where estabelec.cod-estabel = evento-ped.cod-estabel
        no-lock no-error.
    if  avail estabelec then 
        disp estabelec.nome @ c-estabelec with frame {&frame-name}.
    else 
        disp "" @ c-estabelec with frame {&frame-name}.
end.      

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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    assign i-ord-ant   = ?
           l-apply-tab = no.

    if not adm-new-record and avail evento-ped then do:
        enable c-des-event with frame {&frame-name}.
        &if defined(bf_mat_contratos) &then
        assign l-contrato = evento-ped.nr-contrato <> 0.
        &else
        assign l-contrato = evento-ped.nr-contrato <> "".
        &endif
        run pi-troca-campos.
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if avail evento-ped then
    assign gr-evento-ped = rowid (evento-ped).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-numera-evento V-table-Win 
PROCEDURE pi-numera-evento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if input frame {&frame-name} i-contrato = 0 then do:
    if input frame {&frame-name} evento-ped.numero-ordem <> 0 then do with frame {&frame-name}:
        /* ---------- Numeracao de Evento -------------- */
        assign i-seq-evento = 0.
        for each b1-evento-ped 
           where b1-evento-ped.numero-ordem = input frame {&frame-name} evento-ped.numero-ordem
        no-lock:
          if b1-evento-ped.seq-evento > i-seq-evento then
              assign i-seq-evento = b1-evento-ped.seq-evento.
        end.
        if i-seq-evento = 999999 then do:
            run utp/ut-msgs.p ("show",8361,"").
            /* Nao ha numeracao disponivel */
        end.
        else do:
            assign i-seq-evento = i-seq-evento + 1.
            assign evento-ped.seq-evento:screen-value in frame {&frame-name} = string(i-seq-evento).  
        end.
    end.
end.
else do with frame {&frame-name}:
    if  not avail contrato-for then
        find contrato-for where contrato-for.nr-contrato = input i-contrato
            no-lock no-error.
    if  avail contrato-for and
        input evento-ped.numero-ordem <> 0 and
        input evento-ped.num-seq-item <> 0 then do:

        /* ---------- Numeracao de Evento -------------- */
        assign i-seq-evento = 0.

        for last b1-evento-ped field (numero-ordem seq-evento)
            where b1-evento-ped.numero-ordem = input evento-ped.numero-ordem
            no-lock: 
            assign i-seq-evento = b1-evento-ped.seq-evento.
        end.

        if i-seq-evento = 999999 then do:
            run utp/ut-msgs.p ("show",8361,"").
            /* Nao ha numeracao disponivel */
        end.
        else do:
            assign i-seq-evento = i-seq-evento + 1.

            repeat:
                if  can-find (first evento-ped where evento-ped.numero-ordem = input evento-ped.numero-ordem
                              and evento-ped.seq-evento = i-seq-evento) then
                    assign i-seq-evento = i-seq-evento + 1.
                else
                    leave.
            end.

            assign evento-ped.seq-evento:screen-value = string (i-seq-evento).
        end.
    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ordem V-table-Win 
PROCEDURE pi-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

if input frame {&frame-name} i-contrato <> 0  and
   input frame {&frame-name} evento-ped.cod-estabel <> "" and
   input frame {&frame-name} evento-ped.numero-ordem = 0 
   then do with frame {&frame-name}:

    find first param-contrat no-lock no-error.

    &if defined(bf_mat_contratos) &then 
    find contrato-for where contrato-for.nr-contrato = input i-contrato no-lock no-error.
    &else
    find contrato-for where contrato-for.nr-contrato = string(input i-contrato) no-lock no-error.
    &endif

    if not avail contrato-for then return no-apply. 

    find item-contrat 
        where item-contrat.num-seq-item = input evento-ped.num-seq-item
        &if defined(bf_mat_contratos) &then
        and   item-contrat.nr-contrato =  input i-contrato
        &else
        and   item-contrat.nr-contrato =  string(input i-contrato)
        &endif
        no-lock no-error.

    if  avail item-contrat and
        item-contrat.ind-tipo-control = 1 then do:
        find first pedido-compr 
             &if defined(bf_mat_contratos) &then
             where pedido-compr.nr-contrato = input i-contrato 
             &else
             where pedido-compr.nr-contrato = string(input i-contrato) 
             &endif
             and   pedido-compr.cod-estabel = input evento-ped.cod-estabel 
             no-lock no-error.
        if not avail pedido-compr then do:
            /* Estabelecimento nao habilitado para o Contrato */
            run utp/ut-msgs.p("show",7840,"").
        end.
        else do:
            if  contrato-for.ind-control-rec = 1 then 
                find first ordem-compra 
                     &if defined(bf_mat_contratos) &then
                     where ordem-compra.nr-contrato  = input i-contrato 
                     &else
                     where ordem-compra.nr-contrato  = string(input i-contrato)
                     &endif
                     and   ordem-compra.cod-estabel = input evento-ped.cod-estabel 
                     and   ordem-compra.it-codigo   = param-contrat.it-codigo
                     no-lock no-error.
            else 
                find first ordem-compra 
                     &if defined(bf_mat_contratos) &then
                     where ordem-compra.nr-contrato   = input i-contrato 
                     &else
                     where ordem-compra.nr-contrato   = string(input i-contrato)
                     &endif
                     and   ordem-compra.num-seq-item = input evento-ped.num-seq-item 
                     and   ordem-compra.cod-estabel  = input evento-ped.cod-estabel 
                     no-lock no-error.

            if  available ordem-compra then do:
                display ordem-compra.numero-ordem @ evento-ped.numero-ordem 
                        ordem-compra.it-codigo    @ c-it-codigo.
                APPLY "leave":U TO c-it-codigo IN FRAME {&FRAME-NAME}.
            end.
            else do:
                run utp/ut-msgs.p ("show",7841,"").
                /* 7841  Item nao habilitado para o estabelecimento */
            end.
        end.
    end.
end.


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
def input parameter p-handle as handle no-undo.
def input parameter p-handle2 as handle no-undo.

assign h_v16in112 = p-handle
       h_v17in112 = p-handle2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-campos V-table-Win 
PROCEDURE pi-troca-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

do with frame {&frame-name}:
    if not l-contrato then do:
        assign evento-ped.num-seq-item:screen-value = "0"
               evento-ped.num-seq-item:hidden = yes
               c-it-codigo:column             = 21
               c-label-item:hidden            = no
               c-item:column                  = 35.29.
        disp c-label-item.
    end.
    else do:
        assign evento-ped.num-seq-item:hidden = no
               c-label-item:hidden            = yes
               c-it-codigo:column             = 28.43
               c-item:column                  = 42.72.
        if not evento-ped.num-seq-item:sensitive and avail evento-ped
        then /* navegaá∆o */
            disp evento-ped.num-seq-item.
    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/

/****FIM validaá∆o fornecedor, PTI-Status******/

   APPLY 'LEAVE':U TO evento-ped.num-seq-item IN FRAME {&FRAME-NAME}.

       {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

   RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "fi-qtd-prevista").
   assign de-fi-qtd-prevista = dec(return-value).
   assign l-contrato = (input frame {&frame-name} i-contrato <> 0).

   if  evento-ped.numero-ordem:sensitive in frame {&frame-name} and
       not can-find (ordem-compra where ordem-compra.numero-ordem = 
                     input frame {&frame-name} evento-ped.numero-ordem) then do:
       {include/i-vldprg.i}
       {utp/ut-table.i mgind ordem-compra 1}
       run utp/ut-msgs.p ("show",47,trim(return-value)).
       apply "entry" to evento-ped.numero-ordem in frame {&frame-name}.
       return "adm-error".
   end.

   if l-contrato then do with frame {&frame-name}:
       /* ------------ Validaá‰es Eventos para Contratos ------------ */
       for first b-evento-ped fields (nr-contrato num-seq-item numero-ordem seq-evento)
           &if defined(bf_mat_contratos) &then
           where b-evento-ped.nr-contrato   = input i-contrato         and
           &else
           where b-evento-ped.nr-contrato   = string(input i-contrato) and
           &endif
                 b-evento-ped.num-seq-item = evento-ped.num-seq-item       and
                 b-evento-ped.numero-ordem = input evento-ped.numero-ordem and
                 b-evento-ped.seq-evento   = input evento-ped.seq-evento 
       no-lock: end.
       if available b-evento-ped then do:
           if adm-new-record = yes then do:
               {include/i-vldprg.i}
               {utp/ut-liter.i Evento * R}
               /* Evento j† cadastrado */
               run utp/ut-msgs.p("show",1,trim(return-value)).
               apply 'entry' to i-contrato.
               return "adm-error".        
           end.
       end.


       if not avail param-contrat then
           find first param-contrat no-lock no-error.

       &if defined(bf_mat_contratos) &then
       find contrato-for where contrato-for.nr-contrato = input i-contrato no-lock no-error.
       &else
       find contrato-for where contrato-for.nr-contrato = string(input i-contrato) no-lock no-error.
       &endif
       if adm-new-record = yes then do:
           {utp/ut-liter.i Contrato * R}
           if  not available contrato-for then do:
               {include/i-vldprg.i}
               /* Contrato nao Cadastrado */
               run utp/ut-msgs.p("show",56,trim(return-value)).
               apply "entry" to i-contrato.
               return "adm-error".
           end.
       end.

       if  avail contrato-for then do:
           if not ((contrato-for.dt-ini-validade <= today and
                    contrato-for.dt-ter-validade >= today) and
                    contrato-for.ind-sit-contrat = 2) then do:
               {include/i-vldprg.i}
               /* Contrato nao emitido ou vencido. */
               run utp/ut-msgs.p("show",7834,"").  
               if  i-contrato:sensitive then
                   apply 'entry' to i-contrato.                         
               return "adm-error".
           end.
       end.                  

       if  adm-new-record = no then do:
           for first medicao-contrat fields (nr-contrato num-seq-item num-seq-event log-rec-medicao)
               where medicao-contrat.nr-contrato      = evento-ped.nr-contrato 
               and   medicao-contrat.num-seq-item    = evento-ped.num-seq-item 
               and   medicao-contrat.num-seq-event   = evento-ped.seq-evento 
               and   medicao-contrat.log-rec-medicao = yes 
           no-lock: end.
           if avail medicao-contrat then 
               for first medicao-contrat fields (nr-contrato num-seq-item num-seq-event log-rec-medicao)
                   where medicao-contrat.nr-contrato      = evento-ped.nr-contrato 
                   and   medicao-contrat.num-seq-item    = evento-ped.num-seq-item 
                   and   medicao-contrat.num-seq-event   = evento-ped.seq-evento 
                   and   medicao-contrat.log-rec-medicao = no 
               no-lock: end.
           if avail medicao-contrat and medicao-contrat.log-rec-medicao = yes then do:
               {include/i-vldprg.i}
               /* Evento ja Recebido */
               run utp/ut-msgs.p ("show",8310,""). 
               if  i-contrato:sensitive then
                   apply 'entry' to i-contrato.
               return "adm-error".
           end.
           if  evento-ped.ind-sit-event = 2 then do:
               /* Evento ja Realizado */
               run utp/ut-msgs.p ("show",8476,"").
               if  i-contrato:sensitive then
                   apply 'entry' to i-contrato.            
               return "adm-error".
           end.
       end.

       for first pedido-compr fields (nr-contrato cod-estabel)
           &if defined(bf_mat_contratos) &then
           where pedido-compr.nr-contrato  = input i-contrato 
           &else
           where pedido-compr.nr-contrato  = string(input i-contrato)
           &endif
           and   pedido-compr.cod-estabel = input evento-ped.cod-estabel 
       no-lock: end.
       if not avail pedido-compr then do:
           {include/i-vldprg.i}
           run utp/ut-msgs.p("show",7840,""). /* estabelecimento nao habilitado para o contrato */
           if  evento-ped.cod-estabel:sensitive then
               apply 'entry' to evento-ped.cod-estabel.
           return "adm-error". 
       end.

       find item-contrat where 
            item-contrat.num-seq-item = input evento-ped.num-seq-item and 
            &if defined(bf_mat_contratos) &then
            item-contrat.nr-contrato   = input i-contrato no-lock no-error.
            &else
            item-contrat.nr-contrato   = string(input i-contrato) no-lock no-error.
            &endif
       if  not available item-contrat then do:
           {include/i-vldprg.i}
           /* Sequencia de item nao cadastrada. */
           run utp/ut-msgs.p("show",7835,""). 
           if  evento-ped.num-seq-item:sensitive then
               apply 'entry' to evento-ped.num-seq-item.                      
           return "adm-error".
       end.

       assign de-total-qtd = 0
              de-total-val = 0.
       for each b-evento-ped fields (nr-contrato num-seq-item numero-ordem qtd-prevista val-previsto)
          &if defined(bf_mat_contratos) &then
          where b-evento-ped.nr-contrato   = input i-contrato 
          &else
          where b-evento-ped.nr-contrato   = string(input i-contrato)
          &endif
          and   b-evento-ped.num-seq-item = input evento-ped.num-seq-item 
          and   b-evento-ped.numero-ordem = input evento-ped.numero-ordem 
          and   b-evento-ped.seq-evento  <> input evento-ped.seq-evento
          no-lock: 
           assign de-total-qtd = de-total-qtd + b-evento-ped.qtd-prevista
                  de-total-val = de-total-val + b-evento-ped.val-previsto.
       end.
       assign de-qtd-ordem = 0
              de-val-ordem = 0.
       if item-contrat.ind-tipo-control = 2 then do:
           for each prazo-compra fields (numero-ordem situacao qtd-do-forn quantidade)
              where prazo-compra.numero-ordem = input evento-ped.numero-ordem
              and   prazo-compra.situacao = 2 no-lock:

               assign de-qtd-ordem = prazo-compra.qtd-do-forn + de-qtd-ordem             
                      de-val-ordem = de-val-ordem + (prazo-compra.qtd-do-forn *
                                                     item-contrat.pre-unit-for).  
           end.
           if (de-total-qtd + de-fi-qtd-prevista > de-qtd-ordem) or 
              (de-total-val > de-val-ordem) then do:
               {include/i-vldprg.i}
               run utp/ut-msgs.p("show",7842,""). /* total de eventos ultrapassa saldo da ordem */
               if  evento-ped.numero-ordem:sensitive then
                   apply 'entry' to evento-ped.numero-ordem.
               return "adm-error". 
           end.
       end.

       if item-contrat.ind-sit-item <> 2 then do:
           {include/i-vldprg.i}
           run utp/ut-msgs.p("show",17704,""). /* item do contrato n∆o emitido. */
           if  evento-ped.num-seq-item:sensitive then
               apply 'entry' to evento-ped.num-seq-item.
           return "adm-error".
       end.

       if item-contrat.log-libera = no then do:
           {include/i-vldprg.i}
           run utp/ut-msgs.p("show",7838,""). /* item inativo no contrato. */
           if  evento-ped.num-seq-item:sensitive then
               apply 'entry' to evento-ped.num-seq-item.
           return "adm-error". 
       end.

       if  not item-contrat.log-control-event then do:
           {include/i-vldprg.i}
           /*Item nao controlado por evento.*/
           run utp/ut-msgs.p("show",7839,""). 
           if  evento-ped.num-seq-item:sensitive then
               apply 'entry' to evento-ped.num-seq-item.
           return "adm-error". 
       end.

       if  adm-new-record = yes and 
           item-contrat.ind-tipo-control = 1 then do:
           if contrato-for.ind-control-rec = 1 then 
               find first ordem-compra 
                   &if defined(bf_mat_contratos) &then
                   where ordem-compra.nr-contrato  = input i-contrato
                   &else
                   where ordem-compra.nr-contrato  = string(input i-contrato)
                   &endif
                   and   ordem-compra.cod-estabel = input evento-ped.cod-estabel
                   and   ordem-compra.it-codigo   = param-contrat.it-codigo no-lock no-error.
           else
               find first ordem-compra 
                    &if defined(bf_mat_contratos) &then
                    where ordem-compra.nr-contrato    = input i-contrato 
                    &else
                    where ordem-compra.nr-contrato    = string(input i-contrato)
                    &endif
                    and   ordem-compra.num-seq-item  = input evento-ped.num-seq-item 
                    and    ordem-compra.cod-estabel  = input evento-ped.cod-estabel no-lock no-error.

           if  not available ordem-compra then do:
               {include/i-vldprg.i}
               /* Item nao habilitado para o estabelecimento */
               run utp/ut-msgs.p("show",7841,""). 
               /*********
               apply 'entry' to evento-ped.num-seq-item in frame {&frame-name}.                          
               return "adm-error". 
               *********/
           end.
       end.
   end. /* Fim contratos */
   else do:  
        /* ------------ Validaá‰es Eventos para Compras ------------ */


   end. /* Fim compras */

   if  input c-des-event = "" then do:
       {include/i-vldprg.i}
       /* Descricao deve ser diferente de branco. */
       {utp/ut-field.i mgind evento-ped des-event 1}
       run utp/ut-msgs.p ("show",247,trim(return-value)).
       apply "entry" to c-des-event.
       return "adm-error".
   end.

   &IF DEFINED(bf_mat_bloqueio_fornec) &THEN

           ASSIGN i-emitente = 0.

           find FIRST ordem-compra 
                where ordem-compra.numero-ordem = input frame {&frame-name} evento-ped.numero-ordem no-lock no-error.
           if avail ordem-compra then do:
               if  ordem-compra.cod-emitente <> 0  then
                  assign i-emitente = ordem-compra.cod-emitente.
               else do: 
                   find FIRST contrato-for 
                        where contrato-for.nr-contrato = ordem-compra.nr-contrato no-lock no-error.
                   if avail contrato-for then 
                       assign i-emitente = contrato-for.cod-emitente.
               end.

               IF i-emitente <> 0 THEN DO:
                   run cdp/cdapi029.p (input ordem-compra.cod-comprado,
                                       input 1,
                                       input today,
                                       input  i-emitente,
                                       output i-situacao,
                                       output dt-vig-ini,
                                       output dt-vig-fim,
                                       output table tt-erro-2).

                   assign c-return = return-value.

                   if can-find(first tt-erro-2) then
                       run cdp/cd0666.w (table tt-erro-2).

                   if  c-return = "NOK":U then 
                       return "adm-error":U.
               END.

           end.
   &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-ordem V-table-Win 
PROCEDURE pi-zoom-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  assign l-implanta = yes
         i-contrato:screen-value in frame {&frame-name} = "0".
  {include/zoomvar.i &prog-zoom=inzoom/z01in274.w
                   &campo=evento-ped.numero-ordem
                   &campo2=i-contrato
                   &campo3=evento-ped.cod-estabel
                   &campo4=c-it-codigo
                   &campozoom=numero-ordem
                   &campozoom2=nr-contrato
                   &campozoom3=cod-estabel
                   &campozoom4=it-codigo}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-ordem-contrato V-table-Win 
PROCEDURE pi-zoom-ordem-contrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z18in274.w
                     &campo=evento-ped.numero-ordem
                     &campo2=i-contrato
                     &campo3=evento-ped.cod-estabel
                     &campo4=evento-ped.num-seq-item
                     &campozoom=numero-ordem
                     &campozoom2=nr-contrato
                     &campozoom3=cod-estabel
                     &campozoom4=num-seq-item}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvar_chave V-table-Win 
PROCEDURE salvar_chave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAIL evento-ped THEN 
        ASSIGN evento-ped.numero-ordem = INPUT FRAME {&FRAME-NAME} evento-ped.numero-ordem 
               evento-ped.seq-evento   = INPUT FRAME {&FRAME-NAME} evento-ped.seq-evento 
               evento-ped.dt-evento    = TODAY. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "evento-ped"}

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


