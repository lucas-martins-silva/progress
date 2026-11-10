&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V01IN157 2.00.00.079} /*** "010079" 09/01/2026 14:41:39  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in157 MUT}
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
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer  b-movto      for movto-estoq.
def buffer  c-movto      for movto-estoq.
def buffer  b-saldo      for saldo-estoq.
def buffer  b-invent     for inventario.
def buffer  b-inventario for inventario.

def new shared var  c-cod-estabel   like estabelec.cod-estabel.
def new shared var  c-deposito      like deposito.cod-depos.
def new shared var  c-fm-codigo     like item.fm-codigo.
def new shared var  c-it-codigo     like item.it-codigo.
def new shared var  c-it-un         like item.un.
def new shared var  c-referencia    like saldo-estoq.cod-refer.
def new shared var  i-ge-codigo     like item.ge-codigo.
def new shared var  i-nr-ficha      like inventario.nr-ficha no-undo.
def new shared var  c-it-descricao  as character format "x(36)".

def var  c-opcao        as character         no-undo.
def var  r-registro     as rowid             no-undo.
def var  i-cont         as integer           no-undo.
def var  l-localizacao  as logical.
def var  l-edit         as logical  init no  no-undo.
def var  l-existe       as logical  init no  no-undo.
def var  l-atualiza     as logical  init no  no-undo.
def var  l-resposta     as logical  init no  no-undo.
def var  da-fim-per-inv like inventario.dt-saldo      no-undo.
def var  de-saldo       like saldo-estoq.qtidade-atu  no-undo.
def var  c-item         like item.it-codigo           no-undo.
def var  c-local        like inventario.cod-localiz   no-undo.
def var  c-lote         like inventario.lote          no-undo.
def var  l-desabilita   as logical  initial no no-undo.
def var  i-nr-cont-ant  as integer no-undo.
def var  dt-saldo-ant   as date no-undo.
def var i-modo-digi     as integer   no-undo.
def var l-un            as logical   no-undo.
def var i-pg-val        as integer   no-undo.
def var i-sit           as integer   no-undo.
def var da-mensal-ate   like param-estoq.mensal-ate no-undo.
def var r-saldo-estoq as rowid.
def var de-qtidade-atu like saldo-estoq.qtidade-atu. 
def var l-tem-nfe-aca   as logical   no-undo.
def var l-msg-inventario as log      no-undo.

/*************Multiplanta********************/
def var i-tipo-movto as integer no-undo.
{cdp/cd7300.i1}

{mcinc/mcapi281.i}
def temp-table tt-dados-env-SMC     like tt-dados-env.
def temp-table tt-replica-msg-SMC   like tt-replica-msg.
def temp-table tt-control-env-SMC   like tt-control-env.
def temp-table tt-integracao-SMC    like tt-integracao.
/************Fim*****************************/

{cdp/cdcfgmat.i}

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
&Scoped-define EXTERNAL-TABLES inventario
&Scoped-define FIRST-EXTERNAL-TABLE inventario


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR inventario.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS inventario.int-1 
&Scoped-define ENABLED-TABLES inventario
&Scoped-define FIRST-ENABLED-TABLE inventario
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS inventario.int-1 inventario.dt-saldo ~
inventario.nr-ficha inventario.cod-estabel inventario.cod-depos ~
inventario.it-codigo inventario.cod-localiz inventario.lote ~
inventario.cod-refer 
&Scoped-define DISPLAYED-TABLES inventario
&Scoped-define FIRST-DISPLAYED-TABLE inventario
&Scoped-Define DISPLAYED-OBJECTS i-nr-contagem c-desc-estab i-nr-cont-tit ~
c-desc-depos c-desc-item da-vali-lote de-valor c-un c-desc-unid ~
de-valor-mat de-valor-mob de-valor-ggf 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS inventario.dt-saldo i-nr-contagem ~
inventario.nr-ficha inventario.cod-estabel inventario.cod-depos ~
inventario.it-codigo inventario.cod-localiz inventario.lote ~
inventario.cod-refer de-valor 
&Scoped-define ADM-ASSIGN-FIELDS inventario.cod-estabel ~
inventario.cod-depos inventario.it-codigo inventario.cod-localiz ~
inventario.lote inventario.cod-refer de-valor 
&Scoped-define ADM-MODIFY-FIELDS i-nr-contagem da-vali-lote de-valor 

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
DEFINE VARIABLE c-desc-depos AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 39.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-unid AS CHARACTER FORMAT "x(15)" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "xx" 
     LABEL "":R12 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE da-vali-lote AS DATE FORMAT "99/99/9999" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-ggf AS DECIMAL FORMAT ">>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-mat AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-mob AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-cont-tit AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14.57 BY .63 NO-UNDO.

DEFINE VARIABLE i-nr-contagem AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "1", 1,
"2", 2,
"3", 3
     SIZE 18.57 BY .79 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.29 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.29 BY 12.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     inventario.int-1 AT ROW 1.25 COL 85.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE .86 BY .21
     inventario.dt-saldo AT ROW 1.13 COL 27.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     i-nr-contagem AT ROW 2.17 COL 30 NO-LABEL
     inventario.nr-ficha AT ROW 3.54 COL 27.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     inventario.cod-estabel AT ROW 4.54 COL 27.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-desc-estab AT ROW 4.54 COL 35.57 COLON-ALIGNED HELP
          "Nome Estabelecimento" NO-LABEL
     i-nr-cont-tit AT ROW 2.25 COL 12.72 COLON-ALIGNED NO-LABEL
     inventario.cod-depos AT ROW 5.54 COL 27.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-desc-depos AT ROW 5.54 COL 35.57 COLON-ALIGNED HELP
          "Descri‡Æo do Dep¢sito" NO-LABEL
     inventario.it-codigo AT ROW 6.54 COL 27.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-desc-item AT ROW 6.54 COL 45.72 COLON-ALIGNED NO-LABEL
     inventario.cod-localiz AT ROW 7.54 COL 27.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     inventario.lote AT ROW 8.54 COL 27.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     inventario.cod-refer AT ROW 8.58 COL 43.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     da-vali-lote AT ROW 9.54 COL 27.72 COLON-ALIGNED
     de-valor AT ROW 10.54 COL 27.72 COLON-ALIGNED
     c-un AT ROW 11.54 COL 27.72 COLON-ALIGNED HELP
          "Unidade de medida do item"
     c-desc-unid AT ROW 11.54 COL 33.14 COLON-ALIGNED NO-LABEL
     de-valor-mat AT ROW 12.54 COL 27.72 COLON-ALIGNED
     de-valor-mob AT ROW 13.54 COL 27.72 COLON-ALIGNED
     de-valor-ggf AT ROW 14.54 COL 27.72 COLON-ALIGNED HELP
          "Valor do GGF Mensal"
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.inventario
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
         HEIGHT             = 14.71
         WIDTH              = 89.72.
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

/* SETTINGS FOR FILL-IN c-desc-depos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-unid IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN inventario.cod-depos IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN inventario.cod-estabel IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN inventario.cod-localiz IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN inventario.cod-refer IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN da-vali-lote IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN de-valor IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-valor-ggf IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-mat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-mob IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN inventario.dt-saldo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN i-nr-cont-tit IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET i-nr-contagem IN FRAME f-main
   NO-ENABLE 1 3                                                        */
ASSIGN 
       inventario.int-1:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN inventario.it-codigo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN inventario.lote IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN inventario.nr-ficha IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME c-un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un V-table-Win
ON F5 OF c-un IN FRAME f-main
DO:
   {include/zoomvar.i &prog-zoom="inzoom/z01in417.w"
                      &campo=c-un
                      &campozoom=un}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un V-table-Win
ON LEAVE OF c-un IN FRAME f-main
DO:
  {include/leave.i &tabela=tab-unidade
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-unid
                   &where="tab-unidade.un = input frame {&frame-name} c-un}.                  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-un IN FRAME f-main
DO:
     apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME inventario.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inventario.cod-depos V-table-Win
ON F5 OF inventario.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
   {include/zoom.i &prog-zoom="inzoom/z01in084.w"
                   &tabela=inventario
                   &atributo=cod-depos}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inventario.cod-depos V-table-Win
ON LEAVE OF inventario.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
  {include/leave.i &tabela=deposito
                   &atributo-ref=nome   
                   &variavel-ref=c-desc-depos
                   &where="deposito.cod-depos = input frame {&frame-name} inventario.cod-depos}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inventario.cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF inventario.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME inventario.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inventario.cod-estabel V-table-Win
ON F5 OF inventario.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
   {include/zoom.i &prog-zoom="adzoom/z01ad107.w"
                   &tabela=inventario
                   &atributo=cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inventario.cod-estabel V-table-Win
ON LEAVE OF inventario.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
   {include/leave.i &tabela=estabelec
                    &atributo-ref=nome
                    &variavel-ref=c-desc-estab
                    &where="estabelec.cod-estabel = input frame {&frame-name} inventario.cod-estabel}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inventario.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF inventario.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME inventario.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inventario.cod-localiz V-table-Win
ON F5 OF inventario.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
   {include/zoom.i &prog-zoom="inzoom/z01in189.w"
                   &tabela=inventario
                   &atributo=cod-localiz}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inventario.cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF inventario.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME inventario.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inventario.cod-refer V-table-Win
ON F5 OF inventario.cod-refer IN FRAME f-main /* Ref */
DO:
     {include/zoom.i &prog-zoom="inzoom/z01in377.w"
                   &tabela=inventario
                   &atributo=cod-refer}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inventario.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF inventario.cod-refer IN FRAME f-main /* Ref */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-vali-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-vali-lote V-table-Win
ON F5 OF da-vali-lote IN FRAME f-main
DO:
   {include/zoomvar.i &prog-zoom="inzoom/z01in377.w"
                      &campo=inventario.cod-refer
                      &campozoom=cod-refer}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-valor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor V-table-Win
ON ENTRY OF de-valor IN FRAME f-main
DO:

  def var i-opcao as int no-undo.

  assign i-opcao = input frame {&frame-name} i-nr-contagem.

  if  avail inventario 
  and not adm-new-record then do:
      assign de-valor = inventario.val-apurado[i-opcao].
      disp de-valor with frame {&frame-name}.  
  end.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor V-table-Win
ON LEAVE OF de-valor IN FRAME f-main
DO:

def var da-data-saldo like inventario.dt-saldo no-undo.
assign da-data-saldo = input frame {&frame-name} inventario.dt-saldo.
assign de-qtidade-atu = input frame {&frame-name} de-valor.

find first saldo-estoq where 
           saldo-estoq.cod-estabel = input frame {&frame-name} inventario.cod-estabel and
           saldo-estoq.cod-depos   = input frame {&frame-name} inventario.cod-depos   and
           saldo-estoq.cod-localiz = input frame {&frame-name} inventario.cod-localiz and
           saldo-estoq.lote        = input frame {&frame-name} inventario.lote        and
           saldo-estoq.it-codigo   = input frame {&frame-name} inventario.it-codigo   and
           saldo-estoq.cod-refer   = input frame {&frame-name} inventario.cod-refer
           no-lock no-error.
    if avail saldo-estoq then do:
        assign r-saldo-estoq = rowid(saldo-estoq).
            run cpp/cp9045.p (input r-saldo-estoq,
                                input de-qtidade-atu,
                                input no).
    end.                          

if avail item then do:
     /* VERIFICA DATA FINAL DO PERIODO DO INVENTARIO */
     assign da-fim-per-inv = if month(da-data-saldo) = 12
                            then date(01,01,year(da-data-saldo) + 1) - 1
                            else date(month(da-data-saldo) + 1,01,
                                      year(da-data-saldo)) - 1.
     find first estab-mat where 
          estab-mat.cod-estabel = input frame {&frame-name} inventario.cod-estabel no-lock no-error.

     find first item-estab where 
                item-estab.it-codigo = input frame {&frame-name} inventario.it-codigo and
                item-estab.cod-estabel = input frame {&frame-name} inventario.cod-estabel no-lock no-error.

     if item.tipo-contr = 2 
     and (NOT AVAIL item-estab
          OR     (available item-estab and item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] = 0
                  and avail estab-mat and estab-mat.custo-contab = 1)
              or (available item-estab and item-estab.val-unit-mat-o[1] + item-estab.val-unit-mob-o[1] = 0
                  and avail estab-mat and estab-mat.custo-contab = 2)
              or (available item-estab and item-estab.val-unit-mat-p[1] + item-estab.val-unit-mob-p[1] = 0
                  and avail estab-mat and estab-mat.custo-contab = 3)
          ) then 
     do:

       &if defined(bf_mat_fech_estab) &then
         if param-estoq.tp-fech = 2 then do:
            if avail estab-mat then
               assign da-mensal-ate = estab-mat.mensal-ate.
         end.
         else
            assign da-mensal-ate = param-estoq.mensal-ate.
       &endif

         for first b-movto 
                fields (it-codigo )
                use-index item-data where 
                   b-movto.it-codigo   = input frame {&frame-name} inventario.it-codigo and
                   b-movto.cod-estabel = input frame {&frame-name} inventario.cod-estabel and
                   b-movto.esp-docto   = 1 and
                   b-movto.dt-trans    > da-mensal-ate and
                   b-movto.dt-trans   <= da-fim-per-inv no-lock: 
         end.

         if not avail b-movto then
            for first c-movto 
                    fields (it-codigo )
                    use-index item-data where
                   c-movto.it-codigo   = input frame {&frame-name} inventario.it-codigo and
                   c-movto.cod-estabel = input frame {&frame-name} inventario.cod-estabel and
                   c-movto.esp-docto   = 21 and
                   c-movto.dt-trans    > da-mensal-ate and
                   c-movto.dt-trans   <= da-fim-per-inv no-lock: end.

         assign l-tem-nfe-aca = avail c-movto or avail b-movto.
         if not avail c-movto and not avail b-movto then do:
           enable de-valor-mat 
                  de-valor-mob 
                  de-valor-ggf with frame {&frame-name}.  
           apply "entry" to de-valor-mat in frame {&frame-name}.
           return no-apply.
         end.
         else 
           disable de-valor-mat
                   de-valor-mob
                   de-valor-ggf with frame {&frame-name}.  
     end.
     else
         disable de-valor-mat
                 de-valor-mob
                 de-valor-ggf with frame {&frame-name}.
end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME inventario.dt-saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inventario.dt-saldo V-table-Win
ON LEAVE OF inventario.dt-saldo IN FRAME f-main /* Data Saldo Inventariar */
DO:
  find last b-invent use-index nr-ficha where 
       b-invent.dt-saldo = input frame {&frame-name} inventario.dt-saldo no-lock no-error.
  if avail b-invent then do:
     if b-invent.nr-ficha < 9999999 then do:
        disp b-invent.nr-ficha + 1 @ inventario.nr-ficha with frame {&frame-name}.
     end.
  end.
  else do:
     disp 1 @ inventario.nr-ficha with frame {&frame-name}.
  end.

  assign da-fim-per-inv = if month(input frame {&frame-name} inventario.dt-saldo) = 12
                             then date(01,01,year(input frame {&frame-name} inventario.dt-saldo) + 1) - 1
                             else date(month(input frame {&frame-name} inventario.dt-saldo)
                             + 1,01, year(input frame {&frame-name} inventario.dt-saldo)) - 1.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-nr-contagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-contagem V-table-Win
ON VALUE-CHANGED OF i-nr-contagem IN FRAME f-main
DO:
  assign i-nr-contagem = input frame {&frame-name} i-nr-contagem.

  if not adm-new-record and avail inventario then do: 
     assign de-valor = inventario.val-apurado[i-nr-contagem].
     disp de-valor with frame {&frame-name}. 
     disable de-valor-mat
     de-valor-mob
     de-valor-ggf with frame {&frame-name}. 
  end.    

  if (i-nr-contagem = 1) or (i-nr-contagem = 2) or (i-nr-contagem = 3) then do:
     display ?   @ de-valor 
            /* " " @ de-valor-mat
             " " @ de-valor-mob
             " " @ de-valor-ggf */ with frame {&frame-name}.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME inventario.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inventario.it-codigo V-table-Win
ON F5 OF inventario.it-codigo IN FRAME f-main /* Item */
DO:
   {include/zoom.i &prog-zoom="inzoom/z02in172.w"
                   &tabela=inventario
                   &atributo=it-codigo} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inventario.it-codigo V-table-Win
ON LEAVE OF inventario.it-codigo IN FRAME f-main /* Item */
DO:

   find first param-estoq no-lock no-error.

   {include/leave.i &tabela=item
                    &atributo-ref=desc-item 
                    &variavel-ref=c-desc-item
                    &where="item.it-codigo = input frame {&frame-name} inventario.it-codigo"}.


   FIND FIRST item-uni-estab WHERE item-uni-estab.cod-estabel = inventario.cod-estabel:screen-value in frame {&frame-name} 
                               AND item-uni-estab.it-codigo   = inventario.it-codigo:screen-value   in frame {&frame-name} NO-LOCK NO-ERROR.

   if avail item and (inventario.it-codigo:sensitive in frame {&frame-name} = yes) then do:
      c-desc-estab = item.desc-item.

      IF AVAIL item-uni-estab THEN DO:
         disp item-uni-estab.cod-localiz @ inventario.cod-localiz with frame {&frame-name}.

         if item-uni-estab.loc-unica = yes then do:
            disable inventario.cod-localiz with frame {&frame-name}.
         end.
         else do:
              enable inventario.cod-localiz with frame {&frame-name}.
         end.
      END.

      if item.tipo-con-est = 3 or item.tipo-con-est = 4 or item.tipo-con-est = 2 then do:
         if inventario.dt-saldo:sensitive in frame {&frame-name} then
             enable inventario.lote with frame {&frame-name}.
         if item.tipo-con-est = 3 or item.tipo-con-est = 4 THEN DO:
              enable da-vali-lote with frame {&frame-name}.

              IF  INPUT FRAME {&FRAME-NAME} da-vali-lote <> ?  AND
                  INPUT FRAME {&FRAME-NAME} inventario.lote <> "" THEN
                  DISABLE da-vali-lote WITH FRAME {&FRAME-NAME}.
         END.

         if item.tipo-con-est = 4 and substr(param-estoq.char-2,1,1) = "#" then
              enable inventario.cod-refer with frame {&frame-name}.
         else do:
              assign inventario.cod-refer:screen-value in frame {&frame-name} = "".
              disable inventario.cod-refer with frame {&frame-name}.       
         end. 
      end.
      else do:
         assign inventario.cod-refer:screen-value in frame {&frame-name} = "".
         disable inventario.lote
                 inventario.cod-refer 
                 da-vali-lote with frame {&frame-name}.
      end. 

      assign c-un = item.un.
      disp c-un with frame {&frame-name}.

      find first tab-unidade where tab-unidade.un = item.un no-lock no-error.
      if avail tab-unidade then do:
         assign c-desc-unid = tab-unidade.descricao.
         disp c-desc-unid with frame {&frame-name}.
      end.
   end.

   if inventario.dt-saldo:sensitive in frame {&frame-name} = no and
      inventario.nr-ficha:sensitive in frame {&frame-name} = no and
      input frame {&frame-name} i-nr-contagem > 1 then do:     

      assign de-valor     = inventario.val-apurado[input frame {&frame-name} i-nr-contagem]
             de-valor-mat = inventario.valor-mat-m[input frame {&frame-name} i-nr-contagem] 
             de-valor-mob = inventario.valor-mob-m[input frame {&frame-name} i-nr-contagem]
             de-valor-ggf = inventario.valor-ggf-m[input frame {&frame-name} i-nr-contagem]
             da-vali-lote = inventario.dt-ult-entra.

      disp  de-valor
            de-valor-mat
            de-valor-mob
            de-valor-ggf 
            da-vali-lote with frame {&frame-name}.  
   end.        

  if avail item-uni-estab and inventario.it-codigo:sensitive in frame {&frame-name} = no then do: 
  /* BUSCA SALDO DE ESTOQUE REFERENTE AO REGISTRO DE INVENTARIO */
    if item-uni-estab.loc-unica then 
       find first saldo-estoq use-index estabel-dep where 
                  saldo-estoq.cod-estabel = input frame {&frame-name} inventario.cod-estabel and
                  saldo-estoq.cod-depos   = input frame {&frame-name} inventario.cod-depos and 
                  saldo-estoq.cod-localiz = item-uni-estab.cod-localiz and 
                  saldo-estoq.lote        = input frame {&frame-name} inventario.lote and
                  saldo-estoq.it-codigo   = input frame {&frame-name} inventario.it-codigo and
                  saldo-estoq.cod-refer   = input frame {&frame-name} inventario.cod-refer
            exclusive-lock no-error.
    else
       find first saldo-estoq use-index estabel-dep where 
                  saldo-estoq.cod-estabel = input frame {&frame-name} inventario.cod-estabel and 
                  saldo-estoq.cod-depos   = input frame {&frame-name} inventario.cod-depos and 
                  saldo-estoq.cod-localiz = input frame {&frame-name} inventario.cod-localiz and 
                  saldo-estoq.lote        = input frame {&frame-name} inventario.lote and 
                  saldo-estoq.it-codigo   = input frame {&frame-name} inventario.it-codigo and
                  saldo-estoq.cod-refer   = input frame {&frame-name} inventario.cod-refer
            exclusive-lock no-error.


    if avail saldo-estoq then do:
        assign da-vali-lote:screen-value in frame {&frame-name} = string(saldo-estoq.dt-vali-lote)
              inventario.cod-refer:screen-value in frame {&frame-name}  = saldo-estoq.cod-refer.
    end.
    else do:
       find first b-saldo use-index lote where 
                  b-saldo.lote      = input frame {&frame-name} inventario.lote and 
                  b-saldo.it-codigo = input frame {&frame-name} inventario.it-codigo no-lock no-error.
       if avail b-saldo then
          assign da-vali-lote:screen-value in frame {&frame-name} = string(b-saldo.dt-vali-lote)
                 inventario.cod-refer:screen-value in frame {&frame-name}  = b-saldo.cod-refer.
       else do:
          find first b-invent where 
                     b-invent.it-codigo = input frame {&frame-name} inventario.it-codigo and 
                     b-invent.lote      = input frame {&frame-name} inventario.lote no-lock no-error.
          if avail b-invent then
             assign da-vali-lote:screen-value in frame {&frame-name} = string(b-invent.dt-ult-entra).
       end.
    end.

    if available item and item.tipo-con-est >= 3 and input frame {&frame-name} da-vali-lote = ? and
       (inventario.it-codigo:sensitive in frame {&frame-name} = yes) then do:
       enable da-vali-lote with frame {&frame-name}.
    end.
    else do:
       disable da-vali-lote with frame {&frame-name}.
    end.
  end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inventario.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF inventario.it-codigo IN FRAME f-main /* Item */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME inventario.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inventario.lote V-table-Win
ON LEAVE OF inventario.lote IN FRAME f-main /* Lote/S‚rie */
DO:

if avail item-uni-estab then do: 
  /* BUSCA SALDO DE ESTOQUE REFERENTE AO REGISTRO DE INVENTARIO */
  if item-uni-estab.loc-unica then 
     find first saldo-estoq use-index estabel-dep where 
                saldo-estoq.cod-estabel = input frame {&frame-name} inventario.cod-estabel and
                saldo-estoq.cod-depos   = input frame {&frame-name} inventario.cod-depos and 
                saldo-estoq.cod-localiz = item-uni-estab.cod-localiz and 
                saldo-estoq.lote        = input frame {&frame-name} inventario.lote and
                saldo-estoq.it-codigo   = input frame {&frame-name} inventario.it-codigo and
                saldo-estoq.cod-refer   = input frame {&frame-name} inventario.cod-refer
          exclusive-lock no-error.
  else
     find first saldo-estoq use-index estabel-dep where 
                saldo-estoq.cod-estabel = input frame {&frame-name} inventario.cod-estabel and 
                saldo-estoq.cod-depos   = input frame {&frame-name} inventario.cod-depos and 
                saldo-estoq.cod-localiz = input frame {&frame-name} inventario.cod-localiz and 
                saldo-estoq.lote        = input frame {&frame-name} inventario.lote and 
                saldo-estoq.it-codigo   = input frame {&frame-name} inventario.it-codigo and
                saldo-estoq.cod-refer   = input frame {&frame-name} inventario.cod-refer
          exclusive-lock no-error.
  if avail saldo-estoq then do:
      assign da-vali-lote:screen-value in frame {&frame-name} = string(saldo-estoq.dt-vali-lote)
             inventario.cod-refer:screen-value in frame {&frame-name}  = saldo-estoq.cod-refer.
  end.
  else do:

     find first b-saldo use-index lote where 
                b-saldo.lote      = input frame {&frame-name} inventario.lote and 
                b-saldo.it-codigo = input frame {&frame-name} inventario.it-codigo no-lock no-error.
     if avail b-saldo then do:
        assign da-vali-lote:screen-value in frame {&frame-name} = string(b-saldo.dt-vali-lote)
               inventario.cod-refer:screen-value in frame {&frame-name}  = b-saldo.cod-refer.
     end.
     else do:
        find first b-invent where 
                   b-invent.it-codigo = input frame {&frame-name} inventario.it-codigo and 
                   b-invent.lote      = input frame {&frame-name} inventario.lote no-lock no-error.
        if avail b-invent then
           assign da-vali-lote:screen-value in frame {&frame-name} = string(b-invent.dt-ult-entra).
        if item.tipo-con-est = 4 then do:
           enable inventario.cod-refer with frame {&frame-name}.
        end.           
     end.
  end.

  if item.tipo-con-est >= 3 and input frame {&frame-name} da-vali-lote = ? then do:
     enable da-vali-lote with frame {&frame-name}.
  end.
  else do:
     disable da-vali-lote with frame {&frame-name}.
  end.

  find first saldo-estoq  where 
       saldo-estoq.it-codigo = input frame {&frame-name} inventario.it-codigo and
       saldo-estoq.lote      = input frame {&frame-name} inventario.lote no-lock no-error.

  if not avail saldo-estoq and item.tipo-con-est >= 3 then do:
      assign da-vali-lote:screen-value in frame {&frame-name} = ? .
      enable da-vali-lote with frame {&frame-name}.    
  end.

end.
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

 if inventario.it-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
 if inventario.cod-estabel:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
 if inventario.cod-depos:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
 if inventario.cod-localiz:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
 if c-un:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
 if inventario.cod-refer:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

{utp/ut-liter.i Validade_Lote * l}
assign da-vali-lote:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "inventario"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "inventario"}

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ). 

  disp i-nr-cont-tit with frame {&frame-name}.

  if l-desabilita then do:
     assign i-nr-contagem = i-nr-cont-ant.
     display dt-saldo-ant @ inventario.dt-saldo
             i-nr-contagem with frame {&frame-name}.
     apply 'leave' to inventario.dt-saldo in frame {&frame-name}.
     apply 'entry' to inventario.nr-ficha in frame {&frame-name}.
  end.

  assign de-valor      = 0
         de-valor-mat  = 0
         de-valor-mob  = 0
         de-valor-ggf  = 0
         i-nr-contagem = 1.

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

  /* Code placed here will execute PRIOR to standard behavior. */

  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

      run get-attribute ("ADM-NEW-RECORD").
      if return-value = "yes" then do:
         find b-inventario no-lock
              where b-inventario.dt-saldo    = input frame {&FRAME-NAME} inventario.dt-saldo    and
                    b-inventario.cod-estabel = input frame {&FRAME-NAME} inventario.cod-estabel and
                    b-inventario.cod-depos   = input frame {&FRAME-NAME} inventario.cod-depos   and
                    b-inventario.cod-localiz = input frame {&FRAME-NAME} inventario.cod-localiz and
                    b-inventario.lote        = input frame {&FRAME-NAME} inventario.lote        and
                    b-inventario.it-codigo   = input frame {&frame-name} inventario.it-codigo   and
                    b-inventario.cod-refer   = input frame {&frame-name} inventario.cod-refer
              no-error.
         if avail b-inventario then do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Inventario" *}
            run utp/ut-msgs.p (input "show",
                               input 1,
                               input RETURN-VALUE).
            apply "entry" to inventario.it-codigo in frame {&frame-name}.
            return error.
         end.
      end.   

    /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

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

  if not frame {&frame-name}:validate() then
     return 'adm-error':u.

  /* Ponha na pi-validate todas as valida¯´es */

  /* NÊo gravar nada no registro antes do dispatch do assign-record e nem na PI-validate. */

  /* Dispatch standard ADM method.        */

  /* Obrigat«ria para a Base Oracle */  

  if  adm-new-record 
      and avail inventario then 
      assign inventario.val-apurado = ?.
      assign l-desabilita  = yes
             l-atualiza    = yes
             i-nr-cont-ant = input frame {&frame-name} i-nr-contagem
             dt-saldo-ant  = input frame {&frame-name} inventario.dt-saldo.       

  find first param-estoq no-lock no-error.

  if not avail param-estoq then do:
     run utp/ut-msgs.p (input "show", 
                        input 1059, 
                        input "").
     /* Parametros do estoque ainda nÊo cadastrados */
     apply 'entry' to inventario.nr-ficha in frame {&frame-name}.
     return 'adm-error'.
  end. 

  if input frame {&frame-name} inventario.lote = "" and item.tipo-con-est = 2 then do:
          
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "Lote" *}
      run utp/ut-msgs.p (input "show", 
                         input 164, 
                         input RETURN-VALUE).
      apply 'entry' to inventario.lote in frame {&frame-name}.
      return 'adm-error'.
  end.
  
  if inventario.dt-saldo:sensitive in frame {&frame-name} = yes and
     inventario.nr-ficha:sensitive in frame {&frame-name} = yes then do:
     find first b-inventario where
                b-inventario.dt-saldo = input frame {&frame-name} inventario.dt-saldo and
                b-inventario.nr-ficha = input frame {&frame-name} inventario.nr-ficha
                no-lock no-error.
     if  avail b-inventario then 
         find first b-inventario where
                    b-inventario.dt-saldo    = input frame {&frame-name} inventario.dt-saldo and
                    b-inventario.cod-estabel = input frame {&frame-name} inventario.cod-estabel and
                    b-inventario.cod-depos   = input frame {&frame-name} inventario.cod-depos and
                    b-inventario.cod-localiz = input frame {&frame-name} inventario.cod-localiz and
                    b-inventario.lote        = input frame {&frame-name} inventario.lote and
                    b-inventario.it-codigo   = input frame {&frame-name} inventario.it-codigo and
                    b-inventario.cod-refer   = input frame {&frame-name} inventario.cod-refer and
                    rowid(b-inventario)     <> rowid(inventario)
                    no-lock no-error.

         if  avail b-inventario then do:
             {utp/ut-table.i mgind inventario 1}
             run utp/ut-msgs.p (input "show", input 1, input return-value).
             return 'adm-error'.
         end.
  end.

  if input frame {&frame-name} inventario.dt-saldo = ? then do:
     run utp/ut-msgs.p (input "show", 
                        input 4370, 
                        input "").
     /* data de saldo para inventariar deve ser diferente de branco */
     return 'adm-error'.
  end.

  if input frame {&frame-name} i-nr-contagem <= 0 and
     input frame {&frame-name} i-nr-contagem >= 4 then do:
     run utp/ut-msgs.p (input "show", 
                        input 4372,  /* Nßmero da contagem deve ser 1, 2 ou 3 */ 
                        input "").
     return 'adm-error'.
  end.

  for first estabelec 
      fields ( cod-estabel custo-contab nome ) 
      where estabelec.cod-estabel = input frame {&frame-name} inventario.cod-estabel
      no-lock:
  end.

  if not avail estabelec then do:
     run utp/ut-msgs.p (input "show", 
                        input 2061, 
                        input "").
     /* estabelecimento nÊo cadastrado */
     apply 'entry' to inventario.cod-estabel in frame {&frame-name}.
     return 'adm-error'.
  end.

  if not can-find(first deposito where 
                        deposito.cod-depos = input frame {&frame-name} inventario.cod-depos) then do:
      /* Dep¢sito nÆo cadastrado */
      run utp/ut-msgs.p (input "show", input 530, input "").
      apply 'entry':U to inventario.cod-depos in frame {&frame-name}.
     return 'adm-error'.
  end.

  for first item 
      fields ( it-codigo   cod-obsoleto tipo-contr   tipo-con-est loc-unica un
               cod-localiz desc-item    data-ult-ent data-ult-sai fraciona )
      where item.it-codigo = input frame {&frame-name} inventario.it-codigo
      no-lock:
  end.

  for first item-uni-estab where item-uni-estab.cod-estabel = input frame {&frame-name} inventario.cod-estabel
                             AND item-uni-estab.it-codigo   = input frame {&frame-name} inventario.it-codigo
      no-lock:
  end.

  if not avail item then do:
     /* Inicio -- Projeto Internacional */
     {utp/ut-liter.i "Item" *}
     run utp/ut-msgs.p (input "show", 
                        input 47, 
                        input RETURN-VALUE).
     /* item inexistente */
     return 'adm-error'.
  end.

  if  avail item then do:

      if  AVAIL item-uni-estab AND item-uni-estab.cod-obsoleto = 4 then do:
          run utp/ut-msgs.p (input "show", 
                             input 1779,  /* Item obsoleto.Confirma transa‡Æo?  */ 
                             input "").
          if return-value = "no" then do:
             return 'adm-error'.
             apply 'entry' to inventario.dt-saldo in frame {&frame-name}.
          end.
      end.

      if  item.tipo-contr = 4 then do:
          run utp/ut-msgs.p (input "show", 
                             input 4508, 
                             input "").
          /* Item nÆo pode ser consignado/debito direto */
          apply 'entry' to inventario.it-codigo in frame {&frame-name}.
          return 'adm-error'.
      end.

      if  item.tipo-con-est = 4 and item.tipo-contr <> 4 then do:
          for first referencia 
              fields (  )
              where referencia.cod-refer = input frame {&frame-name} inventario.cod-refer no-lock:
          end.
          if  not avail referencia then do:
              run utp/ut-msgs.p (input "show", 
                                 input 4539, 
                                 input "").
              /* Referˆncia nÆo cadastrada */
              apply 'entry' to inventario.cod-refer in frame {&frame-name}.
              return 'adm-error'.
          end.
      end.

      if  item.tipo-con-est >= 3 and input frame {&frame-name} da-vali-lote = ? then do:
          run utp/ut-msgs.p (input "show", 
                             input 4542, 
                             input "").
          /* Item ‚ controlado por lote ou referencia. data validade do lote dev ser informada*/
          apply 'entry' to da-vali-lote in frame {&frame-name}.
          return 'adm-error'.
      end.

      for first localizacao 
          fields (  )
          where localizacao.cod-estabel = input frame {&frame-name} inventario.cod-estabel 
            and localizacao.cod-depos   = input frame {&frame-name} inventario.cod-depos   
            and localizacao.cod-localiz = input frame {&frame-name} inventario.cod-localiz no-lock:
      end.

      if  not avail localizacao then do:
          run utp/ut-msgs.p (input "show", 
                             input 16001 , 
                             input "").
          /*localizacao nao cadastrada para o deposito/esabeleciment */
          apply 'entry' to inventario.cod-localiz in frame {&frame-name}.
          return 'adm-error'.
      end.

      if  item.tipo-con-est = 1
      and input frame {&frame-name} inventario.lote <> " " then do:
          run utp/ut-msgs.p (input "show", 
                           input 17880, 
                           input ""). 
          /* Item Nao ‚ Controlado por Lote ou Referencia - Lote deve ser Branco */
          apply 'entry' to inventario.lote in frame {&frame-name}.
         return 'adm-error'.
      end.

      if  AVAIL item-uni-estab AND item-uni-estab.loc-unica 
      and item-uni-estab.cod-localiz <> input frame {&frame-name} inventario.cod-localiz then do:
          assign l-localizacao = yes.
          run utp/ut-msgs.p (input "show", 
                             input 4898, 
                             input "").
          /* Item Possui Localizacao Unica Diferente da Localizacao Informada */
          return 'adm-error'.
      end.

      IF AVAIL item-uni-estab THEN DO:
         if  item-uni-estab.loc-unica then
             find first saldo-estoq use-index estabel-dep where
                        saldo-estoq.cod-estabel = input frame {&frame-name} inventario.cod-estabel and
                        saldo-estoq.cod-depos   = input frame {&frame-name} inventario.cod-depos and
                        saldo-estoq.cod-localiz = item-uni-estab.cod-localiz and
                        saldo-estoq.lote        = input frame {&frame-name} inventario.lote and
                        saldo-estoq.it-codigo   = input frame {&frame-name} inventario.it-codigo
                        exclusive-lock no-error.
         else
             find first saldo-estoq use-index estabel-dep where
                        saldo-estoq.cod-estabel = input frame {&frame-name} inventario.cod-estabel and
                        saldo-estoq.cod-depos   = input frame {&frame-name} inventario.cod-depos and
                        saldo-estoq.cod-localiz = input frame {&frame-name} inventario.cod-localiz and
                        saldo-estoq.lote        = input frame {&frame-name} inventario.lote and
                        saldo-estoq.it-codigo   = input frame {&frame-name} inventario.it-codigo
                        exclusive-lock no-error.
      END.

      if  item.tipo-con-est <> 4 
      and avail saldo-estoq then
          assign saldo-estoq.cod-refer = input frame {&frame-name} inventario.cod-refer.

  end.

/******************** S¹ NA INCLUS°O DO INVENTµRIO ****************************/
if inventario.dt-saldo:sensitive in frame {&frame-name} = yes and
   inventario.nr-ficha:sensitive in frame {&frame-name} = yes then do:

     assign l-existe = yes
            i-sit    = 2.
     do on error undo,retry:
        find last b-invent use-index nr-ficha 
             where b-invent.dt-saldo = input frame {&frame-name} inventario.dt-saldo
             no-lock no-error.
        if  avail b-invent 
        and rowid(b-inventario) <> rowid(inventario) then do: /* Obrigat«rio para Base Oracle */
           if b-invent.nr-ficha < 9999999 then do:
              if can-find (b-invent use-index nr-ficha where b-invent.dt-saldo =
                 input frame {&frame-name} inventario.dt-saldo and b-invent.nr-ficha = input frame {&frame-name} inventario.nr-ficha) then do:
                 run utp/ut-msgs.p (input "show", 
                                    input 4515, 
                                    input "").
                 if return-value = "no" then
                    return 'adm-error'.
              end.
           end.
           else do:
                 run utp/ut-msgs.p (input "show", 
                                    input 4491, /* mero de Ficha Excedeu 9.999.999. Nao e' Possivel Incluir mais Fichas. */ 
                                    input "").
                 return 'adm-error'.
                 assign l-atualiza = no.
           end.
        end.
     end.
end.
/* ******************  S¹ NA MODIFICAø°O DO INVENTµRIO  *************************/
  if inventario.dt-saldo:sensitive in frame {&frame-name} = no and
     inventario.nr-ficha:sensitive in frame {&frame-name} = no then do:
     assign l-existe = yes
            i-sit    = 1.
     run pi-valida-modificacao.
     if  return-value = "adm-error":U then
         return "adm-error":U.

  end.
  /* esta mensagem deve ocorrer independente de ser alteracao ou inclusÆo */
  if  avail item and item.tipo-contr = 2 /* Total */ then do:
      for first item-estab
          fields ( val-unit-mat-m[1] val-unit-mob-m[1] val-unit-ggf-m[1]
                   val-unit-mat-o[1] val-unit-mob-o[1] val-unit-ggf-o[1]
                   val-unit-mat-p[1] val-unit-mob-p[1] val-unit-ggf-p[1]
                   it-codigo         cod-estabel       deposito-pad      )
          where item-estab.it-codigo   = input frame {&frame-name} inventario.it-codigo 
            and item-estab.cod-estabel = input frame {&frame-name} inventario.cod-estabel no-lock:
      end.

      if (   not available item-estab 
          or (available item-estab and item-estab.val-unit-mat-m[1] +
                                       item-estab.val-unit-mob-m[1] +
                                       item-estab.val-unit-ggf-m[1] = 0 and estab-mat.custo-contab = 1) 
          or (available item-estab and item-estab.val-unit-mat-o[1] +
                                       item-estab.val-unit-mob-o[1] +
                                       item-estab.val-unit-ggf-o[1] = 0 and estab-mat.custo-contab = 2) 
          or (available item-estab and item-estab.val-unit-mat-p[1] +
                                       item-estab.val-unit-mob-p[1] +
                                       item-estab.val-unit-ggf-p[1] = 0 and estab-mat.custo-contab = 3))
      and input frame {&frame-name} de-valor-mat
        + input frame {&frame-name} de-valor-mob
        + input frame {&frame-name} de-valor-ggf = 0
      and input frame {&frame-name} de-valor <> inventario.qtidade-atu then
      do:
          if l-tem-nfe-aca = no then do:

                 run utp/ut-msgs.p (input "show",
                                    input 4554,
                                    input "").
                 /* Um dos valores deve ser maior que zero */
                 return 'adm-error'.
          end.
      end.
  end. /* avail item and item.tipo-contr = 2 */

/**************************************************************************/
  /* PROCESSA DADOS DO REGISTRO DE INVENTARIO CASO NECESSARIO */
  if l-atualiza then do:
      if avail item and item.tipo-con-est >= 3 then do:
         assign da-vali-lote = ?
                inventario.cod-refer  = "".
         if avail saldo-estoq then do:
            assign da-vali-lote = saldo-estoq.dt-vali-lote
                   inventario.cod-refer  = saldo-estoq.cod-refer.
         end.
         else do:
            find first b-saldo use-index lote where
                       b-saldo.lote      = input frame {&frame-name} inventario.lote and
                       b-saldo.it-codigo = input frame {&frame-name} inventario.it-codigo no-lock no-error.
            if avail b-saldo then
               assign da-vali-lote = b-saldo.dt-vali-lote
                      inventario.cod-refer  = b-saldo.cod-refer.
            else do:
               find first b-invent where
                    b-invent.it-codigo = input frame {&frame-name} inventario.it-codigo and
                    b-invent.lote      = input frame {&frame-name} inventario.lote no-lock no-error.
               if avail b-invent then
                  assign da-vali-lote = b-invent.dt-ult-entra.
            end.
         end.
      end.
      if not avail saldo-estoq then do:
         if avail item-uni-estab and item-uni-estab.loc-unica then do:
            create saldo-estoq.
            assign saldo-estoq.it-codigo   = input frame {&frame-name} inventario.it-codigo
                   saldo-estoq.cod-localiz = item-uni-estab.cod-localiz
                   saldo-estoq.cod-estabel = input frame {&frame-name} inventario.cod-estabel
                   saldo-estoq.cod-depos   = input frame {&frame-name} inventario.cod-depos
                   saldo-estoq.lote        = input frame {&frame-name} inventario.lote.
         end.
         else do:
            create saldo-estoq.
            assign saldo-estoq.it-codigo   = input frame {&frame-name} inventario.it-codigo
                   saldo-estoq.cod-localiz = input frame {&frame-name} inventario.cod-localiz
                   saldo-estoq.cod-estabel = input frame {&frame-name} inventario.cod-estabel
                   saldo-estoq.cod-depos   = input frame {&frame-name} inventario.cod-depos
                   saldo-estoq.lote        = input frame {&frame-name} inventario.lote.
         end.
      end.
      if avail item and item.tipo-con-est = 4 then
          assign saldo-estoq.cod-refer = input frame {&frame-name} inventario.cod-refer.
      if l-localizacao then do:
         find first b-invent use-index data-invent where
                    b-invent.dt-saldo    = input frame {&frame-name} inventario.dt-saldo and
                    b-invent.cod-estabel = input frame {&frame-name} inventario.cod-estabel and
                    b-invent.cod-depos   = input frame {&frame-name} inventario.cod-depos and
                    b-invent.cod-localiz = input frame {&frame-name} inventario.cod-localiz and
                    b-invent.lote        = input frame {&frame-name} inventario.lote and
                    b-invent.it-codigo   = input frame {&frame-name} inventario.it-codigo no-lock no-error.
         if avail b-invent then do:
            if b-invent.situacao = 1 then do:
               run utp/ut-msgs.p (input "show", 
                                  input 4493,  /*Invent˜rio j˜ atualizado */ 
                                  input "").
               return 'adm-error'.
            end.
            if b-invent.situacao = 3 then do:
               run utp/ut-msgs.p (input "show", 
                                  input 4494,  /* Invent˜rio j˜ est˜ OK */ 
                                  input "").
               return 'adm-error'.
            end.
         end.
      end.
      if avail inventario and input frame {&frame-name} i-nr-contagem > 1 and
         inventario.val-apurado[input frame {&frame-name} i-nr-contagem - 1] = ? then do:
         run utp/ut-msgs.p (input "show", 
                            input 4496,  /* Contagem anterior nÊo foi digitada */ 
                            input "").
          return 'adm-error'.
      end.

      if  avail inventario 
      and inventario.val-apurado[input frame {&frame-name} i-nr-contagem] <> ? then do:

         run utp/ut-msgs.p (input "show", 
                            input 4550,  /* Item j˜ digitado. Confirma atualiza¯Êo? */ 
                            input "").
         if return-value = "no" then do:
            return 'adm-error'.
         end.
      end.
     /* SOLICITA A QUANTIDADE APURADA DO REGISTRO DE INVENTARIO */
     if input frame {&frame-name} de-valor = ? then do:
        run utp/ut-msgs.p (input "show", 
                           input 4558, /* Quantidade apurada do item nÊo pode ser desconhecido */
                           input "").
        return 'adm-error'.
     end.


     if truncate(input frame {&frame-name} de-valor,0) <> input frame {&frame-name} de-valor
        and avail item and not item.fraciona then do:
        run utp/ut-msgs.p (input "show", 
                           input 4559, /* Item nÊo aceita quantidade fracionada */ 
                           input "").
        return 'adm-error'.
     end.

      if (input frame {&frame-name} de-valor <> 1  and
          input frame {&frame-name} de-valor <> 0)  and item.tipo-con-est = 2 then do:
          run utp/ut-msgs.p (input "show",
                             input 17875,
                             input "").
          return 'adm-error'.
     end.


     /* SOLICITA A UNIDADE DE MEDIDA DO ITEM */
     if avail item and item.un <> input frame {&frame-name} c-un then do:
        run utp/ut-msgs.p (input "show", 
                           input 1302, /* Unidade informada nÊo confere com a do item */ 
                           input "").
        return 'adm-error'.
     end.
     /* ASSUME VALORES DIGITADOS PELO USUARIO */
     assign r-registro = rowid(inventario).

   end.
   for first item-estab 
       fields ( val-unit-mat-m[1] val-unit-mob-m[1] val-unit-ggf-m[1]
                val-unit-mat-o[1] val-unit-mob-o[1] val-unit-ggf-o[1]
                val-unit-mat-p[1] val-unit-mob-p[1] val-unit-ggf-p[1]
                it-codigo         cod-estabel       deposito-pad      )
       use-index item 
       where item-estab.it-codigo   = input frame {&frame-name} inventario.it-codigo 
         and item-estab.cod-estabel = input frame {&frame-name} inventario.cod-estabel no-lock:
   end.
   if not avail item-estab then do:
      create item-estab.
      assign item-estab.it-codigo    = input frame {&frame-name} inventario.it-codigo
             item-estab.cod-estabel  = input frame {&frame-name} inventario.cod-estabel
             item-estab.deposito-pad = input frame {&frame-name} inventario.cod-depos.
      run pi-cria-tt-dados-smc.
   end.

   assign i-nr-contagem = input frame {&frame-name} i-nr-contagem
          de-valor-mat  = input frame {&frame-name} de-valor-mat
          de-valor-mob  = input frame {&frame-name} de-valor-mob
          de-valor-ggf  = input frame {&frame-name} de-valor-ggf
          da-vali-lote  = input frame {&frame-name} da-vali-lote
          de-valor      = input frame {&frame-name} de-valor.

   RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ).

   RUN pi-assign. /*Continua¯Êo do assign-statement*/

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

 assign l-desabilita  = no
        i-nr-cont-ant = 1
        dt-saldo-ant  = ?.
 disable de-valor-mat
         de-valor-mob
         de-valor-ggf with frame {&frame-name}.  
 assign i-nr-contagem:screen-value in frame {&frame-name} = "1".        

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */

  find first inventario where inventario.dt-saldo = input frame {&frame-name} inventario.dt-saldo and
                              inventario.nr-ficha = input frame {&frame-name} inventario.nr-ficha 
                              exclusive-lock no-error. 

  if inventario.situacao <> 1 then do:
     assign inventario.situacao    = 2
            inventario.val-apurado = ?
            inventario.valor-mat-m[1] = 0
            inventario.valor-mob-m[1] = 0
            inventario.valor-ggf-m[1] = 0
            inventario.valor-final    = 0
            inventario.dt-atualiza    = ?. /* qdo preenchido nao entra no ce0703 */
     find next inventario use-index nr-ficha no-lock no-error.
     if avail inventario then do:
        disp inventario.dt-saldo
             inventario.nr-ficha
             inventario.cod-estabel
             inventario.cod-depos
             inventario.cod-localiz
             inventario.it-codigo
             inventario.lote with frame {&frame-name}. 
     end.
     else if not available inventario then
        find prev inventario use-index nr-ficha no-lock no-error.
        if avail inventario then do:
           disp inventario.dt-saldo
                inventario.nr-ficha
                inventario.cod-estabel
                inventario.cod-depos
                inventario.cod-localiz
                inventario.it-codigo
                inventario.lote with frame {&frame-name}. 
        end.
     end.
  else do:
     run utp/ut-msgs.p (input "show",
                        input 4977,  /* Contagem nÆo pode ser eliminada, pois o registro jÿ foi atualizado */
                        input "").
     return 'adm-error'.

  end.


/*  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable V-table-Win 
PROCEDURE local-disable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable':U ) .

  disable all with frame {&frame-name}.

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

  if  l-msg-inventario
  and avail param-estoq then do:

      if  param-estoq.cons-invent   = 1 and inventario.situacao = 3 and 
          inventario.val-apurado[2] = ? and inventario.val-apurado[3] = ? and 
          inventario.val-apurado[1] = inventario.qtidade-atu then do:
          run utp/ut-msgs.p (input "show", input 15346,  /* Inventÿrio estÿ OK */ input "").
      end.
      if  param-estoq.cons-invent = 1   and inventario.situacao = 3 and 
          inventario.val-apurado[1] <> inventario.val-apurado[2] and 
          inventario.val-apurado[3] = ? and 
          inventario.val-apurado[2] = inventario.qtidade-atu then do:
          run utp/ut-msgs.p (input "show", input 15346,  /* Inventÿrio estÿ OK */ input "").
      end.
      if  inventario.situacao = 4 and 
          inventario.val-apurado[2] <> ? and 
          inventario.val-apurado[3] = ? and 
          inventario.val-apurado[1] <>  inventario.val-apurado[2] then do:
          run utp/ut-msgs.p (input "show", input 4555,  /* Valor apurado na 2a contagem n confere com a 1a */
                            input "").
      end.
      if  inventario.situacao = 4 and
          inventario.val-apurado[3] <> ? and
          inventario.val-apurado[1] <>  inventario.val-apurado[3] then do:
          run utp/ut-msgs.p (input "show", input 7337,  /* Valor apurado na 3a contagem n confere com a 1a */
                             input "").
      end.

      assign l-msg-inventario = no.

  end.


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

  /* Dispatch standard ADM method.                             */

  disp i-nr-cont-tit with frame {&frame-name}.

  if avail inventario then do:
     for first estabelec 
         fields ( cod-estabel custo-contab nome ) 
         where estabelec.cod-estabel = inventario.cod-estabel
         no-lock:
     end.

     if  avail estabelec then 
         assign c-desc-estab = estabelec.nome.
     else 
        assign c-desc-estab = "".

     for first item 
         fields ( it-codigo   cod-obsoleto tipo-contr   tipo-con-est loc-unica un
                  cod-localiz desc-item    data-ult-ent data-ult-sai fraciona )
         where item.it-codigo = inventario.it-codigo
         no-lock:
     end.
     if avail item then 
        assign c-desc-item = item.desc-item
               c-un = item.un.
     else 
        assign c-desc-item = "".

     find deposito where deposito.cod-depos = inventario.cod-depos no-lock no-error.
     if avail deposito then 
        assign c-desc-depos = deposito.nome.
     else 
        assign c-desc-depos = "".

/*     assign c-desc-depos = "".*/

     assign da-vali-lote  = inventario.dt-ult-entra
            de-valor-mat  = inventario.valor-mat-m[1]
            de-valor-mob  = inventario.valor-mob-m[1]
            de-valor-ggf  = inventario.valor-ggf-m[1]
            de-valor      = inventario.val-apurado[1]
            i-nr-contagem:screen-value in frame {&frame-name} = string(i-nr-contagem).        

/*  def var i-opcao as int no-undo.
 * 
 *   assign i-opcao = input frame {&frame-name} i-nr-contagem.
 * 
 *   if  avail inventario then do:
 * 
 *      assign da-vali-lote  = inventario.dt-ult-entra
 *             de-valor-mat  = valor-mat-m[i-opcao]
 *             de-valor-mob  = valor-mob-m[i-opcao]
 *             de-valor-ggf  = valor-ggf-m[i-opcao]
 *             de-valor      = val-apurado[i-opcao]
 *             /*i-nr-contagem = input frame {&frame-name} i-nr-contagem.*/
 *             i-nr-contagem:screen-value in frame {&frame-name} = string(i-nr-contagem).
 *   end.    */

  end.  

  assign de-valor = ?.

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

  for first item 
      fields ( it-codigo   cod-obsoleto tipo-contr   tipo-con-est loc-unica un
               cod-localiz desc-item    data-ult-ent data-ult-sai fraciona )
      where item.it-codigo = inventario.it-codigo
      no-lock:
  end.

  if available item then 
    assign c-un = item.un.

  if avail inventario and inventario.nr-ficha:sensitive in frame {&frame-name} = yes then do:
      if avail item and item.tipo-con-est < 3 then do:
          assign da-vali-lote:sensitive in frame {&frame-name}    = no 
                 inventario.lote:sensitive in frame {&frame-name} = no
                 inventario.cod-refer:sensitive in frame {&frame-name}     = no.   
      end. 
      else if avail item and item.tipo-con-est = 3 then 
          assign da-vali-lote:sensitive in frame {&frame-name}    = yes
                 inventario.lote:sensitive in frame {&frame-name} = yes
                 inventario.cod-refer:sensitive in frame {&frame-name}     = no.
      else if avail item and item.tipo-con-est <> 2 then
          assign da-vali-lote:sensitive in frame {&frame-name}    = yes
                 inventario.lote:sensitive in frame {&frame-name} = yes
                 inventario.cod-refer:sensitive in frame {&frame-name}     = yes.         
  end.
  if avail inventario and 
     inventario.it-codigo:sensitive in frame {&frame-name} = no then do:
      apply "leave" to inventario.it-codigo.
  end.
  if not adm-new-record and avail inventario then do:
      assign i-nr-contagem.
      if avail item and inventario.lote = "" then do:
         assign inventario.lote:sensitive in frame {&frame-name} = (item.tipo-con-est > 1)
                inventario.cod-refer:sensitive in frame {&frame-name}     = (item.tipo-con-est = 4).
      end.
  end.

  if  not adm-new-record and avail inventario then do:
      assign de-valor = ?.
      disp de-valor 
      with frame {&frame-name}.  
  end. 


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

   IF ERROR-STATUS:ERROR THEN do:
      assign error-status:error = no.    
   end.   

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  for first param-estoq 
      &if defined(bf_mat_fech_estab) &then
          fields ( cons-invent mensal-ate tp-fech ) 
      &else     
          fields ( cons-invent mensal-ate ) 
      &endif    
      no-lock:
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  {utp/ut-liter.i Nr_Contagem: * L}
  assign i-nr-cont-tit = return-value. 
  display i-nr-cont-tit with frame {&frame-name}.

  {utp/ut-liter.i Quantidade_Apurada * L}
  assign de-valor:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Unid_Medid * L}
  assign c-un:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Valor_Material * L}
  assign de-valor-mat:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Valor_MÆo-de-Obra * L}
  assign de-valor-mob:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Valor_GGF * L}
  assign de-valor-ggf:label in frame {&frame-name} = return-value.


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-assign V-table-Win 
PROCEDURE pi-assign :
/*------------------------------------------------------------------------------
  Purpose:     Devido a falta de espa‡o na procedure
  Parameters:  
  Notes:       Continua‡Æo do assign-statement
------------------------------------------------------------------------------*/

/*continua‡Æo...*/

    assign  inventario.situacao                   = i-sit
            inventario.dt-ult-entra               = if avail item and item.tipo-con-est < 3 
                                                    then item.data-ult-ent 
                                                    else ?
            inventario.dt-ult-saida               = if avail item 
                                                    then item.data-ult-sai
                                                    else ?
            inventario.val-apurado[i-nr-contagem] = de-valor.

    if avail item and item.tipo-con-est < 3 and avail inventario then 
        assign inventario.dt-ult-entra = inventario.dt-ult-entra.
    else 
        assign inventario.dt-ult-entra = da-vali-lote.

    if avail item 
    and de-valor <> inventario.qtidade-atu 
    and item.tipo-contr = 2 
    and (not available item-estab 
         or (available item-estab 
             and item-estab.val-unit-mat-m[1] 
               + item-estab.val-unit-mob-m[1] 
               + item-estab.val-unit-ggf-m[1] = 0)) then 

    do on error undo, retry:
        if l-tem-nfe-aca = no then do:

           if de-valor-mat + de-valor-mob + de-valor-ggf <> 0 then

              assign inventario.valor-mat-m[1] = de-valor-mat
                     inventario.valor-mob-m[1] = de-valor-mob
                     inventario.valor-ggf-m[1] = de-valor-ggf.
        end.
    end.

    if avail inventario then do:
       if avail item and item.tipo-con-est >= 3 and avail saldo-estoq then 
          assign saldo-estoq.dt-vali-lote = INPUT FRAME {&FRAME-NAME} da-vali-lote.
    end.

   /* ATUALIZA°€O SALDO NA DATA DO INVENTARIO - PADRAO */
   run cep/ce0799.p (input rowid(inventario)). 
   if i-nr-contagem = 1 then do:
     if inventario.val-apurado[1] = inventario.qtidade-atu and param-estoq.cons-invent = 1 then do:
        assign inventario.valor-final = inventario.val-apurado[1]
               inventario.situacao    = 3.

        for first item fields (it-codigo data-ult-con) 
            where item.it-codigo = inventario.it-codigo no-lock: end.
        if  item.data-ult-con <> inventario.dt-saldo then do:
            find current item exclusive-lock no-error.
            assign item.data-ult-con = inventario.dt-saldo.
            find current item no-lock no-error.
        end.

        for first item-uni-estab 
            fields ( it-codigo cod-estabel data-ult-con ) 
            where item-uni-estab.it-codigo   = item.it-codigo
              and item-uni-estab.cod-estabel = inventario.cod-estabel no-lock: end.
        if  avail item-uni-estab 
        and item-uni-estab.data-ult-con <> inventario.dt-saldo then do:
            find current item-uni-estab exclusive-lock no-error.
            assign item-uni-estab.data-ult-con = inventario.dt-saldo.
            find current item-uni-estab no-lock no-error.
        end.
     end.
     else do:
        assign inventario.situacao    = 4
               inventario.valor-final = 0.

        if (inventario.val-apurado[1] = inventario.val-apurado[2]) or
           (inventario.val-apurado[1] = inventario.val-apurado[3]) then 
            assign inventario.valor-final = inventario.val-apurado[1].
        else
           if inventario.val-apurado[2] <> ? and
             (inventario.val-apurado[2] = inventario.val-apurado[3]) then 
              assign inventario.valor-final = inventario.val-apurado[2].
           else
              if inventario.val-apurado[3] <> ? then 
                 assign inventario.valor-final = inventario.val-apurado[3].
     end.
  end.
  else do:
     if i-nr-contagem = 2 then do:
        if  inventario.val-apurado[2] = inventario.qtidade-atu and param-estoq.cons-invent = 1 then
            assign inventario.valor-final = inventario.val-apurado[2]
                   inventario.situacao    = 3.
        else do:
            assign inventario.situacao = 4
                   inventario.valor-final = 0.
            if inventario.val-apurado[2] = inventario.val-apurado[1] or 
               inventario.val-apurado[2] = inventario.val-apurado[3] then
               assign inventario.valor-final = inventario.val-apurado[2].
               else if inventario.val-apurado[3] <> ? then 
                       assign inventario.valor-final = inventario.val-apurado[3].
        end.
     end.
     else
         if i-nr-contagem = 3 then do:
            if inventario.val-apurado[3] = inventario.qtidade-atu and param-estoq.cons-invent = 1 then
               assign inventario.situacao    = 3
                      inventario.valor-final = inventario.val-apurado[3].
            else
               if inventario.val-apurado[1] <> inventario.val-apurado[2] then
                  assign inventario.valor-final = inventario.val-apurado[3]
                         inventario.situacao    = 4.
          end.
  end.   

  if i-nr-contagem > 1  then do i-cont = 1 to i-nr-contagem:
     if inventario.val-apurado[i-cont] = inventario.qtidade-atu and param-estoq.cons-invent = 1 then
        assign inventario.valor-final = inventario.val-apurado[i-cont]
               inventario.situacao    = 3.
  end.

  disable de-valor-mat
          de-valor-mob
          de-valor-ggf with frame {&frame-name}.  

  if  input frame {&frame-name} i-nr-contagem > 1 
  and avail inventario then do:
      assign inventario.valor-mat-m[input frame {&frame-name} i-nr-contagem] =
             input frame {&frame-name} de-valor-mat.

      assign inventario.valor-mob-m[input frame {&frame-name} i-nr-contagem] =
             input frame {&frame-name} de-valor-mob.

      assign inventario.valor-ggf-m[input frame {&frame-name} i-nr-contagem] =
             input frame {&frame-name} de-valor-ggf.             

  end. 

  /*apresenta as mensagens do invent rio (procedure local-disable-fields)*/
  assign l-msg-inventario = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados-smc V-table-Win 
PROCEDURE pi-cria-tt-dados-smc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   /*****[ Gera‡Æo de Transa‡Æo Multiplanta Especifica do SMC ]******/
        for each tt-smc-item-estab:
            delete tt-smc-item-estab.
        end.
        assign  c-transacao = "SMC024"
                i-tipo-movto = 1.
        {cdp/cd7300.i5 "001" c-transacao "-SMC"}

        if  param-global.modulo-mp
        and tt-replica-msg-SMC.log-replica-msg  = yes
        then do:
            create  tt-smc-item-estab.
            buffer-copy item-estab to tt-smc-item-estab.
            create  tt-dados-env-SMC.
            assign  tt-dados-env-SMC.num-sequencia  = i-seq
                    tt-dados-env-SMC.cod-tipo-reg   = 281
                    tt-dados-env-SMC.ind-tipo-movto = i-tipo-movto
                    tt-dados-env-SMC.identif-msg    = item-estab.cod-estabel + " , " +
                                                      item-estab.it-codigo.
            raw-transfer tt-smc-item-estab to tt-dados-env-SMC.conteudo-msg.
            assign i-seq = i-seq + 1.
        end.

        {cdp/cd7300.i6 "001" c-transacao "-SMC"}
   /***[Fim da Gera‡Æo de Transa‡Æo Multiplanta Especifica do SMC]***/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-modificacao V-table-Win 
PROCEDURE pi-valida-modificacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     if avail item and item.tipo-con-est >= 3 and
        input frame {&frame-name} i-nr-contagem   = 1 and
        l-existe = yes and
        input frame {&frame-name} inventario.lote = "" then do:
        run utp/ut-msgs.p (input "show", input 4478,  /* Item e' controlado por Lote ou Referencia - Lote nao deve ser branco */ input "").
        apply 'entry' to inventario.lote in frame {&frame-name}.
        return 'adm-error'.
     end.
     if avail inventario then do:
         if avail item and item.tipo-con-est >= 3 and avail saldo-estoq then
            assign saldo-estoq.dt-vali-lote = INPUT FRAME {&FRAME-NAME} da-vali-lote.
     end.
      /* VERIFICA SITUACAO DA FICHA DE INVENTARIO */
      if avail inventario and inventario.situacao = 1 then do:
         run utp/ut-msgs.p (input "show", input 4493,  /*Invent rio j  atualizado */ input "").
         return 'adm-error'.
      end.
      if avail inventario and inventario.situacao = 3 then do:
         run utp/ut-msgs.p (input "show", input 4494,  /*Invent rio j  est  OK */ input "").
         return 'adm-error'.
      end.

      if avail inventario then do:
         if (inventario.situacao = 4 and inventario.valor-final <> 0) or
            (inventario.situacao = 4 and inventario.val-apurado[1] = 0 and inventario.val-apurado[2] = 0) or
            (inventario.situacao = 4 and inventario.val-apurado[3] = 0) then do:
             run utp/ut-msgs.p (input "show", input 4495,  /*Invent rio j  est  OK para atualizar */ input "").
             return 'adm-error'.
         end.
      end.

END PROCEDURE.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡„es, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicionÿrio */

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
  {src/adm/template/snd-list.i "inventario"}

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

