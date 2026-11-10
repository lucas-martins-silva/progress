&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i Q01IN021 2.00.00.017 } /*** "010017" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i Q01IN021 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.
/* ***************** Support for Change Query to Find ***************** */
&Scoped-define CHANGE-QUERY-TO-FIND TRUE
&Scoped-define WHERE-FIRST-TABLE-IN-QUERY-Query-Main mla-doc-pend-aprov.ep-codigo   = g-empresa-aed and mla-doc-pend-aprov.cod-estabel = gc-estabel-aed and mla-doc-pend-aprov.cod-tip-doc = i-cod-tip-doc 
&Scoped-define JOIN-SECOND-TABLE-IN-QUERY-Query-Main TRUE
&Scoped-define WHERE-SECOND-TABLE-IN-QUERY-Query-Main TRUE
&Scoped-define JOIN-THIRD-TABLE-IN-QUERY-Query-Main TRUE
&Scoped-define WHERE-THIRD-TABLE-IN-QUERY-Query-Main TRUE

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/queryd.w
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var i-cod-tip-doc as integer no-undo.
def var c-chave-doc     like mla-doc-pend-aprov.chave-doc NO-UNDO.
def var c-chave-doc-aux like mla-doc-pend-aprov.chave-doc NO-UNDO.

def buffer b-mla-doc-pend-aprov for mla-doc-pend-aprov.

def new global shared var g-empresa-aed  LIKE empresa.ep-codigo     no-undo.
def new global shared var gc-estabel-aed LIKE estabelec.cod-estabel no-undo.
DEF NEW GLOBAL SHARED VAR i-ep-codigo-usuario AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartQuery
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,Navigation-Target

&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES mla-doc-pend-aprov

/* Definitions for QUERY Query-Main                                     */
&Scoped-define QUERY-STRING-Query-Main FOR EACH mla-doc-pend-aprov ~
      WHERE mla-doc-pend-aprov.ep-codigo   = g-empresa-aed and ~
mla-doc-pend-aprov.cod-estabel = gc-estabel-aed and ~
mla-doc-pend-aprov.cod-tip-doc = i-cod-tip-doc NO-LOCK ~
    BY mla-doc-pend-aprov.cod-tip-doc ~
       BY mla-doc-pend-aprov.chave-doc INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH mla-doc-pend-aprov ~
      WHERE mla-doc-pend-aprov.ep-codigo   = g-empresa-aed and ~
mla-doc-pend-aprov.cod-estabel = gc-estabel-aed and ~
mla-doc-pend-aprov.cod-tip-doc = i-cod-tip-doc NO-LOCK ~
    BY mla-doc-pend-aprov.cod-tip-doc ~
       BY mla-doc-pend-aprov.chave-doc INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-Query-Main mla-doc-pend-aprov
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main mla-doc-pend-aprov


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
nr-trans||y|movind.mla-doc-pend-aprov.nr-trans
cod-rejeicao||y|movind.mla-doc-pend-aprov.cod-rejeicao
cod-tip-aprov||y|movind.mla-doc-pend-aprov.cod-tip-aprov
cod-tip-doc||y|movind.mla-doc-pend-aprov.cod-tip-doc
cod-usuar||y|movind.mla-doc-pend-aprov.cod-usuar
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "nr-trans,cod-rejeicao,cod-tip-aprov,cod-tip-doc,cod-usuar"':U).

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
      mla-doc-pend-aprov SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartQuery
   Allow: Basic,Query
   Frames: 1
   Add Fields to: NEITHER
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
  CREATE WINDOW q-tables ASSIGN
         HEIGHT             = 1.33
         WIDTH              = 22.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB q-tables 
/* ************************* Included-Libraries *********************** */

{src/adm/method/query.i}
{include/c-query.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW q-tables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for QUERY Query-Main
     _TblList          = "movind.mla-doc-pend-aprov"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "movind.mla-doc-pend-aprov.cod-tip-doc|yes,movind.mla-doc-pend-aprov.chave-doc|yes"
     _Where[1]         = "mla-doc-pend-aprov.ep-codigo   = g-empresa-aed and
mla-doc-pend-aprov.cod-estabel = gc-estabel-aed and
mla-doc-pend-aprov.cod-tip-doc = i-cod-tip-doc"
     _Design-Parent    is WINDOW q-tables @ ( 1.17 , 9.86 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK q-tables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases q-tables  adm/support/_adm-opn.p
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available q-tables  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI q-tables  _DEFAULT-DISABLE
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'get-first':U ) .

    if available mla-doc-pend-aprov then do:
        assign c-chave-doc = mla-doc-pend-aprov.chave-doc.
    end.    

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'get-last':U ) .

    if available mla-doc-pend-aprov then do:
        assign c-chave-doc = mla-doc-pend-aprov.chave-doc.
    end.    

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

    &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
        
        &IF "{&ems_dbtype}" <> "ORACLE":U &THEN
            find next mla-doc-pend-aprov WHERE mla-doc-pend-aprov.ep-codigo   = g-empresa-aed  AND
                                               mla-doc-pend-aprov.cod-estabel = gc-estabel-aed AND
                                               mla-doc-pend-aprov.cod-tip-doc = i-cod-tip-doc  no-lock no-error.            
        &ENDIF
        
        if available mla-doc-pend-aprov then do:
                        
            assign c-chave-doc-aux = mla-doc-pend-aprov.chave-doc.
            
            find last b-mla-doc-pend-aprov where
                b-mla-doc-pend-aprov.ep-codigo   = g-empresa-aed and
                b-mla-doc-pend-aprov.cod-estabel = gc-estabel-aed and
                b-mla-doc-pend-aprov.cod-tip-doc = i-cod-tip-doc
                no-lock no-error.
            if available b-mla-doc-pend-aprov then
                if b-mla-doc-pend-aprov.chave-doc = mla-doc-pend-aprov.chave-doc then do:
                    RUN dispatch IN THIS-PROCEDURE ( INPUT 'get-next':U ).
                end.
            else do:
                repeat while
                    g-empresa-aed = mla-doc-pend-aprov.ep-codigo and
                    gc-estabel-aed = mla-doc-pend-aprov.cod-estabel and
                    i-cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc and
                    trim(c-chave-doc)   = trim(mla-doc-pend-aprov.chave-doc):
                        find next mla-doc-pend-aprov WHERE mla-doc-pend-aprov.ep-codigo   = g-empresa-aed  AND
                                                           mla-doc-pend-aprov.cod-estabel = gc-estabel-aed AND
                                                           mla-doc-pend-aprov.cod-tip-doc = i-cod-tip-doc  no-lock no-error.
                end.
                &IF "{&ems_dbtype}" = "ORACLE":U &THEN
                    if mla-doc-pend-aprov.chave-doc <> c-chave-doc-aux then 
                        find prev mla-doc-pend-aprov WHERE mla-doc-pend-aprov.ep-codigo   = g-empresa-aed  AND
                                                           mla-doc-pend-aprov.cod-estabel = gc-estabel-aed AND
                                                           mla-doc-pend-aprov.cod-tip-doc = i-cod-tip-doc  no-lock no-error.
                &ELSE
                    find prev mla-doc-pend-aprov WHERE mla-doc-pend-aprov.ep-codigo   = g-empresa-aed  AND
                                                           mla-doc-pend-aprov.cod-estabel = gc-estabel-aed AND
                                                           mla-doc-pend-aprov.cod-tip-doc = i-cod-tip-doc  no-lock no-error.
                &ENDIF
                RUN dispatch IN THIS-PROCEDURE ( INPUT 'get-next':U ).
                assign c-chave-doc = mla-doc-pend-aprov.chave-doc.
            end.
        end.

    &ELSE
        get next {&query-name}.
        if available mla-doc-pend-aprov then do:
            find last b-mla-doc-pend-aprov where
                b-mla-doc-pend-aprov.ep-codigo   = g-empresa-aed and
                b-mla-doc-pend-aprov.cod-estabel = gc-estabel-aed and
                b-mla-doc-pend-aprov.cod-tip-doc = i-cod-tip-doc
                no-lock no-error.
            if available b-mla-doc-pend-aprov then
                if b-mla-doc-pend-aprov.chave-doc = mla-doc-pend-aprov.chave-doc then do:
                    RUN dispatch IN THIS-PROCEDURE ( INPUT 'get-next':U ).
                end.
                else do:
                    repeat while
                        g-empresa-aed = mla-doc-pend-aprov.ep-codigo and
                        gc-estabel-aed = mla-doc-pend-aprov.cod-estabel and
                        i-cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc and
                        trim(c-chave-doc)   = trim(mla-doc-pend-aprov.chave-doc):
                        get next {&query-name}.
                    end.
                    get prev {&query-name}.
                    RUN dispatch IN THIS-PROCEDURE ( INPUT 'get-next':U ).
                    assign c-chave-doc = mla-doc-pend-aprov.chave-doc.
                end.
        end.
    &ENDIF

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

    &IF "{&CHANGE-QUERY-TO-FIND}":U EQ "TRUE":U &THEN
    
        if available mla-doc-pend-aprov then do:
            find first b-mla-doc-pend-aprov 
                 where b-mla-doc-pend-aprov.ep-codigo   = g-empresa-aed 
                   and b-mla-doc-pend-aprov.cod-estabel = gc-estabel-aed 
                   and b-mla-doc-pend-aprov.cod-tip-doc = i-cod-tip-doc no-lock no-error.

            if available b-mla-doc-pend-aprov then
                if trim(b-mla-doc-pend-aprov.chave-doc) = trim(c-chave-doc) then do:
                    RUN dispatch IN THIS-PROCEDURE ( INPUT 'get-prev':U ).
                end.
                else do:
                    repeat while
                        g-empresa-aed = mla-doc-pend-aprov.ep-codigo and
                        gc-estabel-aed = mla-doc-pend-aprov.cod-estabel and
                        i-cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc and
                        c-chave-doc   = mla-doc-pend-aprov.chave-doc:
                        FIND PREV mla-doc-pend-aprov NO-LOCK NO-ERROR.
                    end.
                    FIND NEXT mla-doc-pend-aprov NO-LOCK NO-ERROR.
                    RUN dispatch IN THIS-PROCEDURE ( INPUT 'get-prev':U ).
                    assign c-chave-doc = mla-doc-pend-aprov.chave-doc.
                end.
        end.
    &ELSE
        if available mla-doc-pend-aprov then do:
                find first b-mla-doc-pend-aprov where
                    b-mla-doc-pend-aprov.ep-codigo   = g-empresa-aed and
                    b-mla-doc-pend-aprov.cod-estabel = gc-estabel-aed and
                    b-mla-doc-pend-aprov.cod-tip-doc = i-cod-tip-doc
                    no-lock no-error.
                if available b-mla-doc-pend-aprov then
                    if trim(b-mla-doc-pend-aprov.chave-doc) = trim(c-chave-doc) then do:
                        RUN dispatch IN THIS-PROCEDURE ( INPUT 'get-prev':U ).
                    end.
                    else do:
                        repeat while
                            g-empresa-aed = mla-doc-pend-aprov.ep-codigo and
                            gc-estabel-aed = mla-doc-pend-aprov.cod-estabel and
                            i-cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc and
                            c-chave-doc   = mla-doc-pend-aprov.chave-doc:
                            get prev {&query-name}.
                        end.
                        get next {&query-name}.
                        RUN dispatch IN THIS-PROCEDURE ( INPUT 'get-prev':U ).
                        assign c-chave-doc = mla-doc-pend-aprov.chave-doc.
                    end.
            end.
    &ENDIF

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize q-tables 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    find mla-usuar-aprov where
        mla-usuar-aprov.cod-usuar = c-seg-usuario
        no-lock no-error.
    
    IF AVAIL mla-usuar-aprov THEN DO:
        assign gc-estabel-aed = mla-usuar-aprov.cod-estabel.
        FIND estabelec WHERE
             estabelec.cod-estabel = mla-usuar-aprov.cod-estabel
             NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN
           run cdp/cd9970.p (input  ROWID(estabelec),
                             output g-empresa-aed).
    END.
    ELSE DO:
        ASSIGN g-empresa-aed = i-ep-codigo-usuario.
    END.

    find first mla-tipo-doc-aprov where
        mla-tipo-doc-aprov.ep-codigo = g-empresa-aed 
        no-lock no-error.
    if available mla-tipo-doc-aprov then do:
        run pi-passa-documento (mla-tipo-doc-aprov.cod-tip-doc).
        if available mla-doc-pend-aprov then
            assign c-chave-doc = mla-doc-pend-aprov.chave-doc.
        else
            assign c-chave-doc = "".
    end.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-documento q-tables 
PROCEDURE pi-passa-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-cod-tip-doc as integer no-undo.

    assign i-cod-tip-doc = p-cod-tip-doc.

    RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key q-tables  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "nr-trans" "mla-doc-pend-aprov" "nr-trans"}
  {src/adm/template/sndkycas.i "cod-rejeicao" "mla-doc-pend-aprov" "cod-rejeicao"}
  {src/adm/template/sndkycas.i "cod-tip-aprov" "mla-doc-pend-aprov" "cod-tip-aprov"}
  {src/adm/template/sndkycas.i "cod-tip-doc" "mla-doc-pend-aprov" "cod-tip-doc"}
  {src/adm/template/sndkycas.i "cod-usuar" "mla-doc-pend-aprov" "cod-usuar"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records q-tables  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "mla-doc-pend-aprov"}

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

