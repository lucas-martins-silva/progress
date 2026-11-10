&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V34IN176 2.00.00.012 } /*** "010012" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v34in176 MUT}
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

def var c-estabelec    like estabelec.cod-estabel      no-undo.
def var c-num-ord-inv  like it-doc-fisico.num-ord-inv  no-undo.
def var de-qtd-max-aux like item-doc-est.quantidade[1] no-undo.
def var i-ord-aux      like item-doc-est.nr-ord-prod   no-undo.

def new global shared var gr-doc-fisico as rowid no-undo.

DEF VAR c-zoom-cod-conta   AS CHAR   NO-UNDO.
DEF VAR c-zoom-desc-conta  AS CHAR   NO-UNDO.
DEF VAR i-empresa          AS CHAR   NO-UNDO.
def var v_cod_cta_ctbl     as char   no-undo.
def var v_des_cta_ctbl     as char   no-undo.
def var v_ind_finalid_cta  as char   no-undo.
DEF VAR c-conta            AS CHAR   NO-UNDO.
DEF VAR l-utiliza-cc       AS LOG    NO-UNDO.
DEF VAR c-format-conta     AS CHAR   NO-UNDO.
def var h_api_cta_ctbl     as handle no-undo.
def var h_api_ccusto       as handle no-undo.
def var v_num_tip_cta_ctbl as int    no-undo.
def var v_num_sit_cta_ctbl as int    no-undo.
def var v_log_utz_ccusto   as log    no-undo.
def var v_cod_formato      as char   no-undo.
DEF VAR c-zoom-cod-ccusto  AS CHAR   NO-UNDO.
DEF VAR c-zoom-desc-ccusto AS CHAR   NO-UNDO.
def var v_des_ccusto       as char   no-undo.
def var v_cod_ccusto       as char   no-undo.
DEF VAR i-num-tip-cta-cta  AS INT    NO-UNDO.
DEF VAR i-num-sit-cta      AS INT    NO-UNDO.
DEF VAR i-num-finalid-cta  AS INT    NO-UNDO.
DEF VAR i-lista-finalid    AS INT    NO-UNDO.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro   as int  format ">>>>,>>9" label "N£mero"         column-label "N£mero"
    field ttv_des_msg_ajuda  as char format "x(40)"    label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro   as char format "x(60)"    label "Mensagem Erro"  column-label "Inconsistància"
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES saldo-terc
&Scoped-define FIRST-EXTERNAL-TABLE saldo-terc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR saldo-terc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold d-quantidade i-ord-prod ~
c-cod-conta c-cod-ccusto 
&Scoped-Define DISPLAYED-OBJECTS i-seq c-item c-desc-item d-quantidade ~
i-ord-prod c-cod-conta c-desc-conta c-cod-ccusto c-desc-ccusto 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

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
DEFINE VARIABLE c-cod-ccusto AS CHARACTER FORMAT "X(20)":U 
     LABEL "Centro Custo" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-conta AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta":R7 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ccusto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-item AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE d-quantidade AS DECIMAL FORMAT ">>>>,>>9.9999" INITIAL 0 
     LABEL "":R5 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-ord-prod AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "":R17 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-seq AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 4.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-seq AT ROW 1.25 COL 19 COLON-ALIGNED
     c-item AT ROW 2.25 COL 19 COLON-ALIGNED
     c-desc-item AT ROW 2.25 COL 37 COLON-ALIGNED NO-LABEL
     d-quantidade AT ROW 3.88 COL 19 COLON-ALIGNED
     i-ord-prod AT ROW 4.88 COL 19 COLON-ALIGNED HELP
          "Informe o numero da ordem de produá∆o"
     c-cod-conta AT ROW 5.88 COL 19 COLON-ALIGNED HELP
          "Conta"
     c-desc-conta AT ROW 5.88 COL 38.57 COLON-ALIGNED NO-LABEL
     c-cod-ccusto AT ROW 6.88 COL 19 COLON-ALIGNED WIDGET-ID 2
     c-desc-ccusto AT ROW 6.88 COL 38.57 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.63 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.saldo-terc
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 7
         WIDTH              = 78.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-ccusto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-conta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-seq IN FRAME f-main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-cod-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ccusto V-table-Win
ON ENTRY OF c-cod-ccusto IN FRAME f-main /* Centro Custo */
DO:
    ASSIGN c-cod-ccusto:format in frame {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ccusto V-table-Win
ON F5 OF c-cod-ccusto IN FRAME f-main /* Centro Custo */
DO:
    RUN pi-zoom-ccusto (OUTPUT c-zoom-cod-ccusto,
                        OUTPUT c-zoom-desc-ccusto).

    IF c-zoom-cod-ccusto <> "" THEN
        assign c-cod-ccusto:screen-value  in frame {&FRAME-NAME} = c-zoom-cod-ccusto
               c-desc-ccusto:screen-value in frame {&FRAME-NAME} = c-zoom-desc-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ccusto V-table-Win
ON LEAVE OF c-cod-ccusto IN FRAME f-main /* Centro Custo */
DO:
    assign c-cod-ccusto:format in frame {&FRAME-NAME} = "x(20)".

    IF c-cod-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:
        RUN pi-desc-ccusto (INPUT  input frame {&FRAME-NAME} c-cod-ccusto,
                            OUTPUT c-desc-ccusto).
    
        IF RETURN-VALUE = "OK" THEN
            ASSIGN c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-desc-ccusto.
        ELSE
            ASSIGN c-cod-ccusto:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = ""
                   c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.
    ELSE
        ASSIGN c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ccusto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-ccusto IN FRAME f-main /* Centro Custo */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-conta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-conta V-table-Win
ON ENTRY OF c-cod-conta IN FRAME f-main /* Conta */
DO:
    assign c-cod-conta:FORMAT     IN FRAME {&FRAME-NAME} = "x(20)"
           c-cod-ccusto:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-conta V-table-Win
ON F5 OF c-cod-conta IN FRAME f-main /* Conta */
DO:
    RUN pi-zoom-conta (OUTPUT c-zoom-cod-conta,
                       OUTPUT c-zoom-desc-conta).

    IF c-zoom-cod-conta <> "" THEN
        assign c-cod-conta:screen-value  in frame {&FRAME-NAME} = c-zoom-cod-conta
               c-desc-conta:screen-value in frame {&FRAME-NAME} = c-zoom-desc-conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-conta V-table-Win
ON LEAVE OF c-cod-conta IN FRAME f-main /* Conta */
DO: 
    assign c-cod-conta:format in frame {&FRAME-NAME} = "x(20)".

    IF c-cod-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:

        ASSIGN c-conta = input frame {&frame-name} c-cod-conta.
        RUN pi-desc-conta ( INPUT-OUTPUT c-conta,
                            OUTPUT       c-desc-conta,
                            OUTPUT       l-utiliza-cc).

        IF RETURN-VALUE = "OK" THEN DO:

            RUN pi-format-conta (OUTPUT c-format-conta).

            ASSIGN c-cod-conta:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = c-conta
                   c-cod-conta:FORMAT        IN FRAME {&FRAME-NAME} = c-format-conta
                   c-desc-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-desc-conta.

            IF NOT l-utiliza-cc THEN
                ASSIGN c-cod-ccusto:SENSITIVE     IN FRAME {&FRAME-NAME} = NO
                       c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       c-cod-ccusto:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "".
        END.
        ELSE
            ASSIGN c-cod-conta:FORMAT         IN FRAME {&FRAME-NAME} = "x(20)"
                   c-cod-conta:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = ""
                   c-desc-conta:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = ""
                   c-cod-ccusto:SENSITIVE     IN FRAME {&FRAME-NAME} = NO
                   c-cod-ccusto:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = ""
                   c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.
    ELSE
        ASSIGN c-cod-conta:FORMAT         IN FRAME {&FRAME-NAME} = "x(20)"
               c-desc-conta:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = ""
               c-cod-ccusto:SENSITIVE     IN FRAME {&FRAME-NAME} = NO
               c-cod-ccusto:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = ""
               c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-conta V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-conta IN FRAME f-main /* Conta */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-ord-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ord-prod V-table-Win
ON F5 OF i-ord-prod IN FRAME f-main
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in271.w
                       &campo=i-ord-prod
                       &campozoom=nr-ord-produ}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ord-prod V-table-Win
ON LEAVE OF i-ord-prod IN FRAME f-main
DO:
 
    if  input frame {&frame-name} i-ord-prod <> 0 then do:
        find ord-prod 
            where ord-prod.nr-ord-produ = input frame {&frame-name} i-ord-prod
            no-lock no-error.
        if  available ord-prod then do:
            assign c-cod-conta:screen-value  in frame {&frame-name} = ord-prod.ct-codigo 
                   c-cod-ccusto:screen-value in frame {&frame-name} = ord-prod.sc-codigo.            
            
            apply 'leave' to c-cod-conta  in frame {&frame-name}.
            apply 'leave' to c-cod-ccusto in frame {&frame-name}.
        end.
        disable c-cod-conta with frame {&frame-name}.                
    end.                                                 
    else do:
        if  param-global.modulo-ce then
            assign c-cod-conta:sensitive  in frame {&frame-name} = yes
                   c-cod-ccusto:sensitive in frame {&frame-name} = yes. /***** natur-oper.tipo = 1. entrada *****/            
        else
            assign c-cod-conta:sensitive in frame {&frame-name} = no
                   c-cod-ccusto:sensitive in frame {&frame-name} = no.

        if  input frame {&frame-name} i-ord-prod <> i-ord-aux then
            assign c-cod-conta:screen-value in frame {&frame-name} = ""
                   c-desc-conta:screen-value in frame {&frame-name} = ""
                   c-cod-ccusto:screen-value in frame {&frame-name} = ""
                   c-desc-ccusto:screen-value in frame {&frame-name} = "".

        apply 'entry' to c-cod-conta in frame {&frame-name}.
    end.        

    assign i-ord-aux = input frame {&frame-name} i-ord-prod.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ord-prod V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-ord-prod IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

{utp/ut-field.i mgind it-doc-fisico it-codigo 1}
assign c-item:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind it-doc-fisico sequencia 1}
assign i-seq:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind it-doc-fisico quantidade 1}
assign d-quantidade:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind it-doc-fisico nr-ord-produ 1}
assign i-ord-prod:label in frame {&frame-name} = return-value.

if c-cod-conta:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .

if c-cod-ccusto:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .

if i-ord-prod:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "saldo-terc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "saldo-terc"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
    /*{include/i-valid.i}*/

      if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  delete object h_api_ccusto.
  delete object h_api_cta_ctbl.

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
    if adm-new-record = yes then
    &if  defined(ADM-MODIFY-FIELDS) &then
    enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  run prgint/utb/utb742za.py persistent set h_api_ccusto.
  run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

  find first param-global no-lock no-error.

  find doc-fisico where 
       rowid(doc-fisico) = gr-doc-fisico no-lock no-error.

  if  avail doc-fisico then do:
      find estabelec WHERE
           estabelec.cod-estabel = doc-fisico.cod-estabel no-lock no-error.
      if avail estabelec THEN
          assign i-empresa = estabelec.ep-codigo.                        
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza V-table-Win 
PROCEDURE pi-atualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param nr-sequencia        like it-doc-fisico.sequencia     no-undo.  
def input param it-codigo           like it-doc-fisico.it-codigo     no-undo. 
def input param de-qtd-max          like item-doc-est.quantidade[1]  no-undo.
def input-output param quantidade   like it-doc-fisico.quantidade[1] no-undo.
def input-output param nr-ord-produ like it-doc-fisico.nr-ord-produ  no-undo.
def input-output param ct-codigo    like it-doc-fisico.ct-codigo     no-undo.
def input-output param sc-codigo    like it-doc-fisico.sc-codigo     no-undo.
def input-output param cod-estabel  like estabelec.cod-estabel       no-undo.
def input-output param num-ord-inv  like it-doc-fisico.num-ord-inv   no-undo.
def input-output param baixa-estoq  like it-doc-fisico.baixa-ce      no-undo.

assign i-seq:screen-value        in frame {&frame-name} = string(nr-sequencia)
       c-item:screen-value       in frame {&frame-name} = it-codigo
       d-quantidade:screen-value in frame {&frame-name} = string(quantidade)
       i-ord-prod:screen-value   in frame {&frame-name} = string(nr-ord-produ)
       c-cod-conta:screen-value  in frame {&frame-name} = ct-codigo
       c-cod-ccusto:screen-value in frame {&frame-name} = sc-codigo
       c-estabelec    = cod-estabel
       c-num-ord-inv  = num-ord-inv
       de-qtd-max-aux = de-qtd-max
       i-ord-aux      = nr-ord-produ.

find ord-prod where
     ord-prod.nr-ord-produ = nr-ord-produ no-lock no-error.

find item where
     item.it-codigo = it-codigo no-lock no-error.
if avail item then
   assign c-desc-item:screen-value in frame {&frame-name} = item.desc-item.

assign i-ord-prod:sensitive  in frame {&FRAME-NAME} = (param-global.modulo-cp or param-global.modulo-mi)
       c-cod-conta:sensitive in frame {&FRAME-NAME} =  input frame {&FRAME-NAME} i-ord-prod = 0
       c-cod-ccusto:sensitive in frame {&FRAME-NAME} = input frame {&FRAME-NAME} i-ord-prod = 0.

if avail item then do:
    /* Sugere as informaá‰es cadastradas no CD0138, somente se n∆o tiver ordem informada (zero) */      
    if nr-ord-produ = 0 and ct-codigo = "" then
        assign c-cod-conta:screen-value  in frame {&FRAME-NAME} = item.ct-codigo
               c-cod-ccusto:screen-value in frame {&FRAME-NAME} = item.sc-codigo.
end.

apply 'leave' to c-cod-conta  in frame {&frame-name}.
apply 'leave' to c-cod-ccusto in frame {&frame-name}. 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-dados-conta V-table-Win 
PROCEDURE pi-busca-dados-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-cod-conta       AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-num-tip-cta     AS INT  NO-UNDO.
    DEF OUTPUT PARAM p-num-sit-cta     AS INT  NO-UNDO.
    DEF OUTPUT PARAM p-num-finalid-cta AS INT  NO-UNDO.

    DEF VAR icont AS INT NO-UNDO.

    EMPTY TEMP-TABLE tt_log_erro.
    
    assign v_cod_cta_ctbl    = p-cod-conta
           i-num-tip-cta-cta = 0
           i-num-sit-cta     = 0
           i-num-finalid-cta = 0.

    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    run pi_busca_dados_cta_ctbl_integr in h_api_cta_ctbl (input        i-empresa,         /* EMPRESA EMS2 */
                                                          input        "CEP",             /* MÖDULO */
                                                          input        "",                /* PLANO DE CONTAS */
                                                          input        v_cod_cta_ctbl,    /* CONTA */
                                                          input        today,             /* DATA TRANSACAO */   
                                                          output       v_ind_finalid_cta, /* FINALIDADES DA CONTA */
                                                          output table tt_log_erro).      /* ERROS */ 

    FIND FIRST tt_log_erro NO-ERROR.

    IF NOT AVAIL tt_log_erro THEN DO:
        assign p-num-finalid-cta = {adinc/i05ad049.i 6 v_ind_finalid_cta}
               p-num-tip-cta     = v_num_tip_cta_ctbl
               p-num-sit-cta     = v_num_sit_cta_ctbl.
        RETURN "OK":U.
    END.
    ELSE
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desc-ccusto V-table-Win 
PROCEDURE pi-desc-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-ccuto       AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-desc-ccusto AS CHAR NO-UNDO.

    ASSIGN p-desc-ccusto = ''.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  p-ccuto,            /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".

    ASSIGN p-desc-ccusto = v_des_ccusto.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desc-conta V-table-Win 
PROCEDURE pi-desc-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT-OUTPUT PARAM p-conta      AS CHAR NO-UNDO.
    DEF OUTPUT       PARAM p-desc-conta AS CHAR NO-UNDO.
    DEF OUTPUT       PARAM p-utiliza-cc AS LOG  NO-UNDO.

    ASSIGN p-desc-conta = ''.

    EMPTY TEMP-TABLE tt_log_erro.

    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        i-empresa,          /* EMPRESA EMS2 */
                                                   INPUT        "",                 /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT p-conta,            /* CONTA */
                                                   INPUT        TODAY,              /* DATA TRANSACAO */   
                                                   OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".

    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                       input  "",                 /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  p-conta,            /* CONTA */
                                                       input  today,              /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".

    ASSIGN p-desc-conta = v_des_cta_ctbl
           p-utiliza-cc = v_log_utz_ccusto.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-format-conta V-table-Win 
PROCEDURE pi-format-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM p-format-conta AS CHAR NO-UNDO.

    ASSIGN v_cod_formato = ''.

    run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  today,              /* DATA DE TRANSACAO */ 
                                                       output v_cod_formato,      /* FORMATO CONTA */
                                                       output table tt_log_erro). /* ERROS */

    ASSIGN p-format-conta = v_cod_formato.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava V-table-Win 
PROCEDURE pi-grava :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param quantidade-aux  like it-doc-fisico.quantidade[1] no-undo.
def output param nr-ord-prod-aux like it-doc-fisico.nr-ord-produ  no-undo.
def output param ct-codigo-aux   like it-doc-fisico.ct-codigo     no-undo.
def output param sc-codigo-aux   like it-doc-fisico.sc-codigo     no-undo.
def output param item-pai-aux    like it-doc-fisico.item-pai      no-undo.
def output param cod-roteiro-aux like it-doc-fisico.cod-roteiro   no-undo.
def output param op-codigo-aux   like it-doc-fisico.op-codigo     no-undo.

    find first reservas
         where reservas.nr-ord-produ = input frame {&frame-name} i-ord-prod 
           and reservas.it-codigo   = input frame {&frame-name} c-item no-lock no-error.

    assign quantidade-aux  = input frame {&frame-name} d-quantidade
           nr-ord-prod-aux = input frame {&frame-name} i-ord-prod
           ct-codigo-aux   = input frame {&frame-name} c-cod-conta
           sc-codigo-aux   = input frame {&frame-name} c-cod-ccusto
           item-pai-aux    = if avail reservas then reservas.item-pai    else ""
           cod-roteiro-aux = if avail reservas then reservas.cod-roteiro else ""
           op-codigo-aux   = if avail reservas then reservas.op-codigo   else 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida V-table-Win 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{include/i-vldfrm.i}

    IF  AVAIL item
    AND NOT item.fraciona
    AND ((INTEGER(input frame {&frame-name} d-quantidade ) <> input frame {&frame-name} d-quantidade )) THEN DO:
        RUN utp/ut-msgs.p(INPUT "show", 
                          INPUT 6381,
                          INPUT "").
        apply 'entry' to d-quantidade in frame {&frame-name}.
        RETURN 'adm-error':U.
    END.

    if input frame {&frame-name} d-quantidade = 0 then do:
        /* mensagem: Quantidade deve ser diferente de zero */
        {include/i-vldprg.i}
        {utp/ut-liter.i Quantidade *}
        run utp/ut-msgs.p (input "show", input 1491, input return-value).
        apply 'entry' to d-quantidade in frame {&frame-name}.
        return 'adm-error':U.
    end.       
    if  input frame {&frame-name} d-quantidade > de-qtd-max-aux then do:
       /* mensagem: Quantidade devolvida maior que quantidade faturada */
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show",input 1303,input " ").
       apply 'entry' to d-quantidade in frame {&frame-name}.
       return 'adm-error':U.
    end.

    if  input frame {&frame-name} i-ord-prod <> 0 then do:
        find ord-prod 
            where ord-prod.nr-ord-produ = input frame {&frame-name} i-ord-prod
            no-lock no-error.

        if  not avail ord-prod then do:
            /* mensagem: Ordem de produá∆o n∆o cadastrada */
            {include/i-vldprg.i}
            {utp/ut-table.i mgind ord-prod 01}
            run utp/ut-msgs.p (input "show",input 47,input return-value).
            apply 'entry' to i-ord-prod in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if  ord-prod.cod-estabel <> c-estabelec then do:
            /* mensagem: Ordem de produá∆o n∆o pertence ao estabelecimento da nota */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15189,input " ").
            apply 'entry' to i-ord-prod in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if  avail item and item.tipo-requis = 2 then do:
            /* mensagem: Item possui tipo de requisiá∆o por transferància */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 5675,input " ").
        end.

        if  param-global.modulo-mi then do:
            find ord-manut 
                where ord-manut.nr-ord-produ = ord-prod.nr-ord-produ no-lock no-error.

            if  avail ord-manut then do:
                if  ord-manut.estado-om = 3 then do:
                    /* mensagem: Ordem de manutená∆o suspensa */
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show",input 5676,input " ").
                    apply 'entry' to i-ord-prod in frame {&frame-name}.
                    return 'adm-error':U. 
                end.    

                if  ord-manut.estado-om = 4 then do:
                    if  ord-manut.estado = 8 then do:
                        /* mensagem: Ordem de manutená∆o terminada */
                        {include/i-vldprg.i}
                        run utp/ut-msgs.p (input "show",input 5676,input " ").
                        apply 'entry' to i-ord-prod in frame {&frame-name}.
                        return 'adm-error':U.
                    end.    

                    if  ord-manut.estado = 7 then do:
                        /* mensagem: Ordem de manutená∆o finalizada */
                        {include/i-vldprg.i}
                        run utp/ut-msgs.p (input "show",input 16314,input " ").
                        if  return-value = "no" then do:                               
                            apply 'entry' to i-ord-prod in frame {&frame-name}.
                            return 'adm-error':U.
                        end.
                    end.     
                end.    
            end.
        end.
        if  not avail ord-manut
        and ( ord-prod.estado = 7 or ord-prod.estado = 8 ) then do:
            /* mensagem: Ordem de produá∆o j† esta finalizada */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 1202,input " ").
            apply 'entry' to i-ord-prod in frame {&frame-name}.
            return 'adm-error':U.
        end.
    end.                

    if  input frame {&frame-name} i-ord-prod = 0 
    and input frame {&frame-name} c-cod-conta <> "" then do:

        RUN pi-busca-dados-conta (INPUT  input frame {&frame-name} c-cod-conta,
                                  OUTPUT i-num-tip-cta-cta,  /* conta-contab.tipo    */
                                  OUTPUT i-num-sit-cta,      /* conta-contab.estado  */
                                  OUTPUT i-num-finalid-cta). /* conta-contab.estoque */
    
        IF RETURN-VALUE = "NOK" THEN DO:
            /* mensagem: Conta cont†bil n∆o cadastrada */
            {include/i-vldprg.i}
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Conta" *}
            run utp/ut-msgs.p (input "show",input 47,input RETURN-VALUE).
            apply 'entry' to c-cod-conta in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if  i-num-sit-cta <> 3 then do:
            /* mensagem: Conta n∆o Ç de sistema */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 443,input " ").
            apply 'entry' to c-cod-conta in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if  not can-do("1,2,4,5",string(i-num-tip-cta-cta)) then do:        
            /* mensagem: Conta deve ser de despesa, receita, ativo ou passivo */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 5543,input " ").
            apply "entry" to c-cod-conta in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if  i-num-finalid-cta = 10 then do:
            /* mensagem: Conta n∆o aceita lancamentos do estoque */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15190,input " ").
            apply 'entry' to c-cod-conta in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if  not can-do("1,2,3,6",string(i-num-finalid-cta)) then do:
            /* mensagem: Conta n∆o aceita lancamentos de requisiá‰es */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 107,input " ").
            apply 'entry' to c-cod-conta in frame {&frame-name}.
            return 'adm-error':U.
        end.

        /* validaá∆o modulo de investimento - Jucinei */
        run pi_valida_cta_ctbl_integr in h_api_cta_ctbl (input  STRING(i-empresa),  /* EMPRESA EMS2 */
                                                         input  "INP",              /* MODULO INP */
                                                         input  "",                 /* PLANO CONTAS */ 
                                                         input  input frame {&frame-name} c-cod-conta, /* CONTA */
                                                         input  "Gera lanáamentos", /* FINALIDADES */
                                                         input  today,              /* DATA DE TRANSACAO */  
                                                         output table tt_log_erro). /* ERROS */
        IF RETURN-VALUE = "OK" THEN
            ASSIGN i-lista-finalid = 2. /* 2 - Gera lanáamentos */
        ELSE
            ASSIGN i-lista-finalid = 1. /* 1 - N∆o gera lanáaamentos */

        if  c-num-ord-inv = 0 and i-lista-finalid = 2 then do:
            /* mensagem: Conta cont†bil Ç de investimentos. N∆o pode receber outros lanáamentos */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15191,input " ").
            apply 'entry' to c-cod-conta in frame {&frame-name}.
            return 'adm-error':U.
        end.
    end.        

    if avail item and ( item.tipo-contr = 1 or item.tipo-contr = 4 ) 
    and   input frame {&frame-name} c-cod-conta = "" then do:
        /* mensagem: Conta cont†bil deve ser informada */
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show", input 6726, input " ").
        apply 'entry' to c-cod-conta in frame {&frame-name}.
        return 'adm-error':U.
    end.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-ccusto V-table-Win 
PROCEDURE pi-zoom-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM p-ccusto      AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-desc-ccusto AS CHAR NO-UNDO.

    run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                        input "",                  /* CODIGO DO PLANO CCUSTO */
                                        input "",                  /* UNIDADE DE NEGOCIO */
                                        input today,               /* DATA DE TRANSACAO */
                                        output v_cod_ccusto,       /* CODIGO CCUSTO */
                                        output v_des_ccusto,       /* DESCRICAO CCUSTO */
                                        output table tt_log_erro). /* ERROS */ 

    ASSIGN p-ccusto      = v_cod_ccusto
           p-desc-ccusto = v_des_ccusto.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-conta V-table-Win 
PROCEDURE pi-zoom-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM p-conta      AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-desc-conta AS CHAR NO-UNDO.

    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "CEP",              /* MÖDULO */
                                                   input  "",                 /* PLANO DE CONTAS */
                                                   input  "(nenhum)",         /* FINALIDADES */
                                                   input  today,              /* DATA TRANSACAO */
                                                   output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   output v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   output table tt_log_erro). /* ERROS */

    ASSIGN p-conta      = v_cod_cta_ctbl
           p-desc-conta = v_des_cta_ctbl.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "saldo-terc"}

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

