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
{include/i-prgvrs.i B02AD279 2.00.00.008} /*** "010008" 10/06/2025 10:18:57  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i B02AD279 MUT}
&ENDIF


{include/i_fnctrad.i}
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
def var v-num-produto     as int  no-undo.
def var v-cod-modul-dtsul as char no-undo.
def var c-prog            as char format "x(10)" no-undo.
def var l-modifica        as log  no-undo.
Def Var c-modulos         As Char No-undo.

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
    field ttv_log_selec                    as logical format "*/" 
    field ttv_log_selec_2                  as logical 
    index tt_mod_id                        is primary unique
          ttv_num_produto                  ascending
          tta_cod_modul_dtsul              ascending
          tta_cod_proced                   ascending
          tta_cod_prog_dtsul               ascending
    index tt_prog_desc                    
          tta_des_prog_dtsul               ascending.

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
&Scoped-define INTERNAL-TABLES tt_mod_proc_prog_ems

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table tt_mod_proc_prog_ems.tta_des_prog_dtsul tt_mod_proc_prog_ems.tta_cod_prog_dtsul @ c-prog tt_mod_proc_prog_ems.ttv_log_selec   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define SELF-NAME br-table
&Scoped-define OPEN-QUERY-br-table OPEN QUERY {&SELF-NAME} FOR EACH tt_mod_proc_prog_ems     where tt_mod_proc_prog_ems.ttv_num_produto     = v-num-produto     and   tt_mod_proc_prog_ems.tta_cod_modul_dtsul = v-cod-modul-dtsul     and   tt_mod_proc_prog_ems.tta_des_prog_dtsul >= v-des-prog-ini     and   tt_mod_proc_prog_ems.tta_des_prog_dtsul <= v-des-prog-fim     by tt_mod_proc_prog_ems.tta_des_prog_dtsul.
&Scoped-define TABLES-IN-QUERY-br-table tt_mod_proc_prog_ems
&Scoped-define FIRST-TABLE-IN-QUERY-br-table tt_mod_proc_prog_ems


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-table v-des-prog-ini v-des-prog-fim ~
bt-entra IMAGE-29 IMAGE-30 RECT-1 
&Scoped-Define DISPLAYED-OBJECTS v-des-prog-ini v-des-prog-fim 

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
DEFINE BUTTON bt-entra 
     IMAGE-UP FILE "image~\im-enter":U
     IMAGE-INSENSITIVE FILE "image~\ii-enter":U
     LABEL "bt-inicial" 
     SIZE 4.43 BY .92.

DEFINE VARIABLE v-des-prog-fim AS CHARACTER FORMAT "X(15)":U INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE v-des-prog-ini AS CHARACTER FORMAT "X(15)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-29
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43 BY 1.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      tt_mod_proc_prog_ems SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table B-table-Win _FREEFORM
  QUERY br-table NO-LOCK DISPLAY
      tt_mod_proc_prog_ems.tta_des_prog_dtsul
    tt_mod_proc_prog_ems.tta_cod_prog_dtsul @ c-prog
    tt_mod_proc_prog_ems.ttv_log_selec
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 43 BY 11.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br-table AT ROW 1 COL 1
     v-des-prog-ini AT ROW 12.25 COL 9 COLON-ALIGNED
     v-des-prog-fim AT ROW 12.25 COL 26 COLON-ALIGNED NO-LABEL
     bt-entra AT ROW 12.25 COL 39
     IMAGE-29 AT ROW 12.25 COL 21
     IMAGE-30 AT ROW 12.25 COL 25
     RECT-1 AT ROW 12.08 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
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
         HEIGHT             = 12.33
         WIDTH              = 43.
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
OPEN QUERY {&SELF-NAME} FOR EACH tt_mod_proc_prog_ems
    where tt_mod_proc_prog_ems.ttv_num_produto     = v-num-produto
    and   tt_mod_proc_prog_ems.tta_cod_modul_dtsul = v-cod-modul-dtsul
    and   tt_mod_proc_prog_ems.tta_des_prog_dtsul >= v-des-prog-ini
    and   tt_mod_proc_prog_ems.tta_des_prog_dtsul <= v-des-prog-fim
    by tt_mod_proc_prog_ems.tta_des_prog_dtsul.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = "USED, FIRST USED"
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
  if avail tt_mod_proc_prog_ems and l-modifica then do:
    assign tt_mod_proc_prog_ems.ttv_log_selec = not tt_mod_proc_prog_ems.ttv_log_selec.
    display tt_mod_proc_prog_ems.ttv_log_selec with browse {&BROWSE-NAME}.
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
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
  run new-state('New-Line|':U + string(rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}))).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-entra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-entra B-table-Win
ON CHOOSE OF bt-entra IN FRAME F-Main /* bt-inicial */
DO:
  assign input frame {&FRAME-NAME} v-des-prog-ini
         input frame {&FRAME-NAME} v-des-prog-fim.
  
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

{utp/ut-liter.i Programa * R}
assign c-prog:label = trim(return-value).

{utp/ut-liter.i Descri‡Æo * R}
assign tt_mod_proc_prog_ems.tta_des_prog_dtsul:label = trim(return-value)
       v-des-prog-ini:label = trim(return-value).

{utp/ut-liter.i OK * R}
assign tt_mod_proc_prog_ems.ttv_log_selec:label = trim(return-value).


&IF int(entry(1,proversion,".")) >= 9 &THEN
    ASSIGN  br-table:COLUMN-RESIZABLE IN FRAME F-Main = TRUE.
&endif

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-browse B-table-Win 
PROCEDURE pi-atualiza-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param table for tt_mod_proc_prog_ems.
    
    &IF "{&mgadm_version}" < "2.04A" &THEN
    FOR EACH mod-proc-ge EXCLUSIVE-LOCK
        WHERE mod-proc-ge.int-1 = 0:
        
        /* Acerto de Campo - Integra»’o Gerencial x Financeiro EMS5 */
        ASSIGN mod-proc-ge.int-1 = 1. 
    END.
    &ENDIF
    
    for each mod-proc-ge no-lock:
        
        find first tt_mod_proc_prog_ems no-lock
           where tt_mod_proc_prog_ems.ttv_num_produto     = &IF "{&mgadm_version}" >= "2.04A" &THEN
                                                                mod-proc-ge.ind-produto
                                                            &ELSE
                                                                mod-proc-ge.int-1
                                                            &ENDIF
           and   tt_mod_proc_prog_ems.tta_cod_modul_dtsul = mod-proc-ge.cod_modul_dtsul
           and   tt_mod_proc_prog_ems.tta_cod_prog_dtsul  = mod-proc-ge.cod_proced no-error.

        /* ***** ttv_log_selec   -> Alteracoes do usuario        *****
           ***** ttv_log_selec_2 -> indica se existe mod-proc-ge ***** */      
        if avail tt_mod_proc_prog_ems then  Do: 
            &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEn
                  Run utp/ut-liter.p (input Replace(tt_mod_proc_prog_ems.tta_des_prog_dtsul," ","_"),"*","").
                  Assign tt_mod_proc_prog_ems.tta_des_prog_dtsul = Return-value.
            &ENDIF
            assign tt_mod_proc_prog_ems.ttv_log_selec   = yes
                   tt_mod_proc_prog_ems.ttv_log_selec_2 = yes.

        End.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cancela-alteracoes B-table-Win 
PROCEDURE pi-cancela-alteracoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    SESSION:SET-WAIT-STATE("GENERAL":U).

    /* Desfaz modificacoes do usuario na variavel de controle */     
    for each tt_mod_proc_prog_ems:
       assign tt_mod_proc_prog_ems.ttv_log_selec = tt_mod_proc_prog_ems.ttv_log_selec_2.
    end.   
    
    SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos B-table-Win 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-log-habilita as log no-undo.

    /* Variavel utilizada para verificar se interacao com o Browse */    
    assign l-modifica = p-log-habilita.

/*    if l-modifica then
 *         enable all with frame {&FRAME-NAME}.
 *     else do:
 *      assign v-des-prog-ini:screen-value in frame {&FRAME-NAME} = "":U
 *             v-des-prog-fim:screen-value in frame {&FRAME-NAME} = "ZZZZZZZZZZZZZZZ":U.*/

        apply "CHOOSE":U to bt-entra in frame {&FRAME-NAME}.               
/*        disable all except {&BROWSE-NAME} with frame {&FRAME-NAME}.
 *     end.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posiciona-browse B-table-Win 
PROCEDURE pi-posiciona-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-num-produto     as int  no-undo.
    def input param p-cod-modul-dtsul as char no-undo.   

    assign v-num-produto     = p-num-produto
           v-cod-modul-dtsul = p-cod-modul-dtsul.

    &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
         If Index(c-modulos,v-cod-modul-dtsul) = 0 Then Do:
             Assign c-modulos = c-modulos + "," + v-cod-modul-dtsul.
             FOR EACH tt_mod_proc_prog_ems     where tt_mod_proc_prog_ems.ttv_num_produto     = v-num-produto     and   tt_mod_proc_prog_ems.tta_cod_modul_dtsul = v-cod-modul-dtsul:
                  Run utp/ut-liter.p (input Replace(tt_mod_proc_prog_ems.tta_des_prog_dtsul," ","_"),"*","").
                  Assign tt_mod_proc_prog_ems.tta_des_prog_dtsul = Return-value.
             End.
         End.
    &ENDIF
    
    {&OPEN-QUERY-{&BROWSE-NAME}}
                                                   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-programa B-table-Win 
PROCEDURE pi-retorna-programa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-num-produto    as int  no-undo.
    def output param p-cod-prog-dtsul as char no-undo.
    
    if avail tt_mod_proc_prog_ems then 
        assign p-num-produto    = tt_mod_proc_prog_ems.ttv_num_produto
               p-cod-prog-dtsul = tt_mod_proc_prog_ems.tta_cod_prog_dtsul.
    else
        assign p-num-produto    = 0
               p-cod-prog-dtsul = "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-alteracoes B-table-Win 
PROCEDURE pi-salva-alteracoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var h-acomp as handle no-undo.

    /* Cria Acompanhamento de Gravacao */ 
    run utp/ut-acomp.p persistent set h-acomp.

    {utp/ut-liter.i Atualiza‡Æo *}
    run pi-inicializar in h-acomp (Return-value).
    {utp/ut-liter.i Gravando_Programas_selecionados... *}
    run pi-acompanhar in h-acomp  (Return-value).
    run pi-desabilita-cancela in h-acomp.

    do transaction:
        for each tt_mod_proc_prog_ems:
           /* Acompanhamento para o usuario */ 
           run pi-acompanhar in h-acomp (tt_mod_proc_prog_ems.tta_cod_modul_dtsul).
           
           /* Verifica se jÿ existe */
           find mod-proc-ge exclusive-lock
               where mod-proc-ge.cod_modul_dtsul  = tt_mod_proc_prog_ems.tta_cod_modul_dtsul
               and   mod-proc-ge.cod_proced = tt_mod_proc_prog_ems.tta_cod_prog_dtsul 
               &IF "{&mgadm_version}" >= "2.04A" &THEN
               and   mod-proc-ge.ind-produto = tt_mod_proc_prog_ems.ttv_num_produto no-error.
               &ELSE
               and   mod-proc-ge.int-1      = tt_mod_proc_prog_ems.ttv_num_produto no-error.
               &ENDIF
            
           /* Cria se nao existir e estiver selecionado */ 
           if not avail mod-proc-ge and tt_mod_proc_prog_ems.ttv_log_selec then do:
              create mod-proc-ge.
              assign mod-proc-ge.int-1      = tt_mod_proc_prog_ems.ttv_num_produto
                     mod-proc-ge.cod_modul_dtsul  = tt_mod_proc_prog_ems.tta_cod_modul_dtsul
                     mod-proc-ge.cod_proced = tt_mod_proc_prog_ems.tta_cod_prog_dtsul.
           end.
           
           /* Elimina se existir e nao estiver mais selecionado */
           if avail mod-proc-ge and tt_mod_proc_prog_ems.ttv_log_selec = no then
               delete mod-proc-ge.
           
           /* Atualiza modificacoes do usuario na variavel de controle */ 
           assign tt_mod_proc_prog_ems.ttv_log_selec_2 = tt_mod_proc_prog_ems.ttv_log_selec.
        end.   
    end.
    run pi-finalizar in h-acomp.
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

