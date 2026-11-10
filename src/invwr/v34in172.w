&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
USING com.totvs.datasul.eai.internalid.*.
USING com.totvs.datasul.eai.*.

{include/i-prgvrs.i V34IN172 2.00.02.024 } /*** "010224" 30/10/2026 12:04:46 ***/
 
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v34in172 MUT}
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

{cdp/cdcfgmat.i}
{cdp/cdcfgman.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgren.i} /*Include com PrÇ-Processador da Grendene*/
{include/i_prdvers.i}

/* global variable definitions */
def new global shared var v-row-parent as rowid   no-undo.                                
def new global shared var gr-item      as rowid   no-undo.
def new global shared var l-cd0204-img as logical no-undo.
def NEW GLOBAL SHARED var v-log-fam    as LOGICAL no-undo.


/*DEF VAR de-peso-bruto AS DECIMAL NO-UNDO.
DEF VAR de-peso-liq   AS DECIMAL NO-UNDO.*/

/*** Variˇveis para integraªío EMS x SISDOC ***/
def var i-integracao-sisdoc as integer init ?  no-undo.
def var c-handle            as char            no-undo.
def var h-handle            as handle          no-undo.
def var c-opcao-int         as char            no-undo.
def var i-retorno-erro      as integer init ?  no-undo.

DEFINE VARIABLE h-boar2006 AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-item-copy LIKE ITEM.it-codigo NO-UNDO.

    /* ** 5 => Quando par≥metro "nao-integra" e o registro jˇ estˇ integrado **
       ** 6 => Erro de integraªío no SISDOC                                  **
       ** 7 => Erro de integraªío no EMS                                     ** */
/********* Fim variˇveis para integraªío ******/       

def buffer b-item for item.
def buffer b1-item for item.
DEF BUFFER b-item-dist FOR item-dist.
DEF BUFFER b-it-res-carac FOR it-res-carac.
DEF BUFFER b-it-msg-carac FOR it-msg-carac.

def temp-table tt-item-2 NO-UNDO like item use-index codigo.

def temp-table tt-erro-aux no-undo
    field i-sequenc as int
    field cd-erro   as int
    field mensagem  as char format "x(255)".

{database/tgin/twp/twin172.i1 item tt-item-2 "not avail"}

DEF BUFFER bf-item FOR ITEM.
DEF BUFFER bf-it-carac-tec FOR it-carac-tec.


DEFINE VAR l-narrativa AS LOGICAL NO-UNDO.
DEFINE VAR l-resultados AS LOGICAL NO-UNDO.

/***************Multiplanta********************/
def var i-tipo-movto as integer no-undo.
def var l-cria as logical initial no no-undo.

{cdp/cd7300.i1}
{cdp/cdapi244.i}
{mcinc/mcapi003.i}
def temp-table tt-dados-env-SMC   no-undo like tt-dados-env.
def temp-table tt-replica-msg-SMC no-undo like tt-replica-msg.
def temp-table tt-control-env-SMC no-undo like tt-control-env.
def temp-table tt-integracao-SMC  no-undo like tt-integracao.
/****************Fim*****************************/

def var c-aux        as char             no-undo.
def var c-prog       as handle           no-undo.
def var l-copia      as log              no-undo.
def var l-copy       as log              no-undo.
def var rw-old-item  as rowid            no-undo.
def var rw-new-item  as rowid            no-undo.
def var c-hand-query as char             no-undo.
def var c-it-codigo  like item.it-codigo no-undo.
DEFINE VARIABLE h-bofi282 AS HANDLE NO-UNDO.

/* Definiá∆o de Classe - Eliminaá∆o DE-PARA no EAI*/
DEFINE VARIABLE oMapper AS IInternalIdMapper NO-UNDO.

/* fo 1515.550 DTS-MEXICO */
DEF VAR i-novo       AS INT   NO-UNDO.

DEFINE VARIABLE h-cdapi998 AS HANDLE NO-UNDO.
&IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
    /* Integraá∆o EMS EAI2.0 Mensagem unica */
    DEFINE NEW GLOBAL SHARED VARIABLE v_log_eai2_ativado AS LOGICAL NO-UNDO INITIAL NO.     
&ENDIF 


{bhp/bh9999.i1} /* Definiªío Temp-Table TT-TABELA   */

&IF '{&mgscm_version}' >= '2.06B' &THEN
DEFINE VARIABLE hDBOproxy AS HANDLE NO-UNDO.

DEF TEMP-TABLE ttItemReplica    NO-UNDO
    FIELD it-codigo             LIKE wm-item.cod-item
    FIELD desc-item             LIKE wm-item.des-item
    FIELD unid-med              LIKE wm-item.cod-unid-med
    FIELD peso-bruto            LIKE wm-item.qtd-peso
    FIELD largura               LIKE wm-item.qtd-largura
    FIELD comprimento           LIKE wm-item.qtd-comprimento
    FIELD altura                LIKE wm-item.qtd-altura
    FIELD tipo-con-est          LIKE wm-item.ind-tipo-contr-est
    FIELD fm-cod-com            LIKE wm-item.cod-familia
    FIELD fm-codigo             LIKE wm-item.cod-familia
    INDEX ch-codigo AS PRIMARY UNIQUE it-codigo.
&ENDIF

&IF DEFINED (bf_man_203) &THEN   
    def temp-table tt-estabel no-undo
        field cod-estabel as char
        field log-exporta as log format "*/ "
        index codigo is primary unique cod-estabel
        index exporta log-exporta.  

    def temp-table tt-old-item no-undo like item
        use-index codigo.    

    def temp-table tt-familia NO-UNDO like familia.

    def new shared temp-table tt-item-1 no-undo

    field it-codigo  like item.it-codigo    
    field rw-item    as   rowid
    field diferencas as char  format "x(100)"
    field des-erro   as char  format "x(60)"
    index it it-codigo.

    def var l-cancelar as logical no-undo. 
    def var l-modific  as logical no-undo.  
    def var l-anterior as logical initial yes no-undo. 

&ENDIF


DEFINE VARIABLE h-cd0204-crm  AS HANDLE  NO-UNDO.
DEFINE VARIABLE lIntCRM11     AS LOGICAL NO-UNDO INITIAL FALSE.
RUN utp/ut-crm11.p (OUTPUT lIntCRM11).



/* Integracao Modulo Importacao ***********/
   def var h-vb2in172 as handle no-undo.
/******************************************/
/* Integraá∆o Neogrid/CRM */
   def var c-acao as char no-undo.

/* Local Definitions for EAI                                   */
{cdp/cd9043.i} /* Definiá∆o da tabela de erros RowErros */
DEF VAR c-action AS CHARACTER FORMAT "X(8)" NO-UNDO.
DEFINE TEMP-TABLE tt-item-eai NO-UNDO LIKE ITEM.
DEF VAR hShowMsg AS HANDLE NO-UNDO.
&IF DEFINED (bf_man_204) &THEN 
  DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO. 
  DEFINE VARIABLE i-ind-class-item AS INTEGER    NO-UNDO.
  DEF NEW GLOBAL SHARED VAR whg-cd0204Integracao AS WIDGET-HANDLE NO-UNDO.
&ENDIF

/** Integraá∆o MES X PPI-Multitask **/
DEFINE TEMP-TABLE RowErrorsMes NO-UNDO LIKE RowErrors.
DEFINE VARIABLE cChave         AS CHARACTER NO-UNDO. 
DEFINE VARIABLE cXML           AS LONGCHAR  NO-UNDO. 
DEFINE VARIABLE cXMLAux        AS LONGCHAR  NO-UNDO. 
DEFINE VARIABLE cDescMsgRet    AS CHARACTER NO-UNDO.   
DEFINE VARIABLE h-cdapi990     AS HANDLE    NO-UNDO. 
DEFINE VARIABLE h-cdapi024     AS HANDLE    NO-UNDO.  

{cdp/cdapi990.i2} /* tt-cria-pendencia */

DEFINE VARIABLE c-trad-contr   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-trad-con-est AS CHARACTER NO-UNDO.
{utp/ut-liter.i "DÇbito Direto" *}
ASSIGN c-trad-contr = RETURN-VALUE.
{utp/ut-liter.i "Serial" *}
ASSIGN c-trad-con-est = RETURN-VALUE.


/* Integracao Fluig *************/
DEFINE VARIABLE hFluig       AS HANDLE              NO-UNDO.
DEFINE VARIABLE l-checkFluig AS LOGICAL INITIAL NO  NO-UNDO.

/********************************************/

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.desc-item 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS bt-cria-wf rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS item.it-codigo item.desc-item 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS item.it-codigo 
&Scoped-define ADM-ASSIGN-FIELDS item.it-codigo 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  (input c-campo as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cria-wf 
     IMAGE-UP FILE "image/im-estru.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-estri.bmp":U NO-FOCUS
     LABEL "" 
     SIZE 4 BY 1.08 TOOLTIP "Criar workflow".

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     bt-cria-wf AT ROW 1.08 COL 84.57 WIDGET-ID 2
     item.it-codigo AT ROW 1.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     item.desc-item AT ROW 2.71 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 61.14 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
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
         HEIGHT             = 3.17
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN item.it-codigo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
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

&Scoped-define SELF-NAME bt-cria-wf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cria-wf V-table-Win
ON CHOOSE OF bt-cria-wf IN FRAME f-main
DO:
  RUN cdp/cd0204wf.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.it-codigo V-table-Win
ON LEAVE OF item.it-codigo IN FRAME f-main /* Item */
DO:
  /*** Rotina utilizada especificamente para o programa de cadastro de itens ***/

  def var c-handles as char no-undo.

  RUN get-link-handle IN adm-broker-hdl (INPUT this-procedure,
                                         INPUT 'chave-target',
                                         OUTPUT c-handles).

  if c-handles <> '' then 
     run pi-seta-campo in widget-handle(entry(1,c-handles)).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
find first param-global NO-LOCK NO-ERROR.

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRowErrorsByMES V-table-Win 
PROCEDURE createRowErrorsByMES :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    FOR EACH RowErrorsMes:
        CREATE RowErrors.
        BUFFER-COPY RowErrorsMes TO RowErrors. 
    END.
    
    EMPTY TEMP-TABLE rowErrorsMes NO-ERROR.
    
    RETURN "OK":U.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-inclusao AS CHARACTER FORMAT "X(9)" NO-UNDO.
    {utp/ut-liter.i "inclus∆o" *}
    ASSIGN c-inclusao = TRIM(RETURN-VALUE).

     DEFINE VARIABLE c-item AS CHARACTER FORMAT "X(4)" NO-UNDO.
    {utp/ut-liter.i "Item" *}
    ASSIGN c-item = TRIM(RETURN-VALUE).

  /* Code placed here will execute PRIOR to standard behavior. */
  run new-state ('new-record':U).

   &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN

          IF CAN-FIND(FIRST funcao
                      WHERE funcao.cd-funcao = "spp-sgt"
                      AND   funcao.ativo = YES)  THEN DO:
             RUN utp/ut-msgs.p (input "show",
                                input 33548,
                                input c-inclusao + "~~" + c-item ).

             RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                         OUTPUT c-handle).

             RUN pi-disable-cancel in widget-handle(c-handle).
             RETURN 'adm-error'.
      END.
   &endif.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :

/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
-----------------------------------------------------------------------------*/
    /*Verifica se ouve alteraá∆o na descriá∆o do item, se ouver roda a procedure
      para efetivar a gravaá∆o dos dados*/

    IF CONNECTED("mgfis")
    AND i-pais-impto-usuario = 1 THEN DO:
        IF AVAIL ITEM 
        AND not adm-new-record /* Somente quando for uma alteraá∆o, em casos de c¢pia n∆o deve ser criado o registro de alteraá∆o */
        AND trim(ITEM.desc-item) <> trim(ITEM.desc-item:SCREEN-VALUE IN FRAME {&FRAME-NAME})  THEN DO: 
            RUN fibo/bofi282.p PERSISTENT SET h-bofi282.
            RUN gravaAlteracao IN h-bofi282 (INPUT ITEM.it-codigo,
                                             INPUT ITEM.desc-item,
                                             INPUT ITEM.desc-item:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
            DELETE PROCEDURE h-bofi282.
            ASSIGN h-bofi282 = ?.
        END.
    END.

   /*Alimenta variﬂvel i-ind-class-fam com valor da UPC da Agroind∑stria*/
      
   IF NOT AVAIL param-global THEN
      FIND FIRST param-global NO-LOCK NO-ERROR.

   &IF DEFINED (bf_man_206) &THEN
      IF param-global.ind-int-agro = YES THEN DO:
   &ELSE
      IF substr(param-global.char-2,21,1) =  "1" THEN DO:
   &ENDIF
      
          &IF DEFINED (bf_man_204) &THEN  
              IF c-nom-prog-upc-mg97 <> "" AND 
                 c-nom-prog-upc-mg97 <> ?  AND
                 VALID-HANDLE(whg-cd0204Integracao) AND
                 (search("cdp/cd0204-upca.r") <> ? OR 
                  search("cdp/cd0204-upca.p") <> ?) THEN DO:
                 ASSIGN i-ind-class-item = int(trim(STRING({ininc/i99in172.i 6 whg-cd0204Integracao:SCREEN-VALUE}))).
              END.
          &ENDIF
      END.


    &IF DEFINED (bf_man_203) &THEN        
        for each tt-old-item:
            delete tt-old-item.
        end.
        if not adm-new-record     and avail ITEM then do:    
           create tt-old-item.
           buffer-copy item to tt-old-item.
        end.

        if adm-new-record    = YES  and  /* Copia */
           adm-adding-record = NO then do:    
           create tt-old-item.
           buffer-copy item to tt-old-item.
        end.
    &ENDIF

    do  transaction:
        {include/i-valid.i}
        assign l-cria = adm-new-record
               l-copy = adm-adding-record.

        for each tt-item-2:
            delete tt-item-2.
        end.

        create tt-item-2.
        if  not adm-new-record then
            buffer-copy item to tt-item-2.
        ELSE 
            ASSIGN tt-item-2.it-codigo = item.it-codigo:SCREEN-VALUE.

        assign  c-aux                   = f-retorna-campo ("cb-cod-obsoleto":U).  
        ASSIGN  tt-item-2.cod-obsoleto  = {ininc/i17in172.i 06 c-aux}.   

        IF tt-item-2.cod-obsoleto = 4 THEN DO:

            IF CAN-FIND(FIRST ord-prod
                        WHERE ord-prod.it-codigo = tt-item-2.it-codigo
                          AND ord-prod.estado < 7)  THEN DO:

                RUN utp/ut-msgs.p(INPUT "show",
                                  INPUT 55911,
                                  INPUT ITEM.it-codigo).
    
                IF RETURN-VALUE = "YES":U THEN
                    RUN cpp/cp0204.w(INPUT ROWID(ITEM),
                                     INPUT 1).
            END.

            /*Verifica a existencia de ordens de compra confirmadas e com saldo*/
            IF CAN-FIND(FIRST prazo-compra 
                        WHERE prazo-compra.it-codigo   = tt-item-2.it-codigo
                          AND prazo-compra.situacao    = 2 /*Confirmada*/
                          AND prazo-compra.quant-saldo > 0) THEN DO:

                RUN utp/ut-msgs.p(INPUT "show",
                                  INPUT 56155,
                                  INPUT ITEM.it-codigo).
            END.
        END.
     
        ASSIGN  c-aux                   = f-retorna-campo ("cb-ind-serv-mat":U)
                tt-item-2.ind-serv-mat  = {ininc/i08in172.i 06 c-aux}
                tt-item-2.ge-codigo     = integer (f-retorna-campo ("ge-codigo":U))
                tt-item-2.fm-codigo     = f-retorna-campo ("fm-codigo":U)
                tt-item-2.fm-cod-com    = f-retorna-campo ("fm-cod-com":U)
                tt-item-2.un            = f-retorna-campo ("un":U)
                tt-item-2.cod-estabel   = f-retorna-campo ("cod-estabel":U)               
                tt-item-2.data-implant  = date (f-retorna-campo ("data-implant":U))
                tt-item-2.data-liberac  = date (f-retorna-campo ("data-liberac":U))
                tt-item-2.cd-folh-item  = f-retorna-campo ("cd-folh-item":U)
                tt-item-2.lote-economi  = decimal (f-retorna-campo ("lote-economi":U))
                tt-item-2.codigo-refer  = f-retorna-campo ("codigo-refer":U)
                tt-item-2.inform-compl  = f-retorna-campo ("inform-compl":U)
                tt-item-2.cod-imagem    = f-retorna-campo ("cod-imagem":U).

         FIND FIRST familia WHERE familia.fm-codigo = TT-ITEM-2.fm-codigo NO-LOCK NO-ERROR.        

         /* foi incluida a utilizacao da var. l-cria aqui por problemas no oracle */
         /* quando banco oracle, neste ponto a tab. item ja esta disponivel no adm-new-record */

         IF NOT l-cria AND AVAIL ITEM THEN
             ASSIGN tt-item-2.tipo-contr    = ITEM.tipo-contr 
                    tt-item-2.tipo-con-est  = ITEM.tipo-con-est 
                    tt-item-2.politica      = ITEM.politica 
                    tt-item-2.ind-item-fat  = ITEM.ind-item-fat.
        ELSE
            ASSIGN tt-item-2.tipo-contr   = IF familia.tipo-contr   = 0 OR familia.tipo-contr = 5 THEN 2 ELSE familia.tipo-contr
                   tt-item-2.tipo-con-est = IF familia.tipo-con-est = 0 THEN 1 ELSE familia.tipo-con-est
                   tt-item-2.politica     = IF familia.politica     = 0 THEN 1 ELSE familia.politica
                   tt-item-2.class-fiscal = familia.class-fiscal 
                   tt-item-2.ind-item-fat = NO.

        &IF DEFINED (bf_man_custeio_item) &THEN   
        &else              
        assign  c-aux                   = f-retorna-campo ("cb-tipo-controle":U).
             IF c-aux <> "" THEN
               ASSIGN tt-item-2.tipo-contr    = {ininc/i09in122.i 06 c-aux}.
        &endIF.

        if tt-item-2.tipo-contr = 4 and tt-item-2.tipo-con-est <> 1 then do:
            RUN utp/ut-msgs.p (INPUT 'show',
                               INPUT 54561, 
                               INPUT  c-trad-contr + '~~' + c-trad-con-est).
            RETURN "ADM-ERROR":U.
        end.            
                
        if  not adm-new-record then do:      
            run pi-validate-item.        
            if  return-value <> 'ok' and return-value <> '' then do:
                run pi-apresenta-erros.
                return "ADM-ERROR":U.
            end.
        end.

        /* Dispatch standard ADM method.                             */
        
        IF AVAIL ITEM THEN
            ASSIGN c-item-copy = ITEM.it-codigo.
          
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).
        if  return-value = 'ADM-ERROR':U THEN
            return 'ADM-ERROR':U.

                        
        ASSIGN tt-item-2.peso-liquido = ITEM.peso-liquido 
               tt-item-2.peso-bruto   = ITEM.peso-bruto NO-ERROR.


        if adm-new-record = yes and adm-adding-record = no then do:   

           assign tt-item-2.it-codigo =  input frame {&frame-name} item.it-codigo.

           run cdp/cd0204m.p (input table tt-item-2) . /* EPC */

        end.  

        if  return-value = 'ADM-ERROR':U THEN
            return 'ADM-ERROR':U.

        /******** EMS 2.02 **********/
        &IF DEFINED(bf_mat_tipo_ressup) &THEN
            if l-copy and
               l-cria then
                run cdp/cd0204a.p (input "", input 1, input rowid(item)).
            else if not l-copy and
                    l-cria then
                run cdp/cd0204a.p (input c-it-codigo, input 3, input rowid(item)).

            if  return-value = 'NOK':U THEN
                return 'ADM-ERROR':U.
        &ENDIF 

        /*** Gera item-man ***/
        &IF DEFINED (bf_man_sfc_lc) &THEN
            find first item-man
                 where item-man.it-codigo = item.it-codigo exclusive-lock no-error.
            if  not avail item-man then
                create item-man.
                buffer-copy item except char-1 char-2 int-1 dec-1 to item-man.    
                release item-man.
        &ENDIF

        /******* Integraªío EMS x SISDOC ******/
        if  i-integracao-sisdoc = ? then do:
            RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                        OUTPUT c-handle).
            run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
        end.
        
        IF CAN-FIND (FIRST saldo-estoq WHERE
                     saldo-estoq.it-codigo = ITEM.it-codigo) OR
            CAN-FIND (FIRST movto-estoq WHERE
                     movto-estoq.it-codigo = ITEM.it-codigo) OR
            CAN-FIND (FIRST movto-mat WHERE
                     movto-mat.it-codigo   = ITEM.it-codigo) THEN DO:

            
            buffer-copy tt-item-2 USING IND-ITEM-FAT
                                        POLITICA
                                        cod-obsoleto 
                                        peso-liquido 
                                        peso-bruto
                                        class-fiscal 
                                        &IF DEFINED (bf_mat_versao_ems) &THEN
                                        &ELSE
                                        ind-serv-mat
                                        &ENDIF 
                                        to item.
            
        END.
        ELSE
            buffer-copy tt-item-2 USING TIPO-CON-EST
                                        IND-ITEM-FAT
                                        POLITICA
                                        cod-obsoleto 
                                        peso-liquido 
                                        peso-bruto
                                        tipo-contr
                                        &IF DEFINED (bf_mat_versao_ems) &THEN
                                        &ELSE
                                        ind-serv-mat
                                        &ENDIF 
                                        to item.

            
        ASSIGN item.peso-liquido = tt-item-2.peso-liquido
               ITEM.peso-bruto   = tt-item-2.peso-bruto
               ITEM.cod-obsoleto = tt-item-2.cod-obsoleto
               ITEM.class-fiscal = tt-item-2.class-fiscal  NO-ERROR.

        &IF DEFINED(bf_dis_aloc_neg_pre) &THEN
            FIND item-dist WHERE
                 item-dist.it-codigo = item.it-codigo NO-LOCK NO-ERROR.
            IF  NOT AVAILABLE(item-dist) THEN DO:
                CREATE item-dist.
                ASSIGN item-dist.it-codigo = item.it-codigo.                

                if  not l-copy 
                and l-cria THEN DO:
                    FOR FIRST b-item-dist NO-LOCK
                        WHERE b-item-dist.it-codigo = c-it-codigo:
                        BUFFER-COPY b-item-dist EXCEPT it-codigo TO item-dist.
                    END.
                END.
                ELSE DO:
                    find first fam-comerc where fam-comerc.fm-cod-com = tt-item-2.fm-cod-com no-lock no-error.
                    if avail fam-comerc then
                        assign item-dist.log-aloc-neg = fam-comerc.log-aloc-neg.
                END.
                release item-dist.
            END.
        &ENDIF
        
        assign i-novo = if item.it-codigo:sensitive in frame {&frame-name} 
                                then 1 else 2.
        
        /*/********************Multiplanta***********************/
        
        assign c-transacao = "MAN003".
        {cdp/cd7300.i5 "001" c-transacao}
        assign i-tipo-movto = if item.it-codigo:sensitive in frame {&frame-name} 
                              then 1 else 2.

        if  param-global.modulo-mp and tt-replica-msg.log-replica-msg then do: 
            create tt-item-aux.
            buffer-copy item to tt-item-aux.
            create tt-dados-env.                  
            assign tt-dados-env.num-sequencia  = i-seq 
                   tt-dados-env.cod-tipo-reg   = 3
                   tt-dados-env.ind-tipo-movto = i-tipo-movto
                   tt-dados-env.identif-msg    = item.it-codigo.
            raw-transfer tt-item-aux to tt-dados-env.conteudo-msg.                                     
            assign i-seq = i-seq + 1.                                     
        end.
        {cdp/cd7300.i6 "001" c-transacao}
        /******************Fim-Multiplanta********************/  */

        &IF DEFINED (bf_man_203) &THEN
            if  l-cria = YES and
                l-copy = NO  THEN DO:
                /* Copia                                                                            */
                /* Se for copia n∆o pode atualizar os dados do item conforme a familia de materiais */
                ASSIGN ITEM.log-1 = YES.

                FIND tt-old-item NO-ERROR.
                IF AVAIL tt-old-item THEN DO:
                  FIND b1-item 
                      WHERE b1-item.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR.

                  IF AVAIL b1-item
                  AND tt-old-item.fm-codigo = b1-item.fm-codigo THEN
                      ASSIGN b1-item.class-fiscal = tt-old-item.class-fiscal. 
                 
                   BUFFER-COPY tt-old-item EXCEPT it-codigo 
                                                  desc-item
                                                  ge-codigo
                                                  fm-codigo
                                                  fm-cod-com
                                                  un
                                                  cod-estabel
                                                  data-implant
                                                  data-liberac
                                                  cd-folh-item
                                                  lote-economi
                                                  codigo-refer
                                                  inform-compl
                                                  cod-imagem
                                                  niv-mais-bai
                                                  narrativa
                                                  log-1 
                                                  cd-folh-item 
                                                  log-necessita-li
                                                  compr-fabric
                                                  preco-base 
                                                  preco-fiscal 
                                                  preco-repos 
                                                  preco-ul-ent 
                                                  data-ult-rep
                                                  data-base
                                                  data-ult-ent
                                                  data-ult-sai
                                                  consumo-prev
                                                  cod-obsoleto
                                                  ind-serv-mat
                                                  idi-classif-item
                                                  class-fiscal 
/*                                                   politica     */
/*                                                   demanda      */
/*                                                   lote-multipl */
/*                                                   lote-minimo  */
/*                                                   fator-refugo */
/*                                                   quant-perda  */
/*                                                   periodo-fixo */
/*                                                   tipo-con-est */
/*                                                   classe-repro */
/*                                                   emissao-ord  */
/*                                                   res-int-comp */
/*                                                   res-for-comp */
/*                                                   res-cq-comp  */
/*                                                   ressup-fabri */
                                                  /*cod-obsoleto*/
                            TO b1-item.
                   


/*                    ASSIGN b1-item.peso-liquido = tt-item-2.peso-liquido           */
/*                           b1-item.peso-bruto   = tt-item-2.peso-bruto             */
/*                           b1-item.cod-obsoleto = tt-item-2.cod-obsoleto NO-ERROR. */


    /*                ASSIGN b1-ITEM.log-1 = NO. */
                   ASSIGN  c-aux = f-retorna-campo ("cb-tipo-controle":U).
                   IF c-aux <> "" THEN
                           ASSIGN b1-item.tipo-contr = {ininc/i09in122.i 06 c-aux}.


                END.
            END.
           &ENDIF
            

    /*INTEGRACAO HIS - Hospitalar*/
    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
      IF CAN-FIND(funcao 
                  WHERE funcao.cd-funcao = "spp-integra-ems-his":U
                    AND funcao.ativo = YES) AND 
         adm-new-record THEN DO:

          FIND FIRST grup-estoq NO-LOCK
               WHERE grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.

          FIND FIRST familia NO-LOCK
               WHERE familia.fm-codigo    = ITEM.fm-codigo NO-ERROR.

          &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
              IF grup-estoque.log-orig-ext OR familia.log-orig-ext                    THEN
                 ASSIGN ITEM.log-orig-ext = YES.
              ELSE
                 ASSIGN ITEM.log-orig-ext = NO.
          &ELSE
              IF grup-estoque.log-1        OR SUBSTRING(familia.char-1,154,1) = "S":U THEN 
                 ASSIGN OVERLAY(ITEM.CHAR-1,267,1) = "S":U.
              ELSE
                 ASSIGN OVERLAY(ITEM.CHAR-1,267,1) = "N":U.
          &ENDIF
      END.
    &ENDIF
    
    IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0204-crm) THEN
        RUN integracoes/adapters/emstocrm/cd0204-crm.p PERSISTENT SET h-cd0204-crm. 
        RUN sendToCRM IN h-cd0204-crm (INPUT ITEM.it-codigo,
                                   OUTPUT TABLE RowErrors).
        IF CAN-FIND (FIRST RowErrors WHERE 
                         RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
            UNDO, RETURN "ADM-ERROR":U.
        END.
        DELETE PROCEDURE h-cd0204-crm.
    END.

    /* Integraá∆o Neogrid  */
    if adm-new-record then
       assign c-acao = "Add".
    else 
       assign c-acao = "Update".

    RUN utp/ut-neog.p.
    IF  RETURN-VALUE = "OK" THEN
        &IF '{&BF_DIS_VERSAO_EMS}' < '2.05' &THEN
        FOR EACH estabelec FIELDS (cod-emitente cod-estabel) NO-LOCK,
            FIRST emitente FIELDS (cod-emitente)
            WHERE emitente.cod-emitente        = estabelec.cod-emitente
            AND   SUBSTR(emitente.char-1,11,1) = "1" NO-LOCK:
        &ELSE
        FOR EACH estabelec FIELDS (cod-emitente cod-estabel) NO-LOCK,
            FIRST dist-emitente FIELDS (cod-emitente)
            WHERE dist-emitente.cod-emitente = estabelec.cod-emitente
            AND   dist-emitente.parceiro-b2b = YES NO-LOCK:
        &ENDIF
            RUN adapters/neogrid/enp/aneen005.p (INPUT ROWID(item),
                                                 INPUT estabelec.cod-estabel,
                                                 INPUT estabelec.cod-emitente,
                                                 INPUT c-acao).
        END.

    /* Integracao EAI - Itens */
    &IF DEFINED (bf_man_204) &THEN 

        IF v_log_eai_habilit THEN DO:
            IF adm-new-record THEN ASSIGN c-action = "add". 
            ELSE ASSIGN c-action = "upd".
        
            CREATE tt-item-eai.
            BUFFER-COPY ITEM TO tt-item-eai.
        
            IF c-nom-prog-upc-mg97 <> "" AND 
               c-nom-prog-upc-mg97 <> ?  AND
               (search("cdp/cd0204-upca.r") <> ? OR 
                search("cdp/cd0204-upca.p") <> ?) THEN DO:
                &IF DEFINED (bf_man_206) &THEN
                    ASSIGN tt-item-eai.idi-classif-item = i-ind-class-item.
                &ELSE
                    ASSIGN OVERLAY(tt-item-eai.CHAR-1,19,1) = trim(STRING(i-ind-class-item)).  
                &ENDIF  
            END.                       

            RUN adapters/xml/ma2/axsma003.p (INPUT  c-action,
                                             INPUT  "cd0204.w",
                                             INPUT  STRING(c-prg-vrs),
                                             INPUT  TABLE tt-item-eai,
                                             OUTPUT TABLE RowErrors).  
        
            DELETE tt-item-eai.
            IF CAN-FIND (FIRST RowErrors WHERE 
                               RowErrors.ErrorSubType = "ERROR":U) THEN DO:

                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="YES"}
                undo, return "ADM-ERROR":U.
            END.
        END.
    &ENDIF

   /*Verifica se o tipo de controle Ç Total ou Consignado,
    est† alteraá∆o foio colocada neste ponto devido que 
    na inclus∆o do item n∆o estava limpando a conta*/
    assign c-aux = f-retorna-campo ("cb-tipo-controle":U).
    if  c-aux <> "" then do:
        if  {ininc/i09in122.i 06 c-aux} = 2
        or  {ininc/i09in122.i 06 c-aux} = 3 then
            assign item.conta-aplicacao = "".
    end.    
      
    IF CONNECTED('mgscm') THEN DO: 
        IF ITEM.cod-obsoleto = 1 THEN DO:
            IF NOT VALID-HANDLE(hDBOproxy) THEN
                RUN wmp/wmprx044.p PERSISTENT SET hDBOproxy.
            EMPTY TEMP-TABLE ttItemReplica.
            CREATE ttItemReplica.
            ASSIGN ttItemReplica.it-codigo    = ITEM.it-codigo  
                   ttItemReplica.desc-item    = ITEM.desc-item
                   ttItemReplica.unid-med     = ITEM.un
                   ttItemReplica.peso-bruto   = ITEM.peso-bruto
                   ttItemReplica.largura      = ITEM.largura
                   ttItemReplica.comprimento  = ITEM.comprim
                   ttItemReplica.altura       = ITEM.altura
                   ttItemReplica.tipo-con-est = ITEM.tipo-con-est
                   ttItemReplica.fm-cod-com   = ITEM.fm-cod-com
                   ttItemReplica.fm-codigo    = ITEM.fm-codigo.
            RUN ReplicaItem IN hDBOproxy(INPUT TABLE ttItemReplica,
                                         OUTPUT TABLE RowErrors).
            IF RETURN-VALUE = 'NOK':U THEN DO:
                FOR EACH RowErrors:
                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT RowErrors.ErrorNumber,
                                       INPUT RowErrors.ErrorParameters).
                    IF RowErrors.ErrorNumber = 36 THEN
                        RUN utp/ut-msgs.p (INPUT "show":U,
                                           INPUT 34497, INPUT ITEM.it-codigo + "~~" + "WMS").
                END.    
            END.
            RUN destroy IN hDBOproxy.
        END.
    END.
                                              
    &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
        /** Integracao EAI2 **/
        
        /* Carrega a vari†vel global v_log_eai2_ativado */
        RUN cdp/cd0101i.p. 
       
        IF v_log_eai2_ativado THEN DO: 

           IF NOT VALID-HANDLE(h-cdapi998) OR
              h-cdapi998:TYPE <> "PROCEDURE":U OR
              h-cdapi998:FILE-NAME <> "cdp/cdapi998.p":U THEN DO:
              RUN cdp/cdapi998.p PERSISTENT SET h-cdapi998. 
           END. 
                                              
           RUN pi-sendUpsertItem IN h-cdapi998 (INPUT ROWID(Item), INPUT "Async":U, OUTPUT TABLE RowErrors).                           

           IF VALID-HANDLE(h-cdapi998) AND
              h-cdapi998:TYPE = "PROCEDURE":U AND
              h-cdapi998:FILE-NAME = "cdp/cdapi998.p":U THEN DO:
              DELETE PROCEDURE h-cdapi998 NO-ERROR.
              ASSIGN h-cdapi998 = ?.
           END. 

           IF CAN-FIND(FIRST RowErrors) THEN DO:
              {method/showmessage.i1}
              {method/showmessage.i2}
              {method/showmessage.i3}
              UNDO, RETURN "ADM-ERROR".
           END.                     
        END.
    &ENDIF

    /** Integraá∆o MES X PPI-Multitask **/    
    FIND param-cp NO-LOCK NO-ERROR.
    IF AVAIL param-cp AND param-cp.log-integr-ppi-mes THEN DO:
        
        EMPTY TEMP-TABLE rowErrorsMes NO-ERROR.
        
        IF NOT VALID-HANDLE(h-cdapi998) OR
        h-cdapi998:TYPE <> "PROCEDURE":U OR
        h-cdapi998:FILE-NAME <> "cdp/cdapi998.p":U THEN DO:
            RUN cdp/cdapi998.p PERSISTENT SET h-cdapi998. 
        END. 
        
        /* CRIACAO PENDENCIAS */
        IF NOT VALID-HANDLE(h-cdapi990) OR
        h-cdapi990:TYPE <> "PROCEDURE":U OR
        h-cdapi990:FILE-NAME <> "cdp/cdapi990.p":U THEN DO:
            RUN cdp/cdapi990.p PERSISTENT SET h-cdapi990. 
        END.
        
        /* Se for alteraá∆o, sempre manda mensagem.
          Se for inclusao, valida se o item Ç diferente de totalmente obsoleto (4) */  
        IF NOT adm-new-record
        OR (adm-new-record AND item.cod-obsoleto <> 4) THEN DO:
            RUN pi-SendDirectUpsertItem IN h-cdapi998 (INPUT ROWID(item),
                                                       OUTPUT cXml, 
                                                       OUTPUT cChave,
                                                       OUTPUT TABLE rowErrorsMes).  
            IF CAN-FIND(FIRST rowErrorsMes) THEN DO: 
                /** Tela de confirmacao **/
                    {utp/ut-liter.i do_item * }
                    RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                       INPUT 54394, 
                                       INPUT RETURN-VALUE + " ":U + item.it-codigo).
                                        
                IF RETURN-VALUE = "YES":U THEN DO:                       
                    ASSIGN cDescMsgRet = ""
                           cXMLAux     = cXML. 
                    /* Busca todas as descricoes de erro para salvar na tabela de pendencias */
                    FOR EACH rowErrorsMes:
                        ASSIGN cDescMsgRet = cDescMsgRet + rowErrorsMes.errorDescription + chr(10).
                    END.
                    EMPTY TEMP-TABLE tt-cria-pendencia NO-ERROR.
                    DO WHILE(TRUE):
                        CREATE tt-cria-pendencia.
                        ASSIGN tt-cria-pendencia.cTransaction      = "Item":U
                               tt-cria-pendencia.cInternalId       = cChave 
                               tt-cria-pendencia.cErrorDescription = cDescMsgRet.
                               tt-cria-pendencia.iTipStatus        = 1. /* Pendente com Erro */
                         /* Se o xml conter mais de 9990 caracteres, quebra a variavel */   
                        IF LENGTH(cXMLAux) > 9990 THEN DO:
                            ASSIGN tt-cria-pendencia.cXml  =  SUBSTR(cXMLAux, 1, 9990)     
                                   SUBSTR(cXMLAux,1, 9990) = "":U. 
                        END.
                        ELSE DO:  /* se tiver menos que 9990 caracteres, salva o conteudo e sai do while */ 
                            ASSIGN tt-cria-pendencia.cXml = cXMLAux. 
                            LEAVE. 
                        END.
                    END. /*while */                   
                    EMPTY TEMP-TABLE rowErrorsMes NO-ERROR.
                    RUN createPendency IN h-cdapi990(INPUT  TABLE tt-cria-pendencia, 
                                                     OUTPUT TABLE rowErrorsMes).   

                END.
                ELSE DO:
                
                    UNDO, RETURN "ADM-ERROR":U.
                END.
            END. /* can find rowewrrormes*/  
            ELSE DO:
                /* Se o retorno for ok, verifica se existe pendencia para a chave. Se tiver, exlui */           
                IF CAN-FIND(FIRST pendcia-integr-mes 
                            WHERE pendcia-integr-mes.cod-chave-ident = cChave) THEN
                    RUN deletePendciaByIdentif IN h-cdapi990 (INPUT cChave).                        
            END.    
            EMPTY TEMP-TABLE rowErrorsMes NO-ERROR.
            /* TODO: INCLUIR NA FASE 2 DA INTEGRACAO MES TOTVS ATRAVES DE PARAMETRO
            RUN pi-exporta-mensagem  IN h-cdapi998 (INPUT cXML,
                                                    INPUT "Item":U, 
                                                    INPUT cChave,
                                                    INPUT 1, /* Pendente com Erro */
                                                    OUTPUT TABLE rowErrorsMes).*/
        END.
        IF VALID-HANDLE(h-cdapi990) AND
            h-cdapi990:TYPE = "PROCEDURE":U AND
            h-cdapi990:FILE-NAME = "cdp/cdapi990.p":U THEN DO:
            DELETE PROCEDURE h-cdapi990 NO-ERROR.
            ASSIGN h-cdapi990 = ?.
        END. 
        
       IF VALID-HANDLE(h-cdapi998) AND
          h-cdapi998:TYPE = "PROCEDURE":U AND
          h-cdapi998:FILE-NAME = "cdp/cdapi998.p":U THEN DO:
          DELETE PROCEDURE h-cdapi998 NO-ERROR.
          ASSIGN h-cdapi998 = ?.
       END. 
        
        /* Cria a rowErrors com base na rowErrosMes*/
        IF CAN-FIND(FIRST rowErrorsMes) THEN
            RUN createRowErrorsByMES.
            
        IF CAN-FIND(FIRST RowErrors) THEN DO:
             {method/showmessage.i1}
             {method/showmessage.i2 &Modal="YES"}
             {method/showmessage.i3}
             RETURN "ADM-ERROR".
        END.             
    END. /* AVAIL CP-PARAM*/    

    IF i-pais-impto-usuario = 2 
        AND c-item-copy <> "" 
        AND (c-item-copy <> input frame {&frame-name} item.it-codigo) THEN DO:

        RUN local/arg/boar2006.p PERSISTENT SET h-boar2006.
        RUN pi-copia-despacho IN h-boar2006 (INPUT c-item-copy,
                                             INPUT input frame {&frame-name} item.it-codigo).

        RUN destroy IN h-boar2006.
        ASSIGN h-boar2006 = ?
               c-item-copy = "".


    END.
    
    IF (ITEM.cod-obsoleto = 4) THEN DO:
        FOR EACH portal-reg-clien EXCLUSIVE-LOCK
        WHERE portal-reg-clien.cod-tabela = "ITEM"
        AND portal-reg-clien.cod-item = ITEM.it-codigo:
            DELETE portal-reg-clien.    
        END.
    END.

    RUN piIntegracao(INPUT IF c-acao = "Add" THEN "CREATE" ELSE "UPDATE").

   END. /* do transaction */
  
   FINALLY:              
        IF VALID-HANDLE(h-cdapi990) THEN DO:
            DELETE PROCEDURE h-cdapi990 NO-ERROR.
            ASSIGN h-cdapi990 = ?.
        END. 
        
       IF VALID-HANDLE(h-cdapi998) THEN DO:
          DELETE PROCEDURE h-cdapi998 NO-ERROR.
          ASSIGN h-cdapi998 = ?.
       END.       
   END FINALLY.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /*** Deixar este bloco porque pode acontecer algum erro por falha de 
       base (familia), teoricamente nío deveria acontecer nenhum erro ***/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
    blk_comp-folh:
    FOR  EACH it-carac-tec 
        where it-carac-tec.it-codigo = item.it-codigo no-lock.

        find comp-folh where 
             comp-folh.cd-folha   = it-carac-tec.cd-folha and
             comp-folh.cd-comp    = it-carac-tec.cd-comp  and 
             comp-folh.log-estado = yes no-lock no-error.

        if available comp-folh then DO:
           assign l-copia = yes.
           LEAVE blk_comp-folh.
        END.
    end.

    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-copia AS CHARACTER FORMAT "X(5)" NO-UNDO.
    {utp/ut-liter.i "Copia" *}
    ASSIGN c-copia = TRIM(RETURN-VALUE).

     DEFINE VARIABLE c-item_copia AS CHARACTER FORMAT "X(4)" NO-UNDO.
    {utp/ut-liter.i "item" *}
    ASSIGN c-item_copia = TRIM(RETURN-VALUE).

    &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
    
           IF CAN-FIND(FIRST funcao
                       WHERE funcao.cd-funcao = "spp-sgt"
                       AND   funcao.ativo = YES)  THEN DO:
              RUN utp/ut-msgs.p (input "show",
                                 input 33548,
                                 input c-copia + "~~" + c-item_copia ).
              RETURN "adm-error":U.
       END.
    &endif.

  assign rw-old-item = rowid(item).

  /*ASSIGN de-peso-bruto = ITEM.peso-bruto
         de-peso-liq   = ITEM.peso-liquido.*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  /******* Integracao EMS x SISDOC ******/

  /* Inicio -- Projeto Internacional */
  DEFINE VARIABLE c-eliminacao AS CHARACTER FORMAT "X(13)" NO-UNDO.
  {utp/ut-liter.i "Eliminaá∆o" *}
  ASSIGN c-eliminacao = TRIM(RETURN-VALUE).

  DEFINE VARIABLE c-item_eliminacao AS CHARACTER FORMAT "X(4)" NO-UNDO.
  {utp/ut-liter.i "Item" *}
  ASSIGN c-item_eliminacao = TRIM(RETURN-VALUE).

  &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
    IF CAN-FIND(FIRST funcao
                WHERE funcao.cd-funcao = "spp-sgt"
                  AND   funcao.ativo = YES)  THEN DO:
      RUN utp/ut-msgs.p (INPUT "show",
                         INPUT 33548,
                         INPUT c-eliminacao + "~~" + c-item_eliminacao ).
      RETURN 'adm-error'.
    END.
  &ENDIF

  IF i-integracao-sisdoc = ? THEN DO:
    RUN Who-Is-The-Container IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                               OUTPUT c-handle).
    RUN pi-atualiza-var IN WIDGET-HANDLE(c-handle) (OUTPUT i-integracao-sisdoc).
  END.

  if  i-integracao-sisdoc = 2 then
      assign c-opcao-int = "nao-integra".
  if  i-integracao-sisdoc = 3 then
      assign c-opcao-int = "elimina0204". 

  /***** Fim Integraªío EMS x SISDOC ****/


/*********************************** ATENCAO USO DE PREPROCESSADOR ******************************/

  /* Inicio -- Projeto Internacional */
  DEFINE VARIABLE c-item_grp AS CHARACTER FORMAT "X(4)" NO-UNDO.
  {utp/ut-liter.i "Item" *}
  ASSIGN c-item_grp = TRIM(RETURN-VALUE).

  DEFINE VARIABLE c-relatorio_com_grupo_item_grp AS CHARACTER FORMAT "X(41)" NO-UNDO.
  {utp/ut-liter.i "relaá∆o com Grupo de Embarque (EQ0102)" *}
  ASSIGN c-relatorio_com_grupo_item_grp = TRIM(RETURN-VALUE).

  DEFINE VARIABLE c-item_possui_relatorio_item_grp AS CHARACTER FORMAT "X(41)" NO-UNDO.
  {utp/ut-liter.i "Item possui relaá∆o com Grupo de Embarque," *}
  ASSIGN c-item_possui_relatorio_item_grp = TRIM(RETURN-VALUE).

  &if '{&bf_dis_versao_ems}' >= '2.062' &then /* INICIO PREPROCESSADOR */

     /*******************************************************/
     /** Verifica relacionamento com tabela Grupo Embarque **/
     /*******************************************************/

     if can-find (first eq-item-grp-embarq where
                        eq-item-grp-embarq.it-codigo = item.it-codigo) then do:
        run utp/ut-msgs.p (input "show",
                           input 1170,
                           input c-item_grp + "~~" + c-relatorio_com_grupo_item_grp + "~~" + c-item_possui_relatorio_item_grp).
        return 'ADM-ERROR'.
     end.

  &endif   /* FIM PREPROCESSADOR */
  
  /* Inicio -- Projeto Internacional */
  DEFINE VARIABLE c-item_embarq AS CHARACTER FORMAT "X(4)" NO-UNDO.
  {utp/ut-liter.i "Item" *}
  ASSIGN c-item_embarq = TRIM(RETURN-VALUE).

  DEFINE VARIABLE c-relatorio_com_item_embarq AS CHARACTER FORMAT "X(40)" NO-UNDO.
  {utp/ut-liter.i "relaá∆o com Item x Embalagem (CD0128)" *}
  ASSIGN c-relatorio_com_item_embarq = TRIM(RETURN-VALUE).

  DEFINE VARIABLE c-item_possui_relatorio_item_embarq AS CHARACTER FORMAT "X(44)" NO-UNDO.
  {utp/ut-liter.i "Item possui relaá∆o com Item x Embalagem," *}
  ASSIGN c-item_possui_relatorio_item_embarq = TRIM(RETURN-VALUE).

  &if '{&bf_dis_versao_ems}' >= '2.062' &then /* INICIO PREPROCESSADOR */

    /*******************************************************/
    /** Verifica relacionamento com tabela Embalagem **/
    /*******************************************************/

    if can-find (first eq-item-embal-embarq where
                       eq-item-embal-embarq.it-codigo = item.it-codigo) then do:
       run utp/ut-msgs.p (input "show",
                          input 1170,
                          input c-item_embarq + "~~" + c-relatorio_com_item_embarq + "~~" + c-item_possui_relatorio_item_embarq).
       return 'ADM-ERROR'.
    end.

  &endif   /* FIM PREPROCESSADOR */

  run pi-valida-eliminacao.

  IF RETURN-VALUE <> "OK":U THEN
    RETURN "ADM-ERROR".

  /******** EMS 2.02 **********/
  &IF DEFINED(bf_mat_tipo_ressup) &THEN
      run cdp/cd0204a.p (input "", input 2, input rowid(item)).
      if  return-value = 'NOK':U THEN
          return 'ADM-ERROR':U.
  &ENDIF 

  /* ELIMINANDO O ITEM DAS TABELAS DO DATA COLLECTION */
  do on error undo, leave:
     if connected("mgcld") then do:
         run bcp/bc8001.p(input item.it-codigo,
                          input "",
                          input "E").
      end.
  end.

  /* Integraá∆o Neogrid  */
  RUN utp/ut-neog.p.
  IF  RETURN-VALUE = "OK" THEN
      &IF '{&BF_DIS_VERSAO_EMS}' < '2.05' &THEN
      FOR EACH estabelec FIELDS (cod-emitente cod-estabel) NO-LOCK,
          FIRST emitente FIELDS (cod-emitente)
          WHERE emitente.cod-emitente        = estabelec.cod-emitente
          AND   SUBSTR(emitente.char-1,11,1) = "1" NO-LOCK:
      &ELSE
      FOR EACH estabelec FIELDS (cod-emitente cod-estabel) NO-LOCK,
          FIRST dist-emitente FIELDS (cod-emitente)
          WHERE dist-emitente.cod-emitente = estabelec.cod-emitente
          AND   dist-emitente.parceiro-b2b = YES NO-LOCK:
      &ENDIF
          RUN adapters/neogrid/enp/aneen005.p (INPUT ROWID(item),
                                               INPUT estabelec.cod-estabel,
                                               INPUT estabelec.cod-emitente,
                                               INPUT "Delete").
      END.

  /* Integracao EAI - Itens */
  &IF DEFINED (bf_man_204) &THEN 
    IF v_log_eai_habilit THEN DO:
        FOR EACH tt-item-eai EXCLUSIVE-LOCK: DELETE tt-item-eai. END.
        CREATE tt-item-eai.
        BUFFER-COPY ITEM TO tt-item-eai.
    END.
  &ENDIF
  
  &IF '{&mgscm_version}' >= '2.06B' &THEN
      IF CONNECTED('mgscm') THEN DO: 
          IF NOT VALID-HANDLE(hDBOproxy) THEN
              RUN wmp/wmprx044.p PERSISTENT SET hDBOproxy.
          RUN EliminaItem IN hDBOproxy(INPUT ITEM.it-codigo,
                                       OUTPUT TABLE RowErrors).
          IF RETURN-VALUE = 'NOK':U THEN DO:
              FOR EACH RowErrors
                  WHERE RowErrors.ErrorType <> 'INTERNAL':U:
                  RUN utp/ut-msgs.p (INPUT "show":U,
                                     INPUT RowErrors.ErrorNumber,
                                     INPUT RowErrors.ErrorParameters).
              END.
              RUN destroy IN hDBOproxy.
              return "ADM-ERROR":U.
          END.
          RUN destroy IN hDBOproxy.
      END.
  &ENDIF

  IF lIntCRM11 THEN DO:
    IF NOT VALID-HANDLE(h-cd0204-crm) THEN DO:
      RUN integracoes/adapters/emstocrm/cd0204-crm.p PERSISTENT SET h-cd0204-crm.           
      RUN deleteFromCRM IN h-cd0204-crm (INPUT ITEM.it-codigo,
                                        OUTPUT TABLE RowErrors).
    END.

    IF CAN-FIND (FIRST RowErrors WHERE 
                       RowErrors.ErrorSubType = "ERROR":U) THEN DO:
      {method/showmessage.i1}
      {method/showmessage.i2 &Modal="YES"}
      UNDO, RETURN "ADM-ERROR":U.
    END.
    DELETE PROCEDURE h-cd0204-crm.
  END.                       

  &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
    IF NOT AVAIL tt-item-eai THEN DO:
        FOR EACH tt-item-eai EXCLUSIVE-LOCK: DELETE tt-item-eai. END.
        CREATE tt-item-eai.
        BUFFER-COPY ITEM TO tt-item-eai.
    END.
  &ENDIF
  
  RUN piIntegracao("DELETE").

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /* Integracao EAI - Itens */
  IF NOT RETURN-VALUE = 'ADM-ERROR':U then DO:
    &IF DEFINED (bf_man_204) &THEN 
      IF v_log_eai_habilit THEN DO:
        IF CAN-FIND (FIRST tt-item-eai) THEN DO:
          RUN adapters/xml/ma2/axsma003.p (INPUT  "del",
                                           INPUT  "cd0204.w",
                                           INPUT  c-prg-vrs,
                                           INPUT  TABLE tt-item-eai,
                                           OUTPUT TABLE RowErrors). 

          IF CAN-FIND (FIRST RowErrors WHERE 
                             RowErrors.ErrorSubType = "ERROR":U) THEN DO:
      
              {method/showmessage.i1}
              {method/showmessage.i2 &Modal="YES"}
              undo, return "ADM-ERROR":U.
          END.
        END.
      END.
    &ENDIF
  END.

  /* Elimina Item no de-para (EAI)*/
  IF EAIEngine:isEnvironmentOK() THEN DO:
      oMapper = ConfigurationManager:Instance:Config-Provider:mapper NO-ERROR.
    
      IF oMapper <> ? THEN DO:
          IF CAN-FIND (FIRST tt-item-eai) THEN
              oMapper:deleteValue("ItemInternalId", STRING(tt-item-eai.it-codigo)).
      END.
  END.

  &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
    /** Integraá∆o EAI2 **/
    
    /* Carrega a vari·vel global v_log_eai2_ativado */
    RUN cdp/cd0101i.p. 
    
    IF v_log_eai2_ativado THEN DO:     
       IF NOT VALID-HANDLE(h-cdapi998) OR
          h-cdapi998:TYPE <> "PROCEDURE":U OR
          h-cdapi998:FILE-NAME <> "cdp/cdapi998.p":U THEN DO:
          RUN cdp/cdapi998.p PERSISTENT SET h-cdapi998. 
       END.          
                                      
       RUN pi-sendDelete IN h-cdapi998 (INPUT TABLE tt-item-eai, INPUT "Async":U, OUTPUT TABLE RowErrors).                      
  
       IF VALID-HANDLE(h-cdapi998) AND
          h-cdapi998:TYPE = "PROCEDURE":U AND
          h-cdapi998:FILE-NAME = "cdp/cdapi998.p":U THEN DO:
          DELETE PROCEDURE h-cdapi998 NO-ERROR.
          ASSIGN h-cdapi998 = ?.
       END. 
  
       IF CAN-FIND(FIRST RowErrors) THEN DO:
          {method/showmessage.i1}
          {method/showmessage.i2 &Modal="YES"}
          {method/showmessage.i3}
          RETURN "ADM-ERROR".
       END.                     
    END.
  &ENDIF
  
    /** Integraá∆o MES X PPI-Multitask **/
    FIND param-cp NO-LOCK NO-ERROR.
    IF AVAIL param-cp AND param-cp.log-integr-ppi-mes THEN DO:
        
        EMPTY TEMP-TABLE rowErrorsMes NO-ERROR.
        
        IF NOT VALID-HANDLE(h-cdapi998) OR
        h-cdapi998:TYPE <> "PROCEDURE":U OR
        h-cdapi998:FILE-NAME <> "cdp/cdapi998.p":U THEN DO:
            RUN cdp/cdapi998.p PERSISTENT SET h-cdapi998. 
        END. 
        
        RUN pi-SendDeleteMes IN h-cdapi998 (INPUT TABLE tt-item-eai, OUTPUT TABLE rowErrorsMes).  
        /* Cria a rowErrors com base na rowErrosMes*/
        IF CAN-FIND(FIRST rowErrorsMes) THEN
            RUN createRowErrorsByMES.
            
        IF VALID-HANDLE(h-cdapi998) AND
           h-cdapi998:TYPE = "PROCEDURE":U AND
           h-cdapi998:FILE-NAME = "cdp/cdapi998.p":U THEN DO:
           DELETE PROCEDURE h-cdapi998 NO-ERROR.
           ASSIGN h-cdapi998 = ?.
        END. 

        IF CAN-FIND(FIRST RowErrors) THEN DO:
             {method/showmessage.i1}
             {method/showmessage.i2 &Modal="YES"}
             {method/showmessage.i3}
             RETURN "ADM-ERROR".
        END.

    END. /* AVAIL CP-PARAM*/    

  IF CAN-FIND(FIRST tt-item-eai) THEN
    DELETE tt-item-eai.

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

  /******* Integraªío EMS x SISDOC ******/

    

    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-alteracao AS CHARACTER FORMAT "X(12)" NO-UNDO.
    {utp/ut-liter.i "Alteraá∆o" *}
    ASSIGN c-alteracao = TRIM(RETURN-VALUE).

    DEFINE VARIABLE c-item_alteracao AS CHARACTER FORMAT "X(4)" NO-UNDO.
    {utp/ut-liter.i "Item" *}
    ASSIGN c-item_alteracao = TRIM(RETURN-VALUE).

  if  not adm-new-record then do:
      &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
    
          IF CAN-FIND(FIRST funcao
                      WHERE funcao.cd-funcao = "spp-sgt"
                      AND   funcao.ativo = YES)  THEN DO:
             RUN utp/ut-msgs.p (input "show",
                                 input 33548,
                                 input c-alteracao + "~~" + c-item_alteracao ).

             RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                      OUTPUT c-handle).

             RUN pi-disable-cancel in widget-handle(c-handle).
             RETURN 'adm-error'.
          END.
      &endif.
      if  i-integracao-sisdoc = ? then do:
          RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                      OUTPUT c-handle).
          run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
      end.    
           
  end.  /* if not adm-new-record */

  /***** Fim Integraªío EMS x SISDOC ****/

  run get-attribute ('adm-new-record').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  assign c-it-codigo = item.it-codigo:screen-value in frame {&frame-name}.
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  def var l-new-record as logical no-undo.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  assign l-new-record = adm-new-record.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if rowid(item) <> ? then do:
     assign gr-item = rowid(item).

     if l-copia then do:

        RUN cdp/cd0204b1.w(OUTPUT l-narrativa,
                           OUTPUT l-resultados).

        IF l-resultados THEN DO:

            FOR FIRST bf-item NO-LOCK
                WHERE rowid(bf-item) = rw-old-item:
            END.

            IF AVAIL bf-item THEN DO:

                IF bf-item.cd-folh-item = ITEM.cd-folh-item THEN DO:

                   FOR EACH it-carac-tec EXCLUSIVE-LOCK
                      WHERE it-carac-tec.it-codigo = item.it-codigo 
                        AND it-carac-tec.cd-folha  = item.cd-folh-item:

                       DELETE it-carac-tec.
                   END.

                   FIND FIRST folh-espec 
                        WHERE folh-espec.cd-folha = bf-item.cd-folh-item no-lock no-error.

                   FOR EACH comp-folh NO-LOCK
                      WHERE comp-folh.cd-folha = folh-espec.cd-folha:

                       FOR FIRST it-carac-tec NO-LOCK
                           WHERE it-carac-tec.it-codigo = bf-item.it-codigo 
                             AND it-carac-tec.cd-folha  = comp-folh.cd-folha 
                             AND it-carac-tec.cd-comp   = comp-folh.cd-comp:

                           CREATE bf-it-carac-tec.
                           BUFFER-COPY it-carac-tec EXCEPT it-codigo TO bf-it-carac-tec.
                           ASSIGN bf-it-carac-tec.it-codigo = ITEM.it-codigo.
                           
                           IF bf-it-carac-tec.tipo-result = 2 THEN DO:
                               FOR EACH it-res-carac
                                  WHERE it-res-carac.cd-comp    = it-carac-tec.cd-comp 
                                    and it-res-carac.cd-folha   = it-carac-tec.cd-folh
                                    and it-res-carac.it-codigo  = it-carac-tec.it-codigo
                                    and it-res-carac.nr-tabela  = it-carac-tec.nr-tabela NO-LOCK:
                             
                                    CREATE b-it-res-carac.
                                    BUFFER-COPY it-res-carac EXCEPT it-codigo TO b-it-res-carac.
                                    ASSIGN b-it-res-carac.it-codigo = ITEM.it-codigo.
                               END.
                           END.
                           ELSE IF bf-it-carac-tec.tipo-result = 3 THEN DO:
                               FOR EACH it-msg-carac
                                  WHERE it-msg-carac.cd-comp   =  it-carac-tec.cd-comp  
                                    AND it-msg-carac.cd-folha  =  it-carac-tec.cd-folh  
                                    AND it-msg-carac.it-codigo =  it-carac-tec.it-codigo NO-LOCK:

                                   CREATE b-it-msg-carac.
                                   BUFFER-COPY it-msg-carac EXCEPT it-codigo TO b-it-msg-carac.
                                   ASSIGN b-it-msg-carac.it-codigo = ITEM.it-codigo.
                               END.       
                           END.
                       END. 
                   END.
                END.
            END.
        END.
  
        IF NOT l-narrativa THEN
           assign item.narrativa = " ".

        assign  item.classif-abc   = 1
                item.consumo-aad   = 0
                item.consumo-prev  = 0
                item.data-ult-con  = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
                item.data-ult-ent  = ?
                item.data-ult-rep  = ?
                item.data-ult-sai  = ?
                item.dt-pr-fisc    = ?
                item.dt-ult-ben    = ?
                item.pm-ja-calc    = no
                item.pr-sem-tx     = 0
                item.preco-base    = 0
                item.preco-fiscal  = 0
                item.preco-repos   = 0
                item.preco-ul-ent  = 0
                item.variac-acum   = 0
                item.vl-mat-ant    = 0
                item.vl-mob-ant    = 0
                l-copia            = no.
     end.       
    
     if l-new-record = yes then do:
        if param-global.modulo-en = yes then do:  
           if param-global.consiste-sim and item.cd-folh-item <> '' then do:

              run cdp/cd0204b.w (input gr-item). 

              ASSIGN gr-item = ROWID(ITEM).

              run get-link-handle in adm-broker-hdl (input this-procedure,
                                                     input 'narrativa-target',
                                                     output c-handle).
              if num-entries(c-handle) = 1 then do:
                 assign h-handle = widget-handle(c-handle).
                 if valid-handle(h-handle) then do:

                     IF NOT l-narrativa THEN DO:
                        RUN pi-apaga-narrativa IN h-handle.
                     END.
                 
                    run pi-mostra-narrativa in h-handle.
                    /*RUN dispatch IN h-handle ( INPUT 'row-available':U ).*/
                 end.   
              end.
           end.     
        end.
        &IF DEFINED (bf_man_203) &THEN
            run cdp/cd0204k.p (input item.it-codigo,
                               input "I", /* Inclusío */
                               input no,
                               input no,
                               input yes,
                               input table tt-estabel,
                               input table tt-old-item).
        &ENDIF                           
            
        ASSIGN OVERLAY(item.char-2,52,1)  = IF SUBSTRING(item.char-2,52,1)  = "" THEN "2" ELSE SUBSTRING(item.char-2,52,1)   /* Quando incluir um novo item a Origem Al°quota Pis    = Natureza */    
               OVERLAY(item.char-2,53,1)  = IF SUBSTRING(item.char-2,53,1)  = "" THEN "2" ELSE SUBSTRING(item.char-2,53,1)   /* Quando incluir um novo item a Origem Al°quota Cofins = Natureza */    
               OVERLAY(item.char-1,231,1) = IF SUBSTRING(item.char-1,231,1) = "" THEN "2" ELSE SUBSTRING(item.char-1,231,1)  /* Quando incluir um novo item a Origem Retená∆o Pis    = Natureza  */    
               OVERLAY(item.char-1,232,1) = IF SUBSTRING(item.char-1,232,1) = "" THEN "2" ELSE SUBSTRING(item.char-1,232,1)  /* Quando incluir um novo item a Origem Retená∆o Cofins = Natureza  */    
               OVERLAY(item.char-1,233,1) = IF SUBSTRING(item.char-1,233,1) = "" THEN "2" ELSE SUBSTRING(item.char-1,233,1)  /* Quando incluir um novo item a Origem Retená∆o CSLL   = Natureza  */   
               OVERLAY(item.char-1,192,1) = IF SUBSTRING(item.char-1,192,1) = "" THEN "1" ELSE SUBSTRING(item.char-1,192,1)  /* Quando incluir um novo item a Classificaá∆o de bebidas = Nenhum */        
               OVERLAY(item.char-1,50,5)  = "Nao" /* Quando incluir um novo item o campo PIS/COFINS Subst Total NF (CD0903 - aba Pis/Cofins) deve ser desmarcado */        
               .

        /* UN x Estabel */
        run cdp/cdapi024.p persistent set h-cdapi024.

        run ValidaUnidadeNegocioEstabel in h-cdapi024 (input item.cod-estabel,
                                                       input today,
                                                       input item.cod-unid-negoc,
                                                       output table tt-erro-aux).

        if can-find(first tt-erro-aux) then
            assign item.cod-unid-negoc = "".
            
        delete procedure h-cdapi024.
     end.
     else do:     
          &IF DEFINED (bf_man_203) &THEN              
              if can-find (first fam-uni-estab
                           where fam-uni-estab.fm-codigo = item.fm-codigo no-lock) then do:
                 assign l-modific = yes.                            

                 IF tt-old-item.fm-codigo <> ITEM.fm-codigo THEN 
                    ASSIGN l-cancelar = NO.

                 run cdp/cd0204k1.w (input        item.it-codigo,
                                     input-output l-modific,
                                     input-output l-anterior,
                                     output       l-cancelar,
                                     output table tt-estabel).

                 &IF DEFINED (bf_man_203) &THEN

                     IF v-log-fam = YES  THEN DO:

                         &if defined (CUSTOM_GRENDENE) &then    

                             run cdp/cd0204k.p (input item.it-codigo,
                                                input "M", /* Modificaªío */
                                                input l-modific,
                                                input l-anterior,
                                                input (not l-cancelar),
                                                input table tt-estabel,
                                                input table tt-old-item).

                         &else

                             FIND FIRST familia WHERE familia.fm-codigo = ITEM.fm-codigo NO-LOCK NO-ERROR.

                             CREATE tt-familia.
                             BUFFER-COPY familia TO tt-familia.

                             CREATE tt-item-1.
                             ASSIGN tt-item-1.it-codigo  = ITEM.it-codigo
                                    tt-item-1.rw-item    = ROWID(ITEM)
                                    tt-item-1.diferencas = ""
                                    tt-item-1.des-erro   = "".

                             IF fn-permite-alteracao-un() = NO THEN DO:
                                    BUFFER-COPY familia EXCEPT log-1 tipo-con-est tipo-contr char-2 un TO item. 
                                    ASSIGN OVERLAY(item.char-2,188,12) = SUBSTR(familia.char-2,188,12)
                                           OVERLAY(item.char-2,88,12)  = SUBSTR(familia.char-2,88,12).
                             END.
                             ELSE DO:
                                 BUFFER-COPY familia EXCEPT tipo-contr log-1 char-2 TO item.
                                 ASSIGN OVERLAY(item.char-2,188,12) = SUBSTR(familia.char-2,188,12)
                                        OVERLAY(item.char-2,88,12)  = SUBSTR(familia.char-2,88,12).
                             END.


                             run cdp/cd0202k.p (input "cd0204",
                                      input ITEM.fm-codigo,
                                      input "M":U, /* Modificaá∆o */
                                      input yes,
                                      input yes,
                                      input yes,
                                      input yes,
                                      input yes,
                                      input yes,
                                      input yes,
                                      input yes,
                                      input yes,
                                      input yes,
                                      input yes,
                                      input table tt-item-1,
                                      input table tt-estabel,
                                      input table tt-familia).

                             DELETE tt-familia.
                             DELETE tt-item-1.

                         &endif

                     END.
                     ELSE DO:
                         run cdp/cd0204k.p (input item.it-codigo,
                                            input "M", /* Modificaªío */
                                            input l-modific,
                                            input l-anterior,
                                            input (not l-cancelar),
                                            input table tt-estabel,
                                            input table tt-old-item).
                     END.
                 &else                 
                     run cdp/cd0204k.p (input item.it-codigo,
                                        input "M", /* Modificaªío */
                                        input l-modific,
                                        input l-anterior,
                                        input (not l-cancelar),
                                        input table tt-estabel,
                                        input table tt-old-item).
                 &endif
              end.
          &ENDIF 
     end.
    {include/i-epcgeneric.i AFTER-LOCAL-END-UPDATE VIEWER this-procedure {&FRAME-NAME} ITEM rowid(ITEM)}
     apply 'entry' to item.it-codigo in frame {&frame-name}.
  end.
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
    
    DEFINE VARIABLE c-handle AS HANDLE NO-UNDO.
    
    RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                OUTPUT c-handle).

    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = 'spp-workflow-itens' AND funcao.ativo) THEN DO:
        IF c-handle:FILE-NAME MATCHES "*cd0204*":U THEN DO:
            IF NOT VALID-HANDLE(hFluig) THEN
                RUN utp/ut-integra-ecm.p PERSISTENT SET hFluig.
            
            RUN checkFluigIntegration IN hFluig(OUTPUT l-checkFluig).
            
            IF l-checkFluig THEN DO:
                ASSIGN bt-cria-wf:VISIBLE IN FRAME {&FRAME-NAME} = YES.
            END.
            ELSE
                ASSIGN bt-cria-wf:VISIBLE IN FRAME {&FRAME-NAME} = NO.
            
            IF VALID-HANDLE(hFluig) THEN DO:
                DELETE PROCEDURE hFluig.
            END.    
        END.
        ELSE DO:
            ASSIGN bt-cria-wf:VISIBLE IN FRAME {&FRAME-NAME} = NO.
        END.

   END.
   ELSE DO: 
       ASSIGN bt-cria-wf:VISIBLE IN FRAME {&FRAME-NAME} = NO.
   END.
  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if avail item then
     assign gr-item = rowid(item).

  if l-cd0204-img then do:
     RUN Who-Is-The-Container IN adm-broker-hdl
         (INPUT this-procedure,
          OUTPUT c-prog).     
     run pi-habilita-img in c-prog(input gr-item).
  end.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


  IF adm-new-record THEN DO:
       FIND b-item WHERE b-item.it-codigo = INPUT FRAME {&frame-name} ITEM.it-codigo NO-LOCK NO-ERROR.
       IF AVAIL b-item THEN DO:
           apply 'entry' to item.it-codigo in frame {&frame-name}.
           return 'adm-error':U.
       END.
   END.
   
   /* Code placed here will execute AFTER standard behavior.    */
   IF AVAIL ITEM THEN DO:
   

        /********************Multiplanta***********************/
        assign c-transacao = "MAN003".
        {cdp/cd7300.i5 "001" c-transacao}
        assign i-tipo-movto = i-novo .

        if  param-global.modulo-mp and tt-replica-msg.log-replica-msg then do:
            create tt-item-aux.
            buffer-copy item to tt-item-aux.
            
            create tt-dados-env.
            assign tt-dados-env.num-sequencia  = i-seq
                   tt-dados-env.cod-tipo-reg   = 3
                   tt-dados-env.ind-tipo-movto = i-tipo-movto
                   tt-dados-env.identif-msg    = item.it-codigo.
            raw-transfer tt-item-aux to tt-dados-env.conteudo-msg.
            assign i-seq = i-seq + 1.
        end.
        {cdp/cd7300.i6 "001" c-transacao}   
         /******************Fim-Multiplanta********************/     
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-apresenta-erros V-table-Win 
PROCEDURE pi-apresenta-erros :
/*------------------------------------------------------------------------------
  Purpose: Apresentar erros reportados pelo trigger de write da tabela item.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  {database/tgin/twp/twin172.i "show":U}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-handle V-table-Win 
PROCEDURE pi-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-query as char.

assign c-hand-query = p-query.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle-imp V-table-Win 
PROCEDURE pi-passa-handle-imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Integracao Modulo Importacao ***************************/
    def input parameter p-handle as handle no-undo.    
    assign h-vb2in172 = p-handle.
/**********************************************************/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-eliminacao V-table-Win 
PROCEDURE pi-valida-eliminacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {database/tgin/tdp/tdin172.i 'show'}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: Nío fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaªÑes, pois neste ponto do programa o registro 
  ainda nío foi criado.       
------------------------------------------------------------------------------*/
   def var c-codigo like item.it-codigo no-undo.
   def var l-erro   as   logical        no-undo.

   {include/i-vldfrm.i}
  if input frame {&frame-name} item.desc-item = ""
  then do: {include/i-vldprg.i} 
            run utp/ut-msgs.p( input "show":U,
                               input 190,
                               input "").
            apply 'entry' to item.desc-item  in frame {&frame-name}.
            return 'adm-error':U.
       end.


   if adm-new-record
   and can-find(b-item
       where b-item.it-codigo = input frame {&frame-name} item.it-codigo) then do:
      {utp/ut-table.i mgind item 1}
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show":U,
                         input 8,
                         input return-value).
      apply 'entry' to item.it-codigo in frame {&frame-name}.
      return 'adm-error':U.
   end. 

   if adm-new-record = yes then do:
      if  search ("cdp/cd0204y.r") <> ?
      or  search ("cdp/cd0204y.p") <> ? 
      then do:
         run cdp/cd0204y.p (input item.it-codigo:screen-value in frame {&frame-name},
                            output c-codigo,
                            output l-erro).
         if l-erro = yes then do:
            {utp/ut-table.i mgind item 1}
            {include/i-vldprg.i} 
            run utp/ut-msgs.p( input "show":U,
                               input 932,
                               input return-value).
            apply 'entry' to item.it-codigo in frame {&frame-name}.
            return 'adm-error':U.
         end.
      end.
   end.


   if adm-new-record = yes then do:
      &IF DEFINED (bf_man_203) &THEN 
       IF param-global.modulo-dp = YES THEN DO:   
          if  can-find(first dp-item
                       where dp-item.item-dp  = item.it-codigo:screen-value in frame {&frame-name}) then do:                       
                 run utp/ut-msgs.p( input "show":U,
                                    input 27187,
                                    input return-value).
              apply 'entry' to item.it-codigo in frame {&frame-name}.
              return 'adm-error':U.
          end.
          END.

      &ELSE  
          IF param-global.modulo-dp = YES  THEN DO:
          if  can-find(first cot-item
                       where cot-item.item-destino  = item.it-codigo:screen-value in frame {&frame-name}) then do:
                run utp/ut-msgs.p( input "show":U,
                                   input 27187,
                                   input return-value).
              apply 'entry' to item.it-codigo in frame {&frame-name}.
              return 'adm-error':U.
          end.
          END.
      &ENDIF.
   end.


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
  {src/adm/template/snd-list.i "item"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piIntegracao V-table-Win 
PROCEDURE piIntegracao :
/* -----------------------------------------------------------
  Purpose: Api para integraá‰es    
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE h-ut-integration AS HANDLE      NO-UNDO.

    RUN utp/ut-integration.p PERSISTENT SET h-ut-integration.
    RUN eai-integration IN h-ut-integration (INPUT "Item",            /* Nome da transaá∆o     */
                                             INPUT ROWID(ITEM),       /* Registro da transaá∆o */
                                             INPUT pType,             /* Evento da transaá∆o   */
                                             OUTPUT TABLE RowErrors). /* Erros da transaá∆o    */
    DELETE PROCEDURE h-ut-integration.

    IF CAN-FIND(FIRST RowErrors) THEN DO:
         {method/showmessage.i1}
         {method/showmessage.i2 &Modal="YES"}
         {method/showmessage.i3}
         RETURN "ADM-ERROR".
    END.

END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  (input c-campo as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT c-campo).

  RETURN return-value.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


