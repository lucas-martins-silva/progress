&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V18IN112 2.00.00.039 } /*** "010039" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v18in112 MUT}
&ENDIF

{cdp/cdcfgmat.i}

&if '{&bf_mat_versao_ems}' >= '2.062' &then
    {cdp/cd9590.i}    /*Include verificaá∆o Unidade Neg¢cio*/
&endif


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

{cdp/cdcfgmat.i}    /* pre-processadores                  */
{cdp/cd9731.i2}     /* l-matriz-medicao - param contratos */
{cdp/cd0666.i}      /* Definiá∆o da temp-table tt-erro    */
{cep/ce1234.i}      /* Validaá∆o Decimais                 */
{method/dbotterr.i} /* rowerrors                          */

/* global variable definitions */

def new global shared var gr-evento-ped as rowid no-undo.                               

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def temp-table tt-entrega NO-UNDO
    field cd-freq        like frequencia.cd-freq /*cod. da frequencia de */
    field nr-sequencia   as integer /* seq. das entregas de cada cod. freq.*/
    field dat-entrega    as date.

define temp-table tt-erro-aed no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)"
    field c-param  as char.

def var i-num-seq-item as integer no-undo.
def var da-data-prev as date no-undo.
def var i-cont as integer no-undo.
def var l-confirma as logical no-undo.

def buffer b-evento-ped for evento-ped.

def buffer b1-evento-ped for evento-ped.

def var i-ordem               like evento-ped.numero-ordem.
def var i-sequencia           as   integer format "99".
def var i-ordem-ini           like evento-ped.numero-ordem.
def var i-ordem-fim           like evento-ped.numero-ordem.
def var i-seq-evento          like evento-ped.seq-evento.
def var c-event-codigo        like evento-ped.seq-evento.
def var c-event-desc          like evento-ped.des-event.
def var de-valor-conver       as dec format "->>>>,>>>,>>9.9999".
def var de-variacao-qtd       like evento-ped.qtd-prevista.
def var de-variacao-val       like evento-ped.val-previsto.
def var de-total-qtd          as dec format "->>>>,>>>,>>9.9999".
def var de-qtd-ordem          like de-total-qtd.
def var de-total-val          like evento-ped.val-previsto.
def var de-val-ordem          like de-total-val.
def var de-val-anterior       like evento-ped.val-realizado.
def var de-qtd-anterior       like evento-ped.qtd-realizada.
def var c-desc-1              as   character format "x(38)".
def var c-desc-2              as   character format "x(38)".
def var i-conta               as   integer   no-undo.
def var i-prox-ent            as   integer.
def var i-total-perc          as   integer   no-undo.
DEF VAR l-erro-co             AS LOGICAL NO-UNDO.
DEF VAR l-erro-in             AS LOGICAL NO-UNDO.
DEF VAR l-msg-tela            AS LOGICAL NO-UNDO. 
def var l-pendente            as logical no-undo.

def new shared var c-cod-estabel        like estabelec.cod-estabel.
def new global shared var c-nr-contrato like item-contrat.nr-contrato no-undo.
def new global shared var gr-it-codigo  like ordem-compra.it-codigo no-undo.

def new global shared var g-nr-contrato like contrato-for.nr-contrato no-undo.

def var h_v19in112            as handle no-undo.

def var i-num-seq-medicao     like medicao-contrat.num-seq-medicao.
def var de-val-realizado      like evento-ped.val-realizado.
def var de-qtd-medicao        like medicao-contrat.qtd-prevista.
def var de-val-medicao        like medicao-contrat.val-medicao.
def var de-perc-medicao       like medicao-contrat.perc-medicao.
def var sit-anterior          like evento-ped.ind-sit-event.

/* Integracao Contratos - declaracao temp-tables */
{cnp/cnapi020.i3}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key rt-key-2 fi-frequencia l-realizado ~
fi-num-periodos fi-ord-manut fi-cod-estabel 
&Scoped-Define DISPLAYED-OBJECTS fi-frequencia c-frequencia l-realizado ~
fi-num-periodos fi-numero-ordem fi-ord-manut fi-contrato c-des-contrato ~
fi-cod-tipo-contr c-tipo fi-num-seq-item c-it-codigo c-item fi-cod-estabel ~
c-estabelec fi-seq-evento 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS fi-numero-ordem fi-contrato ~
fi-num-seq-item fi-cod-estabel fi-seq-evento 
&Scoped-define ADM-ASSIGN-FIELDS fi-numero-ordem fi-contrato ~
fi-num-seq-item fi-cod-estabel fi-seq-evento 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  ( input c-campo as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-des-contrato AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE c-estabelec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE c-frequencia AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "x(16)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R15 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-tipo-contr AS INTEGER FORMAT "99" INITIAL 0 
     LABEL "Tipo Contrato" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-contrato AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-frequencia AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "":R12 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-num-periodos AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-num-seq-item AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "SeqÅància Item":R17 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fi-numero-ordem AS INTEGER FORMAT ">>>>>9,99" INITIAL 0 
     LABEL "Ordem Compra":R15 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88.

DEFINE VARIABLE fi-ord-manut AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Ord Manut" 
     VIEW-AS FILL-IN 
     SIZE 13.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-seq-evento AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Seq":R4 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 2.83.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 5.83.

DEFINE VARIABLE l-realizado AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-frequencia AT ROW 1.67 COL 20.14 COLON-ALIGNED HELP
          "FreqÅància de ocorrància do evento."
     c-frequencia AT ROW 1.67 COL 26.14 COLON-ALIGNED HELP
          "Descriá∆o da frequància de fornecimento dos itens" NO-LABEL
     l-realizado AT ROW 2.58 COL 42
     fi-num-periodos AT ROW 2.67 COL 20.14 COLON-ALIGNED
     fi-numero-ordem AT ROW 4.83 COL 20.14 COLON-ALIGNED
     fi-ord-manut AT ROW 4.83 COL 52.86 COLON-ALIGNED
     fi-contrato AT ROW 5.83 COL 20.14 COLON-ALIGNED
     c-des-contrato AT ROW 5.83 COL 29.14 COLON-ALIGNED NO-LABEL
     fi-cod-tipo-contr AT ROW 6.83 COL 20.14 COLON-ALIGNED HELP
          "Tipo de Contrato"
     c-tipo AT ROW 6.83 COL 29.14 COLON-ALIGNED NO-LABEL
     fi-num-seq-item AT ROW 7.83 COL 20.14 COLON-ALIGNED
     c-it-codigo AT ROW 7.83 COL 28.14 COLON-ALIGNED HELP
          "C¢digo do Item" NO-LABEL
     c-item AT ROW 7.83 COL 42 COLON-ALIGNED NO-LABEL
     fi-cod-estabel AT ROW 8.83 COL 20.14 COLON-ALIGNED HELP
          ""
          LABEL "Estabelecimento":R15
     c-estabelec AT ROW 8.83 COL 27.14 COLON-ALIGNED NO-LABEL
     fi-seq-evento AT ROW 8.83 COL 80.14 COLON-ALIGNED
     rt-key AT ROW 1.17 COL 1
     rt-key-2 AT ROW 4.33 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.29
         WIDTH              = 88.29.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-des-contrato IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estabelec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-frequencia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME f-main
   1 2 LIKE = mgcad.estabelec.cod-estabel EXP-LABEL                     */
/* SETTINGS FOR FILL-IN fi-cod-tipo-contr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-contrato IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-num-seq-item IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-numero-ordem IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-seq-evento IN FRAME f-main
   NO-ENABLE 1 2                                                        */
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


&Scoped-define SELF-NAME fi-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel V-table-Win
ON F5 OF fi-cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  assign l-implanta = yes 
         c-nr-contrato = input frame {&frame-name} fi-contrato.
  {include/zoomvar.i &prog-zoom=adzoom/z03ad107.w
                     &campo=fi-cod-estabel
                     &campozoom=cod-estabel}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel V-table-Win
ON LEAVE OF fi-cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-estabelec
                   &where="estabelec.cod-estabel =
                           input frame {&frame-name} fi-cod-estabel"}

run pi-ordem.
run pi-numera-evento.

IF  AVAIL ordem-compra THEN DO:
    DISP ordem-compra.it-codigo @ c-it-codigo WITH FRAME {&frame-name}.
    APPLY "leave":U TO c-it-codigo IN FRAME {&FRAME-NAME}.
END.

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


&Scoped-define SELF-NAME fi-cod-tipo-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-tipo-contr V-table-Win
ON F5 OF fi-cod-tipo-contr IN FRAME f-main /* Tipo Contrato */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in576.w
                   &campo=fi-cod-tipo-contr
                   &campozoom=cod-tipo-contr}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-tipo-contr V-table-Win
ON LEAVE OF fi-cod-tipo-contr IN FRAME f-main /* Tipo Contrato */
DO:
{include/leave.i &tabela=tipo-contrat  
                 &atributo-ref=des-tipo-contrat
                 &variavel-ref=c-tipo
                 &where="tipo-contrat.cod-tipo-contr = input frame {&frame-name} fi-cod-tipo-contr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-tipo-contr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-tipo-contr IN FRAME f-main /* Tipo Contrato */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-contrato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-contrato V-table-Win
ON F5 OF fi-contrato IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in065.w
                     &campo=fi-contrato
                     &campozoom=nr-contrato}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-contrato V-table-Win
ON LEAVE OF fi-contrato IN FRAME f-main
DO:

 {include/leave.i &tabela=contrato-for
                   &atributo-ref=des-contrat
                   &variavel-ref=c-des-contrato
                   &where="string(contrato-for.nr-contrato) =
                           string(input frame {&frame-name} fi-contrato)"}

&if defined(bf_mat_contratos) &then
find contrato-for where string(contrato-for.nr-contrato) = string(input frame {&frame-name} fi-contrato)
        no-lock no-error.
&else
find contrato-for where contrato-for.nr-contrato = input frame {&frame-name} fi-contrato
        no-lock no-error.
&endif

if  available contrato-for then do:
    assign c-des-contrato = contrato-for.des-contrat
           fi-cod-tipo-contr = contrato-for.cod-tipo-contr.
    find tipo-contrat where tipo-contrat.cod-tipo-contr = input frame {&frame-name} fi-cod-tipo-contr
         no-lock no-error.
    if  available tipo-contrat then
        assign c-tipo = tipo-contrat.des-tipo-contrat.
    display c-des-contrato
            fi-cod-tipo-contr
            c-tipo with frame {&frame-name}.    
end.

run pi-ordem.
run pi-numera-evento.
if  valid-handle(h_v19in112) then
    run pi-recebe-item in h_v19in112 (INPUT ordem-compra.nr-contrato,
                                      INPUT ordem-compra.numero-ordem,
                                      INPUT ordem-compra.num-seq-item).

IF  AVAIL ordem-compra THEN DO:
    DISP ordem-compra.it-codigo @ c-it-codigo WITH FRAME {&frame-name}.
    APPLY "leave":U TO c-it-codigo IN FRAME {&FRAME-NAME}.
END.

RUN pi-habilita-om.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-contrato V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-contrato IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-frequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-frequencia V-table-Win
ON F5 OF fi-frequencia IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="adzoom~\z01ad122.w"
                     &campo=fi-frequencia
                     &campozoom=cd-freq}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-frequencia V-table-Win
ON LEAVE OF fi-frequencia IN FRAME f-main
DO:

  {include/leave.i &tabela=frequencia 
                 &atributo-ref=descricao
                 &variavel-ref=c-frequencia
                 &where="frequencia.cd-freq = input frame {&frame-name} fi-frequencia"}

  APPLY "LEAVE":U TO fi-numero-ordem IN FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-frequencia V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-frequencia IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-num-seq-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-seq-item V-table-Win
ON F5 OF fi-num-seq-item IN FRAME f-main /* SeqÅància Item */
DO:     
  assign l-implanta = yes.
  assign g-nr-contrato = input frame {&frame-name} fi-contrato.

  {include/zoomvar.i &prog-zoom="inzoom/z02in582.w"
                     &campo=fi-num-seq-item
                     &campozoom=num-seq-item}  



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-seq-item V-table-Win
ON LEAVE OF fi-num-seq-item IN FRAME f-main /* SeqÅància Item */
DO:

find item-contrat where 
     item-contrat.num-seq-item = input frame {&frame-name} fi-num-seq-item and
     item-contrat.nr-contrato = input frame {&frame-name} fi-contrato no-lock no-error.
if  avail item-contrat then do with frame {&frame-name}:
    assign gr-it-codigo = item-contrat.it-codigo.
    find item where item.it-codigo = item-contrat.it-codigo 
        no-lock no-error.
    if  available item then 
        display item.desc-item @ c-item
                item.it-codigo @ c-it-codigo with frame {&frame-name}.
    run pi-ordem.
    run pi-numera-evento.
    if  valid-handle(h_v19in112) then
        run pi-recebe-item in h_v19in112 (INPUT ordem-compra.nr-contrato,
                                          INPUT ordem-compra.numero-ordem,
                                          INPUT ordem-compra.num-seq-item).
end.

IF  AVAIL ordem-compra THEN DO:
    DISP ordem-compra.it-codigo @ c-it-codigo WITH FRAME {&frame-name}.
    APPLY "leave":U TO c-it-codigo IN FRAME {&FRAME-NAME}.
END.

RUN pi-habilita-om.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-seq-item V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-num-seq-item IN FRAME f-main /* SeqÅància Item */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-numero-ordem V-table-Win
ON F5 OF fi-numero-ordem IN FRAME f-main /* Ordem Compra */
DO:


  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z19in274.w
                   &campo=fi-numero-ordem
                   &campozoom=numero-ordem}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-numero-ordem V-table-Win
ON LEAVE OF fi-numero-ordem IN FRAME f-main /* Ordem Compra */
DO:

find first ordem-compra 
     where ordem-compra.numero-ordem = input frame {&frame-name} fi-numero-ordem
     no-lock no-error.
if  available ordem-compra and 
    &if defined(bf_mat_contratos) &then
        ordem-compra.nr-contrato <> 0 
    &else
        ordem-compra.nr-contrato <> "" 
    &endif    
    then do with frame {&frame-name}:
    assign fi-cod-estabel:screen-value = string(ordem-compra.cod-estabel)
           fi-contrato:screen-value = string(ordem-compra.nr-contrato)
           fi-num-seq-item:screen-value = string(ordem-compra.num-seq-item)
           when ordem-compra.num-seq-item > 0
           c-it-codigo:screen-value = string(ordem-compra.it-codigo).
    apply 'leave' to fi-num-seq-item.
    run pi-numera-evento.
    if  valid-handle(h_v19in112) then
        run pi-recebe-item in h_v19in112 (INPUT ordem-compra.nr-contrato,
                                          INPUT ordem-compra.numero-ordem,
                                          INPUT ordem-compra.num-seq-item).
end.

IF  AVAIL ordem-compra THEN DO:
    DISP ordem-compra.it-codigo @ c-it-codigo WITH FRAME {&frame-name}.
    APPLY "leave":U TO c-it-codigo IN FRAME {&FRAME-NAME}.
END.

 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-numero-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-numero-ordem IN FRAME f-main /* Ordem Compra */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ord-manut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ord-manut V-table-Win
ON F5 OF fi-ord-manut IN FRAME f-main /* Ord Manut */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in271.w"
                     &campo=fi-ord-manut
                     &campozoom=nr-ord-produ}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ord-manut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-ord-manut IN FRAME f-main /* Ord Manut */
DO:
  APPLY "F5":U TO SELF.
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

if fi-contrato:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if fi-num-seq-item:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if fi-numero-ordem:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if fi-cod-estabel:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if fi-numero-ordem:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if fi-frequencia:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if fi-ord-manut:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.

{utp/ut-field.i mgadm frequencia cd-freq 1}
assign fi-frequencia:label in frame {&frame-name} = trim (return-value).
{utp/ut-liter.i Nr._Per°odos MCC l}
assign fi-num-periodos:label in frame {&frame-name} = trim (return-value).
{utp/ut-liter.i Realizado MCC l}
assign l-realizado:label in frame {&frame-name} = trim (return-value).
{utp~/ut-field.i mgind evento-ped nr-contrato 1}
assign fi-contrato:label in frame {&frame-name} = trim(return-value).
{utp~/ut-field.i mgind evento-ped nr-contrato 1}
assign fi-seq-evento:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Modalidade * R }
assign fi-cod-tipo-contr:label in frame {&frame-name} = trim(return-value).
{utp~/ut-field.i mgind evento-ped num-seq-item 1}
assign fi-num-seq-item:label in frame {&frame-name} = trim(return-value).
{utp~/ut-field.i mgind evento-ped numero-ordem 1}
assign fi-numero-ordem:label in frame {&frame-name} = trim(return-value).
{utp~/ut-field.i mgind evento-ped cod-estabel 1}
assign fi-cod-estabel:label in frame {&frame-name} = trim(return-value).
{utp~/ut-field.i mgind evento-ped seq-evento 1}
assign fi-seq-evento:label in frame {&frame-name} = trim(return-value).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  assign fi-num-periodos = 1.

&if defined(bf_mat_contratos) &then
&else
assign fi-contrato:format in frame {&frame-name} = '>>>>>>>>9'.
&endif

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  IF  NOT AVAIL param-global THEN
      FIND FIRST param-global NO-LOCK NO-ERROR.

  /* Code placed here will execute AFTER standard behavior.    */

  disp fi-num-periodos with frame {&frame-name}.

  {utp/ut-liter.i Ord_Manut *}
  ASSIGN fi-ord-manut:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
  &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
       IF param-global.modulo-mi = yes then
          ASSIGN fi-ord-manut:VISIBLE IN FRAME {&FRAME-NAME} = YES.
       ELSE
          ASSIGN fi-ord-manut:VISIBLE IN FRAME {&FRAME-NAME} = NO.
  &ELSE
       ASSIGN fi-ord-manut:VISIBLE IN FRAME {&FRAME-NAME} = NO.
  &ENDIF

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-eventos V-table-Win 
PROCEDURE pi-gera-eventos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def var i-destino      as integer initial 1.
DEF VAR r-evento       AS ROWID     NO-UNDO.

for each tt-erro:
    delete tt-erro.
end.

 find frequencia where 
      frequencia.cd-freq = input frame {&frame-name} fi-frequencia no-lock no-error.

 if not avail frequencia then do:
    {utp/ut-table.i mgadm frequencia 1}
    run utp/ut-msgs.p (input "show",
                       input 56,
                       input return-value).
    apply 'entry' to fi-frequencia in frame {&frame-name}.
    return "adm-error".
 end.

 if input frame {&frame-name} fi-num-periodos < 1 then do:
    run utp/ut-msgs.p (input "show",
                       input 8782,
                       input "").
    apply 'entry' to fi-num-periodos in frame {&frame-name}.
    return "adm-error".
 end.


&IF '{&bf_mat_versao_ems}' >= "2.062":U &THEN
     /********************************MATRIZ UNIDADE NEG‡CIO*******************************/
     IF param-global.modulo-mi AND INPUT FRAME {&FRAME-NAME} fi-ord-manut <> 0 THEN DO:
        FIND FIRST ord-prod 
             WHERE ord-prod.nr-ord-produ = INPUT FRAME {&FRAME-NAME} fi-ord-manut NO-LOCK NO-ERROR.
        IF NOT AVAIL ord-prod THEN DO:
           RUN utp/ut-msgs.p(INPUT "show":U, INPUT 1879, INPUT "").
           APPLY "entry":U TO fi-ord-manut.
           RETURN 'adm-error'.
        END.
            ELSE 
           IF ord-prod.origem = "MI":U THEN DO:
              IF ord-prod.estado = 8 THEN DO:
                 /* Ordem de Produá∆o finalizada ! */
                 RUN utp/ut-msgs.p(INPUT "show":U, INPUT 1882, INPUT "").
                 APPLY "entry":U TO fi-ord-manut.
                 RETURN 'adm-error'.
              END.
                  IF CAN-FIND(FIRST unid-negoc-om 
                      WHERE unid-negoc-om.num-ord-manut = ord-prod.nr-ord-produ) AND 
                      l-unidade-negocio THEN
                      /* Sera assumida matriz de UN da OM */
                      RUN utp/ut-msgs.p(INPUT "show":U, INPUT 34511, INPUT ""). 
           END.
     END.
&ENDIF

 for each tt-entrega:
     delete tt-entrega.
 end.

 assign input frame {&frame-name} fi-contrato
        input frame {&frame-name} fi-num-seq-item
        input frame {&frame-name} fi-numero-ordem
        input frame {&frame-name} fi-seq-evento
        input frame {&frame-name} fi-cod-estabel
        da-data-prev   = date (f-retorna-campo ("fi-dat-prev-entr")).

 &if defined(bf_mat_contratos) &then
     find contrato-for where contrato-for.nr-contrato = fi-contrato no-lock no-error.
 &else
     find contrato-for where contrato-for.nr-contrato = string(fi-contrato) no-lock no-error.
 &endif

 find item-contrat where 
      item-contrat.num-seq-item = fi-num-seq-item and
      item-contrat.nr-contrato   = &if defined(bf_mat_contratos) &then
                                      fi-contrato 
                                  &else
                                      string(fi-contrato)
                                  &endif        
     no-lock no-error.

 if avail item-contrat then do:

     find ordem-compra where ordem-compra.numero-ordem = fi-numero-ordem
        no-lock no-error.
     run cnp/cn9012.p (input (input frame {&frame-name} fi-frequencia),
                       input da-data-prev,
                       input (input frame {&frame-name} fi-num-periodos),
                       input-output table tt-entrega).

     /* Integracao Contratos - limpa registros temp-table integraá∆o */
     {cnp/cnapi020.i4}

     do i-cont = 1 to input frame {&frame-name} fi-num-periodos
     transaction:
        assign  l-confirma = no.

        if i-cont <> 1 then do:
             do while l-confirma = no:
                assign fi-seq-evento = fi-seq-evento + 1.
                find first b-evento-ped
                     where b-evento-ped.nr-contrato   = 
                           &if defined(bf_mat_contratos) &then
                               fi-contrato 
                           &else
                               string(fi-contrato)
                           &endif
                       and b-evento-ped.num-seq-item = fi-num-seq-item
                       and b-evento-ped.numero-ordem = fi-numero-ordem
                       and b-evento-ped.seq-evento   = fi-seq-evento
                      no-lock no-error.           
                if not avail b-evento-ped then assign
                   l-confirma = yes.            
             end.

        end. 

        /*********************************************************** 
        ** Inicio - Ponto UPC "BEFORE-CREATE-EVENTO-PED"
        ***********************************************************/
        IF c-nom-prog-upc-mg97 <> "" AND 
           c-nom-prog-upc-mg97 <> ?  THEN DO:
            RUN VALUE(c-nom-prog-upc-mg97) (INPUT "BEFORE-CREATE-EVENTO-PED",
                                            INPUT "fi-seq-evento",
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME {&FRAME-NAME}:HANDLE,
                                            INPUT STRING(fi-seq-evento),
                                            INPUT ?).
        END.
        /*********************************************************** 
        ** Fim - Ponto UPC "BEFORE-CREATE-EVENTO-PED"
        ***********************************************************/

        create evento-ped.
        assign  evento-ped.nr-contrato = &if defined(bf_mat_contratos) &then
                                            fi-contrato 
                                        &else
                                            string(fi-contrato)
                                        &endif 
                evento-ped.dt-evento    = today
                evento-ped.num-seq-item = fi-num-seq-item
                evento-ped.it-codigo    = input frame {&frame-name} c-it-codigo
                evento-ped.numero-ordem = fi-numero-ordem
                evento-ped.frequencia   = fi-frequencia
                evento-ped.cod-estabel  = fi-cod-estabel
                evento-ped.cod-comprado = if avail ordem-compra then ordem-compra.cod-comprado else ""
                evento-ped.seq-evento   = fi-seq-evento.

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

        &IF "{&bf_mat_versao_ems}" >= "2.062":U &THEN
        IF AVAIL item-contrat AND 
           item-contrat.ind-tipo-control = 1 AND 
           item-contrat.log-control-event AND 
           param-global.modulo-mi THEN 
           &IF "{&bf_mat_versao_ems}" >= "2.08":U &THEN
               ASSIGN evento-ped.nr-ord-produ = INPUT FRAME {&frame-name} fi-ord-manut.
           &ELSE
               ASSIGN evento-ped.int-1 = INPUT FRAME {&frame-name} fi-ord-manut.
           &ENDIF
        &ENDIF

        find first tt-entrega where 
                   tt-entrega.nr-sequencia = i-cont no-error.
        if avail tt-entrega then
           assign da-data-prev = tt-entrega.dat-entrega.

        assign evento-ped.dat-prev-entr = da-data-prev.
        assign evento-ped.dat-nova-realiz = evento-ped.dat-prev-entr.

        assign evento-ped.dat-entr-orig    = da-data-prev
               evento-ped.dat-prev-event   = da-data-prev
               evento-ped.cod-cond-pag     = int (f-retorna-campo ("fi-cod-cond-pag"))
               evento-ped.observacao       = f-retorna-campo ("observacao")
               evento-ped.narrativa        = f-retorna-campo ("narrativa")
               evento-ped.des-event        = f-retorna-campo ("c-des-event")
               evento-ped.qtd-prevista     = dec(f-retorna-campo("fi-qtd-prevista"))
               evento-ped.qtd-realiz       = evento-ped.qtd-prevista
               evento-ped.val-previsto     = dec(f-retorna-campo("fi-val-previsto"))
               evento-ped.perc-lib-previst = dec(f-retorna-campo("fi-perc-lib-previst"))
               evento-ped.perc-lib-realiz  = evento-ped.perc-lib-previst
               evento-ped.ind-sit-event    = 1.

        &IF "{&bf_mat_versao_ems}" >= "2.062":U &THEN
        IF AVAIL item-contrat AND 
           item-contrat.ind-tipo-control = 1 AND 
           item-contrat.log-control-event AND 
           param-global.modulo-mi THEN 
           &IF "{&bf_mat_versao_ems}" >= "2.08":U &THEN
               ASSIGN evento-ped.nr-ord-produ = INPUT FRAME {&frame-name} fi-ord-manut.
           &ELSE
               ASSIGN evento-ped.int-1 = INPUT FRAME {&frame-name} fi-ord-manut.
           &ENDIF
        &ENDIF

        RUN get-field-screen-value IN adm-broker-hdl(INPUT THIS-PROCEDURE, INPUT "tg-log-liber-autom").

        ASSIGN evento-ped.log-liber-autom = IF  RETURN-VALUE = "yes" THEN YES ELSE NO.

        find first nar-evento-aber
            where nar-evento-aber.numero-ordem = evento-ped.numero-ordem
            and   nar-evento-aber.seq-evento   = evento-ped.seq-evento exclusive-lock no-error.
        if not avail nar-evento-aber then do:
            create nar-evento-aber.
            assign nar-evento-aber.numero-ordem = evento-ped.numero-ordem
                   nar-evento-aber.seq-evento   = evento-ped.seq-evento.
        end.
        assign nar-evento-aber.desc-linha   = evento-ped.narrativa.

        /* Matriz de rateio Eventos */
        IF  (l-rat-ord OR l-rat-med) THEN DO:
            {cnp~/cnapi015.i}
            IF  l-chamada = YES THEN DO:
                RUN cnp/cnapi015.p (INPUT item-contrat.nr-contrato,
                                    INPUT item-contrat.num-seq-item,
                                    INPUT ordem-compra.numero-ordem,
                                    INPUT evento-ped.seq-evento,
                                    OUTPUT TABLE rowErrors).
                IF  CAN-FIND(FIRST RowErrors) THEN
                    UNDO, RETURN "ADM-ERROR".
            END.
        END.

        if  avail ordem-compra then
            assign evento-ped.val-previsto = fn_vld_ajust_dec(evento-ped.val-previsto,ordem-compra.mo-codigo).
        assign evento-ped.val-realizado    = evento-ped.val-previsto.

        if f-retorna-campo("cb-destino") = {varinc/var00066.i 04 1} then
           assign i-destino = 1.
        if f-retorna-campo("cb-destino") = {varinc/var00066.i 04 2} then
           assign i-destino = 2. 
        assign evento-ped.ind-dest-event = i-destino.

        /**if  input frame {&frame-name} l-realizado = no then do:  **/
            run cnp/cnapi003.p (input rowid(item-contrat),
                                input evento-ped.qtd-prevista *
                                   integer(item-contrat.ind-tipo-control <> 2),
                                input evento-ped.val-realizado *
                                   integer(item-contrat.ind-tipo-control <> 2),
                                input 0, 
                                input 0, 
                                input 0, 
                                input 0,
                                input c-cod-estabel,
                                output l-msg-tela, 
                                output l-erro-co,
                                input-output table tt-erro).                            
            find first tt-erro no-lock no-error. 
               if avail tt-erro then 
               run cdp/cd0666.w (input table tt-erro).                                        
            if  l-erro-co = yes then
                undo, return "adm-error".
        /**end. a logica para atualizar o liberado ja esta sendo feito no cn0303.i
        else do:
            run cnp/cnapi003.p (input rowid(item-contrat),
                                input evento-ped.qtd-realizada *
                                   integer(item-contrat.ind-tipo-control <> 2),
                                input evento-ped.val-realizado * 
                                   integer(item-contrat.ind-tipo-control <> 2),
                                input evento-ped.qtd-realizada,
                                input evento-ped.val-realizado, 
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
                undo, return "adm-error".**/

        /**  MLA **/
        if  can-find(funcao where
                     funcao.cd-funcao = "Integra_MLA_EMS" and
                     funcao.ativo     = yes) then do:
    
            RUN lap/mlaapi173.p (input 11,
                                 input input frame {&frame-name} c-it-codigo,
                                 input contrato-for.gestor-tecnico,
                                 input contrato-for.cod-emitente,
                                 input contrato-for.cod-emitente,
                                 input "",
                                 input evento-ped.val-previsto,
                                 input evento-ped.val-previsto,
                                 input contrato-for.cod-estabel, 
                                 output table tt-erro-aed).
    
            if  return-value = "nok":U then do:
                find first tt-erro-aed no-error.
                if  avail tt-erro-aed then do:
                    run cdp/cd0669.w (input table tt-erro-aed).
                    undo, return "adm-error":U.
                end.
            end.

            &if defined(bf_mat_aprova_eletronica) &then
                find first param-aprov no-lock no-error.
                if substring(param-aprov.char-1,2,1) = "Y" then do:
                    run cdp/cdapi171.p (11, 2, rowid(evento-ped)).
                end.

                /* Verifica se h† pendància de aprovaá∆o para o evento */                    
                if  param-aprov.aprova-event then do:
                    run cdp/cdapi172.p (11, rowid(evento-ped), output l-pendente).
                end.
            &endif
        end.

        IF  NOT l-pendente THEN DO:
            if  input frame {&frame-name} l-realizado = YES then do:
                assign evento-ped.ind-sit-event = 2. /* Realizado */
                assign sit-anterior = 1 /* Pendente */
                       i-num-seq-medicao = 1
                       de-val-realizado = evento-ped.val-realizado
                       de-perc-medicao = evento-ped.perc-lib-previst
                       de-qtd-medicao = evento-ped.qtd-prevista.
                {cnp/cn0303.i3} /* cria registro de medicao */    
            end.
    
            /* Matriz rateio Mediá∆o */
            IF  l-matriz-medicao THEN DO:
                IF  AVAIL medicao-contrat THEN DO:
                    RUN cnp/cnapi014.p (INPUT ROWID(medicao-contrat),
                                        INPUT item-contrat.ind-tipo-control,
                                        INPUT contrato-for.ind-control-rec).
    
                    IF  RETURN-VALUE = "NOK":U THEN
                        UNDO,RETURN "adm-error".
    
                    RUN cnp/cnapi011.p (INPUT ROWID(medicao-contrat),
                                        INPUT-OUTPUT TABLE tt-erro,
                                        OUTPUT l-erro-in).
    
                    IF  l-erro-in THEN DO:                    
                        RUN cdp/cd0666.w (INPUT TABLE tt-erro).
                        apply "entry":U to frame {&frame-name}.
                        UNDO, RETURN "adm-error".
                    END.
                END.
            END.
    
            if  input frame {&frame-name} l-realizado = yes and avail medicao-contrat then do:
               /** Integracao Contratos - criar registro para eliminacao **/
               {cnp/cnapi020.i1 2 1 CD0115 "Geraá∆o" medicao-contrat medicao-contrat}
            end.
        END.

        /* Fim Rateio */
        ASSIGN r-evento = ROWID(evento-ped).
        RELEASE evento-ped.

        /*********************************************************** 
        ** Inicio - Ponto UPC "AFTER-CREATE-EVENTO-PED"
        ***********************************************************/
        IF c-nom-prog-upc-mg97 <> "" AND 
           c-nom-prog-upc-mg97 <> ?  THEN DO:
            RUN VALUE(c-nom-prog-upc-mg97) (INPUT "AFTER-CREATE-EVENTO-PED",
                                            INPUT "VIEWER",
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME {&FRAME-NAME}:HANDLE,
                                            INPUT "evento-ped",
                                            INPUT ROWID(evento-ped)).
        END.
        /*********************************************************** 
        ** Fim - Ponto UPC "AFTER-CREATE-EVENTO-PED"
        ***********************************************************/

        /*Multiplanta*/
        IF  param-global.modulo-mp              AND
            contrato-for.cod-estab-gestor <> "" THEN DO:
            RUN ccp/ccapi200.p (INPUT "Evento-ped":U,
                                INPUT r-evento,
                                INPUT 1,
                                INPUT-OUTPUT TABLE tt-erro).
        END.
     END.

     /* Integracao Contratos - executa API integraá∆o e valida erros */  
     IF  NOT l-pendente THEN DO:
        {cnp/cnapi020.i2 ADM-ERROR yes}
     END.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-om V-table-Win 
PROCEDURE pi-habilita-om :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF "{&bf_mat_versao_ems}" >= "2.062":U &THEN
    FIND FIRST param-global NO-LOCK NO-ERROR.
    FIND FIRST item-contrat 
         WHERE item-contrat.num-seq-item  = INPUT FRAME {&FRAME-NAME} fi-num-seq-item 
           AND item-contrat.nr-contrato   = INPUT FRAME {&FRAME-NAME} fi-contrato NO-LOCK NO-ERROR.
    IF AVAIL item-contrat AND 
       item-contrat.ind-tipo-control = 1 AND 
       item-contrat.log-control-event AND 
       param-global.modulo-mi THEN 
       ASSIGN fi-ord-manut:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE
       ASSIGN fi-ord-manut:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
              fi-ord-manut:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0":U.
    &ENDIF
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa V-table-Win 
PROCEDURE pi-inicializa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter rw-evento-ped as rowid .

find evento-ped where rowid(evento-ped) = rw-evento-ped no-lock no-error.
if avail evento-ped then do with frame {&frame-name}:
    disp evento-ped.frequencia     @ fi-frequencia
         evento-ped.nr-contrato     @ fi-contrato
         evento-ped.num-seq-item   @ fi-num-seq-item
         evento-ped.numero-ordem   @ fi-numero-ordem
         evento-ped.cod-estabel    @ fi-cod-estabel 
         evento-ped.it-codigo      @ c-it-codigo.


    &IF "{&bf_mat_versao_ems}" >= "2.062":U &THEN
    IF param-global.modulo-mi THEN DO:
        &IF "{&bf_mat_versao_ems}" >= "2.08":U &THEN
        DISP evento-ped.nr-ord-produ @ fi-ord-manut WITH FRAME {&FRAME-NAME}.
        &ELSE
        DISP evento-ped.int-1 @ fi-ord-manut WITH FRAME {&frame-name}.
        &ENDIF
    END.
    &ENDIF
    
    disable fi-seq-evento.

    find first item-contrat 
         where item-contrat.num-seq-item = input fi-num-seq-item 
         and   item-contrat.nr-contrato   = input fi-contrato no-lock no-error.
    if avail item-contrat then do:
        find item where item.it-codigo = item-contrat.it-codigo 
            no-lock no-error.
        if  available item then 
            display item.desc-item @ c-item
                    item.it-codigo @ c-it-codigo .
    end.         
    enable fi-frequencia     
           fi-contrato     
           fi-num-seq-item   
           fi-numero-ordem   
           fi-cod-estabel  
           l-realizado.
    apply "entry" to fi-frequencia.

    RUN pi-habilita-om.

end.

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
if  input frame {&frame-name} fi-contrato <> ""    and
    input frame {&frame-name} fi-numero-ordem <> 0 and
    input frame {&frame-name} fi-num-seq-item <> 0 then do:

    /* ---------- Numeracao de Evento -------------- */
    assign i-seq-evento = 1.

    for first b1-evento-ped field (nr-contrato num-seq-item numero-ordem)
        where b1-evento-ped.numero-ordem = input frame {&frame-name} fi-numero-ordem 
        no-lock: end.
    if  available b1-evento-ped then do:
        for last b1-evento-ped field (nr-contrato num-seq-item numero-ordem seq-evento)
            where b1-evento-ped.numero-ordem = input frame {&frame-name} fi-numero-ordem 
            and   b1-evento-ped.seq-evento  >= input frame {&frame-name} fi-seq-evento 
            no-lock: end.
        if  avail b1-evento-ped then do with frame {&frame-name}:
            assign i-seq-evento = b1-evento-ped.seq-evento.
            repeat:
                if  i-seq-evento < 999999 then
                    assign i-seq-evento = i-seq-evento + 1.
                else do:
                    run utp/ut-msgs.p ("show",8361,"").
                    /* Nao ha numeracao disponivel */
                    leave.
                end.
                find first b1-evento-ped where
                    b1-evento-ped.numero-ordem = input frame {&frame-name} fi-numero-ordem and
                    b1-evento-ped.seq-evento = i-seq-evento no-lock no-error.
                if not avail b1-evento-ped then do:
                    assign fi-seq-evento:screen-value = string (i-seq-evento). 
                    leave.
                end.

            end.
        end.
    end.
    else assign fi-seq-evento:screen-value = string (i-seq-evento).

    /* ------------------------------------------------------ */
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

if  input frame {&frame-name} fi-contrato <> 0 and
    input frame {&frame-name} fi-cod-estabel <> "" and 
    input frame {&frame-name} fi-numero-ordem = 0 then do:
    find first param-contrat no-lock no-error.

    &if defined(bf_mat_contratos) &then                                
       find item-contrat where 
            item-contrat.num-seq-item = input frame {&frame-name} fi-num-seq-item and 
            item-contrat.nr-contrato =  input frame {&frame-name} fi-contrato no-lock no-error.
    &else
       find item-contrat where 
            item-contrat.num-seq-item = input frame {&frame-name} fi-num-seq-item and 
            item-contrat.nr-contrato =  string(input frame {&frame-name} fi-contrato) no-lock no-error.
    &endif
    if  avail item-contrat then do:
    if  item-contrat.ind-tipo-control = 1 then do:

        &if defined(bf_mat_contratos) &then 
            find first pedido-compr 
                 where pedido-compr.nr-contrato = input frame {&frame-name} fi-contrato 
                 and   pedido-compr.cod-estabel = input frame {&frame-name} fi-cod-estabel no-lock no-error.
        &else
            find first pedido-compr 
                 where pedido-compr.nr-contrato = string(input frame {&frame-name} fi-contrato) 
                 and   pedido-compr.cod-estabel = input frame {&frame-name} fi-cod-estabel no-lock no-error.

        &endif

        if  not avail pedido-compr then do:
            /* Estabelecimento nao habilitado para o Contrato */
            run utp/ut-msgs.p("show",7840,"").
            return "adm-error".
        end.

        if contrato-for.ind-control-rec = 1 then 
            &if defined(bf_mat_contratos) &then 
                find first ordem-compra 
                 where ordem-compra.nr-contrato  = input frame {&frame-name} fi-contrato 
                 and   ordem-compra.cod-estabel = input frame {&frame-name} fi-cod-estabel 
                 and   ordem-compra.it-codigo = param-contrat.it-codigo no-lock no-error.
            &else
                find first ordem-compra 
                 where ordem-compra.nr-contrato = string(input frame {&frame-name} fi-contrato) 
                 and   ordem-compra.cod-estabel = input frame {&frame-name} fi-cod-estabel 
                 and   ordem-compra.it-codigo = param-contrat.it-codigo no-lock no-error.
            &endif
        else 
            find first ordem-compra use-index estabel 
                 where ordem-compra.nr-contrato   =  
                       &if defined(bf_mat_contratos) &then 
                           input frame {&frame-name} fi-contrato 
                       &else
                           string(input frame {&frame-name} fi-contrato) 
                       &endif    
                 and   ordem-compra.num-seq-item = input frame {&frame-name} fi-num-seq-item 
                 and   ordem-compra.cod-estabel  = input frame {&frame-name} fi-cod-estabel no-lock no-error.
        if  available ordem-compra then 
            display ordem-compra.numero-ordem @ fi-numero-ordem 
                    ordem-compra.it-codigo    @ c-it-codigo with frame {&frame-name}.
        else do:
            run utp/ut-msgs.p ("show",7841,"").
            /* 7841  Item nao habilitado para o estabelecimento */
            return "adm-error".
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
def input parameter p-handle as handle.
assign h_v19in112 = p-handle.

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
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

for first b-evento-ped fields (nr-contrato num-seq-item numero-ordem seq-evento)
    where b-evento-ped.nr-contrato   = 
          &if defined(bf_mat_contratos) &then  
              input frame {&frame-name} fi-contrato 
          &else
              string(input frame {&frame-name} fi-contrato)         
          &endif    
          and
          b-evento-ped.num-seq-item = input frame {&frame-name} fi-num-seq-item and
          b-evento-ped.numero-ordem = input frame {&frame-name} fi-numero-ordem and
          b-evento-ped.seq-evento   = input frame {&frame-name} fi-seq-evento
    no-lock: end.
if available b-evento-ped then do:
    if adm-new-record = yes then do:
        {include/i-vldprg.i}
        {utp/ut-liter.i Evento * R}
        run utp/ut-msgs.p(input "show",
                          input 1, 
                          input return-value).  /* Evento j† cadastrado */
        apply 'entry' to fi-contrato in frame {&frame-name}.
        return "adm-error".        
    end.
end.

if adm-new-record = yes then do:
    {utp/ut-liter.i Contrato * R}
    find contrato-for where contrato-for.nr-contrato = 
         &if defined(bf_mat_contratos) &then  
             input frame {&frame-name} fi-contrato 
         &else
             string(input frame {&frame-name} fi-contrato)
         &endif
         no-lock no-error.

    if not avail contrato-for then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p("show",56,return-value).  /* Contrato nao Cadastrado */
        apply "entry" to fi-contrato in frame {&frame-name}.
        return "adm-error".
    end.
end.

if  avail contrato-for then do:
    if not ((contrato-for.dt-ini-validade <= today and
             contrato-for.dt-ter-validade >= today) and
             contrato-for.ind-sit-contrat = 2) then do:
        {include/i-vldprg.i}     
        run utp/ut-msgs.p("show",7834,"").  /* Contrato nao emitido ou vencido. */
        apply 'entry' to fi-contrato in frame {&frame-name}.                         
        return "adm-error".
    end.
end.                  

find item-contrat where item-contrat.num-seq-item = input frame {&frame-name} fi-num-seq-item 
                  and   item-contrat.nr-contrato = 
                  &if defined(bf_mat_contratos) &then  
                      input frame {&frame-name} fi-contrato 
                  &else
                      string(input frame {&frame-name} fi-contrato) 
                  &endif
                  no-lock no-error.
if  not available item-contrat then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p("show",7835,""). /* Sequencia de item nao cadastrada. */
    apply 'entry' to fi-num-seq-item in frame {&frame-name}.                      
    return "adm-error".
end.

if item-contrat.ind-sit-item <> 2 then do:
   {include/i-vldprg.i}
    run utp/ut-msgs.p("show", 17704,""). /* Item do contrato n∆o emitido */
    apply 'entry' to fi-num-seq-item in frame {&frame-name}.                       
    return "adm-error".
end.

if item-contrat.log-libera = no then do:
  {include/i-vldprg.i}
   run utp/ut-msgs.p("show",7838,""). /* Item Inativo no Contrato. */
   apply 'entry' to fi-num-seq-item in frame {&frame-name}.                      
   return "adm-error". 
end.

if input frame {&frame-name} fi-contrato:sensitive = no then do:
    if  not item-contrat.log-control-event then do:
       {include/i-vldprg.i}
        run utp/ut-msgs.p("show",7839,""). /* item nao controlado por evento. */
        apply 'entry' to fi-num-seq-item in frame {&frame-name}.                          
        return "adm-error". 
    end.
end.

find ordem-compra where ordem-compra.numero-ordem = input frame {&frame-name} fi-numero-ordem
    no-lock no-error.
if  not avail ordem-compra then do:
    {utp/ut-table.i mgind ordem-compra 1}
    run utp/ut-msgs.p("show",47,trim(return-value)).
    apply 'entry' to fi-numero-ordem in frame {&frame-name}.
    return "adm-error".
end.

if  avail ordem-compra and
    int(ordem-compra.nr-contrato) <> input frame {&frame-name} fi-contrato
    then do:
    /* Ordem n∆o pertence a este contrato */
    run utp/ut-msgs.p ("show",8340,"").
    apply 'entry' to fi-numero-ordem in frame {&frame-name}.
    return "adm-error".
end.

if  adm-new-record = no then do:
    for first medicao-contrat fields (nr-contrato num-seq-item num-seq-event log-rec-medicao)
        where medicao-contrat.nr-contrato = evento-ped.nr-contrato and
              medicao-contrat.num-seq-item = evento-ped.num-seq-item and
              medicao-contrat.num-seq-event = evento-ped.seq-evento and
              medicao-contrat.log-rec-medicao = yes 
    no-lock: end.

    if avail medicao-contrat then 
        for first medicao-contrat fields (nr-contrato num-seq-item num-seq-event log-rec-medicao)
            where medicao-contrat.nr-contrato = evento-ped.nr-contrato and
                  medicao-contrat.num-seq-item = evento-ped.num-seq-item and
                  medicao-contrat.num-seq-event = evento-ped.seq-evento and
                  medicao-contrat.log-rec-medicao = no 
        no-lock: end.
    if avail medicao-contrat and medicao-contrat.log-rec-medicao = yes then do:
      {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show",
                          input  8310,
                          input ""). /* Evento ja Recebido */
       apply 'entry' to fi-contrato in frame {&frame-name}.                           
       return "adm-error".
    end.
end.

for first pedido-compr fields (nr-contrato cod-estabel)
    where pedido-compr.nr-contrato = 
          &if defined(bf_mat_contratos) &then  
              input frame {&frame-name} fi-contrato 
          &else
              string(input frame {&frame-name} fi-contrato) 
          &endif 
      and pedido-compr.cod-estabel = input frame {&frame-name} fi-cod-estabel 
no-lock: end.
if  not avail pedido-compr then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p("show",7840,""). /* Estabelecimento nao habilitado para o Contrato */
     apply 'entry' to fi-cod-estabel in frame {&frame-name}.                      
     return "adm-error". 
end.

if adm-new-record = yes then do:
    if contrato-for.ind-control-rec = 1 then 
        for first ordem-compra fields (nr-contrato cod-estabel it-codigo)
            where ordem-compra.nr-contrato  = 
            &if defined(bf_mat_contratos) &then  
                input frame {&frame-name} fi-contrato
            &else
                string(input frame {&frame-name} fi-contrato)
            &endif
            and   ordem-compra.cod-estabel = input frame {&frame-name} fi-cod-estabel
            and   ordem-compra.it-codigo   = param-contrat.it-codigo 
            no-lock: end.
    else do:
        for first ordem-compra fields (nr-contrato num-seq-item cod-estabel)
            where ordem-compra.nr-contrato   = 
            &if defined(bf_mat_contratos) &then  
                input frame {&frame-name} fi-contrato
            &else
                string(input frame {&frame-name} fi-contrato)
            &endif
            and   ordem-compra.num-seq-item = input frame {&frame-name} fi-num-seq-item 
            and   ordem-compra.cod-estabel = input frame {&frame-name} fi-cod-estabel 
            no-lock: end.
    end.
    if  not available ordem-compra then do:
       {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 7841, 
                          input ""). /* Item nao habilitado para o estabelecimento */
        apply 'entry' to fi-num-seq-item in frame {&frame-name}.                          
        /*return "adm-error". */
    end.
end.

assign de-total-qtd = 0
       de-total-val = 0.
for each b-evento-ped fields (nr-contrato num-seq-item numero-ordem qtd-prevista val-previsto)
   where b-evento-ped.nr-contrato = 
        &if defined(bf_mat_contratos) &then  
            input frame {&frame-name} fi-contrato
        &else
            string(input frame {&frame-name} fi-contrato)
        &endif
   and   b-evento-ped.num-seq-item = input frame {&frame-name} fi-num-seq-item 
   and   b-evento-ped.numero-ordem = input frame {&frame-name} fi-numero-ordem
   no-lock: 
    assign de-total-qtd = de-total-qtd + b-evento-ped.qtd-prevista
           de-total-val = de-total-val + b-evento-ped.val-previsto.
end.
assign de-qtd-ordem = 0
       de-val-ordem = 0.
if item-contrat.ind-tipo-control = 2 then do:
    for each prazo-compra fields (numero-ordem situacao qtd-do-forn quantidade)
       where prazo-compra.numero-ordem = input frame {&frame-name} fi-numero-ordem
       and   prazo-compra.situacao = 2 no-lock:
        assign de-qtd-ordem = prazo-compra.qtd-do-forn + de-qtd-ordem             
               de-val-ordem = de-val-ordem + (prazo-compra.qtd-do-forn * item-contrat.pre-unit-for).
    end.

    if (de-total-qtd > de-qtd-ordem) or 
       (de-total-val > de-val-ordem) then do:
       {include/i-vldprg.i}
       run utp/ut-msgs.p(input "show",
                         input 7842, 
                         input ""). /* Total de eventos ultrapassa saldo da Ordem */
       apply 'entry' to fi-numero-ordem in frame {&frame-name}.                     
       return "adm-error". 
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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this Window, and there are no
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  ( input c-campo as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT c-campo).   

  IF RETURN-VALUE = ? THEN 
      RETURN "":U.
  ELSE 
      RETURN return-value.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

