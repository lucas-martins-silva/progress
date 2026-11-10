&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V44IN271 2.00.00.024 } /*** "010024" 02/07/2024 09:14:32 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v44in271 MUT}
&ENDIF

/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

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
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var i-baixa-reservas        as int    no-undo init 1.
def var l-informa-deposito      as log    no-undo init yes.
def var l-informa-localizacao   as log    no-undo.
def var l-requisicao-automatica as log    no-undo.
def var l-busca-saldos          as log    no-undo.
def var i-empresa-prin          LIKE empresa.ep-codigo NO-UNDO.

def var i-op-seq                         as int    no-undo .
def var de-menor-cq                      as dec    no-undo init 0 .
def var de-saldo-cq                      as dec    no-undo init 0 .
def var de-reporta                       like ord-prod.qt-reportada.
def var de-menor-prod                    as dec    no-undo init 0  .
def var l-ultima                         as log    no-undo         .
def var l-carrega-browse                 as log    no-undo init yes.
def var l-pergunta                       as log    no-undo init yes.
def var de-qtde-requis                   as dec    no-undo.
def var da-data-ultimo-reporte           as date   no-undo.
def var i-estado-oper-ord                as int    no-undo.
def var de-ref-rep                       as dec    no-undo.
def var de-aux                           as dec    no-undo.
def var rw-item-pai                      as rowid  no-undo.
def var i-retorno                        as int    no-undo.
def var i-esp-docto                      as int    no-undo.
def var i-op-codigo                      as int    no-undo.
def var i-nr-ficha                       as int    no-undo.
def var de-qt-acum                       as dec    no-undo.
def var de-qt-orig                       as dec    no-undo.
def var c-cod-depos-acabado              as char   no-undo.
def var c-cod-localiz-acabado            as char   no-undo.
def var c-lote-serie-acabado             as char   no-undo.
def var de-quantidade-reporte            as dec    no-undo.
def var de-horas-mob-dir                 as dec    no-undo.
def var de-horas-ggf                     as dec    no-undo.
def var rw-saldo-estoq                   as rowid  no-undo.
def var l-repete                         as log    no-undo.
def var de-saldo-ped                     as dec    no-undo.
def var c-handle                         as char   no-undo.
def var da-vali-lote-acabado             as date   no-undo.
def var c-cod-refer-acabado              as char   no-undo.
DEF VAR c-conta                          AS CHAR   NO-UNDO.
DEF VAR c-ccusto                         AS CHAR   NO-UNDO.
def var i-cod-msg                        as int    no-undo.
def var l-requisita-configurado          as log    no-undo.
def var i-num-sequen                     as int    no-undo.
def var h-handle                         as handle no-undo.
def var wh-handle-viewer-principal       as handle no-undo.

DEF VAR i-fnc-pf AS LOGICAL NO-UNDO.

def var c-quant-reporte                  as char   no-undo.

/* Variavel global para chamada do programa de cadastro de narrativas para
   ordens de prototipo                                                  */   
def new global shared var gr-parametro-reporte as rowid no-undo.

def buffer b-oper-ord for oper-ord.
def buffer b-ord-prod for ord-prod.

def new global shared var h-acomp as handle no-undo.

def var l-ok as log.

{cdp/cdcfgman.i} /* Include com preprocessador para release 2.02 */ 
{cdp/cdcfgmat.i} /* Preprocessador bf_mat_conta_estab            */ 
{cpp/cpapi001.i}
{cpp/cpapi001.i1}
{cpp/cpapi001.i28} /* f-retorna-ult-oper */
{cpp/cpapi029.i}
{cdp/cd0666.i}


DEFINE VARIABLE h-handle-pai AS HANDLE     NO-UNDO.

/** Unificaá∆o de Conceito **/
{cdp/cdunif001.i}
{cdp/cdunif001.i1}

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
&Scoped-define EXTERNAL-TABLES ord-prod
&Scoped-define FIRST-EXTERNAL-TABLE ord-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-depos fi-conta-debito-direto ~
fi-ccusto fi-cod-localiz fi-quantidade-reporte fi-dt-trans ~
fi-quantidade-refugo fi-nro-docto fi-conta-refugo fi-cc-refugo ~
fi-serie-docto fi-quantidade-aprov-cond 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS fi-dt-trans fi-nro-docto fi-serie-docto 
&Scoped-define ADM-MODIFY-FIELDS fi-quantidade-reporte fi-dt-trans ~
fi-quantidade-refugo fi-nro-docto fi-serie-docto fi-quantidade-aprov-cond 
&Scoped-define List-4 rt-mold 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fi-cc-refugo AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ccusto AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-depos AS CHARACTER FORMAT "x(3)" 
     LABEL "":R10 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-localiz AS CHARACTER FORMAT "x(20)" 
     LABEL "":R14 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-conta-debito-direto AS CHARACTER FORMAT "x(20)" 
     LABEL "":R17 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-conta-refugo AS CHARACTER FORMAT "x(20)" 
     LABEL "":R17 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-trans AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nro-docto AS CHARACTER FORMAT "x(16)" 
     LABEL "":R11 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-quantidade-aprov-cond AS DECIMAL FORMAT ">>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "":R12 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-quantidade-refugo AS DECIMAL FORMAT ">>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "":R12 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-quantidade-reporte AS DECIMAL FORMAT ">>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "":R12 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-serie-docto AS CHARACTER FORMAT "x(5)" 
     LABEL "":R18 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.14 BY 6.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-cod-depos AT ROW 1.25 COL 13.86 COLON-ALIGNED
     fi-conta-debito-direto AT ROW 1.25 COL 45.57 COLON-ALIGNED
     fi-ccusto AT ROW 1.25 COL 65.72 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     fi-cod-localiz AT ROW 2.33 COL 13.86 COLON-ALIGNED HELP
          "C¢digo de Localizaá∆o do Material"
     fi-quantidade-reporte AT ROW 2.33 COL 45.57 COLON-ALIGNED
     fi-dt-trans AT ROW 3.42 COL 13.86 COLON-ALIGNED
     fi-quantidade-refugo AT ROW 3.42 COL 45.57 COLON-ALIGNED
     fi-nro-docto AT ROW 4.5 COL 13.86 COLON-ALIGNED HELP
          "N£mero do Documento"
     fi-conta-refugo AT ROW 4.5 COL 45.57 COLON-ALIGNED
     fi-cc-refugo AT ROW 4.5 COL 65.72 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     fi-serie-docto AT ROW 5.58 COL 13.86 COLON-ALIGNED
     fi-quantidade-aprov-cond AT ROW 5.58 COL 45.57 COLON-ALIGNED
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ord-prod
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 6
         WIDTH              = 87.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi-cc-refugo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-ccusto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-depos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-conta-debito-direto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-conta-refugo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dt-trans IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-nro-docto IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-quantidade-aprov-cond IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-quantidade-refugo IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-quantidade-reporte IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-serie-docto IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR RECTANGLE rt-mold IN FRAME f-main
   4                                                                    */
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

&Scoped-define SELF-NAME f-main
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-main V-table-Win
ON LEAVE OF FRAME f-main
DO:
  /*RUN pi-cria-tt-reservas-alocacoes.*/ 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cc-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-refugo V-table-Win
ON F5 OF fi-cc-refugo IN FRAME f-main
DO:
    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
        run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    
    if v_cod_ccusto <> "" then
                ASSIGN fi-cc-refugo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.
        
    if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-refugo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cc-refugo IN FRAME f-main
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto V-table-Win
ON F5 OF fi-ccusto IN FRAME f-main
DO:
    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
        run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    
    if v_cod_ccusto <> "" then
                ASSIGN fi-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.
        
    if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-ccusto IN FRAME f-main
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos V-table-Win
ON F5 OF fi-cod-depos IN FRAME f-main
DO:
   {include/zoomvar.i &prog-zoom = "inzoom/z01in084.w"
                     &campo     = fi-cod-depos
                     &campozoom = cod-depos   }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos V-table-Win
ON LEAVE OF fi-cod-depos IN FRAME f-main
DO:
    /* Chamada UPC solicitada pela Fras-le */
    RUN pi-upc (INPUT "Dep-sai-comp",
                INPUT "Dep-sai-comp",
                INPUT ?,
                INPUT ?,
                INPUT "ord-prod",
                INPUT ROWID(ord-prod)).
    RUN pi-cria-tt-reservas-alocacoes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-depos IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-localiz V-table-Win
ON F5 OF fi-cod-localiz IN FRAME f-main
DO:
   {include/zoomvar.i &prog-zoom = "inzoom/z01in189.w"
                      &campo     = fi-cod-localiz
                      &campozoom = cod-localiz   }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-localiz V-table-Win
ON LEAVE OF fi-cod-localiz IN FRAME f-main
DO:
   RUN pi-cria-tt-reservas-alocacoes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-localiz IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-conta-debito-direto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-debito-direto V-table-Win
ON ENTRY OF fi-conta-debito-direto IN FRAME f-main
DO:
  ASSIGN fi-conta-debito-direto:FORMAT IN FRAME {&frame-name} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-debito-direto V-table-Win
ON F5 OF fi-conta-debito-direto IN FRAME f-main
DO:
    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
	if v_cod_finalid = "" then do: assign v_cod_finalid = "(nenhum)". end.
	run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT "",
												  INPUT "CEP",
												  INPUT "",
												  INPUT v_cod_finalid,
												  INPUT TODAY,
												  OUTPUT v_cod_cta_ctbl,
												  OUTPUT v_des_cta_ctbl,
												  OUTPUT p-finalidade,
												  OUTPUT TABLE tt_log_erro).
    
    {cdp/cdunif001b.i1}

    IF v_cod_cta_ctbl <> "" THEN
		ASSIGN fi-conta-debito-direto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.
    
	if valid-handle(h_api_cta_ctbl) then
		delete object h_api_cta_ctbl.           
        
    apply 'leave':U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-debito-direto V-table-Win
ON LEAVE OF fi-conta-debito-direto IN FRAME f-main
DO:
    FIND FIRST param-global NO-LOCK NO-ERROR.

    assign i-empresa-prin = param-global.empresa-prin.
    &IF DEFINED (bf_mat_conta_estab) &THEN
        find first estabelec
             where estabelec.cod-estabel = ord-prod.cod-estabel no-lock no-error.
        if avail estabelec then
           run cdp/cd9970.p (input rowid(estabelec),
                             output i-empresa-prin).
    &ENDIF
      
    {cdp/cdunif001a.i fi-conta-debito-direto fi-ccusto {&FRAME-NAME} TODAY i-empresa-prin ord-prod.cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto wWindow
ON LEAVE OF fi-ccusto IN FRAME f-main
DO:
   {cdp/cdunif001d.i fi-ccusto {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-debito-direto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-conta-debito-direto IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-conta-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-refugo V-table-Win
ON ENTRY OF fi-conta-refugo IN FRAME f-main
DO:
  ASSIGN fi-conta-refugo:FORMAT IN FRAME {&frame-name} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-refugo V-table-Win
ON F5 OF fi-conta-refugo IN FRAME f-main
DO:
    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        if v_cod_finalid = "" then do: assign v_cod_finalid = "(nenhum)". end.
        run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT "",
                                                      INPUT "CEP",
                                                      INPUT "",
                                                      INPUT v_cod_finalid,
                                                      INPUT TODAY,
                                                      OUTPUT v_cod_cta_ctbl,
                                                      OUTPUT v_des_cta_ctbl,
                                                      OUTPUT p-finalidade,
                                                      OUTPUT TABLE tt_log_erro).
    
    IF v_cod_cta_ctbl <> "" THEN
		ASSIGN fi-conta-refugo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.

	if valid-handle(h_api_cta_ctbl) then
		delete object h_api_cta_ctbl.   
                
    apply 'leave':U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-refugo V-table-Win
ON LEAVE OF fi-conta-refugo IN FRAME f-main
DO:
    FIND FIRST param-global NO-LOCK NO-ERROR.

    assign i-empresa-prin = param-global.empresa-prin.
    &IF DEFINED (bf_mat_conta_estab) &THEN
        find first estabelec
             where estabelec.cod-estabel = ord-prod.cod-estabel no-lock no-error.
        if avail estabelec then
           run cdp/cd9970.p (input rowid(estabelec),
                             output i-empresa-prin).
    &ENDIF
      
    {cdp/cdunif001a.i fi-conta-refugo fi-cc-refugo {&FRAME-NAME} TODAY i-empresa-prin ord-prod.cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-refugo wWindow
ON LEAVE OF fi-cc-refugo IN FRAME f-main
DO:
   {cdp/cdunif001d.i fi-cc-refugo {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-refugo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-conta-refugo IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-dt-trans
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-dt-trans V-table-Win
ON LEAVE OF fi-dt-trans IN FRAME f-main
DO:
    /* Chamada UPC solicitada pela Fras-le */
    RUN pi-upc (INPUT "Data-Fabric",
                INPUT "Data-Fabric",
                INPUT ?,
                INPUT ?,
                INPUT "ord-prod",
                INPUT ROWID(ord-prod)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-quantidade-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-quantidade-refugo V-table-Win
ON LEAVE OF fi-quantidade-refugo IN FRAME f-main
DO:
   if input frame {&frame-name} fi-quantidade-refugo > 0 then do:
      FIND FIRST item-uni-estab no-lock 
           where item-uni-estab.it-codigo = ITEM.it-codigo  
           AND   item-uni-estab.cod-estabel = ord-prod.cod-estabel  no-error.  
        IF AVAIL item-uni-estab AND item-uni-estab.ind-refugo = 1 THEN
          assign fi-conta-refugo:sensitive in frame {&frame-name} = yes
    			 fi-conta-refugo:FORMAT IN FRAME {&frame-name} = "x(20)".
          
      if input fi-conta-refugo = "" then do:
         &IF DEFINED (bf_mat_conta_estab) &THEN         
             find first estab-mfg
                  where estab-mfg.cod-estab = ord-prod.cod-estabel no-lock no-error.
             if avail estab-mfg and
                estab-mfg.conta-refugo <> ? then
                assign fi-conta-refugo:screen-value in frame {&frame-name} = estab-mfg.ct-refugo
                       fi-cc-refugo:screen-value in frame {&frame-name}    = estab-mfg.sc-refugo
                        . 
             else
         &ENDIF
             assign fi-conta-refugo:screen-value in frame {&frame-name} = param-cp.ct-refugo
                    fi-cc-refugo:screen-value in frame {&frame-name}    = param-cp.sc-refugo
                    .
      end.
   end.             
   else
      assign  fi-conta-refugo:sensitive in frame {&frame-name}  = no
              fi-conta-refugo:screen-value                      = "" 
              fi-cc-refugo:sensitive in frame {&frame-name}     = no
              fi-cc-refugo:screen-value                         = "" 
              .   

        
        apply "leave":U to fi-conta-refugo in frame {&frame-name}.

    RUN pi-upc (INPUT "Leave-qtde-refugo",
                INPUT "Leave-qtde-refugo",
                INPUT ?,
                INPUT ?,
                INPUT "ord-prod",
                INPUT ROWID(ord-prod)).     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-quantidade-reporte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-quantidade-reporte V-table-Win
ON LEAVE OF fi-quantidade-reporte IN FRAME f-main
DO:
   RUN pi-cria-tt-reservas-alocacoes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-serie-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-serie-docto V-table-Win
ON LEAVE OF fi-serie-docto IN FRAME f-main
DO:
   if can-find(first movto-estoq use-index documento where 
                     movto-estoq.serie     = input frame {&frame-name} fi-serie-docto and
                     movto-estoq.nro-docto = input frame {&frame-name} fi-nro-docto)
   then 
      run utp/ut-msgs.p (input "show",
                         input 2628  ,
                         input ""    ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  

if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

EMPTY TEMP-TABLE tt_log_erro.
run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (INPUT "",
                                                  INPUT "",
                                                  INPUT TODAY,
                                                  OUTPUT p_cod_format_cta_ctbl,
                                                  OUTPUT TABLE tt_log_erro).
if valid-handle(h_api_cta_ctbl) then
        delete object h_api_cta_ctbl.   

  /************************ INTERNAL PROCEDURES ********************/

{utp/ut-liter.i Dep¢s._Sa°da MCP L}
assign fi-cod-depos:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Localiz._Sa°da_ MCP L}
assign fi-cod-localiz:label in frame {&frame-name} = return-value. 

{utp/ut-liter.i Data_Fabricaá∆o MCP L}
assign fi-dt-trans:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Quantidade_Reportada MCP L}
assign fi-quantidade-reporte:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Quantidade_Refugada MCP L}
assign fi-quantidade-refugo:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Conta_Refugo MCP L}
assign fi-conta-refugo:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Quant_Aprov_Cond MCP L}
assign fi-quantidade-aprov-cond:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind movto-estoq nro-docto 1}
assign fi-nro-docto:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind movto-estoq serie-docto 1}
assign fi-serie-docto:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind rep-prod conta-aplicacao 1}
assign fi-conta-debito-direto:label in frame {&frame-name} = return-value.

if fi-cod-depos:load-mouse-pointer("image/lupa.cur")           then.
if fi-cod-localiz:load-mouse-pointer("image/lupa.cur")         then.
if fi-conta-debito-direto:load-mouse-pointer("image/lupa.cur") then.
if fi-conta-refugo:load-mouse-pointer("image/lupa.cur")        then.
if fi-ccusto:load-mouse-pointer("image/lupa.cur")              then.
if fi-cc-refugo:load-mouse-pointer("image/lupa.cur")           then.

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
  {src/adm/template/row-list.i "ord-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-prod"}

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
  {include/i-valid.i}


  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */

  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) . */

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
  if valid-handle(h_api_ccusto) THEN
      delete object h_api_ccusto.   

  if valid-handle(h_api_cta_ctbl) then
      delete object h_api_cta_ctbl.   

  IF VALID-HANDLE(h-cpapi029) THEN
      DELETE PROCEDURE h-cpapi029.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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
/*  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
 * */

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

  /* O run dispatch foi comentado para que nao jogue "lixo" na tela
     apos a execucao da disable-fields da viewer principal       */  

  {include/i-epc006.i}   

  /* Dispatch standard ADM method.                             */
  /*  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  * */

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes: A local-enable-fields vai ser acionada somente no leav      
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').
  {include/i-epc004.i}
  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif   */

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

  /* Code placed here will execute AFTER standard behavior.    */
  find first param-global no-lock no-error.
  if param-global.modulo-ce then do:
    find first param-estoq no-lock no-error.
    find first param-cq    no-lock no-error.
  end.
  find first param-cp no-lock no-error.    

 &IF DEFINED (bf_man_204) &THEN
   ASSIGN i-fnc-pf = can-find (first funcao 
                                 where funcao.cd-funcao = "spp-dep-refugo" 
                                   and funcao.ativo     = yes). 
 &endif
 
 IF NOT VALID-HANDLE(h-cpapi029) THEN
     RUN cpp/cpapi029.p PERSISTENT SET h-cpapi029.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-apply-entry V-table-Win 
PROCEDURE pi-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    def var c-tipo       as char init "Fill-in,Radio-set,Combo-box,Editor,Selection-List,Toggle-box,Slider".
    def var wh-frame     as handle  no-undo.
    def var wh-container as handle  no-undo.
    def var i-pag-viewer as integer no-undo.
    def var i-pag-atual  as integer no-undo.
    def var c-campo      as char    no-undo.

    RUN get-link-handle IN adm-broker-hdl
       (INPUT  this-procedure,
        INPUT  "record-source",
        OUTPUT c-handle).

    assign wh-handle-viewer-principal = widget-handle (c-handle).
    run get-attribute in wh-handle-viewer-principal (input "campo" ).    
    assign c-campo = return-value.

    RUN get-attribute ("W-Page").
    assign i-pag-viewer = int(return-value).
    RUN get-attribute ("W-Container-Source").
    assign wh-container = widget-handle (return-value).
    RUN get-attribute in wh-container ("current-page").
    assign i-pag-atual = int(return-value)
           wh-frame = frame {&frame-name}:handle
           wh-frame = wh-frame:first-child
           wh-frame = wh-frame:first-child.

    do while wh-frame <> ? :
       if lookup(wh-frame:Type, c-tipo) <> 0 and
          lookup(wh-frame:name, c-campo) <> 0 then do:
          if i-pag-atual <> i-pag-viewer then
             run select-page in wh-container (string (i-pag-viewer)).
          apply 'entry' to wh-frame.
          leave.
       end.
       assign wh-frame = wh-frame:next-sibling.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-item V-table-Win 
PROCEDURE pi-atualiza-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT "it-codigo").

  find item where item.it-codigo = return-value no-lock no-error.
  assign rw-item-pai = rowid(item) .   

  RUN get-link-handle IN adm-broker-hdl
    (INPUT  this-procedure,
     INPUT  "record-source",
     OUTPUT c-handle).

  assign wh-handle-viewer-principal = widget-handle (c-handle)
         l-requisita-configurado = no.

  def var l-log-reserva-config as log INIT NO no-undo.  

  /*Verifica parametro Gera Reserva Configurado*/
  &if defined(bf_man_206b) &then
      assign l-log-reserva-config = param-cp.log-reserva-config.
  &elseif  defined(bf_man_204) &then      
      assign l-log-reserva-config = if substring(param-cp.char-2,12,1) = "2":U then yes else no.        
  &endif 

  if  NOT(l-log-reserva-config) AND
     ((ord-prod.it-codigo = "" or ord-prod.it-codigo = ?  or
      item.tipo-contr    = 2  or item.tipo-contr    = 4)) then do:

     /*--------------------------------------------------------------
       Procura se a ordem possui requisicao automatica para alguma 
       ordem de destino, e procura esta ordem.
     --------------------------------------------------------------*/
     find first al-res-op where
                al-res-op.nr-ord-produ = ord-prod.nr-ord-produ
                exclusive-lock no-error.
     if avail al-res-op then 
        assign l-requisita-configurado = yes.
     else
        assign l-requisita-configurado = no.

     /*---------------------------------------------------------------
       O al-res-op existe se a ordem foi gerada para um item que foi 
       configurado no modulo configurador ou desenvolvedor 
       (ord-prod.nr-estrutura <> 0). 
       O al-res-op possui a ordem pai e as suas respecitivas ordens
       filhas que serao requisitadas automaticamente para a ordem pai.

       No ord-prod.item-cotacao e' armazenado o pai do item da ordem,
       ou seja, se este estiver em branco e  a ordem foi gerada pelo
       desenvolvedor ou pedidos entao este item da ordem e' nivel 0 
       (acabado final).
     ----------------------------------------------------------------*/

     if  not avail al-res-op         
     and ord-prod.nr-estrut    <> 0  
     and ord-prod.item-cotacao <> "" then do:
        /* A requisicao deste item devera ser feita manualmente para a 
           ordem de destino. Confirma ?                             */                 
        run utp/ut-msgs.p (input "show",
                           input 7401  ,
                           input ""    ).
        if return-value eq "no" then do :
           run dispatch in wh-handle-viewer-principal ("cancel-record").        
        end.
        assign l-requisita-configurado = no.
     end.  

     if avail al-res-op then do:
        find first b-ord-prod no-lock
            where b-ord-prod.nr-ord-produ = al-res-op.nr-ord-res no-error.
        /* Caso a ordem de destino esteja finalizada ou terminada ou
        o estabelecimento da ordem origem e destino forem diferentes 
        a requisicao nao sera efetuada                            */
        if (b-ord-prod.cod-estabel <> ord-prod.cod-estabel) 
        or (b-ord-prod.estado       = 8 
        or  b-ord-prod.estado       = 7) then do:
           if b-ord-prod.estado = 8 
           or b-ord-prod.estado = 7 then do :
              /* Ordem de destino Terminada ou Finalizada. 
              A requisicao automatica nao sera realizada. Continuar ? */
              run utp/ut-msgs.p (input "show",
                                 input 7403  ,
                                 input ""    ).
              if return-value eq "no" then do:
                 run dispath in wh-handle-viewer-principal ("cancel-record"). 
              end.
              assign l-requisita-configurado = no.                          
           end.   
           else do :
              /* O estabelecimento da ordem de destino e origem sao diferentes.
              A requisicao automatica nao sera realizada. Continuar ?     */           
              run utp/ut-msgs.p (input "show",
                                 input 7404  ,
                                 input ""    ).
              if return-value eq "no" then do:
                 run dispath in wh-handle-viewer-principal ("cancel-record"). 
              end.    
              assign l-requisita-configurado = no.
           end.   
        end.
     end.
  end.
  
  assign fi-conta-debito-direto:format in frame {&FRAME-NAME} = "x(20)".
  assign fi-ccusto:format in frame {&FRAME-NAME} = "x(20)".

  if l-requisita-configurado AND ITEM.tipo-contr <> 4  then do: 
     find first al-res-op no-lock
          where al-res-op.nr-ord-prod = ord-prod.nr-ord-prod no-error.
     if avail(al-res-op) then do:
        find b-ord-prod no-lock
            where b-ord-prod.nr-ord-prod = al-res-op.nr-ord-res no-error.
        if avail(b-ord-prod) then do:             
           assign fi-conta-debito-direto:screen-value in frame {&frame-name} = b-ord-prod.ct-codigo
                  fi-ccusto             :SCREEN-VALUE IN FRAME {&FRAME-NAME} = b-ord-prod.sc-codigo
                  fi-conta-debito-direto:sensitive in frame {&frame-name}    = NO
                  fi-ccusto             :SENSITIVE IN FRAME {&FRAME-NAME}    = NO.                     
        end.      
     end.
  end.
  else do:            
     IF  item.it-codigo  = ""
     OR  item.tipo-contr = 3
     OR  item.tipo-contr = 4       
     OR  item.tipo-contr = 1
     AND param-global.modulo-ce = YES THEN DO:

        IF ITEM.ct-codigo = "" THEN DO:
            ASSIGN c-conta  = param-cp.cod-cta-unif
                   c-ccusto = param-cp.cod-ccusto-unif.               
        END.
        ELSE DO:
           ASSIGN c-conta  = ITEM.ct-codigo
                  c-ccusto = ITEM.sc-codigo.
        END.

        IF fi-dt-trans:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           ASSIGN fi-conta-debito-direto:SENSITIVE IN FRAME {&FRAME-NAME}   = TRUE
                  fi-conta-debito-direto:SCREEN-VALUE                       = ""
                  fi-ccusto:SENSITIVE IN FRAME {&FRAME-NAME}                = TRUE
                  fi-ccusto:SCREEN-VALUE                                    = ""
                  fi-quantidade-refugo:SENSITIVE IN FRAME {&FRAME-NAME}     = FALSE
                  fi-quantidade-refugo                                      = 0
                  fi-quantidade-refugo:SCREEN-VALUE                         = ""
                  fi-quantidade-aprov-cond:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
                  fi-quantidade-aprov-cond                                  = 0
                  fi-quantidade-aprov-cond:SCREEN-VALUE                     = ""
                  fi-conta-refugo                                           = ""
                  fi-conta-refugo:SENSITIVE IN FRAME {&FRAME-NAME}          = FALSE
                  fi-cc-refugo                                              = ""
                  fi-cc-refugo:SENSITIVE IN FRAME {&FRAME-NAME}             = FALSE
                  fi-conta-refugo:SCREEN-VALUE                              = ""
                  fi-conta-debito-direto:SCREEN-VALUE                       = IF fi-conta-debito-direto:SCREEN-VALUE = "" 
                                                                                 THEN c-conta
                                                                                 ELSE fi-conta-debito-direto:SCREEN-VALUE
                  fi-ccusto:SCREEN-VALUE                                    = IF fi-ccusto:SCREEN-VALUE = ""
                                                                                 THEN c-ccusto
                                                                                 ELSE fi-ccusto. 

            APPLY 'leave':u TO fi-conta-debito-direto.

        END.


     END.
     ELSE DO: 
        ASSIGN fi-conta-debito-direto:SENSITIVE IN FRAME {&FRAME-NAME}    = FALSE
               fi-conta-debito-direto:SCREEN-VALUE                        = ""           
               fi-ccusto:SENSITIVE IN FRAME {&FRAME-NAME}                 = FALSE
               fi-ccusto:SCREEN-VALUE                                     = ""
               fi-quantidade-refugo:SENSITIVE                             = l-ultima
               fi-quantidade-aprov-cond:SENSITIVE                         = l-ultima          AND
                                                                            item.contr-qualid AND
                                                                            param-global.modulo-cq.
     END.
  END.
  IF  item.tipo-contr      <> 2 
  AND ord-prod.num-ord-inv <> 0 
  AND ord-prod.origem       = 'IN' THEN DO:
    FIND FIRST param-inv NO-LOCK NO-ERROR.
    IF param-inv.log-1 = YES THEN
       ASSIGN fi-conta-debito-direto:SENSITIVE IN FRAME {&FRAME-NAME} = YES
              fi-ccusto:SENSITIVE IN FRAME {&FRAME-NAME}              = YES.
    ELSE
       ASSIGN fi-conta-debito-direto:SENSITIVE IN FRAME {&FRAME-NAME} = NO
              fi-ccusto:SENSITIVE IN FRAME {&FRAME-NAME}              = NO.
  end.           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parametros V-table-Win 
PROCEDURE pi-atualiza-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-baixa-reservas        as int    no-undo.
    def input parameter p-informa-deposito      as log    no-undo init yes.
    def input parameter p-informa-localizacao   as log    no-undo.
    def input parameter p-requisicao-automatica as log    no-undo.
    def input parameter p-busca-saldos          as log    no-undo.

    assign i-baixa-reservas        = p-baixa-reservas
           l-informa-deposito      = p-informa-deposito
           l-informa-localizacao   = p-informa-localizacao
           l-requisicao-automatica = p-requisicao-automatica
           l-busca-saldos          = p-busca-saldos.         

    if not param-cp.dep-fab-unico and 
       l-informa-deposito and 
       fi-dt-trans:sensitive in frame {&frame-name} then
       assign fi-cod-depos:sensitive in frame {&frame-name}     = yes
              fi-cod-depos.
    else 
        assign fi-cod-depos:sensitive in frame {&frame-name}    = no
               fi-cod-depos                                     = "".         

    &IF DEFINED (bf_man_linha_estab) &THEN
    find lin-prod
         where lin-prod.cod-estabel = ord-prod.cod-estabel
           and lin-prod.nr-linha    = ord-prod.nr-linha no-lock no-error.     
    &ELSE
    find lin-prod where 
         lin-prod.nr-linha    = ord-prod.nr-linha no-lock no-error.    
    &ENDIF
    if /* lin-prod.sum-requis = 1 and  */
       l-informa-localizacao and 
       fi-dt-trans:sensitive in frame {&frame-name} then     
       assign fi-cod-localiz:sensitive in frame {&frame-name}     = yes.
    else 
        assign fi-cod-localiz:sensitive in frame {&frame-name}    = no
               fi-cod-localiz                                     = "".              

    display fi-cod-depos
            fi-cod-localiz
            with frame {&frame-name}.

    assign l-carrega-browse = yes.
    RUN pi-cria-tt-reservas-alocacoes.          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-reservas-alocacoes V-table-Win 
PROCEDURE pi-cria-tt-reservas-alocacoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/  
  if ( ( fi-quantidade-reporte <> input frame {&frame-name} fi-quantidade-reporte or
         fi-cod-depos          <> input frame {&frame-name} fi-cod-depos          or
         fi-cod-localiz        <> input frame {&frame-name} fi-cod-localiz        or 
         l-carrega-browse                                     ) and       
       ( fi-dt-trans:sensitive                                ) and 
       ( input frame {&frame-name} fi-quantidade-reporte > 0) ) and
       not l-busca-saldos then do: 

     RUN set-cursor IN adm-broker-hdl (INPUT "WAIT").                               

     assign l-carrega-browse = no
            fi-quantidade-reporte
            fi-cod-depos
            fi-cod-localiz.

     for each tt-rep-prod:
         delete tt-rep-prod.
     end.

     create tt-rep-prod.
     assign tt-rep-prod.nr-ord-prod    = ord-prod.nr-ord-prod
            tt-rep-prod.reserva        = yes
            tt-rep-prod.tipo           = 1
            tt-rep-prod.op-codigo      = oper-ord.op-codigo when avail oper-ord
            tt-rep-prod.cod-roteiro    = oper-ord.cod-roteiro when avail oper-ord
            tt-rep-prod.it-oper        = oper-ord.it-codigo when avail oper-ord
            tt-rep-prod.qt-reporte     = fi-quantidade-reporte
            tt-rep-prod.cod-depos-sai  = if fi-cod-depos:sensitive in frame {&frame-name} then
                                            fi-cod-depos
                                         else ?
            tt-rep-prod.cod-local-sai  = if fi-cod-localiz:sensitive in frame {&frame-name} then
                                            fi-cod-localiz
                                         else ?
            tt-rep-prod.baixa-reservas = i-baixa-reservas.

     run pi-recebe-tt-rep-prod in h-handle (input table tt-rep-prod).       

     /* Carrega as temp-tables de reservas e alocaá‰es */                

     if fi-quantidade-reporte > 0 then do:
        RUN Who-Is-The-Container IN adm-broker-hdl
           (INPUT this-procedure,
            OUTPUT c-handle).
        run get-attribute in widget-handle (c-handle) (input "tipo-reporte").
        if int (return-value) = 1 then
           run cpp/cp0311b.p (input h-handle        ,
                              input rowid (ord-prod)).
        else do:
             run pi-carrega-tt-reservas in h-handle (input yes,
                                                     input int (return-value),
                                                     input rowid (oper-ord)).
        end.
     end.
     else do:
          for each tt-reservas:
              delete tt-reservas.
          end.

          for each tt-aloca:
              delete tt-aloca.
          end.

          run pi-recebe-tt-reservas in h-handle (input table tt-reservas).
          run pi-recebe-tt-aloca    in h-handle (input table tt-aloca).
     end.

     run notify ('pi-recebe-tt-res-aloc,group-assign-target').                             

     RUN set-cursor IN adm-broker-hdl (INPUT "").

     &IF DEFINED(bf_man_205) &THEN
         /*Re-habilita o bot∆o Balanceia caso o usu†rio tenha alterado campos que faáam
           com que as reservas sejam recalculadas.*/
         IF VALID-HANDLE(h-handle-pai) THEN
             RUN pi-local-enable IN h-handle-pai NO-ERROR.
     &ENDIF
  end.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita-campos V-table-Win 
PROCEDURE pi-desabilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   clear frame {&frame-name}.
   disable all with frame {&frame-name}.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-tt-reservas-alocacoes V-table-Win 
PROCEDURE pi-elimina-tt-reservas-alocacoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
for each tt-reservas:
    delete tt-reservas.
end.

for each tt-aloca:
    delete tt-aloca.
end.

run pi-recebe-tt-reservas in h-handle (input table tt-reservas).
run pi-recebe-tt-aloca    in h-handle (input table tt-aloca).
run notify ('pi-recebe-tt-res-aloc,group-assign-target'). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-entry-qtd V-table-Win 
PROCEDURE pi-entry-qtd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                                                                                
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-arquivos V-table-Win 
PROCEDURE pi-grava-arquivos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Chamada EPC para a assign record */
   {include/i-epc003.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos V-table-Win 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Chamada na local-enable-fields da viewer principal.
------------------------------------------------------------------------------*/

  find item no-lock where item.it-codigo = ord-prod.it-codigo no-error.   

  &IF DEFINED (bf_man_linha_estab) &THEN
  find lin-prod no-lock
       where lin-prod.cod-estabel = ord-prod.cod-estabel
         and lin-prod.nr-linha    = ord-prod.nr-linha no-error.     
  &ELSE
  find lin-prod no-lock where lin-prod.nr-linha = ord-prod.nr-linha no-error.  
  &ENDIF


  RUN pi-execute IN h-cpapi029 (INPUT 1,
                                INPUT ord-prod.cod-estabel,
                                INPUT ord-prod.nr-linha,
                                output c-dep-fabrica  ,
                                output d-var-rep      ,   
                                output d-var-req-menor,  
                                output d-var-requis   ,  
                                output d-var-transf   ,
                                output table tt-erro append).

  enable all with frame {&frame-name}.
  clear frame {&frame-name}.

  RUN get-link-handle IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT "record-source",
      OUTPUT c-handle).

  run get-attribute in widget-handle (c-handle) (input "rw-oper").

  find oper-ord where
       rowid (oper-ord) = to-rowid (return-value) no-lock no-error.    

  run get-attribute in widget-handle (c-handle) (input "quant-reporte").
  assign c-quant-reporte = return-value.       

  RUN Who-Is-The-Container IN adm-broker-hdl
     (INPUT this-procedure,
      OUTPUT c-handle).
  run get-attribute in widget-handle (c-handle) (input "tipo-reporte").
  if int (return-value) = 1 then
     assign l-ultima = yes.
  else
      assign l-ultima = (rowid (oper-ord) = f-retorna-ult-oper (ord-prod.nr-ord-prod)).

  if item.tipo-con-est = 2 
  then 
     assign fi-quantidade-reporte = 1
            fi-quantidade-reporte:sensitive in frame {&frame-name} = no.
  else
     assign fi-quantidade-reporte:sensitive in frame {&frame-name} = yes
            fi-quantidade-reporte = if int (return-value) = 1 then
                                      (if ord-prod.qt-ordem > ord-prod.qt-produzida 
                                          then ord-prod.qt-ordem - ord-prod.qt-produzida
                                       else 0)
                                    else dec (c-quant-reporte) / 10000.            

  assign fi-dt-trans                      = today                       
         fi-nro-docto                     = string (ord-prod.nr-ord-prod).

  if not param-cp.dep-fab-unico and l-informa-deposito then 
     assign fi-cod-depos:sensitive in frame {&frame-name} = yes
            fi-cod-depos                                  = c-dep-fabrica.
  else
      assign fi-cod-depos:sensitive in frame {&frame-name} = no
             fi-cod-depos                                  = "".

  if l-informa-localizacao then do:  
     assign fi-cod-localiz:sensitive in frame {&frame-name} = yes.
  end.
  else
      assign fi-cod-localiz:sensitive in frame {&frame-name} = no.                          

  display fi-cod-depos 
          fi-cod-localiz 
          fi-conta-refugo 
          fi-dt-trans 
          fi-nro-docto 
          fi-quantidade-aprov-cond 
          fi-quantidade-refugo 
          fi-quantidade-reporte
          with frame {&frame-name}.

  assign fi-conta-refugo:sensitive   = no
             fi-cc-refugo:sensitive      = no.

  run pi-atualiza-item.        

  run pi-recria-temp-tables.

  /* Se os arquivos temporarios de reservas e alocacoes nao foram preenchidos 
     vai "limpar" os browsers                                              */
  if l-carrega-browse = yes then do: 
     for each tt-reservas :
        delete tt-reservas.
     end.              
     for each tt-aloca :
        delete tt-aloca.
     end.

     run notify ('pi-recebe-tt-res-aloc,group-assign-target'). 
  end.  

    if fi-cod-depos:sensitive in frame {&frame-name} THEN DO:
      apply 'entry' to fi-cod-depos in frame {&frame-name}.
    END.
    ELSE DO:
      IF fi-cod-localiz:sensitive in frame {&frame-name} THEN DO:
        apply 'entry' to fi-cod-localiz in frame {&frame-name}.
      END.
      ELSE DO:  
        apply 'entry' to fi-quantidade-reporte in frame {&frame-name}.
      END.
    END.

    /* Chamada UPC solicitada pela ACO */
    RUN pi-upc (INPUT "Fim-habilita-campos",
                INPUT "Fim-habilita-campos",
                INPUT ?,
                INPUT ?,
                INPUT "ord-prod",
                INPUT ROWID(ord-prod)).                       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT  this-procedure,
     OUTPUT c-handle).

run get-attribute in widget-handle (c-handle) (input 'HANDLE').

assign h-handle = widget-handle (return-value).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recria-temp-tables V-table-Win 
PROCEDURE pi-recria-temp-tables :
/*------------------------------------------------------------------------------
  Purpose: Recriar as temp-tables de reservas e alocacoes devido as novas informacoes
  incluidas pelo usuario.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  assign l-carrega-browse = yes.
  run pi-cria-tt-reservas-alocacoes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-handle-pai V-table-Win 
PROCEDURE pi-seta-handle-pai :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-handle-pai AS HANDLE NO-UNDO.

ASSIGN h-handle-pai = p-handle-pai.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-upc V-table-Win 
PROCEDURE pi-upc :
/**********************************************************************
** UPC Especifica
** Podem ser passados parametros para ela afim de reutilizar o codigo
** se houver necessidade.
**********************************************************************/ 
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

    ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:FILE-NAME.    

    /* DPC */
    if  c-nom-prog-dpc-mg97 <> ""
    and c-nom-prog-dpc-mg97 <> ? then do:

        run value(c-nom-prog-dpc-mg97) (input p-ind-event,
                                        input p-ind-object,
                                        input THIS-PROCEDURE,
                                        input FRAME f-main:HANDLE,
                                        input p-cod-table,
                                        input p-row-table).

    end.

    /* APPC */
    if  c-nom-prog-appc-mg97 <> ""
    and c-nom-prog-appc-mg97 <> ? then do:

        run value(c-nom-prog-appc-mg97) (input p-ind-event,
                                         input p-ind-object,
                                         input THIS-PROCEDURE,
                                         input FRAME f-main:HANDLE,
                                         input p-cod-table,
                                         input p-row-table).

    end.

    /* UPC */
    if  c-nom-prog-upc-mg97 <> ""
    and c-nom-prog-upc-mg97 <> ? then do:
        run value(c-nom-prog-upc-mg97) (input p-ind-event,
                                        input p-ind-object,
                                        input THIS-PROCEDURE,
                                        input FRAME f-main:HANDLE,
                                        input p-cod-table,
                                        input p-row-table).
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

  /* Chamada EPC para a pi-validate */
     {include/i-epc002.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaQtdReporte V-table-Win 
PROCEDURE retornaQtdReporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM p-qt-reporte AS DEC NO-UNDO.

ASSIGN p-qt-reporte = INPUT FRAME f-main fi-quantidade-reporte.

RETURN "OK":U.
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
  {src/adm/template/snd-list.i "ord-prod"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-campo V-table-Win 
PROCEDURE pi-retorna-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter c-campo as char.
def output parameter c-valor-campo as char.

case c-campo:
    when "fi-conta-debito-direto":u then 
		assign c-valor-campo = input frame {&frame-name} fi-conta-debito-direto.
    when "fi-conta-refugo":u then 
		assign c-valor-campo = input frame {&frame-name} fi-conta-refugo.
    when "fi-cc-refugo":u then 
		assign c-valor-campo = input frame {&frame-name} fi-cc-refugo.
    when "fi-ccusto-dd":u then 
		assign c-valor-campo = input frame {&frame-name} fi-ccusto.
end.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
