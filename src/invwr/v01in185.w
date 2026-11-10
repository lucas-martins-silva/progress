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
{include/i-prgvrs.i V01IN185 2.00.00.035 } /*** 010035 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN185 MUT}
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

{cdp/cdcfgmat.i}

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-item-tab for item-tab.

def new shared var i-quant    as integer no-undo.

def var r-row-table as rowid no-undo.
def var r-row-item as rowid no-undo. 
def var c-label as char no-undo.

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
&Scoped-define EXTERNAL-TABLES item-tab
&Scoped-define FIRST-EXTERNAL-TABLE item-tab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-tab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-tab.it-codigo item-tab.pr-item ~
item-tab.int-1 item-tab.quant-min item-tab.aliquota-ipi ~
item-tab.desco-quant item-tab.aliquota-icm 
&Scoped-define ENABLED-TABLES item-tab
&Scoped-define FIRST-ENABLED-TABLE item-tab
&Scoped-Define ENABLED-OBJECTS de-desconto rt-key 
&Scoped-Define DISPLAYED-FIELDS item-tab.it-codigo item-tab.pr-item ~
item-tab.int-1 item-tab.quant-min item-tab.aliquota-ipi ~
item-tab.desco-quant item-tab.aliquota-icm 
&Scoped-define DISPLAYED-TABLES item-tab
&Scoped-define FIRST-DISPLAYED-TABLE item-tab
&Scoped-Define DISPLAYED-OBJECTS c-descricao c-un de-desconto 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS item-tab.aliquota-icm 

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
DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(60)" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "xx" 
     LABEL "Unidade Medida":R17 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE de-desconto AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 5.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-tab.it-codigo AT ROW 1.54 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     c-descricao AT ROW 1.54 COL 36 COLON-ALIGNED NO-LABEL
     c-un AT ROW 2.54 COL 18 COLON-ALIGNED
     item-tab.pr-item AT ROW 2.54 COL 57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     item-tab.int-1 AT ROW 3.54 COL 18 COLON-ALIGNED FORMAT ">>9"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     item-tab.quant-min AT ROW 3.54 COL 57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     item-tab.aliquota-ipi AT ROW 4.54 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     item-tab.desco-quant AT ROW 4.54 COL 57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     item-tab.aliquota-icm AT ROW 5.54 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     de-desconto AT ROW 5.5 COL 57 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-tab
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 6.25
         WIDTH              = 82.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN item-tab.aliquota-icm IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-tab.int-1 IN FRAME f-main
   EXP-FORMAT                                                           */
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

&Scoped-define SELF-NAME de-desconto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-desconto V-table-Win
ON LEAVE OF de-desconto IN FRAME f-main
DO:

    if input frame {&frame-name} item-tab.quant-min = 0 then
        assign i-quant = 1.
    else
        assign i-quant = input frame {&frame-name} item-tab.quant-min.

    display (ROUND((input frame {&frame-name} de-desconto * 100) / (input frame {&frame-name} item-tab.pr-item * 
    		    i-quant),2)) @ item-tab.desco-quant with frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-tab.desco-quant
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-tab.desco-quant V-table-Win
ON LEAVE OF item-tab.desco-quant IN FRAME f-main /* Desconto por Quantidade */
DO:

    if input frame {&frame-name} item-tab.quant-min = 0 then
        assign i-quant = 1.
    else
        assign i-quant = input frame {&frame-name} item-tab.quant-min.

    assign de-desconto = (((i-quant *
                            input frame {&frame-name} item-tab.pr-item) *
                            input frame {&frame-name} item-tab.desco-quant) / 100).    
    
    display de-desconto with frame {&frame-name}.

    if input frame {&frame-name} item-tab.desco-quant = ? 
    then do :
         assign item-tab.desco-quant:screen-value in frame {&frame-name} = string(0).
    end.

    assign de-desconto = 0.     
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-tab.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-tab.it-codigo V-table-Win
ON F5 OF item-tab.it-codigo IN FRAME f-main /* Item */
DO:
  
    {include/zoomvar.i &prog-zoom=inzoom/z02in172.w
                       &campo=item-tab.it-codigo
                       &campozoom=it-codigo}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-tab.it-codigo V-table-Win
ON LEAVE OF item-tab.it-codigo IN FRAME f-main /* Item */
DO:
if item-tab.it-codigo:modified in frame {&frame-name} then do:
    find item where item.it-codigo = input frame {&frame-name} item-tab.it-codigo NO-LOCK NO-ERROR.
    if not available item then do:
        find item-fornec use-index it-forn where item-fornec.item-do-forn = input frame {&frame-name} item-tab.it-codigo and
                                                 item-fornec.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
        if available item-fornec then do:
            find item where item.it-codigo = item-fornec.it-codigo NO-LOCK NO-ERROR.
            if not available item then do: 
               {utp/ut-field.i mgind item it-codigo 1}
                run utp/ut-msgs.p (input "show",
                                   input 56,
                                   input return-value).
                apply "entry" to item-tab.it-codigo in frame {&frame-name}.
                return no-apply.
            end.
        end.
        else do:  
           {utp/ut-field.i mgind item it-codigo 1}
            run utp/ut-msgs.p (input "show",
                               input 56,
                               input return-value).
            apply "entry" to item-tab.it-codigo in frame {&frame-name}.
            return no-apply.
        end.
    end.
    display item.it-codigo @ item-tab.it-codigo with frame {&frame-name}.                                         
    
    find item-fornec where item-fornec.it-codigo = item.it-codigo and
                           item-fornec.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    assign c-descricao = item.desc-item.
    display c-descricao with frame {&frame-name}.
    display item.un when not available item-fornec @ c-un with frame {&frame-name}.
    display item-fornec.unid-med-for when available item-fornec @ c-un with frame {&frame-name}.
    
    /****
    if item.aliquota-ipi > 0 then
        display item.aliquota-ipi @ item-tab.aliquota-ipi with frame {&frame-name}.
    else do:
        find classif-fisc where classif-fisc.class-fiscal = item.class-fiscal no-error.
        if available classif-fisc then do:
            display classif-fisc.aliquota-ipi @ item-tab.aliquota-ipi with frame {&frame-name}.
        end.
    end.
    ****/
    
    assign item-tab.aliquota-icm:screen-value in frame {&frame-name}  = string(tb-pr-cc.aliquota-icm) .
end.

assign item-tab.it-codigo:modified in frame {&frame-name} = no.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-tab.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-tab.it-codigo IN FRAME f-main /* Item */
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

  if item-tab.it-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.  
     
  /************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "item-tab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-tab"}

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

    if adm-new-record then 
         assign de-desconto = 0.

    disp de-desconto with frame {&FRAME-NAME}.

    if r-row-table = ? then display 0 @ item-tab.desco-quant with frame {&frame-name}.

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
  
  /* Ponha na pi-validate todas as valida‡äes */
  
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  
   if input frame {&frame-name} item-tab.pr-item = 0 then do:  
        {utp/ut-liter.i Pre‡o_do * L} 
        assign c-label = return-value.
        run utp/ut-msgs.p (input "show",
                           input 8630,
                           input return-value + "~~" + c-label).
        apply "entry" to item-tab.pr-item in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

  

  find b-item-tab where 
     &if defined(bf_mat_contratos) &then
     b-item-tab.cod-emitente = tb-pr-cc.cod-emitente and
     &else
     b-item-tab.nome-abrev = tb-pr-cc.nome-abrev and
     &endif
     b-item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag and
     b-item-tab.nr-tab = tb-pr-cc.nr-tab and
     b-item-tab.it-codigo = input frame {&frame-name} item-tab.it-codigo and
     b-item-tab.quant-min = input frame {&frame-name} item-tab.quant-min AND
     b-item-tab.cod-estabel = tb-pr-cc.cod-estabel AND
     b-item-tab.mo-codigo = tb-pr-cc.mo-codigo
     no-lock no-error.
      if  avail b-item-tab and adm-new-record then do:
           
              run utp/ut-msgs.p (input "show",
                              input 1409,
                              input "").
           apply "entry" to item-tab.quant-min in frame {&frame-name}.
           RETURN 'ADM-ERROR':U.
       end.                          


  find b-item-tab where 
     &if defined(bf_mat_contratos) &then
     b-item-tab.cod-emitente = tb-pr-cc.cod-emitente and
     &else
     b-item-tab.nome-abrev = tb-pr-cc.nome-abrev and
     &endif
     b-item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag and
     b-item-tab.nr-tab = tb-pr-cc.nr-tab and
     b-item-tab.it-codigo = input frame {&frame-name} item-tab.it-codigo and
     b-item-tab.quant-min = input frame {&frame-name} item-tab.quant-min AND
     b-item-tab.cod-estabel = tb-pr-cc.cod-estabel AND 
     b-item-tab.mo-codigo = tb-pr-cc.mo-codigo
     no-lock no-error.   
     if  avail b-item-tab and  not adm-new-record and item-tab.quant-min:modified in frame {&frame-name} = yes
     and item-tab.quant-min <> input frame {&frame-name} item-tab.quant-min  then do:
                    run utp/ut-msgs.p (input "show",
                              input 1409,
                              input "").
           apply "entry" to item-tab.quant-min in frame {&frame-name}.
           RETURN 'ADM-ERROR':U.
       end.                          


  /* Dispatch standard ADM method.                             */
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
  RETURN 'ADM-ERROR':U.

     
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  
    
 
  
   
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  find tb-pr-cc where rowid(tb-pr-cc) = v-row-parent NO-LOCK NO-ERROR.
  if  available tb-pr-cc then do:
        assign item-tab.nome-abrev   = tb-pr-cc.nome-abrev
               item-tab.nr-tab       = tb-pr-cc.nr-tab
               item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
               item-tab.cod-estabel  = tb-pr-cc.cod-estabel
               item-tab.mo-codigo    = tb-pr-cc.mo-codigo.
        &if defined(bf_mat_contratos) &then
        assign item-tab.cod-emitente = tb-pr-cc.cod-emitente
               item-tab.dt-inicio    = tb-pr-cc.dt-inicio.
        &endif
  end.

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
   
   
/* Code placed here will execute AFTER standard behavior.    */

if  not adm-new-record and
    avail item-tab     and
    avail tb-pr-cc     then do:
    
    find item where item.it-codigo = item-tab.it-codigo no-lock no-error.
    find first emitente where emitente.nome-abrev = tb-pr-cc.nome-abrev no-lock no-error.
    
    display item.it-codigo @ item-tab.it-codigo with frame {&frame-name}.                                         
    find item-fornec where item-fornec.it-codigo = item.it-codigo and
                           item-fornec.cod-emitente = emitente.cod-emitente no-lock no-error.
    assign c-descricao = item.desc-item.
    display c-descricao with frame {&frame-name}.
    
    if  avail item-fornec then
        display item-fornec.unid-med-for @ c-un with frame {&frame-name}.
    else
        display item.un @ c-un with frame {&frame-name}.
    
    apply "leave" to item-tab.desco-quant in frame {&frame-name}.

end.
 

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
    
find first param-compra no-lock no-error.
if  avail param-compra then
    assign item-tab.aliquota-icm:sensitive in frame {&frame-name} = param-compra.utiliza-icm .
    
 
if  not adm-new-record and
    r-row-table <> ? then do:
    
    disable item-tab.it-codigo with frame {&frame-name}.
    find item where item.it-codigo = input frame {&frame-name} item-tab.it-codigo no-lock no-error.
    if not available item then do:
        find item-fornec use-index it-forn where item-fornec.item-do-forn = input frame {&frame-name} item-tab.it-codigo and
                                                 item-fornec.cod-emitente = emitente.cod-emitente no-lock no-error.
        if available item-fornec then do:
            find item where item.it-codigo = item-fornec.it-codigo no-lock no-error.
        end.
    end.
    else
        assign c-descricao = item.desc-item.
end.
    
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


  find tb-pr-cc where rowid(tb-pr-cc) = v-row-parent NO-LOCK NO-ERROR.
  find first emitente where emitente.nome-abrev = tb-pr-cc.nome-abrev no-lock no-error.

  {utp/ut-liter.i Total_Desconto * C}
  assign de-desconto:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Grupo_Corre‡äes * r}
  assign item-tab.int-1:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind item un 1}
  assign c-un:label in frame {&frame-name} = return-value.
  
     
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-row V-table-Win 
PROCEDURE pi-passa-row :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-row-table as rowid no-undo.
    assign r-row-table = p-row-table.

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "item-tab"}

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

