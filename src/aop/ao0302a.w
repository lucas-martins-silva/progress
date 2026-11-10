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
{include/i-prgvrs.i AO0302A 2.00.00.003}  /*** 010003 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0302a MAO}
&ENDIF



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AO0302A
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE WindowType    Detail

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 tgPadrao tgNPadrao tgData tgTexto ~
                              tgNumerico tgTabela tgAprovado tgReprovado tgPendente tgAprovUsuar ~
                              tgAmostAprovado tgAmostReprovado tgAmostPendente tgAmostAprovUsuar 
{aop/ao0302.i} /** Defini‡Æo da ttSelecao **/

/* Parameters Definitions ---                                           */
define input-output parameter table for ttSelecao.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 RECT-4 rtToolBar ~
tgPadrao tgNPadrao tgNumerico tgTexto tgData tgTabela tgPendente ~
tgAprovUsuar tgAmostPendente tgAmostAprovUsuar tgAprovado tgReprovado ~
tgAmostAprovado tgAmostReprovado btOK btCancel btHelp2 fiTexto1 fiTexto2 ~
fiTexto3 fiTexto4 
&Scoped-Define DISPLAYED-OBJECTS tgPadrao tgNPadrao tgNumerico tgTexto ~
tgData tgTabela tgPendente tgAprovUsuar tgAmostPendente tgAmostAprovUsuar ~
tgAprovado tgReprovado tgAmostAprovado tgAmostReprovado fiTexto1 fiTexto2 ~
fiTexto3 fiTexto4 

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

DEFINE VARIABLE fiTexto1 AS CHARACTER FORMAT "X(256)":U INITIAL "Ensaios" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto2 AS CHARACTER FORMAT "X(256)":U INITIAL "Tipo Resultado" 
      VIEW-AS TEXT 
     SIZE 13 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto3 AS CHARACTER FORMAT "X(256)":U INITIAL "Estado dos Ensaios" 
      VIEW-AS TEXT 
     SIZE 15 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto4 AS CHARACTER FORMAT "X(256)":U INITIAL "Estado das Amostras" 
      VIEW-AS TEXT 
     SIZE 15 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39.43 BY 3.21.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 3.25.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 2.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39.43 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 85 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tgAmostAprovado AS LOGICAL INITIAL yes 
     LABEL "Aprovado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .83 NO-UNDO.

DEFINE VARIABLE tgAmostAprovUsuar AS LOGICAL INITIAL yes 
     LABEL "Aprovado pelo Usu rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.14 BY .83 NO-UNDO.

DEFINE VARIABLE tgAmostPendente AS LOGICAL INITIAL yes 
     LABEL "Pendente" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .83 NO-UNDO.

DEFINE VARIABLE tgAmostReprovado AS LOGICAL INITIAL yes 
     LABEL "Reprovado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .83 NO-UNDO.

DEFINE VARIABLE tgAprovado AS LOGICAL INITIAL yes 
     LABEL "Aprovado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .83 NO-UNDO.

DEFINE VARIABLE tgAprovUsuar AS LOGICAL INITIAL yes 
     LABEL "Aprovado pelo Usu rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.14 BY .83 NO-UNDO.

DEFINE VARIABLE tgData AS LOGICAL INITIAL yes 
     LABEL "Data" 
     VIEW-AS TOGGLE-BOX
     SIZE 8.14 BY .83 NO-UNDO.

DEFINE VARIABLE tgNPadrao AS LOGICAL INITIAL yes 
     LABEL "NÆo PadrÆo" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE tgNumerico AS LOGICAL INITIAL yes 
     LABEL "Num‚rico" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgPadrao AS LOGICAL INITIAL yes 
     LABEL "PadrÆo" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE tgPendente AS LOGICAL INITIAL yes 
     LABEL "Pendente" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .83 NO-UNDO.

DEFINE VARIABLE tgReprovado AS LOGICAL INITIAL yes 
     LABEL "Reprovado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgTabela AS LOGICAL INITIAL yes 
     LABEL "Tabela" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgTexto AS LOGICAL INITIAL yes 
     LABEL "Texto" 
     VIEW-AS TOGGLE-BOX
     SIZE 10.14 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tgPadrao AT ROW 2.13 COL 4.86
     tgNPadrao AT ROW 2.13 COL 19.86
     tgNumerico AT ROW 2.13 COL 46.14
     tgTexto AT ROW 2.13 COL 65.86
     tgData AT ROW 3.04 COL 65.86
     tgTabela AT ROW 3.13 COL 46.14
     tgPendente AT ROW 5.46 COL 4.86
     tgAprovUsuar AT ROW 5.46 COL 19.86
     tgAmostPendente AT ROW 5.46 COL 46.14
     tgAmostAprovUsuar AT ROW 5.5 COL 65.86
     tgAprovado AT ROW 6.46 COL 4.86
     tgReprovado AT ROW 6.46 COL 19.86
     tgAmostAprovado AT ROW 6.46 COL 46
     tgAmostReprovado AT ROW 6.46 COL 65.86
     btOK AT ROW 7.92 COL 2
     btCancel AT ROW 7.92 COL 13
     btHelp2 AT ROW 7.92 COL 75.43
     fiTexto1 AT ROW 1.08 COL 2.86 NO-LABEL
     fiTexto2 AT ROW 1.17 COL 40.86 COLON-ALIGNED NO-LABEL
     fiTexto3 AT ROW 4.71 COL 2 COLON-ALIGNED NO-LABEL
     fiTexto4 AT ROW 4.75 COL 41 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1.29 COL 1.57
     RECT-2 AT ROW 1.29 COL 42
     RECT-3 AT ROW 5 COL 42
     RECT-4 AT ROW 4.96 COL 1.57
     rtToolBar AT ROW 7.71 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.43 BY 8.33
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
         HEIGHT             = 8.25
         WIDTH              = 85.57
         MAX-HEIGHT         = 18
         MAX-WIDTH          = 90.86
         VIRTUAL-HEIGHT     = 18
         VIRTUAL-WIDTH      = 90.86
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
/* SETTINGS FOR FILL-IN fiTexto1 IN FRAME fpage0
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
    if return-value = "NOK":U then
        return no-apply.

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

/** Labels dos campos **/
{utp/ut-liter.i Ensaios * }
assign fiTexto1:screen-value in frame fPage0 = return-value.
{utp/ut-liter.i Tipo_Resultado * }
assign fiTexto2:screen-value in frame fPage0 = return-value.
{utp/ut-liter.i Estado_dos_Ensaios * }
assign fiTexto3:screen-value in frame fPage0 = return-value.
{utp/ut-liter.i Estado_das_Amostras * }
assign fiTexto4:screen-value in frame fPage0 = return-value.
{utp/ut-liter.i PadrÆo * }
assign tgPadrao:label in frame fPage0 = return-value.
{utp/ut-liter.i NÆo_PadrÆo * }
assign tgNPadrao:label in frame fPage0 = return-value.
{utp/ut-liter.i Data * }
assign tgData:label in frame fPage0 = return-value.   
{utp/ut-liter.i Texto * }
assign tgTexto:label in frame fPage0 = return-value.  
{utp/ut-liter.i Num‚rico * }
assign tgNumerico:label in frame fPage0 = return-value.
{utp/ut-liter.i Tabela * }
assign tgTabela:label in frame fPage0 = return-value. 
{utp/ut-liter.i Aprovado * }
assign tgAprovado:label in frame fPage0 = return-value.
{utp/ut-liter.i Reprovado * }
assign tgReprovado:label in frame fPage0 = return-value.
{utp/ut-liter.i Pendente * }
assign tgPendente:label in frame fPage0 = return-value.
{utp/ut-liter.i Aprovado_pelo_Usu rio * }
assign tgAprovUsuar:label in frame fPage0 = return-value.
{utp/ut-liter.i Aprovado * }
assign tgAmostAprovado:label in frame fPage0 = return-value.
{utp/ut-liter.i Reprovado * }
assign tgAmostReprovado:label in frame fPage0 = return-value.
{utp/ut-liter.i Pendente * }
assign tgAmostPendente:label in frame fPage0 = return-value.
{utp/ut-liter.i Aprovado_pelo_Usu rio * }
assign tgAmostAprovUsuar:label in frame fPage0 = return-value.


/** Busca Parƒmtros **/
find first ttSelecao no-lock no-error.
if avail ttSelecao then do:
    assign tgPadrao:checked          in frame fPage0    = ttSelecao.lPadrao          
           tgNPadrao:checked         in frame fPage0    = ttSelecao.lNPadrao         
           tgData:checked            in frame fPage0    = ttSelecao.lData            
           tgTexto:checked           in frame fPage0    = ttSelecao.lTexto           
           tgNumerico:checked        in frame fPage0    = ttSelecao.lNumerico        
           tgTabela:checked          in frame fPage0    = ttSelecao.lTabela          
           tgAprovado:checked        in frame fPage0    = ttSelecao.lAprovado        
           tgReprovado:checked       in frame fPage0    = ttSelecao.lReprovado       
           tgPendente:checked        in frame fPage0    = ttSelecao.lPendente        
           tgAprovUsuar:checked      in frame fPage0    = ttSelecao.lAprovUsuar      
           tgAmostAprovado:checked   in frame fPage0    = ttSelecao.lAmostAprovado   
           tgAmostReprovado:checked  in frame fPage0    = ttSelecao.lAmostReprovado  
           tgAmostPendente:checked   in frame fPage0    = ttSelecao.lAmostPendente   
           tgAmostAprovUsuar:checked in frame fPage0    = ttSelecao.lAmostAprovUsuar. 

end.                                                                

RETURN "OK":U.

END PROCEDURE.

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
    assign ttSelecao.lPadrao            = tgPadrao:checked           in frame fPage0      
           ttSelecao.lNPadrao           = tgNPadrao:checked          in frame fPage0      
           ttSelecao.lData              = tgData:checked             in frame fPage0  
           ttSelecao.lTexto             = tgTexto:checked            in frame fPage0
           ttSelecao.lNumerico          = tgNumerico:checked         in frame fPage0       
           ttSelecao.lTabela            = tgTabela:checked           in frame fPage0
           ttSelecao.lAprovado          = tgAprovado:checked         in frame fPage0
           ttSelecao.lReprovado         = tgReprovado:checked        in frame fPage0
           ttSelecao.lPendente          = tgPendente:checked         in frame fPage0
           ttSelecao.lAprovUsuar        = tgAprovUsuar:checked       in frame fPage0
           ttSelecao.lAmostAprovado     = tgAmostAprovado:checked    in frame fPage0
           ttSelecao.lAmostReprovado    = tgAmostReprovado:checked   in frame fPage0
           ttSelecao.lAmostPendente     = tgAmostPendente:checked    in frame fPage0
           ttSelecao.lAmostAprovUsuar   = tgAmostAprovUsuar:checked  in frame fPage0.


end.
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

