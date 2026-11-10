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
{include/i-prgvrs.i AB0608C 2.00.00.008 } /*** 010008 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0608c MAB}
&ENDIF



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0608C
&GLOBAL-DEFINE Version        2.00.00.007

&GLOBAL-DEFINE WindowType    Detail

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 tgComtvel tgLubrific ~
                              tgTerceiros tgProprios tgHabilita tgAtivos tgInativos tgMotorizados tgNmotorizados tgTerc tgProprio tgAtualiza cb-moeda rs-classifica tgIntegrados tgNaoIntegrados tgBuscaMovtoEstoque

{abp/ab0608.i} /** Defini‡Æo da ttSelecao **/

/* Parameters Definitions ---                                           */
define input-output parameter table for ttSelecao.

DEF VAR c-moeda AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-24 RECT-25 RECT-26 ~
RECT-63 rtToolBar RECT-64 tgComtvel tgProprios cb-moeda tgLubrific ~
tgTerceiros tgHabilita rs-classifica tgAtualiza tgAtivos tgMotorizados ~
tgTerc tgInativos tgNmotorizados tgProprio tgIntegrados tgNaoIntegrados ~
tgBuscaMovtoEstoque btOK btCancel btHelp2 fi-classifica 
&Scoped-Define DISPLAYED-OBJECTS tgComtvel tgProprios cb-moeda tgLubrific ~
tgTerceiros tgHabilita rs-classifica tgAtualiza tgAtivos tgMotorizados ~
tgTerc tgInativos tgNmotorizados tgProprio tgIntegrados tgNaoIntegrados ~
tgBuscaMovtoEstoque fi-classifica 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fi-classifica AS CHARACTER FORMAT "X(15)":U INITIAL "Classifica‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.43 BY .67 NO-UNDO.

DEFINE VARIABLE rs-classifica AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "C¢digo", 1,
"Valor", 2,
"Quantidade", 3
     SIZE 18 BY 1.75 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21.43 BY 2.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39.43 BY 2.75.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17.72 BY 2.75.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27.72 BY 2.75.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27.72 BY 2.75.

DEFINE RECTANGLE RECT-63
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68.14 BY 3.

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 2.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 69 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tgAtivos AS LOGICAL INITIAL yes 
     LABEL "Ativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgAtualiza AS LOGICAL INITIAL no 
     LABEL "Atualizar somente documentos sem NFs" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE tgBuscaMovtoEstoque AS LOGICAL INITIAL no 
     LABEL "Busca movimentos pela Data de Integra‡Æo no Estoque" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .83 NO-UNDO.

DEFINE VARIABLE tgComtvel AS LOGICAL INITIAL yes 
     LABEL "Combust¡vel" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.14 BY .83 NO-UNDO.

DEFINE VARIABLE tgHabilita AS LOGICAL INITIAL no 
     LABEL "Habilitar BotÆo Nota Fiscal" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE tgInativos AS LOGICAL INITIAL no 
     LABEL "Inativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgIntegrados AS LOGICAL INITIAL yes 
     LABEL "Intregrados" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgLubrific AS LOGICAL INITIAL yes 
     LABEL "Lubrificantes" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgMotorizados AS LOGICAL INITIAL yes 
     LABEL "Motorizados" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgNaoIntegrados AS LOGICAL INITIAL yes 
     LABEL "NÆo Integrados" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tgNmotorizados AS LOGICAL INITIAL yes 
     LABEL "NÆo Motorizados" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.14 BY .83 NO-UNDO.

DEFINE VARIABLE tgProprio AS LOGICAL INITIAL yes 
     LABEL "Pr¢prios" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgProprios AS LOGICAL INITIAL yes 
     LABEL "Pr¢prios" 
     VIEW-AS TOGGLE-BOX
     SIZE 10.86 BY .83 NO-UNDO.

DEFINE VARIABLE tgTerc AS LOGICAL INITIAL yes 
     LABEL "Terceiros" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgTerceiros AS LOGICAL INITIAL no 
     LABEL "Terceiros" 
     VIEW-AS TOGGLE-BOX
     SIZE 9.86 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tgComtvel AT ROW 2 COL 7.86
     tgProprios AT ROW 2 COL 28.14
     cb-moeda AT ROW 2.25 COL 44.86 COLON-ALIGNED NO-LABEL
     tgLubrific AT ROW 3 COL 7.86
     tgTerceiros AT ROW 3 COL 28.14
     tgHabilita AT ROW 5 COL 6
     rs-classifica AT ROW 5.21 COL 45.43 NO-LABEL
     tgAtualiza AT ROW 6 COL 6
     tgAtivos AT ROW 8.25 COL 2.72
     tgMotorizados AT ROW 8.25 COL 22.86
     tgTerc AT ROW 8.25 COL 50.14
     tgInativos AT ROW 9.25 COL 2.72
     tgNmotorizados AT ROW 9.25 COL 22.86
     tgProprio AT ROW 9.25 COL 50.14
     tgIntegrados AT ROW 11.5 COL 17.29
     tgNaoIntegrados AT ROW 11.5 COL 40.43
     tgBuscaMovtoEstoque AT ROW 12.5 COL 17.29 WIDGET-ID 2
     btOK AT ROW 14.21 COL 2
     btCancel AT ROW 14.21 COL 13
     btHelp2 AT ROW 14.21 COL 59.14
     fi-classifica AT ROW 4.33 COL 41.57 COLON-ALIGNED NO-LABEL
     "Movimento Estoque" VIEW-AS TEXT
          SIZE 14.29 BY .54 AT ROW 10.75 COL 2.72
     "Moeda" VIEW-AS TEXT
          SIZE 5.72 BY .54 AT ROW 1.25 COL 43.29
     "Equipamentos" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 7.5 COL 2.57
     "Postos" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 1.25 COL 25
     RECT-1 AT ROW 1.5 COL 1.57
     RECT-2 AT ROW 4.5 COL 1.57
     RECT-24 AT ROW 1.5 COL 23.29
     RECT-25 AT ROW 1.5 COL 41.72
     RECT-26 AT ROW 4.5 COL 41.86
     RECT-63 AT ROW 7.75 COL 1.57
     rtToolBar AT ROW 14 COL 1
     RECT-64 AT ROW 11 COL 1.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69 BY 14.58
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 14.63
         WIDTH              = 69
         MAX-HEIGHT         = 28.92
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.92
         VIRTUAL-WIDTH      = 146.29
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
    run piGrava in this-procedure.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s inicializa‡Æo da tela.
------------------------------------------------------------------------------*/
{utp/ut-liter.i Classifica‡Æo *}
 
FOR FIRST mab-param-integr fields(des-valor cdn-param)
    where mab-param-integr.cdn-param = 8 no-lock:
    /* Caso Produto nÆo integrar com E M S */
    if  mab-param-integr.des-valor = "1" THEN DO:
        /** Desabilita parametros **/
        ASSIGN tgIntegrados:SENSITIVE      in frame fPage0 = NO
               tgNaoIntegrados:SENSITIVE   in frame fPage0 = NO.
    END.
END.

assign fi-classifica:screen-value in frame fPage0 = return-value.
/** Busca Moeda **/
find first moeda 
    where moeda.mo-codigo = 0 no-lock no-error.

assign cb-moeda:list-items in frame fPage0  = '0 - ' + moeda.descricao
       cb-moeda:screen-value in frame fPage0 = cb-moeda:list-items
       c-moeda = cb-moeda:list-items.

find first param-estoq no-lock no-error.
    
if  param-estoq.tem-moeda1 then do:
    find first moeda
        where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
    assign cb-moeda:list-items = cb-moeda:list-items + ',1 - ' + moeda.descricao.
end.
if param-estoq.tem-moeda2 then do:
    find first moeda 
        where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
    assign cb-moeda:list-items = cb-moeda:list-items + ',2 - ' + moeda.descricao.
end.
assign cb-moeda:screen-value in frame fPage0 = c-moeda.


/** Busca Parƒmtros **/
find first ttSelecao no-lock no-error.
if avail ttSelecao then do:
    assign tgComtvel:checked      in frame fPage0 = ttSelecao.lCombutivel   
           tgLubrific:checked     in frame fPage0 = ttSelecao.lLubrific     
           tgProprios:checked     in frame fPage0 = ttSelecao.lProprios     
           tgTerceiros:checked    in frame fPage0 = ttSelecao.lTerceiros 
           tgHabilita:checked     in frame fPage0 = ttSelecao.lHabilita  
           tgAtualiza:checked     in frame fPage0 = ttSelecao.lAtualiza         
           cb-moeda:screen-value  in frame fPage0 = ttSelecao.cb-moeda
           rs-classifica                          = ttSelecao.classifica
           tgAtivos:checked         in frame fPage0 = ttSelecao.lAtivos
           tgInativos:checked       in frame fPage0 = ttSelecao.lInativos
           tgMotorizados:checked    in frame fPage0 = ttSelecao.lMotorizados
           tgNmotorizados:checked   in frame fPage0 = ttSelecao.lNmotorizados
           tgTerc:checked           in frame fPage0 = ttSelecao.lTerc
           tgProprio:checked        in frame fPage0 = ttSelecao.lProprio
           tgIntegrados:checked     in frame fPage0 = ttSelecao.lIntegrados
           tgNaoIntegrados:checked  in frame fPage0 = ttSelecao.lNaoIntegrados
           tgBuscaMovtoEstoque:checked  in frame fPage0 = ttSelecao.lBuscaMovtoEstoque.
end.
disp rs-classifica with frame fPage0.

return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGrava wWindow 
PROCEDURE piGrava :
/*------------------------------------------------------------------------------
  Purpose:     piGrava
  Parameters:  <none>
  Notes:       Grava os parƒmetros selecionados na temp-table
------------------------------------------------------------------------------*/

find first ttSelecao exclusive-lock no-error.
if avail ttSelecao then do:
    assign ttSelecao.lCombutivel    = tgComtvel:checked       in frame fPage0    
           ttSelecao.lLubrific      = tgLubrific:checked      in frame fPage0    
           ttSelecao.lProprios      = tgProprios:checked      in frame fPage0    
           ttSelecao.lTerceiros     = tgTerceiros:checked     in frame fPage0
           ttSelecao.lHabilita      = tgHabilita:checked      in frame fPage0
           ttSelecao.lAtualiza      = tgAtualiza:checked      in frame fPage0
           ttSelecao.cb-moeda       = cb-moeda:screen-value   in frame fPage0
           ttSelecao.classifica     = input frame fPage0 rs-classifica
           ttSelecao.lAtivos        = tgAtivos:checked        in frame fPage0
           ttSelecao.lInativos      = tgInativos:checked      in frame fPage0
           ttSelecao.lAtualiza      = tgAtualiza:checked      in frame fPage0
           ttSelecao.lMotorizados   = tgMotorizados:checked   in frame fPage0
           ttSelecao.lNmotorizados  = tgNmotorizados:checked  in frame fPage0
           ttSelecao.lTerc          = tgTerc:checked          in frame fPage0
           ttSelecao.lProprio       = tgProprio:checked       in frame fPage0
           ttSelecao.lIntegrados    = tgIntegrados:checked    in frame fPage0
           ttSelecao.lNaoIntegrados = tgNaoIntegrados:checked in frame fPage0
           ttSelecao.lBuscaMovtoEstoque = tgBuscaMovtoEstoque:checked in frame fPage0.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

