&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-cadcom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadcom 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0105 2.00.00.035 } /*** "010035" 31/08/2023 15:08:02  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC0105 MBC}
&ENDIF

/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters: 
      <none>

  Output Parameters: 
      <none>

  Version: 1.00.000

  History: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF VAR h-v01cl011 AS HANDLE NO-UNDO.
DEF VAR h-v01cl018 AS HANDLE NO-UNDO.
DEF VAR h-v04cl018 AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button bt-inicializacao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadcom AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-arquivo 
       MENU-ITEM mi-primeiro    LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM mi-anterior    LABEL "An&terior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM mi-proximo     LABEL "Pr&¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM mi-ultimo      LABEL "&Ultimo"        ACCELERATOR "CTRL-END"
       MENU-ITEM mi-va-para     LABEL "&V  para"       ACCELERATOR "CTRL-T"
       MENU-ITEM mi-pesquisa    LABEL "Pes&quisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM mi-incluir     LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM mi-copiar      LABEL "C&opiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM mi-alterar     LABEL "A&lterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM mi-eliminar    LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM mi-desfazer    LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM mi-cancelar    LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM mi-salvar      LABEL "Sal&var"        ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM m_Inicializao_Coleta_de_Dados LABEL "&Inicializa‡Æo Coleta de Dados" ACCELERATOR "CTRL-N"
       RULE
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU mi-ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-cadastro MENUBAR
       SUB-MENU  mi-arquivo     LABEL "&Arquivo"      
       SUB-MENU  mi-ajuda       LABEL "A&juda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b02cl037 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-cadsim AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navega AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q02cl018 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v01cl011 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v01cl018 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v03cl018 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v04cl018 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-inicializacao 
     IMAGE-UP FILE "image\im-carga":U
     IMAGE-INSENSITIVE FILE "image\ii-carga":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 88.57 BY 1.46
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-inicializacao AT ROW 1.13 COL 62.57 HELP
          "Inicializa‡Æo do Coleta de Dados"
     rt-button AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.14 BY 17.92.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 4
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadcom ASSIGN
         HIDDEN             = YES
         TITLE              = "Tipo de Transa‡Æo"
         HEIGHT             = 15.29
         WIDTH              = 89
         MAX-HEIGHT         = 21.21
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.21
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = YES
         SCROLL-BARS        = NO
         STATUS-AREA        = YES
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = YES
         MESSAGE-AREA       = NO
         SENSITIVE          = YES.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-cadastro:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadcom 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-cadcom.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadcom
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadcom)
THEN w-cadcom:HIDDEN = YES.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadcom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadcom w-cadcom
ON END-ERROR OF w-cadcom /* Tipo de Transa‡Æo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
   /* This case occurs when the user presses the "Esc" key.
      In a persistently run window, just ignore this.  If we did not, the
      application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadcom w-cadcom
ON WINDOW-CLOSE OF w-cadcom /* Tipo de Transa‡Æo */
DO:
   /* This ADM code must be left here in order for the SmartWindow
      and its descendents to terminate properly on exit. */
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-inicializacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inicializacao w-cadcom
ON CHOOSE OF bt-inicializacao IN FRAME f-cad
DO:
   RUN utp/ut-msgs.p(INPUT "SHOW":U,
                     INPUT 16762,
                     INPUT "").
   IF RETURN-VALUE = "YES" THEN DO:
      RUN bcp/bc0001a.p.
      RUN dispatch IN h_q02cl018 ('open-query':U).
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-alterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-alterar w-cadcom
ON CHOOSE OF MENU-ITEM mi-alterar /* Alterar */
DO:
   RUN pi-alterar IN h_p-cadsim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-anterior
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-anterior w-cadcom
ON CHOOSE OF MENU-ITEM mi-anterior /* Anterior */
DO:
   RUN pi-anterior IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-arquivo w-cadcom
ON MENU-DROP OF MENU mi-arquivo /* Arquivo */
DO:
   RUN pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-cancelar w-cadcom
ON CHOOSE OF MENU-ITEM mi-cancelar /* Cancelar */
DO:
   RUN pi-cancelar IN h_p-cadsim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-cadcom
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
   RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-cadcom
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
   RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-copiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-copiar w-cadcom
ON CHOOSE OF MENU-ITEM mi-copiar /* Copiar */
DO:
   RUN pi-copiar IN h_p-cadsim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-desfazer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-desfazer w-cadcom
ON CHOOSE OF MENU-ITEM mi-desfazer /* Desfazer */
DO:
   RUN pi-desfazer IN h_p-cadsim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-eliminar w-cadcom
ON CHOOSE OF MENU-ITEM mi-eliminar /* Eliminar */
DO:
   RUN pi-eliminar IN h_p-cadsim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-cadcom
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
   RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-incluir w-cadcom
ON CHOOSE OF MENU-ITEM mi-incluir /* Incluir */
DO:
   RUN pi-incluir IN h_p-cadsim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-pesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-pesquisa w-cadcom
ON CHOOSE OF MENU-ITEM mi-pesquisa /* Pesquisa */
DO:
   RUN pi-pesquisa IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-primeiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-primeiro w-cadcom
ON CHOOSE OF MENU-ITEM mi-primeiro /* Primeiro */
DO:
   RUN pi-primeiro IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-proximo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-proximo w-cadcom
ON CHOOSE OF MENU-ITEM mi-proximo /* Pr¢ximo */
DO:
   RUN pi-proximo IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-cadcom
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
   RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-salvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-salvar w-cadcom
ON CHOOSE OF MENU-ITEM mi-salvar /* Salvar */
DO:
   RUN pi-salvar IN h_p-cadsim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-cadcom
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
   {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-ultimo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-ultimo w-cadcom
ON CHOOSE OF MENU-ITEM mi-ultimo /* Ultimo */
DO:
   RUN pi-ultimo IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-va-para
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-va-para w-cadcom
ON CHOOSE OF MENU-ITEM mi-va-para /* V  para */
DO:
   RUN pi-vapara IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Inicializao_Coleta_de_Dados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Inicializao_Coleta_de_Dados w-cadcom
ON CHOOSE OF MENU-ITEM m_Inicializao_Coleta_de_Dados /* Inicializa‡Æo Coleta de Dados */
DO:
   APPLY "CHOOSE" TO bt-inicializacao IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadcom 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}


{utp/ut-liter.i "Inicializa‡Æo do Coleta de Dados" * L}
ASSIGN bt-inicializacao:TOOLTIP = TRIM(RETURN-VALUE)
       bt-inicializacao:HELP    = TRIM(RETURN-VALUE).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadcom  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
   DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.
   
   RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
   ASSIGN adm-current-page = INTEGER(RETURN-VALUE).
   
   CASE adm-current-page:   
      WHEN 0 THEN DO:
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'panel/p-navega.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'Edge-Pixels = 0,
                       SmartPanelType = NAV-ICON,
                       Right-to-Left = First-On-Left':U ,
               OUTPUT h_p-navega ).
         RUN set-position IN h_p-navega ( 1.13 , 1.57 ) NO-ERROR.
         /* Size in UIB:  ( 1.25 , 24.00 ) */
      
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'panel/p-cadsim.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'Edge-Pixels = 0,
                       SmartPanelType = Update,
                       AddFunction = One-Record':U ,
               OUTPUT h_p-cadsim ).
         RUN set-position IN h_p-cadsim ( 1.13 , 26.72 ) NO-ERROR.
         /* Size in UIB:  ( 1.25 , 28.00 ) */
      
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'panel/p-exihel.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'Edge-Pixels = 0,
                       SmartPanelType = NAV-ICON,
                       Right-to-Left = First-On-Left':U ,
               OUTPUT h_p-exihel ).
         RUN set-position IN h_p-exihel ( 1.13 , 73.00 ) NO-ERROR.
         /* Size in UIB:  ( 1.25 , 16.00 ) */
      
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'clvwr/v03cl018.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'Layout = ':U ,
               OUTPUT h_v03cl018 ).
         RUN set-position IN h_v03cl018 ( 2.50 , 1.00 ) NO-ERROR.
         /* Size in UIB:  ( 1.33 , 88.57 ) */
      
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'adm/objects/folder.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'FOLDER-LABELS = ':U + 'Transa‡Æo|Etiqueta|Reporte|Parametros' + ',
                       FOLDER-TAB-TYPE = 1':U ,
               OUTPUT h_folder ).
         RUN set-position IN h_folder ( 3.83 , 1.00 ) NO-ERROR.
         RUN set-size IN h_folder ( 12.42 , 88.57 ) NO-ERROR.
      
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'clqry/q02cl018.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'ProgPesquisa = clzoom/z01cl018.w,
                       ProgVaPara = clgo/g01cl018.w,
                       ProgIncMod = ,
                       Implantar = no':U ,
               OUTPUT h_q02cl018 ).
         RUN set-position IN h_q02cl018 ( 1.00 , 53.86 ) NO-ERROR.
         /* Size in UIB:  ( 1.79 , 8.29 ) */
      
         /* Links to SmartPanel h_p-exihel. */
         RUN add-link IN adm-broker-hdl ( h_p-cadsim , 'State':U , h_p-exihel ).
      
         /* Links to SmartViewer h_v03cl018. */
         RUN add-link IN adm-broker-hdl ( h_p-cadsim , 'TableIO':U , h_v03cl018 ).
         RUN add-link IN adm-broker-hdl ( h_q02cl018 , 'Record':U , h_v03cl018 ).
      
         /* Links to SmartFolder h_folder. */
         RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).
      
         /* Links to SmartQuery h_q02cl018. */
         RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , h_q02cl018 ).
         RUN add-link IN adm-broker-hdl ( h_p-navega , 'Navigation':U , h_q02cl018 ).
         RUN add-link IN adm-broker-hdl ( h_p-navega , 'State':U , h_q02cl018 ).
      
         /* Adjust the tab order of the smart objects. */
         RUN adjust-tab-order IN adm-broker-hdl ( h_p-navega ,
               bt-inicializacao:HANDLE IN FRAME f-cad , 'BEFORE':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_p-cadsim ,
               h_p-navega , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
               bt-inicializacao:HANDLE IN FRAME f-cad , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_v03cl018 ,
               h_p-exihel , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
               h_v03cl018 , 'AFTER':U ).
      END. /* Page 0 */
      WHEN 1 THEN DO:
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'clvwr/v01cl018.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'Layout = ':U ,
               OUTPUT h_v01cl018 ).
         RUN set-position IN h_v01cl018 ( 5.21 , 2.72 ) NO-ERROR.
         /* Size in UIB:  ( 10.50 , 85.72 ) */
      
         /* Links to SmartViewer h_v01cl018. */
         RUN add-link IN adm-broker-hdl ( h_q02cl018 , 'Record':U , h_v01cl018 ).
         RUN add-link IN adm-broker-hdl ( h_v03cl018 , 'Group-Assign':U , h_v01cl018 ).
      
         /* Adjust the tab order of the smart objects. */
         RUN adjust-tab-order IN adm-broker-hdl ( h_p-navega ,
               bt-inicializacao:HANDLE IN FRAME f-cad , 'BEFORE':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_p-cadsim ,
               h_p-navega , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
               bt-inicializacao:HANDLE IN FRAME f-cad , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_v03cl018 ,
               h_p-exihel , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
               h_v03cl018 , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_v01cl018 ,
               h_folder , 'AFTER':U ).
      END. /* Page 1 */
      WHEN 2 THEN DO:
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'clvwr/v04cl018.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'Layout = ':U ,
               OUTPUT h_v04cl018 ).
         RUN set-position IN h_v04cl018 ( 5.25 , 2.00 ) NO-ERROR.
         /* Size in UIB:  ( 10.50 , 85.72 ) */
      
         /* Links to SmartViewer h_v04cl018. */
         RUN add-link IN adm-broker-hdl ( h_q02cl018 , 'Record':U , h_v04cl018 ).
         RUN add-link IN adm-broker-hdl ( h_v03cl018 , 'Group-Assign':U , h_v04cl018 ).
      
         /* Adjust the tab order of the smart objects. */
         RUN adjust-tab-order IN adm-broker-hdl ( h_p-navega ,
               bt-inicializacao:HANDLE IN FRAME f-cad , 'BEFORE':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_p-cadsim ,
               h_p-navega , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
               bt-inicializacao:HANDLE IN FRAME f-cad , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_v03cl018 ,
               h_p-exihel , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
               h_v03cl018 , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_v04cl018 ,
               h_folder , 'AFTER':U ).
      END. /* Page 2 */
      WHEN 3 THEN DO:
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'clvwr/v01cl011.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'Layout = ':U ,
               OUTPUT h_v01cl011 ).
         RUN set-position IN h_v01cl011 ( 5.25 , 2.72 ) NO-ERROR.
         /* Size in UIB:  ( 10.50 , 85.72 ) */
      
         /* Links to SmartViewer h_v01cl011. */
         RUN add-link IN adm-broker-hdl ( h_q02cl018 , 'Record':U , h_v01cl011 ).
         RUN add-link IN adm-broker-hdl ( h_v03cl018 , 'Group-Assign':U , h_v01cl011 ).
      
         /* Adjust the tab order of the smart objects. */
         RUN adjust-tab-order IN adm-broker-hdl ( h_p-navega ,
               bt-inicializacao:HANDLE IN FRAME f-cad , 'BEFORE':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_p-cadsim ,
               h_p-navega , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
               bt-inicializacao:HANDLE IN FRAME f-cad , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_v03cl018 ,
               h_p-exihel , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
               h_v03cl018 , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_v01cl011 ,
               h_folder , 'AFTER':U ).
      END. /* Page 3 */
      WHEN 4 THEN DO:
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'clbrw/b02cl037.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'Layout = ':U ,
               OUTPUT h_b02cl037 ).
         RUN set-position IN h_b02cl037 ( 5.50 , 3.00 ) NO-ERROR.
         /* Size in UIB:  ( 10.04 , 85.00 ) */
      
         /* Links to BrowserCadastro2 h_b02cl037. */
         RUN add-link IN adm-broker-hdl ( h_q02cl018 , 'Record':U , h_b02cl037 ).
      
         /* Adjust the tab order of the smart objects. */
         RUN adjust-tab-order IN adm-broker-hdl ( h_p-navega ,
               bt-inicializacao:HANDLE IN FRAME f-cad , 'BEFORE':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_p-cadsim ,
               h_p-navega , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
               bt-inicializacao:HANDLE IN FRAME f-cad , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_v03cl018 ,
               h_p-exihel , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
               h_v03cl018 , 'AFTER':U ).
         RUN adjust-tab-order IN adm-broker-hdl ( h_b02cl037 ,
               h_folder , 'AFTER':U ).
      END. /* Page 4 */
   END CASE.
   /* Select a Startup page. */
   IF adm-current-page EQ 0 THEN
      RUN select-page IN THIS-PROCEDURE ( 1 ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadcom  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

   /* Define variables needed by this internal procedure.             */
   {src/adm/template/row-head.i}
   
   /* Process the newly available records (i.e. display fields,
      open queries, and/or pass records on to any RECORD-TARGETS).    */
   {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadcom  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
   /* Delete the WINDOW we created */
   IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadcom) THEN
      DELETE WIDGET w-cadcom.
  
   IF THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadcom  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
   ENABLE rt-button bt-inicializacao 
      WITH FRAME f-cad IN WINDOW w-cadcom.
   {&OPEN-BROWSERS-IN-QUERY-f-cad}
   VIEW w-cadcom.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadcom 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
   IF VALID-HANDLE(gh-bofn068) THEN DO:
      DELETE PROCEDURE gh-bofn068 NO-ERROR.
      ASSIGN gh-bofn068 = ?.
   END.
   
   IF VALID-HANDLE(gh-bofn088) THEN DO:
      DELETE PROCEDURE gh-bofn088 NO-ERROR.
      ASSIGN gh-bofn088 = ?.
   END.
   
   IF VALID-HANDLE(gh-bofn116) THEN DO:
      DELETE PROCEDURE gh-bofn116 NO-ERROR.
      ASSIGN gh-bofn116 = ?.
   END.

   /* Code placed here will execute PRIOR to standard behavior. */

   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
   {include/i-logfin.i}

   /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadcom 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.

   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadcom 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   /* Code placed here will execute PRIOR to standard behavior. */
   {include/win-size.i}

   RUN pi-before-initialize.

{utp/ut9000.i "BC0105" "2.00.00.035"} /* 31/08/2023 15:08:02 */

   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

   /* Code placed here will execute AFTER standard behavior.    */

   RUN pi-before-initialize.

   {include/i-inifld.i}

   ASSIGN h-v01cl011 = h_v01cl011
          h-v01cl018 = h_v01cl018
          h-v04cl018 = h_v04cl018.
  
   RUN pi-recebe-handle IN h_v03cl018 (INPUT h-v01cl011). /* envia handle */
   RUN pi-recebe-handle IN h_v04cl018 (INPUT h-v01cl018). /* envia handle */
   RUN pi-recebe-handle IN h_v01cl018 (INPUT h-v04cl018). /* envia handle */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita-bt w-cadcom 
PROCEDURE pi-desabilita-bt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN MENU-ITEM m_inicializao_coleta_de_dados:SENSITIVE IN MENU m-cadastro = NO
          bt-inicializacao:SENSITIVE IN FRAME {&FRAME-NAME}                    = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-bt w-cadcom 
PROCEDURE pi-habilita-bt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN MENU-ITEM m_inicializao_coleta_de_dados:SENSITIVE IN MENU m-cadastro = YES
          bt-inicializacao:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_ems_xref w-cadcom 
PROCEDURE pi_ems_xref :
/*------------------------------------------------------------------------------
  Purpose:     Referˆncias XRef
  Parameters:  <none> 
  Notes:       NÆo altere/elimine o c¢digo abaixo.
------------------------------------------------------------------------------*/
   RUN clzoom/z01cl018.w.
   RUN clgo/g01cl018.w.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator w-cadcom 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
   RUN clvwr\v04cl018.w.
   RUN clvwr\v01cl018.w.
   RUN clvwr\v03cl018.w.
   RUN panel\p-cadsim.w.
   RUN adm\objects\folder.w.
   RUN clvwr\v01cl011.w.
   RUN panel\p-navega.w.
   RUN panel\p-exihel.w.
   RUN clqry\q02cl018.w.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadcom  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadcom 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
   DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
   DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.
   
   RUN pi-trata-state ( INPUT p-issuer-hdl,
                        INPUT p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBloqWindow w-cadcom 
PROCEDURE piBloqWindow :
/*------------------------------------------------------------------------------
  Notes: Bloqueia Tela
------------------------------------------------------------------------------*/
   {&WINDOW-NAME}:SENSITIVE = NO.
   
   RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLibWindow w-cadcom 
PROCEDURE piLibWindow :
/*------------------------------------------------------------------------------
  Notes: Libera Tela
------------------------------------------------------------------------------*/
   {&WINDOW-NAME}:SENSITIVE = YES.
   
   RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME   
