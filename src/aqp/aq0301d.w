&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-carg-rural NO-UNDO LIKE carg-rural
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-pesagem NO-UNDO LIKE pesagem
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-pesagem-aux NO-UNDO LIKE pesagem
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0301D 2.00.00.011 } /*** 010011 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aq0301d MAQ }
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        aq0301d
&GLOBAL-DEFINE Version        2.00.00.011

&GLOBAL-DEFINE WindowType     

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Master/Detail

&GLOBAL-DEFINE page0Widgets  btOK btCancel brPesagens bt-sav bt-can fi-peso
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions --- */
DEFINE INPUT PARAMETER p-num-carg AS INTEGER NO-UNDO.

/* Local Handles Definitions ---  */
DEFINE VARIABLE h-boin00981          AS HANDLE      NO-UNDO. /* pesagem */
DEFINE VARIABLE h-boin00961          AS HANDLE      NO-UNDO. /* carg-rural */
DEFINE VARIABLE h-boin00982          AS HANDLE      NO-UNDO. /* liber-carg */
DEFINE VARIABLE h-boin172na          AS HANDLE      NO-UNDO. /* item       */


/* Local Variable Definitions ---   */
DEFINE VARIABLE iLinha               AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-update             AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-fraciona           AS LOGICAL     NO-UNDO.
DEFINE VARIABLE d-val-peso-balan-old AS DECIMAL     NO-UNDO.

/* Local temp-table Definitions ---  */
DEFINE TEMP-TABLE tt-pesagem-desc NO-UNDO 
    LIKE pesagem
    FIELD iSeq AS INTEGER.

/* Local Buffers Definitions --- */
DEFINE BUFFER bf-tt-pesagem      FOR tt-pesagem.
DEFINE BUFFER bf-tt-pesagem-desc FOR tt-pesagem-desc.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brPesagens

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-pesagem

/* Definitions for BROWSE brPesagens                                    */
&Scoped-define FIELDS-IN-QUERY-brPesagens ~
fnSituacao(input tt-pesagem.num-carg, input tt-pesagem.cdn-pesagem) ~
tt-pesagem.cdn-pesagem tt-pesagem.val-peso-balan tt-pesagem.val-peso-aferid ~
tt-pesagem.val-quant 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPesagens 
&Scoped-define QUERY-STRING-brPesagens FOR EACH tt-pesagem NO-LOCK
&Scoped-define OPEN-QUERY-brPesagens OPEN QUERY brPesagens FOR EACH tt-pesagem NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brPesagens tt-pesagem
&Scoped-define FIRST-TABLE-IN-QUERY-brPesagens tt-pesagem


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brPesagens}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 RECT-2 brPesagens fi-peso ~
bt-can bt-sav btOK btCancel 
&Scoped-Define DISPLAYED-OBJECTS fi-peso 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSituacao wWindow 
FUNCTION fnSituacao RETURNS CHARACTER
  ( pi-num-carg AS INT, INPUT pi-cdn-pesagem AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-can 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "Ca&n" 
     SIZE 4 BY 1.25 TOOLTIP "Cancelar".

DEFINE BUTTON bt-sav 
     IMAGE-UP FILE "image/im-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sav.bmp":U
     LABEL "&Sav" 
     SIZE 4 BY 1.25 TOOLTIP "Salvar".

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-peso AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Peso" 
     VIEW-AS FILL-IN 
     SIZE 15.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55.57 BY 6.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 22 BY 6.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 81 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brPesagens FOR 
      tt-pesagem SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brPesagens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPesagens wWindow _STRUCTURED
  QUERY brPesagens NO-LOCK DISPLAY
      fnSituacao(input tt-pesagem.num-carg, input tt-pesagem.cdn-pesagem) COLUMN-LABEL "Situa‡Æo" FORMAT "x(10)":U
            WIDTH 10
      tt-pesagem.cdn-pesagem COLUMN-LABEL "Seq" WIDTH 4 FORMAT ">>>,>>9":U
      tt-pesagem.val-peso-balan COLUMN-LABEL "Pesagem" WIDTH 11  FORMAT ">>>>,>>>,>>9.9999":U
      tt-pesagem.val-peso-aferid COLUMN-LABEL "Peso" WIDTH 11 FORMAT ">>>>,>>>,>>9.9999":U
      tt-pesagem.val-quant COLUMN-LABEL "Quantidade" WIDTH 11 FORMAT ">>>>,>>>,>>9.9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-AUTO-VALIDATE NO-ROW-MARKERS SEPARATORS SIZE 52.57 BY 5.75
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     brPesagens AT ROW 1.75 COL 3.57 WIDGET-ID 200
     fi-peso AT ROW 1.92 COL 63 COLON-ALIGNED
     bt-can AT ROW 2.92 COL 72.14 WIDGET-ID 90
     bt-sav AT ROW 2.92 COL 76.14 WIDGET-ID 30
     btOK AT ROW 8.17 COL 2
     btCancel AT ROW 8.17 COL 13
     "Aferi‡Æo" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.08 COL 4.86 WIDGET-ID 86
     rtToolBar AT ROW 7.92 COL 1
     RECT-1 AT ROW 1.25 COL 2.14 WIDGET-ID 84
     RECT-2 AT ROW 1.25 COL 59 WIDGET-ID 88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.29 BY 17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-carg-rural T "?" NO-UNDO movind carg-rural
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-pesagem T "?" NO-UNDO movind pesagem
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-pesagem-aux T "?" NO-UNDO movind pesagem
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 8.33
         WIDTH              = 81.43
         MAX-HEIGHT         = 38.63
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.63
         VIRTUAL-WIDTH      = 182.86
         MIN-BUTTON         = no
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
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
/* BROWSE-TAB brPesagens RECT-2 fpage0 */
ASSIGN 
       brPesagens:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPesagens
/* Query rebuild information for BROWSE brPesagens
     _TblList          = "Temp-Tables.tt-pesagem"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > "_<CALC>"
"fnSituacao(input tt-pesagem.num-carg, input tt-pesagem.cdn-pesagem)" "Situa‡Æo" "x(10)" ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-pesagem.cdn-pesagem
"cdn-pesagem" "Seq" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-pesagem.val-peso-balan
"val-peso-balan" "Pesagem" ? "decimal" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-pesagem.val-peso-aferid
"val-peso-aferid" "Peso" ? "decimal" ? ? ? ? ? ? no ? no no "12.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-pesagem.val-quant
"val-quant" "Quantidade" ? "decimal" ? ? ? ? ? ? no ? no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brPesagens */
&ANALYZE-RESUME

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


&Scoped-define BROWSE-NAME brPesagens
&Scoped-define SELF-NAME brPesagens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPesagens wWindow
ON VALUE-CHANGED OF brPesagens IN FRAME fpage0
DO:
   GET CURRENT brPesagens NO-LOCK.
   ASSIGN fi-peso = tt-pesagem.val-peso-balan
          d-val-peso-balan-old = tt-pesagem.val-peso-balan.

   DISPLAY fi-peso WITH FRAME fPage0.
   APPLY "ENTRY":U TO fi-peso IN FRAME fpage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-can
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-can wWindow
ON CHOOSE OF bt-can IN FRAME fpage0 /* Can */
DO:

    IF NOT l-update THEN DO:
        EMPTY TEMP-TABLE tt-pesagem NO-ERROR.
        ASSIGN d-val-peso-balan-old                 = 0
               fi-peso:SCREEN-VALUE IN FRAME fPage0 = '0'.
        {&OPEN-QUERY-brPesagens}
    END.
    ELSE DO:
        APPLY 'VALUE-CHANGED' TO brPesagens.
        IF d-val-peso-balan-old <> tt-pesagem.val-peso-balan THEN DO:
            ASSIGN fi-peso:SCREEN-VALUE IN FRAME fPage0 = STRING(d-val-peso-balan-old).
            APPLY 'CHOOSE':U TO bt-sav  IN FRAME fPage0.
        END.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sav
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sav wWindow
ON CHOOSE OF bt-sav IN FRAME fpage0 /* Sav */
DO:
    DEFINE VARIABLE iLinha        AS INTEGER   NO-UNDO.
    DEFINE VARIABLE p-cdn-pesagem AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-msg         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE d-peso-aux AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE i-seq-pesagem AS DECIMAL   NO-UNDO.
    
    IF NOT l-update THEN DO:

        RUN getCreateSequence IN h-boin00981 (INPUT p-num-carg, OUTPUT p-cdn-pesagem).

        CREATE tt-pesagem.
        ASSIGN tt-pesagem.num-carg       = p-num-carg
               tt-pesagem.cdn-pesagem    = p-cdn-pesagem
               tt-pesagem.val-peso-balan = INPUT FRAME fPage0 fi-peso.

        {&OPEN-QUERY-brPesagens}

    END.
    ELSE DO:
        IF AVAIL tt-pesagem THEN DO:
            GET CURRENT brPesagens NO-LOCK.
            ASSIGN iLinha = brPesagens:FOCUSED-ROW IN FRAME fPage0.
            
            IF iLinha = 1 THEN DO:                
                FOR EACH bf-tt-pesagem 
                   WHERE bf-tt-pesagem.val-peso-balan > 0 
                     AND bf-tt-pesagem.cdn-pesagem > 1:                    
                    IF bf-tt-pesagem.val-peso-balan > d-peso-aux THEN DO:
                        ASSIGN d-peso-aux    = bf-tt-pesagem.val-peso-balan
                               i-seq-pesagem = bf-tt-pesagem.cdn-pesagem.
                    END.
                END.
            
                FOR EACH bf-tt-pesagem 
                    WHERE bf-tt-pesagem.cdn-pesagem > 1 
                      AND bf-tt-pesagem.val-peso-balan > 0 :
                      
                    IF INPUT FRAME fPage0 fi-peso < d-peso-aux THEN DO:                
                           RUN utp/ut-msgs.p(INPUT 'show':u, /* Valor inválido para primeira pesagem! */
                                             INPUT 54741,    /* que a primeira pesagem*/
                                             INPUT STRING(i-seq-pesagem)).                       
                        RETURN NO-APPLY.
                    END.
                END.
            END.
            
            ASSIGN tt-pesagem.val-peso-balan = INPUT FRAME fPage0 fi-peso.

            FIND FIRST bf-tt-pesagem NO-ERROR.
            IF AVAIL bf-tt-pesagem THEN DO:
                IF  INPUT FRAME fPage0 fi-peso > bf-tt-pesagem.val-peso-balan 
                AND NUM-RESULTS('brPesagens')  > 1
                AND bf-tt-pesagem.r-rowid <> tt-pesagem.r-rowid THEN DO:
                    {utp/ut-liter.i Valor_informado * }
                    ASSIGN c-msg = RETURN-VALUE.
                    {utp/ut-liter.i a_primeira_pesagem * }

                    RUN utp/ut-msgs.p(INPUT 'show':u, /* Valor informado nao pode ser maior */
                                      INPUT 26175,    /* que a primeira pesagem*/
                                      INPUT c-msg + "~~" + RETURN-VALUE).
                    
                    RETURN NO-APPLY.
                END.
                ELSE DO:
          
                   RUN pi-recalcular-valores IN THIS-PROCEDURE.
          
                   IF RETURN-VALUE = 'NOK' THEN
                       RUN openQueriesPesagens IN THIS-PROCEDURE.
                   ELSE DO:
                       {&OPEN-QUERY-brPesagens}        
                   END.
          
                   RUN pi-posicionar IN THIS-PROCEDURE. 
          
                END.
            END.
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN 'NOK':U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    RUN pi-save IN THIS-PROCEDURE.    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN 'OK':U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-peso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-peso wWindow
ON RETURN OF fi-peso IN FRAME fpage0 /* Peso */
DO:
  APPLY 'CHOOSE':U TO bt-sav IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boin00981) THEN
       RUN destroy IN  h-boin00981.

    IF VALID-HANDLE(h-boin00961) THEN
       RUN destroy IN h-boin00961.

    IF VALID-HANDLE(h-boin00982) THEN
        RUN destroy IN  h-boin00982.
        
    IF VALID-HANDLE(h-boin172na) THEN
        RUN destroy IN h-boin172na.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN initializeDBOs IN THIS-PROCEDURE.

    RUN goToKey IN h-boin00961(INPUT p-num-carg).
    IF RETURN-VALUE = 'OK':U THEN DO:
        EMPTY TEMP-TABLE tt-carg-rural.
        RUN getRecord IN h-boin00961(OUTPUT TABLE tt-carg-rural).
        FIND FIRST tt-carg-rural NO-ERROR.                       
    END.

    RUN openQueriesPesagens IN THIS-PROCEDURE.

    ASSIGN l-update = CAN-FIND(FIRST tt-pesagem).
    
    IF l-update THEN 
       APPLY 'VALUE-CHANGED' TO brPesagens IN FRAME fPage0.
       
    IF tt-carg-rural.cdn-sit > 3 THEN DO: /* I01IN010961.I */
        ASSIGN bt-sav:SENSITIVE  IN FRAME fPage0 = NO
               bt-can:SENSITIVE  IN FRAME fPage0 = NO
               btOK:SENSITIVE    IN FRAME fPage0 = NO
               fi-peso:SENSITIVE IN FRAME fPage0 = NO.
    END.

    IF VALID-HANDLE(h-boin172na) AND AVAIL tt-carg-rural THEN DO:
        RUN goToKey IN h-boin172na(INPUT tt-carg-rural.it-codigo).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getlogField IN h-boin172na(INPUT 'fraciona':U, OUTPUT l-fraciona).
        END.
    END.     
    
    RUN pi-posicionar IN THIS-PROCEDURE.  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-boin00981) THEN
        RUN inbo/boin00981.p PERSISTENT SET h-boin00981.


    IF NOT VALID-HANDLE(h-boin00961) THEN
        RUN inbo/boin00961.p PERSISTENT SET h-boin00961.

    RUN openQueryStatic IN h-boin00961(INPUT 'Main').

    IF NOT VALID-HANDLE(h-boin00982) THEN
        RUN inbo/boin00982.p PERSISTENT SET h-boin00982.

    RUN openQueryStatic IN h-boin00982(INPUT 'Main').

     IF NOT VALID-HANDLE(h-boin172na) THEN
        RUN inbo/boin172na.p PERSISTENT SET h-boin172na.
        
    RUN openQueryStatic IN h-boin172na(INPUT 'Main').

     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesPesagens wWindow 
PROCEDURE openQueriesPesagens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iRowsReturned AS INTEGER NO-UNDO.

    IF VALID-HANDLE(h-boin00981) THEN DO:
        RUN setConstraintNumCarg IN h-boin00981 (INPUT p-num-carg, 
                                                 INPUT p-num-carg).  

        RUN openQueryStatic IN h-boin00981 (INPUT "NumCarg":U).
        
        RUN getBatchRecords IN h-boin00981 (INPUT ?,
                                            INPUT NO,
                                            INPUT 9999,
                                            OUTPUT iRowsReturned,
                                            OUTPUT TABLE tt-pesagem).


        IF CAN-FIND(FIRST tt-pesagem) THEN DO:
           {&OPEN-QUERY-brPesagens}           
            APPLY "VALUE-CHANGED":U TO BROWSE brPesagens. 
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posicionar wWindow 
PROCEDURE pi-posicionar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF CAN-FIND(FIRST bf-tt-pesagem) THEN DO:    
        FOR FIRST bf-tt-pesagem 
            WHERE bf-tt-pesagem.val-peso-balan = 0: END.

        IF AVAIL bf-tt-pesagem THEN
            REPOSITION brPesagens TO ROW (bf-tt-pesagem.cdn-pesagem) NO-ERROR. 
        ELSE 
            REPOSITION brPesagens TO ROW (1) NO-ERROR.     
            
        APPLY "VALUE-CHANGED":U TO BROWSE brPesagens.
        APPLY 'ENTRY':U TO fi-peso IN FRAME fPage0.    
    END.  
    
    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recalcular-valores wWindow 
PROCEDURE pi-recalcular-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cdn-pesagem     AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-cdn-pesagem-alt AS INTEGER NO-UNDO.
    DEFINE VARIABLE d-val-peso-aferid AS DECIMAL NO-UNDO.   
    DEFINE VARIABLE iSeq              AS INTEGER NO-UNDO.

    ASSIGN i-cdn-pesagem-alt = tt-pesagem.cdn-pesagem.

    {&OPEN-QUERY-brPesagens}
    
    ASSIGN iSeq = 0.
    EMPTY TEMP-TABLE tt-pesagem-desc NO-ERROR.
    FOR EACH bf-tt-pesagem BY bf-tt-pesagem.val-peso-balan DESC :
        ASSIGN iSeq = iSeq + 1.
        CREATE tt-pesagem-desc.
        BUFFER-COPY bf-tt-pesagem TO tt-pesagem-desc.
        ASSIGN tt-pesagem-desc.iSeq = iSeq.
    END.

    FOR EACH tt-pesagem-desc:
        FIND FIRST bf-tt-pesagem-desc 
             WHERE bf-tt-pesagem-desc.iSeq = tt-pesagem-desc.iSeq + 1 NO-ERROR.
        IF AVAIL bf-tt-pesagem-desc THEN DO:
            FOR FIRST bf-tt-pesagem 
                WHERE bf-tt-pesagem.cdn-pesagem = bf-tt-pesagem-desc.cdn-pesagem:                 
                 ASSIGN bf-tt-pesagem.val-peso-aferid = tt-pesagem-desc.val-peso-balan - bf-tt-pesagem-desc.val-peso-balan .

                IF tt-carg-rural.val-densidade > 0 THEN DO:
                    IF l-fraciona THEN
                        ASSIGN bf-tt-pesagem.val-quant = bf-tt-pesagem.val-peso-aferid / tt-carg-rural.val-densidade. 
                    ELSE
                        ASSIGN  bf-tt-pesagem.val-quant = ROUND(bf-tt-pesagem.val-peso-aferid / tt-carg-rural.val-densidade,0).
                END.
            END.
        END.
    END.

    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-save wWindow 
PROCEDURE pi-save :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE d-val-peso-aferid AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-val-quant       AS DECIMAL     NO-UNDO.   

    
    IF NOT l-update THEN DO:
        IF AVAIL tt-pesagem THEN DO:
            EMPTY TEMP-TABLE tt-pesagem-aux NO-ERROR.
            CREATE tt-pesagem-aux.
            BUFFER-COPY tt-pesagem TO tt-pesagem-aux.
        
            IF VALID-HANDLE(h-boin00981) THEN DO:
                RUN openQueryStatic IN h-boin00981(INPUT 'Main').
                RUN setRecord       IN h-boin00981 (INPUT TABLE tt-pesagem-aux).
                RUN emptyRowErrors  IN h-boin00981.
                RUN createRecord    IN h-boin00981. 

                RUN getRowErrors IN h-boin00981(OUTPUT TABLE RowErrors).

                IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
                    /* Atualiza valores carg-rural */
                    RUN updateAfericao IN h-boin00961 (INPUT p-num-carg).

                    RUN createLiberCarg IN h-boin00982 (INPUT p-num-carg,
                                                        INPUT tt-carg-rural.qti-comptmento).

                    RUN getRowErrors IN h-boin00982(OUTPUT TABLE RowErrors).
                END.
            END.    
        END.
    END.
    ELSE DO:
        IF VALID-HANDLE(h-boin00981) THEN DO:
            RUN openQueryStatic IN h-boin00981 (INPUT 'Main':U).

            FOR EACH tt-pesagem:
                 
                 RUN goToKey IN h-boin00981 (INPUT tt-pesagem.num-carg, INPUT tt-pesagem.cdn-pesagem).

                 EMPTY TEMP-TABLE tt-pesagem-aux NO-ERROR.

                 RUN getRecord IN h-boin00981 (OUTPUT TABLE tt-pesagem-aux).

                 FIND FIRST tt-pesagem-aux NO-ERROR.
                 ASSIGN tt-pesagem-aux.val-peso-aferid = tt-pesagem.val-peso-aferid
                        tt-pesagem-aux.val-peso-balan  = tt-pesagem.val-peso-balan 
                        tt-pesagem-aux.val-quant       = tt-pesagem.val-quant.  

                 RUN setRecord IN h-boin00981 (INPUT TABLE tt-pesagem-aux).
                 RUN updateRecord IN h-boin00981.

                 RUN getRowErrors IN h-boin00981(OUTPUT TABLE RowErrors).
                 IF CAN-FIND(FIRST RowErrors) THEN
                     LEAVE.
                 ELSE DO:
                     RUN updateLiberCarg IN h-boin00982(INPUT tt-pesagem.num-carg,
                                                        INPUT tt-pesagem.cdn-pesagem,
                                                        INPUT tt-pesagem.val-peso-aferid,
                                                        INPUT tt-pesagem.val-quant).
                 END.
            END.
        END.
        
        IF VALID-HANDLE(h-boin00961) THEN /* Atualiza valores carg-rural */
            RUN updateAfericao IN h-boin00961 (INPUT p-num-carg).

    END.

    IF CAN-FIND(FIRST RowErrors
                WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2}
        RETURN NO-APPLY.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSituacao wWindow 
FUNCTION fnSituacao RETURNS CHARACTER
  ( pi-num-carg AS INT, INPUT pi-cdn-pesagem AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-idi-aprova AS INTEGER     NO-UNDO.

    RUN buscaSituacaoPesagem IN h-boin00982(INPUT pi-num-carg, 
                                            INPUT pi-cdn-pesagem, 
                                            OUTPUT i-idi-aprova).
    IF i-idi-aprova > 0 THEN
        RETURN {ininc/i01in00982.i 04 i-idi-aprova}.
    ELSE RETURN ''.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

