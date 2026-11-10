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
{include/i-prgvrs.i Q15IN090 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i q15in090 MUT}
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
&GLOBAL-DEFINE EXCLUDE-pi-reposiciona-query 1 

/*
/* ***************** Support for Change Query to Find ***************** */
&Scoped-define CHANGE-QUERY-TO-FIND TRUE
&Scoped-define WHERE-FIRST-TABLE-IN-QUERY-Query-Main docum-est.CE-atual = FALSE     AND docum-est.nat-operacao = ""
&Scoped-define JOIN-SECOND-TABLE-IN-QUERY-Query-Main TRUE
&Scoped-define WHERE-SECOND-TABLE-IN-QUERY-Query-Main TRUE
&Scoped-define JOIN-THIRD-TABLE-IN-QUERY-Query-Main TRUE
&Scoped-define WHERE-THIRD-TABLE-IN-QUERY-Query-Main TRUE
*/

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/queryd.w

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def new global shared var gr-docum as rowid no-undo.

DEF TEMP-TABLE tt-docum-est NO-UNDO LIKE docum-est
    FIELD r-rowid AS ROWID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartQuery
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,Navigation-Target

&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-docum-est docum-est

/* Definitions for QUERY Query-Main                                     */
&Scoped-define SELF-NAME Query-Main
&Scoped-define QUERY-STRING-Query-Main FOR EACH tt-docum-est, ~
           FIRST docum-est OF tt-docum-est
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY {&SELF-NAME} FOR EACH tt-docum-est, ~
           FIRST docum-est OF tt-docum-est.
&Scoped-define TABLES-IN-QUERY-Query-Main tt-docum-est docum-est
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main tt-docum-est
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main docum-est


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
      tt-docum-est, 
      docum-est SCROLLING.
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
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-docum-est,
    FIRST docum-est OF tt-docum-est.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Where[1]         = "docum-est.ap-atual = FALSE     AND 
docum-est.CE-atual = FALSE     AND 
docum-est.nat-operacao = """"    AND
((docum-est.pais-origem = ""RE0994"" AND NOT CAN-FIND(FIRST item-doc-est OF docum-est)) 
              OR docum-est.pais-origem = ""IM0994"")"
     _Design-Parent    is WINDOW q-tables @ ( 1.17 , 9.86 )
*/  /* QUERY Query-Main */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize q-tables 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN pi-cria-tt-docum-est.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-chama-container q-tables 
PROCEDURE pi-chama-container :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var c-handle as char no-undo.

    RUN Who-Is-The-Container IN adm-broker-hdl 
        (INPUT this-procedure, OUTPUT c-handle).
    run pi-chama-geracao in widget-handle(c-handle). /* chama o bot’o gerar*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-docum-est q-tables 
PROCEDURE pi-cria-tt-docum-est :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   EMPTY TEMP-TABLE tt-docum-est.

  FOR EACH docum-est no-lock
     WHERE docum-est.ap-atual = FALSE     
       AND docum-est.CE-atual = FALSE     
       AND docum-est.nat-operacao = "":U
       AND docum-est.pais-origem = "IM0994":U:
      CREATE tt-docum-est.
      BUFFER-COPY docum-est TO tt-docum-est.
      ASSIGN tt-docum-est.r-rowid = ROWID(docum-est).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posicao-docum-est q-tables 
PROCEDURE pi-posicao-docum-est :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter p-rowid as rowid no-undo.

IF AVAIL tt-docum-est THEN 
   ASSIGN p-rowid = tt-docum-est.r-rowid.
ELSE
   ASSIGN p-rowid = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reposiciona-docum-est q-tables 
PROCEDURE pi-reposiciona-docum-est :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER p-rowid AS ROWID NO-UNDO.

FIND FIRST tt-docum-est 
     WHERE tt-docum-est.r-rowid = p-rowid NO-ERROR.
IF AVAIL tt-docum-est THEN
   RUN pi-reposiciona-query (INPUT ROWID(tt-docum-est)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reposiciona-query q-tables 
PROCEDURE pi-reposiciona-query :
/*------------------------------------------------------------------------------
  Purpose:     Reposicionar a query
  Parameters:  INPUT rowid para reposicionamento.
  Notes:
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER p-row-table AS ROWID NO-UNDO.

    SESSION:SET-WAIT-STATE("GENERAL":U).

    FIND FIRST tt-docum-est 
        WHERE tt-docum-est.r-rowid = p-row-table NO-ERROR.
    IF  AVAIL tt-docum-est THEN
        ASSIGN p-row-table = ROWID(tt-docum-est).

    /*  N’o reposiciona a query se a tabela estiver vazia. */
    IF NOT CAN-FIND(FIRST {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) THEN RETURN .

    /* O pre-processador a seguir ² utilizado pela equipe do Produto HR */
    {&CODE-SECURITY-OPEN-QUERY-HR}

    REPOSITION {&QUERY-NAME} TO ROWID p-row-table NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:

        SESSION:SET-WAIT-STATE("":U).

        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 16690, INPUT "":U).

        SESSION:SET-WAIT-STATE("GENERAL":U).

        IF RETURN-VALUE = "NO":U THEN
            RETURN .
        ELSE
            ASSIGN tt-uib-reposition-query = yes.

        RUN dispatch IN THIS-PROCEDURE ("OPEN-QUERY":U).

        REPOSITION {&QUERY-NAME} TO ROWID p-row-table NO-ERROR.

    END.

/************ Customizacao Datasul S.A. - John Cleber Jaraceski - 02/07/1999
              Implementar novas caracteristicas para o panel p-navega.w
              devido a deficiencia dos Templates PROGRESS com DATABASE ORACLE
              **********************************/
    &IF "{&ems_dbtype}":U <> "progress":U &THEN
        ASSIGN tt-uib-reposition-query = yes.

        RUN new-state (INPUT "Reposition-Oracle,NAVIGATION-SOURCE":U).
    &ENDIF
/***********************************************/

    RUN dispatch IN THIS-PROCEDURE ('get-next':U).

    SESSION:SET-WAIT-STATE("":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-state2 q-tables 
PROCEDURE pi-trata-state2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-issuer-hdl   AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-state        AS CHAR   NO-UNDO.

def var c-rowid as char no-undo.

     CASE entry(1, p-state, "|":U):
         WHEN 'Pesquisa':U THEN DO:
             run Pesquisa.
         END.
         WHEN 'VaPara':U THEN DO:
             run VaPara.
         END.
         WHEN 'Inclui':U THEN DO:
             run IncMod (INPUT P-STATE).
         END.
         WHEN 'Modifica':U THEN DO:
             run IncMod (INPUT P-STATE) .
         END.
         WHEN 'Copia':U THEN DO:
             run IncMod (INPUT P-STATE).
         END.
         WHEN 'Consulta':U THEN DO:
             run pi-consulta.
         END.
         WHEN 'Reposiciona':U THEN DO:
             RUN pi-cria-tt-docum-est.

             if  num-entries(p-state, "|":U) > 1 then do:
                 RUN dispatch IN THIS-PROCEDURE ("open-query":U).
                 
                 assign c-rowid = entry(2, p-state, "|":U).
                 
                 find first tt-docum-est where
                            tt-docum-est.r-rowid = to-rowid(c-rowid) no-error.

                 run pi-reposiciona-query (input rowid(tt-docum-est)).
             end.
         END.
      
      /************ Customizacao Datasul S.A. - John Cleber Jaraceski - 02/07/1999
                 Implementar novas caracteristicas para o panel p-navega.w 
                 devido a deficiencia dos Templates PROGRESS com DATABASE ORACLE
                 **********************************/
      &IF "progress":U = "oracle":U &THEN
        WHEN "DELETE-COMPLETE":U THEN DO:
           DEFINE VARIABLE c-auxiliar AS CHARACTER NO-UNDO.
           
           IF NOT VALID-HANDLE(h-panel-nav) THEN DO:
               RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                      INPUT "NAVIGATION-SOURCE":U,
                                                      OUTPUT c-auxiliar).
               
               ASSIGN h-panel-nav = WIDGET-HANDLE(c-auxiliar).
           END.
           
           IF VALID-HANDLE(h-panel-nav) THEN DO:
               RUN get-attribute IN h-panel-nav (INPUT "IsInReposition":U).
               
               IF RETURN-VALUE = "YES":U THEN 
                   ASSIGN adm-first-rowid = IF AVAILABLE tt-item 
                                            THEN ROWID(tt-item)
                                            ELSE ?.
           END.
           
         END.
      &ENDIF
   
     END.
   
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
  {src/adm/template/snd-list.i "tt-docum-est"}
  {src/adm/template/snd-list.i "docum-est"}

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
  run pi-trata-state2 (p-issuer-hdl, p-state).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

