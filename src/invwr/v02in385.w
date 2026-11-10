&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
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
{include/i-prgvrs.i V02IN385 2.00.00.024} /*** "010024" 18/06/2025 09:41:36 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v02in385 MUT}
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

def new global shared var c-usuario-aux as char no-undo.
def new global shared var gr-requisicao as rowid no-undo.
def new global shared var gr-usuar-mater as rowid no-undo.
def var r-requisicao as rowid no-undo.
def var r-it-requisicao as rowid no-undo.

def buffer b-requisicao for requisicao.
def buffer b-it-requisicao for it-requisicao.

def var i-tipo-doc as integer no-undo.

def var c-lista-situacao as character no-undo.
def var c-lista-estado   as character no-undo.

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
&Scoped-define EXTERNAL-TABLES requisicao
&Scoped-define FIRST-EXTERNAL-TABLE requisicao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR requisicao.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS requisicao.nr-requisicao ~
requisicao.nome-abrev 
&Scoped-define ENABLED-TABLES requisicao
&Scoped-define FIRST-ENABLED-TABLE requisicao
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS requisicao.nr-requisicao ~
requisicao.nome-abrev 
&Scoped-define DISPLAYED-TABLES requisicao
&Scoped-define FIRST-DISPLAYED-TABLE requisicao
&Scoped-Define DISPLAYED-OBJECTS c-estado c-situacao c-requisitante 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS requisicao.nr-requisicao ~
requisicao.nome-abrev 

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
DEFINE VARIABLE c-estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-requisitante AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 2.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     requisicao.nr-requisicao AT ROW 1.21 COL 20.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-estado AT ROW 1.21 COL 38.14 COLON-ALIGNED
     c-situacao AT ROW 1.21 COL 60.86 COLON-ALIGNED
     requisicao.nome-abrev AT ROW 2.29 COL 20.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     c-requisitante AT ROW 2.29 COL 38.57 COLON-ALIGNED HELP
          "Nome completo do Requisitante" NO-LABEL
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.requisicao
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
         HEIGHT             = 2.33
         WIDTH              = 87.29.
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
       FRAME f-main:HEIGHT           = 2.33
       FRAME f-main:WIDTH            = 87.29.

/* SETTINGS FOR FILL-IN c-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-requisitante IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-situacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN requisicao.nome-abrev IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN requisicao.nr-requisicao IN FRAME f-main
   1                                                                    */
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

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
ASSIGN cAuxTraducao001 = {ininc/i01in385.i 03}.
RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao001).
ASSIGN c-lista-situacao = cAuxTraducao001.
&else
ASSIGN c-lista-situacao = {ininc/i01in385.i 03}.
&endif
  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
      ASSIGN cAuxTraducao002 = {ininc/i02in385.i 03}.
      RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao002).
      ASSIGN c-lista-estado   = cAuxTraducao002.
  &else
      ASSIGN c-lista-estado   = {ininc/i02in385.i 03}.
  &endif
         
  {utp/ut-field.i mgind requisicao estado 1}
  assign c-estado:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind requisicao situacao 1}
  assign c-situacao:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "requisicao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "requisicao"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/
find first param-global no-lock no-error. 

if can-find (first it-requisicao where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                                 and   it-requisicao.qt-atendida <> 0) then do:
     run utp/ut-msgs.p ("show",17698,"").
     return "adm-error".
end.

    /**
    ***   Aprova‡Æo Eletr“nica
    **/
    if requisicao.tp-requis = 1 then
        assign i-tipo-doc = 2.
    if requisicao.tp-requis = 2 then do:
        assign i-tipo-doc = 1.
        run ccp/ccapi642.p (2, rowid(requisicao), 3).
    end.
    if requisicao.tp-requis = 3 then
        assign i-tipo-doc = 5.
    find first param-compra
        no-lock no-error.
    for each it-requisicao where
        it-requisicao.nr-requisicao = requisicao.nr-requisicao NO-LOCK:
        /*** aprova‡Æo eletr“nica ***/
        if param-compra.log-1 then do:
            run cdp/cdapi171.p (i-tipo-doc,
                                3,
                                rowid(it-requisicao)).
        end.
        /***************************/
        /***** INVESTIMENTOS *****/
        if  param-global.modulo-in 
        and it-requisicao.num-ord-inv <> 0 then do:
            run inp/in2101.p(rowid(requisicao), rowid(it-requisicao), "Elimina").
        end.    
        /*************************/
    end.

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
  
  // DMANESTOQ-13826: Inclu¡do RELEASE para atualizar registros do CD1407a qdo o mesmo 
  //                  estiver aberto durante execu‡Æo da API Rest de Atendimento de 
  //                  Requisi‡Æo WMS-SAAS.
  IF AVAILABLE requisicao THEN DO:  
      FIND FIRST b-requisicao EXCLUSIVE-LOCK 
           WHERE b-requisicao.nr-requisicao = requisicao.nr-requisicao NO-ERROR.
      IF AVAIL b-requisicao THEN DO:
          FOR EACH it-requisicao OF b-requisicao NO-LOCK:
              FIND FIRST b-it-requisicao EXCLUSIVE-LOCK 
                   WHERE ROWID(b-it-requisicao) = ROWID(it-requisicao) NO-ERROR.
          END.
          RELEASE b-it-requisicao.
          VALIDATE b-it-requisicao NO-ERROR.
      END.
      RELEASE b-requisicao.
      VALIDATE b-requisicao NO-ERROR.      
  END.         

  /* Dispatch standard ADM method.  */
  if available requisicao then do:
     run utp/ut-liter.p (input {ininc/i03in385.i 04 requisicao.tp-requis}, input "", input "").
     find usuar-mater where 
          usuar-mater.cod-usuario = requisicao.nome-abrev no-lock no-error.
     assign c-requisitante = if available usuar-mater then usuar-mater.nome-usuar else "":U.
     assign c-situacao = entry(requisicao.situacao, c-lista-situacao)
            c-estado   = entry(requisicao.estado, c-lista-estado)
            requisicao.nr-requisicao:label in frame {&frame-name} = RETURN-VALUE.
     if requisicao.tp-requis = 1 then do:
         {utp/ut-field.i mgind usuar-mater usuar-requis 1}
         assign requisicao.nome-abrev:label in frame {&frame-name} = return-value.
     end.
     else do:
        {utp/ut-field.i mgind usuar-mater usuar-solic 1}
         assign requisicao.nome-abrev:label in frame {&frame-name} = return-value.
     end.
  end.
  else do:
      {utp/ut-field.i mgind requisicao nr-requisicao 1}
      assign requisicao.nr-requisicao:label in frame {&frame-name} = 
                                      return-value.
  end. 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

   /* Code placed here will execute AFTER standard behavior.    */

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

  if avail requisicao then
     assign gr-requisicao = rowid(requisicao).

  find first usuar-mater where usuar-mater.cod-usuario = requisicao.nome-abrev
   no-lock no-error.
   if avail usuar-mater then
    assign gr-usuar-mater = rowid(usuar-mater).

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
  {src/adm/template/snd-list.i "requisicao"}

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

