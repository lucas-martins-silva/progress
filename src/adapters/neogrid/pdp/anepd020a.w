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
{include/i-prgvrs.i ANEPD020A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD020A MPD}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ANEPD020A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              tb-pedidos tb-cred-aprov l-ped-nao-aval l-ped-aval l-ped-apro l-ped-repr l-abate-dispon l-abertos l-atend-parcial

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF input-output PARAM p-pedidos       AS LOG NO-UNDO.
DEF input-output PARAM p-cred-aprov    AS LOG NO-UNDO.
DEF input-output PARAM p-ped-nao-aval  AS LOG NO-UNDO.
DEF input-output PARAM p-ped-aval      AS LOG NO-UNDO.
DEF input-output PARAM p-ped-apro      AS LOG NO-UNDO.  
DEF input-output PARAM p-ped-repr      AS LOG NO-UNDO.
DEF input-output PARAM p-abate-dispon  AS LOG NO-UNDO.
DEF input-output PARAM p-abertos       AS LOG NO-UNDO.
DEF input-output PARAM p-atend-parcial AS LOG NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tb-pedidos tb-cred-aprov l-ped-nao-aval ~
l-ped-aval l-ped-apro l-ped-repr l-abate-dispon l-abertos l-atend-parcial ~
btOK btCancel btHelp2 RECT-10 RECT-11 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS tb-pedidos tb-cred-aprov l-ped-nao-aval ~
l-ped-aval l-ped-apro l-ped-repr l-abate-dispon l-abertos l-atend-parcial ~
fi-titulo-1 fi-titulo-2 

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

DEFINE VARIABLE fi-titulo-1 AS CHARACTER FORMAT "X(25)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .63 NO-UNDO.

DEFINE VARIABLE fi-titulo-2 AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 18.72 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.72 BY 2.75.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.72 BY 7.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 43 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE l-abate-dispon AS LOGICAL INITIAL yes 
     LABEL "Abate Dispon¡vel Quantidade Pedido" 
     VIEW-AS TOGGLE-BOX
     SIZE 32.72 BY .83 NO-UNDO.

DEFINE VARIABLE l-abertos AS LOGICAL INITIAL yes 
     LABEL "Abertos" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.43 BY .83 NO-UNDO.

DEFINE VARIABLE l-atend-parcial AS LOGICAL INITIAL yes 
     LABEL "Atendidos Parcialmente" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.43 BY .83 NO-UNDO.

DEFINE VARIABLE l-ped-apro AS LOGICAL INITIAL yes 
     LABEL "Aprovados" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-ped-aval AS LOGICAL INITIAL yes 
     LABEL "Avaliados" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-ped-nao-aval AS LOGICAL INITIAL yes 
     LABEL "NÆo Avaliados" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE l-ped-repr AS LOGICAL INITIAL yes 
     LABEL "Reprovados" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.57 BY .83 NO-UNDO.

DEFINE VARIABLE tb-cred-aprov AS LOGICAL INITIAL yes 
     LABEL "Apenas Pedidos com Cr‚dito Aprovado?" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.43 BY .88 NO-UNDO.

DEFINE VARIABLE tb-pedidos AS LOGICAL INITIAL yes 
     LABEL "Considera Pedidos em Carteira?" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.43 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tb-pedidos AT ROW 2 COL 3.29
     tb-cred-aprov AT ROW 2.92 COL 3.29
     l-ped-nao-aval AT ROW 3.83 COL 3.29
     l-ped-aval AT ROW 4.71 COL 3.29
     l-ped-apro AT ROW 5.63 COL 3.29
     l-ped-repr AT ROW 6.54 COL 3.29
     l-abate-dispon AT ROW 7.46 COL 3.29
     l-abertos AT ROW 9.58 COL 3.29
     l-atend-parcial AT ROW 10.58 COL 3.29
     btOK AT ROW 12.46 COL 2
     btCancel AT ROW 12.46 COL 13
     btHelp2 AT ROW 12.46 COL 33
     fi-titulo-1 AT ROW 1.33 COL 7 COLON-ALIGNED NO-LABEL
     fi-titulo-2 AT ROW 8.83 COL 7 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 9.08 COL 2.29
     RECT-11 AT ROW 1.58 COL 2.29
     rtToolBar AT ROW 12.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 43.72 BY 12.88
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
         HEIGHT             = 13
         WIDTH              = 43.57
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
/* SETTINGS FOR FILL-IN fi-titulo-1 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-titulo-2 IN FRAME fpage0
   NO-ENABLE                                                            */
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
    ASSIGN p-pedidos       = tb-pedidos:CHECKED IN FRAME fPage0
           p-cred-aprov    = tb-cred-aprov:CHECKED IN FRAME fPage0
           p-ped-nao-aval  = l-ped-nao-aval:CHECKED IN FRAME fPage0
           p-ped-aval      = l-ped-aval:CHECKED IN FRAME fPage0
           p-ped-apro      = l-ped-apro:CHECKED IN FRAME fPage0
           p-ped-repr      = l-ped-repr:CHECKED IN FRAME fPage0
           p-abate-dispon  = l-abate-dispon:CHECKED IN FRAME fPage0
           p-abertos       = l-abertos:CHECKED IN FRAME fPage0
           p-atend-parcial = l-atend-parcial:CHECKED IN FRAME fPage0.
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

    {utp/ut-liter.i Situa‡Æo_dos_Pedidos    MPD r} assign fi-titulo-2 = trim(RETURN-VALUE).
    {utp/ut-liter.i Abertos                 MPD r} assign l-abertos:label       in frame fPage0 = trim(return-value).
    {utp/ut-liter.i Atendidos_Parcialmente  MPD r} assign l-atend-parcial:label in frame fPage0 = trim(return-value).

    {utp/ut-liter.i Parƒmetros_de_Pedidos                MPD r} assign fi-titulo-1 = trim(return-value).
    {utp/ut-liter.i Considera_Pedidos_em_Carteira?       MPD r} assign tb-pedidos:label in frame fPage0 = trim(return-value). 
    {utp/ut-liter.i Apenas_Pedidos_com_Cr‚dito_Aprovado? MPD r} assign tb-cred-aprov:LABEL in frame fPage0 = trim(return-value).
    {utp/ut-liter.i NÆo_Avaliados  MPD r} assign l-ped-nao-aval:label in frame fPage0 = trim(return-value).
    {utp/ut-liter.i Avaliados      MPD r} assign l-ped-aval:label in frame fPage0 = trim(return-value).
    {utp/ut-liter.i Aprovados      MPD r} assign l-ped-apro:label in frame fPage0 = trim(return-value).
    {utp/ut-liter.i Reprovados     MPD r} assign l-ped-repr:label in frame fPage0 = trim(return-value).
    {utp/ut-liter.i Abate_Dispon¡vel_Quantidade_Pedido  MPD r} assign l-abate-dispon:label in frame fPage0 = trim(return-value).

    DISP fi-titulo-1 fi-titulo-2 WITH FRAME fPage0.

    ASSIGN tb-pedidos:CHECKED      IN FRAME fPage0 = p-pedidos      
           tb-cred-aprov:CHECKED   IN FRAME fPage0 = p-cred-aprov   
           l-ped-nao-aval:CHECKED  IN FRAME fPage0 = p-ped-nao-aval 
           l-ped-aval:CHECKED      IN FRAME fPage0 = p-ped-aval     
           l-ped-apro:CHECKED      IN FRAME fPage0 = p-ped-apro     
           l-ped-repr:CHECKED      IN FRAME fPage0 = p-ped-repr     
           l-abate-dispon:CHECKED  IN FRAME fPage0 = p-abate-dispon 
           l-abertos:CHECKED       IN FRAME fPage0 = p-abertos      
           l-atend-parcial:CHECKED IN FRAME fPage0 = p-atend-parcial.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

