
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V01AD337 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01ad337 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */
&SCOPED-DEFINE adm-attribute-dlg support/viewerd.w

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-conteudo   AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-area       AS INTEGER   NO-UNDO.
DEFINE VARIABLE v-row-parent AS ROWID     NO-UNDO.

/* Include Definitions ---                                              */
{include/i_dbvers.i}
{include/i_fnctrad.i}

def var c-msg as char.
&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
   Def Var c-lista As Char No-undo.
&endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES obj-cenario
&Scoped-define FIRST-EXTERNAL-TABLE obj-cenario


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR obj-cenario.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS obj-cenario.dt-objetivo-ini ~
obj-cenario.dt-objetivo obj-cenario.vl-objetivo obj-cenario.mo-codigo 
&Scoped-define ENABLED-TABLES obj-cenario
&Scoped-define FIRST-ENABLED-TABLE obj-cenario
&Scoped-define DISPLAYED-TABLES obj-cenario
&Scoped-define FIRST-DISPLAYED-TABLE obj-cenario
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS obj-cenario.ep-codigo ~
obj-cenario.cod-cenario obj-cenario.seq-objetivo ~
obj-cenario.dt-objetivo-ini obj-cenario.dt-objetivo obj-cenario.vl-objetivo ~
obj-cenario.mo-codigo 
&Scoped-Define DISPLAYED-OBJECTS fi-razao-social fi-nome-cenario fi-area ~
cb-conteudo cb-operador fi-valor-realizado fi-descricao-moeda ~
tg-obj-processado 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS obj-cenario.ep-codigo ~
obj-cenario.cod-cenario obj-cenario.seq-objetivo ~
obj-cenario.dt-objetivo-ini 
&Scoped-define ADM-ASSIGN-FIELDS fi-area 

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
DEFINE VARIABLE cb-conteudo AS CHARACTER FORMAT "X(50)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 33 BY 1 NO-UNDO.

DEFINE VARIABLE cb-operador AS CHARACTER FORMAT "X(15)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE fi-area AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao-moeda AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-cenario AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-razao-social AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor-realizado AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.999999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 3.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 8.5.

DEFINE VARIABLE tg-obj-processado AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     obj-cenario.ep-codigo AT ROW 1.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-razao-social AT ROW 1.25 COL 35 COLON-ALIGNED HELP
          "Razao Social da Empresa" NO-LABEL
     obj-cenario.cod-cenario AT ROW 2.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-nome-cenario AT ROW 2.25 COL 35 COLON-ALIGNED NO-LABEL
     obj-cenario.seq-objetivo AT ROW 3.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-area AT ROW 4.75 COL 28 COLON-ALIGNED
     cb-conteudo AT ROW 5.75 COL 28 COLON-ALIGNED
     cb-operador AT ROW 6.75 COL 28 COLON-ALIGNED
     obj-cenario.dt-objetivo-ini AT ROW 7.79 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     obj-cenario.dt-objetivo AT ROW 8.75 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     obj-cenario.vl-objetivo AT ROW 9.75 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     fi-valor-realizado AT ROW 9.75 COL 63 COLON-ALIGNED
     obj-cenario.mo-codigo AT ROW 10.75 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     fi-descricao-moeda AT ROW 10.75 COL 34 COLON-ALIGNED NO-LABEL
     tg-obj-processado AT ROW 11.83 COL 30
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.obj-cenario
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
         HEIGHT             = 12
         WIDTH              = 86.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-conteudo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-operador IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN obj-cenario.cod-cenario IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN obj-cenario.dt-objetivo-ini IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN obj-cenario.ep-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-area IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-descricao-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nome-cenario IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-razao-social IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-valor-realizado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN obj-cenario.seq-objetivo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR TOGGLE-BOX tg-obj-processado IN FRAME f-main
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

&Scoped-define SELF-NAME cb-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-conteudo V-table-Win
ON VALUE-CHANGED OF cb-conteudo IN FRAME f-main
DO:
    IF (   i-area = 4 
        OR i-area = 5) 
    AND
       (   cb-conteudo:LOOKUP(cb-conteudo:SCREEN-VALUE) = 4 
        OR cb-conteudo:LOOKUP(cb-conteudo:SCREEN-VALUE) = 5 
        OR cb-conteudo:LOOKUP(cb-conteudo:SCREEN-VALUE) = 6) 
    THEN
        ASSIGN obj-cenario.mo-codigo:SENSITIVE = NO.
    ELSE
        ASSIGN obj-cenario.mo-codigo:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME obj-cenario.cod-cenario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL obj-cenario.cod-cenario V-table-Win
ON F5 OF obj-cenario.cod-cenario IN FRAME f-main /* C¢digo Cen rio */
OR MOUSE-SELECT-DBLCLICK OF obj-cenario.cod-cenario DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad340.w"
                       &campo="obj-cenario.cod-cenario"
                       &campozoom="cod-cenario"
                       &campo2="fi-nome-cenario"
                       &campozoom2="nome"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL obj-cenario.cod-cenario V-table-Win
ON LEAVE OF obj-cenario.cod-cenario IN FRAME f-main /* C¢digo Cen rio */
DO:
    {include/leave.i &tabela="cenario-ge"
                     &where="cenario-ge.cod-cenario = INTEGER(obj-cenario.cod-cenario:SCREEN-VALUE)"
                     &variavel-ref="fi-nome-cenario"
                     &atributo-ref="nome"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME obj-cenario.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL obj-cenario.mo-codigo V-table-Win
ON F5 OF obj-cenario.mo-codigo IN FRAME f-main /* C¢digo Moeda */
OR MOUSE-SELECT-DBLCLICK OF obj-cenario.mo-codigo DO:
    {include/zoomvar.i &prog-zoom="unzoom/z01un005.w"
                       &campo="obj-cenario.mo-codigo"
                       &campozoom="mo-codigo"
                       &campo2="fi-descricao-moeda"
                       &campozoom2="descricao"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL obj-cenario.mo-codigo V-table-Win
ON LEAVE OF obj-cenario.mo-codigo IN FRAME f-main /* C¢digo Moeda */
DO:
    {include/leave.i &tabela="moeda"
                     &where="moeda.mo-codigo = INTEGER(obj-cenario.mo-codigo:SCREEN-VALUE)"
                     &variavel-ref="fi-descricao-moeda"
                     &atributo-ref="descricao"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-liter.i µrea}
ASSIGN fi-area:LABEL IN FRAME {&FRAME-NAME}      = TRIM(RETURN-VALUE).

{utp/ut-liter.i Conte£do}
ASSIGN cb-conteudo:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE)
       c-conteudo                               = {adinc/i02ad337.i 03}.

&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
     Run utp/ut-lstit.p (input-output c-conteudo).
&ENDIF


{utp/ut-liter.i Operador}
ASSIGN cb-operador:LABEL IN FRAME {&FRAME-NAME}      = TRIM(RETURN-VALUE).
&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
    Assign c-lista = {adinc/i03ad337.i 03}.
    Run utp/ut-lstit.p (input-output c-lista).
    assign cb-operador:List-item-pairs IN FRAME {&FRAME-NAME} = c-lista.
&else
    assign cb-operador:LIST-ITEMS IN FRAME {&frame-name} = {adinc/i03ad337.i 03}.
&endif

{utp/ut-liter.i Valor_Realizado}
ASSIGN fi-valor-realizado:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Objetivo_J _Processado}
ASSIGN tg-obj-processado:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

/*obj-cenario.cod-cenario :LOAD-MOUSE-POINTER("image/lupa":U) IN FRAME {&FRAME-NAME}.
 * obj-cenario.ep-codigo   :LOAD-MOUSE-POINTER("image/lupa":U) IN FRAME {&FRAME-NAME}.*/
obj-cenario.mo-codigo   :LOAD-MOUSE-POINTER("image/lupa":U) IN FRAME {&FRAME-NAME}.

assign obj-cenario.ep-codigo:read-only = yes
       obj-cenario.seq-objetivo:read-only = yes
       obj-cenario.cod-cenario:read-only = yes.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

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
  {src/adm/template/row-list.i "obj-cenario"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "obj-cenario"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI V-table-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY fi-razao-social fi-nome-cenario fi-area cb-conteudo cb-operador 
          fi-valor-realizado fi-descricao-moeda tg-obj-processado 
      WITH FRAME f-main.
  IF AVAILABLE obj-cenario THEN 
    DISPLAY obj-cenario.ep-codigo obj-cenario.cod-cenario obj-cenario.seq-objetivo 
          obj-cenario.dt-objetivo-ini obj-cenario.dt-objetivo 
          obj-cenario.vl-objetivo obj-cenario.mo-codigo 
      WITH FRAME f-main.
  ENABLE obj-cenario.dt-objetivo-ini obj-cenario.dt-objetivo 
         obj-cenario.vl-objetivo obj-cenario.mo-codigo rt-key rt-mold 
      WITH FRAME f-main.
  {&OPEN-BROWSERS-IN-QUERY-f-main}
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
    IF  AVAILABLE cenario-ge THEN
        ASSIGN  obj-cenario.ep-codigo   :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(cenario-ge.ep-codigo)
                obj-cenario.cod-cenario :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(cenario-ge.cod-cenario)
                fi-nome-cenario         :SCREEN-VALUE IN FRAME {&FRAME-NAME} = cenario-ge.nome
                obj-cenario.dt-objetivo-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(cenario-ge.dt-inicial).
    ELSE
        ASSIGN  obj-cenario.ep-codigo   :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0":U
                obj-cenario.cod-cenario :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0":U
                fi-nome-cenario         :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U
                obj-cenario.dt-objetivo-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY).
/*
    {include/leave.i &tabela="empresa"
                     &where="empresa.ep-codigo = INTEGER(obj-cenario.ep-codigo:SCREEN-VALUE in frame {&FRAME-NAME})"
                     &variavel-ref="fi-razao-social"
                     &atributo-ref="razao-social"}
*/
    ASSIGN  obj-cenario.seq-objetivo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(NEXT-VALUE(seq-cod-cenario-obj))
            fi-area                 :SCREEN-VALUE IN FRAME {&FRAME-NAME} = fi-area
            cb-conteudo             :SCREEN-VALUE IN FRAME {&FRAME-NAME} = &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then ENTRY(2, cb-conteudo:List-item-pairs IN FRAME {&FRAME-NAME}) &else ENTRY(1, cb-conteudo:LIST-ITEMS IN FRAME {&FRAME-NAME}) &endif
            obj-cenario.dt-objetivo :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY).

    APPLY "VALUE-CHANGED":U TO cb-conteudo IN FRAME {&FRAME-NAME}.

    ASSIGN  cb-operador      :SCREEN-VALUE  IN FRAME {&FRAME-NAME} = &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then ENTRY(2, cb-operador:List-item-pairs IN FRAME {&FRAME-NAME}) &else ENTRY(1, cb-operador:LIST-ITEMS IN FRAME {&FRAME-NAME}) &endif
            tg-obj-processado:CHECKED       IN FRAME {&FRAME-NAME} = no.
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    {include/i-valid.i}

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

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

    /* Code placed here will execute AFTER standard behavior.    */
    CASE i-area:
        WHEN 1 THEN ASSIGN obj-cenario.cod-conteudo = 
                        cb-conteudo:LOOKUP(cb-conteudo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) IN FRAME {&FRAME-NAME}.
        
        WHEN 2 THEN ASSIGN obj-cenario.cod-conteudo = 2 +
                        cb-conteudo:LOOKUP(cb-conteudo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) IN FRAME {&FRAME-NAME}.
        
        WHEN 3 THEN ASSIGN obj-cenario.cod-conteudo = 4 +
                        cb-conteudo:LOOKUP(cb-conteudo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) IN FRAME {&FRAME-NAME}.
        
        WHEN 4 THEN ASSIGN obj-cenario.cod-conteudo = 7 +
                        cb-conteudo:LOOKUP(cb-conteudo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) IN FRAME {&FRAME-NAME}.
        
        WHEN 5 THEN ASSIGN obj-cenario.cod-conteudo = 13 +
                        cb-conteudo:LOOKUP(cb-conteudo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) IN FRAME {&FRAME-NAME}.
        
        WHEN 6 THEN ASSIGN obj-cenario.cod-conteudo = 19 +
                        cb-conteudo:LOOKUP(cb-conteudo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) IN FRAME {&FRAME-NAME}.
    END CASE.
    
    ASSIGN  obj-cenario.ep-codigo =     cenario-ge.ep-codigo
            obj-cenario.COD-ESTABEL   = " "
            obj-cenario.area            = i-area
            obj-cenario.cod-operador    = cb-operador:LOOKUP(cb-operador:SCREEN-VALUE IN FRAME {&FRAME-NAME}) IN FRAME {&FRAME-NAME}
           
        &IF "{&mgadm_version}":U = "2.03":U &THEN
           obj-cenario.log-1           = tg-obj-processado:CHECKED IN FRAME {&FRAME-NAME}.
        &ELSE
           obj-cenario.log-atualizado  = tg-obj-processado:CHECKED IN FRAME {&FRAME-NAME}.
        &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    IF AVAILABLE cenario-ge THEN
        ASSIGN  obj-cenario.ep-codigo   :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(cenario-ge.ep-codigo)
                obj-cenario.cod-cenario :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(cenario-ge.cod-cenario)
                fi-nome-cenario         :SCREEN-VALUE IN FRAME {&FRAME-NAME} = cenario-ge.nome.
                
    ELSE
        ASSIGN  obj-cenario.cod-cenario :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0":U
                obj-cenario.ep-codigo   :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0":U
                fi-nome-cenario         :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U.

        &IF "{&mguni_version}" >= "2.07A" &THEN
        {include/leave.i &tabela="empresa"
                         &where="empresa.ep-codigo = obj-cenario.ep-codigo:SCREEN-VALUE in frame {&FRAME-NAME}"
                         &variavel-ref="fi-razao-social"
                         &atributo-ref="razao-social"}
        &ELSE
        {include/leave.i &tabela="empresa"
                         &where="empresa.ep-codigo = INTEGER(obj-cenario.ep-codigo:SCREEN-VALUE in frame {&FRAME-NAME})"
                         &variavel-ref="fi-razao-social"
                         &atributo-ref="razao-social"}
        &ENDIF
        

    ASSIGN obj-cenario.seq-objetivo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(NEXT-VALUE(seq-cod-cenario-obj)).

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
    ASSIGN cb-conteudo:SENSITIVE IN FRAME {&FRAME-NAME}        = NO
           cb-operador:SENSITIVE IN FRAME {&FRAME-NAME}        = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-item AS INTEGER NO-UNDO.
    &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
         Def Var hHandle As Handle No-undo.
    &endif
    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    IF AVAILABLE obj-cenario THEN DO:
        
        CASE i-area:
            WHEN 1 THEN ASSIGN i-item = obj-cenario.cod-conteudo.
            
            WHEN 2 THEN ASSIGN i-item = obj-cenario.cod-conteudo - 2.
            
            WHEN 3 THEN ASSIGN i-item = obj-cenario.cod-conteudo - 4.
            
            WHEN 4 THEN ASSIGN i-item = obj-cenario.cod-conteudo - 7.
            
            WHEN 5 THEN ASSIGN i-item = obj-cenario.cod-conteudo - 14.
            
            WHEN 6 THEN ASSIGN i-item = obj-cenario.cod-conteudo - 19.
        END CASE.

        IF (i-item <= 0) OR (i-item > cb-conteudo:NUM-ITEMS IN FRAME {&FRAME-NAME}) THEN
            ASSIGN i-item = 1.
        
        &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
            Assign hHandle = cb-conteudo:Handle.
            If Can-query(hHandle,"list-item-pairs") Then 
                ASSIGN cb-conteudo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                        ENTRY(i-item * 2, cb-conteudo:List-item-pairs IN FRAME {&FRAME-NAME}).
            Else
                ASSIGN cb-conteudo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                    ENTRY(i-item, cb-conteudo:LIST-ITEMS IN FRAME {&FRAME-NAME}).  
        &else
            ASSIGN cb-conteudo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                ENTRY(i-item, cb-conteudo:LIST-ITEMS IN FRAME {&FRAME-NAME}).
        &ENDIF
        
        
        ASSIGN cb-operador:SCREEN-VALUE IN FRAME {&FRAME-NAME}        = &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN ENTRY(obj-cenario.cod-operador * 2, cb-operador:List-item-pairs IN FRAME {&FRAME-NAME}) &else ENTRY(obj-cenario.cod-operador, cb-operador:LIST-ITEMS IN FRAME {&FRAME-NAME}) &endif
               fi-valor-realizado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = &IF "{&mgadm_version}":U = "2.03":U &THEN 
                                                                            STRING(obj-cenario.dec-1)
                                                                        &ELSE
                                                                            STRING(obj-cenario.vl-realizado)
                                                                        &ENDIF
               tg-obj-processado:CHECKED IN FRAME {&FRAME-NAME}       = &IF "{&mgadm_version}":U = "2.03":U &THEN 
                                                                            obj-cenario.log-1.
                                                                        &ELSE
                                                                            obj-cenario.log-atualizado.
                                                                        &ENDIF
    END.
    ELSE
        ASSIGN fi-valor-realizado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0":U
               tg-obj-processado:CHECKED IN FRAME {&FRAME-NAME}       = NO.
    
    APPLY "LEAVE":U TO obj-cenario.ep-codigo    IN FRAME {&FRAME-NAME}.
    APPLY "LEAVE":U TO obj-cenario.cod-cenario  IN FRAME {&FRAME-NAME}.
    APPLY "LEAVE":U TO obj-cenario.mo-codigo    IN FRAME {&FRAME-NAME}.

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
    ASSIGN cb-conteudo:SENSITIVE IN FRAME {&FRAME-NAME}        = YES
           cb-operador:SENSITIVE IN FRAME {&FRAME-NAME}        = YES
           tg-obj-processado:SENSITIVE IN FRAME {&FRAME-NAME}  = 
                    DECIMAL(fi-valor-realizado:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> 0 AND 
                    NOT(adm-new-record).
    
    APPLY "VALUE-CHANGED":U TO cb-conteudo IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-area V-table-Win 
PROCEDURE pi-atualiza-area :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-area AS INTEGER NO-UNDO.
    
    ASSIGN i-area  = pi-area
           fi-area = {adinc/i01ad337.i 04 pi-area}.
    
    RUN pi-atualiza-conteudo IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-conteudo V-table-Win 
PROCEDURE pi-atualiza-conteudo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CASE i-area:
        WHEN 1 THEN  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then 
                         ASSIGN cb-conteudo:List-item-pairs IN FRAME {&FRAME-NAME} = ENTRY(1, c-conteudo) + ",":U + 
                                                                                     ENTRY(2, c-conteudo) + ",":U + 
                                                                                     ENTRY(3, c-conteudo) + ",":U + 
                                                                                     ENTRY(4, c-conteudo).
                     &else
                         ASSIGN cb-conteudo:LIST-ITEMS IN FRAME {&FRAME-NAME} =  ENTRY(1, c-conteudo) + ",":U + 
                                                                                 ENTRY(2, c-conteudo).
                     &endif

        WHEN 2 THEN  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then 
                         ASSIGN cb-conteudo:List-item-pairs IN FRAME {&FRAME-NAME} = ENTRY(5, c-conteudo) + ",":U + 
                                                                                     ENTRY(6, c-conteudo) + ",":U + 
                                                                                     ENTRY(7, c-conteudo) + ",":U + 
                                                                                     ENTRY(8, c-conteudo). 
                     &else
                         ASSIGN cb-conteudo:LIST-ITEMS IN FRAME {&FRAME-NAME} = ENTRY(3, c-conteudo) + ",":U + 
                                                                                ENTRY(4, c-conteudo).
                     &endif

        WHEN 3 THEN  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                         ASSIGN cb-conteudo:List-item-pairs IN FRAME {&FRAME-NAME} = ENTRY(9, c-conteudo) + ",":U + 
                                                                                     ENTRY(10, c-conteudo) + ",":U + 
                                                                                     ENTRY(11, c-conteudo) + ",":U + 
                                                                                     Entry(12, c-conteudo) + ",":U +
                                                                                     ENTRY(13, c-conteudo) + ",":U + 
                                                                                     ENTRY(14, c-conteudo).
                     &else 
                         ASSIGN cb-conteudo:LIST-ITEMS IN FRAME {&FRAME-NAME} = ENTRY(5, c-conteudo) + ",":U + 
                                                                                ENTRY(6, c-conteudo) + ",":U +
                                                                                ENTRY(7, c-conteudo).
                     &endif

        WHEN 4 THEN &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                         ASSIGN cb-conteudo:List-item-pairs IN FRAME {&FRAME-NAME} = ENTRY(15, c-conteudo) + ",":U + 
                                                                                     ENTRY(16, c-conteudo) + ",":U + 
                                                                                     ENTRY(17, c-conteudo) + ",":U + 
                                                                                     ENTRY(18, c-conteudo) + ",":U + 
                                                                                     ENTRY(19, c-conteudo) + ",":U + 
                                                                                     ENTRY(20, c-conteudo) + ",":U + 
                                                                                     ENTRY(21, c-conteudo) + ",":U + 
                                                                                     ENTRY(22, c-conteudo) + ",":U + 
                                                                                     ENTRY(23, c-conteudo) + ",":U + 
                                                                                     ENTRY(24, c-conteudo) + ",":U + 
                                                                                     ENTRY(25, c-conteudo) + ",":U + 
                                                                                     ENTRY(26, c-conteudo).
                    &else
                         ASSIGN cb-conteudo:LIST-ITEMS IN FRAME {&FRAME-NAME} = ENTRY(8, c-conteudo) + ",":U + 
                                                                                ENTRY(9, c-conteudo) + ",":U + 
                                                                                ENTRY(10, c-conteudo) + ",":U + 
                                                                                ENTRY(11, c-conteudo) + ",":U + 
                                                                                ENTRY(12, c-conteudo) + ",":U + 
                                                                                ENTRY(13, c-conteudo).
                    &endif

        WHEN 5 THEN &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                        ASSIGN cb-conteudo:List-item-pairs IN FRAME {&FRAME-NAME} = ENTRY(27, c-conteudo) + ",":U + 
                                                                                    ENTRY(28, c-conteudo) + ",":U + 
                                                                                    ENTRY(29, c-conteudo) + ",":U + 
                                                                                    ENTRY(30, c-conteudo) + ",":U + 
                                                                                    ENTRY(31, c-conteudo) + ",":U + 
                                                                                    ENTRY(32, c-conteudo) + ",":U + 
                                                                                    ENTRY(33, c-conteudo) + ",":U + 
                                                                                    ENTRY(34, c-conteudo) + ",":U + 
                                                                                    ENTRY(35, c-conteudo) + ",":U + 
                                                                                    ENTRY(36, c-conteudo) + ",":U + 
                                                                                    ENTRY(37, c-conteudo) + ",":U + 
                                                                                    ENTRY(38, c-conteudo).
                    &else
                        ASSIGN cb-conteudo:LIST-ITEMS IN FRAME {&FRAME-NAME} = ENTRY(14, c-conteudo) + ",":U + 
                                                                               ENTRY(15, c-conteudo) + ",":U + 
                                                                               ENTRY(16, c-conteudo) + ",":U + 
                                                                               ENTRY(17, c-conteudo) + ",":U + 
                                                                               ENTRY(18, c-conteudo) + ",":U + 
                                                                               ENTRY(19, c-conteudo).
                    &endif

        WHEN 6 THEN &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                         ASSIGN cb-conteudo:List-item-pairs IN FRAME {&FRAME-NAME} = ENTRY(39, c-conteudo) + ",":U + ENTRY(40, c-conteudo).
                    &else
                         ASSIGN cb-conteudo:LIST-ITEMS IN FRAME {&FRAME-NAME} = ENTRY(20, c-conteudo).
                    &endif
    END CASE.
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
    DEFINE INPUT PARAMETER v-row-parent-externo AS ROWID NO-UNDO.
    
    ASSIGN v-row-parent = v-row-parent-externo.
    
    FIND cenario-ge WHERE ROWID(cenario-ge) = v-row-parent NO-LOCK NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /*--- Valida‡äes de Dicion rio de Dados ---*/
    {include/i-vldfrm.i}
    
    /*--- Valida‡Æo do Fill-In obj-cenario.dt-objetivo ---*/
    IF AVAILABLE cenario-ge AND 
      (DATE(obj-cenario.dt-objetivo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = ? OR
       DATE(obj-cenario.dt-objetivo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) < cenario-ge.dt-inicial OR
       DATE(obj-cenario.dt-objetivo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) > cenario-ge.dt-final) THEN DO:
        {include/i-vldprg.i}
        
        {utp/ut-field.i mgadm obj-cenario dt-objetivo 1}
        
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15536,
                           INPUT RETURN-VALUE + "~~" + 
                                 STRING(cenario-ge.dt-inicial, "99/99/9999":U) + "~~" + 
                                 STRING(cenario-ge.dt-final, "99/99/9999":U)).
        
        APPLY "ENTRY":U TO obj-cenario.dt-objetivo IN FRAME {&FRAME-NAME}.
        
        RETURN "ADM-ERROR":U.
    END.
    
    /*--- Valida‡Æo do Fill-In obj-cenario.data-1 ---*/
    IF AVAILABLE cenario-ge AND 
      (DATE(obj-cenario.dt-objetivo-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = ? OR
       DATE(obj-cenario.dt-objetivo-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME}) < cenario-ge.dt-inicial OR
       DATE(obj-cenario.dt-objetivo-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME}) > DATE(obj-cenario.dt-objetivo:SCREEN-VALUE IN FRAME {&FRAME-NAME})) THEN DO:
        {include/i-vldprg.i}
        
        {utp/ut-liter.i Data_Ini_Obj}
        
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15536,
                           INPUT RETURN-VALUE + "~~" + 
                                 STRING(cenario-ge.dt-inicial, "99/99/9999":U) + "~~" + 
                                 obj-cenario.dt-objetivo:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
        
        APPLY "ENTRY":U TO obj-cenario.dt-objetivo-ini IN FRAME {&FRAME-NAME}.
        
        RETURN "ADM-ERROR":U.
    END.
    
    /*--- Valida‡Æo do Fill-In obj-cenario.mo-codigo ---*/
    IF NOT CAN-FIND(moeda WHERE moeda.mo-codigo = INTEGER(obj-cenario.mo-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME})) THEN DO:
        {include/i-vldprg.i}
        
        {utp/ut-table.i mguni moeda 1}
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 56,
                           INPUT RETURN-VALUE).
        
        APPLY "ENTRY":U TO obj-cenario.mo-codigo IN FRAME {&FRAME-NAME}.
        
        RETURN "ADM-ERROR":U.
    END.

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
  {src/adm/template/snd-list.i "obj-cenario"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/*-----------------------------------------------------------
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

    RUN pi-trata-state IN THIS-PROCEDURE (INPUT p-issuer-hdl, INPUT p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


