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
{include/i-prgvrs.i B04AD039 2.00.00.008}  /*** "010008" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i B04AD039 MUT}
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
define variable c-lista-valor as character init '':U no-undo.
def var c-descricao    as char NO-UNDO FORMAT "x(13)".
def var c-lista-desc  as char no-undo.
DEF VAR c-descricao-aux AS CHAR NO-UNDO.
DEF VAR i-cont          AS INT  NO-UNDO.

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
&Scoped-define INTERNAL-TABLES cond-pagto

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table cond-pagto.descricao ~
cond-pagto.cod-cond-pag ~
cond-pagto.log-cond-pagto-mais-negoc ~
entry (cond-pagto.cod-vencto, c-lista-desc) @ c-descricao ~
cond-pagto.prazos[1] cond-pagto.prazos[2] cond-pagto.prazos[3] ~
cond-pagto.prazos[4] cond-pagto.prazos[5] cond-pagto.prazos[6] ~
cond-pagto.prazos[7] cond-pagto.prazos[8] cond-pagto.prazos[9] ~
cond-pagto.prazos[10] cond-pagto.prazos[11] cond-pagto.prazos[12] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table 
&Scoped-define QUERY-STRING-br-table FOR EACH cond-pagto ~
      WHERE cond-pagto.descricao >= fi-descricao-ini and ~
mgadm.cond-pagto.descricao <= fi-descricao-fim and ~
mgadm.cond-pagto.log-cond-pagto-mais-negoc = fi-mais-negoc NO-LOCK ~
    BY cond-pagto.descricao INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-table OPEN QUERY br-table FOR EACH cond-pagto ~
      WHERE cond-pagto.descricao >= fi-descricao-ini and ~
mgadm.cond-pagto.descricao <= fi-descricao-fim and ~
mgadm.cond-pagto.log-cond-pagto-mais-negoc = fi-mais-negoc NO-LOCK ~
    BY cond-pagto.descricao INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-table cond-pagto
&Scoped-define FIRST-TABLE-IN-QUERY-br-table cond-pagto


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-descricao-ini fi-descricao-fim fi-mais-negoc ~
bt-confirma br-table IMAGE-1 IMAGE-2 
&Scoped-Define DISPLAYED-OBJECTS fi-descricao-ini fi-descricao-fim fi-mais-negoc

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
cod-cond-pag||y|mgadm.cond-pagto.cod-cond-pag
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "cod-cond-pag"':U).

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
     IMAGE-UP FILE "image~\im-sav":U
     LABEL "Button 1" 
     SIZE 5.14 BY 1.

DEFINE VARIABLE fi-descricao-fim AS CHARACTER FORMAT "x(30)" INITIAL "zzzzzzzzzzzzzzzzzzzzzzzzzzzzz" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY 1.

DEFINE VARIABLE fi-descricao-ini AS CHARACTER FORMAT "x(30)" 
     LABEL "Descri‡Æo":R11 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY 1.

DEFINE VARIABLE fi-mais-negoc AS LOGICAL
     LABEL "Mais Neg¢cios"
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY 1.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\ii-las":U
     SIZE 2.86 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      cond-pagto
    FIELDS(cond-pagto.descricao
      cond-pagto.cod-cond-pag
      cond-pagto.log-cond-pagto-mais-negoc
      cond-pagto.cod-vencto
      cond-pagto.prazos[1]
      cond-pagto.prazos[2]
      cond-pagto.prazos[3]
      cond-pagto.prazos[4]
      cond-pagto.prazos[5]
      cond-pagto.prazos[6]
      cond-pagto.prazos[7]
      cond-pagto.prazos[8]
      cond-pagto.prazos[9]
      cond-pagto.prazos[10]
      cond-pagto.prazos[11]
      cond-pagto.prazos[12]) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table B-table-Win _STRUCTURED
  QUERY br-table NO-LOCK DISPLAY
      cond-pagto.descricao FORMAT "x(30)":U
      cond-pagto.cod-cond-pag FORMAT ">>>9":U
      cond-pagto.log-cond-pagto-mais-negoc
      entry (cond-pagto.cod-vencto, c-lista-desc) @ c-descricao
      cond-pagto.prazos[1] COLUMN-LABEL "" FORMAT ">>>":U
      cond-pagto.prazos[2] COLUMN-LABEL "" FORMAT ">>>":U
      cond-pagto.prazos[3] COLUMN-LABEL "" FORMAT ">>>":U
      cond-pagto.prazos[4] COLUMN-LABEL "" FORMAT ">>>":U
      cond-pagto.prazos[5] COLUMN-LABEL "" FORMAT ">>>":U
      cond-pagto.prazos[6] COLUMN-LABEL "" FORMAT ">>>":U
      cond-pagto.prazos[7] COLUMN-LABEL "" FORMAT ">>>":U
      cond-pagto.prazos[8] COLUMN-LABEL "" FORMAT ">>>":U
      cond-pagto.prazos[9] COLUMN-LABEL "" FORMAT ">>>":U
      cond-pagto.prazos[10] COLUMN-LABEL "" FORMAT ">>>":U
      cond-pagto.prazos[11] COLUMN-LABEL "" FORMAT ">>>":U
      cond-pagto.prazos[12] COLUMN-LABEL "" FORMAT ">>>":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 86 BY 8.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fi-descricao-ini AT ROW 1 COL 11 COLON-ALIGNED
     fi-descricao-fim AT ROW 1 COL 48 COLON-ALIGNED NO-LABEL
     fi-mais-negoc    AT ROW 2.25 COL 13 
     bt-confirma AT ROW 1 COL 82
     br-table AT ROW 3.50 COL 1
     IMAGE-1 AT ROW 1 COL 44
     IMAGE-2 AT ROW 1 COL 47
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
         HEIGHT             = 10.29
         WIDTH              = 86.57.
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
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br-table bt-confirma F-Main */
ASSIGN        FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _TblList          = "mgadm.cond-pagto"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = "USED"
     _OrdList          = "mgadm.cond-pagto.descricao|yes"
     _Where[1]         = "mgadm.cond-pagto.descricao >= fi-descricao-ini and
mgadm.cond-pagto.descricao <= fi-descricao-fim"
     _FldNameList[1]   = mgadm.cond-pagto.descricao
     _FldNameList[2]   = mgadm.cond-pagto.cod-cond-pag
     _FldNameList[3]   > "_<CALC>"
"entry (cond-pagto.cod-vencto, c-lista-desc) @ c-descricao" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[4]   > mgadm.cond-pagto.prazos[1]
"cond-pagto.prazos[1]" "" ">>>" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[5]   > mgadm.cond-pagto.prazos[2]
"cond-pagto.prazos[2]" "" ">>>" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[6]   > mgadm.cond-pagto.prazos[3]
"cond-pagto.prazos[3]" "" ">>>" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[7]   > mgadm.cond-pagto.prazos[4]
"cond-pagto.prazos[4]" "" ">>>" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[8]   > mgadm.cond-pagto.prazos[5]
"cond-pagto.prazos[5]" "" ">>>" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[9]   > mgadm.cond-pagto.prazos[6]
"cond-pagto.prazos[6]" "" ">>>" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[10]   > mgadm.cond-pagto.prazos[7]
"cond-pagto.prazos[7]" "" ">>>" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[11]   > mgadm.cond-pagto.prazos[8]
"cond-pagto.prazos[8]" "" ">>>" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[12]   > mgadm.cond-pagto.prazos[9]
"cond-pagto.prazos[9]" "" ">>>" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[13]   > mgadm.cond-pagto.prazos[10]
"cond-pagto.prazos[10]" "" ">>>" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[14]   > mgadm.cond-pagto.prazos[11]
"cond-pagto.prazos[11]" "" ">>>" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[15]   > mgadm.cond-pagto.prazos[12]
"cond-pagto.prazos[12]" "" ">>>" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
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
  assign input frame {&frame-name} fi-descricao-ini fi-descricao-fim fi-mais-negoc.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-descricao-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-descricao-ini B-table-Win
ON ANY-KEY OF fi-descricao-ini IN FRAME F-Main /* Descri‡Æo */
DO:
     {include/i-anykey.i &variavel=fi-descricao-ini} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
{utp/ut-field.i mgadm cond-pagto cod-vencto 2}
assign c-descricao:label in browse br-table = return-value.

{utp/ut-field.i mgadm cond-pagto cod-cond-pag 2}
assign cond-pagto.prazos[1]:label in browse br-table = return-value.

{utp/ut-field.i mgadm cond-pagto descricao 1}
assign fi-descricao-ini:label in frame {&frame-name} = return-value.

{utp/ut-liter.i +Neg¢cios *}
assign cond-pagto.log-cond-pagto-mais-negoc:label in browse {&browse-name} = return-value.

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {diinc/i02di165.i 03}.
    RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao001).
    ASSIGN  c-lista-desc = cAuxTraducao001. 
&else
    ASSIGN c-lista-desc = {diinc/i02di165.i 03}.
&endif

DO i-cont = 1 TO NUM-ENTRIES(c-lista-desc):
    ASSIGN c-descricao-aux = ENTRY(i-cont,c-lista-desc,",").
    RUN utp/ut-liter.p (INPUT replace(c-descricao-aux," ","_"),"","").
    ASSIGN ENTRY(i-cont,c-lista-desc,",") = TRIM(RETURN-VALUE).
END.

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
  DEF VAR Filter-Value AS CHAR NO-UNDO.

  /* Copy 'Filter-Attributes' into local variables. */
  RUN get-attribute ('Filter-Value':U).
  Filter-Value = RETURN-VALUE.

  /* No Foreign keys are accepted by this SmartObject. */

  {&OPEN-QUERY-{&BROWSE-NAME}}

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

  DEFINE VARIABLE v_hdl_api        AS HANDLE      NO-UNDO.
  DEFINE VARIABLE v_log_integr_mng AS LOGICAL     NO-UNDO.
  
    
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  run hbbo/boParamFuncaoProdut.p persistent set v_hdl_api.
           
  run pi_existe_funcao in v_hdl_api (input "TOTVS Mais Negocios",
                                     output v_log_integr_mng).
  
  DELETE PROCEDURE v_hdl_api.
  ASSIGN cond-pagto.log-cond-pagto-mais-negoc:VISIBLE in browse {&browse-name} = v_log_integr_mng
         fi-mais-negoc:HIDDEN IN FRAME {&FRAME-NAME} = IF v_log_integr_mng THEN FALSE ELSE TRUE.

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

    if  avail mgadm.cond-pagto then do:
        case p-campo:
            when "cod-cond-pag" then
                assign p-valor = string(cond-pagto.cod-cond-pag).
            when "descricao" then
                assign p-valor = string(cond-pagto.descricao).
            when "log-cond-pagto-mais-negoc" then
                assign p-valor = string(cond-pagto.log-cond-pagto-mais-negoc).
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
  {src/adm/template/sndkycas.i "cod-cond-pag" "cond-pagto" "cod-cond-pag"}

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
  APPLY "entry":u TO fi-descricao-ini IN FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "RetornaValorCampo" B-table-Win _INLINE
/* Actions: ? ? ? ? support/brwrtval.p */
/* Procedure desativada */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

