&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttaf-item-contr-estab-aux NO-UNDO LIKE af-item-contr-estab
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0111B 2.00.00.002 } /*** 010002 ***/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program       AF0111b
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btSalvar btCancel btHelp2 

{utp/ut-glob.i}

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttAf-Item-Contr-Estab-Aux.
DEFINE INPUT PARAMETER h-caller AS HANDLE NO-UNDO.

/*--- Vari†veis definidas para que se possa utilizar o zoom 
      feito em Smart Objects ---*/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
/*-----------------------------------------------------------------*/

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-boaf001    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf006    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf023    AS HANDLE NO-UNDO.

DEFINE VARIABLE cDescEstab     LIKE estabelec.nome NO-UNDO.
DEFINE VARIABLE cDesItem       LIKE item.desc-item NO-UNDO.
DEFINE VARIABLE cNomeEmite     LIKE emitente.nome-emit NO-UNDO.
DEFINE VARIABLE c-cod-grp-aval LIKE af-item-contr-estab.cod-grp-avaliacao NO-UNDO.
DEFINE VARIABLE cDescriVersao  LIKE af-versao-avaliacao.desc-versao       NO-UNDO.

DEFINE VARIABLE wh-pop-menu  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-item1     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-item2     AS WIDGET-HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttaf-item-contr-estab-aux.cod-estabel ~
ttaf-item-contr-estab-aux.it-codigo ttaf-item-contr-estab-aux.cod-emitente ~
ttaf-item-contr-estab-aux.nr-versao 
&Scoped-define ENABLED-TABLES ttaf-item-contr-estab-aux
&Scoped-define FIRST-ENABLED-TABLE ttaf-item-contr-estab-aux
&Scoped-Define ENABLED-OBJECTS RECT-30 rtToolBar cNomeEstab cDescItem ~
cNomeEmitente cDescVersao btOK BtSalvar btCancel btHelp2 
&Scoped-Define DISPLAYED-FIELDS ttaf-item-contr-estab-aux.cod-estabel ~
ttaf-item-contr-estab-aux.it-codigo ttaf-item-contr-estab-aux.cod-emitente ~
ttaf-item-contr-estab-aux.nr-versao 
&Scoped-define DISPLAYED-TABLES ttaf-item-contr-estab-aux
&Scoped-define FIRST-DISPLAYED-TABLE ttaf-item-contr-estab-aux
&Scoped-Define DISPLAYED-OBJECTS cNomeEstab cDescItem cNomeEmitente ~
cDescVersao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-cod-emitente 
       MENU-ITEM mZoomFornecedor LABEL "Zoom de Fornecedor"
       MENU-ITEM mZoomFornecedorEstabItem LABEL "Zoom de Estab/Item/Fornecedor/Vers∆o".

DEFINE MENU POPUP-MENU-cod-estabel 
       MENU-ITEM mZoomEstab     LABEL "Zoom de Estabelecimento"
       MENU-ITEM mZoomEstabItemFornecedor LABEL "Zoom de Estab/Item/Fornecedor/Vers∆o".

DEFINE MENU POPUP-MENU-it-codigo 
       MENU-ITEM mZoomItem      LABEL "Zoom de Item"  
       MENU-ITEM mZoomItemFornecedorEstab LABEL "Zoom de Estab/Item/Fornecedor/Vers∆o".

DEFINE MENU POPUP-MENU-nr-versao 
       MENU-ITEM mZoomVersao    LABEL "Zoom de Vers∆o"
       MENU-ITEM mZoomVersaoEstabItemFornecedor LABEL "Zoom de Estab/Item/Fornecedor/Vers∆o".


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

DEFINE BUTTON BtSalvar 
     LABEL "&Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE cDescItem AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE cDescVersao AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 66.14 BY .88 NO-UNDO.

DEFINE VARIABLE cNomeEmitente AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 63 BY .88 NO-UNDO.

DEFINE VARIABLE cNomeEstab AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 68 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 92 BY 4.71.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 92 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttaf-item-contr-estab-aux.cod-estabel AT ROW 1.5 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cNomeEstab AT ROW 1.5 COL 21 COLON-ALIGNED HELP
          "Descric∆o do Estabelecimento" NO-LABEL
     ttaf-item-contr-estab-aux.it-codigo AT ROW 2.5 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     cDescItem AT ROW 2.5 COL 34 COLON-ALIGNED HELP
          "Descricao do Item" NO-LABEL
     ttaf-item-contr-estab-aux.cod-emitente AT ROW 3.5 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     cNomeEmitente AT ROW 3.5 COL 26 COLON-ALIGNED HELP
          "Descriá∆o do Fornecedor" NO-LABEL
     ttaf-item-contr-estab-aux.nr-versao AT ROW 4.5 COL 13 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     cDescVersao AT ROW 4.5 COL 22.86 COLON-ALIGNED HELP
          "Descriá∆o do Fornecedor" NO-LABEL WIDGET-ID 4
     btOK AT ROW 6.21 COL 2
     BtSalvar AT ROW 6.21 COL 13
     btCancel AT ROW 6.21 COL 24
     btHelp2 AT ROW 6.21 COL 82.14
     RECT-30 AT ROW 1.04 COL 1
     rtToolBar AT ROW 6 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92.43 BY 6.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttaf-item-contr-estab-aux T "?" NO-UNDO emsdca af-item-contr-estab
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
         HEIGHT             = 6.79
         WIDTH              = 92.43
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 92.43
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 92.43
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
ASSIGN 
       ttaf-item-contr-estab-aux.cod-emitente:POPUP-MENU IN FRAME fpage0       = MENU POPUP-MENU-cod-emitente:HANDLE.

ASSIGN 
       ttaf-item-contr-estab-aux.cod-estabel:POPUP-MENU IN FRAME fpage0       = MENU POPUP-MENU-cod-estabel:HANDLE.

ASSIGN 
       ttaf-item-contr-estab-aux.it-codigo:POPUP-MENU IN FRAME fpage0       = MENU POPUP-MENU-it-codigo:HANDLE.

ASSIGN 
       ttaf-item-contr-estab-aux.nr-versao:POPUP-MENU IN FRAME fpage0       = MENU POPUP-MENU-nr-versao:HANDLE.

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
    RETURN "NOK":U.
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
    ASSIGN ttAf-Item-Contr-Estab-Aux.nr-versao = INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.nr-versao.
    RUN piValidaInclusaoGrpAval IN h-boaf006 (INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.cod-estabel,
                                              INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.it-codigo,
                                              INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.cod-emitente,
                                              INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.nr-versao,
                                              OUTPUT c-cod-grp-aval).
    IF  RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Item_X_Fornecedor_X_Estab_X_Ponto_de_controle" *}
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 52859,
                           INPUT RETURN-VALUE + "~~" + 
                                 c-cod-grp-aval).
        APPLY "ENTRY" TO ttAf-Item-Contr-Estab-Aux.cod-estabel IN FRAME fPage0.
        UNDO,RETURN.
    END.
    
    RUN piValidaInclusaoEstab IN h-boaf006 ( INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.cod-estabel ).

    IF  RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Estabelecimento" *}
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 56,
                           INPUT RETURN-VALUE).
        APPLY "ENTRY" TO ttAf-Item-Contr-Estab-Aux.cod-estabel IN FRAME fPage0.
        UNDO,RETURN.
    END.

    RUN piValidaInclusaoItem IN h-boaf006 ( INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.it-codigo ).

    IF  RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "item" *}
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 56,
                           INPUT RETURN-VALUE).
        APPLY "ENTRY" TO ttAf-Item-Contr-Estab-Aux.it-codigo IN FRAME fPage0.
        UNDO,RETURN.
    END.

    RUN piValidaInclusaoEmitente IN h-boaf006 ( INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.cod-emitente ).

    IF  RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Emitente" *}
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 56,
                           INPUT RETURN-VALUE).
        APPLY "ENTRY" TO ttAf-Item-Contr-Estab-Aux.cod-emitente IN FRAME fPage0.
        UNDO,RETURN.
    END.
    
    ASSIGN INPUT FRAME fpage0 ttAf-Item-Contr-Estab-Aux.cod-estabel ttAf-Item-Contr-Estab-Aux.cod-emitente ttAf-Item-Contr-Estab-Aux.it-codigo ttAf-Item-Contr-Estab-Aux.nr-versao.

    RUN piSalva IN h-caller (INPUT TABLE ttAf-Item-Contr-Estab-Aux).

    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN "OK":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtSalvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtSalvar wWindow
ON CHOOSE OF BtSalvar IN FRAME fpage0 /* Salvar */
DO:
    ASSIGN ttAf-Item-Contr-Estab-Aux.nr-versao = INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.nr-versao.
    RUN piValidaInclusaoGrpAval IN h-boaf006 (INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.cod-estabel,
                                              INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.it-codigo,
                                              INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.cod-emitente,
                                              INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.nr-versao,
                                              OUTPUT c-cod-grp-aval).
    IF  RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Item_X_Fornecedor_X_Estab_X_Ponto_de_controle" *}
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 52859,
                           INPUT RETURN-VALUE + "~~" + 
                                 c-cod-grp-aval).
        APPLY "ENTRY" TO ttAf-Item-Contr-Estab-Aux.cod-estabel IN FRAME fPage0.
        UNDO,RETURN.
    END.


    RUN piValidaInclusaoEstab IN h-boaf006 ( INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.cod-estabel ).

    IF  RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Estabelecimento" *}
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 56,
                           INPUT RETURN-VALUE).
        APPLY "ENTRY" TO ttAf-Item-Contr-Estab-Aux.cod-estabel IN FRAME fPage0.
        UNDO,RETURN.
    END.

    RUN piValidaInclusaoItem IN h-boaf006 ( INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.it-codigo ).

    IF  RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "item" *}
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 56,
                           INPUT RETURN-VALUE).
        APPLY "ENTRY" TO ttAf-Item-Contr-Estab-Aux.it-codigo IN FRAME fPage0.
        UNDO,RETURN.
    END.

    RUN piValidaInclusaoEmitente IN h-boaf006 ( INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.cod-emitente ).

    IF  RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Emitente" *}
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 56,
                           INPUT RETURN-VALUE).
        APPLY "ENTRY" TO ttAf-Item-Contr-Estab-Aux.cod-emitente IN FRAME fPage0.
        UNDO,RETURN.
    END.
    
    ASSIGN INPUT FRAME fpage0 ttAf-Item-Contr-Estab-Aux.cod-estabel ttAf-Item-Contr-Estab-Aux.cod-emitente ttAf-Item-Contr-Estab-Aux.it-codigo ttAf-Item-Contr-Estab-Aux.nr-versao.
    RUN piSalva IN h-caller (INPUT TABLE ttAf-Item-Contr-Estab-Aux).

    ASSIGN ttAf-Item-Contr-Estab-Aux.cod-estabel:SCREEN-VALUE IN FRAME fpage0 = ""
           cNomeEstab:SCREEN-VALUE IN FRAME fpage0 = ""
           ttAf-Item-Contr-Estab-Aux.cod-emitente:SCREEN-VALUE IN FRAME fpage0 = "0"
           cNomeEmitente:SCREEN-VALUE IN FRAME fpage0 = ""
           ttAf-Item-Contr-Estab-Aux.it-codigo:SCREEN-VALUE IN FRAME fpage0 = ""
           cDescItem:SCREEN-VALUE IN FRAME fpage0 = ""
           ttAf-Item-Contr-Estab-Aux.nr-versao:SCREEN-VALUE IN FRAME fpage0 = "0"
           cDescVersao:SCREEN-VALUE IN FRAME fpage0 = "".

    APPLY "ENTRY" TO ttAf-Item-Contr-Estab-Aux.cod-estabel IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttaf-item-contr-estab-aux.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-item-contr-estab-aux.cod-emitente wWindow
ON F5 OF ttaf-item-contr-estab-aux.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
  
    /* ZOOM SMART OBJECT */
    {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                       &campo=ttAf-item-contr-estab-aux.cod-emitente
                       &campozoom=cod-emitente
                       &frame=fPage0}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-item-contr-estab-aux.cod-emitente wWindow
ON LEAVE OF ttaf-item-contr-estab-aux.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
  
    RUN getNomeEmitente in h-boaf006 ( INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.cod-emitente,
                                       OUTPUT cNomeEmite ).
    ASSIGN cNomeEmitente:SCREEN-VALUE IN FRAME fPage0 = cNomeEmite.

    RUN executeLeave (INPUT "cod-emitente":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-item-contr-estab-aux.cod-emitente wWindow
ON MOUSE-SELECT-DBLCLICK OF ttaf-item-contr-estab-aux.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
  
  APPLY "F5" TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttaf-item-contr-estab-aux.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-item-contr-estab-aux.cod-estabel wWindow
ON F5 OF ttaf-item-contr-estab-aux.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  
    /* ZOOM SMART OBJECT */
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=ttAf-item-contr-estab-aux.cod-estabel
                       &campozoom=cod-estabel
                       &frame=fPage0}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-item-contr-estab-aux.cod-estabel wWindow
ON LEAVE OF ttaf-item-contr-estab-aux.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    RUN getNomeEstabel in h-boaf006 ( INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.cod-estabel,
                                      OUTPUT cDescEstab ).
    ASSIGN cNomeEstab:SCREEN-VALUE IN FRAME fPage0 = cDescEstab.

    RUN executeLeave (INPUT "cod-estabel":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-item-contr-estab-aux.cod-estabel wWindow
ON MOUSE-SELECT-DBLCLICK OF ttaf-item-contr-estab-aux.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  
    APPLY "F5" TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttaf-item-contr-estab-aux.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-item-contr-estab-aux.it-codigo wWindow
ON F5 OF ttaf-item-contr-estab-aux.it-codigo IN FRAME fpage0 /* Item */
DO:
    
    /* ZOOM SMART OBJECT */
    {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                       &campo=ttAf-item-contr-estab-aux.it-codigo
                       &campozoom=it-codigo
                       &frame=fPage0}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-item-contr-estab-aux.it-codigo wWindow
ON LEAVE OF ttaf-item-contr-estab-aux.it-codigo IN FRAME fpage0 /* Item */
DO:
  
    RUN getDescItem in h-boaf006 ( INPUT FRAME fPage0 ttAf-Item-Contr-Estab-Aux.it-codigo,
                                   OUTPUT cDesItem ).
    ASSIGN cDescItem:SCREEN-VALUE IN FRAME fPage0 = cDesItem.

    RUN executeLeave (INPUT "it-codigo":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-item-contr-estab-aux.it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF ttaf-item-contr-estab-aux.it-codigo IN FRAME fpage0 /* Item */
DO:
  
    APPLY "F5" TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomEstab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomEstab wWindow
ON CHOOSE OF MENU-ITEM mZoomEstab /* Zoom de Estabelecimento */
DO:
  
    /* ZOOM SMART OBJECT */
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=ttAf-item-contr-estab-aux.cod-estabel
                       &campozoom=cod-estabel
                       &frame=fPage0}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomEstabItemFornecedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomEstabItemFornecedor wWindow
ON CHOOSE OF MENU-ITEM mZoomEstabItemFornecedor /* Zoom de Estab/Item/Fornecedor/Vers∆o */
DO:
  
     {method/ZoomFields.i &ProgramZoom="afzoom/z01af006.w"
                        &FieldZoom1="cod-estabel"
                        &FieldScreen1="ttAf-item-contr-estab-aux.cod-estabel"
                        &Frame1="{&frame-name}"
                        &FieldZoom2="it-codigo"
                        &FieldScreen2="ttAf-item-contr-estab-aux.it-codigo"
                        &Frame2="{&frame-name}"
                        &FieldZoom3="cod-emitente"
                        &FieldScreen3="ttAf-item-contr-estab-aux.cod-emitente"
                        &Frame3="{&frame-name}"
                        &FieldZoom4="nr-versao"
                        &FieldScreen4="ttAf-item-contr-estab-aux.nr-versao"
                        &Frame4="{&frame-name}"
                        &EnableImplant="no"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomFornecedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomFornecedor wWindow
ON CHOOSE OF MENU-ITEM mZoomFornecedor /* Zoom de Fornecedor */
DO:
  
    /* ZOOM SMART OBJECT */
    {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                       &campo=ttAf-item-contr-estab-aux.cod-emitente
                       &campozoom=cod-emitente
                       &frame=fPage0}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomFornecedorEstabItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomFornecedorEstabItem wWindow
ON CHOOSE OF MENU-ITEM mZoomFornecedorEstabItem /* Zoom de Estab/Item/Fornecedor/Vers∆o */
DO:
  
     {method/ZoomFields.i &ProgramZoom="afzoom/z01af006.w"
                        &FieldZoom1="cod-estabel"
                        &FieldScreen1="ttAf-item-contr-estab-aux.cod-estabel"
                        &Frame1="{&frame-name}"
                        &FieldZoom2="it-codigo"
                        &FieldScreen2="ttAf-item-contr-estab-aux.it-codigo"
                        &Frame2="{&frame-name}"
                        &FieldZoom3="cod-emitente"
                        &FieldScreen3="ttAf-item-contr-estab-aux.cod-emitente"
                        &Frame3="{&frame-name}"
                        &FieldZoom4="nr-versao"
                        &FieldScreen4="ttAf-item-contr-estab-aux.nr-versao"
                        &Frame4="{&frame-name}"
                        &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomItem wWindow
ON CHOOSE OF MENU-ITEM mZoomItem /* Zoom de Item */
DO:
  
    {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                       &campo=ttAf-item-contr-estab-aux.it-codigo
                       &campozoom=it-codigo
                       &frame=fPage0}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomItemFornecedorEstab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomItemFornecedorEstab wWindow
ON CHOOSE OF MENU-ITEM mZoomItemFornecedorEstab /* Zoom de Estab/Item/Fornecedor/Vers∆o */
DO:
  
    {method/ZoomFields.i &ProgramZoom="afzoom/z01af006.w"
                        &FieldZoom1="cod-estabel"
                        &FieldScreen1="ttAf-item-contr-estab-aux.cod-estabel"
                        &Frame1="{&frame-name}"
                        &FieldZoom2="it-codigo"
                        &FieldScreen2="ttAf-item-contr-estab-aux.it-codigo"
                        &Frame2="{&frame-name}"
                        &FieldZoom3="cod-emitente"
                        &FieldScreen3="ttAf-item-contr-estab-aux.cod-emitente"
                        &Frame3="{&frame-name}"
                        &FieldZoom4="nr-versao"
                        &FieldScreen4="ttAf-item-contr-estab-aux.nr-versao"
                        &Frame4="{&frame-name}"
                        &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomVersao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomVersao wWindow
ON CHOOSE OF MENU-ITEM mZoomVersao /* Zoom de Vers∆o */
DO:
   {method/ZoomFields.i
            &ProgramZoom="afzoom/Z01AF023.w"
            &FieldZoom1="nr-versao"
            &FieldScreen1="ttAf-item-contr-estab-aux.nr-versao"
            &Frame1="fpage0"
            &FieldZoom2="desc-versao"
            &FieldScreen2="cDescVersao"
            &Frame2="fpage0"
            &EnableImplant="yes"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomVersaoEstabItemFornecedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomVersaoEstabItemFornecedor wWindow
ON CHOOSE OF MENU-ITEM mZoomVersaoEstabItemFornecedor /* Zoom de Estab/Item/Fornecedor/Vers∆o */
DO:
  
   {method/ZoomFields.i &ProgramZoom="afzoom/z01af006.w"
                        &FieldZoom1="cod-estabel"
                        &FieldScreen1="ttAf-item-contr-estab-aux.cod-estabel"
                        &Frame1="{&frame-name}"
                        &FieldZoom2="it-codigo"
                        &FieldScreen2="ttAf-item-contr-estab-aux.it-codigo"
                        &Frame2="{&frame-name}"
                        &FieldZoom3="cod-emitente"
                        &FieldScreen3="ttAf-item-contr-estab-aux.cod-emitente"
                        &Frame3="{&frame-name}"
                        &FieldZoom4="nr-versao"
                        &FieldScreen4="ttAf-item-contr-estab-aux.nr-versao"
                        &Frame4="{&frame-name}"
                        &EnableImplant="no"}
                        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttaf-item-contr-estab-aux.nr-versao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-item-contr-estab-aux.nr-versao wWindow
ON F5 OF ttaf-item-contr-estab-aux.nr-versao IN FRAME fpage0 /* N£mero Vers∆o */
DO:
    {method/ZoomFields.i
            &ProgramZoom="afzoom/Z01AF023.w"
            &FieldZoom1="nr-versao"
            &FieldScreen1="ttAf-item-contr-estab-aux.nr-versao"
            &Frame1="fpage0"
            &FieldZoom2="desc-versao"
            &FieldScreen2="cDescVersao"
            &Frame2="fpage0"
            &EnableImplant="yes"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-item-contr-estab-aux.nr-versao wWindow
ON LEAVE OF ttaf-item-contr-estab-aux.nr-versao IN FRAME fpage0 /* N£mero Vers∆o */
DO:
    {method/referencefields.i &HandleDBOLeave="h-boaf023"
                              &KeyValue1="input frame fPage0 ttAf-Item-Contr-Estab-Aux.nr-versao"
                              &KeyValue2="ttAf-Item-Contr-Estab-Aux.ep-codigo"
                              &FieldName1="desc-versao"                                           
                              &FieldScreen1="cDescVersao"
                              &Frame1="fPage0"}
                              
     RUN executeLeave (INPUT "nr-versao":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-item-contr-estab-aux.nr-versao wWindow
ON MOUSE-SELECT-DBLCLICK OF ttaf-item-contr-estab-aux.nr-versao IN FRAME fpage0 /* N£mero Vers∆o */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/MainBlock.i}

{utp/ut-liter.i Zoom_de_Estabelecimento * L}
ASSIGN MENU-ITEM mZoomEstab:label IN MENU POPUP-MENU-cod-estabel = RETURN-VALUE.

{utp/ut-liter.i Zoom_de_Estab_/_Item_/_Fornecedor_/_Versao * L}
ASSIGN MENU-ITEM mZoomEstabItemFornecedor:LABEL IN MENU POPUP-MENU-cod-estabel = trim(return-value).

{utp/ut-liter.i Zoom_de_Item * L}
ASSIGN MENU-ITEM mZoomItem:LABEL IN MENU POPUP-MENU-it-codigo = trim(return-value).

{utp/ut-liter.i Zoom_de_Estab_/_Item_/_Fornecedor_/_Versao * L}
ASSIGN MENU-ITEM mZoomItemFornecedorEstab:LABEL IN MENU POPUP-MENU-it-codigo = trim(return-value).


{utp/ut-liter.i Zoom_de_Emitente * L}
ASSIGN MENU-ITEM mZoomFornecedor:LABEL IN MENU POPUP-MENU-cod-emitente = trim(return-value).

{utp/ut-liter.i Zoom_de_Estab_/_Item_/_Fornecedor_/_Versao * L}
ASSIGN MENU-ITEM mZoomFornecedorEstabItem:LABEL IN MENU POPUP-MENU-cod-emitente = trim(return-value).

{utp/ut-liter.i Zoom_de_Vers∆o * L}
ASSIGN MENU-ITEM mZoomVersao:LABEL IN MENU POPUP-MENU-nr-versao = trim(return-value).

{utp/ut-liter.i Zoom_de_Estab_/_Item_/_Fornecedor_/_Versao * L}
ASSIGN MENU-ITEM mZoomVersaoEstabItemFornecedor:LABEL IN MENU POPUP-MENU-nr-versao = trim(return-value).

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
IF VALID-HANDLE(h-boaf006) THEN DO:
   DELETE PROCEDURE h-boaf006.
   ASSIGN h-boaf006 = ?.
END.

IF VALID-HANDLE(h-boaf023) THEN DO:
   DELETE PROCEDURE h-boaf023.
   ASSIGN h-boaf023 = ?.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wWindow 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*RUN gotokey      IN h-boaf001 (INPUT i-ep-codigo-usuario, 
                                   INPUT iControle:SCREEN-VALUE IN FRAME fpage0).
    IF RETURN-VALUE = "ok" THEN
       RUN getcharfield IN h-boaf001 (INPUT "descricao",
                                      OUTPUT cDescricao).
    ELSE cDescricao = "".

    DISP cDescricao WITH FRAME fpage0.*/


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
    FIND FIRST ttAf-Item-Contr-Estab-Aux NO-LOCK NO-ERROR.
    ENABLE ttAf-Item-Contr-Estab-Aux.cod-estabel 
           ttAf-Item-Contr-Estab-Aux.cod-emitente
           ttAf-Item-Contr-Estab-Aux.it-codigo 
           ttAf-Item-Contr-Estab-Aux.nr-versao WITH FRAME fpage0.

    ttAf-Item-Contr-Estab-Aux.cod-estabel:load-mouse-pointer("image~\rbm.cur":U) in frame fPage0.
    ttAf-Item-Contr-Estab-Aux.it-codigo:load-mouse-pointer("image~\rbm.cur":U) in frame fPage0. 
    ttAf-Item-Contr-Estab-Aux.cod-emitente:load-mouse-pointer("image~\rbm.cur":U) in frame fPage0. 
    ttAf-item-Contr-Estab-Aux.nr-versao:load-mouse-pointer("image~\rbm.cur":U) in frame fPage0. 

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
IF NOT VALID-HANDLE(h-boaf006) OR
   h-boaf006:TYPE <> "PROCEDURE":U OR
   h-boaf006:FILE-NAME <> "afbo/boaf006.p":U THEN DO:
   RUN afbo/boaf006.p PERSISTENT SET h-boaf006.
END.

IF NOT VALID-HANDLE(h-boaf023) OR
   h-boaf023:TYPE <> "PROCEDURE":U OR
   h-boaf023:FILE-NAME <> "afbo/boaf023.p":U THEN DO:
   RUN afbo/boaf023.p PERSISTENT SET h-boaf023.
END.
   RUN openQueryStatic IN h-boaf023 (INPUT "Main":U) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executeLeave wWindow 
PROCEDURE executeLeave :
/*------------------------------------------------------------------------------
  Purpose:     Procedute para executar o Leave dos campos de Descriá∆o ap¢s 
                a busca do Zoom GenÇrico.
  Parameters: p-campo -> Qual campo est† disparando
  Notes:      Esse campo Ç necess†rio pois se sempre disparar todos os campos
              quem disparou o "Leave" vai ser chamado novamente deixando o programa
              em loop 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-campo AS CHARACTER NO-UNDO.

    IF p-campo <> "cod-estabel":U THEN
       APPLY "LEAVE":U TO ttAf-Item-Contr-Estab-Aux.cod-estabel     IN FRAME fpage0.
    IF p-campo <> "it-codigo":U THEN
       APPLY "LEAVE":U TO ttAf-Item-Contr-Estab-Aux.it-codigo       IN FRAME fpage0.
    IF p-campo <> "cod-emitente":U THEN
       APPLY "LEAVE":U TO ttAf-Item-Contr-Estab-Aux.cod-emitente    IN FRAME fpage0.
    IF p-campo <> "nr-versao":U THEN
       APPLY "LEAVE":U TO ttAf-Item-Contr-Estab-Aux.nr-versao       IN FRAME fpage0.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

