&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V01IN250 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN250 MUT}
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

def buffer b-nqa-simp for nqa-simp.
def var i-tipo-plano as integer no-undo.
def new global shared var gr-nqa-simp as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES nqa-simp
&Scoped-define FIRST-EXTERNAL-TABLE nqa-simp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR nqa-simp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS nqa-simp.nr-aceita nqa-simp.nr-rejeita ~
nqa-simp.ajuste-tab 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nr-aceita ~{&FP2}nr-aceita ~{&FP3}~
 ~{&FP1}nr-rejeita ~{&FP2}nr-rejeita ~{&FP3}
&Scoped-define ENABLED-TABLES nqa-simp
&Scoped-define FIRST-ENABLED-TABLE nqa-simp
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-1 
&Scoped-Define DISPLAYED-FIELDS nqa-simp.cod-amostra nqa-simp.perc-nqa ~
nqa-simp.nr-aceita nqa-simp.nr-rejeita nqa-simp.ajuste-tab 
&Scoped-Define DISPLAYED-OBJECTS cb-tipo-plano FILL-IN-1 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cb-tipo-plano nqa-simp.cod-amostra ~
nqa-simp.perc-nqa 
&Scoped-define ADM-ASSIGN-FIELDS cb-tipo-plano 

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
DEFINE VARIABLE cb-tipo-plano AS CHARACTER FORMAT "X(8)":U INITIAL "0" 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 26.14 BY 1.96.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-tipo-plano AT ROW 1.13 COL 24 COLON-ALIGNED
     nqa-simp.cod-amostra AT ROW 2.21 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     nqa-simp.perc-nqa AT ROW 3.21 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     nqa-simp.nr-aceita AT ROW 4.67 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     nqa-simp.nr-rejeita AT ROW 5.67 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     nqa-simp.ajuste-tab AT ROW 7.71 COL 27.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Inferior", 1,
"Superior", 2
          SIZE 24 BY 1.04
     FILL-IN-1 AT ROW 6.88 COL 25.14 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.5 COL 1
     RECT-1 AT ROW 7 COL 25.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.nqa-simp
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 8.33
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R, COLUMNS                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-tipo-plano IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN nqa-simp.cod-amostra IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN nqa-simp.perc-nqa IN FRAME f-main
   NO-ENABLE 1                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cb-tipo-plano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-plano V-table-Win
ON VALUE-CHANGED OF cb-tipo-plano IN FRAME f-main
DO:
  apply 'leave' to nqa-simp.nr-aceita in frame {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME nqa-simp.cod-amostra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nqa-simp.cod-amostra V-table-Win
ON F5 OF nqa-simp.cod-amostra IN FRAME f-main /* C¢digo Amostra */
DO:

  assign input frame {&frame-name} cb-tipo-plano 
         i-tipo-plano = {ININC/i02in250.i 06 cb-tipo-plano}.
  assign l-implanta = yes.    
 {include/zoomvar.i &prog-zoom="inzoom/z02in016.w"
                    &campo=nqa-simp.cod-amostra
                    &campozoom=cod-amostra
                    &parametros="run pi-seta-inicial in wh-pesquisa (input i-tipo-plano)."}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nqa-simp.cod-amostra V-table-Win
ON MOUSE-SELECT-DBLCLICK OF nqa-simp.cod-amostra IN FRAME f-main /* C¢digo Amostra */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME nqa-simp.nr-aceita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nqa-simp.nr-aceita V-table-Win
ON LEAVE OF nqa-simp.nr-aceita IN FRAME f-main /* Num Aceita‡Æo */
DO:
  if input frame {&FRAME-NAME} nqa-simp.nr-aceita = ? then do:
     assign nqa-simp.nr-rejeita:screen-value in frame {&FRAME-NAME} = string(?).
     disable nqa-simp.nr-rejeita with frame {&FRAME-NAME}.
     enable nqa-simp.ajuste-tab with frame {&FRAME-NAME}. 
  end.
  else do:
      disable nqa-simp.ajuste-tab with frame {&FRAME-NAME}.
      assign input frame {&frame-name} cb-tipo-plano 
             i-tipo-plano = {ININC/i02in250.i 06 cb-tipo-plano}.
      if i-tipo-plano = 3 then do:
         assign nqa-simp.nr-rejeita:screen-value in frame {&FRAME-NAME} = string(input frame {&FRAME-NAME} nqa-simp.nr-aceita + 1).
         disable nqa-simp.nr-rejeita with frame {&FRAME-NAME}.
      end.
      else do:
          enable nqa-simp.nr-rejeita with frame {&FRAME-NAME}.
          apply 'entry' to nqa-simp.nr-rejeita in frame {&FRAME-NAME}. 
          return no-apply.
      end.
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

 
/* include que retornar  o label do campo e acerta o label do combo-box */
   {utp/ut-field.i mgind nqa-simp tipo-plano 1}
   assign cb-tipo-plano:label in frame {&FRAME-NAME} = return-value. 
   
/* include que traz a label do retƒngulo */
 {utp/ut-rtlbl.i mgind nqa-simp ajuste-tab FILL-IN-1}.   

 /* Alterar ponteiro do mouse para o campo chave estrangeira   */
 
 if nqa-simp.cod-amostra:load-mouse-pointer ("image\lupa.cur") in frame {&FRAME-NAME} then.

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
  {src/adm/template/row-list.i "nqa-simp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "nqa-simp"}

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

   /* Redefini‡Æo do screen-value do retƒngulo do ajuste-tab */
   
   {utp/ut-rtlbl.i mgind nqa-simp ajuste-tab fill-in-1}.   
   
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

  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

   assign input frame {&frame-name} cb-tipo-plano 
         i-tipo-plano = {ININC/i02in250.i 06 cb-tipo-plano}.

  /* Ponha aqui a valida‡Æo de chave duplicada */
  find amostra where
       amostra.tipo-plano  = i-tipo-plano and
       amostra.cod-amostra = input frame {&FRAME-NAME} nqa-simp.cod-amostra no-lock no-error.
  if avail amostra then do:     
      if  nqa-simp.cod-amostra:sensitive in frame {&frame-name} = yes  and 
          can-find (b-nqa-simp where 
                    b-nqa-simp.tipo-plano  =  i-tipo-plano and
                    b-nqa-simp.cod-amostra =  input frame {&frame-name} nqa-simp.cod-amostra and
                    b-nqa-simp.perc-nqa    =  input frame {&FRAME-NAME} nqa-simp.perc-nqa)
      then do:
            {utp/ut-table.i mgind nqa-simp 1}
             run utp/ut-msgs.p (input "show",
                                input 1,
                                input return-value).                   
             return 'adm-error'.
      End.
  end.
  else do:
         {utp/ut-table.i mgind amostra 1}
         run utp/ut-msgs.p (input "show",
                            input 2,
                            input return-value).
         apply 'entry' to nqa-simp.nr-rejeita in frame {&FRAME-NAME}.  
         return 'adm-error'. 
  end.       
  /* Ponha aqui as demais valida‡äes */
   
      if input frame {&FRAME-NAME} nqa-simp.nr-aceita <> ? and
                                         i-tipo-plano <> 3 and
         input frame {&FRAME-NAME} nqa-simp.nr-aceita >= input frame {&FRAME-NAME} nqa-simp.nr-rejeita then do:
            run utp/ut-msgs.p (input "show",
                               input  467,
                               input "").
            apply 'entry' to nqa-simp.nr-rejeita in frame {&FRAME-NAME}.
            return 'adm-error'.
      end.     
      
      IF  INPUT FRAME {&frame-name} nqa-simp.nr-aceita <> ? 
      AND INPUT FRAME {&frame-name} nqa-simp.nr-rejeita = ? THEN DO:
          RUN utp/ut-msgs.p (INPUT "show",
                             INPUT 467,
                             INPUT "").
          APPLY "entry" TO nqa-simp.nr-rejeita IN FRAME {&frame-name}.
          RETURN "adm-error".                             
      END. /* if input frame ... */
            
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

      
  assign nqa-simp.tipo-plano = {ININC/i02in250.i 06 cb-tipo-plano}.    
  
 
  /* Code placed here will execute AFTER standard behavior.    */

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
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  if avail nqa-simp then do with frame {&FRAME-NAME}:
     assign cb-tipo-plano:screen-value = {ininc/i02in250.i 04 nqa-simp.tipo-plano}.
  end.
  else do:
     assign cb-tipo-plano:screen-value = {ininc/i02in250.i 04 1}.
  end.      
    
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    do with frame {&FRAME-NAME} :
       assign cb-tipo-plano:list-items = {ininc/i02in250.i 03}.
    end.   

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

  /* Code placed here will execute AFTER standard behavior.    */
  
  if avail nqa-simp then
    assign gr-nqa-simp = rowid(nqa-simp).

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
  {src/adm/template/snd-list.i "nqa-simp"}

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


