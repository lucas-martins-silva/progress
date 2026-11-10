&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V81IN172 2.00.00.012 } /*** "010012" ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v81in172 MUT}
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
{cep/ce1234.i} /* Ajuste de Decimais - Chile */
{include/i_fnctrad.i}
/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def buffer b-movto for movto-estoq.
def buffer b-saldo for saldo-estoq.
def buffer b-item for item.
def buffer b-movto-estoq for movto-estoq.

/*def new shared var c-tipo as integer no-undo.
def new shared var de-medio-mat   as dec decimals 4 extent 3
                         format ">>>,>>>,>>9.9999" init 0.
def new shared var de-medio-mob like de-medio-mat.
def new shared var de-medio-ggf like de-medio-mat.
def new shared var r-conta as rowid no-undo.
def new shared var da-inipa-x like movto-estoq.dt-trans.
def new shared var c-serie1      like movto-estoq.serie-docto.
def new shared var i-docto1      like movto-estoq.nro-docto.
def new shared var c-it-codigo   like item.it-codigo.*/

def new shared var i-emp050      as char format "x(3)".
def new shared var i-cta050      as char format "x(20)".
def new shared var i-sbc050      as char format "x(20)".
def new shared var cg-tipo-z       as character.
def new shared var cg-sis-z        as character.

def temp-table tt-param
    field tipo       as integer 
    field medio-mat as dec decimals 4 extent 3 format ">>>,>>>,>>9.9999"
    field medio-mob as dec decimals 4 extent 3 format ">>>,>>>,>>9.9999"
    field medio-ggf as dec decimals 4 extent 3 format ">>>,>>>,>>9.9999"
    field ct-conta     like item.ct-codigo 
    field sc-conta     like item.sc-codigo
    field da-inipa-x   like movto-estoq.dt-trans
    field depos-pad    like movto-estoq.cod-depos
    field serie1       like movto-estoq.serie-docto
    field docto1       like movto-estoq.nro-docto
    field it-codigo    like item.it-codigo
    field parametro    as char format "x(30)".


Def var c-lista          as char no-undo.
def var de-aux           like saldo-terc.valor extent 0 no-undo.
def var i-mo-fasb        as integer no-undo.
def var i-mo-cmi         as integer no-undo.
def var c-opcao          as character no-undo.
def var l-tipo           as logical extent 2.
def var l-resp           as l no-undo format "Sim/Nao".
def var l-param          as l no-undo.
def var de-quant-ini   like saldo-estoq.qtidade-ini init 0.
def var de-vl-mat      like movto-estoq.valor-mat-m.
def var de-vl-mob      like de-vl-mat.
def var da-data          as date.
def var i-cont           as integer.
def var i-y              as int.
def var i-x              as int.
def var i-quantidade     as int.
def var i-ano-corrente   as integer   no-undo.
def var i-per-corrente   as integer   no-undo.
def var de-quant      as dec format "->>>,>>>,>>>,>>9.99" init 0.
def var de-mat      like item-estab.sald-ini-mat-m.
def var de-mob      like item-estab.sald-ini-mob-m.
def var i-moeda       as integer init 0 no-undo.
def var da-maior-dt   as date no-undo.
def var l-erro-x      as logical init no no-undo.
def new shared var r-registro as rowid.
def var c-lista-itens as char format "x(100)".
def var l-nota-ft as logical no-undo.
def var i-aux as integer no-undo.
def var i-aux-2 as integer no-undo.
def var da-ini-periodo as date no-undo.
def var da-fim-periodo as date no-undo.
def var da-iniper-fech as date no-undo.
def var da-fimper-fech as date no-undo.
def var da-ult-fech-dia like param-estoq.ult-fech-dia no-undo.
def var da-ult-per      like param-estoq.ult-per-fech no-undo.
def var p-h-cadsi2      as handle.
DEF VAR v_msg_1 AS CHAR NO-UNDO.

def var h_api_cta          as handle no-undo.
def var h_api_ccust        as handle no-undo.

def var p_cod_format_cta_ctbl AS CHAR no-undo.
def var p_cod_format_ccusto AS CHAR no-undo.
def var v_cod_cta_ctbl AS CHAR no-undo.
def var v_des_cta_ctbl AS CHAR no-undo.
def var v_num_tip_cta_ctbl AS INTEGER no-undo.
def var v_num_sit_cta_ctbl AS INTEGER no-undo.
def var v_ind_finalid_cta AS CHAR no-undo.
def var v_des_ccusto AS CHAR no-undo.
def var v_cod_ccusto AS CHAR no-undo.
def var sc-conta like item.sc-codigo no-undo.
def var c-conta like item.ct-codigo no-undo.

run prgint/utb/utb743za.py persistent set h_api_cta.
run prgint/utb/utb742za.py persistent set h_api_ccust.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Nﬂmero" column-label "Nﬂmero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¨ncia".

def temp-table tt-item-2 no-undo like item use-index codigo.
def var i-empresa like param-global.empresa-prin no-undo.
def var c-estab like item.cod-estabel no-undo.
def var v_log_utz_ccusto as log no-undo.

/*contab recebimento*/
def var i-tipo-contr-old like item.tipo-contr no-undo.
def var h-boin01019      as handle            no-undo.

{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key RECT-10 RECT-9 RECT-1 
&Scoped-Define DISPLAYED-FIELDS item.it-codigo item.desc-item ~
item.ge-codigo item.fm-codigo item.un item.tipo-contr 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS c-desc-grupo c-desc-familia c-desc-tab ~
cb-parametro ct-codigo c-titulo sc-codigo sc-titulo c-serie i-docto ~
c-depos-pad c-desc-dep de-medio-mat1 de-medio-mob1 de-medio-ggf1 ~
de-medio-mat2 de-medio-mob2 de-medio-ggf2 de-medio-mat3 de-medio-mob3 ~
de-medio-ggf3 c-label c-tit-mob c-tit-ggf c-tit-mat 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS cb-parametro c-serie i-docto c-depos-pad ~
de-medio-mat1 de-medio-mob1 de-medio-ggf1 de-medio-mat2 de-medio-mob2 ~
de-medio-ggf2 de-medio-mat3 de-medio-mob3 de-medio-ggf3 sc-codigo ct-codigo 

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
DEFINE VARIABLE cb-parametro AS CHARACTER FORMAT "X(30)":U INITIAL "0" 
     LABEL "" 
     VIEW-AS COMBO-BOX 
     DROP-DOWN-LIST
     SIZE 16.14 BY 1 NO-UNDO.

DEFINE VARIABLE c-depos-pad AS CHARACTER FORMAT "X(3)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-dep AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-familia AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-grupo AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tab AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-label AS CHARACTER FORMAT "X(18)":U 
      VIEW-AS TEXT 
     SIZE 15.86 BY .63 NO-UNDO.

DEFINE VARIABLE c-serie AS CHARACTER FORMAT "X(5)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-ggf AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8.86 BY .54 NO-UNDO.

DEFINE VARIABLE c-tit-mat AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11.43 BY .5 NO-UNDO.

DEFINE VARIABLE c-tit-mob AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13.57 BY .5 NO-UNDO.

DEFINE VARIABLE c-titulo AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 34.72 BY .88 NO-UNDO.

DEFINE VARIABLE ct-codigo AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY .88 NO-UNDO.

DEFINE VARIABLE de-medio-ggf1 AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-medio-ggf2 AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-medio-ggf3 AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-medio-mat1 AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-medio-mat2 AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-medio-mat3 AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-medio-mob1 AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-medio-mob2 AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-medio-mob3 AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE i-docto AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY .88 NO-UNDO.

DEFINE VARIABLE sc-codigo AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY .88 NO-UNDO.

DEFINE VARIABLE sc-titulo AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 34.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 4.13.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.5.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 4.38.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.it-codigo AT ROW 1.17 COL 6.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     item.desc-item AT ROW 1.17 COL 24.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 62 BY .88
     item.ge-codigo AT ROW 2.63 COL 30.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     c-desc-grupo AT ROW 2.63 COL 34.57 COLON-ALIGNED NO-LABEL
     item.fm-codigo AT ROW 3.63 COL 30.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-desc-familia AT ROW 3.63 COL 43.29 COLON-ALIGNED NO-LABEL
     item.un AT ROW 4.63 COL 30.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     c-desc-tab AT ROW 4.63 COL 36.29 COLON-ALIGNED NO-LABEL
     cb-parametro AT ROW 6.29 COL 69 COLON-ALIGNED
     item.tipo-contr AT ROW 6.5 COL 2.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "F°sico", 1,
"Total", 2,
"Consignado", 3,
"DÇbito Direto", 4
          SIZE 54.43 BY .75
     ct-codigo AT ROW 7.83 COL 30.43 COLON-ALIGNED
     c-titulo AT ROW 7.83 COL 51.29 COLON-ALIGNED NO-LABEL
     sc-codigo AT ROW 8.83 COL 30.43 COLON-ALIGNED
     sc-titulo AT ROW 8.83 COL 51.29 COLON-ALIGNED NO-LABEL
     c-serie AT ROW 9.83 COL 30.43 COLON-ALIGNED
     i-docto AT ROW 9.83 COL 51.29 COLON-ALIGNED
     c-depos-pad AT ROW 10.83 COL 30.43 COLON-ALIGNED
     c-desc-dep AT ROW 10.83 COL 36.57 COLON-ALIGNED NO-LABEL
     de-medio-mat1 AT ROW 13 COL 20 COLON-ALIGNED
     de-medio-mob1 AT ROW 13 COL 42 COLON-ALIGNED NO-LABEL
     de-medio-ggf1 AT ROW 13 COL 64 COLON-ALIGNED NO-LABEL
     de-medio-mat2 AT ROW 14 COL 20 COLON-ALIGNED
     de-medio-mob2 AT ROW 14 COL 42 COLON-ALIGNED NO-LABEL
     de-medio-ggf2 AT ROW 14 COL 64 COLON-ALIGNED NO-LABEL
     de-medio-mat3 AT ROW 15 COL 20 COLON-ALIGNED
     de-medio-mob3 AT ROW 15 COL 42 COLON-ALIGNED NO-LABEL
     de-medio-ggf3 AT ROW 15 COL 64 COLON-ALIGNED NO-LABEL
     c-label AT ROW 5.79 COL 33.29 COLON-ALIGNED NO-LABEL
     c-tit-mob AT ROW 12.04 COL 45.86 COLON-ALIGNED NO-LABEL
     c-tit-ggf AT ROW 12.04 COL 70.43 COLON-ALIGNED NO-LABEL
     c-tit-mat AT ROW 12.13 COL 23.57 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     RECT-10 AT ROW 5.96 COL 1
     RECT-9 AT ROW 7.58 COL 1
     RECT-1 AT ROW 12.13 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
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
         HEIGHT             = 15.33
         WIDTH              = 88.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
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
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 15.33
       FRAME f-main:WIDTH            = 88.86.

/* SETTINGS FOR FILL-IN c-depos-pad IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN c-desc-dep IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-familia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-grupo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-tab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-serie IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN c-tit-ggf IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-mat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-mob IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-parametro IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-medio-ggf1 IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-medio-ggf2 IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-medio-ggf3 IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-medio-mat1 IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-medio-mat2 IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-medio-mat3 IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-medio-mob1 IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-medio-mob2 IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-medio-mob3 IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN item.desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.fm-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.ge-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-docto IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN item.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET item.tipo-contr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.un IN FRAME f-main
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

&Scoped-define SELF-NAME c-depos-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-pad V-table-Win
ON F5 OF c-depos-pad IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=c-depos-pad
                     &campo2=c-desc-dep
                     &campozoom=cod-depos
                     &campozoom2=c-desc-dep} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-pad V-table-Win
ON LEAVE OF c-depos-pad IN FRAME f-main
DO:
  {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=c-desc-dep
                   &where="deposito.cod-depos = input frame {&frame-name} 
                           c-depos-pad"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-pad V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-depos-pad IN FRAME f-main
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-parametro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-parametro V-table-Win
ON VALUE-CHANGED OF cb-parametro IN FRAME f-main
DO:
  enable ct-codigo sc-codigo c-serie i-docto c-depos-pad with frame {&frame-name}. 
  apply "entry" TO ct-codigo IN FRAME {&frame-name}.
  if {ininc/i09in122.i 06 cb-parametro:screen-value in frame {&frame-name}} = 2 then do:
      enable de-medio-mat1 de-medio-mob1 de-medio-ggf1 with frame {&frame-name}.
      if  param-estoq.tem-moeda1 then do with frame {&frame-name}: 
          enable de-medio-mat2 de-medio-mob2 de-medio-ggf2 with frame {&frame-name}.
      end.    
      if  param-estoq.tem-moeda2 then do with frame {&frame-name}: 
         enable de-medio-mat3 de-medio-mob3 de-medio-ggf3 with frame {&frame-name}.
      end.
  end.
  else 
     disable de-medio-mat1 de-medio-mob1 de-medio-ggf1 
             de-medio-mat2 de-medio-mob2 de-medio-ggf2
             de-medio-mat3 de-medio-mob3 de-medio-ggf3 with frame {&frame-name}. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-codigo V-table-Win
ON ENTRY OF ct-codigo IN FRAME f-main
DO:
  ASSIGN ct-codigo:FORMAT IN FRAME {&frame-name} = "x(20)".
  ENABLE sc-codigo WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-codigo V-table-Win
ON F5 OF ct-codigo IN FRAME f-main
DO:
   run pi_zoom_cta_ctbl_integr in h_api_cta (input  "",                 /* EMPRESA em branco busca a corrente do usu†rio */
                                             input  "CEP",              /* M‡DULO */         
                                             input  "",                 /* PLANO DE CONTAS */
                                             input  "(nenhum)",         /* FINALIDADES */    
                                             input  today,              /* DATA TRANSACAO */
                                             output v_cod_cta_ctbl,     /* CODIGO CONTA */   
                                             output v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                             output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                             output table tt_log_erro). /* ERROS */ 
   if p_cod_format_cta_ctbl = "" then
       run pi_retorna_formato_cta_ctbl in h_api_cta (input  "",                 /* EMPRESA em branco busca a corrente do usu†rio */
                                                     input  "",                 /* PLANO CONTAS */
                                                     input  TODAY, /* DATA DE TRANSACAO */
                                                     output p_cod_format_cta_ctbl,   /* FORMATO cta */
                                                     output table tt_log_erro). /* ERROS */

    assign ct-codigo:SCREEN-VALUE IN FRAME {&frame-name} = STRING(v_cod_cta_ctbl, p_cod_format_cta_ctbl)
            c-titulo:SCREEN-VALUE IN FRAME {&frame-name} = v_des_cta_ctbl.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-codigo V-table-Win
ON LEAVE OF ct-codigo IN FRAME f-main
DO:
  IF ct-codigo:SCREEN-VALUE <> "" THEN DO:
        ASSIGN ct-codigo:FORMAT IN FRAME {&frame-name} = "x(20)"
               c-conta = REPLACE (ct-codigo:SCREEN-VALUE, ".", "").
            RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        "",                      /* EMPRESA em branco busca a corrente do usu†rio */
                                                      INPUT        "",                      /* PLANO DE CONTAS */
                                                      INPUT-OUTPUT c-conta,                 /* CONTA */
                                                      INPUT        today,                   /* DATA TRANSACAO */   
                                                      OUTPUT       v_des_cta_ctbl,          /* DESCRICAO CONTA */
                                                      OUTPUT       v_num_tip_cta_ctbl,      /* TIPO DA CONTA */
                                                      OUTPUT       v_num_sit_cta_ctbl,      /* SITUAÄ«O DA CONTA */
                                                      OUTPUT       v_ind_finalid_cta,       /* FINALIDADES DA CONTA */
                                                      OUTPUT TABLE tt_log_erro).            /* ERROS */    

/*        run pi_zoom_cta_ctbl_integr in h_api_cta (input  "",                 /* EMPRESA em branco busca a corrente do usu†rio */*/
/*                                                  input  "CEP",              /* M‡DULO */             */
/*                                                  input  "",                 /* PLANO DE CONTAS */    */
/*                                                  input  "(nenhum)",         /* FINALIDADES */        */
/*                                                  input  today,              /* DATA TRANSACAO */     */
/*                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */       */
/*                                                  output v_des_cta_ctbl,     /* DESCRICAO CONTA */    */
/*                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */*/
/*                                                  output table tt_log_erro). /* ERROS */              */
                                                  
        IF RETURN-VALUE = "OK" THEN DO:
            ASSIGN ct-codigo:SCREEN-VALUE = c-conta
                   ct-codigo:FORMAT IN FRAME {&frame-name} = p_cod_format_cta_ctbl
                   c-titulo:SCREEN-VALUE IN FRAME {&frame-name} = v_des_cta_ctbl.
                   
            /* Verifica se a conta utiliza centro de custo */
            run pi_verifica_utilizacao_ccusto in h_api_ccust (input  "",                 /* EMPRESA em branco busca a corrente do usu†rio */
                                                              input  c-estab,            /* ESTABELECIMENTO EMS2 */
                                                              input  "",                 /* PLANO CONTAS */
                                                              input  c-conta,            /* CONTA */
                                                              input  today,              /* DT TRANSACAO */
                                                              output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                              output table tt_log_erro). /* ERROS */
                                                        
            IF v_log_utz_ccusto THEN DO:
                ENABLE sc-codigo WITH FRAME {&FRAME-NAME}.
            END.
            ELSE DO:
                ASSIGN sc-codigo:SCREEN-VALUE in frame {&FRAME-NAME} = "". 
                ASSIGN sc-titulo:SCREEN-VALUE in frame {&FRAME-NAME} = "".
                DISABLE sc-codigo WITH FRAME {&FRAME-NAME}.
            END.
                   
        END.
        ELSE do:
            ASSIGN ct-codigo:FORMAT IN FRAME {&frame-name} = p_cod_format_cta_ctbl
                   c-titulo:SCREEN-VALUE IN FRAME {&frame-name}= "".
       end.
    END.
    ELSE do: 
        ASSIGN ct-codigo:FORMAT IN FRAME {&frame-name} = "x(20)"
               c-titulo:SCREEN-VALUE IN FRAME {&frame-name}= "".
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ct-codigo IN FRAME f-main
DO:
   apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.fm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.fm-codigo V-table-Win
ON F5 OF item.fm-codigo IN FRAME f-main /* Fam°lia */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in122.w"
                   &tabela=item
                   &atributo=fm-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.fm-codigo V-table-Win
ON LEAVE OF item.fm-codigo IN FRAME f-main /* Fam°lia */
DO:
  {include/leave.i &tabela=familia
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-familia
                    &where="familia.fm-codigo = input frame {&frame-name} item.fm-codigo"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.fm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.fm-codigo IN FRAME f-main /* Fam°lia */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.ge-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.ge-codigo V-table-Win
ON F5 OF item.ge-codigo IN FRAME f-main /* Grupo Estoque */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in142.w"
                   &tabela=item
                   &atributo=ge-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.ge-codigo V-table-Win
ON LEAVE OF item.ge-codigo IN FRAME f-main /* Grupo Estoque */
DO:
  {include/leave.i &tabela=grup-estoque
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-grupo
                    &where="item.ge-codigo = input frame {&frame-name} item.ge-codigo"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.ge-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.ge-codigo IN FRAME f-main /* Grupo Estoque */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.it-codigo V-table-Win
ON F5 OF item.it-codigo IN FRAME f-main /* Item */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                   &tabela=item
                   &atributo=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.it-codigo V-table-Win
ON LEAVE OF item.it-codigo IN FRAME f-main /* Item */
DO:
  {include/leave.i &tabela=item
                    &atributo-ref=desc-item
                    &variavel-ref=item.desc-item
                    &where="item.it-codigo = input frame {&frame-name} item.it-codigo"}.

  assign item.ge-codigo:screen-value in frame {&frame-name} = string(item.ge-codigo) 
         item.fm-codigo:screen-value in frame {&frame-name} = string(item.fm-codigo) 
         c-depos-pad:screen-value in frame {&frame-name} = string(item.deposito-pad)
         item.un:screen-value in frame {&frame-name} = string(item.un).
  {include/leave.i &tabela=grup-estoque
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-grupo
                    &where="item.ge-codigo = input frame {&frame-name} item.ge-codigo"}.
  {include/leave.i &tabela=tab-unidade
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-tab
                   &where="tab-unidade.un = input frame {&frame-name} 
                           item.un"} 
  {include/leave.i &tabela=familia
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-familia
                    &where="familia.fm-codigo = input frame {&frame-name} item.fm-codigo"}.

  enable cb-parametro ct-codigo sc-codigo c-serie i-docto 
         c-depos-pad de-medio-mat1 de-medio-mob1 with frame {&frame-name}.                    
  if  param-estoq.tem-moeda1 then do with frame {&frame-name}: 
      enable de-medio-mat2 de-medio-mob2 with frame {&frame-name}.
  end.    
  if  param-estoq.tem-moeda2 then do with frame {&frame-name}: 
      enable de-medio-mat3 de-medio-mob3 with frame {&frame-name}.
  end.  
  apply "entry" TO cb-parametro IN FRAME {&frame-name}.
  return no-apply. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.it-codigo IN FRAME f-main /* Item */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-codigo V-table-Win
ON F5 OF sc-codigo IN FRAME f-main
DO:
   run pi_zoom_ccusto in h_api_ccust (input "",                  /* EMPRESA em branco busca a corrente do usu†rio */
                                      input "",                  /* CODIGO DO PLANO CCUSTO */
                                      input "",                  /* UNIDADE DE NEGOCIO */
                                      input today,               /* DATA DE TRANSACAO */
                                      output v_cod_ccusto,       /* CODIGO CCUSTO */
                                      output v_des_ccusto,       /* DESCRICAO CCUSTO */
                                      output table tt_log_erro). /* ERROS */ 
    
    if p_cod_format_ccusto = "" then 
        run pi_retorna_formato_ccusto in h_api_ccust (input  "",                    /* EMPRESA em branco busca a corrente do usu†rio */
                                                      input  "",                    /* PLANO CCUSTO */
                                                      input  TODAY,                 /* DATA DE TRANSACAO */
                                                      output p_cod_format_ccusto,   /* FORMATO CCUSTO */
                                                      output table tt_log_erro).    /* ERROS */
                                                  
   assign sc-codigo:SCREEN-VALUE IN FRAME {&frame-name} = STRING(v_cod_ccusto, p_cod_format_ccusto)
          sc-titulo:SCREEN-VALUE IN FRAME {&frame-name} = v_des_ccusto. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF sc-codigo IN FRAME f-main
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-codigo V-table-Win
ON LEAVE OF sc-codigo IN FRAME f-main
DO:
  IF sc-codigo:SCREEN-VALUE <> "" THEN DO:
        ASSIGN sc-codigo:FORMAT IN FRAME {&frame-name} = "x(20)"
               sc-conta = sc-codigo:SCREEN-VALUE.
        run pi_busca_dados_ccusto in h_api_ccust (input  "",                 /* EMPRESA em branco busca a corrente do usu†rio */
                                                  input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                  input  sc-conta,           /* CCUSTO */
                                                  input  today,              /* DATA DE TRANSACAO */
                                                  output v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                                  output table tt_log_erro). /* ERROS */

        if p_cod_format_ccusto = "" then 
            run pi_retorna_formato_ccusto in h_api_ccust (input  "",                    /* EMPRESA em branco busca a corrente do usu†rio */
                                                          input  "",                    /* PLANO CCUSTO */
                                                          input  TODAY,                 /* DATA DE TRANSACAO */
                                                          output p_cod_format_ccusto,   /* FORMATO CCUSTO */
                                                          output table tt_log_erro).    /* ERROS */
        IF RETURN-VALUE = "OK" THEN DO:
            ASSIGN sc-codigo:SCREEN-VALUE = sc-conta
                   sc-codigo:FORMAT IN FRAME {&frame-name} = p_cod_format_ccusto
                   sc-titulo:SCREEN-VALUE IN FRAME {&frame-name} = v_des_ccusto.
        END.
        ELSE do:
            ASSIGN sc-titulo:SCREEN-VALUE IN FRAME {&frame-name}= "".
       end.
    END.
    ELSE do: 
        ASSIGN sc-codigo:FORMAT IN FRAME {&frame-name} = "x(20)"
               sc-titulo:SCREEN-VALUE IN FRAME {&frame-name}= "".
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME item.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.un V-table-Win
ON F5 OF item.un IN FRAME f-main /* Unid Medid */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in417.w"
                   &tabela=item
                   &atributo=un}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.un V-table-Win
ON LEAVE OF item.un IN FRAME f-main /* Unid Medid */
DO:
  {include/leave.i &tabela=tab-unidade
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-tab
                   &where="tab-unidade.un = input frame {&frame-name} item.un"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.un V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.un IN FRAME f-main /* Unid Medid */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  if  item.it-codigo:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.
  if  item.un:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  if  item.ge-codigo:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  if  c-depos-pad:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  if  item.fm-codigo:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  if  ct-codigo:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  if  sc-codigo:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.


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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  disable triggers for load of item.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  if {ininc/i09in122.i 06 cb-parametro} = 2 or {ininc/i09in122.i 06 cb-parametro} = 3 then do: 
            assign ct-codigo:screen-value in frame {&FRAME-NAME} = ""
			       sc-codigo:screen-value in frame {&FRAME-NAME} = ""
                   c-titulo = ""
				   sc-titulo = ""
                   item.ct-codigo = ""
				   item.sc-codigo = "".        
  end.    

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
def var l-troca-ok as log no-undo.

do with frame {&frame-name} on error undo, return "adm-error":
  find first tt-param no-error.
  if not avail tt-param then 
      create tt-param.
  assign l-rejeita-dec         = no.    
  assign tt-param.medio-mat[1] = fn_vld_ajust_dec(input frame {&frame-name} de-medio-mat1,0).
  assign tt-param.medio-mat[2] = fn_vld_ajust_dec(input frame {&frame-name} de-medio-mat2,param-estoq.moeda1).
  assign tt-param.medio-mat[3] = fn_vld_ajust_dec(input frame {&frame-name} de-medio-mat3,param-estoq.moeda2).
  assign tt-param.medio-mob[1] = fn_vld_ajust_dec(input frame {&frame-name} de-medio-mob1,0).
  assign tt-param.medio-mob[2] = fn_vld_ajust_dec(input frame {&frame-name} de-medio-mob2,param-estoq.moeda1).
  assign tt-param.medio-mob[3] = fn_vld_ajust_dec(input frame {&frame-name} de-medio-mob3,param-estoq.moeda2).
  assign tt-param.medio-ggf[1] = fn_vld_ajust_dec(input frame {&frame-name} de-medio-ggf1,0).
  assign tt-param.medio-ggf[2] = fn_vld_ajust_dec(input frame {&frame-name} de-medio-ggf2,param-estoq.moeda1).
  assign tt-param.medio-ggf[3] = fn_vld_ajust_dec(input frame {&frame-name} de-medio-ggf3,param-estoq.moeda2).
  assign tt-param.depos-pad    = input frame {&frame-name} c-depos-pad
         tt-param.serie1       = input frame {&frame-name} c-serie
         tt-param.docto1       = input frame {&frame-name} i-docto
         tt-param.parametro    = input frame {&frame-name} cb-parametro. 
  disp tt-param.medio-mat[1] @ de-medio-mat1 
       tt-param.medio-mat[2] @ de-medio-mat2 
       tt-param.medio-mat[3] @ de-medio-mat3
       tt-param.medio-mob[1] @ de-medio-mob1 
       tt-param.medio-mob[2] @ de-medio-mob2 
       tt-param.medio-mob[3] @ de-medio-mob3
       tt-param.medio-ggf[1] @ de-medio-ggf1 
       tt-param.medio-ggf[2] @ de-medio-ggf2 
       tt-param.medio-ggf[3] @ de-medio-ggf3 with frame {&frame-name}.

  if l-rejeita-dec then do:
     run utp/ut-msgs.p (input "show",
                        input 18100,
                        input "").
     apply 'entry' to de-medio-mat1 in frame {&frame-name}.
     return 'adm-error':U.
  end.

  for each tt-item-2:
      delete tt-item-2.
  end.

  create tt-item-2.
  buffer-copy item to tt-item-2.

  /* Code placed here will execute PRIOR to standard behavior. */

  IF i-tipo-contr-old = 4 AND {ininc/i09in122.i 06 cb-parametro:screen-value in frame {&frame-name}} <> 4 THEN DO:

      IF NOT VALID-HANDLE(h-boin01019) THEN 
          RUN inbo/boin01019.p PERSISTENT SET h-boin01019.
      
      RUN verificaTrocaControleItDD IN h-boin01019 (INPUT  item.it-codigo,
                                                    OUTPUT l-troca-ok).
      
      IF VALID-HANDLE(h-boin01019) THEN DO:
          DELETE PROCEDURE h-boin01019.
          ASSIGN h-boin01019 = ?.
      END.

      IF NOT l-troca-ok THEN DO:
          
          RUN utp/ut-msgs.p (INPUT "show",
                             INPUT 851,
                             INPUT "").  
          APPLY 'entry' TO cb-parametro IN FRAME {&FRAME-NAME}.
          RETURN 'adm-error':U.
    
      END.

  END.  

  {utp/ut-liter.i Troca_de_controle_cont†bil_n∆o_permitida!_Item_de_contrato. mce R}
  ASSIGN v_msg_1 = RETURN-VALUE.

  FIND FIRST param-contrat NO-LOCK WHERE
             param-contrat.it-codigo = item.it-codigo NO-ERROR.
  IF AVAIL param-contrat THEN DO:
      RUN utp/ut-msgs.p (INPUT "show",
                         INPUT 17006,
                         INPUT v_msg_1).
      APPLY 'entry' TO cb-parametro IN FRAME {&FRAME-NAME}.
      RETURN 'adm-error':U.
  END.

  FOR EACH item-contrat NO-LOCK WHERE
           item-contrat.it-codigo = item.it-codigo and 
           item-contrat.ind-sit-item <> 3 AND
           item-contrat.ind-sit-item <> 4 :
      RUN utp/ut-msgs.p (INPUT "show",
                         INPUT 17006,
                         INPUT v_msg_1).
      APPLY 'entry' TO cb-parametro IN FRAME {&FRAME-NAME}.
      RETURN 'adm-error':U.
      /*LEAVE.*/
  END.
  find first param-global no-lock no-error.
  if not avail param-global then do:
    run utp/ut-msgs.p (input "show":U, 
                       input 16, 
                       input return-value).
    return 'ADM-ERROR':U.
  end.
  find first param-estoq no-lock no-error.
  if not avail param-estoq then do:
    run utp/ut-msgs.p (input "show":U, 
                       input 1059, 
                       input return-value).
    return 'ADM-ERROR':U.
  end.
  if input frame {&frame-name} item.it-codigo = "" and 
     item.tipo-contr =  4 then do:
      {utp/ut-liter.i DÇbito_direto}
      run utp/ut-msgs.p (input "show", 
                       input 32401 , 
                       input item.it-codigo + "~~" + return-value).
    return 'ADM-ERROR':U.
  end.
  if input frame {&frame-name} item.tipo-contr = cb-parametro:lookup(cb-parametro:screen-value) in frame {&frame-name} then do:
    run utp/ut-msgs.p (input "show", 
                       input 8951 , 
                       input return-value).
    return 'ADM-ERROR':U.
  end.    
  find param-fasb 
       where param-fasb.ep-codigo = i-empresa no-lock no-error .

  assign i-mo-fasb = if avail param-fasb and param-fasb.moeda-fasb <> 0 then 
                       if param-fasb.moeda-fasb = param-estoq.moeda1  then 2
                         else if param-fasb.moeda-fasb = param-estoq.moeda2 then 3
                              else 0
                     else 0
         i-mo-cmi  = if avail param-fasb and param-fasb.moeda-cmi <> 0 then
                       if param-fasb.moeda-cmi = param-estoq.moeda1 then 2
                         else if param-fasb.moeda-cmi = param-estoq.moeda2
                                then 3
                                else 0
                     else 0. 
  for each item-estab use-index item
      where item-estab.it-codigo = item.it-codigo no-lock:
    &if defined (bf_mat_fech_estab) &then
      if param-estoq.tp-fech = 2 then do:
         find estab-mat 
              where estab-mat.cod-estabel = item-estab.cod-estabel
              no-lock no-error.
         if avail estab-mat then
            assign da-ult-fech-dia = estab-mat.ult-fech-dia.
      end.
      else
         assign da-ult-fech-dia = param-estoq.ult-fech-dia.
    &else
        assign da-ult-fech-dia = param-estoq.ult-fech-dia.
    &endif

    find first movto-estoq use-index item-data 
         where movto-estoq.it-codigo = item.it-codigo  and
               movto-estoq.dt-trans  > da-ult-fech-dia and
               movto-estoq.esp-docto = 25  no-lock no-error.
    if avail movto-estoq then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 3242, 
                         input return-value).
      return 'ADM-ERROR':U.
    end.

    if item-estab.sald-ini-mat-m[1] < 0 or
       item-estab.sald-ini-mat-m[2] < 0 or
       item-estab.sald-ini-mat-m[3] < 0 or
       item-estab.sald-ini-mob-m[1] < 0 or
       item-estab.sald-ini-mob-m[2] < 0 or
       item-estab.sald-ini-mob-m[3] < 0 then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 3244, 
                         input return-value).
      return 'ADM-ERROR':U.
    end.
  end.
  for each saldo-estoq use-index item
      where saldo-estoq.it-codigo = item.it-codigo no-lock:
    if saldo-estoq.qtidade-ini < 0 then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 3244, 
                         input return-value).
      return 'ADM-ERROR':U.
    end.
  end.
  {utp/ut-liter.i Verificando_Notas_n∆o_Confirmadas_no_Faturamento... mce R}
  status input return-value.

  /* Verifica Notas nao Confirmadas no Faturamento */
  if param-global.modulo-ft then do:
    assign l-nota-ft = no.

    for each it-nota-fisc where it-nota-fisc.it-codigo = item.it-codigo and
             it-nota-fisc.dt-confirma = ? no-lock :
      find nota-fiscal where nota-fiscal.cod-estabel = it-nota-fisc.cod-estabel and
                             nota-fiscal.serie       = it-nota-fisc.serie       and
                             nota-fiscal.nr-nota-fis = it-nota-fisc.nr-nota-fis
                             no-lock no-error.
      if avail nota-fiscal then 
        if nota-fiscal.dt-cancela <> ? then next.
      else do:
        assign l-nota-ft = yes.
        leave.
      end.
    end.
    if l-nota-ft = no then 
      for each pre-fatur where pre-fatur.cod-sit-pre <> 3 no-lock:
        for each it-pre-fat where it-pre-fat.cdd-embarq   = pre-fatur.cdd-embarq   and
                                  it-pre-fat.nome-abrev   = pre-fatur.nome-abrev   and
                                  it-pre-fat.nr-pedcli    = pre-fatur.nr-pedcli    and
                                  it-pre-fat.it-codigo    = item.it-codigo         no-lock:
          assign l-nota-ft = yes.
          leave.
        end.
      end.
    if l-nota-ft then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 25902, 
                         input return-value).
      return 'ADM-ERROR':U.        
    end.
  end.

  /* Se tiver alguma transacao NFT com valores zerados */
  find first movto-estoq  where movto-estoq.it-codigo      = item.it-codigo and
                                movto-estoq.dt-trans      >= da-inipa-x     and
                                movto-estoq.esp-docto      = 23             and
                                movto-estoq.valor-mat-m[1] = 0              and
                                movto-estoq.valor-mob-m[1] = 0              and
                                movto-estoq.valor-ggf-m[1] = 0 no-lock no-error.
  if avail movto-estoq then do:
    run utp/ut-msgs.p (input "show":U, 
                       input 3261, 
                       input return-value).
    return 'ADM-ERROR':U.
  end.  
  
  assign sc-conta = replace(sc-codigo:SCREEN-VALUE, ".","")
         c-conta = REPLACE (ct-codigo:SCREEN-VALUE, ".", "").

  run pi_busca_dados_cta_ctbl in h_api_cta (input        "",                 /* EMPRESA em branco busca a corrente do usu†rio */
                                            input        "",                 /* PLANO DE CONTAS */
                                            input-output c-conta,            /* CONTA */
                                            input        today,              /* DATA TRANSACAO */
                                            output       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                            output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                            output       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */
                                            output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                            output table tt_log_erro).       /* ERROS */

  find first tt_log_erro no-error.
  if avail tt_log_erro then do:
    run utp/ut-msgs.p (input "show":U, 
                       input 17006, 
                       STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
    return 'ADM-ERROR':U.
  end.
  if v_num_tip_cta_ctbl = 6 then do:
    run utp/ut-msgs.p (input "show":U,
                       input 286,
                       input return-value).
    return 'ADM-ERROR':U.
  end.
/*  if v_num_sit_cta_ctbl <> 3 then do:      */
/*    run utp/ut-msgs.p (input "show":U,     */
/*                       input 443,          */
/*                       input return-value).*/
/*    return 'ADM-ERROR':U.                  */
/*  end.                                     */

  if v_ind_finalid_cta = "" then do:
    run utp/ut-msgs.p (input "show":U,
                       input 445,
                       input return-value).
    return 'ADM-ERROR':U.
  end.
  if lookup({adinc/i05ad049.i 4 9}, v_ind_finalid_cta) <> 0 then do:
    run utp/ut-msgs.p (input "show":U,
                       input 1784,
                       input return-value).
    return 'ADM-ERROR':U.
  end.
  
  /* Verifica se a conta utiliza centro de custo */
  run pi_verifica_utilizacao_ccusto in h_api_ccust (input  "",                 /* EMPRESA em branco busca a corrente do usu†rio */
                                                    input  c-estab,            /* ESTABELECIMENTO EMS2 */
                                                    input  "",                 /* PLANO CONTAS */
                                                    input  c-conta,            /* CONTA */
                                                    input  today,              /* DT TRANSACAO */
                                                    output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                    output table tt_log_erro). /* ERROS */

  /* Se a conta usa centro de custo, busca centro de custo e valida, senao fica em branco "" */ 
  if v_log_utz_ccusto then do:
      run pi_busca_dados_ccusto in h_api_ccust (input  "",                 /* EMPRESA em branco busca a corrente do usu†rio */
                                                input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                input  sc-conta,           /* CCUSTO */
                                                input  today,              /* DATA DE TRANSACAO */
                                                output v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                                output table tt_log_erro). /* ERROS */
    
      find first tt_log_erro no-error.
      if avail tt_log_erro then do:
		run utp/ut-msgs.p (input "show":U, 
						   input 17006, 
						   STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
        return 'ADM-ERROR':U.
      end.
  end.
  else
      assign sc-codigo:SCREEN-VALUE = "".
  
  assign item.ct-codigo = input frame {&frame-name} ct-codigo
         item.sc-codigo = input frame {&frame-name} sc-codigo
         tt-param.ct-conta     = c-conta
         tt-param.sc-conta     = sc-conta
         tt-param.it-codigo   = item.it-codigo.

  find deposito where deposito.cod-depos = input frame {&frame-name} c-depos-pad 
                      no-lock no-error.
  if not avail deposito then do:
    run utp/ut-msgs.p (input "show":U, 
                       input 530, 
                       input return-value).
    return 'ADM-ERROR':U.
  end.   
  if deposito.ind-dep-cq = yes and item.contr-qualid then do:
    run utp/ut-msgs.p (input "show":U, 
                       input 1210, 
                       input return-value).
    return 'ADM-ERROR':U.
  end.   
  if deposito.ind-dep-rej = yes and item.contr-qualid then do:
    run utp/ut-msgs.p (input "show":U, 
                       input 1217, 
                       input return-value).
    return 'ADM-ERROR':U.
  end.   
  for each item-estab where item-estab.it-codigo = item.it-codigo no-lock:
    find estabelec where estabelec.cod-estabel = item-estab.cod-estabel no-lock no-error.
    if not avail estabelec then 
      next.

    if estabelec.deposito-cq = c-depos-pad and item.contr-qualid then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 1210, 
                         input return-value).
      return 'ADM-ERROR':U.
    end.    
    if estabelec.dep-rej-cq = c-depos-pad and item.contr-qualid then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 1217, 
                         input return-value).
      return 'ADM-ERROR':U.
    end.
  end. 
  if (item.tipo-contr = 1 and 
     {ininc/i09in122.i 06 cb-parametro:screen-value in frame {&frame-name}} = 2) or
     (item.tipo-contr = 3 and 
     {ininc/i09in122.i 06 cb-parametro:screen-value in frame {&frame-name}} = 2) or  
     (item.tipo-contr = 4 and 
     {ininc/i09in122.i 06 cb-parametro:screen-value in frame {&frame-name}} = 2) then do:

    if item.tipo-contr = 3 and {ininc/i09in122.i 06 cb-parametro} = 2  then do:
      {utp/ut-liter.i Assumir†_o_valor_informado_como_mÇdio,_caso_o_mÇdio_calculado_for_igual_a_0 mce R}
      status input return-value.
    end.    

/************************************************/
    if tt-param.medio-mat[1] = 0 and
       tt-param.medio-mob[1] = 0 and
       tt-param.medio-ggf[1] = 0 then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 3263,
                         input "").
      apply 'entry' to de-medio-mat1 in frame {&frame-name}.
      return 'ADM-ERROR':U.
    end.    
    if item.tipo-contr = 3 and {ininc/i09in122.i 06 cb-parametro} = 2  then
      status input " ".
  end.
  if item.tipo-contr = 1 and {ininc/i09in122.i 06 cb-parametro} = 2  then 
    find first movto-estoq
         where movto-estoq.it-codigo = item.it-codigo  and
               movto-estoq.dt-trans  < da-ult-fech-dia and
               movto-estoq.esp-docto = 29 /*"RFS"*/ no-lock no-error.
  if item.tipo-contr = 4 and {ininc/i09in122.i 06 cb-parametro} = 2 or
     item.tipo-contr = 4 and {ininc/i09in122.i 06 cb-parametro} = 1 then 
    find first movto-estoq
         where movto-estoq.it-codigo = item.it-codigo  and
               movto-estoq.dt-trans  < da-ult-fech-dia and
               movto-estoq.esp-docto = 27 /*"RDD"*/ no-lock no-error.
  if item.tipo-contr = 3 and {ininc/i09in122.i 06 cb-parametro} = 2  then 
    find first movto-estoq
         where movto-estoq.it-codigo = item.it-codigo  and
               movto-estoq.dt-trans  < da-ult-fech-dia and
               movto-estoq.esp-docto = 26 /*"RCS"*/ no-lock no-error.
  if avail movto-estoq then do:
    run utp/ut-msgs.p (input "show":U, 
                       input 3264, 
                       input "").
    if return-value = "no" then
      return 'ADM-ERROR':U. 
  end.
  if  session:set-wait-state("GENERAL") then .
  run cep/ce0108a.p (input table tt-param).
  if return-value = "NOK" then 
     return "ADM-ERROR".
  assign cb-parametro 
         tt-item-2.tipo-contr = {ininc/i09in122.i 06 cb-parametro}.
  buffer-copy tt-item-2 using tipo-contr to item.
  disp item.tipo-contr with frame {&frame-name}.
  if error-status:error then 
    run dispatch in this-procedure (' show-errors':U).
  else 
    run dispatch in this-procedure (' display-fields':U).  

  if  session:set-wait-state("") then .

  RUN dispatch IN THIS-PROCEDURE ("cancel-record":U).
END.

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
  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .*/
  /* Code placed here will execute AFTER standard behavior.    */

  &if defined(ADM-ASSIGN-FIELDS) &then
      disable {&ADM-ASSIGN-FIELDS} with frame {&frame-name}.
  &endif

  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      assign cb-parametro:LIST-ITEM-PAIRS = ",".
  &else
      assign cb-parametro:list-items = "".
  &endif

  &IF "{&fnc_multi_idioma}":U = "yes":U &THEN
       do with frame {&frame-name}:
         assign c-lista =                 {ininc/i09in122.i 04 1}.
         assign c-lista = c-lista + "," + {ininc/i09in122.i 04 2}. 
         assign c-lista = c-lista + "," + {ininc/i09in122.i 04 3}. 
         assign c-lista = c-lista + "," + {ininc/i09in122.i 04 4}. 
         run utp/ut-lstit.p (input-output c-lista).
         cb-parametro:list-item-pairs = c-lista.
       end.
  &else 
       do with frame {&frame-name}:
         assign cb-parametro:list-items =                                 {ininc/i09in122.i 04 1}.
         assign cb-parametro:list-items = cb-parametro:list-items + "," + {ininc/i09in122.i 04 2}. 
         assign cb-parametro:list-items = cb-parametro:list-items + "," + {ininc/i09in122.i 04 3}. 
         assign cb-parametro:list-items = cb-parametro:list-items + "," + {ininc/i09in122.i 04 4}. 
       end.
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
find first param-global no-lock no-error.
find first param-estoq no-lock no-error.

/* Code placed here will execute PRIOR to standard behavior. */

  if avail item then do:
      assign c-estab = item.cod-estabel.
	
      find last movto-estoq where movto-estoq.it-codigo = item.it-codigo no-lock no-error.
      if avail movto-estoq then do:
          assign c-conta = movto-estoq.ct-codigo
                 sc-conta = movto-estoq.sc-codigo.
            
          /*### Formato conta contabil*/
          IF c-conta <> "" THEN DO:
              ASSIGN ct-codigo:FORMAT IN FRAME {&frame-name} = "x(20)".
    
              RUN pi_retorna_formato_cta_ctbl in h_api_cta (input  "",                    /* EMPRESA em branco busca a corrente do usu†rio */
                                                            input  "",                    /* PLANO CONTAS */
                                                            input  TODAY,                 /* DATA DE TRANSACAO */
                                                            output p_cod_format_cta_ctbl, /* FORMATO cta */
                                                            output table tt_log_erro).    /* ERROS */
              
              RUN pi_busca_dados_cta_ctbl IN h_api_cta (INPUT        "",                 /* EMPRESA em branco busca a corrente do usu†rio */
                                                        INPUT        "",                 /* PLANO DE CONTAS */
                                                        INPUT-OUTPUT c-conta,            /* CONTA */
                                                        INPUT        today,              /* DATA TRANSACAO */   
                                                        OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                        OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                        OUTPUT       v_num_sit_cta_ctbl, /* SITUA«√O DA CONTA */
                                                        OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                        OUTPUT TABLE tt_log_erro).       /* ERROS */     

              IF RETURN-VALUE = "OK" THEN
                  ASSIGN ct-codigo:SCREEN-VALUE = c-conta
                         ct-codigo:FORMAT IN FRAME {&frame-name} = p_cod_format_cta_ctbl
                         c-titulo:SCREEN-VALUE IN FRAME {&frame-name} = v_des_cta_ctbl.
              ELSE 
                  ASSIGN ct-codigo:SCREEN-VALUE = ""
                         ct-codigo:FORMAT IN FRAME {&frame-name} = "x(20)"
                         c-titulo:SCREEN-VALUE IN FRAME {&frame-name}= "".
          END.
    
          IF sc-conta <> "" THEN DO:
              ASSIGN sc-codigo:FORMAT IN FRAME {&frame-name} = "x(20)".
    
              run pi_retorna_formato_ccusto in h_api_ccust (input  "",                  /* EMPRESA em branco busca a corrente do usu†rio */
                                                            input  "",                  /* PLANO CCUSTO */
                                                            input  TODAY,               /* DATA DE TRANSACAO */
                                                            output p_cod_format_ccusto, /* FORMATO CCUSTO */
                                                            output table tt_log_erro).  /* ERROS */
             
              run pi_busca_dados_ccusto in h_api_ccust (input  "",                 /* EMPRESA em branco busca a corrente do usu†rio */
                                                        input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                        input  sc-conta,           /* CCUSTO */
                                                        input  today,              /* DATA DE TRANSACAO */
                                                        output v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                                        output table tt_log_erro). /* ERROS */
              IF RETURN-VALUE = "OK" THEN
                  ASSIGN sc-codigo:SCREEN-VALUE = sc-conta
                         sc-codigo:FORMAT IN FRAME {&frame-name} = p_cod_format_ccusto
                         sc-titulo:SCREEN-VALUE IN FRAME {&frame-name} = v_des_ccusto.
              ELSE 
                  ASSIGN sc-codigo:SCREEN-VALUE = ""
                         sc-codigo:FORMAT IN FRAME {&frame-name} = "x(20)"
                         sc-titulo:SCREEN-VALUE IN FRAME {&frame-name}= "".
          END.
      end.

     find first grup-estoq where grup-estoq.ge-codigo = item.ge-codigo no-lock no-error.
      assign c-desc-grupo =  if avail grup-estoq then grup-estoq.descricao else "".

     find first familia where familia.fm-codigo = item.fm-codigo no-lock no-error.
      assign c-desc-familia = if avail familia then familia.descricao else "".

     find first tab-unidade where tab-unidade.un = item.un no-lock no-error.
      assign c-desc-tab = if avail tab-unidade then tab-unidade.descricao else "".

     assign c-depos-pad = item.deposito-pad.

     find first deposito where deposito.cod-depos = item.deposito-pad no-lock no-error.
      assign c-desc-dep = if avail deposito then deposito.nome else "".

/*     find  movto-estoq where movto-estoq.it-codigo = item.it-codigo no-lock no-error.*/
      assign c-serie = if avail movto-estoq then movto-estoq.serie-docto else "".
             i-docto = if avail movto-estoq then movto-estoq.nro-docto else "".        
  end.

  /* Dispatch standard ADM method.                             */
 /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .*/

  {utp/ut-liter.i Tipo_de_Controle: mce R}
  assign c-label:screen-value in frame {&frame-name} = return-value.  

  {utp/ut-liter.i Mudar_Para mce L}
  assign cb-parametro:label in frame {&frame-name} = return-value.


  {utp/ut-liter.i Conta mce L}
  assign ct-codigo:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Centro_de_Custo mce L}
  assign sc-codigo:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i SÇrie_Documento mce L}
  assign c-serie:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i N£mero_Documento mce L}
  assign i-docto:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Dep¢sito_Padr∆o mce L}
  assign c-depos-pad:label in frame {&frame-name} = return-value.


  if avail item then do with frame {&frame-name}:
     assign cb-parametro:screen-value in frame {&frame-name} = {ininc/i09in122.i 04 item.tipo-contr}.     
  end.
  else do:
     assign cb-parametro:screen-value in frame {&frame-name} = {ininc/i09in122.i 04 01}.     
 end.   

  /* Code placed here will execute AFTER standard behavior.*/
  if avail item then do:
     display item.it-codigo 
             item.ge-codigo
             item.fm-codigo
             item.un
             item.tipo-contr
             c-desc-grupo
             c-desc-familia
             c-desc-tab
             c-depos-pad
             c-desc-dep
             c-serie
             i-docto
             item.desc-item
             de-medio-mat1
             de-medio-mat2
             de-medio-mat3
             de-medio-mob1
             de-medio-mob2
             de-medio-mob3
             de-medio-ggf1
             de-medio-ggf2
             de-medio-ggf3
             with frame {&frame-name}.
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
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/
  find moeda where moeda.mo-codigo = 0 no-lock no-error.
  if avail moeda then do:
     assign de-medio-mat1:label in frame {&frame-name} = moeda.descricao.
  end.
  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-ASSIGN-FIELDS) &then do:
      enable {&ADM-ASSIGN-FIELDS} with frame {&frame-name}.
  &endif
  end.

  if avail item then do:
     find first item-estab where 
          item-estab.it-codigo   = item.it-codigo and
          item-estab.cod-estabel = item.cod-estabel no-lock no-error.

    &if defined (bf_mat_fech_estab) &then
      if param-estoq.tp-fech = 2 then do:
         find estab-mat 
              where estab-mat.cod-estabel = item-estab.cod-estabel
              no-lock no-error.
         if avail estab-mat then
            assign da-ult-per = estab-mat.ult-per-fech.
      end.
      else
         assign da-ult-per = param-estoq.ult-per-fech.
    &else
        assign da-ult-per = param-estoq.ult-per-fech.
    &endif
  end.

  run cdp/cdapi005.p (input  da-ult-per     ,
                      output da-ini-periodo ,   
                      output da-fim-periodo ,
                      output i-per-corrente ,
                      output i-ano-corrente ,
                      output da-iniper-fech ,
                      output da-fimper-fech ).

  if today > da-fim-periodo then do:
     run utp/ut-msgs.p (input "show",
                        input 18116,
                        input "").
     RUN pi-cancelar in p-h-cadsi2 no-error.
     return 'ADM-ERROR':U.
  end.

  if param-estoq.tem-moeda1 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
     if avail moeda then do:
        assign de-medio-mat2:label in frame {&frame-name} = moeda.descricao.
     end.
  end.
  else 
      assign de-medio-mat2:sensitive in frame {&frame-name} = no
             de-medio-mob2:sensitive in frame {&frame-name} = no
             de-medio-ggf2:sensitive in frame {&frame-name} = no.

  if param-estoq.tem-moeda2 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
     if avail moeda then do:
        assign de-medio-mat3:label in frame {&frame-name} = moeda.descricao.
     end.
  end.
  else 
      assign de-medio-mat3:sensitive in frame {&frame-name} = no
             de-medio-mob3:sensitive in frame {&frame-name} = no
             de-medio-ggf3:sensitive in frame {&frame-name} = no.

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    assign cb-parametro:LIST-ITEM-PAIRS = ",".
&else
    assign cb-parametro:list-items = "".
&endif
  if avail item and input frame {&frame-name} item.tipo-contr = 1 then do with frame {&frame-name}:
    &IF "{&fnc_multi_idioma}":U = "yes":U &THEN
        assign c-lista =                 {ininc/i09in122.i 04 1}.
        assign c-lista = c-lista + "," + {ininc/i09in122.i 04 2}. 
        run utp/ut-lstit.p (input-output c-lista).
        cb-parametro:list-item-pairs = c-lista.
    &ELSE
        assign cb-parametro:list-items =                                 {ininc/i09in122.i 04 1}.
        assign cb-parametro:list-items = cb-parametro:list-items + "," + {ininc/i09in122.i 04 2}. 
    &ENDIF
  end.    
  if avail item and input frame {&frame-name} item.tipo-contr = 2 then do with frame {&frame-name}:
    &IF "{&fnc_multi_idioma}":U = "yes":U &THEN
        assign c-lista =                 {ininc/i09in122.i 04 1}.
        assign c-lista = c-lista + "," + {ininc/i09in122.i 04 2}. 
        assign c-lista = c-lista + "," + {ininc/i09in122.i 04 3}. 
        assign c-lista = c-lista + "," + {ininc/i09in122.i 04 4}. 
        run utp/ut-lstit.p (input-output c-lista).
        cb-parametro:list-item-pairs = c-lista.
    &ELSE
        assign cb-parametro:list-items =                                 {ininc/i09in122.i 04 1}.
        assign cb-parametro:list-items = cb-parametro:list-items + "," + {ininc/i09in122.i 04 2}. 
        assign cb-parametro:list-items = cb-parametro:list-items + "," + {ininc/i09in122.i 04 3}. 
        assign cb-parametro:list-items = cb-parametro:list-items + "," + {ininc/i09in122.i 04 4}. 
    &ENDIF
  end.    
  if avail item and input frame {&frame-name} item.tipo-contr = 3 then do with frame {&frame-name}:
    &IF "{&fnc_multi_idioma}":U = "yes":U &THEN
        assign c-lista =                 {ininc/i09in122.i 04 2}.
        assign c-lista = c-lista + "," + {ininc/i09in122.i 04 3}. 
        run utp/ut-lstit.p (input-output c-lista).
        cb-parametro:list-item-pairs = c-lista.
    &ELSE
        assign cb-parametro:list-items =                                 {ininc/i09in122.i 04 2}.
        assign cb-parametro:list-items = cb-parametro:list-items + "," + {ininc/i09in122.i 04 3}. 
    &ENDIF
  end.
  if avail item and input frame {&frame-name} item.tipo-contr = 4 then do with frame {&frame-name}:
    &IF "{&fnc_multi_idioma}":U = "yes":U &THEN
        assign c-lista =                            {ininc/i09in122.i 04 1}.
        assign c-lista = c-lista + "," + {ininc/i09in122.i 04 2}. 
        assign c-lista = c-lista + "," + {ininc/i09in122.i 04 4}. 
        run utp/ut-lstit.p (input-output c-lista).
        cb-parametro:list-item-pairs = c-lista.
    &ELSE
        assign cb-parametro:list-items =                                 {ininc/i09in122.i 04 1}.
        assign cb-parametro:list-items = cb-parametro:list-items + "," + {ininc/i09in122.i 04 2}. 
        assign cb-parametro:list-items = cb-parametro:list-items + "," + {ininc/i09in122.i 04 4}. 
    &ENDIF
  end.    

  if avail item then do with frame {&frame-name}:
     assign cb-parametro:screen-value in frame {&frame-name} = {ininc/i09in122.i 04 item.tipo-contr}.     
  end.
  else do:
     assign cb-parametro:screen-value in frame {&frame-name} = {ininc/i09in122.i 04 01}.     
  end.   

  ASSIGN i-tipo-contr-old = input frame {&frame-name} item.tipo-contr.

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
  find first param-estoq no-lock no-error.

  {utp/ut-liter.i Tipo_de_Controle: mce R}
  assign c-label:screen-value in frame {&frame-name} = return-value.
  do with frame {&frame-name}:
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
          ASSIGN cAuxTraducao001 = {ininc/i09in122.i 03}.
          RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
          ASSIGN  cb-parametro:LIST-ITEM-PAIRS = cAuxTraducao001.
      &else
          ASSIGN cb-parametro:list-items = {ininc/i09in122.i 03}.
      &endif
  end.    

    /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  {utp/ut-liter.i Material * C}
  assign c-tit-mat = return-value.
  {utp/ut-liter.i M∆o-de-Obra * C}
  assign c-tit-mob = return-value.
  {utp/ut-liter.i GGF * C}
  assign c-tit-ggf = return-value.
  display c-tit-mat
          c-tit-mob
          c-tit-ggf with frame {&frame-name}.

  find moeda where moeda.mo-codigo = 0 no-lock no-error.
  if avail moeda then do:
     assign de-medio-mat1:label in frame {&frame-name} = moeda.descricao.
  end.

  if param-estoq.tem-moeda1 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
     if avail moeda then do:
        assign de-medio-mat2:label in frame {&frame-name} = moeda.descricao.
     end.
  end.
  else do:
      assign de-medio-mat2:visible in frame {&frame-name} = no
             de-medio-mob2:visible in frame {&frame-name} = no
             de-medio-ggf2:visible in frame {&frame-name} = no
             de-medio-mat2:sensitive in frame {&frame-name} = no
             de-medio-mob2:sensitive in frame {&frame-name} = no
             de-medio-ggf2:sensitive in frame {&frame-name} = no.
  end.

  if param-estoq.tem-moeda2 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
     if avail moeda then do:
        assign de-medio-mat3:label in frame {&frame-name} = moeda.descricao.
     end.
  end.
  else do:
      assign de-medio-mat3:visible in frame {&frame-name} = no
             de-medio-mob3:visible in frame {&frame-name} = no
             de-medio-ggf3:visible in frame {&frame-name} = no
             de-medio-mat3:sensitive in frame {&frame-name} = no
             de-medio-mob3:sensitive in frame {&frame-name} = no
             de-medio-ggf3:sensitive in frame {&frame-name} = no.
  end.


  FIND FIRST estabelec 
        WHERE estabelec.cod-estabel = param-estoq.estabel-pad NO-LOCK NO-ERROR.
    ASSIGN i-empresa = IF AVAIL estabelec THEN estabelec.ep-codigo ELSE "".

/*  &if defined (bf_dis_consiste_conta) &then                                 */
/*                                                                            */
/*      find estabelec where                                                  */
/*           estabelec.cod-estabel = param-estoq.estabel-pad no-lock no-error.*/
/*                                                                            */
/*      run cdp/cd9970.p (input rowid(estabelec),                             */
/*                        output i-empresa).                                  */
/*  &endif                                                                    */


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-handle as handle.

assign p-h-cadsi2 = p-handle.

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

   /*Segue um exemplo de validaá∆o de programa 
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
  {src/adm/template/snd-list.i "item"}

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

