&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V06IN223 2.00.00.007}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V06IN223 MUT}
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
 
def new global shared var gr-docum as rowid no-undo.
 
/* Local Variable Definitions ---                                       */
def var l-compras as logical no-undo.
def var i-ind-aux as integer no-undo.
def var c-moeda   as char    extent 2.
 
def new global shared var de-aux-1 as decimal.
def new global shared var de-aux-2 as decimal.
def new global shared var de-quantidade as decimal.
def new global shared var c-un as char.
def new global shared var gr-item as rowid no-undo.
 
def var c-estabelec as char no-undo.
def var i-empresa like param-global.empresa-prin no-undo.
{cdp/cdcfgdis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES movto-pend
&Scoped-define FIRST-EXTERNAL-TABLE movto-pend


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-pend.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-pend.num-pedido movto-pend.numero-ordem ~
movto-pend.it-codigo movto-pend.cod-refer movto-pend.parcela ~
movto-pend.conta-aplic movto-pend.cod-depos movto-pend.cod-localiz ~
movto-pend.lote movto-pend.dt-vali-lote movto-pend.conta-contabil 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}num-pedido ~{&FP2}num-pedido ~{&FP3}~
 ~{&FP1}numero-ordem ~{&FP2}numero-ordem ~{&FP3}~
 ~{&FP1}it-codigo ~{&FP2}it-codigo ~{&FP3}~
 ~{&FP1}cod-refer ~{&FP2}cod-refer ~{&FP3}~
 ~{&FP1}parcela ~{&FP2}parcela ~{&FP3}~
 ~{&FP1}conta-aplic ~{&FP2}conta-aplic ~{&FP3}~
 ~{&FP1}cod-depos ~{&FP2}cod-depos ~{&FP3}~
 ~{&FP1}cod-localiz ~{&FP2}cod-localiz ~{&FP3}~
 ~{&FP1}lote ~{&FP2}lote ~{&FP3}~
 ~{&FP1}dt-vali-lote ~{&FP2}dt-vali-lote ~{&FP3}~
 ~{&FP1}conta-contabil ~{&FP2}conta-contabil ~{&FP3}
&Scoped-define ENABLED-TABLES movto-pend
&Scoped-define FIRST-ENABLED-TABLE movto-pend
&Scoped-Define ENABLED-OBJECTS RECT-2 
&Scoped-Define DISPLAYED-FIELDS movto-pend.num-pedido ~
movto-pend.numero-ordem movto-pend.it-codigo movto-pend.cod-refer ~
movto-pend.parcela movto-pend.conta-aplic movto-pend.cod-depos ~
movto-pend.cod-localiz movto-pend.lote movto-pend.dt-vali-lote ~
movto-pend.conta-contabil 
&Scoped-Define DISPLAYED-OBJECTS c-desc-item c-desc-referencia ~
c-desc-aplicacao c-desc-deposito c-desc-localizacao c-desc-conta 

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
DEFINE VARIABLE c-desc-aplicacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-deposito AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 48.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-localizacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-referencia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 12.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     movto-pend.num-pedido AT ROW 2 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     movto-pend.numero-ordem AT ROW 3 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     movto-pend.it-codigo AT ROW 4 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item AT ROW 4 COL 34.14 COLON-ALIGNED NO-LABEL
     movto-pend.cod-refer AT ROW 5 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-desc-referencia AT ROW 5 COL 29 COLON-ALIGNED NO-LABEL
     movto-pend.parcela AT ROW 6 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     movto-pend.conta-aplic AT ROW 7 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-desc-aplicacao AT ROW 7 COL 35 COLON-ALIGNED NO-LABEL
     movto-pend.cod-depos AT ROW 8 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-deposito AT ROW 8 COL 24 COLON-ALIGNED NO-LABEL
     movto-pend.cod-localiz AT ROW 9 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.14 BY .88
     c-desc-localizacao AT ROW 9 COL 31 COLON-ALIGNED NO-LABEL
     movto-pend.lote AT ROW 10 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.14 BY .88
     movto-pend.dt-vali-lote AT ROW 11 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     movto-pend.conta-contabil AT ROW 12 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-desc-conta AT ROW 12 COL 35 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.movto-pend
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
         HEIGHT             = 12.79
         WIDTH              = 85.14.
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

/* SETTINGS FOR FILL-IN c-desc-aplicacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-conta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-deposito IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-localizacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-referencia IN FRAME f-main
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




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME movto-pend.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.cod-depos V-table-Win
ON F5 OF movto-pend.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
 
    {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                       &campo=movto-pend.cod-depos
                       &campozoom=cod-depos}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.cod-depos V-table-Win
ON LEAVE OF movto-pend.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
 
        {include/leave.i &tabela=deposito
                         &atributo-ref=nome
                         &variavel-ref=c-desc-deposito
                         &where="deposito.cod-depos = input frame {&frame-name} movto-pend.cod-depos"}
 
    disable movto-pend.cod-localiz with frame {&frame-name}.
    if item.loc-unica then
        enable movto-pend.cod-localiz with frame {&frame-name}.
 
    disable movto-pend.lote with frame {&frame-name}.
    if item.tipo-con-est <> 1 then
        enable movto-pend.lote with frame {&frame-name}.        
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-pend.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
        apply "F5" to self.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.cod-localiz V-table-Win
ON F5 OF movto-pend.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
 
    {include/zoomvar.i &prog-zoom="inzoom/z01in189.w"
                       &campo=movto-pend.cod-localiz
                       &campozoom=cod-localiz}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.cod-localiz V-table-Win
ON LEAVE OF movto-pend.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
 
        {include/leave.i &tabela=localizacao
                         &atributo-ref=descricao
                         &variavel-ref=c-desc-localizacao
                         &where="localizacao.cod-localiz = input frame {&frame-name} movto-pend.cod-localiz"}
 
    run pi-agrega-VI.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-pend.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
        apply "F5" to self.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.cod-refer V-table-Win
ON F5 OF movto-pend.cod-refer IN FRAME f-main /* Referància */
DO:
 
    {include/zoomvar.i &prog-zoom="inzoom/z01in377.w"
                       &campo=movto-pend.cod-refer
                       &campozoom=cod-refer}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.cod-refer V-table-Win
ON LEAVE OF movto-pend.cod-refer IN FRAME f-main /* Referància */
DO:
 
        {include/leave.i &tabela=referencia
                         &atributo-ref=descricao
                         &variavel-ref=c-desc-referencia
                         &where="referencia.cod-refer = input frame {&frame-name} movto-pend.cod-refer"}
 
    run pi-agrega-IV.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-pend.cod-refer IN FRAME f-main /* Referància */
DO:
        apply "F5" to self.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.conta-aplic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.conta-aplic V-table-Win
ON F5 OF movto-pend.conta-aplic IN FRAME f-main /* Conta Aplicaá∆o */
DO:
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.conta-aplic V-table-Win
ON LEAVE OF movto-pend.conta-aplic IN FRAME f-main /* Conta Aplicaá∆o */
DO:
 
        {include/leave.i &tabela=conta-contab
                         &atributo-ref=titulo
                         &variavel-ref=c-desc-aplicacao
                         &where="conta-contab.conta-contabil = input frame {&frame-name} movto-pend.conta-aplic"}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.conta-aplic V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-pend.conta-aplic IN FRAME f-main /* Conta Aplicaá∆o */
DO:
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.conta-contabil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.conta-contabil V-table-Win
ON F5 OF movto-pend.conta-contabil IN FRAME f-main /* Conta Cont†bil */
DO:
    
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.conta-contabil V-table-Win
ON LEAVE OF movto-pend.conta-contabil IN FRAME f-main /* Conta Cont†bil */
DO:
 
        {include/leave.i &tabela=conta-contab
                         &atributo-ref=titulo
                         &variavel-ref=c-desc-conta
                         &where="conta-contab.conta-contabil = input frame {&frame-name} movto-pend.conta-contabil"}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.conta-contabil V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-pend.conta-contabil IN FRAME f-main /* Conta Cont†bil */
DO:
        
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.it-codigo V-table-Win
ON F5 OF movto-pend.it-codigo IN FRAME f-main /* Item */
DO:
 
    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo=movto-pend.it-codigo
                       &campozoom=it-codigo}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.it-codigo V-table-Win
ON LEAVE OF movto-pend.it-codigo IN FRAME f-main /* Item */
DO:
 
        {include/leave.i &tabela=item
                         &atributo-ref=descricao-1
                         &variavel-ref=c-desc-item
                         &where="item.it-codigo = input frame {&frame-name} movto-pend.it-codigo"}
 
    run pi-agrega-III.  
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-pend.it-codigo IN FRAME f-main /* Item */
DO:
        apply "F5" to self.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.lote V-table-Win
ON LEAVE OF movto-pend.lote IN FRAME f-main /* Lote/SÇrie */
DO:
 
    run pi-agrega-VI.  
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.num-pedido V-table-Win
ON F5 OF movto-pend.num-pedido IN FRAME f-main /* Pedido */
DO:
 
    {include/zoomvar.i &prog-zoom="inzoom/z04in356.w"
                       &campo=movto-pend.num-pedido
                       &campozoom=num-pedido
                       &campo2=movto-pend.numero-ordem
                       &campozoom2=numero-ordem
                       &campo3=movto-pend.parcela
                       &campozoom3=parcela}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.num-pedido V-table-Win
ON LEAVE OF movto-pend.num-pedido IN FRAME f-main /* Pedido */
DO:
 
    run pi-agrega-I.  
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.num-pedido V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-pend.num-pedido IN FRAME f-main /* Pedido */
DO:
        apply "F5" to self.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.numero-ordem V-table-Win
ON F5 OF movto-pend.numero-ordem IN FRAME f-main /* Ordem */
DO:
 
    {include/zoomvar.i &prog-zoom="inzoom/z04in356.w"
                       &campo=movto-pend.num-pedido
                       &campozoom=num-pedido
                       &campo2=movto-pend.numero-ordem
                       &campozoom2=numero-ordem
                       &campo3=movto-pend.parcela
                       &campozoom3=parcela}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.numero-ordem V-table-Win
ON LEAVE OF movto-pend.numero-ordem IN FRAME f-main /* Ordem */
DO:
 
    find ordem-compra where
        ordem-compra.numero-ordem = input frame {&frame-name} movto-pend.numero-ordem and
        ordem-compra.num-pedido = input frame {&frame-name} movto-pend.num-pedido
        no-lock no-error.
    if not available ordem-compra then   
        find ordem-compra where
            ordem-compra.numero-ordem = input frame {&frame-name} movto-pend.numero-ordem
            no-lock no-error.
 
    if available ordem-compra then do:
        find item where 
            item.it-codigo = ordem-compra.it-codigo
            no-lock no-error.
        if available item then do:
            display item.it-codigo @ movto-pend.it-codigo with frame {&frame-name}.
            display item.desc-item @ c-desc-item with frame {&frame-name}.
        end.
    end.        
 
    run pi-agrega-II.  
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.numero-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-pend.numero-ordem IN FRAME f-main /* Ordem */
DO:
        apply "F5" to self.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.parcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.parcela V-table-Win
ON LEAVE OF movto-pend.parcela IN FRAME f-main /* Parcela */
DO:
 
    run pi-agrega-V.  
 
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
 
    if movto-pend.num-pedido:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
    if movto-pend.numero-ordem:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
    if movto-pend.it-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
    if movto-pend.cod-refer:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
    if movto-pend.cod-depos:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
    if movto-pend.cod-localiz:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
    

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
  {src/adm/template/row-list.i "movto-pend"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-pend"}

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
 
    find first param-global
        no-lock no-error.
 
    find first param-estoq
        no-lock no-error.
 
    find docum-est where
        rowid(docum-est) = gr-docum
        no-lock no-error.
 
    if param-estoq.tem-moeda1 then do:
        find moeda where
            moeda.mo-codigo = param-estoq.moeda1
            no-lock no-error.
        assign c-moeda[1] = moeda.descricao.
    end.
    if param-estoq.tem-moeda2 then do:
        find moeda where
            moeda.mo-codigo = param-estoq.moeda2
            no-lock no-error.
        assign c-moeda[2] = moeda.descricao.
    end.
 
    assign l-compras = param-global.modulo-cc
           i-ind-aux = i-ind-aux + 1.
 
    disable movto-pend.num-pedido   with frame {&frame-name}.
    if l-compras then 
        enable movto-pend.num-pedido with frame {&frame-name}.
    else
        run pi-agrega-I.        
 
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
 
    assign movto-pend.serie-docto = ""
           movto-pend.nro-docto = docum-est.nro-docto
           movto-pend.cod-emitente = docum-est.cod-emitente
           movto-pend.nat-operacao = docum-est.nat-operacao
           movto-pend.tipo = 1
           movto-pend.sequencia = i-ind-aux.
 
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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
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
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-agrega-I V-table-Win 
PROCEDURE pi-agrega-I :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    assign l-compras = no.
    if input frame {&frame-name} movto-pend.num-pedido <> 0 then 
        assign l-compras = yes.
 
    disable movto-pend.numero-ordem with frame {&frame-name}.
    if l-compras then
        enable movto-pend.numero-ordem with frame {&frame-name}.
    else
        run pi-agrega-II.        
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-agrega-II V-table-Win 
PROCEDURE pi-agrega-II :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    disable movto-pend.it-codigo with frame {&frame-name}.
    if not l-compras then
        enable movto-pend.it-codigo with frame {&frame-name}.
    else
        run pi-agrega-III.        
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-agrega-III V-table-Win 
PROCEDURE pi-agrega-III :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    find item where 
        item.it-codigo = input frame {&frame-name} movto-pend.it-codigo
        no-lock no-error.
 
    if available item then
        assign gr-item = rowid(item).
    else
        assign gr-item = ?.
 
    if available item then
        display item.cod-localiz @ movto-pend.cod-localiz with frame {&frame-name}.
 
    if available ordem-compra then
        display ordem-compra.dep-almoxar @ movto-pend.cod-depos with frame {&frame-name}.
    else if available item then
        display item.deposito-pad @ movto-pend.cod-depos with frame {&frame-name}.
 
    disable movto-pend.conta-aplic with frame {&frame-name}.
    if available item and
        available ordem-compra and
        (item.tipo-contr = 1 or
        item.tipo-contr = 3 or
        item.tipo-contr = 4) then do:
        display ordem-compra.conta-contabil @ movto-pend.conta-apli with frame {&frame-name}.
        enable movto-pend.conta-aplic with frame {&frame-name}.
    end.
 
    disable movto-pend.cod-refer with frame {&frame-name}.        
    if item.tipo-con-est = 4 then    
        enable movto-pend.cod-refer with frame {&frame-name}.
    else
        run pi-agrega-IV.
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-agrega-IV V-table-Win 
PROCEDURE pi-agrega-IV :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    disable movto-pend.parcela with frame {&frame-name}.
    if l-compras then
        enable movto-pend.parcela with frame {&frame-name}.
    else
        run pi-agrega-V.
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-agrega-V V-table-Win 
PROCEDURE pi-agrega-V :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    find prazo-compra where 
        prazo-compra.numero-ordem = input frame {&frame-name} movto-pend.numero-ordem and
        prazo-compra.parcela = input frame {&frame-name} movto-pend.parcela
        no-lock no-error.
    if available prazo-compra then do:
        find familia where familia.fm-codigo = item.fm-codigo no-lock.
        if available familia then do:
            assign de-aux-1 = prazo-compra.quant-saldo +
                              (prazo-compra.quantidade * familia.var-quantid / 100)
                   de-aux-2 = prazo-compra.quant-saldo -
                              (prazo-compra.quantidade * familia.var-quantid / 100).
        end.
        else do:                              
            assign de-aux-1 = prazo-compra.quant-saldo +
                              (prazo-compra.quantidade * 100 / 100)
                   de-aux-2 = prazo-compra.quant-saldo -
                              (prazo-compra.quantidade * 100 / 100).
        end.
        assign de-quantidade = prazo-compra.quant-saldo
               c-un = prazo-compra.un.
    end.                                                 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-agrega-VI V-table-Win 
PROCEDURE pi-agrega-VI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    find saldo-estoq where
        saldo-estoq.it-codigo = input frame {&frame-name} movto-pend.it-codigo and
        saldo-estoq.cod-estabel = docum-est.cod-estabel and
        saldo-estoq.cod-depos = input frame {&frame-name} movto-pend.cod-depos and
        saldo-estoq.cod-localiz = input frame {&frame-name} movto-pend.cod-localiz and
        saldo-estoq.cod-refer = input frame {&frame-name} movto-pend.cod-refer and
        saldo-estoq.lote = input frame {&frame-name} movto-pend.lote
        no-lock no-error.
 
    if available saldo-estoq then
        display saldo-estoq.dt-vali-lote @ movto-pend.dt-vali-lote with frame {&frame-name}.
 
    disable movto-pend.dt-vali-lote with frame {&frame-name}.
    if item.tipo-con-est > 2 and available saldo-estoq then
        enable movto-pend.dt-vali-lote with frame {&frame-name}.
 
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
 
    if input frame {&frame-name} movto-pend.num-pedido <> 0 then do:
        find pedido-compr where
            pedido-compr.num-pedido = input frame {&frame-name} movto-pend.num-pedido
            no-lock no-error.
        if not available pedido-compr then do:
            {include/i-vldprg.i}
            {utp/ut-table.i mgind pedido-compr 1}
            run utp/ut-msgs.p (input "show", input 47, input return-value).
            apply "entry" to movto-pend.num-pedido in frame {&frame-name}.
            return error.
        end.
        
        assign c-estabelec = pedido-compr.cod-estabel.

        if pedido-compr.situacao = 3 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 7169, input "").
            apply "entry" to movto-pend.num-pedido in frame {&frame-name}.
            return error.
        end.
        if pedido-compr.natureza <> 3 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 6412, input "").
            apply "entry" to movto-pend.num-pedido in frame {&frame-name}.
            return error.
        end.
        if pedido-compr.cod-emitente <> docum-est.cod-emitente then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 7350, input "").
            if return-value = "no" then do:
                apply "entry" to movto-pend.num-pedido in frame {&frame-name}.
                return error.
            end.                
        end.
    end.        
 
    if movto-pend.numero-ordem <> 0 then do:
        find ordem-compra where
            ordem-compra.numero-ordem = input frame {&frame-name} movto-pend.numero-ordem
            no-lock no-error.
        if not available ordem-compra then do:
            {include/i-vldprg.i}
            {utp/ut-table.i mgind ordem-compra 1}
            run utp/ut-msgs.p (input "show", input 47, input return-value).
            apply "entry" to movto-pend.numero-ordem in frame {&frame-name}.
            return error.
        end.
        if input frame {&frame-name} movto-pend.num-pedido <> 0 then do:
            if ordem-compra.num-pedido <> ordem-compra.num-pedido then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show", input 7342, input "").
                apply "entry" to movto-pend.numero-ordem in frame {&frame-name}.
                return error.
            end.
        end.
        if ordem-compra.situacao <> 2 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 7351, input "").
            apply "entry" to movto-pend.numero-ordem in frame {&frame-name}.
            return error.
        end.            
        find first prazo-compra where
            prazo-compra.numero-ordem = ordem-compra.numero-ordem and
            prazo-compra.situacao = 2
            no-lock no-error.
        if not available prazo-compra then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 7343, input "").
            apply "entry" to movto-pend.numero-ordem in frame {&frame-name}.
            return error.
        end.        
        display ordem-compra.it-codigo @ movto-pend.it-codigo with frame {&frame-name}.
    end.
 
    find item where 
        item.it-codigo = input frame {&frame-name} movto-pend.it-codigo
        no-lock no-error.
    if not available item then do:
        {include/i-vldprg.i}
        {utp/ut-table.i mgind item 1}
        run utp/ut-msgs.p (input "show", input 47, input return-value).
        apply "entry" to movto-pend.it-codigo in frame {&frame-name}.
        return error.
    end.
    if item.cod-obsoleto = 3 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show", input 563, input "").
        apply "entry" to movto-pend.it-codigo in frame {&frame-name}.
        return error.
    end.
 
    if input frame {&frame-name} movto-pend.cod-refer <> "" then do:
        find referencia where
            referencia.cod-refer = input frame {&frame-name} movto-pend.cod-refer
            no-lock no-error.
        if not available referencia then do:
            {include/i-vldprg.i}
            {utp/ut-table.i mgind referencia 1}
            run utp/ut-msgs.p (input "show", input 47, input return-value).
            apply "entry" to movto-pend.cod-refer in frame {&frame-name}.
            return error.
        end.
    end.
 
    if input frame {&frame-name} movto-pend.parcela <> 0 then do:
        find prazo-compra use-index ordem where
            prazo-compra.numero-ordem = ordem-compra.numero-ordem and
            prazo-compra.parcela = input frame {&frame-name} movto-pend.parcela
            no-lock no-error.
        if not available prazo-compra then do:    
            {include/i-vldprg.i}
            {utp/ut-field.i mgind movto-pend parcela 1}
            run utp/ut-msgs.p (input "show", input 47, input return-value).
            apply "entry" to movto-pend.parcela in frame {&frame-name}.
            return error.
        end.
        if prazo-compra.situacao <> 2 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 6898, input "").
            apply "entry" to movto-pend.parcela in frame {&frame-name}.
            return error.
        end.
    end.
    
    assign i-empresa = param-global.empresa-prin.
      
    &if defined (bf_dis_consiste_conta) &then
      
        find estabelec where
             estabelec.cod-estabel = c-estabelec no-lock no-error.

        run cdp/cd9970.p (input rowid(estabelec),
                          output i-empresa).
    &endif

    if input frame {&frame-name} movto-pend.conta-aplic <> "" then do:
        find conta-contab where
            conta-contab.ep-codigo = i-empresa and
            conta-contab.conta-contabil = input frame {&frame-name} movto-pend.conta-aplic
            no-lock no-error.
        if not available conta-contab then do:
            {include/i-vldprg.i}
            {utp/ut-field.i mgind movto-pend conta-aplic 1}
            run utp/ut-msgs.p (input "show", input 47, input return-value).
            apply "entry" to movto-pend.conta-aplic in frame {&frame-name}.
            return error.
        end.
        if conta-contab.tipo = 6 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 444, input "").
            apply "entry" to movto-pend.conta-aplic in frame {&frame-name}.
            return error.
        end.
        if conta-contab.estado <> 3 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 443, input "").
            apply "entry" to movto-pend.conta-aplic in frame {&frame-name}.
            return error.
        end.
        if conta-contab.estoque = 10 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 445, input "").
            apply "entry" to movto-pend.conta-aplic in frame {&frame-name}.
            return error.
        end.
        if conta-contab.estoque = 9 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 1784, input "").
            apply "entry" to movto-pend.conta-aplic in frame {&frame-name}.
            return error.
        end.
    end.

    assign i-empresa = param-global.empresa-prin.

    &if defined (bf_dis_consiste_conta) &then

        find estabelec where
             estabelec.cod-estabel = c-estabelec no-lock no-error.

        run cdp/cd9970.p (input rowid(estabelec),
                          output i-empresa).
    &endif

    if input frame {&frame-name} movto-pend.conta-contabil <> "" then do:
        find conta-contab where
            conta-contab.ep-codigo = i-empresa and
            conta-contab.conta-contabil = input frame {&frame-name} movto-pend.conta-contabil
            no-lock no-error.
        if not available conta-contab then do:
            {include/i-vldprg.i}
            {utp/ut-field.i mgind movto-pend conta-contabil 1}
            run utp/ut-msgs.p (input "show", input 47, input return-value).
            apply "entry" to movto-pend.conta-contabil in frame {&frame-name}.
            return error.
        end.
        if input frame {&frame-name} movto-pend.conta-aplic = 
           input frame {&frame-name} movto-pend.conta-contabil then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 7363,input return-value).
            apply "entry" to movto-pend.conta-contabil in frame {&frame-name}.
            return error.
        end.
        if conta-contab.estado <> 3 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 443, input "").
            apply "entry" to movto-pend.conta-contabil in frame {&frame-name}.
            return error.
        end.
        if conta-contab.estoque = 10 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 445, input "").
            apply "entry" to movto-pend.conta-contabil in frame {&frame-name}.
            return error.
        end.
        if conta-contab.estoque = 9 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 1784, input "").
            apply "entry" to movto-pend.conta-contabil in frame {&frame-name}.
            return error.
        end.
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
  {src/adm/template/snd-list.i "movto-pend"}

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


