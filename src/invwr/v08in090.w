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
{include/i-prgvrs.i V08IN090 2.00.00.021 } /*** 010021 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V08IN090 MUT}
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
 
def new global shared var r-estabelec-g  as rowid no-undo.
def new global shared var r-natur-oper-g as rowid no-undo.
def new global shared var r-emitente-g   as rowid no-undo.
def new global shared var r-docum-g      as rowid no-undo.
DEF VAR h-re1701a AS HANDLE NO-UNDO.
 
{include/i-vrtab.i natur-oper}
{include/i-vrtab.i emitente}
{include/i-vrtab.i documento}
{include/i-vrtab.i ordem-compra}
{include/i-vrtab.i pedido-compr}

{cdp/cd4300.i3}  /*Vari˜veis para o cd4300.i4 */
{cdp/cd0101.i50} /*Vari˜veis para o re1001b.i51*/

DEF VAR h-boar2016 AS HANDLE NO-UNDO.
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
&Scoped-define EXTERNAL-TABLES docum-est
&Scoped-define FIRST-EXTERNAL-TABLE docum-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR docum-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS docum-est.nro-docto docum-est.serie-docto ~
docum-est.nat-operacao docum-est.cod-emitente 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nro-docto ~{&FP2}nro-docto ~{&FP3}~
 ~{&FP1}serie-docto ~{&FP2}serie-docto ~{&FP3}~
 ~{&FP1}nat-operacao ~{&FP2}nat-operacao ~{&FP3}~
 ~{&FP1}cod-emitente ~{&FP2}cod-emitente ~{&FP3}
&Scoped-define ENABLED-TABLES docum-est
&Scoped-define FIRST-ENABLED-TABLE docum-est
&Scoped-Define ENABLED-OBJECTS RECT-2 
&Scoped-Define DISPLAYED-FIELDS docum-est.nro-docto docum-est.serie-docto ~
docum-est.nat-operacao docum-est.cod-emitente 
&Scoped-define DISPLAYED-TABLES docum-est
&Scoped-define FIRST-DISPLAYED-TABLE docum-est
&Scoped-Define DISPLAYED-OBJECTS c-despacho FI-natureza FI-emitente

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
DEFINE VARIABLE c-despacho AS CHARACTER FORMAT "X(20)":U 
     LABEL "DP" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE FI-emitente AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .88 NO-UNDO.

DEFINE VARIABLE FI-natureza AS CHARACTER FORMAT "x(35)" 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.63.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     docum-est.nro-docto AT ROW 1.38 COL 17.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     docum-est.serie-docto AT ROW 1.38 COL 42.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
    c-despacho AT ROW 1.38 COL 60 COLON-ALIGNED WIDGET-ID 2
    docum-est.nat-operacao AT ROW 2.38 COL 17.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     FI-natureza AT ROW 2.38 COL 28 COLON-ALIGNED NO-LABEL
     docum-est.cod-emitente AT ROW 3.38 COL 17.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     FI-emitente AT ROW 3.38 COL 30 COLON-ALIGNED HELP
          "Nome Completo do Emitente" NO-LABEL
     RECT-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.docum-est
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 3.67
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-despacho IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-despacho:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN FI-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FI-natureza IN FRAME f-main
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
  {src/adm/template/row-list.i "docum-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "docum-est"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    IF  VALID-HANDLE(h-boar2016) THEN
        RUN destroy IN h-boar2016.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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

  if  avail docum-est then do:
      if gr-documento = ? then assign gr-documento = rowid(docum-est).

      find emitente where emitente.cod-emitente = docum-est.cod-emitente
           no-lock no-error.
      find natur-oper where natur-oper.nat-operacao = docum-est.nat-operacao
           no-lock no-error.
      assign fi-emitente = if avail emitente then emitente.nome-emit else ""
             fi-natureza = if avail natur-oper then natur-oper.denominacao else "".
  end.
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */

  IF  i-pais-impto-usuario = 2 /* Argentina */
    AND CAN-FIND(FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-cod-despacho-plaza":U AND funcao.ativo)
    AND AVAIL docum-est THEN DO:
        IF  NOT VALID-HANDLE(h-boar2016) THEN
            RUN local/arg/boar2016.p PERSISTENT SET h-boar2016.

        RUN retornaDespachoPlaza IN h-boar2016 (INPUT i-ep-codigo-usuario,
                                                INPUT docum-est.serie-docto,
                                                INPUT docum-est.nro-docto,
                                                INPUT docum-est.nat-operacao,
                                                INPUT docum-est.cod-emitente,
                                                OUTPUT c-despacho).
        ASSIGN c-despacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-despacho.
    END.
 
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  
  FIND FIRST param-global NO-LOCK NO-ERROR.
  FIND FIRST param-estoq  NO-LOCK NO-ERROR.
  
  /*Quando tem valor na param-estoq deve ser considerado o que est  nesse campo e nÆo na param-global*/
  IF SUBSTRING(param-estoq.char-2,68,1) <> "":U THEN
      ASSIGN l-ut-ser = (SUBSTRING(param-estoq.char-2,68,1) = "S":U).
  ELSE DO:
      {cdp/cd4300.i4  "yes" param-global.char-2}             
      {cdp/cd0101.i51 "yes"}
  END.

  do with frame {&FRAME-NAME}:
    if not l-ut-ser  /*nÆo utiliza serie*/
    and i-pais-impto-usuario <> 1 /*brasil*/ then 
        assign docum-est.serie-docto:visible  = no. /*esconde a s‚rie*/
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  IF  i-pais-impto-usuario = 2 /* Argentina */
    AND CAN-FIND(FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-cod-despacho-plaza":U AND funcao.ativo) THEN
        ASSIGN c-despacho:HIDDEN IN FRAME {&FRAME-NAME} = NO.
    ELSE 
        ASSIGN c-despacho:HIDDEN IN FRAME {&FRAME-NAME} = YES.


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
 
 if avail docum-est then do:
    assign gr-documento = rowid(docum-est)
           v-row-parent = rowid(docum-est).
    find natur-oper where 
         natur-oper.nat-operacao = docum-est.nat-operacao 
         no-lock no-error.
    if avail natur-oper then
       assign gr-natur-oper = rowid(natur-oper).
    find emitente where 
         emitente.cod-emitente = docum-est.cod-emitente 
         no-lock no-error.
    if avail emitente then 
       assign gr-emitente = rowid(emitente).
 
 end.   

 IF i-pais-impto-usuario = 2 THEN DO: /*roda procedure para habilitar botão (somente para país Argentina)*/
    run pi-bt-prov-desp       in h-re1701a.
 END.  
 
 
  /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle-pai V-table-Win 
PROCEDURE pi-recebe-handle-pai : 
/*------------------------------------------------------------------------------
  Purpose: handle da janela principal para habilitar botões exclusivos para Argentina    
  Parameters:  handle janela pai
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-hpai AS HANDLE    NO-UNDO.

ASSIGN h-re1701a = p-hpai.


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
  {src/adm/template/snd-list.i "docum-est"}

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


