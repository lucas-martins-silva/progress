&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V10IN176 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v10in176 MUT}
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
def buffer b-doc for docum-est.
def buffer b-item for item-doc-est.

def var r-registro as rowid no-undo.
def var l-origem as logical no-undo.

def var l-entrada   as logical no-undo.
def var l-transf    as logical no-undo. 
def var l-modulo-ge as logical no-undo.
def var l-remessa   as logical no-undo.
def var l-retorno   as logical no-undo.
def var l-ent-cons  as logical no-undo.
def var l-sai-cons  as logical no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold c-estab-de-or c-natureza 
&Scoped-Define DISPLAYED-OBJECTS c-estab-de-or c-desc-estabel c-natureza ~
c-desc-natureza 

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
DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-natureza AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab-de-or LIKE estabelec.cod-estabel
     LABEL "Estab Orig/Dest":R15 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-natureza AS CHARACTER FORMAT "9.99-XXX" 
     LABEL "Nat Opera‡Æo":R15 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73 BY 4.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-estab-de-or AT ROW 2.25 COL 22 COLON-ALIGNED
          LABEL "Estab Orig/Dest":R15
     c-desc-estabel AT ROW 2.25 COL 30 COLON-ALIGNED NO-LABEL
     c-natureza AT ROW 3.25 COL 22 COLON-ALIGNED
     c-desc-natureza AT ROW 3.25 COL 32.29 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 4.5
         WIDTH              = 73.29.
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

/* SETTINGS FOR FILL-IN c-desc-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-natureza IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estab-de-or IN FRAME f-main
   LIKE = mgcad.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
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

&Scoped-define SELF-NAME c-estab-de-or
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-de-or V-table-Win
ON F5 OF c-estab-de-or IN FRAME f-main /* Estab Orig/Dest */
DO:

        {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                             &campo=c-estab-de-or
                           &campozoom=cod-estabel}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-de-or V-table-Win
ON LEAVE OF c-estab-de-or IN FRAME f-main /* Estab Orig/Dest */
DO:
  
        {include/leave.i &tabela=estabelec
                           &atributo-ref=nome
                           &variavel-ref=c-desc-estabel
                           &where="estabelec.cod-estabel = input frame {&frame-name} c-estab-de-or"}
  
    disable c-natureza with frame {&frame-name}.
  
    assign docum-est.estab-de-or = input frame {&frame-name} c-estab-de-or.
    
    if docum-est.estab-de-or = docum-est.cod-estabel then do:
        run utp/ut-msgs.p (input "show", input 7298, input "").
        apply "entry" to c-estab-de-or in frame {&frame-name}.
        return no-apply.
    end.
    
    find first b-doc use-index documento where
        b-doc.serie-docto = '' and
        b-doc.nro-docto = docum-est.nro-docto and
        b-doc.cod-emitente = docum-est.cod-emitente and
        b-doc.nat-operacao <> docum-est.nat-operacao and
        b-doc.ce-atual and
        b-doc.cod-estabel = docum-est.estab-de-or and
        b-doc.esp-docto = 23 and
        b-doc.tipo-docto = 2
        no-lock no-error.
    if avail b-doc then do:
    
        display b-doc.nat-operacao @ c-natureza with frame {&frame-name}.
        r-registro = rowid(b-doc).
        find next b-doc where
            b-doc.serie-docto = '' and
            b-doc.nro-docto = docum-est.nro-docto and
            b-doc.cod-emitente = docum-est.cod-emitente and
            b-doc.nat-operacao <> docum-est.nat-operacao and
            b-doc.ce-atual and
            b-doc.cod-estabel = docum-est.estab-de-or and
            b-doc.esp-docto = 23 and
            b-doc.tipo-docto = 2
            no-lock no-error.
            
        if avail b-doc then do:
            enable c-natureza with frame {&frame-name}.
            apply "entry" to c-natureza in frame {&frame-name}.
            return no-apply.
        end.
        
    end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-de-or V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-estab-de-or IN FRAME f-main /* Estab Orig/Dest */
DO:
        apply "F5" to self.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-natureza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-natureza V-table-Win
ON F5 OF c-natureza IN FRAME f-main /* Nat Opera‡Æo */
DO:

        {include/zoomvar.i &prog-zoom="inzoom/z01in245.w"
                             &campo=c-natureza
                           &campozoom=nat-operacao}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-natureza V-table-Win
ON LEAVE OF c-natureza IN FRAME f-main /* Nat Opera‡Æo */
DO:

        {include/leave.i &tabela=natur-oper
                         &atributo-ref=denominacao
                         &variavel-ref=c-desc-natureza
                         &where="natur-oper.nat-operacao = input frame {&frame-name} c-natureza"}

    find b-doc use-index documento where
        b-doc.serie-docto = '' and
        b-doc.nro-docto = docum-est.nro-docto and
        b-doc.cod-emitente = docum-est.cod-emitente and
        b-doc.nat-operacao = input frame {&frame-name} c-natureza and
        b-doc.ce-atual and
        b-doc.cod-estabel = docum-est.estab-de-or and
        b-doc.esp-docto = 23 and
        b-doc.tipo-docto = 2 
        no-lock no-error.
    if not avail b-doc then do:
        run utp/ut-msgs.p (input "show", input 7299, input "").
        apply "entry" to c-natureza in frame {&frame-name}.
        return no-apply.
    end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-natureza V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-natureza IN FRAME f-main /* Nat Opera‡Æo */
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

    if c-estab-de-or:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.      
    if c-natureza:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-chave V-table-Win 
PROCEDURE pi-passa-chave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter r-docum-est as rowid no-undo.

    find first param-global no-lock no-error.
    find first param-estoq  no-lock no-error.

    find docum-est where
         rowid(docum-est) = r-docum-est 
         NO-LOCK no-error.

    find natur-oper where 
        natur-oper.nat-operacao = docum-est.nat-operacao 
        no-lock no-error.
    if available natur-oper then do:
        assign l-entrada   = if natur-oper.tipo = 1 then yes else no
               l-transf    = natur-oper.transf
               l-modulo-ge = param-global.modulo-ge
               l-remessa   = if  natur-oper.tipo = 2
                             and natur-oper.terceiros
                             and natur-oper.transf = no
                             and natur-oper.oper-terc = 2 then yes
                             else no
               l-retorno   = if  natur-oper.tipo = 1
                             and natur-oper.terceiros
                             and natur-oper.transf = no
                             and natur-oper.oper-terc = 2 then yes
                             else no
               l-ent-cons  = if  natur-oper.tipo = 1
                             and natur-oper.terceiros
                             and natur-oper.oper-terc = 1 then yes
                             else no
               l-sai-cons  = if  natur-oper.tipo = 2
                             and natur-oper.terceiros
                             and natur-oper.oper-terc = 1 then yes
                             else no.
    end.                                     
        
    display docum-est.estab-de-or @ c-estab-de-or with frame {&frame-name}.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-transferencia V-table-Win 
PROCEDURE pi-transferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find first b-doc use-index documento where
        b-doc.serie-docto = '' and
        b-doc.nro-docto = docum-est.nro-docto and
        b-doc.cod-emitente = docum-est.cod-emitente and
        b-doc.nat-operacao <> docum-est.nat-operacao and
        b-doc.ce-atual and
        b-doc.cod-estabel = docum-est.estab-de-or and
        b-doc.esp-docto = 23 and
        b-doc.tipo-docto = 2 
        no-lock no-error.
    if avail b-doc then do:
        r-registro = rowid(b-doc).
        find next b-doc where
              b-doc.serie-docto = '' and
              b-doc.nro-docto = docum-est.nro-docto and
              b-doc.cod-emitente = docum-est.cod-emitente and
              b-doc.nat-operacao <> docum-est.nat-operacao and
              b-doc.ce-atual and
              b-doc.cod-estabel = docum-est.estab-de-or and
              b-doc.esp-docto = 23 and
              b-doc.tipo-docto = 2
              no-lock no-error.
        if not avail b-doc then 
            find b-doc where rowid(b-doc) = r-registro no-lock no-error.
        l-origem = yes.
    end.
    else do:
        run utp/ut-msgs.p (input "show", input 7300, input "").
        apply "entry" to c-estab-de-or in frame {&frame-name}.
        return no-apply.
    end.        
    if l-origem then do:
        find natur-oper where natur-oper.nat-operacao = docum-est.nat-operacao
             no-lock no-error.
        assign docum-est.ct-transit = b-doc.ct-transit
               docum-est.despesa-nota = b-doc.despesa-nota
               docum-est.dt-emissao = b-doc.dt-emissao
               docum-est.dt-trans = today
               docum-est.embalagem = b-doc.embalagem
               docum-est.esp-docto = b-doc.esp-docto
               docum-est.sc-transit = b-doc.sc-transit
               docum-est.tipo-docto = natur-oper.tipo
               docum-est.tot-peso = b-doc.tot-peso
               docum-est.tot-valor = b-doc.tot-valor
               docum-est.uf = b-doc.uf
               docum-est.valor-embal = b-doc.valor-embal
               docum-est.valor-frete = b-doc.valor-frete
               docum-est.valor-mercad = b-doc.valor-mercad
               docum-est.valor-outras = b-doc.valor-outras
               docum-est.valor-seguro = b-doc.valor-seguro
               docum-est.via-transp = b-doc.via-transp.

        for each b-item {cep/ce9030.i b-item b-doc} no-lock with frame f-item:
            find item where item.it-codigo = b-item.it-codigo no-lock no-error.
            create item-doc-est.
            assign item-doc-est.atualiza-pa = no
                   item-doc-est.perc-vat = b-item.perc-vat
                   item-doc-est.perc-sales-tax = b-item.perc-sales-tax
                   item-doc-est.cod-depos = item.deposito-pad
                   item-doc-est.cod-emitente = docum-est.cod-emitente
                   item-doc-est.ct-codigo = ""
                   item-doc-est.despesas[1] = b-item.despesas[1]
                   item-doc-est.encerra-pa = no
                   item-doc-est.it-codigo = b-item.it-codigo
                   item-doc-est.cod-localiz = b-item.cod-localiz
                   item-doc-est.lote = b-item.lote
                   item-doc-est.narrativa = b-item.narrativa
                   item-doc-est.nat-comp = b-item.nat-operacao
                   item-doc-est.nro-comp = b-item.nro-docto
                   item-doc-est.cod-refer = b-item.cod-refer
                   item-doc-est.nat-operacao = docum-est.nat-operacao
                   item-doc-est.nr-ord-prod = 0
                   item-doc-est.nro-docto = docum-est.nro-docto
                   item-doc-est.peso-liquido = b-item.peso-liquido
                   item-doc-est.preco-total[1] = b-item.preco-total[1]
                   item-doc-est.qt-do-forn = b-item.qt-do-forn
                   item-doc-est.quantidade = b-item.quantidade
                   item-doc-est.reabre-pa = no
                   item-doc-est.reabre-pd = no
                   item-doc-est.sc-codigo = ""
                   item-doc-est.sequencia = b-item.sequencia
                   item-doc-est.serie-docto = ''
                   item-doc-est.flag-atu = if docum-est.nff or
                          l-ent-cons then 0 else 1
                   item-doc-est.un = b-item.un.
        end.
    end.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this Window, and there are no
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

