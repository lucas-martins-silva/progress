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
{include/i-prgvrs.i V08IN046 2.00.00.023 } /*** "010023" 06/05/2026 17:36:48  ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v08in046 MUT}
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
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{cdp/cd9990.i1}
{cdp/cd4000.i}
{cdp/cdcfgmat.i}

define workfile w-pedido field nome-abrev like ped-venda.nome-abrev
                         field nr-pedcli  like ped-venda.nr-pedcli.
define VAR de-aliquota-pis-old    as DECIMAL FORMAT ">9.9999".
define VAR de-reducao-pis-old     as decimal.
define VAR de-aliquota-cofins-old as DECIMAL FORMAT ">9.9999".
define VAR de-reducao-cofins-old  as decimal.
define VAR l-susp-ipi-old         as LOG.
define var wh-cd0603              as handle no-undo.    
define var c-cd0603               as char   no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE de-val-pis-externo-old    AS DECIMAL NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE de-val-cofins-externo-old AS DECIMAL NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-atualizou-valores-ext   AS LOGICAL NO-UNDO.

/* Integracao Modulo Importacao */
def var l-modulo-imp   as logical                 no-undo.

/* Implanta‡Æo de L¢gica PIS/COFINS - 4 casas decimais */
DEFINE VARIABLE h-cdapi995     AS HANDLE          NO-UNDO.
DEFINE VARIABLE h-cdcfgfiscal  AS HANDLE          NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES classif-fisc
&Scoped-define FIRST-EXTERNAL-TABLE classif-fisc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR classif-fisc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS classif-fisc.dec-1 classif-fisc.dec-2 
&Scoped-define ENABLED-TABLES classif-fisc
&Scoped-define FIRST-ENABLED-TABLE classif-fisc
&Scoped-define DISPLAYED-TABLES classif-fisc
&Scoped-define FIRST-DISPLAYED-TABLE classif-fisc
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 RECT-4 
&Scoped-Define DISPLAYED-FIELDS classif-fisc.dec-1 classif-fisc.dec-2 
&Scoped-Define DISPLAYED-OBJECTS tg-pis-cofins-st de-red-pis ~
de-val-pis-externo de-aliquota-pis-acresc de-red-cofins ~
de-val-cofins-externo de-aliquota-cofins-acresc 

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
DEFINE VARIABLE de-aliquota-cofins-acresc AS DECIMAL FORMAT ">>9.9999":U INITIAL 0 
     LABEL "Aliquota Majorada" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliquota-pis-acresc AS DECIMAL FORMAT ">>9.9999":U INITIAL 0 
     LABEL "Aliquota Majorada" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-red-cofins AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "% Redu‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-red-pis AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "% Redu‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-cofins-externo AS DECIMAL FORMAT ">>9.9999":U INITIAL 0 
     LABEL "% Externo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-pis-externo AS DECIMAL FORMAT ">>9.9999":U INITIAL 0 
     LABEL "% Externo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 2.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 2.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 2.63.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 2.63.

DEFINE VARIABLE tg-pis-cofins-st AS LOGICAL INITIAL no 
     LABEL "Considera PIS/COFINS ST na EFD Contribui‡äes" 
     VIEW-AS TOGGLE-BOX
     SIZE 47 BY .83 NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tg-pis-cofins-st AT ROW 7.46 COL 7.14 WIDGET-ID 2
     classif-fisc.dec-1 AT ROW 1.75 COL 23.72 COLON-ALIGNED HELP
          ""
          LABEL "Aliquota" FORMAT ">9.9999"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     de-red-pis AT ROW 2.75 COL 23.72 COLON-ALIGNED
     de-val-pis-externo AT ROW 5.08 COL 23.72 COLON-ALIGNED
     de-aliquota-pis-acresc AT ROW 6.08 COL 23.72 COLON-ALIGNED
     classif-fisc.dec-2 AT ROW 1.71 COL 62 COLON-ALIGNED HELP
          ""
          LABEL "Aliquota" FORMAT ">9.9999"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     de-red-cofins AT ROW 2.71 COL 62 COLON-ALIGNED
     de-val-cofins-externo AT ROW 5.08 COL 62 COLON-ALIGNED
     de-aliquota-cofins-acresc AT ROW 6.08 COL 62 COLON-ALIGNED
     "PIS Importa‡Æo" VIEW-AS TEXT
          SIZE 15 BY .75 AT ROW 4.29 COL 9
     "PIS" VIEW-AS TEXT
          SIZE 4 BY .75 AT ROW 1.17 COL 9
     "COFINS" VIEW-AS TEXT
          SIZE 8 BY .75 AT ROW 1.17 COL 48
     "COFINS Importa‡Æo" VIEW-AS TEXT
          SIZE 19 BY .75 AT ROW 4.29 COL 48
     RECT-1 AT ROW 1.5 COL 7
     RECT-2 AT ROW 1.5 COL 46
     RECT-3 AT ROW 4.63 COL 7
     RECT-4 AT ROW 4.63 COL 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.classif-fisc
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
         HEIGHT             = 7.67
         WIDTH              = 88.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R,COLUMNS                    */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN de-aliquota-cofins-acresc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-aliquota-pis-acresc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-red-cofins IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-red-pis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-cofins-externo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-pis-externo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN classif-fisc.dec-1 IN FRAME f-main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN classif-fisc.dec-2 IN FRAME f-main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR TOGGLE-BOX tg-pis-cofins-st IN FRAME f-main
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
  {src/adm/template/row-list.i "classif-fisc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "classif-fisc"}

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
  IF VALID-HANDLE(h-cdapi995) THEN DO:
      RUN pi-finalizar in h-cdapi995.
      ASSIGN h-cdapi995 = ?.
  END.

  IF VALID-HANDLE(h-cdcfgfiscal) THEN DO:
      DELETE PROCEDURE h-cdcfgfiscal.
      ASSIGN h-cdcfgfiscal = ?.
  END.

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

  ASSIGN de-val-pis-externo:SCREEN-VALUE IN FRAME {&FRAME-NAME}        = "0":U
         de-aliquota-pis-acresc:screen-value in frame {&frame-name}    = "0":U
         de-val-cofins-externo:SCREEN-VALUE IN FRAME {&FRAME-NAME}     = "0":U
         de-aliquota-cofins-acresc:screen-value in frame {&frame-name} = "0":U
         tg-pis-cofins-st:CHECKED IN FRAME {&frame-name} = NO.

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

  run who-is-the-container in adm-broker-hdl (input this-procedure, output c-cd0603).
  assign wh-cd0603 = widget-handle(c-cd0603).

  IF  AVAIL classif-fisc THEN DO:

      ASSIGN de-aliquota-pis-old     = classif-fisc.dec-1
             de-aliquota-cofins-old  = classif-fisc.dec-2
             de-reducao-pis-old      = classif-fisc.int-1 / 100
             de-reducao-cofins-old   = classif-fisc.int-2 / 100
             l-susp-ipi-old          = classif-fisc.log-1
             l-atualizou-valores-ext = YES.

      &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
      IF DEC(SUBSTR(classif-fisc.char-1,85,9)) <> 0 THEN /* PIS com 4 decimais */
          ASSIGN de-val-pis-externo-old = DEC(SUBSTR(classif-fisc.char-1,85,9)).
      ELSE
          ASSIGN de-val-pis-externo-old = classif-fisc.val-aliq-ext-pis.
          
      IF DEC(SUBSTR(classif-fisc.char-1,94,9)) <> 0 THEN /* COFINS com 4 decimais */
          ASSIGN de-val-cofins-externo-old = DEC(SUBSTR(classif-fisc.char-1,94,9)).
      ELSE
          ASSIGN de-val-cofins-externo-old = classif-fisc.val-aliq-ext-cofins.
      &ELSE
          ASSIGN de-val-pis-externo-old    = DECIMAL(SUBSTRING(classif-fisc.char-1,31,06))
                 de-val-cofins-externo-old = DECIMAL(SUBSTRING(classif-fisc.char-1,37,06)).
      &ENDIF
  END.

  ASSIGN INPUT FRAME {&FRAME-NAME} de-red-pis
         INPUT FRAME {&FRAME-NAME} de-red-cofins
         INPUT FRAME {&FRAME-NAME} de-val-pis-externo
         INPUT FRAME {&FRAME-NAME} de-aliquota-pis-acresc
         INPUT FRAME {&FRAME-NAME} de-val-cofins-externo
         input frame {&frame-name} de-aliquota-cofins-acresc.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
    RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN classif-fisc.int-1 = TRUNC(DEC(de-red-pis:SCREEN-VALUE    IN FRAME {&frame-name}) * 100,0)
         classif-fisc.int-2 = TRUNC(DEC(de-red-cofins:SCREEN-VALUE IN FRAME {&frame-name}) * 100,0).

  &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
      ASSIGN classif-fisc.val-aliq-ext-pis     = de-val-pis-externo
             classif-fisc.val-aliq-ext-cofins  = de-val-cofins-externo
             OVERLAY(classif-fisc.char-1,85,9) = STRING(de-val-pis-externo)
             OVERLAY(classif-fisc.char-1,94,9) = STRING(de-val-cofins-externo).
  &ELSE
      ASSIGN OVERLAY(classif-fisc.char-1,31,06) = STRING(de-val-pis-externo)
             OVERLAY(classif-fisc.char-1,37,06) = STRING(de-val-cofins-externo).
  &ENDIF
   
  &if '{&bf_mat_versao_ems}' >= '2.09' &then
    assign classif-fisc.aliquota-cofins-acresc = de-aliquota-cofins-acresc
           classif-fisc.val-aliq-pis-acresc    = de-aliquota-pis-acresc.
  &else
    overlay(classif-fisc.char-1,56,9) = string(de-aliquota-cofins-acresc).
    OVERLAY(classif-fisc.char-1,65,9) = string(de-aliquota-pis-acresc).      
  &endif

  assign classif-fisc.dec-1 /*Aliquota PIS*/
         classif-fisc.dec-2. /*Aliquota COFINS*/

  /*Campo considera PIS/COFINS ST na EFD Contribui‡äes */
  IF tg-pis-cofins-st:CHECKED IN FRAME {&frame-name} = YES THEN
      OVERLAY(classif-fisc.char-1,83,1) = "1".
  ELSE OVERLAY(classif-fisc.char-1,83,1) = "0".
  
  RUN grava-aliquotas IN h-cdapi995 (INPUT "classif-fisc",
                                     INPUT classif-fisc.class-fiscal,
                                     INPUT classif-fisc.dec-1,
                                     INPUT classif-fisc.dec-2).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

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
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  DISABLE de-red-pis
          de-red-cofins
          de-val-pis-externo
          de-aliquota-pis-acresc
          de-val-cofins-externo
          de-aliquota-cofins-acresc
          tg-pis-cofins-st
          WITH FRAME {&FRAME-NAME}.

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

  IF NOT adm-new-record THEN DO:
      ASSIGN de-red-pis:SCREEN-VALUE    IN FRAME {&frame-name} = STRING(classif-fisc.int-1 / 100, ">9.99":U)
             de-red-cofins:SCREEN-VALUE IN FRAME {&frame-name} = STRING(classif-fisc.int-2 / 100, ">9.99":U) NO-ERROR.

      &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
      IF DEC(SUBSTR(classif-fisc.char-1,85,9)) <> 0 THEN
          ASSIGN de-val-pis-externo:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = STRING(DEC(SUBSTR(classif-fisc.char-1,85,9)),">>9.9999":U) NO-ERROR.
      ELSE
          ASSIGN de-val-pis-externo:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = STRING(classif-fisc.val-aliq-ext-pis,    ">>9.9999":U) NO-ERROR.
          
      IF DEC(SUBSTR(classif-fisc.char-1,94,9)) <> 0 THEN
          ASSIGN de-val-cofins-externo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(DEC(SUBSTR(classif-fisc.char-1,94,9)),">>9.9999":U) NO-ERROR.
      ELSE
          ASSIGN de-val-cofins-externo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(classif-fisc.val-aliq-ext-cofins, ">>9.9999":U) NO-ERROR.
      &ELSE
          ASSIGN de-val-pis-externo:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = STRING(DEC(SUBSTRING(classif-fisc.char-1,31,06)), ">>9.99":U)
                 de-val-cofins-externo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(DEC(SUBSTRING(classif-fisc.char-1,37,06)), ">>9.99":U) NO-ERROR.
      &ENDIF
      
      &if '{&bf_mat_versao_ems}' >= '2.09' &then
        assign de-aliquota-cofins-acresc:screen-value in frame {&frame-name} = string(classif-fisc.aliquota-cofins-acresc,">>9.9999":U)
               de-aliquota-pis-acresc:screen-value in frame {&frame-name}    = string(classif-fisc.val-aliq-pis-acresc,">>9.9999":U).
      &else
        assign de-aliquota-cofins-acresc:screen-value in frame {&frame-name} = string(dec(substring(classif-fisc.char-1,56,9)),">>9.9999":U) 
               de-aliquota-pis-acresc:screen-value in frame {&frame-name}    = string(dec(substring(classif-fisc.char-1,65,9)),">>9.9999":U) NO-ERROR.
      &endif
      
      /*Campo considera PIS/COFINS ST na EFD Contribui‡äes */
      IF SUBSTRING(classif-fisc.char-1,83,1) = "1" THEN
          ASSIGN tg-pis-cofins-st:CHECKED IN FRAME {&frame-name} = YES.
      ELSE ASSIGN tg-pis-cofins-st:CHECKED IN FRAME {&frame-name} = NO.

  END.

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
  /* Dispatch standard ADM method. 

  run get-attribute ('adm-new-record').
                              */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  ENABLE de-red-pis 
         de-red-cofins 
         de-aliquota-pis-acresc 
         de-aliquota-cofins-acresc 
         tg-pis-cofins-st WITH FRAME {&FRAME-NAME}.

  FIND FIRST param-global NO-LOCK NO-ERROR.

  IF  AVAIL param-global     AND
      param-global.modulo-07 THEN
      ASSIGN l-modulo-imp = YES.
  ELSE
      ASSIGN l-modulo-imp = NO.

  IF  l-modulo-imp THEN
      ENABLE de-val-pis-externo
             de-val-cofins-externo WITH FRAME {&FRAME-NAME}.

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
  
  IF NOT VALID-HANDLE (h-cdapi995) THEN
      RUN cdp\cdapi995.p PERSISTENT SET h-cdapi995.

  IF NOT VALID-HANDLE(h-cdcfgfiscal) THEN
      RUN cdp/cdcfgfiscal.p PERSISTENT SET h-cdcfgfiscal.

  RUN pi-retorna-status IN h-cdcfgfiscal ("decimais-pis-cofins", 01).

  IF RETURN-VALUE <> "OK":U THEN
      ASSIGN classif-fisc.dec-1:FORMAT IN FRAME {&FRAME-NAME} = ">9.99"
             classif-fisc.dec-2:FORMAT IN FRAME {&FRAME-NAME} = ">9.99".
  
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Integracao Modulo Importacao */
  find first param-global no-lock no-error.
  if avail param-global and param-global.modulo-07 then 
    assign l-modulo-imp                             = yes.

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "classif-fisc"}

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

