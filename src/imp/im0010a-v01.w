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
{include/i-prgvrs.i IM0010A-V01 2.00.00.013 } /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0010A-V01 MIM}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def var v-row-parent as rowid no-undo.

{cdp/cdcfgmat.i} /* Definiá∆o de prÇ-processadores */ 
{include/boerrtab.i}
{cxbo/bocx085.i tt-cotacao-item-cex}
{cxbo/bocx085.i tt-cotacao-item-cex2}

def var h-bocx085 as handle no-undo.   
def var h-boin082 as handle no-undo.
def var l-criou as logical init no no-undo.
def var l-aprovado as logical no-undo.
def var c-param as char no-undo.
def var r-chave as rowid no-undo.
def var c-return as char no-undo.
def var r-chave-cop as rowid no-undo.
def var h-mapa as handle no-undo.
def var h-dt-cotacao as handle no-undo.
def var h-bocx155b as handle  no-undo.

DEFINE VARIABLE hProgramZoom      AS HANDLE    NO-UNDO.

def new global shared var gr-cotacao-item-i as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key i-numero-ordem i-cod-emitente ~
c-it-codigo i-seq-cotac d-data-cotacao i-mapa-cotacao i-cod-itiner 
&Scoped-Define DISPLAYED-OBJECTS i-numero-ordem i-cod-emitente ~
c-desc-emitente c-it-codigo i-seq-cotac d-data-cotacao i-mapa-cotacao ~
i-cod-itiner c-desc-itinerario c-unid 

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
DEFINE VARIABLE c-desc-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-itinerario AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(256)":U 
     LABEL "it-codigo" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE c-unid AS CHARACTER FORMAT "xx" 
     LABEL "un":R12 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE d-data-cotacao AS DATE FORMAT "99/99/9999":U 
     LABEL "data-cotacao" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "cod-emitente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-itiner AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "cod-itiner" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-mapa-cotacao AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "mapa-cotacao" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-numero-ordem AS INTEGER FORMAT ">>>>>>,99":U INITIAL 0 
     LABEL "numero-ordem" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-seq-cotac AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "i-seq-cotac" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 4.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-numero-ordem AT ROW 1.25 COL 17 COLON-ALIGNED
     i-cod-emitente AT ROW 1.25 COL 55 COLON-ALIGNED
     c-desc-emitente AT ROW 1.25 COL 66.14 COLON-ALIGNED NO-LABEL
     c-it-codigo AT ROW 2.25 COL 17 COLON-ALIGNED
     i-seq-cotac AT ROW 2.25 COL 55 COLON-ALIGNED
     d-data-cotacao AT ROW 3.25 COL 17 COLON-ALIGNED
     i-mapa-cotacao AT ROW 3.25 COL 55 COLON-ALIGNED
     i-cod-itiner AT ROW 4.25 COL 17 COLON-ALIGNED
     c-desc-itinerario AT ROW 4.25 COL 24 COLON-ALIGNED NO-LABEL
     c-unid AT ROW 4.25 COL 55 COLON-ALIGNED HELP
          "Unidade de medida do item"
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
         HEIGHT             = 4.5
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-itinerario IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-unid IN FRAME f-main
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

&Scoped-define SELF-NAME c-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo V-table-Win
ON F5 OF c-it-codigo IN FRAME f-main /* it-codigo */
DO: 
    {method/ZoomFields.i 
     &ProgramZoom="inzoom/z10in082.w"
     &FieldZoom1="numero-ordem"
     &FieldScreen1="i-numero-ordem"
     &Frame1="{&frame-name}"
     &FieldZoom2="cod-emitente"
     &FieldScreen2="i-cod-emitente"
     &Frame2="{&frame-name}"
     &FieldZoom3="data-cotacao"
     &FieldScreen3="d-data-cotacao"
     &Frame3="{&frame-name}"
     &FieldZoom4="seq-cotac"
     &FieldScreen4="i-seq-cotac"
     &Frame4="{&frame-name}"
     &FieldZoom5="un"
     &FieldScreen5="c-unid"
     &Frame5="{&frame-name}"
     &FieldZoom6="it-codigo"
     &FieldScreen6="c-it-codigo"
     &Frame6="{&frame-name}"
     &EnableImplant="no"}
     
     /*
    {include/zoomvar.i &prog-zoom=inzoom/z10in082.w
                     &campo=i-cod-emitente
                     &campo2=i-numero-ordem
                     &campo3=c-it-codigo
                     &campo4=i-seq-cotac
                     &campo5=d-data-cotacao
                     &campo6=c-unid
                     &campozoom=cod-emitente
                     &campozoom2=numero-ordem
                     &campozoom3=it-codigo
                     &campozoom4=seq-cotac
                     &campozoom5=data-cotacao
                     &campozoom6=un}
   */ 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-it-codigo IN FRAME f-main /* it-codigo */
DO:
  apply 'F5' to self in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-data-cotacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-data-cotacao V-table-Win
ON F5 OF d-data-cotacao IN FRAME f-main /* data-cotacao */
DO:
    {method/ZoomFields.i 
     &ProgramZoom="inzoom/z10in082.w"
     &FieldZoom1="numero-ordem"
     &FieldScreen1="i-numero-ordem"
     &Frame1="{&frame-name}"
     &FieldZoom2="cod-emitente"
     &FieldScreen2="i-cod-emitente"
     &Frame2="{&frame-name}"
     &FieldZoom3="data-cotacao"
     &FieldScreen3="d-data-cotacao"
     &Frame3="{&frame-name}"
     &FieldZoom4="seq-cotac"
     &FieldScreen4="i-seq-cotac"
     &Frame4="{&frame-name}"
     &FieldZoom5="un"
     &FieldScreen5="c-unid"
     &Frame5="{&frame-name}"
     &FieldZoom6="it-codigo"
     &FieldScreen6="c-it-codigo"
     &Frame6="{&frame-name}"
     &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-data-cotacao V-table-Win
ON LEAVE OF d-data-cotacao IN FRAME f-main /* data-cotacao */
DO:
    run inbo/boin082.p persistent set h-boin082.
    
    &if defined(bf-mat-comex) &then
        assign input frame {&frame-name} i-numero-ordem
                                         i-cod-emitente
                                         c-it-codigo
                                         d-data-cotacao.
        run findCotacao in h-boin082 (input i-numero-ordem,
                                      input i-cod-emitente,
                                      input c-it-codigo,
                                      input d-data-cotacao,
                                      output c-return).
    &else                                      
        assign input frame {&frame-name} i-numero-ordem
                                         i-cod-emitente
                                         c-it-codigo
                                         i-seq-cotac.
        run findCotacao in h-boin082 (input i-numero-ordem,
                                      input i-cod-emitente,
                                      input c-it-codigo,
                                      input i-seq-cotac,
                                      output c-return).    
    &endif                                      
                                  
    if c-return = "" then
        run getCharfield in h-boin082 (input "un":U,output c-unid).
        
    disp c-unid with frame {&frame-name}.
    
    delete procedure h-boin082.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-data-cotacao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF d-data-cotacao IN FRAME f-main /* data-cotacao */
DO:
  apply 'F5' to self in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente V-table-Win
ON F5 OF i-cod-emitente IN FRAME f-main /* cod-emitente */
DO:
    {method/ZoomFields.i 
     &ProgramZoom="inzoom/z10in082.w"
     &FieldZoom1="numero-ordem"
     &FieldScreen1="i-numero-ordem"
     &Frame1="{&frame-name}"
     &FieldZoom2="cod-emitente"
     &FieldScreen2="i-cod-emitente"
     &Frame2="{&frame-name}"
     &FieldZoom3="data-cotacao"
     &FieldScreen3="d-data-cotacao"
     &Frame3="{&frame-name}"
     &FieldZoom4="seq-cotac"
     &FieldScreen4="i-seq-cotac"
     &Frame4="{&frame-name}"
     &FieldZoom5="un"
     &FieldScreen5="c-unid"
     &Frame5="{&frame-name}"
     &FieldZoom6="it-codigo"
     &FieldScreen6="c-it-codigo"
     &Frame6="{&frame-name}"
     &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente V-table-Win
ON LEAVE OF i-cod-emitente IN FRAME f-main /* cod-emitente */
DO:  
    def var c-nome-abrev like emitente.nome-abrev no-undo.
    def var h-boad098 as handle no-undo.
    
    assign input frame {&frame-name} i-cod-emitente.
    run adbo/boad098.p persistent set h-boad098.        
    run findCodigo in h-boad098(input i-cod-emitente, output c-return).
    if c-return = "" then do:
        run getCharfield in h-boad098(input "nome-abrev", output c-nome-abrev).
        assign c-desc-emitente:screen-value = c-nome-abrev.
    end.
    delete procedure h-boad098.


    /* Sugere o itiner†rio padr∆o associado ao fornecedor (cd2576) */
    /* A sugest∆o ser† feita somente se esse programa N«O for acessado pelos programas cc0303 e im0060, 
       pois estes j† tem gravados a informaá∆o do itiner†rio */

    def var i-cod-itiner-imp as int no-undo.
    
    assign frame {&frame-name} i-cod-emitente.

    run cxbo/bocx155b.p persistent set h-bocx155b.
    
    run findPk-emitente in h-bocx155b (input i-cod-emitente, output c-return).
    
    if  c-return = "" then do:
        run getIntField in h-bocx155b (input "cod-itiner-imp":U, output i-cod-itiner-imp).
        assign i-cod-itiner:screen-value in frame {&frame-name} = string(i-cod-itiner-imp).
        apply "LEAVE":U to i-cod-itiner in frame {&frame-name}.
    end.

    delete procedure h-bocx155b.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-emitente IN FRAME f-main /* cod-emitente */
DO:
  apply 'F5' to self in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-itiner
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-itiner V-table-Win
ON F5 OF i-cod-itiner IN FRAME f-main /* cod-itiner */
DO:
    {include/zoomvar.i &prog-zoom=cxzoom/z01cx115.w
                      &campo=i-cod-itiner
                      &campozoom=cod-itiner}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-itiner V-table-Win
ON LEAVE OF i-cod-itiner IN FRAME f-main /* cod-itiner */
DO:
    def var c-descricao like itinerario.descricao no-undo.
    def var h-bocx115 as handle no-undo.
    
    assign input frame {&frame-name} i-cod-itiner.
    run cxbo/bocx115.p persistent set h-bocx115.        
    run findCodigo in h-bocx115(input i-cod-itiner, output c-return).
    if c-return = "" then do:
        run getCharfield in h-bocx115(input "descricao", output c-descricao).
        assign c-desc-itinerario:screen-value = c-descricao.
    end.        
    delete procedure h-bocx115.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-itiner V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-itiner IN FRAME f-main /* cod-itiner */
DO:
  apply 'F5' to self in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-numero-ordem V-table-Win
ON F5 OF i-numero-ordem IN FRAME f-main /* numero-ordem */
DO:
    {method/ZoomFields.i 
     &ProgramZoom="inzoom/z10in082.w"
     &FieldZoom1="numero-ordem"
     &FieldScreen1="i-numero-ordem"
     &Frame1="{&frame-name}"
     &FieldZoom2="cod-emitente"
     &FieldScreen2="i-cod-emitente"
     &Frame2="{&frame-name}"
     &FieldZoom3="data-cotacao"
     &FieldScreen3="d-data-cotacao"
     &Frame3="{&frame-name}"
     &FieldZoom4="seq-cotac"
     &FieldScreen4="i-seq-cotac"
     &Frame4="{&frame-name}"
     &FieldZoom5="un"
     &FieldScreen5="c-unid"
     &Frame5="{&frame-name}"
     &FieldZoom6="it-codigo"
     &FieldScreen6="c-it-codigo"
     &Frame6="{&frame-name}"
     &EnableImplant="no"}
     
     apply "LEAVE":U to self in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-numero-ordem V-table-Win
ON LEAVE OF i-numero-ordem IN FRAME f-main /* numero-ordem */
DO:

    /* Sugere o itiner†rio padr∆o associado ao fornecedor (cd2576) */
    /* A sugest∆o ser† feita somente se esse programa N«O for acessado pelos programas cc0303 e im0060, 
       pois estes j† tem gravados a informaá∆o do itiner†rio */

    def var i-cod-itiner-imp as int no-undo.
    
    assign frame {&frame-name} i-cod-emitente.

    run cxbo/bocx155b.p persistent set h-bocx155b.
    
    run findPk-emitente in h-bocx155b (input i-cod-emitente, output c-return).
    
    if  c-return = "" then do:
        run getIntField in h-bocx155b (input "cod-itiner-imp":U, output i-cod-itiner-imp).
        assign i-cod-itiner:screen-value in frame {&frame-name} = string(i-cod-itiner-imp).
        apply "LEAVE":U to i-cod-itiner in frame {&frame-name}.
    end.

    delete procedure h-bocx155b.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-numero-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-numero-ordem IN FRAME f-main /* numero-ordem */
DO:
  apply 'F5' to self in frame {&frame-name}.
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
  
  {utp/ut-field.i mgcex cotacao-item-cex numero-ordem 1}
  assign i-numero-ordem:label in frame {&frame-name} = trim(return-value).
  if i-numero-ordem:load-mouse-pointer ("Image\lupa.cur") in frame {&frame-name} then.

  {utp/ut-field.i mgcex cotacao-item-cex cod-emitente 1}
  assign i-cod-emitente:label in frame {&frame-name} = trim(return-value).
  if i-cod-emitente:load-mouse-pointer ("Image\lupa.cur") in frame {&frame-name} then.  

  {utp/ut-field.i mgcex cotacao-item-cex it-codigo 1}
  assign c-it-codigo:label in frame {&frame-name} = trim(return-value).
  if c-it-codigo:load-mouse-pointer ("Image\lupa.cur") in frame {&frame-name} then.  

  {utp/ut-field.i mgcex cotacao-item-cex data-cotacao 1}
  assign d-data-cotacao:label in frame {&frame-name} = trim(return-value).
  if d-data-cotacao:load-mouse-pointer ("Image\lupa.cur") in frame {&frame-name} then.  

  {utp/ut-field.i mgcex cotacao-item-cex mapa-cotacao 1}
  assign i-mapa-cotacao:label in frame {&frame-name} = trim(return-value).
  
  {utp/ut-field.i mgcex cotacao-item-cex cod-itiner 1}
  assign i-cod-itiner:label in frame {&frame-name} = trim(return-value).
  if i-cod-itiner:load-mouse-pointer ("Image\lupa.cur") in frame {&frame-name} then.
  
  {utp/ut-liter.i Un * L}
  assign c-unid:label in frame {&frame-name} = trim(return-value).

  &if defined(bf-mat-comex) &then
  &else
      {utp/ut-field.i mgind cotacao-item seq-cotac 1}
      assign i-seq-cotac:label in frame {&frame-name} = trim(return-value).
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
/*--------------------------------------------------------------------------------
    Grava os valores de tela na tabela temporaria tt-cotacao-item-cex,
    as validacoes sao realizadas nas procedures  Validates.
--------------------------------------------------------------------------------*/
    def output parameter p-chave as rowid no-undo. /* retorna o rowid do registro criado */ 
    
    run limpa-temp-tables.   

    create tt-cotacao-item-cex.           
    assign tt-cotacao-item-cex.numero-ordem = integer(i-numero-ordem:screen-value in frame {&frame-name})
           tt-cotacao-item-cex.cod-emitente = integer(i-cod-emitente:screen-value in frame {&frame-name})  
           tt-cotacao-item-cex.it-codigo    = c-it-codigo:screen-value in frame {&frame-name}
           tt-cotacao-item-cex.seq-cotac    = integer(i-seq-cotac:screen-value in frame {&frame-name})
           tt-cotacao-item-cex.data-cotacao = date(d-data-cotacao:screen-value in frame {&frame-name})
           tt-cotacao-item-cex.mapa-cotacao = integer(i-mapa-cotacao:screen-value in frame {&frame-name})
           tt-cotacao-item-cex.cod-itiner   = integer(i-cod-itiner:screen-value in frame {&frame-name}).

    /*Possibilidade de fazer a validaá∆o aqui para n∆o alterar (estragar outros programas)*/

    run cxbo/bocx085.p persistent set h-bocx085.    
    run validateCreatePai in h-bocx085 (input-output table tt-cotacao-item-cex,
                                        output table tt-bo-erro,
                                        output r-chave,
                                        output l-criou).
    delete procedure h-bocx085.                                        
                                        
    if l-criou then do:
        assign p-chave = r-chave.
        return "".
    end.        
    else do:
        find first tt-bo-erro no-error.
        if avail tt-bo-erro then do:
            run utp/ut-msgs.p (input "show",
                               input tt-bo-erro.cd-erro,
                               input tt-bo-erro.parametros).
            return "adm-error".
        end.
        else do:    
            find first tt-cotacao-item-cex no-error.
            if avail tt-cotacao-item-cex then 
                run imp/im0010b.w(input ?,
                                  input "add1",
                                  input table tt-cotacao-item-cex,
                                  output r-chave).
            assign p-chave = r-chave.                      
            if c-param = "cop" then do:
                run cxbo/bocx085.p persistent set h-bocx085.
                run findRowid in h-bocx085(input r-chave).
                run getCurrent in h-bocx085(output table tt-cotacao-item-cex).
                find first tt-cotacao-item-cex no-error.
                if avail tt-cotacao-item-cex then    
                    RUN executeCopy in h-bocx085(input r-chave-cop,
                                                 input table tt-cotacao-item-cex).
                delete procedure h-bocx085.                                                                 
            end.                  
            return "".
        end.
    end.
        
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  
  if valid-handle(h-bocx085) then
    delete procedure h-bocx085.   

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
  
  if avail tt-cotacao-item-cex then do:

    assign i-numero-ordem = tt-cotacao-item-cex.numero-ordem
           i-cod-emitente = tt-cotacao-item-cex.cod-emitente
           c-it-codigo    = tt-cotacao-item-cex.it-codigo
           i-seq-cotac    = tt-cotacao-item-cex.seq-cotac
           d-data-cotacao = tt-cotacao-item-cex.data-cotacao
           i-mapa-cotacao = tt-cotacao-item-cex.mapa-cotacao
           i-cod-itiner   = tt-cotacao-item-cex.cod-itiner.
    run inbo/boin082.p persistent set h-boin082.
    run findCotacao in h-boin082(input  i-numero-ordem,
                                 input  i-cod-emitente,
                                 input  c-it-codigo,
                                 &if defined(bf-mat-comex) &then
                                     input d-data-cotacao,
                                 &else
                                     input i-seq-cotac,
                                 &endif
                                 output c-return).
    if c-return = "" then do:      
       run getCharfield in h-boin082(input "un":U,output c-unid).
    end.
    delete procedure h-boin082.       
  end.
    
  disp i-numero-ordem
       i-cod-emitente
       c-it-codigo
       i-seq-cotac
       d-data-cotacao
       i-mapa-cotacao
       i-cod-itiner 
       c-unid  with frame {&frame-name}.
       
  apply "leave" to i-cod-emitente in frame {&frame-name}.
  apply "leave" to i-cod-itiner in frame {&frame-name}.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) . 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .  

  /* Code placed here will execute AFTER standard behavior.    */
  
  &if defined(bf-mat-comex) &then
    assign h-dt-cotacao = d-data-cotacao:side-label-handle in frame {&frame-name}
           h-mapa       = i-mapa-cotacao:side-label-handle in frame {&frame-name}
           i-seq-cotac:hidden in frame {&frame-name} = yes
           d-data-cotacao:row    in frame {&frame-name} = 2.25
           d-data-cotacao:column in frame {&frame-name} = 57
           h-dt-cotacao:row                             = 2.25           
           h-dt-cotacao:column                          = 53.00
           i-mapa-cotacao:row    in frame {&frame-name} = 3.25
           i-mapa-cotacao:column in frame {&frame-name} = 19
           h-mapa:column                                = 14.50.
  &else  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-cop V-table-Win 
PROCEDURE pi-inicializa-cop :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter p-chave as rowid no-undo.
  assign r-chave-cop = p-chave.
  run cxbo/bocx085.p persistent set h-bocx085.
  run findRowid in h-bocx085(input r-chave-cop).
  run getCurrent in h-bocx085(output table tt-cotacao-item-cex).  
  run dispatch IN THIS-PROCEDURE ('display-fields':U).
  delete procedure h-bocx085.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-ordem V-table-Win 
PROCEDURE pi-inicializa-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF DEFINED(bf-mat-comex) &THEN
        
        /* No Magnus o programa de cotaá∆o Ç acessado no ambiente Magnus, portanto n∆o ter† posicionamento autom†tico */

    &ELSE
        
        IF gr-cotacao-item-i <> ? THEN DO:
        
            run inbo/boin082.p persistent set h-boin082.
            RUN openQueryStatic IN h-boin082 (INPUT "main":U).
            RUN findRowid IN h-boin082 (INPUT gr-cotacao-item-i).
            IF RETURN-VALUE = "OK":U THEN DO:
                run getCharfield in h-boin082(input "it-codigo":U,output c-it-codigo).
                run getIntfield  in h-boin082(input "numero-ordem":U,output i-numero-ordem).
                run getIntfield  in h-boin082(input "cod-emitente":U,output i-cod-emitente).
                run getDatefield in h-boin082(input "data-cotacao":U,output d-data-cotacao).
                run getIntfield  in h-boin082(input "seq-cotac":U,output i-seq-cotac).
                run getCharfield in h-boin082(input "un":U,output c-unid).
                DISP i-seq-cotac WITH FRAME {&FRAME-NAME}.
                DISP c-it-codigo
                     i-numero-ordem
                     i-cod-emitente
                     d-data-cotacao
                     i-seq-cotac
                     c-unid
                     with frame {&frame-name}.
                apply "leave":U to i-cod-emitente in frame {&frame-name}.
    
            END.

            IF VALID-HANDLE (h-boin082) THEN DO:
                delete procedure h-boin082.
                ASSIGN h-boin082 = ?.
            END.
        END.

    &ENDIF

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

