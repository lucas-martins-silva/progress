&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movadm           PROGRESS
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
{include/i-prgvrs.i B01AD260 2.00.00.026}  /*** 010026 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i b01ad260 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def new global shared var v-row-documento as rowid no-undo.
def new global shared var i-fornec        as int initial 0        no-undo.
def new global shared var i-forn-ini      as int initial 0        no-undo.
def new global shared var i-forn-fim      as int initial 99999999 no-undo.
def new global shared var l-ap0591a       as log initial no       no-undo.
def new global shared var l-saida         as log initial no       no-undo.
define variable c-lista-valor as character init '':U no-undo.

DEFINE VARIABLE l-controle AS LOGICAL INITIAL NO NO-UNDO.

{utp/ut-glob.i}

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
&Scoped-define INTERNAL-TABLES tit-ap

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table tit-ap.cod-fornec ~
tit-ap.cod-estabel tit-ap.cod-esp tit-ap.serie tit-ap.nr-docto ~
tit-ap.parcela tit-ap.vl-orig-me tit-ap.vl-saldo-me tit-ap.moeda ~
tit-ap.portador tit-ap.nome-abrev tit-ap.dt-vencimen 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table 
&Scoped-define QUERY-STRING-br-table FOR EACH tit-ap ~
      WHERE tit-ap.cod-fornec >= c-inicial ~
 AND tit-ap.cod-fornec <= c-final ~
 AND tit-ap.ep-codigo = i-ep-codigo-usuario ~
 AND tit-ap.valor-saldo > 0 ~
 AND (tit-ap.tipo = 1 ~
 or   tit-ap.tipo = 8) ~
  NO-LOCK ~
    BY tit-ap.ep-codigo ~
       BY tit-ap.cod-fornec INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-table OPEN QUERY br-table FOR EACH tit-ap ~
      WHERE tit-ap.cod-fornec >= c-inicial ~
 AND tit-ap.cod-fornec <= c-final ~
 AND tit-ap.ep-codigo = i-ep-codigo-usuario ~
 AND tit-ap.valor-saldo > 0 ~
 AND (tit-ap.tipo = 1 ~
 or   tit-ap.tipo = 8) ~
  NO-LOCK ~
    BY tit-ap.ep-codigo ~
       BY tit-ap.cod-fornec INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-table tit-ap
&Scoped-define FIRST-TABLE-IN-QUERY-br-table tit-ap


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-inicial c-final bt-confirma IMAGE-1 ~
IMAGE-2 br-table 
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
</FOREIGN-KEYS
><EXECUTING-CODE>
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
     IMAGE-UP FILE "image~\im-sav":U
     LABEL "Button 1" 
     SIZE 5.14 BY 1.

DEFINE VARIABLE c-final AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-inicial AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\ii-las":U
     SIZE 2.86 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      tit-ap
    FIELDS(tit-ap.cod-fornec
      tit-ap.cod-estabel
      tit-ap.cod-esp
      tit-ap.serie
      tit-ap.nr-docto
      tit-ap.parcela
      tit-ap.vl-orig-me
      tit-ap.vl-saldo-me
      tit-ap.moeda
      tit-ap.portador
      tit-ap.nome-abrev
      tit-ap.dt-vencimen) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table B-table-Win _STRUCTURED
  QUERY br-table NO-LOCK DISPLAY
      tit-ap.cod-fornec FORMAT ">>>>>>>>9":U
      tit-ap.cod-estabel FORMAT "x(5)":U
      tit-ap.cod-esp FORMAT "!!":U
      tit-ap.serie FORMAT "x(5)":U
      tit-ap.nr-docto FORMAT "x(16)":U
      tit-ap.parcela FORMAT "x(2)":U
      tit-ap.vl-orig-me COLUMN-LABEL "Valor Original Moeda" FORMAT "->>>>>>>,>>9.99":U
      tit-ap.vl-saldo-me FORMAT ">>>>>>>,>>9.99":U
      tit-ap.moeda FORMAT ">9":U
      tit-ap.portador FORMAT ">>>>9":U
      tit-ap.nome-abrev FORMAT "X(12)":U
      tit-ap.dt-vencimen FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 83.43 BY 9.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-inicial AT ROW 1 COL 25 COLON-ALIGNED
     c-final AT ROW 1 COL 46.43 COLON-ALIGNED NO-LABEL
     bt-confirma AT ROW 1 COL 78.14
     br-table AT ROW 2.17 COL 1
     IMAGE-1 AT ROW 1 COL 39
     IMAGE-2 AT ROW 1 COL 45
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
         HEIGHT             = 10.25
         WIDTH              = 83.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{include/c-brwzoo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
/* BROWSE-TAB br-table IMAGE-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _TblList          = "movadm.tit-ap"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = "USED"
     _OrdList          = "movadm.tit-ap.ep-codigo|yes,movadm.tit-ap.cod-fornec|yes"
     _Where[1]         = "tit-ap.cod-fornec >= c-inicial
 AND tit-ap.cod-fornec <= c-final
 AND tit-ap.ep-codigo = i-ep-codigo-usuario
 AND tit-ap.valor-saldo > 0
 AND (tit-ap.tipo = 1
 or   tit-ap.tipo = 8)
 "
     _FldNameList[1]   = movadm.tit-ap.cod-fornec
     _FldNameList[2]   > movadm.tit-ap.cod-estabel
"cod-estabel" ? "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   = movadm.tit-ap.cod-esp
     _FldNameList[4]   = movadm.tit-ap.serie
     _FldNameList[5]   = movadm.tit-ap.nr-docto
     _FldNameList[6]   = movadm.tit-ap.parcela
     _FldNameList[7]   > movadm.tit-ap.vl-orig-me
"vl-orig-me" "Valor Original Moeda" "->>>>>>>,>>9.99" "" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[8]   = movadm.tit-ap.vl-saldo-me
     _FldNameList[9]   = movadm.tit-ap.moeda
     _FldNameList[10]   = movadm.tit-ap.portador
     _FldNameList[11]   = movadm.tit-ap.nome-abrev
     _FldNameList[12]   = movadm.tit-ap.dt-vencimen
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
    assign l-saida = yes.
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
  
  if  avail tit-ap then
      assign v-row-documento = rowid(tit-ap).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma B-table-Win
ON CHOOSE OF bt-confirma IN FRAME F-Main /* Button 1 */
DO:
  assign input frame {&frame-name} c-inicial c-final.
  assign i-forn-ini = c-inicial
         i-forn-fim = c-final
         l-controle = YES.
  
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

ASSIGN c-inicial:SCREEN-VALUE = "0"
       c-final:SCREEN-VALUE   = "999999999".

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).  
      
&ENDIF
/*{utp/ut-field.i mgadm tit-ap Fornecedor 1}
assign c-inicial:label in frame {&frame-name} = trim(return-value).*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  {utp/ut-liter.i Valor_Original MAP R}
  assign tit-ap.vl-orig-me:label in browse {&browse-name} = trim(return-value).
  
  {utp/ut-liter.i Fornecedor MAP R}   
  assign c-inicial:label in frame {&frame-name} = trim(return-value).
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  if l-ap0591a = yes then do:
     assign c-inicial:screen-value in frame {&FRAME-NAME} = string(i-fornec)
            c-final:screen-value   in frame {&FRAME-NAME} = string(i-fornec).     
     APPLY "CHOOSE" to bt-confirma.
  end.   

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
  IF l-controle = YES THEN DO:
    
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .
    
      apply 'entry' to c-inicial in frame {&FRAME-NAME}.
      return error.

  END.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  if  input frame {&frame-name} c-inicial > 
      input frame {&frame-name} c-final then do:
     run utp/ut-msgs.p(input "show",
                       input 3441,
                       input "").
      apply "entry" to c-inicial in frame {&frame-name}.
      return "adm-error".
  end.
      

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  apply 'entry' to c-inicial in frame {&FRAME-NAME}.
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

    if  avail tit-ap then do:
        case p-campo:
            when "cod-fornec" then
                assign p-valor = string(tit-ap.cod-fornec).
            when "nome-abrev" then
                assign p-valor = string(tit-ap.nome-abrev).
            when "cod-estabel" then
                assign p-valor = string(tit-ap.cod-estabel).
            when "cod-esp" then
                assign p-valor = string(tit-ap.cod-esp).
            when "serie" then
                assign p-valor = string(tit-ap.serie).
            when "nr-docto" then
                assign p-valor = string(tit-ap.nr-docto).
            when "parcela" then
                assign p-valor = string(tit-ap.parcela).
            when "dt-vencimen" then
                assign p-valor = string(tit-ap.dt-vencimen).
            when "moeda" then
                assign p-valor = string(tit-ap.moeda).
            when "valor-saldo" then
                assign p-valor = string(tit-ap.valor-saldo).
            when "vl-saldo-me" then
                assign p-valor = string(tit-ap.vl-saldo-me).
        end.
    end.
    return p-valor.
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

