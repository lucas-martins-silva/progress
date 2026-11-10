&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V11IN176 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v11in176 MUT}
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

def temp-table tt-saldo-terc like saldo-terc.

def var i-seq as integer no-undo.
def var l-aux as logical no-undo.
def var de-quantidade as decimal no-undo.
def var c-ct-aux as char no-undo.
def var c-sc-aux as char no-undo.
def var i-ordem-aux as integer no-undo.
def var l-itens as logical no-undo.

def var de-desconto as decimal no-undo.
def var de-peso-liquido as decimal no-undo.
def var de-preco-total as decimal no-undo.
def var de-qt-do-forn as decimal no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold c-nr-comp c-nat-comp de-prop 
&Scoped-Define DISPLAYED-OBJECTS c-nr-comp c-nat-comp c-desc-natureza ~
de-prop 

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
DEFINE VARIABLE c-desc-natureza AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nat-comp AS CHARACTER FORMAT "9.99-xxx" 
     LABEL "Nat Opera‡Æo":R15 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88.

DEFINE VARIABLE c-nr-comp AS CHARACTER FORMAT "x(16)" 
     LABEL "Documento":R11 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE de-prop AS DECIMAL FORMAT ">>9,99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 67 BY 6.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-nr-comp AT ROW 2.5 COL 21 COLON-ALIGNED HELP
          "N£mero do Documento"
     c-nat-comp AT ROW 3.5 COL 21 COLON-ALIGNED
     c-desc-natureza AT ROW 3.5 COL 32 COLON-ALIGNED NO-LABEL
     de-prop AT ROW 4.5 COL 21 COLON-ALIGNED
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 6.04
         WIDTH              = 67.
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

/* SETTINGS FOR FILL-IN c-desc-natureza IN FRAME f-main
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

&Scoped-define SELF-NAME c-nat-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-comp V-table-Win
ON F5 OF c-nat-comp IN FRAME f-main /* Nat Opera‡Æo */
DO:

        {include/zoomvar.i &prog-zoom="inzoom/z01in245.w"
                             &campo=c-nat-comp
                           &campozoom=nat-operacao}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-comp V-table-Win
ON LEAVE OF c-nat-comp IN FRAME f-main /* Nat Opera‡Æo */
DO:

        {include/leave.i &tabela=natur-oper
                         &atributo-ref=denominacao
                         &variavel-ref=c-desc-natureza
                         &where="natur-oper.nat-operacao = input frame {&frame-name} c-nat-comp"}
  
    find first saldo-terc where
        saldo-terc.serie-docto = "" and
        saldo-terc.nro-docto = input frame {&frame-name} c-nr-comp and
        saldo-terc.cod-emitente = docum-est.cod-emitente and
        saldo-terc.nat-oper = input frame {&frame-name} c-nat-comp
        no-lock no-error.
        
    if not available saldo-terc then do:
        run utp/ut-msgs.p (input "show", input 3084, input "").
        apply "entry" to c-nr-comp in frame {&frame-name}.
        return no-apply.
    end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-comp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-nat-comp IN FRAME f-main /* Nat Opera‡Æo */
DO:
        apply "F5" to self.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nr-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-comp V-table-Win
ON F5 OF c-nr-comp IN FRAME f-main /* Documento */
DO:
	{include/zoomvar.i &prog-zoom="inzoom/z07in404.w"
                	     &campo=c-nr-comp
	                   &campozoom=nro-docto
	                   &parametros="run pi-seta-inicial in wh-pesquisa (input docum-est.cod-emitente)."}
	                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-comp V-table-Win
ON LEAVE OF c-nr-comp IN FRAME f-main /* Documento */
DO:
  
    find first saldo-terc where
        saldo-terc.serie-docto = "" and
        saldo-terc.nro-docto = input frame {&frame-name} c-nr-comp and
        saldo-terc.cod-emitente = docum-est.cod-emitente
        no-lock no-error.
        
    if not available saldo-terc then do:
        run utp/ut-msgs.p (input "show", input 3084, input "").
        apply "entry" to c-nr-comp in frame {&frame-name}.
        return no-apply.
    end.
    
    display saldo-terc.nat-operacao @ c-nat-comp with frame {&frame-name}.
    disable c-nat-comp with frame {&frame-name}.
    
    find first saldo-terc where
        saldo-terc.serie-docto = "" and
        saldo-terc.nro-docto = input frame {&frame-name} c-nr-comp and
        saldo-terc.cod-emitente = docum-est.cod-emitente and
        saldo-terc.nat-oper <> input frame {&frame-name} c-nat-comp
        no-lock no-error.
        
    if available saldo-terc then
        enable c-nat-comp with frame {&frame-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-comp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-nr-comp IN FRAME f-main /* Documento */
DO:

	apply "F5" to self.
  
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

    if c-nat-comp:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
    if c-nr-comp:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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

    {utp/ut-liter.i Propor‡Æo * R}
    assign de-prop:label in frame {&frame-name} = trim(return-value).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-beneficiamento V-table-Win 
PROCEDURE pi-beneficiamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for each saldo-terc where
        saldo-terc.nro-docto = input frame {&frame-name} c-nr-comp and
        saldo-terc.serie-docto = "" and
        saldo-terc.nat-oper = input frame {&frame-name} c-nat-comp and
        saldo-terc.cod-emitente = docum-est.cod-emitente and
        saldo-terc.quantidade > 0 no-lock:
        
        find saldo-estoq where
            saldo-estoq.cod-estabel = saldo-terc.cod-estabel and
            saldo-estoq.cod-depos = saldo-terc.cod-depos and
            saldo-estoq.cod-localiz = saldo-terc.cod-localiz and
            saldo-estoq.lote = saldo-terc.lote and
            saldo-estoq.cod-refer = saldo-terc.cod-refer and
            saldo-estoq.it-codigo = saldo-terc.it-codigo 
            no-lock no-error.
            
        if saldo-estoq.qtidade-atu < (saldo-terc.quantidade *
            (input frame {&frame-name} de-prop / 100)) then do:
            run utp/ut-msgs.p (input "show", input 7304, input "").
            apply "entry" to de-prop in frame {&frame-name}.
            return no-apply.
        end.
    end.
    
    find last item-doc-est 
        {cep/ce9030.i item-doc-est docum-est}
        no-lock no-error.            
    find natur-oper where
        natur-oper.nat-operacao = docum-est.nat-operacao
        no-lock no-error.
    if available item-doc-est then
        assign i-seq = item-doc-est.sequencia + param-re.inc-seq.
    else
        assign i-seq = param-re.seq-item-um.
    
    assign l-aux = no.
    
    for each saldo-terc where
        saldo-terc.nro-docto = input frame {&frame-name} c-nr-comp and
        saldo-terc.serie-docto = "" and
        saldo-terc.nat-operacao = input frame {&frame-name} c-nat-comp and
        saldo-terc.cod-emitente = docum-est.cod-emitente and
        saldo-terc.quantidade > 0 no-lock:
        
        find componente where
             componente.nro-docto = saldo-terc.nro-docto and
             componente.serie-docto = '' and
             componente.cod-emitente = saldo-terc.cod-emitente and
             componente.nat-operacao = saldo-terc.nat-operacao and
             componente.it-codigo = saldo-terc.it-codigo and
             componente.cod-refer = saldo-terc.cod-refer and
             componente.sequencia = saldo-terc.sequencia no-lock no-error.
        if  not available componente then do:
            run utp/ut-msgs.p (input "show", input 7309, input "").
            return error.
        end.
        
        find item where item.it-codigo = saldo-terc.it-codigo no-lock no-error.

        create item-doc-est.
        assign item-doc-est.quantidade = if param-re.gera-item-ret = 1 then
                                         saldo-terc.quantidade * (de-prop / 100)
                                         else
                                         de-quantidade.
        if truncate(item-doc-est.quantidade,0) <> item-doc-est.quantidade and
            not item.fraciona then
            assign item-doc-est.quantidade = truncate(item-doc-est.quantidade,0) + 1.

        assign item-doc-est.cod-depos = componente.cod-depos
               item-doc-est.cod-emitente = docum-est.cod-emitente
               item-doc-est.cod-refer = saldo-terc.cod-refer
               item-doc-est.ct-codigo = c-ct-aux
               item-doc-est.dt-vali-lote = componente.dt-vali-lote
               item-doc-est.encerra-pa = componente.encerra-pa
               item-doc-est.it-codigo = saldo-terc.it-codigo
               item-doc-est.cod-localiz = componente.cod-localiz
               item-doc-est.lote = componente.lote
               item-doc-est.narrativa = componente.narrativa
               item-doc-est.seq-comp = componente.sequencia
               item-doc-est.nat-comp = componente.nat-operacao
               item-doc-est.nat-operacao = docum-est.nat-operacao
               item-doc-est.nr-ord-prod = i-ordem-aux
               item-doc-est.nro-comp = componente.nro-docto
               item-doc-est.nro-docto = docum-est.nro-docto
               item-doc-est.num-pedido = componente.num-pedido
               item-doc-est.numero-ordem = componente.numero-ordem
               item-doc-est.parcela = componente.parcela
               item-doc-est.reabre-pa = componente.reabre-pa
               item-doc-est.sc-codigo = c-sc-aux
               item-doc-est.sequencia = i-seq
               item-doc-est.serie-comp = ''
               item-doc-est.serie-docto = ''
               item-doc-est.un = componente.un
               de-desconto = item-doc-est.quantidade *
                          (componente.desconto[1] /
                           componente.quantidade)
               item-doc-est.desconto[1] = if de-desconto <> ? then 
                                          de-desconto
                                          else 0
               de-peso-liquido = item-doc-est.quantidade *
                           (componente.peso-liquido /
                            componente.quantidade)
               item-doc-est.peso-liquido = if de-peso-liquido <> ? then
                                           de-peso-liquido 
                                           else 0
               de-preco-total = item-doc-est.quantidade *
                             (componente.preco-total[1] /
                              componente.quantidade)
               item-doc-est.preco-total[1] = if de-preco-total <> ? then
                                             de-preco-total
                                             else 0
               de-qt-do-forn = item-doc-est.quantidade *
                         (componente.qt-do-forn /
                          componente.quantidade)
               item-doc-est.qt-do-forn = if de-qt-do-forn <> ? then
                                         de-qt-do-forn 
                                         else 0
               item-doc-est.baixa-ce = yes
               item-doc-est.flag-atu = if docum-est.nff or
                          (natur-oper.tipo = 1 and
                           natur-oper.terceiros and
                           natur-oper.oper-terc = 1) then 0 else 1
               i-seq = item-doc-est.sequencia + param-re.inc-seq
               l-itens = no
               l-aux = yes.
        
    end.
    if not l-aux then do:
        if natur-oper.oper-terc = 1 then 
            run utp/ut-msgs.p (input "show", input 7305, input "").
        else 
            run utp/ut-msgs.p (input "show", input 7306, input "").
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-chave V-table-Win 
PROCEDURE pi-passa-chave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter r-docum-est as rowid no-undo.
    
    find docum-est where
        rowid(docum-est) = r-docum-est
        no-lock no-error.
        
    find param-re where
        param-re.usuario = c-seg-usuario
        no-lock no-error.        

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
   
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
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


