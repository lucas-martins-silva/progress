&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i IM0010B-V01 2.00.00.008}  /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0010B-V01 MIM}
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

{include/boerrtab.i}
{cxbo/bocx085.i tt-cotacao-item-cex}
{cxbo/bocx085.i tt-cotacao-item-cex-tmp}

   
def var h-bocx085   as handle no-undo.
def var h-boad098   as handle no-undo.
def var h-bocx095   as handle no-undo.
def var h-boun005   as handle no-undo. 



def var c-param     as char   no-undo.
def var r-chave     as rowid  no-undo.
def var r-chave-pai as rowid  no-undo.
def var c-return    as char   no-undo.


{cdp/cdcfgmat.i}
&if "{&bf_mat_versao_ems}" >= "2.05" &then
    def var i-tp-despesa as integer no-undo.
    def var h-boad259   as handle no-undo.
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
&Scoped-Define ENABLED-OBJECTS text-1 i-cod-emitente c-nome-abrev c-cgc ~
i-cod-desp i-ctp-despesa c-desc-tipo-despesa c-nr-tab i-mo-codigo text-2 ~
rt-key 
&Scoped-Define DISPLAYED-OBJECTS text-1 i-cod-emitente c-nome-abrev c-cgc ~
i-cod-desp tt-desc-desp-imp i-ctp-despesa c-desc-tipo-despesa c-nr-tab ~
i-mo-codigo c-moeda text-2 

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
DEFINE VARIABLE c-cgc AS CHARACTER FORMAT "X(256)":U 
     LABEL "cgc" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tipo-despesa LIKE tipo-rec-desp.descricao
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(256)":U 
     LABEL "nome-abrev" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-tab AS CHARACTER FORMAT "X(10)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-desp AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "cod-desp" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "cod-emitente" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-ctp-despesa AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Tipo Despesa" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-mo-codigo AS INTEGER FORMAT ">9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE text-2 AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE tt-desc-desp-imp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     text-1 AT ROW 3.17 COL 56.57 RIGHT-ALIGNED NO-LABEL
     i-cod-emitente AT ROW 1.17 COL 17.29 COLON-ALIGNED
     c-nome-abrev AT ROW 2.17 COL 17.29 COLON-ALIGNED
     c-cgc AT ROW 3.17 COL 17.29 COLON-ALIGNED
     i-cod-desp AT ROW 1.17 COL 56.14 COLON-ALIGNED
     tt-desc-desp-imp AT ROW 1.17 COL 65.14 COLON-ALIGNED NO-LABEL
     i-ctp-despesa AT ROW 2.17 COL 56.14 COLON-ALIGNED HELP
          "Indicar que tipo de despesa para o Fluxo de Caixa"
     c-desc-tipo-despesa AT ROW 2.17 COL 61.14 COLON-ALIGNED NO-LABEL
     c-nr-tab AT ROW 3.17 COL 56.14 COLON-ALIGNED NO-LABEL
     i-mo-codigo AT ROW 4.17 COL 56.14 COLON-ALIGNED NO-LABEL
     c-moeda AT ROW 4.17 COL 61.14 COLON-ALIGNED NO-LABEL
     text-2 AT ROW 4.17 COL 56.57 RIGHT-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 4.25
         WIDTH              = 88.57.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-tipo-despesa IN FRAME f-main
   LIKE = mgadm.tipo-rec-desp.descricao EXP-LABEL EXP-SIZE              */
/* SETTINGS FOR FILL-IN c-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN text-1 IN FRAME f-main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN text-2 IN FRAME f-main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN tt-desc-desp-imp IN FRAME f-main
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

&Scoped-define SELF-NAME c-cgc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cgc V-table-Win
ON F5 OF c-cgc IN FRAME f-main /* cgc */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="i-cod-emitente"
     &campo1="c-nome-abrev"
     &campo2="c-cgc"    
     &campozoom="cod-emitente"
     &campozoom1="nome-abrev"
     &campozoom2="cgc"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cgc V-table-Win
ON LEAVE OF c-cgc IN FRAME f-main /* cgc */
DO:
  assign input frame {&frame-name} c-cgc.
  find emitente where 
      emitente.cgc = c-cgc no-lock no-error.
  if avail emitente then 
    assign c-nome-abrev   = emitente.nome-abrev
           i-cod-emitente = emitente.cod-emitente.
  
  disp c-nome-abrev
       i-cod-emitente with frame {&frame-name}.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cgc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cgc IN FRAME f-main /* cgc */
DO:
  apply 'F5':U to self in frame {&Frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nome-abrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-abrev V-table-Win
ON F5 OF c-nome-abrev IN FRAME f-main /* nome-abrev */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="i-cod-emitente"
     &campo1="c-nome-abrev"
     &campo2="c-cgc"    
     &campozoom="cod-emitente"
     &campozoom1="nome-abrev"
     &campozoom2="cgc"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-abrev V-table-Win
ON LEAVE OF c-nome-abrev IN FRAME f-main /* nome-abrev */
DO:
  find first emitente where 
      emitente.nome-abrev = c-nome-abrev:screen-value in frame {&frame-name} no-lock no-error.
  if avail emitente then 
    assign i-cod-emitente = emitente.cod-emitente
           c-cgc = emitente.cgc.             
  disp i-cod-emitente
       c-cgc with frame {&frame-name}.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-abrev V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-nome-abrev IN FRAME f-main /* nome-abrev */
DO:
  apply 'F5':U to self in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nr-tab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-tab V-table-Win
ON F5 OF c-nr-tab IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom=cxzoom/z01cx075.w
                     &campo=c-nr-tab
                     &campozoom=nr-tab}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-tab V-table-Win
ON LEFT-MOUSE-DBLCLICK OF c-nr-tab IN FRAME f-main
DO:
  apply "f5":U to self in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-desp V-table-Win
ON F5 OF i-cod-desp IN FRAME f-main /* cod-desp */
DO:
  {include/zoomvar.i &prog-zoom=cxzoom/z01cx095.w
                      &campo=i-cod-desp
                      &campozoom=cod-desp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-desp V-table-Win
ON LEAVE OF i-cod-desp IN FRAME f-main /* cod-desp */
DO:
  def var c-descricao like desp-imp.descricao no-undo.
  
  assign input frame {&frame-name} i-cod-desp.
  run findCodigo in h-bocx095(input i-cod-desp,output c-return).
  if c-return = "" then do:
    run getCharfield in h-bocx095(input "descricao":U,output c-descricao).
    assign tt-desc-desp-imp:screen-value in frame {&frame-name} = c-descricao.

    /* Tipo de Despesa */
    &if "{&bf_mat_versao_ems}" >= "2.05" &then
        if valid-handle(h-bocx095) then do:
            run getIntField in h-bocx095(input "tp-despesa":U, output i-tp-despesa).
            if i-tp-despesa <> 0 then
              assign i-ctp-despesa:screen-value in frame {&frame-name} = string(i-tp-despesa).
            else
              if i-cod-emitente <> 0 then do:
                run getIntField in h-boad098(input "tp-desp-padrao":U, output i-tp-despesa).
                assign i-ctp-despesa:screen-value in frame {&frame-name} = string(i-tp-despesa).
              end.
            apply 'leave':U to i-ctp-despesa in frame {&frame-name}.
        end.
     &endif
     /* Fim tipo de despesa */

  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-desp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-desp IN FRAME f-main /* cod-desp */
DO:
  apply 'F5':U to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente V-table-Win
ON F5 OF i-cod-emitente IN FRAME f-main /* cod-emitente */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="i-cod-emitente"
     &campo1="c-nome-abrev"
     &campo2="c-cgc"    
     &campozoom="cod-emitente"
     &campozoom1="nome-abrev"
     &campozoom2="cgc"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente V-table-Win
ON LEAVE OF i-cod-emitente IN FRAME f-main /* cod-emitente */
DO:
    assign input frame {&frame-name} i-cod-emitente.    
    run findCodigo in h-boad098(input i-cod-emitente, output c-return).
    if c-return = "" then do:
        run getCharfield in h-boad098(input "nome-abrev", output c-nome-abrev).
        assign c-nome-abrev:screen-value in frame {&frame-name} = c-nome-abrev.
        run getCharfield in h-boad098(input "cgc", output c-cgc).
        assign c-cgc:screen-value in frame {&frame-name} = c-cgc.                
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-emitente IN FRAME f-main /* cod-emitente */
DO:
  apply 'F5':U to self in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-ctp-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ctp-despesa V-table-Win
ON F5 OF i-ctp-despesa IN FRAME f-main /* Tipo Despesa */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad259.w
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ &campo="i-ctp-despesa"
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ &campozoom="tp-codigo" 
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ &FRAME="f-main"
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ &campo2="c-desc-tipo-despesa"
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ &campozoom2="descricao"
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ &frame2="f-main"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ctp-despesa V-table-Win
ON LEAVE OF i-ctp-despesa IN FRAME f-main /* Tipo Despesa */
DO:
  &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
    if not valid-handle(h-boad259) then
      run adbo/boad259.p persistent set h-boad259.

  /*Busca descri‡Æo do tipo da Despesa */
  {method/referencefields.i 
    &HandleDBOLeave="h-boad259"
    &FindMethod="findCodigo"
    &KeyValue1="i-ctp-despesa:screen-value in frame f-main"
    &FieldName1="descricao"
    &FieldScreen1="c-desc-tipo-despesa"
    &Frame1="f-main"}
   
  &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ctp-despesa V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-ctp-despesa IN FRAME f-main /* Tipo Despesa */
DO:
  apply "F5":U to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-codigo V-table-Win
ON F5 OF i-mo-codigo IN FRAME f-main
DO:
      {include/zoomvar.i &prog-zoom=adzoom/z01ad178.w
                         &campo=i-mo-codigo
                         &campozoom=mo-codigo
                         &campo2=c-moeda
                         &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-codigo V-table-Win
ON LEAVE OF i-mo-codigo IN FRAME f-main
DO:
    assign input frame {&frame-name} 
        i-mo-codigo.
        
    assign c-moeda = "".
    run findCodigo in h-boun005 (input i-mo-codigo, output c-return).
    if c-return = "" then
        run getCharfield in h-boun005 (input "descricao":U, output c-moeda).
    disp c-moeda with frame {&frame-name}.                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-mo-codigo IN FRAME f-main
DO:
  APPLY 'f5':U TO SELF.
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
  
  {utp/ut-field.i mgcex cotacao-item-cex cod-emitente-desp 1}
  assign i-cod-emitente:label in frame {&frame-name} = return-value.
  if i-cod-emitente:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.  
  
  {utp/ut-field.i mgadm emitente nome-abrev 1}
  assign c-nome-abrev:label in frame {&frame-name} = return-value.
  if c-nome-abrev:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.  

  {utp/ut-field.i mgadm emitente cgc 1}
  assign c-cgc:label in frame {&frame-name} = return-value.
  if c-cgc:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.  
  
  {utp/ut-field.i mgcex desp-imp cod-desp 1}
  assign i-cod-desp:label in frame {&frame-name} = return-value.
  if i-cod-desp:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.

  {utp/ut-field.i mgcex tb-pr-cex nr-tab 1}
  assign TEXT-1:screen-value in frame {&frame-name} = return-value + ":".
  if c-nr-tab:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.

  {utp/ut-liter.i Moeda * L }
  assign TEXT-2:screen-value in frame {&frame-name}= return-value + ":".
  if i-mo-codigo:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.

  if i-ctp-despesa:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME {&frame-name} then.

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

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Os dados sÆo gravados na temp-table para que sejam criadas as informa‡äes default 
  do registro atraves das procedure createFornecedor e updateFornecedor.    
------------------------------------------------------------------------------*/
    def input  parameter p-chave as rowid no-undo.
    def input  parameter p-param as char no-undo.
    def input  parameter table for tt-cotacao-item-cex-tmp.    
    def output parameter p-chave-criada as rowid no-undo.    
    
    run cxbo/bocx085.p persistent set h-bocx085.
    
    run limpa-temp-tables.
    
    for each tt-cotacao-item-cex:
        delete tt-cotacao-item-cex.
    end.
    
    assign input frame {&frame-name} i-cod-emitente
                                     i-cod-desp
                                     c-nr-tab
                                     i-mo-codigo
                                     &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
                                       i-ctp-despesa
                                     &ENDIF
                                     .

    
    case p-param:
        when "add1":U then do:
            find first tt-cotacao-item-cex-tmp no-error.
            if avail tt-cotacao-item-cex-tmp then
                assign tt-cotacao-item-cex-tmp.cod-emitente-desp = i-cod-emitente
                       tt-cotacao-item-cex-tmp.cod-desp          = i-cod-desp
                       tt-cotacao-item-cex-tmp.nr-tab            = c-nr-tab
                       tt-cotacao-item-cex-tmp.mo-codigo         = i-mo-codigo
                       &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
                         tt-cotacao-item-cex-tmp.tp-despesa      = i-ctp-despesa
                       &ENDIF
                       .
                       
            run validateInitialize in h-bocx085(input table tt-cotacao-item-cex-tmp,
                                                output table tt-bo-erro).
        end.
        when "add":U then do:
            for each tt-cotacao-item-cex-tmp:
                delete tt-cotacao-item-cex-tmp.
            end.
            run findRowid in h-bocx085(input p-chave).
            run getCurrent in h-bocx085(output table tt-cotacao-item-cex-tmp).
            find first tt-cotacao-item-cex-tmp no-error.
            if avail tt-cotacao-item-cex-tmp then do:
                create tt-cotacao-item-cex.
                assign tt-cotacao-item-cex.numero-ordem      = tt-cotacao-item-cex-tmp.numero-ordem
                       tt-cotacao-item-cex.cod-emitente      = tt-cotacao-item-cex-tmp.cod-emitente
                       tt-cotacao-item-cex.it-codigo         = tt-cotacao-item-cex-tmp.it-codigo
                       tt-cotacao-item-cex.seq-cotac         = tt-cotacao-item-cex-tmp.seq-cotac
                       tt-cotacao-item-cex.data-cotacao      = tt-cotacao-item-cex-tmp.data-cotacao
                       tt-cotacao-item-cex.mapa-cotacao      = tt-cotacao-item-cex-tmp.mapa-cotacao
                       tt-cotacao-item-cex.cod-itiner        = tt-cotacao-item-cex-tmp.cod-itiner
                       tt-cotacao-item-cex.cod-incoterm      = tt-cotacao-item-cex-tmp.cod-incoterm
                       tt-cotacao-item-cex.cod-emitente-desp = i-cod-emitente
                       tt-cotacao-item-cex.cod-desp          = i-cod-desp
                       tt-cotacao-item-cex.nr-tab            = c-nr-tab
                       tt-cotacao-item-cex.mo-codigo         = i-mo-codigo
                       &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
                         tt-cotacao-item-cex.tp-despesa      = i-ctp-despesa
                       &ENDIF
                       .
            end.
            run validateInitialize in h-bocx085(input table tt-cotacao-item-cex,
                                                output table tt-bo-erro).
        end.
        when "mod":U then do:
            run updateFornecedor in h-bocx085(input p-chave,
                                              input i-cod-emitente,
                                              input i-cod-desp,
                                              input c-nr-tab,
                                              input i-mo-codigo,
                                              &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
                                                input i-ctp-despesa,
                                              &ENDIF
                                              output table tt-bo-erro).
        end.
    end case.

    delete procedure h-bocx085.
    assign h-bocx085 = ?.

    find first tt-bo-erro no-error.
    if avail tt-bo-erro then do:
        run utp/ut-msgs.p (input "show":U,
                           input tt-bo-erro.cd-erro,
                           input tt-bo-erro.parametros).
        return "adm-error":U.                           
    end.
    
    if p-param = "add1":U then do:
        create tt-cotacao-item-cex.
        buffer-copy tt-cotacao-item-cex-tmp to tt-cotacao-item-cex.
        assign p-param = "add":U.
    end.

    run imp/im0010c.w (input p-chave,
                       input p-param,
                       input table tt-cotacao-item-cex,
                       output p-chave-criada).
                       
    if not can-find(first tt-bo-erro) then
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
  
  if valid-handle(h-bocx085) then
    delete procedure h-bocx085.
    
  if valid-handle(h-boad098) then
    delete procedure h-boad098.

  if valid-handle(h-bocx095) then
    delete procedure h-bocx095.

  if valid-handle(h-boun005) then
    delete procedure h-boun005.    

  assign h-bocx085 = ?
         h-boad098 = ?
         h-bocx095 = ?
         h-boun005 = ?.
                       

  &if "{&bf_mat_versao_ems}" >= "2.05" &then
    if valid-handle(h-boad259) then
        delete procedure h-boad259.
    assign h-boad259 = ?.
  &endif
 

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
  find first tt-cotacao-item-cex no-error.
  if avail tt-cotacao-item-cex then
    assign i-cod-desp = tt-cotacao-item-cex.cod-desp.           
  
  disp i-cod-emitente
       c-nome-abrev
       c-cgc
       i-cod-desp
       tt-desc-desp-imp
       c-nome-abrev
       c-cgc 
       i-mo-codigo with frame {&frame-name}.

  &if "{&bf_mat_versao_ems}" >= "2.05" &then
    disp i-ctp-despesa with frame {&frame-name}.
    apply "leave":U to i-ctp-despesa in frame {&frame-name}.  
  &endif


  apply "leave":U to i-cod-desp     in frame {&frame-name}.
  apply "leave":U to i-cod-emitente in frame {&frame-name}.
  apply "leave":U to i-mo-codigo    in frame {&frame-name}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  run adbo/boad098.p persistent set h-boad098.
  run cxbo/bocx095.p persistent set h-bocx095. 
  run unbo/boun005.p persistent set h-boun005.

  /* Tipo de Despesa */
  &if "{&bf_mat_versao_ems}" >= "2.05" &then
    apply 'entry':U to i-cod-emitente in frame {&frame-name}.
    disable c-desc-tipo-despesa with frame {&frame-name}.     
  &else
    assign i-ctp-despesa:hidden in frame {&frame-name} = true
           c-desc-tipo-despesa:hidden in frame {&frame-name} = true
           c-nr-tab:row in frame {&frame-name} = 2.17
           TEXT-1:row in frame {&frame-name} = 2.17
           i-mo-codigo:row in frame {&frame-name} = 3.17
           c-moeda:row      in frame {&frame-name} = 3.17
           TEXT-2:row      in frame {&frame-name} = 3.17.
  &endif
  /* Fim do tipo de Despesa */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-mod V-table-Win 
PROCEDURE pi-inicializa-mod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-chave as rowid no-undo.

    run cxbo/bocx085.p persistent set h-bocx085.
    run findRowid in h-bocx085(input p-chave).
    run getCurrent in h-bocx085(output table tt-cotacao-item-cex).
    
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    
    delete procedure h-bocx085.    
    assign h-bocx085 = ?.

    assign i-cod-desp:sensitive in frame {&frame-name} = no.

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

