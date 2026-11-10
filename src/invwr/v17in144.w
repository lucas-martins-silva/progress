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
{include/i-prgvrs.i V17IN144 2.00.01.015}  /*** 010115 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v17in144 MUT}
&ENDIF



/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w
define new global shared var gr-grup-maquina     as rowid no-undo.
define new global shared var c-programa-chamador as char  no-undo.

def var v-row-parent as rowid no-undo.
def var c-param      as char format "x(40)".
def var h_handle     as handle.
def var i-tipo       as int no-undo.
def var l-log-principal as log no-undo.
DEFINE VARIABLE cb-ind-tempo-operac-aux AS CHARACTER  NO-UNDO.

{cdp/cd0666.i} /* utilizado na trigger de delete */

{cdp/cdcfgman.i}

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
&Scoped-define EXTERNAL-TABLES grup-maquina
&Scoped-define FIRST-EXTERNAL-TABLE grup-maquina


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR grup-maquina.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS grup-maquina.descricao ~
grup-maquina.nr-up-hora grup-maquina.cd-calen grup-maquina.ind-utiliz 
&Scoped-define ENABLED-TABLES grup-maquina
&Scoped-define FIRST-ENABLED-TABLE grup-maquina
&Scoped-define DISPLAYED-TABLES grup-maquina
&Scoped-define FIRST-DISPLAYED-TABLE grup-maquina
&Scoped-Define ENABLED-OBJECTS cb-ind-tempo-operac RECT-1 rt-mold 
&Scoped-Define DISPLAYED-FIELDS grup-maquina.descricao ~
grup-maquina.nr-up-hora grup-maquina.cd-calen grup-maquina.ind-utiliz 
&Scoped-Define DISPLAYED-OBJECTS c-desc-calen tg-gm-principal ~
cb-ind-tempo-operac rs-tipo fi-text-1 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS grup-maquina.descricao ~
grup-maquina.nr-up-hora grup-maquina.cd-calen grup-maquina.ind-utiliz ~
cb-ind-tempo-operac rs-tipo 

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
DEFINE VARIABLE cb-ind-tempo-operac AS CHARACTER FORMAT "x(20)" INITIAL "1" 
     LABEL "Tratamento Tempo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 22.43 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-calen AS CHARACTER FORMAT "X(40)":U
     VIEW-AS FILL-IN
     SIZE 40.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-text-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14.29 BY .67 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Item 1", 1,
"Item 2", 2
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 32.43 BY 1.71.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.14 BY 8.38.

DEFINE VARIABLE tg-gm-principal AS LOGICAL INITIAL no 
     LABEL "GM Principal" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     grup-maquina.descricao AT ROW 1.29 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 33.14 BY .88
     grup-maquina.nr-up-hora AT ROW 2.5 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.86 BY .88
     grup-maquina.cd-calen AT ROW 3.71 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .88
     c-desc-calen AT ROW 3.71 COL 31.43 COLON-ALIGNED NO-LABEL
     tg-gm-principal AT ROW 4.75 COL 55
     grup-maquina.ind-utiliz AT ROW 4.96 COL 19.86
          VIEW-AS TOGGLE-BOX
          SIZE 23.86 BY .83
     cb-ind-tempo-operac AT ROW 5.92 COL 17.72 COLON-ALIGNED HELP
          "Tratamento do tempo de operaá∆o"
     rs-tipo AT ROW 7.71 COL 24.57 NO-LABEL
     fi-text-1 AT ROW 7.71 COL 4.72 NO-LABEL
     RECT-1 AT ROW 7.21 COL 19.72
     rt-mold AT ROW 1.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.grup-maquina
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
         HEIGHT             = 8.54
         WIDTH              = 85.14.
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

/* SETTINGS FOR FILL-IN c-desc-calen IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-ind-tempo-operac IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN grup-maquina.cd-calen IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN grup-maquina.descricao IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN fi-text-1 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR TOGGLE-BOX grup-maquina.ind-utiliz IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN grup-maquina.nr-up-hora IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR RADIO-SET rs-tipo IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX tg-gm-principal IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       tg-gm-principal:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME grup-maquina.cd-calen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cd-calen V-table-Win
ON F5 OF grup-maquina.cd-calen IN FRAME f-main /* Calend†rio */
DO:
   l-implanta = yes.
   {include/zoom.i &prog-zoom="inzoom/z01in026.w"
                   &tabela=grup-maquina
                   &atributo=cd-calen}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cd-calen V-table-Win
ON LEAVE OF grup-maquina.cd-calen IN FRAME f-main /* Calend†rio */
DO:
   {include/leave.i &tabela=calen-gener
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-calen
                   &where="calen-gener.cd-calen = input frame {&frame-name} grup-maquina.cd-calen"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cd-calen V-table-Win
ON MOUSE-SELECT-DBLCLICK OF grup-maquina.cd-calen IN FRAME f-main /* Calend†rio */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  
 if grup-maquina.cd-calen:load-mouse-pointer ("image~\lupa.cur") then.

 &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  
  
  /************************ INTERNAL PROCEDURES ********************/

{database/tgin/tdp/tdin144.i}

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
  {src/adm/template/row-list.i "grup-maquina"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "grup-maquina"}

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

  assign rs-tipo:screen-value in frame {&frame-name} = "1".

  {utp/ut-liter.i Tipo:}
  assign fi-text-1:screen-value in frame {&frame-name} = return-value.

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

    {include/i-valid.i}

    assign i-tipo = input frame {&frame-name} rs-tipo
           l-log-principal = tg-gm-principal:checked in frame {&frame-name}.
    
     if tg-gm-principal:checked in frame {&frame-name} = no then do:
        if can-find(first gm-estrut 
                    where gm-estrut.gm-pai = grup-maquina.gm-codigo) 
                    then do:
               /*N∆o pode desmarcar a flag, pq possui filhos na estrutura de GMs*/         
              run utp/ut-msgs.p (input "show",
                                 input 28518,
                                 input ""). 
              apply "entry" to tg-gm-principal in frame {&frame-name}.
              return 'ADM-ERROR':U.                    
        end.
     end.
     else do:    
        find first gm-estrut 
             where gm-estrut.gm-filho = grup-maquina.gm-codigo no-lock no-error.
        if avail gm-estrut then do:
              /*N∆o pode marcar a flag, se pertencer a estrutura de algum GM principal*/      
              run utp/ut-msgs.p (input "show",
                                 input 28519,
                                 input gm-estrut.gm-pai). 
              apply "entry" to tg-gm-principal in frame {&frame-name}.
              return 'ADM-ERROR':U.                
        end.
     end.
     
     ASSIGN cb-ind-tempo-operac-aux = cb-ind-tempo-operac:SCREEN-VALUE IN FRAME f-main.

    

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    assign substring(grup-maquina.char-1,1,1) = string(i-tipo).    
    
    if c-programa-chamador = "cd0111" then do:
          RUN Who-Is-The-Container IN adm-broker-hdl
              (INPUT this-procedure,
               OUTPUT h_handle).    
          run pi-habilita-bt in h_handle(input yes).    
    end.
  
    assign grup-maquina.ind-tempo-operac = {ininc/i06in144.i 06 cb-ind-tempo-operac-aux }
           grup-maquina.log-principal = l-log-principal.

  
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

  run pi-valida-eliminacao-grup-maquina.
  if  return-value <> "ok" then do:
      run pi-mostra-erros.
      return "ADM-ERROR".
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
    
    if c-programa-chamador = "cd0111" then do:
        RUN Who-Is-The-Container IN adm-broker-hdl
            (INPUT this-procedure,
             OUTPUT h_handle).     
        run pi-habilita-bt in h_handle(input yes).
    end.
     
    disable cb-ind-tempo-operac with frame {&FRAME-NAME}.
    
    assign tg-gm-principal:sensitive in frame {&frame-name} = no.
  
      
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

  If avail grup-maquina then do:
     assign cb-ind-tempo-operac:screen-value in frame {&FRAME-NAME} = {ininc/i06in144.i 04 grup-maquina.ind-tempo-operac}.
  
     find calen-gener  where calen-gener.cd-calen   eq grup-maquina.cd-calen no-lock no-error.
     assign c-desc-calen = if avail calen-gener then calen-gener.descricao else "":U
            rs-tipo      = if substring(grup-maquina.char-1,1,1) <> "" then
                               int(substring(grup-maquina.char-1,1,1))
                           else 1.
  End.

    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  {utp/ut-liter.i Tipo:}
  assign fi-text-1:screen-value in frame {&frame-name} = return-value.
    
   if avail grup-maquina then
      assign tg-gm-principal:checked in frame {&frame-name} = grup-maquina.log-principal.

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
/*    if adm-new-record = yes then */
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    if param-global.modulo-sws = no then
        assign rs-tipo:visible in frame {&frame-name} = no.

  if c-programa-chamador = "cd0111" then do:
      RUN Who-Is-The-Container IN adm-broker-hdl
          (INPUT this-procedure,
           OUTPUT h_handle).     
      run pi-habilita-bt in h_handle(input no).
  end.
  
  enable cb-ind-tempo-operac with frame {&FRAME-NAME}.
  
  assign tg-gm-principal:sensitive in frame {&frame-name} = yes.
  
  
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

    {utp/ut-field.i mgind grup-maquina ind-tempo-operac 1}

    assign cb-ind-tempo-operac:label in frame {&frame-name} = return-value
           cb-ind-tempo-operac:list-items = {ininc/i06in144.i 03}.
    
    find first param-global no-lock no-error.
    if param-global.modulo-sws = no then
        assign rs-tipo:visible          in frame {&frame-name} = no
               rect-1:visible           in frame {&frame-name} = no
               fi-text-1:visible        in frame {&frame-name} = no.
               

    {utp/ut-liter.i GM_Principal *}
    assign tg-gm-principal:label in frame {&frame-name} = return-value
           tg-gm-principal:hidden in frame {&frame-name} = no. 
           

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  {utp/ut-liter.i Tipo:}
  assign rs-tipo:radio-buttons  in frame {&frame-name} = {ininc/i01in084.i 07}
         fi-text-1:screen-value in frame {&frame-name} = return-value.

  
  disable cb-ind-tempo-operac with frame {&FRAME-NAME}.
    
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

  if available grup-maquina then
      assign gr-grup-maquina = rowid(grup-maquina).
      
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-erros V-table-Win 
PROCEDURE pi-mostra-erros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

for each tt-erro:
    delete tt-erro.
end.

{database/tgin/tdp/tdin144.i1}

run cdp/cd0666.w (input table tt-erro).

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
  {src/adm/template/snd-list.i "grup-maquina"}

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

