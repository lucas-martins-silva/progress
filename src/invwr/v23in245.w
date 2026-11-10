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
{include/i-prgvrs.i V23IN245 2.00.00.026}  /*** 010026 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V23IN245 MUT}
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
{cdp/cdcfgdis.i} /* preprocessadores 2.2 */

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
    
    def var v-row-parent    as rowid   no-undo.
    def var l-novo-reg      as logical initial no.
    def var l-setou-campo   as logical no-undo.

    def var l-destino-icm   as logical no-undo.
    def var c-char-2        as char    no-undo.
    def var c-char-2-aux    as char    no-undo.
    def var c-container     as char    no-undo.

    def var l-habilita      as logical init no no-undo.
    def var h-viewer        as handle no-undo.
    def var h-container     as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES natur-oper
&Scoped-define FIRST-EXTERNAL-TABLE natur-oper


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR natur-oper.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS natur-oper.per-des-icms ~
natur-oper.consum-final natur-oper.manut-icm natur-oper.subs-trib ~
natur-oper.perc-red-icm natur-oper.usa-nota-ent natur-oper.aliquota-icm ~
natur-oper.aliq-icm-com natur-oper.ind-tipo-vat natur-oper.ind-it-icms ~
natur-oper.tp-base-icm natur-oper.icms-subs-trib 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}per-des-icms ~{&FP2}per-des-icms ~{&FP3}~
 ~{&FP1}perc-red-icm ~{&FP2}perc-red-icm ~{&FP3}~
 ~{&FP1}aliquota-icm ~{&FP2}aliquota-icm ~{&FP3}~
 ~{&FP1}aliq-icm-com ~{&FP2}aliq-icm-com ~{&FP3}~
 ~{&FP1}tp-base-icm ~{&FP2}tp-base-icm ~{&FP3}~
 ~{&FP1}icms-subs-trib ~{&FP2}icms-subs-trib ~{&FP3}
&Scoped-define ENABLED-TABLES natur-oper
&Scoped-define FIRST-ENABLED-TABLE natur-oper
&Scoped-Define ENABLED-OBJECTS rt-mold-3 rt-mold-2 l-credito-ciap ~
l-acumula-ciap 
&Scoped-Define DISPLAYED-FIELDS natur-oper.per-des-icms ~
natur-oper.consum-final natur-oper.manut-icm natur-oper.subs-trib ~
natur-oper.perc-red-icm natur-oper.usa-nota-ent natur-oper.aliquota-icm ~
natur-oper.aliq-icm-com natur-oper.ind-tipo-vat natur-oper.ind-it-icms ~
natur-oper.tp-base-icm natur-oper.icms-subs-trib 
&Scoped-Define DISPLAYED-OBJECTS l-icm-out-subs de-desc-icms-zf cb-trib-icm ~
l-gera-cred-subs cb-destino-icm l-suspenso l-diferido cb-merc-base-icms ~
l-credito-ciap l-acumula-ciap 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS l-icm-out-subs l-gera-cred-subs 
&Scoped-define ADM-MODIFY-FIELDS l-icm-out-subs de-desc-icms-zf cb-trib-icm ~
l-gera-cred-subs cb-destino-icm cb-merc-base-icms 

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
DEFINE VARIABLE cb-destino-icm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 3" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cb-merc-base-icms AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 3" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cb-trib-icm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 1" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE de-desc-icms-zf AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "% Desconto Zona Franca" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 51 BY 10.38.

DEFINE RECTANGLE rt-mold-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29 BY 10.38.

DEFINE VARIABLE l-acumula-ciap AS LOGICAL INITIAL no 
     LABEL "Considera NF para Ciap" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.86 BY .83 NO-UNDO.

DEFINE VARIABLE l-credito-ciap AS LOGICAL INITIAL no 
     LABEL "Manut Credito Ciap" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.86 BY .83 NO-UNDO.

DEFINE VARIABLE l-diferido AS LOGICAL INITIAL no 
     LABEL "Item ICMS Diferido":L20 
     VIEW-AS TOGGLE-BOX
     SIZE 25.86 BY .83 NO-UNDO.

DEFINE VARIABLE l-gera-cred-subs AS LOGICAL INITIAL no 
     LABEL "Toggle 1" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE l-icm-out-subs AS LOGICAL INITIAL no 
     LABEL "Toggle 1" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE l-suspenso AS LOGICAL INITIAL no 
     LABEL "Item ICMS Suspenso":L20 
     VIEW-AS TOGGLE-BOX
     SIZE 25.86 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     natur-oper.per-des-icms AT ROW 1.29 COL 58.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     l-icm-out-subs AT ROW 1.54 COL 3.14
     natur-oper.consum-final AT ROW 2.29 COL 3.14
          VIEW-AS TOGGLE-BOX
          SIZE 22.14 BY .83
     de-desc-icms-zf AT ROW 2.29 COL 58.86 COLON-ALIGNED
     natur-oper.manut-icm AT ROW 3.04 COL 3.14
          VIEW-AS TOGGLE-BOX
          SIZE 17.86 BY .83
     cb-trib-icm AT ROW 3.29 COL 58.72 COLON-ALIGNED
     natur-oper.subs-trib AT ROW 3.79 COL 3.14
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     natur-oper.perc-red-icm AT ROW 4.29 COL 58.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     l-gera-cred-subs AT ROW 4.54 COL 3.14
     natur-oper.usa-nota-ent AT ROW 5.29 COL 3.14
          VIEW-AS TOGGLE-BOX
          SIZE 24.72 BY .83
     cb-destino-icm AT ROW 5.29 COL 58.72 COLON-ALIGNED
     l-suspenso AT ROW 6.04 COL 3.14 HELP
          "Capital Tipo VAT"
     natur-oper.aliquota-icm AT ROW 6.29 COL 58.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     l-diferido AT ROW 6.79 COL 3.14 HELP
          "Capital Tipo VAT"
     natur-oper.aliq-icm-com AT ROW 7.29 COL 58.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     natur-oper.ind-tipo-vat AT ROW 7.54 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 25.86 BY .83
     natur-oper.ind-it-icms AT ROW 8.29 COL 3.14
          VIEW-AS TOGGLE-BOX
          SIZE 25.14 BY .83
     cb-merc-base-icms AT ROW 8.29 COL 79.72 RIGHT-ALIGNED
     l-credito-ciap AT ROW 9.04 COL 3.14
     natur-oper.tp-base-icm AT ROW 9.29 COL 58.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.14 BY .88
     l-acumula-ciap AT ROW 9.79 COL 3.14
     natur-oper.icms-subs-trib AT ROW 10.29 COL 58.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     rt-mold-3 AT ROW 1 COL 1
     rt-mold-2 AT ROW 1 COL 30.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.natur-oper
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
         HEIGHT             = 10.54
         WIDTH              = 80.86.
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

/* SETTINGS FOR COMBO-BOX cb-destino-icm IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-merc-base-icms IN FRAME f-main
   NO-ENABLE ALIGN-R 3                                                  */
/* SETTINGS FOR COMBO-BOX cb-trib-icm IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN de-desc-icms-zf IN FRAME f-main
   NO-ENABLE 3                                                          */
ASSIGN 
       l-acumula-ciap:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       l-credito-ciap:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX l-diferido IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-gera-cred-subs IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX l-icm-out-subs IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX l-suspenso IN FRAME f-main
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

&Scoped-define SELF-NAME natur-oper.consum-final
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.consum-final V-table-Win
ON VALUE-CHANGED OF natur-oper.consum-final IN FRAME f-main /* Consumidor Final */
DO:
    
    RUN Who-Is-The-Container IN adm-broker-hdl
        (INPUT this-procedure, OUTPUT c-container).
        
    assign h-container = widget-handle(c-container).
    
    run pi-busca-handle in h-container ( output h-viewer ).
    run pi-habilita in h-viewer ( input frame {&frame-name} natur-oper.consum-final ).
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-diferido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-diferido V-table-Win
ON VALUE-CHANGED OF l-diferido IN FRAME f-main /* Item ICMS Diferido */
DO:
  if l-diferido:checked in frame {&FRAME-NAME} then do:
     assign l-suspenso:checked in frame {&FRAME-NAME} = no.
     disable l-suspenso with frame {&FRAME-NAME}.
  end.
  else do:
     enable l-suspenso with frame {&FRAME-NAME}.
  end.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-suspenso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-suspenso V-table-Win
ON VALUE-CHANGED OF l-suspenso IN FRAME f-main /* Item ICMS Suspenso */
DO:
  if l-suspenso:checked in frame {&FRAME-NAME} then do:
     assign l-diferido:checked in frame {&FRAME-NAME} = no.
     disable l-diferido with frame {&FRAME-NAME}.
  end.
  else do:
     enable l-diferido with frame {&FRAME-NAME}.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.subs-trib
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.subs-trib V-table-Win
ON VALUE-CHANGED OF natur-oper.subs-trib IN FRAME f-main /* Substitui‡Æo Tribut ria */
DO:
    assign natur-oper.usa-nota-ent:sensitive in frame {&frame-name} =   
                                   natur-oper.subs-trib:checked in frame {&frame-name} 
                                   and param-global.modulo-re 
           l-gera-cred-subs:sensitive in frame {&frame-name} =
                                   natur-oper.subs-trib:checked in frame {&frame-name} 
                                   and param-global.modulo-re. 
                                   
    if  not natur-oper.subs-trib:checked in frame {&frame-name} then
        assign natur-oper.usa-nota-ent:checked in frame {&frame-name} = no
               l-gera-cred-subs:checked in frame {&frame-name}        = no.
                                   
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

    {utp/ut-field.i mgind natur-oper cd-trib-icm 1}
    assign cb-trib-icm:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i Base_ICMS * L}
    assign cb-merc-base-icms:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Destino_Redu‡Æo_ICMS * L}
    assign cb-destino-icm:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i Subst_Tribut ria * L}
    assign natur-oper.subs-trib:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i ICMS_Outros_Valor_Subst * L}
    assign l-icm-out-subs:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Diminui_Substitui‡Æo_Total_Frete * L}
    assign natur-oper.usa-nota-ent:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Gera_Cr‚dito_Subst_Tribut ria * L}
    assign l-gera-cred-subs:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i %_Desconto_Zona_Franca * L}
    assign de-desc-icms-zf:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Manut_Credito_Ciap * L}
    assign l-credito-ciap:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i Considera_NF_para_Ciap * L}
    assign l-acumula-ciap:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i Item_ICMS_Suspenso * L}
    assign l-suspenso:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i Item_ICMS_Diferido * L}
    assign l-diferido:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i NÆo_Tributada_(ICMS) * L}
    assign natur-oper.ind-tipo-vat:label in frame {&frame-name} = trim(return-value).

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
  {src/adm/template/row-list.i "natur-oper"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "natur-oper"}

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
  
  assign natur-oper.usa-nota-ent:checked in frame {&frame-name} = no
         l-gera-cred-subs:checked in frame {&frame-name}        = no.

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

  assign input frame {&frame-name} cb-trib-icm
         input frame {&frame-name} cb-destino-icm
         input frame {&frame-name} cb-merc-base-icms
         input frame {&frame-name} l-icm-out-subs
         input frame {&frame-name} de-desc-icms-zf
         input frame {&frame-name} l-credito-ciap
         input frame {&frame-name} l-acumula-ciap
         input frame {&frame-name} l-suspenso
         input frame {&frame-name} l-diferido.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  assign natur-oper.cd-trib-icm         = {ininc/i01in245.i 06 cb-trib-icm}
         natur-oper.merc-base-icms      = {ininc/i05in245.i 06 cb-merc-base-icms}
         l-destino-icm                  = {varinc/var00071.i 06 cb-destino-icm} = 1   
         natur-oper.dec-2               = int(l-destino-icm)
         substr(natur-oper.char-2,51,5) = if  l-icm-out-subs
                                          then "1    " 
                                          else "2    "
         substr(natur-oper.char-2,56,5) = if  l-gera-cred-subs
                                          then "1    " 
                                          else "2    "
         substr(natur-oper.char-2,66,5) = if  de-desc-icms-zf <> ?
                                          then string(de-desc-icms-zf,'>9.99')
                                          else " ".
         
  &if defined(bf_dis_ciap) &then        
      assign natur-oper.credito-ciap  = l-credito-ciap
             natur-oper.log-acum-ciap = l-acumula-ciap.
  &endif
            
  
  assign natur-oper.ind-it-sub-dif = if l-suspenso then yes
                                     else if l-diferido then ? 
                                          else no.
             
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

  assign l-novo-reg    = no
         l-setou-campo = no.

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  &if defined(bf_dis_ciap) &then
      disable l-credito-ciap 
              l-acumula-ciap with frame {&frame-name}.
  &endif
 
  disable l-suspenso
          l-diferido
          natur-oper.ind-tipo-vat with frame {&frame-name}.

  

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
        
      if  avail natur-oper then do:
          assign cb-trib-icm:screen-value       = {ininc/i01in245.i 04 natur-oper.cd-trib-icm}
                 cb-destino-icm:screen-value    = if  natur-oper.dec-2 = 1
                                                  then {varinc/var00071.i 04 1}
                                                  else {varinc/var00071.i 04 2}
                 cb-merc-base-icms:screen-value = {ininc/i05in245.i 04 natur-oper.merc-base-icms}
                 l-icm-out-subs:checked         = int(substr(natur-oper.char-2,51,5)) = 1                 
                 l-gera-cred-subs:checked       = int(substr(natur-oper.char-2,56,5)) = 1
                 de-desc-icms-zf:screen-value   = if  natur-oper.char-2 <> ?
                                                  then string(dec(substr(natur-oper.char-2,66,5)))
                                                  else "0".
                                                  
                                                  
          assign l-suspenso:checked = if natur-oper.ind-it-sub-dif then yes
                                      else no
                 l-diferido:checked = if natur-oper.ind-it-sub-dif = ? then yes
                                      else no.
                                                                      
                 
          &if defined(bf_dis_ciap) &then
              assign l-credito-ciap:hidden in frame {&frame-name} = no
                     l-acumula-ciap:hidden in frame {&frame-name} = no
                     l-credito-ciap:checked     = natur-oper.credito-ciap
                     l-acumula-ciap:checked     = natur-oper.log-acum-ciap.
          &endif                  
      end.           
      else
          assign cb-trib-icm:screen-value       = {ininc/i01in245.i 04 01}
                 cb-destino-icm:screen-value    = {varinc/var00071.i 04 01}
                 cb-merc-base-icms:screen-value = {ininc/i05in245.i 04 01}
                 de-desc-icms-zf:screen-value   = "0".
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable V-table-Win 
PROCEDURE local-enable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable':U ) .

    
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
  
  /*if adm-new-record = yes then*/
  &if  defined(ADM-MODIFY-FIELDS) &then
       enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
       &if defined(bf_dis_ciap) &then
           enable l-acumula-ciap
                  l-credito-ciap  with frame {&frame-name}.
       &endif    
  &endif

  assign l-novo-reg = yes.  
  run pi-inicializa-campo (yes).

  enable l-suspenso
         l-diferido
         natur-oper.ind-tipo-vat with frame {&frame-name}.
        

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
      assign cb-trib-icm:list-items = {ininc/i01in245.i 03}
             cb-destino-icm:list-items = {varinc/var00071.i 03}
             cb-merc-base-icms:list-items = {ininc/i05in245.i 03}.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  find first param-global no-lock no-error.


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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campo V-table-Win 
PROCEDURE pi-inicializa-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-seta-campo as logical no-undo.

    if  l-novo-reg then do with frame {&frame-name}:
    
        assign natur-oper.manut-icm:sensitive    = param-global.modulo-ft 
               natur-oper.subs-trib:sensitive    = param-global.modulo-re 
               natur-oper.usa-nota-ent:sensitive =   natur-oper.subs-trib:checked
                                                 and param-global.modulo-re
               l-gera-cred-subs:sensitive        =   natur-oper.subs-trib:checked
                                                 and param-global.modulo-re.

        if  p-seta-campo 
        and adm-new-record 
        and not l-setou-campo then
            assign l-setou-campo = yes.

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
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure, INPUT "cb-tipo-nat-oper").
 
   if  {ininc/i06in245.i 06 return-value} <> 1 /* Entrada */
   and {ininc/i01in245.i 06 cb-trib-icm:screen-value}  = 5 /* Diferido */ then do:
       /* C¢digo de tributa‡Æo nÆo pode ser diferido */
       run utp/ut-msgs.p (input "show":U, input 18587, input "").
       apply "entry":U to cb-trib-icm in frame {&frame-name}.
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
  {src/adm/template/snd-list.i "natur-oper"}

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


