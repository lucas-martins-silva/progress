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
{include/i-prgvrs.i V01IN671 2.00.00.003}  /*** 010003 ***/

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

    def var c-lista-prioridade as char no-undo.

    def var i-cor-f-muito as integer no-undo.
    def var i-cor-l-muito as integer no-undo.
    def var i-cor-f-alta  as integer no-undo.
    def var i-cor-l-alta  as integer no-undo.
    def var i-cor-f-media as integer no-undo.
    def var i-cor-l-media as integer no-undo.
    def var i-cor-f-baixa as integer no-undo.
    def var i-cor-l-baixa as integer no-undo.
    def var i-cor-f       as integer no-undo.
    def var i-cor-l       as integer no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cb-prioridade bt-fundo-ant bt-fundo-prox ~
bt-letra-ant bt-letra-prox RECT-10 RECT-7 RECT-8 RECT-9 rt-mold-9 
&Scoped-Define DISPLAYED-OBJECTS c-muito cb-prioridade c-alta c-media ~
c-baixa 

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
DEFINE BUTTON bt-fundo-ant 
     IMAGE-UP FILE "image~\im-pre":U
     IMAGE-INSENSITIVE FILE "image~\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-fundo-prox 
     IMAGE-UP FILE "image~\im-nex":U
     IMAGE-INSENSITIVE FILE "image~\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-letra-ant 
     IMAGE-UP FILE "image~\im-pre":U
     IMAGE-INSENSITIVE FILE "image~\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-letra-prox 
     IMAGE-UP FILE "image~\im-nex":U
     IMAGE-INSENSITIVE FILE "image~\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE VARIABLE cb-prioridade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Prioridade" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE c-alta AS CHARACTER FORMAT "X(256)":U INITIAL "Alta" 
     VIEW-AS FILL-IN 
     SIZE 19.72 BY 1
     FONT 0 NO-UNDO.

DEFINE VARIABLE c-baixa AS CHARACTER FORMAT "X(256)":U INITIAL "Baixa" 
     VIEW-AS FILL-IN 
     SIZE 19.72 BY 1
     FONT 0 NO-UNDO.

DEFINE VARIABLE c-media AS CHARACTER FORMAT "X(256)":U INITIAL "M‚dia" 
     VIEW-AS FILL-IN 
     SIZE 19.72 BY 1
     FONT 0 NO-UNDO.

DEFINE VARIABLE c-muito AS CHARACTER FORMAT "X(256)":U INITIAL "Muito Alta" 
     VIEW-AS FILL-IN 
     SIZE 19.72 BY 1
     FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 31.29 BY 5.38.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 7.72 BY .75.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 7.72 BY .75.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 23.14 BY 5.38.

DEFINE RECTANGLE rt-mold-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81.86 BY 11.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-muito AT ROW 4.75 COL 13.57 COLON-ALIGNED NO-LABEL
     cb-prioridade AT ROW 4.88 COL 47.43 COLON-ALIGNED
     c-alta AT ROW 5.88 COL 13.57 COLON-ALIGNED NO-LABEL
     c-media AT ROW 7 COL 13.57 COLON-ALIGNED NO-LABEL
     bt-fundo-ant AT ROW 7 COL 49.43 HELP
          "Cor fundo"
     bt-fundo-prox AT ROW 7 COL 53.29 HELP
          "Cor fundo"
     bt-letra-ant AT ROW 7 COL 59.72 HELP
          "Cor letra"
     bt-letra-prox AT ROW 7 COL 63.57 HELP
          "Cor letra"
     c-baixa AT ROW 8.13 COL 13.57 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 4.25 COL 38.29
     RECT-7 AT ROW 8.25 COL 49.43
     RECT-8 AT ROW 8.25 COL 59.72
     RECT-9 AT ROW 4.25 COL 13.86
     rt-mold-9 AT ROW 1 COL 1
     "Fundo" VIEW-AS TEXT
          SIZE 7.29 BY .67 AT ROW 6.25 COL 49.43
     "Letra" VIEW-AS TEXT
          SIZE 6.43 BY .67 AT ROW 6.25 COL 59.72
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
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 11.88
         WIDTH              = 82.
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

/* SETTINGS FOR FILL-IN c-alta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-baixa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-media IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-muito IN FRAME f-main
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

&Scoped-define SELF-NAME bt-fundo-ant
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fundo-ant V-table-Win
ON CHOOSE OF bt-fundo-ant IN FRAME f-main /* Prev */
DO:

    if i-cor-f = 0 then assign i-cor-f = 15.
    else                assign i-cor-f = i-cor-f - 1.

    if entry(1, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-f-muito = i-cor-f.
    if entry(2, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-f-alta  = i-cor-f.
    if entry(3, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-f-media = i-cor-f.
    if entry(4, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-f-baixa = i-cor-f.

    run pi-mostra-cores.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fundo-prox
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fundo-prox V-table-Win
ON CHOOSE OF bt-fundo-prox IN FRAME f-main /* Next */
DO:

    if i-cor-f = 15 then assign i-cor-f = 0.
    else                assign i-cor-f = i-cor-f + 1.

    if entry(1, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-f-muito = i-cor-f.
    if entry(2, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-f-alta  = i-cor-f.
    if entry(3, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-f-media = i-cor-f.
    if entry(4, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-f-baixa = i-cor-f.

    run pi-mostra-cores.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-letra-ant
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-letra-ant V-table-Win
ON CHOOSE OF bt-letra-ant IN FRAME f-main /* Prev */
DO:

    if i-cor-l = 0 then assign i-cor-l = 15.
    else                assign i-cor-l = i-cor-l - 1.

    if entry(1, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-l-muito = i-cor-l.
    if entry(2, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-l-alta  = i-cor-l.
    if entry(3, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-l-media = i-cor-l.
    if entry(4, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-l-baixa = i-cor-l.

    run pi-mostra-cores.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-letra-prox
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-letra-prox V-table-Win
ON CHOOSE OF bt-letra-prox IN FRAME f-main /* Next */
DO:

    if i-cor-l = 15 then assign i-cor-l = 0.
    else                assign i-cor-l = i-cor-l + 1.

    if entry(1, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-l-muito = i-cor-l.
    if entry(2, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-l-alta  = i-cor-l.
    if entry(3, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-l-media = i-cor-l.
    if entry(4, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-l-baixa = i-cor-l.

    run pi-mostra-cores.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-prioridade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-prioridade V-table-Win
ON VALUE-CHANGED OF cb-prioridade IN FRAME f-main /* Prioridade */
DO:

    if entry(1, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-f = i-cor-f-muito
               i-cor-l = i-cor-l-muito.

    if entry(2, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-f = i-cor-f-alta
               i-cor-l = i-cor-l-alta.

    if entry(3, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-f = i-cor-f-media
               i-cor-l = i-cor-l-media.

    if entry(4, c-lista-prioridade) = input frame {&frame-name} cb-prioridade then 
        assign i-cor-f = i-cor-f-baixa
               i-cor-l = i-cor-l-baixa.

    run pi-mostra-cores.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

    {utp/ut-liter.i Muito_Alta * r}
    assign c-muito :screen-value in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Alta * r}
    assign c-alta:screen-value in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i M‚dia * r}
    assign c-media:screen-value in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Baixa * r}
    assign c-baixa:screen-value in frame {&frame-name} = trim(return-value).

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

    /*****     
    assign substring(param-aprov.char-1,1,2)  = i-cor-f-muito
           substring(param-aprov.char-1,3,2)  = i-cor-l-muito
           substring(param-aprov.char-1,5,2)  = i-cor-f-alta
           substring(param-aprov.char-1,7,2)  = i-cor-l-alta 
           substring(param-aprov.char-1,9,2)  = i-cor-f-media
           substring(param-aprov.char-1,11,2) = i-cor-l-media
           substring(param-aprov.char-1,13,2) = i-cor-f-baixa
           substring(param-aprov.char-1,15,2) = i-cor-l-baixa.
           *****/

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    if available param-aprov then do:

        /*****
        assign i-cor-f-muito = integer(substring(param-aprov.char-1,1,2))
               i-cor-l-muito = integer(substring(param-aprov.char-1,3,2))
               i-cor-f-alta  = integer(substring(param-aprov.char-1,5,2))
               i-cor-l-alta  = integer(substring(param-aprov.char-1,7,2))
               i-cor-f-media = integer(substring(param-aprov.char-1,9,2))
               i-cor-l-media = integer(substring(param-aprov.char-1,11,2))
               i-cor-f-baixa = integer(substring(param-aprov.char-1,13,2))
               i-cor-l-baixa = integer(substring(param-aprov.char-1,15,2)).
               *****/

        assign i-cor-f = i-cor-f-muito
               i-cor-l = i-cor-l-muito.

        run pi-mostra-cores.           

    end.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  {utp/ut-liter.i Muito_Alta * r}
  assign c-lista-prioridade = trim(return-value).
  {utp/ut-liter.i Alta * r}
  assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).
  {utp/ut-liter.i M‚dia * r}
  assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).
  {utp/ut-liter.i Baixa * r}
  assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).
  assign cb-prioridade:list-items in frame {&frame-name} = c-lista-prioridade.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    {utp/ut-liter.i Muito_Alta * r}
    assign cb-prioridade = trim(return-value).
    display cb-prioridade with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-assign-record V-table-Win 
PROCEDURE pi-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find first param-mat 
        exclusive-lock no-error.

    if available param-mat then do:
        assign param-mat.cor-fundo-muito = i-cor-f-muito
               param-mat.cor-letra-muito = i-cor-l-muito
               param-mat.cor-fundo-alta  = i-cor-f-alta
               param-mat.cor-letra-alta  = i-cor-l-alta
               param-mat.cor-fundo-media = i-cor-f-media
               param-mat.cor-letra-media = i-cor-l-media
               param-mat.cor-fundo-baixa = i-cor-f-baixa
               param-mat.cor-letra-baixa = i-cor-l-baixa.
    end.

    release param-mat.        

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-cores V-table-Win 
PROCEDURE pi-inicializa-cores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find first param-mat
        no-lock no-error.
    if available param-mat then do:
        assign i-cor-f       = param-mat.cor-fundo-muito
               i-cor-l       = param-mat.cor-letra-muito
               i-cor-f-muito = param-mat.cor-fundo-muito
               i-cor-l-muito = param-mat.cor-letra-muito
               i-cor-f-alta  = param-mat.cor-fundo-alta
               i-cor-l-alta  = param-mat.cor-letra-alta
               i-cor-f-media = param-mat.cor-fundo-media
               i-cor-l-media = param-mat.cor-letra-media
               i-cor-f-baixa = param-mat.cor-fundo-baixa
               i-cor-l-baixa = param-mat.cor-letra-baixa.
    end.
    else do:
        assign i-cor-f       = 15
               i-cor-l       = 0
               i-cor-f-muito = 15
               i-cor-l-muito = 0
               i-cor-f-alta  = 15
               i-cor-l-alta  = 0
               i-cor-f-media = 15
               i-cor-l-media = 0
               i-cor-f-baixa = 15
               i-cor-l-baixa = 0.
    end.

    run pi-mostra-cores.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-cores V-table-Win 
PROCEDURE pi-mostra-cores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign c-muito:bgcolor in frame {&frame-name} = i-cor-f-muito
           c-muito:fgcolor in frame {&frame-name} = i-cor-l-muito
           c-alta:bgcolor  in frame {&frame-name} = i-cor-f-alta
           c-alta:fgcolor  in frame {&frame-name} = i-cor-l-alta
           c-media:bgcolor in frame {&frame-name} = i-cor-f-media
           c-media:fgcolor in frame {&frame-name} = i-cor-l-media
           c-baixa:bgcolor in frame {&frame-name} = i-cor-f-baixa
           c-baixa:fgcolor in frame {&frame-name} = i-cor-l-baixa
           RECT-7:bgcolor  in frame {&frame-name} = i-cor-f
           RECT-8:bgcolor  in frame {&frame-name} = i-cor-l.

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

