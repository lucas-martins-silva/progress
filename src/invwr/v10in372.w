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
{include/i-prgvrs.i V10IN372 2.00.00.016 } /*** "010016" 13/06/2024 12:14:26  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v10in372 MUT}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1998)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

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

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

/* Parameters Definitions ---                                           */
def var r-row-recebimento as rowid no-undo.

/* Local Variable Definitions ---                                       */
def var de-preco-conv as decimal no-undo.
def var de-val-tot as decimal no-undo.
def var l-modulo-ge as logical no-undo.
def var de-pre-ncz as decimal no-undo.
def var de-indice as decimal no-undo.
def var de-qtd-maxima-rec as decimal no-undo.
def var de-pre-maximo-rec as decimal no-undo.
def var de-saldo-forn as decimal no-undo.
def var de-qtd-tot as decimal no-undo.

def new shared var r-gerencial as rowid.
def new shared var c-gerencial as char.

{cep/ce1234.i}  /* Valida‡Æo Decimais */

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
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-6 RECT-7 de-qtd-rec-forn ~
de-valor-total c-un-nova 
&Scoped-Define DISPLAYED-OBJECTS i-num-pedido i-numero-ordem i-parcela ~
i-cod-emitente c-nome-fornec c-it-codigo c-nome-item c-un c-narrativa ~
tb-transf-drb de-qtd-sal-forn de-perc-descto de-pre-unit-for ~
de-aliquota-ipi i-mo-codigo c-nome-moeda de-aliquota-icm de-preco-unit ~
de-aliquota-iss de-qtd-rec-forn de-valor-total c-un-nova ~
de-pre-unit-for-novo 

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
DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE c-narrativa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-fornec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "xx" 
     LABEL "Unidade de Medida":R21 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .88.

DEFINE VARIABLE c-un-nova AS CHARACTER FORMAT "xx" 
     LABEL "Unidade de Medida":R21 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88.

DEFINE VARIABLE de-aliquota-icm AS DECIMAL FORMAT "->>,>>9.99" INITIAL 17 
     LABEL "Aliquota ICMS":R16 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88.

DEFINE VARIABLE de-aliquota-ipi AS DECIMAL FORMAT "->>,>>9.99" INITIAL 10 
     LABEL "Aliquota IPI":R15 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88.

DEFINE VARIABLE de-aliquota-iss AS DECIMAL FORMAT "->>,>>9.99" INITIAL 6 
     LABEL "Aliquota ISS":R15 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88.

DEFINE VARIABLE de-perc-descto AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Percentual Desconto":R23 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .88.

DEFINE VARIABLE de-pre-unit-for AS DECIMAL FORMAT ">>>,>>>,>>9.99999" INITIAL 0 
     LABEL "Preco Unit Fornec":R21 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE de-pre-unit-for-novo AS DECIMAL FORMAT ">>>,>>>,>>9.99999" INITIAL 0 
     LABEL "Preco Unit Fornec":R21 
     VIEW-AS FILL-IN 
     SIZE 19.72 BY .88.

DEFINE VARIABLE de-preco-unit AS DECIMAL FORMAT ">>>,>>>,>>9.99999" INITIAL 0 
     LABEL "Preco Unitario":R17 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE de-qtd-rec-forn AS DECIMAL FORMAT ">>>>,>>9.9999" INITIAL 0 
     LABEL "Qt Recebida Fornec":R22 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88.

DEFINE VARIABLE de-qtd-sal-forn AS DECIMAL FORMAT ">>>>,>>9.9999" INITIAL 0 
     LABEL "Qtd Saldo Fornec":R20 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88.

DEFINE VARIABLE de-valor-total AS DECIMAL FORMAT ">>>,>>>,>>9.9999" INITIAL 0 
     LABEL "Valor Total":R14 
     VIEW-AS FILL-IN 
     SIZE 19.72 BY .88.

DEFINE VARIABLE i-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor":R12 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88.

DEFINE VARIABLE i-mo-codigo AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Moeda":R7 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88.

DEFINE VARIABLE i-num-pedido AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Pedido":R8 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .88.

DEFINE VARIABLE i-numero-ordem AS INTEGER FORMAT "zzzzz9,99" INITIAL 0 
     LABEL "Ordem Compra" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88.

DEFINE VARIABLE i-parcela AS INTEGER FORMAT "->,>>>,>>9" INITIAL 1 
     LABEL "Parcela":R9 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 4.58.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 4.58.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 2.58.

DEFINE VARIABLE tb-transf-drb AS LOGICAL INITIAL no 
     LABEL "Transferˆncia DIT" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-num-pedido AT ROW 1.29 COL 9.43 COLON-ALIGNED
     i-numero-ordem AT ROW 1.29 COL 39.57 COLON-ALIGNED
     i-parcela AT ROW 2.29 COL 9.43 COLON-ALIGNED
     i-cod-emitente AT ROW 2.29 COL 39.57 COLON-ALIGNED
     c-nome-fornec AT ROW 2.29 COL 51.43 COLON-ALIGNED NO-LABEL
     c-it-codigo AT ROW 3.29 COL 9.43 COLON-ALIGNED
     c-nome-item AT ROW 3.29 COL 27.43 COLON-ALIGNED NO-LABEL
     c-un AT ROW 3.29 COL 79.43 COLON-ALIGNED
     c-narrativa AT ROW 4.29 COL 9.43 COLON-ALIGNED NO-LABEL
     tb-transf-drb AT ROW 4.42 COL 62.57 WIDGET-ID 2
     de-qtd-sal-forn AT ROW 6.13 COL 21.43 COLON-ALIGNED
     de-perc-descto AT ROW 6.13 COL 75.43 COLON-ALIGNED
     de-pre-unit-for AT ROW 7.13 COL 21.43 COLON-ALIGNED
     de-aliquota-ipi AT ROW 7.13 COL 75.43 COLON-ALIGNED
     i-mo-codigo AT ROW 8.13 COL 21.43 COLON-ALIGNED
     c-nome-moeda AT ROW 8.13 COL 25.43 COLON-ALIGNED NO-LABEL
     de-aliquota-icm AT ROW 8.13 COL 75.43 COLON-ALIGNED
     de-preco-unit AT ROW 9.13 COL 21.43 COLON-ALIGNED
     de-aliquota-iss AT ROW 9.13 COL 75.43 COLON-ALIGNED
     de-qtd-rec-forn AT ROW 11 COL 21.43 COLON-ALIGNED
     de-valor-total AT ROW 11 COL 65.86 COLON-ALIGNED
     c-un-nova AT ROW 12 COL 21.43 COLON-ALIGNED
     de-pre-unit-for-novo AT ROW 12 COL 65.86 COLON-ALIGNED
     RECT-4 AT ROW 1 COL 1
     RECT-6 AT ROW 5.79 COL 1
     RECT-7 AT ROW 10.67 COL 1
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
         HEIGHT             = 12.46
         WIDTH              = 88.72.
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

/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-narrativa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-fornec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-aliquota-icm IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       de-aliquota-icm:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN de-aliquota-ipi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-aliquota-iss IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       de-aliquota-iss:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN de-perc-descto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-pre-unit-for IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-pre-unit-for-novo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-preco-unit IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qtd-sal-forn IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-mo-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-num-pedido IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-numero-ordem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-parcela IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-transf-drb IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       tb-transf-drb:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME c-un-nova
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un-nova V-table-Win
ON LEAVE OF c-un-nova IN FRAME f-main /* Unidade de Medida */
DO:

    if available prazo-compra then
    assign prazo-compra.qtd-rec-forn = prazo-compra.qtd-rec-forn +
                    (input frame {&frame-name} de-qtd-rec-forn -
                     recebimento.qtd-rec-forn).

    assign recebimento.qtd-rec-forn = input frame {&frame-name} de-qtd-rec-forn.                                 

    if item.tipo-contr <> 4 then do:
        if avail cotacao-item then do:
            if cotacao-item.un <> input frame {&frame-name} c-un-nova then do:
                run utp/ut-msgs.p (input "show", 
                                   input 2391, 
                                   input "").
                apply "close" to this-procedure.
            end.
        end.
    end.
    else do:
        if  avail item-fornec and
            item-fornec.un <> input frame {&frame-name} c-un-nova then do:            
            run utp/ut-msgs.p (input "show", 
                               input 2244, 
                               input "").
            apply "close" to this-procedure.
        end.
    end.

    assign prazo-compra.quant-receb = prazo-compra.quant-receb -
                    recebimento.quant-receb.

    &if defined(bf_mat_contratos) &then
    if ordem-compra.nr-contrato <> 0 then
    &else
    if ordem-compra.nr-contrato <> "" then
    &endif
        assign ordem-compra.qt-acum-rec = ordem-compra.qt-acum-rec -
                    recebimento.quant-receb.

    assign recebimento.quant-receb = input frame {&frame-name} de-qtd-rec-forn / de-indice
           prazo-compra.quant-receb = prazo-compra.quant-receb +
                recebimento.quant-receb.
    &if defined(bf_mat_contratos) &then
    if ordem-compra.nr-contrato <> 0 then
    &else
    if ordem-compra.nr-contrato <> "" then
    &endif
        assign ordem-compra.qt-acum-rec = ordem-compra.qt-acum-rec +
            recebimento.quant-receb.                                                                  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-qtd-rec-forn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-qtd-rec-forn V-table-Win
ON LEAVE OF de-qtd-rec-forn IN FRAME f-main /* Qt Recebida Fornec */
DO:

    if input frame {&frame-name} de-pre-unit-for-novo > 0 then
    display input frame {&frame-name} de-qtd-rec-forn * input frame {&frame-name} de-pre-unit-for-novo 
            @ de-valor-total with frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-valor-total
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor-total V-table-Win
ON LEAVE OF de-valor-total IN FRAME f-main /* Valor Total */
DO:

    display input frame {&frame-name} de-valor-total / 
            input frame {&frame-name} de-qtd-rec-forn @ de-pre-unit-for-novo
            with frame {&frame-name}.

    if available param-compra then            
        assign de-pre-maximo-rec = (input frame {&frame-name} de-qtd-rec-forn * input frame {&frame-name} de-pre-unit-for) *
                                   (param-compra.var-preco / 100 + 1).
    else
        apply "close" to this-procedure.

    if input frame {&frame-name} de-valor-total > de-pre-maximo-rec then do:
        run utp/ut-msgs.p (input "show", 
                           input 3718, 
                           input "").
        if return-value = "no" then do:
           apply "entry" to de-valor-total in frame {&frame-name}.
           return no-apply.
        end.
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

    find first param-compra no-lock no-error.
    if not avail param-compra then do:
       run utp/ut-msgs.p (input "show",
                          input 2587,
                          input "").
       return.
    end.

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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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
    if adm-new-record = yes then
    &if  defined(ADM-MODIFY-FIELDS) &then
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

  {utp/ut-field.i mgind recebimento num-pedido 1}
  assign i-num-pedido:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento it-codigo 1}
  assign c-it-codigo:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento cod-emitente 1}
  assign i-cod-emitente:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento parcela 1}
  assign i-parcela:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Unidade_de_Medida} 
  assign c-un:label in frame {&FRAME-NAME} = trim(return-value)
         c-un-nova:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Qtd_Saldo_Fornec}
  assign de-qtd-sal-forn:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento pre-unit-for 1}
  assign de-pre-unit-for:label in frame {&FRAME-NAME} = trim(return-value)
         de-pre-unit-for-novo:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind cotacao-item mo-codigo 1}
  assign i-mo-codigo:label in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-field.i mgind recebimento preco-unit 2}
  assign de-preco-unit:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Percentual_Desconto}
  assign de-perc-descto:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento aliquota-ipi 1}
  assign de-aliquota-ipi:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento aliquota-icm 1}
  assign de-aliquota-icm:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento aliquota-iss 1}
  assign de-aliquota-iss:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Qt_Recebida_Fornec}
  assign de-qtd-rec-forn:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind recebimento valor-total 1}
  assign de-valor-total:label in frame {&FRAME-NAME} = trim(return-value).


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    find first param-compra no-lock no-error.

    find first param-ge where param-ge.ep-codigo = param-global.empresa-prin no-lock no-error.

    find first param-global no-lock no-error.
    find first param-compra no-lock no-error.

    find param-ge where param-ge.ep-codigo = param-global.empresa-prin no-lock no-error.

    assign l-modulo-ge = if avail param-ge 
             then if param-ge.tp-atualizacao = 1
                     then (search("gep/ge0102a.p") <> ? or 
                           search("gep/ge0102a.r") <> ?)
                     else no
             else no.

    IF i-pais-impto-usuario <> 1 /* Brasil */ THEN
        ASSIGN tb-transf-drb:HIDDEN IN FRAME {&FRAME-NAME} = NO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-rowid V-table-Win 
PROCEDURE pi-recebe-rowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-row-recebimento as rowid no-undo.

assign r-row-recebimento = p-row-recebimento.

RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

find recebimento where rowid(recebimento) = r-row-recebimento no-error.
    if available recebimento then do:
        find ordem-compra where ordem-compra.numero-ordem = recebimento.numero-ordem EXCLUSIVE-LOCK no-error.
        find prazo-compra where prazo-compra.numero-ordem = recebimento.numero-ordem and
                                prazo-compra.parcela      = recebimento.parcela EXCLUSIVE-LOCK no-error.
        find item where item.it-codigo = ordem-compra.it-codigo no-error.
        find first emitente where emitente.cod-emitente = recebimento.cod-emitente no-lock no-error.                                
        if l-modulo-ge = yes then do:
            {utp/ut-liter.i elim-recebimento * R}
            assign c-gerencial = return-value
                   r-gerencial = rowid(ordem-compra).
            run gep/ge0102a.p (input r-gerencial,
                               input 13).
        end.            

        display ordem-compra.num-pedido @ i-num-pedido with frame {&frame-name}.
        display ordem-compra.cod-emitente @ i-cod-emitente with frame {&frame-name}.
        display emitente.nome-abrev @ c-nome-fornec with frame {&frame-name}.
        display prazo-compra.numero-ordem @ i-numero-ordem with frame {&frame-name}.
        display prazo-compra.parcela @ i-parcela with frame {&frame-name}.
        display item.it-codigo @ c-it-codigo with frame {&frame-name}.
        display item.desc-item @ c-nome-item with frame {&frame-name}.
        display prazo-compra.un @ c-un with frame {&frame-name}.

        display item.desc-item @ c-narrativa with frame {&frame-name}.

        find moeda where moeda.mo-codigo = ordem-compra.mo-codigo no-lock no-error.
        display ordem-compra.mo-codigo @ i-mo-codigo with frame {&frame-name}.
        display moeda.descricao @ c-nome-moeda with frame {&frame-name}.

        run cdp/cd0812.p (input ordem-compra.mo-codigo,
                          input 0,
                          input ordem-compra.pre-unit-for,
                          input recebimento.data-nota,
                          output de-pre-ncz).

        display prazo-compra.qtd-sal-forn @ de-qtd-sal-forn with frame {&frame-name}.
        display ordem-compra.pre-unit-for @ de-pre-unit-for with frame {&frame-name}.
        display de-pre-ncz @ de-preco-unit with frame {&frame-name}.
        display ordem-compra.aliquota-ipi @ de-aliquota-ipi with frame {&frame-name}.
        display ordem-compra.perc-descto  @ de-perc-descto with frame {&frame-name}.
        display recebimento.qtd-rec-forn @ de-qtd-rec-forn with frame {&frame-name}.
        display recebimento.valor-total @ de-valor-total with frame {&frame-name}.                                          
        display recebimento.valor-total / recebimento.qtd-rec-forn @ de-pre-unit-for-novo with frame {&frame-name}.
       assign 
         de-aliquota-icm:screen-value in frame {&FRAME-NAME} = string(ordem-compra.aliquota-icm)
         de-aliquota-iss:screen-value in frame {&FRAME-NAME} = string(ordem-compra.aliquota-iss).

        assign de-indice = 1.
        if item.tipo-contr <> 4 then do:
           find item-fornec where item-fornec.cod-emitente = ordem-compra.cod-emitente and
                                  item-fornec.it-codigo    = ordem-compra.it-codigo no-lock no-error.        
           if available item-fornec then do:
              assign de-indice = item-fornec.fator-conver / 
                                 if item-fornec.num-casa-dec = 0 then 1
                                 else exp(10,item-fornec.num-casa-dec).
              display item-fornec.un @ c-un-nova with frame {&frame-name}.
           end.   
        end.
        else do:
            find cotacao-item use-index ordem-compra where cotacao-item.numero-ordem = ordem-compra.numero-ordem and
                                        cotacao-item.cod-emitente = ordem-compra.cod-emitente and
                                        cotacao-item.data-cotacao = ordem-compra.data-cotacao no-lock no-error.
            if available cotacao-item then                                        
                display cotacao-item.un @ c-un-nova with frame {&frame-name}.
            if available cotacao-item then do:        
                if cotacao-item.un <> prazo-compra.un then do:

                    find tab-conv-un where tab-conv-un.un = prazo-compra.un and
                                           tab-conv-un.unid-med-for = cotacao-item.un no-lock no-error.
                    assign de-indice = if available tab-conv-un then
                        tab-conv-un.fator-conver / exp(10,tab-conv-un.num-casa-dec)
                        else 1.
                end.
            end.
        end.
        assign de-val-tot = recebimento.qtd-rec-forn.

        IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
            FOR FIRST ordens-embarque NO-LOCK
                WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem
                AND   ordens-embarque.parcela      = prazo-compra.parcela: END.
            IF AVAIL ordens-embarque THEN
                IF CAN-FIND(FIRST embarq-import-docto
                            WHERE embarq-import-docto.cod-estab        = ordens-embarque.cod-estabel
                              and embarq-import-docto.cod-embarq       = ordens-embarque.embarque   
                              and embarq-import-docto.cod-ser-docto    = recebimento.serie-docto      
                              and embarq-import-docto.cod-docto        = recebimento.numero-nota      
                              and embarq-import-docto.cdn-emitente     = recebimento.cod-emitente     
                              and embarq-import-docto.cod-natur-operac = recebimento.nat-operacao
                              and embarq-import-docto.log-transf-draw) THEN
                    ASSIGN tb-transf-drb:CHECKED IN FRAME {&FRAME-NAME} = YES.
                ELSE
                    ASSIGN tb-transf-drb:CHECKED IN FRAME {&FRAME-NAME} = NO.
            ELSE
                ASSIGN tb-transf-drb:CHECKED IN FRAME {&FRAME-NAME} = NO.

        END.

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
    if  not avail param-compra then
        find first param-compra no-lock no-error.

    {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */

    assign l-rejeita-dec  = no.
    assign de-valor-total:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-valor-total,input frame {&frame-name} i-mo-codigo)).

    if  l-rejeita-dec then do:
        {utp/ut-field.i mgind recebimento valor-total 1}
        run utp/ut-msgs.p(input "show", 
                                   input 18130, 
                                   input trim(return-value)).
        apply 'entry':U to de-valor-total in frame {&frame-name}.
        return "ADM-ERROR":U.
    end.


    /* Consiste saldo da parcela */
    de-qtd-maxima-rec = prazo-compra.qtd-sal-forn * (param-compra.var-quantid / 100 + 1).
    if input frame {&frame-name} de-qtd-rec-forn - recebimento.qtd-rec-forn > de-qtd-maxima-rec 
    then do:
       run utp/ut-msgs.p ("show",5698,"").
       if not return-value = "yes" then 
          return "adm-error".
    end.

    assign recebimento.preco-unit = input frame {&frame-name} de-pre-unit-for-novo * de-indice  
           prazo-compra.quant-saldo = prazo-compra.quantidade - (prazo-compra.quant-receb
                                                              -  recebimento.quant-rejei)
           de-saldo-forn = prazo-compra.qtd-do-forn - (prazo-compra.qtd-rec-forn
                                                    -  prazo-compra.qtd-rej-forn).

    if de-saldo-forn < 0 then
        assign de-saldo-forn = 0.
    assign de-qtd-tot = input frame {&frame-name} de-qtd-rec-forn
        prazo-compra.qtd-sal-forn = de-saldo-forn.

    if de-saldo-forn = 0 then
        assign prazo-compra.quant-saldo = 0
               prazo-compra.situacao    = 6.               

    run utp/ut-msgs.p (input "show", 
                       input 3719, 
                       input "").
    if return-value = "yes" then 
        assign prazo-compra.situacao = 6.

    assign item.preco-ul-ent = recebimento.preco-unit
           item.data-ult-ent = recebimento.data-movto.

    if ordem-compra.mo-codigo > 0 then do:
        run cdp/cd0812.p (input ordem-compra.mo-codigo,
                          input 0,
                          input ordem-compra.pre-unit-for,
                          input ordem-compra.data-pedido,
                          output de-preco-conv).
        if de-preco-conv = ? then
            assign de-preco-conv = ordem-compra.pre-unit-for.
    end.
    else
        assign de-preco-conv = ordem-compra.pre-unit-for.

    assign de-val-tot = (de-qtd-tot - de-val-tot) * de-preco-conv.

    if l-modulo-ge = yes then do:
        {utp/ut-liter.i recebimento * R}
        assign c-gerencial = return-value
               r-gerencial = rowid(ordem-compra).

        run gep/ge0102a.p (input r-gerencial,
                           input 20).
    end. 

    find first prazo-compra where prazo-compra.numero-ordem = ordem-compra.numero-ordem and
                                  prazo-compra.situacao <> 6 and
                                  prazo-compra.situacao <> 4 no-lock no-error.
    if not available prazo-compra then
        assign ordem-compra.situacao = 6.                                                           

    assign recebimento.qtd-rec-forn = input frame {&frame-name} de-qtd-rec-forn
           recebimento.quant-receb  = recebimento.qtd-rec-forn
           recebimento.valor-total  = input frame {&frame-name} de-valor-total
           recebimento.pre-unit-for = input frame {&frame-name} de-pre-unit-for-novo.        

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

