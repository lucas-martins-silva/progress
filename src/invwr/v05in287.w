&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V05IN287 2.00.00.018 } /*** "010018" 11/07/2024 14:46:22 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v05in287 MUT}
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
def var i-ant as integer no-undo.

def new global shared var l-inclui    as logical no-undo.
def new global shared var l-tem-movto as logical no-undo.

def var da-ult-fech-dia-aux as date no-undo.
def var da-mensal-ate-aux   as date no-undo.

def buffer b-estabelec for estabelec.

{cdp/cdcfgman.i}

{cep/ce0101.i3} //l-fechto-gerencial

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
&Scoped-define EXTERNAL-TABLES param-estoq
&Scoped-define FIRST-EXTERNAL-TABLE param-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-estoq.log-1 param-estoq.tipo-pr-med ~
param-estoq.gera-act param-estoq.acerto-aut param-estoq.tip-calc-med ~
param-estoq.num-dec 
&Scoped-define ENABLED-TABLES param-estoq
&Scoped-define FIRST-ENABLED-TABLE param-estoq
&Scoped-Define ENABLED-OBJECTS RECT-12 RECT-13 RECT-16 RECT-17 RECT-18 ~
RECT-19 RECT-21 RECT-6 
&Scoped-Define DISPLAYED-FIELDS param-estoq.log-1 param-estoq.tipo-pr-med ~
param-estoq.fase-medio param-estoq.gera-act param-estoq.acerto-aut ~
param-estoq.tip-calc-med param-estoq.num-dec 
&Scoped-define DISPLAYED-TABLES param-estoq
&Scoped-define FIRST-DISPLAYED-TABLE param-estoq
&Scoped-Define DISPLAYED-OBJECTS l-pm-ja-ini i-val-transf ~
fi-label-tipo-pr-med c-label-transf 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,Lista-de-Objetos,List-5,List-6 */
&Scoped-define Lista-de-Objetos param-estoq.tip-calc-med ~
param-estoq.num-dec 

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
DEFINE VARIABLE c-label-transf AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 19 BY .67 NO-UNDO.

DEFINE VARIABLE fi-label-acerto-aut AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 26 BY .63 NO-UNDO.

DEFINE VARIABLE fi-label-tipo-pr-med AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 15.43 BY .63 NO-UNDO.

DEFINE VARIABLE fi-medio-batch AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15.43 BY .63 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15.43 BY .63 NO-UNDO.

DEFINE VARIABLE i-val-transf AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Item 1", 1,
"Item 2", 2
     SIZE 27.43 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 1.5.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.72 BY 1.5.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 1.5.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 1.5.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 1.5.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 3.25.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 2.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 5.75.

DEFINE VARIABLE l-pm-ja-ini AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 32.29 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-estoq.log-1 AT ROW 1.5 COL 26
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 38 BY .83
     param-estoq.tipo-pr-med AT ROW 3.5 COL 27 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Di rio", 1,
"Mensal", 2
          SIZE 34 BY .83
     param-estoq.fase-medio AT ROW 5.75 COL 4 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "NÆo Calculado", 1,
"Itens Comprados", 2,
"Ord Manuten‡Æo", 3,
"Ord Invest", 4,
"Ord Produ‡Æo", 5
          SIZE 25 BY 4.75
     param-estoq.gera-act AT ROW 5.75 COL 47
          VIEW-AS TOGGLE-BOX
          SIZE 37 BY .88
     l-pm-ja-ini AT ROW 6.75 COL 47
     param-estoq.acerto-aut AT ROW 9.5 COL 50 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sim", 1,
"NÆo", 2
          SIZE 28 BY .83
     i-val-transf AT ROW 11.38 COL 49.86 NO-LABEL
     param-estoq.tip-calc-med AT ROW 11.5 COL 6 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Estab", 1,
"Global", 2
          SIZE 36 BY .88
     param-estoq.num-dec AT ROW 12.75 COL 43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     fi-label-tipo-pr-med AT ROW 2.75 COL 3 NO-LABEL
     FILL-IN-4 AT ROW 4.75 COL 3 NO-LABEL
     fi-medio-batch AT ROW 4.75 COL 46 NO-LABEL
     fi-label-acerto-aut AT ROW 8.5 COL 46 NO-LABEL
     FILL-IN-2 AT ROW 10.75 COL 1 COLON-ALIGNED NO-LABEL
     c-label-transf AT ROW 10.75 COL 44 COLON-ALIGNED NO-LABEL
     RECT-12 AT ROW 11 COL 1
     RECT-13 AT ROW 11 COL 44.29
     RECT-16 AT ROW 1.25 COL 1
     RECT-17 AT ROW 12.5 COL 1
     RECT-18 AT ROW 3 COL 1
     RECT-19 AT ROW 5 COL 44
     RECT-21 AT ROW 8.75 COL 44
     RECT-6 AT ROW 5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-estoq
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
         HEIGHT             = 13.08
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 13.08
       FRAME f-main:WIDTH            = 86.86.

/* SETTINGS FOR FILL-IN c-label-transf IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET param-estoq.fase-medio IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label-acerto-aut IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN fi-label-tipo-pr-med IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-medio-batch IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR RADIO-SET i-val-transf IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-pm-ja-ini IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX param-estoq.log-1 IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN param-estoq.num-dec IN FRAME f-main
   4                                                                    */
/* SETTINGS FOR RADIO-SET param-estoq.tip-calc-med IN FRAME f-main
   4                                                                    */
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

&Scoped-define SELF-NAME param-estoq.fase-medio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.fase-medio V-table-Win
ON ENTRY OF param-estoq.fase-medio IN FRAME f-main /* Fase M‚dio */
DO:
  ASSIGN i-ant = param-estoq.fase-medio.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.fase-medio V-table-Win
ON VALUE-CHANGED OF param-estoq.fase-medio IN FRAME f-main /* Fase M‚dio */
DO:
  RUN utp/ut-msgs.p (INPUT 'show',
                     INPUT 427,
                     INPUT '').
  IF return-value = 'no' THEN DO:
    ASSIGN param-estoq.fase-medio = i-ant.
    DISP param-estoq.fase-medio with frame {&frame-name}.
  END.  
  ELSE ASSIGN i-ant = integer(param-estoq.fase-medio:screen-value).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-val-transf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-val-transf V-table-Win
ON VALUE-CHANGED OF i-val-transf IN FRAME f-main
DO:
    run utp/ut-msgs.p (input 'show', input 28352, input '').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-estoq.log-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.log-1 V-table-Win
ON VALUE-CHANGED OF param-estoq.log-1 IN FRAME f-main
DO:
   if self:checked then do:
      enable  {&Lista-de-Objetos} with frame {&frame-name}.
      assign param-estoq.gera-act:sensitive in frame {&frame-name} = 
             (input frame {&frame-name} param-estoq.tipo-pr-med = 2).
      IF l-inclui = YES or param-estoq.mensal-ate = param-estoq.ult-fech-dia or l-tem-movto = NO
      THEN ASSIGN param-estoq.tipo-pr-med:SENSITIVE IN FRAME {&frame-name} = YES.

   end.   
   else do: 
      disable {&Lista-de-Objetos}     with frame {&frame-name}.         
      disable param-estoq.gera-act    with frame {&frame-name}.
      disable param-estoq.tipo-pr-med with frame {&frame-name}.
   end.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-estoq.tipo-pr-med
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.tipo-pr-med V-table-Win
ON VALUE-CHANGED OF param-estoq.tipo-pr-med IN FRAME f-main /* Pre‡o M‚dio */
DO:
  DEF VAR c-msg AS CHAR NO-UNDO.

  IF NOT AVAIL param-global THEN
        find first param-global no-lock no-error. 
        
  IF AVAIL param-global AND 
  &IF DEFINED (bf_man_206b) &THEN
        param-global.modulo-ch
  &ELSE
        param-global.modulo-cp
  &ENDIF
        THEN DO:
        
          if input frame {&frame-name} param-estoq.tipo-pr-med = 1 THEN DO:
                  RUN utp/ut-msgs.p (INPUT 'show',
                                                         INPUT 51487,
                                                         INPUT '').
                  IF return-value = 'no' THEN DO:
                        ASSIGN param-estoq.tipo-pr-med:SCREEN-VALUE IN frame {&frame-name} = "2" .
                        DISP param-estoq.tipo-pr-med with frame {&frame-name}.
                  END. 
          END.
  
  END.
  
   if input frame {&frame-name} param-estoq.tipo-pr-med = 1 
   then 
      disable param-estoq.gera-act with frame {&frame-name}.
   else 
      enable  param-estoq.gera-act with frame {&frame-name}.

  IF  SELF:SCREEN-VALUE = "1" /*diario*/ THEN DO:
      RUN Get-Field-Screen-Value IN adm-broker-hdl(THIS-PROCEDURE,"l-usa-fech-geren").
      IF  RETURN-VALUE = "yes" THEN DO:
          {utp/ut-liter.i "M‚dio_Di rio"}
          ASSIGN c-msg = TRIM(RETURN-VALUE).
          {utp/ut-liter.i "Fechamento_Gerencial" *}
          RUN utp/ut-msgs.p("show",56972,c-msg + "~~" + TRIM(RETURN-VALUE)).
          ASSIGN SELF:SCREEN-VALUE = "2". //mensal
          RETURN NO-APPLY.
      END.
  END.

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

 {utp/ut-liter.i Usa_c lculo_pre‡o_m‚dio_Batch}
 assign param-estoq.log-1:label in frame {&frame-name} = left-trim(return-value).

 {utp/ut-liter.i Acerto_autom tico_m‚dio_on-line mce l}
 assign fi-label-acerto-aut              = return-value
        fi-label-acerto-aut:screen-value = return-value.

 {utp/ut-liter.i M‚dio_batch mce l}
 assign fi-medio-batch              = return-value
        fi-medio-batch:screen-value = return-value.

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
  {src/adm/template/row-list.i "param-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-estoq"}

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

  {utp/ut-rtlbl.i mgind param-estoq tip-calc-med fill-in-2}
  {utp/ut-rtlbl.i mgind param-estoq fase-medio fill-in-4}    
  {utp/ut-rtlbl.i mgind param-estoq tipo-pr-med fi-label-tipo-pr-med} 
  {utp/ut-liter.i Valoriza_Transferˆncia * L}
  assign c-label-transf:screen-value in frame {&frame-name} = return-value.

 {utp/ut-liter.i Acerto_autom tico_m‚dio_on-line mce l}
 assign fi-label-acerto-aut              = return-value
        fi-label-acerto-aut:screen-value = return-value.

 {utp/ut-liter.i M‚dio_batch mce l}
 assign fi-medio-batch              = return-value
        fi-medio-batch:screen-value = return-value.
        

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

  for each estabelec no-lock 
     where estabelec.usa-mensal <> param-estoq.log-1:   
      find b-estabelec of estabelec exclusive-lock no-error.
      assign b-estabelec.usa-mensal = param-estoq.log-1.
      
      find current b-estabelec no-lock.
  end.    

  if param-estoq.tipo-pr-med = 1 then
     assign param-estoq.gera-act = no.

  assign param-estoq.int-2 = input frame {&frame-name} i-val-transf .

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
  assign i-val-transf = 1.
  IF AVAIL param-estoq THEN
    assign i-val-transf = IF param-estoq.int-2 <> 0 THEN param-estoq.int-2
                          ELSE 1.  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  {utp/ut-rtlbl.i mgind param-estoq tip-calc-med fill-in-2}
  {utp/ut-rtlbl.i mgind param-estoq fase-medio fill-in-4}      
  {utp/ut-rtlbl.i mgind param-estoq tipo-pr-med fi-label-tipo-pr-med}   

  {utp/ut-field.i mgind param-estoq pm-ja-ini 01}
  assign l-pm-ja-ini:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Valoriza_Transferˆncia * L}
  assign c-label-transf:screen-value in frame {&frame-name} = return-value.
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
  def var c-valor as character no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */    
  /* Dispatch standard ADM method.                             */
  
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {varinc/var00083.i 04 1}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN c-valor = RETURN-VALUE + ", 1, " .
    ASSIGN cAuxTraducao001 = {varinc/var00083.i 04 2}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN c-valor = c-valor + RETURN-VALUE + ", 2" 
           i-val-transf:radio-buttons in frame {&frame-name} = c-valor.
&else
    ASSIGN c-valor = {varinc/var00083.i 04 1} + ", 1, "
                   + {varinc/var00083.i 04 2} + ", 2"
             i-val-transf:radio-buttons in frame {&frame-name} = c-valor.
&endif

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  if available param-estoq then do :
     assign param-estoq.fase-medio:sensitive in frame {&frame-name} = no
            param-estoq.tipo-pr-med:sensitive = no.
     if param-estoq.tp-fech = 1 then
         apply "value-changed" to param-estoq.log-1 in frame {&frame-name}.

  end.  
  else 
      disable param-estoq.tipo-pr-med
              param-estoq.fase-medio
              param-estoq.gera-act
              l-pm-ja-ini
              param-estoq.acerto-aut
              param-estoq.num-dec with frame {&frame-name}.  

  IF AVAIL param-estoq THEN DO:
      IF l-inclui = YES OR 
         (param-estoq.mensal-ate = param-estoq.ult-fech-dia AND param-estoq.tp-fech = 1) OR 
         l-tem-movto = NO THEN
         ASSIGN param-estoq.tipo-pr-med:SENSITIVE IN FRAME {&frame-name} = YES.
      
      if param-estoq.tp-fech = 1 then
         assign l-pm-ja-ini:checked in frame {&frame-name} = param-estoq.pm-ja-ini.
      else 
         assign l-pm-ja-ini:checked in frame {&frame-name} = no.
         
      if param-estoq.tp-fech = 2 then 
         disable param-estoq.tipo-pr-med
                 param-estoq.fase-medio
                 param-estoq.gera-act
                 l-pm-ja-ini
                 param-estoq.acerto-aut
                 param-estoq.num-dec with frame {&frame-name}.
  
  END.
  ELSE DO:
      assign l-pm-ja-ini:checked in frame {&frame-name} = no.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita V-table-Win 
PROCEDURE pi-desabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       essa procedure eh chamada pela viewer v03in287.w
------------------------------------------------------------------------------*/
def input param i-tp-fech as i no-undo.
def input param l-agr-estab-emp as logical no-undo.
def input param l-altera as logical no-undo.

if i-tp-fech = 2 then do:    
    IF l-altera THEN DO:
       ASSIGN i-val-transf = 2.
       DISP i-val-transf WITH FRAME {&frame-name}.
    END.   
    
    ASSIGN param-estoq.tip-calc-med:screen-value in frame {&frame-name} = "1".
    
    disable param-estoq.log-1
            param-estoq.tipo-pr-med
            param-estoq.fase-medio
            param-estoq.gera-act            
            l-pm-ja-ini
            param-estoq.acerto-aut
            param-estoq.tip-calc-med
            param-estoq.num-dec with frame {&frame-name}.
            
    IF NOT l-agr-estab-emp THEN 
       DISABLE i-val-transf  WITH FRAME {&frame-name}.
    ELSE      
       ENABLE i-val-transf  WITH FRAME {&frame-name}.           
end.
else do:   /*Fechamento Unico*/
    
    run Get-Field-Screen-Value in adm-broker-hdl (input this-procedure,
                                                  input "mensal-ate").
    assign da-mensal-ate-aux = date(return-value).
    run Get-Field-Screen-Value in adm-broker-hdl (input this-procedure,
                                                  input "ult-fech-dia").
    assign da-ult-fech-dia-aux = date(return-value).

    if  da-mensal-ate-aux = da-ult-fech-dia-aux then
        enable param-estoq.log-1
               param-estoq.tipo-pr-med
               param-estoq.gera-act
               param-estoq.acerto-aut
               param-estoq.tipo-pr-med
               param-estoq.tip-calc-med
               param-estoq.num-dec with frame {&frame-name}.
    else
        disable param-estoq.log-1
                param-estoq.tipo-pr-med
                param-estoq.gera-act
                param-estoq.acerto-aut
                param-estoq.tipo-pr-med
                param-estoq.tip-calc-med
                param-estoq.num-dec with frame {&frame-name}.

    /* Desabilita o parƒmetro "Valoriza Transferencia" quando houver 
    ** uma ou mais NFTs (saida) j  atualizadas nos periodos abertos */
    if  can-find (first movto-estoq
                  where movto-estoq.esp-docto  = 23 /* NFT */
                    and movto-estoq.dt-trans   > da-ult-fech-dia-aux
                    and movto-estoq.tipo-trans = 2 /* Saida */) then
        disable i-val-transf with frame {&frame-name}.
    else
        enable i-val-transf with frame {&frame-name}.

    disable param-estoq.fase-medio
            with frame {&frame-name}.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita V-table-Win 
PROCEDURE pi-habilita :
/*------------------------------------------------------------------------------
  Purpose: Habilita Valoriza Transferˆncia quando o usar o parametro 
    Agrupa Estabelecimentos Por Empresa     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER l-habilita AS LOGICAL NO-UNDO.
    
    IF l-habilita THEN
       ENABLE i-val-transf WITH FRAME {&FRAME-NAME}.
    ELSE 
       DISABLE i-val-transf WITH FRAME {&FRAME-NAME}.

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
  {src/adm/template/snd-list.i "param-estoq"}

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

