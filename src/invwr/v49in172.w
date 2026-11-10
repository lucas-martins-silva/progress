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
{include/i-prgvrs.i V49IN172 2.00.00.015 } /*** "010015" 27/08/2026 14:06:27 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v49in172 MCD}
&ENDIF

/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo. 
def var wh-cd0903         as handle    no-undo.
def var c-handle          as character no-undo.
DEF VAR h-bodi538         AS HANDLE    NO-UNDO.
DEF VAR i-identif         AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

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
&Scoped-define EXTERNAL-TABLES item item-dist
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item, item-dist.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-dist.cdn-onu item-dist.cod-class-risco ~
item-dist.cod-grp-embal item-dist.nom-apropdo-embal ~
item-dist.des-pto-fulgor item-dist.log-possui-certif c-prodanvisa ~
item-dist.desc-ecommerce
&Scoped-define ENABLED-TABLES item-dist
&Scoped-define FIRST-ENABLED-TABLE item-dist
&Scoped-Define ENABLED-OBJECTS c-cod-embal c-prodanvisa c-motiv-isencao  d-peso-quant-ltda tb-quant-ltda ~
tx-certific rt-inf-onu rt-certific c-Proc-Suframa
&Scoped-Define DISPLAYED-FIELDS item-dist.cdn-onu item-dist.cod-class-risco ~
item-dist.cod-grp-embal item-dist.nom-apropdo-embal ~
item-dist.des-pto-fulgor item-dist.log-possui-certif item-dist.desc-ecommerce
&Scoped-define DISPLAYED-TABLES item-dist
&Scoped-define FIRST-DISPLAYED-TABLE item-dist
&Scoped-Define DISPLAYED-OBJECTS c-cod-embal c-prodanvisa c-motiv-isencao d-peso-quant-ltda ~
tb-quant-ltda tx-certific tx-ecommerce tx-livre-comercio-zfm c-Proc-Suframa

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

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
     
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE d-peso-quant-ltda AS DECIMAL FORMAT ">>>,>>>,>>9.99999":U INITIAL 0 
     LABEL "Peso Quant Limitada" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .88 NO-UNDO.

DEFINE VARIABLE tx-certific AS CHARACTER FORMAT "X(16)" INITIAL "Certificados" 
      VIEW-AS TEXT 
     SIZE 10 BY .5 NO-UNDO.

DEFINE VARIABLE tx-Inf-Onu AS CHARACTER FORMAT "X(10)" INITIAL "Inf. ONU" 
      VIEW-AS TEXT 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-certific
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 1.29.

DEFINE RECTANGLE rt-inf-onu
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 6.29.

DEFINE VARIABLE tx-medic AS CHARACTER FORMAT "X(12)" INITIAL "Medicamento" 
      VIEW-AS TEXT 
     SIZE 10 BY .63 NO-UNDO.

DEFINE RECTANGLE rt-medic
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 2.13.

DEFINE VARIABLE tb-quant-ltda AS LOGICAL INITIAL no 
     LABEL "Quantidade Limitada" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.14 BY .83 NO-UNDO.

DEFINE VARIABLE c-cod-embal AS CHARACTER FORMAT "X(20)":U 
     LABEL "C¢digo da Embalagem" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .79 NO-UNDO.


DEFINE VARIABLE c-prodanvisa AS CHARACTER FORMAT "X(15)":U 
     LABEL "Registro Anvisa" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-motiv-isencao AS CHARACTER FORMAT "X(55)":U 
     LABEL "Motivo Isen‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE tx-ecommerce AS CHARACTER FORMAT "X(16)" INITIAL "E-commerce" 
     VIEW-AS TEXT 
     SIZE 9 BY .38 NO-UNDO.

DEFINE RECTANGLE rt-ecommerce
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 1.30.

DEFINE VARIABLE tx-livre-comercio-zfm AS CHARACTER FORMAT "X(20)" INITIAL "Livre Com‚rcio / ZFM" 
  VIEW-AS TEXT 
  SIZE 18 BY .38 NO-UNDO.

DEFINE VARIABLE c-Proc-Suframa AS CHARACTER FORMAT "x(12)":U 
  LABEL "Nr Processo Suframa" 
  VIEW-AS FILL-IN 
  SIZE 15 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-livre-comercio-zfm
  EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
  SIZE 80 BY 1.50.
/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-dist.cdn-onu AT ROW 1.5 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     item-dist.cod-class-risco AT ROW 1.5 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item-dist.cod-grp-embal AT ROW 2.5 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     item-dist.nom-apropdo-embal AT ROW 3.5 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     item-dist.des-pto-fulgor AT ROW 4.5 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     d-peso-quant-ltda AT ROW 5.5 COL 25 COLON-ALIGNED HELP
          "Peso que ser  validado contra o peso do item em questÆo":U
     tb-quant-ltda AT ROW 5.5 COL 52 HELP
          "ExpressÆo 'Quantidade Limitada' gerada XML e impressa no DANFE":U
     c-cod-embal AT ROW 6.5 COL 25 COLON-ALIGNED HELP
          "C¢digo da Embalagem ou Instru‡Æo relativa a embalagens"
     c-prodanvisa AT ROW 7.75 COL 25.14 COLON-ALIGNED HELP
          "N£mero Registro Anvisa":U
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     c-motiv-isencao AT ROW 8.75 COL 25 COLON-ALIGNED HELP
          "Motivo do N£mero do Registro da Anvisa ser Isento":U      
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     item-dist.log-possui-certif AT ROW 10 COL 27
          LABEL "Necessita Certificado?"
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     item-dist.desc-ecommerce AT ROW 11.54 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     tx-Inf-Onu AT ROW 1 COL 2 COLON-ALIGNED NO-LABEL
     tx-medic   AT ROW 7.5 COL 2 COLON-ALIGNED NO-LABEL
     tx-ecommerce AT ROW 11.21 COL 2 COLON-ALIGNED NO-LABEL
    tx-certific AT ROW 9.75 COL 2 COLON-ALIGNED NO-LABEL
    tx-livre-comercio-zfm AT ROW 12.63 COL 2 COLON-ALIGNED NO-LABEL
    c-Proc-Suframa AT ROW 13.21 COL 25 COLON-ALIGNED HELP
      "NF-e - n£mero do processo na Suframa para o item (gALCZFMCBS) comercializado":U
    rt-inf-onu AT ROW 1.21 COL 1
     rt-medic AT ROW 7.63 COL 1
     rt-certific AT ROW 11.29 COL 1
     rt-ecommerce AT ROW 9.88 COL 1
    rt-livre-comercio-zfm AT ROW 12.80 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item,mgdis.item-dist
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
         HEIGHT             = 14.29
         WIDTH              = 80.29.
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

/* SETTINGS FOR TOGGLE-BOX item-dist.log-possui-certif IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tx-Inf-Onu IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-prodanvisa V-table-Win
ON LEAVE OF c-prodanvisa IN FRAME f-main /* Registro anvisa */
DO:
    IF  c-prodanvisa :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Isento" THEN DO:
       ENABLE c-motiv-isencao WITH FRAME {&FRAME-NAME}.
       APPLY "entry" TO c-motiv-isencao IN FRAME {&FRAME-NAME}. 
       return no-apply.
    END.
  ELSE DO:
      ASSIGN c-motiv-isencao :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
      DISABLE c-motiv-isencao WITH FRAME {&FRAME-NAME}.
  END.
         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
      
 /* RUN dispatch IN THIS-PROCEDURE ('initialize':U).    */

 &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN 
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).                   
 &ENDIF               
                                                  
 {utp/ut-liter.i "Inf. ONU"}                                                  
 assign tx-Inf-Onu:screen-value in frame {&frame-name} = trim(return-value).  
 {utp/ut-liter.i "Certificados"}                                              
 ASSIGN tx-certific:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE). 
 {utp/ut-liter.i "Medicamentos"}                                              
 ASSIGN tx-medic:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE). 
 {utp/ut-liter.i "Livre Com‚rcio / ZFM"}                                      
 ASSIGN tx-livre-comercio-zfm:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE). 
                                                                      

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
  {src/adm/template/row-list.i "item-dist"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}
  {src/adm/template/row-find.i "item-dist"}

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

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
  IF  NOT FRAME {&FRAME-NAME}:VALIDATE() THEN
      RETURN 'ADM-ERROR':U.

  IF  c-prodanvisa :SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "Isento" THEN 
      ASSIGN c-motiv-isencao :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  RUN dispatch IN THIS-PROCEDURE (INPUT 'assign-record':U ).           
  IF RETURN-VALUE = 'ADM-ERROR':U THEN
      RETURN 'ADM-ERROR':U.

  IF NOT VALID-HANDLE(h-bodi538) THEN
      RUN dibo/bodi538.p PERSISTENT SET h-bodi538.

  /*** Grava Peso Quantidade Limitada ***/
  FIND FIRST reg-inf-compl
       WHERE reg-inf-compl.cod-tab-inform   = "item-dist"
       AND   reg-inf-compl.cod-campo-inform = "d-peso-quant-ltda" NO-LOCK NO-ERROR.

  IF NOT AVAIL reg-inf-compl THEN DO:
      RUN pi-criaRegInfCompl IN h-bodi538 (INPUT "item-dist",
                                           INPUT "d-peso-quant-ltda",
                                           INPUT "Peso Bruto Quantidade Limitada",
                                           INPUT 0,
                                           INPUT "x(17)",
                                           OUTPUT i-identif).
  END.
  ELSE
      ASSIGN i-identif = reg-inf-compl.cdn-identif.
      
  FOR FIRST inf-compl
      WHERE inf-compl.cdn-identif = i-identif
        AND inf-compl.cod-indice  = item-dist.it-codigo EXCLUSIVE-LOCK:
      ASSIGN inf-compl.des-campo = STRING(d-peso-quant-ltda:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
  END.

  IF NOT AVAIL inf-compl THEN DO:
      CREATE inf-compl.
      ASSIGN inf-compl.cdn-identif = i-identif
             inf-compl.cod-indice  = item-dist.it-codigo.
      ASSIGN inf-compl.des-campo = STRING(d-peso-quant-ltda:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

  END.
  RELEASE inf-compl.


  /*** Grava Peso Quantidade Limitada ***/

  /*** Grava Flag Quantidade Limitada ***/
  FIND FIRST reg-inf-compl
       WHERE reg-inf-compl.cod-tab-inform   = "item-dist"
       AND   reg-inf-compl.cod-campo-inform = "tb-quant-ltda" NO-LOCK NO-ERROR.

  IF NOT AVAIL reg-inf-compl THEN DO:
      RUN pi-criaRegInfCompl IN h-bodi538 (INPUT "item-dist",
                                           INPUT "tb-quant-ltda",
                                           INPUT "Quantidade Limitada",
                                           INPUT 0,
                                           INPUT "x(1)",
                                           OUTPUT i-identif).
  END.
  ELSE
      ASSIGN i-identif = reg-inf-compl.cdn-identif.
      
  FOR FIRST inf-compl
       WHERE inf-compl.cdn-identif = i-identif
         AND inf-compl.cod-indice  = item-dist.it-codigo EXCLUSIVE-LOCK:

       IF tb-quant-ltda:CHECKED IN FRAME {&FRAME-NAME} THEN
          ASSIGN inf-compl.des-campo = "S".
       ELSE
          ASSIGN inf-compl.des-campo = "".
  END.

  IF NOT AVAIL inf-compl THEN DO:
      CREATE inf-compl.
      ASSIGN inf-compl.cdn-identif = i-identif
             inf-compl.cod-indice  = item-dist.it-codigo.
      IF tb-quant-ltda:CHECKED IN FRAME {&FRAME-NAME} THEN
          ASSIGN inf-compl.des-campo = "S".
      ELSE
          ASSIGN inf-compl.des-campo = "".

  END.
  RELEASE inf-compl.

  
  /*** Grava Flag Quantidade Limitada ***/

  /*** Grava Nr Processo Suframa ***/
  FIND FIRST reg-inf-compl
       WHERE reg-inf-compl.cod-tab-inform   = "item-dist"
       AND   reg-inf-compl.cod-campo-inform = "c-Proc-Suframa" NO-LOCK NO-ERROR.

  IF NOT AVAIL reg-inf-compl THEN DO:
      RUN pi-criaRegInfCompl IN h-bodi538 (INPUT "item-dist",
                                           INPUT "c-Proc-Suframa",
                                           INPUT "Nr Processo Suframa",
                                           INPUT 0,
                                           INPUT "x(12)",
                                           OUTPUT i-identif).
  END.
  ELSE
      ASSIGN i-identif = reg-inf-compl.cdn-identif.

  FOR FIRST inf-compl
       WHERE inf-compl.cdn-identif = i-identif
         AND inf-compl.cod-indice  = item-dist.it-codigo EXCLUSIVE-LOCK:
      ASSIGN inf-compl.des-campo = c-Proc-Suframa:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  END.

  IF NOT AVAIL inf-compl THEN DO:
      CREATE inf-compl.
      ASSIGN inf-compl.cdn-identif = i-identif
             inf-compl.cod-indice  = item-dist.it-codigo
             inf-compl.des-campo   = c-Proc-Suframa:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  END.
  RELEASE inf-compl.

  /*** Grava Nr Processo Suframa ***/
  
  IF  VALID-HANDLE(h-bodi538) THEN DO:
      DELETE PROCEDURE h-bodi538.
      ASSIGN h-bodi538 = ?.
  END.

  IF AVAIL item-dist THEN
      ASSIGN OVERLAY(item-dist.char-2,1,20) = c-cod-embal :SCREEN-VALUE IN FRAME {&FRAME-NAME}
             OVERLAY(item-dist.char-2,33,13) = c-prodanvisa :SCREEN-VALUE IN FRAME {&FRAME-NAME}
             OVERLAY(item-dist.char-2,46,55) = c-motiv-isencao:SCREEN-VALUE IN FRAME {&FRAME-NAME}.          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  {utp/ut-liter.i "Inf. ONU"}                                          
  ASSIGN tx-Inf-Onu:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE). 
  {utp/ut-liter.i "Certificados"}                                          
  ASSIGN tx-certific:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE). 
  {utp/ut-liter.i "Medicamentos"}                                          
  ASSIGN tx-medic:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE). 
  {utp/ut-liter.i "Livre Com‚rcio / ZFM"}                                  
  ASSIGN tx-livre-comercio-zfm:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE). 

  DISABLE d-peso-quant-ltda
          tb-quant-ltda
          c-cod-embal
          c-prodanvisa 
          c-motiv-isencao
          c-Proc-Suframa
      WITH FRAME {&frame-name}.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  IF AVAIL item-dist THEN DO:

      ASSIGN c-Proc-Suframa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

      FOR FIRST reg-inf-compl NO-LOCK
          WHERE reg-inf-compl.cod-tab-inform   = "item-dist"
            AND reg-inf-compl.cod-campo-inform = "d-peso-quant-ltda",
          FIRST inf-compl NO-LOCK
          WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif
            AND inf-compl.cod-indice  = item-dist.it-codigo:

          ASSIGN d-peso-quant-ltda:SCREEN-VALUE IN FRAME {&FRAME-NAME} = inf-compl.des-campo.
      END.

      FOR FIRST reg-inf-compl NO-LOCK
          WHERE reg-inf-compl.cod-tab-inform   = "item-dist"
            AND reg-inf-compl.cod-campo-inform = "tb-quant-ltda",
          FIRST inf-compl NO-LOCK
          WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif
            AND inf-compl.cod-indice  = item-dist.it-codigo:

          IF inf-compl.des-campo = "S" THEN
              ASSIGN tb-quant-ltda:CHECKED IN FRAME {&FRAME-NAME} = YES.
          ELSE
              ASSIGN tb-quant-ltda:CHECKED IN FRAME {&FRAME-NAME} = NO.
      END.

      FOR FIRST reg-inf-compl NO-LOCK
          WHERE reg-inf-compl.cod-tab-inform   = "item-dist"
            AND reg-inf-compl.cod-campo-inform = "c-Proc-Suframa",
          FIRST inf-compl NO-LOCK
          WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif
            AND inf-compl.cod-indice  = item-dist.it-codigo:

          ASSIGN c-Proc-Suframa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = inf-compl.des-campo.
      END.
      
      ASSIGN c-cod-embal:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(item-dist.char-2,1,20)
             c-prodanvisa :SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTR(item-dist.char-2,33,13)
             c-motiv-isencao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = substr(item-dist.char-2,46,55).          

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

    ENABLE d-peso-quant-ltda
           tb-quant-ltda
            c-cod-embal
            c-prodanvisa 
            c-motiv-isencao
            c-Proc-Suframa
      WITH FRAME {&frame-name}.

    RUN GET-ATTRIBUTE ('adm-new-record').
    
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ). 

   &if  defined(ADM-MODIFY-FIELDS) &then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
   &endif 

  {utp/ut-liter.i "Inf. ONU"}
  assign tx-Inf-Onu:screen-value in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i "Certificados"}                                          
  ASSIGN tx-certific:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE). 
  {utp/ut-liter.i "Medicamentos"}                                          
  ASSIGN tx-medic:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE). 
  {utp/ut-liter.i "Livre Com‚rcio / ZFM"}                                  
  ASSIGN tx-livre-comercio-zfm:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE). 

  IF  c-prodanvisa :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Isento" THEN
         ENABLE c-motiv-isencao WITH FRAME {&FRAME-NAME}.
     ELSE 
         DISABLE c-motiv-isencao WITH FRAME {&FRAME-NAME}.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  DISABLE d-peso-quant-ltda
          tb-quant-ltda
          c-cod-embal
          c-prodanvisa 
          c-motiv-isencao
          c-Proc-Suframa
      WITH FRAME {&frame-name}.

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
    
    RUN Who-Is-The-Container IN adm-broker-hdl
        (INPUT THIS-PROCEDURE, OUTPUT c-handle).
    ASSIGN wh-cd0903 = WIDGET-HANDLE(c-handle).
        
    IF INPUT FRAME {&FRAME-NAME} item-dist.cdn-onu <> 0 AND 
       INPUT FRAME {&FRAME-NAME} item-dist.cod-class-risco = "" THEN DO:
                            
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 54077,
                           INPUT '').
        
        RUN select-page IN wh-cd0903 (6).        
        APPLY "entry" TO item-dist.cdn-onu.        
        RETURN "adm-error":U.
    
    END.

    IF c-prodanvisa :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Isenta" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 57482,
                           INPUT '').
        
        RUN select-page IN wh-cd0903 (6).        
        APPLY "entry" TO c-prodanvisa.        
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
  {src/adm/template/snd-list.i "item"}
  {src/adm/template/snd-list.i "item-dist"}

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

