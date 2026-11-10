&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mguni            PROGRESS
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
{include/i-prgvrs.i AB0138S 2.00.00.003}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0138s MAB}
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
&GLOBAL-DEFINE Program        AB0138S
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              cEstFim cEstIni cGrFim cGrIni ~
                              cModFim cModIni cPlacaFim cPlacaIni ~
                              cSitFim cSitIni iEmpFim iEmpIni ~
                              tgMotor tgNMotor

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER pMotor     AS   LOGICAL                    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pNMotor    AS   LOGICAL                    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pModeloIni LIKE mab-eqpto.cod-model        NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pModeloFim LIKE mab-eqpto.cod-model        NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pGrIni     LIKE mab-eqpto.cod-grp-eqpto    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pGrFim     LIKE mab-eqpto.cod-grp-eqpto    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pEmpIni    LIKE mab-eqpto.ep-codigo        NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pEmpFim    LIKE mab-eqpto.ep-codigo        NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pEstIni    LIKE mab-eqpto.cod-estabel      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pEstFim    LIKE mab-eqpto.cod-estabel      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pSitIni    LIKE mab-eqpto.cod-sit-eqpto    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pSitFim    LIKE mab-eqpto.cod-sit-eqpto    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pPlacaIni  LIKE mab-eqpto.cod-placa        NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pPlacaFim  LIKE mab-eqpto.cod-placa        NO-UNDO.
DEFINE INPUT        PARAMETER pPage      AS   INTEGER                    NO-UNDO.
DEFINE OUTPUT       PARAMETER pOK        AS   LOGICAL                    NO-UNDO.
define input        parameter pHabilita  as  logical                     no-undo.  
/* Local INPUT-OUTPUT PARAMETER Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-13 ~
IMAGE-14 IMAGE-15 IMAGE-16 IMAGE-17 IMAGE-18 IMAGE-2 IMAGE-9 RECT-13 ~
rtToolBar cGrIni cGrFim iEmpIni iEmpFim cEstIni cEstFim cPlacaIni cPlacaFim ~
cModIni cModFim cSitIni cSitFim tgMotor tgNMotor btOK btCancel btHelp2 ~
text-1 
&Scoped-Define DISPLAYED-OBJECTS cGrIni cGrFim iEmpIni iEmpFim cEstIni ~
cEstFim cPlacaIni cPlacaFim cModIni cModFim cSitIni cSitFim tgMotor ~
tgNMotor text-1 

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

DEFINE VARIABLE cEstFim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cEstIni LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cGrFim AS CHARACTER FORMAT "x(8)" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cGrIni AS CHARACTER FORMAT "x(8)" 
     LABEL "Grupo Equipamento":R21 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cModFim AS CHARACTER FORMAT "x(8)" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cModIni AS CHARACTER FORMAT "x(8)" 
     LABEL "Modelo Eqpto":R15 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cPlacaFim AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cPlacaIni AS CHARACTER FORMAT "x(12)" 
     LABEL "Placa":R7 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cSitFim AS CHARACTER FORMAT "x(8)" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cSitIni AS CHARACTER FORMAT "x(8)" 
     LABEL "Situa‡Æo Equipamento":R24 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iEmpFim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iEmpIni LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(40)":U INITIAL "Tipo Equipamento" 
      VIEW-AS TEXT 
     SIZE 13 BY .67 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 1.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tgMotor AS LOGICAL INITIAL no 
     LABEL "Motorizado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgNMotor AS LOGICAL INITIAL no 
     LABEL "NÆo Motorizado" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     cGrIni AT ROW 1.5 COL 3.29 HELP
          "C¢digo Grupo Equipamento"
     cGrFim AT ROW 1.5 COL 50.57 HELP
          "C¢digo Grupo Equipamento" NO-LABEL
     iEmpIni AT ROW 2.5 COL 18.42 HELP
          "C¢digo da empresa"
          FONT 1
     iEmpFim AT ROW 2.5 COL 50.57 HELP
          "C¢digo da empresa" NO-LABEL
          FONT 1
     cEstIni AT ROW 3.5 COL 18.42 HELP
          "C¢digo do estabelecimento"
          FONT 1
     cEstFim AT ROW 3.5 COL 50.57 HELP
          "C¢digo do estabelecimento" NO-LABEL
          FONT 1
     cPlacaIni AT ROW 4.5 COL 10.86 HELP
          "Placa"
     cPlacaFim AT ROW 4.5 COL 50.57 HELP
          "Placa" NO-LABEL
     cModIni AT ROW 5.5 COL 7.72 HELP
          "C¢digo Modelo Equipamento"
     cModFim AT ROW 5.5 COL 50.57 HELP
          "C¢digo Modelo Equipamento" NO-LABEL
     cSitIni AT ROW 6.5 COL 1.43 HELP
          "C¢digo da Situacao do Equipamento"
     cSitFim AT ROW 6.5 COL 50.57 HELP
          "C¢digo da Situacao do Equipamento" NO-LABEL
     tgMotor AT ROW 8.13 COL 25.72
     tgNMotor AT ROW 8.13 COL 44.29
     btOK AT ROW 9.58 COL 2
     btCancel AT ROW 9.58 COL 13
     btHelp2 AT ROW 9.58 COL 70
     text-1 AT ROW 7.5 COL 18.14 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 1.5 COL 32.29
     IMAGE-10 AT ROW 2.5 COL 47.72
     IMAGE-11 AT ROW 3.5 COL 32.29
     IMAGE-12 AT ROW 3.5 COL 47.72
     IMAGE-13 AT ROW 4.5 COL 32.29
     IMAGE-14 AT ROW 4.5 COL 47.72
     IMAGE-15 AT ROW 5.5 COL 32.29
     IMAGE-16 AT ROW 5.5 COL 47.72
     IMAGE-17 AT ROW 6.5 COL 32.29
     IMAGE-18 AT ROW 6.5 COL 47.72
     IMAGE-2 AT ROW 1.5 COL 47.72
     IMAGE-9 AT ROW 2.5 COL 32.29
     RECT-13 AT ROW 7.75 COL 18.86
     rtToolBar AT ROW 9.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 9.83
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
         HEIGHT             = 9.83
         WIDTH              = 80
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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
/* SETTINGS FOR FILL-IN cEstFim IN FRAME fpage0
   ALIGN-L LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                  */
/* SETTINGS FOR FILL-IN cEstIni IN FRAME fpage0
   ALIGN-L LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                  */
/* SETTINGS FOR FILL-IN cGrFim IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cGrIni IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cModFim IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cModIni IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cPlacaFim IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cPlacaIni IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cSitFim IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cSitIni IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN iEmpFim IN FRAME fpage0
   ALIGN-L LIKE = mguni.empresa.ep-codigo EXP-SIZE                      */
/* SETTINGS FOR FILL-IN iEmpIni IN FRAME fpage0
   ALIGN-L LIKE = mguni.empresa.ep-codigo EXP-SIZE                      */
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
    assign pOk = no.

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
    assign pMotor     = input frame fPage0 tgMotor
           pNMotor    = input frame fPage0 tgnMotor
           pModeloIni = input frame fPage0 cModIni
           pModeloFim = input frame fPage0 cModFim
           pGrIni     = input frame fPage0 cGrIni
           pGrFim     = input frame fPage0 cGrFim
           pEmpIni    = input frame fPage0 iEmpIni    
           pEmpFim    = input frame fPage0 iEmpFim    
           pEstIni    = input frame fPage0 cEstIni
           pEstFim    = input frame fPage0 cEstFim
           pSitIni    = input frame fPage0 cSitIni
           pSitFim    = input frame fPage0 cSitFim
           pPlacaIni  = input frame fPage0 cPlacaIni 
           pPlacaFim  = input frame fPage0 cPlacaFim 
           pOK        = yes.

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
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) inicializa‡Æo da tela
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Grupo Equipamento"}
assign cGrIni:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Empresa"}
assign iEmpIni:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Estabelecimento"}
assign cEstIni:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Placa"}
assign cPlacaIni:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Modelo Equipamento"}
assign cModIni:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Situa‡Æo Equipamento"}
assign cSitIni:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Motorizado"}
assign tgMotor:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "NÆo Motorizado"}
assign tgnMotor:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Tipo Equipamento"}
assign text-1 = trim(return-value).

assign tgMotor   = pMotor    
       tgnMotor  = pNMotor   
       cGrIni    = pGrIni   
       cGrFim    = pGrFim   
       iEmpIni   = pEmpIni   
       iEmpFim   = pEmpFim       
       cEstIni   = pEstIni       
       cEstFim   = pEstFim   
       cPlacaIni = pPlacaIni   
       cPlacaFim = pPlacaFim   
       cModIni   = pModeloIni   
       cModFim   = pModeloFim   
       cSitIni   = pSitIni 
       cSitFim   = pSitFim.

if pHabilita  then
    assign  tgMotor:sensitive in frame fPAGE0 = yes
            tgnMotor:sensitive in frame fPAGE0 = yes.
else
     assign  tgMotor:sensitive in frame fPAGE0 = no   
             tgnMotor:sensitive in frame fPAGE0 = no. 

case pPage:
    when 2 then
        assign cModIni   = "":U
               cModFim   = "ZZZZZZZZ":U
               cModIni:sensitive in frame fPage0 = no
               cModFim:sensitive in frame fPage0 = no
               cSitIni:sensitive in frame fPage0 = yes
               cSitFim:sensitive in frame fPage0 = yes.
    when 3 then         
        assign cSitIni   = "":U
               cSitFim   = "ZZZZZZZZ":U
               cModIni:sensitive in frame fPage0 = yes
               cModFim:sensitive in frame fPage0 = yes
               cSitIni:sensitive in frame fPage0 = no
               cSitFim:sensitive in frame fPage0 = no.
    otherwise
        assign iEmpIni  = &IF "{&mguni_version}" >= "2.071" &THEN "" &else 0 &ENDIF
               iEmpFim  = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ" &else 999 &ENDIF
               iEmpIni:sensitive in frame fPage0 = no
               iEmpFim:sensitive in frame fPage0 = no
               cModIni:sensitive in frame fPage0 = yes
               cModFim:sensitive in frame fPage0 = yes
               cSitIni:sensitive in frame fPage0 = yes
               cSitFim:sensitive in frame fPage0 = yes.
end case.

disp tgMotor   tgnMotor 
     cGrIni    cGrFim   
     iEmpIni   iEmpFim  
     cEstIni   cEstFim  
     cPlacaIni cPlacaFim
     cModIni   cModFim  
     cSitIni   cSitFim  
     text-1
  with frame fPage0.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

