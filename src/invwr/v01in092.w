&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
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
{include/i-prgvrs.i V01IN092 2.00.00.032 } /*** 010032 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in092 MUT}
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
def new global shared var v-row-parent    as rowid no-undo.      
def new global shared var gr-dupli-apagar as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var rw-docum-est as rowid no-undo.

def buffer b-dupli for dupli-apagar.

def var l-inclui   as logical   no-undo.
def var c-retencao as character no-undo.
def var l-consiste as logical   no-undo.

def var dat-tipo-dia   like calen-coml.tipo-dia no-undo. /*CD9020.i7*/

/*
** Integracamo Modulo Importacao
*/ 
def var l-imp      as logical init no no-undo.

{cdp/cd4300.i3} /* vari†veis utilizadas pelo cd4300.i4 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES dupli-apagar
&Scoped-define FIRST-EXTERNAL-TABLE dupli-apagar


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR dupli-apagar.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS dupli-apagar.nr-duplic dupli-apagar.cod-esp ~
dupli-apagar.tp-despesa dupli-apagar.dt-emissao dupli-apagar.dt-trans ~
dupli-apagar.dt-vencim dupli-apagar.vl-a-pagar dupli-apagar.desconto ~
dupli-apagar.vl-desconto dupli-apagar.cod-ret-irf 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nr-duplic ~{&FP2}nr-duplic ~{&FP3}~
 ~{&FP1}cod-esp ~{&FP2}cod-esp ~{&FP3}~
 ~{&FP1}tp-despesa ~{&FP2}tp-despesa ~{&FP3}~
 ~{&FP1}dt-emissao ~{&FP2}dt-emissao ~{&FP3}~
 ~{&FP1}dt-trans ~{&FP2}dt-trans ~{&FP3}~
 ~{&FP1}dt-vencim ~{&FP2}dt-vencim ~{&FP3}~
 ~{&FP1}vl-a-pagar ~{&FP2}vl-a-pagar ~{&FP3}~
 ~{&FP1}desconto ~{&FP2}desconto ~{&FP3}~
 ~{&FP1}vl-desconto ~{&FP2}vl-desconto ~{&FP3}~
 ~{&FP1}cod-ret-irf ~{&FP2}cod-ret-irf ~{&FP3}
&Scoped-define ENABLED-TABLES dupli-apagar
&Scoped-define FIRST-ENABLED-TABLE dupli-apagar
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS dupli-apagar.parcela dupli-apagar.nr-duplic ~
dupli-apagar.cod-esp dupli-apagar.tp-despesa dupli-apagar.dt-emissao ~
dupli-apagar.dt-trans dupli-apagar.dt-vencim dupli-apagar.vl-a-pagar ~
dupli-apagar.desconto dupli-apagar.vl-desconto dupli-apagar.dt-venc-desc ~
dupli-apagar.cod-ret-irf 
&Scoped-Define DISPLAYED-OBJECTS de-vl-descto-me i-moeda c-desc-moeda ~
de-vl-apagar-me 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS dupli-apagar.parcela 
&Scoped-define ADM-ASSIGN-FIELDS dupli-apagar.parcela ~
dupli-apagar.nr-duplic dupli-apagar.cod-esp dupli-apagar.tp-despesa ~
dupli-apagar.dt-emissao dupli-apagar.dt-trans dupli-apagar.dt-vencim ~
dupli-apagar.vl-a-pagar dupli-apagar.desconto dupli-apagar.vl-desconto ~
dupli-apagar.dt-venc-desc dupli-apagar.cod-ret-irf 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-calcula-vencimento V-table-Win 
FUNCTION fn-calcula-vencimento RETURNS DATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-desc-moeda AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 15.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-apagar-me AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "de-vl-apagar-me" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-descto-me AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL ? 
     LABEL "de-vl-descto-me" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-moeda AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "i-moeda" 
     VIEW-AS FILL-IN 
     SIZE 4.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 8.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-vl-descto-me AT ROW 7.42 COL 63 COLON-ALIGNED
     dupli-apagar.parcela AT ROW 1.42 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     dupli-apagar.nr-duplic AT ROW 2.42 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     dupli-apagar.cod-esp AT ROW 3.42 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     dupli-apagar.tp-despesa AT ROW 4.42 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     dupli-apagar.dt-emissao AT ROW 5.42 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     dupli-apagar.dt-trans AT ROW 6.42 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     dupli-apagar.dt-vencim AT ROW 7.42 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     dupli-apagar.vl-a-pagar AT ROW 8.42 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     dupli-apagar.desconto AT ROW 1.42 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     dupli-apagar.vl-desconto AT ROW 2.42 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     dupli-apagar.dt-venc-desc AT ROW 3.42 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     dupli-apagar.cod-ret-irf AT ROW 4.42 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     i-moeda AT ROW 5.42 COL 63 COLON-ALIGNED
     c-desc-moeda AT ROW 5.42 COL 68.14 COLON-ALIGNED NO-LABEL
     de-vl-apagar-me AT ROW 6.42 COL 63 COLON-ALIGNED
     rt-key AT ROW 1 COL 1.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.dupli-apagar
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
         HEIGHT             = 8.75
         WIDTH              = 86.72.
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

/* SETTINGS FOR FILL-IN c-desc-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dupli-apagar.cod-esp IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN dupli-apagar.cod-ret-irf IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN de-vl-apagar-me IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-descto-me IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dupli-apagar.desconto IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN dupli-apagar.dt-emissao IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN dupli-apagar.dt-trans IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN dupli-apagar.dt-venc-desc IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN dupli-apagar.dt-vencim IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN i-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dupli-apagar.nr-duplic IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN dupli-apagar.parcela IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN dupli-apagar.tp-despesa IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN dupli-apagar.vl-a-pagar IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN dupli-apagar.vl-desconto IN FRAME f-main
   2                                                                    */
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

&Scoped-define SELF-NAME dupli-apagar.cod-esp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dupli-apagar.cod-esp V-table-Win
ON F5 OF dupli-apagar.cod-esp IN FRAME f-main /* Especie */
OR  MOUSE-SELECT-DBLCLICK OF dupli-apagar.cod-esp IN FRAME {&FRAME-NAME} DO:
    l-implanta      = yes.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad104.w
                       &campo=dupli-apagar.cod-esp
                       &campozoom=cod-esp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dupli-apagar.cod-ret-irf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dupli-apagar.cod-ret-irf V-table-Win
ON F5 OF dupli-apagar.cod-ret-irf IN FRAME f-main /* C¢digo Retená∆o Imposto */
OR  MOUSE-SELECT-DBLCLICK OF dupli-apagar.cod-ret-irf IN FRAME {&FRAME-NAME} DO:
  assign l-implanta = no.
  {include/zoomvar.i &prog-zoom = adzoom/z01ad999.w
                     &campo     = dupli-apagar.cod-ret-irf 
                     &campozoom = tt-cod-ir.c-cod}
if c-retencao > "" then
   assign dupli-apagar.cod-ret-irf:screen-value in frame {&frame-name} = 
c-retencao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-vl-apagar-me
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-vl-apagar-me V-table-Win
ON LEAVE OF de-vl-apagar-me IN FRAME f-main /* de-vl-apagar-me */
DO:
    if  dupli-apagar.desconto <> 0 then 
        assign de-vl-descto-me:screen-value = string(round((dec(de-vl-apagar-me:screen-value) 
                                            * input dupli-apagar.desconto) / 100,2)).    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dupli-apagar.desconto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dupli-apagar.desconto V-table-Win
ON LEAVE OF dupli-apagar.desconto IN FRAME f-main /* Percentual Desconto */
DO:
    do  with frame {&frame-name}:
        if  input dupli-apagar.desconto = 0 
        and input dupli-apagar.vl-desconto = 0 then do:
            assign dupli-apagar.dt-venc-desc:screen-value = ?
                   dupli-apagar.dt-venc-desc:sensitive    = no.
        end.
        else 
            assign dupli-apagar.dt-venc-desc:sensitive = yes.
        assign dupli-apagar.vl-desconto:screen-value = string(round(
            (input dupli-apagar.vl-a-pagar * input dupli-apagar.desconto) / 100,2)).
        /*
        ** Integracao Modulo Importacao
        */
        if l-imp and dupli-apagar.desconto <> 0 then 
            assign de-vl-descto-me:screen-value = string(round((dec(de-vl-apagar-me:screen-value)
                                                * input dupli-apagar.desconto) / 100,2)).
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dupli-apagar.dt-emissao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dupli-apagar.dt-emissao V-table-Win
ON LEAVE OF dupli-apagar.dt-emissao IN FRAME f-main /* Data Emiss∆o */
DO:
    display fn-calcula-vencimento() @ dupli-apagar.dt-vencim
        with frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-moeda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-moeda V-table-Win
ON LEAVE OF i-moeda IN FRAME f-main /* i-moeda */
DO:
  find moeda where moeda.mo-codigo = input frame {&frame-name} i-moeda no-lock no-error.
  if avail moeda then do:
    assign c-desc-moeda  = moeda.descricao.
    disp c-desc-moeda with frame {&frame-name}.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dupli-apagar.tp-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dupli-apagar.tp-despesa V-table-Win
ON F5 OF dupli-apagar.tp-despesa IN FRAME f-main /* Tipo Despesa */
OR  MOUSE-SELECT-DBLCLICK OF dupli-apagar.tp-despesa IN FRAME {&FRAME-NAME} DO:
    l-implanta      = yes. 
    {include/zoomvar.i &prog-zoom=adzoom/z01ad259.w
                       &campo=dupli-apagar.tp-despesa
                       &campozoom=tp-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dupli-apagar.vl-desconto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dupli-apagar.vl-desconto V-table-Win
ON LEAVE OF dupli-apagar.vl-desconto IN FRAME f-main /* Descto */
DO:
    if  input frame {&frame-name} dupli-apagar.desconto = 0
    and input frame {&frame-name} dupli-apagar.vl-desconto = 0 then do:
        assign dupli-apagar.dt-venc-desc:screen-value in frame {&frame-name} = ?
               dupli-apagar.dt-venc-desc:sensitive in frame {&frame-name}    = no.
    end.
    else do:
        assign dupli-apagar.dt-venc-desc:sensitive in frame {&frame-name} = yes.
    end.
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

  find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
  assign rw-docum-est = v-row-parent.

  find first param-global no-lock no-error.
  find param-re where param-re.usuario = c-seg-usuario no-lock no-error.
  find param-ap where param-ap.ep-codigo = param-global.empresa-prin
       no-lock no-error.

  if  dupli-apagar.cod-ret-irf:load-mouse-pointer("image/lupa.cur") then .
  if  dupli-apagar.cod-esp:load-mouse-pointer("image/lupa.cur") then .
  if  dupli-apagar.tp-despesa:load-mouse-pointer("image/lupa.cur") then .

  {utp/ut-liter.i Moeda_Orig MIM L}
  assign i-moeda:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Vl_Dupl_Mo_Orig MIM L}
  assign de-vl-apagar-me:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Vl_Descto_Mo_Orig MIM L}
  assign de-vl-descto-me:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "dupli-apagar"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "dupli-apagar"}

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

  def buffer b-dupli for dupli-apagar.

  def var de-tot-dupli as decimal no-undo.
  def var i-parcela    as integer no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  assign de-tot-dupli = docum-est.tot-valor
         l-inclui     = yes
         i-parcela    = 1.
  for each b-dupli 
     where b-dupli.cod-emitente = docum-est.cod-emitente 
       and b-dupli.nat-operacao = docum-est.nat-operacao
       and b-dupli.serie-docto  = docum-est.serie-docto
       and b-dupli.nro-docto    = docum-est.nro-docto no-lock:
      assign de-tot-dupli = de-tot-dupli - b-dupli.vl-a-pagar
             i-parcela    = i-parcela + 1. 
  end.
  find first item-doc-est 
       where item-doc-est.cod-emitente = docum-est.cod-emitente 
         and item-doc-est.nat-operacao = docum-est.nat-operacao
         and item-doc-est.serie-docto  = docum-est.serie-docto
         and item-doc-est.nro-docto    = docum-est.nro-docto 
         and item-doc-est.numero-ordem > 0 no-lock no-error.
  if  avail item-doc-est then do:
      find ordem-compra where
           ordem-compra.numero-ordem = item-doc-est.numero-ordem no-lock no-error.
      if  avail ordem-compra then
          assign dupli-apagar.tp-despesa:screen-value in frame {&frame-name} = 
              string(ordem-compra.tp-despesa).
  end.
  else do:
      find emitente where 
           emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.
      assign dupli-apagar.tp-despesa:screen-value in frame {&frame-name} = 
                                     string(emitente.tp-desp-padrao).
  end.

  if de-tot-dupli < 0 then
     assign de-tot-dupli = 0.     

  display string(i-parcela)                            @ dupli-apagar.parcela
          docum-est.dt-emissao                         @ dupli-apagar.dt-emissao
          docum-est.dt-trans                           @ dupli-apagar.dt-trans
          fn-calcula-vencimento()                      @ dupli-apagar.dt-vencim
          docum-est.nro-docto                          @ dupli-apagar.nr-duplic
          de-tot-dupli                                 @ dupli-apagar.vl-a-pagar
          param-re.esp-def-nff when     docum-est.nff  @ dupli-apagar.cod-esp 
          param-re.esp-def-dup when not docum-est.nff  @ dupli-apagar.cod-esp           
          with frame {&frame-name}.

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
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  

  find docum-est where rowid(docum-est) = rw-docum-est no-lock no-error.
  find first param-global no-lock no-error.

  {rep/re1001a.i50}
  {cdp/cd4300.i4 "yes" docum-est.char-1}
  {rep/re1001a.i51 "yes"}

  {rep/re1001c.i50}  
  if l-imp and c-embarque <> "":U then
      assign i-mo-codigo      = int(i-moeda:screen-value in frame {&frame-name})  
             de-vl-a-pagar-mo = dec(de-vl-apagar-me:screen-value in frame {&frame-name})
             de-vl-descto-mo  = dec(de-vl-descto-me:screen-value in frame {&frame-name}).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).
  if  RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.

  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */
  /* Code placed here will execute AFTER standard behavior.    */
  if  avail docum-est then
      assign dupli-apagar.ep-codigo        = param-global.empresa-prin
             dupli-apagar.cod-estabel      = docum-est.cod-estabel
             dupli-apagar.valor-a-pagar-me = dupli-apagar.vl-a-pagar.

  /*
  ** Integracao Modulo Importacao
  */
  if l-imp and c-embarque <> "":U then do:
    {rep/re1001c.i51 "no"}
    {cdp/cd4300.i4  "no" dupli-apagar.char-1}
  end.

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

  /* Code placed here will execute AFTER standard behavior.    */
  if  avail docum-est then
      assign dupli-apagar.cod-emitente     = docum-est.cod-emitente
             dupli-apagar.nat-operacao     = docum-est.nat-operacao
             dupli-apagar.serie-docto      = docum-est.serie-docto
             dupli-apagar.nro-docto        = docum-est.nro-docto.

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

  /*
  ** Integracao Modulo Importacao
  */
  if l-imp then do:

    assign i-moeda         = 0
           c-desc-moeda    = ""
           de-vl-apagar-me = 0
           de-vl-descto-me = 0.
    if not adm-new-record then do:

        {rep/re1001c.i50}                
        {cdp/cd4300.i4  "yes" dupli-apagar.char-1}
        {rep/re1001c.i51 "yes"}

        assign i-moeda         = i-mo-codigo
               de-vl-apagar-me = de-vl-a-pagar-mo
               de-vl-descto-me = de-vl-descto-mo.

        find moeda
            where moeda.mo-codigo = i-moeda no-lock no-error.
        if avail moeda then 
            assign c-desc-moeda = moeda.descricao.
    end.
    disp i-moeda
         c-desc-moeda
         de-vl-apagar-me
         de-vl-descto-me with frame {&frame-name}.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).

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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  if avail dupli-apagar and dupli-apagar.vl-desconto > 0 then do:
      enable dupli-apagar.dt-venc-desc with frame {&frame-name}.
  end.
  assign dupli-apagar.cod-ret-irf:sensitive in frame {&FRAME-NAME} = no.
  find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
  if avail docum-est then do:
    find emitente where emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.
    if avail emitente then assign dupli-apagar.cod-ret-irf:sensitive in frame {&frame-name} = emitente.ind-rendiment.
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

  /* Code placed here will execute AFTER standard behavior.    */    

  /* 
  ** Integracao Modulo Importacao 
  */
  find first param-global no-lock no-error.
  if avail param-global and 
     param-global.modulo-07 then 
    assign l-imp = yes.
  else 
    assign l-imp =  no.      
  if not l-imp then
    assign i-moeda:hidden in frame {&frame-name}         = yes
           c-desc-moeda:hidden in frame {&frame-name}    = yes
           de-vl-apagar-me:hidden in frame {&frame-name} = yes
           de-vl-descto-me:hidden in frame {&frame-name} = yes.  
  else           
    assign i-moeda:hidden in frame {&frame-name}         = no
           c-desc-moeda:hidden in frame {&frame-name}    = no
           de-vl-apagar-me:hidden in frame {&frame-name} = no
           de-vl-descto-me:hidden in frame {&frame-name} = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  assign gr-dupli-apagar = rowid(dupli-apagar).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executa-consistencia V-table-Win 
PROCEDURE pi-executa-consistencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter l-consiste-total as logical no-undo.

assign l-consiste = l-consiste-total.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  def var c-cod-rend   as character no-undo.
  def var i-nr-horas   as decimal   no-undo.
  def var de-tot-dupli as decimal   no-undo.
  def var l-ok         as logical   no-undo.

  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

  if  l-inclui then do:
      find b-dupli no-lock where
           b-dupli.cod-emitente = docum-est.cod-emitente      and
           b-dupli.nat-operacao = docum-est.nat-operacao      and
           b-dupli.serie-docto  = docum-est.serie-docto       and
           b-dupli.nro-docto    = docum-est.nro-docto         and
           b-dupli.parcela      = input frame {&frame-name} dupli-apagar.parcela no-error.
      if  avail b-dupli then do: 
          {include/i-vldprg.i} 
          {utp/ut-table.i mgind dupli-apagar 1}
          run utp/ut-msgs.p (input "show":U, input 7, input return-value).
          apply "entry":U to dupli-apagar.parcela in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      find espec-ap where 
           espec-ap.cod-esp = input frame {&frame-name} dupli-apagar.cod-esp
           no-lock no-error.
      if  not avail espec-ap then do:
          {include/i-vldprg.i} 
          {utp/ut-table.i mgadm espec-ap 1}
          run utp/ut-msgs.p (input "show":U, input 7, input return-value).
          apply "entry":U to dupli-apagar.cod-esp in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if  espec-ap.tipo = 2 then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 625, input "").
          apply "entry" to dupli-apagar.cod-esp in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      find first b-dupli 
           where b-dupli.cod-emitente = docum-est.cod-emitente 
             and b-dupli.serie-docto  = docum-est.serie-docto
             and b-dupli.nro-docto    = docum-est.nro-docto
             and b-dupli.parcela      = input frame {&frame-name} dupli-apagar.parcela
             and b-dupli.cod-esp      = input frame {&frame-name} dupli-apagar.cod-esp
                 no-lock no-error.
      if  avail b-dupli then do:
          {include/i-vldprg.i} 
          {utp/ut-table.i mgind dupli-apagar 1}
          run utp/ut-msgs.p (input "show":U, input 7, input return-value).
          apply "entry":U to dupli-apagar.parcela in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      find       lin-i-ap 
           where lin-i-ap.ep-codigo   = param-global.empresa-prin
             and lin-i-ap.cod-estabel = docum-est.cod-estabel
             and lin-i-ap.cod-esp     = input frame {&frame-name} dupli-apagar.cod-esp
             and lin-i-ap.serie       = docum-est.serie-docto
             and lin-i-ap.nr-docto    = input frame {&frame-name} dupli-apagar.nr-duplic
             and lin-i-ap.parcela     = input frame {&frame-name} dupli-apagar.parcela
             and lin-i-ap.cod-fornec  = docum-est.cod-emitente
                 no-lock no-error.
      if  avail lin-i-ap then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 5402, "").
          apply "entry":U to dupli-apagar.parcela in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      find       tit-ap 
           where tit-ap.ep-codigo   = param-global.empresa-prin
             and tit-ap.cod-estabel = docum-est.cod-estabel
             and tit-ap.cod-esp     = input frame {&frame-name} dupli-apagar.cod-esp
             and tit-ap.serie       = docum-est.serie-docto
             and tit-ap.nr-docto    = input frame {&frame-name} dupli-apagar.nr-duplic
             and tit-ap.parcela     = input frame {&frame-name} dupli-apagar.parcela
             and tit-ap.cod-fornec  = docum-est.cod-emitente
                 no-lock no-error.
      if  avail tit-ap then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 6214, "").
          if  return-value = "no" then do:
              apply "entry":U to dupli-apagar.parcela in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.    
      end.
  end.
  find tipo-rec-desp where
       tipo-rec-desp.tp-codigo = input frame {&frame-name} dupli-apagar.tp-despesa no-lock no-error.
  if  not avail tipo-rec-desp then do:
      {include/i-vldprg.i} 
      {utp/ut-table.i mgadm tipo-rec-desp 1}
      run utp/ut-msgs.p (input "show":U, input 7, input return-value).
      apply "entry":U to dupli-apagar.tp-despesa in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.     
  if  tipo-rec-desp.tipo = 1 then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 4995, "").
      apply "entry":U to dupli-apagar.tp-despesa in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  input frame {&frame-name} dupli-apagar.dt-emissao < today - param-re.var-emis
  or  input frame {&frame-name} dupli-apagar.dt-emissao > today then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 614, "").
      apply "entry":U to dupli-apagar.dt-emissao in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if input frame {&frame-name} dupli-apagar.dt-emissao >
     input frame {&frame-name} dupli-apagar.dt-vencim then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 1031, "").
      apply "entry":U to dupli-apagar.dt-vencim in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  input frame {&frame-name} dupli-apagar.dt-trans > today
  or  input frame {&frame-name} dupli-apagar.dt-trans < 
      input frame {&frame-name} dupli-apagar.dt-emissao then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 1788, "").
      apply "entry":U to dupli-apagar.dt-trans in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  fn-calcula-vencimento() <> input frame {&frame-name} dupli-apagar.dt-vencim
  then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 6252, "").
      if  return-value = "no" then do:
          apply "entry":U to dupli-apagar.dt-vencim in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      else
          run rep/re9995.p (input rowid(docum-est),
                            input 0,
                            input 0,
                            input 6252, 
                            input no,
                            input 1, 
                            input 2).    
  end.
  else
      run rep/re9995.p (input rowid(docum-est),
                            input 0,
                            input 0,
                            input 6252, 
                            input yes,
                            input 1, 
                            input 2). 
  if  avail param-ap 
  and input frame {&frame-name} dupli-apagar.dt-vencim < param-ap.dt-ult-fec
  then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 633, "").
      apply "entry":U to dupli-apagar.dt-vencim in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  dupli-apagar.parcela:sensitive in frame {&frame-name} then   
      find first b-dupli no-lock
           where b-dupli.cod-emitente = docum-est.cod-emitente 
           and   b-dupli.nat-operacao = docum-est.nat-operacao
           and   b-dupli.serie-docto  = docum-est.serie-docto
           and   b-dupli.nro-docto    = docum-est.nro-docto
           and  (b-dupli.dt-vencim    = input frame {&frame-name} dupli-apagar.dt-vencim
            or  (b-dupli.dt-vencim    > input frame {&frame-name} dupli-apagar.dt-vencim
            and  b-dupli.parcela      < input frame {&frame-name} dupli-apagar.parcela)) no-error.
  else
      find first b-dupli no-lock
           where b-dupli.cod-emitente = docum-est.cod-emitente 
           and   b-dupli.nat-operacao = docum-est.nat-operacao
           and   b-dupli.serie-docto  = docum-est.serie-docto
           and   b-dupli.nro-docto    = docum-est.nro-docto
           and   rowid(b-dupli)      <> rowid(dupli-apagar)
           and  (b-dupli.dt-vencim    = input frame {&frame-name} dupli-apagar.dt-vencim
            or  (b-dupli.dt-vencim    > input frame {&frame-name} dupli-apagar.dt-vencim
            and  b-dupli.parcela      < input frame {&frame-name} dupli-apagar.parcela)) no-error.
  if  avail b-dupli then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 6253, input "").
  end.
  if  input frame {&frame-name} dupli-apagar.vl-a-pagar <= 0 then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 309, "").
      apply "entry":U to dupli-apagar.vl-a-pagar in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  assign de-tot-dupli = 0.
  for each b-dupli 
     where b-dupli.cod-emitente = docum-est.cod-emitente 
       and b-dupli.nat-operacao = docum-est.nat-operacao
       and b-dupli.serie-docto  = docum-est.serie-docto
       and b-dupli.nro-docto    = docum-est.nro-docto no-lock:
      if  l-inclui = no
      and rowid(b-dupli) = rowid(dupli-apagar) then
          next. 
      assign de-tot-dupli = de-tot-dupli + b-dupli.vl-a-pagar.
  end.
  if  input frame {&frame-name} dupli-apagar.vl-a-pagar + de-tot-dupli
  <>  docum-est.tot-valor 
  and l-consiste then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 15228, "").
      if  return-value = "no" then do:
          apply "entry":U to dupli-apagar.vl-a-pagar in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
  end.
  if  avail param-ap then do:
      if  input frame {&frame-name} dupli-apagar.dt-venc-desc < param-ap.dt-ult-fec
      then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 633, "").
          apply "entry":U to dupli-apagar.dt-venc-desc in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if  param-ap.prazo-implantacao then do:
          for each calen-coml 
             where calen-coml.ep-codigo   = i-ep-codigo-usuario
               and calen-coml.cod-estabel = docum-est.cod-estabel 
               and calen-coml.data       >= TODAY
               and calen-coml.data       <= input frame {&frame-name} dupli-apagar.dt-vencim 
               and calen-coml.tipo-dia    = 1 no-lock:
              assign i-nr-horas = (input frame {&frame-name} dupli-apagar.dt-vencim - TODAY) * 24.
          end.
          if  i-nr-horas < param-ap.nr-horas then do: 
              find usuar-permissao-ap where 
                   usuar-permissao-ap.usuario = c-seg-usuario no-lock no-error.
              assign i-nr-horas = 0.         
              if  avail usuar-permissao-ap and usuar-permissao-ap.liberar then do:
                  run utp/ut-msgs.p (input "show", input 8220, input " ").                             
                  if  return-value = "no" then do:
                      apply "entry" to dupli-apagar.dt-vencim.
                      return 'ADM-ERROR':U.
                  end. 
              end.
              else do:
                  run utp/ut-msgs.p (input "show", input 8234, input " ").                             
                  if  return-value = "yes" then do:
                      run app/ap0501g.w (output l-ok).
                      if  l-ok = no then do:
                          apply "entry" to dupli-apagar.dt-vencim.
                          return 'ADM-ERROR':U.
                      end.
                  end.  
                  else do: 
                      apply "entry" to dupli-apagar.dt-vencim.
                      return 'ADM-ERROR':U.
                  end.   
              end.
          end.
      end.
  end.

  assign c-cod-rend  = "0561,0588,2063,2281,1283,0730,8053,3426,2103,3674,0924,"
                     + "3208,0764,3277,0297,3251,3223,3264,3249,0916,8045,1708,"
                     + "3280,0422,0481,0430,0490,0473,0190,0246,6015,4600,3317,"
                     + "4424,9991".
  if dupli-apagar.cod-ret-irf:sensitive in frame {&FRAME-NAME} 
  then do:
      if lookup(string(input frame {&frame-name} dupli-apagar.cod-ret-irf,"9999"), c-cod-rend) = 0
      then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 843, 
                      input (input frame {&frame-name} dupli-apagar.cod-ret-irf) ).
          if  return-value = "no" then do:
              apply "entry":U to dupli-apagar.cod-ret-irf in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.   
      end.
  end.

  /*
  ** Importaá∆o 
  */
  {rep/re1001a.i50}
  {cdp/cd4300.i4 "yes" docum-est.char-1}
  {rep/re1001a.i51 "yes"}
  if l-imp and c-embarque <> "":U then do:
    if not can-find(moeda 
                        where moeda.mo-codigo = int(i-moeda:screen-value in frame {&frame-name})) then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, input 4929, "").
        apply "entry":U to i-moeda in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.  
    if dec(de-vl-apagar-me:screen-value in frame {&frame-name}) = 0 or
      (de-vl-apagar-me:screen-value in frame {&frame-name}) = " " then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, input 17527, "").
        apply "entry":U to de-vl-apagar-me in frame {&frame-name}.
        return 'ADM-ERROR':U.
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
  {src/adm/template/snd-list.i "dupli-apagar"}

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


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-calcula-vencimento V-table-Win 
FUNCTION fn-calcula-vencimento RETURNS DATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var c-numeros  as character         no-undo initial "1,2,3,4,5,6,7,8,9,0".
  def var de-perc    as decimal extent 6  no-undo.  
  def var da-data    as date    extent 12 no-undo.
  def var da-partida as date              no-undo.
  def var i-parcela  as integer           no-undo.
  def var i-num-parc as integer           no-undo.
  def var i-ind      as integer           no-undo.
  def var i-avanco   as integer           no-undo.

  find first item-doc-est
       where item-doc-est.cod-emitente = docum-est.cod-emitente
         and item-doc-est.nat-operacao = docum-est.nat-operacao 
         and item-doc-est.serie-docto  = docum-est.serie-docto 
         and item-doc-est.nro-docto    = docum-est.nro-docto
         and item-doc-est.num-pedido   > 0 no-lock no-error.
  if  not available item-doc-est then do:
      find emitente where 
           emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.
      find cond-pagto where cond-pagto.cod-cond-pag = emitente.cod-cond-pag
           no-lock no-error.
  end.
  else do:
      find pedido-compr where pedido-compr.num-pedido = item-doc-est.num-pedido
           no-lock no-error.
      find cond-pagto where cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag
           no-lock no-error.
  end.

  if  not avail cond-pagto then do:
      find cond-especif where cond-especif.num-pedido = item-doc-est.num-pedido
           no-lock no-error.
      assign i-num-parc = 0.
      if  not avail cond-especif then 
          assign da-data = today.
      else do i-ind = 1 to 6:
          if  cond-especif.data-pagto[i-ind] <> ? then
              assign da-data[i-ind] = cond-especif.data-pagto[i-ind]
                     de-perc[i-ind] = cond-especif.perc-pagto[i-ind]
                     i-num-parc     = i-num-parc + 1.
      end.
  end.
  else do:
      assign da-data    = today
             da-partida = docum-est.dt-emissao
             i-num-parc = cond-pagto.num-parcelas.
      find first emitente no-lock
          where emitente.cod-emitente = docum-est.cod-emitente no-error.                 
      {cdp/cd9020.i7 docum-est.cod-estabel}
  end.

  assign i-parcela = 0.
  do  with frame {&frame-name}:
      if  can-do(c-numeros,substring(input dupli-apagar.parcela,1,1)) then
          assign i-parcela = int(substring(input dupli-apagar.parcela,1,1)).
      if  can-do(c-numeros,substring(input dupli-apagar.parcela,2,1)) then
          assign i-parcela = i-parcela * 10
                           + int(substring(input dupli-apagar.parcela,2,1)).
  end.

  if  i-parcela > i-num-parc or i-parcela = 0 then do:
      find last b-dupli
          where b-dupli.cod-emitente = docum-est.cod-emitente
            and b-dupli.nat-operacao = docum-est.nat-operacao 
            and b-dupli.serie-docto  = docum-est.serie-docto 
            and b-dupli.nro-docto    = docum-est.nro-docto no-lock no-error.
      if  avail b-dupli then
          RETURN b-dupli.dt-vencim.
      else
          RETURN today.
  end.    
  else
      RETURN da-data[i-parcela].

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


