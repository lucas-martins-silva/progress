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
{include/i-prgvrs.i V02IN280 2.00.00.041 } /*** 010041 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02in280 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR l-spp-integra-portal    AS LOG INITIAL NO NO-UNDO.
DEF VAR l-spp-integra-paradigma AS LOG INITIAL NO NO-UNDO.
DEF NEW GLOBAL SHARED VAR g-icm AS LOGICAL NO-UNDO.
DEF VAR l-gera-item-for         AS LOGICAL NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES param-compra
&Scoped-define FIRST-EXTERNAL-TABLE param-compra


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-compra.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-compra.Log-despesa ~
param-compra.utiliza-taxa param-compra.utiliza-icm param-compra.utiliza-iss ~
param-compra.cria-eve-ped param-compra.compra-centr ~
param-compra.gera-item-for param-compra.var-preco param-compra.var-quantid ~
param-compra.ipi-sobre-preco param-compra.int-2 param-compra.taxa-financ ~
param-compra.nr-dias-taxa param-compra.prox-nr-prog ~
param-compra.aliq-icm-pad param-compra.aliq-iss-pad 
&Scoped-define ENABLED-TABLES param-compra
&Scoped-define FIRST-ENABLED-TABLE param-compra
&Scoped-Define ENABLED-OBJECTS l-sugere-fator-conv-item l-integra-portal ~
l-considera-restr l-gestor c-estab-central RECT-2 RECT-3 RECT-4 RECT-7 ~
RECT-8 rt-mold RECT-9 RECT-10 
&Scoped-Define DISPLAYED-FIELDS param-compra.Log-despesa ~
param-compra.utiliza-taxa param-compra.utiliza-icm param-compra.utiliza-iss ~
param-compra.cria-eve-ped param-compra.compra-centr ~
param-compra.gera-item-for param-compra.var-preco param-compra.var-quantid ~
param-compra.ipi-sobre-preco param-compra.int-2 param-compra.taxa-financ ~
param-compra.nr-dias-taxa param-compra.prox-nr-prog ~
param-compra.aliq-icm-pad param-compra.aliq-iss-pad 
&Scoped-define DISPLAYED-TABLES param-compra
&Scoped-define FIRST-DISPLAYED-TABLE param-compra
&Scoped-Define DISPLAYED-OBJECTS l-sugere-fator-conv-item l-integra-portal ~
l-considera-restr l-gestor c-estab-central 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS l-sugere-fator-conv-item l-considera-restr 
&Scoped-define ADM-ASSIGN-FIELDS l-sugere-fator-conv-item l-considera-restr 
&Scoped-define ADM-MODIFY-FIELDS l-sugere-fator-conv-item l-considera-restr 

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
DEFINE VARIABLE c-estab-central LIKE estabelec.cod-estabel
     LABEL "":R7 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-int-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 17 BY .63 NO-UNDO.

DEFINE VARIABLE fi-integra-portal AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16.14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-ipi-sobre-preco AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE l-cotacao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 1.17.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45.57 BY 1.42.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45.57 BY 2.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46 BY 5.38.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45.72 BY 1.42.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 2.13.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 1.15.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 6.25.

DEFINE VARIABLE l-considera-restr AS LOGICAL INITIAL no 
     LABEL "Considera Restr Usu rio Docto" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .75 NO-UNDO.

DEFINE VARIABLE l-gestor AS LOGICAL INITIAL no 
     LABEL "Sugere Estab. Gestor" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.29 BY .83.

DEFINE VARIABLE l-integra-portal AS LOGICAL INITIAL no 
     LABEL "Integra com Portal de Compras" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .83 NO-UNDO.

DEFINE VARIABLE l-sugere-fator-conv-item AS LOGICAL INITIAL no 
     LABEL "Sugere Fator de Conv. Gera‡Æo Item/Fornec" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .75 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     l-sugere-fator-conv-item AT ROW 7.92 COL 4
     fi-integra-portal AT ROW 9 COL 1.86 COLON-ALIGNED NO-LABEL
     l-integra-portal AT ROW 9.58 COL 4
     param-compra.Log-despesa AT ROW 1 COL 4
          LABEL "Trata Despesas":L14
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .75
     param-compra.utiliza-taxa AT ROW 1.75 COL 4
          VIEW-AS TOGGLE-BOX
          SIZE 28 BY .75
     param-compra.utiliza-icm AT ROW 2.5 COL 4
          VIEW-AS TOGGLE-BOX
          SIZE 16.86 BY .75
     param-compra.utiliza-iss AT ROW 3.25 COL 4
          VIEW-AS TOGGLE-BOX
          SIZE 15.14 BY .75
     param-compra.cria-eve-ped AT ROW 4 COL 4
          VIEW-AS TOGGLE-BOX
          SIZE 30 BY .75
     param-compra.compra-centr AT ROW 4.75 COL 4
          VIEW-AS TOGGLE-BOX
          SIZE 34.14 BY .75
     param-compra.gera-item-for AT ROW 5.5 COL 4
          VIEW-AS TOGGLE-BOX
          SIZE 31.14 BY .75
     l-considera-restr AT ROW 6.25 COL 4
     l-gestor AT ROW 10.88 COL 4
     c-estab-central AT ROW 11.75 COL 18.72 COLON-ALIGNED HELP
          ""
          LABEL "":R7
     param-compra.var-preco AT ROW 1.25 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     param-compra.var-quantid AT ROW 2.25 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     param-compra.ipi-sobre-preco AT ROW 4.42 COL 51.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Bruto", 1,
"L¡quido", 2
          SIZE 29.86 BY .75
     param-compra.int-2 AT ROW 6 COL 51.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Grupo de compras", 1,
"Comprador", 2
          SIZE 33.86 BY 1
     param-compra.taxa-financ AT ROW 7.75 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     param-compra.nr-dias-taxa AT ROW 8.75 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     param-compra.prox-nr-prog AT ROW 9.75 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     param-compra.aliq-icm-pad AT ROW 10.75 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     param-compra.aliq-iss-pad AT ROW 11.75 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     fi-ipi-sobre-preco AT ROW 3.71 COL 40.43 COLON-ALIGNED NO-LABEL
     fi-int-2 AT ROW 5.5 COL 40.14 COLON-ALIGNED NO-LABEL
     l-cotacao AT ROW 7.29 COL 1 COLON-ALIGNED NO-LABEL 
     RECT-2 AT ROW 3.92 COL 40.29
     RECT-3 AT ROW 1 COL 40.29
     RECT-4 AT ROW 7.5 COL 39.86
     RECT-7 AT ROW 5.75 COL 40.14
     RECT-8 AT ROW 10.75 COL 1
     rt-mold AT ROW 1 COL 1
     RECT-9 AT ROW 9.42 COL 1
     RECT-10 AT ROW 7.67 COL 1 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-compra
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
         WIDTH              = 85.14.
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

ASSIGN 
       param-compra.aliq-icm-pad:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       param-compra.aliq-iss-pad:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-estab-central IN FRAME f-main
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FILL-IN fi-int-2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-integra-portal IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-ipi-sobre-preco IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX l-considera-restr IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN l-cotacao IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX l-sugere-fator-conv-item IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR TOGGLE-BOX param-compra.Log-despesa IN FRAME f-main
   EXP-LABEL                                                            */
ASSIGN 
       param-compra.utiliza-icm:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       param-compra.utiliza-iss:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME c-estab-central
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-central V-table-Win
ON F5 OF c-estab-central IN FRAME f-main
DO:
      {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=c-estab-central
                       &campozoom=cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-central V-table-Win
ON LEAVE OF c-estab-central IN FRAME f-main
DO:
   &if defined(bf_mat_contratos) &then 
       if input frame {&frame-name} c-estab-central <> " " then do.
          find estabelec where 
               estabelec.cod-estabel = input frame {&frame-name} c-estab-central no-lock no-error.
          if not avail estabelec then do:
             run utp/ut-msgs.p ("show",13, input frame {&frame-name} c-estab-central).
             return no-apply.
          end.  
       end.
   &endif    


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-central V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-estab-central IN FRAME f-main
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-compra.gera-item-for
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.gera-item-for V-table-Win
ON VALUE-CHANGED OF param-compra.gera-item-for IN FRAME f-main /* Gera Rela‡Æo Item/Fornecedor */
DO:
  RUN pi-habilita-campos IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-compra.utiliza-icm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.utiliza-icm V-table-Win
ON VALUE-CHANGED OF param-compra.utiliza-icm IN FRAME f-main /* Utiliza ICMS */
DO:
    if  self:checked then enable param-compra.aliq-icm-pad with frame {&frame-name}.
    else disable param-compra.aliq-icm-pad with frame {&frame-name}.
    if param-compra.utiliza-ic:checked in frame {&frame-name} = yes then DO:
        ASSIGN g-icm = YES.
    END.
    ELSE  DO:
        ASSIGN g-icm = NO.
        END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-compra.utiliza-iss
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.utiliza-iss V-table-Win
ON VALUE-CHANGED OF param-compra.utiliza-iss IN FRAME f-main /* Utiliza ISS */
DO:
    if  self:checked then enable param-compra.aliq-iss-pad with frame {&frame-name}.
    else disable param-compra.aliq-iss-pad with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-compra.utiliza-taxa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.utiliza-taxa V-table-Win
ON VALUE-CHANGED OF param-compra.utiliza-taxa IN FRAME f-main /* Utiliza Taxa Financ */
DO:
    if  self:checked 
    then enable param-compra.taxa-financ  
                param-compra.nr-dias-taxa with frame {&frame-name}.
    else disable param-compra.taxa-financ
                 param-compra.nr-dias-taxa with frame {&frame-name}.
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

  {utp/ut-rtlbl.i mgind param-compra ipi-sobre-preco fi-ipi-sobre-preco}

  {utp/ut-liter.i Gera‡Æo_Ordem_Compras * R}
  assign fi-int-2:screen-value in frame {&frame-name} = return-value.

  {utp/ut-liter.i Portal_de_Compras * R}
  ASSIGN fi-integra-portal:screen-value in frame {&frame-name} = return-value.

  {utp/ut-liter.i Cota‡Æo * R}
  ASSIGN l-cotacao:screen-value in frame {&frame-name} = return-value.

  &if defined(bf_mat_contratos) &then 
     if c-estab-central:load-mouse-pointer("image/lupa.cur") then .
     {utp/ut-liter.i Estabelecimento_Central * r}
      assign c-estab-central:label in frame {&frame-name} = trim(return-value).
  &endif

  FIND FIRST funcao NO-LOCK
       WHERE funcao.cd-funcao = "SPP-INTEGRA-PORTAL-COMPRA":U
         AND funcao.ativo NO-ERROR.

  IF AVAIL funcao THEN DO:
      ASSIGN l-spp-integra-portal = YES.
  END.

  FIND FIRST funcao NO-LOCK
       WHERE funcao.cd-funcao = "spp-portal-paradigma":U
         AND funcao.ativo NO-ERROR.

  IF AVAIL funcao THEN DO:
      ASSIGN l-spp-integra-paradigma = YES.
  END.

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
  {src/adm/template/row-list.i "param-compra"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-compra"}

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */
  &if defined(bf_mat_contratos) &then 
      assign input frame {&frame-name} c-estab-central.
      if avail param-compra then 
      assign param-compra.cod-estab-central = input frame {&frame-name} c-estab-central.

      &IF defined(bf_mat_bloqueio_fornec) &THEN
      if l-considera-restr:checked in frame {&frame-name} = yes then do:
         if avail param-compra THEN
            assign param-compra.log-consid-usuar-docto = yes.
      end.
      else do:
         if avail param-compra then
            assign param-compra.log-consid-usuar-docto = no.
      end.
      &ENDIF

      /* Estab. Gestor */
      if l-gestor:checked in frame {&frame-name} = yes then
         assign substring(param-compra.char-2,97,3) = "YES".
      else
         assign substring(param-compra.char-2,97,3) = "NO".    
  &endif
     
  /*Integra‡Æo Portal de Compras - Maylon*/
  IF l-spp-integra-portal THEN DO:
      IF l-integra-portal:checked in frame {&frame-name} = yes THEN DO:
          &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
               ASSIGN SUBSTRING(param-compra.CHAR-2,102,1) = "S":U.
          &ELSE
               ASSIGN param-compra.log-integr-portal = YES.
          &ENDIF
      END.
      ELSE DO:
          &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
               ASSIGN SUBSTRING(param-compra.CHAR-2,102,1) = "N":U.
          &ELSE
               ASSIGN param-compra.log-integr-portal = NO.
          &ENDIF
      END.
  END.
  ELSE DO:
      /* Integra‡Æo Portal Paradigma - Jucinei */
      IF l-spp-integra-paradigma THEN DO:
          IF l-integra-portal:checked in frame {&frame-name} = yes THEN DO:
              &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                   ASSIGN SUBSTRING(param-compra.CHAR-2,103,1) = "S":U.
              &ELSE
                   ASSIGN param-compra.log-portal-paradigma = YES.
              &ENDIF
          END.
          ELSE DO:
              &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                   ASSIGN SUBSTRING(param-compra.CHAR-2,103,1) = "N":U.
              &ELSE
                   ASSIGN param-compra.log-portal-paradigma = NO.
              &ENDIF
          END.
      END.
  END.


  /* param-compra.char-2,136,1 -> Sugere Fator de Conv. Gera‡Æo Item/Fornec */ 
  IF l-sugere-fator-conv-item:CHECKED IN FRAME {&FRAME-NAME} = YES THEN DO:
     IF AVAIL param-compra THEN
        ASSIGN OVERLAY(param-compra.char-2,136,1) = "S".
  END.
  ELSE DO:
     IF AVAIL param-compra THEN
        ASSIGN OVERLAY(param-compra.char-2,136,1) = "N".
  end.

  RUN pi-habilita-campos IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

def var c-icm like param-compra.aliq-icm-pad no-undo.
def var c-iss like param-compra.aliq-iss-pad no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */

  assign c-icm  = input frame {&frame-name} param-compra.aliq-icm-pad
         c-iss  = input frame {&frame-name} param-compra.aliq-iss-pad.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if c-icm <> 0 then 
      assign param-compra.aliq-icm-pad:screen-value in frame {&frame-name} = string(c-icm).
  if c-iss <> 0 then    
      assign param-compra.aliq-iss-pad:screen-value in frame {&frame-name} = string(c-iss).



  /* Code placed here will execute AFTER standard behavior.    */
  do  with frame {&frame-name}:
      assign param-compra.aliq-icm-pad:sensitive   = param-compra.utiliza-icm:checked 
             param-compra.aliq-iss-pad:sensitive   = param-compra.utiliza-iss:checked
             param-compra.taxa-financ:sensitive    = param-compra.utiliza-taxa:checked
             param-compra.nr-dias-taxa:sensitive   = param-compra.utiliza-taxa:checked.

      &IF defined(bf_mat_bloqueio_fornec) &THEN
      if param-compra.log-consid-usuar-docto = yes then
         assign l-considera-restr:checked in frame {&FRAME-NAME} = yes.
      else
         assign l-considera-restr:checked in frame {&FRAME-NAME} = no.
      &ENDIF
  end.

  &if defined(bf_mat_contratos) &then 
      if substring(param-compra.char-2,97,3) = "YES" then
      assign l-gestor:checked in frame {&FRAME-NAME} = yes.
    else
      assign l-gestor:checked in frame {&FRAME-NAME} = no.  
  &endif 

  /*Integra‡Æo Portal de Compras - Maylon*/
  IF l-spp-integra-portal THEN DO:
      ASSIGN l-integra-portal:SENSITIVE IN FRAME f-main = YES
             l-integra-portal:CHECKED   IN FRAME f-main = &IF  "{&bf_mat_versao_ems}" < "2.09" &THEN
                                                              IF SUBSTRING(param-compra.char-2,102,1) = "S":U THEN YES ELSE NO
                                                          &else param-compra.log-integr-portal &ENDIF
             l-integra-portal:LABEL IN FRAME f-main = "Integra com Portal de Compras"
             rt-mold:HEIGHT = 6.25.
  END.
  ELSE DO:
      /* Integra‡Æo Portal Paradigma - Jucinei */
      IF l-spp-integra-paradigma THEN DO:
          ASSIGN l-integra-portal:SENSITIVE IN FRAME f-main = YES
                 l-integra-portal:CHECKED   IN FRAME f-main = &IF  "{&bf_mat_versao_ems}" < "2.09" &THEN
                                                                  IF SUBSTRING(param-compra.char-2,103,1) = "S":U THEN YES ELSE NO
                                                              &else param-compra.log-portal-paradigma &ENDIF
                 l-integra-portal:LABEL     IN FRAME f-main = "Integra com Portal Paradigma":U
                 rt-mold:HEIGHT = 6.25.
      END.
      ELSE DO:
          ASSIGN l-integra-portal:VISIBLE  IN FRAME f-main = NO
                 fi-integra-portal:VISIBLE IN FRAME f-main = NO
                 rect-9:VISIBLE            IN FRAME f-main = NO
                 rt-mold:HEIGHT                            = 9.50.
      END.
  END.
  /*Maylon*/


  /* param-compra.char-2,136,1 -> Sugere Fator de Conv. Gera‡Æo Item/Fornec */ 
  IF TRIM(SUBSTRING(param-compra.char-2,136,1)) = "S" THEN
      ASSIGN l-sugere-fator-conv-item = YES
             l-sugere-fator-conv-item:CHECKED IN FRAME {&FRAME-NAME} = YES.
  ELSE
      ASSIGN l-sugere-fator-conv-item = NO 
             l-sugere-fator-conv-item:CHECKED IN FRAME {&FRAME-NAME} = NO.

  RUN pi-habilita-campos IN THIS-PROCEDURE.

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

  find first param-compra no-lock no-error.
  if not avail param-compra then
     create param-compra.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &if defined(bf_mat_contratos) &then 
       assign c-estab-central:hidden in frame {&frame-name} = FALSE.
       if avail param-compra then 
          assign c-estab-central:screen-value  in frame {&frame-name} = param-compra.cod-estab-central.    

       assign l-gestor:hidden in frame {&frame-name} = FALSE.

  &else
       assign c-estab-central:hidden in frame {&frame-name} = TRUE.    
       assign l-gestor:hidden in frame {&frame-name} = TRUE.    
  &endif

  if mgind.param-compra.int-2 <> 1 and
     mgind.param-compra.int-2 <> 2
  then
      assign mgind.param-compra.int-2:screen-value in frame {&frame-name} = "2".

  /* Code placed here will execute AFTER standard behavior.    */

  &IF defined(bf_mat_bloqueio_fornec) &THEN
      assign l-considera-restr:hidden in frame {&frame-name} = no.
  &ELSE
      assign l-considera-restr:hidden in frame {&frame-name} = yes. 
  &ENDIF
  
  IF i-pais-impto-usuario <> 1 THEN
      ASSIGN fi-ipi-sobre-preco:HIDDEN IN FRAME {&FRAME-NAME}           = YES
             rect-2:HIDDEN IN FRAME {&FRAME-NAME}                       = YES
             param-compra.ipi-sobre-preco:HIDDEN IN FRAME {&frame-name} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view V-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  find first param-compra no-lock no-error. 
  if avail param-compra then
     assign param-compra.prox-nr-prog:SENSITIVE in frame {&FRAME-NAME} = no.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos V-table-Win 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN l-gera-item-for                                           = param-compra.gera-item-for:CHECKED IN FRAME {&FRAME-NAME}
           l-sugere-fator-conv-item:SENSITIVE IN FRAME {&FRAME-NAME} = l-gera-item-for.

    IF NOT l-gera-item-for THEN
        ASSIGN l-sugere-fator-conv-item                                  = NO
               l-sugere-fator-conv-item:CHECKED IN FRAME {&FRAME-NAME}   = NO.

    RETURN "OK":U.
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

    IF l-spp-integra-portal    AND
       l-spp-integra-paradigma THEN DO:
        {include/i-vldprg.i}
        RUN utp/ut-msgs.p (input "show":U,
                           input 52188,
                           input "SPP-PORTAL-PARADIGMA":U + "~~" + "SPP-INTEGRA-PORTAL-COMPRA":U).
        APPLY "entry" TO l-integra-portal IN FRAME {&frame-name}.
        RETURN "adm-error":U.
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
  {src/adm/template/snd-list.i "param-compra"}

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

