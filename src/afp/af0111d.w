&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAf-grp-avaliacao NO-UNDO LIKE af-grp-avaliacao
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttAf-grp-avaliacao-form NO-UNDO LIKE af-grp-avaliacao-form
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttAf-item-contr-estab NO-UNDO LIKE af-item-contr-estab
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
{include/i-prgvrs.i AF0111D 2.00.00.006 } /*** 010006 ***/
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program       AF0111D
&GLOBAL-DEFINE Version        2.00.00.005

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 

DEF BUFFER bttAf-Item-Contr-Estab FOR ttAf-Item-Contr-Estab.
{utp/ut-glob.i}
/* Parameters Definitions ---                                           */

DEFINE INPUT PARAMETER TABLE  FOR ttAf-Item-Contr-Estab.
DEFINE INPUT PARAMETER TABLE  FOR ttAf-Grp-Avaliacao.
DEFINE INPUT PARAMETER TABLE  FOR ttAf-Grp-Avaliacao-Form.
DEFINE INPUT PARAMETER c-cod-grp-avaliacao LIKE Af-Grp-Avaliacao.cod-grp-avaliacao.
DEFINE INPUT PARAMETER pi-nr-versao LIKE Af-Grp-Avaliacao.nr-versao.


/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-boaf001    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf006    AS HANDLE NO-UNDO.

DEFINE VARIABLE c-desc-emitente AS CHARACTER FORMAT "x(30)" NO-UNDO.
DEFINE VARIABLE c-desc-item     AS CHARACTER FORMAT "x(30)" NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSon4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttAf-item-contr-estab

/* Definitions for BROWSE brSon4                                        */
&Scoped-define FIELDS-IN-QUERY-brSon4 ttAf-item-contr-estab.cod-estabel ttAf-item-contr-estab.nr-versao ttAf-item-contr-estab.cod-emitente fn-desc-emitente(ttAf-item-contr-estab.cod-emitente) @ c-desc-emitente ttAf-item-contr-estab.it-codigo fn-desc-item(ttAf-item-contr-estab.it-codigo) @ c-desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon4   
&Scoped-define SELF-NAME brSon4
&Scoped-define QUERY-STRING-brSon4 FOR EACH ttAf-item-contr-estab       WHERE ttAf-item-contr-estab.log-inf-grp-aval = yes  NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSon4 OPEN QUERY {&SELF-NAME} FOR EACH ttAf-item-contr-estab       WHERE ttAf-item-contr-estab.log-inf-grp-aval = yes  NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSon4 ttAf-item-contr-estab
&Scoped-define FIRST-TABLE-IN-QUERY-brSon4 ttAf-item-contr-estab


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brSon4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-30 rtToolBar brSon4 bt-retirar btOK ~
btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-emitente wWindow 
FUNCTION fn-desc-emitente RETURNS CHARACTER
  ( i-codemitente AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-item wWindow 
FUNCTION fn-desc-item RETURNS CHARACTER
  ( c-item AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-retirar 
     LABEL "&NÆo Copiar" 
     SIZE 13 BY 1.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 10.71.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 86 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon4 FOR 
      ttAf-item-contr-estab SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon4 wWindow _FREEFORM
  QUERY brSon4 NO-LOCK DISPLAY
      ttAf-item-contr-estab.cod-estabel FORMAT "X(5)":U WIDTH 9.43
      ttAf-item-contr-estab.nr-versao FORMAT ">>>>9":U WIDTH 7.43
      ttAf-item-contr-estab.cod-emitente FORMAT ">>>>>>>>9":U
      fn-desc-emitente(ttAf-item-contr-estab.cod-emitente) @ c-desc-emitente COLUMN-LABEL "Descri‡Æo"
      ttAf-item-contr-estab.it-codigo FORMAT "x(16)":U
      fn-desc-item(ttAf-item-contr-estab.it-codigo) @ c-desc-item COLUMN-LABEL "Descri‡Æo Item" FORMAT "x(30)":U
            WIDTH 33
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.75
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     brSon4 AT ROW 1.75 COL 3
     bt-retirar AT ROW 10.5 COL 3
     btOK AT ROW 12.21 COL 2
     btCancel AT ROW 12.21 COL 13
     btHelp2 AT ROW 12.25 COL 76
     RECT-30 AT ROW 1.04 COL 1
     rtToolBar AT ROW 12 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 86.72 BY 12.63
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttAf-grp-avaliacao T "?" NO-UNDO emsdca af-grp-avaliacao
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttAf-grp-avaliacao-form T "?" NO-UNDO emsdca af-grp-avaliacao-form
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttAf-item-contr-estab T "?" NO-UNDO emsdca af-item-contr-estab
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
         TITLE              = ""
         HEIGHT             = 12.54
         WIDTH              = 87.72
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brSon4 rtToolBar fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon4
/* Query rebuild information for BROWSE brSon4
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttAf-item-contr-estab
      WHERE ttAf-item-contr-estab.log-inf-grp-aval = yes
 NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "ttAf-item-contr-estab.log-inf-grp-aval = yes
"
     _Query            is OPENED
*/  /* BROWSE brSon4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-retirar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-retirar wWindow
ON CHOOSE OF bt-retirar IN FRAME fpage0 /* NÆo Copiar */
DO:
    if brSon4:num-selected-rows in frame {&frame-name} > 0 then do on error undo, return no-apply:
          get current brSon4.
          RUN piEliminaCodGrpAvaliacao IN h-boaf006 (INPUT ttAf-Item-Contr-Estab.cod-estabel,
                                                   INPUT ttAf-Item-Contr-Estab.it-codigo,
                                                   INPUT ttAf-Item-Contr-Estab.cod-emitente,
                                                   INPUT ttAf-Item-Contr-Estab.cod-grp-avaliacao,
                                                   INPUT pi-nr-versao).
          delete ttAf-Item-Contr-Estab.
          if brSon4:delete-current-row() in frame {&frame-name} then.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
   


    RUN piAtualizaDados IN h-boaf006 (INPUT TABLE ttAf-item-contr-estab,
                                      INPUT TABLE ttAf-Grp-Avaliacao,
                                      INPUT TABLE ttAf-Grp-Avaliacao-Form,
                                      INPUT c-cod-grp-avaliacao,
                                      INPUT pi-nr-versao). 

                                       
    
    APPLY "CLOSE":U TO THIS-PROCEDURE. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon4
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wWindow 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    

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
ENABLE brSon4 
       bt-retirar WITH FRAME fPage0.

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

    {&OPEN-QUERY-brSon4}
    
    IF NOT VALID-HANDLE(h-boaf006) OR
       h-boaf006:TYPE <> "PROCEDURE":U OR
       h-boaf006:FILE-NAME <> "afbo/boaf006.p":U THEN DO:
       
       RUN afbo/boaf006.p PERSISTENT SET h-boaf006.
    
    END.
    
    /*RUN openQueryStatic IN h-boaf006 (INPUT "Main":U) NO-ERROR.*/

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-emitente wWindow 
FUNCTION fn-desc-emitente RETURNS CHARACTER
  ( i-codemitente AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  RUN getNomeEmitente in h-boaf006 ( INPUT i-codemitente,
                                 OUTPUT c-desc-emitente ).
  RETURN c-desc-emitente.  /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-item wWindow 
FUNCTION fn-desc-item RETURNS CHARACTER
  ( c-item AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   RUN getDescItem in h-boaf006 ( INPUT c-item,
                                  OUTPUT c-desc-item ).
   RETURN c-desc-item.  /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

