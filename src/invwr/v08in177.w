&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V08IN177 2.00.00.005 } /*** 010005 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v08in177 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

{include/i-vrtab.i item-estab}
{include/i-vrtab.i item}
{include/i-vrtab.i tab-unidade}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*
def new shared var c-it-descricao   as character form "x(36)".
def new shared var c-it-codigo      like item-estab.it-codigo.
def new shared var c-fm-codigo      like item.fm-codigo.
def new shared var c-it-un          like item.un.
def new shared var i-ge-codigo      like item.ge-codigo.  */

    def var h_api_cta             as handle no-undo.
    def var h_api_ccust           as handle no-undo.
    DEF VAR v_cod_cta_ctbl        AS CHAR   NO-UNDO.
    DEF VAR c-sc-codigo           AS CHAR   NO-UNDO. 
    DEF VAR d-dta-consumo         AS DATE   NO-UNDO.
    def var p_cod_format_cta_ctbl as char   no-undo.
    DEF VAR p_cod_format_ccusto   AS CHAR   NO-UNDO.
    DEF VAR v_des_cta_ctbl        AS CHAR   NO-UNDO.
    DEF VAR v_num_tip_cta_ctbl    AS CHAR   NO-UNDO.
    DEF VAR v_num_sit_cta_ctbl    AS CHAR   NO-UNDO.
    DEF VAR v_ind_finalid_cta     AS CHAR   NO-UNDO.
    DEF VAR v_des_plano_ccusto    AS CHAR   NO-UNDO.
    def var de-total    as decimal format "->>>,>>>,>>9.9999" no-undo.
    def var c-it-codigo as char.


def var c-tit-graf       as char.
def var c-tit-x          as char.
def var c-tit-y          as char.
def var c-item           like item-estab.it-codigo.
def var r-registro       as rowid     no-undo.
def var da-data          as date.
def var de-total-consumo as decimal   format ">>>>,>>>,>>9.9999" init 0.
def var i-dia            as integer   format "99".
def var i-mes            as integer   format "99".
def var i-ano            as integer   format "9999". 
def var i-cont           as integer   format "99"     init 0.
def var i-mes-per        as integer   format "99"     init 1.
def var c-per-pesq       as character format "9999/99".
def var c-jan            as char      format "x(03)".
def var c-fev            as char      format "x(03)".
def var c-mar            as char      format "x(03)".
def var c-abr            as char      format "x(03)".
def var c-mai            as char      format "x(03)".
def var c-jun            as char      format "x(03)".
def var c-jul            as char      format "x(03)".
def var c-ago            as char      format "x(03)".
def var c-set            as char      format "x(03)".
def var c-out            as char      format "x(03)".
def var c-nov            as char      format "x(03)".
def var c-dez            as char      format "x(03)".

def var i-empresa like param-global.empresa-prin no-undo.
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

{utp/utapi001.i}

def var c-tab-meses      as character.
def var c-tabela         as character.

def temp-table tt-deposito no-undo
    field cod-depos like deposito.cod-depos
    index codigo cod-depos.

def temp-table tt_cta_integr no-undo
    field ttv_cod_cta_ctbl         as char format "x(20)" label "Conta Contˇbil"
    field ttv_des_titulo           as char format "x(40)"
    field ttv_num_tip_cta_ctbl     as int  format ">9" label "Tipo Conta" column-label "Tipo Conta"
    field ttv_num_sit_cta_ctbl     as int  format ">9" label "Situaªío Conta" column-label "Situaªío Cta"
    field ttv_ind_finalid_ctbl_cta as char format "X(40)" label "Finalidade Contˇbil".

def temp-table tt-consumo no-undo
    field cod-estabel-prin like estab-mat.cod-estabel-prin
    field periodo          like consumo-estab.periodo 
    field ct-codigo        like consumo-estab.ct-codigo
    FIELD sc-codigo        LIKE consumo-estab.sc-codigo
    field qt-entrada       like consumo-estab.qt-entrada 
    field qt-saida         like consumo-estab.qt-saida 
    field consumo-final    as decimal format "->>>>,>>>,>>9.9999" 
    field total            as decimal format "->>>>,>>>,>>9.9999" initial 0 
    field qtidade          as decimal decimals 2
    index codigo 
          cod-estabel-prin 
          periodo 
          ct-codigo
          sc-codigo.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Nﬂmero" column-label "Nﬂmero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¨ncia".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item item-estab
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item, item-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-estab.cod-estabel 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-estabel ~{&FP2}cod-estabel ~{&FP3}
&Scoped-define ENABLED-TABLES item-estab
&Scoped-define FIRST-ENABLED-TABLE item-estab
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS item-estab.cod-estabel item-estab.it-codigo ~
item.baixa-estoq item.un 
&Scoped-Define DISPLAYED-OBJECTS c-nome-estab c-desc-item c-desc-un ~
c-compr-fabric i-consumo-prev i-consumo-aad i-fator-refugo c-tipo-con-est ~
c-tipo-contr c-cod-obsoleto c-politica c-tipo-requis c-perm-saldo-neg 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS item-estab.it-codigo 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cod-obsoleto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Codigo Obsoleto" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-compr-fabric AS CHARACTER FORMAT "X(256)":U 
     LABEL "C/F" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 54.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-un AS CHARACTER FORMAT "x(15)" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 63.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-perm-saldo-neg AS CHARACTER FORMAT "X(256)":U 
     LABEL "Permite Saldo Negativo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-politica AS CHARACTER FORMAT "X(22)":U 
     LABEL "Pol°tica" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-con-est AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Controle Estoque" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-contr AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Controle" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-requis AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Requisiá∆o" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-consumo-aad AS DECIMAL FORMAT "->>>>,>>9.9999" INITIAL 0 
     LABEL "Consumo AtÇ Data":R22 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE i-consumo-prev AS DECIMAL FORMAT "->>>>,>>9.9999" INITIAL 0 
     LABEL "Consumo Previsto":R20 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE i-fator-refugo AS DECIMAL FORMAT ">9.99" INITIAL 0 
     LABEL "Fator Refugo":R15 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 2.38.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 11.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-estab.cod-estabel AT ROW 1.17 COL 13.14 COLON-ALIGNED
          LABEL "Estab":R18
          VIEW-AS FILL-IN 
          SIZE 8.14 BY .88
     c-nome-estab AT ROW 1.17 COL 21.57 COLON-ALIGNED NO-LABEL
     item-estab.it-codigo AT ROW 2.17 COL 13.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item AT ROW 2.17 COL 30.57 COLON-ALIGNED NO-LABEL
     item.baixa-estoq AT ROW 3.71 COL 51.43
          VIEW-AS TOGGLE-BOX
          SIZE 20.14 BY .88
     item.un AT ROW 3.75 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     c-desc-un AT ROW 3.75 COL 31.57 COLON-ALIGNED NO-LABEL
     c-compr-fabric AT ROW 4.75 COL 26 COLON-ALIGNED
     i-consumo-prev AT ROW 5.75 COL 26 COLON-ALIGNED
     i-consumo-aad AT ROW 6.75 COL 26 COLON-ALIGNED
     i-fator-refugo AT ROW 7.75 COL 26 COLON-ALIGNED
     c-tipo-con-est AT ROW 8.75 COL 26 COLON-ALIGNED
     c-tipo-contr AT ROW 9.75 COL 26 COLON-ALIGNED
     c-cod-obsoleto AT ROW 10.75 COL 26 COLON-ALIGNED
     c-politica AT ROW 11.75 COL 26 COLON-ALIGNED
     c-tipo-requis AT ROW 12.75 COL 26 COLON-ALIGNED
     c-perm-saldo-neg AT ROW 13.75 COL 26 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item,movind.item-estab
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 14
         WIDTH              = 88.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX item.baixa-estoq IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-obsoleto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-compr-fabric IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-perm-saldo-neg IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-politica IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-con-est IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-contr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-requis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-estab.cod-estabel IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN i-consumo-aad IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-consumo-prev IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-fator-refugo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-estab.it-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN item.un IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "item"}
  {src/adm/template/row-list.i "item-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}
  {src/adm/template/row-find.i "item-estab"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}

    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if avail item-estab then do with frame {&frame-name}:

     /*--- Testa se Ç EMS204 ---*/
     &if  defined(bf_mat_uni_estab) &then
          find item-uni-estab where
               item-uni-estab.it-codigo   = item-estab.it-codigo and
               item-uni-estab.cod-estabel = item-estab.cod-estabel no-lock no-error.
          if  avail item-uni-estab then do:     
              assign i-consumo-prev = item-uni-estab.consumo-prev /*-> atualizado ao rodar o ce0345 e ce0408 */
                     i-consumo-aad  = item-estab.consumo-aad  /* mostra consumo do item-estab pois hoje 
                                                                 nao tem nenhum programa atualizando 
                                                                 item-uni-estab.consumo-aad */
                     i-fator-refugo = item-uni-estab.fator-refugo.

              &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                  RUN utp/ut-liter.p (trim({ininc/i17in172.i 04 item.cod-obsoleto}), "*", "").
                  assign c-cod-obsoleto:screen-value   = return-value.
                  RUN utp/ut-liter.p (trim({ininc/i04in122.i 04 item.politica}), "*", "").
                  assign c-politica:screen-value       = return-value.
                  RUN utp/ut-liter.p (trim({ininc/i11in122.i 04 item.perm-saldo-neg}), "*", "").
                  assign c-perm-saldo-neg:screen-value = return-value.
              &else
                  assign c-cod-obsoleto:screen-value   = {ininc/i17in172.i 04 item.cod-obsoleto}
                         c-politica:screen-value       = {ininc/i04in122.i 04 item.politica}
                         c-perm-saldo-neg:screen-value = {ininc/i11in122.i 04 item.perm-saldo-neg}.
              &endif
              
          end.
          else do:
              assign i-consumo-prev = 0
                     i-consumo-aad  = 0
                     i-fator-refugo = 0.

              &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                  RUN utp/ut-liter.p (trim({ininc/i17in172.i 04 1}), "*", "").
                  assign c-cod-obsoleto:screen-value   = return-value.
                  RUN utp/ut-liter.p (trim({ininc/i04in122.i 04 1}), "*", "").
                  assign c-politica:screen-value       = return-value.
                  RUN utp/ut-liter.p (trim({ininc/i11in122.i 04 1}), "*", "").
                  assign c-perm-saldo-neg:screen-value = return-value.
              &else
                  assign c-cod-obsoleto:screen-value   = {ininc/i17in172.i 04 1}
                         c-politica:screen-value       = {ininc/i04in122.i 04 1}
                         c-perm-saldo-neg:screen-value = {ininc/i11in122.i 04 1}.
              &endif
              
          end.
     &else
          find item-mat-estab where
               item-mat-estab.it-codigo   = item-estab.it-codigo and
               item-mat-estab.cod-estabel = item-estab.cod-estabel no-lock no-error.
          if  avail item-mat-estab then do:
              assign i-consumo-prev = item-mat-estab.consumo-prev /*-> atualizado ao rodar o ce0345 e ce0408 */
                     i-consumo-aad  = item-estab.consumo-aad /* mostra consumo do item-estab pois hoje nao
                                                                tem nenhum programa atualizando 
                                                                item-mat-estab.consumo-aad */
                     i-fator-refugo = item-mat-estab.fator-refugo.

              &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                  RUN utp/ut-liter.p (trim({ininc/i17in172.i 04 item.cod-obsoleto}), "*", "").
                  assign c-cod-obsoleto:screen-value   = return-value.
                  RUN utp/ut-liter.p (trim({ininc/i04in122.i 04 item.politica}), "*", "").
                  assign c-politica:screen-value       = return-value.
                  RUN utp/ut-liter.p (trim({ininc/i11in122.i 04 item.perm-saldo-neg}), "*", "").
                  assign c-perm-saldo-neg:screen-value = return-value.
              &else
                  assign c-cod-obsoleto:screen-value   = {ininc/i17in172.i 04 item.cod-obsoleto}
                         c-politica:screen-value       = {ininc/i04in122.i 04 item.politica}
                         c-perm-saldo-neg:screen-value = {ininc/i11in122.i 04 item.perm-saldo-neg}.
              &endif
              
          end.
          else do:
              assign i-consumo-prev = item.consumo-prev
                     i-consumo-aad  = item.consumo-aad
                     i-fator-refugo = item.fator-refugo.

              &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                  RUN utp/ut-liter.p (trim({ininc/i17in172.i 04 item.cod-obsoleto}), "*", "").
                  assign c-cod-obsoleto:screen-value   = return-value.
                  RUN utp/ut-liter.p (trim({ininc/i04in122.i 04 item.politica}), "*", "").
                  assign c-politica:screen-value       = return-value.
                  RUN utp/ut-liter.p (trim({ininc/i11in122.i 04 item.perm-saldo-neg}), "*", "").
                  assign c-perm-saldo-neg:screen-value = return-value.
              &else
                  assign c-cod-obsoleto:screen-value   = {ininc/i17in172.i 04 item.cod-obsoleto}
                         c-politica:screen-value       = {ininc/i04in122.i 04 item.politica}
                         c-perm-saldo-neg:screen-value = {ininc/i11in122.i 04 item.perm-saldo-neg}.
              &endif
              
          end.
     &endif
     
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         RUN utp/ut-liter.p (trim({ininc/i01in122.i 04 item.tipo-con-est}), "*", "").
         assign c-tipo-con-est:screen-value   = return-value.
         RUN utp/ut-liter.p (trim({ininc/i09in122.i 04 item.tipo-contr}), "*", "").
         assign c-tipo-contr:screen-value     = return-value.  
         RUN utp/ut-liter.p (trim({ininc/i01in172.i 04 item.compr-fabric}), "*", "").
         assign c-compr-fabric:screen-value   = return-value.
         RUN utp/ut-liter.p (trim({ininc/i08in122.i 04 item.tipo-requis}), "*", "").
         assign c-tipo-requis:screen-value    = return-value.
     &else
         assign c-tipo-con-est:screen-value   = {ininc/i01in122.i 04 item.tipo-con-est}
                c-tipo-contr:screen-value     = {ininc/i09in122.i 04 item.tipo-contr}   
                c-compr-fabric:screen-value   = {ininc/i01in172.i 04 item.compr-fabric}
                c-tipo-requis:screen-value    = {ininc/i08in122.i 04 item.tipo-requis}.
     &endif
     
     assign c-desc-item = item.desc-item.

     for first estabelec
         where estabelec.cod-estabel = item-estab.cod-estabel no-lock:
         assign c-nome-estab = estabelec.nome.
     end.

     find tab-unidade where tab-unidade.un = item.un no-lock no-error.
     if avail tab-unidade then do:
        assign c-desc-un = tab-unidade.descricao.
     end.

     display c-nome-estab c-desc-item c-desc-un i-consumo-prev i-consumo-aad i-fator-refugo.                

  end.
  else do with frame {&frame-name}:  
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         RUN utp/ut-liter.p (trim({ininc/i04in122.i 04 1}), "*", "").
         assign c-politica:screen-value   = return-value.
         RUN utp/ut-liter.p (trim({ininc/i17in172.i 04 1}), "*", "").
         assign c-cod-obsoleto:screen-value     = return-value.  
         RUN utp/ut-liter.p (trim({ininc/i01in122.i 04 1}), "*", "").
         assign c-tipo-con-est:screen-value   = return-value.
         RUN utp/ut-liter.p (trim({ininc/i09in122.i 04 1}), "*", "").
         assign c-tipo-contr:screen-value    = return-value.
         RUN utp/ut-liter.p (trim({ininc/i01in172.i 04 1}), "*", "").
         assign c-compr-fabric:screen-value    = return-value.
         RUN utp/ut-liter.p (trim({ininc/i08in122.i 04 1}), "*", "").
         assign c-tipo-requis:screen-value    = return-value.
         RUN utp/ut-liter.p (trim({ininc/i11in122.i 04 1}), "*", "").
         assign c-perm-saldo-neg:screen-value    = return-value.
     &else
         assign c-politica:screen-value       = {ininc/i04in122.i 04 1}
                c-cod-obsoleto:screen-value   = {ininc/i17in172.i 04 1}
                c-tipo-con-est:screen-value   = {ininc/i01in122.i 04 1}
                c-tipo-contr:screen-value     = {ininc/i09in122.i 04 1}   
                c-compr-fabric:screen-value   = {ininc/i01in172.i 04 1} 
                c-tipo-requis:screen-value    = {ininc/i08in122.i 04 1}
                c-perm-saldo-neg:screen-value = {ininc/i11in122.i 04 1}.
     &endif 

  end.     

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.

    assign v-row-parent = v-row-parent-externo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico-ce0848 V-table-Win 
PROCEDURE pi-gera-grafico-ce0848 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run prgint/utb/utb743za.py persistent set h_api_cta.
    run prgint/utb/utb742za.py persistent set h_api_ccust.

    def input parameter c-per-ini as char format "9999/99".
    def input parameter i-classif-grafico as int no-undo.
    def var i-incrementa-label     as integer   init 0  no-undo.
    def var i-conta-meses          as integer           no-undo.
    def var i-conta-points         as integer   init 0  no-undo.
    def var c-label-ano            as char              no-undo.
    def var c-tit-graf-item        as char no-undo.
    def var c-tit-graf-est         as char no-undo.
    DEF VAR i-conta AS INT NO-UNDO.

    &SCOPED-DEFINE campos-consumo ct-codigo sc-codigo periodo qt-entrada qt-saida cod-estabel-prin

    if  not avail param-global then
        find first param-global no-lock no-error.

    if  i-classif-grafico = 1 then do:  
        {utp/ut-liter.i Evoluá∆o_do_Consumo_do_Item}
        assign c-tit-graf = return-value.
    end.
    else do:
        {utp/ut-liter.i Evoluá∆o_do_Consumo_do_Estab}
        assign c-tit-graf-est  = return-value.
        {utp/ut-liter.i Item}
        assign c-tit-graf-item = return-value.
    end.

    {utp/ut-liter.i Quantidade}
    assign c-tit-y = return-value.

    {utp/ut-liter.i Meses}
    assign c-tit-x = return-value.

    if int(substr(c-per-ini,5,2)) = 12 then
        assign c-label-ano = substr(c-per-ini,1,4).
    else 
        assign c-label-ano = string(int(substr(c-per-ini,1,4)) - 1) + "/" + substr(c-per-ini,1,4).

    create tt-atributos.
    assign
        tt-atributos.cod-versao-integracao = 003
        tt-atributos.numgraph              = 1
        tt-atributos.graphtype             = 4  
        tt-atributos.lefttitle             = c-tit-y
        tt-atributos.lefttitlestyle        = 0
        tt-atributos.bottomtitle           = c-tit-x + " " + c-label-ano
        tt-atributos.legendpos             = 0
        tt-atributos.gridstyle             = 0
        tt-atributos.gridlinestyle         = 0.

    if  i-classif-grafico = 1 then 
        assign tt-atributos.graphtitle = c-tit-graf + " " + item-estab.it-codigo.
    else
        assign tt-atributos.graphtitle = c-tit-graf-est  + " " + item-estab.cod-estabel + " " +
                                         c-tit-graf-item + " " + item-estab.it-codigo.


    create tt-sets.
    assign
        tt-sets.numgraph   = 1
        tt-sets.numset     = 1
        c-tabela           = {ininc/i01in061.i 03}
        i-ano              = int(substr(c-per-ini,1,4)) - 1
        i-mes              = int(substr(c-per-ini,5,2)) + 1
        da-data            = if i-mes > 12 
                                  then date(1,1,i-ano + 1)
                                  else date(i-mes,1,i-ano).
        i-incrementa-label = int(string(month(da-data),"99")).

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        RUN utp/ut-liter.p (trim(c-tabela), "*", "").
        assign c-tabela = return-value.
    &endif

    DO i-cont = i-conta-meses TO (11 + i-conta-meses):

        assign c-per-pesq       = string(year(da-data),"9999") + 
                                  string(month(da-data),"99")
               de-total-consumo = 0
               i-mes            = month(da-data).

        if  i-classif-grafico = 1 THEN /* por item */
            for each consumo-estab fields ({&campos-consumo}) no-lock
               where consumo-estab.periodo   = c-per-pesq 
                 and consumo-estab.it-codigo = input frame {&frame-name} item-estab.it-codigo: 
          
                 assign i-empresa = param-global.empresa-prin.
                 if  not avail estabelec
                 or  (avail estabelec and estabelec.cod-estabel <> consumo-estab.cod-estabel) then
                     find estabelec where
                          estabelec.cod-estabel = consumo-estab.cod-estabel no-lock no-error.
                 run cdp/cd9970.p (input rowid(estabelec),
                                   output i-empresa).
                
                 assign d-dta-consumo = DATE("01/" + substring(consumo-estab.periodo,5,2) + "/" + substring(consumo-estab.periodo,1,4)).
                                                                                                                                       
                 ASSIGN v_cod_cta_ctbl = consumo-estab.ct-codigo.                                                                     
                 run pi_busca_dados_cta_ctbl in h_api_cta (input        i-empresa,          /* EMPRESA EMS2 */                        
                                                           input        "",                 /* PLANO DE CONTAS */                     
                                                           input-output v_cod_cta_ctbl,     /* CONTA */                               
                                                           input        d-dta-consumo,      /* DATA TRANSACAO */                      
                                                           output       v_des_cta_ctbl,     /* DESCRICAO CONTA */                     
                                                           output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */                       
                                                           output       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */                   
                                                           output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */                
                                                           output table tt_log_erro).       /* ERROS */    
                                                                                                                                      
                /**  Ignora consumo se a conta n∆o for de consumo de acordo com parametro **/
                IF lookup({adinc/i05ad049.i 4 1}, v_ind_finalid_cta) = 0 AND
                   lookup({adinc/i05ad049.i 4 3}, v_ind_finalid_cta) = 0 AND 
                   lookup({adinc/i05ad049.i 4 6}, v_ind_finalid_cta) = 0 THEN
                    NEXT.
                
                FIND FIRST tt-consumo EXCLUSIVE-LOCK 
                     where tt-consumo.cod-estabel-prin = consumo-estab.cod-estabel-prin 
                       and tt-consumo.periodo          = consumo-estab.periodo          
                       and tt-consumo.ct-codigo        = consumo-estab.ct-codigo               
                       AND tt-consumo.sc-codigo        = consumo-estab.sc-codigo no-error.
                if not avail tt-consumo then do:
                       create tt-consumo.
                       assign tt-consumo.cod-estabel-prin = consumo-estab.cod-estabel-prin
                              tt-consumo.periodo          = consumo-estab.periodo
                              tt-consumo.ct-codigo        = consumo-estab.ct-codigo
                              tt-consumo.sc-codigo        = consumo-estab.sc-codigo.
                end.
                   
                assign tt-consumo.qt-entrada    = tt-consumo.qt-entrada + consumo-estab.qt-entrada
                       tt-consumo.qt-saida      = tt-consumo.qt-saida   + consumo-estab.qt-saida
                       tt-consumo.consumo-final = tt-consumo.qt-saida   - tt-consumo.qt-entrada. 
                
                assign de-total-consumo = de-total-consumo + (consumo-estab.qt-saida - consumo-estab.qt-entrada)
                       tt-consumo.total = de-total-consumo.

            end. /*for each*/
   
         ELSE /*por item x estabelecimento*/
            for each consumo-estab fields ({&campos-consumo}) no-lock
                where consumo-estab.periodo     = c-per-pesq
                  and consumo-estab.it-codigo   = input frame {&frame-name} item-estab.it-codigo
                  and consumo-estab.cod-estabel = input frame {&frame-name} item-estab.cod-estabel:

                assign i-empresa = param-global.empresa-prin.
                if  not avail estabelec
                or  (avail estabelec and estabelec.cod-estabel <> consumo-estab.cod-estabel) then
                    find estabelec where
                         estabelec.cod-estabel = consumo-estab.cod-estabel no-lock no-error.
                run cdp/cd9970.p (input rowid(estabelec),
                                  output i-empresa).

                assign d-dta-consumo = DATE("01/" + substring(consumo-estab.periodo,5,2) + "/" + substring(consumo-estab.periodo,1,4)).

                ASSIGN v_cod_cta_ctbl = consumo-estab.ct-codigo.                                                                     
                run pi_busca_dados_cta_ctbl in h_api_cta (input        i-empresa,          /* EMPRESA EMS2 */                        
                                                          input        "",                 /* PLANO DE CONTAS */                     
                                                          input-output v_cod_cta_ctbl,     /* CONTA */                               
                                                          input        d-dta-consumo,      /* DATA TRANSACAO */                      
                                                          output       v_des_cta_ctbl,     /* DESCRICAO CONTA */                     
                                                          output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */                       
                                                          output       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */                   
                                                          output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */                
                                                          output table tt_log_erro).       /* ERROS */    

               /**  Ignora consumo se a conta n∆o for de consumo de acordo com parametro **/
               IF lookup({adinc/i05ad049.i 4 1}, v_ind_finalid_cta) = 0 AND
                  lookup({adinc/i05ad049.i 4 3}, v_ind_finalid_cta) = 0 AND 
                  lookup({adinc/i05ad049.i 4 6}, v_ind_finalid_cta) = 0 THEN
                   NEXT.

               FIND FIRST tt-consumo EXCLUSIVE-LOCK 
                    where tt-consumo.cod-estabel-prin = consumo-estab.cod-estabel-prin 
                      and tt-consumo.periodo          = consumo-estab.periodo          
                      and tt-consumo.ct-codigo        = consumo-estab.ct-codigo               
                      AND tt-consumo.sc-codigo        = consumo-estab.sc-codigo  no-error.
               if not avail tt-consumo then do:
                      create tt-consumo.
                      assign tt-consumo.cod-estabel-prin = consumo-estab.cod-estabel-prin
                             tt-consumo.periodo          = consumo-estab.periodo
                             tt-consumo.ct-codigo        = consumo-estab.ct-codigo
                             tt-consumo.sc-codigo        = consumo-estab.sc-codigo.
               end.

               assign tt-consumo.qt-entrada    = tt-consumo.qt-entrada + consumo-estab.qt-entrada
                      tt-consumo.qt-saida      = tt-consumo.qt-saida   + consumo-estab.qt-saida
                      tt-consumo.consumo-final = tt-consumo.qt-saida   - tt-consumo.qt-entrada. 

               ASSIGN de-total-consumo = de-total-consumo + (consumo-estab.qt-saida - consumo-estab.qt-entrada)
                      tt-consumo.total = de-total-consumo.

            end. /* FOR */



        assign da-data = da-data + 31.

        assign i-conta-points = i-conta-points + 1.

        assign c-tab-meses  = entry(i-incrementa-label,c-tabela).

        create tt-points.
        assign
              tt-points.numgraph  = 1
              tt-points.numpoint  = i-conta-points
              tt-points.labeltext = c-tab-meses.

        create tt-dados.
        assign tt-dados.numgraph              = 1
               tt-dados.numpoint              = i-conta-points
               tt-dados.numset                = 1
               tt-dados.graphdata             = de-total-consumo.

        assign i-incrementa-label = i-incrementa-label + 1.      
        if i-incrementa-label >= 13 then   assign i-incrementa-label = 1.

    END. /* DO */

    run utp/utapi001.p(input table tt-atributos,
                       input table tt-points,
                       input table tt-sets,
                       input table tt-dados,
                       input table tt-ylabels,
                       output table tt-erros).

    if return-value = "NOK" then
        for each tt-erros:
             run utp/ut-msgs.p (input "show",
                                input tt-erros.cod-erro,
                                input "").
        end.

    /* Elimina os registros das temp-tables     */     

    FOR EACH tt-consumo:
        DELETE tt-consumo.
    END.
    for each tt-dados:
       delete tt-dados.
    end.

    for each tt-atributos:
        delete tt-atributos.
    end.

    for each tt-points:
        delete tt-points.
    end.

    for each tt-sets:
        delete tt-sets.
    end.

    for each tt-erros:
        delete tt-erros.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico-ce0849 V-table-Win 
PROCEDURE pi-gera-grafico-ce0849 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter c-per-ini as char format "9999/99".
    def input parameter i-classif-grafico as int no-undo.

    def var de-giro-estoq as dec no-undo.
    def var c-tit-graf-item        as char no-undo.
    def var c-tit-graf-est         as char no-undo.
    def var da-data-orig           as date no-undo.
    def var i-cont-aux             as int  no-undo.
    def var de-saldo-medio         like sl-it-per.saldo-medio no-undo.
    def var da-data-ult-saldo      as date no-undo.

    def var h-acomp as handle no-undo.

    run prgint/utb/utb743za.py persistent set h_api_cta.
    run prgint/utb/utb742za.py persistent set h_api_ccust.

    run utp/ut-acomp.p persistent set h-acomp.
    {utp/ut-liter.i Gerando_gr†fico *}
    run pi-inicializar in h-acomp(input  Return-value ).

    /*--- Cria temp-table com todos os depositos que tenham 
          saldo para o estab, item e deposito ---*/

    &IF int (substring (proversion, 1, index (proversion, ".") - 1)) >= 9 &THEN
        empty temp-table tt-deposito.
    &ELSE      
        for each tt-deposito:
            delete tt-deposito.
        end.
    &ENDIF

    for each deposito fields(cod-depos) no-lock:
        if can-find(first saldo-estoq 
                    where saldo-estoq.cod-estabel = item-estab.cod-estabel
                      and saldo-estoq.it-codigo   = item-estab.it-codigo
                      and saldo-estoq.cod-depos   = deposito.cod-depos) then do:
           create tt-deposito.
           assign tt-deposito.cod-depos = deposito.cod-depos.
        end.
    end.

    /*-----------------------------------------------------------*/

    if  not avail param-global then
        find first param-global no-lock no-error.

    if  i-classif-grafico = 1 then do:  
        {utp/ut-liter.i Giro_de_Estoque_do_Item}
        assign c-tit-graf = return-value.
    end.
    else do:
        {utp/ut-liter.i Giro_de_Estoque_do_Estab}
        assign c-tit-graf-est  = return-value.
        {utp/ut-liter.i Item}
        assign c-tit-graf-item = return-value.
    end.

    {utp/ut-liter.i Porcentagem}
    assign c-tit-y = trim(return-value).
    {utp/ut-liter.i Meses}
    assign c-tit-x = trim(return-value).

    find first tt-atributos no-error.
    if  not avail tt-atributos then
        create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 4
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 0
           tt-atributos.bottomtitle           = c-tit-x
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 0
           tt-atributos.gridlinestyle         = 0.

    if  i-classif-grafico = 1 then 
        assign tt-atributos.graphtitle = c-tit-graf + " " + item-estab.it-codigo.
    else
        assign tt-atributos.graphtitle = c-tit-graf-est  + " " + item-estab.cod-estabel + " " +
                                         c-tit-graf-item + " " + item-estab.it-codigo.

    create tt-sets.
    assign tt-sets.numgraph = 1
           tt-sets.numset   = 1
           c-tabela         = {ininc/i01in061.i 03}
           i-ano            = int(substr(c-per-ini,1,4)) - 1
           i-mes            = int(substr(c-per-ini,5,2)) + 1
           da-data          = (if i-mes > 12
                                  then date(1,1,i-ano + 1)
                                  else date(i-mes,1,i-ano))
           da-data-orig     = da-data.

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        RUN utp/ut-liter.p (trim(c-tabela), "*", "").
        assign c-tabela = return-value.
    &endif
    
    assign i-cont-aux = 1.

    do  i-cont = 1 to 12:

        /*--- Logica para que a variavel da-data contenha o ultimo dia do 
              mes que se esta partindo para consulta ---*/

        if  month(da-data-orig) + i-cont-aux > 12 then
            assign i-cont-aux   = 1
                   da-data      = date(01,01,year(da-data-orig) + 1)
                   da-data-orig = date(01,01,year(da-data-orig) + 1).
        else
            assign da-data    = date(month(da-data-orig) + i-cont-aux,01,year(da-data-orig))
                   i-cont-aux = i-cont-aux + 1.

        assign da-data = da-data - 1.
        /*----------------------------------------------------------*/

        assign c-per-pesq       = string(year(da-data),"9999")+ string(month(da-data),"99")
               de-total-consumo = 0
               de-giro-estoq    = 0
               i-mes            = month(da-data).

        {utp/ut-liter.i Perido:_ *}
        run pi-acompanhar in h-acomp(input  Return-value  + 
                                     string(year(da-data),"9999") + "/" + 
                                     string(month(da-data),"99")). 

        if  i-classif-grafico = 1 then do:

            assign v_cod_cta_ctbl = ""
                   c-sc-codigo    = "".

            for each  consumo-estab use-index item no-lock
                where consumo-estab.periodo   = c-per-pesq
                  and consumo-estab.it-codigo = item-estab.it-codigo:

                assign i-empresa = param-global.empresa-prin.

                &if defined (bf_dis_consiste_conta) &then

                    if  not avail estabelec 
                    or  (avail estabelec and estabelec.cod-estabel <> item-estab.cod-estabel) then
                        find estabelec where
                             estabelec.cod-estabel = item-estab.cod-estabel no-lock no-error.

                    run cdp/cd9970.p (input rowid(estabelec),
                                      output i-empresa).
                &endif

                if  v_cod_cta_ctbl = ""
                or  ( v_cod_cta_ctbl <> "" and (v_cod_cta_ctbl <> consumo-estab.ct-codigo or
                                                c-sc-codigo    <> consumo-estab.sc-codigo )) then do:

                    assign d-dta-consumo = date("01/" + substring(consumo-estab.periodo,5,2) + "/" + substring(consumo-estab.periodo,1,4)).
                                                                                                                                       
                    assign v_cod_cta_ctbl = consumo-estab.ct-codigo
                           c-sc-codigo    = consumo-estab.sc-codigo.

                    run pi_busca_dados_cta_ctbl in h_api_cta  (input        i-empresa,          /* EMPRESA EMS2 */                        
                                                               input        "",                 /* PLANO DE CONTAS */                     
                                                               input-output v_cod_cta_ctbl,     /* CONTA */                               
                                                               input        d-dta-consumo,      /* DATA TRANSACAO */                      
                                                               output       v_des_cta_ctbl,     /* DESCRICAO CONTA */                     
                                                               output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */                       
                                                               output       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */                   
                                                               output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */                
                                                               output table tt_log_erro).       /* ERROS */    
                                                                                                                                      
                    /**  Ignora consumo se a conta n∆o for de consumo de acordo com parametro **/
                    if v_cod_cta_ctbl <> "" and
                       lookup({adinc/i05ad049.i 4 1}, v_ind_finalid_cta) <> 0 or
                       lookup({adinc/i05ad049.i 4 3}, v_ind_finalid_cta) <> 0 or
                       lookup({adinc/i05ad049.i 4 6}, v_ind_finalid_cta) <> 0 then do:
                    
                        assign de-total-consumo = de-total-consumo + consumo-estab.qt-saida.
                    end.
                end.                
            end.
        end.
        else do:
            assign v_cod_cta_ctbl = ""
                   c-sc-codigo    = "".

            for each  consumo-estab use-index item-estab no-lock
                where consumo-estab.periodo     = c-per-pesq
                  and consumo-estab.it-codigo   = item-estab.it-codigo
                  and consumo-estab.cod-estabel = item-estab.cod-estabel:

                assign i-empresa = param-global.empresa-prin.

                &if defined (bf_dis_consiste_conta) &then

                    if  not avail estabelec 
                    or  (avail estabelec and estabelec.cod-estabel <> item-estab.cod-estabel) then
                        find estabelec where
                             estabelec.cod-estabel = item-estab.cod-estabel no-lock no-error.

                    run cdp/cd9970.p (input rowid(estabelec),
                                      output i-empresa).
                &endif

                if  v_cod_cta_ctbl = ""
                    or  ( v_cod_cta_ctbl <> "" and (v_cod_cta_ctbl <> consumo-estab.ct-codigo or
                                                c-sc-codigo        <> consumo-estab.sc-codigo )) then do:

                    assign d-dta-consumo = date("01/" + substring(consumo-estab.periodo,5,2) + "/" + substring(consumo-estab.periodo,1,4)).
                                                                                                                                       
                    assign v_cod_cta_ctbl = consumo-estab.ct-codigo
                           c-sc-codigo    = consumo-estab.sc-codigo.

                    run pi_busca_dados_cta_ctbl in h_api_cta  (input        i-empresa,          /* EMPRESA EMS2 */                        
                                                               input        "",                 /* PLANO DE CONTAS */                     
                                                               input-output v_cod_cta_ctbl,     /* CONTA */                               
                                                               input        d-dta-consumo,      /* DATA TRANSACAO */                      
                                                               output       v_des_cta_ctbl,     /* DESCRICAO CONTA */                     
                                                               output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */                       
                                                               output       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */                   
                                                               output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */                
                                                               output table tt_log_erro).       /* ERROS */    
                                                                                                                                      
                    /**  Ignora consumo se a conta n∆o for de consumo de acordo com parametro **/
                    if v_cod_cta_ctbl <> "" and
                       lookup({adinc/i05ad049.i 4 1}, v_ind_finalid_cta) <> 0 or
                       lookup({adinc/i05ad049.i 4 3}, v_ind_finalid_cta) <> 0 or
                       lookup({adinc/i05ad049.i 4 6}, v_ind_finalid_cta) <> 0 then do:
                    
                        assign de-total-consumo = de-total-consumo + consumo-estab.qt-saida.
                    end.
                end.
            end.
        end.

        assign de-saldo-medio = 0.

        /*--- Acumula os saldos medios dos depositos ---*/
        for each tt-deposito:
            /*--- Quando o grafico eh por item, acumula os saldos de todos 
                  os estabelecimentos ---*/
            IF  i-classif-grafico = 1  THEN DO:
                find last  sl-it-per
                     where sl-it-per.periodo   <= da-data
                       and sl-it-per.it-codigo  = item-estab.it-codigo
                       and sl-it-per.cod-depos  = tt-deposito.cod-depos no-lock no-error.
                if avail sl-it-per then
                   assign da-data-ult-saldo = sl-it-per.periodo.
                else
                   assign da-data-ult-saldo = ?.

                FOR EACH  sl-it-per
                    WHERE sl-it-per.periodo   = da-data-ult-saldo
                      AND sl-it-per.it-codigo = item-estab.it-codigo
                      AND sl-it-per.cod-depos = tt-deposito.cod-depos NO-LOCK:
                    ASSIGN de-saldo-medio = de-saldo-medio + sl-it-per.saldo-medio.
                END.
            END.
            ELSE DO:
                /*--- Sen∆o acumula somente do estabelecimento selecionado ---*/
                find last  sl-it-per
                     where sl-it-per.periodo     <= da-data
                       and sl-it-per.cod-estabel  = item-estab.cod-estabel
                       and sl-it-per.it-codigo    = item-estab.it-codigo
                       and sl-it-per.cod-depos    = tt-deposito.cod-depos no-lock no-error.

                if  avail sl-it-per then
                    assign de-saldo-medio = de-saldo-medio + sl-it-per.saldo-medio.
            END.
        end.

         
        assign de-giro-estoq = (de-total-consumo / de-saldo-medio) * 100.

        if  de-giro-estoq = ? then
            assign de-giro-estoq = 0.

        assign c-tab-meses  = entry(i-mes,c-tabela).

        create tt-points.
        assign tt-points.numgraph  = 1
               tt-points.numpoint  = i-cont
               tt-points.labeltext = c-tab-meses.

        create tt-dados.
        assign tt-dados.numgraph  = 1
               tt-dados.numpoint  = i-cont
               tt-dados.numset    = 1
               tt-dados.graphdata = de-giro-estoq.
    end.

    run pi-finalizar in h-acomp.
    run utp/utapi001.p(input  table tt-atributos,
                       input  table tt-points,
                       input  table tt-sets,
                       input  table tt-dados,
                       input  table tt-ylabels,
                       output table tt-erros).
    if  return-value = "NOK" then
        for each tt-erros:
            run utp/ut-msgs.p (input "show":U, input tt-erros.cod-erro, input "").
        end.

    /* Elimina os registros das temp-tables */
    for each tt-dados:
        delete tt-dados.
    end.
    for each tt-atributos:
        delete tt-atributos.
    end.
    for each tt-points:
        delete tt-points.
    end.
    for each tt-sets:
        delete tt-sets.
    end.
    for each tt-erros:
        delete tt-erros.
    end.

    delete procedure h_api_cta.   
    delete procedure h_api_ccust. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

/*/*    Segue um exemplo de validaá∆o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
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
  {src/adm/template/snd-list.i "item-estab"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
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
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


