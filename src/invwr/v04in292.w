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
{include/i-prgvrs.i V04IN292 2.00.00.030 } /*** "010030" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V04IN292 MUT}
&ENDIF

{cdp/cdcfgmat.i}
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
DEFINE VARIABLE de-valor-var AS DECIMAL     NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES param-re
&Scoped-define FIRST-EXTERNAL-TABLE param-re


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-re.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-re.atu-advert param-re.atu-erro ~
param-re.erro-dupli param-re.cod-ent-item param-re.sem-pedido ~
param-re.alt-uf param-re.rateia-desc param-re.pede-quant ~
param-re.pd-despesas param-re.reabre-pd param-re.log-1 
&Scoped-define ENABLED-TABLES param-re
&Scoped-define FIRST-ENABLED-TABLE param-re
&Scoped-Define ENABLED-OBJECTS RECT-12 RECT-13 RECT-14 RECT-15 
&Scoped-Define DISPLAYED-FIELDS param-re.val-variacao param-re.atu-advert ~
param-re.atu-erro param-re.erro-dupli param-re.cod-ent-item ~
param-re.sem-pedido param-re.alt-uf param-re.rateia-desc ~
param-re.pede-quant param-re.pd-despesas param-re.reabre-pd param-re.log-1 ~
param-re.log-2 
&Scoped-define DISPLAYED-TABLES param-re
&Scoped-define FIRST-DISPLAYED-TABLE param-re
&Scoped-Define DISPLAYED-OBJECTS lRatDiferFIFO l-pede-dupli-auto ~
l-docto-fornec-rest l-ver-diverg-duplis-cp c-erros c-cod-ent-item c-opcoes ~
l-aloc-saldo l-solic-despesas-doc 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS l-docto-fornec-rest 
&Scoped-define ADM-ASSIGN-FIELDS l-docto-fornec-rest 
&Scoped-define ADM-MODIFY-FIELDS l-ver-diverg-duplis-cp ~
l-solic-despesas-doc 

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
DEFINE VARIABLE c-cod-ent-item AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16.29 BY .67 NO-UNDO.

DEFINE VARIABLE c-erros AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13.29 BY .67 NO-UNDO.

DEFINE VARIABLE c-opcoes AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 6.29 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 3.5.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 6.75.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 3.5.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 1.46.

DEFINE VARIABLE l-aloc-saldo AS LOGICAL INITIAL no 
     LABEL "Aloc Saldo Autom tico" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83 NO-UNDO.

DEFINE VARIABLE l-docto-fornec-rest AS LOGICAL INITIAL no 
     LABEL "Docto Fornec Com Restri‡Æo":L31 
     VIEW-AS TOGGLE-BOX
     SIZE 32.72 BY .83 NO-UNDO.

DEFINE VARIABLE l-pede-dupli-auto AS LOGICAL INITIAL no 
     LABEL "Pede Duplicata Autom tico" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83 NO-UNDO.

DEFINE VARIABLE l-solic-despesas-doc AS LOGICAL INITIAL YES 
     LABEL "Pede Despesas dos Documentos" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .71 NO-UNDO.

DEFINE VARIABLE l-ver-diverg-duplis-cp AS LOGICAL INITIAL no 
     LABEL "Verifica Divergˆncias Duplicatas x Condi‡Æo Pagamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 41.14 BY .71 NO-UNDO.

DEFINE VARIABLE lRatDiferFIFO AS LOGICAL INITIAL no 
     LABEL "Rateia Diferen‡a Quantidade FIFO" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-re.val-variacao AT ROW 10.83 COL 54.72 COLON-ALIGNED WIDGET-ID 2
          LABEL "Varia‡Æo Permitida"
          VIEW-AS FILL-IN 
          SIZE 6.14 BY .79
     param-re.atu-advert AT ROW 1.75 COL 8
          VIEW-AS TOGGLE-BOX
          SIZE 29.72 BY .67
     param-re.atu-erro AT ROW 2.75 COL 8
          VIEW-AS TOGGLE-BOX
          SIZE 22.14 BY .67
     param-re.erro-dupli AT ROW 3.75 COL 8
          VIEW-AS TOGGLE-BOX
          SIZE 32.29 BY .67
     param-re.cod-ent-item AT ROW 2 COL 50 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Nosso", 1,
"Fornecedor", 2
          SIZE 21.43 BY 2.17
     param-re.sem-pedido AT ROW 5.75 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 30.43 BY .83
     lRatDiferFIFO AT ROW 5.75 COL 40.86 HELP
          "Rateia Diferen‡a Quantidade FIFO"
     param-re.alt-uf AT ROW 6.58 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 15.86 BY .83
     param-re.rateia-desc AT ROW 6.58 COL 40.86
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .83
     param-re.pede-quant AT ROW 7.42 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 27.72 BY .83
     param-re.pd-despesas AT ROW 7.42 COL 40.86
          VIEW-AS TOGGLE-BOX
          SIZE 32.29 BY .83
     param-re.reabre-pd AT ROW 8.25 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 24.86 BY .83
     l-pede-dupli-auto AT ROW 8.25 COL 40.86
     param-re.log-1 AT ROW 9.08 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 31.57 BY .83
     l-docto-fornec-rest AT ROW 9.08 COL 40.86 HELP
          "Recebe Docto de Fornecedor com Restri‡äes."
     param-re.log-2 AT ROW 9.92 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 31.14 BY .83
     l-ver-diverg-duplis-cp AT ROW 10.04 COL 40.86
     c-erros AT ROW 1 COL 3 COLON-ALIGNED NO-LABEL
     c-cod-ent-item AT ROW 1 COL 45 COLON-ALIGNED NO-LABEL
     c-opcoes AT ROW 5 COL 2 COLON-ALIGNED NO-LABEL
     l-aloc-saldo AT ROW 6.58 COL 40.86
     l-solic-despesas-doc AT ROW 10.79 COL 5
     RECT-12 AT ROW 1.25 COL 3
     RECT-13 AT ROW 5.25 COL 3
     RECT-14 AT ROW 1.25 COL 45
     RECT-15 AT ROW 10.38 COL 40 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-re
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
         HEIGHT             = 11.17
         WIDTH              = 84.29.
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

/* SETTINGS FOR FILL-IN c-cod-ent-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-erros IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-opcoes IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-aloc-saldo IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       l-aloc-saldo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX l-docto-fornec-rest IN FRAME f-main
   NO-ENABLE 1 2                                                        */
ASSIGN 
       l-docto-fornec-rest:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX l-pede-dupli-auto IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       l-pede-dupli-auto:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX l-solic-despesas-doc IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX l-ver-diverg-duplis-cp IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX param-re.log-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lRatDiferFIFO IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       lRatDiferFIFO:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       param-re.pd-despesas:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       param-re.rateia-desc:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN param-re.val-variacao IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
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

&Scoped-define SELF-NAME l-ver-diverg-duplis-cp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-ver-diverg-duplis-cp V-table-Win
ON VALUE-CHANGED OF l-ver-diverg-duplis-cp IN FRAME f-main /* Verifica Divergˆncias Duplicatas x Condi‡Æo Pagamento */
DO:
  if l-ver-diverg-duplis-cp:checked in frame {&frame-name} = yes then do:
      enable param-re.val-variacao with frame {&frame-name}.  
  end.
  else do:
      disable param-re.val-variacao with frame {&frame-name}.
       ASSIGN de-valor-var = 0. 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-re.log-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-re.log-1 V-table-Win
ON VALUE-CHANGED OF param-re.log-1 IN FRAME f-main /* log-1 */
DO:
  if param-re.log-1:checked in frame {&frame-name} = yes then do:
      enable param-re.log-2 with frame {&frame-name}.
      &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
          enable lRatDiferFIFO with frame {&frame-name}.
      &endif
  end.
  else do:
      disable param-re.log-2 with frame {&frame-name}.
      assign param-re.log-2:checked in frame {&frame-name} = no.
      &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
          disable lRatDiferFIFO with frame {&frame-name}.
          assign lRatDiferFIFO:checked in frame {&frame-name} = no.
      &endif
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
  {src/adm/template/row-list.i "param-re"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-re"}

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
  {utp/ut-liter.i Erros/Advertˆncias * R}
  assign c-erros:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Op‡äes * R}
  assign c-opcoes:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Pede_Despesas_dos_Itens * R}
  assign param-re.pd-despesas:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i FIFO_nas_Ordens_de_Compra * R}
  assign param-re.log-1:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Considera_Valor_FIFO_Ordem_Compra * R}
  assign param-re.log-2:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind param-re cod-ent-item 1}
  assign c-cod-ent-item:screen-value in frame {&frame-name} = return-value.

  run get-attribute ('adm-new-record').

  IF adm-new-record THEN do:
      DISABLE param-re.log-2 WITH FRAME {&FRAME-NAME}.
      &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
          DISABLE lRatDiferFIFO WITH FRAME {&FRAME-NAME}.
      &endif
  end.

  IF adm-new-record AND INPUT FRAME {&FRAME-NAME} param-re.log-1 then do:
      ENABLE param-re.log-2 WITH FRAME {&FRAME-NAME}.
      &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
          ENABLE lRatDiferFIFO WITH FRAME {&FRAME-NAME}.
      &endif
  end.
  
  &IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN
      ASSIGN l-docto-fornec-rest:HIDDEN IN FRAME {&FRAME-NAME} = NO.
  &ELSE
      ASSIGN l-docto-fornec-rest:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  &ENDIF

   &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
       IF i-pais-impto-usuario = 1 THEN
          ASSIGN l-pede-dupli-auto:HIDDEN IN FRAME {&FRAME-NAME} = NO.
       ELSE
          ASSIGN l-pede-dupli-auto:HIDDEN IN FRAME {&FRAME-NAME} = yes.
       assign lRatDiferFIFO:hidden  in frame {&frame-name} = no
              lRatDiferFIFO:checked in frame {&frame-name} = no.
   &ELSE
       ASSIGN l-pede-dupli-auto:HIDDEN IN FRAME {&FRAME-NAME} = yes
              lRatDiferFIFO:hidden     in frame {&frame-name} = yes.
   &ENDIF
   
   IF adm-new-record THEN do:
      DISABLE param-re.val-variacao WITH FRAME {&FRAME-NAME}.
   end.

   IF adm-new-record AND INPUT FRAME {&FRAME-NAME} l-ver-diverg-duplis-cp then do:
      ENABLE param-re.val-variacao WITH FRAME {&FRAME-NAME}.
   end.

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
  DEF VAR l-log-2          AS LOG  NO-UNDO.
  DEF VAR c-pede-dupli-ex  AS CHAR NO-UNDO.
  DEF VAR l-RateiaDifFIFO  AS LOG  NO-UNDO.
  DEF VAR l-doctoFornecRes AS LOG  NO-UNDO.
  DEF VAR l-verifDiverg    AS LOG  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  assign l-log-2 = input frame {&frame-name} param-re.log-2
         l-RateiaDifFIFO  = lRatDiferFIFO:CHECKED IN FRAME {&FRAME-NAME}
         l-doctoFornecRes = l-docto-fornec-rest:CHECKED IN FRAME {&FRAME-NAME}
         l-verifDiverg    = l-ver-diverg-duplis-cp:CHECKED IN FRAME {&FRAME-NAME}.

  &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
      IF i-pais-impto-usuario = 1 THEN DO:
         ASSIGN c-pede-dupli-ex = IF input frame {&frame-name} l-pede-dupli-auto = YES 
                                  THEN "S"
                                  ELSE "N".
      END.
  &endif

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.
  ASSIGN param-re.log-2:CHECKED         IN FRAME {&FRAME-NAME} = l-log-2
         lRatDiferFIFO:CHECKED          IN FRAME {&FRAME-NAME} = l-RateiaDifFIFO
         l-docto-fornec-rest:CHECKED    IN FRAME {&FRAME-NAME} = l-doctoFornecRes
         l-ver-diverg-duplis-cp:CHECKED IN FRAME {&FRAME-NAME} = l-verifDiverg.

  assign param-re.log-2         = l-log-2
         lRatDiferFIFO          = l-RateiaDifFIFO
         l-docto-fornec-rest    = l-doctoFornecRes 
         l-ver-diverg-duplis-cp = l-verifDiverg.

  IF l-ver-diverg-duplis-cp:checked in frame {&frame-name} = yes THEN
     ASSIGN param-re.val-variacao = input frame {&frame-name} param-re.val-variacao.
  ELSE 
     ASSIGN param-re.val-variacao = de-valor-var.

  &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
      &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
          assign param-re.log-rat-difer-quant-fifo   = lRatDiferFIFO:checked          in frame {&frame-name}
                 /*Verifica Divergˆncias Duplicatas x Condi‡Æo de pagamento*/
                 param-re.log-diverg-dupl-cond-pagto = l-ver-diverg-duplis-cp:checked in frame {&frame-name}. 
      &else
          assign overlay(param-re.char-1,13,1) = if  lRatDiferFIFO :checked in frame {&frame-name} 
                                                     then "S"
                                                     else "N" 
                 /*Verifica Divergˆncias Duplicatas x Condi‡Æo de pagamento*/
                 overlay(param-re.char-1,14,1) = if  l-ver-diverg-duplis-cp:checked in frame {&frame-name} 
                                                     then "S"
                                                     else "N".
      &endif                                                                                       
  &endif

  &IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN 
      assign param-re.log-docto-fornec = input frame {&frame-name} l-docto-fornec-rest.
  &ENDIF  

  &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
      IF i-pais-impto-usuario = 1 THEN DO:
         &IF '{&bf_mat_versao_ems}' < '2.062' &THEN
             ASSIGN overlay(param-re.char-1,12,1) = c-pede-dupli-ex.
         &endif
         &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
             ASSIGN param-re.log-pedir-dupl-autom = IF c-pede-dupli-ex = "S" THEN YES ELSE NO.
         &endif
      END.
  &endif
  
  IF i-pais-impto-usuario = 2 THEN
        ASSIGN overlay(param-re.char-1,18,1) = if  l-aloc-saldo:checked in frame {&frame-name} 
                                               then "S"
                                               else "N".

  ASSIGN OVERLAY(param-re.char-1,28,1) = IF l-solic-despesas-doc:CHECKED IN FRAME {&FRAME-NAME} THEN "S"
                                                                                                ELSE "N".


  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ).

  IF CAN-FIND(FIRST funcao
              WHERE funcao.cd-funcao = "spp-sgt":U
              AND   funcao.ativo     = TRUE NO-LOCK) THEN DO:
     ASSIGN param-re.reabre-pd:CHECKED IN FRAME {&FRAME-NAME} = NO.
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

  disable param-re.log-2 with frame {&frame-name}.
  disable param-re.val-variacao with frame {&frame-name}.

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  &IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN
      DISABLE l-docto-fornec-rest WITH FRAME {&FRAME-NAME}.
  &ENDIF

  &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
      DISABLE l-pede-dupli-auto lRatDiferFIFO WITH FRAME {&FRAME-NAME}.
  &endif

  IF i-pais-impto-usuario = 2 THEN
     DISABLE l-aloc-saldo WITH FRAME {&FRAME-NAME}.

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
  {utp/ut-liter.i Erros/Advertˆncias * R}
  assign c-erros:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Op‡äes * R}
  assign c-opcoes:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Pede_Despesas_dos_Itens * R}
  assign param-re.pd-despesas:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i FIFO_nas_Ordens_de_Compra * R}
  assign param-re.log-1:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Considera_Valor_FIFO_Ordem_Compra * R}
  assign param-re.log-2:label in frame {&frame-name} = return-value.
  IF AVAIL param-re THEN DO:
      {utp/ut-field.i mgind param-re cod-ent-item 1}
      assign c-cod-ent-item:screen-value in frame {&frame-name} = return-value.
  END.

  &IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN
      IF AVAIL param-re THEN DO:
            ASSIGN l-docto-fornec-rest = param-re.log-docto-fornec.
            DISPLAY l-docto-fornec-rest WITH FRAME {&FRAME-NAME}.
      END.
  &ENDIF 

  &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
      IF i-pais-impto-usuario = 1 THEN DO:
         &IF '{&bf_mat_versao_ems}' < '2.062' &THEN
             IF AVAIL param-re THEN
                ASSIGN l-pede-dupli-auto:CHECKED = IF substr(param-re.char-1,12,1) = "S"
                                                THEN yes
                                                ELSE no.
             ELSE 
                 ASSIGN l-pede-dupli-auto:CHECKED = NO.
         &endif
         &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
             IF AVAIL param-re THEN
                ASSIGN l-pede-dupli-auto:CHECKED = param-re.log-pedir-dupl-autom.
             ELSE
                 ASSIGN l-pede-dupli-auto:CHECKED = NO.
         &endif
      END.
      &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
          IF AVAIL PARAM-re THEN
             assign lRatDiferFIFO:checked          in frame {&frame-name} = param-re.log-rat-difer-quant-fifo
                    /*Verifica Divergˆncias Duplicatas x Condi‡Æo de pagamento*/
                    l-ver-diverg-duplis-cp:checked in frame {&frame-name} = param-re.log-diverg-dupl-cond-pagto.
          ELSE
            assign lRatDiferFIFO:checked          in frame {&frame-name} = no
                   /*Verifica Divergˆncias Duplicatas x Condi‡Æo de pagamento*/
                   l-ver-diverg-duplis-cp:checked in frame {&frame-name} = no.
      &else
         IF AVAIL param-re THEN
            assign lRatDiferFIFO:checked          in frame {&frame-name} = if substr(param-re.char-1,13,1) = "S" then yes else no
                   /*Verifica Divergˆncias Duplicatas x Condi‡Æo de pagamento*/
                   l-ver-diverg-duplis-cp:checked in frame {&frame-name} = if substr(param-re.char-1,14,1) = "S" then yes else no.
          ELSE 
            assign lRatDiferFIFO:checked          in frame {&frame-name} = no
                   /*Verifica Divergˆncias Duplicatas x Condi‡Æo de pagamento*/
                   l-ver-diverg-duplis-cp:checked in frame {&frame-name} = no.
      &endif
  &endif
  
  IF i-pais-impto-usuario = 2 THEN
     ASSIGN l-aloc-saldo:CHECKED = IF substr(param-re.char-1,18,1) = "S"
                                   THEN yes
                                   ELSE no.

  ASSIGN l-solic-despesas-doc:CHECKED = IF SUBSTR(param-re.char-1,28,1) = "N" THEN NO
                                                                              ELSE YES.


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
  IF AVAIL param-re THEN DO:
      if adm-new-record = no and param-re.log-1 then do:
         enable param-re.log-2 with frame {&frame-name}.    
         &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
              enable lRatDiferFIFO with frame {&frame-name}.    
         &endif
      end.
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  &IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN
      ENABLE l-docto-fornec-rest WITH FRAME {&FRAME-NAME}.
  &ENDIF

  &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
      IF i-pais-impto-usuario = 1 THEN
         ENABLE l-pede-dupli-auto WITH FRAME {&FRAME-NAME}.
  &endif
  
  &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN 
      /*Verifica Divergˆncias Duplicatas x Condi‡Æo de pagamento*/
      assign l-ver-diverg-duplis-cp:hidden in frame {&frame-name} = no.
  &else
      /*Verifica Divergˆncias Duplicatas x Condi‡Æo de pagamento*/
      ASSIGN l-ver-diverg-duplis-cp:hidden in frame {&frame-name} = yes. 
  &endif

  /*Verifica‡Æo integra‡Æo do sgt */
      IF CAN-FIND(FIRST funcao
                  WHERE funcao.cd-funcao = "spp-sgt":U 
                  AND   funcao.ativo     = TRUE NO-LOCK) THEN DO:
         DISABLE param-re.reabre-pd WITH FRAME {&FRAME-NAME}. 
      END.

  IF i-pais-impto-usuario = 2 THEN
        ENABLE l-aloc-saldo WITH FRAME {&FRAME-NAME}.

  if l-ver-diverg-duplis-cp:checked in frame {&frame-name} = yes then do:
      enable param-re.val-variacao with frame {&frame-name}.  
  end.
  else do:
      disable param-re.val-variacao with frame {&frame-name}.
  end.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN
      ASSIGN l-docto-fornec-rest:HIDDEN IN FRAME {&FRAME-NAME} = NO.
  &ENDIF 

  &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN 
      IF i-pais-impto-usuario = 1 THEN
         ASSIGN l-pede-dupli-auto:HIDDEN IN FRAME {&FRAME-NAME} = no.
      ELSE
         ASSIGN l-pede-dupli-auto:HIDDEN IN FRAME {&FRAME-NAME} = yes.
      assign lRatDiferFIFO:hidden     in frame {&frame-name} = no.

      /*Verifica Divergˆncias Duplicatas x Condi‡Æo de pagamento*/
      assign l-ver-diverg-duplis-cp:hidden in frame {&frame-name} = no.

  &else
      ASSIGN l-pede-dupli-auto:HIDDEN      IN FRAME {&FRAME-NAME} = yes
             lRatDiferFIFO:hidden          in frame {&frame-name} = yes
             /*Verifica Divergˆncias Duplicatas x Condi‡Æo de pagamento*/
             l-ver-diverg-duplis-cp:hidden in frame {&frame-name} = yes. 
  &endif
  
  IF i-pais-impto-usuario <> 2 THEN /*Argentina*/ 
     ASSIGN l-aloc-saldo:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  ELSE
     ASSIGN l-aloc-saldo:HIDDEN IN FRAME {&FRAME-NAME} = NO.

  /* Code placed here will execute AFTER standard behavior.    */

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

  &IF DEFINED(BF_MAT_BLOQUEIO_FORNEC) &THEN
      ASSIGN l-docto-fornec-rest:HIDDEN IN FRAME {&FRAME-NAME} = NO.
  &ELSE
      ASSIGN l-docto-fornec-rest:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  &ENDIF

  &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
      IF i-pais-impto-usuario = 1 THEN
         ASSIGN l-pede-dupli-auto:HIDDEN IN FRAME {&FRAME-NAME} = no.
      ELSE
         ASSIGN l-pede-dupli-auto:HIDDEN IN FRAME {&FRAME-NAME} = yes.
      assign lRatDiferFIFO:hidden in frame {&frame-name} = no.
  &else
      ASSIGN l-pede-dupli-auto:HIDDEN IN FRAME {&FRAME-NAME} = yes
             lRatDiferFIFO:hidden     in frame {&frame-name} = yes.
  &endif

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */

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
  {src/adm/template/snd-list.i "param-re"}

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

