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
{include/i-prgvrs.i V02IN368 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v02in368 MUT}
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
def temp-table tt-rat-ordem like rat-ordem
     index codigo   
           int-1.

def buffer b-tt-rat-ordem for tt-rat-ordem.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
def new global shared var gr-docum-est as rowid no-undo.
def new global shared var gr-item-doc-est as rowid no-undo.


def var de-indice     as decimal no-undo.
def var de-preco-unit as decimal no-undo.
def var de-desconto   as decimal no-undo.
def var de-preco-min  as decimal no-undo.
def var de-preco-max  as decimal no-undo.
def var de-preuni     as decimal no-undo.
def var de-qtd-max    as decimal no-undo.
def var de-qtd-ant    as decimal no-undo.
def var de-taxa       as decimal no-undo.
def var i-sequencia   like item-doc-est.sequencia  no-undo.
def var de-qt-do-forn like item-doc-est.qt-do-forn no-undo.
def var de-qtd-item   like item-doc-est.quantidade no-undo.
def var i-codigo      like rat-ordem.int-1         no-undo.

{rep/re1001.i07}
{cdp/cd4329.i2}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES rat-ordem
&Scoped-define FIRST-EXTERNAL-TABLE rat-ordem


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR rat-ordem.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS rat-ordem.int-1 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}int-1 ~{&FP2}int-1 ~{&FP3}
&Scoped-define ENABLED-TABLES rat-ordem
&Scoped-define FIRST-ENABLED-TABLE rat-ordem
&Scoped-Define ENABLED-OBJECTS rt-mold i-num-pedido i-numero-ordem ~
i-parcela RECT-1 de-quantidade l-encerra-pa 
&Scoped-Define DISPLAYED-FIELDS rat-ordem.int-1 
&Scoped-Define DISPLAYED-OBJECTS i-num-pedido i-numero-ordem i-parcela ~
de-quant-saldo de-quantidade l-encerra-pa 

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
DEFINE VARIABLE de-quant-saldo AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-quantidade AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-pedido AS INTEGER FORMAT ">>>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-numero-ordem AS INTEGER FORMAT "zzzzz9,99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-parcela AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57.57 BY 2.58.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57.57 BY 4.42.

DEFINE VARIABLE l-encerra-pa AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     rat-ordem.int-1 AT ROW 1.13 COL 53.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 2 BY 1
     i-num-pedido AT ROW 1.25 COL 24.29 COLON-ALIGNED
     i-numero-ordem AT ROW 2.25 COL 24.29 COLON-ALIGNED
     i-parcela AT ROW 3.25 COL 24.29 COLON-ALIGNED
     de-quant-saldo AT ROW 4.25 COL 24.29 COLON-ALIGNED
     de-quantidade AT ROW 6 COL 24.29 COLON-ALIGNED
     l-encerra-pa AT ROW 7 COL 26.29
     rt-mold AT ROW 1 COL 1
     RECT-1 AT ROW 5.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.rat-ordem
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
         HEIGHT             = 7.21
         WIDTH              = 57.57.
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

/* SETTINGS FOR FILL-IN de-quant-saldo IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       rat-ordem.int-1:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME de-quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-quantidade V-table-Win
ON ENTRY OF de-quantidade IN FRAME f-main
DO:
  assign de-qtd-ant = input frame {&frame-name} de-quantidade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-pedido V-table-Win
ON F5 OF i-num-pedido IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z13in274.w
                     &campo=i-numero-ordem                      
                     &campo2=i-num-pedido    
                     &campozoom=numero-ordem
                     &campozoom2=num-pedido
                     &parametros="run pi-recebe-parametros in wh-pesquisa 
                                      (input docum-est.cod-emitente, 
                                       input natur-oper.tipo,
                                       input item.it-codigo)."}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-pedido V-table-Win
ON LEAVE OF i-num-pedido IN FRAME f-main
DO:
  run pi-pedido-ordem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-pedido V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-num-pedido IN FRAME f-main
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-numero-ordem V-table-Win
ON F5 OF i-numero-ordem IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z13in274.w
                     &campo=i-numero-ordem
                     &campozoom=numero-ordem
                     &parametros="run pi-recebe-parametros in wh-pesquisa
                                      (input docum-est.cod-emitente,
                                       input natur-oper.tipo,
                                       input item.it-codigo)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-numero-ordem V-table-Win
ON LEAVE OF i-numero-ordem IN FRAME f-main
DO:
  run pi-pedido-ordem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-numero-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-numero-ordem IN FRAME f-main
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-parcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-parcela V-table-Win
ON LEAVE OF i-parcela IN FRAME f-main
DO:
  find ordem-compra where
       ordem-compra.numero-ordem = input frame {&frame-name} i-numero-ordem
       no-lock no-error.
  if available ordem-compra then do:
      find prazo-compra where
           prazo-compra.numero-ordem = ordem-compra.numero-ordem and
           prazo-compra.parcela      = input frame {&frame-name} i-parcela 
           no-lock no-error.
      if available prazo-compra and
          prazo-compra.situacao = 2 then 
          assign i-parcela:screen-value in frame {&frame-name} = string(prazo-compra.parcela)
                 de-quant-saldo:screen-value in frame {&frame-name} =
                 string((prazo-compra.quant-saldo - prazo-compra.dec-1)).
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
  if i-num-pedido:load-mouse-pointer("image/lupa.cur")
      in frame {&frame-name} then .
  if i-numero-ordem:load-mouse-pointer("image/lupa.cur")
      in frame {&frame-name} then .

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
  {src/adm/template/row-list.i "rat-ordem"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "rat-ordem"}

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
    if adm-new-record = yes then do:
    &if  defined(ADM-MODIFY-FIELDS) &then
    enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
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
  find docum-est where
        rowid(docum-est) = gr-docum-est
        no-lock no-error.
  find natur-oper where
       natur-oper.nat-operacao = docum-est.nat-operacao
       no-lock no-error.      
    find param-re where
        param-re.usuario = c-seg-usuario
        no-lock no-error.

     find first param-compra
        no-lock no-error.        

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-field.i mgind rat-ordem num-pedido 1}
  assign i-num-pedido:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind rat-ordem numero-ordem 1}
  assign i-numero-ordem:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind rat-ordem parcela 1}
  assign i-parcela:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind prazo-compra quant-saldo 1}
  assign de-quant-saldo:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind movto-estoq quantidade 1}
  assign de-quantidade:label in frame {&frame-name} = return-value.

  if natur-oper.tipo = 1 then do: /*na entrada encerra parcela*/
    {utp/ut-field.i mgind item-doc-est encerra-pa 1}
  end.
  else do: /*na devoluá∆o reabre parcela*/
    {utp/ut-field.i mgind item-doc-est reabre-pa 1}
  end.
  assign l-encerra-pa:label in frame {&frame-name} = return-value.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-rat V-table-Win 
PROCEDURE pi-gera-tt-rat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter table for tt-rat-ordem.
def var de-quantidade-total like item-doc-est.quantidade no-undo.
def var de-quantidade-aux   like item-doc-est.quantidade no-undo.
def var c-quant-total as char no-undo.

  find first tt-rat-ordem where
       tt-rat-ordem.num-pedido   = input frame {&frame-name} i-num-pedido   and
       tt-rat-ordem.numero-ordem = input frame {&frame-name} i-numero-ordem and
       tt-rat-ordem.parcela      = input frame {&frame-name} i-parcela      and
       tt-rat-ordem.log-2        = yes
       no-lock no-error.
  if avail tt-rat-ordem and i-codigo = ? then do:
     {utp/ut-table.i mgind rat-ordem 1}
     run utp/ut-msgs.p (input "show",input 1,input return-value).
     apply 'entry' to i-numero-ordem in frame {&frame-name}.
     return error.
  end.

  if input frame {&frame-name} i-num-pedido = 0 and
      input frame {&frame-name} i-numero-ordem <> 0 then do:
      find ordem-compra where
          ordem-compra.numero-ordem = input frame {&frame-name} i-numero-ordem
          no-lock no-error.
      if not available ordem-compra then do:
          /* mensagem: Ordem de compra n∆o cadastrada */
          {utp/ut-table.i mgind ordem-compra 01}
          run utp/ut-msgs.p (input "show",input 47,input return-value).
          apply 'entry' to i-numero-ordem in frame {&frame-name}.
          return error.
      end.
      if ordem-compra.num-pedido = 0 then do:
          /* mensagem: Ordem de compra n∆o possui pedido */
          run utp/ut-msgs.p (input "show",input 15185,input " ").
          apply 'entry' to i-numero-ordem in frame {&frame-name}.
          return error.
      end.
  end.
  if input frame {&frame-name} i-num-pedido <> 0 then do:
       find pedido-compr where
          pedido-compr.num-pedido = input frame {&frame-name} i-num-pedido
          no-lock no-error.
      if not available pedido-compr then do:
          /* mensagem: Pedido de compra nío cadastrado */
          {utp/ut-table.i mgind pedido-compr 01}
          run utp/ut-msgs.p (input "show",input 47,input return-value).
          apply 'entry' to i-num-pedido in frame {&frame-name}.
          return error.
      end.
      if pedido-compr.situacao = 3 then do:
          /* mensagem: Pedido de compra eliminado */
          run utp/ut-msgs.p (input "show",input 7169,input " ").
          apply 'entry' to i-num-pedido in frame {&frame-name}.
          return error.
      end.
      if pedido-compr.end-entrega <> docum-est.cod-estabel then do:
          /* mensagem: Estabelecimento de entrega do pedido ≤ diferente do estabelecimento do documento. Confirma? */
          run utp/ut-msgs.p (input "show",input 6814,input " ").
          if return-value <> "yes" then do:
              apply 'entry' to i-num-pedido in frame {&frame-name}.
              return error.
          end.
      end.
      if pedido-compr.cod-emitente <> docum-est.cod-emitente then do:
          /* mensagem: Pedido de compra nío pertence ao fornecedor do documento. Confirma? */
          run utp/ut-msgs.p (input "show",input 15186,input " ").
          if return-value <> "yes" then do:
              apply 'entry' to i-num-pedido in frame {&frame-name}.
              return error.
          end.
      end.
      find ordem-compra where
          ordem-compra.numero-ordem = input frame {&frame-name} i-numero-ordem
          no-lock no-error.
      if not available ordem-compra then do:
          /* mensagem: Ordem de compra nío cadastrada */
          {utp/ut-table.i mgind ordem-compra 01}
          run utp/ut-msgs.p (input "show",input 47,input return-value).
          apply 'entry' to i-numero-ordem in frame {&frame-name}.
          return error.
      end.
      if input frame {&frame-name} i-num-pedido <> ordem-compra.num-pedido then do:
          /* mensagem: Ordem de compra nío pertence ao pedido */
          run utp/ut-msgs.p (input "show",input 7342,input " ").
          apply 'entry' to i-numero-ordem in frame {&frame-name}.
          return error.
      end.
      if item.it-codigo <> ordem-compra.it-codigo then do:
          /* mensagem: Item da ordem nío confere com item da nota fiscal */
          run utp/ut-msgs.p (input "show",input 15187,input " ").
          apply 'entry' to i-numero-ordem in frame {&frame-name}.
          return error.
      end.
      if ordem-compra.situacao <> 2 then do:
          /* mensagem: Situaªío da ordem nío permite movimentaªío */
          run utp/ut-msgs.p (input "show",input 15188,input " ").
          apply 'entry' to i-numero-ordem in frame {&frame-name}.
          return error.
      end.
      if ordem-compra.situacao = 2 and
          param-compra.pend-aprov = 2 and
          ordem-compra.pend-aprov = 2 then do:
          /* mensagem: Ordem de compra pendente de aprovaªío. Nío pode ser recebida */
          run utp/ut-msgs.p (input "show",input 8813,input " ").
          apply 'entry' to i-numero-ordem in frame {&frame-name}.
          return error.
      end.

      find first prazo-compra where
          prazo-compra.numero-ordem = ordem-compra.numero-ordem and
          prazo-compra.situacao     = 2
          no-lock no-error.
      if not available prazo-compra then do:
          /* mensagem: Ordem de compra nío possui parcelas confirmadas */
          run utp/ut-msgs.p (input "show",input 7343,input " ").
          apply 'entry' to i-numero-ordem in frame {&frame-name}.
          return error.
      end.

      assign de-quantidade-total = 0
             de-quantidade-aux   = 0.
      if i-codigo <> ? then do:
        find tt-rat-ordem where
             tt-rat-ordem.int-1 = i-codigo no-error.
        assign de-quantidade-aux = tt-rat-ordem.quantidade.
      end.             
      for each b-tt-rat-ordem 
         where b-tt-rat-ordem.log-2 = yes  no-lock:
           assign de-quantidade-total = de-quantidade-total +  b-tt-rat-ordem.quantidade.
      end.
      if de-quantidade-total -
         de-quantidade-aux   +
         input frame {&frame-name} de-quantidade > de-qtd-item
      then do:
          {utp/ut-liter.i Quantidade_Parcelas * c}
          assign c-quant-total = trim(return-value).
          {utp/ut-field.i mgind item-doc-est quantidade 1}
          run utp/ut-msgs.p (input "show", input 6671, input c-quant-total 
                                                             + "~~" 
                                                             + trim(return-value) 
                                                             + "~~"
                                                             + string(de-qtd-item - de-quantidade-total)).
          return "adm-error".
      end.

      find prazo-compra where
          prazo-compra.numero-ordem = input frame {&frame-name} i-numero-ordem and
          prazo-compra.parcela      = input frame {&frame-name} i-parcela
          no-lock no-error.
      if not available prazo-compra then do:
          /* mensagem: Parcela nío cadastrada */
          {utp/ut-table.i mgind prazo-compra 01}
          run utp/ut-msgs.p (input "show",input 47,input return-value).
          apply 'entry' to i-parcela in frame {&frame-name}.
          return error.
      end.
      if prazo-compra.situacao <> 2 then do:
          /* mensagem: Situaªío da parcela nío permite movimentªío */
          run utp/ut-msgs.p (input "show",input 6897,input " ").
          apply 'entry' to i-parcela in frame {&frame-name}.
          return error.
      end.
      if prazo-compra.data-entrega > docum-est.dt-emissao + param-re.variacao or
          prazo-compra.data-entrega < docum-est.dt-emissao - param-re.variacao
          then do:
          /* mensagem: Data de entrega da parcela esta fora da variaªío. Confirma? */
          run utp/ut-msgs.p (input "show",input 7179,input " ").
          if return-value <> "yes" then do:
              apply 'entry' to i-parcela in frame {&frame-name}.
              return error.
          end.
      end.
  end.
  else do:
      /* mensagem: Deve ser informado Pedido/Ordem de compra */
      {utp/ut-liter.i Pedido/Ordem * L}
      run utp/ut-msgs.p (input "show",input 54,input return-value).
      apply 'entry' to i-num-pedido in frame {&frame-name}.
      return error.
  end.

  if param-re.aceita-var then
      assign de-preco-min = round( de-preco-unit - (de-preco-unit * familia.var-pre-perm / 100), 4)
             de-preco-max = round( de-preco-unit + (de-preco-unit * familia.var-pre-perm / 100), 4).
  else
      assign de-preco-min = de-preco-unit
             de-preco-max = de-preco-unit.

  /*assign de-preuni = (item-doc-est.preco-total[1] - item-doc-est.desconto[1]) / item-doc-est.qt-do-forn
         de-preuni = if de-preuni = ? then 1 else de-preuni.

  if de-preuni < de-preco-min or
      de-preuni > de-preco-max then do: 
      if param-re.aceita-var then do:
          /* mensagem: Preáo da ordem de compra excede variaá∆o permitida. Confirma? */
          run utp/ut-msgs.p (input "show",input 15242,input " ").
          if return-value <> "yes" then do:
              apply 'entry' to de-quantidade in frame {&frame-name}.
              return error.
          end.
      end.
      else do:
          /* mensagem: Preáo da ordem de compra excede variaá∆o permitida.*/
          run utp/ut-msgs.p (input "show",input 15241,input " ").
          apply 'entry' to de-quantidade in frame {&frame-name}.
          return error.
      end.
  end.        */

  if input frame {&frame-name} de-quantidade = 0 then do:
      /* mensagem: Quantidade deve ser diferente de zero */
      {utp/ut-liter.i Quantidade * L}
      run utp/ut-msgs.p (input "show",input 1491,input return-value).
      apply 'entry' to de-quantidade in frame {&frame-name}.
      return error.
  end.        
  if input frame {&frame-name} de-quantidade > 
     input frame {&frame-name} de-quant-saldo then do:
      /* mensagem: Quantidade deve ser diferente de zero */
      {utp/ut-liter.i Quantidade * L}
      run utp/ut-msgs.p (input "show",input 7229,input return-value).
      apply 'entry' to de-quantidade in frame {&frame-name}.
      return error.
  end.

  run pi-variacao-quant(input prazo-compra.quant-saldo,
                        output de-qtd-max).

  if input frame {&frame-name} de-quantidade > de-qtd-max then do:
      if param-re.aceita-var = no then do:                               
          /* mensagem: Quantidade fora da variacao permitida */
          run utp/ut-msgs.p (input "show",input 5928,input " ").
          apply 'entry' to de-quantidade in frame {&frame-name}.
          return error.
      end.
      /* mensagem: Quantidade fora da variacao permitida. Confirma? */
      run utp/ut-msgs.p (input "show",input 5698,input " ").
      if return-value <> "yes" then do:                                
          apply 'entry' to de-quantidade in frame {&frame-name}.
          return error.
      end.
  end.

  if i-codigo = ? then do:
      find prazo-compra where
           prazo-compra.numero-ordem = input frame {&frame-name} i-numero-ordem and
           prazo-compra.parcela      = input frame {&frame-name} i-parcela
           no-lock no-error.
      find last b-tt-rat-ordem use-index codigo no-lock no-error.
      create tt-rat-ordem.
      assign tt-rat-ordem.qtidade-forn = input frame {&frame-name} de-quantidade * de-indice
             tt-rat-ordem.num-pedido   = input frame {&frame-name} i-num-pedido
             tt-rat-ordem.numero-ordem = input frame {&frame-name} i-numero-ordem
             tt-rat-ordem.parcela      = input frame {&frame-name} i-parcela
             tt-rat-ordem.quantidade   = input frame {&frame-name} de-quantidade
             tt-rat-ordem.nro-docto    = docum-est.nro-docto
             tt-rat-ordem.cod-emitente = docum-est.cod-emitente
             tt-rat-ordem.nat-operacao = docum-est.nat-operacao
             tt-rat-ordem.serie-docto  = docum-est.serie-docto
             tt-rat-ordem.sequencia    = i-sequencia
             tt-rat-ordem.encerrada    = l-encerra-pa:checked in frame {&frame-name}
             tt-rat-ordem.int-1        = if avail b-tt-rat-ordem then
                                             b-tt-rat-ordem.int-1 + 1 
                                         else 1
             tt-rat-ordem.log-2        = yes
             tt-rat-ordem.data-2       = prazo-compra.data-entrega
             tt-rat-ordem.char-2       = "?".

  end.
  else do:
      find tt-rat-ordem where
           tt-rat-ordem.int-1 = i-codigo no-error.
      assign tt-rat-ordem.quantidade   = input frame {&frame-name} de-quantidade
             tt-rat-ordem.qtidade-forn = input frame {&frame-name} de-quantidade * de-indice
             tt-rat-ordem.encerrada    = l-encerra-pa:checked in frame {&frame-name}.
  end.
  Return "ok".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-temp-table V-table-Win 
PROCEDURE pi-passa-temp-table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input-output parameter table      for  tt-rat-ordem.
def input parameter i-sequencia-aux   like item-doc-est.sequencia no-undo.
def input parameter de-qt-do-forn-aux like item-doc-est.qt-do-forn no-undo.
def input parameter de-quantidade-aux like item-doc-est.quantidade no-undo.
def input parameter c-it-codigo       like item-doc-est.it-codigo no-undo.
def input parameter i-codigo-aux      like rat-ordem.int-1 no-undo.
/* 
   Se o parÉmetro "i-codigo-aux" vier com "?" ser† uma inclus∆o do item-doc-est.
   Caso contr†rio ser† modificaá∆o.
*/
assign i-sequencia   = i-sequencia-aux
       de-qt-do-forn = de-qt-do-forn-aux
       de-qtd-item   = de-quantidade-aux
       i-codigo      = i-codigo-aux.

assign de-indice = de-qt-do-forn / de-qtd-item
       de-indice = if de-indice = ? or de-indice = 0 then 1 else de-indice.       

find item where
     item.it-codigo = c-it-codigo no-lock no-error.
if available item then        
    find familia where
         familia.fm-codigo = item.fm-codigo
         no-lock no-error.

if i-codigo-aux <> ? then do:                           /*Modificaá∆o*/
    find first tt-rat-ordem where
         tt-rat-ordem.int-1 = i-codigo no-error.
    find first prazo-compra where
         prazo-compra.numero-ordem = tt-rat-ordem.numero-ordem and
         prazo-compra.parcela      = tt-rat-ordem.parcela no-lock no-error.
    assign i-num-pedido:screen-value in frame {&frame-name} = string(tt-rat-ordem.num-pedido)
           i-numero-ordem:screen-value in frame {&frame-name} = string(tt-rat-ordem.numero-ordem)
           i-parcela:screen-value in frame {&frame-name} = string(tt-rat-ordem.parcela)
           de-quant-saldo:screen-value in frame {&frame-name} = string(prazo-compra.quant-saldo)
           de-quantidade:screen-value in frame {&frame-name} = string(tt-rat-ordem.quantidade)
           l-encerra-pa:checked in frame {&frame-name} = tt-rat-ordem.encerrada.
    disable all with frame {&frame-name}.
    enable  de-quantidade with frame {&frame-name}.

end.           
    assign l-encerra-pa:sensitive in frame {&frame-name} = (   natur-oper.tipo = 1 and param-re.encerra-cc
                                                            or natur-oper.tipo = 2 and param-re.reabre-cc).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pedido-ordem V-table-Win 
PROCEDURE pi-pedido-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  if input frame {&frame-name} i-num-pedido <> 0 and
     input frame {&frame-name} i-numero-ordem = 0 then do:
      find first ordem-compra where
           ordem-compra.num-pedido = input frame {&frame-name} i-num-pedido and
           ordem-compra.situacao   = 2 and
           ordem-compra.it-codigo  = item.it-codigo and
           not can-find 
              (first tt-rat-ordem where
                     tt-rat-ordem.num-pedido = input frame {&frame-name} i-num-pedido and
                     tt-rat-ordem.numero-ordem = ordem-compra.numero-ordem)
           no-lock no-error.
       if available ordem-compra then 
           assign i-numero-ordem:screen-value in frame {&frame-name} = string(ordem-compra.numero-ordem).

  end.
  if input frame {&frame-name} i-num-pedido = 0 and
     input frame {&frame-name} i-numero-ordem <> 0 then do:
      find ordem-compra where
           ordem-compra.numero-ordem = input frame {&frame-name} i-numero-ordem
           no-lock no-error.
      if available ordem-compra and
          ordem-compra.num-pedido <> 0 then
          assign i-num-pedido:screen-value in frame {&frame-name} = string(ordem-compra.num-pedido).
  end.
  find ordem-compra where
       ordem-compra.numero-ordem = input frame {&frame-name} i-numero-ordem
       no-lock no-error.
  if available ordem-compra then do:
      find first prazo-compra where
           prazo-compra.numero-ordem = ordem-compra.numero-ordem and
           prazo-compra.situacao     = 2 and
           not can-find (first tt-rat-ordem where
                tt-rat-ordem.num-pedido = input frame {&frame-name} i-num-pedido and
                tt-rat-ordem.numero-ordem = input frame {&frame-name} i-numero-ordem)
           no-lock no-error.
      if available prazo-compra and
          input frame {&frame-name} i-parcela = 0 then 
          assign i-parcela:screen-value in frame {&frame-name} = string(prazo-compra.parcela)
                 de-quant-saldo:screen-value in frame {&frame-name} =
                 string((prazo-compra.quant-saldo - prazo-compra.dec-1)).
      else if not avail prazo-compra then
          assign de-quant-saldo:screen-value in frame {&frame-name} = " ".
  end.

  if available ordem-compra then
      run rep/re1908.p (input rowid(ordem-compra),
                        input docum-est.dt-emissao,
                        output de-preco-unit,
                        output de-desconto,
                        output de-taxa).
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
  {src/adm/template/snd-list.i "rat-ordem"}

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


