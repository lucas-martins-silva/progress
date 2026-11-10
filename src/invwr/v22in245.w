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
{include/i-prgvrs.i V22IN245 2.00.00.020}  /*** 010020 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V22IN245 MUT}
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
    def new global shared var h_v22in245                   as handle no-undo.
    def var v-row-parent    as rowid   no-undo.
    def var l-novo-reg      as logical initial no.
    def var l-consum-final  as logical no-undo.
    def var l-setou-campo   as logical no-undo.

    def var l-ind-bipi     as logical no-undo.
    def var c-char-2       as char    no-undo.
    def var l-copy         as logical no-undo initial no.
    
def var l-primeiro  as logical init yes.
def var c-formato   as character.

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
&Scoped-Define ENABLED-FIELDS natur-oper.ipi-icm-out natur-oper.manut-ipi ~
natur-oper.usa-pick natur-oper.cd-vinc-ipi natur-oper.perc-red-ipi 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cd-vinc-ipi ~{&FP2}cd-vinc-ipi ~{&FP3}~
 ~{&FP1}perc-red-ipi ~{&FP2}perc-red-ipi ~{&FP3}
&Scoped-define ENABLED-TABLES natur-oper
&Scoped-define FIRST-ENABLED-TABLE natur-oper
&Scoped-Define ENABLED-OBJECTS rt-mold-2 rt-mold-3 
&Scoped-Define DISPLAYED-FIELDS natur-oper.ipi-icm-out natur-oper.manut-ipi ~
natur-oper.usa-pick natur-oper.cd-vinc-ipi natur-oper.perc-red-ipi 
&Scoped-Define DISPLAYED-OBJECTS l-ipi-out-subs l-ipi-bicms l-ipi-tot-nota ~
l-frete-bipi cb-trib-ipi c-desc-vinc-ipi 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS l-ipi-bicms l-ipi-tot-nota l-frete-bipi ~
cb-trib-ipi 

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
DEFINE VARIABLE cb-trib-ipi AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 20.57 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-desc-vinc-ipi AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22.29 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57.29 BY 5.88.

DEFINE RECTANGLE rt-mold-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 27.43 BY 5.88.

DEFINE VARIABLE l-frete-bipi AS LOGICAL INITIAL no 
     LABEL "Toggle 4" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-ipi-bicms AS LOGICAL INITIAL no 
     LABEL "Toggle 1" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-ipi-out-subs AS LOGICAL INITIAL no 
     LABEL "Toggle 2" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

DEFINE VARIABLE l-ipi-tot-nota AS LOGICAL INITIAL no 
     LABEL "Toggle 3" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.57 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     l-ipi-out-subs AT ROW 1.29 COL 2
     natur-oper.ipi-icm-out AT ROW 2.04 COL 2
          VIEW-AS TOGGLE-BOX
          SIZE 25.14 BY .83
     natur-oper.manut-ipi AT ROW 2.79 COL 2
          VIEW-AS TOGGLE-BOX
          SIZE 15.43 BY .83
     natur-oper.usa-pick AT ROW 3.54 COL 2
          VIEW-AS TOGGLE-BOX
          SIZE 25.43 BY .83
     l-ipi-bicms AT ROW 4.29 COL 2
     l-ipi-tot-nota AT ROW 5.04 COL 2
     l-frete-bipi AT ROW 5.79 COL 2
     natur-oper.cd-vinc-ipi AT ROW 2.38 COL 51.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cb-trib-ipi AT ROW 3.38 COL 51.72 COLON-ALIGNED
     natur-oper.perc-red-ipi AT ROW 4.38 COL 51.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-vinc-ipi AT ROW 2.38 COL 60 COLON-ALIGNED NO-LABEL
     rt-mold-2 AT ROW 1 COL 29
     rt-mold-3 AT ROW 1 COL 1
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
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 5.88
         WIDTH              = 85.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-vinc-ipi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-trib-ipi IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX l-frete-bipi IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX l-ipi-bicms IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX l-ipi-out-subs IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-ipi-tot-nota IN FRAME f-main
   NO-ENABLE 3                                                          */
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

&Scoped-define SELF-NAME cb-trib-ipi
&Scoped-define SELF-NAME natur-oper.cd-vinc-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cd-vinc-ipi V-table-Win
ON ENTRY OF natur-oper.cd-vinc-ipi IN FRAME f-main /* C¢digo Vinculaá∆o IPI */
DO:

assign natur-oper.cd-vinc-ipi:format = "99.9-x".
   
 /* if l-primeiro then do:
 *      assign c-formato  = self:format
 *             l-primeiro = no.
 *   end.
 * 
 *   assign self:format =  c-formato.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cd-vinc-ipi V-table-Win
ON F5 OF natur-oper.cd-vinc-ipi IN FRAME f-main /* C¢digo Vinculaá∆o IPI */
DO:
     l-implanta = yes.   
     {include/zoomvar.i &prog-zoom=dizoom/z01di013.w
                       &campo=natur-oper.cd-vinc-ipi
                       &campozoom=cd-vin-ipi}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cd-vinc-ipi V-table-Win
ON LEAVE OF natur-oper.cd-vinc-ipi IN FRAME f-main /* C¢digo Vinculaá∆o IPI */
DO:
  if substring(self:screen-value,1,1) = '0' or
     substring(self:screen-value,1,1) = ''  then do:
     assign self:format = 'x(4)'
            self:screen-value = ''.
  end.
  else do:
     {cdp/cd9998.i}
  end.             
  {include/leave.i &tabela=cod-vin-ipi
                   &atributo-ref=no-codvin
                   &variavel-ref=c-desc-vinc-ipi
                   &where="cod-vin-ipi.cd-vin-ipi = input frame {&frame-name} natur-oper.cd-vinc-ipi"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cd-vinc-ipi V-table-Win
ON MOUSE-SELECT-DBLCLICK OF natur-oper.cd-vinc-ipi IN FRAME f-main /* C¢digo Vinculaá∆o IPI */
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

{utp/ut-field.i mgind natur-oper cd-trib-ipi 1}
assign cb-trib-ipi:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Inclui_IPI_Base_do_ICMS * r}
assign l-ipi-bicms:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Inclui_IPI_Outras_Total * r}
assign l-ipi-tot-nota:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Inclui_Frete_na_Base_IPI * r}
assign l-frete-bipi:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Escrituraá∆o_IPI_Frete * R}
assign natur-oper.usa-pick:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Considera_IPI_Conhecimento_Frete_em_Obrigaá‰es_Fiscais * R}
assign natur-oper.usa-pick:help in frame {&frame-name} = return-value.

{utp/ut-liter.i IPI_Outros_Base_Subst * r}
assign l-ipi-out-subs:label in frame {&frame-name} = return-value.

if natur-oper.cd-vinc-ipi:load-mouse-pointer("image/lupa.cur")
   in frame {&frame-name} then.

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
  
   assign natur-oper.cd-vinc-ipi:screen-value in frame {&FRAME-NAME} = ""
          natur-oper.cd-vinc-ipi:format in frame {&frame-name} = "xxxx".

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
  
   assign input frame {&frame-name} cb-trib-ipi
          l-ipi-out-subs = l-ipi-out-subs:checked in frame {&frame-name}
          l-ipi-bicms    = l-ipi-bicms:checked    in frame {&frame-name}
          l-frete-bipi   = l-frete-bipi:checked   in frame {&frame-name}
          l-ipi-tot-nota = l-ipi-tot-nota:checked in frame {&frame-name}.

   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
   if RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.
    
   assign natur-oper.cd-trib-ipi = {ininc/i10in172.i 06 cb-trib-ipi}
          substr(natur-oper.char-2,1,5)  = if l-ipi-bicms then "1    " else "2    "
          substr(natur-oper.char-2,6,5)  = if l-frete-bipi then "1    " else "2    "
          substr(natur-oper.char-2,16,5) = if l-ipi-tot-nota then "1    " else "2    "
          substr(natur-oper.char-2,46,5) = if  l-ipi-out-subs then "1    " else "2    ". 
  
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  assign l-copy = yes.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .
  
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

    assign l-novo-reg = no
           l-setou-campo = no.

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  disable l-ipi-out-subs with frame {&frame-name}.
  
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
  
  if  available natur-oper then do with frame {&frame-name}:
      assign cb-trib-ipi:screen-value = {ininc/i10in172.i 04 natur-oper.cd-trib-ipi}.
      
      assign l-ipi-bicms:checked in frame {&frame-name}    = if substring(natur-oper.char-2,1,5) <> ""
                                                             then (int(substring(natur-oper.char-2,1,5)) = 1)
                                                             else no
             l-frete-bipi:checked in frame {&frame-name}   = if substring(natur-oper.char-2,6,5) <> ""
                                                             then (int(substring(natur-oper.char-2,6,5)) = 1)
                                                             else no
             l-ipi-tot-nota:checked in frame {&frame-name} = if substring(natur-oper.char-2,16,5) <> ""
                                                             then (int(substring(natur-oper.char-2,16,5)) = 1)
                                                             else no
             l-ipi-out-subs:checked in frame {&frame-name} = if substring(natur-oper.char-2,46,5) <> ""
                                                             then (int(substring(natur-oper.char-2,46,5)) = 1)
                                                             else no.
      
  end.
  else 
      assign cb-trib-ipi:screen-value = {ininc/i10in172.i 04 01}.
      
  

  assign natur-oper.cd-vinc-ipi:format in frame {&frame-name} = "99.9-x".

    find cod-vin-ipi where
        cod-vin-ipi.cd-vin-ipi = input frame {&frame-name} natur-oper.cd-vinc-ipi    
        no-lock no-error.
    assign c-desc-vinc-ipi:screen-value in frame {&frame-name} =
        if available cod-vin-ipi then
            cod-vin-ipi.no-codvin
        else "":U.        

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

  /* Campo com formataá∆o */
  apply 'leave' to natur-oper.cd-vinc-ipi in frame {&frame-name}.
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  assign l-novo-reg = yes.
  run pi-inicializa-campo (yes).

  enable l-ipi-out-subs with frame {&frame-name}.      
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    do with frame {&frame-name}:
        assign cb-trib-ipi:list-items = {ininc/i10in172.i 03}.
    end.
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    find first param-global
        no-lock no-error.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita V-table-Win 
PROCEDURE pi-habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param l-consum-final   as log   no-undo.

    if  l-consum-final then
        assign l-ipi-bicms:checked in frame {&frame-name} = yes.
    else
        assign natur-oper.ipi-icm-out:checked in frame {&frame-name} = no.

    assign l-ipi-bicms:sensitive in frame {&frame-name}            = not l-consum-final
           natur-oper.ipi-icm-out:sensitive in frame {&frame-name} = l-consum-final.
          

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

    if  l-novo-reg then do:
    
        RUN Get-Field-Screen-Value IN adm-broker-hdl
            (INPUT THIS-PROCEDURE, INPUT "consum-final").
        assign l-consum-final = return-value = "sim" or return-value = "yes".

        assign l-ipi-bicms:sensitive in frame {&frame-name}            = not l-consum-final
               natur-oper.ipi-icm-out:sensitive in frame {&frame-name} =   l-consum-final  
                                                                       and param-global.modulo-of 
                                                                       and param-global.modulo-re 
               natur-oper.cd-vinc-ipi:sensitive in frame {&frame-name} = param-global.modulo-of 
               natur-oper.manut-ipi:sensitive in frame {&frame-name}   = param-global.modulo-ft
               natur-oper.usa-pick:sensitive in frame {&frame-name}    = param-global.modulo-re.

        if  p-seta-campo and adm-new-record and not l-setou-campo then do:
            if  not l-consum-final
            or  not param-global.modulo-of then
                assign natur-oper.ipi-icm-out:checked in frame {&frame-name} = no.

            if  l-consum-final then
                assign l-ipi-bicms:checked in frame {&frame-name} = yes.
                
            assign l-setou-campo = yes.
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
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

  if  substring(input frame {&frame-name} natur-oper.cd-vinc-ipi,1,1) <> '' then do : 
    find first cod-vin-ipi where cod-vin-ipi.cd-vin-ipi = input frame {&frame-name} natur-oper.cd-vinc-ipi no-lock no-error. 
    if not avail cod-vin-ipi then do:           
       {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
       {utp/ut-field.i mgind natur-oper cd-vinc-ipi 1}
       run utp/ut-msgs.p (input "show":U, 
                          input 56, 
                          input return-value ).
       apply "entry" to natur-oper.cd-vinc-ipi in frame {&frame-name}.                   
       return 'ADM-ERROR':U.
    end. 
  end.
   
   /*Segue um exemplo de validaá∆o de programa 
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


