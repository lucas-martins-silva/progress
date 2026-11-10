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
{include/i-prgvrs.i V01IN391 2.00.00.009 } /*** "010009" 21/11/2023 17:01:03 ***/

{include/i_fncrowid.i}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN391 MUT}
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
def buffer b-responsavel for responsavel.
def new global shared var gr-responsavel as rowid no-undo.

&IF {&ROWID_READY} = YES &THEN
    def new global shared var v_rec_usuar_mestre as rowid no-undo.
&ELSE
    def new global shared var v_rec_usuar_mestre as recid format ">>>>>>9" initial ? no-undo.
&ENDIF

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
&Scoped-define EXTERNAL-TABLES responsavel
&Scoped-define FIRST-EXTERNAL-TABLE responsavel


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR responsavel.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS responsavel.nome-resp ~
responsavel.cod-respons-2 responsavel.permissao responsavel.inf-adic ~
responsavel.log-1 
&Scoped-define ENABLED-TABLES responsavel
&Scoped-define FIRST-ENABLED-TABLE responsavel
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-1 c-label-permissao 
&Scoped-Define DISPLAYED-FIELDS responsavel.cod-resp responsavel.nome-resp ~
responsavel.cod-respons-2 responsavel.permissao responsavel.inf-adic ~
responsavel.log-1 
&Scoped-define DISPLAYED-TABLES responsavel
&Scoped-define FIRST-DISPLAYED-TABLE responsavel
&Scoped-Define DISPLAYED-OBJECTS c-nome-2 c-label-permissao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS responsavel.cod-resp 

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
DEFINE VARIABLE c-label-permissao AS CHARACTER FORMAT "X(25)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .63 NO-UNDO.

DEFINE VARIABLE c-nome-2 AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 1.88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 8.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     responsavel.cod-resp AT ROW 1.17 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     responsavel.nome-resp AT ROW 2.67 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     responsavel.cod-respons-2 AT ROW 3.75 COL 30 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     c-nome-2 AT ROW 4.88 COL 30 COLON-ALIGNED VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     responsavel.permissao AT ROW 6.88 COL 32 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Pend - Analise", 1,
"Todas Moviment", 2
          SIZE 36.14 BY .75
     responsavel.inf-adic AT ROW 8.46 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     responsavel.log-1 AT ROW 9.63 COL 32 HELP
          "Autoriza Outro Respons vel"
          VIEW-AS TOGGLE-BOX
          SIZE 8.14 BY .83 TOOLTIP "Autoriza Outro Respons vel"
     c-label-permissao AT ROW 5.96 COL 29 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
     RECT-1 AT ROW 6.29 COL 25
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.responsavel
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
         HEIGHT             = 10.38
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

/* SETTINGS FOR FILL-IN responsavel.cod-resp IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR TOGGLE-BOX responsavel.log-1 IN FRAME f-main
   EXP-HELP                                                             */
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

&Scoped-define SELF-NAME responsavel.cod-resp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL responsavel.cod-resp V-table-Win
ON F5 OF responsavel.cod-resp IN FRAME f-main /* Respons vel */
DO:
  run sec/sec000ka.p.
  if v_rec_usuar_mestre <> ? then
  do:
    &IF {&ROWID_READY} = YES &THEN
        find usuar_mestre where rowid(usuar_mestre) =  v_rec_usuar_mestre no-lock no-error.
    &ELSE
        find usuar_mestre where recid(usuar_mestre) =  v_rec_usuar_mestre no-lock no-error.
    &ENDIF

    if avail usuar_mestre then 
        assign responsavel.cod-resp:screen-value in frame {&FRAME-NAME} = usuar_mestre.cod_usuario.
  end. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL responsavel.cod-resp V-table-Win
ON LEAVE OF responsavel.cod-resp IN FRAME f-main /* Respons vel */
DO:
  {include/leave.i &tabela=usuar_mestre
                   &atributo-ref=nom_usuario
                   &variavel-ref=responsavel.nome-resp
                   &where="usuar_mestre.cod_usuario = input frame {&FRAME-NAME} responsavel.cod-resp"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL responsavel.cod-resp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF responsavel.cod-resp IN FRAME f-main /* Respons vel */
DO:
  apply 'F5' to self.
END.

&Scoped-define SELF-NAME responsavel.cod-resp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-respons-2 V-table-Win
ON F5 OF cod-respons-2 IN FRAME f-main /* Respons vel Alternativo*/
DO:
  run sec/sec000ka.p.
  if v_rec_usuar_mestre <> ? then
  do:
    &IF {&ROWID_READY} = YES &THEN
        find usuar_mestre where rowid(usuar_mestre) =  v_rec_usuar_mestre no-lock no-error.
    &ELSE
        find usuar_mestre where recid(usuar_mestre) =  v_rec_usuar_mestre no-lock no-error.
    &ENDIF
    
    if avail usuar_mestre then 
        assign cod-respons-2:screen-value in frame {&FRAME-NAME} = usuar_mestre.cod_usuario.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-respons-2 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cod-respons-2 IN FRAME f-main /* Respons vel Alternativo */
DO:
  apply 'F5' to self.
END.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL responsavel.cod-respons-2 V-table-Win
ON LEAVE OF responsavel.cod-respons-2 IN FRAME f-main /* Respons vel Alternativo*/
DO:
  {include/leave.i &tabela=usuar_mestre
                   &atributo-ref=nom_usuario
                   &variavel-ref=c-nome-2
                   &where="usuar_mestre.cod_usuario = input frame {&FRAME-NAME} responsavel.cod-respons-2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
    
  {utp/ut-liter.i Autoriza * r}
  assign responsavel.log-1:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Respons vel_Alternativo * r}
  assign cod-respons-2:label in frame {&frame-name} = trim(return-value).
  
  {utp/ut-liter.i Nome * r}
  assign c-nome-2:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Altera_Situa‡Æo_Roteiro * r}
  assign c-label-permissao = trim(return-value).
  
  if cod-respons-2:load-mouse-pointer ("image\lupa.cur") in frame {&FRAME-NAME} 
  then.

  if responsavel.cod-resp:load-mouse-pointer ("image\lupa.cur") in frame {&FRAME-NAME} 
  then.

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "responsavel"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "responsavel"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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

  {utp/ut-liter.i Altera_Situa‡Æo_Roteiro * r}
  assign c-label-permissao:screen-value in frame {&FRAME-NAME} = trim(return-value).

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* O programa btb910zz.p solicita a senha do usu rio e confronta a mesma com 
     a senha do usu rio no menu.                                         
     Testa sensitive = no para testar senha somente quando for altera‡Æo */

  if  responsavel.cod-resp:sensitive in frame {&FRAME-NAME} = no then do:
      run btb/btb910zz.p (c-seg-usuario,
                          input no).
      if  return-value = "NOK" then do:
          apply 'entry' to responsavel.nome-resp in frame {&FRAME-NAME}.
          return 'adm-error'.
      end.
  end.

  /* Ponha aqui a valida‡Æo de chave duplicada */
  if  responsavel.cod-resp:sensitive in frame {&FRAME-NAME} = yes
  and can-find (b-responsavel
      where b-responsavel.cod-resp = input frame {&FRAME-NAME} responsavel.cod-resp) then do:
      {utp/ut-table.i mgind responsavel 1}
      run utp/ut-msgs.p (input "show", input 1, input return-value).
      apply 'entry' to responsavel.cod-resp in frame {&FRAME-NAME}.
      return 'adm-error'.
  end.

  /* Verifica se o responsavel est  cadastrado no menu. */
  if  responsavel.cod-resp:sensitive in frame {&FRAME-NAME} = yes
  and not can-find (usuar_mestre
      where usuar_mestre.cod_usuario = input frame {&FRAME-NAME} responsavel.cod-resp) then do:
      {utp/ut-table.i mguni usuar_mestre 1}
      run utp/ut-msgs.p (input "show", input 2, input return-value).
      apply 'entry' to responsavel.cod-resp in frame {&FRAME-NAME}.
      return 'adm-error'.
  end.

  IF responsavel.cod-respons-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:
      {utp/ut-liter.i Respons vel_Alternativo * r}
      run utp/ut-msgs.p (input "show", input 164, input return-value).
      apply 'entry' to responsavel.cod-respons-2 in frame {&FRAME-NAME}.
      return 'adm-error'.
  END.

  /* Ponha aqui as demais valida‡äes */
  
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* O programa btb910zz.p solicita a senha do usu rio e confronta a mesma com
     a senha do usu rio no menu.                               */

  if  avail responsavel then do:
      run btb/btb910zz.p (c-seg-usuario, input no).
      if  return-value = "NOK" then do:
          apply 'entry' to responsavel.nome-resp in frame {&FRAME-NAME}.
          return 'adm-error'.
      end.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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

  FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = input frame {&FRAME-NAME} responsavel.cod-respons-2 NO-LOCK NO-ERROR.
  IF AVAIL usuar_mestre THEN DO:
      ASSIGN c-nome-2 = nom_usuario.
      DISP c-nome-2 WITH FRAME {&FRAME-NAME}.
  END.
  ELSE DO:
      ASSIGN c-nome-2 = "".
      DISP c-nome-2 WITH FRAME {&FRAME-NAME}.
  END.


  /* Code placed here will execute AFTER standard behavior.    */
  if avail responsavel then
     assign gr-responsavel = rowid(responsavel).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "responsavel"}

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


