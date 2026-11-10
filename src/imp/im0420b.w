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
{include/i-prgvrs.i IM0420B 2.00.00.004 } /*** 010004 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0420B MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0420B
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   c-cod-embarq-fim c-cod-embarq-ini c-cod-estab-fim c-cod-estab-ini c-nr-proc-imp-fim c-nr-proc-imp-ini i-numero-ordem-fim i-numero-ordem-ini i-num-pedido-fim i-num-pedido-ini
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAM l-di-informada AS LOGICAL  NO-UNDO.
DEFINE INPUT PARAM phCaller       AS HANDLE   NO-UNDO.

DEFINE VARIABLE cEstab LIKE estabelec.cod-estabel.
/* Local Variable Definitions ---                                       */
/*DEFINI€ÇO DA tt-param*/
{imp/im0420.i tt-param}

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
btReportsJoins btExit btHelp btOK btCancel btHelp2 

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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE c-cod-embarq-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-cod-embarq-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-cod-estab-fim AS CHARACTER FORMAT "x(5)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-cod-estab-ini AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-nr-proc-imp-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-nr-proc-imp-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "Processo Importa‡Æo":R23 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE i-num-pedido-fim AS INTEGER FORMAT ">>>>>,>>9" INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE i-num-pedido-ini AS INTEGER FORMAT ">>>>>,>>9" INITIAL 0 
     LABEL "Pedido":R8 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE i-numero-ordem-fim AS INTEGER FORMAT "zzzzz9,99" INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE i-numero-ordem-ini AS INTEGER FORMAT "zzzzz9,99" INITIAL 0 
     LABEL "Ordem":R7 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.


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
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     c-cod-estab-ini AT ROW 2.75 COL 22 HELP
          "C¢digo do estabelecimento."
     c-cod-estab-fim AT ROW 2.75 COL 52.72 HELP
          "C¢digo do estabelecimento." NO-LABEL
     c-cod-embarq-ini AT ROW 3.67 COL 17.28 HELP
          "C¢digo Embarque"
     c-cod-embarq-fim AT ROW 3.67 COL 52.72 HELP
          "C¢digo Embarque" NO-LABEL
     i-num-pedido-ini AT ROW 4.58 COL 25.57 HELP
          "N£mero do Pedido de Compra"
     i-num-pedido-fim AT ROW 4.58 COL 52.72 HELP
          "N£mero do Pedido de Compra" NO-LABEL
     i-numero-ordem-ini AT ROW 5.5 COL 25.86
     i-numero-ordem-fim AT ROW 5.5 COL 52.72 NO-LABEL
     c-nr-proc-imp-ini AT ROW 6.46 COL 10.14
     c-nr-proc-imp-fim AT ROW 6.46 COL 52.72 NO-LABEL
     IMAGE-1 AT ROW 2.75 COL 42.29
     IMAGE-2 AT ROW 2.75 COL 49.57
     IMAGE-3 AT ROW 3.67 COL 42.29
     IMAGE-4 AT ROW 3.67 COL 49.57
     IMAGE-7 AT ROW 4.58 COL 42.29
     IMAGE-8 AT ROW 4.58 COL 49.57
     IMAGE-9 AT ROW 5.5 COL 42.29
     IMAGE-10 AT ROW 5.5 COL 49.57
     IMAGE-11 AT ROW 6.46 COL 42.29
     IMAGE-12 AT ROW 6.46 COL 49.57
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1.


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
         HEIGHT             = 17
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-embarq-fim IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-cod-embarq-ini IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-cod-estab-fim IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-cod-estab-ini IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-nr-proc-imp-fim IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-nr-proc-imp-ini IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN i-num-pedido-fim IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN i-num-pedido-ini IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN i-numero-ordem-fim IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN i-numero-ordem-ini IN FRAME fPage1
   ALIGN-L                                                              */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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
    RUN cria-tt-param.
    RUN executa-parametros-busca IN phCaller (INPUT TABLE tt-param).
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
IF l-di-informada THEN DO:
    RUN getEstabelecimentoDi IN phCaller (OUTPUT cEstab).

    ASSIGN c-cod-estab-ini = cEstab
           c-cod-estab-fim = cEstab.

    DISP c-cod-estab-ini
         c-cod-estab-fim WITH FRAME fPage1.

    DISABLE c-cod-estab-ini
            c-cod-estab-fim WITH FRAME fPage1.

    EMPTY TEMP-TABLE tt-param.

    RUN get-tt-param-exec IN phCaller (OUTPUT TABLE tt-param).

    FIND FIRST tt-param NO-LOCK NO-ERROR.

    IF AVAIL tt-param THEN DO:

        ASSIGN c-cod-embarq-ini   = tt-param.cdn-embarq-ini  
               c-cod-embarq-fim   = tt-param.cdn-embarq-fim  
               i-num-pedido-ini   = tt-param.num-pedido-ini  
               i-num-pedido-fim   = tt-param.num-pedido-fim  
               i-numero-ordem-ini = tt-param.numero-ordem-ini
               i-numero-ordem-fim = tt-param.numero-ordem-fim
               c-nr-proc-imp-ini  = tt-param.nr-proc-ini     
               c-nr-proc-imp-fim  = tt-param.nr-proc-fim.

        DISP c-cod-embarq-ini  
             c-cod-embarq-fim  
             i-num-pedido-ini  
             i-num-pedido-fim  
             i-numero-ordem-ini
             i-numero-ordem-fim
             c-nr-proc-imp-ini 
             c-nr-proc-imp-fim WITH FRAME fPage1.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cria-tt-param wWindow 
PROCEDURE cria-tt-param :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH tt-param:
    DELETE tt-param.
END.

IF NOT CAN-FIND(FIRST tt-param) THEN
    CREATE tt-param.

FOR FIRST tt-param:
    ASSIGN tt-param.cod-estab-ini      = INPUT FRAME fPage1 c-cod-estab-ini     
           tt-param.cod-estab-fim      = INPUT FRAME fPage1 c-cod-estab-fim     
           tt-param.cdn-embarq-ini     = INPUT FRAME fPage1 c-cod-embarq-ini    
           tt-param.cdn-embarq-fim     = INPUT FRAME fPage1 c-cod-embarq-fim    
           tt-param.num-pedido-ini     = INPUT FRAME fPage1 i-num-pedido-ini    
           tt-param.num-pedido-fim     = INPUT FRAME fPage1 i-num-pedido-fim    
           tt-param.numero-ordem-ini   = INPUT FRAME fPage1 i-numero-ordem-ini  
           tt-param.numero-ordem-fim   = INPUT FRAME fPage1 i-numero-ordem-fim  
           tt-param.nr-proc-ini        = INPUT FRAME fPage1 c-nr-proc-imp-ini       
           tt-param.nr-proc-fim        = INPUT FRAME fPage1 c-nr-proc-imp-fim.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

