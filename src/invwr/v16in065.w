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
{include/i-prgvrs.i V16IN065 2.00.00.037} /*** "010037" 26/10/2026 09:04:13 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V16IN065 MUT}
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

/*********************************************
**Inicio das altera‡äes feitas por Nuno Santo*
**********************************************/

def new global shared var i-moeda-g as integer format ">9" no-undo.
def new global shared var i-conv-g as date format "99/99/9999" initial today no-undo.
def new global shared var da-conv-g as date format "99/99/9999" initial today no-undo.
def new global shared var l-cancela as logical no-undo init yes.
def new global shared var l-conv-g  as log view-as RADIO-SET horizontal RADIO-BUTTONS "Cotacao",yes,"Atual",no no-undo. 
def new global shared var c-nr-contrato like item-contrat.nr-contrato no-undo.

/*********************************************
** Fim das altera‡äes feitas por Nuno Santo  *
**********************************************/

{cdp/cdcfgmat.i}
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
assign i-moeda-g = 0.

DEFINE VARIABLE de-valor-convertido             LIKE contrato-for.sld-val       NO-UNDO.
DEFINE VARIABLE dt-converte-moeda               LIKE contrato-for.dt-contrato   NO-UNDO.
DEFINE VARIABLE de-soma-limite-itens            LIKE item-contrat.val-total     NO-UNDO.
DEFINE VARIABLE de-limite-item                  LIKE item-contrat.val-total     NO-UNDO.
DEFINE VARIABLE de-total-valor-movimentado-item LIKE item-contrat.sld-val       NO-UNDO.
DEFINE VARIABLE de-soma-val-receb-itens         LIKE item-contrat.sld-val-receb NO-UNDO.

{cnp/cnapi006.i} /* defini‡Æo tt-saldos-itens-contrato */

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
&Scoped-define EXTERNAL-TABLES contrato-for
&Scoped-define FIRST-EXTERNAL-TABLE contrato-for


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR contrato-for.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS contrato-for.cod-tipo-contrat ~
contrato-for.dec-2 contrato-for.sld-val contrato-for.sld-val-receb ~
contrato-for.sld-val-liber 
&Scoped-define ENABLED-TABLES contrato-for
&Scoped-define FIRST-ENABLED-TABLE contrato-for
&Scoped-Define ENABLED-OBJECTS RECT-27 RECT-28 
&Scoped-Define DISPLAYED-FIELDS contrato-for.nr-contrato ~
contrato-for.des-contrat contrato-for.cod-tipo-contrat contrato-for.dec-2 ~
contrato-for.sld-val contrato-for.sld-val-receb contrato-for.sld-val-liber 
&Scoped-define DISPLAYED-TABLES contrato-for
&Scoped-define FIRST-DISPLAYED-TABLE contrato-for
&Scoped-Define DISPLAYED-OBJECTS fi-tipo-contrat i-mo-contrat ~
c-mo-contrat-descr c-moeda de-valor-total-itens d-saldo-contrato ~
d-saldo-contrato-receber 

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
DEFINE VARIABLE c-mo-contrat-descr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE d-saldo-contrato AS DECIMAL FORMAT "->>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE d-saldo-contrato-receber AS DECIMAL FORMAT "->>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Saldo Contrato a Receber" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-total-itens AS DECIMAL FORMAT "->>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tipo-contrat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-mo-contrat AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4.29 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.43 BY 3.42.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.43 BY 4.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     contrato-for.nr-contrato AT ROW 1.33 COL 20.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     contrato-for.des-contrat AT ROW 1.33 COL 29.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 43.43 BY .88
     contrato-for.cod-tipo-contrat AT ROW 2.33 COL 20.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     fi-tipo-contrat AT ROW 2.33 COL 23.86 COLON-ALIGNED NO-LABEL
     i-mo-contrat AT ROW 3.29 COL 20.14 COLON-ALIGNED
     c-mo-contrat-descr AT ROW 3.29 COL 25 COLON-ALIGNED NO-LABEL
     c-moeda AT ROW 3.29 COL 59.14 COLON-ALIGNED
     contrato-for.dec-2 AT ROW 5 COL 23 COLON-ALIGNED HELP
          "" WIDGET-ID 4
          LABEL "Valor Total" FORMAT "->>>,>>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 23 BY .88
     de-valor-total-itens AT ROW 5 COL 68 COLON-ALIGNED
     contrato-for.sld-val AT ROW 6 COL 23 COLON-ALIGNED FORMAT "->>,>>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 23 BY .88
     d-saldo-contrato AT ROW 6 COL 68 COLON-ALIGNED
     contrato-for.sld-val-receb AT ROW 7 COL 23 COLON-ALIGNED FORMAT "->>>,>>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 23 BY .88
     d-saldo-contrato-receber AT ROW 7 COL 68 COLON-ALIGNED WIDGET-ID 2
     contrato-for.sld-val-liber AT ROW 8 COL 23 COLON-ALIGNED FORMAT "->>,>>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 23 BY .88
     RECT-27 AT ROW 1.08 COL 1.29
     RECT-28 AT ROW 4.63 COL 1.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.contrato-for
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
         HEIGHT             = 8.04
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

/* SETTINGS FOR FILL-IN c-mo-contrat-descr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-saldo-contrato IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-saldo-contrato-receber IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-total-itens IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN contrato-for.dec-2 IN FRAME f-main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN contrato-for.des-contrat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tipo-contrat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-mo-contrat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN contrato-for.nr-contrato IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN contrato-for.sld-val IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN contrato-for.sld-val-liber IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN contrato-for.sld-val-receb IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

    {utp/ut-liter.i Valor_Total * r}
    assign contrato-for.dec-2:label in frame {&frame-name} = return-value.

    {utp/ut-liter.i Valor_Movimentado * r}
    assign contrato-for.sld-val:label in frame {&frame-name} = return-value.

    {utp/ut-liter.i Valor_Recebido * r}
    assign contrato-for.sld-val-receb:label in frame {&frame-name} = return-value.

    {utp/ut-liter.i Liberado_a_Receber * r}
    assign contrato-for.sld-val-liber:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "contrato-for"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "contrato-for"}

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
   RETURN 'ADM-ERROR':U.
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

  IF AVAIL contrato-for THEN DO:
      ASSIGN c-nr-contrato = contrato-for.nr-contrato.

      FIND FIRST tipo-contrat 
           WHERE tipo-contrat.cod-tipo-contr = contrato-for.cod-tipo-contrat 
           NO-LOCK NO-ERROR.
    
      if avail tipo-contrat then 
         assign fi-tipo-contrat = tipo-contrat.des-tipo-contrat.
      else
        assign fi-tipo-contrat = "":U.
    
      FIND FIRST moeda WHERE moeda.mo-codigo = contrato-for.mo-codigo NO-LOCK NO-ERROR.
    
      if avail moeda then
        assign i-mo-contrat = moeda.mo-codigo
               c-mo-contrat-descr = moeda.descricao.
    
      assign de-soma-limite-itens = 0
             de-total-valor-movimentado-item = 0
             de-soma-val-receb-itens = 0.
      
      IF NOT VALID-HANDLE(h-cnapi006) THEN
          RUN cnp/cnapi006.p PERSISTENT SET h-cnapi006.

      RUN pi-saldos-itens-contrato IN h-cnapi006 (INPUT contrato-for.nr-contrato,
                                                  OUTPUT TABLE tt-saldos-itens-contrato).
      IF VALID-HANDLE(h-cnapi006) THEN DO:
          DELETE PROCEDURE h-cnapi006.
          ASSIGN h-cnapi006 = ?.
      END.
    
      FIND FIRST tt-saldos-itens-contrato NO-ERROR.
      assign  de-valor-total-itens            = tt-saldos-itens-contrato.lim-val
              de-soma-val-receb-itens         = tt-saldos-itens-contrato.val-receb
              de-total-valor-movimentado-item = tt-saldos-itens-contrato.val-mov.

      /*DEC-2 = Limite de Valor do Contrato*/
      IF contrato-for.dec-2 = 0 THEN
          ASSIGN d-saldo-contrato = de-valor-total-itens - de-total-valor-movimentado-item
                 d-saldo-contrato-receber = de-valor-total-itens - de-soma-val-receb-itens.
      ELSE
          ASSIGN d-saldo-contrato = contrato-for.dec-2 - de-total-valor-movimentado-item
                 d-saldo-contrato-receber = contrato-for.dec-2 - contrato-for.sld-val-receb.
              
      DISP d-saldo-contrato
           d-saldo-contrato-receber
           de-valor-total-itens
          WITH FRAME {&frame-name}.
      
  END. /*FIM - IF AVAIL contrato-for */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF NOT AVAIL contrato-for THEN
      find first contrato-for 
           where contrato-for.nr-contrato = input frame {&frame-name} contrato-for.nr-contrato NO-LOCK NO-ERROR. 

  if avail contrato-for then do:
      FIND FIRST moeda where moeda.mo-codigo = i-moeda-g no-lock no-error.
      assign c-moeda:screen-value IN FRAME {&FRAME-NAME} = moeda.descricao.
 

        /***********************************************
        * Consulta Multi-Moeda em Controle Contratos   *
        ***********************************************/
        &if defined (bf_mat_contrato_moedas) &then
        
            ASSIGN dt-converte-moeda = IF l-conv-g THEN contrato-for.dt-contrato ELSE da-conv-g.

            /* Valor Total */
            run cdp/cd0812.p (input contrato-for.mo-codigo,
                              input i-moeda-g,
                              input contrato-for.dec-2,
                              input dt-converte-moeda,
                              output de-valor-convertido).
           
            ASSIGN contrato-for.dec-2:screen-value in frame {&FRAME-NAME} = IF de-valor-convertido = ? THEN string(0) ELSE string(de-valor-convertido).

            /* Valor Movimentado */
            run cdp/cd0812.p (input contrato-for.mo-codigo,
                              input i-moeda-g,
                              input contrato-for.sld-val,
                              input dt-converte-moeda,
                              output de-valor-convertido).
       
            assign contrato-for.sld-val:screen-value in frame {&FRAME-NAME} = if de-valor-convertido = ? THEN string(0) ELSE string(de-valor-convertido).

            /* Valor Recebido */
            run cdp/cd0812.p (input contrato-for.mo-codigo,
                              input i-moeda-g,
                              input contrato-for.sld-val-receb,
                              input dt-converte-moeda,
                              output de-valor-convertido).
           
            assign contrato-for.sld-val-receb:screen-value in frame {&FRAME-NAME} = IF de-valor-convertido = ? THEN string(0) ELSE string(de-valor-convertido).

            /* Liberado a Receber */
            run cdp/cd0812.p (input contrato-for.mo-codigo,
                              input i-moeda-g,
                              input contrato-for.sld-val-liber,
                              input dt-converte-moeda,
                              output de-valor-convertido).
           
            ASSIGN contrato-for.sld-val-liber:screen-value in frame {&FRAME-NAME} = IF de-valor-convertido = ? THEN string(0) ELSE string(de-valor-convertido).
            
            /* Valor Total Itens */
            run cdp/cd0812.p (input contrato-for.mo-codigo,
                              input i-moeda-g,
                              input de-valor-total-itens,
                              input dt-converte-moeda,
                              output de-valor-convertido).

            ASSIGN de-valor-total-itens:screen-value in frame {&FRAME-NAME} = IF de-valor-convertido = ? THEN string(0) ELSE string(de-valor-convertido). 
            
            /* Saldo Contrato a Movimentar */
            run cdp/cd0812.p (input contrato-for.mo-codigo,
                              input i-moeda-g,
                              input d-saldo-contrato,
                              INPUT dt-converte-moeda,
                              output de-valor-convertido).
        
            ASSIGN d-saldo-contrato:screen-value in frame {&FRAME-NAME} = IF (de-valor-convertido = ? OR de-valor-convertido < 0) THEN string(0) 
                                                                          ELSE string(de-valor-convertido).

            /* Saldo Contrato a Receber */
            run cdp/cd0812.p (input contrato-for.mo-codigo,
                              input i-moeda-g,
                              input d-saldo-contrato-receber,
                              INPUT dt-converte-moeda,
                              output de-valor-convertido).
        
            ASSIGN d-saldo-contrato-receber:screen-value in frame {&FRAME-NAME} = IF (de-valor-convertido = ? OR de-valor-convertido < 0) THEN string(0) 
                                                                                  ELSE string(de-valor-convertido).
      
        &endif
        /*************************************************
        * Fim Consulta Multi-Moeda em Controle Contratos *
        **************************************************/

        /*DEC-2 = Limite de Valor do Contrato*/
        IF contrato-for.dec-2 = 0 THEN
            ASSIGN contrato-for.dec-2:SCREEN-VALUE IN FRAME {&frame-name} = de-valor-total-itens:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  END.
    

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

  {utp/ut-liter.i Valor_Movimentado}
  assign contrato-for.sld-val:label in frame {&FRAME-NAME} = return-value. 

 {utp/ut-liter.i Valor_Recebido MCN R}
  assign contrato-for.sld-val-receb:label in frame {&FRAME-NAME} = return-value. 


  {utp/ut-liter.i Modalidade}
  assign contrato-for.cod-tipo-contrat:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Moeda}
  assign c-moeda:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Moeda_Contrato}
  assign i-mo-contrat:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Valor_Total_Itens}
  assign de-valor-total-itens:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Saldo_Contrato_a_Movimentar}
  ASSIGN d-saldo-contrato:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  {utp/ut-liter.i Saldo_Contrato_a_Receber}
  ASSIGN d-saldo-contrato-receber:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .




  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view V-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

&if defined (bf_mat_contrato_moedas) &then

&else
  c-moeda:hidden in frame {&FRAME-NAME} = yes.
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
  {src/adm/template/snd-list.i "contrato-for"}

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

