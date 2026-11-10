&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i IM7000C 2.00.00.001} /* 14/11/2025 16:15:34 */
{utp/ut-glob.i}   
{btb/btb008za.i0}

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-duimp-docto NO-UNDO LIKE duimp-docto
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-duimp-docto4 NO-UNDO LIKE duimp-docto
       field num-declaracao as char
       field cod-item-ini as char
       field cod-item-fim as char
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-duimp-siscomex NO-UNDO LIKE duimp-siscomex
       field r-Rowid as rowid.

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM7000C MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM7000C
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   c-pais-proced-docto v-num-declaracao v-item-ini v-item-fim
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER table for tt-duimp-siscomex.
DEFINE INPUT PARAMETER table for tt-duimp-docto4.
DEFINE INPUT PARAMETER pRowid as rowid NO-UNDO.
DEFINE INPUT PARAMETER pAction AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-bocx00489      AS HANDLE NO-UNDO.
DEFINE VARIABLE v-documento      LIKE duimp-docto.documento NO-UNDO.
DEFINE VARIABLE v-cod-tipo-docto LIKE duimp-docto.cod-tipo-docto NO-UNDO.
DEFINE VARIABLE v-seq-docto      LIKE duimp-docto.seq-docto NO-UNDO.
DEFINE VARIABLE l-erro           AS LOGICAL INIT NO NO-UNDO.

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

DEFINE VARIABLE c-pais-proced-docto AS CHARACTER FORMAT "X(20)":U 
     LABEL "Pa°s de Procedància" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-duimp-dts LIKE duimp-siscomex.cod-duimp-dts
     LABEL "N£mero Interno DUIMP" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-duimp-siscomex LIKE duimp-siscomex.cod-duimp-siscomex
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE v-item-fim AS CHARACTER FORMAT "X(7)":U 
     LABEL "a" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-item-ini AS CHARACTER FORMAT "x(7)":U 
     LABEL "Faixa de Itens" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-num-declaracao AS CHARACTER FORMAT "X(70)":U 
     LABEL "N£mero da Declaraá∆o" 
     VIEW-AS FILL-IN 
     SIZE 51.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-103
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71.57 BY 1.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71.57 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 8.46 COL 2
     btCancel AT ROW 8.46 COL 13
     btHelp2 AT ROW 8.46 COL 67.14
     rtToolBar AT ROW 8.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.29 BY 8.83
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     v-cod-duimp-dts AT ROW 1.71 COL 18 COLON-ALIGNED HELP
          "C¢digo da Declaraá∆o Ènica de Importaá∆o Datasul" WIDGET-ID 10
          LABEL "N£mero Interno DUIMP"
     v-cod-duimp-siscomex AT ROW 1.71 COL 52.86 COLON-ALIGNED HELP
          "C¢digo da Declaraá∆o Ènica de Importaá∆o Siscomex" WIDGET-ID 12
     c-pais-proced-docto AT ROW 3.75 COL 18 COLON-ALIGNED WIDGET-ID 16
     v-num-declaracao AT ROW 4.83 COL 18 COLON-ALIGNED WIDGET-ID 2
     v-item-ini AT ROW 5.83 COL 18 COLON-ALIGNED WIDGET-ID 4
     v-item-fim AT ROW 5.83 COL 38.14 COLON-ALIGNED WIDGET-ID 14
     RECT-3 AT ROW 3.5 COL 2 WIDGET-ID 6
     RECT-103 AT ROW 1.29 COL 2 WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.86 ROW 1.58
         SIZE 73.72 BY 6.42
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
         HEIGHT             = 8.83
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
    
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME c-pais-proced-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-pais-proced-docto wWindow
ON F5 OF c-pais-proced-docto IN FRAME fPage1 /* Pa°s de Procedància */
DO:
  {method/zoomfields.i 
      &ProgramZoom="unzoom/z11un006.w"
      &FieldZoom1="nome-pais"
      &FieldScreen1="c-pais-proced-docto"
      &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-pais-proced-docto wWindow
ON MOUSE-SELECT-DBLCLICK OF c-pais-proced-docto IN FRAME fPage1 /* Pa°s de Procedància */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}


IF c-pais-proced-docto:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage1 THEN.

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
  Purpose:     Inicializa informaá‰es em tela
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

    assign v-cod-duimp-dts      = 0
           v-cod-duimp-siscomex = ""
           v-num-declaracao     = ""
           v-item-ini           = ""
           v-item-fim           = "".

    for first tt-duimp-siscomex no-lock:
        assign v-cod-duimp-dts      = tt-duimp-siscomex.cod-duimp-dts
               v-cod-duimp-siscomex = tt-duimp-siscomex.cod-duimp-siscomex.
    end.
           
    IF  pAction = "Mod":U THEN DO:
        FOR FIRST tt-duimp-docto4 NO-LOCK
            WHERE tt-duimp-docto4.r-rowid = pRowid:
            ASSIGN v-num-declaracao = tt-duimp-docto4.num-declaracao
                   v-item-ini       = tt-duimp-docto4.cod-item-ini
                   v-item-fim       = tt-duimp-docto4.cod-item-fim.
        END.
    END.

    display v-cod-duimp-dts
            v-cod-duimp-siscomex
            v-num-declaracao
            v-item-ini
            v-item-fim
            with frame fPage1.

    disable v-cod-duimp-dts
            v-cod-duimp-siscomex
            with frame fPage1.
    
    APPLY "ENTRY":U TO v-num-declaracao IN FRAME fPage1.    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAddModDeclaracao wWindow 
PROCEDURE piAddModDeclaracao :
/*------------------------------------------------------------------------------
  Purpose: Cria a tabela tempor†ria com os regitros que ser∆o salvos    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-duimp-dts LIKE duimp-docto.cod-duimp-dts NO-UNDO.
    DEFINE INPUT PARAMETER p-documento LIKE duimp-docto.documento NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-tipo-docto LIKE duimp-docto.cod-tipo-docto NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-chave LIKE duimp-docto.cod-chave NO-UNDO.
    DEFINE INPUT PARAMETER p-seq-docto LIKE duimp-docto.seq-docto NO-UNDO.
    DEFINE INPUT PARAMETER p-valor LIKE duimp-docto.valor NO-UNDO. 
    DEFINE INPUT PARAMETER p-pais-proced-docto AS CHARACTER NO-UNDO.

    ASSIGN l-erro = NO.
    
    EMPTY TEMP-TABLE tt-duimp-docto.    
    
    CREATE tt-duimp-docto.
    ASSIGN tt-duimp-docto.cod-duimp-dts  = p-cod-duimp-dts
           tt-duimp-docto.documento      = p-documento
           tt-duimp-docto.cod-tipo-docto = p-cod-tipo-docto
           tt-duimp-docto.cod-chave      = p-cod-chave           
           tt-duimp-docto.seq-docto      = p-seq-docto
           tt-duimp-docto.valor          = p-valor
           OVERLAY(tt-duimp-docto.cod-livre-1,1,20) = p-pais-proced-docto.

    RUN emptyRowObject IN h-bocx00489.
    RUN goToKey        IN h-bocx00489 (INPUT tt-duimp-docto.cod-duimp-dts,   
                                       INPUT tt-duimp-docto.documento,
                                       INPUT tt-duimp-docto.seq-docto,
                                       INPUT tt-duimp-docto.cod-tipo-docto,
                                       INPUT tt-duimp-docto.cod-chave).
    RUN setRecord      IN h-bocx00489 (INPUT TABLE tt-duimp-docto).
    
    RUN emptyRowErrors IN h-bocx00489.
    IF  RETURN-VALUE = "OK":U THEN DO:    
        IF  pAction = "Add":U then
           RUN createRecord IN h-bocx00489.
       else
           RUN updateRecord IN h-bocx00489.
    END.
    RUN getRowErrors IN h-bocx00489(OUTPUT TABLE RowErrors).
    IF  CAN-FIND(FIRST RowErrors
                 WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        assign l-erro = YES.
        return no-apply.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSave wWindow 
PROCEDURE piSave :
/*------------------------------------------------------------------------------
  Purpose: Efetiva a criaá∆o/alteraá∆o do registro
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/    
    ASSIGN INPUT FRAME fPage1 v-num-declaracao
           INPUT FRAME fPage1 v-item-ini
           INPUT FRAME fPage1 v-item-fim
           INPUT FRAME fPage1 c-pais-proced-docto.

    IF  pAction = "Add":U THEN DO:
        ASSIGN v-documento      = 3  /* documento - Declaraá∆o Exportaá∆o Estrangeira (DDE, Dossiàs) */
               v-cod-tipo-docto = 1. /* cod-tipo-docto - Declaraá∆o */
               
        RUN piProximaSeq IN h-bocx00489 (INPUT v-cod-duimp-dts,
                                         INPUT v-documento,
                                         INPUT v-cod-tipo-docto,
                                         INPUT 1, /* cod-chave - Numero da Declaraá∆o */
                                         OUTPUT v-seq-docto).
    END.
    ELSE 
        ASSIGN v-documento      = tt-duimp-docto4.documento
               v-cod-tipo-docto = tt-duimp-docto4.cod-tipo-docto
               v-seq-docto      = tt-duimp-docto4.seq-docto
               c-pais-proced-docto = TRIM(SUBSTRING(tt-duimp-docto4.cod-livre-1,1,20)).

    RUN emptyRowErrors IN h-bocx00489.               

    blk-save:
    DO trans:
        /* N£mero da Declaraá∆o */
        run piAddModDeclaracao (input v-cod-duimp-dts,
                                input v-documento,
                                input v-cod-tipo-docto, 
                                input 1, /* cod-chave - Numero da Declaraá∆o */
                                input v-seq-docto,
                                input v-num-declaracao,
                                INPUT c-pais-proced-docto).
        IF  l-erro THEN DO:
            APPLY "entry" TO v-num-declaracao IN FRAME fPage1.
            UNDO blk-save, RETURN NO-APPLY.
        END.
                                
        /* Faixa Item Inicial */
        run piAddModDeclaracao (input v-cod-duimp-dts,
                                input v-documento,
                                input v-cod-tipo-docto,
                                input 2, /* cod-chave - Item Inicial */
                                input v-seq-docto,
                                input v-item-ini,
                                INPUT c-pais-proced-docto).
        IF  l-erro THEN DO:
            APPLY "entry" TO v-item-ini IN FRAME fPage1.
            UNDO blk-save, RETURN NO-APPLY.
        END.

        /* Faixa Item Final */
        run piAddModDeclaracao (input v-cod-duimp-dts,
                                input v-documento,
                                input v-cod-tipo-docto,
                                input 3, /* cod-chave - Item Final */
                                input v-seq-docto,
                                input v-item-fim,
                                INPUT c-pais-proced-docto).
        IF  l-erro THEN DO:
            APPLY "entry" TO v-item-fim IN FRAME fPage1.
            UNDO blk-save, RETURN NO-APPLY.
        END.
    end.
    
    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

