&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
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
{include/i-prgvrs.i Q22IN385 2.00.00.025 } /*** "010025" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i Q22IN385 MUT}
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

/* Pre-processadores Materiais */
{cdp/cdcfgmat.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def new global shared var i-nroreq-ini  like requisicao.nr-requisicao no-undo.
def new global shared var i-nroreq-fim  like requisicao.nr-requisicao no-undo.
def new global shared var c-nomreq-ini  like requisitante.nome-abrev  no-undo.
def new global shared var c-nomreq-fim  like requisitante.nome-abrev  no-undo.
def new global shared var c-item-ini    like item.it-codigo no-undo.
def new global shared var c-item-fim    like item.it-codigo no-undo.
def new global shared var c-fm-cod-ini  like item.fm-codigo no-undo.
def new global shared var c-fm-cod-fim  like item.fm-codigo no-undo.
def new global shared var da-requis-ini like requisicao.dt-requis no-undo.
def new global shared var da-requis-fim like requisicao.dt-requis no-undo.

/************************************************************************
 * TECNICA DE SEGURANÄA POR ESTABELECIMENTO
 ************************************************************************/

&Scoped-define QUERY-NAME Query-Main
&Scoped-define TABLES-IN-QUERY-Query-Main requisicao requisitante ~
it-requisicao
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main requisicao
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main it-requisicao

&Scoped-define REPOSITION-PROCEDURE-KEY-PHRASE ~
          requisicao.situacao       = 1 ~
      AND requisicao.tp-requis      = 1 ~
      AND requisicao.nr-requisicao >= i-nroreq-ini ~
	  AND requisicao.nr-requisicao <= i-nroreq-fim ~
	  AND requisicao.nome-abrev    >= c-nomreq-ini ~
	  AND requisicao.nome-abrev    <= c-nomreq-fim ~
      AND requisicao.dt-requisicao >= da-requis-ini ~
      AND requisicao.dt-requisicao <= da-requis-fim ~
      &if "{&ems_dbtype}" = "oracle" &THEN USE-INDEX requisicao &endif NO-LOCK, ~
	FIRST it-requisicao WHERE it-requisicao.estado        = 1  ~
                          AND it-requisicao.nr-requisicao = requisicao.nr-requisicao ~
                          AND it-requisicao.situacao      = 1 ~
                          AND it-requisicao.it-codigo     >= c-item-ini ~
                    	  AND it-requisicao.it-codigo     <= c-item-fim ~
                    	  &if "{&ems_dbtype}" = "oracle" &THEN USE-INDEX estado-requis &endif NO-LOCK

{include/i-estab-security.i}
/************************************************************************
 * TECNICA DE SEGURANÄA POR ESTABELECIMENTO
 ************************************************************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartQuery
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,Navigation-Target

&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES requisicao requisitante it-requisicao 

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for QUERY Query-Main                                     */
&Scoped-define OPEN-QUERY-Query-Main ~
    OPEN QUERY Query-Main ~
        FOR EACH requisicao WHERE ~{&KEY-PHRASE} ~
              AND requisicao.situacao       = 1 ~
              AND requisicao.tp-requis      = 1 ~
        	  AND requisicao.nr-requisicao >= i-nroreq-ini ~
        	  AND requisicao.nr-requisicao <= i-nroreq-fim ~
        	  AND requisicao.nome-abrev    >= c-nomreq-ini ~
        	  AND requisicao.nome-abrev    <= c-nomreq-fim ~
              AND requisicao.dt-requisicao >= da-requis-ini ~
              AND requisicao.dt-requisicao <= da-requis-fim ~
              &if "{&ems_dbtype}" = "oracle" &THEN USE-INDEX requisicao &endif NO-LOCK, ~
	FIRST it-requisicao WHERE it-requisicao.estado = 1  ~
                          AND it-requisicao.nr-requisicao = requisicao.nr-requisicao ~
                          AND it-requisicao.situacao = 1 ~
                          AND it-requisicao.it-codigo >= c-item-ini ~
                    	  AND it-requisicao.it-codigo <= c-item-fim ~
                    	  &if "{&ems_dbtype}" = "oracle" &THEN USE-INDEX estado-requis &endif  ~
    ~{&SORTBY-PHRASE} NO-LOCK INDEXED-REPOSITION.

&Scoped-define TABLES-IN-QUERY-Query-Main requisicao requisitante ~
it-requisicao item
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main requisicao
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main it-requisicao
&Scoped-define THIRD-TABLE-IN-QUERY-Query-Main item

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
nome-abrev|y|y|movind.requisicao.nome-abrev
nr-requisicao||y|movind.requisicao.nr-requisicao
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "nome-abrev",
     Keys-Supplied = "nome-abrev,nr-requisicao"':U).

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
     _TblList          = "movind.requisicao,mgind.requisitante WHERE movind.requisicao ...,movind.it-requisicao WHERE movind.requisicao ...,mgind.item WHERE movind.it-requisicao ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = "USED, FIRST USED, FIRST, FIRST USED"
     _Where[1]         = "movind.requisicao.nr-requisicao >= i-nroreq-ini 
 AND movind.requisicao.nr-requisicao <= i-nroreq-fim 
 AND movind.requisicao.tp-requis = 1
 AND movind.requisicao.situacao = 1
 AND movind.requisicao.nome-abrev >= c-nomreq-ini 
 AND movind.requisicao.nome-abrev <= c-nomreq-fim 
 AND movind.requisicao.dt-requisicao >= da-requis-ini 
 AND movind.requisicao.dt-requisicao <= da-requis-fim "
     _JoinCode[2]      = "mgind.requisitante.nome-abrev = movind.requisicao.nome-abrev"
     _JoinCode[3]      = "movind.it-requisicao.nr-requisicao = movind.requisicao.nr-requisicao"
     _Where[3]         = "movind.it-requisicao.it-codigo >= c-item-ini
 AND movind.it-requisicao.it-codigo <= c-item-fim"
     _JoinCode[4]      = "mgind.item.it-codigo = movind.it-requisicao.it-codigo"
     _Where[4]         = "mgind.item.fm-codigo >= c-fm-cod-ini
 AND mgind.item.fm-codigo <= c-fm-cod-fim"
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
    WHEN 'nome-abrev':U THEN DO:
       &Scope KEY-PHRASE requisicao.nome-abrev eq key-value
    END. /* nome-abrev */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
    END. /* OTHERWISE...*/
  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize q-tables 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    ASSIGN i-nroreq-ini = 0
           /* Engenharia Aumento Tamanho Campo Nr Requisicao */
           &IF "{&bf_mat_versao_ems}":U >= "2.04":U &THEN
               i-nroreq-fim = 999999999
           &ELSE
               i-nroreq-fim = 999999
           &ENDIF
           c-nomreq-ini  = ""
           c-nomreq-fim  = "ZZZZZZZZZZZZ"
           c-item-ini    = ""
           c-item-fim    = "ZZZZZZZZZZZZZZZZ"
           c-fm-cod-ini  = ""
           c-fm-cod-fim  = "ZZZZZZZZ".

    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-performance-data-cd1409"
                               AND funcao.ativo     = TRUE) THEN
        ASSIGN da-requis-ini = today - 1 //INICIALIZAR O PROGRAMA MAIS R¡PIDO
               da-requis-fim = today.
    ELSE
        ASSIGN da-requis-ini = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
               da-requis-fim = 12/31/9999.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query-cases q-tables 
PROCEDURE local-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
/* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  /* TÇcnica de seguranáa por estabelecimento */
  &IF DEFINED(UIB_IS_RUNNING) = 0 &THEN
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
        WHEN 'nome-abrev':U THEN DO:
              &Scope KEY-PHRASE requisicao.nome-abrev eq key-value ~
        	  AND requisicao.situacao       = 1 ~
              AND requisicao.tp-requis      = 1 ~
              AND requisicao.nr-requisicao >= i-nroreq-ini ~
        	  AND requisicao.nr-requisicao <= i-nroreq-fim ~
        	  AND requisicao.nome-abrev    >= c-nomreq-ini ~
        	  AND requisicao.nome-abrev    <= c-nomreq-fim ~
              AND requisicao.dt-requisicao >= da-requis-ini ~
              AND requisicao.dt-requisicao <= da-requis-fim ~
              &if "{&ems_dbtype}" = "oracle" &THEN USE-INDEX requisicao &endif NO-LOCK, ~
                  FIRST it-requisicao WHERE it-requisicao.estado        = 1  ~
                                        AND it-requisicao.nr-requisicao = requisicao.nr-requisicao ~
                                        AND it-requisicao.situacao      = 1 ~
                                        AND it-requisicao.it-codigo     >= c-item-ini ~
                                    	AND it-requisicao.it-codigo     <= c-item-fim ~
                                  	    &if "{&ems_dbtype}" = "oracle" &THEN USE-INDEX estado-requis &endif NO-LOCK
                &IF "{&emsfnd_dbtype}" = "ORACLE":U &THEN
                    RUN open-query-oracle IN THIS-PROCEDURE.
                &ELSE
                    {include/i-estab-openquery.i}
                &ENDIF
        END.
        OTHERWISE DO:
              &Scope KEY-PHRASE ~
                  requisicao.situacao       = 1 ~
              AND requisicao.tp-requis      = 1 ~
              AND requisicao.nr-requisicao >= i-nroreq-ini ~
        	  AND requisicao.nr-requisicao <= i-nroreq-fim ~
        	  AND requisicao.nome-abrev    >= c-nomreq-ini ~
        	  AND requisicao.nome-abrev    <= c-nomreq-fim ~
              AND requisicao.dt-requisicao >= da-requis-ini ~
              AND requisicao.dt-requisicao <= da-requis-fim ~
              &if "{&ems_dbtype}" = "oracle" &THEN USE-INDEX requisicao &endif NO-LOCK, ~
            	FIRST it-requisicao WHERE it-requisicao.estado        = 1  ~
                                      AND it-requisicao.nr-requisicao = requisicao.nr-requisicao ~
                                      AND it-requisicao.situacao      = 1 ~
                                      AND it-requisicao.it-codigo     >= c-item-ini ~
                                	  AND it-requisicao.it-codigo     <= c-item-fim ~
                                	  &if "{&ems_dbtype}" = "oracle" &THEN USE-INDEX estado-requis &endif NO-LOCK
                &IF "{&emsfnd_dbtype}" = "ORACLE":U &THEN
                    RUN open-query-oracle IN THIS-PROCEDURE.
                &ELSE
                    {include/i-estab-openquery.i}
                &ENDIF
        END.
    END CASE.
  
  &ELSE
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query-cases':U ) .
  &ENDIF
 

  /* Code placed here will execute AFTER standard behavior.    */
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
  {src/adm/template/sndkycas.i "nome-abrev" "requisicao" "nome-abrev"}
  {src/adm/template/sndkycas.i "nr-requisicao" "requisicao" "nr-requisicao"}

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
  {src/adm/template/snd-list.i "requisicao"}
  {src/adm/template/snd-list.i "requisitante"}
  {src/adm/template/snd-list.i "it-requisicao"}
  {src/adm/template/snd-list.i "item"}

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


PROCEDURE open-query-oracle:

    /*INSERIDO C”DIGO ABAIXO DEVIDO AO ERRO QUE OCORRO EM BASE ORACLE NA NAVEGA«√O*/
    &IF DEFINED(KEY-PHRASE) = 0 &THEN      
      &SCOPED-DEFINE MY-KEY-PHRASE TRUE NO-LOCK
    &ELSE
       &SCOPED-DEFINE MY-KEY-PHRASE {&KEY-PHRASE}    
    &ENDIF  
    
    &IF DEFINED(OPEN-QUERY-{&MY-QUERY}-IN) = 0 &THEN /*se a query n∆o foi definida completa monta o open query*/
        &Scoped-define OPEN-QUERY-{&MY-QUERY}-IN OPEN QUERY {&MY-QUERY} {&QUERY-ESTAB-IN} {&MY-KEY-PHRASE} {&BY-ESTAB-IN}.            
    &ENDIF    
    
    &IF DEFINED(OPEN-QUERY-{&MY-QUERY}-AT) = 0 &THEN /*se a query n∆o foi definida completa monta o open query*/            
        &Scoped-define OPEN-QUERY-{&MY-QUERY}-AT OPEN QUERY {&MY-QUERY} {&QUERY-ESTAB-AT} {&MY-KEY-PHRASE} {&BY-ESTAB-AT}.        
    &ENDIF    
    &UNDEFINE MY-KEY-PHRASE                     
    
    IF l-estab-security-active = NO
    THEN DO: 
      {&OPEN-QUERY-{&MY-QUERY}-IN}      
    END.
    ELSE DO:                
      {&OPEN-QUERY-{&MY-QUERY}-AT}
    END.
    /* Fim da tÇcnica de seguranáa por estabelecimento */ 

END PROCEDURE.
