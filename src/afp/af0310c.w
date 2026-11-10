&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI 
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0310C 2.00.00.002}  /*** 010002 ***/
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
&GLOBAL-DEFINE Program        AF0310C
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         no

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              cb-ano-ini ~
                              cb-periodo-ini ~
                              cb-ano-fim ~
                              cb-periodo-fim ~
                              c-cod-estabel-ini ~
                              c-cod-estabel-fim ~
                              i-cod-emitente-ini ~
                              i-cod-emitente-fim ~
                              i-nr-controle-ini ~
                              i-nr-controle-fim ~
                              c-it-codigo-ini ~
                              c-it-codigo-fim ~
                              c-cod-grp-aval-ini ~
                              c-cod-grp-aval-fim ~
                              c-cod-grp-resp-ini ~
                              c-cod-grp-resp-fim ~
                              i-cod-gr-forn-ini ~
                              i-cod-gr-forn-fim ~
                              c-fm-codigo-ini ~
                              c-fm-codigo-fim ~
                              i-ge-codigo-ini ~
                              i-ge-codigo-fim ~
                              i-classif ~
                              l-indice-nao-digitado ~
                              l-indice-por-item ~
                              l-indice-digitado-calculado

{afbo/boaf008.i2} /* tt-filtro */

/* Parameters Definitions ---                                           */
define input-output param table for tt-filtro.
define output       param l-ok as logical no-undo.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cb-ano-ini cb-periodo-ini cb-ano-fim ~
cb-periodo-fim i-cod-gr-forn-ini i-cod-gr-forn-fim c-fm-codigo-ini ~
c-fm-codigo-fim i-ge-codigo-ini i-ge-codigo-fim i-classif ~
l-indice-nao-digitado l-indice-por-item l-indice-digitado-calculado btOK ~
btCancel btHelp2 IMAGE-65 IMAGE-67 IMAGE-69 IMAGE-70 IMAGE-71 IMAGE-72 ~
IMAGE-74 IMAGE-79 IMAGE-83 IMAGE-84 IMAGE-85 IMAGE-86 IMAGE-89 IMAGE-90 ~
IMAGE-91 IMAGE-92 IMAGE-93 IMAGE-94 IMAGE-95 IMAGE-96 RECT-47 RECT-48 ~
RECT-50 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS cb-ano-ini cb-periodo-ini cb-ano-fim ~
cb-periodo-fim c-cod-estabel-ini c-cod-estabel-fim i-cod-emitente-ini ~
i-cod-emitente-fim i-nr-controle-ini i-nr-controle-fim c-it-codigo-ini ~
c-it-codigo-fim c-cod-grp-aval-ini c-cod-grp-aval-fim c-cod-grp-resp-ini ~
c-cod-grp-resp-fim i-cod-gr-forn-ini i-cod-gr-forn-fim c-fm-codigo-ini ~
c-fm-codigo-fim i-ge-codigo-ini i-ge-codigo-fim i-classif ~
l-indice-nao-digitado l-indice-por-item l-indice-digitado-calculado 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-ano-fim AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ano-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Per¡odo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE cb-periodo-fim AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-periodo-ini AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER FORMAT "X(3)" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ini AS CHARACTER FORMAT "X(3)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-grp-aval-fim AS CHARACTER FORMAT "X(8)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-grp-aval-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Grupo Avalia‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-grp-resp-fim AS CHARACTER FORMAT "X(8)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-grp-resp-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Grupo Respons vel" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-fm-codigo-fim AS CHARACTER FORMAT "X(8)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-fm-codigo-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Fam¡lia" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo-fim AS CHARACTER FORMAT "x(16)" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-gr-forn-fim AS INTEGER FORMAT ">9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-gr-forn-ini AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Grupo Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-ge-codigo-fim AS INTEGER FORMAT ">9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-ge-codigo-ini AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Grupo Estoque" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-controle-fim AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-controle-ini AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "N£mero Controle" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-65
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-67
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-69
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-70
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-71
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-72
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-74
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-79
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-83
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-84
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-85
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-86
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-89
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-90
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-91
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-92
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-93
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-94
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-95
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-96
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE i-classif AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Fornecedor", 1,
"Item", 2,
"N£mero Controle", 3,
"Data Öndice", 4
     SIZE 66 BY 1.5 NO-UNDO.

DEFINE RECTANGLE RECT-47
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 10.5.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 2.25.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE l-indice-digitado-calculado AS LOGICAL INITIAL no 
     LABEL "Öndices Digitados / Calculados" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE VARIABLE l-indice-nao-digitado AS LOGICAL INITIAL no 
     LABEL "Öndices NÆo Digitados" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE VARIABLE l-indice-por-item AS LOGICAL INITIAL no 
     LABEL "Öndices Detalhados por Item" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     cb-ano-ini AT ROW 1.25 COL 10 COLON-ALIGNED
     cb-periodo-ini AT ROW 1.25 COL 20.14 COLON-ALIGNED NO-LABEL
     cb-ano-fim AT ROW 1.25 COL 43 COLON-ALIGNED NO-LABEL
     cb-periodo-fim AT ROW 1.25 COL 54 COLON-ALIGNED NO-LABEL
     c-cod-estabel-ini AT ROW 2.25 COL 30.14 COLON-ALIGNED
     c-cod-estabel-fim AT ROW 2.25 COL 43 COLON-ALIGNED NO-LABEL
     i-cod-emitente-ini AT ROW 3.25 COL 23.14 COLON-ALIGNED
     i-cod-emitente-fim AT ROW 3.25 COL 43 COLON-ALIGNED NO-LABEL
     i-nr-controle-ini AT ROW 4.25 COL 26.14 COLON-ALIGNED
     i-nr-controle-fim AT ROW 4.25 COL 43 COLON-ALIGNED NO-LABEL
     c-it-codigo-ini AT ROW 5.25 COL 16.14 COLON-ALIGNED
     c-it-codigo-fim AT ROW 5.25 COL 43 COLON-ALIGNED NO-LABEL
     c-cod-grp-aval-ini AT ROW 6.25 COL 24.14 COLON-ALIGNED
     c-cod-grp-aval-fim AT ROW 6.25 COL 43 COLON-ALIGNED NO-LABEL
     c-cod-grp-resp-ini AT ROW 7.25 COL 24.14 COLON-ALIGNED
     c-cod-grp-resp-fim AT ROW 7.25 COL 43 COLON-ALIGNED NO-LABEL
     i-cod-gr-forn-ini AT ROW 8.25 COL 27.29 COLON-ALIGNED
     i-cod-gr-forn-fim AT ROW 8.25 COL 43 COLON-ALIGNED NO-LABEL
     c-fm-codigo-ini AT ROW 9.25 COL 24.14 COLON-ALIGNED
     c-fm-codigo-fim AT ROW 9.25 COL 43 COLON-ALIGNED NO-LABEL
     i-ge-codigo-ini AT ROW 10.25 COL 27.29 COLON-ALIGNED
     i-ge-codigo-fim AT ROW 10.25 COL 43 COLON-ALIGNED NO-LABEL
     i-classif AT ROW 12.08 COL 9 NO-LABEL
     l-indice-nao-digitado AT ROW 14.5 COL 9
     l-indice-por-item AT ROW 14.5 COL 45
     l-indice-digitado-calculado AT ROW 15.5 COL 9
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 68.57
     IMAGE-65 AT ROW 1.25 COL 38.14
     IMAGE-67 AT ROW 4.25 COL 38.14
     IMAGE-69 AT ROW 1.25 COL 42
     IMAGE-70 AT ROW 2.25 COL 38.14
     IMAGE-71 AT ROW 2.25 COL 42
     IMAGE-72 AT ROW 3.25 COL 38.14
     IMAGE-74 AT ROW 3.25 COL 42
     IMAGE-79 AT ROW 4.25 COL 42
     IMAGE-83 AT ROW 5.25 COL 38.14
     IMAGE-84 AT ROW 5.25 COL 42
     IMAGE-85 AT ROW 6.25 COL 38.14
     IMAGE-86 AT ROW 6.25 COL 42
     IMAGE-89 AT ROW 7.25 COL 38.14
     IMAGE-90 AT ROW 7.25 COL 42
     IMAGE-91 AT ROW 8.25 COL 38.14
     IMAGE-92 AT ROW 8.25 COL 42
     IMAGE-93 AT ROW 9.25 COL 38.14
     IMAGE-94 AT ROW 9.25 COL 42
     IMAGE-95 AT ROW 10.25 COL 38.14
     IMAGE-96 AT ROW 10.25 COL 42
     RECT-47 AT ROW 1 COL 1.14
     RECT-48 AT ROW 11.75 COL 1.14
     RECT-50 AT ROW 14.25 COL 1.14
     rtToolBar AT ROW 16.54 COL 1
     "Classifica‡Æo" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 11.5 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 79.29 BY 17
         FONT 1
         DEFAULT-BUTTON btOK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 79.43
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
/* SETTINGS FOR FILL-IN c-cod-estabel-fim IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-estabel-ini IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-grp-aval-fim IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-grp-aval-ini IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-grp-resp-fim IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-grp-resp-ini IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo-fim IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo-ini IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-emitente-fim IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-emitente-ini IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-nr-controle-fim IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-nr-controle-ini IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    assign l-ok = no.
    apply "CLOSE":U to this-procedure.
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

    if  avail tt-filtro then do:

        assign tt-filtro.ano-ini                   = input frame fPage0 cb-ano-ini
               tt-filtro.ano-fim                   = input frame fPage0 cb-ano-fim
               tt-filtro.periodo-ini               = input frame fPage0 cb-periodo-ini
               tt-filtro.periodo-fim               = input frame fPage0 cb-periodo-fim
               tt-filtro.cod-estabel-ini           = input frame fPage0 c-cod-estabel-ini           
               tt-filtro.cod-estabel-fim           = input frame fPage0 c-cod-estabel-fim           
               tt-filtro.cod-emitente-ini          = input frame fPage0 i-cod-emitente-ini          
               tt-filtro.cod-emitente-fim          = input frame fPage0 i-cod-emitente-fim          
               tt-filtro.nr-controle-ini           = input frame fPage0 i-nr-controle-ini           
               tt-filtro.nr-controle-fim           = input frame fPage0 i-nr-controle-fim           
               tt-filtro.it-codigo-ini             = input frame fPage0 c-it-codigo-ini             
               tt-filtro.it-codigo-fim             = input frame fPage0 c-it-codigo-fim             
               tt-filtro.cod-grp-aval-ini          = input frame fPage0 c-cod-grp-aval-ini          
               tt-filtro.cod-grp-aval-fim          = input frame fPage0 c-cod-grp-aval-fim          
               tt-filtro.cod-grp-resp-ini          = input frame fPage0 c-cod-grp-resp-ini          
               tt-filtro.cod-grp-resp-fim          = input frame fPage0 c-cod-grp-resp-fim          
               tt-filtro.cod-gr-forn-ini           = input frame fPage0 i-cod-gr-forn-ini           
               tt-filtro.cod-gr-forn-fim           = input frame fPage0 i-cod-gr-forn-fim           
               tt-filtro.fm-codigo-ini             = input frame fPage0 c-fm-codigo-ini             
               tt-filtro.fm-codigo-fim             = input frame fPage0 c-fm-codigo-fim             
               tt-filtro.ge-codigo-ini             = input frame fPage0 i-ge-codigo-ini             
               tt-filtro.ge-codigo-fim             = input frame fPage0 i-ge-codigo-fim             
               tt-filtro.classif                   = input frame fPage0 i-classif                   
               tt-filtro.indice-nao-digitado       = input frame fPage0 l-indice-nao-digitado:checked       
               tt-filtro.indice-digitado-calculado = input frame fPage0 l-indice-digitado-calculado:checked 
               tt-filtro.indice-por-item           = input frame fPage0 l-indice-por-item:checked
               l-ok                                = yes.
    end.
    apply "CLOSE":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano-fim wWindow
ON VALUE-CHANGED OF cb-ano-fim IN FRAME fpage0
DO:
    {afbo/boaf016.i3 "INPUT FRAME fpage0 cb-ano-fim:SCREEN-VALUE" cb-periodo-fim fpage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano-ini wWindow
ON VALUE-CHANGED OF cb-ano-ini IN FRAME fpage0 /* Per¡odo */
DO:
    {afbo/boaf016.i3 "INPUT FRAME fpage0 cb-ano-ini:SCREEN-VALUE" cb-periodo-ini fpage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    find first tt-filtro no-error.
    if  avail tt-filtro then do with frame fPage0:
        /* Preenche os combo-box com os anos */

        {afbo/boaf016.i2 cb-ano-ini cb-ano-fim fpage0}

        assign cb-ano-ini:screen-value     = tt-filtro.ano-ini
               cb-ano-fim:screen-value     = tt-filtro.ano-fim.
       
        apply "value-changed" to cb-ano-ini.
        apply "value-changed" to cb-ano-fim.
       
      
        assign cb-periodo-ini:screen-value = tt-filtro.periodo-ini
               cb-periodo-fim:screen-value = tt-filtro.periodo-fim
               c-cod-estabel-ini           = tt-filtro.cod-estabel-ini
               c-cod-estabel-fim           = tt-filtro.cod-estabel-fim
               i-cod-emitente-ini          = tt-filtro.cod-emitente-ini
               i-cod-emitente-fim          = tt-filtro.cod-emitente-fim
               i-nr-controle-ini           = tt-filtro.nr-controle-ini
               i-nr-controle-fim           = tt-filtro.nr-controle-fim
               c-it-codigo-ini             = tt-filtro.it-codigo-ini
               c-it-codigo-fim             = tt-filtro.it-codigo-fim
               c-cod-grp-aval-ini          = tt-filtro.cod-grp-aval-ini
               c-cod-grp-aval-fim          = tt-filtro.cod-grp-aval-fim
               c-cod-grp-resp-ini          = tt-filtro.cod-grp-resp-ini
               c-cod-grp-resp-fim          = tt-filtro.cod-grp-resp-fim
               i-cod-gr-forn-ini           = tt-filtro.cod-gr-forn-ini
               i-cod-gr-forn-fim           = tt-filtro.cod-gr-forn-fim
               c-fm-codigo-ini             = tt-filtro.fm-codigo-ini
               c-fm-codigo-fim             = tt-filtro.fm-codigo-fim
               i-ge-codigo-ini             = tt-filtro.ge-codigo-ini
               i-ge-codigo-fim             = tt-filtro.ge-codigo-fim
               i-classif                   = tt-filtro.classif
               l-indice-nao-digitado       = tt-filtro.indice-nao-digitado
               l-indice-digitado-calculado = tt-filtro.indice-digitado-calculado
               l-indice-por-item           = tt-filtro.indice-por-item.

        disp {&displayed-objects}.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

