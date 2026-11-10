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
{include/i-prgvrs.i B01AD279 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i B01AD279 MUT}
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
def var c-des-produto as char   no-undo.
def var c-handle      as char   no-undo.
def var h-brw-prog    as handle no-undo.

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

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table tt_mod_ems.tta_cod_modul_dtsul tt_mod_ems.tta_des_modul_dtsul fn-retorna-des-produto(tt_mod_ems.ttv_num_produto) @ c-des-produto   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define SELF-NAME br-table
&Scoped-define OPEN-QUERY-br-table OPEN QUERY {&SELF-NAME}      FOR  EACH tt_mod_ems NO-LOCK         where (tt_mod_ems.ttv_num_produto = 1 and tg-ems2         or     tt_mod_ems.ttv_num_produto = 2 and tg-ems5)         and    tt_mod_ems.tta_cod_modul_dtsul >= v-cod-modulo         BY tt_mod_ems.tta_cod_modul_dtsul.
&Scoped-define TABLES-IN-QUERY-br-table tt_mod_ems
&Scoped-define FIRST-TABLE-IN-QUERY-br-table tt_mod_ems


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-table tg-ems2 tg-ems5 v-cod-modulo ~
bt-entra RECT-1 
&Scoped-Define DISPLAYED-OBJECTS tg-ems2 tg-ems5 v-cod-modulo 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-retorna-des-produto B-table-Win 
FUNCTION fn-retorna-des-produto RETURNS CHARACTER
  (input i-num-produto as int)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-entra 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "bt-inicial" 
     SIZE 4.43 BY .92.

DEFINE VARIABLE v-cod-modulo AS CHARACTER FORMAT "X(3)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44 BY 1.25.

DEFINE VARIABLE tg-ems2 AS LOGICAL INITIAL no 
     LABEL "EMS 2" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ems5 AS LOGICAL INITIAL no 
     LABEL "EMS 5" 
     VIEW-AS TOGGLE-BOX
     SIZE 10 BY .83 NO-UNDO.

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
    fn-retorna-des-produto(tt_mod_ems.ttv_num_produto)  @ c-des-produto
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN NO-COLUMN-SCROLLING SEPARATORS SIZE 44 BY 11.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br-table AT ROW 1 COL 44 RIGHT-ALIGNED
     tg-ems2 AT ROW 12.25 COL 3
     tg-ems5 AT ROW 12.25 COL 15
     v-cod-modulo AT ROW 12.25 COL 31 COLON-ALIGNED
     bt-entra AT ROW 12.25 COL 39
     RECT-1 AT ROW 12.08 COL 1
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
         HEIGHT             = 12.33
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

/* SETTINGS FOR BROWSE br-table IN FRAME F-Main
   ALIGN-R                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME}
     FOR  EACH tt_mod_ems NO-LOCK
        where (tt_mod_ems.ttv_num_produto = 1 and tg-ems2
        or     tt_mod_ems.ttv_num_produto = 2 and tg-ems5)
        and    tt_mod_ems.tta_cod_modul_dtsul >= v-cod-modulo
        BY tt_mod_ems.tta_cod_modul_dtsul.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = "USED,"
     _OrdList          = "mguni.prog_dtsul.cod_prog_dtsul|yes"
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
    RUN NEW-STATE(INPUT 'incluir-browse':U).
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

  if avail tt_mod_ems then
        run pi-posiciona-browse in h-brw-prog (tt_mod_ems.ttv_num_produto,
                                               tt_mod_ems.tta_cod_modul_dtsul).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-entra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-entra B-table-Win
ON CHOOSE OF bt-entra IN FRAME F-Main /* bt-inicial */
DO:
   assign input frame {&FRAME-NAME} tg-ems2
          input frame {&FRAME-NAME} tg-ems5
          input frame {&FRAME-NAME} v-cod-modulo.

   {&OPEN-QUERY-{&BROWSE-NAME}}

   if avail tt_mod_ems then
       apply "VALUE-CHANGED":U to {&BROWSE-NAME} in frame {&FRAME-NAME}.
   else    
       run pi-posiciona-browse in h-brw-prog (0, "").
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
assign c-des-produto:label in browse {&BROWSE-NAME} = TRIM(return-value).

{utp/ut-liter.i M¢dulo  * R} 
assign tt_mod_ems.tta_cod_modul_dtsul:label in browse {&BROWSE-NAME} = TRIM(return-value)
       v-cod-modulo:label in frame {&FRAME-NAME} = TRIM(return-value).

{utp/ut-liter.i EMS_2 * R}
assign tg-ems2:label in frame {&FRAME-NAME} = TRIM(return-value).

{utp/ut-liter.i EMS_5 * R}
assign tg-ems5:label in frame {&FRAME-NAME} = TRIM(return-value).

{utp/ut-liter.i Descri‡Æo * R}
assign tt_mod_ems.tta_des_modul_dtsul:label in browse {&BROWSE-NAME} = TRIM(return-value).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos B-table-Win 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-habilit as log no-undo.

/*    if p-habilit then 
 *         enable all with frame {&FRAME-NAME}.
 *     else do:
 *      assign v-cod-mod-ini:screen-value in frame {&FRAME-NAME} = ""
 *             v-cod-mod-fim:screen-value in frame {&FRAME-NAME} = "ZZZ":U.
 *      apply "CHOOSE" to bt-entra in frame {&FRAME-NAME}.
 *        disable all except {&BROWSE-NAME} with frame {&FRAME-NAME}.
 *     end. */   
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
    DEF INPUT PARAM p-log-ems2        AS LOG NO-UNDO.
    DEF INPUT PARAM p-log-ems5        AS LOG NO-UNDO.

    &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
        Def Var vDesModul As Char No-undo.
        Def Var vDesProc  As Char No-undo.
        Def Var vNomProc  As Char No-undo.
    &endif

    def var h-acomp as handle no-undo.
    def var l-prog  as log    no-undo.    

    for each tt_mod_proc_prog_ems: 
        delete tt_mod_proc_prog_ems.
    end.
    for each tt_mod_ems: 
        delete tt_mod_ems.
    end.

    /* Cria Acompanhamento de Inicilizacao */ 
    run utp/ut-acomp.p persistent set h-acomp.
    {utp/ut-liter.i Verificando_M¢dulos *}
    run pi-inicializar in h-acomp (Return-value).

    IF p-log-ems5 THEN DO:
        /* ****** Verifica se existe integra‡Æo EMS 5 ****** */
        IF (can-find(first funcao where funcao.cd-funcao = "adm-cmg-ems-5.00":U and funcao.ativo)  
        OR  can-find(first funcao where funcao.cd-funcao = "adm-apb-ems-5.00":U and funcao.ativo)
        OR  can-find(first funcao where funcao.cd-funcao = "adm-acr-ems-5.00":U and funcao.ativo))
        AND CONNECTED("EMSBAS":U) AND CONNECTED("EMSFIN":U) AND CONNECTED("EMSUNI":U) THEN DO:
            {utp/ut-liter.i Verificando_M¢dulos_-_EMS5 *}
            run pi-inicializar in h-acomp (Return-value).
            run pi-desabilita-cancela in h-acomp.

            IF SEARCH("prgint/mge/mge703za.r":U) <> ? OR SEARCH("prgint/mge/mge703za.py":U) <> ? THEN DO:
                RUN prgint/mge/mge703za.py (h-acomp,
                                            output table tt_mod_ems,
                                            output table tt_mod_proc_prog_ems) no-error.
            END.
        END.
    END.

    IF p-log-ems2 THEN DO:
        {utp/ut-liter.i Verificando_M¢dulos_-_EMS2 *}
        run pi-inicializar in h-acomp (Return-value).
        run pi-desabilita-cancela in h-acomp.

        bl_mod:
        for each modul_dtsul no-lock:

            /* Acompanhamento */   
            {utp/ut-liter.i M¢dulo:_ *} 
            run pi-acompanhar in h-acomp (Return-value + modul_dtsul.cod_modul_dtsul).

            &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
                 Run utp/ut-ltmnu.p (input Replace(modul_dtsul.des_modul_dtsul," ","_"),"*",2,1).
                 Assign vDesModul = Return-value.
            &ENDIF
            create tt_mod_ems.
            assign tt_mod_ems.ttv_num_produto     = 1 /* 1-EMS2, 2-EMS5 */
                   tt_mod_ems.tta_cod_modul_dtsul = modul_dtsul.cod_modul_dtsul
                   tt_mod_ems.tta_des_modul_dtsul = &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then vDesModul &else modul_dtsul.des_modul_dtsul &endif.

            assign l-prog = no.
            bl_proc:
            for each procedimento no-lock
                where procedimento.cod_modul_dtsul   = modul_dtsul.cod_modul_dtsul:

                /*&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
                    Run utp/ut-ltmnu.p (input Replace(procedimento.des_proced," ","_"),"*",3,1).
                    Assign vDesProc = Return-value.
                    Run utp/ut-ltmnu.p (input Replace(procedimento.des_proced," ","_"),"*",3,2).
                    Assign vNomProc = Return-value.
                &endif */


                bl_prog:
                for each prog_dtsul no-lock
                    where prog_dtsul.cod_proced        = procedimento.cod_proced
                    and   prog_dtsul.log_visualiz_menu = yes:

                    create tt_mod_proc_prog_ems.
                    assign tt_mod_proc_prog_ems.ttv_num_produto         = 1 /* 1-EMS2, 2-EMS5 */
                           tt_mod_proc_prog_ems.tta_cod_modul_dtsul     = modul_dtsul.cod_modul_dtsul
                           tt_mod_proc_prog_ems.tta_cod_proced          = procedimento.cod_proced
                           tt_mod_proc_prog_ems.tta_cod_prog_dtsul      = prog_dtsul.cod_prog_dtsul.

                   Assign  tt_mod_proc_prog_ems.tta_des_modul_dtsul     = &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN vDesModul &else modul_dtsul.des_modul_dtsul &endif .
                   Assign  tt_mod_proc_prog_ems.tta_des_proced          = /*&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN vDesProc &else */ procedimento.des_proced /*&endif*/ .
                   Assign  tt_mod_proc_prog_ems.tta_nom_proced_menu     = /*&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN vNomProc &else*/ procedimento.nom_proced_menu /*&endif*/ .
                           tt_mod_proc_prog_ems.tta_cod_prog_dtsul_base = procedimento.cod_prog_dtsul_base.

                   /*&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
                        Run utp/ut-liter.p (input Replace(prog_dtsul.des_prog_dtsul," ","_"),"*","").
                   &ENDIF*/
                   Assign  tt_mod_proc_prog_ems.tta_des_prog_dtsul      =  /*&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN Return-value &else*/ prog_dtsul.des_prog_dtsul /*&endif*/ .
                   /*&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
                        Run utp/ut-liter.p (input Replace(prog_dtsul.nom_prog_dtsul_menu," ","_"),"*","").
                   &ENDIF*/
                   Assign  tt_mod_proc_prog_ems.tta_nom_prog_dtsul_menu = /*&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN Return-value &else*/ prog_dtsul.nom_prog_dtsul_menu /*&endif*/
                           tt_mod_proc_prog_ems.tta_nom_prog_ext        = prog_dtsul.nom_prog_ext
                           tt_mod_proc_prog_ems.ttv_log_selec           = no
                           tt_mod_proc_prog_ems.ttv_log_selec_2         = no
                           l-prog                                       = yes.
                end /* for bl_prog */.
            end /* for bl_proc */.
            if not l-prog then delete tt_mod_ems.
        end /* for bl_mod */.
    END.

    {utp/ut-liter.i Atualizando... *}
    run pi-acompanhar in h-acomp (Return-value).

    /* Atualiza Browse Programas */
    run get-link-handle in adm-broker-hdl (this-procedure,
                                           "modulo":U,
                                           output c-handle).

    assign h-brw-prog = widget-handle(c-handle).
    run pi-atualiza-browse in h-brw-prog (table tt_mod_proc_prog_ems).

    ASSIGN tg-ems2                                  = p-log-ems2
           tg-ems5                                  = p-log-ems5
           tg-ems2:CHECKED   IN FRAME {&FRAME-NAME} = p-log-ems2
           tg-ems5:CHECKED   IN FRAME {&FRAME-NAME} = p-log-ems5.

    IF tg-ems2 <> tg-ems5 THEN
        ASSIGN tg-ems2:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               tg-ems5:SENSITIVE IN FRAME {&FRAME-NAME} = NO. 

    {&OPEN-QUERY-{&BROWSE-NAME}}

    apply "VALUE-CHANGED":U to {&BROWSE-NAME} in frame {&FRAME-NAME}.
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

