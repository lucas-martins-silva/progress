&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            MSS
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
{include/i-prgvrs.i V19AD098 2.00.00.106 } /*** "010006" 08/10/2026 10:46:59 ***/
 
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v19ad098 MUT}
&ENDIF
 
/********************************************************************************
** Copyright DATFASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHARACTER FORMAT "x(12)" NO-UNDO.
DEF NEW SHARED VAR i-seleciona AS INTEGER.
DEF NEW SHARED VAR r-nat AS ROWID.
DEF NEW SHARED VAR r-emit AS ROWID.
DEF NEW SHARED VAR l-gera AS LOGICAL.
DEF NEW SHARED VAR l-gera-ext AS LOGICAL.
DEF NEW SHARED VAR l-temped AS LOGICAL INITIAL "yes". 

DEF VAR c-nat-operacao-old LIKE natur-oper.nat-operacao.
DEF VAR c-nat-ope-ext-old  LIKE natur-oper.nat-operacao.
DEF VAR c-nat-operacao     LIKE natur-oper.nat-operacao.
DEF VAR c-nat-ope-ext      LIKE natur-oper.nat-operacao.
DEF VAR i-transp-ant       LIKE emitente.cod-transp.
DEF VAR c-transp-ant       LIKE emitente.nome-tr-red.
DEF VAR c-tr-red-ant       LIKE emitente.nome-tr-red.
DEF VAR i-estab-ant        LIKE estab-cli.cod-estabel.
DEF VAR c-estado           LIKE emitente.estado.
DEF VAR c-ins-est          LIKE ped-venda.ins-estadual.
DEF VAR l-nat              AS LOGICAL NO-UNDO.
DEF VAR l-nat-ext          AS LOGICAL NO-UNDO.
DEF VAR i-cont             AS INTEGER NO-UNDO.
DEF VAR i-round            AS INTEGER.
DEF VAR l-arred            AS INTEGER.
DEF VAR de-vlmerc          AS DECIMAL.
DEF VAR l-resp1            AS LOGICAL.
DEF VAR l-resp2            AS LOGICAL.
DEF VAR h-handle-atual     AS HANDLE  NO-UNDO.
DEF VAR h-acomp            AS HANDLE  NO-UNDO.
DEF VAR l-oper             AS LOGICAL NO-UNDO.
DEF VAR l-ext              AS LOGICAL NO-UNDO.
DEF VAR i-parametro        AS INT INIT 1 NO-UNDO.
DEF VAR l-exporta          AS LOGICAL NO-UNDO.

DEF VAR p-exporta AS INTEGER FORMAT 99.
DEF VAR l-ok    AS LOGICAL.
DEF VAR p-transfere AS INTEGER FORMAT 99.

DEFINE VARIABLE h-boec010    AS HANDLE NO-UNDO. /* BO ecu-emitente   */

/**********Multiplanta*****************/

DEF VAR i-tipo-movto AS INTEGER NO-UNDO.

{cdp/cd7300.i1}
{cdp/cdapi209.i}
{cdp/cdcfgdis.i}
/**************Fim***********************/

/*************EAI***********************/
{METHOD/dbotterr.i} /* RowErrors */
DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro  AS INTEGER INITIAL ?
     FIELD ttv_des_msg_ajuda AS CHARACTER INITIAL ?
     FIELD ttv_des_msg_erro  AS CHARACTER INITIAL ?
      .

DEF TEMP-TABLE tt-old-emitente NO-UNDO LIKE emitente.

DEFINE BUFFER bf-emitente FOR emitente.

DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO. 
DEF VAR h-eai-emit               AS HANDLE  NO-UNDO.
DEF VAR hShowMsg                 AS HANDLE  NO-UNDO.

{local/ecu/ecu0117.i}
/*************Fim*************************/

/*************CRM************************/
DEF VAR h-cd1510-crm AS HANDLE  NO-UNDO.

ON WRITE OF emitente OLD BUFFER b-old-emitente DO:
   IF  emitente.nat-operacao = b-old-emitente.nat-operacao THEN
       ASSIGN c-nat-operacao = "".

  IF  emitente.nat-ope-ext = b-old-emitente.nat-ope-ext THEN
      ASSIGN c-nat-ope-ext = "".

  IF  emitente.nat-operacao <> b-old-emitente.nat-operacao
      OR  emitente.nat-ope-ext <> b-old-emitente.nat-ope-ext THEN
      IF  l-nat     = YES
          OR  l-nat-ext = YES THEN DO:
          RUN utp/ut-msgs.p (INPUT "show",
                             INPUT 536,
                             INPUT "").
          IF  RETURN-VALUE = "yes":U THEN DO:
              RUN "cdp/cd1510a1.p" (OUTPUT l-resp1, OUTPUT l-resp2).  
              {cdp/cd1510.i2} 
          END.
       END.                                                                                   
END.

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
&Scoped-define EXTERNAL-TABLES emitente
&Scoped-define FIRST-EXTERNAL-TABLE emitente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR emitente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS emitente.nome-tr-red emitente.nr-tabpre ~
emitente.nat-operacao emitente.nat-ope-ext emitente.cod-cond-pag ~
emitente.bonificacao emitente.ind-fat-par emitente.per-minfat ~
emitente.per-max-canc emitente.perc-fat-ped 
&Scoped-define ENABLED-TABLES emitente
&Scoped-define FIRST-ENABLED-TABLE emitente
&Scoped-Define ENABLED-OBJECTS RECT-43 RECT-1 
&Scoped-Define DISPLAYED-FIELDS emitente.nome-tr-red emitente.nr-tabpre ~
emitente.nat-operacao emitente.nat-ope-ext emitente.cod-cond-pag ~
emitente.bonificacao emitente.ind-fat-par emitente.per-minfat ~
emitente.per-max-canc emitente.perc-fat-ped
&Scoped-define DISPLAYED-TABLES emitente
&Scoped-define FIRST-DISPLAYED-TABLE emitente
&Scoped-Define DISPLAYED-OBJECTS c-transp-pad c-depos-ext tg-relac-item-cli ~
i-moeda-fatur c-moeda c-formaPago c-usuar-respons idi-niv-aces cx-tp-agrup-item ~
tg-perc-max-fat-item tg-agrup-nota cb-esp-ped tg-opt-simp-nac 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS c-transp-pad tg-relac-item-cli cb-esp-ped c-formaPago
&Scoped-define ADM-ASSIGN-FIELDS c-transp-pad cb-esp-ped c-formaPago
&Scoped-define ADM-MODIFY-FIELDS c-transp-pad tg-relac-item-cli c-depos-ext tg-perc-max-fat-item  tg-mais-neg-confirm-entrega ~
idi-niv-aces cb-esp-ped c-usuar-respons c-formaPago

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS> 
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


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-esp-ped AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cx-tp-agrup-item AS INTEGER FORMAT "9":U INITIAL 1 
     LABEL "Tipo Agrupamento Itens" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Sem agrupamento",1,
                     "Agrupamento item/preáo",2,
                     "Agrupamento item",3
     DROP-DOWN-LIST
     SIZE 20.86 BY 1 NO-UNDO.

DEFINE VARIABLE c-depos-ext AS CHARACTER FORMAT "X(3)":U 
     LABEL "Dep¢sito Externo" 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-fatur-ret AS CHARACTER FORMAT "X(30)":U INITIAL "Faturamento Retroativo" 
      VIEW-AS TEXT 
     SIZE 19 BY .67 NO-UNDO.

DEFINE VARIABLE c-formaPago AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Forma de Pago" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-transp-pad AS CHARACTER FORMAT "X(12)":U INITIAL "0" 
     LABEL "Transportador" 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-usuar-respons AS CHARACTER FORMAT "X(12)":U 
     LABEL "Usu†rio Respons†vel" 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88.

DEFINE VARIABLE i-moeda-fatur AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Moeda Faturamento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE idi-niv-aces AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Geral", 1,
"Restrito", 2
     SIZE 22 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39.86 BY 1.42.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39.86 BY 2.54.

DEFINE VARIABLE tg-agrup-nota AS LOGICAL INITIAL NO 
     LABEL "Apenas um Agrupamento por Nota" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mais-neg-confirm-entrega AS LOGICAL INITIAL no 
     LABEL "Confirmaá∆o Data Entrega Mais Neg¢cio" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.86 BY .83 TOOLTIP "?" NO-UNDO.

DEFINE VARIABLE tg-opt-simp-nac AS LOGICAL INITIAL no 
     LABEL "Optante Simples Nacional" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tg-perc-max-fat-item AS LOGICAL INITIAL NO 
     LABEL "Considera % M†x do Item Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-relac-item-cli AS LOGICAL INITIAL NO 
     LABEL "Obriga Relac Item Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.43 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-transp-pad AT ROW 1 COL 16.14 COLON-ALIGNED HELP
          "Transportadora Padr∆o"
     emitente.nome-tr-red AT ROW 1 COL 58.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     emitente.nr-tabpre AT ROW 2 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     c-depos-ext AT ROW 2 COL 58.43 COLON-ALIGNED
     tg-relac-item-cli AT ROW 2 COL 60.57
     emitente.nat-operacao AT ROW 3 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     emitente.nat-ope-ext AT ROW 3 COL 58.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     emitente.cod-cond-pag AT ROW 4 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     i-moeda-fatur AT ROW 4 COL 58.43 COLON-ALIGNED HELP
          "Moeda para Faturamento"
     c-moeda AT ROW 4 COL 63.57 COLON-ALIGNED HELP
          "Descriá∆o Moeda Faturamento" NO-LABEL
     emitente.bonificacao AT ROW 5 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     c-usuar-respons AT ROW 5 COL 58.43 COLON-ALIGNED HELP
          "Usuario Responsavel"
     c-formaPago AT ROW 5 COL 58.43 COLON-ALIGNED HELP
          "Forma de Pagamento" WIDGET-ID 2
     emitente.ind-fat-par AT ROW 6 COL 18.14
          VIEW-AS TOGGLE-BOX
          SIZE 19.86 BY .75
     idi-niv-aces AT ROW 6.63 COL 46.43 NO-LABEL WIDGET-ID 14
     emitente.per-minfat AT ROW 6.79 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     emitente.per-max-canc AT ROW 7.79 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     cx-tp-agrup-item AT ROW 8.71 COL 59.86 COLON-ALIGNED
     emitente.perc-fat-ped AT ROW 8.79 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     tg-perc-max-fat-item AT ROW 9.75 COL 18.14
     tg-agrup-nota AT ROW 9.75 COL 45.14
     cb-esp-ped AT ROW 10.79 COL 16.14 COLON-ALIGNED
     tg-opt-simp-nac AT ROW 11 COL 45.14 WIDGET-ID 18
     tg-mais-neg-confirm-entrega AT ROW 11.83 COL 18.14 HELP
          "Cliente possui Confirmaá∆o de Data de Entrega Mais Neg¢cio" WIDGET-ID 20
     c-fatur-ret AT ROW 7.96 COL 43.57 COLON-ALIGNED NO-LABEL
     "N°vel de Acesso" VIEW-AS TEXT
          SIZE 13 BY .67 AT ROW 5.96 COL 45 WIDGET-ID 12
     RECT-43 AT ROW 8.29 COL 44
     RECT-1 AT ROW 6.33 COL 82.86 RIGHT-ALIGNED WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.emitente
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
         HEIGHT             = 11.96
         WIDTH              = 83.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/METHOD/viewer.i}
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
       FRAME f-main:HEIGHT           = 11.96
       FRAME f-main:WIDTH            = 83.

/* SETTINGS FOR FILL-IN c-formaPago IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
ASSIGN 
       c-formaPago:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-transp-pad IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN c-usuar-respons IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-esp-ped IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cx-tp-agrup-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-moeda-fatur IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET idi-niv-aces IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-main
   ALIGN-R                                                              */
/* SETTINGS FOR TOGGLE-BOX tg-agrup-nota IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-relac-item-cli IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR COMBO-BOX tg-perc-max-fat-item IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX c-depos-ext IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
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

&Scoped-define SELF-NAME c-depos-ext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-ext V-table-Win
ON F5 OF c-depos-ext IN FRAME {&frame-name} /* Dep¢sito Externo */
OR MOUSE-SELECT-DBLCLICK OF c-depos-ext IN FRAME {&frame-name} DO:
    {include/zoomvar.i &prog-zoom="inzoom/z03in084.w"
                       &campo="c-depos-ext"
                       &campozoom="cod-depos"
                       &frame="{&frame-name}"
                       &parametros="run pi-seta-inicial in wh-pesquisa (input emitente.nome-abrev)."}                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-transp-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-transp-pad V-table-Win
ON F5 OF c-transp-pad IN FRAME f-main /* Transportador */
DO:
   ASSIGN l-implanta = YES.
  {include/zoomvar.i &prog-zoom="adzoom/z01ad268.w"
                     &campo=c-transp-pad
                     &campozoom=nome-abrev}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-transp-pad V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-transp-pad IN FRAME f-main /* Transportador */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-usuar-respons
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuar-respons V-table-Win
ON F5 OF c-usuar-respons IN FRAME f-main /* Usu†rio Respons†vel */
DO:
  {include/zoomvar.i &prog-zoom=unzoom/z01un343.w
                       &campo=c-usuar-respons
                       &campozoom=cod_usuario}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuar-respons V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-usuar-respons IN FRAME f-main /* Usu†rio Respons†vel */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emitente.cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.cod-cond-pag V-table-Win
ON F5 OF emitente.cod-cond-pag IN FRAME f-main /* Condiá∆o Pagamento */
DO:
  ASSIGN l-implanta = YES.
  {include/zoomvar.i &prog-zoom="adzoom/z01ad039.w"
                     &campo=emitente.cod-cond-pag  
                     &campozoom=cod-cond-pag}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.cod-cond-pag V-table-Win
ON MOUSE-SELECT-DBLCLICK OF emitente.cod-cond-pag IN FRAME f-main /* Condiá∆o Pagamento */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-moeda-fatur
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-moeda-fatur V-table-Win
ON F5 OF i-moeda-fatur IN FRAME f-main /* Moeda Faturamento */
DO:
  /*******************************************/
  /* Pre-processador Faturamento Outra Moeda */
  /*******************************************/
  &if  defined (bf_dis_fat_moeda) &then 
       IF para-fat.ind-legislacao = 1 THEN DO:
          l-implanta = YES.
          {include/zoomvar.i &prog-zoom = unzoom/z01un005.w
                             &campozoom = mo-codigo
                             &campo     = i-moeda-fatur}
       END.
  &endif.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-moeda-fatur V-table-Win
ON LEAVE OF i-moeda-fatur IN FRAME f-main /* Moeda Faturamento */
DO:
  /*******************************************/
  /* Pre-processador Faturamento Outra Moeda */
  /*******************************************/
  &if  defined (bf_dis_fat_moeda) &then 
       IF  para-fat.ind-legislacao = 1 THEN DO:
           FIND FIRST moeda 
                WHERE moeda.mo-codigo = INPUT i-moeda-fatur NO-LOCK NO-ERROR.
           IF  AVAIL moeda THEN 
               ASSIGN c-moeda:SCREEN-VALUE = STRING(moeda.descricao).
       END.
  &endif.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-moeda-fatur V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-moeda-fatur IN FRAME f-main /* Moeda Faturamento */
DO:
  /*******************************************/
  /* Pre-processador Faturamento Outra Moeda */
  /*******************************************/
  &if  defined (bf_dis_fat_moeda) &then 
       IF  para-fat.ind-legislacao = 1 THEN
           APPLY 'f5' TO SELF.
  &endif.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emitente.ind-fat-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.ind-fat-par V-table-Win
ON VALUE-CHANGED OF emitente.ind-fat-par IN FRAME f-main /* Faturamento Parcial */
DO:
   IF INPUT FRAME {&frame-name} emitente.ind-fat-par = NO THEN DO:
    DISP 0 @ emitente.per-minfat WITH FRAME {&frame-name}.
    DISABLE emitente.per-minfat WITH FRAME {&frame-name}.
  END.
  ELSE
    ENABLE emitente.per-minfat WITH FRAME {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emitente.nat-ope-ext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.nat-ope-ext V-table-Win
ON F5 OF emitente.nat-ope-ext IN FRAME f-main /* Natureza Interestadual */
DO:
  ASSIGN l-implanta = YES.
  {include/zoomvar.i &prog-zoom="inzoom/z01in245.w"
                     &campo=emitente.nat-ope-ext
                     &campozoom=nat-operacao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.nat-ope-ext V-table-Win
ON LEAVE OF emitente.nat-ope-ext IN FRAME f-main /* Natureza Interestadual */
DO:

/*  if  replace(replace(self:screen-value,".",""),"-","") <> "" then do.
 *     do i-cont = 1 to 5:
 *        if  substr(self:screen-value,i-cont,1) = "" then do:
 *          assign self:screen-value = ?.
 *        end.
 *     end.
 *   end.  
 *   else do:
 *     if i-pais-impto-usuario <> 1 then 
 *        assign self:screen-value = ?.
 *   end.     */

    &if  "{&bf_dis_versao_ems}"  <  "2.04"  &then
     IF REPLACE(REPLACE(SELF:SCREEN-VALUE, ".",""),"-","") <> "" THEN DO:
        IF SUBSTR(SELF:SCREEN-VALUE,1,1) = "" THEN DO:
            ASSIGN SELF:SCREEN-VALUE = ?.
        END.
     END.
     ELSE ASSIGN SELF:SCREEN-VALUE = ?.
    &else
    {cdp/cd9998.i}
    &endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.nat-ope-ext V-table-Win
ON MOUSE-SELECT-DBLCLICK OF emitente.nat-ope-ext IN FRAME f-main /* Natureza Interestadual */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emitente.nat-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.nat-operacao V-table-Win
ON F5 OF emitente.nat-operacao IN FRAME f-main /* Natureza Operaá∆o */
DO:
  ASSIGN l-implanta = YES.
  {include/zoomvar.i &prog-zoom="inzoom/z01in245.w"
                     &campo=emitente.nat-operacao
                     &campozoom=nat-operacao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.nat-operacao V-table-Win
ON LEAVE OF emitente.nat-operacao IN FRAME f-main /* Natureza Operaá∆o */
DO:
   {cdp/cd9998.i}

/*  if  replace(replace(self:screen-value,".",""),"-","") <> "" then 
 *   do i-cont = 1 to 5:
 *      if  substr(self:screen-value,i-cont,1) = "" then do:
 *          assign self:screen-value = ?.
 *      end.
 *   end.  
 *   else 
 *      assign self:screen-value = ?.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.nat-operacao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF emitente.nat-operacao IN FRAME f-main /* Natureza Operaá∆o */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emitente.nome-tr-red
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.nome-tr-red V-table-Win
ON F5 OF emitente.nome-tr-red IN FRAME f-main /* Transp Redespacho */
DO:
  ASSIGN l-implanta = YES.
  {include/zoomvar.i &prog-zoom="adzoom/z01ad268.w"
                     &campo=emitente.nome-tr-red
                     &campozoom=nome-abrev}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.nome-tr-red V-table-Win
ON MOUSE-SELECT-DBLCLICK OF emitente.nome-tr-red IN FRAME f-main /* Transp Redespacho */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME emitente.nr-tabpre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.nr-tabpre V-table-Win
ON F5 OF emitente.nr-tabpre IN FRAME f-main /* Tabela Preáos */
DO:
  ASSIGN l-implanta = YES.
  {include/zoomvar.i &prog-zoom="dizoom/z01di189.w"
                     &campo=emitente.nr-tabpre
                     &campozoom=nr-tabpre}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.nr-tabpre V-table-Win
ON MOUSE-SELECT-DBLCLICK OF emitente.nr-tabpre IN FRAME f-main /* Tabela Preáos */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  {utp/ut-liter.i Transportadora * L}
  ASSIGN c-transp-pad:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

  {utp/ut-liter.i Dep¢sito_Externo * L}
  ASSIGN c-depos-ext:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
  
  {utp/ut-liter.i Obriga_Relac_Item_x_Cliente * C}
  ASSIGN tg-relac-item-cli:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
  
  {utp/ut-liter.i "Considera_% M†x_do_Item_Cliente" * } 
  ASSIGN tg-perc-max-fat-item:LABEL IN FRAME f-main = RETURN-VALUE.
  {utp/ut-liter.i Considera_%_M†x_Fat_do_Item_Cliente *} 
  ASSIGN tg-perc-max-fat-item:HELP  IN FRAME f-main = RETURN-VALUE + " (CD0504)".

  IF c-transp-pad:LOAD-MOUSE-POINTER          ("image~\lupa.cur") IN FRAME {&frame-name} THEN.
  IF c-depos-ext:LOAD-MOUSE-POINTER           ("image~\lupa.cur") IN FRAME {&frame-name} THEN.
  IF emitente.nome-tr-red:LOAD-MOUSE-POINTER  ("image~\lupa.cur") IN FRAME {&frame-name} THEN.
  IF emitente.cod-cond-pag:LOAD-MOUSE-POINTER ("image~\lupa.cur") IN FRAME {&frame-name} THEN.
  IF emitente.nr-tabpre:LOAD-MOUSE-POINTER    ("image~\lupa.cur") IN FRAME {&frame-name} THEN.
  IF emitente.nat-operacao:LOAD-MOUSE-POINTER ("image~\lupa.cur") IN FRAME {&frame-name} THEN.
  IF emitente.nat-ope-ext:LOAD-MOUSE-POINTER  ("image~\lupa.cur") IN FRAME {&frame-name} THEN.

    

  &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
      
      {utp/ut-liter.i Faturamento_Retroativo * R} 
      ASSIGN c-fatur-ret:SCREEN-VALUE IN FRAME f-main = RETURN-VALUE.
      {utp/ut-liter.i Tipo_Agrupamento_Itens * R} 
      ASSIGN cx-tp-agrup-item:LABEL IN FRAME f-main = RETURN-VALUE
             cx-tp-agrup-item:HELP  IN FRAME f-main = RETURN-VALUE.
      {utp/ut-liter.i Apenas_um_Agrupamento_por_Nota? * R} 
      ASSIGN tg-agrup-nota:LABEL IN FRAME f-main = RETURN-VALUE
             tg-agrup-nota:HELP  IN FRAME f-main = RETURN-VALUE.
      {utp/ut-liter.i Optante_Simples_Nacional * R} 
      ASSIGN tg-opt-simp-nac:HELP  IN FRAME f-main = RETURN-VALUE.
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
  {src/adm/template/row-list.i "emitente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "emitente"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportaPercMaxFatPed V-table-Win 
PROCEDURE exportaPercMaxFatPed :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    {utp/ut-liter.i "Exportando..." *}                          
    RUN pi-inicializar IN h-acomp(INPUT RETURN-VALUE).

        FOR EACH item-cli EXCLUSIVE-LOCK        
           WHERE item-cli.nome-abrev = emitente.nome-abrev:
                
                IF (i-parametro = 2 AND item-cli.int-1 = tt-old-emitente.perc-fat-ped) OR i-parametro = 3 THEN DO:
                        RUN pi-acompanhar IN h-acomp (INPUT ("Item: " + item-cli.it-codigo)).
                        ASSIGN item-cli.int-1 = emitente.perc-fat-ped.
                END.    
        END.
        
        RUN pi-finalizar IN h-acomp.
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

  {utp/ut-liter.i Transportadora * L}
  ASSIGN c-transp-pad:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

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
    DEFINE VARIABLE lIntCRM11    AS LOGICAL NO-UNDO INITIAL FALSE.

    RUN utp/ut-crm11.p ( OUTPUT lIntCRM11) .
    
    ASSIGN l-oper = NO
       l-ext  = NO.
    /* Code placed here will execute PRIOR to standard behavior. */

    {include/i-valid.i}

    FOR EACH tt-old-emitente EXCLUSIVE-LOCK:
        DELETE tt-old-emitente.
    END.

    IF AVAIL emitente THEN DO:
       CREATE tt-old-emitente.
       BUFFER-COPY emitente TO tt-old-emitente NO-ERROR.
    END.
        
        /* Dispatch standard ADM method.*/
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
        
        ASSIGN OVERLAY(emitente.char-1,147,1) = IF tg-perc-max-fat-item:CHECKED IN FRAME {&frame-name} THEN "S" ELSE "N".

        FIND FIRST tt-old-emitente 
             WHERE tt-old-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
        
        IF (SUBSTRING(emitente.char-1,147,1) = "S" AND (SUBSTRING(emitente.char-1,147,1) <> SUBSTRING(tt-old-emitente.char-1,147,1) 
            OR emitente.perc-fat-ped <> tt-old-emitente.perc-fat-ped)) THEN DO:
                
                RUN setaParametros.
                
                IF l-exporta AND i-parametro > 1 THEN 
                        RUN exportaPercMaxFatPed.
        END.

    /* Projeto 751 - Conferància de Dados de Integraá∆o */
    IF AVAIL emitente THEN DO:
       &IF "{&BF_DIS_VERSAO_EMS}" < "2.071" &THEN
            ASSIGN emitente.data-1 = TODAY
                   OVERLAY(emitente.char-2,68,8) = STRING(TIME,"HH:MM:SS").
       &else
            ASSIGN emitente.dt-atualiza = TODAY
                   emitente.hra-atualiz = STRING(TIME,"HH:MM:SS").
       &endif
    END.
    /* Projeto 751 - Conferància de Dados de Integraá∆o */

    /*******************************************/
    /* Pre-processador Faturamento Outra Moeda */
    /*******************************************/

    FIND dist-emitente
         WHERE dist-emitente.cod-emitente = emitente.cod-emitente
         EXCLUSIVE-LOCK NO-ERROR.

    &if  defined (bf_dis_fat_moeda) &then 
         IF  para-fat.ind-legislacao = 1 THEN DO:
             IF  AVAIL dist-emitente THEN
                 ASSIGN dist-emitente.mo-fatur = INPUT FRAME {&frame-name} i-moeda-fatur.
         END.
    &endif

    IF AVAIL dist-emitente THEN DO:
        ASSIGN dist-emitente.log-obriga-item-cli   = tg-relac-item-cli:CHECKED IN FRAME {&frame-name}
               dist-emitente.idi-niv-aces          = INPUT FRAME {&frame-name} idi-niv-aces
               dist-emitente.cod-usuar-respons     = INPUT FRAME {&frame-name} c-usuar-respons
               dist-emitente.cod-dep-ext           = c-depos-ext:SCREEN-VALUE IN FRAME f-main  /*Gravar Dep¢sito Externo*/
               OVERLAY(dist-emitente.char-1, 82,1) = IF tg-mais-neg-confirm-entrega:CHECKED IN FRAME {&frame-name}  THEN 'S' ELSE 'N'.
    
                IF lIntCRM11 THEN DO:
                 IF NOT VALID-HANDLE(h-cd1510-crm) THEN
                         RUN integracoes/adapters/emstocrm/cd1510-crm.p PERSISTENT SET h-cd1510-crm.

                 RUN sendToCRM IN h-cd1510-crm (INPUT dist-emitente.cod-emitente,
                                                                                OUTPUT TABLE RowErrors).

                 IF CAN-FIND (FIRST RowErrors WHERE 
                                                        RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                         {METHOD/ShowMessage.i1}
                         {METHOD/ShowMessage.i2 &Modal="YES"}
                         UNDO, RETURN "ADM-ERROR":U.
                 END.
                 DELETE PROCEDURE h-cd1510-crm.
            END.         
        END.

    FIND FIRST emitente WHERE ROWID(emitente) = r-emit EXCLUSIVE-LOCK NO-ERROR.
    IF  AVAIL emitente THEN DO:
        IF l-ext THEN DO:
           IF i-pais-impto-usuario = 1 THEN DO:
              ASSIGN emitente.nat-ope-ext = ?.           
              DISP emitente.nat-ope-ext WITH FRAME {&frame-name}.
           END.   
        END.
        IF l-oper THEN DO:
           ASSIGN emitente.nat-operacao = " ".
           DISP emitente.nat-operacao WITH FRAME {&frame-name}.
           APPLY "leave" TO emitente.nat-operacao IN FRAME {&frame-name}.
        END.     
        ASSIGN emitente.ind-fat-par = INPUT FRAME {&frame-name} emitente.ind-fat-par.
    END.    

    FIND FIRST transporte WHERE
         transporte.nome-abrev = INPUT FRAME {&frame-name} c-transp-pad NO-LOCK NO-ERROR.
    IF  NOT AVAIL transporte THEN 
        FIND FIRST transporte WHERE 
             transporte.cod-transp = INTEGER(INPUT FRAME {&frame-name} c-transp-pad) NO-LOCK NO-ERROR.

    IF AVAIL transporte THEN
       ASSIGN emitente.cod-transp = transporte.cod-transp.

    ASSIGN INPUT FRAME {&frame-name} cb-esp-ped.
    ASSIGN emitente.esp-pd-venda = {adinc/i06ad098.i 06 cb-esp-ped}.

    /* Code placed here will execute AFTER standard behavior.    */

        /* Localizaá∆o Equador */
    IF  i-pais-impto-usuario = 21 THEN DO:
        RUN pi-salva-dados-tela. /* Popula a temp-table com os dados preenchidos em tela */        
        IF  CAN-FIND(FIRST tt-ecu-emitente-localiz WHERE tt-ecu-emitente-localiz.cod-docto <> "") THEN DO:
            RUN pi-cria-dados-localiz IN h-boec010 (INPUT TABLE tt-ecu-emitente-localiz).                 
            IF  RETURN-VALUE = "NOK":U THEN
                RETURN "adm-error":U.
        END.

    END.

    /*****************Multiplanta*******************/

    ASSIGN c-transacao = "DIS008".
    {cdp/cd7300.i5 "001" c-transacao}

    ASSIGN i-tipo-movto = 2.
    RUN pi-cria-tt-dados (INPUT i-tipo-movto).

    {cdp/cd7300.i6 "001" c-transacao}
    FIND FIRST tt-dados-env NO-ERROR.
    IF  AVAIL tt-dados-env THEN
        DELETE tt-dados-env.

   /**************Fim-Multiplanta*****************/

    /*  Integracao EAI  */
    IF v_log_eai_habilit THEN 
       IF VALID-HANDLE (h-eai-emit) THEN DO:
          EMPTY TEMP-TABLE tt_log_erro NO-ERROR.
          EMPTY TEMP-TABLE RowErrors   NO-ERROR. 
          RUN PITransUpsert IN h-eai-emit (INPUT ROWID(emitente),
                                           INPUT "upd":U,
                                           OUTPUT TABLE tt_log_erro).
          FIND FIRST tt_log_erro WHERE tt_log_erro.ttv_num_cod_erro <> 60 NO-LOCK NO-ERROR.
            IF AVAIL tt_log_erro THEN DO:
               CREATE RowErrors.
               ASSIGN RowErrors.ErrorSequence     = RowErrors.ErrorSequence + 1
                      RowErrors.ErrorNumber       = ttv_num_cod_erro
                      RowErrors.ErrorDescription  = ttv_des_msg_erro
                      RowErrors.ErrorHelp         = ttv_des_msg_erro.
            END.
            IF CAN-FIND(FIRST RowErrors) THEN DO:
               {METHOD/showmessage.i1}
               /*Transfere temp-table RowErrors para a tela de mensagens de erros*/
               {METHOD/showmessage.i2 &Modal="Yes"}
               RETURN 'ADM-ERROR':U.
            END.
       END.

    /************* Integracao 2.00 X 5.00 *****************/
    IF  CAN-FIND(funcao WHERE funcao.cd-funcao = "adm-cdc-ems-5.00"
        AND funcao.ativo = YES
        AND funcao.log-1 = YES) THEN DO:
        FIND FIRST param-global NO-LOCK NO-ERROR.
        IF  param-global.log-2 = YES THEN DO: 
            VALIDATE emitente NO-ERROR.
            RUN cdp/cd1608.p (INPUT emitente.cod-emitente,
                              INPUT emitente.cod-emitente,
                              INPUT emitente.identific,
                              INPUT YES,
                              INPUT 1,
                              INPUT 0,
                              INPUT "utb765zb.tmp",
                              INPUT "Terminal":U,
                              INPUT "").

        END.
    END.  
    /*********** Fim Integracao 2.00 X 5.00 ****************/

  &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
      IF  i-pais-impto-usuario = 1 THEN DO:

          ASSIGN OVERLAY(emitente.char-1,133,1) = IF tg-opt-simp-nac:CHECKED IN FRAME {&frame-name} THEN "S" ELSE "N".

          FIND dist-emitente
            WHERE dist-emitente.cod-emitente = emitente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
          IF  AVAIL dist-emitente THEN
            ASSIGN dist-emitente.idi-agrup-item       = INTEGER(cx-tp-agrup-item:SCREEN-VALUE IN FRAME f-main)
                   dist-emitente.log-agrup-unico-nota = tg-agrup-nota:CHECKED IN FRAME f-main.
      END.
 &ENDIF

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

  RUN pi-habilita(YES).

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
      DISABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&frame-name}.
  &endif

  /******************************************/
  /* Pre-processado Faturamento Outra Moeda */
  /******************************************/
  &if  defined (bf_dis_fat_moeda) &then  
       FIND FIRST dist-emitente
            WHERE dist-emitente.cod-emitente = emitente.cod-emitente 
            NO-LOCK NO-ERROR.
       IF  AVAIL dist-emitente THEN
           ASSIGN i-moeda-fatur:SENSITIVE IN FRAME {&frame-name} = NO.
  &endif

  &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
      IF  i-pais-impto-usuario = 1 THEN
          DISABLE cx-tp-agrup-item tg-agrup-nota tg-opt-simp-nac WITH FRAME f-main.
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

  /*******************************************/
  /* Pre-processador Faturamento Outra Moeda */
  /*******************************************/
  &if  defined (bf_dis_fat_moeda) &then
       IF  para-fat.ind-legislacao = 1 THEN DO:
           FIND dist-emitente
                WHERE dist-emitente.cod-emitente = emitente.cod-emitente
                NO-LOCK NO-ERROR.
           IF  AVAIL dist-emitente THEN
               ASSIGN i-moeda-fatur = dist-emitente.mo-fatur.
          FIND FIRST moeda 
                WHERE moeda.mo-codigo = i-moeda-fatur NO-LOCK NO-ERROR.
           IF  AVAIL moeda THEN 
               ASSIGN c-moeda = STRING(moeda.descricao).
        END.
  &endif                  


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

/*  {cdp/cd1510.i}*/
  

  APPLY "leave" TO emitente.nat-operacao IN FRAME {&frame-name}.
  APPLY "leave" TO emitente.nat-ope-ext  IN FRAME {&frame-name}.


  FIND gr-cli WHERE
       gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
    IF  emitente.cod-transp = 0 THEN
          FIND transporte WHERE
        transporte.cod-transp = emitente.cod-transp NO-LOCK NO-ERROR.
    ELSE                
       FIND transporte WHERE
            transporte.cod-transp = emitente.cod-transp NO-LOCK NO-ERROR.

    ASSIGN c-transp-pad:SCREEN-VALUE IN FRAME {&frame-name} = 
           IF AVAIL transporte THEN transporte.nome-abrev ELSE "0"
           i-transp-ant = emitente.cod-transp
           c-tr-red-ant = emitente.nome-tr-red.

  IF emitente.ind-fat-par:SENSITIVE IN FRAME {&frame-name} = NO THEN 
     DISABLE emitente.per-minfat WITH FRAME {&frame-name}.
  ELSE IF emitente.ind-fat-par = YES THEN 
     ENABLE emitente.per-minfat WITH FRAME {&frame-name}.   

  ASSIGN cb-esp-ped:SCREEN-VALUE IN FRAME {&frame-name}  = {adinc/i06ad098.i 04 emitente.esp-pd-venda}.

  FIND dist-emitente WHERE
       dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
  IF AVAIL dist-emitente THEN DO:
      ASSIGN tg-relac-item-cli:CHECKED IN FRAME {&frame-name} = dist-emitente.log-obriga-item-cli  
             idi-niv-aces:SCREEN-VALUE IN FRAME f-main        = IF dist-emitente.idi-niv-aces = 0 THEN "1" ELSE STRING(dist-emitente.idi-niv-aces)
             c-usuar-respons:SCREEN-VALUE IN FRAME f-main     = dist-emitente.cod-usuar-respons
             c-depos-ext:SCREEN-VALUE IN FRAME f-main         = TRIM(dist-emitente.cod-dep-ext) /* Mostrar Dep¢sito Externo*/
             tg-mais-neg-confirm-entrega:CHECKED IN FRAME {&frame-name} = IF SUBSTRING(dist-emitente.char-1, 82,1) = "S" THEN YES ELSE NO.
  END.
  ELSE DO:
      ASSIGN c-depos-ext:SCREEN-VALUE IN FRAME f-main = "".
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
      IF  i-pais-impto-usuario = 1 THEN DO:

          ASSIGN tg-opt-simp-nac:CHECKED IN FRAME {&FRAME-NAME}   = IF SUBSTRING(emitente.char-1,133,1) = "S" THEN YES ELSE NO.

          FIND dist-emitente
              WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
          IF  AVAIL dist-emitente THEN
              ASSIGN cx-tp-agrup-item:SCREEN-VALUE IN FRAME f-main = IF dist-emitente.idi-agrup-item = ? THEN '1' ELSE STRING(dist-emitente.idi-agrup-item)
                     tg-agrup-nota:CHECKED IN FRAME f-main         = dist-emitente.log-agrup-unico-nota.
      END.
  &ENDIF
  
  ASSIGN tg-perc-max-fat-item:CHECKED IN FRAME {&frame-name} = IF SUBSTRING(emitente.char-1,147,1) = "S" THEN YES ELSE NO.

  IF NOT CAN-FIND(FIRST hier_param WHERE hier_param.log_usa_regra_time) THEN DO:
        ASSIGN c-usuar-respons:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  END.

    IF  i-pais-impto-usuario = 21 /*Ecuador*/ AND AVAIL emitente AND VALID-HANDLE(h-boec010) THEN DO:
        ASSIGN c-formaPago:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
        RUN pi-busca-dados-localiz.
    END.
    ELSE ASSIGN c-formaPago:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.

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
      ENABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&frame-name}.
  &endif

  /******************************************/
  /* Pre-processado Faturamento Outra Moeda */
  /******************************************/
  &if  defined (bf_dis_fat_moeda) &then  
      IF  para-fat.ind-legislacao = 1 THEN DO:
          FIND FIRST dist-emitente
               WHERE dist-emitente.cod-emitente = emitente.cod-emitente 
               NO-LOCK NO-ERROR.
          IF  AVAIL dist-emitente THEN
               ASSIGN i-moeda-fatur:SENSITIVE IN FRAME {&frame-name} = user-coml.inf-moeda-fatur.
      END.
  &endif

  APPLY "entry" TO c-transp-pad.

  IF emitente.ind-fat-par = NO THEN DO:
     DISP 0 @ emitente.per-minfat WITH FRAME {&frame-name}.
     DISABLE emitente.per-minfat WITH FRAME {&frame-name}.
     ASSIGN emitente.per-minfat:SENSITIVE IN FRAME {&frame-name} = NO.
  END.
  ELSE DO:
     ENABLE emitente.per-minfat WITH FRAME {&frame-name}.
      ASSIGN emitente.per-minfat:SENSITIVE IN FRAME {&frame-name} = YES.
  END.

  IF  AVAIL emitente THEN
      ASSIGN cb-esp-ped:SCREEN-VALUE IN FRAME {&frame-name}  = {adinc/i06ad098.i 04 emitente.esp-pd-venda}.
  ELSE 
      ASSIGN cb-esp-ped:SCREEN-VALUE IN FRAME {&frame-name}  = {adinc/i06ad098.i 04 1}.

  &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
      IF  i-pais-impto-usuario = 1 THEN
          ENABLE cx-tp-agrup-item tg-agrup-nota tg-opt-simp-nac WITH FRAME f-main.
      ASSIGN tg-relac-item-cli:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  &ENDIF
  
  IF NOT CAN-FIND(FIRST hier_param WHERE hier_param.log_usa_regra_time) THEN DO:
        ASSIGN c-usuar-respons:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  END.
  ELSE DO:
      IF c-usuar-respons:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" OR
         idi-niv-aces:SCREEN-VALUE IN FRAME f-main = "1" OR
         c-usuar-respons:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_usuar_corren THEN DO:
          ASSIGN c-usuar-respons:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
      END.
      ELSE 
          ASSIGN c-usuar-respons:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  END.

    IF  i-pais-impto-usuario = 21 THEN ASSIGN c-formaPago:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
    ELSE ASSIGN c-formaPago:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.

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

  DEFINE VARIABLE l-modific  AS LOGICAL INITIAL YES NO-UNDO.
  DEFINE VARIABLE l-anterior AS LOGICAL INITIAL YES NO-UNDO.

  IF AVAIL emitente THEN DO:

     IF CAN-FIND(FIRST distrib-emit-estab
                 WHERE distrib-emit-estab.cod-emitente = emitente.cod-emitente) THEN
        RUN cdp/cd1510d1.w (INPUT emitente.cod-emitente,
                            INPUT l-modific,
                            INPUT l-anterior,
                            INPUT TABLE tt-old-emitente).
  END.

 IF  emitente.cod-transp  <> i-transp-ant OR
      emitente.nome-tr-red <> c-tr-red-ant THEN DO:           

      FIND transporte WHERE 
           transporte.cod-transp = i-transp-ant NO-LOCK NO-ERROR.

      ASSIGN c-transp-ant = IF AVAIL transporte THEN transporte.nome-abrev ELSE "".

      RUN cdp/cd1510b.w (OUTPUT p-exporta,
                         OUTPUT l-ok,
                         OUTPUT p-transfere).

      IF l-ok = YES THEN DO:           

         RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
         RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE). 

         /* Atualiza pedidos*/  
         IF p-transfere >= 2 THEN DO:
            {cdp/cd1510.i3 p-transfere}.
         
         END.
         
         IF p-exporta <> 1 THEN DO:

            /* atualiza estabelecimento cliente */
            IF p-exporta = 2 THEN DO:           
               FOR EACH estab-cli WHERE
                   estab-cli.nome-abrev  = emitente.nome-abrev AND
                   estab-cli.nome-transp = c-transp-ant EXCLUSIVE-LOCK:

                   RUN pi-acompanhar IN h-acomp (INPUT estab-cli.nome-abrev).

                   FIND FIRST transporte NO-LOCK
                       WHERE transporte.cod-transp  = INT(INPUT FRAME {&frame-name} c-transp-pad) 
                          OR transporte.nome-abrev = INPUT FRAME {&frame-name} c-transp-pad NO-ERROR.
                   IF AVAIL transporte THEN
                       ASSIGN estab-cli.nome-transp = transporte.nome-abrev.

               END. /*for each*/
            END. /*p-exporta*/
            ELSE DO: 
               FOR EACH estab-cli WHERE               
                   estab-cli.nome-abrev  = emitente.nome-abrev EXCLUSIVE-LOCK:

                   RUN pi-acompanhar IN h-acomp (INPUT estab-cli.nome-abrev).

                   FIND FIRST transporte NO-LOCK
                       WHERE transporte.cod-transp  = INT(INPUT FRAME {&frame-name} c-transp-pad) 
                          OR transporte.nome-abrev = INPUT FRAME {&frame-name} c-transp-pad NO-ERROR.
                   IF AVAIL transporte THEN
                       ASSIGN estab-cli.nome-transp = transporte.nome-abrev.

               END. /*for each*/
            END. /*else do*/
         END. /* p-exporta <> 1 */

         RUN pi-finalizar IN h-acomp.
      END. /* if l-ok */
      ELSE 
        RETURN "adm-error".           

  END. /* if emitente */

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

  IF  emitente.nat-operacao = c-nat-operacao-old THEN
      ASSIGN c-nat-operacao = "".

  IF  emitente.nat-ope-ext = c-nat-ope-ext-old THEN
      ASSIGN c-nat-ope-ext = "".

  IF  emitente.nat-operacao >= "5" OR
      emitente.nat-ope-ext  >= "5" THEN 
      IF  emitente.nat-operacao <> c-nat-operacao-old
          OR  emitente.nat-ope-ext <> c-nat-ope-ext-old THEN DO:
          IF  l-nat     = YES
              OR  l-nat-ext = YES THEN DO:
              RUN utp/ut-msgs.p (INPUT "show",
                                 INPUT 536,
                                 INPUT "").
              IF  RETURN-VALUE = "yes":U THEN DO:
                  RUN "cdp/cd1510ar.p" (OUTPUT l-resp1, OUTPUT l-resp2).  
                  {cdp/cd1510.i2} 
              END.
          END.  
      END.                                                                                   

  /* Dispatch standard ADM method.                             */
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

      {utp/ut-liter.i "Natureza_Estad/Export"}
      ASSIGN emitente.nat-operacao:LABEL IN FRAME {&frame-name} = TRIM(RETURN-VALUE).
      
      {utp/ut-liter.i "Natureza_de_Operaá∆o_Estadual_ou_Exportaá∆o"}
      ASSIGN emitente.nat-operacao:HELP IN FRAME {&frame-name} = TRIM(RETURN-VALUE).
       
      {utp/ut-field.i mgadm emitente esp-pd-venda 1}
      ASSIGN cb-esp-ped:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
      
  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
      ASSIGN cAuxTraducao001 = {adinc/i06ad098.i 03}.
      RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
      ASSIGN cb-esp-ped:LIST-ITEM-PAIRS IN FRAME {&frame-name} = cAuxTraducao001.
  &else
      ASSIGN cb-esp-ped:LIST-ITEMS IN FRAME {&frame-name} = {adinc/i06ad098.i 03}.
  &endif
  /* Dispatch standard ADM method.                             */

  /******************************************/
  /* Pre-processado Faturamento Outra Moeda */
  /******************************************/
  &if  defined (bf_dis_fat_moeda) &then 
        FIND FIRST para-fat NO-LOCK NO-ERROR.
        FIND user-coml WHERE user-coml.usuario = c-seg-usuario NO-LOCK NO-ERROR.
        IF  para-fat.ind-legislacao = 1 THEN DO:
            FIND FIRST dist-emitente
                 WHERE dist-emitente.cod-emitente = emitente.cod-emitente 
                 EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN i-moeda-fatur:HIDDEN IN FRAME {&frame-name} = NO
                       c-moeda:HIDDEN IN FRAME {&frame-name} = NO.
                IF  i-moeda-fatur:LOAD-MOUSE-POINTER ('image/lupa.cur') IN FRAME {&frame-name} THEN.
        END.

  &else
      ASSIGN i-moeda-fatur:VISIBLE IN FRAME {&frame-name} = NO
             c-moeda:VISIBLE IN FRAME {&frame-name} = NO.
  &endif.
 
  /* Caso o pre-processador de Adm Preáos estiver acionado, n∆o mostra esse campo
     nessa tela, mas apenas na nova viewer que ser† criada.
  */   
  &if defined (bf_dis_adm_preco) &then
      ASSIGN emitente.bonificacao:HIDDEN IN FRAME {&frame-name} = YES.
  &endif.

  /* Integracao EAI - */
  IF v_log_eai_habilit THEN
       RUN adapters/xml/fi2/axsfi001.p PERSISTENT SET h-eai-emit (OUTPUT TABLE tt_log_erro).

  &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
      IF  i-pais-impto-usuario <> 1 THEN
          ASSIGN c-fatur-ret:HIDDEN      IN FRAME f-main = TRUE
                 rect-43:HIDDEN          IN FRAME f-main = TRUE
                 cx-tp-agrup-item:HIDDEN IN FRAME f-main = TRUE
                 tg-agrup-nota:HIDDEN    IN FRAME f-main = TRUE
                 tg-opt-simp-nac:HIDDEN  IN FRAME f-main = TRUE.
  &else
      ASSIGN c-fatur-ret:HIDDEN      IN FRAME f-main = TRUE
             rect-43:HIDDEN          IN FRAME f-main = TRUE
             cx-tp-agrup-item:HIDDEN IN FRAME f-main = TRUE
             tg-agrup-nota:HIDDEN    IN FRAME f-main = TRUE
             tg-opt-simp-nac:HIDDEN  IN FRAME f-main = TRUE. 
  &endif

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


  &IF DEFINED(bf_dis_preco_un_med_mult) &THEN
      &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
          ASSIGN tg-relac-item-cli:HIDDEN IN FRAME {&FRAME-NAME} = YES.
      &ENDIF
  &ENDIF
  
    IF  i-pais-impto-usuario = 21 THEN DO:
        /* BO ecu-emitente */
        IF  NOT VALID-HANDLE(h-boec010) THEN DO:
            RUN local/ecu/ec2bo/boec010.p PERSISTENT SET h-boec010.
            RUN openQueryStatic IN h-boec010 (INPUT "Main":U).
        END.
    END.

    IF  i-pais-impto-usuario = 21 THEN ASSIGN c-formaPago:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
    ELSE ASSIGN c-formaPago:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
    /* Code placed here will execute AFTER standard behavior.    */ 
    
    /* esconder quando nao utilizar faturamento Mais Negocios por Data de Entrega */
    ASSIGN tg-mais-neg-confirm-entrega:HIDDEN IN FRAME {&FRAME-NAME} = NOT CAN-FIND(FIRST param-fatur-mais-negoc 
                                                                                         WHERE param-fatur-mais-negoc.cod-empresa = v_cod_empres_usuar
                                                                                           AND param-fatur-mais-negoc.log-livre-2).
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

  RUN pi-habilita(YES).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Esta procedure Ç espec°fica do MULTIPLANTA.      
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER i-tipo-movto AS INTEGER.
  IF  param-global.modulo-mp AND
      tt-replica-msg.log-replica-msg  = YES THEN DO: 
      CREATE tt-emitente-aux.
      BUFFER-COPY emitente TO tt-emitente-aux.
      CREATE tt-dados-env.                  
      ASSIGN tt-dados-env.num-sequencia  = i-seq 
             tt-dados-env.cod-tipo-reg   = 7
             tt-dados-env.ind-tipo-movto = i-tipo-movto
             tt-dados-env.identif-msg    = STRING(emitente.cod-emitente).
      RAW-TRANSFER tt-emitente-aux TO tt-dados-env.conteudo-msg.                                     
      ASSIGN i-seq = i-seq + 1.                                     
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita V-table-Win 
PROCEDURE pi-habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER l-habilita AS LOGICAL.
DEF VAR c-handle AS CHAR.
/*RUN get-link-handle IN adm-broker-hdl
 *     (INPUT this-procedure,
 *      INPUT 'leandro-source',
 *      OUTPUT c-handle).
 * 
 * if  l-habilita = no then     
 *     RUN set-button-enable IN widget-handle(c-handle) ('no,no,yes').
 * else
 *     RUN set-button-enable IN widget-handle(c-handle) ('yes,yes,yes').    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-dados-tela V-table-Win 
PROCEDURE pi-salva-dados-tela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  NOT CAN-FIND(FIRST tt-ecu-emitente-localiz) THEN DO:
        CREATE tt-ecu-emitente-localiz.
        ASSIGN tt-ecu-emitente-localiz.cod-emitente = emitente.cod-emitente
               tt-ecu-emitente-localiz.natureza     = emitente.natureza
               tt-ecu-emitente-localiz.estado       = emitente.estado
               tt-ecu-emitente-localiz.estado-cobr  = emitente.estado.
    END.
    
    IF  AVAIL tt-ecu-emitente-localiz THEN
        ASSIGN tt-ecu-emitente-localiz.cod-docto                 = emitente.cgc
               tt-ecu-emitente-localiz.cod-emitente              = emitente.cod-emitente 
               tt-ecu-emitente-localiz.identific                 = 2 /* Fornecedor */
               tt-ecu-emitente-localiz.cdn-forma-pagto           = INTEGER(c-formaPago:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-dados-localiz V-table-Win 
PROCEDURE pi-busca-dados-localiz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    IF AVAIL emitente AND emitente.cod-emitente <> 0 AND VALID-HANDLE(h-boec010) THEN DO:
        RUN setDadosInclusaoEmitente IN h-boec010 (INPUT emitente.natureza,
                                                   INPUT emitente.estado,
                                                   INPUT emitente.estado).

        RUN getTtEcuEmitenteLocaliz  IN h-boec010 (INPUT emitente.cod-emitente,
                                                   INPUT emitente.cod-emitente,
                                                   OUTPUT TABLE tt-ecu-emitente-localiz).
        FIND FIRST tt-ecu-emitente-localiz NO-LOCK NO-ERROR.
        
        IF  AVAIL tt-ecu-emitente-localiz THEN DO:
            ASSIGN c-formaPago:SCREEN-VALUE IN FRAME {&FRAME-NAME} =  STRING(tt-ecu-emitente-localiz.cdn-forma-pagto).
        END.
          
    END.

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
DEF INPUT PARAMETER h-handle AS HANDLE NO-UNDO.

ASSIGN h-handle-atual = h-handle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 {include/i-vldfrm.i}
 
 DEFINE VARIABLE lForeignCustomer AS LOGICAL NO-UNDO.
 DEFINE VARIABLE lValidateCfop    AS LOGICAL NO-UNDO.
 
 IF AVAIL emitente THEN
    FIND FIRST bf-emitente 
         WHERE bf-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL bf-emitente THEN DO:
        IF bf-emitente.natureza = 3 OR bf-emitente.natureza = 4 THEN DO: // cliente estrangeiro ou trading
           ASSIGN lForeignCustomer = YES. 
        END.
        ELSE DO:
           ASSIGN lForeignCustomer = NO. 
        END. 
    END.
 
 FIND FIRST transporte WHERE
       transporte.nome-abrev = INPUT FRAME {&frame-name} c-transp-pad NO-LOCK NO-ERROR.
  IF  NOT AVAIL transporte THEN
      FIND FIRST transporte WHERE 
           transporte.cod-transp = INTEGER(INPUT FRAME {&frame-name} c-transp-pad) NO-LOCK NO-ERROR.
  IF  NOT AVAIL transporte THEN DO: 
      {include/i-vldprg.i}
      {utp/ut-table.i mgadm transporte 1}
      RUN utp/ut-msgs.p (INPUT "show",
                         INPUT 56,
                         INPUT RETURN-VALUE + "~~" +
                               RETURN-VALUE).
      APPLY 'entry' TO c-transp-pad IN FRAME {&frame-name}.
      RETURN "adm-error".
  END.

  FIND FIRST transporte WHERE
       transporte.nome-abrev = INPUT FRAME {&frame-name} emitente.nome-tr-red NO-LOCK NO-ERROR.
  IF  NOT AVAIL transporte THEN
      FIND FIRST transporte WHERE
           transporte.cod-transp = INTEGER(INPUT FRAME {&frame-name} emitente.nome-tr-red) NO-LOCK NO-ERROR.
  IF  INPUT FRAME {&frame-name} emitente.nome-tr-red <> "" THEN DO:
      IF  NOT AVAIL transporte THEN DO:
          {include/i-vldprg.i}
          {utp/ut-table.i mgadm transporte 1}
          RUN utp/ut-msgs.p (INPUT "show",
                             INPUT 56,
                             INPUT RETURN-VALUE + "~~" +
                                   RETURN-VALUE).
          APPLY 'entry' TO emitente.nome-tr-red IN FRAME {&frame-name}.
          RETURN "adm-error".
      END.                             
  END.

  IF INPUT FRAME {&frame-name} emitente.nr-tabpre <> "" THEN DO:
    FIND tb-preco WHERE tb-preco.nr-tabpre = INPUT FRAME {&frame-name} emitente.nr-tabpre NO-LOCK NO-ERROR.
    IF NOT AVAIL tb-preco THEN DO:
           {include/i-vldprg.i}    
           {utp/ut-field.i mgadm emitente nr-tabpre 1}
           RUN utp/ut-msgs.p (INPUT "show",
                              INPUT 47,
                              INPUT RETURN-VALUE).
           APPLY 'entry' TO emitente.nr-tabpre IN FRAME {&frame-name}.
           RETURN "adm-error".
    END.
  END. /* if input frame ... */

    /*Validaá∆o Dep¢sito Externo*/    
    IF INPUT FRAME {&frame-name} c-depos-ext <> ""  THEN DO:
        FIND FIRST deposito 
             WHERE deposito.cod-depos  = TRIM(INPUT FRAME {&frame-name} c-depos-ext) NO-LOCK NO-ERROR.               
        IF  NOT AVAIL deposito THEN DO:               
            {include/i-vldprg.i}
            {utp/ut-table.i mgind deposito 1}
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 56,
                               INPUT RETURN-VALUE + "~~" +
                                     RETURN-VALUE).
            APPLY 'entry' TO c-depos-ext IN FRAME {&frame-name}.
            RETURN "adm-error".
        END.
        ELSE DO:
            IF deposito.nome-abrev <> emitente.nome-abrev THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 56802,
                                   INPUT emitente.nome-abrev + "~~" + deposito.cod-depos).
                APPLY 'entry' TO c-depos-ext IN FRAME {&frame-name}.
                RETURN "adm-error".
            END.
        END.
    END.
  /******************************************/
  /* Pre-processado Faturamento Outra Moeda */
  /******************************************/
  &if  defined (bf_dis_fat_moeda) &then 
        FIND FIRST para-fat NO-LOCK NO-ERROR.
        IF  para-fat.ind-legislacao = 1 THEN DO:
            FIND FIRST moeda
                 WHERE moeda.mo-codigo = INPUT FRAME {&frame-name} i-moeda-fatur
                 NO-LOCK NO-ERROR.
            IF  NOT AVAILABLE moeda THEN DO:
              /*  {include/i-vldprg.i} */
                {utp/ut-table.i mguni moeda 1}
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 56,
                                   INPUT RETURN-VALUE).
                APPLY 'entry' TO i-moeda-fatur IN FRAME {&frame-name}.
                RETURN "adm-error".
            END.
        END.
  &endif

/*  if  i-pais-impto-usuario = 1 then do:
 *       assign i-cont = 1.
 *       if  substr(input frame {&frame-name} emitente.nat-operacao:screen-value,i-cont,1) <> "5" and
 *           input frame {&frame-name} emitente.nat-operacao <> ? then do:
 *           {include/i-vldprg.i}
 *           {utp/ut-field.i mgadm emitente nat-operacao 1}
 *           run utp/ut-msgs.p (input "show",
 *                              input 7859,
 *                              input return-value + "~~" + "5"). 
 *           apply "entry" to emitente.nat-operacao in frame {&frame-name}.
 *           return "adm-error".                          
 *       end.
 *   end.    
 * 
 *   
 *   find natur-oper where 
 *        natur-oper.nat-operacao = input frame {&frame-name} emitente.nat-operacao 
 *        no-lock no-error.
 *   if not avail natur-oper and
 *      input frame {&frame-name} emitente.nat-operacao <> ? then do:    
 *           {include/i-vldprg.i}
 *           {utp/ut-field.i mgadm emitente nat-operacao 1}
 *           run utp/ut-msgs.p (input "show",
 *                              input 47,
 *                              input return-value).
 *           apply 'entry' to emitente.nat-operacao in frame {&frame-name}.
 *           return "adm-error".
 *   end.
 *   
 *   if  substr(input frame {&frame-name} emitente.nat-ope-ext:screen-value,i-cont,1) <> "6" and
 *       substr(input frame {&frame-name} emitente.nat-ope-ext:screen-value,i-cont,1) <> "7" and
 *       input frame {&frame-name} emitente.nat-ope-ext <> ? then do:
 *       {include/i-vldprg.i}
 *       {utp/ut-field.i mgadm emitente nat-ope-ext 1}
 *       run utp/ut-msgs.p (input "show",
 *                          input 7859,
 *                          input return-value + "~~" + "6 ou 7").  
 *       apply "entry" to emitente.nat-ope-ext in frame {&frame-name}.
 *       return "adm-error".                          
 *   end.*/

  FIND natur-oper WHERE 
       natur-oper.nat-operacao = INPUT FRAME {&frame-name} emitente.nat-operacao 
       NO-LOCK NO-ERROR.
  IF NOT AVAIL natur-oper /*and
 *      input frame {&frame-name} emitente.nat-operacao <> ?) or
 *      input frame {&frame-name} emintete.nat-operacao = */ THEN DO:    
          {include/i-vldprg.i}
          {utp/ut-field.i mgadm emitente nat-operacao 1}
          RUN utp/ut-msgs.p (INPUT "show",
                             INPUT 47,
                             INPUT RETURN-VALUE).
          APPLY 'entry' TO emitente.nat-operacao IN FRAME {&frame-name}.
          RETURN "adm-error".
  END.
  ELSE DO:

    IF natur-oper.nat-ativa = NO THEN DO:
       RUN utp/ut-msgs.p (INPUT "show",
                          INPUT 26759,
                          INPUT RETURN-VALUE).
       APPLY 'entry' TO emitente.nat-operacao IN FRAME {&frame-name}.
       RETURN "adm-error".
    END.
       
    // nao validar natureza de serviáo e que n∆o possua CFOP informado
    IF natur-oper.tipo = 3 AND LENGTH(TRIM(natur-oper.cod-cfop)) = 0 THEN DO:
       ASSIGN lValidateCfop = NO. 
    END.
    ELSE DO:
       ASSIGN lValidateCfop = YES. 
    END.
    
    IF i-pais-impto-usuario = 1 AND lValidateCfop = YES THEN DO: 
       IF NOT CAN-DO('1,5', SUBSTR(natur-oper.cod-cfop,1,1)) AND lForeignCustomer = NO THEN DO:
          //ERRO: NATUREZA DE OPERACAO PARA ENTREGA DEVERIA SER ESTADUAL
          {utp/ut-liter.i "Estadual" *}
          RUN utp/ut-msgs.p (INPUT "show",
                             INPUT 57889,
                             INPUT RETURN-VALUE).
          APPLY 'entry' TO emitente.nat-operacao IN FRAME {&frame-name}.
          RETURN "adm-error".                
       END.
    END.
  END.   

  IF emitente.nat-ope-ext:HIDDEN = NO THEN DO:
     FIND natur-oper WHERE 
          natur-oper.nat-operacao = INPUT FRAME {&frame-name} emitente.nat-ope-ext 
          NO-LOCK NO-ERROR.

     /********************************************************/     
     /** Validaá∆o natureza de operaá∆o externa para Brasil **/
     /********************************************************/

     IF (NOT AVAIL natur-oper OR
        (INPUT FRAME {&frame-name} emitente.nat-ope-ext = ? AND
         i-pais-impto-usuario = 1)) THEN DO:    
             {include/i-vldprg.i}
             {utp/ut-field.i mgadm emitente nat-ope-ext 1}
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 47,
                                INPUT RETURN-VALUE).
             APPLY 'entry' TO emitente.nat-ope-ext IN FRAME {&frame-name}.
             RETURN "adm-error".
     END.
     ELSE DO:
     
        IF natur-oper.nat-ativa = NO THEN DO:
           RUN utp/ut-msgs.p (INPUT "show",
                              INPUT 26759,
                              INPUT RETURN-VALUE).
           APPLY 'entry' TO emitente.nat-ope-ext IN FRAME {&frame-name}.
           RETURN "adm-error".
        END.
                  
        // nao validar natureza de serviáo e que n∆o possua CFOP informado   
        IF natur-oper.tipo = 3 AND LENGTH(TRIM(natur-oper.cod-cfop)) = 0 THEN DO:
           ASSIGN lValidateCfop = NO. 
        END.
        ELSE DO:
           ASSIGN lValidateCfop = YES. 
        END.
       
        IF i-pais-impto-usuario = 1 AND lValidateCfop = YES THEN DO: 
           IF NOT CAN-DO('2,6', SUBSTR(natur-oper.cod-cfop,1,1)) AND lForeignCustomer = NO THEN DO:
              //ERRO: NATUREZA DE OPERACAO PARA ENTREGA DEVERIA SER INTERESTADUAL
              {utp/ut-liter.i "Interestadual" *}
              RUN utp/ut-msgs.p (INPUT "show",
                                 INPUT 57889,
                                 INPUT RETURN-VALUE).
              APPLY 'entry' TO emitente.nat-ope-ext IN FRAME {&frame-name}.
              RETURN "adm-error".                
           END.
        END. 
     END.   
  END.  

  FIND cond-pagto WHERE cond-pagto.cod-cond-pag = INPUT FRAME {&frame-name} emitente.cod-cond-pag NO-LOCK NO-ERROR.
  IF NOT AVAIL cond-pagto AND INPUT FRAME {&frame-name} emitente.cod-cond-pag <> 0 THEN DO:    
          {include/i-vldprg.i}
          {utp/ut-field.i mgadm emitente cod-cond-pag 1}
          RUN utp/ut-msgs.p (INPUT "show",
                             INPUT 47,
                             INPUT RETURN-VALUE).
          APPLY 'entry' TO emitente.cod-cond-pag IN FRAME {&frame-name}.
          RETURN "adm-error".
   END.          


    /**************************************************************************************************/  

    ASSIGN c-nat-operacao = INPUT FRAME {&frame-name} emitente.nat-operacao.

   /*** Atribuicao de valores as variaveis de teste do cd1510a ***/
     FIND natur-oper
          WHERE natur-oper.nat-operacao = INPUT FRAME {&frame-name} emitente.nat-operacao
                NO-LOCK NO-ERROR.
     IF  AVAIL natur-oper THEN
         ASSIGN l-gera = natur-oper.emite-duplic
                r-nat  = ROWID(natur-oper).
     ASSIGN l-temped = NO
            r-emit   = ROWID(emitente).
   /*****/

   /***Teste para verificar se a natureza antiga e a atual geram ou n∆o faturamento*****/
       IF  AVAIL natur-oper  THEN DO:
           IF  c-nat-operacao <> natur-oper.nat-operacao THEN DO:
               FIND  natur-oper
                     WHERE natur-oper.nat-operacao = INPUT FRAME {&frame-name} emitente.nat-operacao
                     NO-LOCK NO-ERROR.
               IF  AVAIL natur-oper
                   AND r-nat <> ? THEN DO:
                   IF  l-gera <> natur-oper.emite-duplic THEN
                       ASSIGN i-seleciona = 1.
                   ELSE
                       ASSIGN i-seleciona = 0.
                   RUN "cdp/cd1510ar.p".
                   ASSIGN l-gera = NO.
                   IF  l-temped = YES THEN
                       ASSIGN l-nat = YES.
                       IF  l-temped = YES
                           AND i-seleciona = 1 THEN
                           RETURN "adm-error".
               END.
           END.
       END.
      /*******/ 

       ASSIGN c-nat-ope-ext = emitente.nat-ope-ext.

       FIND natur-oper
            WHERE  natur-oper.nat-operacao = emitente.nat-ope-ext
            NO-LOCK NO-ERROR.
       IF  AVAIL natur-oper THEN
           ASSIGN l-gera-ext = natur-oper.emite-duplic.

  /***Teste para verificar se a natureza antiga e a atual geram ou n∆o faturamento*****/

   IF  c-nat-ope-ext <> emitente.nat-ope-ext THEN DO:
      FIND  natur-oper
            WHERE natur-oper.nat-operacao = emitente.nat-ope-ext
                  NO-LOCK NO-ERROR.
      IF  AVAIL natur-oper
          AND r-nat <> ? THEN DO:
          IF l-gera-ext <> natur-oper.emite-duplic THEN
             ASSIGN i-seleciona = 1.
          ELSE
             ASSIGN i-seleciona = 0.

          RUN "cdp/cd1510ar.p".
          ASSIGN l-gera-ext = NO.
          IF  l-temped = YES THEN
              ASSIGN l-nat-ext = YES.
          IF  l-temped = YES
              AND i-seleciona = 1 THEN
              RETURN "adm-error".
      END.
  END. 

  /*****/ 
 
  IF  INPUT FRAME {&frame-name} emitente.nat-operacao = ? THEN 
      ASSIGN emitente.nat-operacao:SCREEN-VALUE = "111"
             l-oper = YES.

  IF  INPUT FRAME {&frame-name} emitente.nat-ope-ext = ? THEN  
      ASSIGN emitente.nat-ope-ext:SCREEN-VALUE = "111"
             l-ext = YES.
                
  IF CAN-FIND(FIRST hier_param WHERE hier_param.log_usa_regra_time) THEN DO:

        IF (INPUT FRAME {&frame-name} idi-niv-aces = 2) AND ((INPUT FRAME {&frame-name} c-usuar-respons = ?)
                OR (INPUT FRAME {&frame-name} c-usuar-respons = "")) THEN  DO:

            {include/i-vldprg.i}
            {utp/ut-field.i mgdis dist-emitente cod-usuar-respons 1}

            RUN utp/ut-msgs.p (INPUT "show",
                             INPUT 47,
                             INPUT RETURN-VALUE).

            APPLY 'entry' TO c-usuar-respons IN FRAME {&frame-name}.

            RETURN "adm-error".

        END.

      IF TRIM(INPUT FRAME {&frame-name} c-usuar-respons) <> "" THEN DO:

          IF NOT CAN-FIND(FIRST usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = INPUT FRAME {&frame-name} c-usuar-respons) THEN DO:

              {utp/ut-field.i mgdis dist-emitente cod-usuar-respons 1}

              RUN utp/ut-msgs.p (INPUT "show",
                                 INPUT 47,
                                 INPUT RETURN-VALUE).

              APPLY 'ENTRY' TO c-usuar-respons IN FRAME {&FRAME-NAME}.

              RETURN "adm-error".
          END.

      END.

  END.          

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
  {src/adm/template/snd-list.i "emitente"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaParametros V-table-Win 
PROCEDURE setaParametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON bt-ajuda 
         LABEL "&Ajuda"
         SIZE 10 BY 1
         BGCOLOR 8 .

    DEFINE BUTTON bt-cancela AUTO-END-KEY 
         LABEL "&Cancelar"
         SIZE 10 BY 1
         BGCOLOR 8 .

    DEFINE BUTTON bt-ok AUTO-GO 
         LABEL "&OK"
         SIZE 10 BY 1
         BGCOLOR 8 .

    DEFINE VARIABLE parametro AS INTEGER
         VIEW-AS RADIO-SET VERTICAL
         RADIO-BUTTONS 
              "N∆o exporta", 1,
              "Exporta apenas para itens com o mesmo percentual", 2,
              "Exporta para todos os itens", 3
         SIZE 40.29 BY 2 NO-UNDO.

    DEFINE RECTANGLE RECT-1
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 68 BY 4.8.


    DEFINE RECTANGLE rt-buttom
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 68 BY 1.42
         BGCOLOR 7 .


    ASSIGN parametro = i-parametro.

    /*
    ** Definiá∆o de frames
    */
    DEFINE FRAME FSelection
         parametro AT ROW 2.7 COL 5.57 NO-LABEL
         bt-ok AT ROW 6.42 COL 3.14
         bt-cancela AT ROW 6.42 COL 14.14
         bt-ajuda AT ROW 6.42 COL 59.14
         RECT-1 AT ROW 1.2 COL 2.14
         rt-buttom AT ROW 6.17 COL 2.14
         SPACE(0.71) SKIP(0.23)
         WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER FONT 1
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             TITLE "Exportar Percentual M†ximo Fat para Itens do Cliente?"
             DEFAULT-BUTTON bt-ok.

    /*
    ** Triggers
    */

    ON CHOOSE OF bt-cancela IN FRAME fSelection
    DO:
        ASSIGN l-exporta = NO.
                APPLY "GO":U TO FRAME fSelection.
    END.    

    ON CHOOSE OF bt-ok IN FRAME fSelection 
    DO:
        ASSIGN i-parametro = INT(parametro:SCREEN-VALUE)
                       l-exporta = YES.
        APPLY "GO":U TO FRAME fSelection.
    END.   

    DISPLAY parametro
            WITH FRAME fSelection. 

    ENABLE parametro
           bt-ok
           bt-cancela WITH FRAME fSelection.

    WAIT-FOR "GO":U OF FRAME fSelection.
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

  IF  p-state = 'update-begin' THEN
      RUN pi-habilita (NO).

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  RUN pi-trata-state (p-issuer-hdl, p-state).
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
    IF VALID-HANDLE(h-boec010) THEN DO:
        DELETE PROCEDURE h-boec010.
        ASSIGN h-boec010 = ?.
    END.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

