&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V01IN176 2.00.01.003}  /*** 010103 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in176 MUT}
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

/* Local Variable Definitions ---                                       */

{include/tt-edit.i}   /* Definido para a procedure interna */
{include/pi-edit.i}   /* pi-calcula-itens-nota */

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

def var c-item          like item-doc-est.it-codigo   no-undo.
def var c-descricao     like item.descricao-1         no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item-doc-est
&Scoped-define FIRST-EXTERNAL-TABLE item-doc-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-doc-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-doc-est.num-pedido ~
item-doc-est.numero-ordem item-doc-est.it-codigo item-doc-est.qt-do-forn ~
item-doc-est.un item-doc-est.quantidade 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}num-pedido ~{&FP2}num-pedido ~{&FP3}~
 ~{&FP1}numero-ordem ~{&FP2}numero-ordem ~{&FP3}~
 ~{&FP1}it-codigo ~{&FP2}it-codigo ~{&FP3}~
 ~{&FP1}qt-do-forn ~{&FP2}qt-do-forn ~{&FP3}~
 ~{&FP1}un ~{&FP2}un ~{&FP3}~
 ~{&FP1}quantidade ~{&FP2}quantidade ~{&FP3}
&Scoped-define ENABLED-TABLES item-doc-est
&Scoped-define FIRST-ENABLED-TABLE item-doc-est
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS item-doc-est.sequencia ~
item-doc-est.num-pedido item-doc-est.numero-ordem item-doc-est.it-codigo ~
item-doc-est.cod-refer item-doc-est.parcela item-doc-est.qt-do-forn ~
item-doc-est.un item-doc-est.quantidade 
&Scoped-Define DISPLAYED-OBJECTS fi-un fi-desc-ref fi-item-do-forn ~
fi-descricao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS item-doc-est.sequencia ~
item-doc-est.num-pedido item-doc-est.numero-ordem item-doc-est.it-codigo ~
item-doc-est.cod-refer item-doc-est.parcela item-doc-est.qt-do-forn ~
item-doc-est.un item-doc-est.quantidade 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-indice-conv V-table-Win 
FUNCTION fn-indice-conv RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

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
DEFINE VARIABLE fi-desc-ref AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-item-do-forn AS CHARACTER FORMAT "x(18)":U 
     LABEL "Fill 1" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-un AS CHARACTER FORMAT "x(5)":U 
     VIEW-AS FILL-IN 
     SIZE 4.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 8.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-un AT ROW 8.46 COL 79 COLON-ALIGNED NO-LABEL
     fi-desc-ref AT ROW 6.5 COL 33.57 COLON-ALIGNED NO-LABEL
     item-doc-est.sequencia AT ROW 1.5 COL 20.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     item-doc-est.num-pedido AT ROW 2.5 COL 20.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     item-doc-est.numero-ordem AT ROW 3.5 COL 20.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     item-doc-est.it-codigo AT ROW 4.5 COL 20.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     fi-item-do-forn AT ROW 5.5 COL 20.57 COLON-ALIGNED
     item-doc-est.cod-refer AT ROW 6.5 COL 20.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     item-doc-est.parcela AT ROW 7.5 COL 20.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     fi-descricao AT ROW 4.5 COL 38.29 COLON-ALIGNED NO-LABEL
     item-doc-est.qt-do-forn AT ROW 8.46 COL 20.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     item-doc-est.un AT ROW 8.46 COL 41.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     item-doc-est.quantidade AT ROW 8.46 COL 61.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-doc-est
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 9.29
         WIDTH              = 87.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN item-doc-est.cod-refer IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-desc-ref IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-item-do-forn IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-doc-est.it-codigo IN FRAME f-main
   2                                                                    */
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
/* SETTINGS FOR FILL-IN item-doc-est.qt-do-forn IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN item-doc-est.quantidade IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN item-doc-est.sequencia IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN item-doc-est.un IN FRAME f-main
   2                                                                    */
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




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME item-doc-est.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.cod-refer V-table-Win
ON F5 OF item-doc-est.cod-refer IN FRAME f-main /* Referància */
OR  MOUSE-SELECT-DBLCLICK OF item-doc-est.cod-refer IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=inzoom/z02in377.w
                       &campo=item-doc-est.cod-refer
                       &campozoom=cod-refer}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.cod-refer V-table-Win
ON LEAVE OF item-doc-est.cod-refer IN FRAME f-main /* Referància */
DO:
    {include/leave.i &tabela=referencia
                     &atributo-ref=descricao
                     &variavel-ref=fi-desc-ref
                     &where="referencia.cod-refer = input frame {&frame-name}
                             item-doc-est.cod-refer"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-item-do-forn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-item-do-forn V-table-Win
ON F5 OF fi-item-do-forn IN FRAME f-main /* Fill 1 */
OR  MOUSE-SELECT-DBLCLICK OF fi-item-do-forn IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in178.w
                       &campo=fi-item-do-forn
                       &campozoom=fi-item-do-forn}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-item-do-forn V-table-Win
ON LEAVE OF fi-item-do-forn IN FRAME f-main /* Fill 1 */
DO:
    find first item-fornec 
         where item-fornec.cod-emitente = docum-est.cod-emitente
           and item-fornec.item-do-forn = input frame {&frame-name} fi-item-do-forn
               no-lock no-error.
    find item where available item-fornec and
         item.it-codigo = item-fornec.it-codigo no-lock no-error.
    assign item-doc-est.cod-refer:sensitive in frame {&frame-name} =
        (available item and item.tipo-con-est = 4). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.it-codigo V-table-Win
ON ENTRY OF item-doc-est.it-codigo IN FRAME f-main /* Item */
DO:
  if  input frame {&frame-name} item-doc-est.numero-ordem = 0 then 
      assign c-item = input frame {&frame-name} item-doc-est.it-codigo
             c-descricao = fi-descricao:screen-value.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.it-codigo V-table-Win
ON F5 OF item-doc-est.it-codigo IN FRAME f-main /* Item */
OR  MOUSE-SELECT-DBLCLICK OF item-doc-est.it-codigo IN FRAME {&frame-name} DO:
    l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z02in172.w
                       &campo=item-doc-est.it-codigo
                       &campozoom=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.it-codigo V-table-Win
ON LEAVE OF item-doc-est.it-codigo IN FRAME f-main /* Item */
DO:

    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=fi-descricao
                     &where="item.it-codigo = input frame {&frame-name}
                             item-doc-est.it-codigo"}

    find item where 
         item.it-codigo = input frame {&frame-name} item-doc-est.it-codigo
         no-lock no-error.
    assign item-doc-est.cod-refer:sensitive in frame {&frame-name} =
        (available item and item.tipo-con-est = 4).

    assign l-alterou-item = yes.

    if not l-inclusao then do:
       find b-item-doc-est where rowid(b-item-doc-est) = rw-item-doc-est no-lock no-error.
       assign l-alterou-item = b-item-doc-est.it-codigo <> input frame {&frame-name} item-doc-est.it-codigo.
    end.

    if c-item <> input frame {&frame-name} item-doc-est.it-codigo or
       c-descricao <> item.desc-item then do:
        RUN get-link-handle IN adm-broker-hdl
            (INPUT this-procedure, INPUT "Acha-wh1-target", OUTPUT c-handle).
        if  avail item then do i-x = 1 to num-entries(c-handle):  
            assign wh-programa = widget-handle(entry(i-x,c-handle)).
            if  valid-handle(wh-programa) then do:
                run pi-inicializa in wh-programa (input rowid(item), 
                                                  input l-alterou-item,
                                                  input l-inclusao).
            end.
        end.    
    end.    


    RUN get-link-handle IN adm-broker-hdl
        (INPUT this-procedure, INPUT "Acha-wh2-target", OUTPUT c-handle).

    if  avail item then do i-x = 1 to num-entries(c-handle):  
        assign wh-programa = widget-handle(entry(i-x,c-handle)).
        if  valid-handle(wh-programa) then do:
            run   pi-habilita-desabilita-preco-unit in wh-programa.
        end.
    end.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_f5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_f5 V-table-Win
ON CHOOSE OF MENU-ITEM m_f5 /* F5 - Zoom */
DO:
    apply "F5" to item-doc-est.num-pedido in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_F5_ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_F5_ordem V-table-Win
ON CHOOSE OF MENU-ITEM m_F5_ordem /* F5 - Zoom */
DO:
    apply "F5" to item-doc-est.numero-ordem in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_f7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_f7 V-table-Win
ON CHOOSE OF MENU-ITEM m_f7 /* F7 - Consulta Pedido */
DO:
    apply "F7" to item-doc-est.num-pedido in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_f7_ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_f7_ordem V-table-Win
ON CHOOSE OF MENU-ITEM m_f7_ordem /* F7 - Consulta Ordens */
DO:
    apply "F7" to item-doc-est.numero-ordem in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_f8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_f8 V-table-Win
ON CHOOSE OF MENU-ITEM m_f8 /* F8 - Abertura Pedido */
DO:
    apply "F8" to item-doc-est.num-pedido in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.num-pedido V-table-Win
ON F5 OF item-doc-est.num-pedido IN FRAME f-main /* Pedido */
OR  MOUSE-SELECT-DBLCLICK OF item-doc-est.num-pedido in frame {&frame-name} DO:
    {include/zoomvar.i &prog-zoom=inzoom/z13in274.w
                       &campo=item-doc-est.numero-ordem                       
                       &campo2=item-doc-est.num-pedido   
                       &campozoom=numero-ordem
                       &campozoom2=num-pedido
                       &parametros="run pi-recebe-parametros in wh-pesquisa 
                                        (input docum-est.cod-emitente, 
                                         input natur-oper.tipo)."}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.num-pedido V-table-Win
ON F7 OF item-doc-est.num-pedido IN FRAME f-main /* Pedido */
DO:
    find pedido-compr where pedido-compr.num-pedido = input frame {&frame-name} item-doc-est.num-pedido  no-lock no-error.
    assign gr-pedido-compr = if avail pedido-compr then rowid(pedido-compr) else ?.
    run ccp/cc0509.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.num-pedido V-table-Win
ON F8 OF item-doc-est.num-pedido IN FRAME f-main /* Pedido */
DO:
    do  with frame {&FRAME-NAME}:
        assign i-sequencia = integer(item-doc-est.sequencia:screen-value).
        if  i-sequencia = 0 then
            return no-apply.
        run rep/re0301o.w (input v-row-parent, input i-sequencia).
        apply "entry" to self.
        find first rat-ordem no-lock
             where rat-ordem.cod-emitente = docum-est.cod-emitente
               and rat-ordem.nat-operacao = docum-est.nat-operacao
               and rat-ordem.serie-docto  = docum-est.serie-docto
               and rat-ordem.nro-docto    = docum-est.nro-docto no-error.
        assign l-rateio = available rat-ordem.
        if  l-rateio then do:
            find ordem-compra no-lock where 
                 ordem-compra.numero-ordem = rat-ordem.numero-ordem no-error.
            find item-fornec no-lock where
                 item-fornec.cod-emitente = rat-ordem.cod-emitente and
                 item-fornec.it-codigo    = ordem-compra.it-codigo no-error.
            display rat-ordem.num-pedido   @ item-doc-est.num-pedido
                    rat-ordem.numero-ordem @ item-doc-est.numero-ordem
                    ordem-compra.it-codigo @ item-doc-est.it-codigo
                    item-fornec.item-do-forn when param-re.cod-ent-item = 1
                                           @ fi-item-do-forn
                    "" when param-re.cod-ent-item = 2
                                           @ fi-item-do-forn
                    rat-ordem.parcela      @ item-doc-est.parcela.
            for each rat-ordem NO-LOCK
               where rat-ordem.cod-emitente = docum-est.cod-emitente
                 and rat-ordem.nat-operacao = docum-est.nat-operacao
                 and rat-ordem.serie-docto  = docum-est.serie-docto
                 and rat-ordem.nro-docto    = docum-est.nro-docto
                 and rat-ordem.sequencia    = i-sequencia:
                assign de-quantidade = de-quantidade + rat-ordem.quantidade
                       de-qtd-forn   = de-qtd-forn   + rat-ordem.qtidade-forn.
            end.         
            display de-quantidade @ item-doc-est.quantidade
                    de-qtd-forn   @ item-doc-est.qt-do-forn.
            disable item-doc-est.num-pedido
                    item-doc-est.numero-ordem
                    item-doc-est.it-codigo
                    item-doc-est.sequencia
                    fi-item-do-forn
                    item-doc-est.cod-refer
                    item-doc-est.parcela
                    item-doc-est.quantidade
                    item-doc-est.qt-do-forn.
        end.                   
    end.                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.num-pedido V-table-Win
ON LEAVE OF item-doc-est.num-pedido IN FRAME f-main /* Pedido */
DO:
    if  input frame {&frame-name} item-doc-est.num-pedido <> 0 then do with frame {&frame-name}:
        find pedido-compr where pedido-compr.num-pedido = input frame {&frame-name} item-doc-est.num-pedido 
             no-lock no-error.
        if  avail pedido-compr then do:
           if input frame {&frame-name} item-doc-est.numero-ordem <> 0 then do with frame {&frame-name}:
               find ordem-compra where 
                    ordem-compra.numero-ordem = input frame {&frame-name} item-doc-est.numero-ordem no-lock no-error.
           end.
           else do:
              find first ordem-compra
                   where ordem-compra.num-pedido = pedido-compr.num-pedido
                   and ( ordem-compra.situacao = 2 or
                        (ordem-compra.situacao = 6 and docum-est.tipo-docto = 2) )
                   no-lock no-error.
              assign item-doc-est.numero-ordem:screen-value = string(ordem-compra.numero-ordem).
           end.
           if  avail ordem-compra then do with frame {&frame-name}:
              assign item-doc-est.it-codigo:screen-value = ordem-compra.it-codigo
                     item-doc-est.cod-refer:screen-value = ordem-compra.cod-refer
                     item-doc-est.parcela:sensitive = yes.
              find first prazo-compra
                   where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                     and prazo-compra.situacao     = 2 no-lock no-error.
              if  avail prazo-compra then do:
                  assign item-doc-est.parcela:screen-value    = string(prazo-compra.parcela)
                       item-doc-est.qt-do-forn:screen-value = string(prazo-compra.qtd-sal-forn).
              end.              
           end.
        end.
    end.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.numero-ordem V-table-Win
ON F5 OF item-doc-est.numero-ordem IN FRAME f-main /* Ordem Compra */
OR  MOUSE-SELECT-DBLCLICK OF item-doc-est.numero-ordem in frame {&frame-name} DO:
    {include/zoomvar.i &prog-zoom=inzoom/z13in274.w
                       &campo=item-doc-est.numero-ordem
                       &campozoom=numero-ordem                       
                       &parametros="run pi-recebe-parametros in wh-pesquisa 
                                        (input docum-est.cod-emitente, 
                                         input natur-oper.tipo, input '')."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.numero-ordem V-table-Win
ON F7 OF item-doc-est.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:
    find ordem-compra where ordem-compra.numero-ordem = input frame {&frame-name} item-doc-est.numero-ordem no-lock no-error.
    assign gr-ordem-compra = if avail ordem-compra then rowid(ordem-compra) else ?.
    run ccp/cc0505.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.numero-ordem V-table-Win
ON LEAVE OF item-doc-est.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:
    if  input frame {&frame-name} item-doc-est.numero-ordem <> 0 then do with frame {&frame-name}:
        find ordem-compra where 
             ordem-compra.numero-ordem = input frame {&frame-name} item-doc-est.numero-ordem no-lock no-error.
        if  avail ordem-compra then do with frame {&frame-name}:

           assign c-item = input frame {&frame-name} item-doc-est.it-codigo
                  c-descricao = fi-descricao:screen-value. 

           assign item-doc-est.num-pedido:screen-value = string(ordem-compra.num-pedido)
                  item-doc-est.it-codigo:screen-value = ordem-compra.it-codigo
                  item-doc-est.cod-refer:screen-value = ordem-compra.cod-refer
                  item-doc-est.parcela:sensitive = yes.
           find first prazo-compra
                where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                  and prazo-compra.situacao     = 2 no-lock no-error.
           if  avail prazo-compra then do:
               assign item-doc-est.parcela:screen-value    = string(prazo-compra.parcela)
                    item-doc-est.qt-do-forn:screen-value = string(prazo-compra.qtd-sal-forn).
           end.              
        end.

/* Referente ao trecho w-ordem do re0301e1.p ----------------------------
 *                 assign de-qtd-acum = 0.
 * Acho que o w-ordem s¢ Ç criado na opá∆o modifica
 *                 for each b-item-doc-est where
 *                          b-item-doc-est.cod-emitente = docum-est.cod-emitente and
 *                          b-item-doc-est.nat-operacao = docum-est.nat-operacao and
 *                          b-item-doc-est.serie-docto  = docum-est.serie-docto  and
 *                          b-item-doc-est.nro-docto    = docum-est.nro-docto:
 *                     assign de-qtd-acum = de-qtd-acum + b-item-doc-est.quantidade.
 *                 end.        
 *  ---------------------------------------------------                */
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.parcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.parcela V-table-Win
ON F5 OF item-doc-est.parcela IN FRAME f-main /* Parcela */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in356.w
                       &campo=item-doc-est.parcela
                       &campozoom=parcela
                       &parametros="run pi-seta-inicial in wh-pesquisa 
                                        (input rowid(ordem-compra))."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.parcela V-table-Win
ON LEAVE OF item-doc-est.parcela IN FRAME f-main /* Parcela */
DO:
      if  input frame {&frame-name} item-doc-est.numero-ordem <> 0 and  
          input frame {&frame-name} item-doc-est.parcela <> 0 then do with frame {&frame-name}:
           find prazo-compra where prazo-compra.numero-ordem = input frame {&frame-name} item-doc-est.numero-ordem
                               and prazo-compra.parcela      = input frame {&frame-name} item-doc-est.parcela
                               no-lock no-error.
        if avail prazo-compra and prazo-compra.situacao = 2 then do:
            find ordem-compra where 
                 ordem-compra.numero-ordem = input frame {&frame-name} item-doc-est.numero-ordem no-lock no-error.
            if  avail ordem-compra then do with frame {&frame-name}:
               assign item-doc-est.num-pedido:screen-value = string(ordem-compra.num-pedido)
                      item-doc-est.it-codigo:screen-value = ordem-compra.it-codigo
                      item-doc-est.cod-refer:screen-value = ordem-compra.cod-refer
                      item-doc-est.qt-do-forn:screen-value = string(prazo-compra.qtd-sal-forn).

               RUN get-link-handle IN adm-broker-hdl
                   (INPUT this-procedure, INPUT "Acha-wh2-target", OUTPUT c-handle).
               if  avail item then do i-x = 1 to num-entries(c-handle):  
                   assign wh-programa = widget-handle(entry(i-x,c-handle)).
                   if  valid-handle(wh-programa) then do:
                       run   pi-habilita-desabilita-preco-unit in wh-programa.

                       find item where 
                            item.it-codigo = input frame {&frame-name} item-doc-est.it-codigo
                            no-lock no-error.

                       RUN pi-calcula-preco in wh-programa
                          (input rowid(item), input input frame {&frame-name} item-doc-est.numero-ordem, input ?).
                   end.
               end.    
            end.
        end.
      end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.parcela V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-doc-est.parcela IN FRAME f-main /* Parcela */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.qt-do-forn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.qt-do-forn V-table-Win
ON LEAVE OF item-doc-est.qt-do-forn IN FRAME f-main /* Qtde Emitente */
DO:

    RUN get-link-handle IN adm-broker-hdl
        (INPUT this-procedure, INPUT "Acha-wh2-target", OUTPUT c-handle).
    if  avail item then do i-x = 1 to num-entries(c-handle):  
        assign wh-programa = widget-handle(entry(i-x,c-handle)).
        if  valid-handle(wh-programa) then do:
            run   pi-habilita-desabilita-preco-unit in wh-programa.

            find item where 
                 item.it-codigo = input frame {&frame-name} item-doc-est.it-codigo
                 no-lock no-error.

            RUN pi-calcula-preco in wh-programa
               (input rowid(item), input input frame {&frame-name} item-doc-est.numero-ordem, input ?).

        end.
    end.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.un V-table-Win
ON LEAVE OF item-doc-est.un IN FRAME f-main /* Un */
DO:
    if  avail item then do with frame {&frame-name}:
        assign de-qtd-forn                          = input item-doc-est.qt-do-forn
               item-doc-est.quantidade:screen-value = string ( if item.fraciona 
                            then de-qtd-forn / fn-indice-conv()
                            else truncate(de-qtd-forn / fn-indice-conv(),0) )
               fi-un:screen-value                   = item.un.
    end.
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

  {utp/ut-field.i mgind item-fornec item-do-forn 1}
  assign fi-item-do-forn:label in frame {&frame-name} = return-value.

  if item-doc-est.num-pedido:load-mouse-pointer("image/rbm.cur")
     in frame {&frame-name} then .
  if item-doc-est.numero-ordem:load-mouse-pointer("image/rbm.cur")
     in frame {&frame-name} then .   
  if item-doc-est.it-codigo:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .
  if fi-item-do-forn:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .
  if item-doc-est.cod-refer:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .

  find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
  find first param-global no-lock no-error.
  find first param-compra no-lock no-error.
  find param-re where param-re.usuario = c-seg-usuario no-lock no-error.
  find natur-oper where natur-oper.nat-operacao = docum-est.nat-operacao
       no-lock no-error.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  find last b-item-doc-est 
      where b-item-doc-est.cod-emitente = docum-est.cod-emitente
        and b-item-doc-est.nat-operacao = docum-est.nat-operacao
        and b-item-doc-est.serie-docto  = docum-est.serie-docto
        and b-item-doc-est.nro-docto    = docum-est.nro-docto no-lock no-error.
  assign i-sequencia = if avail b-item-doc-est 
                       then b-item-doc-est.sequencia + param-re.inc-seq
                       else if param-re.seq-item-um > 0
                            then param-re.seq-item-um
                            else 10.
  do  with frame {&frame-name}:
      assign item-doc-est.sequencia:screen-value = string (i-sequencia)
             item-doc-est.sequencia:sensitive    = param-re.pd-seq.
  end.
  assign l-inclui = yes.

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
  find docum-est where rowid(docum-est) = v-row-parent no-error.
  run pi-seta-flags-observacao in this-procedure  
      (input docum-est.cod-observa, docum-est.nat-operacao).
  find item where item.it-codigo = item-doc-est.it-codigo no-lock no-error.
  if  l-inclui then do:
      assign item-doc-est.cod-emitente = docum-est.cod-emitente
             item-doc-est.nat-operacao = docum-est.nat-operacao
             item-doc-est.serie-docto  = docum-est.serie-docto
             item-doc-est.nro-docto    = docum-est.nro-docto
             item-doc-est.sequencia    = i-sequencia.
  end.
  find ordem-compra where ordem-compra.numero-ordem = item-doc-est.numero-ordem
       no-lock no-error.
  if  avail ordem-compra then 
      assign item-doc-est.num-ord-inv = ordem-compra.num-ord-inv.     

/****      
  N∆o posso colocar este c¢digo porque a° quando o usu†rio informar outro valor
  o que ir† se sobresair ser† sempre o calculado.
  Se necess†rio, estudar uma maneira de obter ambos os valores.
  ****************************************************************************/




  /* Calculo do IPI */
  run rep/re9992.p ( input rowid(item-doc-est) ).  /*IPI*/
  assign   /*item-doc-est.valor-ipi[1]   = de-IPI-item*/
           item-doc-est.base-ipi[1]    = de-IPI-base-item
           item-doc-est.ipi-ntrib[1]   = de-IPI-ntrib-item
           item-doc-est.ipi-outras[1]  = de-IPI-outras-item.


  assign de-ISS-base-item   = 0
         de-ISS-item        = 0 
         de-ISS-ntrib-item  = 0
         de-ISS-outras-item = 0.

  if l-servicos = no then
     assign item-doc-est.cd-trib-iss  = 2. /*ISENTO item.cd-trib-iss*/ 
  else do:
     if item.cd-trib-iss = 2 /*"I"*/ then 
        assign item-doc-est.cd-trib-iss = 2 /*"I"*/.
     else 
        assign item-doc-est.cd-trib-iss = 3 /*"O"*/.
  end.

  /* Calculo do ISS */
  if  l-servicos or (item-doc-est.cd-trib-iss = 1      
                and item-doc-est.aliquota-iss > 0) then do:
      run rep/re9993.p (input rowid(item-doc-est)). 
  end.
  assign item-doc-est.base-iss[1]    = de-ISS-base-item
         item-doc-est.valor-iss[1]   = de-ISS-item
         item-doc-est.iss-outras[1]  = de-ISS-outras-item.

  if  l-servicos then do:
     assign /*item-doc-est.valor-ipi     = 0*/
            item-doc-est.base-ipi      = 0
            item-doc-est.ipi-ntrib     = 0
            item-doc-est.ipi-outras    = 0
            item-doc-est.cd-trib-ipi   = 1   /* Zero  */
            item-doc-est.valor-icm     = 0
            item-doc-est.base-icm      = 0
            item-doc-est.icm-ntrib     = 0
            item-doc-est.icm-outras    = 0
            item-doc-est.cd-trib-icm   = 1   /* Zero  */
            item-doc-est.icm-complem   = 0.
  end.
  else do:

  if  l-transf and param-re.inclui-icms
   and l-inclui
   and item.tipo-contr = 2 /*"t"*/ then
     run rep/re9998.p (input rowid(item-doc-est)).

    /* Calculo do ICMS */
    run rep/re9994.p ( input rowid(item-doc-est) ).  /*ICMS*/

    find emitente where
         emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.
    find estabelec where
         estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
    find natur-oper where
         natur-oper.nat-operacao = docum-est.nat-operacao no-lock no-error.     

    assign item-doc-est.valor-icm[1]   = de-ICM-item
           item-doc-est.base-icm[1]    = de-ICM-base-item
           item-doc-est.icm-ntrib[1]   = de-ICM-ntrib-item
           item-doc-est.icm-outras[1]  = de-ICM-outras-item
           item-doc-est.icm-complem[1] = de-ICM-complem-item *
                                         integer(estabelec.pais = "BRASIL" and
                                         emitente.pais = estabelec.pais and
                                         estabelec.estado <> docum-est.uf and
                                         natur-oper.consum-final).
    assign item-doc-est.base-subs[1]   = if natur-oper.subs-trib 
                                         then de-ICM-base-item else 0
           item-doc-est.vl-subs[1]     = if natur-oper.subs-trib 
                                         then de-ICM-item else 0.
    if  l-devolucao and l-entrada and param-global.modulo-ft then do:
        assign item-doc-est.base-subs[1] = 0
               item-doc-est.vl-subs[1]   = 0.
        if  item-doc-est.serie-comp <> ""
        and item-doc-est.nro-comp > "" then do:
            find first it-nota-fisc
                 where it-nota-fisc.nr-nota-fis = item-doc-est.nro-comp
                   and it-nota-fisc.serie      = item-doc-est.serie-comp
                   and it-nota-fisc.it-codigo  = item-doc-est.it-codigo
                   and it-nota-fisc.cod-estabel = docum-est.cod-estabel
                       no-lock no-error.
            if  avail it-nota-fisc and it-nota-fisc.vl-icmsub-it > 0 then do:
                assign item-doc-est.vl-subs[1] =
                            round((it-nota-fisc.vl-icmsub-it /
                            it-nota-fisc.vl-merc-liq) *
                            (item-doc-est.preco-total[1]
                           - item-doc-est.desconto[1]),2)
                       item-doc-est.base-subs[1] =
                            round((it-nota-fisc.vl-bsubs-it /
                            it-nota-fisc.vl-merc-liq) *
                            (item-doc-est.preco-total[1]
                           - item-doc-est.desconto[1]),2).
            end.
        end.
    end.
  end.

  find conta-contab where
       conta-contab.ep-codigo = param-global.empresa-prin and
       conta-contab.conta-contabil = item-doc-est.conta-contabil no-lock no-error.
  assign item-doc-est.ct-codigo      = if avail conta-contab then conta-contab.ct-codigo else "":U.
  assign item-doc-est.sc-codigo      = if avail conta-contab then conta-contab.sc-codigo else "":U.


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
  if  avail item-doc-est then do:
      find item where item.it-codigo = item-doc-est.it-codigo no-lock no-error.
      find referencia where referencia.cod-refer = item-doc-est.cod-refer
           no-lock no-error.
      assign fi-descricao = if avail item then item.desc-item else ""
             fi-un        = if avail item then item.un else ""
             fi-desc-ref  = if avail referencia and avail item 
                            and item.tipo-contr = 4
                            then referencia.descricao else "".
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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
  run get-attribute ('adm-new-record').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif


  if not l-inclusao  then do:   /* alteracao */
    find item where 
         item.it-codigo = input frame {&frame-name} item-doc-est.it-codigo
         no-lock no-error.
    assign item-doc-est.cod-refer:sensitive in frame {&frame-name} =
        (available item and item.tipo-con-est = 4).
    RUN get-link-handle IN adm-broker-hdl
        (INPUT this-procedure, INPUT "Acha-wh1-target", OUTPUT c-handle).
    if  avail item then do i-x = 1 to num-entries(c-handle):  
        assign wh-programa = widget-handle(entry(i-x,c-handle)).
        if  valid-handle(wh-programa) then do:
            run pi-inicializa in wh-programa (input rowid(item), 
                                              input no,        /*Indica se o item foi alterado.Neste */
                                              input l-inclusao). /* momento ele ainda n∆o foi alterado */
        end.
    end.    
    RUN get-link-handle IN adm-broker-hdl
        (INPUT this-procedure, INPUT "Acha-wh2-target", OUTPUT c-handle).
    if  avail item then do i-x = 1 to num-entries(c-handle):  
        assign wh-programa = widget-handle(entry(i-x,c-handle)).
        if  valid-handle(wh-programa) then do:
            run   pi-habilita-desabilita-preco-unit in wh-programa.
        end.
    end.    
  end.
  RUN pi-inicializa-campo.


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
  /* Code placed here will execute AFTER standard behavior.    */

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campo V-table-Win 
PROCEDURE pi-inicializa-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
  find first param-global no-lock no-error.
  find first param-compra no-lock no-error.
  find param-re where param-re.usuario = c-seg-usuario no-lock no-error.
  find natur-oper where natur-oper.nat-operacao = docum-est.nat-operacao
       no-lock no-error.

  run pi-seta-flags-observacao in this-procedure  
          (input docum-est.cod-observa, docum-est.nat-operacao).
  assign l-compras = param-global.modulo-cc and avail param-compra and
                     not (l-devolucao or l-transf  or l-ent-cons or 
                          l-sai-cons  or l-remessa or l-retorno).

do  with frame {&frame-name}:
    assign item-doc-est.num-pedido:sensitive   = l-compras
           item-doc-est.numero-ordem:sensitive = l-compras.
end.

if l-transf and l-entrada then do with frame {&frame-name}:
   assign   item-doc-est.cod-refer:sensitive  = no
            item-doc-est.qt-do-forn:sensitive = no
            item-doc-est.quantidade:sensitive = no
            item-doc-est.un:sensitive         = no
            item-doc-est.it-codigo:sensitive  = no
            fi-item-do-forn:sensitive         = no.
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
  def var i-nr-itens as integer   no-undo.
  def var c-un       as character no-undo.
  def var de-lim-inf as decimal   no-undo.
  def var de-lim-sup as decimal   no-undo.
  def var l-d-forn   as logical   no-undo.

  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

  run pi-seta-flags-observacao in this-procedure  
          (input docum-est.cod-observa, docum-est.nat-operacao).
  assign l-compras = param-global.modulo-cc and avail param-compra and
                     not (l-devolucao or l-transf  or l-ent-cons or 
                          l-sai-cons  or l-remessa or l-retorno)
         l-d-forn = natur-oper.tipo = 2 and docum-est.esp-docto = 20 /*"NFD"*/.

  if  l-inclui then do with frame {&frame-name}:
      find item-doc-est no-lock where
           item-doc-est.cod-emitente = docum-est.cod-emitente and
           item-doc-est.nat-operacao = docum-est.nat-operacao and
           item-doc-est.serie-docto  = docum-est.serie-docto  and
           item-doc-est.nro-docto    = docum-est.nro-docto    and
           item-doc-est.sequencia    = input item-doc-est.sequencia no-error.
      if  avail item-doc-est then do: 
          {include/i-vldprg.i} 
          {utp/ut-table.i mgind item-doc-est 1}
          run utp/ut-msgs.p (input "show":U, input 7, input return-value).
          return 'ADM-ERROR':U.
      end.
  end.

  find item where
       item.it-codigo = input frame {&frame-name} item-doc-est.it-codigo
       no-lock no-error.
  find familia where
       familia.fm-codigo = item.fm-codigo no-lock no-error.     
  if  not avail item then do:
      {include/i-vldprg.i} 
      {utp/ut-table.i mgind item 1}
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      apply "entry" to item-doc-est.it-codigo in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  find item-fornec where
       item-fornec.it-codigo    = item.it-codigo and
       item-fornec.cod-emitente = docum-est.cod-emitente no-lock no-error.
  if  param-global.modulo-ft and natur-oper.imp-nota then do:
      run pi-calcula-itens-nota (output i-nr-itens).
      assign i-nr-itens = i-nr-itens + 1.
      if  i-nr-itens > para-fat.nr-item-nota then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 6342, input "").
          apply "entry" to item-doc-est.it-codigo in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
  end.
  find pedido-compr where pedido-compr.num-pedido = input frame {&frame-name} item-doc-est.num-pedido  no-lock no-error.
  find ordem-compra where ordem-compra.numero-ordem = input frame {&frame-name} item-doc-est.numero-ordem no-lock no-error.
  find estabelec where estabelec.cod-estabel = docum-est.cod-estabel 
       no-lock no-error.
  if  avail ordem-compra then
      find first cotacao-item no-lock 
           where cotacao-item.numero-ordem = ordem-compra.numero-ordem 
             and cotacao-item.cod-emitente = ordem-compra.cod-emitente 
             and cotacao-item.data-cotacao = ordem-compra.data-cotacao no-error.

  assign c-un = if item.tipo-contr <> 4
                then if avail item-fornec then item-fornec.unid-med-for
                     else item.un
                else if avail cotacao-item then cotacao-item.un
                     else item.un.

  if  (input frame {&frame-name} item-doc-est.num-pedido  <> 0   or 
       input frame {&frame-name} item-doc-est.numero-ordem <> 0) or  
      (param-re.sem-pedido = no and (l-compras and not l-d-forn)) then do with frame {&frame-name}:     
      if  not avail pedido-compr then do:
          {utp/ut-table.i mgind pedido-compr 1}
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 2, input return-value).
          apply "entry" to item-doc-est.num-pedido in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if  pedido-compr.situacao = 3 then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 1813, input "").
          apply "entry" to item-doc-est.num-pedido in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if  pedido-compr.end-entrega <> docum-est.cod-estabel then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 6814, input "").
          if  return-value = "no" then do:
              apply "entry" to item-doc-est.num-pedido in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.
      end.
      if  pedido-compr.cod-emitente <> docum-est.cod-emitente then do:
          {include/i-vldprg.i} 
          if param-re.rec-out-for then do: /* usu†rio pode receber pedidos de um outro fornecedor*/
             run utp/ut-msgs.p (input "show":U, input 5696, input "").
             if return-value = "no" then do:
                apply "entry" to item-doc-est.num-pedido in frame {&frame-name}.
                return 'ADM-ERROR':U.
             end.
          end.
          else do:
             run utp/ut-msgs.p (input "show":U, input 8851, input "").
             apply "entry" to item-doc-est.num-pedido in frame {&frame-name}.
             return 'ADM-ERROR':U.
          end.
      end.
      if  (docum-est.tipo-docto = 1 and ordem-compra.situacao <> 2)
      or  (docum-est.tipo-docto = 2 and ordem-compra.situacao <> 2 
                                    and ordem-compra.situacao <> 6) then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, 
                             input (if l-entrada then 6350 else 6352), 
                             input "").
          apply "entry" to item-doc-est.numero-ordem in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if  ordem-compra.it-codigo <> input item-doc-est.it-codigo then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 5055, input "").
          apply "entry" to item-doc-est.it-codigo in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      find prazo-compra where 
           prazo-compra.numero-ordem = ordem-compra.numero-ordem and
           prazo-compra.parcela = input frame {&frame-name} item-doc-est.parcela
           no-lock no-error.
      if  not avail prazo-compra then do:
          {include/i-vldprg.i} 
          {utp/ut-table.i mgind prazo-compra 1}
          run utp/ut-msgs.p (input "show":U, input 2, input return-value).
          apply "entry" to item-doc-est.parcela in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if  (prazo-compra.situacao <> 2 and prazo-compra.situacao <> 6)
      or  (prazo-compra.situacao <> 2 and l-entrada) then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U,
                             input (if l-entrada then 6359 else 6360), 
                             input "").
          apply "entry" to item-doc-est.parcela in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if  (prazo-compra.data-entrega > docum-est.dt-trans + param-re.variacao
      or   prazo-compra.data-entrega < docum-est.dt-trans - param-re.variacao)
      and l-entrada then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 5929, 
                             input string(prazo-compra.data-entrega) + "~~" + 
                                   string (docum-est.dt-trans - param-re.variacao)  + "~~" + 
                                   string (docum-est.dt-trans + param-re.variacao)).
          if  return-value = "no" then do:
              apply "entry" to item-doc-est.parcela in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.
      end.
      if  l-entrada and not l-devolucao and not l-transf 
      then do with frame {&frame-name}:
          assign de-lim-inf = ordem-compra.qt-acum-nec * 
                              familia.var-qtd-perm / 100
                 de-lim-sup = prazo-compra.quant-saldo + de-lim-inf
                 de-lim-inf = prazo-compra.quant-saldo - de-lim-inf.
          if  input item-doc-est.quantidade < de-lim-inf 
          or  input item-doc-est.quantidade > de-lim-sup then do:
              run utp/ut-msgs.p (input "show":U, input 5517, input "").
              if  param-re.aceita-var then do:
                  {utp/ut-liter.i Quantidade MRE R}
                  run utp/ut-msgs.p (input "show":U, input 6164, input return-value).
                  if  return-value = "no" then do:
                      apply "entry" to item-doc-est.quantidade.
                      return 'ADM-ERROR':U.
                  end.    
              end.
              run rep/re9997.p (input v-row-parent,
                                input (de-lim-inf + de-lim-sup) / 2,
                                input input item-doc-est.quantidade,
                                input 5517, input no).  
          end.
          else 
              run rep/re9997.p (input v-row-parent,
                                input (de-lim-inf + de-lim-sup) / 2,
                                input input item-doc-est.quantidade,
                                input 5517, input yes).  
      end.
  end.
  if  item.cod-obsoleto = 4 then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 563, input "").
  end.
  find referencia where
       referencia.cod-refer = input frame {&frame-name} item-doc-est.cod-refer
       no-lock no-error.
  if  item-doc-est.cod-refer:sensitive in frame {&frame-name}
  and not avail referencia then do:
      {include/i-vldprg.i} 
      {utp/ut-table.i mgind referencia 1}
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      apply "entry" to item-doc-est.cod-refer in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  input frame {&frame-name} item-doc-est.un <> c-un then do:
      if  item.tipo-contr <> 4 or (item.tipo-contr = 4 and avail item-fornec)
      or  avail ordem-compra then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 8578, input "").
          apply "entry" to item-doc-est.un in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.    
  end.
  if  l-transf and l-entrada = no and param-global.modulo-ft 
  and docum-est.uf = "AM" then do:
      /* cd9900.p - Calcula restituicao do Amazonas 
                    na versao I.00 Ç chamado no re0301e1.p
      */              
  end. 
  if  item.tipo-con-est = 2
  and input frame {&frame-name} item-doc-est.quantidade <> 0
  and input frame {&frame-name} item-doc-est.quantidade <> 1 then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 4460, input "").
      apply "entry" to item-doc-est.quantidade in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.

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


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-indice-conv V-table-Win 
FUNCTION fn-indice-conv RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var i-ordem   as integer   no-undo.
  def var i-parcela as integer   no-undo.
  def var c-item    as character no-undo.
  def var c-un-forn as character no-undo.
  def var de-indice as decimal   no-undo.

  assign i-ordem   = input frame {&frame-name} item-doc-est.numero-ordem
         i-parcela = input frame {&frame-name} item-doc-est.parcela
         c-item    = input frame {&frame-name} item-doc-est.it-codigo
         c-un-forn = input frame {&frame-name} item-doc-est.un.
  find prazo-compra where
       prazo-compra.numero-ordem = i-ordem   and
       prazo-compra.parcela      = i-parcela no-lock no-error.
  find item-fornec where 
       item-fornec.it-codigo    = c-item and
       item-fornec.cod-emitente = docum-est.cod-emitente no-lock no-error.    
  if  available item-fornec then
      assign de-indice = item-fornec.fator-conver /
                       if item-fornec.num-casa-dec = 0 then 1
                       else exp(10,item-fornec.num-casa-dec).
  else do:
      find tab-conv-un where
           tab-conv-un.un           = item.un and
           tab-conv-un.unid-med-for = c-un-forn no-lock no-error.
      if  available tab-conv-un then
          assign de-indice = tab-conv-un.fator-conver /
                             if tab-conv-un.num-casa-dec = 0 then 1
                             else exp(10,tab-conv-un.num-casa-dec).
      else
          assign de-indice = 1.
  end.

  RETURN de-indice.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


