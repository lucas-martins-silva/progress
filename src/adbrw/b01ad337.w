&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i B01AD337 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i B01AD337 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */
&SCOPED-DEFINE adm-attribute-dlg support/browserd.w

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-conteudo   AS CHARACTER NO-UNDO FORMAT "X(50)":U.
DEFINE VARIABLE c-operador   AS CHARACTER NO-UNDO FORMAT "X(15)":U.
DEFINE VARIABLE i-area       AS INTEGER   NO-UNDO.
DEFINE VARIABLE v-row-parent AS ROWID     NO-UNDO.
DEFINE VARIABLE v-row-table  AS ROWID     NO-UNDO.
DEFINE VARIABLE cTexto       AS CHARACTER FORMAT "X(03)".

/* Include Definitions ---                                              */
{include/i_dbvers.i}
{include/i_fnctrad.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE BrowserCadastro2
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cenario-ge
&Scoped-define FIRST-EXTERNAL-TABLE cenario-ge


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cenario-ge.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES obj-cenario

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table obj-cenario.seq-objetivo ~
ENTRY(obj-cenario.cod-conteudo, c-conteudo) @ c-conteudo ~
ENTRY(obj-cenario.cod-operador, c-operador) @ c-operador ~
obj-cenario.dt-objetivo obj-cenario.vl-objetivo ~
&IF "{&mgadm_version}":U = "2.03":U &THEN   obj-cenario.dec-1 &ELSE   obj-cenario.vl-realizado &ENDIF ~
&IF "{&mgadm_version}":U = "2.03":U &THEN   fnc_trad(obj-cenario.log-1) @ cTexto &ELSE   fnc_trad(obj-cenario.log-atualizado) @ cTexto &ENDIF 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table 
&Scoped-define QUERY-STRING-br-table FOR EACH obj-cenario OF cenario-ge WHERE ~{&KEY-PHRASE} ~
      AND obj-cenario.area = i-area NO-LOCK ~
    BY obj-cenario.seq-objetivo INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-table OPEN QUERY br-table FOR EACH obj-cenario OF cenario-ge WHERE ~{&KEY-PHRASE} ~
      AND obj-cenario.area = i-area NO-LOCK ~
    BY obj-cenario.seq-objetivo INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-table obj-cenario
&Scoped-define FIRST-TABLE-IN-QUERY-br-table obj-cenario


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-table bt-incluir bt-modificar bt-eliminar 

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
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).

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
<FILTER-ATTRIBUTES></FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnc_trad B-table-Win 
FUNCTION fnc_trad RETURNS CHARACTER
  ( lLiter As Logical )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-eliminar 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-incluir 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-modificar 
     LABEL "&Modificar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      obj-cenario SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table B-table-Win _STRUCTURED
  QUERY br-table NO-LOCK DISPLAY
      obj-cenario.seq-objetivo FORMAT ">>>9":U
      ENTRY(obj-cenario.cod-conteudo, c-conteudo) @ c-conteudo
      ENTRY(obj-cenario.cod-operador, c-operador) @ c-operador
      obj-cenario.dt-objetivo FORMAT "99/99/9999":U
      obj-cenario.vl-objetivo FORMAT "->>>,>>>,>>>,>>9.999999":U
      &IF "{&mgadm_version}":U = "2.03":U &THEN
  obj-cenario.dec-1
&ELSE
  obj-cenario.vl-realizado
&ENDIF FORMAT "->>>,>>>,>>>,>>9.999999":U
      &IF "{&mgadm_version}":U = "2.03":U &THEN
  fnc_trad(obj-cenario.log-1) @ cTexto
&ELSE
  fnc_trad(obj-cenario.log-atualizado) @ cTexto
&ENDIF
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 88 BY 8.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br-table AT ROW 1 COL 1
     bt-incluir AT ROW 9.25 COL 1
     bt-modificar AT ROW 9.25 COL 11
     bt-eliminar AT ROW 9.25 COL 21
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: BrowserCadastro2
   External Tables: mgadm.cenario-ge
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: External-Tables
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 9.42
         WIDTH              = 88.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{utp/ut-glob.i}
{src/adm/method/browser.i}
{include/c-brows3.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
/* BROWSE-TAB br-table 1 F-Main */
ASSIGN        FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _TblList          = "mgadm.obj-cenario OF mgadm.cenario-ge"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE"
     _OrdList          = "mgadm.obj-cenario.seq-objetivo|yes"
     _Where[1]         = "obj-cenario.area = i-area"
     _FldNameList[1]   = mgadm.obj-cenario.seq-objetivo
     _FldNameList[2]   > "_<CALC>"
"ENTRY(obj-cenario.cod-conteudo, c-conteudo) @ c-conteudo" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   > "_<CALC>"
"ENTRY(obj-cenario.cod-operador, c-operador) @ c-operador" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[4]   = mgadm.obj-cenario.dt-objetivo
     _FldNameList[5]   = mgadm.obj-cenario.vl-objetivo
     _FldNameList[6]   > "_<CALC>"
"&IF ""{&mgadm_version}"":U = ""2.03"":U &THEN
  obj-cenario.dec-1
&ELSE
  obj-cenario.vl-realizado
&ENDIF" ? ">>>,>>>,>>>,>>9.999999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[7]   > "_<CALC>"
"&IF ""{&mgadm_version}"":U = ""2.03"":U &THEN
  fnc_trad(obj-cenario.log-1) @ cTexto
&ELSE
  fnc_trad(obj-cenario.log-atualizado) @ cTexto
&ENDIF" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
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
    if  avail obj-cenario
    then do:

        RUN New-State("DblClick, SELF":U).

    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-ENTRY OF br-table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}  
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

    {src/adm/template/brschnge.i}
    /*  run new-state('New-Line|':U + string(rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}))).*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar B-table-Win
ON CHOOSE OF bt-eliminar IN FRAME F-Main /* Eliminar */
DO:
    RUN pi-eliminar IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir B-table-Win
ON CHOOSE OF bt-incluir IN FRAME F-Main /* Incluir */
DO:
    RUN pi-incmod IN THIS-PROCEDURE (INPUT "incluir":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-modificar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modificar B-table-Win
ON CHOOSE OF bt-modificar IN FRAME F-Main /* Modificar */
DO:
    RUN pi-incmod IN THIS-PROCEDURE (INPUT "modificar":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
ASSIGN cAuxTraducao001 = {adinc/i02ad337.i 03}.
RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao001).
ASSIGN c-conteudo = cAuxTraducao001.
&else
ASSIGN c-conteudo = {adinc/i02ad337.i 03}.
&endif
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao002 = {adinc/i03ad337.i 03}.
    RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao002).
    ASSIGN c-operador = cAuxTraducao002.
&else
    ASSIGN c-operador = {adinc/i03ad337.i 03}.
&endif
&IF "{&FNC_MULTI_IDIOMA}" &THEN
      Def Var i As Integer No-undo.
      Repeat i = 1 To Num-entries(c-conteudo):
          If i < Num-entries(c-operador) Then Do:
              Run utp/ut-liter.p (input replace(Entry(i,c-conteudo)," ","_"),"*","").
              Assign Entry(i,c-conteudo) = Return-value.
              Run utp/ut-liter.p (input replace(Entry(i,c-operador)," ","_"),"*","").
              Assign Entry(i,c-operador) = Return-value.
          End.
          Else Do:
              Run utp/ut-liter.p (input replace(Entry(i,c-conteudo)," ","_"),"*","").
              Assign Entry(i,c-conteudo) = Return-value.
          End.
      End.
&ENDIF


{utp/ut-liter.i Conte£do}
ASSIGN c-conteudo:LABEL IN BROWSE {&BROWSE-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Operador}
ASSIGN c-operador:LABEL IN BROWSE {&BROWSE-NAME} = TRIM(RETURN-VALUE).

&IF "{&mgadm_version}":U = "2.03":U &THEN
    {utp/ut-liter.i Vl_Realizado}
    ASSIGN obj-cenario.dec-1:LABEL IN BROWSE {&BROWSE-NAME} = TRIM(RETURN-VALUE).
&ENDIF

{utp/ut-liter.i Obj_Atual}
ASSIGN cTexto:LABEL IN BROWSE {&BROWSE-NAME} = TRIM(RETURN-VALUE).


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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "cenario-ge"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cenario-ge"}

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

    RUN What-Is-The-Page IN adm-broker-hdl (INPUT THIS-PROCEDURE).

    ASSIGN i-area = INTEGER(RETURN-VALUE) NO-ERROR.

    /* RUN pi-atualiza-conteudo IN THIS-PROCEDURE. */

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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
    APPLY "VALUE-CHANGED":U TO {&BROWSE-NAME} IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-conteudo B-table-Win 
PROCEDURE pi-atualiza-conteudo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CASE i-area:
        WHEN 1 THEN ASSIGN c-conteudo = ENTRY(1, c-conteudo) + ",":U + 
                                        ENTRY(2, c-conteudo).

        WHEN 2 THEN ASSIGN c-conteudo = ENTRY(3, c-conteudo) + ",":U + 
                                        ENTRY(4, c-conteudo).

        WHEN 3 THEN ASSIGN c-conteudo = ENTRY(5, c-conteudo) + ",":U + 
                                        ENTRY(6, c-conteudo) + ",":U +
                                        ENTRY(7, c-conteudo).

        WHEN 4 THEN ASSIGN c-conteudo = ENTRY(8, c-conteudo) + ",":U + 
                                        ENTRY(9, c-conteudo) + ",":U + 
                                        ENTRY(10, c-conteudo) + ",":U + 
                                        ENTRY(11, c-conteudo) + ",":U + 
                                        ENTRY(12, c-conteudo) + ",":U + 
                                        ENTRY(13, c-conteudo).

        WHEN 5 THEN ASSIGN c-conteudo = ENTRY(14, c-conteudo) + ",":U + 
                                        ENTRY(15, c-conteudo) + ",":U + 
                                        ENTRY(16, c-conteudo) + ",":U + 
                                        ENTRY(17, c-conteudo) + ",":U + 
                                        ENTRY(18, c-conteudo) + ",":U + 
                                        ENTRY(19, c-conteudo).

        WHEN 6 THEN ASSIGN c-conteudo = ENTRY(20, c-conteudo).
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-area B-table-Win 
PROCEDURE pi-retorna-area :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-area AS INTEGER NO-UNDO.

    ASSIGN p-area = i-area.

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

  /* There are no foreign keys supplied by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cenario-ge"}
  {src/adm/template/snd-list.i "obj-cenario"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

    RUN pi-trata-state IN THIS-PROCEDURE (INPUT p-issuer-hdl, INPUT p-state).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnc_trad B-table-Win 
FUNCTION fnc_trad RETURNS CHARACTER
  ( lLiter As Logical ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  Run utp/ut-liter.p (input String(lLiter,"Sim/NÆo"),"*","").
  RETURN Return-value.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

