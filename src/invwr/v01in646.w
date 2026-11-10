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
{include/i-prgvrs.i V01IN646 2.00.00.004}  /*** 010004 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in646 MUT}
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

def var de-total    as decimal format "->>>,>>>,>>9.9999" no-undo.
def var de-qtde     as decimal format "->>>,>>>,>>9.9999" no-undo.
def var c-periodo   like consumo.periodo no-undo.

/* Defini‡Æo de Vari veis para o Gr fico ------------------------------------------*/
{utp/utapi001.i}

define temp-table tt-digita
    field marca          as char format "x(01)"  COLUMN-LABEL ""
    field fm-codigo      like familia.fm-codigo
    field descricao      like familia.descricao
    index id is primary unique fm-codigo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES estat-cc-fam
&Scoped-define FIRST-EXTERNAL-TABLE estat-cc-fam


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estat-cc-fam.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estat-cc-fam.qtd-pec-faixa 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}qtd-pec-faixa ~{&FP2}qtd-pec-faixa ~{&FP3}
&Scoped-define ENABLED-TABLES estat-cc-fam
&Scoped-define FIRST-ENABLED-TABLE estat-cc-fam
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS estat-cc-fam.cod-estabel ~
estat-cc-fam.periodo estat-cc-fam.cod-faixa estat-cc-fam.fm-codigo ~
estat-cc-fam.qtd-pec-faixa 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS estat-cc-fam.cod-estabel ~
estat-cc-fam.periodo estat-cc-fam.cod-faixa estat-cc-fam.fm-codigo 

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
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estat-cc-fam.cod-estabel AT ROW 1.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     estat-cc-fam.periodo AT ROW 2.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     estat-cc-fam.cod-faixa AT ROW 3.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     estat-cc-fam.fm-codigo AT ROW 4.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     estat-cc-fam.qtd-pec-faixa AT ROW 5.75 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 5.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estat-cc-fam
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 6.04
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

/* SETTINGS FOR FILL-IN estat-cc-fam.cod-estabel IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN estat-cc-fam.cod-faixa IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN estat-cc-fam.fm-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN estat-cc-fam.periodo IN FRAME f-main
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
  {src/adm/template/row-list.i "estat-cc-fam"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estat-cc-fam"}

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
         input frame {&FRAME-NAME} estat-cc-fam.cod-estabel no-lock no-error.
    if not available estabelec
    then do:
        run utp/ut-msgs.p (input "show",
                           input 4802,
                           input "").
        apply "entry" to estat-cc-fam.cod-estabel in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.

    if int(substr(string(input frame {&FRAME-NAME} estat-cc-fam.periodo),5,2)) < 1 or 
       int(substr(string(input frame {&FRAME-NAME} estat-cc-fam.periodo),5,2)) > 12
    then do:
        run utp/ut-msgs.p (input "show",
                           input 3767,
                           input "").
        apply "entry" to estat-cc-fam.periodo in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.

    if int(substr(string(input frame {&FRAME-NAME} estat-cc-fam.periodo),1,4)) < 1990 or 
       int(substr(string(input frame {&FRAME-NAME} estat-cc-fam.periodo),1,4)) > year(today) + 1
    then do:
        run utp/ut-msgs.p (input "show",
                           input 1655,
                           input "").
        apply "entry" to estat-cc-fam.periodo in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.

    find familia where familia.fm-codigo =
         input frame {&FRAME-NAME} estat-cc-fam.fm-codigo no-lock no-error.
    if not available familia
    then do:
        run utp/ut-msgs.p (input "show",
                           input 7636,
                           input "").
        apply "entry" to estat-cc-fam.fm-codigo in frame {&FRAME-NAME}.
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

    def input parameter table for tt-digita.
    def var de-outros as deci no-undo init 0.

    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.

    {utp/ut-liter.i Qtde_Acumulada_PECs_X_Fam¡lia_Material}
    assign c-tit-graf = return-value.
    
    {utp/ut-liter.i Fam¡lia_Material}
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
                                  estat-cc-fam.periodo:screen-value in frame {&FRAME-NAME}
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

    for each estat-cc-fam no-lock
       where estat-cc-fam.cod-estabel = estat-cc-fam.cod-estabel:screen-value in frame {&FRAME-NAME} 
         and estat-cc-fam.periodo = string(substr(estat-cc-fam.periodo:screen-value,1,4) +
                                    string(substr(estat-cc-fam.periodo:screen-value,6,2),"99"))
        break by estat-cc-fam.fm-codigo:

        if first-of(estat-cc-fam.fm-codigo)
        then do:
            assign de-total  = 0
                   de-qtde   = 0.
        end.
        find first tt-digita where tt-digita.fm-codigo = estat-cc-fam.fm-codigo no-lock no-error.
        if not available tt-digita
        then
            next.
        if tt-digita.marca = ""
        then do:
            assign de-outros = de-outros + estat-cc-fam.qtd-pec-faixa.
            next.
        end.
        assign de-qtde = de-qtde + estat-cc-fam.qtd-pec-faixa.

        if last-of(estat-cc-fam.fm-codigo)
        then do:
            assign i-conta-points = i-conta-points + 1.

            create tt-points.
            assign tt-points.numgraph  = 1
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = estat-cc-fam.fm-codigo.
            create tt-dados.
            assign tt-dados.numgraph              = 1
                   tt-dados.numpoint              = i-conta-points
                   tt-dados.numset                = 1
                   tt-dados.graphdata             = de-qtde.
        end.
    end.
    if de-outros > 0
    then do:
            assign i-conta-points = i-conta-points + 1.

            create tt-points.
            assign tt-points.numgraph  = 1
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = "Outros".
            create tt-dados.
            assign tt-dados.numgraph              = 1
                   tt-dados.numpoint              = i-conta-points
                   tt-dados.numset                = 1
                   tt-dados.graphdata             = de-outros.
    end.
    
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

    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable c-familia         as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.

    {utp/ut-liter.i Qtde_PECs_X_Faixa_Valores}
    assign c-tit-graf = return-value.
    
    {utp/ut-liter.i Faixa_Valores}
    assign c-tit-y = return-value.
    
    {utp/ut-liter.i Qtde_Pedidos_Compra}
    assign c-tit-x = return-value.

    find familia where familia.fm-codigo = estat-cc-fam.fm-codigo:screen-value in frame {&FRAME-NAME}
         no-lock no-error.

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
                                  estat-cc-fam.periodo:screen-value in frame {&FRAME-NAME} + "  " +
                                  estat-cc-fam.fm-codigo:screen-value in frame {&FRAME-NAME} + " - " +
                                  if avail familia then familia.descricao else ""
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

    for each estat-cc-fam no-lock
       where estat-cc-fam.cod-estabel = estat-cc-fam.cod-estabel:screen-value in frame {&FRAME-NAME} 
         and estat-cc-fam.periodo = string(substr(estat-cc-fam.periodo:screen-value,1,4) +
                                       string(substr(estat-cc-fam.periodo:screen-value,6,2),"99"))
         and estat-cc-fam.fm-codigo = estat-cc-fam.fm-codigo:screen-value in frame {&FRAME-NAME} 
        break by estat-cc-fam.cod-faixa:

        if first-of(estat-cc-fam.cod-faixa)
        then do:
            find estat-cc-faixa of estat-cc-fam no-lock no-error.
            assign de-total = 0
                   de-qtde  = 0.
        end.
        
        if  not avail estat-cc-faixa then next. 
        
        assign de-qtde = de-qtde + estat-cc-fam.qtd-pec-faixa.
        
        if last-of(estat-cc-fam.cod-faixa)
        then do:
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
                   tt-dados.graphdata             = de-qtde.
        end.
    end.

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

    def input parameter table for tt-digita.
    def var de-outros as deci format ">>>,>>>,>>9.99" no-undo init 0.

    define variable c-tit-graf        as character                      no-undo.
    define variable c-tit-Y           as character                      no-undo.
    define variable c-tit-X           as character                      no-undo.
    define variable i-conta-points    as integer   init 0               no-undo.

    {utp/ut-liter.i Valor_Pedidos_Compra_X_Fam¡lia_Material}
    assign c-tit-graf = return-value.
    
    {utp/ut-liter.i Fam¡lia_Material}
    assign c-tit-y = return-value.
    
    {utp/ut-liter.i Valor_Pedidos_Compra}
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
                                  estat-cc-fam.periodo:screen-value in frame {&FRAME-NAME}
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

    for each estat-cc-fam no-lock
       where estat-cc-fam.cod-estabel = estat-cc-fam.cod-estabel:screen-value in frame {&FRAME-NAME} 
         and estat-cc-fam.periodo = string(substr(estat-cc-fam.periodo:screen-value,1,4) +
                                    string(substr(estat-cc-fam.periodo:screen-value,6,2),"99"))
         and estat-cc-fam.cod-faixa = 99
        break by estat-cc-fam.fm-codigo:

        if first-of(estat-cc-fam.fm-codigo)
        then do:
            assign de-total  = 0
                   de-qtde   = 0.
        end.
        find first tt-digita where tt-digita.fm-codigo = estat-cc-fam.fm-codigo no-lock no-error.
        if not available tt-digita
        then
            next.
        if tt-digita.marca = ""
        then do:
            assign de-outros = de-outros + estat-cc-fam.dec-1.
            next.
        end.
        assign de-qtde = de-qtde + estat-cc-fam.dec-1.

        if last-of(estat-cc-fam.fm-codigo)
        then do:
            assign i-conta-points = i-conta-points + 1.

            create tt-points.
            assign tt-points.numgraph  = 1
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = estat-cc-fam.fm-codigo.
            create tt-dados.
            assign tt-dados.numgraph              = 1
                   tt-dados.numpoint              = i-conta-points
                   tt-dados.numset                = 1
                   tt-dados.graphdata             = de-qtde.
        end.
    end.
    if de-outros > 0
    then do:
            assign i-conta-points = i-conta-points + 1.

            create tt-points.
            assign tt-points.numgraph  = 1
                   tt-points.numpoint  = i-conta-points
                   tt-points.labeltext = "Outros".
            create tt-dados.
            assign tt-dados.numgraph              = 1
                   tt-dados.numpoint              = i-conta-points
                   tt-dados.numset                = 1
                   tt-dados.graphdata             = de-outros.
    end.
    
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
  {src/adm/template/snd-list.i "estat-cc-fam"}

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


