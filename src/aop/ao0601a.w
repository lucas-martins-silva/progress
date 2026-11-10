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
{include/i-prgvrs.i AO0601A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0601a MAO}
&ENDIF



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AO0601A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType    Detail

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 tgPadrao tgNPadrao tgData tgTexto ~
                              tgNumerico tgTabela tgAprovado tgReprovado tgPendente tgAprovUsuar ~
                              fi-ensaio-ini fi-ensaio-fim fi-data-ini fi-data-fim 



def temp-table ttSelecao no-undo
     field c-ensaio-ini     as char initial "":U
     field c-ensaio-fim     as char initial "ZZZZZZZZ":U
     field d-data-ini       as date initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF 
     field d-data-fim       as date initial 12/31/9999
     field i-lubrific-ini   as int  initial 0
     field i-lubrific-fim   as int  initial 999999999
     field c-evento-ini     as char initial "":U
     field c-evento-fim     as char initial "ZZZZZZZZ":U
     field c-item-ini       as char initial "":U
     field c-item-fim       as char initial "ZZZZZZZZZZZZZZZ":U
     field lPadrao          as logical initial yes
     field lNPadrao         as logical initial yes
     field lData            as logical initial yes
     field lTexto           as logical initial yes
     field lNumerico        as logical initial yes 
     field lTabela          as logical initial yes 
     field lAprovado        as logical initial yes 
     field lReprovado       as logical initial yes 
     field lPendente        as logical initial yes 
     field lAprovUsuar      as logical initial yes. 






/* Parameters Definitions ---                                           */
define input-output parameter table for ttSelecao.
define input-output param pOK as logical no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-ensaio-ini fi-ensaio-fim fi-data-ini ~
fi-data-fim tgPadrao tgNPadrao tgPendente tgAprovUsuar tgAprovado ~
tgReprovado tgNumerico tgTabela tgTexto tgData btOK btCancel btHelp2 ~
fiTexto1 fiTexto3 fiTexto2 IMAGE-21 IMAGE-22 IMAGE-23 IMAGE-24 RECT-1 ~
RECT-2 RECT-31 RECT-4 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS fi-ensaio-ini fi-ensaio-fim fi-data-ini ~
fi-data-fim tgPadrao tgNPadrao tgPendente tgAprovUsuar tgAprovado ~
tgReprovado tgNumerico tgTabela tgTexto tgData fiTexto1 fiTexto3 fiTexto2 

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

DEFINE VARIABLE fi-data-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-data-ini AS DATE FORMAT "99/99/9999" INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data":R17 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-ensaio-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-ensaio-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Ensaio":R8 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiTexto1 AS CHARACTER FORMAT "X(256)":U INITIAL "Ensaios" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto2 AS CHARACTER FORMAT "X(256)":U INITIAL "Tipo Resultado" 
      VIEW-AS TEXT 
     SIZE 13 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto3 AS CHARACTER FORMAT "X(256)":U INITIAL "Estado dos Ensaios" 
      VIEW-AS TEXT 
     SIZE 15 BY .67 NO-UNDO.

DEFINE IMAGE IMAGE-21
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68 BY 2.04.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68 BY 2.13.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68 BY 2.75.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68 BY 1.83.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 68 BY 1.42
     BGCOLOR 7 .

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
     fi-ensaio-ini AT ROW 1.5 COL 9 COLON-ALIGNED HELP
          "C¢digo do ensaio"
     fi-ensaio-fim AT ROW 1.5 COL 29 COLON-ALIGNED HELP
          "C¢digo do ensaio" NO-LABEL
     fi-data-ini AT ROW 2.5 COL 9 COLON-ALIGNED HELP
          "Data do movimento"
     fi-data-fim AT ROW 2.5 COL 29 COLON-ALIGNED HELP
          "Data do movimento" NO-LABEL
     tgPadrao AT ROW 4.75 COL 4.29
     tgNPadrao AT ROW 4.75 COL 19.29
     tgPendente AT ROW 7 COL 4.29
     tgAprovUsuar AT ROW 7 COL 19.29
     tgAprovado AT ROW 7.08 COL 41
     tgReprovado AT ROW 7.08 COL 57
     tgNumerico AT ROW 9.5 COL 4.29
     tgTabela AT ROW 9.5 COL 19.29
     tgTexto AT ROW 9.5 COL 41
     tgData AT ROW 9.5 COL 57
     btOK AT ROW 11.33 COL 2
     btCancel AT ROW 11.33 COL 13
     btHelp2 AT ROW 11.38 COL 57.43
     fiTexto1 AT ROW 3.79 COL 2.29 NO-LABEL
     fiTexto3 AT ROW 6.21 COL 2 NO-LABEL
     fiTexto2 AT ROW 8.46 COL 2.86 NO-LABEL
     IMAGE-21 AT ROW 2.5 COL 28
     IMAGE-22 AT ROW 2.5 COL 22
     IMAGE-23 AT ROW 1.5 COL 28
     IMAGE-24 AT ROW 1.5 COL 22
     RECT-1 AT ROW 3.92 COL 1
     RECT-2 AT ROW 8.88 COL 1
     RECT-31 AT ROW 1 COL 1
     RECT-4 AT ROW 6.5 COL 1
     rtToolBar AT ROW 11.13 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 68.72 BY 11.83
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
         TITLE              = "Sele‡Æo"
         HEIGHT             = 11.63
         WIDTH              = 69.29
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
/* SETTINGS FOR FILL-IN fiTexto2 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiTexto3 IN FRAME fpage0
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
ON END-ERROR OF wWindow /* Sele‡Æo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Sele‡Æo */
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

    assign pOK = no. 
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
    assign pOK = yes. 
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
assign fi-ensaio-ini:label in frame fPage0 = return-value.
{utp/ut-liter.i Data * }
assign fi-data-ini:label in frame fPage0 = return-value.
{utp/ut-liter.i Tipo_Resultado * }
assign fiTexto2:screen-value in frame fPage0 = return-value.
{utp/ut-liter.i Estado_dos_Ensaios * }
assign fiTexto3:screen-value in frame fPage0 = return-value.
{utp/ut-liter.i PadrÆo *}
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
{utp/ut-liter.i Ensaios * }
assign fiTexto1:screen-value in frame fPage0 = return-value.

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
           fi-ensaio-ini:screen-value in frame fPage0   = ttSelecao.c-ensaio-ini
           fi-ensaio-fim:screen-value in frame fPage0   = ttSelecao.c-ensaio-fim
           fi-data-ini:screen-value   in frame fPage0   = string(ttSelecao.d-data-ini)  
           fi-data-fim:screen-value   in frame fPage0   = string(ttSelecao.d-data-fim)
           tgAprovUsuar:checked       in frame fPage0   = ttSelecao.lAprovUsuar.




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
           ttSelecao.lAprovUsuar        = tgAprovUsuar:checked         in frame fPage0
           ttSelecao.c-ensaio-ini       = fi-ensaio-ini:screen-value in frame fPage0 
           ttSelecao.c-ensaio-fim       = fi-ensaio-fim:screen-value in frame fPage0 
           ttSelecao.d-data-ini         = date(fi-data-ini:screen-value   in frame fPage0) 
           ttSelecao.d-data-fim         = date(fi-data-fim:screen-value   in frame fPage0). 



end.
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

