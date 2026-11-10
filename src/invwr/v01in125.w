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
{include/i-prgvrs.i V01IN125 2.00.00.019} /*** "010019" 21/11/2023 17:01:03 ***/

{include/i_fncrowid.i}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN125 MUT}
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
def buffer b-ficha-metodo for ficha-metodo.
def new global shared var gr-ficha-metodo as rowid no-undo.

&IF {&ROWID_READY} = YES &THEN
    def new global shared var v_rec_docto_anexo as rowid no-undo.
&ELSE
    def new global shared var v_rec_docto_anexo as recid no-undo.
&ENDIF

{cdp/cd0666.i} /* utilizado na trigger de delete */

{bhp/bh9999.i1} /* Defini‡Æo Temp-Table TT-TABELA   */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ficha-metodo
&Scoped-define FIRST-EXTERNAL-TABLE ficha-metodo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ficha-metodo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ficha-metodo.descricao ~
ficha-metodo.responsavel ficha-metodo.cod-docto-anexo ~
ficha-metodo.narrativa 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}descricao ~{&FP2}descricao ~{&FP3}~
 ~{&FP1}responsavel ~{&FP2}responsavel ~{&FP3}~
 ~{&FP1}cod-docto-anexo ~{&FP2}cod-docto-anexo ~{&FP3}
&Scoped-define ENABLED-TABLES ficha-metodo
&Scoped-define FIRST-ENABLED-TABLE ficha-metodo
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold bt-docto 
&Scoped-Define DISPLAYED-FIELDS ficha-metodo.fi-codigo ~
ficha-metodo.descricao ficha-metodo.responsavel ~
ficha-metodo.cod-docto-anexo ficha-metodo.narrativa 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS ficha-metodo.fi-codigo 

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
DEFINE BUTTON bt-docto 
     IMAGE-UP FILE "Image~\im-show":U
     IMAGE-INSENSITIVE FILE "image~\ii-show":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 101.14 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 101 BY 9.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ficha-metodo.fi-codigo AT ROW 1.25 COL 18.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     ficha-metodo.descricao AT ROW 2.75 COL 18.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     ficha-metodo.responsavel AT ROW 3.75 COL 18.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     bt-docto AT ROW 4.75 COL 35.72
     ficha-metodo.cod-docto-anexo AT ROW 4.83 COL 18.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     ficha-metodo.narrativa AT ROW 5.96 COL 20.86 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 80 BY 5
          FONT 2
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.ficha-metodo
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
         HEIGHT             = 10.67
         WIDTH              = 101.57.
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

/* SETTINGS FOR FILL-IN ficha-metodo.fi-codigo IN FRAME f-main
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

&Scoped-define SELF-NAME bt-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-docto V-table-Win
ON CHOOSE OF bt-docto IN FRAME f-main
DO:

  if input frame {&frame-name} ficha-metodo.cod-docto-anexo <> "" then do:
     find ficha-metodo 
          WHERE ficha-metodo.fi-codigo = input frame {&frame-name} ficha-metodo.fi-codigo
          no-lock no-error.
     if not avail ficha-metodo then do:
        run utp/ut-msgs.p (input "show",
                           input 16,
                           input "").
        return no-apply.                   
     end.
     find docto_anexo where docto_anexo.cod_docto_anexo = input frame {&frame-name} 
          ficha-metodo.cod-docto-anexo no-lock no-error.
     if avail docto_anexo then do:
        if docto_anexo.cod_catal_docto_anexo <> param-global.cod-catal-docto-anexo
           then do:
           run utp/ut-msgs.p (input 'show':U,
                              input 7596,
                              input string (param-global.cod-catal-docto-anexo)).
           return no-apply.
        end.                      
     end.
     else do:
          {utp/ut-table.i mguni docto_anexo 1}
          run utp/ut-msgs.p (input 'show':U,
                             input 558,
                             input return-value).
          return no-apply.
     end.
     find catal_docto_anexo
          where catal_docto_anexo.cod_catal_docto_anexo = docto_anexo.cod_catal_docto_anexo 
          no-lock no-error.                              
     if avail catal_docto_anexo then do:
        run btb/btb915za.p(input search(trim(catal_docto_anexo.cod_path_catal) + "/":U +
            trim(docto_anexo.nom_arq_ext_docto_anexo))).
     end.       
  end.   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ficha-metodo.cod-docto-anexo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ficha-metodo.cod-docto-anexo V-table-Win
ON F5 OF ficha-metodo.cod-docto-anexo IN FRAME f-main /* Documento Anexo */
DO:
  if avail param-global then 
     run btb/btb002ka.p (input param-global.cod-catal-docto-anexo).

     &IF {&ROWID_READY} = YES &THEN
        find docto_anexo where rowid(docto_anexo) = v_rec_docto_anexo no-lock no-error.
     &ELSE
        find docto_anexo where recid(docto_anexo) = v_rec_docto_anexo no-lock no-error.
     &ENDIF

     assign ficha-metodo.cod-docto-anexo:screen-value = if avail docto_anexo then
     string(docto_anexo.cod_docto_anexo) else "":U.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ficha-metodo.cod-docto-anexo V-table-Win
ON LEAVE OF ficha-metodo.cod-docto-anexo IN FRAME f-main /* Documento Anexo */
DO:
  if input frame {&FRAME-NAME} ficha-metodo.cod-docto-anexo = "" then
     assign bt-docto:sensitive in frame {&FRAME-NAME} = no.
  else
     assign bt-docto:sensitive in frame {&FRAME-NAME} = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ficha-metodo.cod-docto-anexo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ficha-metodo.cod-docto-anexo IN FRAME f-main /* Documento Anexo */
DO:
  apply 'F5' to self.
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

 if ficha-metodo.cod-docto-anexo:load-mouse-pointer('image/lupa.cur') in frame {&frame-name} then.

 {database/tgin/tdp/tdin125.i}

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
  {src/adm/template/row-list.i "ficha-metodo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ficha-metodo"}

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

  /* Ponha aqui a valida‡Æo de chave duplicada */
  if ficha-metodo.fi-codigo:sensitive in frame {&frame-name} = yes
     and can-find(b-ficha-metodo where b-ficha-metodo.fi-codigo =
         input frame {&frame-name} ficha-metodo.fi-codigo) then do:
     {utp/ut-table.i mgind ficha-metodo 1}
     run utp/ut-msgs.p (input 'show',
                        input 1,
                        input return-value).
     apply 'entry' to ficha-metodo.fi-codigo in frame {&frame-name}.      
     return 'ADM-ERROR':U.
  end.
  if input frame {&FRAME-NAME} ficha-metodo.cod-docto-anexo <> "" then do:
     find docto_anexo where docto_anexo.cod_docto_anexo = input frame {&frame-name}  
          ficha-metodo.cod-docto-anexo no-lock no-error.
     if avail docto_anexo then do:
        if docto_anexo.cod_catal_docto_anexo <> param-global.cod-catal-docto-anexo
           then do:
           run utp/ut-msgs.p (input 'show':U,
                              input 7596,
                              input string (param-global.cod-catal-docto-anexo)).
           apply 'entry' to ficha-metodo.cod-docto-anexo in frame {&FRAME-NAME}.                   
           return 'ADM-ERROR':U.
        end.                      
     end.
     else do:
        {utp/ut-table.i mguni docto_anexo 1}
        run utp/ut-msgs.p (input 'show':U,
                           input 558,
                           input return-value).
        apply 'entry' to ficha-metodo.cod-docto-anexo in frame {&FRAME-NAME}.                   
        return 'ADM-ERROR':U.
     end.
  end.   


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

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

  run pi-valida-eliminacao-ficha-metodo.
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
  find first param-global no-lock no-error.

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
  if available ficha-metodo then do:
     assign gr-ficha-metodo = rowid(ficha-metodo).
     find first ficha-metodo where rowid(ficha-metodo) = gr-ficha-metodo no-lock no-error.
     if avail ficha-metodo then
        if ficha-metodo.cod-docto-anexo = "" then 
           assign bt-docto:sensitive in frame {&FRAME-NAME} = no.
        else 
           assign bt-docto:sensitive in frame {&FRAME-NAME} = yes.
     end.      


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

{database/tgin/tdp/tdin125.i1}

run cdp/cd0666.w (input table tt-erro).

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
  {src/adm/template/snd-list.i "ficha-metodo"}

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


