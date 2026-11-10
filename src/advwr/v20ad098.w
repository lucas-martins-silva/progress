&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V20AD098 2.00.00.044 } /*** "010044" 13/08/2026 08:46:54 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v20ad098 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-bofi230     AS HANDLE NO-UNDO.
DEFINE VARIABLE hProgramZoom  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad00954   AS HANDLE NO-UNDO.

{adbo/boad00954.i tt-emitente-internac}

/** Include de PrÇ-processadores **/
{cdp/cdcfgdis.i}


DEFINE VARIABLE i-cod-meio-pagto AS INT       NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS emitente.atividade emitente.linha-produt ~
emitente.cod-canal-venda emitente.cod-suframa emitente.cod-cacex ~
emitente.insc-subs-trib emitente.emite-etiq 
&Scoped-define ENABLED-TABLES emitente
&Scoped-define FIRST-ENABLED-TABLE emitente
&Scoped-Define ENABLED-OBJECTS cb-cod-ind-servico cb-tip-cob-desp ~
i-tip-operac tg-insc-siafi tg-isencao tg-paa tg-zera-vl-triangular ~
c-nr-tabpre RECT-1 RECT-2 
&Scoped-Define DISPLAYED-FIELDS emitente.atividade emitente.linha-produt ~
emitente.cod-canal-venda emitente.cod-suframa emitente.cod-cacex ~
emitente.insc-subs-trib emitente.emite-etiq 
&Scoped-define DISPLAYED-TABLES emitente
&Scoped-define FIRST-DISPLAYED-TABLE emitente
&Scoped-Define DISPLAYED-OBJECTS cb-cod-ind-servico c-descricao-cv ~
cb-tip-cob-desp i-tip-operac c-desc-operac c-tab-pauta c-tab-pmc ~
tg-insc-siafi tg-isencao tg-paa tg-zera-vl-triangular c-nr-tabpre ~
c-desc-tabpre cb-cod-meio-pagto 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

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
DEFINE VARIABLE cb-cod-ind-servico AS CHARACTER FORMAT "X(256)":U 
     LABEL "Indicador de serviáo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 36.72 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cod-meio-pagto AS CHARACTER FORMAT "X(256)" 
     LABEL "Meio de Pagamento" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 36.72 BY .88 NO-UNDO.

DEFINE VARIABLE cb-tip-cob-desp AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 33 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-operac AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 31.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tabpre AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-cv AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88.

DEFINE VARIABLE c-nr-tabpre AS CHARACTER FORMAT "X(8)":U 
     LABEL "Tab Preáo" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-tab-pauta AS CHARACTER FORMAT "xxx/xx":U 
     LABEL "Tab Pauta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-tab-pmc AS CHARACTER FORMAT "xxx/xx":U 
     LABEL "Tabela PMC" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-tip-operac AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.29 BY 2.17.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.29 BY 2.21.

DEFINE VARIABLE tg-insc-siafi AS LOGICAL INITIAL no 
     LABEL "Inscrito SIAFI" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.29 BY .75 NO-UNDO.

DEFINE VARIABLE tg-isencao AS LOGICAL INITIAL no 
     LABEL "Isená∆o da Contribuiá∆o Previdenci†ria de acordo com a Lei 13.606/2018" 
     VIEW-AS TOGGLE-BOX
     SIZE 53 BY .83 NO-UNDO.

DEFINE VARIABLE tg-paa AS LOGICAL INITIAL no 
     LABEL "Entidade do Programa de Aquisiá∆o de Alimentos - PAA" 
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .83 NO-UNDO.

DEFINE VARIABLE tg-zera-vl-triangular AS LOGICAL INITIAL no 
     LABEL "Gerar remessa com valores zerados" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .75 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     emitente.atividade AT ROW 1.08 COL 11.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     emitente.linha-produt AT ROW 2.08 COL 11.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     emitente.cod-canal-venda AT ROW 3.08 COL 11.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     cb-cod-ind-servico AT ROW 4.08 COL 16 COLON-ALIGNED WIDGET-ID 10
     c-descricao-cv AT ROW 3.08 COL 16 COLON-ALIGNED HELP
          "Descriá∆o" NO-LABEL
     cb-tip-cob-desp AT ROW 4.08 COL 11.29 COLON-ALIGNED
     i-tip-operac AT ROW 5.08 COL 11.29 COLON-ALIGNED
     c-desc-operac AT ROW 5.08 COL 16.14 COLON-ALIGNED NO-LABEL
     emitente.cod-suframa AT ROW 1.08 COL 64.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .88
     emitente.cod-cacex AT ROW 2.08 COL 64.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .88
     emitente.insc-subs-trib AT ROW 3.08 COL 64.72 COLON-ALIGNED
          LABEL "Inscr Aux Subst Tribut."
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .88
     c-tab-pauta AT ROW 4.08 COL 64.72 COLON-ALIGNED HELP
          "Tabela Pauta ST" WIDGET-ID 8
     c-tab-pmc AT ROW 5.08 COL 64.72 COLON-ALIGNED HELP
          "Tabela PMC para Medicamentos" WIDGET-ID 8
     emitente.emite-etiq AT ROW 6 COL 66.72
          VIEW-AS TOGGLE-BOX
          SIZE 17.14 BY .75
     tg-insc-siafi AT ROW 6.75 COL 66.72 HELP
          "Destinat†rio inscr SIAFI n∆o possui valor m°nimo retená∆o" WIDGET-ID 8
     tg-isencao AT ROW 7.83 COL 13.14 WIDGET-ID 2
     tg-paa AT ROW 8.58 COL 13.14 WIDGET-ID 6
     tg-zera-vl-triangular AT ROW 10.33 COL 13.14 HELP
          "Gerar nota de remessa da operaá∆o triangular com valor zerado"
     c-nr-tabpre AT ROW 11.08 COL 11.14 COLON-ALIGNED HELP
          "Tabela de preáo utilizada para o c†lculo da nota de remessa"
     c-desc-tabpre AT ROW 11.08 COL 22.14 COLON-ALIGNED NO-LABEL
     cb-cod-meio-pagto AT ROW 5.08 COL 16 COLON-ALIGNED WIDGET-ID 14
     "Comercializaá∆o Produá∆o Rural" VIEW-AS TEXT
          SIZE 26 BY .54 AT ROW 7.17 COL 2.57
     "Operaá∆o Triangular - Venda Ö Ordem" VIEW-AS TEXT
          SIZE 28 BY .54 AT ROW 9.67 COL 2.57
     RECT-1 AT ROW 7.5 COL 1.57
     RECT-2 AT ROW 10 COL 1.57
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
         HEIGHT             = 11.21
         WIDTH              = 89.
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
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-operac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-tabpre IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-cv IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tab-pauta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tab-pmc IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-cod-ind-servico:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-cod-meio-pagto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN emitente.insc-subs-trib IN FRAME f-main
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-nr-tabpre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-tabpre V-table-Win
ON F5 OF c-nr-tabpre IN FRAME f-main /* Tab Preáo */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=dizoom/z01di189.w
                     &campo=c-nr-tabpre
                     &campozoom=nr-tabpre
                     &frame="f-main"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-tabpre V-table-Win
ON LEAVE OF c-nr-tabpre IN FRAME f-main /* Tab Preáo */
DO:
    {include/leave.i &tabela=tb-preco
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-tabpre
                     &where="tb-preco.nr-tabpre = input frame {&frame-name} c-nr-tabpre"}
                     
    IF c-nr-tabpre:SCREEN-VALUE <> "" THEN
        ASSIGN tg-zera-vl-triangular:CHECKED   = NO
               tg-zera-vl-triangular:SENSITIVE = NO.
    ELSE 
        ASSIGN tg-zera-vl-triangular:SENSITIVE = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-tabpre V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-nr-tabpre IN FRAME f-main /* Tab Preáo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-tab-pauta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tab-pauta V-table-Win
ON F5 OF c-tab-pauta IN FRAME f-main /* Tab Pauta */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="dizoom/z01di189.w"
                     &campo=c-tab-pauta
                     &campozoom=nr-tabpre}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tab-pauta V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-tab-pauta IN FRAME f-main /* Tab Pauta */
DO:
  apply "F5" to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-tab-pmc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tab-pmc V-table-Win
ON F5 OF c-tab-pmc IN FRAME f-main /* Tabela PMC */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="dizoom/z01di189.w"
                     &campo=c-tab-pmc
                     &campozoom=nr-tabpre}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tab-pmc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-tab-pmc IN FRAME f-main /* Tabela PMC */
DO:
  apply "F5" to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cod-meio-pagto
&Scoped-define SELF-NAME emitente.cod-canal-venda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.cod-canal-venda V-table-Win
ON F5 OF emitente.cod-canal-venda IN FRAME f-main /* Canal Venda */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom= "dizoom/z01di232.w"
                     &campo= emitente.cod-canal-venda
                     &campozoom= cod-canal-venda} 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.cod-canal-venda V-table-Win
ON LEAVE OF emitente.cod-canal-venda IN FRAME f-main /* Canal Venda */
DO:
  find first canal-venda where canal-venda.cod-canal-venda = input emitente.cod-canal-venda
       no-lock no-error.
  if  avail canal-venda then
      assign c-descricao-cv:screen-value = canal-venda.descricao.
  else
      assign c-descricao-cv:screen-value = ''.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL emitente.cod-canal-venda V-table-Win
ON MOUSE-SELECT-DBLCLICK OF emitente.cod-canal-venda IN FRAME f-main /* Canal Venda */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-tip-operac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tip-operac V-table-Win
ON F5 OF i-tip-operac IN FRAME f-main
DO:

  {method/zoomfields.i &ProgramZoom="dizoom/z01di00897.w"
                       &FieldZoom1="cdn-tip-ped"
                       &FieldScreen1="i-tip-operac"
                       &Frame1="f-main"
                       &FieldZoom2="descricao"
                       &FieldScreen2="c-desc-operac"
                       &Frame2="f-main"
                       &EnableImplant="YES"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tip-operac V-table-Win
ON LEAVE OF i-tip-operac IN FRAME f-main
DO:
  find first tip-ped-cia 
       where tip-ped-cia.cdn-tip-ped = int(i-tip-operac:screen-value in frame {&frame-name})
       no-lock no-error.
  
  if avail tip-ped-cia then
     assign c-desc-operac:screen-value = tip-ped-cia.descricao.
  else
     assign c-desc-operac:screen-value = ''.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tip-operac V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-tip-operac IN FRAME f-main
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-zera-vl-triangular
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-zera-vl-triangular V-table-Win
ON VALUE-CHANGED OF tg-zera-vl-triangular IN FRAME f-main /* Gerar remessa com valores zerados */
DO:

    IF tg-zera-vl-triangular:CHECKED THEN
        ASSIGN c-nr-tabpre  :SENSITIVE    = NO
               c-nr-tabpre  :SCREEN-VALUE = ""
               c-desc-tabpre:SCREEN-VALUE = "".
    ELSE 
        ASSIGN c-nr-tabpre  :SENSITIVE    = YES.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  ASSIGN tg-isencao   :CHECKED IN FRAME {&FRAME-NAME} = NO
         tg-paa       :CHECKED IN FRAME {&FRAME-NAME} = NO
         tg-insc-siafi:CHECKED IN FRAME {&FRAME-NAME} = NO.

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

  {include/i-valid.i}

    /******************** Verifica se ouve alteracao no seguinte campo: cod-suframa
                           Chama o programa para atualizacao dos dados do emitente ********************/
    
    IF AVAIL emitente
    AND i-pais-impto-usuario = 1
    AND CONNECTED("mgfis")
    AND emitente.cod-suframa <> emitente.cod-suframa:INPUT-VALUE IN FRAME {&FRAME-NAME} THEN
    DO:
        RUN fibo/bofi230.p PERSISTENT SET h-bofi230.
        RUN gravaAlteracao IN h-bofi230(INPUT emitente.cod-emitente,
                                        INPUT emitente.identific,
                                        INPUT emitente.cod-suframa,
                                        INPUT emitente.cod-suframa:INPUT-VALUE IN FRAME {&FRAME-NAME},
                                        INPUT 09).
        DELETE PROCEDURE h-bofi230.
        ASSIGN h-bofi230 = ?.
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  assign input frame {&frame-name} cb-tip-cob-desp 
         emitente.tip-cob-desp       = {diinc/i04di072.i 06 cb-tip-cob-desp}.

  FIND FIRST dist-emitente EXCLUSIVE-LOCK 
       WHERE dist-emitente.cod-emitente = emitente.cod-emitente  NO-ERROR.
  IF AVAIL dist-emitente THEN
     ASSIGN dist-emitente.nr-tb-pauta          = INPUT FRAME {&FRAME-NAME} c-tab-pauta
            OVERLAY(dist-emitente.char-1,26,8) = INPUT FRAME {&FRAME-NAME} c-tab-pmc
            OVERLAY(dist-emitente.char-1,24,1) = STRING(INT(tg-isencao:CHECKED IN FRAME {&FRAME-NAME}))
            OVERLAY(dist-emitente.char-1,25,1) = STRING(INT(tg-paa    :CHECKED IN FRAME {&FRAME-NAME}))
            OVERLAY(dist-emitente.char-1,81,1) = IF tg-insc-siafi:CHECKED IN FRAME {&FRAME-NAME} THEN "S":U ELSE "N":U.
  
  ASSIGN OVERLAY(emitente.char-2,115,1) = IF tg-zera-vl-triangular:CHECKED IN FRAME {&FRAME-NAME} THEN "S" ELSE "N"
         OVERLAY(emitente.char-2,116,8) = c-nr-tabpre:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  
  if not avail para-ped then
     find first para-ped no-lock no-error.

  /* Sugest∆o autom†tica da natureza de operaá∆o - CD0101 */
 
  IF INPUT FRAME {&frame-name} i-tip-operac = "?" OR INPUT FRAME {&frame-name} i-tip-operac = ? THEN
      ASSIGN i-tip-operac:screen-value in frame {&frame-name} = "0".
    
  if avail para-ped and substring(para-ped.char-1,88,1) = "s" THEN
     assign overlay(emitente.char-1,134,5) = input frame {&frame-name} i-tip-operac.

  IF i-pais-impto-usuario = 7  AND /* Chile */
     VALID-HANDLE(h-boad00954) THEN DO:
      
      EMPTY TEMP-TABLE tt-emitente-internac.

      RUN goToKey IN h-boad00954 (INPUT emitente.cod-emitente).
      IF RETURN-VALUE = "OK":U THEN
          RUN getRecord IN h-boad00954 (OUTPUT TABLE tt-emitente-internac).

      FIND FIRST tt-emitente-internac NO-LOCK
           WHERE tt-emitente-internac.cdn-emitente = emitente.cod-emitente NO-ERROR.

      IF NOT AVAIL tt-emitente-internac THEN DO:
          CREATE tt-emitente-internac.
          ASSIGN tt-emitente-internac.cdn-emitente = emitente.cod-emitente
                 tt-emitente-internac.num-livre-1  = {adinc/i01ad00594chi.i 6 cb-cod-ind-servico:SCREEN-VALUE IN FRAME {&FRAME-NAME}}.
                 
          IF cb-cod-meio-pagto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN 
              ASSIGN tt-emitente-internac.cod-livre-2  = ENTRY(1, "", ";").
          ELSE
              ASSIGN tt-emitente-internac.cod-livre-2  = ENTRY(1, STRING({adinc/i02ad00594chi.i 6 cb-cod-meio-pagto:SCREEN-VALUE IN FRAME {&FRAME-NAME}}), ";").
              
          RUN emptyRowErrors IN h-boad00954.
          RUN setRecord IN h-boad00954 (INPUT TABLE tt-emitente-internac).
          RUN createRecord IN h-boad00954.
      END.
      ELSE DO:
          ASSIGN tt-emitente-internac.num-livre-1 = {adinc/i01ad00594chi.i 6 cb-cod-ind-servico:SCREEN-VALUE IN FRAME {&FRAME-NAME}}.
          
          IF cb-cod-meio-pagto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN 
              ASSIGN tt-emitente-internac.cod-livre-2  = ENTRY(1, "", ";").
          ELSE
              ASSIGN tt-emitente-internac.cod-livre-2  = ENTRY(1, STRING({adinc/i02ad00594chi.i 6 cb-cod-meio-pagto:SCREEN-VALUE IN FRAME {&FRAME-NAME}}), ";").
          
          RUN emptyRowErrors IN h-boad00954.
          RUN setRecord IN h-boad00954 (INPUT TABLE tt-emitente-internac).
          RUN updateRecord IN h-boad00954.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  VALID-HANDLE(h-boad00954) THEN DO:
        RUN destroy IN h-boad00954.
        ASSIGN h-boad00954 = ?.
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  assign cb-tip-cob-desp:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
         c-tab-pauta:SENSITIVE           IN FRAME {&FRAME-NAME} = NO 
         c-tab-pmc:SENSITIVE             IN FRAME {&FRAME-NAME} = NO 
         tg-paa:SENSITIVE                IN FRAME {&FRAME-NAME} = NO
         tg-isencao:SENSITIVE            IN FRAME {&FRAME-NAME} = NO
         tg-zera-vl-triangular:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         c-nr-tabpre:SENSITIVE           IN FRAME {&FRAME-NAME} = NO
         tg-insc-siafi:SENSITIVE         IN FRAME {&FRAME-NAME} = NO.

  if not avail para-ped then
     find first para-ped no-lock no-error.

  /* Sugest∆o autom†tica da natureza de operaá∆o - CD0101 */
  if avail para-ped and substring(para-ped.char-1,88,1) = "s" then
     assign i-tip-operac:sensitive in frame {&frame-name} = no.

  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  IF i-pais-impto-usuario = 7 THEN
      ASSIGN cb-cod-ind-servico:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             cb-cod-meio-pagto:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
      
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

  {utp/ut-field.i mgadm emitente tip-cob-desp 1}
  assign cb-tip-cob-desp:label in frame {&FRAME-NAME} = trim(return-value).

  if avail emitente and i-pais-impto-usuario = 1 then do with frame {&frame-name}:
     assign cb-tip-cob-desp:screen-value = {diinc/i04di072.i 04 emitente.tip-cob-desp}.
  end.
  else do:
     assign cb-tip-cob-desp:screen-value = {diinc/i04di072.i 04 1}.
  end.

  if avail emitente then do:

      find first canal-venda 
          where canal-venda.cod-canal-venda = input frame {&frame-name} emitente.cod-canal-venda 
          no-lock no-error.

     if  avail canal-venda then
         assign c-descricao-cv:screen-value = canal-venda.descricao.
     else
         assign c-descricao-cv:screen-value = ''.
    
     if not avail para-ped then
        find first para-ped no-lock no-error.

     /* Sugest∆o autom†tica da natureza de operaá∆o - CD0101 */
     if avail para-ped and substring(para-ped.char-1,88,1) = "s" then do:

        assign i-tip-operac:screen-value in frame {&frame-name} = substr(emitente.char-1,134,5).
        
        find first tip-ped-cia 
             where tip-ped-cia.cdn-tip-ped = int(i-tip-operac:screen-value in frame {&frame-name})
             no-lock no-error.
        
        if  avail tip-ped-cia then
            assign c-desc-operac:screen-value = tip-ped-cia.descricao.
        else
            assign c-desc-operac:screen-value = ''.

     end.                                           

     /* Atená∆o para o uso de prÇ-processador. Na release 2.01 a tabela de preco Ç grava no campo char.
        Mas quando o prÇ-processador de Administraá∆o de preáos estiver acionado, en **/
     &if defined (bf_dis_adm_preco) &then

        /* busca tabela de pauta na emitente-dist */
        FIND FIRST dist-emitente 
             WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
        IF AVAIL dist-emitente THEN
           ASSIGN c-tab-pauta  :FORMAT       IN FRAME {&FRAME-NAME} = "X(8)":U
                  c-tab-pauta  :SCREEN-VALUE IN FRAME {&FRAME-NAME} = dist-emitente.nr-tb-pauta
                  c-tab-pmc    :FORMAT       IN FRAME {&FRAME-NAME} = "X(8)":U
                  c-tab-pmc    :SCREEN-VALUE IN FRAME {&FRAME-NAME} = substr(dist-emitente.char-1,26,8)
                  tg-insc-siafi:CHECKED      IN FRAME {&FRAME-NAME} = IF TRIM(SUBSTRING(dist-emitente.char-1,81,1)) = "S":U THEN YES ELSE NO.
     &else

        assign c-tab-pauta:screen-value in frame {&frame-name} = substr(emitente.char-1,1,5).

     &endif
     
     IF i-pais-impto-usuario = 7 THEN DO:

         EMPTY TEMP-TABLE tt-emitente-internac.

         IF NOT VALID-HANDLE(h-boad00954) THEN DO:
             RUN adbo/boad00954.p PERSISTENT SET h-boad00954.

             RUN openQueryStatic IN h-boad00954 (INPUT "Main":U) NO-ERROR.

             &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
                ASSIGN cAuxTraducao001 = {adinc/i01ad00594chi.i 03}.
                RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
                ASSIGN cb-cod-ind-servico:LIST-ITEM-PAIRS in frame {&FRAME-NAME} = cAuxTraducao001 + ", , ".
             &else
                ASSIGN cb-cod-ind-servico:list-items in frame {&FRAME-NAME} = {adinc/i01ad00594chi.i 03} + ", ".
             &endif

             &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
                ASSIGN cAuxTraducao002 = {adinc/i02ad00594chi.i 03}.
                RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao002).
                ASSIGN cb-cod-meio-pagto:LIST-ITEM-PAIRS in FRAME {&FRAME-NAME} = cAuxTraducao002 + ", , ".
             &else
                ASSIGN cb-cod-meio-pagto:list-items in frame {&FRAME-NAME} = {adinc/i02ad00594chi.i 03} + ", ".
             &endif
         END.

         RUN goToKey IN h-boad00954 (INPUT emitente.cod-emitente).

         IF RETURN-VALUE = "OK":U THEN DO:
             RUN getRecord IN h-boad00954 (OUTPUT TABLE tt-emitente-internac).

             FIND FIRST tt-emitente-internac NO-LOCK
                  WHERE tt-emitente-internac.cdn-emitente = emitente.cod-emitente NO-ERROR.
             IF AVAIL tt-emitente-internac THEN DO:
                 IF tt-emitente-internac.num-livre-1 <> 0 THEN
                     ASSIGN cb-cod-ind-servico:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {adinc/i01ad00594chi.i 04 tt-emitente-internac.num-livre-1}.
                 ELSE 
                     ASSIGN cb-cod-ind-servico:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
                 
                 IF ENTRY(1,tt-emitente-internac.cod-livre-2,";") <> "" THEN DO: 
                    ASSIGN i-cod-meio-pagto = INT(ENTRY(1,tt-emitente-internac.cod-livre-2,";")).
                    ASSIGN cb-cod-meio-pagto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {adinc/i02ad00594chi.i 04 i-cod-meio-pagto}.
                 END.
                 ELSE
                    ASSIGN cb-cod-meio-pagto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".                     
                    
             END.
             ELSE
                 ASSIGN cb-cod-ind-servico:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
                        cb-cod-meio-pagto:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = " ".                     
         END.
         ELSE 
             ASSIGN cb-cod-ind-servico:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
                    cb-cod-meio-pagto :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
     END.
     
     ASSIGN tg-zera-vl-triangular:CHECKED      IN FRAME {&FRAME-NAME} = (SUBSTR(emitente.char-2,115,1) = "S").
            c-nr-tabpre          :SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(SUBSTR(emitente.char-2,116,8)).

     APPLY "LEAVE":U TO c-nr-tabpre IN FRAME {&FRAME-NAME}.
     
  END.

  ASSIGN tg-isencao:CHECKED IN FRAME {&FRAME-NAME} = NO
         tg-paa:CHECKED     IN FRAME {&FRAME-NAME} = NO.
  IF  AVAIL dist-emitente THEN DO:

      IF  SUBSTR(dist-emitente.char-1,24,1) = "1"
      OR  (    SUBSTR(dist-emitente.char-1,24,1) = ""
           AND SUBSTR(dist-emitente.char-1,23,1) = "7") THEN 
          ASSIGN tg-isencao:CHECKED IN FRAME {&FRAME-NAME} = YES.

      IF  SUBSTR(dist-emitente.char-1,25,1) = "1"
      OR  (    SUBSTR(dist-emitente.char-1,25,1) = ""
           AND SUBSTR(dist-emitente.char-1,23,1) = "8") THEN       
          ASSIGN tg-paa:CHECKED IN FRAME {&FRAME-NAME} = YES.

  END.

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN tg-zera-vl-triangular:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         c-nr-tabpre:SENSITIVE           IN FRAME {&FRAME-NAME} = NO
         i-tip-operac:SENSITIVE          IN FRAME {&FRAME-NAME} = NO
         tg-insc-siafi:SENSITIVE         IN FRAME {&FRAME-NAME} = NO
         tg-isencao:SENSITIVE            IN FRAME {&FRAME-NAME} = NO
         tg-paa:SENSITIVE                IN FRAME {&FRAME-NAME} = NO.

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
  assign cb-tip-cob-desp:SENSITIVE       IN FRAME {&FRAME-NAME} = YES 
         c-tab-pauta:SENSITIVE           IN FRAME {&FRAME-NAME} = YES 
         c-tab-pmc:SENSITIVE             IN FRAME {&FRAME-NAME} = YES 
         tg-isencao:SENSITIVE            IN FRAME {&FRAME-NAME} = YES
         tg-paa:SENSITIVE                IN FRAME {&FRAME-NAME} = YES
         tg-insc-siafi:SENSITIVE         IN FRAME {&FRAME-NAME} = YES.

  IF tg-zera-vl-triangular:CHECKED THEN
      ASSIGN c-nr-tabpre:SENSITIVE = NO.
  ELSE 
      ASSIGN c-nr-tabpre:SENSITIVE = YES.

  IF c-nr-tabpre:SCREEN-VALUE <> "" THEN
      ASSIGN tg-zera-vl-triangular:SENSITIVE = NO.
  ELSE 
      ASSIGN tg-zera-vl-triangular:SENSITIVE = YES.

  if not avail para-ped then
     find first para-ped no-lock no-error.

  /* Sugest∆o autom†tica da natureza de operaá∆o - CD0101 */
  if avail para-ped and substring(para-ped.char-1,88,1) = "s" then
     assign i-tip-operac:sensitive in frame {&frame-name} = yes.

  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  if emitente.cod-canal-venda:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  if c-nr-tabpre             :load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

  IF i-pais-impto-usuario = 7 THEN
      ASSIGN cb-cod-ind-servico:SENSITIVE IN FRAME {&FRAME-NAME} = YES
             cb-cod-meio-pagto :SENSITIVE IN FRAME {&FRAME-NAME} = YES.

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

  
  do with frame {&frame-name}:
     assign cb-tip-cob-desp:list-items = {diinc/i04di072.i 03}.
     {utp/ut-liter.i Tabela_de_Pauta * L}
     assign c-tab-pauta:label = return-value.
     /* Tabela de pauta para c†lculo de substituiá∆o tribut†ria. */
     if  c-tab-pauta:load-mouse-pointer ("image~\lupa.cur") then.
     if  c-tab-pmc:load-mouse-pointer ("image~\lupa.cur") then.
  end.

  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  IF i-pais-impto-usuario <> 1 THEN
      ASSIGN c-tab-pauta:HIDDEN             IN FRAME {&frame-name} = YES 
             c-tab-pmc:HIDDEN               IN FRAME {&frame-name} = YES 
             cb-tip-cob-desp:HIDDEN         IN FRAME {&frame-name} = YES
             emitente.cod-cacex:HIDDEN      IN FRAME {&frame-name} = YES
             emitente.cod-suframa:HIDDEN    IN FRAME {&frame-name} = YES
             emitente.insc-subs-trib:HIDDEN IN FRAME {&frame-name} = YES
             tg-paa:HIDDEN                  IN FRAME {&FRAME-NAME} = YES
             tg-isencao:HIDDEN              IN FRAME {&FRAME-NAME} = YES
             tg-zera-vl-triangular:HIDDEN   IN FRAME {&FRAME-NAME} = YES
             c-nr-tabpre:HIDDEN             IN FRAME {&FRAME-NAME} = yes
             tg-insc-siafi:HIDDEN           IN FRAME {&FRAME-NAME} = yes.
             
  IF i-pais-impto-usuario <> 7 then /* Chile */             
      assign cb-cod-meio-pagto:hidden in frame {&FRAME-NAME} = yes.

  IF i-pais-impto-usuario = 7 THEN DO: /* Chile */

      ASSIGN emitente.atividade:COL IN FRAME {&FRAME-NAME}                            = 18
             emitente.linha-produt:COL IN FRAME {&FRAME-NAME}                         = 18
             emitente.cod-canal-venda:COL IN FRAME {&FRAME-NAME}                      = 18
             c-descricao-cv:COL IN FRAME {&FRAME-NAME}                                = c-descricao-cv:COL IN FRAME {&FRAME-NAME} + 4.71
             emitente.cod-canal-venda:SIDE-LABEL-HANDLE:COLUMN IN FRAME {&FRAME-NAME} = 8.8
             emitente.linha-produt:SIDE-LABEL-HANDLE:COLUMN IN FRAME {&FRAME-NAME}    = 7
             emitente.atividade:SIDE-LABEL-HANDLE:COLUMN IN FRAME {&FRAME-NAME}       = 6.5.
      
      ASSIGN cb-cod-ind-servico:HIDDEN IN FRAME {&FRAME-NAME} = NO.
  END.

  IF AVAIL emitente THEN DO:
      assign cb-tip-cob-desp:sensitive            in frame {&frame-name} = no
             emitente.cod-suframa:screen-value    in frame {&frame-name} = emitente.cod-suframa 
             emitente.cod-cacex:screen-value      in frame {&frame-name} = emitente.cod-cacex 
             emitente.insc-subs-trib:screen-value in frame {&frame-name} = emitente.insc-subs-trib.
  END.

  find first para-ped no-lock no-error.

  /* Sugest∆o autom†tica da natureza de operaá∆o - CD0101 */
  if avail para-ped and substring(para-ped.char-1,88,1) = "s" then do:

     if i-tip-operac:load-mouse-pointer ("image~\lupa.cur") then.
    
     {utp/ut-liter.i Tipo_Oper_Venda *}
     assign i-tip-operac:label in frame {&frame-name} = return-value.

     {utp/ut-liter.i Tipo_de_operaá∆o_de_venda * L}
     assign i-tip-operac:help in frame {&frame-name} = return-value.

  end.
  else 
     assign i-tip-operac:hidden  in frame {&frame-name} = yes
            c-desc-operac:hidden in frame {&frame-name} = yes.
    
  /* Code placed here will execute AFTER standard behavior.    */

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

  find first canal-venda where 
             canal-venda.cod-canal-venda = input frame {&frame-name} emitente.cod-canal-venda
             no-lock no-error.

  if  not avail canal-venda and 
      input frame {&frame-name} emitente.cod-canal-venda <> 0 then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgdis canal-venda 1}
      run utp/ut-msgs.p (input "show",
                         input 2,
                         input return-value).
      apply 'entry' to emitente.cod-canal-venda.
      return 'adm-error'.
  end. 
  
  if  input frame {&frame-name} c-tab-pauta <> "" and
      i-pais-impto-usuario = 1 then do:
      find tb-preco 
           where tb-preco.nr-tabpre = input frame {&frame-name} c-tab-pauta 
           no-lock no-error.
      if  not avail tb-preco then do:
          {include/i-vldprg.i}    
          {utp/ut-field.i mgadm emitente nr-tabpre 1}
           run utp/ut-msgs.p (input "show",
                             input 47,
                             input return-value).
          apply 'entry' to c-tab-pauta in frame {&frame-name}.
          return "adm-error".
      end.
  end.

  if  input frame {&frame-name} c-tab-pmc <> "" and
      i-pais-impto-usuario = 1 then do:
      find tb-preco 
           where tb-preco.nr-tabpre = input frame {&frame-name} c-tab-pmc no-lock no-error.
      if  not avail tb-preco then do:
          {include/i-vldprg.i}    
          {utp/ut-field.i mgadm emitente nr-tabpre 1}
           run utp/ut-msgs.p (input "show",
                             input 47,
                             input return-value).
          apply 'entry' to c-tab-pmc in frame {&frame-name}.
          return "adm-error".
      end.
  end.
  if not avail para-ped then
     find first para-ped no-lock no-error.

  /* Sugest∆o autom†tica da natureza de operaá∆o - CD0101 */
  if avail para-ped and substring(para-ped.char-1,88,1) = "s"
  and int(i-tip-operac:screen-value in frame {&frame-name}) > 0 then do:

     find first tip-ped-cia 
          where tip-ped-cia.cdn-tip-ped = int(i-tip-operac:screen-value in frame {&frame-name})
          no-lock no-error.
     
     if  not avail tip-ped-cia then do:
         {include/i-vldprg.i}
         {utp/ut-table.i mgdis tip-ped-cia 1}
         run utp/ut-msgs.p (input "show",
                            input 2,
                            input return-value).
         apply 'entry' to i-tip-operac.
         return 'adm-error'.
     end. 

  end.

  IF i-pais-impto-usuario = 7 AND 
     (cb-cod-ind-servico:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ? OR
      cb-cod-ind-servico:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "") THEN DO:
      {utp/ut-liter.i "Indicador_de_serviáo"}
      run utp/ut-msgs.p (input "show",
                         input 265,
                         input return-value).
      apply 'entry' to cb-cod-ind-servico.
      return 'adm-error'.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  if emitente.cod-canal-venda:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

