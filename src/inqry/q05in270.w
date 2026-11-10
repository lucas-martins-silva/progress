&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS q-tables 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i  2.00.00.002}
/*------------------------------------------------------------------------
 
  File:  
 
  Description: from QUERY.W - Template For Query objects in the ADM
 
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
&Scop adm-attribute-dlg support/queryd.w
 
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
def var c-nr-ord-manut-anterior like ord-taref.nr-ord-produ /*initial 0*/ no-undo.
/*def var c-cd-tag-anterior     like man-eq-tag.cd-tag     initial "" no-undo.*/
/*define new global shared var c-ord-manut as integer /*no-undo*/.*/
/*define new global shared var c-tag     as character no-undo.*/
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 
 
/* ********************  Preprocessor Definitions  ******************** */
 
&Scoped-define PROCEDURE-TYPE SmartQuery
 
&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,Navigation-Target
 
&Scoped-define QUERY-NAME Query-Main
 
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ord-manut ord-taref
 
/* Definitions for QUERY Query-Main                                     */
&Scoped-define SELF-NAME Query-Main
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY {&SELF-NAME} FOR EACH ord-manut       WHERE ord-manut.estado-om <> 4 NO-LOCK, ~
             EACH ord-taref OF ord-manut       WHERE ord-taref.aceite = TRUE NO-LOCK.
&Scoped-define TABLES-IN-QUERY-Query-Main ord-manut ord-taref
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ord-manut
 
 
/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
 
/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME
 
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" q-tables _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&QUERY-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
al-codigo||y|movind.ord-manut.al-codigo
cd-causa-padr||y|movind.ord-manut.cd-causa-padr
cd-equipto||y|movind.ord-manut.cd-equipto
nr-ord-produ||y|movind.ord-manut.nr-ord-produ
cd-interv-padr||y|movind.ord-manut.cd-interv-padr
cd-manut||y|movind.ord-manut.cd-manut
sequencia||y|movind.ord-manut.sequencia
cd-parada||y|movind.ord-manut.cd-parada
cd-tag||y|movind.ord-manut.cd-tag
cd-pend-padr||y|movind.ord-manut.cd-pend-padr
cd-planejado||y|movind.ord-manut.cd-planejado
cd-projeto||y|movind.ord-manut.cd-projeto
nr-rot-insp||y|movind.ord-manut.nr-rot-insp
nr-rot-lubr||y|movind.ord-manut.nr-rot-lubr
cd-sint-padr||y|movind.ord-manut.cd-sint-padr
cd-tipo||y|movind.ord-manut.cd-tipo
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "al-codigo,cd-causa-padr,cd-equipto,nr-ord-produ,cd-interv-padr,cd-manut,sequencia,cd-parada,cd-tag,cd-pend-padr,cd-planejado,cd-projeto,nr-rot-insp,nr-rot-lubr,cd-sint-padr,cd-tipo"':U).
 
/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" q-tables _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&QUERY-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS>
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE>
<FILTER-ATTRIBUTES>
************************
* Initialize Filter Attributes */
RUN set-attribute-list IN THIS-PROCEDURE ('
  Filter-Value=':U).
/************************
</FILTER-ATTRIBUTES> */   
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
/* ***********************  Control Definitions  ********************** */
 
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ord-manut, 
      ord-taref SCROLLING.
&ANALYZE-RESUME
 
/* ************************  Frame Definitions  *********************** */
 
 
 
/* *********************** Procedure Settings ************************ */
 
&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartQuery
   Allow: Basic,Query
   Frames: 1
   Add Fields to: NEITHER
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
  CREATE WINDOW q-tables ASSIGN
         HEIGHT             = 1.33
         WIDTH              = 22.
                                                                        */
&ANALYZE-RESUME
 
 
/* ***************  Runtime Attributes and UIB Settings  ************** */
 
&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW q-tables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME
 
 
/* Setting information for Queries and Browse Widgets fields            */
 
&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for QUERY Query-Main
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ord-manut
      WHERE ord-manut.estado-om <> 4 NO-LOCK,
      EACH ord-taref OF ord-manut
      WHERE ord-taref.aceite = TRUE NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Design-Parent    is WINDOW q-tables @ ( 1.17 , 9.14 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME
 
 
 
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB q-tables 
/* ************************* Included-Libraries *********************** */
 
{src/adm/method/query.i}
{include/c-query.i}
{utp/ut-glob.i}
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
 
 
/* ************************  Control Triggers  ************************ */
 
&Scoped-define SELF-NAME Query-Main
&UNDEFINE SELF-NAME
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK q-tables 
 
 
/* ***************************  Main Block  *************************** */
 
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
/* **********************  Internal Procedures  *********************** */
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases q-tables adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR Filter-Value AS CHAR NO-UNDO.
 
  /* Copy 'Filter-Attributes' into local variables. */
  RUN get-attribute ('Filter-Value':U).
  Filter-Value = RETURN-VALUE.
 
  /* No Foreign keys are accepted by this SmartObject. */
 
  {&OPEN-QUERY-{&QUERY-NAME}}
 
END PROCEDURE.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available q-tables _ADM-ROW-AVAILABLE
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
 
  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}
 
END PROCEDURE.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI q-tables _DEFAULT-DISABLE
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
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-get-first q-tables 
PROCEDURE local-get-first :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
 
   assign c-nr-ord-manut-anterior = 0.
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'get-first':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-get-last q-tables 
PROCEDURE local-get-last :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
 
   assign c-nr-ord-manut-anterior = 0.
 
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'get-last':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-get-next q-tables 
PROCEDURE local-get-next :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
  if avail ord-taref then do:
     assign c-nr-ord-manut-anterior = ord-manut.nr-ord-produ. 
 
repeat while avail ord-taref:
    get next {&query-name} no-lock.
    if  avail ord-taref then do:
        if  ord-taref.nr-ord-produ = c-nr-ord-manut-anterior then
            next.
        else do:
            get prev {&query-name} no-lock.
            leave.
        end.
    end.
    else do:
        get last {&query-name} no-lock.      
        leave.
    end.
end.
 
end.
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'get-next':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-get-prev q-tables 
PROCEDURE local-get-prev :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
  assign c-nr-ord-manut-anterior = ord-manut.nr-ord-produ. 
 
  repeat while avail ord-taref:
    get prev {&query-name} no-lock.
    if  avail ord-taref then do:
        if  ord-taref.nr-ord-produ = c-nr-ord-manut-anterior then
            next.
        else do:
            get next {&query-name} no-lock.
            leave.
        end.
    end.
    else do:
        get first {&query-name} no-lock.      
        leave.
    end.
end.
 
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'get-prev':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key q-tables adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/
 
  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}
 
  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "al-codigo" "ord-manut" "al-codigo"}
  {src/adm/template/sndkycas.i "cd-causa-padr" "ord-manut" "cd-causa-padr"}
  {src/adm/template/sndkycas.i "cd-equipto" "ord-manut" "cd-equipto"}
  {src/adm/template/sndkycas.i "nr-ord-produ" "ord-manut" "nr-ord-produ"}
  {src/adm/template/sndkycas.i "cd-interv-padr" "ord-manut" "cd-interv-padr"}
  {src/adm/template/sndkycas.i "cd-manut" "ord-manut" "cd-manut"}
  {src/adm/template/sndkycas.i "sequencia" "ord-manut" "sequencia"}
  {src/adm/template/sndkycas.i "cd-parada" "ord-manut" "cd-parada"}
  {src/adm/template/sndkycas.i "cd-tag" "ord-manut" "cd-tag"}
  {src/adm/template/sndkycas.i "cd-pend-padr" "ord-manut" "cd-pend-padr"}
  {src/adm/template/sndkycas.i "cd-planejado" "ord-manut" "cd-planejado"}
  {src/adm/template/sndkycas.i "cd-projeto" "ord-manut" "cd-projeto"}
  {src/adm/template/sndkycas.i "nr-rot-insp" "ord-manut" "nr-rot-insp"}
  {src/adm/template/sndkycas.i "nr-rot-lubr" "ord-manut" "nr-rot-lubr"}
  {src/adm/template/sndkycas.i "cd-sint-padr" "ord-manut" "cd-sint-padr"}
  {src/adm/template/sndkycas.i "cd-tipo" "ord-manut" "cd-tipo"}
 
  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}
 
END PROCEDURE.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records q-tables _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/
 
  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}
 
  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ord-manut"}
  {src/adm/template/snd-list.i "ord-taref"}
 
  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}
 
END PROCEDURE.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed q-tables 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
 
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/qstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
