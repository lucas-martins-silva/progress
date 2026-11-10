&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          rtb              PROGRESS
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
{include/i-prgvrs.i IM0000AB 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0000AB MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0000AB
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 bt-calcula de-base-calculo
                              
/*&GLOBAL-DEFINE ttParent         tt-variaveis
 * &GLOBAL-DEFINE hDBOParent       h-bovar
 * &GLOBAL-DEFINE DBOParentTable   variaveis
 * &GLOBAL-DEFINE DBOParentDestroy YES
 * 
 * &GLOBAL-DEFINE ttSon1           tt-variaveis
 * &GLOBAL-DEFINE hDBOSon1         h-bovar2
 * &GLOBAL-DEFINE DBOSon1Table     tt-variaveis
 * &GLOBAL-DEFINE DBOSon1Destroy   YES*/
                              
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Global Variable Definitions ---                                       */

  
/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER c-formula AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE rowsreturn           AS integer NO-UNDO. 
/*DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.*/

{cdp/cdcfgdis.i}    /* Defini‡Æo pre-processador */
{cdp/cdcfgmat.i}    /* Defini‡Æo pre-processador */

DEFINE TEMP-TABLE tt-variaveis no-undo
    field nome-variavel  as char format "x(30)"
    field descricao as char format "x(40)"
    FIELD valor AS DECIMAL FORMAT ">>>>>>>>>9.99" LABEL "Valor"
    FIELD sequencia AS INTEGER
        index nome is primary unique 
          nome-variavel.


&IF defined(bf-mat-comex) &then
   {cdp/cdapi031.i}
&else
   {cdp/cdapi020.i}
&endif

{cdp/cd0666.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-variaveis

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 tt-variaveis.nome-variavel tt-variaveis.descricao tt-variaveis.valor   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 tt-variaveis.valor   
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-1 tt-variaveis percentual Ex
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-1 tt-variaveis
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-BROWSE-1 percentual
&Scoped-define THIRD-ENABLED-TABLE-IN-QUERY-BROWSE-1 Ex
&Scoped-define SELF-NAME BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY {&SELF-NAME} FOR EACH tt-variaveis  NO-LOCK by tt-variaveis.sequencia.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 tt-variaveis
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 tt-variaveis


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btQueryJoins btReportsJoins btExit btHelp ~
de-base-calculo bt-calcula btOK btCancel btHelp2 rtToolBar rtToolBar-2 
&Scoped-Define DISPLAYED-OBJECTS de-base-calculo 

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
DEFINE BUTTON bt-calcula 
     IMAGE-UP FILE "image/im-calc2.bmp":U
     LABEL "Button 9" 
     SIZE 5 BY 1.13 TOOLTIP "Calcula".

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

DEFINE VARIABLE de-base-calculo AS DECIMAL FORMAT "->>>>>>>>>9.99":U INITIAL 0 
     LABEL "Resultado" 
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 82.86 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 82.72 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      tt-variaveis SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 wWindow _FREEFORM
  QUERY BROWSE-1 DISPLAY
      tt-variaveis.nome-variavel label "Nome Variavel" format "x(25)"
      tt-variaveis.descricao label "Descri‡Æo" format "x(35)"
      tt-variaveis.valor LABEL "Valor" 
    ENABLE
      tt-variaveis.valor HELP "Nas al¡quotas informar percentual. Ex.: informar 10 para 10%"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 78.43 BY 7.5
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.17 COL 67.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.17 COL 71.29 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.17 COL 75.29 HELP
          "Sair"
     btHelp AT ROW 1.17 COL 79.29 HELP
          "Ajuda"
     de-base-calculo AT ROW 12.25 COL 74.86 RIGHT-ALIGNED HELP
          "Resultado da aplica‡Æo da f¢rmula."
     bt-calcula AT ROW 12.25 COL 76
     btOK AT ROW 13.96 COL 2
     btCancel AT ROW 13.96 COL 13
     btHelp2 AT ROW 14 COL 73.43
     rtToolBar AT ROW 13.75 COL 1
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.57 BY 14.63
         FONT 1.

DEFINE FRAME fPage2
     BROWSE-1 AT ROW 1.75 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 3
         SIZE 82.86 BY 9
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
         HEIGHT             = 14.71
         WIDTH              = 83.57
         MAX-HEIGHT         = 18.96
         MAX-WIDTH          = 105
         VIRTUAL-HEIGHT     = 18.96
         VIRTUAL-WIDTH      = 105
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
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN de-base-calculo IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB BROWSE-1 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-variaveis  NO-LOCK by tt-variaveis.sequencia.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 wWindow
ON MOUSE-SELECT-DBLCLICK OF BROWSE-1 IN FRAME fPage2
DO:
  apply "value-changed" to browse-1 in frame fpage2.
  apply "choose" to btOk in frame fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 wWindow
ON VALUE-CHANGED OF BROWSE-1 IN FRAME fPage2
DO:
    if avail tt-variaveis then do:  
        if browse-1:num-selected-rows in frame fPage2 = 0 then do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Nenhum_Registro_Foi_Selecionado" *}
            message RETURN-VALUE.
        end.
        if browse-1:num-selected-rows in frame fPage2 <> 0 then do:
             browse browse-1:fetch-selected-row(int(browse-1:num-selected-rows)).
             assign nome-variavel =  tt-variaveis.nome-variavel.
        end.
    end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-calcula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-calcula wWindow
ON CHOOSE OF bt-calcula IN FRAME fpage0 /* Button 9 */
DO:
    /* Formula calculo base PIS */
    FOR EACH tt-formula:
        DELETE tt-formula.
    END.

    FOR EACH tt-var:
        DELETE tt-var.
    END.

    CREATE tt-formula.
    ASSIGN tt-formula.formula = c-formula
           tt-formula.cod-versao-integracao = 001.

    FIND tt-variaveis WHERE
        tt-variaveis.nome-variavel = "VA" NO-LOCK NO-ERROR.

    CREATE tt-var.
    ASSIGN tt-var.nome      = "VA"
           tt-var.valor     = tt-variaveis.valor.
           tt-var.tipo-res  = 1.

    FIND tt-variaveis WHERE
       tt-variaveis.nome-variavel = "DA" NO-LOCK NO-ERROR.
    
    CREATE tt-var.
    ASSIGN tt-var.nome      = "DA"
           tt-var.valor     = tt-variaveis.valor
           tt-var.tipo-res  = 1.

    FIND tt-variaveis WHERE
        tt-variaveis.nome-variavel = "a" NO-LOCK NO-ERROR.
    
    CREATE tt-var.
    ASSIGN tt-var.nome      = "a"
           tt-var.valor     = tt-variaveis.valor / 100
           tt-var.tipo-res  = 1.

    FIND tt-variaveis WHERE
        tt-variaveis.nome-variavel = "b" NO-LOCK NO-ERROR.
    
    CREATE tt-var.
    ASSIGN tt-var.nome      = "b"
           tt-var.valor     = tt-variaveis.valor / 100
           tt-var.tipo-res  = 1.

    FIND tt-variaveis WHERE
        tt-variaveis.nome-variavel = "c" NO-LOCK NO-ERROR.

    CREATE tt-var.
    ASSIGN tt-var.nome      = "c"
           tt-var.valor     = tt-variaveis.valor / 100
           tt-var.tipo-res  = 1.  

    FIND tt-variaveis WHERE
        tt-variaveis.nome-variavel = "d" NO-LOCK NO-ERROR.
    
    CREATE tt-var.
    ASSIGN tt-var.nome      = "d"
           tt-var.valor     = tt-variaveis.valor / 100
           tt-var.tipo-res  = 1.

    FIND tt-variaveis WHERE
        tt-variaveis.nome-variavel = "e" NO-LOCK NO-ERROR.
    
    CREATE tt-var.
    ASSIGN tt-var.nome      = "e"
           tt-var.valor     = tt-variaveis.valor / 100
           tt-var.tipo-res  = 1.
    
    &IF defined(bf-mat-comex) &then
       RUN cdp/cdapi031.p (INPUT-OUTPUT TABLE tt-formula,
                           INPUT TABLE tt-var,
                           INPUT-OUTPUT TABLE tt-erro,
                           INPUT YES).
    &else
       RUN cdp/cdapi020.p (INPUT-OUTPUT TABLE tt-formula,
                           INPUT TABLE tt-var,
                           INPUT-OUTPUT TABLE tt-erro,
                           INPUT YES).
    &endif

    IF CAN-FIND(FIRST tt-erro) THEN DO:
        FOR EACH tt-erro.
            MESSAGE tt-erro.cd-erro "-" tt-erro.mensagem VIEW-AS ALERT-BOX ERROR.
        END.
    END.
    ELSE DO: 
        FIND FIRST tt-formula NO-LOCK NO-ERROR.
        ASSIGN de-base-calculo = tt-formula.RESULT.
        DISP de-base-calculo WITH FRAME {&FRAME-NAME}.
    END.
        
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializa‡Æo do programam ---*/
{window/MainBlock.i}

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
    enable browse-1 
         with frame fpage2.
    apply "entry" to browse-1 in frame fpage2.
             
    run initializeDBos in this-procedure.
   
    RETURN "OK":U.          
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

    /* A vari vel c-program vem carregada com o programa que foi o chamador */
    create tt-variaveis.
    assign tt-variaveis.nome-variavel = "VA"
           tt-variaveis.descricao     = "Valor Aduaneiro"
           tt-variaveis.sequencia     = 1.

    create tt-variaveis.
    assign tt-variaveis.nome-variavel = "a"
           tt-variaveis.descricao     = "Al¡quota do Imposto de Importa‡Æo"
           tt-variaveis.sequencia     = 3.

    create tt-variaveis.
    assign tt-variaveis.nome-variavel = "b"
           tt-variaveis.descricao     = "Al¡quota do IPI"
           tt-variaveis.sequencia     = 4.

    create tt-variaveis.
    assign tt-variaveis.nome-variavel = "c"
           tt-variaveis.descricao     = "Al¡quota do PIS/PASEP Importa‡Æo"
           tt-variaveis.sequencia     = 5.

    create tt-variaveis.
    assign tt-variaveis.nome-variavel = "d"
           tt-variaveis.descricao     = "Al¡quota do COFINS Importa‡Æo"
           tt-variaveis.sequencia     = 6.

    create tt-variaveis.
    assign tt-variaveis.nome-variavel = "e"
           tt-variaveis.descricao     = "Al¡quota do ICMS"
           tt-variaveis.sequencia     = 7.

    create tt-variaveis.
    assign tt-variaveis.nome-variavel = "DA"
           tt-variaveis.descricao = "Despesas Aduaneiras"
           tt-variaveis.sequencia     = 2.
                                                                                                
    {&OPEN-QUERY-BROWSE-1}
  
    apply "entry" to browse-1 in frame fpage2.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

