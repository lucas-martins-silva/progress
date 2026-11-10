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
{include/i-prgvrs.i IM0100E 2.00.00.004} /*** "010004" 09/07/2026 16:01:59 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0100E MIM}
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
&GLOBAL-DEFINE Program         IM0100E
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel
&GLOBAL-DEFINE page1Widgets   l-imp-import ~
                              l-imp-prod-ind ~
                              l-imp-circ-serv ~
                              l-prg-integ-soc ~
                              l-cont-segur-soc ~
                              l-IBSUF l-IBSMun l-CBS l-IS


/* Parameters Definitions ---                                           */

DEFINE INPUT-OUTPUT PARAMETER p-l-imp-import     AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-l-imp-prod-ind   AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-l-imp-circ-serv  AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-l-prg-integ-soc  AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-l-cont-segur-soc AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-l-IBSUF          AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-l-IBSMun         AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-l-CBS            AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-l-IS             AS LOGICAL NO-UNDO.

/* Local Variable Definitions ---                                       */
DEF VAR l-nt2024002 AS LOGICAL NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002" AND funcao.ativo).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 84.43 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.29 BY 9.71.

DEFINE VARIABLE l-CBS AS LOGICAL INITIAL no 
     LABEL "CBS - Contribui‡Æo sobre Bens e Servi‡os" 
     VIEW-AS TOGGLE-BOX
     SIZE 47.86 BY .88 NO-UNDO.

DEFINE VARIABLE l-cont-segur-soc AS LOGICAL INITIAL no 
     LABEL "COFINS - Contribui‡Æo para o Financiamento da Seguran‡a Social" 
     VIEW-AS TOGGLE-BOX
     SIZE 47.86 BY .88 NO-UNDO.

DEFINE VARIABLE l-IBSMun AS LOGICAL INITIAL no 
     LABEL "IBS Mun - Imposto sobre Bens e Servi‡os Municipal" 
     VIEW-AS TOGGLE-BOX
     SIZE 47.86 BY .88 NO-UNDO.

DEFINE VARIABLE l-IBSUF AS LOGICAL INITIAL no 
     LABEL "IBS UF - Imposto sobre Bens e Servi‡os Estadual" 
     VIEW-AS TOGGLE-BOX
     SIZE 47.86 BY .88 NO-UNDO.

DEFINE VARIABLE l-imp-circ-serv AS LOGICAL INITIAL no 
     LABEL "ICMS - Imposto sobre Circula‡Æo e Servi‡os" 
     VIEW-AS TOGGLE-BOX
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE l-imp-import AS LOGICAL INITIAL no 
     LABEL "II - Imposto de Importa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE l-imp-prod-ind AS LOGICAL INITIAL no 
     LABEL "IPI - Imposto sobre Produtos Industrializados" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE l-IS AS LOGICAL INITIAL no 
     LABEL "IS - Imposto Seletivo" 
     VIEW-AS TOGGLE-BOX
     SIZE 47.86 BY .88 NO-UNDO.

DEFINE VARIABLE l-prg-integ-soc AS LOGICAL INITIAL no 
     LABEL "PIS - Programa de Integra‡Æo Social" 
     VIEW-AS TOGGLE-BOX
     SIZE 46 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 12.67 COL 2.72
     btCancel AT ROW 12.67 COL 13.72
     rtToolBar AT ROW 12.46 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 86.72 BY 13
         FONT 1.

DEFINE FRAME fPage1
     l-imp-import AT ROW 2.13 COL 5.29
     l-imp-prod-ind AT ROW 3.13 COL 5.29
     l-imp-circ-serv AT ROW 4.13 COL 5.29
     l-prg-integ-soc AT ROW 5.13 COL 5.29
     l-cont-segur-soc AT ROW 6.13 COL 5.29
     l-IBSUF AT ROW 7.13 COL 5.29
     l-IBSMun AT ROW 8.13 COL 5.29 WIDGET-ID 2
     l-CBS AT ROW 9.13 COL 5.29
     l-IS AT ROW 10.13 COL 5.29 WIDGET-ID 4
     "Recarrega" VIEW-AS TEXT
          SIZE 8 BY .88 AT ROW 1.25 COL 5.72
     RECT-1 AT ROW 1.63 COL 2.72
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.14 ROW 1.5
         SIZE 84.43 BY 10.75
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
         HEIGHT             = 13.21
         WIDTH              = 86.72
         MAX-HEIGHT         = 24.21
         MAX-WIDTH          = 110.86
         VIRTUAL-HEIGHT     = 24.21
         VIRTUAL-WIDTH      = 110.86
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
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


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    ASSIGN p-l-imp-import     = INPUT FRAME fPage1 l-imp-import    
           p-l-imp-prod-ind   = INPUT FRAME fPage1 l-imp-prod-ind  
           p-l-imp-circ-serv  = INPUT FRAME fPage1 l-imp-circ-serv 
           p-l-prg-integ-soc  = INPUT FRAME fPage1 l-prg-integ-soc 
           p-l-cont-segur-soc = INPUT FRAME fPage1 l-cont-segur-soc
           p-l-IBSUF          = INPUT FRAME fPage1 l-IBSUF
           p-l-IBSMun         = INPUT FRAME fPage1 l-IBSMun
           p-l-CBS            = INPUT FRAME fPage1 l-CBS
           p-l-IS             = INPUT FRAME fPage1 l-IS.

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

ASSIGN l-imp-import:CHECKED     IN FRAME fPage1 = p-l-imp-import    
       l-imp-prod-ind:CHECKED   IN FRAME fPage1 = p-l-imp-prod-ind  
       l-imp-circ-serv:CHECKED  IN FRAME fPage1 = p-l-imp-circ-serv 
       l-prg-integ-soc:CHECKED  IN FRAME fPage1 = p-l-prg-integ-soc 
       l-cont-segur-soc:CHECKED IN FRAME fPage1 = p-l-cont-segur-soc
       l-IBSUF:CHECKED          IN FRAME fPage1 = p-l-IBSUF
       l-IBSMun:CHECKED         IN FRAME fPage1 = p-l-IBSMun
       l-CBS:CHECKED            IN FRAME fPage1 = p-l-CBS
       l-IS:CHECKED             IN FRAME fPage1 = p-l-IS.

IF NOT l-nt2024002 THEN DO:
    ASSIGN l-IBSUF:HIDDEN  IN FRAME fPage1 = YES
           l-IBSMun:HIDDEN IN FRAME fPage1 = YES
           l-CBS:HIDDEN    IN FRAME fPage1 = YES
           l-IS:HIDDEN     IN FRAME fPage1 = YES.
END.

RUN utp/ut-msgs.p (INPUT "show",
                   INPUT 33810,
                   INPUT "").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


