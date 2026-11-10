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
{include/i-prgvrs.i V34IN245 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V34IN245 MUT}
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

def var h-cabecalho as handle  no-undo.
def var c-tipo      as char    no-undo.

{cdp/cd4300.i3}              /* Definicao var para o cd4300.i4  */
{cdp/cd0604.i50}             /* Definicao var para o cd0604.i51 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES natur-oper
&Scoped-define FIRST-EXTERNAL-TABLE natur-oper


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR natur-oper.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS natur-oper.calc-auto natur-oper.emite-duplic ~
natur-oper.auto-cr natur-oper.baixa-estoq natur-oper.ind-contabilizacao ~
natur-oper.auto-ce natur-oper.auto-ct natur-oper.atual-estat ~
natur-oper.baixa-ship natur-oper.auto-est 
&Scoped-define FIELD-PAIRS
&Scoped-define ENABLED-TABLES natur-oper
&Scoped-define FIRST-ENABLED-TABLE natur-oper
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-3 
&Scoped-Define DISPLAYED-FIELDS natur-oper.calc-auto ~
natur-oper.emite-duplic natur-oper.auto-cr natur-oper.baixa-estoq ~
natur-oper.ind-contabilizacao natur-oper.auto-ce natur-oper.auto-ct ~
natur-oper.atual-estat natur-oper.baixa-ship natur-oper.auto-est 
&Scoped-Define DISPLAYED-OBJECTS tb-sc-transven l-emite-remito ~
l-gera-prevcr tg-atu-cota 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS tb-sc-transven l-emite-remito ~
l-gera-prevcr tg-atu-cota 
&Scoped-define ADM-ASSIGN-FIELDS tb-sc-transven l-emite-remito ~
l-gera-prevcr tg-atu-cota 
&Scoped-define ADM-MODIFY-FIELDS tb-sc-transven l-emite-remito ~
l-gera-prevcr tg-atu-cota 

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
DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37.14 BY 5.92.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36.29 BY 5.92.

DEFINE VARIABLE l-emite-remito AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-gera-prevcr AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.29 BY .83 NO-UNDO.

DEFINE VARIABLE tb-sc-transven AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-atu-cota AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.43 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     natur-oper.calc-auto AT ROW 1.25 COL 2.14
          VIEW-AS TOGGLE-BOX
          SIZE 23.43 BY .83
     natur-oper.emite-duplic AT ROW 1.25 COL 40.14
          VIEW-AS TOGGLE-BOX
          SIZE 20.14 BY .83
     tb-sc-transven AT ROW 2 COL 2.14
     natur-oper.auto-cr AT ROW 2 COL 40.14
          VIEW-AS TOGGLE-BOX
          SIZE 18.72 BY .83
     natur-oper.baixa-estoq AT ROW 2.75 COL 2.14
          VIEW-AS TOGGLE-BOX
          SIZE 18.86 BY .83
     natur-oper.ind-contabilizacao AT ROW 2.75 COL 40.14
          VIEW-AS TOGGLE-BOX
          SIZE 24.57 BY .83
     natur-oper.auto-ce AT ROW 3.5 COL 2.14
          VIEW-AS TOGGLE-BOX
          SIZE 18.57 BY .83
     natur-oper.auto-ct AT ROW 3.5 COL 40.14
          VIEW-AS TOGGLE-BOX
          SIZE 18.43 BY .83
     l-emite-remito AT ROW 4.25 COL 2.14
     natur-oper.atual-estat AT ROW 4.25 COL 40.14
          VIEW-AS TOGGLE-BOX
          SIZE 23.57 BY .83
     natur-oper.baixa-ship AT ROW 5 COL 2.14
          VIEW-AS TOGGLE-BOX
          SIZE 34.57 BY .83
     natur-oper.auto-est AT ROW 5 COL 40.14
          VIEW-AS TOGGLE-BOX
          SIZE 21.29 BY .83
     l-gera-prevcr AT ROW 5.75 COL 2.14
     tg-atu-cota AT ROW 5.75 COL 40.14
     RECT-4 AT ROW 1 COL 39
     RECT-3 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.natur-oper
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
         HEIGHT             = 5.92
         WIDTH              = 74.29.
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

/* SETTINGS FOR TOGGLE-BOX l-emite-remito IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX l-gera-prevcr IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX tb-sc-transven IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX tg-atu-cota IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
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

&Scoped-define SELF-NAME natur-oper.atual-estat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.atual-estat V-table-Win
ON VALUE-CHANGED OF natur-oper.atual-estat IN FRAME f-main /* Atualiza Estat°stica */
DO:
    /*
    if natur-oper.atual-estat:checked in frame {&frame-name} then
       assign natur-oper.auto-est:sensitive in frame {&frame-name} = yes.
    else
       assign natur-oper.auto-est:sensitive in frame {&frame-name} = no
              natur-oper.auto-est:checked   in frame {&frame-name} = no.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.baixa-estoq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.baixa-estoq V-table-Win
ON VALUE-CHANGED OF natur-oper.baixa-estoq IN FRAME f-main /* Baixa Estoque */
DO:
 if natur-oper.baixa-estoq:checked in frame {&frame-name} = no then do:
      assign natur-oper.baixa-ship:checked   in frame {&frame-name} = no
          /* natur-oper.auto-ce:checked      in frame {&frame-name} = no */
             natur-oper.baixa-ship:sensitive in frame {&frame-name} = no.
          /* natur-oper.auto-ce:sensitive    in frame {&frame-name} = no.*/
  end.
/*else
      assign natur-oper.auto-ce:sensitive in frame {&frame-name} = yes. */
      
  if natur-oper.baixa-estoq:checked in frame {&frame-name} = yes and
     natur-oper.calc-auto:checked   in frame {&frame-name} = no  and
     l-emite-remito:checked         in frame {&frame-name} = yes 
  then assign natur-oper.baixa-ship:sensitive in frame {&frame-name} = yes.
  else assign natur-oper.baixa-ship:sensitive in frame {&frame-name} = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.calc-auto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.calc-auto V-table-Win
ON VALUE-CHANGED OF natur-oper.calc-auto IN FRAME f-main /* C†lculo Autom†tico */
DO:
  if input frame {&frame-name} natur-oper.calc-auto = yes then
     assign l-emite-remito:checked          in frame {&frame-name} = no
            natur-oper.baixa-ship:checked   in frame {&frame-name} = no
            l-gera-prevcr:checked           in frame {&frame-name} = no
            l-emite-remito:sensitive        in frame {&frame-name} = no
            natur-oper.baixa-ship:sensitive in frame {&frame-name} = no
            l-gera-prevcr:sensitive         in frame {&frame-name} = no.
  else
     assign l-emite-remito:sensitive        in frame {&frame-name} = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.emite-duplic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.emite-duplic V-table-Win
ON VALUE-CHANGED OF natur-oper.emite-duplic IN FRAME f-main /* Gera Duplicatas */
DO:
    /*
    if natur-oper.emite-duplic:checked     in frame {&frame-name} then
        assign natur-oper.auto-cr:sensitive in frame {&frame-name} = yes.
    else
        assign natur-oper.auto-cr:sensitive in frame {&frame-name} = no
               natur-oper.auto-cr:checked   in frame {&frame-name} = no.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.ind-contabilizacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.ind-contabilizacao V-table-Win
ON VALUE-CHANGED OF natur-oper.ind-contabilizacao IN FRAME f-main /* Gera Contabilizaá∆o */
DO:
    /*
    if natur-oper.ind-contabilizacao:checked in frame {&frame-name} then
        assign natur-oper.auto-ct:sensitive  in frame {&frame-name} = yes.
    else
       assign natur-oper.auto-ct:sensitive in frame {&frame-name} = no
              natur-oper.auto-ct:checked   in frame {&frame-name} = no.
    */          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-emite-remito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-emite-remito V-table-Win
ON VALUE-CHANGED OF l-emite-remito IN FRAME f-main
DO:
  if input frame {&frame-name} l-emite-remito:checked = yes then
    assign l-gera-prevcr:sensitive         in frame {&frame-name} = yes.
  else
    assign l-gera-prevcr:checked           in frame {&frame-name} = no 
           l-gera-prevcr:sensitive         in frame {&frame-name} = no
           natur-oper.baixa-ship:checked   in frame {&frame-name} = no
           natur-oper.baixa-ship:sensitive in frame {&frame-name} = no.
           
  if natur-oper.baixa-estoq:checked in frame {&frame-name} = yes and
     natur-oper.calc-auto:checked   in frame {&frame-name} = no  and
     l-emite-remito:checked         in frame {&frame-name} = yes 
  then assign natur-oper.baixa-ship:sensitive in frame {&frame-name} = yes.
  else assign natur-oper.baixa-ship:sensitive in frame {&frame-name} = no.
           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  {utp/ut-liter.i Imprime_NF_Auto * L}
  assign tb-sc-transven:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Atualiza_Cotas * L}
  assign tg-atu-cota:label in frame {&frame-name} = trim(return-value).
 
  {utp/ut-liter.i Atualiza_Estoque * R}
  assign natur-oper.baixa-estoq:label in frame {&frame-name} = trim(return-value).
       
  {utp/ut-liter.i Atualiza_Estoque_pelo_Remito *}
  assign natur-oper.baixa-ship:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Emite_Remito *}
  assign l-emite-remito:label in frame {&frame-name} = trim(return-value).
  
  {utp/ut-liter.i Atualiza_CR *}
  assign natur-oper.emite-duplic:label in frame {&frame-name} = trim(return-value).  

  {utp/ut-liter.i Remito_Gera_Previs∆o_CR *}
  assign l-gera-prevcr:label in frame {&frame-name} = trim(return-value).

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
  {src/adm/template/row-list.i "natur-oper"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "natur-oper"}

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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
  if avail param-global and
           param-global.modulo-08 = yes
  then assign tg-atu-cota:sensitive in frame {&frame-name} = yes.
  else assign tg-atu-cota:sensitive in frame {&frame-name} = no.
  
  assign natur-oper.calc-auto:checked   in frame {&frame-name} = yes
         natur-oper.baixa-estoq:checked in frame {&frame-name} = yes.
  
  apply "value-changed" to natur-oper.calc-auto.
  apply "value-changed" to natur-oper.baixa-estoq.
  apply "value-changed" to l-emite-remito.
  apply "value-changed" to natur-oper.emite-duplic.
  apply "value-changed" to natur-oper.ind-contabilizacao.
  apply "value-changed" to natur-oper.atual-estat.  

  /* Code placed here will execute AFTER standard behavior.    */

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
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).
    if RETURN-VALUE = 'ADM-ERROR':U then
        return 'ADM-ERROR':U.
        
     
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

    /***Imprime nota fiscal auto***/
    if tb-sc-transven:checked in frame {&FRAME-NAME} = yes 
       then assign natur-oper.sc-transven = '1'.
       else assign natur-oper.sc-transven = '0'.

    assign natur-oper.baixa-ship = input frame {&frame-name} natur-oper.baixa-ship.
 
    
    /***Atualiza Cotas***/
    if avail param-global and
             param-global.modulo-08 
    then assign substr(natur-oper.char-2,31,5) = if tg-atu-cota:checked in frame {&FRAME-NAME} 
                                                 then "1    " 
                                                 else "2    ".
     
    /***Emite remito e Remito Gera Previs∆o CR***/
    assign substr(natur-oper.char-2,41,5) = if l-emite-remito:checked in frame {&FRAME-NAME}
                                            then "1    " 
                                            else "2    "
           substr(natur-oper.char-2,61,5) = if l-gera-prevcr:checked in frame {&FRAME-NAME}
                                            then "1    " 
                                            else "2    ".   

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
    
    assign natur-oper.baixa-ship:sensitive in frame {&frame-name} = no.
    
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

  /***Imprime nota fiscal auto***/
  if avail natur-oper then do:
     if natur-oper.sc-transven = '1' then 
          assign tb-sc-transven:checked in frame {&frame-name} = yes.
     else assign tb-sc-transven:checked in frame {&frame-name} = no.
  end.

  /***Atualiza Cotas***/
  find first param-global no-lock no-error.
  if param-global.modulo-08 then do:
     if avail natur-oper then
        assign tg-atu-cota:checked in frame {&frame-name} =  if substr(natur-oper.char-2,31,5) = '1'
                                                                then yes
                                                                else no.
  end.

  /***Emite remito e Remito Gera Previs∆o CR***/
  if avail natur-oper then
     assign l-emite-remito:checked in frame {&frame-name} = if substr(natur-oper.char-2,41,5) = '1'
                                                               then yes
                                                               else no
            l-gera-prevcr:checked  in frame {&frame-name} = if substr(natur-oper.char-2,61,5) = '1'
                                                               then yes
                                                               else no.
                                                               
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
    
    run get-attribute('adm-new-record').    

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    run pi-habilita-desabilita-campos.

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
  
  find first param-global no-lock no-error.
  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-desabilita-campos V-table-Win 
PROCEDURE pi-habilita-desabilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
do with frame {&frame-name}:
    /* assign natur-oper.auto-est:sensitive = natur-oper.atual-estat:checked */
       assign tb-sc-transven:sensitive      = yes
           tg-atu-cota:sensitive         = avail param-global and param-global.modulo-08 = yes.
        /* natur-oper.auto-cr:sensitive  = natur-oper.emite-duplic:checked
           natur-oper.auto-ct:sensitive  = natur-oper.ind-contabilizacao:checked. */

    if natur-oper.baixa-estoq:checked = no then 
       assign natur-oper.baixa-ship:sensitive  = no.
 /*           natur-oper.auto-ce:sensitive     = no.
    else
       assign natur-oper.auto-ce:sensitive  = yes. */
       
    assign natur-oper.baixa-ship:sensitive  = natur-oper.baixa-estoq:checked  = yes 
                                          and natur-oper.calc-auto:checked    = no 
                                          and l-emite-remito:checked          = yes.
  if natur-oper.calc-auto:checked then
     assign l-emite-remito:sensitive        = no
            natur-oper.baixa-ship:sensitive = no
            l-gera-prevcr:sensitive         = no.
  else
     assign l-emite-remito:sensitive        = yes.


end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

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
  {src/adm/template/snd-list.i "natur-oper"}

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


