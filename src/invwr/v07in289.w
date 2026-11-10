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
{include/i-prgvrs.i V07IN289 2.00.00.011}  /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V07IN289 MUT}
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
{cdp/cdcfgmnt.i}


&Scop adm-attribute-dlg support/viewerd.w

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def workfile w-faixa field w-inicio like param-cp.prim-ord-man
                     field w-fim like param-cp.prim-ord-man.
def var l-erro as logical no-undo.
def var i-anterior like param-cp.prim-ord-man no-undo.

def var h-v02in289 as handle no-undo.
def var c-handle   as char no-undo.

def var l-numer-aut       as logical no-undo.
def var i-prim-solic-serv like param-mi.prox-sol-serv no-undo.
def var i-ult-solic-serv  like param-mi.prox-sol-serv  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-mi
&Scoped-define FIRST-EXTERNAL-TABLE param-mi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-mi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-mi.prim-ord-plan param-mi.ult-ord-plan 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}prim-ord-plan ~{&FP2}prim-ord-plan ~{&FP3}~
 ~{&FP1}ult-ord-plan ~{&FP2}ult-ord-plan ~{&FP3}
&Scoped-define ENABLED-TABLES param-mi
&Scoped-define FIRST-ENABLED-TABLE param-mi
&Scoped-Define ENABLED-OBJECTS rt-mold i-prim-ord-man i-ult-ord-man ~
i-prox-ord-man i-prim-ord-aut i-ult-ord-aut i-prox-ord-aut 
&Scoped-Define DISPLAYED-FIELDS param-mi.prim-ord-plan ~
param-mi.ult-ord-plan 
&Scoped-Define DISPLAYED-OBJECTS i-prim-ord-man i-ult-ord-man ~
i-prox-ord-man i-prim-ord-aut i-ult-ord-aut i-prox-ord-aut 

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
DEFINE VARIABLE i-prim-ord-aut AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-prim-ord-man AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-prox-ord-aut AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-prox-ord-man AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-ult-ord-aut AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-ult-ord-man AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77 BY 8.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-prim-ord-man AT ROW 1.46 COL 40 COLON-ALIGNED
     i-ult-ord-man AT ROW 2.46 COL 40 COLON-ALIGNED
     i-prox-ord-man AT ROW 3.5 COL 40.14 COLON-ALIGNED
     i-prim-ord-aut AT ROW 4.5 COL 40.14 COLON-ALIGNED
     i-ult-ord-aut AT ROW 5.5 COL 40.14 COLON-ALIGNED
     i-prox-ord-aut AT ROW 6.5 COL 40.14 COLON-ALIGNED
     param-mi.prim-ord-plan AT ROW 7.5 COL 40.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     param-mi.ult-ord-plan AT ROW 8.5 COL 40.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-mi
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 8.79
         WIDTH              = 77.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

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

&Scoped-define SELF-NAME i-prim-ord-man
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-prim-ord-man V-table-Win
ON ENTRY OF i-prim-ord-man IN FRAME f-main
DO:
  FIND FIRST param-cp no-lock NO-ERROR.
  IF  AVAIL param-cp THEN
      ASSIGN i-prim-ord-man:screen-value in frame {&frame-name} = string(param-cp.prim-ord-man-mi)
             i-ult-ord-man:screen-value in frame {&frame-name}  = string(param-cp.ult-ord-man-mi)
             i-prox-ord-man:screen-value in frame {&frame-name} = string(param-cp.prox-ord-man-mi)
             i-prim-ord-aut:screen-value in frame {&frame-name} = string(param-cp.prim-ord-aut-mi)
             i-ult-ord-aut:screen-value in frame {&frame-name}  = string(param-cp.ult-ord-aut-mi)
             i-prox-ord-aut:screen-value in frame {&frame-name} = string(param-cp.prox-ord-aut-mi).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/****************************  Main Block  *************************** */

  {utp/ut-field.i mgind param-cp prim-ord-man-mi 1}
  ASSIGN i-prim-ord-man:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
  {utp/ut-field.i mgind param-cp ult-ord-man-mi 1}
  ASSIGN i-ult-ord-man:LABEL IN FRAME {&frame-name} = RETURN-VALUE. 
  {utp/ut-field.i mgind param-cp prox-ord-man-mi 1}
  ASSIGN i-prox-ord-man:LABEL IN FRAME {&frame-name} = RETURN-VALUE. 
  {utp/ut-field.i mgind param-cp prim-ord-aut-mi 1}
  ASSIGN i-prim-ord-aut:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
  {utp/ut-field.i mgind param-cp ult-ord-aut-mi 1}
  ASSIGN i-ult-ord-aut:LABEL IN FRAME {&frame-name} = RETURN-VALUE. 
  {utp/ut-field.i mgind param-cp prox-ord-aut-mi 1}
  ASSIGN i-prox-ord-aut:LABEL IN FRAME {&frame-name} = RETURN-VALUE. 

   find first param-global no-lock no-error.
   find first param-mi no-error.
   
   if avail param-global then
      if param-global.modulo-pi = no then 
         if avail param-mi then 
            assign param-mi.prim-ord-plan = 1
                   param-mi.ult-ord-plan  = 1.
      

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
  {src/adm/template/row-list.i "param-mi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-mi"}

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
 {include/i-valid.i}
  
  FIND FIRST param-cp exclusive-lock NO-ERROR.
  IF  NOT AVAIL param-cp THEN DO:
      create param-cp.
      ASSIGN param-cp.prim-ord-aut-cp = 0
             param-cp.prim-ord-man    = 0
             param-cp.prox-ord-aut    = 0
             param-cp.prox-ord-man    = 0
             param-cp.ult-ord-aut-cp  = 0
             param-cp.ult-ord-man     = 0.
  END.
  
  ASSIGN param-cp.prim-ord-man-mi = int(i-prim-ord-man:screen-value in frame {&frame-name})
         param-cp.ult-ord-man-mi  = int(i-ult-ord-man:screen-value in frame {&frame-name})
         param-cp.prox-ord-man-mi = int(i-prox-ord-man:screen-value in frame {&frame-name})
         param-cp.prim-ord-aut-mi = int(i-prim-ord-aut:screen-value in frame {&frame-name})
         param-cp.ult-ord-aut-mi  = int(i-ult-ord-aut:screen-value in frame {&frame-name})
         param-cp.prox-ord-aut-mi = int(i-prox-ord-aut:screen-value in frame {&frame-name}).

  release param-cp.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
   
   find first param-global no-lock no-error.
   find first param-mi exclusive-lock no-error.
   
   if avail param-global then
      if param-global.modulo-pi = no then do:
         if avail param-mi then 
            assign param-mi.prim-ord-plan = 0
                   param-mi.ult-ord-plan  = 0.
      end. 
      
   &if defined (bf_mnt_ems203)  &then
      if l-numer-aut = yes and avail param-mi then
      assign param-mi.prim-sol-serv = i-prim-solic-serv
             param-mi.ult-sol-serv  = i-ult-solic-serv.
   &endif 
   
   release param-mi.
   
   find first param-mi no-lock no-error.
   
  /* Code placed here will execute AFTER standard behavior.    */

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

  FIND FIRST param-cp no-lock NO-ERROR.
  IF  AVAIL param-cp THEN
      ASSIGN i-prim-ord-man:screen-value in frame {&frame-name} = string(param-cp.prim-ord-man-mi)
             i-ult-ord-man:screen-value in frame {&frame-name}  = string(param-cp.ult-ord-man-mi)
             i-prox-ord-man:screen-value in frame {&frame-name} = string(param-cp.prox-ord-man-mi)
             i-prim-ord-aut:screen-value in frame {&frame-name} = string(param-cp.prim-ord-aut-mi)
             i-ult-ord-aut:screen-value in frame {&frame-name}  = string(param-cp.ult-ord-aut-mi)
             i-prox-ord-aut:screen-value in frame {&frame-name} = string(param-cp.prox-ord-aut-mi).

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
 
  if avail param-global then
     if param-global.modulo-pi = no then 
        disable param-mi.prim-ord-plan 
                param-mi.ult-ord-plan with frame {&frame-name}.
     else
        enable param-mi.prim-ord-plan 
                param-mi.ult-ord-plan with frame {&frame-name}.

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
 
    {include/i-vldfrm.i}
    
    &if defined(bf_mnt_ems203) &then
       
       find first param-mnt no-lock no-error.
       if  avail param-mnt and 
           param-mnt.produto-cp = 1 then do:
          
           if length(i-prim-ord-man:screen-value in frame {&frame-name}) > 7 or
              length(i-ult-ord-man:screen-value in frame {&frame-name})  > 7 or
              length(i-prim-ord-aut:screen-value in frame {&frame-name}) > 7 or
              length(i-ult-ord-aut:screen-value in frame {&frame-name})  > 7 or
              length(param-mi.prim-ord-plan:screen-value in frame {&frame-name}) > 7 or
              length(param-mi.ult-ord-plan:screen-value in frame {&frame-name}) > 7 then do:
             
              {include/i-vldprg.i}
              RUN utp/ut-msgs.p (input "show",
                                 input 19297,
                                 input "").
              APPLY "entry" TO i-prim-ord-man IN FRAME {&frame-name}.
              RETURN "adm-error".
                   
           end.
       end.
       
       RUN Who-Is-The-Container IN adm-broker-hdl (INPUT this-procedure, OUTPUT c-handle).
    
       run pi-retorna-handle in widget-handle(c-handle)(output h-v02in289).
    
       run pi-faixa-solic in h-v02in289 (output l-numer-aut,
                                         output i-prim-solic-serv,
                                         output i-ult-solic-serv ).
       if return-value = "adm-error" then
          return "adm-error".                                  
    &else
       assign l-numer-aut = no.                                     
    &endif
    
    IF  (INPUT FRAME {&frame-name} i-prim-ord-man) > (INPUT FRAME {&frame-name} i-ult-ord-man) 
    THEN DO:
        {include/i-vldprg.i}
        RUN utp/ut-msgs.p (input "show",
                           input 18590,
                           input trim(i-prim-ord-man:label) + "~~" + trim(i-ult-ord-man:label)).
        APPLY "entry" TO i-prim-ord-man IN FRAME {&frame-name}.
        RETURN "adm-error".
    END.  

  IF  (INPUT FRAME {&frame-name} i-prox-ord-man) < (INPUT FRAME {&frame-name} i-prim-ord-man)
  or  (INPUT FRAME {&frame-name} i-prox-ord-man) > (INPUT FRAME {&frame-name} i-ult-ord-man)
  THEN DO:
      {include/i-vldprg.i}
      RUN utp/ut-msgs.p (input "show",
                         input 8898,
                         input "").
      APPLY "entry" TO i-prox-ord-man IN FRAME {&frame-name}.
      RETURN "adm-error".
  END.

    IF  (INPUT FRAME {&frame-name} i-prim-ord-aut) > (INPUT FRAME {&frame-name} i-ult-ord-aut)
    THEN DO:
        {include/i-vldprg.i}
        RUN utp/ut-msgs.p (input "show",
                           input 18590,
                           input trim(i-prim-ord-aut:label) 
                           + "~~" + trim(i-ult-ord-aut:label)).
        APPLY "entry" TO i-prim-ord-aut IN FRAME {&frame-name}.
        RETURN "adm-error".
    END.
  
  IF  (INPUT FRAME {&frame-name} i-prox-ord-aut) < (INPUT FRAME {&frame-name} i-prim-ord-aut)
  or  (INPUT FRAME {&frame-name} i-prox-ord-aut) > (INPUT FRAME {&frame-name} i-ult-ord-aut)
  THEN DO:
      {include/i-vldprg.i}
      RUN utp/ut-msgs.p (input "show",
                         input 749,
                         input "").
      APPLY "entry" TO i-prox-ord-aut IN FRAME {&frame-name}.
      RETURN "adm-error".
  END.

  IF  (INPUT FRAME {&frame-name} param-mi.prim-ord-plan) > (INPUT FRAME {&frame-name} param-mi.ult-ord-plan)
  THEN DO:
      {include/i-vldprg.i}
      RUN utp/ut-msgs.p (input "show",
                         input 18590,
                         input trim(param-mi.prim-ord-plan:label) 
                         + "~~" + trim(param-mi.ult-ord-plan:label)).
      APPLY "entry" TO param-mi.prim-ord-plan IN FRAME {&frame-name}.
      RETURN "adm-error".
  END.
  
  find first param-global
      no-lock no-error.
  if  avail param-global then do:
      if  param-global.modulo-cp = yes then do:
          find first param-cp no-lock no-error.
          if  avail param-cp then do:
              create w-faixa.
              assign w-inicio = param-cp.prim-ord-man
                     w-fim    = param-cp.ult-ord-man.
              create w-faixa.
              assign w-inicio = param-cp.prim-ord-aut-cp
                     w-fim    = param-cp.ult-ord-aut-cp.
          end.
      end.
      if  param-global.modulo-pi = yes then do:
          create w-faixa.
          assign w-inicio = input frame {&frame-name} param-mi.prim-ord-plan
                 w-fim    = input frame {&frame-name} param-mi.ult-ord-plan.
      end.            
      create w-faixa.
      assign w-inicio = input frame {&frame-name} i-prim-ord-man
             w-fim    = input frame {&frame-name} i-ult-ord-man.
      create w-faixa.
      assign w-inicio = input frame {&frame-name} i-prim-ord-aut
             w-fim    = input frame {&frame-name} i-ult-ord-aut.
      if l-numer-aut then do:      
         create w-faixa.       
         assign w-inicio = i-prim-solic-serv
                w-fim    = i-ult-solic-serv.
      end.          
      assign i-anterior = 0
             l-erro     = no.
      for each w-faixa break by w-inicio:
          if  w-fim > i-anterior 
          and w-inicio > i-anterior then do:
              assign i-anterior = w-fim.
          end.
          else do:
              assign l-erro = yes.
          end.
      end.
      for each w-faixa:
          delete w-faixa.
      end.
      if  l-erro = yes then do:
          RUN utp/ut-msgs.p (input "show",
                            input 3250,
                            input "").
          APPLY "entry" TO i-prim-ord-man IN FRAME {&frame-name}.
          RETURN "adm-error".
      end.
  end.

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
  {src/adm/template/snd-list.i "param-mi"}

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


