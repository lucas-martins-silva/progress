&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-preco-frete-coleta NO-UNDO LIKE preco-frete-coleta
       FIELD r-rowid AS rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0212B 2.00.00.007 } /*** 010007 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0212b MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AQ0212b
&GLOBAL-DEFINE Version        2.00.00.007

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0widgets  fi-dat-inic-vigenc ~
                             fi-dat-fim-vigenc ~
                             fi-cod-estabel ~
                             fi-cod-rota ~
                             tg-todos-rota ~
                             fi-cod-transp ~
                             tg-todos-transp ~
                             fi-cdn-tip-veic ~
                             tg-todos-tip-veic ~
                             cb-item ~
                             tg-todos-item ~
                             fi-val-unit-frete-km ~
                             fi-val-unit-frete-quant ~
                             fi-val-fix-frete ~
                             fi-val-unit-bonus-km ~
                             fi-val-unit-bonus-pto-col
DEFINE INPUT-OUTPUT PARAMETER pr-row-id AS ROWID     NO-UNDO.
DEFINE INPUT        PARAMETER pc-action AS CHARACTER NO-UNDO.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.


DEFINE VARIABLE h-boad107na AS HANDLE NO-UNDO. /* estabel            */
DEFINE VARIABLE h-boin00975 AS HANDLE NO-UNDO. /* rota-coleta        */
DEFINE VARIABLE h-boin00983 AS HANDLE NO-UNDO. /* item-estab-rural   */
DEFINE VARIABLE h-boin00996 AS HANDLE NO-UNDO. /* preco-frete-coleta */
DEFINE VARIABLE h-boin627zm AS HANDLE NO-UNDO. /* usuar-mater        */






{cdp/cd0031.i} /* seguranáa por estabelecimento */
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-3 RECT-4 RECT-5 RECT-6 ~
fi-dat-inic-vigenc fi-dat-fim-vigenc fi-cod-estabel fi-nome fi-cod-rota ~
fi-desc-rota tg-todos-rota fi-cod-transp fi-nome-transp tg-todos-transp ~
fi-cdn-tip-veic fi-des-tip-veic tg-todos-tip-veic cb-item fi-desc-item ~
tg-todos-item fi-val-unit-frete-km fi-val-unit-bonus-km ~
fi-val-unit-frete-quant fi-val-unit-bonus-pto-col fi-val-fix-frete btOK ~
btSave btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-dat-inic-vigenc fi-dat-fim-vigenc ~
fi-cod-estabel fi-nome fi-cod-rota fi-desc-rota tg-todos-rota fi-cod-transp ~
fi-nome-transp tg-todos-transp fi-cdn-tip-veic fi-des-tip-veic ~
tg-todos-tip-veic cb-item fi-desc-item tg-todos-item fi-val-unit-frete-km ~
fi-val-unit-bonus-km fi-val-unit-frete-quant fi-val-unit-bonus-pto-col ~
fi-val-fix-frete 

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

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE fi-cdn-tip-veic AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Tipo Ve°culo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-rota AS CHARACTER FORMAT "X(12)":U 
     LABEL "Rota" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-transp AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Transportador" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dat-fim-vigenc AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Fim" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dat-inic-vigenc AS DATE FORMAT "99/99/9999":U 
     LABEL "Data In°cio" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-tip-veic AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-rota AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-transp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE fi-val-fix-frete AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Preáo Fixo" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-val-unit-bonus-km AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Bìnus Unit Km" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-val-unit-bonus-pto-col AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Bìnus Unit Pto Coleta" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-val-unit-frete-km AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Preáo Unit Km" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-val-unit-frete-quant AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Preáo Unit Qtde" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 2.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 6.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 3.75.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 3.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 84 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-todos-item AS LOGICAL INITIAL no 
     LABEL "Todos" 
     VIEW-AS TOGGLE-BOX
     SIZE 7 BY .83 NO-UNDO.

DEFINE VARIABLE tg-todos-rota AS LOGICAL INITIAL no 
     LABEL "Todas" 
     VIEW-AS TOGGLE-BOX
     SIZE 7 BY .83 NO-UNDO.

DEFINE VARIABLE tg-todos-tip-veic AS LOGICAL INITIAL no 
     LABEL "Todos" 
     VIEW-AS TOGGLE-BOX
     SIZE 7 BY .83 NO-UNDO.

DEFINE VARIABLE tg-todos-transp AS LOGICAL INITIAL no 
     LABEL "Todos" 
     VIEW-AS TOGGLE-BOX
     SIZE 7 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-dat-inic-vigenc AT ROW 2 COL 25 COLON-ALIGNED
     fi-dat-fim-vigenc AT ROW 2 COL 45.29 COLON-ALIGNED
     fi-cod-estabel AT ROW 4.79 COL 14 COLON-ALIGNED
     fi-nome AT ROW 4.79 COL 22 COLON-ALIGNED NO-LABEL
     fi-cod-rota AT ROW 5.75 COL 14 COLON-ALIGNED
     fi-desc-rota AT ROW 5.75 COL 26 COLON-ALIGNED NO-LABEL
     tg-todos-rota AT ROW 5.79 COL 74.29
     fi-cod-transp AT ROW 6.75 COL 14 COLON-ALIGNED
     fi-nome-transp AT ROW 6.75 COL 26 COLON-ALIGNED NO-LABEL
     tg-todos-transp AT ROW 6.79 COL 74.29
     fi-cdn-tip-veic AT ROW 7.75 COL 14 COLON-ALIGNED
     fi-des-tip-veic AT ROW 7.75 COL 19 COLON-ALIGNED NO-LABEL
     tg-todos-tip-veic AT ROW 7.79 COL 74.29
     cb-item AT ROW 8.71 COL 14.14 COLON-ALIGNED WIDGET-ID 8
     fi-desc-item AT ROW 8.71 COL 32.43 COLON-ALIGNED NO-LABEL
     tg-todos-item AT ROW 8.75 COL 74.29
     fi-val-unit-frete-km AT ROW 10.71 COL 16.86 COLON-ALIGNED
     fi-val-unit-bonus-km AT ROW 11.04 COL 60.72 COLON-ALIGNED
     fi-val-unit-frete-quant AT ROW 11.71 COL 16.86 COLON-ALIGNED
     fi-val-unit-bonus-pto-col AT ROW 12.04 COL 60.72 COLON-ALIGNED
     fi-val-fix-frete AT ROW 12.71 COL 16.86 COLON-ALIGNED
     btOK AT ROW 14.33 COL 2
     btSave AT ROW 14.33 COL 13
     btCancel AT ROW 14.33 COL 24
     btHelp2 AT ROW 14.38 COL 73
     "Bìnus" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 10 COL 43
     "Preáos" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 10 COL 6
     "Abrangància" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 3.75 COL 6
     "Vigància" VIEW-AS TEXT
          SIZE 6.29 BY .54 AT ROW 1.25 COL 5.72
     rtToolBar AT ROW 14.13 COL 1
     RECT-3 AT ROW 1.5 COL 2
     RECT-4 AT ROW 4 COL 2
     RECT-5 AT ROW 10.25 COL 2
     RECT-6 AT ROW 10.25 COL 42 WIDGET-ID 6
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
   Temp-Tables and Buffers:
      TABLE: tt-preco-frete-coleta T "?" NO-UNDO mgcad preco-frete-coleta
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS rowid
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
         HEIGHT             = 14.75
         WIDTH              = 83
         MAX-HEIGHT         = 38.63
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.63
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
         RESIZE             = no
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
  NOT-VISIBLE,                                                          */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
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
    IF pc-action = "ADD":U THEN
        RUN pi-create-record IN THIS-PROCEDURE.
    ELSE IF pc-action = "UPDATE":U THEN
        RUN pi-update-record IN THIS-PROCEDURE.
    ELSE 
        RUN pi-copy-record IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK" THEN DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN "OK":U.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wWindow
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    IF pc-action = "ADD":U THEN
        RUN pi-create-record IN THIS-PROCEDURE.
    ELSE IF pc-action = "COPY":U THEN
        RUN pi-copy-record IN THIS-PROCEDURE.

    IF RETURN-VALUE = "OK" THEN
        RUN pi-limpa-campos IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-item wWindow
ON VALUE-CHANGED OF cb-item IN FRAME fpage0 /* Item */
DO: 
    DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.
    
    IF VALID-HANDLE(h-boin00983) THEN DO:
       RUN findDescItem IN h-boin00983(INPUT SELF:SCREEN-VALUE, OUTPUT c-desc-item).

       ASSIGN fi-desc-item:SCREEN-VALUE IN FRAME fPage0 = c-desc-item.
    END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cdn-tip-veic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-tip-veic wWindow
ON LEAVE OF fi-cdn-tip-veic IN FRAME fpage0 /* Tipo Ve°culo */
OR 'ENTRY':U OF fi-cdn-tip-veic DO:
    IF INPUT FRAME {&FRAME-NAME} fi-cdn-tip-veic > 0 THEN DO:
        {include/leave.i &tabela=tip-veic-transp
                     &atributo-ref=des-tip-veic
                     &variavel-ref=fi-des-tip-veic
                     &where="tip-veic-transp.cdn-tip-veic = INPUT FRAME {&frame-name} fi-cdn-tip-veic"}
    END.
    ELSE
        ASSIGN fi-des-tip-veic:SCREEN-VALUE IN FRAME fPage0 = "":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-tip-veic wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cdn-tip-veic IN FRAME fpage0 /* Tipo Ve°culo */
OR 'F5' OF fi-cdn-tip-veic DO:
    {method/zoomfields.i 
         &ProgramZoom="adzoom/z01ad00509.w"
         &FieldZoom1="cdn-tip-veic"
         &FieldScreen1="fi-cdn-tip-veic"
         &Frame1="fPage0"
         &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wWindow
ON LEAVE OF fi-cod-estabel IN FRAME fpage0 /* Estabelecimento */
OR "ENTRY" OF fi-cod-estabel DO:
   {method/ReferenceFields.i &HandleDBOLeave="h-boad107na"
                             &KeyValue1="SELF:SCREEN-VALUE"
                             &FieldName1="nome"
                             &FieldScreen1="fi-nome"
                             &Frame1="fPage0"}
                             
    RUN pi-carrega-cb-item IN THIS-PROCEDURE(INPUT SELF:SCREEN-VALUE).                             
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estabel IN FRAME fpage0 /* Estabelecimento */
OR 'F5' OF fi-cod-estabel DO:
    ASSIGN l-implanta = NO.
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=fi-cod-estabel
                       &campozoom=cod-estabel
                       &campo2=fi-nome
                       &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-rota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-rota wWindow
ON LEAVE OF fi-cod-rota IN FRAME fpage0 /* Rota */
OR "ENTRY" OF fi-cod-rota DO:
    {method/ReferenceFields.i 
          &HandleDBOLeave="h-boin00975"
          &KeyValue1="SELF:SCREEN-VALUE"
          &FieldName1="des-rota"
          &FieldScreen1="fi-desc-rota"
          &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-rota wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-rota IN FRAME fpage0 /* Rota */
OR 'F5' OF fi-cod-rota DO:
     {method/zoomfields.i 
           &ProgramZoom="inzoom/z01in00975.w"
           &FieldZoom1="cod-rota"
           &FieldScreen1="fi-cod-rota"
           &Frame1="fPage0"
           &FieldZoom2="des-rota"
           &FieldScreen2="fi-desc-rota"
           &Frame2="fPage0"
           &EnableImplant="YES"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-transp wWindow
ON ENTRY OF fi-cod-transp IN FRAME fpage0 /* Transportador */
DO:
  APPLY 'LEAVE' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-transp wWindow
ON LEAVE OF fi-cod-transp IN FRAME fpage0 /* Transportador */
OR "ENTRY" OF fi-cod-transp DO:
    IF INPUT FRAME {&FRAME-NAME} fi-cod-transp > 0 THEN DO:
        {include/leave.i &tabela=transporte
                         &atributo-ref=nome
                         &variavel-ref=fi-nome-transp
                         &where="transporte.cod-transp = INPUT FRAME {&frame-name} fi-cod-transp"}
    END.
    ELSE
        ASSIGN fi-nome-transp:SCREEN-VALUE IN FRAME fPage0 = "":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-transp wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-transp IN FRAME fpage0 /* Transportador */
OR 'F5':U OF fi-cod-transp DO:
 {method/zoomfields.i &ProgramZoom="adzoom/z02ad268.w"
                       &FieldZoom1="cod-transp"
                       &FieldScreen1="fi-cod-transp"
                       &Frame1="fPage0"
                       &FieldZoom1="nome"
                       &EnableImplant="YES"}
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


&Scoped-define SELF-NAME tg-todos-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-todos-item wWindow
ON VALUE-CHANGED OF tg-todos-item IN FRAME fpage0 /* Todos */
DO:
    ASSIGN cb-item:SENSITIVE IN FRAME fPage0 = NOT SELF:CHECKED.

    IF SELF:CHECKED THEN 
        ASSIGN cb-item:SCREEN-VALUE IN FRAME fPage0 = "*":U.
    ELSE 
        ASSIGN cb-item:SCREEN-VALUE IN FRAME fPage0 = "":U.

    APPLY "VALUE-CHANGED":U TO cb-item IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-todos-rota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-todos-rota wWindow
ON VALUE-CHANGED OF tg-todos-rota IN FRAME fpage0 /* Todas */
DO:
    ASSIGN fi-cod-rota:SENSITIVE IN FRAME fPage0 = NOT SELF:CHECKED.
    
    IF SELF:CHECKED THEN 
        ASSIGN fi-cod-rota:SCREEN-VALUE IN FRAME fPage0 = "*":U.
    ELSE 
        ASSIGN fi-cod-rota:SCREEN-VALUE IN FRAME fPage0 = "":U.
    
    APPLY "LEAVE" TO fi-cod-rota IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-todos-tip-veic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-todos-tip-veic wWindow
ON VALUE-CHANGED OF tg-todos-tip-veic IN FRAME fpage0 /* Todos */
DO:
    ASSIGN fi-cdn-tip-veic:SENSITIVE IN FRAME fPage0 = NOT SELF:CHECKED
           fi-cdn-tip-veic:SCREEN-VALUE IN FRAME fPage0 = "0":U.
    
    APPLY "LEAVE":U TO fi-cdn-tip-veic IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-todos-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-todos-transp wWindow
ON VALUE-CHANGED OF tg-todos-transp IN FRAME fpage0 /* Todos */
DO:
    ASSIGN fi-cod-transp:SENSITIVE IN FRAME fPage0 = NOT SELF:CHECKED
           fi-cod-transp:SCREEN-VALUE IN FRAME fPage0 = "0":U.
              
    APPLY "LEAVE":U TO fi-cod-transp IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
fi-cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPage0.
fi-cod-rota:LOAD-MOUSE-POINTER("image/lupa.cur":U)     IN FRAME fPage0.
fi-cod-transp:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage0.
fi-cdn-tip-veic:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

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
    IF VALID-HANDLE(h-boad107na) THEN DO:
        DELETE PROCEDURE h-boad107na.
        ASSIGN h-boad107na = ?.
    END.

    /* rota-coleta   */ 
    IF VALID-HANDLE (h-boin00975) THEN DO: 
        DELETE PROCEDURE h-boin00975 .
        ASSIGN  h-boin00975 = ?.
    END.

    /* item-estab-rural   */ 
    IF VALID-HANDLE (h-boin00983) THEN DO: 
        DELETE PROCEDURE h-boin00983 .
        ASSIGN  h-boin00983= ?.
    END.

    /* preco-frete-coleta   */ 
    IF VALID-HANDLE (h-boin00996) THEN DO: 
        DELETE PROCEDURE h-boin00996 .
        ASSIGN  h-boin00996 = ?.
    END.

    /*usuar-mater*/
    IF VALID-HANDLE (h-boin627zm) THEN DO: 
        DELETE PROCEDURE h-boin627zm .
        ASSIGN h-boin627zm = ?.
    END.   

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
    DEFINE VARIABLE c-char-1 AS CHARACTER NO-UNDO.

    RUN initializeDBOs IN THIS-PROCEDURE.         

    /* Para update ou copia busca temp-table e atualiza campos da tela */
    IF pc-action = "UPDATE":U OR  pc-action = "COPY":U THEN DO: 
        RUN pi-get-record      IN THIS-PROCEDURE.
        RUN pi-atualiza-campos IN THIS-PROCEDURE.

    END.
    ELSE DO:
        IF VALID-HANDLE(h-boin627zm) THEN DO:
            RUN goTokey IN h-boin627zm(INPUT c-seg-usuario).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField IN h-boin627zm(INPUT "char-1":U, OUTPUT c-char-1).
                ASSIGN fi-cod-estabel:SCREEN-VALUE IN FRAME fPage0 = SUBSTRING(c-char-1,16,5).
                APPLY "LEAVE":U TO fi-cod-estabel IN FRAME fPage0.
            END.
        END.

        RUN pi-carrega-cb-item IN THIS-PROCEDURE(INPUT  SUBSTRING(c-char-1,16,5)).

    END.

    ENABLE btOk
           btCancel
           btSave
           btHelp2
           WITH FRAME fPage0.

    IF pc-action = "UPDATE":U THEN DO:
        DISABLE btSave 
                WITH FRAME fPage0.
    END.

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
    /* estabelec */
    IF NOT VALID-HANDLE(h-boad107na) THEN
        RUN adbo/boad107na.p PERSISTENT SET h-boad107na.

    RUN openQueryStatic IN h-boad107na(INPUT "Main":U).

    /* rota-coleta   */ 
    IF NOT VALID-HANDLE(h-boin00975) THEN 
        RUN inbo/boin00975.p PERSISTENT SET h-boin00975.

    RUN OpenQueryStatic IN h-boin00975 (INPUT "Main":U) NO-ERROR.

    /* item-estab-rural   */ 
    IF NOT VALID-HANDLE(h-boin00983) THEN 
        RUN inbo/boin00983.p PERSISTENT SET h-boin00983.

    RUN OpenQueryStatic IN h-boin00983 (INPUT "Main":U) NO-ERROR.

    /* preco-frete-coleta   */ 
    IF NOT VALID-HANDLE(h-boin00996) THEN 
        RUN inbo/boin00996.p PERSISTENT SET h-boin00996.

    RUN OpenQueryStatic IN h-boin00996 (INPUT "Main":U) NO-ERROR.

    /*usuar-mater*/
    IF NOT VALID-HANDLE(h-boin627zm) THEN 
        RUN inbo/boin627zm.p PERSISTENT SET h-boin627zm.

    RUN OpenQueryStatic IN h-boin627zm (INPUT "Default":U) NO-ERROR.
   


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-campos wWindow 
PROCEDURE pi-atualiza-campos :
/*------------------------------------------------------------------------------
  Purpose: Atualizacao dos campos de tela com base no registro j· criado
  Parameters:  <none>
  Notes: Executado para update ou copy      
------------------------------------------------------------------------------*/
    FOR FIRST tt-preco-frete-coleta:   
        ASSIGN fi-dat-inic-vigenc        = tt-preco-frete-coleta.dat-inic-vigenc        
               fi-dat-fim-vigenc         = tt-preco-frete-coleta.dat-fim-vigenc      
               fi-cod-estabel            = tt-preco-frete-coleta.cod-estabel         
               fi-cod-rota               = tt-preco-frete-coleta.cod-rota
               fi-cod-transp             = tt-preco-frete-coleta.cod-transp
               fi-cdn-tip-veic           = tt-preco-frete-coleta.cdn-tip-veic
               fi-val-unit-frete-km      = tt-preco-frete-coleta.val-unit-frete-km
               fi-val-unit-frete-quant   = tt-preco-frete-coleta.val-unit-frete-quant
               fi-val-fix-frete          = tt-preco-frete-coleta.val-fix-frete
               fi-val-unit-bonus-km      = tt-preco-frete-coleta.val-unit-bonus-km   
               fi-val-unit-bonus-pto-col = tt-preco-frete-coleta.val-unit-bonus-pto-col.      

        DISPLAY fi-dat-inic-vigenc
                fi-dat-fim-vigenc
                fi-cod-estabel
                fi-cod-rota
                tg-todos-rota
                fi-cod-transp
                tg-todos-transp
                fi-cdn-tip-veic
                tg-todos-tip-veic
                tg-todos-item
                fi-val-unit-frete-km
                fi-val-unit-frete-quant
                fi-val-fix-frete 
                fi-val-unit-bonus-km         
                fi-val-unit-bonus-pto-col
                WITH FRAME fPage0.

        APPLY 'LEAVE':U TO fi-cod-estabel IN FRAME fPage0.

        IF tt-preco-frete-coleta.cod-rota = "*":U THEN DO:
            ASSIGN tg-todos-rota:CHECKED             IN FRAME fPage0 = YES.
            APPLY 'VALUE-CHANGED':U TO tg-todos-rota IN FRAME fPage0.
        END.
        ELSE 
            APPLY 'LEAVE':U TO fi-cod-rota IN FRAME fPage0.

        IF tt-preco-frete-coleta.cod-transp = 0 THEN DO:
            ASSIGN tg-todos-transp:CHECKED             IN FRAME fPage0 = YES.
            APPLY 'VALUE-CHANGED':U TO tg-todos-transp IN FRAME fPage0.
        END.
        ELSE 
            APPLY 'LEAVE':U TO fi-cod-transp IN FRAME fPage0.

        IF tt-preco-frete-coleta.cdn-tip-veic = 0 THEN DO:
            ASSIGN tg-todos-tip-veic:CHECKED             IN FRAME fPage0 = YES.
            APPLY 'VALUE-CHANGED':U TO tg-todos-tip-veic IN FRAME fPage0.
        END.
        ELSE 
            APPLY 'LEAVE':U TO fi-cdn-tip-veic  IN FRAME fPage0.

        RUN pi-carrega-cb-item IN THIS-PROCEDURE(INPUT  tt-preco-frete-coleta.cod-estabel).
        
        ASSIGN cb-item:SCREEN-VALUE IN FRAME fPage0 = tt-preco-frete-coleta.it-codigo.

        IF tt-preco-frete-coleta.it-codigo = "*":U THEN DO:
            ASSIGN tg-todos-item:CHECKED             IN FRAME fPage0 = YES.
            APPLY 'VALUE-CHANGED':U TO tg-todos-item IN FRAME fPage0.
        END.
        ELSE 
            APPLY 'VALUE-CHANGED':U TO cb-item IN FRAME fPage0.
    END.                                                                                             
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-cb-item wWindow 
PROCEDURE pi-carrega-cb-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-list AS CHARACTER NO-UNDO.

    IF VALID-HANDLE(h-boin00983) THEN DO:
        RUN getListItemPairs IN h-boin00983(INPUT pc-cod-estabel, OUTPUT c-list).

        IF c-list <> "," THEN
            ASSIGN c-list = "*,*," + c-list.

        ASSIGN cb-item:LIST-ITEM-PAIRS IN FRAME fPage0 = c-list
               cb-item:SCREEN-VALUE    IN FRAME fPage0 = ENTRY (1,c-list).

        APPLY 'VALUE-CHANGED':U TO cb-item IN FRAME fPage0. 
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-copy-record wWindow 
PROCEDURE pi-copy-record :
/*------------------------------------------------------------------------------
  Purpose: Copiar registros com base na regra selecionada na tela aq0212    
  Parameters:  <none>
  Notes: Comportamento desta procedure n∆o impactado pelo bot∆o salvar desta tela.      
------------------------------------------------------------------------------*/
    RUN pi-tt-preco-frete-coleta IN THIS-PROCEDURE.

    IF VALID-HANDLE(h-boin00996) THEN DO:
        EMPTY TEMP-TABLE RowErrors NO-ERROR.
        RUN emptyRowErrors IN h-boin00996.
        RUN setRecord IN h-boin00996(INPUT TABLE tt-preco-frete-coleta). 
        RUN createRecord IN h-boin00996.
        IF RETURN-VALUE = "NOK":U THEN DO:
            /** Retorna a temp-table rowErrors com os erros da transa? o **/
            RUN getRowErrors IN h-boin00996 (OUTPUT TABLE RowErrors).
            IF CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:                
                /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="Yes"}
                {method/showmessage.i3}
                RETURN "NOK":U.
            END.
        END.
        ELSE 
            RUN getRowid IN h-boin00996(OUTPUT pr-row-id).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-create-record wWindow 
PROCEDURE pi-create-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN pi-tt-preco-frete-coleta IN THIS-PROCEDURE.

    IF VALID-HANDLE(h-boin00996) THEN DO:
        EMPTY TEMP-TABLE RowErrors NO-ERROR.
        RUN emptyRowErrors IN h-boin00996.
        RUN setRecord IN h-boin00996(INPUT TABLE tt-preco-frete-coleta). 
        RUN createRecord IN h-boin00996.
        IF RETURN-VALUE = "NOK":U THEN DO:
            /** Retorna a temp-table rowErrors com os erros da transa? o **/
            RUN getRowErrors IN h-boin00996 (OUTPUT TABLE RowErrors).
            IF CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:               
                /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="Yes"}
                {method/showmessage.i3}
                RETURN "NOK":U.
            END.
        END.
        ELSE 
            RUN getRowid IN h-boin00996(OUTPUT pr-row-id).
    END.  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-get-record wWindow 
PROCEDURE pi-get-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-preco-frete-coleta NO-ERROR.
    IF VALID-HANDLE(h-boin00996) THEN DO:
        RUN repositionRecord IN h-boin00996(INPUT pr-row-id).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getRecord IN h-boin00996(OUTPUT TABLE tt-preco-frete-coleta). 
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-campos wWindow 
PROCEDURE pi-limpa-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN fi-dat-inic-vigenc        = ?
           fi-dat-fim-vigenc         = ?
           fi-cod-estabel            = "":U
           fi-cod-rota               = "":U
           fi-cod-transp             = 0
           fi-cdn-tip-veic           = 0
           cb-item                   = "":U
           fi-val-unit-frete-km      = 0
           fi-val-unit-frete-quant   = 0
           fi-val-fix-frete          = 0
           fi-val-unit-bonus-km      = 0
           fi-val-unit-bonus-pto-col = 0.

    ASSIGN tg-todos-rota:CHECKED     IN FRAME fPage0 = NO
           tg-todos-transp:CHECKED   IN FRAME fPage0 = NO
           tg-todos-tip-veic:CHECKED IN FRAME fPage0 = NO
           tg-todos-item:CHECKED     IN FRAME fPage0 = NO
           fi-cod-estabel:SENSITIVE  IN FRAME fPage0 = YES
           fi-cod-rota:SENSITIVE     IN FRAME fPage0 = YES
           fi-cod-transp:SENSITIVE   IN FRAME fPage0 = YES
           fi-cdn-tip-veic:SENSITIVE IN FRAME fPage0 = YES
           cb-item:SENSITIVE        IN FRAME fPage0 = YES.

    DISPLAY fi-dat-inic-vigenc
            fi-dat-fim-vigenc
            fi-cod-estabel
            fi-cod-rota
            tg-todos-rota
            fi-cod-transp
            tg-todos-transp
            fi-cdn-tip-veic
            tg-todos-tip-veic
            cb-item
            tg-todos-item
            fi-val-unit-frete-km
            fi-val-unit-frete-quant
            fi-val-fix-frete
            fi-val-unit-bonus-km      
            fi-val-unit-bonus-pto-col
            WITH FRAME fPage0.

    APPLY 'LEAVE':U         TO fi-cod-estabel     IN FRAME fPage0.
    APPLY 'LEAVE':U         TO fi-cod-rota        IN FRAME fPage0.
    APPLY 'LEAVE':U         TO fi-cod-transp      IN FRAME fPage0.
    APPLY 'LEAVE':U         TO fi-cdn-tip-veic    IN FRAME fPage0.
    APPLY 'VALUE-CHANGED':U TO cb-item            IN FRAME fPage0.
    APPLY 'ENTRY':U         TO fi-dat-inic-vigenc IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-tt-preco-frete-coleta wWindow 
PROCEDURE pi-tt-preco-frete-coleta :
/*------------------------------------------------------------------------------
  Purpose: POPULAR TEMP TABLE PARA CRIAÄ«O DO REGISTRO    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF pc-action = "ADD":U THEN DO:
        EMPTY TEMP-TABLE tt-preco-frete-coleta NO-ERROR.
        CREATE tt-preco-frete-coleta. 
    END.

    ASSIGN tt-preco-frete-coleta.dat-inic-vigenc        = INPUT FRAME fPage0 fi-dat-inic-vigenc
           tt-preco-frete-coleta.dat-fim-vigenc         = INPUT FRAME fPage0 fi-dat-fim-vigenc
           tt-preco-frete-coleta.cod-estabel            = INPUT FRAME fPage0 fi-cod-estabel
           tt-preco-frete-coleta.cod-rota               = INPUT FRAME fPage0 fi-cod-rota
           tt-preco-frete-coleta.cod-transp             = INPUT FRAME fPage0 fi-cod-transp
           tt-preco-frete-coleta.cdn-tip-veic           = INPUT FRAME fPage0 fi-cdn-tip-veic
           tt-preco-frete-coleta.it-codigo              = INPUT FRAME fPage0 cb-item
           tt-preco-frete-coleta.val-unit-frete-km      = INPUT FRAME fPage0 fi-val-unit-frete-km
           tt-preco-frete-coleta.val-unit-frete-quant   = INPUT FRAME fPage0 fi-val-unit-frete-quant
           tt-preco-frete-coleta.val-fix-frete          = INPUT FRAME fPage0 fi-val-fix-frete 
           tt-preco-frete-coleta.val-unit-bonus-km      = INPUT FRAME fPage0 fi-val-unit-bonus-km
           tt-preco-frete-coleta.val-unit-bonus-pto-col = INPUT FRAME fPage0 fi-val-unit-bonus-pto-col.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-update-record wWindow 
PROCEDURE pi-update-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN pi-tt-preco-frete-coleta IN THIS-PROCEDURE.

    IF VALID-HANDLE(h-boin00996) THEN DO:
        EMPTY TEMP-TABLE RowErrors NO-ERROR.
        RUN emptyRowErrors IN h-boin00996.
        RUN setRecord IN h-boin00996(INPUT TABLE tt-preco-frete-coleta). 
        RUN updateRecord IN h-boin00996.
        IF RETURN-VALUE = "NOK":U THEN DO:
            /** Retorna a temp-table rowErrors com os erros da transa? o **/
            RUN getRowErrors IN h-boin00996 (OUTPUT TABLE RowErrors).
            IF CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:              
                /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="Yes"}
                {method/showmessage.i3}
                RETURN "NOK":U.
            END.
        END.
        ELSE 
            RUN getRowid IN h-boin00996(OUTPUT pr-row-id).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

