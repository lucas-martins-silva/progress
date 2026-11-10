&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i IM0031B-V01 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0031b-v01 MIM}
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
{cdp/cdcfgmat.i} /* include pre-processadores magnus */

/* Local Variable Definitions ---                                       */
def var r-chave     as rowid no-undo.
def var r-chave-pai as rowid no-undo.
def var c-param     as char no-undo.
def var c-return    as char no-undo.

def var h-bocx100 as handle no-undo.
def var h-boin176 as handle no-undo.

{include/boerrtab.i}
{cxbo/bocx100.i tt-item-doc-est-cex}
{cxbo/bocx100.i tt-item-doc-est-cex-bas}
{inbo/boin176.i tt-item-doc-est}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold i-cod-emitente-desp i-cod-desp ~
de-val-desp 
&Scoped-Define DISPLAYED-OBJECTS i-cod-emitente-desp c-desc-emitente ~
i-cod-desp c-desc-desp-imp de-val-desp 

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
DEFINE VARIABLE c-desc-desp-imp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-emitente AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-desp AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "val-desp" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-desp AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "cod-desp" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-desp AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "cod-emitente-desp" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-cod-emitente-desp AT ROW 1.25 COL 25 COLON-ALIGNED
     c-desc-emitente AT ROW 1.25 COL 38 COLON-ALIGNED NO-LABEL
     i-cod-desp AT ROW 2.25 COL 25 COLON-ALIGNED
     c-desc-desp-imp AT ROW 2.25 COL 35 COLON-ALIGNED NO-LABEL
     de-val-desp AT ROW 3.25 COL 25 COLON-ALIGNED
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 3.5
         WIDTH              = 80.
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

/* SETTINGS FOR FILL-IN c-desc-desp-imp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-emitente IN FRAME f-main
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

&Scoped-define SELF-NAME i-cod-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-desp V-table-Win
ON LEAVE OF i-cod-desp IN FRAME f-main /* cod-desp */
DO:
    def var h-bocx095 as handle no-undo.
    def var c-descricao like desp-imp.descricao no-undo.
    
    assign input frame {&frame-name} i-cod-desp.    
    run cxbo/bocx095.p persistent set h-bocx095.
    run findCodigo in h-bocx095(input i-cod-desp,output c-return).
    if c-return = "" then
        run getCharfield in h-bocx095(input "descricao",output c-descricao).
    assign c-desc-desp-imp = c-descricao.
    delete procedure h-bocx095.
    disp c-desc-desp-imp with frame {&frame-name}.                            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-emitente-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente-desp V-table-Win
ON LEAVE OF i-cod-emitente-desp IN FRAME f-main /* cod-emitente-desp */
DO:
    def var h-boad098 as handle no-undo.
    def var c-nome-abrev like emitente.nome-abrev no-undo.
    
    assign input frame {&frame-name} i-cod-emitente-desp.    
    run adbo/boad098.p persistent set h-boad098.
    run findCodigo in h-boad098(input i-cod-emitente-desp,output c-return).
    if c-return = "" then
        run getCharfield in h-boad098(input "nome-abrev",output c-nome-abrev).
    assign c-desc-emitente = c-nome-abrev.
    delete procedure h-boad098.
    disp c-desc-emitente with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/****************************  Main Block  ****************************/

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES *************************/
  
  {utp/ut-field.i mgcex item-doc-est-cex cod-emitente-desp 1}
  assign i-cod-emitente-desp:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgcex item-doc-est-cex cod-desp 1}
  assign i-cod-desp:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgcex item-doc-est-cex val-desp 1}
  assign de-val-desp:label in frame {&frame-name} = return-value.

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

  As valida‡äes referente ao registro e a cria‡Æo do registro ‚ feita pela proce-
  dure ValidateCreate na BOCX030 (Item-doc-est-cex)
  
------------------------------------------------------------------------------*/
    def var c-serie-docto like item-doc-est.serie-docto no-undo.
    def var c-nro-docto like item-doc-est.nro-docto no-undo.
    def var c-nat-operacao like item-doc-est.nat-operacao no-undo.
    def var i-cod-emitente like item-doc-est.cod-emitente no-undo.
    def var i-sequencia like item-doc-est.sequencia no-undo.
    
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.    
    
    run cxbo/bocx100.p persistent set h-bocx100.  
    case c-param:
        when "add":U then do:      
            for each tt-item-doc-est-cex:
                delete tt-item-doc-est-cex.
            end.
            run inbo/boin176.p persistent set h-boin176.
            run findRowid in h-boin176(input r-chave-pai).
            run getCharfield in h-boin176(input "serie-docto":U ,output c-serie-docto).
            run getCharfield in h-boin176(input "nro-docto":U   ,output c-nro-docto).
            run getCharfield in h-boin176(input "nat-operacao":U,output c-nat-operacao).
            run getIntfield  in h-boin176(input "cod-emitente":U,output i-cod-emitente).
            run getIntfield  in h-boin176(input "sequencia":U   ,output i-sequencia).
            delete procedure h-boin176.
            create tt-item-doc-est-cex.
            assign tt-item-doc-est-cex.serie-docto  = c-serie-docto
                &if defined(bf-mat-comex) &then
                   tt-item-doc-est-cex.nro-docto    = string(c-nro-docto)
                &else
                   tt-item-doc-est-cex.nro-docto    = c-nro-docto                
                &endif                   
                   tt-item-doc-est-cex.cod-emitente = i-cod-emitente
                   tt-item-doc-est-cex.nat-operacao = c-nat-operacao
                   tt-item-doc-est-cex.sequencia    = i-sequencia.               
        end.
        when "mod":U then do:
            run findRowid in h-bocx100(input r-chave).
            run getCurrent in h-bocx100(output table tt-item-doc-est-cex).
            find first tt-item-doc-est-cex no-error.
        end.
        when "add1":U or 
        when "mod1":U then do:
            find first tt-item-doc-est-cex no-error.        
        end.
    end case.
    
    assign tt-item-doc-est-cex.cod-emitente-desp = integer(i-cod-emitente-desp:screen-value in frame {&frame-name})
           tt-item-doc-est-cex.cod-desp          = integer(i-cod-desp:screen-value in frame {&frame-name})
           tt-item-doc-est-cex.val-desp          = decimal(de-val-desp:screen-value in frame {&frame-name}).           
           
    case c-param:
        when "add":U then do:
            run validateCreate in h-bocx100(input table tt-item-doc-est-cex,
                                            output table tt-bo-erro,                                            
                                            output r-chave).
            if not can-find(first tt-bo-erro) then
                assign tt-item-doc-est-cex.r-rowid = r-chave.                                                            
        end.                                            
        when "mod":U then
            run validateUpdate in h-bocx100(input table tt-item-doc-est-cex,
                                            input r-chave, 
                                            output table tt-bo-erro).
        when "add1":U then do:
            find tt-item-doc-est-cex-bas 
                where tt-item-doc-est-cex-bas.serie-docto = tt-item-doc-est-cex.serie-docto
                  and tt-item-doc-est-cex-bas.nro-docto   = tt-item-doc-est-cex.nro-docto
                  and tt-item-doc-est-cex-bas.cod-emitente = tt-item-doc-est-cex.cod-emitente
                  and tt-item-doc-est-cex-bas.nat-operacao = tt-item-doc-est-cex.nat-operacao
                  and tt-item-doc-est-cex-bas.sequencia    = tt-item-doc-est-cex.sequencia
                  and tt-item-doc-est-cex-bas.cod-desp     = tt-item-doc-est-cex.cod-desp
                  no-error.
            if avail tt-item-doc-est-cex-bas then do:
                create tt-bo-erro.
                {utp/ut-table.i mgcex item-doc-est-cex 1}
                assign tt-bo-erro.parametros = return-value.
                run utp/ut-msgs.p (input "msg":U,
                                   input 8,
                                   input return-value).
                assign tt-bo-erro.i-sequen = 1
                       tt-bo-erro.cd-erro  = 8
                       tt-bo-erro.mensagem = return-value.                                   
            end.
            else 
                run validateCreateDesp in h-bocx100(input table tt-item-doc-est-cex,
                                                    output table tt-bo-erro).        
        end.
        when "mod1":U then do:
            run validateCreateDesp in h-bocx100(input table tt-item-doc-est-cex,
                                                output table tt-bo-erro).
        end.                                                               
    end case.
    delete procedure h-bocx100.
      
    find first tt-bo-erro no-error.
    if avail tt-bo-erro then do:
        run utp/ut-msgs.p (input "show",
                           input 17242,
                           input tt-bo-erro.mensagem).
        return "adm-error".                         
    end.
    else
        return "".
    
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

  if valid-handle(h-bocx100) then 
    delete procedure h-bocx100.

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
  
  find first tt-item-doc-est-cex no-error.
  if avail tt-item-doc-est-cex then do:
    assign i-cod-emitente-desp = tt-item-doc-est-cex.cod-emitente-desp
           i-cod-desp          = tt-item-doc-est-cex.cod-desp
           de-val-desp         = tt-item-doc-est-cex.val-desp.
  end.  
  
  disp i-cod-emitente-desp
       i-cod-desp 
       de-val-desp
       with frame {&frame-name}.
       
  apply "leave" to i-cod-emitente-desp in frame {&frame-name}.
  apply "leave" to i-cod-desp in frame {&frame-name}.
       
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
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit V-table-Win 
PROCEDURE local-exit :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'exit':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ).    

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-temp-tables V-table-Win 
PROCEDURE pi-limpa-temp-tables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  for each tt-bo-erro:
    delete tt-bo-erro.
  end.
  
  for each tt-item-doc-est-cex:
    delete tt-item-doc-est-cex.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-principal V-table-Win 
PROCEDURE pi-principal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter p-chave as rowid no-undo.
  def input parameter p-chave-pai as rowid no-undo.
  def input parameter p-param as char no-undo.
  def input parameter table for tt-item-doc-est-cex.
  def input parameter table for tt-item-doc-est-cex-bas.  
  
  assign r-chave     = p-chave
         r-chave-pai = p-chave-pai
         c-param     = p-param.
         
  if c-param = "add":U or 
     c-param = "add1":U then do:
    find first tt-item-doc-est-cex no-error.
    if avail tt-item-doc-est-cex then do:
        assign tt-item-doc-est-cex.cod-desp = 0
               tt-item-doc-est-cex.cod-emitente-desp = 0
               tt-item-doc-est-cex.mo-codigo = 0
               tt-item-doc-est-cex.val-desp = 0.
    end.        
  end.         

  if c-param = "mod":U then do:
        run cxbo/bocx100.p persistent set h-bocx100.
        run findRowid in h-bocx100 (input r-chave).
        run getCurrent in h-bocx100 (output table tt-item-doc-est-cex).
        delete procedure h-bocx100.
  end.
  
  if c-param = "mod" or
     c-param = "mod1" then
    assign i-cod-emitente-desp:sensitive in frame {&frame-name} = no
           i-cod-desp:sensitive in frame {&frame-name}          = no.
  
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-TT V-table-Win 
PROCEDURE pi-retorna-TT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter table for tt-item-doc-est-cex.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
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


