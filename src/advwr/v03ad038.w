&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mguni            PROGRESS
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
{include/i-prgvrs.i V03AD038 2.00.00.008}  /*** 010008 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v03ad038 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def buffer b-con-bh-adm for con-bh-adm.
{bhp/bh9800.i1}
{include/i_dbvers.i}

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
&Scoped-define EXTERNAL-TABLES con-bh-adm
&Scoped-define FIRST-EXTERNAL-TABLE con-bh-adm


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR con-bh-adm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS con-bh-adm.cd-banco con-bh-adm.nm-fisico ~
con-bh-adm.ds-banco con-bh-adm.caminho con-bh-adm.service con-bh-adm.host ~
con-bh-adm.parametro 
&Scoped-define ENABLED-TABLES con-bh-adm
&Scoped-define FIRST-ENABLED-TABLE con-bh-adm
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS con-bh-adm.cd-banco con-bh-adm.nm-fisico ~
con-bh-adm.ds-banco con-bh-adm.caminho con-bh-adm.service con-bh-adm.host ~
con-bh-adm.parametro 
&Scoped-define DISPLAYED-TABLES con-bh-adm
&Scoped-define FIRST-DISPLAYED-TABLE con-bh-adm
&Scoped-Define DISPLAYED-OBJECTS c_nm-logico i_ep-codigo l-bco-unificado ~
c-alias 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS c_nm-logico i_ep-codigo 
&Scoped-define ADM-ASSIGN-FIELDS l-bco-unificado c-alias 
&Scoped-define ADM-MODIFY-FIELDS l-bco-unificado c-alias 

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
DEFINE VARIABLE c-alias AS CHARACTER FORMAT "X(256)":U 
     LABEL "Conjunto Alias" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .88 NO-UNDO.

DEFINE VARIABLE c_nm-logico LIKE con-bh-adm.nm-logico
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE i_ep-codigo LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.29.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 9.5.

DEFINE VARIABLE l-bco-unificado AS LOGICAL INITIAL no 
     LABEL "Banco Unificado" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c_nm-logico AT ROW 1.21 COL 24 COLON-ALIGNED
     i_ep-codigo AT ROW 2.17 COL 24 COLON-ALIGNED
     con-bh-adm.cd-banco AT ROW 3.54 COL 24 COLON-ALIGNED HELP
          ""
          LABEL "Nome L¢gico":R7 FORMAT "x(35)"
          VIEW-AS FILL-IN 
          SIZE 45 BY .88
     con-bh-adm.nm-fisico AT ROW 4.54 COL 24 COLON-ALIGNED FORMAT "x(35)"
          VIEW-AS FILL-IN 
          SIZE 45 BY .88
     con-bh-adm.ds-banco AT ROW 5.54 COL 24 COLON-ALIGNED FORMAT "x(100)"
          VIEW-AS FILL-IN 
          SIZE 56 BY .88
     con-bh-adm.caminho AT ROW 6.54 COL 24 COLON-ALIGNED FORMAT "x(150)"
          VIEW-AS FILL-IN 
          SIZE 56 BY .88
     con-bh-adm.service AT ROW 7.54 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 56 BY .88
     con-bh-adm.host AT ROW 8.54 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 56 BY .88
     con-bh-adm.parametro AT ROW 9.54 COL 24 COLON-ALIGNED FORMAT "x(150)"
          VIEW-AS FILL-IN 
          SIZE 56 BY .88
     l-bco-unificado AT ROW 10.54 COL 26
     c-alias AT ROW 11.54 COL 24 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.con-bh-adm
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 11.92
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-alias IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN con-bh-adm.caminho IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN con-bh-adm.cd-banco IN FRAME f-main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN c_nm-logico IN FRAME f-main
   NO-ENABLE 1 LIKE = mgadm.con-bh-adm.nm-logico EXP-SIZE               */
/* SETTINGS FOR FILL-IN con-bh-adm.ds-banco IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN i_ep-codigo IN FRAME f-main
   NO-ENABLE 1 LIKE = mguni.empresa.ep-codigo EXP-SIZE                  */
/* SETTINGS FOR TOGGLE-BOX l-bco-unificado IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN con-bh-adm.nm-fisico IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN con-bh-adm.parametro IN FRAME f-main
   EXP-FORMAT                                                           */
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

&Scoped-define SELF-NAME con-bh-adm.cd-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL con-bh-adm.cd-banco V-table-Win
ON LEAVE OF con-bh-adm.cd-banco IN FRAME f-main /* Nome L¢gico */
DO:
    if con-bh-adm.cd-banco:screen-value = "" 
    then do:
        {utp/ut-liter.i Nome_L¢gico * L}
        run utp/ut-msgs.p ( input "SHOW",
                            input 25938,
                            input trim(return-value)).
        apply "entry":U to con-bh-adm.cd-banco.
        return no-apply.       
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c_nm-logico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c_nm-logico V-table-Win
ON LEAVE OF c_nm-logico IN FRAME f-main /* Nome L¢gico */
DO:
  
    if c_nm-logico:screen-value = "" 
    then do:
        {utp/ut-liter.i Codigo_do_Banco * L}
        run utp/ut-msgs.p ( input "SHOW",
                            input 25938,
                            input trim(return-value)).
        apply "entry":U to c_nm-logico.
        return no-apply.       
    end.
    
    if c_nm-logico:screen-value = "hisadm" 
    then do: 
        DISABLE i_ep-codigo WITH FRAME {&FRAME-NAME}.
        i_ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0". 
    END.
    ELSE ENABLE i_ep-codigo WITH FRAME {&FRAME-NAME}.
   
   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME con-bh-adm.ds-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL con-bh-adm.ds-banco V-table-Win
ON LEAVE OF con-bh-adm.ds-banco IN FRAME f-main /* Descricao */
DO:
      if con-bh-adm.ds-banco:screen-value = "" 
    then do:
        {utp/ut-field.i con-bh-adm.ds-banco * L}
        run utp/ut-msgs.p ( input "SHOW",
                            input 25938,
                            input trim(return-value)).
        apply "entry":U to con-bh-adm.ds-banco.
        return no-apply.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i_ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i_ep-codigo V-table-Win
ON F5 OF i_ep-codigo IN FRAME f-main /* Empresa */
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom="unzoom\z01un004.w"
                      &campo=i_ep-codigo
                      &campozoom=ep-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i_ep-codigo V-table-Win
ON LEAVE OF i_ep-codigo IN FRAME f-main /* Empresa */
DO:
    &IF "{&mguni_version}" >= "2.07A" &THEN
    IF i_ep-codigo:screen-value in frame {&frame-name} <> "" AND NOT CAN-FIND( FIRST empresa WHERE empresa.ep-codigo = i_ep-codigo:screen-value in frame {&frame-name}) THEN DO:
    &ELSE
    IF integer(i_ep-codigo:screen-value in frame {&frame-name}) <> 0 AND NOT CAN-FIND( FIRST empresa WHERE empresa.ep-codigo = integer(i_ep-codigo:screen-value in frame {&frame-name})) THEN DO:
    &ENDIF
        run utp/ut-msgs.p ( input "SHOW",
                            input 12,
                            input i_ep-codigo:screen-value in frame {&frame-name}).
        apply "entry":U to i_ep-codigo.
        return no-apply.  
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i_ep-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i_ep-codigo IN FRAME f-main /* Empresa */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-bco-unificado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-bco-unificado V-table-Win
ON VALUE-CHANGED OF l-bco-unificado IN FRAME f-main /* Banco Unificado */
DO:
    IF l-bco-unificado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "yes" THEN DO:
        ASSIGN c-alias:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    END.
    ELSE DO:
        ASSIGN c-alias:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               c-alias:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME con-bh-adm.nm-fisico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL con-bh-adm.nm-fisico V-table-Win
ON LEAVE OF con-bh-adm.nm-fisico IN FRAME f-main /* Nome F¡sico */
DO:
    if con-bh-adm.nm-fisico:screen-value = "" 
    then do:
        {utp/ut-field.i con-bh-adm.nm-fisico * L}
        run utp/ut-msgs.p ( input "SHOW",
                            input 25938,
                            input trim(return-value)).
        apply "entry":U to con-bh-adm.nm-fisico.
        return no-apply.       
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

  {utp/ut-liter.i Codigo_do_Banco * L}
  assign c_nm-logico:label in frame {&FRAME-NAME} = trim(return-value)
         c_nm-logico:help in frame {&FRAME-NAME} = trim(return-value).
  {utp/ut-liter.i Nome_Logico * L}
  assign con-bh-adm.cd-banco:label in frame {&FRAME-NAME} = trim(return-value)
         con-bh-adm.cd-banco:help in frame {&FRAME-NAME} = trim(return-value).
  if i_ep-codigo:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
   
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
  {src/adm/template/row-list.i "con-bh-adm"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "con-bh-adm"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/


    /* Code placed here will execute PRIOR to standard behavior. */
    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.
    
    

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    IF c_nm-logico:screen-value = "hisadm" THEN
        ASSIGN i_ep-codigo:SCREEN-VALUE = "0".
    
    IF i_ep-codigo:SCREEN-VALUE <> "0" AND i_ep-codigo:SCREEN-VALUE <> "" THEN
        ASSIGN con-bh-adm.nm-logico = c_nm-logico:SCREEN-VALUE  + "," + i_ep-codigo:SCREEN-VALUE.
    ELSE
        ASSIGN con-bh-adm.nm-logico = c_nm-logico:SCREEN-VALUE.

    assign  con-bh-adm.tipo = 2.

    &IF '{&mgadm_version}' < '2.05' &THEN
        ASSIGN con-bh-adm.log-1 = INPUT FRAME {&frame-name} l-bco-unificado
               con-bh-adm.char-1 = INPUT FRAME {&FRAME-NAME} c-alias.
    &ELSE
        ASSIGN con-bh-adm.log_bco_unif = INPUT FRAME {&frame-name} l-bco-unificado
               con-bh-adm.dsl_alias = INPUT FRAME {&FRAME-NAME} c-alias.
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    find first b-con-bh-adm
         where b-con-bh-adm.nm-logico = c_nm-logico:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "," +
                                        i_ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
         no-lock no-error.
   
    IF NOT AVAIL b-con-bh-adm AND INTEGER(i_ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = 0 THEN
        find first b-con-bh-adm
            where b-con-bh-adm.nm-logico = c_nm-logico:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
            no-lock no-error.

    if  avail b-con-bh-adm
    then do:
        {utp/ut-table.i mgadm con-bh-adm 1}
        run utp/ut-msgs.p ( input "SHOW",
                            input 1,
                            input trim(return-value)).
    
        return 'ADM-ERROR':U.
    end.



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

  IF  AVAIL con-bh-adm
  AND NOT adm-new-record THEN DO:
  &IF '{&mgadm_version}' < '2.05' &THEN
      ASSIGN l-bco-unificado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(con-bh-adm.log-1)
             c-alias:SCREEN-VALUE IN FRAME {&FRAME-NAME} = con-bh-adm.char-1.
  &ELSE
      ASSIGN l-bco-unificado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(con-bh-adm.log_bco_unif)
             c-alias:SCREEN-VALUE IN FRAME {&FRAME-NAME} = con-bh-adm.dsl_alias.
  &ENDIF
      ASSIGN c_nm-logico:SCREEN-VALUE = ENTRY(1,con-bh-adm.nm-logico).
      IF NUM-ENTRIES(con-bh-adm.nm-logico) > 1 THEN 
          ASSIGN i_ep-codigo:SCREEN-VALUE = ENTRY(2,con-bh-adm.nm-logico).   
      ELSE
          ASSIGN i_ep-codigo:SCREEN-VALUE = "".


  END.

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
/*     if adm-new-record = yes then */
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    APPLY "value-changed" TO l-bco-unificado IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    &if "{&mgadm_version}":U < "2.05":U &then
        for each con-bh-com exclusive-lock:
            find first con-bh-adm exclusive-lock
                 where con-bh-adm.nm-logico = con-bh-com.nm-logico
                 no-error.
        
            if  not avail con-bh-adm
            then do:
                create  con-bh-adm.
                assign  con-bh-adm.nm-logico = con-bh-com.nm-logico.
            end.
            
            assign  con-bh-adm.cd-banco     = con-bh-com.cd-banco
                    con-bh-adm.ds-banco     = con-bh-com.ds-banco
                    con-bh-adm.nm-fisico    = con-bh-com.nm-fisico
                    con-bh-adm.caminho      = con-bh-com.caminho
                    con-bh-adm.host         = con-bh-com.host
                    con-bh-adm.parametro    = con-bh-com.parametro
                    con-bh-adm.service      = con-bh-com.service
                    con-bh-adm.tipo         = con-bh-com.tipo.
            delete  con-bh-com.
        end.
        for each con-bh-ind exclusive-lock:
            find first con-bh-adm exclusive-lock
                 where con-bh-adm.nm-logico = con-bh-ind.nm-logico
                 no-error.
            
            if  not avail con-bh-adm
            then do:
                create  con-bh-adm.
                assign  con-bh-adm.nm-logico = con-bh-ind.nm-logico.
            end.
            
            assign  con-bh-adm.cd-banco     = con-bh-ind.cd-banco
                    con-bh-adm.ds-banco     = con-bh-ind.ds-banco
                    con-bh-adm.nm-fisico    = con-bh-ind.nm-fisico
                    con-bh-adm.caminho      = con-bh-ind.caminho
                    con-bh-adm.host         = con-bh-ind.host
                    con-bh-adm.parametro    = con-bh-ind.parametro
                    con-bh-adm.service      = con-bh-ind.service
                    con-bh-adm.tipo         = con-bh-ind.tipo.
            delete  con-bh-ind.
        end.
    &endif
    
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  {utp/ut-liter.i "Banco Unificado" * L}
  ASSIGN l-bco-unificado:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  {utp/ut-liter.i "Conjunto Alias" * L}
  ASSIGN c-alias:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

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


/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-conexao V-table-Win 
PROCEDURE pi-verifica-conexao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*** Conecta Base de Dados - Bancos Hist¢ricos ***/
    for each tt-param-bh:
        delete tt-param-bh.
    end.
    find first param-global no-lock no-error.
    &IF "{&mguni_version}" >= "2.07A" &THEN
    IF i_ep-codigo:screen-value in frame {&FRAME-NAME} <> "" AND param-global.empresa-prin <> i_ep-codigo:screen-value in frame {&FRAME-NAME} AND
    &ELSE
    IF INTEGER(i_ep-codigo:screen-value in frame {&FRAME-NAME}) <> 0 AND param-global.empresa-prin <> INTEGER(i_ep-codigo:screen-value in frame {&FRAME-NAME}) AND
    &ENDIF
       c_nm-logico:screen-value in frame {&FRAME-NAME} <> "hisadm" THEN DO:

        run utp/ut-msgs.p ( input "SHOW",
                    input 28270,
                    input i_ep-codigo:screen-value in frame {&FRAME-NAME} + "~~" + STRING(param-global.empresa-prin)).

        RETURN NO-APPLY.
    END.

    create  tt-param-bh.
    assign  
            tt-param-bh.banco                 = trim(c_nm-logico:screen-value in frame {&FRAME-NAME})
            tt-param-bh.tp-banco              = 2
            tt-param-bh.cod-versao-integracao = 1.

    run bhp/bh9800.p (  input table tt-param-bh,
                        output table tt-erro).

  
    find first tt-erro no-lock no-error.
    if  avail tt-erro
    then do:
        find first tt-erro no-error.
        if  avail tt-erro
        then  run utp/ut-msgs.p (   input "SHOW",
                                    input 17477,
                                    input tt-erro.mensagem).
    end.
    else do:
        {utp/ut-liter.i "Conexao com sucesso" * 1}
        run utp/ut-msgs.p ( input "SHOW",
                            input 19085,
                            input trim(return-value)).
        run bhp/bh9810.p (  input trim(c_nm-logico:screen-value in frame {&FRAME-NAME})).
    end.

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
  {src/adm/template/snd-list.i "con-bh-adm"}

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

