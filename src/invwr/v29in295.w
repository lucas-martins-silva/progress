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
{include/i-prgvrs.i V29IN295 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v29in295 MUT}
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

DEF VAR h-boin082i       AS HANDLE NO-UNDO.

{include/i-vrtab.i transporte}
{include/i-vrtab.i responsavel}
{include/i-vrtab.i moeda}

{cdp/cdcfgmat.i}
{cdp/cd4300.i3}             /* variaveis para desmembrar variaveis livres   */
{ccp/cc9019.i50}            /* desmembrar atributos livres cotacao-item     */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def new global shared var i-moeda-g as integer initial 0 no-undo.
def new global shared var l-conv-g  as logical initial yes no-undo.
def new global shared var da-conv-g as date format "99/99/9999" no-undo.
def var da-date as date no-undo.
def var i-qdt-ordens as integer format ">>>9" no-undo.
def var i-qdt-aberto as integer  format ">>>9" no-undo.

DEF VAR de-quant-prazo  LIKE prazo-compra.quantidade NO-UNDO.
DEF VAR de-preco-unit   LIKE ordem-compra.preco-unit NO-UNDO.
DEF VAR de-pre-unit     LIKE ordem-compra.preco-unit NO-UNDO.
DEF VAR de-pre-unit-for LIKE ordem-compra.preco-unit NO-UNDO.
DEF VAR gr-pedido-compr AS ROWID                     NO-UNDO.

/*def var i-moeda-zoom like i-moeda-g no-undo.*/
def var l-aberto as logical no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES pedido-compr
&Scoped-define FIRST-EXTERNAL-TABLE pedido-compr


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR pedido-compr.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 
&Scoped-Define DISPLAYED-OBJECTS de-aberto de-atraso de-total-merc ~
de-despesas de-impostos de-total 

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
DEFINE VARIABLE de-aberto AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Mercadoria em Aberto" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-atraso AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Mercadoria em Atraso" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-despesas AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Despesas" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-impostos AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Impostos" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-total AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Total" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-total-merc AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Total Mercadoria" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 70.43 BY 6.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-aberto AT ROW 1.25 COL 35 COLON-ALIGNED
     de-atraso AT ROW 2.25 COL 35 COLON-ALIGNED
     de-total-merc AT ROW 3.25 COL 35 COLON-ALIGNED
     de-despesas AT ROW 4.25 COL 35 COLON-ALIGNED
     de-impostos AT ROW 5.25 COL 35 COLON-ALIGNED
     de-total AT ROW 6.25 COL 35 COLON-ALIGNED
     RECT-2 AT ROW 1 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.pedido-compr
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
         HEIGHT             = 6.5
         WIDTH              = 71.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN de-aberto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-atraso IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-despesas IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-impostos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-total IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-total-merc IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

 

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
  {src/adm/template/row-list.i "pedido-compr"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "pedido-compr"}

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
  IF NOT AVAIL param-global THEN
     FIND FIRST param-global NO-LOCK NO-ERROR.

  IF  CONNECTED("mgcex") 
  AND (AVAIL param-global AND param-global.modulo-07) THEN DO:

      IF NOT VALID-HANDLE(h-boin082i) THEN
          RUN inbo/boin082i.p PERSISTENT SET h-boin082i.

      IF gr-pedido-compr <> ? THEN
         FIND FIRST pedido-compr WHERE ROWID(pedido-compr) = gr-pedido-compr NO-LOCK NO-ERROR.
    
      FOR FIRST param-imp  FIELDS (char-1 cdn-despes-impto-ipi   cdn-despes-impto-pis   
                                   cdn-despes-impto-cofins cdn-despes-impto-icms     )
          WHERE param-imp.cod-estabel = pedido-compr.cod-estabel NO-LOCK:
      END.
      IF NOT AVAIL param-imp THEN NEXT.

      ASSIGN de-quant-prazo   = 0
             de-preco-unit    = 0
             de-pre-unit      = 0
             de-pre-unit-for  = 0
             de-aberto        = 0
             de-atraso        = 0
             de-despesas      = 0
             de-total-merc    = 0
             de-total         = 0
             de-impostos      = 0.
    
      FOR EACH ordem-compra use-index pedido 
         WHERE ordem-compra.num-pedido = pedido-compr.num-pedido no-lock:
    
          if valid-handle(h-boin082i) THEN
             RUN piRetiraIpi IN h-boin082i (INPUT ordem-compra.numero-ordem,
                                            INPUT 2,
                                            OUTPUT de-pre-unit,
                                            OUTPUT de-pre-unit-for).

          FOR FIRST cotacao-item WHERE cotacao-item.numero-ordem  = ordem-compra.numero-ordem
                                    AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                                    AND cotacao-item.it-codigo    = ordem-compra.it-codigo
                                    AND cotacao-item.cot-aprovada = YES NO-LOCK:
          END.
    
          IF AVAIL cotacao-item THEN DO:
    
              {ccp/cc9019.i50}               
              {cdp/cd4300.i4 "yes" cotacao-item.char-1}
              {ccp/cc9019.i51 "yes"}
              
              if l-conv-g then 
                 assign da-date = cotacao-item.data-cotacao.
              else 
                 assign da-date = da-conv-g. 
        
              run cdp/cd0812.p (input  ordem-compra.mo-codigo,
                                input  i-moeda-g,
                                input  de-pre-unit,
                                input  da-date,
                                output de-preco-unit).
        
              if de-preco-unit = ? then de-preco-unit = 0.
        
              ASSIGN de-quant-prazo   = 0.
        
              FOR each prazo-compra use-index ordem
                 WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock:
                  IF prazo-compra.situacao = 4 THEN NEXT.
        
                  ASSIGN de-quant-prazo = de-quant-prazo + prazo-compra.quantidade.
        
                  IF prazo-compra.quant-saldo  > 0 AND
                     prazo-compra.situacao    <> 4 and
                     prazo-compra.situacao    <> 6 THEN
                     ASSIGN de-aberto = de-aberto + (prazo-compra.quant-saldo * de-preco-unit).
                     /* Valor Mercadoria em Aberto */
        
                  if prazo-compra.data-entrega < TODAY AND prazo-compra.situacao = 2 THEN 
                     ASSIGN de-atraso = de-atraso + prazo-compra.quant-saldo  /* Valor Mercadoria em Atraso */
                                      * de-preco-unit.
              END.
    
             FOR EACH cotacao-item-cex WHERE cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
                                         AND cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente
                                         AND cotacao-item-cex.it-codigo    = cotacao-item.it-codigo
                                         AND cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
                                         AND cotacao-item-cex.mapa-cotacao = i-mapa-cotacao-i50 NO-LOCK:
                 
                 FOR FIRST desp-imp FIELDS(inc-val-embal inc-val-seguro inc-val-frete inc-val-outras-desp cod-desp)
                     WHERE desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK:
                 END.
    
                 IF AVAIL desp-imp 
                 AND (desp-imp.inc-val-embal       = YES 
                      OR   desp-imp.inc-val-seguro = YES
                      OR   desp-imp.inc-val-frete  = YES
                      OR   desp-imp.inc-val-outras-desp = YES)
                 THEN DO:
    
                     IF l-conv-g then 
                        assign da-date = cotacao-item.data-cotacao.
                     else 
                        assign da-date = da-conv-g. 
    
                     run cdp/cd0812.p (input  cotacao-item-cex.mo-codigo,
                                       input  i-moeda-g,
                                       input  cotacao-item-cex.val-desp,
                                       input  da-date,
                                       output de-preco-unit).
    
                     IF AVAIL param-imp AND (int(substr(param-imp.char-1,21,20)) = desp-imp.cod-desp
                                         OR  param-imp.cdn-despes-impto-ipi      = desp-imp.cod-desp
                                         OR  param-imp.cdn-despes-impto-pis      = desp-imp.cod-desp
                                         OR  param-imp.cdn-despes-impto-cofins   = desp-imp.cod-desp
                                         OR  param-imp.cdn-despes-impto-icms     = desp-imp.cod-desp) THEN
                        ASSIGN de-impostos = de-impostos + (de-preco-unit * de-quant-prazo).
                     ELSE
                        ASSIGN de-despesas = de-despesas + (de-preco-unit * de-quant-prazo).
                 END.
             END.
          END.
    
          if valid-handle(h-boin082i) then
             RUN piRetiraIpi IN h-boin082i (INPUT ordem-compra.numero-ordem,
                                            INPUT 1,
                                            OUTPUT de-pre-unit,
                                            OUTPUT de-pre-unit-for).
          if l-conv-g then 
             assign da-date = cotacao-item.data-cotacao.
          else 
             assign da-date = da-conv-g. 
    
          run cdp/cd0812.p (input  ordem-compra.mo-codigo,
                            input  i-moeda-g,
                            input  de-pre-unit,
                            input  da-date,
                            output de-preco-unit).
    
          ASSIGN de-total-merc = de-total-merc + de-preco-unit.  /* Valor Total da Mercadoria */
      end.
    
      ASSIGN de-total = de-total-merc + de-despesas + de-impostos.  /* Valor Total */
  END.

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

  {utp/ut-liter.i Valor_Mercadoria_em_Aberto}
  assign de-aberto:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Valor_Mercadoria_em_Atraso}
  assign de-atraso:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Valor_Total}
  assign de-total:label in frame {&FRAME-NAME} = trim(return-value).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


  /* Code placed here will execute AFTER standard behavior.    */

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE elimina-boin082i B-table-Win 
PROCEDURE elimina-boin082i :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if valid-handle(h-boin082i) then do:
     delete procedure h-boin082i no-error.
     assign h-boin082i = ?.
  end.

  RETURN "OK":U.

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a valida‡Æo de chave duplicada */

  /* Ponha aqui as demais valida‡äes */

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "pedido-compr"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-pedido V-table-Win  
PROCEDURE pi-altera-pedido :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER r-rowid AS ROWID NO-UNDO.

  ASSIGN gr-pedido-compr = r-rowid.
  
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
