&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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
{include/i-prgvrs.i  2.00.00.003}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i  MUT}
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

def new global shared var gr-param-estoq as rowid  no-undo.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-estoq
&Scoped-define FIRST-EXTERNAL-TABLE param-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-estoq.tem-moeda1 param-estoq.moeda1 ~
param-estoq.tp-ct-moeda1 param-estoq.tem-moeda2 param-estoq.moeda2 ~
param-estoq.tp-ct-moeda2 param-estoq.mensal-ate 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}moeda1 ~{&FP2}moeda1 ~{&FP3}~
 ~{&FP1}moeda2 ~{&FP2}moeda2 ~{&FP3}~
 ~{&FP1}mensal-ate ~{&FP2}mensal-ate ~{&FP3}
&Scoped-define ENABLED-TABLES param-estoq
&Scoped-define FIRST-ENABLED-TABLE param-estoq
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-1 RECT-2 RECT-3 
&Scoped-Define DISPLAYED-FIELDS param-estoq.tem-moeda1 param-estoq.moeda1 ~
param-estoq.tp-ct-moeda1 param-estoq.tem-moeda2 param-estoq.moeda2 ~
param-estoq.tp-ct-moeda2 param-estoq.mensal-ate 
&Scoped-Define DISPLAYED-OBJECTS c-descricao-1 c-descricao-2 

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
DEFINE VARIABLE c-descricao-1 AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88.

DEFINE VARIABLE c-descricao-2 AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88.

DEFINE VARIABLE c-text-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-text-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 70 BY 3.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 70 BY 3.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 70 BY 1.88.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72 BY 10.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-estoq.tem-moeda1 AT ROW 1.54 COL 32
          VIEW-AS TOGGLE-BOX
          SIZE 29.57 BY .88
     param-estoq.moeda1 AT ROW 2.54 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     c-descricao-1 AT ROW 2.54 COL 34 COLON-ALIGNED NO-LABEL
     c-text-1 AT ROW 3.54 COL 14 COLON-ALIGNED NO-LABEL
     param-estoq.tp-ct-moeda1 AT ROW 3.54 COL 32 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Di†ria", 1,
"Mensal", 2,
"MÇdia", 3
          SIZE 29.29 BY .88
     param-estoq.tem-moeda2 AT ROW 5.5 COL 32
          VIEW-AS TOGGLE-BOX
          SIZE 29.57 BY .88
     param-estoq.moeda2 AT ROW 6.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     c-descricao-2 AT ROW 6.5 COL 34 COLON-ALIGNED NO-LABEL
     c-text-2 AT ROW 7.5 COL 14 COLON-ALIGNED NO-LABEL
     param-estoq.tp-ct-moeda2 AT ROW 7.5 COL 32 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Di†ria", 1,
"Mensal", 2,
"MÇdia", 3
          SIZE 29.29 BY .88
     param-estoq.mensal-ate AT ROW 9.63 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     rt-mold AT ROW 1 COL 2
     RECT-1 AT ROW 1.25 COL 3
     RECT-2 AT ROW 5.04 COL 3
     RECT-3 AT ROW 9.08 COL 3
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
         HEIGHT             = 10.38
         WIDTH              = 73.72.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Default                                      */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-descricao-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-text-1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-text-2 IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME param-estoq.moeda1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.moeda1 V-table-Win
ON ENTRY OF param-estoq.moeda1 IN FRAME f-main /* Moeda Alternativa 1 */
DO:
  /*if input frame {&frame-name} param-estoq.tem-moeda1 = no
 *   then do : run utp/ut-msgs.p (input "show" , input 1140, input string(1) ).
 *             apply 'entry' to param-estoq.tem-moeda1 in frame f-main.
 *        end .
 *   
 *   */
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.moeda1 V-table-Win
ON F5 OF param-estoq.moeda1 IN FRAME f-main /* Moeda Alternativa 1 */
DO:
  assign l-implanta = no.
  {include/zoomvar.i &prog-zoom="unzoom/z01un005.w"
                     &campo=param-estoq.moeda1
                     &campozoom=mo-codigo
                     &campo2=c-descricao-1
                     &campozoom2=descricao}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.moeda1 V-table-Win
ON LEAVE OF param-estoq.moeda1 IN FRAME f-main /* Moeda Alternativa 1 */
DO:

 if input frame {&frame-name} param-estoq.tem-moeda1 = no
  then do : run utp/ut-msgs.p (input "show" , input 1140, input string(1) ).
            assign  param-estoq.moeda1 = 0.
            display param-estoq.moeda1 with  frame {&frame-name}.
       end .
  
{include/leave.i &tabela=moeda 
            &atributo-ref= descricao
            &variavel-ref=c-descricao-1
            &where="moeda.mo-codigo = input frame {&frame-name} param-estoq.moeda1"}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.moeda1 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-estoq.moeda1 IN FRAME f-main /* Moeda Alternativa 1 */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-estoq.moeda2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.moeda2 V-table-Win
ON ENTRY OF param-estoq.moeda2 IN FRAME f-main /* Moeda Alternativa 2 */
DO:
  /*if input frame {&frame-name} param-estoq.tem-moeda2 = no
 *   then do : run utp/ut-msgs.p (input "show" , input 1140, input string(2) ).
 *             apply 'entry' to param-estoq.tem-moeda2 in frame {&frame-name} .
 *        end .*/
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.moeda2 V-table-Win
ON F5 OF param-estoq.moeda2 IN FRAME f-main /* Moeda Alternativa 2 */
DO: 
  assign l-implanta = no.
                     
  {include/zoomvar.i &prog-zoom="unzoom/z01un005.w"
                     &campo=param-estoq.moeda2
                     &campozoom=mo-codigo
                     &campo2=c-descricao-2
                     &campozoom2=descricao}                     
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.moeda2 V-table-Win
ON LEAVE OF param-estoq.moeda2 IN FRAME f-main /* Moeda Alternativa 2 */
DO:
 if input frame {&frame-name} param-estoq.tem-moeda2 = no
  then do : run utp/ut-msgs.p (input "show" , input 1140, input string(2) ).        
            assign  param-estoq.moeda2 = 0.
            display param-estoq.moeda2 with  frame {&frame-name}.
       end . 
{include/leave.i &tabela=moeda 
                   &atributo-ref=descricao
                   &variavel-ref=c-descricao-2
                   &where="moeda.mo-codigo = input frame {&frame-name} param-estoq.moeda2"}
                                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.moeda2 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-estoq.moeda2 IN FRAME f-main /* Moeda Alternativa 2 */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
if param-estoq.moeda1:load-mouse-pointer("image/lupa.cur") in frame {&FRAME-NAME} then.
if param-estoq.moeda2:load-mouse-pointer("image/lupa.cur") in frame {&FRAME-NAME} then. 

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF       
    
 {utp/ut-rtlbl.i mgind param-estoq tp-ct-moeda1 c-text-1} 
 {utp/ut-rtlbl.i mgind param-estoq tp-ct-moeda2 c-text-2}
 
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
 
  IF  AVAIL moeda THEN DO:
      FIND moeda WHERE moeda.mo-codigo = param-estoq.moeda1 NO-LOCK NO-ERROR.
      ASSIGN c-descricao-1 = IF AVAIL moeda THEN moeda.descricao ELSE "":U.
  END. /* moeda-1 */ 
  
  IF  AVAIL moeda THEN DO:
      FIND moeda WHERE moeda.mo-codigo = param-estoq.moeda2 NO-LOCK NO-ERROR.
      ASSIGN c-descricao-2 = IF AVAIL moeda THEN moeda.descricao ELSE "":U.
  END. /* moeda-1 */
  
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

   /* FIND FIRST param-estoq  NO-LOCK NO-ERROR.
 *     IF NOT AVAILABLE (param-estoq)  THEN DO:
 *       /* cria o registro caso n∆o exista */
 *       CREATE param-estoq.
 *     END.
 *     RUN new-state ('update-begin':U).
 *   
 * */
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

  /* Code placed here will execute AFTER standard behavior.    */
   
 {utp/ut-rtlbl.i mgind param-estoq tp-ct-moeda1 c-text-1}  
 {utp/ut-rtlbl.i mgind param-estoq tp-ct-moeda2 c-text-2} 

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


