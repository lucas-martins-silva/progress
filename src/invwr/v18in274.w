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
{include/i-prgvrs.i V18IN274 2.00.00.015 } /*** "010015" 22/04/2024 14:19:13  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v18in274 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

/**  Caraiba
**/
def var l-permissao   as logical no-undo.
def var c-permissao-1 as char    no-undo.
def var c-permissao-2 as char    no-undo.
def buffer b-usuar-mater for usuar-mater.
/*****/

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

{cdp/cd0666.i}  /* tt-erro */
/* Integracao Contratos - declaracao temp-tables */
{cnp/cnapi020.i}

def var i-empresa like param-global.empresa-prin no-undo.

def var v_titulo_ccusto      as char   no-undo.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Número" column-label "Número"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistºncia"
    .

def var v_cod_formato      as char   no-undo.
def var v_cod_formato1     as char   no-undo.
def var h_api_cta_ctbl     as handle no-undo.
def var h_api_ccusto       as handle no-undo.
def var v_cod_cta_ctbl     as char   no-undo.
def var v_des_cta_ctbl     as char   no-undo.
def var v_ind_finalid_cta  as char   no-undo.
def var v_cod_ccusto       as char   no-undo.
def var v_des_ccusto       as char   no-undo.
DEF VAR v_des_cta          AS CHAR   NO-UNDO.
def var v_num_tip_cta      as int    no-undo.
def var v_num_sit_cta      as int    no-undo.
DEF VAR c-lista-estoque    AS CHAR   NO-UNDO.
DEF VAR i-lista-estoque    AS INT    NO-UNDO.
def var v_num_tip_cta_ctbl as int    no-undo.
def var v_num_sit_cta_ctbl as int    no-undo.
DEF VAR c-cod-ccusto       AS CHAR   NO-UNDO.

DEF VAR c-desc-conta       AS CHAR   NO-UNDO.
DEF VAR c-desc-ccusto      AS CHAR   NO-UNDO.
DEF VAR c-zoom-cod-conta   AS CHAR   NO-UNDO.
DEF VAR c-zoom-desc-conta  AS CHAR   NO-UNDO.
DEF VAR c-zoom-cod-ccusto  AS CHAR   NO-UNDO.
DEF VAR c-zoom-desc-ccusto AS CHAR   NO-UNDO.
DEF VAR c-conta            AS CHAR   NO-UNDO.
def var v_log_utz_ccusto   as log    no-undo.
DEF VAR i-num-tip-cta-cta  AS INT    NO-UNDO.
DEF VAR i-num-sit-cta      AS INT    NO-UNDO.
DEF VAR i-num-finalid-cta  AS INT    NO-UNDO.
DEF VAR l-utiliza-cc       AS LOG    NO-UNDO.
DEF VAR c-format-conta     AS CHAR   NO-UNDO.
DEF VAR c-format-ccusto    AS CHAR   NO-UNDO.
DEF VAR icont              AS INT    NO-UNDO.

/* Multiplanta */
def var l-erro as logical no-undo.
def var i-tipo-movto as integer no-undo.
def var c-msg as char no-undo.
/* ----------- */

def var c-estabelec as char no-undo.
DEF VAR l-integra-paradigma AS LOG NO-UNDO INITIAL NO.

def var c-formato-conta      as char no-undo.
DEF VAR c-formato-ccusto     AS CHAR NO-UNDO.
def var l-executou-zoom-dep  as log  no-undo.
def var c-dep-almoxar-ant     like ordem-compra.dep-almoxar.

/* Integraá∆o CNP X INP */
{cdp/cd9731.i}
{cdp/cd9730.i "new"}

/* Integraá∆o M¢dulo Importaá∆o */
{include/boerrtab.i}
{cdp/cd4300.i3}  /* tratamento atributo livre */
{ccp/cc9019.i50} /* tratamento atributo livre */

/***PTI-Status***/
&if defined (bf_mat_bloqueio_fornec) &then
    def var h-api029       as handle no-undo.
    def var i-situacao     as int    no-undo.  
    def var dt-vig-ini     as date   no-undo.  
    def var dt-vig-fim     as date   no-undo.  
    def var c-return       as char   no-undo.

    def temp-table tt-erro-2 no-undo
        field i-sequen as int             
        field cd-erro  as int
        field mensagem as char format "x(255)"
        field c-param  as char.

&endif

&IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
    DEFINE VARIABLE h-cdapi024      AS HANDLE                      NO-UNDO.
    DEFINE VARIABLE hProgramZoom    AS HANDLE                      NO-UNDO.
    
    DEFINE VARIABLE c-it-codigo     like ordem-compra.it-codigo    NO-UNDO.
    DEFINE VARIABLE c-cod-estabel   like ordem-compra.cod-estabel  NO-UNDO.
    DEFINE VARIABLE dt-data-emissao like ordem-compra.data-emissao NO-UNDO.
    DEFINE VARIABLE c-requisitante  like ordem-compra.requisitante NO-UNDO.

    {cdp/cd9590.i}    /*Include verificaá∆o Unidade Neg¢cio*/

    DEFINE VARIABLE l-unid-neg AS LOGICAL INIT NO NO-UNDO.
    
    def temp-table tt-erro-aux no-undo
        field i-sequen as int             
        field cd-erro  as int
        field mensagem as char format "x(255)".
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
&Scoped-define EXTERNAL-TABLES ordem-compra
&Scoped-define FIRST-EXTERNAL-TABLE ordem-compra


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ordem-compra.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ordem-compra.requisitante ~
ordem-compra.dep-almoxar ordem-compra.tp-despesa ordem-compra.ct-codigo ~
ordem-compra.sc-codigo 
&Scoped-define ENABLED-TABLES ordem-compra
&Scoped-define FIRST-ENABLED-TABLE ordem-compra
&Scoped-Define ENABLED-OBJECTS rt-mold cb-local-entrega c-cod-incoterm ~
i-pto-contr-base 
&Scoped-Define DISPLAYED-FIELDS ordem-compra.nr-contrato ~
ordem-compra.numero-ordem ordem-compra.it-codigo ordem-compra.requisitante ~
ordem-compra.dep-almoxar ordem-compra.cod-comprado ordem-compra.cod-estabel ~
ordem-compra.data-emissao ordem-compra.tp-despesa ordem-compra.ct-codigo ~
ordem-compra.sc-codigo 
&Scoped-define DISPLAYED-TABLES ordem-compra
&Scoped-define FIRST-DISPLAYED-TABLE ordem-compra
&Scoped-Define DISPLAYED-OBJECTS c-desc-contrato c-desc-item cb-natureza ~
cb-codigo-icm cb-situacao cb-origem cb-local-entrega c-cod-unid-negoc ~
c-desc-un c-desc-despesa fi-conta fi-centro-custo c-cod-incoterm ~
i-pto-contr-base c-pto-contr-base 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS cb-situacao 
&Scoped-define ADM-MODIFY-FIELDS ordem-compra.nr-contrato 

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
DEFINE VARIABLE cb-codigo-icm AS CHARACTER FORMAT "X(256)":U 
     LABEL "icm" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-local-entrega AS CHARACTER FORMAT "X(256)":U 
     LABEL "Local Entrega" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 22.14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-natureza AS CHARACTER FORMAT "X(256)":U 
     LABEL "natureza" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-origem AS CHARACTER FORMAT "X(256)":U 
     LABEL "origem" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-situacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "situaá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-incoterm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Incoterm" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-contrato AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-despesa AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 50.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-un AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-pto-contr-base AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 15.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-centro-custo AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 36.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-pto-contr-base AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Ponto Controle Base" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 12.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ordem-compra.nr-contrato AT ROW 1.17 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-contrato AT ROW 1.17 COL 33.72 COLON-ALIGNED NO-LABEL
     ordem-compra.numero-ordem AT ROW 2.17 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     ordem-compra.it-codigo AT ROW 3.17 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item AT ROW 3.17 COL 33.72 COLON-ALIGNED NO-LABEL
     cb-natureza AT ROW 4.17 COL 16.57 COLON-ALIGNED
     cb-codigo-icm AT ROW 4.17 COL 60.29 COLON-ALIGNED
     cb-situacao AT ROW 5.17 COL 16.57 COLON-ALIGNED
     ordem-compra.requisitante AT ROW 5.17 COL 60.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     cb-origem AT ROW 6.17 COL 16.57 COLON-ALIGNED
     ordem-compra.dep-almoxar AT ROW 6.17 COL 60.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     ordem-compra.cod-comprado AT ROW 7.17 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     ordem-compra.cod-estabel AT ROW 7.17 COL 60.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     ordem-compra.data-emissao AT ROW 8.17 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     cb-local-entrega AT ROW 8.17 COL 60.29 COLON-ALIGNED
     c-cod-unid-negoc AT ROW 9.17 COL 16.57 COLON-ALIGNED
     c-desc-un AT ROW 9.17 COL 22.14 COLON-ALIGNED NO-LABEL
     ordem-compra.tp-despesa AT ROW 9.17 COL 60.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-despesa AT ROW 9.17 COL 65.14 COLON-ALIGNED NO-LABEL
     ordem-compra.ct-codigo AT ROW 10.17 COL 16.57 COLON-ALIGNED WIDGET-ID 6 FORMAT "x(20)"
          VIEW-AS FILL-IN 
          SIZE 19 BY .88
     fi-conta AT ROW 10.17 COL 35.72 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     ordem-compra.sc-codigo AT ROW 11.17 COL 16.57 COLON-ALIGNED WIDGET-ID 8
          LABEL "Centro Custo":R11 FORMAT "x(20)"
          VIEW-AS FILL-IN 
          SIZE 19 BY .88
     fi-centro-custo AT ROW 11.17 COL 35.72 COLON-ALIGNED NO-LABEL
     c-cod-incoterm AT ROW 12.17 COL 16.57 COLON-ALIGNED
     i-pto-contr-base AT ROW 12.17 COL 60.29 COLON-ALIGNED
     c-pto-contr-base AT ROW 12.17 COL 67.57 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.ordem-compra
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
         HEIGHT             = 12.38
         WIDTH              = 86.43.
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
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 12.38
       FRAME f-main:WIDTH            = 86.43.

/* SETTINGS FOR FILL-IN c-cod-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-contrato IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-despesa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-pto-contr-base IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-codigo-icm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-natureza IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-origem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-situacao IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN ordem-compra.cod-comprado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ordem-compra.cod-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ordem-compra.ct-codigo IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN ordem-compra.data-emissao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-centro-custo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-conta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ordem-compra.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ordem-compra.nr-contrato IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN ordem-compra.numero-ordem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ordem-compra.sc-codigo IN FRAME f-main
   EXP-LABEL EXP-FORMAT                                                 */
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
ON F5 OF c-cod-unid-negoc IN FRAME f-main /* Unidade Neg¢cio */
DO:
  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
        {method/zoomfields.i &ProgramZoom="inzoom/z01in745.w"
                             &FieldZoom1="cod-unid-negoc"
                             &FieldScreen1="c-cod-unid-negoc"
                             &Frame1="f-main"
                             &EnableImplant="no"}
  &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc V-table-Win
ON LEAVE OF c-cod-unid-negoc IN FRAME f-main /* Unidade Neg¢cio */
DO:
  &if '{&bf_mat_versao_ems}' >= '2.062' &then
        if l-mat-unid-negoc then
            {include/leave.i &tabela=unid-negoc
                             &atributo-ref=des-unid-negoc
                             &variavel-ref=c-desc-un
                             &where="unid-negoc.cod-unid-negoc = input frame {&frame-name} c-cod-unid-negoc"}.
  &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-unid-negoc IN FRAME f-main /* Unidade Neg¢cio */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-desc-un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-desc-un V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-desc-un IN FRAME f-main
DO:
   &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
        apply 'F5' to self.
   &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ordem-compra.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.cod-estabel V-table-Win
ON F5 OF ordem-compra.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom=adzoom/z01ad107.w
                  &tabela=ordem-compra
                  &atributo=dep-almoxar}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ordem-compra.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ordem-compra.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.ct-codigo V-table-Win
ON ENTRY OF ordem-compra.ct-codigo IN FRAME f-main /* Conta */
DO:
    assign ordem-compra.ct-codigo:FORMAT    IN FRAME {&FRAME-NAME} = "x(20)"
           ordem-compra.sc-codigo:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.ct-codigo V-table-Win
ON F5 OF ordem-compra.ct-codigo IN FRAME f-main /* Conta */
DO:
    RUN pi-zoom-conta (OUTPUT c-zoom-cod-conta,
                       OUTPUT c-zoom-desc-conta).
    
    IF c-zoom-cod-conta <> "" THEN
        assign ordem-compra.ct-codigo:screen-value in frame {&FRAME-NAME} = c-zoom-cod-conta
               fi-conta:screen-value               in frame {&FRAME-NAME} = c-zoom-desc-conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.ct-codigo V-table-Win
ON LEAVE OF ordem-compra.ct-codigo IN FRAME f-main /* Conta */
DO:
    IF ordem-compra.ct-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:

        ASSIGN c-conta = replace(input frame {&frame-name} ordem-compra.ct-codigo,".","").
        RUN pi-desc-conta ( INPUT-OUTPUT c-conta,
                            OUTPUT       c-desc-conta,
                            OUTPUT       l-utiliza-cc).

        IF RETURN-VALUE = "OK" THEN DO:

            RUN pi-format-conta (OUTPUT c-format-conta).

            ASSIGN ordem-compra.ct-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-conta
                   ordem-compra.ct-codigo:FORMAT       IN FRAME {&FRAME-NAME} = c-format-conta
                   fi-conta:SCREEN-VALUE               IN FRAME {&FRAME-NAME} = c-desc-conta.

            IF NOT l-utiliza-cc THEN
                ASSIGN ordem-compra.sc-codigo:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
                       fi-centro-custo:SCREEN-VALUE        IN FRAME {&FRAME-NAME} = ""
                       ordem-compra.sc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
        END.
        ELSE
            ASSIGN ordem-compra.ct-codigo:FORMAT       IN FRAME {&FRAME-NAME} = "x(20)"
                   ordem-compra.ct-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   fi-conta:SCREEN-VALUE               IN FRAME {&FRAME-NAME} = ""
                   ordem-compra.sc-codigo:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
                   ordem-compra.sc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   fi-centro-custo:SCREEN-VALUE        IN FRAME {&FRAME-NAME} = "".

        if l-mat-unid-negoc then
            ASSIGN c-cod-unid-negoc:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    END.
    ELSE DO:
        ASSIGN ordem-compra.ct-codigo:FORMAT       IN FRAME {&FRAME-NAME} = "x(20)"
               fi-conta:SCREEN-VALUE               IN FRAME {&FRAME-NAME} = ""
               ordem-compra.sc-codigo:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
               ordem-compra.sc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               fi-centro-custo:SCREEN-VALUE        IN FRAME {&FRAME-NAME} = ""
               c-cod-unid-negoc:SENSITIVE          IN FRAME {&FRAME-NAME} = NO.

        RUN pi-sugere-un-ext IN THIS-PROCEDURE.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.ct-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ordem-compra.ct-codigo IN FRAME f-main /* Conta */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ordem-compra.dep-almoxar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.dep-almoxar V-table-Win
ON ENTRY OF ordem-compra.dep-almoxar IN FRAME f-main /* Dep¢sito */
DO:
  if not l-executou-zoom-dep then
        assign c-dep-almoxar-ant = input frame {&frame-name} ordem-compra.dep-almoxar.
    
    assign l-executou-zoom-dep = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.dep-almoxar V-table-Win
ON F5 OF ordem-compra.dep-almoxar IN FRAME f-main /* Dep¢sito */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in084.w   
                     &campo=ordem-compra.dep-almoxar
                     &campozoom=cod-depos}
  assign l-executou-zoom-dep = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.dep-almoxar V-table-Win
ON LEAVE OF ordem-compra.dep-almoxar IN FRAME f-main /* Dep¢sito */
DO:
  /***********************UNIDADE DE NEG‡CIO************************/
  &if '{&bf_mat_versao_ems}' >= '2.062' &THEN
    /*Se a unidade de neg¢cio ainda n∆o fora sugerida, ou o dep¢sito tenha sido alterado,
      ser† chamada a procedure para sugerir uma UN*/
    if  l-mat-unid-negoc and
       (input frame {&frame-name} c-cod-unid-negoc = "" or 
        input frame {&frame-name} ordem-compra.dep-almoxar <> c-dep-almoxar-ant)then
        run pi-sugere-un-ext.
  &endif
  
  assign c-dep-almoxar-ant = input frame {&frame-name} ordem-compra.dep-almoxar.
  /***********************UNIDADE DE NEG‡CIO************************/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.dep-almoxar V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ordem-compra.dep-almoxar IN FRAME f-main /* Dep¢sito */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-pto-contr-base
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-pto-contr-base V-table-Win
ON F5 OF i-pto-contr-base IN FRAME f-main /* Ponto Controle Base */
DO:
    {include/zoomvar.i &prog-zoom=cxzoom/z01cx110.w
                      &campo=i-pto-contr-base
                      &campozoom=cod-pto-contr}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-pto-contr-base V-table-Win
ON LEAVE OF i-pto-contr-base IN FRAME f-main /* Ponto Controle Base */
DO:
    def var h-bocx110   as handle no-undo.
    def var c-descricao as char   no-undo.    
    def var c-return    as char   no-undo.

    assign input frame {&frame-name} i-pto-contr-base.
    run cxbo/bocx110.p persistent set h-bocx110.
    run findCodigo in h-bocx110 (input i-pto-contr-base,
                                 output c-return).
    if c-return = "" then
        run getCharfield in h-bocx110 (input "descricao":U,output c-descricao).
    assign c-pto-contr-base:screen-value in frame {&frame-name} = c-descricao.
    delete procedure h-bocx110.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-pto-contr-base V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-pto-contr-base IN FRAME f-main /* Ponto Controle Base */
DO:
    apply "F5":U to self in frame {&frame-name}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ordem-compra.nr-contrato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.nr-contrato V-table-Win
ON F5 OF ordem-compra.nr-contrato IN FRAME f-main /* N£mero Contrato */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom=inzoom/z01in065.w   
                  &tabela=ordem-compra
                  &atributo=nr-contrato}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.nr-contrato V-table-Win
ON LEAVE OF ordem-compra.nr-contrato IN FRAME f-main /* N£mero Contrato */
DO:
     {include/leave.i &tabela=contrato-for
                      &atributo-ref=des-contrat
                      &variavel-ref=c-desc-contrato
                      &where="contrato-for.nr-contrato = input frame {&frame-name}
                              ordem-compra.nr-contrato"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.nr-contrato V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ordem-compra.nr-contrato IN FRAME f-main /* N£mero Contrato */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ordem-compra.numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.numero-ordem V-table-Win
ON F5 OF ordem-compra.numero-ordem IN FRAME f-main /* Ordem */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom=inzoom/z01in274.w   
                  &tabela=ordem-compra
                  &atributo=numero-ordem}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.numero-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ordem-compra.numero-ordem IN FRAME f-main /* Ordem */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ordem-compra.requisitante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.requisitante V-table-Win
ON F5 OF ordem-compra.requisitante IN FRAME f-main /* Requisitante */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z01in386.w
                       &campo=ordem-compra.requisitante
                       &campozoom=nome-abrev}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.requisitante V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ordem-compra.requisitante IN FRAME f-main /* Requisitante */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ordem-compra.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.sc-codigo V-table-Win
ON ENTRY OF ordem-compra.sc-codigo IN FRAME f-main /* Centro Custo */
DO:
    assign ordem-compra.sc-codigo:format in frame {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.sc-codigo V-table-Win
ON F5 OF ordem-compra.sc-codigo IN FRAME f-main /* Centro Custo */
DO:
    RUN pi-zoom-ccusto (OUTPUT c-zoom-cod-ccusto,
                        OUTPUT c-zoom-desc-ccusto).
   
    IF c-zoom-cod-ccusto <> "" THEN
        assign ordem-compra.sc-codigo:screen-value in frame {&FRAME-NAME} = c-zoom-cod-ccusto
               fi-centro-custo:screen-value        in frame {&FRAME-NAME} = c-zoom-desc-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.sc-codigo V-table-Win
ON LEAVE OF ordem-compra.sc-codigo IN FRAME f-main /* Centro Custo */
DO:

    IF ordem-compra.sc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:

        assign ordem-compra.sc-codigo:format in frame {&FRAME-NAME} = "x(20)".
        
        ASSIGN c-cod-ccusto = replace(input frame {&frame-name} ordem-compra.sc-codigo,".","").
        RUN pi-desc-ccusto (INPUT  replace(input frame {&frame-name} ordem-compra.sc-codigo,".",""),
                            OUTPUT c-desc-ccusto).

        IF c-desc-ccusto <> "" THEN DO:
            RUN pi-format-ccusto (OUTPUT c-format-ccusto).

            ASSIGN /*ordem-compra.sc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(c-cod-ccusto,c-format-ccusto)*/
                   ordem-compra.sc-codigo:FORMAT IN FRAME {&FRAME-NAME} = c-format-ccusto
                   fi-centro-custo:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = c-desc-ccusto.
        END.
        ELSE
            ASSIGN fi-centro-custo:SCREEN-VALUE        IN FRAME {&FRAME-NAME} = ""
                   ordem-compra.sc-codigo:FORMAT       IN FRAME {&FRAME-NAME} = "x(20)"
                   ordem-compra.sc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    END.
    ELSE DO:
        ASSIGN ordem-compra.sc-codigo:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
               fi-centro-custo:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.sc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ordem-compra.sc-codigo IN FRAME f-main /* Centro Custo */
DO:
   APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ordem-compra.tp-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.tp-despesa V-table-Win
ON F5 OF ordem-compra.tp-despesa IN FRAME f-main /* Tipo Despesa */
DO:
{include/zoomvar.i &prog-zoom=adzoom/z01ad259.w
                     &campo=ordem-compra.tp-despesa
                     &campozoom=tp-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.tp-despesa V-table-Win
ON LEAVE OF ordem-compra.tp-despesa IN FRAME f-main /* Tipo Despesa */
DO:
  {include/leave.i &tabela=tipo-rec-desp
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-despesa
                   &where="tipo-rec-desp.tp-codigo = input frame {&frame-name} ordem-compra.tp-despesa"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ordem-compra.tp-despesa V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ordem-compra.tp-despesa IN FRAME f-main /* Tipo Despesa */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

if ordem-compra.nr-contrato:load-mouse-pointer  ("Image~\lupa.cur") in frame {&frame-name} then.
if ordem-compra.numero-ordem:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if ordem-compra.dep-almoxar:load-mouse-pointer  ("Image~\lupa.cur") in frame {&frame-name} then.
if ordem-compra.cod-estabel:load-mouse-pointer  ("Image~\lupa.cur") in frame {&frame-name} then.
if ordem-compra.ct-codigo:load-mouse-pointer    ("Image~\lupa.cur") in frame {&frame-name} then.
if ordem-compra.sc-codigo:load-mouse-pointer    ("Image~\lupa.cur") in frame {&frame-name} then.
if ordem-compra.requisitante:LOAD-MOUSE-POINTER ("image~\lupa.cur") in frame {&frame-name} then.
IF ordem-compra.tp-despesa:LOAD-MOUSE-POINTER   ("image~\lupa.cur") IN FRAME {&FRAME-NAME} THEN.

&IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
 IF c-cod-unid-negoc:LOAD-MOUSE-POINTER ("image~\lupa.cur") IN FRAME {&FRAME-NAME} THEN.
&ENDIF

{utp/ut-field.i mgind ordem-compra codigo-icm 1}
assign cb-codigo-icm:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind ordem-compra natureza 1}
assign cb-natureza:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind ordem-compra origem 1}
assign cb-origem:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind ordem-compra situacao 1}
assign cb-situacao:label in frame {&frame-name} = return-value.

run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
  run prgint\utb\utb742za.py persistent set h_api_ccusto.

/* Integraá∆o M¢dulo Importaá∆o */
if i-pto-contr-base:load-mouse-pointer("image/lupa.cur") in frame {&frame-name} then.

{utp/ut-liter.i Incoterm * L}
assign c-cod-incoterm:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Ponto_Controle_Base * L}
assign i-pto-contr-base:label in frame {&frame-name} = trim(return-value).

&IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
   {utp/ut-liter.i Unidade_Neg¢cio * L}
   assign c-cod-unid-negoc:label in frame {&frame-name} = trim(return-value).
&ENDIF

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
  {src/adm/template/row-list.i "ordem-compra"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ordem-compra"}

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
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  

find first param-global no-lock no-error.

run cdp/cdapi181.p (input  c-seg-usuario,
                    input  2,
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
    {utp/ut-liter.i Itens_do_Contrato * r}
    assign c-permissao-2 = trim(return-value).
    run utp/ut-msgs.p (input "show",
                       input 18728,
                       input c-permissao-1 + "~~" + c-permissao-2).
    return "adm-error".
end.

find contrato-for where
    contrato-for.nr-contrato = input frame {&frame-name} ordem-compra.nr-contrato
    no-lock no-error.
find usuar-mater where
    usuar-mater.cod-usuar = c-seg-usuario
    no-lock no-error.
find b-usuar-mater where
    b-usuar-mater.cod-usuar = contrato-for.gestor-tecnico
    no-lock no-error.
if usuar-mater.cont-acesso-cc and
    usuar-mater.sc-codigo <> b-usuar-mater.sc-codigo then do:
    if adm-new-record then do:
        {utp/ut-liter.i Inlcuir_Ordens_a_Contratos * r}
        assign c-permissao-1 = trim(return-value).
    end.
    else do:
        {utp/ut-liter.i Modificar_Ordens_de_Contratos * r}
        assign c-permissao-1 = trim(return-value).
    end.
    {utp/ut-liter.i de_outro_Centro_de_Custo * r}
    assign c-permissao-2 = trim(return-value).
    run utp/ut-msgs.p (input "show",
                       input 18728 ,
                       input c-permissao-1 + "~~" + c-permissao-2).
    return "adm-error".
end.

if not adm-new-record then do:
    if usuar-mater.perm-alt-cont = no and
        usuar-mater.cod-usuario <> b-usuar-mater.cod-usuario then do:
        {utp/ut-liter.i Modificar_Ordens_de_Contratos * r}
        assign c-permissao-1 = trim(return-value).
        {utp/ut-liter.i de_outro_Usu†rio * r}
        assign c-permissao-2 = trim(return-value).
        run utp/ut-msgs.p (input "show",
                           input 18728,
                           input c-permissao-1 + "~~" + c-permissao-2).
        return "adm-error".
    end.
end.

find first requisitante 
     where requisitante.nome-abrev = input frame {&frame-name} ordem-compra.requisitante no-lock no-error.
if not avail requisitante then do:
    {utp/ut-table.i mgind requisitante 1}
    run utp/ut-msgs.p (input "show":U, input 47, input return-value).
    apply "entry" to ordem-compra.requisitante in frame {&frame-name}.
    return "adm-error".
end.

find  contrato-for
where contrato-for.nr-contrato = ordem-compra.nr-contrato
     no-lock no-error.

if  not avail contrato-for or
    not contrato-for.log-libera then do:
    run utp/ut-msgs.p (input "show", input 15208, input "").
    /* Contrato inativo*/
    return "adm-error".
end.

find  item-contrat
where item-contrat.nr-contrato  = contrato-for.nr-contrato 
  and item-contrat.num-seq-item = ordem-compra.num-seq-item no-lock no-error.

if  not avail item-contrat or
    not item-contrat.log-libera then do:
    run utp/ut-msgs.p (input "show", input 7838, input "").
    /* Item inativo no contrato */
    return "adm-error".
end.

&if defined(bf_mat_contratos) &then
    if  param-global.modulo-mp then do:
        run ccp/ccapi199.p(input "Ordem-contrato", rowid(ordem-compra),
                           output l-erro).
        if l-erro then do:
            {utp/ut-liter.i Ordem}
             assign c-msg = trim(return-value).
             {utp/ut-liter.i Executor}
            run utp/ut-msgs.p("show",18200,c-msg + "~~" + trim(return-value)).
            return "adm-error".
        end.
    end.
&endif

if input frame {&frame-name} ordem-compra.ct-codigo <> "" then do:
    
    ASSIGN c-conta = input frame {&frame-name} ordem-compra.ct-codigo.
    RUN pi-desc-conta ( INPUT-OUTPUT c-conta,
                        OUTPUT       c-desc-conta,
                        OUTPUT       l-utiliza-cc).

    if RETURN-VALUE = "nok" then do:
        run utp/ut-msgs.p ("show",19,"").
        apply 'entry' to ordem-compra.ct-codigo in frame {&frame-name}.
        return "adm-error".
    end.

    IF RETURN-VALUE = "OK" AND l-utiliza-cc THEN DO:
        if input frame {&frame-name} ordem-compra.sc-codigo <> "" then do:

            RUN pi-desc-ccusto (INPUT  input frame {&frame-name} ordem-compra.sc-codigo,
                                OUTPUT c-desc-ccusto).

            if RETURN-VALUE = "nok" then do:
                run utp/ut-msgs.p ("show",19,"").
                apply 'entry' to ordem-compra.sc-codigo in frame {&frame-name}.
                return "adm-error".
            end.
        end.
    END.
end.

find item where item.it-codigo = input frame {&frame-name} ordem-compra.it-codigo
    no-lock no-error.
if  avail item and 
   (item.tipo-contr = 1 or item.tipo-contr = 4) then do:

    assign v_cod_cta_ctbl = input frame {&frame-name} ordem-compra.ct-codigo.
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,         /* EMPRESA EMS 2 */
                                                   input        "",                /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,    /* CONTA */
                                                   input        today,             /* DATA TRANSACAO */   
                                                   output       v_des_cta,         /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta,     /* TIPO DA CONTA */
                                                   output       v_num_sit_cta,     /* SITUA∞ÄO DA CONTA */
                                                   output       v_ind_finalid_cta, /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro). 

    RUN pi_busca_dados_cta_ctbl_integr IN h_api_cta_ctbl (INPUT        i-empresa,         /* EMPRESA EMS2 */
                                                          INPUT        "CEP":U,           /* MÖDULO */
                                                          INPUT        "",                /* PLANO DE CONTAS */
                                                          INPUT        v_cod_cta_ctbl,    /* CONTA */
                                                          INPUT        today,             /* DATA TRANSACAO */   
                                                          OUTPUT       v_ind_finalid_cta, /* FINALIDADES DA CONTA */
                                                          OUTPUT table tt_log_erro).      /* ERROS */

    FIND FIRST tt_log_erro NO-ERROR.

    ASSIGN c-lista-estoque = v_ind_finalid_cta.

    DO icont = 1 TO NUM-ENTRIES(c-lista-estoque):
        IF {adinc/i05ad049.i 6 ENTRY(icont,c-lista-estoque) } <> 0 THEN DO:
            ASSIGN i-lista-estoque = {adinc/i05ad049.i 6 ENTRY(icont,c-lista-estoque) }.
        END.
    END.

    if NOT avail tt_log_erro then do:
        if ( v_num_tip_cta <> 1 and v_num_tip_cta <> 4 and
             v_num_tip_cta <> 5 and v_num_tip_cta <> 2    ) or v_num_sit_cta <> 3 then do:
            run utp/ut-msgs.p ( input "show",
                                input 1576,
                                input " " ).
            apply 'entry' to ordem-compra.ct-codigo in frame {&frame-name}.
            return "adm-error".
        end.
        if  param-global.modulo-ce then do:
            if  i-lista-estoque  = 0 
            or  (    i-lista-estoque <> 1 
                 and i-lista-estoque <> 2 
                 and i-lista-estoque <> 3 
                 and i-lista-estoque <> 5 
                 and i-lista-estoque <> 6 ) then do:

                run utp/ut-msgs.p ( input "show",
                                    input 1577,
                                    input "" ).
                apply 'entry' to ordem-compra.ct-codigo in frame {&frame-name}.
                return "adm-error".
            end.
        end.
    end.    
end.

&if defined(bf_mat_bloqueio_fornec) &then

    if (ordem-compra.nr-contrato:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
        ordem-compra.nr-contrato    <> input frame {&frame-name} ordem-compra.nr-contrato )
    or (ordem-compra.numero-ordem:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
        ordem-compra.numero-ordem   <> input frame {&frame-name} ordem-compra.numero-ordem )
    or (ordem-compra.it-codigo:SENSITIVE IN FRAME {&frame-name} = YES AND
        ordem-compra.it-codigo      <> input frame {&frame-name} ordem-compra.it-codigo )
    or (ordem-compra.ct-codigo:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND 
        ordem-compra.ct-codigo <> input frame {&frame-name} ordem-compra.ct-codigo)
    or (ordem-compra.cod-comprado:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
        ordem-compra.cod-comprado   <> input frame {&frame-name} ordem-compra.cod-comprado )
    or (cb-natureza:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
        cb-natureza                 <> input frame {&frame-name} cb-natureza )
    or (cb-codigo-icm:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
        cb-codigo-icm               <> input frame {&frame-name} cb-codigo-icm )
    or (cb-origem:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
        cb-origem                   <> input frame {&frame-name} cb-origem )
    or (ordem-compra.requisitante:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
        ordem-compra.requisitante   <> input frame {&frame-name} ordem-compra.requisitante)
    or (ordem-compra.dep-almoxar:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
        ordem-compra.dep-almoxar    <> input frame {&frame-name} ordem-compra.dep-almoxar )
    or (ordem-compra.cod-estabel:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
        ordem-compra.cod-estabel    <> input frame {&frame-name} ordem-compra.cod-estabel )
    or (ordem-compra.data-emissao:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
        ordem-compra.data-emissao   <> input frame {&frame-name} ordem-compra.data-emissao)
    or (cb-local-entrega:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
        cb-local-entrega            <> input frame {&frame-name} cb-local-entrega)
    or (c-cod-incoterm:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
        c-cod-incoterm              <> input frame {&frame-name} c-cod-incoterm)
    or (i-pto-contr-base:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
        i-pto-contr-base            <> input frame {&frame-name} i-pto-contr-base )
    or (c-pto-contr-base:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
        c-pto-contr-base            <> input frame {&frame-name} c-pto-contr-base )
    /*or (cb-situacao:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
        cb-situacao             <> input frame {&frame-name} cb-situacao
       and input frame {&frame-name} cb-situacao <> "recebida")*/  then do:

        if avail contrato-for then do:
            run cdp/cdapi029.p (input  contrato-for.cod-comprado,
                                input  1,
                                input  today,
                                input  contrato-for.cod-emitente,
                                output i-situacao,
                                output dt-vig-ini,
                                output dt-vig-fim,
                                output table tt-erro-2).
            assign c-return = return-value.

            if can-find (first tt-erro-2) then
               run cdp/cd0669.w (table tt-erro-2).

            if c-return = "NOK":U then
                return "ADM-ERROR":U.
        end.
    end.
&endif
/****FIM validaá∆o fornecedor, PTI-Status******/

FIND tipo-rec-desp WHERE
     tipo-rec-desp.tp-codigo = INPUT FRAME {&FRAME-NAME} ordem-compra.tp-despesa NO-LOCK NO-ERROR.

IF NOT AVAIL tipo-rec-desp THEN DO:
   {utp/ut-table.i mgadm tipo-rec-desp 1}
   RUN utp/ut-msgs.p (INPUT "show":U,
                      INPUT 2,
                      INPUT RETURN-VALUE).
   APPLY 'entry':U TO ordem-compra.tp-despesa IN FRAME {&FRAME-NAME}.
   RETURN "adm-error".
END.

IF tipo-rec-desp.tipo = 1 THEN DO:
   {utp/ut-table.i mgadm tipo-rec-desp 1}
   RUN utp/ut-msgs.p (INPUT "show":U,
                      INPUT 146,
                      INPUT RETURN-VALUE).
   APPLY 'entry':U TO ordem-compra.tp-despesa IN FRAME {&FRAME-NAME}.
   RETURN "adm-error".
END.

/* Integracao Contratos - limpa registros temp-table integraá∆o */
{cnp/cnapi020.i4}
    /* Integracao Contratos - criar registro para integraá∆o */
{cnp/cnapi020.i1 1 2 "CN0304" " " "ordem-compra" ordem-compra "except ordem-compra.narrativa"}

/* Dispatch standard ADM method.                             */
RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

/* Atualiza a situacao da ordem e das parcelas */

/*assign ordem-compra.situacao = {ininc/i02in274.i 06 cb-situacao}.*/

assign input frame {&frame-name} cb-local-entrega
       ordem-compra.local-entrega = {ininc/i08in295.i 06 cb-local-entrega}.

assign ordem-compra.ct-codigo = input frame {&FRAME-NAME} ordem-compra.ct-codigo
       ordem-compra.sc-codigo = input frame {&FRAME-NAME} ordem-compra.sc-codigo.


/*********************************UNIDADE DE NEG‡CIO**********************************/
&IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
    IF  l-mat-unid-negoc THEN DO: /*ParÉmetro de materiais - Utiliza UN*/
        IF  NOT CAN-FIND(FIRST matriz-rat-med NO-LOCK
                         WHERE matriz-rat-med.numero-ordem = ordem-compra.numero-ordem)
        AND NOT CAN-FIND (FIRST unid-neg-ordem 
                          WHERE unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem) /* usado em ordem de MI */
        AND NOT CAN-FIND(FIRST unid-negoc NO-LOCK
                         WHERE unid-negoc.cod-unid-negoc = input frame {&frame-name} c-cod-unid-negoc) THEN DO:
            
            {utp/ut-field.i mgind unid-negoc cod-unid-negoc 1}
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 2,
                               INPUT RETURN-VALUE).
            
            UNDO, RETURN "adm-error":U.
        END.

        &if '{&bf_mat_versao_ems}' >= '2.062' &then
            if  l-unidade-negocio 
            and input frame {&frame-name} c-cod-unid-negoc <> "" then do:

                if not valid-handle(h-cdapi024) then
                    run cdp/cdapi024.p persistent set h-cdapi024.

                if valid-handle(h-cdapi024) then do:

                    /*UN X Estabelecimento*/
                    run ValidaUnidadeNegocioEstabel in h-cdapi024 (input  ordem-compra.cod-estabel,
                                                                   input  ordem-compra.data-emissao,
                                                                   input  input frame {&frame-name} c-cod-unid-negoc,
                                                                   output table tt-erro-aux).

                    /*UN X Usu†rio*/
                    run ValidaUnidadeNegocioUsuario in h-cdapi024 (input  ordem-compra.cod-comprado,
                                                                   input  input frame {&frame-name} c-cod-unid-negoc,
                                                                   output table tt-erro-aux append).
                   
                    /*Validacao Restricao Unidade Negocio*/
                    if not avail param-global then
                        find first param-global no-lock no-error.

                    &if "{&bf_mat_versao_ems}" <= "2.072" &then
                        assign l-unid-neg = if substring(param-global.char-2,31,1) = "2" then yes else no.
                    &else
                        assign l-unid-neg = param-global.log-validac-ems5.
                    &endif
                    
                    if  l-unid-neg 
                    and ordem-compra.ct-codigo <> "" then
                        run ValidaRestricoesUnidadeNegocio in h-cdapi024 (input  ordem-compra.cod-estabel,
                                                                          input  ordem-compra.ct-codigo,
                                                                          input  ordem-compra.sc-codigo,
                                                                          input  input frame {&frame-name} c-cod-unid-negoc,
                                                                          input  ordem-compra.data-emissao,
                                                                          input  no,
                                                                          output table tt-erro-aux append).

                    if can-find(first tt-erro-aux) then do:
                        run cdp/cd0666.w (input table tt-erro-aux).

                        RUN pi-finalizar IN h-cdapi024.

                        undo, return "adm-error":U.
                    end.
                end.
            end.
        &endif

        assign ordem-compra.cod-unid-negoc = input frame {&frame-name} c-cod-unid-negoc.
    END.
    else
        assign ordem-compra.cod-unid-negoc = "".
&endif

/*for each prazo-compra
    where prazo-compra.numero-ordem = ordem-compra.numero-ordem
    EXCLUSIVE-LOCK:
    if  prazo-compra.situacao <> 4 then   /* Eliminada */
        assign prazo-compra.situacao = {ininc/i02in274.i 06 cb-situacao}.         
end.*/

/**** Aprovaá∆o Eletrìnica ****/
find first param-compra  no-lock no-error.
find first param-contrat no-lock no-error.
if  param-compra.log-1 and param-contrat.log-1
then do:
     find contrato-for no-lock 
        where contrato-for.nr-contrato = ordem-compra.nr-contrato no-error.
     find first item-contrat 
        where item-contrat.nr-contrato = ordem-compra.nr-contrato 
          and item-contrat.it-codigo   = ordem-compra.it-codigo no-lock no-error.

     if  avail item-contrat
     and item-contrat.val-total = 0 
     and avail contrato-for 
     and contrato-for.dec-2 = 0 then
         run cdp/cdapi171.p (8, 2, rowid(ordem-compra)).
end.
/**** fim ****/

/* Integraá∆o CNP X INP */
if l-integra-cn-in and ordem-compra.num-ord-inv <> 0 then do:   
   for each prazo-compra
      where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
      and   prazo-compra.situacao <> 4
      no-lock:      
      &if defined(bf_mat_controle_verba) &then
          run inp/inapi358.p (input rowid(prazo-compra), no).
      &endif
      run inp/in2110a.p (input rowid(prazo-compra), "M").
      run inp/in2110b.p.
   end.   
   run inp/in2110.p (input rowid(ordem-compra) , "M").   
   run inp/in2110b.p.
   if return-value = "NOK":U then
      undo, return "adm-error":U.
end.

/* Integraá∆o M¢dulo Importaá∆o */
if param-global.modulo-07 then do:
    find emitente
        where emitente.cod-emitente = ordem-compra.cod-emitente no-lock no-error.
    if avail emitente 
        and (emitente.natureza = 3 or emitente.natureza = 4) then do:
        /* valida informacoes importacao */
        run imp/im9034.p (input ordem-compra.numero-ordem,
                          input input frame {&frame-name} c-cod-incoterm,
                          input input frame {&frame-name} i-pto-contr-base,
                          output table tt-bo-erro).
        find first tt-bo-erro no-error.
        if avail tt-bo-erro then do:
            run utp/ut-msgs.p (input "show":U,
                               input tt-bo-erro.cd-erro,
                               input tt-bo-erro.parametros).
            undo, return "adm-error":U.
        end.        
    end.
end.

IF l-integra-paradigma THEN DO:
    RUN ccp/ccapi342.p (INPUT  "ordem-compra":U,
                        INPUT  ROWID(ordem-compra),
                        OUTPUT TABLE RowErrors).

    if can-find (first RowErrors) then
        run cdp/cd0669.w (table tt-erro-2).

    if c-return = "NOK":U then
        undo, return "ADM-ERROR":U.
END.

/* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
/* Code placed here will execute AFTER standard behavior.    */

if  param-global.modulo-mp then
run ccp/ccapi200.p(input "Ordem-compra":U, rowid(ordem-compra),
                   input 2 , input-output table tt-erro).

/* Integracao Contratos - criar registro para integraá∆o */
{cnp/cnapi020.i1 2 2 "CN0304" " " "ordem-compra" ordem-compra "except ordem-compra.narrativa"}

/* Integracao Contratos - executa API integrar e validar erros */  
{cnp/cnapi020.i2 "NOK" yes}

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
  &if '{&bf_mat_versao_ems}' >= '2.062' &THEN
      if valid-handle(h-cdapi024) then
          RUN pi-finalizar IN h-cdapi024.
  &endif

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  delete object h_api_cta_ctbl.
  delete object h_api_ccusto.

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
  
  
  assign ordem-compra.ct-codigo:format in frame {&FRAME-NAME} = "x(20)"
         ordem-compra.sc-codigo:format in frame {&FRAME-NAME} = "x(20)".

  find contrato-for where 
       contrato-for.nr-contrato = ordem-compra.nr-contrato no-lock no-error.
   assign c-desc-contrato = if avail contrato-for then contrato-for.des-contrat else "":U.

  find item where 
       item.it-codigo = ordem-compra.it-codigo no-lock no-error.
  assign c-desc-item = if avail item then item.desc-item else "":U.   

  FIND tipo-rec-desp WHERE 
       tipo-rec-desp.tp-codigo = ordem-compra.tp-despesa NO-LOCK NO-ERROR.
  ASSIGN c-desc-despesa = IF AVAIL tipo-rec-desp THEN tipo-rec-desp.descricao ELSE "":U.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if  avail ordem-compra then do with frame {&frame-name}:
      assign cb-codigo-icm = {ininc/i01in082.i 04 ordem-compra.codigo-icm}
             cb-natureza   = {ininc/i01in274.i 04 ordem-compra.natureza}
             cb-origem     = {ininc/i03in274.i 04 ordem-compra.origem}.
             cb-local-entrega = {ininc/i08in295.i 04 ordem-compra.local-entrega} no-error.
      if ordem-compra.situacao <> 2 and ordem-compra.situacao <> 6 then 
         assign cb-situacao = {ininc/i02in274.i 04 2}.
      else 
         assign cb-situacao = {ininc/i02in274.i 04 ordem-compra.situacao}.

      APPLY "LEAVE" TO ordem-compra.ct-codigo IN FRAME {&FRAME-NAME}.
      APPLY "LEAVE" TO ordem-compra.sc-codigo IN FRAME {&FRAME-NAME}.

      find estabelec WHERE
           estabelec.cod-estabel = ordem-compra.cod-estabel no-lock no-error.
      if  avail estabelec THEN
         assign i-empresa = estabelec.ep-codigo.

      disp ordem-compra.ct-codigo
           ordem-compra.sc-codigo
           ordem-compra.cod-comprado
           ordem-compra.dep-almoxar
           ordem-compra.cod-estabel
           ordem-compra.data-emissao
           ordem-compra.requisitante
           cb-codigo-icm
           cb-natureza
           cb-natureza
           cb-origem
           cb-local-entrega
           cb-situacao.

    /* Integracao Modulo Importacao */       
    if avail param-global and param-global.modulo-07 then do:          
      if avail ordem-compra then do:        
        find emitente where emitente.cod-emitente = ordem-compra.cod-emitente no-lock no-error.
        if emitente.natureza = 3 or emitente.natureza = 4 then do:
            assign c-cod-incoterm:hidden   in frame {&frame-name}    = no
                   i-pto-contr-base:hidden in frame {&frame-name}    = no
                   c-pto-contr-base:hidden in frame {&frame-name}    = no
                   c-cod-incoterm:sensitive in frame {&frame-name}   = yes
                   i-pto-contr-base:sensitive in frame {&frame-name} = yes.
            find cotacao-item 
                where cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                  and cotacao-item.cot-aprovada exclusive-lock no-error.
            if avail cotacao-item then do:
                {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                {ccp/cc9019.i51 "yes"}
                assign c-cod-incoterm:screen-value in frame {&frame-name}   = c-cod-incoterm-i50
                       i-pto-contr-base:screen-value in frame {&frame-name} = string(i-cod-pto-contr-i50).
                apply "leave":U to i-pto-contr-base in frame {&frame-name}.                       
            end.                   
        end.
        else do:
            assign c-cod-incoterm:hidden in frame {&frame-name}   = yes
                   i-pto-contr-base:hidden in frame {&frame-name} = yes
                   c-pto-contr-base:hidden in frame {&frame-name} = yes.        
        end.
      end.
    end.

  end. 
  else do:
       assign cb-codigo-icm:screen-value = {ininc/i01in082.i 04 1}
              cb-natureza:screen-value   = {ininc/i01in274.i 04 1}
              cb-origem:screen-value     = {ininc/i03in274.i 04 1}
              cb-situacao:screen-value   = {ininc/i02in274.i 04 2}.
  end.

  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
    IF  l-mat-unid-negoc THEN DO:
        ASSIGN c-cod-unid-negoc = ordem-compra.cod-unid-negoc.
        DISP c-cod-unid-negoc WITH FRAME {&FRAME-NAME}.
        APPLY 'leave' TO c-cod-unid-negoc IN FRAME {&FRAME-NAME}.
    END.
  &ENDIF

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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /*assign cb-situacao:sensitive in frame {&frame-name} = not adm-new-record.*/

  if adm-new-record = yes then  
    &if defined(ADM-MODIFY-FIELDS) &then
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

  {utp/ut-liter.i Local_Entrega * r }
  assign cb-local-entrega:label in frame {&frame-name} = trim(return-value)
  .
  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
      ASSIGN cAuxTraducao001 = {ininc/i08in295.i 03}.
      RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
      ASSIGN cb-local-entrega:LIST-ITEM-PAIRS in frame {&frame-name} = cAuxTraducao001.
  &else
      ASSIGN cb-local-entrega:list-items in frame {&frame-name} = {ininc/i08in295.i 03}.
  &endif

  if cb-situacao:add-last({ininc/i02in274.i 04 2}) in frame {&frame-name} then.
  if cb-situacao:add-last({ininc/i02in274.i 04 6}) in frame {&frame-name} then.

  do  with frame {&frame-name}: 
      assign cb-codigo-icm:list-items = {ininc/i01in082.i 03}
             cb-natureza:list-items   = {ininc/i01in274.i 03}
             cb-origem:list-items     = {ininc/i03in274.i 03}.
  end.        

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  find first param-global no-lock no-error.

  /***********************UNIDADE DE NEG‡CIO************************/
  &if '{&bf_mat_versao_ems}' >= '2.062' &THEN
    assign c-cod-unid-negoc:hidden    in frame {&frame-name} = no
           c-desc-un:hidden           in frame {&frame-name} = no.
    if l-mat-unid-negoc then do: /*ParÉmetro de materiais - Utiliza UN*/
       run cdp/cdapi024.p persistent set h-cdapi024.
    end.
    else
       assign c-cod-unid-negoc:sensitive in frame {&frame-name} = no.
  &else
    assign c-cod-unid-negoc:hidden    in frame {&frame-name} = yes
           c-desc-un:hidden           in frame {&frame-name} = yes.
  &endif
  /***********************UNIDADE DE NEG‡CIO************************/

    FIND FIRST funcao NO-LOCK
         WHERE funcao.cd-funcao = "spp-portal-paradigma":U
           AND funcao.ativo NO-ERROR.
    
    IF AVAIL funcao THEN DO:
    
        IF NOT AVAIL param-compra THEN
            FIND FIRST param-compra NO-LOCK NO-ERROR.
    
        IF &if "{&bf_mat_versao_ems}" < "2.09" &then
               SUBSTRING(param-compra.char-2,103,1) = "S":U
           &ELSE
               param-compra.log-portal-paradigma
           &ENDIF
        THEN DO:
            ASSIGN l-integra-paradigma = YES.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-dados-un V-table-Win 
PROCEDURE pi-atualiza-dados-un :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
    ASSIGN c-it-codigo     = INPUT FRAME {&frame-name} ordem-compra.it-codigo
           c-cod-estabel   = INPUT FRAME {&FRAME-NAME} ordem-compra.cod-estabel
           dt-data-emissao = INPUT FRAME {&FRAME-NAME} ordem-compra.data-emissao
           c-requisitante  = INPUT FRAME {&FRAME-NAME} ordem-compra.requisitante.
&endif
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desc-ccusto V-table-Win 
PROCEDURE pi-desc-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-ccuto       AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-desc-ccusto AS CHAR NO-UNDO.

    ASSIGN p-desc-ccusto = ''.

    run pi_busca_dados_ccusto in h_api_ccusto (input  STRING(i-empresa),         /* EMPRESA EMS2 */
                                               input  "",                        /* CODIGO DO PLANO CCUSTO */
                                               input  p-ccuto,                   /* CCUSTO */
                                               input  ordem-compra.data-emissao, /* DATA DE TRANSACAO */
                                               output v_des_ccusto,              /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro).        /* ERROS */
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".
    
    ASSIGN p-desc-ccusto = v_des_ccusto.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desc-conta V-table-Win 
PROCEDURE pi-desc-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT-OUTPUT PARAM p-conta      AS CHAR NO-UNDO.
    DEF OUTPUT       PARAM p-desc-conta AS CHAR NO-UNDO.
    DEF OUTPUT       PARAM p-utiliza-cc AS LOG  NO-UNDO.

    ASSIGN p-desc-conta = ''.

    EMPTY TEMP-TABLE tt_log_erro.

    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        i-empresa,                 /* EMPRESA EMS2 */
                                                   INPUT        "",                        /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT p-conta,                   /* CONTA */
                                                   INPUT        ordem-compra.data-emissao, /* DATA TRANSACAO */   
                                                   OUTPUT       v_des_cta_ctbl,            /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".

    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,                 /* EMPRESA EMS 2 */
                                                       input  "",                        /* ESTABELECIMENTO EMS2 */
                                                       input  "",                        /* PLANO CONTAS */
                                                       input  p-conta,                   /* CONTA */
                                                       input  ordem-compra.data-emissao, /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,          /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro).        /* ERROS */
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".

    ASSIGN p-desc-conta = v_des_cta_ctbl
           p-utiliza-cc = v_log_utz_ccusto.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-format-ccusto V-table-Win 
PROCEDURE pi-format-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM p-format-ccusto AS CHAR NO-UNDO.

    ASSIGN v_cod_formato   = ""
           c-format-ccusto = "".

    run pi_retorna_formato_ccusto in h_api_ccusto (input  STRING(i-empresa),         /* EMPRESA EMS2 */
                                                   input  "",                        /* PLANO CCUSTO */
                                                   input  ordem-compra.data-emissao, /* DATA DE TRANSACAO */
                                                   output v_cod_formato,             /* FORMATO CCUSTO */
                                                   output table tt_log_erro).        /* ERROS */

    ASSIGN p-format-ccusto = v_cod_formato.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-format-conta V-table-Win 
PROCEDURE pi-format-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM p-format-conta AS CHAR NO-UNDO.

    ASSIGN v_cod_formato = ''.

    run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,                 /* EMPRESA EMS2 */
                                                       input  "",                        /* PLANO CONTAS */
                                                       input  ordem-compra.data-emissao, /* DATA DE TRANSACAO */ 
                                                       output v_cod_formato,             /* FORMATO CONTA */
                                                       output table tt_log_erro).        /* ERROS */

    ASSIGN p-format-conta = v_cod_formato.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-sugere-un-ext V-table-Win 
PROCEDURE pi-sugere-un-ext :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
    /*ParÉmetro de materiais - Utiliza UN*/
    if l-mat-unid-negoc then do:
        if not adm-new-record then do:
            if avail ordem-compra then do:
                if not can-find (first unid-neg-ordem where
                                       unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem) then do:
                    /*Campos de outras viwers*/
                    run pi-atualiza-dados-un.
                    /*Sugere UN 
                      1) Estabel x Item x Dep¢sito
                      2) Estabel x Item*/
                    if valid-handle(h-cdapi024) then
                        run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input c-cod-estabel,
                                                                           input c-it-codigo,
                                                                           input input frame {&frame-name} ordem-compra.dep-almoxar,
                                                                           output c-cod-unid-negoc).

                    disp c-cod-unid-negoc with frame {&frame-name}.
                    apply 'leave' to c-cod-unid-negoc in frame {&frame-name}.
            
                    /*Retira o formato da conta cont†bil*/
                    assign ordem-compra.ct-codigo:format in frame {&frame-name} = "x(20)".
            
                    /*Se a conta cont†bil n∆o fora informada, n∆o poder† ser alterada a unidade de neg¢cio
                      pois o item permanecer† em estoque.*/
                    if input frame {&frame-name} ordem-compra.ct-codigo = "" then
                        assign c-cod-unid-negoc:sensitive in frame {&frame-name} = no.
                    ELSE DO:
                        /*Retorna o formato da conta cont†bil*/
                        assign ordem-compra.ct-codigo:format in frame {&frame-name} = v_cod_formato.
                        assign c-cod-unid-negoc:sensitive in frame {&frame-name} = yes.
                    END.
                end.
                else do:
                    /* Se tem matriz limpa a unidade... */
                    assign c-cod-unid-negoc:screen-value in frame {&frame-name} = "".
                    apply 'leave' to c-cod-unid-negoc in frame {&frame-name}.

                    run pi-atualiza-dados-un.

                    /* Retira o formato da conta cont†bil */
                    assign ordem-compra.ct-codigo:format in frame {&frame-name} = "x(20)".

                    /* ...PorÇm, se n∆o tem conta, n∆o pode ter matriz, ent∆o sugere a unidade do relacionamento */
                    if input frame {&frame-name} ordem-compra.ct-codigo = "" then do:
                        if l-mat-unid-negoc then do:
                            /*Sugere UN 
                              1) Estabel x Item x Dep¢sito
                              2) Estabel x Item*/
                            if valid-handle(h-cdapi024) then
                                run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input c-cod-estabel,
                                                                                   input c-it-codigo,
                                                                                   input input frame {&frame-name} ordem-compra.dep-almoxar,
                                                                                  output c-cod-unid-negoc).
                            disp c-cod-unid-negoc with frame {&frame-name}.
                            apply 'leave' to c-cod-unid-negoc in frame {&frame-name}.
                        end.
                    end.
                    ELSE
                       /* Retorna o formato da conta cont†bil */
                       assign ordem-compra.ct-codigo:format in frame {&frame-name} = v_cod_formato.
                end.
            end.
        end.
        else do:
            /*Campos de outras viwers*/
            run pi-atualiza-dados-un.
    
            /*Sugere UN 
              1) Estabel x Item x Dep¢sito
              2) Estabel x Item*/
            if valid-handle(h-cdapi024) then
                run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input c-cod-estabel,
                                                                   input c-it-codigo,
                                                                   input input frame {&frame-name} ordem-compra.dep-almoxar,
                                                                   output c-cod-unid-negoc).
            
            disp c-cod-unid-negoc with frame {&frame-name}.
            apply 'leave' to c-cod-unid-negoc in frame {&frame-name}.
    
            /*Retira o formato da conta cont†bil*/
            assign ordem-compra.ct-codigo:format in frame {&frame-name} = "x(20)".
    
            /*Se a conta cont†bil n∆o fora informada, n∆o poder† ser alterada a unidade de neg¢cio
              pois o item permanecer† em estoque.*/
            if input frame {&frame-name} ordem-compra.ct-codigo = "" then
                assign c-cod-unid-negoc:sensitive in frame {&frame-name} = no.
            else do:
                assign c-cod-unid-negoc:sensitive in frame {&frame-name} = yes.
                
                /*Retorna o formato da conta cont†bil*/
                assign ordem-compra.ct-codigo:format in frame {&frame-name} = v_cod_formato.
            end.
        end.
    end.

&ENDIF

return "OK".

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

/****In°cio validaá∆o fornecedor, PTI-Status***/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-ccusto V-table-Win 
PROCEDURE pi-zoom-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM p-ccusto      AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-desc-ccusto AS CHAR NO-UNDO.

    run pi_zoom_ccusto in h_api_ccusto (input string(i-empresa),   /* EMPRESA EMS2 */
                                        input "",                  /* CODIGO DO PLANO CCUSTO */
                                        input "",                  /* UNIDADE DE NEGOCIO */
                                        input today,               /* DATA DE TRANSACAO */
                                        output v_cod_ccusto,       /* CODIGO CCUSTO */
                                        output v_des_ccusto,       /* DESCRICAO CCUSTO */
                                        output table tt_log_erro). /* ERROS */ 

    ASSIGN p-ccusto      = v_cod_ccusto
           p-desc-ccusto = v_des_ccusto.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-conta V-table-Win 
PROCEDURE pi-zoom-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM p-conta      AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-desc-conta AS CHAR NO-UNDO.

    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  string(i-empresa),  /* EMPRESA EMS2 */
                                                   input  "CEP",              /* MÖDULO */
                                                   input  "",                 /* PLANO DE CONTAS */
                                                   input  "(nenhum)",         /* FINALIDADES */
                                                   input  today,              /* DATA TRANSACAO */
                                                   output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   output v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   output table tt_log_erro). /* ERROS */

    ASSIGN p-conta      = v_cod_cta_ctbl
           p-desc-conta = v_des_cta_ctbl.

    RETURN "ok".

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
  {src/adm/template/snd-list.i "ordem-compra"}

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

