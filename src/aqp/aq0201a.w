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
{include/i-prgvrs.i AQ0201A 2.00.00.008 } /*** 010008 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aq0201a MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        aq0201a
&GLOBAL-DEFINE Version        2.00.00.008

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0widgets   fiDataIni fiDataIFim cb-item ~
fiCodEstabIni fiCodEstabFim fiCodRegiaoIni fiCodRegiaoFim fiCodRotaIni ~
fiCodRotaFim fiCodGrupoIni fiCodGrupoFim fiCodPtoColetaIni ~
fiCodPtoColetaFim fiCdnProdutIni fiCdnProdutFim cb-tipo-regra fiCodRegraIni ~
fiCodRegraFim fiCodExameIni fiCodExameFim fiCodCompIni fiCodCompFim ~
fiCodPropriedIni fiCodPropriedFim ~
IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 IMAGE-10 IMAGE-11 IMAGE-12 ~
IMAGE-13 IMAGE-14 IMAGE-15 IMAGE-16 IMAGE-17 IMAGE-18 IMAGE-19 IMAGE-20~
 IMAGE-21 IMAGE-22 IMAGE-23 IMAGE-24 IMAGE-25 IMAGE-26 btOk btCancel btHelp2 


{aqp/aqapi001.i} /* temp-tables */


/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-param.


/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-boin00983 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin627   AS HANDLE NO-UNDO.  /* item-estab-rural   */
DEFINE VARIABLE h-boin172na AS HANDLE NO-UNDO.  /* item              */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-3 IMAGE-5 IMAGE-6 RECT-4 ~
RECT-5 IMAGE-7 IMAGE-8 IMAGE-9 IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 ~
IMAGE-15 IMAGE-16 IMAGE-17 IMAGE-18 IMAGE-19 IMAGE-20 RECT-6 IMAGE-21 ~
IMAGE-22 IMAGE-23 IMAGE-24 IMAGE-25 IMAGE-26 fiDataIni fiDataIFim cb-item ~
fiDescItem fiCodEstabIni fiCodEstabFim fiCodRegiaoIni fiCodRegiaoFim ~
fiCodRotaIni fiCodRotaFim fiCodGrupoIni fiCodGrupoFim fiCdnProdutIni ~
fiCdnProdutFim fiCodPropriedIni fiCodPropriedFim fiCodPtoColetaIni ~
fiCodPtoColetaFim cb-tipo-regra fiCodRegraIni fiCodRegraFim fiCodExameIni ~
fiCodExameFim fiCodCompIni fiCodCompFim btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fiDataIni fiDataIFim cb-item fiDescItem ~
fiCodEstabIni fiCodEstabFim fiCodRegiaoIni fiCodRegiaoFim fiCodRotaIni ~
fiCodRotaFim fiCodGrupoIni fiCodGrupoFim fiCdnProdutIni fiCdnProdutFim ~
fiCodPropriedIni fiCodPropriedFim fiCodPtoColetaIni fiCodPtoColetaFim ~
cb-tipo-regra fiCodRegraIni fiCodRegraFim fiCodExameIni fiCodExameFim ~
fiCodCompIni fiCodCompFim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
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

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE cb-tipo-regra AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 5 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Preáo Base",1,
                     "Variaá∆o Qualidade",2,
                     "Variaá∆o Volume",3,
                     "Bìnus Fixo",4,
                     "Todos",5
     DROP-DOWN-LIST
     SIZE 16.72 BY 1 NO-UNDO.

DEFINE VARIABLE fiCdnProdutFim AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCdnProdutIni AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Produtor" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodCompFim AS INTEGER FORMAT ">>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodCompIni AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Comp" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodEstabFim AS CHARACTER FORMAT "X(5)":U 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodEstabIni AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodExameFim AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodExameIni AS INTEGER FORMAT ">>>>>9 ":U INITIAL 0 
     LABEL "Exame" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodGrupoFim AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodGrupoIni AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Grupo" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodPropriedFim AS CHARACTER FORMAT "X(16)":U INITIAL "0" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodPropriedIni AS CHARACTER FORMAT "X(16)":U INITIAL "0" 
     LABEL "Propriedade" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodPtoColetaFim AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodPtoColetaIni AS CHARACTER FORMAT "X(12)":U 
     LABEL "Pto. Coleta" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodRegiaoFim AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodRegiaoIni AS CHARACTER FORMAT "X(12)":U 
     LABEL "Regi∆o" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodRegraFim AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 24.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodRegraIni AS CHARACTER FORMAT "X(20)":U 
     LABEL "Regra" 
     VIEW-AS FILL-IN 
     SIZE 24.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodRotaFim AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodRotaIni AS CHARACTER FORMAT "X(12)":U 
     LABEL "Rota" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiDataIFim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14.14 BY .88 NO-UNDO.

DEFINE VARIABLE fiDataIni AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 13.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescItem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27.43 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
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

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 2.25.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 9.25.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 3.08.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 2.96.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 84 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiDataIni AT ROW 2.25 COL 23 COLON-ALIGNED NO-LABEL
     fiDataIFim AT ROW 2.25 COL 48.86 COLON-ALIGNED NO-LABEL
     cb-item AT ROW 5.08 COL 20.14 COLON-ALIGNED
     fiDescItem AT ROW 5.08 COL 38.29 COLON-ALIGNED NO-LABEL
     fiCodEstabIni AT ROW 6.08 COL 20.14 COLON-ALIGNED
     fiCodEstabFim AT ROW 6.13 COL 49.14 COLON-ALIGNED NO-LABEL
     fiCodRegiaoIni AT ROW 7.08 COL 20.14 COLON-ALIGNED
     fiCodRegiaoFim AT ROW 7.08 COL 49.14 COLON-ALIGNED NO-LABEL
     fiCodRotaIni AT ROW 8.08 COL 20.14 COLON-ALIGNED
     fiCodRotaFim AT ROW 8.08 COL 49.14 COLON-ALIGNED NO-LABEL
     fiCodGrupoIni AT ROW 9.08 COL 20.14 COLON-ALIGNED
     fiCodGrupoFim AT ROW 9.08 COL 49.14 COLON-ALIGNED NO-LABEL
     fiCdnProdutIni AT ROW 10.08 COL 20.14 COLON-ALIGNED
     fiCdnProdutFim AT ROW 10.08 COL 49.14 COLON-ALIGNED NO-LABEL
     fiCodPropriedIni AT ROW 11.08 COL 20.14 COLON-ALIGNED
     fiCodPropriedFim AT ROW 11.08 COL 49.14 COLON-ALIGNED NO-LABEL
     fiCodPtoColetaIni AT ROW 12.08 COL 20.14 COLON-ALIGNED
     fiCodPtoColetaFim AT ROW 12.08 COL 49.14 COLON-ALIGNED NO-LABEL
     cb-tipo-regra AT ROW 14.5 COL 20.29 COLON-ALIGNED
     fiCodRegraIni AT ROW 15.67 COL 12.14 COLON-ALIGNED
     fiCodRegraFim AT ROW 15.67 COL 49.29 COLON-ALIGNED NO-LABEL
     fiCodExameIni AT ROW 18.25 COL 20.14 COLON-ALIGNED
     fiCodExameFim AT ROW 18.25 COL 49.14 COLON-ALIGNED NO-LABEL
     fiCodCompIni AT ROW 19.29 COL 20.14 COLON-ALIGNED
     fiCodCompFim AT ROW 19.29 COL 49.14 COLON-ALIGNED NO-LABEL
     btOK AT ROW 21.08 COL 2
     btCancel AT ROW 21.08 COL 13
     btHelp2 AT ROW 21.13 COL 73
     "Regra" VIEW-AS TEXT
          SIZE 6 BY .67 AT ROW 13.71 COL 6
     "Vigància" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1.25 COL 5.72
     "Abrangància" VIEW-AS TEXT
          SIZE 12 BY .54 AT ROW 3.96 COL 6
     "Controle Qualidade" VIEW-AS TEXT
          SIZE 14 BY .67 AT ROW 17.42 COL 6
     rtToolBar AT ROW 20.88 COL 1
     RECT-3 AT ROW 1.5 COL 3
     IMAGE-5 AT ROW 2.25 COL 38.72
     IMAGE-6 AT ROW 2.25 COL 48
     RECT-4 AT ROW 4.25 COL 3
     RECT-5 AT ROW 14 COL 3
     IMAGE-7 AT ROW 6.13 COL 38.86
     IMAGE-8 AT ROW 6.13 COL 48.14
     IMAGE-9 AT ROW 7.08 COL 38.86
     IMAGE-10 AT ROW 7.08 COL 48.14
     IMAGE-11 AT ROW 8.08 COL 38.86
     IMAGE-12 AT ROW 8.08 COL 48.14
     IMAGE-13 AT ROW 9.08 COL 38.86
     IMAGE-14 AT ROW 9.08 COL 48.14
     IMAGE-15 AT ROW 10.08 COL 38.86
     IMAGE-16 AT ROW 10.08 COL 48.14
     IMAGE-17 AT ROW 11.08 COL 38.86
     IMAGE-18 AT ROW 11.08 COL 48.14
     IMAGE-19 AT ROW 15.67 COL 39
     IMAGE-20 AT ROW 15.67 COL 48.29
     RECT-6 AT ROW 17.71 COL 3
     IMAGE-21 AT ROW 18.25 COL 38.86
     IMAGE-22 AT ROW 18.25 COL 48.14
     IMAGE-23 AT ROW 19.29 COL 38.86
     IMAGE-24 AT ROW 19.29 COL 48.14
     IMAGE-25 AT ROW 12.08 COL 38.86
     IMAGE-26 AT ROW 12.08 COL 48.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 21.33
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
         HEIGHT             = 21.33
         WIDTH              = 83.29
         MAX-HEIGHT         = 38.63
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.63
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
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
ASSIGN 
       IMAGE-10:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-11:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-12:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-13:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-14:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-15:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-16:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-17:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-18:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-19:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-20:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-21:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-22:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-23:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-24:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-25:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-26:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-5:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-6:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-7:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-8:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-9:HIDDEN IN FRAME fpage0           = TRUE.

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
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN 'NOK'.
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
    RUN piAtualizaParams IN THIS-PROCEDURE.    
    IF RETURN-VALUE = "OK":U THEN DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN 'OK':U.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-item wWindow
ON VALUE-CHANGED OF cb-item IN FRAME fpage0 /* Item */
DO: 
    DEFINE VARIABLE pDescItem    AS CHARACTER NO-UNDO.

    RUN goToKey IN h-boin172na (INPUT SELF:SCREEN-VALUE IN FRAME fPage0) NO-ERROR.

    IF RETURN-VALUE = "OK":U THEN DO:
        RUN findDescItem IN h-boin00983 (INPUT SELF:SCREEN-VALUE IN FRAME fPage0, OUTPUT pDescItem) NO-ERROR. 
        ASSIGN fiDescItem:SCREEN-VALUE IN FRAME fPage0 = pDescItem.                                          
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tipo-regra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-regra wWindow
ON VALUE-CHANGED OF cb-tipo-regra IN FRAME fpage0 /* Tipo */
DO: 
    DEFINE VARIABLE l-habilita AS LOGICAL NO-UNDO.

    /* VAR. QUALIDADE OU TODOS */
    ASSIGN l-habilita = SELF:SCREEN-VALUE IN FRAME fPage0 = '2' OR SELF:SCREEN-VALUE IN FRAME fPage0 = '5'.

    ASSIGN fiCodExameIni:SENSITIVE IN FRAME fPage0 =  l-habilita
           fiCodExameFim:SENSITIVE IN FRAME fPage0 =  l-habilita 
           fiCodCompIni:SENSITIVE  IN FRAME fPage0 =  l-habilita 
           fiCodCompFim:SENSITIVE  IN FRAME fPage0 =  l-habilita.

    IF NOT l-habilita THEN DO: /* Var qualidade*/
        ASSIGN fiCodExameIni:SCREEN-VALUE IN FRAME fPage0 = '0':U
               fiCodExameFim:SCREEN-VALUE IN FRAME fPage0 = '999999':U
               fiCodCompIni:SCREEN-VALUE  IN FRAME fPage0 = '0':U
               fiCodCompFim:SCREEN-VALUE  IN FRAME fPage0 = '9999':U.
    END.
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


/*:T--- L¢gica para inicializaá∆o do programam ---*/
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
    /* Item */
    IF VALID-HANDLE (h-boin172na) THEN DO:
        DELETE PROCEDURE h-boin172na.
        ASSIGN h-boin172na = ?.
    END.

    /** item-estab-rural **/
    IF  VALID-HANDLE(h-boin00983) THEN DO:
        DELETE PROCEDURE h-boin00983.
        ASSIGN h-boin00983 = ?.
    END.

    /** usuar-mater **/
    IF  VALID-HANDLE(h-boin627) THEN DO:
        DELETE PROCEDURE h-boin627.
        ASSIGN h-boin627 = ?.
    END.

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
    DEFINE VARIABLE c-return AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-list   AS CHARACTER   NO-UNDO.

    RUN initializeDBOs IN THIS-PROCEDURE.
 
    RUN findUsuar_mater IN h-boin627 (INPUT c-seg-usuario, OUTPUT c-return).

    IF c-return = "" THEN DO:
        RUN getCharField IN h-boin627 (INPUT 'char-1', OUTPUT c-return).
         ASSIGN c-return = SUBSTR(c-return,16,5). /* estab usuar */
    END.

    RUN getListItems IN h-boin00983(INPUT c-return, OUTPUT c-list).

    IF c-list <> "" THEN DO:
        ASSIGN cb-item:LIST-ITEMS IN FRAME fPage0   = c-list
               cb-item:SCREEN-VALUE IN FRAME fPage0 = ENTRY (1,c-list).

        APPLY 'VALUE-CHANGED':U TO cb-item IN FRAME fPage0. 
    END.
        
    RUN piAtualizaCampos IN THIS-PROCEDURE.  
  
    APPLY 'VALUE-CHANGED':U TO cb-tipo-regra IN FRAME fPage0.
    APPLY 'VALUE-CHANGED':U TO cb-item       IN FRAME fPage0.
    
    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT VALID-HANDLE(h-boin00983) THEN
        RUN inbo/boin00983.p PERSISTENT SET h-boin00983.

    RUN openQueryStatic IN h-boin00983(INPUT 'Main':U).

    /* item */ 
    IF NOT VALID-HANDLE( h-boin172na) THEN 
        RUN inbo/boin172na.p PERSISTENT SET h-boin172na.

    RUN OpenQueryStatic IN h-boin172na (INPUT "Main":U) NO-ERROR.

    /** usuar-mater **/
    IF NOT VALID-HANDLE(h-boin627) THEN
        RUN inbo/boin627.p PERSISTENT SET h-boin627.

    RUN openquery IN h-boin627(INPUT 1) NO-ERROR.


   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaCampos wWindow 
PROCEDURE piAtualizaCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST tt-param NO-ERROR.
    IF AVAIL tt-param THEN DO:
        ASSIGN fiDataIni:SCREEN-VALUE         IN FRAME fPage0 = STRING(tt-param.da-dat-ini)
               fiDataIFim:SCREEN-VALUE        IN FRAME fPage0 = STRING(tt-param.da-dat-fim)
               fiCodEstabIni:SCREEN-VALUE     IN FRAME fPage0 = tt-param.cod-estabel-ini
               fiCodEstabFim:SCREEN-VALUE     IN FRAME fPage0 = tt-param.cod-estabel-fim
               fiCodRegiaoIni:SCREEN-VALUE    IN FRAME fPage0 = tt-param.cod-regiao-ini
               fiCodRegiaoFim:SCREEN-VALUE    IN FRAME fPage0 = tt-param.cod-regiao-fim
               fiCodRotaIni:SCREEN-VALUE      IN FRAME fPage0 = tt-param.cod-rota-ini
               fiCodRotaFim:SCREEN-VALUE      IN FRAME fPage0 = tt-param.cod-rota-fim
               fiCodGrupoIni:SCREEN-VALUE     IN FRAME fPage0 = STRING(tt-param.cdn-grp-produt-ini)
               fiCodGrupoFim:SCREEN-VALUE     IN FRAME fPage0 = STRING(tt-param.cdn-grp-produt-fim)
               fiCdnProdutIni:SCREEN-VALUE    IN FRAME fPage0 = STRING(tt-param.cdn-produt-rural-ini)
               fiCdnProdutFim:SCREEN-VALUE    IN FRAME fPage0 = STRING(tt-param.cdn-produt-rural-fim)
               fiCodPtoColetaIni:SCREEN-VALUE IN FRAME fPage0 = tt-param.cod-pto-coleta-ini
               fiCodPtoColetaFim:SCREEN-VALUE IN FRAME fPage0 = tt-param.cod-pto-coleta-fim
               cb-tipo-regra:SCREEN-VALUE     IN FRAME fPage0 = STRING(tt-param.cdn-tipo)
               fiCodRegraIni:SCREEN-VALUE     IN FRAME fPage0 = tt-param.cod-regra-ini
               fiCodRegraFim:SCREEN-VALUE     IN FRAME fPage0 = tt-param.cod-regra-fim
               fiCodExameIni:SCREEN-VALUE     IN FRAME fPage0 = STRING(tt-param.cod-exame-ini)
               fiCodExameFim:SCREEN-VALUE     IN FRAME fPage0 = STRING(tt-param.cod-exame-fim)
               fiCodCompIni:SCREEN-VALUE      IN FRAME fPage0 = STRING(tt-param.cod-comp-ini)
               fiCodCompFim:SCREEN-VALUE      IN FRAME fPage0 = STRING(tt-param.cod-comp-fim)
               fiCodPropriedIni:SCREEN-VALUE  IN FRAME fPage0 = tt-param.cod-propried-ini
               fiCodPropriedFim:SCREEN-VALUE  IN FRAME fPage0 = tt-param.cod-propried-fim.

        IF tt-param.it-codigo <> "" THEN 
            ASSIGN cb-item:SCREEN-VALUE IN FRAME fPage0 = tt-param.it-codigo.
               
    END.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaParams wWindow 
PROCEDURE piAtualizaParams :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF INPUT FRAME fPage0 fiDataIFim        <  INPUT FRAME fPage0 fiDataIni         OR
       INPUT FRAME fPage0 fiCodEstabFim     <  INPUT FRAME fPage0 fiCodEstabIni     OR
       INPUT FRAME fPage0 fiCodRegiaoFim    <  INPUT FRAME fPage0 fiCodRegiaoIni    OR
       INPUT FRAME fPage0 fiCodRotaFim      <  INPUT FRAME fPage0 fiCodRotaIni      OR
       INPUT FRAME fPage0 fiCodGrupoFim     <  INPUT FRAME fPage0 fiCodGrupoIni     OR
       INPUT FRAME fPage0 fiCdnProdutFim    <  INPUT FRAME fPage0 fiCdnProdutini    OR
       INPUT FRAME fPage0 fiCodPtoColetaFim <  INPUT FRAME fPage0 fiCodPtoColetaIni OR
       INPUT FRAME fPage0 fiCodRegraFim     <  INPUT FRAME fPage0 fiCodRegraini     OR
       INPUT FRAME fPage0 fiCodExameFim     <  INPUT FRAME fPage0 fiCodExameIni     OR
       INPUT FRAME fPage0 fiCodCompFim      <  INPUT FRAME fPage0 fiCodCompIni      OR
       INPUT FRAME fPage0 fiCodPropriedFim  <  INPUT FRAME fPage0 fiCodPropriedIni  THEN DO:
        RUN utp/ut-msgs.p(INPUT 'SHOW',
                          INPUT 51730,
                          INPUT ' ').
        RETURN "NOK":U.
    END.
    
    ASSIGN tt-param.da-dat-ini           = INPUT FRAME fPage0 fiDataIni
           tt-param.da-dat-fim           = INPUT FRAME fPage0 fiDataIFim
           tt-param.it-codigo            = INPUT FRAME fPage0 cb-item
           tt-param.cod-estabel-ini      = INPUT FRAME fPage0 fiCodEstabIni
           tt-param.cod-estabel-fim      = INPUT FRAME fPage0 fiCodEstabFim
           tt-param.cod-regiao-ini       = INPUT FRAME fPage0 fiCodRegiaoIni
           tt-param.cod-regiao-fim       = INPUT FRAME fPage0 fiCodRegiaoFim
           tt-param.cod-rota-ini         = INPUT FRAME fPage0 fiCodRotaIni
           tt-param.cod-rota-fim         = INPUT FRAME fPage0 fiCodRotaFim
           tt-param.cdn-grp-produt-ini   = INPUT FRAME fPage0 fiCodGrupoIni
           tt-param.cdn-grp-produt-fim   = INPUT FRAME fPage0 fiCodGrupoFim
           tt-param.cdn-produt-rural-ini = INPUT FRAME fPage0 fiCdnProdutIni
           tt-param.cdn-produt-rural-fim = INPUT FRAME fPage0 fiCdnProdutFim
           tt-param.cod-pto-coleta-ini   = INPUT FRAME fPage0 fiCodPtoColetaIni
           tt-param.cod-pto-coleta-fim   = INPUT FRAME fPage0 fiCodPtoColetaFim
           tt-param.cdn-tipo             = INPUT FRAME fPage0 cb-tipo-regra
           tt-param.cod-regra-ini        = INPUT FRAME fPage0 fiCodRegraIni
           tt-param.cod-regra-fim        = INPUT FRAME fPage0 fiCodRegraFim
           tt-param.cod-exame-ini        = INPUT FRAME fPage0 fiCodExameIni
           tt-param.cod-exame-fim        = INPUT FRAME fPage0 fiCodExameFim
           tt-param.cod-comp-ini         = INPUT FRAME fPage0 fiCodCompIni
           tt-param.cod-comp-fim         = INPUT FRAME fPage0 fiCodCompFim
           tt-param.cod-propried-ini     = INPUT FRAME fPage0 fiCodPropriedIni
           tt-param.cod-propried-fim     = INPUT FRAME fPage0 fiCodPropriedFim.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

