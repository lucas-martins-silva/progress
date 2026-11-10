&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V03IN425 2.00.00.028 } /*** 010028 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN425 MUT}
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
def new global shared var v-row-parent as rowid no-undo.                                

/* Parameters Definitions ---                                           */
def buffer buffer-tabela for tb-pr-cc.

/* Local Variable Definitions ---                                       */
def var l-sobrepoe as logical initial no.
def var c-nome-abrev as character no-undo.
def var i-cod-cond-pag as integer no-undo.
def var c-nr-tab as character no-undo.
DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-mo-codigo AS INTEGER     NO-UNDO.
def var r-tabela as rowid no-undo.
def var h_v02in425 as handle no-undo.
def var l-date-ini as logical initial no.

{cdp/cdcfgmat.i}

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
&Scoped-define EXTERNAL-TABLES tb-pr-cc
&Scoped-define FIRST-EXTERNAL-TABLE tb-pr-cc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR tb-pr-cc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tb-pr-cc.dt-inicio tb-pr-cc.valor-frete ~
tb-pr-cc.dt-termino tb-pr-cc.frete tb-pr-cc.situacao tb-pr-cc.valor-taxa ~
tb-pr-cc.aliquota-icm tb-pr-cc.nr-dias-taxa tb-pr-cc.codigo-ipi ~
tb-pr-cc.perc-descto tb-pr-cc.taxa-financ 
&Scoped-define ENABLED-TABLES tb-pr-cc
&Scoped-define FIRST-ENABLED-TABLE tb-pr-cc
&Scoped-Define ENABLED-OBJECTS rt-key rt-key-2 
&Scoped-Define DISPLAYED-FIELDS tb-pr-cc.dt-inicio tb-pr-cc.valor-frete ~
tb-pr-cc.dt-termino tb-pr-cc.frete tb-pr-cc.situacao tb-pr-cc.valor-taxa ~
tb-pr-cc.aliquota-icm tb-pr-cc.nr-dias-taxa tb-pr-cc.codigo-ipi ~
tb-pr-cc.perc-descto tb-pr-cc.taxa-financ 
&Scoped-define DISPLAYED-TABLES tb-pr-cc
&Scoped-define FIRST-DISPLAYED-TABLE tb-pr-cc


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
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 3.58.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 4.63.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tb-pr-cc.dt-inicio AT ROW 1.21 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     tb-pr-cc.valor-frete AT ROW 1.17 COL 58.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.72 BY .88
     tb-pr-cc.dt-termino AT ROW 2.29 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     tb-pr-cc.frete AT ROW 2.25 COL 60.72
          VIEW-AS TOGGLE-BOX
          SIZE 17.43 BY .75
     tb-pr-cc.situacao AT ROW 3.25 COL 60.72 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Ativa", 1,
"Inativa", 2
          SIZE 18.29 BY .75
     tb-pr-cc.valor-taxa AT ROW 5.33 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     tb-pr-cc.aliquota-icm AT ROW 7.33 COL 58.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     tb-pr-cc.nr-dias-taxa AT ROW 6.33 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     tb-pr-cc.codigo-ipi AT ROW 5.33 COL 60.72
          VIEW-AS TOGGLE-BOX
          SIZE 15.14 BY .75
     tb-pr-cc.perc-descto AT ROW 7.33 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     tb-pr-cc.taxa-financ AT ROW 6.33 COL 60.72
          VIEW-AS TOGGLE-BOX
          SIZE 24.57 BY .75
     rt-key AT ROW 1 COL 1
     rt-key-2 AT ROW 4.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.tb-pr-cc
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
         HEIGHT             = 8.46
         WIDTH              = 85.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

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
  {src/adm/template/row-list.i "tb-pr-cc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "tb-pr-cc"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .


  /* Code placed here will execute AFTER standard behavior.    */

  assign tb-pr-cc.dt-inicio:screen-value in frame {&frame-name}  = string(today)
         tb-pr-cc.dt-termino:screen-value in frame {&frame-name} = string(today). 

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  
  /* Ponha aqui a validaá∆o de chave duplicada */
  
  /* Ponha aqui as demais validaá‰es */
  if avail tb-pr-cc then do:
      if tb-pr-cc.dt-inicio <> input frame {&FRAME-NAME} tb-pr-cc.dt-inicio then     
         assign l-date-ini = yes.
      else
         assign l-date-ini = no.   
  end.
  
  if valid-handle (h_v02in425) then 
        run pi-retorna-valores in h_v02in425 (output c-nome-abrev ,
                                              output i-cod-cond-pag ,
                                              output c-nr-tab,
                                              output c-cod-estabel,
                                              output i-mo-codigo ).

/*---- Sobreposiá∆o com datas de validade de outra tabela de preáos -----*/    
    assign l-sobrepoe = no.
    find first buffer-tabela
        where buffer-tabela.nome-abrev   = c-nome-abrev
          and buffer-tabela.cod-cond-pag = i-cod-cond-pag 
          and buffer-tabela.nr-tab      <> c-nr-tab
          AND buffer-tabela.cod-estabel  = c-cod-estabel
          AND buffer-tabela.mo-codigo    = i-mo-codigo
          and buffer-tabela.situacao     = 1  /* 1= ativa (Procura apenas por tabelas ativas)*/  
        no-lock no-error.
    if avail buffer-tabela then do:
        if input frame {&frame-name} tb-pr-cc.dt-inicio  <= buffer-tabela.dt-termino and
           input frame {&frame-name} tb-pr-cc.dt-termino >= buffer-tabela.dt-inicio 
        then do:
            IF  input frame {&frame-name} tb-pr-cc.situacao = 1 THEN /*ao modificar verifica se a tabela est† ativa ou n∆o para permitir a modificaá∆o*/
                ASSIGN l-sobrepoe = yes.
            
        end.
        do while available buffer-tabela:
            find next buffer-tabela use-index ch-codigo 
                where buffer-tabela.nome-abrev   = c-nome-abrev 
                  and buffer-tabela.cod-cond-pag = i-cod-cond-pag 
                  and buffer-tabela.nr-tab <> c-nr-tab
                  AND buffer-tabela.cod-estabel  = c-cod-estabel
                  AND buffer-tabela.mo-codigo    = i-mo-codigo no-lock no-error.
            if available buffer-tabela then do:    
                if input frame {&frame-name} tb-pr-cc.dt-inicio  <= buffer-tabela.dt-termino and
                   input frame {&frame-name} tb-pr-cc.dt-termino >= buffer-tabela.dt-inicio then
                   assign l-sobrepoe = yes.
            end.
        end.
    end.
    if l-sobrepoe = yes then do:
        run utp/ut-msgs.p (input "show",
                           input 1276,
                           input "").
        apply "entry" to tb-pr-cc.dt-inicio in frame {&frame-name}.
        return 'adm-error'.
    end.
   
if input frame {&frame-name} tb-pr-cc.dt-inicio > 
   input frame {&frame-name} tb-pr-cc.dt-termino then do:
    run utp/ut-msgs.p (input "show",
                       input 137,
                       input "").
    apply 'entry' to tb-pr-cc.dt-inicio in frame {&frame-name}.
    return 'adm-error'.
end.
    
      
  
  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

&if defined(bf_mat_contratos) &then 
IF l-date-ini THEN DO:
    FOR EACH item-tab WHERE 
        item-tab.nr-tab       = tb-pr-cc.nr-tab and
        item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag and
        item-tab.cod-emitente = tb-pr-cc.cod-emitente AND 
        item-tab.cod-estabel  = tb-pr-cc.cod-estabel  AND
        item-tab.mo-codigo    = tb-pr-cc.mo-codigo exclusive-lock:              
        ASSIGN item-tab.dt-inicio = tb-pr-cc.dt-inicio.        
    END.   
END.
&endif

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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  if  avail param-compra then do:
      assign tb-pr-cc.aliquota-icm:sensitive in frame {&frame-name} = param-compra.utiliza-icm
             tb-pr-cc.taxa-financ:sensitive in frame {&frame-name}  = param-compra.utiliza-taxa
             tb-pr-cc.nr-dias-taxa:sensitive in frame {&frame-name} = param-compra.utiliza-taxa
             tb-pr-cc.valor-taxa:sensitive in frame {&frame-name}   = param-compra.utiliza-taxa.
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
  find first param-compra no-lock no-error.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-data V-table-Win 
PROCEDURE pi-retorna-data:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter p-data-inic   like tb-pr-cc.dt-inicio.
def output parameter p-data-fim    like tb-pr-cc.dt-termino.

assign p-data-inic = input frame {&frame-name} tb-pr-cc.dt-inicio
       p-data-fim  = input frame {&frame-name} tb-pr-cc.dt-termino.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-data V-table-Win 
PROCEDURE pi-seta-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-data-ini as date  no-undo.
    
    assign tb-pr-cc.dt-inicio:screen-value in frame {&frame-name} = string(p-data-ini)
           tb-pr-cc.dt-termino:screen-value in frame {&frame-name} = string(p-data-ini).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-handle V-table-Win 
PROCEDURE pi-seta-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-handle as handle.

assign h_v02in425 = p-handle.

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
  {src/adm/template/snd-list.i "tb-pr-cc"}

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

