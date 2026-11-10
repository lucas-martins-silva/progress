&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-imp-cotac NO-UNDO LIKE decla-import-cotac
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-decla-imp-cotac-aux NO-UNDO LIKE decla-import-cotac
       FIELD r-Rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0400C 2.00.00.012 } /*** "010012" 14/11/2025 16:15:33 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0400C
&GLOBAL-DEFINE Version        2.00.00.012

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 brCotacao btAlteraCotacao btDelCotacao btSaveCotacao

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER phBoCaller      AS HANDLE    NO-UNDO.
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-boun005 AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-desc-moeda LIKE moeda.descricao NO-UNDO.
DEFINE VARIABLE h-bocx395 AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-cont    AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brCotacao

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-decla-imp-cotac

/* Definitions for BROWSE brCotacao                                     */
&Scoped-define FIELDS-IN-QUERY-brCotacao tt-decla-imp-cotac.cdn-moeda fnDescMoeda(tt-decla-imp-cotac.cdn-moeda) @ c-desc-moeda tt-decla-imp-cotac.val-cotac   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brCotacao tt-decla-imp-cotac.val-cotac   
&Scoped-define ENABLED-TABLES-IN-QUERY-brCotacao tt-decla-imp-cotac
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brCotacao tt-decla-imp-cotac
&Scoped-define SELF-NAME brCotacao
&Scoped-define QUERY-STRING-brCotacao FOR EACH tt-decla-imp-cotac NO-LOCK
&Scoped-define OPEN-QUERY-brCotacao OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-imp-cotac NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brCotacao tt-decla-imp-cotac
&Scoped-define FIRST-TABLE-IN-QUERY-brCotacao tt-decla-imp-cotac


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brCotacao}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btQueryJoins btReportsJoins btExit btHelp ~
rtToolBar rtKeys rtKeys-2 rtToolBar-2 i-num-di-ems c-cod-di-siscomex ~
i-num-seq-retif c-cod-estab d-dat-di brCotacao btAlteraCotacao ~
btSaveCotacao btDelCotacao btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS i-num-di-ems c-cod-di-siscomex ~
i-num-seq-retif c-cod-estab d-dat-di 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescMoeda wWindow 
FUNCTION fnDescMoeda RETURNS CHARACTER
  ( pMoeda AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
DEFINE BUTTON btAlteraCotacao 
     IMAGE-UP FILE "image/im-clr.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-clr.bmp":U
     LABEL "Save" 
     SIZE 4 BY 1.25 TOOLTIP "Alteraá∆o Cotaá∆o DI"
     FONT 4.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDelCotacao 
     IMAGE-UP FILE "image/im-era.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-era.bmp":U
     LABEL "Excluir" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE BUTTON btSaveCotacao 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25 TOOLTIP "Salva Cotaá∆o DI"
     FONT 4.

DEFINE VARIABLE c-cod-di-siscomex AS CHARACTER FORMAT "x(13)" 
     LABEL "DI Siscomex" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estab AS CHARACTER FORMAT "x(5)" 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE d-dat-di AS DATE FORMAT "99/99/9999" 
     LABEL "Data da DI" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-di-ems AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Declaraá∆o de Importaá∆o EMS" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-seq-retif AS INTEGER FORMAT "99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61.57 BY 2.58.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61.57 BY 10.17.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 62 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 62 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brCotacao FOR 
      tt-decla-imp-cotac SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brCotacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brCotacao wWindow _FREEFORM
  QUERY brCotacao NO-LOCK DISPLAY
      tt-decla-imp-cotac.cdn-moeda FORMAT ">9":U COLUMN-LABEL "Moeda"
      fnDescMoeda(tt-decla-imp-cotac.cdn-moeda) @ c-desc-moeda FORMAT "x(50)" WIDTH 30 COLUMN-LABEL "Descriá∆o"
      tt-decla-imp-cotac.val-cotac FORMAT "->>>,>>9.99999999":U
      ENABLE
          tt-decla-imp-cotac.val-cotac
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 53 BY 9.5
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 46 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 50 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 54 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 58 HELP
          "Ajuda"
     i-num-di-ems AT ROW 3 COL 22.86 COLON-ALIGNED HELP
          "N£mero Declaraá∆o de Importaá∆o EMS"
     c-cod-di-siscomex AT ROW 3 COL 42.86 COLON-ALIGNED HELP
          "C¢digo DI Siscomex"
     i-num-seq-retif AT ROW 3 COL 52.86 COLON-ALIGNED HELP
          "N£mero Sequencia Retificaá∆o" NO-LABEL
     c-cod-estab AT ROW 4 COL 22.86 COLON-ALIGNED HELP
          "C¢digo do estabelecimento."
     d-dat-di AT ROW 4 COL 42.86 COLON-ALIGNED HELP
          "Data da DI"
     brCotacao AT ROW 5.67 COL 3
     btAlteraCotacao AT ROW 5.75 COL 57 HELP
          "Confirma alteraá‰es"
     btSaveCotacao AT ROW 6.96 COL 57 HELP
          "Confirma alteraá‰es"
     btDelCotacao AT ROW 8.17 COL 57 HELP
          "Confirma alteraá‰es"
     btOK AT ROW 15.88 COL 2
     btCancel AT ROW 15.88 COL 13
     btHelp2 AT ROW 15.88 COL 51.86
     rtToolBar AT ROW 15.67 COL 1
     rtKeys AT ROW 2.67 COL 1.43
     rtKeys-2 AT ROW 5.33 COL 1.43
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62.86 BY 16.21
         FONT 1.

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decla-imp-cotac T "?" NO-UNDO mgcex decla-import-cotac
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-decla-imp-cotac-aux T "?" NO-UNDO mgcex decla-import-cotac
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
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
         HEIGHT             = 16.33
         WIDTH              = 63.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 103.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 103.14
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
/* BROWSE-TAB brCotacao d-dat-di fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brCotacao
/* Query rebuild information for BROWSE brCotacao
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-imp-cotac NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brCotacao */
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


&Scoped-define SELF-NAME btAlteraCotacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlteraCotacao wWindow
ON CHOOSE OF btAlteraCotacao IN FRAME fpage0 /* Save */
DO:
  RUN pi-update.
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


&Scoped-define SELF-NAME btDelCotacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelCotacao wWindow
ON CHOOSE OF btDelCotacao IN FRAME fpage0 /* Excluir */
DO:
  RUN pi-exclui-cotacao.
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


&Scoped-define SELF-NAME btSaveCotacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSaveCotacao wWindow
ON CHOOSE OF btSaveCotacao IN FRAME fpage0 /* Save */
DO:
  RUN pi-salva-cotacao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brCotacao
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

IF VALID-HANDLE(h-boun005) THEN DO:
    DELETE PROCEDURE h-boun005.
    ASSIGN h-boun005 = ?.
END.

IF VALID-HANDLE(h-bocx395) THEN DO:
    DELETE PROCEDURE h-bocx395.
    ASSIGN h-bocx395 = ?.
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

RUN inicia-bos.

IF prParent <> ? THEN DO:
    /*POSICIONANDO DI*/
    RUN repositionRecord IN phBoCaller (INPUT prParent).

    RUN getIntField      IN phBoCaller (INPUT 'num-di-ems',
                                        OUTPUT i-num-di-ems).
    RUN getCharField     IN phBoCaller (INPUT 'cod-estab',
                                        OUTPUT c-cod-estab).
    RUN getCharField     IN phBoCaller (INPUT 'cod-di-siscomex',
                                        OUTPUT c-cod-di-siscomex).
    RUN getIntField      IN phBoCaller (INPUT 'num-seq-retif',
                                        OUTPUT i-num-seq-retif).
    RUN getDateField     IN phBoCaller (INPUT 'dat-di',
                                        OUTPUT d-dat-di).    
    RUN getCharField     IN phBoCaller (INPUT 'cdd-siscomex-dts',
                                        OUTPUT de-cdd-siscomex-dts).                                        

    DISPLAY i-num-di-ems
            c-cod-estab
            c-cod-di-siscomex
            i-num-seq-retif
            d-dat-di WITH FRAME fPage0.

END.

RUN pi-atualiza-browser.

ASSIGN tt-decla-imp-cotac.val-cotac:READ-ONLY  IN BROWSE brCotacao = YES.

IF CAN-FIND(FIRST tt-decla-imp-cotac) THEN DO:
    DISABLE btSaveCotacao WITH FRAME fPage0.   
    ENABLE btDelCotacao btAlteraCotacao WITH FRAME fPage0.   
END.
ELSE
    DISABLE btDelCotacao btAlteraCotacao btSaveCotacao WITH FRAME fPage0.   

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicia-bos wWindow 
PROCEDURE inicia-bos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT VALID-HANDLE(h-bocx395) THEN DO:
    RUN cxbo\bocx395.p PERSISTENT SET h-bocx395.
    RUN openQueryStatic IN h-bocx395(INPUT 'Main':U).
END.
    

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-browser wWindow 
PROCEDURE pi-atualiza-browser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt-decla-imp-cotac.

RUN getMoedasDespesas IN h-bocx395(INPUT i-num-di-ems,
                                   INPUT de-cdd-siscomex-dts,
                                   OUTPUT TABLE tt-decla-imp-cotac).

{&OPEN-QUERY-brCotacao}

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exclui-cotacao wWindow 
PROCEDURE pi-exclui-cotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO  i-cont = 1 TO brCotacao:NUM-SELECTED-ROWS IN FRAME fPage0:
    IF  brCotacao:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage0 THEN DO:  

        RUN goToKey IN h-bocx395 (INPUT tt-decla-imp-cotac.num-di-ems,
                                  INPUT tt-decla-imp-cotac.cdn-moeda,
                                  INPUT tt-decla-imp-cotac.cdd-siscomex-dts).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN deleteRecord IN h-bocx395.
            RUN goToKey IN h-bocx395 (INPUT tt-decla-imp-cotac.num-di-ems,
                                      INPUT tt-decla-imp-cotac.cdn-moeda,
                                      INPUT tt-decla-imp-cotac.cdd-siscomex-dts).
            IF RETURN-VALUE = "NOK":U THEN
                DELETE tt-decla-imp-cotac.
        END.
        ELSE DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Cotaá∆o_n∆o_pode_ser_exclu°da_pois_a_mesma_n∆o_foi_confirmada" *}
            RUN utp/ut-msgs.p (INPUT 'show',
                            INPUT "17006",
                            INPUT RETURN-VALUE + '!').
        END.
    END.
END.

{&OPEN-QUERY-brCotacao}

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-cotacao wWindow 
PROCEDURE pi-salva-cotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH tt-decla-imp-cotac:
    EMPTY TEMP-TABLE tt-decla-imp-cotac-aux.
    CREATE tt-decla-imp-cotac-aux.
    BUFFER-COPY tt-decla-imp-cotac TO tt-decla-imp-cotac-aux.

    RUN emptyRowErrors  IN h-bocx395.
    RUN emptyRowObject  IN h-bocx395.
    RUN openQueryStatic IN h-bocx395 (INPUT "Main":U).
    IF RETURN-VALUE = "NOK":U THEN
        RUN emptyRowErrors IN h-bocx395.

    RUN goToKey         IN h-bocx395 (INPUT tt-decla-imp-cotac-aux.num-di-ems,
                                      INPUT tt-decla-imp-cotac-aux.cdn-moeda,
                                      INPUT tt-decla-imp-cotac.cdd-siscomex-dts).
    /*FOR FIRST tt-decla-imp-cotac-aux: END.*/
    IF RETURN-VALUE = "NOK" THEN DO:
        RUN setRecord       IN h-bocx395 (INPUT TABLE tt-decla-imp-cotac-aux).
        RUN createRecord    IN h-bocx395.
    END.
    ELSE DO:
        RUN setRecord       IN h-bocx395 (INPUT TABLE tt-decla-imp-cotac-aux).
        RUN updateRecord    IN h-bocx395.
    END.

    IF RETURN-VALUE = "OK":U THEN DO:
        DISABLE btSaveCotacao WITH FRAME fPage0.
        ENABLE btDelCotacao btAlteraCotacao WITH FRAME fPage0.
        ASSIGN tt-decla-imp-cotac.val-cotac:READ-ONLY  IN BROWSE brCotacao = YES.
    END.
    ELSE DO:
        RUN getRowErrors IN h-bocx395(OUTPUT TABLE RowErrors).
        IF  CAN-FIND(FIRST RowErrors
                     /*WHERE RowErrors.ErrorType <> "INTERNAL":U*/ ) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
        END.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-update wWindow 
PROCEDURE pi-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO  i-cont = 1 TO brCotacao:NUM-SELECTED-ROWS IN FRAME fPage0:
    IF  brCotacao:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage0 THEN DO:  

        DISABLE btDelCotacao btAlteraCotacao WITH FRAME fPage0.
        ENABLE btSaveCotacao WITH FRAME fPage0.

        ASSIGN tt-decla-imp-cotac.val-cotac:READ-ONLY  IN BROWSE brCotacao = NO.

        APPLY "ENTRY" TO tt-decla-imp-cotac.val-cotac IN BROWSE brCotacao.

    END.

END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescMoeda wWindow 
FUNCTION fnDescMoeda RETURNS CHARACTER
  ( pMoeda AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NOT VALID-HANDLE(h-boun005) THEN DO:
      RUN unbo\boun005na.p PERSISTENT SET h-boun005.
      RUN openQueryStatic IN h-boun005 (INPUT "Main":U).
  END.
      

  RUN goToKey IN h-boun005 (INPUT pMoeda). 
  IF RETURN-VALUE = "OK" THEN DO:
      RUN getCharField IN h-boun005 (INPUT 'descricao',
                                     OUTPUT c-desc-moeda).
  END.


  RETURN c-desc-moeda.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



