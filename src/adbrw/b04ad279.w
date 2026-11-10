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
{include/i-prgvrs.i B04AD279 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i B04AD279 MUT}
&ENDIF



/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{include/i_fnctrad.i}
/* Preprocessor Definitions ---                                         */
&SCOPED-DEFINE adm-attribute-dlg support/browserd.w

/* Temp-Table Definitions ---                                           */
def temp-table tt_mod_ems no-undo
    field tta_cod_modul_dtsul              as character format "x(3)" 
    field tta_des_modul_dtsul              as character format "x(25)"
    field ttv_num_produto                  as integer format ">9"
    index tt_mod_id                        is primary unique
          ttv_num_produto                  ascending
          tta_cod_modul_dtsul              ascending.

def temp-table tt_mod_proc_prog_ems no-undo
    field tta_cod_modul_dtsul              as character format "x(3)" 
    field tta_des_modul_dtsul              as character format "x(28)" 
    field tta_cod_proced                   as character format "x(32)" 
    field tta_des_proced                   as character format "x(60)" 
    field tta_nom_proced_menu              as character format "x(32)" 
    field tta_cod_prog_dtsul_base          as character format "x(50)" 
    field tta_cod_prog_dtsul               as character format "x(50)" 
    field tta_des_prog_dtsul               as character format "x(40)" 
    field tta_nom_prog_dtsul_menu          as character format "x(40)" 
    field tta_nom_prog_ext                 as character format "x(32)" 
    field ttv_num_produto                  as integer format ">9"
    field ttv_log_selec                    as logical 
    field ttv_log_selec_2                  as logical 
    index tt_mod_id                        is primary unique
          ttv_num_produto                  ascending
          tta_cod_modul_dtsul              ascending
          tta_cod_proced                   ascending
          tta_cod_prog_dtsul               ascending
    index tt_prog_desc                    
          tta_des_prog_dtsul               ascending.
          
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-browse AS HANDLE NO-UNDO.
def var c-des-produto as char   no-undo.
def var c-handle      as char   no-undo.
def var h-brw-prog    as handle no-undo.

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
&Scoped-define INTERNAL-TABLES tt_mod_ems

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table tt_mod_ems.tta_cod_modul_dtsul tt_mod_ems.tta_des_modul_dtsul fn-retorna-des-produto(tt_mod_ems.ttv_num_produto) @ c-des-produto   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define SELF-NAME br-table
&Scoped-define OPEN-QUERY-br-table OPEN QUERY br-table FOR EACH tt_mod_ems NO-LOCK     BY tt_mod_ems.tta_cod_modul_dtsul.
&Scoped-define TABLES-IN-QUERY-br-table tt_mod_ems
&Scoped-define FIRST-TABLE-IN-QUERY-br-table tt_mod_ems


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br-table}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-table 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-retorna-des-produto B-table-Win 
FUNCTION fn-retorna-des-produto RETURNS CHARACTER
  (input i-num-produto as int)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      tt_mod_ems SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table B-table-Win _FREEFORM
  QUERY br-table NO-LOCK DISPLAY
      tt_mod_ems.tta_cod_modul_dtsul
tt_mod_ems.tta_des_modul_dtsul
fn-retorna-des-produto(tt_mod_ems.ttv_num_produto) @ c-des-produto
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 44 BY 8.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br-table AT ROW 1 COL 1
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 8.5
         WIDTH              = 44.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{include/c-browse.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br-table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _START_FREEFORM
OPEN QUERY br-table FOR EACH tt_mod_ems NO-LOCK
    BY tt_mod_ems.tta_cod_modul_dtsul.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
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

    if avail tt_mod_ems and valid-handle(h-brw-prog) then
        run pi-posiciona-browse in h-brw-prog (tt_mod_ems.ttv_num_produto,
                                               tt_mod_ems.tta_cod_modul_dtsul).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

{utp/ut-liter.i Produto * R} 
assign c-des-produto:label in browse {&BROWSE-NAME} = return-value.

{utp/ut-liter.i M¢dulo  * R} 
assign tt_mod_ems.tta_cod_modul_dtsul:label in browse {&BROWSE-NAME} = return-value.
  
{utp/ut-liter.i Descri‡Æo * R}
assign tt_mod_ems.tta_des_modul_dtsul:label in browse {&BROWSE-NAME} = return-value.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-tt B-table-Win 
PROCEDURE pi-inicializa-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each tt_mod_proc_prog_ems: 
        delete tt_mod_proc_prog_ems.
    end.
    for each tt_mod_ems: 
        delete tt_mod_ems.
    end.
    /* ****** Verifica se existe integra‡Æo EMS 5 ****** */
    if can-find(first funcao where funcao.cd-funcao = "adm-cmg-ems-5.00":U and funcao.ativo)  
    or can-find(first funcao where funcao.cd-funcao = "adm-apb-ems-5.00":U and funcao.ativo)
    or can-find(first funcao where funcao.cd-funcao = "adm-acr-ems-5.00":U and funcao.ativo) then do:
    
        /* Verifica Modulos/Programas do EMS5 */
        if  connected("emsbas":U) and connected("emsfin":U) and connected("emsuni":U) then do:
            if search("prgint/mge/mge703zb.r":U) <> ? 
            or search("prgint/mge/mge703zb.py":U) <> ? then do:
    
                for each mod-proc-ge no-lock
                &IF "{&mgadm_version}" >= "2.04A" &THEN
                    where mod-proc-ge.ind-produto = 2 /* EMS5 */:
                &ELSE 
                    where mod-proc-ge.int-1 = 2 /* EMS5 */:
                &ENDIF
            
                    if not can-find(first tt_mod_ems no-lock
                        where tt_mod_ems.ttv_num_produto     = 2 /* EMS5 */
                        and   tt_mod_ems.tta_cod_modul_dtsul = mod-proc-ge.cod_modul_dtsul) then do:
            
                        create tt_mod_ems.
                        assign tt_mod_ems.ttv_num_produto     = 2 /* EMS5 */
                               tt_mod_ems.tta_cod_modul_dtsul = mod-proc-ge.cod_modul_dtsul 
                               tt_mod_ems.tta_des_modul_dtsul = "".
                    end.
                    create tt_mod_proc_prog_ems.
                    assign tt_mod_proc_prog_ems.ttv_num_produto          = 2 /* EMS 5 */
                           tt_mod_proc_prog_ems.tta_cod_modul_dtsul      = mod-proc-ge.cod_modul_dtsul
                           tt_mod_proc_prog_ems.tta_cod_prog_dtsul       = mod-proc-ge.cod_proced 
                           tt_mod_proc_prog_ems.tta_des_modul_dtsul      = ""
                           tt_mod_proc_prog_ems.tta_cod_proced           = ""
                           tt_mod_proc_prog_ems.tta_des_proced           = ""
                           tt_mod_proc_prog_ems.tta_nom_proced_menu      = ""
                           tt_mod_proc_prog_ems.tta_cod_prog_dtsul_base  = ""
                           tt_mod_proc_prog_ems.tta_des_prog_dtsul       = ""
                           tt_mod_proc_prog_ems.tta_nom_prog_dtsul_menu  = ""
                           tt_mod_proc_prog_ems.tta_nom_prog_ext         = ""
                           tt_mod_proc_prog_ems.ttv_log_selec            = yes
                           tt_mod_proc_prog_ems.ttv_log_selec_2          = yes.
                end.
                run prgint/mge/mge703zb.py (input-output table tt_mod_ems,
                                            input-output table tt_mod_proc_prog_ems) no-error.
            end.
        end.
    END.

    /* Verifica Modulo/Programas do EMS2 */    
    for each mod-proc-ge no-lock 
      &IF "{&mgadm_version}" >= "2.04A" &THEN
        where mod-proc-ge.ind-produto = 1 /* EMS2 */:
      &ELSE
        where mod-proc-ge.int-1 <= 1 /* EMS2 */:
      &ENDIF

        if not can-find(first tt_mod_ems no-lock
            where tt_mod_ems.ttv_num_produto     = 1 /* EMS2 */
            and   tt_mod_ems.tta_cod_modul_dtsul = mod-proc-ge.cod_modul_dtsul) then do:

            find modul_dtsul no-lock
                where modul_dtsul.cod_modul_dtsul = mod-proc-ge.cod_modul_dtsul no-error.

            if avail modul_dtsul then do:
                &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
                      Run utp/ut-ltmnu.p (input Replace(modul_dtsul.des_modul_dtsul," ","_"),"*",2,1).
                &ENDIF
                create tt_mod_ems.
                assign tt_mod_ems.ttv_num_produto     = 1 /* EMS2 */
                       tt_mod_ems.tta_cod_modul_dtsul = modul_dtsul.cod_modul_dtsul 
                       tt_mod_ems.tta_des_modul_dtsul = &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN Return-value &else modul_dtsul.des_modul_dtsul &endif.
            end.
        end.

        find prog_dtsul no-lock
            where prog_dtsul.cod_prog_dtsul = mod-proc-ge.cod_proced no-error.
        
        if avail prog_dtsul then do:
            &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
                  Run utp/ut-liter.p (input Replace(prog_dtsul.des_prog_dtsul," ","_"),"*","").
            &ENDIF
            create tt_mod_proc_prog_ems.
            assign tt_mod_proc_prog_ems.ttv_num_produto          = 1 /* EMS 2 */
                   tt_mod_proc_prog_ems.tta_cod_modul_dtsul      = mod-proc-ge.cod_modul_dtsul
                   tt_mod_proc_prog_ems.tta_cod_prog_dtsul       = mod-proc-ge.cod_proced 
                   tt_mod_proc_prog_ems.tta_des_modul_dtsul      = modul_dtsul.des_modul_dtsul
                   tt_mod_proc_prog_ems.tta_cod_proced           = ""
                   tt_mod_proc_prog_ems.tta_des_proced           = ""
                   tt_mod_proc_prog_ems.tta_nom_proced_menu      = ""
                   tt_mod_proc_prog_ems.tta_cod_prog_dtsul_base  = ""
                   tt_mod_proc_prog_ems.tta_des_prog_dtsul       = &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN Return-value &else prog_dtsul.des_prog_dtsul &endif 
                   tt_mod_proc_prog_ems.tta_nom_prog_dtsul_menu  = prog_dtsul.nom_prog_dtsul_menu
                   tt_mod_proc_prog_ems.tta_nom_prog_ext         = prog_dtsul.nom_prog_ext
                   tt_mod_proc_prog_ems.ttv_log_selec            = yes
                   tt_mod_proc_prog_ems.ttv_log_selec_2          = yes.
        end.
    end.    
   
    /* Atualiza Browse Programas */
    run get-link-handle in adm-broker-hdl (this-procedure,
                                           "modulo":U,
                                           output c-handle).

    assign h-brw-prog = widget-handle(c-handle).
    run pi-atualiza-browse in h-brw-prog (table tt_mod_proc_prog_ems).

    {&OPEN-QUERY-{&BROWSE-NAME}}

    apply "VALUE-CHANGED":U to {&BROWSE-NAME} in frame {&FRAME-NAME}.

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-retorna-des-produto B-table-Win 
FUNCTION fn-retorna-des-produto RETURNS CHARACTER
  (input i-num-produto as int) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN {adinc/i01ad279.i 04 i-num-produto}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

