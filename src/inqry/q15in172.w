&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i Q15IN172 2.00.00.005}  /*** "010005" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i Q15IN172 MUT}
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

/* ***************** Support for Change Query to Find ***************** */
&Scoped-define CHANGE-QUERY-TO-FIND TRUE
&Scoped-define WHERE-FIRST-TABLE-IN-QUERY-Query-Main mgind.item.niv-mais-bai >= 0
&Scoped-define JOIN-SECOND-TABLE-IN-QUERY-Query-Main TRUE
&Scoped-define WHERE-SECOND-TABLE-IN-QUERY-Query-Main TRUE
&Scoped-define JOIN-THIRD-TABLE-IN-QUERY-Query-Main TRUE
&Scoped-define WHERE-THIRD-TABLE-IN-QUERY-Query-Main TRUE

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/queryd.w

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartQuery

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,Navigation-Target

&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES item

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for QUERY Query-Main                                     */
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH item use-index codigo WHERE ~{&KEY-PHRASE} ~
      AND item.niv-mais-bai >= 0 NO-LOCK ~
    BY item.it-codigo INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-Query-Main item
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main item


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
class-fiscal|y|y|mgind.item.class-fiscal
cod-comprado|y|y|mgind.item.cod-comprado
ge-codigo|y|y|mgind.item.ge-codigo
nr-linha|y|y|mgind.item.nr-linha
nat-despesa|y|y|mgind.item.nat-despesa
un|y|y|mgind.item.un
it-codigo||y|mgind.item.it-codigo
fm-codigo||y|mgind.item.fm-codigo
cd-tag||y|mgind.item.cd-tag
cd-planejado||y|mgind.item.cd-planejado
cod-refer||y|mgind.item.cod-refer
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "class-fiscal,cod-comprado,ge-codigo,nr-linha,nat-despesa,un",
     Keys-Supplied = "class-fiscal,cod-comprado,ge-codigo,nr-linha,nat-despesa,un,it-codigo,fm-codigo,cd-tag,cd-planejado,cod-refer"':U).

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
      item
    FIELDS() SCROLLING.
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
         HEIGHT             = 1.35
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
     _TblList          = "mgind.item"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE"
     _TblOptList       = "USED"
     _OrdList          = "mgind.item.it-codigo|yes"
     _Where[1]         = "mgind.item.niv-mais-bai > 0"
     _Design-Parent    is WINDOW q-tables @ ( 1.15 , 9.86 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB q-tables 
/* ************************* Included-Libraries *********************** */

{src/adm/method/query.i}
{include/c-query.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



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
    WHEN 'class-fiscal':U THEN DO:
       &Scope KEY-PHRASE item.class-fiscal eq key-value
       {&OPEN-QUERY-{&QUERY-NAME}}
    END. /* class-fiscal */
    WHEN 'cod-comprado':U THEN DO:
       &Scope KEY-PHRASE item.cod-comprado eq key-value
       {&OPEN-QUERY-{&QUERY-NAME}}
    END. /* cod-comprado */
    WHEN 'ge-codigo':U THEN DO:
       &Scope KEY-PHRASE item.ge-codigo eq INTEGER(key-value)
       {&OPEN-QUERY-{&QUERY-NAME}}
    END. /* ge-codigo */
    WHEN 'nr-linha':U THEN DO:
       &Scope KEY-PHRASE item.nr-linha eq INTEGER(key-value)
       {&OPEN-QUERY-{&QUERY-NAME}}
    END. /* nr-linha */
    WHEN 'nat-despesa':U THEN DO:
       &Scope KEY-PHRASE item.nat-despesa eq INTEGER(key-value)
       {&OPEN-QUERY-{&QUERY-NAME}}
    END. /* nat-despesa */
    WHEN 'un':U THEN DO:
       &Scope KEY-PHRASE item.un eq key-value
       {&OPEN-QUERY-{&QUERY-NAME}}
    END. /* un */
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
  {src/adm/template/sndkycas.i "class-fiscal" "item" "class-fiscal"}
  {src/adm/template/sndkycas.i "cod-comprado" "item" "cod-comprado"}
  {src/adm/template/sndkycas.i "ge-codigo" "item" "ge-codigo"}
  {src/adm/template/sndkycas.i "nr-linha" "item" "nr-linha"}
  {src/adm/template/sndkycas.i "nat-despesa" "item" "nat-despesa"}
  {src/adm/template/sndkycas.i "un" "item" "un"}
  {src/adm/template/sndkycas.i "it-codigo" "item" "it-codigo"}
  {src/adm/template/sndkycas.i "fm-codigo" "item" "fm-codigo"}
  {src/adm/template/sndkycas.i "cd-tag" "item" "cd-tag"}
  {src/adm/template/sndkycas.i "cd-planejado" "item" "cd-planejado"}
  {src/adm/template/sndkycas.i "cod-refer" "item" "cod-refer"}

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


