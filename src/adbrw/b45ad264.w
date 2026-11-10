&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          rtb              PROGRESS
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
{include/i-prgvrs.i B45AD264 2.00.00.010}  /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i B45AD264 MUT}
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

def new global shared var v-row-titulo as rowid no-undo.

/* Local Variable Definitions ---                                       */
define variable c-lista-valor as character init '':U no-undo.
DEFINE VARIABLE l-abre-query AS LOGICAL INIT NO NO-UNDO.

def new global shared var da-cr0709-emis-ini as date        no-undo.
def new global shared var da-cr0709-emis-fim as date        no-undo.

{crp/cr0709.i}

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
&Scoped-define INTERNAL-TABLES titulo

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table titulo.ep-codigo titulo.cod-esp titulo.cod-emitente titulo.nome-abrev titulo.cod-estabel titulo.serie titulo.nr-docto titulo.parcela titulo.dt-vencimen titulo.mo-codigo titulo.vl-saldo titulo.vl-saldo-me   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define SELF-NAME br-table
&Scoped-define OPEN-QUERY-br-table if l-mostra-faixa-titulo then do:     if c-inicial = c-final then         open query {&SELF-NAME} for each titulo               where titulo.ep-codigo   = i-ep-codigo-usuario                 and titulo.cod-esp     = c-inicial                 and titulo.dt-emissao >= da-cr0709-emis-ini                 and titulo.dt-emissao <= da-cr0709-emis-fim               no-lock ~{&SORTBY-PHRASE} indexed-reposition.     else         open query {&SELF-NAME} for each titulo               where titulo.ep-codigo   = i-ep-codigo-usuario                 and titulo.cod-esp    >= c-inicial                 and titulo.cod-esp    <= c-final                 and titulo.dt-emissao >= da-cr0709-emis-ini                 and titulo.dt-emissao <= da-cr0709-emis-fim               no-lock ~{&SORTBY-PHRASE} indexed-reposition. end. else do:     if c-inicial = c-final then         open query {&SELF-NAME} for each titulo               where titulo.ep-codigo = i-ep-codigo-usuario                 and titulo.cod-esp   = c-inicial               no-lock ~{&SORTBY-PHRASE} indexed-reposition.     else         open query {&SELF-NAME} for each titulo               where titulo.ep-codigo  = i-ep-codigo-usuario                 and titulo.cod-esp   >= c-inicial                 and titulo.cod-esp   <= c-final               no-lock ~{&SORTBY-PHRASE} indexed-reposition. end.
&Scoped-define TABLES-IN-QUERY-br-table titulo
&Scoped-define FIRST-TABLE-IN-QUERY-br-table titulo


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-inicial c-final bt-confirma br-table ~
IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 
&Scoped-Define DISPLAYED-OBJECTS de-data-ini de-data-fim c-inicial c-final 

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
cod-emitente|y|y|movadm.titulo.cod-emitente
cod-esp|y|y|movadm.titulo.cod-esp
cod-estabel|y|y|movadm.titulo.cod-estabel
nome-abrev||y|movadm.titulo.nome-abrev
cod-cond-pag||y|movadm.titulo.cod-cond-pag
ep-codigo||y|movadm.titulo.ep-codigo
usuario||y|movadm.titulo.usuario
cod-rep||y|movadm.titulo.cod-rep
tp-codigo||y|movadm.titulo.tp-codigo
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "cod-emitente,cod-esp,cod-estabel",
     Keys-Supplied = "cod-emitente,cod-esp,cod-estabel,nome-abrev,cod-cond-pag,ep-codigo,usuario,cod-rep,tp-codigo"':U).

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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image\im-sav":U
     LABEL "Button 1" 
     SIZE 5.14 BY 1.

DEFINE VARIABLE c-final AS CHARACTER FORMAT "X(2)":U INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-inicial AS CHARACTER FORMAT "X(2)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE de-data-fim AS DATE FORMAT "99/99/99":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE de-data-ini AS DATE FORMAT "99/99/99":U 
     LABEL "Data EmissÆo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-3
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-4
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      titulo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table B-table-Win _FREEFORM
  QUERY br-table NO-LOCK DISPLAY
      titulo.ep-codigo
      titulo.cod-esp
      titulo.cod-emitente
      titulo.nome-abrev
      titulo.cod-estabel FORMAT "x(4)"
      titulo.serie FORMAT "x(6)"
      titulo.nr-docto
      titulo.parcela
      titulo.dt-vencimen
      titulo.mo-codigo
      titulo.vl-saldo FORMAT "->,>>>,>>>,>>9.99"
      titulo.vl-saldo-me
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 80 BY 8.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     de-data-ini AT ROW 1.04 COL 17 COLON-ALIGNED
     de-data-fim AT ROW 1.04 COL 43.29 COLON-ALIGNED NO-LABEL
     c-inicial AT ROW 2 COL 23.86 COLON-ALIGNED
     c-final AT ROW 2 COL 43.29 COLON-ALIGNED NO-LABEL
     bt-confirma AT ROW 2 COL 76
     br-table AT ROW 3 COL 1
     IMAGE-1 AT ROW 2 COL 30.29
     IMAGE-2 AT ROW 2 COL 42
     IMAGE-3 AT ROW 1.04 COL 30.29
     IMAGE-4 AT ROW 1.04 COL 42
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
         HEIGHT             = 10.33
         WIDTH              = 80.43.
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

/* SETTINGS FOR FILL-IN de-data-fim IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-data-ini IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _START_FREEFORM
if l-mostra-faixa-titulo then do:
    if c-inicial = c-final then
        open query {&SELF-NAME} for each titulo
              where titulo.ep-codigo   = i-ep-codigo-usuario
                and titulo.cod-esp     = c-inicial
                and titulo.dt-emissao >= da-cr0709-emis-ini
                and titulo.dt-emissao <= da-cr0709-emis-fim
              no-lock ~{&SORTBY-PHRASE} indexed-reposition.
    else
        open query {&SELF-NAME} for each titulo
              where titulo.ep-codigo   = i-ep-codigo-usuario
                and titulo.cod-esp    >= c-inicial
                and titulo.cod-esp    <= c-final
                and titulo.dt-emissao >= da-cr0709-emis-ini
                and titulo.dt-emissao <= da-cr0709-emis-fim
              no-lock ~{&SORTBY-PHRASE} indexed-reposition.
end.
else do:
    if c-inicial = c-final then
        open query {&SELF-NAME} for each titulo
              where titulo.ep-codigo = i-ep-codigo-usuario
                and titulo.cod-esp   = c-inicial
              no-lock ~{&SORTBY-PHRASE} indexed-reposition.
    else
        open query {&SELF-NAME} for each titulo
              where titulo.ep-codigo  = i-ep-codigo-usuario
                and titulo.cod-esp   >= c-inicial
                and titulo.cod-esp   <= c-final
              no-lock ~{&SORTBY-PHRASE} indexed-reposition.
end.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION SORTBY-PHRASE"
     _TblOptList       = "USED"
     _OrdList          = "movadm.titulo.cod-esp|yes"
     _Where[1]         = "titulo.cod-esp  >= c-inicial AND 
titulo.cod-esp  <= c-final
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


  if  avail titulo then do:
      assign v-row-titulo = rowid(titulo).
  end.


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
  ASSIGN l-abre-query = YES.
  
  assign input frame {&frame-name} c-inicial c-final.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  if l-mostra-faixa-titulo then
      assign de-data-ini:screen-value in frame {&frame-name} = string(da-cr0709-emis-ini)
             de-data-fim:screen-value in frame {&frame-name} = string(da-cr0709-emis-fim).
  apply 'value-changed' to {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

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
    WHEN 'cod-emitente':U THEN DO:
       &Scope KEY-PHRASE titulo.cod-emitente eq INTEGER(key-value)
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* cod-emitente */
    WHEN 'cod-esp':U THEN DO:
       &Scope KEY-PHRASE titulo.cod-esp eq key-value
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* cod-esp */
    WHEN 'cod-estabel':U THEN DO:
       &Scope KEY-PHRASE titulo.cod-estabel eq key-value
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* cod-estabel */
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
  {utp/ut-liter.i Saldo_Moeda_Nacional * L}
  assign titulo.vl-saldo:label in browse {&browse-name} = return-value.
  
  {utp/ut-liter.i Saldo_Moeda_Estrangeira * L}
  assign titulo.vl-saldo-me:label in browse {&browse-name} = return-value.
  
  {utp/ut-liter.i Esp‚cie * L}
  assign c-inicial:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Dt_Vencimento * L}
  assign titulo.dt-vencimen:label in browse {&browse-name} = return-value.

  assign c-inicial = " "
         c-final = "ZZ".
  /* Dispatch standard ADM method.                             */
  if l-mostra-faixa-titulo then
      assign de-data-ini:visible   in frame {&frame-name} = yes
             de-data-fim:visible   in frame {&frame-name} = yes
             IMAGE-3:visible       in frame {&frame-name} = yes
             IMAGE-4:visible       in frame {&frame-name} = yes 
             de-data-ini:screen-value in frame {&frame-name} = string(da-cr0709-emis-ini)
             de-data-fim:screen-value in frame {&frame-name} = string(da-cr0709-emis-fim).
  else
      assign de-data-ini:visible   in frame {&frame-name} = no
             de-data-fim:visible   in frame {&frame-name} = no
             IMAGE-3:visible       in frame {&frame-name} = no
             IMAGE-4:visible       in frame {&frame-name} = no.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  assign c-final:screen-value in frame {&frame-name} = "ZZZZZZZZZZZZZZZZ".
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  IF l-abre-query THEN
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-valor B-table-Win 
PROCEDURE pi-retorna-valor :
DEFINE INPUT PARAMETER P-CAMPO AS CHARACTER NO-UNDO.

    DEFINE VARIABLE P-VALOR AS CHAR INIT "" NO-UNDO.

    if  avail titulo then do:
        case p-campo:
            when "cod-esp" then
                assign p-valor = string(titulo.cod-esp).
            when "cod-emitente" then
                assign p-valor = string(titulo.cod-emitente).
            when "nome-abrev" then
                assign p-valor = string(titulo.nome-abrev).
            when "cod-estabel" then
                assign p-valor = string(titulo.cod-estabel).
            when "serie" then
                assign p-valor = string(titulo.serie).
            when "nr-docto" then
                assign p-valor = string(titulo.nr-docto).
            when "parcela" then
                assign p-valor = string(titulo.parcela).
            when "dt-vencimen" then
                assign p-valor = string(titulo.dt-vencimen).
            when "mo-codigo" then
                assign p-valor = string(titulo.mo-codigo).
            when "vl-saldo" then
                assign p-valor = string(titulo.vl-saldo).
            when "vl-saldo-me" then
                assign p-valor = string(titulo.vl-saldo-me).
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
  {src/adm/template/sndkycas.i "cod-emitente" "titulo" "cod-emitente"}
  {src/adm/template/sndkycas.i "cod-esp" "titulo" "cod-esp"}
  {src/adm/template/sndkycas.i "cod-estabel" "titulo" "cod-estabel"}
  {src/adm/template/sndkycas.i "nome-abrev" "titulo" "nome-abrev"}
  {src/adm/template/sndkycas.i "cod-cond-pag" "titulo" "cod-cond-pag"}
  {src/adm/template/sndkycas.i "ep-codigo" "titulo" "ep-codigo"}
  {src/adm/template/sndkycas.i "usuario" "titulo" "usuario"}
  {src/adm/template/sndkycas.i "cod-rep" "titulo" "cod-rep"}
  {src/adm/template/sndkycas.i "tp-codigo" "titulo" "tp-codigo"}

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

