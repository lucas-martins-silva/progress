&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i B04AD098 2.00.00.035 } /*** 010035 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i B04AD098 MUT}
&ENDIF


/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

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
&Scop adm-attribute-dlg support/browserd.w

define variable c-lista-valor       as character init '':U        no-undo.
define variable l-fornecedor-filtro as logical                    no-undo.
define variable l-cliente-filtro    as logical                    no-undo.
define variable l-ambos-filtro      as logical                    no-undo.
define variable h-handle-pai        as handle                     no-undo.
define variable c-cgc               like emitente.cgc.
define variable c-form1             like param-global.formato-id-pessoal.
define variable c-form2             like param-global.formato-id-pessoal.
define variable c-identific         as char format "x(20)"        no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES emitente

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table if emitente.natureza = 1 then string(emitente.cgc, c-form1) else string(emitente.cgc, c-form2) @ c-cgc emitente.cod-emitente emitente.nome-abrev emitente.nome-emit emitente.cod-gr-cli emitente.nome-matriz emitente.cidade emitente.estado emitente.cep fn-identific(emitente.identific) @ c-identific   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define SELF-NAME br-table
&Scoped-define OPEN-QUERY-br-table     if  l-cliente-filtro     and not l-fornecedor-filtro     and l-ambos-filtro then         open query {&SELF-NAME}             for each  emitente                 where emitente.cgc >= c-inicial                 and   emitente.cgc <= c-final                 and   (   emitente.identific = 1                        or emitente.identific = 3)                 no-lock by emitente.cgc indexed-reposition.     else          if  l-cliente-filtro          and l-fornecedor-filtro          and l-ambos-filtro then              open query {&SELF-NAME}                  for each  emitente                      where emitente.cgc >= c-inicial                      and   emitente.cgc <= c-final                      no-lock by emitente.cgc indexed-reposition.          else              open query {&SELF-NAME}                  for each  emitente                      where emitente.cgc >= c-inicial                      and   emitente.cgc <= c-final                      and   (   (emitente.identific = 1 and l-cliente-filtro)                             or (emitente.identific = 2 and l-fornecedor-filtro)                             or (emitente.identific = 3 and l-ambos-filtro))                  no-lock by emitente.cgc indexed-reposition.
&Scoped-define TABLES-IN-QUERY-br-table emitente
&Scoped-define FIRST-TABLE-IN-QUERY-br-table emitente


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-inicial c-final bt-confirma br-table ~
IMAGE-1 IMAGE-2 
&Scoped-Define DISPLAYED-OBJECTS c-inicial c-final 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
cod-cond-pag|y|y|mgadm.emitente.cod-cond-pag
cod-gr-forn|y|y|mgadm.emitente.cod-gr-forn
cod-rep|y|y|mgadm.emitente.cod-rep
cod-transp|y|y|mgadm.emitente.cod-transp
cod-banco||y|mgadm.emitente.cod-banco
nome-abrev||y|mgadm.emitente.nome-abrev
cod-emitente||y|mgadm.emitente.cod-emitente
cod-gr-cli||y|mgadm.emitente.cod-gr-cli
cod-mensagem||y|mgadm.emitente.cod-mensagem
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "cod-cond-pag,cod-gr-forn,cod-rep,cod-transp",
     Keys-Supplied = "cod-cond-pag,cod-gr-forn,cod-rep,cod-transp,cod-banco,nome-abrev,cod-emitente,cod-gr-cli,cod-mensagem"':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-identific B-table-Win 
FUNCTION fn-identific RETURNS CHARACTER
  ( input p-identific as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image\im-sav":U
     LABEL "Button 1" 
     SIZE 5.14 BY 1.

DEFINE VARIABLE c-final AS CHARACTER FORMAT "X(19)":U INITIAL "ZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-inicial AS CHARACTER FORMAT "x(19)" 
     LABEL "":R4 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      emitente SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table B-table-Win _FREEFORM
  QUERY br-table NO-LOCK DISPLAY
      if emitente.natureza = 1 then
  string(emitente.cgc, c-form1)
else
  string(emitente.cgc, c-form2) @ c-cgc
      emitente.cod-emitente FORMAT ">>>>>>>>9":U
      emitente.nome-abrev FORMAT "X(12)":U
      emitente.nome-emit FORMAT "X(40)":U
      emitente.cod-gr-cli FORMAT ">>>9":U
      emitente.nome-matriz FORMAT "x(12)":U
      emitente.cidade FORMAT "X(50)":U
      emitente.estado FORMAT "x(4)":U
      emitente.cep FORMAT "x(12)":U
      fn-identific(emitente.identific) @ c-identific
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 78 BY 9.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-inicial AT ROW 1 COL 9 COLON-ALIGNED HELP
          "CGC ou CIC do cliente/fornecedor"
     c-final AT ROW 1 COL 40.86 COLON-ALIGNED NO-LABEL
     bt-confirma AT ROW 1 COL 73
     br-table AT ROW 2.38 COL 1
     IMAGE-1 AT ROW 1 COL 36.72
     IMAGE-2 AT ROW 1 COL 39.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 10.63
         WIDTH              = 78.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{include/c-brwzoo.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
/* BROWSE-TAB br-table bt-confirma F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _START_FREEFORM
    if  l-cliente-filtro
    and not l-fornecedor-filtro
    and l-ambos-filtro then
        open query {&SELF-NAME}
            for each  emitente
                where emitente.cgc >= c-inicial
                and   emitente.cgc <= c-final
                and   (   emitente.identific = 1
                       or emitente.identific = 3)
                no-lock by emitente.cgc indexed-reposition.
    else
         if  l-cliente-filtro
         and l-fornecedor-filtro
         and l-ambos-filtro then
             open query {&SELF-NAME}
                 for each  emitente
                     where emitente.cgc >= c-inicial
                     and   emitente.cgc <= c-final
                     no-lock by emitente.cgc indexed-reposition.
         else
             open query {&SELF-NAME}
                 for each  emitente
                     where emitente.cgc >= c-inicial
                     and   emitente.cgc <= c-final
                     and   (   (emitente.identific = 1 and l-cliente-filtro)
                            or (emitente.identific = 2 and l-fornecedor-filtro)
                            or (emitente.identific = 3 and l-ambos-filtro))
                 no-lock by emitente.cgc indexed-reposition.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = "USED"
     _OrdList          = "mgadm.emitente.cgc|yes"
     _Where[1]         = "mgadm.emitente.cgc       >= c-inicial and
mgadm.emitente.cgc       <= c-final   and
mgadm.emitente.identific <> 2
"
     _Query            is NOT OPENED
*/  /* BROWSE br-table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br-table
&Scoped-define SELF-NAME br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br-table IN FRAME F-Main
DO:
    RUN New-State('DblClick':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-ENTRY OF br-table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}

  run new-state('New-Line|':U + string(rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}))).
  run seta-valor.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-LEAVE OF br-table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON VALUE-CHANGED OF br-table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
  run new-state('New-Line|':U + string(rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}))).
  run new-state('Value-Changed|':U + string(this-procedure)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma B-table-Win
ON CHOOSE OF bt-confirma IN FRAME F-Main /* Button 1 */
DO:

  assign input frame {&frame-name} c-inicial c-final.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

  apply 'value-changed':U to {&browse-name} in frame {&frame-name}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

find first param-global no-lock.
assign c-form1 = param-global.formato-id-pessoal
       c-form2 = param-global.formato-id-federal.

/* Alterado o label do CGC
{utp/ut-field.i mgadm emitente cgc 1}*/
assign c-cgc:label in browse {&browse-name} = param-global.label-cgc.

if c-form1 = "" then
   assign c-form1 = "x(08)".
if c-form2 = "" then
   assign c-form2 = "x(08)".

assign c-inicial:label in frame {&frame-name} = param-global.label-cgc.   

{utp/ut-liter.i Identifica‡Æo}
assign c-identific:label in browse {&browse-name} = return-value.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
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
    WHEN 'cod-cond-pag':U THEN DO:
       &Scope KEY-PHRASE emitente.cod-cond-pag eq INTEGER(key-value)
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* cod-cond-pag */
    WHEN 'cod-gr-forn':U THEN DO:
       &Scope KEY-PHRASE emitente.cod-gr-forn eq INTEGER(key-value)
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* cod-gr-forn */
    WHEN 'cod-rep':U THEN DO:
       &Scope KEY-PHRASE emitente.cod-rep eq INTEGER(key-value)
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* cod-rep */
    WHEN 'cod-transp':U THEN DO:
       &Scope KEY-PHRASE emitente.cod-transp eq INTEGER(key-value)
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* cod-transp */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run Who-Is-The-Container in adm-broker-hdl (input this-procedure,
                                              output h-handle-pai).
  if  valid-handle(h-handle-pai) then 
      run pi-filtro in h-handle-pai (output l-fornecedor-filtro,
                                     output l-cliente-filtro,
                                     output l-ambos-filtro).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  apply "VALUE-CHANGED" to br-table in frame {&frame-name} .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  apply 'entry' to c-inicial in frame {&FRAME-NAME}.
  return error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view B-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  apply 'value-changed':U to {&browse-name} in frame {&frame-name}.
  apply 'entry' to c-inicial in frame {&FRAME-NAME}.


END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartBrowser, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-filtro B-table-Win 
PROCEDURE pi-filtro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter p-l-fornecedor as logical no-undo.
    define input parameter p-l-cliente    as logical no-undo.
    define input parameter p-l-ambos      as logical no-undo.

    assign l-fornecedor-filtro = p-l-fornecedor
           l-cliente-filtro    = p-l-cliente
           l-ambos-filtro      = p-l-ambos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-valor B-table-Win 
PROCEDURE pi-retorna-valor :
DEFINE INPUT PARAMETER P-CAMPO AS CHARACTER NO-UNDO.

    DEFINE VARIABLE P-VALOR AS CHAR INIT "" NO-UNDO.

    if  avail mgadm.emitente then do:
        case p-campo:
            when "cod-emitente" then
                assign p-valor = string(emitente.cod-emitente).
            when "nome-abrev" then
                assign p-valor = string(emitente.nome-abrev).
            when "cod-gr-cli" then
                assign p-valor = string(emitente.cod-gr-cli).
            when "nome-matriz" then
                assign p-valor = string(emitente.nome-matriz).
            when "nome-emit" then
                assign p-valor = string(emitente.nome-emit).
        end.
    end.
    return p-valor.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "cod-cond-pag" "emitente" "cod-cond-pag"}
  {src/adm/template/sndkycas.i "cod-gr-forn" "emitente" "cod-gr-forn"}
  {src/adm/template/sndkycas.i "cod-rep" "emitente" "cod-rep"}
  {src/adm/template/sndkycas.i "cod-transp" "emitente" "cod-transp"}
  {src/adm/template/sndkycas.i "cod-banco" "emitente" "cod-banco"}
  {src/adm/template/sndkycas.i "nome-abrev" "emitente" "nome-abrev"}
  {src/adm/template/sndkycas.i "cod-emitente" "emitente" "cod-emitente"}
  {src/adm/template/sndkycas.i "cod-gr-cli" "emitente" "cod-gr-cli"}
  {src/adm/template/sndkycas.i "cod-mensagem" "emitente" "cod-mensagem"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
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
      {src/adm/template/bstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "RetornaValorCampo" B-table-Win _INLINE
/* Actions: ? ? ? ? support/brwrtval.p */
/* Procedure desativada */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-identific B-table-Win 
FUNCTION fn-identific RETURNS CHARACTER
  ( input p-identific as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  run utp/ut-liter.p (input {adinc/i02ad098.i 04 p-identific},
                      input "",
                      input "").
  return return-value.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

