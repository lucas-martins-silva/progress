&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttUnidNegocEqpto NO-UNDO LIKE mab-unid-negoc-eqpto
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0138N 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i AB0138N MAB}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{cdp/cdcfgmnt.i} /*Versäes EMS MNT*/
{cdp/cd9911.i}   /*Unidade Neg¢cio*/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0138N
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Unid Negoc

&GLOBAL-DEFINE page0Widgets   btOK btHelp 
&GLOBAL-DEFINE page1Widgets   brUnNegoc
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-ep-codigo LIKE mab-eqpto.ep-codigo NO-UNDO.
DEFINE INPUT PARAMETER p-cod-eqpto LIKE mab-eqpto.cod-eqpto NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hDBOUnidNegocEqpto AS HANDLE NO-UNDO.    
DEFINE VARIABLE hDBOEqpto          AS HANDLE NO-UNDO.

DEFINE VARIABLE c-cod-estabel      LIKE mab-eqpto.cod-estabel                            NO-UNDO.
DEFINE VARIABLE c-cod-unid-negoc   LIKE mab-unid-negoc-histor-ativid.cod-unid-negoc      NO-UNDO.
&IF DEFINED(bf_mnt_ems206b) &THEN
DEFINE VARIABLE c-des-unid-negoc   LIKE unid-negoc.des-unid-negoc                        NO-UNDO.
&ELSE
DEFINE VARIABLE c-des-unid-negoc   AS CHARACTER                                          NO-UNDO.
&ENDIF
DEFINE VARIABLE perc-unid-negoc    LIKE mab-unid-negoc-histor-ativid.val-perc-unid-negoc NO-UNDO.
DEFINE VARIABLE l-erro             AS LOGICAL INITIAL NO                                 NO-UNDO.
DEFINE VARIABLE l-habilita         AS LOGICAL INITIAL NO                                 NO-UNDO.

/* Temp-table Definitions ---                                           */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brUnNegoc

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttUnidNegocEqpto

/* Definitions for BROWSE brUnNegoc                                     */
&Scoped-define FIELDS-IN-QUERY-brUnNegoc ttUnidNegocEqpto.cod-unid-negoc fnDescUnidNegocOM (ttUnidNegocEqpto.cod-unid-negoc) @ c-des-unid-negoc ttUnidNegocEqpto.val-perc-unid-negoc   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brUnNegoc   
&Scoped-define SELF-NAME brUnNegoc
&Scoped-define QUERY-STRING-brUnNegoc FOR EACH ttUnidNegocEqpto NO-LOCK
&Scoped-define OPEN-QUERY-brUnNegoc OPEN QUERY {&SELF-NAME} FOR EACH ttUnidNegocEqpto NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brUnNegoc ttUnidNegocEqpto
&Scoped-define FIRST-TABLE-IN-QUERY-brUnNegoc ttUnidNegocEqpto


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brUnNegoc}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-9 rtToolBar ep-codigo cod-eqpto ~
c-desc-eqpto btOK btHelp 
&Scoped-Define DISPLAYED-OBJECTS ep-codigo cod-eqpto c-desc-eqpto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescUnidNegocOM wWindow 
FUNCTION fnDescUnidNegocOM RETURNS CHARACTER
  ( INPUT pcod-unid-negoc AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-desc-eqpto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE cod-eqpto LIKE ttUnidNegocEqpto.cod-eqpto
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE ep-codigo LIKE ttUnidNegocEqpto.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.43 BY 2.54.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brUnNegoc FOR 
      ttUnidNegocEqpto SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brUnNegoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brUnNegoc wWindow _FREEFORM
  QUERY brUnNegoc DISPLAY
      ttUnidNegocEqpto.cod-unid-negoc 
fnDescUnidNegocOM (ttUnidNegocEqpto.cod-unid-negoc) @ c-des-unid-negoc
ttUnidNegocEqpto.val-perc-unid-negoc
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 68 BY 8.25
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ep-codigo AT ROW 1.5 COL 22 COLON-ALIGNED HELP
          "C¢digo da Empresa do Equipamento"
     cod-eqpto AT ROW 2.5 COL 22 COLON-ALIGNED HELP
          "C¢digo do Equipamento"
     c-desc-eqpto AT ROW 2.5 COL 39 COLON-ALIGNED NO-LABEL
     btOK AT ROW 15.92 COL 1.86
     btHelp AT ROW 15.92 COL 79.86
     RECT-9 AT ROW 1.21 COL 1.57
     rtToolBar AT ROW 15.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.13
         FONT 1.

DEFINE FRAME fPage1
     brUnNegoc AT ROW 1.5 COL 7
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4.14 ROW 5.13
         SIZE 84.43 BY 9.88
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttUnidNegocEqpto T "?" NO-UNDO mgfro mab-unid-negoc-eqpto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Manuten‡Æo Matriz Unidade Neg¢cio Ordem de Manuten‡Æo"
         HEIGHT             = 16.17
         WIDTH              = 90
         MAX-HEIGHT         = 39.54
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.54
         VIRTUAL-WIDTH      = 182.86
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}
{btb/btb008za.i0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN cod-eqpto IN FRAME fpage0
   LIKE = Temp-Tables.ttUnidNegocEqpto.cod-eqpto                        */
/* SETTINGS FOR FILL-IN ep-codigo IN FRAME fpage0
   LIKE = Temp-Tables.ttUnidNegocEqpto.ep-codigo                        */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brUnNegoc 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brUnNegoc
/* Query rebuild information for BROWSE brUnNegoc
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttUnidNegocEqpto NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brUnNegoc */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Manuten‡Æo Matriz Unidade Neg¢cio Ordem de Manuten‡Æo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Manuten‡Æo Matriz Unidade Neg¢cio Ordem de Manuten‡Æo */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    APPLY "CLOSE":U   TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brUnNegoc
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(hDBOEqpto) THEN
        RUN destroy IN hDBOEqpto.

    IF VALID-HANDLE(hDBOUnidNegocEqpto) THEN
        RUN destroy IN hDBOUnidNegocEqpto.

    RETURN "OK":U.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {utp/ut-liter.i Descri‡Æo *}
    ASSIGN c-des-unid-negoc:LABEL IN BROWSE brUnNegoc = RETURN-VALUE.
    {utp/ut-liter.i %Unid_Negoc *}
    ASSIGN ttUnidNegocEqpto.val-perc-unid-negoc:LABEL IN BROWSE brUnNegoc = RETURN-VALUE.

    ASSIGN cod-eqpto    = p-cod-eqpto
           ep-codigo    = p-ep-codigo.

    RUN buscaModelo IN hDBOEqpto (INPUT p-ep-codigo,
                                  INPUT p-cod-eqpto,
                                  OUTPUT c-desc-eqpto).

    DISP ep-codigo cod-eqpto c-desc-eqpto WITH FRAME fPage0.

    RUN carregaTT IN hDBOUnidNegocEqpto (INPUT p-ep-codigo,
                                         INPUT p-cod-eqpto,
                                         OUTPUT TABLE ttUnidNegocEqpto).

    /*--- Atualiaza o browse ---*/
    RUN OpenQueryBrowse IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE (hDBOEqpto) THEN DO:
        {btb/btb008za.i1 frbo/bofr007.p}
        {btb/btb008za.i2 frbo/bofr007.p '' hDBOEqpto}
    END.
    RUN openQueryStatic  IN hDBOEqpto (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE (hDBOUnidNegocEqpto) THEN DO:
        {btb/btb008za.i1 frbo/bofr131.p}                  
        {btb/btb008za.i2 frbo/bofr131.p '' hDBOUnidNegocEqpto}
    END.
    RUN openQueryStatic IN hDBOUnidNegocEqpto (INPUT "Main":U) NO-ERROR.

    RETURN "OK":U.                                     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryBrowse wWindow 
PROCEDURE openQueryBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&OPEN-QUERY-brUnNegoc}

    RETURN "OK":U.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescUnidNegocOM wWindow 
FUNCTION fnDescUnidNegocOM RETURNS CHARACTER
  ( INPUT pcod-unid-negoc AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Retornar a descri‡Æo da Unidade de Neg¢cio referente a Ordem de Manuten‡Æo
    Notes:  pcod-unid-negoc - C¢digo da Unidade de Neg¢cio
------------------------------------------------------------------------------*/
    
    &IF DEFINED(bf_mnt_ems206b) &THEN
        FIND FIRST unid-negoc NO-LOCK
            WHERE unid-negoc.cod-unid-negoc = pcod-unid-negoc NO-ERROR.
        
        ASSIGN c-des-unid-negoc = IF AVAIL unid-negoc THEN unid-negoc.des-unid-negoc ELSE "":U.
    &ENDIF

    RETURN c-des-unid-negoc.   /** Function return value. **/
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

