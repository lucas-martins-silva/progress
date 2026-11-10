&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i IM0010C-V01 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0010C-V01 MIM}
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
def new global shared var i-global-cod-emitente like emitente.cod-emitente no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

{include/boerrtab.i}
{cxbo/bocx085.i tt-cotacao-item-cex}

def new global shared var is-cod-itiner as integer no-undo.
def var c-return as char no-undo.
def var h-bocx085 as handle no-undo.

{cdp/cdcfgmat.i}

&if "{&bf_mat_versao_ems}" >= "2.062" &then
def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)"
    field c-param    as char .
&endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS i-cod-cond-pag de-taxa-financ de-perc-taxa ~
i-nr-dias-taxa de-perc-descto c-contato i-cod-comprado i-cod-pto-contr ~
de-val-desp i-dias-validade log-recalc-val rt-key 
&Scoped-Define DISPLAYED-OBJECTS i-cod-cond-pag c-desc-cond-pagto ~
de-taxa-financ de-perc-taxa i-nr-dias-taxa de-perc-descto c-contato ~
i-cod-comprado i-cod-pto-contr da-data-cotacao-desp de-val-desp ~
da-data-atualiz c-hora-atualiz i-dias-validade log-recalc-val 

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
DEFINE VARIABLE c-contato AS CHARACTER FORMAT "X(12)":U 
     LABEL "contato" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cond-pagto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-hora-atualiz AS CHARACTER FORMAT "X(8)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-atualiz AS DATE FORMAT "99/99/9999":U 
     LABEL "data-atualiz" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-cotacao-desp AS DATE FORMAT "99/99/9999":U 
     LABEL "data-cotacao-desp" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-descto AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "perc-descto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-taxa AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "perc-taxa" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-desp AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999":U INITIAL 0 
     LABEL "val-desp" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-comprado AS CHARACTER FORMAT "X(12)":U 
     LABEL "cod-comprado" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-cond-pag AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "cod-cond-pag" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-pto-contr AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "cod-pto-contr" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-dias-validade AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "dias-validade" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-dias-taxa AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "nr-dias" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 7.25.

DEFINE VARIABLE de-taxa-financ AS LOGICAL INITIAL no 
     LABEL "taxa-financ" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE log-recalc-val AS LOGICAL INITIAL no 
     LABEL "Recalcula Valor" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.14 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-cod-cond-pag AT ROW 1.25 COL 18 COLON-ALIGNED
     c-desc-cond-pagto AT ROW 1.25 COL 23 COLON-ALIGNED NO-LABEL
     de-taxa-financ AT ROW 2.25 COL 20
     de-perc-taxa AT ROW 2.25 COL 53 COLON-ALIGNED
     i-nr-dias-taxa AT ROW 2.25 COL 80 COLON-ALIGNED
     de-perc-descto AT ROW 3.25 COL 18 COLON-ALIGNED
     c-contato AT ROW 3.25 COL 53 COLON-ALIGNED
     i-cod-comprado AT ROW 4.25 COL 18 COLON-ALIGNED
     i-cod-pto-contr AT ROW 4.25 COL 53 COLON-ALIGNED
     da-data-cotacao-desp AT ROW 5.25 COL 18 COLON-ALIGNED
     de-val-desp AT ROW 5.25 COL 53 COLON-ALIGNED
     da-data-atualiz AT ROW 6.25 COL 18 COLON-ALIGNED
     c-hora-atualiz AT ROW 6.25 COL 32 COLON-ALIGNED NO-LABEL
     i-dias-validade AT ROW 6.25 COL 53 COLON-ALIGNED
     log-recalc-val AT ROW 7.25 COL 19.86
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 7.38
         WIDTH              = 89.
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

/* SETTINGS FOR FILL-IN c-desc-cond-pagto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-hora-atualiz IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-data-atualiz IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-data-cotacao-desp IN FRAME f-main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME i-cod-comprado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-comprado V-table-Win
ON F5 OF i-cod-comprado IN FRAME f-main /* cod-comprado */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in055.w
                      &campo=i-cod-comprado
                      &campozoom=cod-comprado}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-comprado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-comprado IN FRAME f-main /* cod-comprado */
DO:
  apply 'F5' to self in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag V-table-Win
ON F5 OF i-cod-cond-pag IN FRAME f-main /* cod-cond-pag */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad039.w
                     &campo=i-cod-cond-pag
                     &campozoom=cod-cond-pag
                     &campo2=c-desc-cond-pagto
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag V-table-Win
ON LEAVE OF i-cod-cond-pag IN FRAME f-main /* cod-cond-pag */
DO:
    def var h-boad039 as handle no-undo.    
    def var c-descricao like cond-pagto.descricao no-undo.
    
    assign input frame {&frame-name} i-cod-cond-pag.
    run adbo/boad039.p persistent set h-boad039.
    run findCodigo in h-boad039 (input i-cod-cond-pag,output c-return).
    if c-return = "" then do:
        run getCharfield in h-boad039(input "descricao",output c-descricao).
        assign c-desc-cond-pagto = c-descricao.
    end.        
    delete procedure h-boad039.
    
    if i-cod-cond-pag = 0 then do:
      {utp/ut-liter.i Condi‡Æo_espec¡fica * L}
      assign c-desc-cond-pagto = return-value.
    end.
    
    disp c-desc-cond-pagto with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-cond-pag IN FRAME f-main /* cod-cond-pag */
DO:
  apply 'F5' to self in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-pto-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-pto-contr V-table-Win
ON F5 OF i-cod-pto-contr IN FRAME f-main /* cod-pto-contr */
DO:
  {include/zoomvar.i &prog-zoom=cxzoom/z01cx120.w
                      &campo=i-cod-pto-contr
                      &campozoom=cod-pto-contr}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-pto-contr V-table-Win
ON LEFT-MOUSE-DBLCLICK OF i-cod-pto-contr IN FRAME f-main /* cod-pto-contr */
DO:
  apply "f5" to self in frame {&frame-name}.
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
  
  {utp/ut-field.i mgcex cotacao-item-cex cod-cond-pag 1}
  assign i-cod-cond-pag:label in frame {&Frame-name} = return-value.
  if i-cod-cond-pag:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.    
  
  {utp/ut-field.i mgcex cotacao-item-cex taxa-financ 1}
  assign de-taxa-financ:label in frame {&Frame-name} = return-value.
  
  {utp/ut-field.i mgcex cotacao-item-cex perc-taxa 1}
  assign de-perc-taxa:label in frame {&Frame-name} = return-value.
  
  {utp/ut-field.i mgcex cotacao-item-cex nr-dias-taxa 1}    
  assign i-nr-dias-taxa:label in frame {&Frame-name} = return-value.
  
  {utp/ut-field.i mgcex cotacao-item-cex perc-descto 1}  
  assign de-perc-descto:label in frame {&Frame-name} = return-value.
  
  {utp/ut-field.i mgcex cotacao-item-cex contato 1}
  assign c-contato:label in frame {&Frame-name} = return-value.
    
  {utp/ut-field.i mgcex cotacao-item-cex cod-comprado 1}
  assign i-cod-comprado:label in frame {&Frame-name} = return-value.
  if i-cod-comprado:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.      
  
  {utp/ut-field.i mgcex cotacao-item-cex val-desp 1}
  assign de-val-desp:label in frame {&Frame-name} = return-value.
  
  {utp/ut-field.i mgcex cotacao-item-cex data-atualiz 1}          
  assign da-data-atualiz:label in frame {&Frame-name} = return-value.
    
  {utp/ut-field.i mgcex cotacao-item-cex dias-validade 1}  
  assign i-dias-validade:label in frame {&Frame-name} = return-value.
  
  {utp/ut-field.i mgcex cotacao-item-cex data-cotacao-desp 1}  
  assign da-data-cotacao-desp:label in frame {&Frame-name} = return-value.

  {utp/ut-field.i mgcex cotacao-item-cex cod-pto-contr 1}  
  assign i-cod-pto-contr:label in frame {&Frame-name} = return-value.
  if i-cod-pto-contr:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE limpa-temp-tables V-table-Win 
PROCEDURE limpa-temp-tables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  for each tt-cotacao-item-cex:
    delete tt-cotacao-item-cex.  
  end.

  for each tt-bo-erro: 
    delete tt-bo-erro.
  end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------

  A procedure tem por fun‡Æo criar ou modificar os registros da tabela cotacao-item-cex,
  todas as informa‡äes referente a tabela sÆo gravadas na temp-table que envia os dados para
  as procedure ValidateCreate e ValidateUpdate que irÆo atualizar os valores na tabela.  

------------------------------------------------------------------------------*/        
    def input parameter p-chave as rowid no-undo.
    def input parameter p-param as char no-undo.
    def input parameter table for tt-cotacao-item-cex.
    def output parameter p-chave-criada as rowid no-undo.
    
    
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    
    
    run cxbo/bocx085.p persistent set h-bocx085.
    
    assign input frame {&frame-name} i-cod-cond-pag
                                     de-taxa-financ
                                     i-nr-dias-taxa
                                     de-perc-taxa
                                     de-perc-descto
                                     c-contato
                                     i-cod-comprado
                                     i-cod-pto-contr
                                     de-val-desp
                                     da-data-cotacao-desp
                                     i-dias-validade.
    if p-param = "mod" then do:
        for each tt-cotacao-item-cex:
            delete tt-cotacao-item-cex.
        end.
        run findRowid in h-bocx085(input p-chave).
        run getCurrent in h-bocx085(output table tt-cotacao-item-cex).
    end.
    
    find first tt-cotacao-item-cex no-error.                          
    if avail tt-cotacao-item-cex then      
        assign tt-cotacao-item-cex.cod-cond-pag  = i-cod-cond-pag
               tt-cotacao-item-cex.taxa-financ   = de-taxa-financ
               tt-cotacao-item-cex.nr-dias-taxa  = i-nr-dias-taxa
               tt-cotacao-item-cex.perc-taxa     = de-perc-taxa
               tt-cotacao-item-cex.perc-descto   = de-perc-descto
               tt-cotacao-item-cex.contato       = c-contato
               tt-cotacao-item-cex.cod-comprado  = i-cod-comprado
               tt-cotacao-item-cex.cod-pto-contr = i-cod-pto-contr
               tt-cotacao-item-cex.val-desp      = de-val-desp
               tt-cotacao-item-cex.data-cotacao-desp = da-data-cotacao-desp
               tt-cotacao-item-cex.dias-validade = i-dias-validade.

    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
         IF log-recalc-val:SENSITIVE IN FRAME f-main THEN 
             ASSIGN tt-cotacao-item-cex.log-recalc-val = INPUT FRAME f-main log-recalc-val.
                                                    
    &ENDIF
   
    if p-param = "add" THEN DO:
      RUN validateCreate in h-bocx085 (input table tt-cotacao-item-cex,
                                       output table tt-bo-erro,
                                       output p-chave-criada).
      
    END.
    else          
      RUN validateUpdate in h-bocx085(input table tt-cotacao-item-cex,
                                      input p-chave,
                                      output table tt-bo-erro).             
    delete procedure h-bocx085.                                      
    

    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN

        FOR EACH tt-erro:
            DELETE tt-erro.
        END.
    
        FOR EACH tt-bo-erro:
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = tt-bo-erro.i-sequen 
                   tt-erro.cd-erro  = tt-bo-erro.cd-erro
                   tt-erro.mensagem = tt-bo-erro.mensagem
                   tt-erro.c-param  = tt-bo-erro.parametros.
        END.
    
        IF  CAN-FIND(FIRST tt-erro) THEN
            RUN cdp/cd0669.w(INPUT TABLE tt-erro).
    
        IF  CAN-FIND(FIRST tt-bo-erro
                     WHERE tt-bo-erro.errorSubType <> "INFORMATION":U
                       AND tt-bo-erro.errorSubType <> "WARNING":U) THEN
            RETURN "adm-error":U.
        ELSE 
            RETURN "".

    &ELSE
    
        find first tt-bo-erro no-error.
        if avail tt-bo-erro then do:
            run utp/ut-msgs.p (input "show",
                               input tt-bo-erro.cd-erro,
                               input tt-bo-erro.parametros).
            return "adm-error".                           
        end.
        else return "".

    &ENDIF
    
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
  
  if valid-handle(h-bocx085) then
    delete procedure h-bocx085.  

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
  
  find first tt-cotacao-item-cex no-error.
  if avail tt-cotacao-item-cex then do:  
    assign i-cod-cond-pag = tt-cotacao-item-cex.cod-cond-pag
           de-taxa-financ = tt-cotacao-item-cex.taxa-financ
           i-nr-dias-taxa = tt-cotacao-item-cex.nr-dias-taxa
           de-perc-taxa = tt-cotacao-item-cex.perc-taxa
           de-perc-descto = tt-cotacao-item-cex.perc-descto
           c-contato   = tt-cotacao-item-cex.contato
           i-cod-comprado = tt-cotacao-item-cex.cod-comprado
           de-val-desp = tt-cotacao-item-cex.val-desp
           da-data-atualiz = tt-cotacao-item-cex.data-atualiz
           c-hora-atualiz = tt-cotacao-item-cex.hora-atualiz
           i-dias-validade = tt-cotacao-item-cex.dias-validade
           da-data-cotacao-desp = tt-cotacao-item-cex.data-cotacao-desp
           i-cod-pto-contr = tt-cotacao-item-cex.cod-pto-contr.               
           
    /* Grava Itiner rio para inicializa‡Æo da Pesquisa do Ponto de Controle */
    assign is-cod-itiner = tt-cotacao-item-cex.cod-itiner.
                           
  end.
  
  disp i-cod-cond-pag
       de-taxa-financ 
       i-nr-dias-taxa
       de-perc-taxa 
       de-perc-descto 
       c-contato 
       i-cod-comprado
       de-val-desp
       da-data-atualiz
       c-hora-atualiz
       i-dias-validade 
       c-desc-cond-pagto 
       i-cod-pto-contr
       da-data-cotacao-desp with frame {&frame-name}.
  
  apply "leave" to i-cod-cond-pag in frame {&frame-name}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa V-table-Win 
PROCEDURE pi-inicializa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  def input parameter p-chave as rowid no-undo.
  def input parameter p-param as char no-undo.
  def input parameter table for tt-cotacao-item-cex.  
  
  run cxbo/bocx085.p persistent set h-bocx085.

  &IF '{&BF_MAT_VERSAO_EMS}' < '2.062' &THEN
      ASSIGN log-recalc-val:VISIBLE IN FRAME f-main = NO.
  &ENDIF 
  
  if p-param = "add" then do:
    run createFornecedor in h-bocx085(input-output table tt-cotacao-item-cex,
                                      output table tt-bo-erro).
    find first tt-bo-erro no-error.
    if avail tt-bo-erro then do:
        run utp/ut-msgs.p(input "show",
                          input tt-bo-erro.cd-erro,
                          input tt-bo-erro.parametros).
    end.                                          

    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
       ASSIGN log-recalc-val:SENSITIVE IN FRAME f-main = NO.
    &ENDIF
  end.
  else do:
    run findRowid in h-bocx085(input p-chave).
    run getCurrent in h-bocx085(output table tt-cotacao-item-cex).

    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
       FIND FIRST tt-cotacao-item-cex NO-ERROR.
       ASSIGN log-recalc-val = tt-cotacao-item-cex.log-recalc-val.
       DISP log-recalc-val WITH FRAME f-main.
    &ENDIF

  end.  
  
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  delete procedure h-bocx085.

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

