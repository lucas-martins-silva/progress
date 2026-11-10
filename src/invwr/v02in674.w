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
{include/i-prgvrs.i V02IN674 2.00.00.004} /*** "010004" 09/01/2026 14:41:40  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN674 MUT}
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

def var v-row-parent      as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES fam-mat-estab
&Scoped-define FIRST-EXTERNAL-TABLE fam-mat-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR fam-mat-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS fam-mat-estab.nat-despesa ~
fam-mat-estab.horiz-fixo fam-mat-estab.periodo-fixo 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nat-despesa ~{&FP2}nat-despesa ~{&FP3}~
 ~{&FP1}horiz-fixo ~{&FP2}horiz-fixo ~{&FP3}~
 ~{&FP1}periodo-fixo ~{&FP2}periodo-fixo ~{&FP3}
&Scoped-define ENABLED-TABLES fam-mat-estab
&Scoped-define FIRST-ENABLED-TABLE fam-mat-estab
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS fam-mat-estab.nat-despesa ~
fam-mat-estab.horiz-fixo fam-mat-estab.periodo-fixo 
&Scoped-Define DISPLAYED-OBJECTS c-desc-nat cb-tipo-est-seg ~
cb-classificacao-abc cb-emissao-ordens cb-tipo-lote-economico cb-politica ~
cb-tipo-demanda 

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
DEFINE VARIABLE cb-classificacao-abc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 1" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE cb-emissao-ordens AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 2" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE cb-politica AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 4" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-demanda AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 5" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-est-seg AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 1" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-lote-economico AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 3" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-nat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87.29 BY 10.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fam-mat-estab.nat-despesa AT ROW 1.67 COL 26.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     c-desc-nat AT ROW 1.67 COL 33.14 COLON-ALIGNED NO-LABEL
     cb-tipo-est-seg AT ROW 2.67 COL 26.43 COLON-ALIGNED
     cb-classificacao-abc AT ROW 3.67 COL 26.43 COLON-ALIGNED
     cb-emissao-ordens AT ROW 4.67 COL 26.43 COLON-ALIGNED
     cb-tipo-lote-economico AT ROW 5.67 COL 26.43 COLON-ALIGNED
     cb-politica AT ROW 6.67 COL 26.43 COLON-ALIGNED
     cb-tipo-demanda AT ROW 7.67 COL 26.43 COLON-ALIGNED
     fam-mat-estab.horiz-fixo AT ROW 8.67 COL 26.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     fam-mat-estab.periodo-fixo AT ROW 9.67 COL 26.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.fam-mat-estab
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
         HEIGHT             = 10.33
         WIDTH              = 87.29.
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

/* SETTINGS FOR FILL-IN c-desc-nat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-classificacao-abc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-emissao-ordens IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-politica IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tipo-demanda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tipo-est-seg IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tipo-lote-economico IN FRAME f-main
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

&Scoped-define SELF-NAME fam-mat-estab.nat-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.nat-despesa V-table-Win
ON F5 OF fam-mat-estab.nat-despesa IN FRAME f-main /* Natureza Despesa */
DO:
  {include/zoomvar.i &prog-zoom= "inzoom/z01in246.w"
                     &campo=fam-mat-estab.nat-despesa
                     &campozoom=nat-despesa}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.nat-despesa V-table-Win
ON LEAVE OF fam-mat-estab.nat-despesa IN FRAME f-main /* Natureza Despesa */
DO:
   for first natureza-despesa fields (nat-despesa descricao) where
       natureza-despesa.nat-despesa = input frame {&frame-name} fam-mat-estab.nat-despesa 
       no-lock: end.
  if avail natureza-despesa then
      assign c-desc-nat:screen-value in frame {&frame-name} = natureza-despesa.descricao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.nat-despesa V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fam-mat-estab.nat-despesa IN FRAME f-main /* Natureza Despesa */
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
  if fam-mat-estab.nat-despesa:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
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
  {src/adm/template/row-list.i "fam-mat-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "fam-mat-estab"}

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
    assign input frame {&frame-name} cb-classificacao-abc
           input frame {&frame-name} cb-emissao-ordens
           input frame {&frame-name} cb-tipo-lote-economico
           input frame {&frame-name} cb-politica 
           input frame {&frame-name} cb-tipo-demanda 
           input frame {&frame-name} cb-tipo-est-seg.
    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
    assign fam-mat-estab.classif-abc = {ininc/i03in172.i 06 cb-classificacao-abc}
           fam-mat-estab.emissao-ord = {ininc/i03in122.i 06 cb-emissao-ordens}
           fam-mat-estab.tipo-lote-ec = {ininc/i04in172.i 06 cb-tipo-lote-economico}
           fam-mat-estab.politica = {ininc/i04in122.i 06 cb-politica}
           fam-mat-estab.demanda = {ininc/i02in122.i 06 cb-tipo-demanda}
           fam-mat-estab.tipo-est-seg = {ininc/i05in122.i 06 cb-tipo-est-seg}.
                
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
    disable cb-classificacao-abc
            cb-emissao-ordens
            cb-tipo-lote-economico
            cb-politica
            cb-tipo-demanda
            cb-tipo-est-seg 
            with frame {&frame-name}.
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
  do  with frame {&frame-name}:
      if  avail fam-mat-estab then do:
          assign cb-classificacao-abc:screen-value    = {ininc/i03in172.i 04 fam-mat-estab.classif-abc}
                 cb-emissao-ordens:screen-value       = {ininc/i03in122.i 04 fam-mat-estab.emissao-ord}
                 cb-tipo-lote-economico:screen-value  = {ininc/i04in172.i 04 fam-mat-estab.tipo-lote-ec}
                 cb-politica:screen-value             = {ininc/i04in122.i 04 fam-mat-estab.politica}
                 cb-tipo-demanda:screen-value         = {ininc/i02in122.i 04 fam-mat-estab.demanda}
                 cb-tipo-est-seg:screen-value         = {ininc/i05in122.i 04 fam-mat-estab.tipo-est-seg}.
          for first natureza-despesa fields (nat-despesa descricao) where
              natureza-despesa.nat-despesa = fam-mat-estab.nat-despesa no-lock: end.
          if avail natureza-despesa then
              assign c-desc-nat:screen-value  = natureza-despesa.descricao.         
      end.
      else do:
          assign cb-classificacao-abc:screen-value    = {ininc/i03in172.i 04 1}
                 cb-emissao-ordens:screen-value       = {ininc/i03in122.i 04 1}
                 cb-tipo-lote-economico:screen-value  = {ininc/i04in172.i 04 1}
                 cb-politica:screen-value             = {ininc/i04in122.i 04 1}
                 cb-tipo-demanda:screen-value         = {ininc/i02in122.i 04 1}
                 cb-tipo-est-seg:screen-value         = {ininc/i05in122.i 04 1}
                 c-desc-nat:screen-value              = " ".
          
      end.
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
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    enable  cb-classificacao-abc
            cb-emissao-ordens
            cb-tipo-lote-economico
            cb-politica
            cb-tipo-demanda
            cb-tipo-est-seg 
            with frame {&frame-name}.
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
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
  do  with frame {&frame-name}:
      {utp/ut-field.i mgind item classif-abc 1}
      assign cb-classificacao-abc:label = trim(return-value).
      {utp/ut-field.i mgind item emissao-ord 1}
      assign cb-emissao-ordens:label = trim(return-value).
      {utp/ut-field.i mgind item tipo-lote-ec 1}
      assign cb-tipo-lote-economico:label = trim(return-value).
      {utp/ut-field.i mgind item politica 1}
      assign cb-politica:label = trim(return-value).
      {utp/ut-field.i mgind item demanda 1}
      assign cb-tipo-demanda:label = trim(return-value).
      {utp/ut-field.i mgind item tipo-est-seg 1}
      assign cb-tipo-est-seg:label = trim(return-value).
      
      assign cb-classificacao-abc:list-items   = {ininc/i03in172.i 03}
             cb-emissao-ordens:list-items      = {ininc/i03in122.i 03}
             cb-tipo-lote-economico:list-items = {ininc/i04in172.i 03}
             cb-politica:list-items            = {ininc/i04in122.i 03}
             cb-tipo-demanda:list-items        = {ininc/i02in122.i 03}
             cb-tipo-est-seg:list-items        = {ininc/i05in122.i 03}.
    
  end.
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
   if not can-find (natureza-despesa where
       natureza-despesa.nat-despesa = input frame {&frame-name} fam-mat-estab.nat-despesa) then do:
       {include/i-vldprg.i}
       {utp/ut-table.i mgind natureza-despesa 1}
       run utp/ut-msgs.p (input "show":U, input 56, input return-value).
       apply "entry" to fam-mat-estab.nat-despesa in frame {&frame-name}.
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
  {src/adm/template/snd-list.i "fam-mat-estab"}

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


