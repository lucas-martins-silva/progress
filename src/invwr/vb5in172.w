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
{include/i-prgvrs.i VB5IN172 2.00.00.026 } /*** "010026" 08/05/2026 14:53:28  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN   
{include/i-license-manager.i VB5IN172 MUT}
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

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-handle1         as character no-undo.
def var wh-cd0903         as handle    no-undo.
def var h-cdapi995        as handle    no-undo.
DEF VAR h-cdcfgfiscal     AS HANDLE    NO-UNDO.

def temp-table tt-pedido NO-UNDO
    field nome-abrev like ped-venda.nome-abrev
    field nr-pedcli  like ped-venda.nr-pedcli.

def buffer b-ped-item for ped-item.

def var de-ipi-ant like classif-fisc.aliquota-ipi.
def var i-exporta      as integer.
def var l-aberto       as logical.
def var l-parcial      as logical.
def var l-pendente     as logical.
def var i-cont         as integer.
def var c-class-fiscal as char.
def var c-fator        as char.

&IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
DEF VAR c-class-fiscal-ant LIKE ITEM.class-fiscal.
&ENDIF


{cdp/cd4000.i}
{cdp/cd9990.i1}
{cdp/cd7300.i1}
{cdp/cdapi206.i2}

def var l-estab-am as logical.

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
&Scoped-Define ENABLED-FIELDS item.data-2 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS text-1 text-2 RECT-27 RECT-43 RECT-14 ~
RECT-15 
&Scoped-Define DISPLAYED-OBJECTS l-calc-pis-por-unidade de-valor-pis ~
c-un-pis-uni cb-origem-pis de-ali-pis de-red-pis de-retenc-pis ~
l-orig-retenc-pis l-pis-cofins-subst-total l-orig-retenc-csll ~
de-val-aliq-dif-pis l-calc-cofins-por-unidade de-valor-cofins ~
c-un-cofins-uni cb-origem-cofins de-ali-cofins de-red-cofins ~
de-retenc-cofins l-orig-retenc-cofins de-retenc-csll de-val-aliq-dif-cofins

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
DEFINE VARIABLE cb-origem-cofins AS CHARACTER FORMAT "X(256)":U 
     LABEL "Origem Al°quota" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item","Natureza" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE cb-origem-pis AS CHARACTER FORMAT "X(256)":U 
     LABEL "Origem Al°quota" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item","Natureza" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE l-orig-retenc-cofins AS CHARACTER FORMAT "X(256)":U 
     LABEL "Origem Retená∆o COFINS" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item","Natureza" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE l-orig-retenc-csll AS CHARACTER FORMAT "X(256)":U 
     LABEL "Origem Retená∆o CSLL" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item","Natureza" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE l-orig-retenc-pis AS CHARACTER FORMAT "X(256)":U 
     LABEL "Origem Retená∆o PIS" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item","Natureza" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE c-un-cofins-uni AS CHARACTER FORMAT "X(03)":U 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 TOOLTIP "teste tooltip cofins" NO-UNDO.

DEFINE VARIABLE c-un-pis-uni AS CHARACTER FORMAT "X(03)":U 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 TOOLTIP "teste tooltip" NO-UNDO.

DEFINE VARIABLE de-ali-cofins AS DECIMAL FORMAT ">9.9999":U INITIAL 0 
     LABEL "Al°quota COFINS" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-ali-pis AS DECIMAL FORMAT ">9.9999":U INITIAL 0 
     LABEL "Al°quota PIS" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-red-cofins AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "% Reduá∆o COFINS" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-red-pis AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "% Reduá∆o PIS" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-retenc-cofins AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "% Retená∆o COFINS" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-retenc-csll AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "% Retená∆o CSLL" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-retenc-pis AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "% Retená∆o PIS" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-aliq-dif-cofins AS DECIMAL FORMAT ">9.9999":U INITIAL 0 
     LABEL "de-val-aliq-dif-cofins" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-aliq-dif-pis AS DECIMAL FORMAT ">9.9999":U INITIAL 0 
     LABEL "de-val-aliq-dif-pis" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-cofins AS DECIMAL FORMAT ">>>9.99999":U INITIAL 0 
     LABEL "Valor COFINS por unidade" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-pis AS DECIMAL FORMAT ">>>9.99999":U INITIAL 0 
     LABEL "Valor PIS por unidade" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(18)":U 
      VIEW-AS TEXT 
     SIZE 18 BY .67 NO-UNDO.

DEFINE VARIABLE text-2 AS CHARACTER FORMAT "X(18)":U 
      VIEW-AS TEXT 
     SIZE 18 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34 BY 1.54.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34.14 BY 1.54.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 7.17.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 2.25.

DEFINE VARIABLE l-calc-cofins-por-unidade AS LOGICAL INITIAL no 
     LABEL "Calcula COFINS por Unidade" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .88 NO-UNDO.

DEFINE VARIABLE l-calc-pis-por-unidade AS LOGICAL INITIAL no 
     LABEL "Calcula PIS por Unidade" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE l-pis-cofins-subst-total AS LOGICAL INITIAL no 
     LABEL "PIS/COFINS Subst Total NF" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.72 BY .71 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     l-calc-pis-por-unidade AT ROW 1.33 COL 20
     de-valor-pis AT ROW 2.33 COL 18 COLON-ALIGNED
     c-un-pis-uni AT ROW 2.33 COL 30.29 COLON-ALIGNED HELP
          "UN para convers∆o do PIS quando calculado por unidade" NO-LABEL
     cb-origem-pis AT ROW 3.33 COL 18 COLON-ALIGNED
     de-ali-pis AT ROW 4.33 COL 18 COLON-ALIGNED
     de-red-pis AT ROW 5.33 COL 18 COLON-ALIGNED
     de-retenc-pis AT ROW 6.33 COL 18 COLON-ALIGNED HELP
          "Percentual de Rentená∆o de PIS"
     l-orig-retenc-pis AT ROW 7.33 COL 18 COLON-ALIGNED
     l-pis-cofins-subst-total AT ROW 8.63 COL 21.43 HELP
          "Incorpora o valor do PIS/COFINS Substituto no total da nota."
     l-orig-retenc-csll AT ROW 9.63 COL 19.29 COLON-ALIGNED
     de-val-aliq-dif-pis AT ROW 11.5 COL 17.72 COLON-ALIGNED HELP
          "Entrar com valor da Al°quota Diferenciada"
     l-calc-cofins-por-unidade AT ROW 1.33 COL 59
     de-valor-cofins AT ROW 2.33 COL 57 COLON-ALIGNED
     c-un-cofins-uni AT ROW 2.33 COL 69.43 COLON-ALIGNED HELP
          "UN para convers∆o do COFINS quando calculado por unidade" NO-LABEL
     cb-origem-cofins AT ROW 3.33 COL 57 COLON-ALIGNED
     de-ali-cofins AT ROW 4.33 COL 57 COLON-ALIGNED
     de-red-cofins AT ROW 5.33 COL 57 COLON-ALIGNED
     de-retenc-cofins AT ROW 6.33 COL 57 COLON-ALIGNED HELP
          "Percentual de Rentená∆o de COFINS"
     l-orig-retenc-cofins AT ROW 7.33 COL 57 COLON-ALIGNED
     item.data-2 AT ROW 8.63 COL 57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     de-retenc-csll AT ROW 9.63 COL 57 COLON-ALIGNED HELP
          "Percentual de Rentená∆o de CSLL"
     de-val-aliq-dif-cofins AT ROW 11.5 COL 66.29 COLON-ALIGNED HELP
          "Entrar com valor da Al°quota Diferenciada"
     text-1 AT ROW 10.75 COL 1.29 COLON-ALIGNED NO-LABEL
     text-2 AT ROW 10.75 COL 48.72 COLON-ALIGNED NO-LABEL
     RECT-27 AT ROW 1.21 COL 2
     RECT-43 AT ROW 8.46 COL 2
     RECT-14 AT ROW 11.04 COL 2
     RECT-15 AT ROW 11.04 COL 48.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


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
         HEIGHT             = 11.71
         WIDTH              = 82.
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

/* SETTINGS FOR FILL-IN c-un-cofins-uni IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-pis-uni IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-origem-cofins IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-origem-pis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.data-2 IN FRAME f-main
   NO-DISPLAY                                                           */
ASSIGN 
       item.data-2:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN de-ali-cofins IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-ali-pis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-red-cofins IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-red-pis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-retenc-cofins IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-retenc-csll IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-retenc-pis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-aliq-dif-cofins IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-aliq-dif-pis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-cofins IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-pis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-calc-cofins-por-unidade IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-calc-pis-por-unidade IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX l-orig-retenc-cofins IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX l-orig-retenc-csll IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX l-orig-retenc-pis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-pis-cofins-subst-total IN FRAME f-main
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

&Scoped-define SELF-NAME c-un-cofins-uni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un-cofins-uni V-table-Win
ON F5 OF c-un-cofins-uni IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in417.w"
                     &campo=c-un-cofins-uni
                     &campozoom=un}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un-cofins-uni V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-un-cofins-uni IN FRAME f-main
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-un-pis-uni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un-pis-uni V-table-Win
ON F5 OF c-un-pis-uni IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in417.w"
                     &campo=c-un-pis-uni
                     &campozoom=un}
END.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un-pis-uni V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-un-pis-uni IN FRAME f-main
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-calc-cofins-por-unidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-calc-cofins-por-unidade V-table-Win
ON VALUE-CHANGED OF l-calc-cofins-por-unidade IN FRAME f-main /* Calcula COFINS por Unidade */
DO: 
  IF l-calc-cofins-por-unidade:CHECKED IN FRAME {&frame-name} THEN 
      ENABLE   
        de-valor-cofins 
        c-un-cofins-uni
      WITH FRAME {&FRAME-NAME}. 
  ELSE
      DISABLE   
        de-valor-cofins 
        c-un-cofins-uni
      WITH FRAME {&FRAME-NAME}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-calc-pis-por-unidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-calc-pis-por-unidade V-table-Win
ON VALUE-CHANGED OF l-calc-pis-por-unidade IN FRAME f-main /* Calcula PIS por Unidade */
DO: 
  IF l-calc-pis-por-unidade:CHECKED IN FRAME {&frame-name} THEN 
      ENABLE   
        de-valor-pis 
        c-un-pis-uni
      WITH FRAME {&FRAME-NAME}. 
  ELSE
      DISABLE   
        de-valor-pis 
        c-un-pis-uni
      WITH FRAME {&FRAME-NAME}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if c-un-pis-uni:LOAD-MOUSE-POINTER          ("image/lupa.cur") in frame {&frame-name} then.
  if c-un-cofins-uni:LOAD-MOUSE-POINTER       ("image/lupa.cur") in frame {&frame-name} then.
  
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
  /*if  not frame {&frame-name}:validate() then
 *       return 'ADM-ERROR':U.*/

  /* Ponha aqui a validaá∆o de chave duplicada */

  /* Ponha aqui as demais validaá‰es */

  assign de-ipi-ant = item.aliquota-ipi.

  &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
    IF NOT adm-new-record THEN
        ASSIGN c-class-fiscal-ant = ITEM.class-fiscal.
  &ENDIF

  find first param-global no-lock no-error.

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  IF de-ali-pis:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "?" THEN
      ASSIGN INPUT FRAME {&FRAME-NAME} de-ali-pis.

  IF de-ali-cofins:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "?" THEN
      ASSIGN INPUT FRAME {&FRAME-NAME} de-ali-cofins.

  ASSIGN INPUT FRAME {&FRAME-NAME} de-red-pis
         INPUT FRAME {&FRAME-NAME} de-red-cofins
         INPUT FRAME {&FRAME-NAME} de-retenc-pis
         INPUT FRAME {&FRAME-NAME} cb-origem-pis
         INPUT FRAME {&FRAME-NAME} cb-origem-cofins
         INPUT FRAME {&FRAME-NAME} de-retenc-cofins
         INPUT FRAME {&FRAME-NAME} de-retenc-csll
         INPUT FRAME {&FRAME-NAME} de-retenc-csll
         INPUT FRAME {&FRAME-NAME} de-retenc-csll
         INPUT FRAME {&FRAME-NAME} de-retenc-csll
         INPUT FRAME {&FRAME-NAME} l-pis-cofins-subst-total.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.
     
  assign overlay(item.char-1,50,5) = if  l-pis-cofins-subst-total
                                         then string("Sim", "X(5)")
                                         else string("Nao", "X(5)")
         overlay(item.char-2,31,5)  = string(de-ali-pis   ,"99.99")
         overlay(item.char-2,36,5)  = string(de-ali-cofins,"99.99")      
         overlay(item.char-2,74,5)  = string(DEC(de-val-aliq-dif-pis:SCREEN-VALUE IN FRAME f-main),"99.99") 
         overlay(item.char-2,79,5)  = string(DEC(de-val-aliq-dif-cofins:SCREEN-VALUE IN FRAME f-main),"99.99")
         OVERLAY(item.char-2,84,9)  = de-val-aliq-dif-pis:SCREEN-VALUE IN FRAME f-main /* PIS com 4 decimais */
         OVERLAY(item.char-2,93,9)  = de-val-aliq-dif-cofins:SCREEN-VALUE IN FRAME f-main /* COFINS com 4 decimais */
         overlay(item.char-2,52,1)  = if cb-origem-pis = "Item" then "1" else "2"
         overlay(item.char-2,53,1)  = if cb-origem-cofins = "Item" then "1" else "2".

   RUN grava-aliquotas IN h-cdapi995 (INPUT "item",
                                      INPUT ITEM.it-codigo,
                                      INPUT de-ali-pis,
                                      INPUT de-ali-cofins).

  /* Atualiza os campos Calcula PIS por, Valor PIS por unidade, Calcula COFINS por e Valor COFINS por unidade  */
  /* Os valores dos campos "Calcula PIS por" e "Calcula COFINS por" sao 1 - Percentual / 2 - Valor por Unidade */
  &if "{&bf_dis_versao_ems}" >= "2.06" &then
    find item-dist where item-dist.it-codigo = item.it-codigo exclusive-lock no-error.
    if not avail item-dist then do:
        create item-dist.
        assign item-dist.it-codigo = item.it-codigo.
    end.
    /* Campos: 
        - Calcula Pis por Unidade Produto - item.char-1,193,1                                                          
        - item-dist.idi-forma-calc-pis
        - Valor Pis por Unidade - item.char-2,54,10
                                - item-dist.val-unit-pis
        - Calcula Cofins por Unidade Produto - item.char-1,194,1
                                             - item-dist.idi-forma-calc-cofins
        - Valor Cofins por Unidade - item.char-2,64,10
                                   - item-dist.val-unit-cofins */
                                       
    assign item-dist.idi-forma-calc-pis     = if l-calc-pis-por-unidade:checked in frame {&frame-name} then 2 else 1
           item-dist.val-unit-pis           = input frame {&frame-name} de-valor-pis
           item-dist.idi-forma-calc-cofins  = if l-calc-cofins-por-unidade:checked in frame {&frame-name} then 2 else 1
           item-dist.val-unit-cofins        = input frame {&frame-name} de-valor-cofins
           item-dist.cdd-perc-retenc-pis    = input frame {&frame-name} de-retenc-pis
           item-dist.log-orig-retenc-pis    = IF l-orig-retenc-pis:screen-value in frame {&frame-name} = "Item" then yes else NO
           item-dist.cdd-perc-retenc-cofins = input frame {&frame-name} de-retenc-cofins
           item-dist.log-orig-retenc-cofins = IF l-orig-retenc-cofins:screen-value in frame {&frame-name} = "Item" then yes else no
           item-dist.cdd-perc-retenc-csll   = input frame {&frame-name} de-retenc-csll
           item-dist.log-orig-retenc-csll   = IF l-orig-retenc-csll:screen-value in frame {&frame-name} = "Item" then yes else NO
           OVERLAY(item-dist.char-2,21,6)   = INPUT FRAME {&FRAME-NAME} c-un-cofins-uni
           OVERLAY(item-dist.char-2,27,6)   = INPUT FRAME {&frame-name} c-un-pis-uni.
           
  &else
    assign overlay(item.char-1,193,1) = if l-calc-pis-por-unidade:checked in frame {&frame-name} then "2" else "1"
           overlay(item.char-2,54,10) = string(input frame {&frame-name} de-valor-pis, ">>>9.99999")
           overlay(item.char-1,194,1) = if l-calc-cofins-por-unidade:checked in frame {&frame-name} then "2" else "1"
           overlay(item.char-2,64,10) = string(input frame {&frame-name} de-valor-cofins, ">>>9.99999")
           overlay(item.char-1,239,5) = string(de-retenc-pis,"99.99")
           overlay(item.char-1,231,1) = if l-orig-retenc-pis:screen-value in frame {&frame-name} = "Item" then "1" else "2"
           overlay(item.char-1,244,5) = string(input frame {&frame-name} de-retenc-cofins,"99.99")
           overlay(item.char-1,232,1) = if l-orig-retenc-cofins:screen-value in frame {&frame-name} = "Item" then "1" else "2"
           overlay(item.char-1,234,5) = string(input frame {&frame-name} de-retenc-csll,"99.99")
           overlay(item.char-1,233,1) = if l-orig-retenc-csll:screen-value in frame {&frame-name} = "Item" then "1" else "2".
  &endif

  &if "{&bf_dis_versao_ems}" >= "2.06" &then
    find item-mat where item-mat.it-codigo = item.it-codigo exclusive-lock no-error.
    if not avail item-mat then do:
        create item-mat.
        assign item-mat.it-codigo = item.it-codigo.
    end.
    ASSIGN item-mat.val-reduc-pis-normal    = de-red-pis
           item-mat.val-reduc-cofins-normal = de-red-cofins
           overlay(item.char-2,46,5)        = string(de-red-cofins)
           overlay(item.char-2,41,5)        = string(de-red-pis).
  &else
    ASSIGN overlay(item.char-2,200,6) = string(de-red-pis   ,"99.99")
           overlay(item.char-2,206,6) = string(de-red-cofins,"99.99").  
  &endif


  if  param-global.modulo-pd then do:
      if  de-ipi-ant <> item.aliquota-ipi then do:
          run cdp/cd0903a.w (output i-exporta,
                             output l-aberto,
                             output l-parcial,
                             output l-pendente).
          for each tt-pedido:
              delete tt-pedido.
          end.    
          if  i-exporta = 1 then
              {cdp/cd0903.i " "}
          if  i-exporta = 2 then
              {cdp/cd0903.i "and ped-item.aliquota-ipi =de-ipi-ant"}  
          for each tt-pedido:
              find ped-venda
                   where ped-venda.nome-abrev = tt-pedido.nome-abrev
                   and   ped-venda.nr-pedcli   = tt-pedido.nr-pedcli EXCLUSIVE-LOCK NO-ERROR.
              run cdp/cd4323a.p (input rowid(ped-venda),
                                 input yes,
                                 input i-pais-impto-usuario).

              delete tt-pedido.
          end.                                

         /******************Multiplanta******************/

         assign c-transacao = "DIS005".
         {cdp/cd7300.i5 "001" c-transacao}

         if  param-global.modulo-mp and
             tt-replica-msg.log-replica-msg  = yes then do: 
             create tt-param.
             assign tt-param.it-codigo        = item.it-codigo
                    tt-param.aliquota-ipi-ant = de-ipi-ant
                    tt-param.aliquota-ipi-atu = item.aliquota-ipi
                    tt-param.i-exporta        = i-exporta
                    tt-param.l-aberto         = l-aberto
                    tt-param.l-parcial        = l-parcial
                    tt-param.l-pendente       = l-pendente.

             create tt-dados-env.                  
             assign tt-dados-env.num-sequencia  = i-seq 
             tt-dados-env.cod-tipo-reg          = 3
             tt-dados-env.ind-tipo-movto        = 10
             tt-dados-env.identif-msg           = item.it-codigo.
             raw-transfer tt-param to tt-dados-env.conteudo-msg.                                    
             assign i-seq = i-seq + 1.                                     
         end.  

         {cdp/cd7300.i6 "001" c-transacao}
         find first tt-dados-env no-error.
         if  avail tt-dados-env then
         delete tt-dados-env.

         /**************Fim-Multiplanta*****************/

      end.
  end.    

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
  DISABLE l-calc-pis-por-unidade 
          de-valor-pis 
          cb-origem-pis 
          de-ali-pis 
          de-red-pis 
          de-retenc-pis 
          l-orig-retenc-pis 
          l-pis-cofins-subst-total 
          l-orig-retenc-csll 
          l-calc-cofins-por-unidade 
          de-valor-cofins 
          cb-origem-cofins 
          de-ali-cofins de-red-cofins 
          de-retenc-cofins 
          l-orig-retenc-cofins 
          de-retenc-csll 
          de-val-aliq-dif-cofins 
          de-val-aliq-dif-pis
          c-un-cofins-uni
          c-un-pis-uni
      WITH FRAME {&FRAME-NAME}.

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
  if  avail item then do:
      find classif-fisc 
          where classif-fisc.class-fiscal = item.class-fiscal no-lock no-error.

      find tab-codser 
          where tab-codser.cod-servico = item.cod-servico no-lock no-error.

      /* Inicializa o parÉmetro Incorpora PIS/Cofins Total NF */
      assign l-pis-cofins-subst-total =  substr(item.char-1,50,5) = " "
                                      or substr(item.char-1,50,5) = "Sim".

      RUN recupera-aliquotas IN h-cdapi995 (INPUT  "item",
                                            INPUT  ITEM.it-codigo,
                                            OUTPUT de-ali-pis,
                                            OUTPUT de-ali-cofins).

    assign 
        de-ali-pis             = IF de-ali-pis    = 0 THEN dec(substr(item.char-2,31,5)) ELSE de-ali-pis
        de-ali-cofins          = IF de-ali-cofins = 0 THEN dec(substr(item.char-2,36,5)) ELSE de-ali-cofins
        de-val-aliq-dif-pis    = dec(substr(item.char-2,74,5))
        de-val-aliq-dif-cofins = dec(substr(item.char-2,79,5))
        cb-origem-pis          = if substr(item.char-2,52,1) = "1" 
                                 then "Item"                     /* Pega do item */
                                 else "Natureza"                 /* Pega da natureza */
        cb-origem-cofins       = if substr(item.char-2,53,1) = "1"
                                 then "Item"                     /* Pega do item */
                                 else "Natureza".                /* Pega da natureza */

      IF DEC(SUBSTR(item.char-2,84,9)) <> 0 THEN /* PIS com 4 decimais */
          ASSIGN de-val-aliq-dif-pis = DEC(SUBSTR(item.char-2,84,9)).
      
      IF DEC(SUBSTR(item.char-2,93,9)) <> 0 THEN /* COFINS com 4 decimais */
          ASSIGN de-val-aliq-dif-cofins = DEC(SUBSTR(item.char-2,93,9)).
      
      &if "{&bf_dis_versao_ems}" >= "2.06" &then
        find item-mat where item-mat.it-codigo = item.it-codigo NO-LOCK no-error.
        if not avail item-mat then do:
            create item-mat.
            assign item-mat.it-codigo = item.it-codigo.
        end.
        ASSIGN de-red-pis    = item-mat.val-reduc-pis-normal
               de-red-cofins = item-mat.val-reduc-cofins-normal.
      &else
        ASSIGN de-red-pis    = dec(substr(item.char-2,200,6))
               de-red-cofins = dec(substr(item.char-2,206,6)).  
      &endif

      /* Calcula PIS por Unidade, Valor PIS por unidade, Calcula COFINS por Unidade e Valor COFINS por unidade  */
      /* As flags sao gravadas com base nos valores: 1 - Percentual / 2 - Valor por Unidade */
      &if "{&bf_dis_versao_ems}" >= "2.06" &then
          find item-dist where item-dist.it-codigo = item.it-codigo no-lock no-error.
          if  avail item-dist then do:
              assign l-calc-pis-por-unidade    = if item-dist.idi-forma-calc-pis = 2 then yes else no
                     l-calc-cofins-por-unidade = if item-dist.idi-forma-calc-cofins = 2 then yes else no
                     de-valor-pis              = item-dist.val-unit-pis
                     de-valor-cofins           = item-dist.val-unit-cofins
                     de-retenc-pis             = item-dist.cdd-perc-retenc-pis
                     l-orig-retenc-pis         = IF item-dist.log-orig-retenc-pis = YES THEN "Item" ELSE "Natureza"
                     de-retenc-cofins          = item-dist.cdd-perc-retenc-cofins
                     l-orig-retenc-cofins      = IF item-dist.log-orig-retenc-cofins = YES THEN "Item" ELSE "Natureza"
                     de-retenc-csll            = item-dist.cdd-perc-retenc-csll
                     l-orig-retenc-csll        = IF item-dist.log-orig-retenc-csll = YES THEN "Item" ELSE "Natureza"
                     c-un-cofins-uni           = SUBSTR(item-dist.char-2,21,6)
                     c-un-pis-uni              = SUBSTR(item-dist.char-2,27,6).
          end.
          else
              assign l-calc-pis-por-unidade    = no
                     l-calc-cofins-por-unidade = no
                     de-valor-pis              = 0
                     de-valor-cofins           = 0
                     de-retenc-pis             = 0
                     l-orig-retenc-pis         = "Natureza"
                     de-retenc-cofins          = 0
                     l-orig-retenc-cofins      = "Natureza"
                     de-retenc-csll            = 0
                     l-orig-retenc-csll        = "Natureza".

      &else
          assign l-calc-pis-por-unidade    = if  substr(item.char-1,193,1) = "2" then yes else no
                 l-calc-cofins-por-unidade = if  substr(item.char-1,194,1) = "2" then yes else no
                 de-valor-pis              = dec(substr(item.char-2,54,10))
                 de-valor-cofins           = dec(substr(item.char-2,64,10))
                 de-retenc-pis             = dec(substr(item.char-1,239,5))
                 l-orig-retenc-pis         = if substr(item.char-1,231,1) = "1"  then "Item"    
                                                                                 else "Natureza"
                 de-retenc-cofins          = dec(substr(item.char-1,244,5))
                 l-orig-retenc-cofins      = if substr(item.char-1,232,1) = "1"  then "Item"     
                                                                                 else "Natureza" 
                 de-retenc-csll            = dec(substr(item.char-1,234,5))
                 l-orig-retenc-csll        = if substr(item.char-1,233,1) = "1"  then "Item"     
                                                                                 else "Natureza". 
      &endif
  end.
  else
      assign l-calc-pis-por-unidade    = no
             l-calc-cofins-por-unidade = no
             de-valor-pis              = 0
             de-valor-cofins           = 0
             de-retenc-pis             = 0
             l-orig-retenc-pis         = "Natureza"
             de-retenc-cofins          = 0
             l-orig-retenc-cofins      = "Natureza"
             de-retenc-csll            = 0
             l-orig-retenc-csll        = "Natureza"
             de-val-aliq-dif-pis       = 0
             de-val-aliq-dif-cofins    = 0.

  /* Dispatch standard ADM method.                             */
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
  ENABLE l-calc-pis-por-unidade 
         de-valor-pis 
         cb-origem-pis 
         de-ali-pis 
         de-red-pis 
         de-retenc-pis 
         l-orig-retenc-pis 
         l-pis-cofins-subst-total 
         l-orig-retenc-csll 
         l-calc-cofins-por-unidade 
         de-valor-cofins 
         cb-origem-cofins 
         de-ali-cofins de-red-cofins 
         de-retenc-cofins 
         l-orig-retenc-cofins 
         de-retenc-csll 
         de-val-aliq-dif-cofins 
         de-val-aliq-dif-pis
         c-un-cofins-uni
         c-un-pis-uni
      WITH FRAME {&FRAME-NAME}.

  APPLY 'VALUE-CHANGED' to l-calc-pis-por-unidade    IN FRAME {&FRAME-NAME}.   
  APPLY 'VALUE-CHANGED' to l-calc-cofins-por-unidade IN FRAME {&FRAME-NAME}.   

  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
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

  IF NOT VALID-HANDLE (h-cdapi995)  THEN
      RUN cdp\cdapi995.p PERSISTENT SET h-cdapi995.

  IF NOT VALID-HANDLE(h-cdcfgfiscal) THEN
      RUN cdp/cdcfgfiscal.p PERSISTENT SET h-cdcfgfiscal.

  RUN pi-retorna-status IN h-cdcfgfiscal ("decimais-pis-cofins", 01).

  IF RETURN-VALUE <> "OK":U THEN
      ASSIGN de-ali-pis   :FORMAT IN FRAME {&FRAME-NAME} = ">9.99"
             de-ali-cofins:FORMAT IN FRAME {&FRAME-NAME} = ">9.99".
  
  
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  run traduzLiteral.
  
  
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    IF VALID-HANDLE(h-cdcfgfiscal) THEN DO:
            DELETE PROCEDURE h-cdcfgfiscal.
            ASSIGN h-cdcfgfiscal = ?.
    END.
    IF VALID-HANDLE(h-cdapi995) THEN DO:
            DELETE PROCEDURE h-cdapi995.
            ASSIGN h-cdapi995 = ?.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN Who-Is-The-Container IN adm-broker-hdl
        (INPUT this-procedure, OUTPUT c-handle1).
    assign wh-cd0903 = widget-handle(c-handle1).

    IF INPUT FRAME {&frame-name} c-un-pis-uni <> "" THEN DO:
        FIND FIRST tab-unidade WHERE tab-unidade.un = INPUT FRAME {&frame-name} c-un-pis-uni NO-ERROR.

        IF NOT AVAIL tab-unidade THEN DO:
             {utp/ut-liter.i "Unidade_de_Medida" *}
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 2,
                                INPUT TRIM(RETURN-VALUE)).
                                
             RUN select-page IN wh-cd0903 (4). 
             APPLY  'entry' to c-un-pis-uni in frame {&frame-name}.
             RETURN 'ADM-ERROR':U.
        END.
    END.
    
    IF INPUT FRAME {&frame-name} c-un-cofins-uni <> "" THEN DO:
        FIND FIRST tab-unidade WHERE tab-unidade.un = INPUT FRAME {&frame-name} c-un-cofins-uni NO-ERROR.

        IF NOT AVAIL tab-unidade THEN DO:
             {utp/ut-liter.i "Unidade_de_Medida" *}
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 2,
                                INPUT TRIM(RETURN-VALUE)).
                                
             RUN select-page IN wh-cd0903 (4). 
             APPLY  'entry' to c-un-cofins-uni in frame {&frame-name}.
             RETURN 'ADM-ERROR':U.
        END.
    END.
    
    {cdp/cd9998.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE traduzLiteral V-table-Win 
PROCEDURE traduzLiteral :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

    {utp/ut-liter.i PIS_Importaá∆o * }
    assign text-1:screen-value in frame {&frame-name} = RETURN-VALUE. 
    {utp/ut-liter.i COFINS_Importaá∆o * }
    assign text-2:screen-value in frame {&frame-name} = RETURN-VALUE. 
    {utp/ut-liter.i Al°quota_Diferenciada * }
    assign de-val-aliq-dif-pis:label in frame {&frame-name} = RETURN-VALUE. 
    assign de-val-aliq-dif-cofins:label in frame {&frame-name} = RETURN-VALUE. 
    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

