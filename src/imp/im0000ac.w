&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-tab-ocor NO-UNDO LIKE tab-ocor
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
{include/i-prgvrs.i IM0000AC 2.00.00.003 } /*** 010003 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0000AC MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0000AC
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEF INPUT PARAM p-estab LIKE estabelec.cod-estabel NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-boad250        AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-reg-retornados AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-contaregistro  AS INTEGER     NO-UNDO.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTaxa

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-tab-ocor

/* Definitions for BROWSE brTaxa                                        */
&Scoped-define FIELDS-IN-QUERY-brTaxa tt-tab-ocor.c-campo[1] tt-tab-ocor.de-campo[1]   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTaxa   
&Scoped-define SELF-NAME brTaxa
&Scoped-define QUERY-STRING-brTaxa FOR EACH tt-tab-ocor NO-LOCK
&Scoped-define OPEN-QUERY-brTaxa OPEN QUERY {&SELF-NAME} FOR EACH tt-tab-ocor NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTaxa tt-tab-ocor
&Scoped-define FIRST-TABLE-IN-QUERY-brTaxa tt-tab-ocor


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brTaxa}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-1 btQueryJoins ~
btReportsJoins btExit btHelp brTaxa btOK btCancel btHelp2 

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
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
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
     IMAGE-UP FILE "image/im-joi":U
     IMAGE-INSENSITIVE FILE "image/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image/im-pri":U
     IMAGE-INSENSITIVE FILE "image/ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 54 BY 7.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 56 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 56 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTaxa FOR 
      tt-tab-ocor SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTaxa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTaxa wWindow _FREEFORM
  QUERY brTaxa NO-LOCK DISPLAY
      tt-tab-ocor.char-1      FORMAT "x(30)":U         COLUMN-LABEL "Faixa"
      tt-tab-ocor.de-campo[1] FORMAT "->>,>>9.99":U   COLUMN-LABEL "Valor"
    ENABLE
        tt-tab-ocor.de-campo[1]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 50 BY 6.25
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 40.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 44.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 48.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 52.57 HELP
          "Ajuda"
     brTaxa AT ROW 3.33 COL 4 
     btOK AT ROW 10.42 COL 2
     btCancel AT ROW 10.42 COL 13
     btHelp2 AT ROW 10.42 COL 46.29
     "Faixas de Valores Taxa Siscomex" VIEW-AS TEXT
          SIZE 24 BY .54 AT ROW 2.5 COL 4 
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 10.21 COL 1
     RECT-1 AT ROW 2.75 COL 2 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 56 BY 10.79
         FONT 1 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-tab-ocor T "?" NO-UNDO mgadm tab-ocor
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
         HEIGHT             = 10.79
         WIDTH              = 56
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
/* BROWSE-TAB brTaxa btHelp fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTaxa
/* Query rebuild information for BROWSE brTaxa
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-tab-ocor NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brTaxa */
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
    RUN pi-salva-faixas.
    IF RETURN-VALUE = "OK":U THEN
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


&Scoped-define BROWSE-NAME brTaxa
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

IF NOT VALID-HANDLE(h-boad250) THEN
    RUN adbo/boad250.p PERSISTENT SET h-boad250.

ENABLE brTaxa WITH FRAME fPage0.

RUN pi-busca-faixas.
RUN pi-cria-tab-ocor.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-faixas wWindow 
PROCEDURE pi-busca-faixas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt-tab-ocor.

/* eliminar registros duplicados */
FOR EACH tab-ocor
    WHERE tab-ocor.cod-tab    = 612
      AND tab-ocor.c-campo[1] = p-estab
      AND tab-ocor.i-campo[1] > 7 EXCLUSIVE-LOCK:
    DELETE tab-ocor.
END.

RUN setConstraintTaxaSiscomex IN h-boad250 (INPUT p-estab).
RUN openQueryStatic           IN h-boad250 (INPUT "TaxaSiscomex":U).
RUN getBatchRecords           IN h-boad250 (INPUT  ?,
                                            INPUT  ?,
                                            INPUT  99999,
                                            OUTPUT i-reg-retornados,
                                            OUTPUT TABLE tt-tab-ocor).
FOR FIRST tt-tab-ocor: END.

{&OPEN-QUERY-brTaxa}


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-faixas wWindow 
PROCEDURE pi-salva-faixas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN i-contaregistro = 0.

    IF CAN-FIND(FIRST tt-tab-ocor
                WHERE tt-tab-ocor.de-campo[1] = 0) THEN DO:

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Valor_Taxa_Siscomex" *}
        RUN utp/ut-msgs.p(INPUT "Show":U,
                          INPUT 2333,
                          INPUT RETURN-VALUE).

        RETURN "NOK":U.

    END.
    ELSE DO:
        FOR EACH tt-tab-ocor:
            IF NOT CAN-FIND(FIRST tab-ocor
                            WHERE tab-ocor.cod-tab    = 612
                            AND   tab-ocor.c-campo[1] = p-estab
                            AND   tab-ocor.char-1     = tt-tab-ocor.char-1) THEN DO:
        
                FIND LAST tab-ocor NO-LOCK
                    WHERE tab-ocor.cod-tab    = 612 NO-ERROR.
                IF  AVAIL tab-ocor THEN 
                     ASSIGN i-contaregistro = tab-ocor.cod-ocor + 1.
                ELSE ASSIGN i-contaregistro = 1.
        
                CREATE tab-ocor.
                ASSIGN tab-ocor.cod-tab    = 612
                       tab-ocor.cod-ocor   = i-contaregistro
                       tab-ocor.c-campo[1] = p-estab
                       tab-ocor.i-campo[1] = tt-tab-ocor.cod-ocor
                       tab-ocor.char-1     = tt-tab-ocor.char-1.
            END.
            ELSE DO:
                FOR FIRST tab-ocor
                    WHERE tab-ocor.cod-tab    = 612
                    AND   tab-ocor.c-campo[1] = p-estab 
                    AND   tab-ocor.char-1     = tt-tab-ocor.char-1 EXCLUSIVE-LOCK: END.
            END.
        
            ASSIGN tab-ocor.de-campo[1] = tt-tab-ocor.de-campo[1].
        END.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tab-ocor wWindow 
PROCEDURE pi-cria-tab-ocor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT CAN-FIND(FIRST tt-tab-ocor
                    WHERE tt-tab-ocor.cod-tab    = 612
                    AND   tt-tab-ocor.c-campo[1] = p-estab) THEN DO:

        CREATE tt-tab-ocor.
        ASSIGN tt-tab-ocor.cod-tab     = 612
               tt-tab-ocor.cod-ocor    = 1
               tt-tab-ocor.c-campo[1]  = p-estab
               tt-tab-ocor.char-1      = "Por Declara‡Æo de Importa‡Æo"
               tt-tab-ocor.de-campo[1] = 0.

        CREATE tt-tab-ocor.
        ASSIGN tt-tab-ocor.cod-tab     = 612
               tt-tab-ocor.cod-ocor    = 2
               tt-tab-ocor.c-campo[1]  = p-estab
               tt-tab-ocor.char-1      = "At‚ a 2§ Adi‡Æo"
               tt-tab-ocor.de-campo[1] = 0.

        CREATE tt-tab-ocor.
        ASSIGN tt-tab-ocor.cod-tab     = 612
               tt-tab-ocor.cod-ocor    = 3
               tt-tab-ocor.c-campo[1]  = p-estab
               tt-tab-ocor.char-1      = "3§ a 5§ Adi‡Æo"
               tt-tab-ocor.de-campo[1] = 0.

        CREATE tt-tab-ocor.
        ASSIGN tt-tab-ocor.cod-tab     = 612
               tt-tab-ocor.cod-ocor    = 4
               tt-tab-ocor.c-campo[1]  = p-estab
               tt-tab-ocor.char-1      = "6§ a 10§ Adi‡Æo"
               tt-tab-ocor.de-campo[1] = 0.

        CREATE tt-tab-ocor.
        ASSIGN tt-tab-ocor.cod-tab     = 612
               tt-tab-ocor.cod-ocor    = 5
               tt-tab-ocor.c-campo[1]  = p-estab
               tt-tab-ocor.char-1      = "11§ a 20§ Adi‡Æo"
               tt-tab-ocor.de-campo[1] = 0.

        CREATE tt-tab-ocor.
        ASSIGN tt-tab-ocor.cod-tab     = 612
               tt-tab-ocor.cod-ocor    = 6
               tt-tab-ocor.c-campo[1]  = p-estab
               tt-tab-ocor.char-1      = "21§ a 50§ Adi‡Æo"
               tt-tab-ocor.de-campo[1] = 0.

        CREATE tt-tab-ocor.
        ASSIGN tt-tab-ocor.cod-tab     = 612
               tt-tab-ocor.cod-ocor    = 7
               tt-tab-ocor.c-campo[1]  = p-estab
               tt-tab-ocor.char-1      = "A partir da 51§ Adi‡Æo"
               tt-tab-ocor.de-campo[1] = 0.

    END.

    {&OPEN-QUERY-brTaxa}

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
