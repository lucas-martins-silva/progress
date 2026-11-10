&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0410AA 2.00.00.002 } /*** 010002 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0410AA MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0410AA
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
define input  parameter p-numero-ordem like ordem-compra.numero-ordem     no-undo.
define input  parameter p-it-codigo    like item.it-codigo                no-undo.
define input  parameter p-quantidade   like prazo-compra.quantidade       no-undo.
define input  parameter p-un-nossa     like item.un                       no-undo.
define input  parameter p-quantidade-fornec like prazo-compra.qtd-do-forn no-undo.
define input  parameter p-un-fornec    like cotacao-item.un               no-undo.
define input  parameter phCaller       as   handle                        no-undo.
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
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar btQueryJoins ~
btReportsJoins btExit btHelp de-quantidade btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS i-numero-ordem c-it-codigo de-quantidade ~
c-un-nossa de-quantidade-fornec c-un-fornec 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-fornec AS CHARACTER FORMAT "X(2)":U 
     LABEL "Un Fornec" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-nossa AS CHARACTER FORMAT "X(2)":U 
     LABEL "Un" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-quantidade AS DECIMAL FORMAT ">>>>>,>>9.9999":U INITIAL 0 
     LABEL "Nossa Qtde" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-quantidade-fornec AS DECIMAL FORMAT "->>>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtde Fornec" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-numero-ordem AS INTEGER FORMAT ">>>>>9,99":U INITIAL 0 
     LABEL "Ordem" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     i-numero-ordem AT ROW 2.75 COL 32 COLON-ALIGNED WIDGET-ID 12
     c-it-codigo AT ROW 3.75 COL 32 COLON-ALIGNED WIDGET-ID 2
     de-quantidade AT ROW 4.75 COL 32 COLON-ALIGNED WIDGET-ID 8
     c-un-nossa AT ROW 4.75 COL 53.86 COLON-ALIGNED WIDGET-ID 6
     de-quantidade-fornec AT ROW 5.75 COL 32 COLON-ALIGNED WIDGET-ID 10
     c-un-fornec AT ROW 5.75 COL 53.86 COLON-ALIGNED WIDGET-ID 4
     btOK AT ROW 7.21 COL 2
     btCancel AT ROW 7.21 COL 13
     btHelp2 AT ROW 7.21 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 7 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 7.71
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 7.75
         WIDTH              = 90
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
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
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-fornec IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-nossa IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-quantidade-fornec IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-numero-ordem IN FRAME fpage0
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
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
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
    ASSIGN INPUT FRAME fPage0 de-quantidade.

    RUN setaQuantidadeEmbarque IN phCaller (INPUT INPUT FRAME fPage0 de-quantidade).

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-quantidade wWindow
ON LEAVE OF de-quantidade IN FRAME fpage0 /* Nossa Qtde */
DO:
  FOR FIRST ordem-compra fields(cod-emitente) 
      WHERE ordem-compra.numero-ordem = int(i-numero-ordem:SCREEN-VALUE IN FRAME fPage0) NO-LOCK: END.

  IF AVAIL ordem-compra THEN DO:
      FIND FIRST item-fornec WHERE item-fornec.it-codigo    = c-it-codigo:SCREEN-VALUE IN FRAME fPage0
                             AND   item-fornec.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.  
      IF AVAIL item-fornec THEN DO:
          ASSIGN de-quantidade-fornec:SCREEN-VALUE IN FRAME fPage0 = 
                                                     string(int(de-quantidade:SCREEN-VALUE IN FRAME fPage0)
                                                                * (item-fornec.fator-conver /
                                                                IF item-fornec.num-casa-dec = 0 THEN 1
                                                                    ELSE EXP(10, item-fornec.num-casa-dec))).
      END.
      ELSE
          ASSIGN de-quantidade-fornec:SCREEN-VALUE IN FRAME fPage0 = de-quantidade:SCREEN-VALUE IN FRAME fPage0.
  END.
  ELSE
      ASSIGN de-quantidade-fornec:SCREEN-VALUE IN FRAME fPage0 = de-quantidade:SCREEN-VALUE IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
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
    assign i-numero-ordem       = p-numero-ordem
           c-it-codigo          = p-it-codigo
           de-quantidade        = p-quantidade
           c-un-nossa           = p-un-nossa
           de-quantidade-fornec = p-quantidade-fornec
           c-un-fornec          = p-un-fornec.
           
    display i-numero-ordem
            c-it-codigo
            de-quantidade
            c-un-nossa
            de-quantidade-fornec
            c-un-fornec
            with frame fPage0. 

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

