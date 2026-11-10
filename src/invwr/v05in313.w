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
{include/i-prgvrs.i V05IN313 2.00.00.008}  /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V05IN313 MUT}
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
def new global shared var gr-pl-mest   as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def buffer b-pl-mest for pl-mest.
def var c-lista-estado as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES pl-mest
&Scoped-define FIRST-EXTERNAL-TABLE pl-mest


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR pl-mest.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS pl-mest.log-detalhe-atp ~
pl-mest.log-recurso-prod pl-mest.log-recurso-item pl-mest.dat-ini-pp ~
pl-mest.dat-fim-pp 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}dat-ini-pp ~{&FP2}dat-ini-pp ~{&FP3}~
 ~{&FP1}dat-fim-pp ~{&FP2}dat-fim-pp ~{&FP3}
&Scoped-define ENABLED-TABLES pl-mest
&Scoped-define FIRST-ENABLED-TABLE pl-mest
&Scoped-Define ENABLED-OBJECTS ret-1 ret-2 ret-3 
&Scoped-Define DISPLAYED-FIELDS pl-mest.log-detalhe-atp ~
pl-mest.log-recurso-prod pl-mest.log-recurso-item pl-mest.dat-ini-pp ~
pl-mest.dat-fim-pp 
&Scoped-Define DISPLAYED-OBJECTS c-tipo-calculo-atp cb-ind-funcao-plano ~
cb-ind-nivel-calc 

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
DEFINE VARIABLE cb-ind-funcao-plano AS CHARACTER FORMAT "X(25)" INITIAL "1" 
     LABEL "Funá∆o plano MPS":R20 
     VIEW-AS COMBO-BOX INNER-LINES 5
/*      LIST-ITEMS "Item 1" */
     SIZE 23.14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ind-nivel-calc AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
/*      LIST-ITEMS "Item 1" */
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-tipo-calculo-atp AS CHARACTER FORMAT "X(30)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 23.29 BY .88 NO-UNDO.

DEFINE RECTANGLE ret-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 2.5.

DEFINE RECTANGLE ret-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 2.5.

DEFINE RECTANGLE ret-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 1.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     pl-mest.log-detalhe-atp AT ROW 1.17 COL 16.43
          VIEW-AS TOGGLE-BOX
          SIZE 30.43 BY .83
     c-tipo-calculo-atp AT ROW 1.17 COL 58.14 COLON-ALIGNED
     cb-ind-funcao-plano AT ROW 2.17 COL 58.14 COLON-ALIGNED HELP
          "Funá∆o do plano mestre"
     pl-mest.log-recurso-prod AT ROW 4.17 COL 16.43
          VIEW-AS TOGGLE-BOX
          SIZE 35.72 BY .83
     pl-mest.log-recurso-item AT ROW 5.17 COL 16.43
          VIEW-AS TOGGLE-BOX
          SIZE 32.14 BY .83
     cb-ind-nivel-calc AT ROW 4.17 COL 58.14 COLON-ALIGNED
     pl-mest.dat-ini-pp AT ROW 6.88 COL 22.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     pl-mest.dat-fim-pp AT ROW 6.88 COL 58.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     ret-1 AT ROW 1 COL 1
     ret-2 AT ROW 3.75 COL 1
     ret-3 AT ROW 6.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.pl-mest
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
         HEIGHT             = 7.04
         WIDTH              = 85.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-tipo-calculo-atp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-ind-funcao-plano IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-ind-nivel-calc IN FRAME f-main
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-field.i mgind pl-mest tipo-calculo-atp 1}
assign c-tipo-calculo-atp:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind pl-mest ind-nivel-calc 1}
assign cb-ind-nivel-calc:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind pl-mest ind-funcao-plano 1}
assign cb-ind-funcao-plano:label in frame {&frame-name} = return-value.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF         

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
  {src/adm/template/row-list.i "pl-mest"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "pl-mest"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.

/*
    if  pl-mest.dat-ini-pp  = ?
    or (pl-mest.dat-ini-pp >= pl-mest.dat-ini-pm
    and pl-mest.dat-ini-pp <  pl-mest.dat-fim-pm) then do:
  */  

    if   input pl-mest.dat-ini-pp <> ?
    and (input pl-mest.dat-ini-pp <  pl-mest.dat-ini-pm
    or   input pl-mest.dat-ini-pp >= pl-mest.dat-fim-pm) then do:
        {utp/ut-liter.i Data_in°cio * R}  
        run utp/ut-msgs.p (input "show",
                           input 16539,
                           input return-value).       
        apply 'entry' to pl-mest.dat-ini-pp in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.   

/*    if  input frame {&fame-name} pl-mest.dat-fim-pp  = ?
    or (input frame {&fame-name} pl-mest.dat-fim-pp <= pl-mest.dat-fim-pm
    and input frame {&fame-name} pl-mest.dat-fim-pp >  pl-mest.dat-ini-pm) then .
    else do:
*/
    if   input pl-mest.dat-fim-pp <> ?
    and (input pl-mest.dat-fim-pp >  pl-mest.dat-fim-pm
    or   input pl-mest.dat-fim-pp <= pl-mest.dat-ini-pm) then do:

        {utp/ut-liter.i Data_fim * R}  
        run utp/ut-msgs.p (input "show",
                           input 16539,
                           input return-value).       
        apply 'entry' to pl-mest.dat-fim-pp in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.   

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if  RETURN-VALUE = 'ADM-ERROR':U then 
        RETURN 'ADM-ERROR':U.

    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  do with frame {&frame-name}:   
     assign pl-mest.tipo-calculo-atp = {ininc/i06in313.i 06 c-tipo-calculo-atp}.
     assign pl-mest.ind-nivel-calc   = {ininc/i07in313.i 06 cb-ind-nivel-calc:screen-value}.
     assign pl-mest.ind-funcao-plano = {ininc/i08in313.i 06 cb-ind-funcao-plano:screen-value}.
  end.


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
  disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.

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

  if avail pl-mest then do:
      RUN utp/ut-liter.p (trim({ininc/i06in313.i 04 pl-mest.tipo-calculo-atp}), "*", "").
      assign c-tipo-calculo-atp:screen-value in frame {&frame-name} = RETURN-VALUE
             c-tipo-calculo-atp                                    = {ininc/i06in313.i 04 pl-mest.tipo-calculo-atp}
             cb-ind-nivel-calc:screen-value in frame {&frame-name} = {ininc/i07in313.i 04 pl-mest.ind-nivel-calc}
             cb-ind-funcao-plano:screen-value in frame {&frame-name} = {ininc/i08in313.i 04 pl-mest.ind-funcao-plano}.
  end.
  else do:
      RUN utp/ut-liter.p (trim({ininc/i06in313.i 04 1}), "*", "").
      assign c-tipo-calculo-atp:screen-value in frame {&frame-name} = RETURN-VALUE
             c-tipo-calculo-atp                                    = {ininc/i06in313.i 04 1}
             cb-ind-nivel-calc:screen-value in frame {&frame-name} = {ininc/i07in313.i 04 1}
             cb-ind-funcao-plano:screen-value in frame {&frame-name} = {ininc/i08in313.i 04 1}.
  end.             

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

  do with frame {&frame-name}:
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE c-lista AS CHARACTER  NO-UNDO.
         ASSIGN c-lista = {ininc/i07in313.i 03}.
    	 run utp/ut-lstit.p (input-output c-lista).
         ASSIGN cb-ind-nivel-calc:LIST-ITEM-PAIRS = c-lista
                c-lista = {ininc/i08in313.i 03}.
         run utp/ut-lstit.p (input-output c-lista).
         ASSIGN cb-ind-funcao-plano:LIST-ITEM-PAIRS = c-lista.
     &else
         assign cb-ind-nivel-calc:list-items   = {ininc/i07in313.i 03}
                cb-ind-funcao-plano:list-items = {ininc/i08in313.i 03}.
     &endif
  end.

  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos V-table-Win 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  assign pl-mest.log-detalhe-atp:sensitive   in frame {&frame-name} = yes
         cb-ind-nivel-calc:sensitive         in frame {&frame-name} = yes
         cb-ind-funcao-plano:sensitive       in frame {&frame-name} = yes
         pl-mest.log-recurso-item:sensitive  in frame {&frame-name} = yes
         pl-mest.log-recurso-prod:sensitive  in frame {&frame-name} = yes
         pl-mest.dat-ini-pp:sensitive        in frame {&frame-name} = yes
         pl-mest.dat-fim-pp:sensitive        in frame {&frame-name} = yes.

  if pl-mest.dat-ini-pp = ? then
     assign pl-mest.dat-ini-pp:screen-value = string(pl-mest.dat-ini-pm).

  if pl-mest.dat-fim-pp = ? then
     assign pl-mest.dat-fim-pp:screen-value = string(pl-mest.dat-fim-pm).

  if pl-mest.estado > 1 then
     assign pl-mest.log-detalhe-atp:sensitive   in frame {&frame-name}  = no
            cb-ind-funcao-plano:sensitive       in frame {&frame-name}  = no.

  if pl-mest.estado > 5 then
     assign cb-ind-nivel-calc:sensitive        in frame {&frame-name}  = no
            pl-mest.log-recurso-item:sensitive in frame {&frame-name}  = no
            pl-mest.log-recurso-prod:sensitive in frame {&frame-name}  = no.  

  if pl-mest.estado > 6 then
     assign pl-mest.dat-ini-pp:sensitive in frame {&frame-name}        = no
            pl-mest.dat-fim-pp:sensitive in frame {&frame-name}        = no.



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
  {src/adm/template/snd-list.i "pl-mest"}

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


