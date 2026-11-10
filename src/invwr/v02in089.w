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
{include/i-prgvrs.i V02IN089 2.00.00.008} /*** "010008" 13/11/2023 08:33:50  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02in089 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

{cdp/cdcfgdis.i}

DEF VAR c-cod-estabel-usuar LIKE estabelec.cod-estabel.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES doc-fisico
&Scoped-define FIRST-EXTERNAL-TABLE doc-fisico


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR doc-fisico.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS doc-fisico.cod-estabel doc-fisico.dt-emissao ~
doc-fisico.dt-trans 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-estabel ~{&FP2}cod-estabel ~{&FP3}~
 ~{&FP1}dt-emissao ~{&FP2}dt-emissao ~{&FP3}~
 ~{&FP1}dt-trans ~{&FP2}dt-trans ~{&FP3}
&Scoped-define ENABLED-TABLES doc-fisico
&Scoped-define FIRST-ENABLED-TABLE doc-fisico
&Scoped-Define ENABLED-OBJECTS rt-key RECT-2 RECT-1 
&Scoped-Define DISPLAYED-FIELDS doc-fisico.cod-emitente ~
doc-fisico.serie-docto doc-fisico.nro-docto doc-fisico.tipo-nota ~
doc-fisico.cod-estabel doc-fisico.dt-emissao doc-fisico.dt-trans 
&Scoped-Define DISPLAYED-OBJECTS fi-emitente fi-estabel c-tipo-nota 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS doc-fisico.cod-emitente ~
doc-fisico.serie-docto doc-fisico.nro-docto doc-fisico.tipo-nota 
&Scoped-define ADM-ASSIGN-FIELDS doc-fisico.cod-emitente ~
doc-fisico.serie-docto doc-fisico.nro-docto doc-fisico.tipo-nota ~
doc-fisico.cod-estabel doc-fisico.dt-emissao doc-fisico.dt-trans 

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
DEFINE VARIABLE c-tipo-nota AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.29 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.29 BY 3.58.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.29 BY 1.58.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.29 BY 3.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     doc-fisico.cod-emitente AT ROW 1.33 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fi-emitente AT ROW 1.33 COL 37 COLON-ALIGNED NO-LABEL
     doc-fisico.serie-docto AT ROW 2.33 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     doc-fisico.nro-docto AT ROW 3.33 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     doc-fisico.tipo-nota AT ROW 5.46 COL 5.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Compra", 1,
"Beneficiamento", 2,
"Devolu‡Æo", 3,
"Consigna‡Æo", 4
          SIZE 81 BY .83
     doc-fisico.cod-estabel AT ROW 7.33 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     fi-estabel AT ROW 7.33 COL 32 COLON-ALIGNED NO-LABEL
     doc-fisico.dt-emissao AT ROW 8.33 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     doc-fisico.dt-trans AT ROW 9.33 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-tipo-nota AT ROW 4.71 COL 34 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     RECT-2 AT ROW 5 COL 1
     RECT-1 AT ROW 7 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.doc-fisico
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
         HEIGHT             = 9.96
         WIDTH              = 88.72.
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

/* SETTINGS FOR FILL-IN c-tipo-nota IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN doc-fisico.cod-emitente IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN doc-fisico.cod-estabel IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN doc-fisico.dt-emissao IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN doc-fisico.dt-trans IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN fi-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN doc-fisico.nro-docto IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN doc-fisico.serie-docto IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR RADIO-SET doc-fisico.tipo-nota IN FRAME f-main
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

  {utp/ut-field.i mgind doc-fisico tipo-nota 1}
  assign c-tipo-nota:screen-value in frame {&frame-name} = return-value.
    
  if doc-fisico.cod-emitente:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then .      
  if doc-fisico.cod-estabel:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then .

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
  {src/adm/template/row-list.i "doc-fisico"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "doc-fisico"}

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
  find first param-estoq no-lock no-error.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  ASSIGN c-cod-estabel-usuar = param-estoq.estabel-pad.

  /* Funcao Super/Minas */
  &IF DEFINED(Bf_dis_usuario_estab) &THEN
      IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                           AND funcao.ativo     = YES) THEN DO:
         RUN cdp/cd8702.p (INPUT c-seg-usuario,
                                INPUT-OUTPUT c-cod-estabel-usuar).
      END.
   &ENDIF
  /* Code placed here will execute AFTER standard behavior.    */
  display c-cod-estabel-usuar     @ doc-fisico.cod-estabel
          today                   @ doc-fisico.dt-emissao
          today                   @ doc-fisico.dt-trans
          with frame {&frame-name}.
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    def var c-data as character no-undo.
    
    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    find first param-estoq no-lock no-error.
    find param-re where param-re.usuario = c-seg-usuario no-lock no-error.
    
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    if  doc-fisico.cod-emitente:sensitive in frame {&frame-name} 
    and can-find(first doc-fisico 
           where doc-fisico.cod-emitente = input frame {&FRAME-NAME} doc-fisico.cod-emitente 
             and doc-fisico.serie-docto  = input frame {&FRAME-NAME} doc-fisico.serie-docto  
             and doc-fisico.nro-docto    = input frame {&FRAME-NAME} doc-fisico.nro-docto)
    then do:
        {utp/ut-table.i mgind doc-fisico 1}
        run utp/ut-msgs.p (input "show":U, input 7, input return-value).
        apply "entry" to doc-fisico.cod-emitente in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
       
    find emitente where 
         emitente.cod-emitente = input frame {&frame-name} doc-fisico.cod-emitente
         no-lock no-error.
    if  not available emitente then do:
        {utp/ut-table.i mgadm emitente 1}
        run utp/ut-msgs.p (input "show", input 47, input return-value).
        apply "entry" to doc-fisico.cod-emitente in frame {&frame-name}.
        return "adm-error".
    end.
    else do:
        if  emitente.identific = 2 
        and input frame {&frame-name} doc-fisico.tipo-nota = 3 then do:
            {utp/ut-table.i mgadm emitente 1}
            run utp/ut-msgs.p (input "show", input 158, input return-value).
            apply "entry" to doc-fisico.cod-emitente in frame {&frame-name}.
            return "ADM-ERROR":U.
        end.
    end.        
    
    find estabelec where 
         estabelec.cod-estabel = input frame {&frame-name} doc-fisico.cod-estabel
         no-lock no-error.
    if  not available estabelec then do:
        {utp/ut-table.i mgadm estabelec 1}
        run utp/ut-msgs.p (input "show", input 47, input return-value).
        apply "entry" to doc-fisico.cod-estabel in frame {&frame-name}.
        return "ADM-ERROR":U.
    end.
    if  input frame {&frame-name} doc-fisico.dt-trans < (today - param-re.var-atual)
    or  input frame {&frame-name} doc-fisico.dt-trans > today 
    or  input frame {&frame-name} doc-fisico.dt-trans < param-estoq.mensal-ate then do:
        {utp/ut-field.i mgind doc-fisico dt-trans 1}
        run utp/ut-msgs.p (input "show", input 8824, input return-value).
        apply "entry" to doc-fisico.dt-trans in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    if  input frame {&frame-name} doc-fisico.dt-trans < input frame {&frame-name} doc-fisico.dt-emissao 
    then do:
        {utp/ut-field.i mgind doc-fisico dt-emissao 1}
        assign c-data = return-value.    
        {utp/ut-field.i mgind doc-fisico dt-trans 1}
        run utp/ut-msgs.p (input "show", input 8826, input return-value + "~~" + c-data).
        apply "entry" to doc-fisico.dt-trans in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.    
    if  input frame {&frame-name} doc-fisico.dt-emissao < (today - param-re.var-emis)
    or  input frame {&frame-name} doc-fisico.dt-emissao > today then do:
        {utp/ut-field.i mgind doc-fisico dt-emissao 1}
        run utp/ut-msgs.p (input "show", input 8824, input return-value).
        apply "entry" to doc-fisico.dt-emissao in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if  RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
    assign doc-fisico.situacao = 1.
    
    /* Cria documento paralelo para o recebimento fiscal */
    if  doc-fisico.cod-emitente:sensitive in frame {&frame-name} then do:
        create docum-est.
        assign docum-est.cod-emitente = doc-fisico.cod-emitente 
               docum-est.nro-docto    = doc-fisico.nro-docto
               docum-est.serie-docto  = doc-fisico.serie-docto
               docum-est.nat-operacao = "".  
    end.
    else
        find docum-est where
             docum-est.cod-emitente = doc-fisico.cod-emitente and
             docum-est.nro-docto    = doc-fisico.nro-docto    and
             docum-est.serie-docto  = doc-fisico.serie-docto  and
             docum-est.nat-operacao = "" no-lock no-error.
    
    assign docum-est.dt-emissao  = doc-fisico.dt-emissao
           docum-est.dt-trans    = doc-fisico.dt-trans
           docum-est.rec-fisico  = yes
           docum-est.cod-estabel = doc-fisico.cod-estabel
           docum-est.estab-fisc  = doc-fisico.cod-estabel.
    
    /* Atributos a serem gravados por algum problema posterior no re1001 - Fiscal
       esp-docto, conta-contabil, ct-transit, sc-transit,
       tipo-docto, cod-observa, uf, aliquota-icm, aliquota-ipi, aliquota-iss */
    
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
  if  avail doc-fisico then do:
      find emitente where emitente.cod-emitente = doc-fisico.cod-emitente
           no-lock no-error.
      find estabelec where estabelec.cod-estabel = doc-fisico.cod-estabel 
           no-lock no-error.    
      assign fi-emitente = if avail emitente then emitente.nome-emit else ""
             fi-estabel  = if avail estabelec then estabelec.nome else "".
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
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    if adm-new-record = yes then
    &if  defined(ADM-MODIFY-FIELDS) &then
    enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

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
    
/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "doc-fisico"}

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


