&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmfg            PROGRESS
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
{include/i-prgvrs.i V01IN318 2.00.01.005}  /*** 010105 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN318 MUT}
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

def new global shared var gr-pl-prod as rowid no-undo.
DEF NEW GLOBAL SHARED VAR i-cd-plano AS INT NO-UNDO.
def new global shared var c-dt-per-ini-inv-pl0701 as char.
def new global shared var c-dt-per-fim-inv-pl0701 as char.

{cdp/cdcfgman.i}

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
&Scoped-define EXTERNAL-TABLES pl-prod
&Scoped-define FIRST-EXTERNAL-TABLE pl-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR pl-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS pl-prod.cd-plano pl-prod.descricao ~
pl-prod.tipo-plano pl-prod.pl-estado pl-prod.cd-tipo pl-prod.log-1 ~
pl-prod.horiz-fixo pl-prod.nr-dias-seg 
&Scoped-define ENABLED-TABLES pl-prod
&Scoped-define FIRST-ENABLED-TABLE pl-prod
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS pl-prod.cd-plano pl-prod.descricao ~
pl-prod.tipo-plano pl-prod.pl-estado pl-prod.cd-tipo pl-prod.log-1 ~
pl-prod.quant-confirm pl-prod.horiz-fixo pl-prod.nr-dias-seg 
&Scoped-define DISPLAYED-TABLES pl-prod
&Scoped-define FIRST-DISPLAYED-TABLE pl-prod
&Scoped-Define DISPLAYED-OBJECTS c-desc-tipo i-nr-dia c-dt-per-ini ~
da-dt-ini-per-i da-dt-fim-per-i tb-multi-estabel c-dt-per-fim ~
da-dt-ini-per-f da-dt-fim-per-f tb-aloca-saldo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS c-dt-per-ini c-dt-per-fim 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
cd-plano|y|y|mgmfg.pl-prod.cd-plano
usuario||y|mgmfg.pl-prod.usuario
cd-tipo||y|mgmfg.pl-prod.cd-tipo
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "cd-plano",
     Keys-Supplied = "cd-plano,usuario,cd-tipo"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-desc-tipo AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-dt-per-fim AS CHARACTER FORMAT "999/9999":U 
     LABEL "Per Fim" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-dt-per-ini AS CHARACTER FORMAT "999/9999":U 
     LABEL "Per Ini" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-fim-per-f AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-fim-per-i AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-ini-per-f AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-ini-per-i AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-dia AS INTEGER FORMAT ">>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 5.71.

DEFINE VARIABLE tb-aloca-saldo AS LOGICAL INITIAL no 
     LABEL "Disponibiliza Aloca‡Æo Saldo" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83.

DEFINE VARIABLE tb-multi-estabel AS LOGICAL INITIAL no 
     LABEL "Considera Multi-Estabelecimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     pl-prod.cd-plano AT ROW 1.21 COL 15.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     pl-prod.descricao AT ROW 1.25 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     pl-prod.tipo-plano AT ROW 1.25 COL 53.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     pl-prod.pl-estado AT ROW 1.25 COL 61 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Ativo", 1,
"Inativo", 2
          SIZE 18.29 BY .88
     pl-prod.cd-tipo AT ROW 2.17 COL 15.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     c-desc-tipo AT ROW 2.17 COL 21 COLON-ALIGNED NO-LABEL
     i-nr-dia AT ROW 2.21 COL 42.72 COLON-ALIGNED NO-LABEL
     pl-prod.log-1 AT ROW 2.25 COL 50.72
          VIEW-AS TOGGLE-BOX
          SIZE 22.14 BY .83
     c-dt-per-ini AT ROW 3.21 COL 15.72 COLON-ALIGNED
     da-dt-ini-per-i AT ROW 3.21 COL 27.14 COLON-ALIGNED NO-LABEL
     da-dt-fim-per-i AT ROW 3.21 COL 41.86 COLON-ALIGNED NO-LABEL
     pl-prod.quant-confirm AT ROW 3.21 COL 61
          VIEW-AS TOGGLE-BOX
          SIZE 25.57 BY .83
     tb-multi-estabel AT ROW 4 COL 61
     c-dt-per-fim AT ROW 4.21 COL 15.72 COLON-ALIGNED
     da-dt-ini-per-f AT ROW 4.21 COL 27.14 COLON-ALIGNED NO-LABEL
     da-dt-fim-per-f AT ROW 4.21 COL 41.86 COLON-ALIGNED NO-LABEL
     tb-aloca-saldo AT ROW 4.75 COL 61 WIDGET-ID 2
     pl-prod.horiz-fixo AT ROW 5.21 COL 15.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     pl-prod.nr-dias-seg AT ROW 5.21 COL 41.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgmfg.pl-prod
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
         HEIGHT             = 5.71
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-tipo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-dt-per-fim IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-dt-per-ini IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN da-dt-fim-per-f IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-dt-fim-per-i IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-dt-ini-per-f IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-dt-ini-per-i IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-nr-dia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX pl-prod.quant-confirm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-aloca-saldo IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       tb-aloca-saldo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tb-multi-estabel IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       tb-multi-estabel:HIDDEN IN FRAME f-main           = TRUE.

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

   {utp/ut-liter.i Per¡odo_Ini * L}
   assign c-dt-per-ini:label in frame {&frame-name} = return-value.
   {utp/ut-liter.i Per¡odo_Fim * L}
   assign c-dt-per-fim:label in frame {&frame-name} = return-value.
   {utp/ut-liter.i Necessidades_Brutas * L}
   assign pl-prod.log-1:label in frame {&frame-name} = return-value.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.
  DEF VAR row-avail-enabled AS LOGICAL NO-UNDO.

  /* LOCK status on the find depends on FIELDS-ENABLED. */
  RUN get-attribute ('FIELDS-ENABLED':U).
  row-avail-enabled = (RETURN-VALUE eq 'yes':U).
  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'cd-plano':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = pl-prod
           &WHERE = "WHERE pl-prod.cd-plano eq INTEGER(key-value)"
       }
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "pl-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "pl-prod"}

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

   if avail pl-prod then do:
      find tipo-per 
         where tipo-per.cd-tipo = pl-prod.cd-tipo 
         no-lock no-error.
      assign c-desc-tipo = if avail tipo-per then tipo-per.descricao else "".
      assign i-nr-dia    = if avail tipo-per then tipo-per.nr-dia else 0.  

      assign c-dt-per-ini = string(pl-prod.nr-per-ini,"999") + string(pl-prod.ano-per-ini,"9999")
             c-dt-per-fim = string(pl-prod.nr-per-fim,"999") + string(pl-prod.ano-per-fim,"9999")
             i-cd-plano   = pl-prod.cd-plano.
      
   
   assign tb-multi-estabel = pl-prod.log-multi-estabel
          tb-multi-estabel:hidden in frame {&frame-name} = no
          tb-aloca-saldo   = pl-prod.log-dispon-aloc-saldo
          tb-aloca-saldo:hidden in frame {&frame-name} = no.
   


      find first periodo
         where periodo.cd-tipo = pl-prod.cd-tipo
           and periodo.nr-periodo = pl-prod.nr-per-ini
           and periodo.ano        = pl-prod.ano-per-ini
         no-lock no-error.
      if avail periodo then do:
         assign da-dt-ini-per-i = periodo.dt-inicio
                da-dt-fim-per-i = periodo.dt-termino.
      end.
      find first periodo
         where periodo.cd-tipo = pl-prod.cd-tipo
           and periodo.nr-periodo = pl-prod.nr-per-fim
           and periodo.ano        = pl-prod.ano-per-fim
         no-lock no-error.
      if avail periodo then do:
         assign da-dt-ini-per-f = periodo.dt-inicio
                da-dt-fim-per-f = periodo.dt-termino.
      end.
   end.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

   if avail pl-prod then do:
      assign c-dt-per-fim-inv-pl0701 = (string(pl-prod.ano-per-fim,"9999") + 
                                        string(pl-prod.nr-per-fim,"999"))
             c-dt-per-ini-inv-pl0701 = (string(pl-prod.ano-per-ini,"9999") + 
                                        string(pl-prod.nr-per-ini,"999")).
                                    
      assign gr-pl-prod = rowid(pl-prod).
   end.

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
  
  /* Ponha aqui a valida‡Æo de chave duplicada */
  
  /* Ponha aqui as demais valida‡äes */
  
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "cd-plano" "pl-prod" "cd-plano"}
  {src/adm/template/sndkycas.i "usuario" "pl-prod" "usuario"}
  {src/adm/template/sndkycas.i "cd-tipo" "pl-prod" "cd-tipo"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "pl-prod"}

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

