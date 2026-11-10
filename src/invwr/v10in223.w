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
{include/i-prgvrs.i V10IN223 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v10in223 MUT}
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
def var l-inclui as logical   no-undo.
def var i-pedido as integer   no-undo.
def var i-ordem  as integer   no-undo.
def var i-x      as integer   no-undo.
def var c-handle as character no-undo.
def var h_v11in223 as handle no-undo.

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
&Scoped-Define ENABLED-FIELDS movto-pend.cod-depos ~
movto-pend.conta-contabil 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-depos ~{&FP2}cod-depos ~{&FP3}~
 ~{&FP1}conta-contabil ~{&FP2}conta-contabil ~{&FP3}
&Scoped-define ENABLED-TABLES movto-pend
&Scoped-define FIRST-ENABLED-TABLE movto-pend
&Scoped-Define ENABLED-OBJECTS rt-key RECT-1 
&Scoped-Define DISPLAYED-FIELDS movto-pend.it-codigo movto-pend.num-pedido ~
movto-pend.numero-ordem movto-pend.parcela movto-pend.log-1 ~
movto-pend.cod-refer movto-pend.conta-aplic movto-pend.cod-depos ~
movto-pend.cod-localiz movto-pend.lote movto-pend.dt-vali-lote ~
movto-pend.conta-contabil 
&Scoped-Define DISPLAYED-OBJECTS fi-descricao c-desc-ref fi-aplicacao ~
fi-deposito fi-localizacao fi-contabil 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS movto-pend.it-codigo movto-pend.num-pedido ~
movto-pend.numero-ordem movto-pend.parcela 
&Scoped-define ADM-ASSIGN-FIELDS movto-pend.it-codigo movto-pend.num-pedido ~
movto-pend.numero-ordem movto-pend.parcela movto-pend.log-1 ~
movto-pend.cod-refer movto-pend.conta-aplic movto-pend.cod-depos ~
movto-pend.cod-localiz movto-pend.lote movto-pend.dt-vali-lote ~
movto-pend.conta-contabil 

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
DEFINE VARIABLE c-desc-ref AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fi-aplicacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-contabil AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-deposito AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-localizacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87.29 BY 7.75.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87.43 BY 4.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     movto-pend.it-codigo AT ROW 1.33 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     fi-descricao AT ROW 1.33 COL 34.86 COLON-ALIGNED NO-LABEL
     movto-pend.num-pedido AT ROW 2.33 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     movto-pend.numero-ordem AT ROW 3.33 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     movto-pend.parcela AT ROW 4.33 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     movto-pend.log-1 AT ROW 4.46 COL 37
          VIEW-AS TOGGLE-BOX
          SIZE 24.29 BY .83
     movto-pend.cod-refer AT ROW 6.04 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-desc-ref AT ROW 6.04 COL 29.57 COLON-ALIGNED NO-LABEL
     movto-pend.conta-aplic AT ROW 7.04 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     fi-aplicacao AT ROW 7.04 COL 35.86 COLON-ALIGNED NO-LABEL
     movto-pend.cod-depos AT ROW 8.04 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     fi-deposito AT ROW 8.04 COL 24.72 COLON-ALIGNED NO-LABEL
     movto-pend.cod-localiz AT ROW 9.04 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.14 BY .88
     fi-localizacao AT ROW 9.04 COL 31.72 COLON-ALIGNED NO-LABEL
     movto-pend.lote AT ROW 10.04 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.14 BY .88
     movto-pend.dt-vali-lote AT ROW 11.04 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     movto-pend.conta-contabil AT ROW 12.04 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     fi-contabil AT ROW 12.04 COL 35.57 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1.04 COL 1
     RECT-1 AT ROW 5.54 COL 1.14
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
         HEIGHT             = 12.29
         WIDTH              = 87.72.
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

/* SETTINGS FOR FILL-IN c-desc-ref IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-pend.cod-depos IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN movto-pend.cod-localiz IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN movto-pend.cod-refer IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN movto-pend.conta-aplic IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN movto-pend.conta-contabil IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN movto-pend.dt-vali-lote IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-aplicacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-contabil IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-deposito IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-localizacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-pend.it-codigo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR TOGGLE-BOX movto-pend.log-1 IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN movto-pend.lote IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN movto-pend.num-pedido IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN movto-pend.numero-ordem IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN movto-pend.parcela IN FRAME f-main
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
OR  MOUSE-SELECT-DBLCLICK OF movto-pend.cod-depos IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in084.w
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
                     &variavel-ref=fi-deposito
                     &where="deposito.cod-depos = input frame {&frame-name}
                             movto-pend.cod-depos"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.cod-localiz V-table-Win
ON F5 OF movto-pend.cod-localiz IN FRAME f-main /* Localiza‡Æo */
OR  MOUSE-SELECT-DBLCLICK OF movto-pend.cod-localiz IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in189.w
                       &campo=movto-pend.cod-localiz
                       &campozoom=cod-localiz}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.cod-localiz V-table-Win
ON LEAVE OF movto-pend.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
    {include/leave.i &tabela=localizacao
                   &atributo-ref=descricao
                   &variavel-ref=fi-localizacao
                   &where="localizacao.cod-localiz = input frame {&frame-name} movto-pend.cod-localiz and
                           localizacao.cod-estabel = docum-est.cod-estabel and
                           localizacao.cod-depos   = input frame {&frame-name} movto-pend.cod-depos"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.cod-refer V-table-Win
ON F5 OF movto-pend.cod-refer IN FRAME f-main /* Referˆncia */
OR  MOUSE-SELECT-DBLCLICK OF movto-pend.cod-refer IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in377.w
                       &campo=movto-pend.cod-refer
                       &campozoom=cod-refer}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.cod-refer V-table-Win
ON LEAVE OF movto-pend.cod-refer IN FRAME f-main /* Referˆncia */
DO:
  {include/leave.i &tabela=referencia
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-ref
                   &where="referencia.cod-refer = input frame {&frame-name}
                           movto-pend.cod-refer"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.conta-aplic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.conta-aplic V-table-Win
ON F5 OF movto-pend.conta-aplic IN FRAME f-main /* Conta Aplica‡Æo */
OR  MOUSE-SELECT-DBLCLICK OF movto-pend.conta-aplic IN FRAME {&FRAME-NAME} DO:
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.conta-aplic V-table-Win
ON LEAVE OF movto-pend.conta-aplic IN FRAME f-main /* Conta Aplica‡Æo */
DO:
    {include/leave.i &tabela=conta-contab
                     &atributo-ref=titulo
                     &variavel-ref=fi-aplicacao
                     &where="conta-contab.conta-contabil = input frame {&frame-name}
                             movto-pend.conta-aplic and
                             conta-contab.ep-codigo = param-global.empresa-prin"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.conta-contabil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.conta-contabil V-table-Win
ON F5 OF movto-pend.conta-contabil IN FRAME f-main /* Conta Cont bil */
OR  MOUSE-SELECT-DBLCLICK OF movto-pend.conta-contabil IN FRAME {&FRAME-NAME} DO:

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.conta-contabil V-table-Win
ON LEAVE OF movto-pend.conta-contabil IN FRAME f-main /* Conta Cont bil */
DO:
    {include/leave.i &tabela=conta-contab
                     &atributo-ref=titulo
                     &variavel-ref=fi-contabil
                     &where="conta-contab.conta-contabil = input frame {&frame-name}
                             movto-pend.conta-contabil and
                             conta-contab.ep-codigo = param-global.empresa-prin"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.it-codigo V-table-Win
ON F5 OF movto-pend.it-codigo IN FRAME f-main /* Item */
OR  MOUSE-SELECT-DBLCLICK OF movto-pend.it-codigo IN FRAME {&frame-name} DO:
    {include/zoomvar.i &prog-zoom=inzoom/z02in172.w
                       &campo=movto-pend.it-codigo
                       &campozoom=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.it-codigo V-table-Win
ON LEAVE OF movto-pend.it-codigo IN FRAME f-main /* Item */
DO:
    find item where item.it-codigo = input frame {&frame-name} movto-pend.it-codigo
         no-lock no-error.
    if  avail item then do with frame {&frame-name}:
        assign movto-pend.cod-refer:sensitive      = (item.tipo-con-est = 4)
               movto-pend.conta-aplic:sensitive    = (item.tipo-contr = 1 or
                                                      item.tipo-contr = 4)
               movto-pend.conta-aplic:screen-value = (item.conta-aplic)                                                      
               movto-pend.cod-localiz:sensitive    = (not item.loc-unica)
               movto-pend.cod-depos:screen-value   = if avail ordem-compra 
                                                     then ordem-compra.dep-almoxar
                                                     else item.deposito-pad
               movto-pend.cod-localiz:screen-value = item.cod-localiz
               movto-pend.cod-localiz:sensitive    = (item.loc-unica = no)
               movto-pend.lote:sensitive           = (item.tipo-con-est <> 1).
        RUN get-link-handle IN adm-broker-hdl
            (INPUT this-procedure, INPUT "Acha-wh2-target", OUTPUT c-handle).
        if  valid-handle(widget-handle(c-handle)) then 
            run pi-inicializa-campo in widget-handle(c-handle) (input rowid(item)).
    end.       
    else do with frame {&frame-name}:
        assign movto-pend.cod-refer:sensitive   = no
               movto-pend.conta-aplic:sensitive = no
               movto-pend.cod-depos:sensitive   = no.
    end.
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=fi-descricao
                     &where="item.it-codigo = input frame {&frame-name}
                             movto-pend.it-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.lote V-table-Win
ON LEAVE OF movto-pend.lote IN FRAME f-main /* Lote/S‚rie */
DO:
  find first saldo-estoq where
        saldo-estoq.it-codigo    =
          input frame {&frame-name} movto-pend.it-codigo   and
        saldo-estoq.lote         =
          input frame {&frame-name} movto-pend.lote        
        no-error.
  if avail saldo-estoq then do:  
      assign movto-pend.dt-vali-lote:screen-value in frame {&frame-name} = string(saldo-estoq.dt-vali-lote).
      disable movto-pend.dt-vali-lote with frame {&frame-name}.
  end.
  else do:
      assign movto-pend.dt-vali-lote:screen-value in frame {&frame-name} = " ".
      enable movto-pend.dt-vali-lote with frame {&frame-name}.
  end.
 
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.num-pedido V-table-Win
ON F5 OF movto-pend.num-pedido IN FRAME f-main /* Pedido */
do:
    {include/zoomvar.i &prog-zoom=inzoom/z13in274.w
                       &campo=movto-pend.numero-ordem
                       &campo2=movto-pend.num-pedido   
                       &campo3=movto-pend.parcela
                       &campozoom=numero-ordem
                       &campozoom2=num-pedido
                       &campozoom3=parcela
                       &parametros="run pi-recebe-parametros in wh-pesquisa 
                                        (input docum-est.cod-emitente, 
                                         input natur-oper.tipo,
                                         input input frame {&frame-name} movto-pend.it-codigo)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.num-pedido V-table-Win
ON LEAVE OF movto-pend.num-pedido IN FRAME f-main /* Pedido */
DO:
   assign i-pedido = input frame {&frame-name} movto-pend.num-pedido.
   if input frame {&frame-name} movto-pend.num-pedido = 0 and
      input frame {&frame-name} movto-pend.numero-ordem <> 0 then do:
       find ordem-compra where
            ordem-compra.numero-ordem = input frame {&frame-name} movto-pend.numero-ordem
            no-lock no-error.
       if available ordem-compra and 
           ordem-compra.num-pedido <> 0 then
           assign movto-pend.num-pedido:screen-value in frame {&frame-name} = string(ordem-compra.num-pedido).
   end.
   
   if  i-pedido <> 0 
   and input frame {&frame-name} movto-pend.numero-ordem = 0 then
       /* Busca primeira ordem com data de entrega mais antiga */ 
       for each ordem-compra        
          where ordem-compra.num-pedido = i-pedido
            and ordem-compra.situacao   = 2         /* Confirmada */
            and (   ordem-compra.it-codigo = input frame {&frame-name} movto-pend.it-codigo
                 or input frame {&frame-name} movto-pend.it-codigo = " " ) no-lock,

          first prazo-compra use-index ordem-sit no-lock
             where prazo-compra.numero-ordem  = ordem-compra.numero-ordem
               and prazo-compra.situacao      = 2  /* Confirmada */
               and ( prazo-compra.quant-saldo - prazo-compra.dec-1 > 0 )
             by prazo-compra.data-entrega
             by prazo-compra.numero-ordem:
             
          assign movto-pend.numero-ordem:screen-value in frame {&frame-name} = 
                                         string(ordem-compra.numero-ordem).
          leave.                         
       end.                                                
                                                      
   
   if adm-new-record = no and 
      input frame {&frame-name} movto-pend.num-pedido <> 0 then do:
      find prazo-compr where
           prazo-compr.numero-ordem = input frame {&frame-name} movto-pend.numero-ordem and
           prazo-compr.parcela      = input frame {&frame-name} movto-pend.parcela
           no-lock no-error.
       if avail prazo-compr then
           run pi-inicializa-campo in h_v11in223 (input rowid(prazo-compra)).
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.num-pedido V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-pend.num-pedido IN FRAME f-main /* Pedido */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.numero-ordem V-table-Win
ON F5 OF movto-pend.numero-ordem IN FRAME f-main /* Ordem */
OR  MOUSE-SELECT-DBLCLICK OF movto-pend.numero-ordem IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=inzoom/z13in274.w
                       &campo=movto-pend.numero-ordem
                       &campozoom=numero-ordem                       
                       &parametros="run pi-recebe-parametros in wh-pesquisa 
                                        (input docum-est.cod-emitente, 
                                         input natur-oper.tipo,
                                         input input frame {&frame-name} movto-pend.it-codigo)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.numero-ordem V-table-Win
ON LEAVE OF movto-pend.numero-ordem IN FRAME f-main /* Ordem */
DO:
    do  with frame {&frame-name}:

        assign i-ordem = input movto-pend.numero-ordem.

        find item 
            where item.it-codigo = input movto-pend.it-codigo no-lock no-error.

        find ordem-compra 
            where ordem-compra.numero-ordem = i-ordem no-lock no-error.
            
        assign movto-pend.conta-aplic:screen-value = if  avail ordem-compra 
                                                     and can-do("1,4", string(item.tipo-contr))
                                                     then 
                                                         ordem-compra.conta-contabil
                                                     else 
                                                         if  avail item then
                                                             item.conta-aplic
                                                         else 
                                                             " ".
        if  avail ordem-compra then do:
            find first prazo-compra 
                where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
                  and prazo-compra.quant-saldo  > 0 no-lock no-error.
            
            if avail prazo-compra then
                assign movto-pend.parcela:screen-value = string(prazo-compra.parcela).
                
            if  input movto-pend.num-pedido = 0 then
                assign movto-pend.num-pedido:screen-value = string(ordem-compra.num-pedido).
                
            if  input movto-pend.it-codigo = " " then do:
                find item
                    where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
                    
                assign movto-pend.it-codigo:screen-value = item.it-codigo
                       fi-descricao:screen-value = item.desc-item.
                       
                apply "leave" to movto-pend.it-codigo in frame {&frame-name}.

            end.           
        end. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.parcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.parcela V-table-Win
ON F5 OF movto-pend.parcela IN FRAME f-main /* Parcela */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in356.w
                     &campo=movto-pend.parcela
                     &campozoom=parcela
                     &parametros="run pi-seta-inicial in wh-pesquisa 
                                      (input rowid(ordem-compra))."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.parcela V-table-Win
ON LEAVE OF movto-pend.parcela IN FRAME f-main /* Parcela */
DO:
    find prazo-compra where
         prazo-compra.numero-ordem = input frame {&frame-name} 
                                     movto-pend.numero-ordem and
         prazo-compra.parcela      = input frame {&frame-name} movto-pend.parcela
         no-lock no-error.
    if  avail prazo-compra then do:     
        enable movto-pend.log-1 with frame {&frame-name}.
        if  valid-handle(h_v11in223) then 
            run pi-inicializa-campo in h_v11in223 (input rowid(prazo-compra)).
    end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.parcela V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-pend.parcela IN FRAME f-main /* Parcela */
DO:
  apply "f5" to self.
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
 
  find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
  find first param-global no-lock no-error.
  find first param-estoq  no-lock no-error.
 
  if  movto-pend.num-pedido:load-mouse-pointer("image/lupa.cur") then .
  if  movto-pend.numero-ordem:load-mouse-pointer("image/lupa.cur") then .
  if  movto-pend.parcela:load-mouse-pointer("image/lupa.cur") then .
  if  movto-pend.it-codigo:load-mouse-pointer("image/lupa.cur") then .
  if  movto-pend.cod-refer:load-mouse-pointer("image/lupa.cur") then .
  if  movto-pend.cod-depos:load-mouse-pointer("image/lupa.cur") then .
  if  movto-pend.cod-localiz:load-mouse-pointer("image/lupa.cur") then .
  

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
 
  /* Code placed here will execute AFTER standard behavior.    */
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
  def buffer b-movto-pend for movto-pend.
 
  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.
 
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
  if  l-inclui then do:    /*  chave primaria e nao unica  */
     find last b-movto-pend no-lock
           where b-movto-pend.cod-emitente = docum-est.cod-emitente
             and b-movto-pend.nat-operacao = docum-est.nat-operacao
             and b-movto-pend.serie-docto  = docum-est.serie-docto
             and b-movto-pend.nro-docto    = docum-est.nro-docto  no-error.
      assign movto-pend.cod-emitente = docum-est.cod-emitente
             movto-pend.nat-operacao = docum-est.nat-operacao
             movto-pend.serie-docto  = docum-est.serie-docto
             movto-pend.nro-docto    = docum-est.nro-docto
             movto-pend.tipo         = 1
             movto-pend.sequencia    = if not avail b-movto-pend then 1
                                       else b-movto-pend.sequencia + 1.
  end.
 
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
  if  avail movto-pend then do:
      find item where item.it-codigo = movto-pend.it-codigo no-lock no-error.
      find deposito where deposito.cod-depos = movto-pend.cod-depos 
           no-lock no-error.
      find localizacao where localizacao.cod-localiz = movto-pend.cod-localiz
           no-lock no-error.
      find conta-contab where
           conta-contab.ep-codigo      = param-global.empresa-prin and 
           conta-contab.conta-contabil = movto-pend.conta-aplic 
           no-lock no-error.
      assign fi-descricao   = if avail item then item.desc-item else ""
             fi-deposito    = if avail deposito then deposito.nome else ""
             fi-localizacao = if avail localizacao then localizacao.descricao
                              else ""
             fi-aplicacao   = if avail conta-contab then conta-contab.titulo 
                              else "".
      find conta-contab where
           conta-contab.ep-codigo      = param-global.empresa-prin and 
           conta-contab.conta-contabil = movto-pend.conta-contabil
           no-lock no-error.
      assign fi-contabil = if avail conta-contab then conta-contab.titulo 
                           else "".
  end.
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  {utp/ut-field.i mgind item-doc-est encerra-pa 01}
  assign movto-pend.log-1:label in frame {&frame-name} = return-value.
 
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
  find docum-est where
       rowid(docum-est) = v-row-parent no-lock no-error.
  find natur-oper where
       natur-oper.nat-operacao = docum-est.nat-operacao 
       no-lock no-error.
  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  do  with frame {&frame-name}:
      if adm-new-record then
          assign movto-pend.num-pedido:sensitive   = param-global.modulo-cc
                 movto-pend.numero-ordem:sensitive = param-global.modulo-cc
                 movto-pend.parcela:sensitive      = param-global.modulo-cc.
      else
          assign movto-pend.num-pedido:sensitive   = no
                 movto-pend.numero-ordem:sensitive = no
                 movto-pend.parcela:sensitive      = no.
  end.
  {utp/ut-field.i mgind item-doc-est encerra-pa 01}
  assign movto-pend.log-1:label in frame {&frame-name} = return-value.
 
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
  find first param-global no-lock no-error.
  find first param-estoq  no-lock no-error.
  /* Dispatch standard ADM method.                             */
 
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    /* Code placed here will execute AFTER standard behavior.    */
 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter h-handle as handle no-undo.
 
assign h_v11in223 = h-handle.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */    
  assign i-pedido = input frame {&frame-name} movto-pend.num-pedido
         i-ordem  = input frame {&frame-name} movto-pend.numero-ordem.
  if  i-pedido > 0 then do with frame {&frame-name}:
      find pedido-compr where pedido-compr.num-pedido = i-pedido no-lock no-error.
      if  not avail pedido-compr then do:
          {utp/ut-table.i mgind pedido-compr 1}
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show":U, input 2, input return-value).
          apply "entry" to movto-pend.num-pedido in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if  pedido-compr.situacao = 3 then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show":U, input 1813, input "").
          apply "entry" to movto-pend.num-pedido in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.     
      if  pedido-compr.natureza <> 3 then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show":U, input 6412, input "").
          apply "entry" to movto-pend.num-pedido in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if  pedido-compr.cod-emitente <> docum-est.cod-emitente then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show":U, input 5696, input "").
          if  return-value = "no" then do:
              apply "entry" to movto-pend.num-pedido in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.    
      end.
      find ordem-compra no-lock where 
           ordem-compra.numero-ordem = input movto-pend.numero-ordem no-error.
      if  not available ordem-compra then do:
          {utp/ut-table.i mgind ordem-compra 1}
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show":U, input 2, input return-value).
          apply "entry" to movto-pend.numero-ordem in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if  ordem-compra.num-pedido <> pedido-compr.num-pedido then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show":U, input 5701, input "").
          apply "entry" to movto-pend.numero-ordem in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.     
      find first prazo-compra 
           where prazo-compra.numero-ordem = ordem-compra.numero-ordem
             and prazo-compra.parcela      = input frame {&frame-name}
                 movto-pend.parcela no-lock no-error.
      if  not avail prazo-compra then do:
          {utp/ut-table.i mgind prazo-compra 1}
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show":U, input 2, input return-value).
          apply "entry" to movto-pend.parcela in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.       
      if  prazo-compra.situacao <> 2 then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show":U, input 6359, input "").
          apply "entry" to movto-pend.parcela in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
  end.
  find item where item.it-codigo = input frame {&frame-name} movto-pend.it-codigo
       no-lock no-error.
  if  not avail item then do:
      {utp/ut-table.i mgind item 1}
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      apply "entry" to movto-pend.it-codigo in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.     
  if  item.cod-obsoleto = 3 then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show":U, input 999, input "").
      apply "entry" to movto-pend.it-codigo in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if avail ordem-compra and 
     ordem-compra.it-codigo <> item.it-codigo then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show":U, input 5055, input "").
      apply "entry" to movto-pend.it-codigo in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
 
  if movto-pend.cod-refer:sensitive in frame {&frame-name} = yes then do:
      find referencia where
           referencia.cod-refer = input frame {&frame-name} movto-pend.cod-refer
           no-lock no-error.
      if  not avail referencia then do:
          {utp/ut-table.i mgind referencia 1}
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show":U, input 2, input return-value).
          apply "entry" to movto-pend.cod-refer in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
  end.
  if movto-pend.conta-aplic:sensitive in frame {&frame-name} = yes then do:
      find conta-contab where
           conta-contab.ep-codigo    = param-global.empresa-prin and
           conta-contab.conta-contab = input frame {&frame-name} 
           movto-pend.conta-aplic no-lock no-error.
      if  not available conta-contab then do:
          {utp/ut-table.i mgadm conta-contab 1}
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 2, input return-value).
          apply "entry" to movto-pend.conta-aplic in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if  conta-contab.estado <> 3 then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 1062, input "").
          apply "entry" to movto-pend.conta-aplic in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if  conta-contab.estoque = 1 then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 4049, input "").
          apply "entry" to movto-pend.conta-aplic in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if  conta-contab.estoque = 10 then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 4994, input "11").
          apply "entry" to movto-pend.conta-aplic in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
  end.
  if  input frame {&frame-name} movto-pend.lote = "" and 
      movto-pend.lote:sensitive in frame {&frame-name} = yes then do:  
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show":U, input 1818, input "").
      apply "entry" to movto-pend.lote in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  input frame {&frame-name} movto-pend.dt-vali-lote = ? and 
      movto-pend.dt-vali-lote:sensitive in frame {&frame-name} = yes then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show":U, input 1786, input "").
      apply "entry" to movto-pend.lote in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  find conta-contab where
       conta-contab.ep-codigo    = param-global.empresa-prin and
       conta-contab.conta-contab = input frame {&frame-name} 
       movto-pend.conta-contabil no-lock no-error.
  if  not available conta-contab then do:
      {utp/ut-table.i mgadm conta-contab 1}
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      apply "entry" to movto-pend.conta-contabil in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  conta-contab.estado <> 3 then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 1062, input "").
      apply "entry" to movto-pend.conta-contabil in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  conta-contab.estoque = 1 then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 4049, input "").
      apply "entry" to movto-pend.conta-contabil in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  conta-contab.estoque = 10 then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 4994, input "12").
      apply "entry" to movto-pend.conta-contabil in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.  
  find first localizacao where 
       localizacao.cod-localiz = input frame {&frame-name} movto-pend.cod-localiz and
       localizacao.cod-estabel = docum-est.cod-estabel and
       localizacao.cod-depos   = input frame {&frame-name} movto-pend.cod-depos
        no-lock no-error.
  if  not avail localizacao then do:
      {utp/ut-table.i mgind localizacao 1}
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      apply "entry" to movto-pend.cod-localiz in frame {&frame-name}.
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


