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
{include/i-prgvrs.i V24IN245 2.00.00.016}  /*** 010016 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V24IN245 MUT}
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
   def new global shared var wh-cb-tipo-nat-oper           as widget-handle no-undo.
   def new global shared var wh-v24in245                   as widget-handle no-undo.
   def new global shared var wh-v20in245                   as widget-handle no-undo.


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
    def new global shared var g-nat-oper as char.
    def var v-row-parent  as rowid   no-undo.
    def var l-novo-reg    as logical initial no.
    def var c-tipo        as char    no-undo.
    def var l-setou-campo as logical no-undo.
    def var c-nat-oper    as char    no-undo.
    
    def buffer b-natur-oper for natur-oper.

    def var l-ind-biss    as logical no-undo.
    def var c-char-2      as char    no-undo.
    def var c-char-2-aux  as char    no-undo.
    def var c-tipo-nat    as char    no-undo.
    def var l-copia       as log init no no-undo.

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
&Scoped-Define ENABLED-FIELDS natur-oper.perc-red-iss ~
natur-oper.nat-vinculada natur-oper.perc-PIS[1] natur-oper.per-fin-soc[1] ~
natur-oper.perc-PIS[2] natur-oper.per-fin-soc[2] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}perc-red-iss ~{&FP2}perc-red-iss ~{&FP3}~
 ~{&FP1}nat-vinculada ~{&FP2}nat-vinculada ~{&FP3}~
 ~{&FP1}perc-PIS[1] ~{&FP2}perc-PIS[1] ~{&FP3}~
 ~{&FP1}per-fin-soc[1] ~{&FP2}per-fin-soc[1] ~{&FP3}~
 ~{&FP1}perc-PIS[2] ~{&FP2}perc-PIS[2] ~{&FP3}~
 ~{&FP1}per-fin-soc[2] ~{&FP2}per-fin-soc[2] ~{&FP3}
&Scoped-define ENABLED-TABLES natur-oper
&Scoped-define FIRST-ENABLED-TABLE natur-oper
&Scoped-Define ENABLED-OBJECTS rt-mold-5 rt-mold-4 
&Scoped-Define DISPLAYED-FIELDS natur-oper.perc-red-iss ~
natur-oper.nat-vinculada natur-oper.perc-PIS[1] natur-oper.per-fin-soc[1] ~
natur-oper.perc-PIS[2] natur-oper.per-fin-soc[2] 
&Scoped-Define DISPLAYED-OBJECTS cb-trib-iss cb-ind-biss ~
c-desc-nat-vinculada 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cb-trib-iss cb-ind-biss 

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
DEFINE VARIABLE cb-ind-biss AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 3" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 19.72 BY 1 NO-UNDO.

DEFINE VARIABLE cb-trib-iss AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 2" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 19.72 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-nat-vinculada AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.29 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.29 BY 4.25.

DEFINE RECTANGLE rt-mold-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.29 BY 4.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-trib-iss AT ROW 1.17 COL 33.86 COLON-ALIGNED
     cb-ind-biss AT ROW 2.17 COL 33.86 COLON-ALIGNED
     natur-oper.perc-red-iss AT ROW 3.17 COL 33.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     natur-oper.nat-vinculada AT ROW 4.17 COL 33.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     c-desc-nat-vinculada AT ROW 4.17 COL 44.72 COLON-ALIGNED NO-LABEL
     natur-oper.perc-PIS[1] AT ROW 5.79 COL 33.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     natur-oper.per-fin-soc[1] AT ROW 6.79 COL 33.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     natur-oper.perc-PIS[2] AT ROW 7.79 COL 33.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     natur-oper.per-fin-soc[2] AT ROW 8.79 COL 33.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     rt-mold-5 AT ROW 1 COL 1
     rt-mold-4 AT ROW 5.63 COL 1
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
         HEIGHT             = 9.04
         WIDTH              = 86.43.
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

/* SETTINGS FOR FILL-IN c-desc-nat-vinculada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-ind-biss IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-trib-iss IN FRAME f-main
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

&Scoped-define SELF-NAME natur-oper.nat-vinculada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.nat-vinculada V-table-Win
ON ENTRY OF natur-oper.nat-vinculada IN FRAME f-main /* Natureza Vinculada */
DO:
  assign natur-oper.nat-vinculada:format in frame {&frame-name} = "9.99-xxx".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.nat-vinculada V-table-Win
ON F5 OF natur-oper.nat-vinculada IN FRAME f-main /* Natureza Vinculada */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z01in245.w
                       &campo=natur-oper.nat-vinculada
                       &campozoom=nat-operacao}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.nat-vinculada V-table-Win
ON LEAVE OF natur-oper.nat-vinculada IN FRAME f-main /* Natureza Vinculada */
DO:
 
  if substring(self:screen-value,1,1) = '0' or
     substring(self:screen-value,1,1) = ''  then do:
     assign self:format = 'xxxxxx'
            self:screen-value = ''.
  end.
  else do:
     {cdp/cd9998.i}
  end.             
  
 find b-natur-oper where
      b-natur-oper.nat-operacao = input frame {&frame-name} natur-oper.nat-vinculada
      no-lock no-error.
 assign c-desc-nat-vinculada:screen-value in frame {&frame-name} =
        if available b-natur-oper then
           b-natur-oper.denominacao
        else "":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.nat-vinculada V-table-Win
ON MOUSE-SELECT-DBLCLICK OF natur-oper.nat-vinculada IN FRAME f-main /* Natureza Vinculada */
DO:

    apply "F5" to self.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.perc-red-iss
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.perc-red-iss V-table-Win
ON LEAVE OF natur-oper.perc-red-iss IN FRAME f-main /* % Reduá∆o ISS */
DO:
  /*assign natur-oper.nat-vinculada:sensitive in frame {&frame-name} =
 *       if g-nat-oper = "servico" 
 *           then yes          
 *           else no.*/
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

    {utp/ut-liter.i Base_ISS * r}
    assign cb-ind-biss:label in frame {&frame-name} = trim(return-value).

    {utp/ut-field.i mgind natur-oper cd-trib-iss 1}
    assign cb-trib-iss:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i %_PIS_Interno * L}
    assign mgind.natur-oper.perc-PIS[1]:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i %_PIS_Exportaá∆o * L}
    assign mgind.natur-oper.perc-PIS[2]:label in frame {&frame-name} = trim(return-value).    
    
    {utp/ut-liter.i %_COFINS_Interno * L}
    assign mgind.natur-oper.per-fin-soc[1]:label in frame {&frame-name} = trim(return-value).    
    
    {utp/ut-liter.i %_COFINS_Exportaá∆o * L}
    assign mgind.natur-oper.per-fin-soc[2]:label in frame {&frame-name} = trim(return-value).

    if natur-oper.nat-vinculada:load-mouse-pointer("image/lupa.cur")
        in frame {&frame-name} then .

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
  
  assign natur-oper.nat-vinculada:screen-value in frame {&frame-name} = ""
         natur-oper.nat-vinculada:format in frame {&frame-name} = "xxxxxx"
         cb-ind-biss:screen-value in frame {&frame-name}        = {varinc/var00074.i 04 01}.
  
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
  
  assign input frame {&frame-name} cb-trib-iss cb-ind-biss.
  
  if input frame {&frame-name} natur-oper.nat-vinculada = " " 
  or input frame {&frame-name} natur-oper.nat-vinculada = ? then
     assign natur-oper.nat-vinculada:format in frame {&frame-name} = "xxxxxx"
            natur-oper.nat-vinculada:screen-value in frame {&frame-name} = "".
   
  /* Dispatch standard ADM method.                             */
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.
  
  assign natur-oper.cd-trib-iss = {ininc/i11in172.i 06 cb-trib-iss}
         c-char-2-aux           = if  trim(natur-oper.char-2) <> ""
                                  then natur-oper.char-2
                                  else "                    ":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  assign l-ind-biss                     = {varinc/var00074.i 06 cb-ind-biss} = 1
         substr(natur-oper.char-2,21,5) = if l-ind-biss then "1    " else "2    ".
         

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
  
  assign  l-copia = yes.

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

  if  avail natur-oper then
      assign natur-oper.nat-vinculada:format in frame {&frame-name} = "9.99-xxx".

  if  avail natur-oper or l-copia then do with frame {&frame-name}:
      assign cb-trib-iss:screen-value = {ininc/i11in172.i 04 natur-oper.cd-trib-iss}.
      if  natur-oper.char-2 <> ?
      and trim(substr(natur-oper.char-2,21,1)) <> "" then
          assign cb-ind-biss:screen-value = {varinc/var00074.i 04 int(substr(natur-oper.char-2,21,5))}.
      else
          assign cb-ind-biss:screen-value = {varinc/var00074.i 04 01}.        
  end.
  else
      assign cb-trib-iss:screen-value = {ininc/i11in172.i 04 01}
             cb-ind-biss:screen-value = {varinc/var00074.i 04 01}.

  find b-natur-oper 
      where b-natur-oper.nat-operacao = input frame {&frame-name} natur-oper.nat-vinculada
      no-lock no-error.

  assign c-desc-nat-vinculada:screen-value in frame {&frame-name} = if  available b-natur-oper 
                                                                    then b-natur-oper.denominacao
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if  avail natur-oper then do:
      if  substr(natur-oper.nat-vinculada,1,1) = "" or
          natur-oper.nat-vinculada:screen-value in frame {&frame-name} = ? then do:
          assign natur-oper.nat-vinculada:screen-value in frame {&frame-name} = ""
                 natur-oper.nat-vinculada:format       in frame {&frame-name} = "xxxxxx"
                 c-desc-nat-vinculada:screen-value     in frame {&frame-name} = "".
      end.
  end.
            
   
  if  not param-global.modulo-ft then
      disable cb-trib-iss
              cb-ind-biss
              natur-oper.perc-red-iss
              natur-oper.nat-vinculada with frame {&frame-name}.
  
  /*if adm-new-record = yes then*/
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  assign l-novo-reg = yes.
  run pi-inicializa-campo (yes).


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
        assign cb-trib-iss:list-items = {ininc/i11in172.i 03}.
        assign cb-ind-biss:list-items = {varinc/var00074.i 03}.
    end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
    find first param-global
        no-lock no-error.
        
  assign wh-v24in245 = this-procedure.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-disable-campo V-table-Win 
PROCEDURE pi-disable-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
enable natur-oper.nat-vinculada with frame {&frame-name}.

/*assign natur-oper.nat-vinculada:sensitive in frame {&frame-name} = yes.*/
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-disable-campo-2 V-table-Win 
PROCEDURE pi-disable-campo-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign natur-oper.nat-vinculada:screen-value in frame {&frame-name} = ""
       natur-oper.nat-vinculada:format in frame {&frame-name} = "xxx"
       c-desc-nat-vinculada:screen-value in frame {&frame-name} = "".
       
disable natur-oper.nat-vinculada with frame {&frame-name}.       



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
            (INPUT THIS-PROCEDURE, INPUT "tipo":U).
            assign c-tipo = return-value.
            
        assign natur-oper.nat-vinculada:sensitive in frame {&frame-name} =
                                        if {ininc/i06in245.i 06 c-tipo-nat} = 3 
                                        and param-global.modulo-ft 
                                        then yes
                                        else no.

        if  p-seta-campo 
        and adm-new-record 
        and not l-setou-campo then
            assign l-setou-campo = yes.
                
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-tipo V-table-Win 
PROCEDURE pi-recebe-tipo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter c-tp as char no-undo.

assign c-tipo-nat = c-tp.

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
  

    /*RUN Get-Field-Screen-Value IN adm-broker-hdl 
 *         (INPUT THIS-PROCEDURE, INPUT "tipo":U).
 *         assign c-tipo         = return-value.*/

    RUN Get-Field-Screen-Value IN adm-broker-hdl 
        (INPUT THIS-PROCEDURE, INPUT "nat-operacao":U).
        assign c-nat-oper     = return-value.
        
    if {ininc/i06in245.i 06 c-tipo-nat} = 3 then do:   
        if input frame {&frame-name} natur-oper.nat-vinculada <> ""
        and input frame {&frame-name} natur-oper.nat-vinculada <> ? then do: 
            if substring(c-nat-oper,1,1) <> substring(input frame {&frame-name} natur-oper.nat-vinculada,1,1) 
                or c-nat-oper = input frame {&frame-name} natur-oper.nat-vinculada then do:
                {include/i-vldprg.i} 
                /* mensagem: Natureza de Operaá∆o invalida */
                run utp/ut-msgs.p (input "show":U, input 4676, input "").
                apply "entry" to natur-oper.nat-vinculada in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
            find first b-natur-oper use-index natureza where
                b-natur-oper.nat-operacao = input frame {&frame-name} natur-oper.nat-vinculada
                no-lock no-error.
            if not available b-natur-oper then do:
                {include/i-vldprg.i} 
                /* mensagem: Natureza de Operaá∆o n∆o cadastrada */
                run utp/ut-msgs.p (input "show":U, input 8193, input return-value).
                apply "entry" to natur-oper.nat-vinculada in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
            if available b-natur-oper and
                b-natur-oper.tipo <> 2 then do:
                {include/i-vldprg.i} 
                /* mensagem: Natureza de Operaá∆o invalida */
                run utp/ut-msgs.p (input "show":U, input 4676, input return-value).
                apply "entry" to natur-oper.nat-vinculada in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
        end.
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


