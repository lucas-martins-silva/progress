&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-cadpaifilho-filho
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadpaifilho-filho 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0203 2.00.00.035}  /*** "010035" 31/08/2023 15:08:04  ***/

/*------------------------------------------------------------------------

  File: 

  Description: 

  vareters: 
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

DEF VAR p-table         AS ROWID.
DEF VAR c-cdtrans-ini   AS CHARACTER    INIT ""             NO-UNDO.
DEF VAR c-cdtrans-fim   AS CHARACTER    INIT "ZZZZZZZZZZZZ" NO-UNDO.
DEF VAR de-nr-trans     AS DECIMAL      INIT 0000000000     NO-UNDO.
DEF VAR de-trans-ini    AS DECIMAL      INIT 0000000000     NO-UNDO.
DEF VAR de-trans-fim    AS DECIMAL      INIT 9999999999     NO-UNDO.
DEF VAR da-trans-ini    AS DATE         INIT 01/01/1800     NO-UNDO.
DEF VAR da-trans-fim    AS DATE         INIT 12/31/9999     NO-UNDO.
DEF VAR hr-trans-ini    AS CHARACTER    INIT "00:00:00"     NO-UNDO.
DEF VAR hr-trans-fim    AS CHARACTER    INIT "23:59:59"     NO-UNDO.
DEF VAR c-usu-ini       AS CHARACTER    INIT ""             NO-UNDO.
DEF VAR c-usu-fim       AS CHARACTER    INIT "ZZZZZZZZZZZZ" NO-UNDO.
DEF VAR da-atu-ini      AS DATE         INIT 01/01/1800     NO-UNDO.
DEF VAR da-atu-fim      AS DATE         INIT 12/31/9999     NO-UNDO.
DEF VAR hr-atu-ini      AS CHARACTER    INIT "00:00:00"     NO-UNDO.
DEF VAR hr-atu-fim      AS CHARACTER    INIT "23:59:59"     NO-UNDO.
DEF VAR l-nova          AS LOGICAL      INIT YES            NO-UNDO.
DEF VAR l-atualizada    AS LOGICAL      INIT NO             NO-UNDO.
DEF VAR l-erro          AS LOGICAL      INIT NO             NO-UNDO.
DEF VAR l-errovp        AS LOGICAL      INIT NO             NO-UNDO.
DEF VAR l-em-proces     AS LOGICAL      INIT NO             NO-UNDO.
DEF VAR l-cancelado     AS LOGICAL      INIT NO             NO-UNDO.
DEF VAR l-movimento     AS LOGICAL      INIT YES            NO-UNDO.
DEF VAR l-etiqueta      AS LOGICAL      INIT YES            NO-UNDO.
DEF VAR c-filtro        AS CHARACTER                        NO-UNDO.
DEF VAR lVaParaNrTrans  AS LOGICAL      INITIAL NO          NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-paifil
&Scoped-define DB-AWARE NO

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Record-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-query bt-filtro bt-param bt-vapara ~
rt-button 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadpaifilho-filho AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-arquivo 
       MENU-ITEM mi-primeiro    LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM mi-anterior    LABEL "An&terior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM mi-proximo     LABEL "Pr&¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM mi-ultimo      LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       MENU-ITEM mi-va-para     LABEL "&V  para"       ACCELERATOR "CTRL-T"
       MENU-ITEM mi-pesquisa    LABEL "Pes&quisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM mi-atualiza    LABEL "A&tualiza"      ACCELERATOR "CTRL-A"
       MENU-ITEM mi-Filtro      LABEL "&Filtro"        ACCELERATOR "CTRL-F"
       MENU-ITEM mi-Parametros  LABEL "Parƒ&metros"    ACCELERATOR "CTRL-R"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU mi-ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-cadastro MENUBAR
       SUB-MENU  mi-arquivo     LABEL "&Arquivo"      
       SUB-MENU  mi-ajuda       LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b06cl012 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder   AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navega AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q01cl018 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v02cl018 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-filtro 
     IMAGE-UP FILE "image/im-fil":U
     IMAGE-INSENSITIVE FILE "image/ii-fil":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-param 
     IMAGE-UP FILE "image/im-param":U
     IMAGE-INSENSITIVE FILE "image/im-param":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-query 
     IMAGE-UP FILE "image/im-sav":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-vapara 
     IMAGE-UP FILE "image/im-crit.bmp":U
     LABEL "<VP>" 
     SIZE 4 BY 1.25 TOOLTIP "V  Para Numero da Transa‡Æo.".

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.46
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-query AT ROW 1.17 COL 52 HELP
          "Atualiza Informa‡äes"
     bt-filtro AT ROW 1.17 COL 56 HELP
          "Filtro"
     bt-param AT ROW 1.17 COL 60 HELP
          "Parƒmetros"
     bt-vapara AT ROW 1.17 COL 64 HELP
          "V  Para Numero da Transa‡Æo."
     rt-button AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-paifil
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadpaifilho-filho ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta de Transa‡äes"
         HEIGHT             = 13.54
         WIDTH              = 90.14
         MAX-HEIGHT         = 29.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29.21
         VIRTUAL-WIDTH      = 146.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadpaifilho-filho 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-paifil.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadpaifilho-filho
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   L-To-R                                                               */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadpaifilho-filho)
THEN w-cadpaifilho-filho:HIDDEN = YES.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadpaifilho-filho
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadpaifilho-filho w-cadpaifilho-filho
ON END-ERROR OF w-cadpaifilho-filho /* Consulta de Transa‡äes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
   /* This case occurs when the user presses the "Esc" key.
      In a persistently run window, just ignore this.  If we did not, the
      application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadpaifilho-filho w-cadpaifilho-filho
ON WINDOW-CLOSE OF w-cadpaifilho-filho /* Consulta de Transa‡äes */
DO:
   /* This ADM code must be left here in order for the SmartWindow
      and its descendents to terminate properly on exit. */
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro w-cadpaifilho-filho
ON CHOOSE OF bt-filtro IN FRAME f-cad
DO:
   ASSIGN lVaParaNrTrans = NO.
   RUN dispatch IN h_b06cl012 ('open-query':U).
   RUN bcp/bc0203a.w (INPUT-OUTPUT c-filtro).
   RUN pi-recebe-param IN h_b06cl012 ( INPUT c-cdtrans-ini,
                                       INPUT c-cdtrans-fim,
                                       INPUT de-trans-ini,
                                       INPUT de-trans-fim,
                                       INPUT da-trans-ini,
                                       INPUT da-trans-fim,
                                       INPUT hr-trans-ini,
                                       INPUT hr-trans-fim,
                                       INPUT c-usu-ini,
                                       INPUT c-usu-fim,
                                       INPUT da-atu-ini,
                                       INPUT da-atu-fim,
                                       INPUT hr-atu-ini,
                                       INPUT hr-atu-fim,
                                       INPUT l-nova,
                                       INPUT l-atualizada,
                                       INPUT l-erro,
                                       INPUT l-em-proces,
                                       INPUT l-cancelado,
                                       INPUT l-movimento,
                                       INPUT l-etiqueta,
                                       INPUT c-filtro).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-param
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-param w-cadpaifilho-filho
ON CHOOSE OF bt-param IN FRAME f-cad
DO:
   ASSIGN lVaParaNrTrans = NO.
   RUN pi-busca-cdtrans IN h_v02cl018 (OUTPUT c-cdtrans-ini).
   RUN dispatch IN h_b06cl012 ('open-query':U).   
   ASSIGN c-cdtrans-fim = c-cdtrans-ini.
   RUN bcp/bc0203b.w(INPUT "bc0203":U,
                     INPUT-OUTPUT c-cdtrans-ini,
                     INPUT-OUTPUT c-cdtrans-fim,
                     INPUT-OUTPUT de-trans-ini,
                     INPUT-OUTPUT de-trans-fim,
                     INPUT-OUTPUT da-trans-ini,
                     INPUT-OUTPUT da-trans-fim,
                     INPUT-OUTPUT hr-trans-ini,
                     INPUT-OUTPUT hr-trans-fim,
                     INPUT-OUTPUT c-usu-ini,
                     INPUT-OUTPUT c-usu-fim,
                     INPUT-OUTPUT da-atu-ini,
                     INPUT-OUTPUT da-atu-fim,
                     INPUT-OUTPUT hr-atu-ini,
                     INPUT-OUTPUT hr-atu-fim,
                     INPUT-OUTPUT l-nova,
                     INPUT-OUTPUT l-atualizada,
                     INPUT-OUTPUT l-erro,
                     INPUT-OUTPUT l-em-proces,
                     INPUT-OUTPUT l-cancelado,
                     INPUT-OUTPUT l-movimento,
                     INPUT-OUTPUT l-etiqueta).

   RUN pi-recebe-param IN h_b06cl012 ( INPUT c-cdtrans-ini,
                                       INPUT c-cdtrans-fim,
                                       INPUT de-trans-ini,
                                       INPUT de-trans-fim,
                                       INPUT da-trans-ini,
                                       INPUT da-trans-fim,
                                       INPUT hr-trans-ini,
                                       INPUT hr-trans-fim,
                                       INPUT c-usu-ini,
                                       INPUT c-usu-fim,
                                       INPUT da-atu-ini,
                                       INPUT da-atu-fim,
                                       INPUT hr-atu-ini,
                                       INPUT hr-atu-fim,
                                       INPUT l-nova,
                                       INPUT l-atualizada,
                                       INPUT l-erro,
                                       INPUT l-em-proces,
                                       INPUT l-cancelado,
                                       INPUT l-movimento,
                                       INPUT l-etiqueta,
                                       INPUT c-filtro).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-query
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-query w-cadpaifilho-filho
ON CHOOSE OF bt-query IN FRAME f-cad
DO:
   IF lVaParaNrTrans = YES THEN DO:
      RUN utp/ut-msgs ( INPUT "SHOW":U,
                        INPUT 29746,
                        INPUT STRING(de-nr-trans)).
      IF RETURN-VALUE = "NO" THEN DO:
         ASSIGN  lVaParaNrTrans  = NO.
         RUN dispatch IN h_b06cl012 ('open-query':U).
         RUN pi-recebe-param IN h_b06cl012 ( INPUT c-cdtrans-ini,
                                             INPUT c-cdtrans-fim,
                                             INPUT de-trans-ini,
                                             INPUT de-trans-fim,
                                             INPUT da-trans-ini,
                                             INPUT da-trans-fim,
                                             INPUT hr-trans-ini,
                                             INPUT hr-trans-fim,
                                             INPUT c-usu-ini,
                                             INPUT c-usu-fim,
                                             INPUT da-atu-ini,
                                             INPUT da-atu-fim,
                                             INPUT hr-atu-ini,
                                             INPUT hr-atu-fim,
                                             INPUT l-nova,
                                             INPUT l-atualizada,
                                             INPUT l-erro,
                                             INPUT l-em-proces,
                                             INPUT l-cancelado,
                                             INPUT l-movimento,
                                             INPUT l-etiqueta,
                                             INPUT c-filtro).
      END.
      ELSE
         RUN pi-posiciona-registro.
   END.
   RUN pi-atualiza-query IN h_b06cl012 (INPUT YES).
   RUN dispatch IN h_b06cl012 ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-vapara
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-vapara w-cadpaifilho-filho
ON CHOOSE OF bt-vapara IN FRAME f-cad /* <VP> */
DO:
   ASSIGN  de-nr-trans = 0.
   RUN dispatch IN h_b06cl012 ('open-query':U).
   RUN bcp/bc0203d.w (INPUT-OUTPUT de-nr-trans).

   RUN pi-posiciona-registro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-anterior
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-anterior w-cadpaifilho-filho
ON CHOOSE OF MENU-ITEM mi-anterior /* Anterior */
DO:
   RUN pi-anterior IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-arquivo w-cadpaifilho-filho
ON MENU-DROP OF MENU mi-arquivo /* Arquivo */
DO:
   RUN pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-atualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-atualiza w-cadpaifilho-filho
ON CHOOSE OF MENU-ITEM mi-atualiza /* Atualiza */
DO:
   RUN dispatch IN h_b06cl012 ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-cadpaifilho-filho
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
   RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-cadpaifilho-filho
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
   RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-Filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-Filtro w-cadpaifilho-filho
ON CHOOSE OF MENU-ITEM mi-Filtro /* Filtro */
DO:
   RUN bcp/bc0203a.w (INPUT-OUTPUT c-filtro).
   RUN pi-recebe-filtro IN h_b06cl012 (INPUT c-filtro).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-cadpaifilho-filho
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
   RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-Parametros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-Parametros w-cadpaifilho-filho
ON CHOOSE OF MENU-ITEM mi-Parametros /* Parƒmetros */
DO:
   APPLY "CHOOSE" TO bt-param IN FRAME {&FRAME-NAME}.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-pesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-pesquisa w-cadpaifilho-filho
ON CHOOSE OF MENU-ITEM mi-pesquisa /* Pesquisa */
DO:
   RUN pi-pesquisa IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-primeiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-primeiro w-cadpaifilho-filho
ON CHOOSE OF MENU-ITEM mi-primeiro /* Primeiro */
DO:
   RUN pi-primeiro IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-proximo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-proximo w-cadpaifilho-filho
ON CHOOSE OF MENU-ITEM mi-proximo /* Pr¢ximo */
DO:
   RUN pi-proximo IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-cadpaifilho-filho
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
   RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-cadpaifilho-filho
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
   {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-ultimo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-ultimo w-cadpaifilho-filho
ON CHOOSE OF MENU-ITEM mi-ultimo /* éltimo */
DO:
   RUN pi-ultimo IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-va-para
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-va-para w-cadpaifilho-filho
ON CHOOSE OF MENU-ITEM mi-va-para /* V  para */
DO:
   RUN pi-vapara IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadpaifilho-filho 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */

{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadpaifilho-filho  _ADM-CREATE-OBJECTS
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
         RUN set-position IN h_p-navega ( 1.17 , 1.57 ) NO-ERROR.
         /* Size in UIB:  ( 1.25 , 24.00 ) */
      
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'panel/p-exihel.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'Edge-Pixels = 0,
                       SmartPanelType = NAV-ICON,
                       Right-to-Left = First-On-Left':U ,
               OUTPUT h_p-exihel ).
         RUN set-position IN h_p-exihel ( 1.17 , 74.72 ) NO-ERROR.
         /* Size in UIB:  ( 1.25 , 16.00 ) */
      
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'adm/objects/folder.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'FOLDER-LABELS = ':U + 'Transa‡Æo' + ',
                       FOLDER-TAB-TYPE = 1':U ,
               OUTPUT h_folder ).
         RUN set-position IN h_folder ( 4.00 , 1.00 ) NO-ERROR.
         RUN set-size IN h_folder ( 10.50 , 90.00 ) NO-ERROR.
      
         /* Links to SmartPanel h_p-exihel. */
         RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).
      
         /* Links to SmartFolder h_folder. */
         RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).      
      END.
      
      WHEN 1 THEN DO:
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'clvwr/v02cl018.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'Layout = ':U ,
               OUTPUT h_v02cl018 ).
         RUN set-position IN h_v02cl018 ( 2.67 , 1.00 ) NO-ERROR.
         /* Size in UIB:  ( 1.25 , 88.57 ) */
      
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'clbrw/b06cl012.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'Layout = ':U ,
               OUTPUT h_b06cl012 ).
         RUN set-position IN h_b06cl012 ( 5.46 , 2.14 ) NO-ERROR.
         /* Size in UIB:  ( 8.75 , 87.29 ) */
      
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'clqry/q01cl018.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'ProgPesquisa = clzoom/z01cl018.w,
                       ProgVaPara = clgo/g01cl018.w,
                       ProgIncMod = ,
                       Implantar = no':U ,
               OUTPUT h_q01cl018 ).
         RUN set-position IN h_q01cl018 ( 1.00 , 39.00 ) NO-ERROR.
         /* Size in UIB:  ( 1.79 , 8.29 ) */
      
         /* Links to SmartViewer h_v02cl018. */
         RUN add-link IN adm-broker-hdl ( h_q01cl018 , 'Record':U , h_v02cl018 ).
      
         /* Links to BrowserCadastro2 h_b06cl012. */
         RUN add-link IN adm-broker-hdl ( h_q01cl018 , 'Record':U , h_b06cl012 ).
         RUN add-link IN adm-broker-hdl ( h_b06cl012 , 'Record':U , THIS-PROCEDURE ).
      
         /* Links to SmartQuery h_q01cl018. */
         RUN add-link IN adm-broker-hdl ( h_p-navega , 'Navigation':U , h_q01cl018 ).
         RUN add-link IN adm-broker-hdl ( h_p-navega , 'State':U , h_q01cl018 ).
      
         /* Adjust the tab order of the smart objects. */
      END.   
   END CASE.
   /* Select a Startup page. */
   IF adm-current-page EQ 0 THEN
      RUN select-page IN THIS-PROCEDURE ( 1 ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadpaifilho-filho  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadpaifilho-filho  _DEFAULT-DISABLE
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
   IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadpaifilho-filho) THEN
      DELETE WIDGET w-cadpaifilho-filho.
   
   IF THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadpaifilho-filho  _DEFAULT-ENABLE
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
   ENABLE bt-query
          bt-filtro
          bt-param
          bt-vapara
          rt-button 
      WITH FRAME f-cad IN WINDOW w-cadpaifilho-filho.
   
   {&OPEN-BROWSERS-IN-QUERY-f-cad}
   VIEW w-cadpaifilho-filho.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadpaifilho-filho 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
   /* Code placed here will execute PRIOR to standard behavior. */
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
   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
   {include/i-logfin.i}

   /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadpaifilho-filho 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadpaifilho-filho 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
   /* Code placed here will execute PRIOR to standard behavior. */
   {include/win-size.i}
   RUN pi-before-initialize.

   /* Dispatch standard ADM method.                             */
{utp/ut9000.i "BC0203" "2.00.00.035"} /* 31/08/2023 15:08:04 */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

   RUN pi-recebe-handle IN h_b06cl012( INPUT h_v02cl018,
                                       INPUT h_q01cl018).


   /* O campo data inicial ‚ iniciado com o primeiro dia do mˆs, tratar questäes de performacne e usabilidade do programa */
   ASSIGN da-trans-ini = DATE(MONTH(TODAY), 01,  YEAR(TODAY)).

   /* Code placed here will execute AFTER standard behavior.    */
   RUN pi-after-initialize.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posiciona-registro w-cadpaifilho-filho 
PROCEDURE pi-posiciona-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF de-nr-trans <> 0 THEN DO:
      ASSIGN lVaParaNrTrans = YES.
      RUN pi-vapara-nrtrans IN h_b06cl012(INPUT de-nr-trans,
                                          OUTPUT l-errovp).
      IF l-errovp THEN DO:
         ASSIGN lVaParaNrTrans = NO.
         {utp/ut-liter.i "Numero da transa‡Æo nÆo encontrado."}
         RUN utp/ut-msgs.p(INPUT "SHOW":U,
                           INPUT 17567,
                           INPUT RETURN-VALUE + "(" + STRING(de-nr-trans) + ")" ).
      END.
   END.
   ELSE
      ASSIGN lVaParaNrTrans = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_ems_xref w-cadpaifilho-filho 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator w-cadpaifilho-filho 
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
   RUN "panel\p-navega.w *RTB-SmObj* ".
   RUN "panel\p-exihel.w *RTB-SmObj* ".
   RUN "adm\objects\folder.w *RTB-SmObj* ".
   RUN "clqry\q01cl018.w *RTB-SmObj* ".
   RUN "clbrw\b06cl012.w *RTB-SmObj* ".
   RUN "clvwr\v02cl018.w *RTB-SmObj* ".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadpaifilho-filho  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/
   /* SEND-RECORDS does nothing because there are no External
      Tables specified for this w-paifil, and there are no
      tables specified in any contained Browse, Query, or Frame. */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadpaifilho-filho 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBloqWindow wMaintenance 
PROCEDURE piBloqWindow :
/*------------------------------------------------------------------------------
  Notes: Bloquei Tela
------------------------------------------------------------------------------*/
   ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLibWindow wMaintenance 
PROCEDURE piLibWindow  :
/*------------------------------------------------------------------------------
  Notes: Libera Tela
------------------------------------------------------------------------------*/
   ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
