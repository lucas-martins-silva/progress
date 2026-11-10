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
{include/i-prgvrs.i V01IN642 2.00.00.006 } /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN642 MUT}
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

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

/* Parameters Definitions ---                                           */

def var de-total    as decimal format "->>>,>>>,>>9.9999" no-undo.
def var de-qtde     as decimal format "->>>,>>>,>>9.9999" no-undo.
def var c-periodo   like consumo.periodo no-undo.
def var c-period    like consumo.periodo no-undo.

def temp-table tt-estat-cc-cmp-fx no-undo
        field  cod-estabel       like estat-cc-cmp-fx.cod-estabel
        field  periodo           as character
        field  cod-comprado      like estat-cc-cmp-fx.cod-comprado
        field  cod-faixa         like  estat-cc-faixa.cod-faixa
        field  qtd-ordens-faixa  like estat-cc-cmp-fx.qtd-pec-faixa
        field  vlr-inicio        like estat-cc-faixa.vlr-inicio 
        field  vlr-fim           like estat-cc-faixa.vlr-fim  .

define temp-table tt-estabel no-undo
    field cod-estabel      like estabelec.cod-estabel
    index id cod-estabel.

define temp-table tt-comprador no-undo
    field cod-comprado     like comprador.cod-comprado
    index id cod-comprado.

def var l-entrou     as logical no-undo initial no.

def var de-valor     as dec     no-undo initial 0.
def var l-ok         as logical no-undo.
def var l-continua   as logical no-undo initial yes.
def var l-not-est    as logical no-undo.
def var l-next       as logical no-undo.
def var c-codigo-estabel as char   no-undo.
def var i-conta-points   as integer no-undo.
/* Defini‡Æo de Vari veis para o Gr fico ------------------------------------------*/
{utp/utapi001.i}
{cdp/cdcfgmat.i}

{cep/ce1234.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES estat-cc-compr
&Scoped-define FIRST-EXTERNAL-TABLE estat-cc-compr


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estat-cc-compr.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estat-cc-compr.cod-comprado 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-comprado ~{&FP2}cod-comprado ~{&FP3}
&Scoped-define ENABLED-TABLES estat-cc-compr
&Scoped-define FIRST-ENABLED-TABLE estat-cc-compr
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS estat-cc-compr.cod-estabel ~
estat-cc-compr.periodo estat-cc-compr.cod-comprado 
&Scoped-define DISPLAYED-TABLES estat-cc-compr
&Scoped-define FIRST-DISPLAYED-TABLE estat-cc-compr
&Scoped-Define DISPLAYED-OBJECTS c-desc-comprador 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS estat-cc-compr.cod-estabel ~
estat-cc-compr.periodo 

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
DEFINE VARIABLE c-desc-comprador AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 51.72 BY .88 NO-UNDO.
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estat-cc-compr.cod-estabel AT ROW 1.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     estat-cc-compr.periodo AT ROW 2.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     estat-cc-compr.cod-comprado AT ROW 3.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     c-desc-comprador AT ROW 3.17 COL 35.14 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estat-cc-compr
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
         HEIGHT             = 3.38
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-desc-comprador IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estat-cc-compr.cod-estabel IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN estat-cc-compr.periodo IN FRAME f-main
   NO-ENABLE 1                                                          */
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "estat-cc-compr"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estat-cc-compr"}

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

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}

    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    find estabelec where estabelec.cod-estabel =
         input frame {&FRAME-NAME} estat-cc-comp.cod-estabel no-lock no-error.
    if not available estabelec
    then do:
        run utp/ut-msgs.p (input "show",
                           input 4802,
                           input "").
        apply "entry" to estat-cc-comp.cod-estabel in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.

    find comprador where comprador.cod-comprado =
         input frame {&FRAME-NAME} estat-cc-comp.cod-comprado no-lock no-error.
    if not available comprador
    then do:
        run utp/ut-msgs.p (input "show",
                           input 5936,
                           input "").
        apply "entry" to estat-cc-comp.cod-comprado in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.
    ELSE DO:
        ASSIGN c-desc-comprador:SCREEN-VALUE IN FRAME {&FRAME-NAME} = comprador.nome.
    END.

    if int(substr(string(input frame {&FRAME-NAME} estat-cc-comp.periodo),5,2)) < 1 or 
       int(substr(string(input frame {&FRAME-NAME} estat-cc-comp.periodo),5,2)) > 12
    then do:
        run utp/ut-msgs.p (input "show",
                           input 3767,
                           input "").
        apply "entry" to estat-cc-comp.periodo in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.

    if int(substr(string(input frame {&FRAME-NAME} estat-cc-comp.periodo),1,4)) < 1990 or 
       int(substr(string(input frame {&FRAME-NAME} estat-cc-comp.periodo),1,4)) > year(today) + 1
    then do:
        run utp/ut-msgs.p (input "show",
                           input 1655,
                           input "").
        apply "entry" to estat-cc-comp.periodo in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST comprador FIELDS(nome)
        where comprador.cod-comprado = estat-cc-comp.cod-comprado NO-LOCK: END.

    ASSIGN c-desc-comprador = if avail comprador then comprador.nome ELSE " ".
    DISP c-desc-comprador WITH FRAME {&FRAME-NAME}.    

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
    if adm-new-record = yes then
    &if  defined(ADM-MODIFY-FIELDS) &then
    enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico1 V-table-Win 
PROCEDURE pi-gera-grafico1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.

    def input parameter table for tt-estabel.
    def input parameter table for tt-comprador.

    {utp/ut-liter.i Compradores}
    assign c-tit-x = return-value.

    /* Inicializa temp-tables -----------------------------------------------------*/
    for each tt-dados:      delete tt-dados.     end.
    for each tt-atributos:  delete tt-atributos. end.
    for each tt-points:     delete tt-points.    end.
    for each tt-sets:       delete tt-sets.      end.
    for each tt-erros:      delete tt-erros.     end.

    /* Configura o Gr fico --------------------------------------------------------*/

    {utp/ut-liter.i Valor_Total_Pedidos_por_Comprador}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i Valor}
    assign c-tit-y = return-value.

    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 4
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-x 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>>,>>9.99".

    {utp/ut-liter.i N£mero_Pedidos_Emitidos_por_Comprador}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i N£mero_Pedidos_Compra}
    assign c-tit-y = return-value.

    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 2
           tt-atributos.graphtype             = 4
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 1 
           tt-atributos.bottomtitle           = c-tit-x 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>9".

    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 1.
    create tt-sets.
    assign tt-sets.numgraph   = 2
           tt-sets.numset     = 1.
    assign c-period = 
           string(substr(estat-cc-compr.periodo:screen-value,1,4) +
           string(substr(estat-cc-compr.periodo:screen-value,6,2),"99")).
    find first tt-estabel no-error.
    if not avail tt-estabel then do:
       create tt-estabel.
       assign tt-estabel.cod-estabel = 
              estat-cc-compr.cod-estabel:screen-value in frame {&FRAME-NAME}.
    end.

    find first tt-comprador no-error.
    if not avail tt-comprador then do:
       create tt-comprador.
       assign tt-comprador.cod-comprado = 
              estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}.
    end.

    run pi-gera-tt-points.
    /* Gera o Gr fico -------------------------------------------------------------*/
    run utp/utapi001.p(input table tt-atributos,
                       input table tt-points,
                       input table tt-sets,
                       input table tt-dados,
                       input table tt-ylabels,
                       output table tt-erros).

    if return-value = "NOK" then
       for each tt-erros:
           run utp/ut-msgs.p (input "show",
                              input tt-erros.cod-erro,
                              input "").
       end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico1-junto V-table-Win 
PROCEDURE pi-gera-grafico1-junto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter table for tt-estabel.
    def input parameter table for tt-comprador.

    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.

    {utp/ut-liter.i Valor_Total_X_Num_PEC_Emit_Comprador}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i Valor_x_Mil_/_No_Pedidos}
    assign c-tit-y = return-value.

    {utp/ut-liter.i Compradores}
    assign c-tit-x = return-value.

    /* Inicializa temp-tables -----------------------------------------------------*/
    for each tt-dados:      delete tt-dados.     end.
    for each tt-atributos:  delete tt-atributos. end.
    for each tt-points:     delete tt-points.    end.
    for each tt-sets:       delete tt-sets.      end.
    for each tt-erros:      delete tt-erros.     end.

    /* Configura o Gr fico --------------------------------------------------------*/
    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 3
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-x 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>>,>>9".

    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 1
           tt-sets.LegendText = "Valor x Mil"
           tt-sets.colorset   = 3.
    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 2
           tt-sets.LegendText = "No Pedidos"
           tt-sets.colorset   = 12.
    assign c-period = 
           string(substr(estat-cc-compr.periodo:screen-value,1,4) +
           string(substr(estat-cc-compr.periodo:screen-value,6,2),"99")).

    find first tt-estabel no-error.
    if not avail tt-estabel then do:
       create tt-estabel.
       assign tt-estabel.cod-estabel = 
              estat-cc-compr.cod-estabel:screen-value in frame {&FRAME-NAME}.
    end.

    find first tt-comprador no-error.
    if not avail tt-comprador then do:
       create tt-comprador.
       assign tt-comprador.cod-comprado = 
              estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}.
    end.

    run pi-gera-tt-points-1.

    /* Gera o Gr fico -------------------------------------------------------------*/
    run utp/utapi001.p(input table tt-atributos,
                       input table tt-points,
                       input table tt-sets,
                       input table tt-dados,
                       input table tt-ylabels,
                       output table tt-erros).

    if return-value = "NOK" then
        for each tt-erros:
             run utp/ut-msgs.p (input "show",
                                input tt-erros.cod-erro,
                                input "").
        end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico2 V-table-Win 
PROCEDURE pi-gera-grafico2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter table for tt-estabel.
    def input parameter table for tt-comprador.
    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.

    {utp/ut-liter.i Compradores}
    assign c-tit-x = return-value.

    {utp/ut-liter.i Requisi‡äes_Compra_Recebidas_X_Comprador}
    assign c-tit-graf = return-value.

    /* Inicializa temp-tables -----------------------------------------------------*/
    for each tt-dados:      delete tt-dados.     end.
    for each tt-atributos:  delete tt-atributos. end.
    for each tt-points:     delete tt-points.    end.
    for each tt-sets:       delete tt-sets.      end.
    for each tt-erros:      delete tt-erros.     end.

    /* Configura o Gr fico --------------------------------------------------------*/

    {utp/ut-liter.i Qtde_RCs_Normais}
    assign c-tit-y = return-value.

    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 4
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-x 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>9".

    {utp/ut-liter.i Qtde_RCs_Urgentes}
    assign c-tit-y = return-value.

    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 2
           tt-atributos.graphtype             = 4
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 1 
           tt-atributos.bottomtitle           = c-tit-x 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>9".

    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 1.
    create tt-sets.
    assign tt-sets.numgraph   = 2
           tt-sets.numset     = 1.
    assign c-period = 
           string(substr(estat-cc-compr.periodo:screen-value,1,4) +
           string(substr(estat-cc-compr.periodo:screen-value,6,2),"99")).
    find first tt-estabel no-error.
    if not avail tt-estabel then do:
       create tt-estabel.
       assign tt-estabel.cod-estabel = 
              estat-cc-compr.cod-estabel:screen-value in frame {&FRAME-NAME}.
    end.

    find first tt-comprador no-error.
    if not avail tt-comprador then do:
       create tt-comprador.
       assign tt-comprador.cod-comprado = 
              estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}.
    end.

    run pi-gera-tt-points-2.
    /* Gera o Gr fico -------------------------------------------------------------*/
    run utp/utapi001.p(input table tt-atributos,
                       input table tt-points,
                       input table tt-sets,
                       input table tt-dados,
                       input table tt-ylabels,
                       output table tt-erros).

    if return-value = "NOK" then
        for each tt-erros:
             run utp/ut-msgs.p (input "show",
                                input tt-erros.cod-erro,
                                input "").
        end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico2-junto V-table-Win 
PROCEDURE pi-gera-grafico2-junto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter table for tt-estabel.
    def input parameter table for tt-comprador.
    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.

    {utp/ut-liter.i Compradores}
    assign c-tit-x = return-value.

    {utp/ut-liter.i Requisi‡äes_Compra_Recebidas_X_Comprador}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i Normais_X_Urgentes}
    assign c-tit-y = return-value.

    /* Inicializa temp-tables -----------------------------------------------------*/
    for each tt-dados:      delete tt-dados.     end.
    for each tt-atributos:  delete tt-atributos. end.
    for each tt-points:     delete tt-points.    end.
    for each tt-sets:       delete tt-sets.      end.
    for each tt-erros:      delete tt-erros.     end.

    /* Configura o Gr fico --------------------------------------------------------*/

    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 3
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-x 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>9".


    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 1
           tt-sets.LegendText = "Normais"
           tt-sets.colorset   = 9.
    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 2
           tt-sets.LegendText = "Urgentes"
           tt-sets.colorset   = 12.

    assign c-period = 
           string(substr(estat-cc-compr.periodo:screen-value,1,4) +
           string(substr(estat-cc-compr.periodo:screen-value,6,2),"99")).
    find first tt-estabel no-error.
    if not avail tt-estabel then do:
       create tt-estabel.
       assign tt-estabel.cod-estabel = 
              estat-cc-compr.cod-estabel:screen-value in frame {&FRAME-NAME}.
    end.

    find first tt-comprador no-error.
    if not avail tt-comprador then do:
       create tt-comprador.
       assign tt-comprador.cod-comprado = 
              estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}.
    end.

    run pi-gera-tt-points-3.

    /* Gera o Gr fico -------------------------------------------------------------*/
    run utp/utapi001.p(input table tt-atributos,
                       input table tt-points,
                       input table tt-sets,
                       input table tt-dados,
                       input table tt-ylabels,
                       output table tt-erros).

    if return-value = "NOK" then
        for each tt-erros:
             run utp/ut-msgs.p (input "show",
                                input tt-erros.cod-erro,
                                input "").
        end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico3 V-table-Win 
PROCEDURE pi-gera-grafico3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter table for tt-estabel.
    def input parameter table for tt-comprador.
    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.

    {utp/ut-liter.i Compradores}
    assign c-tit-x = return-value.

    /* Inicializa temp-tables -----------------------------------------------------*/
    for each tt-dados:      delete tt-dados.     end.
    for each tt-atributos:  delete tt-atributos. end.
    for each tt-points:     delete tt-points.    end.
    for each tt-sets:       delete tt-sets.      end.
    for each tt-erros:      delete tt-erros.     end.

    /* Configura o Gr fico --------------------------------------------------------*/

    {utp/ut-liter.i Valor_Total_Contratos_X_Comprador}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i Valor_x_Mil}
    assign c-tit-y = return-value.

    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 4
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-x 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>>,>>9.99".

    {utp/ut-liter.i Contratos_Fechados_X_Comprador}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i N£mero_Contratos}
    assign c-tit-y = return-value.

    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 2
           tt-atributos.graphtype             = 4
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-x 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>9".

    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 1.
    create tt-sets.
    assign tt-sets.numgraph   = 2
           tt-sets.numset     = 1.

    assign c-period = 
           string(substr(estat-cc-compr.periodo:screen-value,1,4) +
           string(substr(estat-cc-compr.periodo:screen-value,6,2),"99")).
    find first tt-estabel no-error.
    if not avail tt-estabel then do:
       create tt-estabel.
       assign tt-estabel.cod-estabel = 
              estat-cc-compr.cod-estabel:screen-value in frame {&FRAME-NAME}.
    end.

    find first tt-comprador no-error.
    if not avail tt-comprador then do:
       create tt-comprador.
       assign tt-comprador.cod-comprado = 
              estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}.
    end.

    run pi-gera-tt-points-4.

    /* Gera o Gr fico -------------------------------------------------------------*/
    run utp/utapi001.p(input table tt-atributos,
                       input table tt-points,
                       input table tt-sets,
                       input table tt-dados,
                       input table tt-ylabels,
                       output table tt-erros).

    if return-value = "NOK" then
        for each tt-erros:
             run utp/ut-msgs.p (input "show",
                                input tt-erros.cod-erro,
                                input "").
        end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico3-junto V-table-Win 
PROCEDURE pi-gera-grafico3-junto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter table for tt-estabel.
    def input parameter table for tt-comprador.
    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.

    {utp/ut-liter.i Valor_Total_Contratos_X_Contratos_Fechados_Comprador}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i Valor_x_Mil_/_Contratos}
    assign c-tit-y = return-value.

    {utp/ut-liter.i Compradores}
    assign c-tit-x = return-value.

    /* Inicializa temp-tables -----------------------------------------------------*/
    for each tt-dados:      delete tt-dados.     end.
    for each tt-atributos:  delete tt-atributos. end.
    for each tt-points:     delete tt-points.    end.
    for each tt-sets:       delete tt-sets.      end.
    for each tt-erros:      delete tt-erros.     end.

    /* Configura o Gr fico --------------------------------------------------------*/
    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 3
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-x 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>>,>>9".

    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 1
           tt-sets.LegendText = "Valor x Mil"
           tt-sets.colorset   = 9.
    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 2
           tt-sets.LegendText = "Contratos Fechados"
           tt-sets.colorset   = 14.

    assign c-period = 
           string(substr(estat-cc-compr.periodo:screen-value,1,4) +
           string(substr(estat-cc-compr.periodo:screen-value,6,2),"99")).
    find first tt-estabel no-error.
    if not avail tt-estabel then do:
       create tt-estabel.
       assign tt-estabel.cod-estabel = 
              estat-cc-compr.cod-estabel:screen-value in frame {&FRAME-NAME}.
    end.

    find first tt-comprador no-error.
    if not avail tt-comprador then do:
       create tt-comprador.
       assign tt-comprador.cod-comprado = 
              estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}.
    end.

    run pi-gera-tt-points-5.

    /* Gera o Gr fico -------------------------------------------------------------*/
    run utp/utapi001.p(input table tt-atributos,
                       input table tt-points,
                       input table tt-sets,
                       input table tt-dados,
                       input table tt-ylabels,
                       output table tt-erros).

    if return-value = "NOK" then
        for each tt-erros:
             run utp/ut-msgs.p (input "show",
                                input tt-erros.cod-erro,
                                input "").
        end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico4 V-table-Win 
PROCEDURE pi-gera-grafico4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter table for tt-estabel.
    def input parameter table for tt-comprador.
    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.
    define variable i-cont-com        as integer                        no-undo.

    {utp/ut-liter.i Qtde_Acumulada_PECs_X_Faixa_Valores}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i Status_de_Valores}
    assign c-tit-y = return-value.

    {utp/ut-liter.i Qtde_Pedidos_Compra}
    assign c-tit-x = return-value.

    /* Inicializa temp-tables -----------------------------------------------------*/
    for each tt-dados:      delete tt-dados.     end.
    for each tt-atributos:  delete tt-atributos. end.
    for each tt-points:     delete tt-points.    end.
    for each tt-sets:       delete tt-sets.      end.
    for each tt-erros:      delete tt-erros.     end.

    /* Configura o Gr fico --------------------------------------------------------*/
    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 4
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                                estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-x
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-y 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>9".
    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 1.
    assign c-period = 
           string(substr(estat-cc-compr.periodo:screen-value,1,4) +
           string(substr(estat-cc-compr.periodo:screen-value,6,2),"99")).

    find first tt-estabel no-error.
    if not avail tt-estabel then do:
       create tt-estabel.
       assign tt-estabel.cod-estabel = 
              estat-cc-compr.cod-estabel:screen-value in frame {&FRAME-NAME}.
    end.

    find first tt-comprador no-error.
    if not avail tt-comprador then do:
       assign i-cont-com = 1.
       create tt-comprador.
       assign tt-comprador.cod-comprado = 
              estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}
              tt-atributos.graphtitle = tt-atributos.graphtitle + " - " +
                                        tt-comprador.cod-comprado.
    end.

    /*--- Monta titulo do grafico ---*/
    if  i-cont-com = 0 then do:
        for each tt-comprador:
            assign i-cont-com = i-cont-com + 1. 
        end.
        find first tt-comprador no-error.
        assign tt-atributos.graphtitle = tt-atributos.graphtitle + " - " +
                                         tt-comprador.cod-comprado.
        find last tt-comprador no-error.
        assign tt-atributos.graphtitle = tt-atributos.graphtitle + 
                                         if  i-cont-com = 1 then
                                             ""
                                         else if  i-cont-com = 2 then 
                                             ", " + tt-comprador.cod-comprado
                                         else
                                             " ... " + tt-comprador.cod-comprado.
    end.

    run pi-gera-tt-points-6.

    /* Gera o Gr fico -------------------------------------------------------------*/
    run utp/utapi001.p(input table tt-atributos,
                       input table tt-points,
                       input table tt-sets,
                       input table tt-dados,
                       input table tt-ylabels,
                       output table tt-erros).

    if return-value = "NOK" then
        for each tt-erros:
             run utp/ut-msgs.p (input "show":U,
                                input tt-erros.cod-erro,
                                input "").
        end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico4-comp V-table-Win 
PROCEDURE pi-gera-grafico4-comp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter table for tt-estabel.
    def input parameter table for tt-comprador.
    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.

    {utp/ut-liter.i Qtde_Acumulada_PECs_X_Faixa_Valores}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i Status_de_Valores}
    assign c-tit-y = return-value.

    {utp/ut-liter.i Qtde_Pedidos_Compra}
    assign c-tit-x = return-value.

    /* Inicializa temp-tables -----------------------------------------------------*/
    for each tt-dados:      delete tt-dados.     end.
    for each tt-atributos:  delete tt-atributos. end.
    for each tt-points:     delete tt-points.    end.
    for each tt-sets:       delete tt-sets.      end.
    for each tt-erros:      delete tt-erros.     end.

    /* Configura o Gr fico --------------------------------------------------------*/
    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 4
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME} + " " +
                                  estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-x
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-y 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>9".

    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 1.

    assign c-period = 
           string(substr(estat-cc-compr.periodo:screen-value,1,4) +
           string(substr(estat-cc-compr.periodo:screen-value,6,2),"99")).

    find first tt-estabel no-error.
    if not avail tt-estabel then do:
       create tt-estabel.
       assign tt-estabel.cod-estabel = 
              estat-cc-compr.cod-estabel:screen-value in frame {&FRAME-NAME}.
    end.

    find first tt-comprador no-error.
    if not avail tt-comprador then do:
       create tt-comprador.
       assign tt-comprador.cod-comprado = 
              estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}.
    end.

    run pi-gera-tt-points-7.

    /* Gera o Gr fico -------------------------------------------------------------*/
    run utp/utapi001.p(input table tt-atributos,
                       input table tt-points,
                       input table tt-sets,
                       input table tt-dados,
                       input table tt-ylabels,
                       output table tt-erros).

    if return-value = "NOK" then
        for each tt-erros:
             run utp/ut-msgs.p (input "show",
                                input tt-erros.cod-erro,
                                input "").
        end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico5 V-table-Win 
PROCEDURE pi-gera-grafico5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&if defined (bf_mat_versao_ems) &then
    def input parameter table for tt-estabel.
    def input parameter table for tt-comprador.
    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.

    {utp/ut-liter.i Compradores}
    assign c-tit-x = return-value.

    /* Inicializa temp-tables -----------------------------------------------------*/
    for each tt-dados:      delete tt-dados.     end.
    for each tt-atributos:  delete tt-atributos. end.
    for each tt-points:     delete tt-points.    end.
    for each tt-sets:       delete tt-sets.      end.
    for each tt-erros:      delete tt-erros.     end.

    /* Configura o Gr fico --------------------------------------------------------*/

    {utp/ut-liter.i Ordens_Confirmadas_por_Comprador}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i Valor}
    assign c-tit-y = return-value.

    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 4
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-x 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>>,>>9.99".

    {utp/ut-liter.i N£mero_Ordens_Confirmadas_por_Comprador}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i N£mero_Ordens_Compra}
    assign c-tit-y = return-value.

    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 2
           tt-atributos.graphtype             = 4
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 1 
           tt-atributos.bottomtitle           = c-tit-x 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>9".

    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 1.
    create tt-sets.
    assign tt-sets.numgraph   = 2
           tt-sets.numset     = 1.

    assign c-period = 
           string(substr(estat-cc-compr.periodo:screen-value,1,4) +
           string(substr(estat-cc-compr.periodo:screen-value,6,2),"99")).

    find first tt-estabel no-error.
    if not avail tt-estabel then do:
       create tt-estabel.
       assign tt-estabel.cod-estabel = 
              estat-cc-compr.cod-estabel:screen-value in frame {&FRAME-NAME}.
    end.

    find first tt-comprador no-error.
    if not avail tt-comprador then do:
       create tt-comprador.
       assign tt-comprador.cod-comprado = 
              estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}.
    end.

    run pi-gera-tt-points-8.

    /* Gera o Gr fico -------------------------------------------------------------*/
    run utp/utapi001.p(input table tt-atributos,
                       input table tt-points,
                       input table tt-sets,
                       input table tt-dados,
                       input table tt-ylabels,
                       output table tt-erros).

    if return-value = "NOK" then
        for each tt-erros:
             run utp/ut-msgs.p (input "show",
                                input tt-erros.cod-erro,
                                input "").
        end.
&endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico5-junto V-table-Win 
PROCEDURE pi-gera-grafico5-junto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if defined (bf_mat_versao_ems) &then
    def input parameter table for tt-estabel.
    def input parameter table for tt-comprador.
    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.

    {utp/ut-liter.i Ordens_Fechadas_X_Comprador}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i Valor_/_No_Ordens}
    assign c-tit-y = return-value.

    {utp/ut-liter.i Compradores}
    assign c-tit-x = return-value.

    /* Inicializa temp-tables -----------------------------------------------------*/
    for each tt-dados:      delete tt-dados.     end.
    for each tt-atributos:  delete tt-atributos. end.
    for each tt-points:     delete tt-points.    end.
    for each tt-sets:       delete tt-sets.      end.
    for each tt-erros:      delete tt-erros.     end.

    /* Configura o Gr fico --------------------------------------------------------*/
    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 3
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-x 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>>,>>9".

    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 1
           tt-sets.LegendText = "Valor"
           tt-sets.colorset   = 3.
    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 2
           tt-sets.LegendText = "No Ordens"
           tt-sets.colorset   = 12.

    assign c-period = 
           string(substr(estat-cc-compr.periodo:screen-value,1,4) +
           string(substr(estat-cc-compr.periodo:screen-value,6,2),"99")).

    find first tt-estabel no-error.
    if not avail tt-estabel then do:
       create tt-estabel.
       assign tt-estabel.cod-estabel = 
              estat-cc-compr.cod-estabel:screen-value in frame {&FRAME-NAME}.
    end.

    find first tt-comprador no-error.
    if not avail tt-comprador then do:
       create tt-comprador.
       assign tt-comprador.cod-comprado = 
              estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}.
    end.

    run pi-gera-tt-points-9.

    /* Gera o Gr fico -------------------------------------------------------------*/
    run utp/utapi001.p(input table tt-atributos,
                       input table tt-points,
                       input table tt-sets,
                       input table tt-dados,
                       input table tt-ylabels,
                       output table tt-erros).

    if return-value = "NOK" then
        for each tt-erros:
             run utp/ut-msgs.p (input "show",
                                input tt-erros.cod-erro,
                                input "").
        end.
&endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico6 V-table-Win 
PROCEDURE pi-gera-grafico6 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if defined (bf_mat_versao_ems) &then
    def input parameter table for tt-estabel.
    def input parameter table for tt-comprador.
    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.

    {utp/ut-liter.i Compradores}
    assign c-tit-x = return-value.

    /* Inicializa temp-tables -----------------------------------------------------*/
    for each tt-dados:      delete tt-dados.     end.
    for each tt-atributos:  delete tt-atributos. end.
    for each tt-points:     delete tt-points.    end.
    for each tt-sets:       delete tt-sets.      end.
    for each tt-erros:      delete tt-erros.     end.

    /* Configura o Gr fico --------------------------------------------------------*/

    {utp/ut-liter.i Total_Ordens_por_Comprador}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i N£mero_Ordens}
    assign c-tit-y = return-value.

    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 4
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-x 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>>,>>9.99".

    {utp/ut-liter.i Ordens_Confirmadas_por_Comprador}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i N£mero_Ordens_Compra}
    assign c-tit-y = return-value.

    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 2
           tt-atributos.graphtype             = 4
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 1 
           tt-atributos.bottomtitle           = c-tit-x 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>9".

    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 1.
    create tt-sets.
    assign tt-sets.numgraph   = 2
           tt-sets.numset     = 1.

    assign c-period = 
           string(substr(estat-cc-compr.periodo:screen-value,1,4) +
           string(substr(estat-cc-compr.periodo:screen-value,6,2),"99")).

    find first tt-estabel no-error.
    if not avail tt-estabel then do:
       create tt-estabel.
       assign tt-estabel.cod-estabel = 
              estat-cc-compr.cod-estabel:screen-value in frame {&FRAME-NAME}.
    end.

    find first tt-comprador no-error.
    if not avail tt-comprador then do:
       create tt-comprador.
       assign tt-comprador.cod-comprado = 
              estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}.
    end.

    run pi-gera-tt-points-10.


    /* Gera o Gr fico -------------------------------------------------------------*/
    run utp/utapi001.p(input table tt-atributos,
                       input table tt-points,
                       input table tt-sets,
                       input table tt-dados,
                       input table tt-ylabels,
                       output table tt-erros).

    if return-value = "NOK" then
        for each tt-erros:
             run utp/ut-msgs.p (input "show",
                                input tt-erros.cod-erro,
                                input "").
        end.
&endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico6-junto V-table-Win 
PROCEDURE pi-gera-grafico6-junto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if defined (bf_mat_versao_ems) &then
    def input parameter table for tt-estabel.
    def input parameter table for tt-comprador.
    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.

    {utp/ut-liter.i Total_Ordens_FechadasX_Total_Ordens_Emitidas}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i N£mero_Ordens_Confirmadas/_Total_Ordens}
    assign c-tit-y = return-value.

    {utp/ut-liter.i Compradores}
    assign c-tit-x = return-value.

    /* Inicializa temp-tables -----------------------------------------------------*/
    for each tt-dados:      delete tt-dados.     end.
    for each tt-atributos:  delete tt-atributos. end.
    for each tt-points:     delete tt-points.    end.
    for each tt-sets:       delete tt-sets.      end.
    for each tt-erros:      delete tt-erros.     end.

    /* Configura o Gr fico --------------------------------------------------------*/
    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 3
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-x 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>>,>>9".

    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 1
           tt-sets.LegendText = "N£mero de Ordens Confirmadas"
           tt-sets.colorset   = 3.
    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 2
           tt-sets.LegendText = "Total Ordens"
           tt-sets.colorset   = 12.

    assign c-period = 
           string(substr(estat-cc-compr.periodo:screen-value,1,4) +
           string(substr(estat-cc-compr.periodo:screen-value,6,2),"99")).

    find first tt-estabel no-error.
    if not avail tt-estabel then do:
       create tt-estabel.
       assign tt-estabel.cod-estabel = 
              estat-cc-compr.cod-estabel:screen-value in frame {&FRAME-NAME}.
    end.

    find first tt-comprador no-error.
    if not avail tt-comprador then do:
       create tt-comprador.
       assign tt-comprador.cod-comprado = 
              estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}.
    end.

    run pi-gera-tt-points-11.

    /* Gera o Gr fico -------------------------------------------------------------*/
    run utp/utapi001.p(input table tt-atributos,
                       input table tt-points,
                       input table tt-sets,
                       input table tt-dados,
                       input table tt-ylabels,
                       output table tt-erros).

    if return-value = "NOK" then
        for each tt-erros:
             run utp/ut-msgs.p (input "show",
                                input tt-erros.cod-erro,
                                input "").
        end.
&endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico7 V-table-Win 
PROCEDURE pi-gera-grafico7 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if defined (bf_mat_versao_ems) &then    
    def input parameter table for tt-estabel.
    def input parameter table for tt-comprador.
    run pi-gera-valores-faixa.
    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.

    {utp/ut-liter.i Qtde_Acumulada_Ordens_X_Faixa_Valores}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i Status_de_Valores}
    assign c-tit-y = return-value.

    {utp/ut-liter.i Qtde_Ordens_Compra}
    assign c-tit-x = return-value.

    /* Inicializa temp-tables -----------------------------------------------------*/
    for each tt-dados:      delete tt-dados.     end.
    for each tt-atributos:  delete tt-atributos. end.
    for each tt-points:     delete tt-points.    end.
    for each tt-sets:       delete tt-sets.      end.
    for each tt-erros:      delete tt-erros.     end.

    /* Configura o Gr fico --------------------------------------------------------*/
    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 4
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-x
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-y 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>9".

    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 1.


    assign c-period = 
           string(substr(estat-cc-compr.periodo:screen-value,1,4) +
           string(substr(estat-cc-compr.periodo:screen-value,6,2),"99")).

    find first tt-estabel no-error.
    if not avail tt-estabel then do:
       create tt-estabel.
       assign tt-estabel.cod-estabel = 
              estat-cc-compr.cod-estabel:screen-value in frame {&FRAME-NAME}.
    end.

    find first tt-comprador no-error.
    if not avail tt-comprador then do:
       create tt-comprador.
       assign tt-comprador.cod-comprado = 
              estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}.
    end.

    run pi-gera-tt-points-12.

    /* Gera o Gr fico -------------------------------------------------------------*/
    run utp/utapi001.p(input table tt-atributos,
                       input table tt-points,
                       input table tt-sets,
                       input table tt-dados,
                       input table tt-ylabels,
                       output table tt-erros).

    if return-value = "NOK" then
        for each tt-erros:
             run utp/ut-msgs.p (input "show",
                                input tt-erros.cod-erro,
                                input "").
        end.
&endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico7-junto V-table-Win 
PROCEDURE pi-gera-grafico7-junto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if defined (bf_mat_versao_ems) &then   
    def input parameter table for tt-estabel.
    def input parameter table for tt-comprador.
    run pi-gera-valores-faixa.

    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.

    {utp/ut-liter.i Qtde_Acumulada_Ordens_X_Faixa_Valores}
    assign c-tit-graf = return-value.

    {utp/ut-liter.i Status_de_Valores}
    assign c-tit-y = return-value.

    {utp/ut-liter.i Qtde_Ordens_Compra}
    assign c-tit-x = return-value.

    /* Inicializa temp-tables -----------------------------------------------------*/
    for each tt-dados:      delete tt-dados.     end.
    for each tt-atributos:  delete tt-atributos. end.
    for each tt-points:     delete tt-points.    end.
    for each tt-sets:       delete tt-sets.      end.
    for each tt-erros:      delete tt-erros.     end.

    /* Configura o Gr fico --------------------------------------------------------*/
    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 4
           tt-atributos.graphtitle            = c-tit-graf + " - " + 
                                  estat-cc-compr.periodo:screen-value in frame {&FRAME-NAME} + " " +
                                  estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}
           tt-atributos.lefttitle             = c-tit-x
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-y 
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>>,>>9".

    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 1.

    assign c-period = 
           string(substr(estat-cc-compr.periodo:screen-value,1,4) +
           string(substr(estat-cc-compr.periodo:screen-value,6,2),"99")).

    find first tt-estabel no-error.
    if not avail tt-estabel then do:
       create tt-estabel.
       assign tt-estabel.cod-estabel = 
              estat-cc-compr.cod-estabel:screen-value in frame {&FRAME-NAME}.
    end.
    find first tt-comprador no-error.
    if not avail tt-comprador then do:
       create tt-comprador.
       assign tt-comprador.cod-comprado = estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}.
    end.
    run pi-gera-tt-points-13.

    /* Gera o Gr fico -------------------------------------------------------------*/
    run utp/utapi001.p(input table tt-atributos,
                       input table tt-points,
                       input table tt-sets,
                       input table tt-dados,
                       input table tt-ylabels,
                       output table tt-erros).

    if return-value = "NOK" then
        for each tt-erros:
             run utp/ut-msgs.p (input "show",
                                input tt-erros.cod-erro,
                                input "").
        end.
&endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-points V-table-Win 
PROCEDURE pi-gera-tt-points :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign i-conta-points = 0.
find first tt-comprador no-error.
if avail tt-comprador then assign l-ok = yes. else no.
for each estat-cc-compr NO-LOCK
    where estat-cc-compr.periodo = c-period,
    first tt-estabel NO-LOCK
    where tt-estabel.cod-estabel = estat-cc-compr.cod-estabel
    break by estat-cc-compr.cod-comprado:
    if l-ok then do:
       find first tt-comprador 
            where tt-comprador.cod-comprado = estat-cc-compr.cod-comprado no-error.
       if not avail tt-comprador then 
          assign l-continua = no. 
       else assign l-continua = yes.
    end.
    if l-continua then do:
       if first-of(estat-cc-compr.cod-comprado) then               
          assign de-total = 0
                 de-qtde  = 0.
       assign de-total = de-total + estat-cc-compr.vlr-tot-pec
              de-qtde  = de-qtde  + estat-cc-compr.qtd-pec-emit.
       if  de-total = 0 and
           de-qtde  = 0 then 
           assign l-next = yes. 
       else assign l-next = no.    
       if not l-next then do:
          if last-of(estat-cc-compr.cod-comprado) then do:
            assign i-conta-points = i-conta-points + 1.
            create tt-points.
            assign tt-points.numgraph  = 1
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = estat-cc-compr.cod-comprado.
            create tt-points.
            assign tt-points.numgraph  = 2
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = estat-cc-compr.cod-comprado.
            create tt-dados.
            assign tt-dados.numgraph   = 1
                   tt-dados.numpoint   = i-conta-points
                   tt-dados.numset     = 1
                   tt-dados.graphdata  = de-total.
            create tt-dados.
            assign tt-dados.numgraph   = 2
                   tt-dados.numpoint   = i-conta-points
                   tt-dados.numset     = 1
                   tt-dados.graphdata  = de-qtde.
          end.  /* if last */
       end.  /* if not l-next */          
    end.  /* if l-continua */ 
end. /* for each */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-points-1 V-table-Win 
PROCEDURE pi-gera-tt-points-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

assign i-conta-points = 0.
find first tt-comprador no-error.
if avail tt-comprador then assign l-ok = yes. else no.
for each estat-cc-compr NO-LOCK
    where estat-cc-compr.periodo = c-period,
    each tt-estabel NO-LOCK
    where tt-estabel.cod-estabel = estat-cc-compr.cod-estabel
    break by estat-cc-compr.cod-comprado:
    if l-ok then do:
       find first tt-comprador 
            where tt-comprador.cod-comprado = estat-cc-compr.cod-comprado no-error.
       if not avail tt-comprador then assign l-continua = no. else assign l-continua = yes.
    end.
    if l-continua then do:
       if first-of(estat-cc-compr.cod-comprado) then
          assign de-total = 0
                 de-qtde  = 0.
       assign de-total = de-total + estat-cc-compr.vlr-tot-pec
              de-qtde  = de-qtde  + estat-cc-compr.qtd-pec-emit.
       if  de-total = 0 and
           de-qtde  = 0 then
           assign l-next = yes.
       else assign l-next = no.
       if not l-next then do:
          if last-of(estat-cc-compr.cod-comprado) then do:
            assign i-conta-points = i-conta-points + 1.
            create tt-points.
            assign tt-points.numgraph  = 1
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = estat-cc-compr.cod-comprado.
            create tt-dados.
            assign tt-dados.numgraph   = 1
                   tt-dados.numpoint   = i-conta-points
                   tt-dados.numset     = 1
                   tt-dados.graphdata  = de-total / 1000.
            create tt-dados.
            assign tt-dados.numgraph   = 1
                   tt-dados.numpoint   = i-conta-points
                   tt-dados.numset     = 2
                   tt-dados.graphdata  = de-qtde.
          end. /* if last-of */
       end. /* if not l-next */            
    end. /* if l-continua */
 end. /* for each */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-points-10 V-table-Win 
PROCEDURE pi-gera-tt-points-10 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if defined (bf_mat_versao_ems) &then   
   assign i-conta-points = 0.
   find first tt-comprador no-error.
   if avail tt-comprador then assign l-ok = yes. else no.
   for each estat-cc-compr NO-LOCK
       where estat-cc-compr.periodo = c-period,
       first tt-estabel NO-LOCK
       where tt-estabel.cod-estabel = estat-cc-compr.cod-estabel
       break by estat-cc-compr.cod-comprado:
       if l-ok then do:
          find first tt-comprador 
               where tt-comprador.cod-comprado = estat-cc-compr.cod-comprado no-error.
          if not avail tt-comprador then assign l-continua = no. else assign l-continua = yes.
       end.
       if l-continua then do:
            if first-of(estat-cc-compr.cod-comprado) then
                assign de-total = 0
                       de-qtde  = 0.
              assign de-total = de-total + estat-cc-compr.qtd-oc-periodo
                     de-qtde  = de-qtde  + estat-cc-compr.qt-oc-fechada-periodo.
          if  de-total = 0 and
              de-qtde  = 0 then 
              assign l-next = yes. 
          else assign l-next = no.    
          if not l-next then do:
          if last-of(estat-cc-compr.cod-comprado) then do:
            assign i-conta-points = i-conta-points + 1.
            create tt-points.
            assign tt-points.numgraph  = 1
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = estat-cc-compr.cod-comprado.
            create tt-points.
            assign tt-points.numgraph  = 2
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = estat-cc-compr.cod-comprado.

            create tt-dados.
            assign tt-dados.numgraph   = 1
                   tt-dados.numpoint   = i-conta-points
                   tt-dados.numset     = 1
                   tt-dados.graphdata  = de-total.
            create tt-dados.
            assign tt-dados.numgraph   = 2
                   tt-dados.numpoint   = i-conta-points
                   tt-dados.numset     = 1
                   tt-dados.graphdata  = de-qtde.
       end.            
     end.
   end.
 end.
&endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-points-11 V-table-Win 
PROCEDURE pi-gera-tt-points-11 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if defined (bf_mat_versao_ems) &then   
   assign i-conta-points = 0.
   find first tt-comprador no-error.
   if avail tt-comprador then assign l-ok = yes. else no.
   for each estat-cc-compr NO-LOCK
       where estat-cc-compr.periodo = c-period,
       each tt-estabel NO-LOCK
       where tt-estabel.cod-estabel = estat-cc-compr.cod-estabel
       break by estat-cc-compr.cod-comprado:
       if l-ok then do:
          find first tt-comprador 
               where tt-comprador.cod-comprado = estat-cc-compr.cod-comprado no-error.
          if not avail tt-comprador then assign l-continua = no. else assign l-continua = yes.
       end.
       if l-continua then do:
            if first-of(estat-cc-compr.cod-comprado) then
                assign de-total = 0
                       de-qtde  = 0.

            assign de-total = de-total + estat-cc-compr.qtd-oc-periodo
                     de-qtde  = de-qtde  + estat-cc-compr.qt-oc-fechada-periodo.

        if  de-total = 0 and
           de-qtde  = 0 then
           assign l-next = yes.
       else assign l-next = no.
       if not l-next then do:
          if last-of(estat-cc-compr.cod-comprado) then do:

            assign i-conta-points = i-conta-points + 1.

            create tt-points.
            assign tt-points.numgraph  = 1
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = estat-cc-compr.cod-comprado.

            create tt-dados.
            assign tt-dados.numgraph   = 1
                   tt-dados.numpoint   = i-conta-points
                   tt-dados.numset     = 1
                   tt-dados.graphdata  = de-qtde .
            create tt-dados.
            assign tt-dados.numgraph   = 1
                   tt-dados.numpoint   = i-conta-points
                   tt-dados.numset     = 2
                   tt-dados.graphdata  = de-total.
        end.           
     end.
   end.
 end.  
&endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-points-12 V-table-Win 
PROCEDURE pi-gera-tt-points-12 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&if defined (bf_mat_versao_ems) &then   
   assign i-conta-points = 0.
   find first tt-comprador no-error.
   if avail tt-comprador then assign l-ok = yes. else no.
   for each  tt-estat-cc-cmp-fx no-lock
       where tt-estat-cc-cmp-fx.periodo = c-period,
       each  tt-estabel 
       where tt-estabel.cod-estabel = tt-estat-cc-cmp-fx.cod-estabel
       break by tt-estat-cc-cmp-fx.vlr-inicio  :
       if l-ok then do:
          find first tt-comprador 
               where tt-comprador.cod-comprado = tt-estat-cc-cmp-fx.cod-comprado no-error.
          if not avail tt-comprador then assign l-continua = no. else assign l-continua = yes.
       end.
       if l-continua then do:
            if first-of(tt-estat-cc-cmp-fx.vlr-inicio)
            then do:
                assign de-total = 0
                       de-qtde  = 0.
            end.
            assign de-qtde = de-qtde + tt-estat-cc-cmp-fx.qtd-ordens-faixa.
            if  de-qtde  = 0 then
                next.
            if last-of(tt-estat-cc-cmp-fx.vlr-inicio)
            then do:
                assign i-conta-points = i-conta-points + 1.
                create tt-points.
                assign tt-points.numgraph  = 1
                       tt-points.numpoint  = i-conta-points
                       tt-points.labeltext = string(tt-estat-cc-cmp-fx.vlr-inicio,"->>>,>>>,>>9") + " at‚ "
                                           + string(tt-estat-cc-cmp-fx.vlr-fim,"-ZZZ,ZZZ,ZZ9").
                create tt-dados.
                assign tt-dados.numgraph   = 1
                       tt-dados.numpoint   = i-conta-points
                       tt-dados.numset     = 1
                       tt-dados.graphdata  = de-qtde.
            end.
        end.    
    end.
&endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-points-13 V-table-Win 
PROCEDURE pi-gera-tt-points-13 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&if defined (bf_mat_versao_ems) &then   
   assign i-conta-points = 0.
   find first tt-comprador no-error.
   if avail tt-comprador then assign l-ok = yes. else no.
   for each  tt-estat-cc-cmp-fx no-lock
       where tt-estat-cc-cmp-fx.periodo = c-period,
       each  tt-estabel 
       where tt-estabel.cod-estabel = tt-estat-cc-cmp-fx.cod-estabel,
       each  tt-comprador 
       where tt-comprador.cod-comprado = tt-estat-cc-cmp-fx.cod-comprado
       break by tt-estat-cc-cmp-fx.vlr-inicio  :
       if first-of(tt-estat-cc-cmp-fx.vlr-inicio)
       then do:
            assign de-total = 0
                   de-qtde  = 0.
       end.
       assign de-qtde = de-qtde + tt-estat-cc-cmp-fx.qtd-ordens-faixa.
       if  de-qtde  = 0 then
           next.
       if last-of(tt-estat-cc-cmp-fx.vlr-inicio)
       then do:
            assign i-conta-points = i-conta-points + 1.
            create tt-points.
            assign tt-points.numgraph  = 1
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = string(tt-estat-cc-cmp-fx.vlr-inicio,"->>>,>>>,>>9") + " at‚ "
                                       + string(tt-estat-cc-cmp-fx.vlr-fim,"-ZZZ,ZZZ,ZZ9").
            create tt-dados.
            assign tt-dados.numgraph              = 1
                   tt-dados.numpoint              = i-conta-points
                   tt-dados.numset                = 1
                   tt-dados.graphdata             = de-qtde.
       end.
   end.
&endif   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-points-2 V-table-Win 
PROCEDURE pi-gera-tt-points-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   assign i-conta-points = 0.
   find first tt-comprador no-error.
   if avail tt-comprador then assign l-ok = yes. else no.

   for each estat-cc-compr NO-LOCK
       where estat-cc-compr.periodo = c-period,
       first tt-estabel NO-LOCK
       where tt-estabel.cod-estabel = estat-cc-compr.cod-estabel
       break by estat-cc-compr.cod-comprado:
       if l-ok then do:
          find first tt-comprador 
               where tt-comprador.cod-comprado = estat-cc-compr.cod-comprado no-error.
          if not avail tt-comprador then assign l-continua = no. else assign l-continua = yes.
       end.

       if  l-continua then do:
            if first-of(estat-cc-compr.cod-comprado) then
                assign de-total = 0
                       de-qtde  = 0.
            assign de-total = de-total + estat-cc-compr.qtd-cmp-norm
                   de-qtde  = de-qtde  + estat-cc-compr.qtd-cmp-urg.

            if  de-total = 0 and
                de-qtde  = 0 then 
                assign l-next = yes. 
            else assign l-next = no.    
            if not l-next then do:
               if last-of(estat-cc-compr.cod-comprado) then do:


                 assign i-conta-points = i-conta-points + 1.
                 create tt-points.
                 assign tt-points.numgraph  = 1
                        tt-points.numpoint  = i-conta-points
                        tt-points.labeltext = estat-cc-compr.cod-comprado.
                 create tt-points.
                 assign tt-points.numgraph  = 2
                        tt-points.numpoint  = i-conta-points
                        tt-points.labeltext = estat-cc-compr.cod-comprado.
                 create tt-dados.
                 assign tt-dados.numgraph   = 1
                        tt-dados.numpoint   = i-conta-points
                        tt-dados.numset     = 1
                        tt-dados.graphdata  = de-total.
                 create tt-dados.
                 assign tt-dados.numgraph   = 2
                        tt-dados.numpoint   = i-conta-points
                        tt-dados.numset     = 1
                        tt-dados.graphdata  = de-qtde.
            end.           
       end.
  end.
 end.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-points-3 V-table-Win 
PROCEDURE pi-gera-tt-points-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   assign i-conta-points = 0.
   find first tt-comprador no-error.
   if avail tt-comprador then assign l-ok = yes. else no.
   for each estat-cc-compr NO-LOCK
       where estat-cc-compr.periodo = c-period,
       each tt-estabel NO-LOCK
       where tt-estabel.cod-estabel = estat-cc-compr.cod-estabel
       break by estat-cc-compr.cod-comprado:
       if l-ok then do:
          find first tt-comprador 
               where tt-comprador.cod-comprado = estat-cc-compr.cod-comprado no-error.
          if not avail tt-comprador then assign l-continua = no. else assign l-continua = yes.
       end.
       if l-continua then do:
            if first-of(estat-cc-compr.cod-comprado) then
                assign de-total = 0
                       de-qtde  = 0.
            assign de-total = de-total + estat-cc-compr.qtd-cmp-norm
                   de-qtde  = de-qtde  + estat-cc-compr.qtd-cmp-urg.
            if  de-total = 0 and
           de-qtde  = 0 then
           assign l-next = yes.
       else assign l-next = no.
       if not l-next then do:

          if last-of(estat-cc-compr.cod-comprado) then do:
            assign i-conta-points = i-conta-points + 1.
            create tt-points.
            assign tt-points.numgraph  = 1
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = estat-cc-compr.cod-comprado.
            create tt-dados.
            assign tt-dados.numgraph              = 1
                   tt-dados.numpoint              = i-conta-points
                   tt-dados.numset                = 1
                   tt-dados.graphdata             = de-total.
            create tt-dados.
            assign tt-dados.numgraph              = 1
                   tt-dados.numpoint              = i-conta-points
                   tt-dados.numset                = 2
                   tt-dados.graphdata             = de-qtde.
         end.            
       end.
     end.
   end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-points-4 V-table-Win 
PROCEDURE pi-gera-tt-points-4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   assign i-conta-points = 0.
   find first tt-comprador no-error.
   if avail tt-comprador then assign l-ok = yes. else no.
   for each estat-cc-compr NO-LOCK
       where estat-cc-compr.periodo = c-period,
       first tt-estabel NO-LOCK
       where tt-estabel.cod-estabel = estat-cc-compr.cod-estabel
       break by estat-cc-compr.cod-comprado:
       if l-ok then do:
          find first tt-comprador 
               where tt-comprador.cod-comprado = estat-cc-compr.cod-comprado no-error.
          if not avail tt-comprador then assign l-continua = no. else assign l-continua = yes.
       end.
       if l-continua then do:
            if first-of(estat-cc-compr.cod-comprado) then
                assign de-total = 0
                       de-qtde  = 0.

            assign de-total = de-total + trunc(estat-cc-compr.vlr-tot-cn / 1000,2)
                   de-qtde  = de-qtde  + estat-cc-compr.qtd-cn-fech.

            if  de-total = 0 and
           de-qtde  = 0 then 
           assign l-next = yes. 
       else assign l-next = no.    
       if not l-next then do:
          if last-of(estat-cc-compr.cod-comprado) then do:

            assign i-conta-points = i-conta-points + 1.

            create tt-points.
            assign tt-points.numgraph  = 1
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = estat-cc-compr.cod-comprado.
            create tt-points.
            assign tt-points.numgraph  = 2
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = estat-cc-compr.cod-comprado.

            create tt-dados.
            assign tt-dados.numgraph              = 1
                   tt-dados.numpoint              = i-conta-points
                   tt-dados.numset                = 1
                   tt-dados.graphdata             = de-total.
            create tt-dados.
            assign tt-dados.numgraph              = 2
                   tt-dados.numpoint              = i-conta-points
                   tt-dados.numset                = 1
                   tt-dados.graphdata             = de-qtde.
       end.            
    end.
  end.
 end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-points-5 V-table-Win 
PROCEDURE pi-gera-tt-points-5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   assign i-conta-points = 0.
   find first tt-comprador no-error.
   if avail tt-comprador then assign l-ok = yes. else no.
   for each estat-cc-compr NO-LOCK
       where estat-cc-compr.periodo = c-period,
       first tt-estabel NO-LOCK
       where tt-estabel.cod-estabel = estat-cc-compr.cod-estabel
       break by estat-cc-compr.cod-comprado:
       if l-ok then do:
          find first tt-comprador 
               where tt-comprador.cod-comprado = estat-cc-compr.cod-comprado no-error.
          if not avail tt-comprador then assign l-continua = no. else assign l-continua = yes.
       end.
       if l-continua then do:
            if first-of(estat-cc-compr.cod-comprado) then
                assign de-total = 0
                       de-qtde  = 0.

            assign de-total = de-total + trunc(estat-cc-compr.vlr-tot-cn / 1000,2)
                   de-qtde  = de-qtde  + estat-cc-compr.qtd-cn-fech.

            if  de-total = 0 and
           de-qtde  = 0 then 
           assign l-next = yes. 
       else assign l-next = no.    
       if not l-next then do:
          if last-of(estat-cc-compr.cod-comprado) then do:

            assign i-conta-points = i-conta-points + 1.

            create tt-points.
            assign tt-points.numgraph  = 1
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = estat-cc-compr.cod-comprado.

            create tt-dados.
            assign tt-dados.numgraph              = 1
                   tt-dados.numpoint              = i-conta-points
                   tt-dados.numset                = 1
                   tt-dados.graphdata             = de-total.
            create tt-dados.
            assign tt-dados.numgraph              = 1
                   tt-dados.numpoint              = i-conta-points
                   tt-dados.numset                = 2
                   tt-dados.graphdata             = de-qtde.
         end.
        end. 
       end.            
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-points-6 V-table-Win 
PROCEDURE pi-gera-tt-points-6 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   assign i-conta-points = 0.

   for each estat-cc-cmp-fx NO-LOCK
       where estat-cc-cmp-fx.periodo = c-period,
       each tt-estabel NO-LOCK
       where tt-estabel.cod-estabel = estat-cc-cmp-fx.cod-estabel,
       first estat-cc-faixa of estat-cc-cmp-fx no-lock
       break by estat-cc-faixa.vlr-inicio:

       find first tt-comprador 
            where tt-comprador.cod-comprado = estat-cc-cmp-fx.cod-comprado no-error.
       if  avail tt-comprador then do:

           assign de-qtde = de-qtde + estat-cc-cmp-fx.qtd-pec-faixa.

           if de-qtde = 0 then next.
       end.

       if  last-of(estat-cc-faixa.vlr-inicio) then do:

           assign i-conta-points = i-conta-points + 1.

           create tt-points.
           assign tt-points.numgraph  = 1
                  tt-points.numpoint  = i-conta-points
                  tt-points.labeltext = string(estat-cc-faixa.vlr-inicio,"->>>,>>>,>>9") + " at‚ "
                                      + string(estat-cc-faixa.vlr-fim,"-ZZZ,ZZZ,ZZ9").
           create tt-dados.
           assign tt-dados.numgraph              = 1
                  tt-dados.numpoint              = i-conta-points
                  tt-dados.numset                = 1
                  tt-dados.graphdata             = de-qtde
                  de-qtde                        = 0.

       end.

   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-points-7 V-table-Win 
PROCEDURE pi-gera-tt-points-7 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   assign i-conta-points = 0.
   find first tt-comprador no-error.
   if avail tt-comprador then assign l-ok = yes. else no.
   for each estat-cc-cmp-fx NO-LOCK
       where estat-cc-cmp-fx.periodo = c-period,
       each tt-estabel NO-LOCK
       where tt-estabel.cod-estabel = estat-cc-cmp-fx.cod-estabel,
       first estat-cc-faixa of estat-cc-cmp-fx no-lock
       break by estat-cc-faixa.vlr-inicio:
       if l-ok then do:
          find first tt-comprador 
               where tt-comprador.cod-comprado = estat-cc-cmp-fx.cod-comprado no-error.
          if not avail tt-comprador then assign l-continua = no. else assign l-continua = yes.
       end.
       if l-continua then do:
            if first-of(estat-cc-faixa.vlr-inicio)
            then do:
                assign de-total = 0
                       de-qtde  = 0.
            end.
            assign de-qtde = de-qtde + estat-cc-cmp-fx.qtd-pec-faixa.

            if  de-qtde  = 0
            then
                next.

            if last-of(estat-cc-faixa.vlr-inicio)
            then do:
                assign i-conta-points = i-conta-points + 1.

                create tt-points.
                assign tt-points.numgraph  = 1
                       tt-points.numpoint  = i-conta-points
                       tt-points.labeltext = string(estat-cc-faixa.vlr-inicio,"->>>,>>>,>>9") + " at‚ "
                                           + string(estat-cc-faixa.vlr-fim,"-ZZZ,ZZZ,ZZ9").
                create tt-dados.
                assign tt-dados.numgraph   = 1
                       tt-dados.numpoint   = i-conta-points
                       tt-dados.numset     = 1
                       tt-dados.graphdata  = de-qtde.
            end.
        end.    
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-points-8 V-table-Win 
PROCEDURE pi-gera-tt-points-8 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&if defined (bf_mat_versao_ems) &then      
   assign i-conta-points = 0.
   find first tt-comprador no-error.
   if avail tt-comprador then assign l-ok = yes. else no.
   for each estat-cc-compr NO-LOCK
       where estat-cc-compr.periodo = c-period,
       first tt-estabel NO-LOCK
    where tt-estabel.cod-estabel = estat-cc-compr.cod-estabel
       break by estat-cc-compr.cod-comprado:
       if l-ok then do:
          find first tt-comprador 
               where tt-comprador.cod-comprado = estat-cc-compr.cod-comprado no-error.
          if not avail tt-comprador then assign l-continua = no. else assign l-continua = yes.
       end.
       if l-continua then do:
            if first-of(estat-cc-compr.cod-comprado) then
                assign de-total = 0
                       de-qtde  = 0.

              assign de-total = de-total + estat-cc-compr.vlr-tot-pec
                     de-qtde  = de-qtde  + estat-cc-compr.qt-oc-fechada-periodo.

            if  de-total = 0 and
           de-qtde  = 0 then 
           assign l-next = yes. 
       else assign l-next = no.    
       if not l-next then do:
          if last-of(estat-cc-compr.cod-comprado) then do:

            assign i-conta-points = i-conta-points + 1.

            create tt-points.
            assign tt-points.numgraph  = 1
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = estat-cc-compr.cod-comprado.
            create tt-points.
            assign tt-points.numgraph  = 2
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = estat-cc-compr.cod-comprado.

            create tt-dados.
            assign tt-dados.numgraph   = 1
                   tt-dados.numpoint   = i-conta-points
                   tt-dados.numset     = 1
                   tt-dados.graphdata  = de-total.
            create tt-dados.
            assign tt-dados.numgraph   = 2
                   tt-dados.numpoint   = i-conta-points
                   tt-dados.numset     = 1        
                   tt-dados.graphdata  = de-qtde.
             end.      
       end.
       end.            
    end.
&endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-points-9 V-table-Win 
PROCEDURE pi-gera-tt-points-9 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if defined (bf_mat_versao_ems) &then   
   assign i-conta-points = 0.
   find first tt-comprador no-error.
   if avail tt-comprador then assign l-ok = yes. else no.
   for each estat-cc-compr NO-LOCK
       where estat-cc-compr.periodo = c-period,
       each tt-estabel NO-LOCK
       where tt-estabel.cod-estabel = estat-cc-compr.cod-estabel
       break by estat-cc-compr.cod-comprado:
       if l-ok then do:
          find first tt-comprador 
               where tt-comprador.cod-comprado = estat-cc-compr.cod-comprado no-error.
          if not avail tt-comprador then assign l-continua = no. else assign l-continua = yes.
       end.
       if l-continua then do:
            if first-of(estat-cc-compr.cod-comprado) then
                assign de-total = 0
                       de-qtde  = 0.

              assign de-total = de-total + estat-cc-compr.vlr-tot-pec
                     de-qtde  = de-qtde  + estat-cc-compr.qt-oc-fechada-periodo.

            if  de-total = 0 and
           de-qtde  = 0 then
           assign l-next = yes.
       else assign l-next = no.
       if not l-next then do:
          if last-of(estat-cc-compr.cod-comprado) then do:

            assign i-conta-points = i-conta-points + 1.

            create tt-points.
            assign tt-points.numgraph  = 1
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = estat-cc-compr.cod-comprado.

            create tt-dados.
            assign tt-dados.numgraph   = 1
                   tt-dados.numpoint   = i-conta-points
                   tt-dados.numset     = 1
                   tt-dados.graphdata  = de-total .
            create tt-dados.
            assign tt-dados.numgraph   = 1
                   tt-dados.numpoint   = i-conta-points
                   tt-dados.numset     = 2
                   tt-dados.graphdata  = de-qtde.
        end. /* if last-of */
       end. /* if not l-next */            
    end. /* if l-continua */
 end. /* for each */

&endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-valores-faixa V-table-Win 
PROCEDURE pi-gera-valores-faixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
for each tt-estat-cc-cmp-fx :
    delete tt-estat-cc-cmp-fx.
end. 


for each ordem-compra where ordem-compra.cod-estabel = estat-cc-compr.cod-estabel and
         ordem-compra.numero-ordem <> 0 
         &if defined (bf_mat_contratos)
         &then and ordem-compra.nr-contrato = 0 
         &endif  and
         string(year (ordem-compra.data-emissao),"9999") + 
         string(month(ordem-compra.data-emissao),"99") = estat-cc-compr.periodo no-lock :

    assign de-valor = fn_ajust_dec((ordem-compra.qt-solic * ordem-compra.preco-unit), 
                                    ordem-compra.mo-codigo).                                        

    find item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.            

    find first estat-cc-faixa where estat-cc-faixa.cod-estabel = ordem-compra.cod-estabel 
         and   estat-cc-faixa.vlr-inicio <= de-valor  
         and   estat-cc-faixa.vlr-fim >= de-valor no-lock no-error.

       if not avail estat-cc-faixa  then 
       find last estat-cc-faixa where
                 estat-cc-faixa.cod-estabel = ordem-compra.cod-estabel and
                 estat-cc-faixa.vlr-inicio >= de-valor no-lock no-error.

       if not avail estat-cc-faixa then next.

        find tt-estat-cc-cmp-fx where 
             tt-estat-cc-cmp-fx.cod-estabel = ordem-compra.cod-estabel      and  
             tt-estat-cc-cmp-fx.periodo     = (string(year (data-emissao),"9999") + 
                                               string(month(data-emissao),"99")) and
             tt-estat-cc-cmp-fx.cod-comprado  = ordem-compra.cod-comprado and
             tt-estat-cc-cmp-fx.cod-faixa   = estat-cc-faixa.cod-faixa and
             tt-estat-cc-cmp-fx.vlr-inicio  = estat-cc-faixa.vlr-inicio and
             tt-estat-cc-cmp-fx.vlr-fim  = estat-cc-faixa.vlr-fim no-error.        

        if not avail tt-estat-cc-cmp-fx
        then do:
            create tt-estat-cc-cmp-fx.
            assign tt-estat-cc-cmp-fx.cod-estabel = ordem-compra.cod-estabel
                    tt-estat-cc-cmp-fx.periodo     = (string(year (data-emissao),"9999") + 
                                                     string(month(data-emissao),"99"))
                   tt-estat-cc-cmp-fx.cod-comprado = ordem-compra.cod-comprado
                   tt-estat-cc-cmp-fx.cod-faixa   = estat-cc-faixa.cod-faixa
                   tt-estat-cc-cmp-fx.vlr-inicio   = estat-cc-faixa.vlr-inicio                   
                   tt-estat-cc-cmp-fx.vlr-fim   = estat-cc-faixa.vlr-fim                   

                   
                   tt-estat-cc-cmp-fx.qtd-ordens-faixa = 0.
        end.
        assign tt-estat-cc-cmp-fx.qtd-ordens-faixa = tt-estat-cc-cmp-fx.qtd-ordens-faixa + 1.        
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-return-compr V-table-Win 
PROCEDURE pi-return-compr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def output param p-cod-comprado like estat-cc-compr.cod-comprado.
  def output param p-cod-estabel  like estat-cc-compr.cod-estabel.

  assign p-cod-comprado = estat-cc-compr.cod-comprado:screen-value in frame {&FRAME-NAME}
         p-cod-estabel  = estat-cc-compr.cod-estabel:screen-value in frame {&FRAME-NAME}.

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
  {src/adm/template/snd-list.i "estat-cc-compr"}

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


