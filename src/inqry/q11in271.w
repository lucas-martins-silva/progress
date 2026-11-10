&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i Q11IN271 2.00.00.006} /* 26/03/2026 16:10:00 */

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i Q11IN271 MUT}
&ENDIF

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
{include/i_dbtype.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var l-nao-iniciadas as logical init "yes".
def var l-liberadas     as logical init "yes".
def var l-alocadas      as logical init "yes".
def var l-separadas     as logical init "yes".
def var l-requisitadas  as logical init "yes".
def var l-iniciadas     as logical init "yes".
def var l-finalizadas   as logical init "yes".
def var l-terminadas    as logical init "yes".
def var i-nr-ord-produ  as integer no-undo.

def var l-reposiciona   as logical no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartQuery

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,Navigation-Target

&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES reservas

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for QUERY Query-Main                                     */
&Scoped-define SELF-NAME Query-Main
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY {&SELF-NAME} FOR EACH reservas NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-Query-Main reservas
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main reservas


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
nr-req-sum|y|y|mgind.reservas.nr-req-sum
cd-lubr|y|y|mgind.reservas.cd-lubr
cod-roteiro||y|mgind.reservas.cod-roteiro
cod-depos||y|mgind.reservas.cod-depos
it-codigo||y|mgind.reservas.it-codigo
nr-ord-produ||y|mgind.reservas.nr-ord-produ
cod-refer||y|mgind.reservas.cod-refer
un||y|mgind.reservas.un
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "nr-req-sum,cd-lubr",
     Keys-Supplied = "nr-req-sum,cd-lubr,cod-roteiro,cod-depos,it-codigo,nr-ord-produ,cod-refer,un"':U).

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
      reservas SCROLLING.
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
/* END WINDOW DEFINITION */
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
OPEN QUERY {&SELF-NAME} FOR EACH reservas NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Design-Parent    is WINDOW q-tables @ ( 1.17 , 9.86 )
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
  DEF VAR key-value AS CHAR NO-UNDO.

  DEF VAR Filter-Value AS CHAR NO-UNDO.

  /* Copy 'Filter-Attributes' into local variables. */
  RUN get-attribute ('Filter-Value':U).
  Filter-Value = RETURN-VALUE.
  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'nr-req-sum':U THEN DO:
       &Scope KEY-PHRASE reservas.nr-req-sum eq INTEGER(key-value)
       {&OPEN-QUERY-{&QUERY-NAME}}
    END. /* nr-req-sum */
    WHEN 'cd-lubr':U THEN DO:
       &Scope KEY-PHRASE reservas.cd-lubr eq key-value
       {&OPEN-QUERY-{&QUERY-NAME}}
    END. /* cd-lubr */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
       {&OPEN-QUERY-{&QUERY-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

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

  /* Dispatch standard ADM method.                             */
    
  get first {&query-name} no-lock.
  
  find ord-prod where ord-prod.nr-ord-produ = reservas.nr-ord-produ no-lock no-error.
  
  if avail ord-prod and
     (( ord-prod.estado = 1 and not l-nao-iniciadas ) or
      ( ord-prod.estado = 2 and not l-liberadas     ) or
      ( ord-prod.estado = 3 and not l-alocadas      ) or
      ( ord-prod.estado = 4 and not l-separadas     ) or
      ( ord-prod.estado = 5 and not l-requisitadas  ) or
      ( ord-prod.estado = 6 and not l-iniciadas     ) or
      ( ord-prod.estado = 7 and not l-finalizadas   ) or
      ( ord-prod.estado = 8 and not l-terminadas    ) ) then do:
      assign i-nr-ord-produ = reservas.nr-ord-produ.
      repeat:
             find first ord-prod where ord-prod.nr-ord-produ > i-nr-ord-produ and
                 (( ord-prod.estado = 1 and l-nao-iniciadas ) or
                  ( ord-prod.estado = 2 and l-liberadas     ) or
                  ( ord-prod.estado = 3 and l-alocadas      ) or
                  ( ord-prod.estado = 4 and l-separadas     ) or
                  ( ord-prod.estado = 5 and l-requisitadas  ) or
                  ( ord-prod.estado = 6 and l-iniciadas     ) or
                  ( ord-prod.estado = 7 and l-finalizadas   ) or
                  ( ord-prod.estado = 8 and l-terminadas    ) ) no-lock no-error.
             if avail ord-prod then do:
                find first reservas 
                     where reservas.nr-ord-produ = ord-prod.nr-ord-produ 
                     no-lock no-error.
                if avail reservas then do:
                   run pi-reposiciona-query (rowid(reservas)).
                   leave.
                end.
                else assign i-nr-ord-produ = ord-prod.nr-ord-produ.
             end.
             else leave.
      end. 
  end.
  else run pi-reposiciona-query (rowid(reservas)).
  
  run new-state ("first-record").

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
  
  &IF "{&ems_dbtype}":U = "ORACLE" &THEN
    FOR LAST reservas NO-LOCK
        USE-INDEX codigo:
    END.
  &ELSE                  
    get last {&query-name} no-lock.
  &ENDIF
  
  if not avail reservas then return.

  find ord-prod where ord-prod.nr-ord-produ = reservas.nr-ord-produ no-lock no-error.

  if avail ord-prod and
     (( ord-prod.estado = 1 and not l-nao-iniciadas ) or
      ( ord-prod.estado = 2 and not l-liberadas     ) or
      ( ord-prod.estado = 3 and not l-alocadas      ) or
      ( ord-prod.estado = 4 and not l-separadas     ) or
      ( ord-prod.estado = 5 and not l-requisitadas  ) or
      ( ord-prod.estado = 6 and not l-iniciadas     ) or
      ( ord-prod.estado = 7 and not l-finalizadas   ) or
      ( ord-prod.estado = 8 and not l-terminadas    ) ) then do:
      assign i-nr-ord-produ = reservas.nr-ord-produ.
      repeat:
             find last ord-prod where ord-prod.nr-ord-produ < i-nr-ord-produ and
                 (( ord-prod.estado = 1 and l-nao-iniciadas ) or
                  ( ord-prod.estado = 2 and l-liberadas     ) or
                  ( ord-prod.estado = 3 and l-alocadas      ) or
                  ( ord-prod.estado = 4 and l-separadas     ) or
                  ( ord-prod.estado = 5 and l-requisitadas  ) or
                  ( ord-prod.estado = 6 and l-iniciadas     ) or
                  ( ord-prod.estado = 7 and l-finalizadas   ) or
                  ( ord-prod.estado = 8 and l-terminadas    ) ) no-lock no-error.
             if avail ord-prod then do:
                find last reservas 
                     where reservas.nr-ord-produ = ord-prod.nr-ord-produ 
                     no-lock no-error.
                if avail reservas then do:
                   run pi-reposiciona-query (rowid(reservas)).
                   leave.
                end.
                else assign i-nr-ord-produ = ord-prod.nr-ord-produ.
             end.
             else leave.
      end. 
  end.
  else run pi-reposiciona-query (rowid(reservas)).
  
  run new-state ("last-record").

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

  /* Dispatch standard ADM method.                             */
  
  if not l-reposiciona then do:
     get next {&query-name} no-lock.
     
     find ord-prod where ord-prod.nr-ord-produ = reservas.nr-ord-produ no-lock no-error.
     
     if avail ord-prod and
        (( ord-prod.estado = 1 and not l-nao-iniciadas ) or
         ( ord-prod.estado = 2 and not l-liberadas     ) or
         ( ord-prod.estado = 3 and not l-alocadas      ) or
         ( ord-prod.estado = 4 and not l-separadas     ) or
         ( ord-prod.estado = 5 and not l-requisitadas  ) or
         ( ord-prod.estado = 6 and not l-iniciadas     ) or
         ( ord-prod.estado = 7 and not l-finalizadas   ) or
         ( ord-prod.estado = 8 and not l-terminadas    ) ) then do:
         assign i-nr-ord-produ = reservas.nr-ord-produ.
         repeat:
                find first ord-prod where ord-prod.nr-ord-produ > i-nr-ord-produ and
                    (( ord-prod.estado = 1 and l-nao-iniciadas ) or
                     ( ord-prod.estado = 2 and l-liberadas     ) or
                     ( ord-prod.estado = 3 and l-alocadas      ) or
                     ( ord-prod.estado = 4 and l-separadas     ) or
                     ( ord-prod.estado = 5 and l-requisitadas  ) or
                     ( ord-prod.estado = 6 and l-iniciadas     ) or
                     ( ord-prod.estado = 7 and l-finalizadas   ) or
                     ( ord-prod.estado = 8 and l-terminadas    ) ) no-lock no-error.
                if avail ord-prod then do:
                   find first reservas 
                        where reservas.nr-ord-produ = ord-prod.nr-ord-produ 
                        no-lock no-error.
                   if avail reservas then do:
                      assign l-reposiciona = yes.
                      run pi-reposiciona-query (rowid(reservas)).
                      assign l-reposiciona = no.
                      leave.
                   end.
                   else assign i-nr-ord-produ = ord-prod.nr-ord-produ.
                end.
                else do:
                     get prev {&query-name} no-lock.
                     run new-state ("last-record").
                     leave.
                end.
         end. 
     end.
     else do:
          assign l-reposiciona = yes.
          run pi-reposiciona-query (rowid(reservas)).
          assign l-reposiciona = no.
     end.
  end.
  else RUN dispatch IN THIS-PROCEDURE ( INPUT 'get-next':U ) .
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

  /* Dispatch standard ADM method.                             */
  
  get prev {&query-name} no-lock.
    
  find ord-prod where ord-prod.nr-ord-produ = reservas.nr-ord-produ no-lock no-error.
  
  if avail ord-prod and
     (( ord-prod.estado = 1 and not l-nao-iniciadas ) or
      ( ord-prod.estado = 2 and not l-liberadas     ) or
      ( ord-prod.estado = 3 and not l-alocadas      ) or
      ( ord-prod.estado = 4 and not l-separadas     ) or
      ( ord-prod.estado = 5 and not l-requisitadas  ) or
      ( ord-prod.estado = 6 and not l-iniciadas     ) or
      ( ord-prod.estado = 7 and not l-finalizadas   ) or
      ( ord-prod.estado = 8 and not l-terminadas    ) ) then do:
      assign i-nr-ord-produ = reservas.nr-ord-produ.
      repeat:
             find last ord-prod where ord-prod.nr-ord-produ < i-nr-ord-produ and
                 (( ord-prod.estado = 1 and l-nao-iniciadas ) or
                  ( ord-prod.estado = 2 and l-liberadas     ) or
                  ( ord-prod.estado = 3 and l-alocadas      ) or
                  ( ord-prod.estado = 4 and l-separadas     ) or
                  ( ord-prod.estado = 5 and l-requisitadas  ) or
                  ( ord-prod.estado = 6 and l-iniciadas     ) or
                  ( ord-prod.estado = 7 and l-finalizadas   ) or
                  ( ord-prod.estado = 8 and l-terminadas    ) ) no-lock no-error.
             if avail ord-prod then do:
                find last reservas 
                     where reservas.nr-ord-produ = ord-prod.nr-ord-produ 
                     no-lock no-error.
                if avail reservas then do:
                   run pi-reposiciona-query (rowid(reservas)).
                   leave.
                end.
                else assign i-nr-ord-produ = ord-prod.nr-ord-produ.
             end. 
             else do: 
                  get next {&query-name} no-lock.
                  run new-state ("first-record").
                  leave.
             end.                      
      end. 
  end.
  else run pi-reposiciona-query (rowid(reservas)). .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-variaveis q-tables 
PROCEDURE pi-atualiza-variaveis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param l-param-nao-iniciadas as log.
   def input param l-param-liberadas     as log.
   def input param l-param-alocadas      as log.
   def input param l-param-separadas     as log.
   def input param l-param-requisitadas  as log.
   def input param l-param-iniciadas     as log.
   def input param l-param-finalizadas   as log.
   def input param l-param-terminadas    as log.
   def input param l-cancelar            as log.
   
   assign l-nao-iniciadas = l-param-nao-iniciadas    
          l-liberadas     = l-param-liberadas
          l-alocadas      = l-param-alocadas
          l-separadas     = l-param-separadas
          l-requisitadas  = l-param-requisitadas
          l-iniciadas     = l-param-iniciadas
          l-finalizadas   = l-param-finalizadas
          l-terminadas    = l-param-terminadas.     
   
   if not l-cancelar then
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .    
      
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
  {src/adm/template/sndkycas.i "nr-req-sum" "reservas" "nr-req-sum"}
  {src/adm/template/sndkycas.i "cd-lubr" "reservas" "cd-lubr"}
  {src/adm/template/sndkycas.i "cod-roteiro" "reservas" "cod-roteiro"}
  {src/adm/template/sndkycas.i "cod-depos" "reservas" "cod-depos"}
  {src/adm/template/sndkycas.i "it-codigo" "reservas" "it-codigo"}
  {src/adm/template/sndkycas.i "nr-ord-produ" "reservas" "nr-ord-produ"}
  {src/adm/template/sndkycas.i "cod-refer" "reservas" "cod-refer"}
  {src/adm/template/sndkycas.i "un" "reservas" "un"}

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
  {src/adm/template/snd-list.i "reservas"}

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


