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
{include/i-prgvrs.i AB0402A 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0402a MAB}
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
&GLOBAL-DEFINE Program        AB0402A
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              fiData fiHora fiHodometro fiHodometroSec fiAtividade

/* Parameters Definitions ---                                           */
define input  parameter pRowid          as   rowid                                    no-undo.
define input  parameter pUN             as   character                                no-undo.
define input  parameter pUNSec          as   CHARACTER                                no-undo.
define input  parameter pUsaContadorSec as   LOGICAL                                  no-undo.
define output parameter pHodometro      like mab-abastec-lubrific.val-hodom-horim     no-undo.
define output parameter pHodometroSec   like mab-abastec-lubrific.val-hodom-horim-sec no-undo.
define output parameter pData           like mab-abastec-lubrific.dat-movto           no-undo.
define output parameter pHora           like mab-abastec-lubrific.hra-inicial         no-undo.
define output parameter pAtividade      like mab-abastec-lubrific.cod-ativid          no-undo.
define output parameter lOK             as   logical                                  no-undo.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cHora AS CHARACTER format "99:99:99" NO-UNDO.
define buffer bfApont for mab-abastec-lubrific.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-18 RECT-19 rtToolBar fiDocumento ~
fiHodometro fiUN fiHodometroSec fiUNSec fiData fiHora fiAtividade btOK ~
btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fiDocumento fiHodometro fiUN ~
fiHodometroSec fiUNSec fiData fiHora fiAtividade 

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

DEFINE VARIABLE fiAtividade AS CHARACTER FORMAT "X(8)":U 
     LABEL "Atividade" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fiData AS DATE FORMAT "99/99/9999" INITIAL 08/05/03 
     LABEL "Data Movimento":R17 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiDocumento AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Documento":R11 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiHodometro AS DECIMAL FORMAT ">>>>>>9.9" INITIAL 0 
     LABEL "Contador":R23 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiHodometroSec AS DECIMAL FORMAT ">>>>>>9.9" INITIAL 0 
     LABEL "Contador Secund rio":R23 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiHora AS CHARACTER FORMAT "99:99:99" INITIAL "00:00:00" 
     LABEL "Hora Inicial":R15 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fiUN AS CHARACTER FORMAT "xx":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fiUNSec AS CHARACTER FORMAT "xx":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 50 BY 1.5.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 50 BY 5.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 50 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiDocumento AT ROW 1.5 COL 18 COLON-ALIGNED HELP
          "N£mero do Documento de Abastecimentos/Lubrifica‡äes"
     fiHodometro AT ROW 3.29 COL 18 COLON-ALIGNED HELP
          "Valor Hod“metro/Hor¡metro do Equipamento"
     fiUN AT ROW 3.29 COL 28.57 COLON-ALIGNED NO-LABEL
     fiHodometroSec AT ROW 4.29 COL 18 COLON-ALIGNED HELP
          "Valor Hod“metro/Hor¡metro do Equipamento"
     fiUNSec AT ROW 4.29 COL 28.57 COLON-ALIGNED NO-LABEL
     fiData AT ROW 5.29 COL 18 COLON-ALIGNED HELP
          "Data do movimento"
     fiHora AT ROW 6.29 COL 18 COLON-ALIGNED HELP
          "Hora Inicial do Abastecimento / Troca àleo - Filtro."
     fiAtividade AT ROW 7.29 COL 18 COLON-ALIGNED
     btOK AT ROW 8.88 COL 2
     btCancel AT ROW 8.88 COL 13
     btHelp2 AT ROW 8.88 COL 40
     RECT-18 AT ROW 1.25 COL 1
     RECT-19 AT ROW 3 COL 1
     rtToolBar AT ROW 8.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 50 BY 9.25
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
         HEIGHT             = 9.25
         WIDTH              = 50
         MAX-HEIGHT         = 9.25
         MAX-WIDTH          = 50
         VIRTUAL-HEIGHT     = 9.25
         VIRTUAL-WIDTH      = 50
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
    assign lOK = no.
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
    assign pHodometro    = input frame fPage0 fiHodometro
           pHodometroSec = input frame fPage0 fiHodometroSec
           pData      = input frame fPage0 fiData
           pHora      = input frame fPage0 fiHora
           pAtividade = INPUT FRAME fPage0 fiAtividade
           lOK        = yes.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiAtividade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiAtividade wWindow
ON F5 OF fiAtividade IN FRAME fpage0 /* Atividade */
DO:
    {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr001.w"
           &FieldZoom1="cod-ativid"
           &FieldScreen1="fiAtividade"
           &Frame1="fPage0"
           &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiAtividade wWindow
ON MOUSE-SELECT-DBLCLICK OF fiAtividade IN FRAME fpage0 /* Atividade */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiHora
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiHora wWindow
ON LEAVE OF fiHora IN FRAME fpage0 /* Hora Inicial */
DO:
    /** Consiste o hor rio **/
    assign cHora = fiHora:screen-value in frame fPage0.
    run piFormataHorarioSeg (input-output cHora).
    if return-value = "NOK":U then do:
        apply "ENTRY":U to fiHora in frame fPage0.
        return no-apply.
    end.
    assign fiHora:screen-value in frame fPage0 = cHora.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
fiAtividade:LOAD-MOUSE-POINTER("image~\lupa.cur":U)  in frame fPage0.
{window/mainblock.i}

{abp/ab9000.i}  /** Procedure buscaFormatoConta **/

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
    DISPLAY fiDocumento fiUN fiUnSec fiAtividade WITH FRAME fPage0.

    IF  NOT pUsaContadorSec THEN
        ASSIGN fiHodometroSec:SENSITIVE IN FRAME fPage0 = NO.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override (antes) inicializa‡Æo de tela.
------------------------------------------------------------------------------*/
if pRowid <> ? then do:
    for first bfApont
        where rowid(bfApont) = pRowid no-lock:
        assign fiDocumento    = bfApont.num-docto
               fiHodometro    = bfApont.val-hodom-horim
               fiHodometroSec = bfApont.val-hodom-horim-sec
               fiData         = bfApont.dat-movto
               fiHora         = bfApont.hra-inicial
               fiAtividade    = bfApont.cod-ativid.
    end.
end.

assign fiUN    = pUN
       fiUNSec = pUNSec.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

