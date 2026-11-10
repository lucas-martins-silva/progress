&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
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
{include/i-prgvrs.i IM7000B 2.00.00.000}
{utp/ut-glob.i}   
{btb/btb008za.i0}

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-duimp-docto NO-UNDO LIKE duimp-docto
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-duimp-docto-aux NO-UNDO LIKE duimp-docto
       field r-Rowid as rowid.       
DEFINE TEMP-TABLE tt-duimp-siscomex NO-UNDO LIKE duimp-siscomex
       field r-Rowid as rowid.

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM7000B MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM7000B
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   v-processo
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER table for tt-duimp-siscomex.
DEFINE INPUT PARAMETER table for tt-duimp-docto.
DEFINE INPUT PARAMETER pRowid as rowid NO-UNDO.
DEFINE INPUT PARAMETER pAction AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-bocx00489 AS HANDLE NO-UNDO.
DEFINE VARIABLE v-seq-docto LIKE duimp-docto.seq-docto NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

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

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE v-cod-duimp-dts LIKE duimp-siscomex.cod-duimp-dts
     LABEL "N£mero Interno DUIMP" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-duimp-siscomex LIKE duimp-siscomex.cod-duimp-siscomex
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE v-processo AS CHARACTER FORMAT "X(17)":U INITIAL "0" 
     LABEL "Processo/Dossiˆ" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE v-tipo-processo AS CHARACTER FORMAT "X(60)":U 
     LABEL "Tipo Processo/Dossiˆ" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-103
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71.57 BY 1.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71.57 BY 2.79.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 7.88 COL 2
     btCancel AT ROW 7.88 COL 13
     btHelp2 AT ROW 7.88 COL 67.14
     rtToolBar AT ROW 7.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.29 BY 8.13
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     v-cod-duimp-dts AT ROW 1.71 COL 18 COLON-ALIGNED HELP
          "C¢digo da Declara‡Æo énica de Importa‡Æo Datasul" WIDGET-ID 10
          LABEL "N£mero Interno DUIMP"
     v-cod-duimp-siscomex AT ROW 1.71 COL 52.86 COLON-ALIGNED HELP
          "C¢digo da Declara‡Æo énica de Importa‡Æo Siscomex" WIDGET-ID 12
     v-tipo-processo AT ROW 3.79 COL 18 COLON-ALIGNED WIDGET-ID 2
     v-processo AT ROW 4.79 COL 18 COLON-ALIGNED WIDGET-ID 4
     RECT-3 AT ROW 3.33 COL 2 WIDGET-ID 6
     RECT-103 AT ROW 1.29 COL 2 WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.86 ROW 1.58
         SIZE 73.72 BY 5.45
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
         HEIGHT             = 8.13
         WIDTH              = 77.29
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN v-cod-duimp-dts IN FRAME fPage1
   LIKE = mgcex.duimp-siscomex.cod-duimp-dts EXP-LABEL EXP-SIZE         */
/* SETTINGS FOR FILL-IN v-cod-duimp-siscomex IN FRAME fPage1
   LIKE = mgcex.duimp-siscomex.cod-duimp-siscomex EXP-SIZE              */
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
     _Options          = "SHARE-LOCK KEEP-EMPTY"
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
    run piSave in this-procedure.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     Elimina os handles instanciados no programa
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-bocx00489) THEN DO:
        DELETE PROCEDURE h-bocx00489.
        ASSIGN h-bocx00489 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterinitializeinterface wWindow 
PROCEDURE afterinitializeinterface :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa informa‡äes em tela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT VALID-HANDLE(h-bocx00489) OR
       h-bocx00489:TYPE <> "PROCEDURE":U OR
       h-bocx00489:FILE-NAME <> "cxbo/bocx00489.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00489.p YES}
        {btb/btb008za.i2 cxbo/bocx00489.p '' h-bocx00489}
    END. 
    RUN openQueryStatic IN h-bocx00489 (INPUT "Main":U) NO-ERROR.

    RUN displayFields IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields wWindow 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     Apresenta os valores dos registros em tela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN v-cod-duimp-dts       = 0
           v-cod-duimp-siscomex  = ""
           v-tipo-processo       = ""
           v-processo            = "".

    FOR FIRST tt-duimp-siscomex NO-LOCK:
        ASSIGN v-cod-duimp-dts       = tt-duimp-siscomex.cod-duimp-dts
               v-cod-duimp-siscomex  = tt-duimp-siscomex.cod-duimp-siscomex.
    END.

    {utp/ut-liter.i "Administrativo"}
    ASSIGN v-tipo-processo = "1 - ":U + RETURN-VALUE.

    EMPTY TEMP-TABLE tt-duimp-docto-aux.
    
    IF  pAction = "Mod":U THEN DO:        
        FOR FIRST tt-duimp-docto NO-LOCK
            WHERE tt-duimp-docto.r-rowid = pRowid:
            ASSIGN v-processo = tt-duimp-docto.valor.
            
            CREATE tt-duimp-docto-aux.
            BUFFER-COPY tt-duimp-docto TO tt-duimp-docto-aux.
        END.
    END.

    DISPLAY v-cod-duimp-dts
            v-cod-duimp-siscomex
            v-tipo-processo
            v-processo
            WITH FRAME fPage1.

    DISABLE v-cod-duimp-dts
            v-cod-duimp-siscomex
            v-tipo-processo
            WITH FRAME fPage1.

    APPLY "ENTRY":U TO v-processo IN FRAME fPage1.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSave wWindow 
PROCEDURE piSave :
/*------------------------------------------------------------------------------
  Purpose:     Procedure responsavel por salvar os registros do AC Drawback
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN INPUT FRAME fPage1 v-processo.
    
    IF  pAction = "Add":U THEN DO:
        RUN piProximaSeq IN h-bocx00489 (input v-cod-duimp-dts,
                                         input 2, /* documento */
                                         input 1, /* cod-tipo-docto */
                                         input 1, /* cod-chave */
                                         output v-seq-docto).

        CREATE tt-duimp-docto-aux.
        ASSIGN tt-duimp-docto-aux.cod-duimp-dts  = v-cod-duimp-dts
               tt-duimp-docto-aux.documento      = 2 /* Processo */
               tt-duimp-docto-aux.seq-docto      = v-seq-docto
               tt-duimp-docto-aux.cod-tipo-docto = 1 /* Administrativo */
               tt-duimp-docto-aux.cod-chave      = 1. /* N£mero Processo/Dossiˆ */
    END.
    ELSE DO:
        FIND FIRST tt-duimp-docto-aux EXCLUSIVE-LOCK NO-ERROR.    
    END.

    ASSIGN tt-duimp-docto-aux.valor = string(v-processo).

    RUN emptyRowErrors IN h-bocx00489.
    RUN emptyRowObject IN h-bocx00489.
    RUN goToKey        IN h-bocx00489 (INPUT tt-duimp-docto-aux.cod-duimp-dts,   
                                       INPUT tt-duimp-docto-aux.documento,
                                       INPUT tt-duimp-docto-aux.seq-docto,
                                       INPUT tt-duimp-docto-aux.cod-tipo-docto,
                                       INPUT tt-duimp-docto-aux.cod-chave).

    IF  pAction = "Add":U THEN DO:
        RUN setRecord    IN h-bocx00489 (INPUT TABLE tt-duimp-docto-aux).
        RUN createRecord IN h-bocx00489.
    END.
    ELSE DO:
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN setRecord    IN h-bocx00489 (INPUT TABLE tt-duimp-docto-aux).
            RUN updateRecord IN h-bocx00489.
        END.
    END.
    IF  RETURN-VALUE = "OK":U THEN DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
    ELSE DO:
        RUN getRowErrors IN h-bocx00489(OUTPUT TABLE RowErrors).
        IF  CAN-FIND(FIRST RowErrors
                     WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
        END.
        RETURN NO-APPLY.
    END.

    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

