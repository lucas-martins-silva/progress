&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V16IN295 2.00.00.018}  /*** 010018 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v16in295 MUT}
&ENDIF

{cdp/cdcfgmat.i}

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
def var c-erro as char no-undo.
def var i-eliminar as integer initial 1.

def buffer b-pedido-compr for pedido-compr.
def var l-modulo-ge as logical no-undo.

def var r-gerencial as rowid.
def var de-qtd-tot as decimal no-undo.
def var de-preco-conv as decimal no-undo.
def var de-val-tot as decimal no-undo.

{cdp/cd0669.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES pedido-compr
&Scoped-define FIRST-EXTERNAL-TABLE pedido-compr


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR pedido-compr.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS pedido-compr.num-pedido ~
pedido-compr.data-pedido pedido-compr.cod-emitente 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}num-pedido ~{&FP2}num-pedido ~{&FP3}~
 ~{&FP1}data-pedido ~{&FP2}data-pedido ~{&FP3}~
 ~{&FP1}cod-emitente ~{&FP2}cod-emitente ~{&FP3}
&Scoped-define ENABLED-TABLES pedido-compr
&Scoped-define FIRST-ENABLED-TABLE pedido-compr
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS pedido-compr.num-pedido ~
pedido-compr.data-pedido pedido-compr.cod-emitente 
&Scoped-Define DISPLAYED-OBJECTS c-nome-fornec c-cgc c-natureza c-situacao 

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
DEFINE VARIABLE c-natureza AS CHARACTER FORMAT "X(20)" INITIAL "1" 
     LABEL "Natureza":R10 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(20)" INITIAL "1" 
     LABEL "Situa‡Æo":R10 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 21.57 BY 1 NO-UNDO.

DEFINE VARIABLE c-cgc AS CHARACTER FORMAT "x(19)" INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 21.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-fornec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     pedido-compr.num-pedido AT ROW 1.25 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     pedido-compr.data-pedido AT ROW 1.25 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     pedido-compr.cod-emitente AT ROW 2.25 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-nome-fornec AT ROW 2.25 COL 27.57 COLON-ALIGNED NO-LABEL
     c-cgc AT ROW 2.25 COL 64 COLON-ALIGNED HELP
          "CGC ou CIC do cliente/fornecedor" NO-LABEL
     c-natureza AT ROW 3.25 COL 17 COLON-ALIGNED HELP
          "Informe a Natureza do Pedido de Compra"
     c-situacao AT ROW 3.25 COL 64 COLON-ALIGNED HELP
          "Informe a Situa‡Æo do Pedido de Compra"
     rt-key AT ROW 1 COL 1
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
         HEIGHT             = 3.54
         WIDTH              = 88.
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

/* SETTINGS FOR FILL-IN c-cgc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX c-natureza IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-fornec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX c-situacao IN FRAME f-main
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

    if pedido-compr.cod-emitente:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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

  if adm-new-record = no
  then
      run ccp/ccapi642.p (5, rowid(pedido-compr), 3).

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  

  if adm-new-record
  then
      run ccp/ccapi642.p (5, rowid(pedido-compr), 1).
  else
      run ccp/ccapi642.p (5, rowid(pedido-compr), 2).

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

  /* Dispatch standard ADM method.                             */

    if pedido-compr.situacao = 1 then do:
        run utp/ut-msgs.p (input "show", 
                           input 1812, 
                           input "").
        return error.                              
    end.            
    if pedido-compr.situacao = 3 then do:
        run utp/ut-msgs.p (input "show", 
                           input 1813, 
                           input "").
        return error.                              
    end.
    if
    &if defined(bf_mat_contratos) &then  
            pedido-compr.nr-contrato <> 0
        &else
            pedido-compr.nr-contrato <> ""
        &endif
      then do:
        run utp/ut-msgs.p (input "show", 
                           input 1806, 
                           input "").
        return error.                              
    end.        
    find first recebimento where 
         recebimento.num-pedido = pedido-compr.num-pedido no-lock no-error.

    if avail recebimento then do:
       run utp/ut-msgs.p (input "show", 
                          input 16294, 
                          input "").
       return error.                   
    end.   

    /* EDI
    if param-global.modulo-ed = yes then do:
        run edp/ed9103.p (input pedido-compr.num-pedido,
                          output l-imp-edi).
        if l-imp-edi then
            {cdp/cd9999.i "Pedido ja transmitido pelo EDI."
                          "Nao pode ser eliminado"}

        run edp/ed9101.p (input ?,
                          input pedido-compr.num-pedido,
                          input ?,
                          input ?,
                          input ?,
                          input ?,
                          input "3").
    end. */

    find b-pedido-compr where
         b-pedido-compr.num-pedido = input frame {&frame-name} pedido-compr.num-pedido
         exclusive-lock no-wait no-error.
    if locked b-pedido-compr then do:
        run utp/ut-msgs.p (input "show", 
                           input 1815, 
                           input "").
        return error.                              
    end.                    

    if param-global.modulo-in then do:
        find first ordem-compra where 
            ordem-compra.num-pedido = input frame {&frame-name} pedido-compr.num-pedido and 
            ordem-compra.num-ord-inv <> 0 
            no-lock  no-error.
        if avail ordem-compra then do:
            run utp/ut-msgs.p (input "show", 
                               input 1816, 
                               input "").
            return error.                          
        end.                    
    end.           

    run ccp/ccapi642.p (5, rowid(pedido-compr), 3).

    for each ordem-compra use-index pedido where
        ordem-compra.num-pedido = input frame {&frame-name} pedido-compr.num-pedido no-lock: /*juliano*/

        /**
        ***   Aprova‡Æo Eletr“nica
        **/
        if param-compra.log-1 then
            run cdp/cdapi171.p (6,3,rowid(ordem-compra)).

        find item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
        if l-modulo-ge = yes then do:
            assign r-gerencial = rowid(ordem-compra).
            run gep/ge0102a.p (input r-gerencial, input 6).
        end.
        assign ordem-compra.num-pedido  = 0
               ordem-compra.situacao    = 3
               ordem-compra.data-pedido = ?
               de-qtd-tot               = 0.
        for each prazo-compra where
            prazo-compra.numero-ordem = ordem-compra.numero-ordem exclusive-lock: /*juliano*/
            assign prazo-compra.situacao = ordem-compra.situacao
                   de-qtd-tot = de-qtd-tot + prazo-compra.qtd-sal-forn.
        end.
        if ordem-compra.mo-codigo > 0 then do:
            run cdp/cd0812.p (input ordem-compra.mo-codigo,input 0,
                              input ordem-compra.pre-unit-for,
                              input input frame {&frame-name} pedido-compr.data-pedido,
                              output de-preco-conv).
            if de-preco-conv = ? then
                assign de-preco-conv = ordem-compra.pre-unit-for.
        end.
        else
            assign de-preco-conv = ordem-compra.pre-unit-for.
        assign de-val-tot = de-qtd-tot * de-preco-conv.
        if l-modulo-ge then do:
            find first estat-cc where estat-cc.dt-compra = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF and 
                estat-cc.cod-estabel = ordem-compra.cod-estabel       and 
                estat-cc.cod-gr-forn = emitente.cod-gr-forn           and 
                estat-cc.fm-codigo   = item.fm-codigo 
                exclusive-lock no-error. /*juliano*/
            if available estat-cc then    
                assign estat-cc.valor[1] = estat-cc.valor[1] - de-val-tot.

            find first estat-cc where 
                estat-cc.dt-compra = input frame {&frame-name} pedido-compr.data-pedido and 
                estat-cc.cod-estabel = ordem-compra.cod-estabel                         and 
                estat-cc.cod-gr-forn = emitente.cod-gr-forn                             and 
                estat-cc.fm-codigo = item.fm-codigo 
                exclusive-lock no-error. /*juliano*/
            if available estat-cc then                        
                assign estat-cc.valor[1] = estat-cc.valor[1] - de-val-tot.
        end.
        /*---Modulo Investimento---*/
        if ordem-compra.num-ord-inv <> 0 then do:
            run inp/in2104.p (input rowid(ordem-compra),
                              input rowid(pedido-compr),
                              input "E",
                              input-output table tt-erro,
                              no).
        end.
    end.
    find first cond-especif where 
        cond-especif.num-pedido = input frame {&frame-name} pedido-compr.num-pedido 
        exclusive-lock no-error. /*juliano*/
    if available cond-especif then
        delete cond-especif.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ).

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    if available pedido-compr then do with frame {&frame-name}:
        assign c-natureza:screen-value = {ininc/i01in295.i 04 pedido-compr.natureza}.
        assign c-situacao:screen-value = {ininc/i02in295.i 04 pedido-compr.situacao}.
    end.
    else do:
        assign c-natureza:screen-value = {ininc/i01in295.i 04 1}.
        assign c-situacao:screen-value = {ininc/i02in295.i 04 2}.
    end.

    {utp/ut-liter.i NÆo_encontrado * R}.
    assign c-erro = return-value.

    find emitente where emitente.cod-emitente = pedido-compr.cod-emitente no-lock no-error.
    if available emitente then do:
        display emitente.nome-abrev @ c-nome-fornec with frame {&frame-name}.
        display emitente.cgc        @ c-cgc         with frame {&frame-name}.
    end.
    else do:
        display c-erro              @ c-nome-fornec with frame {&frame-name}.
        display ?                   @ c-cgc         with frame {&frame-name}.
    end.

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

    do with frame {&frame-name}:
        assign c-natureza:list-items = {ininc/i01in295.i 03}.
        assign c-situacao:list-items = {ininc/i02in295.i 03}.
    end.

  {utp/ut-field.i mgind pedido-compr natureza 1}
  assign c-natureza:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind pedido-compr situacao 1}
  assign c-situacao:label in frame {&FRAME-NAME} = trim(return-value).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    find first param-global no-lock no-error.
    find first param-compra no-lock no-error.
    find param-ge where param-ge.ep-codigo = param-global.empresa-prin no-lock no-error.

    assign c-cgc:format in frame {&frame-name} = param-global.formato-id-federal.
    assign l-modulo-ge = if avail param-ge 
             then if param-ge.tp-atualizacao = 1
                     then (search("gep/ge0102a.p") <> ? or 
                           search("gep/ge0102a.r") <> ?)
                     else no
             else no.

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "pedido-compr"}

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


