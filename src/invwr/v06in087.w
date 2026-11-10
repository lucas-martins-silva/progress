&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V06IN087 2.00.00.008}  /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v06in087 MUT}
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
def new global shared var gr-docum-est as rowid no-undo.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent    as rowid                     no-undo.
def var c-per-cotacao   as char                      no-undo.
def var de-vl-taxa-aux  like despesa-aces.vl-taxa    no-undo.
/*def var i-cod-tax-aux   like item-doc-est.cod-tax    no-undo.*/
def var da-data-emissao like despesa-aces.dt-emissao no-undo.
def var i-tax-tip-calculo as integer no-undo.
def var i-isr-tip-calculo as integer no-undo.
def var l-zoom              as logical  no-undo.

{cdp/cd4300.i3}  /*Vari†veis para o cd4300.i4 */
{rep/re3001d.i50} /*Vari†veis para o re1001b.i51*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES despesa-aces
&Scoped-define FIRST-EXTERNAL-TABLE despesa-aces


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR despesa-aces.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS despesa-aces.mo-codigo ~
despesa-aces.cotacao-dia despesa-aces.valor-me despesa-aces.cod-tax ~
despesa-aces.perc-vat despesa-aces.vl-taxa-me 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}mo-codigo ~{&FP2}mo-codigo ~{&FP3}~
 ~{&FP1}cotacao-dia ~{&FP2}cotacao-dia ~{&FP3}~
 ~{&FP1}valor-me ~{&FP2}valor-me ~{&FP3}~
 ~{&FP1}cod-tax ~{&FP2}cod-tax ~{&FP3}~
 ~{&FP1}perc-vat ~{&FP2}perc-vat ~{&FP3}~
 ~{&FP1}vl-taxa-me ~{&FP2}vl-taxa-me ~{&FP3}
&Scoped-define ENABLED-TABLES despesa-aces
&Scoped-define FIRST-ENABLED-TABLE despesa-aces
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-13 
&Scoped-Define DISPLAYED-FIELDS despesa-aces.mo-codigo ~
despesa-aces.cotacao-dia despesa-aces.valor-me despesa-aces.cod-tax ~
despesa-aces.perc-vat despesa-aces.vl-taxa-me despesa-aces.cod-tax-isr ~
despesa-aces.perc-isr 
&Scoped-Define DISPLAYED-OBJECTS c-moeda c-desc-tax c-desc-isr fi-vl-isr-me 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS despesa-aces.cod-tax-isr ~
despesa-aces.perc-isr 
&Scoped-define ADM-MODIFY-FIELDS despesa-aces.cod-tax-isr ~
despesa-aces.perc-isr 

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
DEFINE VARIABLE c-desc-isr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tax AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-isr-me AS DECIMAL FORMAT ">>>,>>>,>>9.99" INITIAL 0 
     LABEL "":R11 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.57 BY 7.92.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.57 BY 2.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     despesa-aces.mo-codigo AT ROW 1.42 COL 26.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     c-moeda AT ROW 1.42 COL 30.72 COLON-ALIGNED NO-LABEL
     despesa-aces.cotacao-dia AT ROW 2.42 COL 26.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     despesa-aces.valor-me AT ROW 4.67 COL 26.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     despesa-aces.cod-tax AT ROW 5.67 COL 26.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     c-desc-tax AT ROW 5.67 COL 32.86 COLON-ALIGNED NO-LABEL
     despesa-aces.perc-vat AT ROW 6.67 COL 26.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     despesa-aces.vl-taxa-me AT ROW 7.67 COL 26.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.72 BY .88
     despesa-aces.cod-tax-isr AT ROW 8.67 COL 26.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-isr AT ROW 8.67 COL 31.72 COLON-ALIGNED NO-LABEL
     despesa-aces.perc-isr AT ROW 9.67 COL 26.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-vl-isr-me AT ROW 10.67 COL 26.57 COLON-ALIGNED
     rt-mold AT ROW 1 COL 1
     RECT-13 AT ROW 3.83 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.despesa-aces
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
         HEIGHT             = 10.79
         WIDTH              = 86.72.
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

/* SETTINGS FOR FILL-IN c-desc-isr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-tax IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN despesa-aces.cod-tax-isr IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-vl-isr-me IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN despesa-aces.perc-isr IN FRAME f-main
   NO-ENABLE 2 3                                                        */
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

&Scoped-define SELF-NAME despesa-aces.cod-tax
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.cod-tax V-table-Win
ON ENTRY OF despesa-aces.cod-tax IN FRAME f-main /* C¢digo Imposto */
DO:
/*  assign i-cod-tax-aux = input frame {&frame-name} despesa-aces.cod-tax.*/

    if  not l-zoom then 
        assign despesa-aces.cod-tax:modified in frame {&FRAME-NAME} = no.

    assign l-zoom = no.
    


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.cod-tax V-table-Win
ON F5 OF despesa-aces.cod-tax IN FRAME f-main /* C¢digo Imposto */
DO:
  {include/zoomvar.i &prog-zoom="dizoom/z01di217.w"
                       &campo=despesa-aces.cod-tax
                       &campozoom=cod-tax}

    assign l-zoom = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.cod-tax V-table-Win
ON LEAVE OF despesa-aces.cod-tax IN FRAME f-main /* C¢digo Imposto */
DO:
  {include/leave.i &tabela=tipo-tax
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-tax
                     &where="tipo-tax.cod-tax = input frame {&frame-name} despesa-aces.cod-tax"}
  
    find tipo-tax where 
        tipo-tax.cod-tax = input frame {&frame-name} despesa-aces.cod-tax 
        no-lock no-error.
  
    find pais where 
        pais.nome-pais = estabelec.pais 
        no-lock no-error. 

    if available tipo-tax and
       (input frame {&frame-name} despesa-aces.cod-tax = 0 or
        despesa-aces.cod-tax:modified in  frame {&frame-name}) then do: 

        assign despesa-aces.perc-vat:sensitive in frame {&frame-name} = yes
               despesa-aces.vl-taxa-me:sensitive in frame {&frame-name} = yes.
        assign despesa-aces.perc-vat:screen-value in frame  {&frame-name} = string(tipo-tax.tax-perc).
        enable  despesa-aces.perc-vat 
                despesa-aces.vl-taxa-me
                with frame {&frame-name}.
        run pi-gera-imposto.
        apply 'entry' to despesa-aces.perc-vat in frame {&frame-name}.
        return no-apply.
    end.
    else if not available tipo-tax then
            assign despesa-aces.perc-vat:screen-value in frame {&frame-name} = "0"
                   despesa-aces.vl-taxa-me:screen-value in frame {&frame-name} = "0"
                   despesa-aces.perc-vat:sensitive in frame {&frame-name} = no
                   despesa-aces.vl-taxa-me:sensitive in frame {&frame-name} = no.
        

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.cod-tax V-table-Win
ON MOUSE-SELECT-DBLCLICK OF despesa-aces.cod-tax IN FRAME f-main /* C¢digo Imposto */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.cod-tax-isr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.cod-tax-isr V-table-Win
ON ENTRY OF despesa-aces.cod-tax-isr IN FRAME f-main /* Cod Taxa Serv */
DO:
/*  assign i-cod-tax-aux = input frame {&frame-name} despesa-aces.cod-tax-isr.*/
    if  not l-zoom then 
        assign despesa-aces.cod-tax-isr:modified in frame {&FRAME-NAME} = no.

    assign l-zoom = no.
    


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.cod-tax-isr V-table-Win
ON F5 OF despesa-aces.cod-tax-isr IN FRAME f-main /* Cod Taxa Serv */
DO:
  {include/zoomvar.i &prog-zoom="dizoom/z01di217.w"
                     &campo=despesa-aces.cod-tax-isr
                     &campozoom=cod-tax-isr}
  assign l-zoom = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.cod-tax-isr V-table-Win
ON LEAVE OF despesa-aces.cod-tax-isr IN FRAME f-main /* Cod Taxa Serv */
DO:
  {include/leave.i &tabela=tipo-tax
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-isr
                   &where="tipo-tax.cod-tax = input frame {&frame-name} despesa-aces.cod-tax-isr"}
  if available tipo-tax and
       (input frame {&frame-name} despesa-aces.cod-tax-isr = 0 or
        despesa-aces.cod-tax-isr:modified in  frame {&frame-name}) then do: 
  
      assign despesa-aces.perc-isr:screen-value in frame  {&frame-name} = string(tipo-tax.tax-perc).
      enable  despesa-aces.perc-isr 
              fi-vl-isr-me
              with frame {&frame-name}.
      run pi-calcula-isr.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.cod-tax-isr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF despesa-aces.cod-tax-isr IN FRAME f-main /* Cod Taxa Serv */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.mo-codigo V-table-Win
ON F5 OF despesa-aces.mo-codigo IN FRAME f-main /* Moeda */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad178.w"
                     &campo=despesa-aces.mo-codigo
                     &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.mo-codigo V-table-Win
ON LEAVE OF despesa-aces.mo-codigo IN FRAME f-main /* Moeda */
DO:
  {include/leave.i &tabela=moeda
                     &atributo-ref=descricao
                     &variavel-ref=c-moeda
                     &where="moeda.mo-codigo = input frame {&frame-name} despesa-aces.mo-codigo"}

  if da-data-emissao <> ? then do:
      find cotacao where
               cotacao.mo-codigo  = input frame {&frame-name} despesa-aces.mo-codigo and
               cotacao.ano-periodo = c-per-cotacao no-lock no-error.
      assign despesa-aces.cotacao-dia:screen-value in frame {&frame-name} = 
                                                if avail cotacao then
                                                     string(cotacao.cotacao[day(da-data-emissao)])
                                                else "1".
          if avail cotacao then 
              enable  despesa-aces.cotacao-dia with frame {&frame-name}.
          else 
              disable despesa-aces.cotacao-dia with frame {&frame-name}.
  end. 
  
  if input frame {&frame-name} despesa-aces.mo-codigo = 0 then
       assign despesa-aces.cotacao-dia:screen-value in frame {&frame-name} = "1"
              despesa-aces.cotacao-dia:sensitive in frame {&frame-name} = no.
  else assign despesa-aces.cotacao-dia:sensitive in frame {&frame-name} = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.mo-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF despesa-aces.mo-codigo IN FRAME f-main /* Moeda */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.perc-isr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.perc-isr V-table-Win
ON ENTRY OF despesa-aces.perc-isr IN FRAME f-main /* Taxa Serviáo */
DO:
        assign despesa-aces.valor-me:modified in frame {&FRAME-NAME} = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.perc-isr V-table-Win
ON LEAVE OF despesa-aces.perc-isr IN FRAME f-main /* Taxa Serviáo */
DO:
        if (input frame {&frame-name} despesa-aces.perc-isr = 0 or
          despesa-aces.perc-isr:modified in  frame {&frame-name}) then 
              run pi-calcula-isr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.perc-vat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.perc-vat V-table-Win
ON ENTRY OF despesa-aces.perc-vat IN FRAME f-main /* Perc Taxa */
DO:
          assign despesa-aces.perc-vat:modified in frame {&FRAME-NAME} = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.perc-vat V-table-Win
ON LEAVE OF despesa-aces.perc-vat IN FRAME f-main /* Perc Taxa */
DO:
        if (input frame {&frame-name} despesa-aces.perc-vat = 0 or
          despesa-aces.perc-vat:modified in  frame {&frame-name}) then 
            run pi-gera-imposto.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME despesa-aces.valor-me
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.valor-me V-table-Win
ON ENTRY OF despesa-aces.valor-me IN FRAME f-main /* Vlr Moeda Extrangeira */
DO:
        assign despesa-aces.valor-me:modified in frame {&FRAME-NAME} = no.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL despesa-aces.valor-me V-table-Win
ON LEAVE OF despesa-aces.valor-me IN FRAME f-main /* Vlr Moeda Extrangeira */
DO:
      if (input frame {&frame-name} despesa-aces.valor-me = 0 or
          despesa-aces.valor-me:modified in  frame {&frame-name}) then 
        run pi-gera-imposto.

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

  if despesa-aces.cod-tax:load-mouse-pointer     ("image/lupa.cur") in frame {&frame-name} then.
  if despesa-aces.cod-tax-isr:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if despesa-aces.mo-codigo:load-mouse-pointer   ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "despesa-aces"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "despesa-aces"}

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
  
  {utp/ut-liter.i Percentual_Imposto * L}
  assign despesa-aces.perc-vat:label in frame {&frame-name} = return-value.
   
  assign despesa-aces.vl-taxa-me:screen-value in frame {&frame-name} = "0"
         despesa-aces.vl-taxa-me:sensitive in frame {&frame-name} = no
         despesa-aces.perc-vat:sensitive in frame {&frame-name} = no.

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
    
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

      /*I-tax-tip-calculo/i-isr-tip-calculo indica se o imposto j† est† inclu°do no preáo 
        total do item. Se for igual a 2, o imposto j† est† inclu°do e desta forma ser† retirado
        na geraá∆o do movto estoque. Se for igual a 1, o imposto n∆o est† inclu°do e ser† somado
        na geraá∆o dos documentos no AP. */
      assign de-vl-isr-desp-me       = input frame {&FRAME-NAME} fi-vl-isr-me
             de-tot-taxa-desp        = if i-tax-tip-calculo = 1 then despesa-aces.vl-taxa    else 0
                                     + if i-isr-tip-calculo = 1 then fi-vl-isr-me      else 0
             de-tot-taxa-desp-me     = if i-tax-tip-calculo = 1 then despesa-aces.vl-taxa-me else 0
                                     + if i-isr-tip-calculo = 1 then de-vl-isr-desp-me else 0
             de-taxa-inc-desp        = if i-tax-tip-calculo = 2 then despesa-aces.vl-taxa    else 0
                                     + if i-isr-tip-calculo = 2 then fi-vl-isr-me      else 0
             de-taxa-inc-desp-me     = if i-tax-tip-calculo = 2 then despesa-aces.vl-taxa-me else 0
                                     + if i-isr-tip-calculo = 2 then de-vl-isr-desp-me else 0.

  {rep/re3001d.i51 "no"}
  {cdp/cd4300.i4  "no" despesa-aces.char-1}


    if despesa-aces.mo-codigo <> 0 then 
        assign despesa-aces.valor      = despesa-aces.valor-me * 
                                         despesa-aces.cotacao-dia
               despesa-aces.vl-taxa    = despesa-aces.vl-taxa-me *
                                         despesa-aces.cotacao-dia
               fi-vl-isr-me     = de-vl-isr-desp-me * 
                                         despesa-aces.cotacao-dia.
    else 
        assign despesa-aces.valor   = despesa-aces.valor-me
               despesa-aces.vl-taxa = despesa-aces.vl-taxa-me
               fi-vl-isr-me         = de-vl-isr-desp-me.                                         
    
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

  if avail despesa-aces then do:
    /*retira o valor do isr-me da vari†vel char-1 e joga na vari†ve de-vl-isr-me*/
    {cdp/cd4300.i4  "yes" despesa-aces.char-1}             
    {rep/re3001d.i51 "yes"}
    assign fi-vl-isr-me:screen-value in frame {&FRAME-NAME} = string(de-vl-isr-desp-me).
    find tipo-tax where
         tipo-tax.cod-tax = despesa-aces.cod-tax no-lock no-error.
    if avail tipo-tax then 
        assign c-desc-tax:screen-value in frame {&frame-name} = tipo-tax.descricao.
    if avail emitente and emitente.identific = 1 then do:
        find tipo-tax where
             tipo-tax.cod-tax = despesa-aces.cod-tax-isr no-lock no-error.
        if avail tipo-tax then 
            assign c-desc-isr:screen-value in frame {&frame-name} = tipo-tax.descricao.
    end.        
  end.

  {utp/ut-field.i mgind despesa-aces vl-isr 1}
  assign fi-vl-isr-me:label in frame {&FRAME-NAME} = return-value.


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
    find docum-est where
         rowid(docum-est) = gr-docum-est no-lock no-error.
    find estabelec where 
         estabelec.cod-estabel = docum-est.cod-estabel
         no-lock no-error.
    find pais where
         pais.nome-pais = estabelec.pais no-lock no-error.
    if adm-new-record = no and avail despesa-aces then do:
        if despesa-aces.mo-codigo = 0 then
            assign despesa-aces.cotacao-dia:sensitive in frame {&frame-name} = no.
        else assign despesa-aces.cotacao-dia:sensitive in frame {&frame-name} = yes.
 
        find emitente where
             emitente.cod-emitente = despesa-aces.cod-emitente
             no-lock no-error.
        find tipo-tax where
             tipo-tax.cod-tax = despesa-aces.cod-tax no-lock no-error.
        if avail tipo-tax then do:
            assign c-desc-tax:screen-value in frame {&frame-name} = tipo-tax.descricao.
            enable despesa-aces.perc-vat
                   despesa-aces.vl-taxa-me
                   with frame {&frame-name}.
        end.
        else 
            disable despesa-aces.perc-vat 
                    despesa-aces.vl-taxa-me
                    with frame {&frame-name}.
        
        /* ISR */
        if emitente.natureza = 1 then do:
            enable despesa-aces.cod-tax-isr
                   with frame {&frame-name}. 
            find tipo-tax where
                 tipo-tax.cod-tax = input frame {&frame-name} despesa-aces.cod-tax-isr
                 no-lock no-error.
            if avail tipo-tax then
                disp tipo-tax.descricao @ c-desc-isr with frame {&frame-name}.
            if avail tipo-tax  then 
                enable despesa-aces.cod-tax-isr
                       despesa-aces.perc-isr
                       fi-vl-isr-me
                       with frame {&frame-name}.
            else  
                disable despesa-aces.perc-isr
                        fi-vl-isr-me
                        with frame {&frame-name}.
        end.
        else  
            disable despesa-aces.cod-tax-isr
                    despesa-aces.perc-isr
                    fi-vl-isr-me
                    with frame {&frame-name}.
 
    end. 
 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-isr V-table-Win 
PROCEDURE pi-calcula-isr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  if avail tipo-tax and tipo-tax.ind-tip-calculo = 2 then    /*** Imposto -> Base 100 % + IVA ***/
       assign fi-vl-isr-me:screen-value in frame {&frame-name} = 
                            string(((input frame {&frame-name} despesa-aces.valor-me - input frame {&frame-name} despesa-aces.vl-taxa-me) /
                            (input frame {&frame-name} despesa-aces.perc-isr + 100) * 100)).
  else assign fi-vl-isr-me:screen-value in frame {&frame-name} = 
                            string((input frame {&frame-name} despesa-aces.valor-me - input frame {&frame-name} despesa-aces.vl-taxa-me) *
                           (input frame {&frame-name} despesa-aces.perc-isr / 100)).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-imposto V-table-Win 
PROCEDURE pi-gera-imposto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  if avail tipo-tax and tipo-tax.ind-tip-calculo = 2 then 
       assign despesa-aces.vl-taxa-me:screen-value in frame {&frame-name} = 
                                    string(input frame {&frame-name} despesa-aces.valor-me - (input frame {&frame-name} despesa-aces.valor-me / 
                                    (input frame {&frame-name} despesa-aces.perc-vat + 100)) * 100).
  else assign despesa-aces.vl-taxa-me:screen-value in frame {&frame-name} = 
                                    string(input frame {&frame-name} despesa-aces.valor-me * 
                                       (input frame {&frame-name} despesa-aces.perc-vat / 100)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campos V-table-Win 
PROCEDURE pi-inicializa-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input param da-dt-emissao like despesa-aces.dt-emissao no-undo.
  assign da-data-emissao = da-dt-emissao.

  if da-dt-emissao <> ? then do:
      assign c-per-cotacao = string(year(da-dt-emissao),'9999')
                           + string(month(da-dt-emissao),'99').
  
      find cotacao where
           cotacao.mo-codigo  = input frame {&frame-name} despesa-aces.mo-codigo and
           cotacao.ano-periodo = c-per-cotacao no-lock no-error.
      assign despesa-aces.cotacao-dia:screen-value in frame {&frame-name} = 
                                   if avail cotacao then
                                        string(cotacao.cotacao[day(da-dt-emissao)])
                                   else "1".
      if avail cotacao then 
          enable  despesa-aces.cotacao-dia with frame {&frame-name}.
      else 
          disable despesa-aces.cotacao-dia with frame {&frame-name}.
  end.
  else do:
      RUN Get-Field-Screen-Value IN adm-broker-hdl
         (INPUT this-procedure,
          INPUT "cod-forn-ac").
      
      find emitente where
           emitente.cod-emitente = int(return-value) no-lock no-error.
      if avail emitente then do:
          assign despesa-aces.cod-tax:screen-value in frame {&frame-name} = 
                                      string(emitente.cod-tax).
          
          find tipo-tax where 
               tipo-tax.cod-tax = emitente.cod-tax 
               no-lock no-error.      
          if avail tipo-tax then do:
              assign c-desc-tax:screen-value in frame {&frame-name} = tipo-tax.descricao
                     despesa-aces.perc-vat:screen-value in frame  {&frame-name} = string(tipo-tax.tax-perc).
              run pi-gera-imposto.
              enable  despesa-aces.perc-vat 
                      despesa-aces.vl-taxa-me
                      with frame {&frame-name}.
          end.
          if emitente.natureza = 1 then 
              enable despesa-aces.cod-tax-isr
                     despesa-aces.perc-isr
                     fi-vl-isr-me
                     with frame {&frame-name}.
          else  
              disable despesa-aces.cod-tax-isr
                      despesa-aces.perc-isr
                      fi-vl-isr-me
                      with frame {&frame-name}.
          
      end.
      else  
          disable despesa-aces.cod-tax-isr
                  despesa-aces.perc-isr
                  fi-vl-isr-me
                  with frame {&frame-name}.
  end.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-data V-table-Win 
PROCEDURE pi-inicializa-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input param da-dt-emissao like despesa-aces.dt-emissao no-undo.
  assign c-per-cotacao = string(year(da-dt-emissao),'9999')
                       + string(month(da-dt-emissao),'99').
  
  find cotacao where
       cotacao.mo-codigo  = input frame {&frame-name} despesa-aces.mo-codigo and
       cotacao.ano-periodo = c-per-cotacao no-lock no-error.
  if avail cotacao then 
      enable  despesa-aces.cotacao-dia with frame {&frame-name}.
  else 
      disable despesa-aces.cotacao-dia with frame {&frame-name}.

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
  assign i-tax-tip-calculo = 1
         i-isr-tip-calculo = 1.
    
/*/*    Segue um exemplo de validaá∆o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

  find first cotacao where
       cotacao.mo-codigo   = input frame {&frame-name} despesa-aces.mo-codigo and
       cotacao.ano-periodo = c-per-cotacao
       no-lock no-error.
  if (not avail cotacao or 
     input frame {&frame-name} despesa-aces.cotacao-dia = 0) and 
     input frame {&frame-name} despesa-aces.mo-codigo <> 0 then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 1920, input return-value).
      apply "entry" to despesa-aces.mo-codigo in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.

    find tipo-tax where 
         tipo-tax.cod-tax = input frame {&frame-name} despesa-aces.cod-tax
         no-lock no-error.
    if  not avail tipo-tax  
    and input frame {&frame-name} despesa-aces.cod-tax <> 0 then do:
        {include/i-vldprg.i}                   
        {utp/ut-table.i mgdis tipo-tax 1}
        run utp/ut-msgs.p (input "show", input 2, input return-value).
        apply 'entry' to despesa-aces.cod-tax in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    else do:
        if avail tipo-tax then do:
            if  input frame {&frame-name} despesa-aces.perc-vat = 0 then do:
                {include/i-vldprg.i}                   
                run utp/ut-msgs.p (input "show",
                                   input 2336,
                                   input "").
                apply 'entry' to despesa-aces.perc-vat in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
            if  input frame {&frame-name} despesa-aces.perc-vat > 100 then do:
                {include/i-vldprg.i}                   
                run utp/ut-msgs.p (input "show",
                                   input 374,
                                   input " ").
                apply 'entry' to despesa-aces.perc-vat in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
        end.
    end.

  assign i-tax-tip-calculo = if input frame {&frame-name} despesa-aces.cod-tax <> 0 then tipo-tax.ind-tip-calculo
                                else 1.
  
  if emitente.natureza = 1 then do:
        find tipo-tax where 
             tipo-tax.cod-tax = input frame {&frame-name} despesa-aces.cod-tax-isr
             no-lock no-error.
        if not avail tipo-tax 
        and input frame {&frame-name} despesa-aces.cod-tax-isr  <> 0 then do:
            {include/i-vldprg.i}                   
            {utp/ut-table.i mgdis tipo-tax 1}
            run utp/ut-msgs.p (input "show", input 2, input return-value).
            apply 'entry' to despesa-aces.cod-tax-isr in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        else do:
            if avail tipo-tax then do:
                if  input frame {&frame-name} despesa-aces.perc-isr = 0 then do:
                    {include/i-vldprg.i}                   
                    run utp/ut-msgs.p (input "show",
                                       input 2336,
                                       input "").
                    apply 'entry' to despesa-aces.perc-isr in frame {&frame-name}.
                    return 'ADM-ERROR':U.
                end.
                if  input frame {&frame-name} despesa-aces.perc-isr > 100 then do:
                    {include/i-vldprg.i}                   
                    run utp/ut-msgs.p (input "show",
                                       input 374,
                                       input " ").
                    apply 'entry' to despesa-aces.perc-isr in frame {&frame-name}.
                    return 'ADM-ERROR':U.
                end.
            end.        
        end.            
      assign i-isr-tip-calculo = if input frame {&frame-name} despesa-aces.cod-tax-isr <> 0 then tipo-tax.ind-tip-calculo
                                    else 1.
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
  {src/adm/template/snd-list.i "despesa-aces"}

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


