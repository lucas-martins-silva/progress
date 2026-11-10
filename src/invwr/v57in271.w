&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
{include/i-prgvrs.i V57IN271 2.00.00.007 } /*** "010007" 19/06/2024 15:51:45 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v57in271 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

&Scop adm-attribute-dlg support/viewerd.w

{include/i-vrtab.i oper-ord}
{include/i-vrtab.i ord-prod}

{cdp/cdcfgman.i} /** Release 2.02 **/
{cdp/cdcfgmat.i} /** bf_mat_conta_estab **/

{sfc/sf0303a.i}   /*** Temp-table tt-reporte  ***/
{cpp/cpapi001.i}  /*** Temp-table tt-rep-prod ***/
{cpp/cpapi001.i1} /*** Temp-table tt-reservas ***/
{cdp/cd0666.i}    /* definiªío da tt-erro            */
{cpp/cpapi020.i}  /*** tt-balanceia  ***/
{cpp/cpapi020.i1} /* Funá‰es Fator de Concentraá∆o */

{cpp/cpapi029.i}
/** UnificaÁ„o de Conceitos **/
{cdp/cdunif001.i}
{cdp/cdunif001.i1}

def buffer b-oper-ord for oper-ord.
def buffer b-ord-prod for ord-prod.

def var c-handle         as char   no-undo.
def var h-handle         as handle no-undo.
def var h-aloca          as handle no-undo.
def var h-reserva        as handle no-undo.
def var h-reciclado      as handle no-undo.
def var l-carrega-browse as log    no-undo.
def var v-row-parent     as rowid  no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def var i-empresa-prin  LIKE empresa.ep-codigo no-undo.
&ELSE
def var i-empresa-prin  as integer no-undo.
&ENDIF

def var c-cod-estabel    like ord-prod.cod-estabel no-undo.
DEFINE VARIABLE l-unid-negoc AS LOGICAL  INIT NO  NO-UNDO.
DEFINE VARIABLE h-cdapi024   AS HANDLE     NO-UNDO.
DEFINE VARIABLE l-contr-qualid AS LOGICAL    NO-UNDO.

{cdp/cd9203.i}     /* Function f-item-uni-estab        */

DEFINE VARIABLE h-handle-pai AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-ccusto-dd fi-cc-refugo RECT-3 rt-key 
&Scoped-Define DISPLAYED-OBJECTS c-cod-depos c-cod-localiz c-ct-debito ~
fi-ccusto-dd c-ct-refugo fi-cc-refugo c-dep-refugo c-loc-refugo c-dep-acab ~
c-loc-acab c-refer-acab c-lote-acab dt-valid-lote fi-per-ppm 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS c-dep-refugo c-loc-refugo c-dep-acab ~
c-refer-acab c-lote-acab dt-valid-lote 
&Scoped-define List-4 c-dep-acab c-loc-acab c-lote-acab 

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
DEFINE VARIABLE c-cod-depos AS CHARACTER FORMAT "x(3)" 
     LABEL "Dep¢s. Sa°da":R12 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-localiz AS CHARACTER FORMAT "x(20)" 
     LABEL "Localiz. Sa°da":R14 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-ct-debito AS CHARACTER FORMAT "X(17)":U 
     LABEL "Conta DÇbito Direto" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-ct-refugo AS CHARACTER FORMAT "x(17)" 
     LABEL "Conta Refugo":R17 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-dep-acab AS CHARACTER FORMAT "X(3)":U 
     LABEL "Dep¢sito" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-dep-refugo AS CHARACTER FORMAT "X(3)":U 
     LABEL "Dep¢sito Refugo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-loc-acab AS CHARACTER FORMAT "X(20)":U 
     LABEL "Localizaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 23.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-loc-refugo AS CHARACTER FORMAT "X(20)":U 
     LABEL "Localiz. Refugo" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-lote-acab AS CHARACTER FORMAT "X(40)":U 
     LABEL "Lote SÇrie" 
     VIEW-AS FILL-IN 
     SIZE 23.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-refer-acab AS CHARACTER FORMAT "X(8)":U 
     LABEL "Referància" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE dt-valid-lote AS DATE FORMAT "99/99/9999":U 
     LABEL "Validade Lote" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cc-refugo AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ccusto-dd AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-per-ppm AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "PPM" 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35.72 BY 6.54.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50.57 BY 6.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-cod-depos AT ROW 1.5 COL 14.29 COLON-ALIGNED
     c-cod-localiz AT ROW 2.5 COL 14.29 COLON-ALIGNED HELP
          "C¢digo de Localizaá∆o do Material"
     c-ct-debito AT ROW 3.5 COL 14.29 COLON-ALIGNED
     fi-ccusto-dd AT ROW 3.5 COL 31.72 COLON-ALIGNED NO-LABEL
     c-ct-refugo AT ROW 4.5 COL 14.29 COLON-ALIGNED
     fi-cc-refugo AT ROW 4.5 COL 31.72 COLON-ALIGNED NO-LABEL
     c-dep-refugo AT ROW 5.5 COL 14.29 COLON-ALIGNED
     c-loc-refugo AT ROW 6.5 COL 14.29 COLON-ALIGNED
     c-dep-acab AT ROW 1.5 COL 61.29 COLON-ALIGNED
     c-loc-acab AT ROW 2.5 COL 61.29 COLON-ALIGNED
     c-refer-acab AT ROW 3.5 COL 61.29 COLON-ALIGNED
     c-lote-acab AT ROW 4.5 COL 61.29 COLON-ALIGNED
     dt-valid-lote AT ROW 5.5 COL 61.29 COLON-ALIGNED
     fi-per-ppm AT ROW 6.5 COL 61.29 COLON-ALIGNED
     RECT-3 AT ROW 1.08 COL 52.29
     rt-key AT ROW 1.08 COL 1.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 6.75
         WIDTH              = 87.72.
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

/* SETTINGS FOR FILL-IN c-cod-depos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ct-debito IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ct-refugo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-dep-acab IN FRAME f-main
   NO-ENABLE 3 4                                                        */
/* SETTINGS FOR FILL-IN c-dep-refugo IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-loc-acab IN FRAME f-main
   NO-ENABLE 4                                                          */
/* SETTINGS FOR FILL-IN c-loc-refugo IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-lote-acab IN FRAME f-main
   NO-ENABLE 3 4                                                        */
/* SETTINGS FOR FILL-IN c-refer-acab IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN dt-valid-lote IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-per-ppm IN FRAME f-main
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

&Scoped-define SELF-NAME c-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos V-table-Win
ON F5 OF c-cod-depos IN FRAME f-main /* Dep¢s. Sa°da */
DO:
   {include/zoomvar.i &prog-zoom = "inzoom/z01in084.w"
                      &campo     = c-cod-depos
                      &campozoom = cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos V-table-Win
ON LEAVE OF c-cod-depos IN FRAME f-main /* Dep¢s. Sa°da */
DO:
  RUN pi-cria-tt-reservas-alocacoes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-depos IN FRAME f-main /* Dep¢s. Sa°da */
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-localiz V-table-Win
ON F5 OF c-cod-localiz IN FRAME f-main /* Localiz. Sa°da */
DO:
   {include/zoomvar.i &prog-zoom = "inzoom/z01in189.w"
                      &campo     = c-cod-localiz
                      &campozoom = cod-localiz}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-localiz V-table-Win
ON LEAVE OF c-cod-localiz IN FRAME f-main /* Localiz. Sa°da */
DO:
   RUN pi-cria-tt-reservas-alocacoes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-localiz IN FRAME f-main /* Localiz. Sa°da */
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ct-debito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-debito V-table-Win
ON F5 OF c-ct-debito IN FRAME f-main /* Conta DÇbito Direto */
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
                ASSIGN c-ct-debito:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.

        if valid-handle(h_api_cta_ctbl) then
                delete object h_api_cta_ctbl.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-debito V-table-Win
ON LEAVE OF c-ct-debito IN FRAME f-main /* Conta DÇbito Direto */
DO:
  {cdp/cdunif001a.i c-ct-debito fi-ccusto-dd {&FRAME-NAME} TODAY """" c-cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-debito V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-ct-debito IN FRAME f-main /* Conta DÇbito Direto */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ct-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-refugo V-table-Win
ON F5 OF c-ct-refugo IN FRAME f-main /* Conta Refugo */
DO:
    assign i-empresa-prin = param-global.empresa-prin.
    &IF DEFINED (bf_mat_conta_estab) &THEN
        find first estabelec
             where estabelec.cod-estabel = c-cod-estabel no-lock no-error.
        if avail estabelec then
           run cdp/cd9970.p (input rowid(estabelec),
                             output i-empresa-prin).
    &ENDIF
    assign i-ep-codigo-usuario = i-empresa-prin.

        
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
                ASSIGN c-ct-refugo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.
        
        if valid-handle(h_api_cta_ctbl) then
                delete object h_api_cta_ctbl.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-refugo V-table-Win
ON LEAVE OF c-ct-refugo IN FRAME f-main /* Conta Refugo */
DO:
  {cdp/cdunif001a.i c-ct-refugo fi-cc-refugo {&FRAME-NAME} TODAY """" c-cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-refugo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-ct-refugo IN FRAME f-main /* Conta Refugo */
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-dep-acab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-dep-acab V-table-Win
ON F5 OF c-dep-acab IN FRAME f-main /* Dep¢sito */
DO:
   {include/zoomvar.i &prog-zoom = "inzoom/z01in084.w"
                      &campo     = c-dep-acab
                      &campozoom = cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-dep-acab V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-dep-acab IN FRAME f-main /* Dep¢sito */
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-dep-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-dep-refugo V-table-Win
ON F5 OF c-dep-refugo IN FRAME f-main /* Dep¢sito Refugo */
DO:
   {include/zoomvar.i &prog-zoom = "inzoom/z01in084.w"
                      &campo     = c-dep-refugo
                      &campozoom = cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-dep-refugo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-dep-refugo IN FRAME f-main /* Dep¢sito Refugo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-loc-acab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-loc-acab V-table-Win
ON F5 OF c-loc-acab IN FRAME f-main /* Localizaá∆o */
DO:
   {include/zoomvar.i &prog-zoom = "inzoom/z01in189.w"
                      &campo     = c-loc-acab
                      &campozoom = cod-localiz}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-loc-acab V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-loc-acab IN FRAME f-main /* Localizaá∆o */
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-lote-acab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-lote-acab V-table-Win
ON LEAVE OF c-lote-acab IN FRAME f-main /* Lote SÇrie */
DO:
   if  item.tipo-con-est = 3 
   or  item.tipo-con-est = 4 then do:
       find first saldo-estoq use-index lote
           where saldo-estoq.lote      = input frame {&frame-name} c-lote-acab
             and saldo-estoq.it-codigo = item.it-codigo no-lock no-error.         

       if  not avail(saldo-estoq) then 
           assign dt-valid-lote:sensitive = yes.      
       else
          assign dt-valid-lote:sensitive    = no
                 dt-valid-lote:screen-value = string(saldo-estoq.dt-vali-lote).
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-refer-acab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-refer-acab V-table-Win
ON F5 OF c-refer-acab IN FRAME f-main /* Referància */
DO:
  {include/zoomvar.i &prog-zoom  = inzoom/z01in375.w
                     &campo      = c-refer-acab
                     &campozoom  = cod-refer
                     &parametros = "run pi-seta-inicial in wh-pesquisa
                                                       (input item.it-codigo)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-refer-acab V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-refer-acab IN FRAME f-main /* Referància */
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cc-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-refugo V-table-Win
ON F5 OF fi-cc-refugo IN FRAME f-main
DO:
    assign i-empresa-prin = param-global.empresa-prin.
    &IF DEFINED (bf_mat_conta_estab) &THEN
        find first estabelec
             where estabelec.cod-estabel = c-cod-estabel no-lock no-error.
        if avail estabelec then
           run cdp/cd9970.p (input rowid(estabelec),
                             output i-empresa-prin).
    &ENDIF
    assign i-ep-codigo-usuario = i-empresa-prin.

        
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
ON LEAVE OF fi-cc-refugo IN FRAME f-main
DO:
   {cdp/cdunif001d.i fi-cc-refugo {&frame-name}}
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


&Scoped-define SELF-NAME fi-ccusto-dd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto-dd V-table-Win
ON F5 OF fi-ccusto-dd IN FRAME f-main
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
                ASSIGN fi-ccusto-dd:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.
        
    if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.     
                
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto-dd V-table-Win
ON LEAVE OF fi-ccusto-dd IN FRAME f-main
DO:
   {cdp/cdunif001d.i fi-ccusto-dd {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto-dd V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-ccusto-dd IN FRAME f-main
DO:
  APPLY "F5":u TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-liter.i Dep¢s._Sa°da MCP L}
assign c-cod-depos:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Localiz._Sa°da_ MCP L}
assign c-cod-localiz:label in frame {&frame-name} = return-value. 

{utp/ut-liter.i Conta_Refugo MCP L}
assign c-ct-refugo:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind deposito cod-depos 1}
assign c-dep-acab:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind localizacao cod-localiz 1}
assign c-loc-acab:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind ord-prod lote-serie 1}
assign c-lote-acab:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind ord-prod cod-refer 1}
assign c-refer-acab:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind lote dt-validade 1}
assign dt-valid-lote:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Dep¢sito_Refugo * R}
assign c-dep-refugo:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Localizaá∆o_Refugo * R}
assign c-loc-refugo:label in frame {&frame-name} = trim(return-value).

{utp/ut-field.i mgind rep-prod cod-cta-unif 1}
assign c-ct-debito:label in frame {&frame-name} = trim(return-value).


if c-dep-acab:load-mouse-pointer("image/lupa.cur":U)    then.
if c-loc-acab:load-mouse-pointer("image/lupa.cur":U)    then.
if c-refer-acab:load-mouse-pointer("image/lupa.cur":U)  then.
if c-cod-depos:load-mouse-pointer("image/lupa.cur":U)   then.
if c-cod-localiz:load-mouse-pointer("image/lupa.cur":U) then.
if c-ct-refugo:load-mouse-pointer("image/lupa.cur":U)   then.
if c-ct-debito:load-mouse-pointer("image/lupa.cur":U)   then.
IF fi-ccusto-dd:LOAD-MOUSE-POINTER("image/lupa.cur":U)  THEN.
IF fi-cc-refugo:LOAD-MOUSE-POINTER("image/lupa.cur":U)  THEN.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

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

/*    /* Dispatch standard ADM method.                             */
 *     RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
 *     if RETURN-VALUE = 'ADM-ERROR':U then 
 *         return 'ADM-ERROR':U.*/

    assign tt-reporte.cod-depos    = c-cod-depos:screen-value   in frame {&frame-name}
           tt-reporte.cod-localiz  = c-cod-localiz:screen-value in frame {&frame-name}
           tt-reporte.ct-refugo    = c-ct-refugo:screen-value   in frame {&frame-name}
           tt-reporte.sc-refugo    = fi-cc-refugo:screen-value  in frame {&frame-name}
           tt-reporte.ct-debito    = c-ct-debito:screen-value   in frame {&frame-name}
           tt-reporte.sc-debito    = fi-ccusto-dd:screen-value  in frame {&frame-name}
           tt-reporte.dep-acab     = c-dep-acab:screen-value    in frame {&frame-name}
           tt-reporte.loc-acab     = c-loc-acab:screen-value    in frame {&frame-name}
           tt-reporte.cod-refer    = c-refer-acab:screen-value  in frame {&frame-name}
           tt-reporte.lote-serie   = c-lote-acab:screen-value   in frame {&frame-name}
           tt-reporte.dt-vali-lote = input frame {&frame-name} dt-valid-lote
           tt-reporte.dep-refugo   = c-dep-refugo:screen-value  in frame {&frame-name}
           tt-reporte.loc-refugo   = c-loc-refugo:screen-value  in frame {&frame-name}

           tt-rep-prod.cod-depos    = tt-reporte.dep-acab
           tt-rep-prod.cod-localiz  = tt-reporte.loc-acab
           tt-rep-prod.lote-serie   =  c-lote-acab:screen-value   in frame {&frame-name}
           tt-rep-prod.cod-refer    = tt-reporte.cod-refer
           tt-rep-prod.dt-vali-lote = tt-reporte.dt-vali-lote
           tt-rep-prod.ct-refugo    = tt-reporte.ct-refugo
           tt-rep-prod.sc-refugo    = tt-reporte.sc-refugo
           tt-rep-prod.dep-refugo   = tt-reporte.dep-refugo
           tt-rep-prod.loc-refugo   = tt-reporte.loc-refugo
           tt-rep-prod.cod-cta-unif = tt-reporte.ct-debito
                   tt-rep-prod.cod-ccusto-unif = tt-reporte.sc-debito
                   .
    /*** alteracoes para o modulo de concentracao ***/
    IF param-global.modulo-per-ppm AND
       (item.tipo-formula = 2 or item.tipo-formula = 3) THEN do:
        ASSIGN tt-reporte.per-ppm  = INPUT FRAME {&FRAME-NAME} fi-per-ppm
               tt-rep-prod.per-ppm = tt-reporte.per-ppm.
    end.

    /* Code placed here will execute AFTER standard behavior.    */
    run pi-validate.
    if  RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    run pi-atualiza-tt-reporte in widget-handle (c-handle) (input table tt-reporte).

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
  DELETE PROCEDURE h-cpapi020 NO-ERROR.

  IF VALID-HANDLE(h-cdapi024) THEN
      DELETE PROCEDURE h-cdapi024.
  ASSIGN h-cdapi024 = ?.

  IF NOT VALID-HANDLE(h-cpapi029) THEN
      DELETE PROCEDURE  h-cpapi029.

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
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
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

  /* Code placed here will execute AFTER standard behavior.    */

    find first param-global no-lock no-error.
    if  param-global.modulo-ce then do:
       find first param-estoq no-lock no-error.
       find first param-cq    no-lock no-error.
    end.

    &IF DEFINED(bf_man_206b) &THEN
        /*verifica se Unidade de Negocio est† implantado*/
        IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO":U
                                   AND funcao.ativo     = YES NO-LOCK) THEN DO:
            ASSIGN l-unid-negoc = YES.
            RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.
        END.
    &endif

    IF NOT VALID-HANDLE(h-cpapi029) THEN
        RUN cpp/cpapi029.p PERSISTENT SET h-cpapi029.

    find first param-cp no-lock no-error.
    run notify ('pi-habilita-browse-mob,record-target').
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-handle V-table-Win 
PROCEDURE pi-atualiza-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-aloca     as handle.
def input param p-reserva   as handle.
def input param p-reciclado as handle.

assign h-aloca     = p-aloca
       h-reserva   = p-reserva
       h-reciclado = p-reciclado.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-tt-reporte V-table-Win 
PROCEDURE pi-atualiza-tt-reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param table for tt-reporte.

    DEFINE VARIABLE l-avail-unid-negoc-cq AS LOGICAL INIT NO NO-UNDO.
    DEFINE VARIABLE l-enable-lote-acab    AS LOGICAL INIT NO NO-UNDO.
    DEFINE VARIABLE l-res-neg             AS LOGICAL INIT NO NO-UNDO.
    DEFINE VARIABLE l-estado-dep-aca      AS LOGICAL INIT NO NO-UNDO.

    def var i-ind-refugo as int no-undo.
    find first tt-reporte no-error.
    find split-operac
        where rowid(split-operac) = tt-reporte.rw-split-operac no-lock no-error.
    find op-sfc
        where op-sfc.nr-ord-produ = split-operac.nr-ord-produ no-lock no-error.
    find ord-prod
        where ord-prod.nr-ord-produ = split-operac.nr-ord-produ no-lock no-error.
    find item
        where item.it-codigo = ord-prod.it-codigo no-lock no-error.

    &IF DEFINED (bf_mat_conta_estab) &THEN
        assign c-cod-estabel = ord-prod.cod-estabel.
    &ENDIF

    IF NOT VALID-HANDLE(h-cpapi029) THEN 
        RUN cpp/cpapi029.p PERSISTENT SET h-cpapi029.

    RUN pi-execute IN h-cpapi029 (INPUT 1,
                                  INPUT ord-prod.cod-estabel,
                                  INPUT ord-prod.nr-linha,
                                  output c-dep-fabrica  ,
                                  output d-var-rep      ,   
                                  output d-var-req-menor,  
                                  output d-var-requis   ,  
                                  output d-var-transf   ,
                                  output table tt-erro append).

    DELETE PROCEDURE h-cpapi029.


    /*** Habilita dep¢sito de sa°da das reservas ***/
    if  not param-cp.dep-fab-unico
    and tt-reporte.informa-deposito then
        assign c-cod-depos:sensitive in frame {&frame-name} = yes
               c-cod-depos = c-dep-fabrica.
    else 
        assign c-cod-depos:sensitive in frame {&frame-name} = no
               c-cod-depos = "".

    /*** Habilita localizaá∆o de sa°da das reservas ***/ 
    &IF DEFINED (bf_man_linha_estab) &THEN
        find lin-prod
             where lin-prod.cod-estabel = ord-prod.cod-estabel
               and lin-prod.nr-linha    = ord-prod.nr-linha no-lock no-error.  
    &ELSE
        find lin-prod where lin-prod.nr-linha = ord-prod.nr-linha no-lock no-error.  
    &ENDIF    
    if  avail lin-prod
    and lin-prod.sum-requis = 1
    and tt-reporte.informa-localizacao then
        assign c-cod-localiz:sensitive in frame {&frame-name} = yes.
    else 
        assign c-cod-localiz:sensitive in frame {&frame-name} = no
               c-cod-localiz                                  = "".

    /*** Habilita dados de refugo ***/
    if  tt-reporte.qtd-operac-refgda > 0 then do:

        /* Se o item Ç refugado (perda) ou vira material reciclado, quando existe refugo */
        FIND FIRST item-uni-estab WHERE item-uni-estab.cod-estabel = ord-prod.cod-estabel
                                    AND item-uni-estab.it-codigo   = ord-prod.it-codigo NO-LOCK NO-ERROR.

        assign i-ind-refugo = if  avail item-uni-estab
                              then item-uni-estab.ind-refugo
                              else item.ind-refugo.

        if  i-ind-refugo = 1 then do: /* Perda total */
            assign c-ct-refugo:sensitive in frame {&frame-name} = yes.

            &IF DEFINED (bf_mat_conta_estab) &THEN
                find first estab-mfg
                     where estab-mfg.cod-estab = ord-prod.cod-estabel no-lock no-error.
                if avail estab-mfg and
                   estab-mfg.ct-refugo <> ? then
                   assign c-ct-refugo = estab-mfg.ct-refugo
                                                fi-cc-refugo = estab-mfg.sc-refugo
                                                .
                else
            &ENDIF
                assign c-ct-refugo = param-cp.ct-refugo
                                        fi-cc-refugo = param-cp.sc-refugo
                                        .
        end.
        else do: /* Material recicl†vel */
            find first deposito
                where deposito.log-reciclagem = yes no-lock no-error.
            assign c-dep-refugo:sensitive in frame {&frame-name} = yes
                   c-dep-refugo = if  avail deposito 
                                  then deposito.cod-depos
                                  else "".
            ASSIGN  c-loc-refugo:sensitive = not(f-item-uni-estab (input item.it-codigo,
                                                   input ord-prod.cod-estabel,
                                                   "loc-unica":U) = "yes":U).
            ASSIGN  c-loc-refugo = f-item-uni-estab (input item.it-codigo,
                                                     input ord-prod.cod-estabel,
                                                     "cod-localiz":U) .
        end.
    end.
    else
        assign c-ct-refugo:sensitive in frame {&frame-name}  = no
               fi-cc-refugo:sensitive in frame {&frame-name}  = no
               c-dep-refugo:sensitive in frame {&frame-name} = no
               c-loc-refugo:sensitive in frame {&frame-name} = no
               c-ct-refugo  = ""
               fi-cc-refugo  = ""
               c-dep-refugo = ""
               c-loc-refugo = "". 

    /*** Procura a operaá∆o, para verificar se Ç a £ltima ***/
    find oper-ord
        where rowid(oper-ord) = gr-oper-ord no-lock no-error.

    if  oper-ord.log-operac-final = yes then do:
        ASSIGN l-contr-qualid = (f-item-uni-estab (input item.it-codigo,
                                                   input ord-prod.cod-estabel,
                                                   "contr-qualid":U) = "yes":U).
        if  item.tipo-contr <> 4 then do:     
            assign c-dep-acab:sensitive in frame {&frame-name} = yes
                   c-loc-acab:sensitive in frame {&frame-name} = yes 
                   c-dep-acab = ord-prod.cod-depos.
            if  param-global.modulo-cq and 
                param-cq.tipo-cq       > 0 and 
                l-contr-qualid then do:

                /*se controle qualidade implantado e item tem controle qualidade, entao:*/
                &IF DEFINED(bf_man_206b) &THEN
                    /*Se tem unidade de negocio implantado, tenta encontrar o deposito cq da unidade de negocio*/
                    IF l-unid-negoc THEN DO:
                        FIND FIRST unid-negoc-cq WHERE unid-negoc-cq.cod-estab      = ord-prod.cod-estabel
                                                   AND unid-negoc-cq.cod-unid-negoc = ord-prod.cod-unid-negoc NO-LOCK NO-ERROR.
                        IF AVAIL unid-negoc-cq THEN
                            ASSIGN c-dep-acab            = unid-negoc-cq.cod-depos-cq
                                   l-avail-unid-negoc-cq = YES.
                    END.
                &endif

                IF l-unid-negoc = NO OR l-avail-unid-negoc-cq = NO THEN DO:
                    /*Se nao (implantado unidade de negocio) ou 
                         (implantado unidade de negocio mas nao encontrou dep cq da unid negoc) entao*/
                    find first estabelec where 
                               estabelec.cod-estabel = ord-prod.cod-estabel no-lock no-error.
                    if  avail(estabelec) then 
                        assign c-dep-acab = estabelec.deposito-cq.
                END.
            end.           

            assign c-refer-acab:sensitive in frame {&frame-name} = (item.tipo-con-est = 4)      
                   c-refer-acab = if  item.tipo-con-est = 4 
                                  then ord-prod.cod-refer             
                                  else "".
            ASSIGN c-loc-acab   = f-item-uni-estab (input item.it-codigo,
                                                    input ord-prod.cod-estabel,
                                                    "cod-localiz":U) .

            ASSIGN c-loc-acab:sensitive = not(f-item-uni-estab (input item.it-codigo,
                                                                INPUT ord-prod.cod-estabel,
                                                               "loc-unica":U) = "yes":U ).

            if  item.tipo-con-est <> 1 then do:
                if  item.tipo-con-est = 2 
                or  item.tipo-con-est = 3
                OR  ITEM.tipo-con-est = 4 then do:
                    assign c-lote-acab:sensitive = yes.
                    if  ord-prod.lote-serie = "" then
                        assign c-lote-acab = if  ord-prod.nr-ord-prod > 999999
                                             then string(ord-prod.nr-ord-prod, "999999999")
                                             else ord-prod.cod-estabel + "." +
                                                  string(ord-prod.nr-ord-produ,"999999").
                    else
                        assign c-lote-acab = ord-prod.lote-serie.

                    find first saldo-estoq use-index lote 
                        where saldo-estoq.lote      = c-lote-acab
                          and saldo-estoq.it-codigo = item.it-codigo no-lock no-error.       
                    if  avail saldo-estoq then
                        assign dt-valid-lote = saldo-estoq.dt-vali-lote
                               dt-valid-lote:sensitive = no.             
                    else 
                        assign dt-valid-lote:sensitive = yes.
                end.
            end.                                
            else 
                assign dt-valid-lote:sensitive = no
                       c-lote-acab:sensitive   = no
                       c-refer-acab:sensitive  = no.
        end.                                
        else
            assign c-dep-acab:sensitive    = no
                   c-loc-acab:sensitive    = no
                   c-refer-acab:sensitive  = no
                   c-lote-acab:sensitive   = no
                   dt-valid-lote:sensitive = no.
    end.
    ELSE DO:

        IF (ord-prod.rep-prod = 2 
        OR ord-prod.rep-prod = 3)
        AND item.tipo-contr <> 4
        AND item.tipo-contr <> 1 THEN DO:

            FOR EACH tt-reservas WHERE
                tt-reservas.quant-orig < 0:
                FIND FIRST ITEM WHERE
                    ITEM.it-codigo = tt-reservas.it-codigo NO-LOCK NO-ERROR.
                IF (ITEM.tipo-con-est = 3 OR
                    ITEM.tipo-con-est = 4) THEN DO:
                    ASSIGN l-res-neg = YES.
                    LEAVE.
                END.
            END.
    
            IF l-res-neg THEN
                ASSIGN l-estado-dep-aca = YES.

        END.

        IF NOT l-estado-dep-aca AND
           tt-reporte.qtd-operac-refgda > 0 THEN DO:

            if  item.tipo-con-est = 2 
            or  item.tipo-con-est = 3
            OR  ITEM.tipo-con-est = 4 then do:

                assign c-lote-acab = "ref".
                
                find first saldo-estoq use-index lote 
                    where saldo-estoq.lote      = c-lote-acab
                      and saldo-estoq.it-codigo = item.it-codigo no-lock no-error.       
                if  avail saldo-estoq then
                    assign dt-valid-lote = saldo-estoq.dt-vali-lote
                           dt-valid-lote:sensitive = no.             
                else 
                    assign dt-valid-lote:sensitive = yes.
            end.
        END.
        ELSE
            ASSIGN dt-valid-lote:sensitive = no.

        assign c-lote-acab:sensitive   = no
               c-dep-acab:sensitive    = no
               c-loc-acab:sensitive    = no
               c-refer-acab:sensitive  = no.
    END.
    /** Verifica Ordens de Configurador e DÇbito Direto **/
    run pi-conta-aplicacao in this-procedure.

    /*** modificacoes para o modulo de Fator de concentracao e PPM ***/
    if param-global.modulo-per-ppm THEN DO:
        run cpp/cpapi020.p persistent set h-cpapi020(INPUT-OUTPUT table tt-balanceia,
                                                     input-output table tt-erro,
                                                     INPUT        yes,
                                                     INPUT-OUTPUT TABLE tt-veiculos).

       IF (item.tipo-formula = 2 or item.tipo-formula = 3) THEN
           assign fi-per-ppm:sensitive in frame {&frame-name} = true.

       if item.tipo-formula <> 0 THEN
          case item.tipo-formula:
              when 2 then
                  run pi-formata-campo (fi-per-ppm:HANDLE IN FRAME {&FRAME-NAME}, true, true, item.per-ppm, {ininc/i25in172.i 04 02} + "(%)":u, ">>9.9999":u).
              when 3 then
                  run pi-formata-campo (fi-per-ppm:handle IN FRAME {&FRAME-NAME}, true, true, item.per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
              otherwise
                  run pi-formata-campo (fi-per-ppm:handle IN FRAME {&FRAME-NAME}, false, false, 0, "", "").
          end case.
       else
          run pi-formata-campo (fi-per-ppm:handle IN FRAME {&FRAME-NAME}, false, false, 0, "", "").
    END.
    ELSE
       assign fi-per-ppm:visible  in frame {&frame-name} = false.

    /*** fim das modificaoes  ***/
    disp c-cod-depos
         c-cod-localiz
         c-ct-refugo
         c-dep-acab
         c-loc-acab
         c-refer-acab
         c-lote-acab
         dt-valid-lote
         c-dep-refugo
         c-loc-refugo
         with frame {&frame-name}.
     {include/i-epc006.i}

    assign l-carrega-browse = yes.
    RUN pi-cria-tt-reservas-alocacoes.          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-conta-aplicacao V-table-Win 
PROCEDURE pi-conta-aplicacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if tt-reporte.requisita-configurado then do: 
     find first al-res-op where
                al-res-op.nr-ord-prod = ord-prod.nr-ord-prod
                no-lock no-error.
     if avail(al-res-op) then do:
        find b-ord-prod where 
             b-ord-prod.nr-ord-prod = al-res-op.nr-ord-res
             no-lock no-error.
        if avail(b-ord-prod) then do:             
           assign c-ct-debito:screen-value in frame {&frame-name} = b-ord-prod.ct-codigo
                  c-ct-debito:sensitive in frame {&frame-name}    = no.  
           assign fi-ccusto-dd:screen-value in frame {&frame-name} = b-ord-prod.sc-codigo
                  fi-ccusto-dd:sensitive in frame {&frame-name}    = no.  
                                  
        end.      
     end.
  end.
  else do:            
     if  item.it-codigo = ""
     or  item.tipo-contr = 3
     or  item.tipo-contr = 4       
     or  item.tipo-contr = 1
     and param-global.modulo-ce = yes 
     then do:
       assign c-ct-debito:sensitive in frame {&frame-name}  = true
              c-ct-debito:screen-value                      = ""
              fi-ccusto-dd:sensitive in frame {&frame-name} = true
              fi-ccusto-dd:screen-value                     = ""
              c-ct-refugo                                   = ""
              c-ct-refugo:sensitive in frame {&frame-name}  = false
              fi-cc-refugo                                  = ""
              fi-cc-refugo:sensitive in frame {&frame-name} = false
              c-ct-refugo:screen-value                      = ""
              c-ct-debito:screen-value                      = if c-ct-debito:screen-value = "" 
                                                             then item.ct-codigo
                                                             else c-ct-debito:screen-value
              fi-ccusto-dd:screen-value                     = if fi-ccusto-dd:screen-value = "" 
                                                             then item.sc-codigo
                                                             else fi-ccusto-dd:screen-value
                                                                                                                         .
     end.      
     else do: 
        assign c-ct-debito:sensitive in frame {&frame-name}  = false
               c-ct-debito:screen-value                      = "". 
        assign fi-ccusto-dd:sensitive in frame {&frame-name} = false
               fi-ccusto-dd:screen-value                     = "". 
                           
     end.                  
  end.            


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

    if (c-cod-depos     <> input frame {&frame-name} c-cod-depos
    or  c-cod-localiz   <> input frame {&frame-name} c-cod-localiz
    or  l-carrega-browse = yes)
    /*and tt-reporte.busca-saldos = no*/ then do: 

        RUN set-cursor IN adm-broker-hdl (INPUT "WAIT":U).                               

        assign l-carrega-browse = no
               c-cod-depos
               c-cod-localiz.

        for each tt-rep-prod:
            delete tt-rep-prod.
        end.

        create tt-rep-prod.
        assign tt-rep-prod.nr-ord-prod    = ord-prod.nr-ord-prod
               tt-rep-prod.it-codigo      = ord-prod.it-codigo
               tt-rep-prod.data           = tt-reporte.dat-fim-reporte
               tt-rep-prod.reserva        = yes
               tt-rep-prod.tipo           = ord-prod.rep-prod
               tt-rep-prod.un             = ord-prod.un
               tt-rep-prod.op-codigo      = oper-ord.op-codigo    when avail oper-ord
               tt-rep-prod.cod-roteiro    = oper-ord.cod-roteiro  when avail oper-ord
               tt-rep-prod.it-oper        = oper-ord.it-codigo    when avail oper-ord
               tt-rep-prod.pto-controle   = oper-ord.pto-controle WHEN AVAIL oper-ord
               tt-rep-prod.qt-reporte     = IF oper-ord.val-operac-item = 1 THEN tt-reporte.qtd-operac-reptda
                                            ELSE ((ord-prod.qt-ordem * tt-reporte.qtd-operac-reptda) / qtd-previs-operac)
               tt-rep-prod.cod-depos-sai  = if  c-cod-depos:sensitive in frame {&frame-name}
                                            then c-cod-depos
                                            else ?
               tt-rep-prod.cod-local-sai  = if  c-cod-localiz:sensitive in frame {&frame-name}
                                            then c-cod-localiz
                                            else ?
               tt-rep-prod.prog-seg       = 'sf0303'
               tt-rep-prod.baixa-reservas = tt-reporte.baixa-reservas.
        ASSIGN tt-rep-prod.cod-cta-unif    = STRING(f-item-uni-estab (input item.it-codigo,
                                                                     input ord-prod.cod-estabel,
                                                                     "ct-codigo":U)).
        ASSIGN tt-rep-prod.cod-ccusto-unif = STRING(f-item-uni-estab (input item.it-codigo,
                                                                     input ord-prod.cod-estabel,
                                                                     "sc-codigo":U)).
                                                                                                                                         

        if  tt-rep-prod.cod-cta-unif = ""  
        and item.tipo-contr         = 3 /* Consignado */ then do:
            &IF DEFINED (bf_mat_conta_estab) &THEN
                find first estab-mfg
                     where estab-mfg.cod-estabel = ord-prod.cod-estabel no-lock no-error.
                if avail estab-mfg and
                   estab-mfg.cod-cta-unif <> ? then
                   assign tt-rep-prod.cod-cta-unif = estab-mfg.cod-cta-unif
                                                tt-rep-prod.cod-ccusto-unif = estab-mfg.cod-ccusto-unif
                                                .
                else
            &ENDIF
                assign tt-rep-prod.cod-cta-unif = param-cp.cod-cta-unif
                                        tt-rep-prod.cod-ccusto-unif = param-cp.cod-ccusto-unif
                                        .
        end.

        run pi-recebe-tt-rep-prod in h-handle (input table tt-rep-prod).

        /*********************************************************************
        ** Se o programa foi aberto e n∆o Ç a £ltima operaá∆o e o 
        ** tipo de reporte da ordem Ç por Ordem, n∆o deve buscar 
        ** reservas e alocaá‰es  
        ** BETA-TESTE Refugo por Operaá∆o
        *********************************************************************/
         if (ord-prod.rep-prod = 1 and oper-ord.log-operac-final) or 
            ord-prod.rep-prod > 1 then do:
            if NOT tt-reporte.busca-saldos then do:
                /* Carrega as temp-tables de reservas e alocaá‰es */
                if  tt-reporte.qtd-operac-reptda > 0 then do:
                    RUN Who-Is-The-Container IN adm-broker-hdl
                       (INPUT this-procedure,
                        OUTPUT c-handle).
                    run get-attribute in widget-handle (c-handle) (input "tipo-reporte").

                    /*** Executa procedure para carregar as reservas das ordens.
                         Caso o reporte seja por ordem ou operacao, busca as reservas por operacao.
                         Se o reporte for por pto de controle, busca por pto de controle. ***/

                    run pi-carrega-tt-reservas in h-handle (input yes,
                                                            input ord-prod.rep-prod,
                                                            input rowid (oper-ord)).
                end.
                else do:
                    for each tt-reservas: delete tt-reservas. end.
                    for each tt-aloca:    delete tt-aloca.    end.

                    run pi-recebe-tt-reservas in h-handle (input table tt-reservas).
                    run pi-recebe-tt-aloca    in h-handle (input table tt-aloca).
                end.

                if  valid-handle(h-aloca) then do:
                    run pi-habilita-campos in h-aloca.
                    run pi-recebe-tt-res-aloc in h-aloca.
                end.

                if  valid-handle(h-reserva) then do:
                    run pi-habilita-campos in h-reserva.
                    run pi-recebe-tt-res-aloc in h-reserva.
                end.

                if  valid-handle(h-reciclado) then do:
                    run pi-habilita-campos in h-reciclado.
                    run pi-recebe-tt-res-aloc in h-reciclado.
                end.
            end.    
        end.
        else do:
            for each tt-reservas: delete tt-reservas. end.
            for each tt-aloca:    delete tt-aloca.    end.

            run pi-recebe-tt-reservas in h-handle (input table tt-reservas).
            run pi-recebe-tt-aloca    in h-handle (input table tt-aloca).
        end.
        RUN set-cursor IN adm-broker-hdl (INPUT "").

        RUN habilitaBalanceamento IN h-handle-pai NO-ERROR.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campo V-table-Win 
PROCEDURE pi-formata-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pHandle      as handle no-undo.
def input param pVisible     as log    no-undo.
def input param pSensitive   as log    no-undo.
def input param pScreenValue as dec    no-undo.
def input param pLabel       as char   no-undo.
def input param pFormat      as char   no-undo.

    if pVisible then
        assign pHandle:visible      = pVisible
               pHandle:sensitive    = pSensitive
               pHandle:format       = pFormat
               pHandle:screen-value = string(pScreenValue)
               pHandle:label        = pLabel no-error.
    else
        assign pHandle:visible = pVisible no-error.

return 'ok':u.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle-pai V-table-Win 
PROCEDURE pi-recebe-handle-pai :
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

    def var c-erro    as char no-undo.
    def var c-texto   as char no-undo.
    def var c-retorno as char no-undo.
    def var c-campo   as char no-undo.
    def var i-cont    as int no-undo.    

    DEFINE VARIABLE c-unid-achada AS CHARACTER  NO-UNDO.

    IF VALID-HANDLE(h-reserva) THEN DO:
        RUN pi-valida-lote IN h-reserva.
        IF RETURN-VALUE = "NOK" 
            THEN RETURN "adm-error".
    END.


    run pi-recebe-tt-rep-prod in h-handle (input table tt-rep-prod).

    run pi-valida-rep-prod    in h-handle (input  yes,
                                           input  ord-prod.nr-ord-prod,
                                           output c-erro,
                                           output c-texto). 

    assign c-retorno = return-value.

    RUN set-cursor in adm-broker-hdl ("").

    if  c-retorno = "nok" then do:
        case int (entry (1, c-erro)):
            when 56 then
                apply 'entry' to c-loc-acab in frame {&frame-name}.

            when 530 or when 3412 then 
                apply 'entry' to c-cod-depos in frame {&frame-name}.

            when 2386 or when 2387 or when 2388 then
                apply 'entry' to c-ct-refugo in frame {&frame-name}.

            when 2403 or when 7410 then
                apply 'entry' to c-dep-acab in frame {&frame-name}.

            when 1252 or when 2408 or when 2158 then
                apply 'entry' to c-lote-acab in frame {&frame-name}.

            when 529 or when 1235 or when 1236 then
                apply 'entry' to c-refer-acab in frame {&frame-name}.

            when 1247 or when 2409 or when 2410 then
                apply 'entry':U to dt-valid-lote in frame {&frame-name}.
        end case.
    end.

    do  i-cont = 1 to num-entries (c-erro):
        run utp/ut-msgs.p (input "show":U,
                           input int (entry (i-cont, c-erro)),
                           input entry (i-cont, c-texto)).
    end.

    &IF DEFINED(bf_man_206b) &THEN
        /*Se unidade de negocio implantado, valida se deposito Ç valido para a unidade de negocio*/
        if  l-unid-negoc AND 
            param-global.modulo-cq and 
            param-cq.tipo-cq       > 0 and 
            l-contr-qualid then do:
                /*se controle qualidade implantado e item tem controle qualidade, entao:*/
                RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT ord-prod.cod-estabel,
                                                         INPUT ord-prod.it-codigo,
                                                         INPUT c-dep-acab:SCREEN-VALUE IN FRAME f-main,
                                                         OUTPUT c-unid-achada).
                IF c-unid-achada <> ord-prod.cod-unid-negoc THEN DO:
                    /*Erro: Dep¢sito n∆o pode ser alterado, pois n∆o est† de acordo com a Unidade de Neg¢cio.*/
                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 31379,
                                       INPUT "").
                    ASSIGN c-retorno = "nok":U.
                END.
        END.
    &endif
    
    if  c-retorno = "nok":U then 
        return "adm-error":U.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

