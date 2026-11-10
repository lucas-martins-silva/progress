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
{include/i-prgvrs.i V15IN172 2.00.00.014}  /*** "010014" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V15IN172 MUT}
&ENDIF


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

/*** Vari veis para integra‡Æo EMS x SISDOC ***/
def var i-integracao-sisdoc as integer init ?  no-undo.
def var c-handle            as char            no-undo.
def var c-opcao-int         as char            no-undo.
def var l-passou            as logical init no no-undo.
def var i-retorno-erro      as integer init ?  no-undo.
    /* ** 5 => Quando parƒmetro "nao-integra" e o registro j  est  integrado **
       ** 6 => Erro de integra‡Æo no SISDOC                                  **
       ** 7 => Erro de integra‡Æo no EMS                                     ** */
/********* Fim vari veis para integra‡Æo ******/       

def new global shared var gr-item as rowid no-undo.

def var de-lote-multiplo as decimal no-undo.

/******* Multi-Planta ********/
def var i-tipo-movto as integer no-undo.
def var l-cria as logical no-undo.

{cdp/cd7300.i1}
/************* Fim ***********/

    /**  Melhorias
    **/
    {cdp/cdcfgmat.i}
    def var c-lista-prioridade   as char no-undo.

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.periodo-fixo item.lote-multipl ~
item.res-for-comp item.tempo-segur item.res-int-comp item.res-cq-comp ~
item.quant-segur item.quant-perda item.lote-economi 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS item.periodo-fixo item.lote-multipl ~
item.res-for-comp item.tempo-segur item.res-int-comp item.res-cq-comp ~
item.quant-segur item.quant-perda item.lote-economi 
&Scoped-Define DISPLAYED-OBJECTS fi-demanda fi-emissao-ord fi-politica ~
fi-tipo-lote-ec de-var-aprov cb-prioridade c-ean-code 

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
DEFINE VARIABLE cb-prioridade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Prior. Aprov." 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 13.72 BY 1 NO-UNDO.

DEFINE VARIABLE c-ean-code AS CHARACTER FORMAT "X(16)":U 
     LABEL "C¢digo EAN" 
     VIEW-AS FILL-IN 
     SIZE 22.14 BY .88 NO-UNDO.

DEFINE VARIABLE de-var-aprov AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Varia‡Æo Perm." 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-demanda AS CHARACTER FORMAT "X(12)" 
     LABEL "Fill 2":R18 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-emissao-ord AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fill 4" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-politica AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fill 5" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tipo-lote-ec AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fill 3" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.14 BY 9.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.periodo-fixo AT ROW 1.88 COL 62.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     item.lote-multipl AT ROW 2.38 COL 20.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fi-demanda AT ROW 2.88 COL 62.43 COLON-ALIGNED HELP
          "Tipo de Demanda do Item"
     item.res-for-comp AT ROW 3.38 COL 20.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     item.tempo-segur AT ROW 3.88 COL 62.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     item.res-int-comp AT ROW 4.38 COL 20.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     fi-emissao-ord AT ROW 4.88 COL 62.43 COLON-ALIGNED
     item.res-cq-comp AT ROW 5.38 COL 20.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     fi-politica AT ROW 5.88 COL 62.43 COLON-ALIGNED
     item.quant-segur AT ROW 6.38 COL 20.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fi-tipo-lote-ec AT ROW 6.88 COL 62.43 COLON-ALIGNED
     item.quant-perda AT ROW 7.38 COL 20.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     de-var-aprov AT ROW 7.88 COL 62.43 COLON-ALIGNED
     item.lote-economi AT ROW 8.38 COL 20.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     cb-prioridade AT ROW 8.88 COL 62.43 COLON-ALIGNED
     c-ean-code AT ROW 9.5 COL 20 COLON-ALIGNED
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
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
         HEIGHT             = 9.79
         WIDTH              = 85.43.
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

/* SETTINGS FOR FILL-IN c-ean-code IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-prioridade IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-prioridade:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN de-var-aprov IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       de-var-aprov:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-demanda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-emissao-ord IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-politica IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tipo-lote-ec IN FRAME f-main
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

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

  Do  with frame {&frame-name}:
      {utp/ut-field.i mgind item demanda 1}
      assign fi-demanda:label = return-value.
      {utp/ut-field.i mgind item tipo-lote-ec 1}
      assign fi-tipo-lote-ec:label = return-value.      
      {utp/ut-field.i mgind item emissao-ord 1}
      assign fi-emissao-ord:label = return-value.
      {utp/ut-field.i mgind item politica 1}
      assign fi-politica:label = return-value.
  end.
  
  /**  Melhorias
  **/
  &if defined(bf_mat_aprova_eletronica) &then
      {utp/ut-liter.i Varia‡Æo_Perm. * r}
      assign de-var-aprov:label in frame {&frame-name} = trim(return-value).
      {utp/ut-liter.i Prior._Aprov. * r}
      assign cb-prioridade:label in frame {&frame-name} = trim(return-value).
      {utp/ut-liter.i Muito_Alta * r}
      assign c-lista-prioridade = trim(return-value).
      {utp/ut-liter.i Alta * r}
      assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).    
      {utp/ut-liter.i M‚dia * r}
      assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).    
      {utp/ut-liter.i Baixa * r}
      assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).    
      assign cb-prioridade:list-items in frame {&frame-name} = c-lista-prioridade.
  &endif

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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        assign cb-prioridade = entry(4,c-lista-prioridade).
        display cb-prioridade with frame {&frame-name}.
    &endif

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

    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        assign input frame {&frame-name} cb-prioridade
               input frame {&frame-name} de-var-aprov.
    &endif
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        find item-mat where
            item-mat.it-codigo = item.it-codigo
            exclusive-lock no-error.
        if available item-mat then do:
            assign item-mat.variacao-perm = de-var-aprov.
            case lookup(cb-prioridade,replace(c-lista-prioridade," ,",",")):
                when 1 then assign item-mat.prioridade-aprov = 999.
                when 2 then assign item-mat.prioridade-aprov = 750.
                when 3 then assign item-mat.prioridade-aprov = 450.
                when 4 then assign item-mat.prioridade-aprov = 150.
            end case.
        end.
        release item-mat.
    &endif

 find first pend-item where 
      pend-item.it-codigo = item.it-codigo 
  and pend-item.modulo    = "MCC" exclusive-lock no-error.
 if  avail pend-item then delete pend-item.
 
 if connected("debsup") then do:
    assign substring(item.char-1,91,16) = string(c-ean-code:screen-value in frame {&frame-name},'x(16)').
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

    &if defined(bf_mat_aprova_eletronica) &then
        assign cb-prioridade:sensitive in frame {&frame-name} = no
               de-var-aprov:sensitive  in frame {&frame-name} = no.
    &endif

    assign c-ean-code:sensitive in frame {&frame-name} = no.
    disable c-ean-code with frame {&frame-name}.

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

  Do  with frame {&frame-name}:
    if available item then do:
      assign fi-demanda      = entry(item.demanda,{ininc/i02in122.i 03})
             fi-tipo-lote-ec = entry(item.tipo-lote-ec,{ininc/i04in172.i 03})
             fi-emissao-ord  = entry(item.emissao-ord,{ininc/i03in122.i 03})
             fi-politica     = entry(item.politica,{ininc/i04in122.i 03})
             c-ean-code      = trim(substring(item.char-1,91,16)).
    end.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        find item-mat where
            item-mat.it-codigo = item.it-codigo
            no-lock no-error.
        if available item-mat then do:
            display item-mat.variacao-perm @ de-var-aprov with frame {&frame-name}.
            if  item-mat.prioridade-aprov >= 0 and
                item-mat.prioridade-aprov <= 300 then
                assign cb-prioridade = entry(4,c-lista-prioridade).
            if  item-mat.prioridade-aprov >  300 and
                item-mat.prioridade-aprov <= 600 then
                assign cb-prioridade = entry(3,c-lista-prioridade).
            if  item-mat.prioridade-aprov >  600 and
                item-mat.prioridade-aprov <  999 then
                assign cb-prioridade = entry(2,c-lista-prioridade).
            if  item-mat.prioridade-aprov =  999 then
                assign cb-prioridade = entry(1,c-lista-prioridade).
            display cb-prioridade with frame {&frame-name}.
        end.
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

    &if defined(bf_mat_aprova_eletronica) &then
        if adm-new-record then do:
            assign cb-prioridade = entry(4,c-lista-prioridade).
            display cb-prioridade with frame {&frame-name}.
        end.    
        assign cb-prioridade:sensitive in frame {&frame-name} = yes
               de-var-aprov:sensitive  in frame {&frame-name} = yes.
    &endif

  /******* Integra‡Æo EMS x SISDOC ******/
  if  not adm-new-record then do:
      if  i-integracao-sisdoc = ? then do:
          RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                      OUTPUT c-handle).
          run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
      end.   
  end.  /* if not adm-new-record */
  
  if  l-passou = yes then do:
      assign l-passou = no.
      if i-retorno-erro = 5 or
         i-retorno-erro = 6 or
         i-retorno-erro = 7 then do:
         run notify ("pi-cancelar, tableio-source").
         return "adm-error".
         assign i-retorno-erro = ?.
      end.   
  end.
  /***** Fim Integra‡Æo EMS x SISDOC ****/
  if connected("debsup") then do:
      enable c-ean-code with frame {&frame-name}.
      assign c-ean-code:sensitive in frame {&frame-name} = yes.
  end.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
    /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /**  Melhorias
  **/
  &if defined(bf_mat_aprova_eletronica) &then
      assign cb-prioridade:hidden in frame {&frame-name} = no
             de-var-aprov:hidden  in frame {&frame-name} = no.
  &endif
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
  assign gr-item = if avail item then rowid(item) else gr-item.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter i-tipo-movto as integer.

if  param-global.modulo-mp and
    tt-replica-msg.log-replica-msg  = yes then do:
    create tt-dados-env.                  
    assign tt-dados-env.num-sequencia  = i-seq 
           tt-dados-env.cod-tipo-reg   = 3     
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = item.it-codigo.
    raw-transfer item to tt-dados-env.conteudo-msg.                                     
    assign i-seq = i-seq + 1.                                     
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
    
/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

     
          

if item.fraciona = no and 
    input frame {&frame-name} item.lote-multipl -
    int(input frame {&frame-name} item.lote-multipl) <> 0  
     then do:
        {include/i-vldprg.i}

       run utp/ut-msgs.p (input "show",
                          input 847,  /* Quantidade fracionada */
                          input return-value).
       apply "entry" to item.lote-multipl in frame {&frame-name}.
       return 'ADM-ERROR':U.
     end.



if item.fraciona = no and 
    input frame {&frame-name} item.quant-segur -
    int(input frame {&frame-name} item.quant-segur) <> 0  
     then do:
        {include/i-vldprg.i}

       run utp/ut-msgs.p (input "show",
                          input 847,  /* Quantidade fracionada */
                          input return-value).
       apply "entry" to item.quant-segur in frame {&frame-name}.
       return 'ADM-ERROR':U.
     end.


          
if item.fraciona = no and 
    input frame {&frame-name} item.quant-perda -
    int(input frame {&frame-name} item.quant-perda) <> 0  
     then do:
        {include/i-vldprg.i}

       run utp/ut-msgs.p (input "show",
                          input 847,  /* Quantidade fracionada */
                          input return-value).
       apply "entry" to item.quant-perda in frame {&frame-name}.
       return 'ADM-ERROR':U.
     end.


          
if item.fraciona = no and 
    input frame {&frame-name} item.lote-economi -
    int(input frame {&frame-name} item.lote-economi) <> 0  
     then do:
        {include/i-vldprg.i}

       run utp/ut-msgs.p (input "show",
                          input 847,  /* Quantidade fracionada */
                          input return-value).
       apply "entry" to item.lote-economi in frame {&frame-name}.
     return 'ADM-ERROR':U.
     end.

         


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
  {src/adm/template/snd-list.i "item"}

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

