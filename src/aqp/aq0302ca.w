&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0302CA 2.00.00.003 } /*** 010003 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aq0302ca MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        aq0302ca
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets  bt-voltar  bt-atualizar bt-ratear
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER pd-diferenca AS DECIMAL NO-UNDO.
DEFINE INPUT  PARAMETER pd-qtd-coletiva AS DECIMAL NO-UNDO.
DEFINE OUTPUT PARAMETER pi-opcao     AS INTEGER NO-UNDO.


/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar ed-msg bt-ratear bt-voltar ~
bt-atualizar fi-msg 
&Scoped-Define DISPLAYED-OBJECTS ed-msg fi-msg 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-atualizar 
     LABEL "Atualizar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ratear 
     LABEL "Ratear" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-voltar 
     LABEL "Voltar" 
     SIZE 10 BY 1.

DEFINE VARIABLE ed-msg AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 57 BY 4 NO-UNDO.

DEFINE VARIABLE fi-msg AS CHARACTER FORMAT "X(256)":U INITIAL "Somat¢rio das quantidades difere do total do ponto de coleta" 
      VIEW-AS TEXT 
     SIZE 58 BY .67
     FONT 0 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 62 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ed-msg AT ROW 2.75 COL 3 NO-LABEL
     bt-ratear AT ROW 7.25 COL 2
     bt-voltar AT ROW 7.25 COL 13
     bt-atualizar AT ROW 7.25 COL 23.72
     fi-msg AT ROW 1.58 COL 2.86 NO-LABEL WIDGET-ID 2
     rtToolBar AT ROW 7.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62.57 BY 8.25
         FONT 1 WIDGET-ID 100.


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
         HEIGHT             = 7.71
         WIDTH              = 62
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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
/* SETTINGS FOR FILL-IN fi-msg IN FRAME fpage0
   ALIGN-L                                                              */
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
 
  APPLY "choose":U TO bt-voltar IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-atualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-atualizar wWindow
ON CHOOSE OF bt-atualizar IN FRAME fpage0 /* Atualizar */
DO:
    ASSIGN pi-opcao = 2.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ratear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ratear wWindow
ON CHOOSE OF bt-ratear IN FRAME fpage0 /* Ratear */
DO:
    ASSIGN pi-opcao = 1.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-voltar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-voltar wWindow
ON CHOOSE OF bt-voltar IN FRAME fpage0 /* Voltar */
DO:
    ASSIGN pi-opcao = 0.
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
    DEFINE VARIABLE c-msg AS CHARACTER   NO-UNDO.

    {utp/ut-liter.i Diferen‡a * }
    ASSIGN c-msg = RETURN-VALUE + ": " + STRING(pd-diferenca) + CHR(13). 
    {utp/ut-liter.i Ratear * }
    ASSIGN c-msg = c-msg +  RETURN-VALUE + ":".
    {utp/ut-liter.i divide_diferen‡a_entre_produtores * }
    ASSIGN c-msg = c-msg +  RETURN-VALUE  + CHR(13). 
    {utp/ut-liter.i Voltar * }
    ASSIGN c-msg = c-msg +  RETURN-VALUE + ":".
    {utp/ut-liter.i retorna_…_digita‡Æo * }
    ASSIGN c-msg = c-msg +  RETURN-VALUE + CHR(13). 
    {utp/ut-liter.i Atualizar * }
     ASSIGN c-msg = c-msg +  RETURN-VALUE + ":".
    {utp/ut-liter.i sobrepäe_total_do_ponto_de_coleta * }
    ASSIGN c-msg = c-msg +  RETURN-VALUE.
    

     run utp/ut-msgs.p (INPUT 'msg',
                        INPUT 54693,
                        INPUT ' ').


    ASSIGN fi-msg:SCREEN-VALUE IN FRAME fPage0 = "(" + string(54693) + ") " + RETURN-VALUE.

    ASSIGN ed-msg:SCREEN-VALUE IN FRAME fPage0 = c-msg
           ed-msg:SENSITIVE IN FRAME fPage0 = YES
           ed-msg:READ-ONLY IN FRAME fPage0 = YES.           
    
    ASSIGN bt-ratear:SENSITIVE IN FRAME fPage0 = pd-qtd-coletiva > 0 .
           
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

