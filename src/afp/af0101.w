&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-param-af NO-UNDO LIKE param-af
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0101 2.00.00.003 } /*** 010003 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AF0101 MAF}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AF0101
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Parametros

&GLOBAL-DEFINE page0Widgets   btOPenHist btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   tt-param-af.log-usa-versao tt-param-af.log-versao-demerito ~
                              tt-param-af.log-versao-formula tt-param-af.i-tipo-validade-versao tt-param-af.log-elimina-relac

/* Parameters Definitions ---                                           */

{utp/ut-glob.i}.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-boaf022 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-afapi003 AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar btOPenHist ~
btQueryJoins btReportsJoins btExit btHelp btOK btCancel btHelp2 

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

DEFINE BUTTON btOPenHist 
     IMAGE-UP FILE "image/toolbar/gr-ger.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/gr-ger.bmp":U
     LABEL "Open History" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 6.5.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 1.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOPenHist AT ROW 1.13 COL 70.57 HELP
          "Consultas relacionadas"
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
     tt-param-af.log-usa-versao AT ROW 2.5 COL 4.57
          LABEL "Utiliza controle de vers∆o"
          VIEW-AS TOGGLE-BOX
          SIZE 28.43 BY .88
     tt-param-af.log-versao-demerito AT ROW 3.5 COL 9
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .88
     tt-param-af.i-tipo-validade-versao AT ROW 3.5 COL 50 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Utilizaá∆o das vers‰es", 1,
"Cadastro de vers‰es", 2
          SIZE 20 BY 1.75
     tt-param-af.log-versao-formula AT ROW 4.5 COL 9
          VIEW-AS TOGGLE-BOX
          SIZE 31 BY .88
     tt-param-af.log-elimina-relac AT ROW 8.71 COL 4.57
          VIEW-AS TOGGLE-BOX
          SIZE 34 BY .88
     "Controle de validade conforme" VIEW-AS TEXT
          SIZE 21 BY .88 AT ROW 2.5 COL 46
     "Vers‰es" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 1.29 COL 5
     RECT-49 AT ROW 1.5 COL 3
     RECT-50 AT ROW 8.42 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 12
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-param-af T "?" NO-UNDO mgcad param-af
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
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 38.21
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.21
         VIRTUAL-WIDTH      = 182.86
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
/* SETTINGS FOR TOGGLE-BOX tt-param-af.log-usa-versao IN FRAME fPage1
   EXP-LABEL                                                            */
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
    RUN emptyRowErrors IN h-boaf022.

    RUN atualizaCampos IN THIS-PROCEDURE.

    RUN setRecord IN h-boaf022 (INPUT TABLE tt-param-af).

    RUN pi-salva-valor-antigo IN h-afapi003 (INPUT 'param-af':U, INPUT tt-param-af.r-rowid).

    RUN updateRecord IN h-boaf022.

    IF  RETURN-VALUE = "NOK":U THEN DO:
        RUN getRowErrors IN h-boaf022 (OUTPUT TABLE RowErrors).        
        IF CAN-FIND(FIRST RowErrors) THEN DO: 
            {method/showmessage.i1} 
            {method/showmessage.i2 &modal="YES"} 
            {method/showmessage.i3}
        END.
    END.
        ELSE DO:  
            
            RUN pi-salva-alteracao IN h-afapi003 (INPUT 'param-af':U, 
                                                  INPUT tt-param-af.r-rowid,
                                                  INPUT 'AF0101':U).
            APPLY "CLOSE":U TO THIS-PROCEDURE.            
        END.
                
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOPenHist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOPenHist wWindow
ON CHOOSE OF btOPenHist IN FRAME fpage0 /* Open History */
DO:
   DEFINE VARIABLE hProgram          AS HANDLE NO-UNDO.
    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).
    {&WINDOW-NAME}:SENSITIVE = NO.               

    RUN afp/af0602.w PERSISTENT SET hProgram.

   /** Validaªío do Handle **/
   IF  VALID-HANDLE(hProgram) AND
       hProgram:TYPE = "PROCEDURE":U AND
       hProgram:FILE-NAME = "afp/af0602.w":U THEN DO:
       /*--- Inicializa programa de alteraªío dos par≥metros ---*/
       RUN initializeInterface IN hProgram. 
       /*Passa os parÉmetros para executar a tela*/
       RUN pi-executa-tela IN hProgram(INPUT "param-af":U, INPUT STRING(tt-param-af.seq-param-af)).
   END.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-param-af.log-usa-versao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-af.log-usa-versao wWindow
ON VALUE-CHANGED OF tt-param-af.log-usa-versao IN FRAME fPage1 /* Utiliza controle de vers∆o */
DO:
  RUN pi-habilita-campos.
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


&Scoped-define FRAME-NAME fpage0
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
  Purpose: Destoi a referància da boaf022
  Parameters:
  Notes:       
------------------------------------------------------------------------------*/
    IF  VALID-HANDLE(h-boaf022)        AND
        h-boaf022:TYPE = "PROCEDURE":U AND
        h-boaf022:FILE-NAME = "afbo/boaf022.p":U THEN DO:
        DELETE PROCEDURE h-boaf022.
        ASSIGN h-boaf022 = ?.
    END.
    
    IF VALID-HANDLE(h-afapi003) THEN DO:
        DELETE PROCEDURE h-afapi003.
        ASSIGN h-afapi003 = ?.
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

RUN pi-habilita-campos.

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
RUN pi-habilita-campos.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaCampos wWindow 
PROCEDURE atualizaCampos :
/*------------------------------------------------------------------------------
  Purpose: Alimentar a Temp-Table com os valores da tela    
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN tt-param-af.log-usa-versao         = tt-param-af.log-usa-versao:CHECKED IN FRAME fPage1            
           tt-param-af.log-elimina-relac      = tt-param-af.log-elimina-relac:CHECKED IN FRAME fPage1
           tt-param-af.log-versao-demerito    = tt-param-af.log-versao-demerito:CHECKED IN FRAME fPage1
           tt-param-af.log-versao-formula     = tt-param-af.log-versao-formula:CHECKED IN FRAME fPage1
           tt-param-af.i-tipo-validade-versao = INPUT FRAME fPage1 tt-param-af.i-tipo-validade-versao.
           
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose: Seta valores Default e inicializa os componentes antes de iniciar a 
            interface.
  Parameters:
  Notes:       
------------------------------------------------------------------------------*/
    RUN initializeDBOs IN THIS-PROCEDURE.    
    
    RUN goToKey IN h-boaf022 (INPUT 1, INPUT v_cdn_empres_usuar).

    /* Registro de parÉmetros ainda n∆o existe - Necess†rio criar */
    IF RETURN-VALUE = "NOK":U THEN DO:
        CREATE tt-param-af.        

        ASSIGN tt-param-af.seq-param-af = 1
               tt-param-af.ep-codigo = v_cdn_empres_usuar.

        RUN emptyRowErrors IN h-boaf022.

        RUN setRecord IN h-boaf022 (INPUT TABLE tt-param-af).
        RUN createRecord IN h-boaf022.
    END.
    ELSE DO:
        /* Busca o registro de parÉmetros */
        RUN getRecord IN h-boaf022 (OUTPUT TABLE tt-param-af).

        FIND FIRST tt-param-af NO-LOCK NO-ERROR.   
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose: Referànciar a boaf022 na vari†vel h-boaf022 
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
    
    IF NOT VALID-HANDLE(h-boaf022)
        OR h-boaf022:TYPE      <> "PROCEDURE":U
        OR h-boaf022:FILE-NAME <> "afbo/boaf022.p":U THEN
        RUN afbo/boaf022.p PERSISTENT SET h-boaf022.

    RUN openQueryStatic IN h-boaf022 (INPUT "Main":U) NO-ERROR.
    
    RUN afp/afapi003.p PERSISTENT SET h-afapi003.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos wWindow 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para habilitar/Desabilitar os campos
               Usa vers∆o faixa demÇrito e Usa vers∆o f¢rmula
               Habilita os campos se Utiliza controle de vers∆o estiver habilitado
               Desabilita e limpa os campos caso n∆o
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

IF tt-param-af.log-usa-versao:CHECKED IN FRAME fpage1 THEN DO:
    ENABLE tt-param-af.log-versao-demerito
           tt-param-af.log-versao-formula
           tt-param-af.i-tipo-validade-versao
        WITH FRAME fpage1.
END.
ELSE DO:
    ASSIGN tt-param-af.log-versao-demerito:CHECKED IN FRAME fpage1 = FALSE
           tt-param-af.log-versao-formula:CHECKED IN FRAME fpage1 = FALSE
           tt-param-af.i-tipo-validade-versao:SCREEN-VALUE IN FRAME fPage1 = "1".

    DISABLE tt-param-af.log-versao-demerito
            tt-param-af.log-versao-formula
            tt-param-af.i-tipo-validade-versao
     WITH FRAME fpage1.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

