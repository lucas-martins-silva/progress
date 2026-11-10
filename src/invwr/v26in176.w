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
{include/i-prgvrs.i V26IN176 2.00.00.012 } /*** "010012" ***/
 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v26in176 MUT}
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
def new global shared var v-row-parent    as rowid no-undo.             
def new global shared var gr-pedido-compr as rowid no-undo.
def new global shared var gr-ordem-compra as rowid no-undo.
 
/* Parameters Definitions ---                                           */
def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.

define var c-formato-conta  as char no-undo.
define var c-formato-ccusto as char no-undo. 

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància".
    
/* Local Variable Definitions ---                                       */
 
{include/tt-edit.i}   /* Definido para a procedure interna */
{include/pi-edit.i}   /* pi-calcula-itens-nota */

{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
 
def buffer b-item-doc-est for item-doc-est.
 
{rep/re9999.i1}
{rep/re9999.i2 "new"}
 
def var l-compras       as logical   no-undo.
def var l-inclui        as logical   no-undo.
def var l-rateio        as logical   no-undo.
 
def var i-sequencia     as integer   no-undo.
def var i-x             as integer   no-undo.
def var de-quantidade   as decimal   no-undo.
def var de-qtd-forn     as decimal   no-undo.
def var c-handle        as character no-undo.
def var wh-programa     as handle    no-undo.
def var rw-item-doc-est as rowid     no-undo. 
def var l-inclusao      as logical   no-undo.
def var l-alterou-item  as logical   no-undo.
def var i-empresa like param-global.empresa-prin no-undo.

DEF VAR h-boin01089     AS HANDLE    NO-UNDO. /*natur-rendto*/
DEF VAR c-des-natur-rendto-aux AS CHARACTER NO-UNDO.
 
def var i-num-ord-inv       as integer  no-undo.

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
&Scoped-define EXTERNAL-TABLES item-doc-est
&Scoped-define FIRST-EXTERNAL-TABLE item-doc-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-doc-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-doc-est.num-pedido ~
item-doc-est.numero-ordem item-doc-est.nr-ord-produ item-doc-est.int-1 ~
item-doc-est.item-pai item-doc-est.cod-roteiro item-doc-est.op-codigo ~
item-doc-est.log-1 item-doc-est.encerra-pa item-doc-est.baixa-ce ~
item-doc-est.qt-etiquetas item-doc-est.ct-codigo item-doc-est.sc-codigo 
&Scoped-define ENABLED-TABLES item-doc-est
&Scoped-define FIRST-ENABLED-TABLE item-doc-est
&Scoped-Define ENABLED-OBJECTS rt-key rt-key-2 rt-key-3 ~
fi-log-usa-unid-negoc-fifo fi-cod-unid-negoc 
&Scoped-Define DISPLAYED-FIELDS item-doc-est.num-pedido ~
item-doc-est.numero-ordem item-doc-est.nr-ord-produ item-doc-est.int-1 ~
item-doc-est.item-pai item-doc-est.parcela item-doc-est.cod-roteiro ~
item-doc-est.op-codigo item-doc-est.log-1 item-doc-est.encerra-pa ~
item-doc-est.baixa-ce item-doc-est.qt-etiquetas item-doc-est.ct-codigo ~
item-doc-est.sc-codigo 
&Scoped-define DISPLAYED-TABLES item-doc-est
&Scoped-define FIRST-DISPLAYED-TABLE item-doc-est
&Scoped-Define DISPLAYED-OBJECTS fi-parcNC fi-log-usa-unid-negoc-fifo ~
c-desc-conta-ctbl c-desc-ccusto fi-cod-unid-negoc fi-des-unid-negoc ~
c-cdn-serv-inss c-des-serv-inss c-cod-nat-rendimento c-des-natur-rendto 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS item-doc-est.num-pedido ~
item-doc-est.numero-ordem item-doc-est.parcela 

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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-num-pedido 
       MENU-ITEM m_f5           LABEL "F5 - Zoom"     
       MENU-ITEM m_f7           LABEL "F7 - Consulta Pedido"
       MENU-ITEM m_f8           LABEL "F8 - Abertura Pedido".

DEFINE MENU POPUP-MENU-numero-ordem 
       MENU-ITEM m_F5_ordem     LABEL "F5 - Zoom"     
       MENU-ITEM m_f7_ordem     LABEL "F7 - Consulta Ordens".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cdn-serv-inss AS CHARACTER FORMAT "X(3)":U 
     LABEL "Tipo de Serviáo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-nat-rendimento AS CHARACTER FORMAT "X(09)":U 
     LABEL "Natureza Rendimento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 TOOLTIP "Natureza Rendimento" NO-UNDO.

DEFINE VARIABLE c-des-natur-rendto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-serv-inss AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ccusto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-conta-ctbl AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-unid-negoc AS CHARACTER FORMAT "X(3)" 
     LABEL "Unidade Neg¢cio":R18 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE fi-des-unid-negoc AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-parcNC AS CHARACTER FORMAT "X(2)":U 
     LABEL "Parcela NC" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.72 BY 6.5.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.14 BY 5.5.

DEFINE RECTANGLE rt-key-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41.57 BY 6.5.

DEFINE VARIABLE fi-log-usa-unid-negoc-fifo AS LOGICAL INITIAL no 
     LABEL "Considera Unid Neg FIFO":L29 
     VIEW-AS TOGGLE-BOX
     SIZE 20.43 BY .83.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-doc-est.num-pedido AT ROW 1.33 COL 17.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     fi-parcNC AT ROW 1.33 COL 64.57 COLON-ALIGNED
     item-doc-est.numero-ordem AT ROW 2.33 COL 17.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     item-doc-est.nr-ord-produ AT ROW 2.33 COL 64.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     item-doc-est.int-1 AT ROW 3.33 COL 17.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     item-doc-est.item-pai AT ROW 3.33 COL 64.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     item-doc-est.parcela AT ROW 4.33 COL 17.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     item-doc-est.cod-roteiro AT ROW 4.33 COL 64.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     item-doc-est.op-codigo AT ROW 5.33 COL 64.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     fi-log-usa-unid-negoc-fifo AT ROW 5.54 COL 3
     item-doc-est.log-1 AT ROW 5.54 COL 25
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .83 TOOLTIP "FIFO Ordem de Compra"
     item-doc-est.encerra-pa AT ROW 6.33 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 18.14 BY .83
     item-doc-est.baixa-ce AT ROW 6.33 COL 25
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .83
     item-doc-est.qt-etiquetas AT ROW 6.33 COL 64.57 COLON-ALIGNED FORMAT ">>>>>>>9"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     item-doc-est.ct-codigo AT ROW 8 COL 21.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-desc-conta-ctbl AT ROW 8 COL 40 COLON-ALIGNED NO-LABEL
     item-doc-est.sc-codigo AT ROW 9 COL 21.72 COLON-ALIGNED
          LABEL "Centro de Custo"
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-desc-ccusto AT ROW 9 COL 40 COLON-ALIGNED NO-LABEL
     fi-cod-unid-negoc AT ROW 10 COL 21.72 COLON-ALIGNED
     fi-des-unid-negoc AT ROW 10 COL 27 COLON-ALIGNED HELP
          "Descriá∆o Unidade Negocio" NO-LABEL
     c-cdn-serv-inss AT ROW 11 COL 21.72 COLON-ALIGNED WIDGET-ID 2
     c-des-serv-inss AT ROW 11 COL 28.86 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     c-cod-nat-rendimento AT ROW 12 COL 21.57 COLON-ALIGNED WIDGET-ID 6
     c-des-natur-rendto AT ROW 12 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     rt-key AT ROW 1 COL 44
     rt-key-2 AT ROW 7.75 COL 1.57
     rt-key-3 AT ROW 1 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.item-doc-est
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
         HEIGHT             = 12.33
         WIDTH              = 86.43.
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

/* SETTINGS FOR FILL-IN c-cdn-serv-inss IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-nat-rendimento IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-natur-rendto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-serv-inss IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ccusto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-conta-ctbl IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-cod-unid-negoc:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-des-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-des-unid-negoc:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       fi-log-usa-unid-negoc-fifo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-parcNC IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-doc-est.num-pedido IN FRAME f-main
   2                                                                    */
ASSIGN 
       item-doc-est.num-pedido:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-num-pedido:HANDLE.

/* SETTINGS FOR FILL-IN item-doc-est.numero-ordem IN FRAME f-main
   2                                                                    */
ASSIGN 
       item-doc-est.numero-ordem:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-numero-ordem:HANDLE.

/* SETTINGS FOR FILL-IN item-doc-est.parcela IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN item-doc-est.qt-etiquetas IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN item-doc-est.sc-codigo IN FRAME f-main
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
 
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
 
  /************************ INTERNAL PROCEDURES ********************/
 
 
    do with frame {&frame-name}:
        {utp/ut-liter.i Evento * L}
        assign item-doc-est.int-1:label = return-value.
        {utp/ut-liter.i FIFO_Ordem_Compra * R}
        assign item-doc-est.log-1:label = trim(return-value).
    end.

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
  {src/adm/template/row-list.i "item-doc-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-doc-est"}

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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
 
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

  /* Code placed here will execute AFTER standard behavior.    */

  /* Elimina handle's */
  delete object h_api_cta_ctbl.
  delete object h_api_ccusto. 
  DELETE OBJECT h-boin01089.

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
 
    /* Vari·veis conta ctbl */
    def var v_cod_cta_ctbl       as char   no-undo.
    def var v_titulo_cta_ctbl    as char   no-undo.
    def var v_num_tip_cta_ctbl   as int    no-undo.
    def var v_num_sit_cta_ctbl   as int    no-undo.
    def var v_ind_finalid_cta    as char   no-undo.
    /* Vari·veis centro de custo */ 
    def var v_cod_ccusto         as char   no-undo.
    def var v_titulo_ccusto      as char   no-undo.   
 
    
    if AVAIL(item-doc-est) then do:
        assign i-num-ord-inv = item-doc-est.num-ord-inv.
        
        FIND FIRST docum-est NO-LOCK 
            WHERE  docum-est.cod-emitente = item-doc-est.cod-emitente
              AND  docum-est.nat-operacao = item-doc-est.nat-operacao
              AND  docum-est.serie-docto  = item-doc-est.serie-docto
              AND  docum-est.nro-docto    = item-doc-est.nro-docto NO-ERROR.
        IF NOT AVAIL(docum-est) THEN LEAVE.


        find estabelec where
                 estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
        assign i-empresa = estabelec.ep-codigo when avail estabelec.            
        
      
        IF NOT VALID-HANDLE( h_api_cta_ctbl) OR NOT VALID-HANDLE(h_api_ccusto) THEN LEAVE.
            
        /* Retorna formato da conta contabil */
        run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,           /* EMPRESA EMS2 */
                                                           input  "",                  /* PLANO CONTAS */
                                                           input  docum-est.dt-trans,  /* DATA DE TRANSACAO */
                                                           output c-formato-conta,     /* FORMATO CONTA */
                                                           output table tt_log_erro).  /* ERROS */

       
        /* Retorna formato do centro de custo */
        run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,           /* EMPRESA EMS2 */
                                                       input  "",                  /* PLANO CCUSTO */
                                                       input  docum-est.dt-trans,  /* DATA DE TRANSACAO */
                                                       output c-formato-ccusto,    /* FORMATO CCUSTO */
                                                       output table tt_log_erro).  /* ERROS */  

       
                                                       
        /* Busca dados da conta cont†bil */
        ASSIGN v_cod_cta_ctbl = item-doc-est.ct-codigo.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                       input        "",                 /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,     /* CONTA */
                                                       input        docum-est.dt-trans, /* DATA TRANSACAO */   
                                                       output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                       output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).       /* ERROS */ 
    
       
        /* Busca dados do centro de custo */
        ASSIGN v_cod_ccusto = item-doc-est.sc-codigo.
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                   input  v_cod_ccusto,       /* CCUSTO */
                                                   input  docum-est.dt-trans, /* DATA DE TRANSACAO */
                                                   output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */

      
        assign c-desc-conta-ctbl:screen-value in frame {&frame-name} = v_titulo_cta_ctbl.
        assign c-desc-ccusto:screen-value in frame {&frame-name} = v_titulo_ccusto.
                      
        if c-formato-conta <> "" then
            assign item-doc-est.ct-codigo:format in frame {&FRAME-NAME} = c-formato-conta.
        if c-formato-ccusto <> "" then
            assign item-doc-est.sc-codigo:format in frame {&FRAME-NAME} = c-formato-ccusto.            
        
            

    end.            
    
    {utp/ut-liter.i "Pedido Compra" *}
    assign item-doc-est.num-pedido:label in frame {&frame-name} = RETURN-VALUE.
    
    if avail item-doc-est then
        assign fi-cod-unid-negoc:screen-value     in frame {&frame-name} = item-doc-est.cod-unid-negoc
               fi-log-usa-unid-negoc-fifo:checked in frame {&frame-name} = item-doc-est.log-usa-unid-negoc.
    else
        assign fi-cod-unid-negoc:screen-value     in frame {&frame-name} = ""
               fi-log-usa-unid-negoc-fifo:checked in frame {&frame-name} = no.
    
    find first unid-negoc 
         where unid-negoc.cod-unid-negoc = input frame {&frame-name} fi-cod-unid-negoc
         no-lock no-error.
    if avail unid-negoc then
        assign fi-des-unid-negoc:screen-value in frame {&frame-name} = unid-negoc.des-unid-negoc.
    else
        assign fi-des-unid-negoc:screen-value in frame {&frame-name} = "".

    IF  i-pais-impto-usuario <> 1 THEN DO:
        ASSIGN fi-parcNC:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(item-doc-est.cod-parc-devol).
    END.
    ELSE DO:
        /*REINF - Serviáo Tomados*/
        FIND FIRST tab-serv-inss 
             WHERE tab-serv-inss.cdn-serv-inss = int(SUBSTRING(item-doc-est.char-2,941,3)) NO-LOCK NO-ERROR.
          IF AVAIL tab-serv-inss THEN
            ASSIGN c-cdn-serv-inss:SCREEN-VALUE IN FRAME {&FRAME-NAME} = substring(item-doc-est.char-2,941,3)
                   c-des-serv-inss:SCREEN-VALUE IN FRAME {&FRAME-NAME} = tab-serv-inss.des-serv-inss.
    
        /*REINF - Retená∆o */
        IF  SUBSTRING(item-doc-est.char-2,946,9) <> ''
        AND VALID-HANDLE(h-boin01089) THEN DO:
            
            RUN goToKey IN h-boin01089 (INPUT SUBSTRING(item-doc-est.char-2,946,9)).
            
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField IN h-boin01089 (INPUT "des-natur-rendto":U,
                                                 OUTPUT c-des-natur-rendto-aux).
                ASSIGN c-cod-nat-rendimento:screen-value in frame {&FRAME-NAME} = SUBSTRING(item-doc-est.char-2,946,9)
                       c-des-natur-rendto  :screen-value in frame {&FRAME-NAME} = c-des-natur-rendto-aux.
            END.
        END.
        ELSE DO:
             ASSIGN c-cod-nat-rendimento:screen-value in frame {&FRAME-NAME} = ''
                    c-des-natur-rendto  :screen-value in frame {&FRAME-NAME} = ''.
        END.
    END.

  /* Code placed here will execute AFTER standard behavior.    */
 
    RETURN "OK":U.
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
  find first para-fat no-lock no-error.
  find first param-global no-lock no-error.
    
  /* Handle da API Conta Cont†bil */
  run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
  /* Handle da API Centro Custo */
  run prgint\utb\utb742za.py persistent set h_api_ccusto.

  RUN inbo\boin01089.p PERSISTENT SET h-boin01089.
  RUN openQueryStatic IN h-boin01089 (INPUT "Main":U) NO-ERROR.


  find first param-global no-lock no-error.
  find first param-compra no-lock no-error.
  find param-re where param-re.usuario = c-seg-usuario no-lock no-error.

  
  {utp/ut-liter.i Considera_Unid_Neg_FIFO * R}
  assign fi-log-usa-unid-negoc-fifo:label  in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Unidade_de_Neg¢cio * R}
  assign fi-cod-unid-negoc:label           in frame {&frame-name} = trim(return-value)
         fi-log-usa-unid-negoc-fifo:hidden in frame {&frame-name} = no
         fi-cod-unid-negoc:hidden          in frame {&frame-name} = no
         fi-des-unid-negoc:hidden          in frame {&frame-name} = no.
  IF  i-pais-impto-usuario = 1 THEN DO:
      ASSIGN fi-parcNC:HIDDEN in frame {&frame-name} = YES.

      {utp/ut-liter.i Parcela_NC * R}
      ASSIGN fi-parcNC:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
  END.
  ELSE DO:
      ASSIGN c-cdn-serv-inss     :HIDDEN          IN FRAME {&frame-name} = yes
             c-des-serv-inss     :HIDDEN          IN FRAME {&frame-name} = yes
             c-cod-nat-rendimento:HIDDEN          IN FRAME {&frame-name} = yes
             c-des-natur-rendto  :HIDDEN          IN FRAME {&frame-name} = yes.
  END.


  /* Code placed here will execute AFTER standard behavior.    */
 
    {utp/ut-liter.i Centro_de_Custo * R}
    assign item-doc-est.sc-codigo:label      in frame {&frame-name} = trim(return-value).
    {utp/ut-liter.i Conta_Cont†bil * R}
    assign item-doc-est.ct-codigo:label      in frame {&frame-name} = trim(return-value).    
 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-itens-nota V-table-Win 
PROCEDURE pi-calcula-itens-nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    define output parameter i-nr-itens as integer no-undo.
 
    def var i-nr-posicoes as integer no-undo.
 
    run rep/re0301x1.p (output i-nr-posicoes).
    for each tt-editor:
        delete tt-editor.
    end.
 
    for each b-item-doc-est 
       where b-item-doc-est.cod-emitente = docum-est.cod-emitente
         and b-item-doc-est.nat-operacao = docum-est.nat-operacao
         and b-item-doc-est.serie-docto  = docum-est.serie-docto
         and b-item-doc-est.nro-docto    = docum-est.nro-docto no-lock:
 
        find item where item.it-codigo = b-item-doc-est.it-codigo no-lock no-error.
        assign i-nr-itens = i-nr-itens + integer(item.ind-imp-desc < 5).
 
        if  index("256",string(item.ind-imp-desc)) > 0 then do:
            run pi-print-editor (item.narrativa, i-nr-posicoes).
            if  item.ind-imp-desc = 6 then 
                assign i-nr-itens = i-nr-itens + 1.
            else
                for each tt-editor:
                    assign i-nr-itens = i-nr-itens + 1.
                end.
        end.
        else
            if  item.ind-imp-desc = 3 then do:
                find item-cli where 
                     item-cli.it-codigo  = item.it-codigo and
                     item-cli.nome-abrev = emitente.nome-abrev no-lock no-error.
                if  avail item-cli then do:
                    run pi-print-editor (item-cli.narrativa, i-nr-posicoes).
                    for each tt-editor:
                        assign i-nr-itens = i-nr-itens + 1.
                    end.
                end.
            end. 
            else
                if  item.ind-imp-desc = 4 or item.ind-imp-desc = 7 then do:
                    run pi-print-editor (b-item-doc-est.narrativa, i-nr-posicoes).
                    for each tt-editor:
                        assign i-nr-itens = i-nr-itens + 1.
                    end.
                end.
    end.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-parametros V-table-Win 
PROCEDURE pi-recebe-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 def input   parameter p-rw-item-doc-est as rowid   no-undo. 
 def input   parameter p-c-incmod        as char    no-undo.
 
assign rw-item-doc-est = p-rw-item-doc-est
       l-inclusao      = p-c-incmod <> "Modificar".
 
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
  {src/adm/template/snd-list.i "item-doc-est"}

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

