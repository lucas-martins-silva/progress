&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
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
{include/i-prgvrs.i AQ0204B 2.00.00.003 } /*** 010003 ***/
/********************************************************************************
/*
 * Copyright (c) 2011, TOTVS S/A. Todos os direitos reservados.
 * 
 * Os Programas desta Aplicaá∆o (que incluem tanto o software quanto a sua
 * documentaá∆o) contÇm informaá‰es propriet†rias da TOTVS S/A; eles s∆o
 * licenciados de acordo com um contrato de licenÁa contendo restriÁıes de uso e
 * confidencialidade, e s∆o tambÇm protegidos pela Lei 9609/98 e 9610/98,
 * respectivamente Lei do Software e Lei dos Direitos Autorais. Engenharia
 * reversa, descompilaá∆o e desmontagem dos programas s∆o proibidos. Nenhuma
 * parte destes programas pode ser reproduzida ou transmitida de nenhuma forma e
 * por nenhum meio, eletrìnico ou mecÉnico, por motivo algum, sem a permiss∆o
 * escrita da TOTVS S/A.
 */
*******************************************************************************/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0204B MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AQ0204B
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE WindowType     Detail



&GLOBAL-DEFINE page0Widgets   c-cod-pto-coleta-ini c-cod-pto-coleta-fim ~
                              c-desc-pto-coleta-ini c-desc-pto-coleta-fim ~
                              i-cod-regiao-ini i-cod-regiao-fim ~
                              btHelp btOK btCancel 

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAM p-cod-pto-coleta-ini  LIKE pto-coleta.cod-pto-coleta  NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-cod-pto-coleta-fim  LIKE pto-coleta.cod-pto-coleta  NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-desc-pto-coleta-ini LIKE pto-coleta.des-pto-coleta  NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-desc-pto-coleta-fim LIKE pto-coleta.des-pto-coleta  NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-cod-regiao-ini      LIKE regiao-abrangen.cod-regiao NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-cod-regiao-fim      LIKE regiao-abrangen.cod-regiao NO-UNDO.

DEFINE VARIABLE wh-pesquisa    AS HANDLE      NO-UNDO.
/* Local Variable Definitions (DBOs Handles) --- */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
{cdp/cdcfgmat.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-cod-pto-coleta-ini c-cod-pto-coleta-fim ~
c-desc-pto-coleta-ini c-desc-pto-coleta-fim btOK btCancel btHelp ~
i-cod-regiao-ini i-cod-regiao-fim IMAGE-10 IMAGE-3 IMAGE-4 IMAGE-9 ~
rtToolBar IMAGE-11 IMAGE-12 
&Scoped-Define DISPLAYED-OBJECTS c-cod-pto-coleta-ini c-cod-pto-coleta-fim ~
c-desc-pto-coleta-ini c-desc-pto-coleta-fim i-cod-regiao-ini ~
i-cod-regiao-fim 

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

DEFINE BUTTON btHelp 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-pto-coleta-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-pto-coleta-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "C¢digo Pto Coleta" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-pto-coleta-fim AS CHARACTER FORMAT "X(40)" INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-pto-coleta-ini AS CHARACTER FORMAT "X(40)" 
     LABEL "Descriá∆o":R15 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-regiao-fim AS CHARACTER FORMAT "x(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-regiao-ini LIKE regiao-abrangen.cod-regiao
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 78 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-cod-pto-coleta-ini AT ROW 3.25 COL 14.86 COLON-ALIGNED HELP
          "Produtor Rural"
     c-cod-pto-coleta-fim AT ROW 3.25 COL 46.57 COLON-ALIGNED NO-LABEL
     c-desc-pto-coleta-ini AT ROW 4.25 COL 14.86 COLON-ALIGNED
     c-desc-pto-coleta-fim AT ROW 4.25 COL 46.57 COLON-ALIGNED NO-LABEL
     btOK AT ROW 9.25 COL 2
     btCancel AT ROW 9.25 COL 13
     btHelp AT ROW 9.25 COL 68.29
     i-cod-regiao-ini AT ROW 5.25 COL 14.86 COLON-ALIGNED HELP
          "C¢digo Regi∆o" WIDGET-ID 4
     i-cod-regiao-fim AT ROW 5.25 COL 46.72 COLON-ALIGNED HELP
          "C¢digo Regi∆o" NO-LABEL WIDGET-ID 2
     IMAGE-10 AT ROW 4.25 COL 44.72
     IMAGE-3 AT ROW 3.25 COL 38.29
     IMAGE-4 AT ROW 3.25 COL 44.72
     IMAGE-9 AT ROW 4.25 COL 38.14
     rtToolBar AT ROW 9 COL 1
     IMAGE-11 AT ROW 5.25 COL 38.14 WIDGET-ID 6
     IMAGE-12 AT ROW 5.25 COL 44.57 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 78.57 BY 9.54
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 9.58
         WIDTH              = 78.14
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN i-cod-regiao-ini IN FRAME fpage0
   LIKE = mgind.regiao-abrangen.cod-regiao EXP-SIZE                     */
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
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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
   ASSIGN p-cod-pto-coleta-ini  = INPUT FRAME fPage0 c-cod-pto-coleta-ini 
          p-cod-pto-coleta-fim  = INPUT FRAME fPage0 c-cod-pto-coleta-fim
          p-desc-pto-coleta-ini = INPUT FRAME fPage0 c-desc-pto-coleta-ini  
          p-desc-pto-coleta-fim = INPUT FRAME fPage0 c-desc-pto-coleta-fim
          p-cod-regiao-ini      = INPUT FRAME fPage0 i-cod-regiao-ini 
          p-cod-regiao-fim      = INPUT FRAME fPage0 i-cod-regiao-fim.
   
   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-pto-coleta-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-pto-coleta-fim wWindow
ON F5 OF c-cod-pto-coleta-fim IN FRAME fpage0
DO:
  {method/ZoomFields.i
         &ProgramZoom="inzoom/z01in00966.w"
         &FieldZoom1="cod-pto-coleta"
         &FieldScreen1="c-cod-pto-coleta-fim"
         &Frame1="fPage0"
         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-pto-coleta-fim wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-pto-coleta-fim IN FRAME fpage0
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-pto-coleta-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-pto-coleta-ini wWindow
ON F5 OF c-cod-pto-coleta-ini IN FRAME fpage0 /* C¢digo Pto Coleta */
DO:
  {method/ZoomFields.i
         &ProgramZoom="inzoom/z01in00966.w"
         &FieldZoom1="cod-pto-coleta"
         &FieldScreen1="c-cod-pto-coleta-ini"
         &Frame1="fPage0"
         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-pto-coleta-ini wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-pto-coleta-ini IN FRAME fpage0 /* C¢digo Pto Coleta */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-regiao-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-regiao-fim wWindow
ON F5 OF i-cod-regiao-fim IN FRAME fpage0
DO:
    {method/ZoomFields.i
         &ProgramZoom="inzoom/z01in00977.w"
         &FieldZoom1="cod-regiao"
         &FieldScreen1="i-cod-regiao-fim"
         &Frame1="fPage0"
         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-regiao-fim wWindow
ON MOUSE-SELECT-DBLCLICK OF i-cod-regiao-fim IN FRAME fpage0
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-regiao-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-regiao-ini wWindow
ON F5 OF i-cod-regiao-ini IN FRAME fpage0 /* Regi∆o */
DO:

    {method/ZoomFields.i
         &ProgramZoom="inzoom/z01in00977.w"
         &FieldZoom1="cod-regiao"
         &FieldScreen1="i-cod-regiao-ini"
         &Frame1="fPage0"
         &EnableImplant="NO"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-regiao-ini wWindow
ON MOUSE-SELECT-DBLCLICK OF i-cod-regiao-ini IN FRAME fpage0 /* Regi∆o */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose: Atualizaá∆o de dados de campos em tela    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   c-cod-pto-coleta-ini:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
   c-cod-pto-coleta-fim:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
   i-cod-regiao-ini:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
   i-cod-regiao-fim:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
   
   ASSIGN c-cod-pto-coleta-ini = p-cod-pto-coleta-ini
          c-cod-pto-coleta-fim = p-cod-pto-coleta-fim 
          c-desc-pto-coleta-ini   = p-desc-pto-coleta-ini  
          c-desc-pto-coleta-fim   = p-desc-pto-coleta-fim
          i-cod-regiao-ini = p-cod-regiao-ini
          i-cod-regiao-fim = p-cod-regiao-fim .

   DISP c-cod-pto-coleta-ini
        c-cod-pto-coleta-fim
        c-desc-pto-coleta-ini  
        c-desc-pto-coleta-fim
        i-cod-regiao-ini
        i-cod-regiao-fim
       WITH FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

