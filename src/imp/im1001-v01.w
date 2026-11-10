&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
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
{include/i-prgvrs.i IM1001-V01 2.00.00.010}  /*** 010010 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im1001-v01 MIM}
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

{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{include/boerrtab.i}   
{cxbo/bocx255.i tt-dupli-apagar-cex}

def var r-chave     as rowid  no-undo.
def var r-chave-pai as rowid  no-undo.
def var c-param     as char   no-undo.
def var h-bocx255   as handle no-undo.
def var h-boin090   as handle no-undo.
def var h-bocx095   as handle no-undo.
def var h-boun005   as handle no-undo.
def var h-boad098   as handle no-undo.
def var h-bocx250   as handle no-undo.
def var h-boad104   as handle no-undo.
def var c-return    as char   no-undo.

def var c-estabel  like estabelec.cod-estabel no-undo.
def var c-desp-imp like desp-imp.descricao  no-undo.
def var c-emitente like emitente.nome-abrev no-undo.
def var c-moeda    like moeda.descricao     no-undo.
def var c-erro     as char                  no-undo.
def var c-esp-tit-rec as char no-undo.
def var i-tipo     as int no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES dupli-apagar-cex
&Scoped-define FIRST-EXTERNAL-TABLE dupli-apagar-cex


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR dupli-apagar-cex.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold rt-key i-cod-emitente-desp c-parcela ~
c-cod-esp i-tp-despesa da-emissao de-perc-desconto da-venc-desc da-vencim ~
de-vl-a-pagar de-vl-a-pagar-mo dt-trans 
&Scoped-Define DISPLAYED-OBJECTS i-cod-emitente-desp c-desc-emitente ~
c-parcela c-cod-esp i-tp-despesa da-emissao de-perc-desconto da-venc-desc ~
da-vencim de-vl-a-pagar i-mo-codigo c-desc-moeda de-vl-a-pagar-mo dt-trans 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS i-tp-despesa da-emissao de-perc-desconto ~
da-venc-desc da-vencim de-vl-a-pagar 

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
DEFINE VARIABLE c-cod-esp AS CHARACTER FORMAT "!!":U 
     LABEL "c-cod-esp" 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-emitente AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda AS CHARACTER FORMAT "x(12)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-parcela AS CHARACTER FORMAT "X(2)" 
     LABEL "c-parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE da-emissao AS DATE FORMAT "99/99/9999" 
     LABEL "da-emissao" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE da-venc-desc AS DATE FORMAT "99/99/9999" 
     LABEL "da-venc-desc" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE da-vencim AS DATE FORMAT "99/99/9999" 
     LABEL "da-vencim" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-desconto AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "de-perc-desconto" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-a-pagar AS DECIMAL FORMAT ">>>>>,>>>,>>9.99" INITIAL 0 
     LABEL "de-vl-a-pagar" 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-a-pagar-mo AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "de-vl-a-pagar-mo" 
     VIEW-AS FILL-IN 
     SIZE 18.72 BY .88 NO-UNDO.

DEFINE VARIABLE dt-trans AS DATE FORMAT "99/99/9999":U 
     LABEL "dt-trans" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-desp AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "i-cod-emitente-desp" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-mo-codigo AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "i-mo-codigo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-tp-despesa AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "i-tp-despesa" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79.29 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79.29 BY 10.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-cod-emitente-desp AT ROW 1.17 COL 26 COLON-ALIGNED
     c-desc-emitente AT ROW 1.17 COL 36 COLON-ALIGNED NO-LABEL
     c-parcela AT ROW 2.17 COL 26 COLON-ALIGNED
     c-cod-esp AT ROW 3.63 COL 25.72 COLON-ALIGNED
     i-tp-despesa AT ROW 4.63 COL 25.72 COLON-ALIGNED
     da-emissao AT ROW 5.63 COL 25.72 COLON-ALIGNED
     de-perc-desconto AT ROW 6.63 COL 25.72 COLON-ALIGNED
     da-venc-desc AT ROW 7.63 COL 25.72 COLON-ALIGNED
     da-vencim AT ROW 8.63 COL 25.72 COLON-ALIGNED
     de-vl-a-pagar AT ROW 9.63 COL 25.72 COLON-ALIGNED
     i-mo-codigo AT ROW 10.63 COL 25.72 COLON-ALIGNED
     c-desc-moeda AT ROW 10.63 COL 30.72 COLON-ALIGNED NO-LABEL
     de-vl-a-pagar-mo AT ROW 11.63 COL 25.72 COLON-ALIGNED
     dt-trans AT ROW 12.63 COL 25.72 COLON-ALIGNED
     rt-mold AT ROW 3.25 COL 1
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgcex.dupli-apagar-cex
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
         HEIGHT             = 12.88
         WIDTH              = 79.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R, COLUMNS                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-emissao IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN da-venc-desc IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN da-vencim IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN de-perc-desconto IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN de-vl-a-pagar IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN i-mo-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-tp-despesa IN FRAME f-main
   1                                                                    */
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

&Scoped-define SELF-NAME c-cod-esp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-esp V-table-Win
ON F5 OF c-cod-esp IN FRAME f-main /* c-cod-esp */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad104.w
                       &campo=c-cod-esp
                       &campozoom=cod-esp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-esp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-esp IN FRAME f-main /* c-cod-esp */
DO:
     apply "F5" to self in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-emitente-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente-desp V-table-Win
ON LEAVE OF i-cod-emitente-desp IN FRAME f-main /* i-cod-emitente-desp */
DO:
    assign input frame {&FRAME-NAME}
        i-cod-emitente-desp.
    run findCodigo in h-boad098(input i-cod-emitente-desp,output c-return).
    if c-return = "" then
        run getCharfield in h-boad098(input "nome-abrev",output c-emitente).
    assign c-desc-emitente = c-emitente.
    disp c-desc-emitente with frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-codigo V-table-Win
ON LEAVE OF i-mo-codigo IN FRAME f-main /* i-mo-codigo */
DO:
    assign input frame {&FRAME-NAME}
        i-mo-codigo.
    run findCodigo in h-boun005(input i-mo-codigo,output c-return).
    if c-return = "" then
      run getCharfield in h-boun005(input "descricao",output c-moeda).
    assign c-desc-moeda = c-moeda.
    disp c-desc-moeda with frame {&FRAME-NAME}.
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
   if  c-cod-esp:load-mouse-pointer("image/lupa.cur") then .

   {utp/ut-field.i mgcex dupli-apagar-cex cod-esp 1}
   assign c-cod-esp:label in frame {&frame-name} = return-value.  

   {utp/ut-field.i mgcex dupli-apagar-cex cod-emitente-desp 1}
   assign i-cod-emitente-desp:label in frame {&frame-name} = return-value.  
  
   {utp/ut-field.i mgcex dupli-apagar-cex parcela 1}
   assign c-parcela:label in frame {&frame-name} = return-value.
  
   {utp/ut-field.i mgcex dupli-apagar-cex dt-emissao 1}
   assign da-emissao:label in frame {&frame-name} = return-value.

   {utp/ut-field.i mgcex dupli-apagar-cex desconto 1}
   assign de-perc-desconto:label in frame {&frame-name} = return-value.
  
   {utp/ut-field.i mgcex dupli-apagar-cex dt-venc-desc 1}
   assign da-venc-desc:label in frame {&frame-name} = return-value.
  
   {utp/ut-field.i mgcex dupli-apagar-cex dt-vencim 1}
   assign da-vencim:label in frame {&frame-name} = return-value.

   {utp/ut-field.i mgcex dupli-apagar-cex vl-a-pagar 1}
   assign de-vl-a-pagar:label in frame {&frame-name} = return-value.
   
   {utp/ut-field.i mgcex dupli-apagar-cex mo-codigo 1}
   assign i-mo-codigo:label in frame {&frame-name} = return-value.

   {utp/ut-field.i mgcex dupli-apagar-cex vl-a-pagar-mo 1}
   assign de-vl-a-pagar-mo:label in frame {&frame-name} = return-value.
   
   {utp/ut-field.i mgcex dupli-apagar-cex tp-despesa 1}
   assign i-tp-despesa:label in frame {&frame-name} = return-value.

   {utp/ut-field.i mgcex dupli-apagar-cex dt-trans 1}
   assign dt-trans:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "dupli-apagar-cex"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "dupli-apagar-cex"}

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
    def var c-serie-docto  like docum-est.serie-docto no-undo.
    def var c-nro-docto    like docum-est.nro-docto no-undo.
    def var i-cod-emitente like emitente.cod-emitente no-undo.
    def var c-nat-operacao like docum-est.nat-operacao no-undo.
    
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    
    for each tt-dupli-apagar-cex:
        delete tt-dupli-apagar-cex.
    end.

    case c-param:
        when "add" then do:
            run findRowid in h-boin090(input r-chave-pai).
            run getCharfield in h-boin090(input "serie-docto",output c-serie-docto).
            run getCharfield in h-boin090(input "nro-docto",output c-nro-docto).
            run getIntfield in h-boin090(input "cod-emitente",output i-cod-emitente).
            run getCharfield in h-boin090(input "nat-operacao",output c-nat-operacao).
            create tt-dupli-apagar-cex.
            assign tt-dupli-apagar-cex.serie-docto  = c-serie-docto
                &if defined(bf-mat-comex) &then
                   tt-dupli-apagar-cex.nro-docto    = string(c-nro-docto)
                &else
                   tt-dupli-apagar-cex.nro-docto    = c-nro-docto
                &endif
                   tt-dupli-apagar-cex.cod-emitente = i-cod-emitente
                   tt-dupli-apagar-cex.nat-operacao = c-nat-operacao.
        end.
        when "mod" then do:
            run findRowid in h-bocx255(input r-chave).
            run getCurrent in h-bocx255(output table tt-dupli-apagar-cex).
            find first tt-dupli-apagar-cex no-error.
        end.
    end case.
    
    run findEspecie in h-boad104 (input c-cod-esp:screen-value in frame {&frame-name}, output c-erro).
    if c-erro <> "" then do:
        run utp/ut-msgs.p (input "show":U, input 7, input c-erro).
        apply "entry":U to c-cod-esp in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    run getIntField in h-boad104 ("tipo", output i-tipo).

    if i-tipo = 2 then do:
        run utp/ut-msgs.p (input "show":U, input 625, input "").
        apply "entry" to c-cod-esp in frame {&frame-name}.
        return 'ADM-ERROR':U.    
    end.    

    
    assign tt-dupli-apagar-cex.cod-esp                = string(c-cod-esp:screen-value in frame {&frame-name})
           tt-dupli-apagar-cex.cod-emitente-desp      = integer(i-cod-emitente-desp:screen-value in frame {&frame-name})
           tt-dupli-apagar-cex.parcela                = c-parcela:screen-value in frame {&frame-name}
           tt-dupli-apagar-cex.dt-emissao             = date(da-emissao:screen-value in frame {&frame-name})           
           tt-dupli-apagar-cex.desconto               = decimal(de-perc-desconto:screen-value in frame {&frame-name})           
           tt-dupli-apagar-cex.dt-venc-desc           = date(da-venc-desc:screen-value in frame {&frame-name})
           tt-dupli-apagar-cex.dt-vencim              = date(da-vencim:screen-value in frame {&frame-name})
           tt-dupli-apagar-cex.vl-a-pagar             = decimal(de-vl-a-pagar:screen-value in frame {&frame-name})
           tt-dupli-apagar-cex.mo-codigo              = int(i-mo-codigo:screen-value in frame {&frame-name})
           tt-dupli-apagar-cex.vl-a-pagar-mo          = decimal(de-vl-a-pagar-mo:screen-value in frame {&frame-name})
           tt-dupli-apagar-cex.tp-despesa             = integer(i-tp-despesa:screen-value in frame {&frame-name})
           &if defined(bf-mat-comex) &then
           &else
               tt-dupli-apagar-cex.dt-trans               = date(dt-trans:screen-value in frame {&FRAME-NAME})
           &endif
           .


    RUN setUsuario IN h-bocx255 (INPUT c-seg-usuario).                
    if c-param = "add" then           
        run validateCreate in h-bocx255(input table tt-dupli-apagar-cex,output table tt-bo-erro,output r-chave).
    else 
        run validateUpdate in h-bocx255(input table tt-dupli-apagar-cex,input r-chave, output table tt-bo-erro).
    
    find first tt-bo-erro no-error.
    if avail tt-bo-erro then do:
        run utp/ut-msgs.p (input "show",
                           input tt-bo-erro.cd-erro,
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
  delete procedure h-bocx255.  
  delete procedure h-boin090.
  delete procedure h-bocx095.
  delete procedure h-boad098.
  delete procedure h-boun005.  
  delete procedure h-bocx250.
  delete procedure h-boad104.
  
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
  &if defined(bf-mat-comex) &then
      assign dt-trans:hidden in frame {&FRAME-NAME} = yes. 
  &else
  &endif
  
  run cxbo/bocx255.p persistent set h-bocx255.
  run cxbo/bocx250.p persistent set h-bocx250.  
  run inbo/boin090.p persistent set h-boin090.
  run cxbo/bocx095.p persistent set h-bocx095.
  run adbo/boad098.p persistent set h-boad098.
  run unbo/boun005.p persistent set h-boun005.  
  run adbo/boad104.p persistent set h-boad104.
  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-principal V-table-Win 
PROCEDURE pi-principal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter p-chave     as rowid no-undo.
  def input parameter p-chave-pai as rowid no-undo.
  def input parameter p-param     as char  no-undo.

  assign r-chave     = p-chave
         r-chave-pai = p-chave-pai
         c-param     = p-param.

  run findRowid in h-bocx255 (input r-chave).
  run getCurrent in h-bocx255 (output table tt-dupli-apagar-cex).
      
  if c-param = "mod" then
    assign i-cod-emitente-desp:sensitive in frame {&frame-name} = no
           c-parcela:sensitive in frame {&frame-name}           = no
           i-mo-codigo:sensitive in frame {&frame-name}         = no.

  if c-param = "add" then do:
     assign i-mo-codigo:sensitive in frame {&frame-name} = yes.
     run findRowid in h-boin090(input r-chave-pai).
     run getCharfield in h-boin090(input "cod-estabel",output c-estabel).
     RUN getDatefield IN h-boin090(INPUT "dt-emissao",OUTPUT da-emissao).
     RUN getDatefield IN h-boin090(INPUT "dt-trans",OUTPUT dt-trans).
     run findCodigo   in h-bocx250(input c-estabel, output c-erro).
     if c-erro = "" then do:
         run getCharField in h-bocx250("esp-tit-rec", output c-esp-tit-rec).
         assign  c-cod-esp = c-esp-tit-rec.
     end.
  end.
  
  find first tt-dupli-apagar-cex no-error.
  if  avail tt-dupli-apagar-cex then do:

      assign i-cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp
             c-parcela           = tt-dupli-apagar-cex.parcela
             da-emissao          = tt-dupli-apagar-cex.dt-emissao
             c-cod-esp           = tt-dupli-apagar-cex.cod-esp
             de-perc-desconto    = tt-dupli-apagar-cex.desconto           
             da-venc-desc        = tt-dupli-apagar-cex.dt-venc-desc
             da-vencim           = tt-dupli-apagar-cex.dt-vencim  
             de-vl-a-pagar       = tt-dupli-apagar-cex.vl-a-pagar
             i-mo-codigo         = tt-dupli-apagar-cex.mo-codigo
             de-vl-a-pagar-mo    = tt-dupli-apagar-cex.vl-a-pagar-mo
             i-tp-despesa        = tt-dupli-apagar-cex.tp-despesa
             &if defined(bf-mat-comex) &then
             &else
                dt-trans            = tt-dupli-apagar-cex.dt-trans
             &endif
             .
                              
      apply "leave" to i-cod-emitente-desp in frame {&FRAME-NAME}.         
      apply "leave" to i-mo-codigo in frame {&FRAME-NAME}.
  end.

  disp i-cod-emitente-desp 
       c-parcela
       da-emissao
       c-cod-esp
       de-perc-desconto           
       da-venc-desc
       da-vencim  
       de-vl-a-pagar 
       i-mo-codigo
       de-vl-a-pagar-mo 
       i-tp-despesa 
       &if defined(bf-mat-comex) &then
       &else   
          dt-trans 
       &endif
       with frame {&frame-name}.
       
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
  {src/adm/template/snd-list.i "dupli-apagar-cex"}

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


