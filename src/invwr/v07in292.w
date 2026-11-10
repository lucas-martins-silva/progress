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
{include/i-prgvrs.i V07IN292 2.00.00.040 } /*** "010040" 26/11/2025 08:41:32  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V07IN292 MUT}
&ENDIF

/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

 -----------------------------------------------------------------------*/
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
DEFINE VARIABLE i-var-consig-aux    AS INTEGER    NO-UNDO.

{cdp/cdcfgmat.i} /* Definiá∆o PrÇ-Processadores */
&if "{&bf_mat_versao_ems}" >= "2.062":U &then
    {cdp/cd9590.i}
&endif

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
&Scoped-define EXTERNAL-TABLES param-re
&Scoped-define FIRST-EXTERNAL-TABLE param-re


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-re.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-re.log-ped-mesma-matriz ~
param-re.inc-seq param-re.seq-item-um param-re.variacao ~
param-re.esp-def-dup param-re.esp-def-dac param-re.pede-it-agreg ~
param-re.pede-desc-it param-re.aceita-var param-re.encerra-cc ~
param-re.rec-out-for param-re.pd-seq param-re.preco-unit param-re.reabre-cc ~
param-re.log-geracao-ncr-ap tg-contrat-leasing tg-validacao-conta
&Scoped-define ENABLED-TABLES param-re
&Scoped-define FIRST-ENABLED-TABLE param-re
&Scoped-Define ENABLED-OBJECTS c-valorizacao RECT-17 rt-mold 
&Scoped-Define DISPLAYED-FIELDS param-re.log-ped-mesma-matriz ~
param-re.inc-seq param-re.seq-item-um param-re.variacao ~
param-re.esp-def-dup param-re.esp-def-dac param-re.pede-it-agreg ~
param-re.pede-desc-it param-re.aceita-var param-re.encerra-cc ~
param-re.rec-out-for param-re.pd-seq param-re.preco-unit param-re.reabre-cc ~
param-re.log-geracao-ncr-ap 
&Scoped-define DISPLAYED-TABLES param-re
&Scoped-define FIRST-DISPLAYED-TABLE param-re
&Scoped-Define DISPLAYED-OBJECTS tg-contrat-leasing tg-des-lancto-gfe ~
tg-ut-config-trib-imp-ret c-esp-def-dup c-esp-def-dac i-var-consig ~
log-pedir-unid-negoc l-pd-esp-fiscal c-valorizacao tg-validacao-conta

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS log-pedir-unid-negoc 
&Scoped-define ADM-ASSIGN-FIELDS log-pedir-unid-negoc l-pd-esp-fiscal tg-ut-config-trib-imp-ret tg-des-lancto-gfe
&Scoped-define ADM-MODIFY-FIELDS i-var-consig log-pedir-unid-negoc ~
l-pd-esp-fiscal tg-ut-config-trib-imp-ret tg-des-lancto-gfe


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
DEFINE VARIABLE c-esp-def-dac AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-esp-def-dup AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-valorizacao AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 19.72 BY .67 NO-UNDO.

DEFINE VARIABLE i-var-consig AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "MÇdio", 1,
"Informado", 2
     SIZE 12 BY 1.79 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 6.29.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 22.72 BY 2.17.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 4.79.

DEFINE VARIABLE l-pd-esp-fiscal AS LOGICAL INITIAL no 
     LABEL "Pede Esp Fiscal" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.72 BY .83 NO-UNDO.

DEFINE VARIABLE log-pedir-unid-negoc AS LOGICAL INITIAL no 
     LABEL "Pede Unidade Neg¢cio" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.72 BY .83 NO-UNDO.

DEFINE VARIABLE tg-contrat-leasing AS LOGICAL INITIAL no 
     LABEL "Contrato Leasing" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-des-lancto-gfe AS LOGICAL INITIAL no 
     LABEL "Desatualiza Lancto GFE" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.29 BY .83 TOOLTIP "Usu†rio poder† desatualizar lanáamentos" NO-UNDO.

DEFINE VARIABLE tg-ut-config-trib-imp-ret AS LOGICAL INITIAL no 
     LABEL "Utiliza Config Trib Imp Ret" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-validacao-conta AS LOGICAL INITIAL NO
     LABEL "Validar Contas Cont†beis"
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-re.inc-seq AT ROW 1.54 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     param-re.seq-item-um AT ROW 1.54 COL 51.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     param-re.variacao AT ROW 2.54 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     param-re.esp-def-dup AT ROW 3.54 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     c-esp-def-dup AT ROW 3.54 COL 30.57 COLON-ALIGNED NO-LABEL
     param-re.esp-def-dac AT ROW 4.54 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     c-esp-def-dac AT ROW 4.54 COL 30.57 COLON-ALIGNED NO-LABEL
     i-var-consig AT ROW 6.54 COL 5.86 NO-LABEL
     tg-contrat-leasing AT ROW 8.63 COL 3 
     tg-validacao-conta AT ROW 9.63 COL 3 
     param-re.pede-it-agreg AT ROW 6 COL 28.57
          VIEW-AS TOGGLE-BOX
          SIZE 18.57 BY .88
     param-re.pede-desc-it AT ROW 6 COL 55.57
          VIEW-AS TOGGLE-BOX
          SIZE 16.29 BY .88
     param-re.aceita-var AT ROW 6.88 COL 28.57
          VIEW-AS TOGGLE-BOX
          SIZE 25.86 BY .88
     param-re.encerra-cc AT ROW 6.88 COL 55.57
          VIEW-AS TOGGLE-BOX
          SIZE 29 BY .88
     param-re.rec-out-for AT ROW 7.75 COL 28.57
          LABEL "Pedido Outro Fornec":L20
          VIEW-AS TOGGLE-BOX
          SIZE 21.86 BY .83
     param-re.pd-seq AT ROW 7.75 COL 55.57
          VIEW-AS TOGGLE-BOX
          SIZE 7.72 BY .88
     param-re.log-ped-mesma-matriz AT ROW 8.63 COL 28.57 WIDGET-ID 2
          VIEW-AS TOGGLE-BOX
          SIZE 30.72 BY .83
     param-re.preco-unit AT ROW 9.5 COL 28.57
          VIEW-AS TOGGLE-BOX
          SIZE 24.14 BY .88
     log-pedir-unid-negoc AT ROW 10.38 COL 55.57
     param-re.log-geracao-ncr-ap AT ROW 9.5 COL 55.57
          VIEW-AS TOGGLE-BOX
          SIZE 26.72 BY .83
     l-pd-esp-fiscal AT ROW 10.38 COL 28.57
     tg-ut-config-trib-imp-ret AT ROW 11.21 COL 28.57 WIDGET-ID 4
     param-re.reabre-cc AT ROW 8.63 COL 55.57
          VIEW-AS TOGGLE-BOX
          SIZE 26.14 BY .83
     tg-des-lancto-gfe AT ROW 11.21 COL 55.57 WIDGET-ID 6
     c-valorizacao AT ROW 6.04 COL 3 COLON-ALIGNED NO-LABEL
     RECT-22 AT ROW 6.33 COL 3
     RECT-17 AT ROW 5.83 COL 1
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


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
         HEIGHT             = 11.33
         WIDTH              = 85.
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

/* SETTINGS FOR FILL-IN c-esp-def-dac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-esp-def-dup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET i-var-consig IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX l-pd-esp-fiscal IN FRAME f-main
   NO-ENABLE 2 3                                                        */
ASSIGN 
       l-pd-esp-fiscal:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX log-pedir-unid-negoc IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX param-re.rec-out-for IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR RECTANGLE RECT-22 IN FRAME f-main
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

&Scoped-define SELF-NAME param-re.esp-def-dac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-re.esp-def-dac V-table-Win
ON F5 OF param-re.esp-def-dac IN FRAME f-main /* EspÇcie para Despesas */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="adzoom/z01ad104.w"
                      &campo=param-re.esp-def-dac
                      &campozoom=cod-esp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-re.esp-def-dac V-table-Win
ON LEAVE OF param-re.esp-def-dac IN FRAME f-main /* EspÇcie para Despesas */
DO:
   {include/leave.i &tabela=espec-ap
                   &atributo-ref=descricao
                   &variavel-ref=c-esp-def-dac
                   &where="espec-ap.cod-esp = input frame {&frame-name} param-re.esp-def-dac"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-re.esp-def-dac V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-re.esp-def-dac IN FRAME f-main /* EspÇcie para Despesas */
DO:
   apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-re.esp-def-dup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-re.esp-def-dup V-table-Win
ON F5 OF param-re.esp-def-dup IN FRAME f-main /* EspÇcie  Duplicatas NF */
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom="adzoom/z01ad104.w"
                      &campo=param-re.esp-def-dup
                      &campozoom=cod-esp}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-re.esp-def-dup V-table-Win
ON LEAVE OF param-re.esp-def-dup IN FRAME f-main /* EspÇcie  Duplicatas NF */
DO:
  {include/leave.i &tabela=espec-ap
                   &atributo-ref=descricao
                   &variavel-ref=c-esp-def-dup
                   &where="espec-ap.cod-esp = input frame {&frame-name} param-re.esp-def-dup"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-re.esp-def-dup V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-re.esp-def-dup IN FRAME f-main /* EspÇcie  Duplicatas NF */
DO:
   apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-re.log-ped-mesma-matriz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-re.log-ped-mesma-matriz V-table-Win
ON VALUE-CHANGED OF param-re.log-ped-mesma-matriz IN FRAME f-main /* Pedido mesma Matriz Fornec */
DO:
  rec-out-for:CHECKED = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-re.rec-out-for
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-re.rec-out-for V-table-Win
ON VALUE-CHANGED OF param-re.rec-out-for IN FRAME f-main /* Pedido Outro Fornec */
DO:
  log-ped-mesma-matriz:CHECKED = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

   /***************************************************************************************
   * PrÇ-processador utilizado para mostrar o toggle-box do campo param-re. pd-esp-fiscal,* 
     na release 2.03                                                                      *   
   ***************************************************************************************/

    &if defined(bf_mat_esp_fiscal) &then     
    if i-pais-impto-usuario = 1 then
        assign l-pd-esp-fiscal:hidden in frame {&frame-name} = no.          
    else
        assign l-pd-esp-fiscal:hidden in frame {&frame-name} = yes
               l-pd-esp-fiscal:sensitive in frame {&frame-name} = no.
    &endif
   /***************************************************************************************/
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

  if param-re.esp-def-dup:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.      
  if param-re.esp-def-dac:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

  {utp/ut-liter.i Valorizaá∆o_Entrada_Consig * R}
  assign c-valorizacao:screen-value in frame {&frame-name} = return-value.

  RUN pi-traducao.

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

  {utp/ut-liter.i Valorizaá∆o_Entrada_Consig * R}
  assign c-valorizacao:screen-value in frame {&frame-name} = return-value.


  RUN pi-traducao.
  
  /*Quando add o registro o padr∆o ser a flag desmarcada*/
  assign log-pedir-unid-negoc:checked in frame {&frame-name} = NO
         tg-contrat-leasing:checked in frame {&frame-name} = NO 
         tg-validacao-conta:checked in frame {&frame-name} = NO.

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

    ASSIGN i-var-consig-aux    = input frame {&frame-name} i-var-consig.

    find espec-ap where espec-ap.cod-esp = input frame {&frame-name} param-re.esp-def-dup no-lock no-error.
    if available espec-ap then do:
        if espec-ap.tipo = 2 then do:
           run utp/ut-msgs.p (input "show", 
                              input 4641, 
                              input "").
           apply "entry" to param-re.esp-def-dup in frame {&frame-name}.
           return 'ADM-ERROR':U.
        end.
    end.           
    find espec-ap where espec-ap.cod-esp = input frame {&frame-name} param-re.esp-def-dac no-lock no-error.
    if available espec-ap then do:
        if espec-ap.tipo = 2 then do:
           run utp/ut-msgs.p (input "show", 
                              input 4641, 
                              input "").
           apply "entry" to param-re.esp-def-dac in frame {&frame-name}.
           return 'ADM-ERROR':U.
        end.
    end.           


  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

  assign param-re.int-1 = if i-var-consig-aux = 1
                          then 0
                          else 1.

    /*********************************************************************************
    * PrÇ-processador utilizado para gravar valor no campo param-re.pd-esp-fiscal,   *
    * na release 2.03                                                                *   
    *********************************************************************************/
    &if defined(bf_mat_esp_fiscal) &then 
     if i-pais-impto-usuario = 1 then  
        if avail param-re then 
          assign param-re.pd-esp-fiscal = input frame {&frame-name} l-pd-esp-fiscal.     
    &endif
    /********************************************************************************/

    /***************************************************************************************
    * utilizado para gravar valor no campo param-re.log-pedir-unid-negoc,                  *
    * ,ut-config-trib-imp-ret , tg-contrat-leasing                                         *   
    ***************************************************************************************/
   
    IF AVAIL param-re THEN DO:
       ASSIGN param-re.log-pedir-unid-negoc = INPUT FRAME {&FRAME-NAME} log-pedir-unid-negoc.
       IF i-pais-impto-usuario = 1 THEN DO: /*Brasil*/
           IF tg-ut-config-trib-imp-ret:CHECKED IN FRAME {&FRAME-NAME} THEN
               ASSIGN OVERLAY(param-re.char-1,25,1) = "Y":U.
           ELSE 
               ASSIGN OVERLAY(param-re.char-1,25,1) = "":U.
           
           IF tg-contrat-leasing:CHECKED IN FRAME {&FRAME-NAME} THEN   /*entra somente quando for Brasil*/
               ASSIGN OVERLAY(param-re.char-1,27,1) = "S":U.
           ELSE 
               ASSIGN OVERLAY(param-re.char-1,27,1) = "N":U. 
       END.
       IF tg-des-lancto-gfe:CHECKED IN FRAME {&FRAME-NAME} THEN
           ASSIGN OVERLAY(param-re.char-1,26,1) = "S":U.
       ELSE 
           ASSIGN OVERLAY(param-re.char-1,26,1) = "N":U.

       /*parÉmetro para ativar a validaá∆o contas cont†beis*/
       ASSIGN param-re.log-validac-cta = INPUT FRAME {&FRAME-NAME} tg-validacao-conta.
    END.
    /**************************************************************************************/

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  &if "{&bf_mat_versao_ems}" >= "2.062":U &then
      if not l-mat-unid-negoc then
          assign log-pedir-unid-negoc:checked in frame {&frame-name}   = no
                 log-pedir-unid-negoc:sensitive in frame {&frame-name} = no.
  &endif

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  {utp/ut-liter.i Valorizaá∆o_Entrada_Consig * R}
  assign c-valorizacao:screen-value in frame {&frame-name} = return-value.

  RUN pi-traducao.
  
  find espec-ap where espec-ap.cod-esp = input frame {&frame-name} param-re.esp-def-dup no-lock no-error.
  if available espec-ap then
      display espec-ap.descricao @ c-esp-def-dup with frame {&frame-name}.

  find espec-ap where espec-ap.cod-esp = input frame {&frame-name} param-re.esp-def-dac no-lock no-error.
  if available espec-ap then
      display espec-ap.descricao @ c-esp-def-dac with frame {&frame-name}.

  if avail param-re then do:

      assign i-var-consig = if param-re.int-1 = 0 then 1
                            else 2.
      disp i-var-consig with frame {&frame-name}.

      /***************************************************************************************
       * utilizado para mostrar valor no campo param-re.log-pedir-unid-negoc                  *
       * e para o campo ut-config-trib-imp-ret                                                *
       ***************************************************************************************/
      
      if not adm-new-record then do:
          IF i-pais-impto-usuario = 1 THEN DO: /*Brasil*/
              /*cfg-trib*/
              if substring(param-re.char-1,25,1) = "Y":U then  
                  assign tg-ut-config-trib-imp-ret:CHECKED IN FRAME {&FRAME-NAME} = YES.
              else
                  assign tg-ut-config-trib-imp-ret:CHECKED IN FRAME {&FRAME-NAME} = NO.
            
             /*contrato leasing*/
             if substring(param-re.char-1,27,1) = "S":U then  
                 assign tg-contrat-leasing:CHECKED IN FRAME {&FRAME-NAME} = YES.
             else
                 assign tg-contrat-leasing:CHECKED IN FRAME {&FRAME-NAME} = NO.
          END.

          /*parÉmetro para ativar a validaá∆o das contas cont†beis*/
          /*O campo log-validac-cta por n∆o ser um campo mandat¢rio, o valor inicial dele Ç nulo,para n∆o apresentar 
            erro progress em tela, Ç verificado o conte£do do campo*/
          ASSIGN tg-validacao-conta:CHECKED IN FRAME {&FRAME-NAME} = IF param-re.log-validac-cta THEN YES ELSE NO.
          RUN pi-traducao.
      

          
          /*ctbz-gfe*/
          if substring(param-re.char-1,26,1) = "S":U then  
              assign tg-des-lancto-gfe:CHECKED IN FRAME {&FRAME-NAME} = YES.
          else
              assign tg-des-lancto-gfe:CHECKED IN FRAME {&FRAME-NAME} = NO.
  
              assign log-pedir-unid-negoc:screen-value in frame {&frame-name} = string(param-re.log-pedir-unid-negoc).
              
      end.    
      /**************************************************************************************/
  end.

  /* Code placed here will execute AFTER standard behavior.    */

  /*****************************************************************************************
  * PrÇ-processador utilizado para mostrar o valor do campo pd-esp-fiscal, na release 2.03 *   
  *****************************************************************************************/
  &if defined(bf_mat_esp_fiscal) &then
    if i-pais-impto-usuario = 1 then do:
       if avail param-re and
          not adm-new-record then do:
          assign l-pd-esp-fiscal = param-re.pd-esp-fiscal.
          disp l-pd-esp-fiscal with frame {&frame-name}.
       end.     
    end.
  &endif
  /****************************************************************************************/

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
  &if defined(bf_mat_esp_fiscal) &then
      if i-pais-impto-usuario = 1 then 
         assign l-pd-esp-fiscal:hidden in frame {&frame-name} = no.
      else
         assign l-pd-esp-fiscal:hidden in frame {&frame-name} = yes
                l-pd-esp-fiscal:sensitive in frame {&frame-name} = no.
  &else
      assign l-pd-esp-fiscal:hidden in frame {&frame-name} = yes
             l-pd-esp-fiscal:sensitive in frame {&frame-name} = no.
  &endif
  
  /***************************************************************************************
  * PrÇ-processador utilizado para gravar valor no campo param-re.log-pedir-unid-negoc, *
  * na release 2.06B                                                                    *   
  ***************************************************************************************/
  &if "{&bf_mat_versao_ems}" >= "2.062":U &then
      assign log-pedir-unid-negoc:hidden in frame {&frame-name}    = no
             log-pedir-unid-negoc:sensitive in frame {&frame-name} = l-mat-unid-negoc.
      
      if avail param-re then
          assign log-pedir-unid-negoc:screen-value in frame {&frame-name} = string(param-re.log-pedir-unid-negoc).

      if not l-mat-unid-negoc then
          assign log-pedir-unid-negoc:screen-value in frame {&frame-name} = string(l-mat-unid-negoc).
  &else
      assign log-pedir-unid-negoc:hidden in frame {&frame-name} = yes.
  &endif
  /**************************************************************************************/
 
  if i-pais-impto-usuario = 1 then do: /*Brasil*/
      /*habilita campo conforme parametrizado no re0103*/
      IF CAN-FIND(FIRST funcao WHERE 
                        funcao.cd-funcao = "spp-aut-impto":U AND
                        funcao.ativo) THEN
          ASSIGN tg-ut-config-trib-imp-ret:sensitive in frame {&frame-name} = yes.              
      ELSE    
          ASSIGN tg-ut-config-trib-imp-ret:sensitive in frame {&frame-name} = no. 
   end.
   ELSE
      ASSIGN tg-ut-config-trib-imp-ret:hidden in frame {&frame-name} = YES. 
      
  /*desatualizar lancto-gfe*/
  IF CAN-FIND(FIRST funcao 
              WHERE funcao.cd-funcao = "SPP_TOTVSGFE"
                AND funcao.ativo) THEN
      ASSIGN tg-des-lancto-gfe:SENSITIVE IN FRAME {&FRAME-NAME} = YES.


      
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

   /***************************************************************************************
   * PrÇ-processador utilizado para mostrar o toggle-box do campo param-re. pd-esp-fiscal,* 
     na release 2.03                                                                      *   
   ***************************************************************************************/
   &if defined(bf_mat_esp_fiscal) &then         
       if i-pais-impto-usuario = 1 then
          assign l-pd-esp-fiscal:hidden    in frame {&frame-name} = no
                 l-pd-esp-fiscal:sensitive in frame {&frame-name} = no.
       else
          assign l-pd-esp-fiscal:hidden in frame {&frame-name} = yes
                 l-pd-esp-fiscal:sensitive in frame {&frame-name} = no.
   &endif
   /***************************************************************************************/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  {utp/ut-liter.i Variac_Perm_Dt_Entrega * R}
  assign param-re.variacao:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i EspÇcie_Duplicatas_NFF MME R}
  assign param-re.esp-def-dup:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Variaá∆o_Permitida_para_Data_de_Entrega * R}
  assign param-re.variacao:help in frame {&frame-name} = return-value. 
  
  {utp/ut-liter.i Valorizaá∆o_Entrada_Consig * R}
  assign c-valorizacao:screen-value in frame {&frame-name} = return-value.

  RUN pi-traducao.


  assign param-re.esp-def-dup:format in frame {&frame-name} = "x(2)"
         param-re.esp-def-dac:format in frame {&frame-name} = "x(2)".

  find first param-global no-lock no-error.

  if i-pais-impto-usuario = 1 then
      assign log-geracao-ncr-ap:hidden in frame {&frame-name} = yes
             log-geracao-ncr-ap:sensitive in frame {&frame-name} = no.
  ELSE
      assign tg-ut-config-trib-imp-ret:HIDDEN in frame {&frame-name} = yes
             tg-ut-config-trib-imp-ret:sensitive in frame {&frame-name} = no
             tg-contrat-leasing:HIDDEN in frame {&frame-name} = yes
             tg-contrat-leasing:sensitive in frame {&frame-name} = no.

  run pi-organiza-tela.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-organiza-tela V-table-Win 
PROCEDURE pi-organiza-tela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&if "{&bf_mat_versao_ems}" < "2.062":U &then
    assign log-pedir-unid-negoc:hidden in frame f-main   = yes.
&endif

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
 
 IF i-pais-impto-usuario = 1 AND /*Brasil*/
    tg-ut-config-trib-imp-ret:CHECKED IN FRAME {&FRAME-NAME} AND
    NOT CAN-FIND(FIRST funcao WHERE 
                       funcao.cd-funcao = "spp-aut-impto":U AND
                       funcao.ativo) THEN DO:
                       
        def var c-texto-1 as char no-undo.
        def var c-texto-2 as char no-undo.
        
        {utp/ut-liter.i "Parametrizaá∆o_n∆o_permitida." *}
        Assign c-texto-1 = RETURN-VALUE.
        
        {utp/ut-liter.i "ê_necess†rio_ativar_a_func∆o_Sugere_Imposto_Retido_Duplicata_(RE0103)." *}
        Assign c-texto-2 = RETURN-VALUE.
                
        run utp/ut-msgs.p (input "show":U,        
                           input 29693,           
                           input c-texto-1 + "~~" + c-texto-2).
        return 'ADM-ERROR':U.
    END.                       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-traducao V-table-Win 
PROCEDURE pi-traducao:
    {utp/ut-liter.i Desatualiza_Lancto_GFE * R}
    assign tg-des-lancto-gfe:label in frame {&frame-name} = return-value.

    {utp/ut-liter.i Validar_Contas_Cont†beis * R}
    assign tg-validacao-conta:LABEL in frame {&frame-name} = return-value.

    RETURN "OK":U.
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

