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
{include/i-prgvrs.i V33IN172 2.00.00.009 } /*** "010009" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V33IN172 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

    DEF VAR h-cdCfgFiscal-local     AS  HANDLE      NO-UNDO.
    DEF VAR l-cfg-trib-1            AS  LOGICAL     NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS item.class-fiscal item.ind-ipi-dife ~
item.aliquota-ISS item.aliquota-ipi item.niv-rest-icms item.per-rest-icms ~
item.cod-servico 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-FIELDS item.class-fiscal item.ind-ipi-dife ~
item.aliquota-ISS item.aliquota-ipi item.niv-rest-icms item.per-rest-icms ~
item.cod-servico 
&Scoped-Define DISPLAYED-OBJECTS c-cd-trib-iss c-cd-trib-ipi i-aliq-pis ~
c-op-susp-ipi i-red-pis c-orig-aliq-pis i-aliq-cofins c-cd-trib-icm ~
i-red-cofins c-orig-aliq-cofins c-cod-sefazsp l-combust c-cod-clas-fisc 

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
DEFINE VARIABLE c-cd-trib-icm AS CHARACTER FORMAT "X(20)":U 
     LABEL "c-cd-trib-icm" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cd-trib-ipi AS CHARACTER FORMAT "X(20)":U 
     LABEL "c-cd-trib-ipi" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cd-trib-iss AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-clas-fisc AS CHARACTER FORMAT "X(50)":U 
     LABEL "Classe Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.
DEFINE VARIABLE c-cod-sefazsp AS int FORMAT ">>>9":U 
     LABEL "C¢digo SEFAZ - SP" 
     VIEW-AS FILL-IN 
     SIZE 7.29 BY .88 NO-UNDO.
DEFINE VARIABLE c-op-susp-ipi AS CHARACTER FORMAT "X(256)":U 
     LABEL "Optante Suspens∆o IPI" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-orig-aliq-cofins AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-orig-aliq-pis AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-aliq-cofins AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88 NO-UNDO.

DEFINE VARIABLE i-aliq-pis AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88 NO-UNDO.

DEFINE VARIABLE i-red-cofins AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88 NO-UNDO.

DEFINE VARIABLE i-red-pis AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88 NO-UNDO.

DEFINE VARIABLE l-combust AS LOGICAL INITIAL no 
     LABEL "Combust°vel / Solvente" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.class-fiscal AT ROW 1.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     item.ind-ipi-dife AT ROW 2.17 COL 24
          VIEW-AS TOGGLE-BOX
          SIZE 29.43 BY .75
     item.aliquota-ISS AT ROW 2.17 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     item.aliquota-ipi AT ROW 3.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     c-cd-trib-iss AT ROW 3.17 COL 61 COLON-ALIGNED
     c-cd-trib-ipi AT ROW 4.17 COL 22 COLON-ALIGNED
     i-aliq-pis AT ROW 4.17 COL 61 COLON-ALIGNED
     c-op-susp-ipi AT ROW 5.17 COL 22 COLON-ALIGNED
     i-red-pis AT ROW 5.17 COL 61 COLON-ALIGNED
     item.niv-rest-icms AT ROW 6.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     c-orig-aliq-pis AT ROW 6.17 COL 61 COLON-ALIGNED
     item.per-rest-icms AT ROW 7.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     i-aliq-cofins AT ROW 7.17 COL 61 COLON-ALIGNED
     c-cd-trib-icm AT ROW 8.17 COL 22 COLON-ALIGNED
     i-red-cofins AT ROW 8.17 COL 61 COLON-ALIGNED
     item.cod-servico AT ROW 9.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-orig-aliq-cofins AT ROW 9.17 COL 61 COLON-ALIGNED
     c-cod-sefazsp AT ROW 10.17 COL 22 COLON-ALIGNED
     l-combust AT ROW 10.17 COL 61
     c-cod-clas-fisc AT ROW 11.25 COL 22 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


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
         HEIGHT             = 11.25
         WIDTH              = 86.86.
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
       FRAME f-main:HEIGHT           = 11.25
       FRAME f-main:WIDTH            = 86.86.

/* SETTINGS FOR FILL-IN c-cd-trib-icm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cd-trib-ipi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cd-trib-iss IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-clas-fisc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-sefazsp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-op-susp-ipi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-orig-aliq-cofins IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-orig-aliq-pis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-aliq-cofins IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-aliq-pis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-red-cofins IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-red-pis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-combust IN FRAME f-main
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

  {utp/ut-field.i mgind item cd-trib-ipi 1}.
  assign c-cd-trib-ipi:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind item cd-trib-icm 1}.
  assign c-cd-trib-icm:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind item cd-trib-iss 1}.
  assign c-cd-trib-iss:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Al°quota_PIS * L}
  assign i-aliq-pis:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Al°quota_COFINS * L}
  assign i-aliq-cofins:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Reduá∆o_PIS * L}
  assign i-red-pis:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Reduá∆o_COFINS * L}
  assign i-red-cofins:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Optante_Suspens∆o_IPI * L}
  assign c-op-susp-ipi:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Origem_Al°quota_PIS * L}
  assign c-orig-aliq-pis:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Origem_Al°quota_COFINS * L}
  assign c-orig-aliq-cofins:label in frame {&frame-name} = trim(return-value).

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

  /* Traz a descricao dos Radio-sets cd-trib-ipi,cd-trib-icm,cd-trib-iss */ 
  if avail item then do with frame {&frame-name}:
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao001 = {ininc/i10in172.i 04 item.cd-trib-ipi}.
         run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                             INPUT "",
                             INPUT "").
         ASSIGN  c-cd-trib-ipi:screen-value = RETURN-VALUE.
     &else
         ASSIGN c-cd-trib-ipi:screen-value = {ininc/i10in172.i 04 item.cd-trib-ipi}.
     &endif
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao002 = {ininc/i07in122.i 04 item.cd-trib-icm}.
         run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                             INPUT "",
                             INPUT "").
         ASSIGN  c-cd-trib-icm:screen-value = RETURN-VALUE.
     &else
         ASSIGN c-cd-trib-icm:screen-value = {ininc/i07in122.i 04 item.cd-trib-icm}.
     &endif
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao003 = {ininc/i11in172.i 04 item.cd-trib-iss}.
         run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao003)," ","_"),
                             INPUT "",
                             INPUT "").
         ASSIGN  c-cd-trib-iss:screen-value = RETURN-VALUE.
     &else
         ASSIGN c-cd-trib-iss:screen-value = {ininc/i11in172.i 04 item.cd-trib-iss}.
     &endif
     /*Atualizaá‰es dos campos PIS/COFINS*/
     assign i-aliq-pis:screen-value         = substring(item.char-2,31,5)
            i-aliq-cofins:screen-value      = substring(item.char-2,36,5)
            i-red-pis:screen-value          = substring(item.char-2,41,5)
            i-red-cofins:screen-value       = substring(item.char-2,46,5)
            c-op-susp-ipi:screen-value      = if substring(item.char-2,51,1) = "1" then "N∆o"  else "Sim"
            c-orig-aliq-pis:screen-value    = if substring(item.char-2,52,1) = "1" then "Item" else "Natureza"
            c-orig-aliq-cofins:screen-value = if substring(item.char-2,53,1) = "1" then "Item" else "Natureza".
     &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
         find first item-dist NO-LOCK where item-dist.it-codigo = item.it-codigo no-error.
         assign c-cod-sefazsp:screen-value = string(item-dist.cdn-sefazsp) 
                l-combust:CHECKED          = item-dist.log-combust.
     &else
         assign c-cod-sefazsp:screen-value = substr(item.char-1,254,4)
                l-combust:CHECKED          = IF substr(item.char-1,258,1) = "1" THEN YES ELSE NO.
     &endif
  end.
  else do:
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao004 = {ininc/i10in172.i 04 1}.
         run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao004)," ","_"),
                             INPUT "",
                             INPUT "").
         ASSIGN  c-cd-trib-ipi:screen-value = RETURN-VALUE. 
     &else
         ASSIGN c-cd-trib-ipi:screen-value = {ininc/i10in172.i 04 1}.
     &endif
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao005 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao005 = {ininc/i07in122.i 04 1}.
         run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao005)," ","_"),
                             INPUT "",
                             INPUT "").
         ASSIGN  c-cd-trib-icm:screen-value = RETURN-VALUE. 
     &else
         ASSIGN c-cd-trib-icm:screen-value = {ininc/i07in122.i 04 1}.
     &endif
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao006 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao006 = {ininc/i11in172.i 04 1}.
         run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao006)," ","_"),
                             INPUT "",
                             INPUT "").
         ASSIGN  c-cd-trib-iss:screen-value = RETURN-VALUE. 
     &else
         ASSIGN c-cd-trib-iss:screen-value = {ininc/i11in172.i 04 1}.
     &endif
  end.       

  FIND FIRST ct-clas-item 
      WHERE  ct-clas-item.cod-item = ITEM.it-codigo NO-LOCK NO-ERROR.

  IF AVAIL ct-clas-item THEN DO:
      ASSIGN c-cod-clas-fisc:SCREEN-VALUE = ct-clas-item.cod-clas-fisc.
  END.
  ELSE DO:
      ASSIGN c-cod-clas-fisc:SCREEN-VALUE = "".
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
/* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

   /* Code placed here will execute AFTER standard behavior.    */

    /* configurador de tributos */
    IF  NOT l-cfg-trib-1 THEN
        ASSIGN c-cod-clas-fisc:HIDDEN IN FRAME {&FRAME-NAME} = YES.

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a validaá∆o de chave duplicada */

  /* Ponha aqui as demais validaá‰es */

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

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

    DEF INPUT PARAMETER p-c-nome-var    AS CHAR     NO-UNDO.
    DEF INPUT PARAMETER p-h-handle      AS  HANDLE  NO-UNDO.

    CASE p-c-nome-var:
        WHEN "h-cdCfgFiscal-local" THEN ASSIGN h-cdCfgFiscal-local = p-h-handle.
    END CASE.

    /* configurador de tributos */

    IF  VALID-HANDLE(h-cdCfgFiscal-local) THEN DO:
        RUN pi-retorna-status IN h-cdCfgFiscal-local ("cfg-trib", 1).
        IF  RETURN-VALUE = "OK":U THEN
            ASSIGN l-cfg-trib-1 = YES.
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

