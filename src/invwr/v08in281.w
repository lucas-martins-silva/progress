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
{include/i-prgvrs.i V08IN281 2.00.01.024 } /*** "010124" 22/10/2026 14:46:05 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v08in281 MUT}
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

{cdp/cdcfgman.i}  /* Defini‡Æo preprocessador bf_man_sfc_lc */

DEFINE VARIABLE l-spp-gera-reserva-config      AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE l-log-reserva-config           AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE l-valida-apont-retroativo-op   AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE l-rep-ordem-producao           AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE c-msg                          AS CHARACTER NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES param-cp
&Scoped-define FIRST-EXTERNAL-TABLE param-cp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-cp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-cp.log-1 
&Scoped-define ENABLED-TABLES param-cp
&Scoped-define FIRST-ENABLED-TABLE param-cp
&Scoped-Define ENABLED-OBJECTS RECT-35 tb-sd-neg RECT-36 RECT-38 lote ~
l-libera-op RECT-39 tg-log-reserva-config RECT-40 ~
tg-valida-apont-retroativo-op integra-wms c-lote-wms tg-ativo ~
c-url-webservice bt-testar-ws tg-prod bt-seguranca bt-log-xml ~
bt-diagnostico bt-param c-texto-1 c-integr-ppi 
&Scoped-Define DISPLAYED-OBJECTS tb-sd-neg lote l-libera-op ~
tg-log-reserva-config tg-valida-apont-retroativo-op integra-wms c-lote-wms ~
tg-ativo c-url-webservice tg-prod c-texto-1 c-integr-ppi 

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
DEFINE BUTTON bt-diagnostico 
     LABEL "Diagn¢stico" 
     SIZE 9.72 BY 1.

DEFINE BUTTON bt-log-xml 
     LABEL "Log XML" 
     SIZE 9.72 BY 1.

DEFINE BUTTON bt-param 
     LABEL "Parƒmetros" 
     SIZE 9.72 BY 1.

DEFINE BUTTON bt-seguranca 
     LABEL "Seguran‡a" 
     SIZE 9.72 BY 1.

DEFINE BUTTON bt-testar-ws 
     LABEL "" 
     SIZE 9.72 BY 1.

DEFINE VARIABLE c-integr-ppi AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 18.14 BY .67 NO-UNDO.

DEFINE VARIABLE c-lote-wms AS CHARACTER FORMAT "X(40)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-texto-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .67 NO-UNDO.

DEFINE VARIABLE c-url-webservice AS CHARACTER FORMAT "X(150)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 42.86 BY .88 NO-UNDO.

DEFINE VARIABLE lote AS CHARACTER FORMAT "X(40)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 10.75.

DEFINE RECTANGLE RECT-36
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.29 BY 2.5.

DEFINE RECTANGLE RECT-38
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.29 BY 1.79.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.29 BY 1.79.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.29 BY 2.79.

DEFINE VARIABLE integra-wms AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 45 BY .83 NO-UNDO.

DEFINE VARIABLE l-libera-op AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tb-sd-neg AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 45 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ativo AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 6 BY .83 NO-UNDO.

DEFINE VARIABLE tg-log-reserva-config AS LOGICAL INITIAL no 
     LABEL "Gera Reserva Configurado" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 TOOLTIP "Gera Reserva Configurado" NO-UNDO.

DEFINE VARIABLE tg-prod AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-valida-apont-retroativo-op AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tb-sd-neg AT ROW 2 COL 81.14 RIGHT-ALIGNED
     param-cp.log-1 AT ROW 2.75 COL 2
          VIEW-AS TOGGLE-BOX
          SIZE 3.57 BY 7.83
     lote AT ROW 3.04 COL 35.43 COLON-ALIGNED
     l-libera-op AT ROW 4.92 COL 7.29
     tg-log-reserva-config AT ROW 4.92 COL 29.14 HELP
          "Gera Reserva Configurado"
     tg-valida-apont-retroativo-op AT ROW 4.92 COL 56 WIDGET-ID 4
     integra-wms AT ROW 6.96 COL 8
     c-lote-wms AT ROW 6.96 COL 49.14 COLON-ALIGNED
     tg-ativo AT ROW 9.08 COL 7.72
     c-url-webservice AT ROW 9.17 COL 25 COLON-ALIGNED
     bt-testar-ws AT ROW 9.08 COL 70.29
     tg-prod AT ROW 10.13 COL 7.72 WIDGET-ID 6
     bt-seguranca AT ROW 10.08 COL 40.29
     bt-log-xml AT ROW 10.08 COL 50.29
     bt-diagnostico AT ROW 10.08 COL 60.29 WIDGET-ID 2
     bt-param AT ROW 10.08 COL 70.29
     c-texto-1 AT ROW 1.5 COL 5.86 COLON-ALIGNED NO-LABEL
     c-integr-ppi AT ROW 8.42 COL 5.86 COLON-ALIGNED NO-LABEL
     RECT-35 AT ROW 1.25 COL 1
     RECT-36 AT ROW 1.75 COL 6
     RECT-38 AT ROW 4.46 COL 6
     RECT-39 AT ROW 6.5 COL 6
     RECT-40 AT ROW 8.75 COL 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-cp
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
         HEIGHT             = 11.42
         WIDTH              = 84.
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

/* SETTINGS FOR TOGGLE-BOX param-cp.log-1 IN FRAME f-main
   NO-DISPLAY                                                           */
ASSIGN 
       param-cp.log-1:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tb-sd-neg IN FRAME f-main
   ALIGN-R                                                              */
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

&Scoped-define SELF-NAME bt-diagnostico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-diagnostico V-table-Win
ON CHOOSE OF bt-diagnostico IN FRAME f-main /* Diagn¢stico */
DO:
    RUN "cpp/cp0106d.w".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-log-xml
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-log-xml V-table-Win
ON CHOOSE OF bt-log-xml IN FRAME f-main /* Log XML */
DO:
    RUN "cpp/cplogxml.w".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-param
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-param V-table-Win
ON CHOOSE OF bt-param IN FRAME f-main /* Parƒmetros */
DO:   
    ASSIGN CURRENT-WINDOW:SENSITIVE = FALSE.
    RUN "cpp/cp0106b.w".
    ASSIGN CURRENT-WINDOW:SENSITIVE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-seguranca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-seguranca V-table-Win
ON CHOOSE OF bt-seguranca IN FRAME f-main /* Seguran‡a */
DO:
    RUN "cpp/cp0106c.w".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-testar-ws
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-testar-ws V-table-Win
ON CHOOSE OF bt-testar-ws IN FRAME f-main
DO:   
    ASSIGN c-msg  = "". 
    RUN pi-testar-ws IN THIS-PROCEDURE(OUTPUT c-msg).
    IF c-msg = "" THEN 
       RUN utp/ut-msgs.p (INPUT "show":U, 
                          INPUT 53255, 
                          INPUT "":u).
    ELSE DO:
        {utp/ut-liter.i "MES_Channel" *}
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 36365, 
                           INPUT RETURN-VALUE + "~~":U + c-msg).      
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME integra-wms
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integra-wms V-table-Win
ON VALUE-CHANGED OF integra-wms IN FRAME f-main
DO:
  
    DISP c-lote-wms WITH FRAME {&FRAME-NAME}.
    assign c-lote-wms:sensitive in frame {&frame-name} = integra-wms:CHECKED IN FRAME {&FRAME-NAME}.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-sd-neg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-sd-neg V-table-Win
ON VALUE-CHANGED OF tb-sd-neg IN FRAME f-main
DO:
  if tb-sd-neg:checked in frame {&frame-name} then
     disp lote with frame {&frame-name}.
  else
      disp "" @ lote with frame {&frame-name}.
  assign lote:sensitive in frame {&frame-name} = tb-sd-neg:checked in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-ativo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-ativo V-table-Win
ON VALUE-CHANGED OF tg-ativo IN FRAME f-main
DO: 
    APPLY 'ENTRY':U TO c-url-webservice IN FRAME {&FRAME-NAME}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-prod V-table-Win
ON VALUE-CHANGED OF tg-prod IN FRAME f-main
DO: 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  RUN verificaFuncaoReservaConfig.

  DEF VAR l-existe-wm    AS LOG NO-UNDO.

  {utp/ut-liter.i Reporte_Repetitivo/Batch * L}
  assign c-texto-1 = trim (return-value).
  {utp/ut-liter.i Integra‡Æo_TOTVS_MES * }
  assign c-integr-ppi = trim (return-value).

  disp c-texto-1 
       c-integr-ppi 
       with frame {&frame-name}.

  {utp/ut-liter.i Lote_padrÆo_para_saldo_negativo * L}
  assign lote:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Lote_WMS * L}
  assign c-lote-wms:label in frame {&frame-name}   = trim(return-value)
         c-lote-wms:HIDDEN IN FRAME {&FRAME-NAME} = NO.
  
  {utp/ut-liter.i Permite_saldo_negativo_para_itens_contr._por_lote *}
  assign tb-sd-neg:label in frame {&frame-name} = trim (return-value).

  {utp/ut-liter.i Utiliza_Libera‡Æo_OP * L}
  assign l-libera-op:label = trim (return-value).

  {utp/ut-liter.i Integra‡Æo_WMS * L}
  assign integra-wms:label = trim (return-value).

  {utp/ut-liter.i Ativo *}
  assign tg-ativo:label = trim (return-value).

  {utp/ut-liter.i Reporta_no_PCP *}
  assign tg-prod:label = trim (return-value).

  {utp/ut-liter.i URL_Webservice *}
  assign c-url-webservice:label = trim (return-value).

  {utp/ut-liter.i Testar_WS *}
  assign bt-testar-ws:label = trim (return-value).

  {utp/ut-liter.i Parƒmetros *}
  assign bt-param:label = trim (return-value).


  IF l-spp-gera-reserva-config THEN DO:
      {utp/ut-liter.i Gera_Reserva_Configurado *}
      ASSIGN tg-log-reserva-config:LABEL in frame {&frame-name} = trim (return-value).
  END.

  {utp/ut-liter.i Valida_apontamento_retroativo_OP *}
  ASSIGN tg-valida-apont-retroativo-op:LABEL in frame {&frame-name} = trim (return-value).

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
  {src/adm/template/row-list.i "param-cp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-cp"}

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

  {utp/ut-liter.i Reporte_Repetitivo mcp l}
  assign c-texto-1 = trim (return-value).

  disp c-texto-1 with frame {&frame-name}. 

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
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  

  assign lote = input frame {&frame-name} lote.

  ASSIGN c-lote-wms = input frame {&frame-name} c-lote-wms.

  ASSIGN l-valida-apont-retroativo-op = input frame {&frame-name} tg-valida-apont-retroativo-op
         l-rep-ordem-producao         = input frame {&frame-name} tg-prod.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

  assign param-cp.lote = lote.

  ASSIGN param-cp.cod-lote-wms  = c-lote-wms.
  
  ASSIGN param-cp.log-integr-wms = integra-wms:CHECKED IN FRAME {&FRAME-NAME}.

  IF l-spp-gera-reserva-config THEN
      ASSIGN param-cp.log-reserva-config = tg-log-reserva-config:CHECKED IN FRAME {&frame-name}.
    
  assign param-cp.int-1 = 0
         overlay(param-cp.char-1,8,1) = if input frame {&frame-name} l-libera-op = yes then "1"
                                          else "2"
         param-cp.log-integr-ppi-mes    = input frame {&frame-name} tg-ativo
         param-cp.des-url-ws            = input frame {&frame-name} c-url-webservice.

  RUN pi-assign-param-manuf.
    
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

  DISABLE integra-wms 
          tg-log-reserva-config
      WITH FRAME {&FRAME-NAME}.

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

  /* Esse campo s¢ est  na tela para que o programa funcione, pois ‚
     necess rio que exista um campo de tabela habilitado na viewer */
  assign param-cp.log-1:sensitive in frame {&frame-name} = no.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if avail param-cp then do:
      assign lote:screen-value in frame {&frame-name} = param-cp.lote.
    
      ASSIGN integra-wms:CHECKED IN FRAME {&frame-name} = param-cp.log-integr-wms.

      IF l-spp-gera-reserva-config THEN
          ASSIGN tg-log-reserva-config:CHECKED IN FRAME {&frame-name} = param-cp.log-reserva-config
                 l-log-reserva-config                                 = param-cp.log-reserva-config.
      
      ASSIGN  c-lote-wms:SCREEN-VALUE IN FRAME {&FRAME-NAME} = param-cp.cod-lote-wms.

      assign l-libera-op:checked in frame {&frame-name} = if substring(param-cp.char-1,8,1) = "1" then yes
                                                              else no.
  end.

  RUN pi-trata-param-manuf.

  assign tb-sd-neg:CHECKED IN FRAME {&FRAME-NAME}                     = (lote:screen-value in frame {&frame-name} <> "")
         lote:SENSITIVE    IN FRAME {&FRAME-NAME}                     = tb-sd-neg:checked in frame {&frame-name}
         tg-valida-apont-retroativo-op:CHECKED IN FRAME {&FRAME-NAME} = l-valida-apont-retroativo-op
         tg-ativo:CHECKED  IN FRAME {&FRAME-NAME}                     = param-cp.log-integr-ppi-mes
         tg-prod:CHECKED IN FRAME {&FRAME-NAME}                       = l-rep-ordem-producao
         c-url-webservice:SCREEN-VALUE IN FRAME {&FRAME-NAME}         = param-cp.des-url-ws.

  FOR FIRST param-global FIELDS (modulo-ch) NO-LOCK:
      IF NOT param-global.modulo-ch THEN
          ASSIGN tg-prod:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* O novo campo s¢ ser  habilitado se a base mgscm estiver conectada
  *  e se houver registros na tabela wm-param. */
  IF CONNECTED("mgscm") THEN DO:
      ENABLE integra-wms WITH FRAME {&FRAME-NAME}.
  END.

  /* Code placed here will execute AFTER standard behavior.    */

  if adm-new-record = yes then
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  /*habilita conforme funcao especial spp-gera-reserva-config*/
  ASSIGN tg-log-reserva-config:sensitive in frame {&frame-name} = l-spp-gera-reserva-config.

  /* Esse campo s¢ est  na tela para que o programa funcione, pois ‚
     necess rio que exista um campo de tabela habilitado na viewer */
  assign param-cp.log-1:sensitive in frame {&frame-name} = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-assign-param-manuf V-table-Win 
PROCEDURE pi-assign-param-manuf :
/* -----------------------------------------------------------
  Purpose: Atualiza a param-manuf conforme os flags da tela
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
 FOR FIRST param-manuf
      WHERE param-manuf.cod-entid = "param-cp"
        AND param-manuf.cod-param = "log-valida-apont-retroativo-op" EXCLUSIVE-LOCK:

     ASSIGN param-manuf.param-logico = l-valida-apont-retroativo-op.
 END.

 FOR FIRST param-manuf
     WHERE param-manuf.cod-entid = "param-cp"
       AND param-manuf.cod-param = "log-reporte-ordem-pela-producao" EXCLUSIVE-LOCK:

     ASSIGN param-manuf.param-logico = l-rep-ordem-producao.
 END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-testar-ws V-table-Win 
PROCEDURE pi-testar-ws :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hWebService  AS HANDLE    NO-UNDO.
    DEFINE OUTPUT PARAM pc-msg   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cConnString  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-user       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-password   AS CHARACTER NO-UNDO.

    CREATE SERVER hWebService. 

    IF CAN-FIND(FIRST param-integr-mes 
                WHERE param-integr-mes.idi-entidade = 5) THEN DO:

        FOR EACH param-integr-mes 
           WHERE param-integr-mes.idi-entidade = 5 NO-LOCK:

           IF param-integr-mes.cod-campo = "user" THEN 
               ASSIGN c-user = param-integr-mes.des-campo.

           IF param-integr-mes.cod-campo = "password" THEN 
               ASSIGN c-password = param-integr-mes.des-campo.
        END.
                                     
        ASSIGN cConnString = " -WSDL '":U + c-url-webservice:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "?wsdl'" +
                             " -WSDLUserid '" + c-user + "'" +
                             " -WSDLPassword '" + c-password + "'" +
                             " -SOAPEndpointUserid '" + c-user + "'" +
                             " -SOAPEndpointPassword '" + c-password + "'" +
                             " -clientConnectTimeout 60000".
    END.
    ELSE DO:
        ASSIGN cConnString = "-WSDL '":U + c-url-webservice:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "?wsdl'":U.
    END.
    
    hWebService:CONNECT(cConnString) NO-ERROR.
    IF NOT hWebService:CONNECTED() THEN    
        ASSIGN pc-msg = ERROR-STATUS:GET-MESSAGE(1).   
    ELSE                       
        hWebService:DISCONNECT() NO-ERROR.                         
    
    RETURN "OK":U. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-param-manuf V-table-Win 
PROCEDURE pi-trata-param-manuf :
/* -----------------------------------------------------------
  Purpose: Faz a criacao/localiza‡Æo dos registros da param-manuf (parametros novos) e
  alimenta as flags correspondentes   
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  FOR FIRST param-manuf
      WHERE param-manuf.cod-entid = "param-cp"
        AND param-manuf.cod-param = "log-valida-apont-retroativo-op" NO-LOCK:
  END.

  IF NOT AVAIL param-manuf THEN DO:

      CREATE param-manuf.
      ASSIGN param-manuf.cod-entid = "param-cp"                      
             param-manuf.cod-param = "log-valida-apont-retroativo-op"
             param-manuf.dsl-help-msg = "Se ativado, o sistema nÆo ir  permitir o lan‡amento de movimenta‡äes com data anterior … data de in¡cio da ordem de produ‡Æo."
             param-manuf.desc-param = "Valida apontamento retroativo OP"
             param-manuf.titulo = "Valida apont. Retroativo OP".
  END.

  ASSIGN l-valida-apont-retroativo-op = param-manuf.param-logico.

  FOR FIRST param-manuf
      WHERE param-manuf.cod-entid = "param-cp"
        AND param-manuf.cod-param = "log-reporte-ordem-pela-producao" NO-LOCK:
  END.

  IF NOT AVAIL param-manuf THEN DO:

      CREATE param-manuf.
      ASSIGN param-manuf.cod-entid = "param-cp"                      
             param-manuf.cod-param = "log-reporte-ordem-pela-producao"
             param-manuf.dsl-help-msg = "Quando SFC implantado, se ativado, o cliente quer reporte por ordem seja pelo m¢dulo de produ‡Æo"
             param-manuf.desc-param = "Reporte por ordem pelo PCP"
             param-manuf.titulo = "Reporte por ordem pelo PCP".
  END.

  ASSIGN l-rep-ordem-producao = param-manuf.param-logico.

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


  /*******************Valida‡Æo Parƒmetro "Gera Reserva Configurado"**************/
  /*Somente permite ativar ou desativar o parƒmetro caso nÆo hajam registros de 
    Reserva Alternativa Configurada com Ordem Pai ou Ordem Filha em aberto*/
  DEFINE VARIABLE l-ord-n-finalizada AS LOGICAL INIT NO NO-UNDO.

  IF l-spp-gera-reserva-config AND l-log-reserva-config <> tg-log-reserva-config:CHECKED IN FRAME f-main THEN DO:
      /*se funcao ativada e valor de tela diferente de valor original, entÆo:*/

      FOR EACH al-res-op FIELDS(nr-ord-res nr-ord-produ) NO-LOCK:
          
          IF    CAN-FIND(FIRST ord-prod WHERE ord-prod.nr-ord-produ = al-res-op.nr-ord-res   /*Ordem pai*/
                                          AND ord-prod.estado       < 7 NO-LOCK)             /*Estado diferente Finalizada e Terminada*/
             OR CAN-FIND(FIRST ord-prod WHERE ord-prod.nr-ord-produ = al-res-op.nr-ord-produ /*Ordem filha*/                               
                                          AND ord-prod.estado       < 7 NO-LOCK) THEN DO:    /*Estado diferente Finalizada e Terminada*/ 
              ASSIGN l-ord-n-finalizada = YES.
              LEAVE.
          END.
      END.

      IF l-ord-n-finalizada THEN DO:
          {include/i-vldprg.i}
          IF tg-log-reserva-config:CHECKED IN FRAME f-main THEN DO:
              {utp/ut-liter.i Ativa‡Æo *}
          END.
          ELSE DO:
              {utp/ut-liter.i Desativa‡Æo *}
          END.
          /*NÆo permitida &1 do parƒmetro Gera Reserva Configurado. 
            Existem ordens que devem ser conclu¡das antes desta mudan‡a. Deseja visualiz -las? */
          run utp/ut-msgs.p (input "show":U, input 31416, input return-value).   
          IF RETURN-VALUE = "yes":U THEN DO:

              /*trava a tela*/
              assign {&window-name}:sensitive = no.

              /*Chama o relatorio Ordens Pendentes Configurador*/
              RUN cpp/cp0106a.w.

              /*Destrava a tela*/
              assign {&WINDOW-NAME}:sensitive = yes.

          END.
          APPLY "entry":U TO tg-log-reserva-config IN FRAME f-main.
          return 'ADM-ERROR':U.
      END.
  END.

  
    IF  INPUT FRAME {&FRAME-NAME} integra-wms = YES
    AND INPUT FRAME {&FRAME-NAME} c-lote-wms  = ""  THEN DO:
        {utp/ut-liter.i "Lote_WMS" *}
        run utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17677, 
                           INPUT RETURN-VALUE).   
        RETURN 'ADM-ERROR':U.
    END.
    
    
    /* *************Integra‡Æo PPI x Multitask *******************/
    IF tg-ativo:CHECKED AND c-url-webservice:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:       
        run utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 29042, /* URL deve ser informada */
                           INPUT "":U).   
        APPLY "entry":U TO c-url-webservice IN FRAME {&FRAME-NAME}.                   
        RETURN 'ADM-ERROR':U.  
    END.     
     
    IF tg-ativo:CHECKED THEN DO:
        ASSIGN c-msg  = "". 
        RUN pi-testar-ws IN THIS-PROCEDURE(OUTPUT c-msg).
        IF c-msg <> "" THEN DO: 
            {utp/ut-liter.i "MES_Channel" *}
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 36365, 
                               INPUT RETURN-VALUE + "~~":U + c-msg).      
        END.
    END.    

    /* *************Integra‡Æo PPI x Multitask *******************/        

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
  {src/adm/template/snd-list.i "param-cp"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaFuncaoReservaConfig V-table-Win 
PROCEDURE verificaFuncaoReservaConfig :
/*------------------------------------------------------------------------------
  Purpose:     verifica se a funcao especial "spp-gera-reserva-config" est  ativa
               quando nÆo ativa, esconde o parametro Gera Reserva Configurado
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN l-spp-gera-reserva-config = YES.

IF NOT l-spp-gera-reserva-config THEN
    ASSIGN tg-log-reserva-config:HIDDEN IN FRAME f-main    = YES
           tg-log-reserva-config:SENSITIVE IN FRAME f-main = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

