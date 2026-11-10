&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttUnidNegocHist NO-UNDO LIKE mab-unid-negoc-histor-ativid
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0138L 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i AB0138L MAB}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{cdp/cdcfgmnt.i} /*Versäes EMS MNT*/
{cdp/cd9911.i}   /*Unidade Neg¢cio*/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0138L
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Unid Negoc

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp 
&GLOBAL-DEFINE page1Widgets   brUnNegoc
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-ep-codigo    LIKE mab-eqpto.ep-codigo            NO-UNDO.
DEFINE INPUT PARAMETER p-cod-eqpto    LIKE mab-eqpto.cod-eqpto            NO-UNDO.
DEFINE INPUT PARAMETER p-dat-cadastro LIKE mab-histor-ativid.dat-cadastro NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hDBOUnidNegocHist AS HANDLE NO-UNDO.    
DEFINE VARIABLE hDBOEqpto         AS HANDLE NO-UNDO.

DEFINE VARIABLE c-cod-estabel     LIKE mab-eqpto.cod-estabel                            NO-UNDO.
DEFINE VARIABLE c-cod-unid-negoc  LIKE mab-unid-negoc-histor-ativid.cod-unid-negoc      NO-UNDO.
&IF DEFINED(bf_mnt_ems206b) &THEN
    DEFINE VARIABLE c-des-unid-negoc  LIKE unid-negoc.des-unid-negoc                    NO-UNDO.
&ELSE
    DEFINE VARIABLE c-des-unid-negoc  AS CHARACTER                                      NO-UNDO.
&ENDIF

DEFINE VARIABLE perc-unid-negoc   LIKE mab-unid-negoc-histor-ativid.val-perc-unid-negoc NO-UNDO.
DEFINE VARIABLE l-erro            AS LOGICAL INITIAL NO                                 NO-UNDO.
DEFINE VARIABLE l-habilita        AS LOGICAL INITIAL NO                                 NO-UNDO.

DEFINE BUFFER bf-ttUnidNegocHist FOR ttUnidNegocHist.
DEFINE BUFFER bf-UnidNegocHistor FOR mab-unid-negoc-histor-ativid.

{frbo/bofr133.i ttUnidNegocHistAux}

/* Temp-table Definitions ---                                           */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brUnNegoc

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttUnidNegocHist

/* Definitions for BROWSE brUnNegoc                                     */
&Scoped-define FIELDS-IN-QUERY-brUnNegoc ttUnidNegocHist.cod-unid-negoc fnDescUnidNegocOM (ttUnidNegocHist.cod-unid-negoc) @ c-des-unid-negoc ttUnidNegocHist.val-perc-unid-negoc   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brUnNegoc   
&Scoped-define SELF-NAME brUnNegoc
&Scoped-define QUERY-STRING-brUnNegoc FOR EACH ttUnidNegocHist NO-LOCK
&Scoped-define OPEN-QUERY-brUnNegoc OPEN QUERY {&SELF-NAME} FOR EACH ttUnidNegocHist NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brUnNegoc ttUnidNegocHist
&Scoped-define FIRST-TABLE-IN-QUERY-brUnNegoc ttUnidNegocHist


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brUnNegoc}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ep-codigo cod-eqpto c-desc-eqpto ~
dat-cadastro btOK btCancel btHelp RECT-9 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS ep-codigo cod-eqpto c-desc-eqpto ~
dat-cadastro 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescUnidNegocOM wWindow 
FUNCTION fnDescUnidNegocOM RETURNS CHARACTER
  ( INPUT pcod-unid-negoc AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-desc-eqpto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE cod-eqpto LIKE ttUnidNegocHist.cod-eqpto
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE dat-cadastro LIKE ttUnidNegocHist.dat-cadastro
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE ep-codigo LIKE ttUnidNegocHist.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.43 BY 3.54.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btAddSon1 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btEliminar 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btModificar 
     LABEL "&Modificar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brUnNegoc FOR 
      ttUnidNegocHist SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brUnNegoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brUnNegoc wWindow _FREEFORM
  QUERY brUnNegoc DISPLAY
      ttUnidNegocHist.cod-unid-negoc 
fnDescUnidNegocOM (ttUnidNegocHist.cod-unid-negoc) @ c-des-unid-negoc
ttUnidNegocHist.val-perc-unid-negoc
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 68 BY 7
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ep-codigo AT ROW 1.5 COL 22 COLON-ALIGNED HELP
          "C¢digo Empresa Equipamento"
     cod-eqpto AT ROW 2.5 COL 22 COLON-ALIGNED HELP
          "C¢digo do Equipamento"
     c-desc-eqpto AT ROW 2.5 COL 39 COLON-ALIGNED NO-LABEL
     dat-cadastro AT ROW 3.5 COL 22 COLON-ALIGNED HELP
          "Data do Cadastro"
     btOK AT ROW 15.96 COL 1.86
     btCancel AT ROW 15.96 COL 12.72
     btHelp AT ROW 15.92 COL 79.86
     RECT-9 AT ROW 1.21 COL 1.72
     rtToolBar AT ROW 15.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.13
         FONT 1.

DEFINE FRAME fPage1
     brUnNegoc AT ROW 1.5 COL 7
     btAddSon1 AT ROW 8.5 COL 7
     btModificar AT ROW 8.5 COL 17
     btEliminar AT ROW 8.5 COL 27
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4.14 ROW 6.21
         SIZE 84.43 BY 8.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttUnidNegocHist T "?" NO-UNDO mgfro mab-unid-negoc-histor-ativid
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
         TITLE              = "Manuten‡Æo Matriz Unidade Neg¢cio Ordem de Manuten‡Æo"
         HEIGHT             = 16.17
         WIDTH              = 90
         MAX-HEIGHT         = 39.54
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.54
         VIRTUAL-WIDTH      = 182.86
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
{btb/btb008za.i0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN cod-eqpto IN FRAME fpage0
   LIKE = Temp-Tables.ttUnidNegocHist. EXP-SIZE                         */
/* SETTINGS FOR FILL-IN dat-cadastro IN FRAME fpage0
   LIKE = Temp-Tables.ttUnidNegocHist.                                  */
/* SETTINGS FOR FILL-IN ep-codigo IN FRAME fpage0
   LIKE = Temp-Tables.ttUnidNegocHist.ep-codigo                         */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brUnNegoc 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brUnNegoc
/* Query rebuild information for BROWSE brUnNegoc
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttUnidNegocHist NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brUnNegoc */
&ANALYZE-RESUME

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
ON END-ERROR OF wWindow /* Manuten‡Æo Matriz Unidade Neg¢cio Ordem de Manuten‡Æo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Manuten‡Æo Matriz Unidade Neg¢cio Ordem de Manuten‡Æo */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "choose":U TO btCancel IN FRAME fPAGE0.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brUnNegoc
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brUnNegoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brUnNegoc wWindow
ON MOUSE-SELECT-DBLCLICK OF brUnNegoc IN FRAME fPage1
DO:    
    IF l-habilita AND AVAIL ttUnidNegocHist THEN DO:
        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        RUN abp/ab0138m.w (INPUT p-ep-codigo,
                           INPUT p-cod-eqpto,
                           INPUT p-dat-cadastro,
                           INPUT ttUnidNegocHist.cod-unid-negoc,
                           INPUT ttUnidNegocHist.val-perc-unid-negoc,
                           INPUT "UPDATE":U,
                           INPUT-OUTPUT TABLE ttUnidNegocHist).
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

        RUN OpenQueryBrowse IN THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wWindow
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN abp/ab0138m.w (INPUT p-ep-codigo,
                       INPUT p-cod-eqpto,
                       INPUT p-dat-cadastro,
                       INPUT "",
                       INPUT 0,
                       INPUT "ADD",
                       INPUT-OUTPUT TABLE ttUnidNegocHist).
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    RUN OpenQueryBrowse IN THIS-PROCEDURE.
    APPLY "ENTRY":U TO btAddSon1 IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btEliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEliminar wWindow
ON CHOOSE OF btEliminar IN FRAME fPage1 /* Eliminar */
DO:
    IF NUM-RESULTS("brUnNegoc":U) > 0 THEN
        RUN validaDelete IN THIS-PROCEDURE.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btModificar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModificar wWindow
ON CHOOSE OF btModificar IN FRAME fPage1 /* Modificar */
DO:
    IF AVAIL ttUnidNegocHist THEN DO:
        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        RUN abp/ab0138m.w (INPUT p-ep-codigo,
                           INPUT p-cod-eqpto,
                           INPUT p-dat-cadastro,
                           INPUT ttUnidNegocHist.cod-unid-negoc,
                           INPUT ttUnidNegocHist.val-perc-unid-negoc,
                           INPUT "UPDATE":U,
                           INPUT-OUTPUT TABLE ttUnidNegocHist).
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

        RUN OpenQueryBrowse IN THIS-PROCEDURE.
        APPLY "ENTRY":U TO btModificar IN FRAME fPage1.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    /** Deixa manutenir somente se ultimo historico selecionado **/
    IF l-habilita THEN DO:
        IF NUM-RESULTS("brUnNegoc":U) > 0 THEN
            RUN validaPercentual IN hDBOUnidNegocHist (INPUT TABLE ttUnidNegocHist,
                                                       OUTPUT l-erro).
        IF NOT l-erro THEN DO:
            RUN gravaRegistro IN THIS-PROCEDURE.
            APPLY "CLOSE":U   TO THIS-PROCEDURE.
        END.
        ELSE DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 35861,
                               INPUT "":U).
        END.
    END.
    ELSE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(hDBOEqpto) THEN
        RUN destroy IN hDBOEqpto.

    IF VALID-HANDLE(hDBOUnidNegocHist) THEN
        RUN destroy IN hDBOUnidNegocHist.

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
    {utp/ut-liter.i Descri‡Æo *}
    ASSIGN c-des-unid-negoc:LABEL IN BROWSE brUnNegoc = RETURN-VALUE.
    {utp/ut-liter.i %Unid_Negoc *}
    ASSIGN ttUnidNegocHist.val-perc-unid-negoc:LABEL IN BROWSE brUnNegoc = RETURN-VALUE.

    ASSIGN cod-eqpto    = p-cod-eqpto
           ep-codigo    = p-ep-codigo
           dat-cadastro = p-dat-cadastro.

    RUN buscaModelo IN hDBOEqpto (INPUT p-ep-codigo,
                                  INPUT p-cod-eqpto,
                                  OUTPUT c-desc-eqpto).

    DISP ep-codigo cod-eqpto c-desc-eqpto dat-cadastro WITH FRAME fPage0.

    RUN carregaTT IN hDBOUnidNegocHist (INPUT p-ep-codigo,
                                        INPUT p-cod-eqpto,
                                        INPUT p-dat-cadastro,
                                        OUTPUT TABLE ttUnidNegocHist).

    /** Verifica se hist¢rico selecionado, ‚ o mais recente do equipamento. **/
    RUN validaUltimoHistorico IN hDBOUnidNegocHist (INPUT p-ep-codigo,
                                                    INPUT p-cod-eqpto,
                                                    INPUT p-dat-cadastro,
                                                    OUTPUT l-habilita).

    /** Habilita botäes do browse caso hist¢rico selecionado seja o mais recente do
        equipamento. **/
    IF l-habilita THEN
        ENABLE btAddSon1 WITH FRAME fPage1.

    /*--- Atualiaza o browse ---*/
    RUN OpenQueryBrowse IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE (hDBOEqpto) THEN DO:
        {btb/btb008za.i1 frbo/bofr007.p}
        {btb/btb008za.i2 frbo/bofr007.p '' hDBOEqpto}
    END.
    RUN openQueryStatic  IN hDBOEqpto (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE (hDBOUnidNegocHist) THEN DO:
        {btb/btb008za.i1 frbo/bofr133.p}                  
        {btb/btb008za.i2 frbo/bofr133.p '' hDBOUnidNegocHist}
    END.
    RUN openQueryStatic IN hDBOUnidNegocHist (INPUT "Main":U) NO-ERROR.

    RETURN "OK":U.                                     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaRegistros wWindow 
PROCEDURE eliminaRegistros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH  bf-UnidNegocHistor
        WHERE bf-UnidNegocHistor.ep-codigo    = p-ep-codigo
        AND   bf-UnidNegocHistor.cod-eqpto    = p-cod-eqpto
        AND   bf-UnidNegocHistor.dat-cadastro = p-dat-cadastro NO-LOCK:
        /** Verifica se algum registro foi eliminado **/
        IF NOT CAN-FIND(FIRST ttUnidNegocHist
                        WHERE ttUnidNegocHist.ep-codigo      = bf-UnidNegocHistor.ep-codigo
                        AND   ttUnidNegocHist.cod-eqpto      = bf-UnidNegocHistor.cod-eqpto
                        AND   ttUnidNegocHist.dat-cadastro   = bf-UnidNegocHistor.dat-cadastro 
                        AND   ttUnidNegocHist.cod-unid-negoc = bf-UnidNegocHistor.cod-unid-negoc NO-LOCK) THEN DO:
            /** Posiciona registro na BO **/
            RUN goToKey IN hDBOUnidNegocHist (INPUT bf-UnidNegocHistor.ep-codigo,
                                              INPUT bf-UnidNegocHistor.cod-eqpto,
                                              INPUT bf-UnidNegocHistor.dat-cadastro,
                                              INPUT bf-UnidNegocHistor.cod-unid-negoc).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN emptyRowErrors IN hDBOUnidNegocHist.
                RUN deleteRecord   IN hDBOUnidNegocHist.
                IF RETURN-VALUE = "NOK":U THEN DO:
                    /** Retorna a temp-table rowErrors com os erros da transa‡Æo **/
                    RUN getRowErrors IN hDBOUnidNegocHist (OUTPUT TABLE RowErrors).
                    /*--- Descri»’o dos erros:
                        3: Tabela {&TableLabel} n’o dispon­vel
                        10: Query esta posicionada no œltimo registro
                        8: Query esta vazia ---*/
                    FOR EACH RowErrors 
                        WHERE (RowErrors.ErrorType   = "INTERNAL":U) AND
                              (RowErrors.ErrorNumber = 3  OR
                               RowErrors.ErrorNumber = 10 OR
                               RowErrors.ErrorNumber = 8 ) EXCLUSIVE-LOCK:
                        DELETE RowErrors.
                    END.
                    IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
                        /** Inclui codigo da unidade negocio no erro **/
                        FOR EACH RowErrors:
                            ASSIGN RowErrors.errorDescription = RowErrors.errorDescription + " (":U + bf-UnidNegocHistor.cod-unid-negoc + ")":U.
                        END.
                        /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
                        {method/showmessage.i1}
                        {method/showmessage.i2 &Modal="Yes"}
                        {method/showmessage.i3}
                        RETURN "NOK":U.
                    END.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gravaRegistro wWindow 
PROCEDURE gravaRegistro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH  bf-ttUnidNegocHist NO-LOCK:

        EMPTY TEMP-TABLE ttUnidNegocHistAux.

        FOR FIRST ttUnidNegocHist
            WHERE ROWID(ttUnidNegocHist) = ROWID(bf-ttUnidNegocHist) NO-LOCK:
        END.
        RUN goToKey IN hDBOUnidNegocHist (INPUT ttUnidNegocHist.ep-codigo,
                                          INPUT ttUnidNegocHist.cod-eqpto,
                                          INPUT ttUnidNegocHist.dat-cadastro,
                                          INPUT ttUnidNegocHist.cod-unid-negoc).

        IF RETURN-VALUE = "OK":U THEN DO:
            /*--- Transfere temp-table ttUnidNegocHist para o DBO ---*/
            RUN getRecord      IN hDBOUnidNegocHist (OUTPUT TABLE ttUnidNegocHistAux).
            FOR FIRST ttUnidNegocHistAux:
                BUFFER-COPY ttUnidNegocHist TO ttUnidNegocHistAux.
            END.
            RUN setRecord      IN hDBOUnidNegocHist (INPUT TABLE ttUnidNegocHistAux).
            RUN emptyRowErrors IN hDBOUnidNegocHist.
            RUN updateRecord   IN hDBOUnidNegocHist.
        END.
        ELSE DO:
            CREATE ttUnidNegocHistAux.
            BUFFER-COPY ttUnidNegocHist TO ttUnidNegocHistAux.
            /*--- Transfere temp-table ttUnidNegocHist para o DBO ---*/
            RUN setRecord      IN hDBOUnidNegocHist (INPUT TABLE ttUnidNegocHistAux).
            RUN emptyRowErrors IN hDBOUnidNegocHist.
            RUN createRecord   IN hDBOUnidNegocHist.
        END.
        IF RETURN-VALUE = "NOK":U THEN DO:
            /** Retorna a temp-table rowErrors com os erros da transa‡Æo **/
            RUN getRowErrors IN hDBOUnidNegocHist (OUTPUT TABLE RowErrors).
            /** Inclui codigo da unidade negocio no erro **/
            FOR EACH RowErrors:
                ASSIGN RowErrors.errorDescription = RowErrors.errorDescription + " (":U + ttUnidNegocHist.cod-unid-negoc + ")":U.
            END.
            /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="Yes"}
            {method/showmessage.i3}
            RETURN "NOK":U.
        END.
    END.
    /** Elimina registros da "mab-unid-negoc-histor-ativid",
        caso houverem. **/
    RUN eliminaRegistros IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryBrowse wWindow 
PROCEDURE openQueryBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&OPEN-QUERY-brUnNegoc}

    /* Habilita / Desabilita botoes do browse, somente se o hist¢rico selecionado
    for o mais recente do equipamento. */
    IF l-habilita AND NUM-RESULTS("brUnNegoc":U) > 0
        THEN ENABLE  btModificar btEliminar WITH FRAME fPage1.
        ELSE DISABLE btModificar btEliminar WITH FRAME fPage1.

    RETURN "OK":U.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaDelete wWindow 
PROCEDURE validaDelete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    /** Tela de confirma‡Æo de delete **/
    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 550, INPUT "":U).

    IF RETURN-VALUE = "YES":U THEN DO:
        IF AVAIL ttUnidNegocHist THEN
            DELETE ttUnidNegocHist.

        /** Atualiza o Browse **/
        RUN OpenQueryBrowse IN THIS-PROCEDURE.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescUnidNegocOM wWindow 
FUNCTION fnDescUnidNegocOM RETURNS CHARACTER
  ( INPUT pcod-unid-negoc AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Retornar a descri‡Æo da Unidade de Neg¢cio referente a Ordem de Manuten‡Æo
    Notes:  pcod-unid-negoc - C¢digo da Unidade de Neg¢cio
------------------------------------------------------------------------------*/

    &IF DEFINED(bf_mnt_ems206b) &THEN
        FIND FIRST unid-negoc NO-LOCK
            WHERE unid-negoc.cod-unid-negoc = pcod-unid-negoc NO-ERROR.
        
        ASSIGN c-des-unid-negoc = IF AVAIL unid-negoc THEN unid-negoc.des-unid-negoc ELSE "":U.
    &ENDIF
                                                                                          
    RETURN c-des-unid-negoc.   /** Function return value. **/
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

