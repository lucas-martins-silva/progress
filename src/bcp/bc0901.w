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
{include/i-prgvrs.i BC0901 2.00.00.008 } /*** "010008" 09/10/2025 11:26:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC0901 MBC}
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
&GLOBAL-DEFINE Program        BC0901
&GLOBAL-DEFINE Version        2.00.00.008

&GLOBAL-DEFINE WindowType     Master
/*
&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   <Folder1 ,Folder 2 ,... , Folder8>
*/
&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 btConnect btRefresh ~
                              btClearError btStop btRestart br-info
                              
                              
/*
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
*/
/* Parameters Definitions ---                                           */

/* handle do programa de procedures */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE                   VARIABLE wh-pesquisa    AS HANDLE NO-UNDO.



/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cLevel AS CHARACTER        NO-UNDO INIT "1".
DEFINE VARIABLE cNoId  AS CHARACTER        NO-UNDO.
Define Variable vLtr   As Character        No-undo.
Define Variable vLtr1  As Character        No-undo.
Define Variable vLtr2  As Character        No-undo.
Define Variable vLtr3  As Character        No-undo.
Define Variable vLtr4  As Character        No-undo.
Define Variable vLtr5  As Character        No-undo.
Define Variable vLtr6  As Character        No-undo.



DEF VAR chTreeRoot   AS com-handle no-undo. 
DEF VAR chTreeServid AS com-handle no-undo.
DEF VAR chColetor    AS com-handle no-undo.
DEF VAR vNewItem     AS com-handle no-undo.

/* Temp Table Definitions ---                                           */
DEFINE TEMP-TABLE ttInfCol NO-UNDO
    FIELD sequencia             AS INTEGER   FORMAT ">>>>9":U LABEL "Seq Erro"
    FIELD infColServ            AS CHARACTER FORMAT "x(30)":U LABEL "Informaá∆o"
    FIELD numColServ            AS CHARACTER FORMAT "x(5)":U  LABEL "N£meros"
    FIELD infColUser            AS CHARACTER FORMAT "x(30)":U LABEL "Informaá∆o"
    FIELD numColUser            AS CHARACTER FORMAT "x(30)":U LABEL "N£meros"
    FIELD cparam                AS CHARACTER FORMAT "x(30)":U LABEL "ParÉmetro"
    FIELD valor                 AS CHARACTER FORMAT "x(30)":U LABEL "Valor"
    FIELD descparam             AS CHARACTER FORMAT "x(30)":U LABEL "Descriá∆o do ParÉmetro"
    FIELD usuario               AS CHARACTER FORMAT "x(30)":U LABEL "Usu†rio"
    FIELD dtErro                AS CHARACTER FORMAT "x(30)":U LABEL "Dt Erro"
    FIELD hrErro                AS CHARACTER FORMAT "x(30)":U LABEL "Hr Erro"
    FIELD ErroCol               AS CHARACTER FORMAT "x(30)":U LABEL "Erro Col"
    FIELD descErro              AS CHARACTER FORMAT "x(50)":U LABEL "Descriá∆o"
    FIELD pos                   AS CHARACTER FORMAT "x(50)":U LABEL ""
    INDEX chEstr IS UNIQUE PRIMARY sequencia.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-info

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttInfCol

/* Definitions for BROWSE br-info                             */
&Scoped-define FIELDS-IN-QUERY-br-info ttInfCol.sequencia ttInfCol.infColServ ttInfCol.numColServ ttInfCol.infColUser ttInfCol.numColUser ttInfCol.cparam ttInfCol.valor ttInfCol.descparam ttInfCol.usuario ttInfCol.dtErro ttInfCol.hrErro ttInfCol.ErroCol ttInfCol.descErro
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-info   
&Scoped-define SELF-NAME br-info
&Scoped-define QUERY-STRING-br-info FOR EACH ttInfCol NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-info OPEN QUERY {&SELF-NAME} FOR EACH ttInfCol NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-info ttInfCol
&Scoped-define FIRST-TABLE-IN-QUERY-br-info ttInfCol

/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-info}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btQueryJoins btReportsJoins btExit btHelp ~
btStop btRestart btConnect btDisconnect btRefresh btClearError btOK ~
btCancel btHelp2 RECT-1 rtToolBar rtToolBar-2 br-info

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM mStop          LABEL "&Parar"        
       MENU-ITEM mRestart       LABEL "&Reiniciar"    
       RULE
       MENU-ITEM mConnect       LABEL "&Conectar"     
       MENU-ITEM mDisconnect    LABEL "&Desconectar"  
       MENU-ITEM mRefresh       LABEL "&Atualizar"    
       MENU-ITEM mClearError    LABEL "&Eliminar Erros"
       RULE
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

/* Eventos treeview*/
{utp/ut-4gltreeview.i}

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btClearError 
     IMAGE-UP FILE "image/im-lixo.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-lixo.bmp":U
     LABEL "" 
     SIZE 5 BY 1.13 TOOLTIP "Limpa os Erros do Coletor Selecionado".

DEFINE BUTTON btConnect 
     IMAGE-UP FILE "image/conecta.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-conecta.bmp":U NO-CONVERT-3D-COLORS
     LABEL "Button 2" 
     SIZE 5 BY 1.13 TOOLTIP "Conecta Todos os Coletores abaixo do item Selecionado".

DEFINE BUTTON btDisconnect 
     IMAGE-UP FILE "image/desconecta.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-desconecta.bmp":U
     LABEL "btDisconnect" 
     SIZE 5 BY 1.13 TOOLTIP "Desconecta Todos os Coletores abaixo do item Selecionado".

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

DEFINE BUTTON btRefresh 
     IMAGE-UP FILE "image/im-relo.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-relo.bmp":U
     LABEL "" 
     SIZE 5 BY 1.13 TOOLTIP "Atualizar Dados do Gerenciador".

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btRestart 
     IMAGE-UP FILE "image/im-rstsr.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-rstsr.bmp":U NO-CONVERT-3D-COLORS
     LABEL "btRestart" 
     SIZE 5 BY 1.13 TOOLTIP "Conecta Todos os Coletores abaixo do item Selecionado".

DEFINE BUTTON btStop 
     IMAGE-UP FILE "image/im-stosr.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-stosr.bmp":U NO-CONVERT-3D-COLORS
     LABEL "btStop" 
     SIZE 5 BY 1.13 TOOLTIP "Conecta Todos os Coletores abaixo do item Selecionado".

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 11.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.54
     BGCOLOR 7 .
       
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-info FOR 
      ttInfCol SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-info
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-info wWindow _FREEFORM
  QUERY br-info NO-LOCK DISPLAY
      ttInfCol.sequencia 
      ttInfCol.infColServ
      ttInfCol.numColServ
      ttInfCol.infColUser
      ttInfCol.numColUser 
      ttInfCol.cparam
      ttInfCol.valor
      ttInfCol.descparam
      ttInfCol.usuario
      ttInfCol.dtErro
      ttInfCol.hrErro
      ttInfCol.ErroCol
      ttInfCol.descErro
      ttInfCol.pos
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 53.43 BY 11.20
         FONT 1 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.
       
/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     btStop AT ROW 1.21 COL 1.86 HELP
          "Conecta Todos os Coletores abaixo do item Selecionado"
     btRestart AT ROW 1.21 COL 7 HELP
          "Conecta Todos os Coletores abaixo do item Selecionado"
     btConnect AT ROW 1.25 COL 17.14 HELP
          "Conecta Todos os Coletores abaixo do item Selecionado"
     btDisconnect AT ROW 1.25 COL 22.14 HELP
          "Desconecta Todos os Coletores abaixo do item Selecionado"
     btRefresh AT ROW 1.25 COL 27.14 HELP
          "Atualizar Dados do Gerenciador"
     btClearError AT ROW 1.25 COL 32.14 HELP
          "Limpa os Erros do Coletor Selecionado"
     br-info AT ROW 2.96 COL 36.57 WIDGET-ID 100
     btOK AT ROW 14.92 COL 2
     btCancel AT ROW 14.92 COL 13
     btHelp2 AT ROW 14.92 COL 80
     RECT-1 AT ROW 2.71 COL 1.72
     rtToolBar AT ROW 14.67 COL 1
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.57 BY 15.33
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
         HEIGHT             = 15.33
         WIDTH              = 90.57
         MAX-HEIGHT         = 26.96
         MAX-WIDTH          = 160
         VIRTUAL-HEIGHT     = 26.96
         VIRTUAL-WIDTH      = 160
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 1
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{bcp/bc9117.i}
{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-info btClearError fpage0 */
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
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btClearError
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btClearError wWindow
ON CHOOSE OF btClearError IN FRAME fpage0
DO:
  FOR EACH bc-coletor-erro EXCLUSIVE-LOCK
     WHERE bc-coletor-erro.id-coletor = cNoID:

      DELETE bc-coletor-erro.
  END.
  RUN pi-atualizaTreeview.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConnect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConnect wWindow
ON CHOOSE OF btConnect IN FRAME fpage0 /* Button 2 */
DO:
    IF c-codigo-node BEGINS "t" THEN DO:
       ASSIGN cNoID = TRIM(ENTRY(1, ENTRY(3,c-codigo-node,'|'),':':U)). 
       RUN piConectaColetor(INPUT cNoID,INPUT YES).
       RUN pi-atualizaTreeview.
    END.
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDisconnect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDisconnect wWindow
ON CHOOSE OF btDisconnect IN FRAME fpage0 /* btDisconnect */
DO:
    IF c-codigo-node BEGINS "t" THEN DO:    
       ASSIGN cNoID = TRIM(ENTRY(1, ENTRY(3,c-codigo-node,'|'),':':U)).
       RUN piConectaColetor(INPUT cNoID,INPUT NO).
       RUN pi-atualizaTreeview.
    END.   
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
  RETURN NO-APPLY.
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


&Scoped-define SELF-NAME btRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRefresh wWindow
ON CHOOSE OF btRefresh IN FRAME fpage0
DO:
  RUN pi-atualizaTreeview.
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


&Scoped-define SELF-NAME btRestart
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRestart wWindow
ON CHOOSE OF btRestart IN FRAME fpage0 /* btRestart */
DO:
    IF c-codigo-node BEGINS "i" THEN DO:
        ASSIGN cNoID = TRIM(ENTRY(1, ENTRY(2,c-codigo-node,'|'),':':U)).
        {utp/ut-liter.i Vocà_esta_prestes_a_Reiniciar_o_Servidor_de_Coletores_ *}
        Assign vLtr = Return-value.
        {utp/ut-liter.i Caso_o_servidor_seja_reiniciado,_todos_os_coletores *}
        Assign vLtr1 = Return-value.
        {utp/ut-liter.i relacionados_a_este_servidor_ser∆o_desativados,e_as_sess‰es *}
        Assign vLtr2 = Return-value.
        {utp/ut-liter.i destes_usu†rios_ir∆o_cair *}
        Assign vLtr3 = Return-value.
        {utp/ut-liter.i Deseja_realmente_reiniciar_o_Servidor_ *}
        Assign vLtr4 = Return-value.
        {utp/ut-liter.i Desativar_Servidor *}

        MESSAGE vLtr cNoID Skip " " Skip
                 vLtr1 Skip
                 vLtr2 Skip
                 vLtr3 Skip " " Skip
                 vLtr4 cNoId " ?"
            VIEW-AS ALERT-BOX 
            Question BUTTONS Yes-no-cancel 
            Title Return-value
            Update cEscolha As Logical.
        If cEscolha Then Do:
           FIND FIRST servid_exec
            WHERE servid_exec.cod_servid_exec = cNoID Exclusive-lock NO-ERROR.
           If Avail servid_exec Then
               ASSIGN servid_exec.log_servid_exec_ativ   = Yes
                      servid_exec.log_servid_exec_bloqdo   = NO.
           Release servid_exec.
           RUN pi-atualizaTreeview.
        End.
    END.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btStop
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btStop wWindow
ON CHOOSE OF btStop IN FRAME fpage0 /* btStop */
DO:
    IF c-codigo-node BEGINS "i" THEN DO:
        {utp/ut-liter.i Vocà_esta_prestes_a_desativar_o_Servidor_de_Coletores_ *}
        Assign vLtr = Return-value.
        {utp/ut-liter.i Caso_o_servidor_seja_desativado,_todos_os_coletores *}
        Assign vLtr1 = Return-value.
        {utp/ut-liter.i relacionados_a_este_servidor_tambÇm_ser∆o_desativados, *}
        Assign vLtr2 = Return-value.
        {utp/ut-liter.i e_n∆o_ser†_poss°vel_reiniciar_este_coletor_remotamente. *}
        Assign vLtr3 = Return-value.
        {utp/ut-liter.i Deseja_realmente_desativar_o_Servidor_ *}
        Assign vLtr4 = Return-value.
        {utp/ut-liter.i Desativar_Servidor *}

        MESSAGE vLtr cNoID Skip " " Skip
                vLtr1 Skip
                vLtr2 Skip
                vLtr3 Skip " " Skip
                vLtr4 cNoId " ?"
           VIEW-AS ALERT-BOX 
           Question BUTTONS Yes-no-cancel 
           Title Return-value
           Update cEscolha As Logical.
       If cEscolha Then Do:
           FIND FIRST servid_exec
            WHERE servid_exec.cod_servid_exec = cNoID Exclusive-lock NO-ERROR.
           If Avail servid_exec Then
               ASSIGN servid_exec.log_servid_exec_ativ   = NO
                      servid_exec.log_servid_exec_bloqdo   = NO.
           Release servid_exec.
           RUN pi-atualizaTreeview.
       End.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mClearError
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mClearError wWindow
ON CHOOSE OF MENU-ITEM mClearError /* Eliminar Erros */
DO:
    APPLY "CHOOSE":U TO btClearError IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mConnect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mConnect wWindow
ON CHOOSE OF MENU-ITEM mConnect /* Conectar */
DO:
    APPLY "CHOOSE":U TO btConnect    IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mDisconnect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mDisconnect wWindow
ON CHOOSE OF MENU-ITEM mDisconnect /* Desconectar */
DO:
    APPLY "CHOOSE":U TO btDisconnect IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mRefresh wWindow
ON CHOOSE OF MENU-ITEM mRefresh /* Atualizar */
DO:
    APPLY "CHOOSE":U TO btRefresh    IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mRestart
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mRestart wWindow
ON CHOOSE OF MENU-ITEM mRestart /* Reiniciar */
DO:
    APPLY "CHOOSE":U TO btRestart    IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mStop
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mStop wWindow
ON CHOOSE OF MENU-ITEM mStop /* Parar */
DO:
    APPLY "CHOOSE":U TO btStop       IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME smFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL smFile wWindow
ON MENU-DROP OF MENU smFile /* Arquivo */
DO:
    assign menu-item mStop      :SENSITIVE in menu smFile = btStop       :SENSITIVE IN FRAME fPage0.
    assign menu-item mRestart   :SENSITIVE in menu smFile = btRestart    :SENSITIVE IN FRAME fPage0.
    assign menu-item mConnect   :SENSITIVE in menu smFile = btConnect    :SENSITIVE IN FRAME fPage0.
    assign menu-item mDisconnect:SENSITIVE in menu smFile = btDisconnect :SENSITIVE IN FRAME fPage0.
    assign menu-item mRefresh   :SENSITIVE in menu smFile = btRefresh    :SENSITIVE IN FRAME fPage0.
    assign menu-item mClearError:SENSITIVE in menu smFile = btClearError :SENSITIVE IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-info
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializaá∆o do programa ---*/
{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF NOT VALID-HANDLE(h-4gltreeview) THEN DO:
   
      RUN utp/ut-4gltreeview.w PERSISTENT SET h-4gltreeview.
   
      RUN setParentFrame IN h-4gltreeview (INPUT FRAME fPage0:HANDLE).

      RUN initializeObject IN h-4gltreeview.
   
      SUBSCRIBE TO "tvNodeEvent" IN h-4gltreeview.

      RUN repositionObject IN h-4gltreeview (2.96, 2.72).

      RUN resizeObject IN h-4gltreeview (11.25, 33.00).
   END.
    
   RUN pi-atualizaTreeview.
   
   RUN piPopulateIt.
   
   RUN pi-ClickTreeView.
   
   RUN applyEntry IN h-4gltreeview (INPUT "").

   


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piConectaColetor wWindow 
PROCEDURE piConectaColetor :
/*------------------------------------------------------------------------------
  Purpose:  Roda Programa com DLL e envia requisiá∆o de conex∆o   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pIdColetor    AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER pConecta      AS LOGICAL       NO-UNDO.

FIND FIRST bc-param-ext EXCLUSIVE-LOCK
    WHERE  bc-param-ext.cod-entidade-param-ext = "bc-coletor"
       And bc-param-ext.cod-param-ext = "RequisConexao"
       AND bc-param-ext.cod-chave-param-ext = pIdColetor NO-ERROR.

       /* Tratamento para caso n∆o exista o parametro NmProgCom */
IF AVAIL bc-param-ext THEN
   ASSIGN bc-param-ext.param-inteiro = IF pConecta THEN 1 ELSE 2.
RELEASE bc-param-ext.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ClickTreeView wWindow 
PROCEDURE pi-ClickTreeView :
/*------------------------------------------------------------------------------
  Purpose: Faz a atualizaá∆o do ListView    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lExistNo       AS LOGICAL           NO-UNDO.
DEFINE VARIABLE iImage         AS INTEGER           NO-UNDO.
DEFINE VARIABLE iNrServid      AS INTEGER    INIT 0 NO-UNDO.
DEFINE VARIABLE iNrServidAtiv  AS INTEGER    INIT 0 NO-UNDO.
DEFINE VARIABLE iNrColetor     AS INTEGER    INIT 0 NO-UNDO.
DEFINE VARIABLE iNrColetorAtiv AS INTEGER    INIT 0 NO-UNDO.
DEFINE VARIABLE iSeq           AS INTEGER    INIT 0 NO-UNDO.
DEFINE VARIABLE cCodColetor    AS CHARACTER         NO-UNDO.
DEFINE VARIABLE cParametro     AS CHARACTER         NO-UNDO.

EMPTY TEMP-TABLE ttInfCol.

ASSIGN iSeq  = 0
       cNoID = "".

IF c-codigo-node BEGINS "i" THEN
    ASSIGN cNoID = TRIM(ENTRY(1, ENTRY(2,c-codigo-node,'|'),':':U)).
IF c-codigo-node BEGINS "t"
  OR c-codigo-node BEGINS "m" THEN    
   ASSIGN cNoID = TRIM(ENTRY(1, ENTRY(3,c-codigo-node,'|'),':':U)).
    
IF c-codigo-node BEGINS "p"
   OR c-codigo-node = "" THEN DO:
          
    FOR EACH bc-coletor NO-LOCK:
       IF CAN-FIND(FIRST bc-param-ext WHERE bc-param-ext.cod-entidade-param-ext = "bc-coletor"
                                        And bc-param-ext.cod-param-ext       = "ConectadoColetor"
                                        AND bc-param-ext.cod-chave-param-ext = bc-coletor.Id-Coletor
                                        AND bc-param-ext.param-logico) THEN
          ASSIGN iNrColetorAtiv = iNrColetorAtiv + 1.
       ASSIGN iNrColetor = iNrColetor + 1.
    END.
    
    CREATE ttInfCol.
    {utp/ut-liter.i Coletores_Ativos *}
    ASSIGN ttInfCol.sequencia  = 1
           ttInfCol.infColServ = RETURN-VALUE
           ttInfCol.numColServ = TRIM(STRING(iNrColetorAtiv)) + "/" + TRIM(STRING(iNrColetor)).   
    
    For Each bc-param-ext No-lock
       Where bc-param-ext.cod-entidade-param-ext = "bc-coletor"
         And bc-param-ext.cod-param-ext = "ServidorExec" BREAK BY bc-param-ext.param-caracter:
      IF FIRST-OF(bc-param-ext.param-caracter) THEN DO:
          FIND FIRST servid_exec NO-LOCK 
               WHERE servid_exec.cod_servid_exec = bc-param-ext.param-caracter NO-ERROR.
          IF AVAIL servid_exec THEN
            ASSIGN iNrServidAtiv = iNrServidAtiv + IF servid_exec.log_servid_exec_ativ THEN 1 ELSE 0
                   iNrServid     = iNrServid + 1.
      END.
    END.
    
    CREATE ttInfCol.
    {utp/ut-liter.i Servidores_Ativos *}
    ASSIGN ttInfCol.sequencia  = 2
           ttInfCol.infColServ = RETURN-VALUE
           ttInfCol.numColServ = TRIM(STRING(iNrServidAtiv)) + "/" + TRIM(STRING(iNrServid)).
           
    ASSIGN ttInfCol.sequencia:VISIBLE IN BROWSE br-info = NO
           ttInfCol.infColServ:VISIBLE IN BROWSE br-info = YES 
           ttInfCol.numColServ:VISIBLE IN BROWSE br-info = YES
           ttInfCol.pos:VISIBLE IN BROWSE br-info = YES
           ttInfCol.infColUser:VISIBLE IN BROWSE br-info = NO
           ttInfCol.numColUser:VISIBLE IN BROWSE br-info = NO
           ttInfCol.cparam:VISIBLE IN BROWSE br-info = NO
           ttInfCol.valor:VISIBLE IN BROWSE br-info = NO
           ttInfCol.descparam:VISIBLE IN BROWSE br-info = NO
           ttInfCol.usuario:VISIBLE IN BROWSE br-info = NO
           ttInfCol.dtErro:VISIBLE IN BROWSE br-info = NO
           ttInfCol.hrErro:VISIBLE IN BROWSE br-info = NO
           ttInfCol.ErroCol:VISIBLE IN BROWSE br-info = NO
           ttInfCol.descErro:VISIBLE IN BROWSE br-info = NO
           ttInfCol.infColServ:WIDTH-CHAR IN BROWSE br-info = 25
           ttInfCol.numColServ:WIDTH-CHAR IN BROWSE br-info = 10.  
       
    {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}  
               
    DISABLE btDisconnect btConnect btStop btRestart WITH FRAME {&FRAME-NAME}.

END.
IF c-codigo-node BEGINS "i" THEN DO:
   ASSIGN lExistNo  = NO.
   FOR EACH bc-param-ext Where bc-param-ext.cod-entidade-param-ext = "bc-coletor"
                         And bc-param-ext.cod-param-ext = "ServidorExec" 
                         AND bc-param-ext.param-caracter = cNoId NO-LOCK :
       ASSIGN cCodColetor = Bc-param-ext.cod-chave-param-ext.
       /* Habilita e Desabilita bot‰es de Conex∆o */
       IF CAN-FIND( Bc-param-ext WHERE bc-param-ext.cod-entidade-param-ext = "bc-coletor"
                         And Bc-param-ext.cod-param-ext = "ServidorExec"
                         AND Bc-param-ext.param-caracter = bc-param-ext.param-caracter
                         AND Bc-param-ext.cod-chave-param-ext  = cCodColetor) THEN DO:
            ASSIGN iNrColetor = iNrColetor + 1.
            IF CAN-FIND(FIRST Bc-param-ext
                            WHERE bc-param-ext.cod-entidade-param-ext = "bc-coletor" And
                                  Bc-param-ext.cod-param-ext = "ConectadoColetor" AND
                                  Bc-param-ext.param-logico  = YES AND
                                  Bc-param-ext.cod-chave-param-ext  = cCodColetor) THEN DO:
                ASSIGN iNrColetorAtiv = iNrColetorAtiv + 1.
            END.
            
            DISABLE btDisconnect btConnect WITH FRAME {&FRAME-NAME}.
       END.
   END.
   FIND FIRST servid_exec NO-LOCK 
        WHERE servid_exec.cod_servid_exec = cNoID NO-ERROR.
   IF AVAIL servid_exec THEN DO:
        {utp/ut-liter.i Coletores_Ativos_em_ *}
        CREATE ttInfCol.
        ASSIGN ttInfCol.sequencia  = 1
               ttInfCol.infColUser = RETURN-VALUE + TRIM(STRING(cNoID))
               ttInfCol.numColUser = TRIM(STRING(iNrColetorAtiv)) + "/" + TRIM(STRING(iNrColetor)). 
               
        {utp/ut-liter.i Usuario_Gerenciando_ *}
        CREATE ttInfCol.
        ASSIGN ttInfCol.sequencia  = 2
               ttInfCol.infColUser = RETURN-VALUE + TRIM(STRING(cNoID))
               ttInfCol.numColUser = TRIM(STRING(servid_exec.cod_usuar_ult_atualiz)). 
                       
       If servid_exec.Log_servid_exec_ativ Then
           Enable btStop btRestart WITH FRAME {&FRAME-NAME}.
   End.
   ASSIGN ttInfCol.sequencia:VISIBLE IN BROWSE br-info = NO
          ttInfCol.infColServ:VISIBLE IN BROWSE br-info = NO
          ttInfCol.numColServ:VISIBLE IN BROWSE br-info = NO
          ttInfCol.infColUser:VISIBLE IN BROWSE br-info = YES
          ttInfCol.numColUser:VISIBLE IN BROWSE br-info = YES
          ttInfCol.pos:VISIBLE IN BROWSE br-info = YES
          ttInfCol.cparam:VISIBLE IN BROWSE br-info = NO
          ttInfCol.valor:VISIBLE IN BROWSE br-info = NO
          ttInfCol.descparam:VISIBLE IN BROWSE br-info = NO
          ttInfCol.usuario:VISIBLE IN BROWSE br-info = NO
          ttInfCol.dtErro:VISIBLE IN BROWSE br-info = NO
          ttInfCol.hrErro:VISIBLE IN BROWSE br-info = NO
          ttInfCol.ErroCol:VISIBLE IN BROWSE br-info = NO
          ttInfCol.descErro:VISIBLE IN BROWSE br-info = NO
          ttInfCol.infColUser:WIDTH-CHAR IN BROWSE br-info = 30
          ttInfCol.numColUser:WIDTH-CHAR IN BROWSE br-info = 10.  
 
   {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}      
END.
IF c-codigo-node BEGINS "t" THEN DO:
    For Each bc-param-ext No-lock
    Where bc-param-ext.cod-entidade-param-ext = "bc-coletor"
      And bc-param-ext.cod-chave-param-ext = cNoId BREAK BY bc-param-ext.cod-param-ext:
        CASE bc-param-ext.ind-tipo-dado:
            WHEN 1 THEN ASSIGN cParametro = bc-param-ext.param-caracter.
            WHEN 2 THEN ASSIGN cParametro = STRING(bc-param-ext.param-data).
            WHEN 3 THEN ASSIGN cParametro = STRING(bc-param-ext.param-decimal).
            WHEN 4 THEN ASSIGN cParametro = STRING(bc-param-ext.param-inteiro).
            WHEN 5 THEN ASSIGN cParametro = STRING(bc-param-ext.param-Logico).
        END CASE.
        ASSIGN iSeq = iSeq + 1.
        CREATE ttInfCol.
        ASSIGN ttInfCol.sequencia = iSeq
               ttInfCol.cparam    = TRIM(bc-param-ext.cod-param-ext)
               ttInfCol.valor     = cParametro
               ttInfCol.descparam = TRIM(bc-param-ext.desc-param).
    END.
    
    
    /* Habilita e Desabilita bot‰es de Conex∆o */
    IF CAN-FIND(FIRST bc-param-ext
                WHERE bc-param-ext.cod-entidade-param-ext = "bc-coletor" And
                      bc-param-ext.cod-param-ext = "ConectadoColetor" AND
                      bc-param-ext.param-logico  = NO                AND
                      bc-param-ext.cod-chave-param-ext = cNoId) THEN
        ENABLE btConnect WITH FRAME {&FRAME-NAME}.
    ELSE 
        DISABLE btConnect WITH FRAME {&FRAME-NAME}.

    IF CAN-FIND(FIRST bc-param-ext 
                WHERE bc-param-ext.cod-entidade-param-ext = "bc-coletor" And
                      bc-param-ext.cod-param-ext = "ConectadoColetor" AND
                      bc-param-ext.param-logico  = YES                 AND
                      bc-param-ext.cod-chave-param-ext = cNoId) THEN
        ENABLE btDisconnect WITH FRAME {&FRAME-NAME}.
    ELSE 
        DISABLE btDisconnect WITH FRAME {&FRAME-NAME}.

    FIND FIRST  Bc-param-ext NO-LOCK
     WHERE bc-param-ext.cod-entidade-param-ext = "bc-coletor"
       And Bc-param-ext.cod-param-ext = "ServidorExec"
       AND Bc-param-ext.cod-chave-param-ext  = cNoId NO-ERROR.
    IF AVAIL bc-param-ext THEN DO:
        FIND first servid_exec NO-LOCK 
        WHERE servid_exec.cod_servid_exec = bc-param-ext.param-caracter NO-ERROR.
        IF AVAIL servid_exec THEN 
            IF NOT servid_exec.log_servid_exec_ativ THEN
               DISABLE btDisconnect btConnect WITH FRAME {&FRAME-NAME}.
    END.
    Disable btStop btRestart WITH FRAME {&FRAME-NAME}.
    
    ASSIGN ttInfCol.sequencia:VISIBLE IN BROWSE br-info = NO
           ttInfCol.infColServ:VISIBLE IN BROWSE br-info = NO
           ttInfCol.numColServ:VISIBLE IN BROWSE br-info = NO
           ttInfCol.infColUser:VISIBLE IN BROWSE br-info = NO
           ttInfCol.numColUser:VISIBLE IN BROWSE br-info = NO
           ttInfCol.cparam:VISIBLE IN BROWSE br-info = YES
           ttInfCol.valor:VISIBLE IN BROWSE br-info = YES
           ttInfCol.descparam:VISIBLE IN BROWSE br-info = YES
           ttInfCol.pos:VISIBLE IN BROWSE br-info = YES
           ttInfCol.pos:VISIBLE IN BROWSE br-info = NO
           ttInfCol.usuario:VISIBLE IN BROWSE br-info = NO
           ttInfCol.dtErro:VISIBLE IN BROWSE br-info = NO
           ttInfCol.hrErro:VISIBLE IN BROWSE br-info = NO
           ttInfCol.ErroCol:VISIBLE IN BROWSE br-info = NO
           ttInfCol.descErro:VISIBLE IN BROWSE br-info = NO
           ttInfCol.cparam:WIDTH-CHAR IN BROWSE br-info = 20
           ttInfCol.valor:WIDTH-CHAR IN BROWSE br-info = 30
           ttInfCol.descparam:WIDTH-CHAR IN BROWSE br-info = 40. 
 
    {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}} 
    
END.

IF c-codigo-node BEGINS "m" THEN DO:

    FOR EACH bc-coletor-erro WHERE bc-coletor-erro.id-coletor = cNoId NO-LOCK BY bc-coletor-erro.nr-sequencia DESC:
       
        ASSIGN iSeq = iSeq + 1.
        CREATE ttInfCol.
        ASSIGN ttInfCol.sequencia = bc-coletor-erro.nr-sequencia
               ttInfCol.usuario   = TRIM(bc-coletor-erro.cod-usuario)
               ttInfCol.dtErro    = TRIM(STRING(bc-coletor-erro.data-erro))
               ttInfCol.hrErro    = TRIM(bc-coletor-erro.hora-erro)
               ttInfCol.ErroCol   = TRIM(STRING(bc-coletor-erro.cod-erro))
               ttInfCol.descErro  = TRIM(SUBSTRING(bc-coletor-erro.desc-erro,2)).
    END.
    DISABLE btDisconnect btConnect btStop btRestart WITH FRAME {&FRAME-NAME}.
    
    ASSIGN ttInfCol.sequencia:VISIBLE IN BROWSE br-info = YES
           ttInfCol.infColServ:VISIBLE IN BROWSE br-info = NO
           ttInfCol.numColServ:VISIBLE IN BROWSE br-info = NO
           ttInfCol.infColUser:VISIBLE IN BROWSE br-info = NO
           ttInfCol.numColUser:VISIBLE IN BROWSE br-info = NO
           ttInfCol.cparam:VISIBLE IN BROWSE br-info = NO
           ttInfCol.valor:VISIBLE IN BROWSE br-info = NO
           ttInfCol.descparam:VISIBLE IN BROWSE br-info = NO
           ttInfCol.usuario:VISIBLE IN BROWSE br-info = YES
           ttInfCol.dtErro:VISIBLE IN BROWSE br-info = YES
           ttInfCol.hrErro:VISIBLE IN BROWSE br-info = YES
           ttInfCol.ErroCol:VISIBLE IN BROWSE br-info = YES
           ttInfCol.descErro:VISIBLE IN BROWSE br-info = YES
           ttInfCol.pos:VISIBLE IN BROWSE br-info = YES
           ttInfCol.sequencia:WIDTH-CHAR IN BROWSE br-info = 7
           ttInfCol.usuario:WIDTH-CHAR IN BROWSE br-info = 10
           ttInfCol.dtErro:WIDTH-CHAR IN BROWSE br-info = 9
           ttInfCol.hrErro:WIDTH-CHAR IN BROWSE br-info = 8
           ttInfCol.ErroCol:WIDTH-CHAR IN BROWSE br-info = 8
           ttInfCol.descErro:WIDTH-CHAR IN BROWSE br-info = 50. 
 
    {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}} 
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPopulateIt wWindow 
PROCEDURE piPopulateIt :
/*------------------------------------------------------------------------------
  Purpose: Inicialisa o TreeView    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE iImage      AS INTEGER    NO-UNDO.

   RUN emptyTree IN h-4gltreeview NO-ERROR.
   
   ASSIGN cFont    = "font=1"
          cFgColor = "fgcolor=0".
   
   {utp/ut-liter.i Coletores *}
   RUN pi-create-node IN THIS-PROCEDURE ( INPUT "p":U + STRING("Coletores"),
                                          INPUT "",
                                          INPUT RETURN-VALUE,
                                          INPUT "image/treeview/tvpics/afsingwind.bmp",
                                          INPUT cExpClp + CHR(1) + cFgColor + CHR(1) + cFont).
                                          
   RUN pi-atualizaTreeview.   

   RUN applyEntry IN h-4gltreeview (INPUT "").
   
   FOR EACH bc-param-ext NO-LOCK
      WHERE bc-param-ext.cod-entidade-param-ext = "bc-coletor"
        AND bc-param-ext.cod-param-ext = "ServidorExec" BREAK BY bc-param-ext.param-caracter:
   IF FIRST-OF(bc-param-ext.param-caracter) THEN DO:
               
      RUN pi-create-node IN THIS-PROCEDURE ( INPUT "i":U + STRING("Coletores") + "|":U + STRING(bc-param-ext.param-caracter),
                                             INPUT "p":U + STRING("Coletores"),
                                             INPUT STRING(bc-param-ext.param-caracter),
                                             INPUT "image/treeview/tvpics/db.bmp",
                                             INPUT cExpClp + CHR(1) + cFgColor + CHR(1) + cFont) NO-ERROR.
   END.

   /* Cria Segundo n¢ que fara a listagem dos Coletores */
   FOR EACH bc-coletor NO-LOCK
      WHERE bc-coletor.id-coletor = bc-param-ext.cod-chave-param-ext 
         BY bc-coletor.id-coletor:

      IF CAN-FIND( bc-param-ext WHERE bc-param-ext.cod-entidade-param-ext = "bc-coletor"
               AND bc-param-ext.cod-param-ext           = "ServidorExec"
               AND bc-param-ext.param-caracter      = bc-param-ext.param-caracter
               AND bc-param-ext.cod-chave-param-ext = bc-coletor.id-coletor) THEN DO:
    
         IF CAN-FIND (FIRST bc-param-ext
                      WHERE bc-param-ext.cod-entidade-param-ext = "bc-coletor"
                        AND bc-param-ext.cod-param-ext          = "ConectadoColetor" 
                        AND bc-param-ext.param-logico           = NO 
                        AND bc-param-ext.cod-chave-param-ext    = bc-coletor.id-coletor) THEN
            ASSIGN iImage = 4.
         ELSE 
            ASSIGN iImage = 5.
            
         RUN pi-create-node IN THIS-PROCEDURE ( INPUT "t":U + STRING("Coletores") + "|":U + STRING(bc-param-ext.param-caracter) + "|":U + STRING(bc-param-ext.cod-chave-param-ext),
                                                INPUT "i":U + STRING("Coletores") + "|":U + STRING(bc-param-ext.param-caracter),
                                                INPUT STRING(bc-param-ext.cod-chave-param-ext),
                                                INPUT "image/treeview/tvpics/Barcode.bmp",
                                                INPUT cExpClp + CHR(1) + cFgColor + CHR(1) + cFont) NO-ERROR.         
         {utp/ut-liter.i Erros *}       
         RUN pi-create-node IN THIS-PROCEDURE ( INPUT "m":U + STRING("Erros") + "|":U + STRING(bc-param-ext.param-caracter) + "|":U + STRING(bc-param-ext.cod-chave-param-ext),
                                                INPUT "t":U + STRING("Coletores") + "|":U + STRING(bc-param-ext.param-caracter) + "|":U + STRING(bc-param-ext.cod-chave-param-ext),
                                                INPUT RETURN-VALUE,
                                                INPUT "image/treeview/tvpics/field.bmp",
                                                INPUT cExpClp + CHR(1) + cFgColor + CHR(1) + cFont) NO-ERROR.       

         END. /* IF CAN-FIND( Bc-param-ext... */
      END. /* For Each bc-coletor No-lock */
   END. /* For Each bc-param-ext No-lock */
/*RUN piNodeClick.*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRunConnect wWindow 
PROCEDURE piRunConnect :
/*------------------------------------------------------------------------------
  Purpose:    Roda a Conex∆o e Desconex∆o dos coletores selecionados 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER lConecta AS LOGICAL     NO-UNDO.
DEFINE VARIABLE cIdColetor AS CHARACTER  NO-UNDO.

    IF c-codigo-node BEGINS "p" THEN
       ASSIGN cLevel = "1".
    IF c-codigo-node BEGINS "i" THEN
       ASSIGN cLevel = "2". 
    IF c-codigo-node BEGINS "t" THEN
       ASSIGN cLevel = "3". 

    CASE cLevel:
        WHEN "1" THEN DO:
            FOR EACH bc-coletor NO-LOCK:
                RUN piConectaColetor(INPUT bc-coletor.id-coletor,INPUT lConecta).
            END.
            RUN pi-atualizaTreeview.
        END.
        WHEN "2" THEN DO:
            IF c-codigo-node BEGINS "i" THEN
               ASSIGN cNoID = TRIM(ENTRY(1, ENTRY(2,c-codigo-node,'|'),':':U)).
               
            IF lConecta THEN DO:
                FOR EACH bc-param-ext Where bc-param-ext.cod-param-ext = "ServidorExec" 
                           AND bc-param-ext.param-caracter = cNoId NO-LOCK:
                    RUN piConectaColetor(INPUT bc-param-ext.cod-chave-param-ext,INPUT lConecta).
                END.
            END.
            ELSE DO:
                 FIND first servid_exec
                 WHERE servid_exec.cod_servid_exec = cNoId NO-ERROR.
                 IF AVAIL servid_exec THEN
                     ASSIGN servid_exec.log_servid_exec_ativ = NO.

            END.
            RUN pi-atualizaTreeview.
        END.
        WHEN "3" THEN DO:
            IF c-codigo-node BEGINS "t" THEN    
               ASSIGN cNoID = TRIM(ENTRY(1, ENTRY(3,c-codigo-node,'|'),':':U)).
           
            RUN piConectaColetor(INPUT cNoID,INPUT lConecta).
            RUN pi-atualizaTreeview.
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:    Roda a Conex∆o e Desconex∆o dos coletores selecionados 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF VALID-HANDLE(h-4gltreeview) THEN DO:
      RUN destroyObject IN h-4gltreeview.
      DELETE PROCEDURE h-4gltreeview NO-ERROR.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

