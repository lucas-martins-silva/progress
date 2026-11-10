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
{include/i-prgvrs.i AQ0205B 2.00.00.003 } /*** 010003 ***/
/********************************************************************************
/*
 * Copyright (c) 2011, TOTVS S/A. Todos os direitos reservados.
 * 
 * Os Programas desta Aplica‡Æo (que incluem tanto o software quanto a sua
 * documenta‡Æo) cont‚m informa‡äes propriet rias da TOTVS S/A; eles sÆo
 * licenciados de acordo com um contrato de licença contendo restrições de uso e
 * confidencialidade, e sÆo tamb‚m protegidos pela Lei 9609/98 e 9610/98,
 * respectivamente Lei do Software e Lei dos Direitos Autorais. Engenharia
 * reversa, descompila‡Æo e desmontagem dos programas sÆo proibidos. Nenhuma
 * parte destes programas pode ser reproduzida ou transmitida de nenhuma forma e
 * por nenhum meio, eletr“nico ou mecƒnico, por motivo algum, sem a permissÆo
 * escrita da TOTVS S/A.
 */
*******************************************************************************/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0205B MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AQ0205B
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE page0Widgets   i-cod-produt-rural-ini i-cod-produt-rural-fim ~
                              i-cod-grp-produt-ini i-cod-grp-produt-fim ~
                              btHelp btOK btCancel 

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAM p-cod-produt-rural-ini LIKE produt-rural.cdn-produt-rural NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-cod-produt-rural-fim LIKE produt-rural.cdn-produt-rural NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-cod-grp-produt-ini   LIKE grp-produt.cdn-grp-produt     NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-cod-grp-produt-fim   LIKE grp-produt.cdn-grp-produt     NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS i-cod-produt-rural-ini ~
i-cod-produt-rural-fim i-cod-grp-produt-ini i-cod-grp-produt-fim btOK ~
btCancel btHelp IMAGE-10 IMAGE-3 IMAGE-4 IMAGE-9 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS i-cod-produt-rural-ini ~
i-cod-produt-rural-fim i-cod-grp-produt-ini i-cod-grp-produt-fim 

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

DEFINE VARIABLE i-cod-grp-produt-fim AS INTEGER FORMAT ">>>>>9" INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-grp-produt-ini AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Grupo Produtor":R15 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-produt-rural-fim AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-produt-rural-ini AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "C¢digo Produtor Rural" 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
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
     i-cod-produt-rural-ini AT ROW 3.25 COL 21 COLON-ALIGNED HELP
          "Produtor Rural"
     i-cod-produt-rural-fim AT ROW 3.25 COL 46.57 COLON-ALIGNED NO-LABEL
     i-cod-grp-produt-ini AT ROW 4.25 COL 21 COLON-ALIGNED
     i-cod-grp-produt-fim AT ROW 4.25 COL 46.57 COLON-ALIGNED NO-LABEL
     btOK AT ROW 9.25 COL 2
     btCancel AT ROW 9.25 COL 13
     btHelp AT ROW 9.25 COL 68.29
     IMAGE-10 AT ROW 4.25 COL 44.72
     IMAGE-3 AT ROW 3.25 COL 38.29
     IMAGE-4 AT ROW 3.25 COL 44.72
     IMAGE-9 AT ROW 4.25 COL 38.14
     rtToolBar AT ROW 9 COL 1
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
   ASSIGN p-cod-produt-rural-ini = INPUT FRAME fPage0 i-cod-produt-rural-ini 
          p-cod-produt-rural-fim = INPUT FRAME fPage0 i-cod-produt-rural-fim
          p-cod-grp-produt-ini   = INPUT FRAME fPage0 i-cod-grp-produt-ini  
          p-cod-grp-produt-fim   = INPUT FRAME fPage0 i-cod-grp-produt-fim.
   
   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-grp-produt-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-grp-produt-fim wWindow
ON F5 OF i-cod-grp-produt-fim IN FRAME fpage0
DO:
  {method/ZoomFields.i
         &ProgramZoom="inzoom/z01in00963.w"
         &FieldZoom1="cdn-grp-produt"
         &FieldScreen1="i-cod-grp-produt-fim"
         &Frame1="fPage0"
         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-grp-produt-fim wWindow
ON MOUSE-SELECT-DBLCLICK OF i-cod-grp-produt-fim IN FRAME fpage0
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-grp-produt-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-grp-produt-ini wWindow
ON F5 OF i-cod-grp-produt-ini IN FRAME fpage0 /* Grupo Produtor */
DO:
  {method/ZoomFields.i
         &ProgramZoom="inzoom/z01in00963.w"
         &FieldZoom1="cdn-grp-produt"
         &FieldScreen1="i-cod-grp-produt-ini"
         &Frame1="fPage0"
         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-grp-produt-ini wWindow
ON MOUSE-SELECT-DBLCLICK OF i-cod-grp-produt-ini IN FRAME fpage0 /* Grupo Produtor */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-produt-rural-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-produt-rural-fim wWindow
ON F5 OF i-cod-produt-rural-fim IN FRAME fpage0
DO:
    {method/ZoomFields.i
         &ProgramZoom="inzoom/z01in00962.w"
         &FieldZoom1="cdn-produt-rural"
         &FieldScreen1="i-cod-produt-rural-fim"
         &Frame1="fPage0"
         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-produt-rural-fim wWindow
ON MOUSE-SELECT-DBLCLICK OF i-cod-produt-rural-fim IN FRAME fpage0
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-produt-rural-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-produt-rural-ini wWindow
ON F5 OF i-cod-produt-rural-ini IN FRAME fpage0 /* C¢digo Produtor Rural */
DO:

    {method/ZoomFields.i
         &ProgramZoom="inzoom/z01in00962.w"
         &FieldZoom1="cdn-produt-rural"
         &FieldScreen1="i-cod-produt-rural-ini"
         &Frame1="fPage0"
         &EnableImplant="NO"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-produt-rural-ini wWindow
ON MOUSE-SELECT-DBLCLICK OF i-cod-produt-rural-ini IN FRAME fpage0 /* C¢digo Produtor Rural */
DO:
  APPLY "f5" TO SELF.
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
  Purpose: Atualiza‡Æo de dados de campos em tela    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   i-cod-produt-rural-ini:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
   i-cod-produt-rural-fim:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
   i-cod-grp-produt-ini:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
   i-cod-grp-produt-fim:load-mouse-pointer ("image/lupa.cur")  in frame fPage0. 
    
   ASSIGN i-cod-produt-rural-ini = p-cod-produt-rural-ini
          i-cod-produt-rural-fim = p-cod-produt-rural-fim 
          i-cod-grp-produt-ini   = p-cod-grp-produt-ini  
          i-cod-grp-produt-fim   = p-cod-grp-produt-fim.

   DISP i-cod-produt-rural-ini
        i-cod-produt-rural-fim
        i-cod-grp-produt-ini  
        i-cod-grp-produt-fim  
       WITH FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

