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
{include/i-prgvrs.i V25IN122 2.00.00.051 } /*** "010051" 03/11/2025 15:05:40 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v25in122 MUT}
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
def new global shared var gr-familia as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var l-primeiro  as logical init yes.
def var c-formato   as character.

def workfile     w-pedido
                 field nome-abrev     like ped-venda.nome-abrev
                 field nr-pedcli      like ped-venda.nr-pedcli.

def var aux-class-fiscal      like familia.class-fiscal.
def var aux-baixa-estoq       like familia.baixa-estoq.
def var aux-codigo-orig       like familia.codigo-orig.
def var aux-fator-conver      like familia.fator-conver.
def var aux-cd-trib-icm       like familia.cd-trib-icm.
def var aux-cd-trib-ipi       like familia.cd-trib-ipi.
def var aux-fraciona          like familia.fraciona.
def var aux-ind-imp-desc      like familia.ind-imp-desc.
def var aux-deposito-pad      like familia.deposito-pad.
def var i-param-class-fiscal  like familia.class-fiscal.
def var l-param-baixa-estoq   like familia.baixa-estoq.
def var i-param-codigo-orig   like familia.codigo-orig.
def var i-param-fator-conver  like familia.fator-conver.
def var i-param-cd-trib-icm   like familia.cd-trib-icm.
def var i-param-cd-trib-ipi   like familia.cd-trib-ipi.
def var l-param-fraciona      like familia.fraciona.
def var i-param-ind-imp-desc  like familia.ind-imp-desc.
def var i-param-deposito-pad  like familia.deposito-pad.

def var i-exporta-item    as integer initial "1" no-undo.
def var i-exporta-ped     as integer initial "1" no-undo.
def var l-param-aberto    as logical             no-undo.
def var l-param-parcial   as logical             no-undo.

def new shared    var  l-fiscal       as logical initial no no-undo.
def new shared    var  r-it-pre       as rowid no-undo.
def new shared    var  de-vl-bipi     like it-nota-fisc.vl-bipi-it.
def new shared    var  de-vl-preuni   like ped-item.vl-preuni.
def new shared    var  de-vl-preori   like ped-item.vl-preori.
def new shared    var  de-totipi      like ped-venda.vl-tot-ped.
def new shared    var  de-vl-mercori  like it-nota-fisc.vl-merc-ori.

def new shared        var  de-abevl       like ped-venda.vl-liq-abe.
def new shared        var  de-totvl       like ped-venda.vl-liq-ped.
def new shared        var  de-vl-tot-it   like ped-ent.vl-tot-it.
def new shared        var  de-vl-liq-it   like ped-ent.vl-liq-it.
def new shared        var  de-vl-merc-abe like ped-ent.vl-merc-abe.
def new shared        var  de-vl-liq-abe  like ped-ent.vl-liq-abe.
def new shared        var  de-vl-mercliq  like it-nota-fisc.vl-merc-liq.
def new shared        var  de-vlipi       like it-nota-fisc.vl-ipi-it.
def new shared        var  de-total       like ped-venda.vl-tot-ped.
def new shared        var  de-ipi-ant     like classif-fisc.aliquota-ipi. 

def new shared        var  r-item         as rowid no-undo.
def new shared        var  r-ped-it       as rowid no-undo.
def new shared        var  r-ped-en       as rowid no-undo.
def new shared        var  r-pedido       as rowid no-undo.

def                   var  i-cont         as int. 

def new shared        var  l-tot-ab       as logical                    init no  no-undo.

def temp-table tt-item-aux like item.

def var c-class as char no-undo.    
def var h-acomp as handle no-undo.
DEF VAR h-boco2006 AS HANDLE NO-UNDO.
DEF VAR h-boar2126 AS HANDLE NO-UNDO.
DEF VAR c-liter AS CHAR FORMAT "x(30)" NO-UNDO.

define buffer b-item      for item.
define buffer b-item-2     for item.  
define buffer b-ped-item   for ped-item.

/*** Definiá∆o dos prÇ-processadores de releases ***/
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

&if "{&bf_dis_versao_ems}" >= "2.03" &then
/******** Temp-Table usada na exportaá∆o dos dados *******/
{cdp/cd0134a.i} /* definicao tt-old-familia */
/*********************************************************/
&endif
{include/i_fnctrad.i} 

&if "{&bf_mat_versao_ems}" >= "2.062" &then   
{cdp/cd9590.i}
&endif   


DEFINE VARIABLE c-lista-tipo-con-est AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lista-ind-imp-desc AS CHARACTER NO-UNDO.

DEFINE VARIABLE hProgramZoom AS HANDLE NO-UNDO.

DEFINE VARIABLE h-bosc124 AS HANDLE NO-UNDO.

&IF '{&mgscm_version}' >= '2.06B' &THEN
DEFINE VARIABLE hDBOproxy AS HANDLE NO-UNDO.
{method/dbotterr.i}
&ENDIF

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
&Scoped-define EXTERNAL-TABLES familia
&Scoped-define FIRST-EXTERNAL-TABLE familia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR familia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS familia.descricao familia.un ~
familia.deposito-pad familia.cod-localiz familia.codigo-orig ~
familia.fator-conver familia.cod-classe-frete familia.class-fiscal ~
familia.cod-servico familia.loc-unica familia.baixa-estoq familia.fraciona ~
familia.cd-trib-icm familia.cd-trib-ipi 
&Scoped-define ENABLED-TABLES familia
&Scoped-define FIRST-ENABLED-TABLE familia
&Scoped-Define ENABLED-OBJECTS c-impto-rf c-cod-unid-negoc RECT-20 RECT-21 ~
RECT-22 rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS familia.fm-codigo familia.descricao ~
familia.un familia.deposito-pad familia.cod-localiz familia.codigo-orig ~
familia.fator-conver familia.cod-classe-frete familia.class-fiscal ~
familia.cod-servico familia.loc-unica familia.baixa-estoq familia.fraciona ~
familia.cd-trib-icm familia.cd-trib-ipi 
&Scoped-define DISPLAYED-TABLES familia
&Scoped-define FIRST-DISPLAYED-TABLE familia
&Scoped-Define DISPLAYED-OBJECTS c-desc-impto-rf c-impto-rf c-un-descricao ~
cb-tipo-con-est cb-ind-imp-desc c-cod-unid-negoc c-desc-classe-frete ~
i-cod-atividade l-ativo-fixo c-des-unid-negoc c-cd-trib-icm c-cd-trib-ipi 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cb-tipo-con-est cb-ind-imp-desc 
&Scoped-define ADM-ASSIGN-FIELDS familia.descricao familia.un ~
cb-tipo-con-est familia.deposito-pad familia.cod-localiz ~
familia.fator-conver cb-ind-imp-desc familia.class-fiscal ~
familia.cod-servico familia.loc-unica familia.baixa-estoq familia.fraciona ~
familia.cd-trib-icm familia.cd-trib-ipi 
&Scoped-define ADM-MODIFY-FIELDS familia.descricao familia.un ~
cb-tipo-con-est familia.deposito-pad familia.cod-localiz ~
familia.fator-conver cb-ind-imp-desc familia.class-fiscal ~
familia.cod-servico familia.loc-unica familia.baixa-estoq familia.fraciona ~
familia.cd-trib-icm familia.cd-trib-ipi 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
fm-codigo|y|y|mgind.familia.fm-codigo
class-fiscal||y|mgind.familia.class-fiscal
cod-comprado||y|mgind.familia.cod-comprado
nr-linha||y|mgind.familia.nr-linha
cd-planejado||y|mgind.familia.cd-planejado
un||y|mgind.familia.un
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "fm-codigo",
     Keys-Supplied = "fm-codigo,class-fiscal,cod-comprado,nr-linha,cd-planejado,un"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-ind-imp-desc AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-con-est AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 17.14 BY 1 NO-UNDO.

DEFINE VARIABLE c-cd-trib-icm AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .63 NO-UNDO.

DEFINE VARIABLE c-cd-trib-ipi AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .63 NO-UNDO.

DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-unid-negoc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-classe-frete AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.86 BY .92 NO-UNDO.

DEFINE VARIABLE c-desc-impto-rf AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 35.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-impto-rf AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Impto RF" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .92 NO-UNDO.

DEFINE VARIABLE i-cod-atividade AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "C¢digo Atividade" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32.57 BY 3.33.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32.57 BY 3.67.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32.57 BY 3.75.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 101.86 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69 BY 11.67.

DEFINE VARIABLE l-ativo-fixo AS LOGICAL INITIAL no 
     LABEL "Ativo Fixo" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-desc-impto-rf AT ROW 12.83 COL 30.57 COLON-ALIGNED
     c-impto-rf AT ROW 12.83 COL 21 COLON-ALIGNED
     familia.fm-codigo AT ROW 1.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .92
     familia.descricao AT ROW 2.67 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .92
     familia.un AT ROW 3.67 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .92
     c-un-descricao AT ROW 3.67 COL 27.14 COLON-ALIGNED NO-LABEL
     cb-tipo-con-est AT ROW 4.75 COL 21 COLON-ALIGNED
     familia.deposito-pad AT ROW 5.75 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .92
     familia.cod-localiz AT ROW 6.75 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .92
     familia.codigo-orig AT ROW 7.75 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.86 BY .92
     familia.fator-conver AT ROW 8.75 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .92
     cb-ind-imp-desc AT ROW 9.75 COL 21 COLON-ALIGNED
     c-cod-unid-negoc AT ROW 10.83 COL 21 COLON-ALIGNED
     familia.cod-classe-frete AT ROW 11.83 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .92
     c-desc-classe-frete AT ROW 11.83 COL 30.57 COLON-ALIGNED NO-LABEL
     i-cod-atividade AT ROW 12.83 COL 21 COLON-ALIGNED WIDGET-ID 4
     l-ativo-fixo AT ROW 12.83 COL 33 WIDGET-ID 2
     familia.class-fiscal AT ROW 7.75 COL 51.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .92
     familia.cod-servico AT ROW 8.75 COL 51.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .92
     familia.loc-unica AT ROW 2.83 COL 74.29
          VIEW-AS TOGGLE-BOX
          SIZE 23 BY .75
     familia.baixa-estoq AT ROW 3.83 COL 74.29
          VIEW-AS TOGGLE-BOX
          SIZE 20.86 BY .75
     familia.fraciona AT ROW 4.83 COL 74.29
          VIEW-AS TOGGLE-BOX
          SIZE 27.43 BY .75
     familia.cd-trib-icm AT ROW 6.67 COL 84.14 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Tributado", 1,
"Isento", 2,
"Outros", 3,
"Reduzido", 4
          SIZE 13.86 BY 2.92
     familia.cd-trib-ipi AT ROW 11 COL 84.14 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Tributado", 1,
"Isento", 2,
"Outros", 3,
"Reduzido", 4
          SIZE 14.14 BY 2.46
     c-des-unid-negoc AT ROW 10.83 COL 27.43 COLON-ALIGNED NO-LABEL
     c-cd-trib-icm AT ROW 5.92 COL 73.14 NO-LABEL
     c-cd-trib-ipi AT ROW 10.25 COL 71.14 COLON-ALIGNED NO-LABEL
     RECT-20 AT ROW 2.38 COL 70.29
     RECT-21 AT ROW 6.25 COL 70.29
     RECT-22 AT ROW 10.25 COL 70.29
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.33 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.familia
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
         HEIGHT             = 13.04
         WIDTH              = 101.86.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 13.04
       FRAME f-main:WIDTH            = 101.86.

/* SETTINGS FOR TOGGLE-BOX familia.baixa-estoq IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN c-cd-trib-icm IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-cd-trib-ipi IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-unid-negoc:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-des-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-des-unid-negoc:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-classe-frete IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-impto-rf IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-ind-imp-desc IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-tipo-con-est IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR RADIO-SET familia.cd-trib-icm IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR RADIO-SET familia.cd-trib-ipi IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN familia.class-fiscal IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN familia.cod-localiz IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN familia.cod-servico IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN familia.deposito-pad IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN familia.descricao IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN familia.fator-conver IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN familia.fm-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX familia.fraciona IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN i-cod-atividade IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       i-cod-atividade:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX l-ativo-fixo IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       l-ativo-fixo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX familia.loc-unica IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN familia.un IN FRAME f-main
   2 3                                                                  */
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
ON F5 OF c-cod-unid-negoc IN FRAME f-main
DO:

    &if "{&bf_mat_versao_ems}" >= "2.062" &then   
   {method/zoomfields.i &ProgramZoom="inzoom/z01in745.w"
                         &FieldZoom1="cod-unid-negoc"
                         &FieldScreen1="c-cod-unid-negoc"
                         &Frame1="{&frame-name}"
                         &FieldZoom2="des-unid-negoc"
                         &FieldScreen2="c-des-unid-negoc"
                         &Frame2="{&frame-name}"
                         &EnableImplant="no"}
    &endif   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc V-table-Win
ON LEAVE OF c-cod-unid-negoc IN FRAME f-main
DO:

    &if '{&BF_MAT_VERSAO_EMS}' >= '2.062':U &then 
        {include/leave.i &tabela=unid-negoc
                         &atributo-ref=des-unid-negoc
                         &variavel-ref=c-des-unid-negoc
                         &where="unid-negoc.cod-unid-negoc = input frame {&FRAME-NAME} c-cod-unid-negoc"}
    &endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-unid-negoc IN FRAME f-main
DO:

    APPLY 'F5':U TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-impto-rf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-impto-rf V-table-Win
ON F5 OF c-impto-rf IN FRAME f-main /* Impto RF */
DO:
  {include/zoomvar.i &prog-zoom=dizoom/z01di217.w 
                     &campo=c-impto-rf
                     &campozoom=cod-tax}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-impto-rf V-table-Win
ON LEAVE OF c-impto-rf IN FRAME f-main /* Impto RF */
DO:
  {include/leave.i &tabela=tipo-tax 
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-impto-rf
                    &where="tipo-tax.cod-tax = input frame {&frame-name} c-impto-rf"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-impto-rf V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-impto-rf IN FRAME f-main /* Impto RF */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME familia.class-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.class-fiscal V-table-Win
ON ENTRY OF familia.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:

   if l-primeiro then do:
       assign c-formato  = self:format 
              l-primeiro = no.
   end.

   assign self:format =  c-formato.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.class-fiscal V-table-Win
ON F5 OF familia.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:
  assign l-implanta = yes.  
  {include/zoomvar.i &prog-zoom=inzoom/z01in046.w
                     &campozoom=class-fiscal
                     &campo=familia.class-fiscal}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.class-fiscal V-table-Win
ON LEAVE OF familia.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:
   /* Existe uma dpc que substitui essa trigger de leave - bra0013.p
      que executa a pi-leave */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.class-fiscal V-table-Win
ON MOUSE-SELECT-DBLCLICK OF familia.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:
  apply  'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME familia.cod-classe-frete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-classe-frete V-table-Win
ON F5 OF familia.cod-classe-frete IN FRAME f-main /* Classe Frete */
DO:
  assign l-implanta = no.
  {include/zoomvar.i &prog-zoom="sczoom/z01sc124.w"
                  &campo=familia.cod-classe-frete
                  &campozoom=cod-classe-frete}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-classe-frete V-table-Win
ON LEAVE OF familia.cod-classe-frete IN FRAME f-main /* Classe Frete */
DO:
    assign c-desc-classe-frete = "".
    if valid-handle (h-bosc124) then do:
        run GoToKey     in h-bosc124 (input frame {&FRAME-NAME} familia.cod-classe-frete).
        if  return-value = "OK":U then
            run getCharField in h-bosc124 (input "des-classe-frete":U, output  c-desc-classe-frete).
    end.
    assign c-desc-classe-frete:screen-value in frame {&frame-name} = c-desc-classe-frete.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-classe-frete V-table-Win
ON MOUSE-SELECT-DBLCLICK OF familia.cod-classe-frete IN FRAME f-main /* Classe Frete */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME familia.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-localiz V-table-Win
ON F5 OF familia.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom\z01in189.w"
                     &campo=familia.cod-localiz
                     &campozoom=cod-localiz}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-localiz V-table-Win
ON MOUSE-MOVE-DBLCLICK OF familia.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME familia.cod-servico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-servico V-table-Win
ON F5 OF familia.cod-servico IN FRAME f-main /* Serviáo */
DO:
  assign l-implanta = yes.  
  {include/zoom.i &prog-zoom="dizoom/z01di185.w"
                  &tabela=familia
                  &atributo=cod-servico}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-servico V-table-Win
ON MOUSE-SELECT-DBLCLICK OF familia.cod-servico IN FRAME f-main /* Serviáo */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME familia.deposito-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.deposito-pad V-table-Win
ON F5 OF familia.deposito-pad IN FRAME f-main /* Dep¢sito Padr∆o */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom\z01in084.w"
                     &campo=familia.deposito-pad
                     &campozoom=cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.deposito-pad V-table-Win
ON MOUSE-SELECT-DBLCLICK OF familia.deposito-pad IN FRAME f-main /* Dep¢sito Padr∆o */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME familia.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.un V-table-Win
ON F5 OF familia.un IN FRAME f-main /* Unid Padr∆o */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in417.w"
                  &tabela=familia
                  &atributo=un}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.un V-table-Win
ON LEAVE OF familia.un IN FRAME f-main /* Unid Padr∆o */
DO:
  {include/leave.i &tabela=tab-unidade
                   &atributo-ref=descricao
                   &variavel-ref=c-un-descricao
                   &where="tab-unidade.un = input frame {&FRAME-NAME} familia.un"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.un V-table-Win
ON MOUSE-SELECT-DBLCLICK OF familia.un IN FRAME f-main /* Unid Padr∆o */
DO:
  apply  'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  {utp/ut-rtlbl.i mgind familia cd-trib-icm c-cd-trib-icm}
  {utp/ut-rtlbl.i mgind familia cd-trib-ipi c-cd-trib-ipi}  
  {utp/ut-field.i mgind familia tipo-con-est 1}
  assign cb-tipo-con-est:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-field.i mgind familia ind-imp-desc 1}
  assign cb-ind-imp-desc:label in frame {&FRAME-NAME} = return-value.

 if  familia.un:load-mouse-pointer                ("image/lupa.cur") in frame {&FRAME-NAME} then.
 if  familia.class-fiscal:load-mouse-pointer      ("image/lupa.cur") in frame {&FRAME-NAME} then.
 if  familia.cod-servico:load-mouse-pointer       ("image/lupa.cur") in frame {&FRAME-NAME} then.
 if  familia.deposito-pad:load-mouse-pointer      ("image/lupa.cur") in frame {&FRAME-NAME} then.
 if  familia.cod-localiz:load-mouse-pointer       ("image/lupa.cur") in frame {&FRAME-NAME} then. 

&if "{&bf_mat_versao_ems}" >= "2.062" &then   
c-cod-unid-negoc:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.  
{utp/ut-field.i mgind familia-mat cod-unid-negoc 1}
assign c-cod-unid-negoc:label in frame {&FRAME-NAME} = return-value.
&endif   


 if i-pais-impto-usuario = 1 then do with frame {&frame-name}:
    assign familia.cod-classe-frete:visible = no
           c-desc-classe-frete:visible = no.
 end.
    else if familia.cod-classe-frete:load-mouse-pointer  ("image/lupa.cur") in frame {&FRAME-NAME} then.

IF i-pais-impto-usuario = 17 THEN
    c-impto-rf:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&FRAME-NAME}.

  /************************ INTERNAL PROCEDURES ********************/

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
  DEF VAR key-value AS CHAR NO-UNDO.
  DEF VAR row-avail-enabled AS LOGICAL NO-UNDO.

  /* LOCK status on the find depends on FIELDS-ENABLED. */
  RUN get-attribute ('FIELDS-ENABLED':U).
  row-avail-enabled = (RETURN-VALUE eq 'yes':U).
  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'fm-codigo':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = familia
           &WHERE = "WHERE familia.fm-codigo eq key-value"
       }
  END CASE.

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
  {src/adm/template/row-list.i "familia"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "familia"}

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

  {utp/ut-rtlbl.i mgind familia cd-trib-icm c-cd-trib-icm}
  {utp/ut-rtlbl.i mgind familia cd-trib-ipi c-cd-trib-ipi}   

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
{include/i-valid.i}

if input frame {&frame-name} familia.un:screen-value = "" or
   input frame {&frame-name} familia.un:screen-value = ? then do: 
      {utp/ut-field.i mgind familia un 1}
        run utp/ut-msgs.p (input "show",
                           input 164,
                           input return-value).
        apply "entry" to familia.un.
        return "adm-error".
   end.
 else do:  
   find tab-unidade where tab-unidade.un = familia.un:screen-value in frame {&frame-name} no-lock no-error.
   if not avail tab-unidade then do:
      {utp/ut-field.i mgind familia un 1}
        run utp/ut-msgs.p (input "show",
                           input 7860,
                           input return-value).
        apply "entry" to familia.un.
        return "adm-error".
   end.  
end.



if input frame {&frame-name} familia.deposito-pad:screen-value = "" or
   input frame {&frame-name} familia.deposito-pad:screen-value = ? then do: 
      {utp/ut-field.i mgind familia deposito-pad 1}
        run utp/ut-msgs.p (input "show",
                           input 164,
                           input return-value).
        apply "entry" to familia.deposito-pad.
        return "adm-error".
   end.
   else do:
   find deposito where deposito.cod-depos = familia.deposito-pad:screen-value in frame {&frame-name} no-lock no-error.
   if not avail deposito then do:
      {utp/ut-field.i mgind familia deposito-pad 1}
        run utp/ut-msgs.p (input "show",
                           input 47,
                           input return-value).
        apply "entry" to familia.deposito-pad.
        return "adm-error".
   end.  
end.

if input frame {&frame-name} familia.cod-localiz:screen-value <> "" and
   input frame {&frame-name} familia.cod-localiz:screen-value <> ? then do: 

   find first localizacao where localizacao.cod-depos   = familia.deposito-pad:screen-value in frame {&frame-name} 
                            and localizacao.cod-localiz = familia.cod-localiz:screen-value in frame {&frame-name} no-lock no-error.

       if  not avail localizacao then do:
           {utp/ut-field.i mgind familia cod-localiz 1}
           run utp/ut-msgs.p (input "show",
                              input 15811,
                              input return-value).
           apply "entry" to familia.cod-localiz.
           return "adm-error".
       end.
end.  

if familia.descricao:screen-value in frame {&frame-name} = "" then do:
    {utp/ut-field.i mgind familia descricao 1}
    run utp/ut-msgs.p (input "show",
                       input 190,
                       input return-value).
    apply "entry" to familia.descricao.
    return "adm-error".
end.

&if "{&bf_mat_versao_ems}" >= "2.062" &then
IF  l-dis-unid-negoc THEN DO:
    IF  NOT CAN-FIND(FIRST unid-negoc
                     WHERE unid-negoc.cod-unid-negoc = c-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:
        {utp/ut-field.i mgind familia-mat cod-unid-negoc 1}
        run utp/ut-msgs.p (input "show",
                           input 2,
                           input return-value).
        apply "entry" to c-cod-unid-negoc.
        return "adm-error".
    END.
END.
&ENDIF

&IF "{&mguni_version}" < "2.07" &THEN
    /**** Classe frete n∆o pode ser brancos para o produto internacional ****/
    if param-global.modulo-tf = yes then do:
    
     IF i-pais-impto-usuario <> 1 THEN DO:
        IF INPUT FRAME {&FRAME-NAME} familia.cod-classe-frete = "" THEN DO:
          {utp/ut-field.i mgind familia cod-classe-frete 1}
          RUN utp/ut-msgs.p (INPUT "show",
                             INPUT 164,
                             INPUT RETURN-VALUE).
          APPLY "entry" TO familia.cod-classe-frete.
          RETURN "ADM-ERROR".
        END.
        ELSE do: 
              if valid-handle (h-bosc124) then do:
                  
                  run GoToKey     in h-bosc124 (input frame {&FRAME-NAME} familia.cod-classe-frete).
                  
                  if return-value = "NOK":U then do:
                      {utp/ut-field.i mgind familia cod-classe-frete 1}
                      RUN utp/ut-msgs.p (INPUT "show",
                                         INPUT 7381,
                                         INPUT return-value).
                      APPLY "entry" TO familia.cod-classe-frete.
                      RETURN "ADM-ERROR".
                  end.
    
              end.
        END.
     END.
    end.
&ENDIF

/*** Cria temp-table para uso 
     na exportaá∆o dos dados ***/
&if "{&bf_dis_versao_ems}" >= "2.03" &then
    run pi-cria-tt-old-familia.  
&endif
/*******************************/

IF i-pais-impto-usuario = 17 THEN DO:
    IF int(c-impto-rf:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> 0 THEN DO:
        FIND FIRST tipo-tax 
             WHERE tipo-tax.cod-tax = int(c-impto-rf:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-LOCK NO-ERROR.
        IF NOT AVAIL tipo-tax THEN DO:
             {utp/ut-liter.i "Imposto" *}
             run utp/ut-msgs.p (input "show":U, 
                                INPUT 3549,
                                input TRIM(RETURN-VALUE)).
             return 'ADM-ERROR':U.
        END.
        ELSE DO:
            IF tipo-tax.tipo  <>  1 THEN DO:
                run utp/ut-msgs.p (input "show":U, 
                                   INPUT 7267, 
                                   input "").
                return 'ADM-ERROR':U.
            END.
        END.
    END.
END.

/* Dispatch standard ADM method.                             */

RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).

if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    If  lookup(cb-tipo-con-est,cb-tipo-con-est:LIST-ITEM-PAIRS,",") mod 2 <> 0 Then
        ASSIGN familia.tipo-con-est = (lookup(cb-tipo-con-est,cb-tipo-con-est:LIST-ITEM-PAIRS,",") + 1) / 2.
    else 
        ASSIGN familia.tipo-con-est = lookup(cb-tipo-con-est,cb-tipo-con-est:LIST-ITEM-PAIRS,",") / 2.

    If  lookup(cb-ind-imp-desc,cb-ind-imp-desc:LIST-ITEM-PAIRS,",") mod 2 <> 0 Then
        ASSIGN familia.ind-imp-desc = (lookup(cb-ind-imp-desc,cb-ind-imp-desc:LIST-ITEM-PAIRS,",") + 1) / 2.
    else 
        ASSIGN familia.ind-imp-desc = lookup(cb-ind-imp-desc,cb-ind-imp-desc:LIST-ITEM-PAIRS,",") / 2.
&ELSE
    assign familia.tipo-con-est = {ininc/i01in122.i 06 cb-tipo-con-est}
           familia.ind-imp-desc = {ininc/i10in122.i 06 cb-ind-imp-desc}.
&ENDIF

&if "{&bf_mat_versao_ems}" >= "2.062" &then
IF  l-dis-unid-negoc THEN DO:

    FIND FIRST familia-mat
        WHERE familia-mat.fm-codigo = familia.fm-codigo EXCLUSIVE-LOCK NO-ERROR.
    IF  NOT AVAIL familia-mat THEN DO:
        CREATE familia-mat.
        ASSIGN familia-mat.fm-codigo = familia.fm-codigo.
    END.
    ASSIGN familia-mat.cod-unid-negoc = c-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}
           c-cod-unid-negoc           = c-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
END.
&ENDIF

    &IF '{&mgscm_version}' >= '2.06B' &THEN
        IF CONNECTED('mgscm') THEN DO: 
            IF NOT VALID-HANDLE(hDBOproxy) THEN
                RUN wmp/wmprx042.p PERSISTENT SET hDBOproxy.
            RUN ReplicaFamilia IN hDBOproxy(INPUT 2,
                                            INPUT familia.fm-codigo, 
                                            INPUT familia.descricao,
                                            INPUT familia.un,
                                            INPUT familia.tipo-con-est,
                                            OUTPUT TABLE RowErrors).
            IF RETURN-VALUE = 'NOK':U THEN DO:
                FOR EACH RowErrors:
                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT RowErrors.ErrorNumber,
                                       INPUT RowErrors.ErrorParameters).
                END.
                RUN destroy IN hDBOproxy.
                RETURN "ADM-ERROR":U.
            END.
            RUN destroy IN hDBOproxy.
        END.
    &ENDIF

IF i-pais-impto-usuario = 17 THEN DO:

    RUN pi-atualiza-campos IN h-boco2006 (INPUT familia.fm-codigo,
                                          INPUT INT(c-impto-rf:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                          INPUT "MFT":U). 

    IF c-impto-rf <> INT(c-impto-rf:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:
        {utp/ut-liter.i "o_imposto_RF_da_fam°lia" *}
        ASSIGN c-liter = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "os_itens_desta_fam°lia" *}
        ASSIGN c-liter = c-liter + "~~" + TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17756,
                           INPUT c-liter). /* Deseja exportar &1 para &2 ? */

        IF RETURN-VALUE = "YES":U THEN DO:
            RUN pi-exportar-imp-familia-item IN h-boco2006 (INPUT familia.fm-codigo,
                                                            INPUT INT(c-impto-rf:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                                            INPUT "MFT":U).
        END.
    END.
END.

IF i-pais-impto-usuario = 2 THEN DO:

    RUN pi-atualiza-campos IN h-boar2126 (INPUT familia.fm-codigo,
                                          INPUT INT(i-cod-atividade:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                          INPUT l-ativo-fixo:CHECKED IN FRAME {&FRAME-NAME},
                                          INPUT ?, /* tipo concepto MRE */
                                          INPUT "MFT":U). 
END.


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

  apply "leave" to familia.class-fiscal in frame {&frame-name}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

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

  if valid-handle (h-bosc124) then do:
      delete procedure h-bosc124.
      assign h-bosc124 = ?.
  end.

  IF i-pais-impto-usuario = 17 AND VALID-HANDLE(h-boco2006) THEN
        RUN destroy IN h-boco2006.
        
    IF  i-pais-impto-usuario = 2 AND VALID-HANDLE(h-boar2126) THEN
        RUN destroy IN h-boar2126.
        
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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

  assign   familia.codigo-orig:sensitive in frame {&frame-name} = no.
  assign   cb-tipo-con-est:sensitive in frame {&frame-name} = no.
  assign   cb-ind-imp-desc:sensitive in frame {&frame-name} = no.

    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        ASSIGN c-cod-unid-negoc:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    &ENDIF
    
  IF i-pais-impto-usuario = 17 THEN
      ASSIGN c-impto-rf:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
      
    IF  i-pais-impto-usuario = 2 THEN
        ASSIGN i-cod-atividade:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               l-ativo-fixo:SENSITIVE IN FRAME {&FRAME-NAME}    = NO.
    
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

  do with frame {&FRAME-NAME}:

     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         ASSIGN c-lista-tipo-con-est = {ininc/i01in122.i 03}.
         RUN utp/ut-lstit.p (INPUT-OUTPUT c-lista-tipo-con-est).
         ASSIGN cb-tipo-con-est:LIST-ITEM-PAIRS = c-lista-tipo-con-est.
     &else
         ASSIGN cb-tipo-con-est:list-items = {ininc/i01in122.i 03}.
     &endif

     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         ASSIGN c-lista-ind-imp-desc = {ininc/i10in122.i 03}.
         RUN utp/ut-lstit.p (INPUT-OUTPUT c-lista-ind-imp-desc).
         ASSIGN cb-ind-imp-desc:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = c-lista-ind-imp-desc.
     &else
         ASSIGN cb-ind-imp-desc:list-items = {ininc/i10in122.i 03}.
     &endif
  END.

  if  avail familia then do with frame {&FRAME-NAME}:

      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          ASSIGN cb-tipo-con-est:screen-value = IF familia.tipo-con-est <> 0 THEN entry(familia.tipo-con-est * 2,cb-tipo-con-est:LIST-ITEM-PAIRS,",")
                                                ELSE entry(2,cb-tipo-con-est:LIST-ITEM-PAIRS,",")
                 cb-ind-imp-desc:screen-value = IF familia.ind-imp-desc <> 0 THEN entry(familia.ind-imp-desc * 2,cb-ind-imp-desc:LIST-ITEM-PAIRS,",")
                                                ELSE entry(2,cb-ind-imp-desc:LIST-ITEM-PAIRS,",").
      &ELSE
          ASSIGN cb-tipo-con-est:screen-value = IF familia.tipo-con-est <> 0 THEN entry(familia.tipo-con-est,cb-tipo-con-est:LIST-ITEMS,",")
                                                ELSE entry(1,cb-tipo-con-est:LIST-ITEMS,",")
                 cb-ind-imp-desc:screen-value = IF familia.ind-imp-desc <> 0 THEN entry(familia.ind-imp-desc,cb-ind-imp-desc:LIST-ITEMS,",")
                                                ELSE entry(1,cb-ind-imp-desc:LIST-ITEMS,",").
      &ENDIF
  end.
  else do with frame {&frame-name}:

      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          ASSIGN cb-tipo-con-est:screen-value = entry(2,cb-tipo-con-est:LIST-ITEM-PAIRS,",")
                 cb-ind-imp-desc:screen-value = entry(2,cb-ind-imp-desc:LIST-ITEM-PAIRS,",").
      &ELSE
          ASSIGN cb-tipo-con-est:screen-value = entry(1,cb-tipo-con-est:LIST-ITEMS,",")
                 cb-ind-imp-desc:screen-value = entry(1,cb-ind-imp-desc:LIST-ITEMS,",").
      &ENDIF
  end.  

    find tab-unidade where tab-unidade.un = familia.un no-lock no-error.
    IF  avail tab-unidade then
        {include/leave.i &tabela=tab-unidade
                         &atributo-ref=descricao
                         &variavel-ref=c-un-descricao
                         &where="tab-unidade.un = input frame {&frame-name} familia.un"}

    apply 'LEAVE':u to FAMILIA.cod-classe-frete in frame {&frame-name}.

    &if '{&BF_MAT_VERSAO_EMS}' >= '2.062':U &then 
    IF  AVAIL familia THEN DO:
        FIND familia-mat
            WHERE familia-mat.fm-codigo = familia.fm-codigo NO-LOCK NO-ERROR.
        IF  AVAIL familia-mat THEN DO:
            FIND unid-negoc
                WHERE unid-negoc.cod-unid-negoc = familia-mat.cod-unid-negoc NO-LOCK NO-ERROR.
            ASSIGN c-cod-unid-negoc = familia-mat.cod-unid-negoc
                   c-des-unid-negoc = IF  AVAIL unid-negoc THEN unid-negoc.des-unid-negoc ELSE "".
        END.
        ELSE
            ASSIGN c-cod-unid-negoc = ""
                   c-des-unid-negoc = "".

        ASSIGN c-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-cod-unid-negoc
               c-des-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-des-unid-negoc.
    END.
    &endif

  assign aux-class-fiscal = input frame {&frame-name} familia.class-fiscal.
  assign aux-baixa-estoq  = familia.baixa-estoq:checked.
  assign aux-codigo-orig  = input frame {&frame-name} familia.codigo-orig.
  assign aux-fator-conver = input frame {&frame-name} familia.fator-conver.
  assign aux-cd-trib-icm  = input frame {&frame-name} familia.cd-trib-icm.
  assign aux-cd-trib-ipi  = input frame {&frame-name} familia.cd-trib-ipi.
  assign aux-fraciona     = familia.fraciona:checked.
  assign aux-ind-imp-desc = cb-ind-imp-desc:lookup(cb-ind-imp-desc:screen-value).
  assign aux-deposito-pad = input frame {&frame-name} familia.deposito-pad.

  IF i-pais-impto-usuario = 17 THEN DO:

      RUN goToKey IN h-boco2006 (INPUT familia.fm-codigo).
    
      IF RETURN-VALUE = "OK":U THEN
        RUN getIntField IN h-boco2006 (INPUT "cdn-impto-rf-faturam":U,
                                       OUTPUT c-impto-rf).
      ELSE
        ASSIGN c-impto-rf = 0.

      DISP c-impto-rf WITH FRAME {&FRAME-NAME}.
    
      APPLY "LEAVE":U TO c-impto-rf IN FRAME {&FRAME-NAME}.
  END.
  
  
    IF i-pais-impto-usuario = 2 THEN DO:

        RUN goToKey IN h-boar2126 (INPUT i-ep-codigo-usuario,
                                   INPUT familia.fm-codigo).
    
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN getIntField IN h-boar2126 (INPUT "num-livre-1":U, OUTPUT i-cod-atividade).
            RUN getLogField IN h-boar2126 (INPUT "log-livre-1":U, OUTPUT l-ativo-fixo).
        END.
        ELSE
            ASSIGN i-cod-atividade = 0
                   l-ativo-fixo = NO.

        DISP i-cod-atividade l-ativo-fixo WITH FRAME {&FRAME-NAME}.
    END.

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

  assign   familia.codigo-orig:sensitive in frame {&frame-name} = yes
           cb-tipo-con-est:sensitive in frame {&frame-name} = yes
           cb-ind-imp-desc:sensitive in frame {&frame-name} = yes.


    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        ASSIGN c-cod-unid-negoc:SENSITIVE IN FRAME {&FRAME-NAME} = l-dis-unid-negoc.
    &ENDIF
    
        
    if param-global.modulo-tf = no or not connected ("mgscm") then
        assign familia.cod-classe-frete:sensitive in frame {&frame-name} = no
               c-desc-classe-frete:sensitive in frame {&frame-name} = no.

    IF i-pais-impto-usuario = 17 THEN
        ASSIGN c-impto-rf:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

    IF  i-pais-impto-usuario = 2 THEN
        ASSIGN i-cod-atividade:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               l-ativo-fixo:SENSITIVE IN FRAME {&FRAME-NAME}    = YES.        
        
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

    def var c-dif     as char no-undo.
    DEF VAR c-dif-aux AS CHAR NO-UNDO.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

      /* Code placed here will execute AFTER standard behavior.    */

&if "{&bf_dis_versao_ems}" < "2.03" &then
     
    /*--- Exportaá∆o dos dados da fam°lia para os itens pelo 
          faturamento (Funá∆o desabilitada a partir da vers∆o 2.03) ---*/
    run pi-exporta-dados-item.
    /*------------------------------------------------------*/

&else

    &if '{&BF_MAT_VERSAO_EMS}' >= '2.062':U &then 
        IF  l-dis-unid-negoc
        AND AVAIL familia-mat THEN
            BUFFER-COMPARE familia-mat TO tt-old-familia SAVE RESULT IN c-dif-aux.
    &endif

    buffer-compare familia to tt-old-familia save result in c-dif.
    if  c-dif     <> ""
    OR  c-dif-aux <> "" then do:

        /*------- Exportaá∆o dos dados da fam°lia para Fam°lia x Estabel
                  Item e Item x Estabel         -----------*/
        run cdp/cd0134a.w ( input "ft0306.w":U,
                            input rowid(familia),
                            input table tt-old-familia).      
       /*-------------------------------------------------*/

    end.

&endif

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.   
                            */
  do with frame {&FRAME-NAME}:
     assign familia.codigo-orig:screen-value in frame {&frame-name} = string(0).
  end.

  find first param-global no-lock no-error.  

  IF i-pais-impto-usuario = 17 THEN DO:
    IF NOT VALID-HANDLE(h-boco2006) THEN
        RUN local/col/boco2006.p PERSISTENT SET h-boco2006.

    RUN openQueryStatic IN h-boco2006 (INPUT "Main":U) NO-ERROR.
  END.
  
    IF  i-pais-impto-usuario = 2 THEN DO:
        IF  NOT VALID-HANDLE(h-boar2126) THEN
            RUN local/arg/boar2126.p PERSISTENT SET h-boar2126.

        RUN openQueryStatic IN h-boar2126 (INPUT "Main":U) NO-ERROR.
    END.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    &IF "{&mguni_version}" < "2.07" &THEN
        if  param-global.modulo-tf and connected ("mgscm":U) then do:
            run scbo/bosc124.p persistent set h-bosc124.
            run OpenQueryStatic in h-bosc124 (input "Main":U).
        end.
    &ENDIF
    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        ASSIGN c-cod-unid-negoc:VISIBLE IN FRAME {&FRAME-NAME} = YES
               c-des-unid-negoc:VISIBLE IN FRAME {&FRAME-NAME} = YES.
    &ELSE
        ASSIGN c-cod-unid-negoc:VISIBLE IN FRAME {&FRAME-NAME} = NO
               c-des-unid-negoc:VISIBLE IN FRAME {&FRAME-NAME} = NO.
    &ENDIF
    
    IF i-pais-impto-usuario <> 17 THEN
        ASSIGN c-impto-rf:HIDDEN IN FRAME {&FRAME-NAME} = YES
               c-desc-impto-rf:HIDDEN IN FRAME {&FRAME-NAME} = YES.
    ELSE 
        ASSIGN c-impto-rf:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        
    ASSIGN i-cod-atividade:HIDDEN IN FRAME {&FRAME-NAME} = (i-pais-impto-usuario <> 2)
           l-ativo-fixo:HIDDEN IN FRAME {&FRAME-NAME}    = (i-pais-impto-usuario <> 2).

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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ).

  if  avail familia then assign gr-familia = rowid(familia).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-old-familia V-table-Win 
PROCEDURE pi-cria-tt-old-familia :
/*------------------------------------------------------------------------------
  Purpose: Cria temp-table com os dados da fam°lia antes da alteraá∆o para
           comparaá∆o na tela de exportaá∆o.
------------------------------------------------------------------------------*/

&if "{&bf_dis_versao_ems}" >= "2.03" &then
    
    for each tt-old-familia:
        delete tt-old-familia.
    end.

    if  avail familia then do:
        create tt-old-familia.
        buffer-copy familia to tt-old-familia no-error.
        if  error-status:error then
            return "NOK":U.

        &if "{&bf_mat_versao_ems}" >= "2.062" &then
        FIND FIRST familia-mat
            WHERE familia-mat.fm-codigo = familia.fm-codigo NO-LOCK NO-ERROR.
        IF  AVAIL familia-mat THEN
            BUFFER-COPY familia-mat TO tt-old-familia NO-ERROR.
        &ENDIF
    end.

&endif

    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-disable-fields V-table-Win 
PROCEDURE pi-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  IF i-pais-impto-usuario = 17 THEN
    ASSIGN c-impto-rf:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    
    IF  i-pais-impto-usuario = 2 THEN
        ASSIGN i-cod-atividade:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               l-ativo-fixo:SENSITIVE IN FRAME {&FRAME-NAME}    = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-display V-table-Win 
PROCEDURE pi-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     if avail familia then do:
        assign familia.class-fiscal:screen-value in frame {&frame-name} = string(familia.class-fiscal).
        assign familia.cod-servico:screen-value in frame {&frame-name} = string(familia.cod-servico).
     end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-enable-fields V-table-Win 
PROCEDURE pi-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  IF i-pais-impto-usuario = 17 THEN
    ASSIGN c-impto-rf:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    
    IF  i-pais-impto-usuario = 2 THEN
        ASSIGN i-cod-atividade:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               l-ativo-fixo:SENSITIVE IN FRAME {&FRAME-NAME}    = YES.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-dados-item V-table-Win 
PROCEDURE pi-exporta-dados-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&if "{&bf_dis_versao_ems}" < "2.03" &then
    
    define var rs-exporta-item as integer no-undo.
    define var rs-exporta-ped  as integer no-undo.
    define var l-aberto        as logical no-undo.
    define var l-parcial       as logical no-undo.
    define var l-fiscal        as logical no-undo.

    RUN get-attribute ('ADM-ADD-RECORD').

       assign i-param-class-fiscal = aux-class-fiscal
              l-param-baixa-estoq  = aux-baixa-estoq
              i-param-codigo-orig  = aux-codigo-orig
              i-param-fator-conver = aux-fator-conver
              i-param-cd-trib-icm  = aux-cd-trib-icm
              i-param-cd-trib-ipi  = aux-cd-trib-ipi
              l-param-fraciona     = aux-fraciona
              i-param-ind-imp-desc = aux-ind-imp-desc
              i-param-deposito-pad = aux-deposito-pad.

       if familia.class-fiscal:screen-value in frame {&frame-name}  <> "" then 
          assign l-fiscal = yes.


       if familia.class-fiscal <> aux-class-fiscal or  
          familia.baixa-estoq  <> aux-baixa-estoq  or
          familia.codigo-orig  <> aux-codigo-orig  or
          familia.fator-conver <> aux-fator-conver or 
          familia.cd-trib-icm  <> aux-cd-trib-icm  or
          familia.cd-trib-ipi  <> aux-cd-trib-ipi  or
          familia.fraciona     <> aux-fraciona     or
          familia.ind-imp-desc <> aux-ind-imp-desc or
          familia.deposito-pad <> aux-deposito-pad then
          do: 

             run ftp/ft0306a.w (output rs-exporta-item).

             run utp/ut-acomp.p persistent set h-acomp.
             {utp/ut-liter.i Processando_Calculo * r}
             run pi-inicializar in h-acomp (return-value).

             if  rs-exporta-item = 2 then do:
                 assign i-exporta-item = 2.

                 if  familia.class-fiscal <> aux-class-fiscal and
                     l-fiscal                                 then do:
                     run ftp/ft0306b.w (output rs-exporta-ped, output l-aberto, output l-parcial).
                 end.
                 assign l-param-aberto  = l-aberto
                        l-param-parcial = l-parcial.

                 find classif-fisc 
                      where classif-fisc.class-fiscal = input frame {&FRAME-NAME} familia.class-fiscal no-lock no-error.
                 for each b-item-2 where b-item-2.fm-codigo = familia.fm-codigo no-lock:
                     find item where rowid(item) = rowid(b-item-2) EXCLUSIVE-LOCK NO-ERROR.

                     run pi-acompanhar in h-acomp (item.it-codigo).

                     if  familia.class-fiscal <> aux-class-fiscal and
                         l-fiscal                                 then do:
                         assign item.class-fiscal = familia.class-fiscal.
                         assign item.aliquota-ipi = classif-fisc.aliquota-ipi.

                         if  rs-exporta-ped <> 1 then do:
                             for each w-pedido:
                                 delete w-pedido.
                             end.
                         end.
                         if  rs-exporta-ped = 2 then do:
                             assign i-exporta-ped = 2. 
                             for each w-pedido:
                                 delete w-pedido.
                             end.
                             /* gravar aliquota de ipi nos pedidos */
                             {cdp/cd0903.i3 " "}

                             /* recalcular o valor dos pedidos */
                             for each w-pedido:
                                 find ped-venda
                                 where ped-venda.nome-abrev = w-pedido.nome-abrev
                                   and   ped-venda.nr-pedcli  = w-pedido.nr-pedcli EXCLUSIVE-LOCK NO-ERROR.
                                   run cdp/cd4323a.p (input rowid(ped-venda),
                                                      input yes,
                                                      input i-pais-impto-usuario).

                                   delete w-pedido.
                             end.
                         end.
                         if  rs-exporta-ped = 3 then do:
                             assign i-exporta-ped = 3.
                             for each w-pedido:
                                 delete w-pedido.
                             end.
                             /* gravar aliquota de ipi nos pedidos */
                            {cdp/cd0903.i3 "and ped-item.aliquota-ipi = de-ipi-ant"}

                            /* recalcular o valor dos pedidos */
                            for each w-pedido:
                                find ped-venda
                                     where ped-venda.nome-abrev = w-pedido.nome-abrev
                                       and   ped-venda.nr-pedcli  = w-pedido.nr-pedcli EXCLUSIVE-LOCK NO-ERROR.
                                     run cdp/cd4323a.p (input rowid(ped-venda),
                                                        input yes,
                                                        input i-pais-impto-usuario).

                                     delete w-pedido.
                            end.
                         end.

                     end.   

                     if  familia.baixa-estoq  <> aux-baixa-estoq  then 
                         assign item.baixa-estoq =  familia.baixa-estoq.   

                     if  familia.codigo-orig  <> aux-codigo-orig then
                         assign item.codigo-orig = familia.codigo-orig.

                     if  familia.fator-conver <> aux-fator-conver then 
                         assign item.fator-conver = familia.fator-conver.   

                     if  familia.cd-trib-icm  <> aux-cd-trib-icm  then 
                         assign item.cd-trib-icm =  familia.cd-trib-icm.   

                     if  familia.cd-trib-ipi  <>  aux-cd-trib-ipi  then 
                         assign item.cd-trib-ipi =  familia.cd-trib-ipi.   

                     if  familia.fraciona     <>  aux-fraciona     then 
                         assign item.fraciona = familia.fraciona.   

                     if  familia.ind-imp-desc <>  aux-ind-imp-desc then
                         assign item.ind-imp-desc = familia.ind-imp-desc.

                     if  familia.deposito-pad <>  aux-deposito-pad then
                         assign item.deposito-pad = familia.deposito-pad.     


                 end.
             end.

             if  rs-exporta-item = 3 then do:
                 assign i-exporta-item = 3.  
                 if familia.class-fiscal <> aux-class-fiscal and
                    l-fiscal                                 then do:
                    run ftp/ft0306b.w (output rs-exporta-ped, output l-aberto, output l-parcial).
                    assign l-param-aberto  = l-aberto
                           l-param-parcial = l-parcial.

                    find classif-fisc where classif-fisc.class-fiscal = familia.class-fiscal no-lock no-error.

                    for each b-item-2 where b-item-2.fm-codigo = familia.fm-codigo 
                         and b-item-2.class-fiscal             = aux-class-fiscal no-lock:

                         find item where rowid(item) = rowid(b-item-2) EXCLUSIVE-LOCK NO-ERROR.                             
                         assign item.class-fiscal = familia.class-fiscal.
                         assign item.aliquota-ipi = classif-fisc.aliquota-ipi.

                         if  rs-exporta-ped <> 1 then do:
                             for each w-pedido:
                                 delete w-pedido.
                             end.
                         end.

                         if  rs-exporta-ped = 2 then do:
                             assign i-exporta-ped = 2.
                             {cdp/cd0903.i1} /*Atualiza aliquota de ipi nos pedidos do item */
                         end.

                         if  rs-exporta-ped = 3 then do:
                             assign i-exporta-ped = 3.
                             {cdp/cd0903.i2} /*Atualiza aliquota de ipi nos pedidos com valor anterior */
                         end.

                    end.    

                 end.                                  

                 if  familia.baixa-estoq  <> aux-baixa-estoq  then do:
                     for each item where item.fm-codigo   = familia.fm-codigo 
                          and item.baixa-estoq = aux-baixa-estoq no-lock:
                          find b-item where rowid(b-item) =  rowid(item) EXCLUSIVE-LOCK no-error.
                               assign b-item.baixa-estoq = familia.baixa-estoq.
                     end.
                 end.

                 if  familia.codigo-orig <> aux-codigo-orig then do:
                     for each item where item.fm-codigo   = familia.fm-codigo 
                          and item.codigo-orig = aux-codigo-orig no-lock:
                          find b-item where rowid(b-item) =  rowid(item) EXCLUSIVE-LOCK no-error.
                          assign b-item.codigo-orig = familia.codigo-orig.
                     end.
                 end.           

                 if  familia.fator-conver <> aux-fator-conver then do:
                     for each item where item.fm-codigo   = familia.fm-codigo 
                          and item.fator-conver = aux-fator-conver no-lock:
                          find b-item where rowid(b-item) =  rowid(item) EXCLUSIVE-LOCK no-error.
                          assign b-item.fator-conver = familia.fator-conver.
                     end.
                 end.

                if familia.cd-trib-icm  <> aux-cd-trib-icm  then do:
                   for each item where item.fm-codigo   = familia.fm-codigo 
                       and item.cd-trib-icm = aux-cd-trib-icm no-lock:
                       find b-item where rowid(b-item) =  rowid(item) EXCLUSIVE-LOCK no-error.
                       assign b-item.cd-trib-icm = familia.cd-trib-icm.
                   end.
                end.             

                if  familia.cd-trib-ipi  <> aux-cd-trib-ipi  then do:
                    for each item where item.fm-codigo   = familia.fm-codigo 
                        and item.cd-trib-ipi = aux-cd-trib-ipi no-lock:
                        find b-item where rowid(b-item) =  rowid(item) EXCLUSIVE-LOCK no-error.
                        assign b-item.cd-trib-ipi = familia.cd-trib-ipi.
                     end.
                end.

                if  familia.fraciona  <> aux-fraciona  then do:
                    for each item where item.fm-codigo   = familia.fm-codigo 
                         and item.fraciona = aux-fraciona no-lock:
                         find b-item where rowid(b-item) =  rowid(item) EXCLUSIVE-LOCK no-error.
                         assign b-item.fraciona = familia.fraciona.
                     end.
                end.            

                if  familia.ind-imp-desc <> aux-ind-imp-desc then do:
                    for each item where item.fm-codigo   = familia.fm-codigo 
                         and item.ind-imp-desc = aux-ind-imp-desc no-lock:
                         find b-item where rowid(b-item) =  rowid(item) EXCLUSIVE-LOCK no-error.
                         assign b-item.ind-imp-desc = familia.ind-imp-desc.
                    end.
                end.        

                if  familia.deposito-pad <> aux-deposito-pad then do:
                    for each item where item.fm-codigo  = familia.fm-codigo
                         and item.deposito-pad = aux-deposito-pad no-lock:
                         find b-item where rowid(b-item) = rowid(item) EXCLUSIVE-LOCK no-error.
                         assign b-item.deposito-pad = familia.deposito-pad.
                    end.      
                end.    
            end. 

            assign aux-class-fiscal = input frame {&frame-name} familia.class-fiscal.
            assign aux-baixa-estoq  = familia.baixa-estoq:checked.
            assign aux-codigo-orig  = input frame {&frame-name} familia.codigo-orig.
                   /* cb-codigo-orig:lookup(cb-codigo-orig:screen-value). */
            assign aux-fator-conver = input frame {&frame-name} familia.fator-conver.
            assign aux-cd-trib-icm  = input frame {&frame-name} familia.cd-trib-icm.
            assign aux-cd-trib-ipi  = input frame {&frame-name} familia.cd-trib-ipi.
            assign aux-fraciona     = familia.fraciona:checked.
            assign aux-ind-imp-desc = cb-ind-imp-desc:lookup(cb-ind-imp-desc:screen-value).
            assign aux-deposito-pad = input frame {&frame-name} familia.deposito-pad.


          /***MULTIPLANTA***************************/

          run pi-finalizar in h-acomp.

       end.
&endif

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave V-table-Win 
PROCEDURE pi-leave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   {cdp/cd9998.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-servico V-table-Win 
PROCEDURE pi-valida-servico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

if input frame {&frame-name} familia.cod-servico:screen-value <> "0" 
   and input frame {&frame-name} familia.cod-servico:screen-value <> ? then do:

   find tab-codser where tab-codser.cod-servico = input frame {&frame-name} familia.cod-servico
        no-lock no-error.
   if not avail tab-codser then do:
       {utp/ut-field.i mgind familia cod-servico 1}
       run utp/ut-msgs.p (input "show",
                          input 47,
                          input return-value).
       apply "entry" to familia.cod-servico.
       return "nok".
  end.
end.

if  familia.class-fiscal:screen-value <> ""
and familia.class-fiscal:screen-value <> ? then do: 
    find classif-fisc where classif-fisc.class-fiscal = input frame {&frame-name} familia.class-fiscal 
         no-lock no-error.
         if not avail classif-fisc then do: 
             run utp/ut-msgs.p (input "show",
                                input 5670,
                                input return-value).     
             apply "entry" to familia.class-fiscal.
             return "nok".
         end.        
end.


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

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "fm-codigo" "familia" "fm-codigo"}
  {src/adm/template/sndkycas.i "class-fiscal" "familia" "class-fiscal"}
  {src/adm/template/sndkycas.i "cod-comprado" "familia" "cod-comprado"}
  {src/adm/template/sndkycas.i "nr-linha" "familia" "nr-linha"}
  {src/adm/template/sndkycas.i "cd-planejado" "familia" "cd-planejado"}
  {src/adm/template/sndkycas.i "un" "familia" "un"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "familia"}

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

